// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_RDMA_ig.v

`include "simulate_x_tick.vh"
#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_RDMA_ig (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,op_load
  ,ig2cq_pd
  ,ig2cq_pvld
  ,ig2cq_prdy
  ,dma_rd_req_pd
  ,dma_rd_req_vld
  ,dma_rd_req_rdy
  ,reg2dp_op_en
  ,reg2dp_winograd
  ,reg2dp_channel
  ,reg2dp_height
  ,reg2dp_width
  ,reg2dp_rdma_data_mode
  ,reg2dp_rdma_data_size
  ,reg2dp_rdma_data_use
  ,reg2dp_base_addr_high
  ,reg2dp_base_addr_low
  ,reg2dp_line_stride
  ,reg2dp_surface_stride
  ,reg2dp_proc_precision
  ,reg2dp_perf_dma_en
  ,dp2reg_rdma_stall
  );

input         nvdla_core_clk;
input         nvdla_core_rstn;
input         op_load;
input         dma_rd_req_rdy;
output [NVDLA_DMA_RD_REQ-1:0] dma_rd_req_pd;
output        dma_rd_req_vld;
input         ig2cq_prdy;
output [15:0] ig2cq_pd;
output        ig2cq_pvld;
input         reg2dp_op_en;
input         reg2dp_winograd;
input  [12:0] reg2dp_channel;
input  [12:0] reg2dp_height;
input  [12:0] reg2dp_width;
input   [1:0] reg2dp_proc_precision;
input         reg2dp_rdma_data_mode;
input         reg2dp_rdma_data_size;
input   [1:0] reg2dp_rdma_data_use;
input  [31:0] reg2dp_base_addr_high;
input  [31-AM_AW:0] reg2dp_base_addr_low;
input  [31-AM_AW:0] reg2dp_line_stride;
input  [31-AM_AW:0] reg2dp_surface_stride;
input         reg2dp_perf_dma_en;
output [31:0] dp2reg_rdma_stall;

reg    [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] base_addr_line;
reg    [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] base_addr_surf;
reg    [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] base_addr_width;
#ifdef NVDLA_WINOGRAD_ENABLE
reg    [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] base_addr_wino;
reg           mon_base_addr_wino_c;
#endif
reg           mon_base_addr_line_c;
reg           mon_base_addr_surf_c;
reg           mon_base_addr_width_c;
wire          ig2eg_cube_end;
wire   [14:0] ig2eg_size;
reg           cmd_process;
wire          cmd_accept;
wire          op_done;
reg     [13-AM_AW:0] count_c;
reg    [14:0] count_w;
reg    [12:0] count_h;
reg    [13-AM_AW:0] size_of_surf;
reg    [14:0] size_of_straight;
reg    [14:0] size_of_width;
wire   [12:0] size_of_height;
wire   [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] cfg_base_addr;
wire          cfg_data_mode_per_kernel;
wire          cfg_data_size_1byte;
wire          cfg_data_use_both;
wire          cfg_mode_1x1_pack;
wire          cfg_proc_int16;
wire          cfg_proc_int8;
wire   [31-AM_AW:0] cfg_line_stride;
wire   [31-AM_AW:0] cfg_surf_stride;
wire          is_cube_end;
wire          is_last_c;
wire          is_last_h;
wire          is_last_w;
wire          is_line_end;
wire          is_surf_end;
#ifdef NVDLA_WINOGRAD_ENABLE
wire          cfg_mode_wino;
reg     [1:0] count_g;
wire    [1:0] size_of_wino;
wire          is_last_wg;
wire          is_wino_end;
reg     [2:0] mode_wino_req_size;
#endif
reg    [14:0] dma_req_size;
reg    [NVDLA_MEM_ADDRESS_WIDTH-1:0] dma_req_addr;

reg           stl_adv;
reg    [31:0] stl_cnt_cur;
reg    [33:0] stl_cnt_dec;
reg    [33:0] stl_cnt_ext;
reg    [33:0] stl_cnt_inc;
reg    [33:0] stl_cnt_mod;
reg    [33:0] stl_cnt_new;
reg    [33:0] stl_cnt_nxt;
wire          rdma_stall_cnt_cen;
wire          rdma_stall_cnt_clr;
wire          rdma_stall_cnt_inc;
wire          dp2reg_rdma_stall_dec;
reg    [31:0] dp2reg_rdma_stall;
   

assign op_done = cmd_accept & is_cube_end;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_process <= 1'b0;
  end else begin
    if (op_load) begin
        cmd_process <= 1'b1;
    end else if (op_done) begin
        cmd_process <= 1'b0;
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
  // VCS coverage off 
  nv_assert_never #(0,0,"SDP-RDMA: get an op-done without starting the op")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, !cmd_process && op_done); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============
// Address catenate and offset calc
//==============
#if (NVDLA_MEM_ADDRESS_WIDTH > 32) 
assign cfg_base_addr   = {reg2dp_base_addr_high,reg2dp_base_addr_low};
#else
assign cfg_base_addr   = reg2dp_base_addr_low;
#endif
assign cfg_surf_stride = {reg2dp_surface_stride};
assign cfg_line_stride = {reg2dp_line_stride};

assign cfg_data_size_1byte = reg2dp_rdma_data_size == 1'h0 ;
assign cfg_data_use_both = reg2dp_rdma_data_use == 2'h2 ;
assign cfg_data_mode_per_kernel = reg2dp_rdma_data_mode == 1'h0 ;

assign cfg_proc_int8  = reg2dp_proc_precision == 0 ;
assign cfg_proc_int16 = reg2dp_proc_precision == 1 ;

#ifdef NVDLA_WINOGRAD_ENABLE
assign cfg_mode_wino = reg2dp_winograd== 1'h1 ;
#endif
assign cfg_mode_1x1_pack = (reg2dp_width==0) & (reg2dp_height==0);

//=================================================
// Cube Shape
//=================================================
#ifdef NVDLA_WINOGRAD_ENABLE
assign is_wino_end  = (!cfg_mode_wino)  | cfg_data_mode_per_kernel | is_last_wg;
assign is_line_end  = (!cfg_mode_wino)  | cfg_data_mode_per_kernel | is_wino_end & is_last_w;
#else 
assign is_line_end  = 1'b1; 
#endif
assign is_surf_end  = cfg_mode_1x1_pack | cfg_data_mode_per_kernel | (is_line_end & is_last_h);
assign is_cube_end  = cfg_mode_1x1_pack | cfg_data_mode_per_kernel | (is_surf_end & is_last_c);

#ifdef NVDLA_WINOGRAD_ENABLE
//==============
// Winagrad Count: size always==1, go height direction with 4 steps, then width direction
//==============
assign size_of_wino = cfg_mode_wino ? 2'd3 : 2'd0;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_g <= {2{1'b0}};
  end else begin
    if (cfg_mode_wino) begin
        if (cmd_accept) begin
            if (is_wino_end) begin
                count_g <= 0;
            end else begin
                count_g <= count_g + 1'b1;
            end
        end
    end
  end
end
assign is_last_wg = (count_g==size_of_wino);
#endif

//==============
// CHANNEL Count:
//==============
always @(
  cfg_proc_int8
  or reg2dp_channel
  or cfg_proc_int16
  ) begin
    if (cfg_proc_int8) begin
        size_of_surf = {1'b0,reg2dp_channel[12:AM_AW]};
    end else if (cfg_proc_int16) begin
        size_of_surf = reg2dp_channel[12:AM_AW2];
    end else begin
        size_of_surf = reg2dp_channel[12:AM_AW2];
    end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_c <= {(14-AM_AW){1'b0}};
  end else begin
    if (cmd_accept) begin
        if (is_cube_end) begin
            count_c <= 0;
        end else if (is_surf_end) begin
            count_c <= count_c + 1;
        end
    end
  end
end
assign is_last_c = (count_c==size_of_surf);

//==============
// HEIGHT Count:
//==============
#ifdef NVDLA_WINOGRAD_ENABLE
assign size_of_height = cfg_mode_wino ? {2'd0,reg2dp_height[12:2]} : reg2dp_height;
#else
assign size_of_height = reg2dp_height;
#endif
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_h <= {13{1'b0}};
  end else begin
    if (cmd_accept) begin
        if (is_surf_end) begin
            count_h <= 0;
        end else if (is_line_end) begin
            count_h <= count_h + 1;
        end
    end
  end
end
assign is_last_h = (count_h==size_of_height);

#ifdef NVDLA_WINOGRAD_ENABLE
//==============
// Width Count:
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_w <= {15{1'b0}};
  end else begin
    if (cfg_mode_wino) begin
        if (cmd_accept) begin
            if (is_line_end) begin
                count_w <= 0;
            end else if (is_wino_end) begin
                count_w <= count_w + 1;
            end
        end
    end
  end
end
assign is_last_w = (count_w==size_of_width);
#endif

//==========================================
// DMA Req : ADDR PREPARE
//==========================================
// LINE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_line <= {(NVDLA_MEM_ADDRESS_WIDTH-AM_AW){1'b0}};
    mon_base_addr_line_c <= 1'b0;
  end else begin
    if (op_load) begin
        base_addr_line <= cfg_base_addr;
    end else if (cmd_accept) begin
        #ifdef NVDLA_WINOGRAD_ENABLE
        if (cfg_mode_wino) begin
            if (is_surf_end) begin
                {mon_base_addr_line_c,base_addr_line} <= base_addr_surf + cfg_surf_stride;
            end else if (is_line_end) begin
                {mon_base_addr_line_c,base_addr_line} <= base_addr_line + (cfg_line_stride<<2);
            end
        end else
        #endif 
        begin
            if (is_surf_end) begin
                {mon_base_addr_line_c,base_addr_line} <= base_addr_surf + cfg_surf_stride;
            end else begin
                {mon_base_addr_line_c,base_addr_line} <= base_addr_line + cfg_line_stride;
            end
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"SDP RDMA: no overflow is allowed")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_line_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// SURF
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_surf <= {(NVDLA_MEM_ADDRESS_WIDTH-AM_AW){1'b0}};
    mon_base_addr_surf_c <= 1'b0;
  end else begin
    if (op_load) begin
        base_addr_surf <= cfg_base_addr;
    end else if (cmd_accept) begin
        #ifdef NVDLA_WINOGRAD_ENABLE
        if (cfg_mode_wino) begin
            if (is_surf_end) begin
                {mon_base_addr_surf_c,base_addr_surf} <= base_addr_surf + cfg_surf_stride;
            end
        end else
        #endif 
        begin
            if (is_surf_end) begin
                {mon_base_addr_surf_c,base_addr_surf} <= base_addr_surf + cfg_surf_stride;
            end
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"SDP RDMA: no overflow is allowed")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_surf_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

#ifdef NVDLA_WINOGRAD_ENABLE
// ADDR WinoG
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_wino <= {(NVDLA_MEM_ADDRESS_WIDTH-AM_AW){1'b0}};
    mon_base_addr_wino_c <= 1'b0;
  end else begin
    if (cfg_mode_wino) begin
        if (op_load) begin
            base_addr_wino <= cfg_base_addr;
        end else if (cmd_accept) begin
            if (is_surf_end) begin
                {mon_base_addr_wino_c,base_addr_wino} <= base_addr_surf + cfg_surf_stride;
            end else if (is_line_end) begin
                {mon_base_addr_wino_c,base_addr_wino} <= base_addr_line + (cfg_line_stride<<2);
            end else if (is_wino_end) begin
                {mon_base_addr_wino_c,base_addr_wino} <= base_addr_width + (dma_req_size+1);
            end else begin
                {mon_base_addr_wino_c,base_addr_wino} <= base_addr_wino + cfg_line_stride;
            end
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"SDP RDMA: no overflow is allowed")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_wino_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// ADDR width
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_width <= {(NVDLA_MEM_ADDRESS_WIDTH-AM_AW){1'b0}};
    mon_base_addr_width_c <= 1'b0;
  end else begin
    if (cfg_mode_wino) begin
        if (op_load) begin
            base_addr_width <= cfg_base_addr;
        end else if (cmd_accept) begin
            if (is_surf_end) begin
                {mon_base_addr_width_c,base_addr_width} <= base_addr_surf + cfg_surf_stride;
            end else if (is_line_end) begin
                {mon_base_addr_width_c,base_addr_width} <= base_addr_line + (cfg_line_stride<<2);
            end else if (is_wino_end) begin
                {mon_base_addr_width_c,base_addr_width} <= base_addr_width + (dma_req_size+1);
            end
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"SDP RDMA: no overflow is allowed")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_width_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
#endif

//==========================================
// DMA Req : Addr
//==========================================
always @(
  base_addr_line
  #ifdef NVDLA_WINOGRAD_ENABLE
  or cfg_mode_wino
  or base_addr_wino
  #endif
  ) begin
    #ifdef NVDLA_WINOGRAD_ENABLE
    if (cfg_mode_wino) 
        dma_req_addr = {base_addr_wino,{AM_AW{1'b0}}};
    else 
    #endif
        dma_req_addr = {base_addr_line,{AM_AW{1'b0}}};
end

// Size_Of_Width: As each element is 1B or 2B, the width of cube will be resized accordingly 
always @(
  reg2dp_width
  #ifdef NVDLA_WINOGRAD_ENABLE
  or cfg_mode_wino
  #endif
  or cfg_proc_int8
  or cfg_data_use_both
  or cfg_data_size_1byte
  ) begin
    #ifdef NVDLA_WINOGRAD_ENABLE
    if (cfg_mode_wino) begin
        size_of_width = {3'd0,reg2dp_width[12:1]};
    end else 
    #endif
    if (cfg_proc_int8) begin
        if (cfg_data_use_both) begin
            if (cfg_data_size_1byte) begin
                size_of_width = (reg2dp_width << 1) + 1;
            end else begin
                size_of_width = (reg2dp_width << 2) + 3;
            end
        end else begin
            if (cfg_data_size_1byte) begin
                size_of_width = {2'd0,reg2dp_width};
            end else begin
                size_of_width = (reg2dp_width << 1) + 1;
            end
        end
    end else begin
        if (cfg_data_use_both) begin
            size_of_width = (reg2dp_width << 1) + 1;
        end else begin
            size_of_width = {2'd0,reg2dp_width};
            
        end
    end
end

//==========================================
// DMA Req : SIZE
//==========================================
#ifdef NVDLA_WINOGRAD_ENABLE
// winograd
always @(
  cfg_proc_int8
  or cfg_data_use_both
  or cfg_data_size_1byte
  ) begin
    if (cfg_proc_int8) begin
        if (cfg_data_use_both) begin
            if (cfg_data_size_1byte) begin
                mode_wino_req_size = 3'd3;
            end else begin
                mode_wino_req_size = 3'd7;
            end
        end else begin
            if (cfg_data_size_1byte) begin
                mode_wino_req_size = 3'd1;
            end else begin
                mode_wino_req_size = 3'd3;
            end
        end
    end else begin
        if (cfg_data_use_both) begin
            if (cfg_data_size_1byte) begin
                mode_wino_req_size = 3'd1;
            end else begin
                mode_wino_req_size = 3'd3;
            end
        end else begin
            if (cfg_data_size_1byte) begin
                mode_wino_req_size = 3'd0;
            end else begin
                mode_wino_req_size = 3'd1;
            end
        end
    end
end
#endif

// in 1x1_pack mode, only send one request out 
//assign mode_1x1_req_size = size_of_surf;
// PRECISION: 2byte both
//  8:1byte:single - 1B/elem -  32B/surf - 1 x surf
//  8:2byte:single - 2B/elem -  64B/surf - 2 x surf
//  8:1byte:both   - 2B/elem -  64B/surf - 2 x surf
//  8:2byte:both   - 4B/elem - 128B/surf - 4 x surf
// 16:2byte:single - 2B/elem -  32B/surf - 1 x surf
// 16:2byte:both   - 4B/elem -  64B/surf - 2 x surf
always @(
  cfg_proc_int8
  or cfg_data_use_both
  or cfg_data_size_1byte
  or size_of_surf
  ) begin
    if (cfg_proc_int8) begin
        if (cfg_data_use_both) begin
            if (cfg_data_size_1byte) begin
                size_of_straight = (size_of_surf << 1) + 1;
            end else begin
                size_of_straight = (size_of_surf << 2) + 3;
            end
        end else begin
            if (cfg_data_size_1byte) begin
                size_of_straight = (size_of_surf << 0) + 0;
            end else begin
                size_of_straight = (size_of_surf << 1) + 1;
            end
        end
    end else begin
        if (cfg_data_use_both) begin
            if (cfg_data_size_1byte) begin
                size_of_straight = (size_of_surf << 1) + 0; // illegal
            end else begin
                size_of_straight = (size_of_surf << 1) + 1;
            end
        end else begin
            if (cfg_data_size_1byte) begin
                size_of_straight = (size_of_surf << 1) + 0; // illegal
            end else begin
                size_of_straight = (size_of_surf << 0) + 0;
            end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"NO SIZE of 1Byte supported if proc precision is INT16")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & cfg_proc_int16 & cfg_data_size_1byte); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  cfg_data_mode_per_kernel
  or cfg_mode_1x1_pack
  or size_of_straight
  #ifdef NVDLA_WINOGRAD_ENABLE
  or cfg_mode_wino
  or mode_wino_req_size
  #endif
  or size_of_width
  ) begin
    if (cfg_data_mode_per_kernel || cfg_mode_1x1_pack) begin
        dma_req_size = size_of_straight;
    end else begin
        #ifdef NVDLA_WINOGRAD_ENABLE
        if (cfg_mode_wino) begin
            dma_req_size = {{12{1'b0}}, mode_wino_req_size};
        end else
        #endif
        begin
            dma_req_size = size_of_width;
        end
    end
end

//==========================================
// Context Queue Interface
// size,cube_end
//==========================================
assign ig2eg_size = dma_req_size;
assign ig2eg_cube_end  = is_cube_end;

assign ig2cq_pd[14:0] = ig2eg_size[14:0];
assign ig2cq_pd[15] =   ig2eg_cube_end ;
assign ig2cq_pvld = cmd_process & dma_rd_req_rdy;
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
  nv_assert_never #(0,0,"SDP-RDMA: CQ and DMA should accept or reject together")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (ig2cq_pvld & ig2cq_prdy) ^ (dma_rd_req_vld & dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============
// DMA Req : PIPE
//==============
// VALID: clamp when when cq is not ready
assign dma_rd_req_vld = cmd_process & ig2cq_prdy;

assign dma_rd_req_pd[NVDLA_MEM_ADDRESS_WIDTH-1:0] =     dma_req_addr[NVDLA_MEM_ADDRESS_WIDTH-1:0];
assign dma_rd_req_pd[NVDLA_DMA_RD_REQ-1:NVDLA_MEM_ADDRESS_WIDTH] =     dma_req_size[14:0];

// Accept
assign cmd_accept = dma_rd_req_vld & dma_rd_req_rdy;


//==============
// PERF STATISTIC
assign rdma_stall_cnt_inc = dma_rd_req_vld & !dma_rd_req_rdy;
assign rdma_stall_cnt_clr = op_load;
assign rdma_stall_cnt_cen = reg2dp_op_en & reg2dp_perf_dma_en;


assign dp2reg_rdma_stall_dec = 1'b0;

// stl adv logic
always @(
  rdma_stall_cnt_inc
  or dp2reg_rdma_stall_dec
  ) begin
  stl_adv = rdma_stall_cnt_inc ^ dp2reg_rdma_stall_dec;
end
    
// stl cnt logic
always @(
  stl_cnt_cur
  or rdma_stall_cnt_inc
  or dp2reg_rdma_stall_dec
  or stl_adv
  or rdma_stall_cnt_clr
  ) begin
  stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
  stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; 
  stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; 
  stl_cnt_mod[33:0] = (rdma_stall_cnt_inc && !dp2reg_rdma_stall_dec)? stl_cnt_inc : (!rdma_stall_cnt_inc && dp2reg_rdma_stall_dec)? stl_cnt_dec : stl_cnt_ext;
  stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
  stl_cnt_nxt[33:0] = (rdma_stall_cnt_clr)? 34'd0 : stl_cnt_new[33:0];
end

// stl flops
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stl_cnt_cur[31:0] <= 0;
  end else begin
  if (rdma_stall_cnt_cen) begin
  stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
  end
  end
end

// stl output logic
always @(
  stl_cnt_cur
  ) begin
  dp2reg_rdma_stall[31:0] = stl_cnt_cur[31:0];
end
        
      
#ifdef NVDLA_WINOGRAD_ENABLE
//===============
// ASSERTION
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
  nv_assert_never #(0,0,"SDP-RDMA: winograd, height need be multiple of 4")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, op_load & cfg_mode_wino & (reg2dp_height[1:0]!=2'b11)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
#endif

endmodule // NV_NVDLA_SDP_RDMA_ig

