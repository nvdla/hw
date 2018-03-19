// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_intp.v

#include "NV_NVDLA_CDP_define.h"

module NV_NVDLA_CDP_DP_intp (
   nvdla_core_clk                  //|< i
  ,nvdla_core_rstn                 //|< i
  ,dp2reg_done                     //|< i
  ,intp2mul_prdy                   //|< i
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         ,lut2intp_X_data_${m}0         //|> o
//:         ,lut2intp_X_data_${m}0_17b     //|> o
//:         ,lut2intp_X_data_${m}1         //|> o
//:         ,lut2intp_X_info_${m}          //|> o
//:     );
//: }
  ,lut2intp_X_sel                  //|< i
  ,lut2intp_Y_sel                  //|< i
  ,lut2intp_pvld                   //|< i
  ,pwrbus_ram_pd                   //|< i
  ,reg2dp_lut_le_end_high          //|< i
  ,reg2dp_lut_le_end_low           //|< i
  ,reg2dp_lut_le_function          //|< i
  ,reg2dp_lut_le_index_offset      //|< i
  ,reg2dp_lut_le_slope_oflow_scale //|< i
  ,reg2dp_lut_le_slope_oflow_shift //|< i
  ,reg2dp_lut_le_slope_uflow_scale //|< i
  ,reg2dp_lut_le_slope_uflow_shift //|< i
  ,reg2dp_lut_le_start_high        //|< i
  ,reg2dp_lut_le_start_low         //|< i
  ,reg2dp_lut_lo_end_high          //|< i
  ,reg2dp_lut_lo_end_low           //|< i
  ,reg2dp_lut_lo_slope_oflow_scale //|< i
  ,reg2dp_lut_lo_slope_oflow_shift //|< i
  ,reg2dp_lut_lo_slope_uflow_scale //|< i
  ,reg2dp_lut_lo_slope_uflow_shift //|< i
  ,reg2dp_lut_lo_start_high        //|< i
  ,reg2dp_lut_lo_start_low         //|< i
  ,reg2dp_sqsum_bypass             //|< i
  ,sync2itp_pd                     //|< i
  ,sync2itp_pvld                   //|< i
  ,dp2reg_d0_perf_lut_hybrid       //|> o
  ,dp2reg_d0_perf_lut_le_hit       //|> o
  ,dp2reg_d0_perf_lut_lo_hit       //|> o
  ,dp2reg_d0_perf_lut_oflow        //|> o
  ,dp2reg_d0_perf_lut_uflow        //|> o
  ,dp2reg_d1_perf_lut_hybrid       //|> o
  ,dp2reg_d1_perf_lut_le_hit       //|> o
  ,dp2reg_d1_perf_lut_lo_hit       //|> o
  ,dp2reg_d1_perf_lut_oflow        //|> o
  ,dp2reg_d1_perf_lut_uflow        //|> o
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:       ,intp2mul_pd_$m                   //|> o
//:     );
//: }
  ,intp2mul_pvld                   //|> o
  ,lut2intp_prdy                   //|> o
  ,sync2itp_prdy                   //|> o
  );
//////////////////////////////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          dp2reg_done;
input          intp2mul_prdy;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         input [31:0] lut2intp_X_data_${m}0;
//:         input [16:0] lut2intp_X_data_${m}0_17b;
//:         input [31:0] lut2intp_X_data_${m}1;
//:         input [19:0] lut2intp_X_info_${m};
//:     );
//: }
input    [NVDLA_CDP_THROUGHPUT-1:0] lut2intp_X_sel;
input    [NVDLA_CDP_THROUGHPUT-1:0] lut2intp_Y_sel;
input          lut2intp_pvld;
input   [31:0] pwrbus_ram_pd;
input    [5:0] reg2dp_lut_le_end_high;
input   [31:0] reg2dp_lut_le_end_low;
input          reg2dp_lut_le_function;
input    [7:0] reg2dp_lut_le_index_offset;
input   [15:0] reg2dp_lut_le_slope_oflow_scale;
input    [4:0] reg2dp_lut_le_slope_oflow_shift;
input   [15:0] reg2dp_lut_le_slope_uflow_scale;
input    [4:0] reg2dp_lut_le_slope_uflow_shift;
input    [5:0] reg2dp_lut_le_start_high;
input   [31:0] reg2dp_lut_le_start_low;
input    [5:0] reg2dp_lut_lo_end_high;
input   [31:0] reg2dp_lut_lo_end_low;
input   [15:0] reg2dp_lut_lo_slope_oflow_scale;
input    [4:0] reg2dp_lut_lo_slope_oflow_shift;
input   [15:0] reg2dp_lut_lo_slope_uflow_scale;
input    [4:0] reg2dp_lut_lo_slope_uflow_shift;
input    [5:0] reg2dp_lut_lo_start_high;
input   [31:0] reg2dp_lut_lo_start_low;
input          reg2dp_sqsum_bypass;

//: my $k = NVDLA_CDP_THROUGHPUT;
//: my $icvto = NVDLA_CDP_ICVTO_BWPE;
//: print "input  [${k}*(${icvto}*2+3)-1:0] sync2itp_pd;  \n";
input          sync2itp_pvld;
output  [31:0] dp2reg_d0_perf_lut_hybrid;
output  [31:0] dp2reg_d0_perf_lut_le_hit;
output  [31:0] dp2reg_d0_perf_lut_lo_hit;
output  [31:0] dp2reg_d0_perf_lut_oflow;
output  [31:0] dp2reg_d0_perf_lut_uflow;
output  [31:0] dp2reg_d1_perf_lut_hybrid;
output  [31:0] dp2reg_d1_perf_lut_le_hit;
output  [31:0] dp2reg_d1_perf_lut_lo_hit;
output  [31:0] dp2reg_d1_perf_lut_oflow;
output  [31:0] dp2reg_d1_perf_lut_uflow;

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         output  [16:0] intp2mul_pd_$m;
//:     );
//: }
output         intp2mul_pvld;
output         lut2intp_prdy;
output         sync2itp_prdy;
//////////////////////////////////////////////////////////////////////
reg            X_exp;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         reg     [38:0] Xinterp_in0_pd_$m;
//:         reg     [37:0] Xinterp_in1_pd_$m;
//:         reg     [16:0] Xinterp_in_pd_$m;
//:         reg     [16:0] Xinterp_in_scale_$m;
//:         reg     [5:0]  Xinterp_in_shift_$m;
//:     );
//: }
reg     [31:0] both_hybrid_counter;
reg      [NVDLA_CDP_THROUGHPUT-1:0] both_hybrid_flag;
reg     [31:0] both_of_counter;
reg      [NVDLA_CDP_THROUGHPUT-1:0] both_of_flag;
reg     [31:0] both_uf_counter;
reg      [NVDLA_CDP_THROUGHPUT-1:0] both_uf_flag;
reg     [31:0] dp2reg_d0_perf_lut_hybrid;
reg     [31:0] dp2reg_d0_perf_lut_le_hit;
reg     [31:0] dp2reg_d0_perf_lut_lo_hit;
reg     [31:0] dp2reg_d0_perf_lut_oflow;
reg     [31:0] dp2reg_d0_perf_lut_uflow;
reg     [31:0] dp2reg_d1_perf_lut_hybrid;
reg     [31:0] dp2reg_d1_perf_lut_le_hit;
reg     [31:0] dp2reg_d1_perf_lut_lo_hit;
reg     [31:0] dp2reg_d1_perf_lut_oflow;
reg     [31:0] dp2reg_d1_perf_lut_uflow;
//reg    [NVDLA_CDP_THROUGHPUT*17-1:0] intp2mul_pd;
//reg            intp2mul_pvld;
reg            intp_pvld_d;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         reg     [16:0] ip2mul_pd_$m;
//:     );
//: }
//reg            ip2mul_prdy;
reg            layer_flg;
//reg    [NVDLA_CDP_THROUGHPUT*103-1:0] lut2intp_data;
//reg            lut2intp_prdy;
//reg            lut2intp_valid;
reg     [37:0] lut_le_max;
reg     [38:0] lut_le_min;
reg     [37:0] lut_lo_max;
reg     [37:0] lut_lo_min;
reg      [NVDLA_CDP_THROUGHPUT-1:0] only_le_hit;
reg     [31:0] only_le_hit_counter;
reg      [NVDLA_CDP_THROUGHPUT-1:0] only_lo_hit;
reg     [31:0] only_lo_hit_counter;
reg     [15:0] reg2dp_lut_le_slope_oflow_scale_sync;
reg      [4:0] reg2dp_lut_le_slope_oflow_shift_sync;
reg     [15:0] reg2dp_lut_le_slope_uflow_scale_sync;
reg      [4:0] reg2dp_lut_le_slope_uflow_shift_sync;
reg     [15:0] reg2dp_lut_lo_slope_oflow_scale_sync;
reg      [4:0] reg2dp_lut_lo_slope_oflow_shift_sync;
reg     [15:0] reg2dp_lut_lo_slope_uflow_scale_sync;
reg      [4:0] reg2dp_lut_lo_slope_uflow_shift_sync;
reg            sqsum_bypass_enable;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         wire     [1:0] X_info_$m;
//:         wire           X_oflow_$m;
//:         wire           X_uflow_$m;
//:         wire     [1:0] Y_info_$m;
//:         wire           Y_oflow_$m;
//:         wire           Y_uflow_$m;
//:         wire    [16:0] Xinterp_out_pd_$m;
//:         wire    [37:0] hit_in1_pd_$m;
//:     );
//: }
wire     [NVDLA_CDP_THROUGHPUT-1:0] Xinterp_in_rdy;
wire     [NVDLA_CDP_THROUGHPUT-1:0] Xinterp_in_vld;
wire     [NVDLA_CDP_THROUGHPUT-1:0] Xinterp_out_rdy;
wire     [NVDLA_CDP_THROUGHPUT-1:0] Xinterp_out_vld;
wire    [31:0] both_hybrid_counter_nxt;
wire     [3:0] both_hybrid_ele;
wire    [31:0] both_of_counter_nxt;
wire     [3:0] both_of_ele;
wire    [31:0] both_uf_counter_nxt;
wire     [3:0] both_uf_ele;
wire    [NVDLA_CDP_THROUGHPUT*4-1:0] dat_info_in;
wire    [NVDLA_CDP_THROUGHPUT*2-1:0] info_Xin_pd;
wire    [NVDLA_CDP_THROUGHPUT*2-1:0] info_Yin_pd;
wire    [NVDLA_CDP_THROUGHPUT*4-1:0] info_in_pd;
wire           info_in_rdy;
wire           info_in_vld;
wire    [NVDLA_CDP_THROUGHPUT*4-1:0] info_o_pd;
wire           info_o_rdy;
wire           info_o_vld;
wire           intp_in_prdy;
wire           intp_in_pvld;
wire           intp_prdy;
wire           intp_prdy_d;
wire           intp_pvld;
wire   [NVDLA_CDP_THROUGHPUT*17-1:0] ip2mul_pd;
wire           ip2mul_pvld;
wire           layer_done;
wire   [127:0] le_offset_exp;
wire     [6:0] le_offset_use;
wire    [16:0] le_slope_oflow_scale;
wire    [16:0] le_slope_uflow_scale;
wire    [16:0] lo_slope_oflow_scale;
wire    [16:0] lo_slope_uflow_scale;
wire   [NVDLA_CDP_THROUGHPUT*103-1:0] lut2intp_pd;
wire           lut2intp_ready;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         wire    [31:0] lut2ip_X_data_${m}0;
//:         wire    [16:0] lut2ip_X_data_${m}0_17b;
//:         wire    [31:0] lut2ip_X_data_${m}1;
//:         wire    [19:0] lut2ip_X_info_$m;
//:     );
//: }
wire     [NVDLA_CDP_THROUGHPUT-1:0] lut2ip_X_sel;
wire     [NVDLA_CDP_THROUGHPUT-1:0] lut2ip_Y_sel;
wire    [37:0] lut_le_end;
wire    [38:0] lut_le_min_int;
wire    [37:0] lut_le_start;
wire    [37:0] lut_lo_end;
wire    [37:0] lut_lo_start;
wire           mon_both_hybrid_counter_nxt;
wire           mon_both_of_counter_nxt;
wire           mon_both_uf_counter_nxt;
wire    [90:0] mon_lut_le_min_int;
wire           mon_only_le_hit_counter_nxt;
wire           mon_only_lo_hit_counter_nxt;
wire    [31:0] only_le_hit_counter_nxt;
wire     [3:0] only_le_hit_ele;
wire    [31:0] only_lo_hit_counter_nxt;
wire     [3:0] only_lo_hit_ele;
///////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    X_exp <= 1'b0;
  end else begin
  X_exp <= reg2dp_lut_le_function == 1'h0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sqsum_bypass_enable <= 1'b0;
  end else begin
  sqsum_bypass_enable <= reg2dp_sqsum_bypass == 1'h1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_lut_le_slope_uflow_shift_sync <= {5{1'b0}};
  end else begin
  reg2dp_lut_le_slope_uflow_shift_sync <= reg2dp_lut_le_slope_uflow_shift[4:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_lut_le_slope_oflow_shift_sync <= {5{1'b0}};
  end else begin
  reg2dp_lut_le_slope_oflow_shift_sync <= reg2dp_lut_le_slope_oflow_shift[4:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_lut_lo_slope_uflow_shift_sync <= {5{1'b0}};
  end else begin
  reg2dp_lut_lo_slope_uflow_shift_sync <= reg2dp_lut_lo_slope_uflow_shift[4:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_lut_lo_slope_oflow_shift_sync <= {5{1'b0}};
  end else begin
  reg2dp_lut_lo_slope_oflow_shift_sync <= reg2dp_lut_lo_slope_oflow_shift[4:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_lut_le_slope_uflow_scale_sync <= {16{1'b0}};
  end else begin
  reg2dp_lut_le_slope_uflow_scale_sync <= reg2dp_lut_le_slope_uflow_scale[15:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_lut_le_slope_oflow_scale_sync <= {16{1'b0}};
  end else begin
  reg2dp_lut_le_slope_oflow_scale_sync <= reg2dp_lut_le_slope_oflow_scale[15:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_lut_lo_slope_uflow_scale_sync <= {16{1'b0}};
  end else begin
  reg2dp_lut_lo_slope_uflow_scale_sync <= reg2dp_lut_lo_slope_uflow_scale[15:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_lut_lo_slope_oflow_scale_sync <= {16{1'b0}};
  end else begin
  reg2dp_lut_lo_slope_oflow_scale_sync <= reg2dp_lut_lo_slope_oflow_scale[15:0];
  end
end
///////////////////////////////////////////
assign le_slope_uflow_scale = {reg2dp_lut_le_slope_uflow_scale_sync[15],reg2dp_lut_le_slope_uflow_scale_sync[15:0]};
assign le_slope_oflow_scale = {reg2dp_lut_le_slope_oflow_scale_sync[15],reg2dp_lut_le_slope_oflow_scale_sync[15:0]};
assign lo_slope_uflow_scale = {reg2dp_lut_lo_slope_uflow_scale_sync[15],reg2dp_lut_lo_slope_uflow_scale_sync[15:0]};
assign lo_slope_oflow_scale = {reg2dp_lut_lo_slope_oflow_scale_sync[15],reg2dp_lut_lo_slope_oflow_scale_sync[15:0]};
///////////////////////////////////////////
//lut2intp pipe sync for timing

assign lut2intp_pd = {
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:            lut2intp_X_data_${m}0[31:0],lut2intp_X_data_${m}0_17b[16:0],lut2intp_X_data_${m}1[31:0],
//:     );
//: }
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:            lut2intp_X_info_${m}[19:0],
//:     );
//: }
               lut2intp_X_sel,
               lut2intp_Y_sel
               };

//: my $k = NVDLA_CDP_THROUGHPUT*103;
//: &eperl::pipe(" -is -wid $k -do lut2intp_data -vo lut2intp_valid -ri lut2intp_ready -di lut2intp_pd -vi lut2intp_pvld -ro lut2intp_prdy ");

assign {
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         lut2ip_X_data_${m}0[31:0],lut2ip_X_data_${m}0_17b[16:0],lut2ip_X_data_${m}1[31:0],
//:     );
//: }
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         lut2ip_X_info_${m}[19:0],
//:     );
//: }
        lut2ip_X_sel,
        lut2ip_Y_sel} = lut2intp_data;

///////////////////////////////////////////
//lock
//from lut2int and sync2itp to intp_in
assign lut2intp_ready = intp_in_prdy & sync2itp_pvld;
assign sync2itp_prdy = intp_in_prdy & lut2intp_valid;
assign intp_in_pvld = sync2itp_pvld & lut2intp_valid;
///////////////////////////////////////////
assign intp_in_prdy = (&Xinterp_in_rdy) & info_in_rdy;

//: my $k = NVDLA_CDP_THROUGHPUT;
//: my $icvto=NVDLA_CDP_ICVTO_BWPE;
//: my $sqbw=${icvto}*2+3;
//: foreach my $m (0..$k -1) {
//:   print qq(
//:     assign hit_in1_pd_$m = (sqsum_bypass_enable ? {{(38-${sqbw}){sync2itp_pd[${sqbw}*$m+${sqbw}-1]}} ,sync2itp_pd[${sqbw}*$m+${sqbw}-1:${sqbw}*$m]} : {17'd0,sync2itp_pd[${sqbw}*$m+${sqbw}-1:${sqbw}*$m] });
//:     );
//: }
/////////////////////////////////////////////////
//start/end prepare for out of range interpolation
/////////////////////////////////////////////////

assign lut_le_end[37:0]   = {reg2dp_lut_le_end_high[5:0],reg2dp_lut_le_end_low[31:0]};
assign lut_le_start[37:0] = {reg2dp_lut_le_start_high[5:0],reg2dp_lut_le_start_low[31:0]};
assign lut_lo_end[37:0]   = {reg2dp_lut_lo_end_high[5:0],reg2dp_lut_lo_end_low[31:0]};
assign lut_lo_start[37:0] = {reg2dp_lut_lo_start_high[5:0],reg2dp_lut_lo_start_low[31:0]};

assign le_offset_use = reg2dp_lut_le_index_offset[6:0];
assign le_offset_exp[127:0] = reg2dp_lut_le_index_offset[7] ? 128'd0 : (1'b1 << le_offset_use);
assign {mon_lut_le_min_int[90:0],lut_le_min_int[38:0]} = X_exp ? ($signed({{91{lut_le_start[37]}}, lut_le_start[37:0]}) + $signed({1'b0,le_offset_exp})) : {{92{lut_le_start[37]}}, lut_le_start[37:0]};

//
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_le_max[37:0] <= {38{1'b0}};
  end else begin
  lut_le_max[37:0] <= lut_le_end;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_le_min[38:0] <= {39{1'b0}};
  end else begin
  lut_le_min[38:0] <= lut_le_min_int;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_lo_max[37:0] <= {38{1'b0}};
  end else begin
  lut_lo_max[37:0] <= lut_lo_end;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_lo_min[37:0] <= {38{1'b0}};
  end else begin
  lut_lo_min[37:0] <= lut_lo_start;
  end
end

/////////////////////////////////////////////////
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:     assign X_uflow_${m} = lut2ip_X_info_${m}[16];   
//:     assign X_oflow_${m} = lut2ip_X_info_${m}[17];   
//:     assign Y_uflow_${m} = lut2ip_X_info_${m}[18];   
//:     assign Y_oflow_${m} = lut2ip_X_info_${m}[19];   
//:   );
//: }

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:      always @(*) begin
//:        if(lut2ip_X_sel[$m]) begin 
//:            if(X_uflow_$m) 
//:                Xinterp_in0_pd_$m = lut_le_min[38:0]; 
//:            else if(X_oflow_$m) 
//:                Xinterp_in0_pd_$m = {lut_le_max[37],lut_le_max[37:0]}; 
//:            else 
//:                Xinterp_in0_pd_$m = {{7{lut2ip_X_data_${m}0[31]}},lut2ip_X_data_${m}0[31:0]}; 
//:        end else if(lut2ip_Y_sel[$m]) begin
//:            if(Y_uflow_$m) 
//:                Xinterp_in0_pd_$m = {lut_lo_min[37],lut_lo_min[37:0]}; 
//:            else if(Y_oflow_$m) 
//:                Xinterp_in0_pd_$m = {lut_lo_max[37],lut_lo_max[37:0]}; 
//:            else 
//:                Xinterp_in0_pd_$m = {{7{lut2ip_X_data_${m}0[31]}},lut2ip_X_data_${m}0[31:0]}; 
//:        end else
//:                Xinterp_in0_pd_$m = 39'd0; 
//:      end
//:   );
//: }

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:      always @(*) begin
//:        if(lut2ip_X_sel[$m]) begin 
//:            if(X_uflow_$m | X_oflow_$m) 
//:                Xinterp_in1_pd_$m = hit_in1_pd_$m; 
//:            else 
//:                Xinterp_in1_pd_$m = {{6{lut2ip_X_data_${m}1[31]}},lut2ip_X_data_${m}1[31:0]}; 
//:        end else if(lut2ip_Y_sel[$m]) begin
//:            if(Y_uflow_$m | Y_oflow_$m) 
//:                Xinterp_in1_pd_$m = hit_in1_pd_$m; 
//:            else 
//:                Xinterp_in1_pd_$m = {{6{lut2ip_X_data_${m}1[31]}},lut2ip_X_data_${m}1[31:0]}; 
//:        end else
//:                Xinterp_in1_pd_$m = 38'd0; 
//:      end
//:   );
//: }



//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:      always @(*) begin
//:        if(lut2ip_X_sel[$m] | lut2ip_Y_sel[$m]) 
//:            Xinterp_in_pd_$m = lut2ip_X_data_${m}0_17b[16:0]; 
//:        else 
//:            Xinterp_in_pd_$m = 17'd0; 
//:      end
//:   );
//: }

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:      always @(*) begin
//:        if(lut2ip_X_sel[$m]) begin 
//:            if(X_uflow_$m) 
//:                Xinterp_in_scale_$m = le_slope_uflow_scale[16:0]; 
//:            else if(X_oflow_$m) 
//:                Xinterp_in_scale_$m = le_slope_oflow_scale[16:0]; 
//:            else 
//:                Xinterp_in_scale_$m = {1'b0,lut2ip_X_info_${m}[15:0]}; 
//:        end else if(lut2ip_Y_sel[$m]) begin
//:            if(Y_uflow_$m) 
//:                Xinterp_in_scale_$m = lo_slope_uflow_scale[16:0]; 
//:            else if(Y_oflow_$m) 
//:                Xinterp_in_scale_$m = lo_slope_oflow_scale[16:0]; 
//:            else 
//:                Xinterp_in_scale_$m = {1'b0,lut2ip_X_info_${m}[15:0]}; 
//:        end else
//:                Xinterp_in_scale_$m = 17'd0; 
//:      end
//:   );
//: }


//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:      always @(*) begin
//:        if(lut2ip_X_sel[$m]) begin 
//:            if(X_uflow_$m) 
//:                Xinterp_in_shift_$m = {{1{reg2dp_lut_le_slope_uflow_shift_sync[4]}}, reg2dp_lut_le_slope_uflow_shift_sync[4:0]}; 
//:            else if(X_oflow_$m) 
//:                Xinterp_in_shift_$m = {{1{reg2dp_lut_le_slope_oflow_shift_sync[4]}}, reg2dp_lut_le_slope_oflow_shift_sync[4:0]}; 
//:            else 
//:                Xinterp_in_shift_$m = {1'b0,5'd16}; 
//:        end else if(lut2ip_Y_sel[$m]) begin
//:            if(Y_uflow_$m) 
//:                Xinterp_in_shift_$m = {{1{reg2dp_lut_lo_slope_uflow_shift_sync[4]}}, reg2dp_lut_lo_slope_uflow_shift_sync[4:0]}; 
//:            else if(Y_oflow_$m) 
//:                Xinterp_in_shift_$m = {{1{reg2dp_lut_lo_slope_oflow_shift_sync[4]}}, reg2dp_lut_lo_slope_oflow_shift_sync[4:0]}; 
//:            else 
//:                Xinterp_in_shift_$m = {1'b0,5'd16}; 
//:        end else
//:                Xinterp_in_shift_$m = 6'd0; 
//:      end
//:   );
//: }


//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:      assign Xinterp_in_vld[$m] = intp_in_pvld & info_in_rdy
//:   );
//:      foreach my $i  (0..$k-1) {
//:         if($i != $m) {
//:             print qq(
//:                 & Xinterp_in_rdy[$i]
//:             );
//:         }
//:      }
//:   print qq(
//:   ;
//:   );
//: }


//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:          NV_NVDLA_CDP_DP_INTP_unit u_interp_X$m (
//:             .nvdla_core_clk          (nvdla_core_clk)
//:            ,.nvdla_core_rstn         (nvdla_core_rstn)               
//:            ,.interp_in0_pd           (Xinterp_in0_pd_${m}[38:0])     
//:            ,.interp_in1_pd           (Xinterp_in1_pd_${m}[37:0])     
//:            ,.interp_in_pd            (Xinterp_in_pd_${m}[16:0])      
//:            ,.interp_in_scale         (Xinterp_in_scale_${m}[16:0])   
//:            ,.interp_in_shift         (Xinterp_in_shift_${m}[5:0])    
//:            ,.interp_in_vld           (Xinterp_in_vld[$m])            
//:            ,.interp_out_rdy          (Xinterp_out_rdy[$m])           
//:            ,.interp_in_rdy           (Xinterp_in_rdy[$m])            
//:            ,.interp_out_pd           (Xinterp_out_pd_${m}[16:0])     
//:            ,.interp_out_vld          (Xinterp_out_vld[$m])            
//:            );
//:   );
//: }

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:      assign Xinterp_out_rdy[$m] = intp_prdy & info_o_vld
//:   );
//:      foreach my $i  (0..$k-1) {
//:         if($i != $m) {
//:             print qq(
//:                 & Xinterp_out_vld[$i]
//:             );
//:         }
//:      }
//:   print qq(
//:   ;
//:   );
//: }

assign info_o_rdy = intp_prdy & ((&Xinterp_out_vld));

///////////////////////////////////////////////
//process for normal uflow/oflow info
assign info_in_vld = intp_in_pvld & (&Xinterp_in_rdy);

assign info_Xin_pd  = {
//: my $k = NVDLA_CDP_THROUGHPUT;
//: if($k > 1) {
//:     foreach my $m  (0..$k-2) {
//:       my $i = $k -$m - 1;
//:       print qq(
//:         lut2ip_X_info_${i}[17:16],
//:       );
//:     }
//: }
        lut2ip_X_info_0[17:16]};

assign info_Yin_pd  = {
//: my $k = NVDLA_CDP_THROUGHPUT;
//: if($k > 1) {
//:     foreach my $m  (0..$k-2) {
//:       my $i = $k -$m - 1;
//:       print qq(
//:         lut2ip_X_info_${i}[19:18],
//:       );
//:     }
//: }
            lut2ip_X_info_0[19:18]};
assign dat_info_in = {info_Yin_pd,info_Xin_pd};

assign info_in_pd = dat_info_in;
NV_NVDLA_CDP_DP_intpinfo_fifo u_intpinfo_sync_fifo (
   .nvdla_core_clk          (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
  ,.intpinfo_wr_prdy        (info_in_rdy)                           //|> w
  ,.intpinfo_wr_pvld        (info_in_vld)                           //|< w
  //,.intpinfo_wr_pd          ({48'd0,info_in_pd})                      //|< w
  ,.intpinfo_wr_pd          (info_in_pd)                      //|< w
  ,.intpinfo_rd_prdy        (info_o_rdy)                            //|< w
  ,.intpinfo_rd_pvld        (info_o_vld)                            //|> w
  ,.intpinfo_rd_pd          (info_o_pd)                       //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])                   //|< i
  );

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:     assign X_info_$m = info_o_pd[${m}*2+1:${m}*2];
//:     assign Y_info_$m = info_o_pd[${k}*2+${m}*2+1:${k}*2+${m}*2];
//:   );
//: }

////////////////////////////////////////////////
assign intp_pvld  = info_o_vld & ((&Xinterp_out_vld));
assign intp_prdy  = ~intp_pvld_d | intp_prdy_d;
////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    intp_pvld_d <= 1'b0;
  end else begin
    if(intp_pvld)
        intp_pvld_d <= 1'b1;
    else if(intp_prdy_d)
        intp_pvld_d <= 1'b0;
  end
end
//assign intp_prdy_d = ip2mul_prdy;
assign ip2mul_pvld = intp_pvld_d;

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:   print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:           if (!nvdla_core_rstn) begin
//:             ip2mul_pd_$m <= {17{1'b0}};
//:           end else if(intp_pvld & intp_prdy) begin 
//:             ip2mul_pd_$m <= Xinterp_out_pd_$m; 
//:           end
//:         end
//:   );
//: }

////////////////////////////////////////////////
//LUT perf counters
////////////////////////////////////////////////
assign layer_done = dp2reg_done;

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $i  (0..$k-1) {
//:   print qq(
//:     always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:       if (!nvdla_core_rstn) begin
//:         both_hybrid_flag[$i] <= 1'b0;
//:         both_of_flag[$i] <= 1'b0;
//:         both_uf_flag[$i] <= 1'b0;
//:         only_le_hit[$i] <= 1'b0;
//:         only_lo_hit[$i] <= 1'b0;
//:       end else begin
//:       if(intp_pvld & intp_prdy) begin
//:           both_hybrid_flag[$i] <= ({X_info_$i,Y_info_$i} == 4'b0000) | ({X_info_$i,Y_info_$i} == 4'b0110) | ({X_info_$i,Y_info_$i} == 4'b1001);
//:           both_of_flag[$i]     <= ({X_info_$i,Y_info_$i} == 4'b1010);
//:           both_uf_flag[$i]     <= ({X_info_$i,Y_info_$i} == 4'b0101);
//:           only_le_hit[$i]      <= ({X_info_$i,Y_info_$i} == 4'b0001) | ({X_info_$i,Y_info_$i} == 4'b0010);
//:           only_lo_hit[$i]      <= ({X_info_$i,Y_info_$i} == 4'b0100) | ({X_info_$i,Y_info_$i} == 4'b1000);
//:       end
//:     end
//:     end
//:   );
//: }

function [3:0] fun_bit_sum_8;
  input [7:0] idata;
  reg [3:0] ocnt;
  begin
    ocnt =
        (( idata[0]  
      +  idata[1]  
      +  idata[2] ) 
      + ( idata[3]  
      +  idata[4]  
      +  idata[5] )) 
      + ( idata[6]  
      +  idata[7] ) ;
    fun_bit_sum_8 = ocnt;
  end
endfunction

assign both_hybrid_ele = fun_bit_sum_8({{(8-NVDLA_CDP_THROUGHPUT){1'b0}},both_hybrid_flag});
assign both_of_ele     = fun_bit_sum_8({{(8-NVDLA_CDP_THROUGHPUT){1'b0}},both_of_flag});
assign both_uf_ele     = fun_bit_sum_8({{(8-NVDLA_CDP_THROUGHPUT){1'b0}},both_uf_flag});
assign only_le_hit_ele = fun_bit_sum_8({{(8-NVDLA_CDP_THROUGHPUT){1'b0}},only_le_hit});
assign only_lo_hit_ele = fun_bit_sum_8({{(8-NVDLA_CDP_THROUGHPUT){1'b0}},only_lo_hit});

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    both_hybrid_counter <= {32{1'b0}};
    both_of_counter <= {32{1'b0}};
    both_uf_counter <= {32{1'b0}};
    only_le_hit_counter <= {32{1'b0}};
    only_lo_hit_counter <= {32{1'b0}};
  end else begin
    if(layer_done) begin
        both_hybrid_counter <= 32'd0;
        both_of_counter     <= 32'd0;
        both_uf_counter     <= 32'd0;
        only_le_hit_counter <= 32'd0;
        only_lo_hit_counter <= 32'd0;
    end else if(intp_pvld_d & intp_prdy_d) begin
        both_hybrid_counter <= mon_both_hybrid_counter_nxt  ? 32'hffff_ffff : both_hybrid_counter_nxt ;
        both_of_counter     <= mon_both_of_counter_nxt      ? 32'hffff_ffff : both_of_counter_nxt       ;
        both_uf_counter     <= mon_both_uf_counter_nxt      ? 32'hffff_ffff : both_uf_counter_nxt       ;
        only_le_hit_counter <= mon_only_le_hit_counter_nxt  ? 32'hffff_ffff : only_le_hit_counter_nxt   ;
        only_lo_hit_counter <= mon_only_lo_hit_counter_nxt  ? 32'hffff_ffff : only_lo_hit_counter_nxt   ;
    end 
  end
end

assign {mon_both_hybrid_counter_nxt  ,both_hybrid_counter_nxt[31:0]} = both_hybrid_counter + both_hybrid_ele;
assign {mon_both_of_counter_nxt      ,both_of_counter_nxt[31:0]    } = both_of_counter       + both_of_ele     ;
assign {mon_both_uf_counter_nxt      ,both_uf_counter_nxt[31:0]    } = both_uf_counter       + both_uf_ele     ;
assign {mon_only_le_hit_counter_nxt  ,only_le_hit_counter_nxt[31:0]} = only_le_hit_counter   + only_le_hit_ele ;
assign {mon_only_lo_hit_counter_nxt  ,only_lo_hit_counter_nxt[31:0]} = only_lo_hit_counter   + only_lo_hit_ele ;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    layer_flg <= 1'b0;
  end else begin
  if ((layer_done) == 1'b1) begin
    layer_flg <= ~layer_flg;
  // VCS coverage off
  end else if ((layer_done) == 1'b0) begin
  end else begin
    layer_flg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_perf_lut_hybrid <= {32{1'b0}};
  end else begin
  if ((layer_done & (~layer_flg)) == 1'b1) begin
    dp2reg_d0_perf_lut_hybrid <= both_hybrid_counter;
  // VCS coverage off
  end else if ((layer_done & (~layer_flg)) == 1'b0) begin
  end else begin
    dp2reg_d0_perf_lut_hybrid <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done & (~layer_flg)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_perf_lut_hybrid <= {32{1'b0}};
  end else begin
  if ((layer_done &   layer_flg ) == 1'b1) begin
    dp2reg_d1_perf_lut_hybrid <= both_hybrid_counter;
  // VCS coverage off
  end else if ((layer_done &   layer_flg ) == 1'b0) begin
  end else begin
    dp2reg_d1_perf_lut_hybrid <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done &   layer_flg ))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_perf_lut_oflow <= {32{1'b0}};
  end else begin
  if ((layer_done & (~layer_flg)) == 1'b1) begin
    dp2reg_d0_perf_lut_oflow <= both_of_counter;
  // VCS coverage off
  end else if ((layer_done & (~layer_flg)) == 1'b0) begin
  end else begin
    dp2reg_d0_perf_lut_oflow <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done & (~layer_flg)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_perf_lut_oflow <= {32{1'b0}};
  end else begin
  if ((layer_done &   layer_flg ) == 1'b1) begin
    dp2reg_d1_perf_lut_oflow <= both_of_counter;
  // VCS coverage off
  end else if ((layer_done &   layer_flg ) == 1'b0) begin
  end else begin
    dp2reg_d1_perf_lut_oflow <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done &   layer_flg ))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_perf_lut_uflow <= {32{1'b0}};
  end else begin
  if ((layer_done & (~layer_flg)) == 1'b1) begin
    dp2reg_d0_perf_lut_uflow <= both_uf_counter;
  // VCS coverage off
  end else if ((layer_done & (~layer_flg)) == 1'b0) begin
  end else begin
    dp2reg_d0_perf_lut_uflow <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done & (~layer_flg)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_perf_lut_uflow <= {32{1'b0}};
  end else begin
  if ((layer_done &   layer_flg ) == 1'b1) begin
    dp2reg_d1_perf_lut_uflow <= both_uf_counter;
  // VCS coverage off
  end else if ((layer_done &   layer_flg ) == 1'b0) begin
  end else begin
    dp2reg_d1_perf_lut_uflow <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done &   layer_flg ))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_perf_lut_le_hit <= {32{1'b0}};
  end else begin
  if ((layer_done & (~layer_flg)) == 1'b1) begin
    dp2reg_d0_perf_lut_le_hit <= only_le_hit_counter;
  // VCS coverage off
  end else if ((layer_done & (~layer_flg)) == 1'b0) begin
  end else begin
    dp2reg_d0_perf_lut_le_hit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done & (~layer_flg)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_perf_lut_le_hit <= {32{1'b0}};
  end else begin
  if ((layer_done &   layer_flg ) == 1'b1) begin
    dp2reg_d1_perf_lut_le_hit <= only_le_hit_counter;
  // VCS coverage off
  end else if ((layer_done &   layer_flg ) == 1'b0) begin
  end else begin
    dp2reg_d1_perf_lut_le_hit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done &   layer_flg ))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_perf_lut_lo_hit <= {32{1'b0}};
  end else begin
  if ((layer_done & (~layer_flg)) == 1'b1) begin
    dp2reg_d0_perf_lut_lo_hit <= only_lo_hit_counter;
  // VCS coverage off
  end else if ((layer_done & (~layer_flg)) == 1'b0) begin
  end else begin
    dp2reg_d0_perf_lut_lo_hit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done & (~layer_flg)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_perf_lut_lo_hit <= {32{1'b0}};
  end else begin
  if ((layer_done &   layer_flg ) == 1'b1) begin
    dp2reg_d1_perf_lut_lo_hit <= only_lo_hit_counter;
  // VCS coverage off
  end else if ((layer_done &   layer_flg ) == 1'b0) begin
  end else begin
    dp2reg_d1_perf_lut_lo_hit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done &   layer_flg ))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
////////////////////////////////////////////////
//intp output pipe sync for timing
////////////////////////////////////////////////
assign ip2mul_pd = {
//: my $k = NVDLA_CDP_THROUGHPUT;
//: if($k > 1) {
//:     foreach my $m  (0..$k-2) {
//:         my $i = $k - $m -1;
//:         print qq(
//:             ip2mul_pd_${i}[16:0],
//:         );
//:     }
//: }
ip2mul_pd_0[16:0]};

////////::pipe -bc -is intp2mul_pd(intp2mul_pvld,intp2mul_prdy) <= ip2mul_pd(ip2mul_pvld,ip2mul_prdy);
//: my $k = NVDLA_CDP_THROUGHPUT*17;
//: &eperl::pipe(" -wid $k -is -do intp2mul_pd -vo intp2mul_pvld -ri intp2mul_prdy -di ip2mul_pd -vi ip2mul_pvld -ro ip2mul_prdy ");

assign intp_prdy_d = ip2mul_prdy;


assign {
//: my $k = NVDLA_CDP_THROUGHPUT;
//: if($k > 1) {
//:     foreach my $m  (0..$k-2) {
//:         my $i = $k - $m -1;
//:         print qq(
//:             intp2mul_pd_${i}[16:0],
//:         );
//:     }
//: }
intp2mul_pd_0[16:0]} = intp2mul_pd;

////////////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_intp

//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_CDP_DP_intpinfo_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus intpinfo_wr -rd_pipebus intpinfo_rd -rd_reg -ram_bypass -d 19 -w 80 -ram ra2 [Chosen ram type: ra2 - ramgen_generic (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


#ifdef LARGE_FIFO_RAM

module NV_NVDLA_CDP_DP_intpinfo_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , intpinfo_wr_prdy
    , intpinfo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , intpinfo_wr_pause
`endif
    , intpinfo_wr_pd
    , intpinfo_rd_prdy
    , intpinfo_rd_pvld
    , intpinfo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        intpinfo_wr_prdy;
input         intpinfo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         intpinfo_wr_pause;
`endif
input  [31:0] intpinfo_wr_pd;
input         intpinfo_rd_prdy;
output        intpinfo_rd_pvld;
output [31:0] intpinfo_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        intpinfo_wr_busy_int;		        	// copy for internal use
assign     intpinfo_wr_prdy = !intpinfo_wr_busy_int;
assign       wr_reserving = intpinfo_wr_pvld && !intpinfo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [4:0] intpinfo_wr_count;			// write-side count

wire [4:0] wr_count_next_wr_popping = wr_reserving ? intpinfo_wr_count : (intpinfo_wr_count - 1'd1); // spyglass disable W164a W484
wire [4:0] wr_count_next_no_wr_popping = wr_reserving ? (intpinfo_wr_count + 1'd1) : intpinfo_wr_count; // spyglass disable W164a W484
wire [4:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_19 = ( wr_count_next_no_wr_popping == 5'd19 );
wire wr_count_next_is_19 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_19;
wire [4:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [4:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       intpinfo_wr_busy_next = wr_count_next_is_19 || // busy next cycle?
                          (wr_limit_reg != 5'd0 &&      // check intpinfo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || intpinfo_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       intpinfo_wr_busy_next = wr_count_next_is_19 || // busy next cycle?
                          (wr_limit_reg != 5'd0 &&      // check intpinfo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intpinfo_wr_busy_int <=  1'b0;
        intpinfo_wr_count <=  5'd0;
    end else begin
	intpinfo_wr_busy_int <=  intpinfo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    intpinfo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            intpinfo_wr_count <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as intpinfo_wr_pvld

//
// RAM
//

reg  [4:0] intpinfo_wr_adr;			// current write address
wire [4:0] intpinfo_rd_adr_p;		// read address to use for ram
wire [31:0] intpinfo_rd_pd_p_byp_ram;		// read data directly out of ram

wire rd_enable;

wire ore;
wire do_bypass;
wire comb_bypass;
wire rd_popping;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsthp_19x32 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( intpinfo_wr_adr )
    , .we        ( wr_pushing && (intpinfo_wr_count != 5'd0 || !rd_popping) )
    , .di        ( intpinfo_wr_pd )
    , .ra        ( intpinfo_rd_adr_p )
    , .re        ( (do_bypass && wr_pushing) || rd_enable )
    , .dout        ( intpinfo_rd_pd_p_byp_ram )
    , .byp_sel        ( comb_bypass )
    , .dbyp        ( intpinfo_wr_pd[31:0] )
    , .ore        ( ore )
    );
// next intpinfo_wr_adr if wr_pushing=1
wire [4:0] wr_adr_next = (intpinfo_wr_adr == 5'd18) ? 5'd0 : (intpinfo_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intpinfo_wr_adr <=  5'd0;
    end else begin
        if ( wr_pushing ) begin
            intpinfo_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            intpinfo_wr_adr   <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

reg  [4:0] intpinfo_rd_adr;		// current read address
// next    read address
wire [4:0] rd_adr_next = (intpinfo_rd_adr == 5'd18) ? 5'd0 : (intpinfo_rd_adr + 1'd1);   // spyglass disable W484
assign         intpinfo_rd_adr_p = rd_popping ? rd_adr_next : intpinfo_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intpinfo_rd_adr <=  5'd0;
    end else begin
        if ( rd_popping ) begin
	    intpinfo_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            intpinfo_rd_adr <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end
end
// spyglass enable_block W484

assign do_bypass = (rd_popping ? (intpinfo_wr_adr == rd_adr_next) : (intpinfo_wr_adr == intpinfo_rd_adr));
wire [31:0] intpinfo_rd_pd_p_byp = intpinfo_rd_pd_p_byp_ram;


//
// Combinatorial Bypass
//
// If we're pushing an empty fifo, mux the wr_data directly.
//
assign comb_bypass = intpinfo_wr_count == 0;
wire [31:0] intpinfo_rd_pd_p = intpinfo_rd_pd_p_byp;



//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       intpinfo_rd_pvld_p; 		// data out of fifo is valid

reg        intpinfo_rd_pvld_int;	// internal copy of intpinfo_rd_pvld
assign     intpinfo_rd_pvld = intpinfo_rd_pvld_int;
assign     rd_popping = intpinfo_rd_pvld_p && !(intpinfo_rd_pvld_int && !intpinfo_rd_prdy);

reg  [4:0] intpinfo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [4:0] rd_count_p_next_rd_popping = rd_pushing ? intpinfo_rd_count_p : 
                                                                (intpinfo_rd_count_p - 1'd1);
wire [4:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (intpinfo_rd_count_p + 1'd1) : 
                                                                    intpinfo_rd_count_p;
// spyglass enable_block W164a W484
wire [4:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign     intpinfo_rd_pvld_p = intpinfo_rd_count_p != 0 || rd_pushing;
assign rd_enable = ((rd_count_p_next_not_0) && ((~intpinfo_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intpinfo_rd_count_p <=  5'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    intpinfo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            intpinfo_rd_count_p <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (intpinfo_rd_pvld_p || (intpinfo_rd_pvld_int && !intpinfo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intpinfo_rd_pvld_int <=  1'b0;
    end else begin
        intpinfo_rd_pvld_int <=  rd_req_next;
    end
end
assign intpinfo_rd_pd = intpinfo_rd_pd_p;
assign ore = rd_popping;

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (intpinfo_wr_pvld && !intpinfo_wr_busy_int) || (intpinfo_wr_busy_int != intpinfo_wr_busy_next)) || (rd_pushing || rd_popping || (intpinfo_rd_pvld_int && intpinfo_rd_prdy)))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_DP_intpinfo_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_DP_intpinfo_fifo_wr_limit : 5'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 5'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 5'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 5'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [4:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 5'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( intpinfo_wr_pvld && !(!intpinfo_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst0(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst1(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {27'd0, (wr_limit_reg == 5'd0) ? 5'd19 : wr_limit_reg} )
    , .curr	( {27'd0, intpinfo_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_DP_intpinfo_fifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_CDP_DP_intpinfo_fifo



#endif

#ifdef SMALL_FIFO_RAM
module NV_NVDLA_CDP_DP_intpinfo_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , intpinfo_wr_prdy
    , intpinfo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , intpinfo_wr_pause
`endif
    , intpinfo_wr_pd
    , intpinfo_rd_prdy
    , intpinfo_rd_pvld
    , intpinfo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        intpinfo_wr_prdy;
input         intpinfo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         intpinfo_wr_pause;
`endif
input  [3:0] intpinfo_wr_pd;
input         intpinfo_rd_prdy;
output        intpinfo_rd_pvld;
output [3:0] intpinfo_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        intpinfo_wr_busy_int;		        	// copy for internal use
assign     intpinfo_wr_prdy = !intpinfo_wr_busy_int;
assign       wr_reserving = intpinfo_wr_pvld && !intpinfo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [4:0] intpinfo_wr_count;			// write-side count

wire [4:0] wr_count_next_wr_popping = wr_reserving ? intpinfo_wr_count : (intpinfo_wr_count - 1'd1); // spyglass disable W164a W484
wire [4:0] wr_count_next_no_wr_popping = wr_reserving ? (intpinfo_wr_count + 1'd1) : intpinfo_wr_count; // spyglass disable W164a W484
wire [4:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_19 = ( wr_count_next_no_wr_popping == 5'd19 );
wire wr_count_next_is_19 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_19;
wire [4:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [4:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       intpinfo_wr_busy_next = wr_count_next_is_19 || // busy next cycle?
                          (wr_limit_reg != 5'd0 &&      // check intpinfo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || intpinfo_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       intpinfo_wr_busy_next = wr_count_next_is_19 || // busy next cycle?
                          (wr_limit_reg != 5'd0 &&      // check intpinfo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intpinfo_wr_busy_int <=  1'b0;
        intpinfo_wr_count <=  5'd0;
    end else begin
	intpinfo_wr_busy_int <=  intpinfo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    intpinfo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            intpinfo_wr_count <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as intpinfo_wr_pvld

//
// RAM
//

reg  [4:0] intpinfo_wr_adr;			// current write address
wire [4:0] intpinfo_rd_adr_p;		// read address to use for ram
wire [3:0] intpinfo_rd_pd_p_byp_ram;		// read data directly out of ram

wire rd_enable;

wire ore;
wire do_bypass;
wire comb_bypass;
wire rd_popping;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsthp_19x4 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( intpinfo_wr_adr )
    , .we        ( wr_pushing && (intpinfo_wr_count != 5'd0 || !rd_popping) )
    , .di        ( intpinfo_wr_pd )
    , .ra        ( intpinfo_rd_adr_p )
    , .re        ( (do_bypass && wr_pushing) || rd_enable )
    , .dout        ( intpinfo_rd_pd_p_byp_ram )
    , .byp_sel        ( comb_bypass )
    , .dbyp        ( intpinfo_wr_pd[3:0] )
    , .ore        ( ore )
    );
// next intpinfo_wr_adr if wr_pushing=1
wire [4:0] wr_adr_next = (intpinfo_wr_adr == 5'd18) ? 5'd0 : (intpinfo_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intpinfo_wr_adr <=  5'd0;
    end else begin
        if ( wr_pushing ) begin
            intpinfo_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            intpinfo_wr_adr   <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

reg  [4:0] intpinfo_rd_adr;		// current read address
// next    read address
wire [4:0] rd_adr_next = (intpinfo_rd_adr == 5'd18) ? 5'd0 : (intpinfo_rd_adr + 1'd1);   // spyglass disable W484
assign         intpinfo_rd_adr_p = rd_popping ? rd_adr_next : intpinfo_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intpinfo_rd_adr <=  5'd0;
    end else begin
        if ( rd_popping ) begin
	    intpinfo_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            intpinfo_rd_adr <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end
end
// spyglass enable_block W484

assign do_bypass = (rd_popping ? (intpinfo_wr_adr == rd_adr_next) : (intpinfo_wr_adr == intpinfo_rd_adr));
wire [3:0] intpinfo_rd_pd_p_byp = intpinfo_rd_pd_p_byp_ram;


//
// Combinatorial Bypass
//
// If we're pushing an empty fifo, mux the wr_data directly.
//
assign comb_bypass = intpinfo_wr_count == 0;
wire [3:0] intpinfo_rd_pd_p = intpinfo_rd_pd_p_byp;



//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       intpinfo_rd_pvld_p; 		// data out of fifo is valid

reg        intpinfo_rd_pvld_int;	// internal copy of intpinfo_rd_pvld
assign     intpinfo_rd_pvld = intpinfo_rd_pvld_int;
assign     rd_popping = intpinfo_rd_pvld_p && !(intpinfo_rd_pvld_int && !intpinfo_rd_prdy);

reg  [4:0] intpinfo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [4:0] rd_count_p_next_rd_popping = rd_pushing ? intpinfo_rd_count_p : 
                                                                (intpinfo_rd_count_p - 1'd1);
wire [4:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (intpinfo_rd_count_p + 1'd1) : 
                                                                    intpinfo_rd_count_p;
// spyglass enable_block W164a W484
wire [4:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign     intpinfo_rd_pvld_p = intpinfo_rd_count_p != 0 || rd_pushing;
assign rd_enable = ((rd_count_p_next_not_0) && ((~intpinfo_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intpinfo_rd_count_p <=  5'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    intpinfo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            intpinfo_rd_count_p <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (intpinfo_rd_pvld_p || (intpinfo_rd_pvld_int && !intpinfo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intpinfo_rd_pvld_int <=  1'b0;
    end else begin
        intpinfo_rd_pvld_int <=  rd_req_next;
    end
end
assign intpinfo_rd_pd = intpinfo_rd_pd_p;
assign ore = rd_popping;

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (intpinfo_wr_pvld && !intpinfo_wr_busy_int) || (intpinfo_wr_busy_int != intpinfo_wr_busy_next)) || (rd_pushing || rd_popping || (intpinfo_rd_pvld_int && intpinfo_rd_prdy)))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_DP_intpinfo_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_DP_intpinfo_fifo_wr_limit : 5'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 5'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 5'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 5'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [4:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 5'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intpinfo_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( intpinfo_wr_pvld && !(!intpinfo_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst0(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst1(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {27'd0, (wr_limit_reg == 5'd0) ? 5'd19 : wr_limit_reg} )
    , .curr	( {27'd0, intpinfo_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_DP_intpinfo_fifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_CDP_DP_intpinfo_fifo





#endif



