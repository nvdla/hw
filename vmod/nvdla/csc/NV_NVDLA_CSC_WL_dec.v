// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CSC_WL_dec.v

#include "NV_NVDLA_CSC.h"

module NV_NVDLA_CSC_WL_dec (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,input_data
  ,input_mask
  ,input_mask_en
  ,input_pipe_valid
  ,input_sel
  ,is_fp16
  ,is_int8
//: for(my $i = 0; $i < CSC_ATOMC; $i ++) {
//:     print qq(  ,output_data${i}\n);
//: }
  ,output_mask
  ,output_pvld
  ,output_sel
  );

input           nvdla_core_clk;
input           nvdla_core_rstn;
input  [CSC_ATOMC*CSC_BPE-1:0] input_data;
input  [CSC_ATOMC-1:0]         input_mask;
input     [9:0] input_mask_en;
input           input_pipe_valid;
input    [CSC_ATOMK-1:0] input_sel;
input           is_fp16;
input           is_int8;
//: for(my $i = 0; $i < CSC_ATOMC; $i ++) {
//:     print qq(output    [CSC_BPE-1:0] output_data${i};\n);
//: }
output  [CSC_ATOMC-1:0] output_mask;
output          output_pvld;
output   [CSC_ATOMK-1:0] output_sel;

wire    [CSC_ATOMC-1:0] input_mask_gated;
reg     [CSC_ATOMC*CSC_BPE-1:0] data_d1;
reg     [CSC_ATOMC-1:0] mask_d1;
//reg     [CSC_ATOMC-1:0] mask_d2_fp16_w;
//reg     [CSC_ATOMC-1:0] mask_d2_int16_w;
wire     [CSC_ATOMC-1:0] mask_d2_int8_w;
wire     [CSC_ATOMC-1:0] mask_d2_w;
reg     [CSC_ATOMC-1:0] mask_d3;
reg      [CSC_ATOMK-1:0] sel_d1;
reg      [CSC_ATOMK-1:0] sel_d2;
reg      [CSC_ATOMK-1:0] sel_d3;
reg             valid_d1;
reg             valid_d2;
reg             valid_d3;
//: my $kk=CSC_BPE;
//: for(my $i = 0; $i < CSC_ATOMC; $i ++) {
//:     my $series_no = sprintf("%02d", $i);
//:     print qq(reg       [CSC_BPE-1:0] vec_data_${series_no};\n);
//:     print qq(reg       [CSC_BPE-1:0] vec_data_${series_no}_d2;\n);
//:     print qq(reg       [CSC_BPE-1:0] vec_data_${series_no}_d3;\n);
//: }

//: for(my $i = 0; $i < CSC_ATOMC; $i ++) {
//:     my $j = 1;
//:     while(2**$j <= ($i + 1)) {   
//:         $j ++;
//:     }
//:     my $k = $j - 1;
//:     my $series_no = sprintf("%02d", $i);
//:     print qq(wire       [${k}:0] vec_sum_${series_no};\n);
//:     print qq(reg       [${k}:0] vec_sum_${series_no}_d1;\n);
//: }

/////////////////////////////////////////////////////////////////////////////////////////////
// Decoder of compressed weight                                                  
//
//            data_mask             input_data     mac_sel
//                |                     |            |
//            sums_for_sel           register     register
//                |                     |            |
//                ------------------>  mux        register
//                                      |            |
//                                   output_data  output_sel
//
/////////////////////////////////////////////////////////////////////////////////////////////


//: my $i;
//: my $j;
//: my $k;
//: my $series_no;
//: my $series_no_1;
//: my $name;
//: my $name_1;
//: my $width;
//: my $st;
//: my $end;
//: my @bit_width_list;
//: $width = CSC_BPE;
//: for($i = 0; $i < CSC_ATOMC; $i ++) {
//:     $j = 0;
//:     while(2**$j <= ($i + 1)) {   
//:         $j ++;
//:     }
//:     $bit_width_list[$i] = $j;
//: }
//: print "////////////////////////////////// phase I: calculate sums for mux //////////////////////////////////\n";
//: print "assign input_mask_gated = ~input_mask_en[8] ? {${width}{1'b0}} : input_mask;\n\n";
//: 
//: for($i = 0; $i < CSC_ATOMC; $i ++) {
//:     $series_no = sprintf("%02d", $i);
//:     print "assign vec_sum_${series_no} = ";
//:     for($j = 0; $j < $i + 1; $j ++) {
//:         print "input_mask_gated[${j}]";
//:         if($j == $i) {
//:             print ";\n";
//:         } elsif ($j % 8 == 7) {
//:             print "\n                   + ";
//:         } else {
//:             print " + ";
//:         }
//:     } 
//:     print "\n\n";
//: }
//: print "\n\n";
//: 
//: print "////////////////////////////////// phase I: registers //////////////////////////////////\n";
//: &eperl::flop("-nodeclare -rval \"1'b0\" -q valid_d1 -d input_pipe_valid ");
//: &eperl::flop("-nodeclare -norst -q data_d1 -en input_pipe_valid -d input_data ");
//: &eperl::flop("-nodeclare -norst -q mask_d1 -en input_pipe_valid -d input_mask ");
//: &eperl::flop("-nodeclare -q sel_d1 -en input_pipe_valid -d input_sel ");
//: 
//: for($i = 0; $i < CSC_ATOMC; $i ++) {
//:     $series_no = sprintf("%02d", $i);
//:     my $j = int($i / 8);
//:     my $wid = $bit_width_list[$i];
//:     &eperl::flop("-nodeclare -rval \"{${wid}{1'b0}}\" -q vec_sum_${series_no}_d1 -en \"(input_pipe_valid & input_mask_en[${j}])\" -d vec_sum_${series_no} ");
//: }
//: print "\n\n";
//: 
//: print "////////////////////////////////// phase II: mux //////////////////////////////////\n";
//: for($i = 0; $i < CSC_ATOMC; $i ++) {
//:     $series_no = sprintf("%02d", $i);
//:     $name = "vec_data_${series_no}";
//:     $k = $bit_width_list[$i];
//: 
//:     print "always @ (*) begin\n";
//:     print "    case(vec_sum_${series_no}_d1)\n";
//: 
//:     for($j = 1; $j <= $i + 1; $j ++) {
//:         $st = $j * $width - 1;
//:         $end = ($j - 1) * $width;
//:         print "        ${k}'d${j}: $name = data_d1[${st}:${end}];\n";
//:     }
//:     print "    default: $name= ${width}'b0;\n";
//:     print "    endcase\n";
//:     print "end\n\n";
//: }
//: print "\n\n";
//: 
//: print "////////////////////////////////// phase II: registers //////////////////////////////////\n";
//: &eperl::flop("-nodeclare -rval \"1'b0\" -q valid_d2 -d valid_d1 ");
//: &eperl::flop("-nodeclare -q sel_d2 -en valid_d1 -d sel_d1 ");
//: for($i = 0; $i < CSC_ATOMC; $i ++) {
//:     $series_no = sprintf("%02d", $i);
//:     $name = "vec_data_${series_no}";
//:     &eperl::flop("-nodeclare -norst -q ${name}_d2 -en \"valid_d1\" -d \"(${name} & {${width}{mask_d1[${i}]}})\" ");
//: }
//: print "\n\n";
//: 
//: print "////////////////////////////////// phase III: registers //////////////////////////////////\n";
//: for($i = 0; $i < CSC_ATOMC; $i ++) {
//:     $series_no = sprintf("%02d", $i);
//:     $name = "vec_data_${series_no}_d2";
//:     print "assign mask_d2_int8_w[${i}] = (|${name});\n";
//: }
//: print "\n\n\n";
//: 
//: #for($i = 0; $i < CSC_ATOMC; $i += 2) {
//: #    $j = $i + 1;
//: #    $series_no = sprintf("%02d", $i);
//: #    $series_no_1 = sprintf("%02d", $j);
//: #    $name = "vec_data_${series_no}_d2";
//: #    $name_1 = "vec_data_${series_no_1}_d2";
//: #    print "assign mask_d2_int16_w[${j}:${i}] = {2{(|{${name_1}, ${name}})}};\n";
//: #}
//: #print "\n\n\n";
//: 
//: #for($i = 0; $i < CSC_ATOMC; $i += 2) {
//: #    $j = $i + 1;
//: #    $series_no = sprintf("%02d", $i);
//: #    $series_no_1 = sprintf("%02d", $j);
//: #    $name = "vec_data_${series_no}_d2";
//: #    $name_1 = "vec_data_${series_no_1}_d2";
//: #    print "assign mask_d2_fp16_w[${j}:${i}] = {2{(|{${name_1}[6:0], ${name}})}};\n";
//: #}
//: #print "\n\n\n";
//: 
//: #print "assign mask_d2_w = is_int8 ? mask_d2_int8_w :\n";
//: #print "                   is_fp16 ? mask_d2_fp16_w :\n";
//: #print "                   mask_d2_int16_w;\n";
//: #print "\n\n\n";
//: print "assign mask_d2_w = mask_d2_int8_w ;\n";   #only for int8
//: 
//: &eperl::flop("-nodeclare -rval \"1'b0\" -q valid_d3 -d valid_d2 ");
//: &eperl::flop("-nodeclare -norst -q mask_d3 -en valid_d2 -d mask_d2_w ");
//: &eperl::flop("-nodeclare -q sel_d3 -en valid_d2 -d sel_d2 ");
//: for($i = 0; $i < CSC_ATOMC; $i ++) {
//:     $series_no = sprintf("%02d", $i);
//:     $name = "vec_data_${series_no}";
//:     &eperl::flop("-nodeclare -q ${name}_d3 -en valid_d2 -d ${name}_d2 ");
//: }
//: print "\n\n";
//: 
//: print "////////////////////////////////// output: rename //////////////////////////////////\n";
//: print "assign output_pvld = valid_d3;\n";
//: print "assign output_mask = mask_d3;\n";
//: print "assign output_sel = sel_d3;\n";
//: for($i = 0; $i < CSC_ATOMC; $i ++) {
//:     $series_no = sprintf("%02d", $i);
//:     $name = "vec_data_${series_no}";
//:     print "assign output_data${i} = ${name}_d3;\n";
//: }
//: print "\n\n";

endmodule // NV_NVDLA_CSC_WL_dec
