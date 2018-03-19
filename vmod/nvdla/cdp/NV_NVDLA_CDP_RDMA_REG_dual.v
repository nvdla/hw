// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_RDMA_REG_dual.v

module NV_NVDLA_CDP_RDMA_REG_dual (
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
  ,channel
  ,height
  ,width
  ,input_data
  ,op_en_trigger
  ,dma_en
  ,src_base_addr_high
  ,src_base_addr_low
  ,src_ram_type
  ,src_line_stride
  ,src_surface_stride
  ,op_en
  ,perf_read_stall
  );

wire   [31:0] nvdla_cdp_rdma_d_cya_0_out;
wire   [31:0] nvdla_cdp_rdma_d_data_cube_channel_0_out;
wire   [31:0] nvdla_cdp_rdma_d_data_cube_height_0_out;
wire   [31:0] nvdla_cdp_rdma_d_data_cube_width_0_out;
wire   [31:0] nvdla_cdp_rdma_d_data_format_0_out;
wire   [31:0] nvdla_cdp_rdma_d_op_enable_0_out;
wire   [31:0] nvdla_cdp_rdma_d_operation_mode_0_out;
wire   [31:0] nvdla_cdp_rdma_d_perf_enable_0_out;
wire   [31:0] nvdla_cdp_rdma_d_perf_read_stall_0_out;
wire   [31:0] nvdla_cdp_rdma_d_src_base_addr_high_0_out;
wire   [31:0] nvdla_cdp_rdma_d_src_base_addr_low_0_out;
wire   [31:0] nvdla_cdp_rdma_d_src_compression_en_0_out;
wire   [31:0] nvdla_cdp_rdma_d_src_dma_cfg_0_out;
wire   [31:0] nvdla_cdp_rdma_d_src_line_stride_0_out;
wire   [31:0] nvdla_cdp_rdma_d_src_surface_stride_0_out;
wire    [1:0] operation_mode;
wire   [11:0] reg_offset_rd_int;
wire   [31:0] reg_offset_wr;
wire          src_compression_en;
// Register control interface
output [31:0] reg_rd_data;
input [11:0]  reg_offset;
input [31:0]  reg_wr_data;  //(UNUSED_DEC)
input         reg_wr_en;
input         nvdla_core_clk;
input         nvdla_core_rstn;


// Writable register flop/trigger outputs
output [31:0] cya;
output [12:0] channel;
output [12:0] height;
output [12:0] width;
output [1:0]  input_data;
output        op_en_trigger;
output        dma_en;
output [31:0] src_base_addr_high;
output [31:0] src_base_addr_low;
output        src_ram_type;
output [31:0] src_line_stride;
output [31:0] src_surface_stride;

// Read-only register inputs
input         op_en;
input [31:0]  perf_read_stall;

// wr_mask register inputs

// rstn register inputs

// leda FM_2_23 off
reg           arreggen_abort_on_invalid_wr;
reg           arreggen_abort_on_rowr;
reg           arreggen_dump;
// leda FM_2_23 on
reg    [12:0] channel;
reg    [31:0] cya;
reg           dma_en;
reg    [12:0] height;
reg     [1:0] input_data;
reg    [31:0] reg_rd_data;
reg    [31:0] src_base_addr_high;
reg    [31:0] src_base_addr_low;
reg    [31:0] src_line_stride;
reg           src_ram_type;
reg    [31:0] src_surface_stride;
reg    [12:0] width;

assign reg_offset_wr = {20'b0 , reg_offset};
// SCR signals

// Address decode
wire nvdla_cdp_rdma_d_cya_0_wren = (reg_offset_wr == (32'he040  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_data_cube_channel_0_wren = (reg_offset_wr == (32'he014  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_data_cube_height_0_wren = (reg_offset_wr == (32'he010  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_data_cube_width_0_wren = (reg_offset_wr == (32'he00c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_data_format_0_wren = (reg_offset_wr == (32'he034  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_operation_mode_0_wren = (reg_offset_wr == (32'he030  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_op_enable_0_wren = (reg_offset_wr == (32'he008  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_perf_enable_0_wren = (reg_offset_wr == (32'he038  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_perf_read_stall_0_wren = (reg_offset_wr == (32'he03c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_src_base_addr_high_0_wren = (reg_offset_wr == (32'he01c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_src_base_addr_low_0_wren = (reg_offset_wr == (32'he018  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_src_compression_en_0_wren = (reg_offset_wr == (32'he02c  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_src_dma_cfg_0_wren = (reg_offset_wr == (32'he028  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_src_line_stride_0_wren = (reg_offset_wr == (32'he020  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)
wire nvdla_cdp_rdma_d_src_surface_stride_0_wren = (reg_offset_wr == (32'he024  & 32'h00000fff)) & reg_wr_en ;  //spyglass disable UnloadedNet-ML //(W528)

assign operation_mode = 2'h0;
assign src_compression_en = 1'h0;
assign nvdla_cdp_rdma_d_cya_0_out[31:0] = { cya };
assign nvdla_cdp_rdma_d_data_cube_channel_0_out[31:0] = { 19'b0, channel };
assign nvdla_cdp_rdma_d_data_cube_height_0_out[31:0] = { 19'b0, height };
assign nvdla_cdp_rdma_d_data_cube_width_0_out[31:0] = { 19'b0, width };
assign nvdla_cdp_rdma_d_data_format_0_out[31:0] = { 30'b0, input_data };
assign nvdla_cdp_rdma_d_operation_mode_0_out[31:0] = { 30'b0, operation_mode };
assign nvdla_cdp_rdma_d_op_enable_0_out[31:0] = { 31'b0, op_en };
assign nvdla_cdp_rdma_d_perf_enable_0_out[31:0] = { 31'b0, dma_en };
assign nvdla_cdp_rdma_d_perf_read_stall_0_out[31:0] = { perf_read_stall };
assign nvdla_cdp_rdma_d_src_base_addr_high_0_out[31:0] = { src_base_addr_high };
assign nvdla_cdp_rdma_d_src_base_addr_low_0_out[31:0] = { src_base_addr_low };
assign nvdla_cdp_rdma_d_src_compression_en_0_out[31:0] = { 31'b0, src_compression_en };
assign nvdla_cdp_rdma_d_src_dma_cfg_0_out[31:0] = { 31'b0, src_ram_type };
assign nvdla_cdp_rdma_d_src_line_stride_0_out[31:0] = { src_line_stride };
assign nvdla_cdp_rdma_d_src_surface_stride_0_out[31:0] = { src_surface_stride };

assign op_en_trigger = nvdla_cdp_rdma_d_op_enable_0_wren;  //(W563)

assign reg_offset_rd_int = reg_offset;
// Output mux
//spyglass disable_block W338, W263 
always @(
  reg_offset_rd_int
  or nvdla_cdp_rdma_d_cya_0_out
  or nvdla_cdp_rdma_d_data_cube_channel_0_out
  or nvdla_cdp_rdma_d_data_cube_height_0_out
  or nvdla_cdp_rdma_d_data_cube_width_0_out
  or nvdla_cdp_rdma_d_data_format_0_out
  or nvdla_cdp_rdma_d_operation_mode_0_out
  or nvdla_cdp_rdma_d_op_enable_0_out
  or nvdla_cdp_rdma_d_perf_enable_0_out
  or nvdla_cdp_rdma_d_perf_read_stall_0_out
  or nvdla_cdp_rdma_d_src_base_addr_high_0_out
  or nvdla_cdp_rdma_d_src_base_addr_low_0_out
  or nvdla_cdp_rdma_d_src_compression_en_0_out
  or nvdla_cdp_rdma_d_src_dma_cfg_0_out
  or nvdla_cdp_rdma_d_src_line_stride_0_out
  or nvdla_cdp_rdma_d_src_surface_stride_0_out
  ) begin
  case (reg_offset_rd_int)
     (32'he040  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_cya_0_out ;
                            end 
     (32'he014  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_data_cube_channel_0_out ;
                            end 
     (32'he010  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_data_cube_height_0_out ;
                            end 
     (32'he00c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_data_cube_width_0_out ;
                            end 
     (32'he034  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_data_format_0_out ;
                            end 
     (32'he030  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_operation_mode_0_out ;
                            end 
     (32'he008  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_op_enable_0_out ;
                            end 
     (32'he038  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_perf_enable_0_out ;
                            end 
     (32'he03c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_perf_read_stall_0_out ;
                            end 
     (32'he01c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_src_base_addr_high_0_out ;
                            end 
     (32'he018  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_src_base_addr_low_0_out ;
                            end 
     (32'he02c  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_src_compression_en_0_out ;
                            end 
     (32'he028  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_src_dma_cfg_0_out ;
                            end 
     (32'he020  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_src_line_stride_0_out ;
                            end 
     (32'he024  & 32'h00000fff): begin 
                            reg_rd_data =  nvdla_cdp_rdma_d_src_surface_stride_0_out ;
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
    channel[12:0] <= 13'b0000000000000;
    height[12:0] <= 13'b0000000000000;
    width[12:0] <= 13'b0000000000000;
    input_data[1:0] <= 2'b00;
    dma_en <= 1'b0;
    src_base_addr_high[31:0] <= 32'b00000000000000000000000000000000;
    src_base_addr_low[31:0] <= 32'b00000000000000000000000000000000;
    src_ram_type <= 1'b0;
    src_line_stride[31:0] <= 32'b00000000000000000000000000000000;
    src_surface_stride[31:0] <= 32'b00000000000000000000000000000000;
  end else begin
  // Register: NVDLA_CDP_RDMA_D_CYA_0    Field: cya
  if (nvdla_cdp_rdma_d_cya_0_wren) begin
    cya[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_RDMA_D_DATA_CUBE_CHANNEL_0    Field: channel
  if (nvdla_cdp_rdma_d_data_cube_channel_0_wren) begin
    channel[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_CDP_RDMA_D_DATA_CUBE_HEIGHT_0    Field: height
  if (nvdla_cdp_rdma_d_data_cube_height_0_wren) begin
    height[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_CDP_RDMA_D_DATA_CUBE_WIDTH_0    Field: width
  if (nvdla_cdp_rdma_d_data_cube_width_0_wren) begin
    width[12:0] <= reg_wr_data[12:0];
  end

  // Register: NVDLA_CDP_RDMA_D_DATA_FORMAT_0    Field: input_data
  if (nvdla_cdp_rdma_d_data_format_0_wren) begin
    input_data[1:0] <= reg_wr_data[1:0];
  end

  // Not generating flops for constant field NVDLA_CDP_RDMA_D_OPERATION_MODE_0::operation_mode

  // Not generating flops for field NVDLA_CDP_RDMA_D_OP_ENABLE_0::op_en (to be implemented outside)

  // Register: NVDLA_CDP_RDMA_D_PERF_ENABLE_0    Field: dma_en
  if (nvdla_cdp_rdma_d_perf_enable_0_wren) begin
    dma_en <= reg_wr_data[0];
  end

  // Not generating flops for read-only field NVDLA_CDP_RDMA_D_PERF_READ_STALL_0::perf_read_stall

  // Register: NVDLA_CDP_RDMA_D_SRC_BASE_ADDR_HIGH_0    Field: src_base_addr_high
  if (nvdla_cdp_rdma_d_src_base_addr_high_0_wren) begin
    src_base_addr_high[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_RDMA_D_SRC_BASE_ADDR_LOW_0    Field: src_base_addr_low
  if (nvdla_cdp_rdma_d_src_base_addr_low_0_wren) begin
    src_base_addr_low[31:0] <= reg_wr_data[31:0];
  end

  // Not generating flops for constant field NVDLA_CDP_RDMA_D_SRC_COMPRESSION_EN_0::src_compression_en

  // Register: NVDLA_CDP_RDMA_D_SRC_DMA_CFG_0    Field: src_ram_type
  if (nvdla_cdp_rdma_d_src_dma_cfg_0_wren) begin
    src_ram_type <= reg_wr_data[0];
  end

  // Register: NVDLA_CDP_RDMA_D_SRC_LINE_STRIDE_0    Field: src_line_stride
  if (nvdla_cdp_rdma_d_src_line_stride_0_wren) begin
    src_line_stride[31:0] <= reg_wr_data[31:0];
  end

  // Register: NVDLA_CDP_RDMA_D_SRC_SURFACE_STRIDE_0    Field: src_surface_stride
  if (nvdla_cdp_rdma_d_src_surface_stride_0_wren) begin
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
      (32'he040  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_CYA_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_cya_0_out, nvdla_cdp_rdma_d_cya_0_out);
      (32'he014  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_DATA_CUBE_CHANNEL_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_data_cube_channel_0_out, nvdla_cdp_rdma_d_data_cube_channel_0_out);
      (32'he010  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_DATA_CUBE_HEIGHT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_data_cube_height_0_out, nvdla_cdp_rdma_d_data_cube_height_0_out);
      (32'he00c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_DATA_CUBE_WIDTH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_data_cube_width_0_out, nvdla_cdp_rdma_d_data_cube_width_0_out);
      (32'he034  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_DATA_FORMAT_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_data_format_0_out, nvdla_cdp_rdma_d_data_format_0_out);
      (32'he030  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_RDMA_D_OPERATION_MODE_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'he008  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_OP_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_op_enable_0_out, nvdla_cdp_rdma_d_op_enable_0_out);
      (32'he038  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_PERF_ENABLE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_perf_enable_0_out, nvdla_cdp_rdma_d_perf_enable_0_out);
      (32'he03c  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_RDMA_D_PERF_READ_STALL_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'he01c  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_SRC_BASE_ADDR_HIGH_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_src_base_addr_high_0_out, nvdla_cdp_rdma_d_src_base_addr_high_0_out);
      (32'he018  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_SRC_BASE_ADDR_LOW_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_src_base_addr_low_0_out, nvdla_cdp_rdma_d_src_base_addr_low_0_out);
      (32'he02c  & 32'h00000fff): begin
          if (arreggen_dump) $display("%t:%m: read-only reg wr: NVDLA_CDP_RDMA_D_SRC_COMPRESSION_EN_0 = 0x%h", $time, reg_wr_data);
          if (arreggen_abort_on_rowr) begin $display("ERROR: write to read-only register!"); $finish; end
        end
      (32'he028  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_SRC_DMA_CFG_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_src_dma_cfg_0_out, nvdla_cdp_rdma_d_src_dma_cfg_0_out);
      (32'he020  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_SRC_LINE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_src_line_stride_0_out, nvdla_cdp_rdma_d_src_line_stride_0_out);
      (32'he024  & 32'h00000fff): if (arreggen_dump) $display("%t:%m: reg wr: NVDLA_CDP_RDMA_D_SRC_SURFACE_STRIDE_0 = 0x%h (old value: 0x%h, 0x%b))", $time, reg_wr_data, nvdla_cdp_rdma_d_src_surface_stride_0_out, nvdla_cdp_rdma_d_src_surface_stride_0_out);
      default: begin
          if (arreggen_dump) $display("%t:%m: reg wr: Unknown register (0x%h) = 0x%h", $time, reg_offset, reg_wr_data);
          if (arreggen_abort_on_invalid_wr) begin $display("ERROR: write to undefined register!"); $finish; end
        end
    endcase
  end
end

// VCS coverage on
// synopsys translate_on

endmodule // NV_NVDLA_CDP_RDMA_REG_dual

