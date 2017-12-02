// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CVIF_write.v

module NV_NVDLA_CVIF_write (
   bdma2cvif_wr_req_pd       //|< i
  ,bdma2cvif_wr_req_valid    //|< i
  ,cdp2cvif_wr_req_pd        //|< i
  ,cdp2cvif_wr_req_valid     //|< i
  ,cvif2noc_axi_aw_awready   //|< i
  ,cvif2noc_axi_w_wready     //|< i
  ,noc2cvif_axi_b_bid        //|< i
  ,noc2cvif_axi_b_bvalid     //|< i
  ,nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  ,pdp2cvif_wr_req_pd        //|< i
  ,pdp2cvif_wr_req_valid     //|< i
  ,pwrbus_ram_pd             //|< i
  ,rbk2cvif_wr_req_pd        //|< i
  ,rbk2cvif_wr_req_valid     //|< i
  ,reg2dp_wr_os_cnt          //|< i
  ,reg2dp_wr_weight_bdma     //|< i
  ,reg2dp_wr_weight_cdp      //|< i
  ,reg2dp_wr_weight_pdp      //|< i
  ,reg2dp_wr_weight_rbk      //|< i
  ,reg2dp_wr_weight_sdp      //|< i
  ,sdp2cvif_wr_req_pd        //|< i
  ,sdp2cvif_wr_req_valid     //|< i
  ,bdma2cvif_wr_req_ready    //|> o
  ,cdp2cvif_wr_req_ready     //|> o
  ,cvif2bdma_wr_rsp_complete //|> o
  ,cvif2cdp_wr_rsp_complete  //|> o
  ,cvif2noc_axi_aw_awaddr    //|> o
  ,cvif2noc_axi_aw_awid      //|> o
  ,cvif2noc_axi_aw_awlen     //|> o
  ,cvif2noc_axi_aw_awvalid   //|> o
  ,cvif2noc_axi_w_wdata      //|> o
  ,cvif2noc_axi_w_wlast      //|> o
  ,cvif2noc_axi_w_wstrb      //|> o
  ,cvif2noc_axi_w_wvalid     //|> o
  ,cvif2pdp_wr_rsp_complete  //|> o
  ,cvif2rbk_wr_rsp_complete  //|> o
  ,cvif2sdp_wr_rsp_complete  //|> o
  ,noc2cvif_axi_b_bready     //|> o
  ,pdp2cvif_wr_req_ready     //|> o
  ,rbk2cvif_wr_req_ready     //|> o
  ,sdp2cvif_wr_req_ready     //|> o
  );

//
// NV_NVDLA_CVIF_write_ports.v
//
input  nvdla_core_clk;   /* bdma2cvif_wr_req, cdp2cvif_wr_req, cvif2bdma_wr_rsp, cvif2cdp_wr_rsp, cvif2noc_axi_aw, cvif2noc_axi_w, cvif2pdp_wr_rsp, cvif2rbk_wr_rsp, cvif2sdp_wr_rsp, noc2cvif_axi_b, pdp2cvif_wr_req, rbk2cvif_wr_req, sdp2cvif_wr_req */
input  nvdla_core_rstn;  /* bdma2cvif_wr_req, cdp2cvif_wr_req, cvif2bdma_wr_rsp, cvif2cdp_wr_rsp, cvif2noc_axi_aw, cvif2noc_axi_w, cvif2pdp_wr_rsp, cvif2rbk_wr_rsp, cvif2sdp_wr_rsp, noc2cvif_axi_b, pdp2cvif_wr_req, rbk2cvif_wr_req, sdp2cvif_wr_req */

input          bdma2cvif_wr_req_valid;  /* data valid */
output         bdma2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] bdma2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input          cdp2cvif_wr_req_valid;  /* data valid */
output         cdp2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] cdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

output  cvif2bdma_wr_rsp_complete;

output  cvif2cdp_wr_rsp_complete;

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

output  cvif2pdp_wr_rsp_complete;

output  cvif2rbk_wr_rsp_complete;

output  cvif2sdp_wr_rsp_complete;

input        noc2cvif_axi_b_bvalid;  /* data valid */
output       noc2cvif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2cvif_axi_b_bid;

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

input [7:0] reg2dp_wr_os_cnt;
input [7:0] reg2dp_wr_weight_bdma;
input [7:0] reg2dp_wr_weight_cdp;
input [7:0] reg2dp_wr_weight_pdp;
input [7:0] reg2dp_wr_weight_rbk;
input [7:0] reg2dp_wr_weight_sdp;
wire  [2:0] cq_rd0_pd;
wire        cq_rd0_prdy;
wire        cq_rd0_pvld;
wire  [2:0] cq_rd1_pd;
wire        cq_rd1_prdy;
wire        cq_rd1_pvld;
wire  [2:0] cq_rd2_pd;
wire        cq_rd2_prdy;
wire        cq_rd2_pvld;
wire  [2:0] cq_rd3_pd;
wire        cq_rd3_prdy;
wire        cq_rd3_pvld;
wire  [2:0] cq_rd4_pd;
wire        cq_rd4_prdy;
wire        cq_rd4_pvld;
wire  [2:0] cq_wr_pd;
wire        cq_wr_prdy;
wire        cq_wr_pvld;
wire  [2:0] cq_wr_thread_id;
wire  [1:0] eg2ig_axi_len;
wire        eg2ig_axi_vld;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
NV_NVDLA_CVIF_WRITE_ig u_ig (
   .nvdla_core_clk            (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)              //|< i
  ,.bdma2cvif_wr_req_valid    (bdma2cvif_wr_req_valid)       //|< i
  ,.bdma2cvif_wr_req_ready    (bdma2cvif_wr_req_ready)       //|> o
  ,.bdma2cvif_wr_req_pd       (bdma2cvif_wr_req_pd[514:0])   //|< i
  ,.cdp2cvif_wr_req_valid     (cdp2cvif_wr_req_valid)        //|< i
  ,.cdp2cvif_wr_req_ready     (cdp2cvif_wr_req_ready)        //|> o
  ,.cdp2cvif_wr_req_pd        (cdp2cvif_wr_req_pd[514:0])    //|< i
  ,.cq_wr_pvld                (cq_wr_pvld)                   //|> w
  ,.cq_wr_prdy                (cq_wr_prdy)                   //|< w
  ,.cq_wr_thread_id           (cq_wr_thread_id[2:0])         //|> w
  ,.cq_wr_pd                  (cq_wr_pd[2:0])                //|> w
  ,.cvif2noc_axi_aw_awvalid   (cvif2noc_axi_aw_awvalid)      //|> o
  ,.cvif2noc_axi_aw_awready   (cvif2noc_axi_aw_awready)      //|< i
  ,.cvif2noc_axi_aw_awid      (cvif2noc_axi_aw_awid[7:0])    //|> o
  ,.cvif2noc_axi_aw_awlen     (cvif2noc_axi_aw_awlen[3:0])   //|> o
  ,.cvif2noc_axi_aw_awaddr    (cvif2noc_axi_aw_awaddr[63:0]) //|> o
  ,.cvif2noc_axi_w_wvalid     (cvif2noc_axi_w_wvalid)        //|> o
  ,.cvif2noc_axi_w_wready     (cvif2noc_axi_w_wready)        //|< i
  ,.cvif2noc_axi_w_wdata      (cvif2noc_axi_w_wdata[511:0])  //|> o
  ,.cvif2noc_axi_w_wstrb      (cvif2noc_axi_w_wstrb[63:0])   //|> o
  ,.cvif2noc_axi_w_wlast      (cvif2noc_axi_w_wlast)         //|> o
  ,.pdp2cvif_wr_req_valid     (pdp2cvif_wr_req_valid)        //|< i
  ,.pdp2cvif_wr_req_ready     (pdp2cvif_wr_req_ready)        //|> o
  ,.pdp2cvif_wr_req_pd        (pdp2cvif_wr_req_pd[514:0])    //|< i
  ,.pwrbus_ram_pd             (pwrbus_ram_pd[31:0])          //|< i
  ,.rbk2cvif_wr_req_valid     (rbk2cvif_wr_req_valid)        //|< i
  ,.rbk2cvif_wr_req_ready     (rbk2cvif_wr_req_ready)        //|> o
  ,.rbk2cvif_wr_req_pd        (rbk2cvif_wr_req_pd[514:0])    //|< i
  ,.sdp2cvif_wr_req_valid     (sdp2cvif_wr_req_valid)        //|< i
  ,.sdp2cvif_wr_req_ready     (sdp2cvif_wr_req_ready)        //|> o
  ,.sdp2cvif_wr_req_pd        (sdp2cvif_wr_req_pd[514:0])    //|< i
  ,.reg2dp_wr_os_cnt          (reg2dp_wr_os_cnt[7:0])        //|< i
  ,.reg2dp_wr_weight_bdma     (reg2dp_wr_weight_bdma[7:0])   //|< i
  ,.reg2dp_wr_weight_cdp      (reg2dp_wr_weight_cdp[7:0])    //|< i
  ,.reg2dp_wr_weight_pdp      (reg2dp_wr_weight_pdp[7:0])    //|< i
  ,.reg2dp_wr_weight_rbk      (reg2dp_wr_weight_rbk[7:0])    //|< i
  ,.reg2dp_wr_weight_sdp      (reg2dp_wr_weight_sdp[7:0])    //|< i
  ,.eg2ig_axi_len             (eg2ig_axi_len[1:0])           //|< w
  ,.eg2ig_axi_vld             (eg2ig_axi_vld)                //|< w
  );

NV_NVDLA_CVIF_WRITE_eg u_eg (
   .nvdla_core_clk            (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)              //|< i
  ,.cvif2sdp_wr_rsp_complete  (cvif2sdp_wr_rsp_complete)     //|> o
  ,.cvif2cdp_wr_rsp_complete  (cvif2cdp_wr_rsp_complete)     //|> o
  ,.cvif2pdp_wr_rsp_complete  (cvif2pdp_wr_rsp_complete)     //|> o
  ,.cvif2bdma_wr_rsp_complete (cvif2bdma_wr_rsp_complete)    //|> o
  ,.cvif2rbk_wr_rsp_complete  (cvif2rbk_wr_rsp_complete)     //|> o
  ,.cq_rd0_pvld               (cq_rd0_pvld)                  //|< w
  ,.cq_rd0_prdy               (cq_rd0_prdy)                  //|> w
  ,.cq_rd0_pd                 (cq_rd0_pd[2:0])               //|< w
  ,.cq_rd1_pvld               (cq_rd1_pvld)                  //|< w
  ,.cq_rd1_prdy               (cq_rd1_prdy)                  //|> w
  ,.cq_rd1_pd                 (cq_rd1_pd[2:0])               //|< w
  ,.cq_rd2_pvld               (cq_rd2_pvld)                  //|< w
  ,.cq_rd2_prdy               (cq_rd2_prdy)                  //|> w
  ,.cq_rd2_pd                 (cq_rd2_pd[2:0])               //|< w
  ,.cq_rd3_pvld               (cq_rd3_pvld)                  //|< w
  ,.cq_rd3_prdy               (cq_rd3_prdy)                  //|> w
  ,.cq_rd3_pd                 (cq_rd3_pd[2:0])               //|< w
  ,.cq_rd4_pvld               (cq_rd4_pvld)                  //|< w
  ,.cq_rd4_prdy               (cq_rd4_prdy)                  //|> w
  ,.cq_rd4_pd                 (cq_rd4_pd[2:0])               //|< w
  ,.noc2cvif_axi_b_bvalid     (noc2cvif_axi_b_bvalid)        //|< i
  ,.noc2cvif_axi_b_bready     (noc2cvif_axi_b_bready)        //|> o
  ,.noc2cvif_axi_b_bid        (noc2cvif_axi_b_bid[7:0])      //|< i
  ,.eg2ig_axi_len             (eg2ig_axi_len[1:0])           //|> w
  ,.eg2ig_axi_vld             (eg2ig_axi_vld)                //|> w
  );

NV_NVDLA_CVIF_WRITE_cq u_cq (
   .nvdla_core_clk            (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)              //|< i
  ,.cq_wr_prdy                (cq_wr_prdy)                   //|> w
  ,.cq_wr_pvld                (cq_wr_pvld)                   //|< w
  ,.cq_wr_thread_id           (cq_wr_thread_id[2:0])         //|< w
  ,.cq_wr_pd                  (cq_wr_pd[2:0])                //|< w
  ,.cq_rd0_prdy               (cq_rd0_prdy)                  //|< w
  ,.cq_rd0_pvld               (cq_rd0_pvld)                  //|> w
  ,.cq_rd0_pd                 (cq_rd0_pd[2:0])               //|> w
  ,.cq_rd1_prdy               (cq_rd1_prdy)                  //|< w
  ,.cq_rd1_pvld               (cq_rd1_pvld)                  //|> w
  ,.cq_rd1_pd                 (cq_rd1_pd[2:0])               //|> w
  ,.cq_rd2_prdy               (cq_rd2_prdy)                  //|< w
  ,.cq_rd2_pvld               (cq_rd2_pvld)                  //|> w
  ,.cq_rd2_pd                 (cq_rd2_pd[2:0])               //|> w
  ,.cq_rd3_prdy               (cq_rd3_prdy)                  //|< w
  ,.cq_rd3_pvld               (cq_rd3_pvld)                  //|> w
  ,.cq_rd3_pd                 (cq_rd3_pd[2:0])               //|> w
  ,.cq_rd4_prdy               (cq_rd4_prdy)                  //|< w
  ,.cq_rd4_pvld               (cq_rd4_pvld)                  //|> w
  ,.cq_rd4_pd                 (cq_rd4_pd[2:0])               //|> w
  ,.pwrbus_ram_pd             (pwrbus_ram_pd[31:0])          //|< i
  );

endmodule // NV_NVDLA_CVIF_write

