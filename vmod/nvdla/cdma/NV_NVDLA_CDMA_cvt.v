// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_cvt.v

#include "NV_NVDLA_CDMA_define.h"

module NV_NVDLA_CDMA_cvt (
   nvdla_core_clk  
  ,nvdla_core_rstn 
  ,dc2cvt_dat_wr_en
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      ,dc2cvt_dat_wr_sel
//:      ,dc2cvt_dat_wr_addr
//:      ,dc2cvt_dat_wr_data
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:       ,dc2cvt_dat_wr_mask
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:             ,dc2cvt_dat_wr_addr${i}
//:             ,dc2cvt_dat_wr_data${i}
//:         );
//:     }
//: } else {
//:     print qq(
//:      ,dc2cvt_dat_wr_addr
//:      ,dc2cvt_dat_wr_data
//:     );
//: }
  ,dc2cvt_dat_wr_info_pd

#ifdef NVDLA_WINOGRAD_ENABLE
  ,wg2cvt_dat_wr_en       
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      ,wg2cvt_dat_wr_sel
//:      ,wg2cvt_dat_wr_addr
//:      ,wg2cvt_dat_wr_data
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:       ,wg2cvt_dat_wr_mask
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:             ,wg2cvt_dat_wr_addr${i}
//:             ,wg2cvt_dat_wr_data${i}
//:         );
//:     }
//: } else {
//:     print qq(
//:      ,wg2cvt_dat_wr_addr
//:      ,wg2cvt_dat_wr_data
//:     );
//: }
//   ,wg2cvt_dat_wr_addr     
//   ,wg2cvt_dat_wr_hsel     
//   ,wg2cvt_dat_wr_data     
  ,wg2cvt_dat_wr_info_pd  
#endif
  ,img2cvt_dat_wr_en      
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      ,img2cvt_dat_wr_sel 
//:      ,img2cvt_dat_wr_addr 
//:      ,img2cvt_dat_wr_data 
//:      ,img2cvt_mn_wr_data 
//:      ,img2cvt_dat_wr_pad_mask
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:         ,img2cvt_dat_wr_mask
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:             ,img2cvt_dat_wr_addr${i}
//:             ,img2cvt_dat_wr_data${i}
//:             ,img2cvt_mn_wr_data${i}
//:             ,img2cvt_dat_wr_pad_mask${i}
//:         );
//:     }
//: } else {
//:     print qq(
//:      ,img2cvt_dat_wr_addr
//:      ,img2cvt_dat_wr_data
//:      ,img2cvt_mn_wr_data
//:      ,img2cvt_dat_wr_pad_mask
//:     );
//: }
  //  ,img2cvt_dat_wr_addr    
  //  ,img2cvt_dat_wr_hsel    
  //  ,img2cvt_dat_wr_data    
  //  ,img2cvt_mn_wr_data     
  ,img2cvt_dat_wr_info_pd 
  ,cdma2buf_dat_wr_en     
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     print qq(
//:      ,cdma2buf_dat_wr_sel
//:      ,cdma2buf_dat_wr_addr
//:      ,cdma2buf_dat_wr_data
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:        ,cdma2buf_dat_wr_mask
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:             ,cdma2buf_dat_wr_addr${i}
//:             ,cdma2buf_dat_wr_data${i}
//:         );
//:     }
//: } else {
//:     print qq(
//:      ,cdma2buf_dat_wr_addr
//:      ,cdma2buf_dat_wr_data
//:     );
//: }
//      ,cdma2buf_dat_wr_addr   
//      ,cdma2buf_dat_wr_hsel   
//      ,cdma2buf_dat_wr_data   
  ,nvdla_hls_clk          
  ,slcg_hls_en            
  ,nvdla_core_ng_clk      
  ,reg2dp_op_en           
  ,reg2dp_in_precision    
  ,reg2dp_proc_precision  
  ,reg2dp_cvt_en          
  ,reg2dp_cvt_truncate    
  ,reg2dp_cvt_offset      
  ,reg2dp_cvt_scale       
  ,reg2dp_nan_to_zero     
  ,reg2dp_pad_value       
  ,dp2reg_done            
 // ,img2cvt_dat_wr_pad_mask
  ,dp2reg_nan_data_num    
  ,dp2reg_inf_data_num    
  ,dp2reg_dat_flush_done  
  );
///////////////////////////////////////////////////////////////////
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         dc2cvt_dat_wr_en;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      input [${k}-1:0]     dc2cvt_dat_wr_sel;
//:      input [16:0]         dc2cvt_dat_wr_addr;
//:      input [${dmaif}-1:0] dc2cvt_dat_wr_data;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:      input   [${k}-1:0]      dc2cvt_dat_wr_mask;
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:             input [16:0]         dc2cvt_dat_wr_addr${i};
//:             input [${dmaif}-1:0] dc2cvt_dat_wr_data${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:      input [16:0]         dc2cvt_dat_wr_addr;
//:      input [${dmaif}-1:0] dc2cvt_dat_wr_data;
//:     );
//: }
input [11:0] dc2cvt_dat_wr_info_pd;
// input         dc2cvt_dat_wr_en;
// input  [11:0] dc2cvt_dat_wr_addr;
// input         dc2cvt_dat_wr_hsel;
// input [NVDLA_CDMA_DMAIF_BW-1:0] dc2cvt_dat_wr_data;
// input  [11:0] dc2cvt_dat_wr_info_pd;

#ifdef NVDLA_WINOGRAD_ENABLE
input         wg2cvt_dat_wr_en;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      input [${k}-1:0]     wg2cvt_dat_wr_sel;
//:      input [16:0]         wg2cvt_dat_wr_addr;
//:      input [${dmaif}-1:0] wg2cvt_dat_wr_data;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:      input   [${k}-1:0]      wg2cvt_dat_wr_mask;
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:              input [16:0]         wg2cvt_dat_wr_addr${i};
//:              input [${dmaif}-1:0] wg2cvt_dat_wr_data${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:      input [16:0]         wg2cvt_dat_wr_addr;
//:      input [${dmaif}-1:0] wg2cvt_dat_wr_data;
//:     );
//: }
// input  [11:0] wg2cvt_dat_wr_addr;
// input         wg2cvt_dat_wr_hsel;
// input [NVDLA_CDMA_DMAIF_BW-1:0] wg2cvt_dat_wr_data;
input  [11:0] wg2cvt_dat_wr_info_pd;
#endif
//////////////// img
input          img2cvt_dat_wr_en; 
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      input [${k}-1:0]     img2cvt_dat_wr_sel;
//:      input [16:0]         img2cvt_dat_wr_addr;
//:      input [${dmaif}-1:0] img2cvt_dat_wr_data;
//:      input [${Bnum}*16-1:0] img2cvt_mn_wr_data;
//:      input  [$Bnum-1:0]   img2cvt_dat_wr_pad_mask;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:      input   [${k}-1:0]      img2cvt_dat_wr_mask;
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:              input [16:0]         img2cvt_dat_wr_addr${i};
//:              input [${dmaif}-1:0] img2cvt_dat_wr_data${i};
//:              input [${Bnum}*16-1:0] img2cvt_mn_wr_data${i};
//:              input  [$Bnum-1:0]   img2cvt_dat_wr_pad_mask${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:      input [16:0]         img2cvt_dat_wr_addr;
//:      input [${dmaif}-1:0] img2cvt_dat_wr_data;
//:      input [${Bnum}*16-1:0] img2cvt_mn_wr_data;
//:      input  [$Bnum-1:0]   img2cvt_dat_wr_pad_mask;
//:     );
//: }
input   [11:0] img2cvt_dat_wr_info_pd;
//   input   [11:0] img2cvt_dat_wr_addr;
//   input          img2cvt_dat_wr_hsel;
//   //input [1023:0] img2cvt_dat_wr_data;
//   input [NVDLA_CDMA_DMAIF_BW-1:0] img2cvt_dat_wr_data;
//   //input  [127:0] img2cvt_dat_wr_pad_mask;
//   //input [1023:0] img2cvt_mn_wr_data;
//   //: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//   //: my $Bnum = $dmaif / NVDLA_BPE;
//   //: print qq(input  [$Bnum-1:0] img2cvt_dat_wr_pad_mask; );
//   input [NVDLA_CDMA_DMAIF_BW-1:0] img2cvt_mn_wr_data;

output         cdma2buf_dat_wr_en;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int($atmc/$dmaif);
//:     print qq(
//:      output [${k}-1:0]     cdma2buf_dat_wr_sel;
//:      output [16:0]         cdma2buf_dat_wr_addr;
//:      output [${dmaif}-1:0] cdma2buf_dat_wr_data;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:      output   [${k}-1:0]      cdma2buf_dat_wr_mask;
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:              output [16:0]         cdma2buf_dat_wr_addr${i};
//:              output [${dmaif}-1:0] cdma2buf_dat_wr_data${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:      output [16:0]         cdma2buf_dat_wr_addr;
//:      output [${dmaif}-1:0] cdma2buf_dat_wr_data;
//:     );
//: }

//  output          cdma2buf_dat_wr_en; 
//  output   [11:0] cdma2buf_dat_wr_addr;
//  output    [1:0] cdma2buf_dat_wr_hsel;
//  //output [1023:0] cdma2buf_dat_wr_data;
//  output [NVDLA_CDMA_DMAIF_BW-1:0] cdma2buf_dat_wr_data;

input   nvdla_hls_clk;
output  slcg_hls_en;
input   nvdla_core_ng_clk;

input   [0:0]    reg2dp_op_en;
input   [1:0]    reg2dp_in_precision;
input   [1:0]    reg2dp_proc_precision;
input   [0:0]    reg2dp_cvt_en;
input   [5:0]    reg2dp_cvt_truncate;
input   [15:0]   reg2dp_cvt_offset;
input   [15:0]   reg2dp_cvt_scale;
input   [0:0]    reg2dp_nan_to_zero;
input   [15:0]   reg2dp_pad_value;
input            dp2reg_done;
output  [31:0]   dp2reg_nan_data_num;
output  [31:0]   dp2reg_inf_data_num;
output           dp2reg_dat_flush_done;
///////////////////////////////////////////////////////////////////
reg       [5:0] cfg_cvt_en;
reg             cfg_in_int8;
reg      [1:0] cfg_in_precision;
reg      [1:0] cfg_proc_precision;
reg     [15:0] cfg_scale;
reg      [5:0] cfg_truncate;
reg     [15:0] cfg_offset;
reg             cfg_out_int8;
reg     [15:0] cfg_pad_value;
reg      [16:0] cvt_out_addr_d1;
reg      [16:0] cvt_out_addr_reg;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm=NVDLA_MEMORY_ATOMIC_SIZE;
//: my $bpe = NVDLA_BPE;
//: my $Bnum = $dmaif / $bpe;
//: my $atmm_num= $Bnum / $atmm;
//: foreach my $k (0..$atmm_num -1) {
//:     print qq(reg     [${atmm}*${bpe}-1:0] cvt_out_data_p${k}_reg; \n);
//:     print qq(wire    [${atmm}*${bpe}-1:0] cvt_out_data_p${k};  \n);
//: }
reg       [3:0] cvt_out_nz_mask_d1;
reg             cvt_out_pad_vld_d1;
reg             cvt_out_vld_d1;
reg             cvt_out_vld_reg;
reg    [NVDLA_CDMA_DMAIF_BW-1:0] cvt_wr_data_d1;
reg             cvt_wr_en_d1;
reg             cvt_wr_mean_d1;
reg    [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE*16-1:0] cvt_wr_mean_data_d1;
reg      [17:0] dat_cbuf_flush_idx;
#ifndef NVDLA_FEATURE_DATA_TYPE_INT8
reg      [31:0] dat_fp16_inf_flag;
reg             dat_fp16_inf_vld;
reg      [31:0] dat_fp16_nan_flag;
reg             dat_fp16_nan_vld;
reg      [31:0] dp2reg_inf_data_num;
reg      [31:0] dp2reg_nan_data_num;
#else
wire     [31:0] dp2reg_inf_data_num;
wire     [31:0] dp2reg_nan_data_num;
#endif
reg             is_data_expand;
reg             is_data_normal;
reg             is_input_fp16;
reg       [0:0] is_input_int8;
reg             op_en;
reg             op_en_d0;
reg             cvt_wr_uint_d1;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $Bnum = $dmaif / $bpe;
//: foreach my $i (0..$Bnum -1) {
//: print qq(
//:     reg      [16:0] oprand_0_${i}_d0;
//:     reg      [15:0] oprand_1_${i}_d0;
//:     wire     [16:0] oprand_0_${i}_ori;
//:     wire     [15:0] oprand_1_${i}_ori;
//:     wire     [15:0] cellout_${i};
//: );
//: }
//: print qq(
//:     wire     [$Bnum-1:0] oprand_0_8b_sign;
//:     wire     [$Bnum-1:0] mon_cell_op0_ready;
//:     wire     [$Bnum-1:0] mon_cell_op1_ready;
//:     wire     [$Bnum-1:0] cvt_cell_en;
//:     reg      [$Bnum-1:0] cell_en_d0;
//:     reg      [$Bnum-1:0] cvt_cell_en_d1;
//: );
reg             slcg_hls_en_d1;
reg             slcg_hls_en_d2;
reg             slcg_hls_en_d3;
wire    [15:0] cfg_pad_value_w;
wire            cfg_reg_en;
wire    [NVDLA_CDMA_DMAIF_BW-1:0] cvt_data_cell;
wire     [16:0] cvt_out_addr;
wire     [16:0] cvt_out_addr_bp;
wire     [16:0] cvt_out_addr_reg_w;
wire   [NVDLA_CDMA_DMAIF_BW-1:0] cvt_out_data_masked;
wire   [NVDLA_CDMA_DMAIF_BW-1:0] cvt_out_data_mix;
wire      [3:0] cvt_out_nz_mask_bp;
wire            cvt_out_pad_vld_bp;
wire            cvt_out_vld;
wire            cvt_out_vld_bp;
wire            cvt_out_vld_reg_w;
wire     [16:0] cvt_wr_addr;
wire   [NVDLA_CDMA_DMAIF_BW-1:0] cvt_wr_data;
wire            cvt_wr_en;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     my $s = int($atmc/$dmaif);
//:     print qq(
//:      wire  [${k}-1:0]     cvt_wr_sel;
//:      wire  [${k}-1:0]     cvt_out_sel;
//:      reg   [${k}-1:0]     cvt_out_sel_d1;
//:      wire  [${k}-1:0]     cvt_out_sel_bp;
//:      reg   [${s}-1:0]     cvt_out_sel_reg;
//:      wire  [${k}-1:0]     cvt_out_reg_en;
//:      reg   [${k}-1:0]     cvt_out_reg_en_d1;
//:      wire  [${k}-1:0]     cvt_out_reg_en_bp;
//:     );
//: } else {
//:     print qq(
//:      wire                 cvt_out_reg_en;
//:      reg                  cvt_out_reg_en_d1;
//:      wire                 cvt_out_reg_en_bp;
//:     );
//: }
//: print qq(
//:     wire    [${Bnum}-1:0] cvt_wr_pad_mask;
//:     reg     [${Bnum}-1:0] cvt_out_pad_mask_d1;
//:     wire    [${Bnum}-1:0] cvt_out_pad_mask_bp;
//: );

wire     [11:0] cvt_wr_info_pd;
wire      [3:0] cvt_wr_mask;
wire            cvt_wr_mean;
wire   [NVDLA_CDMA_DMAIF_BW/NVDLA_BPE*16-1:0] cvt_wr_mean_data;
wire      [2:0] cvt_wr_sub_h;
wire            cvt_wr_uint;
wire     [17:0] dat_cbuf_flush_idx_w;
wire            dat_cbuf_flush_vld_w;
wire     [31:0] dat_half_mask;
#ifndef NVDLA_FEATURE_DATA_TYPE_INT8
wire     [31:0] dat_fp16_exp_flag_w;
wire     [31:0] dat_fp16_inf_flag_w;
wire      [5:0] dat_fp16_inf_sum;
wire            dat_fp16_inf_vld_w;
wire     [31:0] dat_fp16_manti_flag_w;
wire     [31:0] dat_fp16_nan_flag_w;
wire      [5:0] dat_fp16_nan_sum;
wire            dat_fp16_nan_vld_w;
wire     [31:0] dp2reg_inf_data_num_inc;
wire     [31:0] dp2reg_inf_data_num_w;
wire     [31:0] dp2reg_nan_data_num_inc;
wire     [31:0] dp2reg_nan_data_num_w;
wire            inf_carry;
wire            inf_reg_en;
#endif
wire    [NVDLA_CDMA_DMAIF_BW-1:0] dat_nan_mask;
wire            is_data_expand_w;
wire            is_data_normal_w;
wire            is_input_fp16_w;
wire            is_input_int8_w;
wire            is_output_int8_w;
wire            mon_dat_cbuf_flush_idx_w;
wire            nan_carry;
wire            nan_reg_en;
wire            op_en_w;
wire            slcg_hls_en_w;
///////////////////////////////////////////////////////////////////
    
////////////////////////////////////////////////////////////////////////
//  prepare input signals                                             //
////////////////////////////////////////////////////////////////////////
assign op_en_w = ~dp2reg_done & reg2dp_op_en;
assign cfg_reg_en = op_en_w & ~op_en;
#ifdef NVDLA_FEATURE_DATA_TYPE_INT8
assign is_input_int8_w = 1'b1;
assign is_input_fp16_w = 1'b0;
assign is_output_int8_w = 1'b1;
#else
assign is_input_int8_w = (reg2dp_in_precision == 2'h0 );
assign is_input_fp16_w = (reg2dp_in_precision == 2'h2 );
assign is_output_int8_w = (reg2dp_proc_precision == 2'h0 );
#endif
assign is_data_expand_w = is_input_int8_w & ~is_output_int8_w;
assign is_data_normal_w = is_input_int8_w ~^ is_output_int8_w;
//assign nan_pass_w = ~reg2dp_nan_to_zero | ~is_input_fp16_w;
//assign cfg_pad_value_w = is_output_int8_w ? {2{reg2dp_pad_value[7:0]}} : reg2dp_pad_value;
assign cfg_pad_value_w = reg2dp_pad_value;

//: &eperl::flop("-nodeclare -rval \"1'b0\"                            -d \"op_en_w\"                -q op_en");
//: &eperl::flop("-nodeclare -rval \"{2{1'b0}}\"    -en \"cfg_reg_en\" -d \"reg2dp_in_precision\"    -q cfg_in_precision");
//: &eperl::flop("-nodeclare -rval \"{2{1'b0}}\"    -en \"cfg_reg_en\" -d \"reg2dp_proc_precision\"  -q cfg_proc_precision");
//: &eperl::flop("-nodeclare -rval \"{16{1'b0}}\"   -en \"cfg_reg_en\" -d \"reg2dp_cvt_scale\"       -q cfg_scale");
//: &eperl::flop("-nodeclare -rval \"{6{1'b0}}\"    -en \"cfg_reg_en\" -d \"reg2dp_cvt_truncate\"    -q cfg_truncate");
//: &eperl::flop("-nodeclare -rval \"{16{1'b0}}\"   -en \"cfg_reg_en\" -d \"reg2dp_cvt_offset\"      -q cfg_offset");
//: &eperl::flop("-nodeclare -rval \"{6{1'b0}}\"    -en \"cfg_reg_en\" -d \"{6{reg2dp_cvt_en}}\"     -q cfg_cvt_en");
//: &eperl::flop("-nodeclare -rval \"1'b0\"         -en \"cfg_reg_en\" -d \"is_input_int8_w\"        -q cfg_in_int8");
//: &eperl::flop("-nodeclare -rval \"1'b0\"         -en \"cfg_reg_en\" -d \"is_output_int8_w\"       -q cfg_out_int8");
//: &eperl::flop("-nodeclare -rval \"{16{1'b0}}\"   -en \"cfg_reg_en\" -d \"cfg_pad_value_w\"        -q cfg_pad_value");
//: &eperl::flop("-nodeclare -rval \"1'b0\"         -en \"cfg_reg_en\" -d \"is_input_int8_w\"        -q is_input_int8");
//: &eperl::flop("-nodeclare -rval \"1'b0\"         -en \"cfg_reg_en\" -d \"is_input_fp16_w\"        -q is_input_fp16");
//: &eperl::flop("-nodeclare -rval \"1'b0\"         -en \"cfg_reg_en\" -d \"is_data_expand_w\"       -q is_data_expand");
//: &eperl::flop("-nodeclare -rval \"1'b0\"         -en \"cfg_reg_en\" -d \"is_data_normal_w\"       -q is_data_normal");
// //: &eperl::flop("-nodeclare -rval \"1'b1\"         -en \"cfg_reg_en\" -d \"nan_pass_w\"             -q nan_pass");

////////////////////////////////////////////////////////////////////////
//  SLCG control signal                                               //
////////////////////////////////////////////////////////////////////////
assign slcg_hls_en_w = reg2dp_op_en & reg2dp_cvt_en;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"slcg_hls_en_w\" -q slcg_hls_en_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"slcg_hls_en_d1\" -q slcg_hls_en_d2");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"slcg_hls_en_d2\" -q slcg_hls_en_d3");

assign slcg_hls_en = slcg_hls_en_d3;

////////////////////////////////////////////////////////////////////////
//  Input signals                                                     //
////////////////////////////////////////////////////////////////////////

assign cvt_wr_info_pd = ({12 {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_info_pd)
#ifdef NVDLA_WINOGRAD_ENABLE
                      | ({12 {wg2cvt_dat_wr_en}} & wg2cvt_dat_wr_info_pd)
#endif
                      | ({12 {img2cvt_dat_wr_en}} & img2cvt_dat_wr_info_pd);

assign cvt_wr_mask[3:0] =     cvt_wr_info_pd[3:0];
//assign cvt_wr_interleave  =     cvt_wr_info_pd[4];
//assign cvt_wr_ext64  =     cvt_wr_info_pd[5];
//assign cvt_wr_ext128  =     cvt_wr_info_pd[6];
assign cvt_wr_mean  =     cvt_wr_info_pd[7];
assign cvt_wr_uint  =     cvt_wr_info_pd[8];
assign cvt_wr_sub_h[2:0] =     cvt_wr_info_pd[11:9];

#ifdef NVDLA_WINOGRAD_ENABLE
assign cvt_wr_en = (dc2cvt_dat_wr_en | wg2cvt_dat_wr_en | img2cvt_dat_wr_en);
#else
assign cvt_wr_en = (dc2cvt_dat_wr_en | img2cvt_dat_wr_en);
#endif

#ifdef NVDLA_WINOGRAD_ENABLE
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:          assign cvt_wr_pad_mask = img2cvt_dat_wr_en ? img2cvt_dat_wr_pad_mask : ${Bnum}'d0;
//:          assign cvt_wr_sel = dc2cvt_dat_wr_en ? dc2cvt_dat_wr_sel
//:                             : wg2cvt_dat_wr_en ? wg2cvt_dat_wr_sel
//:                             : img2cvt_dat_wr_en ? img2cvt_dat_wr_sel : 0;
//:          assign cvt_wr_addr = ({17 {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_addr)
//:                             | ({17 {wg2cvt_dat_wr_en}} & wg2cvt_dat_wr_addr)
//:                             | ({17 {img2cvt_dat_wr_en}} & img2cvt_dat_wr_addr);
//:          assign cvt_wr_data = ({NVDLA_CDMA_DMAIF_BW {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_data)
//:                             | ({NVDLA_CDMA_DMAIF_BW {wg2cvt_dat_wr_en}} & wg2cvt_dat_wr_data)
//:                             | ({NVDLA_CDMA_DMAIF_BW {img2cvt_dat_wr_en}} & img2cvt_dat_wr_data);
//:          assign cvt_wr_mean_data = img2cvt_mn_wr_data;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:          assign cvt_dat_wr_mask = (dc2cvt_dat_wr_en & dc2cvt_dat_wr_mask)
//:                                 | (wg2cvt_dat_wr_en & wg2cvt_dat_wr_mask)
//:                                 | (img2cvt_dat_wr_en & img2cvt_dat_wr_mask);
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:          assign cvt_wr_pad_mask${i} = img2cvt_dat_wr_en ? img2cvt_dat_wr_pad_mask${i} : ${Bnum}'d0;
//:          assign cvt_wr_addr${i} = ({17 {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_addr${i})
//:                                 | ({17 {wg2cvt_dat_wr_en}} & wg2cvt_dat_wr_addr${i})
//:                                 | ({17 {img2cvt_dat_wr_en}} & img2cvt_dat_wr_addr${i});
//:          assign cvt_wr_data${i} = ({NVDLA_CDMA_DMAIF_BW {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_data${i})
//:                                 | ({NVDLA_CDMA_DMAIF_BW {wg2cvt_dat_wr_en}} & wg2cvt_dat_wr_data${i})
//:                                 | ({NVDLA_CDMA_DMAIF_BW {img2cvt_dat_wr_en}} & img2cvt_dat_wr_data${i});
//:          assign cvt_wr_mean_data${i} = img2cvt_mn_wr_data${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:          assign cvt_wr_pad_mask = img2cvt_dat_wr_en ? img2cvt_dat_wr_pad_mask : ${Bnum}'d0;
//:          assign cvt_wr_addr = ({17 {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_addr)
//:                             | ({17 {wg2cvt_dat_wr_en}} & wg2cvt_dat_wr_addr)
//:                             | ({17 {img2cvt_dat_wr_en}} & img2cvt_dat_wr_addr);
//:          assign cvt_wr_data = ({NVDLA_CDMA_DMAIF_BW {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_data)
//:                             | ({NVDLA_CDMA_DMAIF_BW {wg2cvt_dat_wr_en}} & wg2cvt_dat_wr_data)
//:                             | ({NVDLA_CDMA_DMAIF_BW {img2cvt_dat_wr_en}} & img2cvt_dat_wr_data);
//:          assign cvt_wr_mean_data = img2cvt_mn_wr_data;
//:     );
//: }
#else
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:          assign cvt_wr_pad_mask = img2cvt_dat_wr_en ? img2cvt_dat_wr_pad_mask : ${Bnum}'d0;
//:          assign cvt_wr_sel = dc2cvt_dat_wr_en ? dc2cvt_dat_wr_sel
//:                             : img2cvt_dat_wr_en ? img2cvt_dat_wr_sel : 0;
//:          assign cvt_wr_addr = ({17 {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_addr)
//:                             | ({17 {img2cvt_dat_wr_en}} & img2cvt_dat_wr_addr);
//:          assign cvt_wr_data = ({NVDLA_CDMA_DMAIF_BW {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_data)
//:                             | ({NVDLA_CDMA_DMAIF_BW {img2cvt_dat_wr_en}} & img2cvt_dat_wr_data);
//:          assign cvt_wr_mean_data = img2cvt_mn_wr_data;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:          assign cvt_dat_wr_mask = (dc2cvt_dat_wr_en & dc2cvt_dat_wr_mask)
//:                                 | (img2cvt_dat_wr_en & img2cvt_dat_wr_mask);
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:          assign cvt_wr_pad_mask${i} = img2cvt_dat_wr_en ? img2cvt_dat_wr_pad_mask${i} : ${Bnum}'d0;
//:          assign cvt_wr_addr${i} = ({17 {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_addr${i})
//:                                 | ({17 {img2cvt_dat_wr_en}} & img2cvt_dat_wr_addr${i});
//:          assign cvt_wr_data${i} = ({NVDLA_CDMA_DMAIF_BW {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_data${i})
//:                                 | ({NVDLA_CDMA_DMAIF_BW {img2cvt_dat_wr_en}} & img2cvt_dat_wr_data${i});
//:          assign cvt_wr_mean_data${i} = img2cvt_mn_wr_data${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:          assign cvt_wr_pad_mask = img2cvt_dat_wr_en ? img2cvt_dat_wr_pad_mask : ${Bnum}'d0;
//:          assign cvt_wr_addr = ({17 {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_addr)
//:                             | ({17 {img2cvt_dat_wr_en}} & img2cvt_dat_wr_addr);
//:          assign cvt_wr_data = ({NVDLA_CDMA_DMAIF_BW {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_data)
//:                             | ({NVDLA_CDMA_DMAIF_BW {img2cvt_dat_wr_en}} & img2cvt_dat_wr_data);
//:          assign cvt_wr_mean_data = img2cvt_mn_wr_data;
//:     );
//: }
#endif

////////////////////////////////////////////////////////////////////////
//  generator mux control signals                                     //
////////////////////////////////////////////////////////////////////////
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     print qq(
//:         assign cvt_out_sel = cvt_wr_sel;
//:         assign cvt_out_reg_en = cvt_wr_en ? cvt_out_sel : 0;
//:     );
//: } else {
//:     print qq(
//:         //assign cvt_out_reg_en = cvt_wr_en;
//:         assign cvt_out_reg_en = 1'b0;
//:     );
//: }
assign cvt_out_addr = cvt_wr_addr;
assign cvt_out_vld = cvt_wr_en;

//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm=NVDLA_MEMORY_ATOMIC_SIZE;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmm_num = $Bnum / $atmm;
//: if($atmm_num == 1) {
//:     print qq(
//:         assign cvt_cell_en = (cvt_wr_en & cfg_cvt_en[0]) ? {${atmm}{cvt_wr_mask[0]}} : ${Bnum}'b0;
//:     );
//: } elsif($atmm_num == 2) {
//:     print qq(
//:         assign cvt_cell_en = (cvt_wr_en & cfg_cvt_en[0]) ? {{${atmm}{cvt_wr_mask[1]}},{${atmm}{cvt_wr_mask[0]}}} : ${Bnum}'b0;
//:     );
//: } elsif($atmm_num == 4) {
//:     print qq(
//:         assign cvt_cell_en = (cvt_wr_en & cfg_cvt_en[0]) ? {{${atmm}{cvt_wr_mask[3]}},{${atmm}{cvt_wr_mask[2]}},{${atmm}{cvt_wr_mask[1]}},{${atmm}{cvt_wr_mask[0]}}} : ${Bnum}'b0;
//:     );
//: }

//assign cvt_out_reg_en = cvt_wr_en ? {{4{cvt_out_sel[1]}}, {4{cvt_out_sel[0]}}} : 8'b0;

////////////////////////////////////////////////////////////////////////
//  One pipeline stage for retiming                                   //
////////////////////////////////////////////////////////////////////////
//: &eperl::flop("-nodeclare   -rval \"1'b0\"                                   -d \"cvt_wr_en\"             -q cvt_wr_en_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"        -en \"cvt_wr_en\"          -d \"cvt_wr_mean\"           -q cvt_wr_mean_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"        -en \"cvt_wr_en\"          -d \"cvt_wr_uint\"           -q cvt_wr_uint_d1");
//: &eperl::flop("-nodeclare  -norst                 -en \"cvt_wr_en & cvt_wr_mean\" -d \"cvt_wr_mean_data\" -q cvt_wr_mean_data_d1");
//: &eperl::flop("-nodeclare  -norst                 -en \"cvt_wr_en\"          -d \"cvt_wr_data\"           -q cvt_wr_data_d1");
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $Bnum = $dmaif / $bpe;
//: &eperl::flop("-nodeclare   -rval \"${Bnum}'b0\"           -en \"cvt_wr_en | cvt_wr_en_d1\" -d \"cvt_cell_en\"     -q cvt_cell_en_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"                                   -d \"cvt_out_vld\"           -q cvt_out_vld_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"                                   -d \"img2cvt_dat_wr_en\"     -q cvt_out_pad_vld_d1");
//: &eperl::flop("-nodeclare   -rval \"{17{1'b0}}\"  -en \"cvt_wr_en\"          -d \"cvt_out_addr\"          -q cvt_out_addr_d1");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"   -en \"cvt_wr_en\"          -d \"cvt_wr_mask\"           -q cvt_out_nz_mask_d1");
//: &eperl::flop("-nodeclare   -rval \"${Bnum}'b0\"           -en \"img2cvt_dat_wr_en\"  -d \"cvt_wr_pad_mask\"       -q cvt_out_pad_mask_d1");
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//: if($dmaif < $atmc) {
//:     &eperl::flop("-nodeclare   -rval \"${k}'b0\"                                      -d \"cvt_out_reg_en\"        -q cvt_out_reg_en_d1");
//:     &eperl::flop("-nodeclare   -rval \"{2{1'b0}}\"   -en \"cvt_wr_en\"          -d \"cvt_out_sel\"           -q cvt_out_sel_d1");
//: } else {
//:     &eperl::flop("-nodeclare   -rval \"1'b0\"                                      -d \"cvt_out_reg_en\"        -q cvt_out_reg_en_d1");
//: }
////////////////////////////////////////////////////////////////////////
//  generate input signals for convertor cells                        //
////////////////////////////////////////////////////////////////////////
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $Bnum = $dmaif / $bpe;
//: foreach my $i(0..$Bnum-1) {
//:     my $j = $i + 1;
//:     print qq (
//:     assign oprand_0_8b_sign[${i}] = (cvt_wr_data_d1[${j}*${bpe}-1] & ~cvt_wr_uint_d1);
//:     assign oprand_0_${i}_ori = {{(17-${bpe}){oprand_0_8b_sign[${i}]}}, cvt_wr_data_d1[${j}*${bpe}-1:${i}*${bpe}]} ;
//:     assign oprand_1_${i}_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[${j}*16-1:${i}*16] : cfg_offset[15:0];
//:     );
//:     &eperl::flop("-nodeclare -norst -en \"cvt_cell_en_d1[${i}]\" -d \"oprand_0_${i}_ori\" -q oprand_0_${i}_d0");
//:     &eperl::flop("-nodeclare -norst -en \"cvt_cell_en_d1[${i}]\" -d \"oprand_1_${i}_ori\" -q oprand_1_${i}_d0");
//: }
////////////////////////////////////////////////////////////////////////
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $Bnum = ($dmaif / $bpe);
//: &eperl::flop("-nodeclare -rval \"1'b0\"                               -d \"cvt_wr_en_d1\"   -q op_en_d0");
//: &eperl::flop("-nodeclare -rval \"${Bnum}'b0\"  -en \"cvt_wr_en_d1 | op_en_d0\"  -d \"cvt_cell_en_d1\" -q cell_en_d0 ");

////////////////////////////////////////////////////////////////////////
//  instance of convert cells                                         //
////////////////////////////////////////////////////////////////////////
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $Bnum = $dmaif / $bpe;
//: foreach my $i (0..$Bnum-1) {
//:     print qq (
//:         NV_NVDLA_CDMA_CVT_cell u_cell_${i} (
//:           .nvdla_core_clk      (nvdla_hls_clk)         
//:          ,.nvdla_core_rstn     (nvdla_core_rstn)       
//:          ,.chn_data_in_rsc_z   (oprand_0_${i}_d0[16:0])
//:          ,.chn_data_in_rsc_vz  (cell_en_d0[${i}])      
//:           // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
//:          ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[${i}])
//:           // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
//:          ,.chn_alu_in_rsc_z    (oprand_1_${i}_d0[15:0]) 
//:          ,.chn_alu_in_rsc_vz   (cell_en_d0[${i}])       
//:           // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
//:          ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[${i}])
//:           // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
//:          ,.cfg_mul_in_rsc_z    (cfg_scale[15:0])        
//:          ,.cfg_in_precision    (cfg_in_precision[1:0])  
//:          ,.cfg_out_precision   (cfg_proc_precision[1:0])
//:          ,.cfg_truncate        (cfg_truncate[5:0])      
//:          ,.chn_data_out_rsc_z  (cellout_${i}[15:0])     
//:          ,.chn_data_out_rsc_vz (1'b1)                   
//:          ,.chn_data_out_rsc_lz (    )                   
//:          );\n);
//: }
//: print "\n";

assign cvt_data_cell = {
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $Bnum = $dmaif / $bpe;
//: if($Bnum > 1) {
//:     foreach my $i(0..$Bnum-2){
//:         my $j = $Bnum - $i -1;
//:         print qq(cellout_${j}[${bpe}-1:0], );
//:     }
//: }
//: print qq(cellout_0[${bpe}-1:0]};  \n);

////////////////////////////////////////////////////////////////////////
//  stage 2: pipeline to match latency of conver cells                //
////////////////////////////////////////////////////////////////////////
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//: for(my $i = 1; $i <= NVDLA_HLS_CDMA_CVT_LATENCY+1; $i ++) {
//:     my $j = $i + 1;
//:     &eperl::flop("-wid 1   -rval \"1'b0\"        -d \"cvt_out_vld_d${i}\"     -q cvt_out_vld_d${j}");
//:     &eperl::flop("-wid 1   -rval \"1'b0\"        -d \"cvt_out_pad_vld_d${i}\" -q cvt_out_pad_vld_d${j}");
//:     if($dmaif < $atmc) {
//:         &eperl::flop("-wid $k  -rval \"{${k}{1'b0}}\" -en \"cvt_out_vld_d${i}\"                  -d \"cvt_out_sel_d${i}\"      -q cvt_out_sel_d${j}");
//:         &eperl::flop("-wid $k   -rval \"{${k}{1'b0}}\"   -en \"cvt_out_vld_d${i} | cvt_out_vld_d2\" -d \"cvt_out_reg_en_d${i}\"   -q cvt_out_reg_en_d${j}");
//:     } else {
//:         &eperl::flop("-wid $k   -rval \"1'b0\"   -en \"cvt_out_vld_d${i} | cvt_out_vld_d2\" -d \"cvt_out_reg_en_d${i}\"   -q cvt_out_reg_en_d${j}");
//:     }
//:     &eperl::flop("-wid 17  -rval \"{17{1'b0}}\"  -en \"cvt_out_vld_d${i}\"                  -d \"cvt_out_addr_d${i}\"     -q cvt_out_addr_d${j}");
//:     &eperl::flop("-wid 4   -rval \"{4{1'b0}}\"   -en \"cvt_out_vld_d${i}\"                  -d \"cvt_out_nz_mask_d${i}\"  -q cvt_out_nz_mask_d${j}");
//:     &eperl::flop("-wid $Bnum -rval \"{${Bnum}{1'b0}}\" -en \"cvt_out_pad_vld_d${i}\"        -d \"cvt_out_pad_mask_d${i}\" -q cvt_out_pad_mask_d${j}");
//:     print "\n\n";
//: }
//: my $i = NVDLA_HLS_CDMA_CVT_LATENCY+2;
//: if($dmaif < $atmc){
//:     print qq(
//:     assign cvt_out_sel_bp      = cfg_cvt_en[1] ? cvt_out_sel_d${i}     : cvt_out_sel_d1;
//:     );
//: }
//: print qq(
//: assign cvt_out_vld_bp      = cfg_cvt_en[1] ? cvt_out_vld_d${i}      : cvt_out_vld_d1;
//: assign cvt_out_addr_bp     = cfg_cvt_en[1] ? cvt_out_addr_d${i}     : cvt_out_addr_d1;
//: assign cvt_out_nz_mask_bp  = cfg_cvt_en[2] ? cvt_out_nz_mask_d${i}  : cvt_out_nz_mask_d1;
//: assign cvt_out_pad_vld_bp  = cfg_cvt_en[3] ? cvt_out_pad_vld_d${i}  : cvt_out_pad_vld_d1;
//: assign cvt_out_pad_mask_bp = ~cvt_out_pad_vld_bp ? ${Bnum}'b0 : (cfg_cvt_en[3] ? cvt_out_pad_mask_d${i} : cvt_out_pad_mask_d1);
//: assign cvt_out_reg_en_bp   = cfg_cvt_en[4] ? cvt_out_reg_en_d${i}   : cvt_out_reg_en_d1;
//: );

////////////////////////////////////////////////////////////////////////
//  stage 3: final pipeline stage                                    //
////////////////////////////////////////////////////////////////////////
assign cvt_out_data_mix = cfg_cvt_en[5] ? cvt_data_cell : cvt_wr_data_d1;

//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm=NVDLA_MEMORY_ATOMIC_SIZE;
//: my $bpe = NVDLA_BPE;
//: my $atmmbw= $atmm *  $bpe;
//: my $Bnum = $dmaif / $bpe;
//: my $atmm_num= $Bnum / $atmm;
//: for(my $i = 0; $i < $Bnum; $i ++) {
//:     my $b0 = $i * $bpe;
//:     my $b1 = ($i + 1) * $bpe - 1;
//:     print "assign cvt_out_data_masked[${b1}:${b0}] = cvt_out_pad_mask_bp[${i}] ? cfg_pad_value[${bpe}-1:0] : cvt_out_data_mix[${b1}:${b0}]; \n";
//: }
//: foreach my $k (0..$atmm_num -1) {
//:     print qq(assign cvt_out_data_p${k} = cvt_out_nz_mask_bp[${k}] ? cvt_out_data_masked[(${k}+1)*${atmmbw}-1:${k}*${atmmbw}] : 0;  \n);
//:     ##&eperl::flop("-nodeclare   -rval \"${atmmbw}'b0\"  -en \"cvt_out_reg_en_bp == ${k}\" -d \"cvt_out_data_p${k}\" -q cvt_out_data_p${k}_reg");
//:     &eperl::flop("-nodeclare   -rval \"${atmmbw}'b0\"   -d \"cvt_out_data_p${k}\" -q cvt_out_data_p${k}_reg");
//: }

assign cvt_out_vld_reg_w = cvt_out_vld_bp | dat_cbuf_flush_vld_w;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW/NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE;
//: if ( $dmaif < $atmc ) {
//:     my $k = int( log( int($atmc/$dmaif) ) / log(2) );
//:     print "assign cvt_out_addr_reg_w = dat_cbuf_flush_vld_w ? dat_cbuf_flush_idx[17:${k}] : cvt_out_addr_bp; \n";
//: } else {
//:     print "assign cvt_out_addr_reg_w = dat_cbuf_flush_vld_w ? dat_cbuf_flush_idx[16:0] : cvt_out_addr_bp; \n";
//: }

//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $Bnum = $dmaif / $bpe;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE;
//: if($Bnum < $atmc) {
//:     my $dmaif_num = $atmc / $Bnum;
//:     my $k = int(log($dmaif_num)/log(2));
//:     print qq(wire    [$dmaif_num-1:0]    cvt_out_sel_reg_w; \n);
//:     if($dmaif_num == 2) {
//:         print qq(assign cvt_out_sel_reg_w = dat_cbuf_flush_vld_w ? {dat_cbuf_flush_idx[0], ~dat_cbuf_flush_idx[0]} : {cvt_out_sel_bp[0],~cvt_out_sel_bp[0]};  \n);
//:     } elsif($dmaif_num == 4) {
//:         print qq(
//:         assign cvt_out_sel_reg_w = dat_cbuf_flush_vld_w ? {dat_cbuf_flush_idx[1:0]==2'b11, dat_cbuf_flush_idx[1:0]==2'b10, 
//:                                                            dat_cbuf_flush_idx[1:0]==2'b01, dat_cbuf_flush_idx[1:0]==2'b00} : 
//:                                                           {cvt_out_sel_bp[1:0]==2'b11,cvt_out_sel_bp[1:0]==2'b10,
//:                                                            cvt_out_sel_bp[1:0]==2'b01,cvt_out_sel_bp[1:0]==2'b00};
//:         );
//:     }
//:
//:     &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"${dmaif_num}'b0\"  -en \"cvt_out_vld_reg_w\" -d \"cvt_out_sel_reg_w\" -q cvt_out_sel_reg");
//: }
//================  Non-SLCG clock domain ================//
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"1'b0\"   -d \"cvt_out_vld_reg_w\" -q cvt_out_vld_reg");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{17{1'b0}}\"  -en \"cvt_out_vld_reg_w\" -d \"cvt_out_addr_reg_w\" -q cvt_out_addr_reg");

////////////////////////////////////////////////////////////////////////
//  Data buffer flush logic                                           //
////////////////////////////////////////////////////////////////////////

assign {mon_dat_cbuf_flush_idx_w,
        dat_cbuf_flush_idx_w} = dat_cbuf_flush_idx + 1'b1;
//: my $bank_entry = NVDLA_CBUF_BANK_NUMBER * NVDLA_CBUF_BANK_DEPTH;
//: my $bank_entry_bw = int( log( $bank_entry)/log(2) );
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: my $k;
//: if($dmaif < $atmc) {
//:     $k = int(log(int($atmc/$dmaif))/log(2));
//: } else {
//:     $k = 0;
//: }
//: print qq(
//:     assign dat_cbuf_flush_vld_w = ~dat_cbuf_flush_idx[${bank_entry_bw}+$k-1];//max value = half bank entry * 2^$k
//:     assign dp2reg_dat_flush_done = dat_cbuf_flush_idx[${bank_entry_bw}+$k-1];
//: );

//assign dat_cbuf_flush_vld_w = ~dat_cbuf_flush_idx[17];
//assign dp2reg_dat_flush_done = dat_cbuf_flush_idx[17];

//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{18{1'b0}}\"  -en \"dat_cbuf_flush_vld_w\" -d \"dat_cbuf_flush_idx_w\" -q dat_cbuf_flush_idx");

//================  Non-SLCG clock domain end ================//

////////////////////////////////////////////////////////////////////////
//  output ports                                                      //
////////////////////////////////////////////////////////////////////////
assign cdma2buf_dat_wr_en = cvt_out_vld_reg;
assign cdma2buf_dat_wr_addr = cvt_out_addr_reg;
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $bpe = NVDLA_BPE;
//: my $Bnum = $dmaif / $bpe;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE;
//: if($Bnum < $atmc) {
//:     print qq(assign cdma2buf_dat_wr_sel = cvt_out_sel_reg; \n );
//: }

assign cdma2buf_dat_wr_data = {
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm=NVDLA_MEMORY_ATOMIC_SIZE;
//: my $bpe = NVDLA_BPE;
//: my $Bnum = $dmaif / $bpe;
//: my $atmm_num= $Bnum / $atmm;
//: if($atmm_num > 1){
//:     foreach my $i(0..$atmm_num -2) {
//:         my $j = $atmm_num - $i -1;
//:         print "cvt_out_data_p${j}_reg, ";
//:     }
//: }
 cvt_out_data_p0_reg};

#ifndef NVDLA_FEATURE_DATA_TYPE_INT8
////////////////////////////////////////////////////////////////////////
//  Infinity and NaN counting logic                                   //
////////////////////////////////////////////////////////////////////////
//: my $i;
//: my $b0;
//: my $b1;
//: for($i = 0; $i < 32; $i ++) {
//:     $b0 = 16 * $i + 10;
//:     $b1 = 16 * $i + 14;
//:     print "assign dat_fp16_exp_flag_w[$i] = (&cvt_wr_data[${b1}:${b0}]);\n";
//: }
//: print "\n\n";
//: 
//: for($i = 0; $i < 32; $i ++) {
//:     $b0 = 16 * $i;
//:     $b1 = 16 * $i + 9;
//:     print "assign dat_fp16_manti_flag_w[$i] = (|cvt_wr_data[${b1}:${b0}]);\n";
//: }
//: print "\n\n";


assign dat_fp16_nan_flag_w = (dat_fp16_exp_flag_w & dat_fp16_manti_flag_w & {{16{cvt_wr_mask[1]}}, {16{cvt_wr_mask[0]}}});
assign dat_fp16_inf_flag_w = (dat_fp16_exp_flag_w & ~dat_fp16_manti_flag_w & {{16{cvt_wr_mask[1]}}, {16{cvt_wr_mask[0]}}});

//: my $i;
//: my $b0;
//: my $b1;
//: for($i = 0; $i < 32; $i ++) {
//:     $b0 = 16 * $i;
//:     $b1 = 16 * $i + 15;
//:     print "assign dat_nan_mask[${b1}:${b0}] = {16{~dat_fp16_nan_flag_w[${i}]}};\n";
//: }
//: print "\n\n";

assign dat_fp16_nan_vld_w = cvt_wr_en & (|dat_fp16_nan_flag_w) & reg2dp_op_en & is_input_fp16;
assign dat_fp16_inf_vld_w = cvt_wr_en & (|dat_fp16_inf_flag_w) & reg2dp_op_en & is_input_fp16;

assign dat_half_mask = {{16{cvt_wr_mask[1]}}, {16{cvt_wr_mask[0]}}};

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dat_fp16_nan_vld_w\" -q dat_fp16_nan_vld");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dat_fp16_inf_vld_w\" -q dat_fp16_inf_vld");
//: &eperl::flop("-nodeclare  -norst -en \"dat_fp16_nan_vld_w\" -d \"dat_fp16_nan_flag_w & dat_half_mask\" -q dat_fp16_nan_flag");
//: &eperl::flop("-nodeclare  -norst -en \"dat_fp16_inf_vld_w\" -d \"dat_fp16_inf_flag_w & dat_half_mask\" -q dat_fp16_inf_flag");

/////////////////// ///////////////////

assign dat_fp16_nan_sum = dat_fp16_nan_flag[31] + dat_fp16_nan_flag[30] + dat_fp16_nan_flag[29] + dat_fp16_nan_flag[28] + dat_fp16_nan_flag[27] + dat_fp16_nan_flag[26] + dat_fp16_nan_flag[25] + dat_fp16_nan_flag[24] +
                          dat_fp16_nan_flag[23] + dat_fp16_nan_flag[22] + dat_fp16_nan_flag[21] + dat_fp16_nan_flag[20] + dat_fp16_nan_flag[19] + dat_fp16_nan_flag[18] + dat_fp16_nan_flag[17] + dat_fp16_nan_flag[16] +
                          dat_fp16_nan_flag[15] + dat_fp16_nan_flag[14] + dat_fp16_nan_flag[13] + dat_fp16_nan_flag[12] + dat_fp16_nan_flag[11] + dat_fp16_nan_flag[10] + dat_fp16_nan_flag[9] + dat_fp16_nan_flag[8] +
                          dat_fp16_nan_flag[7] + dat_fp16_nan_flag[6] + dat_fp16_nan_flag[5] + dat_fp16_nan_flag[4] + dat_fp16_nan_flag[3] + dat_fp16_nan_flag[2] + dat_fp16_nan_flag[1] + dat_fp16_nan_flag[0];

assign dat_fp16_inf_sum = dat_fp16_inf_flag[31] + dat_fp16_inf_flag[30] + dat_fp16_inf_flag[29] + dat_fp16_inf_flag[28] + dat_fp16_inf_flag[27] + dat_fp16_inf_flag[26] + dat_fp16_inf_flag[25] + dat_fp16_inf_flag[24] +
                          dat_fp16_inf_flag[23] + dat_fp16_inf_flag[22] + dat_fp16_inf_flag[21] + dat_fp16_inf_flag[20] + dat_fp16_inf_flag[19] + dat_fp16_inf_flag[18] + dat_fp16_inf_flag[17] + dat_fp16_inf_flag[16] +
                          dat_fp16_inf_flag[15] + dat_fp16_inf_flag[14] + dat_fp16_inf_flag[13] + dat_fp16_inf_flag[12] + dat_fp16_inf_flag[11] + dat_fp16_inf_flag[10] + dat_fp16_inf_flag[9] + dat_fp16_inf_flag[8] +
                          dat_fp16_inf_flag[7] + dat_fp16_inf_flag[6] + dat_fp16_inf_flag[5] + dat_fp16_inf_flag[4] + dat_fp16_inf_flag[3] + dat_fp16_inf_flag[2] + dat_fp16_inf_flag[1] + dat_fp16_inf_flag[0];


assign {nan_carry,
        dp2reg_nan_data_num_inc} = dp2reg_nan_data_num + dat_fp16_nan_sum;
assign dp2reg_nan_data_num_w = cfg_reg_en ? 32'b0 :
                               nan_carry ? ~(32'b0) :
                               dp2reg_nan_data_num_inc;
assign nan_reg_en = cfg_reg_en | (dat_fp16_nan_vld & (|dat_fp16_nan_sum));
assign {inf_carry,
        dp2reg_inf_data_num_inc} = dp2reg_inf_data_num + dat_fp16_inf_sum;
assign dp2reg_inf_data_num_w = cfg_reg_en ? 32'b0 :
                               inf_carry ? ~(32'b0) :
                               dp2reg_inf_data_num_inc;
assign inf_reg_en = cfg_reg_en | (dat_fp16_inf_vld & (|dat_fp16_inf_sum));

//: &eperl::flop("-nodeclare   -rval \"{32{1'b0}}\"  -en \"nan_reg_en\" -d \"dp2reg_nan_data_num_w\" -q dp2reg_nan_data_num");
//: &eperl::flop("-nodeclare   -rval \"{32{1'b0}}\"  -en \"inf_reg_en\" -d \"dp2reg_inf_data_num_w\" -q dp2reg_inf_data_num");
#else
assign dat_nan_mask = {NVDLA_CDMA_DMAIF_BW{1'b1}};
assign dp2reg_nan_data_num = 32'b0;
assign dp2reg_inf_data_num = 32'b0;
#endif


////////////////////////////////////////////////////////////////////////
//  Assertion                                                         //
////////////////////////////////////////////////////////////////////////
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

  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_47x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_49x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en | cvt_wr_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_50x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_51x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_52x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_55x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_56x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(img2cvt_dat_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_57x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_58x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_59x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en_d1 | op_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_63x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_65x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_pad_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1 | cvt_out_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_70x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_72x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_73x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_pad_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_74x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2 | cvt_out_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_79x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_80x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_pad_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_81x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3 | cvt_out_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_82x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_83x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_84x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_86x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_pad_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_88x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4 | cvt_out_vld_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_89x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_90x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_91x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[1]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_92x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_93x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[3]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_94x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[4]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_95x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[5]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[6]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_97x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[7]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_98x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_reg_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_99x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_reg_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_101x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(dat_cbuf_flush_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_102x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(nan_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_103x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(inf_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 

#ifdef NVDLA_WINOGRAD_ENABLE
  nv_assert_zero_one_hot #(0,3,0,"Error! CVT input conflict!")      zzz_assert_zero_one_hot_16x (nvdla_core_clk, `ASSERT_RESET, {dc2cvt_dat_wr_en, wg2cvt_dat_wr_en, img2cvt_dat_wr_en}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Wg set two high masks")      zzz_assert_never_19x (nvdla_core_clk, `ASSERT_RESET, (wg2cvt_dat_wr_en & (|cvt_wr_mask[3:2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Wg set mean flag")      zzz_assert_never_22x (nvdla_core_clk, `ASSERT_RESET, (wg2cvt_dat_wr_en & cvt_wr_mean)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Wg set uint flag")      zzz_assert_never_24x (nvdla_core_clk, `ASSERT_RESET, (wg2cvt_dat_wr_en & cvt_wr_uint)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Wg set sub h flag")      zzz_assert_never_26x (nvdla_core_clk, `ASSERT_RESET, (wg2cvt_dat_wr_en & (|cvt_wr_sub_h))); // spyglass disable W504 SelfDeterminedExpr-ML 
#else
  nv_assert_zero_one_hot #(0,2,0,"Error! CVT input conflict!")      zzz_assert_zero_one_hot_16x (nvdla_core_clk, `ASSERT_RESET, {dc2cvt_dat_wr_en, img2cvt_dat_wr_en}); // spyglass disable W504 SelfDeterminedExpr-ML 
#endif
  nv_assert_never #(0,0,"Error! Disable when input data")      zzz_assert_never_17x (nvdla_core_clk, `ASSERT_RESET, (~op_en & cvt_wr_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Dc set two high masks")      zzz_assert_never_18x (nvdla_core_clk, `ASSERT_RESET, (dc2cvt_dat_wr_en & (|cvt_wr_mask[3:2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Img set two hight masks when int8 input")      zzz_assert_never_20x (nvdla_core_clk, `ASSERT_RESET, (img2cvt_dat_wr_en & (|cvt_wr_mask[3:2]) & is_input_int8[0])); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Dc set mean flag")      zzz_assert_never_21x (nvdla_core_clk, `ASSERT_RESET, (dc2cvt_dat_wr_en & cvt_wr_mean)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Dc set uint flag")      zzz_assert_never_23x (nvdla_core_clk, `ASSERT_RESET, (dc2cvt_dat_wr_en & cvt_wr_uint)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Dc set sub h flag")      zzz_assert_never_25x (nvdla_core_clk, `ASSERT_RESET, (dc2cvt_dat_wr_en & (|cvt_wr_sub_h))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Input data mask error!")      zzz_assert_never_27x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & (cvt_wr_mask != 4'h1) & (cvt_wr_mask != 4'h3) & (cvt_wr_mask != 4'hf))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Input data high mask set when input int8!")      zzz_assert_never_28x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_mask[3] & cfg_in_int8)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Expand when 16bit input!")      zzz_assert_never_32x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & ~cfg_in_int8 & is_data_expand)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Expand out of range when sel set!")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & cvt_wr_sel & is_data_expand & cvt_wr_mask[1])); // spyglass disable W504 SelfDeterminedExpr-ML 
  //nv_assert_never #(0,0,"Error! Half mask without output!")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & ~cvt_wr_ext64 & ~cvt_wr_ext128 & ~cvt_wr_mask[1])); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Half mask without output!")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en &  ~cvt_wr_mask[1])); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! cvt mode is not enable when format change!")      zzz_assert_never_40x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & ~cfg_cvt_en[0] & (cfg_in_precision[1:0] != cfg_proc_precision[1:0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! invalid precision transform!")      zzz_assert_never_41x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & (cfg_in_precision[1:0] == 2'h2 ) & (cfg_proc_precision[1:0] != 2'h2 ))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! cell op0 is not ready when input valid!")      zzz_assert_never_60x (nvdla_core_clk, `ASSERT_RESET, ((|(cell_en_d0 & ~mon_cell_op0_ready)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! cell op1 is not ready when input valid!")      zzz_assert_never_61x (nvdla_core_clk, `ASSERT_RESET, ((|(cell_en_d0 & ~mon_cell_op1_ready)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! CVT and flush write hazard!")      zzz_assert_never_100x (nvdla_core_ng_clk, `ASSERT_RESET, (cvt_out_vld_bp & dat_cbuf_flush_vld_w)); // spyglass disable W504 SelfDeterminedExpr-ML 

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

endmodule // NV_NVDLA_CDMA_cvt


