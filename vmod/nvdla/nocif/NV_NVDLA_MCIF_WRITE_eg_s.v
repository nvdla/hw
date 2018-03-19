// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_WRITE_eg_s.v

#include "NV_NVDLA_MCIF_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_WRITE_eg_s (
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
///////////////////////////////////////////////////////
// NV_NVDLA_MCIF_WRITE_eg_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output  mcif2sdp_wr_rsp_complete;
output  mcif2cdp_wr_rsp_complete;
output  mcif2pdp_wr_rsp_complete;
output  mcif2bdma_wr_rsp_complete;
output  mcif2rbk_wr_rsp_complete;

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

input        noc2mcif_axi_b_bvalid;  /* data valid */
output       noc2mcif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2mcif_axi_b_bid;

output [1:0] eg2ig_axi_len;
output       eg2ig_axi_vld;
///////////////////////////////////////////////////////
reg    [1:0] eg2ig_axi_len;
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
///////////////////////////////////////////////////////
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
  end
  end
end

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
    mcif2bdma_wr_rsp_complete <= 1'b0;
  end else begin
  mcif2bdma_wr_rsp_complete <= dma0_vld & cq_rd0_pvld & cq_rd0_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif2sdp_wr_rsp_complete <= 1'b0;
  end else begin
  mcif2sdp_wr_rsp_complete <= dma1_vld & cq_rd1_pvld & cq_rd1_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif2pdp_wr_rsp_complete <= 1'b0;
  end else begin
  mcif2pdp_wr_rsp_complete <= dma2_vld & cq_rd2_pvld & cq_rd2_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif2cdp_wr_rsp_complete <= 1'b0;
  end else begin
  mcif2cdp_wr_rsp_complete <= dma3_vld & cq_rd3_pvld & cq_rd3_require_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif2rbk_wr_rsp_complete <= 1'b0;
  end else begin
  mcif2rbk_wr_rsp_complete <= dma4_vld & cq_rd4_pvld & cq_rd4_require_ack;
  end
end

// EG2IG outstanding Counting
assign eg2ig_axi_vld = iflop_axi_vld;
always @(*) begin
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





endmodule // NV_NVDLA_MCIF_WRITE_eg

