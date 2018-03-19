// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_NOCIF_DRAM_WRITE_eg.v

`include "simulate_x_tick.vh"
#include "NV_NVDLA_define.h"
#ifdef NVDLA_BDMA_ENABLE
    #define INT_NVDLA_BDMA_ENABLE 1
#else
    #define INT_NVDLA_BDMA_ENABLE 0
#endif
#ifdef NVDLA_CDP_ENABLE
    #define INT_NVDLA_CDP_ENABLE 1
#else
    #define INT_NVDLA_CDP_ENABLE 0
#endif
#ifdef NVDLA_PDP_ENABLE
    #define INT_NVDLA_PDP_ENABLE 1
#else
    #define INT_NVDLA_PDP_ENABLE 0
#endif
#ifdef NVDLA_RUBIK_ENABLE
    #define INT_NVDLA_RUBIK_ENABLE 1
#else
    #define INT_NVDLA_RUBIK_ENABLE 0
#endif
#ifdef NVDLA_SDP_BS_ENABLE
    #define INT_NVDLA_SDP_BS_ENABLE 1
#else
    #define INT_NVDLA_SDP_BS_ENABLE 0
#endif
#ifdef NVDLA_SDP_BN_ENABLE
    #define INT_NVDLA_SDP_BN_ENABLE 1
#else
    #define INT_NVDLA_SDP_BN_ENABLE 0
#endif
#ifdef NVDLA_SDP_EW_ENABLE
    #define INT_NVDLA_SDP_EW_ENABLE 1
#else
    #define INT_NVDLA_SDP_EW_ENABLE 0
#endif

module NV_NVDLA_NOCIF_DRAM_WRITE_eg (
   nvdla_core_clk
  ,nvdla_core_rstn
//:my $i;
//:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
//:print qq(
//:  ,cq_rd${i}_pvld
//:  ,cq_rd${i}_pd
//:  ,cq_rd${i}_prdy
//:  ,mcif2client${i}_wr_rsp_complete
//:);
//:}
  ,noc2mcif_axi_b_bid
  ,noc2mcif_axi_b_bvalid
  ,eg2ig_axi_len
  ,eg2ig_axi_vld
  ,noc2mcif_axi_b_bready
);


input  nvdla_core_clk;
input  nvdla_core_rstn;

//:my $i;
//:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
//:print qq(
//:output mcif2client${i}_wr_rsp_complete;
//:input cq_rd${i}_pvld;
//:output cq_rd${i}_prdy;
//:input [2:0] cq_rd${i}_pd;
//:);
//:}
input        noc2mcif_axi_b_bvalid;  /* data valid */
output       noc2mcif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2mcif_axi_b_bid;

output [1:0] eg2ig_axi_len;
output       eg2ig_axi_vld;

//:my $i;
//:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
//:print qq(
//:reg mcif2client${i}_wr_rsp_complete;
//:wire [1:0] cq_rd${i}_len;
//:wire cq_rd${i}_require_ack;
//:wire dma${i}_vld;
//:);
//:}

reg    [1:0] eg2ig_axi_len;
reg    [2:0] iflop_axi_axid;
reg          iflop_axi_vld;

//stepheng,remove for no loading.
// TIE-OFFs 
//assign noc2mcif_axi_b_bresp_NC = noc2mcif_axi_b_bresp;
//assign noc2mcif_axi_b_buser_NC = noc2mcif_axi_b_buser;
//assign noc2mcif_axi_b_bid_NC = noc2mcif_axi_b_bid;
//

wire cq_vld = 
//:my $i;
//:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
//:print qq(
//: (!cq_rd${i}_pvld & cq_rd${i}_prdy) |
//:);
//:}
0;

assign noc2mcif_axi_b_bready = !cq_vld;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    iflop_axi_vld <= 1'b0;
  end else begin
  if (noc2mcif_axi_b_bready)
     iflop_axi_vld <= noc2mcif_axi_b_bvalid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    iflop_axi_axid <= {3{1'b0}};
  end else begin
  if ((noc2mcif_axi_b_bvalid & noc2mcif_axi_b_bready) == 1'b1) begin
    iflop_axi_axid <= noc2mcif_axi_b_bid[2:0];
  // VCS coverage off
  end else if ((noc2mcif_axi_b_bvalid) == 1'b0) begin
  end else begin
    iflop_axi_axid <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(noc2mcif_axi_b_bvalid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// EG===Contect Qeueu
//:my $i;
//:my @dma_index = (INT_NVDLA_BDMA_ENABLE, 1,INT_NVDLA_PDP_ENABLE, INT_NVDLA_CDP_ENABLE,INT_NVDLA_RUBIK_ENABLE, 0, 0, 0, 0,0,0,0,0,0,0);
//:my @client_id = (0,1,2,3,4,0,0,0,0,0,0,0,0,0,0,0);
//:my @remap_clientid = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
//:my $nindex = 0;
//:for ($i=0;$i<16;$i++) {
//: if ($dma_index[$i] != 0) {
//:  $remap_clientid[$nindex] = $client_id[$i];
//:  $nindex++;
//: }
//:}
//:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
//:print qq(
//:assign dma${i}_vld = iflop_axi_vld & (iflop_axi_axid == $remap_clientid[$i]);
//:assign cq_rd${i}_prdy = dma${i}_vld;
//:assign cq_rd${i}_require_ack = cq_rd${i}_pd[0:0];
//:assign cq_rd${i}_len = cq_rd${i}_pd[2:1];
//:always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//: if (!nvdla_core_rstn) begin
//:    mcif2client${i}_wr_rsp_complete <= 1'b0;
//:  end else begin
//:  mcif2client${i}_wr_rsp_complete <= dma${i}_vld & cq_rd${i}_pvld & cq_rd${i}_require_ack;
//:  end
//:end
//:);
//:}

// EG2IG outstanding Counting
assign eg2ig_axi_vld = iflop_axi_vld & noc2mcif_axi_b_bready;

always @(
dma0_vld or
cq_rd0_len 
//:my $i;
//:for($i=1;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
//:print qq(
//:or dma${i}_vld
//:or cq_rd${i}_len
//:);
//:}
) begin
   //spyglass disable_block W171 W226
   case (1'b1)
//:my $i;
   //:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
   //:print qq(
   //:dma${i}_vld: eg2ig_axi_len = cq_rd${i}_len;
   //:);
   //:}
      //VCS coverage off
    default : begin 
                eg2ig_axi_len[1:0] = {2{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end
endmodule // NV_NVDLA_CVIF_WRITE_eg
