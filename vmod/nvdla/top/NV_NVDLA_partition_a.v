// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_partition_a.v

#include "NV_NVDLA_define.h"

`include "NV_HWACC_NVDLA_tick_defines.vh"

#include "../cacc/NV_NVDLA_CACC.h"
#include "../cmac/NV_NVDLA_CMAC.h"
module NV_NVDLA_partition_a (
   cacc2sdp_ready              
#ifdef NVDLA_RETIMING_ENABLE
  ,csb2cacc_req_dst_pvld       
  ,csb2cacc_req_dst_prdy       
  ,csb2cacc_req_dst_pd         
  ,cacc2csb_resp_src_pd        
  ,cacc2csb_resp_src_valid     
  ,cacc2glb_done_intr_src_pd   
#else
  ,csb2cacc_req_pvld           
  ,csb2cacc_req_prdy           
  ,csb2cacc_req_pd             
  ,cacc2csb_resp_pd            
  ,cacc2csb_resp_valid         
  ,cacc2glb_done_intr_pd       
#endif
  ,direct_reset_               
  ,dla_reset_rstn              
  ,global_clk_ovr_on           
#ifdef NVDLA_RETIMING_ENABLE
//: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
//: print qq(
//: ,mac_a2accu_dst_data${i}   )
//: }
  ,mac_a2accu_dst_mask         
  ,mac_a2accu_dst_mode         
  ,mac_a2accu_dst_pd           
  ,mac_a2accu_dst_pvld         
//: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
//: print qq(
//: ,mac_b2accu_src_data${i}   )
//: }
  ,mac_b2accu_src_mask         
  ,mac_b2accu_src_mode         
  ,mac_b2accu_src_pd           
  ,mac_b2accu_src_pvld         
#else
//: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
//: print qq(
//: ,mac_a2accu_data${i}   )
//: }
  ,mac_a2accu_mask             
  ,mac_a2accu_mode             
  ,mac_a2accu_pd               
  ,mac_a2accu_pvld             
//: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
//: print qq(
//: ,mac_b2accu_data${i}   )
//: }
  ,mac_b2accu_mask             
  ,mac_b2accu_mode             
  ,mac_b2accu_pd               
  ,mac_b2accu_pvld             
#endif
  ,nvdla_clk_ovr_on            
  ,nvdla_core_clk              
  ,pwrbus_ram_pd               
  ,test_mode                   
  ,tmc2slcg_disable_clock_gating
  ,accu2sc_credit_size          
  ,accu2sc_credit_vld           
  ,cacc2sdp_pd                  
  ,cacc2sdp_valid               
  );

//
// NV_NVDLA_partition_a_io.v
//

input  test_mode;
input  direct_reset_;

input  global_clk_ovr_on;
input  tmc2slcg_disable_clock_gating;

output       accu2sc_credit_vld;   /* data valid */
output [2:0] accu2sc_credit_size;

#ifdef NVDLA_RETIMING_ENABLE
output        cacc2csb_resp_src_valid;  /* data valid */
output [33:0] cacc2csb_resp_src_pd;     /* pkt_id_width=1 pkt_widths=33,33  */
output [1:0]  cacc2glb_done_intr_src_pd;
input         csb2cacc_req_dst_pvld;  /* data valid */
output        csb2cacc_req_dst_prdy;  /* data return handshake */
input  [62:0] csb2cacc_req_dst_pd;

#else
output        cacc2csb_resp_valid;  /* data valid */
output [33:0] cacc2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */
output [1:0]  cacc2glb_done_intr_pd;
input         csb2cacc_req_pvld;  /* data valid */
output        csb2cacc_req_prdy;  /* data return handshake */
input  [62:0] csb2cacc_req_pd;

#endif

output         cacc2sdp_valid;  /* data valid */
input          cacc2sdp_ready;  /* data return handshake */
output [CACC_SDP_WIDTH-1:0] cacc2sdp_pd;


#ifdef NVDLA_RETIMING_ENABLE
input         mac_a2accu_dst_pvld;   /* data valid */
input   [CMAC_ATOMK_HALF-1:0] mac_a2accu_dst_mask;
input   mac_a2accu_dst_mode;
//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//: print qq(
//: input [CMAC_RESULT_WIDTH-1:0] mac_a2accu_dst_data${i};   )
//: }
input   [8:0] mac_a2accu_dst_pd;
input         mac_b2accu_src_pvld;   /* data valid */
input   [CMAC_ATOMK_HALF-1:0] mac_b2accu_src_mask;
input   mac_b2accu_src_mode;
//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//: print qq(
//: input [CMAC_RESULT_WIDTH-1:0] mac_b2accu_src_data${i};   )
//: }
input   [8:0] mac_b2accu_src_pd;
#else
input         mac_a2accu_pvld;   /* data valid */
input   [CMAC_ATOMK_HALF-1:0] mac_a2accu_mask;
input   mac_a2accu_mode;
//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//: print qq(
//: input [CMAC_RESULT_WIDTH-1:0] mac_a2accu_data${i};   )
//: }
input   [8:0] mac_a2accu_pd;
input         mac_b2accu_pvld;   /* data valid */
input   [CMAC_ATOMK_HALF-1:0] mac_b2accu_mask;
input   mac_b2accu_mode;
//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//: print qq(
//: input [CMAC_RESULT_WIDTH-1:0] mac_b2accu_data${i};   )
//: }
input   [8:0] mac_b2accu_pd;
#endif

input [31:0] pwrbus_ram_pd;

//input  la_r_clk;           
//input  larstn;             

input  nvdla_core_clk;     
input  dla_reset_rstn;     

input         nvdla_clk_ovr_on;

wire          dla_clk_ovr_on_sync;
wire          global_clk_ovr_on_sync;
#ifdef NVDLA_RETIMING_ENABLE
//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//: print qq(
//: wire  [CMAC_RESULT_WIDTH-1:0] mac_b2accu_dst_data${i}; )
//: }
wire    [CMAC_ATOMK_HALF-1:0] mac_b2accu_dst_mask;
wire    mac_b2accu_dst_mode;
wire    [8:0] mac_b2accu_dst_pd;
wire          mac_b2accu_dst_pvld;
#else
//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//: print qq(
//: wire  [CMAC_RESULT_WIDTH-1:0] mac_b2accu_data${i}; )
//: }
wire    [CMAC_ATOMK_HALF-1:0] mac_b2accu_mask;
wire    mac_b2accu_mode;
wire    [8:0] mac_b2accu_pd;
wire          mac_b2accu_pvld;
#endif
wire          nvdla_core_rstn;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition M:    Reset Syncer                                //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_reset u_partition_a_reset (
   .dla_reset_rstn                (dla_reset_rstn)                 //|< i
  ,.direct_reset_                 (direct_reset_)                  //|< i
  ,.test_mode                     (test_mode)                      //|< i
  ,.synced_rstn                   (nvdla_core_rstn)                //|> w
  ,.nvdla_clk                     (nvdla_core_clk)                 //|< i
  );

////////////////////////////////////////////////////////////////////////
// SLCG override
////////////////////////////////////////////////////////////////////////
NV_NVDLA_sync3d u_dla_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)                 //|< i
  ,.sync_i                        (nvdla_clk_ovr_on)               //|< i
  ,.sync_o                        (dla_clk_ovr_on_sync)            //|> w
  );

NV_NVDLA_sync3d_s u_global_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)                 //|< i
  ,.prst                          (nvdla_core_rstn)                //|< w
  ,.sync_i                        (global_clk_ovr_on)              //|< i
  ,.sync_o                        (global_clk_ovr_on_sync)         //|> w
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition A:     Convolution Accumulator                    //
////////////////////////////////////////////////////////////////////////
//stepheng, modify for cacc verification
NV_NVDLA_cacc u_NV_NVDLA_cacc (
   .nvdla_core_clk                (nvdla_core_clk) 
  ,.nvdla_core_rstn               (nvdla_core_rstn)
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd)  
#ifdef NVDLA_RETIMING_ENABLE
  ,.csb2cacc_req_pvld             (csb2cacc_req_dst_pvld)         
  ,.csb2cacc_req_prdy             (csb2cacc_req_dst_prdy)         
  ,.csb2cacc_req_pd               (csb2cacc_req_dst_pd)     
  ,.cacc2csb_resp_valid           (cacc2csb_resp_src_valid)       
  ,.cacc2csb_resp_pd              (cacc2csb_resp_src_pd)    
  ,.cacc2glb_done_intr_pd         (cacc2glb_done_intr_src_pd)
#else
  ,.csb2cacc_req_pvld             (csb2cacc_req_pvld)          
  ,.csb2cacc_req_prdy             (csb2cacc_req_prdy)          
  ,.csb2cacc_req_pd               (csb2cacc_req_pd)      
  ,.cacc2csb_resp_valid           (cacc2csb_resp_valid)        
  ,.cacc2csb_resp_pd              (cacc2csb_resp_pd)     
  ,.cacc2glb_done_intr_pd         (cacc2glb_done_intr_pd) 
#endif
#ifdef NVDLA_RETIMING_ENABLE
  ,.mac_a2accu_pvld               (mac_a2accu_dst_pvld)            //|< i
  ,.mac_a2accu_mask               (mac_a2accu_dst_mask[CMAC_ATOMK_HALF-1:0])       //|< i
  ,.mac_a2accu_mode               (mac_a2accu_dst_mode)       //|< i
  //:for(my $i=0; $i<CACC_ATOMK/2; $i++){
  //: print ",.mac_a2accu_data${i}              (mac_a2accu_dst_data${i}) \n";   #//|< i
  //: }
  ,.mac_a2accu_pd                 (mac_a2accu_dst_pd[8:0])         //|< i
  ,.mac_b2accu_pvld               (mac_b2accu_dst_pvld)            //|< w
  ,.mac_b2accu_mask               (mac_b2accu_dst_mask[CMAC_ATOMK_HALF-1:0])       //|< w
  ,.mac_b2accu_mode               (mac_b2accu_dst_mode)       //|< w
  //:for(my $i=0; $i<CACC_ATOMK/2; $i++){
  //: print ",.mac_b2accu_data${i}              (mac_b2accu_dst_data${i}) \n";   #//|< i
  //: }
  ,.mac_b2accu_pd                 (mac_b2accu_dst_pd[8:0])         //|< w
#else
  ,.mac_a2accu_pvld               (mac_a2accu_pvld)                //|< i
  ,.mac_a2accu_mask               (mac_a2accu_mask[CMAC_ATOMK_HALF-1:0])           //|< i
  ,.mac_a2accu_mode               (mac_a2accu_mode)           //|< i
  //:for(my $i=0; $i<CACC_ATOMK/2; $i++){
  //: print ",.mac_a2accu_data${i}              (mac_a2accu_data${i}) \n";   #//|< i
  //: }
  ,.mac_a2accu_pd                 (mac_a2accu_pd[8:0])             //|< i
  ,.mac_b2accu_pvld               (mac_b2accu_pvld)                //|< w
  ,.mac_b2accu_mask               (mac_b2accu_mask[CMAC_ATOMK_HALF-1:0])           //|< w
  ,.mac_b2accu_mode               (mac_b2accu_mode)           //|< w
  //:for(my $i=0; $i<CACC_ATOMK/2; $i++){
  //: print ",.mac_b2accu_data${i}              (mac_b2accu_data${i}) \n";   #//|< i
  //: }
  ,.mac_b2accu_pd                 (mac_b2accu_pd[8:0])             //|< w
#endif
  ,.cacc2sdp_valid                (cacc2sdp_valid)        
  ,.cacc2sdp_ready                (cacc2sdp_ready)        
  ,.cacc2sdp_pd                   (cacc2sdp_pd)    
  ,.accu2sc_credit_vld            (accu2sc_credit_vld)    
  ,.accu2sc_credit_size           (accu2sc_credit_size)
  ,.dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)
  );

#ifdef NVDLA_RETIMING_ENABLE
////////////////////////////////////////////////////////////////////////
//  NVDLA Partition A:    Retiming path cmac_b->cacc                  //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_cmac_b2cacc u_NV_NVDLA_RT_cmac_b2cacc (
   .nvdla_core_clk                (nvdla_core_clk)             
  ,.nvdla_core_rstn               (nvdla_core_rstn)            
  ,.mac2accu_src_pvld             (mac_b2accu_src_pvld)        
  ,.mac2accu_src_mask             (mac_b2accu_src_mask)   
  ,.mac2accu_src_mode             (mac_b2accu_src_mode)   
  //: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
  //: print qq(
  //: ,.mac2accu_src_data${i}            (mac_b2accu_src_data${i})   )
  //: }
  ,.mac2accu_src_pd               (mac_b2accu_src_pd)     
  ,.mac2accu_dst_pvld             (mac_b2accu_dst_pvld)        
  ,.mac2accu_dst_mask             (mac_b2accu_dst_mask)   
  ,.mac2accu_dst_mode             (mac_b2accu_dst_mode)   
  //: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
  //: print qq(
  //: ,.mac2accu_dst_data${i}            (mac_b2accu_dst_data${i})   )
  //: }
  ,.mac2accu_dst_pd               (mac_b2accu_dst_pd)     
  );
#endif

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition A:    OBS                                         //
////////////////////////////////////////////////////////////////////////
//&Instance NV_NVDLA_A_obs;

////////////////////////////////////////////////////////////////////////
//  Dangles/Contenders report                                         //
////////////////////////////////////////////////////////////////////////

//|
//|
//|
//|

endmodule // NV_NVDLA_partition_a


