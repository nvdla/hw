// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_CORE_cal2d.v

module NV_NVDLA_PDP_CORE_cal2d (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,nvdla_op_gated_clk_fp16        //|< i
  ,padding_v_cfg                  //|< i
  ,pdp_dp2wdma_ready              //|< i
  ,pdp_op_start                   //|< i
  ,pooling1d_pd                   //|< i
  ,pooling1d_pvld                 //|< i
  ,pooling_channel_cfg            //|< i
  ,pooling_out_fwidth_cfg         //|< i
  ,pooling_out_lwidth_cfg         //|< i
  ,pooling_out_mwidth_cfg         //|< i
  ,pooling_size_v_cfg             //|< i
  ,pooling_splitw_num_cfg         //|< i
  ,pooling_stride_v_cfg           //|< i
  ,pooling_type_cfg               //|< i
  ,pwrbus_ram_pd                  //|< i
  ,reg2dp_cube_in_height          //|< i
  ,reg2dp_cube_out_width          //|< i
  ,reg2dp_fp16_en                 //|< i
  ,reg2dp_input_data              //|< i
  ,reg2dp_int16_en                //|< i
  ,reg2dp_int8_en                 //|< i
  ,reg2dp_kernel_height           //|< i
  ,reg2dp_kernel_width            //|< i
  ,reg2dp_pad_bottom_cfg          //|< i
  ,reg2dp_pad_top                 //|< i
  ,reg2dp_pad_value_1x_cfg        //|< i
  ,reg2dp_pad_value_2x_cfg        //|< i
  ,reg2dp_pad_value_3x_cfg        //|< i
  ,reg2dp_pad_value_4x_cfg        //|< i
  ,reg2dp_pad_value_5x_cfg        //|< i
  ,reg2dp_pad_value_6x_cfg        //|< i
  ,reg2dp_pad_value_7x_cfg        //|< i
  ,reg2dp_partial_width_out_first //|< i
  ,reg2dp_partial_width_out_last  //|< i
  ,reg2dp_partial_width_out_mid   //|< i
  ,reg2dp_recip_height_cfg        //|< i
  ,reg2dp_recip_width_cfg         //|< i
  ,pdp_dp2wdma_pd                 //|> o
  ,pdp_dp2wdma_valid              //|> o
  ,pooling1d_prdy                 //|> o
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input          nvdla_op_gated_clk_fp16;
input    [2:0] padding_v_cfg;
input          pdp_dp2wdma_ready;
input          pdp_op_start;
input  [111:0] pooling1d_pd;
input          pooling1d_pvld;
input   [12:0] pooling_channel_cfg;
input    [9:0] pooling_out_fwidth_cfg;
input    [9:0] pooling_out_lwidth_cfg;
input    [9:0] pooling_out_mwidth_cfg;
input    [2:0] pooling_size_v_cfg;
input    [7:0] pooling_splitw_num_cfg;
input    [3:0] pooling_stride_v_cfg;
input    [1:0] pooling_type_cfg;
input   [31:0] pwrbus_ram_pd;
input   [12:0] reg2dp_cube_in_height;
input   [12:0] reg2dp_cube_out_width;
input          reg2dp_fp16_en;
input    [1:0] reg2dp_input_data;
input          reg2dp_int16_en;
input          reg2dp_int8_en;
input    [2:0] reg2dp_kernel_height;
input    [2:0] reg2dp_kernel_width;
input    [2:0] reg2dp_pad_bottom_cfg;
input    [2:0] reg2dp_pad_top;
input   [18:0] reg2dp_pad_value_1x_cfg;
input   [18:0] reg2dp_pad_value_2x_cfg;
input   [18:0] reg2dp_pad_value_3x_cfg;
input   [18:0] reg2dp_pad_value_4x_cfg;
input   [18:0] reg2dp_pad_value_5x_cfg;
input   [18:0] reg2dp_pad_value_6x_cfg;
input   [18:0] reg2dp_pad_value_7x_cfg;
input    [9:0] reg2dp_partial_width_out_first;
input    [9:0] reg2dp_partial_width_out_last;
input    [9:0] reg2dp_partial_width_out_mid;
input   [16:0] reg2dp_recip_height_cfg;
input   [16:0] reg2dp_recip_width_cfg;
output  [63:0] pdp_dp2wdma_pd;
output         pdp_dp2wdma_valid;
output         pooling1d_prdy;
wire     [5:0] BANK_DEPTH;
wire           active_last_line;
wire           average_pooling_en;
wire           bubble_en_end;
wire     [2:0] bubble_num_dec;
wire     [3:0] buffer_lines_0;
wire     [3:0] buffer_lines_1;
wire     [3:0] buffer_lines_2;
wire     [3:0] buffer_lines_3;
wire     [3:0] cube_in_height_cfg;
wire    [13:0] cube_out_channel;
wire           cur_datin_disable_2d_sync;
wire    [21:0] data_16bit_0;
wire    [21:0] data_16bit_0_ff;
wire    [21:0] data_16bit_1;
wire    [21:0] data_16bit_1_ff;
wire    [21:0] data_16bit_2;
wire    [21:0] data_16bit_2_ff;
wire    [21:0] data_16bit_3;
wire    [21:0] data_16bit_3_ff;
wire    [13:0] data_8bit_0;
wire    [13:0] data_8bit_0_ff;
wire    [13:0] data_8bit_1;
wire    [13:0] data_8bit_1_ff;
wire    [13:0] data_8bit_2;
wire    [13:0] data_8bit_2_ff;
wire    [13:0] data_8bit_3;
wire    [13:0] data_8bit_3_ff;
wire    [13:0] data_8bit_4;
wire    [13:0] data_8bit_4_ff;
wire    [13:0] data_8bit_5;
wire    [13:0] data_8bit_5_ff;
wire    [13:0] data_8bit_6;
wire    [13:0] data_8bit_6_ff;
wire    [13:0] data_8bit_7;
wire    [13:0] data_8bit_7_ff;
wire           data_c_end;
wire    [18:0] data_hmult_16bit_0;
wire    [38:0] data_hmult_16bit_0_ext;
wire    [38:0] data_hmult_16bit_0_ext_ff;
wire    [18:0] data_hmult_16bit_1;
wire    [38:0] data_hmult_16bit_1_ext;
wire    [38:0] data_hmult_16bit_1_ext_ff;
wire    [18:0] data_hmult_16bit_2;
wire    [38:0] data_hmult_16bit_2_ext;
wire    [38:0] data_hmult_16bit_2_ext_ff;
wire    [18:0] data_hmult_16bit_3;
wire    [38:0] data_hmult_16bit_3_ext;
wire    [38:0] data_hmult_16bit_3_ext_ff;
wire    [21:0] data_hmult_8bit_0;
wire    [30:0] data_hmult_8bit_0_lsb_ext;
wire    [30:0] data_hmult_8bit_0_lsb_ext_ff;
wire    [30:0] data_hmult_8bit_0_msb_ext;
wire    [30:0] data_hmult_8bit_0_msb_ext_ff;
wire    [21:0] data_hmult_8bit_1;
wire    [30:0] data_hmult_8bit_1_lsb_ext;
wire    [30:0] data_hmult_8bit_1_lsb_ext_ff;
wire    [30:0] data_hmult_8bit_1_msb_ext;
wire    [30:0] data_hmult_8bit_1_msb_ext_ff;
wire    [21:0] data_hmult_8bit_2;
wire    [30:0] data_hmult_8bit_2_lsb_ext;
wire    [30:0] data_hmult_8bit_2_lsb_ext_ff;
wire    [30:0] data_hmult_8bit_2_msb_ext;
wire    [30:0] data_hmult_8bit_2_msb_ext_ff;
wire    [21:0] data_hmult_8bit_3;
wire    [30:0] data_hmult_8bit_3_lsb_ext;
wire    [30:0] data_hmult_8bit_3_lsb_ext_ff;
wire    [30:0] data_hmult_8bit_3_msb_ext;
wire    [30:0] data_hmult_8bit_3_msb_ext_ff;
wire    [21:0] data_hmult_stage0_in0;
wire    [21:0] data_hmult_stage0_in1;
wire    [21:0] data_hmult_stage0_in2;
wire    [21:0] data_hmult_stage0_in3;
wire    [15:0] data_mult_stage1_in0;
wire    [15:0] data_mult_stage1_in1;
wire    [15:0] data_mult_stage1_in2;
wire    [15:0] data_mult_stage1_in3;
wire    [15:0] data_vmult_16bit_0;
wire    [35:0] data_vmult_16bit_0_ext;
wire    [35:0] data_vmult_16bit_0_ext_ff;
wire    [15:0] data_vmult_16bit_1;
wire    [35:0] data_vmult_16bit_1_ext;
wire    [35:0] data_vmult_16bit_1_ext_ff;
wire    [15:0] data_vmult_16bit_2;
wire    [35:0] data_vmult_16bit_2_ext;
wire    [35:0] data_vmult_16bit_2_ext_ff;
wire    [15:0] data_vmult_16bit_3;
wire    [35:0] data_vmult_16bit_3_ext;
wire    [35:0] data_vmult_16bit_3_ext_ff;
wire    [15:0] data_vmult_8bit_0;
wire    [27:0] data_vmult_8bit_0_lsb_ext;
wire    [27:0] data_vmult_8bit_0_lsb_ext_ff;
wire    [27:0] data_vmult_8bit_0_msb_ext;
wire    [27:0] data_vmult_8bit_0_msb_ext_ff;
wire    [15:0] data_vmult_8bit_1;
wire    [27:0] data_vmult_8bit_1_lsb_ext;
wire    [27:0] data_vmult_8bit_1_lsb_ext_ff;
wire    [27:0] data_vmult_8bit_1_msb_ext;
wire    [27:0] data_vmult_8bit_1_msb_ext_ff;
wire    [15:0] data_vmult_8bit_2;
wire    [27:0] data_vmult_8bit_2_lsb_ext;
wire    [27:0] data_vmult_8bit_2_lsb_ext_ff;
wire    [27:0] data_vmult_8bit_2_msb_ext;
wire    [27:0] data_vmult_8bit_2_msb_ext_ff;
wire    [15:0] data_vmult_8bit_3;
wire    [27:0] data_vmult_8bit_3_lsb_ext;
wire    [27:0] data_vmult_8bit_3_lsb_ext_ff;
wire    [27:0] data_vmult_8bit_3_msb_ext;
wire    [27:0] data_vmult_8bit_3_msb_ext_ff;
wire   [254:0] din_pd;
wire   [254:0] din_pd_d0;
wire   [254:0] din_pd_d1;
wire   [254:0] din_pd_d2;
wire   [254:0] din_pd_d3;
wire   [254:0] din_pd_d4;
wire           din_rdy;
wire           din_rdy_d0;
wire           din_rdy_d1;
wire           din_rdy_d2;
wire           din_rdy_d3;
wire           din_rdy_d4;
wire           din_vld;
wire           din_vld_d0;
wire           din_vld_d1;
wire           din_vld_d2;
wire           din_vld_d3;
wire           din_vld_d4;
wire   [254:0] dout_pd;
wire           dout_rdy;
wire           dout_vld;
wire     [3:0] first_out_num;
wire     [2:0] first_out_num_dec2;
wire           first_splitw;
wire     [2:0] flush_in_next_surf;
wire     [2:0] flush_num_dec1;
wire           flush_read_en;
wire     [7:0] fp16_4add_in_prdy;
wire     [7:0] fp16_4add_in_pvld;
wire     [7:0] fp16_4add_out_prdy;
wire     [7:0] fp16_4add_out_pvld;
wire    [67:0] fp16_add_in_a;
wire    [67:0] fp16_add_in_a_sync;
wire    [67:0] fp16_add_in_b0;
wire    [67:0] fp16_add_in_b1;
wire    [67:0] fp16_add_in_b2;
wire    [67:0] fp16_add_in_b3;
wire    [67:0] fp16_add_in_b4;
wire    [67:0] fp16_add_in_b5;
wire    [67:0] fp16_add_in_b6;
wire    [67:0] fp16_add_in_b7;
wire           fp16_add_in_rdy;
wire     [3:0] fp16_add_pad_in_a_rdy;
wire     [3:0] fp16_add_pad_in_a_vld;
wire     [3:0] fp16_add_pad_in_b_rdy;
wire     [3:0] fp16_add_pad_in_b_vld;
wire    [16:0] fp16_add_pad_out0;
wire    [16:0] fp16_add_pad_out1;
wire    [16:0] fp16_add_pad_out2;
wire    [16:0] fp16_add_pad_out3;
wire           fp16_add_pad_out_pvld;
wire     [3:0] fp16_add_pad_out_rdy;
wire     [3:0] fp16_add_pad_out_vld;
wire           fp16_en;
wire           fp16_mean_pool_cfg;
wire           fp16_mean_pool_valid;
wire   [114:0] fp16_mul_pad_line_in_pd;
wire   [114:0] fp16_mul_pad_line_in_pd_d0;
wire   [114:0] fp16_mul_pad_line_in_pd_d1;
wire   [114:0] fp16_mul_pad_line_in_pd_d2;
wire   [114:0] fp16_mul_pad_line_in_pd_d3;
wire           fp16_mul_pad_line_in_rdy;
wire           fp16_mul_pad_line_in_rdy_d0;
wire           fp16_mul_pad_line_in_rdy_d1;
wire           fp16_mul_pad_line_in_rdy_d2;
wire           fp16_mul_pad_line_in_rdy_d3;
wire     [0:0] fp16_mul_pad_line_in_vld;
wire           fp16_mul_pad_line_in_vld_d0;
wire           fp16_mul_pad_line_in_vld_d1;
wire           fp16_mul_pad_line_in_vld_d2;
wire           fp16_mul_pad_line_in_vld_d3;
wire   [114:0] fp16_mul_pad_line_out_pd;
wire           fp16_mul_pad_line_out_rdy;
wire           fp16_mul_pad_line_out_vld;
wire           fp16_mul_pad_line_prdy;
wire           fp16_mul_pad_line_pvld;
wire     [1:0] fp16_mul_pad_line_rdy;
wire     [1:0] fp16_mul_pad_line_vld;
wire     [3:0] fp16_mulv_in_a_rdy;
wire     [3:0] fp16_mulv_in_a_vld;
wire     [3:0] fp16_mulv_in_b_rdy;
wire     [3:0] fp16_mulv_in_b_vld;
wire           fp16_mulv_in_vld;
wire    [16:0] fp16_mulv_out0;
wire    [16:0] fp16_mulv_out1;
wire    [16:0] fp16_mulv_out2;
wire    [16:0] fp16_mulv_out3;
wire     [3:0] fp16_mulv_out_rdy;
wire     [3:0] fp16_mulv_out_vld;
wire           fp16_mulv_rdy;
wire     [3:0] fp16_mulw_in_a_rdy;
wire     [3:0] fp16_mulw_in_a_vld;
wire     [3:0] fp16_mulw_in_b_rdy;
wire     [3:0] fp16_mulw_in_b_vld;
wire           fp16_mulw_in_vld;
wire    [16:0] fp16_mulw_out0;
wire    [16:0] fp16_mulw_out1;
wire    [16:0] fp16_mulw_out2;
wire    [16:0] fp16_mulw_out3;
wire           fp16_mulw_out_pvld;
wire     [3:0] fp16_mulw_out_rdy;
wire     [3:0] fp16_mulw_out_vld;
wire           fp16_mulw_rdy;
wire   [114:0] fp16_pout_mem_data;
wire    [15:0] fp17T16_out0;
wire    [15:0] fp17T16_out1;
wire    [15:0] fp17T16_out2;
wire    [15:0] fp17T16_out3;
wire     [3:0] fp17T16_out_rdy;
wire     [3:0] fp17T16_out_vld;
wire   [111:0] fp_add_out_dp_ext_0;
wire   [111:0] fp_add_out_dp_ext_1;
wire   [111:0] fp_add_out_dp_ext_2;
wire   [111:0] fp_add_out_dp_ext_3;
wire   [111:0] fp_add_out_dp_ext_4;
wire   [111:0] fp_add_out_dp_ext_5;
wire   [111:0] fp_add_out_dp_ext_6;
wire   [111:0] fp_add_out_dp_ext_7;
wire           fp_add_out_load;
wire           fp_add_out_vld;
wire    [63:0] fp_dp2wdma_dp;
wire           fp_dp2wdma_prdy;
wire           fp_dp2wdma_pvld;
wire     [5:0] fp_mem0_waddr;
wire   [115:0] fp_mem0_wdata;
wire     [5:0] fp_mem1_waddr;
wire   [115:0] fp_mem1_wdata;
wire     [5:0] fp_mem2_waddr;
wire   [115:0] fp_mem2_wdata;
wire     [5:0] fp_mem3_waddr;
wire   [115:0] fp_mem3_wdata;
wire     [5:0] fp_mem4_waddr;
wire   [115:0] fp_mem4_wdata;
wire     [5:0] fp_mem5_waddr;
wire   [115:0] fp_mem5_wdata;
wire     [5:0] fp_mem6_waddr;
wire   [115:0] fp_mem6_wdata;
wire     [5:0] fp_mem7_waddr;
wire   [115:0] fp_mem7_wdata;
wire     [2:0] fp_mem_size_v;
wire     [7:0] fp_mem_we;
wire           fp_mulw_prdy;
wire   [115:0] fp_pooling_result0;
wire   [115:0] fp_pooling_result1;
wire   [115:0] fp_pooling_result2;
wire   [115:0] fp_pooling_result3;
wire   [115:0] fp_pooling_result4;
wire   [115:0] fp_pooling_result5;
wire   [115:0] fp_pooling_result6;
wire   [115:0] fp_pooling_result7;
wire    [67:0] fp_pooling_result_dp_0;
wire    [67:0] fp_pooling_result_dp_1;
wire    [67:0] fp_pooling_result_dp_2;
wire    [67:0] fp_pooling_result_dp_3;
wire    [67:0] fp_pooling_result_dp_4;
wire    [67:0] fp_pooling_result_dp_5;
wire    [67:0] fp_pooling_result_dp_6;
wire    [67:0] fp_pooling_result_dp_7;
wire   [114:0] fp_pout_mem_data;
wire   [114:0] fp_pout_mem_data_act;
wire   [114:0] fp_pout_mem_data_last;
wire     [7:0] fp_pout_mem_data_sel;
wire     [7:0] fp_pout_mem_data_sel_last;
wire     [3:0] h_pt;
wire     [4:0] h_pt_pb;
wire    [10:0] hmult_8bit_0_lsb;
wire    [10:0] hmult_8bit_0_msb;
wire    [10:0] hmult_8bit_1_lsb;
wire    [10:0] hmult_8bit_1_msb;
wire    [10:0] hmult_8bit_2_lsb;
wire    [10:0] hmult_8bit_2_msb;
wire    [10:0] hmult_8bit_3_lsb;
wire    [10:0] hmult_8bit_3_msb;
wire           i16_less_neg_0_5_0;
wire           i16_less_neg_0_5_1;
wire           i16_less_neg_0_5_2;
wire           i16_less_neg_0_5_3;
wire           i16_more_neg_0_5_0;
wire           i16_more_neg_0_5_1;
wire           i16_more_neg_0_5_2;
wire           i16_more_neg_0_5_3;
wire    [18:0] i16_neg_add1_0;
wire    [18:0] i16_neg_add1_1;
wire    [18:0] i16_neg_add1_2;
wire    [18:0] i16_neg_add1_3;
wire    [15:0] i16_neg_vadd1_0;
wire    [15:0] i16_neg_vadd1_1;
wire    [15:0] i16_neg_vadd1_2;
wire    [15:0] i16_neg_vadd1_3;
wire           i16_vless_neg_0_5_0;
wire           i16_vless_neg_0_5_1;
wire           i16_vless_neg_0_5_2;
wire           i16_vless_neg_0_5_3;
wire           i16_vmore_neg_0_5_0;
wire           i16_vmore_neg_0_5_1;
wire           i16_vmore_neg_0_5_2;
wire           i16_vmore_neg_0_5_3;
wire           i8_less_neg_0_5_0_l;
wire           i8_less_neg_0_5_0_m;
wire           i8_less_neg_0_5_1_l;
wire           i8_less_neg_0_5_1_m;
wire           i8_less_neg_0_5_2_l;
wire           i8_less_neg_0_5_2_m;
wire           i8_less_neg_0_5_3_l;
wire           i8_less_neg_0_5_3_m;
wire           i8_more_neg_0_5_0_l;
wire           i8_more_neg_0_5_0_m;
wire           i8_more_neg_0_5_1_l;
wire           i8_more_neg_0_5_1_m;
wire           i8_more_neg_0_5_2_l;
wire           i8_more_neg_0_5_2_m;
wire           i8_more_neg_0_5_3_l;
wire           i8_more_neg_0_5_3_m;
wire    [10:0] i8_neg_add1_0_l;
wire    [10:0] i8_neg_add1_0_m;
wire    [10:0] i8_neg_add1_1_l;
wire    [10:0] i8_neg_add1_1_m;
wire    [10:0] i8_neg_add1_2_l;
wire    [10:0] i8_neg_add1_2_m;
wire    [10:0] i8_neg_add1_3_l;
wire    [10:0] i8_neg_add1_3_m;
wire     [7:0] i8_neg_vadd1_0_l;
wire     [7:0] i8_neg_vadd1_0_m;
wire     [7:0] i8_neg_vadd1_1_l;
wire     [7:0] i8_neg_vadd1_1_m;
wire     [7:0] i8_neg_vadd1_2_l;
wire     [7:0] i8_neg_vadd1_2_m;
wire     [7:0] i8_neg_vadd1_3_l;
wire     [7:0] i8_neg_vadd1_3_m;
wire           i8_vless_neg_0_5_0_l;
wire           i8_vless_neg_0_5_0_m;
wire           i8_vless_neg_0_5_1_l;
wire           i8_vless_neg_0_5_1_m;
wire           i8_vless_neg_0_5_2_l;
wire           i8_vless_neg_0_5_2_m;
wire           i8_vless_neg_0_5_3_l;
wire           i8_vless_neg_0_5_3_m;
wire           i8_vmore_neg_0_5_0_l;
wire           i8_vmore_neg_0_5_0_m;
wire           i8_vmore_neg_0_5_1_l;
wire           i8_vmore_neg_0_5_1_m;
wire           i8_vmore_neg_0_5_2_l;
wire           i8_vmore_neg_0_5_2_m;
wire           i8_vmore_neg_0_5_3_l;
wire           i8_vmore_neg_0_5_3_m;
wire           init_cnt;
wire     [7:0] init_unit2d_set;
wire           int16_en;
wire           int8_en;
wire    [63:0] int_dp2wdma_pd;
wire           int_dp2wdma_valid;
wire   [114:0] int_pout_mem_data;
wire     [3:0] kernel_width_cfg;
wire           last_c;
wire           last_line_in;
wire           last_out_done;
wire           last_pooling_flag;
wire           last_splitw;
wire           last_sub_lbuf_done;
wire           line_end;
wire           load_din;
wire           load_din_all;
wire           load_wr_stage1;
wire           load_wr_stage1_all;
wire           load_wr_stage2;
wire           load_wr_stage2_all;
wire           load_wr_stage3;
wire           load_wr_stage3_all;
wire     [7:0] mem_data_valid;
wire     [5:0] mem_raddr;
wire     [5:0] mem_raddr_2d_sync;
wire   [115:0] mem_rdata_0;
wire   [115:0] mem_rdata_1;
wire   [115:0] mem_rdata_2;
wire   [115:0] mem_rdata_3;
wire   [115:0] mem_rdata_4;
wire   [115:0] mem_rdata_5;
wire   [115:0] mem_rdata_6;
wire   [115:0] mem_rdata_7;
wire     [7:0] mem_re;
wire     [7:0] mem_re1;
wire     [7:0] mem_re1_1st;
wire     [7:0] mem_re2;
wire     [7:0] mem_re2_1st;
wire     [7:0] mem_re2_last;
wire     [7:0] mem_re3;
wire     [7:0] mem_re3_1st;
wire     [7:0] mem_re3_last;
wire     [7:0] mem_re4;
wire     [7:0] mem_re4_1st;
wire     [7:0] mem_re4_last;
wire     [7:0] mem_re_1st;
wire     [7:0] mem_re_1st_2d_sync;
wire     [7:0] mem_re_2d_sync;
wire     [7:0] mem_re_last;
wire     [5:0] mem_waddr_0;
wire     [5:0] mem_waddr_1;
wire     [5:0] mem_waddr_2;
wire     [5:0] mem_waddr_3;
wire     [5:0] mem_waddr_4;
wire     [5:0] mem_waddr_5;
wire     [5:0] mem_waddr_6;
wire     [5:0] mem_waddr_7;
wire   [115:0] mem_wdata_0;
wire   [115:0] mem_wdata_1;
wire   [115:0] mem_wdata_2;
wire   [115:0] mem_wdata_3;
wire   [115:0] mem_wdata_4;
wire   [115:0] mem_wdata_5;
wire   [115:0] mem_wdata_6;
wire   [115:0] mem_wdata_7;
wire     [7:0] mem_we;
wire           middle_surface_trig;
wire     [0:0] mon_data_16bit_0;
wire     [0:0] mon_data_16bit_0_ff;
wire     [0:0] mon_data_16bit_1;
wire     [0:0] mon_data_16bit_1_ff;
wire     [0:0] mon_data_16bit_2;
wire     [0:0] mon_data_16bit_2_ff;
wire     [0:0] mon_data_16bit_3;
wire     [0:0] mon_data_16bit_3_ff;
wire     [1:0] mon_data_8bit_0;
wire     [1:0] mon_data_8bit_0_ff;
wire     [1:0] mon_data_8bit_1;
wire     [1:0] mon_data_8bit_1_ff;
wire     [1:0] mon_data_8bit_2;
wire     [1:0] mon_data_8bit_2_ff;
wire     [1:0] mon_data_8bit_3;
wire     [1:0] mon_data_8bit_3_ff;
wire     [1:0] mon_data_8bit_4;
wire     [1:0] mon_data_8bit_4_ff;
wire     [1:0] mon_data_8bit_5;
wire     [1:0] mon_data_8bit_5_ff;
wire     [1:0] mon_data_8bit_6;
wire     [1:0] mon_data_8bit_6_ff;
wire     [1:0] mon_data_8bit_7;
wire     [1:0] mon_data_8bit_7_ff;
wire     [0:0] mon_first_out_num;
wire           mon_flush_in_next_surf;
wire           mon_flush_num_dec1;
wire           mon_i16_neg_add1_0;
wire           mon_i16_neg_add1_1;
wire           mon_i16_neg_add1_2;
wire           mon_i16_neg_add1_3;
wire           mon_i16_neg_vadd1_0;
wire           mon_i16_neg_vadd1_1;
wire           mon_i16_neg_vadd1_2;
wire           mon_i16_neg_vadd1_3;
wire           mon_i8_neg_add1_0_l;
wire           mon_i8_neg_add1_0_m;
wire           mon_i8_neg_add1_1_l;
wire           mon_i8_neg_add1_1_m;
wire           mon_i8_neg_add1_2_l;
wire           mon_i8_neg_add1_2_m;
wire           mon_i8_neg_add1_3_l;
wire           mon_i8_neg_add1_3_m;
wire           mon_i8_neg_vadd1_0_l;
wire           mon_i8_neg_vadd1_0_m;
wire           mon_i8_neg_vadd1_1_l;
wire           mon_i8_neg_vadd1_1_m;
wire           mon_i8_neg_vadd1_2_l;
wire           mon_i8_neg_vadd1_2_m;
wire           mon_i8_neg_vadd1_3_l;
wire           mon_i8_neg_vadd1_3_m;
wire     [0:0] mon_pad_table_index;
wire           mon_pad_value;
wire     [1:0] mon_pooling_size_minus_sride;
wire           mon_rest_height;
wire     [5:0] mon_strip_ycnt_offset;
wire           mon_surface_num_0;
wire     [1:0] mon_unit2d_cnt_pooling_max;
wire           need_flush;
wire           one_width_bubble_end;
wire           one_width_disable_2d_sync;
wire           one_width_norm_rdy;
wire     [2:0] pad_l;
wire    [16:0] pad_line_sum;
wire           pad_line_sum_prdy;
wire           pad_line_sum_pvld;
wire     [2:0] pad_r;
wire     [2:0] pad_table_index;
wire    [21:0] pad_value;
wire           padding_here;
wire     [2:0] padding_stride1_num;
wire     [2:0] padding_stride2_num;
wire     [2:0] padding_stride3_num;
wire     [2:0] padding_stride4_num;
wire           pooling1d_norm_rdy;
wire   [111:0] pooling1d_pd_use;
wire           pooling1d_prdy_use;
wire           pooling1d_pvld_use;
wire           pooling1d_vld_rebuild;
wire    [31:0] pooling_2d_info;
wire     [3:0] pooling_2d_info_0;
wire     [3:0] pooling_2d_info_1;
wire     [3:0] pooling_2d_info_2;
wire     [3:0] pooling_2d_info_3;
wire     [3:0] pooling_2d_info_4;
wire     [3:0] pooling_2d_info_5;
wire     [3:0] pooling_2d_info_6;
wire     [3:0] pooling_2d_info_7;
wire    [31:0] pooling_2d_info_sync;
wire           pooling_2d_rdy;
wire   [111:0] pooling_2d_result_0;
wire   [111:0] pooling_2d_result_1;
wire   [111:0] pooling_2d_result_2;
wire   [111:0] pooling_2d_result_3;
wire   [111:0] pooling_2d_result_4;
wire   [111:0] pooling_2d_result_5;
wire   [111:0] pooling_2d_result_6;
wire   [111:0] pooling_2d_result_7;
wire   [111:0] pooling_datin;
wire   [111:0] pooling_datin_ext;
wire     [3:0] pooling_size;
wire     [2:0] pooling_size_minus_sride;
wire     [3:0] pooling_size_v;
wire           pooling_stride_big;
wire     [4:0] pooling_stride_v;
wire           pout_data_stage0_prdy;
wire           pout_data_stage1_prdy;
wire           pout_data_stage2_prdy;
wire           pout_data_stage3_prdy;
wire   [114:0] pout_mem_data;
wire    [21:0] pout_mem_data0;
wire    [21:0] pout_mem_data1;
wire    [21:0] pout_mem_data2;
wire    [21:0] pout_mem_data3;
wire   [114:0] pout_mem_data_last;
wire   [114:0] pout_mem_data_last_sync;
wire     [7:0] pout_mem_data_sel;
wire     [7:0] pout_mem_data_sel_0;
wire     [7:0] pout_mem_data_sel_1;
wire     [7:0] pout_mem_data_sel_1_last;
wire     [7:0] pout_mem_data_sel_2;
wire     [7:0] pout_mem_data_sel_2_last;
wire     [7:0] pout_mem_data_sel_3;
wire     [7:0] pout_mem_data_sel_3_last;
wire     [7:0] pout_mem_data_sel_last;
wire     [7:0] pout_mem_data_sel_last_sync;
wire     [7:0] pout_mem_data_sel_sync;
wire     [2:0] pout_mem_size_v_use;
wire    [12:0] pout_width_cur;
wire           rd_comb_lbuf_end;
wire           rd_lbuf_end;
wire           rd_line_out;
wire           rd_line_out_done;
wire           rd_pout_data_en;
wire           rd_pout_data_stage0;
wire           rd_pout_data_stage1;
wire           rd_pout_data_stage1_all;
wire           rd_pout_data_stage2;
wire           rd_pout_data_stage2_all;
wire           rd_sub_lbuf_end;
wire    [12:0] rest_height;
wire    [13:0] rest_height_use;
wire           small_active;
wire           splitw_enable;
wire     [4:0] stride;
wire     [4:0] stride_1x;
wire     [5:0] stride_2x;
wire     [6:0] stride_3x;
wire     [6:0] stride_4x;
wire     [7:0] stride_5x;
wire     [7:0] stride_6x;
wire     [7:0] stride_7x;
wire           stride_end;
wire           stride_trig_end;
wire     [2:0] strip_ycnt_offset;
wire           stripe_receive_done;
wire           sub_lbuf_dout_done;
wire     [9:0] surface_num;
wire     [9:0] surface_num_0;
wire     [9:0] surface_num_1;
wire     [7:0] unit2d_clr;
wire     [3:0] unit2d_cnt_pooling_a1;
wire     [3:0] unit2d_cnt_pooling_a2;
wire     [3:0] unit2d_cnt_pooling_a3;
wire     [3:0] unit2d_cnt_pooling_a4;
wire     [3:0] unit2d_cnt_pooling_a5;
wire     [3:0] unit2d_cnt_pooling_a6;
wire     [3:0] unit2d_cnt_pooling_a7;
wire           unit2d_cnt_pooling_end;
wire           unit2d_cnt_pooling_last_end;
wire     [2:0] unit2d_cnt_pooling_max;
wire     [7:0] unit2d_en_last;
wire     [7:0] unit2d_set;
wire     [7:0] unit2d_set_trig;
wire     [2:0] unit2d_vsize1_0;
wire     [2:0] unit2d_vsize1_1;
wire     [2:0] unit2d_vsize1_2;
wire     [2:0] unit2d_vsize1_3;
wire     [2:0] unit2d_vsize1_4;
wire     [2:0] unit2d_vsize1_5;
wire     [2:0] unit2d_vsize1_6;
wire     [2:0] unit2d_vsize1_7;
wire     [2:0] unit2d_vsize2_0;
wire     [2:0] unit2d_vsize2_1;
wire     [2:0] unit2d_vsize2_2;
wire     [2:0] unit2d_vsize2_3;
wire     [2:0] unit2d_vsize2_4;
wire     [2:0] unit2d_vsize2_5;
wire     [2:0] unit2d_vsize2_6;
wire     [2:0] unit2d_vsize2_7;
wire     [2:0] unit2d_vsize3_0;
wire     [2:0] unit2d_vsize3_1;
wire     [2:0] unit2d_vsize3_2;
wire     [2:0] unit2d_vsize3_3;
wire     [2:0] unit2d_vsize3_4;
wire     [2:0] unit2d_vsize3_5;
wire     [2:0] unit2d_vsize3_6;
wire     [2:0] unit2d_vsize3_7;
wire     [2:0] unit2d_vsize4_0;
wire     [2:0] unit2d_vsize4_1;
wire     [2:0] unit2d_vsize4_2;
wire     [2:0] unit2d_vsize4_3;
wire     [2:0] unit2d_vsize4_4;
wire     [2:0] unit2d_vsize4_5;
wire     [2:0] unit2d_vsize4_6;
wire     [2:0] unit2d_vsize4_7;
wire     [2:0] unit2d_vsize_0;
wire     [2:0] unit2d_vsize_1;
wire     [2:0] unit2d_vsize_2;
wire     [2:0] unit2d_vsize_3;
wire     [2:0] unit2d_vsize_4;
wire     [2:0] unit2d_vsize_5;
wire     [2:0] unit2d_vsize_6;
wire     [2:0] unit2d_vsize_7;
wire     [2:0] up_pnum0;
wire     [7:0] vmult_8bit_0_lsb;
wire     [7:0] vmult_8bit_0_msb;
wire     [7:0] vmult_8bit_1_lsb;
wire     [7:0] vmult_8bit_1_msb;
wire     [7:0] vmult_8bit_2_lsb;
wire     [7:0] vmult_8bit_2_msb;
wire     [7:0] vmult_8bit_3_lsb;
wire     [7:0] vmult_8bit_3_msb;
wire           wr_data_stage0_prdy;
wire           wr_data_stage1_prdy;
wire           wr_line_dat_done;
wire           wr_subcube_dat_done;
wire           wr_surface_dat_done;
wire           wr_total_cube_done;
reg      [3:0] bank_merge_num;
reg      [2:0] bubble_add;
reg      [2:0] bubble_cnt;
reg      [2:0] bubble_num;
reg      [2:0] bubble_num_use;
reg      [3:0] buffer_lines_num;
reg      [1:0] c_cnt;
reg      [1:0] channel_cnt;
reg            cube_end_flag;
reg            cur_datin_disable;
reg            cur_datin_disable_2d;
reg            cur_datin_disable_3d;
reg            cur_datin_disable_d;
reg    [111:0] datin_buf;
reg    [111:0] datin_buf_2d;
reg      [2:0] flush_num;
reg      [2:0] flush_num_cal;
reg            flush_read_en_d;
reg      [5:0] int_mem_waddr;
reg    [115:0] int_mem_wdata_0;
reg    [115:0] int_mem_wdata_1;
reg    [115:0] int_mem_wdata_2;
reg    [115:0] int_mem_wdata_3;
reg    [115:0] int_mem_wdata_4;
reg    [115:0] int_mem_wdata_5;
reg    [115:0] int_mem_wdata_6;
reg    [115:0] int_mem_wdata_7;
reg      [7:0] int_mem_we;
reg            is_one_width_in;
reg     [16:0] kernel_width_fp17;
reg            last_active_line_2d;
reg            last_active_line_d;
reg      [2:0] last_out_cnt;
reg            last_out_en;
reg     [12:0] line_cnt;
reg    [114:0] mem_data0;
reg    [114:0] mem_data0_lst;
reg    [114:0] mem_data1;
reg    [114:0] mem_data1_lst;
reg    [114:0] mem_data2;
reg    [114:0] mem_data2_lst;
reg    [114:0] mem_data3;
reg    [114:0] mem_data3_lst;
reg    [114:0] mem_data4;
reg    [114:0] mem_data4_lst;
reg    [114:0] mem_data5;
reg    [114:0] mem_data5_lst;
reg    [114:0] mem_data6;
reg    [114:0] mem_data6_lst;
reg    [114:0] mem_data7;
reg    [114:0] mem_data7_lst;
reg      [5:0] mem_raddr_2d;
reg      [5:0] mem_raddr_d;
reg            mem_re1_sel;
reg            mem_re2_sel;
reg            mem_re2_sel_last;
reg            mem_re3_sel;
reg            mem_re3_sel_last;
reg            mem_re4_sel;
reg            mem_re4_sel_last;
reg      [7:0] mem_re_1st_2d;
reg      [7:0] mem_re_1st_d;
reg      [7:0] mem_re_2d;
reg      [7:0] mem_re_d;
reg      [7:0] mem_re_last_2d;
reg      [7:0] mem_re_last_d;
reg            need_bubble;
reg      [2:0] next2_0;
reg      [2:0] next2_1;
reg      [2:0] next3_0;
reg      [2:0] next3_1;
reg      [2:0] next3_2;
reg      [2:0] next4_0;
reg      [2:0] next4_1;
reg      [2:0] next4_2;
reg      [2:0] next4_3;
reg      [2:0] next5_0;
reg      [2:0] next5_1;
reg      [2:0] next5_2;
reg      [2:0] next5_3;
reg      [2:0] next5_4;
reg      [2:0] next6_0;
reg      [2:0] next6_1;
reg      [2:0] next6_2;
reg      [2:0] next6_3;
reg      [2:0] next6_4;
reg      [2:0] next6_5;
reg      [2:0] next7_0;
reg      [2:0] next7_1;
reg      [2:0] next7_2;
reg      [2:0] next7_3;
reg      [2:0] next7_4;
reg      [2:0] next7_5;
reg      [2:0] next7_6;
reg      [2:0] one_width_bubble_cnt;
reg            one_width_disable;
reg            one_width_disable_2d;
reg            one_width_disable_3d;
reg            one_width_disable_d;
reg      [5:0] pad_r_remain;
reg     [18:0] pad_table_out;
reg      [2:0] padding_stride_num;
reg      [2:0] pnum_flush0;
reg      [2:0] pnum_flush1;
reg      [2:0] pnum_flush2;
reg      [2:0] pnum_flush3;
reg      [2:0] pnum_flush4;
reg      [2:0] pnum_flush5;
reg      [2:0] pnum_flush6;
reg     [27:0] pout_data_0_0;
reg     [27:0] pout_data_0_1;
reg     [27:0] pout_data_0_2;
reg     [27:0] pout_data_0_3;
reg     [21:0] pout_data_stage0_0;
reg     [21:0] pout_data_stage0_1;
reg     [21:0] pout_data_stage0_2;
reg     [21:0] pout_data_stage0_3;
reg     [15:0] pout_data_stage1_0;
reg     [15:0] pout_data_stage1_1;
reg     [15:0] pout_data_stage1_2;
reg     [15:0] pout_data_stage1_3;
reg            pout_data_stage1_vld;
reg            pout_data_stage2_vld;
reg            pout_data_stage3_vld;
reg     [27:0] pout_mem_data_0;
reg     [27:0] pout_mem_data_1;
reg     [27:0] pout_mem_data_2;
reg     [27:0] pout_mem_data_3;
reg    [114:0] pout_mem_data_act;
reg      [2:0] pout_mem_size_v;
reg     [12:0] pout_width_cur_latch;
reg      [2:0] rd_comb_lbuf_cnt;
reg      [5:0] rd_line_out_cnt;
reg            rd_pout_data_en_2d;
reg            rd_pout_data_en_3d;
reg            rd_pout_data_en_4d;
reg            rd_pout_data_en_d;
reg      [2:0] rd_sub_lbuf_cnt;
reg     [16:0] reg2dp_recip_height_use;
reg     [16:0] reg2dp_recip_width_use;
reg      [2:0] samllH_flush_num;
reg      [2:0] strip_ycnt_psize;
reg      [3:0] strip_ycnt_stride;
reg      [3:0] strip_ycnt_stride_f;
reg      [5:0] sub_lbuf_dout_cnt;
reg            subend_need_flush_flg;
reg     [10:0] surface_cnt_rd;
reg            surfend_need_bubble_flg;
reg      [2:0] unit2d_cnt_pooling;
reg      [2:0] unit2d_cnt_pooling_last;
reg      [2:0] unit2d_cnt_pooling_last_2d;
reg      [2:0] unit2d_cnt_pooling_last_d;
reg      [2:0] unit2d_cnt_stride;
reg      [7:0] unit2d_en;
reg      [7:0] unit2d_mem_1strd;
reg      [2:0] unit2d_vsize_cnt_0;
reg      [2:0] unit2d_vsize_cnt_0_d;
reg      [2:0] unit2d_vsize_cnt_1;
reg      [2:0] unit2d_vsize_cnt_1_d;
reg      [2:0] unit2d_vsize_cnt_2;
reg      [2:0] unit2d_vsize_cnt_2_d;
reg      [2:0] unit2d_vsize_cnt_3;
reg      [2:0] unit2d_vsize_cnt_3_d;
reg      [2:0] unit2d_vsize_cnt_4;
reg      [2:0] unit2d_vsize_cnt_4_d;
reg      [2:0] unit2d_vsize_cnt_5;
reg      [2:0] unit2d_vsize_cnt_5_d;
reg      [2:0] unit2d_vsize_cnt_6;
reg      [2:0] unit2d_vsize_cnt_6_d;
reg      [2:0] unit2d_vsize_cnt_7;
reg      [2:0] unit2d_vsize_cnt_7_d;
reg            up_pnum1;
reg      [1:0] up_pnum2;
reg      [1:0] up_pnum3;
reg      [2:0] up_pnum4;
reg      [2:0] up_pnum5;
reg            wr_data_stage0_vld;
reg            wr_data_stage1_vld;
reg            wr_data_stage2_vld;
reg     [12:0] wr_line_dat_cnt;
reg            wr_line_end_2d;
reg            wr_line_end_buf;
reg      [7:0] wr_splitc_cnt;
reg      [2:0] wr_sub_lbuf_cnt;
reg     [12:0] wr_surface_dat_cnt;
reg            wr_surface_dat_done_2d;
reg            wr_surface_dat_done_buf;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==============================================================
////pdp cube_out_width setting

//////////////////////////////
//pdp cube_out_width setting, limited by line buffer size
//////////////////////////////
//non-split mode
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
  nv_assert_never #(0,0,"PDP cube_out_width setting out of range")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, load_din &(pout_width_cur > 13'd127) & (bank_merge_num==4'd8)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cube_out_width setting out of range")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, load_din &(pout_width_cur > 13'd63)  & (bank_merge_num==4'd4)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cube_out_width setting out of range")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, load_din &(pout_width_cur > 13'd31)  & (bank_merge_num==4'd2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cube_out_width setting out of range")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, load_din &(pout_width_cur > 13'd15)  & (bank_merge_num==4'd1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============================================================
//bank depth is fixed to 64
//--------------------------------------------------------------
assign BANK_DEPTH = 6'd63;//64-1
//==============================================================
// buffer the input data from pooling 1D unit
// calculate the data postion in input-data-cube
//
//--------------------------------------------------------------
assign pooling1d_prdy = pooling1d_prdy_use;
assign pooling1d_pvld_use = pooling1d_pvld;
assign pooling1d_pd_use = pooling1d_pd[111:0];

assign pooling1d_prdy_use = one_width_norm_rdy & (~cur_datin_disable);
assign one_width_norm_rdy = pooling1d_norm_rdy & (~one_width_disable);
//////////////////////////////////////////////////////////////////////////////////////
assign load_din         = pooling1d_prdy_use & pooling1d_pvld_use; 
assign stripe_receive_done = load_din & data_c_end;

assign average_pooling_en = (pooling_type_cfg== 2'h0 );
assign int8_en = (reg2dp_input_data[1:0] == 2'h0 );
assign int16_en = (reg2dp_input_data[1:0] == 2'h1 );
//////////////////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    c_cnt[1:0] <= {2{1'b0}};
  end else begin
    if(load_din)
        c_cnt[1:0] <= c_cnt + 1'b1;
  end
end
assign data_c_end       = (c_cnt == 2'd3); 
//end of line
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_line_dat_cnt[12:0] <= {13{1'b0}};
  end else begin
    if(wr_line_dat_done)
        wr_line_dat_cnt[12:0] <= 0;
    else if(stripe_receive_done)
        wr_line_dat_cnt[12:0] <= wr_line_dat_cnt + 1;
  end
end
assign wr_line_dat_done  = (wr_line_dat_cnt==pout_width_cur) & stripe_receive_done;

//end of surface
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_surface_dat_cnt <= {13{1'b0}};
  end else begin
   if(wr_surface_dat_done)
       wr_surface_dat_cnt <= 13'd0;
   else if(wr_line_dat_done)
       wr_surface_dat_cnt <= wr_surface_dat_cnt + 13'd1;
  end
end
assign last_line_in = ( wr_surface_dat_cnt==reg2dp_cube_in_height[12:0]);
assign wr_surface_dat_done = wr_line_dat_done & last_line_in;

//end of splitw
assign cube_out_channel[13:0]= pooling_channel_cfg[12:0] + 1'b1;
//16bits: INT16 or FP16
//assign surface_num_0[9:0] = cube_out_channel[12:4] + (|cube_out_channel[3:0]);
assign {mon_surface_num_0,surface_num_0[9:0]} = cube_out_channel[13:4] + {9'd0,(|cube_out_channel[3:0])};
//8bits: INT8
//assign surface_num_1[9:0] = {2'b0,cube_out_channel[12:5]} + (|cube_out_channel[4:0]);
assign surface_num_1[9:0] = {1'b0,cube_out_channel[13:5]} + (|cube_out_channel[4:0]);
assign surface_num        = int8_en ? surface_num_1 : surface_num_0;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    surface_cnt_rd[10:0] <= {11{1'b0}};
  end else begin
  if(wr_subcube_dat_done)
       surface_cnt_rd[10:0] <=  11'd0;
  else if(wr_surface_dat_done)
       surface_cnt_rd[10:0] <= surface_cnt_rd + 1;
  end
end
assign wr_subcube_dat_done = ((surface_num-1)==surface_cnt_rd) & wr_surface_dat_done;

//total cube done
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_splitc_cnt[7:0] <= {8{1'b0}};
  end else begin
    if(wr_total_cube_done)
        wr_splitc_cnt[7:0] <= 8'd0;
    else if(wr_subcube_dat_done)
        wr_splitc_cnt[7:0] <= wr_splitc_cnt + 1;
  end
end
assign wr_total_cube_done = (wr_splitc_cnt==pooling_splitw_num_cfg[7:0]) & wr_subcube_dat_done;
//////////////////////////////////////////////////////////////////////////////////////

//split width selection 
assign splitw_enable = (pooling_splitw_num_cfg!=8'd0);
assign last_splitw   = (wr_splitc_cnt==pooling_splitw_num_cfg[7:0]) & splitw_enable;
assign first_splitw  = (wr_splitc_cnt==8'd0) & splitw_enable;

assign pout_width_cur[12:0]= (~splitw_enable) ? reg2dp_cube_out_width[12:0] : 
                            (last_splitw  ? {3'd0,pooling_out_lwidth_cfg[9:0]} : 
                             first_splitw ? {3'd0,pooling_out_fwidth_cfg[9:0]} : 
                                            {3'd0,pooling_out_mwidth_cfg[9:0]});
/////////////////////////////////////////////////////////////////////////////////////   
// assign data_posinfo = wr_line_dat_done;
//=============================================================
// physical memory bank 8
// 8 memory banks are used to load maximum 8 pooling output lines
//
//-------------------------------------------------------------

//maximum pooling output lines  need to be  buffer
//stride 1
assign buffer_lines_0[3:0] = pooling_size_v[3:0];  
//stride 2
assign buffer_lines_1[3:0] = {1'd0,pooling_size_v[3:1]} + pooling_size_v[0];
//stride 3
assign buffer_lines_2[3:0] = (3'd5>= pooling_size_v_cfg[2:0] ) ? 4'd2: 4'd3; 
//stride 4 5 6 7
assign buffer_lines_3 = 4'd2;

assign pooling_stride_big =  (pooling_stride_v_cfg>={1'b0,pooling_size_v_cfg[2:0]});

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_lines_num <= {4{1'b0}};
  end else begin
  if(pdp_op_start) begin
    if(pooling_stride_big)
        buffer_lines_num <= 4'd1;
    else begin
        case(pooling_stride_v_cfg)
            4'd0:    buffer_lines_num <= buffer_lines_0;  
            4'd1:    buffer_lines_num <= buffer_lines_1;
            4'd2:    buffer_lines_num <= buffer_lines_2;
            default: buffer_lines_num <= buffer_lines_3;
        endcase
    end
  end
  end
end

//memory bank merge num
always @(
  buffer_lines_num
  ) begin
   case(buffer_lines_num)
       4'd1:      bank_merge_num = 4'd8;
       4'd2:      bank_merge_num = 4'd4;
       4'd4,4'd3: bank_merge_num = 4'd2;
       default  : bank_merge_num = 4'd1;
   endcase
end
//==========================================================
//bank active enable signal 
//
//----------------------------------------------------------
//stride intial data

//stride ==1 
assign padding_stride1_num[2:0] = padding_v_cfg[2:0];
//stride ==2
assign padding_stride2_num[2:0] = {1'b0,padding_v_cfg[2:1]};
//stride ==3
assign padding_stride3_num[2:0]= (padding_v_cfg[2:0]>=3'd6) ? 3'd2 :
                                 (padding_v_cfg[2:0]>=3'd3) ? 3'd1 : 3'd0;
//stride==4 5 6 7
assign padding_stride4_num[2:0]= ({1'b0,padding_v_cfg[2:0]}>pooling_stride_v_cfg) ? 3'd1:3'd0;

assign pooling_stride_v[4:0] = pooling_stride_v_cfg[3:0] + 1;
//real num-1
always @(
  pooling_stride_v_cfg
  or padding_stride1_num
  or padding_stride2_num
  or padding_stride3_num
  or padding_stride4_num
  ) begin
 case(pooling_stride_v_cfg[3:0])
         4'd0: padding_stride_num = padding_stride1_num;
         4'd1: padding_stride_num = padding_stride2_num;
         4'd2: padding_stride_num = padding_stride3_num;
         default:padding_stride_num=padding_stride4_num;
 endcase
end

assign   {mon_strip_ycnt_offset[5:0],strip_ycnt_offset[2:0]} = {5'd0,padding_v_cfg} - padding_stride_num * pooling_stride_v;
/////////////////////////////////////////////////////////////////////////////////
assign middle_surface_trig = wr_surface_dat_done & (~wr_total_cube_done);
assign stride_end       = wr_line_dat_done & (strip_ycnt_stride== pooling_stride_v_cfg);      
assign init_cnt         = middle_surface_trig | pdp_op_start;

//pooling stride in vertical direction
always @(
  init_cnt
  or strip_ycnt_offset
  or stride_end
  or wr_line_dat_done
  or strip_ycnt_stride
  ) begin
     if(init_cnt)
         strip_ycnt_stride_f[3:0] = {1'b0,strip_ycnt_offset};
     else if(stride_end)
         strip_ycnt_stride_f[3:0] = 4'd0;
     else if(wr_line_dat_done)
         strip_ycnt_stride_f[3:0] = strip_ycnt_stride + 1;
     else
         strip_ycnt_stride_f[3:0] = strip_ycnt_stride;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    strip_ycnt_stride[3:0] <= {4{1'b0}};
  end else begin
  if ((init_cnt | stride_end | wr_line_dat_done) == 1'b1) begin
    strip_ycnt_stride[3:0] <= strip_ycnt_stride_f;
  // VCS coverage off
  end else if ((init_cnt | stride_end | wr_line_dat_done) == 1'b0) begin
  end else begin
    strip_ycnt_stride[3:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(init_cnt | stride_end | wr_line_dat_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//2D pooling result ready
assign {mon_pooling_size_minus_sride[1:0],pooling_size_minus_sride[2:0]} = {1'b0,pooling_size_v_cfg[2:0]} - pooling_stride_v_cfg[3:0];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    strip_ycnt_psize <= {3{1'b0}};
  end else begin
   if(init_cnt)
        strip_ycnt_psize[2:0] <= padding_v_cfg[2:0];
   else if({1'b0,pooling_size_v_cfg} >= pooling_stride_v_cfg) begin
       if(pooling_2d_rdy)
            strip_ycnt_psize <= pooling_size_minus_sride[2:0];
       else if(wr_line_dat_done)
            strip_ycnt_psize <= strip_ycnt_psize + 1;
   end else begin // pooling_size < stride
       if(strip_ycnt_stride_f <= {1'b0,pooling_size_v_cfg})
            strip_ycnt_psize <= strip_ycnt_stride_f[2:0];
       else
            strip_ycnt_psize <= 3'd0;
   end
  end
end

//=====================================================================
assign pooling_size_v[3:0] = pooling_size_v_cfg[2:0] + 1;

assign pooling_size[3:0] = pooling_size_v;
assign stride[4:0] = pooling_stride_v;
assign pad_l[2:0] = padding_v_cfg;
assign pad_r = reg2dp_pad_bottom_cfg[2:0];//3'd1;

//active_data_num_last_pooling = (pad_l + width) % stride;
//assign {mon_active_data_num_last_pooling[1:0],active_data_num_last_pooling[2:0]} = pooling_size - pad_r;

//line num need flush at surface end
always @(
  pad_r
  or stride_1x
  or stride_2x
  or stride_3x
  or stride_4x
  or stride_5x
  or stride_6x
  or stride_7x
  ) begin
    if({2'd0,pad_r} < stride_1x[4:0])
        flush_num_cal = 3'd0;
    else if({3'd0,pad_r} < stride_2x[5:0])
        flush_num_cal = 3'd1;
    else if({4'd0,pad_r} < stride_3x[6:0])
        flush_num_cal = 3'd2;
    else if({4'd0,pad_r} < stride_4x[6:0])
        flush_num_cal = 3'd3;
    else if({5'd0,pad_r} < stride_5x[7:0])
        flush_num_cal = 3'd4;
    else if({5'd0,pad_r} < stride_6x[7:0])
        flush_num_cal = 3'd5;
    else if({5'd0,pad_r} < stride_7x[7:0])
        flush_num_cal = 3'd6;
    else// if({5'd0,pad_r} = stride_7x[7:0])
        flush_num_cal = 3'd7;
end

//small input detect
assign small_active = ((~(|reg2dp_cube_in_height[12:3])) & ((reg2dp_cube_in_height[2:0] + reg2dp_pad_top[2:0]) < {1'b0,reg2dp_kernel_height[2:0]}));
//non-split mode cube_width + pad_left + pad_right
assign h_pt[3:0] = reg2dp_cube_in_height[2:0] + reg2dp_pad_top[2:0];
assign h_pt_pb[4:0] = h_pt[3:0] + {1'b0,pad_r};

//pad_right remain afrer 1st kernel pooling
always @(
  small_active
  or h_pt_pb
  or reg2dp_kernel_height
  ) begin
    if(small_active)
        pad_r_remain[5:0] = h_pt_pb[4:0] - {2'd0,reg2dp_kernel_height[2:0]} ;
    else
        pad_r_remain[5:0] = 6'd0 ;
end
//how many need bubble after 1st kernel pooling
always @(
  pad_r_remain
  or stride_6x
  or stride_5x
  or stride_4x
  or stride_3x
  or stride_2x
  or stride_1x
  ) begin
    if({2'd0,pad_r_remain} == stride_6x[7:0])
        samllH_flush_num = 3'd6;
    else if({2'd0,pad_r_remain} == stride_5x[7:0])
        samllH_flush_num = 3'd5;
    else if({1'b0,pad_r_remain} == stride_4x[6:0])
        samllH_flush_num = 3'd4;
    else if({1'b0,pad_r_remain} == stride_3x[6:0])
        samllH_flush_num = 3'd3;
    else if(pad_r_remain == stride_2x[5:0])
        samllH_flush_num = 3'd2;
    else if(pad_r_remain == {1'b0,stride_1x[4:0]})
        samllH_flush_num = 3'd1;
    else// if(pad_r_remain == 8'd0)
        samllH_flush_num = 3'd0;
end

//flush num calc
always @(
  flush_num_cal
  or small_active
  or samllH_flush_num
  ) begin
    if(flush_num_cal==3'd0)
         flush_num[2:0] = 3'd0;
    else if(small_active)
         flush_num[2:0] = samllH_flush_num;
    else
        flush_num[2:0] = flush_num_cal[2:0];
end

assign need_flush = (flush_num != 3'd0);

assign stride_1x[4:0] =   stride[4:0];
assign stride_2x[5:0] =  {stride[4:0],1'b0};
assign stride_3x[6:0] = ( stride_2x+{1'b0,stride[4:0]});
assign stride_4x[6:0] =  {stride[4:0],2'b0}; 
assign stride_5x[7:0] = ( stride_4x+{2'd0,stride[4:0]});
assign stride_6x[7:0] = ( stride_3x+stride_3x);
assign stride_7x[7:0] = ( stride_4x+stride_3x);

//the 1st element/line num need output data
//assign {mon_first_out_num[0],first_out_num[3:0]} = small_active ? {2'd0,reg2dp_cube_in_height[2:0]} : (pooling_size - pad_l);
assign cube_in_height_cfg[3:0] = reg2dp_cube_in_height[2:0] + 3'd1;
assign {mon_first_out_num[0],first_out_num[3:0]} = small_active ? {1'd0,cube_in_height_cfg[3:0]} : (pooling_size - pad_l);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    need_bubble <= 1'b0;
    bubble_num_use[2:0] <= {3{1'b0}};
  end else begin
    //if(wr_total_cube_done) begin
    if(wr_subcube_dat_done) begin
        if(need_flush) begin
            need_bubble <= 1'b1;
            bubble_num_use[2:0]  <= flush_num;
        end else begin
            need_bubble <= 1'b0;
            bubble_num_use[2:0]  <= 3'd0;
        end
    end else if(last_line_in) begin
        if({1'b0,flush_num} >= first_out_num) begin
            need_bubble <= 1'b1;
            bubble_num_use[2:0]  <= flush_num - first_out_num[2:0] + 1'b1 + bubble_add;
        end else if(|bubble_add) begin
            need_bubble <= 1'b1;
            bubble_num_use[2:0]  <= bubble_add;
        end else begin
            need_bubble <= 1'b0;
            bubble_num_use[2:0]  <= 3'd0;
        end
    end
  end
end

///////////////////////////////////////////////////////////////////////
//bubble control when next surface comming .  Beginning
///////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bubble_num[2:0] <= {3{1'b0}};
  end else begin
    if(pdp_op_start) begin
        if({1'b0,flush_num} >= first_out_num) begin
            bubble_num[2:0]  <= flush_num - first_out_num[2:0] + 1'b1;
        end else begin
            bubble_num[2:0]  <= 3'd0;
        end
    end
  end
end
assign {mon_flush_in_next_surf,flush_in_next_surf[2:0]} = flush_num[2:0] - bubble_num[2:0];
///////////////
always @(
  flush_in_next_surf
  or bubble_num
  or pnum_flush1
  or pnum_flush0
  or pnum_flush2
  or pnum_flush3
  or pnum_flush4
  or pnum_flush5
  or pnum_flush6
  ) begin
    if(flush_in_next_surf == 4'd2) begin
        if(bubble_num == 3'd0) begin
            next2_1 = pnum_flush1;
            next2_0 = pnum_flush0;
        end else if(bubble_num == 3'd1) begin
            next2_1 = pnum_flush2;
            next2_0 = pnum_flush1;
        end else if(bubble_num == 3'd2) begin
            next2_1 = pnum_flush3;
            next2_0 = pnum_flush2;
        end else if(bubble_num == 3'd3) begin
            next2_1 = pnum_flush4;
            next2_0 = pnum_flush3;
        end else if(bubble_num == 3'd4) begin
            next2_1 = pnum_flush5;
            next2_0 = pnum_flush4;
        end else begin// else if(bubble_num == 3'd4) begin
            next2_1 = pnum_flush6;
            next2_0 = pnum_flush5;
        end
    end else begin
            next2_1 = 3'd0;
            next2_0 = 3'd0;
    end
end

always @(
  flush_in_next_surf
  or bubble_num
  or pnum_flush2
  or pnum_flush1
  or pnum_flush0
  or pnum_flush3
  or pnum_flush4
  or pnum_flush5
  or pnum_flush6
  ) begin
    if(flush_in_next_surf == 4'd3) begin
        if(bubble_num == 3'd0) begin
            next3_2 = pnum_flush2;
            next3_1 = pnum_flush1;
            next3_0 = pnum_flush0;
        end else if(bubble_num == 3'd1) begin
            next3_2 = pnum_flush3;
            next3_1 = pnum_flush2;
            next3_0 = pnum_flush1;
        end else if(bubble_num == 3'd2) begin
            next3_2 = pnum_flush4;
            next3_1 = pnum_flush3;
            next3_0 = pnum_flush2;
        end else if(bubble_num == 3'd3) begin
            next3_2 = pnum_flush5;
            next3_1 = pnum_flush4;
            next3_0 = pnum_flush3;
        end else begin// else if(bubble_num == 3'd4) begin
            next3_2 = pnum_flush6;
            next3_1 = pnum_flush5;
            next3_0 = pnum_flush4;
        end
    end else begin
            next3_2 = 3'd0;
            next3_1 = 3'd0;
            next3_0 = 3'd0;
    end
end

always @(
  flush_in_next_surf
  or bubble_num
  or pnum_flush3
  or pnum_flush2
  or pnum_flush1
  or pnum_flush0
  or pnum_flush4
  or pnum_flush5
  or pnum_flush6
  ) begin
    if(flush_in_next_surf == 4'd4) begin
        if(bubble_num == 3'd0) begin
            next4_3 = pnum_flush3;
            next4_2 = pnum_flush2;
            next4_1 = pnum_flush1;
            next4_0 = pnum_flush0;
        end else if(bubble_num == 3'd1) begin
            next4_3 = pnum_flush4;
            next4_2 = pnum_flush3;
            next4_1 = pnum_flush2;
            next4_0 = pnum_flush1;
        end else if(bubble_num == 3'd2) begin
            next4_3 = pnum_flush5;
            next4_2 = pnum_flush4;
            next4_1 = pnum_flush3;
            next4_0 = pnum_flush2;
        end else begin//else if(bubble_num == 3'd3) begin
            next4_3 = pnum_flush6;
            next4_2 = pnum_flush5;
            next4_1 = pnum_flush4;
            next4_0 = pnum_flush3;
        end
    end else begin
            next4_3 = 3'd0;
            next4_2 = 3'd0;
            next4_1 = 3'd0;
            next4_0 = 3'd0;
    end
end

always @(
  flush_in_next_surf
  or bubble_num
  or pnum_flush4
  or pnum_flush3
  or pnum_flush2
  or pnum_flush1
  or pnum_flush0
  or pnum_flush5
  or pnum_flush6
  ) begin
    if(flush_in_next_surf == 4'd5) begin
        if(bubble_num == 3'd0) begin
            next5_4 = pnum_flush4;
            next5_3 = pnum_flush3;
            next5_2 = pnum_flush2;
            next5_1 = pnum_flush1;
            next5_0 = pnum_flush0;
        end else if(bubble_num == 3'd1) begin
            next5_4 = pnum_flush5;
            next5_3 = pnum_flush4;
            next5_2 = pnum_flush3;
            next5_1 = pnum_flush2;
            next5_0 = pnum_flush1;
        end else begin //else if(bubble_num == 3'd2) begin
            next5_4 = pnum_flush6;
            next5_3 = pnum_flush5;
            next5_2 = pnum_flush4;
            next5_1 = pnum_flush3;
            next5_0 = pnum_flush2;
        end
    end else begin
            next5_4 = 3'd0;
            next5_3 = 3'd0;
            next5_2 = 3'd0;
            next5_1 = 3'd0;
            next5_0 = 3'd0;
    end
end
always @(
  flush_in_next_surf
  or bubble_num
  or pnum_flush5
  or pnum_flush4
  or pnum_flush3
  or pnum_flush2
  or pnum_flush1
  or pnum_flush0
  or pnum_flush6
  ) begin
    if(flush_in_next_surf == 4'd6) begin
        if(bubble_num == 3'd0) begin
            next6_5 = pnum_flush5;
            next6_4 = pnum_flush4;
            next6_3 = pnum_flush3;
            next6_2 = pnum_flush2;
            next6_1 = pnum_flush1;
            next6_0 = pnum_flush0;
        end else begin//else if(bubble_num == 3'd1) begin
            next6_5 = pnum_flush6;
            next6_4 = pnum_flush5;
            next6_3 = pnum_flush4;
            next6_2 = pnum_flush3;
            next6_1 = pnum_flush2;
            next6_0 = pnum_flush1;
        end
    end else begin
            next6_5 = 3'd0;
            next6_4 = 3'd0;
            next6_3 = 3'd0;
            next6_2 = 3'd0;
            next6_1 = 3'd0;
            next6_0 = 3'd0;
    end
end
always @(
  flush_in_next_surf
  or pnum_flush6
  or pnum_flush5
  or pnum_flush4
  or pnum_flush3
  or pnum_flush2
  or pnum_flush1
  or pnum_flush0
  ) begin
    if(flush_in_next_surf == 4'd7) begin
            next7_6 = pnum_flush6;
            next7_5 = pnum_flush5;
            next7_4 = pnum_flush4;
            next7_3 = pnum_flush3;
            next7_2 = pnum_flush2;
            next7_1 = pnum_flush1;
            next7_0 = pnum_flush0;
    end else begin
            next7_6 = 3'd0;
            next7_5 = 3'd0;
            next7_4 = 3'd0;
            next7_3 = 3'd0;
            next7_2 = 3'd0;
            next7_1 = 3'd0;
            next7_0 = 3'd0;
    end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bubble_add <= {3{1'b0}};
  end else begin
    if(flush_in_next_surf == 4'd2) begin
            if((up_pnum0 == next2_1)|({2'd0,up_pnum1} == next2_1)|({1'b0,up_pnum2} == next2_1)|({1'b0,up_pnum3} == next2_1)|(up_pnum4 == next2_1)|(up_pnum5 == next2_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next2_0)|({2'd0,up_pnum1} == next2_0)|({1'b0,up_pnum2} == next2_0)|({1'b0,up_pnum3} == next2_0)|(up_pnum4 == next2_0)|(up_pnum5 == next2_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else if(flush_in_next_surf == 4'd3) begin
            if(     (up_pnum0 == next3_2)|({2'd0,up_pnum1} == next3_2)|({1'b0,up_pnum2} == next3_2)|({1'b0,up_pnum3} == next3_2)|(up_pnum4 == next3_2)|(up_pnum5 == next3_2))
                bubble_add <= 3'd3;
            else if((up_pnum0 == next3_1)|({2'd0,up_pnum1} == next3_1)|({1'b0,up_pnum2} == next3_1)|({1'b0,up_pnum3} == next3_1)|(up_pnum4 == next3_1)|(up_pnum5 == next3_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next3_0)|({2'd0,up_pnum1} == next3_0)|({1'b0,up_pnum2} == next3_0)|({1'b0,up_pnum3} == next3_0)|(up_pnum4 == next3_0)|(up_pnum5 == next3_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else if(flush_in_next_surf == 4'd4) begin
            if(     (up_pnum0 == next4_3)|({2'd0,up_pnum1} == next4_3)|({1'b0,up_pnum2} == next4_3)|({1'b0,up_pnum3} == next4_3)|(up_pnum4 == next4_3)|(up_pnum5 == next4_3))
                bubble_add <= 3'd4;
            else if((up_pnum0 == next4_2)|({2'd0,up_pnum1} == next4_2)|({1'b0,up_pnum2} == next4_2)|({1'b0,up_pnum3} == next4_2)|(up_pnum4 == next4_2)|(up_pnum5 == next4_2))
                bubble_add <= 3'd3;
            else if((up_pnum0 == next4_1)|({2'd0,up_pnum1} == next4_1)|({1'b0,up_pnum2} == next4_1)|({1'b0,up_pnum3} == next4_1)|(up_pnum4 == next4_1)|(up_pnum5 == next4_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next4_0)|({2'd0,up_pnum1} == next4_0)|({1'b0,up_pnum2} == next4_0)|({1'b0,up_pnum3} == next4_0)|(up_pnum4 == next4_0)|(up_pnum5 == next4_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else if(flush_in_next_surf == 4'd5) begin
            if(     (up_pnum0 == next5_4)|({2'd0,up_pnum1} == next5_4)|({1'b0,up_pnum2} == next5_4)|({1'b0,up_pnum3} == next5_4)|(up_pnum4 == next5_4)|(up_pnum5 == next5_4))
                bubble_add <= 3'd5;
            else if((up_pnum0 == next5_3)|({2'd0,up_pnum1} == next5_3)|({1'b0,up_pnum2} == next5_3)|({1'b0,up_pnum3} == next5_3)|(up_pnum4 == next5_3)|(up_pnum5 == next5_3))
                bubble_add <= 3'd4;
            else if((up_pnum0 == next5_2)|({2'd0,up_pnum1} == next5_2)|({1'b0,up_pnum2} == next5_2)|({1'b0,up_pnum3} == next5_2)|(up_pnum4 == next5_2)|(up_pnum5 == next5_2))
                bubble_add <= 3'd3;
            else if((up_pnum0 == next5_1)|({2'd0,up_pnum1} == next5_1)|({1'b0,up_pnum2} == next5_1)|({1'b0,up_pnum3} == next5_1)|(up_pnum4 == next5_1)|(up_pnum5 == next5_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next5_0)|({2'd0,up_pnum1} == next5_0)|({1'b0,up_pnum2} == next5_0)|({1'b0,up_pnum3} == next5_0)|(up_pnum4 == next5_0)|(up_pnum5 == next5_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else if(flush_in_next_surf == 4'd6) begin
            if(     (up_pnum0 == next6_5)|({2'd0,up_pnum1} == next6_5)|({1'b0,up_pnum2} == next6_5)|({1'b0,up_pnum3} == next6_5)|(up_pnum4 == next6_5)|(up_pnum5 == next6_5))
                bubble_add <= 3'd6;
            else if((up_pnum0 == next6_4)|({2'd0,up_pnum1} == next6_4)|({1'b0,up_pnum2} == next6_4)|({1'b0,up_pnum3} == next6_4)|(up_pnum4 == next6_4)|(up_pnum5 == next6_4))
                bubble_add <= 3'd5;
            else if((up_pnum0 == next6_3)|({2'd0,up_pnum1} == next6_3)|({1'b0,up_pnum2} == next6_3)|({1'b0,up_pnum3} == next6_3)|(up_pnum4 == next6_3)|(up_pnum5 == next6_3))
                bubble_add <= 3'd4;
            else if((up_pnum0 == next6_2)|({2'd0,up_pnum1} == next6_2)|({1'b0,up_pnum2} == next6_2)|({1'b0,up_pnum3} == next6_2)|(up_pnum4 == next6_2)|(up_pnum5 == next6_2))
                bubble_add <= 3'd3;
            else if((up_pnum0 == next6_1)|({2'd0,up_pnum1} == next6_1)|({1'b0,up_pnum2} == next6_1)|({1'b0,up_pnum3} == next6_1)|(up_pnum4 == next6_1)|(up_pnum5 == next6_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next6_0)|({2'd0,up_pnum1} == next6_0)|({1'b0,up_pnum2} == next6_0)|({1'b0,up_pnum3} == next6_0)|(up_pnum4 == next6_0)|(up_pnum5 == next6_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else if(flush_in_next_surf == 4'd7) begin
            if(     (up_pnum0 == next7_6)|({2'd0,up_pnum1} == next7_6)|({1'b0,up_pnum2} == next7_6)|({1'b0,up_pnum3} == next7_6)|(up_pnum4 == next7_6)|(up_pnum5 == next7_6))
                bubble_add <= 3'd7;
            else if((up_pnum0 == next7_5)|({2'd0,up_pnum1} == next7_5)|({1'b0,up_pnum2} == next7_5)|({1'b0,up_pnum3} == next7_5)|(up_pnum4 == next7_5)|(up_pnum5 == next7_5))
                bubble_add <= 3'd6;
            else if((up_pnum0 == next7_4)|({2'd0,up_pnum1} == next7_4)|({1'b0,up_pnum2} == next7_4)|({1'b0,up_pnum3} == next7_4)|(up_pnum4 == next7_4)|(up_pnum5 == next7_4))
                bubble_add <= 3'd5;
            else if((up_pnum0 == next7_3)|({2'd0,up_pnum1} == next7_3)|({1'b0,up_pnum2} == next7_3)|({1'b0,up_pnum3} == next7_3)|(up_pnum4 == next7_3)|(up_pnum5 == next7_3))
                bubble_add <= 3'd4;
            else if((up_pnum0 == next7_2)|({2'd0,up_pnum1} == next7_2)|({1'b0,up_pnum2} == next7_2)|({1'b0,up_pnum3} == next7_2)|(up_pnum4 == next7_2)|(up_pnum5 == next7_2))
                bubble_add <= 3'd3;
            else if((up_pnum0 == next7_1)|({2'd0,up_pnum1} == next7_1)|({1'b0,up_pnum2} == next7_1)|({1'b0,up_pnum3} == next7_1)|(up_pnum4 == next7_1)|(up_pnum5 == next7_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next7_0)|({2'd0,up_pnum1} == next7_0)|({1'b0,up_pnum2} == next7_0)|({1'b0,up_pnum3} == next7_0)|(up_pnum4 == next7_0)|(up_pnum5 == next7_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else begin
        bubble_add <= 3'd0;
    end
  end
end
//-------------------------
assign unit2d_cnt_pooling_a1[3:0] = unit2d_cnt_pooling[2:0] + 3'd1;
assign unit2d_cnt_pooling_a2[3:0] = unit2d_cnt_pooling[2:0] + 3'd2;
assign unit2d_cnt_pooling_a3[3:0] = unit2d_cnt_pooling[2:0] + 3'd3;
assign unit2d_cnt_pooling_a4[3:0] = unit2d_cnt_pooling[2:0] + 3'd4;
assign unit2d_cnt_pooling_a5[3:0] = unit2d_cnt_pooling[2:0] + 3'd5;
assign unit2d_cnt_pooling_a6[3:0] = unit2d_cnt_pooling[2:0] + 3'd6;
assign unit2d_cnt_pooling_a7[3:0] = unit2d_cnt_pooling[2:0] + 3'd7;

//pooling No. in flush time
always @(posedge nvdla_core_clk) begin
    //if(wr_surface_dat_done) begin
    if(last_line_in) begin
        if(unit2d_cnt_pooling[2:0] == unit2d_cnt_pooling_max) begin
            pnum_flush0 <= 3'd0;
            pnum_flush1 <= 3'd1;
            pnum_flush2 <= 3'd2;
            pnum_flush3 <= 3'd3;
            pnum_flush4 <= 3'd4;
            pnum_flush5 <= 3'd5;
            pnum_flush6 <= 3'd6;
        end else if(unit2d_cnt_pooling_a1 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling_max;
            pnum_flush1 <= 3'd0;
            pnum_flush2 <= 3'd1;
            pnum_flush3 <= 3'd2;
            pnum_flush4 <= 3'd3;
            pnum_flush5 <= 3'd4;
            pnum_flush6 <= 3'd5;
        end else if(unit2d_cnt_pooling_a2 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'b1;
            pnum_flush1 <= unit2d_cnt_pooling_max;
            pnum_flush2 <= 3'd0;
            pnum_flush3 <= 3'd1;
            pnum_flush4 <= 3'd2;
            pnum_flush5 <= 3'd3;
            pnum_flush6 <= 3'd4;
        end else if(unit2d_cnt_pooling_a3 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'd1;
            pnum_flush1 <= unit2d_cnt_pooling + 2'd2;
            pnum_flush2 <= unit2d_cnt_pooling_max;
            pnum_flush3 <= 3'd0;
            pnum_flush4 <= 3'd1;
            pnum_flush5 <= 3'd2;
            pnum_flush6 <= 3'd3;
        end else if(unit2d_cnt_pooling_a4 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'd1;
            pnum_flush1 <= unit2d_cnt_pooling + 2'd2;
            pnum_flush2 <= unit2d_cnt_pooling + 2'd3;
            pnum_flush3 <= unit2d_cnt_pooling_max;
            pnum_flush4 <= 3'd0;
            pnum_flush5 <= 3'd1;
            pnum_flush6 <= 3'd2;
        end else if(unit2d_cnt_pooling_a5 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'd1;
            pnum_flush1 <= unit2d_cnt_pooling + 2'd2;
            pnum_flush2 <= unit2d_cnt_pooling + 2'd3;
            pnum_flush3 <= unit2d_cnt_pooling + 3'd4;
            pnum_flush4 <= unit2d_cnt_pooling_max;
            pnum_flush5 <= 3'd0;
            pnum_flush6 <= 3'd1;
        end else if(unit2d_cnt_pooling_a6 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'd1;
            pnum_flush1 <= unit2d_cnt_pooling + 2'd2;
            pnum_flush2 <= unit2d_cnt_pooling + 2'd3;
            pnum_flush3 <= unit2d_cnt_pooling + 3'd4;
            pnum_flush4 <= unit2d_cnt_pooling + 3'd5;
            pnum_flush5 <= unit2d_cnt_pooling_max;
            pnum_flush6 <= 3'd0;
        end else if(unit2d_cnt_pooling_a7 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'd1;
            pnum_flush1 <= unit2d_cnt_pooling + 2'd2;
            pnum_flush2 <= unit2d_cnt_pooling + 2'd3;
            pnum_flush3 <= unit2d_cnt_pooling + 3'd4;
            pnum_flush4 <= unit2d_cnt_pooling + 3'd5;
            pnum_flush5 <= unit2d_cnt_pooling + 3'd6;
            pnum_flush6 <= unit2d_cnt_pooling_max;
        end
    end
end

//-------------------------
//update pooling No. in line2 of next surface
//-------------------------
assign up_pnum0 = 3'd0;
always @(posedge nvdla_core_clk) begin
    if(padding_v_cfg[2:0] == 3'd0) begin
        up_pnum1 <= 1'd0;
        up_pnum2 <= 2'd0;
        up_pnum3 <= 2'd0;
        up_pnum4 <= 3'd0;
        up_pnum5 <= 3'd0;
    end else if(padding_v_cfg[2:0] == 3'd1) begin
        if(stride[4:0]==5'd1) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else begin
            up_pnum1 <= 1'd0;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end
    end else if(padding_v_cfg[2:0] == 3'd2) begin
        if(stride[4:0]==5'd1) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else if(stride[4:0]==5'd2) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else begin
            up_pnum1 <= 1'd0;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end
    end else if(padding_v_cfg[2:0] == 3'd3) begin
        if(stride[4:0]==5'd1) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd3;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else if((stride[4:0]==5'd2)|(stride[4:0]==5'd3)) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else begin
            up_pnum1 <= 1'd0;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end
    end else if(padding_v_cfg[2:0] == 3'd4) begin
        if(stride[4:0]==5'd1) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd3;
            up_pnum4 <= 3'd4;
            up_pnum5 <= 3'd0;
        end else if(stride[4:0]==5'd2) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else if((stride[4:0]==5'd3)|(stride[4:0]==5'd4)) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else begin
            up_pnum1 <= 1'd0;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end
    end else if(padding_v_cfg[2:0] == 3'd5) begin
        if(stride[4:0]==5'd1) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd3;
            up_pnum4 <= 3'd4;
            up_pnum5 <= 3'd5;
        end else if(stride[4:0]==5'd2) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else if((stride[4:0]==5'd3)|(stride[4:0]==5'd4)|(stride[4:0]==5'd5)) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else begin
            up_pnum1 <= 1'd0;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end
    end
end

///////////////////////////////////////////////////////////////////////
//bubble control when next surface comming .  Ending
///////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    subend_need_flush_flg <= 1'b0;
  end else begin
    if(wr_subcube_dat_done & need_flush & is_one_width_in)
        subend_need_flush_flg <= 1'b1;
    else if(one_width_bubble_end)
        subend_need_flush_flg <= 1'b0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    surfend_need_bubble_flg <= 1'b0;
  end else begin
    if(wr_surface_dat_done & need_bubble & is_one_width_in)
        surfend_need_bubble_flg <= 1'b1;
    else if(one_width_bubble_end)
        surfend_need_bubble_flg <= 1'b0;
  end
end

/////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cur_datin_disable <= 1'b0;
  end else begin
    if((wr_subcube_dat_done & need_flush & (~is_one_width_in)) | (subend_need_flush_flg & one_width_bubble_end))
        cur_datin_disable <= 1'b1;
    else if((wr_surface_dat_done & need_bubble & (~is_one_width_in)) | (surfend_need_bubble_flg & one_width_bubble_end))
        cur_datin_disable <= 1'b1;
    else if(bubble_en_end)
        cur_datin_disable <= 1'b0;
  end
end
/////////////////////////////////////////
//&Always posedge;
//    if(wr_subcube_dat_done & need_flush)
//        cur_datin_disable <0= 1'b1;
//    else if(wr_surface_dat_done & need_bubble)
//        cur_datin_disable <0= 1'b1;
//    else if(bubble_en_end)
//        cur_datin_disable <0= 1'b0;
//&End;
///////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_width_cur_latch <= {13{1'b0}};
  end else begin
    if((wr_subcube_dat_done & need_flush) || (wr_surface_dat_done & need_bubble))
        pout_width_cur_latch <= pout_width_cur;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    channel_cnt <= {2{1'b0}};
  end else begin
    if(cur_datin_disable) begin
        if(last_c)
            channel_cnt <= 2'd0;
        //else if(pooling1d_norm_rdy)
        else if(one_width_norm_rdy)
            channel_cnt <= channel_cnt + 1'b1;
    end else
            channel_cnt <= 2'd0;
  end
end
//assign last_c = (channel_cnt==2'd3) & pooling1d_norm_rdy;
assign last_c = (channel_cnt==2'd3) & one_width_norm_rdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    line_cnt <= {13{1'b0}};
  end else begin
    if(cur_datin_disable) begin
        if(line_end)
            line_cnt <= 13'd0;
        else if(last_c)
            line_cnt <= line_cnt + 1'b1;
    end else
            line_cnt <= 13'd0;
  end
end
assign line_end = (line_cnt==pout_width_cur_latch) & last_c;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bubble_cnt <= {3{1'b0}};
  end else begin
    if(cur_datin_disable) begin
        if(bubble_en_end)
            bubble_cnt <= 3'd0;
        else if(line_end)
            bubble_cnt <= bubble_cnt + 1'b1;
    end else
            bubble_cnt <= 3'd0;
  end
end
assign bubble_en_end = (bubble_cnt == bubble_num_dec) & line_end;
assign bubble_num_dec[2:0] = (bubble_num_use-1'b1);

//////////////////////////////////////////////////////
//last lines output en during new lines comming
//----------------------------------------------------
//cube end flag for last_out_en control in the cube end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cube_end_flag <= 1'b0;
  end else begin
    if(wr_subcube_dat_done)
        cube_end_flag <= 1'b1;
    else if(load_din)
        cube_end_flag <= 1'b0;
  end
end

//assign {mon_first_out_num_dec1[1:0],first_out_num_dec1[2:0]} = first_out_num - 4'd1;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_out_en <= 1'b0;
  end else begin
    if(first_out_num != 3'd1) begin
        if((need_bubble & bubble_en_end & (~cube_end_flag) & (bubble_add < flush_in_next_surf)) | (~need_bubble & need_flush & wr_surface_dat_done & (~wr_subcube_dat_done)))
            last_out_en <= 1'b1;
        else if(last_out_done)
            last_out_en <= 1'b0;
    end else
            last_out_en <= 1'b0;
  end
end

assign first_out_num_dec2[2:0] = flush_num - bubble_num_use - 1'b1;//first_out_num - 2'd2;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_out_cnt <= {3{1'b0}};
  end else begin
    if(last_out_en) begin
        if(wr_line_dat_done) begin
            if(((last_out_cnt == first_out_num_dec2) & need_bubble) | (~need_bubble & (last_out_cnt == flush_num_dec1)))
                last_out_cnt <= 3'd0;
            else
                last_out_cnt <= last_out_cnt + 1'b1;
        end
    end else
        last_out_cnt <= 3'd0;
  end
end
assign {mon_flush_num_dec1,flush_num_dec1[2:0]} = flush_num - 3'd1;
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
  nv_assert_never #(0,0,"PDP cal2d datin_disable: no overflow is allowed")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, mon_flush_num_dec1 & wr_line_dat_done & last_out_en); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign last_out_done = (((last_out_cnt == first_out_num_dec2) & need_bubble) | (~need_bubble & (last_out_cnt == flush_num_dec1))) & wr_line_dat_done & last_out_en;

///////////////////////////////////////////////////////////////////////
//bubble control when input width is only 1 element in width
///////////////////////////////////////////////////////////////////////
always @(
  splitw_enable
  or reg2dp_cube_out_width
  or first_splitw
  or reg2dp_partial_width_out_first
  or last_splitw
  or reg2dp_partial_width_out_last
  or pooling_splitw_num_cfg
  or reg2dp_partial_width_out_mid
  ) begin
    if(~splitw_enable)
        is_one_width_in = (reg2dp_cube_out_width[12:0] == 13'd0);
    else if(first_splitw)
        is_one_width_in = (reg2dp_partial_width_out_first[9:0] == 10'd0);
    else if(last_splitw)
        is_one_width_in = (reg2dp_partial_width_out_last[9:0] == 10'd0);
    else
        is_one_width_in = (pooling_splitw_num_cfg > 8'd1)? (reg2dp_partial_width_out_mid[9:0] == 10'd0) : 1'b0;
end
/////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    one_width_disable <= 1'b0;
  end else begin
    if(wr_line_dat_done & is_one_width_in)
        one_width_disable <= 1'b1;
    else if(one_width_bubble_end)
        one_width_disable <= 1'b0;
  end
end
/////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    one_width_bubble_cnt <= {3{1'b0}};
  end else begin
    if(one_width_disable) begin
        if(one_width_bubble_end)
            one_width_bubble_cnt <= 3'd0;
        else if(pooling1d_norm_rdy)
            one_width_bubble_cnt <= one_width_bubble_cnt + 1'b1;
    end else
            one_width_bubble_cnt <= 3'd0;
  end
end
assign one_width_bubble_end = (one_width_bubble_cnt == (4 -2'd2)) & pooling1d_norm_rdy;

//////////////////////////////////////////////////////

assign  pooling_2d_rdy      = wr_line_dat_done & (strip_ycnt_psize ==pooling_size_v_cfg[2:0])  ;
//=====================================================================
//pooling 2D unit counter
//
//---------------------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_cnt_stride[2:0] <= {3{1'b0}};
  end else begin
    if(init_cnt)
       unit2d_cnt_stride[2:0] <= padding_stride_num;
    else if(stride_end) begin
       if(stride_trig_end)
          unit2d_cnt_stride[2:0] <= 3'd0;
       else
          unit2d_cnt_stride[2:0] <= unit2d_cnt_stride + 1;
    end
  end
end
assign stride_trig_end = (unit2d_cnt_pooling_max==unit2d_cnt_stride);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_cnt_pooling <= {3{1'b0}};
  end else begin
    if(init_cnt)
         unit2d_cnt_pooling <= 3'd0;
    else if(pooling_2d_rdy | wr_surface_dat_done) begin
      if(unit2d_cnt_pooling_end)
           unit2d_cnt_pooling <= 3'd0;
      else
           unit2d_cnt_pooling[2:0] <= unit2d_cnt_pooling + 1;
    end
  end
end
assign unit2d_cnt_pooling_end = (unit2d_cnt_pooling == unit2d_cnt_pooling_max);

assign {mon_unit2d_cnt_pooling_max[1:0],unit2d_cnt_pooling_max[2:0]} = buffer_lines_num - 4'd1;
//-------------------------
//flag the last one pooling in height direction
//-------------------------
assign {mon_rest_height,rest_height[12:0]} = reg2dp_cube_in_height - wr_surface_dat_cnt;
assign rest_height_use[13:0] = rest_height + {10'd0,reg2dp_pad_bottom_cfg};
assign last_pooling_flag = rest_height_use[13:0] <= {11'd0,pooling_size_v_cfg};
//======================================================================

//unit2d pooling enable         
assign init_unit2d_set[0] = init_cnt & (padding_stride_num>=0); 

assign unit2d_set_trig[0] = stride_end & stride_trig_end & (~last_pooling_flag);

assign unit2d_set[0] = unit2d_set_trig[0] | init_unit2d_set[0];

assign unit2d_clr[0] = (pooling_2d_rdy & (unit2d_cnt_pooling == 3'd0)) | wr_surface_dat_done;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_en[0] <= 1'b0;
  end else begin

 if(wr_total_cube_done) 

      unit2d_en[0] <= 1'b0;

 else if(unit2d_set[0]) 

      unit2d_en[0] <= 1'b1;

 else if(unit2d_clr[0]) 

      unit2d_en[0] <= 1'b0;

  end
end

assign init_unit2d_set[1] = init_cnt & (padding_stride_num>=1); 

assign unit2d_set_trig[1] = stride_end & (unit2d_cnt_stride == 3'd0) & (~stride_trig_end) & (~last_pooling_flag);

assign unit2d_set[1] = unit2d_set_trig[1] | init_unit2d_set[1];

assign unit2d_clr[1] = (pooling_2d_rdy & (unit2d_cnt_pooling == 3'd1)) | wr_surface_dat_done;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_en[1] <= 1'b0;
  end else begin

 if(wr_total_cube_done) 

      unit2d_en[1] <= 1'b0;

 else if(unit2d_set[1]) 

      unit2d_en[1] <= 1'b1;

 else if(unit2d_clr[1]) 

      unit2d_en[1] <= 1'b0;

  end
end

assign init_unit2d_set[2] = init_cnt & (padding_stride_num>=2); 

assign unit2d_set_trig[2] = stride_end & (unit2d_cnt_stride == 3'd1) & (~stride_trig_end) & (~last_pooling_flag);

assign unit2d_set[2] = unit2d_set_trig[2] | init_unit2d_set[2];

assign unit2d_clr[2] = (pooling_2d_rdy & (unit2d_cnt_pooling == 3'd2)) | wr_surface_dat_done;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_en[2] <= 1'b0;
  end else begin

 if(wr_total_cube_done) 

      unit2d_en[2] <= 1'b0;

 else if(unit2d_set[2]) 

      unit2d_en[2] <= 1'b1;

 else if(unit2d_clr[2]) 

      unit2d_en[2] <= 1'b0;

  end
end

assign init_unit2d_set[3] = init_cnt & (padding_stride_num>=3); 

assign unit2d_set_trig[3] = stride_end & (unit2d_cnt_stride == 3'd2) & (~stride_trig_end) & (~last_pooling_flag);

assign unit2d_set[3] = unit2d_set_trig[3] | init_unit2d_set[3];

assign unit2d_clr[3] = (pooling_2d_rdy & (unit2d_cnt_pooling == 3'd3)) | wr_surface_dat_done;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_en[3] <= 1'b0;
  end else begin

 if(wr_total_cube_done) 

      unit2d_en[3] <= 1'b0;

 else if(unit2d_set[3]) 

      unit2d_en[3] <= 1'b1;

 else if(unit2d_clr[3]) 

      unit2d_en[3] <= 1'b0;

  end
end

assign init_unit2d_set[4] = init_cnt & (padding_stride_num>=4); 

assign unit2d_set_trig[4] = stride_end & (unit2d_cnt_stride == 3'd3) & (~stride_trig_end) & (~last_pooling_flag);

assign unit2d_set[4] = unit2d_set_trig[4] | init_unit2d_set[4];

assign unit2d_clr[4] = (pooling_2d_rdy & (unit2d_cnt_pooling == 3'd4)) | wr_surface_dat_done;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_en[4] <= 1'b0;
  end else begin

 if(wr_total_cube_done) 

      unit2d_en[4] <= 1'b0;

 else if(unit2d_set[4]) 

      unit2d_en[4] <= 1'b1;

 else if(unit2d_clr[4]) 

      unit2d_en[4] <= 1'b0;

  end
end

assign init_unit2d_set[5] = init_cnt & (padding_stride_num>=5); 

assign unit2d_set_trig[5] = stride_end & (unit2d_cnt_stride == 3'd4) & (~stride_trig_end) & (~last_pooling_flag);

assign unit2d_set[5] = unit2d_set_trig[5] | init_unit2d_set[5];

assign unit2d_clr[5] = (pooling_2d_rdy & (unit2d_cnt_pooling == 3'd5)) | wr_surface_dat_done;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_en[5] <= 1'b0;
  end else begin

 if(wr_total_cube_done) 

      unit2d_en[5] <= 1'b0;

 else if(unit2d_set[5]) 

      unit2d_en[5] <= 1'b1;

 else if(unit2d_clr[5]) 

      unit2d_en[5] <= 1'b0;

  end
end

assign init_unit2d_set[6] = init_cnt & (padding_stride_num>=6); 

assign unit2d_set_trig[6] = stride_end & (unit2d_cnt_stride == 3'd5) & (~stride_trig_end) & (~last_pooling_flag);

assign unit2d_set[6] = unit2d_set_trig[6] | init_unit2d_set[6];

assign unit2d_clr[6] = (pooling_2d_rdy & (unit2d_cnt_pooling == 3'd6)) | wr_surface_dat_done;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_en[6] <= 1'b0;
  end else begin

 if(wr_total_cube_done) 

      unit2d_en[6] <= 1'b0;

 else if(unit2d_set[6]) 

      unit2d_en[6] <= 1'b1;

 else if(unit2d_clr[6]) 

      unit2d_en[6] <= 1'b0;

  end
end

assign init_unit2d_set[7] = init_cnt & (padding_stride_num>=7); 

assign unit2d_set_trig[7] = stride_end & (unit2d_cnt_stride == 3'd6) & (~stride_trig_end) & (~last_pooling_flag);

assign unit2d_set[7] = unit2d_set_trig[7] | init_unit2d_set[7];

assign unit2d_clr[7] = (pooling_2d_rdy & (unit2d_cnt_pooling == 3'd7)) | wr_surface_dat_done;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_en[7] <= 1'b0;
  end else begin

 if(wr_total_cube_done) 

      unit2d_en[7] <= 1'b0;

 else if(unit2d_set[7]) 

      unit2d_en[7] <= 1'b1;

 else if(unit2d_clr[7]) 

      unit2d_en[7] <= 1'b0;

  end
end

 
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datin_buf <= {112{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    datin_buf <= pooling1d_pd_use[111:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    datin_buf <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wr_line_end_buf <= 1'b0;
  end else begin
  if ((load_din) == 1'b1) begin
    wr_line_end_buf <= wr_line_dat_done;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    wr_line_end_buf <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wr_surface_dat_done_buf <= 1'b0;
  end else begin
  if ((load_din) == 1'b1) begin
    wr_surface_dat_done_buf <= wr_surface_dat_done;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    wr_surface_dat_done_buf <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////////////
//calculate the real pooling size within one poooling 
//PerBeg
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_vsize_cnt_0[2:0] <= {3{1'b0}};
  end else begin

    if(unit2d_set[0]) 

        unit2d_vsize_cnt_0[2:0] <= 3'd0; 

    else if(unit2d_en[0] & wr_line_dat_done)

        unit2d_vsize_cnt_0[2:0] <= unit2d_vsize_cnt_0[2:0] + 3'd1;

  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_vsize_cnt_1[2:0] <= {3{1'b0}};
  end else begin

    if(unit2d_set[1]) 

        unit2d_vsize_cnt_1[2:0] <= 3'd0; 

    else if(unit2d_en[1] & wr_line_dat_done)

        unit2d_vsize_cnt_1[2:0] <= unit2d_vsize_cnt_1[2:0] + 3'd1;

  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_vsize_cnt_2[2:0] <= {3{1'b0}};
  end else begin

    if(unit2d_set[2]) 

        unit2d_vsize_cnt_2[2:0] <= 3'd0; 

    else if(unit2d_en[2] & wr_line_dat_done)

        unit2d_vsize_cnt_2[2:0] <= unit2d_vsize_cnt_2[2:0] + 3'd1;

  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_vsize_cnt_3[2:0] <= {3{1'b0}};
  end else begin

    if(unit2d_set[3]) 

        unit2d_vsize_cnt_3[2:0] <= 3'd0; 

    else if(unit2d_en[3] & wr_line_dat_done)

        unit2d_vsize_cnt_3[2:0] <= unit2d_vsize_cnt_3[2:0] + 3'd1;

  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_vsize_cnt_4[2:0] <= {3{1'b0}};
  end else begin

    if(unit2d_set[4]) 

        unit2d_vsize_cnt_4[2:0] <= 3'd0; 

    else if(unit2d_en[4] & wr_line_dat_done)

        unit2d_vsize_cnt_4[2:0] <= unit2d_vsize_cnt_4[2:0] + 3'd1;

  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_vsize_cnt_5[2:0] <= {3{1'b0}};
  end else begin

    if(unit2d_set[5]) 

        unit2d_vsize_cnt_5[2:0] <= 3'd0; 

    else if(unit2d_en[5] & wr_line_dat_done)

        unit2d_vsize_cnt_5[2:0] <= unit2d_vsize_cnt_5[2:0] + 3'd1;

  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_vsize_cnt_6[2:0] <= {3{1'b0}};
  end else begin

    if(unit2d_set[6]) 

        unit2d_vsize_cnt_6[2:0] <= 3'd0; 

    else if(unit2d_en[6] & wr_line_dat_done)

        unit2d_vsize_cnt_6[2:0] <= unit2d_vsize_cnt_6[2:0] + 3'd1;

  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_vsize_cnt_7[2:0] <= {3{1'b0}};
  end else begin

    if(unit2d_set[7]) 

        unit2d_vsize_cnt_7[2:0] <= 3'd0; 

    else if(unit2d_en[7] & wr_line_dat_done)

        unit2d_vsize_cnt_7[2:0] <= unit2d_vsize_cnt_7[2:0] + 3'd1;

  end
end


//line buffer number 1
assign unit2d_vsize1_0 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_1 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_2 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_3 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_4 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_5 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_6 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_7 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;

//line buffer number 2
assign unit2d_vsize2_0 = mem_re2_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize2_1 = mem_re2_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize2_2 = mem_re2_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize2_3 = mem_re2_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize2_4 = mem_re2_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize2_5 = mem_re2_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize2_6 = mem_re2_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize2_7 = mem_re2_sel? unit2d_vsize_cnt_1 : 3'd0;

//line buffer number 3 4
assign unit2d_vsize3_0 = mem_re3_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize3_1 = mem_re3_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize3_2 = mem_re3_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize3_3 = mem_re3_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize3_4 = mem_re3_sel? unit2d_vsize_cnt_2 : 3'd0;
assign unit2d_vsize3_5 = mem_re3_sel? unit2d_vsize_cnt_2 : 3'd0;
assign unit2d_vsize3_6 = mem_re3_sel? unit2d_vsize_cnt_3 : 3'd0;
assign unit2d_vsize3_7 = mem_re3_sel? unit2d_vsize_cnt_3 : 3'd0;

//line buffer 5 6 7 8
assign unit2d_vsize4_0 = mem_re4_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize4_1 = mem_re4_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize4_2 = mem_re4_sel? unit2d_vsize_cnt_2 : 3'd0;
assign unit2d_vsize4_3 = mem_re4_sel? unit2d_vsize_cnt_3 : 3'd0;
assign unit2d_vsize4_4 = mem_re4_sel? unit2d_vsize_cnt_4 : 3'd0;
assign unit2d_vsize4_5 = mem_re4_sel? unit2d_vsize_cnt_5 : 3'd0;
assign unit2d_vsize4_6 = mem_re4_sel? unit2d_vsize_cnt_6 : 3'd0;
assign unit2d_vsize4_7 = mem_re4_sel? unit2d_vsize_cnt_7 : 3'd0;

assign unit2d_vsize_0 = unit2d_vsize1_0 | unit2d_vsize2_0 | unit2d_vsize3_0 | unit2d_vsize4_0;
assign unit2d_vsize_1 = unit2d_vsize1_1 | unit2d_vsize2_1 | unit2d_vsize3_1 | unit2d_vsize4_1;
assign unit2d_vsize_2 = unit2d_vsize1_2 | unit2d_vsize2_2 | unit2d_vsize3_2 | unit2d_vsize4_2;
assign unit2d_vsize_3 = unit2d_vsize1_3 | unit2d_vsize2_3 | unit2d_vsize3_3 | unit2d_vsize4_3;
assign unit2d_vsize_4 = unit2d_vsize1_4 | unit2d_vsize2_4 | unit2d_vsize3_4 | unit2d_vsize4_4;
assign unit2d_vsize_5 = unit2d_vsize1_5 | unit2d_vsize2_5 | unit2d_vsize3_5 | unit2d_vsize4_5;
assign unit2d_vsize_6 = unit2d_vsize1_6 | unit2d_vsize2_6 | unit2d_vsize3_6 | unit2d_vsize4_6;
assign unit2d_vsize_7 = unit2d_vsize1_7 | unit2d_vsize2_7 | unit2d_vsize3_7 | unit2d_vsize4_7;
                                
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_vsize_cnt_0_d <= {3{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    unit2d_vsize_cnt_0_d <= unit2d_vsize_0;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    unit2d_vsize_cnt_0_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    unit2d_vsize_cnt_1_d <= {3{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    unit2d_vsize_cnt_1_d <= unit2d_vsize_1;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    unit2d_vsize_cnt_1_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    unit2d_vsize_cnt_2_d <= {3{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    unit2d_vsize_cnt_2_d <= unit2d_vsize_2;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    unit2d_vsize_cnt_2_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    unit2d_vsize_cnt_3_d <= {3{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    unit2d_vsize_cnt_3_d <= unit2d_vsize_3;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    unit2d_vsize_cnt_3_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    unit2d_vsize_cnt_4_d <= {3{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    unit2d_vsize_cnt_4_d <= unit2d_vsize_4;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    unit2d_vsize_cnt_4_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    unit2d_vsize_cnt_5_d <= {3{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    unit2d_vsize_cnt_5_d <= unit2d_vsize_5;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    unit2d_vsize_cnt_5_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    unit2d_vsize_cnt_6_d <= {3{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    unit2d_vsize_cnt_6_d <= unit2d_vsize_6;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    unit2d_vsize_cnt_6_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    unit2d_vsize_cnt_7_d <= {3{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    unit2d_vsize_cnt_7_d <= unit2d_vsize_7;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    unit2d_vsize_cnt_7_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//============================================================

assign active_last_line = (strip_ycnt_psize == pooling_size_v_cfg) | last_line_in;
//============================================================
//memory bank read/write controller
//
//------------------------------------------------------------
//memory read
//mem bank0 enable
//

//memory first read
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[0] <= 1'b0;
  end else begin
  unit2d_mem_1strd[0] <= unit2d_set[0] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[0]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[1] <= 1'b0;
  end else begin
  unit2d_mem_1strd[1] <= unit2d_set[1] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[1]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[2] <= 1'b0;
  end else begin
  unit2d_mem_1strd[2] <= unit2d_set[2] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[2]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[3] <= 1'b0;
  end else begin
  unit2d_mem_1strd[3] <= unit2d_set[3] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[3]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[4] <= 1'b0;
  end else begin
  unit2d_mem_1strd[4] <= unit2d_set[4] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[4]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[5] <= 1'b0;
  end else begin
  unit2d_mem_1strd[5] <= unit2d_set[5] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[5]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[6] <= 1'b0;
  end else begin
  unit2d_mem_1strd[6] <= unit2d_set[6] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[6]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[7] <= 1'b0;
  end else begin
  unit2d_mem_1strd[7] <= unit2d_set[7] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[7]);
  end
end
 
//line buffer number 1
assign mem_re1[0] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re1_sel;
assign mem_re1[1] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re1_sel;
assign mem_re1[2] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd2) & mem_re1_sel;
assign mem_re1[3] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd3) & mem_re1_sel;
assign mem_re1[4] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd4) & mem_re1_sel;
assign mem_re1[5] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd5) & mem_re1_sel;
assign mem_re1[6] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd6) & mem_re1_sel;
assign mem_re1[7] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd7) & mem_re1_sel;
assign mem_re1_1st[0] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[1] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[2] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[3] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[4] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[5] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[6] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[7] =  unit2d_mem_1strd[0] & mem_re1_sel;

//line buffer number 2
//4 bank read enable
//mem_read
assign mem_re2[0] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re2_sel;
assign mem_re2[1] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re2_sel; 
assign mem_re2[2] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd2) & mem_re2_sel;
assign mem_re2[3] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd3) & mem_re2_sel;
assign mem_re2[4] = unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re2_sel;
assign mem_re2[5] = unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re2_sel;
assign mem_re2[6] = unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd2) & mem_re2_sel;
assign mem_re2[7] = unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd3) & mem_re2_sel;
assign mem_re2_1st[0] =  unit2d_mem_1strd[0] & mem_re2_sel;
assign mem_re2_1st[1] =  unit2d_mem_1strd[0] & mem_re2_sel;
assign mem_re2_1st[2] =  unit2d_mem_1strd[0] & mem_re2_sel;
assign mem_re2_1st[3] =  unit2d_mem_1strd[0] & mem_re2_sel;
assign mem_re2_1st[4] =  unit2d_mem_1strd[1] & mem_re2_sel;
assign mem_re2_1st[5] =  unit2d_mem_1strd[1] & mem_re2_sel;
assign mem_re2_1st[6] =  unit2d_mem_1strd[1] & mem_re2_sel;
assign mem_re2_1st[7] =  unit2d_mem_1strd[1] & mem_re2_sel;

//line buffer number 3 4
assign mem_re3[0] =  unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel;
assign mem_re3[1] =  unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel;
assign mem_re3[2] =  unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel;
assign mem_re3[3] =  unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel;
assign mem_re3[4] =  unit2d_en[2] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel;
assign mem_re3[5] =  unit2d_en[2] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel;
assign mem_re3[6] =  unit2d_en[3] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel;
assign mem_re3[7] =  unit2d_en[3] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel;
assign mem_re3_1st[0] =  unit2d_mem_1strd[0] & mem_re3_sel;
assign mem_re3_1st[1] =  unit2d_mem_1strd[0] & mem_re3_sel;
assign mem_re3_1st[2] =  unit2d_mem_1strd[1] & mem_re3_sel;
assign mem_re3_1st[3] =  unit2d_mem_1strd[1] & mem_re3_sel;
assign mem_re3_1st[4] =  unit2d_mem_1strd[2] & mem_re3_sel;
assign mem_re3_1st[5] =  unit2d_mem_1strd[2] & mem_re3_sel;
assign mem_re3_1st[6] =  unit2d_mem_1strd[3] & mem_re3_sel;
assign mem_re3_1st[7] =  unit2d_mem_1strd[3] & mem_re3_sel;

//line buffer 5 6 7 8
assign mem_re4[0] =  unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[1] =  unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[2] =  unit2d_en[2] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[3] =  unit2d_en[3] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[4] =  unit2d_en[4] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[5] =  unit2d_en[5] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[6] =  unit2d_en[6] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[7] =  unit2d_en[7] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4_1st[0] =  unit2d_mem_1strd[0] & mem_re4_sel;
assign mem_re4_1st[1] =  unit2d_mem_1strd[1] & mem_re4_sel;
assign mem_re4_1st[2] =  unit2d_mem_1strd[2] & mem_re4_sel;
assign mem_re4_1st[3] =  unit2d_mem_1strd[3] & mem_re4_sel;
assign mem_re4_1st[4] =  unit2d_mem_1strd[4] & mem_re4_sel;
assign mem_re4_1st[5] =  unit2d_mem_1strd[5] & mem_re4_sel;
assign mem_re4_1st[6] =  unit2d_mem_1strd[6] & mem_re4_sel;
assign mem_re4_1st[7] =  unit2d_mem_1strd[7] & mem_re4_sel;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_re1_sel <= 1'b0;
    mem_re2_sel <= 1'b0;
    mem_re3_sel <= 1'b0;
    mem_re4_sel <= 1'b0;
  end else begin
 mem_re1_sel  <= (buffer_lines_num==4'd1);
 mem_re2_sel  <= (buffer_lines_num==4'd2);
 mem_re3_sel  <= (buffer_lines_num==4'd3) | (buffer_lines_num==4'd4);
 mem_re4_sel  <= (buffer_lines_num >=4'd5);
  end
end

///////////////////////////
//shouldn't read data from mem for the first pooling line
///////////////////////////
assign mem_re       = mem_re1 |  mem_re2 | mem_re3 | mem_re4;
assign mem_re_1st   = mem_re1_1st | mem_re2_1st | mem_re3_1st | mem_re4_1st;
assign mem_raddr    = sub_lbuf_dout_cnt;

//line buffer counter
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_sub_lbuf_cnt[2:0] <= {3{1'b0}};
  end else begin
    if(wr_line_dat_done | last_sub_lbuf_done | line_end)
          wr_sub_lbuf_cnt[2:0] <= 3'd0;
    else if(sub_lbuf_dout_done)
          wr_sub_lbuf_cnt[2:0] <= wr_sub_lbuf_cnt + 1;
  end
end
assign last_sub_lbuf_done = ((bank_merge_num-1) =={2'd0,wr_sub_lbuf_cnt}) & sub_lbuf_dout_done;
//--------------------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_lbuf_dout_cnt[5:0] <= {6{1'b0}};
  end else begin
    if(sub_lbuf_dout_done | wr_line_dat_done | line_end)
          sub_lbuf_dout_cnt[5:0] <= 6'd0;
    //else if(load_din | (cur_datin_disable & pooling1d_norm_rdy))
    else if(load_din | (cur_datin_disable & one_width_norm_rdy))
          sub_lbuf_dout_cnt[5:0] <= sub_lbuf_dout_cnt+ 6'd1;
  end
end
//assign sub_lbuf_dout_done  = (sub_lbuf_dout_cnt==6'd63) & (load_din | cur_datin_disable);
assign sub_lbuf_dout_done  = (sub_lbuf_dout_cnt==6'd63) & (load_din | (cur_datin_disable & one_width_norm_rdy));
//==============================================================================================
//buffer the data from memory  and from UNIT1D
//
//----------------------------------------------------------------------------------------------
 //=========================================================
 //POOLING FUNCTION DEFINITION
 //
 //---- -----------------------------------------------------

function[27:0] pooling_MIN; 
   input       reg2dp_int8_en;
   input       reg2dp_int16_en;
   input       reg2dp_fp16_en;
   input        data0_valid;
   input[27:0]  data0;
   input[27:0]  data1;
   reg[13:0]  data0_lsb;
   reg[13:0]  data0_msb;
   reg[13:0]  data1_lsb;
   reg[13:0]  data1_msb;
   reg[27:0]  int16_data0;
   reg[27:0]  int16_data1;
   reg[27:0]  fp16_data0;
   reg[27:0]  fp16_data1;
   reg[27:0]  min_16int;
   reg[27:0]  min_fp16;
   reg[13:0]  min_8int_lsb;
   reg[13:0]  min_8int_msb;
   reg        min_8int_lsb_ff;
   reg        min_8int_msb_ff;
   reg        min_16int_ff;
  begin
      {data0_msb,data0_lsb} = reg2dp_int8_en ? data0 : 0;
      {data1_msb,data1_lsb} = reg2dp_int8_en ? data1 : 0;
      int16_data0 = reg2dp_int16_en ? data0 : 0;
      int16_data1 = reg2dp_int16_en ? data1 : 0;
      fp16_data0 = reg2dp_fp16_en ? data0 : 0;
      fp16_data1 = reg2dp_fp16_en ? data1 : 0;

      min_8int_lsb_ff = ($signed(data1_lsb)> $signed(data0_lsb));
      min_8int_msb_ff = ($signed(data1_msb)> $signed(data0_msb));
      min_16int_ff    = ($signed(int16_data1)>  $signed(int16_data0)) ;
      
      min_8int_lsb = (min_8int_lsb_ff & data0_valid) ? data0_lsb : data1_lsb;
      min_8int_msb = (min_8int_msb_ff & data0_valid) ? data0_msb : data1_msb;
      min_16int    = (min_16int_ff    & data0_valid) ? int16_data0 : int16_data1;
      min_fp16     = ((~fp16_data0[15]) & (~fp16_data1[15]))? ((fp16_data0[14:0]>fp16_data1[14:0])? fp16_data1 : fp16_data0) : 
                     (((fp16_data0[15]) & ( fp16_data1[15]))?  ((fp16_data0[14:0]>fp16_data1[14:0])? fp16_data0 : fp16_data1) : 
                     (((fp16_data0[15]) & (~fp16_data1[15]))?  fp16_data0 : fp16_data1));

      pooling_MIN  = reg2dp_fp16_en ? min_fp16 : 
                    (reg2dp_int16_en ? min_16int : {min_8int_msb,min_8int_lsb});
  end
 endfunction

 function[27:0] pooling_MAX; 
   input       reg2dp_int8_en;
   input       reg2dp_int16_en;
   input       reg2dp_fp16_en;
   input        data0_valid;
   input[27:0]  data0;
   input[27:0]  data1;
   reg[13:0]  data0_lsb;
   reg[13:0]  data0_msb;
   reg[13:0]  data1_lsb;
   reg[13:0]  data1_msb;
   reg[27:0]  int16_data0;
   reg[27:0]  int16_data1;
   reg[27:0]  fp16_data0;
   reg[27:0]  fp16_data1;
   reg[27:0]  max_16int;
   reg[27:0]  max_fp16;
   reg[13:0]  max_8int_lsb;
   reg[13:0]  max_8int_msb;
   reg        max_8int_lsb_ff;
   reg        max_8int_msb_ff;
   reg        max_16int_ff;
   begin
      {data0_msb,data0_lsb} = reg2dp_int8_en ? data0 : 0;
      {data1_msb,data1_lsb} = reg2dp_int8_en ? data1 : 0;
      int16_data0 = reg2dp_int16_en ? data0 : 0;
      int16_data1 = reg2dp_int16_en ? data1 : 0;
      fp16_data0 = reg2dp_fp16_en ? data0 : 0;
      fp16_data1 = reg2dp_fp16_en ? data1 : 0;

      max_8int_lsb_ff = ($signed(data0_lsb)> $signed(data1_lsb));
      max_8int_msb_ff = ($signed(data0_msb)> $signed(data1_msb));
      max_16int_ff    = ($signed(int16_data0)>  $signed(int16_data1))       ;
      
      max_8int_lsb = (max_8int_lsb_ff & data0_valid) ? data0_lsb : data1_lsb;
      max_8int_msb = (max_8int_msb_ff & data0_valid) ? data0_msb : data1_msb;
      max_16int    = (max_16int_ff    & data0_valid) ? int16_data0 : int16_data1;
      max_fp16     = ((~fp16_data0[15]) & (~fp16_data1[15]))? ((fp16_data0[14:0]>fp16_data1[14:0])? fp16_data0 : fp16_data1) : 
                     (((fp16_data0[15]) & (fp16_data1[15]))?  ((fp16_data0[14:0]>fp16_data1[14:0])? fp16_data1 : fp16_data0) : 
                     (((fp16_data0[15]) & (~fp16_data1[15]))?  fp16_data1 : fp16_data0));
      pooling_MAX  = reg2dp_fp16_en ? max_fp16 : 
                    (reg2dp_int16_en ? max_16int : {max_8int_msb,max_8int_lsb});
  end
 endfunction

 function[27:0] pooling_SUM; 
   input       reg2dp_int8_en;
   input       reg2dp_int16_en;
   input        data0_valid;
   input[27:0]  data0;
   input[27:0]  data1;
   reg[13:0]  data0_lsb;
   reg[13:0]  data0_msb;
   reg[13:0]  data1_lsb;
   reg[13:0]  data1_msb;
   reg[27:0]  int16_data0;
   reg[27:0]  int16_data1;
   reg[27:0]  sum_16int;
   reg[13:0]  sum_8int_lsb;
   reg[13:0]  sum_8int_msb;
   reg[13:0]  sum_8int_lsb_ff;
   reg[13:0]  sum_8int_msb_ff;
   reg[27:0]  sum_16int_ff;
   begin
      {data0_msb,data0_lsb} = (reg2dp_int8_en & data0_valid) ? data0 : 0;
      {data1_msb,data1_lsb} = (reg2dp_int8_en & data0_valid) ? data1 : 0;
      int16_data0 = (reg2dp_int16_en & data0_valid) ? data0 : 0;
      int16_data1 = (reg2dp_int16_en & data0_valid) ? data1 : 0;
      //spyglass disable_block W484
      sum_8int_lsb_ff[13:0] =  ($signed(data1_lsb) + $signed(data0_lsb));
      sum_8int_msb_ff[13:0] =  ($signed(data1_msb) + $signed(data0_msb));
      sum_16int_ff[27:0]    =  ($signed(int16_data1) + $signed(int16_data0))        ; 
      //spyglass enable_block W484
      
      sum_8int_lsb =   sum_8int_lsb_ff ;
      sum_8int_msb =   sum_8int_msb_ff ;
      sum_16int    =   sum_16int_ff    ; 
      pooling_SUM  = reg2dp_int16_en ? sum_16int : {sum_8int_msb,sum_8int_lsb};
  end
 endfunction

 //pooling result
function[111:0] pooling_fun;
  input       reg2dp_int8_en;
  input       reg2dp_int16_en;
  input       reg2dp_fp16_en;
  input[1:0]  pooling_type;
  input       data0_valid;
  input[111:0] data0_in;
  input[111:0] data1_in;
  reg    min_pooling;
  reg    max_pooling;
  reg    mean_pooling;
  reg  [3:0] din0_is_nan;
  reg  [3:0] din1_is_nan;
  reg  [3:0] nan_in;
  begin
     min_pooling = (pooling_type== 2'h2 );
     max_pooling = (pooling_type== 2'h1 );
     mean_pooling = (pooling_type== 2'h0 );
     din0_is_nan[0] = &data0_in[14:10] & (|data0_in[9:0]);
     din1_is_nan[0] = &data1_in[14:10] & (|data1_in[9:0]);
     din0_is_nan[1] = &data0_in[42:38] & (|data0_in[37:28]);
     din1_is_nan[1] = &data1_in[42:38] & (|data1_in[37:28]);
     din0_is_nan[2] = &data0_in[70:66] & (|data0_in[65:56]);
     din1_is_nan[2] = &data1_in[70:66] & (|data1_in[65:56]);
     din0_is_nan[3] = &data0_in[98:94] & (|data0_in[93:84]);
     din1_is_nan[3] = &data1_in[98:94] & (|data1_in[93:84]);
     nan_in = din0_is_nan | din1_is_nan;
     pooling_fun[27:0]  = mean_pooling? pooling_SUM(reg2dp_int8_en,reg2dp_int16_en,data0_valid,data0_in[27:0],data1_in[27:0]) :
         min_pooling ? (((~reg2dp_fp16_en)| (~nan_in[0] & reg2dp_fp16_en))? pooling_MIN (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_valid,data0_in[27:0],data1_in[27:0]) : (din0_is_nan[0]? data0_in[27:0] : data1_in[27:0])) :
         max_pooling ? (((~reg2dp_fp16_en)| (~nan_in[0] & reg2dp_fp16_en))? pooling_MAX (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_valid,data0_in[27:0],data1_in[27:0]) : (din0_is_nan[0]? data0_in[27:0] : data1_in[27:0])) : 0;
      
     pooling_fun[55:28] = mean_pooling? pooling_SUM(reg2dp_int8_en,reg2dp_int16_en,data0_valid,data0_in[55:28],data1_in[55:28]) :
         min_pooling ? (((~reg2dp_fp16_en)| (~nan_in[1] & reg2dp_fp16_en))? pooling_MIN (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_valid,data0_in[55:28],data1_in[55:28]) : (din0_is_nan[1]? data0_in[55:28] : data1_in[55:28])):
         max_pooling ? (((~reg2dp_fp16_en)| (~nan_in[1] & reg2dp_fp16_en))? pooling_MAX (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_valid,data0_in[55:28],data1_in[55:28]) : (din0_is_nan[1]? data0_in[55:28] : data1_in[55:28])): 0;
      
     pooling_fun[83:56] = mean_pooling? pooling_SUM(reg2dp_int8_en,reg2dp_int16_en,data0_valid,data0_in[83:56],data1_in[83:56]) :
         min_pooling ? (((~reg2dp_fp16_en)| (~nan_in[2] & reg2dp_fp16_en))? pooling_MIN (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_valid,data0_in[83:56],data1_in[83:56]) : (din0_is_nan[2]? data0_in[83:56] : data1_in[83:56])) :
         max_pooling ? (((~reg2dp_fp16_en)| (~nan_in[2] & reg2dp_fp16_en))? pooling_MAX (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_valid,data0_in[83:56],data1_in[83:56]) : (din0_is_nan[2]? data0_in[83:56] : data1_in[83:56])) : 0;
      
     pooling_fun[111:84]= mean_pooling? pooling_SUM(reg2dp_int8_en,reg2dp_int16_en,data0_valid,data0_in[111:84],data1_in[111:84]) : 
         min_pooling ? (((~reg2dp_fp16_en)| (~nan_in[3] & reg2dp_fp16_en))? pooling_MIN (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_valid,data0_in[111:84],data1_in[111:84]) : (din0_is_nan[3]? data0_in[111:84] : data1_in[111:84])) :
         max_pooling ? (((~reg2dp_fp16_en)| (~nan_in[3] & reg2dp_fp16_en))? pooling_MAX (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_valid,data0_in[111:84],data1_in[111:84]) : (din0_is_nan[3]? data0_in[111:84] : data1_in[111:84])) : 0;
  end
endfunction
 
 //write memory 
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_data0_lst[114:0] <= {115{1'b0}};
    mem_data1_lst[114:0] <= {115{1'b0}};
    mem_data2_lst[114:0] <= {115{1'b0}};
    mem_data3_lst[114:0] <= {115{1'b0}};
    mem_data4_lst[114:0] <= {115{1'b0}};
    mem_data5_lst[114:0] <= {115{1'b0}};
    mem_data6_lst[114:0] <= {115{1'b0}};
    mem_data7_lst[114:0] <= {115{1'b0}};
  end else begin
     if(flush_read_en_d & wr_data_stage0_prdy) begin
             mem_data0_lst[114:0] <= {mem_rdata_0[114:0]};
             mem_data1_lst[114:0] <= {mem_rdata_1[114:0]};
             mem_data2_lst[114:0] <= {mem_rdata_2[114:0]};
             mem_data3_lst[114:0] <= {mem_rdata_3[114:0]};
             mem_data4_lst[114:0] <= {mem_rdata_4[114:0]};
             mem_data5_lst[114:0] <= {mem_rdata_5[114:0]};
             mem_data6_lst[114:0] <= {mem_rdata_6[114:0]};
             mem_data7_lst[114:0] <= {mem_rdata_7[114:0]};
     end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_data0[114:0] <= {115{1'b0}};
    mem_data1[114:0] <= {115{1'b0}};
    mem_data2[114:0] <= {115{1'b0}};
    mem_data3[114:0] <= {115{1'b0}};
    mem_data4[114:0] <= {115{1'b0}};
    mem_data5[114:0] <= {115{1'b0}};
    mem_data6[114:0] <= {115{1'b0}};
    mem_data7[114:0] <= {115{1'b0}};
  end else begin
     if(load_wr_stage1) begin//one cycle delay than pooling1d input
             mem_data0[114:0] <= mem_re_1st_d[0]? {unit2d_vsize_cnt_0_d, datin_buf}: { unit2d_vsize_cnt_0_d,mem_rdata_0[111:0]};
             mem_data1[114:0] <= mem_re_1st_d[1]? {unit2d_vsize_cnt_1_d, datin_buf}: { unit2d_vsize_cnt_1_d,mem_rdata_1[111:0]};
             mem_data2[114:0] <= mem_re_1st_d[2]? {unit2d_vsize_cnt_2_d, datin_buf}: { unit2d_vsize_cnt_2_d,mem_rdata_2[111:0]};
             mem_data3[114:0] <= mem_re_1st_d[3]? {unit2d_vsize_cnt_3_d, datin_buf}: { unit2d_vsize_cnt_3_d,mem_rdata_3[111:0]};
             mem_data4[114:0] <= mem_re_1st_d[4]? {unit2d_vsize_cnt_4_d, datin_buf}: { unit2d_vsize_cnt_4_d,mem_rdata_4[111:0]};
             mem_data5[114:0] <= mem_re_1st_d[5]? {unit2d_vsize_cnt_5_d, datin_buf}: { unit2d_vsize_cnt_5_d,mem_rdata_5[111:0]};
             mem_data6[114:0] <= mem_re_1st_d[6]? {unit2d_vsize_cnt_6_d, datin_buf}: { unit2d_vsize_cnt_6_d,mem_rdata_6[111:0]};
             mem_data7[114:0] <= mem_re_1st_d[7]? {unit2d_vsize_cnt_7_d, datin_buf}: { unit2d_vsize_cnt_7_d,mem_rdata_7[111:0]};
     end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datin_buf_2d <= {112{1'b0}};
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    datin_buf_2d <= datin_buf;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    datin_buf_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wr_line_end_2d <= 1'b0;
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    wr_line_end_2d <= wr_line_end_buf;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    wr_line_end_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mem_raddr_2d <= {6{1'b0}};
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    mem_raddr_2d <= mem_raddr_d;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    mem_raddr_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wr_surface_dat_done_2d <= 1'b0;
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    wr_surface_dat_done_2d <= wr_surface_dat_done_buf;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    wr_surface_dat_done_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_active_line_d <= 1'b0;
  end else begin
  if ((load_din) == 1'b1) begin
    last_active_line_d <= active_last_line;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    last_active_line_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_active_line_2d <= 1'b0;
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    last_active_line_2d <= last_active_line_d;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    last_active_line_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mem_re_1st_d <= {8{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    mem_re_1st_d <= mem_re_1st;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    mem_re_1st_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mem_re_1st_2d <= {8{1'b0}};
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    mem_re_1st_2d <= mem_re_1st_d;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    mem_re_1st_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mem_raddr_d <= {6{1'b0}};
  end else begin
  if (((|mem_re) | (flush_read_en & one_width_norm_rdy)) == 1'b1) begin
    mem_raddr_d <= mem_raddr;
  // VCS coverage off
  end else if (((|mem_re) | (flush_read_en & one_width_norm_rdy)) == 1'b0) begin
  end else begin
    mem_raddr_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((|mem_re) | (flush_read_en & one_width_norm_rdy)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//=========================== 
//8bits mem_re two cycle delay
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_re_d <= {8{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    mem_re_d <= mem_re;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    mem_re_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mem_re_2d <= {8{1'b0}};
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    mem_re_2d <= mem_re_d;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    mem_re_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//write stage0
assign pooling1d_norm_rdy = ~wr_data_stage0_vld | wr_data_stage0_prdy;
//rebuild valid signal with cur_datin_disable control
//assign pooling1d_vld_rebuild = cur_datin_disable ? 1'b1 : pooling1d_pvld_use;
assign pooling1d_vld_rebuild = (one_width_disable | cur_datin_disable) ? 1'b1 : pooling1d_pvld_use;
assign load_din_all     = pooling1d_norm_rdy & pooling1d_vld_rebuild; 
//pipe delay
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_data_stage0_vld <= 1'b0;
  end else begin
    //if(|mem_re) 
    if(pooling1d_vld_rebuild) 
        wr_data_stage0_vld <= 1'b1;
    else if(wr_data_stage0_prdy)
        wr_data_stage0_vld <= 1'b0;
  end
end

assign wr_data_stage0_prdy = ~wr_data_stage1_vld | wr_data_stage1_prdy;
//write  stage1
assign load_wr_stage1_all = wr_data_stage0_vld & wr_data_stage0_prdy;
//assign load_wr_stage1 = wr_data_stage0_vld & wr_data_stage0_prdy & (~cur_datin_disable_d);
assign load_wr_stage1 = wr_data_stage0_vld & wr_data_stage0_prdy & (~cur_datin_disable_d) & (~one_width_disable_d);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_data_stage1_vld <= 1'b0;
  end else begin
     if(wr_data_stage0_vld)
           wr_data_stage1_vld <= 1'b1;
     else if(wr_data_stage1_prdy)
           wr_data_stage1_vld <= 1'b0;
  end
end

//write stage2
assign load_wr_stage2_all   = wr_data_stage1_vld & wr_data_stage1_prdy;
assign load_wr_stage2   = wr_data_stage1_vld & wr_data_stage1_prdy & (~cur_datin_disable_2d) & (~one_width_disable_2d);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_data_stage2_vld <= 1'b0;
  end else begin
    //if(wr_data_stage1_vld)
    if(wr_data_stage1_vld & (~fp16_mean_pool_cfg))
        wr_data_stage2_vld <= 1'b1;
    else if(pout_data_stage0_prdy)
        wr_data_stage2_vld <= 1'b0;
  end
end
assign load_wr_stage3_all = wr_data_stage2_vld & pout_data_stage0_prdy;
assign load_wr_stage3 = wr_data_stage2_vld & pout_data_stage0_prdy & (~cur_datin_disable_3d) & (~one_width_disable_3d);
//====================================================================
// pooling data calculation and write back
//
//--------------------------------------------------------------------
assign pooling_datin = datin_buf_2d[111:0];
//read from memory
assign  mem_data_valid = load_wr_stage2 ? mem_re_2d : 8'h00;
//assign pooling_2d_result_0  =  mem_re_1st_2d[0] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[0],mem_data0[111:0],pooling_datin);
//assign pooling_2d_result_1  =  mem_re_1st_2d[1] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[1],mem_data1[111:0],pooling_datin);
//assign pooling_2d_result_2  =  mem_re_1st_2d[2] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[2],mem_data2[111:0],pooling_datin);
//assign pooling_2d_result_3  =  mem_re_1st_2d[3] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[3],mem_data3[111:0],pooling_datin);
//assign pooling_2d_result_4  =  mem_re_1st_2d[4] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[4],mem_data4[111:0],pooling_datin);
//assign pooling_2d_result_5  =  mem_re_1st_2d[5] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[5],mem_data5[111:0],pooling_datin);
//assign pooling_2d_result_6  =  mem_re_1st_2d[6] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[6],mem_data6[111:0],pooling_datin);
//assign pooling_2d_result_7  =  mem_re_1st_2d[7] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[7],mem_data7[111:0],pooling_datin);
assign pooling_2d_result_0  =  mem_re_1st_2d[0] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[0]/*,mem_data0[111:0]*/,pooling_datin,mem_data0[111:0]);
assign pooling_2d_result_1  =  mem_re_1st_2d[1] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[1]/*,mem_data1[111:0]*/,pooling_datin,mem_data1[111:0]);
assign pooling_2d_result_2  =  mem_re_1st_2d[2] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[2]/*,mem_data2[111:0]*/,pooling_datin,mem_data2[111:0]);
assign pooling_2d_result_3  =  mem_re_1st_2d[3] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[3]/*,mem_data3[111:0]*/,pooling_datin,mem_data3[111:0]);
assign pooling_2d_result_4  =  mem_re_1st_2d[4] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[4]/*,mem_data4[111:0]*/,pooling_datin,mem_data4[111:0]);
assign pooling_2d_result_5  =  mem_re_1st_2d[5] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[5]/*,mem_data5[111:0]*/,pooling_datin,mem_data5[111:0]);
assign pooling_2d_result_6  =  mem_re_1st_2d[6] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[6]/*,mem_data6[111:0]*/,pooling_datin,mem_data6[111:0]);
assign pooling_2d_result_7  =  mem_re_1st_2d[7] ? pooling_datin : pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],mem_data_valid[7]/*,mem_data7[111:0]*/,pooling_datin,mem_data7[111:0]);
assign pooling_2d_info_0    =  {wr_line_end_2d,mem_data0[114:112]};
assign pooling_2d_info_1    =  {wr_line_end_2d,mem_data1[114:112]};
assign pooling_2d_info_2    =  {wr_line_end_2d,mem_data2[114:112]}; 
assign pooling_2d_info_3    =  {wr_line_end_2d,mem_data3[114:112]};
assign pooling_2d_info_4    =  {wr_line_end_2d,mem_data4[114:112]};
assign pooling_2d_info_5    =  {wr_line_end_2d,mem_data5[114:112]};
assign pooling_2d_info_6    =  {wr_line_end_2d,mem_data6[114:112]};
assign pooling_2d_info_7    =  {wr_line_end_2d,mem_data7[114:112]};

//memory write data
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_mem_wdata_0 <= {116{1'b0}};
    int_mem_wdata_1 <= {116{1'b0}};
    int_mem_wdata_2 <= {116{1'b0}};
    int_mem_wdata_3 <= {116{1'b0}};
    int_mem_wdata_4 <= {116{1'b0}};
    int_mem_wdata_5 <= {116{1'b0}};
    int_mem_wdata_6 <= {116{1'b0}};
    int_mem_wdata_7 <= {116{1'b0}};
  end else begin
    if(load_wr_stage2) begin
       int_mem_wdata_0 <= {pooling_2d_info_0,pooling_2d_result_0};
       int_mem_wdata_1 <= {pooling_2d_info_1,pooling_2d_result_1};
       int_mem_wdata_2 <= {pooling_2d_info_2,pooling_2d_result_2};
       int_mem_wdata_3 <= {pooling_2d_info_3,pooling_2d_result_3};
       int_mem_wdata_4 <= {pooling_2d_info_4,pooling_2d_result_4};
       int_mem_wdata_5 <= {pooling_2d_info_5,pooling_2d_result_5};
       int_mem_wdata_6 <= {pooling_2d_info_6,pooling_2d_result_6};
       int_mem_wdata_7 <= {pooling_2d_info_7,pooling_2d_result_7};
     end
  end
end

//write enabel signal
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_mem_we <= {8{1'b0}};
  end else begin
  if ((load_wr_stage2) == 1'b1) begin
    int_mem_we <= mem_re_2d;
  // VCS coverage off
  end else if ((load_wr_stage2) == 1'b0) begin
  end else begin
    int_mem_we <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    int_mem_waddr <= {6{1'b0}};
  end else begin
  if ((load_wr_stage2) == 1'b1) begin
    int_mem_waddr <= mem_raddr_2d;
  // VCS coverage off
  end else if ((load_wr_stage2) == 1'b0) begin
  end else begin
    int_mem_waddr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign fp16_mean_pool_cfg = (fp16_en & average_pooling_en);

//memory write select 
assign mem_wdata_0 = (fp16_mean_pool_cfg)? fp_mem0_wdata : int_mem_wdata_0;
assign mem_wdata_1 = (fp16_mean_pool_cfg)? fp_mem1_wdata : int_mem_wdata_1;
assign mem_wdata_2 = (fp16_mean_pool_cfg)? fp_mem2_wdata : int_mem_wdata_2;
assign mem_wdata_3 = (fp16_mean_pool_cfg)? fp_mem3_wdata : int_mem_wdata_3;
assign mem_wdata_4 = (fp16_mean_pool_cfg)? fp_mem4_wdata : int_mem_wdata_4;
assign mem_wdata_5 = (fp16_mean_pool_cfg)? fp_mem5_wdata : int_mem_wdata_5;
assign mem_wdata_6 = (fp16_mean_pool_cfg)? fp_mem6_wdata : int_mem_wdata_6;
assign mem_wdata_7 = (fp16_mean_pool_cfg)? fp_mem7_wdata : int_mem_wdata_7;
assign mem_we      = (fp16_mean_pool_cfg)? fp_mem_we : (int_mem_we & {8{load_wr_stage3}});
assign mem_waddr_0 = (fp16_mean_pool_cfg)? fp_mem0_waddr : int_mem_waddr;
assign mem_waddr_1 = (fp16_mean_pool_cfg)? fp_mem1_waddr : int_mem_waddr;
assign mem_waddr_2 = (fp16_mean_pool_cfg)? fp_mem2_waddr : int_mem_waddr;
assign mem_waddr_3 = (fp16_mean_pool_cfg)? fp_mem3_waddr : int_mem_waddr;
assign mem_waddr_4 = (fp16_mean_pool_cfg)? fp_mem4_waddr : int_mem_waddr;
assign mem_waddr_5 = (fp16_mean_pool_cfg)? fp_mem5_waddr : int_mem_waddr;
assign mem_waddr_6 = (fp16_mean_pool_cfg)? fp_mem6_waddr : int_mem_waddr;
assign mem_waddr_7 = (fp16_mean_pool_cfg)? fp_mem7_waddr : int_mem_waddr;

//=============================================================================
//memory line buffer instance
// 
//-----------------------------------------------------------------------------
nv_ram_rws_64x116 bank0_uram_0 (
   .clk                         (nvdla_core_clk)                    //|< i
  ,.ra                          (mem_raddr[5:0])                    //|< w
  ,.re                          (mem_re[0] | mem_re_last[0])        //|< ?
  ,.dout                        (mem_rdata_0[115:0])                //|> w
  ,.wa                          (mem_waddr_0[5:0])                  //|< w
  ,.we                          (mem_we[0])                         //|< w
  ,.di                          (mem_wdata_0[115:0])                //|< w
  ,.pwrbus_ram_pd               (pwrbus_ram_pd[31:0])               //|< i
  );



nv_ram_rws_64x116 bank1_uram_0 (
   .clk                         (nvdla_core_clk)                    //|< i
  ,.ra                          (mem_raddr[5:0])                    //|< w
  ,.re                          (mem_re[1] | mem_re_last[1])        //|< ?
  ,.dout                        (mem_rdata_1[115:0])                //|> w
  ,.wa                          (mem_waddr_1[5:0])                  //|< w
  ,.we                          (mem_we[1])                         //|< w
  ,.di                          (mem_wdata_1[115:0])                //|< w
  ,.pwrbus_ram_pd               (pwrbus_ram_pd[31:0])               //|< i
  );



nv_ram_rws_64x116 bank2_uram_0 (
   .clk                         (nvdla_core_clk)                    //|< i
  ,.ra                          (mem_raddr[5:0])                    //|< w
  ,.re                          (mem_re[2] | mem_re_last[2])        //|< ?
  ,.dout                        (mem_rdata_2[115:0])                //|> w
  ,.wa                          (mem_waddr_2[5:0])                  //|< w
  ,.we                          (mem_we[2])                         //|< w
  ,.di                          (mem_wdata_2[115:0])                //|< w
  ,.pwrbus_ram_pd               (pwrbus_ram_pd[31:0])               //|< i
  );



nv_ram_rws_64x116 bank3_uram_0 (
   .clk                         (nvdla_core_clk)                    //|< i
  ,.ra                          (mem_raddr[5:0])                    //|< w
  ,.re                          (mem_re[3] | mem_re_last[3])        //|< ?
  ,.dout                        (mem_rdata_3[115:0])                //|> w
  ,.wa                          (mem_waddr_3[5:0])                  //|< w
  ,.we                          (mem_we[3])                         //|< w
  ,.di                          (mem_wdata_3[115:0])                //|< w
  ,.pwrbus_ram_pd               (pwrbus_ram_pd[31:0])               //|< i
  );



nv_ram_rws_64x116 bank4_uram_0 (
   .clk                         (nvdla_core_clk)                    //|< i
  ,.ra                          (mem_raddr[5:0])                    //|< w
  ,.re                          (mem_re[4] | mem_re_last[4])        //|< ?
  ,.dout                        (mem_rdata_4[115:0])                //|> w
  ,.wa                          (mem_waddr_4[5:0])                  //|< w
  ,.we                          (mem_we[4])                         //|< w
  ,.di                          (mem_wdata_4[115:0])                //|< w
  ,.pwrbus_ram_pd               (pwrbus_ram_pd[31:0])               //|< i
  );



nv_ram_rws_64x116 bank5_uram_0 (
   .clk                         (nvdla_core_clk)                    //|< i
  ,.ra                          (mem_raddr[5:0])                    //|< w
  ,.re                          (mem_re[5] | mem_re_last[5])        //|< ?
  ,.dout                        (mem_rdata_5[115:0])                //|> w
  ,.wa                          (mem_waddr_5[5:0])                  //|< w
  ,.we                          (mem_we[5])                         //|< w
  ,.di                          (mem_wdata_5[115:0])                //|< w
  ,.pwrbus_ram_pd               (pwrbus_ram_pd[31:0])               //|< i
  );



nv_ram_rws_64x116 bank6_uram_0 (
   .clk                         (nvdla_core_clk)                    //|< i
  ,.ra                          (mem_raddr[5:0])                    //|< w
  ,.re                          (mem_re[6] | mem_re_last[6])        //|< ?
  ,.dout                        (mem_rdata_6[115:0])                //|> w
  ,.wa                          (mem_waddr_6[5:0])                  //|< w
  ,.we                          (mem_we[6])                         //|< w
  ,.di                          (mem_wdata_6[115:0])                //|< w
  ,.pwrbus_ram_pd               (pwrbus_ram_pd[31:0])               //|< i
  );



nv_ram_rws_64x116 bank7_uram_0 (
   .clk                         (nvdla_core_clk)                    //|< i
  ,.ra                          (mem_raddr[5:0])                    //|< w
  ,.re                          (mem_re[7] | mem_re_last[7])        //|< ?
  ,.dout                        (mem_rdata_7[115:0])                //|> w
  ,.wa                          (mem_waddr_7[5:0])                  //|< w
  ,.we                          (mem_we[7])                         //|< w
  ,.di                          (mem_wdata_7[115:0])                //|< w
  ,.pwrbus_ram_pd               (pwrbus_ram_pd[31:0])               //|< i
  );




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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram0 read and write same addr simultaneously")      zzz_assert_never_31x (nvdla_core_clk, `ASSERT_RESET, (mem_we[0] & ( mem_re[0] | mem_re_last[0])) & (mem_raddr == mem_waddr_0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram1 read and write same addr simultaneously")      zzz_assert_never_32x (nvdla_core_clk, `ASSERT_RESET, (mem_we[1] & ( mem_re[1] | mem_re_last[1])) & (mem_raddr == mem_waddr_1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram2 read and write same addr simultaneously")      zzz_assert_never_33x (nvdla_core_clk, `ASSERT_RESET, (mem_we[2] & ( mem_re[2] | mem_re_last[2])) & (mem_raddr == mem_waddr_2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram3 read and write same addr simultaneously")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (mem_we[3] & ( mem_re[3] | mem_re_last[3])) & (mem_raddr == mem_waddr_3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram4 read and write same addr simultaneously")      zzz_assert_never_35x (nvdla_core_clk, `ASSERT_RESET, (mem_we[4] & ( mem_re[4] | mem_re_last[4])) & (mem_raddr == mem_waddr_4)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram5 read and write same addr simultaneously")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (mem_we[5] & ( mem_re[5] | mem_re_last[5])) & (mem_raddr == mem_waddr_5)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram6 read and write same addr simultaneously")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (mem_we[6] & ( mem_re[6] | mem_re_last[6])) & (mem_raddr == mem_waddr_6)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram7 read and write same addr simultaneously")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (mem_we[7] & ( mem_re[7] | mem_re_last[7])) & (mem_raddr == mem_waddr_7)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============================================================================
//data reading control during datin_disable time
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//data reading from buffer for datin_disable bubble part and last_out during the next surface coming
//cur_datin_disable means bubble part, need disable input data prdy
//in the end of total layer, if have data need flushed, will also bubble input
//last_out_en flush the last lines during the next surface data coming
/////////////////////////////////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_cnt_pooling_last <= {3{1'b0}};
    mem_re2_sel_last <= 1'b0;
    mem_re3_sel_last <= 1'b0;
    mem_re4_sel_last <= 1'b0;
  end else begin
    if(wr_surface_dat_done) begin
        unit2d_cnt_pooling_last <= (unit2d_cnt_pooling == unit2d_cnt_pooling_max) ? 3'd0 : (unit2d_cnt_pooling + 1'b1);
        mem_re2_sel_last        <= mem_re2_sel;
        mem_re3_sel_last        <= mem_re3_sel;
        mem_re4_sel_last        <= mem_re4_sel;
    //end else if(((line_end & cur_datin_disable) | (wr_line_dat_done & last_out_en)) & pooling1d_norm_rdy) begin
    end else if(((line_end & cur_datin_disable) | (wr_line_dat_done & last_out_en)) & one_width_norm_rdy) begin
        if(unit2d_cnt_pooling_last_end)
            unit2d_cnt_pooling_last <= 3'd0;
        else
            unit2d_cnt_pooling_last <= unit2d_cnt_pooling_last + 1'b1;
    end
  end
end
assign unit2d_cnt_pooling_last_end = (unit2d_cnt_pooling_last == unit2d_cnt_pooling_max);

//assign flush_read_en = (cur_datin_disable | last_out_en);
//assign flush_read_en = (cur_datin_disable | last_out_en) & pooling1d_norm_rdy;
assign flush_read_en = (cur_datin_disable | last_out_en) & one_width_norm_rdy;

assign unit2d_en_last[0] = flush_read_en & (unit2d_cnt_pooling_last == 3'd0);
assign unit2d_en_last[1] = flush_read_en & (unit2d_cnt_pooling_last == 3'd1);
assign unit2d_en_last[2] = flush_read_en & (unit2d_cnt_pooling_last == 3'd2);
assign unit2d_en_last[3] = flush_read_en & (unit2d_cnt_pooling_last == 3'd3);
assign unit2d_en_last[4] = flush_read_en & (unit2d_cnt_pooling_last == 3'd4);
assign unit2d_en_last[5] = flush_read_en & (unit2d_cnt_pooling_last == 3'd5);
assign unit2d_en_last[6] = flush_read_en & (unit2d_cnt_pooling_last == 3'd6);
assign unit2d_en_last[7] = flush_read_en & (unit2d_cnt_pooling_last == 3'd7);

assign mem_re2_last[0] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd0) & mem_re2_sel_last;
assign mem_re2_last[1] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd1) & mem_re2_sel_last;
assign mem_re2_last[2] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd2) & mem_re2_sel_last;
assign mem_re2_last[3] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd3) & mem_re2_sel_last;
assign mem_re2_last[4] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd0) & mem_re2_sel_last;
assign mem_re2_last[5] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd1) & mem_re2_sel_last;
assign mem_re2_last[6] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd2) & mem_re2_sel_last;
assign mem_re2_last[7] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd3) & mem_re2_sel_last;

assign mem_re3_last[0] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel_last;
assign mem_re3_last[1] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel_last;
assign mem_re3_last[2] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel_last;
assign mem_re3_last[3] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel_last;
assign mem_re3_last[4] =  unit2d_en_last[2] & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel_last;
assign mem_re3_last[5] =  unit2d_en_last[2] & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel_last;
assign mem_re3_last[6] =  unit2d_en_last[3] & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel_last;
assign mem_re3_last[7] =  unit2d_en_last[3] & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel_last;

assign mem_re4_last[0] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[1] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[2] =  unit2d_en_last[2] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[3] =  unit2d_en_last[3] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[4] =  unit2d_en_last[4] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[5] =  unit2d_en_last[5] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[6] =  unit2d_en_last[6] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[7] =  unit2d_en_last[7] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;

assign mem_re_last = mem_re2_last | mem_re3_last | mem_re4_last;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    flush_read_en_d <= 1'b0;
  end else begin
  if (((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b1) begin
    flush_read_en_d <= flush_read_en;
  // VCS coverage off
  end else if (((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b0) begin
  end else begin
    flush_read_en_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy )))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mem_re_last_d <= {8{1'b0}};
  end else begin
  if (((load_din                 ) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b1) begin
    mem_re_last_d <= mem_re_last;
  // VCS coverage off
  end else if (((load_din                 ) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b0) begin
  end else begin
    mem_re_last_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((load_din                 ) | (cur_datin_disable & one_width_norm_rdy )))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    unit2d_cnt_pooling_last_d <= {3{1'b0}};
  end else begin
  if (((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b1) begin
    unit2d_cnt_pooling_last_d <= unit2d_cnt_pooling_last;
  // VCS coverage off
  end else if (((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b0) begin
  end else begin
    unit2d_cnt_pooling_last_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy )))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_datin_disable_d <= 1'b0;
  end else begin
  if ((load_din_all) == 1'b1) begin
    cur_datin_disable_d <= cur_datin_disable;
  // VCS coverage off
  end else if ((load_din_all) == 1'b0) begin
  end else begin
    cur_datin_disable_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    one_width_disable_d <= 1'b0;
  end else begin
  if ((load_din_all) == 1'b1) begin
    one_width_disable_d <= one_width_disable;
  // VCS coverage off
  end else if ((load_din_all) == 1'b0) begin
  end else begin
    one_width_disable_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mem_re_last_2d <= {8{1'b0}};
  end else begin
  if (( load_wr_stage1                  | (cur_datin_disable_d & wr_data_stage0_prdy)) == 1'b1) begin
    mem_re_last_2d <= mem_re_last_d;
  // VCS coverage off
  end else if (( load_wr_stage1                  | (cur_datin_disable_d & wr_data_stage0_prdy)) == 1'b0) begin
  end else begin
    mem_re_last_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_44x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^( load_wr_stage1                  | (cur_datin_disable_d & wr_data_stage0_prdy)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    unit2d_cnt_pooling_last_2d <= {3{1'b0}};
  end else begin
  if (((load_wr_stage1 & (|mem_re_last_d)) | (cur_datin_disable_d & wr_data_stage0_prdy)) == 1'b1) begin
    unit2d_cnt_pooling_last_2d <= unit2d_cnt_pooling_last_d;
  // VCS coverage off
  end else if (((load_wr_stage1 & (|mem_re_last_d)) | (cur_datin_disable_d & wr_data_stage0_prdy)) == 1'b0) begin
  end else begin
    unit2d_cnt_pooling_last_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_45x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((load_wr_stage1 & (|mem_re_last_d)) | (cur_datin_disable_d & wr_data_stage0_prdy)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//&Always posedge;
//    if(cur_datin_disable_d)
//        cur_datin_disable_2d <0= 1'b1;
//    else if(wr_data_stage1_prdy)
//        cur_datin_disable_2d <0= 1'b0;
//&End;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cur_datin_disable_2d <= 1'b0;
  end else begin
  if ((load_wr_stage1_all) == 1'b1) begin
    cur_datin_disable_2d <= cur_datin_disable_d;
  // VCS coverage off
  end else if ((load_wr_stage1_all) == 1'b0) begin
  end else begin
    cur_datin_disable_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_46x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    one_width_disable_2d <= 1'b0;
  end else begin
  if ((load_wr_stage1_all) == 1'b1) begin
    one_width_disable_2d <= one_width_disable_d;
  // VCS coverage off
  end else if ((load_wr_stage1_all) == 1'b0) begin
  end else begin
    one_width_disable_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_47x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cur_datin_disable_3d <= 1'b0;
  end else begin
  if ((load_wr_stage2_all) == 1'b1) begin
    cur_datin_disable_3d <= cur_datin_disable_2d;
  // VCS coverage off
  end else if ((load_wr_stage2_all) == 1'b0) begin
  end else begin
    cur_datin_disable_3d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage2_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    one_width_disable_3d <= 1'b0;
  end else begin
  if ((load_wr_stage2_all) == 1'b1) begin
    one_width_disable_3d <= one_width_disable_2d;
  // VCS coverage off
  end else if ((load_wr_stage2_all) == 1'b0) begin
  end else begin
    one_width_disable_3d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_49x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage2_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//line buffer2
assign pout_mem_data_sel_1_last[0] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[0] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re2_sel;
assign pout_mem_data_sel_1_last[1] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[1] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re2_sel;
assign pout_mem_data_sel_1_last[2] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[2] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re2_sel;
assign pout_mem_data_sel_1_last[3] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[3] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re2_sel;
assign pout_mem_data_sel_1_last[4] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[4] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re2_sel;
assign pout_mem_data_sel_1_last[5] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[5] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re2_sel;
assign pout_mem_data_sel_1_last[6] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[6] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re2_sel;
assign pout_mem_data_sel_1_last[7] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[7] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re2_sel;

//line buffer3,4
assign pout_mem_data_sel_2_last[0] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[0] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re3_sel;
assign pout_mem_data_sel_2_last[1] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[1] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re3_sel;
assign pout_mem_data_sel_2_last[2] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[2] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re3_sel;
assign pout_mem_data_sel_2_last[3] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[3] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re3_sel;
assign pout_mem_data_sel_2_last[4] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[4] & (unit2d_cnt_pooling_last_2d==3'd2) & mem_re3_sel;
assign pout_mem_data_sel_2_last[5] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[5] & (unit2d_cnt_pooling_last_2d==3'd2) & mem_re3_sel;
assign pout_mem_data_sel_2_last[6] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[6] & (unit2d_cnt_pooling_last_2d==3'd3) & mem_re3_sel;
assign pout_mem_data_sel_2_last[7] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[7] & (unit2d_cnt_pooling_last_2d==3'd3) & mem_re3_sel;

//line buffer 5,6,7,8
assign pout_mem_data_sel_3_last[0] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[0] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re4_sel;
assign pout_mem_data_sel_3_last[1] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[1] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re4_sel;
assign pout_mem_data_sel_3_last[2] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[2] & (unit2d_cnt_pooling_last_2d==3'd2) & mem_re4_sel;
assign pout_mem_data_sel_3_last[3] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[3] & (unit2d_cnt_pooling_last_2d==3'd3) & mem_re4_sel;
assign pout_mem_data_sel_3_last[4] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[4] & (unit2d_cnt_pooling_last_2d==3'd4) & mem_re4_sel;
assign pout_mem_data_sel_3_last[5] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[5] & (unit2d_cnt_pooling_last_2d==3'd5) & mem_re4_sel;
assign pout_mem_data_sel_3_last[6] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[6] & (unit2d_cnt_pooling_last_2d==3'd6) & mem_re4_sel;
assign pout_mem_data_sel_3_last[7] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[7] & (unit2d_cnt_pooling_last_2d==3'd7) & mem_re4_sel;
 
assign pout_mem_data_sel_last = pout_mem_data_sel_3_last | pout_mem_data_sel_2_last | pout_mem_data_sel_1_last;

assign pout_mem_data_last = (mem_data0_lst & {115{pout_mem_data_sel_last[0]}}) |
                            (mem_data1_lst & {115{pout_mem_data_sel_last[1]}}) |
                            (mem_data2_lst & {115{pout_mem_data_sel_last[2]}}) |
                            (mem_data3_lst & {115{pout_mem_data_sel_last[3]}}) |
                            (mem_data4_lst & {115{pout_mem_data_sel_last[4]}}) |
                            (mem_data5_lst & {115{pout_mem_data_sel_last[5]}}) |
                            (mem_data6_lst & {115{pout_mem_data_sel_last[6]}}) |
                            (mem_data7_lst & {115{pout_mem_data_sel_last[7]}}) ;

//==============================================================================
//unit2d pooling data read out
//
//
//------------------------------------------------------------------------------
//data count in sub line 
assign rd_line_out_done = wr_line_end_2d & rd_line_out;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_line_out_cnt <= {6{1'b0}};
  end else begin
   if(rd_line_out_done | rd_sub_lbuf_end)
        rd_line_out_cnt <= 6'd0;
   else if(rd_line_out)
        rd_line_out_cnt <= rd_line_out_cnt + 1'd1;
  end
end
assign  rd_sub_lbuf_end =((rd_line_out & (rd_line_out_cnt==BANK_DEPTH)) | rd_line_out_done); 

//sub line buffer counter
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_sub_lbuf_cnt[2:0] <= {3{1'b0}};
  end else begin
     if(rd_comb_lbuf_end)
         rd_sub_lbuf_cnt[2:0] <= 3'd0;  
    else if(rd_sub_lbuf_end)
         rd_sub_lbuf_cnt[2:0] <= rd_sub_lbuf_cnt +1;
  end
end
assign rd_comb_lbuf_end = (rd_sub_lbuf_end & ({2'd0,rd_sub_lbuf_cnt}==(bank_merge_num -1))) | rd_line_out_done;

//combine line buffer counter
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_comb_lbuf_cnt[2:0] <= {3{1'b0}};
  end else begin
    //if(rd_lbuf_end | wr_surface_dat_done_2d)
    if(rd_lbuf_end | (wr_surface_dat_done_2d & load_wr_stage2))
        rd_comb_lbuf_cnt[2:0] <= 3'd0;  
    else if(rd_comb_lbuf_end & last_active_line_2d)
        rd_comb_lbuf_cnt[2:0] <= rd_comb_lbuf_cnt + 1;
  end
end
assign rd_lbuf_end = ({2'd0,rd_comb_lbuf_cnt}==(buffer_lines_num-1)) & rd_comb_lbuf_end & last_active_line_2d;
////////////////////////////////////////////////////////////////////////////////////////////////////
//unit2d_data_rdy need two active delays as load_wr_stage2
assign rd_line_out = |pout_mem_data_sel;
assign rd_pout_data_en = (rd_line_out | ((load_wr_stage2 & (|mem_re_last_2d))| (cur_datin_disable_2d & wr_data_stage1_prdy)));

//read output stage
assign wr_data_stage1_prdy = (fp16_en & average_pooling_en)? fp16_add_in_rdy : (~wr_data_stage2_vld | pout_data_stage0_prdy);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_pout_data_en_d <= 1'b0;
  end else begin
  if ((load_wr_stage2_all) == 1'b1) begin
    rd_pout_data_en_d <= rd_pout_data_en;
  // VCS coverage off
  end else if ((load_wr_stage2_all) == 1'b0) begin
  end else begin
    rd_pout_data_en_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_50x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage2_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign rd_pout_data_stage0 = load_wr_stage3_all & rd_pout_data_en_d;

assign pout_data_stage0_prdy = ~pout_data_stage1_vld | pout_data_stage1_prdy;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_data_stage1_vld <= 1'b0;
  end else begin
   if(wr_data_stage2_vld)
      pout_data_stage1_vld <= 1'b1;
   else if(pout_data_stage1_prdy)
      pout_data_stage1_vld <= 1'b0;
  end
end

assign pout_data_stage1_prdy = ~pout_data_stage2_vld | pout_data_stage2_prdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_pout_data_en_2d <= 1'b0;
  end else begin
  if ((load_wr_stage3_all) == 1'b1) begin
    rd_pout_data_en_2d <= rd_pout_data_en_d;
  // VCS coverage off
  end else if ((load_wr_stage3_all) == 1'b0) begin
  end else begin
    rd_pout_data_en_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_51x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage3_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign rd_pout_data_stage1_all = pout_data_stage1_vld & pout_data_stage1_prdy;
assign rd_pout_data_stage1 = pout_data_stage1_vld & pout_data_stage1_prdy & rd_pout_data_en_2d;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_data_stage2_vld <= 1'b0;
  end else begin
   if(pout_data_stage1_vld)
      pout_data_stage2_vld <= 1'b1;
   else if(pout_data_stage2_prdy)
      pout_data_stage2_vld <= 1'b0;
  end
end

assign pout_data_stage2_prdy = ~pout_data_stage3_vld | pout_data_stage3_prdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_pout_data_en_3d <= 1'b0;
  end else begin
  if ((rd_pout_data_stage1_all) == 1'b1) begin
    rd_pout_data_en_3d <= rd_pout_data_en_2d;
  // VCS coverage off
  end else if ((rd_pout_data_stage1_all) == 1'b0) begin
  end else begin
    rd_pout_data_en_3d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_52x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_pout_data_stage1_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign rd_pout_data_stage2_all = pout_data_stage2_vld & pout_data_stage2_prdy;
assign rd_pout_data_stage2 = pout_data_stage2_vld & pout_data_stage2_prdy & rd_pout_data_en_3d;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_pout_data_en_4d <= 1'b0;
  end else begin
  if ((rd_pout_data_stage2_all) == 1'b1) begin
    rd_pout_data_en_4d <= rd_pout_data_en_3d;
  // VCS coverage off
  end else if ((rd_pout_data_stage2_all) == 1'b0) begin
  end else begin
    rd_pout_data_en_4d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_pout_data_stage2_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pout_data_stage3_vld <= 1'b0;
  end else begin
   if(pout_data_stage2_vld)
      pout_data_stage3_vld <= 1'b1;
   else if(pout_data_stage3_prdy)
      pout_data_stage3_vld <= 1'b0;
  end
end
/////////////////////////////////////////////////////////
//line buffer1 
assign pout_mem_data_sel_0    = mem_re_2d & {8{load_wr_stage2}} & {8{ mem_re1_sel}} & {8{last_active_line_2d}};

//line buffer2
assign pout_mem_data_sel_1[0] = mem_re_2d[0] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[1] = mem_re_2d[1] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[2] = mem_re_2d[2] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[3] = mem_re_2d[3] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[4] = mem_re_2d[4] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[5] = mem_re_2d[5] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[6] = mem_re_2d[6] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[7] = mem_re_2d[7] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re2_sel;

//line buffer3,4
assign pout_mem_data_sel_2[0] = mem_re_2d[0] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[1] = mem_re_2d[1] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[2] = mem_re_2d[2] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[3] = mem_re_2d[3] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[4] = mem_re_2d[4] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd2) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[5] = mem_re_2d[5] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd2) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[6] = mem_re_2d[6] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd3) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[7] = mem_re_2d[7] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd3) & last_active_line_2d & mem_re3_sel;

//line buffer 5,6,7,8
assign pout_mem_data_sel_3[0] = mem_re_2d[0] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[1] = mem_re_2d[1] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[2] = mem_re_2d[2] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd2) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[3] = mem_re_2d[3] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd3) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[4] = mem_re_2d[4] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd4) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[5] = mem_re_2d[5] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd5) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[6] = mem_re_2d[6] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd6) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[7] = mem_re_2d[7] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd7) & last_active_line_2d & mem_re4_sel;

assign pout_mem_data_sel = (pout_mem_data_sel_3 | pout_mem_data_sel_2 | pout_mem_data_sel_1 | pout_mem_data_sel_0);

always @(
  pout_mem_data_sel
  or pooling_2d_info_0
  or pooling_2d_result_0
  or pooling_2d_info_1
  or pooling_2d_result_1
  or pooling_2d_info_2
  or pooling_2d_result_2
  or pooling_2d_info_3
  or pooling_2d_result_3
  or pooling_2d_info_4
  or pooling_2d_result_4
  or pooling_2d_info_5
  or pooling_2d_result_5
  or pooling_2d_info_6
  or pooling_2d_result_6
  or pooling_2d_info_7
  or pooling_2d_result_7
  ) begin
    case(pout_mem_data_sel[7:0])
      8'h01: pout_mem_data_act = {pooling_2d_info_0[2:0],pooling_2d_result_0};
      8'h02: pout_mem_data_act = {pooling_2d_info_1[2:0],pooling_2d_result_1};
      8'h04: pout_mem_data_act = {pooling_2d_info_2[2:0],pooling_2d_result_2};
      8'h08: pout_mem_data_act = {pooling_2d_info_3[2:0],pooling_2d_result_3};
      8'h10: pout_mem_data_act = {pooling_2d_info_4[2:0],pooling_2d_result_4};
      8'h20: pout_mem_data_act = {pooling_2d_info_5[2:0],pooling_2d_result_5};
      8'h40: pout_mem_data_act = {pooling_2d_info_6[2:0],pooling_2d_result_6};
      8'h80: pout_mem_data_act = {pooling_2d_info_7[2:0],pooling_2d_result_7};
    default: pout_mem_data_act = 115'd0;
    endcase
end

assign int_pout_mem_data = pout_mem_data_act | pout_mem_data_last;
assign pout_mem_data = (fp16_en & average_pooling_en)? fp16_pout_mem_data : int_pout_mem_data;
//=============================================================
//pooling output data to DMA
//
//-------------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_mem_data_0 <= {28{1'b0}};
    pout_mem_data_1 <= {28{1'b0}};
    pout_mem_data_2 <= {28{1'b0}};
    pout_mem_data_3 <= {28{1'b0}};
    pout_mem_size_v <= {3{1'b0}};
  end else begin
    if(rd_pout_data_en) begin
        pout_mem_data_0 <= pout_mem_data[27:0];
        pout_mem_data_1 <= pout_mem_data[55:28];
        pout_mem_data_2 <= pout_mem_data[83:56];
        pout_mem_data_3 <= pout_mem_data[111:84];
        pout_mem_size_v <= pout_mem_data[114:112];
    end
  end
end

//===========================================================
//adding pad value in v direction
//-----------------------------------------------------------
//padding value 1x,2x,3x,4x,5x,6x,7x table
assign pout_mem_size_v_use = fp16_mean_pool_cfg ? fp_mem_size_v : pout_mem_size_v;
assign padding_here = average_pooling_en & (pout_mem_size_v_use != pooling_size_v_cfg);
assign {mon_pad_table_index[0],pad_table_index[2:0]} = pooling_size_v_cfg - pout_mem_size_v_use;
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
  nv_assert_never #(0,0,"PDPCore cal2d: pooling size should not less than active num")      zzz_assert_never_54x (nvdla_core_clk, `ASSERT_RESET, ((fp16_mean_pool_cfg? fp16_mulw_in_vld: rd_pout_data_stage0) & mon_pad_table_index & reg2dp_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(
  pad_table_index
  or reg2dp_pad_value_1x_cfg
  or reg2dp_pad_value_2x_cfg
  or reg2dp_pad_value_3x_cfg
  or reg2dp_pad_value_4x_cfg
  or reg2dp_pad_value_5x_cfg
  or reg2dp_pad_value_6x_cfg
  or reg2dp_pad_value_7x_cfg
  ) begin
    case(pad_table_index)
       3'd1: pad_table_out = reg2dp_pad_value_1x_cfg[18:0]; //1x  
       3'd2: pad_table_out = reg2dp_pad_value_2x_cfg[18:0]; //2x
       3'd3: pad_table_out = reg2dp_pad_value_3x_cfg[18:0]; //3x
       3'd4: pad_table_out = reg2dp_pad_value_4x_cfg[18:0]; //4x
       3'd5: pad_table_out = reg2dp_pad_value_5x_cfg[18:0]; //5x
       3'd6: pad_table_out = reg2dp_pad_value_6x_cfg[18:0]; //6x
       3'd7: pad_table_out = reg2dp_pad_value_7x_cfg[18:0]; //7x
       default:pad_table_out = 19'd0; //1x;
    endcase
end

assign kernel_width_cfg[3:0] = reg2dp_kernel_width[2:0]+3'd1;
assign {mon_pad_value,pad_value[21:0]} = $signed(pad_table_out) * $signed({{1{1'b0}}, kernel_width_cfg});
assign pout_mem_data0 = pout_mem_data_0[21:0];
assign pout_mem_data1 = pout_mem_data_1[21:0];
assign pout_mem_data2 = pout_mem_data_2[21:0];
assign pout_mem_data3 = pout_mem_data_3[21:0];

assign {mon_data_16bit_0_ff[0],data_16bit_0_ff[21:0]} = $signed(pout_mem_data0) + $signed(pad_value);
assign {mon_data_16bit_1_ff[0],data_16bit_1_ff[21:0]} = $signed(pout_mem_data1) + $signed(pad_value);
assign {mon_data_16bit_2_ff[0],data_16bit_2_ff[21:0]} = $signed(pout_mem_data2) + $signed(pad_value);
assign {mon_data_16bit_3_ff[0],data_16bit_3_ff[21:0]} = $signed(pout_mem_data3) + $signed(pad_value);
assign {mon_data_16bit_0[0],data_16bit_0[21:0]} = padding_here ? {mon_data_16bit_0_ff[0],data_16bit_0_ff[21:0]} : {pout_mem_data_0[21],pout_mem_data_0[21:0]};
assign {mon_data_16bit_1[0],data_16bit_1[21:0]} = padding_here ? {mon_data_16bit_1_ff[0],data_16bit_1_ff[21:0]} : {pout_mem_data_1[21],pout_mem_data_1[21:0]};
assign {mon_data_16bit_2[0],data_16bit_2[21:0]} = padding_here ? {mon_data_16bit_2_ff[0],data_16bit_2_ff[21:0]} : {pout_mem_data_2[21],pout_mem_data_2[21:0]};
assign {mon_data_16bit_3[0],data_16bit_3[21:0]} = padding_here ? {mon_data_16bit_3_ff[0],data_16bit_3_ff[21:0]} : {pout_mem_data_3[21],pout_mem_data_3[21:0]};
                                                                                                                                                                                                     
assign {mon_data_8bit_0_ff[1:0] ,data_8bit_0_ff[13:0]} = $signed({pout_mem_data_0[13],pout_mem_data_0[13:0] }) + $signed({pad_value[13], pad_value[13:0]});
assign {mon_data_8bit_1_ff[1:0] ,data_8bit_1_ff[13:0]} = $signed({pout_mem_data_0[27],pout_mem_data_0[27:14]}) + $signed({pad_value[13], pad_value[13:0]});
assign {mon_data_8bit_2_ff[1:0] ,data_8bit_2_ff[13:0]} = $signed({pout_mem_data_1[13],pout_mem_data_1[13:0] }) + $signed({pad_value[13], pad_value[13:0]});
assign {mon_data_8bit_3_ff[1:0] ,data_8bit_3_ff[13:0]} = $signed({pout_mem_data_1[27],pout_mem_data_1[27:14]}) + $signed({pad_value[13], pad_value[13:0]});
assign {mon_data_8bit_4_ff[1:0] ,data_8bit_4_ff[13:0]} = $signed({pout_mem_data_2[13],pout_mem_data_2[13:0] }) + $signed({pad_value[13], pad_value[13:0]});
assign {mon_data_8bit_5_ff[1:0] ,data_8bit_5_ff[13:0]} = $signed({pout_mem_data_2[27],pout_mem_data_2[27:14]}) + $signed({pad_value[13], pad_value[13:0]});
assign {mon_data_8bit_6_ff[1:0] ,data_8bit_6_ff[13:0]} = $signed({pout_mem_data_3[13],pout_mem_data_3[13:0] }) + $signed({pad_value[13], pad_value[13:0]});
assign {mon_data_8bit_7_ff[1:0] ,data_8bit_7_ff[13:0]} = $signed({pout_mem_data_3[27],pout_mem_data_3[27:14]}) + $signed({pad_value[13], pad_value[13:0]});
assign {mon_data_8bit_0[1:0] ,data_8bit_0[13:0]}  = padding_here ? {mon_data_8bit_0_ff[1:0] ,data_8bit_0_ff[13:0]} : {{2{pout_mem_data_0[13]}},pout_mem_data_0[13:0] };
assign {mon_data_8bit_1[1:0] ,data_8bit_1[13:0]}  = padding_here ? {mon_data_8bit_1_ff[1:0] ,data_8bit_1_ff[13:0]} : {{2{pout_mem_data_0[27]}},pout_mem_data_0[27:14]};
assign {mon_data_8bit_2[1:0] ,data_8bit_2[13:0]}  = padding_here ? {mon_data_8bit_2_ff[1:0] ,data_8bit_2_ff[13:0]} : {{2{pout_mem_data_1[13]}},pout_mem_data_1[13:0] };
assign {mon_data_8bit_3[1:0] ,data_8bit_3[13:0]}  = padding_here ? {mon_data_8bit_3_ff[1:0] ,data_8bit_3_ff[13:0]} : {{2{pout_mem_data_1[27]}},pout_mem_data_1[27:14]};
assign {mon_data_8bit_4[1:0] ,data_8bit_4[13:0]}  = padding_here ? {mon_data_8bit_4_ff[1:0] ,data_8bit_4_ff[13:0]} : {{2{pout_mem_data_2[13]}},pout_mem_data_2[13:0] };
assign {mon_data_8bit_5[1:0] ,data_8bit_5[13:0]}  = padding_here ? {mon_data_8bit_5_ff[1:0] ,data_8bit_5_ff[13:0]} : {{2{pout_mem_data_2[27]}},pout_mem_data_2[27:14]};
assign {mon_data_8bit_6[1:0] ,data_8bit_6[13:0]}  = padding_here ? {mon_data_8bit_6_ff[1:0] ,data_8bit_6_ff[13:0]} : {{2{pout_mem_data_3[13]}},pout_mem_data_3[13:0] };
assign {mon_data_8bit_7[1:0] ,data_8bit_7[13:0]}  = padding_here ? {mon_data_8bit_7_ff[1:0] ,data_8bit_7_ff[13:0]} : {{2{pout_mem_data_3[27]}},pout_mem_data_3[27:14]};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_data_0_0[27:0] <= {28{1'b0}};
    pout_data_0_1[27:0] <= {28{1'b0}};
    pout_data_0_2[27:0] <= {28{1'b0}};
    pout_data_0_3[27:0] <= {28{1'b0}};
  end else begin
   if(~fp16_en & average_pooling_en) begin
        if(rd_pout_data_stage0) begin
           if(int8_en) begin
               pout_data_0_0[27:0] <= {data_8bit_1, data_8bit_0};
               pout_data_0_1[27:0] <= {data_8bit_3, data_8bit_2};
               pout_data_0_2[27:0] <= {data_8bit_5, data_8bit_4};
               pout_data_0_3[27:0] <= {data_8bit_7, data_8bit_6};
           end else begin
               pout_data_0_0[27:0] <= {{6{data_16bit_0[21]}}, data_16bit_0[21:0]};
               pout_data_0_1[27:0] <= {{6{data_16bit_1[21]}}, data_16bit_1[21:0]};
               pout_data_0_2[27:0] <= {{6{data_16bit_2[21]}}, data_16bit_2[21:0]};
               pout_data_0_3[27:0] <= {{6{data_16bit_3[21]}}, data_16bit_3[21:0]};
           end
        end
   end else if(rd_pout_data_stage0)begin
        pout_data_0_0[27:0] <= pout_mem_data_0;
        pout_data_0_1[27:0] <= pout_mem_data_1;
        pout_data_0_2[27:0] <= pout_mem_data_2;
        pout_data_0_3[27:0] <= pout_mem_data_3;
   end
  end
end

//===========================================================
//stage1: (* /kernel_width)
//stage1 : calcate pooling data based on real pooling size --- (* 1/kernel_width)
//-----------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_recip_width_use[16:0] <= {17{1'b0}};
  end else begin
  reg2dp_recip_width_use[16:0] <= reg2dp_recip_width_cfg[16:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_recip_height_use[16:0] <= {17{1'b0}};
  end else begin
  reg2dp_recip_height_use[16:0] <= reg2dp_recip_height_cfg[16:0];
  end
end
//16bits
assign data_hmult_16bit_0_ext_ff[38:0] = $signed(pout_data_0_0[21:0]) * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_16bit_1_ext_ff[38:0] = $signed(pout_data_0_1[21:0]) * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_16bit_2_ext_ff[38:0] = $signed(pout_data_0_2[21:0]) * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_16bit_3_ext_ff[38:0] = $signed(pout_data_0_3[21:0]) * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_16bit_0_ext[38:0] = average_pooling_en ? data_hmult_16bit_0_ext_ff[38:0] : {pout_data_0_0[21],pout_data_0_0[21:0],16'd0};
assign data_hmult_16bit_1_ext[38:0] = average_pooling_en ? data_hmult_16bit_1_ext_ff[38:0] : {pout_data_0_1[21],pout_data_0_1[21:0],16'd0};
assign data_hmult_16bit_2_ext[38:0] = average_pooling_en ? data_hmult_16bit_2_ext_ff[38:0] : {pout_data_0_2[21],pout_data_0_2[21:0],16'd0};
assign data_hmult_16bit_3_ext[38:0] = average_pooling_en ? data_hmult_16bit_3_ext_ff[38:0] : {pout_data_0_3[21],pout_data_0_3[21:0],16'd0};
assign i16_less_neg_0_5_0 = data_hmult_16bit_0_ext[38] & ((data_hmult_16bit_0_ext[15] & (~(|data_hmult_16bit_0_ext[14:0]))) | (~data_hmult_16bit_0_ext[15]));
assign i16_less_neg_0_5_1 = data_hmult_16bit_1_ext[38] & ((data_hmult_16bit_1_ext[15] & (~(|data_hmult_16bit_1_ext[14:0]))) | (~data_hmult_16bit_1_ext[15]));
assign i16_less_neg_0_5_2 = data_hmult_16bit_2_ext[38] & ((data_hmult_16bit_2_ext[15] & (~(|data_hmult_16bit_2_ext[14:0]))) | (~data_hmult_16bit_2_ext[15]));
assign i16_less_neg_0_5_3 = data_hmult_16bit_3_ext[38] & ((data_hmult_16bit_3_ext[15] & (~(|data_hmult_16bit_3_ext[14:0]))) | (~data_hmult_16bit_3_ext[15]));
assign i16_more_neg_0_5_0 = data_hmult_16bit_0_ext[38] & data_hmult_16bit_0_ext[15] & (|data_hmult_16bit_0_ext[14:0]);
assign i16_more_neg_0_5_1 = data_hmult_16bit_1_ext[38] & data_hmult_16bit_1_ext[15] & (|data_hmult_16bit_1_ext[14:0]);
assign i16_more_neg_0_5_2 = data_hmult_16bit_2_ext[38] & data_hmult_16bit_2_ext[15] & (|data_hmult_16bit_2_ext[14:0]);
assign i16_more_neg_0_5_3 = data_hmult_16bit_3_ext[38] & data_hmult_16bit_3_ext[15] & (|data_hmult_16bit_3_ext[14:0]);
assign {mon_i16_neg_add1_0,i16_neg_add1_0[18:0]} = data_hmult_16bit_0_ext[34:16]+19'd1; 
assign {mon_i16_neg_add1_1,i16_neg_add1_1[18:0]} = data_hmult_16bit_1_ext[34:16]+19'd1;
assign {mon_i16_neg_add1_2,i16_neg_add1_2[18:0]} = data_hmult_16bit_2_ext[34:16]+19'd1;
assign {mon_i16_neg_add1_3,i16_neg_add1_3[18:0]} = data_hmult_16bit_3_ext[34:16]+19'd1;
assign data_hmult_16bit_0[18:0] = (i16_less_neg_0_5_0)? data_hmult_16bit_0_ext[34:16] : (i16_more_neg_0_5_0)? i16_neg_add1_0[18:0] : (data_hmult_16bit_0_ext[33:16]+data_hmult_16bit_0_ext[15]);//rounding 0.5=1, -0.5=-1  
assign data_hmult_16bit_1[18:0] = (i16_less_neg_0_5_1)? data_hmult_16bit_1_ext[34:16] : (i16_more_neg_0_5_1)? i16_neg_add1_1[18:0] : (data_hmult_16bit_1_ext[33:16]+data_hmult_16bit_1_ext[15]);//rounding 0.5=1, -0.5=-1 
assign data_hmult_16bit_2[18:0] = (i16_less_neg_0_5_2)? data_hmult_16bit_2_ext[34:16] : (i16_more_neg_0_5_2)? i16_neg_add1_2[18:0] : (data_hmult_16bit_2_ext[33:16]+data_hmult_16bit_2_ext[15]);//rounding 0.5=1, -0.5=-1 
assign data_hmult_16bit_3[18:0] = (i16_less_neg_0_5_3)? data_hmult_16bit_3_ext[34:16] : (i16_more_neg_0_5_3)? i16_neg_add1_3[18:0] : (data_hmult_16bit_3_ext[33:16]+data_hmult_16bit_3_ext[15]);//rounding 0.5=1, -0.5=-1 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_55x (nvdla_core_clk, `ASSERT_RESET, (rd_pout_data_stage1 & int16_en & ((&data_hmult_16bit_0_ext[38:37]) != (|data_hmult_16bit_0_ext[38:37])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_56x (nvdla_core_clk, `ASSERT_RESET, (rd_pout_data_stage1 & int16_en & ((&data_hmult_16bit_1_ext[38:37]) != (|data_hmult_16bit_1_ext[38:37])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_57x (nvdla_core_clk, `ASSERT_RESET, (rd_pout_data_stage1 & int16_en & ((&data_hmult_16bit_2_ext[38:37]) != (|data_hmult_16bit_2_ext[38:37])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_58x (nvdla_core_clk, `ASSERT_RESET, (rd_pout_data_stage1 & int16_en & ((&data_hmult_16bit_3_ext[38:37]) != (|data_hmult_16bit_3_ext[38:37])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//8bits
assign data_hmult_8bit_0_lsb_ext_ff[30:0] = $signed(pout_data_0_0[13:0])  * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_8bit_0_msb_ext_ff[30:0] = $signed(pout_data_0_0[27:14]) * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_8bit_1_lsb_ext_ff[30:0] = $signed(pout_data_0_1[13:0])  * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_8bit_1_msb_ext_ff[30:0] = $signed(pout_data_0_1[27:14]) * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_8bit_2_lsb_ext_ff[30:0] = $signed(pout_data_0_2[13:0])  * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_8bit_2_msb_ext_ff[30:0] = $signed(pout_data_0_2[27:14]) * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_8bit_3_lsb_ext_ff[30:0] = $signed(pout_data_0_3[13:0])  * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_8bit_3_msb_ext_ff[30:0] = $signed(pout_data_0_3[27:14]) * $signed({1'b0,reg2dp_recip_width_use[16:0]});
assign data_hmult_8bit_0_lsb_ext[30:0] = average_pooling_en ? data_hmult_8bit_0_lsb_ext_ff : {pout_data_0_0[13],pout_data_0_0[13:0] ,16'd0};
assign data_hmult_8bit_0_msb_ext[30:0] = average_pooling_en ? data_hmult_8bit_0_msb_ext_ff : {pout_data_0_0[27],pout_data_0_0[27:14],16'd0};
assign data_hmult_8bit_1_lsb_ext[30:0] = average_pooling_en ? data_hmult_8bit_1_lsb_ext_ff : {pout_data_0_1[13],pout_data_0_1[13:0] ,16'd0};
assign data_hmult_8bit_1_msb_ext[30:0] = average_pooling_en ? data_hmult_8bit_1_msb_ext_ff : {pout_data_0_1[27],pout_data_0_1[27:14],16'd0};
assign data_hmult_8bit_2_lsb_ext[30:0] = average_pooling_en ? data_hmult_8bit_2_lsb_ext_ff : {pout_data_0_2[13],pout_data_0_2[13:0] ,16'd0};
assign data_hmult_8bit_2_msb_ext[30:0] = average_pooling_en ? data_hmult_8bit_2_msb_ext_ff : {pout_data_0_2[27],pout_data_0_2[27:14],16'd0};
assign data_hmult_8bit_3_lsb_ext[30:0] = average_pooling_en ? data_hmult_8bit_3_lsb_ext_ff : {pout_data_0_3[13],pout_data_0_3[13:0] ,16'd0};
assign data_hmult_8bit_3_msb_ext[30:0] = average_pooling_en ? data_hmult_8bit_3_msb_ext_ff : {pout_data_0_3[27],pout_data_0_3[27:14],16'd0};

assign i8_less_neg_0_5_0_l = data_hmult_8bit_0_lsb_ext[30] & ((data_hmult_8bit_0_lsb_ext[15] & (~(|data_hmult_8bit_0_lsb_ext[14:0]))) | (~data_hmult_8bit_0_lsb_ext[15]));
assign i8_less_neg_0_5_0_m = data_hmult_8bit_0_msb_ext[30] & ((data_hmult_8bit_0_msb_ext[15] & (~(|data_hmult_8bit_0_msb_ext[14:0]))) | (~data_hmult_8bit_0_msb_ext[15]));
assign i8_less_neg_0_5_1_l = data_hmult_8bit_1_lsb_ext[30] & ((data_hmult_8bit_1_lsb_ext[15] & (~(|data_hmult_8bit_1_lsb_ext[14:0]))) | (~data_hmult_8bit_1_lsb_ext[15]));
assign i8_less_neg_0_5_1_m = data_hmult_8bit_1_msb_ext[30] & ((data_hmult_8bit_1_msb_ext[15] & (~(|data_hmult_8bit_1_msb_ext[14:0]))) | (~data_hmult_8bit_1_msb_ext[15]));
assign i8_less_neg_0_5_2_l = data_hmult_8bit_2_lsb_ext[30] & ((data_hmult_8bit_2_lsb_ext[15] & (~(|data_hmult_8bit_2_lsb_ext[14:0]))) | (~data_hmult_8bit_2_lsb_ext[15]));
assign i8_less_neg_0_5_2_m = data_hmult_8bit_2_msb_ext[30] & ((data_hmult_8bit_2_msb_ext[15] & (~(|data_hmult_8bit_2_msb_ext[14:0]))) | (~data_hmult_8bit_2_msb_ext[15]));
assign i8_less_neg_0_5_3_l = data_hmult_8bit_3_lsb_ext[30] & ((data_hmult_8bit_3_lsb_ext[15] & (~(|data_hmult_8bit_3_lsb_ext[14:0]))) | (~data_hmult_8bit_3_lsb_ext[15]));
assign i8_less_neg_0_5_3_m = data_hmult_8bit_3_msb_ext[30] & ((data_hmult_8bit_3_msb_ext[15] & (~(|data_hmult_8bit_3_msb_ext[14:0]))) | (~data_hmult_8bit_3_msb_ext[15]));
assign i8_more_neg_0_5_0_l = data_hmult_8bit_0_lsb_ext[30] & data_hmult_8bit_0_lsb_ext[15] & (|data_hmult_8bit_0_lsb_ext[14:0]);
assign i8_more_neg_0_5_0_m = data_hmult_8bit_0_msb_ext[30] & data_hmult_8bit_0_msb_ext[15] & (|data_hmult_8bit_0_msb_ext[14:0]);
assign i8_more_neg_0_5_1_l = data_hmult_8bit_1_lsb_ext[30] & data_hmult_8bit_1_lsb_ext[15] & (|data_hmult_8bit_1_lsb_ext[14:0]);
assign i8_more_neg_0_5_1_m = data_hmult_8bit_1_msb_ext[30] & data_hmult_8bit_1_msb_ext[15] & (|data_hmult_8bit_1_msb_ext[14:0]);
assign i8_more_neg_0_5_2_l = data_hmult_8bit_2_lsb_ext[30] & data_hmult_8bit_2_lsb_ext[15] & (|data_hmult_8bit_2_lsb_ext[14:0]);
assign i8_more_neg_0_5_2_m = data_hmult_8bit_2_msb_ext[30] & data_hmult_8bit_2_msb_ext[15] & (|data_hmult_8bit_2_msb_ext[14:0]);
assign i8_more_neg_0_5_3_l = data_hmult_8bit_3_lsb_ext[30] & data_hmult_8bit_3_lsb_ext[15] & (|data_hmult_8bit_3_lsb_ext[14:0]);
assign i8_more_neg_0_5_3_m = data_hmult_8bit_3_msb_ext[30] & data_hmult_8bit_3_msb_ext[15] & (|data_hmult_8bit_3_msb_ext[14:0]);
assign {mon_i8_neg_add1_0_l,i8_neg_add1_0_l[10:0]} = data_hmult_8bit_0_lsb_ext[26:16]+11'd1; 
assign {mon_i8_neg_add1_0_m,i8_neg_add1_0_m[10:0]} = data_hmult_8bit_0_msb_ext[26:16]+11'd1; 
assign {mon_i8_neg_add1_1_l,i8_neg_add1_1_l[10:0]} = data_hmult_8bit_1_lsb_ext[26:16]+11'd1;
assign {mon_i8_neg_add1_1_m,i8_neg_add1_1_m[10:0]} = data_hmult_8bit_1_msb_ext[26:16]+11'd1;
assign {mon_i8_neg_add1_2_l,i8_neg_add1_2_l[10:0]} = data_hmult_8bit_2_lsb_ext[26:16]+11'd1;
assign {mon_i8_neg_add1_2_m,i8_neg_add1_2_m[10:0]} = data_hmult_8bit_2_msb_ext[26:16]+11'd1;
assign {mon_i8_neg_add1_3_l,i8_neg_add1_3_l[10:0]} = data_hmult_8bit_3_lsb_ext[26:16]+11'd1;
assign {mon_i8_neg_add1_3_m,i8_neg_add1_3_m[10:0]} = data_hmult_8bit_3_msb_ext[26:16]+11'd1;
assign hmult_8bit_0_lsb[10:0] = (i8_less_neg_0_5_0_l)? data_hmult_8bit_0_lsb_ext[26:16] : (i8_more_neg_0_5_0_l)? i8_neg_add1_0_l[10:0] : (data_hmult_8bit_0_lsb_ext[25:16]+data_hmult_8bit_0_lsb_ext[15]);//rounding 0.5=1, -0.5=-1
assign hmult_8bit_0_msb[10:0] = (i8_less_neg_0_5_0_m)? data_hmult_8bit_0_msb_ext[26:16] : (i8_more_neg_0_5_0_m)? i8_neg_add1_0_m[10:0] : (data_hmult_8bit_0_msb_ext[25:16]+data_hmult_8bit_0_msb_ext[15]);//rounding 0.5=1, -0.5=-1
assign hmult_8bit_1_lsb[10:0] = (i8_less_neg_0_5_1_l)? data_hmult_8bit_1_lsb_ext[26:16] : (i8_more_neg_0_5_1_l)? i8_neg_add1_1_l[10:0] : (data_hmult_8bit_1_lsb_ext[25:16]+data_hmult_8bit_1_lsb_ext[15]);//rounding 0.5=1, -0.5=-1
assign hmult_8bit_1_msb[10:0] = (i8_less_neg_0_5_1_m)? data_hmult_8bit_1_msb_ext[26:16] : (i8_more_neg_0_5_1_m)? i8_neg_add1_1_m[10:0] : (data_hmult_8bit_1_msb_ext[25:16]+data_hmult_8bit_1_msb_ext[15]);//rounding 0.5=1, -0.5=-1
assign hmult_8bit_2_lsb[10:0] = (i8_less_neg_0_5_2_l)? data_hmult_8bit_2_lsb_ext[26:16] : (i8_more_neg_0_5_2_l)? i8_neg_add1_2_l[10:0] : (data_hmult_8bit_2_lsb_ext[25:16]+data_hmult_8bit_2_lsb_ext[15]);//rounding 0.5=1, -0.5=-1
assign hmult_8bit_2_msb[10:0] = (i8_less_neg_0_5_2_m)? data_hmult_8bit_2_msb_ext[26:16] : (i8_more_neg_0_5_2_m)? i8_neg_add1_2_m[10:0] : (data_hmult_8bit_2_msb_ext[25:16]+data_hmult_8bit_2_msb_ext[15]);//rounding 0.5=1, -0.5=-1
assign hmult_8bit_3_lsb[10:0] = (i8_less_neg_0_5_3_l)? data_hmult_8bit_3_lsb_ext[26:16] : (i8_more_neg_0_5_3_l)? i8_neg_add1_3_l[10:0] : (data_hmult_8bit_3_lsb_ext[25:16]+data_hmult_8bit_3_lsb_ext[15]);//rounding 0.5=1, -0.5=-1
assign hmult_8bit_3_msb[10:0] = (i8_less_neg_0_5_3_m)? data_hmult_8bit_3_msb_ext[26:16] : (i8_more_neg_0_5_3_m)? i8_neg_add1_3_m[10:0] : (data_hmult_8bit_3_msb_ext[25:16]+data_hmult_8bit_3_msb_ext[15]);//rounding 0.5=1, -0.5=-1

assign data_hmult_8bit_0[21:0]  = {hmult_8bit_0_msb[10:0],hmult_8bit_0_lsb[10:0]};
assign data_hmult_8bit_1[21:0]  = {hmult_8bit_1_msb[10:0],hmult_8bit_1_lsb[10:0]};
assign data_hmult_8bit_2[21:0]  = {hmult_8bit_2_msb[10:0],hmult_8bit_2_lsb[10:0]};
assign data_hmult_8bit_3[21:0]  = {hmult_8bit_3_msb[10:0],hmult_8bit_3_lsb[10:0]};
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_59x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_hmult_8bit_0_lsb_ext[30:29]) != (|data_hmult_8bit_0_lsb_ext[30:29])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_60x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_hmult_8bit_0_msb_ext[30:29]) != (|data_hmult_8bit_0_msb_ext[30:29])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_61x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_hmult_8bit_1_lsb_ext[30:29]) != (|data_hmult_8bit_1_lsb_ext[30:29])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_62x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_hmult_8bit_1_msb_ext[30:29]) != (|data_hmult_8bit_1_msb_ext[30:29])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_63x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_hmult_8bit_2_lsb_ext[30:29]) != (|data_hmult_8bit_2_lsb_ext[30:29])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_64x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_hmult_8bit_2_msb_ext[30:29]) != (|data_hmult_8bit_2_msb_ext[30:29])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_65x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_hmult_8bit_3_lsb_ext[30:29]) != (|data_hmult_8bit_3_lsb_ext[30:29])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_66x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_hmult_8bit_3_msb_ext[30:29]) != (|data_hmult_8bit_3_msb_ext[30:29])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign data_hmult_stage0_in0[21:0] = int8_en ? data_hmult_8bit_0 : ({{3{data_hmult_16bit_0[18]}}, data_hmult_16bit_0[18:0]});
assign data_hmult_stage0_in1[21:0] = int8_en ? data_hmult_8bit_1 : ({{3{data_hmult_16bit_1[18]}}, data_hmult_16bit_1[18:0]});
assign data_hmult_stage0_in2[21:0] = int8_en ? data_hmult_8bit_2 : ({{3{data_hmult_16bit_2[18]}}, data_hmult_16bit_2[18:0]});
assign data_hmult_stage0_in3[21:0] = int8_en ? data_hmult_8bit_3 : ({{3{data_hmult_16bit_3[18]}}, data_hmult_16bit_3[18:0]});

//load data to stage0
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_data_stage0_0 <= {22{1'b0}};
    pout_data_stage0_1 <= {22{1'b0}};
    pout_data_stage0_2 <= {22{1'b0}};
    pout_data_stage0_3 <= {22{1'b0}};
  end else begin
   //if(~(fp16_en & average_pooling_en)) begin
   if(~fp16_en & average_pooling_en) begin
       if(rd_pout_data_stage1) begin
              pout_data_stage0_0 <=  data_hmult_stage0_in0;
              pout_data_stage0_1 <=  data_hmult_stage0_in1;
              pout_data_stage0_2 <=  data_hmult_stage0_in2;
              pout_data_stage0_3 <=  data_hmult_stage0_in3;
       end
   end else if(rd_pout_data_stage1)begin
      if(int8_en) begin
        pout_data_stage0_0 <= {pout_data_0_0[24:14],pout_data_0_0[10:0]};
        pout_data_stage0_1 <= {pout_data_0_1[24:14],pout_data_0_1[10:0]};
        pout_data_stage0_2 <= {pout_data_0_2[24:14],pout_data_0_2[10:0]};
        pout_data_stage0_3 <= {pout_data_0_3[24:14],pout_data_0_3[10:0]};
      //end else if(int16_en) begin
      end else begin
        pout_data_stage0_0 <= pout_data_0_0[21:0];
        pout_data_stage0_1 <= pout_data_0_1[21:0];
        pout_data_stage0_2 <= pout_data_0_2[21:0];
        pout_data_stage0_3 <= pout_data_0_3[21:0];
      end
   end
  end
end

//===========================================================
//stage1: (* /kernel_height)
assign data_vmult_16bit_0_ext_ff[35:0] = $signed(pout_data_stage0_0[18:0]) * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_16bit_1_ext_ff[35:0] = $signed(pout_data_stage0_1[18:0]) * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_16bit_2_ext_ff[35:0] = $signed(pout_data_stage0_2[18:0]) * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_16bit_3_ext_ff[35:0] = $signed(pout_data_stage0_3[18:0]) * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_16bit_0_ext[35:0] = average_pooling_en ? data_vmult_16bit_0_ext_ff : {pout_data_stage0_0[18],pout_data_stage0_0[18:0],16'd0};
assign data_vmult_16bit_1_ext[35:0] = average_pooling_en ? data_vmult_16bit_1_ext_ff : {pout_data_stage0_1[18],pout_data_stage0_1[18:0],16'd0};
assign data_vmult_16bit_2_ext[35:0] = average_pooling_en ? data_vmult_16bit_2_ext_ff : {pout_data_stage0_2[18],pout_data_stage0_2[18:0],16'd0};
assign data_vmult_16bit_3_ext[35:0] = average_pooling_en ? data_vmult_16bit_3_ext_ff : {pout_data_stage0_3[18],pout_data_stage0_3[18:0],16'd0};
assign i16_vless_neg_0_5_0 = data_vmult_16bit_0_ext[35] & ((data_vmult_16bit_0_ext[15] & (~(|data_vmult_16bit_0_ext[14:0]))) | (~data_vmult_16bit_0_ext[15]));
assign i16_vless_neg_0_5_1 = data_vmult_16bit_1_ext[35] & ((data_vmult_16bit_1_ext[15] & (~(|data_vmult_16bit_1_ext[14:0]))) | (~data_vmult_16bit_1_ext[15]));
assign i16_vless_neg_0_5_2 = data_vmult_16bit_2_ext[35] & ((data_vmult_16bit_2_ext[15] & (~(|data_vmult_16bit_2_ext[14:0]))) | (~data_vmult_16bit_2_ext[15]));
assign i16_vless_neg_0_5_3 = data_vmult_16bit_3_ext[35] & ((data_vmult_16bit_3_ext[15] & (~(|data_vmult_16bit_3_ext[14:0]))) | (~data_vmult_16bit_3_ext[15]));
assign i16_vmore_neg_0_5_0 = data_vmult_16bit_0_ext[35] & data_vmult_16bit_0_ext[15] & (|data_vmult_16bit_0_ext[14:0]);
assign i16_vmore_neg_0_5_1 = data_vmult_16bit_1_ext[35] & data_vmult_16bit_1_ext[15] & (|data_vmult_16bit_1_ext[14:0]);
assign i16_vmore_neg_0_5_2 = data_vmult_16bit_2_ext[35] & data_vmult_16bit_2_ext[15] & (|data_vmult_16bit_2_ext[14:0]);
assign i16_vmore_neg_0_5_3 = data_vmult_16bit_3_ext[35] & data_vmult_16bit_3_ext[15] & (|data_vmult_16bit_3_ext[14:0]);
assign {mon_i16_neg_vadd1_0,i16_neg_vadd1_0[15:0]} = data_vmult_16bit_0_ext[31:16]+16'd1; 
assign {mon_i16_neg_vadd1_1,i16_neg_vadd1_1[15:0]} = data_vmult_16bit_1_ext[31:16]+16'd1;
assign {mon_i16_neg_vadd1_2,i16_neg_vadd1_2[15:0]} = data_vmult_16bit_2_ext[31:16]+16'd1;
assign {mon_i16_neg_vadd1_3,i16_neg_vadd1_3[15:0]} = data_vmult_16bit_3_ext[31:16]+16'd1;
assign data_vmult_16bit_0[15:0] = (i16_vless_neg_0_5_0)? data_vmult_16bit_0_ext[31:16] : (i16_vmore_neg_0_5_0)? i16_neg_vadd1_0[15:0]: (data_vmult_16bit_0_ext[30:16]+data_vmult_16bit_0_ext[15]);//rounding 0.5=1, -0.5=-1  
assign data_vmult_16bit_1[15:0] = (i16_vless_neg_0_5_1)? data_vmult_16bit_1_ext[31:16] : (i16_vmore_neg_0_5_1)? i16_neg_vadd1_1[15:0]: (data_vmult_16bit_1_ext[30:16]+data_vmult_16bit_1_ext[15]);//rounding 0.5=1, -0.5=-1 
assign data_vmult_16bit_2[15:0] = (i16_vless_neg_0_5_2)? data_vmult_16bit_2_ext[31:16] : (i16_vmore_neg_0_5_2)? i16_neg_vadd1_2[15:0]: (data_vmult_16bit_2_ext[30:16]+data_vmult_16bit_2_ext[15]);//rounding 0.5=1, -0.5=-1 
assign data_vmult_16bit_3[15:0] = (i16_vless_neg_0_5_3)? data_vmult_16bit_3_ext[31:16] : (i16_vmore_neg_0_5_3)? i16_neg_vadd1_3[15:0]: (data_vmult_16bit_3_ext[30:16]+data_vmult_16bit_3_ext[15]);//rounding 0.5=1, -0.5=-1 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_67x (nvdla_core_clk, `ASSERT_RESET, (int16_en & rd_pout_data_stage1 & ((&data_vmult_16bit_0_ext[35:34]) != (|data_vmult_16bit_0_ext[35:34])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_68x (nvdla_core_clk, `ASSERT_RESET, (int16_en & rd_pout_data_stage1 & ((&data_vmult_16bit_1_ext[35:34]) != (|data_vmult_16bit_1_ext[35:34])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_69x (nvdla_core_clk, `ASSERT_RESET, (int16_en & rd_pout_data_stage1 & ((&data_vmult_16bit_2_ext[35:34]) != (|data_vmult_16bit_2_ext[35:34])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB bits should be all same as signed bit")      zzz_assert_never_70x (nvdla_core_clk, `ASSERT_RESET, (int16_en & rd_pout_data_stage1 & ((&data_vmult_16bit_3_ext[35:34]) != (|data_vmult_16bit_3_ext[35:34])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//8bits
assign data_vmult_8bit_0_lsb_ext_ff[27:0] = $signed(pout_data_stage0_0[10:0])  * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_8bit_0_msb_ext_ff[27:0] = $signed(pout_data_stage0_0[21:11]) * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_8bit_1_lsb_ext_ff[27:0] = $signed(pout_data_stage0_1[10:0])  * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_8bit_1_msb_ext_ff[27:0] = $signed(pout_data_stage0_1[21:11]) * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_8bit_2_lsb_ext_ff[27:0] = $signed(pout_data_stage0_2[10:0])  * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_8bit_2_msb_ext_ff[27:0] = $signed(pout_data_stage0_2[21:11]) * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_8bit_3_lsb_ext_ff[27:0] = $signed(pout_data_stage0_3[10:0])  * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_8bit_3_msb_ext_ff[27:0] = $signed(pout_data_stage0_3[21:11]) * $signed({1'b0,reg2dp_recip_height_use[16:0]});
assign data_vmult_8bit_0_lsb_ext[27:0] = average_pooling_en ? data_vmult_8bit_0_lsb_ext_ff : {pout_data_stage0_0[10],pout_data_stage0_0[10:0] ,16'd0};
assign data_vmult_8bit_0_msb_ext[27:0] = average_pooling_en ? data_vmult_8bit_0_msb_ext_ff : {pout_data_stage0_0[21],pout_data_stage0_0[21:11],16'd0};
assign data_vmult_8bit_1_lsb_ext[27:0] = average_pooling_en ? data_vmult_8bit_1_lsb_ext_ff : {pout_data_stage0_1[10],pout_data_stage0_1[10:0] ,16'd0};
assign data_vmult_8bit_1_msb_ext[27:0] = average_pooling_en ? data_vmult_8bit_1_msb_ext_ff : {pout_data_stage0_1[21],pout_data_stage0_1[21:11],16'd0};
assign data_vmult_8bit_2_lsb_ext[27:0] = average_pooling_en ? data_vmult_8bit_2_lsb_ext_ff : {pout_data_stage0_2[10],pout_data_stage0_2[10:0] ,16'd0};
assign data_vmult_8bit_2_msb_ext[27:0] = average_pooling_en ? data_vmult_8bit_2_msb_ext_ff : {pout_data_stage0_2[21],pout_data_stage0_2[21:11],16'd0};
assign data_vmult_8bit_3_lsb_ext[27:0] = average_pooling_en ? data_vmult_8bit_3_lsb_ext_ff : {pout_data_stage0_3[10],pout_data_stage0_3[10:0] ,16'd0};
assign data_vmult_8bit_3_msb_ext[27:0] = average_pooling_en ? data_vmult_8bit_3_msb_ext_ff : {pout_data_stage0_3[21],pout_data_stage0_3[21:11],16'd0};

assign i8_vless_neg_0_5_0_l = data_vmult_8bit_0_lsb_ext[27] & ((data_vmult_8bit_0_lsb_ext[15] & (~(|data_vmult_8bit_0_lsb_ext[14:0]))) | (~data_vmult_8bit_0_lsb_ext[15]));
assign i8_vless_neg_0_5_0_m = data_vmult_8bit_0_msb_ext[27] & ((data_vmult_8bit_0_msb_ext[15] & (~(|data_vmult_8bit_0_msb_ext[14:0]))) | (~data_vmult_8bit_0_msb_ext[15]));
assign i8_vless_neg_0_5_1_l = data_vmult_8bit_1_lsb_ext[27] & ((data_vmult_8bit_1_lsb_ext[15] & (~(|data_vmult_8bit_1_lsb_ext[14:0]))) | (~data_vmult_8bit_1_lsb_ext[15]));
assign i8_vless_neg_0_5_1_m = data_vmult_8bit_1_msb_ext[27] & ((data_vmult_8bit_1_msb_ext[15] & (~(|data_vmult_8bit_1_msb_ext[14:0]))) | (~data_vmult_8bit_1_msb_ext[15]));
assign i8_vless_neg_0_5_2_l = data_vmult_8bit_2_lsb_ext[27] & ((data_vmult_8bit_2_lsb_ext[15] & (~(|data_vmult_8bit_2_lsb_ext[14:0]))) | (~data_vmult_8bit_2_lsb_ext[15]));
assign i8_vless_neg_0_5_2_m = data_vmult_8bit_2_msb_ext[27] & ((data_vmult_8bit_2_msb_ext[15] & (~(|data_vmult_8bit_2_msb_ext[14:0]))) | (~data_vmult_8bit_2_msb_ext[15]));
assign i8_vless_neg_0_5_3_l = data_vmult_8bit_3_lsb_ext[27] & ((data_vmult_8bit_3_lsb_ext[15] & (~(|data_vmult_8bit_3_lsb_ext[14:0]))) | (~data_vmult_8bit_3_lsb_ext[15]));
assign i8_vless_neg_0_5_3_m = data_vmult_8bit_3_msb_ext[27] & ((data_vmult_8bit_3_msb_ext[15] & (~(|data_vmult_8bit_3_msb_ext[14:0]))) | (~data_vmult_8bit_3_msb_ext[15]));
assign i8_vmore_neg_0_5_0_l = data_vmult_8bit_0_lsb_ext[27] & data_vmult_8bit_0_lsb_ext[15] & (|data_vmult_8bit_0_lsb_ext[14:0]);
assign i8_vmore_neg_0_5_0_m = data_vmult_8bit_0_msb_ext[27] & data_vmult_8bit_0_msb_ext[15] & (|data_vmult_8bit_0_msb_ext[14:0]);
assign i8_vmore_neg_0_5_1_l = data_vmult_8bit_1_lsb_ext[27] & data_vmult_8bit_1_lsb_ext[15] & (|data_vmult_8bit_1_lsb_ext[14:0]);
assign i8_vmore_neg_0_5_1_m = data_vmult_8bit_1_msb_ext[27] & data_vmult_8bit_1_msb_ext[15] & (|data_vmult_8bit_1_msb_ext[14:0]);
assign i8_vmore_neg_0_5_2_l = data_vmult_8bit_2_lsb_ext[27] & data_vmult_8bit_2_lsb_ext[15] & (|data_vmult_8bit_2_lsb_ext[14:0]);
assign i8_vmore_neg_0_5_2_m = data_vmult_8bit_2_msb_ext[27] & data_vmult_8bit_2_msb_ext[15] & (|data_vmult_8bit_2_msb_ext[14:0]);
assign i8_vmore_neg_0_5_3_l = data_vmult_8bit_3_lsb_ext[27] & data_vmult_8bit_3_lsb_ext[15] & (|data_vmult_8bit_3_lsb_ext[14:0]);
assign i8_vmore_neg_0_5_3_m = data_vmult_8bit_3_msb_ext[27] & data_vmult_8bit_3_msb_ext[15] & (|data_vmult_8bit_3_msb_ext[14:0]);
assign {mon_i8_neg_vadd1_0_l,i8_neg_vadd1_0_l[7:0]} = data_vmult_8bit_0_lsb_ext[23:16]+8'd1; 
assign {mon_i8_neg_vadd1_0_m,i8_neg_vadd1_0_m[7:0]} = data_vmult_8bit_0_msb_ext[23:16]+8'd1; 
assign {mon_i8_neg_vadd1_1_l,i8_neg_vadd1_1_l[7:0]} = data_vmult_8bit_1_lsb_ext[23:16]+8'd1;
assign {mon_i8_neg_vadd1_1_m,i8_neg_vadd1_1_m[7:0]} = data_vmult_8bit_1_msb_ext[23:16]+8'd1;
assign {mon_i8_neg_vadd1_2_l,i8_neg_vadd1_2_l[7:0]} = data_vmult_8bit_2_lsb_ext[23:16]+8'd1;
assign {mon_i8_neg_vadd1_2_m,i8_neg_vadd1_2_m[7:0]} = data_vmult_8bit_2_msb_ext[23:16]+8'd1;
assign {mon_i8_neg_vadd1_3_l,i8_neg_vadd1_3_l[7:0]} = data_vmult_8bit_3_lsb_ext[23:16]+8'd1;
assign {mon_i8_neg_vadd1_3_m,i8_neg_vadd1_3_m[7:0]} = data_vmult_8bit_3_msb_ext[23:16]+8'd1;
assign vmult_8bit_0_lsb[7:0]  = (i8_vless_neg_0_5_0_l)? data_vmult_8bit_0_lsb_ext[23:16] : (i8_vmore_neg_0_5_0_l)? i8_neg_vadd1_0_l[7:0] : (data_vmult_8bit_0_lsb_ext[22:16]+data_vmult_8bit_0_lsb_ext[15]);//rounding 0.5=1, -0.5=-1
assign vmult_8bit_0_msb[7:0]  = (i8_vless_neg_0_5_0_m)? data_vmult_8bit_0_msb_ext[23:16] : (i8_vmore_neg_0_5_0_m)? i8_neg_vadd1_0_m[7:0] : (data_vmult_8bit_0_msb_ext[22:16]+data_vmult_8bit_0_msb_ext[15]);//rounding 0.5=1, -0.5=-1
assign vmult_8bit_1_lsb[7:0]  = (i8_vless_neg_0_5_1_l)? data_vmult_8bit_1_lsb_ext[23:16] : (i8_vmore_neg_0_5_1_l)? i8_neg_vadd1_1_l[7:0] : (data_vmult_8bit_1_lsb_ext[22:16]+data_vmult_8bit_1_lsb_ext[15]);//rounding 0.5=1, -0.5=-1
assign vmult_8bit_1_msb[7:0]  = (i8_vless_neg_0_5_1_m)? data_vmult_8bit_1_msb_ext[23:16] : (i8_vmore_neg_0_5_1_m)? i8_neg_vadd1_1_m[7:0] : (data_vmult_8bit_1_msb_ext[22:16]+data_vmult_8bit_1_msb_ext[15]);//rounding 0.5=1, -0.5=-1
assign vmult_8bit_2_lsb[7:0]  = (i8_vless_neg_0_5_2_l)? data_vmult_8bit_2_lsb_ext[23:16] : (i8_vmore_neg_0_5_2_l)? i8_neg_vadd1_2_l[7:0] : (data_vmult_8bit_2_lsb_ext[22:16]+data_vmult_8bit_2_lsb_ext[15]);//rounding 0.5=1, -0.5=-1
assign vmult_8bit_2_msb[7:0]  = (i8_vless_neg_0_5_2_m)? data_vmult_8bit_2_msb_ext[23:16] : (i8_vmore_neg_0_5_2_m)? i8_neg_vadd1_2_m[7:0] : (data_vmult_8bit_2_msb_ext[22:16]+data_vmult_8bit_2_msb_ext[15]);//rounding 0.5=1, -0.5=-1
assign vmult_8bit_3_lsb[7:0]  = (i8_vless_neg_0_5_3_l)? data_vmult_8bit_3_lsb_ext[23:16] : (i8_vmore_neg_0_5_3_l)? i8_neg_vadd1_3_l[7:0] : (data_vmult_8bit_3_lsb_ext[22:16]+data_vmult_8bit_3_lsb_ext[15]);//rounding 0.5=1, -0.5=-1
assign vmult_8bit_3_msb[7:0]  = (i8_vless_neg_0_5_3_m)? data_vmult_8bit_3_msb_ext[23:16] : (i8_vmore_neg_0_5_3_m)? i8_neg_vadd1_3_m[7:0] : (data_vmult_8bit_3_msb_ext[22:16]+data_vmult_8bit_3_msb_ext[15]);//rounding 0.5=1, -0.5=-1

assign data_vmult_8bit_0[15:0] = {vmult_8bit_0_msb[7:0],vmult_8bit_0_lsb[7:0]};
assign data_vmult_8bit_1[15:0] = {vmult_8bit_1_msb[7:0],vmult_8bit_1_lsb[7:0]};
assign data_vmult_8bit_2[15:0] = {vmult_8bit_2_msb[7:0],vmult_8bit_2_lsb[7:0]};
assign data_vmult_8bit_3[15:0] = {vmult_8bit_3_msb[7:0],vmult_8bit_3_lsb[7:0]};
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB 4bits should be all same as signed bit")      zzz_assert_never_71x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_vmult_8bit_0_lsb_ext[27:26]) != (|data_vmult_8bit_0_lsb_ext[27:26])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB 4bits should be all same as signed bit")      zzz_assert_never_72x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_vmult_8bit_0_msb_ext[27:26]) != (|data_vmult_8bit_0_msb_ext[27:26])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB 4bits should be all same as signed bit")      zzz_assert_never_73x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_vmult_8bit_1_lsb_ext[27:26]) != (|data_vmult_8bit_1_lsb_ext[27:26])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB 4bits should be all same as signed bit")      zzz_assert_never_74x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_vmult_8bit_1_msb_ext[27:26]) != (|data_vmult_8bit_1_msb_ext[27:26])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB 4bits should be all same as signed bit")      zzz_assert_never_75x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_vmult_8bit_2_lsb_ext[27:26]) != (|data_vmult_8bit_2_lsb_ext[27:26])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB 4bits should be all same as signed bit")      zzz_assert_never_76x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_vmult_8bit_2_msb_ext[27:26]) != (|data_vmult_8bit_2_msb_ext[27:26])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB 4bits should be all same as signed bit")      zzz_assert_never_77x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_vmult_8bit_3_lsb_ext[27:26]) != (|data_vmult_8bit_3_lsb_ext[27:26])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore cal2d: the MSB 4bits should be all same as signed bit")      zzz_assert_never_78x (nvdla_core_clk, `ASSERT_RESET, (int8_en & rd_pout_data_stage1 & ((&data_vmult_8bit_3_msb_ext[27:26]) != (|data_vmult_8bit_3_msb_ext[27:26])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign data_mult_stage1_in0[15:0]     = int8_en ? data_vmult_8bit_0 : data_vmult_16bit_0;
assign data_mult_stage1_in1[15:0]     = int8_en ? data_vmult_8bit_1 : data_vmult_16bit_1;
assign data_mult_stage1_in2[15:0]     = int8_en ? data_vmult_8bit_2 : data_vmult_16bit_2;
assign data_mult_stage1_in3[15:0]     = int8_en ? data_vmult_8bit_3 : data_vmult_16bit_3;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_data_stage1_0 <= {16{1'b0}};
    pout_data_stage1_1 <= {16{1'b0}};
    pout_data_stage1_2 <= {16{1'b0}};
    pout_data_stage1_3 <= {16{1'b0}};
  end else begin
   if(~fp16_en & average_pooling_en) begin
       if(rd_pout_data_stage2) begin
           pout_data_stage1_0       <= data_mult_stage1_in0;
           pout_data_stage1_1       <= data_mult_stage1_in1;
           pout_data_stage1_2       <= data_mult_stage1_in2;
           pout_data_stage1_3       <= data_mult_stage1_in3;
       end
   end else if(rd_pout_data_stage2) begin
      if(int8_en) begin
        pout_data_stage1_0       <= {pout_data_stage0_0[18:11],pout_data_stage0_0[7:0]};
        pout_data_stage1_1       <= {pout_data_stage0_1[18:11],pout_data_stage0_1[7:0]};
        pout_data_stage1_2       <= {pout_data_stage0_2[18:11],pout_data_stage0_2[7:0]};
        pout_data_stage1_3       <= {pout_data_stage0_3[18:11],pout_data_stage0_3[7:0]};
      //end else if(int16_en) begin
      end else begin
        pout_data_stage1_0       <= pout_data_stage0_0[15:0];
        pout_data_stage1_1       <= pout_data_stage0_1[15:0];
        pout_data_stage1_2       <= pout_data_stage0_2[15:0];
        pout_data_stage1_3       <= pout_data_stage0_3[15:0];
      end
   end
  end
end
assign int_dp2wdma_pd = {pout_data_stage1_3,pout_data_stage1_2,pout_data_stage1_1,pout_data_stage1_0};
//assign int_dp2wdma_valid = pout_data_stage3_vld;
assign int_dp2wdma_valid = pout_data_stage3_vld & rd_pout_data_en_4d;
assign pout_data_stage3_prdy = (fp16_en & average_pooling_en) ? 1'b0 : pdp_dp2wdma_ready;

//======================================
//fp16 average process
//--------------------------------------

////=============================
////FP16 average mode, sum process
////-----------------------------
//assign fp16_add_in_rdy = fp16_mean_pool_cfg ? din_rdy : 1'b1;
/////////////////////////////////////////////////
////fp16 adder input data
//assign fp16_add_in_a = {pooling_datin[100:84],pooling_datin[72:56],pooling_datin[44:28],pooling_datin[16:0]};
//&PerlBeg;
//  for($i=0;$i<8; $i=$i+1){
//    vprintl( " assign fp16_add_in_b${i} = {mem_data${i}[100:84],mem_data${i}[72:56],mem_data${i}[44:28],mem_data${i}[16:0]}; ");
//    }
//&PerlEnd;
////fp16 adder, input valid, calculate valid
//&PerlBeg;
//  for($i=0;$i<8; $i=$i+1){
//    vprintl( " assign fp16_add_in_vld[$i] = fp16_mean_pool_cfg & (mem_re_2d[$i] & load_wr_stage2); ");
//    }
//&PerlEnd;
//&PerlBeg;
//  for($i=0;$i<8; $i=$i+1){
//    vprintl( "&Instance fp16_4add u_fp16_cal2d_pooling_sum_$i; ");
//    vprintl( " &Connect nvdla_core_clk        nvdla_op_gated_clk_fp16; ");
//    vprintl( " &Connect fp16_add_in_pvld      fp16_add_in_vld[$i];   ");
//    vprintl( " &Connect fp16_add_in_prdy      ;   ");
//    vprintl( " &Connect fp16_add_in_a         fp16_add_in_a;     ");
//    vprintl( " &Connect fp16_add_in_b         fp16_add_in_b${i}; ");
//    vprintl( " &Connect fp16_add_out_prdy     1'b1; ");
//    vprintl( " &Connect fp16_add_out_pvld     ;//fp_pooling_result_vld_$i; ");
//    vprintl( " &Connect fp16_add_out_dp       fp_pooling_result_dp_$i; ");
//    }
//&PerlEnd;
//
////data related info need sync with HLS fp17 adder latency
//assign din_vld = fp16_mean_pool_cfg & wr_data_stage1_vld;
//assign pooling_2d_info[31:0] = {pooling_2d_info_7[3:0],pooling_2d_info_6[3:0],pooling_2d_info_5[3:0],pooling_2d_info_4[3:0],
//                                pooling_2d_info_3[3:0],pooling_2d_info_2[3:0],pooling_2d_info_1[3:0],pooling_2d_info_0[3:0]};
//assign din_pd = {one_width_disable_2d,mem_re_2d[7:0],cur_datin_disable_2d,fp16_add_in_a[67:0],mem_re_1st_2d[7:0],pout_mem_data_sel_last[7:0],pooling_2d_info[31:0], pout_mem_data_sel[7:0], mem_raddr_2d[5:0], pout_mem_data_last[114:0]};
////pipe
//
//assign one_width_disable_2d_sync = dout_pd[254];
//assign mem_re_2d_sync = dout_pd[253:246];
//assign cur_datin_disable_2d_sync = dout_pd[245];
//assign fp16_add_in_a_sync = dout_pd[244:177];
//assign mem_re_1st_2d_sync = dout_pd[176:169];
//assign pout_mem_data_sel_last_sync = dout_pd[168:161];
//assign pooling_2d_info_sync = dout_pd[160:129];
//assign pout_mem_data_sel_sync = dout_pd[128:121];
//assign mem_raddr_2d_sync = dout_pd[120:115];
//assign pout_mem_data_last_sync = dout_pd[114:0];
//
//assign dout_rdy = fp16_mul_pad_line_prdy;
//assign fp_add_out_vld = dout_vld;
//assign fp_add_out_load = dout_vld & dout_rdy & (~cur_datin_disable_2d_sync) & (~one_width_disable_2d_sync);
////////////////////////////////////////////////
//assign pooling_datin_ext = {11'd0,fp16_add_in_a_sync[67:51],11'd0,fp16_add_in_a_sync[50:34],11'd0,fp16_add_in_a_sync[33:17],11'd0,fp16_add_in_a_sync[16:0]};
//&PerlBeg;
//  for($i=0;$i<8; $i=$i+1){
//    vprintl( " assign fp_add_out_dp_ext_$i = {11'd0,fp_pooling_result_dp_${i}[67:51],11'd0,fp_pooling_result_dp_${i}[50:34],11'd0,fp_pooling_result_dp_${i}[33:17],11'd0,fp_pooling_result_dp_${i}[16:0]}; ");
//    vprintl( " assign fp_pooling_result${i} = mem_re_1st_2d_sync[$i] ? {pooling_2d_info_sync[$i*4+3:$i*4],pooling_datin_ext} : {pooling_2d_info_sync[$i*4+3:$i*4],fp_add_out_dp_ext_$i}; ");
//    vprintl( " assign fp_mem_we[$i] = fp_add_out_load & mem_re_2d_sync[$i]; ");
//    vprintl( " assign fp_mem${i}_waddr = mem_raddr_2d_sync[5:0]; ");
//    vprintl( " assign fp_mem${i}_wdata = fp_pooling_result${i}; ");
//    }
//&PerlEnd;
//////////////////////////////////////////////////////////////////////////////
//&PerlBeg;
//  for($i=0;$i<8; $i=$i+1){
//    vprintl( " assign fp_pout_mem_data_sel[$i] = pout_mem_data_sel_sync[$i]; ");
//    vprintl( " assign fp_pout_mem_data_sel_last[$i] = pout_mem_data_sel_last_sync[$i]; ");
//    }
//&PerlEnd;
//assign fp_pout_mem_data_act = (fp_add_out_vld ? (fp_pooling_result0[114:0] & {115{fp_pout_mem_data_sel[0]}}) : 115'd0)
//                            | (fp_add_out_vld ? (fp_pooling_result1[114:0] & {115{fp_pout_mem_data_sel[1]}}) : 115'd0)
//                            | (fp_add_out_vld ? (fp_pooling_result2[114:0] & {115{fp_pout_mem_data_sel[2]}}) : 115'd0)
//                            | (fp_add_out_vld ? (fp_pooling_result3[114:0] & {115{fp_pout_mem_data_sel[3]}}) : 115'd0)
//                            | (fp_add_out_vld ? (fp_pooling_result4[114:0] & {115{fp_pout_mem_data_sel[4]}}) : 115'd0)
//                            | (fp_add_out_vld ? (fp_pooling_result5[114:0] & {115{fp_pout_mem_data_sel[5]}}) : 115'd0)
//                            | (fp_add_out_vld ? (fp_pooling_result6[114:0] & {115{fp_pout_mem_data_sel[6]}}) : 115'd0)
//                            | (fp_add_out_vld ? (fp_pooling_result7[114:0] & {115{fp_pout_mem_data_sel[7]}}) : 115'd0);
//
//assign fp_pout_mem_data_last = (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[0]}}) : 115'd0)
//                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[1]}}) : 115'd0)
//                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[2]}}) : 115'd0)
//                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[3]}}) : 115'd0)
//                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[4]}}) : 115'd0)
//                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[5]}}) : 115'd0)
//                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[6]}}) : 115'd0)
//                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[7]}}) : 115'd0);
//
//
//assign fp_pout_mem_data = fp_pout_mem_data_act | fp_pout_mem_data_last;
//
//
//////////////////////////////////////////////////////////////////////////////
////-----------------------------
//assign fp16_mulw_in_vld_f = (fp_add_out_vld ? (|(fp_pout_mem_data_sel | fp_pout_mem_data_sel_last)) : 1'b0);
//assign fp16_mulw_in_vld = fp16_mulw_in_vld_f;
////
////=============================
//=============================
//FP16 average mode, sum process
//-----------------------------
assign fp16_add_in_rdy = fp16_mean_pool_cfg ? (din_rdy & (&fp16_4add_in_prdy)) : 1'b1;
///////////////////////////////////////////////
assign fp16_mean_pool_valid =  fp16_mean_pool_cfg & wr_data_stage1_vld;

assign fp16_4add_in_pvld[0] = fp16_mean_pool_valid & (&{fp16_4add_in_prdy[7:1]                        }) & din_rdy;
assign fp16_4add_in_pvld[1] = fp16_mean_pool_valid & (&{fp16_4add_in_prdy[7:2], fp16_4add_in_prdy[0  ]}) & din_rdy;
assign fp16_4add_in_pvld[2] = fp16_mean_pool_valid & (&{fp16_4add_in_prdy[7:3], fp16_4add_in_prdy[1:0]}) & din_rdy;
assign fp16_4add_in_pvld[3] = fp16_mean_pool_valid & (&{fp16_4add_in_prdy[7:4], fp16_4add_in_prdy[2:0]}) & din_rdy;
assign fp16_4add_in_pvld[4] = fp16_mean_pool_valid & (&{fp16_4add_in_prdy[7:5], fp16_4add_in_prdy[3:0]}) & din_rdy;
assign fp16_4add_in_pvld[5] = fp16_mean_pool_valid & (&{fp16_4add_in_prdy[7:6], fp16_4add_in_prdy[4:0]}) & din_rdy;
assign fp16_4add_in_pvld[6] = fp16_mean_pool_valid & (&{fp16_4add_in_prdy[7  ], fp16_4add_in_prdy[5:0]}) & din_rdy;
assign fp16_4add_in_pvld[7] = fp16_mean_pool_valid & (&{                        fp16_4add_in_prdy[6:0]}) & din_rdy;

assign din_vld = fp16_mean_pool_valid & (&fp16_4add_in_prdy);

//fp16 adder input data
assign fp16_add_in_a = {pooling_datin[100:84],pooling_datin[72:56],pooling_datin[44:28],pooling_datin[16:0]};
 assign fp16_add_in_b0 = {mem_data0[100:84],mem_data0[72:56],mem_data0[44:28],mem_data0[16:0]}; 
 assign fp16_add_in_b1 = {mem_data1[100:84],mem_data1[72:56],mem_data1[44:28],mem_data1[16:0]}; 
 assign fp16_add_in_b2 = {mem_data2[100:84],mem_data2[72:56],mem_data2[44:28],mem_data2[16:0]}; 
 assign fp16_add_in_b3 = {mem_data3[100:84],mem_data3[72:56],mem_data3[44:28],mem_data3[16:0]}; 
 assign fp16_add_in_b4 = {mem_data4[100:84],mem_data4[72:56],mem_data4[44:28],mem_data4[16:0]}; 
 assign fp16_add_in_b5 = {mem_data5[100:84],mem_data5[72:56],mem_data5[44:28],mem_data5[16:0]}; 
 assign fp16_add_in_b6 = {mem_data6[100:84],mem_data6[72:56],mem_data6[44:28],mem_data6[16:0]}; 
 assign fp16_add_in_b7 = {mem_data7[100:84],mem_data7[72:56],mem_data7[44:28],mem_data7[16:0]}; 
fp16_4add u_fp16_cal2d_pooling_sum_0 (
   .fp16_add_in_a               (fp16_add_in_a[67:0])               //|< w
  ,.fp16_add_in_b               (fp16_add_in_b0[67:0])              //|< w
  ,.fp16_add_in_pvld            (fp16_4add_in_pvld[0])              //|< w
  ,.fp16_add_out_prdy           (fp16_4add_out_prdy[0])             //|< w
  ,.nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_add_in_prdy            (fp16_4add_in_prdy[0])              //|> w
  ,.fp16_add_out_dp             (fp_pooling_result_dp_0[67:0])      //|> w
  ,.fp16_add_out_pvld           (fp16_4add_out_pvld[0])             //|> w
  );
fp16_4add u_fp16_cal2d_pooling_sum_1 (
   .fp16_add_in_a               (fp16_add_in_a[67:0])               //|< w
  ,.fp16_add_in_b               (fp16_add_in_b1[67:0])              //|< w
  ,.fp16_add_in_pvld            (fp16_4add_in_pvld[1])              //|< w
  ,.fp16_add_out_prdy           (fp16_4add_out_prdy[1])             //|< w
  ,.nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_add_in_prdy            (fp16_4add_in_prdy[1])              //|> w
  ,.fp16_add_out_dp             (fp_pooling_result_dp_1[67:0])      //|> w
  ,.fp16_add_out_pvld           (fp16_4add_out_pvld[1])             //|> w
  );
fp16_4add u_fp16_cal2d_pooling_sum_2 (
   .fp16_add_in_a               (fp16_add_in_a[67:0])               //|< w
  ,.fp16_add_in_b               (fp16_add_in_b2[67:0])              //|< w
  ,.fp16_add_in_pvld            (fp16_4add_in_pvld[2])              //|< w
  ,.fp16_add_out_prdy           (fp16_4add_out_prdy[2])             //|< w
  ,.nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_add_in_prdy            (fp16_4add_in_prdy[2])              //|> w
  ,.fp16_add_out_dp             (fp_pooling_result_dp_2[67:0])      //|> w
  ,.fp16_add_out_pvld           (fp16_4add_out_pvld[2])             //|> w
  );
fp16_4add u_fp16_cal2d_pooling_sum_3 (
   .fp16_add_in_a               (fp16_add_in_a[67:0])               //|< w
  ,.fp16_add_in_b               (fp16_add_in_b3[67:0])              //|< w
  ,.fp16_add_in_pvld            (fp16_4add_in_pvld[3])              //|< w
  ,.fp16_add_out_prdy           (fp16_4add_out_prdy[3])             //|< w
  ,.nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_add_in_prdy            (fp16_4add_in_prdy[3])              //|> w
  ,.fp16_add_out_dp             (fp_pooling_result_dp_3[67:0])      //|> w
  ,.fp16_add_out_pvld           (fp16_4add_out_pvld[3])             //|> w
  );
fp16_4add u_fp16_cal2d_pooling_sum_4 (
   .fp16_add_in_a               (fp16_add_in_a[67:0])               //|< w
  ,.fp16_add_in_b               (fp16_add_in_b4[67:0])              //|< w
  ,.fp16_add_in_pvld            (fp16_4add_in_pvld[4])              //|< w
  ,.fp16_add_out_prdy           (fp16_4add_out_prdy[4])             //|< w
  ,.nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_add_in_prdy            (fp16_4add_in_prdy[4])              //|> w
  ,.fp16_add_out_dp             (fp_pooling_result_dp_4[67:0])      //|> w
  ,.fp16_add_out_pvld           (fp16_4add_out_pvld[4])             //|> w
  );
fp16_4add u_fp16_cal2d_pooling_sum_5 (
   .fp16_add_in_a               (fp16_add_in_a[67:0])               //|< w
  ,.fp16_add_in_b               (fp16_add_in_b5[67:0])              //|< w
  ,.fp16_add_in_pvld            (fp16_4add_in_pvld[5])              //|< w
  ,.fp16_add_out_prdy           (fp16_4add_out_prdy[5])             //|< w
  ,.nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_add_in_prdy            (fp16_4add_in_prdy[5])              //|> w
  ,.fp16_add_out_dp             (fp_pooling_result_dp_5[67:0])      //|> w
  ,.fp16_add_out_pvld           (fp16_4add_out_pvld[5])             //|> w
  );
fp16_4add u_fp16_cal2d_pooling_sum_6 (
   .fp16_add_in_a               (fp16_add_in_a[67:0])               //|< w
  ,.fp16_add_in_b               (fp16_add_in_b6[67:0])              //|< w
  ,.fp16_add_in_pvld            (fp16_4add_in_pvld[6])              //|< w
  ,.fp16_add_out_prdy           (fp16_4add_out_prdy[6])             //|< w
  ,.nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_add_in_prdy            (fp16_4add_in_prdy[6])              //|> w
  ,.fp16_add_out_dp             (fp_pooling_result_dp_6[67:0])      //|> w
  ,.fp16_add_out_pvld           (fp16_4add_out_pvld[6])             //|> w
  );
fp16_4add u_fp16_cal2d_pooling_sum_7 (
   .fp16_add_in_a               (fp16_add_in_a[67:0])               //|< w
  ,.fp16_add_in_b               (fp16_add_in_b7[67:0])              //|< w
  ,.fp16_add_in_pvld            (fp16_4add_in_pvld[7])              //|< w
  ,.fp16_add_out_prdy           (fp16_4add_out_prdy[7])             //|< w
  ,.nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_add_in_prdy            (fp16_4add_in_prdy[7])              //|> w
  ,.fp16_add_out_dp             (fp_pooling_result_dp_7[67:0])      //|> w
  ,.fp16_add_out_pvld           (fp16_4add_out_pvld[7])             //|> w
  );

//data related info need sync with HLS fp17 adder latency
assign pooling_2d_info[31:0] = {pooling_2d_info_7[3:0],pooling_2d_info_6[3:0],pooling_2d_info_5[3:0],pooling_2d_info_4[3:0],
                                pooling_2d_info_3[3:0],pooling_2d_info_2[3:0],pooling_2d_info_1[3:0],pooling_2d_info_0[3:0]};
assign din_pd = {one_width_disable_2d,mem_re_2d[7:0],cur_datin_disable_2d,fp16_add_in_a[67:0],mem_re_1st_2d[7:0],pout_mem_data_sel_last[7:0],pooling_2d_info[31:0], pout_mem_data_sel[7:0], mem_raddr_2d[5:0], pout_mem_data_last[114:0]};
//pipe

assign din_vld_d0 = din_vld;
assign din_rdy = din_rdy_d0;
assign din_pd_d0[254:0] = din_pd[254:0];
NV_NVDLA_PDP_CORE_CAL2D_pipe_p1 pipe_p1 (
   .nvdla_op_gated_clk_fp16     (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.din_pd_d0                   (din_pd_d0[254:0])                  //|< w
  ,.din_rdy_d1                  (din_rdy_d1)                        //|< w
  ,.din_vld_d0                  (din_vld_d0)                        //|< w
  ,.din_pd_d1                   (din_pd_d1[254:0])                  //|> w
  ,.din_rdy_d0                  (din_rdy_d0)                        //|> w
  ,.din_vld_d1                  (din_vld_d1)                        //|> w
  );
NV_NVDLA_PDP_CORE_CAL2D_pipe_p2 pipe_p2 (
   .nvdla_op_gated_clk_fp16     (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.din_pd_d1                   (din_pd_d1[254:0])                  //|< w
  ,.din_rdy_d2                  (din_rdy_d2)                        //|< w
  ,.din_vld_d1                  (din_vld_d1)                        //|< w
  ,.din_pd_d2                   (din_pd_d2[254:0])                  //|> w
  ,.din_rdy_d1                  (din_rdy_d1)                        //|> w
  ,.din_vld_d2                  (din_vld_d2)                        //|> w
  );
NV_NVDLA_PDP_CORE_CAL2D_pipe_p3 pipe_p3 (
   .nvdla_op_gated_clk_fp16     (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.din_pd_d2                   (din_pd_d2[254:0])                  //|< w
  ,.din_rdy_d3                  (din_rdy_d3)                        //|< w
  ,.din_vld_d2                  (din_vld_d2)                        //|< w
  ,.din_pd_d3                   (din_pd_d3[254:0])                  //|> w
  ,.din_rdy_d2                  (din_rdy_d2)                        //|> w
  ,.din_vld_d3                  (din_vld_d3)                        //|> w
  );
NV_NVDLA_PDP_CORE_CAL2D_pipe_p4 pipe_p4 (
   .nvdla_op_gated_clk_fp16     (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.din_pd_d3                   (din_pd_d3[254:0])                  //|< w
  ,.din_rdy_d4                  (din_rdy_d4)                        //|< w
  ,.din_vld_d3                  (din_vld_d3)                        //|< w
  ,.din_pd_d4                   (din_pd_d4[254:0])                  //|> w
  ,.din_rdy_d3                  (din_rdy_d3)                        //|> w
  ,.din_vld_d4                  (din_vld_d4)                        //|> w
  );
assign dout_vld = din_vld_d4;
assign din_rdy_d4 = dout_rdy;
assign dout_pd[254:0] = din_pd_d4[254:0];


assign one_width_disable_2d_sync = dout_pd[254];
assign mem_re_2d_sync = dout_pd[253:246];
assign cur_datin_disable_2d_sync = dout_pd[245];
assign fp16_add_in_a_sync = dout_pd[244:177];
assign mem_re_1st_2d_sync = dout_pd[176:169];
assign pout_mem_data_sel_last_sync = dout_pd[168:161];
assign pooling_2d_info_sync = dout_pd[160:129];
assign pout_mem_data_sel_sync = dout_pd[128:121];
assign mem_raddr_2d_sync = dout_pd[120:115];
assign pout_mem_data_last_sync = dout_pd[114:0];

assign dout_rdy = fp16_mul_pad_line_prdy & (&fp16_4add_out_pvld);
assign fp16_4add_out_prdy[0] = fp16_mul_pad_line_prdy & (&{fp16_4add_out_pvld[7:1]}) & dout_vld;
assign fp16_4add_out_prdy[1] = fp16_mul_pad_line_prdy & (&{fp16_4add_out_pvld[7:2],fp16_4add_out_pvld[0  ]}) & dout_vld;
assign fp16_4add_out_prdy[2] = fp16_mul_pad_line_prdy & (&{fp16_4add_out_pvld[7:3],fp16_4add_out_pvld[1:0]}) & dout_vld;
assign fp16_4add_out_prdy[3] = fp16_mul_pad_line_prdy & (&{fp16_4add_out_pvld[7:4],fp16_4add_out_pvld[2:0]}) & dout_vld;
assign fp16_4add_out_prdy[4] = fp16_mul_pad_line_prdy & (&{fp16_4add_out_pvld[7:5],fp16_4add_out_pvld[3:0]}) & dout_vld;
assign fp16_4add_out_prdy[5] = fp16_mul_pad_line_prdy & (&{fp16_4add_out_pvld[7:6],fp16_4add_out_pvld[4:0]}) & dout_vld;
assign fp16_4add_out_prdy[6] = fp16_mul_pad_line_prdy & (&{fp16_4add_out_pvld[7  ],fp16_4add_out_pvld[5:0]}) & dout_vld;
assign fp16_4add_out_prdy[7] = fp16_mul_pad_line_prdy & (&{                        fp16_4add_out_pvld[6:0]}) & dout_vld;

assign fp_add_out_vld = dout_vld & (&fp16_4add_out_pvld);

//assign fp_add_out_load = dout_vld & dout_rdy & (~cur_datin_disable_2d_sync) & (~one_width_disable_2d_sync);
assign fp_add_out_load = fp_add_out_vld & fp16_mul_pad_line_prdy & (~cur_datin_disable_2d_sync) & (~one_width_disable_2d_sync);
//////////////////////////////////////////////
assign pooling_datin_ext = {11'd0,fp16_add_in_a_sync[67:51],11'd0,fp16_add_in_a_sync[50:34],11'd0,fp16_add_in_a_sync[33:17],11'd0,fp16_add_in_a_sync[16:0]};
 assign fp_add_out_dp_ext_0 = {11'd0,fp_pooling_result_dp_0[67:51],11'd0,fp_pooling_result_dp_0[50:34],11'd0,fp_pooling_result_dp_0[33:17],11'd0,fp_pooling_result_dp_0[16:0]}; 
 assign fp_pooling_result0 = mem_re_1st_2d_sync[0] ? {pooling_2d_info_sync[0*4+3:0*4],pooling_datin_ext} : {pooling_2d_info_sync[0*4+3:0*4],fp_add_out_dp_ext_0}; 
 assign fp_mem_we[0] = fp_add_out_load & mem_re_2d_sync[0]; 
 assign fp_mem0_waddr = mem_raddr_2d_sync[5:0]; 
 assign fp_mem0_wdata = fp_pooling_result0; 
 assign fp_add_out_dp_ext_1 = {11'd0,fp_pooling_result_dp_1[67:51],11'd0,fp_pooling_result_dp_1[50:34],11'd0,fp_pooling_result_dp_1[33:17],11'd0,fp_pooling_result_dp_1[16:0]}; 
 assign fp_pooling_result1 = mem_re_1st_2d_sync[1] ? {pooling_2d_info_sync[1*4+3:1*4],pooling_datin_ext} : {pooling_2d_info_sync[1*4+3:1*4],fp_add_out_dp_ext_1}; 
 assign fp_mem_we[1] = fp_add_out_load & mem_re_2d_sync[1]; 
 assign fp_mem1_waddr = mem_raddr_2d_sync[5:0]; 
 assign fp_mem1_wdata = fp_pooling_result1; 
 assign fp_add_out_dp_ext_2 = {11'd0,fp_pooling_result_dp_2[67:51],11'd0,fp_pooling_result_dp_2[50:34],11'd0,fp_pooling_result_dp_2[33:17],11'd0,fp_pooling_result_dp_2[16:0]}; 
 assign fp_pooling_result2 = mem_re_1st_2d_sync[2] ? {pooling_2d_info_sync[2*4+3:2*4],pooling_datin_ext} : {pooling_2d_info_sync[2*4+3:2*4],fp_add_out_dp_ext_2}; 
 assign fp_mem_we[2] = fp_add_out_load & mem_re_2d_sync[2]; 
 assign fp_mem2_waddr = mem_raddr_2d_sync[5:0]; 
 assign fp_mem2_wdata = fp_pooling_result2; 
 assign fp_add_out_dp_ext_3 = {11'd0,fp_pooling_result_dp_3[67:51],11'd0,fp_pooling_result_dp_3[50:34],11'd0,fp_pooling_result_dp_3[33:17],11'd0,fp_pooling_result_dp_3[16:0]}; 
 assign fp_pooling_result3 = mem_re_1st_2d_sync[3] ? {pooling_2d_info_sync[3*4+3:3*4],pooling_datin_ext} : {pooling_2d_info_sync[3*4+3:3*4],fp_add_out_dp_ext_3}; 
 assign fp_mem_we[3] = fp_add_out_load & mem_re_2d_sync[3]; 
 assign fp_mem3_waddr = mem_raddr_2d_sync[5:0]; 
 assign fp_mem3_wdata = fp_pooling_result3; 
 assign fp_add_out_dp_ext_4 = {11'd0,fp_pooling_result_dp_4[67:51],11'd0,fp_pooling_result_dp_4[50:34],11'd0,fp_pooling_result_dp_4[33:17],11'd0,fp_pooling_result_dp_4[16:0]}; 
 assign fp_pooling_result4 = mem_re_1st_2d_sync[4] ? {pooling_2d_info_sync[4*4+3:4*4],pooling_datin_ext} : {pooling_2d_info_sync[4*4+3:4*4],fp_add_out_dp_ext_4}; 
 assign fp_mem_we[4] = fp_add_out_load & mem_re_2d_sync[4]; 
 assign fp_mem4_waddr = mem_raddr_2d_sync[5:0]; 
 assign fp_mem4_wdata = fp_pooling_result4; 
 assign fp_add_out_dp_ext_5 = {11'd0,fp_pooling_result_dp_5[67:51],11'd0,fp_pooling_result_dp_5[50:34],11'd0,fp_pooling_result_dp_5[33:17],11'd0,fp_pooling_result_dp_5[16:0]}; 
 assign fp_pooling_result5 = mem_re_1st_2d_sync[5] ? {pooling_2d_info_sync[5*4+3:5*4],pooling_datin_ext} : {pooling_2d_info_sync[5*4+3:5*4],fp_add_out_dp_ext_5}; 
 assign fp_mem_we[5] = fp_add_out_load & mem_re_2d_sync[5]; 
 assign fp_mem5_waddr = mem_raddr_2d_sync[5:0]; 
 assign fp_mem5_wdata = fp_pooling_result5; 
 assign fp_add_out_dp_ext_6 = {11'd0,fp_pooling_result_dp_6[67:51],11'd0,fp_pooling_result_dp_6[50:34],11'd0,fp_pooling_result_dp_6[33:17],11'd0,fp_pooling_result_dp_6[16:0]}; 
 assign fp_pooling_result6 = mem_re_1st_2d_sync[6] ? {pooling_2d_info_sync[6*4+3:6*4],pooling_datin_ext} : {pooling_2d_info_sync[6*4+3:6*4],fp_add_out_dp_ext_6}; 
 assign fp_mem_we[6] = fp_add_out_load & mem_re_2d_sync[6]; 
 assign fp_mem6_waddr = mem_raddr_2d_sync[5:0]; 
 assign fp_mem6_wdata = fp_pooling_result6; 
 assign fp_add_out_dp_ext_7 = {11'd0,fp_pooling_result_dp_7[67:51],11'd0,fp_pooling_result_dp_7[50:34],11'd0,fp_pooling_result_dp_7[33:17],11'd0,fp_pooling_result_dp_7[16:0]}; 
 assign fp_pooling_result7 = mem_re_1st_2d_sync[7] ? {pooling_2d_info_sync[7*4+3:7*4],pooling_datin_ext} : {pooling_2d_info_sync[7*4+3:7*4],fp_add_out_dp_ext_7}; 
 assign fp_mem_we[7] = fp_add_out_load & mem_re_2d_sync[7]; 
 assign fp_mem7_waddr = mem_raddr_2d_sync[5:0]; 
 assign fp_mem7_wdata = fp_pooling_result7; 
////////////////////////////////////////////////////////////////////////////
 assign fp_pout_mem_data_sel[0] = pout_mem_data_sel_sync[0]; 
 assign fp_pout_mem_data_sel_last[0] = pout_mem_data_sel_last_sync[0]; 
 assign fp_pout_mem_data_sel[1] = pout_mem_data_sel_sync[1]; 
 assign fp_pout_mem_data_sel_last[1] = pout_mem_data_sel_last_sync[1]; 
 assign fp_pout_mem_data_sel[2] = pout_mem_data_sel_sync[2]; 
 assign fp_pout_mem_data_sel_last[2] = pout_mem_data_sel_last_sync[2]; 
 assign fp_pout_mem_data_sel[3] = pout_mem_data_sel_sync[3]; 
 assign fp_pout_mem_data_sel_last[3] = pout_mem_data_sel_last_sync[3]; 
 assign fp_pout_mem_data_sel[4] = pout_mem_data_sel_sync[4]; 
 assign fp_pout_mem_data_sel_last[4] = pout_mem_data_sel_last_sync[4]; 
 assign fp_pout_mem_data_sel[5] = pout_mem_data_sel_sync[5]; 
 assign fp_pout_mem_data_sel_last[5] = pout_mem_data_sel_last_sync[5]; 
 assign fp_pout_mem_data_sel[6] = pout_mem_data_sel_sync[6]; 
 assign fp_pout_mem_data_sel_last[6] = pout_mem_data_sel_last_sync[6]; 
 assign fp_pout_mem_data_sel[7] = pout_mem_data_sel_sync[7]; 
 assign fp_pout_mem_data_sel_last[7] = pout_mem_data_sel_last_sync[7]; 
assign fp_pout_mem_data_act = (fp_add_out_vld ? (fp_pooling_result0[114:0] & {115{fp_pout_mem_data_sel[0]}}) : 115'd0)
                            | (fp_add_out_vld ? (fp_pooling_result1[114:0] & {115{fp_pout_mem_data_sel[1]}}) : 115'd0)
                            | (fp_add_out_vld ? (fp_pooling_result2[114:0] & {115{fp_pout_mem_data_sel[2]}}) : 115'd0)
                            | (fp_add_out_vld ? (fp_pooling_result3[114:0] & {115{fp_pout_mem_data_sel[3]}}) : 115'd0)
                            | (fp_add_out_vld ? (fp_pooling_result4[114:0] & {115{fp_pout_mem_data_sel[4]}}) : 115'd0)
                            | (fp_add_out_vld ? (fp_pooling_result5[114:0] & {115{fp_pout_mem_data_sel[5]}}) : 115'd0)
                            | (fp_add_out_vld ? (fp_pooling_result6[114:0] & {115{fp_pout_mem_data_sel[6]}}) : 115'd0)
                            | (fp_add_out_vld ? (fp_pooling_result7[114:0] & {115{fp_pout_mem_data_sel[7]}}) : 115'd0);

assign fp_pout_mem_data_last = (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[0]}}) : 115'd0)
                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[1]}}) : 115'd0)
                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[2]}}) : 115'd0)
                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[3]}}) : 115'd0)
                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[4]}}) : 115'd0)
                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[5]}}) : 115'd0)
                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[6]}}) : 115'd0)
                             | (fp_add_out_vld ? (pout_mem_data_last_sync[114:0] & {115{fp_pout_mem_data_sel_last[7]}}) : 115'd0);

assign fp_pout_mem_data = fp_pout_mem_data_act | fp_pout_mem_data_last;

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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_79x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel[0]&(|{|fp_pout_mem_data_sel_last,fp_pout_mem_data_sel[7:1]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_80x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel[1]&(|{|fp_pout_mem_data_sel_last,fp_pout_mem_data_sel[7:2],fp_pout_mem_data_sel[0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_81x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel[2]&(|{|fp_pout_mem_data_sel_last,fp_pout_mem_data_sel[7:3],fp_pout_mem_data_sel[1:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_82x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel[3]&(|{|fp_pout_mem_data_sel_last,fp_pout_mem_data_sel[7:4],fp_pout_mem_data_sel[2:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_83x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel[4]&(|{|fp_pout_mem_data_sel_last,fp_pout_mem_data_sel[7:5],fp_pout_mem_data_sel[3:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_84x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel[5]&(|{|fp_pout_mem_data_sel_last,fp_pout_mem_data_sel[7:6],fp_pout_mem_data_sel[4:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_85x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel[6]&(|{|fp_pout_mem_data_sel_last,fp_pout_mem_data_sel[7  ],fp_pout_mem_data_sel[5:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_86x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel[7]&(|{|fp_pout_mem_data_sel_last,fp_pout_mem_data_sel[6:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_87x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel_last[0]&(|{|fp_pout_mem_data_sel,fp_pout_mem_data_sel_last[7:1]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_88x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel_last[1]&(|{|fp_pout_mem_data_sel,fp_pout_mem_data_sel_last[7:2],fp_pout_mem_data_sel_last[0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_89x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel_last[2]&(|{|fp_pout_mem_data_sel,fp_pout_mem_data_sel_last[7:3],fp_pout_mem_data_sel_last[1:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_90x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel_last[3]&(|{|fp_pout_mem_data_sel,fp_pout_mem_data_sel_last[7:4],fp_pout_mem_data_sel_last[2:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_91x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel_last[4]&(|{|fp_pout_mem_data_sel,fp_pout_mem_data_sel_last[7:5],fp_pout_mem_data_sel_last[3:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_92x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel_last[5]&(|{|fp_pout_mem_data_sel,fp_pout_mem_data_sel_last[7:6],fp_pout_mem_data_sel_last[4:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_93x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel_last[6]&(|{|fp_pout_mem_data_sel,fp_pout_mem_data_sel_last[7  ],fp_pout_mem_data_sel_last[5:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDP cal2d: line buffers shouldn't output at same time")      zzz_assert_never_94x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_pout_mem_data_sel_last[7]&(|{|fp_pout_mem_data_sel,fp_pout_mem_data_sel_last[6:0]})); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////////
//-----------------------------
assign fp16_mulw_in_vld = (fp_add_out_vld ? (|(fp_pout_mem_data_sel | fp_pout_mem_data_sel_last)) : 1'b0);

//
//=============================

//=============================
//pad_value_x * kernel_width
//-----------------------------
//kernel_width config in fp17 mode
always @(
  reg2dp_kernel_width
  ) begin
    case(reg2dp_kernel_width[2:0])
    3'h0: kernel_width_fp17 = 17'h7c00;
    3'h1: kernel_width_fp17 = 17'h8000;
    3'h2: kernel_width_fp17 = 17'h8200;
    3'h3: kernel_width_fp17 = 17'h8400;
    3'h4: kernel_width_fp17 = 17'h8500;
    3'h5: kernel_width_fp17 = 17'h8600;
    3'h6: kernel_width_fp17 = 17'h8700;
    3'h7: kernel_width_fp17 = 17'h8800;
  //VCS coverage off
    default: kernel_width_fp17 = 17'h0;
  //VCS coverage on
    endcase
end

//valid/ready control
assign fp16_mul_pad_line_prdy = &fp16_mul_pad_line_rdy[1:0] & fp16_mul_pad_line_in_rdy;

assign fp16_mul_pad_line_vld[0] = fp16_mulw_in_vld & fp16_mul_pad_line_rdy[1] & fp16_mul_pad_line_in_rdy;
assign fp16_mul_pad_line_vld[1] = fp16_mulw_in_vld & fp16_mul_pad_line_rdy[0] & fp16_mul_pad_line_in_rdy;
assign fp16_mul_pad_line_in_vld[0] = fp16_mulw_in_vld & (&fp16_mul_pad_line_rdy[1:0]);

assign fp16_mul_pad_line_in_pd = fp_pout_mem_data;
assign fp_mem_size_v = fp_pout_mem_data[114:112];

HLS_fp17_mul mul_padx_kwidth (
   .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.chn_a_rsc_z                 (pad_table_out[16:0])               //|< r
  ,.chn_a_rsc_vz                (fp16_mul_pad_line_vld[0])          //|< w
  ,.chn_a_rsc_lz                (fp16_mul_pad_line_rdy[0])          //|> w
  ,.chn_b_rsc_z                 (kernel_width_fp17[16:0])           //|< r
  ,.chn_b_rsc_vz                (fp16_mul_pad_line_vld[1])          //|< w
  ,.chn_b_rsc_lz                (fp16_mul_pad_line_rdy[1])          //|> w
  ,.chn_o_rsc_z                 (pad_line_sum[16:0])                //|> w
  ,.chn_o_rsc_vz                (pad_line_sum_prdy)                 //|< w
  ,.chn_o_rsc_lz                (pad_line_sum_pvld)                 //|> w
  );


assign fp16_mul_pad_line_in_vld_d0 = fp16_mul_pad_line_in_vld;
assign fp16_mul_pad_line_in_rdy = fp16_mul_pad_line_in_rdy_d0;
assign fp16_mul_pad_line_in_pd_d0[114:0] = fp16_mul_pad_line_in_pd[114:0];
NV_NVDLA_PDP_CORE_CAL2D_pipe_p5 pipe_p5 (
   .nvdla_op_gated_clk_fp16     (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_mul_pad_line_in_pd_d0  (fp16_mul_pad_line_in_pd_d0[114:0]) //|< w
  ,.fp16_mul_pad_line_in_rdy_d1 (fp16_mul_pad_line_in_rdy_d1)       //|< w
  ,.fp16_mul_pad_line_in_vld_d0 (fp16_mul_pad_line_in_vld_d0)       //|< w
  ,.fp16_mul_pad_line_in_pd_d1  (fp16_mul_pad_line_in_pd_d1[114:0]) //|> w
  ,.fp16_mul_pad_line_in_rdy_d0 (fp16_mul_pad_line_in_rdy_d0)       //|> w
  ,.fp16_mul_pad_line_in_vld_d1 (fp16_mul_pad_line_in_vld_d1)       //|> w
  );
NV_NVDLA_PDP_CORE_CAL2D_pipe_p6 pipe_p6 (
   .nvdla_op_gated_clk_fp16     (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_mul_pad_line_in_pd_d1  (fp16_mul_pad_line_in_pd_d1[114:0]) //|< w
  ,.fp16_mul_pad_line_in_rdy_d2 (fp16_mul_pad_line_in_rdy_d2)       //|< w
  ,.fp16_mul_pad_line_in_vld_d1 (fp16_mul_pad_line_in_vld_d1)       //|< w
  ,.fp16_mul_pad_line_in_pd_d2  (fp16_mul_pad_line_in_pd_d2[114:0]) //|> w
  ,.fp16_mul_pad_line_in_rdy_d1 (fp16_mul_pad_line_in_rdy_d1)       //|> w
  ,.fp16_mul_pad_line_in_vld_d2 (fp16_mul_pad_line_in_vld_d2)       //|> w
  );
NV_NVDLA_PDP_CORE_CAL2D_pipe_p7 pipe_p7 (
   .nvdla_op_gated_clk_fp16     (nvdla_op_gated_clk_fp16)           //|< i
  ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
  ,.fp16_mul_pad_line_in_pd_d2  (fp16_mul_pad_line_in_pd_d2[114:0]) //|< w
  ,.fp16_mul_pad_line_in_rdy_d3 (fp16_mul_pad_line_in_rdy_d3)       //|< w
  ,.fp16_mul_pad_line_in_vld_d2 (fp16_mul_pad_line_in_vld_d2)       //|< w
  ,.fp16_mul_pad_line_in_pd_d3  (fp16_mul_pad_line_in_pd_d3[114:0]) //|> w
  ,.fp16_mul_pad_line_in_rdy_d2 (fp16_mul_pad_line_in_rdy_d2)       //|> w
  ,.fp16_mul_pad_line_in_vld_d3 (fp16_mul_pad_line_in_vld_d3)       //|> w
  );
assign fp16_mul_pad_line_out_vld = fp16_mul_pad_line_in_vld_d3;
assign fp16_mul_pad_line_in_rdy_d3 = fp16_mul_pad_line_out_rdy;
assign fp16_mul_pad_line_out_pd[114:0] = fp16_mul_pad_line_in_pd_d3[114:0];


assign fp16_mul_pad_line_out_rdy = fp_mulw_prdy & pad_line_sum_pvld;
assign pad_line_sum_prdy = fp_mulw_prdy & fp16_mul_pad_line_out_vld;

assign fp16_mul_pad_line_pvld = pad_line_sum_pvld & fp16_mul_pad_line_out_vld;

assign fp16_pout_mem_data = fp16_mul_pad_line_out_pd[114:0];
//=============================
//FP16 process for (+ pad_value_x)
//-----------------------------
assign fp_mulw_prdy     = &{fp16_add_pad_in_a_rdy, fp16_add_pad_in_b_rdy} ; 
assign fp16_add_pad_in_a_vld[0] = fp16_mul_pad_line_pvld & (&{fp16_add_pad_in_b_rdy,fp16_add_pad_in_a_rdy[3:1]});
assign fp16_add_pad_in_a_vld[1] = fp16_mul_pad_line_pvld & (&{fp16_add_pad_in_b_rdy,fp16_add_pad_in_a_rdy[3:2],fp16_add_pad_in_a_rdy[0]});
assign fp16_add_pad_in_a_vld[2] = fp16_mul_pad_line_pvld & (&{fp16_add_pad_in_b_rdy,fp16_add_pad_in_a_rdy[3]  ,fp16_add_pad_in_a_rdy[1:0]});
assign fp16_add_pad_in_a_vld[3] = fp16_mul_pad_line_pvld & (&{fp16_add_pad_in_b_rdy,fp16_add_pad_in_a_rdy[2:0]});
assign fp16_add_pad_in_b_vld[0] = fp16_mul_pad_line_pvld & (&{fp16_add_pad_in_a_rdy,fp16_add_pad_in_b_rdy[3:1]});
assign fp16_add_pad_in_b_vld[1] = fp16_mul_pad_line_pvld & (&{fp16_add_pad_in_a_rdy,fp16_add_pad_in_b_rdy[3:2],fp16_add_pad_in_b_rdy[0]});
assign fp16_add_pad_in_b_vld[2] = fp16_mul_pad_line_pvld & (&{fp16_add_pad_in_a_rdy,fp16_add_pad_in_b_rdy[3]  ,fp16_add_pad_in_b_rdy[1:0]});
assign fp16_add_pad_in_b_vld[3] = fp16_mul_pad_line_pvld & (&{fp16_add_pad_in_a_rdy,fp16_add_pad_in_b_rdy[2:0]});

 HLS_fp17_add u_HLS_fp17_add_0 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_pout_mem_data[16:0])          //|< w
   ,.chn_a_rsc_vz                (fp16_add_pad_in_a_vld[0])          //|< w
   ,.chn_a_rsc_lz                (fp16_add_pad_in_a_rdy[0])          //|> w
   ,.chn_b_rsc_z                 (pad_line_sum[16:0])                //|< w
   ,.chn_b_rsc_vz                (fp16_add_pad_in_b_vld[0])          //|< w
   ,.chn_b_rsc_lz                (fp16_add_pad_in_b_rdy[0])          //|> w
   ,.chn_o_rsc_z                 (fp16_add_pad_out0[16:0])           //|> w
   ,.chn_o_rsc_vz                (fp16_add_pad_out_rdy[0])           //|< w
   ,.chn_o_rsc_lz                (fp16_add_pad_out_vld[0])           //|> w
   );
 HLS_fp17_add u_HLS_fp17_add_1 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_pout_mem_data[44:28])         //|< w
   ,.chn_a_rsc_vz                (fp16_add_pad_in_a_vld[1])          //|< w
   ,.chn_a_rsc_lz                (fp16_add_pad_in_a_rdy[1])          //|> w
   ,.chn_b_rsc_z                 (pad_line_sum[16:0])                //|< w
   ,.chn_b_rsc_vz                (fp16_add_pad_in_b_vld[1])          //|< w
   ,.chn_b_rsc_lz                (fp16_add_pad_in_b_rdy[1])          //|> w
   ,.chn_o_rsc_z                 (fp16_add_pad_out1[16:0])           //|> w
   ,.chn_o_rsc_vz                (fp16_add_pad_out_rdy[1])           //|< w
   ,.chn_o_rsc_lz                (fp16_add_pad_out_vld[1])           //|> w
   );
 HLS_fp17_add u_HLS_fp17_add_2 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_pout_mem_data[72:56])         //|< w
   ,.chn_a_rsc_vz                (fp16_add_pad_in_a_vld[2])          //|< w
   ,.chn_a_rsc_lz                (fp16_add_pad_in_a_rdy[2])          //|> w
   ,.chn_b_rsc_z                 (pad_line_sum[16:0])                //|< w
   ,.chn_b_rsc_vz                (fp16_add_pad_in_b_vld[2])          //|< w
   ,.chn_b_rsc_lz                (fp16_add_pad_in_b_rdy[2])          //|> w
   ,.chn_o_rsc_z                 (fp16_add_pad_out2[16:0])           //|> w
   ,.chn_o_rsc_vz                (fp16_add_pad_out_rdy[2])           //|< w
   ,.chn_o_rsc_lz                (fp16_add_pad_out_vld[2])           //|> w
   );
 HLS_fp17_add u_HLS_fp17_add_3 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_pout_mem_data[100:84])        //|< w
   ,.chn_a_rsc_vz                (fp16_add_pad_in_a_vld[3])          //|< w
   ,.chn_a_rsc_lz                (fp16_add_pad_in_a_rdy[3])          //|> w
   ,.chn_b_rsc_z                 (pad_line_sum[16:0])                //|< w
   ,.chn_b_rsc_vz                (fp16_add_pad_in_b_vld[3])          //|< w
   ,.chn_b_rsc_lz                (fp16_add_pad_in_b_rdy[3])          //|> w
   ,.chn_o_rsc_z                 (fp16_add_pad_out3[16:0])           //|> w
   ,.chn_o_rsc_vz                (fp16_add_pad_out_rdy[3])           //|< w
   ,.chn_o_rsc_lz                (fp16_add_pad_out_vld[3])           //|> w
   );

assign fp16_add_pad_out_rdy[0] = fp16_mulw_rdy & (&{fp16_add_pad_out_vld[3:1]});
assign fp16_add_pad_out_rdy[1] = fp16_mulw_rdy & (&{fp16_add_pad_out_vld[3:2], fp16_add_pad_out_vld[0]});
assign fp16_add_pad_out_rdy[2] = fp16_mulw_rdy & (&{fp16_add_pad_out_vld[3], fp16_add_pad_out_vld[1:0]});
assign fp16_add_pad_out_rdy[3] = fp16_mulw_rdy & (&{fp16_add_pad_out_vld[2:0]});

assign fp16_add_pad_out_pvld = &fp16_add_pad_out_vld[3:0];
//-----------------------------
//
//=============================

//=============================
//FP16 process for (* 1/kernel_width)
//-----------------------------
assign fp16_en = (reg2dp_input_data[1:0] == 2'h2 );

assign fp16_mulw_in_a_vld[0] = fp16_add_pad_out_pvld & (&{fp16_mulw_in_b_rdy[3:0], fp16_mulw_in_a_rdy[3:1]});
assign fp16_mulw_in_a_vld[1] = fp16_add_pad_out_pvld & (&{fp16_mulw_in_b_rdy[3:0], fp16_mulw_in_a_rdy[3:2], fp16_mulw_in_a_rdy[0]});
assign fp16_mulw_in_a_vld[2] = fp16_add_pad_out_pvld & (&{fp16_mulw_in_b_rdy[3:0], fp16_mulw_in_a_rdy[3]  , fp16_mulw_in_a_rdy[1:0]});
assign fp16_mulw_in_a_vld[3] = fp16_add_pad_out_pvld & (&{fp16_mulw_in_b_rdy[3:0], fp16_mulw_in_a_rdy[2:0]});
assign fp16_mulw_in_b_vld[0] = fp16_add_pad_out_pvld & (&{fp16_mulw_in_a_rdy[3:0], fp16_mulw_in_b_rdy[3:1]});
assign fp16_mulw_in_b_vld[1] = fp16_add_pad_out_pvld & (&{fp16_mulw_in_a_rdy[3:0], fp16_mulw_in_b_rdy[3:2], fp16_mulw_in_b_rdy[0]});
assign fp16_mulw_in_b_vld[2] = fp16_add_pad_out_pvld & (&{fp16_mulw_in_a_rdy[3:0], fp16_mulw_in_b_rdy[3]  , fp16_mulw_in_b_rdy[1:0]});
assign fp16_mulw_in_b_vld[3] = fp16_add_pad_out_pvld & (&{fp16_mulw_in_a_rdy[3:0], fp16_mulw_in_b_rdy[2:0]});

assign fp16_mulw_rdy = &{fp16_mulw_in_a_rdy, fp16_mulw_in_b_rdy};

 HLS_fp17_mul u_HLS_fp17_mulw_0 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_add_pad_out0[16:0])           //|< w
   ,.chn_a_rsc_vz                (fp16_mulw_in_a_vld[0])             //|< w
   ,.chn_a_rsc_lz                (fp16_mulw_in_a_rdy[0])             //|> w
   ,.chn_b_rsc_z                 (reg2dp_recip_width_cfg[16:0])      //|< i
   ,.chn_b_rsc_vz                (fp16_mulw_in_b_vld[0])             //|< w
   ,.chn_b_rsc_lz                (fp16_mulw_in_b_rdy[0])             //|> w
   ,.chn_o_rsc_z                 (fp16_mulw_out0[16:0])              //|> w
   ,.chn_o_rsc_vz                (fp16_mulw_out_rdy[0])              //|< w
   ,.chn_o_rsc_lz                (fp16_mulw_out_vld[0])              //|> w
   );
 HLS_fp17_mul u_HLS_fp17_mulw_1 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_add_pad_out1[16:0])           //|< w
   ,.chn_a_rsc_vz                (fp16_mulw_in_a_vld[1])             //|< w
   ,.chn_a_rsc_lz                (fp16_mulw_in_a_rdy[1])             //|> w
   ,.chn_b_rsc_z                 (reg2dp_recip_width_cfg[16:0])      //|< i
   ,.chn_b_rsc_vz                (fp16_mulw_in_b_vld[1])             //|< w
   ,.chn_b_rsc_lz                (fp16_mulw_in_b_rdy[1])             //|> w
   ,.chn_o_rsc_z                 (fp16_mulw_out1[16:0])              //|> w
   ,.chn_o_rsc_vz                (fp16_mulw_out_rdy[1])              //|< w
   ,.chn_o_rsc_lz                (fp16_mulw_out_vld[1])              //|> w
   );
 HLS_fp17_mul u_HLS_fp17_mulw_2 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_add_pad_out2[16:0])           //|< w
   ,.chn_a_rsc_vz                (fp16_mulw_in_a_vld[2])             //|< w
   ,.chn_a_rsc_lz                (fp16_mulw_in_a_rdy[2])             //|> w
   ,.chn_b_rsc_z                 (reg2dp_recip_width_cfg[16:0])      //|< i
   ,.chn_b_rsc_vz                (fp16_mulw_in_b_vld[2])             //|< w
   ,.chn_b_rsc_lz                (fp16_mulw_in_b_rdy[2])             //|> w
   ,.chn_o_rsc_z                 (fp16_mulw_out2[16:0])              //|> w
   ,.chn_o_rsc_vz                (fp16_mulw_out_rdy[2])              //|< w
   ,.chn_o_rsc_lz                (fp16_mulw_out_vld[2])              //|> w
   );
 HLS_fp17_mul u_HLS_fp17_mulw_3 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_add_pad_out3[16:0])           //|< w
   ,.chn_a_rsc_vz                (fp16_mulw_in_a_vld[3])             //|< w
   ,.chn_a_rsc_lz                (fp16_mulw_in_a_rdy[3])             //|> w
   ,.chn_b_rsc_z                 (reg2dp_recip_width_cfg[16:0])      //|< i
   ,.chn_b_rsc_vz                (fp16_mulw_in_b_vld[3])             //|< w
   ,.chn_b_rsc_lz                (fp16_mulw_in_b_rdy[3])             //|> w
   ,.chn_o_rsc_z                 (fp16_mulw_out3[16:0])              //|> w
   ,.chn_o_rsc_vz                (fp16_mulw_out_rdy[3])              //|< w
   ,.chn_o_rsc_lz                (fp16_mulw_out_vld[3])              //|> w
   );

assign fp16_mulw_out_rdy[0] = fp16_mulv_rdy & (&{fp16_mulw_out_vld[3:1]                      });
assign fp16_mulw_out_rdy[1] = fp16_mulv_rdy & (&{fp16_mulw_out_vld[3:2], fp16_mulw_out_vld[0]});
assign fp16_mulw_out_rdy[2] = fp16_mulv_rdy & (&{fp16_mulw_out_vld[3  ], fp16_mulw_out_vld[1:0]});
assign fp16_mulw_out_rdy[3] = fp16_mulv_rdy & (&{                        fp16_mulw_out_vld[2:0]});

//=============================
assign fp16_mulw_out_pvld = &fp16_mulw_out_vld;
//=============================

//=============================
//FP16 process for (* 1/kernel_height)
//-----------------------------
assign fp16_mulv_in_vld = fp16_mulw_out_pvld;

assign fp16_mulv_in_a_vld[0] = fp16_mulv_in_vld & (&{fp16_mulv_in_b_rdy, fp16_mulv_in_a_rdy[3:1]});
assign fp16_mulv_in_a_vld[1] = fp16_mulv_in_vld & (&{fp16_mulv_in_b_rdy, fp16_mulv_in_a_rdy[3:2], fp16_mulv_in_a_rdy[0]});
assign fp16_mulv_in_a_vld[2] = fp16_mulv_in_vld & (&{fp16_mulv_in_b_rdy, fp16_mulv_in_a_rdy[3  ], fp16_mulv_in_a_rdy[1:0]});
assign fp16_mulv_in_a_vld[3] = fp16_mulv_in_vld & (&{fp16_mulv_in_b_rdy, fp16_mulv_in_a_rdy[2:0]});
assign fp16_mulv_in_b_vld[0] = fp16_mulv_in_vld & (&{fp16_mulv_in_a_rdy, fp16_mulv_in_b_rdy[3:1]});
assign fp16_mulv_in_b_vld[1] = fp16_mulv_in_vld & (&{fp16_mulv_in_a_rdy, fp16_mulv_in_b_rdy[3:2], fp16_mulv_in_b_rdy[0]});
assign fp16_mulv_in_b_vld[2] = fp16_mulv_in_vld & (&{fp16_mulv_in_a_rdy, fp16_mulv_in_b_rdy[3  ], fp16_mulv_in_b_rdy[1:0]});
assign fp16_mulv_in_b_vld[3] = fp16_mulv_in_vld & (&{fp16_mulv_in_a_rdy, fp16_mulv_in_b_rdy[2:0]});

assign fp16_mulv_rdy = &{fp16_mulv_in_a_rdy, fp16_mulv_in_b_rdy};

 HLS_fp17_mul u_HLS_fp17_mulv_0 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_mulw_out0[16:0])              //|< w
   ,.chn_a_rsc_vz                (fp16_mulv_in_a_vld[0])             //|< w
   ,.chn_a_rsc_lz                (fp16_mulv_in_a_rdy[0])             //|> w
   ,.chn_b_rsc_z                 (reg2dp_recip_height_cfg[16:0])     //|< i
   ,.chn_b_rsc_vz                (fp16_mulv_in_b_vld[0])             //|< w
   ,.chn_b_rsc_lz                (fp16_mulv_in_b_rdy[0])             //|> w
   ,.chn_o_rsc_z                 (fp16_mulv_out0[16:0])              //|> w
   ,.chn_o_rsc_vz                (fp16_mulv_out_rdy[0])              //|< w
   ,.chn_o_rsc_lz                (fp16_mulv_out_vld[0])              //|> w
   );
 HLS_fp17_mul u_HLS_fp17_mulv_1 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_mulw_out1[16:0])              //|< w
   ,.chn_a_rsc_vz                (fp16_mulv_in_a_vld[1])             //|< w
   ,.chn_a_rsc_lz                (fp16_mulv_in_a_rdy[1])             //|> w
   ,.chn_b_rsc_z                 (reg2dp_recip_height_cfg[16:0])     //|< i
   ,.chn_b_rsc_vz                (fp16_mulv_in_b_vld[1])             //|< w
   ,.chn_b_rsc_lz                (fp16_mulv_in_b_rdy[1])             //|> w
   ,.chn_o_rsc_z                 (fp16_mulv_out1[16:0])              //|> w
   ,.chn_o_rsc_vz                (fp16_mulv_out_rdy[1])              //|< w
   ,.chn_o_rsc_lz                (fp16_mulv_out_vld[1])              //|> w
   );
 HLS_fp17_mul u_HLS_fp17_mulv_2 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_mulw_out2[16:0])              //|< w
   ,.chn_a_rsc_vz                (fp16_mulv_in_a_vld[2])             //|< w
   ,.chn_a_rsc_lz                (fp16_mulv_in_a_rdy[2])             //|> w
   ,.chn_b_rsc_z                 (reg2dp_recip_height_cfg[16:0])     //|< i
   ,.chn_b_rsc_vz                (fp16_mulv_in_b_vld[2])             //|< w
   ,.chn_b_rsc_lz                (fp16_mulv_in_b_rdy[2])             //|> w
   ,.chn_o_rsc_z                 (fp16_mulv_out2[16:0])              //|> w
   ,.chn_o_rsc_vz                (fp16_mulv_out_rdy[2])              //|< w
   ,.chn_o_rsc_lz                (fp16_mulv_out_vld[2])              //|> w
   );
 HLS_fp17_mul u_HLS_fp17_mulv_3 (
    .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
   ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
   ,.chn_a_rsc_z                 (fp16_mulw_out3[16:0])              //|< w
   ,.chn_a_rsc_vz                (fp16_mulv_in_a_vld[3])             //|< w
   ,.chn_a_rsc_lz                (fp16_mulv_in_a_rdy[3])             //|> w
   ,.chn_b_rsc_z                 (reg2dp_recip_height_cfg[16:0])     //|< i
   ,.chn_b_rsc_vz                (fp16_mulv_in_b_vld[3])             //|< w
   ,.chn_b_rsc_lz                (fp16_mulv_in_b_rdy[3])             //|> w
   ,.chn_o_rsc_z                 (fp16_mulv_out3[16:0])              //|> w
   ,.chn_o_rsc_vz                (fp16_mulv_out_rdy[3])              //|< w
   ,.chn_o_rsc_lz                (fp16_mulv_out_vld[3])              //|> w
   );

//-----------------------------
//
//=============================
//fp17 to fp16 convertor
  HLS_fp17_to_fp16 u_HLS_fp17_to_fp16_0 (
     .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
    ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
    ,.chn_a_rsc_z                 (fp16_mulv_out0[16:0])              //|< w
    ,.chn_a_rsc_vz                (fp16_mulv_out_vld[0])              //|< w
    ,.chn_a_rsc_lz                (fp16_mulv_out_rdy[0])              //|> w
    ,.chn_o_rsc_z                 (fp17T16_out0[15:0])                //|> w
    ,.chn_o_rsc_vz                (fp17T16_out_rdy[0])                //|< w
    ,.chn_o_rsc_lz                (fp17T16_out_vld[0])                //|> w
    );
  HLS_fp17_to_fp16 u_HLS_fp17_to_fp16_1 (
     .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
    ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
    ,.chn_a_rsc_z                 (fp16_mulv_out1[16:0])              //|< w
    ,.chn_a_rsc_vz                (fp16_mulv_out_vld[1])              //|< w
    ,.chn_a_rsc_lz                (fp16_mulv_out_rdy[1])              //|> w
    ,.chn_o_rsc_z                 (fp17T16_out1[15:0])                //|> w
    ,.chn_o_rsc_vz                (fp17T16_out_rdy[1])                //|< w
    ,.chn_o_rsc_lz                (fp17T16_out_vld[1])                //|> w
    );
  HLS_fp17_to_fp16 u_HLS_fp17_to_fp16_2 (
     .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
    ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
    ,.chn_a_rsc_z                 (fp16_mulv_out2[16:0])              //|< w
    ,.chn_a_rsc_vz                (fp16_mulv_out_vld[2])              //|< w
    ,.chn_a_rsc_lz                (fp16_mulv_out_rdy[2])              //|> w
    ,.chn_o_rsc_z                 (fp17T16_out2[15:0])                //|> w
    ,.chn_o_rsc_vz                (fp17T16_out_rdy[2])                //|< w
    ,.chn_o_rsc_lz                (fp17T16_out_vld[2])                //|> w
    );
  HLS_fp17_to_fp16 u_HLS_fp17_to_fp16_3 (
     .nvdla_core_clk              (nvdla_op_gated_clk_fp16)           //|< i
    ,.nvdla_core_rstn             (nvdla_core_rstn)                   //|< i
    ,.chn_a_rsc_z                 (fp16_mulv_out3[16:0])              //|< w
    ,.chn_a_rsc_vz                (fp16_mulv_out_vld[3])              //|< w
    ,.chn_a_rsc_lz                (fp16_mulv_out_rdy[3])              //|> w
    ,.chn_o_rsc_z                 (fp17T16_out3[15:0])                //|> w
    ,.chn_o_rsc_vz                (fp17T16_out_rdy[3])                //|< w
    ,.chn_o_rsc_lz                (fp17T16_out_vld[3])                //|> w
    );

assign fp17T16_out_rdy[0] = fp_dp2wdma_prdy & (&{fp17T16_out_vld[3:1]});
assign fp17T16_out_rdy[1] = fp_dp2wdma_prdy & (&{fp17T16_out_vld[3:2],fp17T16_out_vld[0]});
assign fp17T16_out_rdy[2] = fp_dp2wdma_prdy & (&{fp17T16_out_vld[3  ],fp17T16_out_vld[1:0]});
assign fp17T16_out_rdy[3] = fp_dp2wdma_prdy & (&{fp17T16_out_vld[2:0]});

assign fp_dp2wdma_dp   = {fp17T16_out3,fp17T16_out2,fp17T16_out1,fp17T16_out0};
assign fp_dp2wdma_pvld = &fp17T16_out_vld ;
assign fp_dp2wdma_prdy = (fp16_en & average_pooling_en) & pdp_dp2wdma_ready;
//-----------------------------
//
//=============================

//======================================
//interface between POOLING data and DMA
assign pdp_dp2wdma_pd    =  (fp16_en & average_pooling_en) ? fp_dp2wdma_dp : int_dp2wdma_pd;
assign pdp_dp2wdma_valid  = (fp16_en & average_pooling_en) ? fp_dp2wdma_pvld : int_dp2wdma_valid;
//==============
//function points
//==============

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    reg funcpoint_cover_off;
    initial begin
        if ( $test$plusargs( "cover_off" ) ) begin
            funcpoint_cover_off = 1'b1;
        end else begin
            funcpoint_cover_off = 1'b0;
        end
    end

    property PDP_line_buf_busy__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        &unit2d_en & (pout_width_cur==13'hf);
    endproperty
    // Cover 0 : "&unit2d_en & (pout_width_cur==13'hf)"
    FUNCPOINT_PDP_line_buf_busy__0_COV : cover property (PDP_line_buf_busy__0_cov);

  `endif
`endif
//VCS coverage on


////==============
////OBS signals
////==============
//assign obs_bus_pdp_cal2d_unit_en = unit2d_en[7:0];
//assign obs_bus_pdp_cal2d_bank_we = mem_we[7:0];
//assign obs_bus_pdp_cal2d_bank_re = mem_re[7:0] | mem_re_last[7:0];
//assign obs_bus_pdp_cal2d_bubble  = cur_datin_disable;

endmodule // NV_NVDLA_PDP_CORE_cal2d



// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none din_pd_d1[254:0] (din_vld_d1,din_rdy_d1) <= din_pd_d0[254:0] (din_vld_d0,din_rdy_d0)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_CAL2D_pipe_p1 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,din_pd_d0
  ,din_rdy_d1
  ,din_vld_d0
  ,din_pd_d1
  ,din_rdy_d0
  ,din_vld_d1
  );
input          nvdla_op_gated_clk_fp16;
input          nvdla_core_rstn;
input  [254:0] din_pd_d0;
input          din_rdy_d1;
input          din_vld_d0;
output [254:0] din_pd_d1;
output         din_rdy_d0;
output         din_vld_d1;
reg    [254:0] din_pd_d1;
reg            din_rdy_d0;
reg            din_vld_d1;
reg    [254:0] p1_pipe_data;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? din_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && din_vld_d0)? din_pd_d0[254:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  din_rdy_d0 = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or din_rdy_d1
  or p1_pipe_data
  ) begin
  din_vld_d1 = p1_pipe_valid;
  p1_pipe_ready = din_rdy_d1;
  din_pd_d1[254:0] = p1_pipe_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_95x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (din_vld_d1^din_rdy_d1^din_vld_d0^din_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_96x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (din_vld_d0 && !din_rdy_d0), (din_vld_d0), (din_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_CORE_CAL2D_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none din_pd_d2[254:0] (din_vld_d2,din_rdy_d2) <= din_pd_d1[254:0] (din_vld_d1,din_rdy_d1)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_CAL2D_pipe_p2 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,din_pd_d1
  ,din_rdy_d2
  ,din_vld_d1
  ,din_pd_d2
  ,din_rdy_d1
  ,din_vld_d2
  );
input          nvdla_op_gated_clk_fp16;
input          nvdla_core_rstn;
input  [254:0] din_pd_d1;
input          din_rdy_d2;
input          din_vld_d1;
output [254:0] din_pd_d2;
output         din_rdy_d1;
output         din_vld_d2;
reg    [254:0] din_pd_d2;
reg            din_rdy_d1;
reg            din_vld_d2;
reg    [254:0] p2_pipe_data;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? din_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && din_vld_d1)? din_pd_d1[254:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  din_rdy_d1 = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or din_rdy_d2
  or p2_pipe_data
  ) begin
  din_vld_d2 = p2_pipe_valid;
  p2_pipe_ready = din_rdy_d2;
  din_pd_d2[254:0] = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_97x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (din_vld_d2^din_rdy_d2^din_vld_d1^din_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_98x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (din_vld_d1 && !din_rdy_d1), (din_vld_d1), (din_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_CORE_CAL2D_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none din_pd_d3[254:0] (din_vld_d3,din_rdy_d3) <= din_pd_d2[254:0] (din_vld_d2,din_rdy_d2)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_CAL2D_pipe_p3 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,din_pd_d2
  ,din_rdy_d3
  ,din_vld_d2
  ,din_pd_d3
  ,din_rdy_d2
  ,din_vld_d3
  );
input          nvdla_op_gated_clk_fp16;
input          nvdla_core_rstn;
input  [254:0] din_pd_d2;
input          din_rdy_d3;
input          din_vld_d2;
output [254:0] din_pd_d3;
output         din_rdy_d2;
output         din_vld_d3;
reg    [254:0] din_pd_d3;
reg            din_rdy_d2;
reg            din_vld_d3;
reg    [254:0] p3_pipe_data;
reg            p3_pipe_ready;
reg            p3_pipe_ready_bc;
reg            p3_pipe_valid;
//## pipe (3) valid-ready-bubble-collapse
always @(
  p3_pipe_ready
  or p3_pipe_valid
  ) begin
  p3_pipe_ready_bc = p3_pipe_ready || !p3_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? din_vld_d2 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && din_vld_d2)? din_pd_d2[254:0] : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  din_rdy_d2 = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or din_rdy_d3
  or p3_pipe_data
  ) begin
  din_vld_d3 = p3_pipe_valid;
  p3_pipe_ready = din_rdy_d3;
  din_pd_d3[254:0] = p3_pipe_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_99x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (din_vld_d3^din_rdy_d3^din_vld_d2^din_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_100x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (din_vld_d2 && !din_rdy_d2), (din_vld_d2), (din_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_CORE_CAL2D_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none din_pd_d4[254:0] (din_vld_d4,din_rdy_d4) <= din_pd_d3[254:0] (din_vld_d3,din_rdy_d3)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_CAL2D_pipe_p4 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,din_pd_d3
  ,din_rdy_d4
  ,din_vld_d3
  ,din_pd_d4
  ,din_rdy_d3
  ,din_vld_d4
  );
input          nvdla_op_gated_clk_fp16;
input          nvdla_core_rstn;
input  [254:0] din_pd_d3;
input          din_rdy_d4;
input          din_vld_d3;
output [254:0] din_pd_d4;
output         din_rdy_d3;
output         din_vld_d4;
reg    [254:0] din_pd_d4;
reg            din_rdy_d3;
reg            din_vld_d4;
reg    [254:0] p4_pipe_data;
reg            p4_pipe_ready;
reg            p4_pipe_ready_bc;
reg            p4_pipe_valid;
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? din_vld_d3 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && din_vld_d3)? din_pd_d3[254:0] : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  din_rdy_d3 = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or din_rdy_d4
  or p4_pipe_data
  ) begin
  din_vld_d4 = p4_pipe_valid;
  p4_pipe_ready = din_rdy_d4;
  din_pd_d4[254:0] = p4_pipe_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_101x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (din_vld_d4^din_rdy_d4^din_vld_d3^din_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_102x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (din_vld_d3 && !din_rdy_d3), (din_vld_d3), (din_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_CORE_CAL2D_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp16_mul_pad_line_in_pd_d1[114:0] (fp16_mul_pad_line_in_vld_d1,fp16_mul_pad_line_in_rdy_d1) <= fp16_mul_pad_line_in_pd_d0[114:0] (fp16_mul_pad_line_in_vld_d0,fp16_mul_pad_line_in_rdy_d0)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_CAL2D_pipe_p5 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp16_mul_pad_line_in_pd_d0
  ,fp16_mul_pad_line_in_rdy_d1
  ,fp16_mul_pad_line_in_vld_d0
  ,fp16_mul_pad_line_in_pd_d1
  ,fp16_mul_pad_line_in_rdy_d0
  ,fp16_mul_pad_line_in_vld_d1
  );
input          nvdla_op_gated_clk_fp16;
input          nvdla_core_rstn;
input  [114:0] fp16_mul_pad_line_in_pd_d0;
input          fp16_mul_pad_line_in_rdy_d1;
input          fp16_mul_pad_line_in_vld_d0;
output [114:0] fp16_mul_pad_line_in_pd_d1;
output         fp16_mul_pad_line_in_rdy_d0;
output         fp16_mul_pad_line_in_vld_d1;
reg    [114:0] fp16_mul_pad_line_in_pd_d1;
reg            fp16_mul_pad_line_in_rdy_d0;
reg            fp16_mul_pad_line_in_vld_d1;
reg    [114:0] p5_pipe_data;
reg            p5_pipe_ready;
reg            p5_pipe_ready_bc;
reg            p5_pipe_valid;
//## pipe (5) valid-ready-bubble-collapse
always @(
  p5_pipe_ready
  or p5_pipe_valid
  ) begin
  p5_pipe_ready_bc = p5_pipe_ready || !p5_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_pipe_valid <= 1'b0;
  end else begin
  p5_pipe_valid <= (p5_pipe_ready_bc)? fp16_mul_pad_line_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && fp16_mul_pad_line_in_vld_d0)? fp16_mul_pad_line_in_pd_d0[114:0] : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  fp16_mul_pad_line_in_rdy_d0 = p5_pipe_ready_bc;
end
//## pipe (5) output
always @(
  p5_pipe_valid
  or fp16_mul_pad_line_in_rdy_d1
  or p5_pipe_data
  ) begin
  fp16_mul_pad_line_in_vld_d1 = p5_pipe_valid;
  p5_pipe_ready = fp16_mul_pad_line_in_rdy_d1;
  fp16_mul_pad_line_in_pd_d1[114:0] = p5_pipe_data;
end
//## pipe (5) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p5_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_103x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp16_mul_pad_line_in_vld_d1^fp16_mul_pad_line_in_rdy_d1^fp16_mul_pad_line_in_vld_d0^fp16_mul_pad_line_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_104x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp16_mul_pad_line_in_vld_d0 && !fp16_mul_pad_line_in_rdy_d0), (fp16_mul_pad_line_in_vld_d0), (fp16_mul_pad_line_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_CORE_CAL2D_pipe_p5




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp16_mul_pad_line_in_pd_d2[114:0] (fp16_mul_pad_line_in_vld_d2,fp16_mul_pad_line_in_rdy_d2) <= fp16_mul_pad_line_in_pd_d1[114:0] (fp16_mul_pad_line_in_vld_d1,fp16_mul_pad_line_in_rdy_d1)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_CAL2D_pipe_p6 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp16_mul_pad_line_in_pd_d1
  ,fp16_mul_pad_line_in_rdy_d2
  ,fp16_mul_pad_line_in_vld_d1
  ,fp16_mul_pad_line_in_pd_d2
  ,fp16_mul_pad_line_in_rdy_d1
  ,fp16_mul_pad_line_in_vld_d2
  );
input          nvdla_op_gated_clk_fp16;
input          nvdla_core_rstn;
input  [114:0] fp16_mul_pad_line_in_pd_d1;
input          fp16_mul_pad_line_in_rdy_d2;
input          fp16_mul_pad_line_in_vld_d1;
output [114:0] fp16_mul_pad_line_in_pd_d2;
output         fp16_mul_pad_line_in_rdy_d1;
output         fp16_mul_pad_line_in_vld_d2;
reg    [114:0] fp16_mul_pad_line_in_pd_d2;
reg            fp16_mul_pad_line_in_rdy_d1;
reg            fp16_mul_pad_line_in_vld_d2;
reg    [114:0] p6_pipe_data;
reg            p6_pipe_ready;
reg            p6_pipe_ready_bc;
reg            p6_pipe_valid;
//## pipe (6) valid-ready-bubble-collapse
always @(
  p6_pipe_ready
  or p6_pipe_valid
  ) begin
  p6_pipe_ready_bc = p6_pipe_ready || !p6_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p6_pipe_valid <= 1'b0;
  end else begin
  p6_pipe_valid <= (p6_pipe_ready_bc)? fp16_mul_pad_line_in_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p6_pipe_data <= (p6_pipe_ready_bc && fp16_mul_pad_line_in_vld_d1)? fp16_mul_pad_line_in_pd_d1[114:0] : p6_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p6_pipe_ready_bc
  ) begin
  fp16_mul_pad_line_in_rdy_d1 = p6_pipe_ready_bc;
end
//## pipe (6) output
always @(
  p6_pipe_valid
  or fp16_mul_pad_line_in_rdy_d2
  or p6_pipe_data
  ) begin
  fp16_mul_pad_line_in_vld_d2 = p6_pipe_valid;
  p6_pipe_ready = fp16_mul_pad_line_in_rdy_d2;
  fp16_mul_pad_line_in_pd_d2[114:0] = p6_pipe_data;
end
//## pipe (6) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p6_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_105x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp16_mul_pad_line_in_vld_d2^fp16_mul_pad_line_in_rdy_d2^fp16_mul_pad_line_in_vld_d1^fp16_mul_pad_line_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_106x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp16_mul_pad_line_in_vld_d1 && !fp16_mul_pad_line_in_rdy_d1), (fp16_mul_pad_line_in_vld_d1), (fp16_mul_pad_line_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_CORE_CAL2D_pipe_p6




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp16_mul_pad_line_in_pd_d3[114:0] (fp16_mul_pad_line_in_vld_d3,fp16_mul_pad_line_in_rdy_d3) <= fp16_mul_pad_line_in_pd_d2[114:0] (fp16_mul_pad_line_in_vld_d2,fp16_mul_pad_line_in_rdy_d2)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_CAL2D_pipe_p7 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp16_mul_pad_line_in_pd_d2
  ,fp16_mul_pad_line_in_rdy_d3
  ,fp16_mul_pad_line_in_vld_d2
  ,fp16_mul_pad_line_in_pd_d3
  ,fp16_mul_pad_line_in_rdy_d2
  ,fp16_mul_pad_line_in_vld_d3
  );
input          nvdla_op_gated_clk_fp16;
input          nvdla_core_rstn;
input  [114:0] fp16_mul_pad_line_in_pd_d2;
input          fp16_mul_pad_line_in_rdy_d3;
input          fp16_mul_pad_line_in_vld_d2;
output [114:0] fp16_mul_pad_line_in_pd_d3;
output         fp16_mul_pad_line_in_rdy_d2;
output         fp16_mul_pad_line_in_vld_d3;
reg    [114:0] fp16_mul_pad_line_in_pd_d3;
reg            fp16_mul_pad_line_in_rdy_d2;
reg            fp16_mul_pad_line_in_vld_d3;
reg    [114:0] p7_pipe_data;
reg            p7_pipe_ready;
reg            p7_pipe_ready_bc;
reg            p7_pipe_valid;
//## pipe (7) valid-ready-bubble-collapse
always @(
  p7_pipe_ready
  or p7_pipe_valid
  ) begin
  p7_pipe_ready_bc = p7_pipe_ready || !p7_pipe_valid;
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_pipe_valid <= 1'b0;
  end else begin
  p7_pipe_valid <= (p7_pipe_ready_bc)? fp16_mul_pad_line_in_vld_d2 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p7_pipe_data <= (p7_pipe_ready_bc && fp16_mul_pad_line_in_vld_d2)? fp16_mul_pad_line_in_pd_d2[114:0] : p7_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p7_pipe_ready_bc
  ) begin
  fp16_mul_pad_line_in_rdy_d2 = p7_pipe_ready_bc;
end
//## pipe (7) output
always @(
  p7_pipe_valid
  or fp16_mul_pad_line_in_rdy_d3
  or p7_pipe_data
  ) begin
  fp16_mul_pad_line_in_vld_d3 = p7_pipe_valid;
  p7_pipe_ready = fp16_mul_pad_line_in_rdy_d3;
  fp16_mul_pad_line_in_pd_d3[114:0] = p7_pipe_data;
end
//## pipe (7) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p7_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_107x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp16_mul_pad_line_in_vld_d3^fp16_mul_pad_line_in_rdy_d3^fp16_mul_pad_line_in_vld_d2^fp16_mul_pad_line_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_108x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp16_mul_pad_line_in_vld_d2 && !fp16_mul_pad_line_in_rdy_d2), (fp16_mul_pad_line_in_vld_d2), (fp16_mul_pad_line_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_CORE_CAL2D_pipe_p7



