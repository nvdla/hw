// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_NOCIF_DRAM_READ_ig.v

`include "simulate_x_tick.vh"
#include "NV_NVDLA_define.h"
module NV_NVDLA_NOCIF_DRAM_READ_ig (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,pwrbus_ram_pd
  ,eg2ig_axi_vld

  //:my $i;
  //:my $k=NVDLA_NUM_DMA_READ_CLIENTS;
  //:for ($i=0;$i<$k;$i++) {
  //: print (",client${i}2mcif_lat_fifo_depth\n");
  //: print (",client${i}2mcif_rd_cdt_lat_fifo_pop\n");
  //: print (",client${i}2mcif_rd_req_valid\n");
  //: print (",client${i}2mcif_rd_req_ready\n");
  //: print (",client${i}2mcif_rd_req_pd\n");
  //: print (",client${i}2mcif_rd_wt\n");
  //: print (",client${i}2mcif_rd_axid\n");
  //:}
  ,reg2dp_rd_os_cnt
  ,cq_wr_pd                       //|> o
  ,cq_wr_pvld                     //|> o
  ,cq_wr_prdy                     //|> o
  ,cq_wr_thread_id                //|> o
  ,mcif2noc_axi_ar_araddr         //|> o
  ,mcif2noc_axi_ar_arready        //|< i
  ,mcif2noc_axi_ar_arid           //|> o
  ,mcif2noc_axi_ar_arlen          //|> o
  ,mcif2noc_axi_ar_arvalid        //|> o
);


input  nvdla_core_clk;
input  nvdla_core_rstn;
input [31:0] pwrbus_ram_pd;

//:my $i;
//:my $k=NVDLA_NUM_DMA_READ_CLIENTS;
//:for ($i=0;$i<$k;$i++) {
//: print ("input client${i}2mcif_rd_cdt_lat_fifo_pop;\n");
//: print ("input client${i}2mcif_rd_req_valid;\n");
//: print ("output client${i}2mcif_rd_req_ready;\n");
//: print qq(
//: input [NVDLA_MEM_ADDRESS_WIDTH+14:0] client${i}2mcif_rd_req_pd;
//: );
//: print ("input [7:0] client${i}2mcif_rd_wt;\n");
//: print ("input [3:0] client${i}2mcif_rd_axid;\n");
//: print ("input [7:0] client${i}2mcif_lat_fifo_depth;\n");
//: }
  


output       cq_wr_pvld;       /* data valid */
input        cq_wr_prdy;       /* data return handshake */
output [3:0] cq_wr_thread_id;
output [6:0] cq_wr_pd;
output        mcif2noc_axi_ar_arvalid;  /* data valid */
input         mcif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_ar_araddr;

input        eg2ig_axi_vld;
input  [7:0] reg2dp_rd_os_cnt;


wire  [NVDLA_MEM_ADDRESS_WIDTH+10:0] arb2spt_req_pd;
wire         arb2spt_req_ready;
wire         arb2spt_req_valid;

//:my $i;
//:my $k=NVDLA_NUM_DMA_READ_CLIENTS;
//:for ($i=0;$i<$k;$i++) {
//: print qq(
//: wire [NVDLA_MEM_ADDRESS_WIDTH+10:0] bpt2arb_req${i}_pd;
//: );
//: print ("wire  bpt2arb_req${i}_ready;\n");
//: print ("wire  bpt2arb_req${i}_valid;\n");
//:}



//:my $i;
//:my $k=NVDLA_NUM_DMA_READ_CLIENTS;
//:for ($i=0;$i<$k;$i++) {
//: print("NV_NVDLA_NOCIF_DRAM_READ_IG_bpt u_bpt${i} (\n");
//: print (".nvdla_core_clk(nvdla_core_clk)\n");
//: print (",.nvdla_core_rstn(nvdla_core_rstn)\n");
//: print (",.dma2bpt_req_valid(client${i}2mcif_rd_req_valid)\n");
//: print (",.dma2bpt_req_ready(client${i}2mcif_rd_req_ready)\n");
//: print (",.dma2bpt_req_pd(client${i}2mcif_rd_req_pd)\n");
//: print (",.dma2bpt_cdt_lat_fifo_pop(client${i}2mcif_rd_cdt_lat_fifo_pop)\n");
//: print (",.bpt2arb_req_valid(bpt2arb_req${i}_valid)\n");
//: print (",.bpt2arb_req_ready(bpt2arb_req${i}_ready)\n");
//: print (",.bpt2arb_req_pd(bpt2arb_req${i}_pd)\n");
//: print (",.tieoff_axid(client${i}2mcif_rd_axid)\n");
//: print (",.tieoff_lat_fifo_depth(client${i}2mcif_lat_fifo_depth)\n");
//: print (");\n");
//:}

wire [NVDLA_MEM_ADDRESS_WIDTH+10:0]  spt2cvt_req_pd;
wire spt2cvt_req_valid;
wire spt2cvt_req_ready;

NV_NVDLA_NOCIF_DRAM_READ_IG_spt u_spt (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.arb2spt_req_valid         (arb2spt_req_valid)              //|< w
  ,.arb2spt_req_ready         (arb2spt_req_ready)              //|> w
  ,.arb2spt_req_pd            (arb2spt_req_pd[NVDLA_MEM_ADDRESS_WIDTH+10:0])           //|< w
  ,.spt2cvt_req_valid         (spt2cvt_req_valid)              //|> w
  ,.spt2cvt_req_ready         (spt2cvt_req_ready)              //|< w
  ,.spt2cvt_req_pd            (spt2cvt_req_pd[NVDLA_MEM_ADDRESS_WIDTH+10:0])           //|> w
  );
NV_NVDLA_NOCIF_DRAM_READ_IG_cvt u_cvt (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.spt2cvt_req_valid         (spt2cvt_req_valid)              //|< w
  ,.spt2cvt_req_ready         (spt2cvt_req_ready)              //|> w
  ,.spt2cvt_req_pd            (spt2cvt_req_pd[NVDLA_MEM_ADDRESS_WIDTH+10:0])           //|< w
  ,.cq_wr_pvld                (cq_wr_pvld)                     //|> o
  ,.cq_wr_prdy                (cq_wr_prdy)                     //|< i
  ,.cq_wr_thread_id           (cq_wr_thread_id[3:0])           //|> o
  ,.cq_wr_pd                  (cq_wr_pd[6:0])                  //|> o
  ,.mcif2noc_axi_ar_arvalid   (mcif2noc_axi_ar_arvalid)        //|> o
  ,.mcif2noc_axi_ar_arready   (mcif2noc_axi_ar_arready)        //|< i
  ,.mcif2noc_axi_ar_arid      (mcif2noc_axi_ar_arid[7:0])      //|> o
  ,.mcif2noc_axi_ar_arlen     (mcif2noc_axi_ar_arlen[3:0])     //|> o
  ,.mcif2noc_axi_ar_araddr    (mcif2noc_axi_ar_araddr[NVDLA_MEM_ADDRESS_WIDTH-1:0])   //|> o
  ,.reg2dp_rd_os_cnt          (reg2dp_rd_os_cnt[7:0])          //|< i
  ,.eg2ig_axi_vld             (eg2ig_axi_vld)                  //|< i
  );

NV_NVDLA_NOCIF_DRAM_READ_IG_arb u_arb  (
   .nvdla_core_clk(nvdla_core_clk)
   ,.nvdla_core_rstn(nvdla_core_rstn)
   //:my $k=NVDLA_NUM_DMA_READ_CLIENTS;
   //:my $i;
   //:for($i=0;$i<$k;$i++) {
   //:print(",.bpt2arb_req${i}_valid (bpt2arb_req${i}_valid)\n");
   //:print(",.bpt2arb_req${i}_ready (bpt2arb_req${i}_ready)\n");
   //:print(",.bpt2arb_req${i}_pd (bpt2arb_req${i}_pd)\n");
   //:print(",.client${i}2mcif_rd_wt (client${i}2mcif_rd_wt)\n");
   //:}
  ,.arb2spt_req_valid         (arb2spt_req_valid)              //|> w
  ,.arb2spt_req_ready         (arb2spt_req_ready)              //|< w
  ,.arb2spt_req_pd            (arb2spt_req_pd[NVDLA_MEM_ADDRESS_WIDTH+10:0])           //|> w
);

endmodule // NV_NVDLA_NOCIF_READ_ig


