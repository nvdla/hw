// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_nocif.v

#include "NV_NVDLA_MCIF_define.h"

module NV_NVDLA_nocif (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,pwrbus_ram_pd
#ifdef  SEKHAR_MCIF
//: my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,client${i}2mcif_rd_cdt_lat_fifo_pop\n");
//: print("  ,client${i}2mcif_rd_req_valid\n");
//: print("  ,client${i}2mcif_rd_req_pd\n");
//: print("  ,client${i}2mcif_rd_req_ready\n");
//: print("  ,mcif2client${i}_rd_rsp_valid\n");
//: print("  ,mcif2client${i}_rd_rsp_pd\n");
//: print("  ,mcif2client${i}_rd_rsp_ready\n");
//: print("  ,client${i}2mcif_lat_fifo_depth\n");
//: print("  ,client${i}2mcif_rd_axid\n");
//: }
//: my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,client${i}2mcif_wr_req_pd\n");
//: print("  ,client${i}2mcif_wr_req_valid\n");
//: print("  ,client${i}2mcif_wr_req_ready\n");
//: print("  ,mcif2client${i}_wr_rsp_complete\n");
//: print("  ,client${i}2mcif_wr_axid\n");
//: }
#else 
//: my @rdma_name = RDMA_NAME; 
//: foreach my $client (@rdma_name) {
//: print "  ,${client}2mcif_rd_cdt_lat_fifo_pop\n";
//: print "  ,${client}2mcif_rd_req_valid\n";
//: print "  ,${client}2mcif_rd_req_ready\n";
//: print "  ,${client}2mcif_rd_req_pd\n";
//: print "  ,mcif2${client}_rd_rsp_valid\n";
//: print "  ,mcif2${client}_rd_rsp_ready\n";
//: print "  ,mcif2${client}_rd_rsp_pd\n";
//: }
//: my @wdma_name = WDMA_NAME; 
//: foreach my $client (@wdma_name) {
//: print "  ,${client}2mcif_wr_req_valid\n";
//: print "  ,${client}2mcif_wr_req_ready\n";
//: print "  ,${client}2mcif_wr_req_pd\n";
//: print "  ,mcif2${client}_wr_rsp_complete\n";
//: }
#endif
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
//: my @rdma_name = RDMA_NAME; 
//: foreach my $client (@rdma_name) {
//: print "  ,${client}2cvif_rd_cdt_lat_fifo_pop\n";
//: print "  ,${client}2cvif_rd_req_valid\n";
//: print "  ,${client}2cvif_rd_req_ready\n";
//: print "  ,${client}2cvif_rd_req_pd\n";
//: print "  ,cvif2${client}_rd_rsp_valid\n";
//: print "  ,cvif2${client}_rd_rsp_ready\n";
//: print "  ,cvif2${client}_rd_rsp_pd\n";
//: }
//: my @wdma_name = WDMA_NAME; 
//: foreach my $client (@wdma_name) {
//: print "  ,${client}2cvif_wr_req_valid\n";
//: print "  ,${client}2cvif_wr_req_ready\n";
//: print "  ,${client}2cvif_wr_req_pd\n";
//: print "  ,cvif2${client}_wr_rsp_complete\n";
//: }
  ,csb2cvif_req_pd                //|< i
  ,csb2cvif_req_pvld              //|< i
  ,csb2cvif_req_prdy              //|> o
  ,cvif2csb_resp_pd               //|> o
  ,cvif2csb_resp_valid            //|> o
  ,noc2cvif_axi_b_bid             //|< i
  ,noc2cvif_axi_b_bvalid          //|< i
  ,noc2cvif_axi_r_rdata           //|< i
  ,noc2cvif_axi_r_rid             //|< i
  ,noc2cvif_axi_r_rlast           //|< i
  ,noc2cvif_axi_r_rvalid          //|< i
  ,cvif2noc_axi_ar_arready        //|< i
  ,cvif2noc_axi_aw_awready        //|< i
  ,cvif2noc_axi_w_wready          //|< i
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
  ,noc2cvif_axi_b_bready          //|> o
  ,noc2cvif_axi_r_rready          //|> o
#endif
  ,csb2mcif_req_pd                //|< i
  ,csb2mcif_req_pvld              //|< i
  ,csb2mcif_req_prdy              //|> o
  ,mcif2csb_resp_pd               //|> o
  ,mcif2csb_resp_valid            //|> o
  ,noc2mcif_axi_b_bid             //|< i
  ,noc2mcif_axi_b_bvalid          //|< i
  ,noc2mcif_axi_r_rdata           //|< i
  ,noc2mcif_axi_r_rid             //|< i
  ,noc2mcif_axi_r_rlast           //|< i
  ,noc2mcif_axi_r_rvalid          //|< i
  ,mcif2noc_axi_ar_arready        //|< i
  ,mcif2noc_axi_aw_awready        //|< i
  ,mcif2noc_axi_w_wready          //|< i
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
  ,noc2mcif_axi_b_bready          //|> o
  ,noc2mcif_axi_r_rready          //|> o
);


#ifdef  SEKHAR_MCIF
//:my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//:my $i = 0;
//:for ($i=0;$i<$k;$i++) {
//: print ("input client${i}2mcif_rd_cdt_lat_fifo_pop;\n");
//: print("input client${i}2mcif_rd_req_valid;\n");
//: print qq(input [NVDLA_DMA_RD_REQ-1:0] client${i}2mcif_rd_req_pd;\n);
//: print("output client${i}2mcif_rd_req_ready;\n");
//: print("output mcif2client${i}_rd_rsp_valid;\n");
//: print("input mcif2client${i}_rd_rsp_ready;\n");
//: print qq(output [NVDLA_DMA_RD_RSP-1:0] mcif2client${i}_rd_rsp_pd;\n);
//: print("input [7:0] client${i}2mcif_lat_fifo_depth;\n");
//: print("input [3:0] client${i}2mcif_rd_axid;\n");
//: }

//:my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//:my $i = 0;
//:for ($i=0;$i<$k;$i++) {
//: print qq(input [NVDLA_DMA_WR_REQ-1:0] client${i}2mcif_wr_req_pd;\n);
//: print("input client${i}2mcif_wr_req_valid;\n");
//: print("output client${i}2mcif_wr_req_ready;\n");
//: print("output mcif2client${i}_wr_rsp_complete;\n");
//: print("input [3:0] client${i}2mcif_wr_axid;\n");
//: }
#else

//: my @rdma_name = RDMA_NAME; 
//: foreach my $client (@rdma_name) {
//: print ("input  ${client}2mcif_rd_cdt_lat_fifo_pop;\n");
//: print ("input  ${client}2mcif_rd_req_valid;\n");
//: print ("output ${client}2mcif_rd_req_ready;\n");
//: print qq(input  [NVDLA_DMA_RD_REQ-1:0] ${client}2mcif_rd_req_pd;\n);
//: print ("output mcif2${client}_rd_rsp_valid;\n");
//: print ("input  mcif2${client}_rd_rsp_ready;\n");
//: print qq(output [NVDLA_DMA_RD_RSP-1:0] mcif2${client}_rd_rsp_pd;\n);
//: }
//: my @wdma_name = WDMA_NAME; 
//: foreach my $client (@wdma_name) {
//: print ("input  ${client}2mcif_wr_req_valid;\n");
//: print ("output ${client}2mcif_wr_req_ready;\n");
//: print qq(input  [NVDLA_DMA_WR_REQ-1:0] ${client}2mcif_wr_req_pd;\n);
//: print ("output mcif2${client}_wr_rsp_complete;\n");
//: }
#endif

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
//: my @rdma_name = RDMA_NAME; 
//: foreach my $client (@rdma_name) {
//: print ("input  ${client}2cvif_rd_cdt_lat_fifo_pop;\n");
//: print ("input  ${client}2cvif_rd_req_valid;\n");
//: print ("output ${client}2cvif_rd_req_ready;\n");
//: print qq(input  [NVDLA_DMA_RD_REQ-1:0] ${client}2cvif_rd_req_pd;\n);
//: print ("output cvif2${client}_rd_rsp_valid;\n");
//: print ("input  cvif2${client}_rd_rsp_ready;\n");
//: print qq(output [NVDLA_DMA_RD_RSP-1:0] cvif2${client}_rd_rsp_pd;\n);
//: }
//: my @wdma_name = WDMA_NAME; 
//: foreach my $client (@wdma_name) {
//: print ("input  ${client}2cvif_wr_req_valid;\n");
//: print ("output ${client}2cvif_wr_req_ready;\n");
//: print qq(input  [NVDLA_DMA_WR_REQ-1:0] ${client}2cvif_wr_req_pd;\n);
//: print ("output cvif2${client}_wr_rsp_complete;\n");
//: }
#endif



input         nvdla_core_clk;
input         nvdla_core_rstn; 
input  [31:0] pwrbus_ram_pd;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
input         csb2cvif_req_pvld;  /* data valid */
output        csb2cvif_req_prdy;  /* data return handshake */
input  [62:0] csb2cvif_req_pd;
output [33:0] cvif2csb_resp_pd;
output        cvif2csb_resp_valid;

output        cvif2noc_axi_ar_arvalid;  /* data valid */
input         cvif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] cvif2noc_axi_ar_arid;
output  [3:0] cvif2noc_axi_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] cvif2noc_axi_ar_araddr;

output        cvif2noc_axi_aw_awvalid;  /* data valid */
input         cvif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] cvif2noc_axi_aw_awid;
output  [3:0] cvif2noc_axi_aw_awlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] cvif2noc_axi_aw_awaddr;

output         cvif2noc_axi_w_wvalid;  /* data valid */
input          cvif2noc_axi_w_wready;  /* data return handshake */
output [NVDLA_SECONDARY_MEMIF_WIDTH-1:0] cvif2noc_axi_w_wdata;
output  [NVDLA_SECONDARY_MEMIF_WIDTH/8-1:0] cvif2noc_axi_w_wstrb;
output         cvif2noc_axi_w_wlast;
input        noc2cvif_axi_b_bvalid;  /* data valid */
output       noc2cvif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2cvif_axi_b_bid;

input          noc2cvif_axi_r_rvalid;  /* data valid */
output         noc2cvif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2cvif_axi_r_rid;
input          noc2cvif_axi_r_rlast;
input  [NVDLA_SECONDARY_MEMIF_WIDTH-1:0] noc2cvif_axi_r_rdata;
#endif

input         csb2mcif_req_pvld;  /* data valid */
output        csb2mcif_req_prdy;  /* data return handshake */
input  [62:0] csb2mcif_req_pd;
output        mcif2csb_resp_valid;  /* data valid */
output [33:0] mcif2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        mcif2noc_axi_ar_arvalid;  /* data valid */
input         mcif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_ar_araddr;

output        mcif2noc_axi_aw_awvalid;  /* data valid */
input         mcif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] mcif2noc_axi_aw_awid;
output  [3:0] mcif2noc_axi_aw_awlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_aw_awaddr;

output         mcif2noc_axi_w_wvalid;  /* data valid */
input          mcif2noc_axi_w_wready;  /* data return handshake */
output [NVDLA_PRIMARY_MEMIF_WIDTH-1:0] mcif2noc_axi_w_wdata;
output  [NVDLA_PRIMARY_MEMIF_WIDTH/8-1:0] mcif2noc_axi_w_wstrb;
output         mcif2noc_axi_w_wlast;
input        noc2mcif_axi_b_bvalid;  /* data valid */
output       noc2mcif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2mcif_axi_b_bid;

input          noc2mcif_axi_r_rvalid;  /* data valid */
output         noc2mcif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2mcif_axi_r_rid;
input          noc2mcif_axi_r_rlast;
input  [NVDLA_PRIMARY_MEMIF_WIDTH-1:0] noc2mcif_axi_r_rdata;



#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
#ifdef CVIF_MCIF_DIFF
NV_NVDLA_cvif   u_NV_NVDLA_cvif (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
#ifdef NVDLA_BDMA_ENABLE
  ,.bdma2cvif_rd_cdt_lat_fifo_pop  (bdma2cvif_rd_cdt_lat_fifo_pop)  //|< w
  ,.bdma2cvif_rd_req_valid         (bdma2cvif_rd_req_valid)         //|< w
  ,.bdma2cvif_rd_req_ready         (bdma2cvif_rd_req_ready)         //|> w
  ,.bdma2cvif_rd_req_pd            (bdma2cvif_rd_req_pd)      //|< w
  ,.bdma2cvif_wr_req_valid         (bdma2cvif_wr_req_valid)         //|< w
  ,.bdma2cvif_wr_req_ready         (bdma2cvif_wr_req_ready)         //|> w
  ,.bdma2cvif_wr_req_pd            (bdma2cvif_wr_req_pd       )     //|< w
  ,.cvif2bdma_rd_rsp_valid         (cvif2bdma_rd_rsp_valid)         //|> w
  ,.cvif2bdma_rd_rsp_ready         (cvif2bdma_rd_rsp_ready)         //|< w
  ,.cvif2bdma_rd_rsp_pd            (cvif2bdma_rd_rsp_pd       )     //|> w
  ,.cvif2bdma_wr_rsp_complete      (cvif2bdma_wr_rsp_complete)      //|> w
#endif
  ,.cdma_dat2cvif_rd_cdt_lat_fifo_pop     (cdma_dat2cvif_rd_cdt_lat_fifo_pop)     //|< i
  ,.cdma_dat2cvif_rd_req_valid     (cdma_dat2cvif_rd_req_valid)     //|< i
  ,.cdma_dat2cvif_rd_req_ready     (cdma_dat2cvif_rd_req_ready)     //|> o
  ,.cdma_dat2cvif_rd_req_pd        (cdma_dat2cvif_rd_req_pd      )  //|< i
  ,.cdma_wt2cvif_rd_cdt_lat_fifo_pop      (cdma_wt2cvif_rd_cdt_lat_fifo_pop)      //|< i
  ,.cdma_wt2cvif_rd_req_valid      (cdma_wt2cvif_rd_req_valid)      //|< i
  ,.cdma_wt2cvif_rd_req_ready      (cdma_wt2cvif_rd_req_ready)      //|> o
  ,.cdma_wt2cvif_rd_req_pd         (cdma_wt2cvif_rd_req_pd      )   //|< i
#ifdef NVDLA_CDP_ENABLE
  ,.cdp2cvif_rd_cdt_lat_fifo_pop   (cdp2cvif_rd_cdt_lat_fifo_pop)   //|< w
  ,.cdp2cvif_rd_req_valid          (cdp2cvif_rd_req_valid)          //|< w
  ,.cdp2cvif_rd_req_ready          (cdp2cvif_rd_req_ready)          //|> w
  ,.cdp2cvif_rd_req_pd             (cdp2cvif_rd_req_pd      )       //|< w
  ,.cdp2cvif_wr_req_valid          (cdp2cvif_wr_req_valid)          //|< w
  ,.cdp2cvif_wr_req_ready          (cdp2cvif_wr_req_ready)          //|> w
  ,.cdp2cvif_wr_req_pd             (cdp2cvif_wr_req_pd       )      //|< w
  ,.cvif2cdp_rd_rsp_valid          (cvif2cdp_rd_rsp_valid)          //|> w
  ,.cvif2cdp_rd_rsp_ready          (cvif2cdp_rd_rsp_ready)          //|< w
  ,.cvif2cdp_rd_rsp_pd             (cvif2cdp_rd_rsp_pd       )      //|> w
  ,.cvif2cdp_wr_rsp_complete       (cvif2cdp_wr_rsp_complete)       //|> w
#endif
  ,.csb2cvif_req_pvld              (csb2cvif_req_pvld)              //|< w
  ,.csb2cvif_req_prdy              (csb2cvif_req_prdy)              //|> w
  ,.csb2cvif_req_pd                (csb2cvif_req_pd[62:0])          //|< w
  ,.cvif2cdma_dat_rd_rsp_valid     (cvif2cdma_dat_rd_rsp_valid)     //|> o
  ,.cvif2cdma_dat_rd_rsp_ready     (cvif2cdma_dat_rd_rsp_ready)     //|< i
  ,.cvif2cdma_dat_rd_rsp_pd        (cvif2cdma_dat_rd_rsp_pd       ) //|> o
  ,.cvif2cdma_wt_rd_rsp_valid      (cvif2cdma_wt_rd_rsp_valid)      //|> o
  ,.cvif2cdma_wt_rd_rsp_ready      (cvif2cdma_wt_rd_rsp_ready)      //|< i
  ,.cvif2cdma_wt_rd_rsp_pd         (cvif2cdma_wt_rd_rsp_pd       )  //|> o
  ,.cvif2csb_resp_valid            (cvif2csb_resp_valid)            //|> w
  ,.cvif2csb_resp_pd               (cvif2csb_resp_pd[33:0])         //|> w
  ,.cvif2noc_axi_ar_arvalid        (cvif2noc_axi_ar_arvalid)        //|> o
  ,.cvif2noc_axi_ar_arready        (cvif2noc_axi_ar_arready)        //|< i
  ,.cvif2noc_axi_ar_arid           (cvif2noc_axi_ar_arid[7:0])      //|> o
  ,.cvif2noc_axi_ar_arlen          (cvif2noc_axi_ar_arlen[3:0])     //|> o
  ,.cvif2noc_axi_ar_araddr         (cvif2noc_axi_ar_araddr      )   //|> o
  ,.cvif2noc_axi_aw_awvalid        (cvif2noc_axi_aw_awvalid)        //|> o
  ,.cvif2noc_axi_aw_awready        (cvif2noc_axi_aw_awready)        //|< i
  ,.cvif2noc_axi_aw_awid           (cvif2noc_axi_aw_awid[7:0])      //|> o
  ,.cvif2noc_axi_aw_awlen          (cvif2noc_axi_aw_awlen[3:0])     //|> o
  ,.cvif2noc_axi_aw_awaddr         (cvif2noc_axi_aw_awaddr      )   //|> o
  ,.cvif2noc_axi_w_wvalid          (cvif2noc_axi_w_wvalid)          //|> o
  ,.cvif2noc_axi_w_wready          (cvif2noc_axi_w_wready)          //|< i
  ,.cvif2noc_axi_w_wdata           (cvif2noc_axi_w_wdata       )    //|> o
  ,.cvif2noc_axi_w_wstrb           (cvif2noc_axi_w_wstrb      )     //|> o
  ,.cvif2noc_axi_w_wlast           (cvif2noc_axi_w_wlast)           //|> o
#ifdef NVDLA_PDP_ENABLE
  ,.cvif2pdp_rd_rsp_valid          (cvif2pdp_rd_rsp_valid)          //|> w
  ,.cvif2pdp_rd_rsp_ready          (cvif2pdp_rd_rsp_ready)       //|< w
  ,.cvif2pdp_rd_rsp_pd             (cvif2pdp_rd_rsp_pd       )      //|> w
  ,.cvif2pdp_wr_rsp_complete       (cvif2pdp_wr_rsp_complete)       //|> w
  ,.pdp2cvif_rd_cdt_lat_fifo_pop   (pdp2cvif_rd_cdt_lat_fifo_pop)   //|> w
  ,.pdp2cvif_rd_req_valid          (pdp2cvif_rd_req_valid)          //|> w
  ,.pdp2cvif_rd_req_ready          (pdp2cvif_rd_req_ready)          //|> w
  ,.pdp2cvif_rd_req_pd             (pdp2cvif_rd_req_pd      )       //|> w
  ,.pdp2cvif_wr_req_valid          (pdp2cvif_wr_req_valid)          //|> w
  ,.pdp2cvif_wr_req_ready          (pdp2cvif_wr_req_ready)          //|> w
  ,.pdp2cvif_wr_req_pd             (pdp2cvif_wr_req_pd       )      //|> w
#endif
#ifdef NVDLA_SDP_BS_ENABLE
  ,.cvif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)        //|> o
  ,.cvif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)        //|< i
  ,.cvif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd       )    //|> o
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)        //|> o
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)        //|< i
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd       )    //|> o
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  ,.cvif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)        //|> o
  ,.cvif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)        //|< i
  ,.cvif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd       )    //|> o
#endif
  ,.cvif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)          //|> o
  ,.cvif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)          //|< i
  ,.cvif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd       )      //|> o
  ,.cvif2sdp_wr_rsp_complete       (cvif2sdp_wr_rsp_complete)       //|> o
  ,.noc2cvif_axi_b_bvalid          (noc2cvif_axi_b_bvalid)          //|< i
  ,.noc2cvif_axi_b_bready          (noc2cvif_axi_b_bready)          //|> o
  ,.noc2cvif_axi_b_bid             (noc2cvif_axi_b_bid[7:0])        //|< i
  ,.noc2cvif_axi_r_rvalid          (noc2cvif_axi_r_rvalid)          //|< i
  ,.noc2cvif_axi_r_rready          (noc2cvif_axi_r_rready)          //|> o
  ,.noc2cvif_axi_r_rid             (noc2cvif_axi_r_rid[7:0])        //|< i
  ,.noc2cvif_axi_r_rlast           (noc2cvif_axi_r_rlast)           //|< i
  ,.noc2cvif_axi_r_rdata           (noc2cvif_axi_r_rdata       )    //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
#ifdef NVDLA_RUBIK_ENABLE 
  ,.rbk2cvif_rd_cdt_lat_fifo_pop   (rbk2cvif_rd_cdt_lat_fifo_pop)   //|< w
  ,.rbk2cvif_rd_req_valid          (rbk2cvif_rd_req_valid)          //|< w
  ,.rbk2cvif_rd_req_ready          (rbk2cvif_rd_req_ready)          //|> w
  ,.rbk2cvif_rd_req_pd             (rbk2cvif_rd_req_pd      )       //|< w
  ,.rbk2cvif_wr_req_valid          (rbk2cvif_wr_req_valid)          //|< w
  ,.rbk2cvif_wr_req_ready          (rbk2cvif_wr_req_ready)          //|> w
  ,.rbk2cvif_wr_req_pd             (rbk2cvif_wr_req_pd       )      //|< w
  ,.cvif2rbk_rd_rsp_valid          (cvif2rbk_rd_rsp_valid)          //|> w
  ,.cvif2rbk_rd_rsp_ready          (cvif2rbk_rd_rsp_ready)          //|< w
  ,.cvif2rbk_rd_rsp_pd             (cvif2rbk_rd_rsp_pd       )      //|> w
  ,.cvif2rbk_wr_rsp_complete       (cvif2rbk_wr_rsp_complete)       //|> w
#endif
  ,.sdp2cvif_rd_cdt_lat_fifo_pop   (sdp2cvif_rd_cdt_lat_fifo_pop)   //|< i
  ,.sdp2cvif_rd_req_valid          (sdp2cvif_rd_req_valid)          //|< i
  ,.sdp2cvif_rd_req_ready          (sdp2cvif_rd_req_ready)          //|> o
  ,.sdp2cvif_rd_req_pd             (sdp2cvif_rd_req_pd      )       //|< i
  ,.sdp2cvif_wr_req_valid          (sdp2cvif_wr_req_valid)          //|< i
  ,.sdp2cvif_wr_req_ready          (sdp2cvif_wr_req_ready)          //|> o
  ,.sdp2cvif_wr_req_pd             (sdp2cvif_wr_req_pd       )      //|< i
#ifdef NVDLA_SDP_BS_ENABLE
  ,.sdp_b2cvif_rd_cdt_lat_fifo_pop (sdp_b2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_b2cvif_rd_req_valid        (sdp_b2cvif_rd_req_valid)        //|< i
  ,.sdp_b2cvif_rd_req_ready        (sdp_b2cvif_rd_req_ready)        //|> o
  ,.sdp_b2cvif_rd_req_pd           (sdp_b2cvif_rd_req_pd      )     //|< i
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_e2cvif_rd_req_valid        (sdp_e2cvif_rd_req_valid)        //|< i
  ,.sdp_e2cvif_rd_req_ready        (sdp_e2cvif_rd_req_ready)        //|> o
  ,.sdp_e2cvif_rd_req_pd           (sdp_e2cvif_rd_req_pd      )     //|< i
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  ,.sdp_n2cvif_rd_cdt_lat_fifo_pop (sdp_n2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_n2cvif_rd_req_valid        (sdp_n2cvif_rd_req_valid)        //|< i
  ,.sdp_n2cvif_rd_req_ready        (sdp_n2cvif_rd_req_ready)        //|> o
  ,.sdp_n2cvif_rd_req_pd           (sdp_n2cvif_rd_req_pd      )     //|< i
#endif
  );

#else 
   NV_NVDLA_mcif   u_NV_NVDLA_cvif (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.csb2mcif_req_pvld              (csb2cvif_req_pvld)              //|< w
  ,.csb2mcif_req_prdy              (csb2cvif_req_prdy)              //|> w
  ,.csb2mcif_req_pd                (csb2cvif_req_pd[62:0])          //|< w
  ,.mcif2csb_resp_valid            (cvif2csb_resp_valid)            //|> w
  ,.mcif2csb_resp_pd               (cvif2csb_resp_pd[33:0])         //|> w
  ,.cdma_dat2mcif_rd_cdt_lat_fifo_pop (1'b0)      
  ,.cdma_dat2mcif_rd_req_valid     (cdma_dat2cvif_rd_req_valid)     //|< i
  ,.cdma_dat2mcif_rd_req_ready     (cdma_dat2cvif_rd_req_ready)     //|> o
  ,.cdma_dat2mcif_rd_req_pd        (cdma_dat2cvif_rd_req_pd      )  //|< i
  ,.mcif2cdma_dat_rd_rsp_valid     (cvif2cdma_dat_rd_rsp_valid)     //|> o
  ,.mcif2cdma_dat_rd_rsp_ready     (cvif2cdma_dat_rd_rsp_ready)     //|< i
  ,.mcif2cdma_dat_rd_rsp_pd        (cvif2cdma_dat_rd_rsp_pd       ) //|> o
  ,.cdma_wt2mcif_rd_cdt_lat_fifo_pop  (1'b0)      
  ,.cdma_wt2mcif_rd_req_valid      (cdma_wt2cvif_rd_req_valid)      //|< i
  ,.cdma_wt2mcif_rd_req_ready      (cdma_wt2cvif_rd_req_ready)      //|> o
  ,.cdma_wt2mcif_rd_req_pd         (cdma_wt2cvif_rd_req_pd      )   //|< i
  ,.mcif2cdma_wt_rd_rsp_valid      (cvif2cdma_wt_rd_rsp_valid)      //|> o
  ,.mcif2cdma_wt_rd_rsp_ready      (cvif2cdma_wt_rd_rsp_ready)      //|< i
  ,.mcif2cdma_wt_rd_rsp_pd         (cvif2cdma_wt_rd_rsp_pd       )  //|> o
  ,.sdp2mcif_rd_cdt_lat_fifo_pop   (sdp2cvif_rd_cdt_lat_fifo_pop)   //|< i
  ,.sdp2mcif_rd_req_valid          (sdp2cvif_rd_req_valid)          //|< i
  ,.sdp2mcif_rd_req_ready          (sdp2cvif_rd_req_ready)          //|> o
  ,.sdp2mcif_rd_req_pd             (sdp2cvif_rd_req_pd      )       //|< i
  ,.mcif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)          //|> o
  ,.mcif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)          //|< i
  ,.mcif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd       )      //|> o
  ,.sdp2mcif_wr_req_valid          (sdp2cvif_wr_req_valid)          //|< i
  ,.sdp2mcif_wr_req_ready          (sdp2cvif_wr_req_ready)          //|> o
  ,.sdp2mcif_wr_req_pd             (sdp2cvif_wr_req_pd       )      //|< i
  ,.mcif2sdp_wr_rsp_complete       (cvif2sdp_wr_rsp_complete)       //|> o
#ifdef NVDLA_CDP_ENABLE
  ,.cdp2mcif_rd_cdt_lat_fifo_pop   (cdp2cvif_rd_cdt_lat_fifo_pop)   //|< w
  ,.cdp2mcif_rd_req_valid          (cdp2cvif_rd_req_valid)          //|< w
  ,.cdp2mcif_rd_req_ready          (cdp2cvif_rd_req_ready)          //|> w
  ,.cdp2mcif_rd_req_pd             (cdp2cvif_rd_req_pd      )       //|< w
  ,.cdp2mcif_wr_req_valid          (cdp2cvif_wr_req_valid)          //|< w
  ,.cdp2mcif_wr_req_ready          (cdp2cvif_wr_req_ready)          //|> w
  ,.cdp2mcif_wr_req_pd             (cdp2cvif_wr_req_pd       )      //|< w
  ,.mcif2cdp_rd_rsp_valid          (cvif2cdp_rd_rsp_valid)          //|> w
  ,.mcif2cdp_rd_rsp_ready          (cvif2cdp_rd_rsp_ready)          //|< w
  ,.mcif2cdp_rd_rsp_pd             (cvif2cdp_rd_rsp_pd       )      //|> w
  ,.mcif2cdp_wr_rsp_complete       (cvif2cdp_wr_rsp_complete)       //|> w
#endif
#ifdef NVDLA_PDP_ENABLE
  ,.mcif2pdp_rd_rsp_valid          (cvif2pdp_rd_rsp_valid)          //|> w
  ,.mcif2pdp_rd_rsp_ready          (cvif2pdp_rd_rsp_ready)       //|< w
  ,.mcif2pdp_rd_rsp_pd             (cvif2pdp_rd_rsp_pd       )      //|> w
  ,.mcif2pdp_wr_rsp_complete       (cvif2pdp_wr_rsp_complete)       //|> w
  ,.pdp2mcif_rd_cdt_lat_fifo_pop   (pdp2cvif_rd_cdt_lat_fifo_pop)   //|> w
  ,.pdp2mcif_rd_req_valid          (pdp2cvif_rd_req_valid)          //|> w
  ,.pdp2mcif_rd_req_ready          (pdp2cvif_rd_req_ready)          //|> w
  ,.pdp2mcif_rd_req_pd             (pdp2cvif_rd_req_pd      )       //|> w
  ,.pdp2mcif_wr_req_valid          (pdp2cvif_wr_req_valid)          //|> w
  ,.pdp2mcif_wr_req_ready          (pdp2cvif_wr_req_ready)          //|> w
  ,.pdp2mcif_wr_req_pd             (pdp2cvif_wr_req_pd       )      //|> w
#endif
#ifdef NVDLA_SDP_BS_ENABLE
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop (sdp_b2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_b2mcif_rd_req_valid        (sdp_b2cvif_rd_req_valid)        //|< i
  ,.sdp_b2mcif_rd_req_ready        (sdp_b2cvif_rd_req_ready)        //|> o
  ,.sdp_b2mcif_rd_req_pd           (sdp_b2cvif_rd_req_pd      )     //|< i
  ,.mcif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)        //|> o
  ,.mcif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)        //|< i
  ,.mcif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd       )    //|> o
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2cvif_rd_req_valid)        //|< i
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2cvif_rd_req_ready)        //|> o
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2cvif_rd_req_pd      )     //|< i
  ,.mcif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)        //|> o
  ,.mcif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)        //|< i
  ,.mcif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd       )    //|> o
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop (sdp_n2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_n2mcif_rd_req_valid        (sdp_n2cvif_rd_req_valid)        //|< i
  ,.sdp_n2mcif_rd_req_ready        (sdp_n2cvif_rd_req_ready)        //|> o
  ,.sdp_n2mcif_rd_req_pd           (sdp_n2cvif_rd_req_pd      )     //|< i
  ,.mcif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)        //|> o
  ,.mcif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)        //|< i
  ,.mcif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd       )    //|> o
#endif
#ifdef NVDLA_RUBIK_ENABLE 
  ,.rbk2mcif_rd_cdt_lat_fifo_pop   (rbk2cvif_rd_cdt_lat_fifo_pop)   //|< w
  ,.rbk2mcif_rd_req_valid          (rbk2cvif_rd_req_valid)          //|< w
  ,.rbk2mcif_rd_req_ready          (rbk2cvif_rd_req_ready)          //|> w
  ,.rbk2mcif_rd_req_pd             (rbk2cvif_rd_req_pd      )       //|< w
  ,.rbk2mcif_wr_req_valid          (rbk2cvif_wr_req_valid)          //|< w
  ,.rbk2mcif_wr_req_ready          (rbk2cvif_wr_req_ready)          //|> w
  ,.rbk2mcif_wr_req_pd             (rbk2cvif_wr_req_pd       )      //|< w
  ,.mcif2rbk_rd_rsp_valid          (cvif2rbk_rd_rsp_valid)          //|> w
  ,.mcif2rbk_rd_rsp_ready          (cvif2rbk_rd_rsp_ready)          //|< w
  ,.mcif2rbk_rd_rsp_pd             (cvif2rbk_rd_rsp_pd       )      //|> w
  ,.mcif2rbk_wr_rsp_complete       (cvif2rbk_wr_rsp_complete)       //|> w
#endif
#ifdef NVDLA_BDMA_ENABLE
  ,.bdma2mcif_rd_cdt_lat_fifo_pop  (bdma2cvif_rd_cdt_lat_fifo_pop)  //|< w
  ,.bdma2mcif_rd_req_valid         (bdma2cvif_rd_req_valid)         //|< w
  ,.bdma2mcif_rd_req_ready         (bdma2cvif_rd_req_ready)         //|> w
  ,.bdma2mcif_rd_req_pd            (bdma2cvif_rd_req_pd)            //|< w
  ,.bdma2mcif_wr_req_valid         (bdma2cvif_wr_req_valid)         //|< w
  ,.bdma2mcif_wr_req_ready         (bdma2cvif_wr_req_ready)         //|> w
  ,.bdma2mcif_wr_req_pd            (bdma2cvif_wr_req_pd       )     //|< w
  ,.mcif2bdma_rd_rsp_valid         (cvif2bdma_rd_rsp_valid)         //|> w
  ,.mcif2bdma_rd_rsp_ready         (cvif2bdma_rd_rsp_ready)         //|< w
  ,.mcif2bdma_rd_rsp_pd            (cvif2bdma_rd_rsp_pd       )     //|> w
  ,.mcif2bdma_wr_rsp_complete      (cvif2bdma_wr_rsp_complete)      //|> w
#endif
  ,.mcif2noc_axi_ar_arvalid        (cvif2noc_axi_ar_arvalid)        //|> o
  ,.mcif2noc_axi_ar_arready        (cvif2noc_axi_ar_arready)        //|< i
  ,.mcif2noc_axi_ar_arid           (cvif2noc_axi_ar_arid[7:0])      //|> o
  ,.mcif2noc_axi_ar_arlen          (cvif2noc_axi_ar_arlen[3:0])     //|> o
  ,.mcif2noc_axi_ar_araddr         (cvif2noc_axi_ar_araddr      )   //|> o
  ,.noc2mcif_axi_r_rvalid          (noc2cvif_axi_r_rvalid)          //|< i
  ,.noc2mcif_axi_r_rready          (noc2cvif_axi_r_rready)          //|> o
  ,.noc2mcif_axi_r_rid             (noc2cvif_axi_r_rid[7:0])        //|< i
  ,.noc2mcif_axi_r_rlast           (noc2cvif_axi_r_rlast)           //|< i
  ,.noc2mcif_axi_r_rdata           (noc2cvif_axi_r_rdata       )    //|< i
  ,.mcif2noc_axi_aw_awvalid        (cvif2noc_axi_aw_awvalid)        //|> o
  ,.mcif2noc_axi_aw_awready        (cvif2noc_axi_aw_awready)        //|< i
  ,.mcif2noc_axi_aw_awid           (cvif2noc_axi_aw_awid[7:0])      //|> o
  ,.mcif2noc_axi_aw_awlen          (cvif2noc_axi_aw_awlen[3:0])     //|> o
  ,.mcif2noc_axi_aw_awaddr         (cvif2noc_axi_aw_awaddr      )   //|> o
  ,.mcif2noc_axi_w_wvalid          (cvif2noc_axi_w_wvalid)          //|> o
  ,.mcif2noc_axi_w_wready          (cvif2noc_axi_w_wready)          //|< i
  ,.mcif2noc_axi_w_wdata           (cvif2noc_axi_w_wdata       )    //|> o
  ,.mcif2noc_axi_w_wstrb           (cvif2noc_axi_w_wstrb      )     //|> o
  ,.mcif2noc_axi_w_wlast           (cvif2noc_axi_w_wlast)           //|> o
  ,.noc2mcif_axi_b_bvalid          (noc2cvif_axi_b_bvalid)          //|< i
  ,.noc2mcif_axi_b_bready          (noc2cvif_axi_b_bready)          //|> o
  ,.noc2mcif_axi_b_bid             (noc2cvif_axi_b_bid[7:0])        //|< i
  );
#endif
#endif



#ifdef  SEKHAR_MCIF
NV_NVDLA_NOCIF_dram u_dram (
    .nvdla_core_clk(nvdla_core_clk)
    ,.nvdla_core_rstn(nvdla_core_rstn)
    ,.pwrbus_ram_pd (pwrbus_ram_pd)
    ,.csb2mcif_req_pvld   (csb2mcif_req_pvld)              //|< i
    ,.csb2mcif_req_prdy   (csb2mcif_req_prdy)              //|> o
    ,.csb2mcif_req_pd     (csb2mcif_req_pd[62:0])          //|< i
    ,.mcif2csb_resp_valid (mcif2csb_resp_valid)            //|> o
    ,.mcif2csb_resp_pd    (mcif2csb_resp_pd[33:0])         //|> o
//: my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,.client${i}2mcif_rd_cdt_lat_fifo_pop(client${i}2mcif_rd_cdt_lat_fifo_pop)\n");
//: print("  ,.client${i}2mcif_rd_req_valid(client${i}2mcif_rd_req_valid)\n");
//: print("  ,.client${i}2mcif_rd_req_pd(client${i}2mcif_rd_req_pd)\n");
//: print("  ,.client${i}2mcif_rd_req_ready(client${i}2mcif_rd_req_ready)\n");
//: print("  ,.mcif2client${i}_rd_rsp_valid(mcif2client${i}_rd_rsp_valid)\n");
//: print("  ,.mcif2client${i}_rd_rsp_ready(mcif2client${i}_rd_rsp_ready)\n");
//: print("  ,.mcif2client${i}_rd_rsp_pd(mcif2client${i}_rd_rsp_pd)\n");
//: print("  ,.client${i}2mcif_rd_axid(client${i}2mcif_rd_axid)\n");
//: print("  ,.client${i}2mcif_lat_fifo_depth(client${i}2mcif_lat_fifo_depth)\n");
//: }
//: my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,.client${i}2mcif_wr_req_pd(client${i}2mcif_wr_req_pd)\n");
//: print("  ,.client${i}2mcif_wr_req_valid(client${i}2mcif_wr_req_valid)\n");
//: print("  ,.client${i}2mcif_wr_req_ready(client${i}2mcif_wr_req_ready)\n");
//: print("  ,.mcif2client${i}_wr_rsp_complete(mcif2client${i}_wr_rsp_complete)\n");
//: print("  ,.client${i}2mcif_wr_axid(client${i}2mcif_wr_axid)\n");
//: }
  ,.noc2mcif_axi_b_bid(noc2mcif_axi_b_bid             )             //|< i
  ,.noc2mcif_axi_b_bvalid(noc2mcif_axi_b_bvalid          )          //|< i
  ,.noc2mcif_axi_r_rdata(noc2mcif_axi_r_rdata           )           //|< i
  ,.noc2mcif_axi_r_rid(noc2mcif_axi_r_rid             )             //|< i
  ,.noc2mcif_axi_r_rlast(noc2mcif_axi_r_rlast           )           //|< i
  ,.noc2mcif_axi_r_rvalid(noc2mcif_axi_r_rvalid          )          //|< i
  ,.mcif2noc_axi_ar_arready(mcif2noc_axi_ar_arready        )        //|< i
  ,.mcif2noc_axi_aw_awready(mcif2noc_axi_aw_awready        )        //|< i
  ,.mcif2noc_axi_w_wready(mcif2noc_axi_w_wready          )          //|< i
  ,.mcif2noc_axi_ar_araddr(mcif2noc_axi_ar_araddr         )         //|> o
  ,.mcif2noc_axi_ar_arid(mcif2noc_axi_ar_arid           )           //|> o
  ,.mcif2noc_axi_ar_arlen(mcif2noc_axi_ar_arlen          )          //|> o
  ,.mcif2noc_axi_ar_arvalid(mcif2noc_axi_ar_arvalid        )        //|> o
  ,.mcif2noc_axi_aw_awaddr(mcif2noc_axi_aw_awaddr         )         //|> o
  ,.mcif2noc_axi_aw_awid(mcif2noc_axi_aw_awid           )           //|> o
  ,.mcif2noc_axi_aw_awlen(mcif2noc_axi_aw_awlen          )          //|> o
  ,.mcif2noc_axi_aw_awvalid(mcif2noc_axi_aw_awvalid        )        //|> o
  ,.mcif2noc_axi_w_wdata(mcif2noc_axi_w_wdata           )           //|> o
  ,.mcif2noc_axi_w_wlast(mcif2noc_axi_w_wlast           )           //|> o
  ,.mcif2noc_axi_w_wstrb(mcif2noc_axi_w_wstrb           )           //|> o
  ,.mcif2noc_axi_w_wvalid(mcif2noc_axi_w_wvalid          )          //|> o
  ,.noc2mcif_axi_b_bready(noc2mcif_axi_b_bready          )          //|> o
  ,.noc2mcif_axi_r_rready(noc2mcif_axi_r_rready          )          //|> o
);

#else
  NV_NVDLA_mcif   u_NV_NVDLA_mcif (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
#ifdef NVDLA_BDMA_ENABLE
  ,.bdma2mcif_rd_cdt_lat_fifo_pop  (bdma2mcif_rd_cdt_lat_fifo_pop)  //|< w
  ,.bdma2mcif_rd_req_valid         (bdma2mcif_rd_req_valid)         //|< w
  ,.bdma2mcif_rd_req_ready         (bdma2mcif_rd_req_ready)         //|> w
  ,.bdma2mcif_rd_req_pd            (bdma2mcif_rd_req_pd)      //|< w
  ,.bdma2mcif_wr_req_valid         (bdma2mcif_wr_req_valid)         //|< w
  ,.bdma2mcif_wr_req_ready         (bdma2mcif_wr_req_ready)         //|> w
  ,.bdma2mcif_wr_req_pd            (bdma2mcif_wr_req_pd       )     //|< w
  ,.mcif2bdma_rd_rsp_valid         (mcif2bdma_rd_rsp_valid)         //|> w
  ,.mcif2bdma_rd_rsp_ready         (mcif2bdma_rd_rsp_ready)         //|< w
  ,.mcif2bdma_rd_rsp_pd            (mcif2bdma_rd_rsp_pd       )     //|> w
  ,.mcif2bdma_wr_rsp_complete      (mcif2bdma_wr_rsp_complete)      //|> w
#endif
  ,.cdma_dat2mcif_rd_cdt_lat_fifo_pop     (cdma_dat2mcif_rd_cdt_lat_fifo_pop)     //|< i
  ,.cdma_dat2mcif_rd_req_valid     (cdma_dat2mcif_rd_req_valid)     //|< i
  ,.cdma_dat2mcif_rd_req_ready     (cdma_dat2mcif_rd_req_ready)     //|> o
  ,.cdma_dat2mcif_rd_req_pd        (cdma_dat2mcif_rd_req_pd      )  //|< i
  ,.cdma_wt2mcif_rd_cdt_lat_fifo_pop      (cdma_wt2mcif_rd_cdt_lat_fifo_pop)      //|< i
  ,.cdma_wt2mcif_rd_req_valid      (cdma_wt2mcif_rd_req_valid)      //|< i
  ,.cdma_wt2mcif_rd_req_ready      (cdma_wt2mcif_rd_req_ready)      //|> o
  ,.cdma_wt2mcif_rd_req_pd         (cdma_wt2mcif_rd_req_pd      )   //|< i
#ifdef NVDLA_CDP_ENABLE
  ,.cdp2mcif_rd_cdt_lat_fifo_pop   (cdp2mcif_rd_cdt_lat_fifo_pop)   //|< w
  ,.cdp2mcif_rd_req_valid          (cdp2mcif_rd_req_valid)          //|< w
  ,.cdp2mcif_rd_req_ready          (cdp2mcif_rd_req_ready)          //|> w
  ,.cdp2mcif_rd_req_pd             (cdp2mcif_rd_req_pd      )       //|< w
  ,.cdp2mcif_wr_req_valid          (cdp2mcif_wr_req_valid)          //|< w
  ,.cdp2mcif_wr_req_ready          (cdp2mcif_wr_req_ready)          //|> w
  ,.cdp2mcif_wr_req_pd             (cdp2mcif_wr_req_pd       )      //|< w
  ,.mcif2cdp_rd_rsp_valid          (mcif2cdp_rd_rsp_valid)          //|> w
  ,.mcif2cdp_rd_rsp_ready          (mcif2cdp_rd_rsp_ready)          //|< w
  ,.mcif2cdp_rd_rsp_pd             (mcif2cdp_rd_rsp_pd       )      //|> w
  ,.mcif2cdp_wr_rsp_complete       (mcif2cdp_wr_rsp_complete)       //|> w
#endif
  ,.csb2mcif_req_pvld              (csb2mcif_req_pvld)              //|< w
  ,.csb2mcif_req_prdy              (csb2mcif_req_prdy)              //|> w
  ,.csb2mcif_req_pd                (csb2mcif_req_pd[62:0])          //|< w
  ,.mcif2cdma_dat_rd_rsp_valid     (mcif2cdma_dat_rd_rsp_valid)     //|> o
  ,.mcif2cdma_dat_rd_rsp_ready     (mcif2cdma_dat_rd_rsp_ready)     //|< i
  ,.mcif2cdma_dat_rd_rsp_pd        (mcif2cdma_dat_rd_rsp_pd       ) //|> o
  ,.mcif2cdma_wt_rd_rsp_valid      (mcif2cdma_wt_rd_rsp_valid)      //|> o
  ,.mcif2cdma_wt_rd_rsp_ready      (mcif2cdma_wt_rd_rsp_ready)      //|< i
  ,.mcif2cdma_wt_rd_rsp_pd         (mcif2cdma_wt_rd_rsp_pd       )  //|> o
  ,.mcif2csb_resp_valid            (mcif2csb_resp_valid)            //|> w
  ,.mcif2csb_resp_pd               (mcif2csb_resp_pd[33:0])         //|> w
  ,.mcif2noc_axi_ar_arvalid        (mcif2noc_axi_ar_arvalid)        //|> o
  ,.mcif2noc_axi_ar_arready        (mcif2noc_axi_ar_arready)        //|< i
  ,.mcif2noc_axi_ar_arid           (mcif2noc_axi_ar_arid[7:0])      //|> o
  ,.mcif2noc_axi_ar_arlen          (mcif2noc_axi_ar_arlen[3:0])     //|> o
  ,.mcif2noc_axi_ar_araddr         (mcif2noc_axi_ar_araddr      )   //|> o
  ,.mcif2noc_axi_aw_awvalid        (mcif2noc_axi_aw_awvalid)        //|> o
  ,.mcif2noc_axi_aw_awready        (mcif2noc_axi_aw_awready)        //|< i
  ,.mcif2noc_axi_aw_awid           (mcif2noc_axi_aw_awid[7:0])      //|> o
  ,.mcif2noc_axi_aw_awlen          (mcif2noc_axi_aw_awlen[3:0])     //|> o
  ,.mcif2noc_axi_aw_awaddr         (mcif2noc_axi_aw_awaddr      )   //|> o
  ,.mcif2noc_axi_w_wvalid          (mcif2noc_axi_w_wvalid)          //|> o
  ,.mcif2noc_axi_w_wready          (mcif2noc_axi_w_wready)          //|< i
  ,.mcif2noc_axi_w_wdata           (mcif2noc_axi_w_wdata       )    //|> o
  ,.mcif2noc_axi_w_wstrb           (mcif2noc_axi_w_wstrb      )     //|> o
  ,.mcif2noc_axi_w_wlast           (mcif2noc_axi_w_wlast)           //|> o
#ifdef NVDLA_PDP_ENABLE
  ,.mcif2pdp_rd_rsp_valid          (mcif2pdp_rd_rsp_valid)          //|> w
  ,.mcif2pdp_rd_rsp_ready          (mcif2pdp_rd_rsp_ready)       //|< w
  ,.mcif2pdp_rd_rsp_pd             (mcif2pdp_rd_rsp_pd       )      //|> w
  ,.mcif2pdp_wr_rsp_complete       (mcif2pdp_wr_rsp_complete)       //|> w
  ,.pdp2mcif_rd_cdt_lat_fifo_pop   (pdp2mcif_rd_cdt_lat_fifo_pop)   //|> w
  ,.pdp2mcif_rd_req_valid          (pdp2mcif_rd_req_valid)          //|> w
  ,.pdp2mcif_rd_req_ready          (pdp2mcif_rd_req_ready)          //|> w
  ,.pdp2mcif_rd_req_pd             (pdp2mcif_rd_req_pd      )       //|> w
  ,.pdp2mcif_wr_req_valid          (pdp2mcif_wr_req_valid)          //|> w
  ,.pdp2mcif_wr_req_ready          (pdp2mcif_wr_req_ready)          //|> w
  ,.pdp2mcif_wr_req_pd             (pdp2mcif_wr_req_pd       )      //|> w
#endif
#ifdef NVDLA_SDP_BS_ENABLE
  ,.mcif2sdp_b_rd_rsp_valid        (mcif2sdp_b_rd_rsp_valid)        //|> o
  ,.mcif2sdp_b_rd_rsp_ready        (mcif2sdp_b_rd_rsp_ready)        //|< i
  ,.mcif2sdp_b_rd_rsp_pd           (mcif2sdp_b_rd_rsp_pd       )    //|> o
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  ,.mcif2sdp_e_rd_rsp_valid        (mcif2sdp_e_rd_rsp_valid)        //|> o
  ,.mcif2sdp_e_rd_rsp_ready        (mcif2sdp_e_rd_rsp_ready)        //|< i
  ,.mcif2sdp_e_rd_rsp_pd           (mcif2sdp_e_rd_rsp_pd       )    //|> o
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  ,.mcif2sdp_n_rd_rsp_valid        (mcif2sdp_n_rd_rsp_valid)        //|> o
  ,.mcif2sdp_n_rd_rsp_ready        (mcif2sdp_n_rd_rsp_ready)        //|< i
  ,.mcif2sdp_n_rd_rsp_pd           (mcif2sdp_n_rd_rsp_pd       )    //|> o
#endif
  ,.mcif2sdp_rd_rsp_valid          (mcif2sdp_rd_rsp_valid)          //|> o
  ,.mcif2sdp_rd_rsp_ready          (mcif2sdp_rd_rsp_ready)          //|< i
  ,.mcif2sdp_rd_rsp_pd             (mcif2sdp_rd_rsp_pd       )      //|> o
  ,.mcif2sdp_wr_rsp_complete       (mcif2sdp_wr_rsp_complete)       //|> o
  ,.noc2mcif_axi_b_bvalid          (noc2mcif_axi_b_bvalid)          //|< i
  ,.noc2mcif_axi_b_bready          (noc2mcif_axi_b_bready)          //|> o
  ,.noc2mcif_axi_b_bid             (noc2mcif_axi_b_bid[7:0])        //|< i
  ,.noc2mcif_axi_r_rvalid          (noc2mcif_axi_r_rvalid)          //|< i
  ,.noc2mcif_axi_r_rready          (noc2mcif_axi_r_rready)          //|> o
  ,.noc2mcif_axi_r_rid             (noc2mcif_axi_r_rid[7:0])        //|< i
  ,.noc2mcif_axi_r_rlast           (noc2mcif_axi_r_rlast)           //|< i
  ,.noc2mcif_axi_r_rdata           (noc2mcif_axi_r_rdata       )    //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
#ifdef NVDLA_RUBIK_ENABLE 
  ,.rbk2mcif_rd_cdt_lat_fifo_pop   (rbk2mcif_rd_cdt_lat_fifo_pop)   //|< w
  ,.rbk2mcif_rd_req_valid          (rbk2mcif_rd_req_valid)          //|< w
  ,.rbk2mcif_rd_req_ready          (rbk2mcif_rd_req_ready)          //|> w
  ,.rbk2mcif_rd_req_pd             (rbk2mcif_rd_req_pd      )       //|< w
  ,.rbk2mcif_wr_req_valid          (rbk2mcif_wr_req_valid)          //|< w
  ,.rbk2mcif_wr_req_ready          (rbk2mcif_wr_req_ready)          //|> w
  ,.rbk2mcif_wr_req_pd             (rbk2mcif_wr_req_pd       )      //|< w
  ,.mcif2rbk_rd_rsp_valid          (mcif2rbk_rd_rsp_valid)          //|> w
  ,.mcif2rbk_rd_rsp_ready          (mcif2rbk_rd_rsp_ready)          //|< w
  ,.mcif2rbk_rd_rsp_pd             (mcif2rbk_rd_rsp_pd       )      //|> w
  ,.mcif2rbk_wr_rsp_complete       (mcif2rbk_wr_rsp_complete)       //|> w
#endif
  ,.sdp2mcif_rd_cdt_lat_fifo_pop   (sdp2mcif_rd_cdt_lat_fifo_pop)   //|< i
  ,.sdp2mcif_rd_req_valid          (sdp2mcif_rd_req_valid)          //|< i
  ,.sdp2mcif_rd_req_ready          (sdp2mcif_rd_req_ready)          //|> o
  ,.sdp2mcif_rd_req_pd             (sdp2mcif_rd_req_pd      )       //|< i
  ,.sdp2mcif_wr_req_valid          (sdp2mcif_wr_req_valid)          //|< i
  ,.sdp2mcif_wr_req_ready          (sdp2mcif_wr_req_ready)          //|> o
  ,.sdp2mcif_wr_req_pd             (sdp2mcif_wr_req_pd       )      //|< i
#ifdef NVDLA_SDP_BS_ENABLE
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop (sdp_b2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_b2mcif_rd_req_valid        (sdp_b2mcif_rd_req_valid)        //|< i
  ,.sdp_b2mcif_rd_req_ready        (sdp_b2mcif_rd_req_ready)        //|> o
  ,.sdp_b2mcif_rd_req_pd           (sdp_b2mcif_rd_req_pd      )     //|< i
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2mcif_rd_req_valid)        //|< i
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2mcif_rd_req_ready)        //|> o
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2mcif_rd_req_pd      )     //|< i
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop (sdp_n2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_n2mcif_rd_req_valid        (sdp_n2mcif_rd_req_valid)        //|< i
  ,.sdp_n2mcif_rd_req_ready        (sdp_n2mcif_rd_req_ready)        //|> o
  ,.sdp_n2mcif_rd_req_pd           (sdp_n2mcif_rd_req_pd      )     //|< i
#endif
  );
#endif




endmodule
