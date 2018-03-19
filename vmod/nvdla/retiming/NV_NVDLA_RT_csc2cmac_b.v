// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RT_csc2cmac_b.v

#include "../csc/NV_NVDLA_CSC.h"
module NV_NVDLA_RT_csc2cmac_b(
   nvdla_core_clk
  ,nvdla_core_rstn
  ,sc2mac_wt_src_pvld
  ,sc2mac_wt_src_mask
//: for(my $i=0; $i<CSC_ATOMC; $i++){
//: print ",sc2mac_wt_src_data${i} \n";
//: }
  ,sc2mac_wt_src_sel
  ,sc2mac_dat_src_pvld
  ,sc2mac_dat_src_mask
//: for(my $i=0; $i<CSC_ATOMC; $i++){
//: print ",sc2mac_dat_src_data${i} \n";
//: }
  ,sc2mac_dat_src_pd
  ,sc2mac_wt_dst_pvld
  ,sc2mac_wt_dst_mask
//: for(my $i=0; $i<CSC_ATOMC; $i++){
//: print ",sc2mac_wt_dst_data${i} \n";
//: }
  ,sc2mac_wt_dst_sel
  ,sc2mac_dat_dst_pvld
  ,sc2mac_dat_dst_mask
//: for(my $i=0; $i<CSC_ATOMC; $i++){
//: print ",sc2mac_dat_dst_data${i} \n";
//: }
  ,sc2mac_dat_dst_pd
  );

//
// NV_NVDLA_RT_csc2cmac_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         sc2mac_wt_src_pvld;     /* data valid */
input [CSC_ATOMC-1:0] sc2mac_wt_src_mask;
//: my $bb=CSC_BPE;
//: for(my $i=0; $i<CSC_ATOMC; $i++){
//: print "input   [${bb}-1:0] sc2mac_wt_src_data${i};  \n";
//: }
input   [CSC_ATOMK_HF-1:0] sc2mac_wt_src_sel;

input         sc2mac_dat_src_pvld;     /* data valid */
input [CSC_ATOMC-1:0] sc2mac_dat_src_mask;
//: my $bb=CSC_BPE;
//: for(my $i=0; $i<CSC_ATOMC; $i++){
//: print "input   [${bb}-1:0] sc2mac_dat_src_data${i};  \n";
//: }
input   [8:0] sc2mac_dat_src_pd;

output         sc2mac_wt_dst_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_wt_dst_mask;
//: my $bb=CSC_BPE;
//: for(my $i=0; $i<CSC_ATOMC; $i++){
//: print "output   [${bb}-1:0] sc2mac_wt_dst_data${i};  \n";
//: }
output   [CSC_ATOMK_HF-1:0] sc2mac_wt_dst_sel;

output         sc2mac_dat_dst_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_dat_dst_mask;
//: my $bb=CSC_BPE;
//: for(my $i=0; $i<CSC_ATOMC; $i++){
//: print "output   [${bb}-1:0] sc2mac_dat_dst_data${i};  \n";
//: }
output   [8:0] sc2mac_dat_dst_pd;

//:    my $delay = RT_CSC2CMAC_B_LATENCY;
//:    my $i;
//:    my $j;
//:    my $k;
//:    my $bb=CSC_BPE;
//:    my $kk=CSC_ATOMK_HF;
//:    my $cc=CSC_ATOMC;
//:    print "wire sc2mac_wt_pvld_d0 = sc2mac_wt_src_pvld;\n";
//:    print "wire[${kk}-1:0] sc2mac_wt_sel_d0 = sc2mac_wt_src_sel;\n";
//:    print "wire[${cc}-1:0] sc2mac_wt_mask_d0 = sc2mac_wt_src_mask;\n";
//:    for($k = 0; $k <CSC_ATOMC; $k ++) {
//:    print "wire sc2mac_wt_data${k}_d0 = sc2mac_wt_src_data${k};\n";
//:    }
//:
//:    print "wire sc2mac_dat_pvld_d0 = sc2mac_dat_src_pvld;\n";
//:    print "wire[8:0] sc2mac_dat_pd_d0 = sc2mac_dat_src_pd;\n";
//:    print "wire[${cc}-1:0] sc2mac_dat_mask_d0 = sc2mac_dat_src_mask;\n";
//:    for($k = 0; $k <CSC_ATOMC; $k ++) {
//:    print "wire[${bb}-1:0] sc2mac_dat_data${k}_d0 = sc2mac_dat_src_data${k};\n";
//:    }
//:
//:    for($i = 0; $i < $delay; $i ++) {
//:        $j = $i + 1;
//:        &eperl::flop("-q sc2mac_wt_pvld_d${j} -d sc2mac_wt_pvld_d${i}");
//:        &eperl::flop("-wid ${kk} -q sc2mac_wt_sel_d${j}  -en \"(sc2mac_wt_pvld_d${i} | sc2mac_wt_pvld_d${j})\" -d sc2mac_wt_sel_d${i}");
//:        &eperl::flop("-wid ${cc} -q sc2mac_wt_mask_d${j} -en \"(sc2mac_wt_pvld_d${i} | sc2mac_wt_pvld_d${j})\" -d sc2mac_wt_mask_d${i}");
//:        for($k = 0; $k <CSC_ATOMC; $k ++) {
//:        &eperl::flop("-wid ${bb} -q sc2mac_wt_data${k}_d${j} -en sc2mac_wt_mask_d${i}[${k}] -d sc2mac_wt_data${k}_d${i}");
//:        }
//:
//:        &eperl::flop("-q sc2mac_dat_pvld_d${j} -d sc2mac_dat_pvld_d${i}");
//:        &eperl::flop("-wid 9 -q sc2mac_dat_pd_d${j} -en \"(sc2mac_dat_pvld_d${i} | sc2mac_dat_pvld_d${j})\" -d sc2mac_dat_pd_d${i}");
//:        &eperl::flop("-wid ${cc} -q sc2mac_dat_mask_d${j} -en \"(sc2mac_dat_pvld_d${i} | sc2mac_dat_pvld_d${j})\" -d sc2mac_dat_mask_d${i}");
//:        for($k = 0; $k <CSC_ATOMC; $k ++) {
//:        &eperl::flop("-wid ${bb} -q sc2mac_dat_data${k}_d${j} -en \"(sc2mac_dat_mask_d${i}[${k}])\" -d sc2mac_dat_data${k}_d${i}");
//:        }
//:    }
//:
//:    $i = $delay;
//:    print "wire sc2mac_wt_dst_pvld = sc2mac_wt_pvld_d${i};\n";
//:    print "wire[${kk}-1:0] sc2mac_wt_dst_sel = sc2mac_wt_sel_d${i};\n";
//:    print "wire[${cc}-1:0] sc2mac_wt_dst_mask = sc2mac_wt_mask_d${i};\n";
//:    for($k = 0; $k <CSC_ATOMC; $k ++) {
//:    print "wire[${bb}-1:0] sc2mac_wt_dst_data${k} = sc2mac_wt_data${k}_d${i};\n";
//:    }
//:
//:    print "wire sc2mac_dat_dst_pvld = sc2mac_dat_pvld_d${i};\n";
//:    print "wire[8:0] sc2mac_dat_dst_pd = sc2mac_dat_pd_d${i};\n";
//:    print "wire[${cc}-1:0] sc2mac_dat_dst_mask = sc2mac_dat_mask_d${i};\n";
//:    for($k = 0; $k <CSC_ATOMC; $k ++) {
//:    print "wire[${bb}-1:0] sc2mac_dat_dst_data${k} = sc2mac_dat_data${k}_d${i};\n";
//:    }

endmodule // NV_NVDLA_RT_csc2cmac_b

