// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_csb.v

module NV_NVDLA_MCIF_csb (
   nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  ,csb2mcif_req_pd           //|< i
  ,csb2mcif_req_pvld         //|< i
  ,dp2reg_idle               //|< i
  ,csb2mcif_req_prdy         //|> o
  ,mcif2csb_resp_pd          //|> o
  ,mcif2csb_resp_valid       //|> o
  ,reg2dp_rd_os_cnt          //|> o
  ,reg2dp_rd_weight_bdma     //|> o
  ,reg2dp_rd_weight_cdma_dat //|> o
  ,reg2dp_rd_weight_cdma_wt  //|> o
  ,reg2dp_rd_weight_cdp      //|> o
  ,reg2dp_rd_weight_pdp      //|> o
  ,reg2dp_rd_weight_rbk      //|> o
  ,reg2dp_rd_weight_rsv_0    //|> o
  ,reg2dp_rd_weight_rsv_1    //|> o
  ,reg2dp_rd_weight_sdp      //|> o
  ,reg2dp_rd_weight_sdp_b    //|> o
  ,reg2dp_rd_weight_sdp_e    //|> o
  ,reg2dp_rd_weight_sdp_n    //|> o
  ,reg2dp_wr_os_cnt          //|> o
  ,reg2dp_wr_weight_bdma     //|> o
  ,reg2dp_wr_weight_cdp      //|> o
  ,reg2dp_wr_weight_pdp      //|> o
  ,reg2dp_wr_weight_rbk      //|> o
  ,reg2dp_wr_weight_rsv_0    //|> o
  ,reg2dp_wr_weight_rsv_1    //|> o
  ,reg2dp_wr_weight_rsv_2    //|> o
  ,reg2dp_wr_weight_sdp      //|> o
  );
//
// NV_NVDLA_MCIF_csb_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         csb2mcif_req_pvld;  /* data valid */
output        csb2mcif_req_prdy;  /* data return handshake */
input  [62:0] csb2mcif_req_pd;

output        mcif2csb_resp_valid;  /* data valid */
output [33:0] mcif2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input         dp2reg_idle;
output  [7:0] reg2dp_rd_os_cnt;
output  [7:0] reg2dp_rd_weight_bdma;
output  [7:0] reg2dp_rd_weight_cdma_dat;
output  [7:0] reg2dp_rd_weight_cdma_wt;
output  [7:0] reg2dp_rd_weight_cdp;
output  [7:0] reg2dp_rd_weight_pdp;
output  [7:0] reg2dp_rd_weight_rbk;
output  [7:0] reg2dp_rd_weight_rsv_0;
output  [7:0] reg2dp_rd_weight_rsv_1;
output  [7:0] reg2dp_rd_weight_sdp;
output  [7:0] reg2dp_rd_weight_sdp_b;
output  [7:0] reg2dp_rd_weight_sdp_e;
output  [7:0] reg2dp_rd_weight_sdp_n;
output  [7:0] reg2dp_wr_os_cnt;
output  [7:0] reg2dp_wr_weight_bdma;
output  [7:0] reg2dp_wr_weight_cdp;
output  [7:0] reg2dp_wr_weight_pdp;
output  [7:0] reg2dp_wr_weight_rbk;
output  [7:0] reg2dp_wr_weight_rsv_0;
output  [7:0] reg2dp_wr_weight_rsv_1;
output  [7:0] reg2dp_wr_weight_rsv_2;
output  [7:0] reg2dp_wr_weight_sdp;
reg    [33:0] mcif2csb_resp_pd;
reg           mcif2csb_resp_valid;
reg    [62:0] req_pd;
reg           req_vld;
wire   [11:0] reg_offset;
wire   [31:0] reg_rd_data;
wire   [31:0] reg_wr_data;
wire          reg_wr_en;
wire   [21:0] req_addr;
wire    [1:0] req_level_NC;
wire          req_nposted;
wire          req_srcpriv_NC;
wire   [31:0] req_wdat;
wire    [3:0] req_wrbe_NC;
wire          req_write;
wire   [33:0] rsp_pd;
wire          rsp_rd_error;
wire   [32:0] rsp_rd_pd;
wire   [31:0] rsp_rd_rdat;
wire          rsp_rd_vld;
wire          rsp_vld;
wire          rsp_wr_error;
wire   [32:0] rsp_wr_pd;
wire   [31:0] rsp_wr_rdat;
wire          rsp_wr_vld;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    // &Viva width_learning_on;
// REQ INTERFACE

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_vld <= 1'b0;
  end else begin
  req_vld <= csb2mcif_req_pvld;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((csb2mcif_req_pvld) == 1'b1) begin
    req_pd <= csb2mcif_req_pd;
  // VCS coverage off
  end else if ((csb2mcif_req_pvld) == 1'b0) begin
  end else begin
    req_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2mcif_req_prdy = 1'b1;

// ========
// REQUEST
// ========
// flow=pvld_prdy 
assign req_level_NC = req_pd[62:61];
assign req_nposted = req_pd[55:55];
assign req_addr = req_pd[21:0];
assign req_wrbe_NC = req_pd[60:57];
assign req_srcpriv_NC = req_pd[56:56];
assign req_write = req_pd[54:54];
assign req_wdat = req_pd[53:22];
// ========
// RESPONSE
// ========
// flow=valid 
// packet=dla_xx2csb_rd_erpt 
assign rsp_rd_pd[32:32] = rsp_rd_error;
assign rsp_rd_pd[31:0] = rsp_rd_rdat;
// packet=dla_xx2csb_wr_erpt 
assign rsp_wr_pd[32:32] = rsp_wr_error;
assign rsp_wr_pd[31:0] = rsp_wr_rdat;


assign rsp_rd_vld  = req_vld & ~req_write;
assign rsp_rd_rdat = {32{rsp_rd_vld}} & reg_rd_data;
assign rsp_rd_error  = 1'b0;

assign rsp_wr_vld  = req_vld & req_write & req_nposted;
assign rsp_wr_rdat = {32{1'b0}};
assign rsp_wr_error  = 1'b0;

// ========
// REQUEST
// ========
assign rsp_vld = rsp_rd_vld | rsp_wr_vld;
assign rsp_pd[33:33] = ({1{rsp_rd_vld}} & {1'h0}) 
                                | ({1{rsp_wr_vld}} & {1'h1});

assign rsp_pd[32:0] = ({33{rsp_rd_vld}} & rsp_rd_pd)
                                | ({33{rsp_wr_vld}} & rsp_wr_pd);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif2csb_resp_valid <= 1'b0;
  end else begin
  mcif2csb_resp_valid <= rsp_vld;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rsp_vld) == 1'b1) begin
    mcif2csb_resp_pd <= rsp_pd;
  // VCS coverage off
  end else if ((rsp_vld) == 1'b0) begin
  end else begin
    mcif2csb_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign reg_offset = {req_addr[9:0],{2{1'b0}}};
assign reg_wr_en = req_vld & req_write;
assign reg_wr_data = req_wdat;
NV_NVDLA_MCIF_CSB_reg u_reg (
   .reg_rd_data        (reg_rd_data[31:0])              //|> w
  ,.reg_offset         (reg_offset[11:0])               //|< w
  ,.reg_wr_data        (reg_wr_data[31:0])              //|< w
  ,.reg_wr_en          (reg_wr_en)                      //|< w
  ,.nvdla_core_clk     (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)                //|< i
  ,.rd_os_cnt          (reg2dp_rd_os_cnt[7:0])          //|> o
  ,.wr_os_cnt          (reg2dp_wr_os_cnt[7:0])          //|> o
  ,.rd_weight_bdma     (reg2dp_rd_weight_bdma[7:0])     //|> o
  ,.rd_weight_cdp      (reg2dp_rd_weight_cdp[7:0])      //|> o
  ,.rd_weight_pdp      (reg2dp_rd_weight_pdp[7:0])      //|> o
  ,.rd_weight_sdp      (reg2dp_rd_weight_sdp[7:0])      //|> o
  ,.rd_weight_cdma_dat (reg2dp_rd_weight_cdma_dat[7:0]) //|> o
  ,.rd_weight_sdp_b    (reg2dp_rd_weight_sdp_b[7:0])    //|> o
  ,.rd_weight_sdp_e    (reg2dp_rd_weight_sdp_e[7:0])    //|> o
  ,.rd_weight_sdp_n    (reg2dp_rd_weight_sdp_n[7:0])    //|> o
  ,.rd_weight_cdma_wt  (reg2dp_rd_weight_cdma_wt[7:0])  //|> o
  ,.rd_weight_rbk      (reg2dp_rd_weight_rbk[7:0])      //|> o
  ,.rd_weight_rsv_0    (reg2dp_rd_weight_rsv_0[7:0])    //|> o
  ,.rd_weight_rsv_1    (reg2dp_rd_weight_rsv_1[7:0])    //|> o
  ,.wr_weight_bdma     (reg2dp_wr_weight_bdma[7:0])     //|> o
  ,.wr_weight_cdp      (reg2dp_wr_weight_cdp[7:0])      //|> o
  ,.wr_weight_pdp      (reg2dp_wr_weight_pdp[7:0])      //|> o
  ,.wr_weight_sdp      (reg2dp_wr_weight_sdp[7:0])      //|> o
  ,.wr_weight_rbk      (reg2dp_wr_weight_rbk[7:0])      //|> o
  ,.wr_weight_rsv_0    (reg2dp_wr_weight_rsv_0[7:0])    //|> o
  ,.wr_weight_rsv_1    (reg2dp_wr_weight_rsv_1[7:0])    //|> o
  ,.wr_weight_rsv_2    (reg2dp_wr_weight_rsv_2[7:0])    //|> o
  ,.idle               (dp2reg_idle)                    //|< i
  );





endmodule // NV_NVDLA_MCIF_csb

