// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_NOCIF_DRAM_WRITE_ig.v

`include "simulate_x_tick.vh"
#include "NV_NVDLA_define.h"
module NV_NVDLA_NOCIF_DRAM_WRITE_ig (
  nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,pwrbus_ram_pd
  ,reg2dp_wr_os_cnt
  //:my $k=NVDLA_NUM_DMA_WRITE_CLIENTS;
  //:my $i;
  //:for($i=0;$i<$k;$i++) {
  //:print qq(
  //:,client${i}2mcif_wr_req_pd
  //:,client${i}2mcif_wr_req_valid
  //:,client${i}2mcif_wr_req_ready
  //:,client${i}2mcif_wr_wt
  //:,client${i}2mcif_wr_axid
  //:);
  //:}
  ,cq_wr_pvld                
  ,cq_wr_prdy               
  ,cq_wr_thread_id         
  ,cq_wr_pd                
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
  ,eg2ig_axi_len      
  ,eg2ig_axi_vld     
  );


  //:my $i;
  //:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
  //:print qq(
  //:input client${i}2mcif_wr_req_valid;
  //:output client${i}2mcif_wr_req_ready;
  //:input [NVDLA_MEMIF_WIDTH+NVDLA_MEM_MASK_BIT:0] client${i}2mcif_wr_req_pd;
  //:input [7:0] client${i}2mcif_wr_wt;
  //:input [3:0] client${i}2mcif_wr_axid;
  //:);
  //:}

input         nvdla_core_clk;
input         nvdla_core_rstn;
input [31:0]  pwrbus_ram_pd;
input [7:0]  reg2dp_wr_os_cnt;
input   [1:0] eg2ig_axi_len;
input         eg2ig_axi_vld;
output       cq_wr_pvld;       /* data valid */
input        cq_wr_prdy;       /* data return handshake */
output [3:0] cq_wr_thread_id;
output [2:0] cq_wr_pd;

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


//:my $i;
//:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
//:print qq(
//:wire bpt2arb_cmd${i}_valid;
//:wire bpt2arb_cmd${i}_ready;
//:wire [NVDLA_MEM_ADDRESS_WIDTH+12:0] bpt2arb_cmd${i}_pd;
//:wire  bpt2arb_dat${i}_valid;
//:wire  bpt2arb_dat${i}_ready;
//:wire [NVDLA_MEMIF_WIDTH+1:0] bpt2arb_dat${i}_pd;
//:NV_NVDLA_NOCIF_DRAM_WRITE_IG_bpt u_bpt${i} (
//:.nvdla_core_clk         (nvdla_core_clk)
//:,.nvdla_core_rstn       (nvdla_core_rstn)
//:,.dma2bpt_req_valid     (client${i}2mcif_wr_req_valid)
//:,.dma2bpt_req_ready     (client${i}2mcif_wr_req_ready)
//:,.dma2bpt_req_pd        (client${i}2mcif_wr_req_pd)
//:,.bpt2arb_cmd_valid     (bpt2arb_cmd${i}_valid)
//:,.bpt2arb_cmd_ready     (bpt2arb_cmd${i}_ready)
//:,.bpt2arb_cmd_pd        (bpt2arb_cmd${i}_pd)
//:,.bpt2arb_dat_valid     (bpt2arb_dat${i}_valid)
//:,.bpt2arb_dat_ready     (bpt2arb_dat${i}_ready)
//:,.bpt2arb_dat_pd        (bpt2arb_dat${i}_pd)
//:,.pwrbus_ram_pd         (pwrbus_ram_pd)
//:,.axid                  (client${i}2mcif_wr_axid)
//:);
//:);
//:}

wire [NVDLA_MEM_ADDRESS_WIDTH+12:0]    arb2spt_cmd_pd;
wire [NVDLA_MEMIF_WIDTH+1:0]    arb2spt_dat_pd;
wire arb2spt_cmd_valid, arb2spt_cmd_ready;
wire spt2cvt_cmd_valid, spt2cvt_cmd_ready;

NV_NVDLA_NOCIF_DRAM_WRITE_IG_arb u_arb (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
//:my $i;
//:for($i=0;$i<NVDLA_NUM_DMA_WRITE_CLIENTS;$i++) {
//:print qq(
//:,.bpt2arb_cmd${i}_valid     (bpt2arb_cmd${i}_valid)
//:,.bpt2arb_cmd${i}_ready     (bpt2arb_cmd${i}_ready)
//:,.bpt2arb_cmd${i}_pd        (bpt2arb_cmd${i}_pd)
//:,.bpt2arb_dat${i}_valid     (bpt2arb_dat${i}_valid)
//:,.bpt2arb_dat${i}_ready     (bpt2arb_dat${i}_ready)
//:,.bpt2arb_dat${i}_pd        (bpt2arb_dat${i}_pd)
//:,.client${i}2mcif_wr_wt     (client${i}2mcif_wr_wt)
//:);
//:}
  ,.arb2spt_cmd_valid       (arb2spt_cmd_valid)            //|> w
  ,.arb2spt_cmd_ready       (arb2spt_cmd_ready)            //|< w
  ,.arb2spt_cmd_pd          (arb2spt_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+12:0])         //|> w
  ,.arb2spt_dat_valid       (arb2spt_dat_valid)            //|> w
  ,.arb2spt_dat_ready       (arb2spt_dat_ready)            //|< w
  ,.arb2spt_dat_pd          (arb2spt_dat_pd[NVDLA_MEMIF_WIDTH+1:0])        //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|<
);

wire [NVDLA_MEM_ADDRESS_WIDTH+12:0] spt2cvt_cmd_pd;
wire [NVDLA_MEMIF_WIDTH+1:0] spt2cvt_dat_pd;
NV_NVDLA_NOCIF_DRAM_WRITE_IG_spt u_spt (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.arb2spt_cmd_valid       (arb2spt_cmd_valid)            //|< w
  ,.arb2spt_cmd_ready       (arb2spt_cmd_ready)            //|> w
  ,.arb2spt_cmd_pd          (arb2spt_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+12:0])         //|< w
  ,.arb2spt_dat_valid       (arb2spt_dat_valid)            //|< w
  ,.arb2spt_dat_ready       (arb2spt_dat_ready)            //|> w
  ,.arb2spt_dat_pd          (arb2spt_dat_pd[NVDLA_MEMIF_WIDTH+1:0])        //|< w
  ,.spt2cvt_cmd_valid       (spt2cvt_cmd_valid)            //|> w
  ,.spt2cvt_cmd_ready       (spt2cvt_cmd_ready)            //|< w
  ,.spt2cvt_cmd_pd          (spt2cvt_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+12:0])         //|> w
  ,.spt2cvt_dat_valid       (spt2cvt_dat_valid)            //|> w
  ,.spt2cvt_dat_ready       (spt2cvt_dat_ready)            //|< w
  ,.spt2cvt_dat_pd          (spt2cvt_dat_pd[NVDLA_MEMIF_WIDTH+1:0])        //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          //|< i
  );
NV_NVDLA_NOCIF_DRAM_WRITE_IG_cvt u_cvt (
   .nvdla_core_clk          (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
  ,.spt2cvt_cmd_valid       (spt2cvt_cmd_valid)            //|< w
  ,.spt2cvt_cmd_ready       (spt2cvt_cmd_ready)            //|> w
  ,.spt2cvt_cmd_pd          (spt2cvt_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+12:0])         //|< w
  ,.spt2cvt_dat_valid       (spt2cvt_dat_valid)            //|< w
  ,.spt2cvt_dat_ready       (spt2cvt_dat_ready)            //|> w
  ,.spt2cvt_dat_pd          (spt2cvt_dat_pd[NVDLA_MEMIF_WIDTH+1:0])        //|< w
  ,.cq_wr_pvld              (cq_wr_pvld)                   //|> o
  ,.cq_wr_prdy              (cq_wr_prdy)                   //|< i
  ,.cq_wr_thread_id         (cq_wr_thread_id[3:0])         //|> o
  ,.cq_wr_pd                (cq_wr_pd[2:0])                //|> o
  ,.mcif2noc_axi_aw_awvalid (mcif2noc_axi_aw_awvalid)      //|> o
  ,.mcif2noc_axi_aw_awready (mcif2noc_axi_aw_awready)      //|< i
  ,.mcif2noc_axi_aw_awid    (mcif2noc_axi_aw_awid[7:0])    //|> o
  ,.mcif2noc_axi_aw_awlen   (mcif2noc_axi_aw_awlen[3:0])   //|> o
  ,.mcif2noc_axi_aw_awaddr  (mcif2noc_axi_aw_awaddr[NVDLA_MEM_ADDRESS_WIDTH-1:0]) //|> o
  ,.mcif2noc_axi_w_wvalid   (mcif2noc_axi_w_wvalid)        //|> o
  ,.mcif2noc_axi_w_wready   (mcif2noc_axi_w_wready)        //|< i
  ,.mcif2noc_axi_w_wdata    (mcif2noc_axi_w_wdata[NVDLA_PRIMARY_MEMIF_WIDTH-1:0])  //|> o
  ,.mcif2noc_axi_w_wstrb    (mcif2noc_axi_w_wstrb[NVDLA_PRIMARY_MEMIF_WIDTH/8-1:0])   //|> o
  ,.mcif2noc_axi_w_wlast    (mcif2noc_axi_w_wlast)         //|> o
  ,.eg2ig_axi_len           (eg2ig_axi_len[1:0])           //|< i
  ,.eg2ig_axi_vld           (eg2ig_axi_vld)                //|< i
  ,.reg2dp_wr_os_cnt        (reg2dp_wr_os_cnt[7:0])        //|< i
  );

endmodule
