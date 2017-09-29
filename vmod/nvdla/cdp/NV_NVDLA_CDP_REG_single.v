// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_REG_single.v

module NV_NVDLA_CDP_REG_single (
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
  ,lut_access_type
  ,lut_addr_trigger
  ,lut_table_id
  ,lut_data_trigger
  ,lut_hybrid_priority
  ,lut_le_function
  ,lut_oflow_priority
  ,lut_uflow_priority
  ,lut_le_index_offset
  ,lut_le_index_select
  ,lut_lo_index_select
  ,lut_le_end_high
  ,lut_le_end_low
  ,lut_le_slope_oflow_scale
  ,lut_le_slope_uflow_scale
  ,lut_le_slope_oflow_shift
  ,lut_le_slope_uflow_shift
  ,lut_le_start_high
  ,lut_le_start_low
  ,lut_lo_end_high
  ,lut_lo_end_low
  ,lut_lo_slope_oflow_scale
  ,lut_lo_slope_uflow_scale
  ,lut_lo_slope_oflow_shift
  ,lut_lo_slope_uflow_shift
  ,lut_lo_start_high
  ,lut_lo_start_low
  ,producer
  ,lut_addr
  ,lut_data
  ,consumer
  ,status_0
  ,status_1
  );

wire   [31:0] nvdla_cdp_s_lut_access_cfg_0_out;
wire   [31:0] nvdla_cdp_s_lut_access_data_0_out;
wire   [31:0] nvdla_cdp_s_lut_cfg_0_out;
wire   [31:0] nvdla_cdp_s_lut_info_0_out;
wire   [31:0] nvdla_cdp_s_lut_le_end_high_0_out;
wire   [31:0] nvdla_cdp_s_lut_le_end_low_0_out;
wire   [31:0] nvdla_cdp_s_lut_le_slope_scale_0_out;
wire   [31:0] nvdla_cdp_s_lut_le_slope_shift_0_out;
wire   [31:0] nvdla_cdp_s_lut_le_start_high_0_out;
wire   [31:0] nvdla_cdp_s_lut_le_start_low_0_out;
wire   [31:0] nvdla_cdp_s_lut_lo_end_high_0_out;
wire   [31:0] nvdla_cdp_s_lut_lo_end_low_0_out;
wire   [31:0] nvdla_cdp_s_lut_lo_slope_scale_0_out;
wire   [31:0] nvdla_cdp_s_lut_lo_slope_shift_0_out;
wire   [31:0] nvdla_cdp_s_lut_lo_start_high_0_out;
wire   [31:0] nvdla_cdp_s_lut_lo_start_low_0_out;
wire   [31:0] nvdla_cdp_s_pointer_0_out;
wire   [31:0] nvdla_cdp_s_status_0_out;
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
output        lut_access_type;
output        lut_addr_trigger;
output        lut_table_id;
output        lut_data_trigger;
output        lut_hybrid_priority;
output        lut_le_function;
output        lut_oflow_priority;
output        lut_uflow_priority;
output [7:0]  lut_le_index_offset;
output [7:0]  lut_le_index_select;
output [7:0]  lut_lo_index_select;
output [5:0]  lut_le_end_high;
output [31:0] lut_le_end_low;
output [15:0] lut_le_slope_oflow_scale;
output [15:0] lut_le_slope_uflow_scale;
output [4:0]  lut_le_slope_oflow_shift;
output [4:0]  lut_le_slope_uflow_shift;
output [5:0]  lut_le_start_high;
output [31:0] lut_le_start_low;
output [5:0]  lut_lo_end_high;
output [31:0] lut_lo_end_low;
output [15:0] lut_lo_slope_oflow_scale;
output [15:0] lut_lo_slope_uflow_scale;
output [4:0]  lut_lo_slope_oflow_shift;
output [4:0]  lut_lo_slope_uflow_shift;
output [5:0]  lut_lo_start_high;
output [31:0] lut_lo_start_low;
output        producer;

// Read-only register inputs
input [9:0]   lut_addr;
input [15:0]  lut_data;
input         consumer;
input [1:0]   status_0;
input [1:0]   status_1;

// wr_mask register inputs

// rstn register inputs

// leda FM_2_23 off
reg           arreggen_abort_on_invalid_wr;
reg           arreggen_abort_on_rowr;
reg           arreggen_dump;
// leda FM_2_23 on
reg           lut_access_type;
reg           lut_hybrid_priority;
reg     [5:0] lut_le_end_high;
reg    [31:0] lut_le_end_low;
reg           lut_le_function;
reg     [7:0] lut_le_index_offset;
reg     [7:0] lut_le_index_select;
reg    [15:0] lut_le_slope_oflow_scale;
reg     [4:0] lut_le_slope_oflow_shift;
reg    [15:0] lut_le_slope_uflow_scale;
reg     [4:0] lut_le_slope_uflow_shift;
reg     [5:0] lut_le_start_high;
reg    [31:0] lut_le_start_low;
reg     [5:0] lut_lo_end_high;
reg    [31:0] lut_lo_end_low;
reg     [7:0] lut_lo_index_select;
reg    [15:0] lut_lo_slope_oflow_scale;
reg     [4:0] lut_lo_slope_oflow_shift;
reg    [15:0] lut_lo_slope_uflow_scale;
reg     [4:0] lut_lo_slope_uflow_shift;
reg     [5:0] lut_lo_start_high;
reg    [31:0] lut_lo_start_low;
reg           lut_oflow_priority;
reg           lut_table_id;
reg           lut_uflow_priority;
reg           producer;
reg    [31:0] reg_rd_data;

assign reg_offset_wr = {20'b0 , reg_offset};
// SCR signals

// Address decode
wire nvdla_cdp_s_lut_access_cfg_0_wren = (reg_offset_wr == (32'hf008  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_access_data_0_wren = (reg_offset_wr == (32'hf00c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_cfg_0_wren = (reg_offset_wr == (32'hf010  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_info_0_wren = (reg_offset_wr == (32'hf014  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_le_end_high_0_wren = (reg_offset_wr == (32'hf024  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_le_end_low_0_wren = (reg_offset_wr == (32'hf020  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_le_slope_scale_0_wren = (reg_offset_wr == (32'hf038  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_le_slope_shift_0_wren = (reg_offset_wr == (32'hf03c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_le_start_high_0_wren = (reg_offset_wr == (32'hf01c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_le_start_low_0_wren = (reg_offset_wr == (32'hf018  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_lo_end_high_0_wren = (reg_offset_wr == (32'hf034  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_lo_end_low_0_wren = (reg_offset_wr == (32'hf030  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_lo_slope_scale_0_wren = (reg_offset_wr == (32'hf040  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_lo_slope_shift_0_wren = (reg_offset_wr == (32'hf044  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_lo_start_high_0_wren = (reg_offset_wr == (32'hf02c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_lut_lo_start_low_0_wren = (reg_offset_wr == (32'hf028  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_pointer_0_wren = (reg_offset_wr == (32'hf004  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_s_status_0_wren = (reg_offset_wr == (32'hf000  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)

assign nvdla_cdp_s_lut_access_cfg_0_out[31:0] = { 14'b0, lut_access_type, lut_table_id, 6'b0, lut_addr };
assign nvdla_cdp_s_lut_access_data_0_out[31:0] = { 16'b0, lut_data };
assign nvdla_cdp_s_lut_cfg_0_out[31:0] = { 25'b0, lut_hybrid_priority, lut_oflow_priority, lut_uflow_priority, 3'b0, lut_le_function };
assign nvdla_cdp_s_lut_info_0_out[31:0] = { 8'b0, lut_lo_index_select, lut_le_index_select, lut_le_index_offset };
assign nvdla_cdp_s_lut_le_end_high_0_out[31:0] = { 26'b0, lut_le_end_high };
assign nvdla_cdp_s_lut_le_end_low_0_out[31:0] = { lut_le_end_low };
assign nvdla_cdp_s_lut_le_slope_scale_0_out[31:0] = { lut_le_slope_oflow_scale, lut_le_slope_uflow_scale };
assign nvdla_cdp_s_lut_le_slope_shift_0_out[31:0] = { 22'b0, lut_le_slope_oflow_shift, lut_le_slope_uflow_shift };
assign nvdla_cdp_s_lut_le_start_high_0_out[31:0] = { 26'b0, lut_le_start_high };
assign nvdla_cdp_s_lut_le_start_low_0_out[31:0] = { lut_le_start_low };
assign nvdla_cdp_s_lut_lo_end_high_0_out[31:0] = { 26'b0, lut_lo_end_high };
assign nvdla_cdp_s_lut_lo_end_low_0_out[31:0] = { lut_lo_end_low };
assign nvdla_cdp_s_lut_lo_slope_scale_0_out[31:0] = { lut_lo_slope_oflow_scale, lut_lo_slope_uflow_scale };
assign nvdla_cdp_s_lut_lo_slope_shift_0_out[31:0] = { 22'b0, lut_lo_slope_oflow_shift, lut_lo_slope_uflow_shift };
assign nvdla_cdp_s_lut_lo_start_high_0_out[31:0] = { 26'b0, lut_lo_start_high };
assign nvdla_cdp_s_lut_lo_start_low_0_out[31:0] = { lut_lo_start_low };
assign nvdla_cdp_s_pointer_0_out[31:0] = { 15'b0, consumer, 15'b0, producer };
assign nvdla_cdp_s_status_0_out[31:0] = { 14'b0, status_1, 14'b0, status_0 };

assign lut_addr_trigger = nvdla_cdp_s_lut_access_cfg_0_wren;  //(W563)
assign lut_data_trigger = nvdla_cdp_s_lut_access_data_0_wren;  //(W563)

assign reg_offset_rd_int = reg_offset;
// Output mux
//spyglass disable_block W338, W263 
always @(
  reg_offset_rd_int
  or nvdla_cdp_s_lut_access_cfg_0_out
  or nvdla_cdp_s_lut_access_data_0_out
  or nvdla_cdp_s_lut_cfg_0_out
  or nvdla_cdp_s_lut_info_0_out
  or nvdla_cdp_s_lut_le_end_high_0_out
  or nvdla_cdp_s_lut_le_end_low_0_out
  or nvdla_cdp_s_lut_le_slope_scale_0_out
  or nvdla_cdp_s_lut_le_slope_shift_0_out
  or nvdla_cdp_s_lut_le_start_high_0_out
  or nvdla_cdp_s_lut_le_start_low_0_out
  or nvdla_cdp_s_lut_lo_end_high_0_out
  or nvdla_cdp_s_lut_lo_end_low_0_out
  or nvdla_cdp_s_lut_lo_slope_scale_0_out
  or nvdla_cdp_s_lut_lo_slope_shift_0_out
  or nvdla_cdp_s_lut_lo_start_high_0_out
  or nvdla_cdp_s_lut_lo_start_low_0_out
  or nvdla_cdp_s_pointer_0_out
  or nvdla_cdp_s_status_0_out
  ) begin
  case (reg_offset_rd_int)
     (32'hf008  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_access_cfg_0_out ;
                            end 
     (32'hf00c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_access_data_0_out ;
                            end 
     (32'hf010  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_cfg_0_out ;
                            end 
     (32'hf014  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_info_0_out ;
                            end 
     (32'hf024  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_le_end_high_0_out ;
                            end 
     (32'hf020  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_le_end_low_0_out ;
                            end 
     (32'hf038  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_le_slope_scale_0_out ;
                            end 
     (32'hf03c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_le_slope_shift_0_out ;
                            end 
     (32'hf01c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_le_start_high_0_out ;
                            end 
     (32'hf018  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_le_start_low_0_out ;
                            end 
     (32'hf034  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_lo_end_high_0_out ;
                            end 
     (32'hf030  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_lo_end_low_0_out ;
                            end 
     (32'hf040  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_lo_slope_scale_0_out ;
                            end 
     (32'hf044  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_lo_slope_shift_0_out ;
                            end 
     (32'hf02c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_lo_start_high_0_out ;
                            end 
     (32'hf028  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_lut_lo_start_low_0_out ;
                            end 
     (32'hf004  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_pointer_0_out ;
                            end 
     (32'hf000  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_s_status_0_out ;
                            end 
    default: reg_rd_data = {32{1'b0}};
  endcase
end

//spyglass enable_block W338, W263

// spyglass disable_block STARC-2.10.1.6, NoConstWithXZ, W443

// Register flop declarations
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_access_type <= 1'b0;
    lut_table_id <= 1'b0;
    lut_hybrid_priority <= 1'b0;
    lut_le_function <= 1'b0;
    lut_oflow_priority <= 1'b0;
    lut_uflow_priority <= 1'b0;
    lut_le_index_offset[7:0] <= 8'b00000000;
    lut_le_index_select[7:0] <= 8'b00000000;
    lut_lo_index_select[7:0] <= 8'b00000000;
    lut_le_end_high[5:0] <= 6'b000000;
    lut_le_end_low[31:0] <= 32'b00000000000000000000000000000000;
    lut_le_slope_oflow_scale[15:0] <= 16'b0000000000000000;
    lut_le_slope_uflow_scale[15:0] <= 16'b0000000000000000;
    lut_le_slope_oflow_shift[4:0] <= 5'b00000;
    lut_le_slope_uflow_shift[4:0] <= 5'b00000;
    lut_le_start_high[5:0] <= 6'b000000;
    lut_le_start_low[31:0] <= 32'b00000000000000000000000000000000;
    lut_lo_end_high[5:0] <= 6'b000000;
    lut_lo_end_low[31:0] <= 32'b00000000000000000000000000000000;
    lut_lo_slope_oflow_scale[15:0] <= 16'b0000000000000000;
    lut_lo_slope_uflow_scale[15:0] <= 16'b0000000000000000;
    lut_lo_slope_oflow_shift[4:0] <= 5'b00000;
    lut_lo_slope_uflow_shift[4:0] <= 5'b00000;
    lut_lo_start_high[5:0] <= 6'b000000;
    lut_lo_start_low[31:0] <= 32'b00000000000000000000000000000000;
    producer <= 1'b0;
  end else begin
  // Register: NVDLA_CDP_S_LUT_ACCESS_CFG_0    Field: lut_access_type
  if (nvdla_cdp_s_lut_access_cfg_0_wren) begin
    lut_access_type <= reg_wr_data[17];
  end

  // Not generating flops for field NVDLA_CDP_S_LUT_ACCESS_CFG_0::lut_addr (to be implemented outside)

  // Register: NVDLA_CDP_S_LUT_ACCESS_CFG_0    Field: lut_table_id
  if (nvdla_cdp_s_lut_access_cfg_0_wren) begin
    lut_table_id <= reg_wr_data[16];
  end

  // Not generating flops for field NVDLA_CDP_S_LUT_ACCESS_DATA_0::lut_data (to be implemented outside)

  // Register: NVDLA_CDP_S_LUT_CFG_0    Field: lut_hybrid_priority
  if (nvdla_cdp_s_lut_cfg_0_wren) begin
    lut_hybrid_priority <= reg_wr_data[6];
  end

  // Register: NVDLA_CDP_S_LUT_CFG_0    Field: lut_le_function
  if (nvdla_cdp_s_lut_cfg_0_wren) begin
    lut_le_function <= reg_wr_data[0];
  end

  // Register: NVDLA_CDP_S_LUT_CFG_0    Field: lut_oflow_priority
  if (nvdla_cdp_s_lut_cfg_0_wren) begin
    lut_oflow_priority <= reg_wr_data[5];
  end

  // Register: NVDLA_CDP_S_LUT_CFG_0    Field: lut_uflow_priority
  if (nvdla_cdp_s_lut_cfg_0_wren) begin
    lut_uflow_priority <= reg_wr_data[4];
  end

  // Register: NVDLA_CDP_S_LUT_INFO_0    Field: lut_le_index_offset
  if (nvdla_cdp_s_lut_info_0_wren) begin
    lut_le_index_offset[7:0] <= reg_wr_data[7:0];
  end

  // Register: NVDLA_CDP_S_LUT_INFO_0    Field: lut_le_index_select
  if (nvdla_cdp_s_lut_info_0_wren) begin
    lut_le_index_select[7:0] <= reg_wr_data[15:8];
  end

  // Register: NVDLA_CDP_S_LUT_INFO_0    Field: lut_lo_index_select
  if (nvdla_cdp_s_lut_info_0_wren) begin
    lut_lo_index_select[7:0] <= reg_wr_data[23:16];
  end

  // Register: NVDLA_CDP_S_LUT_LE_END_HIGH_0    Field: lut_le_end_high
  if (nvdla_cdp_s_lut_le_end_high_0_wren) begin
    lut_le_end_high[5:0] <= reg_wr_data[5:0];
  end

  // Register: NVDLA_CDP_S_LUT_LE_END_LOW_0    Field: lut_le_end_low
  if (nvdla_cdp_s_lut_le_end_low_0_wren) begin
    lut_le_end_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_S_LUT_LE_SLOPE_SCALE_0    Field: lut_le_slope_oflow_scale
  if (nvdla_cdp_s_lut_le_slope_scale_0_wren) begin
    lut_le_slope_oflow_scale[15:0] <= reg_wr_data[31:16];
  end

  // Register: NVDLA_CDP_S_LUT_LE_SLOPE_SCALE_0    Field: lut_le_slope_uflow_scale
  if (nvdla_cdp_s_lut_le_slope_scale_0_wren) begin
    lut_le_slope_uflow_scale[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_CDP_S_LUT_LE_SLOPE_SHIFT_0    Field: lut_le_slope_oflow_shift
  if (nvdla_cdp_s_lut_le_slope_shift_0_wren) begin
    lut_le_slope_oflow_shift[4:0] <= reg_wr_data[9:5];
  end

  // Register: NVDLA_CDP_S_LUT_LE_SLOPE_SHIFT_0    Field: lut_le_slope_uflow_shift
  if (nvdla_cdp_s_lut_le_slope_shift_0_wren) begin
    lut_le_slope_uflow_shift[4:0] <= reg_wr_data[4:0];
  end

  // Register: NVDLA_CDP_S_LUT_LE_START_HIGH_0    Field: lut_le_start_high
  if (nvdla_cdp_s_lut_le_start_high_0_wren) begin
    lut_le_start_high[5:0] <= reg_wr_data[5:0];
  end

  // Register: NVDLA_CDP_S_LUT_LE_START_LOW_0    Field: lut_le_start_low
  if (nvdla_cdp_s_lut_le_start_low_0_wren) begin
    lut_le_start_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_S_LUT_LO_END_HIGH_0    Field: lut_lo_end_high
  if (nvdla_cdp_s_lut_lo_end_high_0_wren) begin
    lut_lo_end_high[5:0] <= reg_wr_data[5:0];
  end

  // Register: NVDLA_CDP_S_LUT_LO_END_LOW_0    Field: lut_lo_end_low
  if (nvdla_cdp_s_lut_lo_end_low_0_wren) begin
    lut_lo_end_low[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_S_LUT_LO_SLOPE_SCALE_0    Field: lut_lo_slope_oflow_scale
  if (nvdla_cdp_s_lut_lo_slope_scale_0_wren) begin
    lut_lo_slope_oflow_scale[15:0] <= reg_wr_data[31:16];
  end

  // Register: NVDLA_CDP_S_LUT_LO_SLOPE_SCALE_0    Field: lut_lo_slope_uflow_scale
  if (nvdla_cdp_s_lut_lo_slope_scale_0_wren) begin
    lut_lo_slope_uflow_scale[15:0] <= reg_wr_data[15:0];
  end

  // Register: NVDLA_CDP_S_LUT_LO_SLOPE_SHIFT_0    Field: lut_lo_slope_oflow_shift
  if (nvdla_cdp_s_lut_lo_slope_shift_0_wren) begin
    lut_lo_slope_oflow_shift[4:0] <= reg_wr_data[9:5];
  end

  // Register: NVDLA_CDP_S_LUT_LO_SLOPE_SHIFT_0    Field: lut_lo_slope_uflow_shift
  if (nvdla_cdp_s_lut_lo_slope_shift_0_wren) begin
    lut_lo_slope_uflow_shift[4:0] <= reg_wr_data[4:0];
  end

  // Register: NVDLA_CDP_S_LUT_LO_START_HIGH_0    Field: lut_lo_start_high
  if (nvdla_cdp_s_lut_lo_start_high_0_wren) begin
    lut_lo_start_high[5:0] <= reg_wr_data[5:0];
  end

  // Register: NVDLA_CDP_S_LUT_LO_START_LOW_0    Field: lut_lo_start_low
  if (nvdla_cdp_s_lut_lo_start_low_0_wren) begin
    lut_lo_start_low[31:0] <= reg_wr_data[31:0];
  end

  // Not generating flops for read-only field NVDLA_CDP_S_POINTER_0::consumer

  // Register: NVDLA_CDP_S_POINTER_0    Field: producer
  if (nvdla_cdp_s_pointer_0_wren) begin
    producer <= reg_wr_data[0];
  end

  // Not generating flops for read-only field NVDLA_CDP_S_STATUS_0::status_0

  // Not generating flops for read-only field NVDLA_CDP_S_STATUS_0::status_1

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
      (32'hf008  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_ACCESS_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_access_cfg_0_out, nvdla_cdp_s_lut_access_cfg_0_out);
      (32'hf00c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_ACCESS_DATA_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_access_data_0_out, nvdla_cdp_s_lut_access_data_0_out);
      (32'hf010  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_cfg_0_out, nvdla_cdp_s_lut_cfg_0_out);
      (32'hf014  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_INFO_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_info_0_out, nvdla_cdp_s_lut_info_0_out);
      (32'hf024  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LE_END_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_le_end_high_0_out, nvdla_cdp_s_lut_le_end_high_0_out);
      (32'hf020  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LE_END_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_le_end_low_0_out, nvdla_cdp_s_lut_le_end_low_0_out);
      (32'hf038  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LE_SLOPE_SCALE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_le_slope_scale_0_out, nvdla_cdp_s_lut_le_slope_scale_0_out);
      (32'hf03c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LE_SLOPE_SHIFT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_le_slope_shift_0_out, nvdla_cdp_s_lut_le_slope_shift_0_out);
      (32'hf01c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LE_START_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_le_start_high_0_out, nvdla_cdp_s_lut_le_start_high_0_out);
      (32'hf018  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LE_START_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_le_start_low_0_out, nvdla_cdp_s_lut_le_start_low_0_out);
      (32'hf034  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LO_END_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_lo_end_high_0_out, nvdla_cdp_s_lut_lo_end_high_0_out);
      (32'hf030  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LO_END_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_lo_end_low_0_out, nvdla_cdp_s_lut_lo_end_low_0_out);
      (32'hf040  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LO_SLOPE_SCALE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_lo_slope_scale_0_out, nvdla_cdp_s_lut_lo_slope_scale_0_out);
      (32'hf044  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LO_SLOPE_SHIFT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_lo_slope_shift_0_out, nvdla_cdp_s_lut_lo_slope_shift_0_out);
      (32'hf02c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LO_START_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_lo_start_high_0_out, nvdla_cdp_s_lut_lo_start_high_0_out);
      (32'hf028  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_LUT_LO_START_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_lut_lo_start_low_0_out, nvdla_cdp_s_lut_lo_start_low_0_out);
      (32'hf004  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_S_POINTER_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_s_pointer_0_out, nvdla_cdp_s_pointer_0_out);
      (32'hf000  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_S_STATUS_0 = 0x%h", $time, reg_wr_data);
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

endmodule // NV_NVDLA_CDP_REG_single

