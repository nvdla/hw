// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_mul.v

#include "NV_NVDLA_CDP_define.h"

module NV_NVDLA_CDP_DP_mul (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:       ,intp2mul_pd_$m 
//:     );
//: }
  ,intp2mul_pvld           //|< i
  ,mul2ocvt_prdy           //|< i
  ,reg2dp_mul_bypass       //|< i
  ,sync2mul_pd             //|< i
  ,sync2mul_pvld           //|< i
  ,intp2mul_prdy           //|> o
  ,mul2ocvt_pd             //|> o
  ,mul2ocvt_pvld           //|> o
  ,sync2mul_prdy           //|> o
  );
//////////////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         input   [16:0] intp2mul_pd_$m;
//:     );
//: }
//:     print qq(
//:         input   [${k}*${icvto}-1:0] sync2mul_pd;
//:         output [${k}*(${icvto}+16)-1:0] mul2ocvt_pd;
//:     );
input          intp2mul_pvld;
input          mul2ocvt_prdy;
input          reg2dp_mul_bypass;
input          sync2mul_pvld;
output         intp2mul_prdy;
output         mul2ocvt_pvld;
output         sync2mul_prdy;
//////////////////////////////////////////////////////
reg            mul_bypass_en;
wire   [NVDLA_CDP_THROUGHPUT*(NVDLA_CDP_ICVTO_BWPE+16)-1:0] intp_out_ext;
wire   [NVDLA_CDP_THROUGHPUT*(NVDLA_CDP_ICVTO_BWPE+16)-1:0] mul2ocvt_pd_f;
wire           mul2ocvt_pvld_f;
wire           mul_in_rdy;
wire           mul_in_vld;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         wire    [(${icvto}+16)-1:0] mul_unit_pd_$m;
//:         wire    [${icvto}-1:0] mul_ina_pd_$m;
//:         wire    [15:0] mul_inb_pd_$m;
//:     );
//: }
wire     [NVDLA_CDP_THROUGHPUT-1:0] mul_unit_rdy;
wire     [NVDLA_CDP_THROUGHPUT-1:0] mul_unit_vld;
wire     [NVDLA_CDP_THROUGHPUT-1:0] mul_vld;
wire     [NVDLA_CDP_THROUGHPUT-1:0] mul_rdy;
///////////////////////////////////////////
//: my $k = NVDLA_CDP_THROUGHPUT*(NVDLA_CDP_ICVTO_BWPE+16);
//: &eperl::pipe(" -wid $k -is -do mul2ocvt_pd -vo mul2ocvt_pvld -ri mul2ocvt_prdy -di mul2ocvt_pd_f -vi mul2ocvt_pvld_f -ro mul2ocvt_prdy_f ");

///////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mul_bypass_en <= 1'b0;
  end else begin
  mul_bypass_en <= reg2dp_mul_bypass   == 1'h1;
  end
end

//interlock two path data 
assign intp2mul_prdy = (mul_bypass_en ? mul2ocvt_prdy_f : mul_in_rdy) & sync2mul_pvld;
assign sync2mul_prdy = (mul_bypass_en ? mul2ocvt_prdy_f : mul_in_rdy) & intp2mul_pvld;

assign mul_in_vld = mul_bypass_en ? 1'b0 : (sync2mul_pvld & intp2mul_pvld);
assign mul_in_rdy = &mul_rdy;

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         assign mul_vld[$m] = mul_in_vld
//:     );
//:     foreach my $i  (0..$k-1) {
//:         print qq(
//:             & mul_rdy[$i]
//:         );
//:     }
//:     print qq(
//:         ;
//:     );
//: }

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m (0..$k-1) {
//:     print qq(
//:         assign mul_inb_pd_$m = intp2mul_pd_${m}[15:0];
//:     );
//: }

//: my $k = NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         assign mul_ina_pd_$m = sync2mul_pd[$m*${icvto}+${icvto}-1:$m*${icvto}];
//:         NV_NVDLA_CDP_DP_MUL_unit u_mul_unit$m (
//:            .nvdla_core_clk          (nvdla_core_clk)     
//:           ,.nvdla_core_rstn         (nvdla_core_rstn)    
//:           ,.mul_vld                 (mul_vld[$m])         
//:           ,.mul_rdy                 (mul_rdy[$m])         
//:           ,.mul_ina_pd              (mul_ina_pd_$m)   
//:           ,.mul_inb_pd              (mul_inb_pd_$m)
//:           ,.mul_unit_vld            (mul_unit_vld[$m])    
//:           ,.mul_unit_rdy            (mul_unit_rdy[$m])    
//:           ,.mul_unit_pd             (mul_unit_pd_$m)      
//:           );
//:     );
//: }


//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         assign mul_unit_rdy[$m] = mul2ocvt_prdy_f
//:     );
//:     foreach my $i  (0..$k-1) {
//:         print qq(
//:             & mul_unit_vld[$i]
//:         );
//:     }
//:     print qq(
//:         ;
//:     );
//: }

///////////////////
//NaN propagation for mul_bypass condition
///////////////////
assign intp_out_ext = {
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: if($k > 1) {
//:     foreach my $m (0..$k-2) {
//:     my $i = $k -$m -1;
//:         print "{{(${icvto}+16-17){intp2mul_pd_${i}[16]}}, intp2mul_pd_${i}[16:0]},";
//:     }
//: }
//: print "{{(${icvto}+16-17){intp2mul_pd_0[16]}}, intp2mul_pd_0[16:0]}};  \n";
//: 
//: print "assign mul2ocvt_pd_f = mul_bypass_en ? intp_out_ext : { ";
//: if($k > 1) {
//:     foreach my $m (0..$k-2) {
//:     my $i = $k -$m -1;
//:         print "mul_unit_pd_$i,";
//:     }
//: }
//: print " mul_unit_pd_0};  \n";

//output select
assign mul2ocvt_pvld_f = mul_bypass_en ? (sync2mul_pvld & intp2mul_pvld) : (&mul_unit_vld);

//  ///////////////////////////////////////////
//  
//  //: my $k = NVDLA_CDP_THROUGHPUT*(NVDLA_CDP_ICVTO_BWPE+16);
//  //: &eperl::pipe(" -wid $k -is -do mul2ocvt_pd -vo mul2ocvt_pvld -ri mul2ocvt_prdy -di mul2ocvt_pd_f -vi mul2ocvt_pvld_f -ro mul2ocvt_prdy_f ");
//  
///////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_mul


