// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_partition_c.v

#include "NV_NVDLA_define.h"
#include "../csc/NV_NVDLA_CSC.h"
#include "../cmac/NV_NVDLA_CMAC.h"
#include "../cbuf/NV_NVDLA_CBUF.h"
module NV_NVDLA_partition_c (
   accu2sc_credit_size           //|< i
  ,accu2sc_credit_vld            //|< i
#ifdef NVDLA_RETIMING_ENABLE
  ,cacc2csb_resp_src_valid       //|< i
  ,cacc2csb_resp_src_pd          //|< i
  ,cacc2glb_done_intr_src_pd     //|< i
  ,cacc2csb_resp_dst_valid       //|> o
  ,cacc2csb_resp_dst_pd          //|> o
  ,cacc2glb_done_intr_dst_pd     //|> o
  ,csb2cacc_req_src_pvld         //|< i
  ,csb2cacc_req_src_prdy         //|> o
  ,csb2cacc_req_src_pd           //|< i
  ,csb2cacc_req_dst_prdy         //|< i
  ,csb2cacc_req_dst_pvld         //|> o
  ,csb2cacc_req_dst_pd           //|> o
  ,cmac_b2csb_resp_src_valid     //|< i
  ,cmac_b2csb_resp_src_pd        //|< i
  ,cmac_b2csb_resp_dst_valid     //|> o
  ,cmac_b2csb_resp_dst_pd        //|> o
  ,csb2cmac_b_req_dst_pvld       //|> o
  ,csb2cmac_b_req_src_prdy       //|> o
  ,csb2cmac_b_req_dst_pd         //|> o
  ,csb2cmac_b_req_src_pvld       //|< i
  ,csb2cmac_b_req_src_pd         //|< i
  ,csb2cmac_b_req_dst_prdy       //|< i
#endif
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cdma_dat2cvif_rd_req_ready    //|< i
  #endif
  ,cdma_dat2mcif_rd_req_ready    //|< i
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cdma_wt2cvif_rd_req_ready     //|< i
  #endif
  ,cdma_wt2mcif_rd_req_ready     //|< i
  ,csb2cdma_req_pd               //|< i
  ,csb2cdma_req_pvld             //|< i
  ,csb2csc_req_pd                //|< i
  ,csb2csc_req_pvld              //|< i
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2cdma_dat_rd_rsp_pd       //|< i
  ,cvif2cdma_dat_rd_rsp_valid    //|< i
  ,cvif2cdma_wt_rd_rsp_pd        //|< i
  ,cvif2cdma_wt_rd_rsp_valid     //|< i
  #endif
  ,direct_reset_                 //|< i
  ,dla_reset_rstn                //|< i
  ,global_clk_ovr_on             //|< i
  ,mcif2cdma_dat_rd_rsp_pd       //|< i
  ,mcif2cdma_dat_rd_rsp_valid    //|< i
  ,mcif2cdma_wt_rd_rsp_pd        //|< i
  ,mcif2cdma_wt_rd_rsp_valid     //|< i
  ,nvdla_clk_ovr_on              //|< i
  ,nvdla_core_clk                //|< i
  ,pwrbus_ram_pd                 //|< i
  ,test_mode                     //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,cdma2csb_resp_pd              //|> o
  ,cdma2csb_resp_valid           //|> o
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cdma_dat2cvif_rd_req_pd       //|> o
  ,cdma_dat2cvif_rd_req_valid    //|> o
  #endif
  ,cdma_dat2glb_done_intr_pd     //|> o
  ,cdma_dat2mcif_rd_req_pd       //|> o
  ,cdma_dat2mcif_rd_req_valid    //|> o
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cdma_wt2cvif_rd_req_pd        //|> o
  ,cdma_wt2cvif_rd_req_valid     //|> o
  #endif
  ,cdma_wt2glb_done_intr_pd      //|> o
  ,cdma_wt2mcif_rd_req_pd        //|> o
  ,cdma_wt2mcif_rd_req_valid     //|> o
  ,csb2cdma_req_prdy             //|> o
  ,csb2csc_req_prdy              //|> o
  ,csc2csb_resp_pd               //|> o
  ,csc2csb_resp_valid            //|> o
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2cdma_dat_rd_rsp_ready    //|> o
  ,cvif2cdma_wt_rd_rsp_ready     //|> o
  #endif
  ,mcif2cdma_dat_rd_rsp_ready    //|> o
  ,mcif2cdma_wt_rd_rsp_ready     //|> o
#ifdef NVDLA_RETIMING_ENABLE
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: ,sc2mac_dat_a_src_data${i}        //|> o   );
//: }
  ,sc2mac_dat_a_src_mask         //|> o
  ,sc2mac_dat_a_src_pd           //|> o
  ,sc2mac_dat_a_src_pvld         //|> o
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: ,sc2mac_dat_b_dst_data${i}        //|> o   );
//: }
  ,sc2mac_dat_b_dst_mask         //|> o
  ,sc2mac_dat_b_dst_pd           //|> o
  ,sc2mac_dat_b_dst_pvld         //|> o
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: ,sc2mac_wt_a_src_data${i}        //|> o   );
//: }
  ,sc2mac_wt_a_src_mask          //|> o
  ,sc2mac_wt_a_src_pvld          //|> o
  ,sc2mac_wt_a_src_sel           //|> o
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: ,sc2mac_wt_b_dst_data${i}        //|> o   );
//: }
  ,sc2mac_wt_b_dst_mask          //|> o
  ,sc2mac_wt_b_dst_pvld          //|> o
  ,sc2mac_wt_b_dst_sel           //|> o
#else
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: ,sc2mac_dat_a_data${i}        //|> o   );
//: }
  ,sc2mac_dat_a_mask         //|> o
  ,sc2mac_dat_a_pd           //|> o
  ,sc2mac_dat_a_pvld         //|> o
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: ,sc2mac_dat_b_data${i}        //|> o   );
//: }
  ,sc2mac_dat_b_mask         //|> o
  ,sc2mac_dat_b_pd           //|> o
  ,sc2mac_dat_b_pvld         //|> o
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: ,sc2mac_wt_a_data${i}        //|> o   );
//: }
  ,sc2mac_wt_a_mask          //|> o
  ,sc2mac_wt_a_pvld          //|> o
  ,sc2mac_wt_a_sel           //|> o
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: ,sc2mac_wt_b_data${i}        //|> o   );
//: }
  ,sc2mac_wt_b_mask          //|> o
  ,sc2mac_wt_b_pvld          //|> o
  ,sc2mac_wt_b_sel           //|> o
#endif
  );

//
// NV_NVDLA_partition_c_io.v
//

input  test_mode;
input  direct_reset_;

input  global_clk_ovr_on;
input  tmc2slcg_disable_clock_gating;

input       accu2sc_credit_vld;   /* data valid */
input [2:0] accu2sc_credit_size;

#ifdef NVDLA_RETIMING_ENABLE
input         cacc2csb_resp_src_valid;  /* data valid */
input  [33:0] cacc2csb_resp_src_pd;     /* pkt_id_width=1 pkt_widths=33,33  */
input  [1:0]  cacc2glb_done_intr_src_pd;
output        cacc2csb_resp_dst_valid;  /* data valid */
output [33:0] cacc2csb_resp_dst_pd;     /* pkt_id_width=1 pkt_widths=33,33  */
output [1:0]  cacc2glb_done_intr_dst_pd;

input         csb2cacc_req_src_pvld;  /* data valid */
output        csb2cacc_req_src_prdy;  /* data return handshake */
input  [62:0] csb2cacc_req_src_pd;
output        csb2cacc_req_dst_pvld;  /* data valid */
input         csb2cacc_req_dst_prdy;  /* data return handshake */
output [62:0] csb2cacc_req_dst_pd;

input         cmac_b2csb_resp_src_valid;  /* data valid */
input [33:0]  cmac_b2csb_resp_src_pd;     /* pkt_id_width=1 pkt_widths=33,33  */
output        cmac_b2csb_resp_dst_valid;  /* data valid */
output [33:0] cmac_b2csb_resp_dst_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input         csb2cmac_b_req_src_pvld;  /* data valid */
output        csb2cmac_b_req_src_prdy;  /* data return handshake */
input  [62:0] csb2cmac_b_req_src_pd;
output        csb2cmac_b_req_dst_pvld;  /* data valid */
input         csb2cmac_b_req_dst_prdy;  /* data return handshake */
output [62:0] csb2cmac_b_req_dst_pd;
#endif

output        cdma2csb_resp_valid;  /* data valid */
output [33:0] cdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */


output [1:0] cdma_dat2glb_done_intr_pd;

output        cdma_dat2mcif_rd_req_valid;  /* data valid */
input         cdma_dat2mcif_rd_req_ready;  /* data return handshake */
output [NVDLA_MEM_ADDRESS_WIDTH+14:0] cdma_dat2mcif_rd_req_pd;
 

output [1:0] cdma_wt2glb_done_intr_pd;

output        cdma_wt2mcif_rd_req_valid;  /* data valid */
input         cdma_wt2mcif_rd_req_ready;  /* data return handshake */
output [NVDLA_MEM_ADDRESS_WIDTH+14:0] cdma_wt2mcif_rd_req_pd;

input         csb2cdma_req_pvld;  /* data valid */
output        csb2cdma_req_prdy;  /* data return handshake */
input  [62:0] csb2cdma_req_pd;

input         csb2csc_req_pvld;  /* data valid */
output        csb2csc_req_prdy;  /* data return handshake */
input  [62:0] csb2csc_req_pd;

output        csc2csb_resp_valid;  /* data valid */
output [33:0] csc2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output        cdma_dat2cvif_rd_req_valid;  /* data valid */
input         cdma_dat2cvif_rd_req_ready;  /* data return handshake */
output [NVDLA_MEM_ADDRESS_WIDTH+14:0] cdma_dat2cvif_rd_req_pd;
output        cdma_wt2cvif_rd_req_valid;  /* data valid */
input         cdma_wt2cvif_rd_req_ready;  /* data return handshake */
output [NVDLA_MEM_ADDRESS_WIDTH+14:0] cdma_wt2cvif_rd_req_pd;
input          cvif2cdma_dat_rd_rsp_valid;  /* data valid */
output         cvif2cdma_dat_rd_rsp_ready;  /* data return handshake */
input  [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] cvif2cdma_dat_rd_rsp_pd;
input          cvif2cdma_wt_rd_rsp_valid;  /* data valid */
output         cvif2cdma_wt_rd_rsp_ready;  /* data return handshake */
input  [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] cvif2cdma_wt_rd_rsp_pd;
#endif

input          mcif2cdma_dat_rd_rsp_valid;  /* data valid */
output         mcif2cdma_dat_rd_rsp_ready;  /* data return handshake */
input  [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] mcif2cdma_dat_rd_rsp_pd;

input          mcif2cdma_wt_rd_rsp_valid;  /* data valid */
output         mcif2cdma_wt_rd_rsp_ready;  /* data return handshake */
input  [NVDLA_DMAIF_BW+NVDLA_MEM_MASK_BIT-1:0] mcif2cdma_wt_rd_rsp_pd;

input [31:0] pwrbus_ram_pd;

#ifdef NVDLA_RETIMING_ENABLE
//: my $kk=CSC_ATOMC-1;
//: foreach my $i (0..${kk}) {
//: print qq(
//:     output   [CSC_BPE-1:0] sc2mac_dat_a_src_data${i};
//:     output   [CSC_BPE-1:0] sc2mac_dat_b_dst_data${i};
//:     output   [CSC_BPE-1:0] sc2mac_wt_a_src_data${i};
//:     output   [CSC_BPE-1:0] sc2mac_wt_b_dst_data${i};
//: );
//: }
output         sc2mac_dat_a_src_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_dat_a_src_mask;
output   [8:0] sc2mac_dat_a_src_pd;

output         sc2mac_dat_b_dst_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_dat_b_dst_mask;
output   [8:0] sc2mac_dat_b_dst_pd;

output         sc2mac_wt_a_src_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_wt_a_src_mask;
output   [CSC_ATOMK/2-1:0] sc2mac_wt_a_src_sel;

output         sc2mac_wt_b_dst_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_wt_b_dst_mask;
output   [CSC_ATOMK/2-1:0] sc2mac_wt_b_dst_sel;

#else
output         sc2mac_dat_a_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_dat_a_mask;
output   [8:0] sc2mac_dat_a_pd;

output         sc2mac_dat_b_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_dat_b_mask;
output   [8:0] sc2mac_dat_b_pd;

output         sc2mac_wt_a_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_wt_a_mask;
output   [CSC_ATOMK/2-1:0] sc2mac_wt_a_sel;

output         sc2mac_wt_b_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_wt_b_mask;
//: my $kk=CSC_ATOMC-1;
//: foreach my $i (0..${kk}) {
//: print qq(
//:     output   [CSC_BPE-1:0] sc2mac_dat_a_data${i};
//:     output   [CSC_BPE-1:0] sc2mac_dat_b_data${i};
//:     output   [CSC_BPE-1:0] sc2mac_wt_a_data${i};
//:     output   [CSC_BPE-1:0] sc2mac_wt_b_data${i};
//: );
//: }
output   [CSC_ATOMK/2-1:0] sc2mac_wt_b_sel;
#endif

input  nvdla_core_clk;     
input  dla_reset_rstn;     

input          nvdla_clk_ovr_on;
//////////////////////////////////////////////////////
wire           cdma2buf_dat_wr_en;
//: my $dmaif=NVDLA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int($atmc/$dmaif);
//:     print qq(
//:      wire [${k}-1:0]     cdma2buf_dat_wr_sel;
//:      wire [16:0]         cdma2buf_dat_wr_addr;
//:      wire [${dmaif}-1:0] cdma2buf_dat_wr_data;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:      wire   [${k}-1:0]      cdma2buf_dat_wr_mask;
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:              wire [16:0]         cdma2buf_dat_wr_addr${i};
//:              wire [${dmaif}-1:0] cdma2buf_dat_wr_data${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:      wire [16:0]         cdma2buf_dat_wr_addr;
//:      wire [${dmaif}-1:0] cdma2buf_dat_wr_data;
//:     );
//: }
//wire    [11:0] cdma2buf_dat_wr_addr;
//wire  [1023:0] cdma2buf_dat_wr_data;
//wire     [1:0] cdma2buf_dat_wr_hsel;
wire           cdma2buf_wt_wr_en;
//: my $dmaif=NVDLA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int($atmc/$dmaif);
//:     print qq(
//:     wire [${k}-1:0]     cdma2buf_wt_wr_sel ; 
//:     wire [16:0]         cdma2buf_wt_wr_addr;
//:     wire [${dmaif}-1:0] cdma2buf_wt_wr_data;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:     wire   [${k}-1:0]      cdma2buf_wt_wr_mask;
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:             wire [16:0]         cdma2buf_wt_wr_addr${i};
//:             wire [${dmaif}-1:0] cdma2buf_wt_wr_data${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:     wire [16:0]         cdma2buf_wt_wr_addr;
//:     wire [${dmaif}-1:0] cdma2buf_wt_wr_data;
//:     );
//: }
//wire    [11:0] cdma2buf_wt_wr_addr;
//wire   [511:0] cdma2buf_wt_wr_data;
//wire           cdma2buf_wt_wr_hsel;
wire    [CSC_ENTRIES_NUM_WIDTH-1:0] cdma2sc_dat_entries;
wire           cdma2sc_dat_pending_ack;
wire    [13:0] cdma2sc_dat_slices;
wire           cdma2sc_dat_updt;
wire     [8:0] cdma2sc_wmb_entries;
wire    [CSC_ENTRIES_NUM_WIDTH-1:0] cdma2sc_wt_entries;
wire    [13:0] cdma2sc_wt_kernels;
wire           cdma2sc_wt_pending_ack;
wire           cdma2sc_wt_updt;
wire           cdma_dla_clk_ovr_on_sync;
wire           cdma_global_clk_ovr_on_sync;
wire           csc_dla_clk_ovr_on_sync;
wire           csc_global_clk_ovr_on_sync;
wire           nvdla_core_rstn;
wire  [CBUF_ADDR_WIDTH-1:0] sc2buf_dat_rd_addr;
wire  [CBUF_ENTRY_BITS-1:0] sc2buf_dat_rd_data;
wire           sc2buf_dat_rd_en;
wire           sc2buf_dat_rd_valid;
wire [CBUF_RD_DATA_SHIFT_WIDTH-1:0] sc2buf_dat_rd_shift;
wire sc2buf_dat_rd_next1_en;
wire [CBUF_ADDR_WIDTH-1:0] sc2buf_dat_rd_next1_addr;
`ifdef CBUF_WEIGHT_COMPRESSED
wire  [CBUF_ADDR_WIDTH-1:0] sc2buf_wmb_rd_addr;
wire  [CBUF_ENTRY_BITS-1:0] sc2buf_wmb_rd_data;
wire           sc2buf_wmb_rd_en;
wire           sc2buf_wmb_rd_valid;
`endif
wire  [CBUF_ADDR_WIDTH-1:0] sc2buf_wt_rd_addr;
wire  [CBUF_ENTRY_BITS-1:0] sc2buf_wt_rd_data;
wire           sc2buf_wt_rd_en;
wire           sc2buf_wt_rd_valid;
wire    [CSC_ENTRIES_NUM_WIDTH-1:0] sc2cdma_dat_entries;
wire           sc2cdma_dat_pending_req;
wire    [13:0] sc2cdma_dat_slices;
wire           sc2cdma_dat_updt;
wire     [8:0] sc2cdma_wmb_entries;
wire    [CSC_ENTRIES_NUM_WIDTH-1:0] sc2cdma_wt_entries;
wire    [13:0] sc2cdma_wt_kernels;
wire           sc2cdma_wt_pending_req;
wire           sc2cdma_wt_updt;
#ifdef NVDLA_RETIMING_ENABLE
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: wire     [CSC_BPE-1:0] sc2mac_dat_b_src_data${i};   )
//: }
wire   [CSC_ATOMC-1:0] sc2mac_dat_b_src_mask;
wire     [8:0] sc2mac_dat_b_src_pd;
wire           sc2mac_dat_b_src_pvld;
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: wire     [CSC_BPE-1:0] sc2mac_wt_b_src_data${i};   )
//: }
wire   [CSC_ATOMC-1:0] sc2mac_wt_b_src_mask;
wire           sc2mac_wt_b_src_pvld;
wire     [CSC_ATOMK/2-1:0] sc2mac_wt_b_src_sel;
#endif

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Reset Sync                                  //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_reset u_partition_c_reset (
   .dla_reset_rstn                (dla_reset_rstn)                 //|< i
  ,.direct_reset_                 (direct_reset_)                  //|< i
  ,.test_mode                     (test_mode)                      //|< i
  ,.synced_rstn                   (nvdla_core_rstn)                //|> w
  ,.nvdla_clk                     (nvdla_core_clk)                 //|< i
  );

////////////////////////////////////////////////////////////////////////
// SLCG override
////////////////////////////////////////////////////////////////////////
NV_NVDLA_sync3d u_csc_dla_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)          
  ,.sync_i                        (nvdla_clk_ovr_on)        
  ,.sync_o                        (csc_dla_clk_ovr_on_sync) 
  );

NV_NVDLA_sync3d u_cdma_dla_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)          
  ,.sync_i                        (nvdla_clk_ovr_on)        
  ,.sync_o                        (cdma_dla_clk_ovr_on_sync)
  );

//&Instance NV_NVDLA_sync3d u_dla_clk_ovr_on_sync;
//&Connect clk      nvdla_core_clk;
//&Connect sync_i   nvdla_clk_ovr_on;
//&Connect sync_o   dla_clk_ovr_on_sync;

NV_NVDLA_sync3d_s u_global_csc_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)          
  ,.prst                          (nvdla_core_rstn)         
  ,.sync_i                        (global_clk_ovr_on)       
  ,.sync_o                        (csc_global_clk_ovr_on_sync) 
  );

NV_NVDLA_sync3d_s u_global_cdma_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)             
  ,.prst                          (nvdla_core_rstn)            
  ,.sync_i                        (global_clk_ovr_on)          
  ,.sync_o                        (cdma_global_clk_ovr_on_sync)
  );

//&Instance NV_NVDLA_sync3d_s u_global_clk_ovr_on_sync;
//&Connect clk      nvdla_core_clk;
//&Connect prst     nvdla_core_rstn;
//&Connect sync_i   global_clk_ovr_on;
//&Connect sync_o   global_clk_ovr_on_sync;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Convolution DMA                             //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_cdma u_NV_NVDLA_cdma (
   .nvdla_core_clk                (nvdla_core_clk)              
  ,.nvdla_core_rstn               (nvdla_core_rstn)             
  ,.cdma2csb_resp_valid           (cdma2csb_resp_valid)         
  ,.cdma2csb_resp_pd              (cdma2csb_resp_pd)      
  ,.cdma2sc_dat_pending_ack       (cdma2sc_dat_pending_ack)     
  ,.cdma2sc_wt_pending_ack        (cdma2sc_wt_pending_ack)      
  ,.cdma_dat2mcif_rd_req_valid    (cdma_dat2mcif_rd_req_valid)  
  ,.cdma_dat2mcif_rd_req_ready    (cdma_dat2mcif_rd_req_ready)  
  ,.cdma_dat2mcif_rd_req_pd       (cdma_dat2mcif_rd_req_pd)  
  ,.cdma_wt2mcif_rd_req_valid     (cdma_wt2mcif_rd_req_valid)
  ,.cdma_wt2mcif_rd_req_ready     (cdma_wt2mcif_rd_req_ready)
  ,.cdma_wt2mcif_rd_req_pd        (cdma_wt2mcif_rd_req_pd)   
  ,.mcif2cdma_dat_rd_rsp_valid    (mcif2cdma_dat_rd_rsp_valid)  
  ,.mcif2cdma_dat_rd_rsp_ready    (mcif2cdma_dat_rd_rsp_ready)  
  ,.mcif2cdma_dat_rd_rsp_pd       (mcif2cdma_dat_rd_rsp_pd      )
  ,.mcif2cdma_wt_rd_rsp_valid     (mcif2cdma_wt_rd_rsp_valid)    
  ,.mcif2cdma_wt_rd_rsp_ready     (mcif2cdma_wt_rd_rsp_ready)    
  ,.mcif2cdma_wt_rd_rsp_pd        (mcif2cdma_wt_rd_rsp_pd)
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cdma_dat2cvif_rd_req_valid    (cdma_dat2cvif_rd_req_valid)   
  ,.cdma_dat2cvif_rd_req_ready    (cdma_dat2cvif_rd_req_ready)   
  ,.cdma_dat2cvif_rd_req_pd       (cdma_dat2cvif_rd_req_pd)
  ,.cdma_wt2cvif_rd_req_valid     (cdma_wt2cvif_rd_req_valid)    
  ,.cdma_wt2cvif_rd_req_ready     (cdma_wt2cvif_rd_req_ready)    
  ,.cdma_wt2cvif_rd_req_pd        (cdma_wt2cvif_rd_req_pd) 
  ,.cvif2cdma_dat_rd_rsp_valid    (cvif2cdma_dat_rd_rsp_valid)   
  ,.cvif2cdma_dat_rd_rsp_ready    (cvif2cdma_dat_rd_rsp_ready)   
  ,.cvif2cdma_dat_rd_rsp_pd       (cvif2cdma_dat_rd_rsp_pd)
  ,.cvif2cdma_wt_rd_rsp_valid     (cvif2cdma_wt_rd_rsp_valid)    
  ,.cvif2cdma_wt_rd_rsp_ready     (cvif2cdma_wt_rd_rsp_ready)    
  ,.cvif2cdma_wt_rd_rsp_pd        (cvif2cdma_wt_rd_rsp_pd       )
#endif
  ,.cdma_dat2glb_done_intr_pd     (cdma_dat2glb_done_intr_pd)
  ,.cdma_wt2glb_done_intr_pd      (cdma_wt2glb_done_intr_pd) 
  ,.csb2cdma_req_pvld             (csb2cdma_req_pvld)             
  ,.csb2cdma_req_prdy             (csb2cdma_req_prdy)             
  ,.csb2cdma_req_pd               (csb2cdma_req_pd)         
  ,.cdma2buf_dat_wr_en            (cdma2buf_dat_wr_en)            
//: my $dmaif=NVDLA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:       ,.cdma2buf_dat_wr_addr          (cdma2buf_dat_wr_addr)
//:       ,.cdma2buf_dat_wr_sel           (cdma2buf_dat_wr_sel) 
//:       ,.cdma2buf_dat_wr_data          (cdma2buf_dat_wr_data)
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:          ,. cdma2buf_dat_wr_mask      (cdma2buf_dat_wr_mask   )
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:             ,.cdma2buf_dat_wr_addr${i}      (cdma2buf_dat_wr_addr${i}   )
//:             ,.cdma2buf_dat_wr_data${i}      (cdma2buf_dat_wr_data${i}   )
//:         );
//:     }
//: } else {
//:     print qq(
//:       ,.cdma2buf_dat_wr_addr          (cdma2buf_dat_wr_addr)
//:       ,.cdma2buf_dat_wr_data          (cdma2buf_dat_wr_data)
//:     );
//: }
  //,.cdma2buf_dat_wr_addr          (cdma2buf_dat_wr_addr) 
  //,.cdma2buf_dat_wr_hsel          (cdma2buf_dat_wr_hsel)   
  //,.cdma2buf_dat_wr_data          (cdma2buf_dat_wr_data)
  ,.cdma2buf_wt_wr_en             (cdma2buf_wt_wr_en)             
//: my $dmaif=NVDLA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:         ,.cdma2buf_wt_wr_addr           (cdma2buf_wt_wr_addr) 
//:         ,.cdma2buf_wt_wr_sel            (cdma2buf_wt_wr_sel)  
//:         ,.cdma2buf_wt_wr_data           (cdma2buf_wt_wr_data)
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:         ,.cdma2buf_wt_wr_mask    (cdma2buf_wt_wr_mask)
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:            ,.cdma2buf_wt_wr_addr${i}    (cdma2buf_wt_wr_addr${i})
//:            ,.cdma2buf_wt_wr_data${i}    (cdma2buf_wt_wr_data${i})
//:         );
//:     }
//: } else {
//:     print qq(
//:         ,.cdma2buf_wt_wr_addr           (cdma2buf_wt_wr_addr) 
//:         ,.cdma2buf_wt_wr_data           (cdma2buf_wt_wr_data)
//:     );
//: }
  //,.cdma2buf_wt_wr_addr           (cdma2buf_wt_wr_addr) 
  //,.cdma2buf_wt_wr_hsel           (cdma2buf_wt_wr_hsel)       
  //,.cdma2buf_wt_wr_data           (cdma2buf_wt_wr_data)
  ,.cdma2sc_dat_updt              (cdma2sc_dat_updt)            
  ,.cdma2sc_dat_entries           (cdma2sc_dat_entries)   
  ,.cdma2sc_dat_slices            (cdma2sc_dat_slices)    
  ,.sc2cdma_dat_updt              (sc2cdma_dat_updt)            
  ,.sc2cdma_dat_entries           (sc2cdma_dat_entries)   
  ,.sc2cdma_dat_slices            (sc2cdma_dat_slices)    
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd)         
  ,.sc2cdma_dat_pending_req       (sc2cdma_dat_pending_req)     
  ,.sc2cdma_wt_pending_req        (sc2cdma_wt_pending_req)      
  ,.cdma2sc_wt_updt               (cdma2sc_wt_updt)             
  ,.cdma2sc_wt_kernels            (cdma2sc_wt_kernels)    
  ,.cdma2sc_wt_entries            (cdma2sc_wt_entries)    
  ,.cdma2sc_wmb_entries           (cdma2sc_wmb_entries)    
  ,.sc2cdma_wt_updt               (sc2cdma_wt_updt)             
  ,.sc2cdma_wt_kernels            (sc2cdma_wt_kernels)    
  ,.sc2cdma_wt_entries            (sc2cdma_wt_entries)    
  ,.sc2cdma_wmb_entries           (sc2cdma_wmb_entries)    
  ,.dla_clk_ovr_on_sync           (cdma_dla_clk_ovr_on_sync)    
  ,.global_clk_ovr_on_sync        (cdma_global_clk_ovr_on_sync) 
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Convolution Buffer                          //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_cbuf u_NV_NVDLA_cbuf (
//    .nvdla_core_clk                (nvdla_core_clk)     
//   ,.nvdla_core_rstn               (nvdla_core_rstn)    
//   ,.pwrbus_ram_pd                 (pwrbus_ram_pd)
//   ,.cdma2buf_dat_wr_en            (cdma2buf_dat_wr_en) 
// //: my $dmaif=NVDLA_DMAIF_BW;
// //: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_BPE;
// //: if($dmaif < $atmc) {
// //:     my $k = int(log(int($atmc/$dmaif))/log(2));
// //:     print qq(
// //:       ,.cdma2buf_dat_wr_addr          (cdma2buf_dat_wr_addr)
// //:       ,.cdma2buf_dat_wr_hsel          (cdma2buf_dat_wr_sel) 
// //:       ,.cdma2buf_dat_wr_data          (cdma2buf_dat_wr_data)
// //:     );
// //: } elsif($dmaif > $atmc) {
// //:     my $k = int(log(int($dmaif/$atmc))/log(2));
// //:     print qq(
// //:          ,. cdma2buf_dat_wr_mask      (cdma2buf_dat_wr_mask   )
// //:     );
// //:     foreach my $i (0..$k-1) {
// //:         print qq(
// //:             ,.cdma2buf_dat_wr_addr${i}      (cdma2buf_dat_wr_addr${i}   )
// //:             ,.cdma2buf_dat_wr_data${i}      (cdma2buf_dat_wr_data${i}   )
// //:         );
// //:     }
// //: } else {
// //:     print qq(
// //:       ,.cdma2buf_dat_wr_addr          (cdma2buf_dat_wr_addr)
// //:       ,.cdma2buf_dat_wr_data          (cdma2buf_dat_wr_data)
// //:     );
// //: }
//   //,.cdma2buf_dat_wr_addr          (cdma2buf_dat_wr_addr)
//   //,.cdma2buf_dat_wr_hsel          (cdma2buf_dat_wr_hsel)
//   //,.cdma2buf_dat_wr_data          (cdma2buf_dat_wr_data)
//   ,.cdma2buf_wt_wr_en             (cdma2buf_wt_wr_en)     
// //: my $dmaif=NVDLA_DMAIF_BW;
// //: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_BPE;
// //: if($dmaif < $atmc) {
// //:     my $k = int(log(int($atmc/$dmaif))/log(2));
// //:     print qq(
// //:         ,.cdma2buf_wt_wr_addr           (cdma2buf_wt_wr_addr) 
// //:         ,.cdma2buf_wt_wr_hsel            (cdma2buf_wt_wr_sel)        
// //:         ,.cdma2buf_wt_wr_data           (cdma2buf_wt_wr_data)
// //:     );
// //: } elsif($dmaif > $atmc) {
// //:     my $k = int(log(int($dmaif/$atmc))/log(2));
// //:     print qq(
// //:         ,.cdma2buf_wt_wr_mask    (cdma2buf_wt_wr_mask)
// //:     );
// //:     foreach my $i (0..$k-1) {
// //:         print qq(
// //:            ,.cdma2buf_wt_wr_addr${i}    (cdma2buf_wt_wr_addr${i})
// //:            ,.cdma2buf_wt_wr_data${i}    (cdma2buf_wt_wr_data${i})
// //:         );
// //:     }
// //: } else {
// //:     print qq(
// //:         ,.cdma2buf_wt_wr_addr           (cdma2buf_wt_wr_addr) 
// //:         ,.cdma2buf_wt_wr_data           (cdma2buf_wt_wr_data)
// //:     );
// //: }
//   //,.cdma2buf_wt_wr_addr           (cdma2buf_wt_wr_addr) 
//   //,.cdma2buf_wt_wr_hsel           (cdma2buf_wt_wr_hsel)       
//   //,.cdma2buf_wt_wr_data           (cdma2buf_wt_wr_data)
//   ,.sc2buf_dat_rd_en              (sc2buf_dat_rd_en)            
//   ,.sc2buf_dat_rd_addr            (sc2buf_dat_rd_addr)    
//   ,.sc2buf_dat_rd_valid           (sc2buf_dat_rd_valid)         
//   ,.sc2buf_dat_rd_data            (sc2buf_dat_rd_data)  
//   ,.sc2buf_wt_rd_en               (sc2buf_wt_rd_en)             
//   ,.sc2buf_wt_rd_addr             (sc2buf_wt_rd_addr)     
//   ,.sc2buf_wt_rd_valid            (sc2buf_wt_rd_valid)          
//   ,.sc2buf_wt_rd_data             (sc2buf_wt_rd_data)   
//   ,.sc2buf_wmb_rd_en              (sc2buf_wmb_rd_en)            
//   ,.sc2buf_wmb_rd_addr            (sc2buf_wmb_rd_addr)     
//   ,.sc2buf_wmb_rd_valid           (sc2buf_wmb_rd_valid)         
//   ,.sc2buf_wmb_rd_data            (sc2buf_wmb_rd_data)  
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])            //|< i
  ,.cdma2buf_wr_en0               (cdma2buf_dat_wr_en)             //|< w
  ,.cdma2buf_wr_addr0             (cdma2buf_dat_wr_addr[CBUF_ADDR_WIDTH-1:0])     //|< w
  ,.cdma2buf_wr_data0             (cdma2buf_dat_wr_data)//DorisL cdma2buf_dat_wr_data_new)   //|< w
  ,.cdma2buf_wr_en1               (cdma2buf_wt_wr_en)              //|< w
  ,.cdma2buf_wr_addr1             (cdma2buf_wt_wr_addr[CBUF_ADDR_WIDTH-1:0])      //|< w
  ,.cdma2buf_wr_data1             (cdma2buf_wt_wr_data)     //|< w
`ifdef CC_ATOMC_DIV_ATOMK_EQUAL_4  
  ,.cdma2buf_wr_sel0              (cdma2buf_dat_wr_sel)      //|< w
  ,.cdma2buf_wr_sel1              (cdma2buf_wt_wr_sel)      //|< w
`endif
`ifdef CC_ATOMC_DIV_ATOMK_EQUAL_2  
  ,.cdma2buf_wr_sel0              (cdma2buf_dat_wr_sel)      //|< w
  ,.cdma2buf_wr_sel1              (cdma2buf_wt_wr_sel)      //|< w
`endif
`ifdef CC_ATOMC_DIV_ATOMK_EQUAL_1  
  ,.cdma2buf_wr_sel0              ({CBUF_WR_BANK_SEL_WIDTH{1'b1}})      //|< w
  ,.cdma2buf_wr_sel1              ({CBUF_WR_BANK_SEL_WIDTH{1'b1}})      //|< w
`endif
  ,.sc2buf_dat_rd_en              (sc2buf_dat_rd_en)               //|< w
  ,.sc2buf_dat_rd_addr            (sc2buf_dat_rd_addr[CBUF_ADDR_WIDTH-1:0])       //|< w
  ,.sc2buf_dat_rd_valid           (sc2buf_dat_rd_valid)            //|> w
  ,.sc2buf_dat_rd_shift           (sc2buf_dat_rd_shift)
  ,.sc2buf_dat_rd_next1_en        (sc2buf_dat_rd_next1_en)
  ,.sc2buf_dat_rd_next1_addr      (sc2buf_dat_rd_next1_addr)
  ,.sc2buf_dat_rd_data            (sc2buf_dat_rd_data[CBUF_ENTRY_BITS-1:0])     //|> w
  ,.sc2buf_wt_rd_en               (sc2buf_wt_rd_en)                //|< w
  ,.sc2buf_wt_rd_addr             (sc2buf_wt_rd_addr[CBUF_ADDR_WIDTH-1:0])        //|< w
  ,.sc2buf_wt_rd_valid            (sc2buf_wt_rd_valid)             //|> w
  ,.sc2buf_wt_rd_data             (sc2buf_wt_rd_data[CBUF_ENTRY_BITS-1:0])      //|> w
  `ifdef CBUF_WEIGHT_COMPRESSED
  ,.sc2buf_wmb_rd_en              (sc2buf_wmb_rd_en)               //|< w
  ,.sc2buf_wmb_rd_addr            (sc2buf_wmb_rd_addr[CBUF_ADDR_WIDTH-1:0])        //|< w
  ,.sc2buf_wmb_rd_valid           (sc2buf_wmb_rd_valid)            //|> w
  ,.sc2buf_wmb_rd_data            (sc2buf_wmb_rd_data[CBUF_ENTRY_BITS-1:0])     //|> w
  `endif
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Convolution Sequence Controller             //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_csc u_NV_NVDLA_csc (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.sc2cdma_dat_pending_req       (sc2cdma_dat_pending_req)        //|> w
  ,.sc2cdma_wt_pending_req        (sc2cdma_wt_pending_req)         //|> w
  ,.accu2sc_credit_vld            (accu2sc_credit_vld)             //|< i
  ,.accu2sc_credit_size           (accu2sc_credit_size[2:0])       //|< i
  ,.cdma2sc_dat_pending_ack       (cdma2sc_dat_pending_ack)        //|< w
  ,.cdma2sc_wt_pending_ack        (cdma2sc_wt_pending_ack)         //|< w
  ,.csb2csc_req_pvld              (csb2csc_req_pvld)               //|< i
  ,.csb2csc_req_prdy              (csb2csc_req_prdy)               //|> o
  ,.csb2csc_req_pd                (csb2csc_req_pd[62:0])           //|< i
  ,.csc2csb_resp_valid            (csc2csb_resp_valid)             //|> o
  ,.csc2csb_resp_pd               (csc2csb_resp_pd[33:0])          //|> o
  ,.cdma2sc_dat_updt              (cdma2sc_dat_updt)               //|< w
  ,.cdma2sc_dat_entries           (cdma2sc_dat_entries[CSC_ENTRIES_NUM_WIDTH-1:0])      //|< w
  ,.cdma2sc_dat_slices            (cdma2sc_dat_slices[13:0])       //|< w
  ,.sc2cdma_dat_updt              (sc2cdma_dat_updt)               //|> w
  ,.sc2cdma_dat_entries           (sc2cdma_dat_entries[CSC_ENTRIES_NUM_WIDTH-1:0])      //|> w
  ,.sc2cdma_dat_slices            (sc2cdma_dat_slices[13:0])       //|> w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])            //|< i
  ,.sc2buf_dat_rd_en              (sc2buf_dat_rd_en)               //|> w
  ,.sc2buf_dat_rd_addr            (sc2buf_dat_rd_addr[CBUF_ADDR_WIDTH-1:0])       //|> w
  ,.sc2buf_dat_rd_valid           (sc2buf_dat_rd_valid)            //|< w
  ,.sc2buf_dat_rd_data            (sc2buf_dat_rd_data[CBUF_ENTRY_BITS-1:0])     //|< w
  ,.sc2buf_dat_rd_shift           (sc2buf_dat_rd_shift[CBUF_RD_DATA_SHIFT_WIDTH-1:0])
  ,.sc2buf_dat_rd_next1_en        (sc2buf_dat_rd_next1_en)
  ,.sc2buf_dat_rd_next1_addr      (sc2buf_dat_rd_next1_addr)
  `ifdef CBUF_WEIGHT_COMPRESSED
  ,.sc2buf_wmb_rd_en              (sc2buf_wmb_rd_en)               //|> w
  ,.sc2buf_wmb_rd_addr            (sc2buf_wmb_rd_addr[CBUF_ADDR_WIDTH-1:0])        //|> w
  ,.sc2buf_wmb_rd_valid           (sc2buf_wmb_rd_valid)            //|< w
  ,.sc2buf_wmb_rd_data            (sc2buf_wmb_rd_data[CBUF_ENTRY_BITS-1:0])     //|< w
  `endif
  ,.sc2buf_wt_rd_en               (sc2buf_wt_rd_en)                //|> w
  ,.sc2buf_wt_rd_addr             (sc2buf_wt_rd_addr[CBUF_ADDR_WIDTH-1:0])        //|> w
  ,.sc2buf_wt_rd_valid            (sc2buf_wt_rd_valid)             //|< w
  ,.sc2buf_wt_rd_data             (sc2buf_wt_rd_data[CBUF_ENTRY_BITS-1:0])      //|< w
#ifdef NVDLA_RETIMING_ENABLE
  ,.sc2mac_dat_a_pvld             (sc2mac_dat_a_src_pvld)          //|> o
  ,.sc2mac_dat_a_mask             (sc2mac_dat_a_src_mask[CSC_ATOMC-1:0])   //|> o
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_a_data${i}            (sc2mac_dat_a_src_data${i}[CSC_BPE-1:0])    //|> o   )
  //: }
  ,.sc2mac_dat_a_pd               (sc2mac_dat_a_src_pd[8:0])       //|> o
  ,.sc2mac_dat_b_pvld             (sc2mac_dat_b_src_pvld)          //|> w
  ,.sc2mac_dat_b_mask             (sc2mac_dat_b_src_mask[CSC_ATOMC-1:0])   //|> w
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_b_data${i}            (sc2mac_dat_b_src_data${i}[CSC_BPE-1:0])    //|> o   )
  //: }
  ,.sc2mac_dat_b_pd               (sc2mac_dat_b_src_pd[8:0])       //|> w
  ,.sc2mac_wt_a_pvld              (sc2mac_wt_a_src_pvld)           //|> o
  ,.sc2mac_wt_a_mask              (sc2mac_wt_a_src_mask[CSC_ATOMC-1:0])    //|> o
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_a_data${i}            (sc2mac_wt_a_src_data${i}[CSC_BPE-1:0])    //|> o   )
  //: }
  ,.sc2mac_wt_a_sel               (sc2mac_wt_a_src_sel[CSC_ATOMK_HF-1:0])       //|> o
  ,.sc2mac_wt_b_pvld              (sc2mac_wt_b_src_pvld)           //|> w
  ,.sc2mac_wt_b_mask              (sc2mac_wt_b_src_mask[CSC_ATOMC-1:0])    //|> w
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_b_data${i}            (sc2mac_wt_b_src_data${i}[CSC_BPE-1:0])    //|> o   )
  //: }
  ,.sc2mac_wt_b_sel               (sc2mac_wt_b_src_sel[CSC_ATOMK_HF-1:0])       //|> w
#else
  ,.sc2mac_dat_a_pvld             (sc2mac_dat_a_pvld)              //|> o
  ,.sc2mac_dat_a_mask             (sc2mac_dat_a_mask[CSC_ATOMC-1:0])       //|> o
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_a_data${i}            (sc2mac_dat_a_data${i}[CSC_BPE-1:0])    //|> o   )
  //: }
  ,.sc2mac_dat_a_pd               (sc2mac_dat_a_pd[8:0])           //|> o
  ,.sc2mac_dat_b_pvld             (sc2mac_dat_b_pvld)              //|> w
  ,.sc2mac_dat_b_mask             (sc2mac_dat_b_mask[CSC_ATOMC-1:0])       //|> w
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_b_data${i}            (sc2mac_dat_b_data${i}[CSC_BPE-1:0])    //|> o   )
  //: }
  ,.sc2mac_dat_b_pd               (sc2mac_dat_b_pd[8:0])           //|> w
  ,.sc2mac_wt_a_pvld              (sc2mac_wt_a_pvld)               //|> o
  ,.sc2mac_wt_a_mask              (sc2mac_wt_a_mask[CSC_ATOMC-1:0])        //|> o
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_a_data${i}            (sc2mac_wt_a_data${i}[CSC_BPE-1:0])    //|> o   )
  //: }
  ,.sc2mac_wt_a_sel               (sc2mac_wt_a_sel[CSC_ATOMK_HF-1:0])           //|> o
  ,.sc2mac_wt_b_pvld              (sc2mac_wt_b_pvld)               //|> w
  ,.sc2mac_wt_b_mask              (sc2mac_wt_b_mask[CSC_ATOMC-1:0])        //|> w
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_b_data${i}            (sc2mac_wt_b_data${i}[CSC_BPE-1:0])    //|> o   )
  //: }
  ,.sc2mac_wt_b_sel               (sc2mac_wt_b_sel[CSC_ATOMK_HF-1:0])           //|> w
#endif
  ,.cdma2sc_wt_updt               (cdma2sc_wt_updt)         
  ,.cdma2sc_wt_kernels            (cdma2sc_wt_kernels)
  ,.cdma2sc_wt_entries            (cdma2sc_wt_entries)
  ,.cdma2sc_wmb_entries           (cdma2sc_wmb_entries)
  ,.sc2cdma_wt_updt               (sc2cdma_wt_updt)         
  ,.sc2cdma_wt_kernels            (sc2cdma_wt_kernels)
  ,.sc2cdma_wt_entries            (sc2cdma_wt_entries)
  ,.sc2cdma_wmb_entries           (sc2cdma_wmb_entries)
  ,.dla_clk_ovr_on_sync           (csc_dla_clk_ovr_on_sync) 
  ,.global_clk_ovr_on_sync        (csc_global_clk_ovr_on_sync)   
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)
  );

#ifdef NVDLA_RETIMING_ENABLE
////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Retiming path csc->cmac_b                   //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_csc2cmac_b u_NV_NVDLA_RT_csc2cmac_b (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.sc2mac_wt_src_pvld            (sc2mac_wt_b_src_pvld)           //|< w
  ,.sc2mac_wt_src_mask            (sc2mac_wt_b_src_mask[CMAC_ATOMC-1:0])    //|< w
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_src_data${i}           (sc2mac_wt_b_src_data${i}[CMAC_BPE-1:0])     //|< w   )
  //: }
  ,.sc2mac_wt_src_sel             (sc2mac_wt_b_src_sel[CMAC_ATOMK_HALF-1:0])       //|< w
  ,.sc2mac_dat_src_pvld           (sc2mac_dat_b_src_pvld)          //|< w
  ,.sc2mac_dat_src_mask           (sc2mac_dat_b_src_mask[CMAC_ATOMC-1:0])   //|< w
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_src_data${i}           (sc2mac_dat_b_src_data${i}[CMAC_BPE-1:0])     //|< w   )
  //: }
  ,.sc2mac_dat_src_pd             (sc2mac_dat_b_src_pd[8:0])       //|< w
  ,.sc2mac_wt_dst_pvld            (sc2mac_wt_b_dst_pvld)           //|> o
  ,.sc2mac_wt_dst_mask            (sc2mac_wt_b_dst_mask[CMAC_ATOMC-1:0])    //|> o
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_dst_data${i}           (sc2mac_wt_b_dst_data${i}[CMAC_BPE-1:0])     //|< w   )
  //: }
  ,.sc2mac_wt_dst_sel             (sc2mac_wt_b_dst_sel[CMAC_ATOMK_HALF-1:0])       //|> o
  ,.sc2mac_dat_dst_pvld           (sc2mac_dat_b_dst_pvld)          //|> o
  ,.sc2mac_dat_dst_mask           (sc2mac_dat_b_dst_mask[CMAC_ATOMC-1:0])   //|> o
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_dst_data${i}           (sc2mac_dat_b_dst_data${i}[CMAC_BPE-1:0])     //|< w   )
  //: }
  ,.sc2mac_dat_dst_pd             (sc2mac_dat_b_dst_pd[8:0])       //|> o
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Retiming path csb->cmac_b                   //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_csb2cmac u_NV_NVDLA_RT_csb2cmac (
   .nvdla_core_clk                (nvdla_core_clk)              
  ,.nvdla_core_rstn               (nvdla_core_rstn)             
  ,.csb2cmac_req_src_pvld         (csb2cmac_b_req_src_pvld)     
  ,.csb2cmac_req_src_prdy         (csb2cmac_b_req_src_prdy)     
  ,.csb2cmac_req_src_pd           (csb2cmac_b_req_src_pd) 
  ,.cmac2csb_resp_src_valid       (cmac_b2csb_resp_src_valid)   
  ,.cmac2csb_resp_src_pd          (cmac_b2csb_resp_src_pd)
  ,.csb2cmac_req_dst_pvld         (csb2cmac_b_req_dst_pvld)     
  ,.csb2cmac_req_dst_prdy         (csb2cmac_b_req_dst_prdy)     
  ,.csb2cmac_req_dst_pd           (csb2cmac_b_req_dst_pd) 
  ,.cmac2csb_resp_dst_valid       (cmac_b2csb_resp_dst_valid)   
  ,.cmac2csb_resp_dst_pd          (cmac_b2csb_resp_dst_pd)
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Retiming path csb<->cacc                    //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_csb2cacc u_NV_NVDLA_RT_csb2cacc (
   .nvdla_core_clk                (nvdla_core_clk)             
  ,.nvdla_core_rstn               (nvdla_core_rstn)            
  ,.csb2cacc_req_src_pvld         (csb2cacc_req_src_pvld)      
  ,.csb2cacc_req_src_prdy         (csb2cacc_req_src_prdy)      
  ,.csb2cacc_req_src_pd           (csb2cacc_req_src_pd)  
  ,.cacc2csb_resp_src_valid       (cacc2csb_resp_src_valid)    
  ,.cacc2csb_resp_src_pd          (cacc2csb_resp_src_pd) 
  ,.csb2cacc_req_dst_pvld         (csb2cacc_req_dst_pvld)      
  ,.csb2cacc_req_dst_prdy         (csb2cacc_req_dst_prdy)      
  ,.csb2cacc_req_dst_pd           (csb2cacc_req_dst_pd)  
  ,.cacc2csb_resp_dst_valid       (cacc2csb_resp_dst_valid)    
  ,.cacc2csb_resp_dst_pd          (cacc2csb_resp_dst_pd) 
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Retiming path cacc->glbc                    //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_cacc2glb u_NV_NVDLA_RT_cacc2glb (
   .nvdla_core_clk                (nvdla_core_clk)           
  ,.nvdla_core_rstn               (nvdla_core_rstn)          
  ,.cacc2glb_done_intr_src_pd     (cacc2glb_done_intr_src_pd)
  ,.cacc2glb_done_intr_dst_pd     (cacc2glb_done_intr_dst_pd)
  );
#endif

////////////////////////////////////////////////////////////////////////
//  Dangles/Contenders report                                         //
////////////////////////////////////////////////////////////////////////

endmodule // NV_NVDLA_partition_c


