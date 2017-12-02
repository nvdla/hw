// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_READ_IG_spt.v

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_READ_IG_spt (
   nvdla_core_clk    //|< i
  ,nvdla_core_rstn   //|< i
  ,arb2spt_req_valid //|< i
  ,arb2spt_req_ready //|> o
  ,arb2spt_req_pd    //|< i
  ,spt2cvt_req_valid //|> o
  ,spt2cvt_req_ready //|< i
  ,spt2cvt_req_pd    //|> o
  );
//
// NV_NVDLA_MCIF_READ_IG_spt_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         arb2spt_req_valid;  /* data valid */
output        arb2spt_req_ready;  /* data return handshake */
input  [74:0] arb2spt_req_pd;

output        spt2cvt_req_valid;  /* data valid */
input         spt2cvt_req_ready;  /* data return handshake */
output [74:0] spt2cvt_req_pd;

reg     [1:0] beat_count;
reg     [2:0] out_size;
reg    [74:0] p2_pipe_data;
reg    [74:0] p2_pipe_rand_data;
reg           p2_pipe_rand_ready;
reg           p2_pipe_rand_valid;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg    [74:0] p2_pipe_skid_data;
reg           p2_pipe_skid_ready;
reg           p2_pipe_skid_valid;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [74:0] p2_skid_data;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
reg    [74:0] spt2cvt_req_pd;
reg           spt2cvt_req_valid;
reg           spt_out_rdy;
wire    [1:0] beat_size;
wire    [2:0] first_addr_offset;
wire          is_first_beat;
wire          is_ftran_odd;
wire          is_last_beat;
wire          is_ltran_odd;
wire          mon_beat_size_c;
wire    [2:0] non_first_addr_offset;
wire   [63:0] out_addr;
wire    [2:0] out_addr_offset;
wire          out_ftran;
wire          out_ltran;
wire          req_accept;
wire   [63:0] spt2cvt_addr;
wire    [3:0] spt2cvt_axid;
wire          spt2cvt_ftran;
wire          spt2cvt_ltran;
wire          spt2cvt_odd;
wire    [2:0] spt2cvt_size;
wire          spt2cvt_swizzle;
wire          spt_inc;
wire   [74:0] spt_out_pd;
wire          spt_out_vld;
wire   [63:0] spt_req_addr;
wire    [3:0] spt_req_axid;
wire          spt_req_ftran;
wire          spt_req_ltran;
wire          spt_req_odd;
wire    [2:0] spt_req_offset;
wire   [74:0] spt_req_pd;
wire          spt_req_rdy;
wire    [2:0] spt_req_size;
wire          spt_req_swizzle;
wire          spt_req_vld;
wire   [74:0] spt_req_vld_pd;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
NV_NVDLA_MCIF_READ_IG_SPT_pipe_p1 pipe_p1 (
   .nvdla_core_clk    (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)      //|< i
  ,.arb2spt_req_pd    (arb2spt_req_pd[74:0]) //|< i
  ,.arb2spt_req_valid (arb2spt_req_valid)    //|< i
  ,.spt_req_rdy       (spt_req_rdy)          //|< w
  ,.arb2spt_req_ready (arb2spt_req_ready)    //|> o
  ,.spt_req_pd        (spt_req_pd[74:0])     //|> w
  ,.spt_req_vld       (spt_req_vld)          //|> w
  );
assign spt_req_rdy = spt_out_rdy & is_last_beat;

assign spt_req_vld_pd = {75 {spt_req_vld}} & spt_req_pd;

// PKT_UNPACK_WIRE( cvt_read_cmd , spt_req_ , spt_req_vld_pd )
assign       spt_req_axid[3:0] =    spt_req_vld_pd[3:0];
assign       spt_req_addr[63:0] =    spt_req_vld_pd[67:4];
assign       spt_req_size[2:0] =    spt_req_vld_pd[70:68];
assign        spt_req_swizzle  =    spt_req_vld_pd[71];
assign        spt_req_odd  =    spt_req_vld_pd[72];
assign        spt_req_ltran  =    spt_req_vld_pd[73];
assign        spt_req_ftran  =    spt_req_vld_pd[74];
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
  wire cond_zzz_assert_always_1x = (spt_req_addr[4:0] == 0);
  nv_assert_always #(0,0,"lower 5 LSB should always be 0")      zzz_assert_always_1x (.clk(nvdla_core_clk), .reset_(`ASSERT_RESET), .test_expr(cond_zzz_assert_always_1x)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// size -> size_64 mapping & Split
//==============
assign spt_inc = spt_req_ftran & spt_req_ltran & spt_req_swizzle & !spt_req_odd;
assign {mon_beat_size_c,beat_size[1:0]} =  spt_req_size[2:1] + spt_inc;
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
  nv_assert_never #(0,0,"should never overflow")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, mon_beat_size_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_count <= {2{1'b0}};
  end else begin
    if (req_accept) begin
        if (is_last_beat) begin
            beat_count <= 0;
        end else begin
            beat_count <= beat_count + 1;
        end
    end
  end
end

assign is_last_beat  = (beat_count==beat_size);
assign is_first_beat = (beat_count==0);

//==============
// OUT: FTRAN / LTRAN
//==============
assign out_ftran = spt_req_ftran & is_first_beat;
assign out_ltran = spt_req_ltran & is_last_beat;
        
//==============
// OUT: SIZE
//==============
assign is_ftran_odd = spt_req_swizzle;
assign is_ltran_odd = (spt_req_swizzle ^ spt_req_odd);
always @(
  out_ftran
  or is_ftran_odd
  or out_ltran
  or is_ltran_odd
  ) begin
    if ((out_ftran && is_ftran_odd) || (out_ltran && is_ltran_odd)) begin
        out_size = 3'd0;
    end else begin
        out_size = 3'd1;
    end
end

//==============
// OUT: ADDR
//==============
assign spt_req_offset = spt_req_addr[7:5];
assign first_addr_offset = spt_req_offset;
assign non_first_addr_offset[2:0] = (spt_req_offset[2:1] + beat_count) << 1; //spyglass disable SelfDeterminedExpr-ML

assign out_addr_offset = (beat_count==0) ? first_addr_offset : non_first_addr_offset;
//assign out_addr = {spt_req_addr[39:8],out_addr_offset,{5{1'b0}}};
assign out_addr = {spt_req_addr[63:8],out_addr_offset,{5{1'b0}}};  //stepheng.

assign spt2cvt_addr = out_addr;
assign spt2cvt_size = out_size;
assign spt2cvt_swizzle = spt_req_swizzle;
assign spt2cvt_odd   = spt_req_odd;
assign spt2cvt_ftran  = out_ftran;
assign spt2cvt_ltran  = out_ltran;
//assign spt2cvt_user_size   = spt_req_user_size; //stepheng
assign spt2cvt_axid = spt_req_axid;

assign req_accept = spt_out_vld & spt_out_rdy;

assign spt_out_vld = spt_req_vld;

// PKT_PACK_WIRE( cvt_read_cmd , spt2cvt_ , spt_out_pd )
assign      spt_out_pd[3:0] =    spt2cvt_axid[3:0];
assign      spt_out_pd[67:4] =    spt2cvt_addr[63:0];
assign      spt_out_pd[70:68] =    spt2cvt_size[2:0];
assign      spt_out_pd[71] =    spt2cvt_swizzle ;
assign      spt_out_pd[72] =    spt2cvt_odd ;
assign      spt_out_pd[73] =    spt2cvt_ltran ;
assign      spt_out_pd[74] =    spt2cvt_ftran ;
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     spt_out_vld
  or p2_pipe_rand_ready
  or spt_out_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = spt_out_vld;
  spt_out_rdy = p2_pipe_rand_ready;
  p2_pipe_rand_data = spt_out_pd;
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : spt_out_vld;
  spt_out_rdy = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : spt_out_pd;
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
  if      ( $value$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or spt_out_vld
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && spt_out_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p2_pipe_rand_poised) begin
    if (p2_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p2_pipe_stall_cycles <= prand_inst1(p2_pipe_stall_cycles_min, p2_pipe_stall_cycles_max);
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
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_pipe_rand_valid)? p2_pipe_rand_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_pipe_rand_ready = p2_pipe_ready_bc;
end
//## pipe (2) skid buffer
always @(
  p2_pipe_valid
  or p2_skid_ready_flop
  or p2_pipe_skid_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_valid && p2_skid_ready_flop && !p2_pipe_skid_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_pipe_skid_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_pipe_skid_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_valid
  or p2_skid_valid
  or p2_pipe_data
  or p2_skid_data
  ) begin
  p2_pipe_skid_valid = (p2_skid_ready_flop)? p2_pipe_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_pipe_skid_data = (p2_skid_ready_flop)? p2_pipe_data : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) output
always @(
  p2_pipe_skid_valid
  or spt2cvt_req_ready
  or p2_pipe_skid_data
  ) begin
  spt2cvt_req_valid = p2_pipe_skid_valid;
  p2_pipe_skid_ready = spt2cvt_req_ready;
  spt2cvt_req_pd = p2_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (spt2cvt_req_valid^spt2cvt_req_ready^spt_out_vld^spt_out_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (spt_out_vld && !spt_out_rdy), (spt_out_vld), (spt_out_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

    property mcif_spt__addr_is_swizzle_not_odd__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_req_swizzle & !spt_req_odd);
    endproperty
    // Cover 0 : "spt_req_swizzle & !spt_req_odd"
    FUNCPOINT_mcif_spt__addr_is_swizzle_not_odd__0_COV : cover property (mcif_spt__addr_is_swizzle_not_odd__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property mcif_spt__addr_is_swizzle_and_odd__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_req_swizzle & !spt_req_odd);
    endproperty
    // Cover 1 : "spt_req_swizzle & !spt_req_odd"
    FUNCPOINT_mcif_spt__addr_is_swizzle_and_odd__1_COV : cover property (mcif_spt__addr_is_swizzle_and_odd__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property mcif_spt__size_need_expand_by_1__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_inc);
    endproperty
    // Cover 2 : "spt_inc"
    FUNCPOINT_mcif_spt__size_need_expand_by_1__2_COV : cover property (mcif_spt__size_need_expand_by_1__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property mcif_spt__addr_offset_EQ_0__3_0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_req_offset == 0);
    endproperty
    // Cover 3_0 : "spt_req_offset == 0"
    FUNCPOINT_mcif_spt__addr_offset_EQ_0__3_0_COV : cover property (mcif_spt__addr_offset_EQ_0__3_0_cov);

    property mcif_spt__addr_offset_EQ_1__3_1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_req_offset == 1);
    endproperty
    // Cover 3_1 : "spt_req_offset == 1"
    FUNCPOINT_mcif_spt__addr_offset_EQ_1__3_1_COV : cover property (mcif_spt__addr_offset_EQ_1__3_1_cov);

    property mcif_spt__addr_offset_EQ_2__3_2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_req_offset == 2);
    endproperty
    // Cover 3_2 : "spt_req_offset == 2"
    FUNCPOINT_mcif_spt__addr_offset_EQ_2__3_2_COV : cover property (mcif_spt__addr_offset_EQ_2__3_2_cov);

    property mcif_spt__addr_offset_EQ_3__3_3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_req_offset == 3);
    endproperty
    // Cover 3_3 : "spt_req_offset == 3"
    FUNCPOINT_mcif_spt__addr_offset_EQ_3__3_3_COV : cover property (mcif_spt__addr_offset_EQ_3__3_3_cov);

    property mcif_spt__addr_offset_EQ_4__3_4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_req_offset == 4);
    endproperty
    // Cover 3_4 : "spt_req_offset == 4"
    FUNCPOINT_mcif_spt__addr_offset_EQ_4__3_4_COV : cover property (mcif_spt__addr_offset_EQ_4__3_4_cov);

    property mcif_spt__addr_offset_EQ_5__3_5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_req_offset == 5);
    endproperty
    // Cover 3_5 : "spt_req_offset == 5"
    FUNCPOINT_mcif_spt__addr_offset_EQ_5__3_5_COV : cover property (mcif_spt__addr_offset_EQ_5__3_5_cov);

    property mcif_spt__addr_offset_EQ_6__3_6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_req_offset == 6);
    endproperty
    // Cover 3_6 : "spt_req_offset == 6"
    FUNCPOINT_mcif_spt__addr_offset_EQ_6__3_6_COV : cover property (mcif_spt__addr_offset_EQ_6__3_6_cov);

    property mcif_spt__addr_offset_EQ_7__3_7_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((spt_req_vld) && nvdla_core_rstn) |-> (spt_req_offset == 7);
    endproperty
    // Cover 3_7 : "spt_req_offset == 7"
    FUNCPOINT_mcif_spt__addr_offset_EQ_7__3_7_COV : cover property (mcif_spt__addr_offset_EQ_7__3_7_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_MCIF_READ_IG_spt



// **************************************************************************************************************
// Generated by ::pipe -m -bc spt_req_pd (spt_req_vld,spt_req_rdy) <= arb2spt_req_pd[74:0] (arb2spt_req_valid,arb2spt_req_ready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_IG_SPT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb2spt_req_pd
  ,arb2spt_req_valid
  ,spt_req_rdy
  ,arb2spt_req_ready
  ,spt_req_pd
  ,spt_req_vld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [74:0] arb2spt_req_pd;
input         arb2spt_req_valid;
input         spt_req_rdy;
output        arb2spt_req_ready;
output [74:0] spt_req_pd;
output        spt_req_vld;
reg           arb2spt_req_ready;
reg    [74:0] p1_pipe_data;
reg    [74:0] p1_pipe_rand_data;
reg           p1_pipe_rand_ready;
reg           p1_pipe_rand_valid;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg    [74:0] spt_req_pd;
reg           spt_req_vld;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     arb2spt_req_valid
  or p1_pipe_rand_ready
  or arb2spt_req_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = arb2spt_req_valid;
  arb2spt_req_ready = p1_pipe_rand_ready;
  p1_pipe_rand_data = arb2spt_req_pd[74:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : arb2spt_req_valid;
  arb2spt_req_ready = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : arb2spt_req_pd[74:0];
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
  if      ( $value$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_IG_spt_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or arb2spt_req_valid
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && arb2spt_req_valid === 1'b1;
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
  or spt_req_rdy
  or p1_pipe_data
  ) begin
  spt_req_vld = p1_pipe_valid;
  p1_pipe_ready = spt_req_rdy;
  spt_req_pd = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (spt_req_vld^spt_req_rdy^arb2spt_req_valid^arb2spt_req_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (arb2spt_req_valid && !arb2spt_req_ready), (arb2spt_req_valid), (arb2spt_req_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_READ_IG_SPT_pipe_p1


