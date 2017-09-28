// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RT_csb2cacc.v

module NV_NVDLA_RT_csb2cacc (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,csb2cacc_req_src_pvld
  ,csb2cacc_req_src_prdy
  ,csb2cacc_req_src_pd
  ,cacc2csb_resp_src_valid
  ,cacc2csb_resp_src_pd
  ,csb2cacc_req_dst_pvld
  ,csb2cacc_req_dst_prdy
  ,csb2cacc_req_dst_pd
  ,cacc2csb_resp_dst_valid
  ,cacc2csb_resp_dst_pd
  );

//
// NV_NVDLA_RT_csb2cacc_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         csb2cacc_req_src_pvld;  /* data valid */
output        csb2cacc_req_src_prdy;  /* data return handshake */
input  [62:0] csb2cacc_req_src_pd;

input        cacc2csb_resp_src_valid;  /* data valid */
input [33:0] cacc2csb_resp_src_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2cacc_req_dst_pvld;  /* data valid */
input         csb2cacc_req_dst_prdy;  /* data return handshake */
output [62:0] csb2cacc_req_dst_pd;

output        cacc2csb_resp_dst_valid;  /* data valid */
output [33:0] cacc2csb_resp_dst_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

wire [33:0] cacc2csb_resp_pd_d0;
wire        cacc2csb_resp_valid_d0;
wire [62:0] csb2cacc_req_pd_d0;
wire        csb2cacc_req_pvld_d0;
reg  [33:0] cacc2csb_resp_pd_d1;
reg  [33:0] cacc2csb_resp_pd_d2;
reg  [33:0] cacc2csb_resp_pd_d3;
reg         cacc2csb_resp_valid_d1;
reg         cacc2csb_resp_valid_d2;
reg         cacc2csb_resp_valid_d3;
reg  [62:0] csb2cacc_req_pd_d1;
reg  [62:0] csb2cacc_req_pd_d2;
reg  [62:0] csb2cacc_req_pd_d3;
reg         csb2cacc_req_pvld_d1;
reg         csb2cacc_req_pvld_d2;
reg         csb2cacc_req_pvld_d3;


assign csb2cacc_req_src_prdy = 1'b1;




assign csb2cacc_req_pvld_d0 = csb2cacc_req_src_pvld;
assign csb2cacc_req_pd_d0 = csb2cacc_req_src_pd;


assign cacc2csb_resp_valid_d0 = cacc2csb_resp_src_valid;
assign cacc2csb_resp_pd_d0 = cacc2csb_resp_src_pd;




always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2cacc_req_pvld_d1 <= 1'b0;
  end else begin
  csb2cacc_req_pvld_d1 <= csb2cacc_req_pvld_d0;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((csb2cacc_req_pvld_d0) == 1'b1) begin
    csb2cacc_req_pd_d1 <= csb2cacc_req_pd_d0;
  // VCS coverage off
  end else if ((csb2cacc_req_pvld_d0) == 1'b0) begin
  end else begin
    csb2cacc_req_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cacc2csb_resp_valid_d1 <= 1'b0;
  end else begin
  cacc2csb_resp_valid_d1 <= cacc2csb_resp_valid_d0;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cacc2csb_resp_valid_d0) == 1'b1) begin
    cacc2csb_resp_pd_d1 <= cacc2csb_resp_pd_d0;
  // VCS coverage off
  end else if ((cacc2csb_resp_valid_d0) == 1'b0) begin
  end else begin
    cacc2csb_resp_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2cacc_req_pvld_d2 <= 1'b0;
  end else begin
  csb2cacc_req_pvld_d2 <= csb2cacc_req_pvld_d1;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((csb2cacc_req_pvld_d1) == 1'b1) begin
    csb2cacc_req_pd_d2 <= csb2cacc_req_pd_d1;
  // VCS coverage off
  end else if ((csb2cacc_req_pvld_d1) == 1'b0) begin
  end else begin
    csb2cacc_req_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cacc2csb_resp_valid_d2 <= 1'b0;
  end else begin
  cacc2csb_resp_valid_d2 <= cacc2csb_resp_valid_d1;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cacc2csb_resp_valid_d1) == 1'b1) begin
    cacc2csb_resp_pd_d2 <= cacc2csb_resp_pd_d1;
  // VCS coverage off
  end else if ((cacc2csb_resp_valid_d1) == 1'b0) begin
  end else begin
    cacc2csb_resp_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2cacc_req_pvld_d3 <= 1'b0;
  end else begin
  csb2cacc_req_pvld_d3 <= csb2cacc_req_pvld_d2;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((csb2cacc_req_pvld_d2) == 1'b1) begin
    csb2cacc_req_pd_d3 <= csb2cacc_req_pd_d2;
  // VCS coverage off
  end else if ((csb2cacc_req_pvld_d2) == 1'b0) begin
  end else begin
    csb2cacc_req_pd_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cacc2csb_resp_valid_d3 <= 1'b0;
  end else begin
  cacc2csb_resp_valid_d3 <= cacc2csb_resp_valid_d2;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cacc2csb_resp_valid_d2) == 1'b1) begin
    cacc2csb_resp_pd_d3 <= cacc2csb_resp_pd_d2;
  // VCS coverage off
  end else if ((cacc2csb_resp_valid_d2) == 1'b0) begin
  end else begin
    cacc2csb_resp_pd_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end




assign csb2cacc_req_dst_pvld = csb2cacc_req_pvld_d3;
assign csb2cacc_req_dst_pd = csb2cacc_req_pd_d3;


assign cacc2csb_resp_dst_valid = cacc2csb_resp_valid_d3;
assign cacc2csb_resp_dst_pd = cacc2csb_resp_pd_d3;





endmodule // NV_NVDLA_RT_csb2cacc

