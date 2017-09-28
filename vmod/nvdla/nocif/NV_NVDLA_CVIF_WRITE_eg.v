// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CVIF_WRITE_eg.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CVIF_WRITE_eg (
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
  ,noc2cvif_axi_b_bid
  ,noc2cvif_axi_b_bvalid
  ,cq_rd0_prdy
  ,cq_rd1_prdy
  ,cq_rd2_prdy
  ,cq_rd3_prdy
  ,cq_rd4_prdy
  ,cvif2bdma_wr_rsp_complete
  ,cvif2cdp_wr_rsp_complete
  ,cvif2pdp_wr_rsp_complete
  ,cvif2rbk_wr_rsp_complete
  ,cvif2sdp_wr_rsp_complete
  ,eg2ig_axi_len
  ,eg2ig_axi_vld
  ,noc2cvif_axi_b_bready
  );
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//
// NV_NVDLA_CVIF_WRITE_eg_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output  cvif2sdp_wr_rsp_complete;

output  cvif2cdp_wr_rsp_complete;

output  cvif2pdp_wr_rsp_complete;

output  cvif2bdma_wr_rsp_complete;

output  cvif2rbk_wr_rsp_complete;

input        cq_rd0_pvld;  /* data valid */
output       cq_rd0_prdy;  /* data return handshake */
input  [2:0] cq_rd0_pd;

input        cq_rd1_pvld;  /* data valid */
output       cq_rd1_prdy;  /* data return handshake */
input  [2:0] cq_rd1_pd;

input        cq_rd2_pvld;  /* data valid */
output       cq_rd2_prdy;  /* data return handshake */
input  [2:0] cq_rd2_pd;

input        cq_rd3_pvld;  /* data valid */
output       cq_rd3_prdy;  /* data return handshake */
input  [2:0] cq_rd3_pd;

input        cq_rd4_pvld;  /* data valid */
output       cq_rd4_prdy;  /* data return handshake */
input  [2:0] cq_rd4_pd;

input        noc2cvif_axi_b_bvalid;  /* data valid */
output       noc2cvif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2cvif_axi_b_bid;

output [1:0] eg2ig_axi_len;
output       eg2ig_axi_vld;
reg          cvif2bdma_wr_rsp_complete;
reg          cvif2cdp_wr_rsp_complete;
reg          cvif2pdp_wr_rsp_complete;
reg          cvif2rbk_wr_rsp_complete;
reg          cvif2sdp_wr_rsp_complete;
reg    [1:0] eg2ig_axi_len;
reg    [2:0] iflop_axi_axid;
reg          iflop_axi_vld;
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

//stepheng,remove for no loading.
// TIE-OFFs 
//assign noc2cvif_axi_b_bresp_NC = noc2cvif_axi_b_bresp;
//assign noc2cvif_axi_b_buser_NC = noc2cvif_axi_b_buser;
//assign noc2cvif_axi_b_bid_NC = noc2cvif_axi_b_bid;
assign noc2cvif_axi_b_bready = 1'b1; // NO pushback is needed on AXI B channel;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    iflop_axi_vld <= 1'b0;
  end else begin
  iflop_axi_vld <= noc2cvif_axi_b_bvalid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    iflop_axi_axid <= {3{1'b0}};
  end else begin
  if ((noc2cvif_axi_b_bvalid) == 1'b1) begin
    iflop_axi_axid <= noc2cvif_axi_b_bid[2:0];
  // VCS coverage off
  end else if ((noc2cvif_axi_b_bvalid) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(noc2cvif_axi_b_bvalid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign cq_rd0_prdy = dma0_vld;
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
    cvif2bdma_wr_rsp_complete <= 1'b0;
  end else begin
  cvif2bdma_wr_rsp_complete <= dma0_vld & cq_rd0_pvld & cq_rd0_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvif2sdp_wr_rsp_complete <= 1'b0;
  end else begin
  cvif2sdp_wr_rsp_complete <= dma1_vld & cq_rd1_pvld & cq_rd1_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvif2pdp_wr_rsp_complete <= 1'b0;
  end else begin
  cvif2pdp_wr_rsp_complete <= dma2_vld & cq_rd2_pvld & cq_rd2_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvif2cdp_wr_rsp_complete <= 1'b0;
  end else begin
  cvif2cdp_wr_rsp_complete <= dma3_vld & cq_rd3_pvld & cq_rd3_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvif2rbk_wr_rsp_complete <= 1'b0;
  end else begin
  cvif2rbk_wr_rsp_complete <= dma4_vld & cq_rd4_pvld & cq_rd4_require_ack;
  end
end

// EG2IG outstanding Counting
assign eg2ig_axi_vld = iflop_axi_vld;
always @(
  dma0_vld
  or cq_rd0_len
  or dma1_vld
  or cq_rd1_len
  or dma2_vld
  or cq_rd2_len
  or dma3_vld
  or cq_rd3_len
  or dma4_vld
  or cq_rd4_len
  ) begin
//spyglass disable_block W171 W226
    case (1'b1 )
      dma0_vld: eg2ig_axi_len = cq_rd0_len;
      dma1_vld: eg2ig_axi_len = cq_rd1_len;
      dma2_vld: eg2ig_axi_len = cq_rd2_len;
      dma3_vld: eg2ig_axi_len = cq_rd3_len;
      dma4_vld: eg2ig_axi_len = cq_rd4_len;
    //VCS coverage off
    default : begin 
                eg2ig_axi_len[1:0] = {2{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

//==================================
// OBS
//&PerlBeg;
//    foreach my $i (0..$wdma_num-1) {
//        vprinti "
//        | assign obs_bus_cvif_write_eg_dma${i}_vld = dma${i}_vld;
//        ";
//    }
//&PerlEnd;
endmodule // NV_NVDLA_CVIF_WRITE_eg

