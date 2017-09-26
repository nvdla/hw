// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_mul.v

module NV_NVDLA_CDP_DP_mul (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,fp16_en                 //|< i
  ,int16_en                //|< i
  ,int8_en                 //|< i
  ,intp2mul_pd_0           //|< i
  ,intp2mul_pd_1           //|< i
  ,intp2mul_pd_2           //|< i
  ,intp2mul_pd_3           //|< i
  ,intp2mul_pd_4           //|< i
  ,intp2mul_pd_5           //|< i
  ,intp2mul_pd_6           //|< i
  ,intp2mul_pd_7           //|< i
  ,intp2mul_pvld           //|< i
  ,mul2ocvt_prdy           //|< i
  ,nvdla_op_gated_clk_fp16 //|< i
  ,nvdla_op_gated_clk_int  //|< i
  ,reg2dp_input_data_type  //|< i
  ,reg2dp_mul_bypass       //|< i
  ,sync2mul_pd             //|< i
  ,sync2mul_pvld           //|< i
  ,intp2mul_prdy           //|> o
  ,mul2ocvt_pd             //|> o
  ,mul2ocvt_pvld           //|> o
  ,sync2mul_prdy           //|> o
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          fp16_en;
input          int16_en;
input          int8_en;
input   [16:0] intp2mul_pd_0;
input   [16:0] intp2mul_pd_1;
input   [16:0] intp2mul_pd_2;
input   [16:0] intp2mul_pd_3;
input   [16:0] intp2mul_pd_4;
input   [16:0] intp2mul_pd_5;
input   [16:0] intp2mul_pd_6;
input   [16:0] intp2mul_pd_7;
input          intp2mul_pvld;
input          mul2ocvt_prdy;
input          nvdla_op_gated_clk_fp16;
input          nvdla_op_gated_clk_int;
input    [1:0] reg2dp_input_data_type;
input          reg2dp_mul_bypass;
input   [71:0] sync2mul_pd;
input          sync2mul_pvld;
output         intp2mul_prdy;
output [199:0] mul2ocvt_pd;
output         mul2ocvt_pvld;
output         sync2mul_prdy;
reg    [199:0] mul2ocvt_pd;
reg            mul2ocvt_prdy_f;
reg            mul2ocvt_pvld;
reg            mul_bypass_en;
reg    [199:0] p1_pipe_data;
reg    [199:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [199:0] p1_skid_data;
reg    [199:0] p1_skid_pipe_data;
reg            p1_skid_pipe_ready;
reg            p1_skid_pipe_valid;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
wire    [16:0] icvt_out_0;
wire    [16:0] icvt_out_1;
wire    [16:0] icvt_out_2;
wire    [16:0] icvt_out_3;
wire   [199:0] intp_out_ext;
wire   [199:0] intp_out_fp16;
wire    [49:0] intp_out_fp16_0;
wire    [49:0] intp_out_fp16_1;
wire    [49:0] intp_out_fp16_2;
wire    [49:0] intp_out_fp16_3;
wire   [199:0] intp_out_int16;
wire   [199:0] intp_out_int8;
wire     [3:0] is_nan_in;
wire   [199:0] mul2ocvt_pd_f;
wire           mul2ocvt_pvld_f;
wire           mul_in_rdy;
wire           mul_in_vld;
wire     [3:0] mul_rdy;
wire    [49:0] mul_unit_pd_0;
wire    [49:0] mul_unit_pd_1;
wire    [49:0] mul_unit_pd_2;
wire    [49:0] mul_unit_pd_3;
wire     [3:0] mul_unit_rdy;
wire     [3:0] mul_unit_vld;
wire     [3:0] mul_vld;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    ///////////////////////////////////////////
//interlock two path data 
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mul_bypass_en <= 1'b0;
  end else begin
  mul_bypass_en <= reg2dp_mul_bypass   == 1'h1;
  end
end

//assign intp2mul_prdy = mul_in_rdy & sync2mul_pvld;
//assign sync2mul_prdy = mul_in_rdy & intp2mul_pvld;
//assign mul_in_vld = sync2mul_pvld & intp2mul_pvld;
assign intp2mul_prdy = (mul_bypass_en ? mul2ocvt_prdy_f : mul_in_rdy) & sync2mul_pvld;
assign sync2mul_prdy = (mul_bypass_en ? mul2ocvt_prdy_f : mul_in_rdy) & intp2mul_pvld;

assign mul_in_vld = mul_bypass_en ? 1'b0 : (sync2mul_pvld & intp2mul_pvld);
assign mul_in_rdy = &mul_rdy;

assign mul_vld[0] = mul_in_vld & (&mul_rdy[3:1]);
assign mul_vld[1] = mul_in_vld & (&{mul_rdy[3:1],mul_rdy[0]});
assign mul_vld[2] = mul_in_vld & (&{mul_rdy[3],mul_rdy[1:0]});
assign mul_vld[3] = mul_in_vld & (&mul_rdy[2:0]);
NV_NVDLA_CDP_DP_MUL_unit u_mul_unit0 (
   .nvdla_core_clk          (nvdla_core_clk)              //|< i
  ,.nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)             //|< i
  ,.datin_pd                (sync2mul_pd[17:0])           //|< i
  ,.fp16_en                 (fp16_en)                     //|< i
  ,.intp2mul_pd_0           (intp2mul_pd_0[16:0])         //|< i
  ,.intp2mul_pd_1           (intp2mul_pd_4[16:0])         //|< i
  ,.mul_unit_rdy            (mul_unit_rdy[0])             //|< w
  ,.mul_vld                 (mul_vld[0])                  //|< w
  ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)     //|< i
  ,.reg2dp_input_data_type  (reg2dp_input_data_type[1:0]) //|< i
  ,.mul_rdy                 (mul_rdy[0])                  //|> w
  ,.mul_unit_pd             (mul_unit_pd_0[49:0])         //|> w
  ,.mul_unit_vld            (mul_unit_vld[0])             //|> w
  );

NV_NVDLA_CDP_DP_MUL_unit u_mul_unit1 (
   .nvdla_core_clk          (nvdla_core_clk)              //|< i
  ,.nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)             //|< i
  ,.datin_pd                (sync2mul_pd[35:18])          //|< i
  ,.fp16_en                 (fp16_en)                     //|< i
  ,.intp2mul_pd_0           (intp2mul_pd_1[16:0])         //|< i
  ,.intp2mul_pd_1           (intp2mul_pd_5[16:0])         //|< i
  ,.mul_unit_rdy            (mul_unit_rdy[1])             //|< w
  ,.mul_vld                 (mul_vld[1])                  //|< w
  ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)     //|< i
  ,.reg2dp_input_data_type  (reg2dp_input_data_type[1:0]) //|< i
  ,.mul_rdy                 (mul_rdy[1])                  //|> w
  ,.mul_unit_pd             (mul_unit_pd_1[49:0])         //|> w
  ,.mul_unit_vld            (mul_unit_vld[1])             //|> w
  );

NV_NVDLA_CDP_DP_MUL_unit u_mul_unit2 (
   .nvdla_core_clk          (nvdla_core_clk)              //|< i
  ,.nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)             //|< i
  ,.datin_pd                (sync2mul_pd[53:36])          //|< i
  ,.fp16_en                 (fp16_en)                     //|< i
  ,.intp2mul_pd_0           (intp2mul_pd_2[16:0])         //|< i
  ,.intp2mul_pd_1           (intp2mul_pd_6[16:0])         //|< i
  ,.mul_unit_rdy            (mul_unit_rdy[2])             //|< w
  ,.mul_vld                 (mul_vld[2])                  //|< w
  ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)     //|< i
  ,.reg2dp_input_data_type  (reg2dp_input_data_type[1:0]) //|< i
  ,.mul_rdy                 (mul_rdy[2])                  //|> w
  ,.mul_unit_pd             (mul_unit_pd_2[49:0])         //|> w
  ,.mul_unit_vld            (mul_unit_vld[2])             //|> w
  );

NV_NVDLA_CDP_DP_MUL_unit u_mul_unit3 (
   .nvdla_core_clk          (nvdla_core_clk)              //|< i
  ,.nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)      //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)             //|< i
  ,.datin_pd                (sync2mul_pd[71:54])          //|< i
  ,.fp16_en                 (fp16_en)                     //|< i
  ,.intp2mul_pd_0           (intp2mul_pd_3[16:0])         //|< i
  ,.intp2mul_pd_1           (intp2mul_pd_7[16:0])         //|< i
  ,.mul_unit_rdy            (mul_unit_rdy[3])             //|< w
  ,.mul_vld                 (mul_vld[3])                  //|< w
  ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)     //|< i
  ,.reg2dp_input_data_type  (reg2dp_input_data_type[1:0]) //|< i
  ,.mul_rdy                 (mul_rdy[3])                  //|> w
  ,.mul_unit_pd             (mul_unit_pd_3[49:0])         //|> w
  ,.mul_unit_vld            (mul_unit_vld[3])             //|> w
  );

assign mul_unit_rdy[0] = mul2ocvt_prdy_f & (&mul_unit_vld[3:1]);
assign mul_unit_rdy[1] = mul2ocvt_prdy_f & (&{mul_unit_vld[3:2],mul_unit_vld[0]});
assign mul_unit_rdy[2] = mul2ocvt_prdy_f & (&{mul_unit_vld[3],mul_unit_vld[1:0]});
assign mul_unit_rdy[3] = mul2ocvt_prdy_f & (&mul_unit_vld[2:0]);
///////////////////
//NaN propagation for mul_bypass condition
///////////////////
assign icvt_out_0 = sync2mul_pd[16:0];
assign icvt_out_1 = sync2mul_pd[34:18];
assign icvt_out_2 = sync2mul_pd[52:36];
assign icvt_out_3 = sync2mul_pd[70:54];
assign is_nan_in[0] = fp16_en ? (&icvt_out_0[15:10]) & (|icvt_out_0[9:0]) : 1'b0;
assign is_nan_in[1] = fp16_en ? (&icvt_out_1[15:10]) & (|icvt_out_1[9:0]) : 1'b0;
assign is_nan_in[2] = fp16_en ? (&icvt_out_2[15:10]) & (|icvt_out_2[9:0]) : 1'b0;
assign is_nan_in[3] = fp16_en ? (&icvt_out_3[15:10]) & (|icvt_out_3[9:0]) : 1'b0;

assign intp_out_int8  = {{{8{intp2mul_pd_7[16]}}, intp2mul_pd_7[16:0]},{{8{intp2mul_pd_3[16]}}, intp2mul_pd_3[16:0]},
                         {{8{intp2mul_pd_6[16]}}, intp2mul_pd_6[16:0]},{{8{intp2mul_pd_2[16]}}, intp2mul_pd_2[16:0]},
                         {{8{intp2mul_pd_5[16]}}, intp2mul_pd_5[16:0]},{{8{intp2mul_pd_1[16]}}, intp2mul_pd_1[16:0]},
                         {{8{intp2mul_pd_4[16]}}, intp2mul_pd_4[16:0]},{{8{intp2mul_pd_0[16]}}, intp2mul_pd_0[16:0]}};
assign intp_out_int16 = {{{33{intp2mul_pd_3[16]}}, intp2mul_pd_3[16:0]},{{33{intp2mul_pd_2[16]}}, intp2mul_pd_2[16:0]},
                         {{33{intp2mul_pd_1[16]}}, intp2mul_pd_1[16:0]},{{33{intp2mul_pd_0[16]}}, intp2mul_pd_0[16:0]}};

assign intp_out_fp16_0 = is_nan_in[0] ? {{33{icvt_out_0[16]}}, icvt_out_0[16:0]} : {{33{intp2mul_pd_0[16]}}, intp2mul_pd_0[16:0]};
assign intp_out_fp16_1 = is_nan_in[1] ? {{33{icvt_out_1[16]}}, icvt_out_1[16:0]} : {{33{intp2mul_pd_1[16]}}, intp2mul_pd_1[16:0]};
assign intp_out_fp16_2 = is_nan_in[2] ? {{33{icvt_out_2[16]}}, icvt_out_2[16:0]} : {{33{intp2mul_pd_2[16]}}, intp2mul_pd_2[16:0]};
assign intp_out_fp16_3 = is_nan_in[3] ? {{33{icvt_out_3[16]}}, icvt_out_3[16:0]} : {{33{intp2mul_pd_3[16]}}, intp2mul_pd_3[16:0]};
assign intp_out_fp16 = {intp_out_fp16_3,intp_out_fp16_2,intp_out_fp16_1,intp_out_fp16_0};

assign intp_out_ext  = int8_en ? intp_out_int8 : (int16_en ? intp_out_int16 : intp_out_fp16);
//output select
assign mul2ocvt_pd_f = mul_bypass_en ? intp_out_ext : {mul_unit_pd_3,mul_unit_pd_2,mul_unit_pd_1,mul_unit_pd_0};
assign mul2ocvt_pvld_f = mul_bypass_en ? (sync2mul_pvld & intp2mul_pvld) : (&mul_unit_vld);

///////////////////////////////////////////
//data pipe for timing improve
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     mul2ocvt_pvld_f
  or p1_pipe_rand_ready
  or mul2ocvt_pd_f
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = mul2ocvt_pvld_f;
  mul2ocvt_prdy_f = p1_pipe_rand_ready;
  p1_pipe_rand_data = mul2ocvt_pd_f;
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : mul2ocvt_pvld_f;
  mul2ocvt_prdy_f = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : mul2ocvt_pd_f;
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
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_mul_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_mul_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_mul_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDP_DP_mul_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_mul_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_mul_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_DP_mul_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or mul2ocvt_pvld_f
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && mul2ocvt_pvld_f === 1'b1;
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
//## pipe (1) skid buffer
always @(
  p1_pipe_rand_valid
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_rand_valid && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_rand_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_rand_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_rand_valid
  or p1_skid_valid
  or p1_pipe_rand_data
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? p1_pipe_rand_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_skid_pipe_valid)? p1_skid_pipe_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_skid_pipe_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or mul2ocvt_prdy
  or p1_pipe_data
  ) begin
  mul2ocvt_pvld = p1_pipe_valid;
  p1_pipe_ready = mul2ocvt_prdy;
  mul2ocvt_pd = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mul2ocvt_pvld^mul2ocvt_prdy^mul2ocvt_pvld_f^mul2ocvt_prdy_f)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (mul2ocvt_pvld_f && !mul2ocvt_prdy_f), (mul2ocvt_pvld_f), (mul2ocvt_prdy_f)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

///////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_mul


