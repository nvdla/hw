// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cvif.v

module NV_NVDLA_cvif (
   bdma2cvif_rd_cdt_lat_fifo_pop  //|< i
  ,bdma2cvif_rd_req_pd            //|< i
  ,bdma2cvif_rd_req_valid         //|< i
  ,bdma2cvif_wr_req_pd            //|< i
  ,bdma2cvif_wr_req_valid         //|< i
  ,cdma_dat2cvif_rd_req_pd        //|< i
  ,cdma_dat2cvif_rd_req_valid     //|< i
  ,cdma_wt2cvif_rd_req_pd         //|< i
  ,cdma_wt2cvif_rd_req_valid      //|< i
  ,cdp2cvif_rd_cdt_lat_fifo_pop   //|< i
  ,cdp2cvif_rd_req_pd             //|< i
  ,cdp2cvif_rd_req_valid          //|< i
  ,cdp2cvif_wr_req_pd             //|< i
  ,cdp2cvif_wr_req_valid          //|< i
  ,csb2cvif_req_pd                //|< i
  ,csb2cvif_req_pvld              //|< i
  ,cvif2bdma_rd_rsp_ready         //|< i
  ,cvif2cdma_dat_rd_rsp_ready     //|< i
  ,cvif2cdma_wt_rd_rsp_ready      //|< i
  ,cvif2cdp_rd_rsp_ready          //|< i
  ,cvif2noc_axi_ar_arready        //|< i
  ,cvif2noc_axi_aw_awready        //|< i
  ,cvif2noc_axi_w_wready          //|< i
  ,cvif2pdp_rd_rsp_ready          //|< i
  ,cvif2rbk_rd_rsp_ready          //|< i
  ,cvif2sdp_b_rd_rsp_ready        //|< i
  ,cvif2sdp_e_rd_rsp_ready        //|< i
  ,cvif2sdp_n_rd_rsp_ready        //|< i
  ,cvif2sdp_rd_rsp_ready          //|< i
  ,noc2cvif_axi_b_bid             //|< i
  ,noc2cvif_axi_b_bvalid          //|< i
  ,noc2cvif_axi_r_rdata           //|< i
  ,noc2cvif_axi_r_rid             //|< i
  ,noc2cvif_axi_r_rlast           //|< i
  ,noc2cvif_axi_r_rvalid          //|< i
  ,nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,pdp2cvif_rd_cdt_lat_fifo_pop   //|< i
  ,pdp2cvif_rd_req_pd             //|< i
  ,pdp2cvif_rd_req_valid          //|< i
  ,pdp2cvif_wr_req_pd             //|< i
  ,pdp2cvif_wr_req_valid          //|< i
  ,pwrbus_ram_pd                  //|< i
  ,rbk2cvif_rd_cdt_lat_fifo_pop   //|< i
  ,rbk2cvif_rd_req_pd             //|< i
  ,rbk2cvif_rd_req_valid          //|< i
  ,rbk2cvif_wr_req_pd             //|< i
  ,rbk2cvif_wr_req_valid          //|< i
  ,sdp2cvif_rd_cdt_lat_fifo_pop   //|< i
  ,sdp2cvif_rd_req_pd             //|< i
  ,sdp2cvif_rd_req_valid          //|< i
  ,sdp2cvif_wr_req_pd             //|< i
  ,sdp2cvif_wr_req_valid          //|< i
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
  ,bdma2cvif_wr_req_ready         //|> o
  ,cdma_dat2cvif_rd_req_ready     //|> o
  ,cdma_wt2cvif_rd_req_ready      //|> o
  ,cdp2cvif_rd_req_ready          //|> o
  ,cdp2cvif_wr_req_ready          //|> o
  ,csb2cvif_req_prdy              //|> o
  ,cvif2bdma_rd_rsp_pd            //|> o
  ,cvif2bdma_rd_rsp_valid         //|> o
  ,cvif2bdma_wr_rsp_complete      //|> o
  ,cvif2cdma_dat_rd_rsp_pd        //|> o
  ,cvif2cdma_dat_rd_rsp_valid     //|> o
  ,cvif2cdma_wt_rd_rsp_pd         //|> o
  ,cvif2cdma_wt_rd_rsp_valid      //|> o
  ,cvif2cdp_rd_rsp_pd             //|> o
  ,cvif2cdp_rd_rsp_valid          //|> o
  ,cvif2cdp_wr_rsp_complete       //|> o
  ,cvif2csb_resp_pd               //|> o
  ,cvif2csb_resp_valid            //|> o
  ,cvif2noc_axi_ar_araddr         //|> o
  ,cvif2noc_axi_ar_arid           //|> o
  ,cvif2noc_axi_ar_arlen          //|> o
  ,cvif2noc_axi_ar_arvalid        //|> o
  ,cvif2noc_axi_aw_awaddr         //|> o
  ,cvif2noc_axi_aw_awid           //|> o
  ,cvif2noc_axi_aw_awlen          //|> o
  ,cvif2noc_axi_aw_awvalid        //|> o
  ,cvif2noc_axi_w_wdata           //|> o
  ,cvif2noc_axi_w_wlast           //|> o
  ,cvif2noc_axi_w_wstrb           //|> o
  ,cvif2noc_axi_w_wvalid          //|> o
  ,cvif2pdp_rd_rsp_pd             //|> o
  ,cvif2pdp_rd_rsp_valid          //|> o
  ,cvif2pdp_wr_rsp_complete       //|> o
  ,cvif2rbk_rd_rsp_pd             //|> o
  ,cvif2rbk_rd_rsp_valid          //|> o
  ,cvif2rbk_wr_rsp_complete       //|> o
  ,cvif2sdp_b_rd_rsp_pd           //|> o
  ,cvif2sdp_b_rd_rsp_valid        //|> o
  ,cvif2sdp_e_rd_rsp_pd           //|> o
  ,cvif2sdp_e_rd_rsp_valid        //|> o
  ,cvif2sdp_n_rd_rsp_pd           //|> o
  ,cvif2sdp_n_rd_rsp_valid        //|> o
  ,cvif2sdp_rd_rsp_pd             //|> o
  ,cvif2sdp_rd_rsp_valid          //|> o
  ,cvif2sdp_wr_rsp_complete       //|> o
  ,noc2cvif_axi_b_bready          //|> o
  ,noc2cvif_axi_r_rready          //|> o
  ,pdp2cvif_rd_req_ready          //|> o
  ,pdp2cvif_wr_req_ready          //|> o
  ,rbk2cvif_rd_req_ready          //|> o
  ,rbk2cvif_wr_req_ready          //|> o
  ,sdp2cvif_rd_req_ready          //|> o
  ,sdp2cvif_wr_req_ready          //|> o
  ,sdp_b2cvif_rd_req_ready        //|> o
  ,sdp_e2cvif_rd_req_ready        //|> o
  ,sdp_n2cvif_rd_req_ready        //|> o
  );


//
// NV_NVDLA_cvif_ports.v
//
input  nvdla_core_clk;   /* bdma2cvif_rd_cdt, bdma2cvif_rd_req, bdma2cvif_wr_req, cdma_dat2cvif_rd_req, cdma_wt2cvif_rd_req, cdp2cvif_rd_cdt, cdp2cvif_rd_req, cdp2cvif_wr_req, csb2cvif_req, cvif2bdma_rd_rsp, cvif2bdma_wr_rsp, cvif2cdma_dat_rd_rsp, cvif2cdma_wt_rd_rsp, cvif2cdp_rd_rsp, cvif2cdp_wr_rsp, cvif2csb_resp, cvif2noc_axi_ar, cvif2noc_axi_aw, cvif2noc_axi_w, cvif2pdp_rd_rsp, cvif2pdp_wr_rsp, cvif2rbk_rd_rsp, cvif2rbk_wr_rsp, cvif2sdp_b_rd_rsp, cvif2sdp_e_rd_rsp, cvif2sdp_n_rd_rsp, cvif2sdp_rd_rsp, cvif2sdp_wr_rsp, noc2cvif_axi_b, noc2cvif_axi_r, pdp2cvif_rd_cdt, pdp2cvif_rd_req, pdp2cvif_wr_req, rbk2cvif_rd_cdt, rbk2cvif_rd_req, rbk2cvif_wr_req, sdp2cvif_rd_cdt, sdp2cvif_rd_req, sdp2cvif_wr_req, sdp_b2cvif_rd_cdt, sdp_b2cvif_rd_req, sdp_e2cvif_rd_cdt, sdp_e2cvif_rd_req, sdp_n2cvif_rd_cdt, sdp_n2cvif_rd_req */
input  nvdla_core_rstn;  /* bdma2cvif_rd_cdt, bdma2cvif_rd_req, bdma2cvif_wr_req, cdma_dat2cvif_rd_req, cdma_wt2cvif_rd_req, cdp2cvif_rd_cdt, cdp2cvif_rd_req, cdp2cvif_wr_req, csb2cvif_req, cvif2bdma_rd_rsp, cvif2bdma_wr_rsp, cvif2cdma_dat_rd_rsp, cvif2cdma_wt_rd_rsp, cvif2cdp_rd_rsp, cvif2cdp_wr_rsp, cvif2csb_resp, cvif2noc_axi_ar, cvif2noc_axi_aw, cvif2noc_axi_w, cvif2pdp_rd_rsp, cvif2pdp_wr_rsp, cvif2rbk_rd_rsp, cvif2rbk_wr_rsp, cvif2sdp_b_rd_rsp, cvif2sdp_e_rd_rsp, cvif2sdp_n_rd_rsp, cvif2sdp_rd_rsp, cvif2sdp_wr_rsp, noc2cvif_axi_b, noc2cvif_axi_r, pdp2cvif_rd_cdt, pdp2cvif_rd_req, pdp2cvif_wr_req, rbk2cvif_rd_cdt, rbk2cvif_rd_req, rbk2cvif_wr_req, sdp2cvif_rd_cdt, sdp2cvif_rd_req, sdp2cvif_wr_req, sdp_b2cvif_rd_cdt, sdp_b2cvif_rd_req, sdp_e2cvif_rd_cdt, sdp_e2cvif_rd_req, sdp_n2cvif_rd_cdt, sdp_n2cvif_rd_req */

input  bdma2cvif_rd_cdt_lat_fifo_pop;

input         bdma2cvif_rd_req_valid;  /* data valid */
output        bdma2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] bdma2cvif_rd_req_pd;

input          bdma2cvif_wr_req_valid;  /* data valid */
output         bdma2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] bdma2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

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

input          cdp2cvif_wr_req_valid;  /* data valid */
output         cdp2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] cdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input         csb2cvif_req_pvld;  /* data valid */
output        csb2cvif_req_prdy;  /* data return handshake */
input  [62:0] csb2cvif_req_pd;

output         cvif2bdma_rd_rsp_valid;  /* data valid */
input          cvif2bdma_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2bdma_rd_rsp_pd;

output  cvif2bdma_wr_rsp_complete;

output         cvif2cdma_dat_rd_rsp_valid;  /* data valid */
input          cvif2cdma_dat_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2cdma_dat_rd_rsp_pd;

output         cvif2cdma_wt_rd_rsp_valid;  /* data valid */
input          cvif2cdma_wt_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2cdma_wt_rd_rsp_pd;

output         cvif2cdp_rd_rsp_valid;  /* data valid */
input          cvif2cdp_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2cdp_rd_rsp_pd;

output  cvif2cdp_wr_rsp_complete;

output        cvif2csb_resp_valid;  /* data valid */
output [33:0] cvif2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        cvif2noc_axi_ar_arvalid;  /* data valid */
input         cvif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] cvif2noc_axi_ar_arid;
output  [3:0] cvif2noc_axi_ar_arlen;
output [63:0] cvif2noc_axi_ar_araddr;

output        cvif2noc_axi_aw_awvalid;  /* data valid */
input         cvif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] cvif2noc_axi_aw_awid;
output  [3:0] cvif2noc_axi_aw_awlen;
output [63:0] cvif2noc_axi_aw_awaddr;

output         cvif2noc_axi_w_wvalid;  /* data valid */
input          cvif2noc_axi_w_wready;  /* data return handshake */
output [511:0] cvif2noc_axi_w_wdata;
output  [63:0] cvif2noc_axi_w_wstrb;
output         cvif2noc_axi_w_wlast;

output         cvif2pdp_rd_rsp_valid;  /* data valid */
input          cvif2pdp_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2pdp_rd_rsp_pd;

output  cvif2pdp_wr_rsp_complete;

output         cvif2rbk_rd_rsp_valid;  /* data valid */
input          cvif2rbk_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2rbk_rd_rsp_pd;

output  cvif2rbk_wr_rsp_complete;

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

output  cvif2sdp_wr_rsp_complete;

input        noc2cvif_axi_b_bvalid;  /* data valid */
output       noc2cvif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2cvif_axi_b_bid;

input          noc2cvif_axi_r_rvalid;  /* data valid */
output         noc2cvif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2cvif_axi_r_rid;
input          noc2cvif_axi_r_rlast;
input  [511:0] noc2cvif_axi_r_rdata;

input  pdp2cvif_rd_cdt_lat_fifo_pop;

input         pdp2cvif_rd_req_valid;  /* data valid */
output        pdp2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] pdp2cvif_rd_req_pd;

input          pdp2cvif_wr_req_valid;  /* data valid */
output         pdp2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] pdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input [31:0] pwrbus_ram_pd;

input  rbk2cvif_rd_cdt_lat_fifo_pop;

input         rbk2cvif_rd_req_valid;  /* data valid */
output        rbk2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] rbk2cvif_rd_req_pd;

input          rbk2cvif_wr_req_valid;  /* data valid */
output         rbk2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] rbk2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input  sdp2cvif_rd_cdt_lat_fifo_pop;

input         sdp2cvif_rd_req_valid;  /* data valid */
output        sdp2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp2cvif_rd_req_pd;

input          sdp2cvif_wr_req_valid;  /* data valid */
output         sdp2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] sdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

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

wire [7:0] reg2dp_rd_os_cnt;
wire [7:0] reg2dp_rd_weight_bdma;
wire [7:0] reg2dp_rd_weight_cdma_dat;
wire [7:0] reg2dp_rd_weight_cdma_wt;
wire [7:0] reg2dp_rd_weight_cdp;
wire [7:0] reg2dp_rd_weight_pdp;
wire [7:0] reg2dp_rd_weight_rbk;
wire [7:0] reg2dp_rd_weight_sdp;
wire [7:0] reg2dp_rd_weight_sdp_b;
wire [7:0] reg2dp_rd_weight_sdp_e;
wire [7:0] reg2dp_rd_weight_sdp_n;
wire [7:0] reg2dp_wr_os_cnt;
wire [7:0] reg2dp_wr_weight_bdma;
wire [7:0] reg2dp_wr_weight_cdp;
wire [7:0] reg2dp_wr_weight_pdp;
wire [7:0] reg2dp_wr_weight_rbk;
wire [7:0] reg2dp_wr_weight_sdp;

NV_NVDLA_CVIF_read u_read (
   .reg2dp_rd_os_cnt               (reg2dp_rd_os_cnt[7:0])          //|< w
  ,.reg2dp_rd_weight_bdma          (reg2dp_rd_weight_bdma[7:0])     //|< w
  ,.reg2dp_rd_weight_cdma_dat      (reg2dp_rd_weight_cdma_dat[7:0]) //|< w
  ,.reg2dp_rd_weight_cdma_wt       (reg2dp_rd_weight_cdma_wt[7:0])  //|< w
  ,.reg2dp_rd_weight_cdp           (reg2dp_rd_weight_cdp[7:0])      //|< w
  ,.reg2dp_rd_weight_pdp           (reg2dp_rd_weight_pdp[7:0])      //|< w
  ,.reg2dp_rd_weight_rbk           (reg2dp_rd_weight_rbk[7:0])      //|< w
  ,.reg2dp_rd_weight_sdp           (reg2dp_rd_weight_sdp[7:0])      //|< w
  ,.reg2dp_rd_weight_sdp_b         (reg2dp_rd_weight_sdp_b[7:0])    //|< w
  ,.reg2dp_rd_weight_sdp_e         (reg2dp_rd_weight_sdp_e[7:0])    //|< w
  ,.reg2dp_rd_weight_sdp_n         (reg2dp_rd_weight_sdp_n[7:0])    //|< w
  ,.nvdla_core_clk                 (nvdla_core_clk)                 //|< i
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
  ,.cvif2bdma_rd_rsp_valid         (cvif2bdma_rd_rsp_valid)         //|> o
  ,.cvif2bdma_rd_rsp_ready         (cvif2bdma_rd_rsp_ready)         //|< i
  ,.cvif2bdma_rd_rsp_pd            (cvif2bdma_rd_rsp_pd[513:0])     //|> o
  ,.cvif2cdma_dat_rd_rsp_valid     (cvif2cdma_dat_rd_rsp_valid)     //|> o
  ,.cvif2cdma_dat_rd_rsp_ready     (cvif2cdma_dat_rd_rsp_ready)     //|< i
  ,.cvif2cdma_dat_rd_rsp_pd        (cvif2cdma_dat_rd_rsp_pd[513:0]) //|> o
  ,.cvif2cdma_wt_rd_rsp_valid      (cvif2cdma_wt_rd_rsp_valid)      //|> o
  ,.cvif2cdma_wt_rd_rsp_ready      (cvif2cdma_wt_rd_rsp_ready)      //|< i
  ,.cvif2cdma_wt_rd_rsp_pd         (cvif2cdma_wt_rd_rsp_pd[513:0])  //|> o
  ,.cvif2cdp_rd_rsp_valid          (cvif2cdp_rd_rsp_valid)          //|> o
  ,.cvif2cdp_rd_rsp_ready          (cvif2cdp_rd_rsp_ready)          //|< i
  ,.cvif2cdp_rd_rsp_pd             (cvif2cdp_rd_rsp_pd[513:0])      //|> o
  ,.cvif2noc_axi_ar_arvalid        (cvif2noc_axi_ar_arvalid)        //|> o
  ,.cvif2noc_axi_ar_arready        (cvif2noc_axi_ar_arready)        //|< i
  ,.cvif2noc_axi_ar_arid           (cvif2noc_axi_ar_arid[7:0])      //|> o
  ,.cvif2noc_axi_ar_arlen          (cvif2noc_axi_ar_arlen[3:0])     //|> o
  ,.cvif2noc_axi_ar_araddr         (cvif2noc_axi_ar_araddr[63:0])   //|> o
  ,.cvif2pdp_rd_rsp_valid          (cvif2pdp_rd_rsp_valid)          //|> o
  ,.cvif2pdp_rd_rsp_ready          (cvif2pdp_rd_rsp_ready)          //|< i
  ,.cvif2pdp_rd_rsp_pd             (cvif2pdp_rd_rsp_pd[513:0])      //|> o
  ,.cvif2rbk_rd_rsp_valid          (cvif2rbk_rd_rsp_valid)          //|> o
  ,.cvif2rbk_rd_rsp_ready          (cvif2rbk_rd_rsp_ready)          //|< i
  ,.cvif2rbk_rd_rsp_pd             (cvif2rbk_rd_rsp_pd[513:0])      //|> o
  ,.cvif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)        //|> o
  ,.cvif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)        //|< i
  ,.cvif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd[513:0])    //|> o
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)        //|> o
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)        //|< i
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd[513:0])    //|> o
  ,.cvif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)        //|> o
  ,.cvif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)        //|< i
  ,.cvif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd[513:0])    //|> o
  ,.cvif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)          //|> o
  ,.cvif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)          //|< i
  ,.cvif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd[513:0])      //|> o
  ,.noc2cvif_axi_r_rvalid          (noc2cvif_axi_r_rvalid)          //|< i
  ,.noc2cvif_axi_r_rready          (noc2cvif_axi_r_rready)          //|> o
  ,.noc2cvif_axi_r_rid             (noc2cvif_axi_r_rid[7:0])        //|< i
  ,.noc2cvif_axi_r_rlast           (noc2cvif_axi_r_rlast)           //|< i
  ,.noc2cvif_axi_r_rdata           (noc2cvif_axi_r_rdata[511:0])    //|< i
  ,.pdp2cvif_rd_cdt_lat_fifo_pop   (pdp2cvif_rd_cdt_lat_fifo_pop)   //|< i
  ,.pdp2cvif_rd_req_valid          (pdp2cvif_rd_req_valid)          //|< i
  ,.pdp2cvif_rd_req_ready          (pdp2cvif_rd_req_ready)          //|> o
  ,.pdp2cvif_rd_req_pd             (pdp2cvif_rd_req_pd[78:0])       //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
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
  );
NV_NVDLA_CVIF_write u_write (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.bdma2cvif_wr_req_valid         (bdma2cvif_wr_req_valid)         //|< i
  ,.bdma2cvif_wr_req_ready         (bdma2cvif_wr_req_ready)         //|> o
  ,.bdma2cvif_wr_req_pd            (bdma2cvif_wr_req_pd[514:0])     //|< i
  ,.cdp2cvif_wr_req_valid          (cdp2cvif_wr_req_valid)          //|< i
  ,.cdp2cvif_wr_req_ready          (cdp2cvif_wr_req_ready)          //|> o
  ,.cdp2cvif_wr_req_pd             (cdp2cvif_wr_req_pd[514:0])      //|< i
  ,.cvif2bdma_wr_rsp_complete      (cvif2bdma_wr_rsp_complete)      //|> o
  ,.cvif2cdp_wr_rsp_complete       (cvif2cdp_wr_rsp_complete)       //|> o
  ,.cvif2noc_axi_aw_awvalid        (cvif2noc_axi_aw_awvalid)        //|> o
  ,.cvif2noc_axi_aw_awready        (cvif2noc_axi_aw_awready)        //|< i
  ,.cvif2noc_axi_aw_awid           (cvif2noc_axi_aw_awid[7:0])      //|> o
  ,.cvif2noc_axi_aw_awlen          (cvif2noc_axi_aw_awlen[3:0])     //|> o
  ,.cvif2noc_axi_aw_awaddr         (cvif2noc_axi_aw_awaddr[63:0])   //|> o
  ,.cvif2noc_axi_w_wvalid          (cvif2noc_axi_w_wvalid)          //|> o
  ,.cvif2noc_axi_w_wready          (cvif2noc_axi_w_wready)          //|< i
  ,.cvif2noc_axi_w_wdata           (cvif2noc_axi_w_wdata[511:0])    //|> o
  ,.cvif2noc_axi_w_wstrb           (cvif2noc_axi_w_wstrb[63:0])     //|> o
  ,.cvif2noc_axi_w_wlast           (cvif2noc_axi_w_wlast)           //|> o
  ,.cvif2pdp_wr_rsp_complete       (cvif2pdp_wr_rsp_complete)       //|> o
  ,.cvif2rbk_wr_rsp_complete       (cvif2rbk_wr_rsp_complete)       //|> o
  ,.cvif2sdp_wr_rsp_complete       (cvif2sdp_wr_rsp_complete)       //|> o
  ,.noc2cvif_axi_b_bvalid          (noc2cvif_axi_b_bvalid)          //|< i
  ,.noc2cvif_axi_b_bready          (noc2cvif_axi_b_bready)          //|> o
  ,.noc2cvif_axi_b_bid             (noc2cvif_axi_b_bid[7:0])        //|< i
  ,.pdp2cvif_wr_req_valid          (pdp2cvif_wr_req_valid)          //|< i
  ,.pdp2cvif_wr_req_ready          (pdp2cvif_wr_req_ready)          //|> o
  ,.pdp2cvif_wr_req_pd             (pdp2cvif_wr_req_pd[514:0])      //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.rbk2cvif_wr_req_valid          (rbk2cvif_wr_req_valid)          //|< i
  ,.rbk2cvif_wr_req_ready          (rbk2cvif_wr_req_ready)          //|> o
  ,.rbk2cvif_wr_req_pd             (rbk2cvif_wr_req_pd[514:0])      //|< i
  ,.sdp2cvif_wr_req_valid          (sdp2cvif_wr_req_valid)          //|< i
  ,.sdp2cvif_wr_req_ready          (sdp2cvif_wr_req_ready)          //|> o
  ,.sdp2cvif_wr_req_pd             (sdp2cvif_wr_req_pd[514:0])      //|< i
  ,.reg2dp_wr_os_cnt               (reg2dp_wr_os_cnt[7:0])          //|< w
  ,.reg2dp_wr_weight_bdma          (reg2dp_wr_weight_bdma[7:0])     //|< w
  ,.reg2dp_wr_weight_cdp           (reg2dp_wr_weight_cdp[7:0])      //|< w
  ,.reg2dp_wr_weight_pdp           (reg2dp_wr_weight_pdp[7:0])      //|< w
  ,.reg2dp_wr_weight_rbk           (reg2dp_wr_weight_rbk[7:0])      //|< w
  ,.reg2dp_wr_weight_sdp           (reg2dp_wr_weight_sdp[7:0])      //|< w
  );

NV_NVDLA_CVIF_csb u_csb (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.csb2cvif_req_pvld              (csb2cvif_req_pvld)              //|< i
  ,.csb2cvif_req_prdy              (csb2cvif_req_prdy)              //|> o
  ,.csb2cvif_req_pd                (csb2cvif_req_pd[62:0])          //|< i
  ,.cvif2csb_resp_valid            (cvif2csb_resp_valid)            //|> o
  ,.cvif2csb_resp_pd               (cvif2csb_resp_pd[33:0])         //|> o
  ,.dp2reg_idle                    ({1{1'b1}})                      //|< ?
  ,.reg2dp_rd_os_cnt               (reg2dp_rd_os_cnt[7:0])          //|> w
  ,.reg2dp_rd_weight_bdma          (reg2dp_rd_weight_bdma[7:0])     //|> w
  ,.reg2dp_rd_weight_cdma_dat      (reg2dp_rd_weight_cdma_dat[7:0]) //|> w
  ,.reg2dp_rd_weight_cdma_wt       (reg2dp_rd_weight_cdma_wt[7:0])  //|> w
  ,.reg2dp_rd_weight_cdp           (reg2dp_rd_weight_cdp[7:0])      //|> w
  ,.reg2dp_rd_weight_pdp           (reg2dp_rd_weight_pdp[7:0])      //|> w
  ,.reg2dp_rd_weight_rbk           (reg2dp_rd_weight_rbk[7:0])      //|> w
  ,.reg2dp_rd_weight_rsv_0         ()                               //|> ?
  ,.reg2dp_rd_weight_rsv_1         ()                               //|> ?
  ,.reg2dp_rd_weight_sdp           (reg2dp_rd_weight_sdp[7:0])      //|> w
  ,.reg2dp_rd_weight_sdp_b         (reg2dp_rd_weight_sdp_b[7:0])    //|> w
  ,.reg2dp_rd_weight_sdp_e         (reg2dp_rd_weight_sdp_e[7:0])    //|> w
  ,.reg2dp_rd_weight_sdp_n         (reg2dp_rd_weight_sdp_n[7:0])    //|> w
  ,.reg2dp_wr_os_cnt               (reg2dp_wr_os_cnt[7:0])          //|> w
  ,.reg2dp_wr_weight_bdma          (reg2dp_wr_weight_bdma[7:0])     //|> w
  ,.reg2dp_wr_weight_cdp           (reg2dp_wr_weight_cdp[7:0])      //|> w
  ,.reg2dp_wr_weight_pdp           (reg2dp_wr_weight_pdp[7:0])      //|> w
  ,.reg2dp_wr_weight_rbk           (reg2dp_wr_weight_rbk[7:0])      //|> w
  ,.reg2dp_wr_weight_rsv_0         ()                               //|> ?
  ,.reg2dp_wr_weight_rsv_1         ()                               //|> ?
  ,.reg2dp_wr_weight_rsv_2         ()                               //|> ?
  ,.reg2dp_wr_weight_sdp           (reg2dp_wr_weight_sdp[7:0])      //|> w
  );

endmodule // NV_NVDLA_cvif

