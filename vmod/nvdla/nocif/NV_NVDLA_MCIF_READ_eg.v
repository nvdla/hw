// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_READ_eg.v

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_READ_eg (
   nvdla_core_clk             //|< i
  ,nvdla_core_rstn            //|< i
  ,cq_rd0_pd                  //|< i
  ,cq_rd0_pvld                //|< i
  ,cq_rd1_pd                  //|< i
  ,cq_rd1_pvld                //|< i
  ,cq_rd2_pd                  //|< i
  ,cq_rd2_pvld                //|< i
  ,cq_rd3_pd                  //|< i
  ,cq_rd3_pvld                //|< i
  ,cq_rd4_pd                  //|< i
  ,cq_rd4_pvld                //|< i
  ,cq_rd5_pd                  //|< i
  ,cq_rd5_pvld                //|< i
  ,cq_rd6_pd                  //|< i
  ,cq_rd6_pvld                //|< i
  ,cq_rd7_pd                  //|< i
  ,cq_rd7_pvld                //|< i
  ,cq_rd8_pd                  //|< i
  ,cq_rd8_pvld                //|< i
  ,cq_rd9_pd                  //|< i
  ,cq_rd9_pvld                //|< i
  ,mcif2bdma_rd_rsp_ready     //|< i
  ,mcif2cdma_dat_rd_rsp_ready //|< i
  ,mcif2cdma_wt_rd_rsp_ready  //|< i
  ,mcif2cdp_rd_rsp_ready      //|< i
  ,mcif2pdp_rd_rsp_ready      //|< i
  ,mcif2rbk_rd_rsp_ready      //|< i
  ,mcif2sdp_b_rd_rsp_ready    //|< i
  ,mcif2sdp_e_rd_rsp_ready    //|< i
  ,mcif2sdp_n_rd_rsp_ready    //|< i
  ,mcif2sdp_rd_rsp_ready      //|< i
  ,noc2mcif_axi_r_rdata       //|< i
  ,noc2mcif_axi_r_rid         //|< i
  ,noc2mcif_axi_r_rlast       //|< i
  ,noc2mcif_axi_r_rvalid      //|< i
  ,pwrbus_ram_pd              //|< i
  ,cq_rd0_prdy                //|> o
  ,cq_rd1_prdy                //|> o
  ,cq_rd2_prdy                //|> o
  ,cq_rd3_prdy                //|> o
  ,cq_rd4_prdy                //|> o
  ,cq_rd5_prdy                //|> o
  ,cq_rd6_prdy                //|> o
  ,cq_rd7_prdy                //|> o
  ,cq_rd8_prdy                //|> o
  ,cq_rd9_prdy                //|> o
  ,eg2ig_axi_vld              //|> o
  ,mcif2bdma_rd_rsp_pd        //|> o
  ,mcif2bdma_rd_rsp_valid     //|> o
  ,mcif2cdma_dat_rd_rsp_pd    //|> o
  ,mcif2cdma_dat_rd_rsp_valid //|> o
  ,mcif2cdma_wt_rd_rsp_pd     //|> o
  ,mcif2cdma_wt_rd_rsp_valid  //|> o
  ,mcif2cdp_rd_rsp_pd         //|> o
  ,mcif2cdp_rd_rsp_valid      //|> o
  ,mcif2pdp_rd_rsp_pd         //|> o
  ,mcif2pdp_rd_rsp_valid      //|> o
  ,mcif2rbk_rd_rsp_pd         //|> o
  ,mcif2rbk_rd_rsp_valid      //|> o
  ,mcif2sdp_b_rd_rsp_pd       //|> o
  ,mcif2sdp_b_rd_rsp_valid    //|> o
  ,mcif2sdp_e_rd_rsp_pd       //|> o
  ,mcif2sdp_e_rd_rsp_valid    //|> o
  ,mcif2sdp_n_rd_rsp_pd       //|> o
  ,mcif2sdp_n_rd_rsp_valid    //|> o
  ,mcif2sdp_rd_rsp_pd         //|> o
  ,mcif2sdp_rd_rsp_valid      //|> o
  ,noc2mcif_axi_r_rready      //|> o
  );

//
// NV_NVDLA_MCIF_READ_eg_ports.v
//
input  nvdla_core_clk;   /* mcif2sdp_rd_rsp, mcif2sdp_b_rd_rsp, mcif2sdp_n_rd_rsp, mcif2sdp_e_rd_rsp, mcif2cdp_rd_rsp, mcif2pdp_rd_rsp, mcif2bdma_rd_rsp, mcif2rbk_rd_rsp, mcif2cdma_wt_rd_rsp, mcif2cdma_dat_rd_rsp, cq_rd0, cq_rd1, cq_rd2, cq_rd3, cq_rd4, cq_rd5, cq_rd6, cq_rd7, cq_rd8, cq_rd9, noc2mcif_axi_r */
input  nvdla_core_rstn;  /* mcif2sdp_rd_rsp, mcif2sdp_b_rd_rsp, mcif2sdp_n_rd_rsp, mcif2sdp_e_rd_rsp, mcif2cdp_rd_rsp, mcif2pdp_rd_rsp, mcif2bdma_rd_rsp, mcif2rbk_rd_rsp, mcif2cdma_wt_rd_rsp, mcif2cdma_dat_rd_rsp, cq_rd0, cq_rd1, cq_rd2, cq_rd3, cq_rd4, cq_rd5, cq_rd6, cq_rd7, cq_rd8, cq_rd9, noc2mcif_axi_r */

output         mcif2sdp_rd_rsp_valid;  /* data valid */
input          mcif2sdp_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_rd_rsp_pd;

output         mcif2sdp_b_rd_rsp_valid;  /* data valid */
input          mcif2sdp_b_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_b_rd_rsp_pd;

output         mcif2sdp_n_rd_rsp_valid;  /* data valid */
input          mcif2sdp_n_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_n_rd_rsp_pd;

output         mcif2sdp_e_rd_rsp_valid;  /* data valid */
input          mcif2sdp_e_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_e_rd_rsp_pd;

output         mcif2cdp_rd_rsp_valid;  /* data valid */
input          mcif2cdp_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2cdp_rd_rsp_pd;

output         mcif2pdp_rd_rsp_valid;  /* data valid */
input          mcif2pdp_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2pdp_rd_rsp_pd;

output         mcif2bdma_rd_rsp_valid;  /* data valid */
input          mcif2bdma_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2bdma_rd_rsp_pd;

output         mcif2rbk_rd_rsp_valid;  /* data valid */
input          mcif2rbk_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2rbk_rd_rsp_pd;

output         mcif2cdma_wt_rd_rsp_valid;  /* data valid */
input          mcif2cdma_wt_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2cdma_wt_rd_rsp_pd;

output         mcif2cdma_dat_rd_rsp_valid;  /* data valid */
input          mcif2cdma_dat_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2cdma_dat_rd_rsp_pd;

input        cq_rd0_pvld;  /* data valid */
output       cq_rd0_prdy;  /* data return handshake */
input  [6:0] cq_rd0_pd;

input        cq_rd1_pvld;  /* data valid */
output       cq_rd1_prdy;  /* data return handshake */
input  [6:0] cq_rd1_pd;

input        cq_rd2_pvld;  /* data valid */
output       cq_rd2_prdy;  /* data return handshake */
input  [6:0] cq_rd2_pd;

input        cq_rd3_pvld;  /* data valid */
output       cq_rd3_prdy;  /* data return handshake */
input  [6:0] cq_rd3_pd;

input        cq_rd4_pvld;  /* data valid */
output       cq_rd4_prdy;  /* data return handshake */
input  [6:0] cq_rd4_pd;

input        cq_rd5_pvld;  /* data valid */
output       cq_rd5_prdy;  /* data return handshake */
input  [6:0] cq_rd5_pd;

input        cq_rd6_pvld;  /* data valid */
output       cq_rd6_prdy;  /* data return handshake */
input  [6:0] cq_rd6_pd;

input        cq_rd7_pvld;  /* data valid */
output       cq_rd7_prdy;  /* data return handshake */
input  [6:0] cq_rd7_pd;

input        cq_rd8_pvld;  /* data valid */
output       cq_rd8_prdy;  /* data return handshake */
input  [6:0] cq_rd8_pd;

input        cq_rd9_pvld;  /* data valid */
output       cq_rd9_prdy;  /* data return handshake */
input  [6:0] cq_rd9_pd;

input          noc2mcif_axi_r_rvalid;  /* data valid */
output         noc2mcif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2mcif_axi_r_rid;
input          noc2mcif_axi_r_rlast;
input  [511:0] noc2mcif_axi_r_rdata;

input [31:0] pwrbus_ram_pd;

output         eg2ig_axi_vld;
reg      [1:0] arb_cnt;
reg      [6:0] arb_cq_pd;
reg    [511:0] arb_data;
reg      [1:0] arb_wen;
reg      [1:0] ctt0_cnt;
reg      [6:0] ctt0_cq_pd;
reg            ctt0_vld;
reg      [1:0] ctt1_cnt;
reg      [6:0] ctt1_cq_pd;
reg            ctt1_vld;
reg      [1:0] ctt2_cnt;
reg      [6:0] ctt2_cq_pd;
reg            ctt2_vld;
reg      [1:0] ctt3_cnt;
reg      [6:0] ctt3_cq_pd;
reg            ctt3_vld;
reg      [1:0] ctt4_cnt;
reg      [6:0] ctt4_cq_pd;
reg            ctt4_vld;
reg      [1:0] ctt5_cnt;
reg      [6:0] ctt5_cq_pd;
reg            ctt5_vld;
reg      [1:0] ctt6_cnt;
reg      [6:0] ctt6_cq_pd;
reg            ctt6_vld;
reg      [1:0] ctt7_cnt;
reg      [6:0] ctt7_cq_pd;
reg            ctt7_vld;
reg      [1:0] ctt8_cnt;
reg      [6:0] ctt8_cq_pd;
reg            ctt8_vld;
reg      [1:0] ctt9_cnt;
reg      [6:0] ctt9_cq_pd;
reg            ctt9_vld;
wire           arb_cq_fdrop;
wire           arb_cq_ldrop;
wire     [1:0] arb_cq_lens;
wire           arb_cq_ltran;
wire           arb_cq_odd;
wire           arb_cq_swizzle;
wire   [255:0] arb_data0;
wire   [255:0] arb_data0_swizzled;
wire   [255:0] arb_data1;
wire   [255:0] arb_data1_swizzled;
wire           arb_first_beat;
wire           arb_last_beat;
wire   [256:0] arb_pd0;
wire   [256:0] arb_pd1;
wire           arb_wen0_swizzled;
wire           arb_wen1_swizzled;
wire           ctt0_accept;
wire           ctt0_last_beat;
wire           ctt0_rdy;
wire           ctt1_accept;
wire           ctt1_last_beat;
wire           ctt1_rdy;
wire           ctt2_accept;
wire           ctt2_last_beat;
wire           ctt2_rdy;
wire           ctt3_accept;
wire           ctt3_last_beat;
wire           ctt3_rdy;
wire           ctt4_accept;
wire           ctt4_last_beat;
wire           ctt4_rdy;
wire           ctt5_accept;
wire           ctt5_last_beat;
wire           ctt5_rdy;
wire           ctt6_accept;
wire           ctt6_last_beat;
wire           ctt6_rdy;
wire           ctt7_accept;
wire           ctt7_last_beat;
wire           ctt7_rdy;
wire           ctt8_accept;
wire           ctt8_last_beat;
wire           ctt8_rdy;
wire           ctt9_accept;
wire           ctt9_last_beat;
wire           ctt9_rdy;
wire   [511:0] dma0_data;
wire   [255:0] dma0_data0;
wire   [255:0] dma0_data1;
wire           dma0_is_last_odd;
wire           dma0_last_odd;
wire     [1:0] dma0_mask;
wire   [255:0] dma0_mdata0;
wire   [255:0] dma0_mdata1;
wire   [513:0] dma0_pd;
wire           dma0_rdy;
wire           dma0_vld;
wire   [511:0] dma1_data;
wire   [255:0] dma1_data0;
wire   [255:0] dma1_data1;
wire           dma1_is_last_odd;
wire           dma1_last_odd;
wire     [1:0] dma1_mask;
wire   [255:0] dma1_mdata0;
wire   [255:0] dma1_mdata1;
wire   [513:0] dma1_pd;
wire           dma1_rdy;
wire           dma1_vld;
wire   [511:0] dma2_data;
wire   [255:0] dma2_data0;
wire   [255:0] dma2_data1;
wire           dma2_is_last_odd;
wire           dma2_last_odd;
wire     [1:0] dma2_mask;
wire   [255:0] dma2_mdata0;
wire   [255:0] dma2_mdata1;
wire   [513:0] dma2_pd;
wire           dma2_rdy;
wire           dma2_vld;
wire   [511:0] dma3_data;
wire   [255:0] dma3_data0;
wire   [255:0] dma3_data1;
wire           dma3_is_last_odd;
wire           dma3_last_odd;
wire     [1:0] dma3_mask;
wire   [255:0] dma3_mdata0;
wire   [255:0] dma3_mdata1;
wire   [513:0] dma3_pd;
wire           dma3_rdy;
wire           dma3_vld;
wire   [511:0] dma4_data;
wire   [255:0] dma4_data0;
wire   [255:0] dma4_data1;
wire           dma4_is_last_odd;
wire           dma4_last_odd;
wire     [1:0] dma4_mask;
wire   [255:0] dma4_mdata0;
wire   [255:0] dma4_mdata1;
wire   [513:0] dma4_pd;
wire           dma4_rdy;
wire           dma4_vld;
wire   [511:0] dma5_data;
wire   [255:0] dma5_data0;
wire   [255:0] dma5_data1;
wire           dma5_is_last_odd;
wire           dma5_last_odd;
wire     [1:0] dma5_mask;
wire   [255:0] dma5_mdata0;
wire   [255:0] dma5_mdata1;
wire   [513:0] dma5_pd;
wire           dma5_rdy;
wire           dma5_vld;
wire   [511:0] dma6_data;
wire   [255:0] dma6_data0;
wire   [255:0] dma6_data1;
wire           dma6_is_last_odd;
wire           dma6_last_odd;
wire     [1:0] dma6_mask;
wire   [255:0] dma6_mdata0;
wire   [255:0] dma6_mdata1;
wire   [513:0] dma6_pd;
wire           dma6_rdy;
wire           dma6_vld;
wire   [511:0] dma7_data;
wire   [255:0] dma7_data0;
wire   [255:0] dma7_data1;
wire           dma7_is_last_odd;
wire           dma7_last_odd;
wire     [1:0] dma7_mask;
wire   [255:0] dma7_mdata0;
wire   [255:0] dma7_mdata1;
wire   [513:0] dma7_pd;
wire           dma7_rdy;
wire           dma7_vld;
wire   [511:0] dma8_data;
wire   [255:0] dma8_data0;
wire   [255:0] dma8_data1;
wire           dma8_is_last_odd;
wire           dma8_last_odd;
wire     [1:0] dma8_mask;
wire   [255:0] dma8_mdata0;
wire   [255:0] dma8_mdata1;
wire   [513:0] dma8_pd;
wire           dma8_rdy;
wire           dma8_vld;
wire   [511:0] dma9_data;
wire   [255:0] dma9_data0;
wire   [255:0] dma9_data1;
wire           dma9_is_last_odd;
wire           dma9_last_odd;
wire     [1:0] dma9_mask;
wire   [255:0] dma9_mdata0;
wire   [255:0] dma9_mdata1;
wire   [513:0] dma9_pd;
wire           dma9_rdy;
wire           dma9_vld;
wire     [3:0] ipipe_axi_axid;
wire   [511:0] ipipe_axi_data;
wire   [515:0] ipipe_axi_pd;
wire           ipipe_axi_rdy;
wire           ipipe_axi_vld;
wire           last_odd;
wire           mon_dma0_lodd;
wire           mon_dma1_lodd;
wire           mon_dma2_lodd;
wire           mon_dma3_lodd;
wire           mon_dma4_lodd;
wire           mon_dma5_lodd;
wire           mon_dma6_lodd;
wire           mon_dma7_lodd;
wire           mon_dma8_lodd;
wire           mon_dma9_lodd;
wire   [515:0] noc2mcif_axi_r_pd;
wire     [4:0] noc2mcif_axi_r_rid_NC;
wire           noc2mcif_axi_r_rlast_NC;
wire   [256:0] ro0_rd0_pd;
wire           ro0_rd0_prdy;
wire           ro0_rd0_pvld;
wire   [256:0] ro0_rd1_pd;
wire           ro0_rd1_prdy;
wire           ro0_rd1_pvld;
wire   [256:0] ro0_wr0_pd;
wire           ro0_wr0_prdy;
wire           ro0_wr0_pvld;
wire   [256:0] ro0_wr1_pd;
wire           ro0_wr1_prdy;
wire           ro0_wr1_pvld;
wire           ro0_wr_rdy;
wire   [256:0] ro1_rd0_pd;
wire           ro1_rd0_prdy;
wire           ro1_rd0_pvld;
wire   [256:0] ro1_rd1_pd;
wire           ro1_rd1_prdy;
wire           ro1_rd1_pvld;
wire   [256:0] ro1_wr0_pd;
wire           ro1_wr0_prdy;
wire           ro1_wr0_pvld;
wire   [256:0] ro1_wr1_pd;
wire           ro1_wr1_prdy;
wire           ro1_wr1_pvld;
wire           ro1_wr_rdy;
wire   [256:0] ro2_rd0_pd;
wire           ro2_rd0_prdy;
wire           ro2_rd0_pvld;
wire   [256:0] ro2_rd1_pd;
wire           ro2_rd1_prdy;
wire           ro2_rd1_pvld;
wire   [256:0] ro2_wr0_pd;
wire           ro2_wr0_prdy;
wire           ro2_wr0_pvld;
wire   [256:0] ro2_wr1_pd;
wire           ro2_wr1_prdy;
wire           ro2_wr1_pvld;
wire           ro2_wr_rdy;
wire   [256:0] ro3_rd0_pd;
wire           ro3_rd0_prdy;
wire           ro3_rd0_pvld;
wire   [256:0] ro3_rd1_pd;
wire           ro3_rd1_prdy;
wire           ro3_rd1_pvld;
wire   [256:0] ro3_wr0_pd;
wire           ro3_wr0_prdy;
wire           ro3_wr0_pvld;
wire   [256:0] ro3_wr1_pd;
wire           ro3_wr1_prdy;
wire           ro3_wr1_pvld;
wire           ro3_wr_rdy;
wire   [256:0] ro4_rd0_pd;
wire           ro4_rd0_prdy;
wire           ro4_rd0_pvld;
wire   [256:0] ro4_rd1_pd;
wire           ro4_rd1_prdy;
wire           ro4_rd1_pvld;
wire   [256:0] ro4_wr0_pd;
wire           ro4_wr0_prdy;
wire           ro4_wr0_pvld;
wire   [256:0] ro4_wr1_pd;
wire           ro4_wr1_prdy;
wire           ro4_wr1_pvld;
wire           ro4_wr_rdy;
wire   [256:0] ro5_rd0_pd;
wire           ro5_rd0_prdy;
wire           ro5_rd0_pvld;
wire   [256:0] ro5_rd1_pd;
wire           ro5_rd1_prdy;
wire           ro5_rd1_pvld;
wire   [256:0] ro5_wr0_pd;
wire           ro5_wr0_prdy;
wire           ro5_wr0_pvld;
wire   [256:0] ro5_wr1_pd;
wire           ro5_wr1_prdy;
wire           ro5_wr1_pvld;
wire           ro5_wr_rdy;
wire   [256:0] ro6_rd0_pd;
wire           ro6_rd0_prdy;
wire           ro6_rd0_pvld;
wire   [256:0] ro6_rd1_pd;
wire           ro6_rd1_prdy;
wire           ro6_rd1_pvld;
wire   [256:0] ro6_wr0_pd;
wire           ro6_wr0_prdy;
wire           ro6_wr0_pvld;
wire   [256:0] ro6_wr1_pd;
wire           ro6_wr1_prdy;
wire           ro6_wr1_pvld;
wire           ro6_wr_rdy;
wire   [256:0] ro7_rd0_pd;
wire           ro7_rd0_prdy;
wire           ro7_rd0_pvld;
wire   [256:0] ro7_rd1_pd;
wire           ro7_rd1_prdy;
wire           ro7_rd1_pvld;
wire   [256:0] ro7_wr0_pd;
wire           ro7_wr0_prdy;
wire           ro7_wr0_pvld;
wire   [256:0] ro7_wr1_pd;
wire           ro7_wr1_prdy;
wire           ro7_wr1_pvld;
wire           ro7_wr_rdy;
wire   [256:0] ro8_rd0_pd;
wire           ro8_rd0_prdy;
wire           ro8_rd0_pvld;
wire   [256:0] ro8_rd1_pd;
wire           ro8_rd1_prdy;
wire           ro8_rd1_pvld;
wire   [256:0] ro8_wr0_pd;
wire           ro8_wr0_prdy;
wire           ro8_wr0_pvld;
wire   [256:0] ro8_wr1_pd;
wire           ro8_wr1_prdy;
wire           ro8_wr1_pvld;
wire           ro8_wr_rdy;
wire   [256:0] ro9_rd0_pd;
wire           ro9_rd0_prdy;
wire           ro9_rd0_pvld;
wire   [256:0] ro9_rd1_pd;
wire           ro9_rd1_prdy;
wire           ro9_rd1_pvld;
wire   [256:0] ro9_wr0_pd;
wire           ro9_wr0_prdy;
wire           ro9_wr0_pvld;
wire   [256:0] ro9_wr1_pd;
wire           ro9_wr1_prdy;
wire           ro9_wr1_pvld;
wire           ro9_wr_rdy;
wire   [511:0] rq0_rd_pd;
wire           rq0_rd_prdy;
wire           rq0_rd_pvld;
wire   [511:0] rq0_wr_pd;
wire           rq0_wr_prdy;
wire           rq0_wr_pvld;
wire   [511:0] rq1_rd_pd;
wire           rq1_rd_prdy;
wire           rq1_rd_pvld;
wire   [511:0] rq1_wr_pd;
wire           rq1_wr_prdy;
wire           rq1_wr_pvld;
wire   [511:0] rq2_rd_pd;
wire           rq2_rd_prdy;
wire           rq2_rd_pvld;
wire   [511:0] rq2_wr_pd;
wire           rq2_wr_prdy;
wire           rq2_wr_pvld;
wire   [511:0] rq3_rd_pd;
wire           rq3_rd_prdy;
wire           rq3_rd_pvld;
wire   [511:0] rq3_wr_pd;
wire           rq3_wr_prdy;
wire           rq3_wr_pvld;
wire   [511:0] rq4_rd_pd;
wire           rq4_rd_prdy;
wire           rq4_rd_pvld;
wire   [511:0] rq4_wr_pd;
wire           rq4_wr_prdy;
wire           rq4_wr_pvld;
wire   [511:0] rq5_rd_pd;
wire           rq5_rd_prdy;
wire           rq5_rd_pvld;
wire   [511:0] rq5_wr_pd;
wire           rq5_wr_prdy;
wire           rq5_wr_pvld;
wire   [511:0] rq6_rd_pd;
wire           rq6_rd_prdy;
wire           rq6_rd_pvld;
wire   [511:0] rq6_wr_pd;
wire           rq6_wr_prdy;
wire           rq6_wr_pvld;
wire   [511:0] rq7_rd_pd;
wire           rq7_rd_prdy;
wire           rq7_rd_pvld;
wire   [511:0] rq7_wr_pd;
wire           rq7_wr_prdy;
wire           rq7_wr_pvld;
wire   [511:0] rq8_rd_pd;
wire           rq8_rd_prdy;
wire           rq8_rd_pvld;
wire   [511:0] rq8_wr_pd;
wire           rq8_wr_prdy;
wire           rq8_wr_pvld;
wire   [511:0] rq9_rd_pd;
wire           rq9_rd_prdy;
wire           rq9_rd_pvld;
wire   [511:0] rq9_wr_pd;
wire           rq9_wr_prdy;
wire           rq9_wr_pvld;
wire   [511:0] rq_wr_pd;
wire           src0_gnt;
wire           src0_req;
wire           src1_gnt;
wire           src1_req;
wire           src2_gnt;
wire           src2_req;
wire           src3_gnt;
wire           src3_req;
wire           src4_gnt;
wire           src4_req;
wire           src5_gnt;
wire           src5_req;
wire           src6_gnt;
wire           src6_req;
wire           src7_gnt;
wire           src7_req;
wire           src8_gnt;
wire           src8_req;
wire           src9_gnt;
wire           src9_req;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//stepheng,remove
// TIE-OFFs 
//assign noc2mcif_axi_r_rresp_NC = noc2mcif_axi_r_rresp;
assign noc2mcif_axi_r_rlast_NC = noc2mcif_axi_r_rlast;
//assign noc2mcif_axi_r_ruser_NC = noc2mcif_axi_r_ruser;
assign noc2mcif_axi_r_rid_NC   = noc2mcif_axi_r_rid[7:3];

assign noc2mcif_axi_r_pd = {noc2mcif_axi_r_rid[3:0],noc2mcif_axi_r_rdata};
NV_NVDLA_MCIF_READ_EG_pipe_p1 pipe_p1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ipipe_axi_rdy              (ipipe_axi_rdy)                  //|< w
  ,.noc2mcif_axi_r_pd          (noc2mcif_axi_r_pd[515:0])       //|< w
  ,.noc2mcif_axi_r_rvalid      (noc2mcif_axi_r_rvalid)          //|< i
  ,.ipipe_axi_pd               (ipipe_axi_pd[515:0])            //|> w
  ,.ipipe_axi_vld              (ipipe_axi_vld)                  //|> w
  ,.noc2mcif_axi_r_rready      (noc2mcif_axi_r_rready)          //|> o
  );

assign eg2ig_axi_vld = ipipe_axi_vld & ipipe_axi_rdy;

assign {ipipe_axi_axid,ipipe_axi_data} = ipipe_axi_pd;
assign rq_wr_pd = ipipe_axi_data;

// RFIFO WRITe side
assign ipipe_axi_rdy = (rq9_wr_pvld & rq9_wr_prdy)| (rq8_wr_pvld & rq8_wr_prdy)| (rq7_wr_pvld & rq7_wr_prdy)| (rq6_wr_pvld & rq6_wr_prdy)| (rq5_wr_pvld & rq5_wr_prdy)| (rq4_wr_pvld & rq4_wr_prdy)| (rq3_wr_pvld & rq3_wr_prdy)| (rq2_wr_pvld & rq2_wr_prdy)| (rq1_wr_pvld & rq1_wr_prdy)| (rq0_wr_pvld & rq0_wr_prdy);

assign rq0_wr_pvld = ipipe_axi_vld & (ipipe_axi_axid == 0);
assign rq0_wr_pd   = rq_wr_pd;

NV_NVDLA_MCIF_READ_EG_lat_fifo lat_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.rq_wr_prdy                 (rq0_wr_prdy)                    //|> w
  ,.rq_wr_pvld                 (rq0_wr_pvld)                    //|< w
  ,.rq_wr_pd                   (rq0_wr_pd[511:0])               //|< w
  ,.rq_rd_prdy                 (rq0_rd_prdy)                    //|< w
  ,.rq_rd_pvld                 (rq0_rd_pvld)                    //|> w
  ,.rq_rd_pd                   (rq0_rd_pd[511:0])               //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );

assign rq1_wr_pvld = ipipe_axi_vld & (ipipe_axi_axid == 1);
assign rq1_wr_pd   = rq_wr_pd;

NV_NVDLA_MCIF_READ_EG_lat_fifo lat_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.rq_wr_prdy                 (rq1_wr_prdy)                    //|> w
  ,.rq_wr_pvld                 (rq1_wr_pvld)                    //|< w
  ,.rq_wr_pd                   (rq1_wr_pd[511:0])               //|< w
  ,.rq_rd_prdy                 (rq1_rd_prdy)                    //|< w
  ,.rq_rd_pvld                 (rq1_rd_pvld)                    //|> w
  ,.rq_rd_pd                   (rq1_rd_pd[511:0])               //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );

assign rq2_wr_pvld = ipipe_axi_vld & (ipipe_axi_axid == 2);
assign rq2_wr_pd   = rq_wr_pd;

NV_NVDLA_MCIF_READ_EG_lat_fifo lat_fifo2 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.rq_wr_prdy                 (rq2_wr_prdy)                    //|> w
  ,.rq_wr_pvld                 (rq2_wr_pvld)                    //|< w
  ,.rq_wr_pd                   (rq2_wr_pd[511:0])               //|< w
  ,.rq_rd_prdy                 (rq2_rd_prdy)                    //|< w
  ,.rq_rd_pvld                 (rq2_rd_pvld)                    //|> w
  ,.rq_rd_pd                   (rq2_rd_pd[511:0])               //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );

assign rq3_wr_pvld = ipipe_axi_vld & (ipipe_axi_axid == 3);
assign rq3_wr_pd   = rq_wr_pd;

NV_NVDLA_MCIF_READ_EG_lat_fifo lat_fifo3 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.rq_wr_prdy                 (rq3_wr_prdy)                    //|> w
  ,.rq_wr_pvld                 (rq3_wr_pvld)                    //|< w
  ,.rq_wr_pd                   (rq3_wr_pd[511:0])               //|< w
  ,.rq_rd_prdy                 (rq3_rd_prdy)                    //|< w
  ,.rq_rd_pvld                 (rq3_rd_pvld)                    //|> w
  ,.rq_rd_pd                   (rq3_rd_pd[511:0])               //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );

assign rq4_wr_pvld = ipipe_axi_vld & (ipipe_axi_axid == 4);
assign rq4_wr_pd   = rq_wr_pd;

NV_NVDLA_MCIF_READ_EG_lat_fifo lat_fifo4 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.rq_wr_prdy                 (rq4_wr_prdy)                    //|> w
  ,.rq_wr_pvld                 (rq4_wr_pvld)                    //|< w
  ,.rq_wr_pd                   (rq4_wr_pd[511:0])               //|< w
  ,.rq_rd_prdy                 (rq4_rd_prdy)                    //|< w
  ,.rq_rd_pvld                 (rq4_rd_pvld)                    //|> w
  ,.rq_rd_pd                   (rq4_rd_pd[511:0])               //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );

assign rq5_wr_pvld = ipipe_axi_vld & (ipipe_axi_axid == 5);
assign rq5_wr_pd   = rq_wr_pd;

NV_NVDLA_MCIF_READ_EG_lat_fifo lat_fifo5 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.rq_wr_prdy                 (rq5_wr_prdy)                    //|> w
  ,.rq_wr_pvld                 (rq5_wr_pvld)                    //|< w
  ,.rq_wr_pd                   (rq5_wr_pd[511:0])               //|< w
  ,.rq_rd_prdy                 (rq5_rd_prdy)                    //|< w
  ,.rq_rd_pvld                 (rq5_rd_pvld)                    //|> w
  ,.rq_rd_pd                   (rq5_rd_pd[511:0])               //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );

assign rq6_wr_pvld = ipipe_axi_vld & (ipipe_axi_axid == 6);
assign rq6_wr_pd   = rq_wr_pd;

NV_NVDLA_MCIF_READ_EG_lat_fifo lat_fifo6 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.rq_wr_prdy                 (rq6_wr_prdy)                    //|> w
  ,.rq_wr_pvld                 (rq6_wr_pvld)                    //|< w
  ,.rq_wr_pd                   (rq6_wr_pd[511:0])               //|< w
  ,.rq_rd_prdy                 (rq6_rd_prdy)                    //|< w
  ,.rq_rd_pvld                 (rq6_rd_pvld)                    //|> w
  ,.rq_rd_pd                   (rq6_rd_pd[511:0])               //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );

assign rq7_wr_pvld = ipipe_axi_vld & (ipipe_axi_axid == 7);
assign rq7_wr_pd   = rq_wr_pd;

NV_NVDLA_MCIF_READ_EG_lat_fifo lat_fifo7 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.rq_wr_prdy                 (rq7_wr_prdy)                    //|> w
  ,.rq_wr_pvld                 (rq7_wr_pvld)                    //|< w
  ,.rq_wr_pd                   (rq7_wr_pd[511:0])               //|< w
  ,.rq_rd_prdy                 (rq7_rd_prdy)                    //|< w
  ,.rq_rd_pvld                 (rq7_rd_pvld)                    //|> w
  ,.rq_rd_pd                   (rq7_rd_pd[511:0])               //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );

assign rq8_wr_pvld = ipipe_axi_vld & (ipipe_axi_axid == 8);
assign rq8_wr_pd   = rq_wr_pd;

NV_NVDLA_MCIF_READ_EG_lat_fifo lat_fifo8 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.rq_wr_prdy                 (rq8_wr_prdy)                    //|> w
  ,.rq_wr_pvld                 (rq8_wr_pvld)                    //|< w
  ,.rq_wr_pd                   (rq8_wr_pd[511:0])               //|< w
  ,.rq_rd_prdy                 (rq8_rd_prdy)                    //|< w
  ,.rq_rd_pvld                 (rq8_rd_pvld)                    //|> w
  ,.rq_rd_pd                   (rq8_rd_pd[511:0])               //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );

assign rq9_wr_pvld = ipipe_axi_vld & (ipipe_axi_axid == 9);
assign rq9_wr_pd   = rq_wr_pd;

NV_NVDLA_MCIF_READ_EG_lat_fifo lat_fifo9 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.rq_wr_prdy                 (rq9_wr_prdy)                    //|> w
  ,.rq_wr_pvld                 (rq9_wr_pvld)                    //|< w
  ,.rq_wr_pd                   (rq9_wr_pd[511:0])               //|< w
  ,.rq_rd_prdy                 (rq9_rd_prdy)                    //|< w
  ,.rq_rd_pvld                 (rq9_rd_pvld)                    //|> w
  ,.rq_rd_pd                   (rq9_rd_pd[511:0])               //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );


assign src0_req = rq0_rd_pvld & ctt0_vld & ro0_wr_rdy;
assign ctt0_rdy = src0_gnt;
assign rq0_rd_prdy = src0_gnt;
assign src1_req = rq1_rd_pvld & ctt1_vld & ro1_wr_rdy;
assign ctt1_rdy = src1_gnt;
assign rq1_rd_prdy = src1_gnt;
assign src2_req = rq2_rd_pvld & ctt2_vld & ro2_wr_rdy;
assign ctt2_rdy = src2_gnt;
assign rq2_rd_prdy = src2_gnt;
assign src3_req = rq3_rd_pvld & ctt3_vld & ro3_wr_rdy;
assign ctt3_rdy = src3_gnt;
assign rq3_rd_prdy = src3_gnt;
assign src4_req = rq4_rd_pvld & ctt4_vld & ro4_wr_rdy;
assign ctt4_rdy = src4_gnt;
assign rq4_rd_prdy = src4_gnt;
assign src5_req = rq5_rd_pvld & ctt5_vld & ro5_wr_rdy;
assign ctt5_rdy = src5_gnt;
assign rq5_rd_prdy = src5_gnt;
assign src6_req = rq6_rd_pvld & ctt6_vld & ro6_wr_rdy;
assign ctt6_rdy = src6_gnt;
assign rq6_rd_prdy = src6_gnt;
assign src7_req = rq7_rd_pvld & ctt7_vld & ro7_wr_rdy;
assign ctt7_rdy = src7_gnt;
assign rq7_rd_prdy = src7_gnt;
assign src8_req = rq8_rd_pvld & ctt8_vld & ro8_wr_rdy;
assign ctt8_rdy = src8_gnt;
assign rq8_rd_prdy = src8_gnt;
assign src9_req = rq9_rd_pvld & ctt9_vld & ro9_wr_rdy;
assign ctt9_rdy = src9_gnt;
assign rq9_rd_prdy = src9_gnt;

//&PerlBeg;
//    my @dma_list = get_dma_list("mc","rd");
//    foreach $i (0..$#dma_list) {
//        my $dma = $dma_list[$i];
//        vprinti "
//        |assign wt${i} = reg2dp_rd_weight_${dma};
//        ";
//    }
//&PerlEnd;

// ARB
read_eg_arb u_read_eg_arb (
   .req0                       (src0_req)                       //|< w
  ,.req1                       (src1_req)                       //|< w
  ,.req2                       (src2_req)                       //|< w
  ,.req3                       (src3_req)                       //|< w
  ,.req4                       (src4_req)                       //|< w
  ,.req5                       (src5_req)                       //|< w
  ,.req6                       (src6_req)                       //|< w
  ,.req7                       (src7_req)                       //|< w
  ,.req8                       (src8_req)                       //|< w
  ,.req9                       (src9_req)                       //|< w
  ,.wt0                        ({8{1'b1}})                      //|< ?
  ,.wt1                        ({8{1'b1}})                      //|< ?
  ,.wt2                        ({8{1'b1}})                      //|< ?
  ,.wt3                        ({8{1'b1}})                      //|< ?
  ,.wt4                        ({8{1'b1}})                      //|< ?
  ,.wt5                        ({8{1'b1}})                      //|< ?
  ,.wt6                        ({8{1'b1}})                      //|< ?
  ,.wt7                        ({8{1'b1}})                      //|< ?
  ,.wt8                        ({8{1'b1}})                      //|< ?
  ,.wt9                        ({8{1'b1}})                      //|< ?
  ,.clk                        (nvdla_core_clk)                 //|< i
  ,.reset_                     (nvdla_core_rstn)                //|< i
  ,.gnt0                       (src0_gnt)                       //|> w
  ,.gnt1                       (src1_gnt)                       //|> w
  ,.gnt2                       (src2_gnt)                       //|> w
  ,.gnt3                       (src3_gnt)                       //|> w
  ,.gnt4                       (src4_gnt)                       //|> w
  ,.gnt5                       (src5_gnt)                       //|> w
  ,.gnt6                       (src6_gnt)                       //|> w
  ,.gnt7                       (src7_gnt)                       //|> w
  ,.gnt8                       (src8_gnt)                       //|> w
  ,.gnt9                       (src9_gnt)                       //|> w
  );
// NOTE:ezhang, we dont need Weighted But only RR in EG side

////assign arb_gnt = {::replcat_dn(NVDLA_GENERIC_MCIF_READ_DMA_NUM, ", ", '(src${ii}_gnt)')};

//&Always;
////spyglass disable_block W171 W226
//    case (BIT_HIGH)
//    endcase
////spyglass enable_block W171 W226
//&End;

always @(
  src0_gnt
  or rq0_rd_pd
  or src1_gnt
  or rq1_rd_pd
  or src2_gnt
  or rq2_rd_pd
  or src3_gnt
  or rq3_rd_pd
  or src4_gnt
  or rq4_rd_pd
  or src5_gnt
  or rq5_rd_pd
  or src6_gnt
  or rq6_rd_pd
  or src7_gnt
  or rq7_rd_pd
  or src8_gnt
  or rq8_rd_pd
  or src9_gnt
  or rq9_rd_pd
  ) begin
//spyglass disable_block W171 W226
    case (1'b1 )
      src0_gnt: arb_data = rq0_rd_pd;
      src1_gnt: arb_data = rq1_rd_pd;
      src2_gnt: arb_data = rq2_rd_pd;
      src3_gnt: arb_data = rq3_rd_pd;
      src4_gnt: arb_data = rq4_rd_pd;
      src5_gnt: arb_data = rq5_rd_pd;
      src6_gnt: arb_data = rq6_rd_pd;
      src7_gnt: arb_data = rq7_rd_pd;
      src8_gnt: arb_data = rq8_rd_pd;
      src9_gnt: arb_data = rq9_rd_pd;
    //VCS coverage off
    default : begin 
                arb_data[511:0] = {512{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

//&Always;
////spyglass disable_block W171 W226
//    case (BIT_HIGH)
//    endcase
////spyglass enable_block W171 W226
//&End;

//&Always;
////spyglass disable_block W171 W226
//    case (BIT_HIGH)
//    endcase
////spyglass enable_block W171 W226
//&End;

always @(
  src0_gnt
  or ctt0_cq_pd
  or src1_gnt
  or ctt1_cq_pd
  or src2_gnt
  or ctt2_cq_pd
  or src3_gnt
  or ctt3_cq_pd
  or src4_gnt
  or ctt4_cq_pd
  or src5_gnt
  or ctt5_cq_pd
  or src6_gnt
  or ctt6_cq_pd
  or src7_gnt
  or ctt7_cq_pd
  or src8_gnt
  or ctt8_cq_pd
  or src9_gnt
  or ctt9_cq_pd
  ) begin
//spyglass disable_block W171 W226
    case (1'b1 )
      src0_gnt: arb_cq_pd = ctt0_cq_pd;
      src1_gnt: arb_cq_pd = ctt1_cq_pd;
      src2_gnt: arb_cq_pd = ctt2_cq_pd;
      src3_gnt: arb_cq_pd = ctt3_cq_pd;
      src4_gnt: arb_cq_pd = ctt4_cq_pd;
      src5_gnt: arb_cq_pd = ctt5_cq_pd;
      src6_gnt: arb_cq_pd = ctt6_cq_pd;
      src7_gnt: arb_cq_pd = ctt7_cq_pd;
      src8_gnt: arb_cq_pd = ctt8_cq_pd;
      src9_gnt: arb_cq_pd = ctt9_cq_pd;
    //VCS coverage off
    default : begin 
                arb_cq_pd[6:0] = {7{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

always @(
  src0_gnt
  or ctt0_cnt
  or src1_gnt
  or ctt1_cnt
  or src2_gnt
  or ctt2_cnt
  or src3_gnt
  or ctt3_cnt
  or src4_gnt
  or ctt4_cnt
  or src5_gnt
  or ctt5_cnt
  or src6_gnt
  or ctt6_cnt
  or src7_gnt
  or ctt7_cnt
  or src8_gnt
  or ctt8_cnt
  or src9_gnt
  or ctt9_cnt
  ) begin
//spyglass disable_block W171 W226
    case (1'b1 )
      src0_gnt: arb_cnt = ctt0_cnt;
      src1_gnt: arb_cnt = ctt1_cnt;
      src2_gnt: arb_cnt = ctt2_cnt;
      src3_gnt: arb_cnt = ctt3_cnt;
      src4_gnt: arb_cnt = ctt4_cnt;
      src5_gnt: arb_cnt = ctt5_cnt;
      src6_gnt: arb_cnt = ctt6_cnt;
      src7_gnt: arb_cnt = ctt7_cnt;
      src8_gnt: arb_cnt = ctt8_cnt;
      src9_gnt: arb_cnt = ctt9_cnt;
    //VCS coverage off
    default : begin 
                arb_cnt[1:0] = {2{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end


// PKT_UNPACK_WIRE( nocif_read_ig2eg , arb_cq_ , arb_cq_pd )
assign       arb_cq_lens[1:0] =    arb_cq_pd[1:0];
assign        arb_cq_swizzle  =    arb_cq_pd[2];
assign        arb_cq_odd  =    arb_cq_pd[3];
assign        arb_cq_ltran  =    arb_cq_pd[4];
assign        arb_cq_fdrop  =    arb_cq_pd[5];
assign        arb_cq_ldrop  =    arb_cq_pd[6];
always @(
  arb_first_beat
  or arb_cq_fdrop
  or arb_last_beat
  or arb_cq_ldrop
  ) begin
    if (arb_first_beat && arb_cq_fdrop) begin
        arb_wen = 2'b10;
    end else if (arb_last_beat && arb_cq_ldrop) begin
        arb_wen = 2'b01;
    end else begin
        arb_wen = 2'b11;
    end
end

assign last_odd = arb_last_beat && arb_cq_ltran && arb_cq_odd;

assign arb_data0 = {arb_data[255:0]};
assign arb_data1 = {arb_data[511:256]};
assign arb_data0_swizzled = arb_cq_swizzle ? arb_data1 : arb_data0; 
assign arb_data1_swizzled = arb_cq_swizzle ? arb_data0 : arb_data1; 
assign arb_pd0 = {last_odd,arb_data0_swizzled};
assign arb_pd1 = {1'b0    ,arb_data1_swizzled};

assign arb_wen0_swizzled = arb_cq_swizzle ? arb_wen[1] : arb_wen[0];
assign arb_wen1_swizzled = arb_cq_swizzle ? arb_wen[0] : arb_wen[1];
        
assign arb_last_beat  = (arb_cnt==arb_cq_lens);
assign arb_first_beat = (arb_cnt==0);

assign ro0_wr_rdy = ro0_wr0_prdy & ro0_wr1_prdy;
assign ro0_wr0_pvld = src0_gnt & arb_wen0_swizzled & ro0_wr1_prdy;
assign ro0_wr0_pd  = arb_pd0;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro0_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro0_wr0_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro0_wr0_pvld)                   //|< w
  ,.ro_wr_pd                   (ro0_wr0_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro0_rd0_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro0_rd0_pvld)                   //|> w
  ,.ro_rd_pd                   (ro0_rd0_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign ro0_wr1_pvld = src0_gnt & arb_wen1_swizzled & ro0_wr0_prdy;
assign ro0_wr1_pd  = arb_pd1;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro0_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro0_wr1_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro0_wr1_pvld)                   //|< w
  ,.ro_wr_pd                   (ro0_wr1_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro0_rd1_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro0_rd1_pvld)                   //|> w
  ,.ro_rd_pd                   (ro0_rd1_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign dma0_vld = ro0_rd0_pvld & (dma0_last_odd ? 1'b1 : ro0_rd1_pvld);

assign {dma0_last_odd,dma0_data0[255:0]} = ro0_rd0_pd;
assign {mon_dma0_lodd,dma0_data1[255:0]} = ro0_rd1_pd;
assign dma0_is_last_odd = ro0_rd0_pvld & dma0_last_odd;

assign dma0_mask  = dma0_is_last_odd ? 2'b01 : 2'b11;
assign dma0_mdata0 = {256{dma0_mask[0]}} & dma0_data0;
assign dma0_mdata1 = {256{dma0_mask[1]}} & dma0_data1;
assign dma0_data  = {dma0_mdata1,dma0_mdata0};

assign dma0_pd    = {dma0_mask,dma0_data};

assign ro0_rd0_prdy = dma0_rdy & (dma0_is_last_odd ? 1'b1 : ro0_rd1_pvld);
assign ro0_rd1_prdy = dma0_rdy & (dma0_is_last_odd ? 1'b0 : ro0_rd0_pvld);
NV_NVDLA_MCIF_READ_EG_pipe_p2 pipe_p2 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma0_pd                    (dma0_pd[513:0])                 //|< w
  ,.dma0_vld                   (dma0_vld)                       //|< w
  ,.mcif2bdma_rd_rsp_ready     (mcif2bdma_rd_rsp_ready)         //|< i
  ,.dma0_rdy                   (dma0_rdy)                       //|> w
  ,.mcif2bdma_rd_rsp_pd        (mcif2bdma_rd_rsp_pd[513:0])     //|> o
  ,.mcif2bdma_rd_rsp_valid     (mcif2bdma_rd_rsp_valid)         //|> o
  );

assign ro1_wr_rdy = ro1_wr0_prdy & ro1_wr1_prdy;
assign ro1_wr0_pvld = src1_gnt & arb_wen0_swizzled & ro1_wr1_prdy;
assign ro1_wr0_pd  = arb_pd0;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro1_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro1_wr0_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro1_wr0_pvld)                   //|< w
  ,.ro_wr_pd                   (ro1_wr0_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro1_rd0_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro1_rd0_pvld)                   //|> w
  ,.ro_rd_pd                   (ro1_rd0_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign ro1_wr1_pvld = src1_gnt & arb_wen1_swizzled & ro1_wr0_prdy;
assign ro1_wr1_pd  = arb_pd1;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro1_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro1_wr1_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro1_wr1_pvld)                   //|< w
  ,.ro_wr_pd                   (ro1_wr1_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro1_rd1_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro1_rd1_pvld)                   //|> w
  ,.ro_rd_pd                   (ro1_rd1_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign dma1_vld = ro1_rd0_pvld & (dma1_last_odd ? 1'b1 : ro1_rd1_pvld);

assign {dma1_last_odd,dma1_data0[255:0]} = ro1_rd0_pd;
assign {mon_dma1_lodd,dma1_data1[255:0]} = ro1_rd1_pd;
assign dma1_is_last_odd = ro1_rd0_pvld & dma1_last_odd;

assign dma1_mask  = dma1_is_last_odd ? 2'b01 : 2'b11;
assign dma1_mdata0 = {256{dma1_mask[0]}} & dma1_data0;
assign dma1_mdata1 = {256{dma1_mask[1]}} & dma1_data1;
assign dma1_data  = {dma1_mdata1,dma1_mdata0};

assign dma1_pd    = {dma1_mask,dma1_data};

assign ro1_rd0_prdy = dma1_rdy & (dma1_is_last_odd ? 1'b1 : ro1_rd1_pvld);
assign ro1_rd1_prdy = dma1_rdy & (dma1_is_last_odd ? 1'b0 : ro1_rd0_pvld);
NV_NVDLA_MCIF_READ_EG_pipe_p3 pipe_p3 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma1_pd                    (dma1_pd[513:0])                 //|< w
  ,.dma1_vld                   (dma1_vld)                       //|< w
  ,.mcif2sdp_rd_rsp_ready      (mcif2sdp_rd_rsp_ready)          //|< i
  ,.dma1_rdy                   (dma1_rdy)                       //|> w
  ,.mcif2sdp_rd_rsp_pd         (mcif2sdp_rd_rsp_pd[513:0])      //|> o
  ,.mcif2sdp_rd_rsp_valid      (mcif2sdp_rd_rsp_valid)          //|> o
  );

assign ro2_wr_rdy = ro2_wr0_prdy & ro2_wr1_prdy;
assign ro2_wr0_pvld = src2_gnt & arb_wen0_swizzled & ro2_wr1_prdy;
assign ro2_wr0_pd  = arb_pd0;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro2_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro2_wr0_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro2_wr0_pvld)                   //|< w
  ,.ro_wr_pd                   (ro2_wr0_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro2_rd0_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro2_rd0_pvld)                   //|> w
  ,.ro_rd_pd                   (ro2_rd0_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign ro2_wr1_pvld = src2_gnt & arb_wen1_swizzled & ro2_wr0_prdy;
assign ro2_wr1_pd  = arb_pd1;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro2_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro2_wr1_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro2_wr1_pvld)                   //|< w
  ,.ro_wr_pd                   (ro2_wr1_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro2_rd1_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro2_rd1_pvld)                   //|> w
  ,.ro_rd_pd                   (ro2_rd1_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign dma2_vld = ro2_rd0_pvld & (dma2_last_odd ? 1'b1 : ro2_rd1_pvld);

assign {dma2_last_odd,dma2_data0[255:0]} = ro2_rd0_pd;
assign {mon_dma2_lodd,dma2_data1[255:0]} = ro2_rd1_pd;
assign dma2_is_last_odd = ro2_rd0_pvld & dma2_last_odd;

assign dma2_mask  = dma2_is_last_odd ? 2'b01 : 2'b11;
assign dma2_mdata0 = {256{dma2_mask[0]}} & dma2_data0;
assign dma2_mdata1 = {256{dma2_mask[1]}} & dma2_data1;
assign dma2_data  = {dma2_mdata1,dma2_mdata0};

assign dma2_pd    = {dma2_mask,dma2_data};

assign ro2_rd0_prdy = dma2_rdy & (dma2_is_last_odd ? 1'b1 : ro2_rd1_pvld);
assign ro2_rd1_prdy = dma2_rdy & (dma2_is_last_odd ? 1'b0 : ro2_rd0_pvld);
NV_NVDLA_MCIF_READ_EG_pipe_p4 pipe_p4 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma2_pd                    (dma2_pd[513:0])                 //|< w
  ,.dma2_vld                   (dma2_vld)                       //|< w
  ,.mcif2pdp_rd_rsp_ready      (mcif2pdp_rd_rsp_ready)          //|< i
  ,.dma2_rdy                   (dma2_rdy)                       //|> w
  ,.mcif2pdp_rd_rsp_pd         (mcif2pdp_rd_rsp_pd[513:0])      //|> o
  ,.mcif2pdp_rd_rsp_valid      (mcif2pdp_rd_rsp_valid)          //|> o
  );

assign ro3_wr_rdy = ro3_wr0_prdy & ro3_wr1_prdy;
assign ro3_wr0_pvld = src3_gnt & arb_wen0_swizzled & ro3_wr1_prdy;
assign ro3_wr0_pd  = arb_pd0;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro3_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro3_wr0_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro3_wr0_pvld)                   //|< w
  ,.ro_wr_pd                   (ro3_wr0_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro3_rd0_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro3_rd0_pvld)                   //|> w
  ,.ro_rd_pd                   (ro3_rd0_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign ro3_wr1_pvld = src3_gnt & arb_wen1_swizzled & ro3_wr0_prdy;
assign ro3_wr1_pd  = arb_pd1;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro3_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro3_wr1_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro3_wr1_pvld)                   //|< w
  ,.ro_wr_pd                   (ro3_wr1_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro3_rd1_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro3_rd1_pvld)                   //|> w
  ,.ro_rd_pd                   (ro3_rd1_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign dma3_vld = ro3_rd0_pvld & (dma3_last_odd ? 1'b1 : ro3_rd1_pvld);

assign {dma3_last_odd,dma3_data0[255:0]} = ro3_rd0_pd;
assign {mon_dma3_lodd,dma3_data1[255:0]} = ro3_rd1_pd;
assign dma3_is_last_odd = ro3_rd0_pvld & dma3_last_odd;

assign dma3_mask  = dma3_is_last_odd ? 2'b01 : 2'b11;
assign dma3_mdata0 = {256{dma3_mask[0]}} & dma3_data0;
assign dma3_mdata1 = {256{dma3_mask[1]}} & dma3_data1;
assign dma3_data  = {dma3_mdata1,dma3_mdata0};

assign dma3_pd    = {dma3_mask,dma3_data};

assign ro3_rd0_prdy = dma3_rdy & (dma3_is_last_odd ? 1'b1 : ro3_rd1_pvld);
assign ro3_rd1_prdy = dma3_rdy & (dma3_is_last_odd ? 1'b0 : ro3_rd0_pvld);
NV_NVDLA_MCIF_READ_EG_pipe_p5 pipe_p5 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma3_pd                    (dma3_pd[513:0])                 //|< w
  ,.dma3_vld                   (dma3_vld)                       //|< w
  ,.mcif2cdp_rd_rsp_ready      (mcif2cdp_rd_rsp_ready)          //|< i
  ,.dma3_rdy                   (dma3_rdy)                       //|> w
  ,.mcif2cdp_rd_rsp_pd         (mcif2cdp_rd_rsp_pd[513:0])      //|> o
  ,.mcif2cdp_rd_rsp_valid      (mcif2cdp_rd_rsp_valid)          //|> o
  );

assign ro4_wr_rdy = ro4_wr0_prdy & ro4_wr1_prdy;
assign ro4_wr0_pvld = src4_gnt & arb_wen0_swizzled & ro4_wr1_prdy;
assign ro4_wr0_pd  = arb_pd0;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro4_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro4_wr0_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro4_wr0_pvld)                   //|< w
  ,.ro_wr_pd                   (ro4_wr0_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro4_rd0_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro4_rd0_pvld)                   //|> w
  ,.ro_rd_pd                   (ro4_rd0_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign ro4_wr1_pvld = src4_gnt & arb_wen1_swizzled & ro4_wr0_prdy;
assign ro4_wr1_pd  = arb_pd1;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro4_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro4_wr1_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro4_wr1_pvld)                   //|< w
  ,.ro_wr_pd                   (ro4_wr1_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro4_rd1_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro4_rd1_pvld)                   //|> w
  ,.ro_rd_pd                   (ro4_rd1_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign dma4_vld = ro4_rd0_pvld & (dma4_last_odd ? 1'b1 : ro4_rd1_pvld);

assign {dma4_last_odd,dma4_data0[255:0]} = ro4_rd0_pd;
assign {mon_dma4_lodd,dma4_data1[255:0]} = ro4_rd1_pd;
assign dma4_is_last_odd = ro4_rd0_pvld & dma4_last_odd;

assign dma4_mask  = dma4_is_last_odd ? 2'b01 : 2'b11;
assign dma4_mdata0 = {256{dma4_mask[0]}} & dma4_data0;
assign dma4_mdata1 = {256{dma4_mask[1]}} & dma4_data1;
assign dma4_data  = {dma4_mdata1,dma4_mdata0};

assign dma4_pd    = {dma4_mask,dma4_data};

assign ro4_rd0_prdy = dma4_rdy & (dma4_is_last_odd ? 1'b1 : ro4_rd1_pvld);
assign ro4_rd1_prdy = dma4_rdy & (dma4_is_last_odd ? 1'b0 : ro4_rd0_pvld);
NV_NVDLA_MCIF_READ_EG_pipe_p6 pipe_p6 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma4_pd                    (dma4_pd[513:0])                 //|< w
  ,.dma4_vld                   (dma4_vld)                       //|< w
  ,.mcif2rbk_rd_rsp_ready      (mcif2rbk_rd_rsp_ready)          //|< i
  ,.dma4_rdy                   (dma4_rdy)                       //|> w
  ,.mcif2rbk_rd_rsp_pd         (mcif2rbk_rd_rsp_pd[513:0])      //|> o
  ,.mcif2rbk_rd_rsp_valid      (mcif2rbk_rd_rsp_valid)          //|> o
  );

assign ro5_wr_rdy = ro5_wr0_prdy & ro5_wr1_prdy;
assign ro5_wr0_pvld = src5_gnt & arb_wen0_swizzled & ro5_wr1_prdy;
assign ro5_wr0_pd  = arb_pd0;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro5_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro5_wr0_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro5_wr0_pvld)                   //|< w
  ,.ro_wr_pd                   (ro5_wr0_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro5_rd0_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro5_rd0_pvld)                   //|> w
  ,.ro_rd_pd                   (ro5_rd0_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign ro5_wr1_pvld = src5_gnt & arb_wen1_swizzled & ro5_wr0_prdy;
assign ro5_wr1_pd  = arb_pd1;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro5_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro5_wr1_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro5_wr1_pvld)                   //|< w
  ,.ro_wr_pd                   (ro5_wr1_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro5_rd1_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro5_rd1_pvld)                   //|> w
  ,.ro_rd_pd                   (ro5_rd1_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign dma5_vld = ro5_rd0_pvld & (dma5_last_odd ? 1'b1 : ro5_rd1_pvld);

assign {dma5_last_odd,dma5_data0[255:0]} = ro5_rd0_pd;
assign {mon_dma5_lodd,dma5_data1[255:0]} = ro5_rd1_pd;
assign dma5_is_last_odd = ro5_rd0_pvld & dma5_last_odd;

assign dma5_mask  = dma5_is_last_odd ? 2'b01 : 2'b11;
assign dma5_mdata0 = {256{dma5_mask[0]}} & dma5_data0;
assign dma5_mdata1 = {256{dma5_mask[1]}} & dma5_data1;
assign dma5_data  = {dma5_mdata1,dma5_mdata0};

assign dma5_pd    = {dma5_mask,dma5_data};

assign ro5_rd0_prdy = dma5_rdy & (dma5_is_last_odd ? 1'b1 : ro5_rd1_pvld);
assign ro5_rd1_prdy = dma5_rdy & (dma5_is_last_odd ? 1'b0 : ro5_rd0_pvld);
NV_NVDLA_MCIF_READ_EG_pipe_p7 pipe_p7 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma5_pd                    (dma5_pd[513:0])                 //|< w
  ,.dma5_vld                   (dma5_vld)                       //|< w
  ,.mcif2sdp_b_rd_rsp_ready    (mcif2sdp_b_rd_rsp_ready)        //|< i
  ,.dma5_rdy                   (dma5_rdy)                       //|> w
  ,.mcif2sdp_b_rd_rsp_pd       (mcif2sdp_b_rd_rsp_pd[513:0])    //|> o
  ,.mcif2sdp_b_rd_rsp_valid    (mcif2sdp_b_rd_rsp_valid)        //|> o
  );

assign ro6_wr_rdy = ro6_wr0_prdy & ro6_wr1_prdy;
assign ro6_wr0_pvld = src6_gnt & arb_wen0_swizzled & ro6_wr1_prdy;
assign ro6_wr0_pd  = arb_pd0;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro6_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro6_wr0_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro6_wr0_pvld)                   //|< w
  ,.ro_wr_pd                   (ro6_wr0_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro6_rd0_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro6_rd0_pvld)                   //|> w
  ,.ro_rd_pd                   (ro6_rd0_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign ro6_wr1_pvld = src6_gnt & arb_wen1_swizzled & ro6_wr0_prdy;
assign ro6_wr1_pd  = arb_pd1;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro6_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro6_wr1_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro6_wr1_pvld)                   //|< w
  ,.ro_wr_pd                   (ro6_wr1_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro6_rd1_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro6_rd1_pvld)                   //|> w
  ,.ro_rd_pd                   (ro6_rd1_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign dma6_vld = ro6_rd0_pvld & (dma6_last_odd ? 1'b1 : ro6_rd1_pvld);

assign {dma6_last_odd,dma6_data0[255:0]} = ro6_rd0_pd;
assign {mon_dma6_lodd,dma6_data1[255:0]} = ro6_rd1_pd;
assign dma6_is_last_odd = ro6_rd0_pvld & dma6_last_odd;

assign dma6_mask  = dma6_is_last_odd ? 2'b01 : 2'b11;
assign dma6_mdata0 = {256{dma6_mask[0]}} & dma6_data0;
assign dma6_mdata1 = {256{dma6_mask[1]}} & dma6_data1;
assign dma6_data  = {dma6_mdata1,dma6_mdata0};

assign dma6_pd    = {dma6_mask,dma6_data};

assign ro6_rd0_prdy = dma6_rdy & (dma6_is_last_odd ? 1'b1 : ro6_rd1_pvld);
assign ro6_rd1_prdy = dma6_rdy & (dma6_is_last_odd ? 1'b0 : ro6_rd0_pvld);
NV_NVDLA_MCIF_READ_EG_pipe_p8 pipe_p8 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma6_pd                    (dma6_pd[513:0])                 //|< w
  ,.dma6_vld                   (dma6_vld)                       //|< w
  ,.mcif2sdp_n_rd_rsp_ready    (mcif2sdp_n_rd_rsp_ready)        //|< i
  ,.dma6_rdy                   (dma6_rdy)                       //|> w
  ,.mcif2sdp_n_rd_rsp_pd       (mcif2sdp_n_rd_rsp_pd[513:0])    //|> o
  ,.mcif2sdp_n_rd_rsp_valid    (mcif2sdp_n_rd_rsp_valid)        //|> o
  );

assign ro7_wr_rdy = ro7_wr0_prdy & ro7_wr1_prdy;
assign ro7_wr0_pvld = src7_gnt & arb_wen0_swizzled & ro7_wr1_prdy;
assign ro7_wr0_pd  = arb_pd0;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro7_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro7_wr0_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro7_wr0_pvld)                   //|< w
  ,.ro_wr_pd                   (ro7_wr0_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro7_rd0_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro7_rd0_pvld)                   //|> w
  ,.ro_rd_pd                   (ro7_rd0_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign ro7_wr1_pvld = src7_gnt & arb_wen1_swizzled & ro7_wr0_prdy;
assign ro7_wr1_pd  = arb_pd1;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro7_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro7_wr1_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro7_wr1_pvld)                   //|< w
  ,.ro_wr_pd                   (ro7_wr1_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro7_rd1_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro7_rd1_pvld)                   //|> w
  ,.ro_rd_pd                   (ro7_rd1_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign dma7_vld = ro7_rd0_pvld & (dma7_last_odd ? 1'b1 : ro7_rd1_pvld);

assign {dma7_last_odd,dma7_data0[255:0]} = ro7_rd0_pd;
assign {mon_dma7_lodd,dma7_data1[255:0]} = ro7_rd1_pd;
assign dma7_is_last_odd = ro7_rd0_pvld & dma7_last_odd;

assign dma7_mask  = dma7_is_last_odd ? 2'b01 : 2'b11;
assign dma7_mdata0 = {256{dma7_mask[0]}} & dma7_data0;
assign dma7_mdata1 = {256{dma7_mask[1]}} & dma7_data1;
assign dma7_data  = {dma7_mdata1,dma7_mdata0};

assign dma7_pd    = {dma7_mask,dma7_data};

assign ro7_rd0_prdy = dma7_rdy & (dma7_is_last_odd ? 1'b1 : ro7_rd1_pvld);
assign ro7_rd1_prdy = dma7_rdy & (dma7_is_last_odd ? 1'b0 : ro7_rd0_pvld);
NV_NVDLA_MCIF_READ_EG_pipe_p9 pipe_p9 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma7_pd                    (dma7_pd[513:0])                 //|< w
  ,.dma7_vld                   (dma7_vld)                       //|< w
  ,.mcif2sdp_e_rd_rsp_ready    (mcif2sdp_e_rd_rsp_ready)        //|< i
  ,.dma7_rdy                   (dma7_rdy)                       //|> w
  ,.mcif2sdp_e_rd_rsp_pd       (mcif2sdp_e_rd_rsp_pd[513:0])    //|> o
  ,.mcif2sdp_e_rd_rsp_valid    (mcif2sdp_e_rd_rsp_valid)        //|> o
  );

assign ro8_wr_rdy = ro8_wr0_prdy & ro8_wr1_prdy;
assign ro8_wr0_pvld = src8_gnt & arb_wen0_swizzled & ro8_wr1_prdy;
assign ro8_wr0_pd  = arb_pd0;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro8_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro8_wr0_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro8_wr0_pvld)                   //|< w
  ,.ro_wr_pd                   (ro8_wr0_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro8_rd0_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro8_rd0_pvld)                   //|> w
  ,.ro_rd_pd                   (ro8_rd0_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign ro8_wr1_pvld = src8_gnt & arb_wen1_swizzled & ro8_wr0_prdy;
assign ro8_wr1_pd  = arb_pd1;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro8_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro8_wr1_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro8_wr1_pvld)                   //|< w
  ,.ro_wr_pd                   (ro8_wr1_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro8_rd1_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro8_rd1_pvld)                   //|> w
  ,.ro_rd_pd                   (ro8_rd1_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign dma8_vld = ro8_rd0_pvld & (dma8_last_odd ? 1'b1 : ro8_rd1_pvld);

assign {dma8_last_odd,dma8_data0[255:0]} = ro8_rd0_pd;
assign {mon_dma8_lodd,dma8_data1[255:0]} = ro8_rd1_pd;
assign dma8_is_last_odd = ro8_rd0_pvld & dma8_last_odd;

assign dma8_mask  = dma8_is_last_odd ? 2'b01 : 2'b11;
assign dma8_mdata0 = {256{dma8_mask[0]}} & dma8_data0;
assign dma8_mdata1 = {256{dma8_mask[1]}} & dma8_data1;
assign dma8_data  = {dma8_mdata1,dma8_mdata0};

assign dma8_pd    = {dma8_mask,dma8_data};

assign ro8_rd0_prdy = dma8_rdy & (dma8_is_last_odd ? 1'b1 : ro8_rd1_pvld);
assign ro8_rd1_prdy = dma8_rdy & (dma8_is_last_odd ? 1'b0 : ro8_rd0_pvld);
NV_NVDLA_MCIF_READ_EG_pipe_p10 pipe_p10 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma8_pd                    (dma8_pd[513:0])                 //|< w
  ,.dma8_vld                   (dma8_vld)                       //|< w
  ,.mcif2cdma_dat_rd_rsp_ready (mcif2cdma_dat_rd_rsp_ready)     //|< i
  ,.dma8_rdy                   (dma8_rdy)                       //|> w
  ,.mcif2cdma_dat_rd_rsp_pd    (mcif2cdma_dat_rd_rsp_pd[513:0]) //|> o
  ,.mcif2cdma_dat_rd_rsp_valid (mcif2cdma_dat_rd_rsp_valid)     //|> o
  );

assign ro9_wr_rdy = ro9_wr0_prdy & ro9_wr1_prdy;
assign ro9_wr0_pvld = src9_gnt & arb_wen0_swizzled & ro9_wr1_prdy;
assign ro9_wr0_pd  = arb_pd0;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro9_fifo0 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro9_wr0_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro9_wr0_pvld)                   //|< w
  ,.ro_wr_pd                   (ro9_wr0_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro9_rd0_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro9_rd0_pvld)                   //|> w
  ,.ro_rd_pd                   (ro9_rd0_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign ro9_wr1_pvld = src9_gnt & arb_wen1_swizzled & ro9_wr0_prdy;
assign ro9_wr1_pd  = arb_pd1;
NV_NVDLA_MCIF_READ_EG_ro_fifo ro9_fifo1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.ro_wr_prdy                 (ro9_wr1_prdy)                   //|> w
  ,.ro_wr_pvld                 (ro9_wr1_pvld)                   //|< w
  ,.ro_wr_pd                   (ro9_wr1_pd[256:0])              //|< w
  ,.ro_rd_prdy                 (ro9_rd1_prdy)                   //|< w
  ,.ro_rd_pvld                 (ro9_rd1_pvld)                   //|> w
  ,.ro_rd_pd                   (ro9_rd1_pd[256:0])              //|> w
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  );
assign dma9_vld = ro9_rd0_pvld & (dma9_last_odd ? 1'b1 : ro9_rd1_pvld);

assign {dma9_last_odd,dma9_data0[255:0]} = ro9_rd0_pd;
assign {mon_dma9_lodd,dma9_data1[255:0]} = ro9_rd1_pd;
assign dma9_is_last_odd = ro9_rd0_pvld & dma9_last_odd;

assign dma9_mask  = dma9_is_last_odd ? 2'b01 : 2'b11;
assign dma9_mdata0 = {256{dma9_mask[0]}} & dma9_data0;
assign dma9_mdata1 = {256{dma9_mask[1]}} & dma9_data1;
assign dma9_data  = {dma9_mdata1,dma9_mdata0};

assign dma9_pd    = {dma9_mask,dma9_data};

assign ro9_rd0_prdy = dma9_rdy & (dma9_is_last_odd ? 1'b1 : ro9_rd1_pvld);
assign ro9_rd1_prdy = dma9_rdy & (dma9_is_last_odd ? 1'b0 : ro9_rd0_pvld);
NV_NVDLA_MCIF_READ_EG_pipe_p11 pipe_p11 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma9_pd                    (dma9_pd[513:0])                 //|< w
  ,.dma9_vld                   (dma9_vld)                       //|< w
  ,.mcif2cdma_wt_rd_rsp_ready  (mcif2cdma_wt_rd_rsp_ready)      //|< i
  ,.dma9_rdy                   (dma9_rdy)                       //|> w
  ,.mcif2cdma_wt_rd_rsp_pd     (mcif2cdma_wt_rd_rsp_pd[513:0])  //|> o
  ,.mcif2cdma_wt_rd_rsp_valid  (mcif2cdma_wt_rd_rsp_valid)      //|> o
  );


// Context Queue Read
// EG===Context Queue

// ctt_first tells ctt is the next coming data is the first beat of rdata in a transaction

assign ctt0_last_beat = src0_gnt & arb_last_beat;
assign cq_rd0_prdy = (ctt0_rdy & ctt0_last_beat) || !ctt0_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ctt0_vld <= 1'b0;
  end else begin
  if ((cq_rd0_prdy) == 1'b1) begin
    ctt0_vld <= cq_rd0_pvld;
  // VCS coverage off
  end else if ((cq_rd0_prdy) == 1'b0) begin
  end else begin
    ctt0_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq_rd0_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    ctt0_cnt <= {2{1'b0}};
  end else begin
   if (cq_rd0_pvld && cq_rd0_prdy) begin
       ctt0_cnt <= 0;
   end else if (ctt0_accept) begin
       ctt0_cnt <= ctt0_cnt + 1;
   end
  end
end
assign ctt0_accept= ctt0_vld & ctt0_rdy;
always @(posedge nvdla_core_clk) begin
   if (cq_rd0_pvld && cq_rd0_prdy) begin
       ctt0_cq_pd  <= cq_rd0_pd;
   end
end

// ctt_first tells ctt is the next coming data is the first beat of rdata in a transaction

assign ctt1_last_beat = src1_gnt & arb_last_beat;
assign cq_rd1_prdy = (ctt1_rdy & ctt1_last_beat) || !ctt1_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ctt1_vld <= 1'b0;
  end else begin
  if ((cq_rd1_prdy) == 1'b1) begin
    ctt1_vld <= cq_rd1_pvld;
  // VCS coverage off
  end else if ((cq_rd1_prdy) == 1'b0) begin
  end else begin
    ctt1_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq_rd1_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    ctt1_cnt <= {2{1'b0}};
  end else begin
   if (cq_rd1_pvld && cq_rd1_prdy) begin
       ctt1_cnt <= 0;
   end else if (ctt1_accept) begin
       ctt1_cnt <= ctt1_cnt + 1;
   end
  end
end
assign ctt1_accept= ctt1_vld & ctt1_rdy;
always @(posedge nvdla_core_clk) begin
   if (cq_rd1_pvld && cq_rd1_prdy) begin
       ctt1_cq_pd  <= cq_rd1_pd;
   end
end

// ctt_first tells ctt is the next coming data is the first beat of rdata in a transaction

assign ctt2_last_beat = src2_gnt & arb_last_beat;
assign cq_rd2_prdy = (ctt2_rdy & ctt2_last_beat) || !ctt2_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ctt2_vld <= 1'b0;
  end else begin
  if ((cq_rd2_prdy) == 1'b1) begin
    ctt2_vld <= cq_rd2_pvld;
  // VCS coverage off
  end else if ((cq_rd2_prdy) == 1'b0) begin
  end else begin
    ctt2_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq_rd2_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    ctt2_cnt <= {2{1'b0}};
  end else begin
   if (cq_rd2_pvld && cq_rd2_prdy) begin
       ctt2_cnt <= 0;
   end else if (ctt2_accept) begin
       ctt2_cnt <= ctt2_cnt + 1;
   end
  end
end
assign ctt2_accept= ctt2_vld & ctt2_rdy;
always @(posedge nvdla_core_clk) begin
   if (cq_rd2_pvld && cq_rd2_prdy) begin
       ctt2_cq_pd  <= cq_rd2_pd;
   end
end

// ctt_first tells ctt is the next coming data is the first beat of rdata in a transaction

assign ctt3_last_beat = src3_gnt & arb_last_beat;
assign cq_rd3_prdy = (ctt3_rdy & ctt3_last_beat) || !ctt3_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ctt3_vld <= 1'b0;
  end else begin
  if ((cq_rd3_prdy) == 1'b1) begin
    ctt3_vld <= cq_rd3_pvld;
  // VCS coverage off
  end else if ((cq_rd3_prdy) == 1'b0) begin
  end else begin
    ctt3_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq_rd3_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    ctt3_cnt <= {2{1'b0}};
  end else begin
   if (cq_rd3_pvld && cq_rd3_prdy) begin
       ctt3_cnt <= 0;
   end else if (ctt3_accept) begin
       ctt3_cnt <= ctt3_cnt + 1;
   end
  end
end
assign ctt3_accept= ctt3_vld & ctt3_rdy;
always @(posedge nvdla_core_clk) begin
   if (cq_rd3_pvld && cq_rd3_prdy) begin
       ctt3_cq_pd  <= cq_rd3_pd;
   end
end

// ctt_first tells ctt is the next coming data is the first beat of rdata in a transaction

assign ctt4_last_beat = src4_gnt & arb_last_beat;
assign cq_rd4_prdy = (ctt4_rdy & ctt4_last_beat) || !ctt4_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ctt4_vld <= 1'b0;
  end else begin
  if ((cq_rd4_prdy) == 1'b1) begin
    ctt4_vld <= cq_rd4_pvld;
  // VCS coverage off
  end else if ((cq_rd4_prdy) == 1'b0) begin
  end else begin
    ctt4_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq_rd4_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    ctt4_cnt <= {2{1'b0}};
  end else begin
   if (cq_rd4_pvld && cq_rd4_prdy) begin
       ctt4_cnt <= 0;
   end else if (ctt4_accept) begin
       ctt4_cnt <= ctt4_cnt + 1;
   end
  end
end
assign ctt4_accept= ctt4_vld & ctt4_rdy;
always @(posedge nvdla_core_clk) begin
   if (cq_rd4_pvld && cq_rd4_prdy) begin
       ctt4_cq_pd  <= cq_rd4_pd;
   end
end

// ctt_first tells ctt is the next coming data is the first beat of rdata in a transaction

assign ctt5_last_beat = src5_gnt & arb_last_beat;
assign cq_rd5_prdy = (ctt5_rdy & ctt5_last_beat) || !ctt5_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ctt5_vld <= 1'b0;
  end else begin
  if ((cq_rd5_prdy) == 1'b1) begin
    ctt5_vld <= cq_rd5_pvld;
  // VCS coverage off
  end else if ((cq_rd5_prdy) == 1'b0) begin
  end else begin
    ctt5_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq_rd5_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    ctt5_cnt <= {2{1'b0}};
  end else begin
   if (cq_rd5_pvld && cq_rd5_prdy) begin
       ctt5_cnt <= 0;
   end else if (ctt5_accept) begin
       ctt5_cnt <= ctt5_cnt + 1;
   end
  end
end
assign ctt5_accept= ctt5_vld & ctt5_rdy;
always @(posedge nvdla_core_clk) begin
   if (cq_rd5_pvld && cq_rd5_prdy) begin
       ctt5_cq_pd  <= cq_rd5_pd;
   end
end

// ctt_first tells ctt is the next coming data is the first beat of rdata in a transaction

assign ctt6_last_beat = src6_gnt & arb_last_beat;
assign cq_rd6_prdy = (ctt6_rdy & ctt6_last_beat) || !ctt6_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ctt6_vld <= 1'b0;
  end else begin
  if ((cq_rd6_prdy) == 1'b1) begin
    ctt6_vld <= cq_rd6_pvld;
  // VCS coverage off
  end else if ((cq_rd6_prdy) == 1'b0) begin
  end else begin
    ctt6_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq_rd6_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    ctt6_cnt <= {2{1'b0}};
  end else begin
   if (cq_rd6_pvld && cq_rd6_prdy) begin
       ctt6_cnt <= 0;
   end else if (ctt6_accept) begin
       ctt6_cnt <= ctt6_cnt + 1;
   end
  end
end
assign ctt6_accept= ctt6_vld & ctt6_rdy;
always @(posedge nvdla_core_clk) begin
   if (cq_rd6_pvld && cq_rd6_prdy) begin
       ctt6_cq_pd  <= cq_rd6_pd;
   end
end

// ctt_first tells ctt is the next coming data is the first beat of rdata in a transaction

assign ctt7_last_beat = src7_gnt & arb_last_beat;
assign cq_rd7_prdy = (ctt7_rdy & ctt7_last_beat) || !ctt7_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ctt7_vld <= 1'b0;
  end else begin
  if ((cq_rd7_prdy) == 1'b1) begin
    ctt7_vld <= cq_rd7_pvld;
  // VCS coverage off
  end else if ((cq_rd7_prdy) == 1'b0) begin
  end else begin
    ctt7_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq_rd7_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    ctt7_cnt <= {2{1'b0}};
  end else begin
   if (cq_rd7_pvld && cq_rd7_prdy) begin
       ctt7_cnt <= 0;
   end else if (ctt7_accept) begin
       ctt7_cnt <= ctt7_cnt + 1;
   end
  end
end
assign ctt7_accept= ctt7_vld & ctt7_rdy;
always @(posedge nvdla_core_clk) begin
   if (cq_rd7_pvld && cq_rd7_prdy) begin
       ctt7_cq_pd  <= cq_rd7_pd;
   end
end

// ctt_first tells ctt is the next coming data is the first beat of rdata in a transaction

assign ctt8_last_beat = src8_gnt & arb_last_beat;
assign cq_rd8_prdy = (ctt8_rdy & ctt8_last_beat) || !ctt8_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ctt8_vld <= 1'b0;
  end else begin
  if ((cq_rd8_prdy) == 1'b1) begin
    ctt8_vld <= cq_rd8_pvld;
  // VCS coverage off
  end else if ((cq_rd8_prdy) == 1'b0) begin
  end else begin
    ctt8_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq_rd8_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    ctt8_cnt <= {2{1'b0}};
  end else begin
   if (cq_rd8_pvld && cq_rd8_prdy) begin
       ctt8_cnt <= 0;
   end else if (ctt8_accept) begin
       ctt8_cnt <= ctt8_cnt + 1;
   end
  end
end
assign ctt8_accept= ctt8_vld & ctt8_rdy;
always @(posedge nvdla_core_clk) begin
   if (cq_rd8_pvld && cq_rd8_prdy) begin
       ctt8_cq_pd  <= cq_rd8_pd;
   end
end

// ctt_first tells ctt is the next coming data is the first beat of rdata in a transaction

assign ctt9_last_beat = src9_gnt & arb_last_beat;
assign cq_rd9_prdy = (ctt9_rdy & ctt9_last_beat) || !ctt9_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ctt9_vld <= 1'b0;
  end else begin
  if ((cq_rd9_prdy) == 1'b1) begin
    ctt9_vld <= cq_rd9_pvld;
  // VCS coverage off
  end else if ((cq_rd9_prdy) == 1'b0) begin
  end else begin
    ctt9_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq_rd9_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    ctt9_cnt <= {2{1'b0}};
  end else begin
   if (cq_rd9_pvld && cq_rd9_prdy) begin
       ctt9_cnt <= 0;
   end else if (ctt9_accept) begin
       ctt9_cnt <= ctt9_cnt + 1;
   end
  end
end
assign ctt9_accept= ctt9_vld & ctt9_rdy;
always @(posedge nvdla_core_clk) begin
   if (cq_rd9_pvld && cq_rd9_prdy) begin
       ctt9_cq_pd  <= cq_rd9_pd;
   end
end

//===================================================
// OBS
//&PerlBeg;
//    foreach my $i (0..$rdma_num-1) {
//    vprinti "
//    |assign obs_bus_mcif_read_eg_arb_src${i}_gnt = src${i}_gnt;
//    |assign obs_bus_mcif_read_eg_arb_src${i}_req = src${i}_req;
//    |assign obs_bus_mcif_read_eg_cq_src${i}_vld  = cq_rd${i}_pvld;
//    |assign obs_bus_mcif_read_eg_cq_src${i}_rdy  = cq_rd${i}_prdy;
//    |assign obs_bus_mcif_read_eg_rq${i}_wr_pvld   = rq${i}_wr_pvld;
//    |assign obs_bus_mcif_read_eg_rq${i}_wr_prdy   = rq${i}_wr_prdy;
//    |assign obs_bus_mcif_read_eg_rq${i}_rd_pvld   = rq${i}_rd_pvld;
//    |assign obs_bus_mcif_read_eg_rq${i}_rd_prdy   = rq${i}_rd_prdy;
//    |";
//    }
//    
//&PerlEnd;

endmodule // NV_NVDLA_MCIF_READ_eg



// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os ipipe_axi_pd (ipipe_axi_vld,ipipe_axi_rdy) <= noc2mcif_axi_r_pd[515:0] (noc2mcif_axi_r_rvalid,noc2mcif_axi_r_rready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,ipipe_axi_rdy
  ,noc2mcif_axi_r_pd
  ,noc2mcif_axi_r_rvalid
  ,ipipe_axi_pd
  ,ipipe_axi_vld
  ,noc2mcif_axi_r_rready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          ipipe_axi_rdy;
input  [515:0] noc2mcif_axi_r_pd;
input          noc2mcif_axi_r_rvalid;
output [515:0] ipipe_axi_pd;
output         ipipe_axi_vld;
output         noc2mcif_axi_r_rready;
reg    [515:0] ipipe_axi_pd;
reg            ipipe_axi_vld;
reg            noc2mcif_axi_r_rready;
reg    [515:0] p1_pipe_data;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg    [515:0] p1_pipe_skid_data;
reg            p1_pipe_skid_ready;
reg            p1_pipe_skid_valid;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [515:0] p1_skid_data;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? noc2mcif_axi_r_rvalid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && noc2mcif_axi_r_rvalid)? noc2mcif_axi_r_pd[515:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  noc2mcif_axi_r_rready = p1_pipe_ready_bc;
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
  or ipipe_axi_rdy
  or p1_pipe_skid_data
  ) begin
  ipipe_axi_vld = p1_pipe_skid_valid;
  p1_pipe_skid_ready = ipipe_axi_rdy;
  ipipe_axi_pd = p1_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (ipipe_axi_vld^ipipe_axi_rdy^noc2mcif_axi_r_rvalid^noc2mcif_axi_r_rready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_12x (nvdla_core_clk, `ASSERT_RESET, (noc2mcif_axi_r_rvalid && !noc2mcif_axi_r_rready), (noc2mcif_axi_r_rvalid), (noc2mcif_axi_r_rready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is mcif2bdma_rd_rsp_pd (mcif2bdma_rd_rsp_valid,mcif2bdma_rd_rsp_ready) <= dma0_pd[513:0] (dma0_vld,dma0_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma0_pd
  ,dma0_vld
  ,mcif2bdma_rd_rsp_ready
  ,dma0_rdy
  ,mcif2bdma_rd_rsp_pd
  ,mcif2bdma_rd_rsp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dma0_pd;
input          dma0_vld;
input          mcif2bdma_rd_rsp_ready;
output         dma0_rdy;
output [513:0] mcif2bdma_rd_rsp_pd;
output         mcif2bdma_rd_rsp_valid;
reg            dma0_rdy;
reg    [513:0] mcif2bdma_rd_rsp_pd;
reg            mcif2bdma_rd_rsp_valid;
reg    [513:0] p2_pipe_data;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [513:0] p2_skid_data;
reg    [513:0] p2_skid_pipe_data;
reg            p2_skid_pipe_ready;
reg            p2_skid_pipe_valid;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
//## pipe (2) skid buffer
always @(
  dma0_vld
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = dma0_vld && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    dma0_rdy <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  dma0_rdy <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? dma0_pd[513:0] : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or dma0_vld
  or p2_skid_valid
  or dma0_pd
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? dma0_vld : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? dma0_pd[513:0] : p2_skid_data;
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
  or mcif2bdma_rd_rsp_ready
  or p2_pipe_data
  ) begin
  mcif2bdma_rd_rsp_valid = p2_pipe_valid;
  p2_pipe_ready = mcif2bdma_rd_rsp_ready;
  mcif2bdma_rd_rsp_pd = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2bdma_rd_rsp_valid^mcif2bdma_rd_rsp_ready^dma0_vld^dma0_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_14x (nvdla_core_clk, `ASSERT_RESET, (dma0_vld && !dma0_rdy), (dma0_vld), (dma0_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is mcif2sdp_rd_rsp_pd (mcif2sdp_rd_rsp_valid,mcif2sdp_rd_rsp_ready) <= dma1_pd[513:0] (dma1_vld,dma1_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma1_pd
  ,dma1_vld
  ,mcif2sdp_rd_rsp_ready
  ,dma1_rdy
  ,mcif2sdp_rd_rsp_pd
  ,mcif2sdp_rd_rsp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dma1_pd;
input          dma1_vld;
input          mcif2sdp_rd_rsp_ready;
output         dma1_rdy;
output [513:0] mcif2sdp_rd_rsp_pd;
output         mcif2sdp_rd_rsp_valid;
reg            dma1_rdy;
reg    [513:0] mcif2sdp_rd_rsp_pd;
reg            mcif2sdp_rd_rsp_valid;
reg    [513:0] p3_pipe_data;
reg            p3_pipe_ready;
reg            p3_pipe_ready_bc;
reg            p3_pipe_valid;
reg            p3_skid_catch;
reg    [513:0] p3_skid_data;
reg    [513:0] p3_skid_pipe_data;
reg            p3_skid_pipe_ready;
reg            p3_skid_pipe_valid;
reg            p3_skid_ready;
reg            p3_skid_ready_flop;
reg            p3_skid_valid;
//## pipe (3) skid buffer
always @(
  dma1_vld
  or p3_skid_ready_flop
  or p3_skid_pipe_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = dma1_vld && p3_skid_ready_flop && !p3_skid_pipe_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_skid_pipe_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    dma1_rdy <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_skid_pipe_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  dma1_rdy <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? dma1_pd[513:0] : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or dma1_vld
  or p3_skid_valid
  or dma1_pd
  or p3_skid_data
  ) begin
  p3_skid_pipe_valid = (p3_skid_ready_flop)? dma1_vld : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_skid_pipe_data = (p3_skid_ready_flop)? dma1_pd[513:0] : p3_skid_data;
  // VCS sop_coverage_off end
end
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
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && p3_skid_pipe_valid)? p3_skid_pipe_data : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  p3_skid_pipe_ready = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or mcif2sdp_rd_rsp_ready
  or p3_pipe_data
  ) begin
  mcif2sdp_rd_rsp_valid = p3_pipe_valid;
  p3_pipe_ready = mcif2sdp_rd_rsp_ready;
  mcif2sdp_rd_rsp_pd = p3_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2sdp_rd_rsp_valid^mcif2sdp_rd_rsp_ready^dma1_vld^dma1_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_16x (nvdla_core_clk, `ASSERT_RESET, (dma1_vld && !dma1_rdy), (dma1_vld), (dma1_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is mcif2pdp_rd_rsp_pd (mcif2pdp_rd_rsp_valid,mcif2pdp_rd_rsp_ready) <= dma2_pd[513:0] (dma2_vld,dma2_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma2_pd
  ,dma2_vld
  ,mcif2pdp_rd_rsp_ready
  ,dma2_rdy
  ,mcif2pdp_rd_rsp_pd
  ,mcif2pdp_rd_rsp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dma2_pd;
input          dma2_vld;
input          mcif2pdp_rd_rsp_ready;
output         dma2_rdy;
output [513:0] mcif2pdp_rd_rsp_pd;
output         mcif2pdp_rd_rsp_valid;
reg            dma2_rdy;
reg    [513:0] mcif2pdp_rd_rsp_pd;
reg            mcif2pdp_rd_rsp_valid;
reg    [513:0] p4_pipe_data;
reg            p4_pipe_ready;
reg            p4_pipe_ready_bc;
reg            p4_pipe_valid;
reg            p4_skid_catch;
reg    [513:0] p4_skid_data;
reg    [513:0] p4_skid_pipe_data;
reg            p4_skid_pipe_ready;
reg            p4_skid_pipe_valid;
reg            p4_skid_ready;
reg            p4_skid_ready_flop;
reg            p4_skid_valid;
//## pipe (4) skid buffer
always @(
  dma2_vld
  or p4_skid_ready_flop
  or p4_skid_pipe_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = dma2_vld && p4_skid_ready_flop && !p4_skid_pipe_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_skid_pipe_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    dma2_rdy <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_skid_pipe_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  dma2_rdy <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? dma2_pd[513:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or dma2_vld
  or p4_skid_valid
  or dma2_pd
  or p4_skid_data
  ) begin
  p4_skid_pipe_valid = (p4_skid_ready_flop)? dma2_vld : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_skid_pipe_data = (p4_skid_ready_flop)? dma2_pd[513:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? p4_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && p4_skid_pipe_valid)? p4_skid_pipe_data : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  p4_skid_pipe_ready = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or mcif2pdp_rd_rsp_ready
  or p4_pipe_data
  ) begin
  mcif2pdp_rd_rsp_valid = p4_pipe_valid;
  p4_pipe_ready = mcif2pdp_rd_rsp_ready;
  mcif2pdp_rd_rsp_pd = p4_pipe_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2pdp_rd_rsp_valid^mcif2pdp_rd_rsp_ready^dma2_vld^dma2_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_18x (nvdla_core_clk, `ASSERT_RESET, (dma2_vld && !dma2_rdy), (dma2_vld), (dma2_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is mcif2cdp_rd_rsp_pd (mcif2cdp_rd_rsp_valid,mcif2cdp_rd_rsp_ready) <= dma3_pd[513:0] (dma3_vld,dma3_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p5 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma3_pd
  ,dma3_vld
  ,mcif2cdp_rd_rsp_ready
  ,dma3_rdy
  ,mcif2cdp_rd_rsp_pd
  ,mcif2cdp_rd_rsp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dma3_pd;
input          dma3_vld;
input          mcif2cdp_rd_rsp_ready;
output         dma3_rdy;
output [513:0] mcif2cdp_rd_rsp_pd;
output         mcif2cdp_rd_rsp_valid;
reg            dma3_rdy;
reg    [513:0] mcif2cdp_rd_rsp_pd;
reg            mcif2cdp_rd_rsp_valid;
reg    [513:0] p5_pipe_data;
reg            p5_pipe_ready;
reg            p5_pipe_ready_bc;
reg            p5_pipe_valid;
reg            p5_skid_catch;
reg    [513:0] p5_skid_data;
reg    [513:0] p5_skid_pipe_data;
reg            p5_skid_pipe_ready;
reg            p5_skid_pipe_valid;
reg            p5_skid_ready;
reg            p5_skid_ready_flop;
reg            p5_skid_valid;
//## pipe (5) skid buffer
always @(
  dma3_vld
  or p5_skid_ready_flop
  or p5_skid_pipe_ready
  or p5_skid_valid
  ) begin
  p5_skid_catch = dma3_vld && p5_skid_ready_flop && !p5_skid_pipe_ready;  
  p5_skid_ready = (p5_skid_valid)? p5_skid_pipe_ready : !p5_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_skid_valid <= 1'b0;
    p5_skid_ready_flop <= 1'b1;
    dma3_rdy <= 1'b1;
  end else begin
  p5_skid_valid <= (p5_skid_valid)? !p5_skid_pipe_ready : p5_skid_catch;
  p5_skid_ready_flop <= p5_skid_ready;
  dma3_rdy <= p5_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_skid_data <= (p5_skid_catch)? dma3_pd[513:0] : p5_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p5_skid_ready_flop
  or dma3_vld
  or p5_skid_valid
  or dma3_pd
  or p5_skid_data
  ) begin
  p5_skid_pipe_valid = (p5_skid_ready_flop)? dma3_vld : p5_skid_valid; 
  // VCS sop_coverage_off start
  p5_skid_pipe_data = (p5_skid_ready_flop)? dma3_pd[513:0] : p5_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (5) valid-ready-bubble-collapse
always @(
  p5_pipe_ready
  or p5_pipe_valid
  ) begin
  p5_pipe_ready_bc = p5_pipe_ready || !p5_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_pipe_valid <= 1'b0;
  end else begin
  p5_pipe_valid <= (p5_pipe_ready_bc)? p5_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && p5_skid_pipe_valid)? p5_skid_pipe_data : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  p5_skid_pipe_ready = p5_pipe_ready_bc;
end
//## pipe (5) output
always @(
  p5_pipe_valid
  or mcif2cdp_rd_rsp_ready
  or p5_pipe_data
  ) begin
  mcif2cdp_rd_rsp_valid = p5_pipe_valid;
  p5_pipe_ready = mcif2cdp_rd_rsp_ready;
  mcif2cdp_rd_rsp_pd = p5_pipe_data;
end
//## pipe (5) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p5_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2cdp_rd_rsp_valid^mcif2cdp_rd_rsp_ready^dma3_vld^dma3_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_20x (nvdla_core_clk, `ASSERT_RESET, (dma3_vld && !dma3_rdy), (dma3_vld), (dma3_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p5




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is mcif2rbk_rd_rsp_pd (mcif2rbk_rd_rsp_valid,mcif2rbk_rd_rsp_ready) <= dma4_pd[513:0] (dma4_vld,dma4_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p6 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma4_pd
  ,dma4_vld
  ,mcif2rbk_rd_rsp_ready
  ,dma4_rdy
  ,mcif2rbk_rd_rsp_pd
  ,mcif2rbk_rd_rsp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dma4_pd;
input          dma4_vld;
input          mcif2rbk_rd_rsp_ready;
output         dma4_rdy;
output [513:0] mcif2rbk_rd_rsp_pd;
output         mcif2rbk_rd_rsp_valid;
reg            dma4_rdy;
reg    [513:0] mcif2rbk_rd_rsp_pd;
reg            mcif2rbk_rd_rsp_valid;
reg    [513:0] p6_pipe_data;
reg            p6_pipe_ready;
reg            p6_pipe_ready_bc;
reg            p6_pipe_valid;
reg            p6_skid_catch;
reg    [513:0] p6_skid_data;
reg    [513:0] p6_skid_pipe_data;
reg            p6_skid_pipe_ready;
reg            p6_skid_pipe_valid;
reg            p6_skid_ready;
reg            p6_skid_ready_flop;
reg            p6_skid_valid;
//## pipe (6) skid buffer
always @(
  dma4_vld
  or p6_skid_ready_flop
  or p6_skid_pipe_ready
  or p6_skid_valid
  ) begin
  p6_skid_catch = dma4_vld && p6_skid_ready_flop && !p6_skid_pipe_ready;  
  p6_skid_ready = (p6_skid_valid)? p6_skid_pipe_ready : !p6_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p6_skid_valid <= 1'b0;
    p6_skid_ready_flop <= 1'b1;
    dma4_rdy <= 1'b1;
  end else begin
  p6_skid_valid <= (p6_skid_valid)? !p6_skid_pipe_ready : p6_skid_catch;
  p6_skid_ready_flop <= p6_skid_ready;
  dma4_rdy <= p6_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p6_skid_data <= (p6_skid_catch)? dma4_pd[513:0] : p6_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p6_skid_ready_flop
  or dma4_vld
  or p6_skid_valid
  or dma4_pd
  or p6_skid_data
  ) begin
  p6_skid_pipe_valid = (p6_skid_ready_flop)? dma4_vld : p6_skid_valid; 
  // VCS sop_coverage_off start
  p6_skid_pipe_data = (p6_skid_ready_flop)? dma4_pd[513:0] : p6_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (6) valid-ready-bubble-collapse
always @(
  p6_pipe_ready
  or p6_pipe_valid
  ) begin
  p6_pipe_ready_bc = p6_pipe_ready || !p6_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p6_pipe_valid <= 1'b0;
  end else begin
  p6_pipe_valid <= (p6_pipe_ready_bc)? p6_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p6_pipe_data <= (p6_pipe_ready_bc && p6_skid_pipe_valid)? p6_skid_pipe_data : p6_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p6_pipe_ready_bc
  ) begin
  p6_skid_pipe_ready = p6_pipe_ready_bc;
end
//## pipe (6) output
always @(
  p6_pipe_valid
  or mcif2rbk_rd_rsp_ready
  or p6_pipe_data
  ) begin
  mcif2rbk_rd_rsp_valid = p6_pipe_valid;
  p6_pipe_ready = mcif2rbk_rd_rsp_ready;
  mcif2rbk_rd_rsp_pd = p6_pipe_data;
end
//## pipe (6) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p6_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2rbk_rd_rsp_valid^mcif2rbk_rd_rsp_ready^dma4_vld^dma4_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_22x (nvdla_core_clk, `ASSERT_RESET, (dma4_vld && !dma4_rdy), (dma4_vld), (dma4_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p6




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is mcif2sdp_b_rd_rsp_pd (mcif2sdp_b_rd_rsp_valid,mcif2sdp_b_rd_rsp_ready) <= dma5_pd[513:0] (dma5_vld,dma5_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p7 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma5_pd
  ,dma5_vld
  ,mcif2sdp_b_rd_rsp_ready
  ,dma5_rdy
  ,mcif2sdp_b_rd_rsp_pd
  ,mcif2sdp_b_rd_rsp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dma5_pd;
input          dma5_vld;
input          mcif2sdp_b_rd_rsp_ready;
output         dma5_rdy;
output [513:0] mcif2sdp_b_rd_rsp_pd;
output         mcif2sdp_b_rd_rsp_valid;
reg            dma5_rdy;
reg    [513:0] mcif2sdp_b_rd_rsp_pd;
reg            mcif2sdp_b_rd_rsp_valid;
reg    [513:0] p7_pipe_data;
reg            p7_pipe_ready;
reg            p7_pipe_ready_bc;
reg            p7_pipe_valid;
reg            p7_skid_catch;
reg    [513:0] p7_skid_data;
reg    [513:0] p7_skid_pipe_data;
reg            p7_skid_pipe_ready;
reg            p7_skid_pipe_valid;
reg            p7_skid_ready;
reg            p7_skid_ready_flop;
reg            p7_skid_valid;
//## pipe (7) skid buffer
always @(
  dma5_vld
  or p7_skid_ready_flop
  or p7_skid_pipe_ready
  or p7_skid_valid
  ) begin
  p7_skid_catch = dma5_vld && p7_skid_ready_flop && !p7_skid_pipe_ready;  
  p7_skid_ready = (p7_skid_valid)? p7_skid_pipe_ready : !p7_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_skid_valid <= 1'b0;
    p7_skid_ready_flop <= 1'b1;
    dma5_rdy <= 1'b1;
  end else begin
  p7_skid_valid <= (p7_skid_valid)? !p7_skid_pipe_ready : p7_skid_catch;
  p7_skid_ready_flop <= p7_skid_ready;
  dma5_rdy <= p7_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p7_skid_data <= (p7_skid_catch)? dma5_pd[513:0] : p7_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p7_skid_ready_flop
  or dma5_vld
  or p7_skid_valid
  or dma5_pd
  or p7_skid_data
  ) begin
  p7_skid_pipe_valid = (p7_skid_ready_flop)? dma5_vld : p7_skid_valid; 
  // VCS sop_coverage_off start
  p7_skid_pipe_data = (p7_skid_ready_flop)? dma5_pd[513:0] : p7_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (7) valid-ready-bubble-collapse
always @(
  p7_pipe_ready
  or p7_pipe_valid
  ) begin
  p7_pipe_ready_bc = p7_pipe_ready || !p7_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_pipe_valid <= 1'b0;
  end else begin
  p7_pipe_valid <= (p7_pipe_ready_bc)? p7_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p7_pipe_data <= (p7_pipe_ready_bc && p7_skid_pipe_valid)? p7_skid_pipe_data : p7_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p7_pipe_ready_bc
  ) begin
  p7_skid_pipe_ready = p7_pipe_ready_bc;
end
//## pipe (7) output
always @(
  p7_pipe_valid
  or mcif2sdp_b_rd_rsp_ready
  or p7_pipe_data
  ) begin
  mcif2sdp_b_rd_rsp_valid = p7_pipe_valid;
  p7_pipe_ready = mcif2sdp_b_rd_rsp_ready;
  mcif2sdp_b_rd_rsp_pd = p7_pipe_data;
end
//## pipe (7) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p7_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2sdp_b_rd_rsp_valid^mcif2sdp_b_rd_rsp_ready^dma5_vld^dma5_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_24x (nvdla_core_clk, `ASSERT_RESET, (dma5_vld && !dma5_rdy), (dma5_vld), (dma5_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p7




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is mcif2sdp_n_rd_rsp_pd (mcif2sdp_n_rd_rsp_valid,mcif2sdp_n_rd_rsp_ready) <= dma6_pd[513:0] (dma6_vld,dma6_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p8 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma6_pd
  ,dma6_vld
  ,mcif2sdp_n_rd_rsp_ready
  ,dma6_rdy
  ,mcif2sdp_n_rd_rsp_pd
  ,mcif2sdp_n_rd_rsp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dma6_pd;
input          dma6_vld;
input          mcif2sdp_n_rd_rsp_ready;
output         dma6_rdy;
output [513:0] mcif2sdp_n_rd_rsp_pd;
output         mcif2sdp_n_rd_rsp_valid;
reg            dma6_rdy;
reg    [513:0] mcif2sdp_n_rd_rsp_pd;
reg            mcif2sdp_n_rd_rsp_valid;
reg    [513:0] p8_pipe_data;
reg            p8_pipe_ready;
reg            p8_pipe_ready_bc;
reg            p8_pipe_valid;
reg            p8_skid_catch;
reg    [513:0] p8_skid_data;
reg    [513:0] p8_skid_pipe_data;
reg            p8_skid_pipe_ready;
reg            p8_skid_pipe_valid;
reg            p8_skid_ready;
reg            p8_skid_ready_flop;
reg            p8_skid_valid;
//## pipe (8) skid buffer
always @(
  dma6_vld
  or p8_skid_ready_flop
  or p8_skid_pipe_ready
  or p8_skid_valid
  ) begin
  p8_skid_catch = dma6_vld && p8_skid_ready_flop && !p8_skid_pipe_ready;  
  p8_skid_ready = (p8_skid_valid)? p8_skid_pipe_ready : !p8_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p8_skid_valid <= 1'b0;
    p8_skid_ready_flop <= 1'b1;
    dma6_rdy <= 1'b1;
  end else begin
  p8_skid_valid <= (p8_skid_valid)? !p8_skid_pipe_ready : p8_skid_catch;
  p8_skid_ready_flop <= p8_skid_ready;
  dma6_rdy <= p8_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p8_skid_data <= (p8_skid_catch)? dma6_pd[513:0] : p8_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p8_skid_ready_flop
  or dma6_vld
  or p8_skid_valid
  or dma6_pd
  or p8_skid_data
  ) begin
  p8_skid_pipe_valid = (p8_skid_ready_flop)? dma6_vld : p8_skid_valid; 
  // VCS sop_coverage_off start
  p8_skid_pipe_data = (p8_skid_ready_flop)? dma6_pd[513:0] : p8_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (8) valid-ready-bubble-collapse
always @(
  p8_pipe_ready
  or p8_pipe_valid
  ) begin
  p8_pipe_ready_bc = p8_pipe_ready || !p8_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p8_pipe_valid <= 1'b0;
  end else begin
  p8_pipe_valid <= (p8_pipe_ready_bc)? p8_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p8_pipe_data <= (p8_pipe_ready_bc && p8_skid_pipe_valid)? p8_skid_pipe_data : p8_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p8_pipe_ready_bc
  ) begin
  p8_skid_pipe_ready = p8_pipe_ready_bc;
end
//## pipe (8) output
always @(
  p8_pipe_valid
  or mcif2sdp_n_rd_rsp_ready
  or p8_pipe_data
  ) begin
  mcif2sdp_n_rd_rsp_valid = p8_pipe_valid;
  p8_pipe_ready = mcif2sdp_n_rd_rsp_ready;
  mcif2sdp_n_rd_rsp_pd = p8_pipe_data;
end
//## pipe (8) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p8_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2sdp_n_rd_rsp_valid^mcif2sdp_n_rd_rsp_ready^dma6_vld^dma6_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_26x (nvdla_core_clk, `ASSERT_RESET, (dma6_vld && !dma6_rdy), (dma6_vld), (dma6_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p8




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is mcif2sdp_e_rd_rsp_pd (mcif2sdp_e_rd_rsp_valid,mcif2sdp_e_rd_rsp_ready) <= dma7_pd[513:0] (dma7_vld,dma7_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p9 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma7_pd
  ,dma7_vld
  ,mcif2sdp_e_rd_rsp_ready
  ,dma7_rdy
  ,mcif2sdp_e_rd_rsp_pd
  ,mcif2sdp_e_rd_rsp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dma7_pd;
input          dma7_vld;
input          mcif2sdp_e_rd_rsp_ready;
output         dma7_rdy;
output [513:0] mcif2sdp_e_rd_rsp_pd;
output         mcif2sdp_e_rd_rsp_valid;
reg            dma7_rdy;
reg    [513:0] mcif2sdp_e_rd_rsp_pd;
reg            mcif2sdp_e_rd_rsp_valid;
reg    [513:0] p9_pipe_data;
reg            p9_pipe_ready;
reg            p9_pipe_ready_bc;
reg            p9_pipe_valid;
reg            p9_skid_catch;
reg    [513:0] p9_skid_data;
reg    [513:0] p9_skid_pipe_data;
reg            p9_skid_pipe_ready;
reg            p9_skid_pipe_valid;
reg            p9_skid_ready;
reg            p9_skid_ready_flop;
reg            p9_skid_valid;
//## pipe (9) skid buffer
always @(
  dma7_vld
  or p9_skid_ready_flop
  or p9_skid_pipe_ready
  or p9_skid_valid
  ) begin
  p9_skid_catch = dma7_vld && p9_skid_ready_flop && !p9_skid_pipe_ready;  
  p9_skid_ready = (p9_skid_valid)? p9_skid_pipe_ready : !p9_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p9_skid_valid <= 1'b0;
    p9_skid_ready_flop <= 1'b1;
    dma7_rdy <= 1'b1;
  end else begin
  p9_skid_valid <= (p9_skid_valid)? !p9_skid_pipe_ready : p9_skid_catch;
  p9_skid_ready_flop <= p9_skid_ready;
  dma7_rdy <= p9_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p9_skid_data <= (p9_skid_catch)? dma7_pd[513:0] : p9_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p9_skid_ready_flop
  or dma7_vld
  or p9_skid_valid
  or dma7_pd
  or p9_skid_data
  ) begin
  p9_skid_pipe_valid = (p9_skid_ready_flop)? dma7_vld : p9_skid_valid; 
  // VCS sop_coverage_off start
  p9_skid_pipe_data = (p9_skid_ready_flop)? dma7_pd[513:0] : p9_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (9) valid-ready-bubble-collapse
always @(
  p9_pipe_ready
  or p9_pipe_valid
  ) begin
  p9_pipe_ready_bc = p9_pipe_ready || !p9_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p9_pipe_valid <= 1'b0;
  end else begin
  p9_pipe_valid <= (p9_pipe_ready_bc)? p9_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p9_pipe_data <= (p9_pipe_ready_bc && p9_skid_pipe_valid)? p9_skid_pipe_data : p9_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p9_pipe_ready_bc
  ) begin
  p9_skid_pipe_ready = p9_pipe_ready_bc;
end
//## pipe (9) output
always @(
  p9_pipe_valid
  or mcif2sdp_e_rd_rsp_ready
  or p9_pipe_data
  ) begin
  mcif2sdp_e_rd_rsp_valid = p9_pipe_valid;
  p9_pipe_ready = mcif2sdp_e_rd_rsp_ready;
  mcif2sdp_e_rd_rsp_pd = p9_pipe_data;
end
//## pipe (9) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p9_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2sdp_e_rd_rsp_valid^mcif2sdp_e_rd_rsp_ready^dma7_vld^dma7_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_28x (nvdla_core_clk, `ASSERT_RESET, (dma7_vld && !dma7_rdy), (dma7_vld), (dma7_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p9




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is mcif2cdma_dat_rd_rsp_pd (mcif2cdma_dat_rd_rsp_valid,mcif2cdma_dat_rd_rsp_ready) <= dma8_pd[513:0] (dma8_vld,dma8_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p10 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma8_pd
  ,dma8_vld
  ,mcif2cdma_dat_rd_rsp_ready
  ,dma8_rdy
  ,mcif2cdma_dat_rd_rsp_pd
  ,mcif2cdma_dat_rd_rsp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dma8_pd;
input          dma8_vld;
input          mcif2cdma_dat_rd_rsp_ready;
output         dma8_rdy;
output [513:0] mcif2cdma_dat_rd_rsp_pd;
output         mcif2cdma_dat_rd_rsp_valid;
reg            dma8_rdy;
reg    [513:0] mcif2cdma_dat_rd_rsp_pd;
reg            mcif2cdma_dat_rd_rsp_valid;
reg    [513:0] p10_pipe_data;
reg            p10_pipe_ready;
reg            p10_pipe_ready_bc;
reg            p10_pipe_valid;
reg            p10_skid_catch;
reg    [513:0] p10_skid_data;
reg    [513:0] p10_skid_pipe_data;
reg            p10_skid_pipe_ready;
reg            p10_skid_pipe_valid;
reg            p10_skid_ready;
reg            p10_skid_ready_flop;
reg            p10_skid_valid;
//## pipe (10) skid buffer
always @(
  dma8_vld
  or p10_skid_ready_flop
  or p10_skid_pipe_ready
  or p10_skid_valid
  ) begin
  p10_skid_catch = dma8_vld && p10_skid_ready_flop && !p10_skid_pipe_ready;  
  p10_skid_ready = (p10_skid_valid)? p10_skid_pipe_ready : !p10_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p10_skid_valid <= 1'b0;
    p10_skid_ready_flop <= 1'b1;
    dma8_rdy <= 1'b1;
  end else begin
  p10_skid_valid <= (p10_skid_valid)? !p10_skid_pipe_ready : p10_skid_catch;
  p10_skid_ready_flop <= p10_skid_ready;
  dma8_rdy <= p10_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p10_skid_data <= (p10_skid_catch)? dma8_pd[513:0] : p10_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p10_skid_ready_flop
  or dma8_vld
  or p10_skid_valid
  or dma8_pd
  or p10_skid_data
  ) begin
  p10_skid_pipe_valid = (p10_skid_ready_flop)? dma8_vld : p10_skid_valid; 
  // VCS sop_coverage_off start
  p10_skid_pipe_data = (p10_skid_ready_flop)? dma8_pd[513:0] : p10_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (10) valid-ready-bubble-collapse
always @(
  p10_pipe_ready
  or p10_pipe_valid
  ) begin
  p10_pipe_ready_bc = p10_pipe_ready || !p10_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p10_pipe_valid <= 1'b0;
  end else begin
  p10_pipe_valid <= (p10_pipe_ready_bc)? p10_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p10_pipe_data <= (p10_pipe_ready_bc && p10_skid_pipe_valid)? p10_skid_pipe_data : p10_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p10_pipe_ready_bc
  ) begin
  p10_skid_pipe_ready = p10_pipe_ready_bc;
end
//## pipe (10) output
always @(
  p10_pipe_valid
  or mcif2cdma_dat_rd_rsp_ready
  or p10_pipe_data
  ) begin
  mcif2cdma_dat_rd_rsp_valid = p10_pipe_valid;
  p10_pipe_ready = mcif2cdma_dat_rd_rsp_ready;
  mcif2cdma_dat_rd_rsp_pd = p10_pipe_data;
end
//## pipe (10) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p10_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2cdma_dat_rd_rsp_valid^mcif2cdma_dat_rd_rsp_ready^dma8_vld^dma8_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_30x (nvdla_core_clk, `ASSERT_RESET, (dma8_vld && !dma8_rdy), (dma8_vld), (dma8_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p10




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is mcif2cdma_wt_rd_rsp_pd (mcif2cdma_wt_rd_rsp_valid,mcif2cdma_wt_rd_rsp_ready) <= dma9_pd[513:0] (dma9_vld,dma9_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_EG_pipe_p11 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma9_pd
  ,dma9_vld
  ,mcif2cdma_wt_rd_rsp_ready
  ,dma9_rdy
  ,mcif2cdma_wt_rd_rsp_pd
  ,mcif2cdma_wt_rd_rsp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] dma9_pd;
input          dma9_vld;
input          mcif2cdma_wt_rd_rsp_ready;
output         dma9_rdy;
output [513:0] mcif2cdma_wt_rd_rsp_pd;
output         mcif2cdma_wt_rd_rsp_valid;
reg            dma9_rdy;
reg    [513:0] mcif2cdma_wt_rd_rsp_pd;
reg            mcif2cdma_wt_rd_rsp_valid;
reg    [513:0] p11_pipe_data;
reg            p11_pipe_ready;
reg            p11_pipe_ready_bc;
reg            p11_pipe_valid;
reg            p11_skid_catch;
reg    [513:0] p11_skid_data;
reg    [513:0] p11_skid_pipe_data;
reg            p11_skid_pipe_ready;
reg            p11_skid_pipe_valid;
reg            p11_skid_ready;
reg            p11_skid_ready_flop;
reg            p11_skid_valid;
//## pipe (11) skid buffer
always @(
  dma9_vld
  or p11_skid_ready_flop
  or p11_skid_pipe_ready
  or p11_skid_valid
  ) begin
  p11_skid_catch = dma9_vld && p11_skid_ready_flop && !p11_skid_pipe_ready;  
  p11_skid_ready = (p11_skid_valid)? p11_skid_pipe_ready : !p11_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p11_skid_valid <= 1'b0;
    p11_skid_ready_flop <= 1'b1;
    dma9_rdy <= 1'b1;
  end else begin
  p11_skid_valid <= (p11_skid_valid)? !p11_skid_pipe_ready : p11_skid_catch;
  p11_skid_ready_flop <= p11_skid_ready;
  dma9_rdy <= p11_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p11_skid_data <= (p11_skid_catch)? dma9_pd[513:0] : p11_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p11_skid_ready_flop
  or dma9_vld
  or p11_skid_valid
  or dma9_pd
  or p11_skid_data
  ) begin
  p11_skid_pipe_valid = (p11_skid_ready_flop)? dma9_vld : p11_skid_valid; 
  // VCS sop_coverage_off start
  p11_skid_pipe_data = (p11_skid_ready_flop)? dma9_pd[513:0] : p11_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (11) valid-ready-bubble-collapse
always @(
  p11_pipe_ready
  or p11_pipe_valid
  ) begin
  p11_pipe_ready_bc = p11_pipe_ready || !p11_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p11_pipe_valid <= 1'b0;
  end else begin
  p11_pipe_valid <= (p11_pipe_ready_bc)? p11_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p11_pipe_data <= (p11_pipe_ready_bc && p11_skid_pipe_valid)? p11_skid_pipe_data : p11_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p11_pipe_ready_bc
  ) begin
  p11_skid_pipe_ready = p11_pipe_ready_bc;
end
//## pipe (11) output
always @(
  p11_pipe_valid
  or mcif2cdma_wt_rd_rsp_ready
  or p11_pipe_data
  ) begin
  mcif2cdma_wt_rd_rsp_valid = p11_pipe_valid;
  p11_pipe_ready = mcif2cdma_wt_rd_rsp_ready;
  mcif2cdma_wt_rd_rsp_pd = p11_pipe_data;
end
//## pipe (11) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p11_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2cdma_wt_rd_rsp_valid^mcif2cdma_wt_rd_rsp_ready^dma9_vld^dma9_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_32x (nvdla_core_clk, `ASSERT_RESET, (dma9_vld && !dma9_rdy), (dma9_vld), (dma9_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_EG_pipe_p11


//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_MCIF_READ_EG_lat_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus rq_wr -rd_pipebus rq_rd -d 4 -w 512 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_MCIF_READ_EG_lat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , rq_wr_prdy
    , rq_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , rq_wr_pause
`endif
    , rq_wr_pd
    , rq_rd_prdy
    , rq_rd_pvld
    , rq_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        rq_wr_prdy;
input         rq_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         rq_wr_pause;
`endif
input  [511:0] rq_wr_pd;
input         rq_rd_prdy;
output        rq_rd_pvld;
output [511:0] rq_rd_pd;
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
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        rq_wr_busy_int;		        	// copy for internal use
assign     rq_wr_prdy = !rq_wr_busy_int;
assign       wr_reserving = rq_wr_pvld && !rq_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] rq_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? rq_wr_count : (rq_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (rq_wr_count + 1'd1) : rq_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       rq_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check rq_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || rq_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       rq_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check rq_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rq_wr_busy_int <=  1'b0;
        rq_wr_count <=  3'd0;
    end else begin
	rq_wr_busy_int <=  rq_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    rq_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            rq_wr_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as rq_wr_pvld

//
// RAM
//

reg  [1:0] rq_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rq_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    rq_wr_adr <=  rq_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484


reg [1:0] rq_rd_adr;          // read address this cycle
wire ram_we = wr_pushing;   // note: write occurs next cycle
wire [511:0] rq_rd_pd;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_MCIF_READ_EG_lat_fifo_flopram_rwsa_4x512 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( rq_wr_pd )
    , .we        ( ram_we )
    , .wa        ( rq_wr_adr )
    , .ra        ( rq_rd_adr )
    , .dout        ( rq_rd_pd )
    );

wire   rd_popping;              // read side doing pop this cycle?

wire [1:0] rd_adr_next_popping = rq_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rq_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    rq_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            rq_rd_adr <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

reg        rq_rd_pvld; 		// data out of fifo is valid

reg        rq_rd_pvld_int;			// internal copy of rq_rd_pvld
assign     rd_popping = rq_rd_pvld_int && rq_rd_prdy;

reg  [2:0] rq_rd_count;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_next_rd_popping = rd_pushing ? rq_rd_count : 
                                                                (rq_rd_count - 1'd1);
wire [2:0] rd_count_next_no_rd_popping =  rd_pushing ? (rq_rd_count + 1'd1) : 
                                                                    rq_rd_count;
// spyglass enable_block W164a W484
wire [2:0] rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
wire rd_count_next_rd_popping_not_0 = rd_count_next_rd_popping != 0;
wire rd_count_next_no_rd_popping_not_0 = rd_count_next_no_rd_popping != 0;
wire rd_count_next_not_0 = rd_popping ? rd_count_next_rd_popping_not_0 :
                                              rd_count_next_no_rd_popping_not_0;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rq_rd_count <=  3'd0;
        rq_rd_pvld <=  1'b0;
        rq_rd_pvld_int <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    rq_rd_count <=  rd_count_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rq_rd_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    rq_rd_pvld   <=   (rd_count_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rq_rd_pvld   <=  `x_or_0;
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    rq_rd_pvld_int <=   (rd_count_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rq_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on

    end
end

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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (rq_wr_pvld && !rq_wr_busy_int) || (rq_wr_busy_int != rq_wr_busy_next)) || (rd_pushing || rd_popping || (rq_rd_pvld && rq_rd_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_MCIF_READ_EG_lat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_MCIF_READ_EG_lat_fifo_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_wr_limit=%d", wr_limit_override_value);
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
    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
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
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_EG_lat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( rq_wr_pvld && !(!rq_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst0(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst1(stall_cycles_min, stall_cycles_max);
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
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, rq_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_MCIF_READ_EG_lat_fifo") true
// synopsys dc_script_end


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


endmodule // NV_NVDLA_MCIF_READ_EG_lat_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_MCIF_READ_EG_lat_fifo_flopram_rwsa_4x512 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [511:0] di;
input  we;
input  [1:0] wa;
input  [1:0] ra;
output [511:0] dout;

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


`ifdef EMU


// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [511:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_MCIF_READ_EG_lat_fifo_flopram_rwsa_4x512 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout )
   );

`else

reg [511:0] ram_ff0;
reg [511:0] ram_ff1;
reg [511:0] ram_ff2;
reg [511:0] ram_ff3;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [511:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = ram_ff2;
    2'd3:       dout = ram_ff3;
    //VCS coverage off
    default:    dout = {512{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_MCIF_READ_EG_lat_fifo_flopram_rwsa_4x512

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_MCIF_READ_EG_lat_fifo_flopram_rwsa_4x512 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [511:0] Di0;
input  [1:0] Ra0;
output [511:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 512'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [511:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [511:0] Q0 = mem[0];
wire [511:0] Q1 = mem[1];
wire [511:0] Q2 = mem[2];
wire [511:0] Q3 = mem[3];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_MCIF_READ_EG_lat_fifo_flopram_rwsa_4x512] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_MCIF_READ_EG_lat_fifo_flopram_rwsa_4x512] }
endmodule // vmw_NV_NVDLA_MCIF_READ_EG_lat_fifo_flopram_rwsa_4x512

//vmw: Memory vmw_NV_NVDLA_MCIF_READ_EG_lat_fifo_flopram_rwsa_4x512
//vmw: Address-size 2
//vmw: Data-size 512
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[511:0] data0[511:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[511:0] data1[511:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_MCIF_READ_EG_lat_fifo_flopram_rwsa_4x512
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_MCIF_READ_EG_ro_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus ro_wr -rd_pipebus ro_rd -d 4 -ram_bypass -rd_reg -rd_busy_reg -w 257 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_MCIF_READ_EG_ro_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , ro_wr_prdy
    , ro_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , ro_wr_pause
`endif
    , ro_wr_pd
    , ro_rd_prdy
    , ro_rd_pvld
    , ro_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        ro_wr_prdy;
input         ro_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         ro_wr_pause;
`endif
input  [256:0] ro_wr_pd;
input         ro_rd_prdy;
output        ro_rd_pvld;
output [256:0] ro_rd_pd;
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
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        ro_wr_busy_int;		        	// copy for internal use
assign     ro_wr_prdy = !ro_wr_busy_int;
assign       wr_reserving = ro_wr_pvld && !ro_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] ro_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? ro_wr_count : (ro_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (ro_wr_count + 1'd1) : ro_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       ro_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check ro_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || ro_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       ro_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check ro_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_busy_int <=  1'b0;
        ro_wr_count <=  3'd0;
    end else begin
	ro_wr_busy_int <=  ro_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    ro_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            ro_wr_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as ro_wr_pvld

//
// RAM
//

reg  [1:0] ro_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    ro_wr_adr <=  ro_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] ro_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (ro_wr_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [256:0] ro_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_MCIF_READ_EG_ro_fifo_flopram_rwsa_4x257 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( ro_wr_pd )
    , .we        ( ram_we )
    , .wa        ( ro_wr_adr )
    , .ra        ( (ro_wr_count == 0) ? 3'd4 : {1'b0,ro_rd_adr} )
    , .dout        ( ro_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = ro_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    ro_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            ro_rd_adr <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

reg        ro_rd_prdy_d;				// ro_rd_prdy registered in cleanly

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_prdy_d <=  1'b1;
    end else begin
        ro_rd_prdy_d <=  ro_rd_prdy;
    end
end

wire       ro_rd_prdy_d_o;			// combinatorial rd_busy

reg        ro_rd_pvld_int;			// internal copy of ro_rd_pvld

assign     ro_rd_pvld = ro_rd_pvld_int;
wire       ro_rd_pvld_p; 		// data out of fifo is valid

reg        ro_rd_pvld_int_o;	// internal copy of ro_rd_pvld_o
wire       ro_rd_pvld_o = ro_rd_pvld_int_o;
assign     rd_popping = ro_rd_pvld_p && !(ro_rd_pvld_int_o && !ro_rd_prdy_d_o);

reg  [2:0] ro_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_p_next_rd_popping = rd_pushing ? ro_rd_count_p : 
                                                                (ro_rd_count_p - 1'd1);
wire [2:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (ro_rd_count_p + 1'd1) : 
                                                                    ro_rd_count_p;
// spyglass enable_block W164a W484
wire [2:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     ro_rd_pvld_p = ro_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_count_p <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    ro_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            ro_rd_count_p <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end


// 
// SKID for -rd_busy_reg
//
reg [256:0]  ro_rd_pd_o;         // output data register
wire        rd_req_next_o = (ro_rd_pvld_p || (ro_rd_pvld_int_o && !ro_rd_prdy_d_o)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_pvld_int_o <=  1'b0;
    end else begin
        ro_rd_pvld_int_o <=  rd_req_next_o;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (ro_rd_pvld_int && rd_req_next_o && rd_popping) ) begin
        ro_rd_pd_o <=  ro_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((ro_rd_pvld_int && rd_req_next_o && rd_popping)) ) begin
    end else begin
        ro_rd_pd_o <=  {257{`x_or_0}};
    end
    //synopsys translate_on

end

//
// FINAL OUTPUT
//
reg [256:0]  ro_rd_pd;				// output data register
reg        ro_rd_pvld_int_d;			// so we can bubble-collapse ro_rd_prdy_d
assign     ro_rd_prdy_d_o = !((ro_rd_pvld_o && ro_rd_pvld_int_d && !ro_rd_prdy_d ) );
wire       rd_req_next = (!ro_rd_prdy_d_o ? ro_rd_pvld_o : ro_rd_pvld_p) ;  

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_pvld_int <=  1'b0;
        ro_rd_pvld_int_d <=  1'b0;
    end else begin
        if ( !ro_rd_pvld_int || ro_rd_prdy ) begin
	    ro_rd_pvld_int <=  rd_req_next;
        end
        //synopsys translate_off
            else if ( !(!ro_rd_pvld_int || ro_rd_prdy) ) begin
        end else begin
            ro_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on


        ro_rd_pvld_int_d <=  ro_rd_pvld_int;
    end
end

always @( posedge nvdla_core_clk ) begin
    if ( rd_req_next && (!ro_rd_pvld_int || ro_rd_prdy ) ) begin
        case (!ro_rd_prdy_d_o) 
            1'b0:    ro_rd_pd <=  ro_rd_pd_p;
            1'b1:    ro_rd_pd <=  ro_rd_pd_o;
            //VCS coverage off
            default: ro_rd_pd <=  {257{`x_or_0}};
            //VCS coverage on
        endcase
    end
    //synopsys translate_off
        else if ( !(rd_req_next && (!ro_rd_pvld_int || ro_rd_prdy)) ) begin
    end else begin
        ro_rd_pd <=  {257{`x_or_0}};
    end
    //synopsys translate_on

end


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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (ro_wr_pvld && !ro_wr_busy_int) || (ro_wr_busy_int != ro_wr_busy_next)) || (rd_pushing || rd_popping || (ro_rd_pvld_int && ro_rd_prdy_d) || (ro_rd_pvld_int_o && ro_rd_prdy_d_o)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_MCIF_READ_EG_ro_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_MCIF_READ_EG_ro_fifo_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_wr_limit=%d", wr_limit_override_value);
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
    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
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
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_EG_ro_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( ro_wr_pvld && !(!ro_wr_prdy)
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
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, ro_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_MCIF_READ_EG_ro_fifo") true
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


endmodule // NV_NVDLA_MCIF_READ_EG_ro_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_MCIF_READ_EG_ro_fifo_flopram_rwsa_4x257 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [256:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [256:0] dout;

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


`ifdef EMU


wire [256:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [256:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_MCIF_READ_EG_ro_fifo_flopram_rwsa_4x257 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [256:0] ram_ff0;
reg [256:0] ram_ff1;
reg [256:0] ram_ff2;
reg [256:0] ram_ff3;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [256:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {257{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_MCIF_READ_EG_ro_fifo_flopram_rwsa_4x257

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_MCIF_READ_EG_ro_fifo_flopram_rwsa_4x257 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [256:0] Di0;
input  [1:0] Ra0;
output [256:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 257'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [256:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [256:0] Q0 = mem[0];
wire [256:0] Q1 = mem[1];
wire [256:0] Q2 = mem[2];
wire [256:0] Q3 = mem[3];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_MCIF_READ_EG_ro_fifo_flopram_rwsa_4x257] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_MCIF_READ_EG_ro_fifo_flopram_rwsa_4x257] }
endmodule // vmw_NV_NVDLA_MCIF_READ_EG_ro_fifo_flopram_rwsa_4x257

//vmw: Memory vmw_NV_NVDLA_MCIF_READ_EG_ro_fifo_flopram_rwsa_4x257
//vmw: Address-size 2
//vmw: Data-size 257
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[256:0] data0[256:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[256:0] data1[256:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_MCIF_READ_EG_ro_fifo_flopram_rwsa_4x257
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU


