// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_bufferin.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CDP_DP_bufferin (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cdp_rdma2dp_pd
  ,cdp_rdma2dp_valid
  ,normalz_buf_data_prdy
  ,cdp_rdma2dp_ready
  ,normalz_buf_data
  ,normalz_buf_data_pvld
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input   [86:0] cdp_rdma2dp_pd;
input          cdp_rdma2dp_valid;
input          normalz_buf_data_prdy;
output         cdp_rdma2dp_ready;
output [230:0] normalz_buf_data;
output         normalz_buf_data_pvld;
reg            NormalC2CubeEnd;
reg            b_sync_align;
reg            b_sync_dly1;
reg            buf_dat_vld;
reg            buffer_b_sync;
reg    [215:0] buffer_data;
reg            buffer_data_vld;
reg            buffer_last_c;
reg            buffer_last_h;
reg            buffer_last_w;
reg      [2:0] buffer_pos_c;
reg      [3:0] buffer_pos_w;
reg            buffer_ready;
reg      [3:0] buffer_width;
reg            cdp_rdma2dp_ready;
reg      [3:0] cube_end_width_cnt;
reg     [71:0] data_1stC_0;
reg     [71:0] data_1stC_1;
reg     [71:0] data_1stC_2;
reg     [71:0] data_1stC_3;
reg     [71:0] data_1stC_4;
reg     [71:0] data_1stC_5;
reg     [71:0] data_1stC_6;
reg     [71:0] data_1stC_7;
reg     [71:0] data_shift_00;
reg     [71:0] data_shift_01;
reg     [71:0] data_shift_02;
reg     [71:0] data_shift_10;
reg     [71:0] data_shift_11;
reg     [71:0] data_shift_12;
reg     [71:0] data_shift_20;
reg     [71:0] data_shift_21;
reg     [71:0] data_shift_22;
reg     [71:0] data_shift_30;
reg     [71:0] data_shift_31;
reg     [71:0] data_shift_32;
reg     [71:0] data_shift_40;
reg     [71:0] data_shift_41;
reg     [71:0] data_shift_42;
reg     [71:0] data_shift_50;
reg     [71:0] data_shift_51;
reg     [71:0] data_shift_52;
reg     [71:0] data_shift_60;
reg     [71:0] data_shift_61;
reg     [71:0] data_shift_62;
reg     [71:0] data_shift_70;
reg     [71:0] data_shift_71;
reg     [71:0] data_shift_72;
reg            data_shift_valid;
reg            hold_here;
reg            hold_here_dly;
reg      [3:0] is_pos_w_dly;
reg      [3:0] is_pos_w_dly2;
reg            last_c_align;
reg            last_c_dly1;
reg            last_h_align;
reg            last_h_dly1;
reg            last_w_align;
reg            last_w_dly1;
reg      [3:0] last_width;
reg            less2more_dly;
reg            less2more_dly2;
reg            more2less_dly;
reg    [230:0] normalz_buf_data;
reg            normalz_buf_data_pvld;
reg     [86:0] nvdla_cdp_rdma2dp_pd;
reg            nvdla_cdp_rdma2dp_valid;
reg     [86:0] p1_pipe_data;
reg     [86:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg     [86:0] p1_pipe_skid_data;
reg            p1_pipe_skid_ready;
reg            p1_pipe_skid_valid;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg     [86:0] p1_skid_data;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
reg    [230:0] p2_pipe_data;
reg    [230:0] p2_pipe_rand_data;
reg            p2_pipe_rand_ready;
reg            p2_pipe_rand_valid;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [230:0] p2_skid_data;
reg    [230:0] p2_skid_pipe_data;
reg            p2_skid_pipe_ready;
reg            p2_skid_pipe_valid;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
reg      [2:0] pos_c_align;
reg      [2:0] pos_c_dly1;
reg      [3:0] pos_w_align;
reg      [3:0] pos_w_dly1;
reg      [2:0] stat_cur;
reg      [2:0] stat_cur_dly;
reg      [2:0] stat_cur_dly2;
reg      [2:0] stat_nex;
reg      [3:0] width_align;
reg      [3:0] width_cur_1;
reg      [3:0] width_cur_2;
reg      [3:0] width_dly1;
reg      [3:0] width_pre;
reg      [3:0] width_pre_cnt;
reg      [3:0] width_pre_cnt_dly;
reg      [3:0] width_pre_dly;
reg      [3:0] width_pre_dly2;
wire           FIRST_C_bf_end;
wire           FIRST_C_end;
wire           buf_dat_rdy;
wire   [230:0] buffer_pd;
wire           buffer_valid;
wire           cube_done;
wire           data_shift_load;
wire           data_shift_load_all;
wire           data_shift_ready;
wire           dp_b_sync;
wire    [71:0] dp_data;
wire           dp_last_c;
wire           dp_last_h;
wire           dp_last_w;
wire     [2:0] dp_pos_c;
wire     [3:0] dp_pos_w;
wire     [3:0] dp_width;
wire           is_b_sync;
wire           is_last_c;
wire           is_last_h;
wire           is_last_w;
wire     [2:0] is_pos_c;
wire     [3:0] is_pos_w;
wire     [3:0] is_width;
wire     [3:0] is_width_f;
wire           l2m_1stC_vld;
wire           less2more;
wire           load_din;
wire           load_din_full;
wire           more2less;
wire           nvdla_cdp_rdma2dp_ready;
wire           rdma2dp_ready_normal;
wire           rdma2dp_valid_rebuild;
wire           vld;
wire     [3:0] width_cur;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    /////////////////////////////////////////////////////////////
//
parameter cvt2buf_data_bw = 72;
parameter cvt2buf_info_bw = 15;
parameter cvt2buf_dp_bw = cvt2buf_data_bw + cvt2buf_info_bw;

/////////////////////////////////////////////////////////////
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     cdp_rdma2dp_valid
  or p1_pipe_rand_ready
  or cdp_rdma2dp_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = cdp_rdma2dp_valid;
  cdp_rdma2dp_ready = p1_pipe_rand_ready;
  p1_pipe_rand_data = cdp_rdma2dp_pd[cvt2buf_dp_bw-1:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : cdp_rdma2dp_valid;
  cdp_rdma2dp_ready = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : cdp_rdma2dp_pd[cvt2buf_dp_bw-1:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p1_pipe_stall_cycles;
integer p1_pipe_stall_probability;
integer p1_pipe_stall_cycles_min;
integer p1_pipe_stall_cycles_max;
initial begin
  p1_pipe_stall_cycles = 0;
  p1_pipe_stall_probability = 0;
  p1_pipe_stall_cycles_min = 1;
  p1_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or cdp_rdma2dp_valid
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && cdp_rdma2dp_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p1_pipe_rand_poised) begin
    if (p1_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p1_pipe_stall_cycles <= prand_inst1(p1_pipe_stall_cycles_min, p1_pipe_stall_cycles_max);
    end
  end else if (p1_pipe_rand_active) begin
    p1_pipe_stall_cycles <= p1_pipe_stall_cycles - 1;
  end else begin
    p1_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_pipe_rand_valid)? p1_pipe_rand_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_pipe_rand_ready = p1_pipe_ready_bc;
end
//## pipe (1) skid buffer
always @(
  p1_pipe_valid
  or p1_skid_ready_flop
  or p1_pipe_skid_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_valid && p1_skid_ready_flop && !p1_pipe_skid_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_pipe_skid_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_pipe_skid_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_valid
  or p1_skid_valid
  or p1_pipe_data
  or p1_skid_data
  ) begin
  p1_pipe_skid_valid = (p1_skid_ready_flop)? p1_pipe_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_pipe_skid_data = (p1_skid_ready_flop)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) output
always @(
  p1_pipe_skid_valid
  or nvdla_cdp_rdma2dp_ready
  or p1_pipe_skid_data
  ) begin
  nvdla_cdp_rdma2dp_valid = p1_pipe_skid_valid;
  p1_pipe_skid_ready = nvdla_cdp_rdma2dp_ready;
  nvdla_cdp_rdma2dp_pd = p1_pipe_skid_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (nvdla_cdp_rdma2dp_valid^nvdla_cdp_rdma2dp_ready^cdp_rdma2dp_valid^cdp_rdma2dp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (cdp_rdma2dp_valid && !cdp_rdma2dp_ready), (cdp_rdma2dp_valid), (cdp_rdma2dp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//==============
// INPUT UNPACK: from RDMA
//==============

// PKT_UNPACK_WIRE( cdp_cvt2buf , dp_ , nvdla_cdp_rdma2dp_pd )
assign       dp_data[71:0] =    nvdla_cdp_rdma2dp_pd[71:0];
assign       dp_pos_w[3:0] =    nvdla_cdp_rdma2dp_pd[75:72];
assign       dp_width[3:0] =    nvdla_cdp_rdma2dp_pd[79:76];
assign       dp_pos_c[2:0] =    nvdla_cdp_rdma2dp_pd[82:80];
assign        dp_b_sync  =    nvdla_cdp_rdma2dp_pd[83];
assign        dp_last_w  =    nvdla_cdp_rdma2dp_pd[84];
assign        dp_last_h  =    nvdla_cdp_rdma2dp_pd[85];
assign        dp_last_c  =    nvdla_cdp_rdma2dp_pd[86];

assign is_pos_w       = dp_pos_w;
assign is_width_f     = dp_width[3:0];
assign is_width[3:0]  = is_width_f - 1'b1;
assign is_pos_c  = dp_pos_c;
assign is_b_sync = dp_b_sync ;
assign is_last_w = dp_last_w ;
assign is_last_h = dp_last_h ;
assign is_last_c = dp_last_c ;

///////////////////////////////////////////////////
assign nvdla_cdp_rdma2dp_ready = rdma2dp_ready_normal & (~hold_here);
assign rdma2dp_valid_rebuild = nvdla_cdp_rdma2dp_valid | hold_here;

assign vld = rdma2dp_valid_rebuild;
assign load_din = vld & nvdla_cdp_rdma2dp_ready;
assign load_din_full = rdma2dp_valid_rebuild & rdma2dp_ready_normal;

//FSM for different process according to data position with the cube

  //## fsm (1) output


  //## fsm (1) defines

  localparam WAIT = 3'b000;
  localparam NORMAL_C = 3'b001;
  localparam FIRST_C = 3'b010;
  localparam SECOND_C = 3'b011;
  localparam CUBE_END = 3'b100;

  //## fsm (1) com block

  always @(
    stat_cur
    or is_b_sync
    or is_pos_c
    or load_din
    or is_last_c
    or is_last_h
    or is_last_w
    or is_pos_w
    or is_width
    or more2less
    or width_pre_cnt
    or width_pre
    or hold_here
    or rdma2dp_ready_normal
    or cube_done
    ) begin
    stat_nex = stat_cur;
    NormalC2CubeEnd = 0;
    begin
      casez (stat_cur)
        WAIT: begin
          if ((is_b_sync & (is_pos_c==3'd0) & load_din)) begin
            stat_nex = NORMAL_C; 
          end
          `ifndef SYNTHESIS
          // VCS coverage off
          else if (((is_b_sync & (is_pos_c==3'd0) & load_din)) === 1'bx) begin
            stat_nex = 'bx;
          end
          // VCS coverage on
          `endif
        end
        NORMAL_C: begin
          if ((is_b_sync & (is_pos_c==3'd3) & is_last_c & is_last_h & is_last_w & load_din)) begin
            NormalC2CubeEnd = 1;
            stat_nex = CUBE_END; 
          end
          `ifndef SYNTHESIS
          // VCS coverage off
          else if (((is_b_sync & (is_pos_c==3'd3) & is_last_c & is_last_h & is_last_w & load_din)) === 1'bx) begin
            stat_nex = 'bx;
            NormalC2CubeEnd = 'bx;
          end
          // VCS coverage on
          `endif
          else if ((is_b_sync & (is_pos_c==3'd3) & is_last_c) & (~(is_last_h & is_last_w) & load_din)) begin
            stat_nex = FIRST_C; 
          end
          `ifndef SYNTHESIS
          // VCS coverage off
          else if (((is_b_sync & (is_pos_c==3'd3) & is_last_c) & (~(is_last_h & is_last_w) & load_din)) === 1'bx) begin
            stat_nex = 'bx;
          end
          // VCS coverage on
          `endif
        end
        FIRST_C: begin
          if (((is_pos_w == is_width) & (~more2less) & load_din)
                  ||(more2less & (width_pre_cnt == width_pre) & hold_here & rdma2dp_ready_normal)) begin
            stat_nex = SECOND_C; 
          end
          `ifndef SYNTHESIS
          // VCS coverage off
          else if ((((is_pos_w == is_width) & (~more2less) & load_din)
                  ||(more2less & (width_pre_cnt == width_pre) & hold_here & rdma2dp_ready_normal)) === 1'bx) begin
            stat_nex = 'bx;
          end
          // VCS coverage on
          `endif
        end
        SECOND_C: begin
          if (is_b_sync & load_din) begin
            stat_nex = NORMAL_C; 
          end
          `ifndef SYNTHESIS
          // VCS coverage off
          else if ((is_b_sync & load_din) === 1'bx) begin
            stat_nex = 'bx;
          end
          // VCS coverage on
          `endif
        end
        CUBE_END: begin
          if (cube_done) begin
            stat_nex = WAIT; 
          end
          `ifndef SYNTHESIS
          // VCS coverage off
          else if ((cube_done) === 1'bx) begin
            stat_nex = 'bx;
          end
          // VCS coverage on
          `endif
        end
        // VCS coverage off
        default: begin
          stat_nex = WAIT; 
          `ifndef SYNTHESIS
          stat_nex = {3{1'bx}};
          `endif
        end
        // VCS coverage on
      endcase
    end
  end

  //## fsm (1) seq block

  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
      stat_cur <= WAIT;
    end else begin
    stat_cur <= stat_nex;
    end
  end

  //## fsm (1) reachable testpoints


  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__state_reachable_WAIT_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__state_reachable_WAIT_OR_COVER
    `endif // COVER

    `ifdef TP__state_reachable_WAIT
      `define COVER_OR_TP__state_reachable_WAIT_OR_COVER
    `endif // TP__state_reachable_WAIT

  `ifdef COVER_OR_TP__state_reachable_WAIT_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="state_reachable_WAIT"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_0_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_0_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_0_internal_nvdla_core_rstn
      //  Clock signal: testpoint_0_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_0_internal_nvdla_core_clk or negedge testpoint_0_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_0
          if (~testpoint_0_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_0_count_0;

      reg testpoint_0_goal_0;
      initial testpoint_0_goal_0 = 0;
      initial testpoint_0_count_0 = 0;
      always@(testpoint_0_count_0) begin
          if(testpoint_0_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_0_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: state_reachable_WAIT ::: stat_cur==WAIT");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: state_reachable_WAIT ::: testpoint_0_goal_0
              testpoint_0_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_0_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_0_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
          if (testpoint_0_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if ((stat_cur==WAIT) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: state_reachable_WAIT ::: testpoint_0_goal_0");
   `endif
              if ((stat_cur==WAIT) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                  testpoint_0_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk) begin
   `endif
                  testpoint_0_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_0_goal_0_active = ((stat_cur==WAIT) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
   `else
      system_verilog_testpoint svt_state_reachable_WAIT_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__state_reachable_WAIT_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__state_reachable_NORMAL_C_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__state_reachable_NORMAL_C_OR_COVER
    `endif // COVER

    `ifdef TP__state_reachable_NORMAL_C
      `define COVER_OR_TP__state_reachable_NORMAL_C_OR_COVER
    `endif // TP__state_reachable_NORMAL_C

  `ifdef COVER_OR_TP__state_reachable_NORMAL_C_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="state_reachable_NORMAL_C"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_1_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_1_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_1_internal_nvdla_core_rstn
      //  Clock signal: testpoint_1_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_1_internal_nvdla_core_clk or negedge testpoint_1_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_1
          if (~testpoint_1_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_1_count_0;

      reg testpoint_1_goal_0;
      initial testpoint_1_goal_0 = 0;
      initial testpoint_1_count_0 = 0;
      always@(testpoint_1_count_0) begin
          if(testpoint_1_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_1_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: state_reachable_NORMAL_C ::: stat_cur==NORMAL_C");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: state_reachable_NORMAL_C ::: testpoint_1_goal_0
              testpoint_1_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_1_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_1_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
          if (testpoint_1_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if ((stat_cur==NORMAL_C) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: state_reachable_NORMAL_C ::: testpoint_1_goal_0");
   `endif
              if ((stat_cur==NORMAL_C) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                  testpoint_1_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk) begin
   `endif
                  testpoint_1_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_1_goal_0_active = ((stat_cur==NORMAL_C) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
   `else
      system_verilog_testpoint svt_state_reachable_NORMAL_C_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__state_reachable_NORMAL_C_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__state_reachable_FIRST_C_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__state_reachable_FIRST_C_OR_COVER
    `endif // COVER

    `ifdef TP__state_reachable_FIRST_C
      `define COVER_OR_TP__state_reachable_FIRST_C_OR_COVER
    `endif // TP__state_reachable_FIRST_C

  `ifdef COVER_OR_TP__state_reachable_FIRST_C_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="state_reachable_FIRST_C"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_2_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_2_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_2_internal_nvdla_core_rstn
      //  Clock signal: testpoint_2_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_2_internal_nvdla_core_clk or negedge testpoint_2_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_2
          if (~testpoint_2_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_2_count_0;

      reg testpoint_2_goal_0;
      initial testpoint_2_goal_0 = 0;
      initial testpoint_2_count_0 = 0;
      always@(testpoint_2_count_0) begin
          if(testpoint_2_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_2_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: state_reachable_FIRST_C ::: stat_cur==FIRST_C");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: state_reachable_FIRST_C ::: testpoint_2_goal_0
              testpoint_2_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_2_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_2_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_2
          if (testpoint_2_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if ((stat_cur==FIRST_C) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: state_reachable_FIRST_C ::: testpoint_2_goal_0");
   `endif
              if ((stat_cur==FIRST_C) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                  testpoint_2_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk) begin
   `endif
                  testpoint_2_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_2_goal_0_active = ((stat_cur==FIRST_C) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
   `else
      system_verilog_testpoint svt_state_reachable_FIRST_C_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__state_reachable_FIRST_C_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__state_reachable_SECOND_C_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__state_reachable_SECOND_C_OR_COVER
    `endif // COVER

    `ifdef TP__state_reachable_SECOND_C
      `define COVER_OR_TP__state_reachable_SECOND_C_OR_COVER
    `endif // TP__state_reachable_SECOND_C

  `ifdef COVER_OR_TP__state_reachable_SECOND_C_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="state_reachable_SECOND_C"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_3_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_3_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_3_internal_nvdla_core_rstn
      //  Clock signal: testpoint_3_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_3_internal_nvdla_core_clk or negedge testpoint_3_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_3
          if (~testpoint_3_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_3_count_0;

      reg testpoint_3_goal_0;
      initial testpoint_3_goal_0 = 0;
      initial testpoint_3_count_0 = 0;
      always@(testpoint_3_count_0) begin
          if(testpoint_3_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_3_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: state_reachable_SECOND_C ::: stat_cur==SECOND_C");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: state_reachable_SECOND_C ::: testpoint_3_goal_0
              testpoint_3_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_3_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_3_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_3
          if (testpoint_3_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if ((stat_cur==SECOND_C) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: state_reachable_SECOND_C ::: testpoint_3_goal_0");
   `endif
              if ((stat_cur==SECOND_C) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                  testpoint_3_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk) begin
   `endif
                  testpoint_3_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_3_goal_0_active = ((stat_cur==SECOND_C) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
   `else
      system_verilog_testpoint svt_state_reachable_SECOND_C_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__state_reachable_SECOND_C_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__state_reachable_CUBE_END_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__state_reachable_CUBE_END_OR_COVER
    `endif // COVER

    `ifdef TP__state_reachable_CUBE_END
      `define COVER_OR_TP__state_reachable_CUBE_END_OR_COVER
    `endif // TP__state_reachable_CUBE_END

  `ifdef COVER_OR_TP__state_reachable_CUBE_END_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="state_reachable_CUBE_END"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_4_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_4_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_4_internal_nvdla_core_rstn
      //  Clock signal: testpoint_4_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_4_internal_nvdla_core_clk or negedge testpoint_4_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_4
          if (~testpoint_4_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_4_count_0;

      reg testpoint_4_goal_0;
      initial testpoint_4_goal_0 = 0;
      initial testpoint_4_count_0 = 0;
      always@(testpoint_4_count_0) begin
          if(testpoint_4_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_4_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: state_reachable_CUBE_END ::: stat_cur==CUBE_END");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: state_reachable_CUBE_END ::: testpoint_4_goal_0
              testpoint_4_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_4_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_4_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_4
          if (testpoint_4_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if ((stat_cur==CUBE_END) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: state_reachable_CUBE_END ::: testpoint_4_goal_0");
   `endif
              if ((stat_cur==CUBE_END) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                  testpoint_4_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk) begin
   `endif
                  testpoint_4_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_4_goal_0_active = ((stat_cur==CUBE_END) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_4_goal_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
   `else
      system_verilog_testpoint svt_state_reachable_CUBE_END_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__state_reachable_CUBE_END_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END

  //## fsm (1) transition testpoints

  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__transition_WAIT__to__NORMAL_C_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__transition_WAIT__to__NORMAL_C_OR_COVER
    `endif // COVER

    `ifdef TP__transition_WAIT__to__NORMAL_C
      `define COVER_OR_TP__transition_WAIT__to__NORMAL_C_OR_COVER
    `endif // TP__transition_WAIT__to__NORMAL_C

  `ifdef COVER_OR_TP__transition_WAIT__to__NORMAL_C_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="transition_WAIT__to__NORMAL_C"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_5_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_5_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_5_internal_nvdla_core_rstn
      //  Clock signal: testpoint_5_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_5_internal_nvdla_core_clk or negedge testpoint_5_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_5
          if (~testpoint_5_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_5_count_0;

      reg testpoint_5_goal_0;
      initial testpoint_5_goal_0 = 0;
      initial testpoint_5_count_0 = 0;
      always@(testpoint_5_count_0) begin
          if(testpoint_5_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_5_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: transition_WAIT__to__NORMAL_C ::: (stat_cur==WAIT) && (stat_nex == NORMAL_C)");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: transition_WAIT__to__NORMAL_C ::: testpoint_5_goal_0
              testpoint_5_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_5_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_5_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_5
          if (testpoint_5_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if (((stat_cur==WAIT) && (stat_nex == NORMAL_C)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: transition_WAIT__to__NORMAL_C ::: testpoint_5_goal_0");
   `endif
              if (((stat_cur==WAIT) && (stat_nex == NORMAL_C)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                  testpoint_5_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk) begin
   `endif
                  testpoint_5_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_5_goal_0_active = (((stat_cur==WAIT) && (stat_nex == NORMAL_C)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_5_goal_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
   `else
      system_verilog_testpoint svt_transition_WAIT__to__NORMAL_C_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__transition_WAIT__to__NORMAL_C_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__self_transition_WAIT__to__WAIT_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__self_transition_WAIT__to__WAIT_OR_COVER
    `endif // COVER

    `ifdef TP__self_transition_WAIT__to__WAIT
      `define COVER_OR_TP__self_transition_WAIT__to__WAIT_OR_COVER
    `endif // TP__self_transition_WAIT__to__WAIT

  `ifdef COVER_OR_TP__self_transition_WAIT__to__WAIT_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="self_transition_WAIT__to__WAIT"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_6_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_6_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_6_internal_nvdla_core_rstn
      //  Clock signal: testpoint_6_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_6_internal_nvdla_core_clk or negedge testpoint_6_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_6
          if (~testpoint_6_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_6_count_0;

      reg testpoint_6_goal_0;
      initial testpoint_6_goal_0 = 0;
      initial testpoint_6_count_0 = 0;
      always@(testpoint_6_count_0) begin
          if(testpoint_6_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_6_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: self_transition_WAIT__to__WAIT ::: stat_cur==WAIT && stat_nex==WAIT");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: self_transition_WAIT__to__WAIT ::: testpoint_6_goal_0
              testpoint_6_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_6_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_6_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_6
          if (testpoint_6_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if ((stat_cur==WAIT && stat_nex==WAIT) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: self_transition_WAIT__to__WAIT ::: testpoint_6_goal_0");
   `endif
              if ((stat_cur==WAIT && stat_nex==WAIT) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
                  testpoint_6_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk) begin
   `endif
                  testpoint_6_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_6_goal_0_active = ((stat_cur==WAIT && stat_nex==WAIT) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_6_goal_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
   `else
      system_verilog_testpoint svt_self_transition_WAIT__to__WAIT_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__self_transition_WAIT__to__WAIT_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__transition_NORMAL_C__to__CUBE_END_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__transition_NORMAL_C__to__CUBE_END_OR_COVER
    `endif // COVER

    `ifdef TP__transition_NORMAL_C__to__CUBE_END
      `define COVER_OR_TP__transition_NORMAL_C__to__CUBE_END_OR_COVER
    `endif // TP__transition_NORMAL_C__to__CUBE_END

  `ifdef COVER_OR_TP__transition_NORMAL_C__to__CUBE_END_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="transition_NORMAL_C__to__CUBE_END"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_7_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_7_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_7_internal_nvdla_core_rstn
      //  Clock signal: testpoint_7_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_7_internal_nvdla_core_clk or negedge testpoint_7_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_7
          if (~testpoint_7_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_7_count_0;

      reg testpoint_7_goal_0;
      initial testpoint_7_goal_0 = 0;
      initial testpoint_7_count_0 = 0;
      always@(testpoint_7_count_0) begin
          if(testpoint_7_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_7_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: transition_NORMAL_C__to__CUBE_END ::: (stat_cur==NORMAL_C) && (stat_nex == CUBE_END)");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: transition_NORMAL_C__to__CUBE_END ::: testpoint_7_goal_0
              testpoint_7_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_7_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_7_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_7
          if (testpoint_7_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if (((stat_cur==NORMAL_C) && (stat_nex == CUBE_END)) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: transition_NORMAL_C__to__CUBE_END ::: testpoint_7_goal_0");
   `endif
              if (((stat_cur==NORMAL_C) && (stat_nex == CUBE_END)) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
                  testpoint_7_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk) begin
   `endif
                  testpoint_7_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_7_goal_0_active = (((stat_cur==NORMAL_C) && (stat_nex == CUBE_END)) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_7_goal_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
   `else
      system_verilog_testpoint svt_transition_NORMAL_C__to__CUBE_END_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__transition_NORMAL_C__to__CUBE_END_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__transition_NORMAL_C__to__FIRST_C_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__transition_NORMAL_C__to__FIRST_C_OR_COVER
    `endif // COVER

    `ifdef TP__transition_NORMAL_C__to__FIRST_C
      `define COVER_OR_TP__transition_NORMAL_C__to__FIRST_C_OR_COVER
    `endif // TP__transition_NORMAL_C__to__FIRST_C

  `ifdef COVER_OR_TP__transition_NORMAL_C__to__FIRST_C_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="transition_NORMAL_C__to__FIRST_C"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_8_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_8_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_8_internal_nvdla_core_rstn
      //  Clock signal: testpoint_8_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_8_internal_nvdla_core_clk or negedge testpoint_8_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_8
          if (~testpoint_8_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_8_count_0;

      reg testpoint_8_goal_0;
      initial testpoint_8_goal_0 = 0;
      initial testpoint_8_count_0 = 0;
      always@(testpoint_8_count_0) begin
          if(testpoint_8_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_8_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: transition_NORMAL_C__to__FIRST_C ::: (stat_cur==NORMAL_C) && (stat_nex == FIRST_C)");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: transition_NORMAL_C__to__FIRST_C ::: testpoint_8_goal_0
              testpoint_8_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_8_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_8_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_8
          if (testpoint_8_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if (((stat_cur==NORMAL_C) && (stat_nex == FIRST_C)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: transition_NORMAL_C__to__FIRST_C ::: testpoint_8_goal_0");
   `endif
              if (((stat_cur==NORMAL_C) && (stat_nex == FIRST_C)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
                  testpoint_8_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk) begin
   `endif
                  testpoint_8_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_8_goal_0_active = (((stat_cur==NORMAL_C) && (stat_nex == FIRST_C)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_8_goal_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
   `else
      system_verilog_testpoint svt_transition_NORMAL_C__to__FIRST_C_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__transition_NORMAL_C__to__FIRST_C_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__self_transition_NORMAL_C__to__NORMAL_C_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__self_transition_NORMAL_C__to__NORMAL_C_OR_COVER
    `endif // COVER

    `ifdef TP__self_transition_NORMAL_C__to__NORMAL_C
      `define COVER_OR_TP__self_transition_NORMAL_C__to__NORMAL_C_OR_COVER
    `endif // TP__self_transition_NORMAL_C__to__NORMAL_C

  `ifdef COVER_OR_TP__self_transition_NORMAL_C__to__NORMAL_C_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="self_transition_NORMAL_C__to__NORMAL_C"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_9_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_9_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_9_internal_nvdla_core_rstn
      //  Clock signal: testpoint_9_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_9_internal_nvdla_core_clk or negedge testpoint_9_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_9
          if (~testpoint_9_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_9_count_0;

      reg testpoint_9_goal_0;
      initial testpoint_9_goal_0 = 0;
      initial testpoint_9_count_0 = 0;
      always@(testpoint_9_count_0) begin
          if(testpoint_9_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_9_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: self_transition_NORMAL_C__to__NORMAL_C ::: stat_cur==NORMAL_C && stat_nex==NORMAL_C");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: self_transition_NORMAL_C__to__NORMAL_C ::: testpoint_9_goal_0
              testpoint_9_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_9_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_9_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_9
          if (testpoint_9_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if ((stat_cur==NORMAL_C && stat_nex==NORMAL_C) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: self_transition_NORMAL_C__to__NORMAL_C ::: testpoint_9_goal_0");
   `endif
              if ((stat_cur==NORMAL_C && stat_nex==NORMAL_C) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
                  testpoint_9_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk) begin
   `endif
                  testpoint_9_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_9_goal_0_active = ((stat_cur==NORMAL_C && stat_nex==NORMAL_C) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_9_goal_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
   `else
      system_verilog_testpoint svt_self_transition_NORMAL_C__to__NORMAL_C_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__self_transition_NORMAL_C__to__NORMAL_C_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__transition_FIRST_C__to__SECOND_C_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__transition_FIRST_C__to__SECOND_C_OR_COVER
    `endif // COVER

    `ifdef TP__transition_FIRST_C__to__SECOND_C
      `define COVER_OR_TP__transition_FIRST_C__to__SECOND_C_OR_COVER
    `endif // TP__transition_FIRST_C__to__SECOND_C

  `ifdef COVER_OR_TP__transition_FIRST_C__to__SECOND_C_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="transition_FIRST_C__to__SECOND_C"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_10_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_10_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_10_internal_nvdla_core_rstn
      //  Clock signal: testpoint_10_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_10_internal_nvdla_core_clk or negedge testpoint_10_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_10
          if (~testpoint_10_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_10_count_0;

      reg testpoint_10_goal_0;
      initial testpoint_10_goal_0 = 0;
      initial testpoint_10_count_0 = 0;
      always@(testpoint_10_count_0) begin
          if(testpoint_10_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_10_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: transition_FIRST_C__to__SECOND_C ::: (stat_cur==FIRST_C) && (stat_nex == SECOND_C)");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: transition_FIRST_C__to__SECOND_C ::: testpoint_10_goal_0
              testpoint_10_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_10_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_10_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_10
          if (testpoint_10_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if (((stat_cur==FIRST_C) && (stat_nex == SECOND_C)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: transition_FIRST_C__to__SECOND_C ::: testpoint_10_goal_0");
   `endif
              if (((stat_cur==FIRST_C) && (stat_nex == SECOND_C)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
                  testpoint_10_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk) begin
   `endif
                  testpoint_10_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_10_goal_0_active = (((stat_cur==FIRST_C) && (stat_nex == SECOND_C)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_10_goal_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
   `else
      system_verilog_testpoint svt_transition_FIRST_C__to__SECOND_C_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__transition_FIRST_C__to__SECOND_C_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__self_transition_FIRST_C__to__FIRST_C_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__self_transition_FIRST_C__to__FIRST_C_OR_COVER
    `endif // COVER

    `ifdef TP__self_transition_FIRST_C__to__FIRST_C
      `define COVER_OR_TP__self_transition_FIRST_C__to__FIRST_C_OR_COVER
    `endif // TP__self_transition_FIRST_C__to__FIRST_C

  `ifdef COVER_OR_TP__self_transition_FIRST_C__to__FIRST_C_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="self_transition_FIRST_C__to__FIRST_C"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_11_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_11_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_11_internal_nvdla_core_rstn
      //  Clock signal: testpoint_11_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_11_internal_nvdla_core_clk or negedge testpoint_11_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_11
          if (~testpoint_11_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_11_count_0;

      reg testpoint_11_goal_0;
      initial testpoint_11_goal_0 = 0;
      initial testpoint_11_count_0 = 0;
      always@(testpoint_11_count_0) begin
          if(testpoint_11_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_11_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: self_transition_FIRST_C__to__FIRST_C ::: stat_cur==FIRST_C && stat_nex==FIRST_C");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: self_transition_FIRST_C__to__FIRST_C ::: testpoint_11_goal_0
              testpoint_11_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_11_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_11_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_11
          if (testpoint_11_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if ((stat_cur==FIRST_C && stat_nex==FIRST_C) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: self_transition_FIRST_C__to__FIRST_C ::: testpoint_11_goal_0");
   `endif
              if ((stat_cur==FIRST_C && stat_nex==FIRST_C) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
                  testpoint_11_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk) begin
   `endif
                  testpoint_11_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_11_goal_0_active = ((stat_cur==FIRST_C && stat_nex==FIRST_C) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_11_goal_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
   `else
      system_verilog_testpoint svt_self_transition_FIRST_C__to__FIRST_C_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__self_transition_FIRST_C__to__FIRST_C_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__transition_SECOND_C__to__NORMAL_C_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__transition_SECOND_C__to__NORMAL_C_OR_COVER
    `endif // COVER

    `ifdef TP__transition_SECOND_C__to__NORMAL_C
      `define COVER_OR_TP__transition_SECOND_C__to__NORMAL_C_OR_COVER
    `endif // TP__transition_SECOND_C__to__NORMAL_C

  `ifdef COVER_OR_TP__transition_SECOND_C__to__NORMAL_C_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="transition_SECOND_C__to__NORMAL_C"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_12_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_12_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_12_internal_nvdla_core_rstn
      //  Clock signal: testpoint_12_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_12_internal_nvdla_core_clk or negedge testpoint_12_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_12
          if (~testpoint_12_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_12_count_0;

      reg testpoint_12_goal_0;
      initial testpoint_12_goal_0 = 0;
      initial testpoint_12_count_0 = 0;
      always@(testpoint_12_count_0) begin
          if(testpoint_12_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_12_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: transition_SECOND_C__to__NORMAL_C ::: (stat_cur==SECOND_C) && (stat_nex == NORMAL_C)");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: transition_SECOND_C__to__NORMAL_C ::: testpoint_12_goal_0
              testpoint_12_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_12_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_12_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_12
          if (testpoint_12_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if (((stat_cur==SECOND_C) && (stat_nex == NORMAL_C)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: transition_SECOND_C__to__NORMAL_C ::: testpoint_12_goal_0");
   `endif
              if (((stat_cur==SECOND_C) && (stat_nex == NORMAL_C)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
                  testpoint_12_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk) begin
   `endif
                  testpoint_12_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_12_goal_0_active = (((stat_cur==SECOND_C) && (stat_nex == NORMAL_C)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_12_goal_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
   `else
      system_verilog_testpoint svt_transition_SECOND_C__to__NORMAL_C_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__transition_SECOND_C__to__NORMAL_C_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__self_transition_SECOND_C__to__SECOND_C_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__self_transition_SECOND_C__to__SECOND_C_OR_COVER
    `endif // COVER

    `ifdef TP__self_transition_SECOND_C__to__SECOND_C
      `define COVER_OR_TP__self_transition_SECOND_C__to__SECOND_C_OR_COVER
    `endif // TP__self_transition_SECOND_C__to__SECOND_C

  `ifdef COVER_OR_TP__self_transition_SECOND_C__to__SECOND_C_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="self_transition_SECOND_C__to__SECOND_C"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_13_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_13_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_13_internal_nvdla_core_rstn
      //  Clock signal: testpoint_13_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_13_internal_nvdla_core_clk or negedge testpoint_13_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_13
          if (~testpoint_13_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_13_count_0;

      reg testpoint_13_goal_0;
      initial testpoint_13_goal_0 = 0;
      initial testpoint_13_count_0 = 0;
      always@(testpoint_13_count_0) begin
          if(testpoint_13_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_13_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: self_transition_SECOND_C__to__SECOND_C ::: stat_cur==SECOND_C && stat_nex==SECOND_C");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: self_transition_SECOND_C__to__SECOND_C ::: testpoint_13_goal_0
              testpoint_13_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_13_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_13_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_13
          if (testpoint_13_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if ((stat_cur==SECOND_C && stat_nex==SECOND_C) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: self_transition_SECOND_C__to__SECOND_C ::: testpoint_13_goal_0");
   `endif
              if ((stat_cur==SECOND_C && stat_nex==SECOND_C) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk)
                  testpoint_13_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk) begin
   `endif
                  testpoint_13_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_13_goal_0_active = ((stat_cur==SECOND_C && stat_nex==SECOND_C) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_13_goal_0 (.clk (testpoint_13_internal_nvdla_core_clk), .tp(testpoint_13_goal_0_active));
   `else
      system_verilog_testpoint svt_self_transition_SECOND_C__to__SECOND_C_0 (.clk (testpoint_13_internal_nvdla_core_clk), .tp(testpoint_13_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__self_transition_SECOND_C__to__SECOND_C_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__transition_CUBE_END__to__WAIT_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__transition_CUBE_END__to__WAIT_OR_COVER
    `endif // COVER

    `ifdef TP__transition_CUBE_END__to__WAIT
      `define COVER_OR_TP__transition_CUBE_END__to__WAIT_OR_COVER
    `endif // TP__transition_CUBE_END__to__WAIT

  `ifdef COVER_OR_TP__transition_CUBE_END__to__WAIT_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="transition_CUBE_END__to__WAIT"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_14_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_14_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_14_internal_nvdla_core_rstn_with_clock_testpoint_14_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_14_internal_nvdla_core_rstn
      //  Clock signal: testpoint_14_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_14_internal_nvdla_core_rstn_with_clock_testpoint_14_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_14_internal_nvdla_core_rstn_with_clock_testpoint_14_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_14_internal_nvdla_core_clk or negedge testpoint_14_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_14
          if (~testpoint_14_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_14_internal_nvdla_core_rstn_with_clock_testpoint_14_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_14_count_0;

      reg testpoint_14_goal_0;
      initial testpoint_14_goal_0 = 0;
      initial testpoint_14_count_0 = 0;
      always@(testpoint_14_count_0) begin
          if(testpoint_14_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_14_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: transition_CUBE_END__to__WAIT ::: (stat_cur==CUBE_END) && (stat_nex == WAIT)");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: transition_CUBE_END__to__WAIT ::: testpoint_14_goal_0
              testpoint_14_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_14_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_14_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_14
          if (testpoint_14_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if (((stat_cur==CUBE_END) && (stat_nex == WAIT)) && testpoint_got_reset_testpoint_14_internal_nvdla_core_rstn_with_clock_testpoint_14_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: transition_CUBE_END__to__WAIT ::: testpoint_14_goal_0");
   `endif
              if (((stat_cur==CUBE_END) && (stat_nex == WAIT)) && testpoint_got_reset_testpoint_14_internal_nvdla_core_rstn_with_clock_testpoint_14_internal_nvdla_core_clk)
                  testpoint_14_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_14_internal_nvdla_core_rstn_with_clock_testpoint_14_internal_nvdla_core_clk) begin
   `endif
                  testpoint_14_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_14_goal_0_active = (((stat_cur==CUBE_END) && (stat_nex == WAIT)) && testpoint_got_reset_testpoint_14_internal_nvdla_core_rstn_with_clock_testpoint_14_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_14_goal_0 (.clk (testpoint_14_internal_nvdla_core_clk), .tp(testpoint_14_goal_0_active));
   `else
      system_verilog_testpoint svt_transition_CUBE_END__to__WAIT_0 (.clk (testpoint_14_internal_nvdla_core_clk), .tp(testpoint_14_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__transition_CUBE_END__to__WAIT_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END
  `ifndef DISABLE_TESTPOINTS
    `ifdef COVER
      `define COVER_OR_TP__self_transition_CUBE_END__to__CUBE_END_OR_COVER
    `endif // COVER

    `ifdef COVER
      `define COVER_OR_TP__self_transition_CUBE_END__to__CUBE_END_OR_COVER
    `endif // COVER

    `ifdef TP__self_transition_CUBE_END__to__CUBE_END
      `define COVER_OR_TP__self_transition_CUBE_END__to__CUBE_END_OR_COVER
    `endif // TP__self_transition_CUBE_END__to__CUBE_END

  `ifdef COVER_OR_TP__self_transition_CUBE_END__to__CUBE_END_OR_COVER


  //VCS coverage off
      // TESTPOINT_START
      // NAME="self_transition_CUBE_END__to__CUBE_END"
      // TYPE=OCCURRENCE
      // AUTOGEN=true
      // COUNT=1
      // GROUP="DEFAULT"
      // INFO=""
      // RANDOM_COVER=true
      // ASYNC_RESET=1
      // ACTIVE_HIGH_RESET=0
  wire testpoint_15_internal_nvdla_core_clk   = nvdla_core_clk;
  wire testpoint_15_internal_nvdla_core_rstn = nvdla_core_rstn;

  `ifdef FV_COVER_ON
      // Synthesizable code for SFV.
      wire testpoint_got_reset_testpoint_15_internal_nvdla_core_rstn_with_clock_testpoint_15_internal_nvdla_core_clk = 1'b1;
  `else
      // Must be clocked with reset active before we start gathering
      // coverage.
      //  Reset signal: testpoint_15_internal_nvdla_core_rstn
      //  Clock signal: testpoint_15_internal_nvdla_core_clk
      reg testpoint_got_reset_testpoint_15_internal_nvdla_core_rstn_with_clock_testpoint_15_internal_nvdla_core_clk;

      initial
          testpoint_got_reset_testpoint_15_internal_nvdla_core_rstn_with_clock_testpoint_15_internal_nvdla_core_clk <= 1'b0;

      always @(posedge testpoint_15_internal_nvdla_core_clk or negedge testpoint_15_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_15
          if (~testpoint_15_internal_nvdla_core_rstn)
              testpoint_got_reset_testpoint_15_internal_nvdla_core_rstn_with_clock_testpoint_15_internal_nvdla_core_clk <= 1'b1;
      end
  `endif

  `ifndef LINE_TESTPOINTS_OFF
      reg testpoint_15_count_0;

      reg testpoint_15_goal_0;
      initial testpoint_15_goal_0 = 0;
      initial testpoint_15_count_0 = 0;
      always@(testpoint_15_count_0) begin
          if(testpoint_15_count_0 >= 1)
           begin
   `ifdef COVER_PRINT_TESTPOINT_HITS
              if (testpoint_15_goal_0 != 1'b1)
                  $display("TESTPOINT_HIT: NV_NVDLA_CDP_DP_bufferin ::: self_transition_CUBE_END__to__CUBE_END ::: stat_cur==CUBE_END && stat_nex==CUBE_END");
   `endif
              //VCS coverage on
              //coverage name NV_NVDLA_CDP_DP_bufferin ::: self_transition_CUBE_END__to__CUBE_END ::: testpoint_15_goal_0
              testpoint_15_goal_0 = 1'b1;
              //VCS coverage off
          end
          else
              testpoint_15_goal_0 = 1'b0;
      end

      // Increment counters for every condition that's true this clock.
      always @(posedge testpoint_15_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_15
          if (testpoint_15_internal_nvdla_core_rstn) begin
   `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
              if ((stat_cur==CUBE_END && stat_nex==CUBE_END) && testpoint_got_reset_testpoint_15_internal_nvdla_core_rstn_with_clock_testpoint_15_internal_nvdla_core_clk)
                  $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_DP_bufferin ::: self_transition_CUBE_END__to__CUBE_END ::: testpoint_15_goal_0");
   `endif
              if ((stat_cur==CUBE_END && stat_nex==CUBE_END) && testpoint_got_reset_testpoint_15_internal_nvdla_core_rstn_with_clock_testpoint_15_internal_nvdla_core_clk)
                  testpoint_15_count_0 <= 1'd1;
          end
          else begin
   `ifndef FV_COVER_ON
              if (!testpoint_got_reset_testpoint_15_internal_nvdla_core_rstn_with_clock_testpoint_15_internal_nvdla_core_clk) begin
   `endif
                  testpoint_15_count_0 <= 1'd0;
   `ifndef FV_COVER_ON
              end
   `endif
          end
      end
  `endif // LINE_TESTPOINTS_OFF

  `ifndef SV_TESTPOINTS_OFF
      wire testpoint_15_goal_0_active = ((stat_cur==CUBE_END && stat_nex==CUBE_END) && testpoint_got_reset_testpoint_15_internal_nvdla_core_rstn_with_clock_testpoint_15_internal_nvdla_core_clk);

      // system verilog testpoints, to leverage vcs testpoint coverage tools
   `ifndef SV_TESTPOINTS_DESCRIPTIVE
      system_verilog_testpoint svt_testpoint_15_goal_0 (.clk (testpoint_15_internal_nvdla_core_clk), .tp(testpoint_15_goal_0_active));
   `else
      system_verilog_testpoint svt_self_transition_CUBE_END__to__CUBE_END_0 (.clk (testpoint_15_internal_nvdla_core_clk), .tp(testpoint_15_goal_0_active));
   `endif
  `endif

      //VCS coverage on
  `endif //COVER_OR_TP__self_transition_CUBE_END__to__CUBE_END_OR_COVER
  `endif //  DISABLE_TESTPOINTS

      // TESTPOINT_END

  //## fsm (1) assertions

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
    nv_assert_no_x #(0,3,0,"No Xs allowed on stat_cur")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1, stat_cur); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////////////////////////////
assign rdma2dp_ready_normal = (~data_shift_valid) | data_shift_ready; 

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_shift_valid <= 1'b0;
  end else begin
        if(vld)
            data_shift_valid <= 1'b1;
        else if(data_shift_ready)
            data_shift_valid <= 1'b0;
  end
end
assign data_shift_ready =(~buf_dat_vld | buf_dat_rdy);

assign data_shift_load_all = data_shift_ready & data_shift_valid;
assign data_shift_load = data_shift_load_all & ((~hold_here_dly)  | (stat_cur_dly == CUBE_END));
/////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_shift_00 <= {72{1'b0}};
    data_shift_10 <= {72{1'b0}};
    data_shift_20 <= {72{1'b0}};
    data_shift_30 <= {72{1'b0}};
    data_shift_40 <= {72{1'b0}};
    data_shift_50 <= {72{1'b0}};
    data_shift_60 <= {72{1'b0}};
    data_shift_70 <= {72{1'b0}};
    data_shift_01 <= {72{1'b0}};
    data_shift_02 <= {72{1'b0}};
    data_shift_11 <= {72{1'b0}};
    data_shift_12 <= {72{1'b0}};
    data_shift_21 <= {72{1'b0}};
    data_shift_22 <= {72{1'b0}};
    data_shift_31 <= {72{1'b0}};
    data_shift_32 <= {72{1'b0}};
    data_shift_41 <= {72{1'b0}};
    data_shift_42 <= {72{1'b0}};
    data_shift_51 <= {72{1'b0}};
    data_shift_52 <= {72{1'b0}};
    data_shift_61 <= {72{1'b0}};
    data_shift_62 <= {72{1'b0}};
    data_shift_71 <= {72{1'b0}};
    data_shift_72 <= {72{1'b0}};
    data_1stC_0 <= {72{1'b0}};
    data_1stC_1 <= {72{1'b0}};
    data_1stC_2 <= {72{1'b0}};
    data_1stC_3 <= {72{1'b0}};
    data_1stC_4 <= {72{1'b0}};
    data_1stC_5 <= {72{1'b0}};
    data_1stC_6 <= {72{1'b0}};
    data_1stC_7 <= {72{1'b0}};
  end else begin
  case(stat_cur)
      WAIT: begin
          if(load_din) begin
              if(is_pos_w==4'd0) begin
                  data_shift_00 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd1) begin
                  data_shift_10 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd2) begin
                  data_shift_20 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd3) begin
                  data_shift_30 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd4) begin
                  data_shift_40 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd5) begin
                  data_shift_50 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd6) begin
                  data_shift_60 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd7) begin
                  data_shift_70 <= dp_data[cvt2buf_data_bw-1:0];
              end
                  data_shift_01 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_02 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_11 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_12 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_21 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_22 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_31 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_32 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_41 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_42 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_51 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_52 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_61 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_62 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_71 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_72 <= {cvt2buf_data_bw{1'd0}};
      end end
      NORMAL_C: begin
          if(load_din) begin
                      if(is_pos_w==4'd0) begin
                      data_shift_02 <= data_shift_01;
                      data_shift_01 <= data_shift_00;
                      data_shift_00 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd1) begin
                      data_shift_12 <= data_shift_11;
                      data_shift_11 <= data_shift_10;
                      data_shift_10 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd2) begin
                      data_shift_22 <= data_shift_21;
                      data_shift_21 <= data_shift_20;
                      data_shift_20 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd3) begin
                      data_shift_32 <= data_shift_31;
                      data_shift_31 <= data_shift_30;
                      data_shift_30 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd4) begin
                      data_shift_42 <= data_shift_41;
                      data_shift_41 <= data_shift_40;
                      data_shift_40 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd5) begin
                      data_shift_52 <= data_shift_51;
                      data_shift_51 <= data_shift_50;
                      data_shift_50 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd6) begin
                      data_shift_62 <= data_shift_61;
                      data_shift_61 <= data_shift_60;
                      data_shift_60 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd7) begin
                      data_shift_72 <= data_shift_71;
                      data_shift_71 <= data_shift_70;
                      data_shift_70 <= dp_data[cvt2buf_data_bw-1:0];
                      end
      end end
      FIRST_C: begin
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd0) begin
                                  data_shift_02 <= data_shift_01;
                                  data_shift_01 <= data_shift_00;
                                  data_shift_00 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd0) & load_din) begin
                                  data_1stC_0   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_02 <= data_shift_01;
                                  data_shift_01 <= data_shift_00;
                                  data_shift_00 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd1) begin
                                  data_shift_12 <= data_shift_11;
                                  data_shift_11 <= data_shift_10;
                                  data_shift_10 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd1) & load_din) begin
                                  data_1stC_1   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_12 <= data_shift_11;
                                  data_shift_11 <= data_shift_10;
                                  data_shift_10 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd2) begin
                                  data_shift_22 <= data_shift_21;
                                  data_shift_21 <= data_shift_20;
                                  data_shift_20 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd2) & load_din) begin
                                  data_1stC_2   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_22 <= data_shift_21;
                                  data_shift_21 <= data_shift_20;
                                  data_shift_20 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd3) begin
                                  data_shift_32 <= data_shift_31;
                                  data_shift_31 <= data_shift_30;
                                  data_shift_30 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd3) & load_din) begin
                                  data_1stC_3   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_32 <= data_shift_31;
                                  data_shift_31 <= data_shift_30;
                                  data_shift_30 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd4) begin
                                  data_shift_42 <= data_shift_41;
                                  data_shift_41 <= data_shift_40;
                                  data_shift_40 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd4) & load_din) begin
                                  data_1stC_4   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_42 <= data_shift_41;
                                  data_shift_41 <= data_shift_40;
                                  data_shift_40 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd5) begin
                                  data_shift_52 <= data_shift_51;
                                  data_shift_51 <= data_shift_50;
                                  data_shift_50 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd5) & load_din) begin
                                  data_1stC_5   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_52 <= data_shift_51;
                                  data_shift_51 <= data_shift_50;
                                  data_shift_50 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd6) begin
                                  data_shift_62 <= data_shift_61;
                                  data_shift_61 <= data_shift_60;
                                  data_shift_60 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd6) & load_din) begin
                                  data_1stC_6   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_62 <= data_shift_61;
                                  data_shift_61 <= data_shift_60;
                                  data_shift_60 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd7) begin
                                  data_shift_72 <= data_shift_71;
                                  data_shift_71 <= data_shift_70;
                                  data_shift_70 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd7) & load_din) begin
                                  data_1stC_7   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_72 <= data_shift_71;
                                  data_shift_71 <= data_shift_70;
                                  data_shift_70 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
      end// end
      SECOND_C: begin
          if(load_din) begin
                      if(is_pos_w==4'd0) begin
                      data_shift_02 <= 0;
                      data_shift_01 <= data_1stC_0;
                      data_shift_00 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd1) begin
                      data_shift_12 <= 0;
                      data_shift_11 <= data_1stC_1;
                      data_shift_10 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd2) begin
                      data_shift_22 <= 0;
                      data_shift_21 <= data_1stC_2;
                      data_shift_20 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd3) begin
                      data_shift_32 <= 0;
                      data_shift_31 <= data_1stC_3;
                      data_shift_30 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd4) begin
                      data_shift_42 <= 0;
                      data_shift_41 <= data_1stC_4;
                      data_shift_40 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd5) begin
                      data_shift_52 <= 0;
                      data_shift_51 <= data_1stC_5;
                      data_shift_50 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd6) begin
                      data_shift_62 <= 0;
                      data_shift_61 <= data_1stC_6;
                      data_shift_60 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd7) begin
                      data_shift_72 <= 0;
                      data_shift_71 <= data_1stC_7;
                      data_shift_70 <= dp_data[cvt2buf_data_bw-1:0];
                      end
      end end
      CUBE_END: begin
          if(rdma2dp_ready_normal) begin
                      if(cube_end_width_cnt==4'd0) begin
                      data_shift_02 <= data_shift_01;
                      data_shift_01 <= data_shift_00;
                      data_shift_00 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd1) begin
                      data_shift_12 <= data_shift_11;
                      data_shift_11 <= data_shift_10;
                      data_shift_10 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd2) begin
                      data_shift_22 <= data_shift_21;
                      data_shift_21 <= data_shift_20;
                      data_shift_20 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd3) begin
                      data_shift_32 <= data_shift_31;
                      data_shift_31 <= data_shift_30;
                      data_shift_30 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd4) begin
                      data_shift_42 <= data_shift_41;
                      data_shift_41 <= data_shift_40;
                      data_shift_40 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd5) begin
                      data_shift_52 <= data_shift_51;
                      data_shift_51 <= data_shift_50;
                      data_shift_50 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd6) begin
                      data_shift_62 <= data_shift_61;
                      data_shift_61 <= data_shift_60;
                      data_shift_60 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd7) begin
                      data_shift_72 <= data_shift_71;
                      data_shift_71 <= data_shift_70;
                      data_shift_70 <= {cvt2buf_data_bw{1'd0}};
                      end
      end end
      default: begin 
                      data_shift_02 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_01 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_00 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_0 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_12 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_11 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_10 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_1 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_22 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_21 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_20 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_2 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_32 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_31 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_30 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_3 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_42 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_41 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_40 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_4 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_52 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_51 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_50 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_5 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_62 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_61 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_60 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_6 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_72 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_71 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_70 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_7 <= {cvt2buf_data_bw{1'd0}};
      end
 endcase
   end
 end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_pre <= {4{1'b0}};
  end else begin
    if((stat_cur==NORMAL_C) & is_last_c & is_b_sync & (is_pos_c==3'd3) & load_din)
        width_pre <= is_width;
  end
end
always @(
  stat_cur
  or is_pos_w
  or is_width
  ) begin
    //if((stat_cur==FIRST_C) & (is_pos_w == 0) & load_din)
    if((stat_cur==FIRST_C) & (is_pos_w == 0))
        width_cur_1 = is_width;
    else
        width_cur_1 = 0;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_cur_2 <= {4{1'b0}};
  end else begin
    if((stat_cur==FIRST_C) & (is_pos_w == 0) & load_din)
        width_cur_2 <= is_width;
  end
end
//assign width_cur = ((stat_cur==FIRST_C) & (is_pos_w == 0) & load_din)? width_cur_1 : width_cur_2;
assign width_cur = ((stat_cur==FIRST_C) & (is_pos_w == 0))? width_cur_1 : width_cur_2;

assign more2less = (stat_cur==FIRST_C) & (width_cur<width_pre);
assign less2more = (stat_cur==FIRST_C) & (width_cur>width_pre);
assign l2m_1stC_vld = (stat_cur==FIRST_C) & less2more & (is_pos_w <= width_pre);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    hold_here <= 1'b0;
  end else begin
    if((stat_cur==FIRST_C) & more2less) begin
            if((is_pos_w==is_width) & load_din)
                hold_here <= 1;
            else if((width_pre_cnt == width_pre) & rdma2dp_ready_normal)
                hold_here <= 0;
    end else if(NormalC2CubeEnd)//stat_cur==CUBE_END)
            hold_here <= 1;
    else if(cube_done)
            hold_here <= 0;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_pre_cnt[3:0] <= {4{1'b0}};
  end else begin
    if((stat_cur==FIRST_C) & more2less) begin
        if((is_pos_w==is_width) & load_din)
            width_pre_cnt[3:0] <= is_width+4'd1;
        else if(hold_here & rdma2dp_ready_normal)
            width_pre_cnt[3:0] <= width_pre_cnt+4'd1;
    end else
        width_pre_cnt[3:0] <= 4'd0;
  end
end

//the last block data need to be output in cube end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_width <= {4{1'b0}};
  end else begin
    if(NormalC2CubeEnd & load_din)
        last_width <= is_width;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cube_end_width_cnt <= {4{1'b0}};
  end else begin
    if(stat_cur==CUBE_END) begin
        if(rdma2dp_ready_normal) begin
            if(cube_end_width_cnt == last_width)
                cube_end_width_cnt <= 4'd0;
            else
                cube_end_width_cnt <= cube_end_width_cnt + 1;
        end
    end else
        cube_end_width_cnt <= 4'd0;
  end
end

assign cube_done = (stat_cur==CUBE_END) && (cube_end_width_cnt == last_width) & rdma2dp_ready_normal;

//1pipe delay for buffer data generation

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stat_cur_dly <= {3{1'b0}};
  end else begin
  if ((load_din_full) == 1'b1) begin
    stat_cur_dly <= stat_cur;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    stat_cur_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    more2less_dly <= 1'b0;
  end else begin
  if ((load_din_full) == 1'b1) begin
    more2less_dly <= more2less;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    more2less_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    less2more_dly <= 1'b0;
  end else begin
  if ((load_din_full) == 1'b1) begin
    less2more_dly <= less2more;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    less2more_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    hold_here_dly <= 1'b0;
  end else begin
  if ((load_din_full) == 1'b1) begin
    hold_here_dly <= hold_here;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    hold_here_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_pos_w_dly <= {4{1'b0}};
  end else begin
    if((stat_cur == CUBE_END) & rdma2dp_ready_normal)
        is_pos_w_dly <= cube_end_width_cnt;
    else if(load_din)
        is_pos_w_dly <= is_pos_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_pre_cnt_dly <= {4{1'b0}};
  end else begin
  if ((load_din_full) == 1'b1) begin
    width_pre_cnt_dly <= width_pre_cnt;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    width_pre_cnt_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    width_pre_dly <= {4{1'b0}};
  end else begin
  if ((load_din_full) == 1'b1) begin
    width_pre_dly <= width_pre;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    width_pre_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////////////////
//buffer data generation for output data

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_data <= {216{1'b0}};
  end else begin
  if(((stat_cur_dly==NORMAL_C) || (stat_cur_dly==SECOND_C) || (stat_cur_dly==CUBE_END)) & data_shift_load) begin
      if(is_pos_w_dly==4'd0)
          buffer_data <= {data_shift_00,data_shift_01,data_shift_02};
      if(is_pos_w_dly==4'd1)
          buffer_data <= {data_shift_10,data_shift_11,data_shift_12};
      if(is_pos_w_dly==4'd2)
          buffer_data <= {data_shift_20,data_shift_21,data_shift_22};
      if(is_pos_w_dly==4'd3)
          buffer_data <= {data_shift_30,data_shift_31,data_shift_32};
      if(is_pos_w_dly==4'd4)
          buffer_data <= {data_shift_40,data_shift_41,data_shift_42};
      if(is_pos_w_dly==4'd5)
          buffer_data <= {data_shift_50,data_shift_51,data_shift_52};
      if(is_pos_w_dly==4'd6)
          buffer_data <= {data_shift_60,data_shift_61,data_shift_62};
      if(is_pos_w_dly==4'd7)
          buffer_data <= {data_shift_70,data_shift_71,data_shift_72};
  end else if(stat_cur_dly==FIRST_C) begin
      if(more2less_dly) begin
//           if((~hold_here_dly) & data_shift_load) begin
          if(data_shift_load) begin
              if(is_pos_w_dly==4'd0)
                  buffer_data <= {data_shift_00,data_shift_01,data_shift_02};
              if(is_pos_w_dly==4'd1)
                  buffer_data <= {data_shift_10,data_shift_11,data_shift_12};
              if(is_pos_w_dly==4'd2)
                  buffer_data <= {data_shift_20,data_shift_21,data_shift_22};
              if(is_pos_w_dly==4'd3)
                  buffer_data <= {data_shift_30,data_shift_31,data_shift_32};
              if(is_pos_w_dly==4'd4)
                  buffer_data <= {data_shift_40,data_shift_41,data_shift_42};
              if(is_pos_w_dly==4'd5)
                  buffer_data <= {data_shift_50,data_shift_51,data_shift_52};
              if(is_pos_w_dly==4'd6)
                  buffer_data <= {data_shift_60,data_shift_61,data_shift_62};
              if(is_pos_w_dly==4'd7)
                  buffer_data <= {data_shift_70,data_shift_71,data_shift_72};
          end else if(hold_here_dly & data_shift_ready) begin
              if(width_pre_cnt_dly==4'd0)
                  buffer_data <= {data_shift_00,data_shift_01,data_shift_02};
              if(width_pre_cnt_dly==4'd1)
                  buffer_data <= {data_shift_10,data_shift_11,data_shift_12};
              if(width_pre_cnt_dly==4'd2)
                  buffer_data <= {data_shift_20,data_shift_21,data_shift_22};
              if(width_pre_cnt_dly==4'd3)
                  buffer_data <= {data_shift_30,data_shift_31,data_shift_32};
              if(width_pre_cnt_dly==4'd4)
                  buffer_data <= {data_shift_40,data_shift_41,data_shift_42};
              if(width_pre_cnt_dly==4'd5)
                  buffer_data <= {data_shift_50,data_shift_51,data_shift_52};
              if(width_pre_cnt_dly==4'd6)
                  buffer_data <= {data_shift_60,data_shift_61,data_shift_62};
              if(width_pre_cnt_dly==4'd7)
                  buffer_data <= {data_shift_70,data_shift_71,data_shift_72};
          end
      end else begin
          if((is_pos_w_dly<=width_pre_dly) & data_shift_load) begin
              if(is_pos_w_dly==4'd0 )
                  buffer_data <= {data_shift_00,data_shift_01,data_shift_02};
              if(is_pos_w_dly==4'd1 )
                  buffer_data <= {data_shift_10,data_shift_11,data_shift_12};
              if(is_pos_w_dly==4'd2 )
                  buffer_data <= {data_shift_20,data_shift_21,data_shift_22};
              if(is_pos_w_dly==4'd3 )
                  buffer_data <= {data_shift_30,data_shift_31,data_shift_32};
              if(is_pos_w_dly==4'd4 )
                  buffer_data <= {data_shift_40,data_shift_41,data_shift_42};
              if(is_pos_w_dly==4'd5 )
                  buffer_data <= {data_shift_50,data_shift_51,data_shift_52};
              if(is_pos_w_dly==4'd6 )
                  buffer_data <= {data_shift_60,data_shift_61,data_shift_62};
              if(is_pos_w_dly==4'd7 )
                  buffer_data <= {data_shift_70,data_shift_71,data_shift_72};
          end else if(data_shift_load) begin
              buffer_data <= 216'd0;
          end
      end
  end else if(data_shift_ready) begin
      buffer_data <= 216'd0;
  end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buf_dat_vld <= 1'b0;
  end else begin
    if(data_shift_valid)
        buf_dat_vld <=  1'b1 ;
    else if(buf_dat_rdy)
        buf_dat_vld <=  1'b0 ;
  end
end
assign buf_dat_rdy = buffer_ready;

//assign buf_dat_load_all = buf_dat_vld & buf_dat_rdy;
//assign buf_dat_load     = buf_dat_load_all & (~hold_here_dly2);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stat_cur_dly2 <= {3{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    stat_cur_dly2 <= stat_cur_dly;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    stat_cur_dly2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    less2more_dly2 <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    less2more_dly2 <= less2more_dly;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    less2more_dly2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_pos_w_dly2 <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    is_pos_w_dly2 <= is_pos_w_dly;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    is_pos_w_dly2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    width_pre_dly2 <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    width_pre_dly2 <= width_pre_dly;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    width_pre_dly2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(
  stat_cur_dly2
  or less2more_dly2
  or is_pos_w_dly2
  or width_pre_dly2
  or buf_dat_vld
  ) begin
   if(((stat_cur_dly2==FIRST_C) & less2more_dly2 & (is_pos_w_dly2 > width_pre_dly2)) || (stat_cur_dly2==WAIT)) 
       buffer_data_vld = 1'b0;
   else
       buffer_data_vld = buf_dat_vld;
end

//&Always posedge;
//   if((stat_cur_dly==NORMAL_C) || (stat_cur_dly==SECOND_C) || (stat_cur_dly==CUBE_END))
//       buffer_data_vld <0= data_shift_valid? 1'b1 : (buffer_ready? 1'b0 : buffer_data_vld);
//   else if(stat_cur_dly==FIRST_C) begin
//       if(more2less_dly)
//           buffer_data_vld <0= hold_here_dly || (data_shift_valid? 1'b1 : (buffer_ready? 1'b0 : buffer_data_vld));
//       else if(less2more_dly) begin
//           if(is_pos_w_dly<=width_pre_dly)
//               buffer_data_vld <0= data_shift_valid? 1'b1 : (buffer_ready? 1'b0 : buffer_data_vld);
//           else
//               buffer_data_vld <0= buffer_ready? 1'b0 : buffer_data_vld;
//       end else
//           buffer_data_vld <0= data_shift_valid? 1'b1 : (buffer_ready? 1'b0 : buffer_data_vld);
//   end else if(buffer_ready)
//       buffer_data_vld <0= 1'b0;
//&End;

///////////////////////////////////////////////////////////////////////////////////////////
//output data_info generation
///////////////////////////////////////////////////////////////////////////////////////////
assign FIRST_C_end = ((stat_cur==FIRST_C) & (width_pre_cnt == width_pre) & more2less & rdma2dp_ready_normal);
assign FIRST_C_bf_end = ((stat_cur==FIRST_C) & (width_pre_cnt < width_pre) & more2less);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_align <= {4{1'b0}};
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    width_align <= is_width;
  // VCS coverage off
  end else if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b0) begin
  end else begin
    width_align <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_w_align <= 1'b0;
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    last_w_align <= is_last_w;
  // VCS coverage off
  end else if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b0) begin
  end else begin
    last_w_align <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_h_align <= 1'b0;
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    last_h_align <= is_last_h;
  // VCS coverage off
  end else if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b0) begin
  end else begin
    last_h_align <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_c_align <= 1'b0;
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    last_c_align <= is_last_c;
  // VCS coverage off
  end else if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b0) begin
  end else begin
    last_c_align <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pos_c_align <= {3{1'b0}};
  end else begin
    if(FIRST_C_end)
        pos_c_align <= 3'd0;
    else if(is_b_sync & load_din & (~FIRST_C_bf_end))
        pos_c_align <= is_pos_c;
  end
end
always @(
  stat_cur
  or cube_end_width_cnt
  or more2less
  or hold_here
  or width_pre_cnt
  or is_pos_w
  or less2more
  or width_pre
  ) begin
    if(stat_cur==CUBE_END)
        pos_w_align = cube_end_width_cnt;
    else if(stat_cur==WAIT)
        pos_w_align = 4'd0;
    else if(stat_cur==FIRST_C) begin
        if(more2less) begin
            if(hold_here)
                pos_w_align = width_pre_cnt;
            else
                pos_w_align = is_pos_w;
        end else if(less2more) begin
            if((is_pos_w <= width_pre))
                pos_w_align = is_pos_w;
            else
                pos_w_align = 4'd0;
        end else
                pos_w_align = is_pos_w;
    end else
        //pos_w_align = (is_pos_w & {4{vld}});
        pos_w_align = is_pos_w;
end
always @(
  stat_cur
  or cube_done
  or more2less
  or width_pre_cnt
  or width_pre
  or less2more
  or is_pos_w
  or load_din
  or is_b_sync
  ) begin
    if(stat_cur==CUBE_END)
        b_sync_align = cube_done;
    else if(stat_cur==WAIT)
        b_sync_align = 1'b0;
    else if(stat_cur==FIRST_C) begin
        if(more2less)
            b_sync_align = (width_pre_cnt == width_pre);
        else if(less2more)
            b_sync_align = (is_pos_w == width_pre) & load_din;
        else
            b_sync_align = (is_b_sync & load_din);
    end
    else
        b_sync_align = (is_b_sync & load_din);
end

///////////////////
//Two cycle delay
///////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pos_w_dly1 <= {4{1'b0}};
    width_dly1 <= {4{1'b0}};
    pos_c_dly1 <= {3{1'b0}};
    b_sync_dly1 <= 1'b0;
    last_w_dly1 <= 1'b0;
    last_h_dly1 <= 1'b0;
    last_c_dly1 <= 1'b0;
  end else begin
    if((((stat_cur==NORMAL_C)||(stat_cur==SECOND_C)) & load_din)
      || ((stat_cur==CUBE_END) & rdma2dp_ready_normal))begin
        pos_w_dly1  <=  pos_w_align;
        width_dly1  <=  width_align;
        pos_c_dly1  <=  pos_c_align;
        b_sync_dly1 <=  b_sync_align;
        last_w_dly1 <=  last_w_align;
        last_h_dly1 <=  last_h_align;
        last_c_dly1 <=  last_c_align;
    end else if(stat_cur==FIRST_C) begin
        if(more2less & rdma2dp_ready_normal) begin
            if(hold_here) begin
                pos_w_dly1  <=  pos_w_align;
                width_dly1  <=  width_align;
                pos_c_dly1  <=  pos_c_align;
                b_sync_dly1 <=  b_sync_align;
                last_w_dly1 <=  last_w_align;
                last_h_dly1 <=  last_h_align;
                last_c_dly1 <=  last_c_align;
            end else if(load_din) begin
                pos_w_dly1  <=  pos_w_align;
                width_dly1  <=  width_align;
                pos_c_dly1  <=  pos_c_align;
                b_sync_dly1 <=  b_sync_align;
                last_w_dly1 <=  last_w_align;
                last_h_dly1 <=  last_h_align;
                last_c_dly1 <=  last_c_align;
            end
        end else if(less2more) begin
            if(l2m_1stC_vld & load_din) begin
                pos_w_dly1  <=  pos_w_align;
                width_dly1  <=  width_align;
                pos_c_dly1  <=  pos_c_align;
                b_sync_dly1 <=  b_sync_align;
                last_w_dly1 <=  last_w_align;
                last_h_dly1 <=  last_h_align;
                last_c_dly1 <=  last_c_align;
            end
        end else if(load_din)begin
                pos_w_dly1  <=  pos_w_align;
                width_dly1  <=  width_align;
                pos_c_dly1  <=  pos_c_align;
                b_sync_dly1 <=  b_sync_align;
                last_w_dly1 <=  last_w_align;
                last_h_dly1 <=  last_h_align;
                last_c_dly1 <=  last_c_align;
        end
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_pos_w <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_pos_w <= pos_w_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_pos_w <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_width <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_width <= width_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_width <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_pos_c <= {3{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_pos_c <= pos_c_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_pos_c <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_b_sync <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_b_sync <= b_sync_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_b_sync <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_last_w <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_last_w <= last_w_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_last_w <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_last_h <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_last_h <= last_h_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_last_h <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_last_c <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_last_c <= last_c_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_last_c <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////////////////////////////


// PKT_PACK_WIRE( cdp_bufin2core , buffer_ , buffer_pd )
assign      buffer_pd[215:0] =    buffer_data[215:0];
assign      buffer_pd[219:216] =    buffer_pos_w[3:0];
assign      buffer_pd[223:220] =    buffer_width[3:0];
assign      buffer_pd[226:224] =    buffer_pos_c[2:0];
assign      buffer_pd[227] =    buffer_b_sync ;
assign      buffer_pd[228] =    buffer_last_w ;
assign      buffer_pd[229] =    buffer_last_h ;
assign      buffer_pd[230] =    buffer_last_c ;
/////////////////////////////////////////
assign buffer_valid = buffer_data_vld;

/////////////////////////////////////////
//output data pipe for register out
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     buffer_valid
  or p2_pipe_rand_ready
  or buffer_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = buffer_valid;
  buffer_ready = p2_pipe_rand_ready;
  p2_pipe_rand_data = buffer_pd;
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : buffer_valid;
  buffer_ready = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : buffer_pd;
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p2_pipe_stall_cycles;
integer p2_pipe_stall_probability;
integer p2_pipe_stall_cycles_min;
integer p2_pipe_stall_cycles_max;
initial begin
  p2_pipe_stall_cycles = 0;
  p2_pipe_stall_probability = 0;
  p2_pipe_stall_cycles_min = 1;
  p2_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_bufferin_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or buffer_valid
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && buffer_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p2_pipe_rand_poised) begin
    if (p2_pipe_stall_probability >= prand_inst2(1, 100)) begin
      p2_pipe_stall_cycles <= prand_inst3(p2_pipe_stall_cycles_min, p2_pipe_stall_cycles_max);
    end
  end else if (p2_pipe_rand_active) begin
    p2_pipe_stall_cycles <= p2_pipe_stall_cycles - 1;
  end else begin
    p2_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed2;
reg prand_initialized2;
reg prand_no_rollpli2;
`endif
`endif
`endif

function [31:0] prand_inst2;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst2 = min;
`else
`ifdef SYNTHESIS
        prand_inst2 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized2 !== 1'b1) begin
            prand_no_rollpli2 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli2)
                prand_local_seed2 = {$prand_get_seed(2), 16'b0};
            prand_initialized2 = 1'b1;
        end
        if (prand_no_rollpli2) begin
            prand_inst2 = min;
        end else begin
            diff = max - min + 1;
            prand_inst2 = min + prand_local_seed2[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed2 = prand_local_seed2 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst2 = min;
`else
        prand_inst2 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed3;
reg prand_initialized3;
reg prand_no_rollpli3;
`endif
`endif
`endif

function [31:0] prand_inst3;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst3 = min;
`else
`ifdef SYNTHESIS
        prand_inst3 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized3 !== 1'b1) begin
            prand_no_rollpli3 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli3)
                prand_local_seed3 = {$prand_get_seed(3), 16'b0};
            prand_initialized3 = 1'b1;
        end
        if (prand_no_rollpli3) begin
            prand_inst3 = min;
        end else begin
            diff = max - min + 1;
            prand_inst3 = min + prand_local_seed3[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed3 = prand_local_seed3 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst3 = min;
`else
        prand_inst3 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (2) skid buffer
always @(
  p2_pipe_rand_valid
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_rand_valid && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_rand_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_rand_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_rand_valid
  or p2_skid_valid
  or p2_pipe_rand_data
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? p2_pipe_rand_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_skid_pipe_valid)? p2_skid_pipe_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_skid_pipe_ready = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or normalz_buf_data_prdy
  or p2_pipe_data
  ) begin
  normalz_buf_data_pvld = p2_pipe_valid;
  p2_pipe_ready = normalz_buf_data_prdy;
  normalz_buf_data = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (normalz_buf_data_pvld^normalz_buf_data_prdy^buffer_valid^buffer_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_26x (nvdla_core_clk, `ASSERT_RESET, (buffer_valid && !buffer_ready), (buffer_valid), (buffer_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
/////////////////////////////////////////

////==============
////OBS signals
////==============
//assign obs_bus_cdp_buf_load_din  = load_din;
//assign obs_bus_cdp_buf_fsm_st    = stat_cur;
//assign obs_bus_cdp_buf_load_dout = buffer_data_vld & buffer_ready;
//assign obs_bus_cdp_buf_posw      = buffer_pos_w[2:0];
//assign obs_bus_cdp_buf_width     = buffer_width[2:0];
//assign obs_bus_cdp_buf_posc      = buffer_pos_c[1:0];
//assign obs_bus_cdp_buf_bsync     = buffer_b_sync; 
//assign obs_bus_cdp_buf_lastw     = buffer_last_w;
//assign obs_bus_cdp_buf_lasth     = buffer_last_h;
//assign obs_bus_cdp_buf_lastc     = buffer_last_c;
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

    property CDP_bufin_widthchange__more2less__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        load_din_full & more2less;
    endproperty
    // Cover 0 : "load_din_full & more2less"
    FUNCPOINT_CDP_bufin_widthchange__more2less__0_COV : cover property (CDP_bufin_widthchange__more2less__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_bufin_widthchange__less2more__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        load_din_full & less2more;
    endproperty
    // Cover 1 : "load_din_full & less2more"
    FUNCPOINT_CDP_bufin_widthchange__less2more__1_COV : cover property (CDP_bufin_widthchange__less2more__1_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CDP_DP_bufferin


