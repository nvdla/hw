// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_mcif.v

#include "NV_NVDLA_MCIF_define.h"

module NV_NVDLA_mcif (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,pwrbus_ram_pd
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
  ,csb2mcif_req_pd                //|< i
  ,csb2mcif_req_pvld              //|< i
  ,csb2mcif_req_prdy              //|> o
  ,mcif2csb_resp_pd               //|> o
  ,mcif2csb_resp_valid            //|> o
  ,noc2mcif_axi_b_bid             //|< i
  ,noc2mcif_axi_b_bvalid          //|< i
  ,noc2mcif_axi_b_bready          //|> o
  ,noc2mcif_axi_r_rdata           //|< i
  ,noc2mcif_axi_r_rid             //|< i
  ,noc2mcif_axi_r_rlast           //|< i
  ,noc2mcif_axi_r_rvalid          //|< i
  ,noc2mcif_axi_r_rready          //|> o
  ,mcif2noc_axi_ar_araddr         //|> o
  ,mcif2noc_axi_ar_arid           //|> o
  ,mcif2noc_axi_ar_arlen          //|> o
  ,mcif2noc_axi_ar_arvalid        //|> o
  ,mcif2noc_axi_ar_arready        //|< i
  ,mcif2noc_axi_aw_awaddr         //|> o
  ,mcif2noc_axi_aw_awid           //|> o
  ,mcif2noc_axi_aw_awlen          //|> o
  ,mcif2noc_axi_aw_awvalid        //|> o
  ,mcif2noc_axi_aw_awready        //|< i
  ,mcif2noc_axi_w_wdata           //|> o
  ,mcif2noc_axi_w_wlast           //|> o
  ,mcif2noc_axi_w_wstrb           //|> o
  ,mcif2noc_axi_w_wvalid          //|> o
  ,mcif2noc_axi_w_wready          //|< i
);


input         nvdla_core_clk;
input         nvdla_core_rstn;
input [31:0]  pwrbus_ram_pd;

input         csb2mcif_req_pvld;  
output        csb2mcif_req_prdy;  
input  [62:0] csb2mcif_req_pd;
output        mcif2csb_resp_valid;  
output [33:0] mcif2csb_resp_pd;     

output        mcif2noc_axi_ar_arvalid;  
input         mcif2noc_axi_ar_arready;  
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_ar_araddr;

output        mcif2noc_axi_aw_awvalid;  
input         mcif2noc_axi_aw_awready;  
output  [7:0] mcif2noc_axi_aw_awid;
output  [3:0] mcif2noc_axi_aw_awlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_aw_awaddr;

output         mcif2noc_axi_w_wvalid;  
input          mcif2noc_axi_w_wready;  
output [NVDLA_PRIMARY_MEMIF_WIDTH-1:0]   mcif2noc_axi_w_wdata;
output [NVDLA_PRIMARY_MEMIF_STRB-1:0] mcif2noc_axi_w_wstrb;
output         mcif2noc_axi_w_wlast;
input          noc2mcif_axi_b_bvalid;  
output         noc2mcif_axi_b_bready;  
input  [7:0]   noc2mcif_axi_b_bid;

input          noc2mcif_axi_r_rvalid;  
output         noc2mcif_axi_r_rready;  
input  [7:0]   noc2mcif_axi_r_rid;
input          noc2mcif_axi_r_rlast;
input  [NVDLA_PRIMARY_MEMIF_WIDTH-1:0] noc2mcif_axi_r_rdata;

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

wire   [7:0] reg2dp_rd_os_cnt;
wire   [7:0] reg2dp_wr_os_cnt;

//: my @rdma_name = RDMA_NAME; 
//: foreach my $client (@rdma_name) {
//: print "wire   [7:0] reg2dp_rd_weight_${client};\n";
//: }
//: my @wdma_name = WDMA_NAME; 
//: foreach my $client (@wdma_name) {
//: print "wire   [7:0] reg2dp_wr_weight_${client};\n";
//: }


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
  ,.reg2dp_wr_os_cnt               (reg2dp_wr_os_cnt[7:0])          //|> w
//: my @rdma_name = RDMA_NAME; 
//: foreach my $client (@rdma_name) {
//: print"   ,.reg2dp_rd_weight_${client} (reg2dp_rd_weight_${client}[7:0])\n";    
//: }
//: my @wdma_name = WDMA_NAME; 
//: foreach my $client (@wdma_name) {
//: print"   ,.reg2dp_wr_weight_${client} (reg2dp_wr_weight_${client}[7:0])\n";      
//: }
  ,.reg2dp_rd_weight_rsv_0         ()                               //|> ?
  ,.reg2dp_rd_weight_rsv_1         ()                               //|> ?
  ,.reg2dp_wr_weight_rsv_0         ()                               //|> ?
  ,.reg2dp_wr_weight_rsv_1         ()                               //|> ?
  ,.reg2dp_wr_weight_rsv_2         ()                               //|> ?
  );



NV_NVDLA_MCIF_read u_read (
   .reg2dp_rd_os_cnt               (reg2dp_rd_os_cnt[7:0])          //|< w
  ,.nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd)
  //: my @rdma_name = RDMA_NAME; 
  //: foreach my $client (@rdma_name) {
  //:  print("  ,.reg2dp_rd_weight_${client}  (reg2dp_rd_weight_${client})\n"),
  //:  }
  //: foreach my $client (@rdma_name) {
  //:  print("  ,.${client}2mcif_rd_cdt_lat_fifo_pop (${client}2mcif_rd_cdt_lat_fifo_pop)\n");
  //:  print("  ,.${client}2mcif_rd_req_valid (${client}2mcif_rd_req_valid)\n");
  //:  print("  ,.${client}2mcif_rd_req_ready (${client}2mcif_rd_req_ready)\n");
  //:  print("  ,.${client}2mcif_rd_req_pd    (${client}2mcif_rd_req_pd)\n");
  //:  print("  ,.mcif2${client}_rd_rsp_valid (mcif2${client}_rd_rsp_valid)\n");
  //:  print("  ,.mcif2${client}_rd_rsp_ready (mcif2${client}_rd_rsp_ready)\n");
  //:  print("  ,.mcif2${client}_rd_rsp_pd    (mcif2${client}_rd_rsp_pd)\n"),
  //:  }
  ,.mcif2noc_axi_ar_arvalid        (mcif2noc_axi_ar_arvalid)  
  ,.mcif2noc_axi_ar_arready        (mcif2noc_axi_ar_arready)  
  ,.mcif2noc_axi_ar_arid           (mcif2noc_axi_ar_arid)     
  ,.mcif2noc_axi_ar_arlen          (mcif2noc_axi_ar_arlen)    
  ,.mcif2noc_axi_ar_araddr         (mcif2noc_axi_ar_araddr)   
  ,.noc2mcif_axi_r_rvalid          (noc2mcif_axi_r_rvalid)    
  ,.noc2mcif_axi_r_rready          (noc2mcif_axi_r_rready)    
  ,.noc2mcif_axi_r_rid             (noc2mcif_axi_r_rid)       
  ,.noc2mcif_axi_r_rlast           (noc2mcif_axi_r_rlast)     
  ,.noc2mcif_axi_r_rdata           (noc2mcif_axi_r_rdata)    
);


NV_NVDLA_MCIF_write u_write (
  .nvdla_core_clk                 (nvdla_core_clk)            
  ,.nvdla_core_rstn               (nvdla_core_rstn)          
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd)
  ,.reg2dp_wr_os_cnt              (reg2dp_wr_os_cnt)
  //: my @wdma_name = WDMA_NAME; 
  //: foreach my $client (@wdma_name) {
  //:  print("  ,.reg2dp_wr_weight_${client}  (reg2dp_wr_weight_${client})\n"),
  //: }
  //: foreach my $client (@wdma_name) {
  //:  print("  ,.${client}2mcif_wr_req_valid (${client}2mcif_wr_req_valid)\n");
  //:  print("  ,.${client}2mcif_wr_req_ready (${client}2mcif_wr_req_ready)\n");
  //:  print("  ,.${client}2mcif_wr_req_pd    (${client}2mcif_wr_req_pd)\n");
  //:  print("  ,.mcif2${client}_wr_rsp_complete (mcif2${client}_wr_rsp_complete)\n");
  //: }
  ,.mcif2noc_axi_aw_awvalid        (mcif2noc_axi_aw_awvalid) 
  ,.mcif2noc_axi_aw_awready        (mcif2noc_axi_aw_awready) 
  ,.mcif2noc_axi_aw_awid           (mcif2noc_axi_aw_awid)    
  ,.mcif2noc_axi_aw_awlen          (mcif2noc_axi_aw_awlen)   
  ,.mcif2noc_axi_aw_awaddr         (mcif2noc_axi_aw_awaddr)  
  ,.mcif2noc_axi_w_wvalid          (mcif2noc_axi_w_wvalid)   
  ,.mcif2noc_axi_w_wready          (mcif2noc_axi_w_wready)   
  ,.mcif2noc_axi_w_wdata           (mcif2noc_axi_w_wdata)    
  ,.mcif2noc_axi_w_wstrb           (mcif2noc_axi_w_wstrb)    
  ,.mcif2noc_axi_w_wlast           (mcif2noc_axi_w_wlast)    
  ,.noc2mcif_axi_b_bvalid          (noc2mcif_axi_b_bvalid)   
  ,.noc2mcif_axi_b_bready          (noc2mcif_axi_b_bready)   
  ,.noc2mcif_axi_b_bid             (noc2mcif_axi_b_bid)     
);


endmodule
