// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_Y_idx_top.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_HLS_Y_idx_top (
   cfg_lut_hybrid_priority //|< i
  ,cfg_lut_le_function     //|< i
  ,cfg_lut_le_index_offset //|< i
  ,cfg_lut_le_index_select //|< i
  ,cfg_lut_le_start        //|< i
  ,cfg_lut_lo_index_select //|< i
  ,cfg_lut_lo_start        //|< i
  ,cfg_lut_oflow_priority  //|< i
  ,cfg_lut_uflow_priority  //|< i
  ,chn_lut_in_pd           //|< i
  ,chn_lut_in_pvld         //|< i
  ,chn_lut_out_prdy        //|< i
  ,nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,chn_lut_in_prdy         //|> o
  ,chn_lut_out_pd          //|> o
  ,chn_lut_out_pvld        //|> o
  );

input          cfg_lut_hybrid_priority;
input          cfg_lut_le_function;
input    [7:0] cfg_lut_le_index_offset;
input    [7:0] cfg_lut_le_index_select;
input   [31:0] cfg_lut_le_start;
input    [7:0] cfg_lut_lo_index_select;
input   [31:0] cfg_lut_lo_start;
input          cfg_lut_oflow_priority;
input          cfg_lut_uflow_priority;
input  [EW_CORE_OUT_DW-1:0] chn_lut_in_pd;
input          chn_lut_in_pvld;
input          chn_lut_out_prdy;
output         chn_lut_in_prdy;
output [EW_IDX_OUT_DW-1:0] chn_lut_out_pd;
output         chn_lut_out_pvld;

input nvdla_core_clk;
input nvdla_core_rstn;

//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: my $bx =NVDLA_SDP_EW_THROUGHPUT*35;
//: my $bof=NVDLA_SDP_EW_THROUGHPUT*(35+32);
//: my $buf=NVDLA_SDP_EW_THROUGHPUT*(35+32+1);
//: my $bsl=NVDLA_SDP_EW_THROUGHPUT*(35+32+2);
//: my $ba =NVDLA_SDP_EW_THROUGHPUT*(35+32+3);
//: my $beh=NVDLA_SDP_EW_THROUGHPUT*(35+32+12);
//: my $boh=NVDLA_SDP_EW_THROUGHPUT*(35+32+13);
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: wire           chn_lut_in_prdy$i;
//: wire           chn_lut_out_pvld$i;
//: wire    [31:0] lut_data_in$i;
//: wire     [8:0] lut_out_addr$i;
//: wire    [34:0] lut_out_fraction$i;
//: wire           lut_out_le_hit$i;
//: wire           lut_out_lo_hit$i;
//: wire           lut_out_oflow$i;
//: wire           lut_out_sel$i;
//: wire           lut_out_uflow$i;
//: wire    [31:0] lut_out_x$i;
//: );
//: }
//: 
//: 
//: foreach my $i  (0..${k}-1) {
//: print "assign  lut_data_in${i} = chn_lut_in_pd[32*${i}+31:32*${i}]; \n";
//: }
//: 
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: NV_NVDLA_SDP_HLS_Y_int_idx y_int_idx_$i (
//:    .cfg_lut_hybrid_priority (cfg_lut_hybrid_priority)      //|< i
//:   ,.cfg_lut_le_function     (cfg_lut_le_function)          //|< i
//:   ,.cfg_lut_le_index_offset (cfg_lut_le_index_offset[7:0]) //|< i
//:   ,.cfg_lut_le_index_select (cfg_lut_le_index_select[7:0]) //|< i
//:   ,.cfg_lut_le_start        (cfg_lut_le_start[31:0])       //|< i
//:   ,.cfg_lut_lo_index_select (cfg_lut_lo_index_select[7:0]) //|< i
//:   ,.cfg_lut_lo_start        (cfg_lut_lo_start[31:0])       //|< i
//:   ,.cfg_lut_oflow_priority  (cfg_lut_oflow_priority)       //|< i
//:   ,.cfg_lut_uflow_priority  (cfg_lut_uflow_priority)       //|< i
//:   ,.lut_data_in             (lut_data_in${i}[31:0])           //|< w
//:   ,.lut_in_pvld             (chn_lut_in_pvld)              //|< i
//:   ,.lut_out_prdy            (chn_lut_out_prdy)             //|< i
//:   ,.nvdla_core_clk          (nvdla_core_clk)               //|< i
//:   ,.nvdla_core_rstn         (nvdla_core_rstn)              //|< i
//:   ,.lut_in_prdy             (chn_lut_in_prdy${i})             //|> w
//:   ,.lut_out_frac            (lut_out_fraction${i}[34:0])      //|> w
//:   ,.lut_out_le_hit          (lut_out_le_hit${i})              //|> w
//:   ,.lut_out_lo_hit          (lut_out_lo_hit${i})              //|> w
//:   ,.lut_out_oflow           (lut_out_oflow${i})               //|> w
//:   ,.lut_out_pvld            (chn_lut_out_pvld${i})            //|> w
//:   ,.lut_out_ram_addr        (lut_out_addr${i}[8:0])           //|> w
//:   ,.lut_out_ram_sel         (lut_out_sel${i})                 //|> w
//:   ,.lut_out_uflow           (lut_out_uflow${i})               //|> w
//:   ,.lut_out_x               (lut_out_x${i}[31:0])             //|> w
//:   );
//: );
//: }
//: 
//: 
//: foreach my $i  (0..${k}-1) {
//: print "assign   chn_lut_out_pd[35*${i}+34:35*${i}] = lut_out_fraction${i}[34:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   chn_lut_out_pd[32*${i}+31+${bx}:32*${i}+${bx}] = lut_out_x${i}[31:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   chn_lut_out_pd[${i}+${bof}] = lut_out_oflow${i} ; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   chn_lut_out_pd[${i}+${buf}] = lut_out_uflow${i} ; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   chn_lut_out_pd[${i}+${bsl}] = lut_out_sel${i} ; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   chn_lut_out_pd[9*${i}+8+${ba}:9*${i}+${ba}] = lut_out_addr${i}[8:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   chn_lut_out_pd[${i}+${beh}] = lut_out_le_hit${i} ; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   chn_lut_out_pd[${i}+${boh}] = lut_out_lo_hit${i} ; \n";
//: }
//: 


assign  chn_lut_in_prdy  = chn_lut_in_prdy0;
assign  chn_lut_out_pvld = chn_lut_out_pvld0;



endmodule // NV_NVDLA_SDP_HLS_Y_idx_top


