// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_read.v

#include "NV_NVDLA_MCIF_define.h"

module NV_NVDLA_MCIF_read (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,pwrbus_ram_pd
  ,reg2dp_rd_os_cnt
  //: my @rdma_name = RDMA_NAME; 
  //: foreach my $client (@rdma_name) {
  //:  print("  ,reg2dp_rd_weight_${client}\n"),
  //: }
  //: foreach my $client (@rdma_name) {
  //:  print("  ,${client}2mcif_rd_cdt_lat_fifo_pop\n");
  //:  print("  ,${client}2mcif_rd_req_valid\n");
  //:  print("  ,${client}2mcif_rd_req_ready\n");
  //:  print("  ,${client}2mcif_rd_req_pd\n");
  //:  print("  ,mcif2${client}_rd_rsp_valid\n");
  //:  print("  ,mcif2${client}_rd_rsp_ready\n");
  //:  print("  ,mcif2${client}_rd_rsp_pd\n"),
  //: }
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
input  [31:0] pwrbus_ram_pd;
input    [7:0] reg2dp_rd_os_cnt;

//: my @rdma_name = RDMA_NAME; 
//: foreach my $client (@rdma_name) {
//:  print "input  [7:0] reg2dp_rd_weight_${client};\n";
//: }
//: foreach my $client (@rdma_name) {
//:  print("input ${client}2mcif_rd_cdt_lat_fifo_pop;\n");
//:  print("input ${client}2mcif_rd_req_valid;\n");
//:  print("output ${client}2mcif_rd_req_ready;\n");
//:  print qq(input  [NVDLA_DMA_RD_REQ-1:0] ${client}2mcif_rd_req_pd;\n);
//:  print("output mcif2${client}_rd_rsp_valid;\n");
//:  print("input mcif2${client}_rd_rsp_ready;\n");
//:  print qq(output [NVDLA_DMA_RD_RSP-1:0] mcif2${client}_rd_rsp_pd;\n);
//: }

input          noc2mcif_axi_r_rvalid; 
output         noc2mcif_axi_r_rready;
input    [7:0] noc2mcif_axi_r_rid;
input          noc2mcif_axi_r_rlast;
input  [NVDLA_PRIMARY_MEMIF_WIDTH-1:0] noc2mcif_axi_r_rdata;
output        mcif2noc_axi_ar_arvalid;  
input         mcif2noc_axi_ar_arready; 
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_ar_araddr;

wire        eg2ig_axi_vld;
#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
wire  [3:0] cq_wr_thread_id;
wire  [6:0] cq_wr_pd;
wire        cq_wr_pvld;
wire        cq_wr_prdy;
//:for(my $i=0;$i<RDMA_NUM;$i++) {
//:print qq(
//:wire [6:0] cq_rd${i}_pd;
//:wire       cq_rd${i}_prdy;
//:wire       cq_rd${i}_pvld;
//:);
//:}
#endif



NV_NVDLA_MCIF_READ_ig u_ig (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.reg2dp_rd_os_cnt               (reg2dp_rd_os_cnt)
  //: my @rdma_name = RDMA_NAME; 
  //: foreach my $client (@rdma_name) {
  //: print("  ,.reg2dp_rd_weight_${client} (reg2dp_rd_weight_${client})\n");
  //: }
  //: foreach my $client (@rdma_name) {
  //: print (" ,.${client}2mcif_rd_cdt_lat_fifo_pop (${client}2mcif_rd_cdt_lat_fifo_pop)\n");
  //: print (" ,.${client}2mcif_rd_req_valid (${client}2mcif_rd_req_valid)\n");
  //: print (" ,.${client}2mcif_rd_req_ready (${client}2mcif_rd_req_ready)\n");
  //: print (" ,.${client}2mcif_rd_req_pd    (${client}2mcif_rd_req_pd)\n");
  //:}
  ,.mcif2noc_axi_ar_arvalid        (mcif2noc_axi_ar_arvalid)        //|> o
  ,.mcif2noc_axi_ar_arready        (mcif2noc_axi_ar_arready)        //|< i
  ,.mcif2noc_axi_ar_arid           (mcif2noc_axi_ar_arid[7:0])      //|> o
  ,.mcif2noc_axi_ar_arlen          (mcif2noc_axi_ar_arlen[3:0])     //|> o
  ,.mcif2noc_axi_ar_araddr         (mcif2noc_axi_ar_araddr)         //|> o
  ,.eg2ig_axi_vld                  (eg2ig_axi_vld)                  //|> w
#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
  ,.cq_wr_pvld                     (cq_wr_pvld)                     //|> w
  ,.cq_wr_prdy                     (cq_wr_prdy)                     //|< w
  ,.cq_wr_pd                       (cq_wr_pd[6:0])                  //|> w
  ,.cq_wr_thread_id                (cq_wr_thread_id[3:0])           //|> w
#endif
);


#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
NV_NVDLA_MCIF_READ_cq u_cq (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.cq_wr_thread_id                (cq_wr_thread_id[3:0])           //|< w
  ,.cq_wr_prdy                     (cq_wr_prdy)                     //|> w
  ,.cq_wr_pvld                     (cq_wr_pvld)                     //|< w
  ,.cq_wr_pd                       (cq_wr_pd[6:0])                  //|< w
  //:for(my $i=0;$i<RDMA_NUM;$i++) {
  //:  print(" ,.cq_rd${i}_prdy(cq_rd${i}_prdy)\n");
  //:  print(" ,.cq_rd${i}_pvld(cq_rd${i}_pvld)\n");
  //:  print(" ,.cq_rd${i}_pd(cq_rd${i}_pd[6:0])\n");
  //:}
  );
#endif


NV_NVDLA_MCIF_READ_eg u_eg (
   .nvdla_core_clk                 (nvdla_core_clk) 
  ,.nvdla_core_rstn                (nvdla_core_rstn) 
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.eg2ig_axi_vld                  (eg2ig_axi_vld)                  //|> w
#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
  //:for(my $i=0;$i<RDMA_NUM;$i++) {
  //:  print(" ,.cq_rd${i}_prdy(cq_rd${i}_prdy)\n");
  //:  print(" ,.cq_rd${i}_pvld(cq_rd${i}_pvld)\n");
  //:  print(" ,.cq_rd${i}_pd(cq_rd${i}_pd[6:0])\n");
  //:}
#endif
  //: my @rdma_name = RDMA_NAME; 
  //: foreach my $client (@rdma_name) {
  //:  print(" ,.mcif2${client}_rd_rsp_valid(mcif2${client}_rd_rsp_valid)\n");
  //:  print(" ,.mcif2${client}_rd_rsp_ready(mcif2${client}_rd_rsp_ready)\n");
  //:  print(" ,.mcif2${client}_rd_rsp_pd(mcif2${client}_rd_rsp_pd)\n");
  //:}
  ,.noc2mcif_axi_r_rvalid          (noc2mcif_axi_r_rvalid)          //|< i
  ,.noc2mcif_axi_r_rready          (noc2mcif_axi_r_rready)          //|> o
  ,.noc2mcif_axi_r_rid             (noc2mcif_axi_r_rid[7:0])        //|< i
  ,.noc2mcif_axi_r_rlast           (noc2mcif_axi_r_rlast)           //|< i
  ,.noc2mcif_axi_r_rdata           (noc2mcif_axi_r_rdata)           //|< i
  );



endmodule
