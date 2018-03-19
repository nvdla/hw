// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_Y_cvt_top.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_HLS_Y_cvt_top (
   cfg_cvt_bypass   //|< i
  ,cfg_cvt_offset   //|< i
  ,cfg_cvt_scale    //|< i
  ,cfg_cvt_truncate //|< i
  ,cvt_data_in      //|< i
  ,cvt_in_pvld      //|< i
  ,cvt_out_prdy     //|< i
  ,nvdla_core_clk   //|< i
  ,nvdla_core_rstn  //|< i
  ,cvt_data_out     //|> o
  ,cvt_in_prdy      //|> o
  ,cvt_out_pvld     //|> o
  );

input          cfg_cvt_bypass;
input   [31:0] cfg_cvt_offset;
input   [15:0] cfg_cvt_scale;
input    [5:0] cfg_cvt_truncate;
input  [EW_OP_DW-1:0] cvt_data_in;
input          cvt_in_pvld;
input          cvt_out_prdy;
output [EW_OC_DW-1:0] cvt_data_out;
output         cvt_in_prdy;
output         cvt_out_pvld;

input nvdla_core_clk;
input nvdla_core_rstn;

//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: wire    [15:0] cvt_data_in_${i};
//: wire    [31:0] cvt_data_out_${i};
//: wire           cvt_in_prdy_${i};
//: wire           cvt_out_pvld_${i};
//: );
//: }
//: print "\n"; 
//: foreach my $i  (0..${k}-1) {
//: print "assign  cvt_data_in_${i} = cvt_data_in[16*${i}+15:16*${i}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign  cvt_data_out[32*${i}+31:32*${i}] = cvt_data_out_${i}; \n";
//: }
//: 
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: NV_NVDLA_SDP_HLS_Y_int_cvt y_int_cvt_${i} (
//:    .cfg_cvt_bypass   (cfg_cvt_bypass)        //|< i
//:   ,.cfg_cvt_offset   (cfg_cvt_offset[31:0])  //|< i
//:   ,.cfg_cvt_scale    (cfg_cvt_scale[15:0])   //|< i
//:   ,.cfg_cvt_truncate (cfg_cvt_truncate[5:0]) //|< i
//:   ,.cvt_data_in      (cvt_data_in_${i}[15:0])   //|< w
//:   ,.cvt_in_pvld      (cvt_in_pvld)           //|< i
//:   ,.cvt_out_prdy     (cvt_out_prdy)          //|< i
//:   ,.nvdla_core_clk   (nvdla_core_clk)        //|< i
//:   ,.nvdla_core_rstn  (nvdla_core_rstn)       //|< i
//:   ,.cvt_data_out     (cvt_data_out_${i}[31:0])  //|> w
//:   ,.cvt_in_prdy      (cvt_in_prdy_${i})         //|> w
//:   ,.cvt_out_pvld     (cvt_out_pvld_${i})        //|> w
//:   );
//: );
//: }


assign  cvt_in_prdy  = cvt_in_prdy_0;
assign  cvt_out_pvld = cvt_out_pvld_0;


endmodule // NV_NVDLA_SDP_HLS_Y_cvt_top


