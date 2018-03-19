// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_LUT_ctrl.v

#include "NV_NVDLA_CDP_define.h"

module NV_NVDLA_CDP_DP_LUT_ctrl (
   nvdla_core_clk             //|< i
  ,nvdla_core_rstn            //|< i
  ,dp2lut_prdy                //|< i
  ,reg2dp_lut_le_function     //|< i
  ,reg2dp_lut_le_index_offset //|< i
  ,reg2dp_lut_le_index_select //|< i
  ,reg2dp_lut_le_start_high   //|< i
  ,reg2dp_lut_le_start_low    //|< i
  ,reg2dp_lut_lo_index_select //|< i
  ,reg2dp_lut_lo_start_high   //|< i
  ,reg2dp_lut_lo_start_low    //|< i
  ,reg2dp_sqsum_bypass        //|< i
  ,sum2itp_pd                 //|< i
  ,sum2itp_pvld               //|< i
  ,sum2sync_prdy              //|< i
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         ,dp2lut_X_entry_${m}
//:         ,dp2lut_Xinfo_${m}
//:         ,dp2lut_Y_entry_${m}
//:         ,dp2lut_Yinfo_${m}
//:     );
//: }
  ,dp2lut_pvld                //|> o
  ,sum2itp_prdy               //|> o
  ,sum2sync_pd                //|> o
  ,sum2sync_pvld              //|> o
  );
////////////////////////////////////////////////////////////////////////////////////////
//parameter pINT8_BW = 9;//int8 bitwidth after icvt
//parameter pPP_BW = (pINT8_BW + pINT8_BW) -1 + 4;
////////////////////////////////////////////////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          reg2dp_lut_le_function;
input    [7:0] reg2dp_lut_le_index_offset;
input    [7:0] reg2dp_lut_le_index_select;
input    [5:0] reg2dp_lut_le_start_high;
input   [31:0] reg2dp_lut_le_start_low;
input    [7:0] reg2dp_lut_lo_index_select;
input    [5:0] reg2dp_lut_lo_start_high;
input   [31:0] reg2dp_lut_lo_start_low;
input          reg2dp_sqsum_bypass;
//: my $tp=NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: my $sqsumo = $icvto *2 -1+4; ##(${tp}*2) -1 is for x^2, +4 is after 9 lrn
//: print "input  [${tp}*${sqsumo}-1:0] sum2itp_pd;  \n";
//: print "output [${tp}*${sqsumo}-1:0] sum2sync_pd; \n";
input          sum2itp_pvld;
output         sum2itp_prdy;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         output   [9:0] dp2lut_X_entry_${m};
//:         output  [17:0] dp2lut_Xinfo_${m};
//:         output   [9:0] dp2lut_Y_entry_${m};
//:         output  [17:0] dp2lut_Yinfo_${m};
//:     );
//: }
output         dp2lut_pvld;
input          dp2lut_prdy;
output         sum2sync_pvld;
input          sum2sync_prdy;
////////////////////////////////////////////////////////////////////////////////////////
//: my $tp=NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: my $sqsumo = $icvto *2 -1+4; 
//: foreach my $m  (0..${tp}-1) {
//:     print qq(
//:         wire    [17:0] dp2lut_X_info_$m;
//:         wire    [9:0]  dp2lut_X_pd_$m;
//:         wire    [17:0] dp2lut_Y_info_$m;
//:         wire    [9:0]  dp2lut_Y_pd_$m;
//:         wire    [${sqsumo}-1:0] sum2itp_pd_$m;
//:     );
//: }
wire   [NVDLA_CDP_THROUGHPUT-1:0]        dp2lut_rdy;
wire   [NVDLA_CDP_THROUGHPUT-1:0]        dp2lut_vld;
wire   [NVDLA_CDP_THROUGHPUT-1:0]        sum2itp_rdy;
wire   [NVDLA_CDP_THROUGHPUT-1:0]        sum2itp_vld;
////////////////////////////////////////////////////////////////////////////////////////
assign sum2itp_prdy = (&sum2itp_rdy) & sum2sync_prdy;

//////////////////////////////////////////////////////////////////////
//from intp_ctrl input port to sync fifo for interpolation
assign sum2sync_pvld = sum2itp_pvld & (&sum2itp_rdy);
assign sum2sync_pd   = sum2itp_pd;
///////////////////////////////////////////
//: my $tp=NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: my $sqsumo = $icvto *2 -1+4; 
//:     foreach my $m (0..${tp} -1) {
//:       print qq(
//:         assign sum2itp_vld[$m] = sum2itp_pvld & sum2sync_prdy 
//:       );
//:             foreach my $j (0..${tp} -1) {
//:                 if(${j} != ${m}) {
//:                     print qq(
//:                                & sum2itp_rdy[$j]
//:                     );
//:                 }
//:             }
//:       print qq(
//:         ; 
//:       );
//:       print qq(
//:         assign sum2itp_pd_${m} = sum2itp_pd[${sqsumo}*${m}+${sqsumo}-1:${sqsumo}*${m}];
//:         NV_NVDLA_CDP_DP_LUT_CTRL_unit u_LUT_CTRL_unit$m (
//:            .nvdla_core_clk             (nvdla_core_clk)                  
//:           ,.nvdla_core_rstn            (nvdla_core_rstn)                 
//:           ,.sum2itp_pd                 (sum2itp_pd_${m})              
//:           ,.sum2itp_pvld               (sum2itp_vld[${m}])                  
//:           ,.sum2itp_prdy               (sum2itp_rdy[${m}])                  
//:           ,.reg2dp_lut_le_function     (reg2dp_lut_le_function)          
//:           ,.reg2dp_lut_le_index_offset (reg2dp_lut_le_index_offset[7:0]) 
//:           ,.reg2dp_lut_le_index_select (reg2dp_lut_le_index_select[7:0]) 
//:           ,.reg2dp_lut_le_start_high   (reg2dp_lut_le_start_high[5:0])   
//:           ,.reg2dp_lut_le_start_low    (reg2dp_lut_le_start_low[31:0])   
//:           ,.reg2dp_lut_lo_index_select (reg2dp_lut_lo_index_select[7:0]) 
//:           ,.reg2dp_lut_lo_start_high   (reg2dp_lut_lo_start_high[5:0])   
//:           ,.reg2dp_lut_lo_start_low    (reg2dp_lut_lo_start_low[31:0])   
//:           ,.reg2dp_sqsum_bypass        (reg2dp_sqsum_bypass)             
//:           ,.dp2lut_X_info              (dp2lut_X_info_${m})           
//:           ,.dp2lut_X_pd                (dp2lut_X_pd_${m})             
//:           ,.dp2lut_Y_info              (dp2lut_Y_info_${m})           
//:           ,.dp2lut_Y_pd                (dp2lut_Y_pd_${m})             
//:           ,.dp2lut_pvld                (dp2lut_vld[${m}])                   
//:           ,.dp2lut_prdy                (dp2lut_rdy[${m}])                   
//:           );
//:       );
//:     }

//:   my $k = NVDLA_CDP_THROUGHPUT;
//:   foreach my $m (0..$k -1) {
//:      print qq(
//:         assign dp2lut_X_entry_$m = dp2lut_X_pd_$m;
//:         assign dp2lut_Y_entry_$m = dp2lut_Y_pd_$m;
//:         assign dp2lut_Xinfo_$m = dp2lut_X_info_$m;
//:         assign dp2lut_Yinfo_$m = dp2lut_Y_info_$m;
//:      );
//:   }

assign dp2lut_pvld = &dp2lut_vld;
//:   my $k = NVDLA_CDP_THROUGHPUT;
//:     foreach my $m (0..$k -1) {
//:       print qq(
//:         assign dp2lut_rdy[${m}] = dp2lut_prdy 
//:       );
//:             foreach my $j (0..$k -1) {
//:                 if(${j} != ${m}) {
//:                     print qq(
//:                                & dp2lut_vld[$j]
//:                     );
//:                 }
//:             }
//:       print qq(
//:         ; 
//:       );
//:   }

///////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_LUT_ctrl


