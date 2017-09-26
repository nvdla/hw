// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_intp.v

module NV_NVDLA_CDP_DP_intp (
   nvdla_core_clk                  //|< i
  ,nvdla_core_rstn                 //|< i
  ,dp2reg_done                     //|< i
  ,fp16_en                         //|< i
  ,int16_en                        //|< i
  ,int8_en                         //|< i
  ,intp2mul_prdy                   //|< i
  ,lut2intp_X_data_00              //|< i
  ,lut2intp_X_data_00_17b          //|< i
  ,lut2intp_X_data_01              //|< i
  ,lut2intp_X_data_10              //|< i
  ,lut2intp_X_data_10_17b          //|< i
  ,lut2intp_X_data_11              //|< i
  ,lut2intp_X_data_20              //|< i
  ,lut2intp_X_data_20_17b          //|< i
  ,lut2intp_X_data_21              //|< i
  ,lut2intp_X_data_30              //|< i
  ,lut2intp_X_data_30_17b          //|< i
  ,lut2intp_X_data_31              //|< i
  ,lut2intp_X_data_40              //|< i
  ,lut2intp_X_data_40_17b          //|< i
  ,lut2intp_X_data_41              //|< i
  ,lut2intp_X_data_50              //|< i
  ,lut2intp_X_data_50_17b          //|< i
  ,lut2intp_X_data_51              //|< i
  ,lut2intp_X_data_60              //|< i
  ,lut2intp_X_data_60_17b          //|< i
  ,lut2intp_X_data_61              //|< i
  ,lut2intp_X_data_70              //|< i
  ,lut2intp_X_data_70_17b          //|< i
  ,lut2intp_X_data_71              //|< i
  ,lut2intp_X_info_0               //|< i
  ,lut2intp_X_info_1               //|< i
  ,lut2intp_X_info_2               //|< i
  ,lut2intp_X_info_3               //|< i
  ,lut2intp_X_info_4               //|< i
  ,lut2intp_X_info_5               //|< i
  ,lut2intp_X_info_6               //|< i
  ,lut2intp_X_info_7               //|< i
  ,lut2intp_X_sel                  //|< i
  ,lut2intp_Y_sel                  //|< i
  ,lut2intp_pvld                   //|< i
  ,nvdla_op_gated_clk_fp16         //|< i
  ,nvdla_op_gated_clk_int          //|< i
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
  ,intp2mul_pd_0                   //|> o
  ,intp2mul_pd_1                   //|> o
  ,intp2mul_pd_2                   //|> o
  ,intp2mul_pd_3                   //|> o
  ,intp2mul_pd_4                   //|> o
  ,intp2mul_pd_5                   //|> o
  ,intp2mul_pd_6                   //|> o
  ,intp2mul_pd_7                   //|> o
  ,intp2mul_pvld                   //|> o
  ,lut2intp_prdy                   //|> o
  ,sync2itp_prdy                   //|> o
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          dp2reg_done;
input          fp16_en;
input          int16_en;
input          int8_en;
input          intp2mul_prdy;
input   [31:0] lut2intp_X_data_00;
input   [16:0] lut2intp_X_data_00_17b;
input   [31:0] lut2intp_X_data_01;
input   [31:0] lut2intp_X_data_10;
input   [16:0] lut2intp_X_data_10_17b;
input   [31:0] lut2intp_X_data_11;
input   [31:0] lut2intp_X_data_20;
input   [16:0] lut2intp_X_data_20_17b;
input   [31:0] lut2intp_X_data_21;
input   [31:0] lut2intp_X_data_30;
input   [16:0] lut2intp_X_data_30_17b;
input   [31:0] lut2intp_X_data_31;
input   [31:0] lut2intp_X_data_40;
input   [16:0] lut2intp_X_data_40_17b;
input   [31:0] lut2intp_X_data_41;
input   [31:0] lut2intp_X_data_50;
input   [16:0] lut2intp_X_data_50_17b;
input   [31:0] lut2intp_X_data_51;
input   [31:0] lut2intp_X_data_60;
input   [16:0] lut2intp_X_data_60_17b;
input   [31:0] lut2intp_X_data_61;
input   [31:0] lut2intp_X_data_70;
input   [16:0] lut2intp_X_data_70_17b;
input   [31:0] lut2intp_X_data_71;
input   [19:0] lut2intp_X_info_0;
input   [19:0] lut2intp_X_info_1;
input   [19:0] lut2intp_X_info_2;
input   [19:0] lut2intp_X_info_3;
input   [19:0] lut2intp_X_info_4;
input   [19:0] lut2intp_X_info_5;
input   [19:0] lut2intp_X_info_6;
input   [19:0] lut2intp_X_info_7;
input    [7:0] lut2intp_X_sel;
input    [7:0] lut2intp_Y_sel;
input          lut2intp_pvld;
input          nvdla_op_gated_clk_fp16;
input          nvdla_op_gated_clk_int;
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
input  [167:0] sync2itp_pd;
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
output  [16:0] intp2mul_pd_0;
output  [16:0] intp2mul_pd_1;
output  [16:0] intp2mul_pd_2;
output  [16:0] intp2mul_pd_3;
output  [16:0] intp2mul_pd_4;
output  [16:0] intp2mul_pd_5;
output  [16:0] intp2mul_pd_6;
output  [16:0] intp2mul_pd_7;
output         intp2mul_pvld;
output         lut2intp_prdy;
output         sync2itp_prdy;
reg            X_exp;
reg     [38:0] Xinterp_in0_pd_0;
reg     [38:0] Xinterp_in0_pd_1;
reg     [38:0] Xinterp_in0_pd_2;
reg     [38:0] Xinterp_in0_pd_3;
reg     [38:0] Xinterp_in0_pd_4;
reg     [38:0] Xinterp_in0_pd_5;
reg     [38:0] Xinterp_in0_pd_6;
reg     [38:0] Xinterp_in0_pd_7;
reg     [37:0] Xinterp_in1_pd_0;
reg     [37:0] Xinterp_in1_pd_1;
reg     [37:0] Xinterp_in1_pd_2;
reg     [37:0] Xinterp_in1_pd_3;
reg     [37:0] Xinterp_in1_pd_4;
reg     [37:0] Xinterp_in1_pd_5;
reg     [37:0] Xinterp_in1_pd_6;
reg     [37:0] Xinterp_in1_pd_7;
reg     [16:0] Xinterp_in_pd_0;
reg     [16:0] Xinterp_in_pd_1;
reg     [16:0] Xinterp_in_pd_2;
reg     [16:0] Xinterp_in_pd_3;
reg     [16:0] Xinterp_in_pd_4;
reg     [16:0] Xinterp_in_pd_5;
reg     [16:0] Xinterp_in_pd_6;
reg     [16:0] Xinterp_in_pd_7;
reg     [16:0] Xinterp_in_scale_0;
reg     [16:0] Xinterp_in_scale_1;
reg     [16:0] Xinterp_in_scale_2;
reg     [16:0] Xinterp_in_scale_3;
reg     [16:0] Xinterp_in_scale_4;
reg     [16:0] Xinterp_in_scale_5;
reg     [16:0] Xinterp_in_scale_6;
reg     [16:0] Xinterp_in_scale_7;
reg      [5:0] Xinterp_in_shift_0;
reg      [5:0] Xinterp_in_shift_1;
reg      [5:0] Xinterp_in_shift_2;
reg      [5:0] Xinterp_in_shift_3;
reg      [5:0] Xinterp_in_shift_4;
reg      [5:0] Xinterp_in_shift_5;
reg      [5:0] Xinterp_in_shift_6;
reg      [5:0] Xinterp_in_shift_7;
reg     [31:0] both_hybrid_counter;
reg      [7:0] both_hybrid_flag;
reg     [31:0] both_of_counter;
reg      [7:0] both_of_flag;
reg     [31:0] both_uf_counter;
reg      [7:0] both_uf_flag;
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
reg    [135:0] intp2mul_pd;
reg            intp2mul_pvld;
reg            intp_pvld_d;
reg     [16:0] ip2mul_pd_0;
reg     [16:0] ip2mul_pd_1;
reg     [16:0] ip2mul_pd_2;
reg     [16:0] ip2mul_pd_3;
reg     [16:0] ip2mul_pd_4;
reg     [16:0] ip2mul_pd_5;
reg     [16:0] ip2mul_pd_6;
reg     [16:0] ip2mul_pd_7;
reg            ip2mul_prdy;
reg            layer_flg;
reg    [823:0] lut2intp_data;
reg            lut2intp_prdy;
reg            lut2intp_valid;
reg     [37:0] lut_le_max;
reg     [38:0] lut_le_min;
reg     [37:0] lut_lo_max;
reg     [37:0] lut_lo_min;
reg      [7:0] only_le_hit;
reg     [31:0] only_le_hit_counter;
reg      [7:0] only_lo_hit;
reg     [31:0] only_lo_hit_counter;
reg    [823:0] p1_pipe_data;
reg    [823:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [823:0] p1_skid_data;
reg    [823:0] p1_skid_pipe_data;
reg            p1_skid_pipe_ready;
reg            p1_skid_pipe_valid;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
reg    [135:0] p2_pipe_data;
reg    [135:0] p2_pipe_rand_data;
reg            p2_pipe_rand_ready;
reg            p2_pipe_rand_valid;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [135:0] p2_skid_data;
reg    [135:0] p2_skid_pipe_data;
reg            p2_skid_pipe_ready;
reg            p2_skid_pipe_valid;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
reg     [15:0] reg2dp_lut_le_slope_oflow_scale_sync;
reg      [4:0] reg2dp_lut_le_slope_oflow_shift_sync;
reg     [15:0] reg2dp_lut_le_slope_uflow_scale_sync;
reg      [4:0] reg2dp_lut_le_slope_uflow_shift_sync;
reg     [15:0] reg2dp_lut_lo_slope_oflow_scale_sync;
reg      [4:0] reg2dp_lut_lo_slope_oflow_shift_sync;
reg     [15:0] reg2dp_lut_lo_slope_uflow_scale_sync;
reg      [4:0] reg2dp_lut_lo_slope_uflow_shift_sync;
reg            sqsum_bypass_enable;
wire           NaN_flag_0;
wire           NaN_flag_1;
wire           NaN_flag_2;
wire           NaN_flag_3;
wire           NaN_in_flg_0;
wire           NaN_in_flg_1;
wire           NaN_in_flg_2;
wire           NaN_in_flg_3;
wire    [11:0] NaN_info_0;
wire    [11:0] NaN_info_1;
wire    [11:0] NaN_info_2;
wire    [11:0] NaN_info_3;
wire    [47:0] NaN_info_in;
wire     [9:0] NaN_mts_0;
wire     [9:0] NaN_mts_0_in;
wire     [9:0] NaN_mts_1;
wire     [9:0] NaN_mts_1_in;
wire     [9:0] NaN_mts_2;
wire     [9:0] NaN_mts_2_in;
wire     [9:0] NaN_mts_3;
wire     [9:0] NaN_mts_3_in;
wire           NaN_sign_0;
wire           NaN_sign_0_in;
wire           NaN_sign_1;
wire           NaN_sign_1_in;
wire           NaN_sign_2;
wire           NaN_sign_2_in;
wire           NaN_sign_3;
wire           NaN_sign_3_in;
wire     [1:0] X_info_0;
wire     [1:0] X_info_1;
wire     [1:0] X_info_2;
wire     [1:0] X_info_3;
wire     [1:0] X_info_4;
wire     [1:0] X_info_5;
wire     [1:0] X_info_6;
wire     [1:0] X_info_7;
wire           X_oflow_0;
wire           X_oflow_1;
wire           X_oflow_2;
wire           X_oflow_3;
wire           X_oflow_4;
wire           X_oflow_5;
wire           X_oflow_6;
wire           X_oflow_7;
wire           X_uflow_0;
wire           X_uflow_1;
wire           X_uflow_2;
wire           X_uflow_3;
wire           X_uflow_4;
wire           X_uflow_5;
wire           X_uflow_6;
wire           X_uflow_7;
wire     [7:0] Xinterp_in_rdy;
wire     [7:0] Xinterp_in_vld;
wire    [16:0] Xinterp_out_pd_0;
wire    [16:0] Xinterp_out_pd_1;
wire    [16:0] Xinterp_out_pd_2;
wire    [16:0] Xinterp_out_pd_3;
wire    [16:0] Xinterp_out_pd_4;
wire    [16:0] Xinterp_out_pd_5;
wire    [16:0] Xinterp_out_pd_6;
wire    [16:0] Xinterp_out_pd_7;
wire     [7:0] Xinterp_out_rdy;
wire     [7:0] Xinterp_out_vld;
wire     [1:0] Y_info_0;
wire     [1:0] Y_info_1;
wire     [1:0] Y_info_2;
wire     [1:0] Y_info_3;
wire     [1:0] Y_info_4;
wire     [1:0] Y_info_5;
wire     [1:0] Y_info_6;
wire     [1:0] Y_info_7;
wire           Y_oflow_0;
wire           Y_oflow_1;
wire           Y_oflow_2;
wire           Y_oflow_3;
wire           Y_oflow_4;
wire           Y_oflow_5;
wire           Y_oflow_6;
wire           Y_oflow_7;
wire           Y_uflow_0;
wire           Y_uflow_1;
wire           Y_uflow_2;
wire           Y_uflow_3;
wire           Y_uflow_4;
wire           Y_uflow_5;
wire           Y_uflow_6;
wire           Y_uflow_7;
wire    [31:0] both_hybrid_counter_nxt;
wire     [3:0] both_hybrid_ele;
wire    [31:0] both_of_counter_nxt;
wire     [3:0] both_of_ele;
wire    [31:0] both_uf_counter_nxt;
wire     [3:0] both_uf_ele;
wire    [31:0] dat_info_in;
wire     [7:0] exp_temp;
wire    [16:0] fp_le_slope_oflow_scale;
wire    [16:0] fp_le_slope_uflow_scale;
wire    [16:0] fp_lo_slope_oflow_scale;
wire    [16:0] fp_lo_slope_uflow_scale;
wire    [37:0] hit_in1_pd_0;
wire    [37:0] hit_in1_pd_1;
wire    [37:0] hit_in1_pd_2;
wire    [37:0] hit_in1_pd_3;
wire    [37:0] hit_in1_pd_4;
wire    [37:0] hit_in1_pd_5;
wire    [37:0] hit_in1_pd_6;
wire    [37:0] hit_in1_pd_7;
wire    [15:0] info_Xin_pd;
wire    [15:0] info_Yin_pd;
wire    [79:0] info_in_pd;
wire           info_in_rdy;
wire           info_in_vld;
wire    [79:0] info_o_pd;
wire           info_o_rdy;
wire           info_o_vld;
wire           intp_in_prdy;
wire           intp_in_pvld;
wire           intp_prdy;
wire           intp_prdy_d;
wire           intp_pvld;
wire   [135:0] ip2mul_pd;
wire           ip2mul_pvld;
wire           layer_done;
wire   [127:0] le_offset_exp;
wire    [31:0] le_offset_exp_fp;
wire     [6:0] le_offset_use;
wire    [16:0] le_slope_oflow_scale;
wire    [16:0] le_slope_uflow_scale;
wire    [16:0] lo_slope_oflow_scale;
wire    [16:0] lo_slope_uflow_scale;
wire   [823:0] lut2intp_pd;
wire           lut2intp_ready;
wire    [31:0] lut2ip_X_data_00;
wire    [16:0] lut2ip_X_data_00_17b;
wire    [31:0] lut2ip_X_data_01;
wire    [31:0] lut2ip_X_data_10;
wire    [16:0] lut2ip_X_data_10_17b;
wire    [31:0] lut2ip_X_data_11;
wire    [31:0] lut2ip_X_data_20;
wire    [16:0] lut2ip_X_data_20_17b;
wire    [31:0] lut2ip_X_data_21;
wire    [31:0] lut2ip_X_data_30;
wire    [16:0] lut2ip_X_data_30_17b;
wire    [31:0] lut2ip_X_data_31;
wire    [31:0] lut2ip_X_data_40;
wire    [16:0] lut2ip_X_data_40_17b;
wire    [31:0] lut2ip_X_data_41;
wire    [31:0] lut2ip_X_data_50;
wire    [16:0] lut2ip_X_data_50_17b;
wire    [31:0] lut2ip_X_data_51;
wire    [31:0] lut2ip_X_data_60;
wire    [16:0] lut2ip_X_data_60_17b;
wire    [31:0] lut2ip_X_data_61;
wire    [31:0] lut2ip_X_data_70;
wire    [16:0] lut2ip_X_data_70_17b;
wire    [31:0] lut2ip_X_data_71;
wire    [19:0] lut2ip_X_info_0;
wire    [19:0] lut2ip_X_info_1;
wire    [19:0] lut2ip_X_info_2;
wire    [19:0] lut2ip_X_info_3;
wire    [19:0] lut2ip_X_info_4;
wire    [19:0] lut2ip_X_info_5;
wire    [19:0] lut2ip_X_info_6;
wire    [19:0] lut2ip_X_info_7;
wire     [7:0] lut2ip_X_sel;
wire     [7:0] lut2ip_Y_sel;
wire    [37:0] lut_le_end;
wire    [31:0] lut_le_min_fp;
wire    [38:0] lut_le_min_int;
wire    [37:0] lut_le_start;
wire    [37:0] lut_lo_end;
wire    [37:0] lut_lo_start;
wire           mon_both_hybrid_counter_nxt;
wire           mon_both_of_counter_nxt;
wire           mon_both_uf_counter_nxt;
wire           mon_ext_temp;
wire    [90:0] mon_lut_le_min_int;
wire           mon_only_le_hit_counter_nxt;
wire           mon_only_lo_hit_counter_nxt;
wire    [31:0] only_le_hit_counter_nxt;
wire     [3:0] only_le_hit_ele;
wire    [31:0] only_lo_hit_counter_nxt;
wire     [3:0] only_lo_hit_ele;
wire    [37:0] sync2itp_fp32_0;
wire    [37:0] sync2itp_fp32_1;
wire    [37:0] sync2itp_fp32_2;
wire    [37:0] sync2itp_fp32_3;
wire    [37:0] sync2itp_int16_0;
wire    [37:0] sync2itp_int16_1;
wire    [37:0] sync2itp_int16_2;
wire    [37:0] sync2itp_int16_3;
wire    [37:0] sync2itp_int8_lsb_0;
wire    [37:0] sync2itp_int8_lsb_1;
wire    [37:0] sync2itp_int8_lsb_2;
wire    [37:0] sync2itp_int8_lsb_3;
wire    [37:0] sync2itp_int8_msb_0;
wire    [37:0] sync2itp_int8_msb_1;
wire    [37:0] sync2itp_int8_msb_2;
wire    [37:0] sync2itp_int8_msb_3;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    ///////////////////////////////////////////

//scale reg data format convertor for fp16 mode
//fp16 to fp17
//not use valid/ready protocol, because HLS_fp16_to_fp17 unit only 1 cycle latency
HLS_fp16_to_fp17 le_uflow_scale (
   .nvdla_core_clk          (nvdla_op_gated_clk_fp16)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
  ,.chn_a_rsc_z             (reg2dp_lut_le_slope_uflow_scale[15:0]) //|< i
  ,.chn_a_rsc_vz            (fp16_en)                               //|< i
  ,.chn_a_rsc_lz            ()                                      //|> ?
  ,.chn_o_rsc_z             (fp_le_slope_uflow_scale[16:0])         //|> w
  ,.chn_o_rsc_vz            (1'b1)                                  //|< ?
  ,.chn_o_rsc_lz            ()                                      //|> ?
  );
//1'b1;

HLS_fp16_to_fp17 le_oflow_scale (
   .nvdla_core_clk          (nvdla_op_gated_clk_fp16)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
  ,.chn_a_rsc_z             (reg2dp_lut_le_slope_oflow_scale[15:0]) //|< i
  ,.chn_a_rsc_vz            (fp16_en)                               //|< i
  ,.chn_a_rsc_lz            ()                                      //|> ?
  ,.chn_o_rsc_z             (fp_le_slope_oflow_scale[16:0])         //|> w
  ,.chn_o_rsc_vz            (1'b1)                                  //|< ?
  ,.chn_o_rsc_lz            ()                                      //|> ?
  );
//1'b1;

HLS_fp16_to_fp17 lo_uflow_scale (
   .nvdla_core_clk          (nvdla_op_gated_clk_fp16)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
  ,.chn_a_rsc_z             (reg2dp_lut_lo_slope_uflow_scale[15:0]) //|< i
  ,.chn_a_rsc_vz            (fp16_en)                               //|< i
  ,.chn_a_rsc_lz            ()                                      //|> ?
  ,.chn_o_rsc_z             (fp_lo_slope_uflow_scale[16:0])         //|> w
  ,.chn_o_rsc_vz            (1'b1)                                  //|< ?
  ,.chn_o_rsc_lz            ()                                      //|> ?
  );
//1'b1;

HLS_fp16_to_fp17 lo_oflow_scale (
   .nvdla_core_clk          (nvdla_op_gated_clk_fp16)               //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
  ,.chn_a_rsc_z             (reg2dp_lut_lo_slope_oflow_scale[15:0]) //|< i
  ,.chn_a_rsc_vz            (fp16_en)                               //|< i
  ,.chn_a_rsc_lz            ()                                      //|> ?
  ,.chn_o_rsc_z             (fp_lo_slope_oflow_scale[16:0])         //|> w
  ,.chn_o_rsc_vz            (1'b1)                                  //|< ?
  ,.chn_o_rsc_lz            ()                                      //|> ?
  );
//1'b1;

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
assign le_slope_uflow_scale = fp16_en ? fp_le_slope_uflow_scale : {reg2dp_lut_le_slope_uflow_scale_sync[15],reg2dp_lut_le_slope_uflow_scale_sync[15:0]};
assign le_slope_oflow_scale = fp16_en ? fp_le_slope_oflow_scale : {reg2dp_lut_le_slope_oflow_scale_sync[15],reg2dp_lut_le_slope_oflow_scale_sync[15:0]};
assign lo_slope_uflow_scale = fp16_en ? fp_lo_slope_uflow_scale : {reg2dp_lut_lo_slope_uflow_scale_sync[15],reg2dp_lut_lo_slope_uflow_scale_sync[15:0]};
assign lo_slope_oflow_scale = fp16_en ? fp_lo_slope_oflow_scale : {reg2dp_lut_lo_slope_oflow_scale_sync[15],reg2dp_lut_lo_slope_oflow_scale_sync[15:0]};
///////////////////////////////////////////
//assign both_hybrid_sel = (reg2dp_lut_hybrid_priority == NVDLA_CDP_S_LUT_CFG_0_LUT_HYBRID_PRIORITY_LO);
//assign both_of_sel  = (reg2dp_lut_oflow_priority == NVDLA_CDP_S_LUT_CFG_0_LUT_OFLOW_PRIORITY_LO);
//assign both_uf_sel  = (reg2dp_lut_uflow_priority == NVDLA_CDP_S_LUT_CFG_0_LUT_UFLOW_PRIORITY_LO);
///////////////////////////////////////////
//lut2intp pipe sync for timing
assign lut2intp_pd = {lut2intp_X_data_00[31:0],lut2intp_X_data_00_17b[16:0],lut2intp_X_data_01[31:0],
                      lut2intp_X_data_10[31:0],lut2intp_X_data_10_17b[16:0],lut2intp_X_data_11[31:0],
                      lut2intp_X_data_20[31:0],lut2intp_X_data_20_17b[16:0],lut2intp_X_data_21[31:0],
                      lut2intp_X_data_30[31:0],lut2intp_X_data_30_17b[16:0],lut2intp_X_data_31[31:0],
                      lut2intp_X_data_40[31:0],lut2intp_X_data_40_17b[16:0],lut2intp_X_data_41[31:0],
                      lut2intp_X_data_50[31:0],lut2intp_X_data_50_17b[16:0],lut2intp_X_data_51[31:0],
                      lut2intp_X_data_60[31:0],lut2intp_X_data_60_17b[16:0],lut2intp_X_data_61[31:0],
                      lut2intp_X_data_70[31:0],lut2intp_X_data_70_17b[16:0],lut2intp_X_data_71[31:0],
                      lut2intp_X_info_0[19:0],
                      lut2intp_X_info_1[19:0],
                      lut2intp_X_info_2[19:0],
                      lut2intp_X_info_3[19:0],
                      lut2intp_X_info_4[19:0],
                      lut2intp_X_info_5[19:0],
                      lut2intp_X_info_6[19:0],
                      lut2intp_X_info_7[19:0],
                      lut2intp_X_sel[7:0],
                      lut2intp_Y_sel[7:0]
                      };
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     lut2intp_pvld
  or p1_pipe_rand_ready
  or lut2intp_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = lut2intp_pvld;
  lut2intp_prdy = p1_pipe_rand_ready;
  p1_pipe_rand_data = lut2intp_pd;
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : lut2intp_pvld;
  lut2intp_prdy = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : lut2intp_pd;
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p1_pipe_stall_cycles;
integer p1_pipe_stall_probability;
integer p1_pipe_stall_cycles_min;
integer p1_pipe_stall_cycles_max;
initial begin
  p1_pipe_stall_cycles = 0;
  p1_pipe_stall_probability = 0;
  p1_pipe_stall_cycles_min = 1;
  p1_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or lut2intp_pvld
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && lut2intp_pvld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p1_pipe_rand_poised) begin
    if (p1_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p1_pipe_stall_cycles <= prand_inst1(p1_pipe_stall_cycles_min, p1_pipe_stall_cycles_max);
    end
  end else if (p1_pipe_rand_active) begin
    p1_pipe_stall_cycles <= p1_pipe_stall_cycles - 1;
  end else begin
    p1_pipe_stall_cycles <= 0;
  end
  end
end

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

`endif
// VCS coverage on
//## pipe (1) skid buffer
always @(
  p1_pipe_rand_valid
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_rand_valid && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_rand_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_rand_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_rand_valid
  or p1_skid_valid
  or p1_pipe_rand_data
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? p1_pipe_rand_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_skid_pipe_valid)? p1_skid_pipe_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_skid_pipe_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or lut2intp_ready
  or p1_pipe_data
  ) begin
  lut2intp_valid = p1_pipe_valid;
  p1_pipe_ready = lut2intp_ready;
  lut2intp_data = p1_pipe_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (lut2intp_valid^lut2intp_ready^lut2intp_pvld^lut2intp_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (lut2intp_pvld && !lut2intp_prdy), (lut2intp_pvld), (lut2intp_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif

assign {lut2ip_X_data_00[31:0],lut2ip_X_data_00_17b[16:0],lut2ip_X_data_01[31:0],
        lut2ip_X_data_10[31:0],lut2ip_X_data_10_17b[16:0],lut2ip_X_data_11[31:0],
        lut2ip_X_data_20[31:0],lut2ip_X_data_20_17b[16:0],lut2ip_X_data_21[31:0],
        lut2ip_X_data_30[31:0],lut2ip_X_data_30_17b[16:0],lut2ip_X_data_31[31:0],
        lut2ip_X_data_40[31:0],lut2ip_X_data_40_17b[16:0],lut2ip_X_data_41[31:0],
        lut2ip_X_data_50[31:0],lut2ip_X_data_50_17b[16:0],lut2ip_X_data_51[31:0],
        lut2ip_X_data_60[31:0],lut2ip_X_data_60_17b[16:0],lut2ip_X_data_61[31:0],
        lut2ip_X_data_70[31:0],lut2ip_X_data_70_17b[16:0],lut2ip_X_data_71[31:0],
        lut2ip_X_info_0[19:0],
        lut2ip_X_info_1[19:0],
        lut2ip_X_info_2[19:0],
        lut2ip_X_info_3[19:0],
        lut2ip_X_info_4[19:0],
        lut2ip_X_info_5[19:0],
        lut2ip_X_info_6[19:0],
        lut2ip_X_info_7[19:0],
        lut2ip_X_sel[7:0],
        lut2ip_Y_sel[7:0]} = lut2intp_data;
//        lut2ip_Y_data_00[31:0],lut2ip_Y_data_00_17b[16:0],lut2ip_Y_data_01[31:0],
//        lut2ip_Y_data_10[31:0],lut2ip_Y_data_10_17b[16:0],lut2ip_Y_data_11[31:0],
//        lut2ip_Y_data_20[31:0],lut2ip_Y_data_20_17b[16:0],lut2ip_Y_data_21[31:0],
//        lut2ip_Y_data_30[31:0],lut2ip_Y_data_30_17b[16:0],lut2ip_Y_data_31[31:0],
//        lut2ip_Y_data_40[31:0],lut2ip_Y_data_40_17b[16:0],lut2ip_Y_data_41[31:0],
//        lut2ip_Y_data_50[31:0],lut2ip_Y_data_50_17b[16:0],lut2ip_Y_data_51[31:0],
//        lut2ip_Y_data_60[31:0],lut2ip_Y_data_60_17b[16:0],lut2ip_Y_data_61[31:0],
//        lut2ip_Y_data_70[31:0],lut2ip_Y_data_70_17b[16:0],lut2ip_Y_data_71[31:0],
//        lut2ip_Y_info_0[18:0],
//        lut2ip_Y_info_1[18:0],
//        lut2ip_Y_info_2[18:0],
//        lut2ip_Y_info_3[18:0],
//        lut2ip_Y_info_4[18:0],
//        lut2ip_Y_info_5[18:0],
//        lut2ip_Y_info_6[18:0],
//        lut2ip_Y_info_7[18:0]} = lut2intp_data;

///////////////////////////////////////////
//lock
//from lut2int and sync2itp to intp_in
assign lut2intp_ready = intp_in_prdy & sync2itp_pvld;
assign sync2itp_prdy = intp_in_prdy & lut2intp_valid;
assign intp_in_pvld = sync2itp_pvld & lut2intp_valid;
///////////////////////////////////////////
//assign intp_in_prdy = (&Xinterp_in_rdy[7:0]) & (&Yinterp_in_rdy[7:0]) & info_in_rdy;
assign intp_in_prdy = (&Xinterp_in_rdy[7:0]) & info_in_rdy;

assign sync2itp_int8_lsb_0 = int8_en ? (sqsum_bypass_enable ? {{17{sync2itp_pd[20]}} ,sync2itp_pd[20:0]   } : {17'd0,sync2itp_pd[20:0]   }) : 38'd0;
assign sync2itp_int8_msb_0 = int8_en ? (sqsum_bypass_enable ? {{17{sync2itp_pd[41]}} ,sync2itp_pd[41:21]  } : {17'd0,sync2itp_pd[41:21]  }) : 38'd0;
assign sync2itp_int8_lsb_1 = int8_en ? (sqsum_bypass_enable ? {{17{sync2itp_pd[62]}} ,sync2itp_pd[62:42]  } : {17'd0,sync2itp_pd[62:42]  }) : 38'd0;
assign sync2itp_int8_msb_1 = int8_en ? (sqsum_bypass_enable ? {{17{sync2itp_pd[83]}} ,sync2itp_pd[83:63]  } : {17'd0,sync2itp_pd[83:63]  }) : 38'd0;
assign sync2itp_int8_lsb_2 = int8_en ? (sqsum_bypass_enable ? {{17{sync2itp_pd[104]}},sync2itp_pd[104:84] } : {17'd0,sync2itp_pd[104:84] }) : 38'd0;
assign sync2itp_int8_msb_2 = int8_en ? (sqsum_bypass_enable ? {{17{sync2itp_pd[125]}},sync2itp_pd[125:105]} : {17'd0,sync2itp_pd[125:105]}) : 38'd0;
assign sync2itp_int8_lsb_3 = int8_en ? (sqsum_bypass_enable ? {{17{sync2itp_pd[146]}},sync2itp_pd[146:126]} : {17'd0,sync2itp_pd[146:126]}) : 38'd0; 
assign sync2itp_int8_msb_3 = int8_en ? (sqsum_bypass_enable ? {{17{sync2itp_pd[167]}},sync2itp_pd[167:147]} : {17'd0,sync2itp_pd[167:147]}) : 38'd0;

assign sync2itp_int16_0 = int16_en ? (sqsum_bypass_enable ?  {sync2itp_pd[36 ],sync2itp_pd[36:0]   }: {1'b0,sync2itp_pd[36:0]   }) : 38'd0;
assign sync2itp_int16_1 = int16_en ? (sqsum_bypass_enable ?  {sync2itp_pd[78 ],sync2itp_pd[78:42]  }: {1'b0,sync2itp_pd[78:42]  }) : 38'd0;
assign sync2itp_int16_2 = int16_en ? (sqsum_bypass_enable ?  {sync2itp_pd[120],sync2itp_pd[120:84] }: {1'b0,sync2itp_pd[120:84] }) : 38'd0;
assign sync2itp_int16_3 = int16_en ? (sqsum_bypass_enable ?  {sync2itp_pd[162],sync2itp_pd[162:126]}: {1'b0,sync2itp_pd[162:126]}) : 38'd0;
//fp16 mode needn't sqsum_bypass_enable control because always use LSB signed 32bits 
assign sync2itp_fp32_0 = fp16_en ? {6'd0,sync2itp_pd[31:0]}    : 38'd0;
assign sync2itp_fp32_1 = fp16_en ? {6'd0,sync2itp_pd[73:42]}   : 38'd0;
assign sync2itp_fp32_2 = fp16_en ? {6'd0,sync2itp_pd[115:84]}  : 38'd0;
assign sync2itp_fp32_3 = fp16_en ? {6'd0,sync2itp_pd[157:126]} : 38'd0;

assign hit_in1_pd_0 = fp16_en ? sync2itp_fp32_0 : (int16_en ? sync2itp_int16_0 : sync2itp_int8_lsb_0);
assign hit_in1_pd_1 = fp16_en ? sync2itp_fp32_1 : (int16_en ? sync2itp_int16_1 : sync2itp_int8_lsb_1);
assign hit_in1_pd_2 = fp16_en ? sync2itp_fp32_2 : (int16_en ? sync2itp_int16_2 : sync2itp_int8_lsb_2);
assign hit_in1_pd_3 = fp16_en ? sync2itp_fp32_3 : (int16_en ? sync2itp_int16_3 : sync2itp_int8_lsb_3);
assign hit_in1_pd_4 = int8_en ? sync2itp_int8_msb_0 : 38'd0;
assign hit_in1_pd_5 = int8_en ? sync2itp_int8_msb_1 : 38'd0;
assign hit_in1_pd_6 = int8_en ? sync2itp_int8_msb_2 : 38'd0;
assign hit_in1_pd_7 = int8_en ? sync2itp_int8_msb_3 : 38'd0;
/////////////////////////////////////////////////
//start/end prepare for out of range interpolation
/////////////////////////////////////////////////

assign lut_le_end[37:0]   = {reg2dp_lut_le_end_high[5:0],reg2dp_lut_le_end_low[31:0]};
assign lut_le_start[37:0] = {reg2dp_lut_le_start_high[5:0],reg2dp_lut_le_start_low[31:0]};
assign lut_lo_end[37:0]   = {reg2dp_lut_lo_end_high[5:0],reg2dp_lut_lo_end_low[31:0]};
assign lut_lo_start[37:0] = {reg2dp_lut_lo_start_high[5:0],reg2dp_lut_lo_start_low[31:0]};

assign le_offset_use = reg2dp_lut_le_index_offset[6:0];
assign le_offset_exp[127:0] = reg2dp_lut_le_index_offset[7] ? 128'd0 : (1'b1 << le_offset_use);
//assign {mon_lut_le_min_int[91:0],lut_le_min_int[37:0]} = X_exp ? ($signed(::sign_extend(lut_le_start,38,129)) + $signed({1'b0,le_offset_exp})) : ::sign_extend(lut_le_start,38,130);
assign {mon_lut_le_min_int[90:0],lut_le_min_int[38:0]} = X_exp ? ($signed({{91{lut_le_start[37]}}, lut_le_start[37:0]}) + $signed({1'b0,le_offset_exp})) : {{92{lut_le_start[37]}}, lut_le_start[37:0]};

assign {mon_ext_temp,exp_temp[7:0]} = $signed(reg2dp_lut_le_index_offset[7:0]) + $signed({1'b0,7'h7f});
assign le_offset_exp_fp[31:0] = (X_exp & (reg2dp_lut_le_index_offset[7:0]!=8'h80) & (reg2dp_lut_le_index_offset[7:0]!=8'h81)) ? ({1'b0,exp_temp[7:0],23'd0}) : 32'd0;
HLS_fp32_add fp_le_min_pre (
   .nvdla_core_clk          (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
  ,.chn_a_rsc_z             (le_offset_exp_fp[31:0])                //|< w
  ,.chn_a_rsc_vz            (fp16_en)                               //|< i
  ,.chn_a_rsc_lz            ()                                      //|> ?
  ,.chn_b_rsc_z             (lut_le_start[31:0])                    //|< w
  ,.chn_b_rsc_vz            (fp16_en)                               //|< i
  ,.chn_b_rsc_lz            ()                                      //|> ?
  ,.chn_o_rsc_z             (lut_le_min_fp[31:0])                   //|> w
  ,.chn_o_rsc_vz            (1'b1)                                  //|< ?
  ,.chn_o_rsc_lz            ()                                      //|> ?
  );

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
  lut_le_min[38:0] <= fp16_en ? {{7{lut_le_min_fp[31]}}, lut_le_min_fp[31:0]} : lut_le_min_int;
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
 assign X_uflow_0 = lut2ip_X_info_0[16];   
 assign X_oflow_0 = lut2ip_X_info_0[17];   
 assign Y_uflow_0 = lut2ip_X_info_0[18];   
 assign Y_oflow_0 = lut2ip_X_info_0[19];   
 assign X_uflow_1 = lut2ip_X_info_1[16];   
 assign X_oflow_1 = lut2ip_X_info_1[17];   
 assign Y_uflow_1 = lut2ip_X_info_1[18];   
 assign Y_oflow_1 = lut2ip_X_info_1[19];   
 assign X_uflow_2 = lut2ip_X_info_2[16];   
 assign X_oflow_2 = lut2ip_X_info_2[17];   
 assign Y_uflow_2 = lut2ip_X_info_2[18];   
 assign Y_oflow_2 = lut2ip_X_info_2[19];   
 assign X_uflow_3 = lut2ip_X_info_3[16];   
 assign X_oflow_3 = lut2ip_X_info_3[17];   
 assign Y_uflow_3 = lut2ip_X_info_3[18];   
 assign Y_oflow_3 = lut2ip_X_info_3[19];   
 assign X_uflow_4 = lut2ip_X_info_4[16];   
 assign X_oflow_4 = lut2ip_X_info_4[17];   
 assign Y_uflow_4 = lut2ip_X_info_4[18];   
 assign Y_oflow_4 = lut2ip_X_info_4[19];   
 assign X_uflow_5 = lut2ip_X_info_5[16];   
 assign X_oflow_5 = lut2ip_X_info_5[17];   
 assign Y_uflow_5 = lut2ip_X_info_5[18];   
 assign Y_oflow_5 = lut2ip_X_info_5[19];   
 assign X_uflow_6 = lut2ip_X_info_6[16];   
 assign X_oflow_6 = lut2ip_X_info_6[17];   
 assign Y_uflow_6 = lut2ip_X_info_6[18];   
 assign Y_oflow_6 = lut2ip_X_info_6[19];   
 assign X_uflow_7 = lut2ip_X_info_7[16];   
 assign X_oflow_7 = lut2ip_X_info_7[17];   
 assign Y_uflow_7 = lut2ip_X_info_7[18];   
 assign Y_oflow_7 = lut2ip_X_info_7[19];   

//&PerlBeg;
//    for($i=0; $i<8; $i=$i+1) {
//    vprintl(" &Always; ");
//    vprintl("   if(lut2ip_X_sel[$i]) begin ");
//    vprintl("       if(X_uflow_$i) ");
//    vprintl("           Xinterp_in0_pd_$i = lut_le_min[37:0]; ");
//    vprintl("       else if(X_oflow_$i) ");
//    vprintl("           Xinterp_in0_pd_$i = lut_le_max[37:0]; ");
//    vprintl("       else ");
//    vprintl("           Xinterp_in0_pd_$i = {{6{lut2ip_X_data_${i}0[31]}},lut2ip_X_data_${i}0[31:0]}; ");
//    vprintl("   end else if(lut2ip_Y_sel[$i]) begin");
//    vprintl("       if(Y_uflow_$i) ");
//    vprintl("           Xinterp_in0_pd_$i = lut_lo_min[37:0]; ");
//    vprintl("       else if(Y_oflow_$i) ");
//    vprintl("           Xinterp_in0_pd_$i = lut_lo_max[37:0]; ");
//    vprintl("       else ");
//    vprintl("           Xinterp_in0_pd_$i = {{6{lut2ip_X_data_${i}0[31]}},lut2ip_X_data_${i}0[31:0]}; ");
//    vprintl("   end else");
//    vprintl("           Xinterp_in0_pd_$i = 38'd0; ");
//    vprintl(" &End; ");
//    }
//&PerlEnd;

 always @(
   lut2ip_X_sel
   or X_uflow_0
   or lut_le_min
   or X_oflow_0
   or lut_le_max
   or lut2ip_X_data_00
   or lut2ip_Y_sel
   or Y_uflow_0
   or lut_lo_min
   or Y_oflow_0
   or lut_lo_max
   ) begin
   if(lut2ip_X_sel[0]) begin 
       if(X_uflow_0) 
           Xinterp_in0_pd_0 = lut_le_min[38:0]; 
       else if(X_oflow_0) 
           Xinterp_in0_pd_0 = {lut_le_max[37],lut_le_max[37:0]}; 
       else 
           Xinterp_in0_pd_0 = {{7{lut2ip_X_data_00[31]}},lut2ip_X_data_00[31:0]}; 
   end else if(lut2ip_Y_sel[0]) begin
       if(Y_uflow_0) 
           Xinterp_in0_pd_0 = {lut_lo_min[37],lut_lo_min[37:0]}; 
       else if(Y_oflow_0) 
           Xinterp_in0_pd_0 = {lut_lo_max[37],lut_lo_max[37:0]}; 
       else 
           Xinterp_in0_pd_0 = {{7{lut2ip_X_data_00[31]}},lut2ip_X_data_00[31:0]}; 
   end else
           Xinterp_in0_pd_0 = 39'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_1
   or lut_le_min
   or X_oflow_1
   or lut_le_max
   or lut2ip_X_data_10
   or lut2ip_Y_sel
   or Y_uflow_1
   or lut_lo_min
   or Y_oflow_1
   or lut_lo_max
   ) begin
   if(lut2ip_X_sel[1]) begin 
       if(X_uflow_1) 
           Xinterp_in0_pd_1 = lut_le_min[38:0]; 
       else if(X_oflow_1) 
           Xinterp_in0_pd_1 = {lut_le_max[37],lut_le_max[37:0]}; 
       else 
           Xinterp_in0_pd_1 = {{7{lut2ip_X_data_10[31]}},lut2ip_X_data_10[31:0]}; 
   end else if(lut2ip_Y_sel[1]) begin
       if(Y_uflow_1) 
           Xinterp_in0_pd_1 = {lut_lo_min[37],lut_lo_min[37:0]}; 
       else if(Y_oflow_1) 
           Xinterp_in0_pd_1 = {lut_lo_max[37],lut_lo_max[37:0]}; 
       else 
           Xinterp_in0_pd_1 = {{7{lut2ip_X_data_10[31]}},lut2ip_X_data_10[31:0]}; 
   end else
           Xinterp_in0_pd_1 = 39'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_2
   or lut_le_min
   or X_oflow_2
   or lut_le_max
   or lut2ip_X_data_20
   or lut2ip_Y_sel
   or Y_uflow_2
   or lut_lo_min
   or Y_oflow_2
   or lut_lo_max
   ) begin
   if(lut2ip_X_sel[2]) begin 
       if(X_uflow_2) 
           Xinterp_in0_pd_2 = lut_le_min[38:0]; 
       else if(X_oflow_2) 
           Xinterp_in0_pd_2 = {lut_le_max[37],lut_le_max[37:0]}; 
       else 
           Xinterp_in0_pd_2 = {{7{lut2ip_X_data_20[31]}},lut2ip_X_data_20[31:0]}; 
   end else if(lut2ip_Y_sel[2]) begin
       if(Y_uflow_2) 
           Xinterp_in0_pd_2 = {lut_lo_min[37],lut_lo_min[37:0]}; 
       else if(Y_oflow_2) 
           Xinterp_in0_pd_2 = {lut_lo_max[37],lut_lo_max[37:0]}; 
       else 
           Xinterp_in0_pd_2 = {{7{lut2ip_X_data_20[31]}},lut2ip_X_data_20[31:0]}; 
   end else
           Xinterp_in0_pd_2 = 39'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_3
   or lut_le_min
   or X_oflow_3
   or lut_le_max
   or lut2ip_X_data_30
   or lut2ip_Y_sel
   or Y_uflow_3
   or lut_lo_min
   or Y_oflow_3
   or lut_lo_max
   ) begin
   if(lut2ip_X_sel[3]) begin 
       if(X_uflow_3) 
           Xinterp_in0_pd_3 = lut_le_min[38:0]; 
       else if(X_oflow_3) 
           Xinterp_in0_pd_3 = {lut_le_max[37],lut_le_max[37:0]}; 
       else 
           Xinterp_in0_pd_3 = {{7{lut2ip_X_data_30[31]}},lut2ip_X_data_30[31:0]}; 
   end else if(lut2ip_Y_sel[3]) begin
       if(Y_uflow_3) 
           Xinterp_in0_pd_3 = {lut_lo_min[37],lut_lo_min[37:0]}; 
       else if(Y_oflow_3) 
           Xinterp_in0_pd_3 = {lut_lo_max[37],lut_lo_max[37:0]}; 
       else 
           Xinterp_in0_pd_3 = {{7{lut2ip_X_data_30[31]}},lut2ip_X_data_30[31:0]}; 
   end else
           Xinterp_in0_pd_3 = 39'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_4
   or lut_le_min
   or X_oflow_4
   or lut_le_max
   or lut2ip_X_data_40
   or lut2ip_Y_sel
   or Y_uflow_4
   or lut_lo_min
   or Y_oflow_4
   or lut_lo_max
   ) begin
   if(lut2ip_X_sel[4]) begin 
       if(X_uflow_4) 
           Xinterp_in0_pd_4 = lut_le_min[38:0]; 
       else if(X_oflow_4) 
           Xinterp_in0_pd_4 = {lut_le_max[37],lut_le_max[37:0]}; 
       else 
           Xinterp_in0_pd_4 = {{7{lut2ip_X_data_40[31]}},lut2ip_X_data_40[31:0]}; 
   end else if(lut2ip_Y_sel[4]) begin
       if(Y_uflow_4) 
           Xinterp_in0_pd_4 = {lut_lo_min[37],lut_lo_min[37:0]}; 
       else if(Y_oflow_4) 
           Xinterp_in0_pd_4 = {lut_lo_max[37],lut_lo_max[37:0]}; 
       else 
           Xinterp_in0_pd_4 = {{7{lut2ip_X_data_40[31]}},lut2ip_X_data_40[31:0]}; 
   end else
           Xinterp_in0_pd_4 = 39'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_5
   or lut_le_min
   or X_oflow_5
   or lut_le_max
   or lut2ip_X_data_50
   or lut2ip_Y_sel
   or Y_uflow_5
   or lut_lo_min
   or Y_oflow_5
   or lut_lo_max
   ) begin
   if(lut2ip_X_sel[5]) begin 
       if(X_uflow_5) 
           Xinterp_in0_pd_5 = lut_le_min[38:0]; 
       else if(X_oflow_5) 
           Xinterp_in0_pd_5 = {lut_le_max[37],lut_le_max[37:0]}; 
       else 
           Xinterp_in0_pd_5 = {{7{lut2ip_X_data_50[31]}},lut2ip_X_data_50[31:0]}; 
   end else if(lut2ip_Y_sel[5]) begin
       if(Y_uflow_5) 
           Xinterp_in0_pd_5 = {lut_lo_min[37],lut_lo_min[37:0]}; 
       else if(Y_oflow_5) 
           Xinterp_in0_pd_5 = {lut_lo_max[37],lut_lo_max[37:0]}; 
       else 
           Xinterp_in0_pd_5 = {{7{lut2ip_X_data_50[31]}},lut2ip_X_data_50[31:0]}; 
   end else
           Xinterp_in0_pd_5 = 39'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_6
   or lut_le_min
   or X_oflow_6
   or lut_le_max
   or lut2ip_X_data_60
   or lut2ip_Y_sel
   or Y_uflow_6
   or lut_lo_min
   or Y_oflow_6
   or lut_lo_max
   ) begin
   if(lut2ip_X_sel[6]) begin 
       if(X_uflow_6) 
           Xinterp_in0_pd_6 = lut_le_min[38:0]; 
       else if(X_oflow_6) 
           Xinterp_in0_pd_6 = {lut_le_max[37],lut_le_max[37:0]}; 
       else 
           Xinterp_in0_pd_6 = {{7{lut2ip_X_data_60[31]}},lut2ip_X_data_60[31:0]}; 
   end else if(lut2ip_Y_sel[6]) begin
       if(Y_uflow_6) 
           Xinterp_in0_pd_6 = {lut_lo_min[37],lut_lo_min[37:0]}; 
       else if(Y_oflow_6) 
           Xinterp_in0_pd_6 = {lut_lo_max[37],lut_lo_max[37:0]}; 
       else 
           Xinterp_in0_pd_6 = {{7{lut2ip_X_data_60[31]}},lut2ip_X_data_60[31:0]}; 
   end else
           Xinterp_in0_pd_6 = 39'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_7
   or lut_le_min
   or X_oflow_7
   or lut_le_max
   or lut2ip_X_data_70
   or lut2ip_Y_sel
   or Y_uflow_7
   or lut_lo_min
   or Y_oflow_7
   or lut_lo_max
   ) begin
   if(lut2ip_X_sel[7]) begin 
       if(X_uflow_7) 
           Xinterp_in0_pd_7 = lut_le_min[38:0]; 
       else if(X_oflow_7) 
           Xinterp_in0_pd_7 = {lut_le_max[37],lut_le_max[37:0]}; 
       else 
           Xinterp_in0_pd_7 = {{7{lut2ip_X_data_70[31]}},lut2ip_X_data_70[31:0]}; 
   end else if(lut2ip_Y_sel[7]) begin
       if(Y_uflow_7) 
           Xinterp_in0_pd_7 = {lut_lo_min[37],lut_lo_min[37:0]}; 
       else if(Y_oflow_7) 
           Xinterp_in0_pd_7 = {lut_lo_max[37],lut_lo_max[37:0]}; 
       else 
           Xinterp_in0_pd_7 = {{7{lut2ip_X_data_70[31]}},lut2ip_X_data_70[31:0]}; 
   end else
           Xinterp_in0_pd_7 = 39'd0; 
 end

 always @(
   lut2ip_X_sel
   or X_uflow_0
   or X_oflow_0
   or hit_in1_pd_0
   or lut2ip_X_data_01
   or lut2ip_Y_sel
   or Y_uflow_0
   or Y_oflow_0
   ) begin
   if(lut2ip_X_sel[0]) begin 
       if(X_uflow_0 | X_oflow_0) 
           Xinterp_in1_pd_0 = hit_in1_pd_0; 
       else 
           Xinterp_in1_pd_0 = {{6{lut2ip_X_data_01[31]}},lut2ip_X_data_01[31:0]}; 
   end else if(lut2ip_Y_sel[0]) begin
       if(Y_uflow_0 | Y_oflow_0) 
           Xinterp_in1_pd_0 = hit_in1_pd_0; 
       else 
           Xinterp_in1_pd_0 = {{6{lut2ip_X_data_01[31]}},lut2ip_X_data_01[31:0]}; 
   end else
           Xinterp_in1_pd_0 = 38'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_1
   or X_oflow_1
   or hit_in1_pd_1
   or lut2ip_X_data_11
   or lut2ip_Y_sel
   or Y_uflow_1
   or Y_oflow_1
   ) begin
   if(lut2ip_X_sel[1]) begin 
       if(X_uflow_1 | X_oflow_1) 
           Xinterp_in1_pd_1 = hit_in1_pd_1; 
       else 
           Xinterp_in1_pd_1 = {{6{lut2ip_X_data_11[31]}},lut2ip_X_data_11[31:0]}; 
   end else if(lut2ip_Y_sel[1]) begin
       if(Y_uflow_1 | Y_oflow_1) 
           Xinterp_in1_pd_1 = hit_in1_pd_1; 
       else 
           Xinterp_in1_pd_1 = {{6{lut2ip_X_data_11[31]}},lut2ip_X_data_11[31:0]}; 
   end else
           Xinterp_in1_pd_1 = 38'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_2
   or X_oflow_2
   or hit_in1_pd_2
   or lut2ip_X_data_21
   or lut2ip_Y_sel
   or Y_uflow_2
   or Y_oflow_2
   ) begin
   if(lut2ip_X_sel[2]) begin 
       if(X_uflow_2 | X_oflow_2) 
           Xinterp_in1_pd_2 = hit_in1_pd_2; 
       else 
           Xinterp_in1_pd_2 = {{6{lut2ip_X_data_21[31]}},lut2ip_X_data_21[31:0]}; 
   end else if(lut2ip_Y_sel[2]) begin
       if(Y_uflow_2 | Y_oflow_2) 
           Xinterp_in1_pd_2 = hit_in1_pd_2; 
       else 
           Xinterp_in1_pd_2 = {{6{lut2ip_X_data_21[31]}},lut2ip_X_data_21[31:0]}; 
   end else
           Xinterp_in1_pd_2 = 38'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_3
   or X_oflow_3
   or hit_in1_pd_3
   or lut2ip_X_data_31
   or lut2ip_Y_sel
   or Y_uflow_3
   or Y_oflow_3
   ) begin
   if(lut2ip_X_sel[3]) begin 
       if(X_uflow_3 | X_oflow_3) 
           Xinterp_in1_pd_3 = hit_in1_pd_3; 
       else 
           Xinterp_in1_pd_3 = {{6{lut2ip_X_data_31[31]}},lut2ip_X_data_31[31:0]}; 
   end else if(lut2ip_Y_sel[3]) begin
       if(Y_uflow_3 | Y_oflow_3) 
           Xinterp_in1_pd_3 = hit_in1_pd_3; 
       else 
           Xinterp_in1_pd_3 = {{6{lut2ip_X_data_31[31]}},lut2ip_X_data_31[31:0]}; 
   end else
           Xinterp_in1_pd_3 = 38'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_4
   or X_oflow_4
   or hit_in1_pd_4
   or lut2ip_X_data_41
   or lut2ip_Y_sel
   or Y_uflow_4
   or Y_oflow_4
   ) begin
   if(lut2ip_X_sel[4]) begin 
       if(X_uflow_4 | X_oflow_4) 
           Xinterp_in1_pd_4 = hit_in1_pd_4; 
       else 
           Xinterp_in1_pd_4 = {{6{lut2ip_X_data_41[31]}},lut2ip_X_data_41[31:0]}; 
   end else if(lut2ip_Y_sel[4]) begin
       if(Y_uflow_4 | Y_oflow_4) 
           Xinterp_in1_pd_4 = hit_in1_pd_4; 
       else 
           Xinterp_in1_pd_4 = {{6{lut2ip_X_data_41[31]}},lut2ip_X_data_41[31:0]}; 
   end else
           Xinterp_in1_pd_4 = 38'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_5
   or X_oflow_5
   or hit_in1_pd_5
   or lut2ip_X_data_51
   or lut2ip_Y_sel
   or Y_uflow_5
   or Y_oflow_5
   ) begin
   if(lut2ip_X_sel[5]) begin 
       if(X_uflow_5 | X_oflow_5) 
           Xinterp_in1_pd_5 = hit_in1_pd_5; 
       else 
           Xinterp_in1_pd_5 = {{6{lut2ip_X_data_51[31]}},lut2ip_X_data_51[31:0]}; 
   end else if(lut2ip_Y_sel[5]) begin
       if(Y_uflow_5 | Y_oflow_5) 
           Xinterp_in1_pd_5 = hit_in1_pd_5; 
       else 
           Xinterp_in1_pd_5 = {{6{lut2ip_X_data_51[31]}},lut2ip_X_data_51[31:0]}; 
   end else
           Xinterp_in1_pd_5 = 38'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_6
   or X_oflow_6
   or hit_in1_pd_6
   or lut2ip_X_data_61
   or lut2ip_Y_sel
   or Y_uflow_6
   or Y_oflow_6
   ) begin
   if(lut2ip_X_sel[6]) begin 
       if(X_uflow_6 | X_oflow_6) 
           Xinterp_in1_pd_6 = hit_in1_pd_6; 
       else 
           Xinterp_in1_pd_6 = {{6{lut2ip_X_data_61[31]}},lut2ip_X_data_61[31:0]}; 
   end else if(lut2ip_Y_sel[6]) begin
       if(Y_uflow_6 | Y_oflow_6) 
           Xinterp_in1_pd_6 = hit_in1_pd_6; 
       else 
           Xinterp_in1_pd_6 = {{6{lut2ip_X_data_61[31]}},lut2ip_X_data_61[31:0]}; 
   end else
           Xinterp_in1_pd_6 = 38'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_7
   or X_oflow_7
   or hit_in1_pd_7
   or lut2ip_X_data_71
   or lut2ip_Y_sel
   or Y_uflow_7
   or Y_oflow_7
   ) begin
   if(lut2ip_X_sel[7]) begin 
       if(X_uflow_7 | X_oflow_7) 
           Xinterp_in1_pd_7 = hit_in1_pd_7; 
       else 
           Xinterp_in1_pd_7 = {{6{lut2ip_X_data_71[31]}},lut2ip_X_data_71[31:0]}; 
   end else if(lut2ip_Y_sel[7]) begin
       if(Y_uflow_7 | Y_oflow_7) 
           Xinterp_in1_pd_7 = hit_in1_pd_7; 
       else 
           Xinterp_in1_pd_7 = {{6{lut2ip_X_data_71[31]}},lut2ip_X_data_71[31:0]}; 
   end else
           Xinterp_in1_pd_7 = 38'd0; 
 end

 always @(
   lut2ip_X_sel
   or lut2ip_Y_sel
   or lut2ip_X_data_00_17b
   ) begin
   if(lut2ip_X_sel[0] | lut2ip_Y_sel[0]) 
       Xinterp_in_pd_0 = lut2ip_X_data_00_17b[16:0]; 
   else 
       Xinterp_in_pd_0 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or lut2ip_Y_sel
   or lut2ip_X_data_10_17b
   ) begin
   if(lut2ip_X_sel[1] | lut2ip_Y_sel[1]) 
       Xinterp_in_pd_1 = lut2ip_X_data_10_17b[16:0]; 
   else 
       Xinterp_in_pd_1 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or lut2ip_Y_sel
   or lut2ip_X_data_20_17b
   ) begin
   if(lut2ip_X_sel[2] | lut2ip_Y_sel[2]) 
       Xinterp_in_pd_2 = lut2ip_X_data_20_17b[16:0]; 
   else 
       Xinterp_in_pd_2 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or lut2ip_Y_sel
   or lut2ip_X_data_30_17b
   ) begin
   if(lut2ip_X_sel[3] | lut2ip_Y_sel[3]) 
       Xinterp_in_pd_3 = lut2ip_X_data_30_17b[16:0]; 
   else 
       Xinterp_in_pd_3 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or lut2ip_Y_sel
   or lut2ip_X_data_40_17b
   ) begin
   if(lut2ip_X_sel[4] | lut2ip_Y_sel[4]) 
       Xinterp_in_pd_4 = lut2ip_X_data_40_17b[16:0]; 
   else 
       Xinterp_in_pd_4 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or lut2ip_Y_sel
   or lut2ip_X_data_50_17b
   ) begin
   if(lut2ip_X_sel[5] | lut2ip_Y_sel[5]) 
       Xinterp_in_pd_5 = lut2ip_X_data_50_17b[16:0]; 
   else 
       Xinterp_in_pd_5 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or lut2ip_Y_sel
   or lut2ip_X_data_60_17b
   ) begin
   if(lut2ip_X_sel[6] | lut2ip_Y_sel[6]) 
       Xinterp_in_pd_6 = lut2ip_X_data_60_17b[16:0]; 
   else 
       Xinterp_in_pd_6 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or lut2ip_Y_sel
   or lut2ip_X_data_70_17b
   ) begin
   if(lut2ip_X_sel[7] | lut2ip_Y_sel[7]) 
       Xinterp_in_pd_7 = lut2ip_X_data_70_17b[16:0]; 
   else 
       Xinterp_in_pd_7 = 17'd0; 
 end

 always @(
   lut2ip_X_sel
   or X_uflow_0
   or le_slope_uflow_scale
   or X_oflow_0
   or le_slope_oflow_scale
   or lut2ip_X_info_0
   or lut2ip_Y_sel
   or Y_uflow_0
   or lo_slope_uflow_scale
   or Y_oflow_0
   or lo_slope_oflow_scale
   ) begin
   if(lut2ip_X_sel[0]) begin 
       if(X_uflow_0) 
           Xinterp_in_scale_0 = le_slope_uflow_scale[16:0]; 
       else if(X_oflow_0) 
           Xinterp_in_scale_0 = le_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_0 = {1'b0,lut2ip_X_info_0[15:0]}; 
   end else if(lut2ip_Y_sel[0]) begin
       if(Y_uflow_0) 
           Xinterp_in_scale_0 = lo_slope_uflow_scale[16:0]; 
       else if(Y_oflow_0) 
           Xinterp_in_scale_0 = lo_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_0 = {1'b0,lut2ip_X_info_0[15:0]}; 
   end else
           Xinterp_in_scale_0 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_1
   or le_slope_uflow_scale
   or X_oflow_1
   or le_slope_oflow_scale
   or lut2ip_X_info_1
   or lut2ip_Y_sel
   or Y_uflow_1
   or lo_slope_uflow_scale
   or Y_oflow_1
   or lo_slope_oflow_scale
   ) begin
   if(lut2ip_X_sel[1]) begin 
       if(X_uflow_1) 
           Xinterp_in_scale_1 = le_slope_uflow_scale[16:0]; 
       else if(X_oflow_1) 
           Xinterp_in_scale_1 = le_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_1 = {1'b0,lut2ip_X_info_1[15:0]}; 
   end else if(lut2ip_Y_sel[1]) begin
       if(Y_uflow_1) 
           Xinterp_in_scale_1 = lo_slope_uflow_scale[16:0]; 
       else if(Y_oflow_1) 
           Xinterp_in_scale_1 = lo_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_1 = {1'b0,lut2ip_X_info_1[15:0]}; 
   end else
           Xinterp_in_scale_1 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_2
   or le_slope_uflow_scale
   or X_oflow_2
   or le_slope_oflow_scale
   or lut2ip_X_info_2
   or lut2ip_Y_sel
   or Y_uflow_2
   or lo_slope_uflow_scale
   or Y_oflow_2
   or lo_slope_oflow_scale
   ) begin
   if(lut2ip_X_sel[2]) begin 
       if(X_uflow_2) 
           Xinterp_in_scale_2 = le_slope_uflow_scale[16:0]; 
       else if(X_oflow_2) 
           Xinterp_in_scale_2 = le_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_2 = {1'b0,lut2ip_X_info_2[15:0]}; 
   end else if(lut2ip_Y_sel[2]) begin
       if(Y_uflow_2) 
           Xinterp_in_scale_2 = lo_slope_uflow_scale[16:0]; 
       else if(Y_oflow_2) 
           Xinterp_in_scale_2 = lo_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_2 = {1'b0,lut2ip_X_info_2[15:0]}; 
   end else
           Xinterp_in_scale_2 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_3
   or le_slope_uflow_scale
   or X_oflow_3
   or le_slope_oflow_scale
   or lut2ip_X_info_3
   or lut2ip_Y_sel
   or Y_uflow_3
   or lo_slope_uflow_scale
   or Y_oflow_3
   or lo_slope_oflow_scale
   ) begin
   if(lut2ip_X_sel[3]) begin 
       if(X_uflow_3) 
           Xinterp_in_scale_3 = le_slope_uflow_scale[16:0]; 
       else if(X_oflow_3) 
           Xinterp_in_scale_3 = le_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_3 = {1'b0,lut2ip_X_info_3[15:0]}; 
   end else if(lut2ip_Y_sel[3]) begin
       if(Y_uflow_3) 
           Xinterp_in_scale_3 = lo_slope_uflow_scale[16:0]; 
       else if(Y_oflow_3) 
           Xinterp_in_scale_3 = lo_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_3 = {1'b0,lut2ip_X_info_3[15:0]}; 
   end else
           Xinterp_in_scale_3 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_4
   or le_slope_uflow_scale
   or X_oflow_4
   or le_slope_oflow_scale
   or lut2ip_X_info_4
   or lut2ip_Y_sel
   or Y_uflow_4
   or lo_slope_uflow_scale
   or Y_oflow_4
   or lo_slope_oflow_scale
   ) begin
   if(lut2ip_X_sel[4]) begin 
       if(X_uflow_4) 
           Xinterp_in_scale_4 = le_slope_uflow_scale[16:0]; 
       else if(X_oflow_4) 
           Xinterp_in_scale_4 = le_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_4 = {1'b0,lut2ip_X_info_4[15:0]}; 
   end else if(lut2ip_Y_sel[4]) begin
       if(Y_uflow_4) 
           Xinterp_in_scale_4 = lo_slope_uflow_scale[16:0]; 
       else if(Y_oflow_4) 
           Xinterp_in_scale_4 = lo_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_4 = {1'b0,lut2ip_X_info_4[15:0]}; 
   end else
           Xinterp_in_scale_4 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_5
   or le_slope_uflow_scale
   or X_oflow_5
   or le_slope_oflow_scale
   or lut2ip_X_info_5
   or lut2ip_Y_sel
   or Y_uflow_5
   or lo_slope_uflow_scale
   or Y_oflow_5
   or lo_slope_oflow_scale
   ) begin
   if(lut2ip_X_sel[5]) begin 
       if(X_uflow_5) 
           Xinterp_in_scale_5 = le_slope_uflow_scale[16:0]; 
       else if(X_oflow_5) 
           Xinterp_in_scale_5 = le_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_5 = {1'b0,lut2ip_X_info_5[15:0]}; 
   end else if(lut2ip_Y_sel[5]) begin
       if(Y_uflow_5) 
           Xinterp_in_scale_5 = lo_slope_uflow_scale[16:0]; 
       else if(Y_oflow_5) 
           Xinterp_in_scale_5 = lo_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_5 = {1'b0,lut2ip_X_info_5[15:0]}; 
   end else
           Xinterp_in_scale_5 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_6
   or le_slope_uflow_scale
   or X_oflow_6
   or le_slope_oflow_scale
   or lut2ip_X_info_6
   or lut2ip_Y_sel
   or Y_uflow_6
   or lo_slope_uflow_scale
   or Y_oflow_6
   or lo_slope_oflow_scale
   ) begin
   if(lut2ip_X_sel[6]) begin 
       if(X_uflow_6) 
           Xinterp_in_scale_6 = le_slope_uflow_scale[16:0]; 
       else if(X_oflow_6) 
           Xinterp_in_scale_6 = le_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_6 = {1'b0,lut2ip_X_info_6[15:0]}; 
   end else if(lut2ip_Y_sel[6]) begin
       if(Y_uflow_6) 
           Xinterp_in_scale_6 = lo_slope_uflow_scale[16:0]; 
       else if(Y_oflow_6) 
           Xinterp_in_scale_6 = lo_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_6 = {1'b0,lut2ip_X_info_6[15:0]}; 
   end else
           Xinterp_in_scale_6 = 17'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_7
   or le_slope_uflow_scale
   or X_oflow_7
   or le_slope_oflow_scale
   or lut2ip_X_info_7
   or lut2ip_Y_sel
   or Y_uflow_7
   or lo_slope_uflow_scale
   or Y_oflow_7
   or lo_slope_oflow_scale
   ) begin
   if(lut2ip_X_sel[7]) begin 
       if(X_uflow_7) 
           Xinterp_in_scale_7 = le_slope_uflow_scale[16:0]; 
       else if(X_oflow_7) 
           Xinterp_in_scale_7 = le_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_7 = {1'b0,lut2ip_X_info_7[15:0]}; 
   end else if(lut2ip_Y_sel[7]) begin
       if(Y_uflow_7) 
           Xinterp_in_scale_7 = lo_slope_uflow_scale[16:0]; 
       else if(Y_oflow_7) 
           Xinterp_in_scale_7 = lo_slope_oflow_scale[16:0]; 
       else 
           Xinterp_in_scale_7 = {1'b0,lut2ip_X_info_7[15:0]}; 
   end else
           Xinterp_in_scale_7 = 17'd0; 
 end

 always @(
   lut2ip_X_sel
   or X_uflow_0
   or reg2dp_lut_le_slope_uflow_shift_sync
   or X_oflow_0
   or reg2dp_lut_le_slope_oflow_shift_sync
   or lut2ip_Y_sel
   or Y_uflow_0
   or reg2dp_lut_lo_slope_uflow_shift_sync
   or Y_oflow_0
   or reg2dp_lut_lo_slope_oflow_shift_sync
   ) begin
   if(lut2ip_X_sel[0]) begin 
       if(X_uflow_0) 
           Xinterp_in_shift_0 = {{1{reg2dp_lut_le_slope_uflow_shift_sync[4]}}, reg2dp_lut_le_slope_uflow_shift_sync[4:0]}; 
       else if(X_oflow_0) 
           Xinterp_in_shift_0 = {{1{reg2dp_lut_le_slope_oflow_shift_sync[4]}}, reg2dp_lut_le_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_0 = {1'b0,5'd16}; 
   end else if(lut2ip_Y_sel[0]) begin
       if(Y_uflow_0) 
           Xinterp_in_shift_0 = {{1{reg2dp_lut_lo_slope_uflow_shift_sync[4]}}, reg2dp_lut_lo_slope_uflow_shift_sync[4:0]}; 
       else if(Y_oflow_0) 
           Xinterp_in_shift_0 = {{1{reg2dp_lut_lo_slope_oflow_shift_sync[4]}}, reg2dp_lut_lo_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_0 = {1'b0,5'd16}; 
   end else
           Xinterp_in_shift_0 = 6'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_1
   or reg2dp_lut_le_slope_uflow_shift_sync
   or X_oflow_1
   or reg2dp_lut_le_slope_oflow_shift_sync
   or lut2ip_Y_sel
   or Y_uflow_1
   or reg2dp_lut_lo_slope_uflow_shift_sync
   or Y_oflow_1
   or reg2dp_lut_lo_slope_oflow_shift_sync
   ) begin
   if(lut2ip_X_sel[1]) begin 
       if(X_uflow_1) 
           Xinterp_in_shift_1 = {{1{reg2dp_lut_le_slope_uflow_shift_sync[4]}}, reg2dp_lut_le_slope_uflow_shift_sync[4:0]}; 
       else if(X_oflow_1) 
           Xinterp_in_shift_1 = {{1{reg2dp_lut_le_slope_oflow_shift_sync[4]}}, reg2dp_lut_le_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_1 = {1'b0,5'd16}; 
   end else if(lut2ip_Y_sel[1]) begin
       if(Y_uflow_1) 
           Xinterp_in_shift_1 = {{1{reg2dp_lut_lo_slope_uflow_shift_sync[4]}}, reg2dp_lut_lo_slope_uflow_shift_sync[4:0]}; 
       else if(Y_oflow_1) 
           Xinterp_in_shift_1 = {{1{reg2dp_lut_lo_slope_oflow_shift_sync[4]}}, reg2dp_lut_lo_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_1 = {1'b0,5'd16}; 
   end else
           Xinterp_in_shift_1 = 6'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_2
   or reg2dp_lut_le_slope_uflow_shift_sync
   or X_oflow_2
   or reg2dp_lut_le_slope_oflow_shift_sync
   or lut2ip_Y_sel
   or Y_uflow_2
   or reg2dp_lut_lo_slope_uflow_shift_sync
   or Y_oflow_2
   or reg2dp_lut_lo_slope_oflow_shift_sync
   ) begin
   if(lut2ip_X_sel[2]) begin 
       if(X_uflow_2) 
           Xinterp_in_shift_2 = {{1{reg2dp_lut_le_slope_uflow_shift_sync[4]}}, reg2dp_lut_le_slope_uflow_shift_sync[4:0]}; 
       else if(X_oflow_2) 
           Xinterp_in_shift_2 = {{1{reg2dp_lut_le_slope_oflow_shift_sync[4]}}, reg2dp_lut_le_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_2 = {1'b0,5'd16}; 
   end else if(lut2ip_Y_sel[2]) begin
       if(Y_uflow_2) 
           Xinterp_in_shift_2 = {{1{reg2dp_lut_lo_slope_uflow_shift_sync[4]}}, reg2dp_lut_lo_slope_uflow_shift_sync[4:0]}; 
       else if(Y_oflow_2) 
           Xinterp_in_shift_2 = {{1{reg2dp_lut_lo_slope_oflow_shift_sync[4]}}, reg2dp_lut_lo_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_2 = {1'b0,5'd16}; 
   end else
           Xinterp_in_shift_2 = 6'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_3
   or reg2dp_lut_le_slope_uflow_shift_sync
   or X_oflow_3
   or reg2dp_lut_le_slope_oflow_shift_sync
   or lut2ip_Y_sel
   or Y_uflow_3
   or reg2dp_lut_lo_slope_uflow_shift_sync
   or Y_oflow_3
   or reg2dp_lut_lo_slope_oflow_shift_sync
   ) begin
   if(lut2ip_X_sel[3]) begin 
       if(X_uflow_3) 
           Xinterp_in_shift_3 = {{1{reg2dp_lut_le_slope_uflow_shift_sync[4]}}, reg2dp_lut_le_slope_uflow_shift_sync[4:0]}; 
       else if(X_oflow_3) 
           Xinterp_in_shift_3 = {{1{reg2dp_lut_le_slope_oflow_shift_sync[4]}}, reg2dp_lut_le_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_3 = {1'b0,5'd16}; 
   end else if(lut2ip_Y_sel[3]) begin
       if(Y_uflow_3) 
           Xinterp_in_shift_3 = {{1{reg2dp_lut_lo_slope_uflow_shift_sync[4]}}, reg2dp_lut_lo_slope_uflow_shift_sync[4:0]}; 
       else if(Y_oflow_3) 
           Xinterp_in_shift_3 = {{1{reg2dp_lut_lo_slope_oflow_shift_sync[4]}}, reg2dp_lut_lo_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_3 = {1'b0,5'd16}; 
   end else
           Xinterp_in_shift_3 = 6'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_4
   or reg2dp_lut_le_slope_uflow_shift_sync
   or X_oflow_4
   or reg2dp_lut_le_slope_oflow_shift_sync
   or lut2ip_Y_sel
   or Y_uflow_4
   or reg2dp_lut_lo_slope_uflow_shift_sync
   or Y_oflow_4
   or reg2dp_lut_lo_slope_oflow_shift_sync
   ) begin
   if(lut2ip_X_sel[4]) begin 
       if(X_uflow_4) 
           Xinterp_in_shift_4 = {{1{reg2dp_lut_le_slope_uflow_shift_sync[4]}}, reg2dp_lut_le_slope_uflow_shift_sync[4:0]}; 
       else if(X_oflow_4) 
           Xinterp_in_shift_4 = {{1{reg2dp_lut_le_slope_oflow_shift_sync[4]}}, reg2dp_lut_le_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_4 = {1'b0,5'd16}; 
   end else if(lut2ip_Y_sel[4]) begin
       if(Y_uflow_4) 
           Xinterp_in_shift_4 = {{1{reg2dp_lut_lo_slope_uflow_shift_sync[4]}}, reg2dp_lut_lo_slope_uflow_shift_sync[4:0]}; 
       else if(Y_oflow_4) 
           Xinterp_in_shift_4 = {{1{reg2dp_lut_lo_slope_oflow_shift_sync[4]}}, reg2dp_lut_lo_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_4 = {1'b0,5'd16}; 
   end else
           Xinterp_in_shift_4 = 6'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_5
   or reg2dp_lut_le_slope_uflow_shift_sync
   or X_oflow_5
   or reg2dp_lut_le_slope_oflow_shift_sync
   or lut2ip_Y_sel
   or Y_uflow_5
   or reg2dp_lut_lo_slope_uflow_shift_sync
   or Y_oflow_5
   or reg2dp_lut_lo_slope_oflow_shift_sync
   ) begin
   if(lut2ip_X_sel[5]) begin 
       if(X_uflow_5) 
           Xinterp_in_shift_5 = {{1{reg2dp_lut_le_slope_uflow_shift_sync[4]}}, reg2dp_lut_le_slope_uflow_shift_sync[4:0]}; 
       else if(X_oflow_5) 
           Xinterp_in_shift_5 = {{1{reg2dp_lut_le_slope_oflow_shift_sync[4]}}, reg2dp_lut_le_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_5 = {1'b0,5'd16}; 
   end else if(lut2ip_Y_sel[5]) begin
       if(Y_uflow_5) 
           Xinterp_in_shift_5 = {{1{reg2dp_lut_lo_slope_uflow_shift_sync[4]}}, reg2dp_lut_lo_slope_uflow_shift_sync[4:0]}; 
       else if(Y_oflow_5) 
           Xinterp_in_shift_5 = {{1{reg2dp_lut_lo_slope_oflow_shift_sync[4]}}, reg2dp_lut_lo_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_5 = {1'b0,5'd16}; 
   end else
           Xinterp_in_shift_5 = 6'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_6
   or reg2dp_lut_le_slope_uflow_shift_sync
   or X_oflow_6
   or reg2dp_lut_le_slope_oflow_shift_sync
   or lut2ip_Y_sel
   or Y_uflow_6
   or reg2dp_lut_lo_slope_uflow_shift_sync
   or Y_oflow_6
   or reg2dp_lut_lo_slope_oflow_shift_sync
   ) begin
   if(lut2ip_X_sel[6]) begin 
       if(X_uflow_6) 
           Xinterp_in_shift_6 = {{1{reg2dp_lut_le_slope_uflow_shift_sync[4]}}, reg2dp_lut_le_slope_uflow_shift_sync[4:0]}; 
       else if(X_oflow_6) 
           Xinterp_in_shift_6 = {{1{reg2dp_lut_le_slope_oflow_shift_sync[4]}}, reg2dp_lut_le_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_6 = {1'b0,5'd16}; 
   end else if(lut2ip_Y_sel[6]) begin
       if(Y_uflow_6) 
           Xinterp_in_shift_6 = {{1{reg2dp_lut_lo_slope_uflow_shift_sync[4]}}, reg2dp_lut_lo_slope_uflow_shift_sync[4:0]}; 
       else if(Y_oflow_6) 
           Xinterp_in_shift_6 = {{1{reg2dp_lut_lo_slope_oflow_shift_sync[4]}}, reg2dp_lut_lo_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_6 = {1'b0,5'd16}; 
   end else
           Xinterp_in_shift_6 = 6'd0; 
 end
 always @(
   lut2ip_X_sel
   or X_uflow_7
   or reg2dp_lut_le_slope_uflow_shift_sync
   or X_oflow_7
   or reg2dp_lut_le_slope_oflow_shift_sync
   or lut2ip_Y_sel
   or Y_uflow_7
   or reg2dp_lut_lo_slope_uflow_shift_sync
   or Y_oflow_7
   or reg2dp_lut_lo_slope_oflow_shift_sync
   ) begin
   if(lut2ip_X_sel[7]) begin 
       if(X_uflow_7) 
           Xinterp_in_shift_7 = {{1{reg2dp_lut_le_slope_uflow_shift_sync[4]}}, reg2dp_lut_le_slope_uflow_shift_sync[4:0]}; 
       else if(X_oflow_7) 
           Xinterp_in_shift_7 = {{1{reg2dp_lut_le_slope_oflow_shift_sync[4]}}, reg2dp_lut_le_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_7 = {1'b0,5'd16}; 
   end else if(lut2ip_Y_sel[7]) begin
       if(Y_uflow_7) 
           Xinterp_in_shift_7 = {{1{reg2dp_lut_lo_slope_uflow_shift_sync[4]}}, reg2dp_lut_lo_slope_uflow_shift_sync[4:0]}; 
       else if(Y_oflow_7) 
           Xinterp_in_shift_7 = {{1{reg2dp_lut_lo_slope_oflow_shift_sync[4]}}, reg2dp_lut_lo_slope_oflow_shift_sync[4:0]}; 
       else 
           Xinterp_in_shift_7 = {1'b0,5'd16}; 
   end else
           Xinterp_in_shift_7 = 6'd0; 
 end

assign Xinterp_in_vld[0] = intp_in_pvld /*& lut_X_sel[0]*/ & (&{Xinterp_in_rdy[7:1]                    }) /*& (&Yinterp_in_rdy[7:0])*/ & info_in_rdy;
assign Xinterp_in_vld[1] = intp_in_pvld /*& lut_X_sel[1]*/ & (&{Xinterp_in_rdy[7:2],Xinterp_in_rdy[0]  }) /*& (&Yinterp_in_rdy[7:0])*/ & info_in_rdy;
assign Xinterp_in_vld[2] = intp_in_pvld /*& lut_X_sel[2]*/ & (&{Xinterp_in_rdy[7:3],Xinterp_in_rdy[1:0]}) /*& (&Yinterp_in_rdy[7:0])*/ & info_in_rdy;
assign Xinterp_in_vld[3] = intp_in_pvld /*& lut_X_sel[3]*/ & (&{Xinterp_in_rdy[7:4],Xinterp_in_rdy[2:0]}) /*& (&Yinterp_in_rdy[7:0])*/ & info_in_rdy;
assign Xinterp_in_vld[4] = intp_in_pvld /*& lut_X_sel[4]*/ & (&{Xinterp_in_rdy[7:5],Xinterp_in_rdy[3:0]}) /*& (&Yinterp_in_rdy[7:0])*/ & info_in_rdy;
assign Xinterp_in_vld[5] = intp_in_pvld /*& lut_X_sel[5]*/ & (&{Xinterp_in_rdy[7:6],Xinterp_in_rdy[4:0]}) /*& (&Yinterp_in_rdy[7:0])*/ & info_in_rdy;
assign Xinterp_in_vld[6] = intp_in_pvld /*& lut_X_sel[6]*/ & (&{Xinterp_in_rdy[7  ],Xinterp_in_rdy[5:0]}) /*& (&Yinterp_in_rdy[7:0])*/ & info_in_rdy;
assign Xinterp_in_vld[7] = intp_in_pvld /*& lut_X_sel[7]*/ & (&{                    Xinterp_in_rdy[6:0]}) /*& (&Yinterp_in_rdy[7:0])*/ & info_in_rdy;


 NV_NVDLA_CDP_DP_INTP_unit u_interp_X0 (
    .nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)                //|< i
   ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
   ,.fp16_en                 (fp16_en)                               //|< i
   ,.interp_in0_pd           (Xinterp_in0_pd_0[38:0])                //|< r
   ,.interp_in1_pd           (Xinterp_in1_pd_0[37:0])                //|< r
   ,.interp_in_pd            (Xinterp_in_pd_0[16:0])                 //|< r
   ,.interp_in_scale         (Xinterp_in_scale_0[16:0])              //|< r
   ,.interp_in_shift         (Xinterp_in_shift_0[5:0])               //|< r
   ,.interp_in_vld           (Xinterp_in_vld[0])                     //|< w
   ,.interp_out_rdy          (Xinterp_out_rdy[0])                    //|< w
   ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)               //|< i
   ,.interp_in_rdy           (Xinterp_in_rdy[0])                     //|> w
   ,.interp_out_pd           (Xinterp_out_pd_0[16:0])                //|> w
   ,.interp_out_vld          (Xinterp_out_vld[0])                    //|> w
   );
 NV_NVDLA_CDP_DP_INTP_unit u_interp_X1 (
    .nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)                //|< i
   ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
   ,.fp16_en                 (fp16_en)                               //|< i
   ,.interp_in0_pd           (Xinterp_in0_pd_1[38:0])                //|< r
   ,.interp_in1_pd           (Xinterp_in1_pd_1[37:0])                //|< r
   ,.interp_in_pd            (Xinterp_in_pd_1[16:0])                 //|< r
   ,.interp_in_scale         (Xinterp_in_scale_1[16:0])              //|< r
   ,.interp_in_shift         (Xinterp_in_shift_1[5:0])               //|< r
   ,.interp_in_vld           (Xinterp_in_vld[1])                     //|< w
   ,.interp_out_rdy          (Xinterp_out_rdy[1])                    //|< w
   ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)               //|< i
   ,.interp_in_rdy           (Xinterp_in_rdy[1])                     //|> w
   ,.interp_out_pd           (Xinterp_out_pd_1[16:0])                //|> w
   ,.interp_out_vld          (Xinterp_out_vld[1])                    //|> w
   );
 NV_NVDLA_CDP_DP_INTP_unit u_interp_X2 (
    .nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)                //|< i
   ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
   ,.fp16_en                 (fp16_en)                               //|< i
   ,.interp_in0_pd           (Xinterp_in0_pd_2[38:0])                //|< r
   ,.interp_in1_pd           (Xinterp_in1_pd_2[37:0])                //|< r
   ,.interp_in_pd            (Xinterp_in_pd_2[16:0])                 //|< r
   ,.interp_in_scale         (Xinterp_in_scale_2[16:0])              //|< r
   ,.interp_in_shift         (Xinterp_in_shift_2[5:0])               //|< r
   ,.interp_in_vld           (Xinterp_in_vld[2])                     //|< w
   ,.interp_out_rdy          (Xinterp_out_rdy[2])                    //|< w
   ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)               //|< i
   ,.interp_in_rdy           (Xinterp_in_rdy[2])                     //|> w
   ,.interp_out_pd           (Xinterp_out_pd_2[16:0])                //|> w
   ,.interp_out_vld          (Xinterp_out_vld[2])                    //|> w
   );
 NV_NVDLA_CDP_DP_INTP_unit u_interp_X3 (
    .nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)                //|< i
   ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
   ,.fp16_en                 (fp16_en)                               //|< i
   ,.interp_in0_pd           (Xinterp_in0_pd_3[38:0])                //|< r
   ,.interp_in1_pd           (Xinterp_in1_pd_3[37:0])                //|< r
   ,.interp_in_pd            (Xinterp_in_pd_3[16:0])                 //|< r
   ,.interp_in_scale         (Xinterp_in_scale_3[16:0])              //|< r
   ,.interp_in_shift         (Xinterp_in_shift_3[5:0])               //|< r
   ,.interp_in_vld           (Xinterp_in_vld[3])                     //|< w
   ,.interp_out_rdy          (Xinterp_out_rdy[3])                    //|< w
   ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)               //|< i
   ,.interp_in_rdy           (Xinterp_in_rdy[3])                     //|> w
   ,.interp_out_pd           (Xinterp_out_pd_3[16:0])                //|> w
   ,.interp_out_vld          (Xinterp_out_vld[3])                    //|> w
   );
 NV_NVDLA_CDP_DP_INTP_unit u_interp_X4 (
    .nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)                //|< i
   ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
   ,.fp16_en                 (fp16_en)                               //|< i
   ,.interp_in0_pd           (Xinterp_in0_pd_4[38:0])                //|< r
   ,.interp_in1_pd           (Xinterp_in1_pd_4[37:0])                //|< r
   ,.interp_in_pd            (Xinterp_in_pd_4[16:0])                 //|< r
   ,.interp_in_scale         (Xinterp_in_scale_4[16:0])              //|< r
   ,.interp_in_shift         (Xinterp_in_shift_4[5:0])               //|< r
   ,.interp_in_vld           (Xinterp_in_vld[4])                     //|< w
   ,.interp_out_rdy          (Xinterp_out_rdy[4])                    //|< w
   ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)               //|< i
   ,.interp_in_rdy           (Xinterp_in_rdy[4])                     //|> w
   ,.interp_out_pd           (Xinterp_out_pd_4[16:0])                //|> w
   ,.interp_out_vld          (Xinterp_out_vld[4])                    //|> w
   );
 NV_NVDLA_CDP_DP_INTP_unit u_interp_X5 (
    .nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)                //|< i
   ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
   ,.fp16_en                 (fp16_en)                               //|< i
   ,.interp_in0_pd           (Xinterp_in0_pd_5[38:0])                //|< r
   ,.interp_in1_pd           (Xinterp_in1_pd_5[37:0])                //|< r
   ,.interp_in_pd            (Xinterp_in_pd_5[16:0])                 //|< r
   ,.interp_in_scale         (Xinterp_in_scale_5[16:0])              //|< r
   ,.interp_in_shift         (Xinterp_in_shift_5[5:0])               //|< r
   ,.interp_in_vld           (Xinterp_in_vld[5])                     //|< w
   ,.interp_out_rdy          (Xinterp_out_rdy[5])                    //|< w
   ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)               //|< i
   ,.interp_in_rdy           (Xinterp_in_rdy[5])                     //|> w
   ,.interp_out_pd           (Xinterp_out_pd_5[16:0])                //|> w
   ,.interp_out_vld          (Xinterp_out_vld[5])                    //|> w
   );
 NV_NVDLA_CDP_DP_INTP_unit u_interp_X6 (
    .nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)                //|< i
   ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
   ,.fp16_en                 (fp16_en)                               //|< i
   ,.interp_in0_pd           (Xinterp_in0_pd_6[38:0])                //|< r
   ,.interp_in1_pd           (Xinterp_in1_pd_6[37:0])                //|< r
   ,.interp_in_pd            (Xinterp_in_pd_6[16:0])                 //|< r
   ,.interp_in_scale         (Xinterp_in_scale_6[16:0])              //|< r
   ,.interp_in_shift         (Xinterp_in_shift_6[5:0])               //|< r
   ,.interp_in_vld           (Xinterp_in_vld[6])                     //|< w
   ,.interp_out_rdy          (Xinterp_out_rdy[6])                    //|< w
   ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)               //|< i
   ,.interp_in_rdy           (Xinterp_in_rdy[6])                     //|> w
   ,.interp_out_pd           (Xinterp_out_pd_6[16:0])                //|> w
   ,.interp_out_vld          (Xinterp_out_vld[6])                    //|> w
   );
 NV_NVDLA_CDP_DP_INTP_unit u_interp_X7 (
    .nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)                //|< i
   ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
   ,.fp16_en                 (fp16_en)                               //|< i
   ,.interp_in0_pd           (Xinterp_in0_pd_7[38:0])                //|< r
   ,.interp_in1_pd           (Xinterp_in1_pd_7[37:0])                //|< r
   ,.interp_in_pd            (Xinterp_in_pd_7[16:0])                 //|< r
   ,.interp_in_scale         (Xinterp_in_scale_7[16:0])              //|< r
   ,.interp_in_shift         (Xinterp_in_shift_7[5:0])               //|< r
   ,.interp_in_vld           (Xinterp_in_vld[7])                     //|< w
   ,.interp_out_rdy          (Xinterp_out_rdy[7])                    //|< w
   ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)               //|< i
   ,.interp_in_rdy           (Xinterp_in_rdy[7])                     //|> w
   ,.interp_out_pd           (Xinterp_out_pd_7[16:0])                //|> w
   ,.interp_out_vld          (Xinterp_out_vld[7])                    //|> w
   );

assign Xinterp_out_rdy[0] = intp_prdy & (int8_en ? (&{Xinterp_out_vld[7:1]})                      : (&{Xinterp_out_vld[3:1]})                     ) & info_o_vld;
assign Xinterp_out_rdy[1] = intp_prdy & (int8_en ? (&{Xinterp_out_vld[7:2],Xinterp_out_vld[0]})   : (&{Xinterp_out_vld[3:2],Xinterp_out_vld[0]})  ) & info_o_vld;
assign Xinterp_out_rdy[2] = intp_prdy & (int8_en ? (&{Xinterp_out_vld[7:3],Xinterp_out_vld[1:0]}) : (&{Xinterp_out_vld[3  ],Xinterp_out_vld[1:0]})) & info_o_vld;
assign Xinterp_out_rdy[3] = intp_prdy & (int8_en ? (&{Xinterp_out_vld[7:4],Xinterp_out_vld[2:0]}) : (&{Xinterp_out_vld[2:0]})                     ) & info_o_vld;
assign Xinterp_out_rdy[4] = intp_prdy & (int8_en ? (&{Xinterp_out_vld[7:5],Xinterp_out_vld[3:0]}) : 1'b1                                          ) & info_o_vld;
assign Xinterp_out_rdy[5] = intp_prdy & (int8_en ? (&{Xinterp_out_vld[7:6],Xinterp_out_vld[4:0]}) : 1'b1                                          ) & info_o_vld;
assign Xinterp_out_rdy[6] = intp_prdy & (int8_en ? (&{Xinterp_out_vld[7  ],Xinterp_out_vld[5:0]}) : 1'b1                                          ) & info_o_vld;
assign Xinterp_out_rdy[7] = intp_prdy & (int8_en ? (&{Xinterp_out_vld[6:0]})                      : 1'b1                                          ) & info_o_vld;

assign info_o_rdy = intp_prdy & (int8_en ? (&Xinterp_out_vld) : (&Xinterp_out_vld[3:0]));

//
//assign info_o_rdy = intp_prdy & (&Xinterp_out_vld) & (&Yinterp_out_vld);
///////////////////////////////////////////////
//process for NaN
 assign NaN_flag_0 = fp16_en & (&sync2itp_fp32_0[30:23]) & (|sync2itp_fp32_0[22:0]);      
 assign NaN_sign_0_in = sync2itp_fp32_0[31];      
 assign NaN_mts_0_in = sync2itp_fp32_0[9:0];      
 assign NaN_info_0 = {NaN_flag_0,NaN_sign_0_in,NaN_mts_0_in};      
 assign NaN_flag_1 = fp16_en & (&sync2itp_fp32_1[30:23]) & (|sync2itp_fp32_1[22:0]);      
 assign NaN_sign_1_in = sync2itp_fp32_1[31];      
 assign NaN_mts_1_in = sync2itp_fp32_1[9:0];      
 assign NaN_info_1 = {NaN_flag_1,NaN_sign_1_in,NaN_mts_1_in};      
 assign NaN_flag_2 = fp16_en & (&sync2itp_fp32_2[30:23]) & (|sync2itp_fp32_2[22:0]);      
 assign NaN_sign_2_in = sync2itp_fp32_2[31];      
 assign NaN_mts_2_in = sync2itp_fp32_2[9:0];      
 assign NaN_info_2 = {NaN_flag_2,NaN_sign_2_in,NaN_mts_2_in};      
 assign NaN_flag_3 = fp16_en & (&sync2itp_fp32_3[30:23]) & (|sync2itp_fp32_3[22:0]);      
 assign NaN_sign_3_in = sync2itp_fp32_3[31];      
 assign NaN_mts_3_in = sync2itp_fp32_3[9:0];      
 assign NaN_info_3 = {NaN_flag_3,NaN_sign_3_in,NaN_mts_3_in};      
assign NaN_info_in[47:0] = {NaN_info_3,NaN_info_2,NaN_info_1,NaN_info_0};

//process for normal uflow/oflow info
assign info_in_vld = intp_in_pvld & (&Xinterp_in_rdy[7:0]);
assign info_Xin_pd  = {lut2ip_X_info_7[17:16],lut2ip_X_info_6[17:16],lut2ip_X_info_5[17:16],lut2ip_X_info_4[17:16],lut2ip_X_info_3[17:16],lut2ip_X_info_2[17:16],lut2ip_X_info_1[17:16],lut2ip_X_info_0[17:16]};
//assign info_Yin_pd  = {lut2ip_Y_info_7[18:17],lut2ip_Y_info_6[18:17],lut2ip_Y_info_5[18:17],lut2ip_Y_info_4[18:17],lut2ip_Y_info_3[18:17],lut2ip_Y_info_2[18:17],lut2ip_Y_info_1[18:17],lut2ip_Y_info_0[18:17]};
assign info_Yin_pd  = {lut2ip_X_info_7[19:18],lut2ip_X_info_6[19:18],lut2ip_X_info_5[19:18],lut2ip_X_info_4[19:18],lut2ip_X_info_3[19:18],lut2ip_X_info_2[19:18],lut2ip_X_info_1[19:18],lut2ip_X_info_0[19:18]};
assign dat_info_in[31:0] = {info_Yin_pd,info_Xin_pd};
//assign lut_sel[15:0] = {lut_Y_sel,lut_X_sel};

//assign info_in_pd = {lut_sel,NaN_info_in,dat_info_in};
assign info_in_pd = {NaN_info_in,dat_info_in};
NV_NVDLA_CDP_DP_intpinfo_fifo u_intpinfo_sync_fifo (
   .nvdla_core_clk          (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                       //|< i
  ,.intpinfo_wr_prdy        (info_in_rdy)                           //|> w
  ,.intpinfo_wr_pvld        (info_in_vld)                           //|< w
  ,.intpinfo_wr_pd          (info_in_pd[79:0])                      //|< w
  ,.intpinfo_rd_prdy        (info_o_rdy)                            //|< w
  ,.intpinfo_rd_pvld        (info_o_vld)                            //|> w
  ,.intpinfo_rd_pd          (info_o_pd[79:0])                       //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])                   //|< i
  );

assign X_info_0 = info_o_pd[1:0];
assign X_info_1 = info_o_pd[3:2];
assign X_info_2 = info_o_pd[5:4];
assign X_info_3 = info_o_pd[7:6];
assign X_info_4 = info_o_pd[9:8];
assign X_info_5 = info_o_pd[11:10];
assign X_info_6 = info_o_pd[13:12];
assign X_info_7 = info_o_pd[15:14];
assign Y_info_0 = info_o_pd[17:16];
assign Y_info_1 = info_o_pd[19:18];
assign Y_info_2 = info_o_pd[21:20];
assign Y_info_3 = info_o_pd[23:22];
assign Y_info_4 = info_o_pd[25:24];
assign Y_info_5 = info_o_pd[27:26];
assign Y_info_6 = info_o_pd[29:28];
assign Y_info_7 = info_o_pd[31:30];
assign NaN_mts_0    = info_o_pd[41:32];
assign NaN_sign_0   = info_o_pd[42];
assign NaN_in_flg_0 = info_o_pd[43];
assign NaN_mts_1    = info_o_pd[53:44];
assign NaN_sign_1   = info_o_pd[54];
assign NaN_in_flg_1 = info_o_pd[55];
assign NaN_mts_2    = info_o_pd[65:56];
assign NaN_sign_2   = info_o_pd[66];
assign NaN_in_flg_2 = info_o_pd[67];
assign NaN_mts_3    = info_o_pd[77:68];
assign NaN_sign_3   = info_o_pd[78];
assign NaN_in_flg_3 = info_o_pd[79];
//assign lutX_sel = info_o_pd[87:80];
//assign lutY_sel = info_o_pd[95:88];

////////////////////////////////////////////////
//assign intp_pvld  = info_o_vld & (&Xinterp_out_vld) & (&Yinterp_out_vld);
assign intp_pvld  = info_o_vld & (int8_en ? (&Xinterp_out_vld) : (&Xinterp_out_vld[3:0]));
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
assign intp_prdy_d = ip2mul_prdy;
assign ip2mul_pvld = intp_pvld_d;
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     ip2mul_pd_0 <= {17{1'b0}};
   end else begin
     if(intp_pvld & intp_prdy) begin 
         if(NaN_in_flg_0) 
              ip2mul_pd_0 <= {NaN_sign_0,6'h3f,NaN_mts_0}; 
         else 
              ip2mul_pd_0 <= Xinterp_out_pd_0; 
     end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     ip2mul_pd_1 <= {17{1'b0}};
   end else begin
     if(intp_pvld & intp_prdy) begin 
         if(NaN_in_flg_1) 
              ip2mul_pd_1 <= {NaN_sign_1,6'h3f,NaN_mts_1}; 
         else 
              ip2mul_pd_1 <= Xinterp_out_pd_1; 
     end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     ip2mul_pd_2 <= {17{1'b0}};
   end else begin
     if(intp_pvld & intp_prdy) begin 
         if(NaN_in_flg_2) 
              ip2mul_pd_2 <= {NaN_sign_2,6'h3f,NaN_mts_2}; 
         else 
              ip2mul_pd_2 <= Xinterp_out_pd_2; 
     end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     ip2mul_pd_3 <= {17{1'b0}};
   end else begin
     if(intp_pvld & intp_prdy) begin 
         if(NaN_in_flg_3) 
              ip2mul_pd_3 <= {NaN_sign_3,6'h3f,NaN_mts_3}; 
         else 
              ip2mul_pd_3 <= Xinterp_out_pd_3; 
     end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     ip2mul_pd_4 <= {17{1'b0}};
   end else begin
     if(intp_pvld & intp_prdy) begin 
         ip2mul_pd_4 <= Xinterp_out_pd_4; 
     end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     ip2mul_pd_5 <= {17{1'b0}};
   end else begin
     if(intp_pvld & intp_prdy) begin 
         ip2mul_pd_5 <= Xinterp_out_pd_5; 
     end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     ip2mul_pd_6 <= {17{1'b0}};
   end else begin
     if(intp_pvld & intp_prdy) begin 
         ip2mul_pd_6 <= Xinterp_out_pd_6; 
     end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     ip2mul_pd_7 <= {17{1'b0}};
   end else begin
     if(intp_pvld & intp_prdy) begin 
         ip2mul_pd_7 <= Xinterp_out_pd_7; 
     end 
   end
 end


////////////////////////////////////////////////
//LUT perf counters
////////////////////////////////////////////////
assign layer_done = dp2reg_done;

 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     both_hybrid_flag[0] <= 1'b0;
     both_of_flag[0] <= 1'b0;
     both_uf_flag[0] <= 1'b0;
     only_le_hit[0] <= 1'b0;
     only_lo_hit[0] <= 1'b0;
   end else begin
 if(intp_pvld & intp_prdy) begin 
     both_hybrid_flag[0] <= ({X_info_0,Y_info_0} == 4'b0000) | ({X_info_0,Y_info_0} == 4'b0110) | ({X_info_0,Y_info_0} == 4'b1001); 
     both_of_flag[0]     <= ({X_info_0,Y_info_0} == 4'b1010); 
     both_uf_flag[0]     <= ({X_info_0,Y_info_0} == 4'b0101); 
     only_le_hit[0]      <= ({X_info_0,Y_info_0} == 4'b0001) | ({X_info_0,Y_info_0} == 4'b0010); 
     only_lo_hit[0]      <= ({X_info_0,Y_info_0} == 4'b0100) | ({X_info_0,Y_info_0} == 4'b1000); 
 end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     both_hybrid_flag[1] <= 1'b0;
     both_of_flag[1] <= 1'b0;
     both_uf_flag[1] <= 1'b0;
     only_le_hit[1] <= 1'b0;
     only_lo_hit[1] <= 1'b0;
   end else begin
 if(intp_pvld & intp_prdy) begin 
     both_hybrid_flag[1] <= ({X_info_1,Y_info_1} == 4'b0000) | ({X_info_1,Y_info_1} == 4'b0110) | ({X_info_1,Y_info_1} == 4'b1001); 
     both_of_flag[1]     <= ({X_info_1,Y_info_1} == 4'b1010); 
     both_uf_flag[1]     <= ({X_info_1,Y_info_1} == 4'b0101); 
     only_le_hit[1]      <= ({X_info_1,Y_info_1} == 4'b0001) | ({X_info_1,Y_info_1} == 4'b0010); 
     only_lo_hit[1]      <= ({X_info_1,Y_info_1} == 4'b0100) | ({X_info_1,Y_info_1} == 4'b1000); 
 end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     both_hybrid_flag[2] <= 1'b0;
     both_of_flag[2] <= 1'b0;
     both_uf_flag[2] <= 1'b0;
     only_le_hit[2] <= 1'b0;
     only_lo_hit[2] <= 1'b0;
   end else begin
 if(intp_pvld & intp_prdy) begin 
     both_hybrid_flag[2] <= ({X_info_2,Y_info_2} == 4'b0000) | ({X_info_2,Y_info_2} == 4'b0110) | ({X_info_2,Y_info_2} == 4'b1001); 
     both_of_flag[2]     <= ({X_info_2,Y_info_2} == 4'b1010); 
     both_uf_flag[2]     <= ({X_info_2,Y_info_2} == 4'b0101); 
     only_le_hit[2]      <= ({X_info_2,Y_info_2} == 4'b0001) | ({X_info_2,Y_info_2} == 4'b0010); 
     only_lo_hit[2]      <= ({X_info_2,Y_info_2} == 4'b0100) | ({X_info_2,Y_info_2} == 4'b1000); 
 end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     both_hybrid_flag[3] <= 1'b0;
     both_of_flag[3] <= 1'b0;
     both_uf_flag[3] <= 1'b0;
     only_le_hit[3] <= 1'b0;
     only_lo_hit[3] <= 1'b0;
   end else begin
 if(intp_pvld & intp_prdy) begin 
     both_hybrid_flag[3] <= ({X_info_3,Y_info_3} == 4'b0000) | ({X_info_3,Y_info_3} == 4'b0110) | ({X_info_3,Y_info_3} == 4'b1001); 
     both_of_flag[3]     <= ({X_info_3,Y_info_3} == 4'b1010); 
     both_uf_flag[3]     <= ({X_info_3,Y_info_3} == 4'b0101); 
     only_le_hit[3]      <= ({X_info_3,Y_info_3} == 4'b0001) | ({X_info_3,Y_info_3} == 4'b0010); 
     only_lo_hit[3]      <= ({X_info_3,Y_info_3} == 4'b0100) | ({X_info_3,Y_info_3} == 4'b1000); 
 end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     both_hybrid_flag[4] <= 1'b0;
     both_of_flag[4] <= 1'b0;
     both_uf_flag[4] <= 1'b0;
     only_le_hit[4] <= 1'b0;
     only_lo_hit[4] <= 1'b0;
   end else begin
 if(intp_pvld & intp_prdy) begin 
     both_hybrid_flag[4] <= ({X_info_4,Y_info_4} == 4'b0000) | ({X_info_4,Y_info_4} == 4'b0110) | ({X_info_4,Y_info_4} == 4'b1001); 
     both_of_flag[4]     <= ({X_info_4,Y_info_4} == 4'b1010); 
     both_uf_flag[4]     <= ({X_info_4,Y_info_4} == 4'b0101); 
     only_le_hit[4]      <= ({X_info_4,Y_info_4} == 4'b0001) | ({X_info_4,Y_info_4} == 4'b0010); 
     only_lo_hit[4]      <= ({X_info_4,Y_info_4} == 4'b0100) | ({X_info_4,Y_info_4} == 4'b1000); 
 end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     both_hybrid_flag[5] <= 1'b0;
     both_of_flag[5] <= 1'b0;
     both_uf_flag[5] <= 1'b0;
     only_le_hit[5] <= 1'b0;
     only_lo_hit[5] <= 1'b0;
   end else begin
 if(intp_pvld & intp_prdy) begin 
     both_hybrid_flag[5] <= ({X_info_5,Y_info_5} == 4'b0000) | ({X_info_5,Y_info_5} == 4'b0110) | ({X_info_5,Y_info_5} == 4'b1001); 
     both_of_flag[5]     <= ({X_info_5,Y_info_5} == 4'b1010); 
     both_uf_flag[5]     <= ({X_info_5,Y_info_5} == 4'b0101); 
     only_le_hit[5]      <= ({X_info_5,Y_info_5} == 4'b0001) | ({X_info_5,Y_info_5} == 4'b0010); 
     only_lo_hit[5]      <= ({X_info_5,Y_info_5} == 4'b0100) | ({X_info_5,Y_info_5} == 4'b1000); 
 end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     both_hybrid_flag[6] <= 1'b0;
     both_of_flag[6] <= 1'b0;
     both_uf_flag[6] <= 1'b0;
     only_le_hit[6] <= 1'b0;
     only_lo_hit[6] <= 1'b0;
   end else begin
 if(intp_pvld & intp_prdy) begin 
     both_hybrid_flag[6] <= ({X_info_6,Y_info_6} == 4'b0000) | ({X_info_6,Y_info_6} == 4'b0110) | ({X_info_6,Y_info_6} == 4'b1001); 
     both_of_flag[6]     <= ({X_info_6,Y_info_6} == 4'b1010); 
     both_uf_flag[6]     <= ({X_info_6,Y_info_6} == 4'b0101); 
     only_le_hit[6]      <= ({X_info_6,Y_info_6} == 4'b0001) | ({X_info_6,Y_info_6} == 4'b0010); 
     only_lo_hit[6]      <= ({X_info_6,Y_info_6} == 4'b0100) | ({X_info_6,Y_info_6} == 4'b1000); 
 end 
   end
 end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     both_hybrid_flag[7] <= 1'b0;
     both_of_flag[7] <= 1'b0;
     both_uf_flag[7] <= 1'b0;
     only_le_hit[7] <= 1'b0;
     only_lo_hit[7] <= 1'b0;
   end else begin
 if(intp_pvld & intp_prdy) begin 
     both_hybrid_flag[7] <= ({X_info_7,Y_info_7} == 4'b0000) | ({X_info_7,Y_info_7} == 4'b0110) | ({X_info_7,Y_info_7} == 4'b1001); 
     both_of_flag[7]     <= ({X_info_7,Y_info_7} == 4'b1010); 
     both_uf_flag[7]     <= ({X_info_7,Y_info_7} == 4'b0101); 
     only_le_hit[7]      <= ({X_info_7,Y_info_7} == 4'b0001) | ({X_info_7,Y_info_7} == 4'b0010); 
     only_lo_hit[7]      <= ({X_info_7,Y_info_7} == 4'b0100) | ({X_info_7,Y_info_7} == 4'b1000); 
 end 
   end
 end

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

assign both_hybrid_ele = fun_bit_sum_8(both_hybrid_flag);
assign both_of_ele     = fun_bit_sum_8(both_of_flag);
assign both_uf_ele     = fun_bit_sum_8(both_uf_flag);
assign only_le_hit_ele = fun_bit_sum_8(only_le_hit);
assign only_lo_hit_ele = fun_bit_sum_8(only_lo_hit);

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
assign ip2mul_pd = {ip2mul_pd_7[16:0],ip2mul_pd_6[16:0],ip2mul_pd_5[16:0],ip2mul_pd_4[16:0],ip2mul_pd_3[16:0],ip2mul_pd_2[16:0],ip2mul_pd_1[16:0],ip2mul_pd_0[16:0]};
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     ip2mul_pvld
  or p2_pipe_rand_ready
  or ip2mul_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = ip2mul_pvld;
  ip2mul_prdy = p2_pipe_rand_ready;
  p2_pipe_rand_data = ip2mul_pd;
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : ip2mul_pvld;
  ip2mul_prdy = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : ip2mul_pd;
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p2_pipe_stall_cycles;
integer p2_pipe_stall_probability;
integer p2_pipe_stall_cycles_min;
integer p2_pipe_stall_cycles_max;
initial begin
  p2_pipe_stall_cycles = 0;
  p2_pipe_stall_probability = 0;
  p2_pipe_stall_cycles_min = 1;
  p2_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_intp_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or ip2mul_pvld
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && ip2mul_pvld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p2_pipe_rand_poised) begin
    if (p2_pipe_stall_probability >= prand_inst2(1, 100)) begin
      p2_pipe_stall_cycles <= prand_inst3(p2_pipe_stall_cycles_min, p2_pipe_stall_cycles_max);
    end
  end else if (p2_pipe_rand_active) begin
    p2_pipe_stall_cycles <= p2_pipe_stall_cycles - 1;
  end else begin
    p2_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed2;
reg prand_initialized2;
reg prand_no_rollpli2;
`endif
`endif
`endif

function [31:0] prand_inst2;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst2 = min;
`else
`ifdef SYNTHESIS
        prand_inst2 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized2 !== 1'b1) begin
            prand_no_rollpli2 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli2)
                prand_local_seed2 = {$prand_get_seed(2), 16'b0};
            prand_initialized2 = 1'b1;
        end
        if (prand_no_rollpli2) begin
            prand_inst2 = min;
        end else begin
            diff = max - min + 1;
            prand_inst2 = min + prand_local_seed2[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed2 = prand_local_seed2 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst2 = min;
`else
        prand_inst2 = $RollPLI(min, max, "auto");
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
reg [47:0] prand_local_seed3;
reg prand_initialized3;
reg prand_no_rollpli3;
`endif
`endif
`endif

function [31:0] prand_inst3;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst3 = min;
`else
`ifdef SYNTHESIS
        prand_inst3 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized3 !== 1'b1) begin
            prand_no_rollpli3 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli3)
                prand_local_seed3 = {$prand_get_seed(3), 16'b0};
            prand_initialized3 = 1'b1;
        end
        if (prand_no_rollpli3) begin
            prand_inst3 = min;
        end else begin
            diff = max - min + 1;
            prand_inst3 = min + prand_local_seed3[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed3 = prand_local_seed3 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst3 = min;
`else
        prand_inst3 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (2) skid buffer
always @(
  p2_pipe_rand_valid
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_rand_valid && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_rand_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_rand_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_rand_valid
  or p2_skid_valid
  or p2_pipe_rand_data
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? p2_pipe_rand_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_skid_pipe_valid)? p2_skid_pipe_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_skid_pipe_ready = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or intp2mul_prdy
  or p2_pipe_data
  ) begin
  intp2mul_pvld = p2_pipe_valid;
  p2_pipe_ready = intp2mul_prdy;
  intp2mul_pd = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (intp2mul_pvld^intp2mul_prdy^ip2mul_pvld^ip2mul_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_15x (nvdla_core_clk, `ASSERT_RESET, (ip2mul_pvld && !ip2mul_prdy), (ip2mul_pvld), (ip2mul_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif
assign {intp2mul_pd_7[16:0],intp2mul_pd_6[16:0],intp2mul_pd_5[16:0],intp2mul_pd_4[16:0],intp2mul_pd_3[16:0],intp2mul_pd_2[16:0],intp2mul_pd_1[16:0],intp2mul_pd_0[16:0]} = intp2mul_pd;

////==============
////OBS signals
////==============
//assign obs_bus_cdp_intp_load_din = intp_in_pvld & intp_in_prdy;
//assign obs_bus_cdp_lut_le_uflow  = |{X_uflow_7,X_uflow_6,X_uflow_5,X_uflow_4,X_uflow_3,X_uflow_2,X_uflow_1,X_uflow_0}; 
//assign obs_bus_cdp_lut_le_oflow  = |{X_oflow_7,X_oflow_6,X_oflow_5,X_oflow_4,X_oflow_3,X_oflow_2,X_oflow_1,X_oflow_0};
//assign obs_bus_cdp_lut_lo_uflow  = |{Y_uflow_7,Y_uflow_6,Y_uflow_5,Y_uflow_4,Y_uflow_3,Y_uflow_2,Y_uflow_1,Y_uflow_0};
//assign obs_bus_cdp_lut_lo_oflow  = |{Y_oflow_7,Y_oflow_6,Y_oflow_5,Y_oflow_4,Y_oflow_3,Y_oflow_2,Y_oflow_1,Y_oflow_0};

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
input  [79:0] intpinfo_wr_pd;
input         intpinfo_rd_prdy;
output        intpinfo_rd_pvld;
output [79:0] intpinfo_rd_pd;
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
wire [79:0] intpinfo_rd_pd_p_byp_ram;		// read data directly out of ram

wire rd_enable;

wire ore;
wire do_bypass;
wire comb_bypass;
wire rd_popping;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsthp_19x80 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( intpinfo_wr_adr )
    , .we        ( wr_pushing && (intpinfo_wr_count != 5'd0 || !rd_popping) )
    , .di        ( intpinfo_wr_pd )
    , .ra        ( intpinfo_rd_adr_p )
    , .re        ( (do_bypass && wr_pushing) || rd_enable )
    , .dout        ( intpinfo_rd_pd_p_byp_ram )
    , .byp_sel        ( comb_bypass )
    , .dbyp        ( intpinfo_wr_pd[79:0] )
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
wire [79:0] intpinfo_rd_pd_p_byp = intpinfo_rd_pd_p_byp_ram;


//
// Combinatorial Bypass
//
// If we're pushing an empty fifo, mux the wr_data directly.
//
assign comb_bypass = intpinfo_wr_count == 0;
wire [79:0] intpinfo_rd_pd_p = intpinfo_rd_pd_p_byp;



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
                if ( prand_inst4(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst5(stall_cycles_min, stall_cycles_max);
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
reg [47:0] prand_local_seed4;
reg prand_initialized4;
reg prand_no_rollpli4;
`endif
`endif
`endif

function [31:0] prand_inst4;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst4 = min;
`else
`ifdef SYNTHESIS
        prand_inst4 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized4 !== 1'b1) begin
            prand_no_rollpli4 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli4)
                prand_local_seed4 = {$prand_get_seed(4), 16'b0};
            prand_initialized4 = 1'b1;
        end
        if (prand_no_rollpli4) begin
            prand_inst4 = min;
        end else begin
            diff = max - min + 1;
            prand_inst4 = min + prand_local_seed4[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed4 = prand_local_seed4 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst4 = min;
`else
        prand_inst4 = $RollPLI(min, max, "auto");
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
reg [47:0] prand_local_seed5;
reg prand_initialized5;
reg prand_no_rollpli5;
`endif
`endif
`endif

function [31:0] prand_inst5;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst5 = min;
`else
`ifdef SYNTHESIS
        prand_inst5 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized5 !== 1'b1) begin
            prand_no_rollpli5 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli5)
                prand_local_seed5 = {$prand_get_seed(5), 16'b0};
            prand_initialized5 = 1'b1;
        end
        if (prand_no_rollpli5) begin
            prand_inst5 = min;
        end else begin
            diff = max - min + 1;
            prand_inst5 = min + prand_local_seed5[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed5 = prand_local_seed5 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst5 = min;
`else
        prand_inst5 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_CDP_DP_intpinfo_fifo




