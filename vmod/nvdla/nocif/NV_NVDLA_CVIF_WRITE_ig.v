// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CVIF_WRITE_ig.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CVIF_WRITE_ig (
   bdma2cvif_wr_req_pd     //|< i
  ,bdma2cvif_wr_req_valid  //|< i
  ,cdp2cvif_wr_req_pd      //|< i
  ,cdp2cvif_wr_req_valid   //|< i
  ,cq_wr_prdy              //|< i
  ,cvif2noc_axi_aw_awready //|< i
  ,cvif2noc_axi_w_wready   //|< i
  ,eg2ig_axi_len           //|< i
  ,eg2ig_axi_vld           //|< i
  ,nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,pdp2cvif_wr_req_pd      //|< i
  ,pdp2cvif_wr_req_valid   //|< i
  ,pwrbus_ram_pd           //|< i
  ,rbk2cvif_wr_req_pd      //|< i
  ,rbk2cvif_wr_req_valid   //|< i
  ,reg2dp_wr_os_cnt        //|< i
  ,reg2dp_wr_weight_bdma   //|< i
  ,reg2dp_wr_weight_cdp    //|< i
  ,reg2dp_wr_weight_pdp    //|< i
  ,reg2dp_wr_weight_rbk    //|< i
  ,reg2dp_wr_weight_sdp    //|< i
  ,sdp2cvif_wr_req_pd      //|< i
  ,sdp2cvif_wr_req_valid   //|< i
  ,bdma2cvif_wr_req_ready  //|> o
  ,cdp2cvif_wr_req_ready   //|> o
  ,cq_wr_pd                //|> o
  ,cq_wr_pvld              //|> o
  ,cq_wr_thread_id         //|> o
  ,cvif2noc_axi_aw_awaddr  //|> o
  ,cvif2noc_axi_aw_awid    //|> o
  ,cvif2noc_axi_aw_awlen   //|> o
  ,cvif2noc_axi_aw_awvalid //|> o
  ,cvif2noc_axi_w_wdata    //|> o
  ,cvif2noc_axi_w_wlast    //|> o
  ,cvif2noc_axi_w_wstrb    //|> o
  ,cvif2noc_axi_w_wvalid   //|> o
  ,pdp2cvif_wr_req_ready   //|> o
  ,rbk2cvif_wr_req_ready   //|> o
  ,sdp2cvif_wr_req_ready   //|> o
  );

//
// NV_NVDLA_CVIF_WRITE_ig_ports.v
//
input  nvdla_core_clk;   /* bdma2cvif_wr_req, cdp2cvif_wr_req, cq_wr, cvif2noc_axi_aw, cvif2noc_axi_w, pdp2cvif_wr_req, rbk2cvif_wr_req, sdp2cvif_wr_req */
input  nvdla_core_rstn;  /* bdma2cvif_wr_req, cdp2cvif_wr_req, cq_wr, cvif2noc_axi_aw, cvif2noc_axi_w, pdp2cvif_wr_req, rbk2cvif_wr_req, sdp2cvif_wr_req */

input          bdma2cvif_wr_req_valid;  /* data valid */
output         bdma2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] bdma2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input          cdp2cvif_wr_req_valid;  /* data valid */
output         cdp2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] cdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

output       cq_wr_pvld;       /* data valid */
input        cq_wr_prdy;       /* data return handshake */
output [2:0] cq_wr_thread_id;
output [2:0] cq_wr_pd;

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

input          pdp2cvif_wr_req_valid;  /* data valid */
output         pdp2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] pdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input [31:0] pwrbus_ram_pd;

input          rbk2cvif_wr_req_valid;  /* data valid */
output         rbk2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] rbk2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input          sdp2cvif_wr_req_valid;  /* data valid */
output         sdp2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] sdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input   [7:0] reg2dp_wr_os_cnt;
input   [7:0] reg2dp_wr_weight_bdma;
input   [7:0] reg2dp_wr_weight_cdp;
input   [7:0] reg2dp_wr_weight_pdp;
input   [7:0] reg2dp_wr_weight_rbk;
input   [7:0] reg2dp_wr_weight_sdp;
input   [1:0] eg2ig_axi_len;
input         eg2ig_axi_vld;
wire   [76:0] arb2spt_cmd_pd;
wire          arb2spt_cmd_ready;
wire          arb2spt_cmd_valid;
wire  [513:0] arb2spt_dat_pd;
wire          arb2spt_dat_ready;
wire          arb2spt_dat_valid;
wire   [76:0] bpt2arb_cmd0_pd;
wire          bpt2arb_cmd0_ready;
wire          bpt2arb_cmd0_valid;
wire   [76:0] bpt2arb_cmd1_pd;
wire          bpt2arb_cmd1_ready;
wire          bpt2arb_cmd1_valid;
wire   [76:0] bpt2arb_cmd2_pd;
wire          bpt2arb_cmd2_ready;
wire          bpt2arb_cmd2_valid;
wire   [76:0] bpt2arb_cmd3_pd;
wire          bpt2arb_cmd3_ready;
wire          bpt2arb_cmd3_valid;
wire   [76:0] bpt2arb_cmd4_pd;
wire          bpt2arb_cmd4_ready;
wire          bpt2arb_cmd4_valid;
wire  [513:0] bpt2arb_dat0_pd;
wire          bpt2arb_dat0_ready;
wire          bpt2arb_dat0_valid;
wire  [513:0] bpt2arb_dat1_pd;
wire          bpt2arb_dat1_ready;
wire          bpt2arb_dat1_valid;
wire  [513:0] bpt2arb_dat2_pd;
wire          bpt2arb_dat2_ready;
wire          bpt2arb_dat2_valid;
wire  [513:0] bpt2arb_dat3_pd;
wire          bpt2arb_dat3_ready;
wire          bpt2arb_dat3_valid;
wire  [513:0] bpt2arb_dat4_pd;
wire          bpt2arb_dat4_ready;
wire          bpt2arb_dat4_valid;
wire   [76:0] spt2cvt_cmd_pd;
wire          spt2cvt_cmd_ready;
wire          spt2cvt_cmd_valid;
wire  [513:0] spt2cvt_dat_pd;
wire          spt2cvt_dat_ready;
wire          spt2cvt_dat_valid;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
NV_NVDLA_CVIF_WRITE_IG_bpt u_bpt0 (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.dma2bpt_req_valid       (bdma2cvif_wr_req_valid)       //|< i
  ,.dma2bpt_req_ready       (bdma2cvif_wr_req_ready)       //|> o
  ,.dma2bpt_req_pd          (bdma2cvif_wr_req_pd[514:0])   //|< i
  ,.bpt2arb_cmd_valid       (bpt2arb_cmd0_valid)           //|> w
  ,.bpt2arb_cmd_ready       (bpt2arb_cmd0_ready)           //|< w
  ,.bpt2arb_cmd_pd          (bpt2arb_cmd0_pd[76:0])        //|> w
  ,.bpt2arb_dat_valid       (bpt2arb_dat0_valid)           //|> w
  ,.bpt2arb_dat_ready       (bpt2arb_dat0_ready)           //|< w
  ,.bpt2arb_dat_pd          (bpt2arb_dat0_pd[513:0])       //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|< i
  ,.axid                    (4'd0)                         //|< ?
  );

NV_NVDLA_CVIF_WRITE_IG_bpt u_bpt1 (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.dma2bpt_req_valid       (sdp2cvif_wr_req_valid)        //|< i
  ,.dma2bpt_req_ready       (sdp2cvif_wr_req_ready)        //|> o
  ,.dma2bpt_req_pd          (sdp2cvif_wr_req_pd[514:0])    //|< i
  ,.bpt2arb_cmd_valid       (bpt2arb_cmd1_valid)           //|> w
  ,.bpt2arb_cmd_ready       (bpt2arb_cmd1_ready)           //|< w
  ,.bpt2arb_cmd_pd          (bpt2arb_cmd1_pd[76:0])        //|> w
  ,.bpt2arb_dat_valid       (bpt2arb_dat1_valid)           //|> w
  ,.bpt2arb_dat_ready       (bpt2arb_dat1_ready)           //|< w
  ,.bpt2arb_dat_pd          (bpt2arb_dat1_pd[513:0])       //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|< i
  ,.axid                    (4'd1)                         //|< ?
  );

NV_NVDLA_CVIF_WRITE_IG_bpt u_bpt2 (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.dma2bpt_req_valid       (pdp2cvif_wr_req_valid)        //|< i
  ,.dma2bpt_req_ready       (pdp2cvif_wr_req_ready)        //|> o
  ,.dma2bpt_req_pd          (pdp2cvif_wr_req_pd[514:0])    //|< i
  ,.bpt2arb_cmd_valid       (bpt2arb_cmd2_valid)           //|> w
  ,.bpt2arb_cmd_ready       (bpt2arb_cmd2_ready)           //|< w
  ,.bpt2arb_cmd_pd          (bpt2arb_cmd2_pd[76:0])        //|> w
  ,.bpt2arb_dat_valid       (bpt2arb_dat2_valid)           //|> w
  ,.bpt2arb_dat_ready       (bpt2arb_dat2_ready)           //|< w
  ,.bpt2arb_dat_pd          (bpt2arb_dat2_pd[513:0])       //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|< i
  ,.axid                    (4'd2)                         //|< ?
  );

NV_NVDLA_CVIF_WRITE_IG_bpt u_bpt3 (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.dma2bpt_req_valid       (cdp2cvif_wr_req_valid)        //|< i
  ,.dma2bpt_req_ready       (cdp2cvif_wr_req_ready)        //|> o
  ,.dma2bpt_req_pd          (cdp2cvif_wr_req_pd[514:0])    //|< i
  ,.bpt2arb_cmd_valid       (bpt2arb_cmd3_valid)           //|> w
  ,.bpt2arb_cmd_ready       (bpt2arb_cmd3_ready)           //|< w
  ,.bpt2arb_cmd_pd          (bpt2arb_cmd3_pd[76:0])        //|> w
  ,.bpt2arb_dat_valid       (bpt2arb_dat3_valid)           //|> w
  ,.bpt2arb_dat_ready       (bpt2arb_dat3_ready)           //|< w
  ,.bpt2arb_dat_pd          (bpt2arb_dat3_pd[513:0])       //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|< i
  ,.axid                    (4'd3)                         //|< ?
  );

NV_NVDLA_CVIF_WRITE_IG_bpt u_bpt4 (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.dma2bpt_req_valid       (rbk2cvif_wr_req_valid)        //|< i
  ,.dma2bpt_req_ready       (rbk2cvif_wr_req_ready)        //|> o
  ,.dma2bpt_req_pd          (rbk2cvif_wr_req_pd[514:0])    //|< i
  ,.bpt2arb_cmd_valid       (bpt2arb_cmd4_valid)           //|> w
  ,.bpt2arb_cmd_ready       (bpt2arb_cmd4_ready)           //|< w
  ,.bpt2arb_cmd_pd          (bpt2arb_cmd4_pd[76:0])        //|> w
  ,.bpt2arb_dat_valid       (bpt2arb_dat4_valid)           //|> w
  ,.bpt2arb_dat_ready       (bpt2arb_dat4_ready)           //|< w
  ,.bpt2arb_dat_pd          (bpt2arb_dat4_pd[513:0])       //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|< i
  ,.axid                    (4'd4)                         //|< ?
  );


NV_NVDLA_CVIF_WRITE_IG_arb u_arb (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.bpt2arb_cmd0_valid      (bpt2arb_cmd0_valid)           //|< w
  ,.bpt2arb_cmd0_ready      (bpt2arb_cmd0_ready)           //|> w
  ,.bpt2arb_cmd0_pd         (bpt2arb_cmd0_pd[76:0])        //|< w
  ,.bpt2arb_cmd1_valid      (bpt2arb_cmd1_valid)           //|< w
  ,.bpt2arb_cmd1_ready      (bpt2arb_cmd1_ready)           //|> w
  ,.bpt2arb_cmd1_pd         (bpt2arb_cmd1_pd[76:0])        //|< w
  ,.bpt2arb_cmd2_valid      (bpt2arb_cmd2_valid)           //|< w
  ,.bpt2arb_cmd2_ready      (bpt2arb_cmd2_ready)           //|> w
  ,.bpt2arb_cmd2_pd         (bpt2arb_cmd2_pd[76:0])        //|< w
  ,.bpt2arb_cmd3_valid      (bpt2arb_cmd3_valid)           //|< w
  ,.bpt2arb_cmd3_ready      (bpt2arb_cmd3_ready)           //|> w
  ,.bpt2arb_cmd3_pd         (bpt2arb_cmd3_pd[76:0])        //|< w
  ,.bpt2arb_cmd4_valid      (bpt2arb_cmd4_valid)           //|< w
  ,.bpt2arb_cmd4_ready      (bpt2arb_cmd4_ready)           //|> w
  ,.bpt2arb_cmd4_pd         (bpt2arb_cmd4_pd[76:0])        //|< w
  ,.bpt2arb_dat0_valid      (bpt2arb_dat0_valid)           //|< w
  ,.bpt2arb_dat0_ready      (bpt2arb_dat0_ready)           //|> w
  ,.bpt2arb_dat0_pd         (bpt2arb_dat0_pd[513:0])       //|< w
  ,.bpt2arb_dat1_valid      (bpt2arb_dat1_valid)           //|< w
  ,.bpt2arb_dat1_ready      (bpt2arb_dat1_ready)           //|> w
  ,.bpt2arb_dat1_pd         (bpt2arb_dat1_pd[513:0])       //|< w
  ,.bpt2arb_dat2_valid      (bpt2arb_dat2_valid)           //|< w
  ,.bpt2arb_dat2_ready      (bpt2arb_dat2_ready)           //|> w
  ,.bpt2arb_dat2_pd         (bpt2arb_dat2_pd[513:0])       //|< w
  ,.bpt2arb_dat3_valid      (bpt2arb_dat3_valid)           //|< w
  ,.bpt2arb_dat3_ready      (bpt2arb_dat3_ready)           //|> w
  ,.bpt2arb_dat3_pd         (bpt2arb_dat3_pd[513:0])       //|< w
  ,.bpt2arb_dat4_valid      (bpt2arb_dat4_valid)           //|< w
  ,.bpt2arb_dat4_ready      (bpt2arb_dat4_ready)           //|> w
  ,.bpt2arb_dat4_pd         (bpt2arb_dat4_pd[513:0])       //|< w
  ,.arb2spt_cmd_valid       (arb2spt_cmd_valid)            //|> w
  ,.arb2spt_cmd_ready       (arb2spt_cmd_ready)            //|< w
  ,.arb2spt_cmd_pd          (arb2spt_cmd_pd[76:0])         //|> w
  ,.arb2spt_dat_valid       (arb2spt_dat_valid)            //|> w
  ,.arb2spt_dat_ready       (arb2spt_dat_ready)            //|< w
  ,.arb2spt_dat_pd          (arb2spt_dat_pd[513:0])        //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|< i
  ,.reg2dp_wr_weight_bdma   (reg2dp_wr_weight_bdma[7:0])   //|< i
  ,.reg2dp_wr_weight_cdp    (reg2dp_wr_weight_cdp[7:0])    //|< i
  ,.reg2dp_wr_weight_pdp    (reg2dp_wr_weight_pdp[7:0])    //|< i
  ,.reg2dp_wr_weight_rbk    (reg2dp_wr_weight_rbk[7:0])    //|< i
  ,.reg2dp_wr_weight_sdp    (reg2dp_wr_weight_sdp[7:0])    //|< i
  );
NV_NVDLA_CVIF_WRITE_IG_spt u_spt (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.arb2spt_cmd_valid       (arb2spt_cmd_valid)            //|< w
  ,.arb2spt_cmd_ready       (arb2spt_cmd_ready)            //|> w
  ,.arb2spt_cmd_pd          (arb2spt_cmd_pd[76:0])         //|< w
  ,.arb2spt_dat_valid       (arb2spt_dat_valid)            //|< w
  ,.arb2spt_dat_ready       (arb2spt_dat_ready)            //|> w
  ,.arb2spt_dat_pd          (arb2spt_dat_pd[513:0])        //|< w
  ,.spt2cvt_cmd_valid       (spt2cvt_cmd_valid)            //|> w
  ,.spt2cvt_cmd_ready       (spt2cvt_cmd_ready)            //|< w
  ,.spt2cvt_cmd_pd          (spt2cvt_cmd_pd[76:0])         //|> w
  ,.spt2cvt_dat_valid       (spt2cvt_dat_valid)            //|> w
  ,.spt2cvt_dat_ready       (spt2cvt_dat_ready)            //|< w
  ,.spt2cvt_dat_pd          (spt2cvt_dat_pd[513:0])        //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|< i
  );
NV_NVDLA_CVIF_WRITE_IG_cvt u_cvt (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.spt2cvt_cmd_valid       (spt2cvt_cmd_valid)            //|< w
  ,.spt2cvt_cmd_ready       (spt2cvt_cmd_ready)            //|> w
  ,.spt2cvt_cmd_pd          (spt2cvt_cmd_pd[76:0])         //|< w
  ,.spt2cvt_dat_valid       (spt2cvt_dat_valid)            //|< w
  ,.spt2cvt_dat_ready       (spt2cvt_dat_ready)            //|> w
  ,.spt2cvt_dat_pd          (spt2cvt_dat_pd[513:0])        //|< w
  ,.cq_wr_pvld              (cq_wr_pvld)                   //|> o
  ,.cq_wr_prdy              (cq_wr_prdy)                   //|< i
  ,.cq_wr_thread_id         (cq_wr_thread_id[2:0])         //|> o
  ,.cq_wr_pd                (cq_wr_pd[2:0])                //|> o
  ,.cvif2noc_axi_aw_awvalid (cvif2noc_axi_aw_awvalid)      //|> o
  ,.cvif2noc_axi_aw_awready (cvif2noc_axi_aw_awready)      //|< i
  ,.cvif2noc_axi_aw_awid    (cvif2noc_axi_aw_awid[7:0])    //|> o
  ,.cvif2noc_axi_aw_awlen   (cvif2noc_axi_aw_awlen[3:0])   //|> o
  ,.cvif2noc_axi_aw_awaddr  (cvif2noc_axi_aw_awaddr[63:0]) //|> o
  ,.cvif2noc_axi_w_wvalid   (cvif2noc_axi_w_wvalid)        //|> o
  ,.cvif2noc_axi_w_wready   (cvif2noc_axi_w_wready)        //|< i
  ,.cvif2noc_axi_w_wdata    (cvif2noc_axi_w_wdata[511:0])  //|> o
  ,.cvif2noc_axi_w_wstrb    (cvif2noc_axi_w_wstrb[63:0])   //|> o
  ,.cvif2noc_axi_w_wlast    (cvif2noc_axi_w_wlast)         //|> o
  ,.eg2ig_axi_len           (eg2ig_axi_len[1:0])           //|< i
  ,.eg2ig_axi_vld           (eg2ig_axi_vld)                //|< i
  ,.reg2dp_wr_os_cnt        (reg2dp_wr_os_cnt[7:0])        //|< i
  );

endmodule // NV_NVDLA_CVIF_WRITE_ig

