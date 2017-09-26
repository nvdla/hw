// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_GLB_fc.v

module NV_NVDLA_GLB_fc (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,csb2gec_req_pd
  ,csb2gec_req_pvld
  ,direct_reset_
  ,nvdla_falcon_clk
  ,nvdla_falcon_rstn
  ,test_mode
  ,csb2gec_req_prdy
  ,gec2csb_resp_pd
  ,gec2csb_resp_valid
  );
//call FC_PLUTIN here

input nvdla_falcon_clk;
input nvdla_core_clk;
input nvdla_core_rstn;
input nvdla_falcon_rstn;
input direct_reset_;
input test_mode;

input  [62:0] csb2gec_req_pd;
input         csb2gec_req_pvld;
output        csb2gec_req_prdy;
output [33:0] gec2csb_resp_pd;
output        gec2csb_resp_valid;
reg    [33:0] gec2csb_resp_pd;
reg           gec2csb_resp_valid;
wire   [21:0] req_addr;
wire    [1:0] req_level;
wire          req_nposted;
wire          req_pvld;
wire          req_srcpriv;
wire   [31:0] req_wdat;
wire    [3:0] req_wrbe;
wire          req_write;
wire          resp_en;
wire   [33:0] resp_pd_w;
wire          rresp_en;
wire          rresp_error;
wire   [33:0] rresp_pd_w;
wire   [31:0] rresp_rdat;
wire          wresp_en;
wire          wresp_error;
wire   [33:0] wresp_pd_w;
wire   [31:0] wresp_rdat;


assign csb2gec_req_prdy = 1'b1;
assign req_pvld = csb2gec_req_pvld;


// PKT_UNPACK_WIRE( csb2xx_16m_be_lvl ,  req_ ,  csb2gec_req_pd )
assign        req_addr[21:0] =     csb2gec_req_pd[21:0];
assign        req_wdat[31:0] =     csb2gec_req_pd[53:22];
assign         req_write  =     csb2gec_req_pd[54];
assign         req_nposted  =     csb2gec_req_pd[55];
assign         req_srcpriv  =     csb2gec_req_pd[56];
assign        req_wrbe[3:0] =     csb2gec_req_pd[60:57];
assign        req_level[1:0] =     csb2gec_req_pd[62:61];


// PKT_PACK_WIRE_ID( nvdla_xx2csb_resp ,  dla_xx2csb_rd_erpt ,  rresp_ ,  rresp_pd_w )
assign       rresp_pd_w[31:0] =     rresp_rdat[31:0];
assign       rresp_pd_w[32] =     rresp_error ;

assign   rresp_pd_w[33:33] = 1'd0  /* PKT_nvdla_xx2csb_resp_dla_xx2csb_rd_erpt_ID  */ ;

// PKT_PACK_WIRE_ID( nvdla_xx2csb_resp ,  dla_xx2csb_wr_erpt ,  wresp_ ,  wresp_pd_w )
assign       wresp_pd_w[31:0] =     wresp_rdat[31:0];
assign       wresp_pd_w[32] =     wresp_error ;

assign   wresp_pd_w[33:33] = 1'd1  /* PKT_nvdla_xx2csb_resp_dla_xx2csb_wr_erpt_ID  */ ;

assign rresp_rdat = 32'b0;
assign wresp_rdat = 32'b0;
assign rresp_error = 1'b0;
assign wresp_error = 1'b0;

assign wresp_en = req_pvld & req_write & req_nposted;
assign rresp_en = req_pvld & ~req_write;

assign resp_pd_w = wresp_en ? wresp_pd_w : rresp_pd_w;
assign resp_en = wresp_en | rresp_en;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    gec2csb_resp_valid <= 1'b0;
  end else begin
  gec2csb_resp_valid <= resp_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    gec2csb_resp_pd <= {34{1'b0}};
  end else begin
  if ((resp_en) == 1'b1) begin
    gec2csb_resp_pd <= resp_pd_w;
  // VCS coverage off
  end else if ((resp_en) == 1'b0) begin
  end else begin
    gec2csb_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(resp_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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


endmodule // NV_NVDLA_GLB_fc


