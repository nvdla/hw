// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_dual_reg.v

module NV_NVDLA_CDMA_dual_reg (
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
  ,data_bank
  ,weight_bank
  ,batches
  ,batch_stride
  ,conv_x_stride
  ,conv_y_stride
  ,cvt_en
  ,cvt_truncate
  ,cvt_offset
  ,cvt_scale
  ,cya
  ,datain_addr_high_0
  ,datain_addr_high_1
  ,datain_addr_low_0
  ,datain_addr_low_1
  ,line_packed
  ,surf_packed
  ,datain_ram_type
  ,datain_format
  ,pixel_format
  ,pixel_mapping
  ,pixel_sign_override
  ,datain_height
  ,datain_width
  ,datain_channel
  ,datain_height_ext
  ,datain_width_ext
  ,entries
  ,grains
  ,line_stride
  ,uv_line_stride
  ,mean_format
  ,mean_gu
  ,mean_ry
  ,mean_ax
  ,mean_bv
  ,conv_mode
  ,data_reuse
  ,in_precision
  ,proc_precision
  ,skip_data_rls
  ,skip_weight_rls
  ,weight_reuse
  ,nan_to_zero
  ,op_en_trigger
  ,dma_en
  ,pixel_x_offset
  ,pixel_y_offset
  ,rsv_per_line
  ,rsv_per_uv_line
  ,rsv_height
  ,rsv_y_index
  ,surf_stride
  ,weight_addr_high
  ,weight_addr_low
  ,weight_bytes
  ,weight_format
  ,weight_ram_type
  ,byte_per_kernel
  ,weight_kernel
  ,wgs_addr_high
  ,wgs_addr_low
  ,wmb_addr_high
  ,wmb_addr_low
  ,wmb_bytes
  ,pad_bottom
  ,pad_left
  ,pad_right
  ,pad_top
  ,pad_value
  ,inf_data_num
  ,inf_weight_num
  ,nan_data_num
  ,nan_weight_num
  ,op_en
  ,dat_rd_latency
  ,dat_rd_stall
  ,wt_rd_latency
  ,wt_rd_stall
  );

wire   [31:0] nvdla_cdma_d_bank_0_out;
wire   [31:0] nvdla_cdma_d_batch_number_0_out;
wire   [31:0] nvdla_cdma_d_batch_stride_0_out;
wire   [31:0] nvdla_cdma_d_conv_stride_0_out;
wire   [31:0] nvdla_cdma_d_cvt_cfg_0_out;
wire   [31:0] nvdla_cdma_d_cvt_offset_0_out;
wire   [31:0] nvdla_cdma_d_cvt_scale_0_out;
wire   [31:0] nvdla_cdma_d_cya_0_out;
wire   [31:0] nvdla_cdma_d_dain_addr_high_0_0_out;
wire   [31:0] nvdla_cdma_d_dain_addr_high_1_0_out;
wire   [31:0] nvdla_cdma_d_dain_addr_low_0_0_out;
wire   [31:0] nvdla_cdma_d_dain_addr_low_1_0_out;
wire   [31:0] nvdla_cdma_d_dain_map_0_out;
wire   [31:0] nvdla_cdma_d_dain_ram_type_0_out;
wire   [31:0] nvdla_cdma_d_datain_format_0_out;
wire   [31:0] nvdla_cdma_d_datain_size_0_0_out;
wire   [31:0] nvdla_cdma_d_datain_size_1_0_out;
wire   [31:0] nvdla_cdma_d_datain_size_ext_0_0_out;
wire   [31:0] nvdla_cdma_d_entry_per_slice_0_out;
wire   [31:0] nvdla_cdma_d_fetch_grain_0_out;
wire   [31:0] nvdla_cdma_d_inf_input_data_num_0_out;
wire   [31:0] nvdla_cdma_d_inf_input_weight_num_0_out;
wire   [31:0] nvdla_cdma_d_line_stride_0_out;
wire   [31:0] nvdla_cdma_d_line_uv_stride_0_out;
wire   [31:0] nvdla_cdma_d_mean_format_0_out;
wire   [31:0] nvdla_cdma_d_mean_global_0_0_out;
wire   [31:0] nvdla_cdma_d_mean_global_1_0_out;
wire   [31:0] nvdla_cdma_d_misc_cfg_0_out;
wire   [31:0] nvdla_cdma_d_nan_flush_to_zero_0_out;
wire   [31:0] nvdla_cdma_d_nan_input_data_num_0_out;
wire   [31:0] nvdla_cdma_d_nan_input_weight_num_0_out;
wire   [31:0] nvdla_cdma_d_op_enable_0_out;
wire   [31:0] nvdla_cdma_d_perf_dat_read_latency_0_out;
wire   [31:0] nvdla_cdma_d_perf_dat_read_stall_0_out;
wire   [31:0] nvdla_cdma_d_perf_enable_0_out;
wire   [31:0] nvdla_cdma_d_perf_wt_read_latency_0_out;
wire   [31:0] nvdla_cdma_d_perf_wt_read_stall_0_out;
wire   [31:0] nvdla_cdma_d_pixel_offset_0_out;
wire   [31:0] nvdla_cdma_d_reserved_x_cfg_0_out;
wire   [31:0] nvdla_cdma_d_reserved_y_cfg_0_out;
wire   [31:0] nvdla_cdma_d_surf_stride_0_out;
wire   [31:0] nvdla_cdma_d_weight_addr_high_0_out;
wire   [31:0] nvdla_cdma_d_weight_addr_low_0_out;
wire   [31:0] nvdla_cdma_d_weight_bytes_0_out;
wire   [31:0] nvdla_cdma_d_weight_format_0_out;
wire   [31:0] nvdla_cdma_d_weight_ram_type_0_out;
wire   [31:0] nvdla_cdma_d_weight_size_0_0_out;
wire   [31:0] nvdla_cdma_d_weight_size_1_0_out;
wire   [31:0] nvdla_cdma_d_wgs_addr_high_0_out;
wire   [31:0] nvdla_cdma_d_wgs_addr_low_0_out;
wire   [31:0] nvdla_cdma_d_wmb_addr_high_0_out;
wire   [31:0] nvdla_cdma_d_wmb_addr_low_0_out;
wire   [31:0] nvdla_cdma_d_wmb_bytes_0_out;
wire   [31:0] nvdla_cdma_d_zero_padding_0_out;
wire   [31:0] nvdla_cdma_d_zero_padding_value_0_out;
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
output [4:0]  data_bank;
output [4:0]  weight_bank;
output [4:0]  batches;
output [31:0] batch_stride;
output [2:0]  conv_x_stride;
output [2:0]  conv_y_stride;
output        cvt_en;
output [5:0]  cvt_truncate;
output [15:0] cvt_offset;
output [15:0] cvt_scale;
output [31:0] cya;
output [31:0] datain_addr_high_0;
output [31:0] datain_addr_high_1;
output [31:0] datain_addr_low_0;
output [31:0] datain_addr_low_1;
output        line_packed;
output        surf_packed;
output        datain_ram_type;
output        datain_format;
output [5:0]  pixel_format;
output        pixel_mapping;
output        pixel_sign_override;
output [12:0] datain_height;
output [12:0] datain_width;
output [12:0] datain_channel;
output [12:0] datain_height_ext;
output [12:0] datain_width_ext;
output [13:0] entries;
output [11:0] grains;
output [31:0] line_stride;
output [31:0] uv_line_stride;
output        mean_format;
output [15:0] mean_gu;
output [15:0] mean_ry;
output [15:0] mean_ax;
output [15:0] mean_bv;
output        conv_mode;
output        data_reuse;
output [1:0]  in_precision;
output [1:0]  proc_precision;
output        skip_data_rls;
output        skip_weight_rls;
output        weight_reuse;
output        nan_to_zero;
output        op_en_trigger;
output        dma_en;
output [4:0]  pixel_x_offset;
output [2:0]  pixel_y_offset;
output [9:0]  rsv_per_line;
output [9:0]  rsv_per_uv_line;
output [2:0]  rsv_height;
output [4:0]  rsv_y_index;
output [31:0] surf_stride;
output [31:0] weight_addr_high;
output [31:0] weight_addr_low;
output [31:0] weight_bytes;
output        weight_format;
output        weight_ram_type;
output [17:0] byte_per_kernel;
output [12:0] weight_kernel;
output [31:0] wgs_addr_high;
output [31:0] wgs_addr_low;
output [31:0] wmb_addr_high;
output [31:0] wmb_addr_low;
output [27:0] wmb_bytes;
output [5:0]  pad_bottom;
output [4:0]  pad_left;
output [5:0]  pad_right;
output [4:0]  pad_top;
output [15:0] pad_value;

// Read-only register inputs
input [31:0]  inf_data_num;
input [31:0]  inf_weight_num;
input [31:0]  nan_data_num;
input [31:0]  nan_weight_num;
input         op_en;
input [31:0]  dat_rd_latency;
input [31:0]  dat_rd_stall;
input [31:0]  wt_rd_latency;
input [31:0]  wt_rd_stall;

// wr_mask register inputs

// rstn register inputs

// leda FM_2_23 off
reg           arreggen_abort_on_invalid_wr;
reg           arreggen_abort_on_rowr;
reg           arreggen_dump;
// leda FM_2_23 on
reg    [31:0] batch_stride;
reg     [4:0] batches;
reg    [17:0] byte_per_kernel;
reg           conv_mode;
reg     [2:0] conv_x_stride;
reg     [2:0] conv_y_stride;
reg           cvt_en;
reg    [15:0] cvt_offset;
reg    [15:0] cvt_scale;
reg     [5:0] cvt_truncate;
reg    [31:0] cya;
reg     [4:0] data_bank;
reg           data_reuse;
reg    [31:0] datain_addr_high_0;
reg    [31:0] datain_addr_high_1;
reg    [31:0] datain_addr_low_0;
reg    [31:0] datain_addr_low_1;
reg    [12:0] datain_channel;
reg           datain_format;
reg    [12:0] datain_height;
reg    [12:0] datain_height_ext;
reg           datain_ram_type;
reg    [12:0] datain_width;
reg    [12:0] datain_width_ext;
reg           dma_en;
reg    [13:0] entries;
reg    [11:0] grains;
reg     [1:0] in_precision;
reg           line_packed;
reg    [31:0] line_stride;
reg    [15:0] mean_ax;
reg    [15:0] mean_bv;
reg           mean_format;
reg    [15:0] mean_gu;
reg    [15:0] mean_ry;
reg           nan_to_zero;
reg     [5:0] pad_bottom;
reg     [4:0] pad_left;
reg     [5:0] pad_right;
reg     [4:0] pad_top;
reg    [15:0] pad_value;
reg     [5:0] pixel_format;
reg           pixel_mapping;
reg           pixel_sign_override;
reg     [4:0] pixel_x_offset;
reg     [2:0] pixel_y_offset;
reg     [1:0] proc_precision;
reg    [31:0] reg_rd_data;
reg     [2:0] rsv_height;
reg     [9:0] rsv_per_line;
reg     [9:0] rsv_per_uv_line;
reg     [4:0] rsv_y_index;
reg           skip_data_rls;
reg           skip_weight_rls;
reg           surf_packed;
reg    [31:0] surf_stride;
reg    [31:0] uv_line_stride;
reg    [31:0] weight_addr_high;
reg    [31:0] weight_addr_low;
reg     [4:0] weight_bank;
reg    [31:0] weight_bytes;
reg           weight_format;
reg    [12:0] weight_kernel;
reg           weight_ram_type;
reg           weight_reuse;
reg    [31:0] wgs_addr_high;
reg    [31:0] wgs_addr_low;
reg    [31:0] wmb_addr_high;
reg    [31:0] wmb_addr_low;
reg    [27:0] wmb_bytes;

assign reg_offset_wr = {20'b0 , reg_offset};
// SCR signals

// Address decode
wire nvdla_cdma_d_bank_0_wren = (reg_offset_wr == (32'h50bc  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_batch_number_0_wren = (reg_offset_wr == (32'h5058  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_batch_stride_0_wren = (reg_offset_wr == (32'h505c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_conv_stride_0_wren = (reg_offset_wr == (32'h50b0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_cvt_cfg_0_wren = (reg_offset_wr == (32'h50a4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_cvt_offset_0_wren = (reg_offset_wr == (32'h50a8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_cvt_scale_0_wren = (reg_offset_wr == (32'h50ac  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_cya_0_wren = (reg_offset_wr == (32'h50e8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_dain_addr_high_0_0_wren = (reg_offset_wr == (32'h5030  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_dain_addr_high_1_0_wren = (reg_offset_wr == (32'h5038  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_dain_addr_low_0_0_wren = (reg_offset_wr == (32'h5034  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_dain_addr_low_1_0_wren = (reg_offset_wr == (32'h503c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_dain_map_0_wren = (reg_offset_wr == (32'h504c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_dain_ram_type_0_wren = (reg_offset_wr == (32'h502c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_datain_format_0_wren = (reg_offset_wr == (32'h5018  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_datain_size_0_0_wren = (reg_offset_wr == (32'h501c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_datain_size_1_0_wren = (reg_offset_wr == (32'h5020  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_datain_size_ext_0_0_wren = (reg_offset_wr == (32'h5024  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_entry_per_slice_0_wren = (reg_offset_wr == (32'h5060  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_fetch_grain_0_wren = (reg_offset_wr == (32'h5064  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_inf_input_data_num_0_wren = (reg_offset_wr == (32'h50cc  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_inf_input_weight_num_0_wren = (reg_offset_wr == (32'h50d0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_line_stride_0_wren = (reg_offset_wr == (32'h5040  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_line_uv_stride_0_wren = (reg_offset_wr == (32'h5044  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_mean_format_0_wren = (reg_offset_wr == (32'h5098  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_mean_global_0_0_wren = (reg_offset_wr == (32'h509c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_mean_global_1_0_wren = (reg_offset_wr == (32'h50a0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_misc_cfg_0_wren = (reg_offset_wr == (32'h5014  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_nan_flush_to_zero_0_wren = (reg_offset_wr == (32'h50c0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_nan_input_data_num_0_wren = (reg_offset_wr == (32'h50c4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_nan_input_weight_num_0_wren = (reg_offset_wr == (32'h50c8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_op_enable_0_wren = (reg_offset_wr == (32'h5010  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_perf_dat_read_latency_0_wren = (reg_offset_wr == (32'h50e0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_perf_dat_read_stall_0_wren = (reg_offset_wr == (32'h50d8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_perf_enable_0_wren = (reg_offset_wr == (32'h50d4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_perf_wt_read_latency_0_wren = (reg_offset_wr == (32'h50e4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_perf_wt_read_stall_0_wren = (reg_offset_wr == (32'h50dc  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_pixel_offset_0_wren = (reg_offset_wr == (32'h5028  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_reserved_x_cfg_0_wren = (reg_offset_wr == (32'h5050  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_reserved_y_cfg_0_wren = (reg_offset_wr == (32'h5054  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_surf_stride_0_wren = (reg_offset_wr == (32'h5048  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_weight_addr_high_0_wren = (reg_offset_wr == (32'h5078  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_weight_addr_low_0_wren = (reg_offset_wr == (32'h507c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_weight_bytes_0_wren = (reg_offset_wr == (32'h5080  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_weight_format_0_wren = (reg_offset_wr == (32'h5068  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_weight_ram_type_0_wren = (reg_offset_wr == (32'h5074  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_weight_size_0_0_wren = (reg_offset_wr == (32'h506c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_weight_size_1_0_wren = (reg_offset_wr == (32'h5070  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_wgs_addr_high_0_wren = (reg_offset_wr == (32'h5084  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_wgs_addr_low_0_wren = (reg_offset_wr == (32'h5088  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_wmb_addr_high_0_wren = (reg_offset_wr == (32'h508c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_wmb_addr_low_0_wren = (reg_offset_wr == (32'h5090  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_wmb_bytes_0_wren = (reg_offset_wr == (32'h5094  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_zero_padding_0_wren = (reg_offset_wr == (32'h50b4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdma_d_zero_padding_value_0_wren = (reg_offset_wr == (32'h50b8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)

assign nvdla_cdma_d_bank_0_out[31:0] = { 11'b0, weight_bank, 11'b0, data_bank };
assign nvdla_cdma_d_batch_number_0_out[31:0] = { 27'b0, batches };
assign nvdla_cdma_d_batch_stride_0_out[31:0] = { batch_stride };
assign nvdla_cdma_d_conv_stride_0_out[31:0] = { 13'b0, conv_y_stride, 13'b0, conv_x_stride };
assign nvdla_cdma_d_cvt_cfg_0_out[31:0] = { 22'b0, cvt_truncate, 3'b0, cvt_en };
assign nvdla_cdma_d_cvt_offset_0_out[31:0] = { 16'b0, cvt_offset };
assign nvdla_cdma_d_cvt_scale_0_out[31:0] = { 16'b0, cvt_scale };
assign nvdla_cdma_d_cya_0_out[31:0] = { cya };
assign nvdla_cdma_d_dain_addr_high_0_0_out[31:0] = { datain_addr_high_0 };
assign nvdla_cdma_d_dain_addr_high_1_0_out[31:0] = { datain_addr_high_1 };
assign nvdla_cdma_d_dain_addr_low_0_0_out[31:0] = { datain_addr_low_0 };
assign nvdla_cdma_d_dain_addr_low_1_0_out[31:0] = { datain_addr_low_1 };
assign nvdla_cdma_d_dain_map_0_out[31:0] = { 15'b0, surf_packed, 15'b0, line_packed };
assign nvdla_cdma_d_dain_ram_type_0_out[31:0] = { 31'b0, datain_ram_type };
assign nvdla_cdma_d_datain_format_0_out[31:0] = { 11'b0, pixel_sign_override, 3'b0, pixel_mapping, 2'b0, pixel_format, 7'b0, datain_format };
assign nvdla_cdma_d_datain_size_0_0_out[31:0] = { 3'b0, datain_height, 3'b0, datain_width };
assign nvdla_cdma_d_datain_size_1_0_out[31:0] = { 19'b0, datain_channel };
assign nvdla_cdma_d_datain_size_ext_0_0_out[31:0] = { 3'b0, datain_height_ext, 3'b0, datain_width_ext };
assign nvdla_cdma_d_entry_per_slice_0_out[31:0] = { 18'b0, entries };
assign nvdla_cdma_d_fetch_grain_0_out[31:0] = { 20'b0, grains };
assign nvdla_cdma_d_inf_input_data_num_0_out[31:0] = { inf_data_num };
assign nvdla_cdma_d_inf_input_weight_num_0_out[31:0] = { inf_weight_num };
assign nvdla_cdma_d_line_stride_0_out[31:0] = { line_stride };
assign nvdla_cdma_d_line_uv_stride_0_out[31:0] = { uv_line_stride };
assign nvdla_cdma_d_mean_format_0_out[31:0] = { 31'b0, mean_format };
assign nvdla_cdma_d_mean_global_0_0_out[31:0] = { mean_gu, mean_ry };
assign nvdla_cdma_d_mean_global_1_0_out[31:0] = { mean_ax, mean_bv };
assign nvdla_cdma_d_misc_cfg_0_out[31:0] = { 3'b0, skip_weight_rls, 3'b0, skip_data_rls, 3'b0, weight_reuse, 3'b0, data_reuse, 2'b0, proc_precision, 2'b0, in_precision, 7'b0, conv_mode };
assign nvdla_cdma_d_nan_flush_to_zero_0_out[31:0] = { 31'b0, nan_to_zero };
assign nvdla_cdma_d_nan_input_data_num_0_out[31:0] = { nan_data_num };
assign nvdla_cdma_d_nan_input_weight_num_0_out[31:0] = { nan_weight_num };
assign nvdla_cdma_d_op_enable_0_out[31:0] = { 31'b0, op_en };
assign nvdla_cdma_d_perf_dat_read_latency_0_out[31:0] = { dat_rd_latency };
assign nvdla_cdma_d_perf_dat_read_stall_0_out[31:0] = { dat_rd_stall };
assign nvdla_cdma_d_perf_enable_0_out[31:0] = { 31'b0, dma_en };
assign nvdla_cdma_d_perf_wt_read_latency_0_out[31:0] = { wt_rd_latency };
assign nvdla_cdma_d_perf_wt_read_stall_0_out[31:0] = { wt_rd_stall };
assign nvdla_cdma_d_pixel_offset_0_out[31:0] = { 13'b0, pixel_y_offset, 11'b0, pixel_x_offset };
assign nvdla_cdma_d_reserved_x_cfg_0_out[31:0] = { 6'b0, rsv_per_uv_line, 6'b0, rsv_per_line };
assign nvdla_cdma_d_reserved_y_cfg_0_out[31:0] = { 11'b0, rsv_y_index, 13'b0, rsv_height };
assign nvdla_cdma_d_surf_stride_0_out[31:0] = { surf_stride };
assign nvdla_cdma_d_weight_addr_high_0_out[31:0] = { weight_addr_high };
assign nvdla_cdma_d_weight_addr_low_0_out[31:0] = { weight_addr_low };
assign nvdla_cdma_d_weight_bytes_0_out[31:0] = { weight_bytes };
assign nvdla_cdma_d_weight_format_0_out[31:0] = { 31'b0, weight_format };
assign nvdla_cdma_d_weight_ram_type_0_out[31:0] = { 31'b0, weight_ram_type };
assign nvdla_cdma_d_weight_size_0_0_out[31:0] = { 14'b0, byte_per_kernel };
assign nvdla_cdma_d_weight_size_1_0_out[31:0] = { 19'b0, weight_kernel };
assign nvdla_cdma_d_wgs_addr_high_0_out[31:0] = { wgs_addr_high };
assign nvdla_cdma_d_wgs_addr_low_0_out[31:0] = { wgs_addr_low };
assign nvdla_cdma_d_wmb_addr_high_0_out[31:0] = { wmb_addr_high };
assign nvdla_cdma_d_wmb_addr_low_0_out[31:0] = { wmb_addr_low };
assign nvdla_cdma_d_wmb_bytes_0_out[31:0] = { 4'b0, wmb_bytes };
assign nvdla_cdma_d_zero_padding_0_out[31:0] = { 2'b0, pad_bottom, 3'b0, pad_top, 2'b0, pad_right, 3'b0, pad_left };
assign nvdla_cdma_d_zero_padding_value_0_out[31:0] = { 16'b0, pad_value };

assign op_en_trigger = nvdla_cdma_d_op_enable_0_wren;  //(W563)

assign reg_offset_rd_int = reg_offset;
// Output mux
//spyglass disable_block W338, W263 
always @(
  reg_offset_rd_int
  or nvdla_cdma_d_bank_0_out
  or nvdla_cdma_d_batch_number_0_out
  or nvdla_cdma_d_batch_stride_0_out
  or nvdla_cdma_d_conv_stride_0_out
  or nvdla_cdma_d_cvt_cfg_0_out
  or nvdla_cdma_d_cvt_offset_0_out
  or nvdla_cdma_d_cvt_scale_0_out
  or nvdla_cdma_d_cya_0_out
  or nvdla_cdma_d_dain_addr_high_0_0_out
  or nvdla_cdma_d_dain_addr_high_1_0_out
  or nvdla_cdma_d_dain_addr_low_0_0_out
  or nvdla_cdma_d_dain_addr_low_1_0_out
  or nvdla_cdma_d_dain_map_0_out
  or nvdla_cdma_d_dain_ram_type_0_out
  or nvdla_cdma_d_datain_format_0_out
  or nvdla_cdma_d_datain_size_0_0_out
  or nvdla_cdma_d_datain_size_1_0_out
  or nvdla_cdma_d_datain_size_ext_0_0_out
  or nvdla_cdma_d_entry_per_slice_0_out
  or nvdla_cdma_d_fetch_grain_0_out
  or nvdla_cdma_d_inf_input_data_num_0_out
  or nvdla_cdma_d_inf_input_weight_num_0_out
  or nvdla_cdma_d_line_stride_0_out
  or nvdla_cdma_d_line_uv_stride_0_out
  or nvdla_cdma_d_mean_format_0_out
  or nvdla_cdma_d_mean_global_0_0_out
  or nvdla_cdma_d_mean_global_1_0_out
  or nvdla_cdma_d_misc_cfg_0_out
  or nvdla_cdma_d_nan_flush_to_zero_0_out
  or nvdla_cdma_d_nan_input_data_num_0_out
  or nvdla_cdma_d_nan_input_weight_num_0_out
  or nvdla_cdma_d_op_enable_0_out
  or nvdla_cdma_d_perf_dat_read_latency_0_out
  or nvdla_cdma_d_perf_dat_read_stall_0_out
  or nvdla_cdma_d_perf_enable_0_out
  or nvdla_cdma_d_perf_wt_read_latency_0_out
  or nvdla_cdma_d_perf_wt_read_stall_0_out
  or nvdla_cdma_d_pixel_offset_0_out
  or nvdla_cdma_d_reserved_x_cfg_0_out
  or nvdla_cdma_d_reserved_y_cfg_0_out
  or nvdla_cdma_d_surf_stride_0_out
  or nvdla_cdma_d_weight_addr_high_0_out
  or nvdla_cdma_d_weight_addr_low_0_out
  or nvdla_cdma_d_weight_bytes_0_out
  or nvdla_cdma_d_weight_format_0_out
  or nvdla_cdma_d_weight_ram_type_0_out
  or nvdla_cdma_d_weight_size_0_0_out
  or nvdla_cdma_d_weight_size_1_0_out
  or nvdla_cdma_d_wgs_addr_high_0_out
  or nvdla_cdma_d_wgs_addr_low_0_out
  or nvdla_cdma_d_wmb_addr_high_0_out
  or nvdla_cdma_d_wmb_addr_low_0_out
  or nvdla_cdma_d_wmb_bytes_0_out
  or nvdla_cdma_d_zero_padding_0_out
  or nvdla_cdma_d_zero_padding_value_0_out
  ) begin
  case (reg_offset_rd_int)
     (32'h50bc  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_bank_0_out ;
                            end 
     (32'h5058  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_batch_number_0_out ;
                            end 
     (32'h505c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_batch_stride_0_out ;
                            end 
     (32'h50b0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_conv_stride_0_out ;
                            end 
     (32'h50a4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_cvt_cfg_0_out ;
                            end 
     (32'h50a8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_cvt_offset_0_out ;
                            end 
     (32'h50ac  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_cvt_scale_0_out ;
                            end 
     (32'h50e8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_cya_0_out ;
                            end 
     (32'h5030  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_dain_addr_high_0_0_out ;
                            end 
     (32'h5038  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_dain_addr_high_1_0_out ;
                            end 
     (32'h5034  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_dain_addr_low_0_0_out ;
                            end 
     (32'h503c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_dain_addr_low_1_0_out ;
                            end 
     (32'h504c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_dain_map_0_out ;
                            end 
     (32'h502c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_dain_ram_type_0_out ;
                            end 
     (32'h5018  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_datain_format_0_out ;
                            end 
     (32'h501c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_datain_size_0_0_out ;
                            end 
     (32'h5020  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_datain_size_1_0_out ;
                            end 
     (32'h5024  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_datain_size_ext_0_0_out ;
                            end 
     (32'h5060  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_entry_per_slice_0_out ;
                            end 
     (32'h5064  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_fetch_grain_0_out ;
                            end 
     (32'h50cc  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_inf_input_data_num_0_out ;
                            end 
     (32'h50d0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_inf_input_weight_num_0_out ;
                            end 
     (32'h5040  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_line_stride_0_out ;
                            end 
     (32'h5044  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_line_uv_stride_0_out ;
                            end 
     (32'h5098  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_mean_format_0_out ;
                            end 
     (32'h509c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_mean_global_0_0_out ;
                            end 
     (32'h50a0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_mean_global_1_0_out ;
                            end 
     (32'h5014  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_misc_cfg_0_out ;
                            end 
     (32'h50c0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_nan_flush_to_zero_0_out ;
                            end 
     (32'h50c4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_nan_input_data_num_0_out ;
                            end 
     (32'h50c8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_nan_input_weight_num_0_out ;
                            end 
     (32'h5010  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_op_enable_0_out ;
                            end 
     (32'h50e0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_perf_dat_read_latency_0_out ;
                            end 
     (32'h50d8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_perf_dat_read_stall_0_out ;
                            end 
     (32'h50d4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_perf_enable_0_out ;
                            end 
     (32'h50e4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_perf_wt_read_latency_0_out ;
                            end 
     (32'h50dc  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_perf_wt_read_stall_0_out ;
                            end 
     (32'h5028  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_pixel_offset_0_out ;
                            end 
     (32'h5050  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_reserved_x_cfg_0_out ;
                            end 
     (32'h5054  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_reserved_y_cfg_0_out ;
                            end 
     (32'h5048  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_surf_stride_0_out ;
                            end 
     (32'h5078  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_weight_addr_high_0_out ;
                            end 
     (32'h507c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_weight_addr_low_0_out ;
                            end 
     (32'h5080  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_weight_bytes_0_out ;
                            end 
     (32'h5068  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_weight_format_0_out ;
                            end 
     (32'h5074  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_weight_ram_type_0_out ;
                            end 
     (32'h506c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_weight_size_0_0_out ;
                            end 
     (32'h5070  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_weight_size_1_0_out ;
                            end 
     (32'h5084  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_wgs_addr_high_0_out ;
                            end 
     (32'h5088  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_wgs_addr_low_0_out ;
                            end 
     (32'h508c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_wmb_addr_high_0_out ;
                            end 
     (32'h5090  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_wmb_addr_low_0_out ;
                            end 
     (32'h5094  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_wmb_bytes_0_out ;
                            end 
     (32'h50b4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_zero_padding_0_out ;
                            end 
     (32'h50b8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdma_d_zero_padding_value_0_out ;
                            end 
    default: reg_rd_data = {32{1'b0}};
  endcase
end

//spyglass enable_block W338, W263

// spyglass disable_block STARC-2.10.1.6, NoConstWithXZ, W443

// Register flop declarations
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_bank[4:0] <= 5'b00000;
    weight_bank[4:0] <= 5'b00000;
    batches[4:0] <= 5'b00000;
    batch_stride[31:0] <= 32'b00000000000000000000000000000000;
    conv_x_stride[2:0] <= 3'b000;
    conv_y_stride[2:0] <= 3'b000;
    cvt_en <= 1'b0;
    cvt_truncate[5:0] <= 6'b000000;
    cvt_offset[15:0] <= 16'b0000000000000000;
    cvt_scale[15:0] <= 16'b0000000000000000;
    cya[31:0] <= 32'b00000000000000000000000000000000;
    datain_addr_high_0[31:0] <= 32'b00000000000000000000000000000000;
    datain_addr_high_1[31:0] <= 32'b00000000000000000000000000000000;
    datain_addr_low_0[31:0] <= 32'b00000000000000000000000000000000;
    datain_addr_low_1[31:0] <= 32'b00000000000000000000000000000000;
    line_packed <= 1'b0;
    surf_packed <= 1'b0;
    datain_ram_type <= 1'b0;
    datain_format <= 1'b0;
    pixel_format[5:0] <= 6'b001100;
    pixel_mapping <= 1'b0;
    pixel_sign_override <= 1'b0;
    datain_height[12:0] <= 13'b0000000000000;
    datain_width[12:0] <= 13'b0000000000000;
    datain_channel[12:0] <= 13'b0000000000000;
    datain_height_ext[12:0] <= 13'b0000000000000;
    datain_width_ext[12:0] <= 13'b0000000000000;
    entries[13:0] <= 14'b000000000000;
    grains[11:0] <= 12'b000000000000;
    line_stride[31:0] <= 32'b00000000000000000000000000000000;
    uv_line_stride[31:0] <= 32'b00000000000000000000000000000000;
    mean_format <= 1'b0;
    mean_gu[15:0] <= 16'b0000000000000000;
    mean_ry[15:0] <= 16'b0000000000000000;
    mean_ax[15:0] <= 16'b0000000000000000;
    mean_bv[15:0] <= 16'b0000000000000000;
    conv_mode <= 1'b0;
    data_reuse <= 1'b0;
    in_precision[1:0] <= 2'b01;
    proc_precision[1:0] <= 2'b01;
    skip_data_rls <= 1'b0;
    skip_weight_rls <= 1'b0;
    weight_reuse <= 1'b0;
    nan_to_zero <= 1'b0;
    dma_en <= 1'b0;
    pixel_x_offset[4:0] <= 5'b00000;
    pixel_y_offset[2:0] <= 3'b000;
    rsv_per_line[9:0] <= 10'b0000000000;
    rsv_per_uv_line[9:0] <= 10'b0000000000;
    rsv_height[2:0] <= 3'b000;
    rsv_y_index[4:0] <= 5'b00000;
    surf_stride[31:0] <= 32'b00000000000000000000000000000000;
    weight_addr_high[31:0] <= 32'b00000000000000000000000000000000;
    weight_addr_low[31:0] <= 32'b00000000000000000000000000000000;
    weight_bytes[31:0] <= 32'b00000000000000000000000000000000;
    weight_format <= 1'b0;
    weight_ram_type <= 1'b0;
    byte_per_kernel[17:0] <= 18'b000000000000000000;
    weight_kernel[12:0] <= 13'b0000000000000;
    wgs_addr_high[31:0] <= 32'b00000000000000000000000000000000;
    wgs_addr_low[31:0] <= 32'b00000000000000000000000000000000;
    wmb_addr_high[31:0] <= 32'b00000000000000000000000000000000;
    wmb_addr_low[31:0] <= 32'b00000000000000000000000000000000;
    wmb_bytes[27:0] <= 28'b0000000000000000000000000000;
    pad_bottom[5:0] <= 6'b000000;
    pad_left[4:0] <= 5'b00000;
    pad_right[5:0] <= 6'b000000;
    pad_top[4:0] <= 5'b00000;
    pad_value[15:0] <= 16'b0000000000000000;
  end else begin
  // Register: NVDLA_CDMA_D_BANK_0    Field: data_bank
  if (nvdla_cdma_d_bank_0_wren) begin
    data_bank[4:0] <= reg_wr_data[4:0];
  end

  // Register: NVDLA_CDMA_D_BANK_0    Field: weight_bank
  if (nvdla_cdma_d_bank_0_wren) begin
    weight_bank[4:0] <= reg_wr_data[20:16];
  end

  // Register: NVDLA_CDMA_D_BATCH_NUMBER_0    Field: batches
  if (nvdla_cdma_d_batch_number_0_wren) begin
    batches[4:0] <= reg_wr_data[4:0];
  end

  // Register: NVDLA_CDMA_D_BATCH_STRIDE_0    Field: batch_stride
  if (nvdla_cdma_d_batch_stride_0_wren) begin
    batch_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_CONV_STRIDE_0    Field: conv_x_stride
  if (nvdla_cdma_d_conv_stride_0_wren) begin
    conv_x_stride[2:0] <= reg_wr_data[2:0];
  end

  // Register: NVDLA_CDMA_D_CONV_STRIDE_0    Field: conv_y_stride
  if (nvdla_cdma_d_conv_stride_0_wren) begin
    conv_y_stride[2:0] <= reg_wr_data[18:16];
  end

  // Register: NVDLA_CDMA_D_CVT_CFG_0    Field: cvt_en
  if (nvdla_cdma_d_cvt_cfg_0_wren) begin
    cvt_en <= reg_wr_data[0];
  end

  // Register: NVDLA_CDMA_D_CVT_CFG_0    Field: cvt_truncate
  if (nvdla_cdma_d_cvt_cfg_0_wren) begin
    cvt_truncate[5:0] <= reg_wr_data[9:4];
  end

  // Register: NVDLA_CDMA_D_CVT_OFFSET_0    Field: cvt_offset
  if (nvdla_cdma_d_cvt_offset_0_wren) begin
    cvt_offset[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_CDMA_D_CVT_SCALE_0    Field: cvt_scale
  if (nvdla_cdma_d_cvt_scale_0_wren) begin
    cvt_scale[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_CDMA_D_CYA_0    Field: cya
  if (nvdla_cdma_d_cya_0_wren) begin
    cya[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_DAIN_ADDR_HIGH_0_0    Field: datain_addr_high_0
  if (nvdla_cdma_d_dain_addr_high_0_0_wren) begin
    datain_addr_high_0[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_DAIN_ADDR_HIGH_1_0    Field: datain_addr_high_1
  if (nvdla_cdma_d_dain_addr_high_1_0_wren) begin
    datain_addr_high_1[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_DAIN_ADDR_LOW_0_0    Field: datain_addr_low_0
  if (nvdla_cdma_d_dain_addr_low_0_0_wren) begin
    datain_addr_low_0[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_DAIN_ADDR_LOW_1_0    Field: datain_addr_low_1
  if (nvdla_cdma_d_dain_addr_low_1_0_wren) begin
    datain_addr_low_1[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_DAIN_MAP_0    Field: line_packed
  if (nvdla_cdma_d_dain_map_0_wren) begin
    line_packed <= reg_wr_data[0];
  end

  // Register: NVDLA_CDMA_D_DAIN_MAP_0    Field: surf_packed
  if (nvdla_cdma_d_dain_map_0_wren) begin
    surf_packed <= reg_wr_data[16];
  end

  // Register: NVDLA_CDMA_D_DAIN_RAM_TYPE_0    Field: datain_ram_type
  if (nvdla_cdma_d_dain_ram_type_0_wren) begin
    datain_ram_type <= reg_wr_data[0];
  end

  // Register: NVDLA_CDMA_D_DATAIN_FORMAT_0    Field: datain_format
  if (nvdla_cdma_d_datain_format_0_wren) begin
    datain_format <= reg_wr_data[0];
  end

  // Register: NVDLA_CDMA_D_DATAIN_FORMAT_0    Field: pixel_format
  if (nvdla_cdma_d_datain_format_0_wren) begin
    pixel_format[5:0] <= reg_wr_data[13:8];
  end

  // Register: NVDLA_CDMA_D_DATAIN_FORMAT_0    Field: pixel_mapping
  if (nvdla_cdma_d_datain_format_0_wren) begin
    pixel_mapping <= reg_wr_data[16];
  end

  // Register: NVDLA_CDMA_D_DATAIN_FORMAT_0    Field: pixel_sign_override
  if (nvdla_cdma_d_datain_format_0_wren) begin
    pixel_sign_override <= reg_wr_data[20];
  end

  // Register: NVDLA_CDMA_D_DATAIN_SIZE_0_0    Field: datain_height
  if (nvdla_cdma_d_datain_size_0_0_wren) begin
    datain_height[12:0] <= reg_wr_data[28:16];
  end

  // Register: NVDLA_CDMA_D_DATAIN_SIZE_0_0    Field: datain_width
  if (nvdla_cdma_d_datain_size_0_0_wren) begin
    datain_width[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_CDMA_D_DATAIN_SIZE_1_0    Field: datain_channel
  if (nvdla_cdma_d_datain_size_1_0_wren) begin
    datain_channel[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_CDMA_D_DATAIN_SIZE_EXT_0_0    Field: datain_height_ext
  if (nvdla_cdma_d_datain_size_ext_0_0_wren) begin
    datain_height_ext[12:0] <= reg_wr_data[28:16];
  end

  // Register: NVDLA_CDMA_D_DATAIN_SIZE_EXT_0_0    Field: datain_width_ext
  if (nvdla_cdma_d_datain_size_ext_0_0_wren) begin
    datain_width_ext[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_CDMA_D_ENTRY_PER_SLICE_0    Field: entries
  if (nvdla_cdma_d_entry_per_slice_0_wren) begin
    entries[13:0] <= reg_wr_data[13:0];
  end

  // Register: NVDLA_CDMA_D_FETCH_GRAIN_0    Field: grains
  if (nvdla_cdma_d_fetch_grain_0_wren) begin
    grains[11:0] <= reg_wr_data[11:0];
  end

  // Not generating flops for read-only field NVDLA_CDMA_D_INF_INPUT_DATA_NUM_0::inf_data_num

  // Not generating flops for read-only field NVDLA_CDMA_D_INF_INPUT_WEIGHT_NUM_0::inf_weight_num

  // Register: NVDLA_CDMA_D_LINE_STRIDE_0    Field: line_stride
  if (nvdla_cdma_d_line_stride_0_wren) begin
    line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_LINE_UV_STRIDE_0    Field: uv_line_stride
  if (nvdla_cdma_d_line_uv_stride_0_wren) begin
    uv_line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_MEAN_FORMAT_0    Field: mean_format
  if (nvdla_cdma_d_mean_format_0_wren) begin
    mean_format <= reg_wr_data[0];
  end

  // Register: NVDLA_CDMA_D_MEAN_GLOBAL_0_0    Field: mean_gu
  if (nvdla_cdma_d_mean_global_0_0_wren) begin
    mean_gu[15:0] <= reg_wr_data[31:16];
  end

  // Register: NVDLA_CDMA_D_MEAN_GLOBAL_0_0    Field: mean_ry
  if (nvdla_cdma_d_mean_global_0_0_wren) begin
    mean_ry[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_CDMA_D_MEAN_GLOBAL_1_0    Field: mean_ax
  if (nvdla_cdma_d_mean_global_1_0_wren) begin
    mean_ax[15:0] <= reg_wr_data[31:16];
  end

  // Register: NVDLA_CDMA_D_MEAN_GLOBAL_1_0    Field: mean_bv
  if (nvdla_cdma_d_mean_global_1_0_wren) begin
    mean_bv[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_CDMA_D_MISC_CFG_0    Field: conv_mode
  if (nvdla_cdma_d_misc_cfg_0_wren) begin
    conv_mode <= reg_wr_data[0];
  end

  // Register: NVDLA_CDMA_D_MISC_CFG_0    Field: data_reuse
  if (nvdla_cdma_d_misc_cfg_0_wren) begin
    data_reuse <= reg_wr_data[16];
  end

  // Register: NVDLA_CDMA_D_MISC_CFG_0    Field: in_precision
  if (nvdla_cdma_d_misc_cfg_0_wren) begin
    in_precision[1:0] <= reg_wr_data[9:8];
  end

  // Register: NVDLA_CDMA_D_MISC_CFG_0    Field: proc_precision
  if (nvdla_cdma_d_misc_cfg_0_wren) begin
    proc_precision[1:0] <= reg_wr_data[13:12];
  end

  // Register: NVDLA_CDMA_D_MISC_CFG_0    Field: skip_data_rls
  if (nvdla_cdma_d_misc_cfg_0_wren) begin
    skip_data_rls <= reg_wr_data[24];
  end

  // Register: NVDLA_CDMA_D_MISC_CFG_0    Field: skip_weight_rls
  if (nvdla_cdma_d_misc_cfg_0_wren) begin
    skip_weight_rls <= reg_wr_data[28];
  end

  // Register: NVDLA_CDMA_D_MISC_CFG_0    Field: weight_reuse
  if (nvdla_cdma_d_misc_cfg_0_wren) begin
    weight_reuse <= reg_wr_data[20];
  end

  // Register: NVDLA_CDMA_D_NAN_FLUSH_TO_ZERO_0    Field: nan_to_zero
  if (nvdla_cdma_d_nan_flush_to_zero_0_wren) begin
    nan_to_zero <= reg_wr_data[0];
  end

  // Not generating flops for read-only field NVDLA_CDMA_D_NAN_INPUT_DATA_NUM_0::nan_data_num

  // Not generating flops for read-only field NVDLA_CDMA_D_NAN_INPUT_WEIGHT_NUM_0::nan_weight_num

  // Not generating flops for field NVDLA_CDMA_D_OP_ENABLE_0::op_en (to be implemented outside)

  // Not generating flops for read-only field NVDLA_CDMA_D_PERF_DAT_READ_LATENCY_0::dat_rd_latency

  // Not generating flops for read-only field NVDLA_CDMA_D_PERF_DAT_READ_STALL_0::dat_rd_stall

  // Register: NVDLA_CDMA_D_PERF_ENABLE_0    Field: dma_en
  if (nvdla_cdma_d_perf_enable_0_wren) begin
    dma_en <= reg_wr_data[0];
  end

  // Not generating flops for read-only field NVDLA_CDMA_D_PERF_WT_READ_LATENCY_0::wt_rd_latency

  // Not generating flops for read-only field NVDLA_CDMA_D_PERF_WT_READ_STALL_0::wt_rd_stall

  // Register: NVDLA_CDMA_D_PIXEL_OFFSET_0    Field: pixel_x_offset
  if (nvdla_cdma_d_pixel_offset_0_wren) begin
    pixel_x_offset[4:0] <= reg_wr_data[4:0];
  end

  // Register: NVDLA_CDMA_D_PIXEL_OFFSET_0    Field: pixel_y_offset
  if (nvdla_cdma_d_pixel_offset_0_wren) begin
    pixel_y_offset[2:0] <= reg_wr_data[18:16];
  end

  // Register: NVDLA_CDMA_D_RESERVED_X_CFG_0    Field: rsv_per_line
  if (nvdla_cdma_d_reserved_x_cfg_0_wren) begin
    rsv_per_line[9:0] <= reg_wr_data[9:0];
  end

  // Register: NVDLA_CDMA_D_RESERVED_X_CFG_0    Field: rsv_per_uv_line
  if (nvdla_cdma_d_reserved_x_cfg_0_wren) begin
    rsv_per_uv_line[9:0] <= reg_wr_data[25:16];
  end

  // Register: NVDLA_CDMA_D_RESERVED_Y_CFG_0    Field: rsv_height
  if (nvdla_cdma_d_reserved_y_cfg_0_wren) begin
    rsv_height[2:0] <= reg_wr_data[2:0];
  end

  // Register: NVDLA_CDMA_D_RESERVED_Y_CFG_0    Field: rsv_y_index
  if (nvdla_cdma_d_reserved_y_cfg_0_wren) begin
    rsv_y_index[4:0] <= reg_wr_data[20:16];
  end

  // Register: NVDLA_CDMA_D_SURF_STRIDE_0    Field: surf_stride
  if (nvdla_cdma_d_surf_stride_0_wren) begin
    surf_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_WEIGHT_ADDR_HIGH_0    Field: weight_addr_high
  if (nvdla_cdma_d_weight_addr_high_0_wren) begin
    weight_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_WEIGHT_ADDR_LOW_0    Field: weight_addr_low
  if (nvdla_cdma_d_weight_addr_low_0_wren) begin
    weight_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_WEIGHT_BYTES_0    Field: weight_bytes
  if (nvdla_cdma_d_weight_bytes_0_wren) begin
    weight_bytes[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_WEIGHT_FORMAT_0    Field: weight_format
  if (nvdla_cdma_d_weight_format_0_wren) begin
    weight_format <= reg_wr_data[0];
  end

  // Register: NVDLA_CDMA_D_WEIGHT_RAM_TYPE_0    Field: weight_ram_type
  if (nvdla_cdma_d_weight_ram_type_0_wren) begin
    weight_ram_type <= reg_wr_data[0];
  end

  // Register: NVDLA_CDMA_D_WEIGHT_SIZE_0_0    Field: byte_per_kernel
  if (nvdla_cdma_d_weight_size_0_0_wren) begin
    byte_per_kernel[17:0] <= reg_wr_data[17:0];
  end

  // Register: NVDLA_CDMA_D_WEIGHT_SIZE_1_0    Field: weight_kernel
  if (nvdla_cdma_d_weight_size_1_0_wren) begin
    weight_kernel[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_CDMA_D_WGS_ADDR_HIGH_0    Field: wgs_addr_high
  if (nvdla_cdma_d_wgs_addr_high_0_wren) begin
    wgs_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_WGS_ADDR_LOW_0    Field: wgs_addr_low
  if (nvdla_cdma_d_wgs_addr_low_0_wren) begin
    wgs_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_WMB_ADDR_HIGH_0    Field: wmb_addr_high
  if (nvdla_cdma_d_wmb_addr_high_0_wren) begin
    wmb_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_WMB_ADDR_LOW_0    Field: wmb_addr_low
  if (nvdla_cdma_d_wmb_addr_low_0_wren) begin
    wmb_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDMA_D_WMB_BYTES_0    Field: wmb_bytes
  if (nvdla_cdma_d_wmb_bytes_0_wren) begin
    wmb_bytes[27:0] <= reg_wr_data[27:0];
  end

  // Register: NVDLA_CDMA_D_ZERO_PADDING_0    Field: pad_bottom
  if (nvdla_cdma_d_zero_padding_0_wren) begin
    pad_bottom[5:0] <= reg_wr_data[29:24];
  end

  // Register: NVDLA_CDMA_D_ZERO_PADDING_0    Field: pad_left
  if (nvdla_cdma_d_zero_padding_0_wren) begin
    pad_left[4:0] <= reg_wr_data[4:0];
  end

  // Register: NVDLA_CDMA_D_ZERO_PADDING_0    Field: pad_right
  if (nvdla_cdma_d_zero_padding_0_wren) begin
    pad_right[5:0] <= reg_wr_data[13:8];
  end

  // Register: NVDLA_CDMA_D_ZERO_PADDING_0    Field: pad_top
  if (nvdla_cdma_d_zero_padding_0_wren) begin
    pad_top[4:0] <= reg_wr_data[20:16];
  end

  // Register: NVDLA_CDMA_D_ZERO_PADDING_VALUE_0    Field: pad_value
  if (nvdla_cdma_d_zero_padding_value_0_wren) begin
    pad_value[15:0] <= reg_wr_data[15:0];
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
      (32'h50bc  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_BANK_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_bank_0_out, nvdla_cdma_d_bank_0_out);
      (32'h5058  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_BATCH_NUMBER_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_batch_number_0_out, nvdla_cdma_d_batch_number_0_out);
      (32'h505c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_BATCH_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_batch_stride_0_out, nvdla_cdma_d_batch_stride_0_out);
      (32'h50b0  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_CONV_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_conv_stride_0_out, nvdla_cdma_d_conv_stride_0_out);
      (32'h50a4  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_CVT_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_cvt_cfg_0_out, nvdla_cdma_d_cvt_cfg_0_out);
      (32'h50a8  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_CVT_OFFSET_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_cvt_offset_0_out, nvdla_cdma_d_cvt_offset_0_out);
      (32'h50ac  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_CVT_SCALE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_cvt_scale_0_out, nvdla_cdma_d_cvt_scale_0_out);
      (32'h50e8  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_CYA_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_cya_0_out, nvdla_cdma_d_cya_0_out);
      (32'h5030  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_DAIN_ADDR_HIGH_0_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_dain_addr_high_0_0_out, nvdla_cdma_d_dain_addr_high_0_0_out);
      (32'h5038  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_DAIN_ADDR_HIGH_1_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_dain_addr_high_1_0_out, nvdla_cdma_d_dain_addr_high_1_0_out);
      (32'h5034  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_DAIN_ADDR_LOW_0_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_dain_addr_low_0_0_out, nvdla_cdma_d_dain_addr_low_0_0_out);
      (32'h503c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_DAIN_ADDR_LOW_1_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_dain_addr_low_1_0_out, nvdla_cdma_d_dain_addr_low_1_0_out);
      (32'h504c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_DAIN_MAP_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_dain_map_0_out, nvdla_cdma_d_dain_map_0_out);
      (32'h502c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_DAIN_RAM_TYPE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_dain_ram_type_0_out, nvdla_cdma_d_dain_ram_type_0_out);
      (32'h5018  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_DATAIN_FORMAT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_datain_format_0_out, nvdla_cdma_d_datain_format_0_out);
      (32'h501c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_DATAIN_SIZE_0_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_datain_size_0_0_out, nvdla_cdma_d_datain_size_0_0_out);
      (32'h5020  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_DATAIN_SIZE_1_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_datain_size_1_0_out, nvdla_cdma_d_datain_size_1_0_out);
      (32'h5024  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_DATAIN_SIZE_EXT_0_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_datain_size_ext_0_0_out, nvdla_cdma_d_datain_size_ext_0_0_out);
      (32'h5060  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_ENTRY_PER_SLICE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_entry_per_slice_0_out, nvdla_cdma_d_entry_per_slice_0_out);
      (32'h5064  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_FETCH_GRAIN_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_fetch_grain_0_out, nvdla_cdma_d_fetch_grain_0_out);
      (32'h50cc  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDMA_D_INF_INPUT_DATA_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'h50d0  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDMA_D_INF_INPUT_WEIGHT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'h5040  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_line_stride_0_out, nvdla_cdma_d_line_stride_0_out);
      (32'h5044  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_LINE_UV_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_line_uv_stride_0_out, nvdla_cdma_d_line_uv_stride_0_out);
      (32'h5098  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_MEAN_FORMAT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_mean_format_0_out, nvdla_cdma_d_mean_format_0_out);
      (32'h509c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_MEAN_GLOBAL_0_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_mean_global_0_0_out, nvdla_cdma_d_mean_global_0_0_out);
      (32'h50a0  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_MEAN_GLOBAL_1_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_mean_global_1_0_out, nvdla_cdma_d_mean_global_1_0_out);
      (32'h5014  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_MISC_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_misc_cfg_0_out, nvdla_cdma_d_misc_cfg_0_out);
      (32'h50c0  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_NAN_FLUSH_TO_ZERO_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_nan_flush_to_zero_0_out, nvdla_cdma_d_nan_flush_to_zero_0_out);
      (32'h50c4  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDMA_D_NAN_INPUT_DATA_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'h50c8  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDMA_D_NAN_INPUT_WEIGHT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'h5010  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_OP_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_op_enable_0_out, nvdla_cdma_d_op_enable_0_out);
      (32'h50e0  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDMA_D_PERF_DAT_READ_LATENCY_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'h50d8  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDMA_D_PERF_DAT_READ_STALL_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'h50d4  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_PERF_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_perf_enable_0_out, nvdla_cdma_d_perf_enable_0_out);
      (32'h50e4  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDMA_D_PERF_WT_READ_LATENCY_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'h50dc  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDMA_D_PERF_WT_READ_STALL_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'h5028  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_PIXEL_OFFSET_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_pixel_offset_0_out, nvdla_cdma_d_pixel_offset_0_out);
      (32'h5050  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_RESERVED_X_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_reserved_x_cfg_0_out, nvdla_cdma_d_reserved_x_cfg_0_out);
      (32'h5054  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_RESERVED_Y_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_reserved_y_cfg_0_out, nvdla_cdma_d_reserved_y_cfg_0_out);
      (32'h5048  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_SURF_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_surf_stride_0_out, nvdla_cdma_d_surf_stride_0_out);
      (32'h5078  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WEIGHT_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_weight_addr_high_0_out, nvdla_cdma_d_weight_addr_high_0_out);
      (32'h507c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WEIGHT_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_weight_addr_low_0_out, nvdla_cdma_d_weight_addr_low_0_out);
      (32'h5080  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WEIGHT_BYTES_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_weight_bytes_0_out, nvdla_cdma_d_weight_bytes_0_out);
      (32'h5068  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WEIGHT_FORMAT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_weight_format_0_out, nvdla_cdma_d_weight_format_0_out);
      (32'h5074  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WEIGHT_RAM_TYPE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_weight_ram_type_0_out, nvdla_cdma_d_weight_ram_type_0_out);
      (32'h506c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WEIGHT_SIZE_0_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_weight_size_0_0_out, nvdla_cdma_d_weight_size_0_0_out);
      (32'h5070  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WEIGHT_SIZE_1_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_weight_size_1_0_out, nvdla_cdma_d_weight_size_1_0_out);
      (32'h5084  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WGS_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_wgs_addr_high_0_out, nvdla_cdma_d_wgs_addr_high_0_out);
      (32'h5088  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WGS_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_wgs_addr_low_0_out, nvdla_cdma_d_wgs_addr_low_0_out);
      (32'h508c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WMB_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_wmb_addr_high_0_out, nvdla_cdma_d_wmb_addr_high_0_out);
      (32'h5090  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WMB_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_wmb_addr_low_0_out, nvdla_cdma_d_wmb_addr_low_0_out);
      (32'h5094  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_WMB_BYTES_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_wmb_bytes_0_out, nvdla_cdma_d_wmb_bytes_0_out);
      (32'h50b4  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_ZERO_PADDING_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_zero_padding_0_out, nvdla_cdma_d_zero_padding_0_out);
      (32'h50b8  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDMA_D_ZERO_PADDING_VALUE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdma_d_zero_padding_value_0_out, nvdla_cdma_d_zero_padding_value_0_out);
      default: begin
          if (arreggen_dump) $display("%t:%m: reg wr: Unknown register (0x%h) = 0x%h", $time, reg_offset, reg_wr_data);
          if (arreggen_abort_on_invalid_wr) begin $display("ERROR: write to undefined register!"); $finish; end
        end
    endcase
  end
end

// VCS coverage on
// synopsys translate_on

endmodule // NV_NVDLA_CDMA_dual_reg

