// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_CORE_active.v

#include "NV_NVDLA_CMAC.h"

module NV_NVDLA_CMAC_CORE_active (
   nvdla_core_clk
  ,nvdla_core_rstn
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: ,in_dat_data${i})
//: }
  ,in_dat_mask
  ,in_dat_pvld
  ,in_dat_stripe_end
  ,in_dat_stripe_st
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: ,in_wt_data${i})
//: }
  ,in_wt_mask
  ,in_wt_pvld
  ,in_wt_sel
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//:  ,dat${i}_actv_data
//:  ,dat${i}_actv_nz
//:  ,dat${i}_actv_pvld
//:  ,dat${i}_pre_mask
//:  ,dat${i}_pre_pvld
//:  ,dat${i}_pre_stripe_end
//:  ,dat${i}_pre_stripe_st
//: )
//: }

//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//:  ,wt${i}_actv_data
//:  ,wt${i}_actv_nz
//:  ,wt${i}_actv_pvld
//:  ,wt${i}_sd_mask
//:  ,wt${i}_sd_pvld
//: )
//: }
  );

input           nvdla_core_clk;
input           nvdla_core_rstn;
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: input [CMAC_BPE-1:0] in_dat_data${i};)
//: }
input   [CMAC_ATOMC-1:0] in_dat_mask;
input           in_dat_pvld;
input           in_dat_stripe_end;
input           in_dat_stripe_st;
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: input [CMAC_BPE-1:0] in_wt_data${i};)
//: }
input   [CMAC_ATOMC-1:0] in_wt_mask;
input           in_wt_pvld;
input   [CMAC_ATOMK_HALF-1:0] in_wt_sel;
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//:  output [CMAC_BPE*CMAC_ATOMC-1:0] dat${i}_actv_data;
//:  output [CMAC_ATOMC-1:0] dat${i}_actv_nz;
//:  output [CMAC_ATOMC-1:0] dat${i}_actv_pvld;
//:  output [CMAC_ATOMC-1:0] dat${i}_pre_mask;
//:  output dat${i}_pre_pvld;
//:  output dat${i}_pre_stripe_end;
//:  output dat${i}_pre_stripe_st;
//: )
//: }

//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: output [CMAC_BPE*CMAC_ATOMC-1:0] wt${i}_actv_data;
//: output [CMAC_ATOMC-1:0] wt${i}_actv_nz;
//: output [CMAC_ATOMC-1:0] wt${i}_actv_pvld;
//: output [CMAC_ATOMC-1:0] wt${i}_sd_mask;
//: output wt${i}_sd_pvld;
//: )
//: }

//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: reg  [CMAC_BPE*CMAC_ATOMC-1:0]  dat_actv_data_reg${i};
//: )
//: }
wire    [CMAC_BPE*CMAC_ATOMC-1:0]    dat_pre_data_w;
wire   [CMAC_ATOMC-1:0]             dat_pre_mask_w;
reg    [CMAC_ATOMC-1:0]             dat_pre_nz_w;
reg                                 dat_pre_stripe_end;
reg                                 dat_pre_stripe_st;
reg    [CMAC_BPE*CMAC_ATOMC-1:0]    wt_pre_data;
wire    [CMAC_BPE*CMAC_ATOMC-1:0]    wt_pre_data_w;
reg    [CMAC_ATOMC-1:0]             wt_pre_mask;
wire    [CMAC_ATOMC-1:0]             wt_pre_mask_w;
reg    [CMAC_ATOMC-1:0]             wt_pre_nz_w;


//: my $kk=CMAC_ATOMC;
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: wire [${kk}-1:0] wt${i}_sd_mask={${kk}{1'b0}};
//: wire [${kk}-1:0] dat${i}_pre_mask={${kk}{1'b0}};
//: )
//: }

/////////////////////////////////////// handle weight ///////////////////////
// weight pack
//:    print "assign    wt_pre_data_w  = {";
//:    for(my $i = CMAC_ATOMC-1; $i >= 0; $i --) {
//:        print "in_wt_data${i}";
//:        if($i == 0) {
//:            print "};\n";
//:        } elsif ($i % 8 == 0) {
//:            print ",\n                       ";
//:        } else {
//:            print ", ";
//:        }
//:    }

// weight mask pack
//:    print "assign    wt_pre_mask_w = {";
//:    for(my $i = CMAC_ATOMC-1; $i >= 0; $i --) {
//:        print "in_wt_mask[${i}]";
//:        if($i == 0) {
//:            print "};\n";
//:        } elsif ($i % 8 == 0) {
//:            print ",\n                       ";
//:        } else {
//:            print ", ";
//:        }
//:    }




// 1 pipe for input
//: my $i=CMAC_ATOMC;
//: my $j=CMAC_ATOMK_HALF;
//: &eperl::flop(" -q  wt_pre_nz    -en in_wt_pvld -d  wt_pre_mask_w -wid ${i}  -clk nvdla_core_clk -rst nvdla_core_rstn"); 
//: &eperl::flop(" -q wt_pre_sel -d \"in_wt_sel&{${j}{in_wt_pvld}}\" -wid ${j} -clk nvdla_core_clk -rst nvdla_core_rstn");
//: 
//:     for (my $i = 0; $i < CMAC_ATOMC; $i ++) {
//:         my $b0 = $i * 8;
//:         my $b1 = $i * 8 + 7;
//:  &eperl::flop("-nodeclare -norst -q  wt_pre_data[${b1}:${b0}]  -en \"in_wt_pvld & wt_pre_mask_w[${i}]\" -d  \"wt_pre_data_w[${b1}:${b0}]\" -clk nvdla_core_clk"); 
//:  }


// put input weight into shadow.
//:     for(my $i = 0; $i < CMAC_ATOMK_HALF; $i ++) {
//:         print qq (
//:     reg wt${i}_sd_pvld;
//:     wire    wt${i}_sd_pvld_w = wt_pre_sel[${i}] ? 1'b1 : dat_pre_stripe_st ? 1'b0 : wt${i}_sd_pvld; ); 
//: my $kk=CMAC_ATOMC;
//: &eperl::flop("-nodeclare -q  wt${i}_sd_pvld  -d \"wt${i}_sd_pvld_w\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//: &eperl::flop(" -q  wt${i}_sd_nz -en wt_pre_sel[${i}] -d  \"wt_pre_nz\" -wid ${kk} -clk nvdla_core_clk -rst nvdla_core_rstn"); 
//: 
//: print qq(
//: reg [CMAC_BPE*CMAC_ATOMC-1:0] wt${i}_sd_data; );
//:  for(my $k = 0; $k < CMAC_ATOMC; $k ++) {
//:     my $b0 = $k * 8;
//:     my $b1 = $k * 8 + 7;
//:     &eperl::flop("-nodeclare -norst -q  wt${i}_sd_data[${b1}:${b0}]  -en \"wt_pre_sel[${i}] & wt_pre_nz[${k}]\" -d  \"wt_pre_data[${b1}:${b0}] \" -clk nvdla_core_clk"); 
//:     }
//: }
//: &eperl::flop(" -q  dat_actv_stripe_end  -d \"dat_pre_stripe_end\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 


// pop weight from shadow when new stripe begin.
//:     for(my $i = 0; $i < CMAC_ATOMK_HALF; $i ++) {
//:         print qq {
//:     reg wt${i}_actv_vld; 
//:     reg [CMAC_BPE*CMAC_ATOMC-1:0] wt${i}_actv_data;
//:     wire wt${i}_actv_pvld_w = dat_pre_stripe_st ? wt${i}_sd_pvld : dat_actv_stripe_end ? 1'b0 : wt${i}_actv_vld;
//: };
//: my $cmac_atomc = CMAC_ATOMC;
//: &eperl::flop(" -q  wt${i}_actv_vld   -d \"wt${i}_actv_pvld_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -nodeclare"); 
//: &eperl::flop(" -q  wt${i}_actv_pvld  -d \"{${cmac_atomc}{wt${i}_actv_pvld_w}}\" -clk nvdla_core_clk -rst nvdla_core_rstn -wid ${cmac_atomc}"); 
//: &eperl::flop(" -q  wt${i}_actv_nz    -en \"dat_pre_stripe_st & wt${i}_actv_pvld_w\" -d  \"wt${i}_sd_nz\" -clk nvdla_core_clk -rst nvdla_core_rstn -wid ${cmac_atomc}"); 
//: 
//:         for(my $k = 0; $k < CMAC_ATOMC; $k ++) {
//:             my $b0 = $k * 8;
//:             my $b1 = $k * 8 + 7;
//: &eperl::flop("-nodeclare -norst -q  wt${i}_actv_data[${b1}:${b0}]  -en \"dat_pre_stripe_st & wt${i}_actv_pvld_w\" -d  \"{8{wt${i}_sd_nz[${k}]}} & wt${i}_sd_data[${b1}:${b0}]\" -clk nvdla_core_clk"); 
//:     }
//: }


////////////////////////////////// handle data ///////////////
// data pack
//:    print "assign    dat_pre_data_w  = {";
//:    for(my $i = CMAC_INPUT_NUM-1; $i >= 0; $i --) {
//:        print "in_dat_data${i}";
//:        if($i == 0) {
//:            print "};\n";
//:        } elsif ($i % 8 == 0) {
//:            print ",\n                       ";
//:        } else {
//:            print ", ";
//:        }
//:    }

// data mask pack
//:    print "assign    dat_pre_mask_w = {";
//:    for(my $i = CMAC_INPUT_NUM-1; $i >= 0; $i --) {
//:        print "in_dat_mask[${i}]";
//:        if($i == 0) {
//:            print "};\n";
//:        } elsif ($i % 8 == 0) {
//:            print ",\n                       ";
//:        } else {
//:            print ", ";
//:        }
//:    }


// 1 pipe for input data
//: my $kk= CMAC_ATOMC; 
//: &eperl::flop(" -q  dat_pre_pvld   -d \"in_dat_pvld\"  -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//: &eperl::flop(" -q  dat_pre_nz     -en \"in_dat_pvld\" -d  \"dat_pre_mask_w\" -wid ${kk} -clk nvdla_core_clk -rst nvdla_core_rstn"); 

reg [CMAC_BPE*CMAC_ATOMC-1:0] dat_pre_data;
//:     for (my $i = 0; $i < CMAC_ATOMC; $i ++) {
//:         my $b0 = $i * 8;
//:         my $b1 = $i * 8 + 7;
//: &eperl::flop("-nodeclare -norst -q  dat_pre_data[${b1}:${b0}]  -en \"in_dat_pvld & dat_pre_mask_w[${i}]\" -d  \"dat_pre_data_w[${b1}:${b0}]\" -clk nvdla_core_clk"); 
//: }
//: &eperl::flop("-nodeclare -q  dat_pre_stripe_st   -d  \"in_dat_stripe_st & in_dat_pvld\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//: &eperl::flop("-nodeclare -q  dat_pre_stripe_end  -d  \"in_dat_stripe_end & in_dat_pvld \" -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//:     for(my $i = 0; $i < CMAC_ATOMK_HALF; $i ++) {
//:         print qq {
//: assign    dat${i}_pre_pvld       = dat_pre_pvld;
//: assign    dat${i}_pre_stripe_st  = dat_pre_stripe_st;
//: assign    dat${i}_pre_stripe_end = dat_pre_stripe_end;
//:     };
//: }

// get data for cmac, 1 pipe.
//: my $atomc= CMAC_ATOMC; 
//: for(my $i = 0; $i < CMAC_ATOMK_HALF; $i ++) {
//:     my $l = $i + 8;
//:     &eperl::flop(" -q  dat_actv_pvld_reg${i}  -d \"{${atomc}{dat_pre_pvld}}\" -wid ${atomc} -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//:     &eperl::flop(" -q  dat_actv_nz_reg${i}    -en dat_pre_pvld -d  dat_pre_nz -wid $atomc -clk nvdla_core_clk -rst nvdla_core_rstn"); 
//:     for(my $k = 0; $k < CMAC_ATOMC; $k ++) {
//:         my $j = int($k/2);
//:         my $b0 = $k * 8;
//:         my $b1 = $k * 8 + 7;
//:         &eperl::flop("-nodeclare -norst -q  dat_actv_data_reg${i}[${b1}:${b0}]  -en \"dat_pre_pvld & dat_pre_nz[${k}]\" -d  \"dat_pre_data[${b1}:${b0}]\" -clk nvdla_core_clk"); 
//:     }
//: }

//:     for(my $i = 0; $i < CMAC_ATOMK_HALF; $i ++) {
//:         print qq {
//: assign    dat${i}_actv_pvld = dat_actv_pvld_reg${i};
//: assign    dat${i}_actv_data = dat_actv_data_reg${i};
//: assign    dat${i}_actv_nz   = dat_actv_nz_reg${i};
//:     };
//: }
endmodule
