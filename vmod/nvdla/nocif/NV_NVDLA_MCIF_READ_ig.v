// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_READ_ig.v

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_READ_ig (
   bdma2mcif_rd_cdt_lat_fifo_pop  //|< i
  ,bdma2mcif_rd_req_pd            //|< i
  ,bdma2mcif_rd_req_valid         //|< i
  ,cdma_dat2mcif_rd_req_pd        //|< i
  ,cdma_dat2mcif_rd_req_valid     //|< i
  ,cdma_wt2mcif_rd_req_pd         //|< i
  ,cdma_wt2mcif_rd_req_valid      //|< i
  ,cdp2mcif_rd_cdt_lat_fifo_pop   //|< i
  ,cdp2mcif_rd_req_pd             //|< i
  ,cdp2mcif_rd_req_valid          //|< i
  ,cq_wr_prdy                     //|< i
  ,eg2ig_axi_vld                  //|< i
  ,mcif2noc_axi_ar_arready        //|< i
  ,nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,pdp2mcif_rd_cdt_lat_fifo_pop   //|< i
  ,pdp2mcif_rd_req_pd             //|< i
  ,pdp2mcif_rd_req_valid          //|< i
  ,rbk2mcif_rd_cdt_lat_fifo_pop   //|< i
  ,rbk2mcif_rd_req_pd             //|< i
  ,rbk2mcif_rd_req_valid          //|< i
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
  ,sdp2mcif_rd_cdt_lat_fifo_pop   //|< i
  ,sdp2mcif_rd_req_pd             //|< i
  ,sdp2mcif_rd_req_valid          //|< i
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
  ,cdma_dat2mcif_rd_req_ready     //|> o
  ,cdma_wt2mcif_rd_req_ready      //|> o
  ,cdp2mcif_rd_req_ready          //|> o
  ,cq_wr_pd                       //|> o
  ,cq_wr_pvld                     //|> o
  ,cq_wr_thread_id                //|> o
  ,mcif2noc_axi_ar_araddr         //|> o
  ,mcif2noc_axi_ar_arid           //|> o
  ,mcif2noc_axi_ar_arlen          //|> o
  ,mcif2noc_axi_ar_arvalid        //|> o
  ,pdp2mcif_rd_req_ready          //|> o
  ,rbk2mcif_rd_req_ready          //|> o
  ,sdp2mcif_rd_req_ready          //|> o
  ,sdp_b2mcif_rd_req_ready        //|> o
  ,sdp_e2mcif_rd_req_ready        //|> o
  ,sdp_n2mcif_rd_req_ready        //|> o
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
// NV_NVDLA_MCIF_READ_ig_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input  bdma2mcif_rd_cdt_lat_fifo_pop;

input         bdma2mcif_rd_req_valid;  /* data valid */
output        bdma2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] bdma2mcif_rd_req_pd;

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

output       cq_wr_pvld;       /* data valid */
input        cq_wr_prdy;       /* data return handshake */
output [3:0] cq_wr_thread_id;
output [6:0] cq_wr_pd;

output        mcif2noc_axi_ar_arvalid;  /* data valid */
input         mcif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [63:0] mcif2noc_axi_ar_araddr;

input  pdp2mcif_rd_cdt_lat_fifo_pop;

input         pdp2mcif_rd_req_valid;  /* data valid */
output        pdp2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] pdp2mcif_rd_req_pd;

input  rbk2mcif_rd_cdt_lat_fifo_pop;

input         rbk2mcif_rd_req_valid;  /* data valid */
output        rbk2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] rbk2mcif_rd_req_pd;

input  sdp2mcif_rd_cdt_lat_fifo_pop;

input         sdp2mcif_rd_req_valid;  /* data valid */
output        sdp2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp2mcif_rd_req_pd;

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

input        eg2ig_axi_vld;
input  [7:0] reg2dp_rd_os_cnt;
input  [7:0] reg2dp_rd_weight_bdma;
input  [7:0] reg2dp_rd_weight_cdma_dat;
input  [7:0] reg2dp_rd_weight_cdma_wt;
input  [7:0] reg2dp_rd_weight_cdp;
input  [7:0] reg2dp_rd_weight_pdp;
input  [7:0] reg2dp_rd_weight_rbk;
input  [7:0] reg2dp_rd_weight_sdp;
input  [7:0] reg2dp_rd_weight_sdp_b;
input  [7:0] reg2dp_rd_weight_sdp_e;
input  [7:0] reg2dp_rd_weight_sdp_n;
wire  [74:0] arb2spt_req_pd;
wire         arb2spt_req_ready;
wire         arb2spt_req_valid;
wire  [74:0] bpt2arb_req0_pd;
wire         bpt2arb_req0_ready;
wire         bpt2arb_req0_valid;
wire  [74:0] bpt2arb_req1_pd;
wire         bpt2arb_req1_ready;
wire         bpt2arb_req1_valid;
wire  [74:0] bpt2arb_req2_pd;
wire         bpt2arb_req2_ready;
wire         bpt2arb_req2_valid;
wire  [74:0] bpt2arb_req3_pd;
wire         bpt2arb_req3_ready;
wire         bpt2arb_req3_valid;
wire  [74:0] bpt2arb_req4_pd;
wire         bpt2arb_req4_ready;
wire         bpt2arb_req4_valid;
wire  [74:0] bpt2arb_req5_pd;
wire         bpt2arb_req5_ready;
wire         bpt2arb_req5_valid;
wire  [74:0] bpt2arb_req6_pd;
wire         bpt2arb_req6_ready;
wire         bpt2arb_req6_valid;
wire  [74:0] bpt2arb_req7_pd;
wire         bpt2arb_req7_ready;
wire         bpt2arb_req7_valid;
wire  [74:0] bpt2arb_req8_pd;
wire         bpt2arb_req8_ready;
wire         bpt2arb_req8_valid;
wire  [74:0] bpt2arb_req9_pd;
wire         bpt2arb_req9_ready;
wire         bpt2arb_req9_valid;
wire  [74:0] spt2cvt_req_pd;
wire         spt2cvt_req_ready;
wire         spt2cvt_req_valid;

NV_NVDLA_MCIF_READ_IG_bpt u_bpt0 (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.dma2bpt_req_valid         (bdma2mcif_rd_req_valid)         //|< i
  ,.dma2bpt_req_ready         (bdma2mcif_rd_req_ready)         //|> o
  ,.dma2bpt_req_pd            (bdma2mcif_rd_req_pd[78:0])      //|< i
  ,.dma2bpt_cdt_lat_fifo_pop  (bdma2mcif_rd_cdt_lat_fifo_pop)  //|< i
  ,.bpt2arb_req_valid         (bpt2arb_req0_valid)             //|> w
  ,.bpt2arb_req_ready         (bpt2arb_req0_ready)             //|< w
  ,.bpt2arb_req_pd            (bpt2arb_req0_pd[74:0])          //|> w
  ,.tieoff_axid               (4'd0)                           //|< ?
  ,.tieoff_lat_fifo_depth     (8'd245)                         //|< ?
  );
NV_NVDLA_MCIF_READ_IG_bpt u_bpt1 (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.dma2bpt_req_valid         (sdp2mcif_rd_req_valid)          //|< i
  ,.dma2bpt_req_ready         (sdp2mcif_rd_req_ready)          //|> o
  ,.dma2bpt_req_pd            (sdp2mcif_rd_req_pd[78:0])       //|< i
  ,.dma2bpt_cdt_lat_fifo_pop  (sdp2mcif_rd_cdt_lat_fifo_pop)   //|< i
  ,.bpt2arb_req_valid         (bpt2arb_req1_valid)             //|> w
  ,.bpt2arb_req_ready         (bpt2arb_req1_ready)             //|< w
  ,.bpt2arb_req_pd            (bpt2arb_req1_pd[74:0])          //|> w
  ,.tieoff_axid               (4'd1)                           //|< ?
  ,.tieoff_lat_fifo_depth     (8'd80)                          //|< ?
  );
NV_NVDLA_MCIF_READ_IG_bpt u_bpt2 (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.dma2bpt_req_valid         (pdp2mcif_rd_req_valid)          //|< i
  ,.dma2bpt_req_ready         (pdp2mcif_rd_req_ready)          //|> o
  ,.dma2bpt_req_pd            (pdp2mcif_rd_req_pd[78:0])       //|< i
  ,.dma2bpt_cdt_lat_fifo_pop  (pdp2mcif_rd_cdt_lat_fifo_pop)   //|< i
  ,.bpt2arb_req_valid         (bpt2arb_req2_valid)             //|> w
  ,.bpt2arb_req_ready         (bpt2arb_req2_ready)             //|< w
  ,.bpt2arb_req_pd            (bpt2arb_req2_pd[74:0])          //|> w
  ,.tieoff_axid               (4'd2)                           //|< ?
  ,.tieoff_lat_fifo_depth     (8'd61)                          //|< ?
  );
NV_NVDLA_MCIF_READ_IG_bpt u_bpt3 (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.dma2bpt_req_valid         (cdp2mcif_rd_req_valid)          //|< i
  ,.dma2bpt_req_ready         (cdp2mcif_rd_req_ready)          //|> o
  ,.dma2bpt_req_pd            (cdp2mcif_rd_req_pd[78:0])       //|< i
  ,.dma2bpt_cdt_lat_fifo_pop  (cdp2mcif_rd_cdt_lat_fifo_pop)   //|< i
  ,.bpt2arb_req_valid         (bpt2arb_req3_valid)             //|> w
  ,.bpt2arb_req_ready         (bpt2arb_req3_ready)             //|< w
  ,.bpt2arb_req_pd            (bpt2arb_req3_pd[74:0])          //|> w
  ,.tieoff_axid               (4'd3)                           //|< ?
  ,.tieoff_lat_fifo_depth     (8'd61)                          //|< ?
  );
NV_NVDLA_MCIF_READ_IG_bpt u_bpt4 (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.dma2bpt_req_valid         (rbk2mcif_rd_req_valid)          //|< i
  ,.dma2bpt_req_ready         (rbk2mcif_rd_req_ready)          //|> o
  ,.dma2bpt_req_pd            (rbk2mcif_rd_req_pd[78:0])       //|< i
  ,.dma2bpt_cdt_lat_fifo_pop  (rbk2mcif_rd_cdt_lat_fifo_pop)   //|< i
  ,.bpt2arb_req_valid         (bpt2arb_req4_valid)             //|> w
  ,.bpt2arb_req_ready         (bpt2arb_req4_ready)             //|< w
  ,.bpt2arb_req_pd            (bpt2arb_req4_pd[74:0])          //|> w
  ,.tieoff_axid               (4'd4)                           //|< ?
  ,.tieoff_lat_fifo_depth     (8'd80)                          //|< ?
  );
NV_NVDLA_MCIF_READ_IG_bpt u_bpt5 (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.dma2bpt_req_valid         (sdp_b2mcif_rd_req_valid)        //|< i
  ,.dma2bpt_req_ready         (sdp_b2mcif_rd_req_ready)        //|> o
  ,.dma2bpt_req_pd            (sdp_b2mcif_rd_req_pd[78:0])     //|< i
  ,.dma2bpt_cdt_lat_fifo_pop  (sdp_b2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.bpt2arb_req_valid         (bpt2arb_req5_valid)             //|> w
  ,.bpt2arb_req_ready         (bpt2arb_req5_ready)             //|< w
  ,.bpt2arb_req_pd            (bpt2arb_req5_pd[74:0])          //|> w
  ,.tieoff_axid               (4'd5)                           //|< ?
  ,.tieoff_lat_fifo_depth     (8'd160)                         //|< ?
  );
NV_NVDLA_MCIF_READ_IG_bpt u_bpt6 (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.dma2bpt_req_valid         (sdp_n2mcif_rd_req_valid)        //|< i
  ,.dma2bpt_req_ready         (sdp_n2mcif_rd_req_ready)        //|> o
  ,.dma2bpt_req_pd            (sdp_n2mcif_rd_req_pd[78:0])     //|< i
  ,.dma2bpt_cdt_lat_fifo_pop  (sdp_n2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.bpt2arb_req_valid         (bpt2arb_req6_valid)             //|> w
  ,.bpt2arb_req_ready         (bpt2arb_req6_ready)             //|< w
  ,.bpt2arb_req_pd            (bpt2arb_req6_pd[74:0])          //|> w
  ,.tieoff_axid               (4'd6)                           //|< ?
  ,.tieoff_lat_fifo_depth     (8'd160)                         //|< ?
  );
NV_NVDLA_MCIF_READ_IG_bpt u_bpt7 (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.dma2bpt_req_valid         (sdp_e2mcif_rd_req_valid)        //|< i
  ,.dma2bpt_req_ready         (sdp_e2mcif_rd_req_ready)        //|> o
  ,.dma2bpt_req_pd            (sdp_e2mcif_rd_req_pd[78:0])     //|< i
  ,.dma2bpt_cdt_lat_fifo_pop  (sdp_e2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.bpt2arb_req_valid         (bpt2arb_req7_valid)             //|> w
  ,.bpt2arb_req_ready         (bpt2arb_req7_ready)             //|< w
  ,.bpt2arb_req_pd            (bpt2arb_req7_pd[74:0])          //|> w
  ,.tieoff_axid               (4'd7)                           //|< ?
  ,.tieoff_lat_fifo_depth     (8'd80)                          //|< ?
  );
NV_NVDLA_MCIF_READ_IG_bpt u_bpt8 (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.dma2bpt_req_valid         (cdma_dat2mcif_rd_req_valid)     //|< i
  ,.dma2bpt_req_ready         (cdma_dat2mcif_rd_req_ready)     //|> o
  ,.dma2bpt_req_pd            (cdma_dat2mcif_rd_req_pd[78:0])  //|< i
  ,.dma2bpt_cdt_lat_fifo_pop  ({1{1'b0}})                      //|< ?
  ,.bpt2arb_req_valid         (bpt2arb_req8_valid)             //|> w
  ,.bpt2arb_req_ready         (bpt2arb_req8_ready)             //|< w
  ,.bpt2arb_req_pd            (bpt2arb_req8_pd[74:0])          //|> w
  ,.tieoff_axid               (4'd8)                           //|< ?
  ,.tieoff_lat_fifo_depth     (8'd0)                           //|< ?
  );
NV_NVDLA_MCIF_READ_IG_bpt u_bpt9 (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.dma2bpt_req_valid         (cdma_wt2mcif_rd_req_valid)      //|< i
  ,.dma2bpt_req_ready         (cdma_wt2mcif_rd_req_ready)      //|> o
  ,.dma2bpt_req_pd            (cdma_wt2mcif_rd_req_pd[78:0])   //|< i
  ,.dma2bpt_cdt_lat_fifo_pop  ({1{1'b0}})                      //|< ?
  ,.bpt2arb_req_valid         (bpt2arb_req9_valid)             //|> w
  ,.bpt2arb_req_ready         (bpt2arb_req9_ready)             //|< w
  ,.bpt2arb_req_pd            (bpt2arb_req9_pd[74:0])          //|> w
  ,.tieoff_axid               (4'd9)                           //|< ?
  ,.tieoff_lat_fifo_depth     (8'd0)                           //|< ?
  );

NV_NVDLA_MCIF_READ_IG_arb u_arb (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.bpt2arb_req0_valid        (bpt2arb_req0_valid)             //|< w
  ,.bpt2arb_req0_ready        (bpt2arb_req0_ready)             //|> w
  ,.bpt2arb_req0_pd           (bpt2arb_req0_pd[74:0])          //|< w
  ,.bpt2arb_req1_valid        (bpt2arb_req1_valid)             //|< w
  ,.bpt2arb_req1_ready        (bpt2arb_req1_ready)             //|> w
  ,.bpt2arb_req1_pd           (bpt2arb_req1_pd[74:0])          //|< w
  ,.bpt2arb_req2_valid        (bpt2arb_req2_valid)             //|< w
  ,.bpt2arb_req2_ready        (bpt2arb_req2_ready)             //|> w
  ,.bpt2arb_req2_pd           (bpt2arb_req2_pd[74:0])          //|< w
  ,.bpt2arb_req3_valid        (bpt2arb_req3_valid)             //|< w
  ,.bpt2arb_req3_ready        (bpt2arb_req3_ready)             //|> w
  ,.bpt2arb_req3_pd           (bpt2arb_req3_pd[74:0])          //|< w
  ,.bpt2arb_req4_valid        (bpt2arb_req4_valid)             //|< w
  ,.bpt2arb_req4_ready        (bpt2arb_req4_ready)             //|> w
  ,.bpt2arb_req4_pd           (bpt2arb_req4_pd[74:0])          //|< w
  ,.bpt2arb_req5_valid        (bpt2arb_req5_valid)             //|< w
  ,.bpt2arb_req5_ready        (bpt2arb_req5_ready)             //|> w
  ,.bpt2arb_req5_pd           (bpt2arb_req5_pd[74:0])          //|< w
  ,.bpt2arb_req6_valid        (bpt2arb_req6_valid)             //|< w
  ,.bpt2arb_req6_ready        (bpt2arb_req6_ready)             //|> w
  ,.bpt2arb_req6_pd           (bpt2arb_req6_pd[74:0])          //|< w
  ,.bpt2arb_req7_valid        (bpt2arb_req7_valid)             //|< w
  ,.bpt2arb_req7_ready        (bpt2arb_req7_ready)             //|> w
  ,.bpt2arb_req7_pd           (bpt2arb_req7_pd[74:0])          //|< w
  ,.bpt2arb_req8_valid        (bpt2arb_req8_valid)             //|< w
  ,.bpt2arb_req8_ready        (bpt2arb_req8_ready)             //|> w
  ,.bpt2arb_req8_pd           (bpt2arb_req8_pd[74:0])          //|< w
  ,.bpt2arb_req9_valid        (bpt2arb_req9_valid)             //|< w
  ,.bpt2arb_req9_ready        (bpt2arb_req9_ready)             //|> w
  ,.bpt2arb_req9_pd           (bpt2arb_req9_pd[74:0])          //|< w
  ,.arb2spt_req_valid         (arb2spt_req_valid)              //|> w
  ,.arb2spt_req_ready         (arb2spt_req_ready)              //|< w
  ,.arb2spt_req_pd            (arb2spt_req_pd[74:0])           //|> w
  ,.reg2dp_rd_weight_bdma     (reg2dp_rd_weight_bdma[7:0])     //|< i
  ,.reg2dp_rd_weight_cdma_dat (reg2dp_rd_weight_cdma_dat[7:0]) //|< i
  ,.reg2dp_rd_weight_cdma_wt  (reg2dp_rd_weight_cdma_wt[7:0])  //|< i
  ,.reg2dp_rd_weight_cdp      (reg2dp_rd_weight_cdp[7:0])      //|< i
  ,.reg2dp_rd_weight_pdp      (reg2dp_rd_weight_pdp[7:0])      //|< i
  ,.reg2dp_rd_weight_rbk      (reg2dp_rd_weight_rbk[7:0])      //|< i
  ,.reg2dp_rd_weight_sdp      (reg2dp_rd_weight_sdp[7:0])      //|< i
  ,.reg2dp_rd_weight_sdp_b    (reg2dp_rd_weight_sdp_b[7:0])    //|< i
  ,.reg2dp_rd_weight_sdp_e    (reg2dp_rd_weight_sdp_e[7:0])    //|< i
  ,.reg2dp_rd_weight_sdp_n    (reg2dp_rd_weight_sdp_n[7:0])    //|< i
  );
NV_NVDLA_MCIF_READ_IG_spt u_spt (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.arb2spt_req_valid         (arb2spt_req_valid)              //|< w
  ,.arb2spt_req_ready         (arb2spt_req_ready)              //|> w
  ,.arb2spt_req_pd            (arb2spt_req_pd[74:0])           //|< w
  ,.spt2cvt_req_valid         (spt2cvt_req_valid)              //|> w
  ,.spt2cvt_req_ready         (spt2cvt_req_ready)              //|< w
  ,.spt2cvt_req_pd            (spt2cvt_req_pd[74:0])           //|> w
  );
NV_NVDLA_MCIF_READ_IG_cvt u_cvt (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.spt2cvt_req_valid         (spt2cvt_req_valid)              //|< w
  ,.spt2cvt_req_ready         (spt2cvt_req_ready)              //|> w
  ,.spt2cvt_req_pd            (spt2cvt_req_pd[74:0])           //|< w
  ,.cq_wr_pvld                (cq_wr_pvld)                     //|> o
  ,.cq_wr_prdy                (cq_wr_prdy)                     //|< i
  ,.cq_wr_thread_id           (cq_wr_thread_id[3:0])           //|> o
  ,.cq_wr_pd                  (cq_wr_pd[6:0])                  //|> o
  ,.mcif2noc_axi_ar_arvalid   (mcif2noc_axi_ar_arvalid)        //|> o
  ,.mcif2noc_axi_ar_arready   (mcif2noc_axi_ar_arready)        //|< i
  ,.mcif2noc_axi_ar_arid      (mcif2noc_axi_ar_arid[7:0])      //|> o
  ,.mcif2noc_axi_ar_arlen     (mcif2noc_axi_ar_arlen[3:0])     //|> o
  ,.mcif2noc_axi_ar_araddr    (mcif2noc_axi_ar_araddr[63:0])   //|> o
  ,.reg2dp_rd_os_cnt          (reg2dp_rd_os_cnt[7:0])          //|< i
  ,.eg2ig_axi_vld             (eg2ig_axi_vld)                  //|< i
  );

endmodule // NV_NVDLA_MCIF_READ_ig

