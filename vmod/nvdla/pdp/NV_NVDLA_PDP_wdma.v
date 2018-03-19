// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_wdma.v

#include "NV_NVDLA_PDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_PDP_wdma (
   nvdla_core_clk                 //|< i
  ,nvdla_core_clk_orig            //|< i
  ,nvdla_core_rstn                //|< i

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2pdp_wr_rsp_complete       //|< i
  ,pdp2cvif_wr_req_pd             //|> o
  ,pdp2cvif_wr_req_valid          //|> o
  ,pdp2cvif_wr_req_ready          //|< i
#endif
  ,mcif2pdp_wr_rsp_complete       //|< i
  ,pdp2mcif_wr_req_ready          //|< i
  ,pdp_dp2wdma_pd                 //|< i
  ,pdp_dp2wdma_valid              //|< i
  ,pwrbus_ram_pd                  //|< i
  ,rdma2wdma_done                 //|< i
  ,reg2dp_cube_out_channel        //|< i
  ,reg2dp_cube_out_height         //|< i
  ,reg2dp_cube_out_width          //|< i
  ,reg2dp_dma_en                  //|< i
  ,reg2dp_dst_base_addr_high      //|< i
  ,reg2dp_dst_base_addr_low       //|< i
  ,reg2dp_dst_line_stride         //|< i
  ,reg2dp_dst_ram_type            //|< i
  ,reg2dp_dst_surface_stride      //|< i
  ,reg2dp_flying_mode             //|< i
//  ,reg2dp_input_data              //|< i
  ,reg2dp_interrupt_ptr           //|< i
  ,reg2dp_op_en                   //|< i
  ,reg2dp_partial_width_out_first //|< i
  ,reg2dp_partial_width_out_last  //|< i
  ,reg2dp_partial_width_out_mid   //|< i
  ,reg2dp_split_num               //|< i
  ,dp2reg_d0_perf_write_stall     //|> o
  ,dp2reg_d1_perf_write_stall     //|> o
  ,dp2reg_done                    //|> o
//  ,dp2reg_nan_output_num          //|> o
  ,pdp2glb_done_intr_pd           //|> o
  ,pdp2mcif_wr_req_pd             //|> o
  ,pdp2mcif_wr_req_valid          //|> o
  ,pdp_dp2wdma_ready              //|> o
  );
///////////////////////////////////////////////////////////////////////////////////////
//
// NV_NVDLA_PDP_wdma_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output         pdp2mcif_wr_req_valid;  /* data valid */
input          pdp2mcif_wr_req_ready;  /* data return handshake */
output [NVDLA_PDP_MEM_WR_REQ-1:0] pdp2mcif_wr_req_pd;

input  mcif2pdp_wr_rsp_complete;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output         pdp2cvif_wr_req_valid;
input          pdp2cvif_wr_req_ready;
output [NVDLA_PDP_MEM_WR_REQ-1:0] pdp2cvif_wr_req_pd;
input  cvif2pdp_wr_rsp_complete;
#endif

input         pdp_dp2wdma_valid;
output        pdp_dp2wdma_ready;
input  [NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT-1:0] pdp_dp2wdma_pd;

input [31:0] pwrbus_ram_pd;

output [1:0] pdp2glb_done_intr_pd;

input          rdma2wdma_done;
input   [12:0] reg2dp_cube_out_channel;
input   [12:0] reg2dp_cube_out_height;
input   [12:0] reg2dp_cube_out_width;
input          reg2dp_dma_en;
input   [31:0] reg2dp_dst_base_addr_high;
input   [31:0] reg2dp_dst_base_addr_low;
input   [31:0] reg2dp_dst_line_stride;
input          reg2dp_dst_ram_type;
input   [31:0] reg2dp_dst_surface_stride;
input          reg2dp_flying_mode;
//input    [1:0] reg2dp_input_data;
input          reg2dp_interrupt_ptr;
input          reg2dp_op_en;
input    [9:0] reg2dp_partial_width_out_first;
input    [9:0] reg2dp_partial_width_out_last;
input    [9:0] reg2dp_partial_width_out_mid;
input    [7:0] reg2dp_split_num;
output  [31:0] dp2reg_d0_perf_write_stall;
output  [31:0] dp2reg_d1_perf_write_stall;
output         dp2reg_done;
//output  [31:0] dp2reg_nan_output_num;
input   nvdla_core_clk_orig;
///////////////////////////////////////////////////////////////////////////////////////
reg            ack_bot_id;
reg            ack_bot_vld;
reg            ack_top_id;
reg            ack_top_vld;
reg            cmd_en;
reg     [12:0] cmd_fifo_rd_size_use;
reg     [12:0] count_w;
reg            cv_dma_wr_rsp_complete;
reg            cv_pending;
reg            dat0_fifo_rd_pvld;
reg            dat1_fifo_rd_pvld;
reg            dat_en;
reg    [NVDLA_PDP_MEM_WR_REQ-1:0] dma_wr_req_pd;
wire           dma_wr_rsp_complete;
reg     [31:0] dp2reg_d0_perf_write_stall;
reg     [31:0] dp2reg_d1_perf_write_stall;
//reg     [31:0] dp2reg_nan_output_num;
//reg     [63:0] dp2wdma_pd;
//reg            dp2wdma_vld;
//reg            fp16_en;
reg            intp_waiting_rdma;
reg            layer_flag;
reg            mc_dma_wr_rsp_complete;
reg            mc_pending;
reg            mcif2pdp_wr_rsp_complete_d1;
//reg            mon_nan_in_count;
//reg     [31:0] nan_in_count;
reg            op_prcess;
reg      [1:0] pdp2glb_done_intr_pd;
wire            pdp_dp2wdma_ready;
reg     [31:0] pdp_wr_stall_count;
reg            reading_done_flag;
reg            reg_cube_last;
reg      [4:0] reg_lenb;
reg     [12:0] reg_size;
reg            stl_adv;
reg     [31:0] stl_cnt_cur;
reg     [33:0] stl_cnt_dec;
reg     [33:0] stl_cnt_ext;
reg     [33:0] stl_cnt_inc;
reg     [33:0] stl_cnt_mod;
reg     [33:0] stl_cnt_new;
reg     [33:0] stl_cnt_nxt;
reg            waiting_rdma;
reg            wdma_done;
reg            wdma_done_d1;
wire           ack_bot_rdy;
wire           ack_raw_id;
wire           ack_raw_rdy;
wire           ack_raw_vld;
wire           ack_top_rdy;
wire    [63:0] cmd_fifo_rd_addr;
wire           cmd_fifo_rd_cube_end;
//wire     [4:0] cmd_fifo_rd_lenb;
wire    [79:0] cmd_fifo_rd_pd; //bw ?
wire           cmd_fifo_rd_prdy;
wire           cmd_fifo_rd_pvld;
wire    [12:0] cmd_fifo_rd_size;
wire           cnt_cen;
wire           cnt_clr;
wire           cnt_inc;
//: my $dmaifBW = NVDLA_PDP_DMAIF_BW;
//: my $atomicm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_PDP_BWPE;
//: my $pdpbw = NVDLA_PDP_THROUGHPUT*NVDLA_PDP_BWPE;
//: my $Wnum = int( $dmaifBW/$atomicm );
//: my $Bnum = int($atomicm/$pdpbw);
//:    foreach my $posw (0..$Wnum-1) { ##High...low atomic_m
//:      print "wire   [${pdpbw}*${Bnum}-1:0] dat${posw}_data; \n";
//:        foreach my $posb (0..$Bnum-1) { ##throughput in each atomic_m
//:            print qq(
//:            wire [${pdpbw}-1:0]dat${posw}_fifo${posb}_rd_pd;  
//:            wire   dat${posw}_fifo${posb}_rd_prdy;
//:            wire   dat${posw}_fifo${posb}_rd_pvld;
//:            );
//:        }
//:    }
wire           dat_accept;
wire   [NVDLA_PDP_DMAIF_BW-1:0] dat_data;
reg           dat_fifo_rd_last_pvld;
wire           dat_rdy;
wire           dma_wr_cmd_accept;
wire    [63:0] dma_wr_cmd_addr;
wire    [NVDLA_MEM_ADDRESS_WIDTH+13:0] dma_wr_cmd_pd;
wire           dma_wr_cmd_require_ack;
wire    [22:0] dma_wr_cmd_size;
wire           dma_wr_cmd_vld;
wire   [NVDLA_PDP_DMAIF_BW-1:0] dma_wr_dat_data;
wire     [1:0] dma_wr_dat_mask;
wire   [NVDLA_PDP_DMAIF_BW + NVDLA_PDP_MEM_MASK_BIT-1:0] dma_wr_dat_pd;
wire           dma_wr_dat_vld;
wire           dma_wr_req_rdy;
wire           dma_wr_req_type;
wire           dma_wr_req_vld;
wire           dp2wdma_rdy;
wire           intr_fifo_rd_pd;
wire           intr_fifo_rd_prdy;
wire           intr_fifo_rd_pvld;
wire           intr_fifo_wr_pd;
wire           intr_fifo_wr_pvld;
wire           is_last_beat;
wire           is_size_odd;
wire           off_fly_en;
wire           on_fly_en;
wire           op_done;
wire           op_load;
wire           pdp_wr_stall_count_dec;
wire           releasing;
wire           require_ack;
wire           wr_req_rdyi;
///////////////////////////////////////////////////////////////////////////////////////
//==============
// tracing rdma reading done to aviod layer switched but RDMA still reading the last layer
//==============
assign on_fly_en = reg2dp_flying_mode == 1'h0 ;
assign off_fly_en = reg2dp_flying_mode == 1'h1 ;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reading_done_flag <= 1'b0;
  end else begin
    if(op_done)
        reading_done_flag <= 1'b0;
    else if(rdma2wdma_done & off_fly_en)
        reading_done_flag <= 1'b1;
    else if(op_load & on_fly_en)
        reading_done_flag <= 1'b1;
    else if(op_load & off_fly_en)
        reading_done_flag <= 1'b0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    waiting_rdma <= 1'b0;
  end else begin
    if(op_done & (~reading_done_flag))//
        waiting_rdma <= 1'b1;
    else if(reading_done_flag)
        waiting_rdma <= 1'b0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wdma_done <= 1'b0;
  end else begin
    if(op_done & reading_done_flag)//normal case
        wdma_done <= 1'b1;
    else if(waiting_rdma & reading_done_flag)//waiting RDMA case
        wdma_done <= 1'b1;
    else
        wdma_done <= 1'b0;
  end
end
//==============
// Work Processing
//==============
assign op_load = reg2dp_op_en & !op_prcess;
assign op_done = reg_cube_last & is_last_beat & dat_accept;
assign dp2reg_done = wdma_done;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_prcess <= 1'b0;
  end else begin
    if (op_load) begin
        op_prcess <= 1'b1;
    end else if (wdma_done) begin
        op_prcess <= 1'b0;
    end
  end
end

//==============
// Data INPUT pipe and Unpack
//==============
//: my $k = NVDLA_PDP_THROUGHPUT*NVDLA_PDP_BWPE;
//: &eperl::pipe("-wid $k -is -do dp2wdma_pd -vo dp2wdma_vld -ri dp2wdma_rdy -di pdp_dp2wdma_pd -vi pdp_dp2wdma_valid -ro pdp_dp2wdma_ready_ff ");
assign pdp_dp2wdma_ready = pdp_dp2wdma_ready_ff;
//==============
// Instance CMD
//==============
NV_NVDLA_PDP_WDMA_dat u_dat (
   .reg2dp_cube_out_channel        (reg2dp_cube_out_channel[12:0])       
  ,.reg2dp_cube_out_height         (reg2dp_cube_out_height[12:0])        
  ,.reg2dp_cube_out_width          (reg2dp_cube_out_width[12:0])         
//  ,.reg2dp_input_data              (reg2dp_input_data[1:0])            
  ,.reg2dp_partial_width_out_first (reg2dp_partial_width_out_first[9:0]) 
  ,.reg2dp_partial_width_out_last  (reg2dp_partial_width_out_last[9:0])  
  ,.reg2dp_partial_width_out_mid   (reg2dp_partial_width_out_mid[9:0])   
  ,.reg2dp_split_num               (reg2dp_split_num[7:0])               
  ,.dp2wdma_pd                     (dp2wdma_pd)                    
  ,.dp2wdma_vld                    (dp2wdma_vld)                         
  ,.dp2wdma_rdy                    (dp2wdma_rdy)                         
  ,.nvdla_core_clk                 (nvdla_core_clk)                      
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 
//: my $dmaifBW = NVDLA_PDP_DMAIF_BW;
//: my $atomicm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_PDP_BWPE;
//: my $pdpbw = NVDLA_PDP_THROUGHPUT*NVDLA_PDP_BWPE;
//: my $Wnum = int( $dmaifBW/$atomicm );
//: my $Bnum = int($atomicm/$pdpbw);
//:    foreach my $posw (0..$Wnum-1) { ##High...low atomic_m
//:        foreach my $posb (0..$Bnum-1) { ##throughput in each atomic_m
//:            print qq(
//:            ,.dat${posw}_fifo${posb}_rd_pd   (dat${posw}_fifo${posb}_rd_pd   )  
//:            ,.dat${posw}_fifo${posb}_rd_prdy (dat${posw}_fifo${posb}_rd_prdy )
//:            ,.dat${posw}_fifo${posb}_rd_pvld (dat${posw}_fifo${posb}_rd_pvld )
//:            );
//:        }
//:    }
  ,.wdma_done                      (wdma_done)                           
  ,.op_load                        (op_load)                             
  );
/////////////////////////////////////////
// DATA FIFO: READ SIDE
//: my $dmaifBW = NVDLA_PDP_DMAIF_BW;
//: my $atomicm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_PDP_BWPE;
//: my $pdpbw = NVDLA_PDP_THROUGHPUT*NVDLA_PDP_BWPE;
//: my $Wnum = int( $dmaifBW/$atomicm );
//: my $Bnum = int($atomicm/$pdpbw);
//:         ##my $p = int( log(${Wnum}) / log(2) );
//:         print "reg  [${Wnum}-1:0] atomm_invld; \n";
//:    foreach my $posw (0..$Wnum-1) { ##High...low atomic_m
//:         print qq(
//:         always @(*) begin
//:           case (reg_lenb)
//:         );
//:           foreach my $posb (0..$Bnum-1) { ##throughput in each atomic_m
//:            print qq(
//:               5'd${posb}: dat${posw}_fifo_rd_pvld = dat${posw}_fifo${posb}_rd_pvld;
//:               );
//:           }
//:            print qq(
//:              //VCS coverage off
//:              default : begin 
//:                          dat${posw}_fifo_rd_pvld = {1{`x_or_0}};
//:                        end  
//:              //VCS coverage on
//:              endcase
//:            end
//:            );
//:
//:         foreach my $posb (0..$Bnum-1) { ##throughput in each atomic_m
//:           print qq(
//:             assign dat${posw}_fifo${posb}_rd_prdy = (atomm_invld[$posw] & is_last_beat)? 1'b0 : (dat_rdy & dat_fifo_rd_last_pvld);
//:           );
//:         }
//:    }
//:
//:         print qq(
//:         always @(*) begin
//:         );
//:             if($Wnum == 1) {
//:                 print qq(
//:                 atomm_invld[0] = 1'b0;
//:                 dat_fifo_rd_last_pvld = dat0_fifo_rd_pvld;
//:                 );
//:             } elsif($Wnum == 2) {
//:                 print qq(
//:                 atomm_invld[0] = 1'b0;
//:                 atomm_invld[1] = (reg_size[0]==0);
//:                 dat_fifo_rd_last_pvld = ((reg_size[0]==0) & is_last_beat) ? dat0_fifo_rd_pvld : dat1_fifo_rd_pvld;
//:                 );
//:             } elsif($Wnum == 4) {
//:                 print qq(
//:                 atomm_invld[0] = 1'b0;
//:                 atomm_invld[1] = (reg_size[1:0]<2'd1);
//:                 atomm_invld[2] = (reg_size[1:0]<2'd2);
//:                 atomm_invld[3] = (reg_size[1:0]<2'd3);
//:                 dat_fifo_rd_last_pvld = ((reg_size[1:0]==0) & is_last_beat) ? dat0_fifo_rd_pvld : 
//:                                         ((reg_size[1:0]==1) & is_last_beat) ? dat1_fifo_rd_pvld :
//:                                         ((reg_size[1:0]==2) & is_last_beat) ? dat2_fifo_rd_pvld :
//:                                         ((reg_size[1:0]==3) & is_last_beat) ? dat3_fifo_rd_pvld : 0;
//:                 );
//:             } else { ## illegal case, atomic_m num within one dmaif tx should be one of 1/2/4
//:             }
//:         print qq(
//:         end
//:         );


// assign is_size_odd = (reg_size[0]==0);
// assign dat0_fifo0_rd_prdy = dat_rdy & dat_fifo_rd_last_pvld;
// assign dat0_fifo1_rd_prdy = dat_rdy & dat_fifo_rd_last_pvld;
// assign dat0_fifo2_rd_prdy = dat_rdy & dat_fifo_rd_last_pvld;
// assign dat0_fifo3_rd_prdy = dat_rdy & dat_fifo_rd_last_pvld;
// assign dat1_fifo0_rd_prdy = (is_size_odd & is_last_beat)? 1'b0 : dat_rdy & dat_fifo_rd_last_pvld;
// assign dat1_fifo1_rd_prdy = (is_size_odd & is_last_beat)? 1'b0 : dat_rdy & dat_fifo_rd_last_pvld;
// assign dat1_fifo2_rd_prdy = (is_size_odd & is_last_beat)? 1'b0 : dat_rdy & dat_fifo_rd_last_pvld;
// assign dat1_fifo3_rd_prdy = (is_size_odd & is_last_beat)? 1'b0 : dat_rdy & dat_fifo_rd_last_pvld;
// assign dat_fifo_rd_last_pvld = (is_size_odd & is_last_beat) ? dat0_fifo_rd_pvld : dat1_fifo_rd_pvld;
// assign dat0_data= {dat0_fifo3_rd_pd, dat0_fifo2_rd_pd, dat0_fifo1_rd_pd, dat0_fifo0_rd_pd};
// assign dat1_data= {dat1_fifo3_rd_pd, dat1_fifo2_rd_pd, dat1_fifo1_rd_pd, dat1_fifo0_rd_pd};
// assign dat_data = {dat1_data,dat0_data};

//: my $dmaifBW = NVDLA_PDP_DMAIF_BW;
//: my $atomicm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_PDP_BWPE;
//: my $pdpbw = NVDLA_PDP_THROUGHPUT*NVDLA_PDP_BWPE;
//: my $Wnum = int( $dmaifBW/$atomicm );
//: my $Bnum = int($atomicm/$pdpbw);
//:   foreach my $posw (0..$Wnum-1) {
//:     print "assign dat${posw}_data = { ";
//:         if($Bnum > 1) {
//:             foreach my $posb (0..$Bnum-2) { ##throughput in each atomic_m
//:                 my $invb = $Bnum -$posb -1;
//:                 print "dat${posw}_fifo${invb}_rd_pd, ";
//:             }
//:         }
//:     print "dat${posw}_fifo0_rd_pd}; \n";
//:   }
//:
//:   print "assign dat_data = { ";
//:   if($Wnum > 1) {
//:     foreach my $posw (0..$Wnum-2) {
//:         my $invw = $Wnum - $posw -1;
//:         print "dat${invw}_data, ";
//:     }
//:   }
//:   print "dat0_data}; \n";

//==============
// output NaN counter
//==============
//always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//  if (!nvdla_core_rstn) begin
//    fp16_en <= 1'b0;
//  end else begin
//  fp16_en <= reg2dp_input_data== 2'h2;
//  end
//end
//assign dat0_is_nan_0[0] = fp16_en & (&dat0_fifo0_rd_pd[14:10]) & (|dat0_fifo0_rd_pd[9:0]);
//assign dat0_is_nan_0[1] = fp16_en & (&dat0_fifo0_rd_pd[30:26]) & (|dat0_fifo0_rd_pd[25:16]);
//assign dat0_is_nan_0[2] = fp16_en & (&dat0_fifo0_rd_pd[46:42]) & (|dat0_fifo0_rd_pd[41:32]);
//assign dat0_is_nan_0[3] = fp16_en & (&dat0_fifo0_rd_pd[62:58]) & (|dat0_fifo0_rd_pd[57:48]);
//assign dat1_is_nan_0[0] = fp16_en & (&dat1_fifo0_rd_pd[14:10]) & (|dat1_fifo0_rd_pd[9:0]);
//assign dat1_is_nan_0[1] = fp16_en & (&dat1_fifo0_rd_pd[30:26]) & (|dat1_fifo0_rd_pd[25:16]);
//assign dat1_is_nan_0[2] = fp16_en & (&dat1_fifo0_rd_pd[46:42]) & (|dat1_fifo0_rd_pd[41:32]);
//assign dat1_is_nan_0[3] = fp16_en & (&dat1_fifo0_rd_pd[62:58]) & (|dat1_fifo0_rd_pd[57:48]);
//assign dat0_is_nan_1[0] = fp16_en & (&dat0_fifo1_rd_pd[14:10]) & (|dat0_fifo1_rd_pd[9:0]);
//assign dat0_is_nan_1[1] = fp16_en & (&dat0_fifo1_rd_pd[30:26]) & (|dat0_fifo1_rd_pd[25:16]);
//assign dat0_is_nan_1[2] = fp16_en & (&dat0_fifo1_rd_pd[46:42]) & (|dat0_fifo1_rd_pd[41:32]);
//assign dat0_is_nan_1[3] = fp16_en & (&dat0_fifo1_rd_pd[62:58]) & (|dat0_fifo1_rd_pd[57:48]);
//assign dat1_is_nan_1[0] = fp16_en & (&dat1_fifo1_rd_pd[14:10]) & (|dat1_fifo1_rd_pd[9:0]);
//assign dat1_is_nan_1[1] = fp16_en & (&dat1_fifo1_rd_pd[30:26]) & (|dat1_fifo1_rd_pd[25:16]);
//assign dat1_is_nan_1[2] = fp16_en & (&dat1_fifo1_rd_pd[46:42]) & (|dat1_fifo1_rd_pd[41:32]);
//assign dat1_is_nan_1[3] = fp16_en & (&dat1_fifo1_rd_pd[62:58]) & (|dat1_fifo1_rd_pd[57:48]);
//assign dat0_is_nan_2[0] = fp16_en & (&dat0_fifo2_rd_pd[14:10]) & (|dat0_fifo2_rd_pd[9:0]);
//assign dat0_is_nan_2[1] = fp16_en & (&dat0_fifo2_rd_pd[30:26]) & (|dat0_fifo2_rd_pd[25:16]);
//assign dat0_is_nan_2[2] = fp16_en & (&dat0_fifo2_rd_pd[46:42]) & (|dat0_fifo2_rd_pd[41:32]);
//assign dat0_is_nan_2[3] = fp16_en & (&dat0_fifo2_rd_pd[62:58]) & (|dat0_fifo2_rd_pd[57:48]);
//assign dat1_is_nan_2[0] = fp16_en & (&dat1_fifo2_rd_pd[14:10]) & (|dat1_fifo2_rd_pd[9:0]);
//assign dat1_is_nan_2[1] = fp16_en & (&dat1_fifo2_rd_pd[30:26]) & (|dat1_fifo2_rd_pd[25:16]);
//assign dat1_is_nan_2[2] = fp16_en & (&dat1_fifo2_rd_pd[46:42]) & (|dat1_fifo2_rd_pd[41:32]);
//assign dat1_is_nan_2[3] = fp16_en & (&dat1_fifo2_rd_pd[62:58]) & (|dat1_fifo2_rd_pd[57:48]);
//assign dat0_is_nan_3[0] = fp16_en & (&dat0_fifo3_rd_pd[14:10]) & (|dat0_fifo3_rd_pd[9:0]);
//assign dat0_is_nan_3[1] = fp16_en & (&dat0_fifo3_rd_pd[30:26]) & (|dat0_fifo3_rd_pd[25:16]);
//assign dat0_is_nan_3[2] = fp16_en & (&dat0_fifo3_rd_pd[46:42]) & (|dat0_fifo3_rd_pd[41:32]);
//assign dat0_is_nan_3[3] = fp16_en & (&dat0_fifo3_rd_pd[62:58]) & (|dat0_fifo3_rd_pd[57:48]);
//assign dat1_is_nan_3[0] = fp16_en & (&dat1_fifo3_rd_pd[14:10]) & (|dat1_fifo3_rd_pd[9:0]);
//assign dat1_is_nan_3[1] = fp16_en & (&dat1_fifo3_rd_pd[30:26]) & (|dat1_fifo3_rd_pd[25:16]);
//assign dat1_is_nan_3[2] = fp16_en & (&dat1_fifo3_rd_pd[46:42]) & (|dat1_fifo3_rd_pd[41:32]);
//assign dat1_is_nan_3[3] = fp16_en & (&dat1_fifo3_rd_pd[62:58]) & (|dat1_fifo3_rd_pd[57:48]);
//
//assign nan_num_in_x[31:0] = {dat1_is_nan_3,dat1_is_nan_2,dat1_is_nan_1,dat1_is_nan_0,dat0_is_nan_3,dat0_is_nan_2,dat0_is_nan_1,dat0_is_nan_0};
//assign nan_num_in_dat0_0[2:0] = (dat0_is_nan_0[0] + dat0_is_nan_0[1]) + (dat0_is_nan_0[2] + dat0_is_nan_0[3]);
//assign nan_num_in_dat0_1[2:0] = (dat0_is_nan_1[0] + dat0_is_nan_1[1]) + (dat0_is_nan_1[2] + dat0_is_nan_1[3]);
//assign nan_num_in_dat0_2[2:0] = (dat0_is_nan_2[0] + dat0_is_nan_2[1]) + (dat0_is_nan_2[2] + dat0_is_nan_2[3]);
//assign nan_num_in_dat0_3[2:0] = (dat0_is_nan_3[0] + dat0_is_nan_3[1]) + (dat0_is_nan_3[2] + dat0_is_nan_3[3]);
//assign nan_num_in_dat1_0[2:0] = (dat1_is_nan_0[0] + dat1_is_nan_0[1]) + (dat1_is_nan_0[2] + dat1_is_nan_0[3]);
//assign nan_num_in_dat1_1[2:0] = (dat1_is_nan_1[0] + dat1_is_nan_1[1]) + (dat1_is_nan_1[2] + dat1_is_nan_1[3]);
//assign nan_num_in_dat1_2[2:0] = (dat1_is_nan_2[0] + dat1_is_nan_2[1]) + (dat1_is_nan_2[2] + dat1_is_nan_2[3]);
//assign nan_num_in_dat1_3[2:0] = (dat1_is_nan_3[0] + dat1_is_nan_3[1]) + (dat1_is_nan_3[2] + dat1_is_nan_3[3]);
//
//function [5:0] fun_bit_sum_32;
//  input [31:0] idata;
//  reg [5:0] ocnt;
//  begin
//    ocnt =
//        (((( idata[0]  
//      +  idata[1]  
//      +  idata[2] ) 
//      + ( idata[3]  
//      +  idata[4]  
//      +  idata[5] )) 
//      + (( idata[6]  
//      +  idata[7]  
//      +  idata[8] ) 
//      + ( idata[9]  
//      +  idata[10]  
//      +  idata[11] ))) 
//      + ((( idata[12]  
//      +  idata[13]  
//      +  idata[14] ) 
//      + ( idata[15]  
//      +  idata[16]  
//      +  idata[17] )) 
//      + (( idata[18]  
//      +  idata[19]  
//      +  idata[20] ) 
//      + ( idata[21]  
//      +  idata[22]  
//      +  idata[23] )))) 
//      + (( idata[24]  
//      +  idata[25]  
//      +  idata[26] ) 
//      + ( idata[27]  
//      +  idata[28]  
//      +  idata[29] )) 
//      + ( idata[30]  
//      +  idata[31] ) ;
//    fun_bit_sum_32 = ocnt;
//  end
//endfunction
//
//assign nan_num_in_64B = fun_bit_sum_32(nan_num_in_x);
//
//always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//  if (!nvdla_core_rstn) begin
//    {mon_nan_in_count,nan_in_count[31:0]} <= {33{1'b0}};
//  end else begin
//    if(dat_accept) begin
//        if(op_done)
//            {mon_nan_in_count,nan_in_count[31:0]} <= 33'd0;
//        else
//            {mon_nan_in_count,nan_in_count[31:0]} <= nan_in_count + nan_num_in_64B;
//    end
//  end
//end
//`ifdef SPYGLASS_ASSERT_ON
//`else
//// spyglass disable_block NoWidthInBasedNum-ML 
//// spyglass disable_block STARC-2.10.3.2a 
//// spyglass disable_block STARC05-2.1.3.1 
//// spyglass disable_block STARC-2.1.4.6 
//// spyglass disable_block W116 
//// spyglass disable_block W154 
//// spyglass disable_block W239 
//// spyglass disable_block W362 
//// spyglass disable_block WRN_58 
//// spyglass disable_block WRN_61 
//`endif // SPYGLASS_ASSERT_ON
//`ifdef ASSERT_ON
//`ifdef FV_ASSERT_ON
//`define ASSERT_RESET nvdla_core_rstn
//`else
//`ifdef SYNTHESIS
//`define ASSERT_RESET nvdla_core_rstn
//`else
//`ifdef ASSERT_OFF_RESET_IS_X
//`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
//`else
//`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
//`endif // ASSERT_OFF_RESET_IS_X
//`endif // SYNTHESIS
//`endif // FV_ASSERT_ON
//  // VCS coverage off 
//  nv_assert_never #(0,0,"PDP WDMA: nan counter no overflow is allowed")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, mon_nan_in_count); // spyglass disable W504 SelfDeterminedExpr-ML 
//  // VCS coverage on
//`undef ASSERT_RESET
//`endif // ASSERT_ON
//`ifdef SPYGLASS_ASSERT_ON
//`else
//// spyglass enable_block NoWidthInBasedNum-ML 
//// spyglass enable_block STARC-2.10.3.2a 
//// spyglass enable_block STARC05-2.1.3.1 
//// spyglass enable_block STARC-2.1.4.6 
//// spyglass enable_block W116 
//// spyglass enable_block W154 
//// spyglass enable_block W239 
//// spyglass enable_block W362 
//// spyglass enable_block WRN_58 
//// spyglass enable_block WRN_61 
//`endif // SPYGLASS_ASSERT_ON
//
//always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//  if (!nvdla_core_rstn) begin
//    dp2reg_nan_output_num <= {32{1'b0}};
//  end else begin
//    if(op_done)
//            dp2reg_nan_output_num <= nan_in_count;
//  end
//end

//==============
// Instance CMD
//==============
NV_NVDLA_PDP_WDMA_cmd u_cmd (
   .reg2dp_cube_out_channel        (reg2dp_cube_out_channel[12:0])       
  ,.reg2dp_cube_out_height         (reg2dp_cube_out_height[12:0])        
  ,.reg2dp_cube_out_width          (reg2dp_cube_out_width[12:0])         
  ,.reg2dp_dst_base_addr_high      (reg2dp_dst_base_addr_high[31:0])     
  ,.reg2dp_dst_base_addr_low       (reg2dp_dst_base_addr_low[31:0])      
  ,.reg2dp_dst_line_stride         (reg2dp_dst_line_stride[31:0])        
  ,.reg2dp_dst_surface_stride      (reg2dp_dst_surface_stride[31:0])     
//  ,.reg2dp_input_data              (reg2dp_input_data[1:0])              
  ,.reg2dp_partial_width_out_first (reg2dp_partial_width_out_first[9:0]) 
  ,.reg2dp_partial_width_out_last  (reg2dp_partial_width_out_last[9:0])  
  ,.reg2dp_partial_width_out_mid   (reg2dp_partial_width_out_mid[9:0])   
  ,.reg2dp_split_num               (reg2dp_split_num[7:0])               
  ,.cmd_fifo_rd_prdy               (cmd_fifo_rd_prdy)                    
  ,.cmd_fifo_rd_pd                 (cmd_fifo_rd_pd[79:0])                
  ,.cmd_fifo_rd_pvld               (cmd_fifo_rd_pvld)                    
  ,.nvdla_core_clk                 (nvdla_core_clk)                      
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 
  ,.op_load                        (op_load)                             
  );
// CMD FIFO: Read side
assign cmd_fifo_rd_prdy = cmd_en & dma_wr_req_rdy;

// Unpack cmd & data together

// PKT_UNPACK_WIRE( pdp_wdma_cmd , cmd_fifo_rd_ , cmd_fifo_rd_pd )
assign       cmd_fifo_rd_addr[63:0] =    cmd_fifo_rd_pd[63:0];
assign       cmd_fifo_rd_size[12:0] =    cmd_fifo_rd_pd[76:64];
//assign       cmd_fifo_rd_lenb[4:0] =    cmd_fifo_rd_pd[78:77];
assign        cmd_fifo_rd_cube_end  =    cmd_fifo_rd_pd[79];
// addr/size/lenb/end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg_lenb <= 0;
  end else begin
  if ((dma_wr_cmd_accept) == 1'b1) begin
//: my $atomicm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_PDP_BWPE;
//: my $pdpbw = NVDLA_PDP_THROUGHPUT*NVDLA_PDP_BWPE;
//: my $Bnum = int($atomicm/$pdpbw);
//:    print "reg_lenb <= ${Bnum} - 1;";

//reg_lenb <= cmd_fifo_rd_lenb;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg_size <= {13{1'b0}};
  end else begin
  if ((dma_wr_cmd_accept) == 1'b1) begin
    reg_size <= cmd_fifo_rd_size;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg_cube_last <= 1'b0;
  end else begin
  if ((dma_wr_cmd_accept) == 1'b1) begin
    reg_cube_last <= cmd_fifo_rd_cube_end;
  end
  end
end

//==============
// BLOCK Operation
//==============
assign dma_wr_cmd_vld = cmd_en & cmd_fifo_rd_pvld;
assign dma_wr_cmd_accept = dma_wr_cmd_vld & dma_wr_req_rdy;

assign dma_wr_dat_vld   = dat_en & dat_fifo_rd_last_pvld;
assign dat_rdy          = dat_en & dma_wr_req_rdy;
assign dat_accept = dma_wr_dat_vld & dma_wr_req_rdy;

// count_w and tran_cnt is used to index 8B in each 8(B)x8(w)x4(c) block, (w may be < 8 if is_first_w or is_last_w)
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_w <= {13{1'b0}};
  end else begin
    if (dma_wr_cmd_accept) begin
        count_w <= 0;
    end else if (dat_accept) begin
//: my $Wnum= NVDLA_PDP_DMAIF_BW/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_PDP_BWPE;
//: print "    count_w <= count_w + ${Wnum};   \n";
    end
  end
end
//: my $Wnum= NVDLA_PDP_DMAIF_BW/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_PDP_BWPE;
//: if($Wnum == 1) {
//:     print qq(
//:         assign is_last_beat = (count_w==reg_size);
//:     );
//: } elsif($Wnum == 2) {
//:     print qq(
//:         assign is_last_beat = (count_w==reg_size || count_w==reg_size-1);
//:     );
//: } elsif($Wnum == 4) {
//:     print qq(
//:         assign is_last_beat = (count_w==reg_size || count_w==reg_size-1 || count_w==reg_size-2 || count_w==reg_size-3);
//:     );
//: }

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_en <= 1'b1;
    dat_en <= 1'b0;
  end else begin
    if (is_last_beat & dat_accept) begin
        cmd_en <= 1'b1;
        dat_en <= 1'b0;
    end else if (dma_wr_cmd_accept) begin
        cmd_en <= 1'b0;
        dat_en <= 1'b1;
    end
  end
end

//==============
// DMA REQ: Size
//==============
// packet: cmd
//assign dma_wr_cmd_vld  = cmd_vld;
assign dma_wr_cmd_addr = cmd_fifo_rd_addr;
assign dma_wr_cmd_size = {10'b0, cmd_fifo_rd_size};
assign dma_wr_cmd_require_ack   = cmd_fifo_rd_cube_end;

// PKT_PACK_WIRE( dma_write_cmd ,  dma_wr_cmd_ ,  dma_wr_cmd_pd )
assign       dma_wr_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH-1:0]  = dma_wr_cmd_addr[NVDLA_MEM_ADDRESS_WIDTH-1:0];
assign       dma_wr_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+12:NVDLA_MEM_ADDRESS_WIDTH] = dma_wr_cmd_size[12:0];
assign       dma_wr_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+13]    = dma_wr_cmd_require_ack ;
// packet: data
assign dma_wr_dat_data = dat_data;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_fifo_rd_size_use <= {13{1'b0}};
  end else begin
  if ((cmd_fifo_rd_pvld & cmd_fifo_rd_prdy) == 1'b1) begin
    cmd_fifo_rd_size_use <= cmd_fifo_rd_size[12:0];
  // VCS coverage off
  end else if ((cmd_fifo_rd_pvld & cmd_fifo_rd_prdy) == 1'b0) begin
  end else begin
    cmd_fifo_rd_size_use <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd_fifo_rd_pvld & cmd_fifo_rd_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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

//: my $msk = NVDLA_PDP_MEM_MASK_BIT;
//: if($msk == 1) {
//:     print " assign dma_wr_dat_mask = 2'b1;  \n";
//: } elsif($msk == 2) {
//:     print " assign dma_wr_dat_mask = (cmd_fifo_rd_size_use[0]==0 && is_last_beat) ? 2'b01 : 2'b11;  \n";
//: } elsif($msk == 4) {
//:     print " assign dma_wr_dat_mask = ((cmd_fifo_rd_size_use[1:0]==2'b00) && is_last_beat) ? 4'b0001 :  \n";
//:     print "                          ((cmd_fifo_rd_size_use[1:0]==2'b01) && is_last_beat) ? 4'b0011 :  \n";
//:     print "                          ((cmd_fifo_rd_size_use[1:0]==2'b10) && is_last_beat) ? 4'b0111 : 4'b1111;  \n";
//: }

// PKT_PACK_WIRE( dma_write_data ,  dma_wr_dat_ ,  dma_wr_dat_pd )
assign       dma_wr_dat_pd[NVDLA_PDP_DMAIF_BW-1:0] =     dma_wr_dat_data[NVDLA_PDP_DMAIF_BW-1:0];
assign       dma_wr_dat_pd[NVDLA_PDP_DMAIF_BW+NVDLA_PDP_MEM_MASK_BIT-1:NVDLA_PDP_DMAIF_BW] =     dma_wr_dat_mask[NVDLA_PDP_MEM_MASK_BIT-1:0];

// pack cmd & dat
assign dma_wr_req_vld = dma_wr_cmd_vld | dma_wr_dat_vld;
always @(*) begin
    // init to 0
    dma_wr_req_pd[NVDLA_PDP_DMAIF_BW + NVDLA_PDP_MEM_MASK_BIT-1:0] = 0;
    // cmd or dat
    if (cmd_en) begin
        dma_wr_req_pd[NVDLA_MEM_ADDRESS_WIDTH+13:0] = dma_wr_cmd_pd;
    end else begin
        dma_wr_req_pd[NVDLA_PDP_DMAIF_BW + NVDLA_PDP_MEM_MASK_BIT-1:0] = dma_wr_dat_pd;
    end
    // pkt id
    dma_wr_req_pd[NVDLA_PDP_MEM_WR_REQ-1] = cmd_en ? 1'd0  /* PKT_nvdla_dma_wr_req_dma_write_cmd_ID  */  : 1'd1  /* PKT_nvdla_dma_wr_req_dma_write_data_ID  */ ;
end

//==============
// reading stall counter before DMA_if
//==============
assign cnt_inc = 1'b1;
assign cnt_clr = op_done;
assign cnt_cen = (reg2dp_dma_en == 1'h1 ) & (dma_wr_req_vld & (~dma_wr_req_rdy));



    assign pdp_wr_stall_count_dec = 1'b0;

    // stl adv logic

    always @(
      cnt_inc
      or pdp_wr_stall_count_dec
      ) begin
      stl_adv = cnt_inc ^ pdp_wr_stall_count_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or cnt_inc
      or pdp_wr_stall_count_dec
      or stl_adv
      or cnt_clr
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (cnt_inc && !pdp_wr_stall_count_dec)? stl_cnt_inc : (!cnt_inc && pdp_wr_stall_count_dec)? stl_cnt_dec : stl_cnt_ext;
      stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
      stl_cnt_nxt[33:0] = (cnt_clr)? 34'd0 : stl_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // stl flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
      end else begin
      if (cnt_cen) begin
      stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
      end
      end
    end

    // stl output logic

    always @(
      stl_cnt_cur
      ) begin
      pdp_wr_stall_count[31:0] = stl_cnt_cur[31:0];
    end
        
      

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    layer_flag <= 1'b0;
  end else begin
  if ((cnt_clr) == 1'b1) begin
    layer_flag <= ~layer_flag;
  // VCS coverage off
  end else if ((cnt_clr) == 1'b0) begin
  end else begin
    layer_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_perf_write_stall <= {32{1'b0}};
  end else begin
  if ((cnt_clr & (~layer_flag)) == 1'b1) begin
    dp2reg_d0_perf_write_stall <= pdp_wr_stall_count[31:0];
  // VCS coverage off
  end else if ((cnt_clr & (~layer_flag)) == 1'b0) begin
  end else begin
    dp2reg_d0_perf_write_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr & (~layer_flag)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_perf_write_stall <= {32{1'b0}};
  end else begin
  if ((cnt_clr &   layer_flag ) == 1'b1) begin
    dp2reg_d1_perf_write_stall <= pdp_wr_stall_count[31:0];
  // VCS coverage off
  end else if ((cnt_clr &   layer_flag ) == 1'b0) begin
  end else begin
    dp2reg_d1_perf_write_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr &   layer_flag ))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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



NV_NVDLA_DMAIF_wr NV_NVDLA_PDP_WDMA_wr(
   .nvdla_core_clk          (nvdla_core_clk_orig  )  
  ,.nvdla_core_rstn         (nvdla_core_rstn      ) 
  ,.reg2dp_dst_ram_type     (reg2dp_dst_ram_type  )
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif_wr_req_pd          (pdp2cvif_wr_req_pd      )    
  ,.cvif_wr_req_valid       (pdp2cvif_wr_req_valid   )
  ,.cvif_wr_req_ready       (pdp2cvif_wr_req_ready   )
  ,.cvif_wr_rsp_complete    (cvif2pdp_wr_rsp_complete)
  #endif
  ,.mcif_wr_req_pd          (pdp2mcif_wr_req_pd      ) 
  ,.mcif_wr_req_valid       (pdp2mcif_wr_req_valid   ) 
  ,.mcif_wr_req_ready       (pdp2mcif_wr_req_ready   ) 
  ,.mcif_wr_rsp_complete    (mcif2pdp_wr_rsp_complete)

  ,.dmaif_wr_req_pd         (dma_wr_req_pd       )   
  ,.dmaif_wr_req_pvld       (dma_wr_req_vld      )
  ,.dmaif_wr_req_prdy       (dma_wr_req_rdy      )
  ,.dmaif_wr_rsp_complete   (dma_wr_rsp_complete )
);


//logic for wdma writing done, and has accepted dma_wr_rsp_complete, but RDMA still not reading done
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wdma_done_d1 <= 1'b0;
  end else begin
  wdma_done_d1 <= wdma_done;
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    intp_waiting_rdma <= 1'b0;
  end else begin
    if(dma_wr_rsp_complete & waiting_rdma)
        intp_waiting_rdma <= 1'b1;
    else if(wdma_done_d1)
        intp_waiting_rdma <= 1'b0;
  end
end
//

NV_NVDLA_PDP_WDMA_intr_fifo u_intr_fifo (
   .nvdla_core_clk                 (nvdla_core_clk_orig)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.intr_fifo_wr_pvld              (intr_fifo_wr_pvld)                   //|< w
  ,.intr_fifo_wr_pd                (intr_fifo_wr_pd)                     //|< w
  ,.intr_fifo_rd_prdy              (intr_fifo_rd_prdy)                   //|< w
  ,.intr_fifo_rd_pvld              (intr_fifo_rd_pvld)                   //|> w
  ,.intr_fifo_rd_pd                (intr_fifo_rd_pd)                     //|> w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 //|< i
  );
assign intr_fifo_wr_pd    = reg2dp_interrupt_ptr;
assign intr_fifo_wr_pvld  = wdma_done;
assign intr_fifo_rd_prdy  = dma_wr_rsp_complete & (~waiting_rdma) || (intp_waiting_rdma & wdma_done_d1);

always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp2glb_done_intr_pd[0] <= 1'b0;
  end else begin
  pdp2glb_done_intr_pd[0] <= intr_fifo_rd_pvld & intr_fifo_rd_prdy & (intr_fifo_rd_pd==0);
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp2glb_done_intr_pd[1] <= 1'b0;
  end else begin
  pdp2glb_done_intr_pd[1] <= intr_fifo_rd_pvld & intr_fifo_rd_prdy & (intr_fifo_rd_pd==1);
  end
end

////==============
////OBS signals
////==============
//assign obs_bus_pdp_core_proc_en = op_prcess;

//==============
//function polint
//==============
//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_WDMA__dma_writing_stall__7_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        dma_wr_req_vld & (~dma_wr_req_rdy);
    endproperty
    // Cover 7 : "dma_wr_req_vld & (~dma_wr_req_rdy)"
    FUNCPOINT_PDP_WDMA__dma_writing_stall__7_COV : cover property (PDP_WDMA__dma_writing_stall__7_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_WDMA__dp2wdma_stall__8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_dp2wdma_valid & (~pdp_dp2wdma_ready);
    endproperty
    // Cover 8 : "pdp_dp2wdma_valid & (~pdp_dp2wdma_ready)"
    FUNCPOINT_PDP_WDMA__dp2wdma_stall__8_COV : cover property (PDP_WDMA__dp2wdma_stall__8_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_PDP_wdma


//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_PDP_WDMA_intr_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus intr_fifo_wr -rd_pipebus intr_fifo_rd -ram_bypass -d 0 -rd_reg -rd_busy_reg -no_wr_busy -w 1 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_PDP_WDMA_intr_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , intr_fifo_wr_pvld
    , intr_fifo_wr_pd
    , intr_fifo_rd_prdy
    , intr_fifo_rd_pvld
    , intr_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         intr_fifo_wr_pvld;
input         intr_fifo_wr_pd;
input         intr_fifo_rd_prdy;
output        intr_fifo_rd_pvld;
output        intr_fifo_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
        
//          
// NOTE: 0-depth fifo has no write side
//          


//
// RAM
//

//
// NOTE: 0-depth fifo has no ram.
//
wire [0:0] intr_fifo_rd_pd_p = intr_fifo_wr_pd;

//
// SYNCHRONOUS BOUNDARY
//

//
// NOTE: 0-depth fifo has no real boundary between write and read sides
//


//
// READ SIDE
//

reg        intr_fifo_rd_prdy_d;				// intr_fifo_rd_prdy registered in cleanly

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intr_fifo_rd_prdy_d <=  1'b1;
    end else begin
        intr_fifo_rd_prdy_d <=  intr_fifo_rd_prdy;
    end
end

wire       intr_fifo_rd_prdy_d_o;			// combinatorial rd_busy

reg        intr_fifo_rd_pvld_int;			// internal copy of intr_fifo_rd_pvld

assign     intr_fifo_rd_pvld = intr_fifo_rd_pvld_int;
wire       intr_fifo_rd_pvld_p = intr_fifo_wr_pvld ; 		// no real fifo, take from write-side input
reg        intr_fifo_rd_pvld_int_o;	// internal copy of intr_fifo_rd_pvld_o
wire       intr_fifo_rd_pvld_o = intr_fifo_rd_pvld_int_o;
wire       rd_popping = intr_fifo_rd_pvld_p && !(intr_fifo_rd_pvld_int_o && !intr_fifo_rd_prdy_d_o);


// 
// SKID for -rd_busy_reg
//
reg  intr_fifo_rd_pd_o;         // output data register
wire        rd_req_next_o = (intr_fifo_rd_pvld_p || (intr_fifo_rd_pvld_int_o && !intr_fifo_rd_prdy_d_o)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intr_fifo_rd_pvld_int_o <=  1'b0;
    end else begin
        intr_fifo_rd_pvld_int_o <=  rd_req_next_o;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (intr_fifo_rd_pvld_int && rd_req_next_o && rd_popping) ) begin
        intr_fifo_rd_pd_o <=  intr_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((intr_fifo_rd_pvld_int && rd_req_next_o && rd_popping)) ) begin
    end else begin
        intr_fifo_rd_pd_o <=  {1{`x_or_0}};
    end
    //synopsys translate_on

end

//
// FINAL OUTPUT
//
reg  intr_fifo_rd_pd;				// output data register
reg        intr_fifo_rd_pvld_int_d;			// so we can bubble-collapse intr_fifo_rd_prdy_d
assign     intr_fifo_rd_prdy_d_o = !((intr_fifo_rd_pvld_o && intr_fifo_rd_pvld_int_d && !intr_fifo_rd_prdy_d ) );
wire       rd_req_next = (!intr_fifo_rd_prdy_d_o ? intr_fifo_rd_pvld_o : intr_fifo_rd_pvld_p) ;  

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intr_fifo_rd_pvld_int <=  1'b0;
        intr_fifo_rd_pvld_int_d <=  1'b0;
    end else begin
        if ( !intr_fifo_rd_pvld_int || intr_fifo_rd_prdy ) begin
	    intr_fifo_rd_pvld_int <=  rd_req_next;
        end
        //synopsys translate_off
            else if ( !(!intr_fifo_rd_pvld_int || intr_fifo_rd_prdy) ) begin
        end else begin
            intr_fifo_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on


        intr_fifo_rd_pvld_int_d <=  intr_fifo_rd_pvld_int;
    end
end

always @( posedge nvdla_core_clk ) begin
    if ( rd_req_next && (!intr_fifo_rd_pvld_int || intr_fifo_rd_prdy ) ) begin
        case (!intr_fifo_rd_prdy_d_o) 
            1'b0:    intr_fifo_rd_pd <=  intr_fifo_rd_pd_p;
            1'b1:    intr_fifo_rd_pd <=  intr_fifo_rd_pd_o;
            //VCS coverage off
            default: intr_fifo_rd_pd <=  {1{`x_or_0}};
            //VCS coverage on
        endcase
    end
    //synopsys translate_off
        else if ( !(rd_req_next && (!intr_fifo_rd_pvld_int || intr_fifo_rd_prdy)) ) begin
    end else begin
        intr_fifo_rd_pd <=  {1{`x_or_0}};
    end
    //synopsys translate_on

end


// Tie-offs for pwrbus_ram_pd

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((1'b0) || (intr_fifo_wr_pvld || (intr_fifo_rd_pvld_int && intr_fifo_rd_prdy_d) || (intr_fifo_rd_pvld_int_o && intr_fifo_rd_prdy_d_o)))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_PDP_WDMA_intr_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_PDP_WDMA_intr_fifo

