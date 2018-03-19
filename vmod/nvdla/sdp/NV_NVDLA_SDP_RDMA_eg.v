// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_RDMA_eg.v

#include "NV_NVDLA_SDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_RDMA_eg (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,pwrbus_ram_pd           //|< i
  ,op_load                 //|< i
  ,eg_done                 //|> o
  ,cq2eg_pd                //|< i
  ,cq2eg_pvld              //|< i
  ,cq2eg_prdy              //|> o
  ,lat_fifo_rd_pd          //|< i
  ,lat_fifo_rd_pvld        //|< i
  ,lat_fifo_rd_prdy        //|> o
  ,dma_rd_cdt_lat_fifo_pop //|> o
  ,sdp_rdma2dp_alu_pd      //|> o
  ,sdp_rdma2dp_alu_valid   //|> o
  ,sdp_rdma2dp_alu_ready   //|< i
  ,sdp_rdma2dp_mul_pd      //|> o
  ,sdp_rdma2dp_mul_valid   //|> o
  ,sdp_rdma2dp_mul_ready   //|< i
  ,reg2dp_batch_number     //|< i
  ,reg2dp_channel          //|< i
  ,reg2dp_height           //|< i
  ,reg2dp_width            //|< i
  ,reg2dp_proc_precision   //|< i
  ,reg2dp_out_precision    //|< i
  ,reg2dp_rdma_data_mode   //|< i
  ,reg2dp_rdma_data_size   //|< i
  ,reg2dp_rdma_data_use    //|< i
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input   [31:0] pwrbus_ram_pd;
input          op_load;
output         eg_done;
input   [15:0] cq2eg_pd;
input          cq2eg_pvld;
output         cq2eg_prdy;
input  [NVDLA_DMA_RD_RSP-1:0] lat_fifo_rd_pd;
input          lat_fifo_rd_pvld;
output         lat_fifo_rd_prdy;
output         dma_rd_cdt_lat_fifo_pop;
output [AM_DW2:0] sdp_rdma2dp_alu_pd;
output         sdp_rdma2dp_alu_valid;
input          sdp_rdma2dp_alu_ready;
output [AM_DW2:0] sdp_rdma2dp_mul_pd;
output         sdp_rdma2dp_mul_valid;
input          sdp_rdma2dp_mul_ready;
input    [4:0] reg2dp_batch_number;
input   [12:0] reg2dp_channel;
input   [12:0] reg2dp_height;
input   [12:0] reg2dp_width;
input    [1:0] reg2dp_proc_precision;
input    [1:0] reg2dp_out_precision;
input          reg2dp_rdma_data_mode;
input          reg2dp_rdma_data_size;
input    [1:0] reg2dp_rdma_data_use;

wire           cfg_alu_en;
wire           cfg_mul_en;
wire           cfg_do_8;
wire           cfg_dp_8;
wire           cfg_data_size_1byte;
wire           cfg_data_size_2byte;
wire           cfg_mode_1bytex1;
wire           cfg_mode_1bytex2;
wire           cfg_mode_2bytex1;
wire           cfg_mode_2bytex2;
wire           cfg_mode_alu_only;
wire           cfg_mode_both;
wire           cfg_mode_mul_only;
wire           cfg_mode_per_element;
wire           cfg_mode_single;

reg            cq2eg_prdy_hold;
wire           ig2eg_cube_end;
wire    [14:0] ig2eg_size;
wire    [15:0] beat_size;
reg     [14:0] beat_count;
wire    [15:0] beat_count_nxt;
reg            mon_beat_count;
wire           is_last_beat;
wire           is_beat_end;
wire           layer_done;
wire           mul_layer_end;
wire           mul_roc_rdy;
wire           mul_roc_vld;
wire           mul_rod_rdy;
wire           mul_rod_vld;
reg            alu_layer_done;
reg            alu_roc_en;
reg            eg_done;
reg            mul_layer_done;
reg            mul_roc_en;
wire           alu_layer_end;
wire           alu_roc_rdy;
wire           alu_roc_vld;
wire           alu_rod_rdy;
wire           alu_rod_vld;
wire    [4*AM_DW+3:0]  unpack_out_pd;
wire           unpack_out_pvld; 
wire           unpack_out_prdy; 
wire  [AM_DW-1:0]  mode_1bytex2_alu_rod0_pd;
wire  [AM_DW-1:0]  mode_1bytex2_alu_rod1_pd;
wire  [AM_DW-1:0]  mode_2bytex2_alu_rod0_pd;
wire  [AM_DW-1:0]  mode_2bytex2_alu_rod1_pd;
wire  [AM_DW-1:0]  mode_1bytex2_mul_rod0_pd;
wire  [AM_DW-1:0]  mode_1bytex2_mul_rod1_pd;
wire  [AM_DW-1:0]  mode_2bytex2_mul_rod0_pd;
wire  [AM_DW-1:0]  mode_2bytex2_mul_rod1_pd;
                                

//==============
// CFG REG
//==============
assign cfg_data_size_1byte = reg2dp_rdma_data_size == 1'h0 ;
assign cfg_data_size_2byte = reg2dp_rdma_data_size == 1'h1 ;

assign cfg_mode_mul_only  = reg2dp_rdma_data_use == 2'h0 ;
assign cfg_mode_alu_only  = reg2dp_rdma_data_use == 2'h1 ;
assign cfg_mode_both      = reg2dp_rdma_data_use == 2'h2 ;
assign cfg_mode_per_element  = reg2dp_rdma_data_mode == 1'h1 ;

assign cfg_mode_single = cfg_mode_mul_only || cfg_mode_alu_only;

assign cfg_mode_1bytex1 = cfg_data_size_1byte & cfg_mode_single;
assign cfg_mode_2bytex1 = cfg_data_size_2byte & cfg_mode_single;
assign cfg_mode_1bytex2 = cfg_data_size_1byte & cfg_mode_both;
assign cfg_mode_2bytex2 = cfg_data_size_2byte & cfg_mode_both;
#ifdef NVDLA_BATCH_ENABLE
wire   cfg_mode_multi_batch = reg2dp_batch_number!=0;
#endif
assign cfg_dp_8 = reg2dp_proc_precision== 0 ;
assign cfg_do_8 = reg2dp_out_precision== 0 ;

assign cfg_alu_en = cfg_mode_alu_only || cfg_mode_both;
assign cfg_mul_en = cfg_mode_mul_only || cfg_mode_both;


//==============
// DMA Interface
//==============
assign dma_rd_cdt_lat_fifo_pop = lat_fifo_rd_pvld & lat_fifo_rd_prdy;

//==============
// Latency FIFO to buffer return DATA
//==============
wire [3:0]  lat_fifo_rd_mask = {{(4-NVDLA_DMA_MASK_BIT){1'b0}},lat_fifo_rd_pd[NVDLA_DMA_RD_RSP-1:NVDLA_MEMIF_WIDTH]};
wire [2:0]  lat_fifo_rd_size = lat_fifo_rd_mask[3]+lat_fifo_rd_mask[2]+lat_fifo_rd_mask[1]+lat_fifo_rd_mask[0];


//==================================================================
// Context Queue: read
//==================================================================
assign   cq2eg_prdy  = is_beat_end;

assign   ig2eg_size[14:0] = cq2eg_pd[14:0];
assign   ig2eg_cube_end   = cq2eg_pd[15];

assign   beat_size = ig2eg_size+1; 
assign   beat_count_nxt = beat_count+lat_fifo_rd_size;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
      {mon_beat_count,beat_count} <= 16'h0;
  end else begin
    if (lat_fifo_rd_pvld & lat_fifo_rd_prdy) begin
        if (is_last_beat) begin
           {mon_beat_count,beat_count} <= 16'h0;
        end else begin
           {mon_beat_count,beat_count} <= beat_count_nxt;
        end
    end
  end
end
assign is_last_beat = (beat_count_nxt == beat_size);
assign is_beat_end  = is_last_beat & lat_fifo_rd_pvld & lat_fifo_rd_prdy;


`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"info in CQ there be there when return data come")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, (!cq2eg_pvld) & lat_fifo_rd_pvld); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON



/////////combine lat fifo pd to 4*atomic_m*bpe//////
wire  lat_fifo_rd_beat_end = is_last_beat;

NV_NVDLA_SDP_RDMA_unpack  u_rdma_unpack (
   .nvdla_core_clk        (nvdla_core_clk)                
  ,.nvdla_core_rstn       (nvdla_core_rstn)                      
  ,.inp_data              (lat_fifo_rd_pd[NVDLA_DMA_RD_RSP-1:0])        
  ,.inp_pvld              (lat_fifo_rd_pvld)                     
  ,.inp_prdy              (lat_fifo_rd_prdy)                     
  ,.inp_end               (lat_fifo_rd_beat_end)                     
  ,.out_data              (unpack_out_pd[4*AM_DW+3:0])  
  ,.out_pvld              (unpack_out_pvld)                
  ,.out_prdy              (unpack_out_prdy)                
  );

wire  [3:0] unpack_out_mask = unpack_out_pd[4*AM_DW+3:4*AM_DW];
assign      unpack_out_prdy = cfg_mode_both ? alu_rod_rdy & mul_rod_rdy : cfg_mode_alu_only ? alu_rod_rdy : mul_rod_rdy; 

//============================================================
// Re-Order FIFO to send data to SDP-core               
//============================================================
//      |----------------------------------------------------|
//      |    16B     |    16B     |    16B     |     16B     |
// MODE |----------------------------------------------------|
//      |     0            1            2            3       |
// 1Bx1 | ALU or MUL | ALU or MUL | ALU or MUL or ALU or MUL |
//      |----------------------------------------------------|
//      |            0            |            1             |
// 2Bx1 |        ALU or MUL       |        ALU or MUL        |
//      |====================================================|
//      |            0            |            1             |
// 1Bx2 |    ALU     |    MUL     |    ALU     |     MUL     |
//      |----------------------------------------------------|
//      |            0            |            1             |
// 2Bx2 |           ALU           |           MUL            |
//      |----------------------------------------------------|
//============================================================

//: my $k = NVDLA_MEMORY_ATOMIC_SIZE;
//: foreach my $i  (0..${k}-1) {
//: my $j  = ${i}*2;
//: print "assign  mode_1bytex2_alu_rod0_pd[8*${i}+7:8*${i}] = unpack_out_pd[8*${j}+7: 8*${j}]; \n";
//: }
//: print "\n";
//: foreach my $i  (0..${k}-1) {
//: my $jj = ${i}*2+$k*2;
//: print "assign  mode_1bytex2_alu_rod1_pd[8*${i}+7:8*${i}] = unpack_out_pd[8*${jj}+7: 8*${jj}]; \n";
//: }
//: print "\n";
//: foreach my $i  (0..${k}/2-1) {
//: my $j  = ${i}*2;
//: print "assign  mode_2bytex2_alu_rod0_pd[16*${i}+15:16*${i}] = unpack_out_pd[16*${j}+15: 16*${j}]; \n";
//: }
//: print "\n";
//: foreach my $i  (0..${k}/2-1) {
//: my $jj = ${i}*2+$k;
//: print "assign  mode_2bytex2_alu_rod1_pd[16*${i}+15:16*${i}] = unpack_out_pd[16*${jj}+15: 16*${jj}]; \n";
//: }
//: print "\n";
//: foreach my $i  (0..${k}-1) {
//: my $j  = ${i}*2+1;
//: print "assign  mode_1bytex2_mul_rod0_pd[8*${i}+7:8*${i}] = unpack_out_pd[8*${j}+7: 8*${j}]; \n";
//: }
//: print "\n";
//: foreach my $i  (0..${k}-1) {
//: my $jj = ${i}*2+1+$k*2;
//: print "assign  mode_1bytex2_mul_rod1_pd[8*${i}+7:8*${i}] = unpack_out_pd[8*${jj}+7: 8*${jj}]; \n";
//: }
//: print "\n";
//: foreach my $i  (0..${k}/2-1) {
//: my $j  = ${i}*2+1;
//: print "assign  mode_2bytex2_mul_rod0_pd[16*${i}+15:16*${i}] = unpack_out_pd[16*${j}+15: 16*${j}]; \n";
//: }
//: print "\n";
//: foreach my $i  (0..${k}/2-1) {
//: my $jj = ${i}*2+1+$k;
//: print "assign  mode_2bytex2_mul_rod1_pd[16*${i}+15:16*${i}] = unpack_out_pd[16*${jj}+15: 16*${jj}]; \n";
//: }
//: print "\n";


wire  [AM_DW-1:0]  alu_rod0_pd = cfg_mode_2bytex2 ? mode_2bytex2_alu_rod0_pd : cfg_mode_1bytex2 ? mode_1bytex2_alu_rod0_pd : unpack_out_pd[(AM_DW*0+AM_DW-1):AM_DW*0];
wire  [AM_DW-1:0]  alu_rod1_pd = cfg_mode_2bytex2 ? mode_2bytex2_alu_rod1_pd : cfg_mode_1bytex2 ? mode_1bytex2_alu_rod1_pd : unpack_out_pd[(AM_DW*1+AM_DW-1):AM_DW*1];
wire  [AM_DW-1:0]  alu_rod2_pd = unpack_out_pd[(AM_DW*2+AM_DW-1):AM_DW*2];
wire  [AM_DW-1:0]  alu_rod3_pd = unpack_out_pd[(AM_DW*3+AM_DW-1):AM_DW*3];

wire  [AM_DW-1:0]  mul_rod0_pd = cfg_mode_2bytex2 ? mode_2bytex2_mul_rod0_pd : cfg_mode_1bytex2 ? mode_1bytex2_mul_rod0_pd : unpack_out_pd[(AM_DW*0+AM_DW-1):AM_DW*0];
wire  [AM_DW-1:0]  mul_rod1_pd = cfg_mode_2bytex2 ? mode_2bytex2_mul_rod1_pd : cfg_mode_1bytex2 ? mode_1bytex2_mul_rod1_pd : unpack_out_pd[(AM_DW*1+AM_DW-1):AM_DW*1];
wire  [AM_DW-1:0]  mul_rod2_pd = unpack_out_pd[(AM_DW*2+AM_DW-1):AM_DW*2];
wire  [AM_DW-1:0]  mul_rod3_pd = unpack_out_pd[(AM_DW*3+AM_DW-1):AM_DW*3];

wire  [3:0]  alu_rod_mask = cfg_mode_both ? {2'h0,unpack_out_mask[2],unpack_out_mask[0]} : unpack_out_mask[3:0];
wire  [3:0]  mul_rod_mask = cfg_mode_both ? {2'h0,unpack_out_mask[2],unpack_out_mask[0]} : unpack_out_mask[3:0];

wire  [2:0]  alu_roc_size = alu_rod_mask[3] + alu_rod_mask[2] + alu_rod_mask[1] + alu_rod_mask[0];
wire  [2:0]  mul_roc_size = mul_rod_mask[3] + mul_rod_mask[2] + mul_rod_mask[1] + mul_rod_mask[0];

assign  alu_rod_vld = cfg_alu_en & unpack_out_pvld & (cfg_mode_both ? mul_rod_rdy : 1'b1);
assign  mul_rod_vld = cfg_mul_en & unpack_out_pvld & (cfg_mode_both ? alu_rod_rdy : 1'b1);

assign  alu_roc_vld = cfg_alu_en & unpack_out_pvld & (cfg_mode_both ? mul_roc_rdy & mul_rod_rdy & alu_rod_rdy : alu_rod_rdy);
assign  mul_roc_vld = cfg_mul_en & unpack_out_pvld & (cfg_mode_both ? alu_roc_rdy & mul_rod_rdy & alu_rod_rdy : mul_rod_rdy);

wire  [1:0]  alu_roc_pd,mul_roc_pd;
wire         mon_alu_roc_c,mon_mul_roc_c;
assign {mon_alu_roc_c,alu_roc_pd} = alu_roc_size -1;
assign {mon_mul_roc_c,mul_roc_pd} = mul_roc_size -1;

//assert: alu_rod_vld & !alu_roc_rdy

////////////////split unpack pd to 4 atomic_m alu or mul data /////////////////////
NV_NVDLA_SDP_RDMA_EG_ro u_alu (
   .nvdla_core_clk       (nvdla_core_clk)             
  ,.nvdla_core_rstn      (nvdla_core_rstn)            
  ,.pwrbus_ram_pd        (pwrbus_ram_pd)
  ,.sdp_rdma2dp_valid    (sdp_rdma2dp_alu_valid)     
  ,.sdp_rdma2dp_ready    (sdp_rdma2dp_alu_ready)     
  ,.sdp_rdma2dp_pd       (sdp_rdma2dp_alu_pd[AM_DW2:0]) 
  ,.rod0_wr_pd           (alu_rod0_pd[AM_DW-1:0])       
  ,.rod1_wr_pd           (alu_rod1_pd[AM_DW-1:0])       
  ,.rod2_wr_pd           (alu_rod2_pd[AM_DW-1:0])       
  ,.rod3_wr_pd           (alu_rod3_pd[AM_DW-1:0])       
  ,.rod_wr_mask          (alu_rod_mask[3:0])         
  ,.rod_wr_vld           (alu_rod_vld)               
  ,.rod_wr_rdy           (alu_rod_rdy)               
  ,.roc_wr_pd            (alu_roc_pd[1:0])           
  ,.roc_wr_vld           (alu_roc_vld)               
  ,.roc_wr_rdy           (alu_roc_rdy)               
  ,.cfg_dp_8             (cfg_dp_8)                  
  ,.cfg_dp_size_1byte    (cfg_data_size_1byte)                  
  ,.cfg_mode_per_element (cfg_mode_per_element)      
  #ifdef NVDLA_BATCH_ENABLE
  ,.cfg_mode_multi_batch (cfg_mode_multi_batch)      
  ,.reg2dp_batch_number  (reg2dp_batch_number[4:0])  
  #endif
  ,.reg2dp_channel       (reg2dp_channel[12:0])      
  ,.reg2dp_height        (reg2dp_height[12:0])       
  ,.reg2dp_width         (reg2dp_width[12:0])        
  ,.layer_end            (alu_layer_end)             
  );


NV_NVDLA_SDP_RDMA_EG_ro u_mul (
   .nvdla_core_clk       (nvdla_core_clk)            
  ,.nvdla_core_rstn      (nvdla_core_rstn)           
  ,.pwrbus_ram_pd        (pwrbus_ram_pd)
  ,.sdp_rdma2dp_valid    (sdp_rdma2dp_mul_valid)    
  ,.sdp_rdma2dp_ready    (sdp_rdma2dp_mul_ready)    
  ,.sdp_rdma2dp_pd       (sdp_rdma2dp_mul_pd[AM_DW2:0]) 
  ,.rod0_wr_pd           (mul_rod0_pd[AM_DW-1:0])    
  ,.rod1_wr_pd           (mul_rod1_pd[AM_DW-1:0])    
  ,.rod2_wr_pd           (mul_rod2_pd[AM_DW-1:0])    
  ,.rod3_wr_pd           (mul_rod3_pd[AM_DW-1:0])    
  ,.rod_wr_mask          (mul_rod_mask[3:0])         
  ,.rod_wr_vld           (mul_rod_vld)               
  ,.rod_wr_rdy           (mul_rod_rdy)               
  ,.roc_wr_pd            (mul_roc_pd[1:0])           
  ,.roc_wr_vld           (mul_roc_vld)               
  ,.roc_wr_rdy           (mul_roc_rdy)               
  ,.cfg_dp_8             (cfg_dp_8)                  
  ,.cfg_dp_size_1byte    (cfg_data_size_1byte)                  
  ,.cfg_mode_per_element (cfg_mode_per_element)      
  #ifdef NVDLA_BATCH_ENABLE
  ,.cfg_mode_multi_batch (cfg_mode_multi_batch)      
  ,.reg2dp_batch_number  (reg2dp_batch_number[4:0])  
  #endif
  ,.reg2dp_channel       (reg2dp_channel[12:0])      
  ,.reg2dp_height        (reg2dp_height[12:0])       
  ,.reg2dp_width         (reg2dp_width[12:0])        
  ,.layer_end            (mul_layer_end)             
  );



//==========================================================
// Layer Done
//==========================================================
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    alu_layer_done <= 1'b0;
  end else begin
    if (op_load) begin
        if (cfg_alu_en) begin
            alu_layer_done <= 1'b0;
        end else begin
            alu_layer_done <= 1'b1;
        end
    end else if (alu_layer_end) begin
        alu_layer_done <= 1'b1;
    end else if (layer_done) begin
        alu_layer_done <= 1'b0;
    end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mul_layer_done <= 1'b0;
  end else begin
    if (op_load) begin
        if (cfg_mul_en) begin
            mul_layer_done <= 1'b0;
        end else begin
            mul_layer_done <= 1'b1;
        end
    end else if (mul_layer_end) begin
        mul_layer_done <= 1'b1;
    end else if (layer_done) begin
        mul_layer_done <= 1'b0;
    end
  end
end

assign layer_done = alu_layer_done & mul_layer_done;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    eg_done <= 1'b0;
  end else begin
  eg_done <= layer_done;
  end
end


endmodule // NV_NVDLA_SDP_RDMA_eg


