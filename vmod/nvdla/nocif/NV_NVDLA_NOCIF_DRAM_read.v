// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_NOCIF_DRAM_read.v

`include "simulate_x_tick.vh"
#include "NV_NVDLA_define.h"
module NV_NVDLA_NOCIF_DRAM_read (
  nvdla_core_clk
  ,nvdla_core_rstn
  //:my $k=NVDLA_NUM_DMA_READ_CLIENTS;
  //:my $i;
  //:for ($i=0;$i<$k;$i++) {
  //:  print(",client${i}2mcif_rd_cdt_lat_fifo_pop\n");
  //:  print(",client${i}2mcif_rd_req_valid\n");
  //:  print(",client${i}2mcif_rd_req_ready\n");
  //:  print(",client${i}2mcif_rd_req_pd\n");
  //:  print(",mcif2client${i}_rd_rsp_valid\n");
  //:  print(",mcif2client${i}_rd_rsp_ready\n");
  //:  print(",mcif2client${i}_rd_rsp_pd\n"),
  //:  print(",client${i}2mcif_rd_wt\n"),
  //:  print(",client${i}2mcif_rd_axid\n"),
  //:  print(",client${i}2mcif_lat_fifo_depth\n"),
  //:  }
  ,pwrbus_ram_pd
  ,reg2dp_rd_os_cnt
  ,mcif2noc_axi_ar_arvalid
  ,mcif2noc_axi_ar_arready
  ,mcif2noc_axi_ar_arid  
  ,mcif2noc_axi_ar_arlen
  ,mcif2noc_axi_ar_araddr
  ,noc2mcif_axi_r_rvalid 
  ,noc2mcif_axi_r_rready
  ,noc2mcif_axi_r_rid  
  ,noc2mcif_axi_r_rlast
  ,noc2mcif_axi_r_rdata
);

input  nvdla_core_clk;
input  nvdla_core_rstn;

//:my $k=NVDLA_NUM_DMA_READ_CLIENTS;
//:my $w = NVDLA_MEMIF_WIDTH+NVDLA_MEM_MASK_BIT-1;
//:my $i;
//:for ($i=0;$i<$k;$i++) {
//:  print("input client${i}2mcif_rd_cdt_lat_fifo_pop;\n");
//:  print("input client${i}2mcif_rd_req_valid;\n");
//:  print("output client${i}2mcif_rd_req_ready;\n");
//:  print qq(
//:  input [NVDLA_MEM_ADDRESS_WIDTH+14:0] client${i}2mcif_rd_req_pd;
//:  );
//:  print("output mcif2client${i}_rd_rsp_valid;\n");
//:  print("output [$w:0] mcif2client${i}_rd_rsp_pd;\n");
//:  print("input mcif2client${i}_rd_rsp_ready;\n");
//:  print("input [7:0] client${i}2mcif_rd_wt;\n");
//:  print("input [3:0] client${i}2mcif_rd_axid;\n");
//:  print("input [7:0] client${i}2mcif_lat_fifo_depth;\n");
//:  }


  //:my $i;
  //:for($i=0;$i<16;$i++) {
  //: print qq(
  //:wire [6:0] cq_rd${i}_pd;
  //:wire       cq_rd${i}_prdy;
  //:wire      cq_rd${i}_pvld;
  //: );
  //:}

input [7:0] reg2dp_rd_os_cnt;
input          noc2mcif_axi_r_rvalid;  /* data valid */
output         noc2mcif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2mcif_axi_r_rid;
input          noc2mcif_axi_r_rlast;
input  [NVDLA_PRIMARY_MEMIF_WIDTH-1:0] noc2mcif_axi_r_rdata;
output        mcif2noc_axi_ar_arvalid;  /* data valid */
input         mcif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_ar_araddr;
input  [31:0] pwrbus_ram_pd;


wire  [3:0] cq_wr_thread_id;
wire [6:0] cq_wr_pd;
wire   cq_wr_pvld;
wire cq_wr_prdy;
NV_NVDLA_NOCIF_DRAM_READ_ig u_ig (
  .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.reg2dp_rd_os_cnt               (reg2dp_rd_os_cnt)
  ,.eg2ig_axi_vld                  (eg2ig_axi_vld)                  //|> w
  //:my $i;
  //:my $k=NVDLA_NUM_DMA_READ_CLIENTS;
  //:for ($i=0;$i<$k;$i++) {
  //: print (",.client${i}2mcif_rd_cdt_lat_fifo_pop(client${i}2mcif_rd_cdt_lat_fifo_pop)\n");
  //: print (",.client${i}2mcif_rd_req_valid(client${i}2mcif_rd_req_valid)\n");
  //: print (",.client${i}2mcif_rd_req_ready(client${i}2mcif_rd_req_ready)\n");
  //: print (",.client${i}2mcif_rd_req_pd(client${i}2mcif_rd_req_pd)\n");
  //: print (",.client${i}2mcif_rd_wt(client${i}2mcif_rd_wt)\n");
  //: print (",.client${i}2mcif_rd_axid(client${i}2mcif_rd_axid)\n");
  //: print (",.client${i}2mcif_lat_fifo_depth(client${i}2mcif_lat_fifo_depth)\n");
  //:}
  ,.cq_wr_pvld                     (cq_wr_pvld)                     //|> w
  ,.cq_wr_prdy                     (cq_wr_prdy)                     //|< w
  ,.cq_wr_thread_id                (cq_wr_thread_id[3:0])           //|> w
  ,.cq_wr_pd                       (cq_wr_pd[6:0])                  //|> w
  ,.mcif2noc_axi_ar_arvalid        (mcif2noc_axi_ar_arvalid)        //|> o
  ,.mcif2noc_axi_ar_arready        (mcif2noc_axi_ar_arready)        //|< i
  ,.mcif2noc_axi_ar_arid           (mcif2noc_axi_ar_arid[7:0])      //|> o
  ,.mcif2noc_axi_ar_arlen          (mcif2noc_axi_ar_arlen[3:0])     //|> o
  ,.mcif2noc_axi_ar_araddr         (mcif2noc_axi_ar_araddr[NVDLA_MEM_ADDRESS_WIDTH-1:0])   //|> o
);



NV_NVDLA_NOCIF_DRAM_READ_eg u_eg (
   .nvdla_core_clk                 (nvdla_core_clk) 
  ,.nvdla_core_rstn                (nvdla_core_rstn) 
  //:my $k=NVDLA_NUM_DMA_READ_CLIENTS;
  //:my $i;
  //:for($i=0;$i<$k;$i++) {
  //:print(" ,.mcif2client${i}_rd_rsp_valid(mcif2client${i}_rd_rsp_valid)\n");
  //:print(" ,.mcif2client${i}_rd_rsp_ready(mcif2client${i}_rd_rsp_ready)\n");
  //:print(" ,.mcif2client${i}_rd_rsp_pd(mcif2client${i}_rd_rsp_pd)\n");
  //:}
  //:my $i;
  //:for($i=0;$i<NVDLA_NUM_DMA_READ_CLIENTS;$i++) {
  //: print qq(
  //: ,.cq_rd${i}_prdy(cq_rd${i}_prdy)
  //: ,.cq_rd${i}_pvld(cq_rd${i}_pvld)
  //: ,.cq_rd${i}_pd(cq_rd${i}_pd[6:0])
  //:);
  //:}
  ,.noc2mcif_axi_r_rvalid          (noc2mcif_axi_r_rvalid)          //|< i
  ,.noc2mcif_axi_r_rready          (noc2mcif_axi_r_rready)          //|> o
  ,.noc2mcif_axi_r_rid             (noc2mcif_axi_r_rid[7:0])        //|< i
  ,.noc2mcif_axi_r_rlast           (noc2mcif_axi_r_rlast)           //|< i
  ,.noc2mcif_axi_r_rdata           (noc2mcif_axi_r_rdata[NVDLA_PRIMARY_MEMIF_WIDTH-1:0])    //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.eg2ig_axi_vld                  (eg2ig_axi_vld)                  //|> w
  );




NV_NVDLA_NOCIF_DRAM_READ_cq u_cq (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.cq_wr_prdy                     (cq_wr_prdy)                     //|> w
  ,.cq_wr_pvld                     (cq_wr_pvld)                     //|< w
  ,.cq_wr_thread_id                (cq_wr_thread_id[3:0])           //|< w
  ,.cq_wr_pd                       (cq_wr_pd[6:0])                  //|< w
  //:my $i;
  //:for($i=0;$i<NVDLA_NUM_DMA_READ_CLIENTS;$i++) {
  //: print qq(
  //: ,.cq_rd${i}_prdy(cq_rd${i}_prdy)
  //: ,.cq_rd${i}_pvld(cq_rd${i}_pvld)
  //: ,.cq_rd${i}_pd(cq_rd${i}_pd[6:0])
  //: );
  //:}

  //:my $i;
  //:for($i=NVDLA_NUM_DMA_READ_CLIENTS;$i<16;$i++) {
  //: print qq(
  //: ,.cq_rd${i}_prdy(1'b1)
  //:);
  //:}
  
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  );

endmodule
