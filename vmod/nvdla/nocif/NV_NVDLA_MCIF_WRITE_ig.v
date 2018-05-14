// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_WRITE_ig.v

#include "NV_NVDLA_MCIF_define.h"
`include "NV_NVDLA_MCIF_define.vh"
module NV_NVDLA_MCIF_WRITE_ig (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,pwrbus_ram_pd
  ,reg2dp_wr_os_cnt
  //: my @wdma_name = WDMA_NAME; 
  //: foreach my $client (@wdma_name) {
  //: print"  ,reg2dp_wr_weight_${client}\n";      
  //: }
  //: foreach my $client (@wdma_name) {
  //: print"  ,${client}2mcif_wr_req_pd\n";
  //: print"  ,${client}2mcif_wr_req_valid\n";
  //: print"  ,${client}2mcif_wr_req_ready\n";
  //: }
  ,mcif2noc_axi_aw_awvalid 
  ,mcif2noc_axi_aw_awready 
  ,mcif2noc_axi_aw_awid    
  ,mcif2noc_axi_aw_awlen   
  ,mcif2noc_axi_aw_awaddr  
  ,mcif2noc_axi_w_wvalid   
  ,mcif2noc_axi_w_wready  
  ,mcif2noc_axi_w_wdata  
  ,mcif2noc_axi_w_wstrb 
  ,mcif2noc_axi_w_wlast
  ,cq_wr_pvld                
  ,cq_wr_prdy               
  ,cq_wr_pd                
  ,cq_wr_thread_id         
  ,eg2ig_axi_len      
  ,eg2ig_axi_vld     
  );



input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] pwrbus_ram_pd;
input  [7:0]  reg2dp_wr_os_cnt;
input  [1:0]  eg2ig_axi_len;
input         eg2ig_axi_vld;
output        cq_wr_pvld;       
input         cq_wr_prdy;       
output [2:0]  cq_wr_thread_id;
output [2:0]  cq_wr_pd;

output         mcif2noc_axi_aw_awvalid;  
input          mcif2noc_axi_aw_awready;  
output  [7:0]  mcif2noc_axi_aw_awid;
output  [3:0]  mcif2noc_axi_aw_awlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_aw_awaddr;

output         mcif2noc_axi_w_wvalid;  
input          mcif2noc_axi_w_wready;  
output [NVDLA_PRIMARY_MEMIF_WIDTH-1:0]  mcif2noc_axi_w_wdata;
output [NVDLA_PRIMARY_MEMIF_STRB-1:0]   mcif2noc_axi_w_wstrb;
output         mcif2noc_axi_w_wlast;

//: my @wdma_name = WDMA_NAME; 
//: foreach my $client (@wdma_name) {
//: print qq(
//: input  ${client}2mcif_wr_req_valid;
//: output ${client}2mcif_wr_req_ready;
//: input [NVDLA_DMA_WR_REQ-1:0] ${client}2mcif_wr_req_pd;
//: );
//: }
//: foreach my $client (@wdma_name) {
//: print "input  [7:0]  reg2dp_wr_weight_${client};\n";
//: }

wire           arb2spt_cmd_ready;
wire           arb2spt_cmd_valid;
wire [NVDLA_DMA_WR_IG_PW-1:0]    arb2spt_cmd_pd;
wire           arb2spt_dat_ready;
wire           arb2spt_dat_valid;
wire [NVDLA_DMA_WR_REQ-2:0]    arb2spt_dat_pd;
/*
wire           spt2cvt_cmd_ready;
wire           spt2cvt_cmd_valid;
wire [NVDLA_MEM_ADDRESS_WIDTH+12:0] spt2cvt_cmd_pd;
wire           spt2cvt_dat_ready;
wire           spt2cvt_dat_valid;
wire [NVDLA_MEMIF_WIDTH+1:0] spt2cvt_dat_pd;
*/

//: for (my $i=0;$i<WDMA_NUM;$i++) {
//: print qq(
//: wire bpt2arb_cmd${i}_valid;
//: wire bpt2arb_cmd${i}_ready;
//: wire [NVDLA_DMA_WR_IG_PW-1:0] bpt2arb_cmd${i}_pd;
//: wire  bpt2arb_dat${i}_valid;
//: wire  bpt2arb_dat${i}_ready;
//: wire [NVDLA_DMA_WR_REQ-2:0] bpt2arb_dat${i}_pd;
//: );
//: }


//: my $i = 0;
//: my @wdma_name = WDMA_NAME; 
//: foreach my $client (@wdma_name) {
//: print "NV_NVDLA_MCIF_WRITE_IG_bpt u_bpt${i} ( \n";   
//: print "  .nvdla_core_clk         (nvdla_core_clk)\n";
//: print "  ,.nvdla_core_rstn       (nvdla_core_rstn)\n";
//: print "  ,.pwrbus_ram_pd         (pwrbus_ram_pd)\n";
//: print "  ,.dma2bpt_req_valid     (${client}2mcif_wr_req_valid)\n";
//: print "  ,.dma2bpt_req_ready     (${client}2mcif_wr_req_ready)\n";
//: print "  ,.dma2bpt_req_pd        (${client}2mcif_wr_req_pd)\n";
//: print "  ,.bpt2arb_cmd_valid     (bpt2arb_cmd${i}_valid)\n";
//: print "  ,.bpt2arb_cmd_ready     (bpt2arb_cmd${i}_ready)\n";
//: print "  ,.bpt2arb_cmd_pd        (bpt2arb_cmd${i}_pd)\n";
//: print "  ,.bpt2arb_dat_valid     (bpt2arb_dat${i}_valid)\n";
//: print "  ,.bpt2arb_dat_ready     (bpt2arb_dat${i}_ready)\n";
//: print "  ,.bpt2arb_dat_pd        (bpt2arb_dat${i}_pd)\n";
//: print "  ,.axid                  (`tieoff_axid_${client})\n";
//: print ");\n";
//: $i++;
//:}


NV_NVDLA_MCIF_WRITE_IG_arb u_arb (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|<
//: for (my $i=0;$i<WDMA_NUM;$i++) {
//: print "  ,.bpt2arb_cmd${i}_valid     (bpt2arb_cmd${i}_valid)\n";
//: print "  ,.bpt2arb_cmd${i}_ready     (bpt2arb_cmd${i}_ready)\n";
//: print "  ,.bpt2arb_cmd${i}_pd        (bpt2arb_cmd${i}_pd)\n";
//: print "  ,.bpt2arb_dat${i}_valid     (bpt2arb_dat${i}_valid)\n";
//: print "  ,.bpt2arb_dat${i}_ready     (bpt2arb_dat${i}_ready)\n";
//: print "  ,.bpt2arb_dat${i}_pd        (bpt2arb_dat${i}_pd)\n";
//: }
//: my $i=0;
//: my @wdma_name = WDMA_NAME; 
//: foreach my $client (@wdma_name) {
//: print "  ,.reg2dp_wr_weight${i}      (reg2dp_wr_weight_${client}[7:0])\n";
//: $i++;
//: }
  ,.arb2spt_cmd_valid       (arb2spt_cmd_valid)            //|> w
  ,.arb2spt_cmd_ready       (arb2spt_cmd_ready)            //|< w
  ,.arb2spt_cmd_pd          (arb2spt_cmd_pd)
  ,.arb2spt_dat_valid       (arb2spt_dat_valid)            //|> w
  ,.arb2spt_dat_ready       (arb2spt_dat_ready)            //|< w
  ,.arb2spt_dat_pd          (arb2spt_dat_pd)
);


/*
NV_NVDLA_MCIF_WRITE_IG_spt u_spt (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|< i
  ,.arb2spt_cmd_valid       (arb2spt_cmd_valid)            //|< w
  ,.arb2spt_cmd_ready       (arb2spt_cmd_ready)            //|> w
  ,.arb2spt_cmd_pd          (arb2spt_cmd_pd)
  ,.arb2spt_dat_valid       (arb2spt_dat_valid)            //|< w
  ,.arb2spt_dat_ready       (arb2spt_dat_ready)            //|> w
  ,.arb2spt_dat_pd          (arb2spt_dat_pd)
  ,.spt2cvt_cmd_valid       (spt2cvt_cmd_valid)            //|> w
  ,.spt2cvt_cmd_ready       (spt2cvt_cmd_ready)            //|< w
  ,.spt2cvt_cmd_pd          (spt2cvt_cmd_pd)
  ,.spt2cvt_dat_valid       (spt2cvt_dat_valid)            //|> w
  ,.spt2cvt_dat_ready       (spt2cvt_dat_ready)            //|< w
  ,.spt2cvt_dat_pd          (spt2cvt_dat_pd)
);
*/


NV_NVDLA_MCIF_WRITE_IG_cvt u_cvt (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.reg2dp_wr_os_cnt        (reg2dp_wr_os_cnt[7:0])        //|< i
  ,.cq_wr_pvld              (cq_wr_pvld)                   //|> o
  ,.cq_wr_prdy              (cq_wr_prdy)                   //|< i
  ,.cq_wr_pd                (cq_wr_pd[2:0])                //|> o
  ,.cq_wr_thread_id         (cq_wr_thread_id[2:0])         //|> o
  ,.eg2ig_axi_len           (eg2ig_axi_len[1:0])           //|< i
  ,.eg2ig_axi_vld           (eg2ig_axi_vld)                //|< i
  ,.spt2cvt_cmd_valid       (arb2spt_cmd_valid)            //|< w
  ,.spt2cvt_cmd_ready       (arb2spt_cmd_ready)            //|> w
  ,.spt2cvt_cmd_pd          (arb2spt_cmd_pd)
  ,.spt2cvt_dat_valid       (arb2spt_dat_valid)            //|< w
  ,.spt2cvt_dat_ready       (arb2spt_dat_ready)            //|> w
  ,.spt2cvt_dat_pd          (arb2spt_dat_pd)
  ,.mcif2noc_axi_aw_awvalid (mcif2noc_axi_aw_awvalid)      //|> o
  ,.mcif2noc_axi_aw_awready (mcif2noc_axi_aw_awready)      //|< i
  ,.mcif2noc_axi_aw_awid    (mcif2noc_axi_aw_awid[7:0])    //|> o
  ,.mcif2noc_axi_aw_awlen   (mcif2noc_axi_aw_awlen[3:0])   //|> o
  ,.mcif2noc_axi_aw_awaddr  (mcif2noc_axi_aw_awaddr)
  ,.mcif2noc_axi_w_wvalid   (mcif2noc_axi_w_wvalid)        //|> o
  ,.mcif2noc_axi_w_wready   (mcif2noc_axi_w_wready)        //|< i
  ,.mcif2noc_axi_w_wdata    (mcif2noc_axi_w_wdata)
  ,.mcif2noc_axi_w_wstrb    (mcif2noc_axi_w_wstrb)
  ,.mcif2noc_axi_w_wlast    (mcif2noc_axi_w_wlast)         //|> o
  );



endmodule
