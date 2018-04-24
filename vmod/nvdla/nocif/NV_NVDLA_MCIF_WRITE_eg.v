// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_WRITE_eg.v

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_WRITE_eg (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cq_rd0_pd
  ,cq_rd0_pvld
  ,cq_rd1_pd
  ,cq_rd1_pvld
  ,cq_rd2_pd
  ,cq_rd2_pvld
  ,cq_rd3_pd
  ,cq_rd3_pvld
  ,cq_rd4_pd
  ,cq_rd4_pvld
  ,noc2mcif_axi_b_bid
  ,noc2mcif_axi_b_bresp
  ,noc2mcif_axi_b_bvalid
  ,cq_rd0_prdy
  ,cq_rd1_prdy
  ,cq_rd2_prdy
  ,cq_rd3_prdy
  ,cq_rd4_prdy
  ,eg2ig_axi_len
  ,eg2ig_axi_vld
  ,mcif2bdma_wr_rsp_complete
  ,mcif2cdp_wr_rsp_complete
  ,mcif2pdp_wr_rsp_complete
  ,mcif2rbk_wr_rsp_complete
  ,mcif2sdp_wr_rsp_complete
  ,noc2mcif_axi_b_bready
  );

input  nvdla_core_clk;
input  nvdla_core_rstn;

output  mcif2sdp_wr_rsp_complete;
output  mcif2cdp_wr_rsp_complete;
output  mcif2pdp_wr_rsp_complete;

output  mcif2bdma_wr_rsp_complete;
output  mcif2rbk_wr_rsp_complete;

input        cq_rd0_pvld;  
output       cq_rd0_prdy;  
input  [2:0] cq_rd0_pd;

input        cq_rd1_pvld;  
output       cq_rd1_prdy;  
input  [2:0] cq_rd1_pd;

input        cq_rd2_pvld;  
output       cq_rd2_prdy;  
input  [2:0] cq_rd2_pd;

input        cq_rd3_pvld;  
output       cq_rd3_prdy;  
input  [2:0] cq_rd3_pd;

input        cq_rd4_pvld;  
output       cq_rd4_prdy;  
input  [2:0] cq_rd4_pd;

input        noc2mcif_axi_b_bvalid;  
output       noc2mcif_axi_b_bready;  
input  [7:0] noc2mcif_axi_b_bid;
input  [1:0] noc2mcif_axi_b_bresp;

output [1:0] eg2ig_axi_len;
output       eg2ig_axi_vld;
reg    [2:0] iflop_axi_axid;
reg          iflop_axi_vld;
reg          mcif2bdma_wr_rsp_complete;
reg          mcif2cdp_wr_rsp_complete;
reg          mcif2pdp_wr_rsp_complete;
reg          mcif2rbk_wr_rsp_complete;
reg          mcif2sdp_wr_rsp_complete;
wire   [1:0] cq_rd0_len;
wire         cq_rd0_require_ack;
wire   [1:0] cq_rd1_len;
wire         cq_rd1_require_ack;
wire   [1:0] cq_rd2_len;
wire         cq_rd2_require_ack;
wire   [1:0] cq_rd3_len;
wire         cq_rd3_require_ack;
wire   [1:0] cq_rd4_len;
wire         cq_rd4_require_ack;
wire         dma0_vld;
wire         dma1_vld;
wire         dma2_vld;
wire         dma3_vld;
wire         dma4_vld;


// TIE-OFFs 
assign noc2mcif_axi_b_bready = 1'b1; // NO pushback is needed on AXI B channel;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    iflop_axi_vld <= 1'b0;
  end else begin
  iflop_axi_vld <= noc2mcif_axi_b_bvalid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    iflop_axi_axid <= {3{1'b0}};
  end else begin
  if ((noc2mcif_axi_b_bvalid) == 1'b1) begin
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
assign dma0_vld = iflop_axi_vld & (iflop_axi_axid == 0);
assign cq_rd0_prdy = iflop_axi_vld; // ECO 2054481
assign dma1_vld = iflop_axi_vld & (iflop_axi_axid == 1);
assign cq_rd1_prdy = dma1_vld;
assign dma2_vld = iflop_axi_vld & (iflop_axi_axid == 2);
assign cq_rd2_prdy = dma2_vld;
assign dma3_vld = iflop_axi_vld & (iflop_axi_axid == 3);
assign cq_rd3_prdy = dma3_vld;
assign dma4_vld = iflop_axi_vld & (iflop_axi_axid == 4);
assign cq_rd4_prdy = dma4_vld;

// EG===Complet Output

assign cq_rd0_require_ack = cq_rd0_pd[0:0];
assign cq_rd0_len = cq_rd0_pd[2:1];
assign cq_rd1_require_ack = cq_rd1_pd[0:0];
assign cq_rd1_len = cq_rd1_pd[2:1];
assign cq_rd2_require_ack = cq_rd2_pd[0:0];
assign cq_rd2_len = cq_rd2_pd[2:1];
assign cq_rd3_require_ack = cq_rd3_pd[0:0];
assign cq_rd3_len = cq_rd3_pd[2:1];
assign cq_rd4_require_ack = cq_rd4_pd[0:0];
assign cq_rd4_len = cq_rd4_pd[2:1];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif2bdma_wr_rsp_complete <= 1'b0;
  end else begin
  mcif2bdma_wr_rsp_complete <= dma0_vld & cq_rd0_pvld & cq_rd0_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif2sdp_wr_rsp_complete <= 1'b0;
  end else begin
  mcif2sdp_wr_rsp_complete <= dma1_vld & cq_rd0_pvld & cq_rd0_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif2pdp_wr_rsp_complete <= 1'b0;
  end else begin
  mcif2pdp_wr_rsp_complete <= dma2_vld & cq_rd0_pvld & cq_rd0_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif2cdp_wr_rsp_complete <= 1'b0;
  end else begin
  mcif2cdp_wr_rsp_complete <= dma3_vld & cq_rd0_pvld & cq_rd0_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif2rbk_wr_rsp_complete <= 1'b0;
  end else begin
  mcif2rbk_wr_rsp_complete <= dma4_vld & cq_rd0_pvld & cq_rd0_require_ack;
  end
end


assign eg2ig_axi_vld = iflop_axi_vld;
assign eg2ig_axi_len = 2'b0; // ECO 2054481, Synth optimized this out except for through ram paths, which still always be written to zero.



endmodule // NV_NVDLA_MCIF_WRITE_eg

