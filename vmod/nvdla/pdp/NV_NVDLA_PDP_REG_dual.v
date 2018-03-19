// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_REG_dual.v

module NV_NVDLA_PDP_REG_dual (
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
  ,cya
  ,cube_in_channel
  ,cube_in_height
  ,cube_in_width
  ,cube_out_channel
  ,cube_out_height
  ,cube_out_width
  ,input_data
  ,dst_base_addr_high
  ,dst_base_addr_low
  ,dst_line_stride
  ,dst_ram_type
  ,dst_surface_stride
  ,nan_to_zero
  ,flying_mode
  ,pooling_method
  ,split_num
  ,op_en_trigger
  ,partial_width_in_first
  ,partial_width_in_last
  ,partial_width_in_mid
  ,partial_width_out_first
  ,partial_width_out_last
  ,partial_width_out_mid
  ,dma_en
  ,kernel_height
  ,kernel_stride_height
  ,kernel_stride_width
  ,kernel_width
  ,pad_bottom
  ,pad_left
  ,pad_right
  ,pad_top
  ,pad_value_1x
  ,pad_value_2x
  ,pad_value_3x
  ,pad_value_4x
  ,pad_value_5x
  ,pad_value_6x
  ,pad_value_7x
  ,recip_kernel_height
  ,recip_kernel_width
  ,src_base_addr_high
  ,src_base_addr_low
  ,src_line_stride
  ,src_surface_stride
  ,inf_input_num
  ,nan_input_num
  ,nan_output_num
  ,op_en
  ,perf_write_stall
  );

wire   [31:0] nvdla_pdp_d_cya_0_out;
wire   [31:0] nvdla_pdp_d_data_cube_in_channel_0_out;
wire   [31:0] nvdla_pdp_d_data_cube_in_height_0_out;
wire   [31:0] nvdla_pdp_d_data_cube_in_width_0_out;
wire   [31:0] nvdla_pdp_d_data_cube_out_channel_0_out;
wire   [31:0] nvdla_pdp_d_data_cube_out_height_0_out;
wire   [31:0] nvdla_pdp_d_data_cube_out_width_0_out;
wire   [31:0] nvdla_pdp_d_data_format_0_out;
wire   [31:0] nvdla_pdp_d_dst_base_addr_high_0_out;
wire   [31:0] nvdla_pdp_d_dst_base_addr_low_0_out;
wire   [31:0] nvdla_pdp_d_dst_line_stride_0_out;
wire   [31:0] nvdla_pdp_d_dst_ram_cfg_0_out;
wire   [31:0] nvdla_pdp_d_dst_surface_stride_0_out;
wire   [31:0] nvdla_pdp_d_inf_input_num_0_out;
wire   [31:0] nvdla_pdp_d_nan_flush_to_zero_0_out;
wire   [31:0] nvdla_pdp_d_nan_input_num_0_out;
wire   [31:0] nvdla_pdp_d_nan_output_num_0_out;
wire   [31:0] nvdla_pdp_d_op_enable_0_out;
wire   [31:0] nvdla_pdp_d_operation_mode_cfg_0_out;
wire   [31:0] nvdla_pdp_d_partial_width_in_0_out;
wire   [31:0] nvdla_pdp_d_partial_width_out_0_out;
wire   [31:0] nvdla_pdp_d_perf_enable_0_out;
wire   [31:0] nvdla_pdp_d_perf_write_stall_0_out;
wire   [31:0] nvdla_pdp_d_pooling_kernel_cfg_0_out;
wire   [31:0] nvdla_pdp_d_pooling_padding_cfg_0_out;
wire   [31:0] nvdla_pdp_d_pooling_padding_value_1_cfg_0_out;
wire   [31:0] nvdla_pdp_d_pooling_padding_value_2_cfg_0_out;
wire   [31:0] nvdla_pdp_d_pooling_padding_value_3_cfg_0_out;
wire   [31:0] nvdla_pdp_d_pooling_padding_value_4_cfg_0_out;
wire   [31:0] nvdla_pdp_d_pooling_padding_value_5_cfg_0_out;
wire   [31:0] nvdla_pdp_d_pooling_padding_value_6_cfg_0_out;
wire   [31:0] nvdla_pdp_d_pooling_padding_value_7_cfg_0_out;
wire   [31:0] nvdla_pdp_d_recip_kernel_height_0_out;
wire   [31:0] nvdla_pdp_d_recip_kernel_width_0_out;
wire   [31:0] nvdla_pdp_d_src_base_addr_high_0_out;
wire   [31:0] nvdla_pdp_d_src_base_addr_low_0_out;
wire   [31:0] nvdla_pdp_d_src_line_stride_0_out;
wire   [31:0] nvdla_pdp_d_src_surface_stride_0_out;
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
output [31:0] cya;
output [12:0] cube_in_channel;
output [12:0] cube_in_height;
output [12:0] cube_in_width;
output [12:0] cube_out_channel;
output [12:0] cube_out_height;
output [12:0] cube_out_width;
output [1:0]  input_data;
output [31:0] dst_base_addr_high;
output [31:0] dst_base_addr_low;
output [31:0] dst_line_stride;
output        dst_ram_type;
output [31:0] dst_surface_stride;
output        nan_to_zero;
output        flying_mode;
output [1:0]  pooling_method;
output [7:0]  split_num;
output        op_en_trigger;
output [9:0]  partial_width_in_first;
output [9:0]  partial_width_in_last;
output [9:0]  partial_width_in_mid;
output [9:0]  partial_width_out_first;
output [9:0]  partial_width_out_last;
output [9:0]  partial_width_out_mid;
output        dma_en;
output [3:0]  kernel_height;
output [3:0]  kernel_stride_height;
output [3:0]  kernel_stride_width;
output [3:0]  kernel_width;
output [2:0]  pad_bottom;
output [2:0]  pad_left;
output [2:0]  pad_right;
output [2:0]  pad_top;
output [18:0] pad_value_1x;
output [18:0] pad_value_2x;
output [18:0] pad_value_3x;
output [18:0] pad_value_4x;
output [18:0] pad_value_5x;
output [18:0] pad_value_6x;
output [18:0] pad_value_7x;
output [16:0] recip_kernel_height;
output [16:0] recip_kernel_width;
output [31:0] src_base_addr_high;
output [31:0] src_base_addr_low;
output [31:0] src_line_stride;
output [31:0] src_surface_stride;

// Read-only register inputs
input [31:0]  inf_input_num;
input [31:0]  nan_input_num;
input [31:0]  nan_output_num;
input         op_en;
input [31:0]  perf_write_stall;

// wr_mask register inputs

// rstn register inputs

// leda FM_2_23 off
reg           arreggen_abort_on_invalid_wr;
reg           arreggen_abort_on_rowr;
reg           arreggen_dump;
// leda FM_2_23 on
reg    [12:0] cube_in_channel;
reg    [12:0] cube_in_height;
reg    [12:0] cube_in_width;
reg    [12:0] cube_out_channel;
reg    [12:0] cube_out_height;
reg    [12:0] cube_out_width;
reg    [31:0] cya;
reg           dma_en;
reg    [31:0] dst_base_addr_high;
reg    [31:0] dst_base_addr_low;
reg    [31:0] dst_line_stride;
reg           dst_ram_type;
reg    [31:0] dst_surface_stride;
reg           flying_mode;
reg     [1:0] input_data;
reg     [3:0] kernel_height;
reg     [3:0] kernel_stride_height;
reg     [3:0] kernel_stride_width;
reg     [3:0] kernel_width;
reg           nan_to_zero;
reg     [2:0] pad_bottom;
reg     [2:0] pad_left;
reg     [2:0] pad_right;
reg     [2:0] pad_top;
reg    [18:0] pad_value_1x;
reg    [18:0] pad_value_2x;
reg    [18:0] pad_value_3x;
reg    [18:0] pad_value_4x;
reg    [18:0] pad_value_5x;
reg    [18:0] pad_value_6x;
reg    [18:0] pad_value_7x;
reg     [9:0] partial_width_in_first;
reg     [9:0] partial_width_in_last;
reg     [9:0] partial_width_in_mid;
reg     [9:0] partial_width_out_first;
reg     [9:0] partial_width_out_last;
reg     [9:0] partial_width_out_mid;
reg     [1:0] pooling_method;
reg    [16:0] recip_kernel_height;
reg    [16:0] recip_kernel_width;
reg    [31:0] reg_rd_data;
reg     [7:0] split_num;
reg    [31:0] src_base_addr_high;
reg    [31:0] src_base_addr_low;
reg    [31:0] src_line_stride;
reg    [31:0] src_surface_stride;

assign reg_offset_wr = {20'b0 , reg_offset};
// SCR signals

// Address decode
wire nvdla_pdp_d_cya_0_wren = (reg_offset_wr == (32'hd09c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_data_cube_in_channel_0_wren = (reg_offset_wr == (32'hd014  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_data_cube_in_height_0_wren = (reg_offset_wr == (32'hd010  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_data_cube_in_width_0_wren = (reg_offset_wr == (32'hd00c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_data_cube_out_channel_0_wren = (reg_offset_wr == (32'hd020  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_data_cube_out_height_0_wren = (reg_offset_wr == (32'hd01c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_data_cube_out_width_0_wren = (reg_offset_wr == (32'hd018  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_data_format_0_wren = (reg_offset_wr == (32'hd084  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_dst_base_addr_high_0_wren = (reg_offset_wr == (32'hd074  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_dst_base_addr_low_0_wren = (reg_offset_wr == (32'hd070  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_dst_line_stride_0_wren = (reg_offset_wr == (32'hd078  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_dst_ram_cfg_0_wren = (reg_offset_wr == (32'hd080  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_dst_surface_stride_0_wren = (reg_offset_wr == (32'hd07c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_inf_input_num_0_wren = (reg_offset_wr == (32'hd088  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_nan_flush_to_zero_0_wren = (reg_offset_wr == (32'hd028  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_nan_input_num_0_wren = (reg_offset_wr == (32'hd08c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_nan_output_num_0_wren = (reg_offset_wr == (32'hd090  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_operation_mode_cfg_0_wren = (reg_offset_wr == (32'hd024  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_op_enable_0_wren = (reg_offset_wr == (32'hd008  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_partial_width_in_0_wren = (reg_offset_wr == (32'hd02c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_partial_width_out_0_wren = (reg_offset_wr == (32'hd030  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_perf_enable_0_wren = (reg_offset_wr == (32'hd094  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_perf_write_stall_0_wren = (reg_offset_wr == (32'hd098  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_pooling_kernel_cfg_0_wren = (reg_offset_wr == (32'hd034  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_pooling_padding_cfg_0_wren = (reg_offset_wr == (32'hd040  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_pooling_padding_value_1_cfg_0_wren = (reg_offset_wr == (32'hd044  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_pooling_padding_value_2_cfg_0_wren = (reg_offset_wr == (32'hd048  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_pooling_padding_value_3_cfg_0_wren = (reg_offset_wr == (32'hd04c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_pooling_padding_value_4_cfg_0_wren = (reg_offset_wr == (32'hd050  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_pooling_padding_value_5_cfg_0_wren = (reg_offset_wr == (32'hd054  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_pooling_padding_value_6_cfg_0_wren = (reg_offset_wr == (32'hd058  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_pooling_padding_value_7_cfg_0_wren = (reg_offset_wr == (32'hd05c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_recip_kernel_height_0_wren = (reg_offset_wr == (32'hd03c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_recip_kernel_width_0_wren = (reg_offset_wr == (32'hd038  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_src_base_addr_high_0_wren = (reg_offset_wr == (32'hd064  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_src_base_addr_low_0_wren = (reg_offset_wr == (32'hd060  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_src_line_stride_0_wren = (reg_offset_wr == (32'hd068  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_pdp_d_src_surface_stride_0_wren = (reg_offset_wr == (32'hd06c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)

assign nvdla_pdp_d_cya_0_out[31:0] = { cya };
assign nvdla_pdp_d_data_cube_in_channel_0_out[31:0] = { 19'b0, cube_in_channel };
assign nvdla_pdp_d_data_cube_in_height_0_out[31:0] = { 19'b0, cube_in_height };
assign nvdla_pdp_d_data_cube_in_width_0_out[31:0] = { 19'b0, cube_in_width };
assign nvdla_pdp_d_data_cube_out_channel_0_out[31:0] = { 19'b0, cube_out_channel };
assign nvdla_pdp_d_data_cube_out_height_0_out[31:0] = { 19'b0, cube_out_height };
assign nvdla_pdp_d_data_cube_out_width_0_out[31:0] = { 19'b0, cube_out_width };
assign nvdla_pdp_d_data_format_0_out[31:0] = { 30'b0, input_data };
assign nvdla_pdp_d_dst_base_addr_high_0_out[31:0] = { dst_base_addr_high };
//assign nvdla_pdp_d_dst_base_addr_low_0_out[31:0] = { dst_base_addr_low, 5'b0 };
assign nvdla_pdp_d_dst_base_addr_low_0_out[31:0] = { dst_base_addr_low };
assign nvdla_pdp_d_dst_line_stride_0_out[31:0] = { dst_line_stride };
assign nvdla_pdp_d_dst_ram_cfg_0_out[31:0] = { 31'b0, dst_ram_type };
assign nvdla_pdp_d_dst_surface_stride_0_out[31:0] = { dst_surface_stride };
assign nvdla_pdp_d_inf_input_num_0_out[31:0] = { inf_input_num };
assign nvdla_pdp_d_nan_flush_to_zero_0_out[31:0] = { 31'b0, nan_to_zero };
assign nvdla_pdp_d_nan_input_num_0_out[31:0] = { nan_input_num };
assign nvdla_pdp_d_nan_output_num_0_out[31:0] = { nan_output_num };
assign nvdla_pdp_d_operation_mode_cfg_0_out[31:0] = { 16'b0, split_num, 3'b0, flying_mode, 2'b0, pooling_method };
assign nvdla_pdp_d_op_enable_0_out[31:0] = { 31'b0, op_en };
assign nvdla_pdp_d_partial_width_in_0_out[31:0] = { 2'b0, partial_width_in_mid, partial_width_in_last, partial_width_in_first };
assign nvdla_pdp_d_partial_width_out_0_out[31:0] = { 2'b0, partial_width_out_mid, partial_width_out_last, partial_width_out_first };
assign nvdla_pdp_d_perf_enable_0_out[31:0] = { 31'b0, dma_en };
assign nvdla_pdp_d_perf_write_stall_0_out[31:0] = { perf_write_stall };
assign nvdla_pdp_d_pooling_kernel_cfg_0_out[31:0] = { 8'b0, kernel_stride_height, kernel_stride_width, 4'b0, kernel_height, 4'b0, kernel_width };
assign nvdla_pdp_d_pooling_padding_cfg_0_out[31:0] = { 17'b0, pad_bottom, 1'b0, pad_right, 1'b0, pad_top, 1'b0, pad_left };
assign nvdla_pdp_d_pooling_padding_value_1_cfg_0_out[31:0] = { 13'b0, pad_value_1x };
assign nvdla_pdp_d_pooling_padding_value_2_cfg_0_out[31:0] = { 13'b0, pad_value_2x };
assign nvdla_pdp_d_pooling_padding_value_3_cfg_0_out[31:0] = { 13'b0, pad_value_3x };
assign nvdla_pdp_d_pooling_padding_value_4_cfg_0_out[31:0] = { 13'b0, pad_value_4x };
assign nvdla_pdp_d_pooling_padding_value_5_cfg_0_out[31:0] = { 13'b0, pad_value_5x };
assign nvdla_pdp_d_pooling_padding_value_6_cfg_0_out[31:0] = { 13'b0, pad_value_6x };
assign nvdla_pdp_d_pooling_padding_value_7_cfg_0_out[31:0] = { 13'b0, pad_value_7x };
assign nvdla_pdp_d_recip_kernel_height_0_out[31:0] = { 15'b0, recip_kernel_height };
assign nvdla_pdp_d_recip_kernel_width_0_out[31:0] = { 15'b0, recip_kernel_width };
assign nvdla_pdp_d_src_base_addr_high_0_out[31:0] = { src_base_addr_high };
assign nvdla_pdp_d_src_base_addr_low_0_out[31:0] = { src_base_addr_low };
assign nvdla_pdp_d_src_line_stride_0_out[31:0] = { src_line_stride };
assign nvdla_pdp_d_src_surface_stride_0_out[31:0] = { src_surface_stride };

assign op_en_trigger = nvdla_pdp_d_op_enable_0_wren;  //(W563)

assign reg_offset_rd_int = reg_offset;
// Output mux
//spyglass disable_block W338, W263 
always @(
  reg_offset_rd_int
  or nvdla_pdp_d_cya_0_out
  or nvdla_pdp_d_data_cube_in_channel_0_out
  or nvdla_pdp_d_data_cube_in_height_0_out
  or nvdla_pdp_d_data_cube_in_width_0_out
  or nvdla_pdp_d_data_cube_out_channel_0_out
  or nvdla_pdp_d_data_cube_out_height_0_out
  or nvdla_pdp_d_data_cube_out_width_0_out
  or nvdla_pdp_d_data_format_0_out
  or nvdla_pdp_d_dst_base_addr_high_0_out
  or nvdla_pdp_d_dst_base_addr_low_0_out
  or nvdla_pdp_d_dst_line_stride_0_out
  or nvdla_pdp_d_dst_ram_cfg_0_out
  or nvdla_pdp_d_dst_surface_stride_0_out
  or nvdla_pdp_d_inf_input_num_0_out
  or nvdla_pdp_d_nan_flush_to_zero_0_out
  or nvdla_pdp_d_nan_input_num_0_out
  or nvdla_pdp_d_nan_output_num_0_out
  or nvdla_pdp_d_operation_mode_cfg_0_out
  or nvdla_pdp_d_op_enable_0_out
  or nvdla_pdp_d_partial_width_in_0_out
  or nvdla_pdp_d_partial_width_out_0_out
  or nvdla_pdp_d_perf_enable_0_out
  or nvdla_pdp_d_perf_write_stall_0_out
  or nvdla_pdp_d_pooling_kernel_cfg_0_out
  or nvdla_pdp_d_pooling_padding_cfg_0_out
  or nvdla_pdp_d_pooling_padding_value_1_cfg_0_out
  or nvdla_pdp_d_pooling_padding_value_2_cfg_0_out
  or nvdla_pdp_d_pooling_padding_value_3_cfg_0_out
  or nvdla_pdp_d_pooling_padding_value_4_cfg_0_out
  or nvdla_pdp_d_pooling_padding_value_5_cfg_0_out
  or nvdla_pdp_d_pooling_padding_value_6_cfg_0_out
  or nvdla_pdp_d_pooling_padding_value_7_cfg_0_out
  or nvdla_pdp_d_recip_kernel_height_0_out
  or nvdla_pdp_d_recip_kernel_width_0_out
  or nvdla_pdp_d_src_base_addr_high_0_out
  or nvdla_pdp_d_src_base_addr_low_0_out
  or nvdla_pdp_d_src_line_stride_0_out
  or nvdla_pdp_d_src_surface_stride_0_out
  ) begin
  case (reg_offset_rd_int)
     (32'hd09c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_cya_0_out ;
                            end 
     (32'hd014  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_data_cube_in_channel_0_out ;
                            end 
     (32'hd010  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_data_cube_in_height_0_out ;
                            end 
     (32'hd00c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_data_cube_in_width_0_out ;
                            end 
     (32'hd020  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_data_cube_out_channel_0_out ;
                            end 
     (32'hd01c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_data_cube_out_height_0_out ;
                            end 
     (32'hd018  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_data_cube_out_width_0_out ;
                            end 
     (32'hd084  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_data_format_0_out ;
                            end 
     (32'hd074  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_dst_base_addr_high_0_out ;
                            end 
     (32'hd070  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_dst_base_addr_low_0_out ;
                            end 
     (32'hd078  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_dst_line_stride_0_out ;
                            end 
     (32'hd080  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_dst_ram_cfg_0_out ;
                            end 
     (32'hd07c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_dst_surface_stride_0_out ;
                            end 
     (32'hd088  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_inf_input_num_0_out ;
                            end 
     (32'hd028  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_nan_flush_to_zero_0_out ;
                            end 
     (32'hd08c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_nan_input_num_0_out ;
                            end 
     (32'hd090  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_nan_output_num_0_out ;
                            end 
     (32'hd024  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_operation_mode_cfg_0_out ;
                            end 
     (32'hd008  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_op_enable_0_out ;
                            end 
     (32'hd02c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_partial_width_in_0_out ;
                            end 
     (32'hd030  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_partial_width_out_0_out ;
                            end 
     (32'hd094  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_perf_enable_0_out ;
                            end 
     (32'hd098  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_perf_write_stall_0_out ;
                            end 
     (32'hd034  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_pooling_kernel_cfg_0_out ;
                            end 
     (32'hd040  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_pooling_padding_cfg_0_out ;
                            end 
     (32'hd044  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_pooling_padding_value_1_cfg_0_out ;
                            end 
     (32'hd048  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_pooling_padding_value_2_cfg_0_out ;
                            end 
     (32'hd04c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_pooling_padding_value_3_cfg_0_out ;
                            end 
     (32'hd050  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_pooling_padding_value_4_cfg_0_out ;
                            end 
     (32'hd054  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_pooling_padding_value_5_cfg_0_out ;
                            end 
     (32'hd058  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_pooling_padding_value_6_cfg_0_out ;
                            end 
     (32'hd05c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_pooling_padding_value_7_cfg_0_out ;
                            end 
     (32'hd03c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_recip_kernel_height_0_out ;
                            end 
     (32'hd038  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_recip_kernel_width_0_out ;
                            end 
     (32'hd064  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_src_base_addr_high_0_out ;
                            end 
     (32'hd060  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_src_base_addr_low_0_out ;
                            end 
     (32'hd068  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_src_line_stride_0_out ;
                            end 
     (32'hd06c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_pdp_d_src_surface_stride_0_out ;
                            end 
    default: reg_rd_data = {32{1'b0}};
  endcase
end

//spyglass enable_block W338, W263

// spyglass disable_block STARC-2.10.1.6, NoConstWithXZ, W443

// Register flop declarations
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cya[31:0] <= 32'b00000000000000000000000000000000;
    cube_in_channel[12:0] <= 13'b0000000000000;
    cube_in_height[12:0] <= 13'b0000000000000;
    cube_in_width[12:0] <= 13'b0000000000000;
    cube_out_channel[12:0] <= 13'b0000000000000;
    cube_out_height[12:0] <= 13'b0000000000000;
    cube_out_width[12:0] <= 13'b0000000000000;
    input_data[1:0] <= 2'b00;
    dst_base_addr_high[31:0] <= 32'b00000000000000000000000000000000;
    dst_base_addr_low[31:0] <= 32'b00000000000000000000000000000000;
    dst_line_stride[31:0] <= 32'b00000000000000000000000000000000;
    dst_ram_type <= 1'b0;
    dst_surface_stride[31:0] <= 32'b00000000000000000000000000000000;
    nan_to_zero <= 1'b0;
    flying_mode <= 1'b0;
    pooling_method[1:0] <= 2'b00;
    split_num[7:0] <= 8'b00000000;
    partial_width_in_first[9:0] <= 10'b0000000000;
    partial_width_in_last[9:0] <= 10'b0000000000;
    partial_width_in_mid[9:0] <= 10'b0000000000;
    partial_width_out_first[9:0] <= 10'b0000000000;
    partial_width_out_last[9:0] <= 10'b0000000000;
    partial_width_out_mid[9:0] <= 10'b0000000000;
    dma_en <= 1'b0;
    kernel_height[3:0] <= 4'b0000;
    kernel_stride_height[3:0] <= 4'b0000;
    kernel_stride_width[3:0] <= 4'b0000;
    kernel_width[3:0] <= 4'b0000;
    pad_bottom[2:0] <= 3'b000;
    pad_left[2:0] <= 3'b000;
    pad_right[2:0] <= 3'b000;
    pad_top[2:0] <= 3'b000;
    pad_value_1x[18:0] <= 19'b0000000000000000000;
    pad_value_2x[18:0] <= 19'b0000000000000000000;
    pad_value_3x[18:0] <= 19'b0000000000000000000;
    pad_value_4x[18:0] <= 19'b0000000000000000000;
    pad_value_5x[18:0] <= 19'b0000000000000000000;
    pad_value_6x[18:0] <= 19'b0000000000000000000;
    pad_value_7x[18:0] <= 19'b0000000000000000000;
    recip_kernel_height[16:0] <= 17'b00000000000000000;
    recip_kernel_width[16:0] <= 17'b00000000000000000;
    src_base_addr_high[31:0] <= 32'b00000000000000000000000000000000;
    src_base_addr_low[31:0] <= 32'b00000000000000000000000000000000;
    src_line_stride[31:0] <= 32'b00000000000000000000000000000000;
    src_surface_stride[31:0] <= 32'b00000000000000000000000000000000;
  end else begin
  // Register: NVDLA_PDP_D_CYA_0    Field: cya
  if (nvdla_pdp_d_cya_0_wren) begin
    cya[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_PDP_D_DATA_CUBE_IN_CHANNEL_0    Field: cube_in_channel
  if (nvdla_pdp_d_data_cube_in_channel_0_wren) begin
    cube_in_channel[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_PDP_D_DATA_CUBE_IN_HEIGHT_0    Field: cube_in_height
  if (nvdla_pdp_d_data_cube_in_height_0_wren) begin
    cube_in_height[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_PDP_D_DATA_CUBE_IN_WIDTH_0    Field: cube_in_width
  if (nvdla_pdp_d_data_cube_in_width_0_wren) begin
    cube_in_width[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_PDP_D_DATA_CUBE_OUT_CHANNEL_0    Field: cube_out_channel
  if (nvdla_pdp_d_data_cube_out_channel_0_wren) begin
    cube_out_channel[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_PDP_D_DATA_CUBE_OUT_HEIGHT_0    Field: cube_out_height
  if (nvdla_pdp_d_data_cube_out_height_0_wren) begin
    cube_out_height[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_PDP_D_DATA_CUBE_OUT_WIDTH_0    Field: cube_out_width
  if (nvdla_pdp_d_data_cube_out_width_0_wren) begin
    cube_out_width[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_PDP_D_DATA_FORMAT_0    Field: input_data
  if (nvdla_pdp_d_data_format_0_wren) begin
    input_data[1:0] <= reg_wr_data[1:0];
  end

  // Register: NVDLA_PDP_D_DST_BASE_ADDR_HIGH_0    Field: dst_base_addr_high
  if (nvdla_pdp_d_dst_base_addr_high_0_wren) begin
    dst_base_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_PDP_D_DST_BASE_ADDR_LOW_0    Field: dst_base_addr_low
  if (nvdla_pdp_d_dst_base_addr_low_0_wren) begin
    dst_base_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_PDP_D_DST_LINE_STRIDE_0    Field: dst_line_stride
  if (nvdla_pdp_d_dst_line_stride_0_wren) begin
    dst_line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_PDP_D_DST_RAM_CFG_0    Field: dst_ram_type
  if (nvdla_pdp_d_dst_ram_cfg_0_wren) begin
    dst_ram_type <= reg_wr_data[0];
  end

  // Register: NVDLA_PDP_D_DST_SURFACE_STRIDE_0    Field: dst_surface_stride
  if (nvdla_pdp_d_dst_surface_stride_0_wren) begin
    dst_surface_stride[31:0] <= reg_wr_data[31:0];
  end

  // Not generating flops for read-only field NVDLA_PDP_D_INF_INPUT_NUM_0::inf_input_num

  // Register: NVDLA_PDP_D_NAN_FLUSH_TO_ZERO_0    Field: nan_to_zero
  if (nvdla_pdp_d_nan_flush_to_zero_0_wren) begin
    nan_to_zero <= reg_wr_data[0];
  end

  // Not generating flops for read-only field NVDLA_PDP_D_NAN_INPUT_NUM_0::nan_input_num

  // Not generating flops for read-only field NVDLA_PDP_D_NAN_OUTPUT_NUM_0::nan_output_num

  // Register: NVDLA_PDP_D_OPERATION_MODE_CFG_0    Field: flying_mode
  if (nvdla_pdp_d_operation_mode_cfg_0_wren) begin
    flying_mode <= reg_wr_data[4];
  end

  // Register: NVDLA_PDP_D_OPERATION_MODE_CFG_0    Field: pooling_method
  if (nvdla_pdp_d_operation_mode_cfg_0_wren) begin
    pooling_method[1:0] <= reg_wr_data[1:0];
  end

  // Register: NVDLA_PDP_D_OPERATION_MODE_CFG_0    Field: split_num
  if (nvdla_pdp_d_operation_mode_cfg_0_wren) begin
    split_num[7:0] <= reg_wr_data[15:8];
  end

  // Not generating flops for field NVDLA_PDP_D_OP_ENABLE_0::op_en (to be implemented outside)

  // Register: NVDLA_PDP_D_PARTIAL_WIDTH_IN_0    Field: partial_width_in_first
  if (nvdla_pdp_d_partial_width_in_0_wren) begin
    partial_width_in_first[9:0] <= reg_wr_data[9:0];
  end

  // Register: NVDLA_PDP_D_PARTIAL_WIDTH_IN_0    Field: partial_width_in_last
  if (nvdla_pdp_d_partial_width_in_0_wren) begin
    partial_width_in_last[9:0] <= reg_wr_data[19:10];
  end

  // Register: NVDLA_PDP_D_PARTIAL_WIDTH_IN_0    Field: partial_width_in_mid
  if (nvdla_pdp_d_partial_width_in_0_wren) begin
    partial_width_in_mid[9:0] <= reg_wr_data[29:20];
  end

  // Register: NVDLA_PDP_D_PARTIAL_WIDTH_OUT_0    Field: partial_width_out_first
  if (nvdla_pdp_d_partial_width_out_0_wren) begin
    partial_width_out_first[9:0] <= reg_wr_data[9:0];
  end

  // Register: NVDLA_PDP_D_PARTIAL_WIDTH_OUT_0    Field: partial_width_out_last
  if (nvdla_pdp_d_partial_width_out_0_wren) begin
    partial_width_out_last[9:0] <= reg_wr_data[19:10];
  end

  // Register: NVDLA_PDP_D_PARTIAL_WIDTH_OUT_0    Field: partial_width_out_mid
  if (nvdla_pdp_d_partial_width_out_0_wren) begin
    partial_width_out_mid[9:0] <= reg_wr_data[29:20];
  end

  // Register: NVDLA_PDP_D_PERF_ENABLE_0    Field: dma_en
  if (nvdla_pdp_d_perf_enable_0_wren) begin
    dma_en <= reg_wr_data[0];
  end

  // Not generating flops for read-only field NVDLA_PDP_D_PERF_WRITE_STALL_0::perf_write_stall

  // Register: NVDLA_PDP_D_POOLING_KERNEL_CFG_0    Field: kernel_height
  if (nvdla_pdp_d_pooling_kernel_cfg_0_wren) begin
    kernel_height[3:0] <= reg_wr_data[11:8];
  end

  // Register: NVDLA_PDP_D_POOLING_KERNEL_CFG_0    Field: kernel_stride_height
  if (nvdla_pdp_d_pooling_kernel_cfg_0_wren) begin
    kernel_stride_height[3:0] <= reg_wr_data[23:20];
  end

  // Register: NVDLA_PDP_D_POOLING_KERNEL_CFG_0    Field: kernel_stride_width
  if (nvdla_pdp_d_pooling_kernel_cfg_0_wren) begin
    kernel_stride_width[3:0] <= reg_wr_data[19:16];
  end

  // Register: NVDLA_PDP_D_POOLING_KERNEL_CFG_0    Field: kernel_width
  if (nvdla_pdp_d_pooling_kernel_cfg_0_wren) begin
    kernel_width[3:0] <= reg_wr_data[3:0];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_CFG_0    Field: pad_bottom
  if (nvdla_pdp_d_pooling_padding_cfg_0_wren) begin
    pad_bottom[2:0] <= reg_wr_data[14:12];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_CFG_0    Field: pad_left
  if (nvdla_pdp_d_pooling_padding_cfg_0_wren) begin
    pad_left[2:0] <= reg_wr_data[2:0];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_CFG_0    Field: pad_right
  if (nvdla_pdp_d_pooling_padding_cfg_0_wren) begin
    pad_right[2:0] <= reg_wr_data[10:8];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_CFG_0    Field: pad_top
  if (nvdla_pdp_d_pooling_padding_cfg_0_wren) begin
    pad_top[2:0] <= reg_wr_data[6:4];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_VALUE_1_CFG_0    Field: pad_value_1x
  if (nvdla_pdp_d_pooling_padding_value_1_cfg_0_wren) begin
    pad_value_1x[18:0] <= reg_wr_data[18:0];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_VALUE_2_CFG_0    Field: pad_value_2x
  if (nvdla_pdp_d_pooling_padding_value_2_cfg_0_wren) begin
    pad_value_2x[18:0] <= reg_wr_data[18:0];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_VALUE_3_CFG_0    Field: pad_value_3x
  if (nvdla_pdp_d_pooling_padding_value_3_cfg_0_wren) begin
    pad_value_3x[18:0] <= reg_wr_data[18:0];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_VALUE_4_CFG_0    Field: pad_value_4x
  if (nvdla_pdp_d_pooling_padding_value_4_cfg_0_wren) begin
    pad_value_4x[18:0] <= reg_wr_data[18:0];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_VALUE_5_CFG_0    Field: pad_value_5x
  if (nvdla_pdp_d_pooling_padding_value_5_cfg_0_wren) begin
    pad_value_5x[18:0] <= reg_wr_data[18:0];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_VALUE_6_CFG_0    Field: pad_value_6x
  if (nvdla_pdp_d_pooling_padding_value_6_cfg_0_wren) begin
    pad_value_6x[18:0] <= reg_wr_data[18:0];
  end

  // Register: NVDLA_PDP_D_POOLING_PADDING_VALUE_7_CFG_0    Field: pad_value_7x
  if (nvdla_pdp_d_pooling_padding_value_7_cfg_0_wren) begin
    pad_value_7x[18:0] <= reg_wr_data[18:0];
  end

  // Register: NVDLA_PDP_D_RECIP_KERNEL_HEIGHT_0    Field: recip_kernel_height
  if (nvdla_pdp_d_recip_kernel_height_0_wren) begin
    recip_kernel_height[16:0] <= reg_wr_data[16:0];
  end

  // Register: NVDLA_PDP_D_RECIP_KERNEL_WIDTH_0    Field: recip_kernel_width
  if (nvdla_pdp_d_recip_kernel_width_0_wren) begin
    recip_kernel_width[16:0] <= reg_wr_data[16:0];
  end

  // Register: NVDLA_PDP_D_SRC_BASE_ADDR_HIGH_0    Field: src_base_addr_high
  if (nvdla_pdp_d_src_base_addr_high_0_wren) begin
    src_base_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_PDP_D_SRC_BASE_ADDR_LOW_0    Field: src_base_addr_low
  if (nvdla_pdp_d_src_base_addr_low_0_wren) begin
    src_base_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_PDP_D_SRC_LINE_STRIDE_0    Field: src_line_stride
  if (nvdla_pdp_d_src_line_stride_0_wren) begin
    src_line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_PDP_D_SRC_SURFACE_STRIDE_0    Field: src_surface_stride
  if (nvdla_pdp_d_src_surface_stride_0_wren) begin
    src_surface_stride[31:0] <= reg_wr_data[31:0];
  end

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
      (32'hd09c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_CYA_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_cya_0_out, nvdla_pdp_d_cya_0_out);
      (32'hd014  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DATA_CUBE_IN_CHANNEL_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_data_cube_in_channel_0_out, nvdla_pdp_d_data_cube_in_channel_0_out);
      (32'hd010  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DATA_CUBE_IN_HEIGHT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_data_cube_in_height_0_out, nvdla_pdp_d_data_cube_in_height_0_out);
      (32'hd00c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DATA_CUBE_IN_WIDTH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_data_cube_in_width_0_out, nvdla_pdp_d_data_cube_in_width_0_out);
      (32'hd020  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DATA_CUBE_OUT_CHANNEL_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_data_cube_out_channel_0_out, nvdla_pdp_d_data_cube_out_channel_0_out);
      (32'hd01c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DATA_CUBE_OUT_HEIGHT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_data_cube_out_height_0_out, nvdla_pdp_d_data_cube_out_height_0_out);
      (32'hd018  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DATA_CUBE_OUT_WIDTH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_data_cube_out_width_0_out, nvdla_pdp_d_data_cube_out_width_0_out);
      (32'hd084  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DATA_FORMAT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_data_format_0_out, nvdla_pdp_d_data_format_0_out);
      (32'hd074  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DST_BASE_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_dst_base_addr_high_0_out, nvdla_pdp_d_dst_base_addr_high_0_out);
      (32'hd070  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DST_BASE_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_dst_base_addr_low_0_out, nvdla_pdp_d_dst_base_addr_low_0_out);
      (32'hd078  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DST_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_dst_line_stride_0_out, nvdla_pdp_d_dst_line_stride_0_out);
      (32'hd080  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DST_RAM_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_dst_ram_cfg_0_out, nvdla_pdp_d_dst_ram_cfg_0_out);
      (32'hd07c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_DST_SURFACE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_dst_surface_stride_0_out, nvdla_pdp_d_dst_surface_stride_0_out);
      (32'hd088  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_PDP_D_INF_INPUT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hd028  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_NAN_FLUSH_TO_ZERO_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_nan_flush_to_zero_0_out, nvdla_pdp_d_nan_flush_to_zero_0_out);
      (32'hd08c  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_PDP_D_NAN_INPUT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hd090  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_PDP_D_NAN_OUTPUT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hd024  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_OPERATION_MODE_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_operation_mode_cfg_0_out, nvdla_pdp_d_operation_mode_cfg_0_out);
      (32'hd008  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_OP_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_op_enable_0_out, nvdla_pdp_d_op_enable_0_out);
      (32'hd02c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_PARTIAL_WIDTH_IN_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_partial_width_in_0_out, nvdla_pdp_d_partial_width_in_0_out);
      (32'hd030  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_PARTIAL_WIDTH_OUT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_partial_width_out_0_out, nvdla_pdp_d_partial_width_out_0_out);
      (32'hd094  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_PERF_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_perf_enable_0_out, nvdla_pdp_d_perf_enable_0_out);
      (32'hd098  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_PDP_D_PERF_WRITE_STALL_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hd034  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_POOLING_KERNEL_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_pooling_kernel_cfg_0_out, nvdla_pdp_d_pooling_kernel_cfg_0_out);
      (32'hd040  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_POOLING_PADDING_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_pooling_padding_cfg_0_out, nvdla_pdp_d_pooling_padding_cfg_0_out);
      (32'hd044  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_POOLING_PADDING_VALUE_1_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_pooling_padding_value_1_cfg_0_out, nvdla_pdp_d_pooling_padding_value_1_cfg_0_out);
      (32'hd048  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_POOLING_PADDING_VALUE_2_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_pooling_padding_value_2_cfg_0_out, nvdla_pdp_d_pooling_padding_value_2_cfg_0_out);
      (32'hd04c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_POOLING_PADDING_VALUE_3_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_pooling_padding_value_3_cfg_0_out, nvdla_pdp_d_pooling_padding_value_3_cfg_0_out);
      (32'hd050  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_POOLING_PADDING_VALUE_4_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_pooling_padding_value_4_cfg_0_out, nvdla_pdp_d_pooling_padding_value_4_cfg_0_out);
      (32'hd054  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_POOLING_PADDING_VALUE_5_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_pooling_padding_value_5_cfg_0_out, nvdla_pdp_d_pooling_padding_value_5_cfg_0_out);
      (32'hd058  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_POOLING_PADDING_VALUE_6_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_pooling_padding_value_6_cfg_0_out, nvdla_pdp_d_pooling_padding_value_6_cfg_0_out);
      (32'hd05c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_POOLING_PADDING_VALUE_7_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_pooling_padding_value_7_cfg_0_out, nvdla_pdp_d_pooling_padding_value_7_cfg_0_out);
      (32'hd03c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_RECIP_KERNEL_HEIGHT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_recip_kernel_height_0_out, nvdla_pdp_d_recip_kernel_height_0_out);
      (32'hd038  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_RECIP_KERNEL_WIDTH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_recip_kernel_width_0_out, nvdla_pdp_d_recip_kernel_width_0_out);
      (32'hd064  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_SRC_BASE_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_src_base_addr_high_0_out, nvdla_pdp_d_src_base_addr_high_0_out);
      (32'hd060  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_SRC_BASE_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_src_base_addr_low_0_out, nvdla_pdp_d_src_base_addr_low_0_out);
      (32'hd068  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_SRC_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_src_line_stride_0_out, nvdla_pdp_d_src_line_stride_0_out);
      (32'hd06c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_PDP_D_SRC_SURFACE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_pdp_d_src_surface_stride_0_out, nvdla_pdp_d_src_surface_stride_0_out);
      default: begin
          if (arreggen_dump) $display("%t:%m: reg wr: Unknown register (0x%h) = 0x%h", $time, reg_offset, reg_wr_data);
          if (arreggen_abort_on_invalid_wr) begin $display("ERROR: write to undefined register!"); $finish; end
        end
    endcase
  end
end

// VCS coverage on
// synopsys translate_on

endmodule // NV_NVDLA_PDP_REG_dual

