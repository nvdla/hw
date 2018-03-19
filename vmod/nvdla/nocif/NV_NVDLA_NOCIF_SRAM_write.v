// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_NOCIF_SRAM_write.v

#include "NV_NVDLA_define.h"
module NV_NVDLA_NOCIF_SRAM_write (

    nvdla_core_clk
   ,nvdla_core_rstn
   ,pwrbus_ram_pd
  //:my $i;
  //:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
  //:print qq(
  //:,client${i}2cvif_wr_req_pd
  //:,client${i}2cvif_wr_req_valid
  //:,client${i}2cvif_wr_wt
  //:,client${i}2cvif_wr_axid
  //:,client${i}2cvif_wr_req_ready
  //:,cvif2client${i}_wr_rsp_complete
  //:);
  //:}
    ,reg2dp_wr_os_cnt
    ,noc2cvif_axi_b_bid        //|< i
    ,noc2cvif_axi_b_bvalid     //|< i
  ,cvif2noc_axi_aw_awaddr    //|> o
  ,cvif2noc_axi_aw_awid      //|> o
  ,cvif2noc_axi_aw_awlen     //|> o
  ,cvif2noc_axi_aw_awready   //|< i
  ,cvif2noc_axi_w_wready   //|< i
  ,cvif2noc_axi_aw_awvalid   //|> o
  ,cvif2noc_axi_w_wdata      //|> o
  ,cvif2noc_axi_w_wlast      //|> o
  ,cvif2noc_axi_w_wstrb      //|> o
  ,cvif2noc_axi_w_wvalid     //|> o
  ,noc2cvif_axi_b_bready     //|> o
);

  //:my $i;
  //:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
  //:print qq(
  //:input [NVDLA_MEMIF_WIDTH+NVDLA_MEM_MASK_BIT:0] client${i}2cvif_wr_req_pd;
  //:input client${i}2cvif_wr_req_valid;
  //:output client${i}2cvif_wr_req_ready;
  //:input [7:0] client${i}2cvif_wr_wt;
  //:input [3:0] client${i}2cvif_wr_axid;
  //:output cvif2client${i}_wr_rsp_complete;
  //:);
  //:}
  output        cvif2noc_axi_aw_awvalid;  /* data valid */
input         cvif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] cvif2noc_axi_aw_awid;
output  [3:0] cvif2noc_axi_aw_awlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] cvif2noc_axi_aw_awaddr;

output         cvif2noc_axi_w_wvalid;  /* data valid */
input          cvif2noc_axi_w_wready;  /* data return handshake */
output [NVDLA_SECONDARY_MEMIF_WIDTH-1:0] cvif2noc_axi_w_wdata;
output  [(NVDLA_SECONDARY_MEMIF_WIDTH/8)-1:0] cvif2noc_axi_w_wstrb;
output         cvif2noc_axi_w_wlast;
input        noc2cvif_axi_b_bvalid;  /* data valid */
output       noc2cvif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2cvif_axi_b_bid;
input [7:0] reg2dp_wr_os_cnt;
input [31:0] pwrbus_ram_pd;

input  nvdla_core_clk;
input  nvdla_core_rstn;

wire [1:0] eg2ig_axi_len;
wire [3:0] cq_wr_thread_id;
wire [2:0] cq_wr_pd;
wire cq_wr_pvld;
wire cq_wr_prdy;

NV_NVDLA_NOCIF_SRAM_WRITE_ig u_ig (
   .nvdla_core_clk            (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)              //|< i
  ,.pwrbus_ram_pd             (pwrbus_ram_pd)
  ,.reg2dp_wr_os_cnt          (reg2dp_wr_os_cnt)
  //:my $i;
  //:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
  //:print qq(
  //:,.client${i}2cvif_wr_req_valid(client${i}2cvif_wr_req_valid)
  //:,.client${i}2cvif_wr_req_ready(client${i}2cvif_wr_req_ready)
  //:,.client${i}2cvif_wr_req_pd(client${i}2cvif_wr_req_pd)
  //:,.client${i}2cvif_wr_wt(client${i}2cvif_wr_wt)
  //:,.client${i}2cvif_wr_axid(client${i}2cvif_wr_axid)
  //:);
  //:}
  ,.cq_wr_pvld                (cq_wr_pvld)                   //|> w
  ,.cq_wr_prdy                (cq_wr_prdy)                   //|< w
  ,.cq_wr_thread_id           (cq_wr_thread_id[3:0])         //|> w
  ,.cq_wr_pd                  (cq_wr_pd[2:0])                //|> w
  ,.cvif2noc_axi_aw_awvalid   (cvif2noc_axi_aw_awvalid)      //|> o
  ,.cvif2noc_axi_aw_awready   (cvif2noc_axi_aw_awready)      //|< i
  ,.cvif2noc_axi_aw_awid      (cvif2noc_axi_aw_awid[7:0])    //|> o
  ,.cvif2noc_axi_aw_awlen     (cvif2noc_axi_aw_awlen[3:0])   //|> o
  ,.cvif2noc_axi_aw_awaddr    (cvif2noc_axi_aw_awaddr[NVDLA_MEM_ADDRESS_WIDTH-1:0]) //|> o
  ,.cvif2noc_axi_w_wvalid     (cvif2noc_axi_w_wvalid)        //|> o
  ,.cvif2noc_axi_w_wready     (cvif2noc_axi_w_wready)        //|< i
  ,.cvif2noc_axi_w_wdata      (cvif2noc_axi_w_wdata)  //|> o
  ,.cvif2noc_axi_w_wstrb      (cvif2noc_axi_w_wstrb[(NVDLA_SECONDARY_MEMIF_WIDTH/8)-1:0])   //|> o
  ,.cvif2noc_axi_w_wlast      (cvif2noc_axi_w_wlast)         //|> o
  ,.eg2ig_axi_len             (eg2ig_axi_len[1:0])           //|< w
  ,.eg2ig_axi_vld             (eg2ig_axi_vld)                //|< w
);


 //:my $i;
 //:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
  //:print qq(
  //:wire [2:0] cq_rd${i}_pd;
  //:wire       cq_rd${i}_pvld;
  //:wire       cq_rd${i}_prdy;
  //:);
  //:}



NV_NVDLA_NOCIF_SRAM_WRITE_eg u_eg (
   .nvdla_core_clk            (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)              //|< i
  //:my $i;
  //:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
  //:print qq(
  //:,.cvif2client${i}_wr_rsp_complete(cvif2client${i}_wr_rsp_complete)
  //:);
  //:}
  //:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
  //:print qq(
  //:,.cq_rd${i}_pd                 (cq_rd${i}_pd)                  //|< w
  //:,.cq_rd${i}_pvld               (cq_rd${i}_pvld)                  //|< w
  //:,.cq_rd${i}_prdy               (cq_rd${i}_prdy)                  //|> w
  //:);
  //:}

  ,.noc2cvif_axi_b_bvalid     (noc2cvif_axi_b_bvalid)        //|< i
  ,.noc2cvif_axi_b_bready     (noc2cvif_axi_b_bready)        //|> o
  ,.noc2cvif_axi_b_bid        (noc2cvif_axi_b_bid[7:0])      //|< i
  ,.eg2ig_axi_len             (eg2ig_axi_len[1:0])           //|> w
  ,.eg2ig_axi_vld             (eg2ig_axi_vld)                //|> w
  );


NV_NVDLA_NOCIF_SRAM_WRITE_cq u_cq (
   .nvdla_core_clk            (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)              //|< i
  ,.pwrbus_ram_pd             (pwrbus_ram_pd[31:0])
  ,.cq_wr_prdy                (cq_wr_prdy)                   //|> w
  ,.cq_wr_pvld                (cq_wr_pvld)                   //|< w
  ,.cq_wr_thread_id           (cq_wr_thread_id[3:0])         //|< w
  ,.cq_wr_pd                  (cq_wr_pd[2:0])                //|< w
  //:my $i;
  //:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
  //:print qq(
  //:,.cq_rd${i}_pd                 (cq_rd${i}_pd)                  //|< w
  //:,.cq_rd${i}_pvld               (cq_rd${i}_pvld)                  //|< w
  //:,.cq_rd${i}_prdy               (cq_rd${i}_prdy)                  //|> w
  //:);
  //:}
  //:my $i;
  //:for($i=NVDLA_NUM_DMA_WRITE_CLIENTS;$i<16;$i++) {
  //:print qq(
  //:,.cq_rd${i}_prdy               (1'b1)                  //|< w
  //:);
  //:}
);



endmodule
