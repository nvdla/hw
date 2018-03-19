// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_REG_dual.v

module NV_NVDLA_CDP_REG_dual (
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
  ,input_data_type
  ,datin_offset
  ,datin_scale
  ,datin_shifter
  ,datout_offset
  ,datout_scale
  ,datout_shifter
  ,dst_base_addr_high
  ,dst_base_addr_low
  ,dst_ram_type
  ,dst_line_stride
  ,dst_surface_stride
  ,mul_bypass
  ,sqsum_bypass
  ,normalz_len
  ,nan_to_zero
  ,op_en_trigger
  ,dma_en
  ,lut_en
  ,inf_input_num
  ,nan_input_num
  ,nan_output_num
  ,op_en
  ,out_saturation
  ,perf_lut_hybrid
  ,perf_lut_le_hit
  ,perf_lut_lo_hit
  ,perf_lut_oflow
  ,perf_lut_uflow
  ,perf_write_stall
  );

wire          dst_compression_en;
wire   [31:0] nvdla_cdp_d_cya_0_out;
wire   [31:0] nvdla_cdp_d_data_format_0_out;
wire   [31:0] nvdla_cdp_d_datin_offset_0_out;
wire   [31:0] nvdla_cdp_d_datin_scale_0_out;
wire   [31:0] nvdla_cdp_d_datin_shifter_0_out;
wire   [31:0] nvdla_cdp_d_datout_offset_0_out;
wire   [31:0] nvdla_cdp_d_datout_scale_0_out;
wire   [31:0] nvdla_cdp_d_datout_shifter_0_out;
wire   [31:0] nvdla_cdp_d_dst_base_addr_high_0_out;
wire   [31:0] nvdla_cdp_d_dst_base_addr_low_0_out;
wire   [31:0] nvdla_cdp_d_dst_compression_en_0_out;
wire   [31:0] nvdla_cdp_d_dst_dma_cfg_0_out;
wire   [31:0] nvdla_cdp_d_dst_line_stride_0_out;
wire   [31:0] nvdla_cdp_d_dst_surface_stride_0_out;
wire   [31:0] nvdla_cdp_d_func_bypass_0_out;
wire   [31:0] nvdla_cdp_d_inf_input_num_0_out;
wire   [31:0] nvdla_cdp_d_lrn_cfg_0_out;
wire   [31:0] nvdla_cdp_d_nan_flush_to_zero_0_out;
wire   [31:0] nvdla_cdp_d_nan_input_num_0_out;
wire   [31:0] nvdla_cdp_d_nan_output_num_0_out;
wire   [31:0] nvdla_cdp_d_op_enable_0_out;
wire   [31:0] nvdla_cdp_d_out_saturation_0_out;
wire   [31:0] nvdla_cdp_d_perf_enable_0_out;
wire   [31:0] nvdla_cdp_d_perf_lut_hybrid_0_out;
wire   [31:0] nvdla_cdp_d_perf_lut_le_hit_0_out;
wire   [31:0] nvdla_cdp_d_perf_lut_lo_hit_0_out;
wire   [31:0] nvdla_cdp_d_perf_lut_oflow_0_out;
wire   [31:0] nvdla_cdp_d_perf_lut_uflow_0_out;
wire   [31:0] nvdla_cdp_d_perf_write_stall_0_out;
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
output [1:0]  input_data_type;
output [15:0] datin_offset;
output [15:0] datin_scale;
output [4:0]  datin_shifter;
output [31:0] datout_offset;
output [15:0] datout_scale;
output [5:0]  datout_shifter;
output [31:0] dst_base_addr_high;
output [31:0] dst_base_addr_low;
output        dst_ram_type;
output [31:0] dst_line_stride;
output [31:0] dst_surface_stride;
output        mul_bypass;
output        sqsum_bypass;
output [1:0]  normalz_len;
output        nan_to_zero;
output        op_en_trigger;
output        dma_en;
output        lut_en;

// Read-only register inputs
input [31:0]  inf_input_num;
input [31:0]  nan_input_num;
input [31:0]  nan_output_num;
input         op_en;
input [31:0]  out_saturation;
input [31:0]  perf_lut_hybrid;
input [31:0]  perf_lut_le_hit;
input [31:0]  perf_lut_lo_hit;
input [31:0]  perf_lut_oflow;
input [31:0]  perf_lut_uflow;
input [31:0]  perf_write_stall;

// wr_mask register inputs

// rstn register inputs

// leda FM_2_23 off
reg           arreggen_abort_on_invalid_wr;
reg           arreggen_abort_on_rowr;
reg           arreggen_dump;
// leda FM_2_23 on
reg    [31:0] cya;
reg    [15:0] datin_offset;
reg    [15:0] datin_scale;
reg     [4:0] datin_shifter;
reg    [31:0] datout_offset;
reg    [15:0] datout_scale;
reg     [5:0] datout_shifter;
reg           dma_en;
reg    [31:0] dst_base_addr_high;
reg    [31:0] dst_base_addr_low;
reg    [31:0] dst_line_stride;
reg           dst_ram_type;
reg    [31:0] dst_surface_stride;
reg     [1:0] input_data_type;
reg           lut_en;
reg           mul_bypass;
reg           nan_to_zero;
reg     [1:0] normalz_len;
reg    [31:0] reg_rd_data;
reg           sqsum_bypass;

assign reg_offset_wr = {20'b0 , reg_offset};
// SCR signals

// Address decode
wire nvdla_cdp_d_cya_0_wren = (reg_offset_wr == (32'hf0b8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_data_format_0_wren = (reg_offset_wr == (32'hf068  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_datin_offset_0_wren = (reg_offset_wr == (32'hf074  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_datin_scale_0_wren = (reg_offset_wr == (32'hf078  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_datin_shifter_0_wren = (reg_offset_wr == (32'hf07c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_datout_offset_0_wren = (reg_offset_wr == (32'hf080  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_datout_scale_0_wren = (reg_offset_wr == (32'hf084  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_datout_shifter_0_wren = (reg_offset_wr == (32'hf088  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_dst_base_addr_high_0_wren = (reg_offset_wr == (32'hf054  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_dst_base_addr_low_0_wren = (reg_offset_wr == (32'hf050  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_dst_compression_en_0_wren = (reg_offset_wr == (32'hf064  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_dst_dma_cfg_0_wren = (reg_offset_wr == (32'hf060  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_dst_line_stride_0_wren = (reg_offset_wr == (32'hf058  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_dst_surface_stride_0_wren = (reg_offset_wr == (32'hf05c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_func_bypass_0_wren = (reg_offset_wr == (32'hf04c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_inf_input_num_0_wren = (reg_offset_wr == (32'hf090  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_lrn_cfg_0_wren = (reg_offset_wr == (32'hf070  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_nan_flush_to_zero_0_wren = (reg_offset_wr == (32'hf06c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_nan_input_num_0_wren = (reg_offset_wr == (32'hf08c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_nan_output_num_0_wren = (reg_offset_wr == (32'hf094  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_op_enable_0_wren = (reg_offset_wr == (32'hf048  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_out_saturation_0_wren = (reg_offset_wr == (32'hf098  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_perf_enable_0_wren = (reg_offset_wr == (32'hf09c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_perf_lut_hybrid_0_wren = (reg_offset_wr == (32'hf0ac  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_perf_lut_le_hit_0_wren = (reg_offset_wr == (32'hf0b0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_perf_lut_lo_hit_0_wren = (reg_offset_wr == (32'hf0b4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_perf_lut_oflow_0_wren = (reg_offset_wr == (32'hf0a8  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_perf_lut_uflow_0_wren = (reg_offset_wr == (32'hf0a4  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_d_perf_write_stall_0_wren = (reg_offset_wr == (32'hf0a0  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)

assign dst_compression_en = 1'h0;
assign nvdla_cdp_d_cya_0_out[31:0] = { cya };
assign nvdla_cdp_d_data_format_0_out[31:0] = { 30'b0, input_data_type };
assign nvdla_cdp_d_datin_offset_0_out[31:0] = { 16'b0, datin_offset };
assign nvdla_cdp_d_datin_scale_0_out[31:0] = { 16'b0, datin_scale };
assign nvdla_cdp_d_datin_shifter_0_out[31:0] = { 27'b0, datin_shifter };
assign nvdla_cdp_d_datout_offset_0_out[31:0] = { datout_offset };
assign nvdla_cdp_d_datout_scale_0_out[31:0] = { 16'b0, datout_scale };
assign nvdla_cdp_d_datout_shifter_0_out[31:0] = { 26'b0, datout_shifter };
assign nvdla_cdp_d_dst_base_addr_high_0_out[31:0] = { dst_base_addr_high };
assign nvdla_cdp_d_dst_base_addr_low_0_out[31:0] = { dst_base_addr_low };
assign nvdla_cdp_d_dst_compression_en_0_out[31:0] = { 31'b0, dst_compression_en };
assign nvdla_cdp_d_dst_dma_cfg_0_out[31:0] = { 31'b0, dst_ram_type };
assign nvdla_cdp_d_dst_line_stride_0_out[31:0] = { dst_line_stride };
assign nvdla_cdp_d_dst_surface_stride_0_out[31:0] = { dst_surface_stride };
assign nvdla_cdp_d_func_bypass_0_out[31:0] = { 30'b0, mul_bypass, sqsum_bypass };
assign nvdla_cdp_d_inf_input_num_0_out[31:0] = { inf_input_num };
assign nvdla_cdp_d_lrn_cfg_0_out[31:0] = { 30'b0, normalz_len };
assign nvdla_cdp_d_nan_flush_to_zero_0_out[31:0] = { 31'b0, nan_to_zero };
assign nvdla_cdp_d_nan_input_num_0_out[31:0] = { nan_input_num };
assign nvdla_cdp_d_nan_output_num_0_out[31:0] = { nan_output_num };
assign nvdla_cdp_d_op_enable_0_out[31:0] = { 31'b0, op_en };
assign nvdla_cdp_d_out_saturation_0_out[31:0] = { out_saturation };
assign nvdla_cdp_d_perf_enable_0_out[31:0] = { 30'b0, lut_en, dma_en };
assign nvdla_cdp_d_perf_lut_hybrid_0_out[31:0] = { perf_lut_hybrid };
assign nvdla_cdp_d_perf_lut_le_hit_0_out[31:0] = { perf_lut_le_hit };
assign nvdla_cdp_d_perf_lut_lo_hit_0_out[31:0] = { perf_lut_lo_hit };
assign nvdla_cdp_d_perf_lut_oflow_0_out[31:0] = { perf_lut_oflow };
assign nvdla_cdp_d_perf_lut_uflow_0_out[31:0] = { perf_lut_uflow };
assign nvdla_cdp_d_perf_write_stall_0_out[31:0] = { perf_write_stall };

assign op_en_trigger = nvdla_cdp_d_op_enable_0_wren;  //(W563)

assign reg_offset_rd_int = reg_offset;
// Output mux
//spyglass disable_block W338, W263 
always @(
  reg_offset_rd_int
  or nvdla_cdp_d_cya_0_out
  or nvdla_cdp_d_data_format_0_out
  or nvdla_cdp_d_datin_offset_0_out
  or nvdla_cdp_d_datin_scale_0_out
  or nvdla_cdp_d_datin_shifter_0_out
  or nvdla_cdp_d_datout_offset_0_out
  or nvdla_cdp_d_datout_scale_0_out
  or nvdla_cdp_d_datout_shifter_0_out
  or nvdla_cdp_d_dst_base_addr_high_0_out
  or nvdla_cdp_d_dst_base_addr_low_0_out
  or nvdla_cdp_d_dst_compression_en_0_out
  or nvdla_cdp_d_dst_dma_cfg_0_out
  or nvdla_cdp_d_dst_line_stride_0_out
  or nvdla_cdp_d_dst_surface_stride_0_out
  or nvdla_cdp_d_func_bypass_0_out
  or nvdla_cdp_d_inf_input_num_0_out
  or nvdla_cdp_d_lrn_cfg_0_out
  or nvdla_cdp_d_nan_flush_to_zero_0_out
  or nvdla_cdp_d_nan_input_num_0_out
  or nvdla_cdp_d_nan_output_num_0_out
  or nvdla_cdp_d_op_enable_0_out
  or nvdla_cdp_d_out_saturation_0_out
  or nvdla_cdp_d_perf_enable_0_out
  or nvdla_cdp_d_perf_lut_hybrid_0_out
  or nvdla_cdp_d_perf_lut_le_hit_0_out
  or nvdla_cdp_d_perf_lut_lo_hit_0_out
  or nvdla_cdp_d_perf_lut_oflow_0_out
  or nvdla_cdp_d_perf_lut_uflow_0_out
  or nvdla_cdp_d_perf_write_stall_0_out
  ) begin
  case (reg_offset_rd_int)
     (32'hf0b8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_cya_0_out ;
                            end 
     (32'hf068  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_data_format_0_out ;
                            end 
     (32'hf074  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_datin_offset_0_out ;
                            end 
     (32'hf078  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_datin_scale_0_out ;
                            end 
     (32'hf07c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_datin_shifter_0_out ;
                            end 
     (32'hf080  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_datout_offset_0_out ;
                            end 
     (32'hf084  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_datout_scale_0_out ;
                            end 
     (32'hf088  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_datout_shifter_0_out ;
                            end 
     (32'hf054  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_dst_base_addr_high_0_out ;
                            end 
     (32'hf050  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_dst_base_addr_low_0_out ;
                            end 
     (32'hf064  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_dst_compression_en_0_out ;
                            end 
     (32'hf060  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_dst_dma_cfg_0_out ;
                            end 
     (32'hf058  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_dst_line_stride_0_out ;
                            end 
     (32'hf05c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_dst_surface_stride_0_out ;
                            end 
     (32'hf04c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_func_bypass_0_out ;
                            end 
     (32'hf090  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_inf_input_num_0_out ;
                            end 
     (32'hf070  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_lrn_cfg_0_out ;
                            end 
     (32'hf06c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_nan_flush_to_zero_0_out ;
                            end 
     (32'hf08c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_nan_input_num_0_out ;
                            end 
     (32'hf094  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_nan_output_num_0_out ;
                            end 
     (32'hf048  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_op_enable_0_out ;
                            end 
     (32'hf098  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_out_saturation_0_out ;
                            end 
     (32'hf09c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_perf_enable_0_out ;
                            end 
     (32'hf0ac  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_perf_lut_hybrid_0_out ;
                            end 
     (32'hf0b0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_perf_lut_le_hit_0_out ;
                            end 
     (32'hf0b4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_perf_lut_lo_hit_0_out ;
                            end 
     (32'hf0a8  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_perf_lut_oflow_0_out ;
                            end 
     (32'hf0a4  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_perf_lut_uflow_0_out ;
                            end 
     (32'hf0a0  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_d_perf_write_stall_0_out ;
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
    input_data_type[1:0] <= 2'b01;
    datin_offset[15:0] <= 16'b0000000000000000;
    datin_scale[15:0] <= 16'b0000000000000001;
    datin_shifter[4:0] <= 5'b00000;
    datout_offset[31:0] <= 32'b00000000000000000000000000000000;
    datout_scale[15:0] <= 16'b0000000000000001;
    datout_shifter[5:0] <= 6'b000000;
    dst_base_addr_high[31:0] <= 32'b00000000000000000000000000000000;
    dst_base_addr_low[31:0] <= 32'b00000000000000000000000000000000;
    dst_ram_type <= 1'b0;
    dst_line_stride[31:0] <= 32'b00000000000000000000000000000000;
    dst_surface_stride[31:0] <= 32'b00000000000000000000000000000000;
    mul_bypass <= 1'b0;
    sqsum_bypass <= 1'b0;
    normalz_len[1:0] <= 2'b00;
    nan_to_zero <= 1'b0;
    dma_en <= 1'b0;
    lut_en <= 1'b0;
  end else begin
  // Register: NVDLA_CDP_D_CYA_0    Field: cya
  if (nvdla_cdp_d_cya_0_wren) begin
    cya[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_D_DATA_FORMAT_0    Field: input_data_type
  if (nvdla_cdp_d_data_format_0_wren) begin
    input_data_type[1:0] <= reg_wr_data[1:0];
  end

  // Register: NVDLA_CDP_D_DATIN_OFFSET_0    Field: datin_offset
  if (nvdla_cdp_d_datin_offset_0_wren) begin
    datin_offset[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_CDP_D_DATIN_SCALE_0    Field: datin_scale
  if (nvdla_cdp_d_datin_scale_0_wren) begin
    datin_scale[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_CDP_D_DATIN_SHIFTER_0    Field: datin_shifter
  if (nvdla_cdp_d_datin_shifter_0_wren) begin
    datin_shifter[4:0] <= reg_wr_data[4:0];
  end

  // Register: NVDLA_CDP_D_DATOUT_OFFSET_0    Field: datout_offset
  if (nvdla_cdp_d_datout_offset_0_wren) begin
    datout_offset[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_D_DATOUT_SCALE_0    Field: datout_scale
  if (nvdla_cdp_d_datout_scale_0_wren) begin
    datout_scale[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_CDP_D_DATOUT_SHIFTER_0    Field: datout_shifter
  if (nvdla_cdp_d_datout_shifter_0_wren) begin
    datout_shifter[5:0] <= reg_wr_data[5:0];
  end

  // Register: NVDLA_CDP_D_DST_BASE_ADDR_HIGH_0    Field: dst_base_addr_high
  if (nvdla_cdp_d_dst_base_addr_high_0_wren) begin
    dst_base_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_D_DST_BASE_ADDR_LOW_0    Field: dst_base_addr_low
  if (nvdla_cdp_d_dst_base_addr_low_0_wren) begin
    dst_base_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Not generating flops for constant field NVDLA_CDP_D_DST_COMPRESSION_EN_0::dst_compression_en

  // Register: NVDLA_CDP_D_DST_DMA_CFG_0    Field: dst_ram_type
  if (nvdla_cdp_d_dst_dma_cfg_0_wren) begin
    dst_ram_type <= reg_wr_data[0];
  end

  // Register: NVDLA_CDP_D_DST_LINE_STRIDE_0    Field: dst_line_stride
  if (nvdla_cdp_d_dst_line_stride_0_wren) begin
    dst_line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_D_DST_SURFACE_STRIDE_0    Field: dst_surface_stride
  if (nvdla_cdp_d_dst_surface_stride_0_wren) begin
    dst_surface_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_D_FUNC_BYPASS_0    Field: mul_bypass
  if (nvdla_cdp_d_func_bypass_0_wren) begin
    mul_bypass <= reg_wr_data[1];
  end

  // Register: NVDLA_CDP_D_FUNC_BYPASS_0    Field: sqsum_bypass
  if (nvdla_cdp_d_func_bypass_0_wren) begin
    sqsum_bypass <= reg_wr_data[0];
  end

  // Not generating flops for read-only field NVDLA_CDP_D_INF_INPUT_NUM_0::inf_input_num

  // Register: NVDLA_CDP_D_LRN_CFG_0    Field: normalz_len
  if (nvdla_cdp_d_lrn_cfg_0_wren) begin
    normalz_len[1:0] <= reg_wr_data[1:0];
  end

  // Register: NVDLA_CDP_D_NAN_FLUSH_TO_ZERO_0    Field: nan_to_zero
  if (nvdla_cdp_d_nan_flush_to_zero_0_wren) begin
    nan_to_zero <= reg_wr_data[0];
  end

  // Not generating flops for read-only field NVDLA_CDP_D_NAN_INPUT_NUM_0::nan_input_num

  // Not generating flops for read-only field NVDLA_CDP_D_NAN_OUTPUT_NUM_0::nan_output_num

  // Not generating flops for field NVDLA_CDP_D_OP_ENABLE_0::op_en (to be implemented outside)

  // Not generating flops for read-only field NVDLA_CDP_D_OUT_SATURATION_0::out_saturation

  // Register: NVDLA_CDP_D_PERF_ENABLE_0    Field: dma_en
  if (nvdla_cdp_d_perf_enable_0_wren) begin
    dma_en <= reg_wr_data[0];
  end

  // Register: NVDLA_CDP_D_PERF_ENABLE_0    Field: lut_en
  if (nvdla_cdp_d_perf_enable_0_wren) begin
    lut_en <= reg_wr_data[1];
  end

  // Not generating flops for read-only field NVDLA_CDP_D_PERF_LUT_HYBRID_0::perf_lut_hybrid

  // Not generating flops for read-only field NVDLA_CDP_D_PERF_LUT_LE_HIT_0::perf_lut_le_hit

  // Not generating flops for read-only field NVDLA_CDP_D_PERF_LUT_LO_HIT_0::perf_lut_lo_hit

  // Not generating flops for read-only field NVDLA_CDP_D_PERF_LUT_OFLOW_0::perf_lut_oflow

  // Not generating flops for read-only field NVDLA_CDP_D_PERF_LUT_UFLOW_0::perf_lut_uflow

  // Not generating flops for read-only field NVDLA_CDP_D_PERF_WRITE_STALL_0::perf_write_stall

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
      (32'hf0b8  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_CYA_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_cya_0_out, nvdla_cdp_d_cya_0_out);
      (32'hf068  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DATA_FORMAT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_data_format_0_out, nvdla_cdp_d_data_format_0_out);
      (32'hf074  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DATIN_OFFSET_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_datin_offset_0_out, nvdla_cdp_d_datin_offset_0_out);
      (32'hf078  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DATIN_SCALE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_datin_scale_0_out, nvdla_cdp_d_datin_scale_0_out);
      (32'hf07c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DATIN_SHIFTER_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_datin_shifter_0_out, nvdla_cdp_d_datin_shifter_0_out);
      (32'hf080  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DATOUT_OFFSET_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_datout_offset_0_out, nvdla_cdp_d_datout_offset_0_out);
      (32'hf084  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DATOUT_SCALE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_datout_scale_0_out, nvdla_cdp_d_datout_scale_0_out);
      (32'hf088  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DATOUT_SHIFTER_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_datout_shifter_0_out, nvdla_cdp_d_datout_shifter_0_out);
      (32'hf054  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DST_BASE_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_dst_base_addr_high_0_out, nvdla_cdp_d_dst_base_addr_high_0_out);
      (32'hf050  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DST_BASE_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_dst_base_addr_low_0_out, nvdla_cdp_d_dst_base_addr_low_0_out);
      (32'hf064  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_DST_COMPRESSION_EN_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hf060  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DST_DMA_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_dst_dma_cfg_0_out, nvdla_cdp_d_dst_dma_cfg_0_out);
      (32'hf058  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DST_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_dst_line_stride_0_out, nvdla_cdp_d_dst_line_stride_0_out);
      (32'hf05c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_DST_SURFACE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_dst_surface_stride_0_out, nvdla_cdp_d_dst_surface_stride_0_out);
      (32'hf04c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_FUNC_BYPASS_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_func_bypass_0_out, nvdla_cdp_d_func_bypass_0_out);
      (32'hf090  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_INF_INPUT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hf070  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_LRN_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_lrn_cfg_0_out, nvdla_cdp_d_lrn_cfg_0_out);
      (32'hf06c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_NAN_FLUSH_TO_ZERO_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_nan_flush_to_zero_0_out, nvdla_cdp_d_nan_flush_to_zero_0_out);
      (32'hf08c  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_NAN_INPUT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hf094  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_NAN_OUTPUT_NUM_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hf048  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_OP_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_op_enable_0_out, nvdla_cdp_d_op_enable_0_out);
      (32'hf098  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_OUT_SATURATION_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hf09c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_D_PERF_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_d_perf_enable_0_out, nvdla_cdp_d_perf_enable_0_out);
      (32'hf0ac  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_PERF_LUT_HYBRID_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hf0b0  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_PERF_LUT_LE_HIT_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hf0b4  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_PERF_LUT_LO_HIT_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hf0a8  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_PERF_LUT_OFLOW_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hf0a4  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_PERF_LUT_UFLOW_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'hf0a0  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_D_PERF_WRITE_STALL_0 = 0x%h", $time, reg_wr_data);
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

endmodule // NV_NVDLA_CDP_REG_dual

