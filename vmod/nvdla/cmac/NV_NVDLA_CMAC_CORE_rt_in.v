// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_CORE_rt_in.v

#include "NV_NVDLA_CMAC.h"
module NV_NVDLA_CMAC_CORE_rt_in (
   nvdla_core_clk
  ,nvdla_core_rstn
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: ,sc2mac_dat_data${i});
//: }
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: ,in_dat_data${i});
//: }
  ,sc2mac_dat_mask
  ,sc2mac_dat_pd
  ,sc2mac_dat_pvld
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: ,sc2mac_wt_data${i});
//: }
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: ,in_wt_data${i});
//: }
  ,sc2mac_wt_mask
  ,sc2mac_wt_pvld
  ,sc2mac_wt_sel
  ,in_dat_mask
  ,in_dat_pd
  ,in_dat_pvld
  ,in_dat_stripe_end
  ,in_dat_stripe_st
  ,in_wt_mask
  ,in_wt_pvld
  ,in_wt_sel
  );

//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: input   [CMAC_BPE-1:0]  sc2mac_dat_data${i};);
//: }
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: output  [CMAC_BPE-1:0]  in_dat_data${i};);
//: }

//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: input   [CMAC_BPE-1:0] sc2mac_wt_data${i};);
//: }
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: output  [CMAC_BPE-1:0] in_wt_data${i};);
//: }
input           nvdla_core_clk;
input           nvdla_core_rstn;
input   [CMAC_ATOMC-1:0] sc2mac_dat_mask;
input   [8:0]   sc2mac_dat_pd;
input           sc2mac_dat_pvld;
input   [CMAC_ATOMC-1:0] sc2mac_wt_mask;
input           sc2mac_wt_pvld;
input   [CMAC_ATOMK_HALF-1:0] sc2mac_wt_sel;
output  [CMAC_ATOMC-1:0] in_dat_mask;
output  [8:0]   in_dat_pd;
output          in_dat_pvld;
output          in_dat_stripe_end;
output          in_dat_stripe_st;
output  [CMAC_ATOMC-1:0] in_wt_mask;
output          in_wt_pvld;
output  [CMAC_ATOMK_HALF-1:0] in_wt_sel;

//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: wire [CMAC_BPE-1:0] in_dat_data${i};
//: wire [CMAC_BPE-1:0] in_wt_data${i};)
//: }
wire    [CMAC_ATOMC-1:0]    in_dat_mask;
wire    [8:0]               in_dat_pd;
wire                        in_dat_pvld;
wire                        in_dat_stripe_end;
wire                        in_dat_stripe_st;
wire    [CMAC_ATOMC-1:0]    in_wt_mask;
wire                        in_wt_pvld;
wire    [CMAC_ATOMK_HALF-1:0] in_wt_sel;
wire                        in_rt_dat_pvld_d0;
wire    [CMAC_ATOMC-1:0]    in_rt_dat_mask_d0;
wire    [8:0]               in_rt_dat_pd_d0;
wire    [CMAC_BPE*CMAC_ATOMC-1:0] in_rt_dat_data_d0;
//: for(my $i=1; $i<CMAC_IN_RT_LATENCY+1; $i++){
//: print qq(
//: reg     in_rt_dat_pvld_d${i};
//: reg     [CMAC_ATOMC-1:0]   in_rt_dat_mask_d${i};
//: reg     [8:0]              in_rt_dat_pd_d${i};
//: reg     [CMAC_BPE*CMAC_ATOMC-1:0] in_rt_dat_data_d${i};
//: );
//: }

wire    [CMAC_BPE*CMAC_ATOMC-1:0]   in_rt_wt_data_d0;
wire    [CMAC_ATOMC-1:0]            in_rt_wt_mask_d0;
wire                                in_rt_wt_pvld_d0;
wire    [CMAC_ATOMK_HALF-1:0]       in_rt_wt_sel_d0;
//: for(my $i=1; $i<CMAC_IN_RT_LATENCY+1; $i++){
//: print qq(
//: reg    [CMAC_BPE*CMAC_ATOMC-1:0]    in_rt_wt_data_d${i};
//: reg    [CMAC_ATOMC-1:0]             in_rt_wt_mask_d${i};
//: reg                                 in_rt_wt_pvld_d${i};
//: reg    [CMAC_ATOMK_HALF-1:0]        in_rt_wt_sel_d${i};
//: )
//: }

assign    in_rt_dat_pvld_d0 = sc2mac_dat_pvld;
assign    in_rt_dat_mask_d0 = sc2mac_dat_mask;
assign    in_rt_dat_pd_d0   = sc2mac_dat_pd;
assign    in_rt_wt_pvld_d0 = sc2mac_wt_pvld;
assign    in_rt_wt_mask_d0 = sc2mac_wt_mask;
assign    in_rt_wt_sel_d0 = sc2mac_wt_sel;
//:     my $kk=CMAC_BPE;
//:     for(my $k = 0; $k <CMAC_ATOMC; $k ++) {
//:         print "wire [$kk-1:0]  in_rt_dat_data${k}_d0 = sc2mac_dat_data${k}; \n"; 
//:     }
//:     for(my $k = 0; $k <CMAC_ATOMC; $k ++) {
//:         print "wire [$kk-1:0]  in_rt_wt_data${k}_d0 = sc2mac_wt_data${k}; \n"; 
//:     }

//==========================================================
// Retiming flops,add latency.
//==========================================================
//: my $latency = CMAC_IN_RT_LATENCY;
//: my $bpe=CMAC_BPE;
//: for(my $i = 0; $i < $latency; $i ++) {
//:     my $j = $i + 1;
//:     &eperl::flop("-nodeclare -q  in_rt_dat_pvld_d${j}  -d \"in_rt_dat_pvld_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//:     &eperl::flop("-nodeclare -q  in_rt_dat_mask_d${j}  -en \"in_rt_dat_pvld_d${i} | in_rt_dat_pvld_d${j}\" -d  \"in_rt_dat_mask_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//:     &eperl::flop("-nodeclare -q  in_rt_dat_pd_d${j}    -en \"in_rt_dat_pvld_d${i} | in_rt_dat_pvld_d${j}\" -d  \"in_rt_dat_pd_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn ");
//:     for(my $k = 0; $k <CMAC_ATOMC; $k ++) {
//:         &eperl::flop("-norst -wid $bpe -q  in_rt_dat_data${k}_d${j}  -en \"in_rt_dat_mask_d${i}[${k}]\" -d  \"in_rt_dat_data${k}_d${i}\" -clk nvdla_core_clk"); 
//:     }
//:
//:     &eperl::flop("-nodeclare -q  in_rt_wt_pvld_d${j}  -d \"in_rt_wt_pvld_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//:     &eperl::flop("-nodeclare -q  in_rt_wt_mask_d${j}  -en \"in_rt_wt_pvld_d${i} | in_rt_wt_pvld_d${j}\" -d  \"in_rt_wt_mask_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn ");
//:     &eperl::flop("-nodeclare -q  in_rt_wt_sel_d${j} -en \"in_rt_wt_pvld_d${i} | in_rt_wt_pvld_d${j}\" -d  \"in_rt_wt_sel_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn ");
//: 
//:     my $bpe = CMAC_BPE;
//:     for(my $k = 0; $k <CMAC_ATOMC; $k ++) {
//:         &eperl::flop("-norst -wid $bpe -q  in_rt_wt_data${k}_d${j}  -en \"in_rt_wt_mask_d${i}[${k}]\" -d  \"in_rt_wt_data${k}_d${i}\" -clk nvdla_core_clk"); 
//:     }
//: }
//: 
//: my $i = $latency;
//: print "assign    in_dat_pvld = in_rt_dat_pvld_d${i};\n";
//: print "assign    in_dat_mask = in_rt_dat_mask_d${i};\n";
//: print "assign    in_dat_pd   = in_rt_dat_pd_d${i};\n";
//: print "assign    in_wt_pvld = in_rt_wt_pvld_d${i};\n";
//: print "assign    in_wt_mask = in_rt_wt_mask_d${i};\n";
//: print "assign    in_wt_sel = in_rt_wt_sel_d${i};\n";
//: 
//: my $k=$latency;
//: for(my $i=0; $i<CMAC_ATOMC; $i++){
//: print qq(
//: assign in_dat_data${i} = in_rt_dat_data${i}_d${k}; )
//: }
//: for(my $i=0; $i<CMAC_ATOMC; $i++){
//: print qq(
//: assign in_wt_data${i} = in_rt_wt_data${i}_d${k};)
//: }


//: my $i= PKT_nvdla_stripe_info_stripe_st_FIELD;
//: my $j= PKT_nvdla_stripe_info_stripe_end_FIELD;
//: print qq(
//: assign    in_dat_stripe_st  = in_dat_pd[${i}];
//: assign    in_dat_stripe_end = in_dat_pd[${j}]; );
endmodule
