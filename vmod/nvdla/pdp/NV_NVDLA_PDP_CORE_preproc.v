// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_CORE_preproc.v

module NV_NVDLA_PDP_CORE_preproc (
   nvdla_core_clk         //|< i
  ,nvdla_core_rstn        //|< i
  ,pre2cal1d_prdy         //|< i
  ,pwrbus_ram_pd          //|< i
  ,reg2dp_cube_in_channel //|< i
  ,reg2dp_cube_in_height  //|< i
  ,reg2dp_cube_in_width   //|< i
  ,reg2dp_flying_mode     //|< i
  ,reg2dp_input_data      //|< i
  ,reg2dp_op_en           //|< i
  ,sdp2pdp_pd             //|< i
  ,sdp2pdp_valid          //|< i
  ,pre2cal1d_pd           //|> o
  ,pre2cal1d_pvld         //|> o
  ,sdp2pdp_ready          //|> o
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input          pre2cal1d_prdy;
input   [31:0] pwrbus_ram_pd;
input   [12:4] reg2dp_cube_in_channel;
input   [12:0] reg2dp_cube_in_height;
input   [12:0] reg2dp_cube_in_width;
input          reg2dp_flying_mode;
input    [1:0] reg2dp_input_data;
input          reg2dp_op_en;
input  [255:0] sdp2pdp_pd;
input          sdp2pdp_valid;
output  [75:0] pre2cal1d_pd;
output         pre2cal1d_pvld;
output         sdp2pdp_ready;
wire           b_sync;
wire           cube_end;
wire           int8_en;
wire           last_c;
wire           layer_end;
wire           line_end;
wire           load_din;
wire           onfly_en;
wire           op_en_load;
wire    [11:0] pre2cal1d_info;
wire           pre2cal1d_pvld_f;
wire    [63:0] ro_rd_pd_0;
wire    [63:0] ro_rd_pd_1;
wire    [63:0] ro_rd_pd_2;
wire    [63:0] ro_rd_pd_3;
wire     [3:0] ro_rd_rdy;
wire     [3:0] ro_rd_vld;
wire    [63:0] ro_wr_pd_0;
wire    [63:0] ro_wr_pd_1;
wire    [63:0] ro_wr_pd_2;
wire    [63:0] ro_wr_pd_3;
wire     [3:0] ro_wr_rdy;
wire     [3:0] ro_wr_vld;
wire           sdp2pdp_c_end;
wire           sdp2pdp_cube_end;
wire           sdp2pdp_en;
wire           sdp2pdp_line_end;
wire           sdp2pdp_ready_use;
wire           sdp2pdp_surf_end;
wire           sdp2pdp_valid_use;
wire           split_end;
wire           surf_end;
wire     [8:0] surf_num;
reg      [1:0] fifo_sel_cnt;
reg     [12:0] line_cnt;
reg            op_en_d1;
reg    [256:0] p1_pipe_data;
reg    [256:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [256:0] p1_skid_data;
reg    [256:0] p1_skid_pipe_data;
reg            p1_skid_pipe_ready;
reg            p1_skid_pipe_valid;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
reg      [2:0] pos_c;
reg     [63:0] pre2cal1d_data;
reg            sdp2pdp_c_cnt;
reg            sdp2pdp_en_sync;
reg     [12:0] sdp2pdp_height_cnt;
reg    [255:0] sdp2pdp_pd_use;
reg            sdp2pdp_ready_f;
reg      [8:0] sdp2pdp_surf_cnt;
reg            sdp2pdp_valid_use_f;
reg     [12:0] sdp2pdp_width_cnt;
reg      [8:0] surf_cnt;
reg     [12:0] w_cnt;
reg            waiting_for_op_en;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    //==============================================================
//Data path pre process
//--------------------------------------------------------------
assign int8_en  = (reg2dp_input_data[1:0]== 2'h0 );
assign onfly_en = (reg2dp_flying_mode == 1'h0 );
////////////////////////////////////////////////////////////////
assign load_din = (sdp2pdp_valid & sdp2pdp_ready_f & sdp2pdp_en);
//////////////////////////////
//sdp to pdp layer end info
//////////////////////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp2pdp_c_cnt <= 1'b0;
  end else begin
    if(int8_en) begin
        if(load_din) begin
            if(sdp2pdp_c_cnt)
                sdp2pdp_c_cnt <= 1'b0;
            else
                sdp2pdp_c_cnt <= ~sdp2pdp_c_cnt;
        end
    end else 
        sdp2pdp_c_cnt <= 1'b0;
  end
end
assign sdp2pdp_c_end = int8_en ? (load_din & sdp2pdp_c_cnt) : load_din;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp2pdp_width_cnt <= {13{1'b0}};
  end else begin
    if(sdp2pdp_c_end) begin
        if(sdp2pdp_line_end)
            sdp2pdp_width_cnt <= 13'd0;
        else
            sdp2pdp_width_cnt <= sdp2pdp_width_cnt + 1'b1;
    end
  end
end
assign sdp2pdp_line_end = sdp2pdp_c_end & (sdp2pdp_width_cnt == reg2dp_cube_in_width[12:0]);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp2pdp_height_cnt <= {13{1'b0}};
  end else begin
    if(sdp2pdp_line_end) begin
        if(sdp2pdp_surf_end)
            sdp2pdp_height_cnt <= 13'd0;
        else
            sdp2pdp_height_cnt <= sdp2pdp_height_cnt + 1'b1;
    end
  end
end
assign sdp2pdp_surf_end = sdp2pdp_line_end & (sdp2pdp_height_cnt == reg2dp_cube_in_height[12:0]);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp2pdp_surf_cnt <= {9{1'b0}};
  end else begin
    if(sdp2pdp_surf_end) begin
        if(sdp2pdp_cube_end)
            sdp2pdp_surf_cnt <= 9'd0;
        else
            sdp2pdp_surf_cnt <= sdp2pdp_surf_cnt + 1'b1;
    end
  end
end
//assign sdp2pdp_cube_end = sdp2pdp_surf_end & (sdp2pdp_surf_cnt == reg2dp_cube_in_channel[12:4]);
assign sdp2pdp_cube_end = sdp2pdp_surf_end & (int8_en ? (sdp2pdp_surf_cnt == {1'b0,reg2dp_cube_in_channel[12:5]}) : (sdp2pdp_surf_cnt == reg2dp_cube_in_channel[12:4]));

//////////////////////////////////////////////////////////////////////
//waiting for op_en
//////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_en_d1 <= 1'b0;
  end else begin
  op_en_d1 <= reg2dp_op_en;
  end
end
assign op_en_load = reg2dp_op_en & (~op_en_d1);
assign layer_end = sdp2pdp_cube_end;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    waiting_for_op_en <= 1'b1;
  end else begin
    if(layer_end & onfly_en)
        waiting_for_op_en <= 1'b1;
    else if(op_en_load) begin
        if(~onfly_en)
            waiting_for_op_en <= 1'b1;
        else if(onfly_en)
            waiting_for_op_en <= 1'b0;
    end
  end
end

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

    property SDP_NewLayer_out_req_And_core_CurLayer_not_finish__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        waiting_for_op_en & sdp2pdp_valid;
    endproperty
    // Cover 0 : "waiting_for_op_en & sdp2pdp_valid"
    FUNCPOINT_SDP_NewLayer_out_req_And_core_CurLayer_not_finish__0_COV : cover property (SDP_NewLayer_out_req_And_core_CurLayer_not_finish__0_cov);

  `endif
`endif
//VCS coverage on

///////////////////////////
assign sdp2pdp_en = (onfly_en & (~waiting_for_op_en));
assign sdp2pdp_ready = sdp2pdp_ready_f & sdp2pdp_en;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     sdp2pdp_valid
  or p1_pipe_rand_ready
  or sdp2pdp_pd
  or sdp2pdp_en
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = sdp2pdp_valid;
  sdp2pdp_ready_f = p1_pipe_rand_ready;
  p1_pipe_rand_data = {sdp2pdp_pd[255:0],sdp2pdp_en};
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : sdp2pdp_valid;
  sdp2pdp_ready_f = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : {sdp2pdp_pd[255:0],sdp2pdp_en};
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
  if      ( $value$plusargs( "NV_NVDLA_PDP_CORE_preproc_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_PDP_CORE_preproc_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_PDP_CORE_preproc_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_PDP_CORE_preproc_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_PDP_CORE_preproc_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_CORE_preproc_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_CORE_preproc_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or sdp2pdp_valid
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && sdp2pdp_valid === 1'b1;
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
  or sdp2pdp_ready_use
  or p1_pipe_data
  ) begin
  sdp2pdp_valid_use_f = p1_pipe_valid;
  p1_pipe_ready = sdp2pdp_ready_use;
  {sdp2pdp_pd_use,sdp2pdp_en_sync} = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sdp2pdp_valid_use_f^sdp2pdp_ready_use^sdp2pdp_valid^sdp2pdp_ready_f)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (sdp2pdp_valid && !sdp2pdp_ready_f), (sdp2pdp_valid), (sdp2pdp_ready_f)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign sdp2pdp_valid_use = sdp2pdp_valid_use_f & sdp2pdp_en_sync;

////////////////////////////////////////////////////////////////
assign sdp2pdp_ready_use = int8_en ? (&ro_wr_rdy[1:0]) : (&ro_wr_rdy[3:0]);

assign ro_wr_vld[0] = int8_en ? (sdp2pdp_valid_use & ro_wr_rdy[1]) : (sdp2pdp_valid_use & (&{ro_wr_rdy[3:1]}));
assign ro_wr_vld[1] = int8_en ? (sdp2pdp_valid_use & ro_wr_rdy[0]) : (sdp2pdp_valid_use & (&{ro_wr_rdy[3:2],ro_wr_rdy[0]}));
assign ro_wr_vld[2] = int8_en ? 1'b0 : (sdp2pdp_valid_use & (&{ro_wr_rdy[3],  ro_wr_rdy[1:0]}));
assign ro_wr_vld[3] = int8_en ? 1'b0 : (sdp2pdp_valid_use & (&{ro_wr_rdy[2:0]}));

assign ro_wr_pd_0 = int8_en ? {sdp2pdp_pd_use[119:112],sdp2pdp_pd_use[103:96],sdp2pdp_pd_use[87:80],sdp2pdp_pd_use[71:64],sdp2pdp_pd_use[55:48],sdp2pdp_pd_use[39:32],sdp2pdp_pd_use[23:16],sdp2pdp_pd_use[7:0]} : sdp2pdp_pd_use[63:0];
assign ro_wr_pd_1 = int8_en ? {sdp2pdp_pd_use[247:240],sdp2pdp_pd_use[231:224],sdp2pdp_pd_use[215:208],sdp2pdp_pd_use[199:192],sdp2pdp_pd_use[183:176],sdp2pdp_pd_use[167:160],sdp2pdp_pd_use[151:144],sdp2pdp_pd_use[135:128]} : sdp2pdp_pd_use[127:64];
assign ro_wr_pd_2 = int8_en ? 64'd0 : sdp2pdp_pd_use[191:128];
assign ro_wr_pd_3 = int8_en ? 64'd0 : sdp2pdp_pd_use[255:192];

 NV_NVDLA_PDP_SDPIN_ro_fifo u_ro_fifo_0 (
    .nvdla_core_clk  (nvdla_core_clk)      //|< i
   ,.nvdla_core_rstn (nvdla_core_rstn)     //|< i
   ,.ro_wr_prdy      (ro_wr_rdy[0])        //|> w
   ,.ro_wr_pvld      (ro_wr_vld[0])        //|< w
   ,.ro_wr_pd        (ro_wr_pd_0[63:0])    //|< w
   ,.ro_rd_prdy      (ro_rd_rdy[0])        //|< w
   ,.ro_rd_pvld      (ro_rd_vld[0])        //|> w
   ,.ro_rd_pd        (ro_rd_pd_0[63:0])    //|> w
   ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0]) //|< i
   );
 assign ro_rd_rdy[0] = pre2cal1d_prdy & (fifo_sel_cnt == 0); 
 NV_NVDLA_PDP_SDPIN_ro_fifo u_ro_fifo_1 (
    .nvdla_core_clk  (nvdla_core_clk)      //|< i
   ,.nvdla_core_rstn (nvdla_core_rstn)     //|< i
   ,.ro_wr_prdy      (ro_wr_rdy[1])        //|> w
   ,.ro_wr_pvld      (ro_wr_vld[1])        //|< w
   ,.ro_wr_pd        (ro_wr_pd_1[63:0])    //|< w
   ,.ro_rd_prdy      (ro_rd_rdy[1])        //|< w
   ,.ro_rd_pvld      (ro_rd_vld[1])        //|> w
   ,.ro_rd_pd        (ro_rd_pd_1[63:0])    //|> w
   ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0]) //|< i
   );
 assign ro_rd_rdy[1] = pre2cal1d_prdy & (fifo_sel_cnt == 1); 
 NV_NVDLA_PDP_SDPIN_ro_fifo u_ro_fifo_2 (
    .nvdla_core_clk  (nvdla_core_clk)      //|< i
   ,.nvdla_core_rstn (nvdla_core_rstn)     //|< i
   ,.ro_wr_prdy      (ro_wr_rdy[2])        //|> w
   ,.ro_wr_pvld      (ro_wr_vld[2])        //|< w
   ,.ro_wr_pd        (ro_wr_pd_2[63:0])    //|< w
   ,.ro_rd_prdy      (ro_rd_rdy[2])        //|< w
   ,.ro_rd_pvld      (ro_rd_vld[2])        //|> w
   ,.ro_rd_pd        (ro_rd_pd_2[63:0])    //|> w
   ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0]) //|< i
   );
 assign ro_rd_rdy[2] = pre2cal1d_prdy & (fifo_sel_cnt == 2); 
 NV_NVDLA_PDP_SDPIN_ro_fifo u_ro_fifo_3 (
    .nvdla_core_clk  (nvdla_core_clk)      //|< i
   ,.nvdla_core_rstn (nvdla_core_rstn)     //|< i
   ,.ro_wr_prdy      (ro_wr_rdy[3])        //|> w
   ,.ro_wr_pvld      (ro_wr_vld[3])        //|< w
   ,.ro_wr_pd        (ro_wr_pd_3[63:0])    //|< w
   ,.ro_rd_prdy      (ro_rd_rdy[3])        //|< w
   ,.ro_rd_pvld      (ro_rd_vld[3])        //|> w
   ,.ro_rd_pd        (ro_rd_pd_3[63:0])    //|> w
   ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0]) //|< i
   );
 assign ro_rd_rdy[3] = pre2cal1d_prdy & (fifo_sel_cnt == 3); 
assign pre2cal1d_pvld_f = |ro_rd_vld[3:0];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fifo_sel_cnt <= {2{1'b0}};
  end else begin
    if(pre2cal1d_pvld_f) begin
        if(pre2cal1d_prdy) begin
            if((int8_en & (fifo_sel_cnt == 2'd1)) | ((!int8_en) & (fifo_sel_cnt == 2'd3)))
                fifo_sel_cnt <= 2'd0;
            else
                fifo_sel_cnt <= fifo_sel_cnt + 1'b1;
        end
    end
  end
end
always @(
  fifo_sel_cnt
  or ro_rd_pd_0
  or ro_rd_pd_1
  or ro_rd_pd_2
  or ro_rd_pd_3
  ) begin
    case(fifo_sel_cnt)
    2'd0: pre2cal1d_data[63:0] = ro_rd_pd_0[63:0];
    2'd1: pre2cal1d_data[63:0] = ro_rd_pd_1[63:0];
    2'd2: pre2cal1d_data[63:0] = ro_rd_pd_2[63:0];
    2'd3: pre2cal1d_data[63:0] = ro_rd_pd_3[63:0];
    default: pre2cal1d_data[63:0] = 64'd0;
    endcase
end

assign pre2cal1d_pvld = pre2cal1d_pvld_f;
//==============================================================
//Data info path pre process
//--------------------------------------------------------------
//pos_c, 8B data position within 32B
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pos_c[2:0] <= {3{1'b0}};
  end else begin
    if(pre2cal1d_pvld_f & pre2cal1d_prdy) begin
        if(last_c)
            pos_c[2:0] <= 3'd0;
        else
            pos_c[2:0] <= pos_c[2:0] + 1'b1;
    end
  end
end
assign last_c = pre2cal1d_pvld_f & pre2cal1d_prdy & (pos_c == 2'd3);

//width direction
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    w_cnt[12:0] <= {13{1'b0}};
  end else begin
    if(last_c) begin
        if(line_end)
            w_cnt[12:0] <= 13'd0;
        else
            w_cnt[12:0] <= w_cnt[12:0] + 1'b1;
    end
  end
end
assign line_end = last_c & (w_cnt[12:0] == reg2dp_cube_in_width[12:0]);

//height direction
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    line_cnt[12:0] <= {13{1'b0}};
  end else begin
    if(line_end) begin
        if(surf_end)
            line_cnt[12:0] <= 13'd0;
        else
            line_cnt[12:0] <= line_cnt[12:0] + 1'b1;
    end
  end
end
assign surf_end = line_end & (line_cnt[12:0] == reg2dp_cube_in_height[12:0]);

//surface/Channel direction
assign surf_num = int8_en ? {1'b0,reg2dp_cube_in_channel[12:5]} : reg2dp_cube_in_channel[12:4];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    surf_cnt[8:0] <= {9{1'b0}};
  end else begin
    if(surf_end) begin
        if(split_end)
            surf_cnt[8:0] <= 9'd0;
        else
            surf_cnt[8:0] <= surf_cnt[8:0] + 1'b1;
    end
  end
end
assign split_end = surf_end & (surf_cnt[8:0] == surf_num);

assign cube_end = split_end ;
assign b_sync = line_end;

assign pre2cal1d_info = {cube_end,split_end,surf_end,line_end,b_sync,pos_c,4'd0};
assign pre2cal1d_pd = {pre2cal1d_info,pre2cal1d_data};
////////////////////////////
//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property SDP_PDP__int8_enable__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        int8_en & (sdp2pdp_valid_use & sdp2pdp_ready_use);
    endproperty
    // Cover 1 : "int8_en & (sdp2pdp_valid_use & sdp2pdp_ready_use)"
    FUNCPOINT_SDP_PDP__int8_enable__1_COV : cover property (SDP_PDP__int8_enable__1_cov);

  `endif
`endif
//VCS coverage on

////////////////////////////
endmodule // NV_NVDLA_PDP_CORE_preproc

//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_PDP_SDPIN_ro_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus ro_wr -rd_pipebus ro_rd -rd_reg -rand_none -ram_bypass -d 4 -w 64 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_PDP_SDPIN_ro_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , ro_wr_prdy
    , ro_wr_pvld
    , ro_wr_pd
    , ro_rd_prdy
    , ro_rd_pvld
    , ro_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        ro_wr_prdy;
input         ro_wr_pvld;
input  [63:0] ro_wr_pd;
input         ro_rd_prdy;
output        ro_rd_pvld;
output [63:0] ro_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        ro_wr_busy_int;		        	// copy for internal use
assign     ro_wr_prdy = !ro_wr_busy_int;
assign       wr_reserving = ro_wr_pvld && !ro_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] ro_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? ro_wr_count : (ro_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (ro_wr_count + 1'd1) : ro_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       ro_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check ro_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_busy_int <=  1'b0;
        ro_wr_count <=  3'd0;
    end else begin
	ro_wr_busy_int <=  ro_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    ro_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            ro_wr_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as ro_wr_pvld

//
// RAM
//

reg  [1:0] ro_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    ro_wr_adr <=  ro_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] ro_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (ro_wr_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [63:0] ro_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_PDP_SDPIN_ro_fifo_flopram_rwsa_4x64 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( ro_wr_pd )
    , .we        ( ram_we )
    , .wa        ( ro_wr_adr )
    , .ra        ( (ro_wr_count == 0) ? 3'd4 : {1'b0,ro_rd_adr} )
    , .dout        ( ro_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = ro_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    ro_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            ro_rd_adr <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       ro_rd_pvld_p; 		// data out of fifo is valid

reg        ro_rd_pvld_int;	// internal copy of ro_rd_pvld
assign     ro_rd_pvld = ro_rd_pvld_int;
assign     rd_popping = ro_rd_pvld_p && !(ro_rd_pvld_int && !ro_rd_prdy);

reg  [2:0] ro_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_p_next_rd_popping = rd_pushing ? ro_rd_count_p : 
                                                                (ro_rd_count_p - 1'd1);
wire [2:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (ro_rd_count_p + 1'd1) : 
                                                                    ro_rd_count_p;
// spyglass enable_block W164a W484
wire [2:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     ro_rd_pvld_p = ro_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_count_p <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    ro_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            ro_rd_count_p <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [63:0]  ro_rd_pd;         // output data register
wire        rd_req_next = (ro_rd_pvld_p || (ro_rd_pvld_int && !ro_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_pvld_int <=  1'b0;
    end else begin
        ro_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        ro_rd_pd <=  ro_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        ro_rd_pd <=  {64{`x_or_0}};
    end
    //synopsys translate_on

end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (ro_wr_pvld && !ro_wr_busy_int) || (ro_wr_busy_int != ro_wr_busy_next)) || (rd_pushing || rd_popping || (ro_rd_pvld_int && ro_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_PDP_SDPIN_ro_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_PDP_SDPIN_ro_fifo_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_PDP_SDPIN_ro_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_PDP_SDPIN_ro_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif

//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, ro_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_PDP_SDPIN_ro_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_PDP_SDPIN_ro_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_PDP_SDPIN_ro_fifo_flopram_rwsa_4x64 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [63:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [63:0] dout;

NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));


`ifdef EMU


wire [63:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [63:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_PDP_SDPIN_ro_fifo_flopram_rwsa_4x64 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [63:0] ram_ff0;
reg [63:0] ram_ff1;
reg [63:0] ram_ff2;
reg [63:0] ram_ff3;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [63:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {64{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_PDP_SDPIN_ro_fifo_flopram_rwsa_4x64

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_PDP_SDPIN_ro_fifo_flopram_rwsa_4x64 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [63:0] Di0;
input  [1:0] Ra0;
output [63:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 64'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [63:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [63:0] Q0 = mem[0];
wire [63:0] Q1 = mem[1];
wire [63:0] Q2 = mem[2];
wire [63:0] Q3 = mem[3];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_PDP_SDPIN_ro_fifo_flopram_rwsa_4x64] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_PDP_SDPIN_ro_fifo_flopram_rwsa_4x64] }
endmodule // vmw_NV_NVDLA_PDP_SDPIN_ro_fifo_flopram_rwsa_4x64

//vmw: Memory vmw_NV_NVDLA_PDP_SDPIN_ro_fifo_flopram_rwsa_4x64
//vmw: Address-size 2
//vmw: Data-size 64
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[63:0] data0[63:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[63:0] data1[63:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_PDP_SDPIN_ro_fifo_flopram_rwsa_4x64
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU


