// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_csb_master.v

`include "simulate_x_tick.vh"
module NV_NVDLA_csb_master (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,nvdla_falcon_clk        //|< i
  ,nvdla_falcon_rstn       //|< i
  ,pwrbus_ram_pd           //|< i
  ,csb2nvdla_valid         //|< i
  ,csb2nvdla_ready         //|> o
  ,csb2nvdla_addr          //|< i
  ,csb2nvdla_wdat          //|< i
  ,csb2nvdla_write         //|< i
  ,csb2nvdla_nposted       //|< i
  ,nvdla2csb_valid         //|> o
  ,nvdla2csb_data          //|> o
  ,nvdla2csb_wr_complete   //|> o
  ,csb2glb_req_pvld        //|> o
  ,csb2glb_req_prdy        //|< i
  ,csb2glb_req_pd          //|> o
  ,glb2csb_resp_valid      //|< i
  ,glb2csb_resp_pd         //|< i
  ,csb2gec_req_pvld        //|> o
  ,csb2gec_req_prdy        //|< i
  ,csb2gec_req_pd          //|> o
  ,gec2csb_resp_valid      //|< i
  ,gec2csb_resp_pd         //|< i
  ,csb2mcif_req_pvld       //|> o
  ,csb2mcif_req_prdy       //|< i
  ,csb2mcif_req_pd         //|> o
  ,mcif2csb_resp_valid     //|< i
  ,mcif2csb_resp_pd        //|< i
  ,csb2cvif_req_pvld       //|> o
  ,csb2cvif_req_prdy       //|< i
  ,csb2cvif_req_pd         //|> o
  ,cvif2csb_resp_valid     //|< i
  ,cvif2csb_resp_pd        //|< i
  ,csb2bdma_req_pvld       //|> o
  ,csb2bdma_req_prdy       //|< i
  ,csb2bdma_req_pd         //|> o
  ,bdma2csb_resp_valid     //|< i
  ,bdma2csb_resp_pd        //|< i
  ,csb2cdma_req_pvld       //|> o
  ,csb2cdma_req_prdy       //|< i
  ,csb2cdma_req_pd         //|> o
  ,cdma2csb_resp_valid     //|< i
  ,cdma2csb_resp_pd        //|< i
  ,csb2csc_req_pvld        //|> o
  ,csb2csc_req_prdy        //|< i
  ,csb2csc_req_pd          //|> o
  ,csc2csb_resp_valid      //|< i
  ,csc2csb_resp_pd         //|< i
  ,csb2cmac_a_req_pvld     //|> o
  ,csb2cmac_a_req_prdy     //|< i
  ,csb2cmac_a_req_pd       //|> o
  ,cmac_a2csb_resp_valid   //|< i
  ,cmac_a2csb_resp_pd      //|< i
  ,csb2cmac_b_req_pvld     //|> o
  ,csb2cmac_b_req_prdy     //|< i
  ,csb2cmac_b_req_pd       //|> o
  ,cmac_b2csb_resp_valid   //|< i
  ,cmac_b2csb_resp_pd      //|< i
  ,csb2cacc_req_pvld       //|> o
  ,csb2cacc_req_prdy       //|< i
  ,csb2cacc_req_pd         //|> o
  ,cacc2csb_resp_valid     //|< i
  ,cacc2csb_resp_pd        //|< i
  ,csb2sdp_rdma_req_pvld   //|> o
  ,csb2sdp_rdma_req_prdy   //|< i
  ,csb2sdp_rdma_req_pd     //|> o
  ,sdp_rdma2csb_resp_valid //|< i
  ,sdp_rdma2csb_resp_pd    //|< i
  ,csb2sdp_req_pvld        //|> o
  ,csb2sdp_req_prdy        //|< i
  ,csb2sdp_req_pd          //|> o
  ,sdp2csb_resp_valid      //|< i
  ,sdp2csb_resp_pd         //|< i
  ,csb2pdp_rdma_req_pvld   //|> o
  ,csb2pdp_rdma_req_prdy   //|< i
  ,csb2pdp_rdma_req_pd     //|> o
  ,pdp_rdma2csb_resp_valid //|< i
  ,pdp_rdma2csb_resp_pd    //|< i
  ,csb2pdp_req_pvld        //|> o
  ,csb2pdp_req_prdy        //|< i
  ,csb2pdp_req_pd          //|> o
  ,pdp2csb_resp_valid      //|< i
  ,pdp2csb_resp_pd         //|< i
  ,csb2cdp_rdma_req_pvld   //|> o
  ,csb2cdp_rdma_req_prdy   //|< i
  ,csb2cdp_rdma_req_pd     //|> o
  ,cdp_rdma2csb_resp_valid //|< i
  ,cdp_rdma2csb_resp_pd    //|< i
  ,csb2cdp_req_pvld        //|> o
  ,csb2cdp_req_prdy        //|< i
  ,csb2cdp_req_pd          //|> o
  ,cdp2csb_resp_valid      //|< i
  ,cdp2csb_resp_pd         //|< i
  ,csb2rbk_req_pvld        //|> o
  ,csb2rbk_req_prdy        //|< i
  ,csb2rbk_req_pd          //|> o
  ,rbk2csb_resp_valid      //|< i
  ,rbk2csb_resp_pd         //|< i
  );


//
// NV_NVDLA_csb_master_ports.v
//
input  nvdla_core_clk;     /* csb2glb_req, glb2csb_resp, csb2gec_req, gec2csb_resp, csb2mcif_req, mcif2csb_resp, csb2cvif_req, cvif2csb_resp, csb2bdma_req, bdma2csb_resp, csb2cdma_req, cdma2csb_resp, csb2csc_req, csc2csb_resp, csb2cmac_a_req, cmac_a2csb_resp, csb2cmac_b_req, cmac_b2csb_resp, csb2cacc_req, cacc2csb_resp, csb2sdp_rdma_req, sdp_rdma2csb_resp, csb2sdp_req, sdp2csb_resp, csb2pdp_rdma_req, pdp_rdma2csb_resp, csb2pdp_req, pdp2csb_resp, csb2cdp_rdma_req, cdp_rdma2csb_resp, csb2cdp_req, cdp2csb_resp, csb2rbk_req, rbk2csb_resp */
input  nvdla_core_rstn;    /* csb2glb_req, glb2csb_resp, csb2gec_req, gec2csb_resp, csb2mcif_req, mcif2csb_resp, csb2cvif_req, cvif2csb_resp, csb2bdma_req, bdma2csb_resp, csb2cdma_req, cdma2csb_resp, csb2csc_req, csc2csb_resp, csb2cmac_a_req, cmac_a2csb_resp, csb2cmac_b_req, cmac_b2csb_resp, csb2cacc_req, cacc2csb_resp, csb2sdp_rdma_req, sdp_rdma2csb_resp, csb2sdp_req, sdp2csb_resp, csb2pdp_rdma_req, pdp_rdma2csb_resp, csb2pdp_req, pdp2csb_resp, csb2cdp_rdma_req, cdp_rdma2csb_resp, csb2cdp_req, cdp2csb_resp, csb2rbk_req, rbk2csb_resp */
input  nvdla_falcon_clk;   /* csb2nvdla, nvdla2csb, nvdla2csb_wr */
input  nvdla_falcon_rstn;  /* csb2nvdla, nvdla2csb, nvdla2csb_wr */

input [31:0] pwrbus_ram_pd;

input         csb2nvdla_valid;    /* data valid */
output        csb2nvdla_ready;    /* data return handshake */
input  [15:0] csb2nvdla_addr;
input  [31:0] csb2nvdla_wdat;
input         csb2nvdla_write;
input         csb2nvdla_nposted;

output        nvdla2csb_valid;  /* data valid */
output [31:0] nvdla2csb_data;

output  nvdla2csb_wr_complete;

output        csb2glb_req_pvld;  /* data valid */
input         csb2glb_req_prdy;  /* data return handshake */
output [62:0] csb2glb_req_pd;

input        glb2csb_resp_valid;  /* data valid */
input [33:0] glb2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2gec_req_pvld;  /* data valid */
input         csb2gec_req_prdy;  /* data return handshake */
output [62:0] csb2gec_req_pd;

input        gec2csb_resp_valid;  /* data valid */
input [33:0] gec2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2mcif_req_pvld;  /* data valid */
input         csb2mcif_req_prdy;  /* data return handshake */
output [62:0] csb2mcif_req_pd;

input        mcif2csb_resp_valid;  /* data valid */
input [33:0] mcif2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2cvif_req_pvld;  /* data valid */
input         csb2cvif_req_prdy;  /* data return handshake */
output [62:0] csb2cvif_req_pd;

input        cvif2csb_resp_valid;  /* data valid */
input [33:0] cvif2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2bdma_req_pvld;  /* data valid */
input         csb2bdma_req_prdy;  /* data return handshake */
output [62:0] csb2bdma_req_pd;

input        bdma2csb_resp_valid;  /* data valid */
input [33:0] bdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2cdma_req_pvld;  /* data valid */
input         csb2cdma_req_prdy;  /* data return handshake */
output [62:0] csb2cdma_req_pd;

input        cdma2csb_resp_valid;  /* data valid */
input [33:0] cdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2csc_req_pvld;  /* data valid */
input         csb2csc_req_prdy;  /* data return handshake */
output [62:0] csb2csc_req_pd;

input        csc2csb_resp_valid;  /* data valid */
input [33:0] csc2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2cmac_a_req_pvld;  /* data valid */
input         csb2cmac_a_req_prdy;  /* data return handshake */
output [62:0] csb2cmac_a_req_pd;

input        cmac_a2csb_resp_valid;  /* data valid */
input [33:0] cmac_a2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2cmac_b_req_pvld;  /* data valid */
input         csb2cmac_b_req_prdy;  /* data return handshake */
output [62:0] csb2cmac_b_req_pd;

input        cmac_b2csb_resp_valid;  /* data valid */
input [33:0] cmac_b2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2cacc_req_pvld;  /* data valid */
input         csb2cacc_req_prdy;  /* data return handshake */
output [62:0] csb2cacc_req_pd;

input        cacc2csb_resp_valid;  /* data valid */
input [33:0] cacc2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2sdp_rdma_req_pvld;  /* data valid */
input         csb2sdp_rdma_req_prdy;  /* data return handshake */
output [62:0] csb2sdp_rdma_req_pd;

input        sdp_rdma2csb_resp_valid;  /* data valid */
input [33:0] sdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2sdp_req_pvld;  /* data valid */
input         csb2sdp_req_prdy;  /* data return handshake */
output [62:0] csb2sdp_req_pd;

input        sdp2csb_resp_valid;  /* data valid */
input [33:0] sdp2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2pdp_rdma_req_pvld;  /* data valid */
input         csb2pdp_rdma_req_prdy;  /* data return handshake */
output [62:0] csb2pdp_rdma_req_pd;

input        pdp_rdma2csb_resp_valid;  /* data valid */
input [33:0] pdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2pdp_req_pvld;  /* data valid */
input         csb2pdp_req_prdy;  /* data return handshake */
output [62:0] csb2pdp_req_pd;

input        pdp2csb_resp_valid;  /* data valid */
input [33:0] pdp2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2cdp_rdma_req_pvld;  /* data valid */
input         csb2cdp_rdma_req_prdy;  /* data return handshake */
output [62:0] csb2cdp_rdma_req_pd;

input        cdp_rdma2csb_resp_valid;  /* data valid */
input [33:0] cdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2cdp_req_pvld;  /* data valid */
input         csb2cdp_req_prdy;  /* data return handshake */
output [62:0] csb2cdp_req_pd;

input        cdp2csb_resp_valid;  /* data valid */
input [33:0] cdp2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2rbk_req_pvld;  /* data valid */
input         csb2rbk_req_prdy;  /* data return handshake */
output [62:0] csb2rbk_req_pd;

input        rbk2csb_resp_valid;  /* data valid */
input [33:0] rbk2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

wire   [17:0] addr_mask;
wire   [33:0] afbif_resp_pd;
wire          afbif_resp_pvld;
wire   [17:0] core_byte_addr;
wire   [15:0] core_req_addr;
wire          core_req_nposted;
wire   [49:0] core_req_pd;
wire          core_req_prdy;
wire          core_req_pvld;
wire          core_req_write;
wire   [33:0] core_resp_pd;
wire          core_resp_prdy;
wire          core_resp_pvld;
wire   [49:0] csb2nvdla_pd;
wire          dummy_resp_error;
wire   [33:0] dummy_resp_pd;
wire   [31:0] dummy_resp_rdat;
wire          dummy_resp_type_w;
wire          dummy_resp_valid_w;
wire   [33:0] dummy_rresp_pd;
wire   [33:0] dummy_wresp_pd;
wire   [33:0] nvdla2csb_resp_pd;
wire          nvdla2csb_resp_pvld;
wire          nvdla2csb_rresp_is_valid;
wire   [31:0] nvdla2csb_rresp_rdat;
wire          nvdla2csb_wresp_is_valid;
wire          select_afbif;
reg           bdma_req_pvld;
reg           bdma_req_pvld_w;
reg    [33:0] bdma_resp_pd;
reg           bdma_resp_valid;
reg           cacc_req_pvld;
reg           cacc_req_pvld_w;
reg    [33:0] cacc_resp_pd;
reg           cacc_resp_valid;
reg           cdma_req_pvld;
reg           cdma_req_pvld_w;
reg    [33:0] cdma_resp_pd;
reg           cdma_resp_valid;
reg           cdp_rdma_req_pvld;
reg           cdp_rdma_req_pvld_w;
reg    [33:0] cdp_rdma_resp_pd;
reg           cdp_rdma_resp_valid;
reg           cdp_req_pvld;
reg           cdp_req_pvld_w;
reg    [33:0] cdp_resp_pd;
reg           cdp_resp_valid;
reg           cmac_a_req_pvld;
reg           cmac_a_req_pvld_w;
reg    [33:0] cmac_a_resp_pd;
reg           cmac_a_resp_valid;
reg           cmac_b_req_pvld;
reg           cmac_b_req_pvld_w;
reg    [33:0] cmac_b_resp_pd;
reg           cmac_b_resp_valid;
reg    [49:0] core_req_pd_d1;
reg           core_req_pop_valid;
reg           csb2bdma_req_en;
reg    [49:0] csb2bdma_req_pd_tmp;
reg           csb2bdma_req_pvld;
reg           csb2bdma_req_pvld_w;
reg           csb2cacc_req_en;
reg    [49:0] csb2cacc_req_pd_tmp;
reg           csb2cacc_req_pvld;
reg           csb2cacc_req_pvld_w;
reg           csb2cdma_req_en;
reg    [49:0] csb2cdma_req_pd_tmp;
reg           csb2cdma_req_pvld;
reg           csb2cdma_req_pvld_w;
reg           csb2cdp_rdma_req_en;
reg    [49:0] csb2cdp_rdma_req_pd_tmp;
reg           csb2cdp_rdma_req_pvld;
reg           csb2cdp_rdma_req_pvld_w;
reg           csb2cdp_req_en;
reg    [49:0] csb2cdp_req_pd_tmp;
reg           csb2cdp_req_pvld;
reg           csb2cdp_req_pvld_w;
reg           csb2cmac_a_req_en;
reg    [49:0] csb2cmac_a_req_pd_tmp;
reg           csb2cmac_a_req_pvld;
reg           csb2cmac_a_req_pvld_w;
reg           csb2cmac_b_req_en;
reg    [49:0] csb2cmac_b_req_pd_tmp;
reg           csb2cmac_b_req_pvld;
reg           csb2cmac_b_req_pvld_w;
reg           csb2csc_req_en;
reg    [49:0] csb2csc_req_pd_tmp;
reg           csb2csc_req_pvld;
reg           csb2csc_req_pvld_w;
reg           csb2cvif_req_en;
reg    [49:0] csb2cvif_req_pd_tmp;
reg           csb2cvif_req_pvld;
reg           csb2cvif_req_pvld_w;
reg           csb2dummy_req_nposted;
reg           csb2dummy_req_pvld;
reg           csb2dummy_req_read;
reg           csb2gec_req_en;
reg    [49:0] csb2gec_req_pd_tmp;
reg           csb2gec_req_pvld;
reg           csb2gec_req_pvld_w;
reg           csb2glb_req_en;
reg    [49:0] csb2glb_req_pd_tmp;
reg           csb2glb_req_pvld;
reg           csb2glb_req_pvld_w;
reg           csb2mcif_req_en;
reg    [49:0] csb2mcif_req_pd_tmp;
reg           csb2mcif_req_pvld;
reg           csb2mcif_req_pvld_w;
reg           csb2pdp_rdma_req_en;
reg    [49:0] csb2pdp_rdma_req_pd_tmp;
reg           csb2pdp_rdma_req_pvld;
reg           csb2pdp_rdma_req_pvld_w;
reg           csb2pdp_req_en;
reg    [49:0] csb2pdp_req_pd_tmp;
reg           csb2pdp_req_pvld;
reg           csb2pdp_req_pvld_w;
reg           csb2rbk_req_en;
reg    [49:0] csb2rbk_req_pd_tmp;
reg           csb2rbk_req_pvld;
reg           csb2rbk_req_pvld_w;
reg           csb2sdp_rdma_req_en;
reg    [49:0] csb2sdp_rdma_req_pd_tmp;
reg           csb2sdp_rdma_req_pvld;
reg           csb2sdp_rdma_req_pvld_w;
reg           csb2sdp_req_en;
reg    [49:0] csb2sdp_req_pd_tmp;
reg           csb2sdp_req_pvld;
reg           csb2sdp_req_pvld_w;
reg           csc_req_pvld;
reg           csc_req_pvld_w;
reg    [33:0] csc_resp_pd;
reg           csc_resp_valid;
reg           cvif_req_pvld;
reg           cvif_req_pvld_w;
reg    [33:0] cvif_resp_pd;
reg           cvif_resp_valid;
reg           dummy_req_pvld_w;
reg           dummy_resp_type;
reg           dummy_resp_valid;
reg           gec_req_pvld;
reg           gec_req_pvld_w;
reg    [33:0] gec_resp_pd;
reg           gec_resp_valid;
reg           glb_req_pvld;
reg           glb_req_pvld_w;
reg    [33:0] glb_resp_pd;
reg           glb_resp_valid;
reg           mcif_req_pvld;
reg           mcif_req_pvld_w;
reg    [33:0] mcif_resp_pd;
reg           mcif_resp_valid;
reg    [31:0] nvdla2csb_data;
reg           nvdla2csb_valid;
reg           nvdla2csb_wr_complete;
reg           pdp_rdma_req_pvld;
reg           pdp_rdma_req_pvld_w;
reg    [33:0] pdp_rdma_resp_pd;
reg           pdp_rdma_resp_valid;
reg           pdp_req_pvld;
reg           pdp_req_pvld_w;
reg    [33:0] pdp_resp_pd;
reg           pdp_resp_valid;
reg           rbk_req_pvld;
reg           rbk_req_pvld_w;
reg    [33:0] rbk_resp_pd;
reg           rbk_resp_valid;
reg           sdp_rdma_req_pvld;
reg           sdp_rdma_req_pvld_w;
reg    [33:0] sdp_rdma_resp_pd;
reg           sdp_rdma_resp_valid;
reg           sdp_req_pvld;
reg           sdp_req_pvld_w;
reg    [33:0] sdp_resp_pd;
reg           sdp_resp_valid;
reg           select_bdma;
reg           select_cacc;
reg           select_cdma;
reg           select_cdp;
reg           select_cdp_rdma;
reg           select_cmac_a;
reg           select_cmac_b;
reg           select_csc;
reg           select_cvif;
reg           select_dummy;
reg           select_gec;
reg           select_glb;
reg           select_mcif;
reg           select_pdp;
reg           select_pdp_rdma;
reg           select_rbk;
reg           select_sdp;
reg           select_sdp_rdma;

////////////////////////////////////////////////////////////////////////
// Falcon interface to async FIFO                                     //
////////////////////////////////////////////////////////////////////////
assign  csb2nvdla_pd[49:0] = {csb2nvdla_nposted,csb2nvdla_write,csb2nvdla_wdat,csb2nvdla_addr};

NV_NVDLA_CSB_MASTER_falcon2csb_fifo u_fifo_csb2nvdla (
   .wr_clk        (nvdla_falcon_clk)        //|< i
  ,.wr_reset_     (nvdla_falcon_rstn)       //|< i
  ,.wr_ready      (csb2nvdla_ready)         //|> o
  ,.wr_req        (csb2nvdla_valid)         //|< i
  ,.wr_data       (csb2nvdla_pd[49:0])      //|< w
  ,.rd_clk        (nvdla_core_clk)          //|< i
  ,.rd_reset_     (nvdla_core_rstn)         //|< i
  ,.rd_ready      (core_req_prdy)           //|< w
  ,.rd_req        (core_req_pvld)           //|> w
  ,.rd_data       (core_req_pd[49:0])       //|> w
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])     //|< i
  );

assign  core_req_prdy = 1'b1;

NV_NVDLA_CSB_MASTER_csb2falcon_fifo u_fifo_nvdla2csb (
   .wr_clk        (nvdla_core_clk)          //|< i
  ,.wr_reset_     (nvdla_core_rstn)         //|< i
  ,.wr_ready      (core_resp_prdy)          //|> w *
  ,.wr_req        (core_resp_pvld)          //|< w
  ,.wr_data       (core_resp_pd[33:0])      //|< w
  ,.rd_clk        (nvdla_falcon_clk)        //|< i
  ,.rd_reset_     (nvdla_falcon_rstn)       //|< i
  ,.rd_ready      (1'b1)                    //|< ?
  ,.rd_req        (nvdla2csb_resp_pvld)     //|> w
  ,.rd_data       (nvdla2csb_resp_pd[33:0]) //|> w
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])     //|< i
  );

//PKT_UNPACK_WIRE_VLD (nvdla_xx2csb_resp, dla_xx2csb_rd_erpt, nvdla2csb_rresp_, nvdla2csb_resp_pd, nvdla2csb_resp_pvld)
//PKT_UNPACK_WIRE_VLD (nvdla_xx2csb_resp, dla_xx2csb_wr_erpt, nvdla2csb_wresp_, nvdla2csb_resp_pd, nvdla2csb_resp_pvld)
assign       nvdla2csb_rresp_rdat[31:0] =  nvdla2csb_resp_pd[31:0];
assign       nvdla2csb_rresp_is_valid = (nvdla2csb_resp_pvld  && (nvdla2csb_resp_pd[33:33] == 1'd0));
assign       nvdla2csb_wresp_is_valid = (nvdla2csb_resp_pvld  && (nvdla2csb_resp_pd[33:33] == 1'd1));

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
  nv_assert_never #(0,0,"Error! core response fifo block!")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, (core_resp_pvld & ~core_resp_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_falcon_clk or negedge nvdla_falcon_rstn) begin
  if (!nvdla_falcon_rstn) begin
    nvdla2csb_valid <= 1'b0;
  end else begin
    nvdla2csb_valid <= nvdla2csb_rresp_is_valid;
  end
end

always @(posedge nvdla_falcon_clk or negedge nvdla_falcon_rstn) begin
  if (!nvdla_falcon_rstn) begin
    nvdla2csb_data <= {32{1'b0}};
  end else begin
    if(nvdla2csb_rresp_is_valid)
    begin
        nvdla2csb_data <= nvdla2csb_rresp_rdat;
    end
  end
end

/*
&Always posedge nvdla_falcon_clk or negedge nvdla_falcon_rstn;
    if(nvdla2csb_rresp_is_valid)
    begin
        nvdla2csb_error <0= nvdla2csb_rresp_error;
    end
&End;
*/  
always @(posedge nvdla_falcon_clk or negedge nvdla_falcon_rstn) begin
  if (!nvdla_falcon_rstn) begin
    nvdla2csb_wr_complete <= 1'b0;
  end else begin
    nvdla2csb_wr_complete <= nvdla2csb_wresp_is_valid;
  end
end
/*
&Always posedge nvdla_falcon_clk or negedge nvdla_falcon_rstn;
    if(nvdla2csb_wresp_is_valid)
    begin
        nvdla2csb_wr_rdat <0= nvdla2csb_wresp_rdat;
    end
&End;

&Always posedge nvdla_falcon_clk or negedge nvdla_falcon_rstn;
    if(nvdla2csb_wresp_is_valid)
    begin
        nvdla2csb_wr_error <0= nvdla2csb_wresp_error;
    end
&End;
*/

////////////////////////////////////////////////////////////////////////
// Distribute request and gather response                             //
////////////////////////////////////////////////////////////////////////
//PKT_UNPACK_WIRE (csb2xx_request, core_req_, core_req_pd)
//&Forget dangle core_req_srcpriv;
//&Forget dangle core_req_wrbe;
//&Forget dangle core_req_level;
//&Forget dangle core_req_wdat;
assign        core_req_addr[15:0] = core_req_pd[15:0];
assign        core_req_write      = core_req_pd[48];
assign        core_req_nposted    = core_req_pd[49];
 
always @(
  core_req_pvld
  or core_req_prdy
  ) begin
    core_req_pop_valid = core_req_pvld & core_req_prdy;
end

//core_req_addr is word aligned while address from arnvdla is byte aligned.
assign core_byte_addr = {core_req_addr, 2'b0};

always @(posedge nvdla_core_clk) begin
  if ((core_req_pvld & core_req_prdy) == 1'b1) begin
    core_req_pd_d1 <= core_req_pd;
  // VCS coverage off
  end else if ((core_req_pvld & core_req_prdy) == 1'b0) begin
  end else begin
    core_req_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

assign addr_mask = {{16 -10{1'b1}},{12{1'b0}}};
//assign afbif_addr_mask = {{PKT_csb2xx_request_addr_WIDTH-11{1'b1}},{13{1'b0}}};

//&Always;
assign    select_afbif = 1'b0; //((core_byte_addr & afbif_addr_mask) == 0);
//&End;
/*
&Always;
    core2afbif_req_pvld_w = (core_req_pop_valid & select_afbif) ? 1'b1 :
                            (core2afbif_req_prdy) ? 1'b0 :
                            core2afbif_req_pvld;
&End;

::flop core2afbif_req_pvld <0= core2afbif_req_pvld_w;
assign core2afbif_req_pd = core_req_pd_d1;
*/

always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_cmac_a = ((core_byte_addr & addr_mask) == 32'h00007000);
end

always @(
  core_req_pop_valid
  or select_cmac_a
  or csb2cmac_a_req_prdy
  or csb2cmac_a_req_pvld
  or cmac_a_req_pvld
  ) begin
    cmac_a_req_pvld_w = (core_req_pop_valid & select_cmac_a) ? 1'b1 :
                           (csb2cmac_a_req_prdy | ~csb2cmac_a_req_pvld) ? 1'b0 :
                           cmac_a_req_pvld;
end

always @(
  cmac_a_req_pvld
  or csb2cmac_a_req_prdy
  or csb2cmac_a_req_pvld
  ) begin
    csb2cmac_a_req_pvld_w = cmac_a_req_pvld ? 1'b1 :
                               csb2cmac_a_req_prdy ? 1'b0 :
                               csb2cmac_a_req_pvld;
end

always @(
  cmac_a_req_pvld
  or csb2cmac_a_req_prdy
  or csb2cmac_a_req_pvld
  ) begin
    csb2cmac_a_req_en = cmac_a_req_pvld & (csb2cmac_a_req_prdy | ~csb2cmac_a_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmac_a_req_pvld <= 1'b0;
  end else begin
  cmac_a_req_pvld <= cmac_a_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2cmac_a_req_pvld <= 1'b0;
  end else begin
  csb2cmac_a_req_pvld <= csb2cmac_a_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2cmac_a_req_en) == 1'b1) begin
    csb2cmac_a_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2cmac_a_req_en) == 1'b0) begin
  end else begin
    csb2cmac_a_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2cmac_a_req_pd ={7'h0,csb2cmac_a_req_pd_tmp[49:16],6'h0,csb2cmac_a_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_sdp_rdma = ((core_byte_addr & addr_mask) == 32'h0000a000);
end

always @(
  core_req_pop_valid
  or select_sdp_rdma
  or csb2sdp_rdma_req_prdy
  or csb2sdp_rdma_req_pvld
  or sdp_rdma_req_pvld
  ) begin
    sdp_rdma_req_pvld_w = (core_req_pop_valid & select_sdp_rdma) ? 1'b1 :
                           (csb2sdp_rdma_req_prdy | ~csb2sdp_rdma_req_pvld) ? 1'b0 :
                           sdp_rdma_req_pvld;
end

always @(
  sdp_rdma_req_pvld
  or csb2sdp_rdma_req_prdy
  or csb2sdp_rdma_req_pvld
  ) begin
    csb2sdp_rdma_req_pvld_w = sdp_rdma_req_pvld ? 1'b1 :
                               csb2sdp_rdma_req_prdy ? 1'b0 :
                               csb2sdp_rdma_req_pvld;
end

always @(
  sdp_rdma_req_pvld
  or csb2sdp_rdma_req_prdy
  or csb2sdp_rdma_req_pvld
  ) begin
    csb2sdp_rdma_req_en = sdp_rdma_req_pvld & (csb2sdp_rdma_req_prdy | ~csb2sdp_rdma_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp_rdma_req_pvld <= 1'b0;
  end else begin
  sdp_rdma_req_pvld <= sdp_rdma_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2sdp_rdma_req_pvld <= 1'b0;
  end else begin
  csb2sdp_rdma_req_pvld <= csb2sdp_rdma_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2sdp_rdma_req_en) == 1'b1) begin
    csb2sdp_rdma_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2sdp_rdma_req_en) == 1'b0) begin
  end else begin
    csb2sdp_rdma_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2sdp_rdma_req_pd ={7'h0,csb2sdp_rdma_req_pd_tmp[49:16],6'h0,csb2sdp_rdma_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_csc = ((core_byte_addr & addr_mask) == 32'h00006000);
end

always @(
  core_req_pop_valid
  or select_csc
  or csb2csc_req_prdy
  or csb2csc_req_pvld
  or csc_req_pvld
  ) begin
    csc_req_pvld_w = (core_req_pop_valid & select_csc) ? 1'b1 :
                           (csb2csc_req_prdy | ~csb2csc_req_pvld) ? 1'b0 :
                           csc_req_pvld;
end

always @(
  csc_req_pvld
  or csb2csc_req_prdy
  or csb2csc_req_pvld
  ) begin
    csb2csc_req_pvld_w = csc_req_pvld ? 1'b1 :
                               csb2csc_req_prdy ? 1'b0 :
                               csb2csc_req_pvld;
end

always @(
  csc_req_pvld
  or csb2csc_req_prdy
  or csb2csc_req_pvld
  ) begin
    csb2csc_req_en = csc_req_pvld & (csb2csc_req_prdy | ~csb2csc_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csc_req_pvld <= 1'b0;
  end else begin
  csc_req_pvld <= csc_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2csc_req_pvld <= 1'b0;
  end else begin
  csb2csc_req_pvld <= csb2csc_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2csc_req_en) == 1'b1) begin
    csb2csc_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2csc_req_en) == 1'b0) begin
  end else begin
    csb2csc_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2csc_req_pd ={7'h0,csb2csc_req_pd_tmp[49:16],6'h0,csb2csc_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_gec = ((core_byte_addr & addr_mask) == 32'h00001000);
end

always @(
  core_req_pop_valid
  or select_gec
  or csb2gec_req_prdy
  or csb2gec_req_pvld
  or gec_req_pvld
  ) begin
    gec_req_pvld_w = (core_req_pop_valid & select_gec) ? 1'b1 :
                           (csb2gec_req_prdy | ~csb2gec_req_pvld) ? 1'b0 :
                           gec_req_pvld;
end

always @(
  gec_req_pvld
  or csb2gec_req_prdy
  or csb2gec_req_pvld
  ) begin
    csb2gec_req_pvld_w = gec_req_pvld ? 1'b1 :
                               csb2gec_req_prdy ? 1'b0 :
                               csb2gec_req_pvld;
end

always @(
  gec_req_pvld
  or csb2gec_req_prdy
  or csb2gec_req_pvld
  ) begin
    csb2gec_req_en = gec_req_pvld & (csb2gec_req_prdy | ~csb2gec_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    gec_req_pvld <= 1'b0;
  end else begin
  gec_req_pvld <= gec_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2gec_req_pvld <= 1'b0;
  end else begin
  csb2gec_req_pvld <= csb2gec_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2gec_req_en) == 1'b1) begin
    csb2gec_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2gec_req_en) == 1'b0) begin
  end else begin
    csb2gec_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2gec_req_pd ={7'h0,csb2gec_req_pd_tmp[49:16],6'h0,csb2gec_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_cdp = ((core_byte_addr & addr_mask) == 32'h0000f000);
end

always @(
  core_req_pop_valid
  or select_cdp
  or csb2cdp_req_prdy
  or csb2cdp_req_pvld
  or cdp_req_pvld
  ) begin
    cdp_req_pvld_w = (core_req_pop_valid & select_cdp) ? 1'b1 :
                           (csb2cdp_req_prdy | ~csb2cdp_req_pvld) ? 1'b0 :
                           cdp_req_pvld;
end

always @(
  cdp_req_pvld
  or csb2cdp_req_prdy
  or csb2cdp_req_pvld
  ) begin
    csb2cdp_req_pvld_w = cdp_req_pvld ? 1'b1 :
                               csb2cdp_req_prdy ? 1'b0 :
                               csb2cdp_req_pvld;
end

always @(
  cdp_req_pvld
  or csb2cdp_req_prdy
  or csb2cdp_req_pvld
  ) begin
    csb2cdp_req_en = cdp_req_pvld & (csb2cdp_req_prdy | ~csb2cdp_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdp_req_pvld <= 1'b0;
  end else begin
  cdp_req_pvld <= cdp_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2cdp_req_pvld <= 1'b0;
  end else begin
  csb2cdp_req_pvld <= csb2cdp_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2cdp_req_en) == 1'b1) begin
    csb2cdp_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2cdp_req_en) == 1'b0) begin
  end else begin
    csb2cdp_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2cdp_req_pd ={7'h0,csb2cdp_req_pd_tmp[49:16],6'h0,csb2cdp_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_cacc = ((core_byte_addr & addr_mask) == 32'h00009000);
end

always @(
  core_req_pop_valid
  or select_cacc
  or csb2cacc_req_prdy
  or csb2cacc_req_pvld
  or cacc_req_pvld
  ) begin
    cacc_req_pvld_w = (core_req_pop_valid & select_cacc) ? 1'b1 :
                           (csb2cacc_req_prdy | ~csb2cacc_req_pvld) ? 1'b0 :
                           cacc_req_pvld;
end

always @(
  cacc_req_pvld
  or csb2cacc_req_prdy
  or csb2cacc_req_pvld
  ) begin
    csb2cacc_req_pvld_w = cacc_req_pvld ? 1'b1 :
                               csb2cacc_req_prdy ? 1'b0 :
                               csb2cacc_req_pvld;
end

always @(
  cacc_req_pvld
  or csb2cacc_req_prdy
  or csb2cacc_req_pvld
  ) begin
    csb2cacc_req_en = cacc_req_pvld & (csb2cacc_req_prdy | ~csb2cacc_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cacc_req_pvld <= 1'b0;
  end else begin
  cacc_req_pvld <= cacc_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2cacc_req_pvld <= 1'b0;
  end else begin
  csb2cacc_req_pvld <= csb2cacc_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2cacc_req_en) == 1'b1) begin
    csb2cacc_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2cacc_req_en) == 1'b0) begin
  end else begin
    csb2cacc_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2cacc_req_pd ={7'h0,csb2cacc_req_pd_tmp[49:16],6'h0,csb2cacc_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_glb = ((core_byte_addr & addr_mask) == 32'h00000000);
end

always @(
  core_req_pop_valid
  or select_glb
  or csb2glb_req_prdy
  or csb2glb_req_pvld
  or glb_req_pvld
  ) begin
    glb_req_pvld_w = (core_req_pop_valid & select_glb) ? 1'b1 :
                           (csb2glb_req_prdy | ~csb2glb_req_pvld) ? 1'b0 :
                           glb_req_pvld;
end

always @(
  glb_req_pvld
  or csb2glb_req_prdy
  or csb2glb_req_pvld
  ) begin
    csb2glb_req_pvld_w = glb_req_pvld ? 1'b1 :
                               csb2glb_req_prdy ? 1'b0 :
                               csb2glb_req_pvld;
end

always @(
  glb_req_pvld
  or csb2glb_req_prdy
  or csb2glb_req_pvld
  ) begin
    csb2glb_req_en = glb_req_pvld & (csb2glb_req_prdy | ~csb2glb_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    glb_req_pvld <= 1'b0;
  end else begin
  glb_req_pvld <= glb_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2glb_req_pvld <= 1'b0;
  end else begin
  csb2glb_req_pvld <= csb2glb_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2glb_req_en) == 1'b1) begin
    csb2glb_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2glb_req_en) == 1'b0) begin
  end else begin
    csb2glb_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2glb_req_pd ={7'h0,csb2glb_req_pd_tmp[49:16],6'h0,csb2glb_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_cvif = ((core_byte_addr & addr_mask) == 32'h00003000);
end

always @(
  core_req_pop_valid
  or select_cvif
  or csb2cvif_req_prdy
  or csb2cvif_req_pvld
  or cvif_req_pvld
  ) begin
    cvif_req_pvld_w = (core_req_pop_valid & select_cvif) ? 1'b1 :
                           (csb2cvif_req_prdy | ~csb2cvif_req_pvld) ? 1'b0 :
                           cvif_req_pvld;
end

always @(
  cvif_req_pvld
  or csb2cvif_req_prdy
  or csb2cvif_req_pvld
  ) begin
    csb2cvif_req_pvld_w = cvif_req_pvld ? 1'b1 :
                               csb2cvif_req_prdy ? 1'b0 :
                               csb2cvif_req_pvld;
end

always @(
  cvif_req_pvld
  or csb2cvif_req_prdy
  or csb2cvif_req_pvld
  ) begin
    csb2cvif_req_en = cvif_req_pvld & (csb2cvif_req_prdy | ~csb2cvif_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvif_req_pvld <= 1'b0;
  end else begin
  cvif_req_pvld <= cvif_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2cvif_req_pvld <= 1'b0;
  end else begin
  csb2cvif_req_pvld <= csb2cvif_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2cvif_req_en) == 1'b1) begin
    csb2cvif_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2cvif_req_en) == 1'b0) begin
  end else begin
    csb2cvif_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2cvif_req_pd ={7'h0,csb2cvif_req_pd_tmp[49:16],6'h0,csb2cvif_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_cmac_b = ((core_byte_addr & addr_mask) == 32'h00008000);
end

always @(
  core_req_pop_valid
  or select_cmac_b
  or csb2cmac_b_req_prdy
  or csb2cmac_b_req_pvld
  or cmac_b_req_pvld
  ) begin
    cmac_b_req_pvld_w = (core_req_pop_valid & select_cmac_b) ? 1'b1 :
                           (csb2cmac_b_req_prdy | ~csb2cmac_b_req_pvld) ? 1'b0 :
                           cmac_b_req_pvld;
end

always @(
  cmac_b_req_pvld
  or csb2cmac_b_req_prdy
  or csb2cmac_b_req_pvld
  ) begin
    csb2cmac_b_req_pvld_w = cmac_b_req_pvld ? 1'b1 :
                               csb2cmac_b_req_prdy ? 1'b0 :
                               csb2cmac_b_req_pvld;
end

always @(
  cmac_b_req_pvld
  or csb2cmac_b_req_prdy
  or csb2cmac_b_req_pvld
  ) begin
    csb2cmac_b_req_en = cmac_b_req_pvld & (csb2cmac_b_req_prdy | ~csb2cmac_b_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmac_b_req_pvld <= 1'b0;
  end else begin
  cmac_b_req_pvld <= cmac_b_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2cmac_b_req_pvld <= 1'b0;
  end else begin
  csb2cmac_b_req_pvld <= csb2cmac_b_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2cmac_b_req_en) == 1'b1) begin
    csb2cmac_b_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2cmac_b_req_en) == 1'b0) begin
  end else begin
    csb2cmac_b_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2cmac_b_req_pd ={7'h0,csb2cmac_b_req_pd_tmp[49:16],6'h0,csb2cmac_b_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_pdp = ((core_byte_addr & addr_mask) == 32'h0000d000);
end

always @(
  core_req_pop_valid
  or select_pdp
  or csb2pdp_req_prdy
  or csb2pdp_req_pvld
  or pdp_req_pvld
  ) begin
    pdp_req_pvld_w = (core_req_pop_valid & select_pdp) ? 1'b1 :
                           (csb2pdp_req_prdy | ~csb2pdp_req_pvld) ? 1'b0 :
                           pdp_req_pvld;
end

always @(
  pdp_req_pvld
  or csb2pdp_req_prdy
  or csb2pdp_req_pvld
  ) begin
    csb2pdp_req_pvld_w = pdp_req_pvld ? 1'b1 :
                               csb2pdp_req_prdy ? 1'b0 :
                               csb2pdp_req_pvld;
end

always @(
  pdp_req_pvld
  or csb2pdp_req_prdy
  or csb2pdp_req_pvld
  ) begin
    csb2pdp_req_en = pdp_req_pvld & (csb2pdp_req_prdy | ~csb2pdp_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp_req_pvld <= 1'b0;
  end else begin
  pdp_req_pvld <= pdp_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2pdp_req_pvld <= 1'b0;
  end else begin
  csb2pdp_req_pvld <= csb2pdp_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2pdp_req_en) == 1'b1) begin
    csb2pdp_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2pdp_req_en) == 1'b0) begin
  end else begin
    csb2pdp_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2pdp_req_pd ={7'h0,csb2pdp_req_pd_tmp[49:16],6'h0,csb2pdp_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_cdma = ((core_byte_addr & addr_mask) == 32'h00005000);
end

always @(
  core_req_pop_valid
  or select_cdma
  or csb2cdma_req_prdy
  or csb2cdma_req_pvld
  or cdma_req_pvld
  ) begin
    cdma_req_pvld_w = (core_req_pop_valid & select_cdma) ? 1'b1 :
                           (csb2cdma_req_prdy | ~csb2cdma_req_pvld) ? 1'b0 :
                           cdma_req_pvld;
end

always @(
  cdma_req_pvld
  or csb2cdma_req_prdy
  or csb2cdma_req_pvld
  ) begin
    csb2cdma_req_pvld_w = cdma_req_pvld ? 1'b1 :
                               csb2cdma_req_prdy ? 1'b0 :
                               csb2cdma_req_pvld;
end

always @(
  cdma_req_pvld
  or csb2cdma_req_prdy
  or csb2cdma_req_pvld
  ) begin
    csb2cdma_req_en = cdma_req_pvld & (csb2cdma_req_prdy | ~csb2cdma_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdma_req_pvld <= 1'b0;
  end else begin
  cdma_req_pvld <= cdma_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2cdma_req_pvld <= 1'b0;
  end else begin
  csb2cdma_req_pvld <= csb2cdma_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2cdma_req_en) == 1'b1) begin
    csb2cdma_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2cdma_req_en) == 1'b0) begin
  end else begin
    csb2cdma_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2cdma_req_pd ={7'h0,csb2cdma_req_pd_tmp[49:16],6'h0,csb2cdma_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_sdp = ((core_byte_addr & addr_mask) == 32'h0000b000);
end

always @(
  core_req_pop_valid
  or select_sdp
  or csb2sdp_req_prdy
  or csb2sdp_req_pvld
  or sdp_req_pvld
  ) begin
    sdp_req_pvld_w = (core_req_pop_valid & select_sdp) ? 1'b1 :
                           (csb2sdp_req_prdy | ~csb2sdp_req_pvld) ? 1'b0 :
                           sdp_req_pvld;
end

always @(
  sdp_req_pvld
  or csb2sdp_req_prdy
  or csb2sdp_req_pvld
  ) begin
    csb2sdp_req_pvld_w = sdp_req_pvld ? 1'b1 :
                               csb2sdp_req_prdy ? 1'b0 :
                               csb2sdp_req_pvld;
end

always @(
  sdp_req_pvld
  or csb2sdp_req_prdy
  or csb2sdp_req_pvld
  ) begin
    csb2sdp_req_en = sdp_req_pvld & (csb2sdp_req_prdy | ~csb2sdp_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp_req_pvld <= 1'b0;
  end else begin
  sdp_req_pvld <= sdp_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2sdp_req_pvld <= 1'b0;
  end else begin
  csb2sdp_req_pvld <= csb2sdp_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2sdp_req_en) == 1'b1) begin
    csb2sdp_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2sdp_req_en) == 1'b0) begin
  end else begin
    csb2sdp_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2sdp_req_pd ={7'h0,csb2sdp_req_pd_tmp[49:16],6'h0,csb2sdp_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_bdma = ((core_byte_addr & addr_mask) == 32'h00004000);
end

always @(
  core_req_pop_valid
  or select_bdma
  or csb2bdma_req_prdy
  or csb2bdma_req_pvld
  or bdma_req_pvld
  ) begin
    bdma_req_pvld_w = (core_req_pop_valid & select_bdma) ? 1'b1 :
                           (csb2bdma_req_prdy | ~csb2bdma_req_pvld) ? 1'b0 :
                           bdma_req_pvld;
end

always @(
  bdma_req_pvld
  or csb2bdma_req_prdy
  or csb2bdma_req_pvld
  ) begin
    csb2bdma_req_pvld_w = bdma_req_pvld ? 1'b1 :
                               csb2bdma_req_prdy ? 1'b0 :
                               csb2bdma_req_pvld;
end

always @(
  bdma_req_pvld
  or csb2bdma_req_prdy
  or csb2bdma_req_pvld
  ) begin
    csb2bdma_req_en = bdma_req_pvld & (csb2bdma_req_prdy | ~csb2bdma_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bdma_req_pvld <= 1'b0;
  end else begin
  bdma_req_pvld <= bdma_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2bdma_req_pvld <= 1'b0;
  end else begin
  csb2bdma_req_pvld <= csb2bdma_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2bdma_req_en) == 1'b1) begin
    csb2bdma_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2bdma_req_en) == 1'b0) begin
  end else begin
    csb2bdma_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2bdma_req_pd ={7'h0,csb2bdma_req_pd_tmp[49:16],6'h0,csb2bdma_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_pdp_rdma = ((core_byte_addr & addr_mask) == 32'h0000c000);
end

always @(
  core_req_pop_valid
  or select_pdp_rdma
  or csb2pdp_rdma_req_prdy
  or csb2pdp_rdma_req_pvld
  or pdp_rdma_req_pvld
  ) begin
    pdp_rdma_req_pvld_w = (core_req_pop_valid & select_pdp_rdma) ? 1'b1 :
                           (csb2pdp_rdma_req_prdy | ~csb2pdp_rdma_req_pvld) ? 1'b0 :
                           pdp_rdma_req_pvld;
end

always @(
  pdp_rdma_req_pvld
  or csb2pdp_rdma_req_prdy
  or csb2pdp_rdma_req_pvld
  ) begin
    csb2pdp_rdma_req_pvld_w = pdp_rdma_req_pvld ? 1'b1 :
                               csb2pdp_rdma_req_prdy ? 1'b0 :
                               csb2pdp_rdma_req_pvld;
end

always @(
  pdp_rdma_req_pvld
  or csb2pdp_rdma_req_prdy
  or csb2pdp_rdma_req_pvld
  ) begin
    csb2pdp_rdma_req_en = pdp_rdma_req_pvld & (csb2pdp_rdma_req_prdy | ~csb2pdp_rdma_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp_rdma_req_pvld <= 1'b0;
  end else begin
  pdp_rdma_req_pvld <= pdp_rdma_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2pdp_rdma_req_pvld <= 1'b0;
  end else begin
  csb2pdp_rdma_req_pvld <= csb2pdp_rdma_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2pdp_rdma_req_en) == 1'b1) begin
    csb2pdp_rdma_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2pdp_rdma_req_en) == 1'b0) begin
  end else begin
    csb2pdp_rdma_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2pdp_rdma_req_pd ={7'h0,csb2pdp_rdma_req_pd_tmp[49:16],6'h0,csb2pdp_rdma_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_mcif = ((core_byte_addr & addr_mask) == 32'h00002000);
end

always @(
  core_req_pop_valid
  or select_mcif
  or csb2mcif_req_prdy
  or csb2mcif_req_pvld
  or mcif_req_pvld
  ) begin
    mcif_req_pvld_w = (core_req_pop_valid & select_mcif) ? 1'b1 :
                           (csb2mcif_req_prdy | ~csb2mcif_req_pvld) ? 1'b0 :
                           mcif_req_pvld;
end

always @(
  mcif_req_pvld
  or csb2mcif_req_prdy
  or csb2mcif_req_pvld
  ) begin
    csb2mcif_req_pvld_w = mcif_req_pvld ? 1'b1 :
                               csb2mcif_req_prdy ? 1'b0 :
                               csb2mcif_req_pvld;
end

always @(
  mcif_req_pvld
  or csb2mcif_req_prdy
  or csb2mcif_req_pvld
  ) begin
    csb2mcif_req_en = mcif_req_pvld & (csb2mcif_req_prdy | ~csb2mcif_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif_req_pvld <= 1'b0;
  end else begin
  mcif_req_pvld <= mcif_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2mcif_req_pvld <= 1'b0;
  end else begin
  csb2mcif_req_pvld <= csb2mcif_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2mcif_req_en) == 1'b1) begin
    csb2mcif_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2mcif_req_en) == 1'b0) begin
  end else begin
    csb2mcif_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2mcif_req_pd ={7'h0,csb2mcif_req_pd_tmp[49:16],6'h0,csb2mcif_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_cdp_rdma = ((core_byte_addr & addr_mask) == 32'h0000e000);
end

always @(
  core_req_pop_valid
  or select_cdp_rdma
  or csb2cdp_rdma_req_prdy
  or csb2cdp_rdma_req_pvld
  or cdp_rdma_req_pvld
  ) begin
    cdp_rdma_req_pvld_w = (core_req_pop_valid & select_cdp_rdma) ? 1'b1 :
                           (csb2cdp_rdma_req_prdy | ~csb2cdp_rdma_req_pvld) ? 1'b0 :
                           cdp_rdma_req_pvld;
end

always @(
  cdp_rdma_req_pvld
  or csb2cdp_rdma_req_prdy
  or csb2cdp_rdma_req_pvld
  ) begin
    csb2cdp_rdma_req_pvld_w = cdp_rdma_req_pvld ? 1'b1 :
                               csb2cdp_rdma_req_prdy ? 1'b0 :
                               csb2cdp_rdma_req_pvld;
end

always @(
  cdp_rdma_req_pvld
  or csb2cdp_rdma_req_prdy
  or csb2cdp_rdma_req_pvld
  ) begin
    csb2cdp_rdma_req_en = cdp_rdma_req_pvld & (csb2cdp_rdma_req_prdy | ~csb2cdp_rdma_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdp_rdma_req_pvld <= 1'b0;
  end else begin
  cdp_rdma_req_pvld <= cdp_rdma_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2cdp_rdma_req_pvld <= 1'b0;
  end else begin
  csb2cdp_rdma_req_pvld <= csb2cdp_rdma_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2cdp_rdma_req_en) == 1'b1) begin
    csb2cdp_rdma_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2cdp_rdma_req_en) == 1'b0) begin
  end else begin
    csb2cdp_rdma_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2cdp_rdma_req_pd ={7'h0,csb2cdp_rdma_req_pd_tmp[49:16],6'h0,csb2cdp_rdma_req_pd_tmp[15:0]};


always @(
  core_byte_addr
  or addr_mask
  ) begin
    select_rbk = ((core_byte_addr & addr_mask) == 32'h00010000);
end

always @(
  core_req_pop_valid
  or select_rbk
  or csb2rbk_req_prdy
  or csb2rbk_req_pvld
  or rbk_req_pvld
  ) begin
    rbk_req_pvld_w = (core_req_pop_valid & select_rbk) ? 1'b1 :
                           (csb2rbk_req_prdy | ~csb2rbk_req_pvld) ? 1'b0 :
                           rbk_req_pvld;
end

always @(
  rbk_req_pvld
  or csb2rbk_req_prdy
  or csb2rbk_req_pvld
  ) begin
    csb2rbk_req_pvld_w = rbk_req_pvld ? 1'b1 :
                               csb2rbk_req_prdy ? 1'b0 :
                               csb2rbk_req_pvld;
end

always @(
  rbk_req_pvld
  or csb2rbk_req_prdy
  or csb2rbk_req_pvld
  ) begin
    csb2rbk_req_en = rbk_req_pvld & (csb2rbk_req_prdy | ~csb2rbk_req_pvld);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rbk_req_pvld <= 1'b0;
  end else begin
  rbk_req_pvld <= rbk_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2rbk_req_pvld <= 1'b0;
  end else begin
  csb2rbk_req_pvld <= csb2rbk_req_pvld_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((csb2rbk_req_en) == 1'b1) begin
    csb2rbk_req_pd_tmp <= core_req_pd_d1;
  // VCS coverage off
  end else if ((csb2rbk_req_en) == 1'b0) begin
  end else begin
    csb2rbk_req_pd_tmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2rbk_req_pd ={7'h0,csb2rbk_req_pd_tmp[49:16],6'h0,csb2rbk_req_pd_tmp[15:0]};

////////////////// dummy client //////////////////////
always @(
  select_afbif
  or select_cmac_a
  or select_sdp_rdma
  or select_csc
  or select_gec
  or select_cdp
  or select_cacc
  or select_glb
  or select_cvif
  or select_cmac_b
  or select_pdp
  or select_cdma
  or select_sdp
  or select_bdma
  or select_pdp_rdma
  or select_mcif
  or select_cdp_rdma
  or select_rbk
  ) begin
    select_dummy = ~(select_afbif
                   | select_cmac_a
                   | select_sdp_rdma
                   | select_csc
                   | select_gec
                   | select_cdp
                   | select_cacc
                   | select_glb
                   | select_cvif
                   | select_cmac_b
                   | select_pdp
                   | select_cdma
                   | select_sdp
                   | select_bdma
                   | select_pdp_rdma
                   | select_mcif
                   | select_cdp_rdma
                   | select_rbk);
end



//assign csb2dummy_req_prdy = 1'b1;

always @(
  core_req_pop_valid
  or select_dummy
  ) begin
    dummy_req_pvld_w = (core_req_pop_valid & select_dummy);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb2dummy_req_pvld <= 1'b0;
  end else begin
  csb2dummy_req_pvld <= dummy_req_pvld_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dummy_req_pvld_w) == 1'b1) begin
    csb2dummy_req_nposted <= core_req_nposted;
  // VCS coverage off
  end else if ((dummy_req_pvld_w) == 1'b0) begin
  end else begin
    csb2dummy_req_nposted <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dummy_req_pvld_w) == 1'b1) begin
    csb2dummy_req_read <= ~core_req_write;
  // VCS coverage off
  end else if ((dummy_req_pvld_w) == 1'b0) begin
  end else begin
    csb2dummy_req_read <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


// PKT_PACK_WIRE_ID( nvdla_xx2csb_resp ,  dla_xx2csb_rd_erpt ,  dummy_resp_ ,  dummy_rresp_pd )
assign       dummy_rresp_pd[31:0] =     dummy_resp_rdat[31:0];
assign       dummy_rresp_pd[32] =     dummy_resp_error ;

assign   dummy_rresp_pd[33:33] = 1'd0  /* PKT_nvdla_xx2csb_resp_dla_xx2csb_rd_erpt_ID  */ ;

// PKT_PACK_WIRE_ID( nvdla_xx2csb_resp ,  dla_xx2csb_wr_erpt ,  dummy_resp_ ,  dummy_wresp_pd )
assign       dummy_wresp_pd[31:0] =     dummy_resp_rdat[31:0];
assign       dummy_wresp_pd[32] =     dummy_resp_error ;

assign   dummy_wresp_pd[33:33] = 1'd1  /* PKT_nvdla_xx2csb_resp_dla_xx2csb_wr_erpt_ID  */ ;
assign dummy_resp_rdat = {32 {1'b0}};
assign dummy_resp_error = 1'b0;

assign dummy_resp_valid_w = csb2dummy_req_pvld & (csb2dummy_req_nposted | csb2dummy_req_read);
assign dummy_resp_type_w = ~csb2dummy_req_read & csb2dummy_req_nposted;
assign dummy_resp_pd = dummy_resp_type ? dummy_wresp_pd : dummy_rresp_pd;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dummy_resp_valid <= 1'b0;
  end else begin
  dummy_resp_valid <= dummy_resp_valid_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dummy_resp_type <= 1'b0;
  end else begin
  if ((dummy_resp_valid_w) == 1'b1) begin
    dummy_resp_type <= dummy_resp_type_w;
  // VCS coverage off
  end else if ((dummy_resp_valid_w) == 1'b0) begin
  end else begin
    dummy_resp_type <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dummy_resp_valid_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cmac_a_resp_valid <= 1'b0;
  end else begin
  cmac_a_resp_valid <= cmac_a2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cmac_a2csb_resp_valid) == 1'b1) begin
    cmac_a_resp_pd <= cmac_a2csb_resp_pd;
  // VCS coverage off
  end else if ((cmac_a2csb_resp_valid) == 1'b0) begin
  end else begin
    cmac_a_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp_rdma_resp_valid <= 1'b0;
  end else begin
  sdp_rdma_resp_valid <= sdp_rdma2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sdp_rdma2csb_resp_valid) == 1'b1) begin
    sdp_rdma_resp_pd <= sdp_rdma2csb_resp_pd;
  // VCS coverage off
  end else if ((sdp_rdma2csb_resp_valid) == 1'b0) begin
  end else begin
    sdp_rdma_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csc_resp_valid <= 1'b0;
  end else begin
  csc_resp_valid <= csc2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((csc2csb_resp_valid) == 1'b1) begin
    csc_resp_pd <= csc2csb_resp_pd;
  // VCS coverage off
  end else if ((csc2csb_resp_valid) == 1'b0) begin
  end else begin
    csc_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    gec_resp_valid <= 1'b0;
  end else begin
  gec_resp_valid <= gec2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((gec2csb_resp_valid) == 1'b1) begin
    gec_resp_pd <= gec2csb_resp_pd;
  // VCS coverage off
  end else if ((gec2csb_resp_valid) == 1'b0) begin
  end else begin
    gec_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdp_resp_valid <= 1'b0;
  end else begin
  cdp_resp_valid <= cdp2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cdp2csb_resp_valid) == 1'b1) begin
    cdp_resp_pd <= cdp2csb_resp_pd;
  // VCS coverage off
  end else if ((cdp2csb_resp_valid) == 1'b0) begin
  end else begin
    cdp_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cacc_resp_valid <= 1'b0;
  end else begin
  cacc_resp_valid <= cacc2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cacc2csb_resp_valid) == 1'b1) begin
    cacc_resp_pd <= cacc2csb_resp_pd;
  // VCS coverage off
  end else if ((cacc2csb_resp_valid) == 1'b0) begin
  end else begin
    cacc_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    glb_resp_valid <= 1'b0;
  end else begin
  glb_resp_valid <= glb2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((glb2csb_resp_valid) == 1'b1) begin
    glb_resp_pd <= glb2csb_resp_pd;
  // VCS coverage off
  end else if ((glb2csb_resp_valid) == 1'b0) begin
  end else begin
    glb_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvif_resp_valid <= 1'b0;
  end else begin
  cvif_resp_valid <= cvif2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvif2csb_resp_valid) == 1'b1) begin
    cvif_resp_pd <= cvif2csb_resp_pd;
  // VCS coverage off
  end else if ((cvif2csb_resp_valid) == 1'b0) begin
  end else begin
    cvif_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmac_b_resp_valid <= 1'b0;
  end else begin
  cmac_b_resp_valid <= cmac_b2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cmac_b2csb_resp_valid) == 1'b1) begin
    cmac_b_resp_pd <= cmac_b2csb_resp_pd;
  // VCS coverage off
  end else if ((cmac_b2csb_resp_valid) == 1'b0) begin
  end else begin
    cmac_b_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp_resp_valid <= 1'b0;
  end else begin
  pdp_resp_valid <= pdp2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pdp2csb_resp_valid) == 1'b1) begin
    pdp_resp_pd <= pdp2csb_resp_pd;
  // VCS coverage off
  end else if ((pdp2csb_resp_valid) == 1'b0) begin
  end else begin
    pdp_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdma_resp_valid <= 1'b0;
  end else begin
  cdma_resp_valid <= cdma2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cdma2csb_resp_valid) == 1'b1) begin
    cdma_resp_pd <= cdma2csb_resp_pd;
  // VCS coverage off
  end else if ((cdma2csb_resp_valid) == 1'b0) begin
  end else begin
    cdma_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp_resp_valid <= 1'b0;
  end else begin
  sdp_resp_valid <= sdp2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sdp2csb_resp_valid) == 1'b1) begin
    sdp_resp_pd <= sdp2csb_resp_pd;
  // VCS coverage off
  end else if ((sdp2csb_resp_valid) == 1'b0) begin
  end else begin
    sdp_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bdma_resp_valid <= 1'b0;
  end else begin
  bdma_resp_valid <= bdma2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((bdma2csb_resp_valid) == 1'b1) begin
    bdma_resp_pd <= bdma2csb_resp_pd;
  // VCS coverage off
  end else if ((bdma2csb_resp_valid) == 1'b0) begin
  end else begin
    bdma_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp_rdma_resp_valid <= 1'b0;
  end else begin
  pdp_rdma_resp_valid <= pdp_rdma2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pdp_rdma2csb_resp_valid) == 1'b1) begin
    pdp_rdma_resp_pd <= pdp_rdma2csb_resp_pd;
  // VCS coverage off
  end else if ((pdp_rdma2csb_resp_valid) == 1'b0) begin
  end else begin
    pdp_rdma_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mcif_resp_valid <= 1'b0;
  end else begin
  mcif_resp_valid <= mcif2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mcif2csb_resp_valid) == 1'b1) begin
    mcif_resp_pd <= mcif2csb_resp_pd;
  // VCS coverage off
  end else if ((mcif2csb_resp_valid) == 1'b0) begin
  end else begin
    mcif_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdp_rdma_resp_valid <= 1'b0;
  end else begin
  cdp_rdma_resp_valid <= cdp_rdma2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cdp_rdma2csb_resp_valid) == 1'b1) begin
    cdp_rdma_resp_pd <= cdp_rdma2csb_resp_pd;
  // VCS coverage off
  end else if ((cdp_rdma2csb_resp_valid) == 1'b0) begin
  end else begin
    cdp_rdma_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rbk_resp_valid <= 1'b0;
  end else begin
  rbk_resp_valid <= rbk2csb_resp_valid;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rbk2csb_resp_valid) == 1'b1) begin
    rbk_resp_pd <= rbk2csb_resp_pd;
  // VCS coverage off
  end else if ((rbk2csb_resp_valid) == 1'b0) begin
  end else begin
    rbk_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


assign core_resp_pd = ({34 {afbif_resp_pvld}} & afbif_resp_pd)
                    | ({34 {cmac_a_resp_valid}} & cmac_a_resp_pd)
                    | ({34 {sdp_rdma_resp_valid}} & sdp_rdma_resp_pd)
                    | ({34 {csc_resp_valid}} & csc_resp_pd)
                    | ({34 {gec_resp_valid}} & gec_resp_pd)
                    | ({34 {cdp_resp_valid}} & cdp_resp_pd)
                    | ({34 {cacc_resp_valid}} & cacc_resp_pd)
                    | ({34 {glb_resp_valid}} & glb_resp_pd)
                    | ({34 {cvif_resp_valid}} & cvif_resp_pd)
                    | ({34 {cmac_b_resp_valid}} & cmac_b_resp_pd)
                    | ({34 {pdp_resp_valid}} & pdp_resp_pd)
                    | ({34 {cdma_resp_valid}} & cdma_resp_pd)
                    | ({34 {sdp_resp_valid}} & sdp_resp_pd)
                    | ({34 {bdma_resp_valid}} & bdma_resp_pd)
                    | ({34 {pdp_rdma_resp_valid}} & pdp_rdma_resp_pd)
                    | ({34 {mcif_resp_valid}} & mcif_resp_pd)
                    | ({34 {cdp_rdma_resp_valid}} & cdp_rdma_resp_pd)
                    | ({34 {rbk_resp_valid}} & rbk_resp_pd)
                    | ({34 {dummy_resp_valid}} & dummy_resp_pd);

assign core_resp_pvld = afbif_resp_pvld |
                        cmac_a_resp_valid |
                        sdp_rdma_resp_valid |
                        csc_resp_valid |
                        gec_resp_valid |
                        cdp_resp_valid |
                        cacc_resp_valid |
                        glb_resp_valid |
                        cvif_resp_valid |
                        cmac_b_resp_valid |
                        pdp_resp_valid |
                        cdma_resp_valid |
                        sdp_resp_valid |
                        bdma_resp_valid |
                        pdp_rdma_resp_valid |
                        mcif_resp_valid |
                        cdp_rdma_resp_valid |
                        rbk_resp_valid |
                        dummy_resp_valid;

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
  nv_assert_zero_one_hot #(0,19,0,"Error! Multiple response!")      zzz_assert_zero_one_hot_3x (nvdla_core_clk, `ASSERT_RESET, {afbif_resp_pvld,                                                                          cmac_a2csb_resp_valid,                                                                          sdp_rdma2csb_resp_valid,                                                                          csc2csb_resp_valid,                                                                          gec2csb_resp_valid,                                                                          cdp2csb_resp_valid,                                                                          cacc2csb_resp_valid,                                                                          glb2csb_resp_valid,                                                                          cvif2csb_resp_valid,                                                                          cmac_b2csb_resp_valid,                                                                          pdp2csb_resp_valid,                                                                          cdma2csb_resp_valid,                                                                          sdp2csb_resp_valid,                                                                          bdma2csb_resp_valid,                                                                          pdp_rdma2csb_resp_valid,                                                                          mcif2csb_resp_valid,                                                                          cdp_rdma2csb_resp_valid,                                                                          rbk2csb_resp_valid,                                                                          dummy_resp_valid}); // spyglass disable W504 SelfDeterminedExpr-ML 
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



////////////////////////////////////////////////////////////////////////
// CSB master to AFBIF interface                                      //
////////////////////////////////////////////////////////////////////////
/*
&Instance NV_NVDLA_CSB_MASTER_csb2afbif_fifo u_fifo_csb2afbif;
    &Connect    wr_clk          nvdla_core_clk;
    &Connect    wr_reset_       nvdla_core_rstn;
    &Connect    wr_req          core2afbif_req_pvld;
    &Connect    wr_busy         core2afbif_req_busy_next;
    &Connect    wr_data         core2afbif_req_pd;
    &Connect    rd_clk          nvdla_falcon_clk;
    &Connect    rd_reset_       nvdla_falcon_rstn;
    &Connect    rd_req          csb2afbif_pvld;
    &Connect    rd_ready        csb2afbif_prdy;
    &Connect    rd_data         csb2afbif_pd;

&Instance NV_NVDLA_CSB_MASTER_afbif2csb_fifo u_fifo_afbif2csb;
    &Connect    wr_clk          nvdla_falcon_clk;
    &Connect    wr_reset_       nvdla_falcon_rstn;
    &Connect    wr_req          afbif2csb_resp_pvld;
    &Connect    wr_ready        afbif2csb_resp_prdy;
    &Connect    wr_data         afbif2csb_resp_pd;
    &Connect    rd_clk          nvdla_core_clk;
    &Connect    rd_reset_       nvdla_core_rstn;
    &Connect    rd_req          afbif_resp_pvld;
    &Connect    rd_ready        1'b1;
    &Connect    rd_data         afbif_resp_pd;

PKT_PACK_WIRE_ID (nvdla_xx2csb_resp, dla_xx2csb_rd_erpt, afbif2csb_rresp_, afbif2csb_rresp_pd)
PKT_PACK_WIRE_ID (nvdla_xx2csb_resp, dla_xx2csb_wr_erpt, afbif2csb_wresp_, afbif2csb_wresp_pd)

&Forget dangle afbif2csb_resp_prdy;
assign afbif2csb_rresp_rdat = afbif2csb_pd;
assign afbif2csb_wresp_rdat = afbif2csb_wr_rdat;
assign afbif2csb_rresp_error = afbif2csb_error;
assign afbif2csb_wresp_error = afbif2csb_wr_error;

::assert never #(sim_only) "Error! afbif response fifo block!" (afbif2csb_resp_pvld & ~afbif2csb_resp_prdy);

&Always;
    afbif2csb_resp_pvld = afbif2csb_wr_complete | afbif2csb_valid;
&End;

&Always;
    afbif2csb_resp_pd = (afbif2csb_valid) ? afbif2csb_rresp_pd : afbif2csb_wresp_pd;
&End;
*/
assign  afbif_resp_pvld = 1'b0;
assign  afbif_resp_pd = 34'h0;

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           {csb2dummy_req_pvld,csb2mcif_req_pvld};

//////////////////////////////////////////////////////////////
///// functional point                                   /////
//////////////////////////////////////////////////////////////

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    reg funcpoint_cover_off;
    initial begin
        if ( $test$plusargs( "cover_off" ) ) begin
            funcpoint_cover_off = 1'b1;
        end else begin
            funcpoint_cover_off = 1'b0;
        end
    end

    property csb_master__read_dummy_client__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (core_req_pop_valid & ~core_req_write & select_dummy);
    endproperty
    // Cover 0 : "(core_req_pop_valid & ~core_req_write & select_dummy)"
    FUNCPOINT_csb_master__read_dummy_client__0_COV : cover property (csb_master__read_dummy_client__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csb_master__posted_write_dummy_client__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (core_req_pop_valid & core_req_write & ~core_req_nposted & select_dummy);
    endproperty
    // Cover 1 : "(core_req_pop_valid & core_req_write & ~core_req_nposted & select_dummy)"
    FUNCPOINT_csb_master__posted_write_dummy_client__1_COV : cover property (csb_master__posted_write_dummy_client__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csb_master__non_posted_dummy_client__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (core_req_pop_valid & core_req_write & core_req_nposted & select_dummy);
    endproperty
    // Cover 2 : "(core_req_pop_valid & core_req_write & core_req_nposted & select_dummy)"
    FUNCPOINT_csb_master__non_posted_dummy_client__2_COV : cover property (csb_master__non_posted_dummy_client__2_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_csb_master


