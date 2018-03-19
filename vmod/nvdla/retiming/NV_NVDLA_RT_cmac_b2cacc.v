// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RT_cmac_b2cacc.v

#include "../cmac/NV_NVDLA_CMAC.h"
module NV_NVDLA_RT_cmac_b2cacc (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,mac2accu_src_pvld
  ,mac2accu_src_mask
  ,mac2accu_src_mode
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: ,mac2accu_src_data${i}   )
//: }
  ,mac2accu_src_pd
  ,mac2accu_dst_pvld
  ,mac2accu_dst_mask
  ,mac2accu_dst_mode
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: ,mac2accu_dst_data${i}   )
//: }
  ,mac2accu_dst_pd
  );

input  nvdla_core_clk;
input  nvdla_core_rstn;

input         mac2accu_src_pvld;   /* data valid */
input   [CMAC_ATOMK_HALF-1:0] mac2accu_src_mask;
input         mac2accu_src_mode;
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: input [CMAC_RESULT_WIDTH-1:0] mac2accu_src_data${i};  )
//: }
input   [8:0] mac2accu_src_pd;

output         mac2accu_dst_pvld;   /* data valid */
output   [CMAC_ATOMK_HALF-1:0] mac2accu_dst_mask;
output         mac2accu_dst_mode;
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: output [CMAC_RESULT_WIDTH-1:0] mac2accu_dst_data${i};  )
//: }
output   [8:0] mac2accu_dst_pd;

wire        mac2accu_pvld_d0                = mac2accu_src_pvld;
wire [8:0]  mac2accu_pd_d0                  = mac2accu_src_pd;
wire [CMAC_ATOMK_HALF-1:0] mac2accu_mask_d0 = mac2accu_src_mask;
wire       mac2accu_mode_d0                 = mac2accu_src_mode;
//:    my $delay = RT_CMAC_B2CACC_LATENCY;
//:    my $i;
//:    my $j;
//:    my $k;
//:    my $kk=CMAC_ATOMK_HALF;
//:    my $jj=CMAC_RESULT_WIDTH;
//:    for($k = 0; $k <CMAC_ATOMK_HALF; $k ++) {
//:        print "assign mac2accu_data${k}_d0 = mac2accu_src_data${k};\n";
//:    }
//:
//:    for($i = 0; $i < $delay; $i ++) {
//:        $j = $i + 1;
//:        &eperl::flop("-q mac2accu_pvld_d${j} -d mac2accu_pvld_d${i}");
//:        &eperl::flop("-wid 9 -q mac2accu_pd_d${j} -en mac2accu_pvld_d${i} -d  mac2accu_pd_d${i}");
//:        &eperl::flop("-q mac2accu_mode_d${j} -en mac2accu_pvld_d${i} -d  mac2accu_mode_d${i}");
//:        &eperl::flop("-wid ${kk} -q mac2accu_mask_d${j} -d mac2accu_mask_d${i}");
//:        for($k = 0; $k < CMAC_ATOMK_HALF; $k ++) {
//:            &eperl::flop("-wid ${jj} -q mac2accu_data${k}_d${j} -en mac2accu_mask_d${i}[${k}] -d  mac2accu_data${k}_d${i}");
//:        }
//:    }
//:
//:    $i = $delay;
//:    print "assign mac2accu_dst_pvld = mac2accu_pvld_d${i};\n";
//:    print "assign mac2accu_dst_pd = mac2accu_pd_d${i};\n";
//:    print "assign mac2accu_dst_mask = mac2accu_mask_d${i};\n";
//:    print "assign mac2accu_dst_mode = mac2accu_mode_d${i};\n";
//:    for($k = 0; $k <CMAC_ATOMK_HALF; $k ++) {
//:        print "assign mac2accu_dst_data${k} = mac2accu_data${k}_d${i};\n";
//:    }
endmodule 

