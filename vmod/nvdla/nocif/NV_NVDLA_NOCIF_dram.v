// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_NOCIF_dram.v

#include "NV_NVDLA_define.h"
#ifdef NVDLA_BDMA_ENABLE
    #define INT_NVDLA_BDMA_ENABLE 1
#else
    #define INT_NVDLA_BDMA_ENABLE 0
#endif
#ifdef NVDLA_CDP_ENABLE
    #define INT_NVDLA_CDP_ENABLE 1
#else
    #define INT_NVDLA_CDP_ENABLE 0
#endif
#ifdef NVDLA_PDP_ENABLE
    #define INT_NVDLA_PDP_ENABLE 1
#else
    #define INT_NVDLA_PDP_ENABLE 0
#endif
#ifdef NVDLA_RUBIK_ENABLE
    #define INT_NVDLA_RUBIK_ENABLE 1
#else
    #define INT_NVDLA_RUBIK_ENABLE 0
#endif
#ifdef NVDLA_SDP_BS_ENABLE
    #define INT_NVDLA_SDP_BS_ENABLE 1
#else
    #define INT_NVDLA_SDP_BS_ENABLE 0
#endif
#ifdef NVDLA_SDP_BN_ENABLE
    #define INT_NVDLA_SDP_BN_ENABLE 1
#else
    #define INT_NVDLA_SDP_BN_ENABLE 0
#endif
#ifdef NVDLA_SDP_EW_ENABLE
    #define INT_NVDLA_SDP_EW_ENABLE 1
#else
    #define INT_NVDLA_SDP_EW_ENABLE 0
#endif


module NV_NVDLA_NOCIF_dram (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,pwrbus_ram_pd
//: my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,client${i}2mcif_rd_cdt_lat_fifo_pop\n");
//: print("  ,client${i}2mcif_rd_req_valid\n");
//: print("  ,client${i}2mcif_rd_req_pd\n");
//: print("  ,client${i}2mcif_rd_req_ready\n");
//: print("  ,client${i}2mcif_rd_axid\n");
//: print("  ,mcif2client${i}_rd_rsp_valid\n");
//: print("  ,mcif2client${i}_rd_rsp_ready\n");
//: print("  ,mcif2client${i}_rd_rsp_pd\n");
//: print("  ,client${i}2mcif_lat_fifo_depth\n");
//: }
//: my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,client${i}2mcif_wr_req_pd\n");
//: print("  ,client${i}2mcif_wr_req_valid\n");
//: print("  ,client${i}2mcif_wr_req_ready\n");
//: print("  ,client${i}2mcif_wr_axid\n");
//: print("  ,mcif2client${i}_wr_rsp_complete\n");
//: }
  ,csb2mcif_req_pd                //|< i
  ,csb2mcif_req_pvld              //|< i
  ,csb2mcif_req_prdy              //|> o
  ,noc2mcif_axi_b_bid             //|< i
  ,noc2mcif_axi_b_bvalid          //|< i
  ,noc2mcif_axi_r_rdata           //|< i
  ,noc2mcif_axi_r_rid             //|< i
  ,noc2mcif_axi_r_rlast           //|< i
  ,noc2mcif_axi_r_rvalid          //|< i
  ,mcif2noc_axi_ar_arready        //|< i
  ,mcif2noc_axi_aw_awready        //|< i
  ,mcif2noc_axi_w_wready          //|< i
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
  ,noc2mcif_axi_b_bready          //|> o
  ,noc2mcif_axi_r_rready          //|> o
);

//:my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//:my $i = 0;
//:for ($i=0;$i<$k;$i++) {
//: print ("input client${i}2mcif_rd_cdt_lat_fifo_pop;\n");
//: print ("input [3:0] client${i}2mcif_rd_axid;\n");
//: print("input client${i}2mcif_rd_req_valid;\n");
//: print qq(
//: input [NVDLA_MEM_ADDRESS_WIDTH+14:0] client${i}2mcif_rd_req_pd;
//: );
//: print("output client${i}2mcif_rd_req_ready;\n");
//: print("output mcif2client${i}_rd_rsp_valid;\n");
//: print("input mcif2client${i}_rd_rsp_ready;\n");
//: print qq(
//: output [NVDLA_MEMIF_WIDTH+NVDLA_MEM_MASK_BIT-1:0] mcif2client${i}_rd_rsp_pd;
//: );
//: print("input [7:0] client${i}2mcif_lat_fifo_depth;\n");
//: }

//:my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//:my $i = 0;
//:for ($i=0;$i<$k;$i++) {
//: print qq(
//: input [NVDLA_MEMIF_WIDTH+NVDLA_MEM_MASK_BIT:0] client${i}2mcif_wr_req_pd;
//: );
//: print ("input [3:0] client${i}2mcif_wr_axid;\n");
//: print("input client${i}2mcif_wr_req_valid;\n");
//: print("output client${i}2mcif_wr_req_ready;\n");
//: print("output mcif2client${i}_wr_rsp_complete;\n");
//: }


input         nvdla_core_clk;
input         nvdla_core_rstn;
input [31:0]  pwrbus_ram_pd;

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

//:my $i;
//:my $nindex=0;
//: my @dma_index = (INT_NVDLA_BDMA_ENABLE, 1, 1,INT_NVDLA_CDP_ENABLE, INT_NVDLA_PDP_ENABLE,INT_NVDLA_RUBIK_ENABLE, 1, INT_NVDLA_SDP_BS_ENABLE, INT_NVDLA_SDP_EW_ENABLE, INT_NVDLA_SDP_BN_ENABLE,0,0,0,0,0,0);
//: my @dma_name = ("bdma","cdma_dat","cdma_wt","cdp","pdp","rbk","sdp","sdp_b","sdp_e","sdp_n","na","na","na","na","na","na");
//: for ($i=0;$i<16;$i++) {
//: if ($dma_index[$i]) {
//:    print qq(
//:   wire [7:0] reg2dp_rd_weight_$dma_name[$i];
//:   wire [7:0] client${nindex}2mcif_rd_wt = reg2dp_rd_weight_$dma_name[$i];
//:);
//:$nindex++;
//:}
//:else {
//:     if ($dma_name[$i] ne "na") {
//:          print qq(wire [7:0] reg2dp_rd_weight_$dma_name[$i];);
//:     }
//:}
//:}

//:my $i;
//:my $nindex=0;
//: my @dma_index = (INT_NVDLA_BDMA_ENABLE, 1,INT_NVDLA_CDP_ENABLE, INT_NVDLA_PDP_ENABLE, INT_NVDLA_RUBIK_ENABLE, 0,0,0,0,0,0);
//: my @dma_name=("bdma","sdp","cdp","pdp","rbk","na","na","na","na","na","na","na","na","na","na","na");
//: for ($i=0;$i<16;$i++) {
//: if ($dma_index[$i]) {
//:    print qq(
//:   wire [7:0] reg2dp_wr_weight_$dma_name[$i];
//:   wire [7:0] client${nindex}2mcif_wr_wt = reg2dp_wr_weight_$dma_name[$i];
//:);
//:$nindex++;
//:}
//:else {
//:     if ($dma_name[$i] ne "na") {
//:          print qq(wire [7:0] reg2dp_wr_weight_$dma_name[$i];);
//:     }
//:}
//:}

wire [7:0] reg2dp_rd_os_cnt;
wire [7:0] reg2dp_wr_os_cnt;

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



NV_NVDLA_NOCIF_DRAM_read u_read (
   .reg2dp_rd_os_cnt               (reg2dp_rd_os_cnt[7:0])          //|< w
  ,.nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd)
  //:my $k=NVDLA_NUM_DMA_READ_CLIENTS;
  //:my $i;
  //:for ($i=0;$i<$k;$i++) {
  //:  print(",.client${i}2mcif_rd_cdt_lat_fifo_pop(client${i}2mcif_rd_cdt_lat_fifo_pop)\n");
  //:  print(",.client${i}2mcif_rd_req_valid (client${i}2mcif_rd_req_valid)\n");
  //:  print(",.client${i}2mcif_rd_req_ready (client${i}2mcif_rd_req_ready)\n");
  //:  print(",.client${i}2mcif_rd_req_pd (client${i}2mcif_rd_req_pd)\n");
  //:  print(",.mcif2client${i}_rd_rsp_valid (mcif2client${i}_rd_rsp_valid)\n");
  //:  print(",.mcif2client${i}_rd_rsp_ready (mcif2client${i}_rd_rsp_ready)\n");
  //:  print(",.mcif2client${i}_rd_rsp_pd (mcif2client${i}_rd_rsp_pd)\n"),
  //:  print(",.client${i}2mcif_rd_wt (client${i}2mcif_rd_wt)\n"),
  //:  print(",.client${i}2mcif_rd_axid (client${i}2mcif_rd_axid)\n"),
  //:  print(",.client${i}2mcif_lat_fifo_depth (client${i}2mcif_lat_fifo_depth)\n"),
  //:  }
  ,.mcif2noc_axi_ar_arvalid        (mcif2noc_axi_ar_arvalid)        //|> o
  ,.mcif2noc_axi_ar_arready        (mcif2noc_axi_ar_arready)        //|< i
  ,.mcif2noc_axi_ar_arid           (mcif2noc_axi_ar_arid)      //|> o
  ,.mcif2noc_axi_ar_arlen          (mcif2noc_axi_ar_arlen)     //|> o
  ,.mcif2noc_axi_ar_araddr         (mcif2noc_axi_ar_araddr)   //|> o
  ,.noc2mcif_axi_r_rvalid          (noc2mcif_axi_r_rvalid)          //|< i
  ,.noc2mcif_axi_r_rready          (noc2mcif_axi_r_rready)          //|> o
  ,.noc2mcif_axi_r_rid             (noc2mcif_axi_r_rid)        //|< i
  ,.noc2mcif_axi_r_rlast           (noc2mcif_axi_r_rlast)           //|< i
  ,.noc2mcif_axi_r_rdata           (noc2mcif_axi_r_rdata)    //|< i
);


NV_NVDLA_NOCIF_DRAM_write u_write (
  .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd)
  ,.reg2dp_wr_os_cnt               (reg2dp_wr_os_cnt)
  //:my $k=NVDLA_NUM_DMA_WRITE_CLIENTS;
  //:my $i;
  //:for ($i=0;$i<$k;$i++) {
  //:  print(",.client${i}2mcif_wr_req_valid(client${i}2mcif_wr_req_valid)\n");
  //:  print(",.client${i}2mcif_wr_req_ready(client${i}2mcif_wr_req_ready)\n");
  //:  print(",.client${i}2mcif_wr_req_pd(client${i}2mcif_wr_req_pd)\n");
  //:  print(",.client${i}2mcif_wr_wt(client${i}2mcif_wr_wt)\n");
  //:  print(",.client${i}2mcif_wr_axid(client${i}2mcif_wr_axid)\n");
  //:  print(",.mcif2client${i}_wr_rsp_complete(mcif2client${i}_wr_rsp_complete)\n");
  //:}
  ,.mcif2noc_axi_aw_awvalid        (mcif2noc_axi_aw_awvalid)        //|> o
  ,.mcif2noc_axi_aw_awready        (mcif2noc_axi_aw_awready)        //|< i
  ,.mcif2noc_axi_aw_awid           (mcif2noc_axi_aw_awid)      //|> o
  ,.mcif2noc_axi_aw_awlen          (mcif2noc_axi_aw_awlen)     //|> o
  ,.mcif2noc_axi_aw_awaddr         (mcif2noc_axi_aw_awaddr)   //|> o
  ,.mcif2noc_axi_w_wvalid          (mcif2noc_axi_w_wvalid)          //|> o
  ,.mcif2noc_axi_w_wready          (mcif2noc_axi_w_wready)          //|< i
  ,.mcif2noc_axi_w_wdata           (mcif2noc_axi_w_wdata)    //|> o
  ,.mcif2noc_axi_w_wstrb           (mcif2noc_axi_w_wstrb)     //|> o
  ,.mcif2noc_axi_w_wlast           (mcif2noc_axi_w_wlast)           //|> o
  ,.noc2mcif_axi_b_bvalid          (noc2mcif_axi_b_bvalid)          //|< i
  ,.noc2mcif_axi_b_bready          (noc2mcif_axi_b_bready)          //|> o
  ,.noc2mcif_axi_b_bid             (noc2mcif_axi_b_bid)        //|< i
);


endmodule
