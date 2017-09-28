// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CVIF_WRITE_IG_bpt.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CVIF_WRITE_IG_bpt (
   nvdla_core_clk    //|< i
  ,nvdla_core_rstn   //|< i
  ,dma2bpt_req_valid //|< i
  ,dma2bpt_req_ready //|> o
  ,dma2bpt_req_pd    //|< i
  ,bpt2arb_cmd_valid //|> o
  ,bpt2arb_cmd_ready //|< i
  ,bpt2arb_cmd_pd    //|> o
  ,bpt2arb_dat_valid //|> o
  ,bpt2arb_dat_ready //|< i
  ,bpt2arb_dat_pd    //|> o
  ,pwrbus_ram_pd     //|< i
  ,axid              //|< i
  );
//
// NV_NVDLA_CVIF_WRITE_IG_bpt_ports.v
//
input  nvdla_core_clk;   /* dma2bpt_req, bpt2arb_cmd, bpt2arb_dat */
input  nvdla_core_rstn;  /* dma2bpt_req, bpt2arb_cmd, bpt2arb_dat */

input          dma2bpt_req_valid;  /* data valid */
output         dma2bpt_req_ready;  /* data return handshake */
input  [514:0] dma2bpt_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

output        bpt2arb_cmd_valid;  /* data valid */
input         bpt2arb_cmd_ready;  /* data return handshake */
output [76:0] bpt2arb_cmd_pd;

output         bpt2arb_dat_valid;  /* data valid */
input          bpt2arb_dat_ready;  /* data return handshake */
output [513:0] bpt2arb_dat_pd;

input [31:0] pwrbus_ram_pd;

input [3:0] axid;
reg    [1:0] beat_count;
reg          cmd_en;
reg          dat_en;
reg          in_dat1_dis;
reg   [12:0] in_dat_cnt;
reg          in_dat_vld;
reg   [63:0] out_addr;
reg    [2:0] out_size;
reg   [10:0] req_count;
reg   [10:0] req_num;
wire   [1:0] all_idle;
wire   [1:0] beat_size;
wire         bpt2arb_cmd_accept;
wire         bpt2arb_dat_accept;
wire         bpt_idle_NC;
wire [255:0] dfifo0_rd_pd;
wire         dfifo0_rd_prdy;
wire         dfifo0_rd_pvld;
wire         dfifo0_wr_idle;
wire [255:0] dfifo0_wr_pd;
wire         dfifo0_wr_prdy;
wire         dfifo0_wr_pvld;
wire [255:0] dfifo1_rd_pd;
wire         dfifo1_rd_prdy;
wire         dfifo1_rd_pvld;
wire         dfifo1_wr_idle;
wire [255:0] dfifo1_wr_pd;
wire         dfifo1_wr_prdy;
wire         dfifo1_wr_pvld;
wire         dfifo_rd_prdy;
wire   [1:0] dfifo_wr_mask;
wire [513:0] dfifo_wr_pd;
wire         dfifo_wr_rdy;
wire         dfifo_wr_vld;
wire   [2:0] end_offset;
wire   [2:0] ftran_size;
wire  [63:0] in_cmd_addr;
wire  [77:0] in_cmd_pd;
wire         in_cmd_rdy;
wire         in_cmd_require_ack;
wire  [12:0] in_cmd_size;
wire         in_cmd_vld;
wire  [77:0] in_cmd_vld_pd;
wire [255:0] in_dat0_data;
wire         in_dat0_dis;
wire         in_dat0_en;
wire         in_dat0_mask;
wire         in_dat0_pvld;
wire [255:0] in_dat1_data;
wire         in_dat1_en;
wire         in_dat1_mask;
wire         in_dat1_pvld;
wire  [12:0] in_dat_beats;
wire         in_dat_first;
wire         in_dat_last;
wire         in_size_is_even;
wire         in_size_is_odd;
wire  [63:0] ipipe_cmd_addr;
wire  [77:0] ipipe_cmd_pd;
wire         ipipe_cmd_rdy;
wire         ipipe_cmd_require_ack;
wire  [12:0] ipipe_cmd_size;
wire         ipipe_cmd_vld;
wire [511:0] ipipe_dat_data;
wire   [1:0] ipipe_dat_mask;
wire [514:0] ipipe_pd;
wire [514:0] ipipe_pd_p;
wire         ipipe_rdy;
wire         ipipe_rdy_p;
wire         ipipe_vld;
wire         ipipe_vld_p;
wire         is_ftran;
wire         is_last_beat;
wire         is_ltran;
wire         is_mtran;
wire         is_single_tran;
wire         is_stt_addr_32_aligned;
wire         is_swizzle;
wire         large_req_grow;
wire   [2:0] ltran_size;
wire         mon_dfifo0_wr_pd;
wire         mon_dfifo1_wr_pd;
wire         mon_end_offset_c;
wire         mon_out_beats_c;
wire  [12:0] mtran_num;
wire  [63:0] out_cmd_addr;
wire   [3:0] out_cmd_axid;
wire         out_cmd_ftran;
wire         out_cmd_inc;
wire         out_cmd_ltran;
wire         out_cmd_odd;
wire         out_cmd_require_ack;
wire   [2:0] out_cmd_size;
wire         out_cmd_swizzle;
wire         out_cmd_vld;
wire [511:0] out_dat_data;
wire   [1:0] out_dat_mask;
wire         out_dat_vld;
wire   [2:0] size_offset;
wire   [2:0] stt_offset;
wire [255:0] swizzle_dat0_data;
wire         swizzle_dat0_mask;
wire [255:0] swizzle_dat1_data;
wire         swizzle_dat1_mask;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==================
// 1st Stage: REQ PIPE
NV_NVDLA_CVIF_WRITE_IG_BPT_pipe_p1 pipe_p1 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.dma2bpt_req_pd    (dma2bpt_req_pd[514:0]) //|< i
  ,.dma2bpt_req_valid (dma2bpt_req_valid)     //|< i
  ,.ipipe_rdy_p       (ipipe_rdy_p)           //|< w
  ,.dma2bpt_req_ready (dma2bpt_req_ready)     //|> o
  ,.ipipe_pd_p        (ipipe_pd_p[514:0])     //|> w
  ,.ipipe_vld_p       (ipipe_vld_p)           //|> w
  );
NV_NVDLA_CVIF_WRITE_IG_BPT_pipe_p2 pipe_p2 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.ipipe_pd_p        (ipipe_pd_p[514:0])     //|< w
  ,.ipipe_rdy         (ipipe_rdy)             //|< w
  ,.ipipe_vld_p       (ipipe_vld_p)           //|< w
  ,.ipipe_pd          (ipipe_pd[514:0])       //|> w
  ,.ipipe_rdy_p       (ipipe_rdy_p)           //|> w
  ,.ipipe_vld         (ipipe_vld)             //|> w
  );
assign ipipe_cmd_vld = ipipe_vld && (ipipe_pd[514:514]== 0 /* PKT_nvdla_dma_wr_req_dma_write_cmd_int_ID  */ );
assign dfifo_wr_vld = ipipe_vld && (ipipe_pd[514:514]== 1 /* PKT_nvdla_dma_wr_req_dma_write_data_int_ID  */ );
assign dfifo_wr_mask = ipipe_pd[513:512];
assign ipipe_rdy = (ipipe_cmd_vld & ipipe_cmd_rdy) || (dfifo_wr_vld & dfifo_wr_rdy); 

//==================
// 2nd Stage: CMD PIPE

// PKT_UNPACK_WIRE( dma_write_cmd , ipipe_cmd_ , ipipe_pd )
assign       ipipe_cmd_addr[63:0] =    ipipe_pd[63:0];
assign       ipipe_cmd_size[12:0] =    ipipe_pd[76:64];
assign        ipipe_cmd_require_ack  =    ipipe_pd[77];

// PKT_PACK_WIRE( dma_write_cmd , ipipe_cmd_ , ipipe_cmd_pd )
assign      ipipe_cmd_pd[63:0] =    ipipe_cmd_addr[63:0];
assign      ipipe_cmd_pd[76:64] =    ipipe_cmd_size[12:0];
assign      ipipe_cmd_pd[77] =    ipipe_cmd_require_ack ;
NV_NVDLA_CVIF_WRITE_IG_BPT_pipe_p3 pipe_p3 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.in_cmd_rdy        (in_cmd_rdy)            //|< w
  ,.ipipe_cmd_pd      (ipipe_cmd_pd[77:0])    //|< w
  ,.ipipe_cmd_vld     (ipipe_cmd_vld)         //|< w
  ,.in_cmd_pd         (in_cmd_pd[77:0])       //|> w
  ,.in_cmd_vld        (in_cmd_vld)            //|> w
  ,.ipipe_cmd_rdy     (ipipe_cmd_rdy)         //|> w
  );
assign in_cmd_rdy = is_ltran & is_last_beat & bpt2arb_dat_accept;

assign in_cmd_vld_pd = {78{in_cmd_vld}} & in_cmd_pd;

// PKT_UNPACK_WIRE( dma_write_cmd , in_cmd_ , in_cmd_vld_pd )
assign       in_cmd_addr[63:0] =    in_cmd_vld_pd[63:0];
assign       in_cmd_size[12:0] =    in_cmd_vld_pd[76:64];
assign        in_cmd_require_ack  =    in_cmd_vld_pd[77];
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
  wire cond_zzz_assert_always_1x = (in_cmd_addr[4:0] == 0);
  nv_assert_always #(0,0,"lower 5 LSB should always be 0")      zzz_assert_always_1x (.clk(nvdla_core_clk), .reset_(`ASSERT_RESET), .test_expr(cond_zzz_assert_always_1x)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==================
// data will be pushed into dFIFO first in dma format
// 2nd Stage: DATA FIFO: WRITE side

// PKT_UNPACK_WIRE( dma_write_data , ipipe_dat_ , ipipe_pd )
assign       ipipe_dat_data[511:0] =    ipipe_pd[511:0];
assign       ipipe_dat_mask[1:0] =    ipipe_pd[513:512];

// PKT_PACK_WIRE( dma_write_data , ipipe_dat_ , dfifo_wr_pd )
assign      dfifo_wr_pd[511:0] =    ipipe_dat_data[511:0];
assign      dfifo_wr_pd[513:512] =    ipipe_dat_mask[1:0];
assign dfifo0_wr_pvld = dfifo_wr_vld && dfifo_wr_mask[0] && dfifo1_wr_prdy;
assign dfifo1_wr_pvld = dfifo_wr_vld && dfifo_wr_mask[1] && dfifo0_wr_prdy;
assign dfifo0_wr_pd = dfifo_wr_pd[255:0];
assign dfifo1_wr_pd = dfifo_wr_pd[511:256];
assign dfifo_wr_rdy = dfifo0_wr_prdy & dfifo1_wr_prdy;

assign mon_dfifo0_wr_pd = dfifo0_wr_pvld & (^dfifo0_wr_pd);
assign mon_dfifo1_wr_pd = dfifo1_wr_pvld & (^dfifo1_wr_pd);
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
  nv_assert_no_x #(0,1,0,"No X's allowed on valid data bus low 32B")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,mon_dfifo0_wr_pd); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_no_x #(0,1,0,"No X's allowed on valid data bus high 32B")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,mon_dfifo1_wr_pd); // spyglass disable W504 SelfDeterminedExpr-ML 
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

NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo u_dfifo0 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.dfifo_wr_prdy     (dfifo0_wr_prdy)        //|> w
  ,.dfifo_wr_idle     (dfifo0_wr_idle)        //|> w
  ,.dfifo_wr_pvld     (dfifo0_wr_pvld)        //|< w
  ,.dfifo_wr_pd       (dfifo0_wr_pd[255:0])   //|< w
  ,.dfifo_rd_prdy     (dfifo0_rd_prdy)        //|< w
  ,.dfifo_rd_pvld     (dfifo0_rd_pvld)        //|> w
  ,.dfifo_rd_pd       (dfifo0_rd_pd[255:0])   //|> w
  ,.pwrbus_ram_pd     (pwrbus_ram_pd[31:0])   //|< i
  );

NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo u_dfifo1 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.dfifo_wr_prdy     (dfifo1_wr_prdy)        //|> w
  ,.dfifo_wr_idle     (dfifo1_wr_idle)        //|> w
  ,.dfifo_wr_pvld     (dfifo1_wr_pvld)        //|< w
  ,.dfifo_wr_pd       (dfifo1_wr_pd[255:0])   //|< w
  ,.dfifo_rd_prdy     (dfifo1_rd_prdy)        //|< w
  ,.dfifo_rd_pvld     (dfifo1_rd_pvld)        //|> w
  ,.dfifo_rd_pd       (dfifo1_rd_pd[255:0])   //|> w
  ,.pwrbus_ram_pd     (pwrbus_ram_pd[31:0])   //|< i
  );


assign all_idle[1:0] = {
  dfifo1_wr_idle
  ,dfifo0_wr_idle
  };
assign bpt_idle_NC = &all_idle;

//==================
// in_cmd analysis to determine how to pop data from dFIFO
assign stt_offset[2:0] = in_cmd_addr[7:5];
assign size_offset[2:0] = in_cmd_size[2:0];
assign {mon_end_offset_c, end_offset[2:0]} = stt_offset + size_offset;
assign is_stt_addr_32_aligned = (stt_offset[0]==1);
assign is_swizzle = is_stt_addr_32_aligned;
assign in_size_is_odd = (in_cmd_size[0]==0);
assign in_size_is_even = (in_cmd_size[0]==1);
assign large_req_grow = is_swizzle & in_size_is_even;
//assign small_req_grow = is_single_tran & is_swizzle & in_size_is_even;
//assign is_end_addr_32_aligned = (end_offset[0]==0);

//==================
// dFIFO popping in AXI format
//==================
assign in_dat_beats = in_cmd_size[12:1] + large_req_grow;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    in_dat_cnt <= {13{1'b0}};
  end else begin
    if (bpt2arb_dat_accept) begin
        if (in_dat_last) begin
            in_dat_cnt <= 0;
        end else begin
            in_dat_cnt <= in_dat_cnt + 1;
        end
    end
  end
end

assign in_dat_last = (in_dat_cnt==in_dat_beats);
assign in_dat_first = (in_dat_cnt==0);

//==================
assign in_dat0_dis = (in_size_is_even & is_swizzle) ? in_dat_last : 1'b0;

always @(
  in_size_is_even
  or is_swizzle
  or in_dat_first
  or in_dat_last
  ) begin
    if (in_size_is_even) begin
        in_dat1_dis = is_swizzle ? in_dat_first : 1'b0;
    end else begin
        in_dat1_dis = is_swizzle ? in_dat_first : in_dat_last;
    end
end

assign in_dat0_en = !in_dat0_dis;
assign in_dat1_en = !in_dat1_dis;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_en <= 1'b1;
    dat_en <= 1'b0;
  end else begin
    if (bpt2arb_cmd_accept) begin
        cmd_en <= 1'b0;
        dat_en <= 1'b1;
    end else if (bpt2arb_dat_accept & is_last_beat) begin
        cmd_en <= 1'b1;
        dat_en <= 1'b0;
    end
  end
end

// vld & data & mask
assign in_dat0_pvld = dfifo0_rd_pvld & in_dat0_en;
assign in_dat0_data = dfifo0_rd_pd;
assign in_dat0_mask = in_dat0_en;

assign in_dat1_pvld = dfifo1_rd_pvld & in_dat1_en;
assign in_dat1_data = dfifo1_rd_pd;
assign in_dat1_mask = in_dat1_en;

//assign in_dat_vld = (in_dat0_en && in_dat0_pvld) || (in_dat1_en && in_dat1_pvld);
always @(
  in_dat1_en
  or in_dat0_en
  or in_dat0_pvld
  or in_dat1_pvld
  ) begin
    case ({in_dat1_en,in_dat0_en})
    2'b00: in_dat_vld = 1'b0;
    2'b01: in_dat_vld = in_dat0_pvld;
    2'b10: in_dat_vld = in_dat1_pvld;
    2'b11: in_dat_vld = in_dat0_pvld & in_dat1_pvld;
    //VCS coverage off
    default : begin 
                in_dat_vld = {1{`x_or_0}};
              end  
    //VCS coverage on
    endcase
end

// dFIFO read side: ready
assign dfifo_rd_prdy = dat_en & bpt2arb_dat_ready;
assign dfifo0_rd_prdy = in_dat0_en & dfifo_rd_prdy & (in_dat1_dis || in_dat1_pvld);
assign dfifo1_rd_prdy = in_dat1_en & dfifo_rd_prdy & (in_dat0_dis || in_dat0_pvld);

// Swizzle: vld and data
//assign swizzle_dat0_pvld = is_swizzle ? in_dat1_pvld : in_dat0_pvld;
assign swizzle_dat0_data = is_swizzle ? in_dat1_data : in_dat0_data;
assign swizzle_dat0_mask = is_swizzle ? in_dat1_mask : in_dat0_mask;

//assign swizzle_dat1_pvld = is_swizzle ? in_dat0_pvld : in_dat1_pvld;
assign swizzle_dat1_data = is_swizzle ? in_dat0_data : in_dat1_data;
assign swizzle_dat1_mask = is_swizzle ? in_dat0_mask : in_dat1_mask;

//assign swizzle_dat_vld = swizzle_dat0_pvld || swizzle_dat1_pvld;

// DATA FIFO read side: valid
assign out_dat_vld = dat_en & in_dat_vld;
assign out_dat_data = {swizzle_dat1_data,swizzle_dat0_data};
assign out_dat_mask = {swizzle_dat1_mask,swizzle_dat0_mask};

// calculate how many trans to be split
assign is_single_tran = (stt_offset + in_cmd_size) < 8;

assign ftran_size[2:0] = is_single_tran ? size_offset : 3'd7-stt_offset;

assign ltran_size[2:0] = is_single_tran ? size_offset : end_offset;
assign mtran_num = in_cmd_size - ftran_size - ltran_size - 1;

//================
// Beat Count: to count data per split req
//================
assign {mon_out_beats_c,beat_size[1:0]} = out_size[2:1] + out_cmd_inc;
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
  nv_assert_never #(0,0,"should never overflow")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, mon_out_beats_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_count <= {2{1'b0}};
  end else begin
    if (bpt2arb_dat_accept) begin
        if (is_last_beat) begin
            beat_count <= 0; 
        end else begin
            beat_count <= beat_count + 1;
        end
    end
  end
end
assign is_last_beat = (beat_count==beat_size);

// in AXI format
//================
// bsp out: size: this is in unit of 64B, including masked 32B data
//================
always @(
  is_ftran
  or ftran_size
  or is_mtran
  or is_ltran
  or ltran_size
  ) begin
    out_size = {3{`tick_x_or_0}};
    if (is_ftran) begin
        out_size = ftran_size;
    end else if (is_mtran) begin
        out_size = 3'd7;
    end else if (is_ltran) begin
        out_size = ltran_size;
    end
end

//================
// bpt2arb: addr
//================
always @(posedge nvdla_core_clk) begin
    if (bpt2arb_cmd_accept) begin
        if (is_ftran) begin
            out_addr <= in_cmd_addr + ((ftran_size+1)<<5);
        end else begin
            out_addr <= out_addr + 256;
        end
    end
end

//================
// tran count
//================
always @(
  is_single_tran
  or mtran_num
  ) begin
    if (is_single_tran) begin
        req_num = 1;
    end else if (mtran_num==0) begin
        req_num = 2;
    end else begin
        req_num = 2 + mtran_num[12:3];
    end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_count <= {11{1'b0}};
  end else begin
    if (bpt2arb_dat_accept & is_last_beat) begin
        if (is_ltran) begin
            req_count <= 0;
        end else begin
            req_count <= req_count + 1;
        end
    end
  end
end
assign is_ftran = (req_count==0);
assign is_mtran = (req_count>0 && req_count<req_num-1);
assign is_ltran = (req_count==req_num-1);

// CMD PATH
assign out_cmd_vld  = cmd_en & in_cmd_vld;
assign out_cmd_addr = (is_ftran) ? in_cmd_addr : out_addr;
assign out_cmd_size = out_size;
assign out_cmd_inc  = is_ltran & is_ftran & large_req_grow;
assign out_cmd_swizzle = is_swizzle;
assign out_cmd_odd   = in_size_is_odd;
assign out_cmd_ftran = is_ftran;
assign out_cmd_ltran = is_ltran;
//assign out_cmd_user_size = {1'b0,beat_size}; //stepheng.
assign out_cmd_axid = axid;
assign out_cmd_require_ack = in_cmd_require_ack & is_ltran;
assign bpt2arb_cmd_valid = out_cmd_vld;

// PKT_PACK_WIRE( cvt_write_cmd , out_cmd_ , bpt2arb_cmd_pd )
assign      bpt2arb_cmd_pd[3:0] =    out_cmd_axid[3:0];
assign      bpt2arb_cmd_pd[4] =    out_cmd_require_ack ;
assign      bpt2arb_cmd_pd[68:5] =    out_cmd_addr[63:0];
assign      bpt2arb_cmd_pd[71:69] =    out_cmd_size[2:0];
assign      bpt2arb_cmd_pd[72] =    out_cmd_swizzle ;
assign      bpt2arb_cmd_pd[73] =    out_cmd_odd ;
assign      bpt2arb_cmd_pd[74] =    out_cmd_inc ;
assign      bpt2arb_cmd_pd[75] =    out_cmd_ltran ;
assign      bpt2arb_cmd_pd[76] =    out_cmd_ftran ;
assign bpt2arb_cmd_accept = bpt2arb_cmd_valid & bpt2arb_cmd_ready;

// DATA PATH
assign bpt2arb_dat_valid = out_dat_vld;

// PKT_PACK_WIRE( cvt_write_data , out_dat_ , bpt2arb_dat_pd )
assign      bpt2arb_dat_pd[511:0] =    out_dat_data[511:0];
assign      bpt2arb_dat_pd[513:512] =    out_dat_mask[1:0];
assign bpt2arb_dat_accept = bpt2arb_dat_valid & bpt2arb_dat_ready;

endmodule // NV_NVDLA_CVIF_WRITE_IG_bpt



// **************************************************************************************************************
// Generated by ::pipe -m -bc -os ipipe_pd_p (ipipe_vld_p,ipipe_rdy_p) <= dma2bpt_req_pd[514:0] (dma2bpt_req_valid,dma2bpt_req_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_WRITE_IG_BPT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma2bpt_req_pd
  ,dma2bpt_req_valid
  ,ipipe_rdy_p
  ,dma2bpt_req_ready
  ,ipipe_pd_p
  ,ipipe_vld_p
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [514:0] dma2bpt_req_pd;
input          dma2bpt_req_valid;
input          ipipe_rdy_p;
output         dma2bpt_req_ready;
output [514:0] ipipe_pd_p;
output         ipipe_vld_p;
reg            dma2bpt_req_ready;
reg    [514:0] ipipe_pd_p;
reg            ipipe_vld_p;
reg    [514:0] p1_pipe_data;
reg    [514:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg    [514:0] p1_pipe_skid_data;
reg            p1_pipe_skid_ready;
reg            p1_pipe_skid_valid;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [514:0] p1_skid_data;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     dma2bpt_req_valid
  or p1_pipe_rand_ready
  or dma2bpt_req_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = dma2bpt_req_valid;
  dma2bpt_req_ready = p1_pipe_rand_ready;
  p1_pipe_rand_data = dma2bpt_req_pd[514:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : dma2bpt_req_valid;
  dma2bpt_req_ready = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : dma2bpt_req_pd[514:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p1_pipe_stall_cycles;
integer p1_pipe_stall_probability;
integer p1_pipe_stall_cycles_min;
integer p1_pipe_stall_cycles_max;
initial begin
  p1_pipe_stall_cycles = 0;
  p1_pipe_stall_probability = 0;
  p1_pipe_stall_cycles_min = 1;
  p1_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or dma2bpt_req_valid
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && dma2bpt_req_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p1_pipe_rand_poised) begin
    if (p1_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p1_pipe_stall_cycles <= prand_inst1(p1_pipe_stall_cycles_min, p1_pipe_stall_cycles_max);
    end
  end else if (p1_pipe_rand_active) begin
    p1_pipe_stall_cycles <= p1_pipe_stall_cycles - 1;
  end else begin
    p1_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_pipe_rand_valid)? p1_pipe_rand_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_pipe_rand_ready = p1_pipe_ready_bc;
end
//## pipe (1) skid buffer
always @(
  p1_pipe_valid
  or p1_skid_ready_flop
  or p1_pipe_skid_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_valid && p1_skid_ready_flop && !p1_pipe_skid_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_pipe_skid_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_pipe_skid_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_valid
  or p1_skid_valid
  or p1_pipe_data
  or p1_skid_data
  ) begin
  p1_pipe_skid_valid = (p1_skid_ready_flop)? p1_pipe_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_pipe_skid_data = (p1_skid_ready_flop)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) output
always @(
  p1_pipe_skid_valid
  or ipipe_rdy_p
  or p1_pipe_skid_data
  ) begin
  ipipe_vld_p = p1_pipe_skid_valid;
  p1_pipe_skid_ready = ipipe_rdy_p;
  ipipe_pd_p = p1_pipe_skid_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (ipipe_vld_p^ipipe_rdy_p^dma2bpt_req_valid^dma2bpt_req_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (dma2bpt_req_valid && !dma2bpt_req_ready), (dma2bpt_req_valid), (dma2bpt_req_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CVIF_WRITE_IG_BPT_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is ipipe_pd (ipipe_vld,ipipe_rdy) <= ipipe_pd_p[514:0] (ipipe_vld_p,ipipe_rdy_p)
// **************************************************************************************************************
module NV_NVDLA_CVIF_WRITE_IG_BPT_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,ipipe_pd_p
  ,ipipe_rdy
  ,ipipe_vld_p
  ,ipipe_pd
  ,ipipe_rdy_p
  ,ipipe_vld
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [514:0] ipipe_pd_p;
input          ipipe_rdy;
input          ipipe_vld_p;
output [514:0] ipipe_pd;
output         ipipe_rdy_p;
output         ipipe_vld;
reg    [514:0] ipipe_pd;
reg            ipipe_rdy_p;
reg            ipipe_vld;
reg    [514:0] p2_pipe_data;
reg    [514:0] p2_pipe_rand_data;
reg            p2_pipe_rand_ready;
reg            p2_pipe_rand_valid;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [514:0] p2_skid_data;
reg    [514:0] p2_skid_pipe_data;
reg            p2_skid_pipe_ready;
reg            p2_skid_pipe_valid;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     ipipe_vld_p
  or p2_pipe_rand_ready
  or ipipe_pd_p
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = ipipe_vld_p;
  ipipe_rdy_p = p2_pipe_rand_ready;
  p2_pipe_rand_data = ipipe_pd_p[514:0];
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : ipipe_vld_p;
  ipipe_rdy_p = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : ipipe_pd_p[514:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p2_pipe_stall_cycles;
integer p2_pipe_stall_probability;
integer p2_pipe_stall_cycles_min;
integer p2_pipe_stall_cycles_max;
initial begin
  p2_pipe_stall_cycles = 0;
  p2_pipe_stall_probability = 0;
  p2_pipe_stall_cycles_min = 1;
  p2_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or ipipe_vld_p
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && ipipe_vld_p === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p2_pipe_rand_poised) begin
    if (p2_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p2_pipe_stall_cycles <= prand_inst1(p2_pipe_stall_cycles_min, p2_pipe_stall_cycles_max);
    end
  end else if (p2_pipe_rand_active) begin
    p2_pipe_stall_cycles <= p2_pipe_stall_cycles - 1;
  end else begin
    p2_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (2) skid buffer
always @(
  p2_pipe_rand_valid
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_rand_valid && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_rand_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_rand_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_rand_valid
  or p2_skid_valid
  or p2_pipe_rand_data
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? p2_pipe_rand_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_skid_pipe_valid)? p2_skid_pipe_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_skid_pipe_ready = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or ipipe_rdy
  or p2_pipe_data
  ) begin
  ipipe_vld = p2_pipe_valid;
  p2_pipe_ready = ipipe_rdy;
  ipipe_pd = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (ipipe_vld^ipipe_rdy^ipipe_vld_p^ipipe_rdy_p)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (ipipe_vld_p && !ipipe_rdy_p), (ipipe_vld_p), (ipipe_rdy_p)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CVIF_WRITE_IG_BPT_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc in_cmd_pd (in_cmd_vld,in_cmd_rdy) <= ipipe_cmd_pd[77:0] (ipipe_cmd_vld,ipipe_cmd_rdy)
// **************************************************************************************************************
module NV_NVDLA_CVIF_WRITE_IG_BPT_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,in_cmd_rdy
  ,ipipe_cmd_pd
  ,ipipe_cmd_vld
  ,in_cmd_pd
  ,in_cmd_vld
  ,ipipe_cmd_rdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         in_cmd_rdy;
input  [77:0] ipipe_cmd_pd;
input         ipipe_cmd_vld;
output [77:0] in_cmd_pd;
output        in_cmd_vld;
output        ipipe_cmd_rdy;
reg    [77:0] in_cmd_pd;
reg           in_cmd_vld;
reg           ipipe_cmd_rdy;
reg    [77:0] p3_pipe_data;
reg    [77:0] p3_pipe_rand_data;
reg           p3_pipe_rand_ready;
reg           p3_pipe_rand_valid;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg           p3_pipe_valid;
//## pipe (3) randomizer
`ifndef SYNTHESIS
reg p3_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p3_pipe_rand_active
  or 
     `endif
     ipipe_cmd_vld
  or p3_pipe_rand_ready
  or ipipe_cmd_pd
  ) begin
  `ifdef SYNTHESIS
  p3_pipe_rand_valid = ipipe_cmd_vld;
  ipipe_cmd_rdy = p3_pipe_rand_ready;
  p3_pipe_rand_data = ipipe_cmd_pd[77:0];
  `else
  // VCS coverage off
  p3_pipe_rand_valid = (p3_pipe_rand_active)? 1'b0 : ipipe_cmd_vld;
  ipipe_cmd_rdy = (p3_pipe_rand_active)? 1'b0 : p3_pipe_rand_ready;
  p3_pipe_rand_data = (p3_pipe_rand_active)?  'bx : ipipe_cmd_pd[77:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p3_pipe_stall_cycles;
integer p3_pipe_stall_probability;
integer p3_pipe_stall_cycles_min;
integer p3_pipe_stall_cycles_max;
initial begin
  p3_pipe_stall_cycles = 0;
  p3_pipe_stall_probability = 0;
  p3_pipe_stall_cycles_min = 1;
  p3_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_bpt_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p3_pipe_rand_enable;
reg p3_pipe_rand_poised;
always @(
  p3_pipe_stall_cycles
  or p3_pipe_stall_probability
  or ipipe_cmd_vld
  ) begin
  p3_pipe_rand_active = p3_pipe_stall_cycles != 0;
  p3_pipe_rand_enable = p3_pipe_stall_probability != 0;
  p3_pipe_rand_poised = p3_pipe_rand_enable && !p3_pipe_rand_active && ipipe_cmd_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p3_pipe_rand_poised) begin
    if (p3_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p3_pipe_stall_cycles <= prand_inst1(p3_pipe_stall_cycles_min, p3_pipe_stall_cycles_max);
    end
  end else if (p3_pipe_rand_active) begin
    p3_pipe_stall_cycles <= p3_pipe_stall_cycles - 1;
  end else begin
    p3_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (3) valid-ready-bubble-collapse
always @(
  p3_pipe_ready
  or p3_pipe_valid
  ) begin
  p3_pipe_ready_bc = p3_pipe_ready || !p3_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && p3_pipe_rand_valid)? p3_pipe_rand_data : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  p3_pipe_rand_ready = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or in_cmd_rdy
  or p3_pipe_data
  ) begin
  in_cmd_vld = p3_pipe_valid;
  p3_pipe_ready = in_cmd_rdy;
  in_cmd_pd = p3_pipe_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (in_cmd_vld^in_cmd_rdy^ipipe_cmd_vld^ipipe_cmd_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_10x (nvdla_core_clk, `ASSERT_RESET, (ipipe_cmd_vld && !ipipe_cmd_rdy), (ipipe_cmd_vld), (ipipe_cmd_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CVIF_WRITE_IG_BPT_pipe_p3


//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus dfifo_wr -rd_pipebus dfifo_rd -wr_reg -d 1 -ram_bypass -rd_reg -rd_busy_reg -w 256 -wr_idle -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dfifo_wr_prdy
    , dfifo_wr_idle
    , dfifo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , dfifo_wr_pause
`endif
    , dfifo_wr_pd
    , dfifo_rd_prdy
    , dfifo_rd_pvld
    , dfifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dfifo_wr_prdy;
output        dfifo_wr_idle;
input         dfifo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         dfifo_wr_pause;
`endif
input  [255:0] dfifo_wr_pd;
input         dfifo_rd_prdy;
output        dfifo_rd_pvld;
output [255:0] dfifo_rd_pd;
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
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
reg wr_pause_rand_in;
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        dfifo_wr_pvld_in;                                // registered dfifo_wr_pvld
reg        wr_busy_in;                              // inputs being held this cycle?
assign     dfifo_wr_prdy = !wr_busy_in;
wire       dfifo_wr_busy_next;                           // fwd: fifo busy next?

// factor for better timing with distant dfifo_wr_pvld signal
wire       wr_busy_in_next_wr_req_eq_1 = dfifo_wr_busy_next;
wire       wr_busy_in_next_wr_req_eq_0 = (dfifo_wr_pvld_in && dfifo_wr_busy_next) && !wr_reserving;
`ifdef FV_RAND_WR_PAUSE
wire       wr_busy_in_next = (dfifo_wr_pvld? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                             || dfifo_wr_pause ;
`else
wire       wr_busy_in_next = (dfifo_wr_pvld? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                              
                            // synopsys translate_off
                            `ifndef SYNTH_LEVEL1_COMPILE
                            `ifndef SYNTHESIS
                            || wr_pause_rand
                            `endif
                            `endif
                            // synopsys translate_on
                             ;
`endif
wire       wr_busy_in_int;
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_wr_pvld_in <=  1'b0;
        wr_busy_in <=  1'b0;
    end else begin
        wr_busy_in <=  wr_busy_in_next;
        if ( !wr_busy_in_int ) begin
            dfifo_wr_pvld_in  <=  dfifo_wr_pvld && !wr_busy_in;
        end
        //synopsys translate_off
            else if ( wr_busy_in_int ) begin
        end else begin
            dfifo_wr_pvld_in  <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

reg        dfifo_wr_busy_int;		        	// copy for internal use
assign       wr_reserving = dfifo_wr_pvld_in && !dfifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg        dfifo_wr_count;			// write-side count

wire       wr_count_next_wr_popping = wr_reserving ? dfifo_wr_count : (dfifo_wr_count - 1'd1); // spyglass disable W164a W484
wire       wr_count_next_no_wr_popping = wr_reserving ? (dfifo_wr_count + 1'd1) : dfifo_wr_count; // spyglass disable W164a W484
wire       wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_1 = ( wr_count_next_no_wr_popping == 1'd1 );
wire wr_count_next_is_1 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_1;
wire       wr_limit_muxed;  // muxed with simulation/emulation overrides
wire       wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
assign     dfifo_wr_busy_next = wr_count_next_is_1 || // busy next cycle?
                          (wr_limit_reg != 1'd0 &&      // check dfifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
assign     wr_busy_in_int = dfifo_wr_pvld_in && dfifo_wr_busy_int;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_wr_busy_int <=  1'b0;
        dfifo_wr_count <=  1'd0;
    end else begin
	dfifo_wr_busy_int <=  dfifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dfifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dfifo_wr_count <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dfifo_wr_pvld_in

//
// RAM
//

wire rd_popping;

wire ram_we = wr_pushing && (dfifo_wr_count > 1'd0 || !rd_popping);   // note: write occurs next cycle
wire ram_iwe = !wr_busy_in && dfifo_wr_pvld;  
wire [255:0] dfifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_flopram_rwsa_1x256 ram (
      .clk( nvdla_core_clk )
    , .clk_mgated( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dfifo_wr_pd )
    , .iwe        ( ram_iwe )
    , .we        ( ram_we )
    , .ra        ( (dfifo_wr_count == 0) ? 1'd1 : 1'b0 )
    , .dout        ( dfifo_rd_pd_p )
    );


//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

reg        dfifo_rd_prdy_d;				// dfifo_rd_prdy registered in cleanly

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_prdy_d <=  1'b1;
    end else begin
        dfifo_rd_prdy_d <=  dfifo_rd_prdy;
    end
end

wire       dfifo_rd_prdy_d_o;			// combinatorial rd_busy

reg        dfifo_rd_pvld_int;			// internal copy of dfifo_rd_pvld

assign     dfifo_rd_pvld = dfifo_rd_pvld_int;
wire       dfifo_rd_pvld_p; 		// data out of fifo is valid

reg        dfifo_rd_pvld_int_o;	// internal copy of dfifo_rd_pvld_o
wire       dfifo_rd_pvld_o = dfifo_rd_pvld_int_o;
assign     rd_popping = dfifo_rd_pvld_p && !(dfifo_rd_pvld_int_o && !dfifo_rd_prdy_d_o);

reg        dfifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire       rd_count_p_next_rd_popping = rd_pushing ? dfifo_rd_count_p : 
                                                                (dfifo_rd_count_p - 1'd1);
wire       rd_count_p_next_no_rd_popping =  rd_pushing ? (dfifo_rd_count_p + 1'd1) : 
                                                                    dfifo_rd_count_p;
// spyglass enable_block W164a W484
wire       rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     dfifo_rd_pvld_p = dfifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_count_p <=  1'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dfifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dfifo_rd_count_p <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end


// 
// SKID for -rd_busy_reg
//
reg [255:0]  dfifo_rd_pd_o;         // output data register
wire        rd_req_next_o = (dfifo_rd_pvld_p || (dfifo_rd_pvld_int_o && !dfifo_rd_prdy_d_o)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_pvld_int_o <=  1'b0;
    end else begin
        dfifo_rd_pvld_int_o <=  rd_req_next_o;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (dfifo_rd_pvld_int && rd_req_next_o && rd_popping) ) begin
        dfifo_rd_pd_o <=  dfifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((dfifo_rd_pvld_int && rd_req_next_o && rd_popping)) ) begin
    end else begin
        dfifo_rd_pd_o <=  {256{`x_or_0}};
    end
    //synopsys translate_on

end

//
// FINAL OUTPUT
//
reg [255:0]  dfifo_rd_pd;				// output data register
reg        dfifo_rd_pvld_int_d;			// so we can bubble-collapse dfifo_rd_prdy_d
assign     dfifo_rd_prdy_d_o = !((dfifo_rd_pvld_o && dfifo_rd_pvld_int_d && !dfifo_rd_prdy_d ) );
wire       rd_req_next = (!dfifo_rd_prdy_d_o ? dfifo_rd_pvld_o : dfifo_rd_pvld_p) ;  

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_pvld_int <=  1'b0;
        dfifo_rd_pvld_int_d <=  1'b0;
    end else begin
        if ( !dfifo_rd_pvld_int || dfifo_rd_prdy ) begin
	    dfifo_rd_pvld_int <=  rd_req_next;
        end
        //synopsys translate_off
            else if ( !(!dfifo_rd_pvld_int || dfifo_rd_prdy) ) begin
        end else begin
            dfifo_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on


        dfifo_rd_pvld_int_d <=  dfifo_rd_pvld_int;
    end
end

always @( posedge nvdla_core_clk ) begin
    if ( rd_req_next && (!dfifo_rd_pvld_int || dfifo_rd_prdy ) ) begin
        case (!dfifo_rd_prdy_d_o) 
            1'b0:    dfifo_rd_pd <=  dfifo_rd_pd_p;
            1'b1:    dfifo_rd_pd <=  dfifo_rd_pd_o;
            //VCS coverage off
            default: dfifo_rd_pd <=  {256{`x_or_0}};
            //VCS coverage on
        endcase
    end
    //synopsys translate_off
        else if ( !(rd_req_next && (!dfifo_rd_pvld_int || dfifo_rd_prdy)) ) begin
    end else begin
        dfifo_rd_pd <=  {256{`x_or_0}};
    end
    //synopsys translate_on

end

//
// Read-side Idle Calculation
//
wire   rd_idle = !dfifo_rd_pvld_int_o && !dfifo_rd_pvld_int && !rd_pushing && dfifo_rd_count_p == 0;


//
// Write-Side Idle Calculation
//
wire dfifo_wr_idle_d0 = !dfifo_wr_pvld_in && rd_idle && !wr_pushing && dfifo_wr_count == 0
// synopsys translate_off
 `ifndef SYNTH_LEVEL1_COMPILE
 `ifndef SYNTHESIS
    && !wr_pause_rand_in
  `endif
  `endif
// synopsys translate_on
;
wire dfifo_wr_idle = dfifo_wr_idle_d0;


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

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dfifo_wr_pvld_in && !dfifo_wr_busy_int) || (dfifo_wr_busy_int != dfifo_wr_busy_next)) || (rd_pushing || rd_popping || (dfifo_rd_pvld_int && dfifo_rd_prdy_d) || (dfifo_rd_pvld_int_o && dfifo_rd_prdy_d_o)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_wr_limit : 1'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 1'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 1'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 1'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg       wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 1'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( dfifo_wr_pvld && !(!dfifo_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst2(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst3(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_in <=  1'b0;
    end else begin
        wr_pause_rand_in <=  wr_pause_rand;
    end
end

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {31'd0, (wr_limit_reg == 1'd0) ? 1'd1 : wr_limit_reg} )
    , .curr	( {31'd0, dfifo_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

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
//   set_boundary_optimization find(design, "NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed2;
reg prand_initialized2;
reg prand_no_rollpli2;
`endif
`endif
`endif

function [31:0] prand_inst2;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst2 = min;
`else
`ifdef SYNTHESIS
        prand_inst2 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized2 !== 1'b1) begin
            prand_no_rollpli2 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli2)
                prand_local_seed2 = {$prand_get_seed(2), 16'b0};
            prand_initialized2 = 1'b1;
        end
        if (prand_no_rollpli2) begin
            prand_inst2 = min;
        end else begin
            diff = max - min + 1;
            prand_inst2 = min + prand_local_seed2[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed2 = prand_local_seed2 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst2 = min;
`else
        prand_inst2 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed3;
reg prand_initialized3;
reg prand_no_rollpli3;
`endif
`endif
`endif

function [31:0] prand_inst3;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst3 = min;
`else
`ifdef SYNTHESIS
        prand_inst3 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized3 !== 1'b1) begin
            prand_no_rollpli3 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli3)
                prand_local_seed3 = {$prand_get_seed(3), 16'b0};
            prand_initialized3 = 1'b1;
        end
        if (prand_no_rollpli3) begin
            prand_inst3 = min;
        end else begin
            diff = max - min + 1;
            prand_inst3 = min + prand_local_seed3[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed3 = prand_local_seed3 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst3 = min;
`else
        prand_inst3 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo

// 
// Flop-Based RAM (with internal wr_reg)
//
module NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_flopram_rwsa_1x256 (
      clk
    , clk_mgated
    , pwrbus_ram_pd
    , di
    , iwe
    , we
    , ra
    , dout
    );

input  clk;  // write clock
input  clk_mgated;  // write clock mgated
input [31 : 0] pwrbus_ram_pd;
input  [255:0] di;
input  iwe;
input  we;
input  [0:0] ra;
output [255:0] dout;

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

reg [255:0] di_d;  // -wr_reg

always @( posedge clk ) begin
    if ( iwe ) begin
        di_d <=  di; // -wr_reg
    end
end
reg [255:0] ram_ff0;

always @( posedge clk_mgated ) begin
    if ( we ) begin
	ram_ff0 <=  di_d;
    end
end

reg [255:0] dout;

always @(*) begin
    case( ra ) 
    1'd0:       dout = ram_ff0;
    1'd1:       dout = di_d;
    //VCS coverage off
    default:    dout = {256{`x_or_0}};
    //VCS coverage on
    endcase
end

endmodule // NV_NVDLA_CVIF_WRITE_IG_BPT_dfifo_flopram_rwsa_1x256

