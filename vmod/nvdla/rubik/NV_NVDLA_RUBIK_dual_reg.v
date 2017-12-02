// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RUBIK_dual_reg.v

module NV_NVDLA_RUBIK_dual_reg (
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
  ,contract_stride_0
  ,contract_stride_1
  ,dain_addr_high
  ,dain_addr_low
  ,dain_line_stride
  ,dain_planar_stride
  ,datain_ram_type
  ,dain_surf_stride
  ,daout_addr_high
  ,daout_addr_low
  ,daout_line_stride
  ,daout_planar_stride
  ,dataout_ram_type
  ,daout_surf_stride
  ,datain_height
  ,datain_width
  ,datain_channel
  ,dataout_channel
  ,deconv_x_stride
  ,deconv_y_stride
  ,in_precision
  ,rubik_mode
  ,op_en_trigger
  ,perf_en
  ,op_en
  ,rd_stall_cnt
  ,wr_stall_cnt
  );

wire   [31:0] nvdla_rbk_d_contract_stride_0_0_out;
wire   [31:0] nvdla_rbk_d_contract_stride_1_0_out;
wire   [31:0] nvdla_rbk_d_dain_addr_high_0_out;
wire   [31:0] nvdla_rbk_d_dain_addr_low_0_out;
wire   [31:0] nvdla_rbk_d_dain_line_stride_0_out;
wire   [31:0] nvdla_rbk_d_dain_planar_stride_0_out;
wire   [31:0] nvdla_rbk_d_dain_ram_type_0_out;
wire   [31:0] nvdla_rbk_d_dain_surf_stride_0_out;
wire   [31:0] nvdla_rbk_d_daout_addr_high_0_out;
wire   [31:0] nvdla_rbk_d_daout_addr_low_0_out;
wire   [31:0] nvdla_rbk_d_daout_line_stride_0_out;
wire   [31:0] nvdla_rbk_d_daout_planar_stride_0_out;
wire   [31:0] nvdla_rbk_d_daout_ram_type_0_out;
wire   [31:0] nvdla_rbk_d_daout_surf_stride_0_out;
wire   [31:0] nvdla_rbk_d_datain_size_0_0_out;
wire   [31:0] nvdla_rbk_d_datain_size_1_0_out;
wire   [31:0] nvdla_rbk_d_dataout_size_1_0_out;
wire   [31:0] nvdla_rbk_d_deconv_stride_0_out;
wire   [31:0] nvdla_rbk_d_misc_cfg_0_out;
wire   [31:0] nvdla_rbk_d_op_enable_0_out;
wire   [31:0] nvdla_rbk_d_perf_enable_0_out;
wire   [31:0] nvdla_rbk_d_perf_read_stall_0_out;
wire   [31:0] nvdla_rbk_d_perf_write_stall_0_out;
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
output [26:0] contract_stride_0;
output [26:0] contract_stride_1;
output [31:0] dain_addr_high;
output [26:0] dain_addr_low;
output [26:0] dain_line_stride;
output [26:0] dain_planar_stride;
output        datain_ram_type;
output [26:0] dain_surf_stride;
output [31:0] daout_addr_high;
output [26:0] daout_addr_low;
output [26:0] daout_line_stride;
output [26:0] daout_planar_stride;
output        dataout_ram_type;
output [26:0] daout_surf_stride;
output [12:0] datain_height;
output [12:0] datain_width;
output [12:0] datain_channel;
output [12:0] dataout_channel;
output [4:0]  deconv_x_stride;
output [4:0]  deconv_y_stride;
output [1:0]  in_precision;
output [1:0]  rubik_mode;
output        op_en_trigger;
output        perf_en;

// Read-only register inputs
input         op_en;
input [31:0]  rd_stall_cnt;
input [31:0]  wr_stall_cnt;

// wr_mask register inputs

// rstn register inputs

// leda FM_2_23 off
reg           arreggen_abort_on_invalid_wr;
reg           arreggen_abort_on_rowr;
reg           arreggen_dump;
// leda FM_2_23 on
reg    [26:0] contract_stride_0;
reg    [26:0] contract_stride_1;
reg    [31:0] dain_addr_high;
reg    [26:0] dain_addr_low;
reg    [26:0] dain_line_stride;
reg    [26:0] dain_planar_stride;
reg    [26:0] dain_surf_stride;
reg    [31:0] daout_addr_high;
reg    [26:0] daout_addr_low;
reg    [26:0] daout_line_stride;
reg    [26:0] daout_planar_stride;
reg    [26:0] daout_surf_stride;
reg    [12:0] datain_channel;
reg    [12:0] datain_height;
reg           datain_ram_type;
reg    [12:0] datain_width;
reg    [12:0] dataout_channel;
reg           dataout_ram_type;
reg     [4:0] deconv_x_stride;
reg     [4:0] deconv_y_stride;
reg     [1:0] in_precision;
reg           perf_en;
reg    [31:0] reg_rd_data;
reg     [1:0] rubik_mode;

assign reg_offset_wr = {20'b0 , reg_offset};
// SCR signals

// Address decode
wire nvdla_rbk_d_contract_stride_0_0_wren = (reg_offset_wr == (32'h10044  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_contract_stride_1_0_wren = (reg_offset_wr == (32'h10048  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_dain_addr_high_0_wren = (reg_offset_wr == (32'h1001c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_dain_addr_low_0_wren = (reg_offset_wr == (32'h10020  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_dain_line_stride_0_wren = (reg_offset_wr == (32'h10024  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_dain_planar_stride_0_wren = (reg_offset_wr == (32'h1002c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_dain_ram_type_0_wren = (reg_offset_wr == (32'h10010  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_dain_surf_stride_0_wren = (reg_offset_wr == (32'h10028  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_daout_addr_high_0_wren = (reg_offset_wr == (32'h10038  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_daout_addr_low_0_wren = (reg_offset_wr == (32'h1003c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_daout_line_stride_0_wren = (reg_offset_wr == (32'h10040  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_daout_planar_stride_0_wren = (reg_offset_wr == (32'h10050  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_daout_ram_type_0_wren = (reg_offset_wr == (32'h10030  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_daout_surf_stride_0_wren = (reg_offset_wr == (32'h1004c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_datain_size_0_0_wren = (reg_offset_wr == (32'h10014  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_datain_size_1_0_wren = (reg_offset_wr == (32'h10018  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_dataout_size_1_0_wren = (reg_offset_wr == (32'h10034  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_deconv_stride_0_wren = (reg_offset_wr == (32'h10054  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_misc_cfg_0_wren = (reg_offset_wr == (32'h1000c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_op_enable_0_wren = (reg_offset_wr == (32'h10008  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_perf_enable_0_wren = (reg_offset_wr == (32'h10058  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_perf_read_stall_0_wren = (reg_offset_wr == (32'h1005c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_rbk_d_perf_write_stall_0_wren = (reg_offset_wr == (32'h10060  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)

assign nvdla_rbk_d_contract_stride_0_0_out[31:0] = { contract_stride_0, 5'b0 };
assign nvdla_rbk_d_contract_stride_1_0_out[31:0] = { contract_stride_1, 5'b0 };
assign nvdla_rbk_d_dain_addr_high_0_out[31:0] = { dain_addr_high };
assign nvdla_rbk_d_dain_addr_low_0_out[31:0] = { dain_addr_low, 5'b0 };
assign nvdla_rbk_d_dain_line_stride_0_out[31:0] = { dain_line_stride, 5'b0 };
assign nvdla_rbk_d_dain_planar_stride_0_out[31:0] = { dain_planar_stride, 5'b0 };
assign nvdla_rbk_d_dain_ram_type_0_out[31:0] = { 31'b0, datain_ram_type };
assign nvdla_rbk_d_dain_surf_stride_0_out[31:0] = { dain_surf_stride, 5'b0 };
assign nvdla_rbk_d_daout_addr_high_0_out[31:0] = { daout_addr_high };
assign nvdla_rbk_d_daout_addr_low_0_out[31:0] = { daout_addr_low, 5'b0 };
assign nvdla_rbk_d_daout_line_stride_0_out[31:0] = { daout_line_stride, 5'b0 };
assign nvdla_rbk_d_daout_planar_stride_0_out[31:0] = { daout_planar_stride, 5'b0 };
assign nvdla_rbk_d_daout_ram_type_0_out[31:0] = { 31'b0, dataout_ram_type };
assign nvdla_rbk_d_daout_surf_stride_0_out[31:0] = { daout_surf_stride, 5'b0 };
assign nvdla_rbk_d_datain_size_0_0_out[31:0] = { 3'b0, datain_height, 3'b0, datain_width };
assign nvdla_rbk_d_datain_size_1_0_out[31:0] = { 19'b0, datain_channel };
assign nvdla_rbk_d_dataout_size_1_0_out[31:0] = { 19'b0, dataout_channel };
assign nvdla_rbk_d_deconv_stride_0_out[31:0] = { 11'b0, deconv_y_stride, 11'b0, deconv_x_stride };
assign nvdla_rbk_d_misc_cfg_0_out[31:0] = { 22'b0, in_precision, 6'b0, rubik_mode };
assign nvdla_rbk_d_op_enable_0_out[31:0] = { 31'b0, op_en };
assign nvdla_rbk_d_perf_enable_0_out[31:0] = { 31'b0, perf_en };
assign nvdla_rbk_d_perf_read_stall_0_out[31:0] = { rd_stall_cnt };
assign nvdla_rbk_d_perf_write_stall_0_out[31:0] = { wr_stall_cnt };

assign op_en_trigger = nvdla_rbk_d_op_enable_0_wren;  //(W563)

assign reg_offset_rd_int = reg_offset;
// Output mux
//spyglass disable_block W338, W263 
always @(
  reg_offset_rd_int
  or nvdla_rbk_d_contract_stride_0_0_out
  or nvdla_rbk_d_contract_stride_1_0_out
  or nvdla_rbk_d_dain_addr_high_0_out
  or nvdla_rbk_d_dain_addr_low_0_out
  or nvdla_rbk_d_dain_line_stride_0_out
  or nvdla_rbk_d_dain_planar_stride_0_out
  or nvdla_rbk_d_dain_ram_type_0_out
  or nvdla_rbk_d_dain_surf_stride_0_out
  or nvdla_rbk_d_daout_addr_high_0_out
  or nvdla_rbk_d_daout_addr_low_0_out
  or nvdla_rbk_d_daout_line_stride_0_out
  or nvdla_rbk_d_daout_planar_stride_0_out
  or nvdla_rbk_d_daout_ram_type_0_out
  or nvdla_rbk_d_daout_surf_stride_0_out
  or nvdla_rbk_d_datain_size_0_0_out
  or nvdla_rbk_d_datain_size_1_0_out
  or nvdla_rbk_d_dataout_size_1_0_out
  or nvdla_rbk_d_deconv_stride_0_out
  or nvdla_rbk_d_misc_cfg_0_out
  or nvdla_rbk_d_op_enable_0_out
  or nvdla_rbk_d_perf_enable_0_out
  or nvdla_rbk_d_perf_read_stall_0_out
  or nvdla_rbk_d_perf_write_stall_0_out
  ) begin
  case (reg_offset_rd_int)
     (32'h10044  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_contract_stride_0_0_out ;
                            end 
     (32'h10048  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_contract_stride_1_0_out ;
                            end 
     (32'h1001c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_dain_addr_high_0_out ;
                            end 
     (32'h10020  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_dain_addr_low_0_out ;
                            end 
     (32'h10024  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_dain_line_stride_0_out ;
                            end 
     (32'h1002c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_dain_planar_stride_0_out ;
                            end 
     (32'h10010  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_dain_ram_type_0_out ;
                            end 
     (32'h10028  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_dain_surf_stride_0_out ;
                            end 
     (32'h10038  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_daout_addr_high_0_out ;
                            end 
     (32'h1003c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_daout_addr_low_0_out ;
                            end 
     (32'h10040  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_daout_line_stride_0_out ;
                            end 
     (32'h10050  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_daout_planar_stride_0_out ;
                            end 
     (32'h10030  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_daout_ram_type_0_out ;
                            end 
     (32'h1004c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_daout_surf_stride_0_out ;
                            end 
     (32'h10014  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_datain_size_0_0_out ;
                            end 
     (32'h10018  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_datain_size_1_0_out ;
                            end 
     (32'h10034  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_dataout_size_1_0_out ;
                            end 
     (32'h10054  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_deconv_stride_0_out ;
                            end 
     (32'h1000c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_misc_cfg_0_out ;
                            end 
     (32'h10008  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_op_enable_0_out ;
                            end 
     (32'h10058  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_perf_enable_0_out ;
                            end 
     (32'h1005c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_perf_read_stall_0_out ;
                            end 
     (32'h10060  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_rbk_d_perf_write_stall_0_out ;
                            end 
    default: reg_rd_data = {32{1'b0}};
  endcase
end

//spyglass enable_block W338, W263

// spyglass disable_block STARC-2.10.1.6, NoConstWithXZ, W443

// Register flop declarations
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    contract_stride_0[26:0] <= 27'b000000000000000000000000000;
    contract_stride_1[26:0] <= 27'b000000000000000000000000000;
    dain_addr_high[31:0] <= 32'b00000000000000000000000000000000;
    dain_addr_low[26:0] <= 27'b000000000000000000000000000;
    dain_line_stride[26:0] <= 27'b000000000000000000000000000;
    dain_planar_stride[26:0] <= 27'b000000000000000000000000000;
    datain_ram_type <= 1'b0;
    dain_surf_stride[26:0] <= 27'b000000000000000000000000000;
    daout_addr_high[31:0] <= 32'b00000000000000000000000000000000;
    daout_addr_low[26:0] <= 27'b000000000000000000000000000;
    daout_line_stride[26:0] <= 27'b000000000000000000000000000;
    daout_planar_stride[26:0] <= 27'b000000000000000000000000000;
    dataout_ram_type <= 1'b0;
    daout_surf_stride[26:0] <= 27'b000000000000000000000000000;
    datain_height[12:0] <= 13'b0000000000000;
    datain_width[12:0] <= 13'b0000000000000;
    datain_channel[12:0] <= 13'b0000000000000;
    dataout_channel[12:0] <= 13'b0000000000000;
    deconv_x_stride[4:0] <= 5'b00000;
    deconv_y_stride[4:0] <= 5'b00000;
    in_precision[1:0] <= 2'b01;
    rubik_mode[1:0] <= 2'b00;
    perf_en <= 1'b0;
  end else begin
  // Register: NVDLA_RBK_D_CONTRACT_STRIDE_0_0    Field: contract_stride_0
  if (nvdla_rbk_d_contract_stride_0_0_wren) begin
    contract_stride_0[26:0] <= reg_wr_data[31:5];
  end

  // Register: NVDLA_RBK_D_CONTRACT_STRIDE_1_0    Field: contract_stride_1
  if (nvdla_rbk_d_contract_stride_1_0_wren) begin
    contract_stride_1[26:0] <= reg_wr_data[31:5];
  end

  // Register: NVDLA_RBK_D_DAIN_ADDR_HIGH_0    Field: dain_addr_high
  if (nvdla_rbk_d_dain_addr_high_0_wren) begin
    dain_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_RBK_D_DAIN_ADDR_LOW_0    Field: dain_addr_low
  if (nvdla_rbk_d_dain_addr_low_0_wren) begin
    dain_addr_low[26:0] <= reg_wr_data[31:5];
  end

  // Register: NVDLA_RBK_D_DAIN_LINE_STRIDE_0    Field: dain_line_stride
  if (nvdla_rbk_d_dain_line_stride_0_wren) begin
    dain_line_stride[26:0] <= reg_wr_data[31:5];
  end

  // Register: NVDLA_RBK_D_DAIN_PLANAR_STRIDE_0    Field: dain_planar_stride
  if (nvdla_rbk_d_dain_planar_stride_0_wren) begin
    dain_planar_stride[26:0] <= reg_wr_data[31:5];
  end

  // Register: NVDLA_RBK_D_DAIN_RAM_TYPE_0    Field: datain_ram_type
  if (nvdla_rbk_d_dain_ram_type_0_wren) begin
    datain_ram_type <= reg_wr_data[0];
  end

  // Register: NVDLA_RBK_D_DAIN_SURF_STRIDE_0    Field: dain_surf_stride
  if (nvdla_rbk_d_dain_surf_stride_0_wren) begin
    dain_surf_stride[26:0] <= reg_wr_data[31:5];
  end

  // Register: NVDLA_RBK_D_DAOUT_ADDR_HIGH_0    Field: daout_addr_high
  if (nvdla_rbk_d_daout_addr_high_0_wren) begin
    daout_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_RBK_D_DAOUT_ADDR_LOW_0    Field: daout_addr_low
  if (nvdla_rbk_d_daout_addr_low_0_wren) begin
    daout_addr_low[26:0] <= reg_wr_data[31:5];
  end

  // Register: NVDLA_RBK_D_DAOUT_LINE_STRIDE_0    Field: daout_line_stride
  if (nvdla_rbk_d_daout_line_stride_0_wren) begin
    daout_line_stride[26:0] <= reg_wr_data[31:5];
  end

  // Register: NVDLA_RBK_D_DAOUT_PLANAR_STRIDE_0    Field: daout_planar_stride
  if (nvdla_rbk_d_daout_planar_stride_0_wren) begin
    daout_planar_stride[26:0] <= reg_wr_data[31:5];
  end

  // Register: NVDLA_RBK_D_DAOUT_RAM_TYPE_0    Field: dataout_ram_type
  if (nvdla_rbk_d_daout_ram_type_0_wren) begin
    dataout_ram_type <= reg_wr_data[0];
  end

  // Register: NVDLA_RBK_D_DAOUT_SURF_STRIDE_0    Field: daout_surf_stride
  if (nvdla_rbk_d_daout_surf_stride_0_wren) begin
    daout_surf_stride[26:0] <= reg_wr_data[31:5];
  end

  // Register: NVDLA_RBK_D_DATAIN_SIZE_0_0    Field: datain_height
  if (nvdla_rbk_d_datain_size_0_0_wren) begin
    datain_height[12:0] <= reg_wr_data[28:16];
  end

  // Register: NVDLA_RBK_D_DATAIN_SIZE_0_0    Field: datain_width
  if (nvdla_rbk_d_datain_size_0_0_wren) begin
    datain_width[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_RBK_D_DATAIN_SIZE_1_0    Field: datain_channel
  if (nvdla_rbk_d_datain_size_1_0_wren) begin
    datain_channel[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_RBK_D_DATAOUT_SIZE_1_0    Field: dataout_channel
  if (nvdla_rbk_d_dataout_size_1_0_wren) begin
    dataout_channel[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_RBK_D_DECONV_STRIDE_0    Field: deconv_x_stride
  if (nvdla_rbk_d_deconv_stride_0_wren) begin
    deconv_x_stride[4:0] <= reg_wr_data[4:0];
  end

  // Register: NVDLA_RBK_D_DECONV_STRIDE_0    Field: deconv_y_stride
  if (nvdla_rbk_d_deconv_stride_0_wren) begin
    deconv_y_stride[4:0] <= reg_wr_data[20:16];
  end

  // Register: NVDLA_RBK_D_MISC_CFG_0    Field: in_precision
  if (nvdla_rbk_d_misc_cfg_0_wren) begin
    in_precision[1:0] <= reg_wr_data[9:8];
  end

  // Register: NVDLA_RBK_D_MISC_CFG_0    Field: rubik_mode
  if (nvdla_rbk_d_misc_cfg_0_wren) begin
    rubik_mode[1:0] <= reg_wr_data[1:0];
  end

  // Not generating flops for field NVDLA_RBK_D_OP_ENABLE_0::op_en (to be implemented outside)

  // Register: NVDLA_RBK_D_PERF_ENABLE_0    Field: perf_en
  if (nvdla_rbk_d_perf_enable_0_wren) begin
    perf_en <= reg_wr_data[0];
  end

  // Not generating flops for read-only field NVDLA_RBK_D_PERF_READ_STALL_0::rd_stall_cnt

  // Not generating flops for read-only field NVDLA_RBK_D_PERF_WRITE_STALL_0::wr_stall_cnt

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
      (32'h10044  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_CONTRACT_STRIDE_0_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_contract_stride_0_0_out, nvdla_rbk_d_contract_stride_0_0_out);
      (32'h10048  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_CONTRACT_STRIDE_1_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_contract_stride_1_0_out, nvdla_rbk_d_contract_stride_1_0_out);
      (32'h1001c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAIN_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_dain_addr_high_0_out, nvdla_rbk_d_dain_addr_high_0_out);
      (32'h10020  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAIN_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_dain_addr_low_0_out, nvdla_rbk_d_dain_addr_low_0_out);
      (32'h10024  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAIN_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_dain_line_stride_0_out, nvdla_rbk_d_dain_line_stride_0_out);
      (32'h1002c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAIN_PLANAR_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_dain_planar_stride_0_out, nvdla_rbk_d_dain_planar_stride_0_out);
      (32'h10010  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAIN_RAM_TYPE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_dain_ram_type_0_out, nvdla_rbk_d_dain_ram_type_0_out);
      (32'h10028  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAIN_SURF_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_dain_surf_stride_0_out, nvdla_rbk_d_dain_surf_stride_0_out);
      (32'h10038  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAOUT_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_daout_addr_high_0_out, nvdla_rbk_d_daout_addr_high_0_out);
      (32'h1003c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAOUT_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_daout_addr_low_0_out, nvdla_rbk_d_daout_addr_low_0_out);
      (32'h10040  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAOUT_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_daout_line_stride_0_out, nvdla_rbk_d_daout_line_stride_0_out);
      (32'h10050  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAOUT_PLANAR_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_daout_planar_stride_0_out, nvdla_rbk_d_daout_planar_stride_0_out);
      (32'h10030  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAOUT_RAM_TYPE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_daout_ram_type_0_out, nvdla_rbk_d_daout_ram_type_0_out);
      (32'h1004c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DAOUT_SURF_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_daout_surf_stride_0_out, nvdla_rbk_d_daout_surf_stride_0_out);
      (32'h10014  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DATAIN_SIZE_0_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_datain_size_0_0_out, nvdla_rbk_d_datain_size_0_0_out);
      (32'h10018  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DATAIN_SIZE_1_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_datain_size_1_0_out, nvdla_rbk_d_datain_size_1_0_out);
      (32'h10034  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DATAOUT_SIZE_1_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_dataout_size_1_0_out, nvdla_rbk_d_dataout_size_1_0_out);
      (32'h10054  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_DECONV_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_deconv_stride_0_out, nvdla_rbk_d_deconv_stride_0_out);
      (32'h1000c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_MISC_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_misc_cfg_0_out, nvdla_rbk_d_misc_cfg_0_out);
      (32'h10008  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_OP_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_op_enable_0_out, nvdla_rbk_d_op_enable_0_out);
      (32'h10058  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_RBK_D_PERF_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_rbk_d_perf_enable_0_out, nvdla_rbk_d_perf_enable_0_out);
      (32'h1005c  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_RBK_D_PERF_READ_STALL_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'h10060  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_RBK_D_PERF_WRITE_STALL_0 = 0x%h", $time, reg_wr_data);
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

endmodule // NV_NVDLA_RUBIK_dual_reg

