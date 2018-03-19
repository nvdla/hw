// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_c.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_HLS_c (
   cfg_mode_eql      
  ,cfg_offset        
  ,cfg_out_precision 
  ,cfg_scale         
  ,cfg_truncate      
  ,cvt_in_pvld       
  ,cvt_out_prdy      
  ,cvt_pd_in         
  ,nvdla_core_clk    
  ,nvdla_core_rstn   
  ,cvt_in_prdy       
  ,cvt_out_pvld      
  ,cvt_pd_out        
  );

input          cfg_mode_eql;
input   [31:0] cfg_offset;
input    [1:0] cfg_out_precision;
input   [15:0] cfg_scale;
input    [5:0] cfg_truncate;
input          cvt_in_pvld;
input          cvt_out_prdy;
input  [CV_IN_DW-1:0] cvt_pd_in;
output         cvt_in_prdy;
output         cvt_out_pvld;
output [CV_OUT_DW+NVDLA_SDP_MAX_THROUGHPUT-1:0] cvt_pd_out;

input nvdla_core_clk;
input nvdla_core_rstn;

wire [8*NVDLA_SDP_MAX_THROUGHPUT-1:0] cvt_pd_out8;
wire [CV_OUT_DW-1:0] cvt_pd_out16;

//: my $b  = NVDLA_BPE;
//: my $dw = CV_OUT_DW;
//: my $k=NVDLA_SDP_MAX_THROUGHPUT;
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: wire    [31:0] cvt_data_in_$i;
//: wire    [15:0] cvt_data_out_$i;
//: wire           cvt_in_prdy_$i;
//: wire           cvt_out_pvld_$i;
//: wire           cvt_sat_out_$i;
//: );
//: }
//: print "\n"; 
//: foreach my $i  (0..${k}-1) {
//: print "assign  cvt_data_in_${i} = cvt_pd_in[32*${i}+31:32*${i}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign  cvt_pd_out8[8*${i}+7:8*${i}] = cvt_data_out_${i}[7:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign  cvt_pd_out16[16*${i}+15:16*${i}] = cvt_data_out_${i}; \n";
//: }
//: print "\n"; 
//: print "assign  cvt_pd_out[${dw}-1:0] = cfg_out_precision[1:0]==2'b0 ? {{(8*$k){1'b0}},cvt_pd_out8[8*${k}-1:0]} : cvt_pd_out16[16*${k}-1:0]; \n";
//: foreach my $i  (0..${k}-1) {
//: print "assign  cvt_pd_out[${dw}+${i}] = cvt_sat_out_${i}; \n";
//: }
//: print "\n"; 
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: NV_NVDLA_SDP_HLS_C_int c_int_${i} (
//:    .cfg_mode_eql      (cfg_mode_eql)           
//:   ,.cfg_offset        (cfg_offset[31:0])       
//:   ,.cfg_out_precision (cfg_out_precision[1:0]) 
//:   ,.cfg_scale         (cfg_scale[15:0])        
//:   ,.cfg_truncate      (cfg_truncate[5:0])      
//:   ,.cvt_data_in       (cvt_data_in_${i}[31:0])    
//:   ,.cvt_in_pvld       (cvt_in_pvld)            
//:   ,.cvt_out_prdy      (cvt_out_prdy)           
//:   ,.nvdla_core_clk    (nvdla_core_clk)         
//:   ,.nvdla_core_rstn   (nvdla_core_rstn)        
//:   ,.cvt_data_out      (cvt_data_out_${i}[15:0])   
//:   ,.cvt_in_prdy       (cvt_in_prdy_${i})          
//:   ,.cvt_out_pvld      (cvt_out_pvld_${i})         
//:   ,.cvt_sat_out       (cvt_sat_out_${i})          
//:   );
//: 
//: );
//: }


assign  cvt_in_prdy  = cvt_in_prdy_0;
assign  cvt_out_pvld = cvt_out_pvld_0;


endmodule // NV_NVDLA_SDP_HLS_c


