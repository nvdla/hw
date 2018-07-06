// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_WRITE_IG_bpt.v
#include "NV_NVDLA_MCIF_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_WRITE_IG_bpt (
   nvdla_core_clk    //|< i
  ,nvdla_core_rstn   //|< i
  ,pwrbus_ram_pd     //|< i
  ,dma2bpt_req_valid //|< i
  ,dma2bpt_req_ready //|> o
  ,dma2bpt_req_pd    //|< i
  ,bpt2arb_cmd_valid //|> o
  ,bpt2arb_cmd_ready //|< i
  ,bpt2arb_cmd_pd    //|> o
  ,bpt2arb_dat_valid //|> o
  ,bpt2arb_dat_ready //|< i
  ,bpt2arb_dat_pd    //|> o
  ,axid              //|< i
  );
//
// NV_NVDLA_MCIF_WRITE_IG_bpt_ports.v
//
input  nvdla_core_clk;   
input  nvdla_core_rstn; 
input [31:0] pwrbus_ram_pd;
input [3:0]  axid;

input          dma2bpt_req_valid;  
output         dma2bpt_req_ready;  
input  [NVDLA_DMA_WR_REQ-1:0] dma2bpt_req_pd;    

output        bpt2arb_cmd_valid;  
input         bpt2arb_cmd_ready;  
output [NVDLA_DMA_WR_IG_PW-1:0] bpt2arb_cmd_pd;

output         bpt2arb_dat_valid;  
input          bpt2arb_dat_ready;  
output [NVDLA_DMA_WR_REQ-2:0] bpt2arb_dat_pd;


reg          cmd_en;
reg          dat_en;
wire [NVDLA_DMA_WR_REQ-1:0] ipipe_pd;
wire [NVDLA_DMA_WR_REQ-1:0] ipipe_pd_p;
wire         ipipe_rdy;
wire         ipipe_rdy_p;
wire         ipipe_vld;
wire         ipipe_vld_p;
wire  [NVDLA_DMA_WR_CMD-1:0] ipipe_cmd_pd;
wire         ipipe_cmd_vld;
wire         ipipe_cmd_rdy;
wire  [NVDLA_DMA_WR_CMD-1:0] in_cmd_pd;
wire  [NVDLA_DMA_WR_CMD-1:0] in_cmd_vld_pd;
wire         in_cmd_vld;
wire         in_cmd_rdy;
wire  [NVDLA_MEM_ADDRESS_WIDTH-1:0] in_cmd_addr;
wire  [NVDLA_DMA_WR_SIZE-1:0] in_cmd_size;
wire         in_cmd_require_ack;
wire   [NVDLA_DMA_MASK_BIT-1:0] dfifo_wr_mask;
wire [NVDLA_MEMIF_WIDTH-1:0] dfifo_wr_data;
wire         dfifo_wr_prdy;
wire         dfifo_wr_pvld;
wire [NVDLA_MEMIF_WIDTH-1:0] dfifo_rd_data;
wire         dfifo_rd_pvld;
wire         dfifo_rd_prdy;
reg   [NVDLA_MEM_ADDRESS_WIDTH-1:0] out_addr;
wire   [2:0] out_size;
reg    [2:0] out_size_tmp;
reg   [NVDLA_DMA_WR_SIZE-1:0] req_count;
reg   [NVDLA_DMA_WR_SIZE-1:0] req_num;
reg    [2:0] beat_count;
wire   [2:0] beat_size;
wire         is_last_beat;
wire         bpt2arb_cmd_accept;
wire         bpt2arb_dat_accept;
#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
wire         mon_out_beats_c;
wire   [1:0] all_idle;
wire         bpt_idle_NC;
wire [NVDLA_MEMORY_ATOMIC_WIDTH-1:0] dfifo0_rd_pd;
wire         dfifo0_rd_prdy;
wire         dfifo0_rd_pvld;
wire         dfifo0_wr_idle;
wire [NVDLA_MEMORY_ATOMIC_WIDTH-1:0] dfifo0_wr_pd;
wire         dfifo0_wr_prdy;
wire         dfifo0_wr_pvld;
wire [NVDLA_MEMORY_ATOMIC_WIDTH-1:0] dfifo1_rd_pd;
wire         dfifo1_rd_prdy;
wire         dfifo1_rd_pvld;
wire         dfifo1_wr_idle;
wire [NVDLA_MEMORY_ATOMIC_WIDTH-1:0] dfifo1_wr_pd;
wire         dfifo1_wr_prdy;
wire         dfifo1_wr_pvld;
wire         mon_dfifo0_wr_pd;
wire         mon_dfifo1_wr_pd;
reg          in_dat_vld;
reg   [NVDLA_DMA_WR_SIZE-1:0] in_dat_cnt;
reg          in_dat1_dis;
wire [NVDLA_MEMORY_ATOMIC_WIDTH-1:0] in_dat0_data;
wire         in_dat0_dis;
wire         in_dat0_en;
wire         in_dat0_mask;
wire         in_dat0_pvld;
wire [NVDLA_MEMORY_ATOMIC_WIDTH-1:0] in_dat1_data;
wire         in_dat1_en;
wire         in_dat1_mask;
wire         in_dat1_pvld;
wire  [NVDLA_DMA_WR_SIZE-1:0] in_dat_beats;
wire         in_dat_first;
wire         in_dat_last;
wire [NVDLA_MEMORY_ATOMIC_WIDTH-1:0] swizzle_dat0_data;
wire         swizzle_dat0_mask;
wire [NVDLA_MEMORY_ATOMIC_WIDTH-1:0] swizzle_dat1_data;
wire         swizzle_dat1_mask;
#endif
wire   [NVDLA_MCIF_BURST_SIZE_LOG2-1:0] stt_offset;
wire   [NVDLA_MCIF_BURST_SIZE_LOG2-1:0] size_offset;
wire   [NVDLA_MCIF_BURST_SIZE_LOG2-1:0] end_offset;
wire   [NVDLA_MCIF_BURST_SIZE_LOG2-1:0] ftran_size_tmp;
wire   [NVDLA_MCIF_BURST_SIZE_LOG2-1:0] ltran_size_tmp;
wire  [2:0]  ftran_size;
wire  [2:0]  ltran_size;
wire  [NVDLA_DMA_WR_SIZE-1:0] mtran_num;
wire         in_size_is_even;
wire         in_size_is_odd;
wire         is_ftran;
wire         is_ltran;
wire         is_mtran;
wire         is_single_tran;
wire         is_swizzle;
wire         large_req_grow;
wire         mon_end_offset_c;
wire  [NVDLA_MEM_ADDRESS_WIDTH-1:0] out_cmd_addr;
wire   [3:0] out_cmd_axid;
wire         out_cmd_ftran;
wire         out_cmd_inc;
wire         out_cmd_ltran;
wire         out_cmd_odd;
wire         out_cmd_require_ack;
wire   [2:0] out_cmd_size;
wire         out_cmd_swizzle;
wire   [2:0] out_cmd_user_size;
wire         out_cmd_vld;
wire [NVDLA_MEMIF_WIDTH-1:0] out_dat_data;
wire   [NVDLA_DMA_MASK_BIT-1:0] out_dat_mask;
wire         out_dat_vld;
    
//==================
// 1st Stage: REQ PIPE
NV_NVDLA_MCIF_WRITE_IG_BPT_pipe_p1 pipe_p1 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.dma2bpt_req_pd    (dma2bpt_req_pd)
  ,.dma2bpt_req_valid (dma2bpt_req_valid)     //|< i
  ,.dma2bpt_req_ready (dma2bpt_req_ready)     //|> o
  ,.ipipe_pd_p        (ipipe_pd_p)
  ,.ipipe_vld_p       (ipipe_vld_p)           //|> w
  ,.ipipe_rdy_p       (ipipe_rdy_p)           //|< w
  );

NV_NVDLA_MCIF_WRITE_IG_BPT_pipe_p2 pipe_p2 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.ipipe_pd_p        (ipipe_pd_p)
  ,.ipipe_vld_p       (ipipe_vld_p)           //|< w
  ,.ipipe_rdy_p       (ipipe_rdy_p)           //|> w
  ,.ipipe_pd          (ipipe_pd)
  ,.ipipe_vld         (ipipe_vld)             //|> w
  ,.ipipe_rdy         (ipipe_rdy)             //|< w
  );

assign  ipipe_cmd_vld = ipipe_vld && (ipipe_pd[NVDLA_DMA_WR_REQ-1]== 0);
assign  dfifo_wr_pvld = ipipe_vld && (ipipe_pd[NVDLA_DMA_WR_REQ-1]== 1);

assign  dfifo_wr_data = ipipe_pd[NVDLA_MEMIF_WIDTH-1:0];
assign  dfifo_wr_mask = ipipe_pd[NVDLA_MEMIF_WIDTH+NVDLA_DMA_MASK_BIT-1:NVDLA_MEMIF_WIDTH];

assign  ipipe_rdy = (ipipe_cmd_vld & ipipe_cmd_rdy) || (dfifo_wr_pvld & dfifo_wr_prdy); 

assign  ipipe_cmd_pd[NVDLA_DMA_WR_CMD-1:0] = ipipe_pd[NVDLA_DMA_WR_CMD-1:0]; 


NV_NVDLA_MCIF_WRITE_IG_BPT_pipe_p3 pipe_p3 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.ipipe_cmd_pd      (ipipe_cmd_pd)
  ,.ipipe_cmd_vld     (ipipe_cmd_vld)         //|< w
  ,.ipipe_cmd_rdy     (ipipe_cmd_rdy)         //|> w
  ,.in_cmd_pd         (in_cmd_pd)
  ,.in_cmd_vld        (in_cmd_vld)            //|> w
  ,.in_cmd_rdy        (in_cmd_rdy)            //|< w
  );

assign  in_cmd_rdy = is_ltran & is_last_beat & bpt2arb_dat_accept;
assign  in_cmd_vld_pd = {NVDLA_DMA_WR_CMD{in_cmd_vld}} & in_cmd_pd;

assign  in_cmd_addr[NVDLA_MEM_ADDRESS_WIDTH-1:0] =  in_cmd_vld_pd[NVDLA_MEM_ADDRESS_WIDTH-1:0];
assign  in_cmd_size[NVDLA_DMA_WR_SIZE-1:0] =  in_cmd_vld_pd[NVDLA_DMA_WR_CMD-2:NVDLA_MEM_ADDRESS_WIDTH];
assign  in_cmd_require_ack  = in_cmd_vld_pd[NVDLA_DMA_WR_CMD-1];


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
  wire cond_zzz_assert_always_1x = (in_cmd_addr[NVDLA_MEMORY_ATOMIC_LOG2-1:0] == 0);
  nv_assert_always #(0,0,"lower LSB should always be 0")      zzz_assert_always_1x (.clk(nvdla_core_clk), .reset_(`ASSERT_RESET), .test_expr(cond_zzz_assert_always_1x)); // spyglass disable W504 SelfDeterminedExpr-ML 
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


#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
//==================
//: my $hb;
//: my $lb;
//: for (my $i=0;$i<NVDLA_DMA_MASK_BIT;$i++) {
//: $hb = ($i +1) * NVDLA_MEMORY_ATOMIC_WIDTH;
//: $lb = ${i} * NVDLA_MEMORY_ATOMIC_WIDTH;
//: print "assign  dfifo${i}_wr_pd  = dfifo_wr_data[${hb}-1:${lb}]; \n";
//: }

assign dfifo0_wr_pvld = dfifo_wr_pvld && dfifo_wr_mask[0] && dfifo1_wr_prdy;
assign dfifo1_wr_pvld = dfifo_wr_pvld && dfifo_wr_mask[1] && dfifo0_wr_prdy;
assign dfifo_wr_prdy  = dfifo0_wr_prdy & dfifo1_wr_prdy;

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

NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo u_dfifo0 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.dfifo_wr_prdy     (dfifo0_wr_prdy)        //|> w
  ,.dfifo_wr_idle     (dfifo0_wr_idle)        //|> w
  ,.dfifo_wr_pvld     (dfifo0_wr_pvld)        //|< w
  ,.dfifo_wr_pd       (dfifo0_wr_pd)
  ,.dfifo_rd_prdy     (dfifo0_rd_prdy)        //|< w
  ,.dfifo_rd_pvld     (dfifo0_rd_pvld)        //|> w
  ,.dfifo_rd_pd       (dfifo0_rd_pd)
  ,.pwrbus_ram_pd     (pwrbus_ram_pd)
  );

NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo u_dfifo1 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.dfifo_wr_prdy     (dfifo1_wr_prdy)        //|> w
  ,.dfifo_wr_idle     (dfifo1_wr_idle)        //|> w
  ,.dfifo_wr_pvld     (dfifo1_wr_pvld)        //|< w
  ,.dfifo_wr_pd       (dfifo1_wr_pd)
  ,.dfifo_rd_prdy     (dfifo1_rd_prdy)        //|< w
  ,.dfifo_rd_pvld     (dfifo1_rd_pvld)        //|> w
  ,.dfifo_rd_pd       (dfifo1_rd_pd)
  ,.pwrbus_ram_pd     (pwrbus_ram_pd)
  );


assign all_idle[1:0] = {
  dfifo1_wr_idle
  ,dfifo0_wr_idle
  };
assign bpt_idle_NC = &all_idle;
#else 

NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo u_dfifo (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.dfifo_wr_pvld     (dfifo_wr_pvld)        //|< w
  ,.dfifo_wr_prdy     (dfifo_wr_prdy)        //|> w
  ,.dfifo_wr_pd       (dfifo_wr_data)
  ,.dfifo_rd_prdy     (dfifo_rd_prdy)        //|< w
  ,.dfifo_rd_pvld     (dfifo_rd_pvld)        //|> w
  ,.dfifo_rd_pd       (dfifo_rd_data)
  );

#endif

//==================
// in_cmd analysis to determine how to pop data from dFIFO
#if (NVDLA_MCIF_BURST_SIZE > 1)
assign stt_offset[NVDLA_MCIF_BURST_SIZE_LOG2-1:0]  = in_cmd_addr[NVDLA_MEMORY_ATOMIC_LOG2+NVDLA_MCIF_BURST_SIZE_LOG2-1:NVDLA_MEMORY_ATOMIC_LOG2];
assign size_offset[NVDLA_MCIF_BURST_SIZE_LOG2-1:0] = in_cmd_size[NVDLA_MCIF_BURST_SIZE_LOG2-1:0];
assign {mon_end_offset_c, end_offset[NVDLA_MCIF_BURST_SIZE_LOG2-1:0]} = stt_offset + size_offset;

// calculate how many trans to be split
assign is_single_tran  = (stt_offset + in_cmd_size) < NVDLA_MCIF_BURST_SIZE;
assign ftran_size_tmp[NVDLA_MCIF_BURST_SIZE_LOG2-1:0] = is_single_tran ? size_offset : NVDLA_MCIF_BURST_SIZE-1-stt_offset;
assign ltran_size_tmp[NVDLA_MCIF_BURST_SIZE_LOG2-1:0] = is_single_tran ? size_offset : end_offset;

assign ftran_size[2:0] = {{(3-NVDLA_MCIF_BURST_SIZE_LOG2){1'b0}},ftran_size_tmp};
assign ltran_size[2:0] = {{(3-NVDLA_MCIF_BURST_SIZE_LOG2){1'b0}},ltran_size_tmp};
assign mtran_num = in_cmd_size - ftran_size - ltran_size - 1;
#else
assign ftran_size[2:0] = 3'b0; 
assign ltran_size[2:0] = 3'b0;
assign mtran_num = in_cmd_size - 1;
#endif


#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
assign is_swizzle      = (stt_offset[0]==1); 
assign in_size_is_odd  = (in_cmd_size[0]==0);
assign in_size_is_even = (in_cmd_size[0]==1);
assign large_req_grow  = is_swizzle & in_size_is_even;

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

assign in_dat_last  = (in_dat_cnt==in_dat_beats);
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

// vld & data & mask
assign in_dat0_pvld = dfifo0_rd_pvld & in_dat0_en;
assign in_dat0_data = dfifo0_rd_pd;
assign in_dat0_mask = in_dat0_en;

assign in_dat1_pvld = dfifo1_rd_pvld & in_dat1_en;
assign in_dat1_data = dfifo1_rd_pd;
assign in_dat1_mask = in_dat1_en;

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
assign swizzle_dat0_data = is_swizzle ? in_dat1_data : in_dat0_data;
assign swizzle_dat0_mask = is_swizzle ? in_dat1_mask : in_dat0_mask;

assign swizzle_dat1_data = is_swizzle ? in_dat0_data : in_dat1_data;
assign swizzle_dat1_mask = is_swizzle ? in_dat0_mask : in_dat1_mask;

// DATA FIFO read side: valid
assign out_dat_vld = dat_en & in_dat_vld;
assign out_dat_data = {swizzle_dat1_data,swizzle_dat0_data};
assign out_dat_mask = {swizzle_dat1_mask,swizzle_dat0_mask};


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

#else 

assign dfifo_rd_prdy = dat_en & bpt2arb_dat_ready;
// DATA FIFO read side: valid
assign out_dat_vld  = dat_en & dfifo_rd_pvld;
assign out_dat_data = dfifo_rd_data;
assign out_dat_mask = dfifo_rd_pvld; //dfifo_rd_mask;

assign beat_size = out_size; 
#endif


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


//================
// Beat Count: to count data per split req
//================
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
#if (NVDLA_MCIF_BURST_SIZE > 1)
always @(
  is_ftran
  or ftran_size
  or is_mtran
  or is_ltran
  or ltran_size
  ) begin
    out_size_tmp = {3{`tick_x_or_0}};
    if (is_ftran) begin
        out_size_tmp = ftran_size;
    end else if (is_mtran) begin
        out_size_tmp = NVDLA_MCIF_BURST_SIZE-1; //3'd7;
    end else if (is_ltran) begin
        out_size_tmp = ltran_size;
    end
end
assign out_size = out_size_tmp;
#else 
assign out_size = 3'h0;
#endif


//================
// bpt2arb: addr
//================
always @(posedge nvdla_core_clk) begin
    if (bpt2arb_cmd_accept) begin
        if (is_ftran) begin
            out_addr <= in_cmd_addr + ((ftran_size+1)<<NVDLA_MEMORY_ATOMIC_LOG2);
        end else begin
            out_addr <= out_addr + (NVDLA_MCIF_BURST_SIZE<<NVDLA_MEMORY_ATOMIC_LOG2); //256;
        end
    end
end

//================
// tran count
//================
#if (NVDLA_MCIF_BURST_SIZE > 1)
always @(
  is_single_tran
  or mtran_num
  ) begin
    if (is_single_tran) begin
        req_num = 0;
    end else begin
        req_num = 1 + mtran_num[12:NVDLA_MCIF_BURST_SIZE_LOG2]; //3];
    end
end
#else
always @( * ) begin
       req_num = in_cmd_size;
end
#endif


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_count <= {13{1'b0}};
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
assign   is_ftran = (req_count==0);
assign   is_mtran = (req_count>0 && req_count<req_num);
assign   is_ltran = (req_count==req_num);

assign   out_cmd_vld  = cmd_en & in_cmd_vld;
assign   out_cmd_addr = (is_ftran) ? in_cmd_addr : out_addr;
assign   out_cmd_size = out_size;
#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
assign   out_cmd_inc  = is_ltran & is_ftran & large_req_grow;
assign   out_cmd_swizzle = is_swizzle;
assign   out_cmd_odd   = in_size_is_odd;
#else
assign   out_cmd_inc  = 1'b0; 
assign   out_cmd_swizzle = 1'b0; 
assign   out_cmd_odd   = 1'b0; 
#endif
assign   out_cmd_ftran = is_ftran;
assign   out_cmd_ltran = is_ltran;
assign   out_cmd_axid = axid;
assign   out_cmd_require_ack = in_cmd_require_ack & is_ltran;

assign   bpt2arb_cmd_pd[3:0] =  out_cmd_axid[3:0];
assign   bpt2arb_cmd_pd[4] =    out_cmd_require_ack ;
assign   bpt2arb_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+4:5] =  out_cmd_addr[NVDLA_MEM_ADDRESS_WIDTH-1:0];
assign   bpt2arb_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+7:NVDLA_MEM_ADDRESS_WIDTH+5] =  out_cmd_size[2:0];
assign   bpt2arb_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+8] =   out_cmd_swizzle ;
assign   bpt2arb_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+9] =   out_cmd_odd ;
assign   bpt2arb_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+10] =  out_cmd_inc ;
assign   bpt2arb_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+11] =  out_cmd_ltran ;
assign   bpt2arb_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+12] =  out_cmd_ftran ;


assign   bpt2arb_dat_pd[NVDLA_MEMIF_WIDTH-1:0] =    out_dat_data[NVDLA_MEMIF_WIDTH-1:0];
assign   bpt2arb_dat_pd[NVDLA_MEMIF_WIDTH+NVDLA_DMA_MASK_BIT-1:NVDLA_MEMIF_WIDTH] =    out_dat_mask[NVDLA_DMA_MASK_BIT-1:0];

assign   bpt2arb_cmd_valid = out_cmd_vld;
assign   bpt2arb_dat_valid = out_dat_vld;
assign   bpt2arb_cmd_accept = bpt2arb_cmd_valid & bpt2arb_cmd_ready;
assign   bpt2arb_dat_accept = bpt2arb_dat_valid & bpt2arb_dat_ready;


endmodule // NV_NVDLA_MCIF_WRITE_IG_bpt



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is ipipe_pd_p (ipipe_vld_p,ipipe_rdy_p) <= dma2bpt_req_pd[NVDLA_DMA_WR_REQ-1:0] (dma2bpt_req_valid,dma2bpt_req_ready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_BPT_pipe_p1 (
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
input  [NVDLA_DMA_WR_REQ-1:0] dma2bpt_req_pd;
input          dma2bpt_req_valid;
input          ipipe_rdy_p;
output         dma2bpt_req_ready;
output [NVDLA_DMA_WR_REQ-1:0] ipipe_pd_p;
output         ipipe_vld_p;

//: my $k = NVDLA_DMA_WR_REQ;
//: &eperl::pipe(" -wid $k -is -do ipipe_pd_p -vo ipipe_vld_p -ri ipipe_rdy_p -di dma2bpt_req_pd -vi dma2bpt_req_valid -ro dma2bpt_req_ready ");


endmodule // NV_NVDLA_MCIF_WRITE_IG_BPT_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is ipipe_pd (ipipe_vld,ipipe_rdy) <= ipipe_pd_p[NVDLA_DMA_WR_REQ-1:0] (ipipe_vld_p,ipipe_rdy_p)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_BPT_pipe_p2 (
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
input  [NVDLA_DMA_WR_REQ-1:0] ipipe_pd_p;
input          ipipe_rdy;
input          ipipe_vld_p;
output [NVDLA_DMA_WR_REQ-1:0] ipipe_pd;
output         ipipe_rdy_p;
output         ipipe_vld;

//: my $k = NVDLA_DMA_WR_REQ;
//: &eperl::pipe(" -wid $k -is -do ipipe_pd -vo ipipe_vld -ri ipipe_rdy -di ipipe_pd_p -vi ipipe_vld_p -ro ipipe_rdy_p ");


endmodule // NV_NVDLA_MCIF_WRITE_IG_BPT_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc in_cmd_pd (in_cmd_vld,in_cmd_rdy) <= ipipe_cmd_pd[NVDLA_DMA_WR_CMD-1:0] (ipipe_cmd_vld,ipipe_cmd_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_BPT_pipe_p3 (
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
input  [NVDLA_DMA_WR_CMD-1:0] ipipe_cmd_pd;
input         ipipe_cmd_vld;
output [NVDLA_DMA_WR_CMD-1:0] in_cmd_pd;
output        in_cmd_vld;
output        ipipe_cmd_rdy;

//: my $k = NVDLA_DMA_WR_CMD; 
//: &eperl::pipe(" -wid $k -do in_cmd_pd -vo in_cmd_vld -ri in_cmd_rdy -di ipipe_cmd_pd -vi ipipe_cmd_vld -ro ipipe_cmd_rdy");


endmodule // NV_NVDLA_MCIF_WRITE_IG_BPT_pipe_p3



module NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dfifo_wr_prdy
    , dfifo_wr_pvld
    , dfifo_wr_pd
    , dfifo_rd_prdy
    , dfifo_rd_pvld
    , dfifo_rd_pd
    );


input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dfifo_wr_prdy;
input         dfifo_wr_pvld;
input  [NVDLA_MEMIF_WIDTH-1:0] dfifo_wr_pd;
input         dfifo_rd_prdy;
output        dfifo_rd_pvld;
output [NVDLA_MEMIF_WIDTH-1:0] dfifo_rd_pd;


//: my $k = NVDLA_MEMIF_WIDTH;
//: &eperl::pipe(" -wid $k -is -do dfifo_rd_pd -vo dfifo_rd_pvld -ri dfifo_rd_prdy -di dfifo_wr_pd -vi dfifo_wr_pvld -ro dfifo_wr_prdy");


endmodule
