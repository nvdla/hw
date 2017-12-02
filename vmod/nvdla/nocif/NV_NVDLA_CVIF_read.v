// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CVIF_read.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CVIF_read (
   bdma2cvif_rd_cdt_lat_fifo_pop  //|< i
  ,bdma2cvif_rd_req_pd            //|< i
  ,bdma2cvif_rd_req_valid         //|< i
  ,cdma_dat2cvif_rd_req_pd        //|< i
  ,cdma_dat2cvif_rd_req_valid     //|< i
  ,cdma_wt2cvif_rd_req_pd         //|< i
  ,cdma_wt2cvif_rd_req_valid      //|< i
  ,cdp2cvif_rd_cdt_lat_fifo_pop   //|< i
  ,cdp2cvif_rd_req_pd             //|< i
  ,cdp2cvif_rd_req_valid          //|< i
  ,cvif2bdma_rd_rsp_ready         //|< i
  ,cvif2cdma_dat_rd_rsp_ready     //|< i
  ,cvif2cdma_wt_rd_rsp_ready      //|< i
  ,cvif2cdp_rd_rsp_ready          //|< i
  ,cvif2noc_axi_ar_arready        //|< i
  ,cvif2pdp_rd_rsp_ready          //|< i
  ,cvif2rbk_rd_rsp_ready          //|< i
  ,cvif2sdp_b_rd_rsp_ready        //|< i
  ,cvif2sdp_e_rd_rsp_ready        //|< i
  ,cvif2sdp_n_rd_rsp_ready        //|< i
  ,cvif2sdp_rd_rsp_ready          //|< i
  ,noc2cvif_axi_r_rdata           //|< i
  ,noc2cvif_axi_r_rid             //|< i
  ,noc2cvif_axi_r_rlast           //|< i
  ,noc2cvif_axi_r_rvalid          //|< i
  ,nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,pdp2cvif_rd_cdt_lat_fifo_pop   //|< i
  ,pdp2cvif_rd_req_pd             //|< i
  ,pdp2cvif_rd_req_valid          //|< i
  ,pwrbus_ram_pd                  //|< i
  ,rbk2cvif_rd_cdt_lat_fifo_pop   //|< i
  ,rbk2cvif_rd_req_pd             //|< i
  ,rbk2cvif_rd_req_valid          //|< i
  ,reg2dp_rd_os_cnt               //|< i
  ,reg2dp_rd_weight_bdma          //|< i
  ,reg2dp_rd_weight_cdma_dat      //|< i
  ,reg2dp_rd_weight_cdma_wt       //|< i
  ,reg2dp_rd_weight_cdp           //|< i
  ,reg2dp_rd_weight_pdp           //|< i
  ,reg2dp_rd_weight_rbk           //|< i
  ,reg2dp_rd_weight_sdp           //|< i
  ,reg2dp_rd_weight_sdp_b         //|< i
  ,reg2dp_rd_weight_sdp_e         //|< i
  ,reg2dp_rd_weight_sdp_n         //|< i
  ,sdp2cvif_rd_cdt_lat_fifo_pop   //|< i
  ,sdp2cvif_rd_req_pd             //|< i
  ,sdp2cvif_rd_req_valid          //|< i
  ,sdp_b2cvif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_b2cvif_rd_req_pd           //|< i
  ,sdp_b2cvif_rd_req_valid        //|< i
  ,sdp_e2cvif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_e2cvif_rd_req_pd           //|< i
  ,sdp_e2cvif_rd_req_valid        //|< i
  ,sdp_n2cvif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_n2cvif_rd_req_pd           //|< i
  ,sdp_n2cvif_rd_req_valid        //|< i
  ,bdma2cvif_rd_req_ready         //|> o
  ,cdma_dat2cvif_rd_req_ready     //|> o
  ,cdma_wt2cvif_rd_req_ready      //|> o
  ,cdp2cvif_rd_req_ready          //|> o
  ,cvif2bdma_rd_rsp_pd            //|> o
  ,cvif2bdma_rd_rsp_valid         //|> o
  ,cvif2cdma_dat_rd_rsp_pd        //|> o
  ,cvif2cdma_dat_rd_rsp_valid     //|> o
  ,cvif2cdma_wt_rd_rsp_pd         //|> o
  ,cvif2cdma_wt_rd_rsp_valid      //|> o
  ,cvif2cdp_rd_rsp_pd             //|> o
  ,cvif2cdp_rd_rsp_valid          //|> o
  ,cvif2noc_axi_ar_araddr         //|> o
  ,cvif2noc_axi_ar_arid           //|> o
  ,cvif2noc_axi_ar_arlen          //|> o
  ,cvif2noc_axi_ar_arvalid        //|> o
  ,cvif2pdp_rd_rsp_pd             //|> o
  ,cvif2pdp_rd_rsp_valid          //|> o
  ,cvif2rbk_rd_rsp_pd             //|> o
  ,cvif2rbk_rd_rsp_valid          //|> o
  ,cvif2sdp_b_rd_rsp_pd           //|> o
  ,cvif2sdp_b_rd_rsp_valid        //|> o
  ,cvif2sdp_e_rd_rsp_pd           //|> o
  ,cvif2sdp_e_rd_rsp_valid        //|> o
  ,cvif2sdp_n_rd_rsp_pd           //|> o
  ,cvif2sdp_n_rd_rsp_valid        //|> o
  ,cvif2sdp_rd_rsp_pd             //|> o
  ,cvif2sdp_rd_rsp_valid          //|> o
  ,noc2cvif_axi_r_rready          //|> o
  ,pdp2cvif_rd_req_ready          //|> o
  ,rbk2cvif_rd_req_ready          //|> o
  ,sdp2cvif_rd_req_ready          //|> o
  ,sdp_b2cvif_rd_req_ready        //|> o
  ,sdp_e2cvif_rd_req_ready        //|> o
  ,sdp_n2cvif_rd_req_ready        //|> o
  );
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

input [7:0] reg2dp_rd_os_cnt;
input [7:0] reg2dp_rd_weight_bdma;
input [7:0] reg2dp_rd_weight_cdma_dat;
input [7:0] reg2dp_rd_weight_cdma_wt;
input [7:0] reg2dp_rd_weight_cdp;
input [7:0] reg2dp_rd_weight_pdp;
input [7:0] reg2dp_rd_weight_rbk;
input [7:0] reg2dp_rd_weight_sdp;
input [7:0] reg2dp_rd_weight_sdp_b;
input [7:0] reg2dp_rd_weight_sdp_e;
input [7:0] reg2dp_rd_weight_sdp_n;

//
// NV_NVDLA_CVIF_read_ports.v
//
input  nvdla_core_clk;   /* bdma2cvif_rd_cdt, bdma2cvif_rd_req, cdma_dat2cvif_rd_req, cdma_wt2cvif_rd_req, cdp2cvif_rd_cdt, cdp2cvif_rd_req, cvif2bdma_rd_rsp, cvif2cdma_dat_rd_rsp, cvif2cdma_wt_rd_rsp, cvif2cdp_rd_rsp, cvif2noc_axi_ar, cvif2pdp_rd_rsp, cvif2rbk_rd_rsp, cvif2sdp_b_rd_rsp, cvif2sdp_e_rd_rsp, cvif2sdp_n_rd_rsp, cvif2sdp_rd_rsp, noc2cvif_axi_r, pdp2cvif_rd_cdt, pdp2cvif_rd_req, rbk2cvif_rd_cdt, rbk2cvif_rd_req, sdp2cvif_rd_cdt, sdp2cvif_rd_req, sdp_b2cvif_rd_cdt, sdp_b2cvif_rd_req, sdp_e2cvif_rd_cdt, sdp_e2cvif_rd_req, sdp_n2cvif_rd_cdt, sdp_n2cvif_rd_req */
input  nvdla_core_rstn;  /* bdma2cvif_rd_cdt, bdma2cvif_rd_req, cdma_dat2cvif_rd_req, cdma_wt2cvif_rd_req, cdp2cvif_rd_cdt, cdp2cvif_rd_req, cvif2bdma_rd_rsp, cvif2cdma_dat_rd_rsp, cvif2cdma_wt_rd_rsp, cvif2cdp_rd_rsp, cvif2noc_axi_ar, cvif2pdp_rd_rsp, cvif2rbk_rd_rsp, cvif2sdp_b_rd_rsp, cvif2sdp_e_rd_rsp, cvif2sdp_n_rd_rsp, cvif2sdp_rd_rsp, noc2cvif_axi_r, pdp2cvif_rd_cdt, pdp2cvif_rd_req, rbk2cvif_rd_cdt, rbk2cvif_rd_req, sdp2cvif_rd_cdt, sdp2cvif_rd_req, sdp_b2cvif_rd_cdt, sdp_b2cvif_rd_req, sdp_e2cvif_rd_cdt, sdp_e2cvif_rd_req, sdp_n2cvif_rd_cdt, sdp_n2cvif_rd_req */

input  bdma2cvif_rd_cdt_lat_fifo_pop;

input         bdma2cvif_rd_req_valid;  /* data valid */
output        bdma2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] bdma2cvif_rd_req_pd;

input         cdma_dat2cvif_rd_req_valid;  /* data valid */
output        cdma_dat2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] cdma_dat2cvif_rd_req_pd;

input         cdma_wt2cvif_rd_req_valid;  /* data valid */
output        cdma_wt2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] cdma_wt2cvif_rd_req_pd;

input  cdp2cvif_rd_cdt_lat_fifo_pop;

input         cdp2cvif_rd_req_valid;  /* data valid */
output        cdp2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] cdp2cvif_rd_req_pd;

output         cvif2bdma_rd_rsp_valid;  /* data valid */
input          cvif2bdma_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2bdma_rd_rsp_pd;

output         cvif2cdma_dat_rd_rsp_valid;  /* data valid */
input          cvif2cdma_dat_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2cdma_dat_rd_rsp_pd;

output         cvif2cdma_wt_rd_rsp_valid;  /* data valid */
input          cvif2cdma_wt_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2cdma_wt_rd_rsp_pd;

output         cvif2cdp_rd_rsp_valid;  /* data valid */
input          cvif2cdp_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2cdp_rd_rsp_pd;

output        cvif2noc_axi_ar_arvalid;  /* data valid */
input         cvif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] cvif2noc_axi_ar_arid;
output  [3:0] cvif2noc_axi_ar_arlen;
output [63:0] cvif2noc_axi_ar_araddr;

output         cvif2pdp_rd_rsp_valid;  /* data valid */
input          cvif2pdp_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2pdp_rd_rsp_pd;

output         cvif2rbk_rd_rsp_valid;  /* data valid */
input          cvif2rbk_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2rbk_rd_rsp_pd;

output         cvif2sdp_b_rd_rsp_valid;  /* data valid */
input          cvif2sdp_b_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2sdp_b_rd_rsp_pd;

output         cvif2sdp_e_rd_rsp_valid;  /* data valid */
input          cvif2sdp_e_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2sdp_e_rd_rsp_pd;

output         cvif2sdp_n_rd_rsp_valid;  /* data valid */
input          cvif2sdp_n_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2sdp_n_rd_rsp_pd;

output         cvif2sdp_rd_rsp_valid;  /* data valid */
input          cvif2sdp_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2sdp_rd_rsp_pd;

input          noc2cvif_axi_r_rvalid;  /* data valid */
output         noc2cvif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2cvif_axi_r_rid;
input          noc2cvif_axi_r_rlast;
input  [511:0] noc2cvif_axi_r_rdata;

input  pdp2cvif_rd_cdt_lat_fifo_pop;

input         pdp2cvif_rd_req_valid;  /* data valid */
output        pdp2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] pdp2cvif_rd_req_pd;

input [31:0] pwrbus_ram_pd;

input  rbk2cvif_rd_cdt_lat_fifo_pop;

input         rbk2cvif_rd_req_valid;  /* data valid */
output        rbk2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] rbk2cvif_rd_req_pd;

input  sdp2cvif_rd_cdt_lat_fifo_pop;

input         sdp2cvif_rd_req_valid;  /* data valid */
output        sdp2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp2cvif_rd_req_pd;

input  sdp_b2cvif_rd_cdt_lat_fifo_pop;

input         sdp_b2cvif_rd_req_valid;  /* data valid */
output        sdp_b2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_b2cvif_rd_req_pd;

input  sdp_e2cvif_rd_cdt_lat_fifo_pop;

input         sdp_e2cvif_rd_req_valid;  /* data valid */
output        sdp_e2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_e2cvif_rd_req_pd;

input  sdp_n2cvif_rd_cdt_lat_fifo_pop;

input         sdp_n2cvif_rd_req_valid;  /* data valid */
output        sdp_n2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_n2cvif_rd_req_pd;

wire  [6:0] cq_rd0_pd;
wire        cq_rd0_prdy;
wire        cq_rd0_pvld;
wire  [6:0] cq_rd1_pd;
wire        cq_rd1_prdy;
wire        cq_rd1_pvld;
wire  [6:0] cq_rd2_pd;
wire        cq_rd2_prdy;
wire        cq_rd2_pvld;
wire  [6:0] cq_rd3_pd;
wire        cq_rd3_prdy;
wire        cq_rd3_pvld;
wire  [6:0] cq_rd4_pd;
wire        cq_rd4_prdy;
wire        cq_rd4_pvld;
wire  [6:0] cq_rd5_pd;
wire        cq_rd5_prdy;
wire        cq_rd5_pvld;
wire  [6:0] cq_rd6_pd;
wire        cq_rd6_prdy;
wire        cq_rd6_pvld;
wire  [6:0] cq_rd7_pd;
wire        cq_rd7_prdy;
wire        cq_rd7_pvld;
wire  [6:0] cq_rd8_pd;
wire        cq_rd8_prdy;
wire        cq_rd8_pvld;
wire  [6:0] cq_rd9_pd;
wire        cq_rd9_prdy;
wire        cq_rd9_pvld;
wire  [6:0] cq_wr_pd;
wire        cq_wr_prdy;
wire        cq_wr_pvld;
wire  [3:0] cq_wr_thread_id;
wire        eg2ig_axi_vld;

NV_NVDLA_CVIF_READ_ig u_ig (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.bdma2cvif_rd_cdt_lat_fifo_pop  (bdma2cvif_rd_cdt_lat_fifo_pop)  //|< i
  ,.bdma2cvif_rd_req_valid         (bdma2cvif_rd_req_valid)         //|< i
  ,.bdma2cvif_rd_req_ready         (bdma2cvif_rd_req_ready)         //|> o
  ,.bdma2cvif_rd_req_pd            (bdma2cvif_rd_req_pd[78:0])      //|< i
  ,.cdma_dat2cvif_rd_req_valid     (cdma_dat2cvif_rd_req_valid)     //|< i
  ,.cdma_dat2cvif_rd_req_ready     (cdma_dat2cvif_rd_req_ready)     //|> o
  ,.cdma_dat2cvif_rd_req_pd        (cdma_dat2cvif_rd_req_pd[78:0])  //|< i
  ,.cdma_wt2cvif_rd_req_valid      (cdma_wt2cvif_rd_req_valid)      //|< i
  ,.cdma_wt2cvif_rd_req_ready      (cdma_wt2cvif_rd_req_ready)      //|> o
  ,.cdma_wt2cvif_rd_req_pd         (cdma_wt2cvif_rd_req_pd[78:0])   //|< i
  ,.cdp2cvif_rd_cdt_lat_fifo_pop   (cdp2cvif_rd_cdt_lat_fifo_pop)   //|< i
  ,.cdp2cvif_rd_req_valid          (cdp2cvif_rd_req_valid)          //|< i
  ,.cdp2cvif_rd_req_ready          (cdp2cvif_rd_req_ready)          //|> o
  ,.cdp2cvif_rd_req_pd             (cdp2cvif_rd_req_pd[78:0])       //|< i
  ,.cq_wr_pvld                     (cq_wr_pvld)                     //|> w
  ,.cq_wr_prdy                     (cq_wr_prdy)                     //|< w
  ,.cq_wr_thread_id                (cq_wr_thread_id[3:0])           //|> w
  ,.cq_wr_pd                       (cq_wr_pd[6:0])                  //|> w
  ,.cvif2noc_axi_ar_arvalid        (cvif2noc_axi_ar_arvalid)        //|> o
  ,.cvif2noc_axi_ar_arready        (cvif2noc_axi_ar_arready)        //|< i
  ,.cvif2noc_axi_ar_arid           (cvif2noc_axi_ar_arid[7:0])      //|> o
  ,.cvif2noc_axi_ar_arlen          (cvif2noc_axi_ar_arlen[3:0])     //|> o
  ,.cvif2noc_axi_ar_araddr         (cvif2noc_axi_ar_araddr[63:0])   //|> o
  ,.pdp2cvif_rd_cdt_lat_fifo_pop   (pdp2cvif_rd_cdt_lat_fifo_pop)   //|< i
  ,.pdp2cvif_rd_req_valid          (pdp2cvif_rd_req_valid)          //|< i
  ,.pdp2cvif_rd_req_ready          (pdp2cvif_rd_req_ready)          //|> o
  ,.pdp2cvif_rd_req_pd             (pdp2cvif_rd_req_pd[78:0])       //|< i
  ,.rbk2cvif_rd_cdt_lat_fifo_pop   (rbk2cvif_rd_cdt_lat_fifo_pop)   //|< i
  ,.rbk2cvif_rd_req_valid          (rbk2cvif_rd_req_valid)          //|< i
  ,.rbk2cvif_rd_req_ready          (rbk2cvif_rd_req_ready)          //|> o
  ,.rbk2cvif_rd_req_pd             (rbk2cvif_rd_req_pd[78:0])       //|< i
  ,.sdp2cvif_rd_cdt_lat_fifo_pop   (sdp2cvif_rd_cdt_lat_fifo_pop)   //|< i
  ,.sdp2cvif_rd_req_valid          (sdp2cvif_rd_req_valid)          //|< i
  ,.sdp2cvif_rd_req_ready          (sdp2cvif_rd_req_ready)          //|> o
  ,.sdp2cvif_rd_req_pd             (sdp2cvif_rd_req_pd[78:0])       //|< i
  ,.sdp_b2cvif_rd_cdt_lat_fifo_pop (sdp_b2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_b2cvif_rd_req_valid        (sdp_b2cvif_rd_req_valid)        //|< i
  ,.sdp_b2cvif_rd_req_ready        (sdp_b2cvif_rd_req_ready)        //|> o
  ,.sdp_b2cvif_rd_req_pd           (sdp_b2cvif_rd_req_pd[78:0])     //|< i
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_e2cvif_rd_req_valid        (sdp_e2cvif_rd_req_valid)        //|< i
  ,.sdp_e2cvif_rd_req_ready        (sdp_e2cvif_rd_req_ready)        //|> o
  ,.sdp_e2cvif_rd_req_pd           (sdp_e2cvif_rd_req_pd[78:0])     //|< i
  ,.sdp_n2cvif_rd_cdt_lat_fifo_pop (sdp_n2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_n2cvif_rd_req_valid        (sdp_n2cvif_rd_req_valid)        //|< i
  ,.sdp_n2cvif_rd_req_ready        (sdp_n2cvif_rd_req_ready)        //|> o
  ,.sdp_n2cvif_rd_req_pd           (sdp_n2cvif_rd_req_pd[78:0])     //|< i
  ,.eg2ig_axi_vld                  (eg2ig_axi_vld)                  //|< w
  ,.reg2dp_rd_os_cnt               (reg2dp_rd_os_cnt[7:0])          //|< i
  ,.reg2dp_rd_weight_bdma          (reg2dp_rd_weight_bdma[7:0])     //|< i
  ,.reg2dp_rd_weight_cdma_dat      (reg2dp_rd_weight_cdma_dat[7:0]) //|< i
  ,.reg2dp_rd_weight_cdma_wt       (reg2dp_rd_weight_cdma_wt[7:0])  //|< i
  ,.reg2dp_rd_weight_cdp           (reg2dp_rd_weight_cdp[7:0])      //|< i
  ,.reg2dp_rd_weight_pdp           (reg2dp_rd_weight_pdp[7:0])      //|< i
  ,.reg2dp_rd_weight_rbk           (reg2dp_rd_weight_rbk[7:0])      //|< i
  ,.reg2dp_rd_weight_sdp           (reg2dp_rd_weight_sdp[7:0])      //|< i
  ,.reg2dp_rd_weight_sdp_b         (reg2dp_rd_weight_sdp_b[7:0])    //|< i
  ,.reg2dp_rd_weight_sdp_e         (reg2dp_rd_weight_sdp_e[7:0])    //|< i
  ,.reg2dp_rd_weight_sdp_n         (reg2dp_rd_weight_sdp_n[7:0])    //|< i
  );
NV_NVDLA_CVIF_READ_cq u_cq (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.cq_wr_prdy                     (cq_wr_prdy)                     //|> w
  ,.cq_wr_pvld                     (cq_wr_pvld)                     //|< w
  ,.cq_wr_thread_id                (cq_wr_thread_id[3:0])           //|< w
  ,.cq_wr_pd                       (cq_wr_pd[6:0])                  //|< w
  ,.cq_rd0_prdy                    (cq_rd0_prdy)                    //|< w
  ,.cq_rd0_pvld                    (cq_rd0_pvld)                    //|> w
  ,.cq_rd0_pd                      (cq_rd0_pd[6:0])                 //|> w
  ,.cq_rd1_prdy                    (cq_rd1_prdy)                    //|< w
  ,.cq_rd1_pvld                    (cq_rd1_pvld)                    //|> w
  ,.cq_rd1_pd                      (cq_rd1_pd[6:0])                 //|> w
  ,.cq_rd2_prdy                    (cq_rd2_prdy)                    //|< w
  ,.cq_rd2_pvld                    (cq_rd2_pvld)                    //|> w
  ,.cq_rd2_pd                      (cq_rd2_pd[6:0])                 //|> w
  ,.cq_rd3_prdy                    (cq_rd3_prdy)                    //|< w
  ,.cq_rd3_pvld                    (cq_rd3_pvld)                    //|> w
  ,.cq_rd3_pd                      (cq_rd3_pd[6:0])                 //|> w
  ,.cq_rd4_prdy                    (cq_rd4_prdy)                    //|< w
  ,.cq_rd4_pvld                    (cq_rd4_pvld)                    //|> w
  ,.cq_rd4_pd                      (cq_rd4_pd[6:0])                 //|> w
  ,.cq_rd5_prdy                    (cq_rd5_prdy)                    //|< w
  ,.cq_rd5_pvld                    (cq_rd5_pvld)                    //|> w
  ,.cq_rd5_pd                      (cq_rd5_pd[6:0])                 //|> w
  ,.cq_rd6_prdy                    (cq_rd6_prdy)                    //|< w
  ,.cq_rd6_pvld                    (cq_rd6_pvld)                    //|> w
  ,.cq_rd6_pd                      (cq_rd6_pd[6:0])                 //|> w
  ,.cq_rd7_prdy                    (cq_rd7_prdy)                    //|< w
  ,.cq_rd7_pvld                    (cq_rd7_pvld)                    //|> w
  ,.cq_rd7_pd                      (cq_rd7_pd[6:0])                 //|> w
  ,.cq_rd8_prdy                    (cq_rd8_prdy)                    //|< w
  ,.cq_rd8_pvld                    (cq_rd8_pvld)                    //|> w
  ,.cq_rd8_pd                      (cq_rd8_pd[6:0])                 //|> w
  ,.cq_rd9_prdy                    (cq_rd9_prdy)                    //|< w
  ,.cq_rd9_pvld                    (cq_rd9_pvld)                    //|> w
  ,.cq_rd9_pd                      (cq_rd9_pd[6:0])                 //|> w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  );
NV_NVDLA_CVIF_READ_eg u_eg (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.cvif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)          //|> o
  ,.cvif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)          //|< i
  ,.cvif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd[513:0])      //|> o
  ,.cvif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)        //|> o
  ,.cvif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)        //|< i
  ,.cvif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd[513:0])    //|> o
  ,.cvif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)        //|> o
  ,.cvif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)        //|< i
  ,.cvif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd[513:0])    //|> o
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)        //|> o
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)        //|< i
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd[513:0])    //|> o
  ,.cvif2cdp_rd_rsp_valid          (cvif2cdp_rd_rsp_valid)          //|> o
  ,.cvif2cdp_rd_rsp_ready          (cvif2cdp_rd_rsp_ready)          //|< i
  ,.cvif2cdp_rd_rsp_pd             (cvif2cdp_rd_rsp_pd[513:0])      //|> o
  ,.cvif2pdp_rd_rsp_valid          (cvif2pdp_rd_rsp_valid)          //|> o
  ,.cvif2pdp_rd_rsp_ready          (cvif2pdp_rd_rsp_ready)          //|< i
  ,.cvif2pdp_rd_rsp_pd             (cvif2pdp_rd_rsp_pd[513:0])      //|> o
  ,.cvif2bdma_rd_rsp_valid         (cvif2bdma_rd_rsp_valid)         //|> o
  ,.cvif2bdma_rd_rsp_ready         (cvif2bdma_rd_rsp_ready)         //|< i
  ,.cvif2bdma_rd_rsp_pd            (cvif2bdma_rd_rsp_pd[513:0])     //|> o
  ,.cvif2rbk_rd_rsp_valid          (cvif2rbk_rd_rsp_valid)          //|> o
  ,.cvif2rbk_rd_rsp_ready          (cvif2rbk_rd_rsp_ready)          //|< i
  ,.cvif2rbk_rd_rsp_pd             (cvif2rbk_rd_rsp_pd[513:0])      //|> o
  ,.cvif2cdma_wt_rd_rsp_valid      (cvif2cdma_wt_rd_rsp_valid)      //|> o
  ,.cvif2cdma_wt_rd_rsp_ready      (cvif2cdma_wt_rd_rsp_ready)      //|< i
  ,.cvif2cdma_wt_rd_rsp_pd         (cvif2cdma_wt_rd_rsp_pd[513:0])  //|> o
  ,.cvif2cdma_dat_rd_rsp_valid     (cvif2cdma_dat_rd_rsp_valid)     //|> o
  ,.cvif2cdma_dat_rd_rsp_ready     (cvif2cdma_dat_rd_rsp_ready)     //|< i
  ,.cvif2cdma_dat_rd_rsp_pd        (cvif2cdma_dat_rd_rsp_pd[513:0]) //|> o
  ,.cq_rd0_pvld                    (cq_rd0_pvld)                    //|< w
  ,.cq_rd0_prdy                    (cq_rd0_prdy)                    //|> w
  ,.cq_rd0_pd                      (cq_rd0_pd[6:0])                 //|< w
  ,.cq_rd1_pvld                    (cq_rd1_pvld)                    //|< w
  ,.cq_rd1_prdy                    (cq_rd1_prdy)                    //|> w
  ,.cq_rd1_pd                      (cq_rd1_pd[6:0])                 //|< w
  ,.cq_rd2_pvld                    (cq_rd2_pvld)                    //|< w
  ,.cq_rd2_prdy                    (cq_rd2_prdy)                    //|> w
  ,.cq_rd2_pd                      (cq_rd2_pd[6:0])                 //|< w
  ,.cq_rd3_pvld                    (cq_rd3_pvld)                    //|< w
  ,.cq_rd3_prdy                    (cq_rd3_prdy)                    //|> w
  ,.cq_rd3_pd                      (cq_rd3_pd[6:0])                 //|< w
  ,.cq_rd4_pvld                    (cq_rd4_pvld)                    //|< w
  ,.cq_rd4_prdy                    (cq_rd4_prdy)                    //|> w
  ,.cq_rd4_pd                      (cq_rd4_pd[6:0])                 //|< w
  ,.cq_rd5_pvld                    (cq_rd5_pvld)                    //|< w
  ,.cq_rd5_prdy                    (cq_rd5_prdy)                    //|> w
  ,.cq_rd5_pd                      (cq_rd5_pd[6:0])                 //|< w
  ,.cq_rd6_pvld                    (cq_rd6_pvld)                    //|< w
  ,.cq_rd6_prdy                    (cq_rd6_prdy)                    //|> w
  ,.cq_rd6_pd                      (cq_rd6_pd[6:0])                 //|< w
  ,.cq_rd7_pvld                    (cq_rd7_pvld)                    //|< w
  ,.cq_rd7_prdy                    (cq_rd7_prdy)                    //|> w
  ,.cq_rd7_pd                      (cq_rd7_pd[6:0])                 //|< w
  ,.cq_rd8_pvld                    (cq_rd8_pvld)                    //|< w
  ,.cq_rd8_prdy                    (cq_rd8_prdy)                    //|> w
  ,.cq_rd8_pd                      (cq_rd8_pd[6:0])                 //|< w
  ,.cq_rd9_pvld                    (cq_rd9_pvld)                    //|< w
  ,.cq_rd9_prdy                    (cq_rd9_prdy)                    //|> w
  ,.cq_rd9_pd                      (cq_rd9_pd[6:0])                 //|< w
  ,.noc2cvif_axi_r_rvalid          (noc2cvif_axi_r_rvalid)          //|< i
  ,.noc2cvif_axi_r_rready          (noc2cvif_axi_r_rready)          //|> o
  ,.noc2cvif_axi_r_rid             (noc2cvif_axi_r_rid[7:0])        //|< i
  ,.noc2cvif_axi_r_rlast           (noc2cvif_axi_r_rlast)           //|< i
  ,.noc2cvif_axi_r_rdata           (noc2cvif_axi_r_rdata[511:0])    //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.eg2ig_axi_vld                  (eg2ig_axi_vld)                  //|> w
  );

endmodule // NV_NVDLA_CVIF_read

