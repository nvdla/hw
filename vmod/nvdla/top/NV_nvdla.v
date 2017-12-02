// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_nvdla.v

`ifdef NV_HWACC
`include "NV_HWACC_NVDLA_tick_defines.vh"
`endif


module NV_nvdla (
   dla_core_clk                  //|< i
  ,dla_csb_clk                   //|< i
  ,global_clk_ovr_on             //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,dla_reset_rstn                //|< i
  ,direct_reset_                 //|< i
  ,test_mode                     //|< i
  ,csb2nvdla_valid               //|< i
  ,csb2nvdla_ready               //|> o
  ,csb2nvdla_addr                //|< i
  ,csb2nvdla_wdat                //|< i
  ,csb2nvdla_write               //|< i
  ,csb2nvdla_nposted             //|< i
  ,nvdla2csb_valid               //|> o
  ,nvdla2csb_data                //|> o
  ,nvdla2csb_wr_complete         //|> o
  ,nvdla_core2dbb_aw_awvalid     //|> o
  ,nvdla_core2dbb_aw_awready     //|< i
  ,nvdla_core2dbb_aw_awid        //|> o
  ,nvdla_core2dbb_aw_awlen       //|> o
  ,nvdla_core2dbb_aw_awaddr      //|> o
  ,nvdla_core2dbb_w_wvalid       //|> o
  ,nvdla_core2dbb_w_wready       //|< i
  ,nvdla_core2dbb_w_wdata        //|> o
  ,nvdla_core2dbb_w_wstrb        //|> o
  ,nvdla_core2dbb_w_wlast        //|> o
  ,nvdla_core2dbb_b_bvalid       //|< i
  ,nvdla_core2dbb_b_bready       //|> o
  ,nvdla_core2dbb_b_bid          //|< i
  ,nvdla_core2dbb_ar_arvalid     //|> o
  ,nvdla_core2dbb_ar_arready     //|< i
  ,nvdla_core2dbb_ar_arid        //|> o
  ,nvdla_core2dbb_ar_arlen       //|> o
  ,nvdla_core2dbb_ar_araddr      //|> o
  ,nvdla_core2dbb_r_rvalid       //|< i
  ,nvdla_core2dbb_r_rready       //|> o
  ,nvdla_core2dbb_r_rid          //|< i
  ,nvdla_core2dbb_r_rlast        //|< i
  ,nvdla_core2dbb_r_rdata        //|< i
  ,nvdla_core2cvsram_aw_awvalid  //|> o
  ,nvdla_core2cvsram_aw_awready  //|< i
  ,nvdla_core2cvsram_aw_awid     //|> o
  ,nvdla_core2cvsram_aw_awlen    //|> o
  ,nvdla_core2cvsram_aw_awaddr   //|> o
  ,nvdla_core2cvsram_w_wvalid    //|> o
  ,nvdla_core2cvsram_w_wready    //|< i
  ,nvdla_core2cvsram_w_wdata     //|> o
  ,nvdla_core2cvsram_w_wstrb     //|> o
  ,nvdla_core2cvsram_w_wlast     //|> o
  ,nvdla_core2cvsram_b_bvalid    //|< i
  ,nvdla_core2cvsram_b_bready    //|> o
  ,nvdla_core2cvsram_b_bid       //|< i
  ,nvdla_core2cvsram_ar_arvalid  //|> o
  ,nvdla_core2cvsram_ar_arready  //|< i
  ,nvdla_core2cvsram_ar_arid     //|> o
  ,nvdla_core2cvsram_ar_arlen    //|> o
  ,nvdla_core2cvsram_ar_araddr   //|> o
  ,nvdla_core2cvsram_r_rvalid    //|< i
  ,nvdla_core2cvsram_r_rready    //|> o
  ,nvdla_core2cvsram_r_rid       //|< i
  ,nvdla_core2cvsram_r_rlast     //|< i
  ,nvdla_core2cvsram_r_rdata     //|< i
  ,dla_intr                      //|> o
  ,nvdla_pwrbus_ram_c_pd         //|< i
  ,nvdla_pwrbus_ram_ma_pd        //|< i *
  ,nvdla_pwrbus_ram_mb_pd        //|< i *
  ,nvdla_pwrbus_ram_p_pd         //|< i
  ,nvdla_pwrbus_ram_o_pd         //|< i
  ,nvdla_pwrbus_ram_a_pd         //|< i
  );

//
// NV_nvdla_ports.v
//
input  dla_core_clk;  /* nvdla_core2dbb_aw, nvdla_core2dbb_w, nvdla_core2dbb_b, nvdla_core2dbb_ar, nvdla_core2dbb_r, nvdla_core2cvsram_aw, nvdla_core2cvsram_w, nvdla_core2cvsram_b, nvdla_core2cvsram_ar, nvdla_core2cvsram_r */
input  dla_csb_clk;   /* csb2nvdla, nvdla2csb, nvdla2csb_wr */

input  global_clk_ovr_on;
input  tmc2slcg_disable_clock_gating;

input  dla_reset_rstn;
input  direct_reset_;

input  test_mode;

input         csb2nvdla_valid;    /* data valid */
output        csb2nvdla_ready;    /* data return handshake */
input  [15:0] csb2nvdla_addr;
input  [31:0] csb2nvdla_wdat;
input         csb2nvdla_write;
input         csb2nvdla_nposted;

output        nvdla2csb_valid;  /* data valid */
output [31:0] nvdla2csb_data;

output  nvdla2csb_wr_complete;

output        nvdla_core2dbb_aw_awvalid;  /* data valid */
input         nvdla_core2dbb_aw_awready;  /* data return handshake */
output  [7:0] nvdla_core2dbb_aw_awid;
output  [3:0] nvdla_core2dbb_aw_awlen;
output [63:0] nvdla_core2dbb_aw_awaddr;

output         nvdla_core2dbb_w_wvalid;  /* data valid */
input          nvdla_core2dbb_w_wready;  /* data return handshake */
output [511:0] nvdla_core2dbb_w_wdata;
output  [63:0] nvdla_core2dbb_w_wstrb;
output         nvdla_core2dbb_w_wlast;

input        nvdla_core2dbb_b_bvalid;  /* data valid */
output       nvdla_core2dbb_b_bready;  /* data return handshake */
input  [7:0] nvdla_core2dbb_b_bid;

output        nvdla_core2dbb_ar_arvalid;  /* data valid */
input         nvdla_core2dbb_ar_arready;  /* data return handshake */
output  [7:0] nvdla_core2dbb_ar_arid;
output  [3:0] nvdla_core2dbb_ar_arlen;
output [63:0] nvdla_core2dbb_ar_araddr;

input          nvdla_core2dbb_r_rvalid;  /* data valid */
output         nvdla_core2dbb_r_rready;  /* data return handshake */
input    [7:0] nvdla_core2dbb_r_rid;
input          nvdla_core2dbb_r_rlast;
input  [511:0] nvdla_core2dbb_r_rdata;

output        nvdla_core2cvsram_aw_awvalid;  /* data valid */
input         nvdla_core2cvsram_aw_awready;  /* data return handshake */
output  [7:0] nvdla_core2cvsram_aw_awid;
output  [3:0] nvdla_core2cvsram_aw_awlen;
output [63:0] nvdla_core2cvsram_aw_awaddr;

output         nvdla_core2cvsram_w_wvalid;  /* data valid */
input          nvdla_core2cvsram_w_wready;  /* data return handshake */
output [511:0] nvdla_core2cvsram_w_wdata;
output  [63:0] nvdla_core2cvsram_w_wstrb;
output         nvdla_core2cvsram_w_wlast;

input        nvdla_core2cvsram_b_bvalid;  /* data valid */
output       nvdla_core2cvsram_b_bready;  /* data return handshake */
input  [7:0] nvdla_core2cvsram_b_bid;

output        nvdla_core2cvsram_ar_arvalid;  /* data valid */
input         nvdla_core2cvsram_ar_arready;  /* data return handshake */
output  [7:0] nvdla_core2cvsram_ar_arid;
output  [3:0] nvdla_core2cvsram_ar_arlen;
output [63:0] nvdla_core2cvsram_ar_araddr;

input          nvdla_core2cvsram_r_rvalid;  /* data valid */
output         nvdla_core2cvsram_r_rready;  /* data return handshake */
input    [7:0] nvdla_core2cvsram_r_rid;
input          nvdla_core2cvsram_r_rlast;
input  [511:0] nvdla_core2cvsram_r_rdata;

output  dla_intr;

input [31:0] nvdla_pwrbus_ram_c_pd;

input [31:0] nvdla_pwrbus_ram_ma_pd;

input [31:0] nvdla_pwrbus_ram_mb_pd;

input [31:0] nvdla_pwrbus_ram_p_pd;

input [31:0] nvdla_pwrbus_ram_o_pd;

input [31:0] nvdla_pwrbus_ram_a_pd;

//input         dla_csb_clk;

wire   [2:0] accu2sc_credit_size;
wire         accu2sc_credit_vld;
wire  [33:0] cacc2csb_resp_dst_pd;
wire         cacc2csb_resp_dst_valid;
wire  [33:0] cacc2csb_resp_src_pd;
wire         cacc2csb_resp_src_valid;
wire   [1:0] cacc2glb_done_intr_dst_pd;
wire   [1:0] cacc2glb_done_intr_src_pd;
wire [513:0] cacc2sdp_pd;
wire         cacc2sdp_ready;
wire         cacc2sdp_valid;
wire  [33:0] cdma2csb_resp_pd;
wire         cdma2csb_resp_valid;
wire  [78:0] cdma_dat2cvif_rd_req_pd;
wire         cdma_dat2cvif_rd_req_ready;
wire         cdma_dat2cvif_rd_req_valid;
wire   [1:0] cdma_dat2glb_done_intr_pd;
wire  [78:0] cdma_dat2mcif_rd_req_pd;
wire         cdma_dat2mcif_rd_req_ready;
wire         cdma_dat2mcif_rd_req_valid;
wire  [78:0] cdma_wt2cvif_rd_req_pd;
wire         cdma_wt2cvif_rd_req_ready;
wire         cdma_wt2cvif_rd_req_valid;
wire   [1:0] cdma_wt2glb_done_intr_pd;
wire  [78:0] cdma_wt2mcif_rd_req_pd;
wire         cdma_wt2mcif_rd_req_ready;
wire         cdma_wt2mcif_rd_req_valid;
wire  [33:0] cmac_a2csb_resp_src_pd;
wire         cmac_a2csb_resp_src_valid;
wire  [33:0] cmac_b2csb_resp_dst_pd;
wire         cmac_b2csb_resp_dst_valid;
wire  [33:0] cmac_b2csb_resp_src_pd;
wire         cmac_b2csb_resp_src_valid;
wire  [62:0] csb2cacc_req_dst_pd;
wire         csb2cacc_req_dst_prdy;
wire         csb2cacc_req_dst_pvld;
wire  [62:0] csb2cacc_req_src_pd;
wire         csb2cacc_req_src_prdy;
wire         csb2cacc_req_src_pvld;
wire  [62:0] csb2cdma_req_pd;
wire         csb2cdma_req_prdy;
wire         csb2cdma_req_pvld;
wire  [62:0] csb2cmac_a_req_dst_pd;
wire         csb2cmac_a_req_dst_prdy;
wire         csb2cmac_a_req_dst_pvld;
wire  [62:0] csb2cmac_b_req_dst_pd;
wire         csb2cmac_b_req_dst_prdy;
wire         csb2cmac_b_req_dst_pvld;
wire  [62:0] csb2cmac_b_req_src_pd;
wire         csb2cmac_b_req_src_prdy;
wire         csb2cmac_b_req_src_pvld;
wire  [62:0] csb2csc_req_pd;
wire         csb2csc_req_prdy;
wire         csb2csc_req_pvld;
wire  [62:0] csb2sdp_rdma_req_pd;
wire         csb2sdp_rdma_req_prdy;
wire         csb2sdp_rdma_req_pvld;
wire  [62:0] csb2sdp_req_pd;
wire         csb2sdp_req_prdy;
wire         csb2sdp_req_pvld;
wire  [33:0] csc2csb_resp_pd;
wire         csc2csb_resp_valid;
wire [513:0] cvif2cdma_dat_rd_rsp_pd;
wire         cvif2cdma_dat_rd_rsp_ready;
wire         cvif2cdma_dat_rd_rsp_valid;
wire [513:0] cvif2cdma_wt_rd_rsp_pd;
wire         cvif2cdma_wt_rd_rsp_ready;
wire         cvif2cdma_wt_rd_rsp_valid;
wire [513:0] cvif2sdp_b_rd_rsp_pd;
wire         cvif2sdp_b_rd_rsp_ready;
wire         cvif2sdp_b_rd_rsp_valid;
wire [513:0] cvif2sdp_e_rd_rsp_pd;
wire         cvif2sdp_e_rd_rsp_ready;
wire         cvif2sdp_e_rd_rsp_valid;
wire [513:0] cvif2sdp_n_rd_rsp_pd;
wire         cvif2sdp_n_rd_rsp_ready;
wire         cvif2sdp_n_rd_rsp_valid;
wire [513:0] cvif2sdp_rd_rsp_pd;
wire         cvif2sdp_rd_rsp_ready;
wire         cvif2sdp_rd_rsp_valid;
wire         cvif2sdp_wr_rsp_complete;
wire [175:0] mac_a2accu_dst_data0;
wire [175:0] mac_a2accu_dst_data1;
wire [175:0] mac_a2accu_dst_data2;
wire [175:0] mac_a2accu_dst_data3;
wire [175:0] mac_a2accu_dst_data4;
wire [175:0] mac_a2accu_dst_data5;
wire [175:0] mac_a2accu_dst_data6;
wire [175:0] mac_a2accu_dst_data7;
wire   [7:0] mac_a2accu_dst_mask;
wire   [7:0] mac_a2accu_dst_mode;
wire   [8:0] mac_a2accu_dst_pd;
wire         mac_a2accu_dst_pvld;
wire [175:0] mac_a2accu_src_data0;
wire [175:0] mac_a2accu_src_data1;
wire [175:0] mac_a2accu_src_data2;
wire [175:0] mac_a2accu_src_data3;
wire [175:0] mac_a2accu_src_data4;
wire [175:0] mac_a2accu_src_data5;
wire [175:0] mac_a2accu_src_data6;
wire [175:0] mac_a2accu_src_data7;
wire   [7:0] mac_a2accu_src_mask;
wire   [7:0] mac_a2accu_src_mode;
wire   [8:0] mac_a2accu_src_pd;
wire         mac_a2accu_src_pvld;
wire [175:0] mac_b2accu_src_data0;
wire [175:0] mac_b2accu_src_data1;
wire [175:0] mac_b2accu_src_data2;
wire [175:0] mac_b2accu_src_data3;
wire [175:0] mac_b2accu_src_data4;
wire [175:0] mac_b2accu_src_data5;
wire [175:0] mac_b2accu_src_data6;
wire [175:0] mac_b2accu_src_data7;
wire   [7:0] mac_b2accu_src_mask;
wire   [7:0] mac_b2accu_src_mode;
wire   [8:0] mac_b2accu_src_pd;
wire         mac_b2accu_src_pvld;
wire [513:0] mcif2cdma_dat_rd_rsp_pd;
wire         mcif2cdma_dat_rd_rsp_ready;
wire         mcif2cdma_dat_rd_rsp_valid;
wire [513:0] mcif2cdma_wt_rd_rsp_pd;
wire         mcif2cdma_wt_rd_rsp_ready;
wire         mcif2cdma_wt_rd_rsp_valid;
wire [513:0] mcif2sdp_b_rd_rsp_pd;
wire         mcif2sdp_b_rd_rsp_ready;
wire         mcif2sdp_b_rd_rsp_valid;
wire [513:0] mcif2sdp_e_rd_rsp_pd;
wire         mcif2sdp_e_rd_rsp_ready;
wire         mcif2sdp_e_rd_rsp_valid;
wire [513:0] mcif2sdp_n_rd_rsp_pd;
wire         mcif2sdp_n_rd_rsp_ready;
wire         mcif2sdp_n_rd_rsp_valid;
wire [513:0] mcif2sdp_rd_rsp_pd;
wire         mcif2sdp_rd_rsp_ready;
wire         mcif2sdp_rd_rsp_valid;
wire         mcif2sdp_wr_rsp_complete;
wire         nvdla_clk_ovr_on;
wire         nvdla_core_rstn;
wire   [7:0] sc2mac_dat_a_dst_data0;
wire   [7:0] sc2mac_dat_a_dst_data1;
wire   [7:0] sc2mac_dat_a_dst_data10;
wire   [7:0] sc2mac_dat_a_dst_data100;
wire   [7:0] sc2mac_dat_a_dst_data101;
wire   [7:0] sc2mac_dat_a_dst_data102;
wire   [7:0] sc2mac_dat_a_dst_data103;
wire   [7:0] sc2mac_dat_a_dst_data104;
wire   [7:0] sc2mac_dat_a_dst_data105;
wire   [7:0] sc2mac_dat_a_dst_data106;
wire   [7:0] sc2mac_dat_a_dst_data107;
wire   [7:0] sc2mac_dat_a_dst_data108;
wire   [7:0] sc2mac_dat_a_dst_data109;
wire   [7:0] sc2mac_dat_a_dst_data11;
wire   [7:0] sc2mac_dat_a_dst_data110;
wire   [7:0] sc2mac_dat_a_dst_data111;
wire   [7:0] sc2mac_dat_a_dst_data112;
wire   [7:0] sc2mac_dat_a_dst_data113;
wire   [7:0] sc2mac_dat_a_dst_data114;
wire   [7:0] sc2mac_dat_a_dst_data115;
wire   [7:0] sc2mac_dat_a_dst_data116;
wire   [7:0] sc2mac_dat_a_dst_data117;
wire   [7:0] sc2mac_dat_a_dst_data118;
wire   [7:0] sc2mac_dat_a_dst_data119;
wire   [7:0] sc2mac_dat_a_dst_data12;
wire   [7:0] sc2mac_dat_a_dst_data120;
wire   [7:0] sc2mac_dat_a_dst_data121;
wire   [7:0] sc2mac_dat_a_dst_data122;
wire   [7:0] sc2mac_dat_a_dst_data123;
wire   [7:0] sc2mac_dat_a_dst_data124;
wire   [7:0] sc2mac_dat_a_dst_data125;
wire   [7:0] sc2mac_dat_a_dst_data126;
wire   [7:0] sc2mac_dat_a_dst_data127;
wire   [7:0] sc2mac_dat_a_dst_data13;
wire   [7:0] sc2mac_dat_a_dst_data14;
wire   [7:0] sc2mac_dat_a_dst_data15;
wire   [7:0] sc2mac_dat_a_dst_data16;
wire   [7:0] sc2mac_dat_a_dst_data17;
wire   [7:0] sc2mac_dat_a_dst_data18;
wire   [7:0] sc2mac_dat_a_dst_data19;
wire   [7:0] sc2mac_dat_a_dst_data2;
wire   [7:0] sc2mac_dat_a_dst_data20;
wire   [7:0] sc2mac_dat_a_dst_data21;
wire   [7:0] sc2mac_dat_a_dst_data22;
wire   [7:0] sc2mac_dat_a_dst_data23;
wire   [7:0] sc2mac_dat_a_dst_data24;
wire   [7:0] sc2mac_dat_a_dst_data25;
wire   [7:0] sc2mac_dat_a_dst_data26;
wire   [7:0] sc2mac_dat_a_dst_data27;
wire   [7:0] sc2mac_dat_a_dst_data28;
wire   [7:0] sc2mac_dat_a_dst_data29;
wire   [7:0] sc2mac_dat_a_dst_data3;
wire   [7:0] sc2mac_dat_a_dst_data30;
wire   [7:0] sc2mac_dat_a_dst_data31;
wire   [7:0] sc2mac_dat_a_dst_data32;
wire   [7:0] sc2mac_dat_a_dst_data33;
wire   [7:0] sc2mac_dat_a_dst_data34;
wire   [7:0] sc2mac_dat_a_dst_data35;
wire   [7:0] sc2mac_dat_a_dst_data36;
wire   [7:0] sc2mac_dat_a_dst_data37;
wire   [7:0] sc2mac_dat_a_dst_data38;
wire   [7:0] sc2mac_dat_a_dst_data39;
wire   [7:0] sc2mac_dat_a_dst_data4;
wire   [7:0] sc2mac_dat_a_dst_data40;
wire   [7:0] sc2mac_dat_a_dst_data41;
wire   [7:0] sc2mac_dat_a_dst_data42;
wire   [7:0] sc2mac_dat_a_dst_data43;
wire   [7:0] sc2mac_dat_a_dst_data44;
wire   [7:0] sc2mac_dat_a_dst_data45;
wire   [7:0] sc2mac_dat_a_dst_data46;
wire   [7:0] sc2mac_dat_a_dst_data47;
wire   [7:0] sc2mac_dat_a_dst_data48;
wire   [7:0] sc2mac_dat_a_dst_data49;
wire   [7:0] sc2mac_dat_a_dst_data5;
wire   [7:0] sc2mac_dat_a_dst_data50;
wire   [7:0] sc2mac_dat_a_dst_data51;
wire   [7:0] sc2mac_dat_a_dst_data52;
wire   [7:0] sc2mac_dat_a_dst_data53;
wire   [7:0] sc2mac_dat_a_dst_data54;
wire   [7:0] sc2mac_dat_a_dst_data55;
wire   [7:0] sc2mac_dat_a_dst_data56;
wire   [7:0] sc2mac_dat_a_dst_data57;
wire   [7:0] sc2mac_dat_a_dst_data58;
wire   [7:0] sc2mac_dat_a_dst_data59;
wire   [7:0] sc2mac_dat_a_dst_data6;
wire   [7:0] sc2mac_dat_a_dst_data60;
wire   [7:0] sc2mac_dat_a_dst_data61;
wire   [7:0] sc2mac_dat_a_dst_data62;
wire   [7:0] sc2mac_dat_a_dst_data63;
wire   [7:0] sc2mac_dat_a_dst_data64;
wire   [7:0] sc2mac_dat_a_dst_data65;
wire   [7:0] sc2mac_dat_a_dst_data66;
wire   [7:0] sc2mac_dat_a_dst_data67;
wire   [7:0] sc2mac_dat_a_dst_data68;
wire   [7:0] sc2mac_dat_a_dst_data69;
wire   [7:0] sc2mac_dat_a_dst_data7;
wire   [7:0] sc2mac_dat_a_dst_data70;
wire   [7:0] sc2mac_dat_a_dst_data71;
wire   [7:0] sc2mac_dat_a_dst_data72;
wire   [7:0] sc2mac_dat_a_dst_data73;
wire   [7:0] sc2mac_dat_a_dst_data74;
wire   [7:0] sc2mac_dat_a_dst_data75;
wire   [7:0] sc2mac_dat_a_dst_data76;
wire   [7:0] sc2mac_dat_a_dst_data77;
wire   [7:0] sc2mac_dat_a_dst_data78;
wire   [7:0] sc2mac_dat_a_dst_data79;
wire   [7:0] sc2mac_dat_a_dst_data8;
wire   [7:0] sc2mac_dat_a_dst_data80;
wire   [7:0] sc2mac_dat_a_dst_data81;
wire   [7:0] sc2mac_dat_a_dst_data82;
wire   [7:0] sc2mac_dat_a_dst_data83;
wire   [7:0] sc2mac_dat_a_dst_data84;
wire   [7:0] sc2mac_dat_a_dst_data85;
wire   [7:0] sc2mac_dat_a_dst_data86;
wire   [7:0] sc2mac_dat_a_dst_data87;
wire   [7:0] sc2mac_dat_a_dst_data88;
wire   [7:0] sc2mac_dat_a_dst_data89;
wire   [7:0] sc2mac_dat_a_dst_data9;
wire   [7:0] sc2mac_dat_a_dst_data90;
wire   [7:0] sc2mac_dat_a_dst_data91;
wire   [7:0] sc2mac_dat_a_dst_data92;
wire   [7:0] sc2mac_dat_a_dst_data93;
wire   [7:0] sc2mac_dat_a_dst_data94;
wire   [7:0] sc2mac_dat_a_dst_data95;
wire   [7:0] sc2mac_dat_a_dst_data96;
wire   [7:0] sc2mac_dat_a_dst_data97;
wire   [7:0] sc2mac_dat_a_dst_data98;
wire   [7:0] sc2mac_dat_a_dst_data99;
wire [127:0] sc2mac_dat_a_dst_mask;
wire   [8:0] sc2mac_dat_a_dst_pd;
wire         sc2mac_dat_a_dst_pvld;
wire   [7:0] sc2mac_dat_a_src_data0;
wire   [7:0] sc2mac_dat_a_src_data1;
wire   [7:0] sc2mac_dat_a_src_data10;
wire   [7:0] sc2mac_dat_a_src_data100;
wire   [7:0] sc2mac_dat_a_src_data101;
wire   [7:0] sc2mac_dat_a_src_data102;
wire   [7:0] sc2mac_dat_a_src_data103;
wire   [7:0] sc2mac_dat_a_src_data104;
wire   [7:0] sc2mac_dat_a_src_data105;
wire   [7:0] sc2mac_dat_a_src_data106;
wire   [7:0] sc2mac_dat_a_src_data107;
wire   [7:0] sc2mac_dat_a_src_data108;
wire   [7:0] sc2mac_dat_a_src_data109;
wire   [7:0] sc2mac_dat_a_src_data11;
wire   [7:0] sc2mac_dat_a_src_data110;
wire   [7:0] sc2mac_dat_a_src_data111;
wire   [7:0] sc2mac_dat_a_src_data112;
wire   [7:0] sc2mac_dat_a_src_data113;
wire   [7:0] sc2mac_dat_a_src_data114;
wire   [7:0] sc2mac_dat_a_src_data115;
wire   [7:0] sc2mac_dat_a_src_data116;
wire   [7:0] sc2mac_dat_a_src_data117;
wire   [7:0] sc2mac_dat_a_src_data118;
wire   [7:0] sc2mac_dat_a_src_data119;
wire   [7:0] sc2mac_dat_a_src_data12;
wire   [7:0] sc2mac_dat_a_src_data120;
wire   [7:0] sc2mac_dat_a_src_data121;
wire   [7:0] sc2mac_dat_a_src_data122;
wire   [7:0] sc2mac_dat_a_src_data123;
wire   [7:0] sc2mac_dat_a_src_data124;
wire   [7:0] sc2mac_dat_a_src_data125;
wire   [7:0] sc2mac_dat_a_src_data126;
wire   [7:0] sc2mac_dat_a_src_data127;
wire   [7:0] sc2mac_dat_a_src_data13;
wire   [7:0] sc2mac_dat_a_src_data14;
wire   [7:0] sc2mac_dat_a_src_data15;
wire   [7:0] sc2mac_dat_a_src_data16;
wire   [7:0] sc2mac_dat_a_src_data17;
wire   [7:0] sc2mac_dat_a_src_data18;
wire   [7:0] sc2mac_dat_a_src_data19;
wire   [7:0] sc2mac_dat_a_src_data2;
wire   [7:0] sc2mac_dat_a_src_data20;
wire   [7:0] sc2mac_dat_a_src_data21;
wire   [7:0] sc2mac_dat_a_src_data22;
wire   [7:0] sc2mac_dat_a_src_data23;
wire   [7:0] sc2mac_dat_a_src_data24;
wire   [7:0] sc2mac_dat_a_src_data25;
wire   [7:0] sc2mac_dat_a_src_data26;
wire   [7:0] sc2mac_dat_a_src_data27;
wire   [7:0] sc2mac_dat_a_src_data28;
wire   [7:0] sc2mac_dat_a_src_data29;
wire   [7:0] sc2mac_dat_a_src_data3;
wire   [7:0] sc2mac_dat_a_src_data30;
wire   [7:0] sc2mac_dat_a_src_data31;
wire   [7:0] sc2mac_dat_a_src_data32;
wire   [7:0] sc2mac_dat_a_src_data33;
wire   [7:0] sc2mac_dat_a_src_data34;
wire   [7:0] sc2mac_dat_a_src_data35;
wire   [7:0] sc2mac_dat_a_src_data36;
wire   [7:0] sc2mac_dat_a_src_data37;
wire   [7:0] sc2mac_dat_a_src_data38;
wire   [7:0] sc2mac_dat_a_src_data39;
wire   [7:0] sc2mac_dat_a_src_data4;
wire   [7:0] sc2mac_dat_a_src_data40;
wire   [7:0] sc2mac_dat_a_src_data41;
wire   [7:0] sc2mac_dat_a_src_data42;
wire   [7:0] sc2mac_dat_a_src_data43;
wire   [7:0] sc2mac_dat_a_src_data44;
wire   [7:0] sc2mac_dat_a_src_data45;
wire   [7:0] sc2mac_dat_a_src_data46;
wire   [7:0] sc2mac_dat_a_src_data47;
wire   [7:0] sc2mac_dat_a_src_data48;
wire   [7:0] sc2mac_dat_a_src_data49;
wire   [7:0] sc2mac_dat_a_src_data5;
wire   [7:0] sc2mac_dat_a_src_data50;
wire   [7:0] sc2mac_dat_a_src_data51;
wire   [7:0] sc2mac_dat_a_src_data52;
wire   [7:0] sc2mac_dat_a_src_data53;
wire   [7:0] sc2mac_dat_a_src_data54;
wire   [7:0] sc2mac_dat_a_src_data55;
wire   [7:0] sc2mac_dat_a_src_data56;
wire   [7:0] sc2mac_dat_a_src_data57;
wire   [7:0] sc2mac_dat_a_src_data58;
wire   [7:0] sc2mac_dat_a_src_data59;
wire   [7:0] sc2mac_dat_a_src_data6;
wire   [7:0] sc2mac_dat_a_src_data60;
wire   [7:0] sc2mac_dat_a_src_data61;
wire   [7:0] sc2mac_dat_a_src_data62;
wire   [7:0] sc2mac_dat_a_src_data63;
wire   [7:0] sc2mac_dat_a_src_data64;
wire   [7:0] sc2mac_dat_a_src_data65;
wire   [7:0] sc2mac_dat_a_src_data66;
wire   [7:0] sc2mac_dat_a_src_data67;
wire   [7:0] sc2mac_dat_a_src_data68;
wire   [7:0] sc2mac_dat_a_src_data69;
wire   [7:0] sc2mac_dat_a_src_data7;
wire   [7:0] sc2mac_dat_a_src_data70;
wire   [7:0] sc2mac_dat_a_src_data71;
wire   [7:0] sc2mac_dat_a_src_data72;
wire   [7:0] sc2mac_dat_a_src_data73;
wire   [7:0] sc2mac_dat_a_src_data74;
wire   [7:0] sc2mac_dat_a_src_data75;
wire   [7:0] sc2mac_dat_a_src_data76;
wire   [7:0] sc2mac_dat_a_src_data77;
wire   [7:0] sc2mac_dat_a_src_data78;
wire   [7:0] sc2mac_dat_a_src_data79;
wire   [7:0] sc2mac_dat_a_src_data8;
wire   [7:0] sc2mac_dat_a_src_data80;
wire   [7:0] sc2mac_dat_a_src_data81;
wire   [7:0] sc2mac_dat_a_src_data82;
wire   [7:0] sc2mac_dat_a_src_data83;
wire   [7:0] sc2mac_dat_a_src_data84;
wire   [7:0] sc2mac_dat_a_src_data85;
wire   [7:0] sc2mac_dat_a_src_data86;
wire   [7:0] sc2mac_dat_a_src_data87;
wire   [7:0] sc2mac_dat_a_src_data88;
wire   [7:0] sc2mac_dat_a_src_data89;
wire   [7:0] sc2mac_dat_a_src_data9;
wire   [7:0] sc2mac_dat_a_src_data90;
wire   [7:0] sc2mac_dat_a_src_data91;
wire   [7:0] sc2mac_dat_a_src_data92;
wire   [7:0] sc2mac_dat_a_src_data93;
wire   [7:0] sc2mac_dat_a_src_data94;
wire   [7:0] sc2mac_dat_a_src_data95;
wire   [7:0] sc2mac_dat_a_src_data96;
wire   [7:0] sc2mac_dat_a_src_data97;
wire   [7:0] sc2mac_dat_a_src_data98;
wire   [7:0] sc2mac_dat_a_src_data99;
wire [127:0] sc2mac_dat_a_src_mask;
wire   [8:0] sc2mac_dat_a_src_pd;
wire         sc2mac_dat_a_src_pvld;
wire   [7:0] sc2mac_dat_b_dst_data0;
wire   [7:0] sc2mac_dat_b_dst_data1;
wire   [7:0] sc2mac_dat_b_dst_data10;
wire   [7:0] sc2mac_dat_b_dst_data100;
wire   [7:0] sc2mac_dat_b_dst_data101;
wire   [7:0] sc2mac_dat_b_dst_data102;
wire   [7:0] sc2mac_dat_b_dst_data103;
wire   [7:0] sc2mac_dat_b_dst_data104;
wire   [7:0] sc2mac_dat_b_dst_data105;
wire   [7:0] sc2mac_dat_b_dst_data106;
wire   [7:0] sc2mac_dat_b_dst_data107;
wire   [7:0] sc2mac_dat_b_dst_data108;
wire   [7:0] sc2mac_dat_b_dst_data109;
wire   [7:0] sc2mac_dat_b_dst_data11;
wire   [7:0] sc2mac_dat_b_dst_data110;
wire   [7:0] sc2mac_dat_b_dst_data111;
wire   [7:0] sc2mac_dat_b_dst_data112;
wire   [7:0] sc2mac_dat_b_dst_data113;
wire   [7:0] sc2mac_dat_b_dst_data114;
wire   [7:0] sc2mac_dat_b_dst_data115;
wire   [7:0] sc2mac_dat_b_dst_data116;
wire   [7:0] sc2mac_dat_b_dst_data117;
wire   [7:0] sc2mac_dat_b_dst_data118;
wire   [7:0] sc2mac_dat_b_dst_data119;
wire   [7:0] sc2mac_dat_b_dst_data12;
wire   [7:0] sc2mac_dat_b_dst_data120;
wire   [7:0] sc2mac_dat_b_dst_data121;
wire   [7:0] sc2mac_dat_b_dst_data122;
wire   [7:0] sc2mac_dat_b_dst_data123;
wire   [7:0] sc2mac_dat_b_dst_data124;
wire   [7:0] sc2mac_dat_b_dst_data125;
wire   [7:0] sc2mac_dat_b_dst_data126;
wire   [7:0] sc2mac_dat_b_dst_data127;
wire   [7:0] sc2mac_dat_b_dst_data13;
wire   [7:0] sc2mac_dat_b_dst_data14;
wire   [7:0] sc2mac_dat_b_dst_data15;
wire   [7:0] sc2mac_dat_b_dst_data16;
wire   [7:0] sc2mac_dat_b_dst_data17;
wire   [7:0] sc2mac_dat_b_dst_data18;
wire   [7:0] sc2mac_dat_b_dst_data19;
wire   [7:0] sc2mac_dat_b_dst_data2;
wire   [7:0] sc2mac_dat_b_dst_data20;
wire   [7:0] sc2mac_dat_b_dst_data21;
wire   [7:0] sc2mac_dat_b_dst_data22;
wire   [7:0] sc2mac_dat_b_dst_data23;
wire   [7:0] sc2mac_dat_b_dst_data24;
wire   [7:0] sc2mac_dat_b_dst_data25;
wire   [7:0] sc2mac_dat_b_dst_data26;
wire   [7:0] sc2mac_dat_b_dst_data27;
wire   [7:0] sc2mac_dat_b_dst_data28;
wire   [7:0] sc2mac_dat_b_dst_data29;
wire   [7:0] sc2mac_dat_b_dst_data3;
wire   [7:0] sc2mac_dat_b_dst_data30;
wire   [7:0] sc2mac_dat_b_dst_data31;
wire   [7:0] sc2mac_dat_b_dst_data32;
wire   [7:0] sc2mac_dat_b_dst_data33;
wire   [7:0] sc2mac_dat_b_dst_data34;
wire   [7:0] sc2mac_dat_b_dst_data35;
wire   [7:0] sc2mac_dat_b_dst_data36;
wire   [7:0] sc2mac_dat_b_dst_data37;
wire   [7:0] sc2mac_dat_b_dst_data38;
wire   [7:0] sc2mac_dat_b_dst_data39;
wire   [7:0] sc2mac_dat_b_dst_data4;
wire   [7:0] sc2mac_dat_b_dst_data40;
wire   [7:0] sc2mac_dat_b_dst_data41;
wire   [7:0] sc2mac_dat_b_dst_data42;
wire   [7:0] sc2mac_dat_b_dst_data43;
wire   [7:0] sc2mac_dat_b_dst_data44;
wire   [7:0] sc2mac_dat_b_dst_data45;
wire   [7:0] sc2mac_dat_b_dst_data46;
wire   [7:0] sc2mac_dat_b_dst_data47;
wire   [7:0] sc2mac_dat_b_dst_data48;
wire   [7:0] sc2mac_dat_b_dst_data49;
wire   [7:0] sc2mac_dat_b_dst_data5;
wire   [7:0] sc2mac_dat_b_dst_data50;
wire   [7:0] sc2mac_dat_b_dst_data51;
wire   [7:0] sc2mac_dat_b_dst_data52;
wire   [7:0] sc2mac_dat_b_dst_data53;
wire   [7:0] sc2mac_dat_b_dst_data54;
wire   [7:0] sc2mac_dat_b_dst_data55;
wire   [7:0] sc2mac_dat_b_dst_data56;
wire   [7:0] sc2mac_dat_b_dst_data57;
wire   [7:0] sc2mac_dat_b_dst_data58;
wire   [7:0] sc2mac_dat_b_dst_data59;
wire   [7:0] sc2mac_dat_b_dst_data6;
wire   [7:0] sc2mac_dat_b_dst_data60;
wire   [7:0] sc2mac_dat_b_dst_data61;
wire   [7:0] sc2mac_dat_b_dst_data62;
wire   [7:0] sc2mac_dat_b_dst_data63;
wire   [7:0] sc2mac_dat_b_dst_data64;
wire   [7:0] sc2mac_dat_b_dst_data65;
wire   [7:0] sc2mac_dat_b_dst_data66;
wire   [7:0] sc2mac_dat_b_dst_data67;
wire   [7:0] sc2mac_dat_b_dst_data68;
wire   [7:0] sc2mac_dat_b_dst_data69;
wire   [7:0] sc2mac_dat_b_dst_data7;
wire   [7:0] sc2mac_dat_b_dst_data70;
wire   [7:0] sc2mac_dat_b_dst_data71;
wire   [7:0] sc2mac_dat_b_dst_data72;
wire   [7:0] sc2mac_dat_b_dst_data73;
wire   [7:0] sc2mac_dat_b_dst_data74;
wire   [7:0] sc2mac_dat_b_dst_data75;
wire   [7:0] sc2mac_dat_b_dst_data76;
wire   [7:0] sc2mac_dat_b_dst_data77;
wire   [7:0] sc2mac_dat_b_dst_data78;
wire   [7:0] sc2mac_dat_b_dst_data79;
wire   [7:0] sc2mac_dat_b_dst_data8;
wire   [7:0] sc2mac_dat_b_dst_data80;
wire   [7:0] sc2mac_dat_b_dst_data81;
wire   [7:0] sc2mac_dat_b_dst_data82;
wire   [7:0] sc2mac_dat_b_dst_data83;
wire   [7:0] sc2mac_dat_b_dst_data84;
wire   [7:0] sc2mac_dat_b_dst_data85;
wire   [7:0] sc2mac_dat_b_dst_data86;
wire   [7:0] sc2mac_dat_b_dst_data87;
wire   [7:0] sc2mac_dat_b_dst_data88;
wire   [7:0] sc2mac_dat_b_dst_data89;
wire   [7:0] sc2mac_dat_b_dst_data9;
wire   [7:0] sc2mac_dat_b_dst_data90;
wire   [7:0] sc2mac_dat_b_dst_data91;
wire   [7:0] sc2mac_dat_b_dst_data92;
wire   [7:0] sc2mac_dat_b_dst_data93;
wire   [7:0] sc2mac_dat_b_dst_data94;
wire   [7:0] sc2mac_dat_b_dst_data95;
wire   [7:0] sc2mac_dat_b_dst_data96;
wire   [7:0] sc2mac_dat_b_dst_data97;
wire   [7:0] sc2mac_dat_b_dst_data98;
wire   [7:0] sc2mac_dat_b_dst_data99;
wire [127:0] sc2mac_dat_b_dst_mask;
wire   [8:0] sc2mac_dat_b_dst_pd;
wire         sc2mac_dat_b_dst_pvld;
wire   [7:0] sc2mac_wt_a_dst_data0;
wire   [7:0] sc2mac_wt_a_dst_data1;
wire   [7:0] sc2mac_wt_a_dst_data10;
wire   [7:0] sc2mac_wt_a_dst_data100;
wire   [7:0] sc2mac_wt_a_dst_data101;
wire   [7:0] sc2mac_wt_a_dst_data102;
wire   [7:0] sc2mac_wt_a_dst_data103;
wire   [7:0] sc2mac_wt_a_dst_data104;
wire   [7:0] sc2mac_wt_a_dst_data105;
wire   [7:0] sc2mac_wt_a_dst_data106;
wire   [7:0] sc2mac_wt_a_dst_data107;
wire   [7:0] sc2mac_wt_a_dst_data108;
wire   [7:0] sc2mac_wt_a_dst_data109;
wire   [7:0] sc2mac_wt_a_dst_data11;
wire   [7:0] sc2mac_wt_a_dst_data110;
wire   [7:0] sc2mac_wt_a_dst_data111;
wire   [7:0] sc2mac_wt_a_dst_data112;
wire   [7:0] sc2mac_wt_a_dst_data113;
wire   [7:0] sc2mac_wt_a_dst_data114;
wire   [7:0] sc2mac_wt_a_dst_data115;
wire   [7:0] sc2mac_wt_a_dst_data116;
wire   [7:0] sc2mac_wt_a_dst_data117;
wire   [7:0] sc2mac_wt_a_dst_data118;
wire   [7:0] sc2mac_wt_a_dst_data119;
wire   [7:0] sc2mac_wt_a_dst_data12;
wire   [7:0] sc2mac_wt_a_dst_data120;
wire   [7:0] sc2mac_wt_a_dst_data121;
wire   [7:0] sc2mac_wt_a_dst_data122;
wire   [7:0] sc2mac_wt_a_dst_data123;
wire   [7:0] sc2mac_wt_a_dst_data124;
wire   [7:0] sc2mac_wt_a_dst_data125;
wire   [7:0] sc2mac_wt_a_dst_data126;
wire   [7:0] sc2mac_wt_a_dst_data127;
wire   [7:0] sc2mac_wt_a_dst_data13;
wire   [7:0] sc2mac_wt_a_dst_data14;
wire   [7:0] sc2mac_wt_a_dst_data15;
wire   [7:0] sc2mac_wt_a_dst_data16;
wire   [7:0] sc2mac_wt_a_dst_data17;
wire   [7:0] sc2mac_wt_a_dst_data18;
wire   [7:0] sc2mac_wt_a_dst_data19;
wire   [7:0] sc2mac_wt_a_dst_data2;
wire   [7:0] sc2mac_wt_a_dst_data20;
wire   [7:0] sc2mac_wt_a_dst_data21;
wire   [7:0] sc2mac_wt_a_dst_data22;
wire   [7:0] sc2mac_wt_a_dst_data23;
wire   [7:0] sc2mac_wt_a_dst_data24;
wire   [7:0] sc2mac_wt_a_dst_data25;
wire   [7:0] sc2mac_wt_a_dst_data26;
wire   [7:0] sc2mac_wt_a_dst_data27;
wire   [7:0] sc2mac_wt_a_dst_data28;
wire   [7:0] sc2mac_wt_a_dst_data29;
wire   [7:0] sc2mac_wt_a_dst_data3;
wire   [7:0] sc2mac_wt_a_dst_data30;
wire   [7:0] sc2mac_wt_a_dst_data31;
wire   [7:0] sc2mac_wt_a_dst_data32;
wire   [7:0] sc2mac_wt_a_dst_data33;
wire   [7:0] sc2mac_wt_a_dst_data34;
wire   [7:0] sc2mac_wt_a_dst_data35;
wire   [7:0] sc2mac_wt_a_dst_data36;
wire   [7:0] sc2mac_wt_a_dst_data37;
wire   [7:0] sc2mac_wt_a_dst_data38;
wire   [7:0] sc2mac_wt_a_dst_data39;
wire   [7:0] sc2mac_wt_a_dst_data4;
wire   [7:0] sc2mac_wt_a_dst_data40;
wire   [7:0] sc2mac_wt_a_dst_data41;
wire   [7:0] sc2mac_wt_a_dst_data42;
wire   [7:0] sc2mac_wt_a_dst_data43;
wire   [7:0] sc2mac_wt_a_dst_data44;
wire   [7:0] sc2mac_wt_a_dst_data45;
wire   [7:0] sc2mac_wt_a_dst_data46;
wire   [7:0] sc2mac_wt_a_dst_data47;
wire   [7:0] sc2mac_wt_a_dst_data48;
wire   [7:0] sc2mac_wt_a_dst_data49;
wire   [7:0] sc2mac_wt_a_dst_data5;
wire   [7:0] sc2mac_wt_a_dst_data50;
wire   [7:0] sc2mac_wt_a_dst_data51;
wire   [7:0] sc2mac_wt_a_dst_data52;
wire   [7:0] sc2mac_wt_a_dst_data53;
wire   [7:0] sc2mac_wt_a_dst_data54;
wire   [7:0] sc2mac_wt_a_dst_data55;
wire   [7:0] sc2mac_wt_a_dst_data56;
wire   [7:0] sc2mac_wt_a_dst_data57;
wire   [7:0] sc2mac_wt_a_dst_data58;
wire   [7:0] sc2mac_wt_a_dst_data59;
wire   [7:0] sc2mac_wt_a_dst_data6;
wire   [7:0] sc2mac_wt_a_dst_data60;
wire   [7:0] sc2mac_wt_a_dst_data61;
wire   [7:0] sc2mac_wt_a_dst_data62;
wire   [7:0] sc2mac_wt_a_dst_data63;
wire   [7:0] sc2mac_wt_a_dst_data64;
wire   [7:0] sc2mac_wt_a_dst_data65;
wire   [7:0] sc2mac_wt_a_dst_data66;
wire   [7:0] sc2mac_wt_a_dst_data67;
wire   [7:0] sc2mac_wt_a_dst_data68;
wire   [7:0] sc2mac_wt_a_dst_data69;
wire   [7:0] sc2mac_wt_a_dst_data7;
wire   [7:0] sc2mac_wt_a_dst_data70;
wire   [7:0] sc2mac_wt_a_dst_data71;
wire   [7:0] sc2mac_wt_a_dst_data72;
wire   [7:0] sc2mac_wt_a_dst_data73;
wire   [7:0] sc2mac_wt_a_dst_data74;
wire   [7:0] sc2mac_wt_a_dst_data75;
wire   [7:0] sc2mac_wt_a_dst_data76;
wire   [7:0] sc2mac_wt_a_dst_data77;
wire   [7:0] sc2mac_wt_a_dst_data78;
wire   [7:0] sc2mac_wt_a_dst_data79;
wire   [7:0] sc2mac_wt_a_dst_data8;
wire   [7:0] sc2mac_wt_a_dst_data80;
wire   [7:0] sc2mac_wt_a_dst_data81;
wire   [7:0] sc2mac_wt_a_dst_data82;
wire   [7:0] sc2mac_wt_a_dst_data83;
wire   [7:0] sc2mac_wt_a_dst_data84;
wire   [7:0] sc2mac_wt_a_dst_data85;
wire   [7:0] sc2mac_wt_a_dst_data86;
wire   [7:0] sc2mac_wt_a_dst_data87;
wire   [7:0] sc2mac_wt_a_dst_data88;
wire   [7:0] sc2mac_wt_a_dst_data89;
wire   [7:0] sc2mac_wt_a_dst_data9;
wire   [7:0] sc2mac_wt_a_dst_data90;
wire   [7:0] sc2mac_wt_a_dst_data91;
wire   [7:0] sc2mac_wt_a_dst_data92;
wire   [7:0] sc2mac_wt_a_dst_data93;
wire   [7:0] sc2mac_wt_a_dst_data94;
wire   [7:0] sc2mac_wt_a_dst_data95;
wire   [7:0] sc2mac_wt_a_dst_data96;
wire   [7:0] sc2mac_wt_a_dst_data97;
wire   [7:0] sc2mac_wt_a_dst_data98;
wire   [7:0] sc2mac_wt_a_dst_data99;
wire [127:0] sc2mac_wt_a_dst_mask;
wire         sc2mac_wt_a_dst_pvld;
wire   [7:0] sc2mac_wt_a_dst_sel;
wire   [7:0] sc2mac_wt_a_src_data0;
wire   [7:0] sc2mac_wt_a_src_data1;
wire   [7:0] sc2mac_wt_a_src_data10;
wire   [7:0] sc2mac_wt_a_src_data100;
wire   [7:0] sc2mac_wt_a_src_data101;
wire   [7:0] sc2mac_wt_a_src_data102;
wire   [7:0] sc2mac_wt_a_src_data103;
wire   [7:0] sc2mac_wt_a_src_data104;
wire   [7:0] sc2mac_wt_a_src_data105;
wire   [7:0] sc2mac_wt_a_src_data106;
wire   [7:0] sc2mac_wt_a_src_data107;
wire   [7:0] sc2mac_wt_a_src_data108;
wire   [7:0] sc2mac_wt_a_src_data109;
wire   [7:0] sc2mac_wt_a_src_data11;
wire   [7:0] sc2mac_wt_a_src_data110;
wire   [7:0] sc2mac_wt_a_src_data111;
wire   [7:0] sc2mac_wt_a_src_data112;
wire   [7:0] sc2mac_wt_a_src_data113;
wire   [7:0] sc2mac_wt_a_src_data114;
wire   [7:0] sc2mac_wt_a_src_data115;
wire   [7:0] sc2mac_wt_a_src_data116;
wire   [7:0] sc2mac_wt_a_src_data117;
wire   [7:0] sc2mac_wt_a_src_data118;
wire   [7:0] sc2mac_wt_a_src_data119;
wire   [7:0] sc2mac_wt_a_src_data12;
wire   [7:0] sc2mac_wt_a_src_data120;
wire   [7:0] sc2mac_wt_a_src_data121;
wire   [7:0] sc2mac_wt_a_src_data122;
wire   [7:0] sc2mac_wt_a_src_data123;
wire   [7:0] sc2mac_wt_a_src_data124;
wire   [7:0] sc2mac_wt_a_src_data125;
wire   [7:0] sc2mac_wt_a_src_data126;
wire   [7:0] sc2mac_wt_a_src_data127;
wire   [7:0] sc2mac_wt_a_src_data13;
wire   [7:0] sc2mac_wt_a_src_data14;
wire   [7:0] sc2mac_wt_a_src_data15;
wire   [7:0] sc2mac_wt_a_src_data16;
wire   [7:0] sc2mac_wt_a_src_data17;
wire   [7:0] sc2mac_wt_a_src_data18;
wire   [7:0] sc2mac_wt_a_src_data19;
wire   [7:0] sc2mac_wt_a_src_data2;
wire   [7:0] sc2mac_wt_a_src_data20;
wire   [7:0] sc2mac_wt_a_src_data21;
wire   [7:0] sc2mac_wt_a_src_data22;
wire   [7:0] sc2mac_wt_a_src_data23;
wire   [7:0] sc2mac_wt_a_src_data24;
wire   [7:0] sc2mac_wt_a_src_data25;
wire   [7:0] sc2mac_wt_a_src_data26;
wire   [7:0] sc2mac_wt_a_src_data27;
wire   [7:0] sc2mac_wt_a_src_data28;
wire   [7:0] sc2mac_wt_a_src_data29;
wire   [7:0] sc2mac_wt_a_src_data3;
wire   [7:0] sc2mac_wt_a_src_data30;
wire   [7:0] sc2mac_wt_a_src_data31;
wire   [7:0] sc2mac_wt_a_src_data32;
wire   [7:0] sc2mac_wt_a_src_data33;
wire   [7:0] sc2mac_wt_a_src_data34;
wire   [7:0] sc2mac_wt_a_src_data35;
wire   [7:0] sc2mac_wt_a_src_data36;
wire   [7:0] sc2mac_wt_a_src_data37;
wire   [7:0] sc2mac_wt_a_src_data38;
wire   [7:0] sc2mac_wt_a_src_data39;
wire   [7:0] sc2mac_wt_a_src_data4;
wire   [7:0] sc2mac_wt_a_src_data40;
wire   [7:0] sc2mac_wt_a_src_data41;
wire   [7:0] sc2mac_wt_a_src_data42;
wire   [7:0] sc2mac_wt_a_src_data43;
wire   [7:0] sc2mac_wt_a_src_data44;
wire   [7:0] sc2mac_wt_a_src_data45;
wire   [7:0] sc2mac_wt_a_src_data46;
wire   [7:0] sc2mac_wt_a_src_data47;
wire   [7:0] sc2mac_wt_a_src_data48;
wire   [7:0] sc2mac_wt_a_src_data49;
wire   [7:0] sc2mac_wt_a_src_data5;
wire   [7:0] sc2mac_wt_a_src_data50;
wire   [7:0] sc2mac_wt_a_src_data51;
wire   [7:0] sc2mac_wt_a_src_data52;
wire   [7:0] sc2mac_wt_a_src_data53;
wire   [7:0] sc2mac_wt_a_src_data54;
wire   [7:0] sc2mac_wt_a_src_data55;
wire   [7:0] sc2mac_wt_a_src_data56;
wire   [7:0] sc2mac_wt_a_src_data57;
wire   [7:0] sc2mac_wt_a_src_data58;
wire   [7:0] sc2mac_wt_a_src_data59;
wire   [7:0] sc2mac_wt_a_src_data6;
wire   [7:0] sc2mac_wt_a_src_data60;
wire   [7:0] sc2mac_wt_a_src_data61;
wire   [7:0] sc2mac_wt_a_src_data62;
wire   [7:0] sc2mac_wt_a_src_data63;
wire   [7:0] sc2mac_wt_a_src_data64;
wire   [7:0] sc2mac_wt_a_src_data65;
wire   [7:0] sc2mac_wt_a_src_data66;
wire   [7:0] sc2mac_wt_a_src_data67;
wire   [7:0] sc2mac_wt_a_src_data68;
wire   [7:0] sc2mac_wt_a_src_data69;
wire   [7:0] sc2mac_wt_a_src_data7;
wire   [7:0] sc2mac_wt_a_src_data70;
wire   [7:0] sc2mac_wt_a_src_data71;
wire   [7:0] sc2mac_wt_a_src_data72;
wire   [7:0] sc2mac_wt_a_src_data73;
wire   [7:0] sc2mac_wt_a_src_data74;
wire   [7:0] sc2mac_wt_a_src_data75;
wire   [7:0] sc2mac_wt_a_src_data76;
wire   [7:0] sc2mac_wt_a_src_data77;
wire   [7:0] sc2mac_wt_a_src_data78;
wire   [7:0] sc2mac_wt_a_src_data79;
wire   [7:0] sc2mac_wt_a_src_data8;
wire   [7:0] sc2mac_wt_a_src_data80;
wire   [7:0] sc2mac_wt_a_src_data81;
wire   [7:0] sc2mac_wt_a_src_data82;
wire   [7:0] sc2mac_wt_a_src_data83;
wire   [7:0] sc2mac_wt_a_src_data84;
wire   [7:0] sc2mac_wt_a_src_data85;
wire   [7:0] sc2mac_wt_a_src_data86;
wire   [7:0] sc2mac_wt_a_src_data87;
wire   [7:0] sc2mac_wt_a_src_data88;
wire   [7:0] sc2mac_wt_a_src_data89;
wire   [7:0] sc2mac_wt_a_src_data9;
wire   [7:0] sc2mac_wt_a_src_data90;
wire   [7:0] sc2mac_wt_a_src_data91;
wire   [7:0] sc2mac_wt_a_src_data92;
wire   [7:0] sc2mac_wt_a_src_data93;
wire   [7:0] sc2mac_wt_a_src_data94;
wire   [7:0] sc2mac_wt_a_src_data95;
wire   [7:0] sc2mac_wt_a_src_data96;
wire   [7:0] sc2mac_wt_a_src_data97;
wire   [7:0] sc2mac_wt_a_src_data98;
wire   [7:0] sc2mac_wt_a_src_data99;
wire [127:0] sc2mac_wt_a_src_mask;
wire         sc2mac_wt_a_src_pvld;
wire   [7:0] sc2mac_wt_a_src_sel;
wire   [7:0] sc2mac_wt_b_dst_data0;
wire   [7:0] sc2mac_wt_b_dst_data1;
wire   [7:0] sc2mac_wt_b_dst_data10;
wire   [7:0] sc2mac_wt_b_dst_data100;
wire   [7:0] sc2mac_wt_b_dst_data101;
wire   [7:0] sc2mac_wt_b_dst_data102;
wire   [7:0] sc2mac_wt_b_dst_data103;
wire   [7:0] sc2mac_wt_b_dst_data104;
wire   [7:0] sc2mac_wt_b_dst_data105;
wire   [7:0] sc2mac_wt_b_dst_data106;
wire   [7:0] sc2mac_wt_b_dst_data107;
wire   [7:0] sc2mac_wt_b_dst_data108;
wire   [7:0] sc2mac_wt_b_dst_data109;
wire   [7:0] sc2mac_wt_b_dst_data11;
wire   [7:0] sc2mac_wt_b_dst_data110;
wire   [7:0] sc2mac_wt_b_dst_data111;
wire   [7:0] sc2mac_wt_b_dst_data112;
wire   [7:0] sc2mac_wt_b_dst_data113;
wire   [7:0] sc2mac_wt_b_dst_data114;
wire   [7:0] sc2mac_wt_b_dst_data115;
wire   [7:0] sc2mac_wt_b_dst_data116;
wire   [7:0] sc2mac_wt_b_dst_data117;
wire   [7:0] sc2mac_wt_b_dst_data118;
wire   [7:0] sc2mac_wt_b_dst_data119;
wire   [7:0] sc2mac_wt_b_dst_data12;
wire   [7:0] sc2mac_wt_b_dst_data120;
wire   [7:0] sc2mac_wt_b_dst_data121;
wire   [7:0] sc2mac_wt_b_dst_data122;
wire   [7:0] sc2mac_wt_b_dst_data123;
wire   [7:0] sc2mac_wt_b_dst_data124;
wire   [7:0] sc2mac_wt_b_dst_data125;
wire   [7:0] sc2mac_wt_b_dst_data126;
wire   [7:0] sc2mac_wt_b_dst_data127;
wire   [7:0] sc2mac_wt_b_dst_data13;
wire   [7:0] sc2mac_wt_b_dst_data14;
wire   [7:0] sc2mac_wt_b_dst_data15;
wire   [7:0] sc2mac_wt_b_dst_data16;
wire   [7:0] sc2mac_wt_b_dst_data17;
wire   [7:0] sc2mac_wt_b_dst_data18;
wire   [7:0] sc2mac_wt_b_dst_data19;
wire   [7:0] sc2mac_wt_b_dst_data2;
wire   [7:0] sc2mac_wt_b_dst_data20;
wire   [7:0] sc2mac_wt_b_dst_data21;
wire   [7:0] sc2mac_wt_b_dst_data22;
wire   [7:0] sc2mac_wt_b_dst_data23;
wire   [7:0] sc2mac_wt_b_dst_data24;
wire   [7:0] sc2mac_wt_b_dst_data25;
wire   [7:0] sc2mac_wt_b_dst_data26;
wire   [7:0] sc2mac_wt_b_dst_data27;
wire   [7:0] sc2mac_wt_b_dst_data28;
wire   [7:0] sc2mac_wt_b_dst_data29;
wire   [7:0] sc2mac_wt_b_dst_data3;
wire   [7:0] sc2mac_wt_b_dst_data30;
wire   [7:0] sc2mac_wt_b_dst_data31;
wire   [7:0] sc2mac_wt_b_dst_data32;
wire   [7:0] sc2mac_wt_b_dst_data33;
wire   [7:0] sc2mac_wt_b_dst_data34;
wire   [7:0] sc2mac_wt_b_dst_data35;
wire   [7:0] sc2mac_wt_b_dst_data36;
wire   [7:0] sc2mac_wt_b_dst_data37;
wire   [7:0] sc2mac_wt_b_dst_data38;
wire   [7:0] sc2mac_wt_b_dst_data39;
wire   [7:0] sc2mac_wt_b_dst_data4;
wire   [7:0] sc2mac_wt_b_dst_data40;
wire   [7:0] sc2mac_wt_b_dst_data41;
wire   [7:0] sc2mac_wt_b_dst_data42;
wire   [7:0] sc2mac_wt_b_dst_data43;
wire   [7:0] sc2mac_wt_b_dst_data44;
wire   [7:0] sc2mac_wt_b_dst_data45;
wire   [7:0] sc2mac_wt_b_dst_data46;
wire   [7:0] sc2mac_wt_b_dst_data47;
wire   [7:0] sc2mac_wt_b_dst_data48;
wire   [7:0] sc2mac_wt_b_dst_data49;
wire   [7:0] sc2mac_wt_b_dst_data5;
wire   [7:0] sc2mac_wt_b_dst_data50;
wire   [7:0] sc2mac_wt_b_dst_data51;
wire   [7:0] sc2mac_wt_b_dst_data52;
wire   [7:0] sc2mac_wt_b_dst_data53;
wire   [7:0] sc2mac_wt_b_dst_data54;
wire   [7:0] sc2mac_wt_b_dst_data55;
wire   [7:0] sc2mac_wt_b_dst_data56;
wire   [7:0] sc2mac_wt_b_dst_data57;
wire   [7:0] sc2mac_wt_b_dst_data58;
wire   [7:0] sc2mac_wt_b_dst_data59;
wire   [7:0] sc2mac_wt_b_dst_data6;
wire   [7:0] sc2mac_wt_b_dst_data60;
wire   [7:0] sc2mac_wt_b_dst_data61;
wire   [7:0] sc2mac_wt_b_dst_data62;
wire   [7:0] sc2mac_wt_b_dst_data63;
wire   [7:0] sc2mac_wt_b_dst_data64;
wire   [7:0] sc2mac_wt_b_dst_data65;
wire   [7:0] sc2mac_wt_b_dst_data66;
wire   [7:0] sc2mac_wt_b_dst_data67;
wire   [7:0] sc2mac_wt_b_dst_data68;
wire   [7:0] sc2mac_wt_b_dst_data69;
wire   [7:0] sc2mac_wt_b_dst_data7;
wire   [7:0] sc2mac_wt_b_dst_data70;
wire   [7:0] sc2mac_wt_b_dst_data71;
wire   [7:0] sc2mac_wt_b_dst_data72;
wire   [7:0] sc2mac_wt_b_dst_data73;
wire   [7:0] sc2mac_wt_b_dst_data74;
wire   [7:0] sc2mac_wt_b_dst_data75;
wire   [7:0] sc2mac_wt_b_dst_data76;
wire   [7:0] sc2mac_wt_b_dst_data77;
wire   [7:0] sc2mac_wt_b_dst_data78;
wire   [7:0] sc2mac_wt_b_dst_data79;
wire   [7:0] sc2mac_wt_b_dst_data8;
wire   [7:0] sc2mac_wt_b_dst_data80;
wire   [7:0] sc2mac_wt_b_dst_data81;
wire   [7:0] sc2mac_wt_b_dst_data82;
wire   [7:0] sc2mac_wt_b_dst_data83;
wire   [7:0] sc2mac_wt_b_dst_data84;
wire   [7:0] sc2mac_wt_b_dst_data85;
wire   [7:0] sc2mac_wt_b_dst_data86;
wire   [7:0] sc2mac_wt_b_dst_data87;
wire   [7:0] sc2mac_wt_b_dst_data88;
wire   [7:0] sc2mac_wt_b_dst_data89;
wire   [7:0] sc2mac_wt_b_dst_data9;
wire   [7:0] sc2mac_wt_b_dst_data90;
wire   [7:0] sc2mac_wt_b_dst_data91;
wire   [7:0] sc2mac_wt_b_dst_data92;
wire   [7:0] sc2mac_wt_b_dst_data93;
wire   [7:0] sc2mac_wt_b_dst_data94;
wire   [7:0] sc2mac_wt_b_dst_data95;
wire   [7:0] sc2mac_wt_b_dst_data96;
wire   [7:0] sc2mac_wt_b_dst_data97;
wire   [7:0] sc2mac_wt_b_dst_data98;
wire   [7:0] sc2mac_wt_b_dst_data99;
wire [127:0] sc2mac_wt_b_dst_mask;
wire         sc2mac_wt_b_dst_pvld;
wire   [7:0] sc2mac_wt_b_dst_sel;
wire  [33:0] sdp2csb_resp_pd;
wire         sdp2csb_resp_valid;
wire         sdp2cvif_rd_cdt_lat_fifo_pop;
wire  [78:0] sdp2cvif_rd_req_pd;
wire         sdp2cvif_rd_req_ready;
wire         sdp2cvif_rd_req_valid;
wire [514:0] sdp2cvif_wr_req_pd;
wire         sdp2cvif_wr_req_ready;
wire         sdp2cvif_wr_req_valid;
wire   [1:0] sdp2glb_done_intr_pd;
wire         sdp2mcif_rd_cdt_lat_fifo_pop;
wire  [78:0] sdp2mcif_rd_req_pd;
wire         sdp2mcif_rd_req_ready;
wire         sdp2mcif_rd_req_valid;
wire [514:0] sdp2mcif_wr_req_pd;
wire         sdp2mcif_wr_req_ready;
wire         sdp2mcif_wr_req_valid;
wire [255:0] sdp2pdp_pd;
wire         sdp2pdp_ready;
wire         sdp2pdp_valid;
wire         sdp_b2cvif_rd_cdt_lat_fifo_pop;
wire  [78:0] sdp_b2cvif_rd_req_pd;
wire         sdp_b2cvif_rd_req_ready;
wire         sdp_b2cvif_rd_req_valid;
wire         sdp_b2mcif_rd_cdt_lat_fifo_pop;
wire  [78:0] sdp_b2mcif_rd_req_pd;
wire         sdp_b2mcif_rd_req_ready;
wire         sdp_b2mcif_rd_req_valid;
wire         sdp_e2cvif_rd_cdt_lat_fifo_pop;
wire  [78:0] sdp_e2cvif_rd_req_pd;
wire         sdp_e2cvif_rd_req_ready;
wire         sdp_e2cvif_rd_req_valid;
wire         sdp_e2mcif_rd_cdt_lat_fifo_pop;
wire  [78:0] sdp_e2mcif_rd_req_pd;
wire         sdp_e2mcif_rd_req_ready;
wire         sdp_e2mcif_rd_req_valid;
wire         sdp_n2cvif_rd_cdt_lat_fifo_pop;
wire  [78:0] sdp_n2cvif_rd_req_pd;
wire         sdp_n2cvif_rd_req_ready;
wire         sdp_n2cvif_rd_req_valid;
wire         sdp_n2mcif_rd_cdt_lat_fifo_pop;
wire  [78:0] sdp_n2mcif_rd_req_pd;
wire         sdp_n2mcif_rd_req_ready;
wire         sdp_n2mcif_rd_req_valid;
wire  [33:0] sdp_rdma2csb_resp_pd;
wire         sdp_rdma2csb_resp_valid;

//

//&Forget dangle csb2afbif_pvld;
//&Forget dangle csb2afbif_pd;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O                                                 //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_o u_partition_o (
   .test_mode                      (test_mode)                         //|< i
  ,.direct_reset_                  (direct_reset_)                     //|< i
  ,.global_clk_ovr_on              (global_clk_ovr_on)                 //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     //|< i
  ,.cacc2csb_resp_dst_valid        (cacc2csb_resp_dst_valid)           //|< w
  ,.cacc2csb_resp_dst_pd           (cacc2csb_resp_dst_pd[33:0])        //|< w
  ,.cacc2glb_done_intr_dst_pd      (cacc2glb_done_intr_dst_pd[1:0])    //|< w
  ,.cdma2csb_resp_valid            (cdma2csb_resp_valid)               //|< w
  ,.cdma2csb_resp_pd               (cdma2csb_resp_pd[33:0])            //|< w
  ,.cdma_dat2cvif_rd_req_valid     (cdma_dat2cvif_rd_req_valid)        //|< w
  ,.cdma_dat2cvif_rd_req_ready     (cdma_dat2cvif_rd_req_ready)        //|> w
  ,.cdma_dat2cvif_rd_req_pd        (cdma_dat2cvif_rd_req_pd[78:0])     //|< w
  ,.cdma_dat2glb_done_intr_pd      (cdma_dat2glb_done_intr_pd[1:0])    //|< w
  ,.cdma_dat2mcif_rd_req_valid     (cdma_dat2mcif_rd_req_valid)        //|< w
  ,.cdma_dat2mcif_rd_req_ready     (cdma_dat2mcif_rd_req_ready)        //|> w
  ,.cdma_dat2mcif_rd_req_pd        (cdma_dat2mcif_rd_req_pd[78:0])     //|< w
  ,.cdma_wt2cvif_rd_req_valid      (cdma_wt2cvif_rd_req_valid)         //|< w
  ,.cdma_wt2cvif_rd_req_ready      (cdma_wt2cvif_rd_req_ready)         //|> w
  ,.cdma_wt2cvif_rd_req_pd         (cdma_wt2cvif_rd_req_pd[78:0])      //|< w
  ,.cdma_wt2glb_done_intr_pd       (cdma_wt2glb_done_intr_pd[1:0])     //|< w
  ,.cdma_wt2mcif_rd_req_valid      (cdma_wt2mcif_rd_req_valid)         //|< w
  ,.cdma_wt2mcif_rd_req_ready      (cdma_wt2mcif_rd_req_ready)         //|> w
  ,.cdma_wt2mcif_rd_req_pd         (cdma_wt2mcif_rd_req_pd[78:0])      //|< w
  ,.cmac_a2csb_resp_src_valid      (cmac_a2csb_resp_src_valid)         //|< w
  ,.cmac_a2csb_resp_src_pd         (cmac_a2csb_resp_src_pd[33:0])      //|< w
  ,.cmac_b2csb_resp_dst_valid      (cmac_b2csb_resp_dst_valid)         //|< w
  ,.cmac_b2csb_resp_dst_pd         (cmac_b2csb_resp_dst_pd[33:0])      //|< w
  ,.csb2cacc_req_src_pvld          (csb2cacc_req_src_pvld)             //|> w
  ,.csb2cacc_req_src_prdy          (csb2cacc_req_src_prdy)             //|< w
  ,.csb2cacc_req_src_pd            (csb2cacc_req_src_pd[62:0])         //|> w
  ,.csb2cdma_req_pvld              (csb2cdma_req_pvld)                 //|> w
  ,.csb2cdma_req_prdy              (csb2cdma_req_prdy)                 //|< w
  ,.csb2cdma_req_pd                (csb2cdma_req_pd[62:0])             //|> w
  ,.csb2cmac_a_req_dst_pvld        (csb2cmac_a_req_dst_pvld)           //|> w
  ,.csb2cmac_a_req_dst_prdy        (csb2cmac_a_req_dst_prdy)           //|< w
  ,.csb2cmac_a_req_dst_pd          (csb2cmac_a_req_dst_pd[62:0])       //|> w
  ,.csb2cmac_b_req_src_pvld        (csb2cmac_b_req_src_pvld)           //|> w
  ,.csb2cmac_b_req_src_prdy        (csb2cmac_b_req_src_prdy)           //|< w
  ,.csb2cmac_b_req_src_pd          (csb2cmac_b_req_src_pd[62:0])       //|> w
  ,.csb2csc_req_pvld               (csb2csc_req_pvld)                  //|> w
  ,.csb2csc_req_prdy               (csb2csc_req_prdy)                  //|< w
  ,.csb2csc_req_pd                 (csb2csc_req_pd[62:0])              //|> w
  ,.csb2nvdla_valid                (csb2nvdla_valid)                   //|< i
  ,.csb2nvdla_ready                (csb2nvdla_ready)                   //|> o
  ,.csb2nvdla_addr                 (csb2nvdla_addr[15:0])              //|< i
  ,.csb2nvdla_wdat                 (csb2nvdla_wdat[31:0])              //|< i
  ,.csb2nvdla_write                (csb2nvdla_write)                   //|< i
  ,.csb2nvdla_nposted              (csb2nvdla_nposted)                 //|< i
  ,.csb2sdp_rdma_req_pvld          (csb2sdp_rdma_req_pvld)             //|> w
  ,.csb2sdp_rdma_req_prdy          (csb2sdp_rdma_req_prdy)             //|< w
  ,.csb2sdp_rdma_req_pd            (csb2sdp_rdma_req_pd[62:0])         //|> w
  ,.csb2sdp_req_pvld               (csb2sdp_req_pvld)                  //|> w
  ,.csb2sdp_req_prdy               (csb2sdp_req_prdy)                  //|< w
  ,.csb2sdp_req_pd                 (csb2sdp_req_pd[62:0])              //|> w
  ,.csc2csb_resp_valid             (csc2csb_resp_valid)                //|< w
  ,.csc2csb_resp_pd                (csc2csb_resp_pd[33:0])             //|< w
  ,.cvif2cdma_dat_rd_rsp_valid     (cvif2cdma_dat_rd_rsp_valid)        //|> w
  ,.cvif2cdma_dat_rd_rsp_ready     (cvif2cdma_dat_rd_rsp_ready)        //|< w
  ,.cvif2cdma_dat_rd_rsp_pd        (cvif2cdma_dat_rd_rsp_pd[513:0])    //|> w
  ,.cvif2cdma_wt_rd_rsp_valid      (cvif2cdma_wt_rd_rsp_valid)         //|> w
  ,.cvif2cdma_wt_rd_rsp_ready      (cvif2cdma_wt_rd_rsp_ready)         //|< w
  ,.cvif2cdma_wt_rd_rsp_pd         (cvif2cdma_wt_rd_rsp_pd[513:0])     //|> w
  ,.cvif2noc_axi_ar_arvalid        (nvdla_core2cvsram_ar_arvalid)      //|> o
  ,.cvif2noc_axi_ar_arready        (nvdla_core2cvsram_ar_arready)      //|< i
  ,.cvif2noc_axi_ar_arid           (nvdla_core2cvsram_ar_arid[7:0])    //|> o
  ,.cvif2noc_axi_ar_arlen          (nvdla_core2cvsram_ar_arlen[3:0])   //|> o
  ,.cvif2noc_axi_ar_araddr         (nvdla_core2cvsram_ar_araddr[63:0]) //|> o
  ,.cvif2noc_axi_aw_awvalid        (nvdla_core2cvsram_aw_awvalid)      //|> o
  ,.cvif2noc_axi_aw_awready        (nvdla_core2cvsram_aw_awready)      //|< i
  ,.cvif2noc_axi_aw_awid           (nvdla_core2cvsram_aw_awid[7:0])    //|> o
  ,.cvif2noc_axi_aw_awlen          (nvdla_core2cvsram_aw_awlen[3:0])   //|> o
  ,.cvif2noc_axi_aw_awaddr         (nvdla_core2cvsram_aw_awaddr[63:0]) //|> o
  ,.cvif2noc_axi_w_wvalid          (nvdla_core2cvsram_w_wvalid)        //|> o
  ,.cvif2noc_axi_w_wready          (nvdla_core2cvsram_w_wready)        //|< i
  ,.cvif2noc_axi_w_wdata           (nvdla_core2cvsram_w_wdata[511:0])  //|> o
  ,.cvif2noc_axi_w_wstrb           (nvdla_core2cvsram_w_wstrb[63:0])   //|> o
  ,.cvif2noc_axi_w_wlast           (nvdla_core2cvsram_w_wlast)         //|> o
  ,.cvif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)           //|> w
  ,.cvif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)           //|< w
  ,.cvif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd[513:0])       //|> w
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)           //|> w
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)           //|< w
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd[513:0])       //|> w
  ,.cvif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)           //|> w
  ,.cvif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)           //|< w
  ,.cvif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd[513:0])       //|> w
  ,.cvif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)             //|> w
  ,.cvif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)             //|< w
  ,.cvif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd[513:0])         //|> w
  ,.cvif2sdp_wr_rsp_complete       (cvif2sdp_wr_rsp_complete)          //|> w
  ,.mcif2cdma_dat_rd_rsp_valid     (mcif2cdma_dat_rd_rsp_valid)        //|> w
  ,.mcif2cdma_dat_rd_rsp_ready     (mcif2cdma_dat_rd_rsp_ready)        //|< w
  ,.mcif2cdma_dat_rd_rsp_pd        (mcif2cdma_dat_rd_rsp_pd[513:0])    //|> w
  ,.mcif2cdma_wt_rd_rsp_valid      (mcif2cdma_wt_rd_rsp_valid)         //|> w
  ,.mcif2cdma_wt_rd_rsp_ready      (mcif2cdma_wt_rd_rsp_ready)         //|< w
  ,.mcif2cdma_wt_rd_rsp_pd         (mcif2cdma_wt_rd_rsp_pd[513:0])     //|> w
  ,.mcif2noc_axi_ar_arvalid        (nvdla_core2dbb_ar_arvalid)         //|> o
  ,.mcif2noc_axi_ar_arready        (nvdla_core2dbb_ar_arready)         //|< i
  ,.mcif2noc_axi_ar_arid           (nvdla_core2dbb_ar_arid[7:0])       //|> o
  ,.mcif2noc_axi_ar_arlen          (nvdla_core2dbb_ar_arlen[3:0])      //|> o
  ,.mcif2noc_axi_ar_araddr         (nvdla_core2dbb_ar_araddr[63:0])    //|> o
  ,.mcif2noc_axi_aw_awvalid        (nvdla_core2dbb_aw_awvalid)         //|> o
  ,.mcif2noc_axi_aw_awready        (nvdla_core2dbb_aw_awready)         //|< i
  ,.mcif2noc_axi_aw_awid           (nvdla_core2dbb_aw_awid[7:0])       //|> o
  ,.mcif2noc_axi_aw_awlen          (nvdla_core2dbb_aw_awlen[3:0])      //|> o
  ,.mcif2noc_axi_aw_awaddr         (nvdla_core2dbb_aw_awaddr[63:0])    //|> o
  ,.mcif2noc_axi_w_wvalid          (nvdla_core2dbb_w_wvalid)           //|> o
  ,.mcif2noc_axi_w_wready          (nvdla_core2dbb_w_wready)           //|< i
  ,.mcif2noc_axi_w_wdata           (nvdla_core2dbb_w_wdata[511:0])     //|> o
  ,.mcif2noc_axi_w_wstrb           (nvdla_core2dbb_w_wstrb[63:0])      //|> o
  ,.mcif2noc_axi_w_wlast           (nvdla_core2dbb_w_wlast)            //|> o
  ,.mcif2sdp_b_rd_rsp_valid        (mcif2sdp_b_rd_rsp_valid)           //|> w
  ,.mcif2sdp_b_rd_rsp_ready        (mcif2sdp_b_rd_rsp_ready)           //|< w
  ,.mcif2sdp_b_rd_rsp_pd           (mcif2sdp_b_rd_rsp_pd[513:0])       //|> w
  ,.mcif2sdp_e_rd_rsp_valid        (mcif2sdp_e_rd_rsp_valid)           //|> w
  ,.mcif2sdp_e_rd_rsp_ready        (mcif2sdp_e_rd_rsp_ready)           //|< w
  ,.mcif2sdp_e_rd_rsp_pd           (mcif2sdp_e_rd_rsp_pd[513:0])       //|> w
  ,.mcif2sdp_n_rd_rsp_valid        (mcif2sdp_n_rd_rsp_valid)           //|> w
  ,.mcif2sdp_n_rd_rsp_ready        (mcif2sdp_n_rd_rsp_ready)           //|< w
  ,.mcif2sdp_n_rd_rsp_pd           (mcif2sdp_n_rd_rsp_pd[513:0])       //|> w
  ,.mcif2sdp_rd_rsp_valid          (mcif2sdp_rd_rsp_valid)             //|> w
  ,.mcif2sdp_rd_rsp_ready          (mcif2sdp_rd_rsp_ready)             //|< w
  ,.mcif2sdp_rd_rsp_pd             (mcif2sdp_rd_rsp_pd[513:0])         //|> w
  ,.mcif2sdp_wr_rsp_complete       (mcif2sdp_wr_rsp_complete)          //|> w
  ,.noc2cvif_axi_b_bvalid          (nvdla_core2cvsram_b_bvalid)        //|< i
  ,.noc2cvif_axi_b_bready          (nvdla_core2cvsram_b_bready)        //|> o
  ,.noc2cvif_axi_b_bid             (nvdla_core2cvsram_b_bid[7:0])      //|< i
  ,.noc2cvif_axi_r_rvalid          (nvdla_core2cvsram_r_rvalid)        //|< i
  ,.noc2cvif_axi_r_rready          (nvdla_core2cvsram_r_rready)        //|> o
  ,.noc2cvif_axi_r_rid             (nvdla_core2cvsram_r_rid[7:0])      //|< i
  ,.noc2cvif_axi_r_rlast           (nvdla_core2cvsram_r_rlast)         //|< i
  ,.noc2cvif_axi_r_rdata           (nvdla_core2cvsram_r_rdata[511:0])  //|< i
  ,.noc2mcif_axi_b_bvalid          (nvdla_core2dbb_b_bvalid)           //|< i
  ,.noc2mcif_axi_b_bready          (nvdla_core2dbb_b_bready)           //|> o
  ,.noc2mcif_axi_b_bid             (nvdla_core2dbb_b_bid[7:0])         //|< i
  ,.noc2mcif_axi_r_rvalid          (nvdla_core2dbb_r_rvalid)           //|< i
  ,.noc2mcif_axi_r_rready          (nvdla_core2dbb_r_rready)           //|> o
  ,.noc2mcif_axi_r_rid             (nvdla_core2dbb_r_rid[7:0])         //|< i
  ,.noc2mcif_axi_r_rlast           (nvdla_core2dbb_r_rlast)            //|< i
  ,.noc2mcif_axi_r_rdata           (nvdla_core2dbb_r_rdata[511:0])     //|< i
  ,.nvdla2csb_valid                (nvdla2csb_valid)                   //|> o
  ,.nvdla2csb_data                 (nvdla2csb_data[31:0])              //|> o
  ,.nvdla2csb_wr_complete          (nvdla2csb_wr_complete)             //|> o
  ,.core_intr                      (dla_intr)                          //|> o
  ,.pwrbus_ram_pd                  (nvdla_pwrbus_ram_o_pd[31:0])       //|< i
  ,.sc2mac_dat_a_dst_pvld          (sc2mac_dat_a_dst_pvld)             //|> w
  ,.sc2mac_dat_a_dst_mask          (sc2mac_dat_a_dst_mask[127:0])      //|> w
  ,.sc2mac_dat_a_dst_data0         (sc2mac_dat_a_dst_data0[7:0])       //|> w
  ,.sc2mac_dat_a_dst_data1         (sc2mac_dat_a_dst_data1[7:0])       //|> w
  ,.sc2mac_dat_a_dst_data2         (sc2mac_dat_a_dst_data2[7:0])       //|> w
  ,.sc2mac_dat_a_dst_data3         (sc2mac_dat_a_dst_data3[7:0])       //|> w
  ,.sc2mac_dat_a_dst_data4         (sc2mac_dat_a_dst_data4[7:0])       //|> w
  ,.sc2mac_dat_a_dst_data5         (sc2mac_dat_a_dst_data5[7:0])       //|> w
  ,.sc2mac_dat_a_dst_data6         (sc2mac_dat_a_dst_data6[7:0])       //|> w
  ,.sc2mac_dat_a_dst_data7         (sc2mac_dat_a_dst_data7[7:0])       //|> w
  ,.sc2mac_dat_a_dst_data8         (sc2mac_dat_a_dst_data8[7:0])       //|> w
  ,.sc2mac_dat_a_dst_data9         (sc2mac_dat_a_dst_data9[7:0])       //|> w
  ,.sc2mac_dat_a_dst_data10        (sc2mac_dat_a_dst_data10[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data11        (sc2mac_dat_a_dst_data11[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data12        (sc2mac_dat_a_dst_data12[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data13        (sc2mac_dat_a_dst_data13[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data14        (sc2mac_dat_a_dst_data14[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data15        (sc2mac_dat_a_dst_data15[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data16        (sc2mac_dat_a_dst_data16[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data17        (sc2mac_dat_a_dst_data17[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data18        (sc2mac_dat_a_dst_data18[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data19        (sc2mac_dat_a_dst_data19[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data20        (sc2mac_dat_a_dst_data20[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data21        (sc2mac_dat_a_dst_data21[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data22        (sc2mac_dat_a_dst_data22[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data23        (sc2mac_dat_a_dst_data23[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data24        (sc2mac_dat_a_dst_data24[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data25        (sc2mac_dat_a_dst_data25[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data26        (sc2mac_dat_a_dst_data26[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data27        (sc2mac_dat_a_dst_data27[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data28        (sc2mac_dat_a_dst_data28[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data29        (sc2mac_dat_a_dst_data29[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data30        (sc2mac_dat_a_dst_data30[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data31        (sc2mac_dat_a_dst_data31[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data32        (sc2mac_dat_a_dst_data32[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data33        (sc2mac_dat_a_dst_data33[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data34        (sc2mac_dat_a_dst_data34[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data35        (sc2mac_dat_a_dst_data35[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data36        (sc2mac_dat_a_dst_data36[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data37        (sc2mac_dat_a_dst_data37[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data38        (sc2mac_dat_a_dst_data38[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data39        (sc2mac_dat_a_dst_data39[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data40        (sc2mac_dat_a_dst_data40[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data41        (sc2mac_dat_a_dst_data41[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data42        (sc2mac_dat_a_dst_data42[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data43        (sc2mac_dat_a_dst_data43[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data44        (sc2mac_dat_a_dst_data44[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data45        (sc2mac_dat_a_dst_data45[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data46        (sc2mac_dat_a_dst_data46[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data47        (sc2mac_dat_a_dst_data47[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data48        (sc2mac_dat_a_dst_data48[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data49        (sc2mac_dat_a_dst_data49[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data50        (sc2mac_dat_a_dst_data50[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data51        (sc2mac_dat_a_dst_data51[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data52        (sc2mac_dat_a_dst_data52[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data53        (sc2mac_dat_a_dst_data53[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data54        (sc2mac_dat_a_dst_data54[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data55        (sc2mac_dat_a_dst_data55[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data56        (sc2mac_dat_a_dst_data56[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data57        (sc2mac_dat_a_dst_data57[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data58        (sc2mac_dat_a_dst_data58[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data59        (sc2mac_dat_a_dst_data59[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data60        (sc2mac_dat_a_dst_data60[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data61        (sc2mac_dat_a_dst_data61[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data62        (sc2mac_dat_a_dst_data62[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data63        (sc2mac_dat_a_dst_data63[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data64        (sc2mac_dat_a_dst_data64[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data65        (sc2mac_dat_a_dst_data65[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data66        (sc2mac_dat_a_dst_data66[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data67        (sc2mac_dat_a_dst_data67[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data68        (sc2mac_dat_a_dst_data68[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data69        (sc2mac_dat_a_dst_data69[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data70        (sc2mac_dat_a_dst_data70[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data71        (sc2mac_dat_a_dst_data71[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data72        (sc2mac_dat_a_dst_data72[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data73        (sc2mac_dat_a_dst_data73[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data74        (sc2mac_dat_a_dst_data74[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data75        (sc2mac_dat_a_dst_data75[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data76        (sc2mac_dat_a_dst_data76[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data77        (sc2mac_dat_a_dst_data77[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data78        (sc2mac_dat_a_dst_data78[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data79        (sc2mac_dat_a_dst_data79[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data80        (sc2mac_dat_a_dst_data80[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data81        (sc2mac_dat_a_dst_data81[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data82        (sc2mac_dat_a_dst_data82[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data83        (sc2mac_dat_a_dst_data83[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data84        (sc2mac_dat_a_dst_data84[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data85        (sc2mac_dat_a_dst_data85[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data86        (sc2mac_dat_a_dst_data86[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data87        (sc2mac_dat_a_dst_data87[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data88        (sc2mac_dat_a_dst_data88[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data89        (sc2mac_dat_a_dst_data89[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data90        (sc2mac_dat_a_dst_data90[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data91        (sc2mac_dat_a_dst_data91[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data92        (sc2mac_dat_a_dst_data92[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data93        (sc2mac_dat_a_dst_data93[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data94        (sc2mac_dat_a_dst_data94[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data95        (sc2mac_dat_a_dst_data95[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data96        (sc2mac_dat_a_dst_data96[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data97        (sc2mac_dat_a_dst_data97[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data98        (sc2mac_dat_a_dst_data98[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data99        (sc2mac_dat_a_dst_data99[7:0])      //|> w
  ,.sc2mac_dat_a_dst_data100       (sc2mac_dat_a_dst_data100[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data101       (sc2mac_dat_a_dst_data101[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data102       (sc2mac_dat_a_dst_data102[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data103       (sc2mac_dat_a_dst_data103[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data104       (sc2mac_dat_a_dst_data104[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data105       (sc2mac_dat_a_dst_data105[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data106       (sc2mac_dat_a_dst_data106[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data107       (sc2mac_dat_a_dst_data107[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data108       (sc2mac_dat_a_dst_data108[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data109       (sc2mac_dat_a_dst_data109[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data110       (sc2mac_dat_a_dst_data110[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data111       (sc2mac_dat_a_dst_data111[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data112       (sc2mac_dat_a_dst_data112[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data113       (sc2mac_dat_a_dst_data113[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data114       (sc2mac_dat_a_dst_data114[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data115       (sc2mac_dat_a_dst_data115[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data116       (sc2mac_dat_a_dst_data116[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data117       (sc2mac_dat_a_dst_data117[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data118       (sc2mac_dat_a_dst_data118[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data119       (sc2mac_dat_a_dst_data119[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data120       (sc2mac_dat_a_dst_data120[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data121       (sc2mac_dat_a_dst_data121[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data122       (sc2mac_dat_a_dst_data122[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data123       (sc2mac_dat_a_dst_data123[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data124       (sc2mac_dat_a_dst_data124[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data125       (sc2mac_dat_a_dst_data125[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data126       (sc2mac_dat_a_dst_data126[7:0])     //|> w
  ,.sc2mac_dat_a_dst_data127       (sc2mac_dat_a_dst_data127[7:0])     //|> w
  ,.sc2mac_dat_a_dst_pd            (sc2mac_dat_a_dst_pd[8:0])          //|> w
  ,.sc2mac_dat_a_src_pvld          (sc2mac_dat_a_src_pvld)             //|< w
  ,.sc2mac_dat_a_src_mask          (sc2mac_dat_a_src_mask[127:0])      //|< w
  ,.sc2mac_dat_a_src_data0         (sc2mac_dat_a_src_data0[7:0])       //|< w
  ,.sc2mac_dat_a_src_data1         (sc2mac_dat_a_src_data1[7:0])       //|< w
  ,.sc2mac_dat_a_src_data2         (sc2mac_dat_a_src_data2[7:0])       //|< w
  ,.sc2mac_dat_a_src_data3         (sc2mac_dat_a_src_data3[7:0])       //|< w
  ,.sc2mac_dat_a_src_data4         (sc2mac_dat_a_src_data4[7:0])       //|< w
  ,.sc2mac_dat_a_src_data5         (sc2mac_dat_a_src_data5[7:0])       //|< w
  ,.sc2mac_dat_a_src_data6         (sc2mac_dat_a_src_data6[7:0])       //|< w
  ,.sc2mac_dat_a_src_data7         (sc2mac_dat_a_src_data7[7:0])       //|< w
  ,.sc2mac_dat_a_src_data8         (sc2mac_dat_a_src_data8[7:0])       //|< w
  ,.sc2mac_dat_a_src_data9         (sc2mac_dat_a_src_data9[7:0])       //|< w
  ,.sc2mac_dat_a_src_data10        (sc2mac_dat_a_src_data10[7:0])      //|< w
  ,.sc2mac_dat_a_src_data11        (sc2mac_dat_a_src_data11[7:0])      //|< w
  ,.sc2mac_dat_a_src_data12        (sc2mac_dat_a_src_data12[7:0])      //|< w
  ,.sc2mac_dat_a_src_data13        (sc2mac_dat_a_src_data13[7:0])      //|< w
  ,.sc2mac_dat_a_src_data14        (sc2mac_dat_a_src_data14[7:0])      //|< w
  ,.sc2mac_dat_a_src_data15        (sc2mac_dat_a_src_data15[7:0])      //|< w
  ,.sc2mac_dat_a_src_data16        (sc2mac_dat_a_src_data16[7:0])      //|< w
  ,.sc2mac_dat_a_src_data17        (sc2mac_dat_a_src_data17[7:0])      //|< w
  ,.sc2mac_dat_a_src_data18        (sc2mac_dat_a_src_data18[7:0])      //|< w
  ,.sc2mac_dat_a_src_data19        (sc2mac_dat_a_src_data19[7:0])      //|< w
  ,.sc2mac_dat_a_src_data20        (sc2mac_dat_a_src_data20[7:0])      //|< w
  ,.sc2mac_dat_a_src_data21        (sc2mac_dat_a_src_data21[7:0])      //|< w
  ,.sc2mac_dat_a_src_data22        (sc2mac_dat_a_src_data22[7:0])      //|< w
  ,.sc2mac_dat_a_src_data23        (sc2mac_dat_a_src_data23[7:0])      //|< w
  ,.sc2mac_dat_a_src_data24        (sc2mac_dat_a_src_data24[7:0])      //|< w
  ,.sc2mac_dat_a_src_data25        (sc2mac_dat_a_src_data25[7:0])      //|< w
  ,.sc2mac_dat_a_src_data26        (sc2mac_dat_a_src_data26[7:0])      //|< w
  ,.sc2mac_dat_a_src_data27        (sc2mac_dat_a_src_data27[7:0])      //|< w
  ,.sc2mac_dat_a_src_data28        (sc2mac_dat_a_src_data28[7:0])      //|< w
  ,.sc2mac_dat_a_src_data29        (sc2mac_dat_a_src_data29[7:0])      //|< w
  ,.sc2mac_dat_a_src_data30        (sc2mac_dat_a_src_data30[7:0])      //|< w
  ,.sc2mac_dat_a_src_data31        (sc2mac_dat_a_src_data31[7:0])      //|< w
  ,.sc2mac_dat_a_src_data32        (sc2mac_dat_a_src_data32[7:0])      //|< w
  ,.sc2mac_dat_a_src_data33        (sc2mac_dat_a_src_data33[7:0])      //|< w
  ,.sc2mac_dat_a_src_data34        (sc2mac_dat_a_src_data34[7:0])      //|< w
  ,.sc2mac_dat_a_src_data35        (sc2mac_dat_a_src_data35[7:0])      //|< w
  ,.sc2mac_dat_a_src_data36        (sc2mac_dat_a_src_data36[7:0])      //|< w
  ,.sc2mac_dat_a_src_data37        (sc2mac_dat_a_src_data37[7:0])      //|< w
  ,.sc2mac_dat_a_src_data38        (sc2mac_dat_a_src_data38[7:0])      //|< w
  ,.sc2mac_dat_a_src_data39        (sc2mac_dat_a_src_data39[7:0])      //|< w
  ,.sc2mac_dat_a_src_data40        (sc2mac_dat_a_src_data40[7:0])      //|< w
  ,.sc2mac_dat_a_src_data41        (sc2mac_dat_a_src_data41[7:0])      //|< w
  ,.sc2mac_dat_a_src_data42        (sc2mac_dat_a_src_data42[7:0])      //|< w
  ,.sc2mac_dat_a_src_data43        (sc2mac_dat_a_src_data43[7:0])      //|< w
  ,.sc2mac_dat_a_src_data44        (sc2mac_dat_a_src_data44[7:0])      //|< w
  ,.sc2mac_dat_a_src_data45        (sc2mac_dat_a_src_data45[7:0])      //|< w
  ,.sc2mac_dat_a_src_data46        (sc2mac_dat_a_src_data46[7:0])      //|< w
  ,.sc2mac_dat_a_src_data47        (sc2mac_dat_a_src_data47[7:0])      //|< w
  ,.sc2mac_dat_a_src_data48        (sc2mac_dat_a_src_data48[7:0])      //|< w
  ,.sc2mac_dat_a_src_data49        (sc2mac_dat_a_src_data49[7:0])      //|< w
  ,.sc2mac_dat_a_src_data50        (sc2mac_dat_a_src_data50[7:0])      //|< w
  ,.sc2mac_dat_a_src_data51        (sc2mac_dat_a_src_data51[7:0])      //|< w
  ,.sc2mac_dat_a_src_data52        (sc2mac_dat_a_src_data52[7:0])      //|< w
  ,.sc2mac_dat_a_src_data53        (sc2mac_dat_a_src_data53[7:0])      //|< w
  ,.sc2mac_dat_a_src_data54        (sc2mac_dat_a_src_data54[7:0])      //|< w
  ,.sc2mac_dat_a_src_data55        (sc2mac_dat_a_src_data55[7:0])      //|< w
  ,.sc2mac_dat_a_src_data56        (sc2mac_dat_a_src_data56[7:0])      //|< w
  ,.sc2mac_dat_a_src_data57        (sc2mac_dat_a_src_data57[7:0])      //|< w
  ,.sc2mac_dat_a_src_data58        (sc2mac_dat_a_src_data58[7:0])      //|< w
  ,.sc2mac_dat_a_src_data59        (sc2mac_dat_a_src_data59[7:0])      //|< w
  ,.sc2mac_dat_a_src_data60        (sc2mac_dat_a_src_data60[7:0])      //|< w
  ,.sc2mac_dat_a_src_data61        (sc2mac_dat_a_src_data61[7:0])      //|< w
  ,.sc2mac_dat_a_src_data62        (sc2mac_dat_a_src_data62[7:0])      //|< w
  ,.sc2mac_dat_a_src_data63        (sc2mac_dat_a_src_data63[7:0])      //|< w
  ,.sc2mac_dat_a_src_data64        (sc2mac_dat_a_src_data64[7:0])      //|< w
  ,.sc2mac_dat_a_src_data65        (sc2mac_dat_a_src_data65[7:0])      //|< w
  ,.sc2mac_dat_a_src_data66        (sc2mac_dat_a_src_data66[7:0])      //|< w
  ,.sc2mac_dat_a_src_data67        (sc2mac_dat_a_src_data67[7:0])      //|< w
  ,.sc2mac_dat_a_src_data68        (sc2mac_dat_a_src_data68[7:0])      //|< w
  ,.sc2mac_dat_a_src_data69        (sc2mac_dat_a_src_data69[7:0])      //|< w
  ,.sc2mac_dat_a_src_data70        (sc2mac_dat_a_src_data70[7:0])      //|< w
  ,.sc2mac_dat_a_src_data71        (sc2mac_dat_a_src_data71[7:0])      //|< w
  ,.sc2mac_dat_a_src_data72        (sc2mac_dat_a_src_data72[7:0])      //|< w
  ,.sc2mac_dat_a_src_data73        (sc2mac_dat_a_src_data73[7:0])      //|< w
  ,.sc2mac_dat_a_src_data74        (sc2mac_dat_a_src_data74[7:0])      //|< w
  ,.sc2mac_dat_a_src_data75        (sc2mac_dat_a_src_data75[7:0])      //|< w
  ,.sc2mac_dat_a_src_data76        (sc2mac_dat_a_src_data76[7:0])      //|< w
  ,.sc2mac_dat_a_src_data77        (sc2mac_dat_a_src_data77[7:0])      //|< w
  ,.sc2mac_dat_a_src_data78        (sc2mac_dat_a_src_data78[7:0])      //|< w
  ,.sc2mac_dat_a_src_data79        (sc2mac_dat_a_src_data79[7:0])      //|< w
  ,.sc2mac_dat_a_src_data80        (sc2mac_dat_a_src_data80[7:0])      //|< w
  ,.sc2mac_dat_a_src_data81        (sc2mac_dat_a_src_data81[7:0])      //|< w
  ,.sc2mac_dat_a_src_data82        (sc2mac_dat_a_src_data82[7:0])      //|< w
  ,.sc2mac_dat_a_src_data83        (sc2mac_dat_a_src_data83[7:0])      //|< w
  ,.sc2mac_dat_a_src_data84        (sc2mac_dat_a_src_data84[7:0])      //|< w
  ,.sc2mac_dat_a_src_data85        (sc2mac_dat_a_src_data85[7:0])      //|< w
  ,.sc2mac_dat_a_src_data86        (sc2mac_dat_a_src_data86[7:0])      //|< w
  ,.sc2mac_dat_a_src_data87        (sc2mac_dat_a_src_data87[7:0])      //|< w
  ,.sc2mac_dat_a_src_data88        (sc2mac_dat_a_src_data88[7:0])      //|< w
  ,.sc2mac_dat_a_src_data89        (sc2mac_dat_a_src_data89[7:0])      //|< w
  ,.sc2mac_dat_a_src_data90        (sc2mac_dat_a_src_data90[7:0])      //|< w
  ,.sc2mac_dat_a_src_data91        (sc2mac_dat_a_src_data91[7:0])      //|< w
  ,.sc2mac_dat_a_src_data92        (sc2mac_dat_a_src_data92[7:0])      //|< w
  ,.sc2mac_dat_a_src_data93        (sc2mac_dat_a_src_data93[7:0])      //|< w
  ,.sc2mac_dat_a_src_data94        (sc2mac_dat_a_src_data94[7:0])      //|< w
  ,.sc2mac_dat_a_src_data95        (sc2mac_dat_a_src_data95[7:0])      //|< w
  ,.sc2mac_dat_a_src_data96        (sc2mac_dat_a_src_data96[7:0])      //|< w
  ,.sc2mac_dat_a_src_data97        (sc2mac_dat_a_src_data97[7:0])      //|< w
  ,.sc2mac_dat_a_src_data98        (sc2mac_dat_a_src_data98[7:0])      //|< w
  ,.sc2mac_dat_a_src_data99        (sc2mac_dat_a_src_data99[7:0])      //|< w
  ,.sc2mac_dat_a_src_data100       (sc2mac_dat_a_src_data100[7:0])     //|< w
  ,.sc2mac_dat_a_src_data101       (sc2mac_dat_a_src_data101[7:0])     //|< w
  ,.sc2mac_dat_a_src_data102       (sc2mac_dat_a_src_data102[7:0])     //|< w
  ,.sc2mac_dat_a_src_data103       (sc2mac_dat_a_src_data103[7:0])     //|< w
  ,.sc2mac_dat_a_src_data104       (sc2mac_dat_a_src_data104[7:0])     //|< w
  ,.sc2mac_dat_a_src_data105       (sc2mac_dat_a_src_data105[7:0])     //|< w
  ,.sc2mac_dat_a_src_data106       (sc2mac_dat_a_src_data106[7:0])     //|< w
  ,.sc2mac_dat_a_src_data107       (sc2mac_dat_a_src_data107[7:0])     //|< w
  ,.sc2mac_dat_a_src_data108       (sc2mac_dat_a_src_data108[7:0])     //|< w
  ,.sc2mac_dat_a_src_data109       (sc2mac_dat_a_src_data109[7:0])     //|< w
  ,.sc2mac_dat_a_src_data110       (sc2mac_dat_a_src_data110[7:0])     //|< w
  ,.sc2mac_dat_a_src_data111       (sc2mac_dat_a_src_data111[7:0])     //|< w
  ,.sc2mac_dat_a_src_data112       (sc2mac_dat_a_src_data112[7:0])     //|< w
  ,.sc2mac_dat_a_src_data113       (sc2mac_dat_a_src_data113[7:0])     //|< w
  ,.sc2mac_dat_a_src_data114       (sc2mac_dat_a_src_data114[7:0])     //|< w
  ,.sc2mac_dat_a_src_data115       (sc2mac_dat_a_src_data115[7:0])     //|< w
  ,.sc2mac_dat_a_src_data116       (sc2mac_dat_a_src_data116[7:0])     //|< w
  ,.sc2mac_dat_a_src_data117       (sc2mac_dat_a_src_data117[7:0])     //|< w
  ,.sc2mac_dat_a_src_data118       (sc2mac_dat_a_src_data118[7:0])     //|< w
  ,.sc2mac_dat_a_src_data119       (sc2mac_dat_a_src_data119[7:0])     //|< w
  ,.sc2mac_dat_a_src_data120       (sc2mac_dat_a_src_data120[7:0])     //|< w
  ,.sc2mac_dat_a_src_data121       (sc2mac_dat_a_src_data121[7:0])     //|< w
  ,.sc2mac_dat_a_src_data122       (sc2mac_dat_a_src_data122[7:0])     //|< w
  ,.sc2mac_dat_a_src_data123       (sc2mac_dat_a_src_data123[7:0])     //|< w
  ,.sc2mac_dat_a_src_data124       (sc2mac_dat_a_src_data124[7:0])     //|< w
  ,.sc2mac_dat_a_src_data125       (sc2mac_dat_a_src_data125[7:0])     //|< w
  ,.sc2mac_dat_a_src_data126       (sc2mac_dat_a_src_data126[7:0])     //|< w
  ,.sc2mac_dat_a_src_data127       (sc2mac_dat_a_src_data127[7:0])     //|< w
  ,.sc2mac_dat_a_src_pd            (sc2mac_dat_a_src_pd[8:0])          //|< w
  ,.sc2mac_wt_a_dst_pvld           (sc2mac_wt_a_dst_pvld)              //|> w
  ,.sc2mac_wt_a_dst_mask           (sc2mac_wt_a_dst_mask[127:0])       //|> w
  ,.sc2mac_wt_a_dst_data0          (sc2mac_wt_a_dst_data0[7:0])        //|> w
  ,.sc2mac_wt_a_dst_data1          (sc2mac_wt_a_dst_data1[7:0])        //|> w
  ,.sc2mac_wt_a_dst_data2          (sc2mac_wt_a_dst_data2[7:0])        //|> w
  ,.sc2mac_wt_a_dst_data3          (sc2mac_wt_a_dst_data3[7:0])        //|> w
  ,.sc2mac_wt_a_dst_data4          (sc2mac_wt_a_dst_data4[7:0])        //|> w
  ,.sc2mac_wt_a_dst_data5          (sc2mac_wt_a_dst_data5[7:0])        //|> w
  ,.sc2mac_wt_a_dst_data6          (sc2mac_wt_a_dst_data6[7:0])        //|> w
  ,.sc2mac_wt_a_dst_data7          (sc2mac_wt_a_dst_data7[7:0])        //|> w
  ,.sc2mac_wt_a_dst_data8          (sc2mac_wt_a_dst_data8[7:0])        //|> w
  ,.sc2mac_wt_a_dst_data9          (sc2mac_wt_a_dst_data9[7:0])        //|> w
  ,.sc2mac_wt_a_dst_data10         (sc2mac_wt_a_dst_data10[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data11         (sc2mac_wt_a_dst_data11[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data12         (sc2mac_wt_a_dst_data12[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data13         (sc2mac_wt_a_dst_data13[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data14         (sc2mac_wt_a_dst_data14[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data15         (sc2mac_wt_a_dst_data15[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data16         (sc2mac_wt_a_dst_data16[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data17         (sc2mac_wt_a_dst_data17[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data18         (sc2mac_wt_a_dst_data18[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data19         (sc2mac_wt_a_dst_data19[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data20         (sc2mac_wt_a_dst_data20[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data21         (sc2mac_wt_a_dst_data21[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data22         (sc2mac_wt_a_dst_data22[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data23         (sc2mac_wt_a_dst_data23[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data24         (sc2mac_wt_a_dst_data24[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data25         (sc2mac_wt_a_dst_data25[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data26         (sc2mac_wt_a_dst_data26[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data27         (sc2mac_wt_a_dst_data27[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data28         (sc2mac_wt_a_dst_data28[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data29         (sc2mac_wt_a_dst_data29[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data30         (sc2mac_wt_a_dst_data30[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data31         (sc2mac_wt_a_dst_data31[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data32         (sc2mac_wt_a_dst_data32[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data33         (sc2mac_wt_a_dst_data33[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data34         (sc2mac_wt_a_dst_data34[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data35         (sc2mac_wt_a_dst_data35[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data36         (sc2mac_wt_a_dst_data36[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data37         (sc2mac_wt_a_dst_data37[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data38         (sc2mac_wt_a_dst_data38[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data39         (sc2mac_wt_a_dst_data39[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data40         (sc2mac_wt_a_dst_data40[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data41         (sc2mac_wt_a_dst_data41[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data42         (sc2mac_wt_a_dst_data42[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data43         (sc2mac_wt_a_dst_data43[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data44         (sc2mac_wt_a_dst_data44[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data45         (sc2mac_wt_a_dst_data45[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data46         (sc2mac_wt_a_dst_data46[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data47         (sc2mac_wt_a_dst_data47[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data48         (sc2mac_wt_a_dst_data48[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data49         (sc2mac_wt_a_dst_data49[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data50         (sc2mac_wt_a_dst_data50[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data51         (sc2mac_wt_a_dst_data51[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data52         (sc2mac_wt_a_dst_data52[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data53         (sc2mac_wt_a_dst_data53[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data54         (sc2mac_wt_a_dst_data54[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data55         (sc2mac_wt_a_dst_data55[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data56         (sc2mac_wt_a_dst_data56[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data57         (sc2mac_wt_a_dst_data57[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data58         (sc2mac_wt_a_dst_data58[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data59         (sc2mac_wt_a_dst_data59[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data60         (sc2mac_wt_a_dst_data60[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data61         (sc2mac_wt_a_dst_data61[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data62         (sc2mac_wt_a_dst_data62[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data63         (sc2mac_wt_a_dst_data63[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data64         (sc2mac_wt_a_dst_data64[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data65         (sc2mac_wt_a_dst_data65[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data66         (sc2mac_wt_a_dst_data66[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data67         (sc2mac_wt_a_dst_data67[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data68         (sc2mac_wt_a_dst_data68[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data69         (sc2mac_wt_a_dst_data69[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data70         (sc2mac_wt_a_dst_data70[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data71         (sc2mac_wt_a_dst_data71[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data72         (sc2mac_wt_a_dst_data72[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data73         (sc2mac_wt_a_dst_data73[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data74         (sc2mac_wt_a_dst_data74[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data75         (sc2mac_wt_a_dst_data75[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data76         (sc2mac_wt_a_dst_data76[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data77         (sc2mac_wt_a_dst_data77[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data78         (sc2mac_wt_a_dst_data78[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data79         (sc2mac_wt_a_dst_data79[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data80         (sc2mac_wt_a_dst_data80[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data81         (sc2mac_wt_a_dst_data81[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data82         (sc2mac_wt_a_dst_data82[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data83         (sc2mac_wt_a_dst_data83[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data84         (sc2mac_wt_a_dst_data84[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data85         (sc2mac_wt_a_dst_data85[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data86         (sc2mac_wt_a_dst_data86[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data87         (sc2mac_wt_a_dst_data87[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data88         (sc2mac_wt_a_dst_data88[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data89         (sc2mac_wt_a_dst_data89[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data90         (sc2mac_wt_a_dst_data90[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data91         (sc2mac_wt_a_dst_data91[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data92         (sc2mac_wt_a_dst_data92[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data93         (sc2mac_wt_a_dst_data93[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data94         (sc2mac_wt_a_dst_data94[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data95         (sc2mac_wt_a_dst_data95[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data96         (sc2mac_wt_a_dst_data96[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data97         (sc2mac_wt_a_dst_data97[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data98         (sc2mac_wt_a_dst_data98[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data99         (sc2mac_wt_a_dst_data99[7:0])       //|> w
  ,.sc2mac_wt_a_dst_data100        (sc2mac_wt_a_dst_data100[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data101        (sc2mac_wt_a_dst_data101[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data102        (sc2mac_wt_a_dst_data102[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data103        (sc2mac_wt_a_dst_data103[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data104        (sc2mac_wt_a_dst_data104[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data105        (sc2mac_wt_a_dst_data105[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data106        (sc2mac_wt_a_dst_data106[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data107        (sc2mac_wt_a_dst_data107[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data108        (sc2mac_wt_a_dst_data108[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data109        (sc2mac_wt_a_dst_data109[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data110        (sc2mac_wt_a_dst_data110[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data111        (sc2mac_wt_a_dst_data111[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data112        (sc2mac_wt_a_dst_data112[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data113        (sc2mac_wt_a_dst_data113[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data114        (sc2mac_wt_a_dst_data114[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data115        (sc2mac_wt_a_dst_data115[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data116        (sc2mac_wt_a_dst_data116[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data117        (sc2mac_wt_a_dst_data117[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data118        (sc2mac_wt_a_dst_data118[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data119        (sc2mac_wt_a_dst_data119[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data120        (sc2mac_wt_a_dst_data120[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data121        (sc2mac_wt_a_dst_data121[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data122        (sc2mac_wt_a_dst_data122[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data123        (sc2mac_wt_a_dst_data123[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data124        (sc2mac_wt_a_dst_data124[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data125        (sc2mac_wt_a_dst_data125[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data126        (sc2mac_wt_a_dst_data126[7:0])      //|> w
  ,.sc2mac_wt_a_dst_data127        (sc2mac_wt_a_dst_data127[7:0])      //|> w
  ,.sc2mac_wt_a_dst_sel            (sc2mac_wt_a_dst_sel[7:0])          //|> w
  ,.sc2mac_wt_a_src_pvld           (sc2mac_wt_a_src_pvld)              //|< w
  ,.sc2mac_wt_a_src_mask           (sc2mac_wt_a_src_mask[127:0])       //|< w
  ,.sc2mac_wt_a_src_data0          (sc2mac_wt_a_src_data0[7:0])        //|< w
  ,.sc2mac_wt_a_src_data1          (sc2mac_wt_a_src_data1[7:0])        //|< w
  ,.sc2mac_wt_a_src_data2          (sc2mac_wt_a_src_data2[7:0])        //|< w
  ,.sc2mac_wt_a_src_data3          (sc2mac_wt_a_src_data3[7:0])        //|< w
  ,.sc2mac_wt_a_src_data4          (sc2mac_wt_a_src_data4[7:0])        //|< w
  ,.sc2mac_wt_a_src_data5          (sc2mac_wt_a_src_data5[7:0])        //|< w
  ,.sc2mac_wt_a_src_data6          (sc2mac_wt_a_src_data6[7:0])        //|< w
  ,.sc2mac_wt_a_src_data7          (sc2mac_wt_a_src_data7[7:0])        //|< w
  ,.sc2mac_wt_a_src_data8          (sc2mac_wt_a_src_data8[7:0])        //|< w
  ,.sc2mac_wt_a_src_data9          (sc2mac_wt_a_src_data9[7:0])        //|< w
  ,.sc2mac_wt_a_src_data10         (sc2mac_wt_a_src_data10[7:0])       //|< w
  ,.sc2mac_wt_a_src_data11         (sc2mac_wt_a_src_data11[7:0])       //|< w
  ,.sc2mac_wt_a_src_data12         (sc2mac_wt_a_src_data12[7:0])       //|< w
  ,.sc2mac_wt_a_src_data13         (sc2mac_wt_a_src_data13[7:0])       //|< w
  ,.sc2mac_wt_a_src_data14         (sc2mac_wt_a_src_data14[7:0])       //|< w
  ,.sc2mac_wt_a_src_data15         (sc2mac_wt_a_src_data15[7:0])       //|< w
  ,.sc2mac_wt_a_src_data16         (sc2mac_wt_a_src_data16[7:0])       //|< w
  ,.sc2mac_wt_a_src_data17         (sc2mac_wt_a_src_data17[7:0])       //|< w
  ,.sc2mac_wt_a_src_data18         (sc2mac_wt_a_src_data18[7:0])       //|< w
  ,.sc2mac_wt_a_src_data19         (sc2mac_wt_a_src_data19[7:0])       //|< w
  ,.sc2mac_wt_a_src_data20         (sc2mac_wt_a_src_data20[7:0])       //|< w
  ,.sc2mac_wt_a_src_data21         (sc2mac_wt_a_src_data21[7:0])       //|< w
  ,.sc2mac_wt_a_src_data22         (sc2mac_wt_a_src_data22[7:0])       //|< w
  ,.sc2mac_wt_a_src_data23         (sc2mac_wt_a_src_data23[7:0])       //|< w
  ,.sc2mac_wt_a_src_data24         (sc2mac_wt_a_src_data24[7:0])       //|< w
  ,.sc2mac_wt_a_src_data25         (sc2mac_wt_a_src_data25[7:0])       //|< w
  ,.sc2mac_wt_a_src_data26         (sc2mac_wt_a_src_data26[7:0])       //|< w
  ,.sc2mac_wt_a_src_data27         (sc2mac_wt_a_src_data27[7:0])       //|< w
  ,.sc2mac_wt_a_src_data28         (sc2mac_wt_a_src_data28[7:0])       //|< w
  ,.sc2mac_wt_a_src_data29         (sc2mac_wt_a_src_data29[7:0])       //|< w
  ,.sc2mac_wt_a_src_data30         (sc2mac_wt_a_src_data30[7:0])       //|< w
  ,.sc2mac_wt_a_src_data31         (sc2mac_wt_a_src_data31[7:0])       //|< w
  ,.sc2mac_wt_a_src_data32         (sc2mac_wt_a_src_data32[7:0])       //|< w
  ,.sc2mac_wt_a_src_data33         (sc2mac_wt_a_src_data33[7:0])       //|< w
  ,.sc2mac_wt_a_src_data34         (sc2mac_wt_a_src_data34[7:0])       //|< w
  ,.sc2mac_wt_a_src_data35         (sc2mac_wt_a_src_data35[7:0])       //|< w
  ,.sc2mac_wt_a_src_data36         (sc2mac_wt_a_src_data36[7:0])       //|< w
  ,.sc2mac_wt_a_src_data37         (sc2mac_wt_a_src_data37[7:0])       //|< w
  ,.sc2mac_wt_a_src_data38         (sc2mac_wt_a_src_data38[7:0])       //|< w
  ,.sc2mac_wt_a_src_data39         (sc2mac_wt_a_src_data39[7:0])       //|< w
  ,.sc2mac_wt_a_src_data40         (sc2mac_wt_a_src_data40[7:0])       //|< w
  ,.sc2mac_wt_a_src_data41         (sc2mac_wt_a_src_data41[7:0])       //|< w
  ,.sc2mac_wt_a_src_data42         (sc2mac_wt_a_src_data42[7:0])       //|< w
  ,.sc2mac_wt_a_src_data43         (sc2mac_wt_a_src_data43[7:0])       //|< w
  ,.sc2mac_wt_a_src_data44         (sc2mac_wt_a_src_data44[7:0])       //|< w
  ,.sc2mac_wt_a_src_data45         (sc2mac_wt_a_src_data45[7:0])       //|< w
  ,.sc2mac_wt_a_src_data46         (sc2mac_wt_a_src_data46[7:0])       //|< w
  ,.sc2mac_wt_a_src_data47         (sc2mac_wt_a_src_data47[7:0])       //|< w
  ,.sc2mac_wt_a_src_data48         (sc2mac_wt_a_src_data48[7:0])       //|< w
  ,.sc2mac_wt_a_src_data49         (sc2mac_wt_a_src_data49[7:0])       //|< w
  ,.sc2mac_wt_a_src_data50         (sc2mac_wt_a_src_data50[7:0])       //|< w
  ,.sc2mac_wt_a_src_data51         (sc2mac_wt_a_src_data51[7:0])       //|< w
  ,.sc2mac_wt_a_src_data52         (sc2mac_wt_a_src_data52[7:0])       //|< w
  ,.sc2mac_wt_a_src_data53         (sc2mac_wt_a_src_data53[7:0])       //|< w
  ,.sc2mac_wt_a_src_data54         (sc2mac_wt_a_src_data54[7:0])       //|< w
  ,.sc2mac_wt_a_src_data55         (sc2mac_wt_a_src_data55[7:0])       //|< w
  ,.sc2mac_wt_a_src_data56         (sc2mac_wt_a_src_data56[7:0])       //|< w
  ,.sc2mac_wt_a_src_data57         (sc2mac_wt_a_src_data57[7:0])       //|< w
  ,.sc2mac_wt_a_src_data58         (sc2mac_wt_a_src_data58[7:0])       //|< w
  ,.sc2mac_wt_a_src_data59         (sc2mac_wt_a_src_data59[7:0])       //|< w
  ,.sc2mac_wt_a_src_data60         (sc2mac_wt_a_src_data60[7:0])       //|< w
  ,.sc2mac_wt_a_src_data61         (sc2mac_wt_a_src_data61[7:0])       //|< w
  ,.sc2mac_wt_a_src_data62         (sc2mac_wt_a_src_data62[7:0])       //|< w
  ,.sc2mac_wt_a_src_data63         (sc2mac_wt_a_src_data63[7:0])       //|< w
  ,.sc2mac_wt_a_src_data64         (sc2mac_wt_a_src_data64[7:0])       //|< w
  ,.sc2mac_wt_a_src_data65         (sc2mac_wt_a_src_data65[7:0])       //|< w
  ,.sc2mac_wt_a_src_data66         (sc2mac_wt_a_src_data66[7:0])       //|< w
  ,.sc2mac_wt_a_src_data67         (sc2mac_wt_a_src_data67[7:0])       //|< w
  ,.sc2mac_wt_a_src_data68         (sc2mac_wt_a_src_data68[7:0])       //|< w
  ,.sc2mac_wt_a_src_data69         (sc2mac_wt_a_src_data69[7:0])       //|< w
  ,.sc2mac_wt_a_src_data70         (sc2mac_wt_a_src_data70[7:0])       //|< w
  ,.sc2mac_wt_a_src_data71         (sc2mac_wt_a_src_data71[7:0])       //|< w
  ,.sc2mac_wt_a_src_data72         (sc2mac_wt_a_src_data72[7:0])       //|< w
  ,.sc2mac_wt_a_src_data73         (sc2mac_wt_a_src_data73[7:0])       //|< w
  ,.sc2mac_wt_a_src_data74         (sc2mac_wt_a_src_data74[7:0])       //|< w
  ,.sc2mac_wt_a_src_data75         (sc2mac_wt_a_src_data75[7:0])       //|< w
  ,.sc2mac_wt_a_src_data76         (sc2mac_wt_a_src_data76[7:0])       //|< w
  ,.sc2mac_wt_a_src_data77         (sc2mac_wt_a_src_data77[7:0])       //|< w
  ,.sc2mac_wt_a_src_data78         (sc2mac_wt_a_src_data78[7:0])       //|< w
  ,.sc2mac_wt_a_src_data79         (sc2mac_wt_a_src_data79[7:0])       //|< w
  ,.sc2mac_wt_a_src_data80         (sc2mac_wt_a_src_data80[7:0])       //|< w
  ,.sc2mac_wt_a_src_data81         (sc2mac_wt_a_src_data81[7:0])       //|< w
  ,.sc2mac_wt_a_src_data82         (sc2mac_wt_a_src_data82[7:0])       //|< w
  ,.sc2mac_wt_a_src_data83         (sc2mac_wt_a_src_data83[7:0])       //|< w
  ,.sc2mac_wt_a_src_data84         (sc2mac_wt_a_src_data84[7:0])       //|< w
  ,.sc2mac_wt_a_src_data85         (sc2mac_wt_a_src_data85[7:0])       //|< w
  ,.sc2mac_wt_a_src_data86         (sc2mac_wt_a_src_data86[7:0])       //|< w
  ,.sc2mac_wt_a_src_data87         (sc2mac_wt_a_src_data87[7:0])       //|< w
  ,.sc2mac_wt_a_src_data88         (sc2mac_wt_a_src_data88[7:0])       //|< w
  ,.sc2mac_wt_a_src_data89         (sc2mac_wt_a_src_data89[7:0])       //|< w
  ,.sc2mac_wt_a_src_data90         (sc2mac_wt_a_src_data90[7:0])       //|< w
  ,.sc2mac_wt_a_src_data91         (sc2mac_wt_a_src_data91[7:0])       //|< w
  ,.sc2mac_wt_a_src_data92         (sc2mac_wt_a_src_data92[7:0])       //|< w
  ,.sc2mac_wt_a_src_data93         (sc2mac_wt_a_src_data93[7:0])       //|< w
  ,.sc2mac_wt_a_src_data94         (sc2mac_wt_a_src_data94[7:0])       //|< w
  ,.sc2mac_wt_a_src_data95         (sc2mac_wt_a_src_data95[7:0])       //|< w
  ,.sc2mac_wt_a_src_data96         (sc2mac_wt_a_src_data96[7:0])       //|< w
  ,.sc2mac_wt_a_src_data97         (sc2mac_wt_a_src_data97[7:0])       //|< w
  ,.sc2mac_wt_a_src_data98         (sc2mac_wt_a_src_data98[7:0])       //|< w
  ,.sc2mac_wt_a_src_data99         (sc2mac_wt_a_src_data99[7:0])       //|< w
  ,.sc2mac_wt_a_src_data100        (sc2mac_wt_a_src_data100[7:0])      //|< w
  ,.sc2mac_wt_a_src_data101        (sc2mac_wt_a_src_data101[7:0])      //|< w
  ,.sc2mac_wt_a_src_data102        (sc2mac_wt_a_src_data102[7:0])      //|< w
  ,.sc2mac_wt_a_src_data103        (sc2mac_wt_a_src_data103[7:0])      //|< w
  ,.sc2mac_wt_a_src_data104        (sc2mac_wt_a_src_data104[7:0])      //|< w
  ,.sc2mac_wt_a_src_data105        (sc2mac_wt_a_src_data105[7:0])      //|< w
  ,.sc2mac_wt_a_src_data106        (sc2mac_wt_a_src_data106[7:0])      //|< w
  ,.sc2mac_wt_a_src_data107        (sc2mac_wt_a_src_data107[7:0])      //|< w
  ,.sc2mac_wt_a_src_data108        (sc2mac_wt_a_src_data108[7:0])      //|< w
  ,.sc2mac_wt_a_src_data109        (sc2mac_wt_a_src_data109[7:0])      //|< w
  ,.sc2mac_wt_a_src_data110        (sc2mac_wt_a_src_data110[7:0])      //|< w
  ,.sc2mac_wt_a_src_data111        (sc2mac_wt_a_src_data111[7:0])      //|< w
  ,.sc2mac_wt_a_src_data112        (sc2mac_wt_a_src_data112[7:0])      //|< w
  ,.sc2mac_wt_a_src_data113        (sc2mac_wt_a_src_data113[7:0])      //|< w
  ,.sc2mac_wt_a_src_data114        (sc2mac_wt_a_src_data114[7:0])      //|< w
  ,.sc2mac_wt_a_src_data115        (sc2mac_wt_a_src_data115[7:0])      //|< w
  ,.sc2mac_wt_a_src_data116        (sc2mac_wt_a_src_data116[7:0])      //|< w
  ,.sc2mac_wt_a_src_data117        (sc2mac_wt_a_src_data117[7:0])      //|< w
  ,.sc2mac_wt_a_src_data118        (sc2mac_wt_a_src_data118[7:0])      //|< w
  ,.sc2mac_wt_a_src_data119        (sc2mac_wt_a_src_data119[7:0])      //|< w
  ,.sc2mac_wt_a_src_data120        (sc2mac_wt_a_src_data120[7:0])      //|< w
  ,.sc2mac_wt_a_src_data121        (sc2mac_wt_a_src_data121[7:0])      //|< w
  ,.sc2mac_wt_a_src_data122        (sc2mac_wt_a_src_data122[7:0])      //|< w
  ,.sc2mac_wt_a_src_data123        (sc2mac_wt_a_src_data123[7:0])      //|< w
  ,.sc2mac_wt_a_src_data124        (sc2mac_wt_a_src_data124[7:0])      //|< w
  ,.sc2mac_wt_a_src_data125        (sc2mac_wt_a_src_data125[7:0])      //|< w
  ,.sc2mac_wt_a_src_data126        (sc2mac_wt_a_src_data126[7:0])      //|< w
  ,.sc2mac_wt_a_src_data127        (sc2mac_wt_a_src_data127[7:0])      //|< w
  ,.sc2mac_wt_a_src_sel            (sc2mac_wt_a_src_sel[7:0])          //|< w
  ,.sdp2csb_resp_valid             (sdp2csb_resp_valid)                //|< w
  ,.sdp2csb_resp_pd                (sdp2csb_resp_pd[33:0])             //|< w
  ,.sdp2cvif_rd_cdt_lat_fifo_pop   (sdp2cvif_rd_cdt_lat_fifo_pop)      //|< w
  ,.sdp2cvif_rd_req_valid          (sdp2cvif_rd_req_valid)             //|< w
  ,.sdp2cvif_rd_req_ready          (sdp2cvif_rd_req_ready)             //|> w
  ,.sdp2cvif_rd_req_pd             (sdp2cvif_rd_req_pd[78:0])          //|< w
  ,.sdp2cvif_wr_req_valid          (sdp2cvif_wr_req_valid)             //|< w
  ,.sdp2cvif_wr_req_ready          (sdp2cvif_wr_req_ready)             //|> w
  ,.sdp2cvif_wr_req_pd             (sdp2cvif_wr_req_pd[514:0])         //|< w
  ,.sdp2glb_done_intr_pd           (sdp2glb_done_intr_pd[1:0])         //|< w
  ,.sdp2mcif_rd_cdt_lat_fifo_pop   (sdp2mcif_rd_cdt_lat_fifo_pop)      //|< w
  ,.sdp2mcif_rd_req_valid          (sdp2mcif_rd_req_valid)             //|< w
  ,.sdp2mcif_rd_req_ready          (sdp2mcif_rd_req_ready)             //|> w
  ,.sdp2mcif_rd_req_pd             (sdp2mcif_rd_req_pd[78:0])          //|< w
  ,.sdp2mcif_wr_req_valid          (sdp2mcif_wr_req_valid)             //|< w
  ,.sdp2mcif_wr_req_ready          (sdp2mcif_wr_req_ready)             //|> w
  ,.sdp2mcif_wr_req_pd             (sdp2mcif_wr_req_pd[514:0])         //|< w
  ,.sdp2pdp_valid                  (sdp2pdp_valid)                     //|< w
  ,.sdp2pdp_ready                  (sdp2pdp_ready)                     //|> w
  ,.sdp2pdp_pd                     (sdp2pdp_pd[255:0])                 //|< w
  ,.sdp_b2cvif_rd_cdt_lat_fifo_pop (sdp_b2cvif_rd_cdt_lat_fifo_pop)    //|< w
  ,.sdp_b2cvif_rd_req_valid        (sdp_b2cvif_rd_req_valid)           //|< w
  ,.sdp_b2cvif_rd_req_ready        (sdp_b2cvif_rd_req_ready)           //|> w
  ,.sdp_b2cvif_rd_req_pd           (sdp_b2cvif_rd_req_pd[78:0])        //|< w
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop (sdp_b2mcif_rd_cdt_lat_fifo_pop)    //|< w
  ,.sdp_b2mcif_rd_req_valid        (sdp_b2mcif_rd_req_valid)           //|< w
  ,.sdp_b2mcif_rd_req_ready        (sdp_b2mcif_rd_req_ready)           //|> w
  ,.sdp_b2mcif_rd_req_pd           (sdp_b2mcif_rd_req_pd[78:0])        //|< w
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop)    //|< w
  ,.sdp_e2cvif_rd_req_valid        (sdp_e2cvif_rd_req_valid)           //|< w
  ,.sdp_e2cvif_rd_req_ready        (sdp_e2cvif_rd_req_ready)           //|> w
  ,.sdp_e2cvif_rd_req_pd           (sdp_e2cvif_rd_req_pd[78:0])        //|< w
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2mcif_rd_cdt_lat_fifo_pop)    //|< w
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2mcif_rd_req_valid)           //|< w
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2mcif_rd_req_ready)           //|> w
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2mcif_rd_req_pd[78:0])        //|< w
  ,.sdp_n2cvif_rd_cdt_lat_fifo_pop (sdp_n2cvif_rd_cdt_lat_fifo_pop)    //|< w
  ,.sdp_n2cvif_rd_req_valid        (sdp_n2cvif_rd_req_valid)           //|< w
  ,.sdp_n2cvif_rd_req_ready        (sdp_n2cvif_rd_req_ready)           //|> w
  ,.sdp_n2cvif_rd_req_pd           (sdp_n2cvif_rd_req_pd[78:0])        //|< w
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop (sdp_n2mcif_rd_cdt_lat_fifo_pop)    //|< w
  ,.sdp_n2mcif_rd_req_valid        (sdp_n2mcif_rd_req_valid)           //|< w
  ,.sdp_n2mcif_rd_req_ready        (sdp_n2mcif_rd_req_ready)           //|> w
  ,.sdp_n2mcif_rd_req_pd           (sdp_n2mcif_rd_req_pd[78:0])        //|< w
  ,.sdp_rdma2csb_resp_valid        (sdp_rdma2csb_resp_valid)           //|< w
  ,.sdp_rdma2csb_resp_pd           (sdp_rdma2csb_resp_pd[33:0])        //|< w
  ,.nvdla_core_clk                 (dla_core_clk)                      //|< i
  ,.dla_reset_rstn                 (dla_reset_rstn)                    //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                   //|> w
  ,.nvdla_falcon_clk               (dla_csb_clk)                       //|< i
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)                  //|> w
  );
    //&Connect nvdla_host1x_clk   dla_host1x_clk;
    //&Connect nvdla_host1x_clk   dla_core_clk;
    //&Connect /nvdla_obs/        nvdla_pwrpart_o_obs;

    ////Dangle csb if of afbif
    //&Connect afbif2csb_valid          0;
    //&Connect afbif2csb_pd             0;
    //&Connect afbif2csb_error          0;
    //&Connect afbif2csb_wr_complete    0;
    //&Connect afbif2csb_wr_error       0;
    //&Connect afbif2csb_wr_rdat        0;
    //&Connect csb2afbif_pvld           csb2afbif_pvld;
    //&Connect csb2afbif_prdy           0;
    //&Connect csb2afbif_pd             csb2afbif_pd;

    //dangle mc/cvif streamid   //stepheng.
    //&Connect falcon2cvif_streamid     8'd0;
    //&Connect falcon2mcif_streamid     8'd0;

    //connect core_intr to dla_intr

//&Instance NV_NVDLA_partition_o;
//    &Connect nvdla_host1x_clk   dla_host1x_clk;
//    &Connect nvdla_falcon_clk   dla_falcon_clk;
//    &Connect nvdla_core_clk     dla_core_clk;
//    &Connect fault_corrected    dla_fault_corrected;
//    &Connect fault_critical     dla_fault_critical;
//    &Connect /cvif2noc/         nvdla_core2cvsram;
//    &Connect /noc2cvif/         nvdla_core2cvsram;
//    &Connect /mcif2noc/         nvdla_core2dbb;
//    &Connect /noc2mcif/         nvdla_core2dbb;
//    &Connect /pwrbus_ram/       nvdla_pwrbus_ram_o;
//    &Connect /nvdla_obs/        nvdla_pwrpart_o_obs;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C                                                 //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_c u_partition_c (
   .test_mode                      (test_mode)                         //|< i
  ,.direct_reset_                  (direct_reset_)                     //|< i
  ,.global_clk_ovr_on              (global_clk_ovr_on)                 //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     //|< i
  ,.accu2sc_credit_vld             (accu2sc_credit_vld)                //|< w
  ,.accu2sc_credit_size            (accu2sc_credit_size[2:0])          //|< w
  ,.cacc2csb_resp_dst_valid        (cacc2csb_resp_dst_valid)           //|> w
  ,.cacc2csb_resp_dst_pd           (cacc2csb_resp_dst_pd[33:0])        //|> w
  ,.cacc2csb_resp_src_valid        (cacc2csb_resp_src_valid)           //|< w
  ,.cacc2csb_resp_src_pd           (cacc2csb_resp_src_pd[33:0])        //|< w
  ,.cacc2glb_done_intr_dst_pd      (cacc2glb_done_intr_dst_pd[1:0])    //|> w
  ,.cacc2glb_done_intr_src_pd      (cacc2glb_done_intr_src_pd[1:0])    //|< w
  ,.cdma2csb_resp_valid            (cdma2csb_resp_valid)               //|> w
  ,.cdma2csb_resp_pd               (cdma2csb_resp_pd[33:0])            //|> w
  ,.cdma_dat2cvif_rd_req_valid     (cdma_dat2cvif_rd_req_valid)        //|> w
  ,.cdma_dat2cvif_rd_req_ready     (cdma_dat2cvif_rd_req_ready)        //|< w
  ,.cdma_dat2cvif_rd_req_pd        (cdma_dat2cvif_rd_req_pd[78:0])     //|> w
  ,.cdma_dat2glb_done_intr_pd      (cdma_dat2glb_done_intr_pd[1:0])    //|> w
  ,.cdma_dat2mcif_rd_req_valid     (cdma_dat2mcif_rd_req_valid)        //|> w
  ,.cdma_dat2mcif_rd_req_ready     (cdma_dat2mcif_rd_req_ready)        //|< w
  ,.cdma_dat2mcif_rd_req_pd        (cdma_dat2mcif_rd_req_pd[78:0])     //|> w
  ,.cdma_wt2cvif_rd_req_valid      (cdma_wt2cvif_rd_req_valid)         //|> w
  ,.cdma_wt2cvif_rd_req_ready      (cdma_wt2cvif_rd_req_ready)         //|< w
  ,.cdma_wt2cvif_rd_req_pd         (cdma_wt2cvif_rd_req_pd[78:0])      //|> w
  ,.cdma_wt2glb_done_intr_pd       (cdma_wt2glb_done_intr_pd[1:0])     //|> w
  ,.cdma_wt2mcif_rd_req_valid      (cdma_wt2mcif_rd_req_valid)         //|> w
  ,.cdma_wt2mcif_rd_req_ready      (cdma_wt2mcif_rd_req_ready)         //|< w
  ,.cdma_wt2mcif_rd_req_pd         (cdma_wt2mcif_rd_req_pd[78:0])      //|> w
  ,.cmac_b2csb_resp_dst_valid      (cmac_b2csb_resp_dst_valid)         //|> w
  ,.cmac_b2csb_resp_dst_pd         (cmac_b2csb_resp_dst_pd[33:0])      //|> w
  ,.cmac_b2csb_resp_src_valid      (cmac_b2csb_resp_src_valid)         //|< w
  ,.cmac_b2csb_resp_src_pd         (cmac_b2csb_resp_src_pd[33:0])      //|< w
  ,.csb2cacc_req_dst_pvld          (csb2cacc_req_dst_pvld)             //|> w
  ,.csb2cacc_req_dst_prdy          (csb2cacc_req_dst_prdy)             //|< w
  ,.csb2cacc_req_dst_pd            (csb2cacc_req_dst_pd[62:0])         //|> w
  ,.csb2cacc_req_src_pvld          (csb2cacc_req_src_pvld)             //|< w
  ,.csb2cacc_req_src_prdy          (csb2cacc_req_src_prdy)             //|> w
  ,.csb2cacc_req_src_pd            (csb2cacc_req_src_pd[62:0])         //|< w
  ,.csb2cdma_req_pvld              (csb2cdma_req_pvld)                 //|< w
  ,.csb2cdma_req_prdy              (csb2cdma_req_prdy)                 //|> w
  ,.csb2cdma_req_pd                (csb2cdma_req_pd[62:0])             //|< w
  ,.csb2cmac_b_req_dst_pvld        (csb2cmac_b_req_dst_pvld)           //|> w
  ,.csb2cmac_b_req_dst_prdy        (csb2cmac_b_req_dst_prdy)           //|< w
  ,.csb2cmac_b_req_dst_pd          (csb2cmac_b_req_dst_pd[62:0])       //|> w
  ,.csb2cmac_b_req_src_pvld        (csb2cmac_b_req_src_pvld)           //|< w
  ,.csb2cmac_b_req_src_prdy        (csb2cmac_b_req_src_prdy)           //|> w
  ,.csb2cmac_b_req_src_pd          (csb2cmac_b_req_src_pd[62:0])       //|< w
  ,.csb2csc_req_pvld               (csb2csc_req_pvld)                  //|< w
  ,.csb2csc_req_prdy               (csb2csc_req_prdy)                  //|> w
  ,.csb2csc_req_pd                 (csb2csc_req_pd[62:0])              //|< w
  ,.csc2csb_resp_valid             (csc2csb_resp_valid)                //|> w
  ,.csc2csb_resp_pd                (csc2csb_resp_pd[33:0])             //|> w
  ,.cvif2cdma_dat_rd_rsp_valid     (cvif2cdma_dat_rd_rsp_valid)        //|< w
  ,.cvif2cdma_dat_rd_rsp_ready     (cvif2cdma_dat_rd_rsp_ready)        //|> w
  ,.cvif2cdma_dat_rd_rsp_pd        (cvif2cdma_dat_rd_rsp_pd[513:0])    //|< w
  ,.cvif2cdma_wt_rd_rsp_valid      (cvif2cdma_wt_rd_rsp_valid)         //|< w
  ,.cvif2cdma_wt_rd_rsp_ready      (cvif2cdma_wt_rd_rsp_ready)         //|> w
  ,.cvif2cdma_wt_rd_rsp_pd         (cvif2cdma_wt_rd_rsp_pd[513:0])     //|< w
  ,.mcif2cdma_dat_rd_rsp_valid     (mcif2cdma_dat_rd_rsp_valid)        //|< w
  ,.mcif2cdma_dat_rd_rsp_ready     (mcif2cdma_dat_rd_rsp_ready)        //|> w
  ,.mcif2cdma_dat_rd_rsp_pd        (mcif2cdma_dat_rd_rsp_pd[513:0])    //|< w
  ,.mcif2cdma_wt_rd_rsp_valid      (mcif2cdma_wt_rd_rsp_valid)         //|< w
  ,.mcif2cdma_wt_rd_rsp_ready      (mcif2cdma_wt_rd_rsp_ready)         //|> w
  ,.mcif2cdma_wt_rd_rsp_pd         (mcif2cdma_wt_rd_rsp_pd[513:0])     //|< w
  ,.pwrbus_ram_pd                  (nvdla_pwrbus_ram_c_pd[31:0])       //|< i
  ,.sc2mac_dat_a_src_pvld          (sc2mac_dat_a_src_pvld)             //|> w
  ,.sc2mac_dat_a_src_mask          (sc2mac_dat_a_src_mask[127:0])      //|> w
  ,.sc2mac_dat_a_src_data0         (sc2mac_dat_a_src_data0[7:0])       //|> w
  ,.sc2mac_dat_a_src_data1         (sc2mac_dat_a_src_data1[7:0])       //|> w
  ,.sc2mac_dat_a_src_data2         (sc2mac_dat_a_src_data2[7:0])       //|> w
  ,.sc2mac_dat_a_src_data3         (sc2mac_dat_a_src_data3[7:0])       //|> w
  ,.sc2mac_dat_a_src_data4         (sc2mac_dat_a_src_data4[7:0])       //|> w
  ,.sc2mac_dat_a_src_data5         (sc2mac_dat_a_src_data5[7:0])       //|> w
  ,.sc2mac_dat_a_src_data6         (sc2mac_dat_a_src_data6[7:0])       //|> w
  ,.sc2mac_dat_a_src_data7         (sc2mac_dat_a_src_data7[7:0])       //|> w
  ,.sc2mac_dat_a_src_data8         (sc2mac_dat_a_src_data8[7:0])       //|> w
  ,.sc2mac_dat_a_src_data9         (sc2mac_dat_a_src_data9[7:0])       //|> w
  ,.sc2mac_dat_a_src_data10        (sc2mac_dat_a_src_data10[7:0])      //|> w
  ,.sc2mac_dat_a_src_data11        (sc2mac_dat_a_src_data11[7:0])      //|> w
  ,.sc2mac_dat_a_src_data12        (sc2mac_dat_a_src_data12[7:0])      //|> w
  ,.sc2mac_dat_a_src_data13        (sc2mac_dat_a_src_data13[7:0])      //|> w
  ,.sc2mac_dat_a_src_data14        (sc2mac_dat_a_src_data14[7:0])      //|> w
  ,.sc2mac_dat_a_src_data15        (sc2mac_dat_a_src_data15[7:0])      //|> w
  ,.sc2mac_dat_a_src_data16        (sc2mac_dat_a_src_data16[7:0])      //|> w
  ,.sc2mac_dat_a_src_data17        (sc2mac_dat_a_src_data17[7:0])      //|> w
  ,.sc2mac_dat_a_src_data18        (sc2mac_dat_a_src_data18[7:0])      //|> w
  ,.sc2mac_dat_a_src_data19        (sc2mac_dat_a_src_data19[7:0])      //|> w
  ,.sc2mac_dat_a_src_data20        (sc2mac_dat_a_src_data20[7:0])      //|> w
  ,.sc2mac_dat_a_src_data21        (sc2mac_dat_a_src_data21[7:0])      //|> w
  ,.sc2mac_dat_a_src_data22        (sc2mac_dat_a_src_data22[7:0])      //|> w
  ,.sc2mac_dat_a_src_data23        (sc2mac_dat_a_src_data23[7:0])      //|> w
  ,.sc2mac_dat_a_src_data24        (sc2mac_dat_a_src_data24[7:0])      //|> w
  ,.sc2mac_dat_a_src_data25        (sc2mac_dat_a_src_data25[7:0])      //|> w
  ,.sc2mac_dat_a_src_data26        (sc2mac_dat_a_src_data26[7:0])      //|> w
  ,.sc2mac_dat_a_src_data27        (sc2mac_dat_a_src_data27[7:0])      //|> w
  ,.sc2mac_dat_a_src_data28        (sc2mac_dat_a_src_data28[7:0])      //|> w
  ,.sc2mac_dat_a_src_data29        (sc2mac_dat_a_src_data29[7:0])      //|> w
  ,.sc2mac_dat_a_src_data30        (sc2mac_dat_a_src_data30[7:0])      //|> w
  ,.sc2mac_dat_a_src_data31        (sc2mac_dat_a_src_data31[7:0])      //|> w
  ,.sc2mac_dat_a_src_data32        (sc2mac_dat_a_src_data32[7:0])      //|> w
  ,.sc2mac_dat_a_src_data33        (sc2mac_dat_a_src_data33[7:0])      //|> w
  ,.sc2mac_dat_a_src_data34        (sc2mac_dat_a_src_data34[7:0])      //|> w
  ,.sc2mac_dat_a_src_data35        (sc2mac_dat_a_src_data35[7:0])      //|> w
  ,.sc2mac_dat_a_src_data36        (sc2mac_dat_a_src_data36[7:0])      //|> w
  ,.sc2mac_dat_a_src_data37        (sc2mac_dat_a_src_data37[7:0])      //|> w
  ,.sc2mac_dat_a_src_data38        (sc2mac_dat_a_src_data38[7:0])      //|> w
  ,.sc2mac_dat_a_src_data39        (sc2mac_dat_a_src_data39[7:0])      //|> w
  ,.sc2mac_dat_a_src_data40        (sc2mac_dat_a_src_data40[7:0])      //|> w
  ,.sc2mac_dat_a_src_data41        (sc2mac_dat_a_src_data41[7:0])      //|> w
  ,.sc2mac_dat_a_src_data42        (sc2mac_dat_a_src_data42[7:0])      //|> w
  ,.sc2mac_dat_a_src_data43        (sc2mac_dat_a_src_data43[7:0])      //|> w
  ,.sc2mac_dat_a_src_data44        (sc2mac_dat_a_src_data44[7:0])      //|> w
  ,.sc2mac_dat_a_src_data45        (sc2mac_dat_a_src_data45[7:0])      //|> w
  ,.sc2mac_dat_a_src_data46        (sc2mac_dat_a_src_data46[7:0])      //|> w
  ,.sc2mac_dat_a_src_data47        (sc2mac_dat_a_src_data47[7:0])      //|> w
  ,.sc2mac_dat_a_src_data48        (sc2mac_dat_a_src_data48[7:0])      //|> w
  ,.sc2mac_dat_a_src_data49        (sc2mac_dat_a_src_data49[7:0])      //|> w
  ,.sc2mac_dat_a_src_data50        (sc2mac_dat_a_src_data50[7:0])      //|> w
  ,.sc2mac_dat_a_src_data51        (sc2mac_dat_a_src_data51[7:0])      //|> w
  ,.sc2mac_dat_a_src_data52        (sc2mac_dat_a_src_data52[7:0])      //|> w
  ,.sc2mac_dat_a_src_data53        (sc2mac_dat_a_src_data53[7:0])      //|> w
  ,.sc2mac_dat_a_src_data54        (sc2mac_dat_a_src_data54[7:0])      //|> w
  ,.sc2mac_dat_a_src_data55        (sc2mac_dat_a_src_data55[7:0])      //|> w
  ,.sc2mac_dat_a_src_data56        (sc2mac_dat_a_src_data56[7:0])      //|> w
  ,.sc2mac_dat_a_src_data57        (sc2mac_dat_a_src_data57[7:0])      //|> w
  ,.sc2mac_dat_a_src_data58        (sc2mac_dat_a_src_data58[7:0])      //|> w
  ,.sc2mac_dat_a_src_data59        (sc2mac_dat_a_src_data59[7:0])      //|> w
  ,.sc2mac_dat_a_src_data60        (sc2mac_dat_a_src_data60[7:0])      //|> w
  ,.sc2mac_dat_a_src_data61        (sc2mac_dat_a_src_data61[7:0])      //|> w
  ,.sc2mac_dat_a_src_data62        (sc2mac_dat_a_src_data62[7:0])      //|> w
  ,.sc2mac_dat_a_src_data63        (sc2mac_dat_a_src_data63[7:0])      //|> w
  ,.sc2mac_dat_a_src_data64        (sc2mac_dat_a_src_data64[7:0])      //|> w
  ,.sc2mac_dat_a_src_data65        (sc2mac_dat_a_src_data65[7:0])      //|> w
  ,.sc2mac_dat_a_src_data66        (sc2mac_dat_a_src_data66[7:0])      //|> w
  ,.sc2mac_dat_a_src_data67        (sc2mac_dat_a_src_data67[7:0])      //|> w
  ,.sc2mac_dat_a_src_data68        (sc2mac_dat_a_src_data68[7:0])      //|> w
  ,.sc2mac_dat_a_src_data69        (sc2mac_dat_a_src_data69[7:0])      //|> w
  ,.sc2mac_dat_a_src_data70        (sc2mac_dat_a_src_data70[7:0])      //|> w
  ,.sc2mac_dat_a_src_data71        (sc2mac_dat_a_src_data71[7:0])      //|> w
  ,.sc2mac_dat_a_src_data72        (sc2mac_dat_a_src_data72[7:0])      //|> w
  ,.sc2mac_dat_a_src_data73        (sc2mac_dat_a_src_data73[7:0])      //|> w
  ,.sc2mac_dat_a_src_data74        (sc2mac_dat_a_src_data74[7:0])      //|> w
  ,.sc2mac_dat_a_src_data75        (sc2mac_dat_a_src_data75[7:0])      //|> w
  ,.sc2mac_dat_a_src_data76        (sc2mac_dat_a_src_data76[7:0])      //|> w
  ,.sc2mac_dat_a_src_data77        (sc2mac_dat_a_src_data77[7:0])      //|> w
  ,.sc2mac_dat_a_src_data78        (sc2mac_dat_a_src_data78[7:0])      //|> w
  ,.sc2mac_dat_a_src_data79        (sc2mac_dat_a_src_data79[7:0])      //|> w
  ,.sc2mac_dat_a_src_data80        (sc2mac_dat_a_src_data80[7:0])      //|> w
  ,.sc2mac_dat_a_src_data81        (sc2mac_dat_a_src_data81[7:0])      //|> w
  ,.sc2mac_dat_a_src_data82        (sc2mac_dat_a_src_data82[7:0])      //|> w
  ,.sc2mac_dat_a_src_data83        (sc2mac_dat_a_src_data83[7:0])      //|> w
  ,.sc2mac_dat_a_src_data84        (sc2mac_dat_a_src_data84[7:0])      //|> w
  ,.sc2mac_dat_a_src_data85        (sc2mac_dat_a_src_data85[7:0])      //|> w
  ,.sc2mac_dat_a_src_data86        (sc2mac_dat_a_src_data86[7:0])      //|> w
  ,.sc2mac_dat_a_src_data87        (sc2mac_dat_a_src_data87[7:0])      //|> w
  ,.sc2mac_dat_a_src_data88        (sc2mac_dat_a_src_data88[7:0])      //|> w
  ,.sc2mac_dat_a_src_data89        (sc2mac_dat_a_src_data89[7:0])      //|> w
  ,.sc2mac_dat_a_src_data90        (sc2mac_dat_a_src_data90[7:0])      //|> w
  ,.sc2mac_dat_a_src_data91        (sc2mac_dat_a_src_data91[7:0])      //|> w
  ,.sc2mac_dat_a_src_data92        (sc2mac_dat_a_src_data92[7:0])      //|> w
  ,.sc2mac_dat_a_src_data93        (sc2mac_dat_a_src_data93[7:0])      //|> w
  ,.sc2mac_dat_a_src_data94        (sc2mac_dat_a_src_data94[7:0])      //|> w
  ,.sc2mac_dat_a_src_data95        (sc2mac_dat_a_src_data95[7:0])      //|> w
  ,.sc2mac_dat_a_src_data96        (sc2mac_dat_a_src_data96[7:0])      //|> w
  ,.sc2mac_dat_a_src_data97        (sc2mac_dat_a_src_data97[7:0])      //|> w
  ,.sc2mac_dat_a_src_data98        (sc2mac_dat_a_src_data98[7:0])      //|> w
  ,.sc2mac_dat_a_src_data99        (sc2mac_dat_a_src_data99[7:0])      //|> w
  ,.sc2mac_dat_a_src_data100       (sc2mac_dat_a_src_data100[7:0])     //|> w
  ,.sc2mac_dat_a_src_data101       (sc2mac_dat_a_src_data101[7:0])     //|> w
  ,.sc2mac_dat_a_src_data102       (sc2mac_dat_a_src_data102[7:0])     //|> w
  ,.sc2mac_dat_a_src_data103       (sc2mac_dat_a_src_data103[7:0])     //|> w
  ,.sc2mac_dat_a_src_data104       (sc2mac_dat_a_src_data104[7:0])     //|> w
  ,.sc2mac_dat_a_src_data105       (sc2mac_dat_a_src_data105[7:0])     //|> w
  ,.sc2mac_dat_a_src_data106       (sc2mac_dat_a_src_data106[7:0])     //|> w
  ,.sc2mac_dat_a_src_data107       (sc2mac_dat_a_src_data107[7:0])     //|> w
  ,.sc2mac_dat_a_src_data108       (sc2mac_dat_a_src_data108[7:0])     //|> w
  ,.sc2mac_dat_a_src_data109       (sc2mac_dat_a_src_data109[7:0])     //|> w
  ,.sc2mac_dat_a_src_data110       (sc2mac_dat_a_src_data110[7:0])     //|> w
  ,.sc2mac_dat_a_src_data111       (sc2mac_dat_a_src_data111[7:0])     //|> w
  ,.sc2mac_dat_a_src_data112       (sc2mac_dat_a_src_data112[7:0])     //|> w
  ,.sc2mac_dat_a_src_data113       (sc2mac_dat_a_src_data113[7:0])     //|> w
  ,.sc2mac_dat_a_src_data114       (sc2mac_dat_a_src_data114[7:0])     //|> w
  ,.sc2mac_dat_a_src_data115       (sc2mac_dat_a_src_data115[7:0])     //|> w
  ,.sc2mac_dat_a_src_data116       (sc2mac_dat_a_src_data116[7:0])     //|> w
  ,.sc2mac_dat_a_src_data117       (sc2mac_dat_a_src_data117[7:0])     //|> w
  ,.sc2mac_dat_a_src_data118       (sc2mac_dat_a_src_data118[7:0])     //|> w
  ,.sc2mac_dat_a_src_data119       (sc2mac_dat_a_src_data119[7:0])     //|> w
  ,.sc2mac_dat_a_src_data120       (sc2mac_dat_a_src_data120[7:0])     //|> w
  ,.sc2mac_dat_a_src_data121       (sc2mac_dat_a_src_data121[7:0])     //|> w
  ,.sc2mac_dat_a_src_data122       (sc2mac_dat_a_src_data122[7:0])     //|> w
  ,.sc2mac_dat_a_src_data123       (sc2mac_dat_a_src_data123[7:0])     //|> w
  ,.sc2mac_dat_a_src_data124       (sc2mac_dat_a_src_data124[7:0])     //|> w
  ,.sc2mac_dat_a_src_data125       (sc2mac_dat_a_src_data125[7:0])     //|> w
  ,.sc2mac_dat_a_src_data126       (sc2mac_dat_a_src_data126[7:0])     //|> w
  ,.sc2mac_dat_a_src_data127       (sc2mac_dat_a_src_data127[7:0])     //|> w
  ,.sc2mac_dat_a_src_pd            (sc2mac_dat_a_src_pd[8:0])          //|> w
  ,.sc2mac_dat_b_dst_pvld          (sc2mac_dat_b_dst_pvld)             //|> w
  ,.sc2mac_dat_b_dst_mask          (sc2mac_dat_b_dst_mask[127:0])      //|> w
  ,.sc2mac_dat_b_dst_data0         (sc2mac_dat_b_dst_data0[7:0])       //|> w
  ,.sc2mac_dat_b_dst_data1         (sc2mac_dat_b_dst_data1[7:0])       //|> w
  ,.sc2mac_dat_b_dst_data2         (sc2mac_dat_b_dst_data2[7:0])       //|> w
  ,.sc2mac_dat_b_dst_data3         (sc2mac_dat_b_dst_data3[7:0])       //|> w
  ,.sc2mac_dat_b_dst_data4         (sc2mac_dat_b_dst_data4[7:0])       //|> w
  ,.sc2mac_dat_b_dst_data5         (sc2mac_dat_b_dst_data5[7:0])       //|> w
  ,.sc2mac_dat_b_dst_data6         (sc2mac_dat_b_dst_data6[7:0])       //|> w
  ,.sc2mac_dat_b_dst_data7         (sc2mac_dat_b_dst_data7[7:0])       //|> w
  ,.sc2mac_dat_b_dst_data8         (sc2mac_dat_b_dst_data8[7:0])       //|> w
  ,.sc2mac_dat_b_dst_data9         (sc2mac_dat_b_dst_data9[7:0])       //|> w
  ,.sc2mac_dat_b_dst_data10        (sc2mac_dat_b_dst_data10[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data11        (sc2mac_dat_b_dst_data11[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data12        (sc2mac_dat_b_dst_data12[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data13        (sc2mac_dat_b_dst_data13[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data14        (sc2mac_dat_b_dst_data14[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data15        (sc2mac_dat_b_dst_data15[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data16        (sc2mac_dat_b_dst_data16[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data17        (sc2mac_dat_b_dst_data17[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data18        (sc2mac_dat_b_dst_data18[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data19        (sc2mac_dat_b_dst_data19[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data20        (sc2mac_dat_b_dst_data20[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data21        (sc2mac_dat_b_dst_data21[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data22        (sc2mac_dat_b_dst_data22[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data23        (sc2mac_dat_b_dst_data23[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data24        (sc2mac_dat_b_dst_data24[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data25        (sc2mac_dat_b_dst_data25[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data26        (sc2mac_dat_b_dst_data26[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data27        (sc2mac_dat_b_dst_data27[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data28        (sc2mac_dat_b_dst_data28[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data29        (sc2mac_dat_b_dst_data29[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data30        (sc2mac_dat_b_dst_data30[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data31        (sc2mac_dat_b_dst_data31[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data32        (sc2mac_dat_b_dst_data32[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data33        (sc2mac_dat_b_dst_data33[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data34        (sc2mac_dat_b_dst_data34[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data35        (sc2mac_dat_b_dst_data35[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data36        (sc2mac_dat_b_dst_data36[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data37        (sc2mac_dat_b_dst_data37[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data38        (sc2mac_dat_b_dst_data38[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data39        (sc2mac_dat_b_dst_data39[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data40        (sc2mac_dat_b_dst_data40[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data41        (sc2mac_dat_b_dst_data41[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data42        (sc2mac_dat_b_dst_data42[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data43        (sc2mac_dat_b_dst_data43[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data44        (sc2mac_dat_b_dst_data44[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data45        (sc2mac_dat_b_dst_data45[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data46        (sc2mac_dat_b_dst_data46[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data47        (sc2mac_dat_b_dst_data47[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data48        (sc2mac_dat_b_dst_data48[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data49        (sc2mac_dat_b_dst_data49[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data50        (sc2mac_dat_b_dst_data50[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data51        (sc2mac_dat_b_dst_data51[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data52        (sc2mac_dat_b_dst_data52[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data53        (sc2mac_dat_b_dst_data53[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data54        (sc2mac_dat_b_dst_data54[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data55        (sc2mac_dat_b_dst_data55[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data56        (sc2mac_dat_b_dst_data56[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data57        (sc2mac_dat_b_dst_data57[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data58        (sc2mac_dat_b_dst_data58[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data59        (sc2mac_dat_b_dst_data59[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data60        (sc2mac_dat_b_dst_data60[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data61        (sc2mac_dat_b_dst_data61[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data62        (sc2mac_dat_b_dst_data62[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data63        (sc2mac_dat_b_dst_data63[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data64        (sc2mac_dat_b_dst_data64[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data65        (sc2mac_dat_b_dst_data65[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data66        (sc2mac_dat_b_dst_data66[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data67        (sc2mac_dat_b_dst_data67[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data68        (sc2mac_dat_b_dst_data68[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data69        (sc2mac_dat_b_dst_data69[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data70        (sc2mac_dat_b_dst_data70[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data71        (sc2mac_dat_b_dst_data71[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data72        (sc2mac_dat_b_dst_data72[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data73        (sc2mac_dat_b_dst_data73[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data74        (sc2mac_dat_b_dst_data74[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data75        (sc2mac_dat_b_dst_data75[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data76        (sc2mac_dat_b_dst_data76[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data77        (sc2mac_dat_b_dst_data77[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data78        (sc2mac_dat_b_dst_data78[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data79        (sc2mac_dat_b_dst_data79[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data80        (sc2mac_dat_b_dst_data80[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data81        (sc2mac_dat_b_dst_data81[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data82        (sc2mac_dat_b_dst_data82[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data83        (sc2mac_dat_b_dst_data83[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data84        (sc2mac_dat_b_dst_data84[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data85        (sc2mac_dat_b_dst_data85[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data86        (sc2mac_dat_b_dst_data86[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data87        (sc2mac_dat_b_dst_data87[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data88        (sc2mac_dat_b_dst_data88[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data89        (sc2mac_dat_b_dst_data89[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data90        (sc2mac_dat_b_dst_data90[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data91        (sc2mac_dat_b_dst_data91[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data92        (sc2mac_dat_b_dst_data92[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data93        (sc2mac_dat_b_dst_data93[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data94        (sc2mac_dat_b_dst_data94[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data95        (sc2mac_dat_b_dst_data95[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data96        (sc2mac_dat_b_dst_data96[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data97        (sc2mac_dat_b_dst_data97[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data98        (sc2mac_dat_b_dst_data98[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data99        (sc2mac_dat_b_dst_data99[7:0])      //|> w
  ,.sc2mac_dat_b_dst_data100       (sc2mac_dat_b_dst_data100[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data101       (sc2mac_dat_b_dst_data101[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data102       (sc2mac_dat_b_dst_data102[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data103       (sc2mac_dat_b_dst_data103[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data104       (sc2mac_dat_b_dst_data104[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data105       (sc2mac_dat_b_dst_data105[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data106       (sc2mac_dat_b_dst_data106[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data107       (sc2mac_dat_b_dst_data107[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data108       (sc2mac_dat_b_dst_data108[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data109       (sc2mac_dat_b_dst_data109[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data110       (sc2mac_dat_b_dst_data110[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data111       (sc2mac_dat_b_dst_data111[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data112       (sc2mac_dat_b_dst_data112[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data113       (sc2mac_dat_b_dst_data113[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data114       (sc2mac_dat_b_dst_data114[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data115       (sc2mac_dat_b_dst_data115[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data116       (sc2mac_dat_b_dst_data116[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data117       (sc2mac_dat_b_dst_data117[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data118       (sc2mac_dat_b_dst_data118[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data119       (sc2mac_dat_b_dst_data119[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data120       (sc2mac_dat_b_dst_data120[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data121       (sc2mac_dat_b_dst_data121[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data122       (sc2mac_dat_b_dst_data122[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data123       (sc2mac_dat_b_dst_data123[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data124       (sc2mac_dat_b_dst_data124[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data125       (sc2mac_dat_b_dst_data125[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data126       (sc2mac_dat_b_dst_data126[7:0])     //|> w
  ,.sc2mac_dat_b_dst_data127       (sc2mac_dat_b_dst_data127[7:0])     //|> w
  ,.sc2mac_dat_b_dst_pd            (sc2mac_dat_b_dst_pd[8:0])          //|> w
  ,.sc2mac_wt_a_src_pvld           (sc2mac_wt_a_src_pvld)              //|> w
  ,.sc2mac_wt_a_src_mask           (sc2mac_wt_a_src_mask[127:0])       //|> w
  ,.sc2mac_wt_a_src_data0          (sc2mac_wt_a_src_data0[7:0])        //|> w
  ,.sc2mac_wt_a_src_data1          (sc2mac_wt_a_src_data1[7:0])        //|> w
  ,.sc2mac_wt_a_src_data2          (sc2mac_wt_a_src_data2[7:0])        //|> w
  ,.sc2mac_wt_a_src_data3          (sc2mac_wt_a_src_data3[7:0])        //|> w
  ,.sc2mac_wt_a_src_data4          (sc2mac_wt_a_src_data4[7:0])        //|> w
  ,.sc2mac_wt_a_src_data5          (sc2mac_wt_a_src_data5[7:0])        //|> w
  ,.sc2mac_wt_a_src_data6          (sc2mac_wt_a_src_data6[7:0])        //|> w
  ,.sc2mac_wt_a_src_data7          (sc2mac_wt_a_src_data7[7:0])        //|> w
  ,.sc2mac_wt_a_src_data8          (sc2mac_wt_a_src_data8[7:0])        //|> w
  ,.sc2mac_wt_a_src_data9          (sc2mac_wt_a_src_data9[7:0])        //|> w
  ,.sc2mac_wt_a_src_data10         (sc2mac_wt_a_src_data10[7:0])       //|> w
  ,.sc2mac_wt_a_src_data11         (sc2mac_wt_a_src_data11[7:0])       //|> w
  ,.sc2mac_wt_a_src_data12         (sc2mac_wt_a_src_data12[7:0])       //|> w
  ,.sc2mac_wt_a_src_data13         (sc2mac_wt_a_src_data13[7:0])       //|> w
  ,.sc2mac_wt_a_src_data14         (sc2mac_wt_a_src_data14[7:0])       //|> w
  ,.sc2mac_wt_a_src_data15         (sc2mac_wt_a_src_data15[7:0])       //|> w
  ,.sc2mac_wt_a_src_data16         (sc2mac_wt_a_src_data16[7:0])       //|> w
  ,.sc2mac_wt_a_src_data17         (sc2mac_wt_a_src_data17[7:0])       //|> w
  ,.sc2mac_wt_a_src_data18         (sc2mac_wt_a_src_data18[7:0])       //|> w
  ,.sc2mac_wt_a_src_data19         (sc2mac_wt_a_src_data19[7:0])       //|> w
  ,.sc2mac_wt_a_src_data20         (sc2mac_wt_a_src_data20[7:0])       //|> w
  ,.sc2mac_wt_a_src_data21         (sc2mac_wt_a_src_data21[7:0])       //|> w
  ,.sc2mac_wt_a_src_data22         (sc2mac_wt_a_src_data22[7:0])       //|> w
  ,.sc2mac_wt_a_src_data23         (sc2mac_wt_a_src_data23[7:0])       //|> w
  ,.sc2mac_wt_a_src_data24         (sc2mac_wt_a_src_data24[7:0])       //|> w
  ,.sc2mac_wt_a_src_data25         (sc2mac_wt_a_src_data25[7:0])       //|> w
  ,.sc2mac_wt_a_src_data26         (sc2mac_wt_a_src_data26[7:0])       //|> w
  ,.sc2mac_wt_a_src_data27         (sc2mac_wt_a_src_data27[7:0])       //|> w
  ,.sc2mac_wt_a_src_data28         (sc2mac_wt_a_src_data28[7:0])       //|> w
  ,.sc2mac_wt_a_src_data29         (sc2mac_wt_a_src_data29[7:0])       //|> w
  ,.sc2mac_wt_a_src_data30         (sc2mac_wt_a_src_data30[7:0])       //|> w
  ,.sc2mac_wt_a_src_data31         (sc2mac_wt_a_src_data31[7:0])       //|> w
  ,.sc2mac_wt_a_src_data32         (sc2mac_wt_a_src_data32[7:0])       //|> w
  ,.sc2mac_wt_a_src_data33         (sc2mac_wt_a_src_data33[7:0])       //|> w
  ,.sc2mac_wt_a_src_data34         (sc2mac_wt_a_src_data34[7:0])       //|> w
  ,.sc2mac_wt_a_src_data35         (sc2mac_wt_a_src_data35[7:0])       //|> w
  ,.sc2mac_wt_a_src_data36         (sc2mac_wt_a_src_data36[7:0])       //|> w
  ,.sc2mac_wt_a_src_data37         (sc2mac_wt_a_src_data37[7:0])       //|> w
  ,.sc2mac_wt_a_src_data38         (sc2mac_wt_a_src_data38[7:0])       //|> w
  ,.sc2mac_wt_a_src_data39         (sc2mac_wt_a_src_data39[7:0])       //|> w
  ,.sc2mac_wt_a_src_data40         (sc2mac_wt_a_src_data40[7:0])       //|> w
  ,.sc2mac_wt_a_src_data41         (sc2mac_wt_a_src_data41[7:0])       //|> w
  ,.sc2mac_wt_a_src_data42         (sc2mac_wt_a_src_data42[7:0])       //|> w
  ,.sc2mac_wt_a_src_data43         (sc2mac_wt_a_src_data43[7:0])       //|> w
  ,.sc2mac_wt_a_src_data44         (sc2mac_wt_a_src_data44[7:0])       //|> w
  ,.sc2mac_wt_a_src_data45         (sc2mac_wt_a_src_data45[7:0])       //|> w
  ,.sc2mac_wt_a_src_data46         (sc2mac_wt_a_src_data46[7:0])       //|> w
  ,.sc2mac_wt_a_src_data47         (sc2mac_wt_a_src_data47[7:0])       //|> w
  ,.sc2mac_wt_a_src_data48         (sc2mac_wt_a_src_data48[7:0])       //|> w
  ,.sc2mac_wt_a_src_data49         (sc2mac_wt_a_src_data49[7:0])       //|> w
  ,.sc2mac_wt_a_src_data50         (sc2mac_wt_a_src_data50[7:0])       //|> w
  ,.sc2mac_wt_a_src_data51         (sc2mac_wt_a_src_data51[7:0])       //|> w
  ,.sc2mac_wt_a_src_data52         (sc2mac_wt_a_src_data52[7:0])       //|> w
  ,.sc2mac_wt_a_src_data53         (sc2mac_wt_a_src_data53[7:0])       //|> w
  ,.sc2mac_wt_a_src_data54         (sc2mac_wt_a_src_data54[7:0])       //|> w
  ,.sc2mac_wt_a_src_data55         (sc2mac_wt_a_src_data55[7:0])       //|> w
  ,.sc2mac_wt_a_src_data56         (sc2mac_wt_a_src_data56[7:0])       //|> w
  ,.sc2mac_wt_a_src_data57         (sc2mac_wt_a_src_data57[7:0])       //|> w
  ,.sc2mac_wt_a_src_data58         (sc2mac_wt_a_src_data58[7:0])       //|> w
  ,.sc2mac_wt_a_src_data59         (sc2mac_wt_a_src_data59[7:0])       //|> w
  ,.sc2mac_wt_a_src_data60         (sc2mac_wt_a_src_data60[7:0])       //|> w
  ,.sc2mac_wt_a_src_data61         (sc2mac_wt_a_src_data61[7:0])       //|> w
  ,.sc2mac_wt_a_src_data62         (sc2mac_wt_a_src_data62[7:0])       //|> w
  ,.sc2mac_wt_a_src_data63         (sc2mac_wt_a_src_data63[7:0])       //|> w
  ,.sc2mac_wt_a_src_data64         (sc2mac_wt_a_src_data64[7:0])       //|> w
  ,.sc2mac_wt_a_src_data65         (sc2mac_wt_a_src_data65[7:0])       //|> w
  ,.sc2mac_wt_a_src_data66         (sc2mac_wt_a_src_data66[7:0])       //|> w
  ,.sc2mac_wt_a_src_data67         (sc2mac_wt_a_src_data67[7:0])       //|> w
  ,.sc2mac_wt_a_src_data68         (sc2mac_wt_a_src_data68[7:0])       //|> w
  ,.sc2mac_wt_a_src_data69         (sc2mac_wt_a_src_data69[7:0])       //|> w
  ,.sc2mac_wt_a_src_data70         (sc2mac_wt_a_src_data70[7:0])       //|> w
  ,.sc2mac_wt_a_src_data71         (sc2mac_wt_a_src_data71[7:0])       //|> w
  ,.sc2mac_wt_a_src_data72         (sc2mac_wt_a_src_data72[7:0])       //|> w
  ,.sc2mac_wt_a_src_data73         (sc2mac_wt_a_src_data73[7:0])       //|> w
  ,.sc2mac_wt_a_src_data74         (sc2mac_wt_a_src_data74[7:0])       //|> w
  ,.sc2mac_wt_a_src_data75         (sc2mac_wt_a_src_data75[7:0])       //|> w
  ,.sc2mac_wt_a_src_data76         (sc2mac_wt_a_src_data76[7:0])       //|> w
  ,.sc2mac_wt_a_src_data77         (sc2mac_wt_a_src_data77[7:0])       //|> w
  ,.sc2mac_wt_a_src_data78         (sc2mac_wt_a_src_data78[7:0])       //|> w
  ,.sc2mac_wt_a_src_data79         (sc2mac_wt_a_src_data79[7:0])       //|> w
  ,.sc2mac_wt_a_src_data80         (sc2mac_wt_a_src_data80[7:0])       //|> w
  ,.sc2mac_wt_a_src_data81         (sc2mac_wt_a_src_data81[7:0])       //|> w
  ,.sc2mac_wt_a_src_data82         (sc2mac_wt_a_src_data82[7:0])       //|> w
  ,.sc2mac_wt_a_src_data83         (sc2mac_wt_a_src_data83[7:0])       //|> w
  ,.sc2mac_wt_a_src_data84         (sc2mac_wt_a_src_data84[7:0])       //|> w
  ,.sc2mac_wt_a_src_data85         (sc2mac_wt_a_src_data85[7:0])       //|> w
  ,.sc2mac_wt_a_src_data86         (sc2mac_wt_a_src_data86[7:0])       //|> w
  ,.sc2mac_wt_a_src_data87         (sc2mac_wt_a_src_data87[7:0])       //|> w
  ,.sc2mac_wt_a_src_data88         (sc2mac_wt_a_src_data88[7:0])       //|> w
  ,.sc2mac_wt_a_src_data89         (sc2mac_wt_a_src_data89[7:0])       //|> w
  ,.sc2mac_wt_a_src_data90         (sc2mac_wt_a_src_data90[7:0])       //|> w
  ,.sc2mac_wt_a_src_data91         (sc2mac_wt_a_src_data91[7:0])       //|> w
  ,.sc2mac_wt_a_src_data92         (sc2mac_wt_a_src_data92[7:0])       //|> w
  ,.sc2mac_wt_a_src_data93         (sc2mac_wt_a_src_data93[7:0])       //|> w
  ,.sc2mac_wt_a_src_data94         (sc2mac_wt_a_src_data94[7:0])       //|> w
  ,.sc2mac_wt_a_src_data95         (sc2mac_wt_a_src_data95[7:0])       //|> w
  ,.sc2mac_wt_a_src_data96         (sc2mac_wt_a_src_data96[7:0])       //|> w
  ,.sc2mac_wt_a_src_data97         (sc2mac_wt_a_src_data97[7:0])       //|> w
  ,.sc2mac_wt_a_src_data98         (sc2mac_wt_a_src_data98[7:0])       //|> w
  ,.sc2mac_wt_a_src_data99         (sc2mac_wt_a_src_data99[7:0])       //|> w
  ,.sc2mac_wt_a_src_data100        (sc2mac_wt_a_src_data100[7:0])      //|> w
  ,.sc2mac_wt_a_src_data101        (sc2mac_wt_a_src_data101[7:0])      //|> w
  ,.sc2mac_wt_a_src_data102        (sc2mac_wt_a_src_data102[7:0])      //|> w
  ,.sc2mac_wt_a_src_data103        (sc2mac_wt_a_src_data103[7:0])      //|> w
  ,.sc2mac_wt_a_src_data104        (sc2mac_wt_a_src_data104[7:0])      //|> w
  ,.sc2mac_wt_a_src_data105        (sc2mac_wt_a_src_data105[7:0])      //|> w
  ,.sc2mac_wt_a_src_data106        (sc2mac_wt_a_src_data106[7:0])      //|> w
  ,.sc2mac_wt_a_src_data107        (sc2mac_wt_a_src_data107[7:0])      //|> w
  ,.sc2mac_wt_a_src_data108        (sc2mac_wt_a_src_data108[7:0])      //|> w
  ,.sc2mac_wt_a_src_data109        (sc2mac_wt_a_src_data109[7:0])      //|> w
  ,.sc2mac_wt_a_src_data110        (sc2mac_wt_a_src_data110[7:0])      //|> w
  ,.sc2mac_wt_a_src_data111        (sc2mac_wt_a_src_data111[7:0])      //|> w
  ,.sc2mac_wt_a_src_data112        (sc2mac_wt_a_src_data112[7:0])      //|> w
  ,.sc2mac_wt_a_src_data113        (sc2mac_wt_a_src_data113[7:0])      //|> w
  ,.sc2mac_wt_a_src_data114        (sc2mac_wt_a_src_data114[7:0])      //|> w
  ,.sc2mac_wt_a_src_data115        (sc2mac_wt_a_src_data115[7:0])      //|> w
  ,.sc2mac_wt_a_src_data116        (sc2mac_wt_a_src_data116[7:0])      //|> w
  ,.sc2mac_wt_a_src_data117        (sc2mac_wt_a_src_data117[7:0])      //|> w
  ,.sc2mac_wt_a_src_data118        (sc2mac_wt_a_src_data118[7:0])      //|> w
  ,.sc2mac_wt_a_src_data119        (sc2mac_wt_a_src_data119[7:0])      //|> w
  ,.sc2mac_wt_a_src_data120        (sc2mac_wt_a_src_data120[7:0])      //|> w
  ,.sc2mac_wt_a_src_data121        (sc2mac_wt_a_src_data121[7:0])      //|> w
  ,.sc2mac_wt_a_src_data122        (sc2mac_wt_a_src_data122[7:0])      //|> w
  ,.sc2mac_wt_a_src_data123        (sc2mac_wt_a_src_data123[7:0])      //|> w
  ,.sc2mac_wt_a_src_data124        (sc2mac_wt_a_src_data124[7:0])      //|> w
  ,.sc2mac_wt_a_src_data125        (sc2mac_wt_a_src_data125[7:0])      //|> w
  ,.sc2mac_wt_a_src_data126        (sc2mac_wt_a_src_data126[7:0])      //|> w
  ,.sc2mac_wt_a_src_data127        (sc2mac_wt_a_src_data127[7:0])      //|> w
  ,.sc2mac_wt_a_src_sel            (sc2mac_wt_a_src_sel[7:0])          //|> w
  ,.sc2mac_wt_b_dst_pvld           (sc2mac_wt_b_dst_pvld)              //|> w
  ,.sc2mac_wt_b_dst_mask           (sc2mac_wt_b_dst_mask[127:0])       //|> w
  ,.sc2mac_wt_b_dst_data0          (sc2mac_wt_b_dst_data0[7:0])        //|> w
  ,.sc2mac_wt_b_dst_data1          (sc2mac_wt_b_dst_data1[7:0])        //|> w
  ,.sc2mac_wt_b_dst_data2          (sc2mac_wt_b_dst_data2[7:0])        //|> w
  ,.sc2mac_wt_b_dst_data3          (sc2mac_wt_b_dst_data3[7:0])        //|> w
  ,.sc2mac_wt_b_dst_data4          (sc2mac_wt_b_dst_data4[7:0])        //|> w
  ,.sc2mac_wt_b_dst_data5          (sc2mac_wt_b_dst_data5[7:0])        //|> w
  ,.sc2mac_wt_b_dst_data6          (sc2mac_wt_b_dst_data6[7:0])        //|> w
  ,.sc2mac_wt_b_dst_data7          (sc2mac_wt_b_dst_data7[7:0])        //|> w
  ,.sc2mac_wt_b_dst_data8          (sc2mac_wt_b_dst_data8[7:0])        //|> w
  ,.sc2mac_wt_b_dst_data9          (sc2mac_wt_b_dst_data9[7:0])        //|> w
  ,.sc2mac_wt_b_dst_data10         (sc2mac_wt_b_dst_data10[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data11         (sc2mac_wt_b_dst_data11[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data12         (sc2mac_wt_b_dst_data12[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data13         (sc2mac_wt_b_dst_data13[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data14         (sc2mac_wt_b_dst_data14[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data15         (sc2mac_wt_b_dst_data15[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data16         (sc2mac_wt_b_dst_data16[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data17         (sc2mac_wt_b_dst_data17[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data18         (sc2mac_wt_b_dst_data18[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data19         (sc2mac_wt_b_dst_data19[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data20         (sc2mac_wt_b_dst_data20[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data21         (sc2mac_wt_b_dst_data21[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data22         (sc2mac_wt_b_dst_data22[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data23         (sc2mac_wt_b_dst_data23[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data24         (sc2mac_wt_b_dst_data24[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data25         (sc2mac_wt_b_dst_data25[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data26         (sc2mac_wt_b_dst_data26[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data27         (sc2mac_wt_b_dst_data27[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data28         (sc2mac_wt_b_dst_data28[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data29         (sc2mac_wt_b_dst_data29[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data30         (sc2mac_wt_b_dst_data30[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data31         (sc2mac_wt_b_dst_data31[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data32         (sc2mac_wt_b_dst_data32[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data33         (sc2mac_wt_b_dst_data33[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data34         (sc2mac_wt_b_dst_data34[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data35         (sc2mac_wt_b_dst_data35[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data36         (sc2mac_wt_b_dst_data36[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data37         (sc2mac_wt_b_dst_data37[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data38         (sc2mac_wt_b_dst_data38[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data39         (sc2mac_wt_b_dst_data39[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data40         (sc2mac_wt_b_dst_data40[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data41         (sc2mac_wt_b_dst_data41[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data42         (sc2mac_wt_b_dst_data42[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data43         (sc2mac_wt_b_dst_data43[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data44         (sc2mac_wt_b_dst_data44[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data45         (sc2mac_wt_b_dst_data45[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data46         (sc2mac_wt_b_dst_data46[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data47         (sc2mac_wt_b_dst_data47[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data48         (sc2mac_wt_b_dst_data48[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data49         (sc2mac_wt_b_dst_data49[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data50         (sc2mac_wt_b_dst_data50[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data51         (sc2mac_wt_b_dst_data51[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data52         (sc2mac_wt_b_dst_data52[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data53         (sc2mac_wt_b_dst_data53[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data54         (sc2mac_wt_b_dst_data54[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data55         (sc2mac_wt_b_dst_data55[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data56         (sc2mac_wt_b_dst_data56[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data57         (sc2mac_wt_b_dst_data57[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data58         (sc2mac_wt_b_dst_data58[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data59         (sc2mac_wt_b_dst_data59[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data60         (sc2mac_wt_b_dst_data60[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data61         (sc2mac_wt_b_dst_data61[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data62         (sc2mac_wt_b_dst_data62[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data63         (sc2mac_wt_b_dst_data63[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data64         (sc2mac_wt_b_dst_data64[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data65         (sc2mac_wt_b_dst_data65[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data66         (sc2mac_wt_b_dst_data66[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data67         (sc2mac_wt_b_dst_data67[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data68         (sc2mac_wt_b_dst_data68[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data69         (sc2mac_wt_b_dst_data69[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data70         (sc2mac_wt_b_dst_data70[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data71         (sc2mac_wt_b_dst_data71[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data72         (sc2mac_wt_b_dst_data72[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data73         (sc2mac_wt_b_dst_data73[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data74         (sc2mac_wt_b_dst_data74[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data75         (sc2mac_wt_b_dst_data75[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data76         (sc2mac_wt_b_dst_data76[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data77         (sc2mac_wt_b_dst_data77[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data78         (sc2mac_wt_b_dst_data78[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data79         (sc2mac_wt_b_dst_data79[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data80         (sc2mac_wt_b_dst_data80[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data81         (sc2mac_wt_b_dst_data81[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data82         (sc2mac_wt_b_dst_data82[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data83         (sc2mac_wt_b_dst_data83[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data84         (sc2mac_wt_b_dst_data84[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data85         (sc2mac_wt_b_dst_data85[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data86         (sc2mac_wt_b_dst_data86[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data87         (sc2mac_wt_b_dst_data87[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data88         (sc2mac_wt_b_dst_data88[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data89         (sc2mac_wt_b_dst_data89[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data90         (sc2mac_wt_b_dst_data90[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data91         (sc2mac_wt_b_dst_data91[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data92         (sc2mac_wt_b_dst_data92[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data93         (sc2mac_wt_b_dst_data93[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data94         (sc2mac_wt_b_dst_data94[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data95         (sc2mac_wt_b_dst_data95[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data96         (sc2mac_wt_b_dst_data96[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data97         (sc2mac_wt_b_dst_data97[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data98         (sc2mac_wt_b_dst_data98[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data99         (sc2mac_wt_b_dst_data99[7:0])       //|> w
  ,.sc2mac_wt_b_dst_data100        (sc2mac_wt_b_dst_data100[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data101        (sc2mac_wt_b_dst_data101[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data102        (sc2mac_wt_b_dst_data102[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data103        (sc2mac_wt_b_dst_data103[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data104        (sc2mac_wt_b_dst_data104[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data105        (sc2mac_wt_b_dst_data105[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data106        (sc2mac_wt_b_dst_data106[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data107        (sc2mac_wt_b_dst_data107[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data108        (sc2mac_wt_b_dst_data108[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data109        (sc2mac_wt_b_dst_data109[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data110        (sc2mac_wt_b_dst_data110[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data111        (sc2mac_wt_b_dst_data111[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data112        (sc2mac_wt_b_dst_data112[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data113        (sc2mac_wt_b_dst_data113[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data114        (sc2mac_wt_b_dst_data114[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data115        (sc2mac_wt_b_dst_data115[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data116        (sc2mac_wt_b_dst_data116[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data117        (sc2mac_wt_b_dst_data117[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data118        (sc2mac_wt_b_dst_data118[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data119        (sc2mac_wt_b_dst_data119[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data120        (sc2mac_wt_b_dst_data120[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data121        (sc2mac_wt_b_dst_data121[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data122        (sc2mac_wt_b_dst_data122[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data123        (sc2mac_wt_b_dst_data123[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data124        (sc2mac_wt_b_dst_data124[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data125        (sc2mac_wt_b_dst_data125[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data126        (sc2mac_wt_b_dst_data126[7:0])      //|> w
  ,.sc2mac_wt_b_dst_data127        (sc2mac_wt_b_dst_data127[7:0])      //|> w
  ,.sc2mac_wt_b_dst_sel            (sc2mac_wt_b_dst_sel[7:0])          //|> w
  ,.nvdla_core_clk                 (dla_core_clk)                      //|< i
  ,.dla_reset_rstn                 (nvdla_core_rstn)                   //|< w
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)                  //|< w
  );
    //&Connect /nvdla_obs/        nvdla_pwrpart_c_obs;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition MA                                                //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_m u_partition_ma (
   .test_mode                      (test_mode)                         //|< i
  ,.direct_reset_                  (direct_reset_)                     //|< i
  ,.csb2cmac_a_req_pvld            (csb2cmac_a_req_dst_pvld)           //|< w
  ,.csb2cmac_a_req_prdy            (csb2cmac_a_req_dst_prdy)           //|> w
  ,.csb2cmac_a_req_pd              (csb2cmac_a_req_dst_pd[62:0])       //|< w
  ,.cmac_a2csb_resp_valid          (cmac_a2csb_resp_src_valid)         //|> w
  ,.cmac_a2csb_resp_pd             (cmac_a2csb_resp_src_pd[33:0])      //|> w
  ,.sc2mac_wt_pvld                 (sc2mac_wt_a_dst_pvld)              //|< w
  ,.sc2mac_wt_mask                 (sc2mac_wt_a_dst_mask[127:0])       //|< w
  ,.sc2mac_wt_data0                (sc2mac_wt_a_dst_data0[7:0])        //|< w
  ,.sc2mac_wt_data1                (sc2mac_wt_a_dst_data1[7:0])        //|< w
  ,.sc2mac_wt_data2                (sc2mac_wt_a_dst_data2[7:0])        //|< w
  ,.sc2mac_wt_data3                (sc2mac_wt_a_dst_data3[7:0])        //|< w
  ,.sc2mac_wt_data4                (sc2mac_wt_a_dst_data4[7:0])        //|< w
  ,.sc2mac_wt_data5                (sc2mac_wt_a_dst_data5[7:0])        //|< w
  ,.sc2mac_wt_data6                (sc2mac_wt_a_dst_data6[7:0])        //|< w
  ,.sc2mac_wt_data7                (sc2mac_wt_a_dst_data7[7:0])        //|< w
  ,.sc2mac_wt_data8                (sc2mac_wt_a_dst_data8[7:0])        //|< w
  ,.sc2mac_wt_data9                (sc2mac_wt_a_dst_data9[7:0])        //|< w
  ,.sc2mac_wt_data10               (sc2mac_wt_a_dst_data10[7:0])       //|< w
  ,.sc2mac_wt_data11               (sc2mac_wt_a_dst_data11[7:0])       //|< w
  ,.sc2mac_wt_data12               (sc2mac_wt_a_dst_data12[7:0])       //|< w
  ,.sc2mac_wt_data13               (sc2mac_wt_a_dst_data13[7:0])       //|< w
  ,.sc2mac_wt_data14               (sc2mac_wt_a_dst_data14[7:0])       //|< w
  ,.sc2mac_wt_data15               (sc2mac_wt_a_dst_data15[7:0])       //|< w
  ,.sc2mac_wt_data16               (sc2mac_wt_a_dst_data16[7:0])       //|< w
  ,.sc2mac_wt_data17               (sc2mac_wt_a_dst_data17[7:0])       //|< w
  ,.sc2mac_wt_data18               (sc2mac_wt_a_dst_data18[7:0])       //|< w
  ,.sc2mac_wt_data19               (sc2mac_wt_a_dst_data19[7:0])       //|< w
  ,.sc2mac_wt_data20               (sc2mac_wt_a_dst_data20[7:0])       //|< w
  ,.sc2mac_wt_data21               (sc2mac_wt_a_dst_data21[7:0])       //|< w
  ,.sc2mac_wt_data22               (sc2mac_wt_a_dst_data22[7:0])       //|< w
  ,.sc2mac_wt_data23               (sc2mac_wt_a_dst_data23[7:0])       //|< w
  ,.sc2mac_wt_data24               (sc2mac_wt_a_dst_data24[7:0])       //|< w
  ,.sc2mac_wt_data25               (sc2mac_wt_a_dst_data25[7:0])       //|< w
  ,.sc2mac_wt_data26               (sc2mac_wt_a_dst_data26[7:0])       //|< w
  ,.sc2mac_wt_data27               (sc2mac_wt_a_dst_data27[7:0])       //|< w
  ,.sc2mac_wt_data28               (sc2mac_wt_a_dst_data28[7:0])       //|< w
  ,.sc2mac_wt_data29               (sc2mac_wt_a_dst_data29[7:0])       //|< w
  ,.sc2mac_wt_data30               (sc2mac_wt_a_dst_data30[7:0])       //|< w
  ,.sc2mac_wt_data31               (sc2mac_wt_a_dst_data31[7:0])       //|< w
  ,.sc2mac_wt_data32               (sc2mac_wt_a_dst_data32[7:0])       //|< w
  ,.sc2mac_wt_data33               (sc2mac_wt_a_dst_data33[7:0])       //|< w
  ,.sc2mac_wt_data34               (sc2mac_wt_a_dst_data34[7:0])       //|< w
  ,.sc2mac_wt_data35               (sc2mac_wt_a_dst_data35[7:0])       //|< w
  ,.sc2mac_wt_data36               (sc2mac_wt_a_dst_data36[7:0])       //|< w
  ,.sc2mac_wt_data37               (sc2mac_wt_a_dst_data37[7:0])       //|< w
  ,.sc2mac_wt_data38               (sc2mac_wt_a_dst_data38[7:0])       //|< w
  ,.sc2mac_wt_data39               (sc2mac_wt_a_dst_data39[7:0])       //|< w
  ,.sc2mac_wt_data40               (sc2mac_wt_a_dst_data40[7:0])       //|< w
  ,.sc2mac_wt_data41               (sc2mac_wt_a_dst_data41[7:0])       //|< w
  ,.sc2mac_wt_data42               (sc2mac_wt_a_dst_data42[7:0])       //|< w
  ,.sc2mac_wt_data43               (sc2mac_wt_a_dst_data43[7:0])       //|< w
  ,.sc2mac_wt_data44               (sc2mac_wt_a_dst_data44[7:0])       //|< w
  ,.sc2mac_wt_data45               (sc2mac_wt_a_dst_data45[7:0])       //|< w
  ,.sc2mac_wt_data46               (sc2mac_wt_a_dst_data46[7:0])       //|< w
  ,.sc2mac_wt_data47               (sc2mac_wt_a_dst_data47[7:0])       //|< w
  ,.sc2mac_wt_data48               (sc2mac_wt_a_dst_data48[7:0])       //|< w
  ,.sc2mac_wt_data49               (sc2mac_wt_a_dst_data49[7:0])       //|< w
  ,.sc2mac_wt_data50               (sc2mac_wt_a_dst_data50[7:0])       //|< w
  ,.sc2mac_wt_data51               (sc2mac_wt_a_dst_data51[7:0])       //|< w
  ,.sc2mac_wt_data52               (sc2mac_wt_a_dst_data52[7:0])       //|< w
  ,.sc2mac_wt_data53               (sc2mac_wt_a_dst_data53[7:0])       //|< w
  ,.sc2mac_wt_data54               (sc2mac_wt_a_dst_data54[7:0])       //|< w
  ,.sc2mac_wt_data55               (sc2mac_wt_a_dst_data55[7:0])       //|< w
  ,.sc2mac_wt_data56               (sc2mac_wt_a_dst_data56[7:0])       //|< w
  ,.sc2mac_wt_data57               (sc2mac_wt_a_dst_data57[7:0])       //|< w
  ,.sc2mac_wt_data58               (sc2mac_wt_a_dst_data58[7:0])       //|< w
  ,.sc2mac_wt_data59               (sc2mac_wt_a_dst_data59[7:0])       //|< w
  ,.sc2mac_wt_data60               (sc2mac_wt_a_dst_data60[7:0])       //|< w
  ,.sc2mac_wt_data61               (sc2mac_wt_a_dst_data61[7:0])       //|< w
  ,.sc2mac_wt_data62               (sc2mac_wt_a_dst_data62[7:0])       //|< w
  ,.sc2mac_wt_data63               (sc2mac_wt_a_dst_data63[7:0])       //|< w
  ,.sc2mac_wt_data64               (sc2mac_wt_a_dst_data64[7:0])       //|< w
  ,.sc2mac_wt_data65               (sc2mac_wt_a_dst_data65[7:0])       //|< w
  ,.sc2mac_wt_data66               (sc2mac_wt_a_dst_data66[7:0])       //|< w
  ,.sc2mac_wt_data67               (sc2mac_wt_a_dst_data67[7:0])       //|< w
  ,.sc2mac_wt_data68               (sc2mac_wt_a_dst_data68[7:0])       //|< w
  ,.sc2mac_wt_data69               (sc2mac_wt_a_dst_data69[7:0])       //|< w
  ,.sc2mac_wt_data70               (sc2mac_wt_a_dst_data70[7:0])       //|< w
  ,.sc2mac_wt_data71               (sc2mac_wt_a_dst_data71[7:0])       //|< w
  ,.sc2mac_wt_data72               (sc2mac_wt_a_dst_data72[7:0])       //|< w
  ,.sc2mac_wt_data73               (sc2mac_wt_a_dst_data73[7:0])       //|< w
  ,.sc2mac_wt_data74               (sc2mac_wt_a_dst_data74[7:0])       //|< w
  ,.sc2mac_wt_data75               (sc2mac_wt_a_dst_data75[7:0])       //|< w
  ,.sc2mac_wt_data76               (sc2mac_wt_a_dst_data76[7:0])       //|< w
  ,.sc2mac_wt_data77               (sc2mac_wt_a_dst_data77[7:0])       //|< w
  ,.sc2mac_wt_data78               (sc2mac_wt_a_dst_data78[7:0])       //|< w
  ,.sc2mac_wt_data79               (sc2mac_wt_a_dst_data79[7:0])       //|< w
  ,.sc2mac_wt_data80               (sc2mac_wt_a_dst_data80[7:0])       //|< w
  ,.sc2mac_wt_data81               (sc2mac_wt_a_dst_data81[7:0])       //|< w
  ,.sc2mac_wt_data82               (sc2mac_wt_a_dst_data82[7:0])       //|< w
  ,.sc2mac_wt_data83               (sc2mac_wt_a_dst_data83[7:0])       //|< w
  ,.sc2mac_wt_data84               (sc2mac_wt_a_dst_data84[7:0])       //|< w
  ,.sc2mac_wt_data85               (sc2mac_wt_a_dst_data85[7:0])       //|< w
  ,.sc2mac_wt_data86               (sc2mac_wt_a_dst_data86[7:0])       //|< w
  ,.sc2mac_wt_data87               (sc2mac_wt_a_dst_data87[7:0])       //|< w
  ,.sc2mac_wt_data88               (sc2mac_wt_a_dst_data88[7:0])       //|< w
  ,.sc2mac_wt_data89               (sc2mac_wt_a_dst_data89[7:0])       //|< w
  ,.sc2mac_wt_data90               (sc2mac_wt_a_dst_data90[7:0])       //|< w
  ,.sc2mac_wt_data91               (sc2mac_wt_a_dst_data91[7:0])       //|< w
  ,.sc2mac_wt_data92               (sc2mac_wt_a_dst_data92[7:0])       //|< w
  ,.sc2mac_wt_data93               (sc2mac_wt_a_dst_data93[7:0])       //|< w
  ,.sc2mac_wt_data94               (sc2mac_wt_a_dst_data94[7:0])       //|< w
  ,.sc2mac_wt_data95               (sc2mac_wt_a_dst_data95[7:0])       //|< w
  ,.sc2mac_wt_data96               (sc2mac_wt_a_dst_data96[7:0])       //|< w
  ,.sc2mac_wt_data97               (sc2mac_wt_a_dst_data97[7:0])       //|< w
  ,.sc2mac_wt_data98               (sc2mac_wt_a_dst_data98[7:0])       //|< w
  ,.sc2mac_wt_data99               (sc2mac_wt_a_dst_data99[7:0])       //|< w
  ,.sc2mac_wt_data100              (sc2mac_wt_a_dst_data100[7:0])      //|< w
  ,.sc2mac_wt_data101              (sc2mac_wt_a_dst_data101[7:0])      //|< w
  ,.sc2mac_wt_data102              (sc2mac_wt_a_dst_data102[7:0])      //|< w
  ,.sc2mac_wt_data103              (sc2mac_wt_a_dst_data103[7:0])      //|< w
  ,.sc2mac_wt_data104              (sc2mac_wt_a_dst_data104[7:0])      //|< w
  ,.sc2mac_wt_data105              (sc2mac_wt_a_dst_data105[7:0])      //|< w
  ,.sc2mac_wt_data106              (sc2mac_wt_a_dst_data106[7:0])      //|< w
  ,.sc2mac_wt_data107              (sc2mac_wt_a_dst_data107[7:0])      //|< w
  ,.sc2mac_wt_data108              (sc2mac_wt_a_dst_data108[7:0])      //|< w
  ,.sc2mac_wt_data109              (sc2mac_wt_a_dst_data109[7:0])      //|< w
  ,.sc2mac_wt_data110              (sc2mac_wt_a_dst_data110[7:0])      //|< w
  ,.sc2mac_wt_data111              (sc2mac_wt_a_dst_data111[7:0])      //|< w
  ,.sc2mac_wt_data112              (sc2mac_wt_a_dst_data112[7:0])      //|< w
  ,.sc2mac_wt_data113              (sc2mac_wt_a_dst_data113[7:0])      //|< w
  ,.sc2mac_wt_data114              (sc2mac_wt_a_dst_data114[7:0])      //|< w
  ,.sc2mac_wt_data115              (sc2mac_wt_a_dst_data115[7:0])      //|< w
  ,.sc2mac_wt_data116              (sc2mac_wt_a_dst_data116[7:0])      //|< w
  ,.sc2mac_wt_data117              (sc2mac_wt_a_dst_data117[7:0])      //|< w
  ,.sc2mac_wt_data118              (sc2mac_wt_a_dst_data118[7:0])      //|< w
  ,.sc2mac_wt_data119              (sc2mac_wt_a_dst_data119[7:0])      //|< w
  ,.sc2mac_wt_data120              (sc2mac_wt_a_dst_data120[7:0])      //|< w
  ,.sc2mac_wt_data121              (sc2mac_wt_a_dst_data121[7:0])      //|< w
  ,.sc2mac_wt_data122              (sc2mac_wt_a_dst_data122[7:0])      //|< w
  ,.sc2mac_wt_data123              (sc2mac_wt_a_dst_data123[7:0])      //|< w
  ,.sc2mac_wt_data124              (sc2mac_wt_a_dst_data124[7:0])      //|< w
  ,.sc2mac_wt_data125              (sc2mac_wt_a_dst_data125[7:0])      //|< w
  ,.sc2mac_wt_data126              (sc2mac_wt_a_dst_data126[7:0])      //|< w
  ,.sc2mac_wt_data127              (sc2mac_wt_a_dst_data127[7:0])      //|< w
  ,.sc2mac_wt_sel                  (sc2mac_wt_a_dst_sel[7:0])          //|< w
  ,.sc2mac_dat_pvld                (sc2mac_dat_a_dst_pvld)             //|< w
  ,.sc2mac_dat_mask                (sc2mac_dat_a_dst_mask[127:0])      //|< w
  ,.sc2mac_dat_data0               (sc2mac_dat_a_dst_data0[7:0])       //|< w
  ,.sc2mac_dat_data1               (sc2mac_dat_a_dst_data1[7:0])       //|< w
  ,.sc2mac_dat_data2               (sc2mac_dat_a_dst_data2[7:0])       //|< w
  ,.sc2mac_dat_data3               (sc2mac_dat_a_dst_data3[7:0])       //|< w
  ,.sc2mac_dat_data4               (sc2mac_dat_a_dst_data4[7:0])       //|< w
  ,.sc2mac_dat_data5               (sc2mac_dat_a_dst_data5[7:0])       //|< w
  ,.sc2mac_dat_data6               (sc2mac_dat_a_dst_data6[7:0])       //|< w
  ,.sc2mac_dat_data7               (sc2mac_dat_a_dst_data7[7:0])       //|< w
  ,.sc2mac_dat_data8               (sc2mac_dat_a_dst_data8[7:0])       //|< w
  ,.sc2mac_dat_data9               (sc2mac_dat_a_dst_data9[7:0])       //|< w
  ,.sc2mac_dat_data10              (sc2mac_dat_a_dst_data10[7:0])      //|< w
  ,.sc2mac_dat_data11              (sc2mac_dat_a_dst_data11[7:0])      //|< w
  ,.sc2mac_dat_data12              (sc2mac_dat_a_dst_data12[7:0])      //|< w
  ,.sc2mac_dat_data13              (sc2mac_dat_a_dst_data13[7:0])      //|< w
  ,.sc2mac_dat_data14              (sc2mac_dat_a_dst_data14[7:0])      //|< w
  ,.sc2mac_dat_data15              (sc2mac_dat_a_dst_data15[7:0])      //|< w
  ,.sc2mac_dat_data16              (sc2mac_dat_a_dst_data16[7:0])      //|< w
  ,.sc2mac_dat_data17              (sc2mac_dat_a_dst_data17[7:0])      //|< w
  ,.sc2mac_dat_data18              (sc2mac_dat_a_dst_data18[7:0])      //|< w
  ,.sc2mac_dat_data19              (sc2mac_dat_a_dst_data19[7:0])      //|< w
  ,.sc2mac_dat_data20              (sc2mac_dat_a_dst_data20[7:0])      //|< w
  ,.sc2mac_dat_data21              (sc2mac_dat_a_dst_data21[7:0])      //|< w
  ,.sc2mac_dat_data22              (sc2mac_dat_a_dst_data22[7:0])      //|< w
  ,.sc2mac_dat_data23              (sc2mac_dat_a_dst_data23[7:0])      //|< w
  ,.sc2mac_dat_data24              (sc2mac_dat_a_dst_data24[7:0])      //|< w
  ,.sc2mac_dat_data25              (sc2mac_dat_a_dst_data25[7:0])      //|< w
  ,.sc2mac_dat_data26              (sc2mac_dat_a_dst_data26[7:0])      //|< w
  ,.sc2mac_dat_data27              (sc2mac_dat_a_dst_data27[7:0])      //|< w
  ,.sc2mac_dat_data28              (sc2mac_dat_a_dst_data28[7:0])      //|< w
  ,.sc2mac_dat_data29              (sc2mac_dat_a_dst_data29[7:0])      //|< w
  ,.sc2mac_dat_data30              (sc2mac_dat_a_dst_data30[7:0])      //|< w
  ,.sc2mac_dat_data31              (sc2mac_dat_a_dst_data31[7:0])      //|< w
  ,.sc2mac_dat_data32              (sc2mac_dat_a_dst_data32[7:0])      //|< w
  ,.sc2mac_dat_data33              (sc2mac_dat_a_dst_data33[7:0])      //|< w
  ,.sc2mac_dat_data34              (sc2mac_dat_a_dst_data34[7:0])      //|< w
  ,.sc2mac_dat_data35              (sc2mac_dat_a_dst_data35[7:0])      //|< w
  ,.sc2mac_dat_data36              (sc2mac_dat_a_dst_data36[7:0])      //|< w
  ,.sc2mac_dat_data37              (sc2mac_dat_a_dst_data37[7:0])      //|< w
  ,.sc2mac_dat_data38              (sc2mac_dat_a_dst_data38[7:0])      //|< w
  ,.sc2mac_dat_data39              (sc2mac_dat_a_dst_data39[7:0])      //|< w
  ,.sc2mac_dat_data40              (sc2mac_dat_a_dst_data40[7:0])      //|< w
  ,.sc2mac_dat_data41              (sc2mac_dat_a_dst_data41[7:0])      //|< w
  ,.sc2mac_dat_data42              (sc2mac_dat_a_dst_data42[7:0])      //|< w
  ,.sc2mac_dat_data43              (sc2mac_dat_a_dst_data43[7:0])      //|< w
  ,.sc2mac_dat_data44              (sc2mac_dat_a_dst_data44[7:0])      //|< w
  ,.sc2mac_dat_data45              (sc2mac_dat_a_dst_data45[7:0])      //|< w
  ,.sc2mac_dat_data46              (sc2mac_dat_a_dst_data46[7:0])      //|< w
  ,.sc2mac_dat_data47              (sc2mac_dat_a_dst_data47[7:0])      //|< w
  ,.sc2mac_dat_data48              (sc2mac_dat_a_dst_data48[7:0])      //|< w
  ,.sc2mac_dat_data49              (sc2mac_dat_a_dst_data49[7:0])      //|< w
  ,.sc2mac_dat_data50              (sc2mac_dat_a_dst_data50[7:0])      //|< w
  ,.sc2mac_dat_data51              (sc2mac_dat_a_dst_data51[7:0])      //|< w
  ,.sc2mac_dat_data52              (sc2mac_dat_a_dst_data52[7:0])      //|< w
  ,.sc2mac_dat_data53              (sc2mac_dat_a_dst_data53[7:0])      //|< w
  ,.sc2mac_dat_data54              (sc2mac_dat_a_dst_data54[7:0])      //|< w
  ,.sc2mac_dat_data55              (sc2mac_dat_a_dst_data55[7:0])      //|< w
  ,.sc2mac_dat_data56              (sc2mac_dat_a_dst_data56[7:0])      //|< w
  ,.sc2mac_dat_data57              (sc2mac_dat_a_dst_data57[7:0])      //|< w
  ,.sc2mac_dat_data58              (sc2mac_dat_a_dst_data58[7:0])      //|< w
  ,.sc2mac_dat_data59              (sc2mac_dat_a_dst_data59[7:0])      //|< w
  ,.sc2mac_dat_data60              (sc2mac_dat_a_dst_data60[7:0])      //|< w
  ,.sc2mac_dat_data61              (sc2mac_dat_a_dst_data61[7:0])      //|< w
  ,.sc2mac_dat_data62              (sc2mac_dat_a_dst_data62[7:0])      //|< w
  ,.sc2mac_dat_data63              (sc2mac_dat_a_dst_data63[7:0])      //|< w
  ,.sc2mac_dat_data64              (sc2mac_dat_a_dst_data64[7:0])      //|< w
  ,.sc2mac_dat_data65              (sc2mac_dat_a_dst_data65[7:0])      //|< w
  ,.sc2mac_dat_data66              (sc2mac_dat_a_dst_data66[7:0])      //|< w
  ,.sc2mac_dat_data67              (sc2mac_dat_a_dst_data67[7:0])      //|< w
  ,.sc2mac_dat_data68              (sc2mac_dat_a_dst_data68[7:0])      //|< w
  ,.sc2mac_dat_data69              (sc2mac_dat_a_dst_data69[7:0])      //|< w
  ,.sc2mac_dat_data70              (sc2mac_dat_a_dst_data70[7:0])      //|< w
  ,.sc2mac_dat_data71              (sc2mac_dat_a_dst_data71[7:0])      //|< w
  ,.sc2mac_dat_data72              (sc2mac_dat_a_dst_data72[7:0])      //|< w
  ,.sc2mac_dat_data73              (sc2mac_dat_a_dst_data73[7:0])      //|< w
  ,.sc2mac_dat_data74              (sc2mac_dat_a_dst_data74[7:0])      //|< w
  ,.sc2mac_dat_data75              (sc2mac_dat_a_dst_data75[7:0])      //|< w
  ,.sc2mac_dat_data76              (sc2mac_dat_a_dst_data76[7:0])      //|< w
  ,.sc2mac_dat_data77              (sc2mac_dat_a_dst_data77[7:0])      //|< w
  ,.sc2mac_dat_data78              (sc2mac_dat_a_dst_data78[7:0])      //|< w
  ,.sc2mac_dat_data79              (sc2mac_dat_a_dst_data79[7:0])      //|< w
  ,.sc2mac_dat_data80              (sc2mac_dat_a_dst_data80[7:0])      //|< w
  ,.sc2mac_dat_data81              (sc2mac_dat_a_dst_data81[7:0])      //|< w
  ,.sc2mac_dat_data82              (sc2mac_dat_a_dst_data82[7:0])      //|< w
  ,.sc2mac_dat_data83              (sc2mac_dat_a_dst_data83[7:0])      //|< w
  ,.sc2mac_dat_data84              (sc2mac_dat_a_dst_data84[7:0])      //|< w
  ,.sc2mac_dat_data85              (sc2mac_dat_a_dst_data85[7:0])      //|< w
  ,.sc2mac_dat_data86              (sc2mac_dat_a_dst_data86[7:0])      //|< w
  ,.sc2mac_dat_data87              (sc2mac_dat_a_dst_data87[7:0])      //|< w
  ,.sc2mac_dat_data88              (sc2mac_dat_a_dst_data88[7:0])      //|< w
  ,.sc2mac_dat_data89              (sc2mac_dat_a_dst_data89[7:0])      //|< w
  ,.sc2mac_dat_data90              (sc2mac_dat_a_dst_data90[7:0])      //|< w
  ,.sc2mac_dat_data91              (sc2mac_dat_a_dst_data91[7:0])      //|< w
  ,.sc2mac_dat_data92              (sc2mac_dat_a_dst_data92[7:0])      //|< w
  ,.sc2mac_dat_data93              (sc2mac_dat_a_dst_data93[7:0])      //|< w
  ,.sc2mac_dat_data94              (sc2mac_dat_a_dst_data94[7:0])      //|< w
  ,.sc2mac_dat_data95              (sc2mac_dat_a_dst_data95[7:0])      //|< w
  ,.sc2mac_dat_data96              (sc2mac_dat_a_dst_data96[7:0])      //|< w
  ,.sc2mac_dat_data97              (sc2mac_dat_a_dst_data97[7:0])      //|< w
  ,.sc2mac_dat_data98              (sc2mac_dat_a_dst_data98[7:0])      //|< w
  ,.sc2mac_dat_data99              (sc2mac_dat_a_dst_data99[7:0])      //|< w
  ,.sc2mac_dat_data100             (sc2mac_dat_a_dst_data100[7:0])     //|< w
  ,.sc2mac_dat_data101             (sc2mac_dat_a_dst_data101[7:0])     //|< w
  ,.sc2mac_dat_data102             (sc2mac_dat_a_dst_data102[7:0])     //|< w
  ,.sc2mac_dat_data103             (sc2mac_dat_a_dst_data103[7:0])     //|< w
  ,.sc2mac_dat_data104             (sc2mac_dat_a_dst_data104[7:0])     //|< w
  ,.sc2mac_dat_data105             (sc2mac_dat_a_dst_data105[7:0])     //|< w
  ,.sc2mac_dat_data106             (sc2mac_dat_a_dst_data106[7:0])     //|< w
  ,.sc2mac_dat_data107             (sc2mac_dat_a_dst_data107[7:0])     //|< w
  ,.sc2mac_dat_data108             (sc2mac_dat_a_dst_data108[7:0])     //|< w
  ,.sc2mac_dat_data109             (sc2mac_dat_a_dst_data109[7:0])     //|< w
  ,.sc2mac_dat_data110             (sc2mac_dat_a_dst_data110[7:0])     //|< w
  ,.sc2mac_dat_data111             (sc2mac_dat_a_dst_data111[7:0])     //|< w
  ,.sc2mac_dat_data112             (sc2mac_dat_a_dst_data112[7:0])     //|< w
  ,.sc2mac_dat_data113             (sc2mac_dat_a_dst_data113[7:0])     //|< w
  ,.sc2mac_dat_data114             (sc2mac_dat_a_dst_data114[7:0])     //|< w
  ,.sc2mac_dat_data115             (sc2mac_dat_a_dst_data115[7:0])     //|< w
  ,.sc2mac_dat_data116             (sc2mac_dat_a_dst_data116[7:0])     //|< w
  ,.sc2mac_dat_data117             (sc2mac_dat_a_dst_data117[7:0])     //|< w
  ,.sc2mac_dat_data118             (sc2mac_dat_a_dst_data118[7:0])     //|< w
  ,.sc2mac_dat_data119             (sc2mac_dat_a_dst_data119[7:0])     //|< w
  ,.sc2mac_dat_data120             (sc2mac_dat_a_dst_data120[7:0])     //|< w
  ,.sc2mac_dat_data121             (sc2mac_dat_a_dst_data121[7:0])     //|< w
  ,.sc2mac_dat_data122             (sc2mac_dat_a_dst_data122[7:0])     //|< w
  ,.sc2mac_dat_data123             (sc2mac_dat_a_dst_data123[7:0])     //|< w
  ,.sc2mac_dat_data124             (sc2mac_dat_a_dst_data124[7:0])     //|< w
  ,.sc2mac_dat_data125             (sc2mac_dat_a_dst_data125[7:0])     //|< w
  ,.sc2mac_dat_data126             (sc2mac_dat_a_dst_data126[7:0])     //|< w
  ,.sc2mac_dat_data127             (sc2mac_dat_a_dst_data127[7:0])     //|< w
  ,.sc2mac_dat_pd                  (sc2mac_dat_a_dst_pd[8:0])          //|< w
  ,.mac2accu_pvld                  (mac_a2accu_src_pvld)               //|> w
  ,.mac2accu_mask                  (mac_a2accu_src_mask[7:0])          //|> w
  ,.mac2accu_mode                  (mac_a2accu_src_mode[7:0])          //|> w
  ,.mac2accu_data0                 (mac_a2accu_src_data0[175:0])       //|> w
  ,.mac2accu_data1                 (mac_a2accu_src_data1[175:0])       //|> w
  ,.mac2accu_data2                 (mac_a2accu_src_data2[175:0])       //|> w
  ,.mac2accu_data3                 (mac_a2accu_src_data3[175:0])       //|> w
  ,.mac2accu_data4                 (mac_a2accu_src_data4[175:0])       //|> w
  ,.mac2accu_data5                 (mac_a2accu_src_data5[175:0])       //|> w
  ,.mac2accu_data6                 (mac_a2accu_src_data6[175:0])       //|> w
  ,.mac2accu_data7                 (mac_a2accu_src_data7[175:0])       //|> w
  ,.mac2accu_pd                    (mac_a2accu_src_pd[8:0])            //|> w
  ,.global_clk_ovr_on              (global_clk_ovr_on)                 //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     //|< i
  ,.nvdla_core_clk                 (dla_core_clk)                      //|< i
  ,.dla_reset_rstn                 (nvdla_core_rstn)                   //|< w
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)                  //|< w
  );
    //&Connect -qual !/obs_bus/    /nvdla_obs/        nvdla_pwrpart_ma_obs;
    //&Connect /obs_bus/          nvdla_obs_bus_ma;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition MB                                                //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_m u_partition_mb (
   .test_mode                      (test_mode)                         //|< i
  ,.direct_reset_                  (direct_reset_)                     //|< i
  ,.csb2cmac_a_req_pvld            (csb2cmac_b_req_dst_pvld)           //|< w
  ,.csb2cmac_a_req_prdy            (csb2cmac_b_req_dst_prdy)           //|> w
  ,.csb2cmac_a_req_pd              (csb2cmac_b_req_dst_pd[62:0])       //|< w
  ,.cmac_a2csb_resp_valid          (cmac_b2csb_resp_src_valid)         //|> w
  ,.cmac_a2csb_resp_pd             (cmac_b2csb_resp_src_pd[33:0])      //|> w
  ,.sc2mac_wt_pvld                 (sc2mac_wt_b_dst_pvld)              //|< w
  ,.sc2mac_wt_mask                 (sc2mac_wt_b_dst_mask[127:0])       //|< w
  ,.sc2mac_wt_data0                (sc2mac_wt_b_dst_data0[7:0])        //|< w
  ,.sc2mac_wt_data1                (sc2mac_wt_b_dst_data1[7:0])        //|< w
  ,.sc2mac_wt_data2                (sc2mac_wt_b_dst_data2[7:0])        //|< w
  ,.sc2mac_wt_data3                (sc2mac_wt_b_dst_data3[7:0])        //|< w
  ,.sc2mac_wt_data4                (sc2mac_wt_b_dst_data4[7:0])        //|< w
  ,.sc2mac_wt_data5                (sc2mac_wt_b_dst_data5[7:0])        //|< w
  ,.sc2mac_wt_data6                (sc2mac_wt_b_dst_data6[7:0])        //|< w
  ,.sc2mac_wt_data7                (sc2mac_wt_b_dst_data7[7:0])        //|< w
  ,.sc2mac_wt_data8                (sc2mac_wt_b_dst_data8[7:0])        //|< w
  ,.sc2mac_wt_data9                (sc2mac_wt_b_dst_data9[7:0])        //|< w
  ,.sc2mac_wt_data10               (sc2mac_wt_b_dst_data10[7:0])       //|< w
  ,.sc2mac_wt_data11               (sc2mac_wt_b_dst_data11[7:0])       //|< w
  ,.sc2mac_wt_data12               (sc2mac_wt_b_dst_data12[7:0])       //|< w
  ,.sc2mac_wt_data13               (sc2mac_wt_b_dst_data13[7:0])       //|< w
  ,.sc2mac_wt_data14               (sc2mac_wt_b_dst_data14[7:0])       //|< w
  ,.sc2mac_wt_data15               (sc2mac_wt_b_dst_data15[7:0])       //|< w
  ,.sc2mac_wt_data16               (sc2mac_wt_b_dst_data16[7:0])       //|< w
  ,.sc2mac_wt_data17               (sc2mac_wt_b_dst_data17[7:0])       //|< w
  ,.sc2mac_wt_data18               (sc2mac_wt_b_dst_data18[7:0])       //|< w
  ,.sc2mac_wt_data19               (sc2mac_wt_b_dst_data19[7:0])       //|< w
  ,.sc2mac_wt_data20               (sc2mac_wt_b_dst_data20[7:0])       //|< w
  ,.sc2mac_wt_data21               (sc2mac_wt_b_dst_data21[7:0])       //|< w
  ,.sc2mac_wt_data22               (sc2mac_wt_b_dst_data22[7:0])       //|< w
  ,.sc2mac_wt_data23               (sc2mac_wt_b_dst_data23[7:0])       //|< w
  ,.sc2mac_wt_data24               (sc2mac_wt_b_dst_data24[7:0])       //|< w
  ,.sc2mac_wt_data25               (sc2mac_wt_b_dst_data25[7:0])       //|< w
  ,.sc2mac_wt_data26               (sc2mac_wt_b_dst_data26[7:0])       //|< w
  ,.sc2mac_wt_data27               (sc2mac_wt_b_dst_data27[7:0])       //|< w
  ,.sc2mac_wt_data28               (sc2mac_wt_b_dst_data28[7:0])       //|< w
  ,.sc2mac_wt_data29               (sc2mac_wt_b_dst_data29[7:0])       //|< w
  ,.sc2mac_wt_data30               (sc2mac_wt_b_dst_data30[7:0])       //|< w
  ,.sc2mac_wt_data31               (sc2mac_wt_b_dst_data31[7:0])       //|< w
  ,.sc2mac_wt_data32               (sc2mac_wt_b_dst_data32[7:0])       //|< w
  ,.sc2mac_wt_data33               (sc2mac_wt_b_dst_data33[7:0])       //|< w
  ,.sc2mac_wt_data34               (sc2mac_wt_b_dst_data34[7:0])       //|< w
  ,.sc2mac_wt_data35               (sc2mac_wt_b_dst_data35[7:0])       //|< w
  ,.sc2mac_wt_data36               (sc2mac_wt_b_dst_data36[7:0])       //|< w
  ,.sc2mac_wt_data37               (sc2mac_wt_b_dst_data37[7:0])       //|< w
  ,.sc2mac_wt_data38               (sc2mac_wt_b_dst_data38[7:0])       //|< w
  ,.sc2mac_wt_data39               (sc2mac_wt_b_dst_data39[7:0])       //|< w
  ,.sc2mac_wt_data40               (sc2mac_wt_b_dst_data40[7:0])       //|< w
  ,.sc2mac_wt_data41               (sc2mac_wt_b_dst_data41[7:0])       //|< w
  ,.sc2mac_wt_data42               (sc2mac_wt_b_dst_data42[7:0])       //|< w
  ,.sc2mac_wt_data43               (sc2mac_wt_b_dst_data43[7:0])       //|< w
  ,.sc2mac_wt_data44               (sc2mac_wt_b_dst_data44[7:0])       //|< w
  ,.sc2mac_wt_data45               (sc2mac_wt_b_dst_data45[7:0])       //|< w
  ,.sc2mac_wt_data46               (sc2mac_wt_b_dst_data46[7:0])       //|< w
  ,.sc2mac_wt_data47               (sc2mac_wt_b_dst_data47[7:0])       //|< w
  ,.sc2mac_wt_data48               (sc2mac_wt_b_dst_data48[7:0])       //|< w
  ,.sc2mac_wt_data49               (sc2mac_wt_b_dst_data49[7:0])       //|< w
  ,.sc2mac_wt_data50               (sc2mac_wt_b_dst_data50[7:0])       //|< w
  ,.sc2mac_wt_data51               (sc2mac_wt_b_dst_data51[7:0])       //|< w
  ,.sc2mac_wt_data52               (sc2mac_wt_b_dst_data52[7:0])       //|< w
  ,.sc2mac_wt_data53               (sc2mac_wt_b_dst_data53[7:0])       //|< w
  ,.sc2mac_wt_data54               (sc2mac_wt_b_dst_data54[7:0])       //|< w
  ,.sc2mac_wt_data55               (sc2mac_wt_b_dst_data55[7:0])       //|< w
  ,.sc2mac_wt_data56               (sc2mac_wt_b_dst_data56[7:0])       //|< w
  ,.sc2mac_wt_data57               (sc2mac_wt_b_dst_data57[7:0])       //|< w
  ,.sc2mac_wt_data58               (sc2mac_wt_b_dst_data58[7:0])       //|< w
  ,.sc2mac_wt_data59               (sc2mac_wt_b_dst_data59[7:0])       //|< w
  ,.sc2mac_wt_data60               (sc2mac_wt_b_dst_data60[7:0])       //|< w
  ,.sc2mac_wt_data61               (sc2mac_wt_b_dst_data61[7:0])       //|< w
  ,.sc2mac_wt_data62               (sc2mac_wt_b_dst_data62[7:0])       //|< w
  ,.sc2mac_wt_data63               (sc2mac_wt_b_dst_data63[7:0])       //|< w
  ,.sc2mac_wt_data64               (sc2mac_wt_b_dst_data64[7:0])       //|< w
  ,.sc2mac_wt_data65               (sc2mac_wt_b_dst_data65[7:0])       //|< w
  ,.sc2mac_wt_data66               (sc2mac_wt_b_dst_data66[7:0])       //|< w
  ,.sc2mac_wt_data67               (sc2mac_wt_b_dst_data67[7:0])       //|< w
  ,.sc2mac_wt_data68               (sc2mac_wt_b_dst_data68[7:0])       //|< w
  ,.sc2mac_wt_data69               (sc2mac_wt_b_dst_data69[7:0])       //|< w
  ,.sc2mac_wt_data70               (sc2mac_wt_b_dst_data70[7:0])       //|< w
  ,.sc2mac_wt_data71               (sc2mac_wt_b_dst_data71[7:0])       //|< w
  ,.sc2mac_wt_data72               (sc2mac_wt_b_dst_data72[7:0])       //|< w
  ,.sc2mac_wt_data73               (sc2mac_wt_b_dst_data73[7:0])       //|< w
  ,.sc2mac_wt_data74               (sc2mac_wt_b_dst_data74[7:0])       //|< w
  ,.sc2mac_wt_data75               (sc2mac_wt_b_dst_data75[7:0])       //|< w
  ,.sc2mac_wt_data76               (sc2mac_wt_b_dst_data76[7:0])       //|< w
  ,.sc2mac_wt_data77               (sc2mac_wt_b_dst_data77[7:0])       //|< w
  ,.sc2mac_wt_data78               (sc2mac_wt_b_dst_data78[7:0])       //|< w
  ,.sc2mac_wt_data79               (sc2mac_wt_b_dst_data79[7:0])       //|< w
  ,.sc2mac_wt_data80               (sc2mac_wt_b_dst_data80[7:0])       //|< w
  ,.sc2mac_wt_data81               (sc2mac_wt_b_dst_data81[7:0])       //|< w
  ,.sc2mac_wt_data82               (sc2mac_wt_b_dst_data82[7:0])       //|< w
  ,.sc2mac_wt_data83               (sc2mac_wt_b_dst_data83[7:0])       //|< w
  ,.sc2mac_wt_data84               (sc2mac_wt_b_dst_data84[7:0])       //|< w
  ,.sc2mac_wt_data85               (sc2mac_wt_b_dst_data85[7:0])       //|< w
  ,.sc2mac_wt_data86               (sc2mac_wt_b_dst_data86[7:0])       //|< w
  ,.sc2mac_wt_data87               (sc2mac_wt_b_dst_data87[7:0])       //|< w
  ,.sc2mac_wt_data88               (sc2mac_wt_b_dst_data88[7:0])       //|< w
  ,.sc2mac_wt_data89               (sc2mac_wt_b_dst_data89[7:0])       //|< w
  ,.sc2mac_wt_data90               (sc2mac_wt_b_dst_data90[7:0])       //|< w
  ,.sc2mac_wt_data91               (sc2mac_wt_b_dst_data91[7:0])       //|< w
  ,.sc2mac_wt_data92               (sc2mac_wt_b_dst_data92[7:0])       //|< w
  ,.sc2mac_wt_data93               (sc2mac_wt_b_dst_data93[7:0])       //|< w
  ,.sc2mac_wt_data94               (sc2mac_wt_b_dst_data94[7:0])       //|< w
  ,.sc2mac_wt_data95               (sc2mac_wt_b_dst_data95[7:0])       //|< w
  ,.sc2mac_wt_data96               (sc2mac_wt_b_dst_data96[7:0])       //|< w
  ,.sc2mac_wt_data97               (sc2mac_wt_b_dst_data97[7:0])       //|< w
  ,.sc2mac_wt_data98               (sc2mac_wt_b_dst_data98[7:0])       //|< w
  ,.sc2mac_wt_data99               (sc2mac_wt_b_dst_data99[7:0])       //|< w
  ,.sc2mac_wt_data100              (sc2mac_wt_b_dst_data100[7:0])      //|< w
  ,.sc2mac_wt_data101              (sc2mac_wt_b_dst_data101[7:0])      //|< w
  ,.sc2mac_wt_data102              (sc2mac_wt_b_dst_data102[7:0])      //|< w
  ,.sc2mac_wt_data103              (sc2mac_wt_b_dst_data103[7:0])      //|< w
  ,.sc2mac_wt_data104              (sc2mac_wt_b_dst_data104[7:0])      //|< w
  ,.sc2mac_wt_data105              (sc2mac_wt_b_dst_data105[7:0])      //|< w
  ,.sc2mac_wt_data106              (sc2mac_wt_b_dst_data106[7:0])      //|< w
  ,.sc2mac_wt_data107              (sc2mac_wt_b_dst_data107[7:0])      //|< w
  ,.sc2mac_wt_data108              (sc2mac_wt_b_dst_data108[7:0])      //|< w
  ,.sc2mac_wt_data109              (sc2mac_wt_b_dst_data109[7:0])      //|< w
  ,.sc2mac_wt_data110              (sc2mac_wt_b_dst_data110[7:0])      //|< w
  ,.sc2mac_wt_data111              (sc2mac_wt_b_dst_data111[7:0])      //|< w
  ,.sc2mac_wt_data112              (sc2mac_wt_b_dst_data112[7:0])      //|< w
  ,.sc2mac_wt_data113              (sc2mac_wt_b_dst_data113[7:0])      //|< w
  ,.sc2mac_wt_data114              (sc2mac_wt_b_dst_data114[7:0])      //|< w
  ,.sc2mac_wt_data115              (sc2mac_wt_b_dst_data115[7:0])      //|< w
  ,.sc2mac_wt_data116              (sc2mac_wt_b_dst_data116[7:0])      //|< w
  ,.sc2mac_wt_data117              (sc2mac_wt_b_dst_data117[7:0])      //|< w
  ,.sc2mac_wt_data118              (sc2mac_wt_b_dst_data118[7:0])      //|< w
  ,.sc2mac_wt_data119              (sc2mac_wt_b_dst_data119[7:0])      //|< w
  ,.sc2mac_wt_data120              (sc2mac_wt_b_dst_data120[7:0])      //|< w
  ,.sc2mac_wt_data121              (sc2mac_wt_b_dst_data121[7:0])      //|< w
  ,.sc2mac_wt_data122              (sc2mac_wt_b_dst_data122[7:0])      //|< w
  ,.sc2mac_wt_data123              (sc2mac_wt_b_dst_data123[7:0])      //|< w
  ,.sc2mac_wt_data124              (sc2mac_wt_b_dst_data124[7:0])      //|< w
  ,.sc2mac_wt_data125              (sc2mac_wt_b_dst_data125[7:0])      //|< w
  ,.sc2mac_wt_data126              (sc2mac_wt_b_dst_data126[7:0])      //|< w
  ,.sc2mac_wt_data127              (sc2mac_wt_b_dst_data127[7:0])      //|< w
  ,.sc2mac_wt_sel                  (sc2mac_wt_b_dst_sel[7:0])          //|< w
  ,.sc2mac_dat_pvld                (sc2mac_dat_b_dst_pvld)             //|< w
  ,.sc2mac_dat_mask                (sc2mac_dat_b_dst_mask[127:0])      //|< w
  ,.sc2mac_dat_data0               (sc2mac_dat_b_dst_data0[7:0])       //|< w
  ,.sc2mac_dat_data1               (sc2mac_dat_b_dst_data1[7:0])       //|< w
  ,.sc2mac_dat_data2               (sc2mac_dat_b_dst_data2[7:0])       //|< w
  ,.sc2mac_dat_data3               (sc2mac_dat_b_dst_data3[7:0])       //|< w
  ,.sc2mac_dat_data4               (sc2mac_dat_b_dst_data4[7:0])       //|< w
  ,.sc2mac_dat_data5               (sc2mac_dat_b_dst_data5[7:0])       //|< w
  ,.sc2mac_dat_data6               (sc2mac_dat_b_dst_data6[7:0])       //|< w
  ,.sc2mac_dat_data7               (sc2mac_dat_b_dst_data7[7:0])       //|< w
  ,.sc2mac_dat_data8               (sc2mac_dat_b_dst_data8[7:0])       //|< w
  ,.sc2mac_dat_data9               (sc2mac_dat_b_dst_data9[7:0])       //|< w
  ,.sc2mac_dat_data10              (sc2mac_dat_b_dst_data10[7:0])      //|< w
  ,.sc2mac_dat_data11              (sc2mac_dat_b_dst_data11[7:0])      //|< w
  ,.sc2mac_dat_data12              (sc2mac_dat_b_dst_data12[7:0])      //|< w
  ,.sc2mac_dat_data13              (sc2mac_dat_b_dst_data13[7:0])      //|< w
  ,.sc2mac_dat_data14              (sc2mac_dat_b_dst_data14[7:0])      //|< w
  ,.sc2mac_dat_data15              (sc2mac_dat_b_dst_data15[7:0])      //|< w
  ,.sc2mac_dat_data16              (sc2mac_dat_b_dst_data16[7:0])      //|< w
  ,.sc2mac_dat_data17              (sc2mac_dat_b_dst_data17[7:0])      //|< w
  ,.sc2mac_dat_data18              (sc2mac_dat_b_dst_data18[7:0])      //|< w
  ,.sc2mac_dat_data19              (sc2mac_dat_b_dst_data19[7:0])      //|< w
  ,.sc2mac_dat_data20              (sc2mac_dat_b_dst_data20[7:0])      //|< w
  ,.sc2mac_dat_data21              (sc2mac_dat_b_dst_data21[7:0])      //|< w
  ,.sc2mac_dat_data22              (sc2mac_dat_b_dst_data22[7:0])      //|< w
  ,.sc2mac_dat_data23              (sc2mac_dat_b_dst_data23[7:0])      //|< w
  ,.sc2mac_dat_data24              (sc2mac_dat_b_dst_data24[7:0])      //|< w
  ,.sc2mac_dat_data25              (sc2mac_dat_b_dst_data25[7:0])      //|< w
  ,.sc2mac_dat_data26              (sc2mac_dat_b_dst_data26[7:0])      //|< w
  ,.sc2mac_dat_data27              (sc2mac_dat_b_dst_data27[7:0])      //|< w
  ,.sc2mac_dat_data28              (sc2mac_dat_b_dst_data28[7:0])      //|< w
  ,.sc2mac_dat_data29              (sc2mac_dat_b_dst_data29[7:0])      //|< w
  ,.sc2mac_dat_data30              (sc2mac_dat_b_dst_data30[7:0])      //|< w
  ,.sc2mac_dat_data31              (sc2mac_dat_b_dst_data31[7:0])      //|< w
  ,.sc2mac_dat_data32              (sc2mac_dat_b_dst_data32[7:0])      //|< w
  ,.sc2mac_dat_data33              (sc2mac_dat_b_dst_data33[7:0])      //|< w
  ,.sc2mac_dat_data34              (sc2mac_dat_b_dst_data34[7:0])      //|< w
  ,.sc2mac_dat_data35              (sc2mac_dat_b_dst_data35[7:0])      //|< w
  ,.sc2mac_dat_data36              (sc2mac_dat_b_dst_data36[7:0])      //|< w
  ,.sc2mac_dat_data37              (sc2mac_dat_b_dst_data37[7:0])      //|< w
  ,.sc2mac_dat_data38              (sc2mac_dat_b_dst_data38[7:0])      //|< w
  ,.sc2mac_dat_data39              (sc2mac_dat_b_dst_data39[7:0])      //|< w
  ,.sc2mac_dat_data40              (sc2mac_dat_b_dst_data40[7:0])      //|< w
  ,.sc2mac_dat_data41              (sc2mac_dat_b_dst_data41[7:0])      //|< w
  ,.sc2mac_dat_data42              (sc2mac_dat_b_dst_data42[7:0])      //|< w
  ,.sc2mac_dat_data43              (sc2mac_dat_b_dst_data43[7:0])      //|< w
  ,.sc2mac_dat_data44              (sc2mac_dat_b_dst_data44[7:0])      //|< w
  ,.sc2mac_dat_data45              (sc2mac_dat_b_dst_data45[7:0])      //|< w
  ,.sc2mac_dat_data46              (sc2mac_dat_b_dst_data46[7:0])      //|< w
  ,.sc2mac_dat_data47              (sc2mac_dat_b_dst_data47[7:0])      //|< w
  ,.sc2mac_dat_data48              (sc2mac_dat_b_dst_data48[7:0])      //|< w
  ,.sc2mac_dat_data49              (sc2mac_dat_b_dst_data49[7:0])      //|< w
  ,.sc2mac_dat_data50              (sc2mac_dat_b_dst_data50[7:0])      //|< w
  ,.sc2mac_dat_data51              (sc2mac_dat_b_dst_data51[7:0])      //|< w
  ,.sc2mac_dat_data52              (sc2mac_dat_b_dst_data52[7:0])      //|< w
  ,.sc2mac_dat_data53              (sc2mac_dat_b_dst_data53[7:0])      //|< w
  ,.sc2mac_dat_data54              (sc2mac_dat_b_dst_data54[7:0])      //|< w
  ,.sc2mac_dat_data55              (sc2mac_dat_b_dst_data55[7:0])      //|< w
  ,.sc2mac_dat_data56              (sc2mac_dat_b_dst_data56[7:0])      //|< w
  ,.sc2mac_dat_data57              (sc2mac_dat_b_dst_data57[7:0])      //|< w
  ,.sc2mac_dat_data58              (sc2mac_dat_b_dst_data58[7:0])      //|< w
  ,.sc2mac_dat_data59              (sc2mac_dat_b_dst_data59[7:0])      //|< w
  ,.sc2mac_dat_data60              (sc2mac_dat_b_dst_data60[7:0])      //|< w
  ,.sc2mac_dat_data61              (sc2mac_dat_b_dst_data61[7:0])      //|< w
  ,.sc2mac_dat_data62              (sc2mac_dat_b_dst_data62[7:0])      //|< w
  ,.sc2mac_dat_data63              (sc2mac_dat_b_dst_data63[7:0])      //|< w
  ,.sc2mac_dat_data64              (sc2mac_dat_b_dst_data64[7:0])      //|< w
  ,.sc2mac_dat_data65              (sc2mac_dat_b_dst_data65[7:0])      //|< w
  ,.sc2mac_dat_data66              (sc2mac_dat_b_dst_data66[7:0])      //|< w
  ,.sc2mac_dat_data67              (sc2mac_dat_b_dst_data67[7:0])      //|< w
  ,.sc2mac_dat_data68              (sc2mac_dat_b_dst_data68[7:0])      //|< w
  ,.sc2mac_dat_data69              (sc2mac_dat_b_dst_data69[7:0])      //|< w
  ,.sc2mac_dat_data70              (sc2mac_dat_b_dst_data70[7:0])      //|< w
  ,.sc2mac_dat_data71              (sc2mac_dat_b_dst_data71[7:0])      //|< w
  ,.sc2mac_dat_data72              (sc2mac_dat_b_dst_data72[7:0])      //|< w
  ,.sc2mac_dat_data73              (sc2mac_dat_b_dst_data73[7:0])      //|< w
  ,.sc2mac_dat_data74              (sc2mac_dat_b_dst_data74[7:0])      //|< w
  ,.sc2mac_dat_data75              (sc2mac_dat_b_dst_data75[7:0])      //|< w
  ,.sc2mac_dat_data76              (sc2mac_dat_b_dst_data76[7:0])      //|< w
  ,.sc2mac_dat_data77              (sc2mac_dat_b_dst_data77[7:0])      //|< w
  ,.sc2mac_dat_data78              (sc2mac_dat_b_dst_data78[7:0])      //|< w
  ,.sc2mac_dat_data79              (sc2mac_dat_b_dst_data79[7:0])      //|< w
  ,.sc2mac_dat_data80              (sc2mac_dat_b_dst_data80[7:0])      //|< w
  ,.sc2mac_dat_data81              (sc2mac_dat_b_dst_data81[7:0])      //|< w
  ,.sc2mac_dat_data82              (sc2mac_dat_b_dst_data82[7:0])      //|< w
  ,.sc2mac_dat_data83              (sc2mac_dat_b_dst_data83[7:0])      //|< w
  ,.sc2mac_dat_data84              (sc2mac_dat_b_dst_data84[7:0])      //|< w
  ,.sc2mac_dat_data85              (sc2mac_dat_b_dst_data85[7:0])      //|< w
  ,.sc2mac_dat_data86              (sc2mac_dat_b_dst_data86[7:0])      //|< w
  ,.sc2mac_dat_data87              (sc2mac_dat_b_dst_data87[7:0])      //|< w
  ,.sc2mac_dat_data88              (sc2mac_dat_b_dst_data88[7:0])      //|< w
  ,.sc2mac_dat_data89              (sc2mac_dat_b_dst_data89[7:0])      //|< w
  ,.sc2mac_dat_data90              (sc2mac_dat_b_dst_data90[7:0])      //|< w
  ,.sc2mac_dat_data91              (sc2mac_dat_b_dst_data91[7:0])      //|< w
  ,.sc2mac_dat_data92              (sc2mac_dat_b_dst_data92[7:0])      //|< w
  ,.sc2mac_dat_data93              (sc2mac_dat_b_dst_data93[7:0])      //|< w
  ,.sc2mac_dat_data94              (sc2mac_dat_b_dst_data94[7:0])      //|< w
  ,.sc2mac_dat_data95              (sc2mac_dat_b_dst_data95[7:0])      //|< w
  ,.sc2mac_dat_data96              (sc2mac_dat_b_dst_data96[7:0])      //|< w
  ,.sc2mac_dat_data97              (sc2mac_dat_b_dst_data97[7:0])      //|< w
  ,.sc2mac_dat_data98              (sc2mac_dat_b_dst_data98[7:0])      //|< w
  ,.sc2mac_dat_data99              (sc2mac_dat_b_dst_data99[7:0])      //|< w
  ,.sc2mac_dat_data100             (sc2mac_dat_b_dst_data100[7:0])     //|< w
  ,.sc2mac_dat_data101             (sc2mac_dat_b_dst_data101[7:0])     //|< w
  ,.sc2mac_dat_data102             (sc2mac_dat_b_dst_data102[7:0])     //|< w
  ,.sc2mac_dat_data103             (sc2mac_dat_b_dst_data103[7:0])     //|< w
  ,.sc2mac_dat_data104             (sc2mac_dat_b_dst_data104[7:0])     //|< w
  ,.sc2mac_dat_data105             (sc2mac_dat_b_dst_data105[7:0])     //|< w
  ,.sc2mac_dat_data106             (sc2mac_dat_b_dst_data106[7:0])     //|< w
  ,.sc2mac_dat_data107             (sc2mac_dat_b_dst_data107[7:0])     //|< w
  ,.sc2mac_dat_data108             (sc2mac_dat_b_dst_data108[7:0])     //|< w
  ,.sc2mac_dat_data109             (sc2mac_dat_b_dst_data109[7:0])     //|< w
  ,.sc2mac_dat_data110             (sc2mac_dat_b_dst_data110[7:0])     //|< w
  ,.sc2mac_dat_data111             (sc2mac_dat_b_dst_data111[7:0])     //|< w
  ,.sc2mac_dat_data112             (sc2mac_dat_b_dst_data112[7:0])     //|< w
  ,.sc2mac_dat_data113             (sc2mac_dat_b_dst_data113[7:0])     //|< w
  ,.sc2mac_dat_data114             (sc2mac_dat_b_dst_data114[7:0])     //|< w
  ,.sc2mac_dat_data115             (sc2mac_dat_b_dst_data115[7:0])     //|< w
  ,.sc2mac_dat_data116             (sc2mac_dat_b_dst_data116[7:0])     //|< w
  ,.sc2mac_dat_data117             (sc2mac_dat_b_dst_data117[7:0])     //|< w
  ,.sc2mac_dat_data118             (sc2mac_dat_b_dst_data118[7:0])     //|< w
  ,.sc2mac_dat_data119             (sc2mac_dat_b_dst_data119[7:0])     //|< w
  ,.sc2mac_dat_data120             (sc2mac_dat_b_dst_data120[7:0])     //|< w
  ,.sc2mac_dat_data121             (sc2mac_dat_b_dst_data121[7:0])     //|< w
  ,.sc2mac_dat_data122             (sc2mac_dat_b_dst_data122[7:0])     //|< w
  ,.sc2mac_dat_data123             (sc2mac_dat_b_dst_data123[7:0])     //|< w
  ,.sc2mac_dat_data124             (sc2mac_dat_b_dst_data124[7:0])     //|< w
  ,.sc2mac_dat_data125             (sc2mac_dat_b_dst_data125[7:0])     //|< w
  ,.sc2mac_dat_data126             (sc2mac_dat_b_dst_data126[7:0])     //|< w
  ,.sc2mac_dat_data127             (sc2mac_dat_b_dst_data127[7:0])     //|< w
  ,.sc2mac_dat_pd                  (sc2mac_dat_b_dst_pd[8:0])          //|< w
  ,.mac2accu_pvld                  (mac_b2accu_src_pvld)               //|> w
  ,.mac2accu_mask                  (mac_b2accu_src_mask[7:0])          //|> w
  ,.mac2accu_mode                  (mac_b2accu_src_mode[7:0])          //|> w
  ,.mac2accu_data0                 (mac_b2accu_src_data0[175:0])       //|> w
  ,.mac2accu_data1                 (mac_b2accu_src_data1[175:0])       //|> w
  ,.mac2accu_data2                 (mac_b2accu_src_data2[175:0])       //|> w
  ,.mac2accu_data3                 (mac_b2accu_src_data3[175:0])       //|> w
  ,.mac2accu_data4                 (mac_b2accu_src_data4[175:0])       //|> w
  ,.mac2accu_data5                 (mac_b2accu_src_data5[175:0])       //|> w
  ,.mac2accu_data6                 (mac_b2accu_src_data6[175:0])       //|> w
  ,.mac2accu_data7                 (mac_b2accu_src_data7[175:0])       //|> w
  ,.mac2accu_pd                    (mac_b2accu_src_pd[8:0])            //|> w
  ,.global_clk_ovr_on              (global_clk_ovr_on)                 //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     //|< i
  ,.nvdla_core_clk                 (dla_core_clk)                      //|< i
  ,.dla_reset_rstn                 (nvdla_core_rstn)                   //|< w
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)                  //|< w
  );
    //&Connect -qual !/obs_bus/    /nvdla_obs/        nvdla_pwrpart_mb_obs;
    //&Connect /obs_bus/          nvdla_obs_bus_mb;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition A                                                 //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_a u_partition_a (
   .test_mode                      (test_mode)                         //|< i
  ,.direct_reset_                  (direct_reset_)                     //|< i
  ,.global_clk_ovr_on              (global_clk_ovr_on)                 //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     //|< i
  ,.accu2sc_credit_vld             (accu2sc_credit_vld)                //|> w
  ,.accu2sc_credit_size            (accu2sc_credit_size[2:0])          //|> w
  ,.cacc2csb_resp_src_valid        (cacc2csb_resp_src_valid)           //|> w
  ,.cacc2csb_resp_src_pd           (cacc2csb_resp_src_pd[33:0])        //|> w
  ,.cacc2glb_done_intr_src_pd      (cacc2glb_done_intr_src_pd[1:0])    //|> w
  ,.cacc2sdp_valid                 (cacc2sdp_valid)                    //|> w
  ,.cacc2sdp_ready                 (cacc2sdp_ready)                    //|< w
  ,.cacc2sdp_pd                    (cacc2sdp_pd[513:0])                //|> w
  ,.csb2cacc_req_dst_pvld          (csb2cacc_req_dst_pvld)             //|< w
  ,.csb2cacc_req_dst_prdy          (csb2cacc_req_dst_prdy)             //|> w
  ,.csb2cacc_req_dst_pd            (csb2cacc_req_dst_pd[62:0])         //|< w
  ,.mac_a2accu_dst_pvld            (mac_a2accu_dst_pvld)               //|< w
  ,.mac_a2accu_dst_mask            (mac_a2accu_dst_mask[7:0])          //|< w
  ,.mac_a2accu_dst_mode            (mac_a2accu_dst_mode[7:0])          //|< w
  ,.mac_a2accu_dst_data0           (mac_a2accu_dst_data0[175:0])       //|< w
  ,.mac_a2accu_dst_data1           (mac_a2accu_dst_data1[175:0])       //|< w
  ,.mac_a2accu_dst_data2           (mac_a2accu_dst_data2[175:0])       //|< w
  ,.mac_a2accu_dst_data3           (mac_a2accu_dst_data3[175:0])       //|< w
  ,.mac_a2accu_dst_data4           (mac_a2accu_dst_data4[175:0])       //|< w
  ,.mac_a2accu_dst_data5           (mac_a2accu_dst_data5[175:0])       //|< w
  ,.mac_a2accu_dst_data6           (mac_a2accu_dst_data6[175:0])       //|< w
  ,.mac_a2accu_dst_data7           (mac_a2accu_dst_data7[175:0])       //|< w
  ,.mac_a2accu_dst_pd              (mac_a2accu_dst_pd[8:0])            //|< w
  ,.mac_b2accu_src_pvld            (mac_b2accu_src_pvld)               //|< w
  ,.mac_b2accu_src_mask            (mac_b2accu_src_mask[7:0])          //|< w
  ,.mac_b2accu_src_mode            (mac_b2accu_src_mode[7:0])          //|< w
  ,.mac_b2accu_src_data0           (mac_b2accu_src_data0[175:0])       //|< w
  ,.mac_b2accu_src_data1           (mac_b2accu_src_data1[175:0])       //|< w
  ,.mac_b2accu_src_data2           (mac_b2accu_src_data2[175:0])       //|< w
  ,.mac_b2accu_src_data3           (mac_b2accu_src_data3[175:0])       //|< w
  ,.mac_b2accu_src_data4           (mac_b2accu_src_data4[175:0])       //|< w
  ,.mac_b2accu_src_data5           (mac_b2accu_src_data5[175:0])       //|< w
  ,.mac_b2accu_src_data6           (mac_b2accu_src_data6[175:0])       //|< w
  ,.mac_b2accu_src_data7           (mac_b2accu_src_data7[175:0])       //|< w
  ,.mac_b2accu_src_pd              (mac_b2accu_src_pd[8:0])            //|< w
  ,.pwrbus_ram_pd                  (nvdla_pwrbus_ram_a_pd[31:0])       //|< i
  ,.nvdla_core_clk                 (dla_core_clk)                      //|< i
  ,.dla_reset_rstn                 (nvdla_core_rstn)                   //|< w
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)                  //|< w
  );
    //&Connect /nvdla_obs/        nvdla_pwrpart_a_obs;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition P                                                 //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_p u_partition_p (
   .test_mode                      (test_mode)                         //|< i
  ,.direct_reset_                  (direct_reset_)                     //|< i
  ,.global_clk_ovr_on              (global_clk_ovr_on)                 //|< i
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     //|< i
  ,.cacc2sdp_valid                 (cacc2sdp_valid)                    //|< w
  ,.cacc2sdp_ready                 (cacc2sdp_ready)                    //|> w
  ,.cacc2sdp_pd                    (cacc2sdp_pd[513:0])                //|< w
  ,.csb2sdp_rdma_req_pvld          (csb2sdp_rdma_req_pvld)             //|< w
  ,.csb2sdp_rdma_req_prdy          (csb2sdp_rdma_req_prdy)             //|> w
  ,.csb2sdp_rdma_req_pd            (csb2sdp_rdma_req_pd[62:0])         //|< w
  ,.csb2sdp_req_pvld               (csb2sdp_req_pvld)                  //|< w
  ,.csb2sdp_req_prdy               (csb2sdp_req_prdy)                  //|> w
  ,.csb2sdp_req_pd                 (csb2sdp_req_pd[62:0])              //|< w
  ,.cvif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)           //|< w
  ,.cvif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)           //|> w
  ,.cvif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd[513:0])       //|< w
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)           //|< w
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)           //|> w
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd[513:0])       //|< w
  ,.cvif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)           //|< w
  ,.cvif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)           //|> w
  ,.cvif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd[513:0])       //|< w
  ,.cvif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)             //|< w
  ,.cvif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)             //|> w
  ,.cvif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd[513:0])         //|< w
  ,.cvif2sdp_wr_rsp_complete       (cvif2sdp_wr_rsp_complete)          //|< w
  ,.mac_a2accu_dst_pvld            (mac_a2accu_dst_pvld)               //|> w
  ,.mac_a2accu_dst_mask            (mac_a2accu_dst_mask[7:0])          //|> w
  ,.mac_a2accu_dst_mode            (mac_a2accu_dst_mode[7:0])          //|> w
  ,.mac_a2accu_dst_data0           (mac_a2accu_dst_data0[175:0])       //|> w
  ,.mac_a2accu_dst_data1           (mac_a2accu_dst_data1[175:0])       //|> w
  ,.mac_a2accu_dst_data2           (mac_a2accu_dst_data2[175:0])       //|> w
  ,.mac_a2accu_dst_data3           (mac_a2accu_dst_data3[175:0])       //|> w
  ,.mac_a2accu_dst_data4           (mac_a2accu_dst_data4[175:0])       //|> w
  ,.mac_a2accu_dst_data5           (mac_a2accu_dst_data5[175:0])       //|> w
  ,.mac_a2accu_dst_data6           (mac_a2accu_dst_data6[175:0])       //|> w
  ,.mac_a2accu_dst_data7           (mac_a2accu_dst_data7[175:0])       //|> w
  ,.mac_a2accu_dst_pd              (mac_a2accu_dst_pd[8:0])            //|> w
  ,.mac_a2accu_src_pvld            (mac_a2accu_src_pvld)               //|< w
  ,.mac_a2accu_src_mask            (mac_a2accu_src_mask[7:0])          //|< w
  ,.mac_a2accu_src_mode            (mac_a2accu_src_mode[7:0])          //|< w
  ,.mac_a2accu_src_data0           (mac_a2accu_src_data0[175:0])       //|< w
  ,.mac_a2accu_src_data1           (mac_a2accu_src_data1[175:0])       //|< w
  ,.mac_a2accu_src_data2           (mac_a2accu_src_data2[175:0])       //|< w
  ,.mac_a2accu_src_data3           (mac_a2accu_src_data3[175:0])       //|< w
  ,.mac_a2accu_src_data4           (mac_a2accu_src_data4[175:0])       //|< w
  ,.mac_a2accu_src_data5           (mac_a2accu_src_data5[175:0])       //|< w
  ,.mac_a2accu_src_data6           (mac_a2accu_src_data6[175:0])       //|< w
  ,.mac_a2accu_src_data7           (mac_a2accu_src_data7[175:0])       //|< w
  ,.mac_a2accu_src_pd              (mac_a2accu_src_pd[8:0])            //|< w
  ,.mcif2sdp_b_rd_rsp_valid        (mcif2sdp_b_rd_rsp_valid)           //|< w
  ,.mcif2sdp_b_rd_rsp_ready        (mcif2sdp_b_rd_rsp_ready)           //|> w
  ,.mcif2sdp_b_rd_rsp_pd           (mcif2sdp_b_rd_rsp_pd[513:0])       //|< w
  ,.mcif2sdp_e_rd_rsp_valid        (mcif2sdp_e_rd_rsp_valid)           //|< w
  ,.mcif2sdp_e_rd_rsp_ready        (mcif2sdp_e_rd_rsp_ready)           //|> w
  ,.mcif2sdp_e_rd_rsp_pd           (mcif2sdp_e_rd_rsp_pd[513:0])       //|< w
  ,.mcif2sdp_n_rd_rsp_valid        (mcif2sdp_n_rd_rsp_valid)           //|< w
  ,.mcif2sdp_n_rd_rsp_ready        (mcif2sdp_n_rd_rsp_ready)           //|> w
  ,.mcif2sdp_n_rd_rsp_pd           (mcif2sdp_n_rd_rsp_pd[513:0])       //|< w
  ,.mcif2sdp_rd_rsp_valid          (mcif2sdp_rd_rsp_valid)             //|< w
  ,.mcif2sdp_rd_rsp_ready          (mcif2sdp_rd_rsp_ready)             //|> w
  ,.mcif2sdp_rd_rsp_pd             (mcif2sdp_rd_rsp_pd[513:0])         //|< w
  ,.mcif2sdp_wr_rsp_complete       (mcif2sdp_wr_rsp_complete)          //|< w
  ,.pwrbus_ram_pd                  (nvdla_pwrbus_ram_p_pd[31:0])       //|< i
  ,.sdp2csb_resp_valid             (sdp2csb_resp_valid)                //|> w
  ,.sdp2csb_resp_pd                (sdp2csb_resp_pd[33:0])             //|> w
  ,.sdp2cvif_rd_cdt_lat_fifo_pop   (sdp2cvif_rd_cdt_lat_fifo_pop)      //|> w
  ,.sdp2cvif_rd_req_valid          (sdp2cvif_rd_req_valid)             //|> w
  ,.sdp2cvif_rd_req_ready          (sdp2cvif_rd_req_ready)             //|< w
  ,.sdp2cvif_rd_req_pd             (sdp2cvif_rd_req_pd[78:0])          //|> w
  ,.sdp2cvif_wr_req_valid          (sdp2cvif_wr_req_valid)             //|> w
  ,.sdp2cvif_wr_req_ready          (sdp2cvif_wr_req_ready)             //|< w
  ,.sdp2cvif_wr_req_pd             (sdp2cvif_wr_req_pd[514:0])         //|> w
  ,.sdp2glb_done_intr_pd           (sdp2glb_done_intr_pd[1:0])         //|> w
  ,.sdp2mcif_rd_cdt_lat_fifo_pop   (sdp2mcif_rd_cdt_lat_fifo_pop)      //|> w
  ,.sdp2mcif_rd_req_valid          (sdp2mcif_rd_req_valid)             //|> w
  ,.sdp2mcif_rd_req_ready          (sdp2mcif_rd_req_ready)             //|< w
  ,.sdp2mcif_rd_req_pd             (sdp2mcif_rd_req_pd[78:0])          //|> w
  ,.sdp2mcif_wr_req_valid          (sdp2mcif_wr_req_valid)             //|> w
  ,.sdp2mcif_wr_req_ready          (sdp2mcif_wr_req_ready)             //|< w
  ,.sdp2mcif_wr_req_pd             (sdp2mcif_wr_req_pd[514:0])         //|> w
  ,.sdp2pdp_valid                  (sdp2pdp_valid)                     //|> w
  ,.sdp2pdp_ready                  (sdp2pdp_ready)                     //|< w
  ,.sdp2pdp_pd                     (sdp2pdp_pd[255:0])                 //|> w
  ,.sdp_b2cvif_rd_cdt_lat_fifo_pop (sdp_b2cvif_rd_cdt_lat_fifo_pop)    //|> w
  ,.sdp_b2cvif_rd_req_valid        (sdp_b2cvif_rd_req_valid)           //|> w
  ,.sdp_b2cvif_rd_req_ready        (sdp_b2cvif_rd_req_ready)           //|< w
  ,.sdp_b2cvif_rd_req_pd           (sdp_b2cvif_rd_req_pd[78:0])        //|> w
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop (sdp_b2mcif_rd_cdt_lat_fifo_pop)    //|> w
  ,.sdp_b2mcif_rd_req_valid        (sdp_b2mcif_rd_req_valid)           //|> w
  ,.sdp_b2mcif_rd_req_ready        (sdp_b2mcif_rd_req_ready)           //|< w
  ,.sdp_b2mcif_rd_req_pd           (sdp_b2mcif_rd_req_pd[78:0])        //|> w
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop)    //|> w
  ,.sdp_e2cvif_rd_req_valid        (sdp_e2cvif_rd_req_valid)           //|> w
  ,.sdp_e2cvif_rd_req_ready        (sdp_e2cvif_rd_req_ready)           //|< w
  ,.sdp_e2cvif_rd_req_pd           (sdp_e2cvif_rd_req_pd[78:0])        //|> w
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2mcif_rd_cdt_lat_fifo_pop)    //|> w
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2mcif_rd_req_valid)           //|> w
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2mcif_rd_req_ready)           //|< w
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2mcif_rd_req_pd[78:0])        //|> w
  ,.sdp_n2cvif_rd_cdt_lat_fifo_pop (sdp_n2cvif_rd_cdt_lat_fifo_pop)    //|> w
  ,.sdp_n2cvif_rd_req_valid        (sdp_n2cvif_rd_req_valid)           //|> w
  ,.sdp_n2cvif_rd_req_ready        (sdp_n2cvif_rd_req_ready)           //|< w
  ,.sdp_n2cvif_rd_req_pd           (sdp_n2cvif_rd_req_pd[78:0])        //|> w
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop (sdp_n2mcif_rd_cdt_lat_fifo_pop)    //|> w
  ,.sdp_n2mcif_rd_req_valid        (sdp_n2mcif_rd_req_valid)           //|> w
  ,.sdp_n2mcif_rd_req_ready        (sdp_n2mcif_rd_req_ready)           //|< w
  ,.sdp_n2mcif_rd_req_pd           (sdp_n2mcif_rd_req_pd[78:0])        //|> w
  ,.sdp_rdma2csb_resp_valid        (sdp_rdma2csb_resp_valid)           //|> w
  ,.sdp_rdma2csb_resp_pd           (sdp_rdma2csb_resp_pd[33:0])        //|> w
  ,.nvdla_core_clk                 (dla_core_clk)                      //|< i
  ,.dla_reset_rstn                 (nvdla_core_rstn)                   //|< w
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)                  //|< w
  );
    //&Connect /nvdla_obs/        nvdla_pwrpart_p_obs;

////////////////////////////////////////////////////////////////////////
//  NVDLA Engine connections                                          //
////////////////////////////////////////////////////////////////////////
//assign nvdla_host1x_clk = dla_host1x_clk;
//assign nvdla_falcon_clk = dla_falcon_clk;
//assign nvdla_core_clk = dla_core_clk;
//assign dla_fault_corrected = fault_corrected;
//assign dla_fault_critical = fault_critical;

////////////////////////////////////////////////////////////////////////
//  NVDLA Engine dangles                                              //
////////////////////////////////////////////////////////////////////////
// Power Clamp

////////////////////////////////////////////////////////////////////////
//  Dangles/Contenders report                                         //
////////////////////////////////////////////////////////////////////////

//|
//|
//|
//|
//|
//|

endmodule // NV_nvdla


