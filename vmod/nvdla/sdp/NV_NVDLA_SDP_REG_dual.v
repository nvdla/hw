// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_REG_dual.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_REG_dual (
   reg_rd_data
  ,reg_offset
   // verilint 498 off
   // leda UNUSED_DEC off
  ,reg_wr_data
   // verilint 498 on
   // leda UNUSED_DEC on
  ,reg_wr_en
  ,nvdla_core_clk
  ,nvdla_core_rstn
  ,cvt_offset
  ,cvt_scale
  ,cvt_shift
  ,channel
  ,height
  ,width
  ,out_precision
  ,proc_precision
  ,bn_alu_shift_value
  ,bn_alu_src
  ,bn_alu_operand
  ,bn_alu_algo
  ,bn_alu_bypass
  ,bn_bypass
  ,bn_mul_bypass
  ,bn_mul_prelu
  ,bn_relu_bypass
  ,bn_mul_shift_value
  ,bn_mul_src
  ,bn_mul_operand
  ,bs_alu_shift_value
  ,bs_alu_src
  ,bs_alu_operand
  ,bs_alu_algo
  ,bs_alu_bypass
  ,bs_bypass
  ,bs_mul_bypass
  ,bs_mul_prelu
  ,bs_relu_bypass
  ,bs_mul_shift_value
  ,bs_mul_src
  ,bs_mul_operand
  ,ew_alu_cvt_bypass
  ,ew_alu_src
  ,ew_alu_cvt_offset
  ,ew_alu_cvt_scale
  ,ew_alu_cvt_truncate
  ,ew_alu_operand
  ,ew_alu_algo
  ,ew_alu_bypass
  ,ew_bypass
  ,ew_lut_bypass
  ,ew_mul_bypass
  ,ew_mul_prelu
  ,ew_mul_cvt_bypass
  ,ew_mul_src
  ,ew_mul_cvt_offset
  ,ew_mul_cvt_scale
  ,ew_mul_cvt_truncate
  ,ew_mul_operand
  ,ew_truncate
  ,dst_base_addr_high
  ,dst_base_addr_low
  ,dst_batch_stride
  ,dst_ram_type
  ,dst_line_stride
  ,dst_surface_stride
  ,batch_number
  ,flying_mode
  ,nan_to_zero
  ,output_dst
  ,winograd
  ,op_en_trigger
  ,perf_dma_en
  ,perf_lut_en
  ,perf_nan_inf_count_en
  ,perf_sat_en
  ,op_en
  ,lut_hybrid
  ,lut_le_hit
  ,lut_lo_hit
  ,lut_oflow
  ,lut_uflow
  ,out_saturation
  ,wdma_stall
  ,status_unequal
  ,status_inf_input_num
  ,status_nan_input_num
  ,status_nan_output_num
  );

wire   [31:0] nvdla_sdp_d_cvt_offset_0_out;
wire   [31:0] nvdla_sdp_d_cvt_scale_0_out;
wire   [31:0] nvdla_sdp_d_cvt_shift_0_out;
wire   [31:0] nvdla_sdp_d_data_cube_channel_0_out;
wire   [31:0] nvdla_sdp_d_data_cube_height_0_out;
wire   [31:0] nvdla_sdp_d_data_cube_width_0_out;
wire   [31:0] nvdla_sdp_d_data_format_0_out;
wire   [31:0] nvdla_sdp_d_dp_bn_alu_cfg_0_out;
wire   [31:0] nvdla_sdp_d_dp_bn_alu_src_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_bn_cfg_0_out;
wire   [31:0] nvdla_sdp_d_dp_bn_mul_cfg_0_out;
wire   [31:0] nvdla_sdp_d_dp_bn_mul_src_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_bs_alu_cfg_0_out;
wire   [31:0] nvdla_sdp_d_dp_bs_alu_src_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_bs_cfg_0_out;
wire   [31:0] nvdla_sdp_d_dp_bs_mul_cfg_0_out;
wire   [31:0] nvdla_sdp_d_dp_bs_mul_src_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_alu_cfg_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_alu_cvt_offset_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_alu_cvt_scale_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_alu_cvt_truncate_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_alu_src_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_cfg_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_mul_cfg_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_mul_cvt_offset_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_mul_cvt_scale_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_mul_cvt_truncate_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_mul_src_value_0_out;
wire   [31:0] nvdla_sdp_d_dp_ew_truncate_value_0_out;
wire   [31:0] nvdla_sdp_d_dst_base_addr_high_0_out;
wire   [31:0] nvdla_sdp_d_dst_base_addr_low_0_out;
wire   [31:0] nvdla_sdp_d_dst_batch_stride_0_out;
wire   [31:0] nvdla_sdp_d_dst_dma_cfg_0_out;
wire   [31:0] nvdla_sdp_d_dst_line_stride_0_out;
wire   [31:0] nvdla_sdp_d_dst_surface_stride_0_out;
wire   [31:0] nvdla_sdp_d_feature_mode_cfg_0_out;
wire   [31:0] nvdla_sdp_d_op_enable_0_out;
wire   [31:0] nvdla_sdp_d_perf_enable_0_out;
wire   [31:0] nvdla_sdp_d_perf_lut_hybrid_0_out;
wire   [31:0] nvdla_sdp_d_perf_lut_le_hit_0_out;
wire   [31:0] nvdla_sdp_d_perf_lut_lo_hit_0_out;
wire   [31:0] nvdla_sdp_d_perf_lut_oflow_0_out;
wire   [31:0] nvdla_sdp_d_perf_lut_uflow_0_out;
wire   [31:0] nvdla_sdp_d_perf_out_saturation_0_out;
wire   [31:0] nvdla_sdp_d_perf_wdma_write_stall_0_out;
wire   [31:0] nvdla_sdp_d_status_0_out;
wire   [31:0] nvdla_sdp_d_status_inf_input_num_0_out;
wire   [31:0] nvdla_sdp_d_status_nan_input_num_0_out;
wire   [31:0] nvdla_sdp_d_status_nan_output_num_0_out;
wire   [11:0] reg_offset_rd_int;
wire   [31:0] reg_offset_wr;
// Register control interface
output [31:0] reg_rd_data;
input [11:0]  reg_offset;
input [31:0]  reg_wr_data;  //(UNUSED_DEC)
input         reg_wr_en;
input         nvdla_core_clk;
input         nvdla_core_rstn;


// Writable register flop/trigger outputs
output [31:0] cvt_offset;
output [15:0] cvt_scale;
output [5:0]  cvt_shift;
output [12:0] channel;
output [12:0] height;
output [12:0] width;
output [1:0]  out_precision;
output [1:0]  proc_precision;
output [5:0]  bn_alu_shift_value;
output        bn_alu_src;
output [15:0] bn_alu_operand;
output [1:0]  bn_alu_algo;
output        bn_alu_bypass;
output        bn_bypass;
output        bn_mul_bypass;
output        bn_mul_prelu;
output        bn_relu_bypass;
output [7:0]  bn_mul_shift_value;
output        bn_mul_src;
output [15:0] bn_mul_operand;
output [5:0]  bs_alu_shift_value;
output        bs_alu_src;
output [15:0] bs_alu_operand;
output [1:0]  bs_alu_algo;
output        bs_alu_bypass;
output        bs_bypass;
output        bs_mul_bypass;
output        bs_mul_prelu;
output        bs_relu_bypass;
output [7:0]  bs_mul_shift_value;
output        bs_mul_src;
output [15:0] bs_mul_operand;
output        ew_alu_cvt_bypass;
output        ew_alu_src;
output [31:0] ew_alu_cvt_offset;
output [15:0] ew_alu_cvt_scale;
output [5:0]  ew_alu_cvt_truncate;
output [31:0] ew_alu_operand;
output [1:0]  ew_alu_algo;
output        ew_alu_bypass;
output        ew_bypass;
output        ew_lut_bypass;
output        ew_mul_bypass;
output        ew_mul_prelu;
output        ew_mul_cvt_bypass;
output        ew_mul_src;
output [31:0] ew_mul_cvt_offset;
output [15:0] ew_mul_cvt_scale;
output [5:0]  ew_mul_cvt_truncate;
output [31:0] ew_mul_operand;
output [9:0]  ew_truncate;
output [31:0] dst_base_addr_high;
output [31:0] dst_base_addr_low;
output [31:0] dst_batch_stride;
output        dst_ram_type;
output [31:0] dst_line_stride;
output [31:0] dst_surface_stride;
output [4:0]  batch_number;
output        flying_mode;
output        nan_to_zero;
output        output_dst;
output        winograd;
output        op_en_trigger;
output        perf_dma_en;
output        perf_lut_en;
output        perf_nan_inf_count_en;
output        perf_sat_en;

// Read-only register inputs
input         op_en;
input [31:0]  lut_hybrid;
input [31:0]  lut_le_hit;
input [31:0]  lut_lo_hit;
input [31:0]  lut_oflow;
input [31:0]  lut_uflow;
input [31:0]  out_saturation;
input [31:0]  wdma_stall;
input         status_unequal;
input [31:0]  status_inf_input_num;
input [31:0]  status_nan_input_num;
input [31:0]  status_nan_output_num;

// wr_mask register inputs

// rstn register inputs

// leda FM_2_23 off
reg           arreggen_abort_on_invalid_wr;
reg           arreggen_abort_on_rowr;
reg           arreggen_dump;
// leda FM_2_23 on
reg     [4:0] batch_number;
reg     [1:0] bn_alu_algo;
reg           bn_alu_bypass;
reg    [15:0] bn_alu_operand;
reg     [5:0] bn_alu_shift_value;
reg           bn_alu_src;
reg           bn_bypass;
reg           bn_mul_bypass;
reg    [15:0] bn_mul_operand;
reg           bn_mul_prelu;
reg     [7:0] bn_mul_shift_value;
reg           bn_mul_src;
reg           bn_relu_bypass;
reg     [1:0] bs_alu_algo;
reg           bs_alu_bypass;
reg    [15:0] bs_alu_operand;
reg     [5:0] bs_alu_shift_value;
reg           bs_alu_src;
reg           bs_bypass;
reg           bs_mul_bypass;
reg    [15:0] bs_mul_operand;
reg           bs_mul_prelu;
reg     [7:0] bs_mul_shift_value;
reg           bs_mul_src;
reg           bs_relu_bypass;
reg    [12:0] channel;
reg    [31:0] cvt_offset;
reg    [15:0] cvt_scale;
reg     [5:0] cvt_shift;
reg    [31:0] dst_base_addr_high;
reg    [31:0] dst_base_addr_low;
reg    [31:0] dst_batch_stride;
reg    [31:0] dst_line_stride;
reg           dst_ram_type;
reg    [31:0] dst_surface_stride;
reg     [1:0] ew_alu_algo;
reg           ew_alu_bypass;
reg           ew_alu_cvt_bypass;
reg    [31:0] ew_alu_cvt_offset;
reg    [15:0] ew_alu_cvt_scale;
reg     [5:0] ew_alu_cvt_truncate;
reg    [31:0] ew_alu_operand;
reg           ew_alu_src;
reg           ew_bypass;
reg           ew_lut_bypass;
reg           ew_mul_bypass;
reg           ew_mul_cvt_bypass;
reg    [31:0] ew_mul_cvt_offset;
reg    [15:0] ew_mul_cvt_scale;
reg     [5:0] ew_mul_cvt_truncate;
reg    [31:0] ew_mul_operand;
reg           ew_mul_prelu;
reg           ew_mul_src;
reg     [9:0] ew_truncate;
reg           flying_mode;
reg    [12:0] height;
reg           nan_to_zero;
reg     [1:0] out_precision;
reg           output_dst;
reg           perf_dma_en;
reg           perf_lut_en;
reg           perf_nan_inf_count_en;
reg           perf_sat_en;
reg     [1:0] proc_precision;
reg    [31:0] reg_rd_data;
reg    [12:0] width;
reg           winograd;

assign reg_offset_wr = {20'b0 , reg_offset};
// SCR signals

// Address decode
wire nvdla_sdp_d_cvt_offset_0_wren = (reg_offset_wr == (32'hb0c0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_cvt_scale_0_wren = (reg_offset_wr == (32'hb0c4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_cvt_shift_0_wren = (reg_offset_wr == (32'hb0c8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_data_cube_channel_0_wren = (reg_offset_wr == (32'hb044  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_data_cube_height_0_wren = (reg_offset_wr == (32'hb040  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_data_cube_width_0_wren = (reg_offset_wr == (32'hb03c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_data_format_0_wren = (reg_offset_wr == (32'hb0bc  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_bn_alu_cfg_0_wren = (reg_offset_wr == (32'hb070  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_bn_alu_src_value_0_wren = (reg_offset_wr == (32'hb074  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_bn_cfg_0_wren = (reg_offset_wr == (32'hb06c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_bn_mul_cfg_0_wren = (reg_offset_wr == (32'hb078  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_bn_mul_src_value_0_wren = (reg_offset_wr == (32'hb07c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_bs_alu_cfg_0_wren = (reg_offset_wr == (32'hb05c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_bs_alu_src_value_0_wren = (reg_offset_wr == (32'hb060  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_bs_cfg_0_wren = (reg_offset_wr == (32'hb058  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_bs_mul_cfg_0_wren = (reg_offset_wr == (32'hb064  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_bs_mul_src_value_0_wren = (reg_offset_wr == (32'hb068  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_alu_cfg_0_wren = (reg_offset_wr == (32'hb084  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_alu_cvt_offset_value_0_wren = (reg_offset_wr == (32'hb08c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_alu_cvt_scale_value_0_wren = (reg_offset_wr == (32'hb090  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_alu_cvt_truncate_value_0_wren = (reg_offset_wr == (32'hb094  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_alu_src_value_0_wren = (reg_offset_wr == (32'hb088  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_cfg_0_wren = (reg_offset_wr == (32'hb080  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_mul_cfg_0_wren = (reg_offset_wr == (32'hb098  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_mul_cvt_offset_value_0_wren = (reg_offset_wr == (32'hb0a0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_mul_cvt_scale_value_0_wren = (reg_offset_wr == (32'hb0a4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_mul_cvt_truncate_value_0_wren = (reg_offset_wr == (32'hb0a8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_mul_src_value_0_wren = (reg_offset_wr == (32'hb09c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dp_ew_truncate_value_0_wren = (reg_offset_wr == (32'hb0ac  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dst_base_addr_high_0_wren = (reg_offset_wr == (32'hb04c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dst_base_addr_low_0_wren = (reg_offset_wr == (32'hb048  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dst_batch_stride_0_wren = (reg_offset_wr == (32'hb0b8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dst_dma_cfg_0_wren = (reg_offset_wr == (32'hb0b4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dst_line_stride_0_wren = (reg_offset_wr == (32'hb050  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_dst_surface_stride_0_wren = (reg_offset_wr == (32'hb054  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_feature_mode_cfg_0_wren = (reg_offset_wr == (32'hb0b0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_op_enable_0_wren = (reg_offset_wr == (32'hb038  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_perf_enable_0_wren = (reg_offset_wr == (32'hb0dc  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_perf_lut_hybrid_0_wren = (reg_offset_wr == (32'hb0f0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_perf_lut_le_hit_0_wren = (reg_offset_wr == (32'hb0f4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_perf_lut_lo_hit_0_wren = (reg_offset_wr == (32'hb0f8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_perf_lut_oflow_0_wren = (reg_offset_wr == (32'hb0e8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_perf_lut_uflow_0_wren = (reg_offset_wr == (32'hb0e4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_perf_out_saturation_0_wren = (reg_offset_wr == (32'hb0ec  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_perf_wdma_write_stall_0_wren = (reg_offset_wr == (32'hb0e0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_status_0_wren = (reg_offset_wr == (32'hb0cc  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_status_inf_input_num_0_wren = (reg_offset_wr == (32'hb0d4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_status_nan_input_num_0_wren = (reg_offset_wr == (32'hb0d0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_d_status_nan_output_num_0_wren = (reg_offset_wr == (32'hb0d8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)

assign nvdla_sdp_d_cvt_offset_0_out[31:0] = { cvt_offset };
assign nvdla_sdp_d_cvt_scale_0_out[31:0] = { 16'b0, cvt_scale };
assign nvdla_sdp_d_cvt_shift_0_out[31:0] = { 26'b0, cvt_shift };
assign nvdla_sdp_d_data_cube_channel_0_out[31:0] = { 19'b0, channel };
assign nvdla_sdp_d_data_cube_height_0_out[31:0] = { 19'b0, height };
assign nvdla_sdp_d_data_cube_width_0_out[31:0] = { 19'b0, width };
assign nvdla_sdp_d_data_format_0_out[31:0] = { 28'b0, out_precision, proc_precision };
assign nvdla_sdp_d_dp_bn_alu_cfg_0_out[31:0] = { 18'b0, bn_alu_shift_value, 7'b0, bn_alu_src };
assign nvdla_sdp_d_dp_bn_alu_src_value_0_out[31:0] = { 16'b0, bn_alu_operand };
assign nvdla_sdp_d_dp_bn_cfg_0_out[31:0] = { 25'b0, bn_relu_bypass, bn_mul_prelu, bn_mul_bypass, bn_alu_algo, bn_alu_bypass, bn_bypass };
assign nvdla_sdp_d_dp_bn_mul_cfg_0_out[31:0] = { 16'b0, bn_mul_shift_value, 7'b0, bn_mul_src };
assign nvdla_sdp_d_dp_bn_mul_src_value_0_out[31:0] = { 16'b0, bn_mul_operand };
assign nvdla_sdp_d_dp_bs_alu_cfg_0_out[31:0] = { 18'b0, bs_alu_shift_value, 7'b0, bs_alu_src };
assign nvdla_sdp_d_dp_bs_alu_src_value_0_out[31:0] = { 16'b0, bs_alu_operand };
assign nvdla_sdp_d_dp_bs_cfg_0_out[31:0] = { 25'b0, bs_relu_bypass, bs_mul_prelu, bs_mul_bypass, bs_alu_algo, bs_alu_bypass, bs_bypass };
assign nvdla_sdp_d_dp_bs_mul_cfg_0_out[31:0] = { 16'b0, bs_mul_shift_value, 7'b0, bs_mul_src };
assign nvdla_sdp_d_dp_bs_mul_src_value_0_out[31:0] = { 16'b0, bs_mul_operand };
assign nvdla_sdp_d_dp_ew_alu_cfg_0_out[31:0] = { 30'b0, ew_alu_cvt_bypass, ew_alu_src };
assign nvdla_sdp_d_dp_ew_alu_cvt_offset_value_0_out[31:0] = { ew_alu_cvt_offset };
assign nvdla_sdp_d_dp_ew_alu_cvt_scale_value_0_out[31:0] = { 16'b0, ew_alu_cvt_scale };
assign nvdla_sdp_d_dp_ew_alu_cvt_truncate_value_0_out[31:0] = { 26'b0, ew_alu_cvt_truncate };
assign nvdla_sdp_d_dp_ew_alu_src_value_0_out[31:0] = { ew_alu_operand };
assign nvdla_sdp_d_dp_ew_cfg_0_out[31:0] = { 25'b0, ew_lut_bypass, ew_mul_prelu, ew_mul_bypass, ew_alu_algo, ew_alu_bypass, ew_bypass };
assign nvdla_sdp_d_dp_ew_mul_cfg_0_out[31:0] = { 30'b0, ew_mul_cvt_bypass, ew_mul_src };
assign nvdla_sdp_d_dp_ew_mul_cvt_offset_value_0_out[31:0] = { ew_mul_cvt_offset };
assign nvdla_sdp_d_dp_ew_mul_cvt_scale_value_0_out[31:0] = { 16'b0, ew_mul_cvt_scale };
assign nvdla_sdp_d_dp_ew_mul_cvt_truncate_value_0_out[31:0] = { 26'b0, ew_mul_cvt_truncate };
assign nvdla_sdp_d_dp_ew_mul_src_value_0_out[31:0] = { ew_mul_operand };
assign nvdla_sdp_d_dp_ew_truncate_value_0_out[31:0] = { 22'b0, ew_truncate };
assign nvdla_sdp_d_dst_base_addr_high_0_out[31:0] = { dst_base_addr_high };
assign nvdla_sdp_d_dst_base_addr_low_0_out[31:0] = { dst_base_addr_low};
assign nvdla_sdp_d_dst_batch_stride_0_out[31:0] = { dst_batch_stride};
assign nvdla_sdp_d_dst_dma_cfg_0_out[31:0] = { 31'b0, dst_ram_type };
assign nvdla_sdp_d_dst_line_stride_0_out[31:0] = { dst_line_stride};
assign nvdla_sdp_d_dst_surface_stride_0_out[31:0] = { dst_surface_stride};
assign nvdla_sdp_d_feature_mode_cfg_0_out[31:0] = { 19'b0, batch_number, 4'b0, nan_to_zero, winograd, output_dst, flying_mode };
assign nvdla_sdp_d_op_enable_0_out[31:0] = { 31'b0, op_en };
assign nvdla_sdp_d_perf_enable_0_out[31:0] = { 28'b0, perf_nan_inf_count_en, perf_sat_en, perf_lut_en, perf_dma_en };
assign nvdla_sdp_d_perf_lut_hybrid_0_out[31:0] = { lut_hybrid };
assign nvdla_sdp_d_perf_lut_le_hit_0_out[31:0] = { lut_le_hit };
assign nvdla_sdp_d_perf_lut_lo_hit_0_out[31:0] = { lut_lo_hit };
assign nvdla_sdp_d_perf_lut_oflow_0_out[31:0] = { lut_oflow };
assign nvdla_sdp_d_perf_lut_uflow_0_out[31:0] = { lut_uflow };
assign nvdla_sdp_d_perf_out_saturation_0_out[31:0] = { out_saturation };
assign nvdla_sdp_d_perf_wdma_write_stall_0_out[31:0] = { wdma_stall };
assign nvdla_sdp_d_status_0_out[31:0] = { 31'b0, status_unequal };
assign nvdla_sdp_d_status_inf_input_num_0_out[31:0] = { status_inf_input_num };
assign nvdla_sdp_d_status_nan_input_num_0_out[31:0] = { status_nan_input_num };
assign nvdla_sdp_d_status_nan_output_num_0_out[31:0] = { status_nan_output_num };

assign op_en_trigger = nvdla_sdp_d_op_enable_0_wren;  //(W563)

assign reg_offset_rd_int = reg_offset;
// Output mux
//spyglass disable_block W338, W263 
always @(
  reg_offset_rd_int
  or nvdla_sdp_d_cvt_offset_0_out
  or nvdla_sdp_d_cvt_scale_0_out
  or nvdla_sdp_d_cvt_shift_0_out
  or nvdla_sdp_d_data_cube_channel_0_out
  or nvdla_sdp_d_data_cube_height_0_out
  or nvdla_sdp_d_data_cube_width_0_out
  or nvdla_sdp_d_data_format_0_out
  or nvdla_sdp_d_dp_bn_alu_cfg_0_out
  or nvdla_sdp_d_dp_bn_alu_src_value_0_out
  or nvdla_sdp_d_dp_bn_cfg_0_out
  or nvdla_sdp_d_dp_bn_mul_cfg_0_out
  or nvdla_sdp_d_dp_bn_mul_src_value_0_out
  or nvdla_sdp_d_dp_bs_alu_cfg_0_out
  or nvdla_sdp_d_dp_bs_alu_src_value_0_out
  or nvdla_sdp_d_dp_bs_cfg_0_out
  or nvdla_sdp_d_dp_bs_mul_cfg_0_out
  or nvdla_sdp_d_dp_bs_mul_src_value_0_out
  or nvdla_sdp_d_dp_ew_alu_cfg_0_out
  or nvdla_sdp_d_dp_ew_alu_cvt_offset_value_0_out
  or nvdla_sdp_d_dp_ew_alu_cvt_scale_value_0_out
  or nvdla_sdp_d_dp_ew_alu_cvt_truncate_value_0_out
  or nvdla_sdp_d_dp_ew_alu_src_value_0_out
  or nvdla_sdp_d_dp_ew_cfg_0_out
  or nvdla_sdp_d_dp_ew_mul_cfg_0_out
  or nvdla_sdp_d_dp_ew_mul_cvt_offset_value_0_out
  or nvdla_sdp_d_dp_ew_mul_cvt_scale_value_0_out
  or nvdla_sdp_d_dp_ew_mul_cvt_truncate_value_0_out
  or nvdla_sdp_d_dp_ew_mul_src_value_0_out
  or nvdla_sdp_d_dp_ew_truncate_value_0_out
  or nvdla_sdp_d_dst_base_addr_high_0_out
  or nvdla_sdp_d_dst_base_addr_low_0_out
  or nvdla_sdp_d_dst_batch_stride_0_out
  or nvdla_sdp_d_dst_dma_cfg_0_out
  or nvdla_sdp_d_dst_line_stride_0_out
  or nvdla_sdp_d_dst_surface_stride_0_out
  or nvdla_sdp_d_feature_mode_cfg_0_out
  or nvdla_sdp_d_op_enable_0_out
  or nvdla_sdp_d_perf_enable_0_out
  or nvdla_sdp_d_perf_lut_hybrid_0_out
  or nvdla_sdp_d_perf_lut_le_hit_0_out
  or nvdla_sdp_d_perf_lut_lo_hit_0_out
  or nvdla_sdp_d_perf_lut_oflow_0_out
  or nvdla_sdp_d_perf_lut_uflow_0_out
  or nvdla_sdp_d_perf_out_saturation_0_out
  or nvdla_sdp_d_perf_wdma_write_stall_0_out
  or nvdla_sdp_d_status_0_out
  or nvdla_sdp_d_status_inf_input_num_0_out
  or nvdla_sdp_d_status_nan_input_num_0_out
  or nvdla_sdp_d_status_nan_output_num_0_out
  ) begin
  case (reg_offset_rd_int)
     (32'hb0c0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_cvt_offset_0_out ;
                            end 
     (32'hb0c4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_cvt_scale_0_out ;
                            end 
     (32'hb0c8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_cvt_shift_0_out ;
                            end 
     (32'hb044  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_data_cube_channel_0_out ;
                            end 
     (32'hb040  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_data_cube_height_0_out ;
                            end 
     (32'hb03c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_data_cube_width_0_out ;
                            end 
     (32'hb0bc  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_data_format_0_out ;
                            end 
     (32'hb070  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_bn_alu_cfg_0_out ;
                            end 
     (32'hb074  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_bn_alu_src_value_0_out ;
                            end 
     (32'hb06c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_bn_cfg_0_out ;
                            end 
     (32'hb078  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_bn_mul_cfg_0_out ;
                            end 
     (32'hb07c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_bn_mul_src_value_0_out ;
                            end 
     (32'hb05c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_bs_alu_cfg_0_out ;
                            end 
     (32'hb060  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_bs_alu_src_value_0_out ;
                            end 
     (32'hb058  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_bs_cfg_0_out ;
                            end 
     (32'hb064  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_bs_mul_cfg_0_out ;
                            end 
     (32'hb068  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_bs_mul_src_value_0_out ;
                            end 
     (32'hb084  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_alu_cfg_0_out ;
                            end 
     (32'hb08c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_alu_cvt_offset_value_0_out ;
                            end 
     (32'hb090  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_alu_cvt_scale_value_0_out ;
                            end 
     (32'hb094  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_alu_cvt_truncate_value_0_out ;
                            end 
     (32'hb088  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_alu_src_value_0_out ;
                            end 
     (32'hb080  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_cfg_0_out ;
                            end 
     (32'hb098  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_mul_cfg_0_out ;
                            end 
     (32'hb0a0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_mul_cvt_offset_value_0_out ;
                            end 
     (32'hb0a4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_mul_cvt_scale_value_0_out ;
                            end 
     (32'hb0a8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_mul_cvt_truncate_value_0_out ;
                            end 
     (32'hb09c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_mul_src_value_0_out ;
                            end 
     (32'hb0ac  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dp_ew_truncate_value_0_out ;
                            end 
     (32'hb04c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dst_base_addr_high_0_out ;
                            end 
     (32'hb048  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dst_base_addr_low_0_out ;
                            end 
     (32'hb0b8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dst_batch_stride_0_out ;
                            end 
     (32'hb0b4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dst_dma_cfg_0_out ;
                            end 
     (32'hb050  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dst_line_stride_0_out ;
                            end 
     (32'hb054  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_dst_surface_stride_0_out ;
                            end 
     (32'hb0b0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_feature_mode_cfg_0_out ;
                            end 
     (32'hb038  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_op_enable_0_out ;
                            end 
     (32'hb0dc  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_perf_enable_0_out ;
                            end 
     (32'hb0f0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_perf_lut_hybrid_0_out ;
                            end 
     (32'hb0f4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_perf_lut_le_hit_0_out ;
                            end 
     (32'hb0f8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_perf_lut_lo_hit_0_out ;
                            end 
     (32'hb0e8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_perf_lut_oflow_0_out ;
                            end 
     (32'hb0e4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_perf_lut_uflow_0_out ;
                            end 
     (32'hb0ec  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_perf_out_saturation_0_out ;
                            end 
     (32'hb0e0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_perf_wdma_write_stall_0_out ;
                            end 
     (32'hb0cc  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_status_0_out ;
                            end 
     (32'hb0d4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_status_inf_input_num_0_out ;
                            end 
     (32'hb0d0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_status_nan_input_num_0_out ;
                            end 
     (32'hb0d8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_d_status_nan_output_num_0_out ;
                            end 
    default: reg_rd_data = {32{1'b0}};
  endcase
end

//spyglass enable_block W338, W263

// spyglass disable_block STARC-2.10.1.6, NoConstWithXZ, W443

// Register flop declarations
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cvt_offset[31:0] <= 32'h0;
    cvt_scale[15:0] <= 16'b0000000000000000;
    cvt_shift[5:0] <= 6'b000000;
    channel[12:0] <= 13'b0000000000000;
    height[12:0] <= 13'b0000000000000;
    width[12:0] <= 13'b0000000000000;
    out_precision[1:0] <= 2'b00;
    proc_precision[1:0] <= 2'b00;
    bn_alu_shift_value[5:0] <= 6'b000000;
    bn_alu_src <= 1'b0;
    bn_alu_operand[15:0] <= 16'b0000000000000000;
    bn_alu_algo[1:0] <= 2'b00;
    bn_alu_bypass <= 1'b1;
    bn_bypass <= 1'b1;
    bn_mul_bypass <= 1'b1;
    bn_mul_prelu <= 1'b0;
    bn_relu_bypass <= 1'b1;
    bn_mul_shift_value[7:0] <= 8'b00000000;
    bn_mul_src <= 1'b0;
    bn_mul_operand[15:0] <= 16'b0000000000000000;
    bs_alu_shift_value[5:0] <= 6'b000000;
    bs_alu_src <= 1'b0;
    bs_alu_operand[15:0] <= 16'b0000000000000000;
    bs_alu_algo[1:0] <= 2'b00;
    bs_alu_bypass <= 1'b1;
    bs_bypass <= 1'b1;
    bs_mul_bypass <= 1'b1;
    bs_mul_prelu <= 1'b1;
    bs_relu_bypass <= 1'b1;
    bs_mul_shift_value[7:0] <= 8'b00000000;
    bs_mul_src <= 1'b0;
    bs_mul_operand[15:0] <= 16'b0000000000000000;
    ew_alu_cvt_bypass <= 1'b1;
    ew_alu_src <= 1'b0;
    ew_alu_cvt_offset[31:0] <= 32'h0;
    ew_alu_cvt_scale[15:0] <= 16'b0000000000000000;
    ew_alu_cvt_truncate[5:0] <= 6'b000000;
    ew_alu_operand[31:0] <= 32'h0;
    ew_alu_algo[1:0] <= 2'b00;
    ew_alu_bypass <= 1'b1;
    ew_bypass <= 1'b1;
    ew_lut_bypass <= 1'b1;
    ew_mul_bypass <= 1'b1;
    ew_mul_prelu <= 1'b0;
    ew_mul_cvt_bypass <= 1'b1;
    ew_mul_src <= 1'b0;
    ew_mul_cvt_offset[31:0] <= 32'h0;
    ew_mul_cvt_scale[15:0] <= 16'b0000000000000000;
    ew_mul_cvt_truncate[5:0] <= 6'b000000;
    ew_mul_operand[31:0] <= 32'h0;
    ew_truncate[9:0] <= 10'b0000000000;
    dst_base_addr_high[31:0] <= 32'h0;
    dst_base_addr_low[31:0] <= {(32){1'b0}};
    dst_batch_stride[31:0] <= {(32){1'b0}};
    dst_ram_type <= 1'b0;
    dst_line_stride[31:0] <= {(32){1'b0}};
    dst_surface_stride[31:0] <= {(32){1'b0}};
    batch_number[4:0] <= 5'b00000;
    flying_mode <= 1'b0;
    nan_to_zero <= 1'b0;
    output_dst <= 1'b0;
    winograd <= 1'b0;
    perf_dma_en <= 1'b0;
    perf_lut_en <= 1'b0;
    perf_nan_inf_count_en <= 1'b0;
    perf_sat_en <= 1'b0;
  end else begin
  // Register: NVDLA_SDP_D_CVT_OFFSET_0    Field: cvt_offset
  if (nvdla_sdp_d_cvt_offset_0_wren) begin
    cvt_offset[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_D_CVT_SCALE_0    Field: cvt_scale
  if (nvdla_sdp_d_cvt_scale_0_wren) begin
    cvt_scale[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_SDP_D_CVT_SHIFT_0    Field: cvt_shift
  if (nvdla_sdp_d_cvt_shift_0_wren) begin
    cvt_shift[5:0] <= reg_wr_data[5:0];
  end

  // Register: NVDLA_SDP_D_DATA_CUBE_CHANNEL_0    Field: channel
  if (nvdla_sdp_d_data_cube_channel_0_wren) begin
    channel[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_SDP_D_DATA_CUBE_HEIGHT_0    Field: height
  if (nvdla_sdp_d_data_cube_height_0_wren) begin
    height[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_SDP_D_DATA_CUBE_WIDTH_0    Field: width
  if (nvdla_sdp_d_data_cube_width_0_wren) begin
    width[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_SDP_D_DATA_FORMAT_0    Field: out_precision
  if (nvdla_sdp_d_data_format_0_wren) begin
    out_precision[1:0] <= reg_wr_data[3:2];
  end

  // Register: NVDLA_SDP_D_DATA_FORMAT_0    Field: proc_precision
  if (nvdla_sdp_d_data_format_0_wren) begin
    proc_precision[1:0] <= reg_wr_data[1:0];
  end

  // Register: NVDLA_SDP_D_DP_BN_ALU_CFG_0    Field: bn_alu_shift_value
  if (nvdla_sdp_d_dp_bn_alu_cfg_0_wren) begin
    bn_alu_shift_value[5:0] <= reg_wr_data[13:8];
  end

  // Register: NVDLA_SDP_D_DP_BN_ALU_CFG_0    Field: bn_alu_src
  if (nvdla_sdp_d_dp_bn_alu_cfg_0_wren) begin
    bn_alu_src <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_DP_BN_ALU_SRC_VALUE_0    Field: bn_alu_operand
  if (nvdla_sdp_d_dp_bn_alu_src_value_0_wren) begin
    bn_alu_operand[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_SDP_D_DP_BN_CFG_0    Field: bn_alu_algo
  if (nvdla_sdp_d_dp_bn_cfg_0_wren) begin
    bn_alu_algo[1:0] <= reg_wr_data[3:2];
  end

  // Register: NVDLA_SDP_D_DP_BN_CFG_0    Field: bn_alu_bypass
  if (nvdla_sdp_d_dp_bn_cfg_0_wren) begin
    bn_alu_bypass <= reg_wr_data[1];
  end

  // Register: NVDLA_SDP_D_DP_BN_CFG_0    Field: bn_bypass
  if (nvdla_sdp_d_dp_bn_cfg_0_wren) begin
    bn_bypass <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_DP_BN_CFG_0    Field: bn_mul_bypass
  if (nvdla_sdp_d_dp_bn_cfg_0_wren) begin
    bn_mul_bypass <= reg_wr_data[4];
  end

  // Register: NVDLA_SDP_D_DP_BN_CFG_0    Field: bn_mul_prelu
  if (nvdla_sdp_d_dp_bn_cfg_0_wren) begin
    bn_mul_prelu <= reg_wr_data[5];
  end

  // Register: NVDLA_SDP_D_DP_BN_CFG_0    Field: bn_relu_bypass
  if (nvdla_sdp_d_dp_bn_cfg_0_wren) begin
    bn_relu_bypass <= reg_wr_data[6];
  end

  // Register: NVDLA_SDP_D_DP_BN_MUL_CFG_0    Field: bn_mul_shift_value
  if (nvdla_sdp_d_dp_bn_mul_cfg_0_wren) begin
    bn_mul_shift_value[7:0] <= reg_wr_data[15:8];
  end

  // Register: NVDLA_SDP_D_DP_BN_MUL_CFG_0    Field: bn_mul_src
  if (nvdla_sdp_d_dp_bn_mul_cfg_0_wren) begin
    bn_mul_src <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_DP_BN_MUL_SRC_VALUE_0    Field: bn_mul_operand
  if (nvdla_sdp_d_dp_bn_mul_src_value_0_wren) begin
    bn_mul_operand[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_SDP_D_DP_BS_ALU_CFG_0    Field: bs_alu_shift_value
  if (nvdla_sdp_d_dp_bs_alu_cfg_0_wren) begin
    bs_alu_shift_value[5:0] <= reg_wr_data[13:8];
  end

  // Register: NVDLA_SDP_D_DP_BS_ALU_CFG_0    Field: bs_alu_src
  if (nvdla_sdp_d_dp_bs_alu_cfg_0_wren) begin
    bs_alu_src <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_DP_BS_ALU_SRC_VALUE_0    Field: bs_alu_operand
  if (nvdla_sdp_d_dp_bs_alu_src_value_0_wren) begin
    bs_alu_operand[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_SDP_D_DP_BS_CFG_0    Field: bs_alu_algo
  if (nvdla_sdp_d_dp_bs_cfg_0_wren) begin
    bs_alu_algo[1:0] <= reg_wr_data[3:2];
  end

  // Register: NVDLA_SDP_D_DP_BS_CFG_0    Field: bs_alu_bypass
  if (nvdla_sdp_d_dp_bs_cfg_0_wren) begin
    bs_alu_bypass <= reg_wr_data[1];
  end

  // Register: NVDLA_SDP_D_DP_BS_CFG_0    Field: bs_bypass
  if (nvdla_sdp_d_dp_bs_cfg_0_wren) begin
    bs_bypass <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_DP_BS_CFG_0    Field: bs_mul_bypass
  if (nvdla_sdp_d_dp_bs_cfg_0_wren) begin
    bs_mul_bypass <= reg_wr_data[4];
  end

  // Register: NVDLA_SDP_D_DP_BS_CFG_0    Field: bs_mul_prelu
  if (nvdla_sdp_d_dp_bs_cfg_0_wren) begin
    bs_mul_prelu <= reg_wr_data[5];
  end

  // Register: NVDLA_SDP_D_DP_BS_CFG_0    Field: bs_relu_bypass
  if (nvdla_sdp_d_dp_bs_cfg_0_wren) begin
    bs_relu_bypass <= reg_wr_data[6];
  end

  // Register: NVDLA_SDP_D_DP_BS_MUL_CFG_0    Field: bs_mul_shift_value
  if (nvdla_sdp_d_dp_bs_mul_cfg_0_wren) begin
    bs_mul_shift_value[7:0] <= reg_wr_data[15:8];
  end

  // Register: NVDLA_SDP_D_DP_BS_MUL_CFG_0    Field: bs_mul_src
  if (nvdla_sdp_d_dp_bs_mul_cfg_0_wren) begin
    bs_mul_src <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_DP_BS_MUL_SRC_VALUE_0    Field: bs_mul_operand
  if (nvdla_sdp_d_dp_bs_mul_src_value_0_wren) begin
    bs_mul_operand[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_SDP_D_DP_EW_ALU_CFG_0    Field: ew_alu_cvt_bypass
  if (nvdla_sdp_d_dp_ew_alu_cfg_0_wren) begin
    ew_alu_cvt_bypass <= reg_wr_data[1];
  end

  // Register: NVDLA_SDP_D_DP_EW_ALU_CFG_0    Field: ew_alu_src
  if (nvdla_sdp_d_dp_ew_alu_cfg_0_wren) begin
    ew_alu_src <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_DP_EW_ALU_CVT_OFFSET_VALUE_0    Field: ew_alu_cvt_offset
  if (nvdla_sdp_d_dp_ew_alu_cvt_offset_value_0_wren) begin
    ew_alu_cvt_offset[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_D_DP_EW_ALU_CVT_SCALE_VALUE_0    Field: ew_alu_cvt_scale
  if (nvdla_sdp_d_dp_ew_alu_cvt_scale_value_0_wren) begin
    ew_alu_cvt_scale[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_SDP_D_DP_EW_ALU_CVT_TRUNCATE_VALUE_0    Field: ew_alu_cvt_truncate
  if (nvdla_sdp_d_dp_ew_alu_cvt_truncate_value_0_wren) begin
    ew_alu_cvt_truncate[5:0] <= reg_wr_data[5:0];
  end

  // Register: NVDLA_SDP_D_DP_EW_ALU_SRC_VALUE_0    Field: ew_alu_operand
  if (nvdla_sdp_d_dp_ew_alu_src_value_0_wren) begin
    ew_alu_operand[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_D_DP_EW_CFG_0    Field: ew_alu_algo
  if (nvdla_sdp_d_dp_ew_cfg_0_wren) begin
    ew_alu_algo[1:0] <= reg_wr_data[3:2];
  end

  // Register: NVDLA_SDP_D_DP_EW_CFG_0    Field: ew_alu_bypass
  if (nvdla_sdp_d_dp_ew_cfg_0_wren) begin
    ew_alu_bypass <= reg_wr_data[1];
  end

  // Register: NVDLA_SDP_D_DP_EW_CFG_0    Field: ew_bypass
  if (nvdla_sdp_d_dp_ew_cfg_0_wren) begin
    ew_bypass <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_DP_EW_CFG_0    Field: ew_lut_bypass
  if (nvdla_sdp_d_dp_ew_cfg_0_wren) begin
    ew_lut_bypass <= reg_wr_data[6];
  end

  // Register: NVDLA_SDP_D_DP_EW_CFG_0    Field: ew_mul_bypass
  if (nvdla_sdp_d_dp_ew_cfg_0_wren) begin
    ew_mul_bypass <= reg_wr_data[4];
  end

  // Register: NVDLA_SDP_D_DP_EW_CFG_0    Field: ew_mul_prelu
  if (nvdla_sdp_d_dp_ew_cfg_0_wren) begin
    ew_mul_prelu <= reg_wr_data[5];
  end

  // Register: NVDLA_SDP_D_DP_EW_MUL_CFG_0    Field: ew_mul_cvt_bypass
  if (nvdla_sdp_d_dp_ew_mul_cfg_0_wren) begin
    ew_mul_cvt_bypass <= reg_wr_data[1];
  end

  // Register: NVDLA_SDP_D_DP_EW_MUL_CFG_0    Field: ew_mul_src
  if (nvdla_sdp_d_dp_ew_mul_cfg_0_wren) begin
    ew_mul_src <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_DP_EW_MUL_CVT_OFFSET_VALUE_0    Field: ew_mul_cvt_offset
  if (nvdla_sdp_d_dp_ew_mul_cvt_offset_value_0_wren) begin
    ew_mul_cvt_offset[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_D_DP_EW_MUL_CVT_SCALE_VALUE_0    Field: ew_mul_cvt_scale
  if (nvdla_sdp_d_dp_ew_mul_cvt_scale_value_0_wren) begin
    ew_mul_cvt_scale[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_SDP_D_DP_EW_MUL_CVT_TRUNCATE_VALUE_0    Field: ew_mul_cvt_truncate
  if (nvdla_sdp_d_dp_ew_mul_cvt_truncate_value_0_wren) begin
    ew_mul_cvt_truncate[5:0] <= reg_wr_data[5:0];
  end

  // Register: NVDLA_SDP_D_DP_EW_MUL_SRC_VALUE_0    Field: ew_mul_operand
  if (nvdla_sdp_d_dp_ew_mul_src_value_0_wren) begin
    ew_mul_operand[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_D_DP_EW_TRUNCATE_VALUE_0    Field: ew_truncate
  if (nvdla_sdp_d_dp_ew_truncate_value_0_wren) begin
    ew_truncate[9:0] <= reg_wr_data[9:0];
  end

  // Register: NVDLA_SDP_D_DST_BASE_ADDR_HIGH_0    Field: dst_base_addr_high
  if (nvdla_sdp_d_dst_base_addr_high_0_wren) begin
    dst_base_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_D_DST_BASE_ADDR_LOW_0    Field: dst_base_addr_low
  if (nvdla_sdp_d_dst_base_addr_low_0_wren) begin
    dst_base_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_D_DST_BATCH_STRIDE_0    Field: dst_batch_stride
  if (nvdla_sdp_d_dst_batch_stride_0_wren) begin
    dst_batch_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_D_DST_DMA_CFG_0    Field: dst_ram_type
  if (nvdla_sdp_d_dst_dma_cfg_0_wren) begin
    dst_ram_type <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_DST_LINE_STRIDE_0    Field: dst_line_stride
  if (nvdla_sdp_d_dst_line_stride_0_wren) begin
    dst_line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_D_DST_SURFACE_STRIDE_0    Field: dst_surface_stride
  if (nvdla_sdp_d_dst_surface_stride_0_wren) begin
    dst_surface_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_D_FEATURE_MODE_CFG_0    Field: batch_number
  if (nvdla_sdp_d_feature_mode_cfg_0_wren) begin
    batch_number[4:0] <= reg_wr_data[12:8];
  end

  // Register: NVDLA_SDP_D_FEATURE_MODE_CFG_0    Field: flying_mode
  if (nvdla_sdp_d_feature_mode_cfg_0_wren) begin
    flying_mode <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_FEATURE_MODE_CFG_0    Field: nan_to_zero
  if (nvdla_sdp_d_feature_mode_cfg_0_wren) begin
    nan_to_zero <= reg_wr_data[3];
  end

  // Register: NVDLA_SDP_D_FEATURE_MODE_CFG_0    Field: output_dst
  if (nvdla_sdp_d_feature_mode_cfg_0_wren) begin
    output_dst <= reg_wr_data[1];
  end

  // Register: NVDLA_SDP_D_FEATURE_MODE_CFG_0    Field: winograd
  if (nvdla_sdp_d_feature_mode_cfg_0_wren) begin
    winograd <= reg_wr_data[2];
  end

  // Not generating flops for field NVDLA_SDP_D_OP_ENABLE_0::op_en (to be implemented outside)

  // Register: NVDLA_SDP_D_PERF_ENABLE_0    Field: perf_dma_en
  if (nvdla_sdp_d_perf_enable_0_wren) begin
    perf_dma_en <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_D_PERF_ENABLE_0    Field: perf_lut_en
  if (nvdla_sdp_d_perf_enable_0_wren) begin
    perf_lut_en <= reg_wr_data[1];
  end

  // Register: NVDLA_SDP_D_PERF_ENABLE_0    Field: perf_nan_inf_count_en
  if (nvdla_sdp_d_perf_enable_0_wren) begin
    perf_nan_inf_count_en <= reg_wr_data[3];
  end

  // Register: NVDLA_SDP_D_PERF_ENABLE_0    Field: perf_sat_en
  if (nvdla_sdp_d_perf_enable_0_wren) begin
    perf_sat_en <= reg_wr_data[2];
  end

  // Not generating flops for read-only field NVDLA_SDP_D_PERF_LUT_HYBRID_0::lut_hybrid

  // Not generating flops for read-only field NVDLA_SDP_D_PERF_LUT_LE_HIT_0::lut_le_hit

  // Not generating flops for read-only field NVDLA_SDP_D_PERF_LUT_LO_HIT_0::lut_lo_hit

  // Not generating flops for read-only field NVDLA_SDP_D_PERF_LUT_OFLOW_0::lut_oflow

  // Not generating flops for read-only field NVDLA_SDP_D_PERF_LUT_UFLOW_0::lut_uflow

  // Not generating flops for read-only field NVDLA_SDP_D_PERF_OUT_SATURATION_0::out_saturation

  // Not generating flops for read-only field NVDLA_SDP_D_PERF_WDMA_WRITE_STALL_0::wdma_stall

  // Not generating flops for read-only field NVDLA_SDP_D_STATUS_0::status_unequal

  // Not generating flops for read-only field NVDLA_SDP_D_STATUS_INF_INPUT_NUM_0::status_inf_input_num

  // Not generating flops for read-only field NVDLA_SDP_D_STATUS_NAN_INPUT_NUM_0::status_nan_input_num

  // Not generating flops for read-only field NVDLA_SDP_D_STATUS_NAN_OUTPUT_NUM_0::status_nan_output_num

  end
end
// spyglass enable_block STARC-2.10.1.6, NoConstWithXZ, W443

// synopsys translate_off
// VCS coverage off
initial begin
  arreggen_dump                  = $test$plusargs("arreggen_dump_wr");
  arreggen_abort_on_rowr         = $test$plusargs("arreggen_abort_on_rowr");
  arreggen_abort_on_invalid_wr   = $test$plusargs("arreggen_abort_on_invalid_wr");
`ifdef VERILATOR
`else
  $timeformat(-9, 2, "ns", 15);
`endif
end

always @(posedge nvdla_core_clk) begin
  if (reg_wr_en) begin
    case(reg_offset)
      (32'hb0c0  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_CVT_OFFSET_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_cvt_offset_0_out, nvdla_sdp_d_cvt_offset_0_out);
      (32'hb0c4  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_CVT_SCALE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_cvt_scale_0_out, nvdla_sdp_d_cvt_scale_0_out);
      (32'hb0c8  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_CVT_SHIFT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_cvt_shift_0_out, nvdla_sdp_d_cvt_shift_0_out);
      (32'hb044  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DATA_CUBE_CHANNEL_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_data_cube_channel_0_out, nvdla_sdp_d_data_cube_channel_0_out);
      (32'hb040  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DATA_CUBE_HEIGHT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_data_cube_height_0_out, nvdla_sdp_d_data_cube_height_0_out);
      (32'hb03c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DATA_CUBE_WIDTH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_data_cube_width_0_out, nvdla_sdp_d_data_cube_width_0_out);
      (32'hb0bc  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DATA_FORMAT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_data_format_0_out, nvdla_sdp_d_data_format_0_out);
      (32'hb070  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_BN_ALU_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_bn_alu_cfg_0_out, nvdla_sdp_d_dp_bn_alu_cfg_0_out);
      (32'hb074  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_BN_ALU_SRC_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_bn_alu_src_value_0_out, nvdla_sdp_d_dp_bn_alu_src_value_0_out);
      (32'hb06c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_BN_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_bn_cfg_0_out, nvdla_sdp_d_dp_bn_cfg_0_out);
      (32'hb078  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_BN_MUL_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_bn_mul_cfg_0_out, nvdla_sdp_d_dp_bn_mul_cfg_0_out);
      (32'hb07c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_BN_MUL_SRC_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_bn_mul_src_value_0_out, nvdla_sdp_d_dp_bn_mul_src_value_0_out);
      (32'hb05c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_BS_ALU_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_bs_alu_cfg_0_out, nvdla_sdp_d_dp_bs_alu_cfg_0_out);
      (32'hb060  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_BS_ALU_SRC_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_bs_alu_src_value_0_out, nvdla_sdp_d_dp_bs_alu_src_value_0_out);
      (32'hb058  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_BS_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_bs_cfg_0_out, nvdla_sdp_d_dp_bs_cfg_0_out);
      (32'hb064  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_BS_MUL_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_bs_mul_cfg_0_out, nvdla_sdp_d_dp_bs_mul_cfg_0_out);
      (32'hb068  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_BS_MUL_SRC_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_bs_mul_src_value_0_out, nvdla_sdp_d_dp_bs_mul_src_value_0_out);
      (32'hb084  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_ALU_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_alu_cfg_0_out, nvdla_sdp_d_dp_ew_alu_cfg_0_out);
      (32'hb08c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_ALU_CVT_OFFSET_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_alu_cvt_offset_value_0_out, nvdla_sdp_d_dp_ew_alu_cvt_offset_value_0_out);
      (32'hb090  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_ALU_CVT_SCALE_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_alu_cvt_scale_value_0_out, nvdla_sdp_d_dp_ew_alu_cvt_scale_value_0_out);
      (32'hb094  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_ALU_CVT_TRUNCATE_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_alu_cvt_truncate_value_0_out, nvdla_sdp_d_dp_ew_alu_cvt_truncate_value_0_out);
      (32'hb088  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_ALU_SRC_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_alu_src_value_0_out, nvdla_sdp_d_dp_ew_alu_src_value_0_out);
      (32'hb080  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_cfg_0_out, nvdla_sdp_d_dp_ew_cfg_0_out);
      (32'hb098  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_MUL_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_mul_cfg_0_out, nvdla_sdp_d_dp_ew_mul_cfg_0_out);
      (32'hb0a0  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_MUL_CVT_OFFSET_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_mul_cvt_offset_value_0_out, nvdla_sdp_d_dp_ew_mul_cvt_offset_value_0_out);
      (32'hb0a4  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_MUL_CVT_SCALE_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_mul_cvt_scale_value_0_out, nvdla_sdp_d_dp_ew_mul_cvt_scale_value_0_out);
      (32'hb0a8  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_MUL_CVT_TRUNCATE_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_mul_cvt_truncate_value_0_out, nvdla_sdp_d_dp_ew_mul_cvt_truncate_value_0_out);
      (32'hb09c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_MUL_SRC_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_mul_src_value_0_out, nvdla_sdp_d_dp_ew_mul_src_value_0_out);
      (32'hb0ac  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DP_EW_TRUNCATE_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dp_ew_truncate_value_0_out, nvdla_sdp_d_dp_ew_truncate_value_0_out);
      (32'hb04c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DST_BASE_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dst_base_addr_high_0_out, nvdla_sdp_d_dst_base_addr_high_0_out);
      (32'hb048  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DST_BASE_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dst_base_addr_low_0_out, nvdla_sdp_d_dst_base_addr_low_0_out);
      (32'hb0b8  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DST_BATCH_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dst_batch_stride_0_out, nvdla_sdp_d_dst_batch_stride_0_out);
      (32'hb0b4  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DST_DMA_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dst_dma_cfg_0_out, nvdla_sdp_d_dst_dma_cfg_0_out);
      (32'hb050  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DST_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dst_line_stride_0_out, nvdla_sdp_d_dst_line_stride_0_out);
      (32'hb054  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_DST_SURFACE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_dst_surface_stride_0_out, nvdla_sdp_d_dst_surface_stride_0_out);
      (32'hb0b0  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_FEATURE_MODE_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_feature_mode_cfg_0_out, nvdla_sdp_d_feature_mode_cfg_0_out);
      (32'hb038  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_OP_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_op_enable_0_out, nvdla_sdp_d_op_enable_0_out);
      (32'hb0dc  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_D_PERF_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_d_perf_enable_0_out, nvdla_sdp_d_perf_enable_0_out);
      (32'hb0f0  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_PERF_LUT_HYBRID_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hb0f4  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_PERF_LUT_LE_HIT_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hb0f8  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_PERF_LUT_LO_HIT_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hb0e8  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_PERF_LUT_OFLOW_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hb0e4  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_PERF_LUT_UFLOW_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hb0ec  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_PERF_OUT_SATURATION_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hb0e0  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_PERF_WDMA_WRITE_STALL_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hb0cc  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_STATUS_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hb0d4  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_STATUS_INF_INPUT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hb0d0  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_STATUS_NAN_INPUT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hb0d8  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_D_STATUS_NAN_OUTPUT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      default: begin
          if (arreggen_dump) $display("%t:%m: reg wr: Unknown register (0x%h) = 0x%h", $time, reg_offset, reg_wr_data);
          if (arreggen_abort_on_invalid_wr) begin $display("ERROR: write to undefined register!"); $finish; end
        end
    endcase
  end
end

// VCS coverage on
// synopsys translate_on

endmodule // NV_NVDLA_SDP_REG_dual

