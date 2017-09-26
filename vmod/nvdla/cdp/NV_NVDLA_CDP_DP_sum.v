// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_sum.v

module NV_NVDLA_CDP_DP_sum (
   nvdla_core_clk          //|< i
  ,nvdla_op_gated_clk_int  //|< i
  ,nvdla_core_rstn         //|< i
  ,fp16_en                 //|< i
  ,int16_en                //|< i
  ,int8_en                 //|< i
  ,normalz_buf_data        //|< i
  ,normalz_buf_data_pvld   //|< i
  ,nvdla_op_gated_clk_fp16 //|< i
  ,reg2dp_normalz_len      //|< i
  ,sum2itp_prdy            //|< i
  ,normalz_buf_data_prdy   //|> o
  ,sum2itp_pd              //|> o
  ,sum2itp_pvld            //|> o
  );
input          nvdla_core_clk;
input          nvdla_op_gated_clk_int;
input          nvdla_core_rstn;
input          fp16_en;
input          int16_en;
input          int8_en;
input  [230:0] normalz_buf_data;
input          normalz_buf_data_pvld;
input          nvdla_op_gated_clk_fp16;
input    [1:0] reg2dp_normalz_len;
input          sum2itp_prdy;
output         normalz_buf_data_prdy;
output [167:0] sum2itp_pd;
output         sum2itp_pvld;
reg            buf2sum_2d_vld;
reg            buf2sum_3d_vld;
reg            buf2sum_d_vld;
reg    [230:0] cdp_buf2sum_pd;
reg            cdp_buf2sum_valid;
reg     [32:0] int16_sq_0;
reg     [32:0] int16_sq_1;
reg     [32:0] int16_sq_10;
reg     [32:0] int16_sq_11;
reg     [32:0] int16_sq_2;
reg     [32:0] int16_sq_3;
reg     [32:0] int16_sq_4;
reg     [32:0] int16_sq_5;
reg     [32:0] int16_sq_6;
reg     [32:0] int16_sq_7;
reg     [32:0] int16_sq_8;
reg     [32:0] int16_sq_9;
reg     [16:0] int8_msb_sq_2;
reg     [16:0] int8_msb_sq_3;
reg     [16:0] int8_msb_sq_4;
reg     [16:0] int8_msb_sq_5;
reg     [16:0] int8_msb_sq_6;
reg     [16:0] int8_msb_sq_7;
reg     [16:0] int8_msb_sq_8;
reg     [16:0] int8_msb_sq_9;
reg            normalz_buf_data_prdy;
reg    [230:0] p1_pipe_data;
reg    [230:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg    [167:0] p2_pipe_data;
reg    [167:0] p2_pipe_rand_data;
reg            p2_pipe_rand_ready;
reg            p2_pipe_rand_valid;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [167:0] p2_skid_data;
reg    [167:0] p2_skid_pipe_data;
reg            p2_skid_pipe_ready;
reg            p2_skid_pipe_valid;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
reg    [167:0] sum2itp_pd;
reg            sum2itp_pvld;
reg            sum2itp_ready;
wire           buf2sum_2d_rdy;
wire           buf2sum_3d_rdy;
wire           buf2sum_d_rdy;
wire           buf2sum_din_prdy;
wire    [16:0] buf2sum_fp16_0;
wire    [16:0] buf2sum_fp16_1;
wire    [16:0] buf2sum_fp16_10;
wire    [16:0] buf2sum_fp16_11;
wire    [16:0] buf2sum_fp16_2;
wire    [16:0] buf2sum_fp16_3;
wire    [16:0] buf2sum_fp16_4;
wire    [16:0] buf2sum_fp16_5;
wire    [16:0] buf2sum_fp16_6;
wire    [16:0] buf2sum_fp16_7;
wire    [16:0] buf2sum_fp16_8;
wire    [16:0] buf2sum_fp16_9;
wire    [16:0] buf2sum_int16_0;
wire    [16:0] buf2sum_int16_1;
wire    [16:0] buf2sum_int16_10;
wire    [16:0] buf2sum_int16_11;
wire    [16:0] buf2sum_int16_2;
wire    [16:0] buf2sum_int16_3;
wire    [16:0] buf2sum_int16_4;
wire    [16:0] buf2sum_int16_5;
wire    [16:0] buf2sum_int16_6;
wire    [16:0] buf2sum_int16_7;
wire    [16:0] buf2sum_int16_8;
wire    [16:0] buf2sum_int16_9;
wire     [8:0] buf2sum_int8_lsb_2;
wire     [8:0] buf2sum_int8_lsb_3;
wire     [8:0] buf2sum_int8_lsb_4;
wire     [8:0] buf2sum_int8_lsb_5;
wire     [8:0] buf2sum_int8_lsb_6;
wire     [8:0] buf2sum_int8_lsb_7;
wire     [8:0] buf2sum_int8_lsb_8;
wire     [8:0] buf2sum_int8_lsb_9;
wire     [8:0] buf2sum_int8_msb_2;
wire     [8:0] buf2sum_int8_msb_3;
wire     [8:0] buf2sum_int8_msb_4;
wire     [8:0] buf2sum_int8_msb_5;
wire     [8:0] buf2sum_int8_msb_6;
wire     [8:0] buf2sum_int8_msb_7;
wire     [8:0] buf2sum_int8_msb_8;
wire     [8:0] buf2sum_int8_msb_9;
wire     [8:0] buf2sum_int8_msb_abs_2;
wire     [8:0] buf2sum_int8_msb_abs_3;
wire     [8:0] buf2sum_int8_msb_abs_4;
wire     [8:0] buf2sum_int8_msb_abs_5;
wire     [8:0] buf2sum_int8_msb_abs_6;
wire     [8:0] buf2sum_int8_msb_abs_7;
wire     [8:0] buf2sum_int8_msb_abs_8;
wire     [8:0] buf2sum_int8_msb_abs_9;
wire           buf2sum_rdy_f;
wire           cdp_buf2sum_ready;
wire    [31:0] f_fp16_dout_0;
wire    [31:0] f_fp16_dout_1;
wire    [31:0] f_fp16_dout_10;
wire    [31:0] f_fp16_dout_11;
wire    [31:0] f_fp16_dout_2;
wire    [31:0] f_fp16_dout_3;
wire    [31:0] f_fp16_dout_4;
wire    [31:0] f_fp16_dout_5;
wire    [31:0] f_fp16_dout_6;
wire    [31:0] f_fp16_dout_7;
wire    [31:0] f_fp16_dout_8;
wire    [31:0] f_fp16_dout_9;
wire    [32:0] f_sq_pd_int16_0;
wire    [32:0] f_sq_pd_int16_1;
wire    [32:0] f_sq_pd_int16_10;
wire    [32:0] f_sq_pd_int16_11;
wire    [32:0] f_sq_pd_int16_2;
wire    [32:0] f_sq_pd_int16_3;
wire    [32:0] f_sq_pd_int16_4;
wire    [32:0] f_sq_pd_int16_5;
wire    [32:0] f_sq_pd_int16_6;
wire    [32:0] f_sq_pd_int16_7;
wire    [32:0] f_sq_pd_int16_8;
wire    [32:0] f_sq_pd_int16_9;
wire    [16:0] f_sq_pd_int8_lsb_2;
wire    [16:0] f_sq_pd_int8_lsb_3;
wire    [16:0] f_sq_pd_int8_lsb_4;
wire    [16:0] f_sq_pd_int8_lsb_5;
wire    [16:0] f_sq_pd_int8_lsb_6;
wire    [16:0] f_sq_pd_int8_lsb_7;
wire    [16:0] f_sq_pd_int8_lsb_8;
wire    [16:0] f_sq_pd_int8_lsb_9;
wire    [16:0] f_sq_pd_int8_msb_2;
wire    [16:0] f_sq_pd_int8_msb_3;
wire    [16:0] f_sq_pd_int8_msb_4;
wire    [16:0] f_sq_pd_int8_msb_5;
wire    [16:0] f_sq_pd_int8_msb_6;
wire    [16:0] f_sq_pd_int8_msb_7;
wire    [16:0] f_sq_pd_int8_msb_8;
wire    [16:0] f_sq_pd_int8_msb_9;
wire           fp16_din_prdy;
wire    [11:0] fp16_din_prdy_0;
wire    [11:0] fp16_din_prdy_1;
wire           fp16_din_pvld;
wire    [11:0] fp16_din_pvld_0;
wire    [11:0] fp16_din_pvld_1;
wire    [31:0] fp16_dout_0;
wire    [31:0] fp16_dout_1;
wire    [31:0] fp16_dout_10;
wire    [31:0] fp16_dout_11;
wire    [31:0] fp16_dout_2;
wire    [31:0] fp16_dout_3;
wire    [31:0] fp16_dout_4;
wire    [31:0] fp16_dout_5;
wire    [31:0] fp16_dout_6;
wire    [31:0] fp16_dout_7;
wire    [31:0] fp16_dout_8;
wire    [31:0] fp16_dout_9;
wire    [11:0] fp16_dout_prdy;
wire    [11:0] fp16_dout_pvld;
wire   [167:0] fp16_sum;
wire    [31:0] fp16_sum_0;
wire    [31:0] fp16_sum_1;
wire    [31:0] fp16_sum_2;
wire    [31:0] fp16_sum_3;
wire           fp16_sum_pvld;
wire           fp16_sum_rdy;
wire           fp16_sum_rdy_0;
wire           fp16_sum_rdy_1;
wire           fp16_sum_rdy_2;
wire           fp16_sum_rdy_3;
wire           fp16_sum_vld;
wire           fp16_sum_vld_0;
wire           fp16_sum_vld_1;
wire           fp16_sum_vld_2;
wire           fp16_sum_vld_3;
wire    [11:0] fp17T32_i_prdy;
wire    [11:0] fp17T32_i_pvld;
wire    [31:0] fp17T32_o_dp_0;
wire    [31:0] fp17T32_o_dp_1;
wire    [31:0] fp17T32_o_dp_10;
wire    [31:0] fp17T32_o_dp_11;
wire    [31:0] fp17T32_o_dp_2;
wire    [31:0] fp17T32_o_dp_3;
wire    [31:0] fp17T32_o_dp_4;
wire    [31:0] fp17T32_o_dp_5;
wire    [31:0] fp17T32_o_dp_6;
wire    [31:0] fp17T32_o_dp_7;
wire    [31:0] fp17T32_o_dp_8;
wire    [31:0] fp17T32_o_dp_9;
wire    [11:0] fp17T32_o_prdy;
wire    [11:0] fp17T32_o_pvld;
wire           fp_sq_out_rdy;
wire           fp_sq_out_rdy_0;
wire           fp_sq_out_rdy_1;
wire           fp_sq_out_rdy_2;
wire           fp_sq_out_rdy_3;
wire           fp_sq_out_vld;
wire           fp_sq_out_vld_0;
wire           fp_sq_out_vld_1;
wire           fp_sq_out_vld_2;
wire           fp_sq_out_vld_3;
wire   [167:0] int16_sum;
wire    [36:0] int16_sum_1st;
wire    [36:0] int16_sum_2nd;
wire    [36:0] int16_sum_3rd;
wire    [36:0] int16_sum_4th;
wire     [7:0] int8_inv_2;
wire     [7:0] int8_inv_3;
wire     [7:0] int8_inv_4;
wire     [7:0] int8_inv_5;
wire     [7:0] int8_inv_6;
wire     [7:0] int8_inv_7;
wire     [7:0] int8_inv_8;
wire     [7:0] int8_inv_9;
wire   [167:0] int8_sum;
wire    [41:0] int8_sum_1st;
wire    [41:0] int8_sum_2nd;
wire    [41:0] int8_sum_3rd;
wire    [41:0] int8_sum_4th;
wire    [15:0] int_ivt_0;
wire    [15:0] int_ivt_1;
wire    [15:0] int_ivt_10;
wire    [15:0] int_ivt_11;
wire    [15:0] int_ivt_2;
wire    [15:0] int_ivt_3;
wire    [15:0] int_ivt_4;
wire    [15:0] int_ivt_5;
wire    [15:0] int_ivt_6;
wire    [15:0] int_ivt_7;
wire    [15:0] int_ivt_8;
wire    [15:0] int_ivt_9;
wire    [16:0] int_sq_datin_0;
wire    [16:0] int_sq_datin_1;
wire    [16:0] int_sq_datin_10;
wire    [16:0] int_sq_datin_11;
wire    [16:0] int_sq_datin_2;
wire    [16:0] int_sq_datin_3;
wire    [16:0] int_sq_datin_4;
wire    [16:0] int_sq_datin_5;
wire    [16:0] int_sq_datin_6;
wire    [16:0] int_sq_datin_7;
wire    [16:0] int_sq_datin_8;
wire    [16:0] int_sq_datin_9;
wire    [16:0] int_sq_datin_abs_0;
wire    [16:0] int_sq_datin_abs_1;
wire    [16:0] int_sq_datin_abs_10;
wire    [16:0] int_sq_datin_abs_11;
wire    [16:0] int_sq_datin_abs_2;
wire    [16:0] int_sq_datin_abs_3;
wire    [16:0] int_sq_datin_abs_4;
wire    [16:0] int_sq_datin_abs_5;
wire    [16:0] int_sq_datin_abs_6;
wire    [16:0] int_sq_datin_abs_7;
wire    [16:0] int_sq_datin_abs_8;
wire    [16:0] int_sq_datin_abs_9;
wire           len3;
wire           len5;
wire           len7;
wire           len9;
wire           load_din;
wire           load_din_2d;
wire           load_din_d;
wire   [167:0] sum2itp_data;
wire           sum2itp_valid;
wire   [167:0] sum_out_pd;
wire           sum_out_prdy;
wire           sum_out_pvld;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    //==========================================
//----------------------------------------
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     normalz_buf_data_pvld
  or p1_pipe_rand_ready
  or normalz_buf_data
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = normalz_buf_data_pvld;
  normalz_buf_data_prdy = p1_pipe_rand_ready;
  p1_pipe_rand_data = normalz_buf_data[230:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : normalz_buf_data_pvld;
  normalz_buf_data_prdy = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : normalz_buf_data[230:0];
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
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or normalz_buf_data_pvld
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && normalz_buf_data_pvld === 1'b1;
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
//## pipe (1) output
always @(
  p1_pipe_valid
  or cdp_buf2sum_ready
  or p1_pipe_data
  ) begin
  cdp_buf2sum_valid = p1_pipe_valid;
  p1_pipe_ready = cdp_buf2sum_ready;
  cdp_buf2sum_pd = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cdp_buf2sum_valid^cdp_buf2sum_ready^normalz_buf_data_pvld^normalz_buf_data_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (normalz_buf_data_pvld && !normalz_buf_data_prdy), (normalz_buf_data_pvld), (normalz_buf_data_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//assign load_din = cdp_buf2sum_valid & buf2sum_rdy_f;
assign load_din = fp16_en ? 1'b0 : (cdp_buf2sum_valid & buf2sum_rdy_f);

assign cdp_buf2sum_ready = buf2sum_rdy_f;
assign buf2sum_rdy_f = fp16_en ? fp16_din_prdy : buf2sum_din_prdy;
//==========================================

 assign buf2sum_fp16_0     = fp16_en  ? cdp_buf2sum_pd[0+16:0] : 17'd0; 
 assign buf2sum_int16_0    = int16_en ? cdp_buf2sum_pd[0+16:0] : 17'd0; 
 assign buf2sum_fp16_1     = fp16_en  ? cdp_buf2sum_pd[18+16:18] : 17'd0; 
 assign buf2sum_int16_1    = int16_en ? cdp_buf2sum_pd[18+16:18] : 17'd0; 
 assign buf2sum_fp16_2     = fp16_en  ? cdp_buf2sum_pd[36+16:36] : 17'd0; 
 assign buf2sum_int16_2    = int16_en ? cdp_buf2sum_pd[36+16:36] : 17'd0; 
 assign buf2sum_fp16_3     = fp16_en  ? cdp_buf2sum_pd[54+16:54] : 17'd0; 
 assign buf2sum_int16_3    = int16_en ? cdp_buf2sum_pd[54+16:54] : 17'd0; 
 assign buf2sum_fp16_4     = fp16_en  ? cdp_buf2sum_pd[72+16:72] : 17'd0; 
 assign buf2sum_int16_4    = int16_en ? cdp_buf2sum_pd[72+16:72] : 17'd0; 
 assign buf2sum_fp16_5     = fp16_en  ? cdp_buf2sum_pd[90+16:90] : 17'd0; 
 assign buf2sum_int16_5    = int16_en ? cdp_buf2sum_pd[90+16:90] : 17'd0; 
 assign buf2sum_fp16_6     = fp16_en  ? cdp_buf2sum_pd[108+16:108] : 17'd0; 
 assign buf2sum_int16_6    = int16_en ? cdp_buf2sum_pd[108+16:108] : 17'd0; 
 assign buf2sum_fp16_7     = fp16_en  ? cdp_buf2sum_pd[126+16:126] : 17'd0; 
 assign buf2sum_int16_7    = int16_en ? cdp_buf2sum_pd[126+16:126] : 17'd0; 
 assign buf2sum_fp16_8     = fp16_en  ? cdp_buf2sum_pd[144+16:144] : 17'd0; 
 assign buf2sum_int16_8    = int16_en ? cdp_buf2sum_pd[144+16:144] : 17'd0; 
 assign buf2sum_fp16_9     = fp16_en  ? cdp_buf2sum_pd[162+16:162] : 17'd0; 
 assign buf2sum_int16_9    = int16_en ? cdp_buf2sum_pd[162+16:162] : 17'd0; 
 assign buf2sum_fp16_10     = fp16_en  ? cdp_buf2sum_pd[180+16:180] : 17'd0; 
 assign buf2sum_int16_10    = int16_en ? cdp_buf2sum_pd[180+16:180] : 17'd0; 
 assign buf2sum_fp16_11     = fp16_en  ? cdp_buf2sum_pd[198+16:198] : 17'd0; 
 assign buf2sum_int16_11    = int16_en ? cdp_buf2sum_pd[198+16:198] : 17'd0; 

 assign buf2sum_int8_lsb_2 = int8_en  ? cdp_buf2sum_pd[36+8:36] : 9'd0; 
 assign buf2sum_int8_msb_2 = int8_en  ? cdp_buf2sum_pd[36+17:36+9] : 9'd0; 
 assign buf2sum_int8_lsb_3 = int8_en  ? cdp_buf2sum_pd[54+8:54] : 9'd0; 
 assign buf2sum_int8_msb_3 = int8_en  ? cdp_buf2sum_pd[54+17:54+9] : 9'd0; 
 assign buf2sum_int8_lsb_4 = int8_en  ? cdp_buf2sum_pd[72+8:72] : 9'd0; 
 assign buf2sum_int8_msb_4 = int8_en  ? cdp_buf2sum_pd[72+17:72+9] : 9'd0; 
 assign buf2sum_int8_lsb_5 = int8_en  ? cdp_buf2sum_pd[90+8:90] : 9'd0; 
 assign buf2sum_int8_msb_5 = int8_en  ? cdp_buf2sum_pd[90+17:90+9] : 9'd0; 
 assign buf2sum_int8_lsb_6 = int8_en  ? cdp_buf2sum_pd[108+8:108] : 9'd0; 
 assign buf2sum_int8_msb_6 = int8_en  ? cdp_buf2sum_pd[108+17:108+9] : 9'd0; 
 assign buf2sum_int8_lsb_7 = int8_en  ? cdp_buf2sum_pd[126+8:126] : 9'd0; 
 assign buf2sum_int8_msb_7 = int8_en  ? cdp_buf2sum_pd[126+17:126+9] : 9'd0; 
 assign buf2sum_int8_lsb_8 = int8_en  ? cdp_buf2sum_pd[144+8:144] : 9'd0; 
 assign buf2sum_int8_msb_8 = int8_en  ? cdp_buf2sum_pd[144+17:144+9] : 9'd0; 
 assign buf2sum_int8_lsb_9 = int8_en  ? cdp_buf2sum_pd[162+8:162] : 9'd0; 
 assign buf2sum_int8_msb_9 = int8_en  ? cdp_buf2sum_pd[162+17:162+9] : 9'd0; 
//========================================================
//int mode
//--------------------------------------------------------
//////slcg
//////

 assign int_sq_datin_0 = int16_en ? buf2sum_int16_0 : 17'd0; 
 assign int_sq_datin_1 = int16_en ? buf2sum_int16_1 : 17'd0; 
 assign int_sq_datin_2 = int16_en ? buf2sum_int16_2 : (int8_en? {{8{buf2sum_int8_lsb_2[8]}},buf2sum_int8_lsb_2} : 17'd0); 
 assign int_sq_datin_3 = int16_en ? buf2sum_int16_3 : (int8_en? {{8{buf2sum_int8_lsb_3[8]}},buf2sum_int8_lsb_3} : 17'd0); 
 assign int_sq_datin_4 = int16_en ? buf2sum_int16_4 : (int8_en? {{8{buf2sum_int8_lsb_4[8]}},buf2sum_int8_lsb_4} : 17'd0); 
 assign int_sq_datin_5 = int16_en ? buf2sum_int16_5 : (int8_en? {{8{buf2sum_int8_lsb_5[8]}},buf2sum_int8_lsb_5} : 17'd0); 
 assign int_sq_datin_6 = int16_en ? buf2sum_int16_6 : (int8_en? {{8{buf2sum_int8_lsb_6[8]}},buf2sum_int8_lsb_6} : 17'd0); 
 assign int_sq_datin_7 = int16_en ? buf2sum_int16_7 : (int8_en? {{8{buf2sum_int8_lsb_7[8]}},buf2sum_int8_lsb_7} : 17'd0); 
 assign int_sq_datin_8 = int16_en ? buf2sum_int16_8 : (int8_en? {{8{buf2sum_int8_lsb_8[8]}},buf2sum_int8_lsb_8} : 17'd0); 
 assign int_sq_datin_9 = int16_en ? buf2sum_int16_9 : (int8_en? {{8{buf2sum_int8_lsb_9[8]}},buf2sum_int8_lsb_9} : 17'd0); 
 assign int_sq_datin_10 = int16_en ? buf2sum_int16_10 : 17'd0; 
 assign int_sq_datin_11 = int16_en ? buf2sum_int16_11 : 17'd0; 
//square process
 assign int_ivt_0[15:0] = int_sq_datin_0[16] ? (~int_sq_datin_0[15:0]) : 16'd0; 
 assign int_sq_datin_abs_0[16:0] = int_sq_datin_0[16] ? (int_ivt_0[15:0] + 16'd1) : int_sq_datin_0[16:0]; 
 assign int_ivt_1[15:0] = int_sq_datin_1[16] ? (~int_sq_datin_1[15:0]) : 16'd0; 
 assign int_sq_datin_abs_1[16:0] = int_sq_datin_1[16] ? (int_ivt_1[15:0] + 16'd1) : int_sq_datin_1[16:0]; 
 assign int_ivt_2[15:0] = int_sq_datin_2[16] ? (~int_sq_datin_2[15:0]) : 16'd0; 
 assign int_sq_datin_abs_2[16:0] = int_sq_datin_2[16] ? (int_ivt_2[15:0] + 16'd1) : int_sq_datin_2[16:0]; 
 assign int_ivt_3[15:0] = int_sq_datin_3[16] ? (~int_sq_datin_3[15:0]) : 16'd0; 
 assign int_sq_datin_abs_3[16:0] = int_sq_datin_3[16] ? (int_ivt_3[15:0] + 16'd1) : int_sq_datin_3[16:0]; 
 assign int_ivt_4[15:0] = int_sq_datin_4[16] ? (~int_sq_datin_4[15:0]) : 16'd0; 
 assign int_sq_datin_abs_4[16:0] = int_sq_datin_4[16] ? (int_ivt_4[15:0] + 16'd1) : int_sq_datin_4[16:0]; 
 assign int_ivt_5[15:0] = int_sq_datin_5[16] ? (~int_sq_datin_5[15:0]) : 16'd0; 
 assign int_sq_datin_abs_5[16:0] = int_sq_datin_5[16] ? (int_ivt_5[15:0] + 16'd1) : int_sq_datin_5[16:0]; 
 assign int_ivt_6[15:0] = int_sq_datin_6[16] ? (~int_sq_datin_6[15:0]) : 16'd0; 
 assign int_sq_datin_abs_6[16:0] = int_sq_datin_6[16] ? (int_ivt_6[15:0] + 16'd1) : int_sq_datin_6[16:0]; 
 assign int_ivt_7[15:0] = int_sq_datin_7[16] ? (~int_sq_datin_7[15:0]) : 16'd0; 
 assign int_sq_datin_abs_7[16:0] = int_sq_datin_7[16] ? (int_ivt_7[15:0] + 16'd1) : int_sq_datin_7[16:0]; 
 assign int_ivt_8[15:0] = int_sq_datin_8[16] ? (~int_sq_datin_8[15:0]) : 16'd0; 
 assign int_sq_datin_abs_8[16:0] = int_sq_datin_8[16] ? (int_ivt_8[15:0] + 16'd1) : int_sq_datin_8[16:0]; 
 assign int_ivt_9[15:0] = int_sq_datin_9[16] ? (~int_sq_datin_9[15:0]) : 16'd0; 
 assign int_sq_datin_abs_9[16:0] = int_sq_datin_9[16] ? (int_ivt_9[15:0] + 16'd1) : int_sq_datin_9[16:0]; 
 assign int_ivt_10[15:0] = int_sq_datin_10[16] ? (~int_sq_datin_10[15:0]) : 16'd0; 
 assign int_sq_datin_abs_10[16:0] = int_sq_datin_10[16] ? (int_ivt_10[15:0] + 16'd1) : int_sq_datin_10[16:0]; 
 assign int_ivt_11[15:0] = int_sq_datin_11[16] ? (~int_sq_datin_11[15:0]) : 16'd0; 
 assign int_sq_datin_abs_11[16:0] = int_sq_datin_11[16] ? (int_ivt_11[15:0] + 16'd1) : int_sq_datin_11[16:0]; 
 assign int8_inv_2[7:0] = buf2sum_int8_msb_2[8] ? (~buf2sum_int8_msb_2[7:0]) : 8'd0; 
 assign buf2sum_int8_msb_abs_2[8:0] = buf2sum_int8_msb_2[8] ? (int8_inv_2[7:0] + 8'd1) : buf2sum_int8_msb_2[8:0]; 
 assign int8_inv_3[7:0] = buf2sum_int8_msb_3[8] ? (~buf2sum_int8_msb_3[7:0]) : 8'd0; 
 assign buf2sum_int8_msb_abs_3[8:0] = buf2sum_int8_msb_3[8] ? (int8_inv_3[7:0] + 8'd1) : buf2sum_int8_msb_3[8:0]; 
 assign int8_inv_4[7:0] = buf2sum_int8_msb_4[8] ? (~buf2sum_int8_msb_4[7:0]) : 8'd0; 
 assign buf2sum_int8_msb_abs_4[8:0] = buf2sum_int8_msb_4[8] ? (int8_inv_4[7:0] + 8'd1) : buf2sum_int8_msb_4[8:0]; 
 assign int8_inv_5[7:0] = buf2sum_int8_msb_5[8] ? (~buf2sum_int8_msb_5[7:0]) : 8'd0; 
 assign buf2sum_int8_msb_abs_5[8:0] = buf2sum_int8_msb_5[8] ? (int8_inv_5[7:0] + 8'd1) : buf2sum_int8_msb_5[8:0]; 
 assign int8_inv_6[7:0] = buf2sum_int8_msb_6[8] ? (~buf2sum_int8_msb_6[7:0]) : 8'd0; 
 assign buf2sum_int8_msb_abs_6[8:0] = buf2sum_int8_msb_6[8] ? (int8_inv_6[7:0] + 8'd1) : buf2sum_int8_msb_6[8:0]; 
 assign int8_inv_7[7:0] = buf2sum_int8_msb_7[8] ? (~buf2sum_int8_msb_7[7:0]) : 8'd0; 
 assign buf2sum_int8_msb_abs_7[8:0] = buf2sum_int8_msb_7[8] ? (int8_inv_7[7:0] + 8'd1) : buf2sum_int8_msb_7[8:0]; 
 assign int8_inv_8[7:0] = buf2sum_int8_msb_8[8] ? (~buf2sum_int8_msb_8[7:0]) : 8'd0; 
 assign buf2sum_int8_msb_abs_8[8:0] = buf2sum_int8_msb_8[8] ? (int8_inv_8[7:0] + 8'd1) : buf2sum_int8_msb_8[8:0]; 
 assign int8_inv_9[7:0] = buf2sum_int8_msb_9[8] ? (~buf2sum_int8_msb_9[7:0]) : 8'd0; 
 assign buf2sum_int8_msb_abs_9[8:0] = buf2sum_int8_msb_9[8] ? (int8_inv_9[7:0] + 8'd1) : buf2sum_int8_msb_9[8:0]; 
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int16_sq_0 <= {33{1'b0}};
    int16_sq_1 <= {33{1'b0}};
    int16_sq_2 <= {33{1'b0}};
    int16_sq_3 <= {33{1'b0}};
    int16_sq_4 <= {33{1'b0}};
    int16_sq_5 <= {33{1'b0}};
    int16_sq_6 <= {33{1'b0}};
    int16_sq_7 <= {33{1'b0}};
    int16_sq_8 <= {33{1'b0}};
    int16_sq_9 <= {33{1'b0}};
    int16_sq_10 <= {33{1'b0}};
    int16_sq_11 <= {33{1'b0}};
  end else begin
  if(load_din) begin
     int16_sq_0  <= (int16_en & len9)? (int_sq_datin_abs_0  * int_sq_datin_abs_0 ) : 33'd0;
     int16_sq_1  <= (int16_en & (len7|len9))? (int_sq_datin_abs_1  * int_sq_datin_abs_1 ) : 33'd0;
     int16_sq_2  <= ((int16_en & (len5|len7|len9)) | (int8_en & len9))? (int_sq_datin_abs_2 * int_sq_datin_abs_2) : 33'd0;
     int16_sq_3  <= (int16_en | (int8_en & (len5|len7|len9)))? (int_sq_datin_abs_3 * int_sq_datin_abs_3) : 33'd0;
     int16_sq_4  <= (int16_en | int8_en)? (int_sq_datin_abs_4 * int_sq_datin_abs_4) : 33'd0;
     int16_sq_5  <= (int16_en | int8_en)? (int_sq_datin_abs_5 * int_sq_datin_abs_5) : 33'd0;
     int16_sq_6  <= (int16_en | int8_en)? (int_sq_datin_abs_6 * int_sq_datin_abs_6) : 33'd0;
     int16_sq_7  <= (int16_en | int8_en)? (int_sq_datin_abs_7 * int_sq_datin_abs_7) : 33'd0;
     int16_sq_8  <= (int16_en | int8_en)? (int_sq_datin_abs_8 * int_sq_datin_abs_8) : 33'd0;
     int16_sq_9  <= ((int16_en & (len5|len7|len9)) | (int8_en & (len7|len9)))? (int_sq_datin_abs_9 * int_sq_datin_abs_9) : 33'd0;
     int16_sq_10 <= (int16_en & (len7|len9))? (int_sq_datin_abs_10 * int_sq_datin_abs_10) : 33'd0;
     int16_sq_11 <= (int16_en & len9)? (int_sq_datin_abs_11 * int_sq_datin_abs_11) : 33'd0;
  end
  end
end

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_msb_sq_2 <= {17{1'b0}};
    int8_msb_sq_3 <= {17{1'b0}};
    int8_msb_sq_4 <= {17{1'b0}};
    int8_msb_sq_5 <= {17{1'b0}};
    int8_msb_sq_6 <= {17{1'b0}};
    int8_msb_sq_7 <= {17{1'b0}};
    int8_msb_sq_8 <= {17{1'b0}};
    int8_msb_sq_9 <= {17{1'b0}};
  end else begin
  if(load_din) begin
     int8_msb_sq_2  <= (int8_en & (len7|len9))? (buf2sum_int8_msb_abs_2 * buf2sum_int8_msb_abs_2) : 17'd0;
     int8_msb_sq_3  <=  int8_en ? (buf2sum_int8_msb_abs_3 * buf2sum_int8_msb_abs_3) : 17'd0;
     int8_msb_sq_4  <=  int8_en ? (buf2sum_int8_msb_abs_4 * buf2sum_int8_msb_abs_4) : 17'd0;
     int8_msb_sq_5  <=  int8_en ? (buf2sum_int8_msb_abs_5 * buf2sum_int8_msb_abs_5) : 17'd0;
     int8_msb_sq_6  <=  int8_en ? (buf2sum_int8_msb_abs_6 * buf2sum_int8_msb_abs_6) : 17'd0;
     int8_msb_sq_7  <=  int8_en ? (buf2sum_int8_msb_abs_7 * buf2sum_int8_msb_abs_7) : 17'd0;
     int8_msb_sq_8  <= (int8_en & (len5|len7|len9)) ? (buf2sum_int8_msb_abs_8 * buf2sum_int8_msb_abs_8) : 17'd0;
     int8_msb_sq_9  <= (int8_en & len9) ? (buf2sum_int8_msb_abs_9 * buf2sum_int8_msb_abs_9) : 17'd0;
  end
  end
end

 assign f_sq_pd_int16_0    = int16_en ? int16_sq_0 : 33'd0; 
 assign f_sq_pd_int16_1    = int16_en ? int16_sq_1 : 33'd0; 
 assign f_sq_pd_int16_2    = int16_en ? int16_sq_2 : 33'd0; 
 assign f_sq_pd_int16_3    = int16_en ? int16_sq_3 : 33'd0; 
 assign f_sq_pd_int16_4    = int16_en ? int16_sq_4 : 33'd0; 
 assign f_sq_pd_int16_5    = int16_en ? int16_sq_5 : 33'd0; 
 assign f_sq_pd_int16_6    = int16_en ? int16_sq_6 : 33'd0; 
 assign f_sq_pd_int16_7    = int16_en ? int16_sq_7 : 33'd0; 
 assign f_sq_pd_int16_8    = int16_en ? int16_sq_8 : 33'd0; 
 assign f_sq_pd_int16_9    = int16_en ? int16_sq_9 : 33'd0; 
 assign f_sq_pd_int16_10    = int16_en ? int16_sq_10 : 33'd0; 
 assign f_sq_pd_int16_11    = int16_en ? int16_sq_11 : 33'd0; 
 assign f_sq_pd_int8_lsb_2 = int8_en ? int16_sq_2[16:0] : 17'd0; 
 assign f_sq_pd_int8_msb_2 = int8_msb_sq_2; 
 assign f_sq_pd_int8_lsb_3 = int8_en ? int16_sq_3[16:0] : 17'd0; 
 assign f_sq_pd_int8_msb_3 = int8_msb_sq_3; 
 assign f_sq_pd_int8_lsb_4 = int8_en ? int16_sq_4[16:0] : 17'd0; 
 assign f_sq_pd_int8_msb_4 = int8_msb_sq_4; 
 assign f_sq_pd_int8_lsb_5 = int8_en ? int16_sq_5[16:0] : 17'd0; 
 assign f_sq_pd_int8_msb_5 = int8_msb_sq_5; 
 assign f_sq_pd_int8_lsb_6 = int8_en ? int16_sq_6[16:0] : 17'd0; 
 assign f_sq_pd_int8_msb_6 = int8_msb_sq_6; 
 assign f_sq_pd_int8_lsb_7 = int8_en ? int16_sq_7[16:0] : 17'd0; 
 assign f_sq_pd_int8_msb_7 = int8_msb_sq_7; 
 assign f_sq_pd_int8_lsb_8 = int8_en ? int16_sq_8[16:0] : 17'd0; 
 assign f_sq_pd_int8_msb_8 = int8_msb_sq_8; 
 assign f_sq_pd_int8_lsb_9 = int8_en ? int16_sq_9[16:0] : 17'd0; 
 assign f_sq_pd_int8_msb_9 = int8_msb_sq_9; 

assign buf2sum_din_prdy = ~buf2sum_d_vld | buf2sum_d_rdy;
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buf2sum_d_vld <= 1'b0;
  end else begin
    if(~fp16_en & cdp_buf2sum_valid)
        buf2sum_d_vld <= 1'b1;
    else if(buf2sum_d_rdy)
        buf2sum_d_vld <= 1'b0;
  end
end
assign buf2sum_d_rdy = ~buf2sum_2d_vld | buf2sum_2d_rdy;
//===========
//sum process
//-----------
assign len3 = (reg2dp_normalz_len[1:0] == 2'h0 );
assign len5 = (reg2dp_normalz_len[1:0] == 2'h1 );
assign len7 = (reg2dp_normalz_len[1:0] == 2'h2 );
assign len9 = (reg2dp_normalz_len[1:0] == 2'h3 );

assign load_din_d = buf2sum_d_vld & buf2sum_d_rdy;

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buf2sum_2d_vld <= 1'b0;
  end else begin
    if(buf2sum_d_vld)
        buf2sum_2d_vld <= 1'b1;
    else if(buf2sum_2d_rdy)
        buf2sum_2d_vld <= 1'b0;
  end
end
assign buf2sum_2d_rdy  = ~buf2sum_3d_vld | buf2sum_3d_rdy ;

assign load_din_2d = buf2sum_2d_vld & buf2sum_2d_rdy;


//sum for the 1st data
int_sum_block u_sum_block_1st (
   .nvdla_core_clk     (nvdla_op_gated_clk_int)   //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
  ,.int8_en            (int8_en)                  //|< i
  ,.len5               (len5)                     //|< w
  ,.len7               (len7)                     //|< w
  ,.len9               (len9)                     //|< w
  ,.load_din_2d        (load_din_2d)              //|< w
  ,.load_din_d         (load_din_d)               //|< w
  ,.reg2dp_normalz_len (reg2dp_normalz_len[1:0])  //|< i
  ,.sq_pd_int16_0      (f_sq_pd_int16_0[32:0])    //|< w
  ,.sq_pd_int16_1      (f_sq_pd_int16_1[32:0])    //|< w
  ,.sq_pd_int16_2      (f_sq_pd_int16_2[32:0])    //|< w
  ,.sq_pd_int16_3      (f_sq_pd_int16_3[32:0])    //|< w
  ,.sq_pd_int16_4      (f_sq_pd_int16_4[32:0])    //|< w
  ,.sq_pd_int16_5      (f_sq_pd_int16_5[32:0])    //|< w
  ,.sq_pd_int16_6      (f_sq_pd_int16_6[32:0])    //|< w
  ,.sq_pd_int16_7      (f_sq_pd_int16_7[32:0])    //|< w
  ,.sq_pd_int16_8      (f_sq_pd_int16_8[32:0])    //|< w
  ,.sq_pd_int8_lsb_0   (f_sq_pd_int8_lsb_2[16:0]) //|< w
  ,.sq_pd_int8_lsb_1   (f_sq_pd_int8_msb_2[16:0]) //|< w
  ,.sq_pd_int8_lsb_2   (f_sq_pd_int8_lsb_3[16:0]) //|< w
  ,.sq_pd_int8_lsb_3   (f_sq_pd_int8_msb_3[16:0]) //|< w
  ,.sq_pd_int8_lsb_4   (f_sq_pd_int8_lsb_4[16:0]) //|< w
  ,.sq_pd_int8_lsb_5   (f_sq_pd_int8_msb_4[16:0]) //|< w
  ,.sq_pd_int8_lsb_6   (f_sq_pd_int8_lsb_5[16:0]) //|< w
  ,.sq_pd_int8_lsb_7   (f_sq_pd_int8_msb_5[16:0]) //|< w
  ,.sq_pd_int8_lsb_8   (f_sq_pd_int8_lsb_6[16:0]) //|< w
  ,.sq_pd_int8_msb_0   (f_sq_pd_int8_msb_2[16:0]) //|< w
  ,.sq_pd_int8_msb_1   (f_sq_pd_int8_lsb_3[16:0]) //|< w
  ,.sq_pd_int8_msb_2   (f_sq_pd_int8_msb_3[16:0]) //|< w
  ,.sq_pd_int8_msb_3   (f_sq_pd_int8_lsb_4[16:0]) //|< w
  ,.sq_pd_int8_msb_4   (f_sq_pd_int8_msb_4[16:0]) //|< w
  ,.sq_pd_int8_msb_5   (f_sq_pd_int8_lsb_5[16:0]) //|< w
  ,.sq_pd_int8_msb_6   (f_sq_pd_int8_msb_5[16:0]) //|< w
  ,.sq_pd_int8_msb_7   (f_sq_pd_int8_lsb_6[16:0]) //|< w
  ,.sq_pd_int8_msb_8   (f_sq_pd_int8_msb_6[16:0]) //|< w
  ,.int16_sum          (int16_sum_1st[36:0])      //|> w
  ,.int8_sum           (int8_sum_1st[41:0])       //|> w
  );

//sum for the 2nd data
int_sum_block u_sum_block_2nd (
   .nvdla_core_clk     (nvdla_op_gated_clk_int)   //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
  ,.int8_en            (int8_en)                  //|< i
  ,.len5               (len5)                     //|< w
  ,.len7               (len7)                     //|< w
  ,.len9               (len9)                     //|< w
  ,.load_din_2d        (load_din_2d)              //|< w
  ,.load_din_d         (load_din_d)               //|< w
  ,.reg2dp_normalz_len (reg2dp_normalz_len[1:0])  //|< i
  ,.sq_pd_int16_0      (f_sq_pd_int16_1[32:0])    //|< w
  ,.sq_pd_int16_1      (f_sq_pd_int16_2[32:0])    //|< w
  ,.sq_pd_int16_2      (f_sq_pd_int16_3[32:0])    //|< w
  ,.sq_pd_int16_3      (f_sq_pd_int16_4[32:0])    //|< w
  ,.sq_pd_int16_4      (f_sq_pd_int16_5[32:0])    //|< w
  ,.sq_pd_int16_5      (f_sq_pd_int16_6[32:0])    //|< w
  ,.sq_pd_int16_6      (f_sq_pd_int16_7[32:0])    //|< w
  ,.sq_pd_int16_7      (f_sq_pd_int16_8[32:0])    //|< w
  ,.sq_pd_int16_8      (f_sq_pd_int16_9[32:0])    //|< w
  ,.sq_pd_int8_lsb_0   (f_sq_pd_int8_lsb_3[16:0]) //|< w
  ,.sq_pd_int8_lsb_1   (f_sq_pd_int8_msb_3[16:0]) //|< w
  ,.sq_pd_int8_lsb_2   (f_sq_pd_int8_lsb_4[16:0]) //|< w
  ,.sq_pd_int8_lsb_3   (f_sq_pd_int8_msb_4[16:0]) //|< w
  ,.sq_pd_int8_lsb_4   (f_sq_pd_int8_lsb_5[16:0]) //|< w
  ,.sq_pd_int8_lsb_5   (f_sq_pd_int8_msb_5[16:0]) //|< w
  ,.sq_pd_int8_lsb_6   (f_sq_pd_int8_lsb_6[16:0]) //|< w
  ,.sq_pd_int8_lsb_7   (f_sq_pd_int8_msb_6[16:0]) //|< w
  ,.sq_pd_int8_lsb_8   (f_sq_pd_int8_lsb_7[16:0]) //|< w
  ,.sq_pd_int8_msb_0   (f_sq_pd_int8_msb_3[16:0]) //|< w
  ,.sq_pd_int8_msb_1   (f_sq_pd_int8_lsb_4[16:0]) //|< w
  ,.sq_pd_int8_msb_2   (f_sq_pd_int8_msb_4[16:0]) //|< w
  ,.sq_pd_int8_msb_3   (f_sq_pd_int8_lsb_5[16:0]) //|< w
  ,.sq_pd_int8_msb_4   (f_sq_pd_int8_msb_5[16:0]) //|< w
  ,.sq_pd_int8_msb_5   (f_sq_pd_int8_lsb_6[16:0]) //|< w
  ,.sq_pd_int8_msb_6   (f_sq_pd_int8_msb_6[16:0]) //|< w
  ,.sq_pd_int8_msb_7   (f_sq_pd_int8_lsb_7[16:0]) //|< w
  ,.sq_pd_int8_msb_8   (f_sq_pd_int8_msb_7[16:0]) //|< w
  ,.int16_sum          (int16_sum_2nd[36:0])      //|> w
  ,.int8_sum           (int8_sum_2nd[41:0])       //|> w
  );

//sum for the 3rd data
int_sum_block u_sum_block_3rd (
   .nvdla_core_clk     (nvdla_op_gated_clk_int)   //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
  ,.int8_en            (int8_en)                  //|< i
  ,.len5               (len5)                     //|< w
  ,.len7               (len7)                     //|< w
  ,.len9               (len9)                     //|< w
  ,.load_din_2d        (load_din_2d)              //|< w
  ,.load_din_d         (load_din_d)               //|< w
  ,.reg2dp_normalz_len (reg2dp_normalz_len[1:0])  //|< i
  ,.sq_pd_int16_0      (f_sq_pd_int16_2[32:0])    //|< w
  ,.sq_pd_int16_1      (f_sq_pd_int16_3[32:0])    //|< w
  ,.sq_pd_int16_2      (f_sq_pd_int16_4[32:0])    //|< w
  ,.sq_pd_int16_3      (f_sq_pd_int16_5[32:0])    //|< w
  ,.sq_pd_int16_4      (f_sq_pd_int16_6[32:0])    //|< w
  ,.sq_pd_int16_5      (f_sq_pd_int16_7[32:0])    //|< w
  ,.sq_pd_int16_6      (f_sq_pd_int16_8[32:0])    //|< w
  ,.sq_pd_int16_7      (f_sq_pd_int16_9[32:0])    //|< w
  ,.sq_pd_int16_8      (f_sq_pd_int16_10[32:0])   //|< w
  ,.sq_pd_int8_lsb_0   (f_sq_pd_int8_lsb_4[16:0]) //|< w
  ,.sq_pd_int8_lsb_1   (f_sq_pd_int8_msb_4[16:0]) //|< w
  ,.sq_pd_int8_lsb_2   (f_sq_pd_int8_lsb_5[16:0]) //|< w
  ,.sq_pd_int8_lsb_3   (f_sq_pd_int8_msb_5[16:0]) //|< w
  ,.sq_pd_int8_lsb_4   (f_sq_pd_int8_lsb_6[16:0]) //|< w
  ,.sq_pd_int8_lsb_5   (f_sq_pd_int8_msb_6[16:0]) //|< w
  ,.sq_pd_int8_lsb_6   (f_sq_pd_int8_lsb_7[16:0]) //|< w
  ,.sq_pd_int8_lsb_7   (f_sq_pd_int8_msb_7[16:0]) //|< w
  ,.sq_pd_int8_lsb_8   (f_sq_pd_int8_lsb_8[16:0]) //|< w
  ,.sq_pd_int8_msb_0   (f_sq_pd_int8_msb_4[16:0]) //|< w
  ,.sq_pd_int8_msb_1   (f_sq_pd_int8_lsb_5[16:0]) //|< w
  ,.sq_pd_int8_msb_2   (f_sq_pd_int8_msb_5[16:0]) //|< w
  ,.sq_pd_int8_msb_3   (f_sq_pd_int8_lsb_6[16:0]) //|< w
  ,.sq_pd_int8_msb_4   (f_sq_pd_int8_msb_6[16:0]) //|< w
  ,.sq_pd_int8_msb_5   (f_sq_pd_int8_lsb_7[16:0]) //|< w
  ,.sq_pd_int8_msb_6   (f_sq_pd_int8_msb_7[16:0]) //|< w
  ,.sq_pd_int8_msb_7   (f_sq_pd_int8_lsb_8[16:0]) //|< w
  ,.sq_pd_int8_msb_8   (f_sq_pd_int8_msb_8[16:0]) //|< w
  ,.int16_sum          (int16_sum_3rd[36:0])      //|> w
  ,.int8_sum           (int8_sum_3rd[41:0])       //|> w
  );

//sum for the 4th data
int_sum_block u_sum_block_4th (
   .nvdla_core_clk     (nvdla_op_gated_clk_int)   //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
  ,.int8_en            (int8_en)                  //|< i
  ,.len5               (len5)                     //|< w
  ,.len7               (len7)                     //|< w
  ,.len9               (len9)                     //|< w
  ,.load_din_2d        (load_din_2d)              //|< w
  ,.load_din_d         (load_din_d)               //|< w
  ,.reg2dp_normalz_len (reg2dp_normalz_len[1:0])  //|< i
  ,.sq_pd_int16_0      (f_sq_pd_int16_3[32:0])    //|< w
  ,.sq_pd_int16_1      (f_sq_pd_int16_4[32:0])    //|< w
  ,.sq_pd_int16_2      (f_sq_pd_int16_5[32:0])    //|< w
  ,.sq_pd_int16_3      (f_sq_pd_int16_6[32:0])    //|< w
  ,.sq_pd_int16_4      (f_sq_pd_int16_7[32:0])    //|< w
  ,.sq_pd_int16_5      (f_sq_pd_int16_8[32:0])    //|< w
  ,.sq_pd_int16_6      (f_sq_pd_int16_9[32:0])    //|< w
  ,.sq_pd_int16_7      (f_sq_pd_int16_10[32:0])   //|< w
  ,.sq_pd_int16_8      (f_sq_pd_int16_11[32:0])   //|< w
  ,.sq_pd_int8_lsb_0   (f_sq_pd_int8_lsb_5[16:0]) //|< w
  ,.sq_pd_int8_lsb_1   (f_sq_pd_int8_msb_5[16:0]) //|< w
  ,.sq_pd_int8_lsb_2   (f_sq_pd_int8_lsb_6[16:0]) //|< w
  ,.sq_pd_int8_lsb_3   (f_sq_pd_int8_msb_6[16:0]) //|< w
  ,.sq_pd_int8_lsb_4   (f_sq_pd_int8_lsb_7[16:0]) //|< w
  ,.sq_pd_int8_lsb_5   (f_sq_pd_int8_msb_7[16:0]) //|< w
  ,.sq_pd_int8_lsb_6   (f_sq_pd_int8_lsb_8[16:0]) //|< w
  ,.sq_pd_int8_lsb_7   (f_sq_pd_int8_msb_8[16:0]) //|< w
  ,.sq_pd_int8_lsb_8   (f_sq_pd_int8_lsb_9[16:0]) //|< w
  ,.sq_pd_int8_msb_0   (f_sq_pd_int8_msb_5[16:0]) //|< w
  ,.sq_pd_int8_msb_1   (f_sq_pd_int8_lsb_6[16:0]) //|< w
  ,.sq_pd_int8_msb_2   (f_sq_pd_int8_msb_6[16:0]) //|< w
  ,.sq_pd_int8_msb_3   (f_sq_pd_int8_lsb_7[16:0]) //|< w
  ,.sq_pd_int8_msb_4   (f_sq_pd_int8_msb_7[16:0]) //|< w
  ,.sq_pd_int8_msb_5   (f_sq_pd_int8_lsb_8[16:0]) //|< w
  ,.sq_pd_int8_msb_6   (f_sq_pd_int8_msb_8[16:0]) //|< w
  ,.sq_pd_int8_msb_7   (f_sq_pd_int8_lsb_9[16:0]) //|< w
  ,.sq_pd_int8_msb_8   (f_sq_pd_int8_msb_9[16:0]) //|< w
  ,.int16_sum          (int16_sum_4th[36:0])      //|> w
  ,.int8_sum           (int8_sum_4th[41:0])       //|> w
  );

assign int8_sum[167:0]  = {int8_sum_4th, int8_sum_3rd, int8_sum_2nd, int8_sum_1st};
assign int16_sum[167:0] = {5'd0,int16_sum_4th, 5'd0,int16_sum_3rd, 5'd0,int16_sum_2nd, 5'd0,int16_sum_1st};

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buf2sum_3d_vld <= 1'b0;
  end else begin
    if(buf2sum_2d_vld)
        buf2sum_3d_vld <= 1'b1;
    else if(buf2sum_3d_rdy)
        buf2sum_3d_vld <= 1'b0;
  end
end
assign buf2sum_3d_rdy  = sum_out_prdy;

//////slcg

//=====================================================================================================
//=====================================================================================================
//=====================================================================================================
//fp mode
//-----------------------------------------------------------------------------------------------------
assign fp16_din_pvld = (cdp_buf2sum_valid & fp16_en);
assign fp16_din_prdy = &fp17T32_i_prdy;
//===========================
//fp17 to fp32 convertor
//---------------------------
assign fp17T32_i_pvld[0]  = fp16_din_pvld & (len9) & (& fp17T32_i_prdy[11:1]);
assign fp17T32_i_pvld[1]  = fp16_din_pvld & (len9|len7) & (&{fp17T32_i_prdy[11:2] ,fp17T32_i_prdy[0]});
assign fp17T32_i_pvld[2]  = fp16_din_pvld & (len9|len7|len5) & (&{fp17T32_i_prdy[11:3] ,fp17T32_i_prdy[1:0]});
assign fp17T32_i_pvld[3]  = fp16_din_pvld & (&{fp17T32_i_prdy[11:4] ,fp17T32_i_prdy[2:0]});
assign fp17T32_i_pvld[4]  = fp16_din_pvld & (&{fp17T32_i_prdy[11:5] ,fp17T32_i_prdy[3:0]});
assign fp17T32_i_pvld[5]  = fp16_din_pvld & (&{fp17T32_i_prdy[11:6] ,fp17T32_i_prdy[4:0]});
assign fp17T32_i_pvld[6]  = fp16_din_pvld & (&{fp17T32_i_prdy[11:7] ,fp17T32_i_prdy[5:0]});
assign fp17T32_i_pvld[7]  = fp16_din_pvld & (&{fp17T32_i_prdy[11:8] ,fp17T32_i_prdy[6:0]});
assign fp17T32_i_pvld[8]  = fp16_din_pvld & (&{fp17T32_i_prdy[11:9] ,fp17T32_i_prdy[7:0]});
assign fp17T32_i_pvld[9]  = fp16_din_pvld & (len9|len7|len5) & (&{fp17T32_i_prdy[11:10],fp17T32_i_prdy[8:0]});
assign fp17T32_i_pvld[10] = fp16_din_pvld & (len9|len7) & (&{fp17T32_i_prdy[11]   ,fp17T32_i_prdy[9:0]});
assign fp17T32_i_pvld[11] = fp16_din_pvld & (len9) & (&{                      fp17T32_i_prdy[10:0]});
 HLS_fp17_to_fp32 u_fp17_to_fp32_0 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_0[16:0])     //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[0])        //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[0])        //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_0[31:0])     //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[0])        //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[0])        //|> w
   );
 assign fp17T32_o_prdy[0] = fp16_din_prdy_0[0] & fp16_din_prdy_1[0]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_1 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_1[16:0])     //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[1])        //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[1])        //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_1[31:0])     //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[1])        //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[1])        //|> w
   );
 assign fp17T32_o_prdy[1] = fp16_din_prdy_0[1] & fp16_din_prdy_1[1]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_2 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_2[16:0])     //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[2])        //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[2])        //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_2[31:0])     //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[2])        //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[2])        //|> w
   );
 assign fp17T32_o_prdy[2] = fp16_din_prdy_0[2] & fp16_din_prdy_1[2]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_3 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_3[16:0])     //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[3])        //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[3])        //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_3[31:0])     //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[3])        //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[3])        //|> w
   );
 assign fp17T32_o_prdy[3] = fp16_din_prdy_0[3] & fp16_din_prdy_1[3]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_4 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_4[16:0])     //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[4])        //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[4])        //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_4[31:0])     //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[4])        //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[4])        //|> w
   );
 assign fp17T32_o_prdy[4] = fp16_din_prdy_0[4] & fp16_din_prdy_1[4]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_5 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_5[16:0])     //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[5])        //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[5])        //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_5[31:0])     //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[5])        //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[5])        //|> w
   );
 assign fp17T32_o_prdy[5] = fp16_din_prdy_0[5] & fp16_din_prdy_1[5]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_6 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_6[16:0])     //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[6])        //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[6])        //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_6[31:0])     //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[6])        //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[6])        //|> w
   );
 assign fp17T32_o_prdy[6] = fp16_din_prdy_0[6] & fp16_din_prdy_1[6]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_7 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_7[16:0])     //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[7])        //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[7])        //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_7[31:0])     //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[7])        //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[7])        //|> w
   );
 assign fp17T32_o_prdy[7] = fp16_din_prdy_0[7] & fp16_din_prdy_1[7]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_8 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_8[16:0])     //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[8])        //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[8])        //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_8[31:0])     //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[8])        //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[8])        //|> w
   );
 assign fp17T32_o_prdy[8] = fp16_din_prdy_0[8] & fp16_din_prdy_1[8]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_9 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_9[16:0])     //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[9])        //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[9])        //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_9[31:0])     //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[9])        //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[9])        //|> w
   );
 assign fp17T32_o_prdy[9] = fp16_din_prdy_0[9] & fp16_din_prdy_1[9]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_10 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_10[16:0])    //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[10])       //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[10])       //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_10[31:0])    //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[10])       //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[10])       //|> w
   );
 assign fp17T32_o_prdy[10] = fp16_din_prdy_0[10] & fp16_din_prdy_1[10]; 
 HLS_fp17_to_fp32 u_fp17_to_fp32_11 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (buf2sum_fp16_11[16:0])    //|< w
   ,.chn_a_rsc_vz       (fp17T32_i_pvld[11])       //|< w
   ,.chn_a_rsc_lz       (fp17T32_i_prdy[11])       //|> w
   ,.chn_o_rsc_z        (fp17T32_o_dp_11[31:0])    //|> w
   ,.chn_o_rsc_vz       (fp17T32_o_prdy[11])       //|< w
   ,.chn_o_rsc_lz       (fp17T32_o_pvld[11])       //|> w
   );
 assign fp17T32_o_prdy[11] = fp16_din_prdy_0[11] & fp16_din_prdy_1[11]; 
//===========================
//fp square
//---------------------------
//fp16 valid in control, need sync 24 input data channel path
assign fp16_din_pvld_0[0]  = fp17T32_o_pvld[0]  & fp16_din_prdy_1[0];
assign fp16_din_pvld_1[0]  = fp17T32_o_pvld[0]  & fp16_din_prdy_0[0];
assign fp16_din_pvld_0[1]  = fp17T32_o_pvld[1]  & fp16_din_prdy_1[1];
assign fp16_din_pvld_1[1]  = fp17T32_o_pvld[1]  & fp16_din_prdy_0[1];
assign fp16_din_pvld_0[2]  = fp17T32_o_pvld[2]  & fp16_din_prdy_1[2];
assign fp16_din_pvld_1[2]  = fp17T32_o_pvld[2]  & fp16_din_prdy_0[2];
assign fp16_din_pvld_0[3]  = fp17T32_o_pvld[3]  & fp16_din_prdy_1[3];
assign fp16_din_pvld_1[3]  = fp17T32_o_pvld[3]  & fp16_din_prdy_0[3];
assign fp16_din_pvld_0[4]  = fp17T32_o_pvld[4]  & fp16_din_prdy_1[4];
assign fp16_din_pvld_1[4]  = fp17T32_o_pvld[4]  & fp16_din_prdy_0[4];
assign fp16_din_pvld_0[5]  = fp17T32_o_pvld[5]  & fp16_din_prdy_1[5];
assign fp16_din_pvld_1[5]  = fp17T32_o_pvld[5]  & fp16_din_prdy_0[5];
assign fp16_din_pvld_0[6]  = fp17T32_o_pvld[6]  & fp16_din_prdy_1[6];
assign fp16_din_pvld_1[6]  = fp17T32_o_pvld[6]  & fp16_din_prdy_0[6];
assign fp16_din_pvld_0[7]  = fp17T32_o_pvld[7]  & fp16_din_prdy_1[7];
assign fp16_din_pvld_1[7]  = fp17T32_o_pvld[7]  & fp16_din_prdy_0[7];
assign fp16_din_pvld_0[8]  = fp17T32_o_pvld[8]  & fp16_din_prdy_1[8];
assign fp16_din_pvld_1[8]  = fp17T32_o_pvld[8]  & fp16_din_prdy_0[8];
assign fp16_din_pvld_0[9]  = fp17T32_o_pvld[9]  & fp16_din_prdy_1[9];
assign fp16_din_pvld_1[9]  = fp17T32_o_pvld[9]  & fp16_din_prdy_0[9];
assign fp16_din_pvld_0[10] = fp17T32_o_pvld[10] & fp16_din_prdy_1[10];
assign fp16_din_pvld_1[10] = fp17T32_o_pvld[10] & fp16_din_prdy_0[10];
assign fp16_din_pvld_0[11] = fp17T32_o_pvld[11] & fp16_din_prdy_1[11];
assign fp16_din_pvld_1[11] = fp17T32_o_pvld[11] & fp16_din_prdy_0[11];

//fp square instance
 HLS_fp32_mul u_HLS_fp32_mul_0 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_0[31:0])     //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[0])       //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[0])       //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_0[31:0])     //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[0])       //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[0])       //|> w
   ,.chn_o_rsc_z        (fp16_dout_0[31:0])        //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[0])        //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[0])        //|> w
   );
 assign f_fp16_dout_0 = fp16_dout_0[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_1 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_1[31:0])     //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[1])       //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[1])       //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_1[31:0])     //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[1])       //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[1])       //|> w
   ,.chn_o_rsc_z        (fp16_dout_1[31:0])        //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[1])        //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[1])        //|> w
   );
 assign f_fp16_dout_1 = fp16_dout_1[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_2 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_2[31:0])     //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[2])       //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[2])       //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_2[31:0])     //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[2])       //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[2])       //|> w
   ,.chn_o_rsc_z        (fp16_dout_2[31:0])        //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[2])        //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[2])        //|> w
   );
 assign f_fp16_dout_2 = fp16_dout_2[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_3 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_3[31:0])     //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[3])       //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[3])       //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_3[31:0])     //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[3])       //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[3])       //|> w
   ,.chn_o_rsc_z        (fp16_dout_3[31:0])        //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[3])        //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[3])        //|> w
   );
 assign f_fp16_dout_3 = fp16_dout_3[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_4 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_4[31:0])     //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[4])       //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[4])       //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_4[31:0])     //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[4])       //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[4])       //|> w
   ,.chn_o_rsc_z        (fp16_dout_4[31:0])        //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[4])        //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[4])        //|> w
   );
 assign f_fp16_dout_4 = fp16_dout_4[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_5 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_5[31:0])     //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[5])       //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[5])       //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_5[31:0])     //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[5])       //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[5])       //|> w
   ,.chn_o_rsc_z        (fp16_dout_5[31:0])        //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[5])        //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[5])        //|> w
   );
 assign f_fp16_dout_5 = fp16_dout_5[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_6 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_6[31:0])     //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[6])       //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[6])       //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_6[31:0])     //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[6])       //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[6])       //|> w
   ,.chn_o_rsc_z        (fp16_dout_6[31:0])        //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[6])        //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[6])        //|> w
   );
 assign f_fp16_dout_6 = fp16_dout_6[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_7 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_7[31:0])     //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[7])       //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[7])       //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_7[31:0])     //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[7])       //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[7])       //|> w
   ,.chn_o_rsc_z        (fp16_dout_7[31:0])        //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[7])        //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[7])        //|> w
   );
 assign f_fp16_dout_7 = fp16_dout_7[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_8 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_8[31:0])     //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[8])       //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[8])       //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_8[31:0])     //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[8])       //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[8])       //|> w
   ,.chn_o_rsc_z        (fp16_dout_8[31:0])        //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[8])        //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[8])        //|> w
   );
 assign f_fp16_dout_8 = fp16_dout_8[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_9 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_9[31:0])     //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[9])       //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[9])       //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_9[31:0])     //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[9])       //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[9])       //|> w
   ,.chn_o_rsc_z        (fp16_dout_9[31:0])        //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[9])        //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[9])        //|> w
   );
 assign f_fp16_dout_9 = fp16_dout_9[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_10 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_10[31:0])    //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[10])      //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[10])      //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_10[31:0])    //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[10])      //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[10])      //|> w
   ,.chn_o_rsc_z        (fp16_dout_10[31:0])       //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[10])       //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[10])       //|> w
   );
 assign f_fp16_dout_10 = fp16_dout_10[31:0]; 
 HLS_fp32_mul u_HLS_fp32_mul_11 (
    .nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
   ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
   ,.chn_a_rsc_z        (fp17T32_o_dp_11[31:0])    //|< w
   ,.chn_a_rsc_vz       (fp16_din_pvld_0[11])      //|< w
   ,.chn_a_rsc_lz       (fp16_din_prdy_0[11])      //|> w
   ,.chn_b_rsc_z        (fp17T32_o_dp_11[31:0])    //|< w
   ,.chn_b_rsc_vz       (fp16_din_pvld_1[11])      //|< w
   ,.chn_b_rsc_lz       (fp16_din_prdy_1[11])      //|> w
   ,.chn_o_rsc_z        (fp16_dout_11[31:0])       //|> w
   ,.chn_o_rsc_vz       (fp16_dout_prdy[11])       //|< w
   ,.chn_o_rsc_lz       (fp16_dout_pvld[11])       //|> w
   );
 assign f_fp16_dout_11 = fp16_dout_11[31:0]; 

assign fp16_dout_prdy[0] = len9 ? (fp_sq_out_rdy & (&fp16_dout_pvld[11:1])) : fp_sq_out_rdy;
assign fp16_dout_prdy[1] = len9 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[11:2], fp16_dout_pvld[0]})) 
                         : len7 ? (fp_sq_out_rdy & (&fp16_dout_pvld[10:2]))
                         : fp_sq_out_rdy;
assign fp16_dout_prdy[2] = len9 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[11:3], fp16_dout_pvld[1:0]}))
                         : len7 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[10:3], fp16_dout_pvld[1  ]}))
                         : len5 ? (fp_sq_out_rdy & (&fp16_dout_pvld[9:3]))
                         : fp_sq_out_rdy;
assign fp16_dout_prdy[3] = len9 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[11:4], fp16_dout_pvld[2:0]}))
                         : len7 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[10:4], fp16_dout_pvld[2:1]}))
                         : len5 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[9:4], fp16_dout_pvld[2  ]}))
                         : (fp_sq_out_rdy & (&fp16_dout_pvld[8:4]));
assign fp16_dout_prdy[4] = len9 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[11:5], fp16_dout_pvld[3:0]}))
                         : len7 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[10:5], fp16_dout_pvld[3:1]}))
                         : len5 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[9:5] , fp16_dout_pvld[3:2]}))
                         :        (fp_sq_out_rdy & (&{fp16_dout_pvld[8:5] , fp16_dout_pvld[3]}));
assign fp16_dout_prdy[5] = len9 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[11:6], fp16_dout_pvld[4:0]}))
                         : len7 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[10:6], fp16_dout_pvld[4:1]}))
                         : len5 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[9:6] , fp16_dout_pvld[4:2]}))
                         :        (fp_sq_out_rdy & (&{fp16_dout_pvld[8:6] , fp16_dout_pvld[4:3]}));
assign fp16_dout_prdy[6] = len9 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[11:7], fp16_dout_pvld[5:0]}))
                         : len7 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[10:7], fp16_dout_pvld[5:1]}))
                         : len5 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[9:7] , fp16_dout_pvld[5:2]}))
                         :        (fp_sq_out_rdy & (&{fp16_dout_pvld[8:7] , fp16_dout_pvld[5:3]}));
assign fp16_dout_prdy[7] = len9 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[11:8], fp16_dout_pvld[6:0]}))
                         : len7 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[10:8], fp16_dout_pvld[6:1]}))
                         : len5 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[9:8] , fp16_dout_pvld[6:2]}))
                         :        (fp_sq_out_rdy & (&{fp16_dout_pvld[8]   , fp16_dout_pvld[6:3]}));
assign fp16_dout_prdy[8] = len9 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[11:9], fp16_dout_pvld[7:0]}))
                         : len7 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[10:9], fp16_dout_pvld[7:1]}))
                         : len5 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[   9], fp16_dout_pvld[7:2]}))
                         : (fp_sq_out_rdy & (&fp16_dout_pvld[7:3]));
assign fp16_dout_prdy[9] = len9 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[11:10], fp16_dout_pvld[8:0]}))
                         : len7 ? (fp_sq_out_rdy & (&{fp16_dout_pvld[10], fp16_dout_pvld[8:1]}))
                         : len5 ? (fp_sq_out_rdy & ((&fp16_dout_pvld[8:2])))
                         : fp_sq_out_rdy;
assign fp16_dout_prdy[10]= len9 ? (fp_sq_out_rdy & ( fp16_dout_pvld[11]   & (&fp16_dout_pvld[9:0])))
                         : len7 ? (fp_sq_out_rdy & ((&fp16_dout_pvld[9:1])))
                         : fp_sq_out_rdy;
assign fp16_dout_prdy[11]= len9 ? (fp_sq_out_rdy & ((&fp16_dout_pvld[10:0]))) : fp_sq_out_rdy;
//sq output valid
assign fp_sq_out_vld = len9 ? (&fp16_dout_pvld[11:0])
                     : len7 ? (&fp16_dout_pvld[10:1])
                     : len5 ? (&fp16_dout_pvld[9:2])
                     : (&fp16_dout_pvld[8:3]);
//sq output valid
//   fp_sq_out_rdy

//===========================
//fp sum
//---------------------------
assign fp_sq_out_rdy = fp_sq_out_rdy_0 & fp_sq_out_rdy_1 & fp_sq_out_rdy_2 & fp_sq_out_rdy_3;

assign fp_sq_out_vld_0 = fp_sq_out_vld & (fp_sq_out_rdy_1 & fp_sq_out_rdy_2 & fp_sq_out_rdy_3);
assign fp_sq_out_vld_1 = fp_sq_out_vld & (fp_sq_out_rdy_0 & fp_sq_out_rdy_2 & fp_sq_out_rdy_3);
assign fp_sq_out_vld_2 = fp_sq_out_vld & (fp_sq_out_rdy_0 & fp_sq_out_rdy_1 & fp_sq_out_rdy_3);
assign fp_sq_out_vld_3 = fp_sq_out_vld & (fp_sq_out_rdy_0 & fp_sq_out_rdy_1 & fp_sq_out_rdy_2);

//fp sum 1st
fp_sum_block u_fp_sum_block_0 (
   .fp16_dout_0        (f_fp16_dout_0[31:0])      //|< w
  ,.fp16_dout_1        (f_fp16_dout_1[31:0])      //|< w
  ,.fp16_dout_2        (f_fp16_dout_2[31:0])      //|< w
  ,.fp16_dout_3        (f_fp16_dout_3[31:0])      //|< w
  ,.fp16_dout_4        (f_fp16_dout_4[31:0])      //|< w
  ,.fp16_dout_5        (f_fp16_dout_5[31:0])      //|< w
  ,.fp16_dout_6        (f_fp16_dout_6[31:0])      //|< w
  ,.fp16_dout_7        (f_fp16_dout_7[31:0])      //|< w
  ,.fp16_dout_8        (f_fp16_dout_8[31:0])      //|< w
  ,.fp16_sum_rdy       (fp16_sum_rdy_0)           //|< w
  ,.fp_sq_out_vld      (fp_sq_out_vld_0)          //|< w
  ,.len3               (len3)                     //|< w
  ,.len5               (len5)                     //|< w
  ,.len7               (len7)                     //|< w
  ,.len9               (len9)                     //|< w
  ,.nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
  ,.reg2dp_normalz_len (reg2dp_normalz_len[1:0])  //|< i
  ,.fp16_sum           (fp16_sum_0[31:0])         //|> w
  ,.fp16_sum_vld       (fp16_sum_vld_0)           //|> w
  ,.fp_sq_out_rdy      (fp_sq_out_rdy_0)          //|> w
  );

fp_sum_block u_fp_sum_block_1 (
   .fp16_dout_0        (f_fp16_dout_1[31:0])      //|< w
  ,.fp16_dout_1        (f_fp16_dout_2[31:0])      //|< w
  ,.fp16_dout_2        (f_fp16_dout_3[31:0])      //|< w
  ,.fp16_dout_3        (f_fp16_dout_4[31:0])      //|< w
  ,.fp16_dout_4        (f_fp16_dout_5[31:0])      //|< w
  ,.fp16_dout_5        (f_fp16_dout_6[31:0])      //|< w
  ,.fp16_dout_6        (f_fp16_dout_7[31:0])      //|< w
  ,.fp16_dout_7        (f_fp16_dout_8[31:0])      //|< w
  ,.fp16_dout_8        (f_fp16_dout_9[31:0])      //|< w
  ,.fp16_sum_rdy       (fp16_sum_rdy_1)           //|< w
  ,.fp_sq_out_vld      (fp_sq_out_vld_1)          //|< w
  ,.len3               (len3)                     //|< w
  ,.len5               (len5)                     //|< w
  ,.len7               (len7)                     //|< w
  ,.len9               (len9)                     //|< w
  ,.nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
  ,.reg2dp_normalz_len (reg2dp_normalz_len[1:0])  //|< i
  ,.fp16_sum           (fp16_sum_1[31:0])         //|> w
  ,.fp16_sum_vld       (fp16_sum_vld_1)           //|> w
  ,.fp_sq_out_rdy      (fp_sq_out_rdy_1)          //|> w
  );

fp_sum_block u_fp_sum_block_2 (
   .fp16_dout_0        (f_fp16_dout_2[31:0])      //|< w
  ,.fp16_dout_1        (f_fp16_dout_3[31:0])      //|< w
  ,.fp16_dout_2        (f_fp16_dout_4[31:0])      //|< w
  ,.fp16_dout_3        (f_fp16_dout_5[31:0])      //|< w
  ,.fp16_dout_4        (f_fp16_dout_6[31:0])      //|< w
  ,.fp16_dout_5        (f_fp16_dout_7[31:0])      //|< w
  ,.fp16_dout_6        (f_fp16_dout_8[31:0])      //|< w
  ,.fp16_dout_7        (f_fp16_dout_9[31:0])      //|< w
  ,.fp16_dout_8        (f_fp16_dout_10[31:0])     //|< w
  ,.fp16_sum_rdy       (fp16_sum_rdy_2)           //|< w
  ,.fp_sq_out_vld      (fp_sq_out_vld_2)          //|< w
  ,.len3               (len3)                     //|< w
  ,.len5               (len5)                     //|< w
  ,.len7               (len7)                     //|< w
  ,.len9               (len9)                     //|< w
  ,.nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
  ,.reg2dp_normalz_len (reg2dp_normalz_len[1:0])  //|< i
  ,.fp16_sum           (fp16_sum_2[31:0])         //|> w
  ,.fp16_sum_vld       (fp16_sum_vld_2)           //|> w
  ,.fp_sq_out_rdy      (fp_sq_out_rdy_2)          //|> w
  );

fp_sum_block u_fp_sum_block_3 (
   .fp16_dout_0        (f_fp16_dout_3[31:0])      //|< w
  ,.fp16_dout_1        (f_fp16_dout_4[31:0])      //|< w
  ,.fp16_dout_2        (f_fp16_dout_5[31:0])      //|< w
  ,.fp16_dout_3        (f_fp16_dout_6[31:0])      //|< w
  ,.fp16_dout_4        (f_fp16_dout_7[31:0])      //|< w
  ,.fp16_dout_5        (f_fp16_dout_8[31:0])      //|< w
  ,.fp16_dout_6        (f_fp16_dout_9[31:0])      //|< w
  ,.fp16_dout_7        (f_fp16_dout_10[31:0])     //|< w
  ,.fp16_dout_8        (f_fp16_dout_11[31:0])     //|< w
  ,.fp16_sum_rdy       (fp16_sum_rdy_3)           //|< w
  ,.fp_sq_out_vld      (fp_sq_out_vld_3)          //|< w
  ,.len3               (len3)                     //|< w
  ,.len5               (len5)                     //|< w
  ,.len7               (len7)                     //|< w
  ,.len9               (len9)                     //|< w
  ,.nvdla_core_clk     (nvdla_op_gated_clk_fp16)  //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)          //|< i
  ,.reg2dp_normalz_len (reg2dp_normalz_len[1:0])  //|< i
  ,.fp16_sum           (fp16_sum_3[31:0])         //|> w
  ,.fp16_sum_vld       (fp16_sum_vld_3)           //|> w
  ,.fp_sq_out_rdy      (fp_sq_out_rdy_3)          //|> w
  );

assign fp16_sum_rdy_0 = fp16_sum_rdy & (fp16_sum_vld_3 & fp16_sum_vld_2 & fp16_sum_vld_1);
assign fp16_sum_rdy_1 = fp16_sum_rdy & (fp16_sum_vld_3 & fp16_sum_vld_2 & fp16_sum_vld_0);
assign fp16_sum_rdy_2 = fp16_sum_rdy & (fp16_sum_vld_3 & fp16_sum_vld_1 & fp16_sum_vld_0);
assign fp16_sum_rdy_3 = fp16_sum_rdy & (fp16_sum_vld_2 & fp16_sum_vld_1 & fp16_sum_vld_0);

assign fp16_sum_vld = fp16_sum_vld_3 & fp16_sum_vld_2 & fp16_sum_vld_1 & fp16_sum_vld_0;
/////////////////////////////////////////////////
assign fp16_sum_rdy = sum_out_prdy;
assign fp16_sum_pvld = fp16_sum_vld;
assign fp16_sum = {10'd0,fp16_sum_3, 10'd0,fp16_sum_2, 10'd0,fp16_sum_1, 10'd0,fp16_sum_0};

//=======================================================
//data output select
//-------------------------------------------------------
assign sum_out_pd[167:0] = fp16_en? fp16_sum : (int16_en? int16_sum : int8_sum);
assign sum_out_pvld = fp16_en? fp16_sum_pvld : buf2sum_3d_vld;

////////////////////////////////////
//assign sum_out_prdy = sum2sync_prdy & sum2itp_ready;
assign sum_out_prdy = sum2itp_ready;

//assign sum2itp_valid  = sum_out_pvld & sum2sync_prdy;
assign sum2itp_valid  = sum_out_pvld;
assign sum2itp_data = sum_out_pd[167:0];
//assign sum2sync_pvld = sum_out_pvld & sum2itp_ready;
//assign sum2sync_pd= sum_out_pd[167:0];

//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     sum2itp_valid
  or p2_pipe_rand_ready
  or sum2itp_data
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = sum2itp_valid;
  sum2itp_ready = p2_pipe_rand_ready;
  p2_pipe_rand_data = sum2itp_data;
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : sum2itp_valid;
  sum2itp_ready = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : sum2itp_data;
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
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_sum_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or sum2itp_valid
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && sum2itp_valid === 1'b1;
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
  or sum2itp_prdy
  or p2_pipe_data
  ) begin
  sum2itp_pvld = p2_pipe_valid;
  p2_pipe_ready = sum2itp_prdy;
  sum2itp_pd = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sum2itp_pvld^sum2itp_prdy^sum2itp_valid^sum2itp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (sum2itp_valid && !sum2itp_ready), (sum2itp_valid), (sum2itp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_sum


