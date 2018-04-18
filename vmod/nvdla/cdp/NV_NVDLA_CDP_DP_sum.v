// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_sum.v

#include "NV_NVDLA_CDP_define.h"

module NV_NVDLA_CDP_DP_sum (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,normalz_buf_data        //|< i
  ,normalz_buf_data_pvld   //|< i
  ,reg2dp_normalz_len      //|< i
  ,sum2itp_prdy            //|< i
  ,normalz_buf_data_prdy   //|> o
  ,sum2itp_pd              //|> o
  ,sum2itp_pvld            //|> o
  );
/////////////////////////////////////////////////////
// parameter pINT8_BW = 9;

/////////////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
//: my $tp=NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: my $k = ${icvto}*(${tp}+8)+17;
//:     print qq( 
//:         input  [${k}-1:0] normalz_buf_data;
//:         output [${tp}*(${icvto}*2+3)-1:0] sum2itp_pd;
//:     );
input          normalz_buf_data_pvld;
input    [1:0] reg2dp_normalz_len;
input          sum2itp_prdy;
output         normalz_buf_data_prdy;
output         sum2itp_pvld;
/////////////////////////////////////////////////////
reg            buf2sum_2d_vld;
reg            buf2sum_3d_vld;
reg            buf2sum_d_vld;
wire           buf2sum_2d_rdy;
wire           buf2sum_3d_rdy;
wire           buf2sum_d_rdy;
wire           buf2sum_din_prdy;
wire           buf2sum_rdy_f;
wire           cdp_buf2sum_ready;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: my $tp=NVDLA_CDP_THROUGHPUT+8;
//:   foreach my $i  (0..${tp}-1) {
//:     print qq( 
//:     wire [${icvto}-1:0] buf2sum_int8_$i;
//:     wire [${icvto}-1:0] inv_${i};
//:     wire [${icvto}-1:0] int8_abs_${i};
//:     reg  [${icvto}*2-2:0] int8_sq_${i};
//:     reg                   mon_int8_sq_${i};
//:     );
//:   }

wire     [7:0] int8_inv_2;
wire     [7:0] int8_inv_3;
wire     [7:0] int8_inv_4;
wire     [7:0] int8_inv_5;
wire     [7:0] int8_inv_6;
wire     [7:0] int8_inv_7;
wire     [7:0] int8_inv_8;
wire     [7:0] int8_inv_9;
//: my $tp=NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: my $k = ${tp}*(${icvto}*2+3);
//:   print qq(
//:     wire   [${k}-1:0] sum_out_pd;
//:     wire   [${k}-1:0] sum2itp_data;
//:   );
//: foreach my $i (0..$tp-1){
//:   print qq(
//:     wire   [${icvto}*2-1+4-1:0] int8_sum_$i;
//:   );
//: }
wire    [41:0] int8_sum_1st;
wire    [41:0] int8_sum_2nd;
wire    [41:0] int8_sum_3rd;
wire    [41:0] int8_sum_4th;
wire    [15:0] int_ivt_2;
wire    [15:0] int_ivt_3;
wire    [15:0] int_ivt_4;
wire    [15:0] int_ivt_5;
wire    [15:0] int_ivt_6;
wire    [15:0] int_ivt_7;
wire    [15:0] int_ivt_8;
wire    [15:0] int_ivt_9;
wire    [16:0] int_sq_datin_2;
wire    [16:0] int_sq_datin_3;
wire    [16:0] int_sq_datin_4;
wire    [16:0] int_sq_datin_5;
wire    [16:0] int_sq_datin_6;
wire    [16:0] int_sq_datin_7;
wire    [16:0] int_sq_datin_8;
wire    [16:0] int_sq_datin_9;
wire    [16:0] int_sq_datin_abs_2;
wire    [16:0] int_sq_datin_abs_3;
wire    [16:0] int_sq_datin_abs_4;
wire    [16:0] int_sq_datin_abs_5;
wire    [16:0] int_sq_datin_abs_6;
wire    [16:0] int_sq_datin_abs_7;
wire    [16:0] int_sq_datin_abs_8;
wire    [16:0] int_sq_datin_abs_9;
wire           len3;
wire           len5;
wire           len7;
wire           len9;
wire           load_din;
wire           load_din_2d;
wire           load_din_d;
wire           sum2itp_valid;
wire           sum_out_prdy;
wire           sum_out_pvld;
///////////////////////////////////////////
//==========================================
//----------------------------------------

//: my $tp=NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: my $k = ${icvto}*(${tp}+8)+17;
//: &eperl::pipe(" -wid $k -do cdp_buf2sum_pd -vo cdp_buf2sum_valid -ri cdp_buf2sum_ready -di normalz_buf_data -vi normalz_buf_data_pvld -ro normalz_buf_data_prdy ");


/////////////////////////////////////////////
assign load_din = (cdp_buf2sum_valid & buf2sum_rdy_f);

assign cdp_buf2sum_ready = buf2sum_rdy_f;
assign buf2sum_rdy_f = buf2sum_din_prdy;
//==========================================

//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: my $tp=NVDLA_CDP_THROUGHPUT+8;
//:   foreach my $i  (0..${tp}-1) {
//:     print qq( 
//:         assign buf2sum_int8_$i = cdp_buf2sum_pd[${icvto}*${i}+${icvto}-1:${icvto}*${i}]; 
//:     );
//:   }

//========================================================
//int mode
//--------------------------------------------------------
//: my $tp=NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//:     foreach my $i  (0..${tp}+8-1) {
//:       print qq(
//:             assign inv_${i} = buf2sum_int8_${i}[${icvto}-1] ? (~buf2sum_int8_${i}[${icvto}-2:0]) : {(${icvto}-1){1'b0}}; 
//:             assign int8_abs_${i} = buf2sum_int8_${i}[${icvto}-1] ? (inv_${i}[${icvto}-2:0] + {{(${icvto}-2){1'b0}},1'b1}) : buf2sum_int8_${i};
//:       );
//:     }
//:
//:     print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:           if (!nvdla_core_rstn) begin
//:     );
//:             foreach my $i  (0..${tp}+8-1) {
//:               print qq(
//:                   {mon_int8_sq_${i},int8_sq_${i}} <= {(${icvto}*2-1){1'b0}};
//:               );
//:             }
//:     print qq(
//:           end else if(load_din) begin
//:              {mon_int8_sq_0,int8_sq_0} <=            len9 ? (int8_abs_0 * int8_abs_0) : {(${icvto}*2){1'b0}};
//:              {mon_int8_sq_1,int8_sq_1} <= (     len7|len9)? (int8_abs_1 * int8_abs_1) : {(${icvto}*2){1'b0}};
//:              {mon_int8_sq_2,int8_sq_2} <= (len5|len7|len9)? (int8_abs_2 * int8_abs_2) : {(${icvto}*2){1'b0}};
//:              {mon_int8_sq_3,int8_sq_3} <=                   (int8_abs_3 * int8_abs_3);
//:     );
//:              foreach my $i  (0..${tp}-1) {
//:                 my $j = 4 + $i;
//:                 print "{mon_int8_sq_${j},int8_sq_${j}} <= (int8_abs_${j} * int8_abs_${j});  \n";
//:              }
//:             my $b0 = ${tp}+4+0;
//:             my $b1 = ${tp}+4+1;
//:             my $b2 = ${tp}+4+2;
//:             my $b3 = ${tp}+4+3;
//:     print qq(
//:              {mon_int8_sq_${b0},int8_sq_${b0}} <=                   (int8_abs_${b0} * int8_abs_${b0});
//:              {mon_int8_sq_${b1},int8_sq_${b1}} <= (len5|len7|len9)? (int8_abs_${b1} * int8_abs_${b1}) : {(${icvto}*2){1'b0}};
//:              {mon_int8_sq_${b2},int8_sq_${b2}} <= (     len7|len9)? (int8_abs_${b2} * int8_abs_${b2}) : {(${icvto}*2){1'b0}};
//:              {mon_int8_sq_${b3},int8_sq_${b3}} <=            len9 ? (int8_abs_${b3} * int8_abs_${b3}) : {(${icvto}*2){1'b0}};
//:           end
//:         end
//:     );

assign buf2sum_din_prdy = ~buf2sum_d_vld | buf2sum_d_rdy;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buf2sum_d_vld <= 1'b0;
  end else begin
    if(cdp_buf2sum_valid)
        buf2sum_d_vld <= 1'b1;
    else if(buf2sum_d_rdy)
        buf2sum_d_vld <= 1'b0;
  end
end
assign buf2sum_d_rdy = ~buf2sum_2d_vld | buf2sum_2d_rdy;
//===========
//sum process
//-----------
assign len3 = (reg2dp_normalz_len[1:0] == 2'h0 );
assign len5 = (reg2dp_normalz_len[1:0] == 2'h1 );
assign len7 = (reg2dp_normalz_len[1:0] == 2'h2 );
assign len9 = (reg2dp_normalz_len[1:0] == 2'h3 );

assign load_din_d = buf2sum_d_vld & buf2sum_d_rdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buf2sum_2d_vld <= 1'b0;
  end else begin
    if(buf2sum_d_vld)
        buf2sum_2d_vld <= 1'b1;
    else if(buf2sum_2d_rdy)
        buf2sum_2d_vld <= 1'b0;
  end
end
assign buf2sum_2d_rdy  = ~buf2sum_3d_vld | buf2sum_3d_rdy ;

assign load_din_2d = buf2sum_2d_vld & buf2sum_2d_rdy;
//: my $tp=NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//:   foreach my $i  (0..${tp}-1) {
//:     print "int_sum_block_tp1 u_sum_block_$i ( \n";
//:     print qq(
//:          .nvdla_core_clk     (nvdla_core_clk)  
//:         ,.nvdla_core_rstn    (nvdla_core_rstn)         
//:         ,.len5               (len5)                    
//:         ,.len7               (len7)                    
//:         ,.len9               (len9)                    
//:         ,.load_din_2d        (load_din_2d)             
//:         ,.load_din_d         (load_din_d)              
//:         ,.reg2dp_normalz_len (reg2dp_normalz_len[1:0])
//:     );
//:         
//:         foreach my $k  (0..8) {
//:         my $j = $k + $i;
//:             print " ,.sq_pd_int8_${k}       (int8_sq_${j})  \n";
//:         }
//:     print qq(
//:         ,.int8_sum           (int8_sum_${i})      
//:     );
//:     print "    ); \n";
//:   }

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buf2sum_3d_vld <= 1'b0;
  end else begin
    if(buf2sum_2d_vld)
        buf2sum_3d_vld <= 1'b1;
    else if(buf2sum_3d_rdy)
        buf2sum_3d_vld <= 1'b0;
  end
end
assign buf2sum_3d_rdy  = sum_out_prdy;


//=======================================================
//data output select
//-------------------------------------------------------
assign sum_out_pd = {
//: my $tp=NVDLA_CDP_THROUGHPUT;
//:     if($tp > 1){
//:         foreach my $i  (0..${tp}-2) {
//:         my $j = ${tp} - $i -1;
//:           print "int8_sum_${j}, ";
//:         }
//:     }
int8_sum_0};
assign sum_out_pvld = buf2sum_3d_vld;

////////////////////////////////////
//assign sum_out_prdy = sum2itp_ready;
////////////////////////////////////

assign sum2itp_valid  = sum_out_pvld;
assign sum2itp_data = sum_out_pd;
//=======================================================
////////::pipe -bc -is sum2itp_pd (sum2itp_pvld,sum2itp_prdy) <= sum2itp_data (sum2itp_valid,sum2itp_ready);

//: my $k = NVDLA_CDP_THROUGHPUT*21;
//: &eperl::pipe("-wid $k -is -do sum2itp_pd -vo sum2itp_pvld -ri sum2itp_prdy -di sum2itp_data -vi sum2itp_valid -ro sum2itp_ready ");
assign sum_out_prdy = sum2itp_ready;



/////////////////////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_sum


