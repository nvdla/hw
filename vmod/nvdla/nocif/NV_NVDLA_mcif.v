// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_mcif.v

module NV_NVDLA_mcif (
   bdma2mcif_rd_cdt_lat_fifo_pop  //|< i
  ,bdma2mcif_rd_req_pd            //|< i
  ,bdma2mcif_rd_req_valid         //|< i
  ,bdma2mcif_wr_req_pd            //|< i
  ,bdma2mcif_wr_req_valid         //|< i
  ,cdma_dat2mcif_rd_req_pd        //|< i
  ,cdma_dat2mcif_rd_req_valid     //|< i
  ,cdma_wt2mcif_rd_req_pd         //|< i
  ,cdma_wt2mcif_rd_req_valid      //|< i
  ,cdp2mcif_rd_cdt_lat_fifo_pop   //|< i
  ,cdp2mcif_rd_req_pd             //|< i
  ,cdp2mcif_rd_req_valid          //|< i
  ,cdp2mcif_wr_req_pd             //|< i
  ,cdp2mcif_wr_req_valid          //|< i
  ,csb2mcif_req_pd                //|< i
  ,csb2mcif_req_pvld              //|< i
  ,mcif2bdma_rd_rsp_ready         //|< i
  ,mcif2cdma_dat_rd_rsp_ready     //|< i
  ,mcif2cdma_wt_rd_rsp_ready      //|< i
  ,mcif2cdp_rd_rsp_ready          //|< i
  ,mcif2noc_axi_ar_arready        //|< i
  ,mcif2noc_axi_aw_awready        //|< i
  ,mcif2noc_axi_w_wready          //|< i
  ,mcif2pdp_rd_rsp_ready          //|< i
  ,mcif2rbk_rd_rsp_ready          //|< i
  ,mcif2sdp_b_rd_rsp_ready        //|< i
  ,mcif2sdp_e_rd_rsp_ready        //|< i
  ,mcif2sdp_n_rd_rsp_ready        //|< i
  ,mcif2sdp_rd_rsp_ready          //|< i
  ,noc2mcif_axi_b_bid             //|< i
  ,noc2mcif_axi_b_bvalid          //|< i
  ,noc2mcif_axi_r_rdata           //|< i
  ,noc2mcif_axi_r_rid             //|< i
  ,noc2mcif_axi_r_rlast           //|< i
  ,noc2mcif_axi_r_rvalid          //|< i
  ,nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,pdp2mcif_rd_cdt_lat_fifo_pop   //|< i
  ,pdp2mcif_rd_req_pd             //|< i
  ,pdp2mcif_rd_req_valid          //|< i
  ,pdp2mcif_wr_req_pd             //|< i
  ,pdp2mcif_wr_req_valid          //|< i
  ,pwrbus_ram_pd                  //|< i
  ,rbk2mcif_rd_cdt_lat_fifo_pop   //|< i
  ,rbk2mcif_rd_req_pd             //|< i
  ,rbk2mcif_rd_req_valid          //|< i
  ,rbk2mcif_wr_req_pd             //|< i
  ,rbk2mcif_wr_req_valid          //|< i
  ,sdp2mcif_rd_cdt_lat_fifo_pop   //|< i
  ,sdp2mcif_rd_req_pd             //|< i
  ,sdp2mcif_rd_req_valid          //|< i
  ,sdp2mcif_wr_req_pd             //|< i
  ,sdp2mcif_wr_req_valid          //|< i
  ,sdp_b2mcif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_b2mcif_rd_req_pd           //|< i
  ,sdp_b2mcif_rd_req_valid        //|< i
  ,sdp_e2mcif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_e2mcif_rd_req_pd           //|< i
  ,sdp_e2mcif_rd_req_valid        //|< i
  ,sdp_n2mcif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_n2mcif_rd_req_pd           //|< i
  ,sdp_n2mcif_rd_req_valid        //|< i
  ,bdma2mcif_rd_req_ready         //|> o
  ,bdma2mcif_wr_req_ready         //|> o
  ,cdma_dat2mcif_rd_req_ready     //|> o
  ,cdma_wt2mcif_rd_req_ready      //|> o
  ,cdp2mcif_rd_req_ready          //|> o
  ,cdp2mcif_wr_req_ready          //|> o
  ,csb2mcif_req_prdy              //|> o
  ,mcif2bdma_rd_rsp_pd            //|> o
  ,mcif2bdma_rd_rsp_valid         //|> o
  ,mcif2bdma_wr_rsp_complete      //|> o
  ,mcif2cdma_dat_rd_rsp_pd        //|> o
  ,mcif2cdma_dat_rd_rsp_valid     //|> o
  ,mcif2cdma_wt_rd_rsp_pd         //|> o
  ,mcif2cdma_wt_rd_rsp_valid      //|> o
  ,mcif2cdp_rd_rsp_pd             //|> o
  ,mcif2cdp_rd_rsp_valid          //|> o
  ,mcif2cdp_wr_rsp_complete       //|> o
  ,mcif2csb_resp_pd               //|> o
  ,mcif2csb_resp_valid            //|> o
  ,mcif2noc_axi_ar_araddr         //|> o
  ,mcif2noc_axi_ar_arid           //|> o
  ,mcif2noc_axi_ar_arlen          //|> o
  ,mcif2noc_axi_ar_arvalid        //|> o
  ,mcif2noc_axi_aw_awaddr         //|> o
  ,mcif2noc_axi_aw_awid           //|> o
  ,mcif2noc_axi_aw_awlen          //|> o
  ,mcif2noc_axi_aw_awvalid        //|> o
  ,mcif2noc_axi_w_wdata           //|> o
  ,mcif2noc_axi_w_wlast           //|> o
  ,mcif2noc_axi_w_wstrb           //|> o
  ,mcif2noc_axi_w_wvalid          //|> o
  ,mcif2pdp_rd_rsp_pd             //|> o
  ,mcif2pdp_rd_rsp_valid          //|> o
  ,mcif2pdp_wr_rsp_complete       //|> o
  ,mcif2rbk_rd_rsp_pd             //|> o
  ,mcif2rbk_rd_rsp_valid          //|> o
  ,mcif2rbk_wr_rsp_complete       //|> o
  ,mcif2sdp_b_rd_rsp_pd           //|> o
  ,mcif2sdp_b_rd_rsp_valid        //|> o
  ,mcif2sdp_e_rd_rsp_pd           //|> o
  ,mcif2sdp_e_rd_rsp_valid        //|> o
  ,mcif2sdp_n_rd_rsp_pd           //|> o
  ,mcif2sdp_n_rd_rsp_valid        //|> o
  ,mcif2sdp_rd_rsp_pd             //|> o
  ,mcif2sdp_rd_rsp_valid          //|> o
  ,mcif2sdp_wr_rsp_complete       //|> o
  ,noc2mcif_axi_b_bready          //|> o
  ,noc2mcif_axi_r_rready          //|> o
  ,pdp2mcif_rd_req_ready          //|> o
  ,pdp2mcif_wr_req_ready          //|> o
  ,rbk2mcif_rd_req_ready          //|> o
  ,rbk2mcif_wr_req_ready          //|> o
  ,sdp2mcif_rd_req_ready          //|> o
  ,sdp2mcif_wr_req_ready          //|> o
  ,sdp_b2mcif_rd_req_ready        //|> o
  ,sdp_e2mcif_rd_req_ready        //|> o
  ,sdp_n2mcif_rd_req_ready        //|> o
  );


//
// NV_NVDLA_mcif_ports.v
//
input  nvdla_core_clk;   /* bdma2mcif_rd_cdt, bdma2mcif_rd_req, bdma2mcif_wr_req, cdma_dat2mcif_rd_req, cdma_wt2mcif_rd_req, cdp2mcif_rd_cdt, cdp2mcif_rd_req, cdp2mcif_wr_req, csb2mcif_req, mcif2bdma_rd_rsp, mcif2bdma_wr_rsp, mcif2cdma_dat_rd_rsp, mcif2cdma_wt_rd_rsp, mcif2cdp_rd_rsp, mcif2cdp_wr_rsp, mcif2csb_resp, mcif2noc_axi_ar, mcif2noc_axi_aw, mcif2noc_axi_w, mcif2pdp_rd_rsp, mcif2pdp_wr_rsp, mcif2rbk_rd_rsp, mcif2rbk_wr_rsp, mcif2sdp_b_rd_rsp, mcif2sdp_e_rd_rsp, mcif2sdp_n_rd_rsp, mcif2sdp_rd_rsp, mcif2sdp_wr_rsp, noc2mcif_axi_b, noc2mcif_axi_r, pdp2mcif_rd_cdt, pdp2mcif_rd_req, pdp2mcif_wr_req, rbk2mcif_rd_cdt, rbk2mcif_rd_req, rbk2mcif_wr_req, sdp2mcif_rd_cdt, sdp2mcif_rd_req, sdp2mcif_wr_req, sdp_b2mcif_rd_cdt, sdp_b2mcif_rd_req, sdp_e2mcif_rd_cdt, sdp_e2mcif_rd_req, sdp_n2mcif_rd_cdt, sdp_n2mcif_rd_req */
input  nvdla_core_rstn;  /* bdma2mcif_rd_cdt, bdma2mcif_rd_req, bdma2mcif_wr_req, cdma_dat2mcif_rd_req, cdma_wt2mcif_rd_req, cdp2mcif_rd_cdt, cdp2mcif_rd_req, cdp2mcif_wr_req, csb2mcif_req, mcif2bdma_rd_rsp, mcif2bdma_wr_rsp, mcif2cdma_dat_rd_rsp, mcif2cdma_wt_rd_rsp, mcif2cdp_rd_rsp, mcif2cdp_wr_rsp, mcif2csb_resp, mcif2noc_axi_ar, mcif2noc_axi_aw, mcif2noc_axi_w, mcif2pdp_rd_rsp, mcif2pdp_wr_rsp, mcif2rbk_rd_rsp, mcif2rbk_wr_rsp, mcif2sdp_b_rd_rsp, mcif2sdp_e_rd_rsp, mcif2sdp_n_rd_rsp, mcif2sdp_rd_rsp, mcif2sdp_wr_rsp, noc2mcif_axi_b, noc2mcif_axi_r, pdp2mcif_rd_cdt, pdp2mcif_rd_req, pdp2mcif_wr_req, rbk2mcif_rd_cdt, rbk2mcif_rd_req, rbk2mcif_wr_req, sdp2mcif_rd_cdt, sdp2mcif_rd_req, sdp2mcif_wr_req, sdp_b2mcif_rd_cdt, sdp_b2mcif_rd_req, sdp_e2mcif_rd_cdt, sdp_e2mcif_rd_req, sdp_n2mcif_rd_cdt, sdp_n2mcif_rd_req */

input  bdma2mcif_rd_cdt_lat_fifo_pop;

input         bdma2mcif_rd_req_valid;  /* data valid */
output        bdma2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] bdma2mcif_rd_req_pd;

input          bdma2mcif_wr_req_valid;  /* data valid */
output         bdma2mcif_wr_req_ready;  /* data return handshake */
input  [514:0] bdma2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input         cdma_dat2mcif_rd_req_valid;  /* data valid */
output        cdma_dat2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] cdma_dat2mcif_rd_req_pd;

input         cdma_wt2mcif_rd_req_valid;  /* data valid */
output        cdma_wt2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] cdma_wt2mcif_rd_req_pd;

input  cdp2mcif_rd_cdt_lat_fifo_pop;

input         cdp2mcif_rd_req_valid;  /* data valid */
output        cdp2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] cdp2mcif_rd_req_pd;

input          cdp2mcif_wr_req_valid;  /* data valid */
output         cdp2mcif_wr_req_ready;  /* data return handshake */
input  [514:0] cdp2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input         csb2mcif_req_pvld;  /* data valid */
output        csb2mcif_req_prdy;  /* data return handshake */
input  [62:0] csb2mcif_req_pd;

output         mcif2bdma_rd_rsp_valid;  /* data valid */
input          mcif2bdma_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2bdma_rd_rsp_pd;

output  mcif2bdma_wr_rsp_complete;

output         mcif2cdma_dat_rd_rsp_valid;  /* data valid */
input          mcif2cdma_dat_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2cdma_dat_rd_rsp_pd;

output         mcif2cdma_wt_rd_rsp_valid;  /* data valid */
input          mcif2cdma_wt_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2cdma_wt_rd_rsp_pd;

output         mcif2cdp_rd_rsp_valid;  /* data valid */
input          mcif2cdp_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2cdp_rd_rsp_pd;

output  mcif2cdp_wr_rsp_complete;

output        mcif2csb_resp_valid;  /* data valid */
output [33:0] mcif2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        mcif2noc_axi_ar_arvalid;  /* data valid */
input         mcif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [63:0] mcif2noc_axi_ar_araddr;

output        mcif2noc_axi_aw_awvalid;  /* data valid */
input         mcif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] mcif2noc_axi_aw_awid;
output  [3:0] mcif2noc_axi_aw_awlen;
output [63:0] mcif2noc_axi_aw_awaddr;

output         mcif2noc_axi_w_wvalid;  /* data valid */
input          mcif2noc_axi_w_wready;  /* data return handshake */
output [511:0] mcif2noc_axi_w_wdata;
output  [63:0] mcif2noc_axi_w_wstrb;
output         mcif2noc_axi_w_wlast;

output         mcif2pdp_rd_rsp_valid;  /* data valid */
input          mcif2pdp_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2pdp_rd_rsp_pd;

output  mcif2pdp_wr_rsp_complete;

output         mcif2rbk_rd_rsp_valid;  /* data valid */
input          mcif2rbk_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2rbk_rd_rsp_pd;

output  mcif2rbk_wr_rsp_complete;

output         mcif2sdp_b_rd_rsp_valid;  /* data valid */
input          mcif2sdp_b_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_b_rd_rsp_pd;

output         mcif2sdp_e_rd_rsp_valid;  /* data valid */
input          mcif2sdp_e_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_e_rd_rsp_pd;

output         mcif2sdp_n_rd_rsp_valid;  /* data valid */
input          mcif2sdp_n_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_n_rd_rsp_pd;

output         mcif2sdp_rd_rsp_valid;  /* data valid */
input          mcif2sdp_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_rd_rsp_pd;

output  mcif2sdp_wr_rsp_complete;

input        noc2mcif_axi_b_bvalid;  /* data valid */
output       noc2mcif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2mcif_axi_b_bid;

input          noc2mcif_axi_r_rvalid;  /* data valid */
output         noc2mcif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2mcif_axi_r_rid;
input          noc2mcif_axi_r_rlast;
input  [511:0] noc2mcif_axi_r_rdata;

input  pdp2mcif_rd_cdt_lat_fifo_pop;

input         pdp2mcif_rd_req_valid;  /* data valid */
output        pdp2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] pdp2mcif_rd_req_pd;

input          pdp2mcif_wr_req_valid;  /* data valid */
output         pdp2mcif_wr_req_ready;  /* data return handshake */
input  [514:0] pdp2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input [31:0] pwrbus_ram_pd;

input  rbk2mcif_rd_cdt_lat_fifo_pop;

input         rbk2mcif_rd_req_valid;  /* data valid */
output        rbk2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] rbk2mcif_rd_req_pd;

input          rbk2mcif_wr_req_valid;  /* data valid */
output         rbk2mcif_wr_req_ready;  /* data return handshake */
input  [514:0] rbk2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input  sdp2mcif_rd_cdt_lat_fifo_pop;

input         sdp2mcif_rd_req_valid;  /* data valid */
output        sdp2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp2mcif_rd_req_pd;

input          sdp2mcif_wr_req_valid;  /* data valid */
output         sdp2mcif_wr_req_ready;  /* data return handshake */
input  [514:0] sdp2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input  sdp_b2mcif_rd_cdt_lat_fifo_pop;

input         sdp_b2mcif_rd_req_valid;  /* data valid */
output        sdp_b2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_b2mcif_rd_req_pd;

input  sdp_e2mcif_rd_cdt_lat_fifo_pop;

input         sdp_e2mcif_rd_req_valid;  /* data valid */
output        sdp_e2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_e2mcif_rd_req_pd;

input  sdp_n2mcif_rd_cdt_lat_fifo_pop;

input         sdp_n2mcif_rd_req_valid;  /* data valid */
output        sdp_n2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_n2mcif_rd_req_pd;

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

NV_NVDLA_MCIF_read u_read (
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
  ,.bdma2mcif_rd_cdt_lat_fifo_pop  (bdma2mcif_rd_cdt_lat_fifo_pop)  //|< i
  ,.bdma2mcif_rd_req_valid         (bdma2mcif_rd_req_valid)         //|< i
  ,.bdma2mcif_rd_req_ready         (bdma2mcif_rd_req_ready)         //|> o
  ,.bdma2mcif_rd_req_pd            (bdma2mcif_rd_req_pd[78:0])      //|< i
  ,.cdma_dat2mcif_rd_req_valid     (cdma_dat2mcif_rd_req_valid)     //|< i
  ,.cdma_dat2mcif_rd_req_ready     (cdma_dat2mcif_rd_req_ready)     //|> o
  ,.cdma_dat2mcif_rd_req_pd        (cdma_dat2mcif_rd_req_pd[78:0])  //|< i
  ,.cdma_wt2mcif_rd_req_valid      (cdma_wt2mcif_rd_req_valid)      //|< i
  ,.cdma_wt2mcif_rd_req_ready      (cdma_wt2mcif_rd_req_ready)      //|> o
  ,.cdma_wt2mcif_rd_req_pd         (cdma_wt2mcif_rd_req_pd[78:0])   //|< i
  ,.cdp2mcif_rd_cdt_lat_fifo_pop   (cdp2mcif_rd_cdt_lat_fifo_pop)   //|< i
  ,.cdp2mcif_rd_req_valid          (cdp2mcif_rd_req_valid)          //|< i
  ,.cdp2mcif_rd_req_ready          (cdp2mcif_rd_req_ready)          //|> o
  ,.cdp2mcif_rd_req_pd             (cdp2mcif_rd_req_pd[78:0])       //|< i
  ,.mcif2bdma_rd_rsp_valid         (mcif2bdma_rd_rsp_valid)         //|> o
  ,.mcif2bdma_rd_rsp_ready         (mcif2bdma_rd_rsp_ready)         //|< i
  ,.mcif2bdma_rd_rsp_pd            (mcif2bdma_rd_rsp_pd[513:0])     //|> o
  ,.mcif2cdma_dat_rd_rsp_valid     (mcif2cdma_dat_rd_rsp_valid)     //|> o
  ,.mcif2cdma_dat_rd_rsp_ready     (mcif2cdma_dat_rd_rsp_ready)     //|< i
  ,.mcif2cdma_dat_rd_rsp_pd        (mcif2cdma_dat_rd_rsp_pd[513:0]) //|> o
  ,.mcif2cdma_wt_rd_rsp_valid      (mcif2cdma_wt_rd_rsp_valid)      //|> o
  ,.mcif2cdma_wt_rd_rsp_ready      (mcif2cdma_wt_rd_rsp_ready)      //|< i
  ,.mcif2cdma_wt_rd_rsp_pd         (mcif2cdma_wt_rd_rsp_pd[513:0])  //|> o
  ,.mcif2cdp_rd_rsp_valid          (mcif2cdp_rd_rsp_valid)          //|> o
  ,.mcif2cdp_rd_rsp_ready          (mcif2cdp_rd_rsp_ready)          //|< i
  ,.mcif2cdp_rd_rsp_pd             (mcif2cdp_rd_rsp_pd[513:0])      //|> o
  ,.mcif2noc_axi_ar_arvalid        (mcif2noc_axi_ar_arvalid)        //|> o
  ,.mcif2noc_axi_ar_arready        (mcif2noc_axi_ar_arready)        //|< i
  ,.mcif2noc_axi_ar_arid           (mcif2noc_axi_ar_arid[7:0])      //|> o
  ,.mcif2noc_axi_ar_arlen          (mcif2noc_axi_ar_arlen[3:0])     //|> o
  ,.mcif2noc_axi_ar_araddr         (mcif2noc_axi_ar_araddr[63:0])   //|> o
  ,.mcif2pdp_rd_rsp_valid          (mcif2pdp_rd_rsp_valid)          //|> o
  ,.mcif2pdp_rd_rsp_ready          (mcif2pdp_rd_rsp_ready)          //|< i
  ,.mcif2pdp_rd_rsp_pd             (mcif2pdp_rd_rsp_pd[513:0])      //|> o
  ,.mcif2rbk_rd_rsp_valid          (mcif2rbk_rd_rsp_valid)          //|> o
  ,.mcif2rbk_rd_rsp_ready          (mcif2rbk_rd_rsp_ready)          //|< i
  ,.mcif2rbk_rd_rsp_pd             (mcif2rbk_rd_rsp_pd[513:0])      //|> o
  ,.mcif2sdp_b_rd_rsp_valid        (mcif2sdp_b_rd_rsp_valid)        //|> o
  ,.mcif2sdp_b_rd_rsp_ready        (mcif2sdp_b_rd_rsp_ready)        //|< i
  ,.mcif2sdp_b_rd_rsp_pd           (mcif2sdp_b_rd_rsp_pd[513:0])    //|> o
  ,.mcif2sdp_e_rd_rsp_valid        (mcif2sdp_e_rd_rsp_valid)        //|> o
  ,.mcif2sdp_e_rd_rsp_ready        (mcif2sdp_e_rd_rsp_ready)        //|< i
  ,.mcif2sdp_e_rd_rsp_pd           (mcif2sdp_e_rd_rsp_pd[513:0])    //|> o
  ,.mcif2sdp_n_rd_rsp_valid        (mcif2sdp_n_rd_rsp_valid)        //|> o
  ,.mcif2sdp_n_rd_rsp_ready        (mcif2sdp_n_rd_rsp_ready)        //|< i
  ,.mcif2sdp_n_rd_rsp_pd           (mcif2sdp_n_rd_rsp_pd[513:0])    //|> o
  ,.mcif2sdp_rd_rsp_valid          (mcif2sdp_rd_rsp_valid)          //|> o
  ,.mcif2sdp_rd_rsp_ready          (mcif2sdp_rd_rsp_ready)          //|< i
  ,.mcif2sdp_rd_rsp_pd             (mcif2sdp_rd_rsp_pd[513:0])      //|> o
  ,.noc2mcif_axi_r_rvalid          (noc2mcif_axi_r_rvalid)          //|< i
  ,.noc2mcif_axi_r_rready          (noc2mcif_axi_r_rready)          //|> o
  ,.noc2mcif_axi_r_rid             (noc2mcif_axi_r_rid[7:0])        //|< i
  ,.noc2mcif_axi_r_rlast           (noc2mcif_axi_r_rlast)           //|< i
  ,.noc2mcif_axi_r_rdata           (noc2mcif_axi_r_rdata[511:0])    //|< i
  ,.pdp2mcif_rd_cdt_lat_fifo_pop   (pdp2mcif_rd_cdt_lat_fifo_pop)   //|< i
  ,.pdp2mcif_rd_req_valid          (pdp2mcif_rd_req_valid)          //|< i
  ,.pdp2mcif_rd_req_ready          (pdp2mcif_rd_req_ready)          //|> o
  ,.pdp2mcif_rd_req_pd             (pdp2mcif_rd_req_pd[78:0])       //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.rbk2mcif_rd_cdt_lat_fifo_pop   (rbk2mcif_rd_cdt_lat_fifo_pop)   //|< i
  ,.rbk2mcif_rd_req_valid          (rbk2mcif_rd_req_valid)          //|< i
  ,.rbk2mcif_rd_req_ready          (rbk2mcif_rd_req_ready)          //|> o
  ,.rbk2mcif_rd_req_pd             (rbk2mcif_rd_req_pd[78:0])       //|< i
  ,.sdp2mcif_rd_cdt_lat_fifo_pop   (sdp2mcif_rd_cdt_lat_fifo_pop)   //|< i
  ,.sdp2mcif_rd_req_valid          (sdp2mcif_rd_req_valid)          //|< i
  ,.sdp2mcif_rd_req_ready          (sdp2mcif_rd_req_ready)          //|> o
  ,.sdp2mcif_rd_req_pd             (sdp2mcif_rd_req_pd[78:0])       //|< i
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop (sdp_b2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_b2mcif_rd_req_valid        (sdp_b2mcif_rd_req_valid)        //|< i
  ,.sdp_b2mcif_rd_req_ready        (sdp_b2mcif_rd_req_ready)        //|> o
  ,.sdp_b2mcif_rd_req_pd           (sdp_b2mcif_rd_req_pd[78:0])     //|< i
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2mcif_rd_req_valid)        //|< i
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2mcif_rd_req_ready)        //|> o
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2mcif_rd_req_pd[78:0])     //|< i
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop (sdp_n2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_n2mcif_rd_req_valid        (sdp_n2mcif_rd_req_valid)        //|< i
  ,.sdp_n2mcif_rd_req_ready        (sdp_n2mcif_rd_req_ready)        //|> o
  ,.sdp_n2mcif_rd_req_pd           (sdp_n2mcif_rd_req_pd[78:0])     //|< i
  );
NV_NVDLA_MCIF_write u_write (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.bdma2mcif_wr_req_valid         (bdma2mcif_wr_req_valid)         //|< i
  ,.bdma2mcif_wr_req_ready         (bdma2mcif_wr_req_ready)         //|> o
  ,.bdma2mcif_wr_req_pd            (bdma2mcif_wr_req_pd[514:0])     //|< i
  ,.cdp2mcif_wr_req_valid          (cdp2mcif_wr_req_valid)          //|< i
  ,.cdp2mcif_wr_req_ready          (cdp2mcif_wr_req_ready)          //|> o
  ,.cdp2mcif_wr_req_pd             (cdp2mcif_wr_req_pd[514:0])      //|< i
  ,.mcif2bdma_wr_rsp_complete      (mcif2bdma_wr_rsp_complete)      //|> o
  ,.mcif2cdp_wr_rsp_complete       (mcif2cdp_wr_rsp_complete)       //|> o
  ,.mcif2noc_axi_aw_awvalid        (mcif2noc_axi_aw_awvalid)        //|> o
  ,.mcif2noc_axi_aw_awready        (mcif2noc_axi_aw_awready)        //|< i
  ,.mcif2noc_axi_aw_awid           (mcif2noc_axi_aw_awid[7:0])      //|> o
  ,.mcif2noc_axi_aw_awlen          (mcif2noc_axi_aw_awlen[3:0])     //|> o
  ,.mcif2noc_axi_aw_awaddr         (mcif2noc_axi_aw_awaddr[63:0])   //|> o
  ,.mcif2noc_axi_w_wvalid          (mcif2noc_axi_w_wvalid)          //|> o
  ,.mcif2noc_axi_w_wready          (mcif2noc_axi_w_wready)          //|< i
  ,.mcif2noc_axi_w_wdata           (mcif2noc_axi_w_wdata[511:0])    //|> o
  ,.mcif2noc_axi_w_wstrb           (mcif2noc_axi_w_wstrb[63:0])     //|> o
  ,.mcif2noc_axi_w_wlast           (mcif2noc_axi_w_wlast)           //|> o
  ,.mcif2pdp_wr_rsp_complete       (mcif2pdp_wr_rsp_complete)       //|> o
  ,.mcif2rbk_wr_rsp_complete       (mcif2rbk_wr_rsp_complete)       //|> o
  ,.mcif2sdp_wr_rsp_complete       (mcif2sdp_wr_rsp_complete)       //|> o
  ,.noc2mcif_axi_b_bvalid          (noc2mcif_axi_b_bvalid)          //|< i
  ,.noc2mcif_axi_b_bready          (noc2mcif_axi_b_bready)          //|> o
  ,.noc2mcif_axi_b_bid             (noc2mcif_axi_b_bid[7:0])        //|< i
  ,.pdp2mcif_wr_req_valid          (pdp2mcif_wr_req_valid)          //|< i
  ,.pdp2mcif_wr_req_ready          (pdp2mcif_wr_req_ready)          //|> o
  ,.pdp2mcif_wr_req_pd             (pdp2mcif_wr_req_pd[514:0])      //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.rbk2mcif_wr_req_valid          (rbk2mcif_wr_req_valid)          //|< i
  ,.rbk2mcif_wr_req_ready          (rbk2mcif_wr_req_ready)          //|> o
  ,.rbk2mcif_wr_req_pd             (rbk2mcif_wr_req_pd[514:0])      //|< i
  ,.sdp2mcif_wr_req_valid          (sdp2mcif_wr_req_valid)          //|< i
  ,.sdp2mcif_wr_req_ready          (sdp2mcif_wr_req_ready)          //|> o
  ,.sdp2mcif_wr_req_pd             (sdp2mcif_wr_req_pd[514:0])      //|< i
  ,.reg2dp_wr_os_cnt               (reg2dp_wr_os_cnt[7:0])          //|< w
  ,.reg2dp_wr_weight_bdma          (reg2dp_wr_weight_bdma[7:0])     //|< w
  ,.reg2dp_wr_weight_cdp           (reg2dp_wr_weight_cdp[7:0])      //|< w
  ,.reg2dp_wr_weight_pdp           (reg2dp_wr_weight_pdp[7:0])      //|< w
  ,.reg2dp_wr_weight_rbk           (reg2dp_wr_weight_rbk[7:0])      //|< w
  ,.reg2dp_wr_weight_sdp           (reg2dp_wr_weight_sdp[7:0])      //|< w
  );

NV_NVDLA_MCIF_csb u_csb (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.csb2mcif_req_pvld              (csb2mcif_req_pvld)              //|< i
  ,.csb2mcif_req_prdy              (csb2mcif_req_prdy)              //|> o
  ,.csb2mcif_req_pd                (csb2mcif_req_pd[62:0])          //|< i
  ,.mcif2csb_resp_valid            (mcif2csb_resp_valid)            //|> o
  ,.mcif2csb_resp_pd               (mcif2csb_resp_pd[33:0])         //|> o
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

endmodule // NV_NVDLA_mcif

