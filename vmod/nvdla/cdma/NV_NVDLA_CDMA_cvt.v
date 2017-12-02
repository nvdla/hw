// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_cvt.v

module NV_NVDLA_CDMA_cvt (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,dc2cvt_dat_wr_en        //|< i
  ,dc2cvt_dat_wr_addr      //|< i
  ,dc2cvt_dat_wr_hsel      //|< i
  ,dc2cvt_dat_wr_data      //|< i
  ,wg2cvt_dat_wr_en        //|< i
  ,wg2cvt_dat_wr_addr      //|< i
  ,wg2cvt_dat_wr_hsel      //|< i
  ,wg2cvt_dat_wr_data      //|< i
  ,img2cvt_dat_wr_en       //|< i
  ,img2cvt_dat_wr_addr     //|< i
  ,img2cvt_dat_wr_hsel     //|< i
  ,img2cvt_dat_wr_data     //|< i
  ,img2cvt_mn_wr_data      //|< i
  ,dc2cvt_dat_wr_info_pd   //|< i
  ,wg2cvt_dat_wr_info_pd   //|< i
  ,img2cvt_dat_wr_info_pd  //|< i
  ,cdma2buf_dat_wr_en      //|> o
  ,cdma2buf_dat_wr_addr    //|> o
  ,cdma2buf_dat_wr_hsel    //|> o
  ,cdma2buf_dat_wr_data    //|> o
  ,nvdla_hls_clk           //|< i
  ,slcg_hls_en             //|> o
  ,nvdla_core_ng_clk       //|< i
  ,reg2dp_op_en            //|< i
  ,reg2dp_in_precision     //|< i
  ,reg2dp_proc_precision   //|< i
  ,reg2dp_cvt_en           //|< i
  ,reg2dp_cvt_truncate     //|< i
  ,reg2dp_cvt_offset       //|< i
  ,reg2dp_cvt_scale        //|< i
  ,reg2dp_nan_to_zero      //|< i
  ,reg2dp_pad_value        //|< i
  ,dp2reg_done             //|< i
  ,img2cvt_dat_wr_pad_mask //|< i
  ,dp2reg_nan_data_num     //|> o
  ,dp2reg_inf_data_num     //|> o
  ,dp2reg_dat_flush_done   //|> o
  );


//
// NV_NVDLA_CDMA_cvt_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         dc2cvt_dat_wr_en;    /* data valid */
input  [11:0] dc2cvt_dat_wr_addr;
input         dc2cvt_dat_wr_hsel;
input [511:0] dc2cvt_dat_wr_data;

input         wg2cvt_dat_wr_en;    /* data valid */
input  [11:0] wg2cvt_dat_wr_addr;
input         wg2cvt_dat_wr_hsel;
input [511:0] wg2cvt_dat_wr_data;

input          img2cvt_dat_wr_en;    /* data valid */
input   [11:0] img2cvt_dat_wr_addr;
input          img2cvt_dat_wr_hsel;
input [1023:0] img2cvt_dat_wr_data;

input [1023:0] img2cvt_mn_wr_data;

input [11:0] dc2cvt_dat_wr_info_pd;

input [11:0] wg2cvt_dat_wr_info_pd;

input [11:0] img2cvt_dat_wr_info_pd;

output          cdma2buf_dat_wr_en;    /* data valid */
output   [11:0] cdma2buf_dat_wr_addr;
output    [1:0] cdma2buf_dat_wr_hsel;
output [1023:0] cdma2buf_dat_wr_data;

input   nvdla_hls_clk;
output  slcg_hls_en;

input   nvdla_core_ng_clk;

input   [0:0]                   reg2dp_op_en;
input   [1:0]             reg2dp_in_precision;
input   [1:0]           reg2dp_proc_precision;
input   [0:0]                    reg2dp_cvt_en;
input   [5:0]              reg2dp_cvt_truncate;
input   [15:0]             reg2dp_cvt_offset;
input   [15:0]               reg2dp_cvt_scale;
input   [0:0]     reg2dp_nan_to_zero;
input   [15:0]      reg2dp_pad_value;
input                                                               dp2reg_done;
input   [127:0] img2cvt_dat_wr_pad_mask;

output  [31:0]   dp2reg_nan_data_num;
output  [31:0]   dp2reg_inf_data_num;
output                                                              dp2reg_dat_flush_done;

wire     [15:0] cellout_0;
wire     [15:0] cellout_1;
wire     [15:0] cellout_10;
wire     [15:0] cellout_11;
wire     [15:0] cellout_12;
wire     [15:0] cellout_13;
wire     [15:0] cellout_14;
wire     [15:0] cellout_15;
wire     [15:0] cellout_16;
wire     [15:0] cellout_17;
wire     [15:0] cellout_18;
wire     [15:0] cellout_19;
wire     [15:0] cellout_2;
wire     [15:0] cellout_20;
wire     [15:0] cellout_21;
wire     [15:0] cellout_22;
wire     [15:0] cellout_23;
wire     [15:0] cellout_24;
wire     [15:0] cellout_25;
wire     [15:0] cellout_26;
wire     [15:0] cellout_27;
wire     [15:0] cellout_28;
wire     [15:0] cellout_29;
wire     [15:0] cellout_3;
wire     [15:0] cellout_30;
wire     [15:0] cellout_31;
wire     [15:0] cellout_32;
wire     [15:0] cellout_33;
wire     [15:0] cellout_34;
wire     [15:0] cellout_35;
wire     [15:0] cellout_36;
wire     [15:0] cellout_37;
wire     [15:0] cellout_38;
wire     [15:0] cellout_39;
wire     [15:0] cellout_4;
wire     [15:0] cellout_40;
wire     [15:0] cellout_41;
wire     [15:0] cellout_42;
wire     [15:0] cellout_43;
wire     [15:0] cellout_44;
wire     [15:0] cellout_45;
wire     [15:0] cellout_46;
wire     [15:0] cellout_47;
wire     [15:0] cellout_48;
wire     [15:0] cellout_49;
wire     [15:0] cellout_5;
wire     [15:0] cellout_50;
wire     [15:0] cellout_51;
wire     [15:0] cellout_52;
wire     [15:0] cellout_53;
wire     [15:0] cellout_54;
wire     [15:0] cellout_55;
wire     [15:0] cellout_56;
wire     [15:0] cellout_57;
wire     [15:0] cellout_58;
wire     [15:0] cellout_59;
wire     [15:0] cellout_6;
wire     [15:0] cellout_60;
wire     [15:0] cellout_61;
wire     [15:0] cellout_62;
wire     [15:0] cellout_63;
wire     [15:0] cellout_7;
wire     [15:0] cellout_8;
wire     [15:0] cellout_9;
wire            cvt_bypass_sel_half;
wire     [63:0] cvt_cell_en;
wire            cvt_cell_in_sel_half;
wire            cvt_cell_in_sel_interval;
wire            cvt_cell_out_sel_hold;
wire            cvt_cell_out_sel_hold_bp;
wire    [511:0] cvt_data_bypass_hi;
wire    [511:0] cvt_data_bypass_lo;
wire   [1023:0] cvt_data_cell_out;
wire    [255:0] cvt_data_cell_sel0_hi;
wire    [255:0] cvt_data_cell_sel0_lo;
wire            cvt_half_en;
wire            cvt_hold_en;
wire            cvt_hold_en_bp;
wire      [7:0] cvt_line_idx_bp;
wire     [11:0] cvt_out_addr;
wire     [11:0] cvt_out_addr_bp;
wire   [1023:0] cvt_out_data_mix;
wire    [127:0] cvt_out_data_p0;
wire    [127:0] cvt_out_data_p1;
wire    [127:0] cvt_out_data_p2;
wire    [127:0] cvt_out_data_p3;
wire    [127:0] cvt_out_data_p4;
wire    [127:0] cvt_out_data_p5;
wire    [127:0] cvt_out_data_p6;
wire    [127:0] cvt_out_data_p7;
wire      [1:0] cvt_out_hsel;
wire      [1:0] cvt_out_hsel_bp;
wire      [7:0] cvt_out_nz_mask;
wire      [7:0] cvt_out_nz_mask_bp;
wire    [127:0] cvt_out_pad_mask;
wire    [127:0] cvt_out_pad_mask_bp;
wire            cvt_out_pad_vld;
wire            cvt_out_pad_vld_bp;
wire      [7:0] cvt_out_reg_en;
wire      [7:0] cvt_out_reg_en_bp;
wire            cvt_out_single_hsel;
wire            cvt_out_vld;
wire            cvt_out_vld_bp;
wire    [127:0] cvt_sel_pad_mask;
wire      [7:0] cvt_transform_mask;
wire            cvt_wr_ext128;
wire            cvt_wr_ext64;
wire            cvt_wr_interleave;
wire      [3:0] cvt_wr_mask;
wire            cvt_wr_mean;
wire   [1023:0] cvt_wr_mean_data;
wire      [2:0] cvt_wr_sub_h;
wire            cvt_wr_uint;
wire     [63:0] mon_cell_op0_ready;
wire     [63:0] mon_cell_op1_ready;
wire    [271:0] oprand_0_q0;
wire    [271:0] oprand_0_q1;
wire    [271:0] oprand_0_q2;
wire    [271:0] oprand_0_q3;
wire    [255:0] oprand_1_q0;
wire    [255:0] oprand_1_q1;
wire    [255:0] oprand_1_q2;
wire    [255:0] oprand_1_q3;
wire            slcg_hls_en_w;
reg      [63:0] cell_en_d0;
reg       [5:0] cfg_cvt_en;
reg             cfg_in_int8;
reg      [31:0] cfg_in_precision;
reg       [1:0] cfg_in_precision_0;
reg       [1:0] cfg_in_precision_1;
reg       [1:0] cfg_in_precision_10;
reg       [1:0] cfg_in_precision_11;
reg       [1:0] cfg_in_precision_12;
reg       [1:0] cfg_in_precision_13;
reg       [1:0] cfg_in_precision_14;
reg       [1:0] cfg_in_precision_15;
reg       [1:0] cfg_in_precision_2;
reg       [1:0] cfg_in_precision_3;
reg       [1:0] cfg_in_precision_4;
reg       [1:0] cfg_in_precision_5;
reg       [1:0] cfg_in_precision_6;
reg       [1:0] cfg_in_precision_7;
reg       [1:0] cfg_in_precision_8;
reg       [1:0] cfg_in_precision_9;
reg    [1023:0] cfg_offset;
reg             cfg_out_int8;
reg    [1023:0] cfg_pad_value;
reg    [1023:0] cfg_pad_value_w;
reg      [31:0] cfg_proc_precision;
reg       [1:0] cfg_proc_precision_0;
reg       [1:0] cfg_proc_precision_1;
reg       [1:0] cfg_proc_precision_10;
reg       [1:0] cfg_proc_precision_11;
reg       [1:0] cfg_proc_precision_12;
reg       [1:0] cfg_proc_precision_13;
reg       [1:0] cfg_proc_precision_14;
reg       [1:0] cfg_proc_precision_15;
reg       [1:0] cfg_proc_precision_2;
reg       [1:0] cfg_proc_precision_3;
reg       [1:0] cfg_proc_precision_4;
reg       [1:0] cfg_proc_precision_5;
reg       [1:0] cfg_proc_precision_6;
reg       [1:0] cfg_proc_precision_7;
reg       [1:0] cfg_proc_precision_8;
reg       [1:0] cfg_proc_precision_9;
reg             cfg_reg_en;
reg     [255:0] cfg_scale;
reg      [15:0] cfg_scale_0;
reg      [15:0] cfg_scale_1;
reg      [15:0] cfg_scale_10;
reg      [15:0] cfg_scale_11;
reg      [15:0] cfg_scale_12;
reg      [15:0] cfg_scale_13;
reg      [15:0] cfg_scale_14;
reg      [15:0] cfg_scale_15;
reg      [15:0] cfg_scale_2;
reg      [15:0] cfg_scale_3;
reg      [15:0] cfg_scale_4;
reg      [15:0] cfg_scale_5;
reg      [15:0] cfg_scale_6;
reg      [15:0] cfg_scale_7;
reg      [15:0] cfg_scale_8;
reg      [15:0] cfg_scale_9;
reg      [95:0] cfg_truncate;
reg       [5:0] cfg_truncate_0;
reg       [5:0] cfg_truncate_1;
reg       [5:0] cfg_truncate_10;
reg       [5:0] cfg_truncate_11;
reg       [5:0] cfg_truncate_12;
reg       [5:0] cfg_truncate_13;
reg       [5:0] cfg_truncate_14;
reg       [5:0] cfg_truncate_15;
reg       [5:0] cfg_truncate_2;
reg       [5:0] cfg_truncate_3;
reg       [5:0] cfg_truncate_4;
reg       [5:0] cfg_truncate_5;
reg       [5:0] cfg_truncate_6;
reg       [5:0] cfg_truncate_7;
reg       [5:0] cfg_truncate_8;
reg       [5:0] cfg_truncate_9;
reg             cvt_bypass_sel_half_d1;
reg      [63:0] cvt_cell_en_d1;
reg       [3:0] cvt_cell_in_sel_half_d1;
reg       [1:0] cvt_cell_in_sel_interval_d1;
reg             cvt_cell_out_sel_hold_d1;
reg             cvt_cell_out_sel_hold_d2;
reg             cvt_cell_out_sel_hold_d3;
reg             cvt_cell_out_sel_hold_d4;
reg             cvt_cell_out_sel_hold_d5;
reg             cvt_cur_hold;
reg      [11:0] cvt_cur_hold_addr;
reg             cvt_cur_hold_hsel;
reg    [1023:0] cvt_data_cell_16b;
reg     [511:0] cvt_data_cell_8b;
reg     [255:0] cvt_data_cell_8b_masked;
reg             cvt_half_hold;
reg             cvt_half_mode;
reg             cvt_half_rls;
reg      [11:0] cvt_hold_addr_0;
reg      [11:0] cvt_hold_addr_1;
reg      [11:0] cvt_hold_addr_2;
reg      [11:0] cvt_hold_addr_3;
reg      [11:0] cvt_hold_addr_4;
reg      [11:0] cvt_hold_addr_5;
reg      [11:0] cvt_hold_addr_6;
reg      [11:0] cvt_hold_addr_7;
reg     [255:0] cvt_hold_data;
reg     [255:0] cvt_hold_data_0;
reg     [255:0] cvt_hold_data_1;
reg     [255:0] cvt_hold_data_2;
reg     [255:0] cvt_hold_data_3;
reg     [255:0] cvt_hold_data_4;
reg     [255:0] cvt_hold_data_5;
reg     [255:0] cvt_hold_data_6;
reg     [255:0] cvt_hold_data_7;
reg             cvt_hold_en_d1;
reg             cvt_hold_en_d2;
reg             cvt_hold_en_d3;
reg             cvt_hold_en_d4;
reg             cvt_hold_en_d5;
reg             cvt_hold_hsel_0;
reg             cvt_hold_hsel_1;
reg             cvt_hold_hsel_2;
reg             cvt_hold_hsel_3;
reg             cvt_hold_hsel_4;
reg             cvt_hold_hsel_5;
reg             cvt_hold_hsel_6;
reg             cvt_hold_hsel_7;
reg       [7:0] cvt_hold_reg_en;
reg       [7:0] cvt_hold_tag;
reg       [7:0] cvt_hold_tag_w;
reg       [7:0] cvt_line_idx;
reg       [7:0] cvt_line_idx_d1;
reg       [7:0] cvt_line_idx_d2;
reg       [7:0] cvt_line_idx_d3;
reg       [7:0] cvt_line_idx_d4;
reg       [7:0] cvt_line_idx_d5;
reg      [11:0] cvt_out_addr_d1;
reg      [11:0] cvt_out_addr_d2;
reg      [11:0] cvt_out_addr_d3;
reg      [11:0] cvt_out_addr_d4;
reg      [11:0] cvt_out_addr_d5;
reg      [11:0] cvt_out_addr_reg;
reg      [11:0] cvt_out_addr_reg_w;
reg    [1023:0] cvt_out_data_masked;
reg     [127:0] cvt_out_data_p0_reg;
reg     [127:0] cvt_out_data_p1_reg;
reg     [127:0] cvt_out_data_p2_reg;
reg     [127:0] cvt_out_data_p3_reg;
reg     [127:0] cvt_out_data_p4_reg;
reg     [127:0] cvt_out_data_p5_reg;
reg     [127:0] cvt_out_data_p6_reg;
reg     [127:0] cvt_out_data_p7_reg;
reg       [1:0] cvt_out_hsel_d1;
reg       [1:0] cvt_out_hsel_d2;
reg       [1:0] cvt_out_hsel_d3;
reg       [1:0] cvt_out_hsel_d4;
reg       [1:0] cvt_out_hsel_d5;
reg       [1:0] cvt_out_hsel_reg;
reg       [1:0] cvt_out_hsel_reg_w;
reg       [7:0] cvt_out_nz_mask_d1;
reg       [7:0] cvt_out_nz_mask_d2;
reg       [7:0] cvt_out_nz_mask_d3;
reg       [7:0] cvt_out_nz_mask_d4;
reg       [7:0] cvt_out_nz_mask_d5;
reg     [127:0] cvt_out_pad_mask_d1;
reg     [127:0] cvt_out_pad_mask_d2;
reg     [127:0] cvt_out_pad_mask_d3;
reg     [127:0] cvt_out_pad_mask_d4;
reg     [127:0] cvt_out_pad_mask_d5;
reg             cvt_out_pad_vld_d1;
reg             cvt_out_pad_vld_d2;
reg             cvt_out_pad_vld_d3;
reg             cvt_out_pad_vld_d4;
reg             cvt_out_pad_vld_d5;
reg       [7:0] cvt_out_reg_en_d1;
reg       [7:0] cvt_out_reg_en_d2;
reg       [7:0] cvt_out_reg_en_d3;
reg       [7:0] cvt_out_reg_en_d4;
reg       [7:0] cvt_out_reg_en_d5;
reg             cvt_out_vld_d1;
reg             cvt_out_vld_d2;
reg             cvt_out_vld_d3;
reg             cvt_out_vld_d4;
reg             cvt_out_vld_d5;
reg             cvt_out_vld_reg;
reg             cvt_out_vld_reg_w;
reg      [11:0] cvt_wr_addr;
reg    [1023:0] cvt_wr_data;
reg    [1023:0] cvt_wr_data_d1;
reg     [511:0] cvt_wr_data_hi;
reg     [511:0] cvt_wr_data_lo;
reg    [1023:0] cvt_wr_data_ori;
reg     [511:0] cvt_wr_data_ori_hi;
reg     [511:0] cvt_wr_data_ori_lo;
reg             cvt_wr_en;
reg             cvt_wr_en_d1;
reg     [511:0] cvt_wr_half_data;
reg             cvt_wr_hsel;
reg      [11:0] cvt_wr_info_pd;
reg             cvt_wr_mean_d1;
reg    [1023:0] cvt_wr_mean_data_d1;
reg     [127:0] cvt_wr_pad_mask;
reg     [127:0] cvt_wr_pad_mask_expand;
reg     [127:0] cvt_wr_pad_mask_srink;
reg             cvt_wr_pad_mask_vld;
reg      [63:0] cvt_wr_uint_d1;
reg      [12:0] dat_cbuf_flush_idx;
reg      [12:0] dat_cbuf_flush_idx_w;
reg             dat_cbuf_flush_vld_w;
reg      [31:0] dat_fp16_exp_flag_w;
reg      [31:0] dat_fp16_inf_flag;
reg      [31:0] dat_fp16_inf_flag_w;
reg       [5:0] dat_fp16_inf_sum;
reg             dat_fp16_inf_vld;
reg             dat_fp16_inf_vld_w;
reg      [31:0] dat_fp16_manti_flag_w;
reg      [31:0] dat_fp16_nan_flag;
reg      [31:0] dat_fp16_nan_flag_w;
reg       [5:0] dat_fp16_nan_sum;
reg             dat_fp16_nan_vld;
reg             dat_fp16_nan_vld_w;
reg      [31:0] dat_half_mask;
reg     [511:0] dat_nan_mask;
reg      [31:0] dp2reg_inf_data_num;
reg      [31:0] dp2reg_inf_data_num_inc;
reg      [31:0] dp2reg_inf_data_num_w;
reg      [31:0] dp2reg_nan_data_num;
reg      [31:0] dp2reg_nan_data_num_inc;
reg      [31:0] dp2reg_nan_data_num_w;
reg             inf_carry;
reg             inf_reg_en;
reg             is_data_expand;
reg             is_data_expand_w;
reg             is_data_normal;
reg             is_data_normal_w;
reg             is_data_shrink;
reg             is_data_shrink_w;
reg             is_input_fp16;
reg             is_input_fp16_w;
reg      [63:0] is_input_int8;
reg             is_input_int8_w;
reg             is_output_int8_w;
reg             mon_dat_cbuf_flush_idx_w;
reg             nan_carry;
reg             nan_pass;
reg             nan_pass_w;
reg             nan_reg_en;
reg             op_en;
reg             op_en_d0;
reg             op_en_w;
reg      [16:0] oprand_0_0;
reg      [16:0] oprand_0_0_d0;
reg      [16:0] oprand_0_0_ori;
reg      [16:0] oprand_0_1;
reg      [16:0] oprand_0_10;
reg      [16:0] oprand_0_10_d0;
reg      [16:0] oprand_0_10_ori;
reg      [16:0] oprand_0_11;
reg      [16:0] oprand_0_11_d0;
reg      [16:0] oprand_0_11_ori;
reg      [16:0] oprand_0_12;
reg      [16:0] oprand_0_12_d0;
reg      [16:0] oprand_0_12_ori;
reg      [16:0] oprand_0_13;
reg      [16:0] oprand_0_13_d0;
reg      [16:0] oprand_0_13_ori;
reg      [16:0] oprand_0_14;
reg      [16:0] oprand_0_14_d0;
reg      [16:0] oprand_0_14_ori;
reg      [16:0] oprand_0_15;
reg      [16:0] oprand_0_15_d0;
reg      [16:0] oprand_0_15_ori;
reg      [16:0] oprand_0_16;
reg      [16:0] oprand_0_16_d0;
reg      [16:0] oprand_0_16_ori;
reg      [63:0] oprand_0_16b_sign;
reg      [16:0] oprand_0_17;
reg      [16:0] oprand_0_17_d0;
reg      [16:0] oprand_0_17_ori;
reg      [16:0] oprand_0_18;
reg      [16:0] oprand_0_18_d0;
reg      [16:0] oprand_0_18_ori;
reg      [16:0] oprand_0_19;
reg      [16:0] oprand_0_19_d0;
reg      [16:0] oprand_0_19_ori;
reg      [16:0] oprand_0_1_d0;
reg      [16:0] oprand_0_1_ori;
reg      [16:0] oprand_0_2;
reg      [16:0] oprand_0_20;
reg      [16:0] oprand_0_20_d0;
reg      [16:0] oprand_0_20_ori;
reg      [16:0] oprand_0_21;
reg      [16:0] oprand_0_21_d0;
reg      [16:0] oprand_0_21_ori;
reg      [16:0] oprand_0_22;
reg      [16:0] oprand_0_22_d0;
reg      [16:0] oprand_0_22_ori;
reg      [16:0] oprand_0_23;
reg      [16:0] oprand_0_23_d0;
reg      [16:0] oprand_0_23_ori;
reg      [16:0] oprand_0_24;
reg      [16:0] oprand_0_24_d0;
reg      [16:0] oprand_0_24_ori;
reg      [16:0] oprand_0_25;
reg      [16:0] oprand_0_25_d0;
reg      [16:0] oprand_0_25_ori;
reg      [16:0] oprand_0_26;
reg      [16:0] oprand_0_26_d0;
reg      [16:0] oprand_0_26_ori;
reg      [16:0] oprand_0_27;
reg      [16:0] oprand_0_27_d0;
reg      [16:0] oprand_0_27_ori;
reg      [16:0] oprand_0_28;
reg      [16:0] oprand_0_28_d0;
reg      [16:0] oprand_0_28_ori;
reg      [16:0] oprand_0_29;
reg      [16:0] oprand_0_29_d0;
reg      [16:0] oprand_0_29_ori;
reg      [16:0] oprand_0_2_d0;
reg      [16:0] oprand_0_2_ori;
reg      [16:0] oprand_0_3;
reg      [16:0] oprand_0_30;
reg      [16:0] oprand_0_30_d0;
reg      [16:0] oprand_0_30_ori;
reg      [16:0] oprand_0_31;
reg      [16:0] oprand_0_31_d0;
reg      [16:0] oprand_0_31_ori;
reg      [16:0] oprand_0_32;
reg      [16:0] oprand_0_32_d0;
reg      [16:0] oprand_0_32_ori;
reg      [16:0] oprand_0_33;
reg      [16:0] oprand_0_33_d0;
reg      [16:0] oprand_0_33_ori;
reg      [16:0] oprand_0_34;
reg      [16:0] oprand_0_34_d0;
reg      [16:0] oprand_0_34_ori;
reg      [16:0] oprand_0_35;
reg      [16:0] oprand_0_35_d0;
reg      [16:0] oprand_0_35_ori;
reg      [16:0] oprand_0_36;
reg      [16:0] oprand_0_36_d0;
reg      [16:0] oprand_0_36_ori;
reg      [16:0] oprand_0_37;
reg      [16:0] oprand_0_37_d0;
reg      [16:0] oprand_0_37_ori;
reg      [16:0] oprand_0_38;
reg      [16:0] oprand_0_38_d0;
reg      [16:0] oprand_0_38_ori;
reg      [16:0] oprand_0_39;
reg      [16:0] oprand_0_39_d0;
reg      [16:0] oprand_0_39_ori;
reg      [16:0] oprand_0_3_d0;
reg      [16:0] oprand_0_3_ori;
reg      [16:0] oprand_0_4;
reg      [16:0] oprand_0_40;
reg      [16:0] oprand_0_40_d0;
reg      [16:0] oprand_0_40_ori;
reg      [16:0] oprand_0_41;
reg      [16:0] oprand_0_41_d0;
reg      [16:0] oprand_0_41_ori;
reg      [16:0] oprand_0_42;
reg      [16:0] oprand_0_42_d0;
reg      [16:0] oprand_0_42_ori;
reg      [16:0] oprand_0_43;
reg      [16:0] oprand_0_43_d0;
reg      [16:0] oprand_0_43_ori;
reg      [16:0] oprand_0_44;
reg      [16:0] oprand_0_44_d0;
reg      [16:0] oprand_0_44_ori;
reg      [16:0] oprand_0_45;
reg      [16:0] oprand_0_45_d0;
reg      [16:0] oprand_0_45_ori;
reg      [16:0] oprand_0_46;
reg      [16:0] oprand_0_46_d0;
reg      [16:0] oprand_0_46_ori;
reg      [16:0] oprand_0_47;
reg      [16:0] oprand_0_47_d0;
reg      [16:0] oprand_0_47_ori;
reg      [16:0] oprand_0_48;
reg      [16:0] oprand_0_48_d0;
reg      [16:0] oprand_0_48_ori;
reg      [16:0] oprand_0_49;
reg      [16:0] oprand_0_49_d0;
reg      [16:0] oprand_0_49_ori;
reg      [16:0] oprand_0_4_d0;
reg      [16:0] oprand_0_4_ori;
reg      [16:0] oprand_0_5;
reg      [16:0] oprand_0_50;
reg      [16:0] oprand_0_50_d0;
reg      [16:0] oprand_0_50_ori;
reg      [16:0] oprand_0_51;
reg      [16:0] oprand_0_51_d0;
reg      [16:0] oprand_0_51_ori;
reg      [16:0] oprand_0_52;
reg      [16:0] oprand_0_52_d0;
reg      [16:0] oprand_0_52_ori;
reg      [16:0] oprand_0_53;
reg      [16:0] oprand_0_53_d0;
reg      [16:0] oprand_0_53_ori;
reg      [16:0] oprand_0_54;
reg      [16:0] oprand_0_54_d0;
reg      [16:0] oprand_0_54_ori;
reg      [16:0] oprand_0_55;
reg      [16:0] oprand_0_55_d0;
reg      [16:0] oprand_0_55_ori;
reg      [16:0] oprand_0_56;
reg      [16:0] oprand_0_56_d0;
reg      [16:0] oprand_0_56_ori;
reg      [16:0] oprand_0_57;
reg      [16:0] oprand_0_57_d0;
reg      [16:0] oprand_0_57_ori;
reg      [16:0] oprand_0_58;
reg      [16:0] oprand_0_58_d0;
reg      [16:0] oprand_0_58_ori;
reg      [16:0] oprand_0_59;
reg      [16:0] oprand_0_59_d0;
reg      [16:0] oprand_0_59_ori;
reg      [16:0] oprand_0_5_d0;
reg      [16:0] oprand_0_5_ori;
reg      [16:0] oprand_0_6;
reg      [16:0] oprand_0_60;
reg      [16:0] oprand_0_60_d0;
reg      [16:0] oprand_0_60_ori;
reg      [16:0] oprand_0_61;
reg      [16:0] oprand_0_61_d0;
reg      [16:0] oprand_0_61_ori;
reg      [16:0] oprand_0_62;
reg      [16:0] oprand_0_62_d0;
reg      [16:0] oprand_0_62_ori;
reg      [16:0] oprand_0_63;
reg      [16:0] oprand_0_63_d0;
reg      [16:0] oprand_0_63_ori;
reg      [16:0] oprand_0_6_d0;
reg      [16:0] oprand_0_6_ori;
reg      [16:0] oprand_0_7;
reg      [16:0] oprand_0_7_d0;
reg      [16:0] oprand_0_7_ori;
reg      [16:0] oprand_0_8;
reg      [16:0] oprand_0_8_d0;
reg      [16:0] oprand_0_8_ori;
reg      [63:0] oprand_0_8b_sign;
reg      [16:0] oprand_0_9;
reg      [16:0] oprand_0_9_d0;
reg      [16:0] oprand_0_9_ori;
reg     [271:0] oprand_0_q0_ori;
reg     [271:0] oprand_0_q1_ori;
reg     [271:0] oprand_0_q2_ori;
reg     [271:0] oprand_0_q3_ori;
reg      [15:0] oprand_1_0;
reg      [15:0] oprand_1_0_d0;
reg      [15:0] oprand_1_0_ori;
reg      [15:0] oprand_1_1;
reg      [15:0] oprand_1_10;
reg      [15:0] oprand_1_10_d0;
reg      [15:0] oprand_1_10_ori;
reg      [15:0] oprand_1_11;
reg      [15:0] oprand_1_11_d0;
reg      [15:0] oprand_1_11_ori;
reg      [15:0] oprand_1_12;
reg      [15:0] oprand_1_12_d0;
reg      [15:0] oprand_1_12_ori;
reg      [15:0] oprand_1_13;
reg      [15:0] oprand_1_13_d0;
reg      [15:0] oprand_1_13_ori;
reg      [15:0] oprand_1_14;
reg      [15:0] oprand_1_14_d0;
reg      [15:0] oprand_1_14_ori;
reg      [15:0] oprand_1_15;
reg      [15:0] oprand_1_15_d0;
reg      [15:0] oprand_1_15_ori;
reg      [15:0] oprand_1_16;
reg      [15:0] oprand_1_16_d0;
reg      [15:0] oprand_1_16_ori;
reg      [15:0] oprand_1_17;
reg      [15:0] oprand_1_17_d0;
reg      [15:0] oprand_1_17_ori;
reg      [15:0] oprand_1_18;
reg      [15:0] oprand_1_18_d0;
reg      [15:0] oprand_1_18_ori;
reg      [15:0] oprand_1_19;
reg      [15:0] oprand_1_19_d0;
reg      [15:0] oprand_1_19_ori;
reg      [15:0] oprand_1_1_d0;
reg      [15:0] oprand_1_1_ori;
reg      [15:0] oprand_1_2;
reg      [15:0] oprand_1_20;
reg      [15:0] oprand_1_20_d0;
reg      [15:0] oprand_1_20_ori;
reg      [15:0] oprand_1_21;
reg      [15:0] oprand_1_21_d0;
reg      [15:0] oprand_1_21_ori;
reg      [15:0] oprand_1_22;
reg      [15:0] oprand_1_22_d0;
reg      [15:0] oprand_1_22_ori;
reg      [15:0] oprand_1_23;
reg      [15:0] oprand_1_23_d0;
reg      [15:0] oprand_1_23_ori;
reg      [15:0] oprand_1_24;
reg      [15:0] oprand_1_24_d0;
reg      [15:0] oprand_1_24_ori;
reg      [15:0] oprand_1_25;
reg      [15:0] oprand_1_25_d0;
reg      [15:0] oprand_1_25_ori;
reg      [15:0] oprand_1_26;
reg      [15:0] oprand_1_26_d0;
reg      [15:0] oprand_1_26_ori;
reg      [15:0] oprand_1_27;
reg      [15:0] oprand_1_27_d0;
reg      [15:0] oprand_1_27_ori;
reg      [15:0] oprand_1_28;
reg      [15:0] oprand_1_28_d0;
reg      [15:0] oprand_1_28_ori;
reg      [15:0] oprand_1_29;
reg      [15:0] oprand_1_29_d0;
reg      [15:0] oprand_1_29_ori;
reg      [15:0] oprand_1_2_d0;
reg      [15:0] oprand_1_2_ori;
reg      [15:0] oprand_1_3;
reg      [15:0] oprand_1_30;
reg      [15:0] oprand_1_30_d0;
reg      [15:0] oprand_1_30_ori;
reg      [15:0] oprand_1_31;
reg      [15:0] oprand_1_31_d0;
reg      [15:0] oprand_1_31_ori;
reg      [15:0] oprand_1_32;
reg      [15:0] oprand_1_32_d0;
reg      [15:0] oprand_1_32_ori;
reg      [15:0] oprand_1_33;
reg      [15:0] oprand_1_33_d0;
reg      [15:0] oprand_1_33_ori;
reg      [15:0] oprand_1_34;
reg      [15:0] oprand_1_34_d0;
reg      [15:0] oprand_1_34_ori;
reg      [15:0] oprand_1_35;
reg      [15:0] oprand_1_35_d0;
reg      [15:0] oprand_1_35_ori;
reg      [15:0] oprand_1_36;
reg      [15:0] oprand_1_36_d0;
reg      [15:0] oprand_1_36_ori;
reg      [15:0] oprand_1_37;
reg      [15:0] oprand_1_37_d0;
reg      [15:0] oprand_1_37_ori;
reg      [15:0] oprand_1_38;
reg      [15:0] oprand_1_38_d0;
reg      [15:0] oprand_1_38_ori;
reg      [15:0] oprand_1_39;
reg      [15:0] oprand_1_39_d0;
reg      [15:0] oprand_1_39_ori;
reg      [15:0] oprand_1_3_d0;
reg      [15:0] oprand_1_3_ori;
reg      [15:0] oprand_1_4;
reg      [15:0] oprand_1_40;
reg      [15:0] oprand_1_40_d0;
reg      [15:0] oprand_1_40_ori;
reg      [15:0] oprand_1_41;
reg      [15:0] oprand_1_41_d0;
reg      [15:0] oprand_1_41_ori;
reg      [15:0] oprand_1_42;
reg      [15:0] oprand_1_42_d0;
reg      [15:0] oprand_1_42_ori;
reg      [15:0] oprand_1_43;
reg      [15:0] oprand_1_43_d0;
reg      [15:0] oprand_1_43_ori;
reg      [15:0] oprand_1_44;
reg      [15:0] oprand_1_44_d0;
reg      [15:0] oprand_1_44_ori;
reg      [15:0] oprand_1_45;
reg      [15:0] oprand_1_45_d0;
reg      [15:0] oprand_1_45_ori;
reg      [15:0] oprand_1_46;
reg      [15:0] oprand_1_46_d0;
reg      [15:0] oprand_1_46_ori;
reg      [15:0] oprand_1_47;
reg      [15:0] oprand_1_47_d0;
reg      [15:0] oprand_1_47_ori;
reg      [15:0] oprand_1_48;
reg      [15:0] oprand_1_48_d0;
reg      [15:0] oprand_1_48_ori;
reg      [15:0] oprand_1_49;
reg      [15:0] oprand_1_49_d0;
reg      [15:0] oprand_1_49_ori;
reg      [15:0] oprand_1_4_d0;
reg      [15:0] oprand_1_4_ori;
reg      [15:0] oprand_1_5;
reg      [15:0] oprand_1_50;
reg      [15:0] oprand_1_50_d0;
reg      [15:0] oprand_1_50_ori;
reg      [15:0] oprand_1_51;
reg      [15:0] oprand_1_51_d0;
reg      [15:0] oprand_1_51_ori;
reg      [15:0] oprand_1_52;
reg      [15:0] oprand_1_52_d0;
reg      [15:0] oprand_1_52_ori;
reg      [15:0] oprand_1_53;
reg      [15:0] oprand_1_53_d0;
reg      [15:0] oprand_1_53_ori;
reg      [15:0] oprand_1_54;
reg      [15:0] oprand_1_54_d0;
reg      [15:0] oprand_1_54_ori;
reg      [15:0] oprand_1_55;
reg      [15:0] oprand_1_55_d0;
reg      [15:0] oprand_1_55_ori;
reg      [15:0] oprand_1_56;
reg      [15:0] oprand_1_56_d0;
reg      [15:0] oprand_1_56_ori;
reg      [15:0] oprand_1_57;
reg      [15:0] oprand_1_57_d0;
reg      [15:0] oprand_1_57_ori;
reg      [15:0] oprand_1_58;
reg      [15:0] oprand_1_58_d0;
reg      [15:0] oprand_1_58_ori;
reg      [15:0] oprand_1_59;
reg      [15:0] oprand_1_59_d0;
reg      [15:0] oprand_1_59_ori;
reg      [15:0] oprand_1_5_d0;
reg      [15:0] oprand_1_5_ori;
reg      [15:0] oprand_1_6;
reg      [15:0] oprand_1_60;
reg      [15:0] oprand_1_60_d0;
reg      [15:0] oprand_1_60_ori;
reg      [15:0] oprand_1_61;
reg      [15:0] oprand_1_61_d0;
reg      [15:0] oprand_1_61_ori;
reg      [15:0] oprand_1_62;
reg      [15:0] oprand_1_62_d0;
reg      [15:0] oprand_1_62_ori;
reg      [15:0] oprand_1_63;
reg      [15:0] oprand_1_63_d0;
reg      [15:0] oprand_1_63_ori;
reg      [15:0] oprand_1_6_d0;
reg      [15:0] oprand_1_6_ori;
reg      [15:0] oprand_1_7;
reg      [15:0] oprand_1_7_d0;
reg      [15:0] oprand_1_7_ori;
reg      [15:0] oprand_1_8;
reg      [15:0] oprand_1_8_d0;
reg      [15:0] oprand_1_8_ori;
reg      [15:0] oprand_1_9;
reg      [15:0] oprand_1_9_d0;
reg      [15:0] oprand_1_9_ori;
reg     [255:0] oprand_1_q0_ori;
reg     [255:0] oprand_1_q1_ori;
reg     [255:0] oprand_1_q2_ori;
reg     [255:0] oprand_1_q3_ori;
reg             slcg_hls_en_d1;
reg             slcg_hls_en_d2;
reg             slcg_hls_en_d3;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
////////////////////////////////////////////////////////////////////////
//  prepare input signals                                             //
////////////////////////////////////////////////////////////////////////

always @(
  dp2reg_done
  or reg2dp_op_en
  ) begin
    op_en_w = ~dp2reg_done & reg2dp_op_en;
end

always @(
  op_en_w
  or op_en
  ) begin
    cfg_reg_en = op_en_w & ~op_en;
end

always @(
  reg2dp_in_precision
  ) begin
    is_input_int8_w = (reg2dp_in_precision == 2'h0 );
end

always @(
  reg2dp_in_precision
  ) begin
    is_input_fp16_w = (reg2dp_in_precision == 2'h2 );
end

always @(
  reg2dp_proc_precision
  ) begin
    is_output_int8_w = (reg2dp_proc_precision == 2'h0 );
end

always @(
  is_input_int8_w
  or is_output_int8_w
  ) begin
    is_data_shrink_w = ~is_input_int8_w & is_output_int8_w;
end

always @(
  is_input_int8_w
  or is_output_int8_w
  ) begin
    is_data_expand_w = is_input_int8_w & ~is_output_int8_w;
end

always @(
  is_input_int8_w
  or is_output_int8_w
  ) begin
    is_data_normal_w = is_input_int8_w ~^ is_output_int8_w;
end

always @(
  reg2dp_nan_to_zero
  or is_input_fp16_w
  ) begin
    nan_pass_w = ~reg2dp_nan_to_zero | ~is_input_fp16_w;
end

always @(
  is_output_int8_w
  or reg2dp_pad_value
  ) begin
    cfg_pad_value_w = is_output_int8_w ? {128{reg2dp_pad_value[7:0]}} :
                      {64{reg2dp_pad_value}};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_en <= 1'b0;
  end else begin
  op_en <= op_en_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_in_precision <= {32{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_in_precision <= {16{reg2dp_in_precision}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_in_precision <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_proc_precision <= {32{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_proc_precision <= {16{reg2dp_proc_precision}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_proc_precision <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_scale <= {256{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_scale <= {16{reg2dp_cvt_scale}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_scale <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_truncate <= {96{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_truncate <= {16{reg2dp_cvt_truncate}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_truncate <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_cvt_en <= {6{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_cvt_en <= {6{reg2dp_cvt_en}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_cvt_en <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_offset <= {1024{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_offset <= {64{reg2dp_cvt_offset}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_in_int8 <= 1'b0;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_in_int8 <= is_input_int8_w;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_in_int8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_out_int8 <= 1'b0;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_out_int8 <= is_output_int8_w;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_out_int8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_pad_value <= {1024{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_pad_value <= cfg_pad_value_w;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_pad_value <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_input_int8 <= {64{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    is_input_int8 <= {64{is_input_int8_w}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    is_input_int8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_input_fp16 <= 1'b0;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    is_input_fp16 <= is_input_fp16_w;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    is_input_fp16 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_data_shrink <= 1'b0;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    is_data_shrink <= is_data_shrink_w;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    is_data_shrink <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_data_expand <= 1'b0;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    is_data_expand <= is_data_expand_w;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    is_data_expand <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_data_normal <= 1'b0;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    is_data_normal <= is_data_normal_w;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    is_data_normal <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    nan_pass <= 1'b1;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    nan_pass <= nan_pass_w;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    nan_pass <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
//  SLCG control signal                                               //
////////////////////////////////////////////////////////////////////////
assign slcg_hls_en_w = reg2dp_op_en & reg2dp_cvt_en;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_hls_en_d1 <= 1'b0;
  end else begin
  slcg_hls_en_d1 <= slcg_hls_en_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_hls_en_d2 <= 1'b0;
  end else begin
  slcg_hls_en_d2 <= slcg_hls_en_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_hls_en_d3 <= 1'b0;
  end else begin
  slcg_hls_en_d3 <= slcg_hls_en_d2;
  end
end

assign slcg_hls_en = slcg_hls_en_d3;

////////////////////////////////////////////////////////////////////////
//  Input signals                                                     //
////////////////////////////////////////////////////////////////////////

always @(
  dc2cvt_dat_wr_en
  or dc2cvt_dat_wr_info_pd
  or wg2cvt_dat_wr_en
  or wg2cvt_dat_wr_info_pd
  or img2cvt_dat_wr_en
  or img2cvt_dat_wr_info_pd
  ) begin
    cvt_wr_info_pd = ({12 {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_info_pd)
                   | ({12 {wg2cvt_dat_wr_en}} & wg2cvt_dat_wr_info_pd)
                   | ({12 {img2cvt_dat_wr_en}} & img2cvt_dat_wr_info_pd);
end

always @(
  img2cvt_dat_wr_en
  ) begin
    cvt_wr_pad_mask_vld = img2cvt_dat_wr_en;
end

always @(
  cvt_wr_pad_mask_vld
  or img2cvt_dat_wr_pad_mask
  ) begin
    cvt_wr_pad_mask = cvt_wr_pad_mask_vld ? img2cvt_dat_wr_pad_mask : 128'b0;
end

always @(
  cvt_wr_pad_mask
  ) begin
    cvt_wr_pad_mask_srink = {64'b0, {cvt_wr_pad_mask[63*2] ,cvt_wr_pad_mask[62*2] ,cvt_wr_pad_mask[61*2] ,cvt_wr_pad_mask[60*2] ,cvt_wr_pad_mask[59*2] ,cvt_wr_pad_mask[58*2] ,cvt_wr_pad_mask[57*2] ,cvt_wr_pad_mask[56*2] ,cvt_wr_pad_mask[55*2] ,cvt_wr_pad_mask[54*2] ,cvt_wr_pad_mask[53*2] ,cvt_wr_pad_mask[52*2] ,cvt_wr_pad_mask[51*2] ,cvt_wr_pad_mask[50*2] ,cvt_wr_pad_mask[49*2] ,cvt_wr_pad_mask[48*2] ,cvt_wr_pad_mask[47*2] ,cvt_wr_pad_mask[46*2] ,cvt_wr_pad_mask[45*2] ,cvt_wr_pad_mask[44*2] ,cvt_wr_pad_mask[43*2] ,cvt_wr_pad_mask[42*2] ,cvt_wr_pad_mask[41*2] ,cvt_wr_pad_mask[40*2] ,cvt_wr_pad_mask[39*2] ,cvt_wr_pad_mask[38*2] ,cvt_wr_pad_mask[37*2] ,cvt_wr_pad_mask[36*2] ,cvt_wr_pad_mask[35*2] ,cvt_wr_pad_mask[34*2] ,cvt_wr_pad_mask[33*2] ,cvt_wr_pad_mask[32*2] ,cvt_wr_pad_mask[31*2] ,cvt_wr_pad_mask[30*2] ,cvt_wr_pad_mask[29*2] ,cvt_wr_pad_mask[28*2] ,cvt_wr_pad_mask[27*2] ,cvt_wr_pad_mask[26*2] ,cvt_wr_pad_mask[25*2] ,cvt_wr_pad_mask[24*2] ,cvt_wr_pad_mask[23*2] ,cvt_wr_pad_mask[22*2] ,cvt_wr_pad_mask[21*2] ,cvt_wr_pad_mask[20*2] ,cvt_wr_pad_mask[19*2] ,cvt_wr_pad_mask[18*2] ,cvt_wr_pad_mask[17*2] ,cvt_wr_pad_mask[16*2] ,cvt_wr_pad_mask[15*2] ,cvt_wr_pad_mask[14*2] ,cvt_wr_pad_mask[13*2] ,cvt_wr_pad_mask[12*2] ,cvt_wr_pad_mask[11*2] ,cvt_wr_pad_mask[10*2] ,cvt_wr_pad_mask[9*2] ,cvt_wr_pad_mask[8*2] ,cvt_wr_pad_mask[7*2] ,cvt_wr_pad_mask[6*2] ,cvt_wr_pad_mask[5*2] ,cvt_wr_pad_mask[4*2] ,cvt_wr_pad_mask[3*2] ,cvt_wr_pad_mask[2*2] ,cvt_wr_pad_mask[1*2] ,cvt_wr_pad_mask[0*2]}};
end

always @(
  cvt_wr_pad_mask
  ) begin
    cvt_wr_pad_mask_expand = {{2{cvt_wr_pad_mask[63]}} ,{2{cvt_wr_pad_mask[62]}} ,{2{cvt_wr_pad_mask[61]}} ,{2{cvt_wr_pad_mask[60]}} ,{2{cvt_wr_pad_mask[59]}} ,{2{cvt_wr_pad_mask[58]}} ,{2{cvt_wr_pad_mask[57]}} ,{2{cvt_wr_pad_mask[56]}} ,{2{cvt_wr_pad_mask[55]}} ,{2{cvt_wr_pad_mask[54]}} ,{2{cvt_wr_pad_mask[53]}} ,{2{cvt_wr_pad_mask[52]}} ,{2{cvt_wr_pad_mask[51]}} ,{2{cvt_wr_pad_mask[50]}} ,{2{cvt_wr_pad_mask[49]}} ,{2{cvt_wr_pad_mask[48]}} ,{2{cvt_wr_pad_mask[47]}} ,{2{cvt_wr_pad_mask[46]}} ,{2{cvt_wr_pad_mask[45]}} ,{2{cvt_wr_pad_mask[44]}} ,{2{cvt_wr_pad_mask[43]}} ,{2{cvt_wr_pad_mask[42]}} ,{2{cvt_wr_pad_mask[41]}} ,{2{cvt_wr_pad_mask[40]}} ,{2{cvt_wr_pad_mask[39]}} ,{2{cvt_wr_pad_mask[38]}} ,{2{cvt_wr_pad_mask[37]}} ,{2{cvt_wr_pad_mask[36]}} ,{2{cvt_wr_pad_mask[35]}} ,{2{cvt_wr_pad_mask[34]}} ,{2{cvt_wr_pad_mask[33]}} ,{2{cvt_wr_pad_mask[32]}} ,{2{cvt_wr_pad_mask[31]}} ,{2{cvt_wr_pad_mask[30]}} ,{2{cvt_wr_pad_mask[29]}} ,{2{cvt_wr_pad_mask[28]}} ,{2{cvt_wr_pad_mask[27]}} ,{2{cvt_wr_pad_mask[26]}} ,{2{cvt_wr_pad_mask[25]}} ,{2{cvt_wr_pad_mask[24]}} ,{2{cvt_wr_pad_mask[23]}} ,{2{cvt_wr_pad_mask[22]}} ,{2{cvt_wr_pad_mask[21]}} ,{2{cvt_wr_pad_mask[20]}} ,{2{cvt_wr_pad_mask[19]}} ,{2{cvt_wr_pad_mask[18]}} ,{2{cvt_wr_pad_mask[17]}} ,{2{cvt_wr_pad_mask[16]}} ,{2{cvt_wr_pad_mask[15]}} ,{2{cvt_wr_pad_mask[14]}} ,{2{cvt_wr_pad_mask[13]}} ,{2{cvt_wr_pad_mask[12]}} ,{2{cvt_wr_pad_mask[11]}} ,{2{cvt_wr_pad_mask[10]}} ,{2{cvt_wr_pad_mask[9]}} ,{2{cvt_wr_pad_mask[8]}} ,{2{cvt_wr_pad_mask[7]}} ,{2{cvt_wr_pad_mask[6]}} ,{2{cvt_wr_pad_mask[5]}} ,{2{cvt_wr_pad_mask[4]}} ,{2{cvt_wr_pad_mask[3]}} ,{2{cvt_wr_pad_mask[2]}} ,{2{cvt_wr_pad_mask[1]}} ,{2{cvt_wr_pad_mask[0]}}};
end


// PKT_UNPACK_WIRE( nvdla_ram_info ,  cvt_wr_ ,  cvt_wr_info_pd )
assign        cvt_wr_mask[3:0] =     cvt_wr_info_pd[3:0];
assign         cvt_wr_interleave  =     cvt_wr_info_pd[4];
assign         cvt_wr_ext64  =     cvt_wr_info_pd[5];
assign         cvt_wr_ext128  =     cvt_wr_info_pd[6];
assign         cvt_wr_mean  =     cvt_wr_info_pd[7];
assign         cvt_wr_uint  =     cvt_wr_info_pd[8];
assign        cvt_wr_sub_h[2:0] =     cvt_wr_info_pd[11:9];

always @(
  dc2cvt_dat_wr_en
  or dc2cvt_dat_wr_data
  or wg2cvt_dat_wr_en
  or wg2cvt_dat_wr_data
  ) begin
    cvt_wr_half_data = ({512  {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_data)
                     | ({512  {wg2cvt_dat_wr_en}} & wg2cvt_dat_wr_data);
end

always @(
  cvt_wr_half_data
  or img2cvt_dat_wr_en
  or img2cvt_dat_wr_data
  ) begin
    cvt_wr_data_ori = {{512  {1'b0}}, cvt_wr_half_data}
                    | ({1024  {img2cvt_dat_wr_en}} & img2cvt_dat_wr_data);
end

always @(
  cvt_wr_data_ori
  ) begin
    {cvt_wr_data_ori_hi,
     cvt_wr_data_ori_lo} = cvt_wr_data_ori;
end

always @(
  cvt_wr_data_ori_hi
  or nan_pass
  or cvt_wr_data_ori_lo
  or dat_nan_mask
  ) begin
    cvt_wr_data_hi = cvt_wr_data_ori_hi;
    cvt_wr_data_lo = nan_pass ? cvt_wr_data_ori_lo :
                     (cvt_wr_data_ori_lo & dat_nan_mask);
end

always @(
  cvt_wr_data_hi
  or cvt_wr_data_lo
  ) begin
    cvt_wr_data = {cvt_wr_data_hi, cvt_wr_data_lo};
end

always @(
  dc2cvt_dat_wr_en
  or dc2cvt_dat_wr_addr
  or wg2cvt_dat_wr_en
  or wg2cvt_dat_wr_addr
  or img2cvt_dat_wr_en
  or img2cvt_dat_wr_addr
  ) begin
    cvt_wr_addr = ({12 {dc2cvt_dat_wr_en}} & dc2cvt_dat_wr_addr)
                | ({12 {wg2cvt_dat_wr_en}} & wg2cvt_dat_wr_addr)
                | ({12 {img2cvt_dat_wr_en}} & img2cvt_dat_wr_addr);
end

always @(
  dc2cvt_dat_wr_en
  or dc2cvt_dat_wr_hsel
  or wg2cvt_dat_wr_en
  or wg2cvt_dat_wr_hsel
  or img2cvt_dat_wr_en
  or img2cvt_dat_wr_hsel
  ) begin
    cvt_wr_hsel = (dc2cvt_dat_wr_en & dc2cvt_dat_wr_hsel)
                | (wg2cvt_dat_wr_en & wg2cvt_dat_wr_hsel)
                | (img2cvt_dat_wr_en & img2cvt_dat_wr_hsel);
end

always @(
  dc2cvt_dat_wr_en
  or wg2cvt_dat_wr_en
  or img2cvt_dat_wr_en
  ) begin
    cvt_wr_en = (dc2cvt_dat_wr_en | wg2cvt_dat_wr_en | img2cvt_dat_wr_en);
end

assign cvt_wr_mean_data = img2cvt_mn_wr_data;

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
  nv_assert_zero_one_hot #(0,3,0,"Error! CVT input conflict!")      zzz_assert_zero_one_hot_16x (nvdla_core_clk, `ASSERT_RESET, {dc2cvt_dat_wr_en, wg2cvt_dat_wr_en, img2cvt_dat_wr_en}); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Disable when input data")      zzz_assert_never_17x (nvdla_core_clk, `ASSERT_RESET, (~op_en & cvt_wr_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Dc set two high masks")      zzz_assert_never_18x (nvdla_core_clk, `ASSERT_RESET, (dc2cvt_dat_wr_en & (|cvt_wr_mask[3:2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Wg set two high masks")      zzz_assert_never_19x (nvdla_core_clk, `ASSERT_RESET, (wg2cvt_dat_wr_en & (|cvt_wr_mask[3:2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Img set two hight masks when int8 input")      zzz_assert_never_20x (nvdla_core_clk, `ASSERT_RESET, (img2cvt_dat_wr_en & (|cvt_wr_mask[3:2]) & is_input_int8[0])); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Dc set mean flag")      zzz_assert_never_21x (nvdla_core_clk, `ASSERT_RESET, (dc2cvt_dat_wr_en & cvt_wr_mean)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Wg set mean flag")      zzz_assert_never_22x (nvdla_core_clk, `ASSERT_RESET, (wg2cvt_dat_wr_en & cvt_wr_mean)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Dc set uint flag")      zzz_assert_never_23x (nvdla_core_clk, `ASSERT_RESET, (dc2cvt_dat_wr_en & cvt_wr_uint)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Wg set uint flag")      zzz_assert_never_24x (nvdla_core_clk, `ASSERT_RESET, (wg2cvt_dat_wr_en & cvt_wr_uint)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Dc set sub h flag")      zzz_assert_never_25x (nvdla_core_clk, `ASSERT_RESET, (dc2cvt_dat_wr_en & (|cvt_wr_sub_h))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Wg set sub h flag")      zzz_assert_never_26x (nvdla_core_clk, `ASSERT_RESET, (wg2cvt_dat_wr_en & (|cvt_wr_sub_h))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Input data mask error!")      zzz_assert_never_27x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & (cvt_wr_mask != 4'h1) & (cvt_wr_mask != 4'h3) & (cvt_wr_mask != 4'hf))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Input data high mask set when input int8!")      zzz_assert_never_28x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_mask[3] & cfg_in_int8)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Both mask high bit and hsel are set!")      zzz_assert_never_29x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & cvt_wr_hsel & (|cvt_wr_mask[3:2]) & ~is_data_shrink)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Cvt interleave conflict with mask!")      zzz_assert_never_30x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & cvt_wr_interleave & (|cvt_wr_mask[3:2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Cvt hold set when mask high bit set!")      zzz_assert_never_31x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & cvt_cur_hold & (|cvt_wr_mask[3:2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Expand when 16bit input!")      zzz_assert_never_32x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & ~cfg_in_int8 & is_data_expand)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Shink when int8 input!")      zzz_assert_never_33x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & cfg_in_int8 & is_data_shrink)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Shink and expand!")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & is_data_expand & is_data_shrink)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Cvt interleave when half hold!")      zzz_assert_never_35x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & cvt_wr_interleave & cvt_cur_hold)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! No shrink when interleave!")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & cvt_wr_interleave & ~is_data_shrink)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Expand out of range when hsel set!")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & cvt_wr_hsel & is_data_expand & cvt_wr_mask[1])); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Half mask without output!")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & ~cvt_wr_ext64 & ~cvt_wr_ext128 & ~cvt_wr_mask[1])); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Half mask shrink with only ext 64!")      zzz_assert_never_39x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & ~cvt_wr_hsel & cvt_wr_ext64 & ~cvt_wr_ext128 & ~cvt_wr_mask[1])); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! cvt mode is not enable when format change!")      zzz_assert_never_40x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & ~cfg_cvt_en[0] & (cfg_in_precision[1:0] != cfg_proc_precision[1:0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! invalid precision transform!")      zzz_assert_never_41x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & (cfg_in_precision[1:0] == 2'h2 ) & (cfg_proc_precision[1:0] != 2'h2 ))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
//  generator hold control signals                                    //
////////////////////////////////////////////////////////////////////////

///////// generate half status ////////

always @(
  is_data_shrink
  or cvt_wr_mask
  or cvt_wr_interleave
  ) begin
    cvt_half_mode = is_data_shrink & ~(|cvt_wr_mask[3:2]) & ~cvt_wr_interleave;
end

always @(
  cvt_wr_sub_h
  ) begin
    cvt_line_idx[0] = (cvt_wr_sub_h == 3'h0);
    cvt_line_idx[1] = (cvt_wr_sub_h == 3'h1);
    cvt_line_idx[2] = (cvt_wr_sub_h == 3'h2);
    cvt_line_idx[3] = (cvt_wr_sub_h == 3'h3);
    cvt_line_idx[4] = (cvt_wr_sub_h == 3'h4);
    cvt_line_idx[5] = (cvt_wr_sub_h == 3'h5);
    cvt_line_idx[6] = (cvt_wr_sub_h == 3'h6);
    cvt_line_idx[7] = (cvt_wr_sub_h == 3'h7);
end

always @(
  cvt_hold_tag
  or cvt_line_idx
  ) begin
    cvt_cur_hold = (|(cvt_hold_tag & cvt_line_idx));
end

always @(
  cvt_line_idx
  or cvt_hold_addr_7
  or cvt_hold_addr_6
  or cvt_hold_addr_5
  or cvt_hold_addr_4
  or cvt_hold_addr_3
  or cvt_hold_addr_2
  or cvt_hold_addr_1
  or cvt_hold_addr_0
  ) begin
    cvt_cur_hold_addr = ({12 {cvt_line_idx[7]}} & cvt_hold_addr_7) |
                        ({12 {cvt_line_idx[6]}} & cvt_hold_addr_6) |
                        ({12 {cvt_line_idx[5]}} & cvt_hold_addr_5) |
                        ({12 {cvt_line_idx[4]}} & cvt_hold_addr_4) |
                        ({12 {cvt_line_idx[3]}} & cvt_hold_addr_3) |
                        ({12 {cvt_line_idx[2]}} & cvt_hold_addr_2) |
                        ({12 {cvt_line_idx[1]}} & cvt_hold_addr_1) |
                        ({12 {cvt_line_idx[0]}} & cvt_hold_addr_0);
end

always @(
  cvt_line_idx
  or cvt_hold_hsel_7
  or cvt_hold_hsel_6
  or cvt_hold_hsel_5
  or cvt_hold_hsel_4
  or cvt_hold_hsel_3
  or cvt_hold_hsel_2
  or cvt_hold_hsel_1
  or cvt_hold_hsel_0
  ) begin
    cvt_cur_hold_hsel = (cvt_line_idx[7] & cvt_hold_hsel_7) |
                        (cvt_line_idx[6] & cvt_hold_hsel_6) |
                        (cvt_line_idx[5] & cvt_hold_hsel_5) |
                        (cvt_line_idx[4] & cvt_hold_hsel_4) |
                        (cvt_line_idx[3] & cvt_hold_hsel_3) |
                        (cvt_line_idx[2] & cvt_hold_hsel_2) |
                        (cvt_line_idx[1] & cvt_hold_hsel_1) |
                        (cvt_line_idx[0] & cvt_hold_hsel_0);
end

always @(
  cvt_half_mode
  or cvt_cur_hold
  or cvt_wr_ext64
  or cvt_wr_ext128
  ) begin
    cvt_half_hold = cvt_half_mode & ~(cvt_cur_hold | cvt_wr_ext64 | cvt_wr_ext128);
    cvt_half_rls = cvt_half_mode & cvt_cur_hold;
end

always @(
  cfg_reg_en
  or cvt_half_hold
  or cvt_hold_tag
  or cvt_line_idx
  or cvt_half_rls
  ) begin
    cvt_hold_tag_w = cfg_reg_en ? 8'h0 :
                     cvt_half_hold ? (cvt_hold_tag | cvt_line_idx) :
                     cvt_half_rls ? (cvt_hold_tag & ~(cvt_line_idx)) :
                     cvt_hold_tag;
end

always @(
  cvt_half_hold
  or cvt_wr_en
  or cvt_line_idx
  ) begin
    cvt_hold_reg_en = (cvt_half_hold & cvt_wr_en) ? cvt_line_idx : 8'b0;
end

assign cvt_half_en = cvt_half_rls | cvt_half_hold;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_hold_tag <= {8{1'b0}};
  end else begin
  if ((cvt_half_mode & cvt_wr_en) == 1'b1) begin
    cvt_hold_tag <= cvt_hold_tag_w;
  // VCS coverage off
  end else if ((cvt_half_mode & cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_hold_tag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_half_mode & cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_reg_en[7]) == 1'b1) begin
    {cvt_hold_addr_7, cvt_hold_hsel_7} <= {cvt_wr_addr, cvt_wr_hsel};
  // VCS coverage off
  end else if ((cvt_hold_reg_en[7]) == 1'b0) begin
  end else begin
    {cvt_hold_addr_7, cvt_hold_hsel_7} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_reg_en[6]) == 1'b1) begin
    {cvt_hold_addr_6, cvt_hold_hsel_6} <= {cvt_wr_addr, cvt_wr_hsel};
  // VCS coverage off
  end else if ((cvt_hold_reg_en[6]) == 1'b0) begin
  end else begin
    {cvt_hold_addr_6, cvt_hold_hsel_6} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_reg_en[5]) == 1'b1) begin
    {cvt_hold_addr_5, cvt_hold_hsel_5} <= {cvt_wr_addr, cvt_wr_hsel};
  // VCS coverage off
  end else if ((cvt_hold_reg_en[5]) == 1'b0) begin
  end else begin
    {cvt_hold_addr_5, cvt_hold_hsel_5} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_reg_en[4]) == 1'b1) begin
    {cvt_hold_addr_4, cvt_hold_hsel_4} <= {cvt_wr_addr, cvt_wr_hsel};
  // VCS coverage off
  end else if ((cvt_hold_reg_en[4]) == 1'b0) begin
  end else begin
    {cvt_hold_addr_4, cvt_hold_hsel_4} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_reg_en[3]) == 1'b1) begin
    {cvt_hold_addr_3, cvt_hold_hsel_3} <= {cvt_wr_addr, cvt_wr_hsel};
  // VCS coverage off
  end else if ((cvt_hold_reg_en[3]) == 1'b0) begin
  end else begin
    {cvt_hold_addr_3, cvt_hold_hsel_3} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_reg_en[2]) == 1'b1) begin
    {cvt_hold_addr_2, cvt_hold_hsel_2} <= {cvt_wr_addr, cvt_wr_hsel};
  // VCS coverage off
  end else if ((cvt_hold_reg_en[2]) == 1'b0) begin
  end else begin
    {cvt_hold_addr_2, cvt_hold_hsel_2} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_reg_en[1]) == 1'b1) begin
    {cvt_hold_addr_1, cvt_hold_hsel_1} <= {cvt_wr_addr, cvt_wr_hsel};
  // VCS coverage off
  end else if ((cvt_hold_reg_en[1]) == 1'b0) begin
  end else begin
    {cvt_hold_addr_1, cvt_hold_hsel_1} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_reg_en[0]) == 1'b1) begin
    {cvt_hold_addr_0, cvt_hold_hsel_0} <= {cvt_wr_addr, cvt_wr_hsel};
  // VCS coverage off
  end else if ((cvt_hold_reg_en[0]) == 1'b0) begin
  end else begin
    {cvt_hold_addr_0, cvt_hold_hsel_0} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
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
  nv_assert_never #(0,0,"Error! Half hold tag valid when non-half-mode")      zzz_assert_never_43x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & ~cvt_half_mode & cvt_cur_hold)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Addr mismatch when half mode")      zzz_assert_never_44x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & cvt_half_mode & cvt_cur_hold & (cvt_cur_hold_addr != cvt_wr_addr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Hsel mismatch when half mode")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (cvt_wr_en & cvt_half_mode & cvt_cur_hold & (cvt_cur_hold_hsel != cvt_wr_hsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Half hold tag valid when layer disabled")      zzz_assert_never_46x (nvdla_core_clk, `ASSERT_RESET, ((|cvt_hold_tag) & ~reg2dp_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
//  generator mux control signals                                     //
////////////////////////////////////////////////////////////////////////

assign cvt_cell_in_sel_half = (is_data_normal & cvt_wr_hsel & ~cfg_in_int8) |
                              (is_data_shrink & cvt_half_rls);
assign cvt_cell_in_sel_interval = cvt_wr_interleave;

assign cvt_cell_out_sel_hold = cvt_half_rls;

assign cvt_transform_mask = cvt_half_hold ? 8'b0 :
                            cvt_half_rls ? {4'b0, cvt_wr_mask[1:0], 2'b11} :
                            cvt_wr_interleave ? 8'ha :
                            is_data_shrink ? {4'b0, cvt_wr_mask} :
                            is_data_expand ? {{4{cvt_wr_mask[1]}}, {4{cvt_wr_mask[0]}}} :
                            {{2{cvt_wr_mask[3]}}, {2{cvt_wr_mask[2]}}, {2{cvt_wr_mask[1]}}, {2{cvt_wr_mask[0]}}};
assign cvt_out_nz_mask = cvt_wr_hsel ? {cvt_transform_mask[3:0], 4'b0} : cvt_transform_mask; 

assign cvt_sel_pad_mask = cvt_half_rls ? {64'b0, cvt_wr_pad_mask_srink[31:0], 32'b0} :
                          is_data_normal ? cvt_wr_pad_mask :
                          is_data_expand ? cvt_wr_pad_mask_expand :
                          cvt_wr_pad_mask_srink;
assign cvt_out_pad_mask = (cvt_wr_hsel & ~cvt_half_hold) ? {cvt_sel_pad_mask[63:0], 64'b0} : cvt_sel_pad_mask;
assign cvt_out_pad_vld = cvt_wr_pad_mask_vld & cvt_wr_en;

assign cvt_out_single_hsel = cvt_half_rls ? cvt_cur_hold_hsel : cvt_wr_hsel;
assign cvt_out_hsel[0] = ~cvt_out_single_hsel;
assign cvt_out_hsel[1] = cvt_out_single_hsel | (is_data_normal & cvt_wr_mask[2]) | (is_data_expand & cvt_wr_mask[1]) | cvt_wr_ext128;
assign cvt_out_addr = cvt_half_rls ? cvt_cur_hold_addr : cvt_wr_addr;

assign cvt_cell_en = (~cvt_wr_en | ~cfg_cvt_en[0]) ? 64'b0 :
                     cfg_in_int8 ? {{32{cvt_wr_mask[1]}}, {32{cvt_wr_mask[0]}}} :
                     cvt_wr_interleave ? {16'b0, {16{1'b1}}, 16'b0, {16{1'b1}}} :
                     cvt_cell_in_sel_half ? {{16{cvt_wr_mask[1]}}, {16{cvt_wr_mask[0]}}, 32'b0} :
                     {{16{cvt_wr_mask[3]}}, {16{cvt_wr_mask[2]}}, {16{cvt_wr_mask[1]}}, {16{cvt_wr_mask[0]}}};
assign cvt_bypass_sel_half = cvt_wr_hsel;
assign cvt_out_vld = cvt_wr_en & ~cvt_half_hold;
assign cvt_hold_en = cvt_wr_en & cvt_half_hold;
assign cvt_out_reg_en = (cvt_wr_en & ~cvt_half_hold) ? {{4{cvt_out_hsel[1]}}, {4{cvt_out_hsel[0]}}} : 8'b0;

////////////////////////////////////////////////////////////////////////
//  One pipeline stage for retiming                                   //
////////////////////////////////////////////////////////////////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_wr_en_d1 <= 1'b0;
  end else begin
  cvt_wr_en_d1 <= cvt_wr_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_wr_mean_d1 <= 1'b0;
  end else begin
  if ((cvt_wr_en) == 1'b1) begin
    cvt_wr_mean_d1 <= cvt_wr_mean;
  // VCS coverage off
  end else if ((cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_wr_mean_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_47x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_wr_uint_d1 <= {64{1'b0}};
  end else begin
  if ((cvt_wr_en) == 1'b1) begin
    cvt_wr_uint_d1 <= {64{cvt_wr_uint}};
  // VCS coverage off
  end else if ((cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_wr_uint_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk) begin
  if ((cvt_wr_en & cvt_wr_mean) == 1'b1) begin
    cvt_wr_mean_data_d1 <= cvt_wr_mean_data;
  // VCS coverage off
  end else if ((cvt_wr_en & cvt_wr_mean) == 1'b0) begin
  end else begin
    cvt_wr_mean_data_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_wr_en) == 1'b1) begin
    cvt_wr_data_d1 <= cvt_wr_data;
  // VCS coverage off
  end else if ((cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_wr_data_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_cell_en_d1 <= {64{1'b0}};
  end else begin
  if ((cvt_wr_en | cvt_wr_en_d1) == 1'b1) begin
    cvt_cell_en_d1 <= cvt_cell_en;
  // VCS coverage off
  end else if ((cvt_wr_en | cvt_wr_en_d1) == 1'b0) begin
  end else begin
    cvt_cell_en_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_49x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en | cvt_wr_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_cell_in_sel_half_d1 <= {4{1'b0}};
  end else begin
  if ((cvt_wr_en) == 1'b1) begin
    cvt_cell_in_sel_half_d1 <= {4{cvt_cell_in_sel_half}};
  // VCS coverage off
  end else if ((cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_cell_in_sel_half_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_50x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_cell_in_sel_interval_d1 <= {2{1'b0}};
  end else begin
  if ((cvt_wr_en) == 1'b1) begin
    cvt_cell_in_sel_interval_d1 <= {2{cvt_cell_in_sel_interval}};
  // VCS coverage off
  end else if ((cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_cell_in_sel_interval_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_51x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_vld_d1 <= 1'b0;
  end else begin
  cvt_out_vld_d1 <= cvt_out_vld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_hold_en_d1 <= 1'b0;
  end else begin
  cvt_hold_en_d1 <= cvt_hold_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_pad_vld_d1 <= 1'b0;
  end else begin
  cvt_out_pad_vld_d1 <= cvt_out_pad_vld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_hsel_d1 <= {2{1'b0}};
  end else begin
  if ((cvt_wr_en) == 1'b1) begin
    cvt_out_hsel_d1 <= cvt_out_hsel;
  // VCS coverage off
  end else if ((cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_out_hsel_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_52x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_addr_d1 <= {12{1'b0}};
  end else begin
  if ((cvt_wr_en) == 1'b1) begin
    cvt_out_addr_d1 <= cvt_out_addr;
  // VCS coverage off
  end else if ((cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_out_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_line_idx_d1 <= {8{1'b0}};
  end else begin
  if ((cvt_wr_en & cvt_half_en) == 1'b1) begin
    cvt_line_idx_d1 <= cvt_line_idx;
  // VCS coverage off
  end else if ((cvt_wr_en & cvt_half_en) == 1'b0) begin
  end else begin
    cvt_line_idx_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_54x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en & cvt_half_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_nz_mask_d1 <= {8{1'b0}};
  end else begin
  if ((cvt_wr_en) == 1'b1) begin
    cvt_out_nz_mask_d1 <= cvt_out_nz_mask;
  // VCS coverage off
  end else if ((cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_out_nz_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_55x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_pad_mask_d1 <= {128{1'b0}};
  end else begin
  if ((cvt_out_pad_vld) == 1'b1) begin
    cvt_out_pad_mask_d1 <= cvt_out_pad_mask;
  // VCS coverage off
  end else if ((cvt_out_pad_vld) == 1'b0) begin
  end else begin
    cvt_out_pad_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_56x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_pad_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_reg_en_d1 <= {8{1'b0}};
  end else begin
  cvt_out_reg_en_d1 <= cvt_out_reg_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_cell_out_sel_hold_d1 <= 1'b0;
  end else begin
  if ((cvt_wr_en) == 1'b1) begin
    cvt_cell_out_sel_hold_d1 <= cvt_cell_out_sel_hold;
  // VCS coverage off
  end else if ((cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_cell_out_sel_hold_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_57x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_bypass_sel_half_d1 <= 1'b0;
  end else begin
  if ((cvt_wr_en) == 1'b1) begin
    cvt_bypass_sel_half_d1 <= cvt_bypass_sel_half;
  // VCS coverage off
  end else if ((cvt_wr_en) == 1'b0) begin
  end else begin
    cvt_bypass_sel_half_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_58x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
//  generate input signals for convertor cells                        //
////////////////////////////////////////////////////////////////////////

always @(
  cvt_wr_data_d1
  or cvt_wr_uint_d1
  ) begin
    oprand_0_8b_sign[0] = (cvt_wr_data_d1[7] & ~cvt_wr_uint_d1[0]);
    oprand_0_8b_sign[1] = (cvt_wr_data_d1[15] & ~cvt_wr_uint_d1[1]);
    oprand_0_8b_sign[2] = (cvt_wr_data_d1[23] & ~cvt_wr_uint_d1[2]);
    oprand_0_8b_sign[3] = (cvt_wr_data_d1[31] & ~cvt_wr_uint_d1[3]);
    oprand_0_8b_sign[4] = (cvt_wr_data_d1[39] & ~cvt_wr_uint_d1[4]);
    oprand_0_8b_sign[5] = (cvt_wr_data_d1[47] & ~cvt_wr_uint_d1[5]);
    oprand_0_8b_sign[6] = (cvt_wr_data_d1[55] & ~cvt_wr_uint_d1[6]);
    oprand_0_8b_sign[7] = (cvt_wr_data_d1[63] & ~cvt_wr_uint_d1[7]);
    oprand_0_8b_sign[8] = (cvt_wr_data_d1[71] & ~cvt_wr_uint_d1[8]);
    oprand_0_8b_sign[9] = (cvt_wr_data_d1[79] & ~cvt_wr_uint_d1[9]);
    oprand_0_8b_sign[10] = (cvt_wr_data_d1[87] & ~cvt_wr_uint_d1[10]);
    oprand_0_8b_sign[11] = (cvt_wr_data_d1[95] & ~cvt_wr_uint_d1[11]);
    oprand_0_8b_sign[12] = (cvt_wr_data_d1[103] & ~cvt_wr_uint_d1[12]);
    oprand_0_8b_sign[13] = (cvt_wr_data_d1[111] & ~cvt_wr_uint_d1[13]);
    oprand_0_8b_sign[14] = (cvt_wr_data_d1[119] & ~cvt_wr_uint_d1[14]);
    oprand_0_8b_sign[15] = (cvt_wr_data_d1[127] & ~cvt_wr_uint_d1[15]);
    oprand_0_8b_sign[16] = (cvt_wr_data_d1[135] & ~cvt_wr_uint_d1[16]);
    oprand_0_8b_sign[17] = (cvt_wr_data_d1[143] & ~cvt_wr_uint_d1[17]);
    oprand_0_8b_sign[18] = (cvt_wr_data_d1[151] & ~cvt_wr_uint_d1[18]);
    oprand_0_8b_sign[19] = (cvt_wr_data_d1[159] & ~cvt_wr_uint_d1[19]);
    oprand_0_8b_sign[20] = (cvt_wr_data_d1[167] & ~cvt_wr_uint_d1[20]);
    oprand_0_8b_sign[21] = (cvt_wr_data_d1[175] & ~cvt_wr_uint_d1[21]);
    oprand_0_8b_sign[22] = (cvt_wr_data_d1[183] & ~cvt_wr_uint_d1[22]);
    oprand_0_8b_sign[23] = (cvt_wr_data_d1[191] & ~cvt_wr_uint_d1[23]);
    oprand_0_8b_sign[24] = (cvt_wr_data_d1[199] & ~cvt_wr_uint_d1[24]);
    oprand_0_8b_sign[25] = (cvt_wr_data_d1[207] & ~cvt_wr_uint_d1[25]);
    oprand_0_8b_sign[26] = (cvt_wr_data_d1[215] & ~cvt_wr_uint_d1[26]);
    oprand_0_8b_sign[27] = (cvt_wr_data_d1[223] & ~cvt_wr_uint_d1[27]);
    oprand_0_8b_sign[28] = (cvt_wr_data_d1[231] & ~cvt_wr_uint_d1[28]);
    oprand_0_8b_sign[29] = (cvt_wr_data_d1[239] & ~cvt_wr_uint_d1[29]);
    oprand_0_8b_sign[30] = (cvt_wr_data_d1[247] & ~cvt_wr_uint_d1[30]);
    oprand_0_8b_sign[31] = (cvt_wr_data_d1[255] & ~cvt_wr_uint_d1[31]);
    oprand_0_8b_sign[32] = (cvt_wr_data_d1[263] & ~cvt_wr_uint_d1[32]);
    oprand_0_8b_sign[33] = (cvt_wr_data_d1[271] & ~cvt_wr_uint_d1[33]);
    oprand_0_8b_sign[34] = (cvt_wr_data_d1[279] & ~cvt_wr_uint_d1[34]);
    oprand_0_8b_sign[35] = (cvt_wr_data_d1[287] & ~cvt_wr_uint_d1[35]);
    oprand_0_8b_sign[36] = (cvt_wr_data_d1[295] & ~cvt_wr_uint_d1[36]);
    oprand_0_8b_sign[37] = (cvt_wr_data_d1[303] & ~cvt_wr_uint_d1[37]);
    oprand_0_8b_sign[38] = (cvt_wr_data_d1[311] & ~cvt_wr_uint_d1[38]);
    oprand_0_8b_sign[39] = (cvt_wr_data_d1[319] & ~cvt_wr_uint_d1[39]);
    oprand_0_8b_sign[40] = (cvt_wr_data_d1[327] & ~cvt_wr_uint_d1[40]);
    oprand_0_8b_sign[41] = (cvt_wr_data_d1[335] & ~cvt_wr_uint_d1[41]);
    oprand_0_8b_sign[42] = (cvt_wr_data_d1[343] & ~cvt_wr_uint_d1[42]);
    oprand_0_8b_sign[43] = (cvt_wr_data_d1[351] & ~cvt_wr_uint_d1[43]);
    oprand_0_8b_sign[44] = (cvt_wr_data_d1[359] & ~cvt_wr_uint_d1[44]);
    oprand_0_8b_sign[45] = (cvt_wr_data_d1[367] & ~cvt_wr_uint_d1[45]);
    oprand_0_8b_sign[46] = (cvt_wr_data_d1[375] & ~cvt_wr_uint_d1[46]);
    oprand_0_8b_sign[47] = (cvt_wr_data_d1[383] & ~cvt_wr_uint_d1[47]);
    oprand_0_8b_sign[48] = (cvt_wr_data_d1[391] & ~cvt_wr_uint_d1[48]);
    oprand_0_8b_sign[49] = (cvt_wr_data_d1[399] & ~cvt_wr_uint_d1[49]);
    oprand_0_8b_sign[50] = (cvt_wr_data_d1[407] & ~cvt_wr_uint_d1[50]);
    oprand_0_8b_sign[51] = (cvt_wr_data_d1[415] & ~cvt_wr_uint_d1[51]);
    oprand_0_8b_sign[52] = (cvt_wr_data_d1[423] & ~cvt_wr_uint_d1[52]);
    oprand_0_8b_sign[53] = (cvt_wr_data_d1[431] & ~cvt_wr_uint_d1[53]);
    oprand_0_8b_sign[54] = (cvt_wr_data_d1[439] & ~cvt_wr_uint_d1[54]);
    oprand_0_8b_sign[55] = (cvt_wr_data_d1[447] & ~cvt_wr_uint_d1[55]);
    oprand_0_8b_sign[56] = (cvt_wr_data_d1[455] & ~cvt_wr_uint_d1[56]);
    oprand_0_8b_sign[57] = (cvt_wr_data_d1[463] & ~cvt_wr_uint_d1[57]);
    oprand_0_8b_sign[58] = (cvt_wr_data_d1[471] & ~cvt_wr_uint_d1[58]);
    oprand_0_8b_sign[59] = (cvt_wr_data_d1[479] & ~cvt_wr_uint_d1[59]);
    oprand_0_8b_sign[60] = (cvt_wr_data_d1[487] & ~cvt_wr_uint_d1[60]);
    oprand_0_8b_sign[61] = (cvt_wr_data_d1[495] & ~cvt_wr_uint_d1[61]);
    oprand_0_8b_sign[62] = (cvt_wr_data_d1[503] & ~cvt_wr_uint_d1[62]);
    oprand_0_8b_sign[63] = (cvt_wr_data_d1[511] & ~cvt_wr_uint_d1[63]);
end

always @(
  cvt_wr_data_d1
  or cvt_wr_uint_d1
  ) begin
    oprand_0_16b_sign[0] = (cvt_wr_data_d1[15] & ~cvt_wr_uint_d1[0]);
    oprand_0_16b_sign[1] = (cvt_wr_data_d1[31] & ~cvt_wr_uint_d1[1]);
    oprand_0_16b_sign[2] = (cvt_wr_data_d1[47] & ~cvt_wr_uint_d1[2]);
    oprand_0_16b_sign[3] = (cvt_wr_data_d1[63] & ~cvt_wr_uint_d1[3]);
    oprand_0_16b_sign[4] = (cvt_wr_data_d1[79] & ~cvt_wr_uint_d1[4]);
    oprand_0_16b_sign[5] = (cvt_wr_data_d1[95] & ~cvt_wr_uint_d1[5]);
    oprand_0_16b_sign[6] = (cvt_wr_data_d1[111] & ~cvt_wr_uint_d1[6]);
    oprand_0_16b_sign[7] = (cvt_wr_data_d1[127] & ~cvt_wr_uint_d1[7]);
    oprand_0_16b_sign[8] = (cvt_wr_data_d1[143] & ~cvt_wr_uint_d1[8]);
    oprand_0_16b_sign[9] = (cvt_wr_data_d1[159] & ~cvt_wr_uint_d1[9]);
    oprand_0_16b_sign[10] = (cvt_wr_data_d1[175] & ~cvt_wr_uint_d1[10]);
    oprand_0_16b_sign[11] = (cvt_wr_data_d1[191] & ~cvt_wr_uint_d1[11]);
    oprand_0_16b_sign[12] = (cvt_wr_data_d1[207] & ~cvt_wr_uint_d1[12]);
    oprand_0_16b_sign[13] = (cvt_wr_data_d1[223] & ~cvt_wr_uint_d1[13]);
    oprand_0_16b_sign[14] = (cvt_wr_data_d1[239] & ~cvt_wr_uint_d1[14]);
    oprand_0_16b_sign[15] = (cvt_wr_data_d1[255] & ~cvt_wr_uint_d1[15]);
    oprand_0_16b_sign[16] = (cvt_wr_data_d1[271] & ~cvt_wr_uint_d1[16]);
    oprand_0_16b_sign[17] = (cvt_wr_data_d1[287] & ~cvt_wr_uint_d1[17]);
    oprand_0_16b_sign[18] = (cvt_wr_data_d1[303] & ~cvt_wr_uint_d1[18]);
    oprand_0_16b_sign[19] = (cvt_wr_data_d1[319] & ~cvt_wr_uint_d1[19]);
    oprand_0_16b_sign[20] = (cvt_wr_data_d1[335] & ~cvt_wr_uint_d1[20]);
    oprand_0_16b_sign[21] = (cvt_wr_data_d1[351] & ~cvt_wr_uint_d1[21]);
    oprand_0_16b_sign[22] = (cvt_wr_data_d1[367] & ~cvt_wr_uint_d1[22]);
    oprand_0_16b_sign[23] = (cvt_wr_data_d1[383] & ~cvt_wr_uint_d1[23]);
    oprand_0_16b_sign[24] = (cvt_wr_data_d1[399] & ~cvt_wr_uint_d1[24]);
    oprand_0_16b_sign[25] = (cvt_wr_data_d1[415] & ~cvt_wr_uint_d1[25]);
    oprand_0_16b_sign[26] = (cvt_wr_data_d1[431] & ~cvt_wr_uint_d1[26]);
    oprand_0_16b_sign[27] = (cvt_wr_data_d1[447] & ~cvt_wr_uint_d1[27]);
    oprand_0_16b_sign[28] = (cvt_wr_data_d1[463] & ~cvt_wr_uint_d1[28]);
    oprand_0_16b_sign[29] = (cvt_wr_data_d1[479] & ~cvt_wr_uint_d1[29]);
    oprand_0_16b_sign[30] = (cvt_wr_data_d1[495] & ~cvt_wr_uint_d1[30]);
    oprand_0_16b_sign[31] = (cvt_wr_data_d1[511] & ~cvt_wr_uint_d1[31]);
    oprand_0_16b_sign[32] = (cvt_wr_data_d1[527] & ~cvt_wr_uint_d1[32]);
    oprand_0_16b_sign[33] = (cvt_wr_data_d1[543] & ~cvt_wr_uint_d1[33]);
    oprand_0_16b_sign[34] = (cvt_wr_data_d1[559] & ~cvt_wr_uint_d1[34]);
    oprand_0_16b_sign[35] = (cvt_wr_data_d1[575] & ~cvt_wr_uint_d1[35]);
    oprand_0_16b_sign[36] = (cvt_wr_data_d1[591] & ~cvt_wr_uint_d1[36]);
    oprand_0_16b_sign[37] = (cvt_wr_data_d1[607] & ~cvt_wr_uint_d1[37]);
    oprand_0_16b_sign[38] = (cvt_wr_data_d1[623] & ~cvt_wr_uint_d1[38]);
    oprand_0_16b_sign[39] = (cvt_wr_data_d1[639] & ~cvt_wr_uint_d1[39]);
    oprand_0_16b_sign[40] = (cvt_wr_data_d1[655] & ~cvt_wr_uint_d1[40]);
    oprand_0_16b_sign[41] = (cvt_wr_data_d1[671] & ~cvt_wr_uint_d1[41]);
    oprand_0_16b_sign[42] = (cvt_wr_data_d1[687] & ~cvt_wr_uint_d1[42]);
    oprand_0_16b_sign[43] = (cvt_wr_data_d1[703] & ~cvt_wr_uint_d1[43]);
    oprand_0_16b_sign[44] = (cvt_wr_data_d1[719] & ~cvt_wr_uint_d1[44]);
    oprand_0_16b_sign[45] = (cvt_wr_data_d1[735] & ~cvt_wr_uint_d1[45]);
    oprand_0_16b_sign[46] = (cvt_wr_data_d1[751] & ~cvt_wr_uint_d1[46]);
    oprand_0_16b_sign[47] = (cvt_wr_data_d1[767] & ~cvt_wr_uint_d1[47]);
    oprand_0_16b_sign[48] = (cvt_wr_data_d1[783] & ~cvt_wr_uint_d1[48]);
    oprand_0_16b_sign[49] = (cvt_wr_data_d1[799] & ~cvt_wr_uint_d1[49]);
    oprand_0_16b_sign[50] = (cvt_wr_data_d1[815] & ~cvt_wr_uint_d1[50]);
    oprand_0_16b_sign[51] = (cvt_wr_data_d1[831] & ~cvt_wr_uint_d1[51]);
    oprand_0_16b_sign[52] = (cvt_wr_data_d1[847] & ~cvt_wr_uint_d1[52]);
    oprand_0_16b_sign[53] = (cvt_wr_data_d1[863] & ~cvt_wr_uint_d1[53]);
    oprand_0_16b_sign[54] = (cvt_wr_data_d1[879] & ~cvt_wr_uint_d1[54]);
    oprand_0_16b_sign[55] = (cvt_wr_data_d1[895] & ~cvt_wr_uint_d1[55]);
    oprand_0_16b_sign[56] = (cvt_wr_data_d1[911] & ~cvt_wr_uint_d1[56]);
    oprand_0_16b_sign[57] = (cvt_wr_data_d1[927] & ~cvt_wr_uint_d1[57]);
    oprand_0_16b_sign[58] = (cvt_wr_data_d1[943] & ~cvt_wr_uint_d1[58]);
    oprand_0_16b_sign[59] = (cvt_wr_data_d1[959] & ~cvt_wr_uint_d1[59]);
    oprand_0_16b_sign[60] = (cvt_wr_data_d1[975] & ~cvt_wr_uint_d1[60]);
    oprand_0_16b_sign[61] = (cvt_wr_data_d1[991] & ~cvt_wr_uint_d1[61]);
    oprand_0_16b_sign[62] = (cvt_wr_data_d1[1007] & ~cvt_wr_uint_d1[62]);
    oprand_0_16b_sign[63] = (cvt_wr_data_d1[1023] & ~cvt_wr_uint_d1[63]);
end

always @(
  is_input_int8
  or oprand_0_8b_sign
  or cvt_wr_data_d1
  or oprand_0_16b_sign
  ) begin
    oprand_0_0_ori = is_input_int8[0] ? {{9{oprand_0_8b_sign[0]}}, cvt_wr_data_d1[7:0]} : {oprand_0_16b_sign[0], cvt_wr_data_d1[15:0]};
    oprand_0_1_ori = is_input_int8[1] ? {{9{oprand_0_8b_sign[1]}}, cvt_wr_data_d1[15:8]} : {oprand_0_16b_sign[1], cvt_wr_data_d1[31:16]};
    oprand_0_2_ori = is_input_int8[2] ? {{9{oprand_0_8b_sign[2]}}, cvt_wr_data_d1[23:16]} : {oprand_0_16b_sign[2], cvt_wr_data_d1[47:32]};
    oprand_0_3_ori = is_input_int8[3] ? {{9{oprand_0_8b_sign[3]}}, cvt_wr_data_d1[31:24]} : {oprand_0_16b_sign[3], cvt_wr_data_d1[63:48]};
    oprand_0_4_ori = is_input_int8[4] ? {{9{oprand_0_8b_sign[4]}}, cvt_wr_data_d1[39:32]} : {oprand_0_16b_sign[4], cvt_wr_data_d1[79:64]};
    oprand_0_5_ori = is_input_int8[5] ? {{9{oprand_0_8b_sign[5]}}, cvt_wr_data_d1[47:40]} : {oprand_0_16b_sign[5], cvt_wr_data_d1[95:80]};
    oprand_0_6_ori = is_input_int8[6] ? {{9{oprand_0_8b_sign[6]}}, cvt_wr_data_d1[55:48]} : {oprand_0_16b_sign[6], cvt_wr_data_d1[111:96]};
    oprand_0_7_ori = is_input_int8[7] ? {{9{oprand_0_8b_sign[7]}}, cvt_wr_data_d1[63:56]} : {oprand_0_16b_sign[7], cvt_wr_data_d1[127:112]};
    oprand_0_8_ori = is_input_int8[8] ? {{9{oprand_0_8b_sign[8]}}, cvt_wr_data_d1[71:64]} : {oprand_0_16b_sign[8], cvt_wr_data_d1[143:128]};
    oprand_0_9_ori = is_input_int8[9] ? {{9{oprand_0_8b_sign[9]}}, cvt_wr_data_d1[79:72]} : {oprand_0_16b_sign[9], cvt_wr_data_d1[159:144]};
    oprand_0_10_ori = is_input_int8[10] ? {{9{oprand_0_8b_sign[10]}}, cvt_wr_data_d1[87:80]} : {oprand_0_16b_sign[10], cvt_wr_data_d1[175:160]};
    oprand_0_11_ori = is_input_int8[11] ? {{9{oprand_0_8b_sign[11]}}, cvt_wr_data_d1[95:88]} : {oprand_0_16b_sign[11], cvt_wr_data_d1[191:176]};
    oprand_0_12_ori = is_input_int8[12] ? {{9{oprand_0_8b_sign[12]}}, cvt_wr_data_d1[103:96]} : {oprand_0_16b_sign[12], cvt_wr_data_d1[207:192]};
    oprand_0_13_ori = is_input_int8[13] ? {{9{oprand_0_8b_sign[13]}}, cvt_wr_data_d1[111:104]} : {oprand_0_16b_sign[13], cvt_wr_data_d1[223:208]};
    oprand_0_14_ori = is_input_int8[14] ? {{9{oprand_0_8b_sign[14]}}, cvt_wr_data_d1[119:112]} : {oprand_0_16b_sign[14], cvt_wr_data_d1[239:224]};
    oprand_0_15_ori = is_input_int8[15] ? {{9{oprand_0_8b_sign[15]}}, cvt_wr_data_d1[127:120]} : {oprand_0_16b_sign[15], cvt_wr_data_d1[255:240]};
    oprand_0_16_ori = is_input_int8[16] ? {{9{oprand_0_8b_sign[16]}}, cvt_wr_data_d1[135:128]} : {oprand_0_16b_sign[16], cvt_wr_data_d1[271:256]};
    oprand_0_17_ori = is_input_int8[17] ? {{9{oprand_0_8b_sign[17]}}, cvt_wr_data_d1[143:136]} : {oprand_0_16b_sign[17], cvt_wr_data_d1[287:272]};
    oprand_0_18_ori = is_input_int8[18] ? {{9{oprand_0_8b_sign[18]}}, cvt_wr_data_d1[151:144]} : {oprand_0_16b_sign[18], cvt_wr_data_d1[303:288]};
    oprand_0_19_ori = is_input_int8[19] ? {{9{oprand_0_8b_sign[19]}}, cvt_wr_data_d1[159:152]} : {oprand_0_16b_sign[19], cvt_wr_data_d1[319:304]};
    oprand_0_20_ori = is_input_int8[20] ? {{9{oprand_0_8b_sign[20]}}, cvt_wr_data_d1[167:160]} : {oprand_0_16b_sign[20], cvt_wr_data_d1[335:320]};
    oprand_0_21_ori = is_input_int8[21] ? {{9{oprand_0_8b_sign[21]}}, cvt_wr_data_d1[175:168]} : {oprand_0_16b_sign[21], cvt_wr_data_d1[351:336]};
    oprand_0_22_ori = is_input_int8[22] ? {{9{oprand_0_8b_sign[22]}}, cvt_wr_data_d1[183:176]} : {oprand_0_16b_sign[22], cvt_wr_data_d1[367:352]};
    oprand_0_23_ori = is_input_int8[23] ? {{9{oprand_0_8b_sign[23]}}, cvt_wr_data_d1[191:184]} : {oprand_0_16b_sign[23], cvt_wr_data_d1[383:368]};
    oprand_0_24_ori = is_input_int8[24] ? {{9{oprand_0_8b_sign[24]}}, cvt_wr_data_d1[199:192]} : {oprand_0_16b_sign[24], cvt_wr_data_d1[399:384]};
    oprand_0_25_ori = is_input_int8[25] ? {{9{oprand_0_8b_sign[25]}}, cvt_wr_data_d1[207:200]} : {oprand_0_16b_sign[25], cvt_wr_data_d1[415:400]};
    oprand_0_26_ori = is_input_int8[26] ? {{9{oprand_0_8b_sign[26]}}, cvt_wr_data_d1[215:208]} : {oprand_0_16b_sign[26], cvt_wr_data_d1[431:416]};
    oprand_0_27_ori = is_input_int8[27] ? {{9{oprand_0_8b_sign[27]}}, cvt_wr_data_d1[223:216]} : {oprand_0_16b_sign[27], cvt_wr_data_d1[447:432]};
    oprand_0_28_ori = is_input_int8[28] ? {{9{oprand_0_8b_sign[28]}}, cvt_wr_data_d1[231:224]} : {oprand_0_16b_sign[28], cvt_wr_data_d1[463:448]};
    oprand_0_29_ori = is_input_int8[29] ? {{9{oprand_0_8b_sign[29]}}, cvt_wr_data_d1[239:232]} : {oprand_0_16b_sign[29], cvt_wr_data_d1[479:464]};
    oprand_0_30_ori = is_input_int8[30] ? {{9{oprand_0_8b_sign[30]}}, cvt_wr_data_d1[247:240]} : {oprand_0_16b_sign[30], cvt_wr_data_d1[495:480]};
    oprand_0_31_ori = is_input_int8[31] ? {{9{oprand_0_8b_sign[31]}}, cvt_wr_data_d1[255:248]} : {oprand_0_16b_sign[31], cvt_wr_data_d1[511:496]};
    oprand_0_32_ori = is_input_int8[32] ? {{9{oprand_0_8b_sign[32]}}, cvt_wr_data_d1[263:256]} : {oprand_0_16b_sign[32], cvt_wr_data_d1[527:512]};
    oprand_0_33_ori = is_input_int8[33] ? {{9{oprand_0_8b_sign[33]}}, cvt_wr_data_d1[271:264]} : {oprand_0_16b_sign[33], cvt_wr_data_d1[543:528]};
    oprand_0_34_ori = is_input_int8[34] ? {{9{oprand_0_8b_sign[34]}}, cvt_wr_data_d1[279:272]} : {oprand_0_16b_sign[34], cvt_wr_data_d1[559:544]};
    oprand_0_35_ori = is_input_int8[35] ? {{9{oprand_0_8b_sign[35]}}, cvt_wr_data_d1[287:280]} : {oprand_0_16b_sign[35], cvt_wr_data_d1[575:560]};
    oprand_0_36_ori = is_input_int8[36] ? {{9{oprand_0_8b_sign[36]}}, cvt_wr_data_d1[295:288]} : {oprand_0_16b_sign[36], cvt_wr_data_d1[591:576]};
    oprand_0_37_ori = is_input_int8[37] ? {{9{oprand_0_8b_sign[37]}}, cvt_wr_data_d1[303:296]} : {oprand_0_16b_sign[37], cvt_wr_data_d1[607:592]};
    oprand_0_38_ori = is_input_int8[38] ? {{9{oprand_0_8b_sign[38]}}, cvt_wr_data_d1[311:304]} : {oprand_0_16b_sign[38], cvt_wr_data_d1[623:608]};
    oprand_0_39_ori = is_input_int8[39] ? {{9{oprand_0_8b_sign[39]}}, cvt_wr_data_d1[319:312]} : {oprand_0_16b_sign[39], cvt_wr_data_d1[639:624]};
    oprand_0_40_ori = is_input_int8[40] ? {{9{oprand_0_8b_sign[40]}}, cvt_wr_data_d1[327:320]} : {oprand_0_16b_sign[40], cvt_wr_data_d1[655:640]};
    oprand_0_41_ori = is_input_int8[41] ? {{9{oprand_0_8b_sign[41]}}, cvt_wr_data_d1[335:328]} : {oprand_0_16b_sign[41], cvt_wr_data_d1[671:656]};
    oprand_0_42_ori = is_input_int8[42] ? {{9{oprand_0_8b_sign[42]}}, cvt_wr_data_d1[343:336]} : {oprand_0_16b_sign[42], cvt_wr_data_d1[687:672]};
    oprand_0_43_ori = is_input_int8[43] ? {{9{oprand_0_8b_sign[43]}}, cvt_wr_data_d1[351:344]} : {oprand_0_16b_sign[43], cvt_wr_data_d1[703:688]};
    oprand_0_44_ori = is_input_int8[44] ? {{9{oprand_0_8b_sign[44]}}, cvt_wr_data_d1[359:352]} : {oprand_0_16b_sign[44], cvt_wr_data_d1[719:704]};
    oprand_0_45_ori = is_input_int8[45] ? {{9{oprand_0_8b_sign[45]}}, cvt_wr_data_d1[367:360]} : {oprand_0_16b_sign[45], cvt_wr_data_d1[735:720]};
    oprand_0_46_ori = is_input_int8[46] ? {{9{oprand_0_8b_sign[46]}}, cvt_wr_data_d1[375:368]} : {oprand_0_16b_sign[46], cvt_wr_data_d1[751:736]};
    oprand_0_47_ori = is_input_int8[47] ? {{9{oprand_0_8b_sign[47]}}, cvt_wr_data_d1[383:376]} : {oprand_0_16b_sign[47], cvt_wr_data_d1[767:752]};
    oprand_0_48_ori = is_input_int8[48] ? {{9{oprand_0_8b_sign[48]}}, cvt_wr_data_d1[391:384]} : {oprand_0_16b_sign[48], cvt_wr_data_d1[783:768]};
    oprand_0_49_ori = is_input_int8[49] ? {{9{oprand_0_8b_sign[49]}}, cvt_wr_data_d1[399:392]} : {oprand_0_16b_sign[49], cvt_wr_data_d1[799:784]};
    oprand_0_50_ori = is_input_int8[50] ? {{9{oprand_0_8b_sign[50]}}, cvt_wr_data_d1[407:400]} : {oprand_0_16b_sign[50], cvt_wr_data_d1[815:800]};
    oprand_0_51_ori = is_input_int8[51] ? {{9{oprand_0_8b_sign[51]}}, cvt_wr_data_d1[415:408]} : {oprand_0_16b_sign[51], cvt_wr_data_d1[831:816]};
    oprand_0_52_ori = is_input_int8[52] ? {{9{oprand_0_8b_sign[52]}}, cvt_wr_data_d1[423:416]} : {oprand_0_16b_sign[52], cvt_wr_data_d1[847:832]};
    oprand_0_53_ori = is_input_int8[53] ? {{9{oprand_0_8b_sign[53]}}, cvt_wr_data_d1[431:424]} : {oprand_0_16b_sign[53], cvt_wr_data_d1[863:848]};
    oprand_0_54_ori = is_input_int8[54] ? {{9{oprand_0_8b_sign[54]}}, cvt_wr_data_d1[439:432]} : {oprand_0_16b_sign[54], cvt_wr_data_d1[879:864]};
    oprand_0_55_ori = is_input_int8[55] ? {{9{oprand_0_8b_sign[55]}}, cvt_wr_data_d1[447:440]} : {oprand_0_16b_sign[55], cvt_wr_data_d1[895:880]};
    oprand_0_56_ori = is_input_int8[56] ? {{9{oprand_0_8b_sign[56]}}, cvt_wr_data_d1[455:448]} : {oprand_0_16b_sign[56], cvt_wr_data_d1[911:896]};
    oprand_0_57_ori = is_input_int8[57] ? {{9{oprand_0_8b_sign[57]}}, cvt_wr_data_d1[463:456]} : {oprand_0_16b_sign[57], cvt_wr_data_d1[927:912]};
    oprand_0_58_ori = is_input_int8[58] ? {{9{oprand_0_8b_sign[58]}}, cvt_wr_data_d1[471:464]} : {oprand_0_16b_sign[58], cvt_wr_data_d1[943:928]};
    oprand_0_59_ori = is_input_int8[59] ? {{9{oprand_0_8b_sign[59]}}, cvt_wr_data_d1[479:472]} : {oprand_0_16b_sign[59], cvt_wr_data_d1[959:944]};
    oprand_0_60_ori = is_input_int8[60] ? {{9{oprand_0_8b_sign[60]}}, cvt_wr_data_d1[487:480]} : {oprand_0_16b_sign[60], cvt_wr_data_d1[975:960]};
    oprand_0_61_ori = is_input_int8[61] ? {{9{oprand_0_8b_sign[61]}}, cvt_wr_data_d1[495:488]} : {oprand_0_16b_sign[61], cvt_wr_data_d1[991:976]};
    oprand_0_62_ori = is_input_int8[62] ? {{9{oprand_0_8b_sign[62]}}, cvt_wr_data_d1[503:496]} : {oprand_0_16b_sign[62], cvt_wr_data_d1[1007:992]};
    oprand_0_63_ori = is_input_int8[63] ? {{9{oprand_0_8b_sign[63]}}, cvt_wr_data_d1[511:504]} : {oprand_0_16b_sign[63], cvt_wr_data_d1[1023:1008]};
end

always @(
  cvt_wr_mean_d1
  or cvt_wr_mean_data_d1
  or cfg_offset
  ) begin
    oprand_1_0_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[15:0] : cfg_offset[15:0];
    oprand_1_1_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[31:16] : cfg_offset[31:16];
    oprand_1_2_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[47:32] : cfg_offset[47:32];
    oprand_1_3_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[63:48] : cfg_offset[63:48];
    oprand_1_4_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[79:64] : cfg_offset[79:64];
    oprand_1_5_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[95:80] : cfg_offset[95:80];
    oprand_1_6_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[111:96] : cfg_offset[111:96];
    oprand_1_7_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[127:112] : cfg_offset[127:112];
    oprand_1_8_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[143:128] : cfg_offset[143:128];
    oprand_1_9_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[159:144] : cfg_offset[159:144];
    oprand_1_10_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[175:160] : cfg_offset[175:160];
    oprand_1_11_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[191:176] : cfg_offset[191:176];
    oprand_1_12_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[207:192] : cfg_offset[207:192];
    oprand_1_13_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[223:208] : cfg_offset[223:208];
    oprand_1_14_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[239:224] : cfg_offset[239:224];
    oprand_1_15_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[255:240] : cfg_offset[255:240];
    oprand_1_16_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[271:256] : cfg_offset[271:256];
    oprand_1_17_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[287:272] : cfg_offset[287:272];
    oprand_1_18_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[303:288] : cfg_offset[303:288];
    oprand_1_19_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[319:304] : cfg_offset[319:304];
    oprand_1_20_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[335:320] : cfg_offset[335:320];
    oprand_1_21_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[351:336] : cfg_offset[351:336];
    oprand_1_22_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[367:352] : cfg_offset[367:352];
    oprand_1_23_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[383:368] : cfg_offset[383:368];
    oprand_1_24_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[399:384] : cfg_offset[399:384];
    oprand_1_25_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[415:400] : cfg_offset[415:400];
    oprand_1_26_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[431:416] : cfg_offset[431:416];
    oprand_1_27_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[447:432] : cfg_offset[447:432];
    oprand_1_28_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[463:448] : cfg_offset[463:448];
    oprand_1_29_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[479:464] : cfg_offset[479:464];
    oprand_1_30_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[495:480] : cfg_offset[495:480];
    oprand_1_31_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[511:496] : cfg_offset[511:496];
    oprand_1_32_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[527:512] : cfg_offset[527:512];
    oprand_1_33_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[543:528] : cfg_offset[543:528];
    oprand_1_34_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[559:544] : cfg_offset[559:544];
    oprand_1_35_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[575:560] : cfg_offset[575:560];
    oprand_1_36_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[591:576] : cfg_offset[591:576];
    oprand_1_37_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[607:592] : cfg_offset[607:592];
    oprand_1_38_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[623:608] : cfg_offset[623:608];
    oprand_1_39_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[639:624] : cfg_offset[639:624];
    oprand_1_40_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[655:640] : cfg_offset[655:640];
    oprand_1_41_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[671:656] : cfg_offset[671:656];
    oprand_1_42_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[687:672] : cfg_offset[687:672];
    oprand_1_43_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[703:688] : cfg_offset[703:688];
    oprand_1_44_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[719:704] : cfg_offset[719:704];
    oprand_1_45_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[735:720] : cfg_offset[735:720];
    oprand_1_46_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[751:736] : cfg_offset[751:736];
    oprand_1_47_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[767:752] : cfg_offset[767:752];
    oprand_1_48_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[783:768] : cfg_offset[783:768];
    oprand_1_49_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[799:784] : cfg_offset[799:784];
    oprand_1_50_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[815:800] : cfg_offset[815:800];
    oprand_1_51_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[831:816] : cfg_offset[831:816];
    oprand_1_52_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[847:832] : cfg_offset[847:832];
    oprand_1_53_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[863:848] : cfg_offset[863:848];
    oprand_1_54_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[879:864] : cfg_offset[879:864];
    oprand_1_55_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[895:880] : cfg_offset[895:880];
    oprand_1_56_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[911:896] : cfg_offset[911:896];
    oprand_1_57_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[927:912] : cfg_offset[927:912];
    oprand_1_58_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[943:928] : cfg_offset[943:928];
    oprand_1_59_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[959:944] : cfg_offset[959:944];
    oprand_1_60_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[975:960] : cfg_offset[975:960];
    oprand_1_61_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[991:976] : cfg_offset[991:976];
    oprand_1_62_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[1007:992] : cfg_offset[1007:992];
    oprand_1_63_ori = cvt_wr_mean_d1 ? cvt_wr_mean_data_d1[1023:1008] : cfg_offset[1023:1008];
end


////////////////////////////////////////////////////////////////////////

////oprand_0
always @(
  oprand_0_63_ori
  or oprand_0_62_ori
  or oprand_0_61_ori
  or oprand_0_60_ori
  or oprand_0_59_ori
  or oprand_0_58_ori
  or oprand_0_57_ori
  or oprand_0_56_ori
  or oprand_0_55_ori
  or oprand_0_54_ori
  or oprand_0_53_ori
  or oprand_0_52_ori
  or oprand_0_51_ori
  or oprand_0_50_ori
  or oprand_0_49_ori
  or oprand_0_48_ori
  or oprand_0_47_ori
  or oprand_0_46_ori
  or oprand_0_45_ori
  or oprand_0_44_ori
  or oprand_0_43_ori
  or oprand_0_42_ori
  or oprand_0_41_ori
  or oprand_0_40_ori
  or oprand_0_39_ori
  or oprand_0_38_ori
  or oprand_0_37_ori
  or oprand_0_36_ori
  or oprand_0_35_ori
  or oprand_0_34_ori
  or oprand_0_33_ori
  or oprand_0_32_ori
  or oprand_0_31_ori
  or oprand_0_30_ori
  or oprand_0_29_ori
  or oprand_0_28_ori
  or oprand_0_27_ori
  or oprand_0_26_ori
  or oprand_0_25_ori
  or oprand_0_24_ori
  or oprand_0_23_ori
  or oprand_0_22_ori
  or oprand_0_21_ori
  or oprand_0_20_ori
  or oprand_0_19_ori
  or oprand_0_18_ori
  or oprand_0_17_ori
  or oprand_0_16_ori
  or oprand_0_15_ori
  or oprand_0_14_ori
  or oprand_0_13_ori
  or oprand_0_12_ori
  or oprand_0_11_ori
  or oprand_0_10_ori
  or oprand_0_9_ori
  or oprand_0_8_ori
  or oprand_0_7_ori
  or oprand_0_6_ori
  or oprand_0_5_ori
  or oprand_0_4_ori
  or oprand_0_3_ori
  or oprand_0_2_ori
  or oprand_0_1_ori
  or oprand_0_0_ori
  ) begin
    {oprand_0_q3_ori,
     oprand_0_q2_ori,
     oprand_0_q1_ori,
     oprand_0_q0_ori}
        = {oprand_0_63_ori, oprand_0_62_ori, oprand_0_61_ori, oprand_0_60_ori, oprand_0_59_ori, oprand_0_58_ori, oprand_0_57_ori, oprand_0_56_ori, oprand_0_55_ori, oprand_0_54_ori, oprand_0_53_ori, oprand_0_52_ori, oprand_0_51_ori, oprand_0_50_ori, oprand_0_49_ori, oprand_0_48_ori, oprand_0_47_ori, oprand_0_46_ori, oprand_0_45_ori, oprand_0_44_ori, oprand_0_43_ori, oprand_0_42_ori, oprand_0_41_ori, oprand_0_40_ori, oprand_0_39_ori, oprand_0_38_ori, oprand_0_37_ori, oprand_0_36_ori, oprand_0_35_ori, oprand_0_34_ori, oprand_0_33_ori, oprand_0_32_ori, oprand_0_31_ori, oprand_0_30_ori, oprand_0_29_ori, oprand_0_28_ori, oprand_0_27_ori, oprand_0_26_ori, oprand_0_25_ori, oprand_0_24_ori, oprand_0_23_ori, oprand_0_22_ori, oprand_0_21_ori, oprand_0_20_ori, oprand_0_19_ori, oprand_0_18_ori, oprand_0_17_ori, oprand_0_16_ori, oprand_0_15_ori, oprand_0_14_ori, oprand_0_13_ori, oprand_0_12_ori, oprand_0_11_ori, oprand_0_10_ori, oprand_0_9_ori, oprand_0_8_ori, oprand_0_7_ori, oprand_0_6_ori, oprand_0_5_ori, oprand_0_4_ori, oprand_0_3_ori, oprand_0_2_ori, oprand_0_1_ori, oprand_0_0_ori};
end

assign oprand_0_q3 = cvt_cell_in_sel_half_d1[0] ? oprand_0_q1_ori : oprand_0_q3_ori;
assign oprand_0_q2 = cvt_cell_in_sel_half_d1[1] ? oprand_0_q0_ori :
                     cvt_cell_in_sel_interval_d1[0] ? oprand_0_q1_ori :
                     oprand_0_q2_ori;
assign oprand_0_q1 = oprand_0_q1_ori;
assign oprand_0_q0 = oprand_0_q0_ori;

always @(
  oprand_0_q3
  or oprand_0_q2
  or oprand_0_q1
  or oprand_0_q0
  ) begin
    {oprand_0_63, oprand_0_62, oprand_0_61, oprand_0_60, oprand_0_59, oprand_0_58, oprand_0_57, oprand_0_56, oprand_0_55, oprand_0_54, oprand_0_53, oprand_0_52, oprand_0_51, oprand_0_50, oprand_0_49, oprand_0_48, oprand_0_47, oprand_0_46, oprand_0_45, oprand_0_44, oprand_0_43, oprand_0_42, oprand_0_41, oprand_0_40, oprand_0_39, oprand_0_38, oprand_0_37, oprand_0_36, oprand_0_35, oprand_0_34, oprand_0_33, oprand_0_32, oprand_0_31, oprand_0_30, oprand_0_29, oprand_0_28, oprand_0_27, oprand_0_26, oprand_0_25, oprand_0_24, oprand_0_23, oprand_0_22, oprand_0_21, oprand_0_20, oprand_0_19, oprand_0_18, oprand_0_17, oprand_0_16, oprand_0_15, oprand_0_14, oprand_0_13, oprand_0_12, oprand_0_11, oprand_0_10, oprand_0_9, oprand_0_8, oprand_0_7, oprand_0_6, oprand_0_5, oprand_0_4, oprand_0_3, oprand_0_2, oprand_0_1, oprand_0_0} = 
        {oprand_0_q3,
         oprand_0_q2,
         oprand_0_q1,
         oprand_0_q0};
end

////oprand_1
always @(
  oprand_1_63_ori
  or oprand_1_62_ori
  or oprand_1_61_ori
  or oprand_1_60_ori
  or oprand_1_59_ori
  or oprand_1_58_ori
  or oprand_1_57_ori
  or oprand_1_56_ori
  or oprand_1_55_ori
  or oprand_1_54_ori
  or oprand_1_53_ori
  or oprand_1_52_ori
  or oprand_1_51_ori
  or oprand_1_50_ori
  or oprand_1_49_ori
  or oprand_1_48_ori
  or oprand_1_47_ori
  or oprand_1_46_ori
  or oprand_1_45_ori
  or oprand_1_44_ori
  or oprand_1_43_ori
  or oprand_1_42_ori
  or oprand_1_41_ori
  or oprand_1_40_ori
  or oprand_1_39_ori
  or oprand_1_38_ori
  or oprand_1_37_ori
  or oprand_1_36_ori
  or oprand_1_35_ori
  or oprand_1_34_ori
  or oprand_1_33_ori
  or oprand_1_32_ori
  or oprand_1_31_ori
  or oprand_1_30_ori
  or oprand_1_29_ori
  or oprand_1_28_ori
  or oprand_1_27_ori
  or oprand_1_26_ori
  or oprand_1_25_ori
  or oprand_1_24_ori
  or oprand_1_23_ori
  or oprand_1_22_ori
  or oprand_1_21_ori
  or oprand_1_20_ori
  or oprand_1_19_ori
  or oprand_1_18_ori
  or oprand_1_17_ori
  or oprand_1_16_ori
  or oprand_1_15_ori
  or oprand_1_14_ori
  or oprand_1_13_ori
  or oprand_1_12_ori
  or oprand_1_11_ori
  or oprand_1_10_ori
  or oprand_1_9_ori
  or oprand_1_8_ori
  or oprand_1_7_ori
  or oprand_1_6_ori
  or oprand_1_5_ori
  or oprand_1_4_ori
  or oprand_1_3_ori
  or oprand_1_2_ori
  or oprand_1_1_ori
  or oprand_1_0_ori
  ) begin
    {oprand_1_q3_ori,
     oprand_1_q2_ori,
     oprand_1_q1_ori,
     oprand_1_q0_ori}
        = {oprand_1_63_ori, oprand_1_62_ori, oprand_1_61_ori, oprand_1_60_ori, oprand_1_59_ori, oprand_1_58_ori, oprand_1_57_ori, oprand_1_56_ori, oprand_1_55_ori, oprand_1_54_ori, oprand_1_53_ori, oprand_1_52_ori, oprand_1_51_ori, oprand_1_50_ori, oprand_1_49_ori, oprand_1_48_ori, oprand_1_47_ori, oprand_1_46_ori, oprand_1_45_ori, oprand_1_44_ori, oprand_1_43_ori, oprand_1_42_ori, oprand_1_41_ori, oprand_1_40_ori, oprand_1_39_ori, oprand_1_38_ori, oprand_1_37_ori, oprand_1_36_ori, oprand_1_35_ori, oprand_1_34_ori, oprand_1_33_ori, oprand_1_32_ori, oprand_1_31_ori, oprand_1_30_ori, oprand_1_29_ori, oprand_1_28_ori, oprand_1_27_ori, oprand_1_26_ori, oprand_1_25_ori, oprand_1_24_ori, oprand_1_23_ori, oprand_1_22_ori, oprand_1_21_ori, oprand_1_20_ori, oprand_1_19_ori, oprand_1_18_ori, oprand_1_17_ori, oprand_1_16_ori, oprand_1_15_ori, oprand_1_14_ori, oprand_1_13_ori, oprand_1_12_ori, oprand_1_11_ori, oprand_1_10_ori, oprand_1_9_ori, oprand_1_8_ori, oprand_1_7_ori, oprand_1_6_ori, oprand_1_5_ori, oprand_1_4_ori, oprand_1_3_ori, oprand_1_2_ori, oprand_1_1_ori, oprand_1_0_ori};
end

assign oprand_1_q3 = cvt_cell_in_sel_half_d1[2] ? oprand_1_q1_ori : oprand_1_q3_ori;
assign oprand_1_q2 = cvt_cell_in_sel_half_d1[3] ? oprand_1_q0_ori :
                     cvt_cell_in_sel_interval_d1[1] ? oprand_1_q1_ori :
                     oprand_1_q2_ori;
assign oprand_1_q1 = oprand_1_q1_ori;
assign oprand_1_q0 = oprand_1_q0_ori;

always @(
  oprand_1_q3
  or oprand_1_q2
  or oprand_1_q1
  or oprand_1_q0
  ) begin
    {oprand_1_63, oprand_1_62, oprand_1_61, oprand_1_60, oprand_1_59, oprand_1_58, oprand_1_57, oprand_1_56, oprand_1_55, oprand_1_54, oprand_1_53, oprand_1_52, oprand_1_51, oprand_1_50, oprand_1_49, oprand_1_48, oprand_1_47, oprand_1_46, oprand_1_45, oprand_1_44, oprand_1_43, oprand_1_42, oprand_1_41, oprand_1_40, oprand_1_39, oprand_1_38, oprand_1_37, oprand_1_36, oprand_1_35, oprand_1_34, oprand_1_33, oprand_1_32, oprand_1_31, oprand_1_30, oprand_1_29, oprand_1_28, oprand_1_27, oprand_1_26, oprand_1_25, oprand_1_24, oprand_1_23, oprand_1_22, oprand_1_21, oprand_1_20, oprand_1_19, oprand_1_18, oprand_1_17, oprand_1_16, oprand_1_15, oprand_1_14, oprand_1_13, oprand_1_12, oprand_1_11, oprand_1_10, oprand_1_9, oprand_1_8, oprand_1_7, oprand_1_6, oprand_1_5, oprand_1_4, oprand_1_3, oprand_1_2, oprand_1_1, oprand_1_0} = 
        {oprand_1_q3,
         oprand_1_q2,
         oprand_1_q1,
         oprand_1_q0};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_en_d0 <= 1'b0;
  end else begin
  op_en_d0 <= cvt_wr_en_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cell_en_d0 <= {64{1'b0}};
  end else begin
  if ((cvt_wr_en_d1 | op_en_d0) == 1'b1) begin
    cell_en_d0 <= cvt_cell_en_d1;
  // VCS coverage off
  end else if ((cvt_wr_en_d1 | op_en_d0) == 1'b0) begin
  end else begin
    cell_en_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_59x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_wr_en_d1 | op_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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


always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[0]) == 1'b1) begin
    oprand_0_0_d0 <= oprand_0_0;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[0]) == 1'b0) begin
  end else begin
    oprand_0_0_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[0]) == 1'b1) begin
    oprand_1_0_d0 <= oprand_1_0;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[0]) == 1'b0) begin
  end else begin
    oprand_1_0_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[1]) == 1'b1) begin
    oprand_0_1_d0 <= oprand_0_1;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[1]) == 1'b0) begin
  end else begin
    oprand_0_1_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[1]) == 1'b1) begin
    oprand_1_1_d0 <= oprand_1_1;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[1]) == 1'b0) begin
  end else begin
    oprand_1_1_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[2]) == 1'b1) begin
    oprand_0_2_d0 <= oprand_0_2;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[2]) == 1'b0) begin
  end else begin
    oprand_0_2_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[2]) == 1'b1) begin
    oprand_1_2_d0 <= oprand_1_2;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[2]) == 1'b0) begin
  end else begin
    oprand_1_2_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[3]) == 1'b1) begin
    oprand_0_3_d0 <= oprand_0_3;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[3]) == 1'b0) begin
  end else begin
    oprand_0_3_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[3]) == 1'b1) begin
    oprand_1_3_d0 <= oprand_1_3;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[3]) == 1'b0) begin
  end else begin
    oprand_1_3_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[4]) == 1'b1) begin
    oprand_0_4_d0 <= oprand_0_4;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[4]) == 1'b0) begin
  end else begin
    oprand_0_4_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[4]) == 1'b1) begin
    oprand_1_4_d0 <= oprand_1_4;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[4]) == 1'b0) begin
  end else begin
    oprand_1_4_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[5]) == 1'b1) begin
    oprand_0_5_d0 <= oprand_0_5;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[5]) == 1'b0) begin
  end else begin
    oprand_0_5_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[5]) == 1'b1) begin
    oprand_1_5_d0 <= oprand_1_5;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[5]) == 1'b0) begin
  end else begin
    oprand_1_5_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[6]) == 1'b1) begin
    oprand_0_6_d0 <= oprand_0_6;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[6]) == 1'b0) begin
  end else begin
    oprand_0_6_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[6]) == 1'b1) begin
    oprand_1_6_d0 <= oprand_1_6;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[6]) == 1'b0) begin
  end else begin
    oprand_1_6_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[7]) == 1'b1) begin
    oprand_0_7_d0 <= oprand_0_7;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[7]) == 1'b0) begin
  end else begin
    oprand_0_7_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[7]) == 1'b1) begin
    oprand_1_7_d0 <= oprand_1_7;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[7]) == 1'b0) begin
  end else begin
    oprand_1_7_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[8]) == 1'b1) begin
    oprand_0_8_d0 <= oprand_0_8;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[8]) == 1'b0) begin
  end else begin
    oprand_0_8_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[8]) == 1'b1) begin
    oprand_1_8_d0 <= oprand_1_8;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[8]) == 1'b0) begin
  end else begin
    oprand_1_8_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[9]) == 1'b1) begin
    oprand_0_9_d0 <= oprand_0_9;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[9]) == 1'b0) begin
  end else begin
    oprand_0_9_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[9]) == 1'b1) begin
    oprand_1_9_d0 <= oprand_1_9;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[9]) == 1'b0) begin
  end else begin
    oprand_1_9_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[10]) == 1'b1) begin
    oprand_0_10_d0 <= oprand_0_10;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[10]) == 1'b0) begin
  end else begin
    oprand_0_10_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[10]) == 1'b1) begin
    oprand_1_10_d0 <= oprand_1_10;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[10]) == 1'b0) begin
  end else begin
    oprand_1_10_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[11]) == 1'b1) begin
    oprand_0_11_d0 <= oprand_0_11;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[11]) == 1'b0) begin
  end else begin
    oprand_0_11_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[11]) == 1'b1) begin
    oprand_1_11_d0 <= oprand_1_11;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[11]) == 1'b0) begin
  end else begin
    oprand_1_11_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[12]) == 1'b1) begin
    oprand_0_12_d0 <= oprand_0_12;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[12]) == 1'b0) begin
  end else begin
    oprand_0_12_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[12]) == 1'b1) begin
    oprand_1_12_d0 <= oprand_1_12;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[12]) == 1'b0) begin
  end else begin
    oprand_1_12_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[13]) == 1'b1) begin
    oprand_0_13_d0 <= oprand_0_13;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[13]) == 1'b0) begin
  end else begin
    oprand_0_13_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[13]) == 1'b1) begin
    oprand_1_13_d0 <= oprand_1_13;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[13]) == 1'b0) begin
  end else begin
    oprand_1_13_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[14]) == 1'b1) begin
    oprand_0_14_d0 <= oprand_0_14;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[14]) == 1'b0) begin
  end else begin
    oprand_0_14_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[14]) == 1'b1) begin
    oprand_1_14_d0 <= oprand_1_14;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[14]) == 1'b0) begin
  end else begin
    oprand_1_14_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[15]) == 1'b1) begin
    oprand_0_15_d0 <= oprand_0_15;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[15]) == 1'b0) begin
  end else begin
    oprand_0_15_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[15]) == 1'b1) begin
    oprand_1_15_d0 <= oprand_1_15;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[15]) == 1'b0) begin
  end else begin
    oprand_1_15_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[16]) == 1'b1) begin
    oprand_0_16_d0 <= oprand_0_16;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[16]) == 1'b0) begin
  end else begin
    oprand_0_16_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[16]) == 1'b1) begin
    oprand_1_16_d0 <= oprand_1_16;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[16]) == 1'b0) begin
  end else begin
    oprand_1_16_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[17]) == 1'b1) begin
    oprand_0_17_d0 <= oprand_0_17;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[17]) == 1'b0) begin
  end else begin
    oprand_0_17_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[17]) == 1'b1) begin
    oprand_1_17_d0 <= oprand_1_17;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[17]) == 1'b0) begin
  end else begin
    oprand_1_17_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[18]) == 1'b1) begin
    oprand_0_18_d0 <= oprand_0_18;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[18]) == 1'b0) begin
  end else begin
    oprand_0_18_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[18]) == 1'b1) begin
    oprand_1_18_d0 <= oprand_1_18;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[18]) == 1'b0) begin
  end else begin
    oprand_1_18_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[19]) == 1'b1) begin
    oprand_0_19_d0 <= oprand_0_19;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[19]) == 1'b0) begin
  end else begin
    oprand_0_19_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[19]) == 1'b1) begin
    oprand_1_19_d0 <= oprand_1_19;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[19]) == 1'b0) begin
  end else begin
    oprand_1_19_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[20]) == 1'b1) begin
    oprand_0_20_d0 <= oprand_0_20;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[20]) == 1'b0) begin
  end else begin
    oprand_0_20_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[20]) == 1'b1) begin
    oprand_1_20_d0 <= oprand_1_20;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[20]) == 1'b0) begin
  end else begin
    oprand_1_20_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[21]) == 1'b1) begin
    oprand_0_21_d0 <= oprand_0_21;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[21]) == 1'b0) begin
  end else begin
    oprand_0_21_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[21]) == 1'b1) begin
    oprand_1_21_d0 <= oprand_1_21;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[21]) == 1'b0) begin
  end else begin
    oprand_1_21_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[22]) == 1'b1) begin
    oprand_0_22_d0 <= oprand_0_22;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[22]) == 1'b0) begin
  end else begin
    oprand_0_22_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[22]) == 1'b1) begin
    oprand_1_22_d0 <= oprand_1_22;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[22]) == 1'b0) begin
  end else begin
    oprand_1_22_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[23]) == 1'b1) begin
    oprand_0_23_d0 <= oprand_0_23;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[23]) == 1'b0) begin
  end else begin
    oprand_0_23_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[23]) == 1'b1) begin
    oprand_1_23_d0 <= oprand_1_23;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[23]) == 1'b0) begin
  end else begin
    oprand_1_23_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[24]) == 1'b1) begin
    oprand_0_24_d0 <= oprand_0_24;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[24]) == 1'b0) begin
  end else begin
    oprand_0_24_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[24]) == 1'b1) begin
    oprand_1_24_d0 <= oprand_1_24;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[24]) == 1'b0) begin
  end else begin
    oprand_1_24_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[25]) == 1'b1) begin
    oprand_0_25_d0 <= oprand_0_25;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[25]) == 1'b0) begin
  end else begin
    oprand_0_25_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[25]) == 1'b1) begin
    oprand_1_25_d0 <= oprand_1_25;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[25]) == 1'b0) begin
  end else begin
    oprand_1_25_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[26]) == 1'b1) begin
    oprand_0_26_d0 <= oprand_0_26;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[26]) == 1'b0) begin
  end else begin
    oprand_0_26_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[26]) == 1'b1) begin
    oprand_1_26_d0 <= oprand_1_26;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[26]) == 1'b0) begin
  end else begin
    oprand_1_26_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[27]) == 1'b1) begin
    oprand_0_27_d0 <= oprand_0_27;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[27]) == 1'b0) begin
  end else begin
    oprand_0_27_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[27]) == 1'b1) begin
    oprand_1_27_d0 <= oprand_1_27;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[27]) == 1'b0) begin
  end else begin
    oprand_1_27_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[28]) == 1'b1) begin
    oprand_0_28_d0 <= oprand_0_28;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[28]) == 1'b0) begin
  end else begin
    oprand_0_28_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[28]) == 1'b1) begin
    oprand_1_28_d0 <= oprand_1_28;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[28]) == 1'b0) begin
  end else begin
    oprand_1_28_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[29]) == 1'b1) begin
    oprand_0_29_d0 <= oprand_0_29;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[29]) == 1'b0) begin
  end else begin
    oprand_0_29_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[29]) == 1'b1) begin
    oprand_1_29_d0 <= oprand_1_29;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[29]) == 1'b0) begin
  end else begin
    oprand_1_29_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[30]) == 1'b1) begin
    oprand_0_30_d0 <= oprand_0_30;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[30]) == 1'b0) begin
  end else begin
    oprand_0_30_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[30]) == 1'b1) begin
    oprand_1_30_d0 <= oprand_1_30;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[30]) == 1'b0) begin
  end else begin
    oprand_1_30_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[31]) == 1'b1) begin
    oprand_0_31_d0 <= oprand_0_31;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[31]) == 1'b0) begin
  end else begin
    oprand_0_31_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[31]) == 1'b1) begin
    oprand_1_31_d0 <= oprand_1_31;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[31]) == 1'b0) begin
  end else begin
    oprand_1_31_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[32]) == 1'b1) begin
    oprand_0_32_d0 <= oprand_0_32;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[32]) == 1'b0) begin
  end else begin
    oprand_0_32_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[32]) == 1'b1) begin
    oprand_1_32_d0 <= oprand_1_32;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[32]) == 1'b0) begin
  end else begin
    oprand_1_32_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[33]) == 1'b1) begin
    oprand_0_33_d0 <= oprand_0_33;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[33]) == 1'b0) begin
  end else begin
    oprand_0_33_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[33]) == 1'b1) begin
    oprand_1_33_d0 <= oprand_1_33;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[33]) == 1'b0) begin
  end else begin
    oprand_1_33_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[34]) == 1'b1) begin
    oprand_0_34_d0 <= oprand_0_34;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[34]) == 1'b0) begin
  end else begin
    oprand_0_34_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[34]) == 1'b1) begin
    oprand_1_34_d0 <= oprand_1_34;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[34]) == 1'b0) begin
  end else begin
    oprand_1_34_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[35]) == 1'b1) begin
    oprand_0_35_d0 <= oprand_0_35;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[35]) == 1'b0) begin
  end else begin
    oprand_0_35_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[35]) == 1'b1) begin
    oprand_1_35_d0 <= oprand_1_35;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[35]) == 1'b0) begin
  end else begin
    oprand_1_35_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[36]) == 1'b1) begin
    oprand_0_36_d0 <= oprand_0_36;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[36]) == 1'b0) begin
  end else begin
    oprand_0_36_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[36]) == 1'b1) begin
    oprand_1_36_d0 <= oprand_1_36;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[36]) == 1'b0) begin
  end else begin
    oprand_1_36_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[37]) == 1'b1) begin
    oprand_0_37_d0 <= oprand_0_37;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[37]) == 1'b0) begin
  end else begin
    oprand_0_37_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[37]) == 1'b1) begin
    oprand_1_37_d0 <= oprand_1_37;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[37]) == 1'b0) begin
  end else begin
    oprand_1_37_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[38]) == 1'b1) begin
    oprand_0_38_d0 <= oprand_0_38;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[38]) == 1'b0) begin
  end else begin
    oprand_0_38_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[38]) == 1'b1) begin
    oprand_1_38_d0 <= oprand_1_38;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[38]) == 1'b0) begin
  end else begin
    oprand_1_38_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[39]) == 1'b1) begin
    oprand_0_39_d0 <= oprand_0_39;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[39]) == 1'b0) begin
  end else begin
    oprand_0_39_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[39]) == 1'b1) begin
    oprand_1_39_d0 <= oprand_1_39;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[39]) == 1'b0) begin
  end else begin
    oprand_1_39_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[40]) == 1'b1) begin
    oprand_0_40_d0 <= oprand_0_40;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[40]) == 1'b0) begin
  end else begin
    oprand_0_40_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[40]) == 1'b1) begin
    oprand_1_40_d0 <= oprand_1_40;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[40]) == 1'b0) begin
  end else begin
    oprand_1_40_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[41]) == 1'b1) begin
    oprand_0_41_d0 <= oprand_0_41;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[41]) == 1'b0) begin
  end else begin
    oprand_0_41_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[41]) == 1'b1) begin
    oprand_1_41_d0 <= oprand_1_41;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[41]) == 1'b0) begin
  end else begin
    oprand_1_41_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[42]) == 1'b1) begin
    oprand_0_42_d0 <= oprand_0_42;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[42]) == 1'b0) begin
  end else begin
    oprand_0_42_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[42]) == 1'b1) begin
    oprand_1_42_d0 <= oprand_1_42;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[42]) == 1'b0) begin
  end else begin
    oprand_1_42_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[43]) == 1'b1) begin
    oprand_0_43_d0 <= oprand_0_43;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[43]) == 1'b0) begin
  end else begin
    oprand_0_43_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[43]) == 1'b1) begin
    oprand_1_43_d0 <= oprand_1_43;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[43]) == 1'b0) begin
  end else begin
    oprand_1_43_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[44]) == 1'b1) begin
    oprand_0_44_d0 <= oprand_0_44;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[44]) == 1'b0) begin
  end else begin
    oprand_0_44_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[44]) == 1'b1) begin
    oprand_1_44_d0 <= oprand_1_44;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[44]) == 1'b0) begin
  end else begin
    oprand_1_44_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[45]) == 1'b1) begin
    oprand_0_45_d0 <= oprand_0_45;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[45]) == 1'b0) begin
  end else begin
    oprand_0_45_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[45]) == 1'b1) begin
    oprand_1_45_d0 <= oprand_1_45;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[45]) == 1'b0) begin
  end else begin
    oprand_1_45_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[46]) == 1'b1) begin
    oprand_0_46_d0 <= oprand_0_46;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[46]) == 1'b0) begin
  end else begin
    oprand_0_46_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[46]) == 1'b1) begin
    oprand_1_46_d0 <= oprand_1_46;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[46]) == 1'b0) begin
  end else begin
    oprand_1_46_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[47]) == 1'b1) begin
    oprand_0_47_d0 <= oprand_0_47;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[47]) == 1'b0) begin
  end else begin
    oprand_0_47_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[47]) == 1'b1) begin
    oprand_1_47_d0 <= oprand_1_47;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[47]) == 1'b0) begin
  end else begin
    oprand_1_47_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[48]) == 1'b1) begin
    oprand_0_48_d0 <= oprand_0_48;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[48]) == 1'b0) begin
  end else begin
    oprand_0_48_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[48]) == 1'b1) begin
    oprand_1_48_d0 <= oprand_1_48;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[48]) == 1'b0) begin
  end else begin
    oprand_1_48_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[49]) == 1'b1) begin
    oprand_0_49_d0 <= oprand_0_49;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[49]) == 1'b0) begin
  end else begin
    oprand_0_49_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[49]) == 1'b1) begin
    oprand_1_49_d0 <= oprand_1_49;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[49]) == 1'b0) begin
  end else begin
    oprand_1_49_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[50]) == 1'b1) begin
    oprand_0_50_d0 <= oprand_0_50;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[50]) == 1'b0) begin
  end else begin
    oprand_0_50_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[50]) == 1'b1) begin
    oprand_1_50_d0 <= oprand_1_50;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[50]) == 1'b0) begin
  end else begin
    oprand_1_50_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[51]) == 1'b1) begin
    oprand_0_51_d0 <= oprand_0_51;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[51]) == 1'b0) begin
  end else begin
    oprand_0_51_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[51]) == 1'b1) begin
    oprand_1_51_d0 <= oprand_1_51;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[51]) == 1'b0) begin
  end else begin
    oprand_1_51_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[52]) == 1'b1) begin
    oprand_0_52_d0 <= oprand_0_52;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[52]) == 1'b0) begin
  end else begin
    oprand_0_52_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[52]) == 1'b1) begin
    oprand_1_52_d0 <= oprand_1_52;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[52]) == 1'b0) begin
  end else begin
    oprand_1_52_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[53]) == 1'b1) begin
    oprand_0_53_d0 <= oprand_0_53;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[53]) == 1'b0) begin
  end else begin
    oprand_0_53_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[53]) == 1'b1) begin
    oprand_1_53_d0 <= oprand_1_53;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[53]) == 1'b0) begin
  end else begin
    oprand_1_53_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[54]) == 1'b1) begin
    oprand_0_54_d0 <= oprand_0_54;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[54]) == 1'b0) begin
  end else begin
    oprand_0_54_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[54]) == 1'b1) begin
    oprand_1_54_d0 <= oprand_1_54;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[54]) == 1'b0) begin
  end else begin
    oprand_1_54_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[55]) == 1'b1) begin
    oprand_0_55_d0 <= oprand_0_55;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[55]) == 1'b0) begin
  end else begin
    oprand_0_55_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[55]) == 1'b1) begin
    oprand_1_55_d0 <= oprand_1_55;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[55]) == 1'b0) begin
  end else begin
    oprand_1_55_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[56]) == 1'b1) begin
    oprand_0_56_d0 <= oprand_0_56;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[56]) == 1'b0) begin
  end else begin
    oprand_0_56_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[56]) == 1'b1) begin
    oprand_1_56_d0 <= oprand_1_56;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[56]) == 1'b0) begin
  end else begin
    oprand_1_56_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[57]) == 1'b1) begin
    oprand_0_57_d0 <= oprand_0_57;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[57]) == 1'b0) begin
  end else begin
    oprand_0_57_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[57]) == 1'b1) begin
    oprand_1_57_d0 <= oprand_1_57;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[57]) == 1'b0) begin
  end else begin
    oprand_1_57_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[58]) == 1'b1) begin
    oprand_0_58_d0 <= oprand_0_58;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[58]) == 1'b0) begin
  end else begin
    oprand_0_58_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[58]) == 1'b1) begin
    oprand_1_58_d0 <= oprand_1_58;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[58]) == 1'b0) begin
  end else begin
    oprand_1_58_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[59]) == 1'b1) begin
    oprand_0_59_d0 <= oprand_0_59;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[59]) == 1'b0) begin
  end else begin
    oprand_0_59_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[59]) == 1'b1) begin
    oprand_1_59_d0 <= oprand_1_59;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[59]) == 1'b0) begin
  end else begin
    oprand_1_59_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[60]) == 1'b1) begin
    oprand_0_60_d0 <= oprand_0_60;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[60]) == 1'b0) begin
  end else begin
    oprand_0_60_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[60]) == 1'b1) begin
    oprand_1_60_d0 <= oprand_1_60;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[60]) == 1'b0) begin
  end else begin
    oprand_1_60_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[61]) == 1'b1) begin
    oprand_0_61_d0 <= oprand_0_61;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[61]) == 1'b0) begin
  end else begin
    oprand_0_61_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[61]) == 1'b1) begin
    oprand_1_61_d0 <= oprand_1_61;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[61]) == 1'b0) begin
  end else begin
    oprand_1_61_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[62]) == 1'b1) begin
    oprand_0_62_d0 <= oprand_0_62;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[62]) == 1'b0) begin
  end else begin
    oprand_0_62_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[62]) == 1'b1) begin
    oprand_1_62_d0 <= oprand_1_62;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[62]) == 1'b0) begin
  end else begin
    oprand_1_62_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[63]) == 1'b1) begin
    oprand_0_63_d0 <= oprand_0_63;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[63]) == 1'b0) begin
  end else begin
    oprand_0_63_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_cell_en_d1[63]) == 1'b1) begin
    oprand_1_63_d0 <= oprand_1_63;
  // VCS coverage off
  end else if ((cvt_cell_en_d1[63]) == 1'b0) begin
  end else begin
    oprand_1_63_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

////////////////////////////////////////////////////////////////////////
//  instance of convert cells                                         //
////////////////////////////////////////////////////////////////////////


always @(
  cfg_in_precision
  ) begin
    {cfg_in_precision_15[1:0], cfg_in_precision_14[1:0], cfg_in_precision_13[1:0], cfg_in_precision_12[1:0], cfg_in_precision_11[1:0], cfg_in_precision_10[1:0], cfg_in_precision_9[1:0], cfg_in_precision_8[1:0], cfg_in_precision_7[1:0], cfg_in_precision_6[1:0], cfg_in_precision_5[1:0], cfg_in_precision_4[1:0], cfg_in_precision_3[1:0], cfg_in_precision_2[1:0], cfg_in_precision_1[1:0], cfg_in_precision_0[1:0]} = cfg_in_precision;
end

always @(
  cfg_proc_precision
  ) begin
    {cfg_proc_precision_15[1:0], cfg_proc_precision_14[1:0], cfg_proc_precision_13[1:0], cfg_proc_precision_12[1:0], cfg_proc_precision_11[1:0], cfg_proc_precision_10[1:0], cfg_proc_precision_9[1:0], cfg_proc_precision_8[1:0], cfg_proc_precision_7[1:0], cfg_proc_precision_6[1:0], cfg_proc_precision_5[1:0], cfg_proc_precision_4[1:0], cfg_proc_precision_3[1:0], cfg_proc_precision_2[1:0], cfg_proc_precision_1[1:0], cfg_proc_precision_0[1:0]} = cfg_proc_precision;
end

always @(
  cfg_scale
  ) begin
    {cfg_scale_15[15:0], cfg_scale_14[15:0], cfg_scale_13[15:0], cfg_scale_12[15:0], cfg_scale_11[15:0], cfg_scale_10[15:0], cfg_scale_9[15:0], cfg_scale_8[15:0], cfg_scale_7[15:0], cfg_scale_6[15:0], cfg_scale_5[15:0], cfg_scale_4[15:0], cfg_scale_3[15:0], cfg_scale_2[15:0], cfg_scale_1[15:0], cfg_scale_0[15:0]} = cfg_scale;
end

always @(
  cfg_truncate
  ) begin
    {cfg_truncate_15[5:0], cfg_truncate_14[5:0], cfg_truncate_13[5:0], cfg_truncate_12[5:0], cfg_truncate_11[5:0], cfg_truncate_10[5:0], cfg_truncate_9[5:0], cfg_truncate_8[5:0], cfg_truncate_7[5:0], cfg_truncate_6[5:0], cfg_truncate_5[5:0], cfg_truncate_4[5:0], cfg_truncate_3[5:0], cfg_truncate_2[5:0], cfg_truncate_1[5:0], cfg_truncate_0[5:0]} = cfg_truncate;
end


NV_NVDLA_CDMA_CVT_cell u_cell_0 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_0_d0[16:0])        //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[0])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[0])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_0_d0[15:0])        //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[0])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[0])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_0[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_0[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_0[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_0[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_0[15:0])            //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_1 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_1_d0[16:0])        //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[1])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[1])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_1_d0[15:0])        //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[1])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[1])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_0[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_0[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_0[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_0[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_1[15:0])            //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_2 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_2_d0[16:0])        //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[2])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[2])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_2_d0[15:0])        //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[2])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[2])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_0[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_0[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_0[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_0[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_2[15:0])            //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_3 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_3_d0[16:0])        //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[3])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[3])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_3_d0[15:0])        //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[3])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[3])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_0[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_0[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_0[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_0[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_3[15:0])            //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_4 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_4_d0[16:0])        //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[4])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[4])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_4_d0[15:0])        //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[4])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[4])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_1[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_1[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_1[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_1[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_4[15:0])            //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_5 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_5_d0[16:0])        //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[5])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[5])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_5_d0[15:0])        //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[5])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[5])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_1[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_1[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_1[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_1[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_5[15:0])            //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_6 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_6_d0[16:0])        //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[6])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[6])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_6_d0[15:0])        //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[6])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[6])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_1[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_1[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_1[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_1[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_6[15:0])            //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_7 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_7_d0[16:0])        //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[7])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[7])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_7_d0[15:0])        //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[7])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[7])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_1[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_1[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_1[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_1[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_7[15:0])            //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_8 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_8_d0[16:0])        //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[8])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[8])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_8_d0[15:0])        //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[8])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[8])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_2[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_2[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_2[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_2[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_8[15:0])            //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_9 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_9_d0[16:0])        //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[9])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[9])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_9_d0[15:0])        //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[9])              //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[9])      //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_2[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_2[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_2[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_2[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_9[15:0])            //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_10 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_10_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[10])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[10])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_10_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[10])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[10])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_2[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_2[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_2[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_2[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_10[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_11 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_11_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[11])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[11])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_11_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[11])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[11])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_2[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_2[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_2[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_2[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_11[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_12 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_12_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[12])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[12])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_12_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[12])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[12])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_3[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_3[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_3[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_3[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_12[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_13 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_13_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[13])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[13])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_13_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[13])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[13])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_3[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_3[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_3[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_3[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_13[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_14 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_14_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[14])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[14])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_14_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[14])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[14])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_3[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_3[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_3[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_3[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_14[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_15 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_15_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[15])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[15])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_15_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[15])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[15])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_3[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_3[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_3[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_3[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_15[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_16 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_16_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[16])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[16])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_16_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[16])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[16])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_4[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_4[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_4[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_4[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_16[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_17 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_17_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[17])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[17])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_17_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[17])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[17])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_4[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_4[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_4[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_4[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_17[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_18 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_18_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[18])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[18])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_18_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[18])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[18])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_4[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_4[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_4[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_4[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_18[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_19 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_19_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[19])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[19])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_19_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[19])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[19])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_4[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_4[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_4[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_4[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_19[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_20 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_20_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[20])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[20])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_20_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[20])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[20])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_5[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_5[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_5[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_5[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_20[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_21 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_21_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[21])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[21])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_21_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[21])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[21])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_5[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_5[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_5[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_5[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_21[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_22 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_22_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[22])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[22])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_22_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[22])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[22])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_5[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_5[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_5[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_5[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_22[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_23 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_23_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[23])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[23])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_23_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[23])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[23])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_5[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_5[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_5[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_5[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_23[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_24 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_24_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[24])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[24])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_24_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[24])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[24])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_6[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_6[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_6[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_6[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_24[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_25 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_25_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[25])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[25])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_25_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[25])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[25])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_6[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_6[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_6[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_6[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_25[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_26 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_26_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[26])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[26])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_26_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[26])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[26])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_6[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_6[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_6[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_6[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_26[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_27 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_27_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[27])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[27])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_27_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[27])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[27])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_6[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_6[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_6[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_6[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_27[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_28 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_28_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[28])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[28])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_28_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[28])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[28])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_7[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_7[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_7[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_7[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_28[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_29 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_29_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[29])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[29])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_29_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[29])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[29])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_7[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_7[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_7[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_7[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_29[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_30 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_30_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[30])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[30])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_30_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[30])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[30])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_7[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_7[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_7[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_7[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_30[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_31 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_31_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[31])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[31])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_31_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[31])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[31])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_7[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_7[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_7[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_7[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_31[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_32 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_32_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[32])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[32])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_32_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[32])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[32])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_8[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_8[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_8[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_8[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_32[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_33 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_33_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[33])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[33])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_33_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[33])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[33])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_8[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_8[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_8[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_8[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_33[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_34 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_34_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[34])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[34])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_34_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[34])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[34])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_8[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_8[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_8[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_8[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_34[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_35 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_35_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[35])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[35])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_35_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[35])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[35])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_8[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_8[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_8[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_8[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_35[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_36 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_36_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[36])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[36])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_36_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[36])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[36])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_9[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_9[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_9[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_9[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_36[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_37 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_37_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[37])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[37])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_37_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[37])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[37])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_9[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_9[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_9[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_9[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_37[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_38 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_38_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[38])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[38])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_38_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[38])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[38])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_9[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_9[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_9[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_9[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_38[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_39 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_39_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[39])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[39])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_39_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[39])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[39])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_9[15:0])          //|< r
  ,.cfg_in_precision    (cfg_in_precision_9[1:0])    //|< r
  ,.cfg_out_precision   (cfg_proc_precision_9[1:0])  //|< r
  ,.cfg_truncate        (cfg_truncate_9[5:0])        //|< r
  ,.chn_data_out_rsc_z  (cellout_39[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_40 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_40_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[40])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[40])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_40_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[40])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[40])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_10[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_10[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_10[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_10[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_40[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_41 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_41_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[41])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[41])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_41_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[41])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[41])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_10[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_10[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_10[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_10[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_41[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_42 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_42_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[42])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[42])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_42_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[42])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[42])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_10[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_10[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_10[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_10[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_42[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_43 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_43_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[43])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[43])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_43_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[43])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[43])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_10[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_10[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_10[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_10[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_43[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_44 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_44_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[44])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[44])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_44_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[44])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[44])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_11[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_11[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_11[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_11[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_44[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_45 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_45_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[45])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[45])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_45_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[45])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[45])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_11[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_11[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_11[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_11[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_45[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_46 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_46_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[46])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[46])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_46_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[46])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[46])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_11[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_11[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_11[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_11[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_46[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_47 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_47_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[47])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[47])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_47_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[47])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[47])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_11[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_11[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_11[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_11[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_47[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_48 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_48_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[48])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[48])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_48_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[48])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[48])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_12[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_12[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_12[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_12[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_48[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_49 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_49_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[49])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[49])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_49_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[49])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[49])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_12[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_12[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_12[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_12[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_49[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_50 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_50_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[50])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[50])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_50_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[50])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[50])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_12[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_12[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_12[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_12[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_50[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_51 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_51_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[51])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[51])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_51_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[51])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[51])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_12[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_12[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_12[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_12[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_51[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_52 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_52_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[52])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[52])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_52_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[52])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[52])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_13[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_13[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_13[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_13[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_52[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_53 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_53_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[53])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[53])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_53_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[53])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[53])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_13[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_13[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_13[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_13[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_53[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_54 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_54_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[54])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[54])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_54_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[54])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[54])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_13[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_13[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_13[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_13[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_54[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_55 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_55_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[55])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[55])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_55_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[55])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[55])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_13[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_13[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_13[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_13[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_55[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_56 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_56_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[56])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[56])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_56_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[56])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[56])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_14[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_14[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_14[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_14[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_56[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_57 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_57_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[57])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[57])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_57_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[57])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[57])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_14[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_14[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_14[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_14[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_57[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_58 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_58_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[58])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[58])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_58_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[58])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[58])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_14[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_14[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_14[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_14[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_58[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_59 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_59_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[59])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[59])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_59_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[59])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[59])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_14[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_14[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_14[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_14[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_59[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_60 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_60_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[60])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[60])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_60_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[60])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[60])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_15[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_15[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_15[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_15[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_60[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_61 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_61_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[61])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[61])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_61_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[61])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[61])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_15[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_15[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_15[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_15[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_61[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_62 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_62_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[62])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[62])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_62_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[62])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[62])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_15[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_15[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_15[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_15[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_62[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );


NV_NVDLA_CDMA_CVT_cell u_cell_63 (
   .nvdla_core_clk      (nvdla_hls_clk)              //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)            //|< i
  ,.chn_data_in_rsc_z   (oprand_0_63_d0[16:0])       //|< r
  ,.chn_data_in_rsc_vz  (cell_en_d0[63])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_cell_op0_ready[63])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_z    (oprand_1_63_d0[15:0])       //|< r
  ,.chn_alu_in_rsc_vz   (cell_en_d0[63])             //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_alu_in_rsc_lz   (mon_cell_op1_ready[63])     //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_mul_in_rsc_z    (cfg_scale_15[15:0])         //|< r
  ,.cfg_in_precision    (cfg_in_precision_15[1:0])   //|< r
  ,.cfg_out_precision   (cfg_proc_precision_15[1:0]) //|< r
  ,.cfg_truncate        (cfg_truncate_15[5:0])       //|< r
  ,.chn_data_out_rsc_z  (cellout_63[15:0])           //|> w
  ,.chn_data_out_rsc_vz (1'b1)                       //|< ?
  ,.chn_data_out_rsc_lz ()                           //|> ?
  );






always @(
  cellout_63
  or cellout_62
  or cellout_61
  or cellout_60
  or cellout_59
  or cellout_58
  or cellout_57
  or cellout_56
  or cellout_55
  or cellout_54
  or cellout_53
  or cellout_52
  or cellout_51
  or cellout_50
  or cellout_49
  or cellout_48
  or cellout_47
  or cellout_46
  or cellout_45
  or cellout_44
  or cellout_43
  or cellout_42
  or cellout_41
  or cellout_40
  or cellout_39
  or cellout_38
  or cellout_37
  or cellout_36
  or cellout_35
  or cellout_34
  or cellout_33
  or cellout_32
  or cellout_31
  or cellout_30
  or cellout_29
  or cellout_28
  or cellout_27
  or cellout_26
  or cellout_25
  or cellout_24
  or cellout_23
  or cellout_22
  or cellout_21
  or cellout_20
  or cellout_19
  or cellout_18
  or cellout_17
  or cellout_16
  or cellout_15
  or cellout_14
  or cellout_13
  or cellout_12
  or cellout_11
  or cellout_10
  or cellout_9
  or cellout_8
  or cellout_7
  or cellout_6
  or cellout_5
  or cellout_4
  or cellout_3
  or cellout_2
  or cellout_1
  or cellout_0
  ) begin
    cvt_data_cell_16b = {cellout_63, cellout_62, cellout_61, cellout_60, cellout_59, cellout_58, cellout_57, cellout_56, cellout_55, cellout_54, cellout_53, cellout_52, cellout_51, cellout_50, cellout_49, cellout_48, cellout_47, cellout_46, cellout_45, cellout_44, cellout_43, cellout_42, cellout_41, cellout_40, cellout_39, cellout_38, cellout_37, cellout_36, cellout_35, cellout_34, cellout_33, cellout_32, cellout_31, cellout_30, cellout_29, cellout_28, cellout_27, cellout_26, cellout_25, cellout_24, cellout_23, cellout_22, cellout_21, cellout_20, cellout_19, cellout_18, cellout_17, cellout_16, cellout_15, cellout_14, cellout_13, cellout_12, cellout_11, cellout_10, cellout_9, cellout_8, cellout_7, cellout_6, cellout_5, cellout_4, cellout_3, cellout_2, cellout_1, cellout_0};
end

always @(
  cellout_63
  or cellout_62
  or cellout_61
  or cellout_60
  or cellout_59
  or cellout_58
  or cellout_57
  or cellout_56
  or cellout_55
  or cellout_54
  or cellout_53
  or cellout_52
  or cellout_51
  or cellout_50
  or cellout_49
  or cellout_48
  or cellout_47
  or cellout_46
  or cellout_45
  or cellout_44
  or cellout_43
  or cellout_42
  or cellout_41
  or cellout_40
  or cellout_39
  or cellout_38
  or cellout_37
  or cellout_36
  or cellout_35
  or cellout_34
  or cellout_33
  or cellout_32
  or cellout_31
  or cellout_30
  or cellout_29
  or cellout_28
  or cellout_27
  or cellout_26
  or cellout_25
  or cellout_24
  or cellout_23
  or cellout_22
  or cellout_21
  or cellout_20
  or cellout_19
  or cellout_18
  or cellout_17
  or cellout_16
  or cellout_15
  or cellout_14
  or cellout_13
  or cellout_12
  or cellout_11
  or cellout_10
  or cellout_9
  or cellout_8
  or cellout_7
  or cellout_6
  or cellout_5
  or cellout_4
  or cellout_3
  or cellout_2
  or cellout_1
  or cellout_0
  ) begin
    cvt_data_cell_8b = {cellout_63[7:0], cellout_62[7:0], cellout_61[7:0], cellout_60[7:0], cellout_59[7:0], cellout_58[7:0], cellout_57[7:0], cellout_56[7:0], cellout_55[7:0], cellout_54[7:0], cellout_53[7:0], cellout_52[7:0], cellout_51[7:0], cellout_50[7:0], cellout_49[7:0], cellout_48[7:0], cellout_47[7:0], cellout_46[7:0], cellout_45[7:0], cellout_44[7:0], cellout_43[7:0], cellout_42[7:0], cellout_41[7:0], cellout_40[7:0], cellout_39[7:0], cellout_38[7:0], cellout_37[7:0], cellout_36[7:0], cellout_35[7:0], cellout_34[7:0], cellout_33[7:0], cellout_32[7:0], cellout_31[7:0], cellout_30[7:0], cellout_29[7:0], cellout_28[7:0], cellout_27[7:0], cellout_26[7:0], cellout_25[7:0], cellout_24[7:0], cellout_23[7:0], cellout_22[7:0], cellout_21[7:0], cellout_20[7:0], cellout_19[7:0], cellout_18[7:0], cellout_17[7:0], cellout_16[7:0], cellout_15[7:0], cellout_14[7:0], cellout_13[7:0], cellout_12[7:0], cellout_11[7:0], cellout_10[7:0], cellout_9[7:0], cellout_8[7:0], cellout_7[7:0], cellout_6[7:0], cellout_5[7:0], cellout_4[7:0], cellout_3[7:0], cellout_2[7:0], cellout_1[7:0], cellout_0[7:0]};
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
  nv_assert_never #(0,0,"Error! cell op0 is not ready when input valid!")      zzz_assert_never_60x (nvdla_core_clk, `ASSERT_RESET, ((|(cell_en_d0 & ~mon_cell_op0_ready)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! cell op1 is not ready when input valid!")      zzz_assert_never_61x (nvdla_core_clk, `ASSERT_RESET, ((|(cell_en_d0 & ~mon_cell_op1_ready)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
//  stage 2: pipeline to match latency of conver cells                //
////////////////////////////////////////////////////////////////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_vld_d2 <= 1'b0;
  end else begin
  cvt_out_vld_d2 <= cvt_out_vld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_pad_vld_d2 <= 1'b0;
  end else begin
  cvt_out_pad_vld_d2 <= cvt_out_pad_vld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_hold_en_d2 <= 1'b0;
  end else begin
  cvt_hold_en_d2 <= cvt_hold_en_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_hsel_d2 <= {2{1'b0}};
  end else begin
  if ((cvt_out_vld_d1) == 1'b1) begin
    cvt_out_hsel_d2 <= cvt_out_hsel_d1;
  // VCS coverage off
  end else if ((cvt_out_vld_d1) == 1'b0) begin
  end else begin
    cvt_out_hsel_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_addr_d2 <= {12{1'b0}};
  end else begin
  if ((cvt_out_vld_d1) == 1'b1) begin
    cvt_out_addr_d2 <= cvt_out_addr_d1;
  // VCS coverage off
  end else if ((cvt_out_vld_d1) == 1'b0) begin
  end else begin
    cvt_out_addr_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_63x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_line_idx_d2 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d1 | cvt_hold_en_d1) == 1'b1) begin
    cvt_line_idx_d2 <= cvt_line_idx_d1;
  // VCS coverage off
  end else if ((cvt_out_vld_d1 | cvt_hold_en_d1) == 1'b0) begin
  end else begin
    cvt_line_idx_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_64x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1 | cvt_hold_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_nz_mask_d2 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d1) == 1'b1) begin
    cvt_out_nz_mask_d2 <= cvt_out_nz_mask_d1;
  // VCS coverage off
  end else if ((cvt_out_vld_d1) == 1'b0) begin
  end else begin
    cvt_out_nz_mask_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_65x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_pad_mask_d2 <= {128{1'b0}};
  end else begin
  if ((cvt_out_pad_vld_d1) == 1'b1) begin
    cvt_out_pad_mask_d2 <= cvt_out_pad_mask_d1;
  // VCS coverage off
  end else if ((cvt_out_pad_vld_d1) == 1'b0) begin
  end else begin
    cvt_out_pad_mask_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_pad_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_reg_en_d2 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d1 | cvt_out_vld_d2) == 1'b1) begin
    cvt_out_reg_en_d2 <= cvt_out_reg_en_d1;
  // VCS coverage off
  end else if ((cvt_out_vld_d1 | cvt_out_vld_d2) == 1'b0) begin
  end else begin
    cvt_out_reg_en_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1 | cvt_out_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_cell_out_sel_hold_d2 <= 1'b0;
  end else begin
  if ((cvt_out_vld_d1) == 1'b1) begin
    cvt_cell_out_sel_hold_d2 <= cvt_cell_out_sel_hold_d1;
  // VCS coverage off
  end else if ((cvt_out_vld_d1) == 1'b0) begin
  end else begin
    cvt_cell_out_sel_hold_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_vld_d3 <= 1'b0;
  end else begin
  cvt_out_vld_d3 <= cvt_out_vld_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_pad_vld_d3 <= 1'b0;
  end else begin
  cvt_out_pad_vld_d3 <= cvt_out_pad_vld_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_hold_en_d3 <= 1'b0;
  end else begin
  cvt_hold_en_d3 <= cvt_hold_en_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_hsel_d3 <= {2{1'b0}};
  end else begin
  if ((cvt_out_vld_d2) == 1'b1) begin
    cvt_out_hsel_d3 <= cvt_out_hsel_d2;
  // VCS coverage off
  end else if ((cvt_out_vld_d2) == 1'b0) begin
  end else begin
    cvt_out_hsel_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_addr_d3 <= {12{1'b0}};
  end else begin
  if ((cvt_out_vld_d2) == 1'b1) begin
    cvt_out_addr_d3 <= cvt_out_addr_d2;
  // VCS coverage off
  end else if ((cvt_out_vld_d2) == 1'b0) begin
  end else begin
    cvt_out_addr_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_70x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_line_idx_d3 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d2 | cvt_hold_en_d2) == 1'b1) begin
    cvt_line_idx_d3 <= cvt_line_idx_d2;
  // VCS coverage off
  end else if ((cvt_out_vld_d2 | cvt_hold_en_d2) == 1'b0) begin
  end else begin
    cvt_line_idx_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_71x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2 | cvt_hold_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_nz_mask_d3 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d2) == 1'b1) begin
    cvt_out_nz_mask_d3 <= cvt_out_nz_mask_d2;
  // VCS coverage off
  end else if ((cvt_out_vld_d2) == 1'b0) begin
  end else begin
    cvt_out_nz_mask_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_72x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_pad_mask_d3 <= {128{1'b0}};
  end else begin
  if ((cvt_out_pad_vld_d2) == 1'b1) begin
    cvt_out_pad_mask_d3 <= cvt_out_pad_mask_d2;
  // VCS coverage off
  end else if ((cvt_out_pad_vld_d2) == 1'b0) begin
  end else begin
    cvt_out_pad_mask_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_73x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_pad_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_reg_en_d3 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d2 | cvt_out_vld_d3) == 1'b1) begin
    cvt_out_reg_en_d3 <= cvt_out_reg_en_d2;
  // VCS coverage off
  end else if ((cvt_out_vld_d2 | cvt_out_vld_d3) == 1'b0) begin
  end else begin
    cvt_out_reg_en_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_74x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2 | cvt_out_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_cell_out_sel_hold_d3 <= 1'b0;
  end else begin
  if ((cvt_out_vld_d2) == 1'b1) begin
    cvt_cell_out_sel_hold_d3 <= cvt_cell_out_sel_hold_d2;
  // VCS coverage off
  end else if ((cvt_out_vld_d2) == 1'b0) begin
  end else begin
    cvt_cell_out_sel_hold_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_vld_d4 <= 1'b0;
  end else begin
  cvt_out_vld_d4 <= cvt_out_vld_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_pad_vld_d4 <= 1'b0;
  end else begin
  cvt_out_pad_vld_d4 <= cvt_out_pad_vld_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_hold_en_d4 <= 1'b0;
  end else begin
  cvt_hold_en_d4 <= cvt_hold_en_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_hsel_d4 <= {2{1'b0}};
  end else begin
  if ((cvt_out_vld_d3) == 1'b1) begin
    cvt_out_hsel_d4 <= cvt_out_hsel_d3;
  // VCS coverage off
  end else if ((cvt_out_vld_d3) == 1'b0) begin
  end else begin
    cvt_out_hsel_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_addr_d4 <= {12{1'b0}};
  end else begin
  if ((cvt_out_vld_d3) == 1'b1) begin
    cvt_out_addr_d4 <= cvt_out_addr_d3;
  // VCS coverage off
  end else if ((cvt_out_vld_d3) == 1'b0) begin
  end else begin
    cvt_out_addr_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_line_idx_d4 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d3 | cvt_hold_en_d3) == 1'b1) begin
    cvt_line_idx_d4 <= cvt_line_idx_d3;
  // VCS coverage off
  end else if ((cvt_out_vld_d3 | cvt_hold_en_d3) == 1'b0) begin
  end else begin
    cvt_line_idx_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_78x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3 | cvt_hold_en_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_nz_mask_d4 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d3) == 1'b1) begin
    cvt_out_nz_mask_d4 <= cvt_out_nz_mask_d3;
  // VCS coverage off
  end else if ((cvt_out_vld_d3) == 1'b0) begin
  end else begin
    cvt_out_nz_mask_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_79x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_pad_mask_d4 <= {128{1'b0}};
  end else begin
  if ((cvt_out_pad_vld_d3) == 1'b1) begin
    cvt_out_pad_mask_d4 <= cvt_out_pad_mask_d3;
  // VCS coverage off
  end else if ((cvt_out_pad_vld_d3) == 1'b0) begin
  end else begin
    cvt_out_pad_mask_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_80x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_pad_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_reg_en_d4 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d3 | cvt_out_vld_d4) == 1'b1) begin
    cvt_out_reg_en_d4 <= cvt_out_reg_en_d3;
  // VCS coverage off
  end else if ((cvt_out_vld_d3 | cvt_out_vld_d4) == 1'b0) begin
  end else begin
    cvt_out_reg_en_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_81x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3 | cvt_out_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_cell_out_sel_hold_d4 <= 1'b0;
  end else begin
  if ((cvt_out_vld_d3) == 1'b1) begin
    cvt_cell_out_sel_hold_d4 <= cvt_cell_out_sel_hold_d3;
  // VCS coverage off
  end else if ((cvt_out_vld_d3) == 1'b0) begin
  end else begin
    cvt_cell_out_sel_hold_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_82x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_vld_d5 <= 1'b0;
  end else begin
  cvt_out_vld_d5 <= cvt_out_vld_d4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_pad_vld_d5 <= 1'b0;
  end else begin
  cvt_out_pad_vld_d5 <= cvt_out_pad_vld_d4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_hold_en_d5 <= 1'b0;
  end else begin
  cvt_hold_en_d5 <= cvt_hold_en_d4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_hsel_d5 <= {2{1'b0}};
  end else begin
  if ((cvt_out_vld_d4) == 1'b1) begin
    cvt_out_hsel_d5 <= cvt_out_hsel_d4;
  // VCS coverage off
  end else if ((cvt_out_vld_d4) == 1'b0) begin
  end else begin
    cvt_out_hsel_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_83x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_addr_d5 <= {12{1'b0}};
  end else begin
  if ((cvt_out_vld_d4) == 1'b1) begin
    cvt_out_addr_d5 <= cvt_out_addr_d4;
  // VCS coverage off
  end else if ((cvt_out_vld_d4) == 1'b0) begin
  end else begin
    cvt_out_addr_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_84x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_line_idx_d5 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d4 | cvt_hold_en_d4) == 1'b1) begin
    cvt_line_idx_d5 <= cvt_line_idx_d4;
  // VCS coverage off
  end else if ((cvt_out_vld_d4 | cvt_hold_en_d4) == 1'b0) begin
  end else begin
    cvt_line_idx_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_85x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4 | cvt_hold_en_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_nz_mask_d5 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d4) == 1'b1) begin
    cvt_out_nz_mask_d5 <= cvt_out_nz_mask_d4;
  // VCS coverage off
  end else if ((cvt_out_vld_d4) == 1'b0) begin
  end else begin
    cvt_out_nz_mask_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_86x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_pad_mask_d5 <= {128{1'b0}};
  end else begin
  if ((cvt_out_pad_vld_d4) == 1'b1) begin
    cvt_out_pad_mask_d5 <= cvt_out_pad_mask_d4;
  // VCS coverage off
  end else if ((cvt_out_pad_vld_d4) == 1'b0) begin
  end else begin
    cvt_out_pad_mask_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_pad_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_reg_en_d5 <= {8{1'b0}};
  end else begin
  if ((cvt_out_vld_d4 | cvt_out_vld_d5) == 1'b1) begin
    cvt_out_reg_en_d5 <= cvt_out_reg_en_d4;
  // VCS coverage off
  end else if ((cvt_out_vld_d4 | cvt_out_vld_d5) == 1'b0) begin
  end else begin
    cvt_out_reg_en_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_88x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4 | cvt_out_vld_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_cell_out_sel_hold_d5 <= 1'b0;
  end else begin
  if ((cvt_out_vld_d4) == 1'b1) begin
    cvt_cell_out_sel_hold_d5 <= cvt_cell_out_sel_hold_d4;
  // VCS coverage off
  end else if ((cvt_out_vld_d4) == 1'b0) begin
  end else begin
    cvt_cell_out_sel_hold_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_89x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign cvt_out_vld_bp = cfg_cvt_en[1] ? cvt_out_vld_d5 : cvt_out_vld_d1;
assign cvt_out_hsel_bp = cfg_cvt_en[1] ? cvt_out_hsel_d5 : cvt_out_hsel_d1;
assign cvt_out_addr_bp = cfg_cvt_en[1] ? cvt_out_addr_d5 : cvt_out_addr_d1;
assign cvt_out_nz_mask_bp = cfg_cvt_en[2] ? cvt_out_nz_mask_d5 : cvt_out_nz_mask_d1;
assign cvt_out_pad_vld_bp = cfg_cvt_en[3] ? cvt_out_pad_vld_d5 : cvt_out_pad_vld_d1;
assign cvt_out_pad_mask_bp = ~cvt_out_pad_vld_bp ? 128'b0 :
                             cfg_cvt_en[3] ? cvt_out_pad_mask_d5 : cvt_out_pad_mask_d1;
assign cvt_out_reg_en_bp = cfg_cvt_en[4] ? cvt_out_reg_en_d5 : cvt_out_reg_en_d1;
assign cvt_hold_en_bp = cvt_hold_en_d5;
assign cvt_line_idx_bp = cvt_line_idx_d5;
assign cvt_cell_out_sel_hold_bp = cvt_cell_out_sel_hold_d5;

////////////////////////////////////////////////////////////////////////
//  stage 3: finial pipeline stage                                    //
////////////////////////////////////////////////////////////////////////
//////// half hold data ////////

always @(
  cvt_line_idx_bp
  or cvt_hold_data_7
  or cvt_hold_data_6
  or cvt_hold_data_5
  or cvt_hold_data_4
  or cvt_hold_data_3
  or cvt_hold_data_2
  or cvt_hold_data_1
  or cvt_hold_data_0
  ) begin
    cvt_hold_data = ({(1024  /4) {cvt_line_idx_bp[7]}} & cvt_hold_data_7) |
                    ({(1024  /4) {cvt_line_idx_bp[6]}} & cvt_hold_data_6) |
                    ({(1024  /4) {cvt_line_idx_bp[5]}} & cvt_hold_data_5) |
                    ({(1024  /4) {cvt_line_idx_bp[4]}} & cvt_hold_data_4) |
                    ({(1024  /4) {cvt_line_idx_bp[3]}} & cvt_hold_data_3) |
                    ({(1024  /4) {cvt_line_idx_bp[2]}} & cvt_hold_data_2) |
                    ({(1024  /4) {cvt_line_idx_bp[1]}} & cvt_hold_data_1) |
                    ({(1024  /4) {cvt_line_idx_bp[0]}} & cvt_hold_data_0);
end

always @(
  cvt_out_pad_mask_bp
  or cfg_pad_value
  or cvt_data_cell_8b
  ) begin
    cvt_data_cell_8b_masked[7:0] = cvt_out_pad_mask_bp[0] ? cfg_pad_value[7:0] : cvt_data_cell_8b[7:0];
    cvt_data_cell_8b_masked[15:8] = cvt_out_pad_mask_bp[1] ? cfg_pad_value[15:8] : cvt_data_cell_8b[15:8];
    cvt_data_cell_8b_masked[23:16] = cvt_out_pad_mask_bp[2] ? cfg_pad_value[23:16] : cvt_data_cell_8b[23:16];
    cvt_data_cell_8b_masked[31:24] = cvt_out_pad_mask_bp[3] ? cfg_pad_value[31:24] : cvt_data_cell_8b[31:24];
    cvt_data_cell_8b_masked[39:32] = cvt_out_pad_mask_bp[4] ? cfg_pad_value[39:32] : cvt_data_cell_8b[39:32];
    cvt_data_cell_8b_masked[47:40] = cvt_out_pad_mask_bp[5] ? cfg_pad_value[47:40] : cvt_data_cell_8b[47:40];
    cvt_data_cell_8b_masked[55:48] = cvt_out_pad_mask_bp[6] ? cfg_pad_value[55:48] : cvt_data_cell_8b[55:48];
    cvt_data_cell_8b_masked[63:56] = cvt_out_pad_mask_bp[7] ? cfg_pad_value[63:56] : cvt_data_cell_8b[63:56];
    cvt_data_cell_8b_masked[71:64] = cvt_out_pad_mask_bp[8] ? cfg_pad_value[71:64] : cvt_data_cell_8b[71:64];
    cvt_data_cell_8b_masked[79:72] = cvt_out_pad_mask_bp[9] ? cfg_pad_value[79:72] : cvt_data_cell_8b[79:72];
    cvt_data_cell_8b_masked[87:80] = cvt_out_pad_mask_bp[10] ? cfg_pad_value[87:80] : cvt_data_cell_8b[87:80];
    cvt_data_cell_8b_masked[95:88] = cvt_out_pad_mask_bp[11] ? cfg_pad_value[95:88] : cvt_data_cell_8b[95:88];
    cvt_data_cell_8b_masked[103:96] = cvt_out_pad_mask_bp[12] ? cfg_pad_value[103:96] : cvt_data_cell_8b[103:96];
    cvt_data_cell_8b_masked[111:104] = cvt_out_pad_mask_bp[13] ? cfg_pad_value[111:104] : cvt_data_cell_8b[111:104];
    cvt_data_cell_8b_masked[119:112] = cvt_out_pad_mask_bp[14] ? cfg_pad_value[119:112] : cvt_data_cell_8b[119:112];
    cvt_data_cell_8b_masked[127:120] = cvt_out_pad_mask_bp[15] ? cfg_pad_value[127:120] : cvt_data_cell_8b[127:120];
    cvt_data_cell_8b_masked[135:128] = cvt_out_pad_mask_bp[16] ? cfg_pad_value[135:128] : cvt_data_cell_8b[135:128];
    cvt_data_cell_8b_masked[143:136] = cvt_out_pad_mask_bp[17] ? cfg_pad_value[143:136] : cvt_data_cell_8b[143:136];
    cvt_data_cell_8b_masked[151:144] = cvt_out_pad_mask_bp[18] ? cfg_pad_value[151:144] : cvt_data_cell_8b[151:144];
    cvt_data_cell_8b_masked[159:152] = cvt_out_pad_mask_bp[19] ? cfg_pad_value[159:152] : cvt_data_cell_8b[159:152];
    cvt_data_cell_8b_masked[167:160] = cvt_out_pad_mask_bp[20] ? cfg_pad_value[167:160] : cvt_data_cell_8b[167:160];
    cvt_data_cell_8b_masked[175:168] = cvt_out_pad_mask_bp[21] ? cfg_pad_value[175:168] : cvt_data_cell_8b[175:168];
    cvt_data_cell_8b_masked[183:176] = cvt_out_pad_mask_bp[22] ? cfg_pad_value[183:176] : cvt_data_cell_8b[183:176];
    cvt_data_cell_8b_masked[191:184] = cvt_out_pad_mask_bp[23] ? cfg_pad_value[191:184] : cvt_data_cell_8b[191:184];
    cvt_data_cell_8b_masked[199:192] = cvt_out_pad_mask_bp[24] ? cfg_pad_value[199:192] : cvt_data_cell_8b[199:192];
    cvt_data_cell_8b_masked[207:200] = cvt_out_pad_mask_bp[25] ? cfg_pad_value[207:200] : cvt_data_cell_8b[207:200];
    cvt_data_cell_8b_masked[215:208] = cvt_out_pad_mask_bp[26] ? cfg_pad_value[215:208] : cvt_data_cell_8b[215:208];
    cvt_data_cell_8b_masked[223:216] = cvt_out_pad_mask_bp[27] ? cfg_pad_value[223:216] : cvt_data_cell_8b[223:216];
    cvt_data_cell_8b_masked[231:224] = cvt_out_pad_mask_bp[28] ? cfg_pad_value[231:224] : cvt_data_cell_8b[231:224];
    cvt_data_cell_8b_masked[239:232] = cvt_out_pad_mask_bp[29] ? cfg_pad_value[239:232] : cvt_data_cell_8b[239:232];
    cvt_data_cell_8b_masked[247:240] = cvt_out_pad_mask_bp[30] ? cfg_pad_value[247:240] : cvt_data_cell_8b[247:240];
    cvt_data_cell_8b_masked[255:248] = cvt_out_pad_mask_bp[31] ? cfg_pad_value[255:248] : cvt_data_cell_8b[255:248];
end

always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_en_bp & cvt_line_idx_bp[7]) == 1'b1) begin
    cvt_hold_data_7 <= cvt_data_cell_8b_masked[255:0];
  // VCS coverage off
  end else if ((cvt_hold_en_bp & cvt_line_idx_bp[7]) == 1'b0) begin
  end else begin
    cvt_hold_data_7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_en_bp & cvt_line_idx_bp[6]) == 1'b1) begin
    cvt_hold_data_6 <= cvt_data_cell_8b_masked[255:0];
  // VCS coverage off
  end else if ((cvt_hold_en_bp & cvt_line_idx_bp[6]) == 1'b0) begin
  end else begin
    cvt_hold_data_6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_en_bp & cvt_line_idx_bp[5]) == 1'b1) begin
    cvt_hold_data_5 <= cvt_data_cell_8b_masked[255:0];
  // VCS coverage off
  end else if ((cvt_hold_en_bp & cvt_line_idx_bp[5]) == 1'b0) begin
  end else begin
    cvt_hold_data_5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_en_bp & cvt_line_idx_bp[4]) == 1'b1) begin
    cvt_hold_data_4 <= cvt_data_cell_8b_masked[255:0];
  // VCS coverage off
  end else if ((cvt_hold_en_bp & cvt_line_idx_bp[4]) == 1'b0) begin
  end else begin
    cvt_hold_data_4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_en_bp & cvt_line_idx_bp[3]) == 1'b1) begin
    cvt_hold_data_3 <= cvt_data_cell_8b_masked[255:0];
  // VCS coverage off
  end else if ((cvt_hold_en_bp & cvt_line_idx_bp[3]) == 1'b0) begin
  end else begin
    cvt_hold_data_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_en_bp & cvt_line_idx_bp[2]) == 1'b1) begin
    cvt_hold_data_2 <= cvt_data_cell_8b_masked[255:0];
  // VCS coverage off
  end else if ((cvt_hold_en_bp & cvt_line_idx_bp[2]) == 1'b0) begin
  end else begin
    cvt_hold_data_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_en_bp & cvt_line_idx_bp[1]) == 1'b1) begin
    cvt_hold_data_1 <= cvt_data_cell_8b_masked[255:0];
  // VCS coverage off
  end else if ((cvt_hold_en_bp & cvt_line_idx_bp[1]) == 1'b0) begin
  end else begin
    cvt_hold_data_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((cvt_hold_en_bp & cvt_line_idx_bp[0]) == 1'b1) begin
    cvt_hold_data_0 <= cvt_data_cell_8b_masked[255:0];
  // VCS coverage off
  end else if ((cvt_hold_en_bp & cvt_line_idx_bp[0]) == 1'b0) begin
  end else begin
    cvt_hold_data_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

//////// output regiseters ////////

assign cvt_data_bypass_hi = cvt_bypass_sel_half_d1 ? cvt_wr_data_d1[511:0] : cvt_wr_data_d1[1023:512];
assign cvt_data_bypass_lo = cvt_wr_data_d1[511:0];

assign cvt_data_cell_sel0_lo = cvt_cell_out_sel_hold_bp ? cvt_hold_data : cvt_data_cell_8b[255:0];
assign cvt_data_cell_sel0_hi = cvt_data_cell_8b[511:256];

assign cvt_data_cell_out = ~cfg_out_int8 ? cvt_data_cell_16b :
                           {2{cvt_data_cell_sel0_hi, cvt_data_cell_sel0_lo}};

assign cvt_out_data_mix = cfg_cvt_en[5] ? cvt_data_cell_out : {cvt_data_bypass_hi, cvt_data_bypass_lo};

always @(
  cvt_out_pad_mask_bp
  or cfg_pad_value
  or cvt_out_data_mix
  ) begin
    cvt_out_data_masked[7:0] = cvt_out_pad_mask_bp[0] ? cfg_pad_value[7:0] : cvt_out_data_mix[7:0];
    cvt_out_data_masked[15:8] = cvt_out_pad_mask_bp[1] ? cfg_pad_value[15:8] : cvt_out_data_mix[15:8];
    cvt_out_data_masked[23:16] = cvt_out_pad_mask_bp[2] ? cfg_pad_value[23:16] : cvt_out_data_mix[23:16];
    cvt_out_data_masked[31:24] = cvt_out_pad_mask_bp[3] ? cfg_pad_value[31:24] : cvt_out_data_mix[31:24];
    cvt_out_data_masked[39:32] = cvt_out_pad_mask_bp[4] ? cfg_pad_value[39:32] : cvt_out_data_mix[39:32];
    cvt_out_data_masked[47:40] = cvt_out_pad_mask_bp[5] ? cfg_pad_value[47:40] : cvt_out_data_mix[47:40];
    cvt_out_data_masked[55:48] = cvt_out_pad_mask_bp[6] ? cfg_pad_value[55:48] : cvt_out_data_mix[55:48];
    cvt_out_data_masked[63:56] = cvt_out_pad_mask_bp[7] ? cfg_pad_value[63:56] : cvt_out_data_mix[63:56];
    cvt_out_data_masked[71:64] = cvt_out_pad_mask_bp[8] ? cfg_pad_value[71:64] : cvt_out_data_mix[71:64];
    cvt_out_data_masked[79:72] = cvt_out_pad_mask_bp[9] ? cfg_pad_value[79:72] : cvt_out_data_mix[79:72];
    cvt_out_data_masked[87:80] = cvt_out_pad_mask_bp[10] ? cfg_pad_value[87:80] : cvt_out_data_mix[87:80];
    cvt_out_data_masked[95:88] = cvt_out_pad_mask_bp[11] ? cfg_pad_value[95:88] : cvt_out_data_mix[95:88];
    cvt_out_data_masked[103:96] = cvt_out_pad_mask_bp[12] ? cfg_pad_value[103:96] : cvt_out_data_mix[103:96];
    cvt_out_data_masked[111:104] = cvt_out_pad_mask_bp[13] ? cfg_pad_value[111:104] : cvt_out_data_mix[111:104];
    cvt_out_data_masked[119:112] = cvt_out_pad_mask_bp[14] ? cfg_pad_value[119:112] : cvt_out_data_mix[119:112];
    cvt_out_data_masked[127:120] = cvt_out_pad_mask_bp[15] ? cfg_pad_value[127:120] : cvt_out_data_mix[127:120];
    cvt_out_data_masked[135:128] = cvt_out_pad_mask_bp[16] ? cfg_pad_value[135:128] : cvt_out_data_mix[135:128];
    cvt_out_data_masked[143:136] = cvt_out_pad_mask_bp[17] ? cfg_pad_value[143:136] : cvt_out_data_mix[143:136];
    cvt_out_data_masked[151:144] = cvt_out_pad_mask_bp[18] ? cfg_pad_value[151:144] : cvt_out_data_mix[151:144];
    cvt_out_data_masked[159:152] = cvt_out_pad_mask_bp[19] ? cfg_pad_value[159:152] : cvt_out_data_mix[159:152];
    cvt_out_data_masked[167:160] = cvt_out_pad_mask_bp[20] ? cfg_pad_value[167:160] : cvt_out_data_mix[167:160];
    cvt_out_data_masked[175:168] = cvt_out_pad_mask_bp[21] ? cfg_pad_value[175:168] : cvt_out_data_mix[175:168];
    cvt_out_data_masked[183:176] = cvt_out_pad_mask_bp[22] ? cfg_pad_value[183:176] : cvt_out_data_mix[183:176];
    cvt_out_data_masked[191:184] = cvt_out_pad_mask_bp[23] ? cfg_pad_value[191:184] : cvt_out_data_mix[191:184];
    cvt_out_data_masked[199:192] = cvt_out_pad_mask_bp[24] ? cfg_pad_value[199:192] : cvt_out_data_mix[199:192];
    cvt_out_data_masked[207:200] = cvt_out_pad_mask_bp[25] ? cfg_pad_value[207:200] : cvt_out_data_mix[207:200];
    cvt_out_data_masked[215:208] = cvt_out_pad_mask_bp[26] ? cfg_pad_value[215:208] : cvt_out_data_mix[215:208];
    cvt_out_data_masked[223:216] = cvt_out_pad_mask_bp[27] ? cfg_pad_value[223:216] : cvt_out_data_mix[223:216];
    cvt_out_data_masked[231:224] = cvt_out_pad_mask_bp[28] ? cfg_pad_value[231:224] : cvt_out_data_mix[231:224];
    cvt_out_data_masked[239:232] = cvt_out_pad_mask_bp[29] ? cfg_pad_value[239:232] : cvt_out_data_mix[239:232];
    cvt_out_data_masked[247:240] = cvt_out_pad_mask_bp[30] ? cfg_pad_value[247:240] : cvt_out_data_mix[247:240];
    cvt_out_data_masked[255:248] = cvt_out_pad_mask_bp[31] ? cfg_pad_value[255:248] : cvt_out_data_mix[255:248];
    cvt_out_data_masked[263:256] = cvt_out_pad_mask_bp[32] ? cfg_pad_value[263:256] : cvt_out_data_mix[263:256];
    cvt_out_data_masked[271:264] = cvt_out_pad_mask_bp[33] ? cfg_pad_value[271:264] : cvt_out_data_mix[271:264];
    cvt_out_data_masked[279:272] = cvt_out_pad_mask_bp[34] ? cfg_pad_value[279:272] : cvt_out_data_mix[279:272];
    cvt_out_data_masked[287:280] = cvt_out_pad_mask_bp[35] ? cfg_pad_value[287:280] : cvt_out_data_mix[287:280];
    cvt_out_data_masked[295:288] = cvt_out_pad_mask_bp[36] ? cfg_pad_value[295:288] : cvt_out_data_mix[295:288];
    cvt_out_data_masked[303:296] = cvt_out_pad_mask_bp[37] ? cfg_pad_value[303:296] : cvt_out_data_mix[303:296];
    cvt_out_data_masked[311:304] = cvt_out_pad_mask_bp[38] ? cfg_pad_value[311:304] : cvt_out_data_mix[311:304];
    cvt_out_data_masked[319:312] = cvt_out_pad_mask_bp[39] ? cfg_pad_value[319:312] : cvt_out_data_mix[319:312];
    cvt_out_data_masked[327:320] = cvt_out_pad_mask_bp[40] ? cfg_pad_value[327:320] : cvt_out_data_mix[327:320];
    cvt_out_data_masked[335:328] = cvt_out_pad_mask_bp[41] ? cfg_pad_value[335:328] : cvt_out_data_mix[335:328];
    cvt_out_data_masked[343:336] = cvt_out_pad_mask_bp[42] ? cfg_pad_value[343:336] : cvt_out_data_mix[343:336];
    cvt_out_data_masked[351:344] = cvt_out_pad_mask_bp[43] ? cfg_pad_value[351:344] : cvt_out_data_mix[351:344];
    cvt_out_data_masked[359:352] = cvt_out_pad_mask_bp[44] ? cfg_pad_value[359:352] : cvt_out_data_mix[359:352];
    cvt_out_data_masked[367:360] = cvt_out_pad_mask_bp[45] ? cfg_pad_value[367:360] : cvt_out_data_mix[367:360];
    cvt_out_data_masked[375:368] = cvt_out_pad_mask_bp[46] ? cfg_pad_value[375:368] : cvt_out_data_mix[375:368];
    cvt_out_data_masked[383:376] = cvt_out_pad_mask_bp[47] ? cfg_pad_value[383:376] : cvt_out_data_mix[383:376];
    cvt_out_data_masked[391:384] = cvt_out_pad_mask_bp[48] ? cfg_pad_value[391:384] : cvt_out_data_mix[391:384];
    cvt_out_data_masked[399:392] = cvt_out_pad_mask_bp[49] ? cfg_pad_value[399:392] : cvt_out_data_mix[399:392];
    cvt_out_data_masked[407:400] = cvt_out_pad_mask_bp[50] ? cfg_pad_value[407:400] : cvt_out_data_mix[407:400];
    cvt_out_data_masked[415:408] = cvt_out_pad_mask_bp[51] ? cfg_pad_value[415:408] : cvt_out_data_mix[415:408];
    cvt_out_data_masked[423:416] = cvt_out_pad_mask_bp[52] ? cfg_pad_value[423:416] : cvt_out_data_mix[423:416];
    cvt_out_data_masked[431:424] = cvt_out_pad_mask_bp[53] ? cfg_pad_value[431:424] : cvt_out_data_mix[431:424];
    cvt_out_data_masked[439:432] = cvt_out_pad_mask_bp[54] ? cfg_pad_value[439:432] : cvt_out_data_mix[439:432];
    cvt_out_data_masked[447:440] = cvt_out_pad_mask_bp[55] ? cfg_pad_value[447:440] : cvt_out_data_mix[447:440];
    cvt_out_data_masked[455:448] = cvt_out_pad_mask_bp[56] ? cfg_pad_value[455:448] : cvt_out_data_mix[455:448];
    cvt_out_data_masked[463:456] = cvt_out_pad_mask_bp[57] ? cfg_pad_value[463:456] : cvt_out_data_mix[463:456];
    cvt_out_data_masked[471:464] = cvt_out_pad_mask_bp[58] ? cfg_pad_value[471:464] : cvt_out_data_mix[471:464];
    cvt_out_data_masked[479:472] = cvt_out_pad_mask_bp[59] ? cfg_pad_value[479:472] : cvt_out_data_mix[479:472];
    cvt_out_data_masked[487:480] = cvt_out_pad_mask_bp[60] ? cfg_pad_value[487:480] : cvt_out_data_mix[487:480];
    cvt_out_data_masked[495:488] = cvt_out_pad_mask_bp[61] ? cfg_pad_value[495:488] : cvt_out_data_mix[495:488];
    cvt_out_data_masked[503:496] = cvt_out_pad_mask_bp[62] ? cfg_pad_value[503:496] : cvt_out_data_mix[503:496];
    cvt_out_data_masked[511:504] = cvt_out_pad_mask_bp[63] ? cfg_pad_value[511:504] : cvt_out_data_mix[511:504];
    cvt_out_data_masked[519:512] = cvt_out_pad_mask_bp[64] ? cfg_pad_value[519:512] : cvt_out_data_mix[519:512];
    cvt_out_data_masked[527:520] = cvt_out_pad_mask_bp[65] ? cfg_pad_value[527:520] : cvt_out_data_mix[527:520];
    cvt_out_data_masked[535:528] = cvt_out_pad_mask_bp[66] ? cfg_pad_value[535:528] : cvt_out_data_mix[535:528];
    cvt_out_data_masked[543:536] = cvt_out_pad_mask_bp[67] ? cfg_pad_value[543:536] : cvt_out_data_mix[543:536];
    cvt_out_data_masked[551:544] = cvt_out_pad_mask_bp[68] ? cfg_pad_value[551:544] : cvt_out_data_mix[551:544];
    cvt_out_data_masked[559:552] = cvt_out_pad_mask_bp[69] ? cfg_pad_value[559:552] : cvt_out_data_mix[559:552];
    cvt_out_data_masked[567:560] = cvt_out_pad_mask_bp[70] ? cfg_pad_value[567:560] : cvt_out_data_mix[567:560];
    cvt_out_data_masked[575:568] = cvt_out_pad_mask_bp[71] ? cfg_pad_value[575:568] : cvt_out_data_mix[575:568];
    cvt_out_data_masked[583:576] = cvt_out_pad_mask_bp[72] ? cfg_pad_value[583:576] : cvt_out_data_mix[583:576];
    cvt_out_data_masked[591:584] = cvt_out_pad_mask_bp[73] ? cfg_pad_value[591:584] : cvt_out_data_mix[591:584];
    cvt_out_data_masked[599:592] = cvt_out_pad_mask_bp[74] ? cfg_pad_value[599:592] : cvt_out_data_mix[599:592];
    cvt_out_data_masked[607:600] = cvt_out_pad_mask_bp[75] ? cfg_pad_value[607:600] : cvt_out_data_mix[607:600];
    cvt_out_data_masked[615:608] = cvt_out_pad_mask_bp[76] ? cfg_pad_value[615:608] : cvt_out_data_mix[615:608];
    cvt_out_data_masked[623:616] = cvt_out_pad_mask_bp[77] ? cfg_pad_value[623:616] : cvt_out_data_mix[623:616];
    cvt_out_data_masked[631:624] = cvt_out_pad_mask_bp[78] ? cfg_pad_value[631:624] : cvt_out_data_mix[631:624];
    cvt_out_data_masked[639:632] = cvt_out_pad_mask_bp[79] ? cfg_pad_value[639:632] : cvt_out_data_mix[639:632];
    cvt_out_data_masked[647:640] = cvt_out_pad_mask_bp[80] ? cfg_pad_value[647:640] : cvt_out_data_mix[647:640];
    cvt_out_data_masked[655:648] = cvt_out_pad_mask_bp[81] ? cfg_pad_value[655:648] : cvt_out_data_mix[655:648];
    cvt_out_data_masked[663:656] = cvt_out_pad_mask_bp[82] ? cfg_pad_value[663:656] : cvt_out_data_mix[663:656];
    cvt_out_data_masked[671:664] = cvt_out_pad_mask_bp[83] ? cfg_pad_value[671:664] : cvt_out_data_mix[671:664];
    cvt_out_data_masked[679:672] = cvt_out_pad_mask_bp[84] ? cfg_pad_value[679:672] : cvt_out_data_mix[679:672];
    cvt_out_data_masked[687:680] = cvt_out_pad_mask_bp[85] ? cfg_pad_value[687:680] : cvt_out_data_mix[687:680];
    cvt_out_data_masked[695:688] = cvt_out_pad_mask_bp[86] ? cfg_pad_value[695:688] : cvt_out_data_mix[695:688];
    cvt_out_data_masked[703:696] = cvt_out_pad_mask_bp[87] ? cfg_pad_value[703:696] : cvt_out_data_mix[703:696];
    cvt_out_data_masked[711:704] = cvt_out_pad_mask_bp[88] ? cfg_pad_value[711:704] : cvt_out_data_mix[711:704];
    cvt_out_data_masked[719:712] = cvt_out_pad_mask_bp[89] ? cfg_pad_value[719:712] : cvt_out_data_mix[719:712];
    cvt_out_data_masked[727:720] = cvt_out_pad_mask_bp[90] ? cfg_pad_value[727:720] : cvt_out_data_mix[727:720];
    cvt_out_data_masked[735:728] = cvt_out_pad_mask_bp[91] ? cfg_pad_value[735:728] : cvt_out_data_mix[735:728];
    cvt_out_data_masked[743:736] = cvt_out_pad_mask_bp[92] ? cfg_pad_value[743:736] : cvt_out_data_mix[743:736];
    cvt_out_data_masked[751:744] = cvt_out_pad_mask_bp[93] ? cfg_pad_value[751:744] : cvt_out_data_mix[751:744];
    cvt_out_data_masked[759:752] = cvt_out_pad_mask_bp[94] ? cfg_pad_value[759:752] : cvt_out_data_mix[759:752];
    cvt_out_data_masked[767:760] = cvt_out_pad_mask_bp[95] ? cfg_pad_value[767:760] : cvt_out_data_mix[767:760];
    cvt_out_data_masked[775:768] = cvt_out_pad_mask_bp[96] ? cfg_pad_value[775:768] : cvt_out_data_mix[775:768];
    cvt_out_data_masked[783:776] = cvt_out_pad_mask_bp[97] ? cfg_pad_value[783:776] : cvt_out_data_mix[783:776];
    cvt_out_data_masked[791:784] = cvt_out_pad_mask_bp[98] ? cfg_pad_value[791:784] : cvt_out_data_mix[791:784];
    cvt_out_data_masked[799:792] = cvt_out_pad_mask_bp[99] ? cfg_pad_value[799:792] : cvt_out_data_mix[799:792];
    cvt_out_data_masked[807:800] = cvt_out_pad_mask_bp[100] ? cfg_pad_value[807:800] : cvt_out_data_mix[807:800];
    cvt_out_data_masked[815:808] = cvt_out_pad_mask_bp[101] ? cfg_pad_value[815:808] : cvt_out_data_mix[815:808];
    cvt_out_data_masked[823:816] = cvt_out_pad_mask_bp[102] ? cfg_pad_value[823:816] : cvt_out_data_mix[823:816];
    cvt_out_data_masked[831:824] = cvt_out_pad_mask_bp[103] ? cfg_pad_value[831:824] : cvt_out_data_mix[831:824];
    cvt_out_data_masked[839:832] = cvt_out_pad_mask_bp[104] ? cfg_pad_value[839:832] : cvt_out_data_mix[839:832];
    cvt_out_data_masked[847:840] = cvt_out_pad_mask_bp[105] ? cfg_pad_value[847:840] : cvt_out_data_mix[847:840];
    cvt_out_data_masked[855:848] = cvt_out_pad_mask_bp[106] ? cfg_pad_value[855:848] : cvt_out_data_mix[855:848];
    cvt_out_data_masked[863:856] = cvt_out_pad_mask_bp[107] ? cfg_pad_value[863:856] : cvt_out_data_mix[863:856];
    cvt_out_data_masked[871:864] = cvt_out_pad_mask_bp[108] ? cfg_pad_value[871:864] : cvt_out_data_mix[871:864];
    cvt_out_data_masked[879:872] = cvt_out_pad_mask_bp[109] ? cfg_pad_value[879:872] : cvt_out_data_mix[879:872];
    cvt_out_data_masked[887:880] = cvt_out_pad_mask_bp[110] ? cfg_pad_value[887:880] : cvt_out_data_mix[887:880];
    cvt_out_data_masked[895:888] = cvt_out_pad_mask_bp[111] ? cfg_pad_value[895:888] : cvt_out_data_mix[895:888];
    cvt_out_data_masked[903:896] = cvt_out_pad_mask_bp[112] ? cfg_pad_value[903:896] : cvt_out_data_mix[903:896];
    cvt_out_data_masked[911:904] = cvt_out_pad_mask_bp[113] ? cfg_pad_value[911:904] : cvt_out_data_mix[911:904];
    cvt_out_data_masked[919:912] = cvt_out_pad_mask_bp[114] ? cfg_pad_value[919:912] : cvt_out_data_mix[919:912];
    cvt_out_data_masked[927:920] = cvt_out_pad_mask_bp[115] ? cfg_pad_value[927:920] : cvt_out_data_mix[927:920];
    cvt_out_data_masked[935:928] = cvt_out_pad_mask_bp[116] ? cfg_pad_value[935:928] : cvt_out_data_mix[935:928];
    cvt_out_data_masked[943:936] = cvt_out_pad_mask_bp[117] ? cfg_pad_value[943:936] : cvt_out_data_mix[943:936];
    cvt_out_data_masked[951:944] = cvt_out_pad_mask_bp[118] ? cfg_pad_value[951:944] : cvt_out_data_mix[951:944];
    cvt_out_data_masked[959:952] = cvt_out_pad_mask_bp[119] ? cfg_pad_value[959:952] : cvt_out_data_mix[959:952];
    cvt_out_data_masked[967:960] = cvt_out_pad_mask_bp[120] ? cfg_pad_value[967:960] : cvt_out_data_mix[967:960];
    cvt_out_data_masked[975:968] = cvt_out_pad_mask_bp[121] ? cfg_pad_value[975:968] : cvt_out_data_mix[975:968];
    cvt_out_data_masked[983:976] = cvt_out_pad_mask_bp[122] ? cfg_pad_value[983:976] : cvt_out_data_mix[983:976];
    cvt_out_data_masked[991:984] = cvt_out_pad_mask_bp[123] ? cfg_pad_value[991:984] : cvt_out_data_mix[991:984];
    cvt_out_data_masked[999:992] = cvt_out_pad_mask_bp[124] ? cfg_pad_value[999:992] : cvt_out_data_mix[999:992];
    cvt_out_data_masked[1007:1000] = cvt_out_pad_mask_bp[125] ? cfg_pad_value[1007:1000] : cvt_out_data_mix[1007:1000];
    cvt_out_data_masked[1015:1008] = cvt_out_pad_mask_bp[126] ? cfg_pad_value[1015:1008] : cvt_out_data_mix[1015:1008];
    cvt_out_data_masked[1023:1016] = cvt_out_pad_mask_bp[127] ? cfg_pad_value[1023:1016] : cvt_out_data_mix[1023:1016];
end

assign cvt_out_data_p0 = ~cvt_out_nz_mask_bp[0] ? 128'b0 : cvt_out_data_masked[127:0];
assign cvt_out_data_p1 = ~cvt_out_nz_mask_bp[1] ? 128'b0 : cvt_out_data_masked[255:128];
assign cvt_out_data_p2 = ~cvt_out_nz_mask_bp[2] ? 128'b0 : cvt_out_data_masked[383:256];
assign cvt_out_data_p3 = ~cvt_out_nz_mask_bp[3] ? 128'b0 : cvt_out_data_masked[511:384];
assign cvt_out_data_p4 = ~cvt_out_nz_mask_bp[4] ? 128'b0 : cvt_out_data_masked[639:512];
assign cvt_out_data_p5 = ~cvt_out_nz_mask_bp[5] ? 128'b0 : cvt_out_data_masked[767:640];
assign cvt_out_data_p6 = ~cvt_out_nz_mask_bp[6] ? 128'b0 : cvt_out_data_masked[895:768];
assign cvt_out_data_p7 = ~cvt_out_nz_mask_bp[7] ? 128'b0 : cvt_out_data_masked[1023:896];

always @(
  cvt_out_vld_bp
  or dat_cbuf_flush_vld_w
  ) begin
    cvt_out_vld_reg_w = cvt_out_vld_bp | dat_cbuf_flush_vld_w;
end

always @(
  dat_cbuf_flush_vld_w
  or dat_cbuf_flush_idx
  or cvt_out_addr_bp
  ) begin
    cvt_out_addr_reg_w = dat_cbuf_flush_vld_w ? dat_cbuf_flush_idx[(1  + 12 ) -1:1] :
                         cvt_out_addr_bp;
end

always @(
  dat_cbuf_flush_vld_w
  or dat_cbuf_flush_idx
  or cvt_out_hsel_bp
  ) begin
    cvt_out_hsel_reg_w = dat_cbuf_flush_vld_w ? {dat_cbuf_flush_idx[0], ~dat_cbuf_flush_idx[0]} :
                         cvt_out_hsel_bp;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_data_p0_reg <= {128{1'b0}};
  end else begin
  if ((cvt_out_reg_en_bp[0]) == 1'b1) begin
    cvt_out_data_p0_reg <= cvt_out_data_p0;
  // VCS coverage off
  end else if ((cvt_out_reg_en_bp[0]) == 1'b0) begin
  end else begin
    cvt_out_data_p0_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_90x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_data_p1_reg <= {128{1'b0}};
  end else begin
  if ((cvt_out_reg_en_bp[1]) == 1'b1) begin
    cvt_out_data_p1_reg <= cvt_out_data_p1;
  // VCS coverage off
  end else if ((cvt_out_reg_en_bp[1]) == 1'b0) begin
  end else begin
    cvt_out_data_p1_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_91x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[1]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_data_p2_reg <= {128{1'b0}};
  end else begin
  if ((cvt_out_reg_en_bp[2]) == 1'b1) begin
    cvt_out_data_p2_reg <= cvt_out_data_p2;
  // VCS coverage off
  end else if ((cvt_out_reg_en_bp[2]) == 1'b0) begin
  end else begin
    cvt_out_data_p2_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_92x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_data_p3_reg <= {128{1'b0}};
  end else begin
  if ((cvt_out_reg_en_bp[3]) == 1'b1) begin
    cvt_out_data_p3_reg <= cvt_out_data_p3;
  // VCS coverage off
  end else if ((cvt_out_reg_en_bp[3]) == 1'b0) begin
  end else begin
    cvt_out_data_p3_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_93x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[3]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_data_p4_reg <= {128{1'b0}};
  end else begin
  if ((cvt_out_reg_en_bp[4]) == 1'b1) begin
    cvt_out_data_p4_reg <= cvt_out_data_p4;
  // VCS coverage off
  end else if ((cvt_out_reg_en_bp[4]) == 1'b0) begin
  end else begin
    cvt_out_data_p4_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_94x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[4]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_data_p5_reg <= {128{1'b0}};
  end else begin
  if ((cvt_out_reg_en_bp[5]) == 1'b1) begin
    cvt_out_data_p5_reg <= cvt_out_data_p5;
  // VCS coverage off
  end else if ((cvt_out_reg_en_bp[5]) == 1'b0) begin
  end else begin
    cvt_out_data_p5_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_95x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[5]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_data_p6_reg <= {128{1'b0}};
  end else begin
  if ((cvt_out_reg_en_bp[6]) == 1'b1) begin
    cvt_out_data_p6_reg <= cvt_out_data_p6;
  // VCS coverage off
  end else if ((cvt_out_reg_en_bp[6]) == 1'b0) begin
  end else begin
    cvt_out_data_p6_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[6]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cvt_out_data_p7_reg <= {128{1'b0}};
  end else begin
  if ((cvt_out_reg_en_bp[7]) == 1'b1) begin
    cvt_out_data_p7_reg <= cvt_out_data_p7;
  // VCS coverage off
  end else if ((cvt_out_reg_en_bp[7]) == 1'b0) begin
  end else begin
    cvt_out_data_p7_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_97x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_reg_en_bp[7]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//================  Non-SLCG clock domain ================//

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_vld_reg <= 1'b0;
  end else begin
  cvt_out_vld_reg <= cvt_out_vld_reg_w;
  end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_addr_reg <= {12{1'b0}};
  end else begin
  if ((cvt_out_vld_reg_w) == 1'b1) begin
    cvt_out_addr_reg <= cvt_out_addr_reg_w;
  // VCS coverage off
  end else if ((cvt_out_vld_reg_w) == 1'b0) begin
  end else begin
    cvt_out_addr_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_98x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_reg_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_out_hsel_reg <= {2{1'b0}};
  end else begin
  if ((cvt_out_vld_reg_w) == 1'b1) begin
    cvt_out_hsel_reg <= cvt_out_hsel_reg_w;
  // VCS coverage off
  end else if ((cvt_out_vld_reg_w) == 1'b0) begin
  end else begin
    cvt_out_hsel_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_99x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cvt_out_vld_reg_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
//  Data buffer flush logic                                           //
////////////////////////////////////////////////////////////////////////

always @(
  dat_cbuf_flush_idx
  ) begin
    {mon_dat_cbuf_flush_idx_w,
     dat_cbuf_flush_idx_w} = dat_cbuf_flush_idx + 1'b1;
end

always @(
  dat_cbuf_flush_idx
  ) begin
    dat_cbuf_flush_vld_w = ~dat_cbuf_flush_idx[(1  + 12 ) -1];
end

assign dp2reg_dat_flush_done = dat_cbuf_flush_idx[(1  + 12 ) -1];

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_cbuf_flush_idx <= {13{1'b0}};
  end else begin
  if ((dat_cbuf_flush_vld_w) == 1'b1) begin
    dat_cbuf_flush_idx <= dat_cbuf_flush_idx_w;
  // VCS coverage off
  end else if ((dat_cbuf_flush_vld_w) == 1'b0) begin
  end else begin
    dat_cbuf_flush_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_101x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(dat_cbuf_flush_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//================  Non-SLCG clock domain end ================//

////////////////////////////////////////////////////////////////////////
//  output ports                                                      //
////////////////////////////////////////////////////////////////////////
assign cdma2buf_dat_wr_en = cvt_out_vld_reg;
assign cdma2buf_dat_wr_addr = cvt_out_addr_reg;
assign cdma2buf_dat_wr_hsel = cvt_out_hsel_reg;
assign cdma2buf_dat_wr_data = {cvt_out_data_p7_reg, cvt_out_data_p6_reg, cvt_out_data_p5_reg, cvt_out_data_p4_reg,
                               cvt_out_data_p3_reg, cvt_out_data_p2_reg, cvt_out_data_p1_reg, cvt_out_data_p0_reg};

////////////////////////////////////////////////////////////////////////
//  Infinity and NaN counting logic                                   //
////////////////////////////////////////////////////////////////////////
always @(
  cvt_wr_data_ori
  ) begin
    dat_fp16_exp_flag_w[0] = (&cvt_wr_data_ori[14:10]);
    dat_fp16_exp_flag_w[1] = (&cvt_wr_data_ori[30:26]);
    dat_fp16_exp_flag_w[2] = (&cvt_wr_data_ori[46:42]);
    dat_fp16_exp_flag_w[3] = (&cvt_wr_data_ori[62:58]);
    dat_fp16_exp_flag_w[4] = (&cvt_wr_data_ori[78:74]);
    dat_fp16_exp_flag_w[5] = (&cvt_wr_data_ori[94:90]);
    dat_fp16_exp_flag_w[6] = (&cvt_wr_data_ori[110:106]);
    dat_fp16_exp_flag_w[7] = (&cvt_wr_data_ori[126:122]);
    dat_fp16_exp_flag_w[8] = (&cvt_wr_data_ori[142:138]);
    dat_fp16_exp_flag_w[9] = (&cvt_wr_data_ori[158:154]);
    dat_fp16_exp_flag_w[10] = (&cvt_wr_data_ori[174:170]);
    dat_fp16_exp_flag_w[11] = (&cvt_wr_data_ori[190:186]);
    dat_fp16_exp_flag_w[12] = (&cvt_wr_data_ori[206:202]);
    dat_fp16_exp_flag_w[13] = (&cvt_wr_data_ori[222:218]);
    dat_fp16_exp_flag_w[14] = (&cvt_wr_data_ori[238:234]);
    dat_fp16_exp_flag_w[15] = (&cvt_wr_data_ori[254:250]);
    dat_fp16_exp_flag_w[16] = (&cvt_wr_data_ori[270:266]);
    dat_fp16_exp_flag_w[17] = (&cvt_wr_data_ori[286:282]);
    dat_fp16_exp_flag_w[18] = (&cvt_wr_data_ori[302:298]);
    dat_fp16_exp_flag_w[19] = (&cvt_wr_data_ori[318:314]);
    dat_fp16_exp_flag_w[20] = (&cvt_wr_data_ori[334:330]);
    dat_fp16_exp_flag_w[21] = (&cvt_wr_data_ori[350:346]);
    dat_fp16_exp_flag_w[22] = (&cvt_wr_data_ori[366:362]);
    dat_fp16_exp_flag_w[23] = (&cvt_wr_data_ori[382:378]);
    dat_fp16_exp_flag_w[24] = (&cvt_wr_data_ori[398:394]);
    dat_fp16_exp_flag_w[25] = (&cvt_wr_data_ori[414:410]);
    dat_fp16_exp_flag_w[26] = (&cvt_wr_data_ori[430:426]);
    dat_fp16_exp_flag_w[27] = (&cvt_wr_data_ori[446:442]);
    dat_fp16_exp_flag_w[28] = (&cvt_wr_data_ori[462:458]);
    dat_fp16_exp_flag_w[29] = (&cvt_wr_data_ori[478:474]);
    dat_fp16_exp_flag_w[30] = (&cvt_wr_data_ori[494:490]);
    dat_fp16_exp_flag_w[31] = (&cvt_wr_data_ori[510:506]);
end

always @(
  cvt_wr_data_ori
  ) begin
    dat_fp16_manti_flag_w[0] = (|cvt_wr_data_ori[9:0]);
    dat_fp16_manti_flag_w[1] = (|cvt_wr_data_ori[25:16]);
    dat_fp16_manti_flag_w[2] = (|cvt_wr_data_ori[41:32]);
    dat_fp16_manti_flag_w[3] = (|cvt_wr_data_ori[57:48]);
    dat_fp16_manti_flag_w[4] = (|cvt_wr_data_ori[73:64]);
    dat_fp16_manti_flag_w[5] = (|cvt_wr_data_ori[89:80]);
    dat_fp16_manti_flag_w[6] = (|cvt_wr_data_ori[105:96]);
    dat_fp16_manti_flag_w[7] = (|cvt_wr_data_ori[121:112]);
    dat_fp16_manti_flag_w[8] = (|cvt_wr_data_ori[137:128]);
    dat_fp16_manti_flag_w[9] = (|cvt_wr_data_ori[153:144]);
    dat_fp16_manti_flag_w[10] = (|cvt_wr_data_ori[169:160]);
    dat_fp16_manti_flag_w[11] = (|cvt_wr_data_ori[185:176]);
    dat_fp16_manti_flag_w[12] = (|cvt_wr_data_ori[201:192]);
    dat_fp16_manti_flag_w[13] = (|cvt_wr_data_ori[217:208]);
    dat_fp16_manti_flag_w[14] = (|cvt_wr_data_ori[233:224]);
    dat_fp16_manti_flag_w[15] = (|cvt_wr_data_ori[249:240]);
    dat_fp16_manti_flag_w[16] = (|cvt_wr_data_ori[265:256]);
    dat_fp16_manti_flag_w[17] = (|cvt_wr_data_ori[281:272]);
    dat_fp16_manti_flag_w[18] = (|cvt_wr_data_ori[297:288]);
    dat_fp16_manti_flag_w[19] = (|cvt_wr_data_ori[313:304]);
    dat_fp16_manti_flag_w[20] = (|cvt_wr_data_ori[329:320]);
    dat_fp16_manti_flag_w[21] = (|cvt_wr_data_ori[345:336]);
    dat_fp16_manti_flag_w[22] = (|cvt_wr_data_ori[361:352]);
    dat_fp16_manti_flag_w[23] = (|cvt_wr_data_ori[377:368]);
    dat_fp16_manti_flag_w[24] = (|cvt_wr_data_ori[393:384]);
    dat_fp16_manti_flag_w[25] = (|cvt_wr_data_ori[409:400]);
    dat_fp16_manti_flag_w[26] = (|cvt_wr_data_ori[425:416]);
    dat_fp16_manti_flag_w[27] = (|cvt_wr_data_ori[441:432]);
    dat_fp16_manti_flag_w[28] = (|cvt_wr_data_ori[457:448]);
    dat_fp16_manti_flag_w[29] = (|cvt_wr_data_ori[473:464]);
    dat_fp16_manti_flag_w[30] = (|cvt_wr_data_ori[489:480]);
    dat_fp16_manti_flag_w[31] = (|cvt_wr_data_ori[505:496]);
end


always @(
  dat_fp16_exp_flag_w
  or dat_fp16_manti_flag_w
  or cvt_wr_mask
  ) begin
    dat_fp16_nan_flag_w = (dat_fp16_exp_flag_w & dat_fp16_manti_flag_w & {{16{cvt_wr_mask[1]}}, {16{cvt_wr_mask[0]}}});
    dat_fp16_inf_flag_w = (dat_fp16_exp_flag_w & ~dat_fp16_manti_flag_w & {{16{cvt_wr_mask[1]}}, {16{cvt_wr_mask[0]}}});
end

always @(
  dat_fp16_nan_flag_w
  ) begin
    dat_nan_mask[15:0] = {16{~dat_fp16_nan_flag_w[0]}};
    dat_nan_mask[31:16] = {16{~dat_fp16_nan_flag_w[1]}};
    dat_nan_mask[47:32] = {16{~dat_fp16_nan_flag_w[2]}};
    dat_nan_mask[63:48] = {16{~dat_fp16_nan_flag_w[3]}};
    dat_nan_mask[79:64] = {16{~dat_fp16_nan_flag_w[4]}};
    dat_nan_mask[95:80] = {16{~dat_fp16_nan_flag_w[5]}};
    dat_nan_mask[111:96] = {16{~dat_fp16_nan_flag_w[6]}};
    dat_nan_mask[127:112] = {16{~dat_fp16_nan_flag_w[7]}};
    dat_nan_mask[143:128] = {16{~dat_fp16_nan_flag_w[8]}};
    dat_nan_mask[159:144] = {16{~dat_fp16_nan_flag_w[9]}};
    dat_nan_mask[175:160] = {16{~dat_fp16_nan_flag_w[10]}};
    dat_nan_mask[191:176] = {16{~dat_fp16_nan_flag_w[11]}};
    dat_nan_mask[207:192] = {16{~dat_fp16_nan_flag_w[12]}};
    dat_nan_mask[223:208] = {16{~dat_fp16_nan_flag_w[13]}};
    dat_nan_mask[239:224] = {16{~dat_fp16_nan_flag_w[14]}};
    dat_nan_mask[255:240] = {16{~dat_fp16_nan_flag_w[15]}};
    dat_nan_mask[271:256] = {16{~dat_fp16_nan_flag_w[16]}};
    dat_nan_mask[287:272] = {16{~dat_fp16_nan_flag_w[17]}};
    dat_nan_mask[303:288] = {16{~dat_fp16_nan_flag_w[18]}};
    dat_nan_mask[319:304] = {16{~dat_fp16_nan_flag_w[19]}};
    dat_nan_mask[335:320] = {16{~dat_fp16_nan_flag_w[20]}};
    dat_nan_mask[351:336] = {16{~dat_fp16_nan_flag_w[21]}};
    dat_nan_mask[367:352] = {16{~dat_fp16_nan_flag_w[22]}};
    dat_nan_mask[383:368] = {16{~dat_fp16_nan_flag_w[23]}};
    dat_nan_mask[399:384] = {16{~dat_fp16_nan_flag_w[24]}};
    dat_nan_mask[415:400] = {16{~dat_fp16_nan_flag_w[25]}};
    dat_nan_mask[431:416] = {16{~dat_fp16_nan_flag_w[26]}};
    dat_nan_mask[447:432] = {16{~dat_fp16_nan_flag_w[27]}};
    dat_nan_mask[463:448] = {16{~dat_fp16_nan_flag_w[28]}};
    dat_nan_mask[479:464] = {16{~dat_fp16_nan_flag_w[29]}};
    dat_nan_mask[495:480] = {16{~dat_fp16_nan_flag_w[30]}};
    dat_nan_mask[511:496] = {16{~dat_fp16_nan_flag_w[31]}};
end


always @(
  cvt_wr_en
  or dat_fp16_nan_flag_w
  or reg2dp_op_en
  or is_input_fp16
  or dat_fp16_inf_flag_w
  ) begin
    dat_fp16_nan_vld_w = cvt_wr_en & (|dat_fp16_nan_flag_w) & reg2dp_op_en & is_input_fp16;
    dat_fp16_inf_vld_w = cvt_wr_en & (|dat_fp16_inf_flag_w) & reg2dp_op_en & is_input_fp16;
end

always @(
  cvt_wr_mask
  ) begin
    dat_half_mask = {{16{cvt_wr_mask[1]}}, {16{cvt_wr_mask[0]}}};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_fp16_nan_vld <= 1'b0;
  end else begin
  dat_fp16_nan_vld <= dat_fp16_nan_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_fp16_inf_vld <= 1'b0;
  end else begin
  dat_fp16_inf_vld <= dat_fp16_inf_vld_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_fp16_nan_vld_w) == 1'b1) begin
    dat_fp16_nan_flag <= dat_fp16_nan_flag_w & dat_half_mask;
  // VCS coverage off
  end else if ((dat_fp16_nan_vld_w) == 1'b0) begin
  end else begin
    dat_fp16_nan_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_fp16_inf_vld_w) == 1'b1) begin
    dat_fp16_inf_flag <= dat_fp16_inf_flag_w & dat_half_mask;
  // VCS coverage off
  end else if ((dat_fp16_inf_vld_w) == 1'b0) begin
  end else begin
    dat_fp16_inf_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

/////////////////// ///////////////////

always @(
  dat_fp16_nan_flag
  ) begin
    dat_fp16_nan_sum = dat_fp16_nan_flag[31] + dat_fp16_nan_flag[30] + dat_fp16_nan_flag[29] + dat_fp16_nan_flag[28] + dat_fp16_nan_flag[27] + dat_fp16_nan_flag[26] + dat_fp16_nan_flag[25] + dat_fp16_nan_flag[24] +
                       dat_fp16_nan_flag[23] + dat_fp16_nan_flag[22] + dat_fp16_nan_flag[21] + dat_fp16_nan_flag[20] + dat_fp16_nan_flag[19] + dat_fp16_nan_flag[18] + dat_fp16_nan_flag[17] + dat_fp16_nan_flag[16] +
                       dat_fp16_nan_flag[15] + dat_fp16_nan_flag[14] + dat_fp16_nan_flag[13] + dat_fp16_nan_flag[12] + dat_fp16_nan_flag[11] + dat_fp16_nan_flag[10] + dat_fp16_nan_flag[9] + dat_fp16_nan_flag[8] +
                       dat_fp16_nan_flag[7] + dat_fp16_nan_flag[6] + dat_fp16_nan_flag[5] + dat_fp16_nan_flag[4] + dat_fp16_nan_flag[3] + dat_fp16_nan_flag[2] + dat_fp16_nan_flag[1] + dat_fp16_nan_flag[0];
end

always @(
  dat_fp16_inf_flag
  ) begin
    dat_fp16_inf_sum = dat_fp16_inf_flag[31] + dat_fp16_inf_flag[30] + dat_fp16_inf_flag[29] + dat_fp16_inf_flag[28] + dat_fp16_inf_flag[27] + dat_fp16_inf_flag[26] + dat_fp16_inf_flag[25] + dat_fp16_inf_flag[24] +
                       dat_fp16_inf_flag[23] + dat_fp16_inf_flag[22] + dat_fp16_inf_flag[21] + dat_fp16_inf_flag[20] + dat_fp16_inf_flag[19] + dat_fp16_inf_flag[18] + dat_fp16_inf_flag[17] + dat_fp16_inf_flag[16] +
                       dat_fp16_inf_flag[15] + dat_fp16_inf_flag[14] + dat_fp16_inf_flag[13] + dat_fp16_inf_flag[12] + dat_fp16_inf_flag[11] + dat_fp16_inf_flag[10] + dat_fp16_inf_flag[9] + dat_fp16_inf_flag[8] +
                       dat_fp16_inf_flag[7] + dat_fp16_inf_flag[6] + dat_fp16_inf_flag[5] + dat_fp16_inf_flag[4] + dat_fp16_inf_flag[3] + dat_fp16_inf_flag[2] + dat_fp16_inf_flag[1] + dat_fp16_inf_flag[0];
end


always @(
  dp2reg_nan_data_num
  or dat_fp16_nan_sum
  ) begin
    {nan_carry,
     dp2reg_nan_data_num_inc} = dp2reg_nan_data_num + dat_fp16_nan_sum;
end

always @(
  cfg_reg_en
  or nan_carry
  or dp2reg_nan_data_num_inc
  ) begin
    dp2reg_nan_data_num_w = cfg_reg_en ? 32'b0 :
                            nan_carry ? ~(32'b0) :
                            dp2reg_nan_data_num_inc;
end

always @(
  cfg_reg_en
  or dat_fp16_nan_vld
  or dat_fp16_nan_sum
  ) begin
    nan_reg_en = cfg_reg_en | (dat_fp16_nan_vld & (|dat_fp16_nan_sum));
end

always @(
  dp2reg_inf_data_num
  or dat_fp16_inf_sum
  ) begin
    {inf_carry,
     dp2reg_inf_data_num_inc} = dp2reg_inf_data_num + dat_fp16_inf_sum;
end

always @(
  cfg_reg_en
  or inf_carry
  or dp2reg_inf_data_num_inc
  ) begin
    dp2reg_inf_data_num_w = cfg_reg_en ? 32'b0 :
                            inf_carry ? ~(32'b0) :
                            dp2reg_inf_data_num_inc;
end

always @(
  cfg_reg_en
  or dat_fp16_inf_vld
  or dat_fp16_inf_sum
  ) begin
    inf_reg_en = cfg_reg_en | (dat_fp16_inf_vld & (|dat_fp16_inf_sum));
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_nan_data_num <= {32{1'b0}};
  end else begin
  if ((nan_reg_en) == 1'b1) begin
    dp2reg_nan_data_num <= dp2reg_nan_data_num_w;
  // VCS coverage off
  end else if ((nan_reg_en) == 1'b0) begin
  end else begin
    dp2reg_nan_data_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_102x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(nan_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_inf_data_num <= {32{1'b0}};
  end else begin
  if ((inf_reg_en) == 1'b1) begin
    dp2reg_inf_data_num <= dp2reg_inf_data_num_w;
  // VCS coverage off
  end else if ((inf_reg_en) == 1'b0) begin
  end else begin
    dp2reg_inf_data_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_103x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(inf_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           cvt_out_hsel_d1;

endmodule // NV_NVDLA_CDMA_cvt


