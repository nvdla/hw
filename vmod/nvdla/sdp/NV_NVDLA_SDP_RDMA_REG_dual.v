// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_RDMA_REG_dual.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_RDMA_REG_dual (
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
  ,bn_base_addr_high
  ,bn_base_addr_low
  ,bn_batch_stride
  ,bn_line_stride
  ,bn_surface_stride
  ,brdma_data_mode
  ,brdma_data_size
  ,brdma_data_use
  ,brdma_disable
  ,brdma_ram_type
  ,bs_base_addr_high
  ,bs_base_addr_low
  ,bs_batch_stride
  ,bs_line_stride
  ,bs_surface_stride
  ,channel
  ,height
  ,width
  ,erdma_data_mode
  ,erdma_data_size
  ,erdma_data_use
  ,erdma_disable
  ,erdma_ram_type
  ,ew_base_addr_high
  ,ew_base_addr_low
  ,ew_batch_stride
  ,ew_line_stride
  ,ew_surface_stride
  ,batch_number
  ,flying_mode
  ,in_precision
  ,out_precision
  ,proc_precision
  ,winograd
  ,nrdma_data_mode
  ,nrdma_data_size
  ,nrdma_data_use
  ,nrdma_disable
  ,nrdma_ram_type
  ,op_en_trigger
  ,perf_dma_en
  ,perf_nan_inf_count_en
  ,src_base_addr_high
  ,src_base_addr_low
  ,src_ram_type
  ,src_line_stride
  ,src_surface_stride
  ,op_en
  ,brdma_stall
  ,erdma_stall
  ,mrdma_stall
  ,nrdma_stall
  ,status_inf_input_num
  ,status_nan_input_num
  );

wire   [31:0] nvdla_sdp_rdma_d_bn_base_addr_high_0_out;
wire   [31:0] nvdla_sdp_rdma_d_bn_base_addr_low_0_out;
wire   [31:0] nvdla_sdp_rdma_d_bn_batch_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_bn_line_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_bn_surface_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_brdma_cfg_0_out;
wire   [31:0] nvdla_sdp_rdma_d_bs_base_addr_high_0_out;
wire   [31:0] nvdla_sdp_rdma_d_bs_base_addr_low_0_out;
wire   [31:0] nvdla_sdp_rdma_d_bs_batch_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_bs_line_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_bs_surface_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_data_cube_channel_0_out;
wire   [31:0] nvdla_sdp_rdma_d_data_cube_height_0_out;
wire   [31:0] nvdla_sdp_rdma_d_data_cube_width_0_out;
wire   [31:0] nvdla_sdp_rdma_d_erdma_cfg_0_out;
wire   [31:0] nvdla_sdp_rdma_d_ew_base_addr_high_0_out;
wire   [31:0] nvdla_sdp_rdma_d_ew_base_addr_low_0_out;
wire   [31:0] nvdla_sdp_rdma_d_ew_batch_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_ew_line_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_ew_surface_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_feature_mode_cfg_0_out;
wire   [31:0] nvdla_sdp_rdma_d_nrdma_cfg_0_out;
wire   [31:0] nvdla_sdp_rdma_d_op_enable_0_out;
wire   [31:0] nvdla_sdp_rdma_d_perf_brdma_read_stall_0_out;
wire   [31:0] nvdla_sdp_rdma_d_perf_enable_0_out;
wire   [31:0] nvdla_sdp_rdma_d_perf_erdma_read_stall_0_out;
wire   [31:0] nvdla_sdp_rdma_d_perf_mrdma_read_stall_0_out;
wire   [31:0] nvdla_sdp_rdma_d_perf_nrdma_read_stall_0_out;
wire   [31:0] nvdla_sdp_rdma_d_src_base_addr_high_0_out;
wire   [31:0] nvdla_sdp_rdma_d_src_base_addr_low_0_out;
wire   [31:0] nvdla_sdp_rdma_d_src_dma_cfg_0_out;
wire   [31:0] nvdla_sdp_rdma_d_src_line_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_src_surface_stride_0_out;
wire   [31:0] nvdla_sdp_rdma_d_status_inf_input_num_0_out;
wire   [31:0] nvdla_sdp_rdma_d_status_nan_input_num_0_out;
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
output [31:0] bn_base_addr_high;
output [31:0] bn_base_addr_low;
output [31:0] bn_batch_stride;
output [31:0] bn_line_stride;
output [31:0] bn_surface_stride;
output        brdma_data_mode;
output        brdma_data_size;
output [1:0]  brdma_data_use;
output        brdma_disable;
output        brdma_ram_type;
output [31:0] bs_base_addr_high;
output [31:0] bs_base_addr_low;
output [31:0] bs_batch_stride;
output [31:0] bs_line_stride;
output [31:0] bs_surface_stride;
output [12:0] channel;
output [12:0] height;
output [12:0] width;
output        erdma_data_mode;
output        erdma_data_size;
output [1:0]  erdma_data_use;
output        erdma_disable;
output        erdma_ram_type;
output [31:0] ew_base_addr_high;
output [31:0] ew_base_addr_low;
output [31:0] ew_batch_stride;
output [31:0] ew_line_stride;
output [31:0] ew_surface_stride;
output [4:0]  batch_number;
output        flying_mode;
output [1:0]  in_precision;
output [1:0]  out_precision;
output [1:0]  proc_precision;
output        winograd;
output        nrdma_data_mode;
output        nrdma_data_size;
output [1:0]  nrdma_data_use;
output        nrdma_disable;
output        nrdma_ram_type;
output        op_en_trigger;
output        perf_dma_en;
output        perf_nan_inf_count_en;
output [31:0] src_base_addr_high;
output [31:0] src_base_addr_low;
output        src_ram_type;
output [31:0] src_line_stride;
output [31:0] src_surface_stride;

// Read-only register inputs
input         op_en;
input [31:0]  brdma_stall;
input [31:0]  erdma_stall;
input [31:0]  mrdma_stall;
input [31:0]  nrdma_stall;
input [31:0]  status_inf_input_num;
input [31:0]  status_nan_input_num;

// wr_mask register inputs

// rstn register inputs

// leda FM_2_23 off
reg           arreggen_abort_on_invalid_wr;
reg           arreggen_abort_on_rowr;
reg           arreggen_dump;
// leda FM_2_23 on
reg     [4:0] batch_number;
reg    [31:0] bn_base_addr_high;
reg    [31:0] bn_base_addr_low;
reg    [31:0] bn_batch_stride;
reg    [31:0] bn_line_stride;
reg    [31:0] bn_surface_stride;
reg           brdma_data_mode;
reg           brdma_data_size;
reg     [1:0] brdma_data_use;
reg           brdma_disable;
reg           brdma_ram_type;
reg    [31:0] bs_base_addr_high;
reg    [31:0] bs_base_addr_low;
reg    [31:0] bs_batch_stride;
reg    [31:0] bs_line_stride;
reg    [31:0] bs_surface_stride;
reg    [12:0] channel;
reg           erdma_data_mode;
reg           erdma_data_size;
reg     [1:0] erdma_data_use;
reg           erdma_disable;
reg           erdma_ram_type;
reg    [31:0] ew_base_addr_high;
reg    [31:0] ew_base_addr_low;
reg    [31:0] ew_batch_stride;
reg    [31:0] ew_line_stride;
reg    [31:0] ew_surface_stride;
reg           flying_mode;
reg    [12:0] height;
reg     [1:0] in_precision;
reg           nrdma_data_mode;
reg           nrdma_data_size;
reg     [1:0] nrdma_data_use;
reg           nrdma_disable;
reg           nrdma_ram_type;
reg     [1:0] out_precision;
reg           perf_dma_en;
reg           perf_nan_inf_count_en;
reg     [1:0] proc_precision;
reg    [31:0] reg_rd_data;
reg    [31:0] src_base_addr_high;
reg    [31:0] src_base_addr_low;
reg    [31:0] src_line_stride;
reg           src_ram_type;
reg    [31:0] src_surface_stride;
reg    [12:0] width;
reg           winograd;

assign reg_offset_wr = {20'b0 , reg_offset};
// SCR signals

// Address decode
wire nvdla_sdp_rdma_d_bn_base_addr_high_0_wren = (reg_offset_wr == (32'ha048  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_bn_base_addr_low_0_wren = (reg_offset_wr == (32'ha044  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_bn_batch_stride_0_wren = (reg_offset_wr == (32'ha054  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_bn_line_stride_0_wren = (reg_offset_wr == (32'ha04c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_bn_surface_stride_0_wren = (reg_offset_wr == (32'ha050  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_brdma_cfg_0_wren = (reg_offset_wr == (32'ha028  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_bs_base_addr_high_0_wren = (reg_offset_wr == (32'ha030  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_bs_base_addr_low_0_wren = (reg_offset_wr == (32'ha02c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_bs_batch_stride_0_wren = (reg_offset_wr == (32'ha03c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_bs_line_stride_0_wren = (reg_offset_wr == (32'ha034  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_bs_surface_stride_0_wren = (reg_offset_wr == (32'ha038  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_data_cube_channel_0_wren = (reg_offset_wr == (32'ha014  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_data_cube_height_0_wren = (reg_offset_wr == (32'ha010  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_data_cube_width_0_wren = (reg_offset_wr == (32'ha00c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_erdma_cfg_0_wren = (reg_offset_wr == (32'ha058  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_ew_base_addr_high_0_wren = (reg_offset_wr == (32'ha060  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_ew_base_addr_low_0_wren = (reg_offset_wr == (32'ha05c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_ew_batch_stride_0_wren = (reg_offset_wr == (32'ha06c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_ew_line_stride_0_wren = (reg_offset_wr == (32'ha064  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_ew_surface_stride_0_wren = (reg_offset_wr == (32'ha068  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_feature_mode_cfg_0_wren = (reg_offset_wr == (32'ha070  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_nrdma_cfg_0_wren = (reg_offset_wr == (32'ha040  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_op_enable_0_wren = (reg_offset_wr == (32'ha008  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_perf_brdma_read_stall_0_wren = (reg_offset_wr == (32'ha088  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_perf_enable_0_wren = (reg_offset_wr == (32'ha080  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_perf_erdma_read_stall_0_wren = (reg_offset_wr == (32'ha090  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_perf_mrdma_read_stall_0_wren = (reg_offset_wr == (32'ha084  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_perf_nrdma_read_stall_0_wren = (reg_offset_wr == (32'ha08c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_src_base_addr_high_0_wren = (reg_offset_wr == (32'ha01c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_src_base_addr_low_0_wren = (reg_offset_wr == (32'ha018  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_src_dma_cfg_0_wren = (reg_offset_wr == (32'ha074  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_src_line_stride_0_wren = (reg_offset_wr == (32'ha020  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_src_surface_stride_0_wren = (reg_offset_wr == (32'ha024  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_status_inf_input_num_0_wren = (reg_offset_wr == (32'ha07c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_sdp_rdma_d_status_nan_input_num_0_wren = (reg_offset_wr == (32'ha078  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)

assign nvdla_sdp_rdma_d_bn_base_addr_high_0_out[31:0] = { bn_base_addr_high };
assign nvdla_sdp_rdma_d_bn_base_addr_low_0_out[31:0] = { bn_base_addr_low};
assign nvdla_sdp_rdma_d_bn_batch_stride_0_out[31:0] = { bn_batch_stride};
assign nvdla_sdp_rdma_d_bn_line_stride_0_out[31:0] = { bn_line_stride};
assign nvdla_sdp_rdma_d_bn_surface_stride_0_out[31:0] = { bn_surface_stride};
assign nvdla_sdp_rdma_d_brdma_cfg_0_out[31:0] = { 26'b0, brdma_ram_type, brdma_data_mode, brdma_data_size, brdma_data_use, brdma_disable };
assign nvdla_sdp_rdma_d_bs_base_addr_high_0_out[31:0] = { bs_base_addr_high };
assign nvdla_sdp_rdma_d_bs_base_addr_low_0_out[31:0] = { bs_base_addr_low};
assign nvdla_sdp_rdma_d_bs_batch_stride_0_out[31:0] = { bs_batch_stride};
assign nvdla_sdp_rdma_d_bs_line_stride_0_out[31:0] = { bs_line_stride};
assign nvdla_sdp_rdma_d_bs_surface_stride_0_out[31:0] = { bs_surface_stride};
assign nvdla_sdp_rdma_d_data_cube_channel_0_out[31:0] = { 19'b0, channel };
assign nvdla_sdp_rdma_d_data_cube_height_0_out[31:0] = { 19'b0, height };
assign nvdla_sdp_rdma_d_data_cube_width_0_out[31:0] = { 19'b0, width };
assign nvdla_sdp_rdma_d_erdma_cfg_0_out[31:0] = { 26'b0, erdma_ram_type, erdma_data_mode, erdma_data_size, erdma_data_use, erdma_disable };
assign nvdla_sdp_rdma_d_ew_base_addr_high_0_out[31:0] = { ew_base_addr_high };
assign nvdla_sdp_rdma_d_ew_base_addr_low_0_out[31:0] = { ew_base_addr_low};
assign nvdla_sdp_rdma_d_ew_batch_stride_0_out[31:0] = { ew_batch_stride};
assign nvdla_sdp_rdma_d_ew_line_stride_0_out[31:0] = { ew_line_stride};
assign nvdla_sdp_rdma_d_ew_surface_stride_0_out[31:0] = { ew_surface_stride};
assign nvdla_sdp_rdma_d_feature_mode_cfg_0_out[31:0] = { 19'b0, batch_number, out_precision, proc_precision, in_precision, winograd, flying_mode };
assign nvdla_sdp_rdma_d_nrdma_cfg_0_out[31:0] = { 26'b0, nrdma_ram_type, nrdma_data_mode, nrdma_data_size, nrdma_data_use, nrdma_disable };
assign nvdla_sdp_rdma_d_op_enable_0_out[31:0] = { 31'b0, op_en };
assign nvdla_sdp_rdma_d_perf_brdma_read_stall_0_out[31:0] = { brdma_stall };
assign nvdla_sdp_rdma_d_perf_enable_0_out[31:0] = { 30'b0, perf_nan_inf_count_en, perf_dma_en };
assign nvdla_sdp_rdma_d_perf_erdma_read_stall_0_out[31:0] = { erdma_stall };
assign nvdla_sdp_rdma_d_perf_mrdma_read_stall_0_out[31:0] = { mrdma_stall };
assign nvdla_sdp_rdma_d_perf_nrdma_read_stall_0_out[31:0] = { nrdma_stall };
assign nvdla_sdp_rdma_d_src_base_addr_high_0_out[31:0] = { src_base_addr_high };
assign nvdla_sdp_rdma_d_src_base_addr_low_0_out[31:0] = { src_base_addr_low};
assign nvdla_sdp_rdma_d_src_dma_cfg_0_out[31:0] = { 31'b0, src_ram_type };
assign nvdla_sdp_rdma_d_src_line_stride_0_out[31:0] = { src_line_stride};
assign nvdla_sdp_rdma_d_src_surface_stride_0_out[31:0] = { src_surface_stride};
assign nvdla_sdp_rdma_d_status_inf_input_num_0_out[31:0] = { status_inf_input_num };
assign nvdla_sdp_rdma_d_status_nan_input_num_0_out[31:0] = { status_nan_input_num };

assign op_en_trigger = nvdla_sdp_rdma_d_op_enable_0_wren;  //(W563)

assign reg_offset_rd_int = reg_offset;
// Output mux
//spyglass disable_block W338, W263 
always @(
  reg_offset_rd_int
  or nvdla_sdp_rdma_d_bn_base_addr_high_0_out
  or nvdla_sdp_rdma_d_bn_base_addr_low_0_out
  or nvdla_sdp_rdma_d_bn_batch_stride_0_out
  or nvdla_sdp_rdma_d_bn_line_stride_0_out
  or nvdla_sdp_rdma_d_bn_surface_stride_0_out
  or nvdla_sdp_rdma_d_brdma_cfg_0_out
  or nvdla_sdp_rdma_d_bs_base_addr_high_0_out
  or nvdla_sdp_rdma_d_bs_base_addr_low_0_out
  or nvdla_sdp_rdma_d_bs_batch_stride_0_out
  or nvdla_sdp_rdma_d_bs_line_stride_0_out
  or nvdla_sdp_rdma_d_bs_surface_stride_0_out
  or nvdla_sdp_rdma_d_data_cube_channel_0_out
  or nvdla_sdp_rdma_d_data_cube_height_0_out
  or nvdla_sdp_rdma_d_data_cube_width_0_out
  or nvdla_sdp_rdma_d_erdma_cfg_0_out
  or nvdla_sdp_rdma_d_ew_base_addr_high_0_out
  or nvdla_sdp_rdma_d_ew_base_addr_low_0_out
  or nvdla_sdp_rdma_d_ew_batch_stride_0_out
  or nvdla_sdp_rdma_d_ew_line_stride_0_out
  or nvdla_sdp_rdma_d_ew_surface_stride_0_out
  or nvdla_sdp_rdma_d_feature_mode_cfg_0_out
  or nvdla_sdp_rdma_d_nrdma_cfg_0_out
  or nvdla_sdp_rdma_d_op_enable_0_out
  or nvdla_sdp_rdma_d_perf_brdma_read_stall_0_out
  or nvdla_sdp_rdma_d_perf_enable_0_out
  or nvdla_sdp_rdma_d_perf_erdma_read_stall_0_out
  or nvdla_sdp_rdma_d_perf_mrdma_read_stall_0_out
  or nvdla_sdp_rdma_d_perf_nrdma_read_stall_0_out
  or nvdla_sdp_rdma_d_src_base_addr_high_0_out
  or nvdla_sdp_rdma_d_src_base_addr_low_0_out
  or nvdla_sdp_rdma_d_src_dma_cfg_0_out
  or nvdla_sdp_rdma_d_src_line_stride_0_out
  or nvdla_sdp_rdma_d_src_surface_stride_0_out
  or nvdla_sdp_rdma_d_status_inf_input_num_0_out
  or nvdla_sdp_rdma_d_status_nan_input_num_0_out
  ) begin
  case (reg_offset_rd_int)
     (32'ha048  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_bn_base_addr_high_0_out ;
                            end 
     (32'ha044  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_bn_base_addr_low_0_out ;
                            end 
     (32'ha054  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_bn_batch_stride_0_out ;
                            end 
     (32'ha04c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_bn_line_stride_0_out ;
                            end 
     (32'ha050  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_bn_surface_stride_0_out ;
                            end 
     (32'ha028  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_brdma_cfg_0_out ;
                            end 
     (32'ha030  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_bs_base_addr_high_0_out ;
                            end 
     (32'ha02c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_bs_base_addr_low_0_out ;
                            end 
     (32'ha03c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_bs_batch_stride_0_out ;
                            end 
     (32'ha034  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_bs_line_stride_0_out ;
                            end 
     (32'ha038  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_bs_surface_stride_0_out ;
                            end 
     (32'ha014  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_data_cube_channel_0_out ;
                            end 
     (32'ha010  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_data_cube_height_0_out ;
                            end 
     (32'ha00c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_data_cube_width_0_out ;
                            end 
     (32'ha058  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_erdma_cfg_0_out ;
                            end 
     (32'ha060  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_ew_base_addr_high_0_out ;
                            end 
     (32'ha05c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_ew_base_addr_low_0_out ;
                            end 
     (32'ha06c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_ew_batch_stride_0_out ;
                            end 
     (32'ha064  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_ew_line_stride_0_out ;
                            end 
     (32'ha068  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_ew_surface_stride_0_out ;
                            end 
     (32'ha070  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_feature_mode_cfg_0_out ;
                            end 
     (32'ha040  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_nrdma_cfg_0_out ;
                            end 
     (32'ha008  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_op_enable_0_out ;
                            end 
     (32'ha088  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_perf_brdma_read_stall_0_out ;
                            end 
     (32'ha080  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_perf_enable_0_out ;
                            end 
     (32'ha090  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_perf_erdma_read_stall_0_out ;
                            end 
     (32'ha084  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_perf_mrdma_read_stall_0_out ;
                            end 
     (32'ha08c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_perf_nrdma_read_stall_0_out ;
                            end 
     (32'ha01c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_src_base_addr_high_0_out ;
                            end 
     (32'ha018  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_src_base_addr_low_0_out ;
                            end 
     (32'ha074  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_src_dma_cfg_0_out ;
                            end 
     (32'ha020  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_src_line_stride_0_out ;
                            end 
     (32'ha024  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_src_surface_stride_0_out ;
                            end 
     (32'ha07c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_status_inf_input_num_0_out ;
                            end 
     (32'ha078  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_sdp_rdma_d_status_nan_input_num_0_out ;
                            end 
    default: reg_rd_data = {32{1'b0}};
  endcase
end

//spyglass enable_block W338, W263

// spyglass disable_block STARC-2.10.1.6, NoConstWithXZ, W443

// Register flop declarations
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bn_base_addr_high[31:0] <= 32'h0;
    bn_base_addr_low[31:0] <= {(32){1'b0}};
    bn_batch_stride[31:0] <= {(32){1'b0}};
    bn_line_stride[31:0] <= {(32){1'b0}};
    bn_surface_stride[31:0] <= {(32){1'b0}};
    brdma_data_mode <= 1'b0;
    brdma_data_size <= 1'b0;
    brdma_data_use[1:0] <= 2'b00;
    brdma_disable <= 1'b1;
    brdma_ram_type <= 1'b0;
    bs_base_addr_high[31:0] <= 32'h0;
    bs_base_addr_low[31:0] <= {(32){1'b0}};
    bs_batch_stride[31:0] <= {(32){1'b0}};
    bs_line_stride[31:0] <= {(32){1'b0}};
    bs_surface_stride[31:0] <= {(32){1'b0}};
    channel[12:0] <= 13'b0000000000000;
    height[12:0] <= 13'b0000000000000;
    width[12:0] <= 13'b0000000000000;
    erdma_data_mode <= 1'b0;
    erdma_data_size <= 1'b0;
    erdma_data_use[1:0] <= 2'b00;
    erdma_disable <= 1'b1;
    erdma_ram_type <= 1'b0;
    ew_base_addr_high[31:0] <= 32'h0;
    ew_base_addr_low[31:0] <= {(32){1'b0}};
    ew_batch_stride[31:0] <= {(32){1'b0}};
    ew_line_stride[31:0] <= {(32){1'b0}};
    ew_surface_stride[31:0] <= {(32){1'b0}};
    batch_number[4:0] <= 5'b00000;
    flying_mode <= 1'b0;
    in_precision[1:0] <= 2'b01;
    out_precision[1:0] <= 2'b00;
    proc_precision[1:0] <= 2'b01;
    winograd <= 1'b0;
    nrdma_data_mode <= 1'b0;
    nrdma_data_size <= 1'b0;
    nrdma_data_use[1:0] <= 2'b00;
    nrdma_disable <= 1'b1;
    nrdma_ram_type <= 1'b0;
    perf_dma_en <= 1'b0;
    perf_nan_inf_count_en <= 1'b0;
    src_base_addr_high[31:0] <= 32'h0;
    src_base_addr_low[31:0] <= {(32){1'b0}};
    src_ram_type <= 1'b0;
    src_line_stride[31:0] <= {(32){1'b0}};
    src_surface_stride[31:0] <= {(32){1'b0}};
  end else begin
  // Register: NVDLA_SDP_RDMA_D_BN_BASE_ADDR_HIGH_0    Field: bn_base_addr_high
  if (nvdla_sdp_rdma_d_bn_base_addr_high_0_wren) begin
    bn_base_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_BN_BASE_ADDR_LOW_0    Field: bn_base_addr_low
  if (nvdla_sdp_rdma_d_bn_base_addr_low_0_wren) begin
    bn_base_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_BN_BATCH_STRIDE_0    Field: bn_batch_stride
  if (nvdla_sdp_rdma_d_bn_batch_stride_0_wren) begin
    bn_batch_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_BN_LINE_STRIDE_0    Field: bn_line_stride
  if (nvdla_sdp_rdma_d_bn_line_stride_0_wren) begin
    bn_line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_BN_SURFACE_STRIDE_0    Field: bn_surface_stride
  if (nvdla_sdp_rdma_d_bn_surface_stride_0_wren) begin
    bn_surface_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_BRDMA_CFG_0    Field: brdma_data_mode
  if (nvdla_sdp_rdma_d_brdma_cfg_0_wren) begin
    brdma_data_mode <= reg_wr_data[4];
  end

  // Register: NVDLA_SDP_RDMA_D_BRDMA_CFG_0    Field: brdma_data_size
  if (nvdla_sdp_rdma_d_brdma_cfg_0_wren) begin
    brdma_data_size <= reg_wr_data[3];
  end

  // Register: NVDLA_SDP_RDMA_D_BRDMA_CFG_0    Field: brdma_data_use
  if (nvdla_sdp_rdma_d_brdma_cfg_0_wren) begin
    brdma_data_use[1:0] <= reg_wr_data[2:1];
  end

  // Register: NVDLA_SDP_RDMA_D_BRDMA_CFG_0    Field: brdma_disable
  if (nvdla_sdp_rdma_d_brdma_cfg_0_wren) begin
    brdma_disable <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_RDMA_D_BRDMA_CFG_0    Field: brdma_ram_type
  if (nvdla_sdp_rdma_d_brdma_cfg_0_wren) begin
    brdma_ram_type <= reg_wr_data[5];
  end

  // Register: NVDLA_SDP_RDMA_D_BS_BASE_ADDR_HIGH_0    Field: bs_base_addr_high
  if (nvdla_sdp_rdma_d_bs_base_addr_high_0_wren) begin
    bs_base_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_BS_BASE_ADDR_LOW_0    Field: bs_base_addr_low
  if (nvdla_sdp_rdma_d_bs_base_addr_low_0_wren) begin
    bs_base_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_BS_BATCH_STRIDE_0    Field: bs_batch_stride
  if (nvdla_sdp_rdma_d_bs_batch_stride_0_wren) begin
    bs_batch_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_BS_LINE_STRIDE_0    Field: bs_line_stride
  if (nvdla_sdp_rdma_d_bs_line_stride_0_wren) begin
    bs_line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_BS_SURFACE_STRIDE_0    Field: bs_surface_stride
  if (nvdla_sdp_rdma_d_bs_surface_stride_0_wren) begin
    bs_surface_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_DATA_CUBE_CHANNEL_0    Field: channel
  if (nvdla_sdp_rdma_d_data_cube_channel_0_wren) begin
    channel[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_SDP_RDMA_D_DATA_CUBE_HEIGHT_0    Field: height
  if (nvdla_sdp_rdma_d_data_cube_height_0_wren) begin
    height[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_SDP_RDMA_D_DATA_CUBE_WIDTH_0    Field: width
  if (nvdla_sdp_rdma_d_data_cube_width_0_wren) begin
    width[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_SDP_RDMA_D_ERDMA_CFG_0    Field: erdma_data_mode
  if (nvdla_sdp_rdma_d_erdma_cfg_0_wren) begin
    erdma_data_mode <= reg_wr_data[4];
  end

  // Register: NVDLA_SDP_RDMA_D_ERDMA_CFG_0    Field: erdma_data_size
  if (nvdla_sdp_rdma_d_erdma_cfg_0_wren) begin
    erdma_data_size <= reg_wr_data[3];
  end

  // Register: NVDLA_SDP_RDMA_D_ERDMA_CFG_0    Field: erdma_data_use
  if (nvdla_sdp_rdma_d_erdma_cfg_0_wren) begin
    erdma_data_use[1:0] <= reg_wr_data[2:1];
  end

  // Register: NVDLA_SDP_RDMA_D_ERDMA_CFG_0    Field: erdma_disable
  if (nvdla_sdp_rdma_d_erdma_cfg_0_wren) begin
    erdma_disable <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_RDMA_D_ERDMA_CFG_0    Field: erdma_ram_type
  if (nvdla_sdp_rdma_d_erdma_cfg_0_wren) begin
    erdma_ram_type <= reg_wr_data[5];
  end

  // Register: NVDLA_SDP_RDMA_D_EW_BASE_ADDR_HIGH_0    Field: ew_base_addr_high
  if (nvdla_sdp_rdma_d_ew_base_addr_high_0_wren) begin
    ew_base_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_EW_BASE_ADDR_LOW_0    Field: ew_base_addr_low
  if (nvdla_sdp_rdma_d_ew_base_addr_low_0_wren) begin
    ew_base_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_EW_BATCH_STRIDE_0    Field: ew_batch_stride
  if (nvdla_sdp_rdma_d_ew_batch_stride_0_wren) begin
    ew_batch_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_EW_LINE_STRIDE_0    Field: ew_line_stride
  if (nvdla_sdp_rdma_d_ew_line_stride_0_wren) begin
    ew_line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_EW_SURFACE_STRIDE_0    Field: ew_surface_stride
  if (nvdla_sdp_rdma_d_ew_surface_stride_0_wren) begin
    ew_surface_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0    Field: batch_number
  if (nvdla_sdp_rdma_d_feature_mode_cfg_0_wren) begin
    batch_number[4:0] <= reg_wr_data[12:8];
  end

  // Register: NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0    Field: flying_mode
  if (nvdla_sdp_rdma_d_feature_mode_cfg_0_wren) begin
    flying_mode <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0    Field: in_precision
  if (nvdla_sdp_rdma_d_feature_mode_cfg_0_wren) begin
    in_precision[1:0] <= reg_wr_data[3:2];
  end

  // Register: NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0    Field: out_precision
  if (nvdla_sdp_rdma_d_feature_mode_cfg_0_wren) begin
    out_precision[1:0] <= reg_wr_data[7:6];
  end

  // Register: NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0    Field: proc_precision
  if (nvdla_sdp_rdma_d_feature_mode_cfg_0_wren) begin
    proc_precision[1:0] <= reg_wr_data[5:4];
  end

  // Register: NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0    Field: winograd
  if (nvdla_sdp_rdma_d_feature_mode_cfg_0_wren) begin
    winograd <= reg_wr_data[1];
  end

  // Register: NVDLA_SDP_RDMA_D_NRDMA_CFG_0    Field: nrdma_data_mode
  if (nvdla_sdp_rdma_d_nrdma_cfg_0_wren) begin
    nrdma_data_mode <= reg_wr_data[4];
  end

  // Register: NVDLA_SDP_RDMA_D_NRDMA_CFG_0    Field: nrdma_data_size
  if (nvdla_sdp_rdma_d_nrdma_cfg_0_wren) begin
    nrdma_data_size <= reg_wr_data[3];
  end

  // Register: NVDLA_SDP_RDMA_D_NRDMA_CFG_0    Field: nrdma_data_use
  if (nvdla_sdp_rdma_d_nrdma_cfg_0_wren) begin
    nrdma_data_use[1:0] <= reg_wr_data[2:1];
  end

  // Register: NVDLA_SDP_RDMA_D_NRDMA_CFG_0    Field: nrdma_disable
  if (nvdla_sdp_rdma_d_nrdma_cfg_0_wren) begin
    nrdma_disable <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_RDMA_D_NRDMA_CFG_0    Field: nrdma_ram_type
  if (nvdla_sdp_rdma_d_nrdma_cfg_0_wren) begin
    nrdma_ram_type <= reg_wr_data[5];
  end

  // Not generating flops for field NVDLA_SDP_RDMA_D_OP_ENABLE_0::op_en (to be implemented outside)

  // Not generating flops for read-only field NVDLA_SDP_RDMA_D_PERF_BRDMA_READ_STALL_0::brdma_stall

  // Register: NVDLA_SDP_RDMA_D_PERF_ENABLE_0    Field: perf_dma_en
  if (nvdla_sdp_rdma_d_perf_enable_0_wren) begin
    perf_dma_en <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_RDMA_D_PERF_ENABLE_0    Field: perf_nan_inf_count_en
  if (nvdla_sdp_rdma_d_perf_enable_0_wren) begin
    perf_nan_inf_count_en <= reg_wr_data[1];
  end

  // Not generating flops for read-only field NVDLA_SDP_RDMA_D_PERF_ERDMA_READ_STALL_0::erdma_stall

  // Not generating flops for read-only field NVDLA_SDP_RDMA_D_PERF_MRDMA_READ_STALL_0::mrdma_stall

  // Not generating flops for read-only field NVDLA_SDP_RDMA_D_PERF_NRDMA_READ_STALL_0::nrdma_stall

  // Register: NVDLA_SDP_RDMA_D_SRC_BASE_ADDR_HIGH_0    Field: src_base_addr_high
  if (nvdla_sdp_rdma_d_src_base_addr_high_0_wren) begin
    src_base_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_SRC_BASE_ADDR_LOW_0    Field: src_base_addr_low
  if (nvdla_sdp_rdma_d_src_base_addr_low_0_wren) begin
    src_base_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_SRC_DMA_CFG_0    Field: src_ram_type
  if (nvdla_sdp_rdma_d_src_dma_cfg_0_wren) begin
    src_ram_type <= reg_wr_data[0];
  end

  // Register: NVDLA_SDP_RDMA_D_SRC_LINE_STRIDE_0    Field: src_line_stride
  if (nvdla_sdp_rdma_d_src_line_stride_0_wren) begin
    src_line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_SDP_RDMA_D_SRC_SURFACE_STRIDE_0    Field: src_surface_stride
  if (nvdla_sdp_rdma_d_src_surface_stride_0_wren) begin
    src_surface_stride[31:0] <= reg_wr_data[31:0];
  end

  // Not generating flops for read-only field NVDLA_SDP_RDMA_D_STATUS_INF_INPUT_NUM_0::status_inf_input_num

  // Not generating flops for read-only field NVDLA_SDP_RDMA_D_STATUS_NAN_INPUT_NUM_0::status_nan_input_num

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
      (32'ha048  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BN_BASE_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_bn_base_addr_high_0_out, nvdla_sdp_rdma_d_bn_base_addr_high_0_out);
      (32'ha044  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BN_BASE_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_bn_base_addr_low_0_out, nvdla_sdp_rdma_d_bn_base_addr_low_0_out);
      (32'ha054  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BN_BATCH_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_bn_batch_stride_0_out, nvdla_sdp_rdma_d_bn_batch_stride_0_out);
      (32'ha04c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BN_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_bn_line_stride_0_out, nvdla_sdp_rdma_d_bn_line_stride_0_out);
      (32'ha050  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BN_SURFACE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_bn_surface_stride_0_out, nvdla_sdp_rdma_d_bn_surface_stride_0_out);
      (32'ha028  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BRDMA_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_brdma_cfg_0_out, nvdla_sdp_rdma_d_brdma_cfg_0_out);
      (32'ha030  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BS_BASE_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_bs_base_addr_high_0_out, nvdla_sdp_rdma_d_bs_base_addr_high_0_out);
      (32'ha02c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BS_BASE_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_bs_base_addr_low_0_out, nvdla_sdp_rdma_d_bs_base_addr_low_0_out);
      (32'ha03c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BS_BATCH_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_bs_batch_stride_0_out, nvdla_sdp_rdma_d_bs_batch_stride_0_out);
      (32'ha034  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BS_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_bs_line_stride_0_out, nvdla_sdp_rdma_d_bs_line_stride_0_out);
      (32'ha038  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_BS_SURFACE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_bs_surface_stride_0_out, nvdla_sdp_rdma_d_bs_surface_stride_0_out);
      (32'ha014  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_DATA_CUBE_CHANNEL_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_data_cube_channel_0_out, nvdla_sdp_rdma_d_data_cube_channel_0_out);
      (32'ha010  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_DATA_CUBE_HEIGHT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_data_cube_height_0_out, nvdla_sdp_rdma_d_data_cube_height_0_out);
      (32'ha00c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_DATA_CUBE_WIDTH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_data_cube_width_0_out, nvdla_sdp_rdma_d_data_cube_width_0_out);
      (32'ha058  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_ERDMA_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_erdma_cfg_0_out, nvdla_sdp_rdma_d_erdma_cfg_0_out);
      (32'ha060  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_EW_BASE_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_ew_base_addr_high_0_out, nvdla_sdp_rdma_d_ew_base_addr_high_0_out);
      (32'ha05c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_EW_BASE_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_ew_base_addr_low_0_out, nvdla_sdp_rdma_d_ew_base_addr_low_0_out);
      (32'ha06c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_EW_BATCH_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_ew_batch_stride_0_out, nvdla_sdp_rdma_d_ew_batch_stride_0_out);
      (32'ha064  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_EW_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_ew_line_stride_0_out, nvdla_sdp_rdma_d_ew_line_stride_0_out);
      (32'ha068  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_EW_SURFACE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_ew_surface_stride_0_out, nvdla_sdp_rdma_d_ew_surface_stride_0_out);
      (32'ha070  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_FEATURE_MODE_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_feature_mode_cfg_0_out, nvdla_sdp_rdma_d_feature_mode_cfg_0_out);
      (32'ha040  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_NRDMA_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_nrdma_cfg_0_out, nvdla_sdp_rdma_d_nrdma_cfg_0_out);
      (32'ha008  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_OP_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_op_enable_0_out, nvdla_sdp_rdma_d_op_enable_0_out);
      (32'ha088  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_RDMA_D_PERF_BRDMA_READ_STALL_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'ha080  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_PERF_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_perf_enable_0_out, nvdla_sdp_rdma_d_perf_enable_0_out);
      (32'ha090  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_RDMA_D_PERF_ERDMA_READ_STALL_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'ha084  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_RDMA_D_PERF_MRDMA_READ_STALL_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'ha08c  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_RDMA_D_PERF_NRDMA_READ_STALL_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'ha01c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_SRC_BASE_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_src_base_addr_high_0_out, nvdla_sdp_rdma_d_src_base_addr_high_0_out);
      (32'ha018  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_SRC_BASE_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_src_base_addr_low_0_out, nvdla_sdp_rdma_d_src_base_addr_low_0_out);
      (32'ha074  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_SRC_DMA_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_src_dma_cfg_0_out, nvdla_sdp_rdma_d_src_dma_cfg_0_out);
      (32'ha020  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_SRC_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_src_line_stride_0_out, nvdla_sdp_rdma_d_src_line_stride_0_out);
      (32'ha024  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_SDP_RDMA_D_SRC_SURFACE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_sdp_rdma_d_src_surface_stride_0_out, nvdla_sdp_rdma_d_src_surface_stride_0_out);
      (32'ha07c  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_RDMA_D_STATUS_INF_INPUT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'ha078  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_SDP_RDMA_D_STATUS_NAN_INPUT_NUM_0 = 0x%h", $time, reg_wr_data);
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

endmodule // NV_NVDLA_SDP_RDMA_REG_dual

