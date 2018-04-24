// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_READ_ig.v

#include "NV_NVDLA_MCIF_define.h"
`include "NV_NVDLA_MCIF_define.vh"

module NV_NVDLA_MCIF_READ_ig (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,pwrbus_ram_pd
  ,reg2dp_rd_os_cnt
  //: my @rdma_name = RDMA_NAME; 
  //: foreach my $client (@rdma_name) {
  //:  print("  ,reg2dp_rd_weight_${client}\n");
  //: }
  //: foreach my $client (@rdma_name) {
  //: print ("  ,${client}2mcif_rd_cdt_lat_fifo_pop\n");
  //: print ("  ,${client}2mcif_rd_req_valid\n");
  //: print ("  ,${client}2mcif_rd_req_ready\n");
  //: print ("  ,${client}2mcif_rd_req_pd\n");
  //:}
#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
  ,cq_wr_pd                       //|> o
  ,cq_wr_pvld                     //|> o
  ,cq_wr_prdy                     //|> o
  ,cq_wr_thread_id                //|> o
#endif
  ,eg2ig_axi_vld
  ,mcif2noc_axi_ar_araddr         //|> o
  ,mcif2noc_axi_ar_arready        //|< i
  ,mcif2noc_axi_ar_arid           //|> o
  ,mcif2noc_axi_ar_arlen          //|> o
  ,mcif2noc_axi_ar_arvalid        //|> o
);


input  nvdla_core_clk;
input  nvdla_core_rstn;
input [31:0] pwrbus_ram_pd;
input  [7:0] reg2dp_rd_os_cnt;

//: my @rdma_name = RDMA_NAME; 
//: foreach my $client (@rdma_name) {
//:  print("input  [7:0] reg2dp_rd_weight_${client};\n");
//: }
//: foreach my $client (@rdma_name) {
//: print ("input  ${client}2mcif_rd_cdt_lat_fifo_pop;\n");
//: print ("input  ${client}2mcif_rd_req_valid;\n");
//: print ("output ${client}2mcif_rd_req_ready;\n");
//: print qq(input [NVDLA_DMA_RD_REQ-1:0] ${client}2mcif_rd_req_pd;\n);
//: }

output        mcif2noc_axi_ar_arvalid;  
input         mcif2noc_axi_ar_arready;  
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_ar_araddr;

input        eg2ig_axi_vld;
#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
output       cq_wr_pvld;       
input        cq_wr_prdy;       
output [6:0] cq_wr_pd;
output [3:0] cq_wr_thread_id;
#endif

//:for (my $i=0;$i<RDMA_NUM;$i++) {
//: print qq(wire [NVDLA_MEM_ADDRESS_WIDTH+10:0] bpt2arb_req${i}_pd;\n);
//: print ("wire  bpt2arb_req${i}_ready;\n");
//: print ("wire  bpt2arb_req${i}_valid;\n");
//:}

wire  [NVDLA_MEM_ADDRESS_WIDTH+10:0] arb2spt_req_pd;
wire         arb2spt_req_ready;
wire         arb2spt_req_valid;
wire [NVDLA_MEM_ADDRESS_WIDTH+10:0]  spt2cvt_req_pd;
wire spt2cvt_req_valid;
wire spt2cvt_req_ready;



//---------------------read_bpt inst--------------------------------//
//: my $i = 0;
//: my @rdma_name = RDMA_NAME; 
//: foreach my $client (@rdma_name) {
//: print("NV_NVDLA_MCIF_READ_IG_bpt u_bpt${i} (\n");
//: print ("   .nvdla_core_clk(nvdla_core_clk)\n");
//: print ("  ,.nvdla_core_rstn(nvdla_core_rstn)\n");
//: print ("  ,.dma2bpt_cdt_lat_fifo_pop(${client}2mcif_rd_cdt_lat_fifo_pop)\n");
//: print ("  ,.dma2bpt_req_valid(${client}2mcif_rd_req_valid)\n");
//: print ("  ,.dma2bpt_req_ready(${client}2mcif_rd_req_ready)\n");
//: print ("  ,.dma2bpt_req_pd(${client}2mcif_rd_req_pd)\n");
//: print ("  ,.bpt2arb_req_valid(bpt2arb_req${i}_valid)\n");
//: print ("  ,.bpt2arb_req_ready(bpt2arb_req${i}_ready)\n");
//: print ("  ,.bpt2arb_req_pd(bpt2arb_req${i}_pd)\n");
//: print ("  ,.tieoff_axid(`tieoff_axid_${client})\n");
//: print ("  ,.tieoff_lat_fifo_depth(`tieoff_depth_${client})\n");
//: print (");\n");
//: $i++;
//: }


NV_NVDLA_MCIF_READ_IG_arb u_arb  (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
   //: my $i = 0;
   //: my @rdma_name = RDMA_NAME; 
   //: foreach my $client (@rdma_name) {
   //: print("  ,.reg2dp_rd_weight${i}(reg2dp_rd_weight_${client})\n");
   //: $i++;
   //: }
   //: $i = 0;
   //: foreach my $client (@rdma_name) {
   //: print("  ,.bpt2arb_req${i}_valid(bpt2arb_req${i}_valid)\n");
   //: print("  ,.bpt2arb_req${i}_ready(bpt2arb_req${i}_ready)\n");
   //: print("  ,.bpt2arb_req${i}_pd(bpt2arb_req${i}_pd)\n");
   //: $i++;
   //: }
  ,.arb2spt_req_valid         (arb2spt_req_valid)              //|> w
  ,.arb2spt_req_ready         (arb2spt_req_ready)              //|< w
  ,.arb2spt_req_pd            (arb2spt_req_pd)                 //|> w
);

/*
NV_NVDLA_MCIF_READ_IG_spt u_spt (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.arb2spt_req_valid         (arb2spt_req_valid)              //|< w
  ,.arb2spt_req_ready         (arb2spt_req_ready)              //|> w
  ,.arb2spt_req_pd            (arb2spt_req_pd)                 //|< w
  ,.spt2cvt_req_valid         (spt2cvt_req_valid)              //|> w
  ,.spt2cvt_req_ready         (spt2cvt_req_ready)              //|< w
  ,.spt2cvt_req_pd            (spt2cvt_req_pd)                 //|> w
  );
*/

NV_NVDLA_MCIF_READ_IG_cvt u_cvt (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
  ,.reg2dp_rd_os_cnt          (reg2dp_rd_os_cnt[7:0])          //|< i
#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
  ,.cq_wr_pvld                (cq_wr_pvld)                     //|> o
  ,.cq_wr_prdy                (cq_wr_prdy)                     //|< i
  ,.cq_wr_pd                  (cq_wr_pd[6:0])                  //|> o
  ,.cq_wr_thread_id           (cq_wr_thread_id[3:0])           //|> o
#endif
  ,.eg2ig_axi_vld             (eg2ig_axi_vld)                  //|< i
  ,.spt2cvt_req_valid         (arb2spt_req_valid)              //|< w
  ,.spt2cvt_req_ready         (arb2spt_req_ready)              //|> w
  ,.spt2cvt_req_pd            (arb2spt_req_pd)                 //|< w
  ,.mcif2noc_axi_ar_arvalid   (mcif2noc_axi_ar_arvalid)        //|> o
  ,.mcif2noc_axi_ar_arready   (mcif2noc_axi_ar_arready)        //|< i
  ,.mcif2noc_axi_ar_arid      (mcif2noc_axi_ar_arid[7:0])      //|> o
  ,.mcif2noc_axi_ar_arlen     (mcif2noc_axi_ar_arlen[3:0])     //|> o
  ,.mcif2noc_axi_ar_araddr    (mcif2noc_axi_ar_araddr)         //|> o
  );




endmodule 


