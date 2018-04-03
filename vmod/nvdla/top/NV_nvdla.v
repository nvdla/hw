// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_nvdla.v

#include "NV_NVDLA_define.h"

`include "NV_HWACC_NVDLA_tick_defines.vh"

#include "../cmac/NV_NVDLA_CMAC.h"
#include "../csc/NV_NVDLA_CSC.h"
module NV_nvdla (
   dla_core_clk                  //|< i
  ,dla_csb_clk                   //|< i
  ,global_clk_ovr_on             //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,dla_reset_rstn                //|< i
  ,direct_reset_                 //|< i
  ,test_mode                     //|< i
  ,csb2nvdla_valid               //|< i
  ,csb2nvdla_ready               //|> o
  ,csb2nvdla_addr                //|< i
  ,csb2nvdla_wdat                //|< i
  ,csb2nvdla_write               //|< i
  ,csb2nvdla_nposted             //|< i
  ,nvdla2csb_valid               //|> o
  ,nvdla2csb_data                //|> o
  ,nvdla2csb_wr_complete         //|> o
  ,nvdla_core2dbb_aw_awvalid     //|> o
  ,nvdla_core2dbb_aw_awready     //|< i
  ,nvdla_core2dbb_aw_awid        //|> o
  ,nvdla_core2dbb_aw_awlen       //|> o
  ,nvdla_core2dbb_aw_awaddr      //|> o
  ,nvdla_core2dbb_w_wvalid       //|> o
  ,nvdla_core2dbb_w_wready       //|< i
  ,nvdla_core2dbb_w_wdata        //|> o
  ,nvdla_core2dbb_w_wstrb        //|> o
  ,nvdla_core2dbb_w_wlast        //|> o
  ,nvdla_core2dbb_b_bvalid       //|< i
  ,nvdla_core2dbb_b_bready       //|> o
  ,nvdla_core2dbb_b_bid          //|< i
  ,nvdla_core2dbb_ar_arvalid     //|> o
  ,nvdla_core2dbb_ar_arready     //|< i
  ,nvdla_core2dbb_ar_arid        //|> o
  ,nvdla_core2dbb_ar_arlen       //|> o
  ,nvdla_core2dbb_ar_araddr      //|> o
  ,nvdla_core2dbb_r_rvalid       //|< i
  ,nvdla_core2dbb_r_rready       //|> o
  ,nvdla_core2dbb_r_rid          //|< i
  ,nvdla_core2dbb_r_rlast        //|< i
  ,nvdla_core2dbb_r_rdata        //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,nvdla_core2cvsram_aw_awvalid  //|> o
  ,nvdla_core2cvsram_aw_awready  //|< i
  ,nvdla_core2cvsram_aw_awid     //|> o
  ,nvdla_core2cvsram_aw_awlen    //|> o
  ,nvdla_core2cvsram_aw_awaddr   //|> o
  ,nvdla_core2cvsram_w_wvalid    //|> o
  ,nvdla_core2cvsram_w_wready    //|< i
  ,nvdla_core2cvsram_w_wdata     //|> o
  ,nvdla_core2cvsram_w_wstrb     //|> o
  ,nvdla_core2cvsram_w_wlast     //|> o
  ,nvdla_core2cvsram_b_bvalid    //|< i
  ,nvdla_core2cvsram_b_bready    //|> o
  ,nvdla_core2cvsram_b_bid       //|< i
  ,nvdla_core2cvsram_ar_arvalid  //|> o
  ,nvdla_core2cvsram_ar_arready  //|< i
  ,nvdla_core2cvsram_ar_arid     //|> o
  ,nvdla_core2cvsram_ar_arlen    //|> o
  ,nvdla_core2cvsram_ar_araddr   //|> o
  ,nvdla_core2cvsram_r_rvalid    //|< i
  ,nvdla_core2cvsram_r_rready    //|> o
  ,nvdla_core2cvsram_r_rid       //|< i
  ,nvdla_core2cvsram_r_rlast     //|< i
  ,nvdla_core2cvsram_r_rdata     //|< i
#endif
  ,dla_intr                      //|> o
  ,nvdla_pwrbus_ram_c_pd         //|< i
  ,nvdla_pwrbus_ram_ma_pd        //|< i *
  ,nvdla_pwrbus_ram_mb_pd        //|< i *
  ,nvdla_pwrbus_ram_p_pd         //|< i
  ,nvdla_pwrbus_ram_o_pd         //|< i
  ,nvdla_pwrbus_ram_a_pd         //|< i
  );
////////////////////////////////////////////////////////////////////////////////
input  dla_core_clk; 
input  dla_csb_clk; 
input  global_clk_ovr_on;
input  tmc2slcg_disable_clock_gating;
input  dla_reset_rstn;
input  direct_reset_;
input  test_mode;

//csb
input         csb2nvdla_valid;  
output        csb2nvdla_ready; 
input  [15:0] csb2nvdla_addr;
input  [31:0] csb2nvdla_wdat;
input         csb2nvdla_write;
input         csb2nvdla_nposted;
output        nvdla2csb_valid;
output [31:0] nvdla2csb_data;
output  nvdla2csb_wr_complete;
///////////////
output        nvdla_core2dbb_aw_awvalid;
input         nvdla_core2dbb_aw_awready;
output  [7:0] nvdla_core2dbb_aw_awid;
output  [3:0] nvdla_core2dbb_aw_awlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] nvdla_core2dbb_aw_awaddr;

output         nvdla_core2dbb_w_wvalid; 
input          nvdla_core2dbb_w_wready; 
output [NVDLA_PRIMARY_MEMIF_WIDTH-1:0] nvdla_core2dbb_w_wdata;
output  [NVDLA_PRIMARY_MEMIF_WIDTH/8-1:0] nvdla_core2dbb_w_wstrb;
output         nvdla_core2dbb_w_wlast;

output        nvdla_core2dbb_ar_arvalid; 
input         nvdla_core2dbb_ar_arready;
output  [7:0] nvdla_core2dbb_ar_arid;
output  [3:0] nvdla_core2dbb_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] nvdla_core2dbb_ar_araddr;

input        nvdla_core2dbb_b_bvalid; 
output       nvdla_core2dbb_b_bready;
input  [7:0] nvdla_core2dbb_b_bid;

input          nvdla_core2dbb_r_rvalid;
output         nvdla_core2dbb_r_rready;
input    [7:0] nvdla_core2dbb_r_rid;
input          nvdla_core2dbb_r_rlast;
input  [NVDLA_PRIMARY_MEMIF_WIDTH-1:0] nvdla_core2dbb_r_rdata;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output        nvdla_core2cvsram_aw_awvalid;
input         nvdla_core2cvsram_aw_awready;
output  [7:0] nvdla_core2cvsram_aw_awid;
output  [3:0] nvdla_core2cvsram_aw_awlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] nvdla_core2cvsram_aw_awaddr;

output         nvdla_core2cvsram_w_wvalid;
input          nvdla_core2cvsram_w_wready;
output [NVDLA_SECONDARY_MEMIF_WIDTH-1:0] nvdla_core2cvsram_w_wdata;
output  [NVDLA_SECONDARY_MEMIF_WIDTH/8-1:0] nvdla_core2cvsram_w_wstrb;
output         nvdla_core2cvsram_w_wlast;

input        nvdla_core2cvsram_b_bvalid; 
output       nvdla_core2cvsram_b_bready;
input  [7:0] nvdla_core2cvsram_b_bid;

output        nvdla_core2cvsram_ar_arvalid;
input         nvdla_core2cvsram_ar_arready;
output  [7:0] nvdla_core2cvsram_ar_arid;
output  [3:0] nvdla_core2cvsram_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] nvdla_core2cvsram_ar_araddr;

input          nvdla_core2cvsram_r_rvalid;
output         nvdla_core2cvsram_r_rready;
input    [7:0] nvdla_core2cvsram_r_rid;
input          nvdla_core2cvsram_r_rlast;
input  [NVDLA_SECONDARY_MEMIF_WIDTH-1:0] nvdla_core2cvsram_r_rdata;
#endif

output  dla_intr;

input [31:0] nvdla_pwrbus_ram_c_pd;
input [31:0] nvdla_pwrbus_ram_ma_pd;
input [31:0] nvdla_pwrbus_ram_mb_pd;
input [31:0] nvdla_pwrbus_ram_p_pd;
input [31:0] nvdla_pwrbus_ram_o_pd;
input [31:0] nvdla_pwrbus_ram_a_pd;
////////////////////////////////////////////////////////////////////////////////

wire   [2:0] accu2sc_credit_size;
wire         accu2sc_credit_vld;

#ifdef NVDLA_RETIMING_ENABLE
wire  [33:0] cacc2csb_resp_dst_pd;
wire         cacc2csb_resp_dst_valid;
wire  [33:0] cacc2csb_resp_src_pd;
wire         cacc2csb_resp_src_valid;
wire   [1:0] cacc2glb_done_intr_dst_pd;
wire   [1:0] cacc2glb_done_intr_src_pd;
#else
wire  [33:0] cacc2csb_resp_pd;
wire         cacc2csb_resp_valid;
wire   [1:0] cacc2glb_done_intr_pd;
#endif

wire [NVDLA_SDP_MAX_THROUGHPUT*32+2-1:0] cacc2sdp_pd;
wire         cacc2sdp_ready;
wire         cacc2sdp_valid;
wire  [33:0] cdma2csb_resp_pd;
wire         cdma2csb_resp_valid;

wire   [1:0] cdma_dat2glb_done_intr_pd;
wire   [1:0] cdma_wt2glb_done_intr_pd;
#ifdef NVDLA_RETIMING_ENABLE
wire  [33:0] cmac_a2csb_resp_src_pd;
wire         cmac_a2csb_resp_src_valid;
wire  [33:0] cmac_b2csb_resp_dst_pd;
wire         cmac_b2csb_resp_dst_valid;
wire  [33:0] cmac_b2csb_resp_src_pd;
wire         cmac_b2csb_resp_src_valid;
#else
wire  [33:0] cmac_a2csb_resp_pd;
wire         cmac_a2csb_resp_valid;
wire  [33:0] cmac_b2csb_resp_pd;
wire         cmac_b2csb_resp_valid;
#endif
wire  [62:0] csb2cdma_req_pd;
wire         csb2cdma_req_prdy;
wire         csb2cdma_req_pvld;
#ifdef NVDLA_RETIMING_ENABLE
wire  [62:0] csb2cacc_req_dst_pd;
wire         csb2cacc_req_dst_prdy;
wire         csb2cacc_req_dst_pvld;
wire  [62:0] csb2cacc_req_src_pd;
wire         csb2cacc_req_src_prdy;
wire         csb2cacc_req_src_pvld;
wire  [62:0] csb2cmac_a_req_dst_pd;
wire         csb2cmac_a_req_dst_prdy;
wire         csb2cmac_a_req_dst_pvld;
wire  [62:0] csb2cmac_b_req_dst_pd;
wire         csb2cmac_b_req_dst_prdy;
wire         csb2cmac_b_req_dst_pvld;
wire  [62:0] csb2cmac_b_req_src_pd;
wire         csb2cmac_b_req_src_prdy;
wire         csb2cmac_b_req_src_pvld;
#else
wire  [62:0] csb2cacc_req_pd;
wire         csb2cacc_req_prdy;
wire         csb2cacc_req_pvld;
wire  [62:0] csb2cmac_a_req_pd;
wire         csb2cmac_a_req_prdy;
wire         csb2cmac_a_req_pvld;
wire  [62:0] csb2cmac_b_req_pd;
wire         csb2cmac_b_req_prdy;
wire         csb2cmac_b_req_pvld;
#endif
wire  [62:0] csb2csc_req_pd;
wire         csb2csc_req_prdy;
wire         csb2csc_req_pvld;
wire  [62:0] csb2sdp_rdma_req_pd;
wire         csb2sdp_rdma_req_prdy;
wire         csb2sdp_rdma_req_pvld;
wire  [62:0] csb2sdp_req_pd;
wire         csb2sdp_req_prdy;
wire         csb2sdp_req_pvld;
wire  [33:0] csc2csb_resp_pd;
wire         csc2csb_resp_valid;

#ifdef NVDLA_RETIMING_ENABLE
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: wire [CMAC_RESULT_WIDTH-1:0] mac_a2accu_dst_data${i};   )
//: }
wire   [CMAC_ATOMK/2-1:0] mac_a2accu_dst_mask;
wire                      mac_a2accu_dst_mode;
wire   [8:0] mac_a2accu_dst_pd;
wire         mac_a2accu_dst_pvld;
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: wire [CMAC_RESULT_WIDTH-1:0] mac_a2accu_src_data${i};   )
//: }
wire   [CMAC_ATOMK/2-1:0] mac_a2accu_src_mask;
wire                      mac_a2accu_src_mode;
wire   [8:0] mac_a2accu_src_pd;
wire         mac_a2accu_src_pvld;
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: wire [CMAC_RESULT_WIDTH-1:0] mac_b2accu_src_data${i};   )
//: }
wire   [CMAC_ATOMK/2-1:0] mac_b2accu_src_mask;
wire                      mac_b2accu_src_mode;
wire   [8:0] mac_b2accu_src_pd;
wire         mac_b2accu_src_pvld;
#else
//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//: print qq(
//: wire [CMAC_RESULT_WIDTH-1:0] mac_a2accu_data${i};
//: wire [CMAC_RESULT_WIDTH-1:0] mac_b2accu_data${i};
//: );
//: }
wire   [CMAC_ATOMK/2-1:0] mac_a2accu_mask;
wire                      mac_a2accu_mode;
wire   [8:0] mac_a2accu_pd;
wire         mac_a2accu_pvld;
wire   [CMAC_ATOMK/2-1:0] mac_b2accu_mask;
wire                      mac_b2accu_mode;
wire   [8:0] mac_b2accu_pd;
wire         mac_b2accu_pvld;
#endif
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]        cdma_dat2cvif_rd_req_pd;
wire                                        cdma_dat2cvif_rd_req_ready;
wire                                        cdma_dat2cvif_rd_req_valid;
wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]        cdma_wt2cvif_rd_req_pd;
wire                                        cdma_wt2cvif_rd_req_ready;
wire                                        cdma_wt2cvif_rd_req_valid;
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] cvif2cdma_dat_rd_rsp_pd;
wire                                        cvif2cdma_dat_rd_rsp_ready;
wire                                        cvif2cdma_dat_rd_rsp_valid;
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] cvif2cdma_wt_rd_rsp_pd;
wire                                        cvif2cdma_wt_rd_rsp_ready;
wire                                        cvif2cdma_wt_rd_rsp_valid;
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] cvif2sdp_rd_rsp_pd;
wire                                        cvif2sdp_rd_rsp_ready;
wire                                        cvif2sdp_rd_rsp_valid;
wire                                        cvif2sdp_wr_rsp_complete;
wire                                        sdp2cvif_rd_cdt_lat_fifo_pop;
wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]        sdp2cvif_rd_req_pd;
wire                                        sdp2cvif_rd_req_ready;
wire                                        sdp2cvif_rd_req_valid;
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT:0] sdp2cvif_wr_req_pd;
wire                                        sdp2cvif_wr_req_ready;
wire                                        sdp2cvif_wr_req_valid;
#ifdef NVDLA_SDP_BS_ENABLE
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] cvif2sdp_b_rd_rsp_pd;
wire                                        cvif2sdp_b_rd_rsp_ready;
wire                                        cvif2sdp_b_rd_rsp_valid;
wire                                        sdp_b2cvif_rd_cdt_lat_fifo_pop;
wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]        sdp_b2cvif_rd_req_pd;
wire                                        sdp_b2cvif_rd_req_ready;
wire                                        sdp_b2cvif_rd_req_valid;
#endif
#ifdef NVDLA_SDP_EW_ENABLE
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] cvif2sdp_e_rd_rsp_pd;
wire                                        cvif2sdp_e_rd_rsp_ready;
wire                                        cvif2sdp_e_rd_rsp_valid;
wire                                        sdp_e2cvif_rd_cdt_lat_fifo_pop;
wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]        sdp_e2cvif_rd_req_pd;
wire                                        sdp_e2cvif_rd_req_ready;
wire                                        sdp_e2cvif_rd_req_valid;
#endif
#ifdef NVDLA_SDP_BN_ENABLE
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] cvif2sdp_n_rd_rsp_pd;
wire                                        cvif2sdp_n_rd_rsp_ready;
wire                                        cvif2sdp_n_rd_rsp_valid;
wire                                        sdp_n2cvif_rd_cdt_lat_fifo_pop;
wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]        sdp_n2cvif_rd_req_pd;
wire                                        sdp_n2cvif_rd_req_ready;
wire                                        sdp_n2cvif_rd_req_valid;
#endif
#endif
wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]        cdma_dat2mcif_rd_req_pd;
wire                                        cdma_dat2mcif_rd_req_ready;
wire                                        cdma_dat2mcif_rd_req_valid;
wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]        cdma_wt2mcif_rd_req_pd;
wire                                        cdma_wt2mcif_rd_req_ready;
wire                                        cdma_wt2mcif_rd_req_valid;
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] mcif2cdma_dat_rd_rsp_pd;
wire                                        mcif2cdma_dat_rd_rsp_ready;
wire                                        mcif2cdma_dat_rd_rsp_valid;
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] mcif2cdma_wt_rd_rsp_pd;
wire                                        mcif2cdma_wt_rd_rsp_ready;
wire                                        mcif2cdma_wt_rd_rsp_valid;
#ifdef NVDLA_SDP_BS_ENABLE
  wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] mcif2sdp_b_rd_rsp_pd;
  wire                                      mcif2sdp_b_rd_rsp_ready;
  wire                                      mcif2sdp_b_rd_rsp_valid;
  wire                                      sdp_b2mcif_rd_cdt_lat_fifo_pop;
  wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]      sdp_b2mcif_rd_req_pd;
  wire                                      sdp_b2mcif_rd_req_ready;
  wire                                      sdp_b2mcif_rd_req_valid;
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] mcif2sdp_e_rd_rsp_pd;
  wire                                      mcif2sdp_e_rd_rsp_ready;
  wire                                      mcif2sdp_e_rd_rsp_valid;
  wire                                      sdp_e2mcif_rd_cdt_lat_fifo_pop;
  wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]      sdp_e2mcif_rd_req_pd;
  wire                                      sdp_e2mcif_rd_req_ready;
  wire                                      sdp_e2mcif_rd_req_valid;
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] mcif2sdp_n_rd_rsp_pd;
  wire                                      mcif2sdp_n_rd_rsp_ready;
  wire                                      mcif2sdp_n_rd_rsp_valid;
  wire                                      sdp_n2mcif_rd_cdt_lat_fifo_pop;
  wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]      sdp_n2mcif_rd_req_pd;
  wire                                      sdp_n2mcif_rd_req_ready;
  wire                                      sdp_n2mcif_rd_req_valid;
#endif
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] mcif2sdp_rd_rsp_pd;
wire                                        mcif2sdp_rd_rsp_ready;
wire                                        mcif2sdp_rd_rsp_valid;
wire                                        mcif2sdp_wr_rsp_complete;
wire                                        sdp2mcif_rd_cdt_lat_fifo_pop;
wire  [NVDLA_MEM_ADDRESS_WIDTH+14:0]        sdp2mcif_rd_req_pd;
wire                                        sdp2mcif_rd_req_ready;
wire                                        sdp2mcif_rd_req_valid;
wire [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT:0]  sdp2mcif_wr_req_pd;
wire                                        sdp2mcif_wr_req_ready;
wire                                        sdp2mcif_wr_req_valid;

wire  [33:0] sdp2csb_resp_pd;
wire         sdp2csb_resp_valid;
wire   [1:0] sdp2glb_done_intr_pd;
wire [NVDLA_SDP_MAX_THROUGHPUT*NVDLA_BPE-1:0] sdp2pdp_pd;
wire         sdp2pdp_ready;
wire         sdp2pdp_valid;
wire  [33:0] sdp_rdma2csb_resp_pd;
wire         sdp_rdma2csb_resp_valid;

wire         nvdla_clk_ovr_on;
wire         nvdla_core_rstn;

#ifdef NVDLA_RETIMING_ENABLE
//: my $kk=CSC_ATOMC-1;
//: foreach my $i (0..${kk}) {
//: print qq(
//:     wire   [7:0] sc2mac_dat_a_dst_data${i};
//:     wire   [7:0] sc2mac_dat_a_src_data${i};
//:     wire   [7:0] sc2mac_dat_b_dst_data${i};
//:     wire   [7:0] sc2mac_wt_a_dst_data${i};
//:     wire   [7:0] sc2mac_wt_a_src_data${i};
//:     wire   [7:0] sc2mac_wt_b_dst_data${i};
//: );
//: }
wire [CSC_ATOMC-1:0] sc2mac_dat_a_dst_mask;
wire [8:0] sc2mac_dat_a_dst_pd;
wire         sc2mac_dat_a_dst_pvld;
wire [CSC_ATOMC-1:0] sc2mac_dat_a_src_mask;
wire [8:0] sc2mac_dat_a_src_pd;
wire         sc2mac_dat_a_src_pvld;
wire [CSC_ATOMC-1:0] sc2mac_dat_b_dst_mask;
wire [8:0] sc2mac_dat_b_dst_pd;
wire         sc2mac_dat_b_dst_pvld;
wire [CSC_ATOMC-1:0] sc2mac_wt_a_dst_mask;
wire         sc2mac_wt_a_dst_pvld;
wire [CSC_ATOMK/2-1:0] sc2mac_wt_a_dst_sel;
wire [CSC_ATOMC-1:0] sc2mac_wt_a_src_mask;
wire         sc2mac_wt_a_src_pvld;
wire [CSC_ATOMK/2-1:0] sc2mac_wt_a_src_sel;
wire [CSC_ATOMC-1:0] sc2mac_wt_b_dst_mask;
wire         sc2mac_wt_b_dst_pvld;
wire [CSC_ATOMK/2-1:0] sc2mac_wt_b_dst_sel;
#else
//: my $kk=CSC_ATOMC-1;
//: foreach my $i (0..${kk}) {
//: print qq(
//:     wire   [CSC_BPE-1:0] sc2mac_dat_a_data${i};
//:     wire   [CSC_BPE-1:0] sc2mac_dat_b_data${i};
//:     wire   [CSC_BPE-1:0] sc2mac_wt_a_data${i};
//:     wire   [CSC_BPE-1:0] sc2mac_wt_b_data${i};
//: );
//: }
wire [CSC_ATOMC-1:0] sc2mac_dat_a_mask;
wire [8:0] sc2mac_dat_a_pd;
wire         sc2mac_dat_a_pvld;
wire [CSC_ATOMC-1:0] sc2mac_dat_b_mask;
wire [8:0] sc2mac_dat_b_pd;
wire         sc2mac_dat_b_pvld;
wire [CSC_ATOMC-1:0] sc2mac_wt_a_mask;
wire         sc2mac_wt_a_pvld;
wire [CSC_ATOMK/2-1:0] sc2mac_wt_a_sel;
wire [CSC_ATOMC-1:0] sc2mac_wt_b_mask;
wire         sc2mac_wt_b_pvld;
wire [CSC_ATOMK/2-1:0] sc2mac_wt_b_sel;
#endif
////////////////////////////////////////////////////////////////////////////////

#ifndef NVDLA_SECONDARY_MEMIF_ENABLE
   assign nvdla_core2cvsram_aw_awvalid = 1'b0;
   assign nvdla_core2cvsram_w_wvalid = 1'b0;
   assign nvdla_core2cvsram_w_wlast = 1'b0;
   assign nvdla_core2cvsram_b_bready = 1'b1;
   assign nvdla_core2cvsram_r_rready = 1'b1;
#endif

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O                                                 //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_o u_partition_o (
   .test_mode                      (test_mode)                     
  ,.direct_reset_                  (direct_reset_)                 
  ,.global_clk_ovr_on              (global_clk_ovr_on)             
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating) 
#ifdef NVDLA_RETIMING_ENABLE
  ,.cacc2csb_resp_dst_valid        (cacc2csb_resp_dst_valid)       
  ,.cacc2csb_resp_dst_pd           (cacc2csb_resp_dst_pd[33:0])    
  ,.cacc2glb_done_intr_dst_pd      (cacc2glb_done_intr_dst_pd[1:0])
  ,.csb2cacc_req_src_pvld          (csb2cacc_req_src_pvld)         
  ,.csb2cacc_req_src_prdy          (csb2cacc_req_src_prdy)         
  ,.csb2cacc_req_src_pd            (csb2cacc_req_src_pd[62:0])     
  ,.cmac_a2csb_resp_src_valid      (cmac_a2csb_resp_src_valid)     
  ,.cmac_a2csb_resp_src_pd         (cmac_a2csb_resp_src_pd[33:0])  
  ,.cmac_b2csb_resp_dst_valid      (cmac_b2csb_resp_dst_valid)     
  ,.cmac_b2csb_resp_dst_pd         (cmac_b2csb_resp_dst_pd[33:0])  
  ,.csb2cmac_a_req_dst_pvld        (csb2cmac_a_req_dst_pvld)       
  ,.csb2cmac_a_req_dst_prdy        (csb2cmac_a_req_dst_prdy)       
  ,.csb2cmac_a_req_dst_pd          (csb2cmac_a_req_dst_pd[62:0])   
  ,.csb2cmac_b_req_src_pvld        (csb2cmac_b_req_src_pvld)       
  ,.csb2cmac_b_req_src_prdy        (csb2cmac_b_req_src_prdy)       
  ,.csb2cmac_b_req_src_pd          (csb2cmac_b_req_src_pd[62:0])   
#else
  ,.cacc2csb_resp_valid        (cacc2csb_resp_valid)               
  ,.cacc2csb_resp_pd           (cacc2csb_resp_pd[33:0])            
  ,.cacc2glb_done_intr_pd      (cacc2glb_done_intr_pd[1:0])        
  ,.csb2cacc_req_pvld          (csb2cacc_req_pvld)                 
  ,.csb2cacc_req_prdy          (csb2cacc_req_prdy)                 
  ,.csb2cacc_req_pd            (csb2cacc_req_pd[62:0])             
  ,.cmac_a2csb_resp_valid      (cmac_a2csb_resp_valid)             
  ,.cmac_a2csb_resp_pd         (cmac_a2csb_resp_pd[33:0])          
  ,.cmac_b2csb_resp_valid      (cmac_b2csb_resp_valid)             
  ,.cmac_b2csb_resp_pd         (cmac_b2csb_resp_pd[33:0])          
  ,.csb2cmac_a_req_pvld        (csb2cmac_a_req_pvld)               
  ,.csb2cmac_a_req_prdy        (csb2cmac_a_req_prdy)               
  ,.csb2cmac_a_req_pd          (csb2cmac_a_req_pd[62:0])           
  ,.csb2cmac_b_req_pvld        (csb2cmac_b_req_pvld)               
  ,.csb2cmac_b_req_prdy        (csb2cmac_b_req_prdy)               
  ,.csb2cmac_b_req_pd          (csb2cmac_b_req_pd[62:0])           
#endif
  ,.cdma2csb_resp_valid            (cdma2csb_resp_valid)            
  ,.cdma2csb_resp_pd               (cdma2csb_resp_pd[33:0])         
  ,.cdma_dat2glb_done_intr_pd      (cdma_dat2glb_done_intr_pd[1:0]) 
  ,.cdma_dat2mcif_rd_req_valid     (cdma_dat2mcif_rd_req_valid)     
  ,.cdma_dat2mcif_rd_req_ready     (cdma_dat2mcif_rd_req_ready)     
  ,.cdma_dat2mcif_rd_req_pd        (cdma_dat2mcif_rd_req_pd)  
  ,.cdma_wt2glb_done_intr_pd       (cdma_wt2glb_done_intr_pd[1:0])  
  ,.cdma_wt2mcif_rd_req_valid      (cdma_wt2mcif_rd_req_valid)      
  ,.cdma_wt2mcif_rd_req_ready      (cdma_wt2mcif_rd_req_ready)      
  ,.cdma_wt2mcif_rd_req_pd         (cdma_wt2mcif_rd_req_pd)     
  ,.csb2cdma_req_pvld              (csb2cdma_req_pvld)                
  ,.csb2cdma_req_prdy              (csb2cdma_req_prdy)                
  ,.csb2cdma_req_pd                (csb2cdma_req_pd[62:0])            
  ,.csb2csc_req_pvld               (csb2csc_req_pvld)                 
  ,.csb2csc_req_prdy               (csb2csc_req_prdy)                 
  ,.csb2csc_req_pd                 (csb2csc_req_pd[62:0])             
  ,.csb2nvdla_valid                (csb2nvdla_valid)                  
  ,.csb2nvdla_ready                (csb2nvdla_ready)                  
  ,.csb2nvdla_addr                 (csb2nvdla_addr[15:0])             
  ,.csb2nvdla_wdat                 (csb2nvdla_wdat[31:0])             
  ,.csb2nvdla_write                (csb2nvdla_write)                  
  ,.csb2nvdla_nposted              (csb2nvdla_nposted)                
  ,.csb2sdp_rdma_req_pvld          (csb2sdp_rdma_req_pvld)            
  ,.csb2sdp_rdma_req_prdy          (csb2sdp_rdma_req_prdy)            
  ,.csb2sdp_rdma_req_pd            (csb2sdp_rdma_req_pd[62:0])        
  ,.csb2sdp_req_pvld               (csb2sdp_req_pvld)                 
  ,.csb2sdp_req_prdy               (csb2sdp_req_prdy)                 
  ,.csb2sdp_req_pd                 (csb2sdp_req_pd[62:0])             
  ,.csc2csb_resp_valid             (csc2csb_resp_valid)               
  ,.csc2csb_resp_pd                (csc2csb_resp_pd[33:0])            
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif2noc_axi_ar_arvalid        (nvdla_core2cvsram_ar_arvalid)     
  ,.cvif2noc_axi_ar_arready        (nvdla_core2cvsram_ar_arready)     
  ,.cvif2noc_axi_ar_arid           (nvdla_core2cvsram_ar_arid[7:0])   
  ,.cvif2noc_axi_ar_arlen          (nvdla_core2cvsram_ar_arlen[3:0])  
  ,.cvif2noc_axi_ar_araddr         (nvdla_core2cvsram_ar_araddr)
  ,.cvif2noc_axi_aw_awvalid        (nvdla_core2cvsram_aw_awvalid)     
  ,.cvif2noc_axi_aw_awready        (nvdla_core2cvsram_aw_awready)     
  ,.cvif2noc_axi_aw_awid           (nvdla_core2cvsram_aw_awid[7:0])   
  ,.cvif2noc_axi_aw_awlen          (nvdla_core2cvsram_aw_awlen[3:0])  
  ,.cvif2noc_axi_aw_awaddr         (nvdla_core2cvsram_aw_awaddr)
  ,.cvif2noc_axi_w_wvalid          (nvdla_core2cvsram_w_wvalid)       
  ,.cvif2noc_axi_w_wready          (nvdla_core2cvsram_w_wready)       
  ,.cvif2noc_axi_w_wdata           (nvdla_core2cvsram_w_wdata) 
  ,.cvif2noc_axi_w_wstrb           (nvdla_core2cvsram_w_wstrb)  
  ,.cvif2noc_axi_w_wlast           (nvdla_core2cvsram_w_wlast)        
  ,.noc2cvif_axi_b_bvalid          (nvdla_core2cvsram_b_bvalid)       
  ,.noc2cvif_axi_b_bready          (nvdla_core2cvsram_b_bready)       
  ,.noc2cvif_axi_b_bid             (nvdla_core2cvsram_b_bid[7:0])     
  ,.noc2cvif_axi_r_rvalid          (nvdla_core2cvsram_r_rvalid)       
  ,.noc2cvif_axi_r_rready          (nvdla_core2cvsram_r_rready)       
  ,.noc2cvif_axi_r_rid             (nvdla_core2cvsram_r_rid[7:0])     
  ,.noc2cvif_axi_r_rlast           (nvdla_core2cvsram_r_rlast)        
  ,.noc2cvif_axi_r_rdata           (nvdla_core2cvsram_r_rdata) 

  ,.cdma_dat2cvif_rd_req_valid     (cdma_dat2cvif_rd_req_valid)       
  ,.cdma_dat2cvif_rd_req_ready     (cdma_dat2cvif_rd_req_ready)       
  ,.cdma_dat2cvif_rd_req_pd        (cdma_dat2cvif_rd_req_pd)    
  ,.cdma_wt2cvif_rd_req_valid      (cdma_wt2cvif_rd_req_valid)        
  ,.cdma_wt2cvif_rd_req_ready      (cdma_wt2cvif_rd_req_ready) 
  ,.cdma_wt2cvif_rd_req_pd         (cdma_wt2cvif_rd_req_pd)   
  ,.cvif2cdma_dat_rd_rsp_valid     (cvif2cdma_dat_rd_rsp_valid)     
  ,.cvif2cdma_dat_rd_rsp_ready     (cvif2cdma_dat_rd_rsp_ready)     
  ,.cvif2cdma_dat_rd_rsp_pd        (cvif2cdma_dat_rd_rsp_pd) 
  ,.cvif2cdma_wt_rd_rsp_valid      (cvif2cdma_wt_rd_rsp_valid)      
  ,.cvif2cdma_wt_rd_rsp_ready      (cvif2cdma_wt_rd_rsp_ready)      
  ,.cvif2cdma_wt_rd_rsp_pd         (cvif2cdma_wt_rd_rsp_pd)  
#ifdef NVDLA_SDP_BS_ENABLE
  ,.sdp_b2cvif_rd_cdt_lat_fifo_pop (sdp_b2cvif_rd_cdt_lat_fifo_pop) 
  ,.sdp_b2cvif_rd_req_valid        (sdp_b2cvif_rd_req_valid)        
  ,.sdp_b2cvif_rd_req_ready        (sdp_b2cvif_rd_req_ready)        
  ,.sdp_b2cvif_rd_req_pd           (sdp_b2cvif_rd_req_pd)     
  ,.cvif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)        
  ,.cvif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)        
  ,.cvif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd)    
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop) 
  ,.sdp_e2cvif_rd_req_valid        (sdp_e2cvif_rd_req_valid)        
  ,.sdp_e2cvif_rd_req_ready        (sdp_e2cvif_rd_req_ready)        
  ,.sdp_e2cvif_rd_req_pd           (sdp_e2cvif_rd_req_pd)     
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)        
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)        
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd)    
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  ,.sdp_n2cvif_rd_cdt_lat_fifo_pop (sdp_n2cvif_rd_cdt_lat_fifo_pop) 
  ,.sdp_n2cvif_rd_req_valid        (sdp_n2cvif_rd_req_valid)        
  ,.sdp_n2cvif_rd_req_ready        (sdp_n2cvif_rd_req_ready)        
  ,.sdp_n2cvif_rd_req_pd           (sdp_n2cvif_rd_req_pd)     
  ,.cvif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)        
  ,.cvif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)        
  ,.cvif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd)    
#endif
  ,.sdp2cvif_rd_cdt_lat_fifo_pop   (sdp2cvif_rd_cdt_lat_fifo_pop)   
  ,.sdp2cvif_rd_req_valid          (sdp2cvif_rd_req_valid)          
  ,.sdp2cvif_rd_req_ready          (sdp2cvif_rd_req_ready)          
  ,.sdp2cvif_rd_req_pd             (sdp2cvif_rd_req_pd)       
  ,.sdp2cvif_wr_req_valid          (sdp2cvif_wr_req_valid)          
  ,.sdp2cvif_wr_req_ready          (sdp2cvif_wr_req_ready)          
  ,.sdp2cvif_wr_req_pd             (sdp2cvif_wr_req_pd)      
  ,.cvif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)          
  ,.cvif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)          
  ,.cvif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd)      
  ,.cvif2sdp_wr_rsp_complete       (cvif2sdp_wr_rsp_complete)       
#endif
  ,.mcif2noc_axi_ar_arvalid        (nvdla_core2dbb_ar_arvalid)      
  ,.mcif2noc_axi_ar_arready        (nvdla_core2dbb_ar_arready)      
  ,.mcif2noc_axi_ar_arid           (nvdla_core2dbb_ar_arid[7:0])    
  ,.mcif2noc_axi_ar_arlen          (nvdla_core2dbb_ar_arlen[3:0])   
  ,.mcif2noc_axi_ar_araddr         (nvdla_core2dbb_ar_araddr) 
  ,.mcif2noc_axi_aw_awvalid        (nvdla_core2dbb_aw_awvalid)      
  ,.mcif2noc_axi_aw_awready        (nvdla_core2dbb_aw_awready)      
  ,.mcif2noc_axi_aw_awid           (nvdla_core2dbb_aw_awid[7:0])    
  ,.mcif2noc_axi_aw_awlen          (nvdla_core2dbb_aw_awlen[3:0])   
  ,.mcif2noc_axi_aw_awaddr         (nvdla_core2dbb_aw_awaddr) 
  ,.mcif2noc_axi_w_wvalid          (nvdla_core2dbb_w_wvalid)        
  ,.mcif2noc_axi_w_wready          (nvdla_core2dbb_w_wready)        
  ,.mcif2noc_axi_w_wdata           (nvdla_core2dbb_w_wdata)  
  ,.mcif2noc_axi_w_wstrb           (nvdla_core2dbb_w_wstrb)   
  ,.mcif2noc_axi_w_wlast           (nvdla_core2dbb_w_wlast)         
  ,.noc2mcif_axi_b_bvalid          (nvdla_core2dbb_b_bvalid)        
  ,.noc2mcif_axi_b_bready          (nvdla_core2dbb_b_bready)        
  ,.noc2mcif_axi_b_bid             (nvdla_core2dbb_b_bid[7:0])      
  ,.noc2mcif_axi_r_rvalid          (nvdla_core2dbb_r_rvalid)        
  ,.noc2mcif_axi_r_rready          (nvdla_core2dbb_r_rready)        
  ,.noc2mcif_axi_r_rid             (nvdla_core2dbb_r_rid[7:0])      
  ,.noc2mcif_axi_r_rlast           (nvdla_core2dbb_r_rlast)         
  ,.noc2mcif_axi_r_rdata           (nvdla_core2dbb_r_rdata)  
  ,.mcif2cdma_dat_rd_rsp_valid     (mcif2cdma_dat_rd_rsp_valid)     
  ,.mcif2cdma_dat_rd_rsp_ready     (mcif2cdma_dat_rd_rsp_ready)     
  ,.mcif2cdma_dat_rd_rsp_pd        (mcif2cdma_dat_rd_rsp_pd) 
  ,.mcif2cdma_wt_rd_rsp_valid      (mcif2cdma_wt_rd_rsp_valid)      
  ,.mcif2cdma_wt_rd_rsp_ready      (mcif2cdma_wt_rd_rsp_ready)      
  ,.mcif2cdma_wt_rd_rsp_pd         (mcif2cdma_wt_rd_rsp_pd)  
#ifdef NVDLA_SDP_BS_ENABLE
  ,.mcif2sdp_b_rd_rsp_valid        (mcif2sdp_b_rd_rsp_valid)        
  ,.mcif2sdp_b_rd_rsp_ready        (mcif2sdp_b_rd_rsp_ready)        
  ,.mcif2sdp_b_rd_rsp_pd           (mcif2sdp_b_rd_rsp_pd)    
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop (sdp_b2mcif_rd_cdt_lat_fifo_pop) 
  ,.sdp_b2mcif_rd_req_valid        (sdp_b2mcif_rd_req_valid)        
  ,.sdp_b2mcif_rd_req_ready        (sdp_b2mcif_rd_req_ready)        
  ,.sdp_b2mcif_rd_req_pd           (sdp_b2mcif_rd_req_pd)     
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  ,.mcif2sdp_e_rd_rsp_valid        (mcif2sdp_e_rd_rsp_valid)        
  ,.mcif2sdp_e_rd_rsp_ready        (mcif2sdp_e_rd_rsp_ready)        
  ,.mcif2sdp_e_rd_rsp_pd           (mcif2sdp_e_rd_rsp_pd)    
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2mcif_rd_cdt_lat_fifo_pop) 
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2mcif_rd_req_valid)        
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2mcif_rd_req_ready)        
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2mcif_rd_req_pd)     
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  ,.mcif2sdp_n_rd_rsp_valid        (mcif2sdp_n_rd_rsp_valid)        
  ,.mcif2sdp_n_rd_rsp_ready        (mcif2sdp_n_rd_rsp_ready)        
  ,.mcif2sdp_n_rd_rsp_pd           (mcif2sdp_n_rd_rsp_pd) 
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop (sdp_n2mcif_rd_cdt_lat_fifo_pop) 
  ,.sdp_n2mcif_rd_req_valid        (sdp_n2mcif_rd_req_valid)     
  ,.sdp_n2mcif_rd_req_ready        (sdp_n2mcif_rd_req_ready)     
  ,.sdp_n2mcif_rd_req_pd           (sdp_n2mcif_rd_req_pd)  
#endif
  ,.mcif2sdp_rd_rsp_valid          (mcif2sdp_rd_rsp_valid)       
  ,.mcif2sdp_rd_rsp_ready          (mcif2sdp_rd_rsp_ready)       
  ,.mcif2sdp_rd_rsp_pd             (mcif2sdp_rd_rsp_pd)   
  ,.mcif2sdp_wr_rsp_complete       (mcif2sdp_wr_rsp_complete)    
  ,.sdp2mcif_rd_cdt_lat_fifo_pop   (sdp2mcif_rd_cdt_lat_fifo_pop)
  ,.sdp2mcif_rd_req_valid          (sdp2mcif_rd_req_valid)       
  ,.sdp2mcif_rd_req_ready          (sdp2mcif_rd_req_ready)       
  ,.sdp2mcif_rd_req_pd             (sdp2mcif_rd_req_pd)    
  ,.sdp2mcif_wr_req_valid          (sdp2mcif_wr_req_valid)       
  ,.sdp2mcif_wr_req_ready          (sdp2mcif_wr_req_ready)       
  ,.sdp2mcif_wr_req_pd             (sdp2mcif_wr_req_pd)   
  ,.nvdla2csb_valid                (nvdla2csb_valid)             
  ,.nvdla2csb_data                 (nvdla2csb_data[31:0])        
  ,.nvdla2csb_wr_complete          (nvdla2csb_wr_complete)       
  ,.core_intr                      (dla_intr)                    
  ,.pwrbus_ram_pd                  (nvdla_pwrbus_ram_o_pd[31:0]) 
  ,.sdp2csb_resp_valid             (sdp2csb_resp_valid)          
  ,.sdp2csb_resp_pd                (sdp2csb_resp_pd[33:0])       
  ,.sdp2glb_done_intr_pd           (sdp2glb_done_intr_pd[1:0])   
  ,.sdp2pdp_valid                  (sdp2pdp_valid)               
  ,.sdp2pdp_ready                  (sdp2pdp_ready)               
  ,.sdp2pdp_pd                     (sdp2pdp_pd)
  ,.sdp_rdma2csb_resp_valid        (sdp_rdma2csb_resp_valid)      
  ,.sdp_rdma2csb_resp_pd           (sdp_rdma2csb_resp_pd[33:0])   
  ,.nvdla_core_clk                 (dla_core_clk)                 
  ,.dla_reset_rstn                 (dla_reset_rstn)               
  ,.nvdla_core_rstn                (nvdla_core_rstn)              
  ,.nvdla_falcon_clk               (dla_csb_clk)                  
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)             
#ifdef NVDLA_RETIMING_ENABLE
  ,.sc2mac_dat_a_dst_pvld          (sc2mac_dat_a_dst_pvld)        
  ,.sc2mac_dat_a_dst_mask          (sc2mac_dat_a_dst_mask[CSC_ATOMC-1:0]) 
  ,.sc2mac_dat_a_dst_pd            (sc2mac_dat_a_dst_pd[8:0])     
  ,.sc2mac_dat_a_src_pvld          (sc2mac_dat_a_src_pvld)        
  ,.sc2mac_dat_a_src_mask          (sc2mac_dat_a_src_mask[CSC_ATOMC-1:0]) 
  ,.sc2mac_dat_a_src_pd            (sc2mac_dat_a_src_pd[8:0])     
  ,.sc2mac_wt_a_dst_pvld           (sc2mac_wt_a_dst_pvld)         
  ,.sc2mac_wt_a_dst_mask           (sc2mac_wt_a_dst_mask[CSC_ATOMC-1:0])  
  ,.sc2mac_wt_a_dst_sel            (sc2mac_wt_a_dst_sel[CSC_ATOMK/2-1:0])     
  ,.sc2mac_wt_a_src_pvld           (sc2mac_wt_a_src_pvld)         
  ,.sc2mac_wt_a_src_mask           (sc2mac_wt_a_src_mask[CSC_ATOMC-1:0])  
  //: my $kk=CSC_ATOMC-1;
  //: foreach my $i (0..${kk}){
  //: print qq(
  //:     ,.sc2mac_dat_a_dst_data${i}         (sc2mac_dat_a_dst_data${i})
  //:     ,.sc2mac_dat_a_src_data${i}         (sc2mac_dat_a_src_data${i})
  //:     ,.sc2mac_wt_a_dst_data${i}          (sc2mac_wt_a_dst_data${i})
  //:     ,.sc2mac_wt_a_src_data${i}          (sc2mac_wt_a_src_data${i})
  //: );
  //: }
  ,.sc2mac_wt_a_src_sel            (sc2mac_wt_a_src_sel[CSC_ATOMK/2-1:0]) 
#endif
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C                                                 //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_c u_partition_c (
   .test_mode                      (test_mode)                     
  ,.direct_reset_                  (direct_reset_)                 
  ,.global_clk_ovr_on              (global_clk_ovr_on)             
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating) 
  ,.accu2sc_credit_vld             (accu2sc_credit_vld)            
  ,.accu2sc_credit_size            (accu2sc_credit_size[2:0])      
#ifdef NVDLA_RETIMING_ENABLE
  ,.cacc2csb_resp_dst_valid        (cacc2csb_resp_dst_valid)       
  ,.cacc2csb_resp_dst_pd           (cacc2csb_resp_dst_pd[33:0])    
  ,.cacc2csb_resp_src_valid        (cacc2csb_resp_src_valid)       
  ,.cacc2csb_resp_src_pd           (cacc2csb_resp_src_pd[33:0])    
  ,.cacc2glb_done_intr_dst_pd      (cacc2glb_done_intr_dst_pd[1:0])
  ,.cacc2glb_done_intr_src_pd      (cacc2glb_done_intr_src_pd[1:0])
  ,.cmac_b2csb_resp_dst_valid      (cmac_b2csb_resp_dst_valid)     
  ,.cmac_b2csb_resp_dst_pd         (cmac_b2csb_resp_dst_pd[33:0])  
  ,.cmac_b2csb_resp_src_valid      (cmac_b2csb_resp_src_valid)     
  ,.cmac_b2csb_resp_src_pd         (cmac_b2csb_resp_src_pd[33:0])  
  ,.csb2cacc_req_dst_pvld          (csb2cacc_req_dst_pvld)         
  ,.csb2cacc_req_dst_prdy          (csb2cacc_req_dst_prdy)         
  ,.csb2cacc_req_dst_pd            (csb2cacc_req_dst_pd[62:0])     
  ,.csb2cacc_req_src_pvld          (csb2cacc_req_src_pvld)         
  ,.csb2cacc_req_src_prdy          (csb2cacc_req_src_prdy)         
  ,.csb2cacc_req_src_pd            (csb2cacc_req_src_pd[62:0])     
  ,.csb2cmac_b_req_dst_pvld        (csb2cmac_b_req_dst_pvld)       
  ,.csb2cmac_b_req_dst_prdy        (csb2cmac_b_req_dst_prdy)       
  ,.csb2cmac_b_req_dst_pd          (csb2cmac_b_req_dst_pd[62:0])   
  ,.csb2cmac_b_req_src_pvld        (csb2cmac_b_req_src_pvld)       
  ,.csb2cmac_b_req_src_prdy        (csb2cmac_b_req_src_prdy)       
  ,.csb2cmac_b_req_src_pd          (csb2cmac_b_req_src_pd[62:0])   
#endif
  ,.cdma2csb_resp_valid            (cdma2csb_resp_valid)           
  ,.cdma2csb_resp_pd               (cdma2csb_resp_pd[33:0])        
  ,.cdma_dat2glb_done_intr_pd      (cdma_dat2glb_done_intr_pd[1:0])
  ,.cdma_dat2mcif_rd_req_valid     (cdma_dat2mcif_rd_req_valid)    
  ,.cdma_dat2mcif_rd_req_ready     (cdma_dat2mcif_rd_req_ready)    
  ,.cdma_dat2mcif_rd_req_pd        (cdma_dat2mcif_rd_req_pd) 
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cdma_dat2cvif_rd_req_valid     (cdma_dat2cvif_rd_req_valid)    
  ,.cdma_dat2cvif_rd_req_ready     (cdma_dat2cvif_rd_req_ready)    
  ,.cdma_dat2cvif_rd_req_pd        (cdma_dat2cvif_rd_req_pd) 
  ,.cdma_wt2cvif_rd_req_valid      (cdma_wt2cvif_rd_req_valid)     
  ,.cdma_wt2cvif_rd_req_ready      (cdma_wt2cvif_rd_req_ready)     
  ,.cdma_wt2cvif_rd_req_pd         (cdma_wt2cvif_rd_req_pd)  
  ,.cvif2cdma_dat_rd_rsp_valid     (cvif2cdma_dat_rd_rsp_valid)    
  ,.cvif2cdma_dat_rd_rsp_ready     (cvif2cdma_dat_rd_rsp_ready)    
  ,.cvif2cdma_dat_rd_rsp_pd        (cvif2cdma_dat_rd_rsp_pd)
  ,.cvif2cdma_wt_rd_rsp_valid      (cvif2cdma_wt_rd_rsp_valid)     
  ,.cvif2cdma_wt_rd_rsp_ready      (cvif2cdma_wt_rd_rsp_ready)     
  ,.cvif2cdma_wt_rd_rsp_pd         (cvif2cdma_wt_rd_rsp_pd) 
#endif
  ,.cdma_wt2glb_done_intr_pd       (cdma_wt2glb_done_intr_pd[1:0]) 
  ,.cdma_wt2mcif_rd_req_valid      (cdma_wt2mcif_rd_req_valid)     
  ,.cdma_wt2mcif_rd_req_ready      (cdma_wt2mcif_rd_req_ready)     
  ,.cdma_wt2mcif_rd_req_pd         (cdma_wt2mcif_rd_req_pd)  
  ,.csb2cdma_req_pvld              (csb2cdma_req_pvld)             
  ,.csb2cdma_req_prdy              (csb2cdma_req_prdy)             
  ,.csb2cdma_req_pd                (csb2cdma_req_pd[62:0])         
  ,.csb2csc_req_pvld               (csb2csc_req_pvld)              
  ,.csb2csc_req_prdy               (csb2csc_req_prdy)              
  ,.csb2csc_req_pd                 (csb2csc_req_pd[62:0])          
  ,.csc2csb_resp_valid             (csc2csb_resp_valid)            
  ,.csc2csb_resp_pd                (csc2csb_resp_pd[33:0])         
  ,.mcif2cdma_dat_rd_rsp_valid     (mcif2cdma_dat_rd_rsp_valid)    
  ,.mcif2cdma_dat_rd_rsp_ready     (mcif2cdma_dat_rd_rsp_ready)    
  ,.mcif2cdma_dat_rd_rsp_pd        (mcif2cdma_dat_rd_rsp_pd)
  ,.mcif2cdma_wt_rd_rsp_valid      (mcif2cdma_wt_rd_rsp_valid)     
  ,.mcif2cdma_wt_rd_rsp_ready      (mcif2cdma_wt_rd_rsp_ready)     
  ,.mcif2cdma_wt_rd_rsp_pd         (mcif2cdma_wt_rd_rsp_pd) 
  ,.pwrbus_ram_pd                  (nvdla_pwrbus_ram_c_pd[31:0])   
#ifdef NVDLA_RETIMING_ENABLE
  ,.sc2mac_dat_a_src_pvld          (sc2mac_dat_a_src_pvld)         
  ,.sc2mac_dat_a_src_mask          (sc2mac_dat_a_src_mask[CSC_ATOMC-1:0])  
  //: my $kk=CSC_ATOMC-1;
  //: foreach my $i (0..${kk}){
  //: print qq(
  //:     ,.sc2mac_dat_a_src_data${i}         (sc2mac_dat_a_src_data${i})
  //:     ,.sc2mac_dat_b_dst_data${i}         (sc2mac_dat_b_dst_data${i})
  //:     ,.sc2mac_wt_a_src_data${i}          (sc2mac_wt_a_src_data${i})
  //:     ,.sc2mac_wt_b_dst_data${i}          (sc2mac_wt_b_dst_data${i})
  //: );
  //: }
  ,.sc2mac_dat_a_src_pd            (sc2mac_dat_a_src_pd[8:0])    
  ,.sc2mac_dat_b_dst_pvld          (sc2mac_dat_b_dst_pvld)       
  ,.sc2mac_dat_b_dst_mask          (sc2mac_dat_b_dst_mask[CSC_ATOMC-1:0])
  ,.sc2mac_dat_b_dst_pd            (sc2mac_dat_b_dst_pd[8:0])    
  ,.sc2mac_wt_a_src_pvld           (sc2mac_wt_a_src_pvld)        
  ,.sc2mac_wt_a_src_mask           (sc2mac_wt_a_src_mask[CSC_ATOMC-1:0]) 
  ,.sc2mac_wt_a_src_sel            (sc2mac_wt_a_src_sel[CSC_ATOMK/2-1:0])    
  ,.sc2mac_wt_b_dst_pvld           (sc2mac_wt_b_dst_pvld)        
  ,.sc2mac_wt_b_dst_mask           (sc2mac_wt_b_dst_mask[CSC_ATOMC-1:0]) 
  ,.sc2mac_wt_b_dst_sel            (sc2mac_wt_b_dst_sel[CSC_ATOMK/2-1:0])    
#else
  ,.sc2mac_dat_a_pvld              (sc2mac_dat_a_pvld)           
  ,.sc2mac_dat_a_mask              (sc2mac_dat_a_mask[CSC_ATOMC-1:0])    
  //: my $kk=CSC_ATOMC-1;
  //: foreach my $i (0..${kk}){
  //: print qq(
  //:       ,.sc2mac_dat_a_data${i}             (sc2mac_dat_a_data${i})    
  //:       ,.sc2mac_dat_b_data${i}             (sc2mac_dat_b_data${i})
  //:       ,.sc2mac_wt_a_data${i}              (sc2mac_wt_a_data${i})
  //:       ,.sc2mac_wt_b_data${i}              (sc2mac_wt_b_data${i})
  //: );
  //: }
  ,.sc2mac_dat_a_pd                (sc2mac_dat_a_pd[8:0])       
  ,.sc2mac_dat_b_pvld              (sc2mac_dat_b_pvld)          
  ,.sc2mac_dat_b_mask              (sc2mac_dat_b_mask[CSC_ATOMC-1:0])   
  ,.sc2mac_dat_b_pd                (sc2mac_dat_b_pd[8:0])       
  ,.sc2mac_wt_a_pvld               (sc2mac_wt_a_pvld)           
  ,.sc2mac_wt_a_mask               (sc2mac_wt_a_mask[CSC_ATOMC-1:0])    
  ,.sc2mac_wt_a_sel                (sc2mac_wt_a_sel[CSC_ATOMK/2-1:0])       
  ,.sc2mac_wt_b_pvld               (sc2mac_wt_b_pvld)           
  ,.sc2mac_wt_b_mask               (sc2mac_wt_b_mask[CSC_ATOMC-1:0])    
  ,.sc2mac_wt_b_sel                (sc2mac_wt_b_sel[CSC_ATOMK/2-1:0])       
#endif
  ,.nvdla_core_clk                 (dla_core_clk)               
  ,.dla_reset_rstn                 (nvdla_core_rstn)            
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)           
  );
    //&Connect /nvdla_obs/        nvdla_pwrpart_c_obs;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition MA                                                //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_m u_partition_ma (
   .test_mode                      (test_mode)                    
  ,.direct_reset_                  (direct_reset_)                
#ifdef NVDLA_RETIMING_ENABLE
  ,.csb2cmac_a_req_pvld            (csb2cmac_a_req_dst_pvld)           //|< w
  ,.csb2cmac_a_req_prdy            (csb2cmac_a_req_dst_prdy)           //|> w
  ,.csb2cmac_a_req_pd              (csb2cmac_a_req_dst_pd)       //|< w
  ,.cmac_a2csb_resp_valid          (cmac_a2csb_resp_src_valid)         //|> w
  ,.cmac_a2csb_resp_pd             (cmac_a2csb_resp_src_pd)      //|> w
  ,.sc2mac_wt_pvld                 (sc2mac_wt_a_dst_pvld)              //|< w
  ,.sc2mac_wt_mask                 (sc2mac_wt_a_dst_mask)       //|< w
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_data${i}                (sc2mac_wt_a_dst_data${i})        //|< w )
  //: }
  ,.sc2mac_wt_sel                  (sc2mac_wt_a_dst_sel)          //|< w
  ,.sc2mac_dat_pvld                (sc2mac_dat_a_dst_pvld)             //|< w
  ,.sc2mac_dat_mask                (sc2mac_dat_a_dst_mask)      //|< w
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_data${i}                (sc2mac_dat_a_dst_data${i})        //|< w )
  //: }
  ,.sc2mac_dat_pd                  (sc2mac_dat_a_dst_pd)          //|< w
  ,.mac2accu_pvld                  (mac_a2accu_src_pvld)               //|> w
  ,.mac2accu_mask                  (mac_a2accu_src_mask)          //|> w
  ,.mac2accu_mode                  (mac_a2accu_src_mode)          //|> w
  //: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
  //: print qq(
  //: ,.mac2accu_data${i}                 (mac_a2accu_src_data${i})       //|> w )
  //: }
  ,.mac2accu_pd                    (mac_a2accu_src_pd)            //|> w
#else
  ,.csb2cmac_a_req_pvld            (csb2cmac_a_req_pvld)               //|< w
  ,.csb2cmac_a_req_prdy            (csb2cmac_a_req_prdy)               //|> w
  ,.csb2cmac_a_req_pd              (csb2cmac_a_req_pd)           //|< w
  ,.cmac_a2csb_resp_valid          (cmac_a2csb_resp_valid)             //|> w
  ,.cmac_a2csb_resp_pd             (cmac_a2csb_resp_pd)          //|> w
  ,.sc2mac_wt_pvld                 (sc2mac_wt_a_pvld)                  //|< w
  ,.sc2mac_wt_mask                 (sc2mac_wt_a_mask)           //|< w
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_data${i}                (sc2mac_wt_a_data${i})        //|< w )
  //: }
  ,.sc2mac_wt_sel                  (sc2mac_wt_a_sel)              //|< w
  ,.sc2mac_dat_pvld                (sc2mac_dat_a_pvld)                 //|< w
  ,.sc2mac_dat_mask                (sc2mac_dat_a_mask)          //|< w
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_data${i}                (sc2mac_dat_a_data${i})        //|< w )
  //: }
  ,.sc2mac_dat_pd                  (sc2mac_dat_a_pd)              //|< w
  ,.mac2accu_pvld                  (mac_a2accu_pvld)                   //|> w
  ,.mac2accu_mask                  (mac_a2accu_mask)              //|> w
  ,.mac2accu_mode                  (mac_a2accu_mode)              //|> w
  //: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
  //: print qq(
  //: ,.mac2accu_data${i}                 (mac_a2accu_data${i})       //|> w )
  //: }
  ,.mac2accu_pd                    (mac_a2accu_pd)                //|> w
#endif
  ,.global_clk_ovr_on              (global_clk_ovr_on)            
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)
  ,.nvdla_core_clk                 (dla_core_clk)                 
  ,.dla_reset_rstn                 (nvdla_core_rstn)              
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)             
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition MB                                                //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_m u_partition_mb (
   .test_mode                      (test_mode)                    
  ,.direct_reset_                  (direct_reset_)                
#ifdef NVDLA_RETIMING_ENABLE
  ,.csb2cmac_a_req_pvld            (csb2cmac_b_req_dst_pvld)           //|< w
  ,.csb2cmac_a_req_prdy            (csb2cmac_b_req_dst_prdy)           //|> w
  ,.csb2cmac_a_req_pd              (csb2cmac_b_req_dst_pd)       //|< w
  ,.cmac_a2csb_resp_valid          (cmac_b2csb_resp_src_valid)         //|> w
  ,.cmac_a2csb_resp_pd             (cmac_b2csb_resp_src_pd)      //|> w
  ,.sc2mac_wt_pvld                 (sc2mac_wt_b_dst_pvld)              //|< w
  ,.sc2mac_wt_mask                 (sc2mac_wt_b_dst_mask)       //|< w
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_data${i}                (sc2mac_wt_b_dst_data${i})        //|< w )
  //: }
  ,.sc2mac_wt_sel                  (sc2mac_wt_b_dst_sel)          //|< w
  ,.sc2mac_dat_pvld                (sc2mac_dat_b_dst_pvld)             //|< w
  ,.sc2mac_dat_mask                (sc2mac_dat_b_dst_mask)      //|< w
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_data${i}                (sc2mac_dat_b_dst_data${i})        //|< w )
  //: }
  ,.sc2mac_dat_pd                  (sc2mac_dat_b_dst_pd)          //|< w
  ,.mac2accu_pvld                  (mac_b2accu_src_pvld)               //|> w
  ,.mac2accu_mask                  (mac_b2accu_src_mask)          //|> w
  ,.mac2accu_mode                  (mac_b2accu_src_mode)          //|> w
  //: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
  //: print qq(
  //: ,.mac2accu_data${i}                 (mac_b2accu_src_data${i})       //|> w )
  //: }
  ,.mac2accu_pd                    (mac_b2accu_src_pd)            //|> w
#else
  ,.csb2cmac_a_req_pvld            (csb2cmac_b_req_pvld)               //|< w
  ,.csb2cmac_a_req_prdy            (csb2cmac_b_req_prdy)               //|> w
  ,.csb2cmac_a_req_pd              (csb2cmac_b_req_pd)           //|< w
  ,.cmac_a2csb_resp_valid          (cmac_b2csb_resp_valid)             //|> w
  ,.cmac_a2csb_resp_pd             (cmac_b2csb_resp_pd)          //|> w
  ,.sc2mac_wt_pvld                 (sc2mac_wt_b_pvld)                  //|< w
  ,.sc2mac_wt_mask                 (sc2mac_wt_b_mask)           //|< w
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_data${i}                (sc2mac_wt_b_data${i})        //|< w )
  //: }
  ,.sc2mac_wt_sel                  (sc2mac_wt_b_sel)              //|< w
  ,.sc2mac_dat_pvld                (sc2mac_dat_b_pvld)                 //|< w
  ,.sc2mac_dat_mask                (sc2mac_dat_b_mask)          //|< w
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_data${i}                (sc2mac_dat_b_data${i})        //|< w )
  //: }
  ,.sc2mac_dat_pd                  (sc2mac_dat_b_pd)              //|< w
  ,.mac2accu_pvld                  (mac_b2accu_pvld)                   //|> w
  ,.mac2accu_mask                  (mac_b2accu_mask)              //|> w
  ,.mac2accu_mode                  (mac_b2accu_mode)              //|> w
  //: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
  //: print qq(
  //: ,.mac2accu_data${i}                 (mac_b2accu_data${i})       //|> w )
  //: }
  ,.mac2accu_pd                    (mac_b2accu_pd)                //|> w
#endif
  ,.global_clk_ovr_on              (global_clk_ovr_on)              
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)  
  ,.nvdla_core_clk                 (dla_core_clk)                   
  ,.dla_reset_rstn                 (nvdla_core_rstn)                
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)               
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition A                                                 //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_a u_partition_a (
   .test_mode                      (test_mode)                     
  ,.direct_reset_                  (direct_reset_)                 
  ,.global_clk_ovr_on              (global_clk_ovr_on)             
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating) 
  ,.accu2sc_credit_vld             (accu2sc_credit_vld)            
  ,.accu2sc_credit_size            (accu2sc_credit_size[2:0])      
#ifdef NVDLA_RETIMING_ENABLE
  ,.csb2cacc_req_dst_pvld          (csb2cacc_req_dst_pvld)         
  ,.csb2cacc_req_dst_prdy          (csb2cacc_req_dst_prdy)         
  ,.csb2cacc_req_dst_pd            (csb2cacc_req_dst_pd[62:0])     
  ,.cacc2csb_resp_src_valid        (cacc2csb_resp_src_valid)       
  ,.cacc2csb_resp_src_pd           (cacc2csb_resp_src_pd[33:0])    
  ,.cacc2glb_done_intr_src_pd      (cacc2glb_done_intr_src_pd[1:0])
#else
  ,.csb2cacc_req_pvld              (csb2cacc_req_pvld)             
  ,.csb2cacc_req_prdy              (csb2cacc_req_prdy)             
  ,.csb2cacc_req_pd                (csb2cacc_req_pd[62:0])         
  ,.cacc2csb_resp_valid            (cacc2csb_resp_valid)           
  ,.cacc2csb_resp_pd               (cacc2csb_resp_pd[33:0])        
  ,.cacc2glb_done_intr_pd          (cacc2glb_done_intr_pd[1:0])    
#endif
  ,.cacc2sdp_valid                 (cacc2sdp_valid)                
  ,.cacc2sdp_ready                 (cacc2sdp_ready)                
  ,.cacc2sdp_pd                    (cacc2sdp_pd)            
#ifdef NVDLA_RETIMING_ENABLE
  ,.mac_a2accu_dst_pvld            (mac_a2accu_dst_pvld)           
  ,.mac_a2accu_dst_mask            (mac_a2accu_dst_mask[CMAC_ATOMK/2-1:0])      
  ,.mac_a2accu_dst_mode            (mac_a2accu_dst_mode)      
  //: for(my $i=0; $i<CMAC_ATOMK/2 ; $i++){
  //: print qq(
  //: ,.mac_a2accu_dst_data${i}           (mac_a2accu_dst_data${i}[CMAC_RESULT_WIDTH-1:0])   )
  //: }
  ,.mac_a2accu_dst_pd              (mac_a2accu_dst_pd[8:0])       
  ,.mac_b2accu_src_pvld            (mac_b2accu_src_pvld)          
  ,.mac_b2accu_src_mask            (mac_b2accu_src_mask[CMAC_ATOMK/2-1:0])     
  ,.mac_b2accu_src_mode            (mac_b2accu_src_mode)     
  //: for(my $i=0; $i<CMAC_ATOMK/2 ; $i++){
  //: print qq(
  //: ,.mac_b2accu_src_data${i}           (mac_b2accu_src_data${i}[CMAC_RESULT_WIDTH-1:0])   )
  //: }
  ,.mac_b2accu_src_pd              (mac_b2accu_src_pd[8:0])       
#else
  ,.mac_a2accu_pvld                (mac_a2accu_pvld)              
  ,.mac_a2accu_mask                (mac_a2accu_mask[CMAC_ATOMK/2-1:0])         
  ,.mac_a2accu_mode                (mac_a2accu_mode)         
  //: for(my $i=0; $i<CMAC_ATOMK/2 ; $i++){
  //: print qq(
  //: ,.mac_a2accu_data${i}           (mac_a2accu_data${i}[CMAC_RESULT_WIDTH-1:0])   )
  //: }
  ,.mac_a2accu_pd                  (mac_a2accu_pd[8:0])           
  ,.mac_b2accu_pvld                (mac_b2accu_pvld)              
  ,.mac_b2accu_mask                (mac_b2accu_mask[CMAC_ATOMK/2-1:0])         
  ,.mac_b2accu_mode                (mac_b2accu_mode)         
  //: for(my $i=0; $i<CMAC_ATOMK/2 ; $i++){
  //: print qq(
  //: ,.mac_b2accu_data${i}           (mac_b2accu_data${i}[CMAC_RESULT_WIDTH-1:0])   )
  //: }
  ,.mac_b2accu_pd                  (mac_b2accu_pd[8:0])           
#endif
  ,.pwrbus_ram_pd                  (nvdla_pwrbus_ram_a_pd[31:0])  
  ,.nvdla_core_clk                 (dla_core_clk)                 
  ,.dla_reset_rstn                 (nvdla_core_rstn)              
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)             
  );
////////////////////////////////////////////////////////////////////////
//  NVDLA Partition P                                                 //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_partition_p u_partition_p (
   .test_mode                      (test_mode)                        
  ,.direct_reset_                  (direct_reset_)                     
  ,.global_clk_ovr_on              (global_clk_ovr_on)                 
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)     
  ,.cacc2sdp_valid                 (cacc2sdp_valid)                    
  ,.cacc2sdp_ready                 (cacc2sdp_ready)                    
  ,.cacc2sdp_pd                    (cacc2sdp_pd)
  ,.csb2sdp_rdma_req_pvld          (csb2sdp_rdma_req_pvld)             
  ,.csb2sdp_rdma_req_prdy          (csb2sdp_rdma_req_prdy)             
  ,.csb2sdp_rdma_req_pd            (csb2sdp_rdma_req_pd[62:0])         
  ,.csb2sdp_req_pvld               (csb2sdp_req_pvld)                  
  ,.csb2sdp_req_prdy               (csb2sdp_req_prdy)                  
  ,.csb2sdp_req_pd                 (csb2sdp_req_pd[62:0])              
#ifdef NVDLA_RETIMING_ENABLE
  ,.mac_a2accu_dst_pvld            (mac_a2accu_dst_pvld)               
  ,.mac_a2accu_dst_mask            (mac_a2accu_dst_mask[CMAC_ATOMK/2-1:0])          
  ,.mac_a2accu_dst_mode            (mac_a2accu_dst_mode)          
  //: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
  //: print qq(
  //: ,.mac_a2accu_dst_data${i}           (mac_a2accu_dst_data${i}[CMAC_RESULT_WIDTH-1:0])   )
  //: }
  ,.mac_a2accu_dst_pd              (mac_a2accu_dst_pd[8:0])            
  ,.mac_a2accu_src_pvld            (mac_a2accu_src_pvld)               
  ,.mac_a2accu_src_mask            (mac_a2accu_src_mask[CMAC_ATOMK/2-1:0])          
  ,.mac_a2accu_src_mode            (mac_a2accu_src_mode)          
  //: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
  //: print qq(
  //: ,.mac_a2accu_src_data${i}           (mac_a2accu_src_data${i}[CMAC_RESULT_WIDTH-1:0])   )
  //: }
  ,.mac_a2accu_src_pd              (mac_a2accu_src_pd[8:0])            
#endif
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
#ifdef NVDLA_SDP_BS_ENABLE
  ,.sdp_b2cvif_rd_cdt_lat_fifo_pop (sdp_b2cvif_rd_cdt_lat_fifo_pop) 
  ,.sdp_b2cvif_rd_req_valid        (sdp_b2cvif_rd_req_valid)        
  ,.sdp_b2cvif_rd_req_ready        (sdp_b2cvif_rd_req_ready)        
  ,.sdp_b2cvif_rd_req_pd           (sdp_b2cvif_rd_req_pd      )     
  ,.cvif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)        
  ,.cvif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)        
  ,.cvif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd       )    
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop) 
  ,.sdp_e2cvif_rd_req_valid        (sdp_e2cvif_rd_req_valid)        
  ,.sdp_e2cvif_rd_req_ready        (sdp_e2cvif_rd_req_ready)        
  ,.sdp_e2cvif_rd_req_pd           (sdp_e2cvif_rd_req_pd      )     
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)        
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)        
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd       )    
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  ,.sdp_n2cvif_rd_cdt_lat_fifo_pop (sdp_n2cvif_rd_cdt_lat_fifo_pop) 
  ,.sdp_n2cvif_rd_req_valid        (sdp_n2cvif_rd_req_valid)        
  ,.sdp_n2cvif_rd_req_ready        (sdp_n2cvif_rd_req_ready)        
  ,.sdp_n2cvif_rd_req_pd           (sdp_n2cvif_rd_req_pd      )     
  ,.cvif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)        
  ,.cvif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)        
  ,.cvif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd       )    
#endif
  ,.cvif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)          
  ,.cvif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)          
  ,.cvif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd       )      
  ,.sdp2cvif_rd_cdt_lat_fifo_pop   (sdp2cvif_rd_cdt_lat_fifo_pop)   
  ,.sdp2cvif_rd_req_valid          (sdp2cvif_rd_req_valid)          
  ,.sdp2cvif_rd_req_ready          (sdp2cvif_rd_req_ready)          
  ,.sdp2cvif_rd_req_pd             (sdp2cvif_rd_req_pd      )       
  ,.sdp2cvif_wr_req_valid          (sdp2cvif_wr_req_valid)          
  ,.sdp2cvif_wr_req_ready          (sdp2cvif_wr_req_ready)          
  ,.sdp2cvif_wr_req_pd             (sdp2cvif_wr_req_pd       )      
  ,.cvif2sdp_wr_rsp_complete       (cvif2sdp_wr_rsp_complete)       
#endif
#ifdef NVDLA_SDP_BS_ENABLE
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop (sdp_b2mcif_rd_cdt_lat_fifo_pop) 
  ,.sdp_b2mcif_rd_req_valid        (sdp_b2mcif_rd_req_valid)        
  ,.sdp_b2mcif_rd_req_ready        (sdp_b2mcif_rd_req_ready)        
  ,.sdp_b2mcif_rd_req_pd           (sdp_b2mcif_rd_req_pd      )     
  ,.mcif2sdp_b_rd_rsp_valid        (mcif2sdp_b_rd_rsp_valid)        
  ,.mcif2sdp_b_rd_rsp_ready        (mcif2sdp_b_rd_rsp_ready)        
  ,.mcif2sdp_b_rd_rsp_pd           (mcif2sdp_b_rd_rsp_pd       )    
#endif
#ifdef NVDLA_SDP_EW_ENABLE
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2mcif_rd_cdt_lat_fifo_pop) 
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2mcif_rd_req_valid)        
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2mcif_rd_req_ready)        
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2mcif_rd_req_pd      )     
  ,.mcif2sdp_e_rd_rsp_valid        (mcif2sdp_e_rd_rsp_valid)        
  ,.mcif2sdp_e_rd_rsp_ready        (mcif2sdp_e_rd_rsp_ready)        
  ,.mcif2sdp_e_rd_rsp_pd           (mcif2sdp_e_rd_rsp_pd       )    
#endif
#ifdef NVDLA_SDP_BN_ENABLE
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop (sdp_n2mcif_rd_cdt_lat_fifo_pop) 
  ,.sdp_n2mcif_rd_req_valid        (sdp_n2mcif_rd_req_valid)        
  ,.sdp_n2mcif_rd_req_ready        (sdp_n2mcif_rd_req_ready)        
  ,.sdp_n2mcif_rd_req_pd           (sdp_n2mcif_rd_req_pd      )     
  ,.mcif2sdp_n_rd_rsp_valid        (mcif2sdp_n_rd_rsp_valid)        
  ,.mcif2sdp_n_rd_rsp_ready        (mcif2sdp_n_rd_rsp_ready)        
  ,.mcif2sdp_n_rd_rsp_pd           (mcif2sdp_n_rd_rsp_pd       )    
#endif
  ,.mcif2sdp_rd_rsp_valid          (mcif2sdp_rd_rsp_valid)          
  ,.mcif2sdp_rd_rsp_ready          (mcif2sdp_rd_rsp_ready)          
  ,.mcif2sdp_rd_rsp_pd             (mcif2sdp_rd_rsp_pd       )      
  ,.mcif2sdp_wr_rsp_complete       (mcif2sdp_wr_rsp_complete)       
  ,.pwrbus_ram_pd                  (nvdla_pwrbus_ram_p_pd[31:0])    
  ,.sdp2csb_resp_valid             (sdp2csb_resp_valid)             
  ,.sdp2csb_resp_pd                (sdp2csb_resp_pd[33:0])          
  ,.sdp2glb_done_intr_pd           (sdp2glb_done_intr_pd[1:0])      
  ,.sdp2mcif_rd_cdt_lat_fifo_pop   (sdp2mcif_rd_cdt_lat_fifo_pop)   
  ,.sdp2mcif_rd_req_valid          (sdp2mcif_rd_req_valid)          
  ,.sdp2mcif_rd_req_ready          (sdp2mcif_rd_req_ready)          
  ,.sdp2mcif_rd_req_pd             (sdp2mcif_rd_req_pd      )       
  ,.sdp2mcif_wr_req_valid          (sdp2mcif_wr_req_valid)          
  ,.sdp2mcif_wr_req_ready          (sdp2mcif_wr_req_ready)          
  ,.sdp2mcif_wr_req_pd             (sdp2mcif_wr_req_pd       )      
  ,.sdp2pdp_valid                  (sdp2pdp_valid)                  
  ,.sdp2pdp_ready                  (sdp2pdp_ready)                  
  ,.sdp2pdp_pd                     (sdp2pdp_pd )              
  ,.sdp_rdma2csb_resp_valid        (sdp_rdma2csb_resp_valid)        
  ,.sdp_rdma2csb_resp_pd           (sdp_rdma2csb_resp_pd[33:0])     
  ,.nvdla_core_clk                 (dla_core_clk)                   
  ,.dla_reset_rstn                 (nvdla_core_rstn)                
  ,.nvdla_clk_ovr_on               (nvdla_clk_ovr_on)               
  );



endmodule // NV_nvdla


