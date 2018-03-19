// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_lut_line.v

module NV_NVDLA_SDP_HLS_lut_line (
   cfg_lut_sel     //|< i
  ,cfg_lut_start   //|< i
  ,idx_data_in     //|< i
  ,idx_in_pvld     //|< i
  ,idx_out_prdy    //|< i
  ,nvdla_core_clk  //|< i
  ,nvdla_core_rstn //|< i
  ,idx_in_prdy     //|> o
  ,idx_out_pvld    //|> o
  ,lut_frac_out    //|> o
  ,lut_index_out   //|> o
  ,lut_oflow_out   //|> o
  ,lut_uflow_out   //|> o
  );

parameter   LUT_DEPTH = 256;

input   [7:0] cfg_lut_sel;
input  [31:0] cfg_lut_start;
input  [31:0] idx_data_in;
input         idx_in_pvld;
input         idx_out_prdy;
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        idx_in_prdy;
output        idx_out_pvld;
output [34:0] lut_frac_out;
output  [8:0] lut_index_out;
output        lut_oflow_out;
output        lut_uflow_out;

reg     [8:0] lut_index_final;
wire    [7:0] cfg_lut_sel_reg;
wire   [31:0] cfg_lut_start_reg;
wire   [31:0] idx_data_reg;
wire   [34:0] lut_frac_final;
wire   [34:0] lut_frac_shift;
wire    [8:0] lut_index_shift;
wire   [31:0] lut_index_sub;
wire   [31:0] lut_index_sub_reg;
wire   [31:0] lut_index_sub_tmp;
wire          lut_oflow;
wire          lut_uflow;
wire          lut_uflow_in;
wire          mon_index_sub_c;
wire          mux_prdy;
wire          mux_pvld;
wire          sub_prdy;
wire          sub_pvld;


// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
NV_NVDLA_SDP_HLS_LUT_LINE_pipe_p1 pipe_p1 (
   .nvdla_core_clk    (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)         //|< i
  ,.cfg_lut_sel       (cfg_lut_sel[7:0])        //|< i
  ,.cfg_lut_start     (cfg_lut_start[31:0])     //|< i
  ,.idx_data_in       (idx_data_in[31:0])       //|< i
  ,.idx_in_pvld       (idx_in_pvld)             //|< i
  ,.mux_prdy          (mux_prdy)                //|< w
  ,.cfg_lut_sel_reg   (cfg_lut_sel_reg[7:0])    //|> w
  ,.cfg_lut_start_reg (cfg_lut_start_reg[31:0]) //|> w
  ,.idx_data_reg      (idx_data_reg[31:0])      //|> w
  ,.idx_in_prdy       (idx_in_prdy)             //|> o
  ,.mux_pvld          (mux_pvld)                //|> w
  );

assign  lut_uflow_in = ($signed(idx_data_reg[31:0]) <= $signed(cfg_lut_start_reg[31:0])); 

assign  {mon_index_sub_c,lut_index_sub_tmp[31:0]} = $signed(idx_data_reg[31:0])- $signed(cfg_lut_start_reg[31:0]);

//unsigned int
assign  lut_index_sub[31:0] = lut_uflow_in ? 0 : lut_index_sub_tmp[31:0];

NV_NVDLA_SDP_HLS_LUT_LINE_pipe_p2 pipe_p2 (
   .nvdla_core_clk    (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)         //|< i
  ,.lut_index_sub     (lut_index_sub[31:0])     //|< w
  ,.lut_uflow_in      (lut_uflow_in)            //|< w
  ,.mux_pvld          (mux_pvld)                //|< w
  ,.sub_prdy          (sub_prdy)                //|< w
  ,.lut_index_sub_reg (lut_index_sub_reg[31:0]) //|> w
  ,.lut_uflow         (lut_uflow)               //|> w
  ,.mux_prdy          (mux_prdy)                //|> w
  ,.sub_pvld          (sub_pvld)                //|> w
  );

//saturation and truncate, but no rounding
NV_NVDLA_HLS_shiftrightusz #(.IN_WIDTH(32 ),.OUT_WIDTH(9 ),.FRAC_WIDTH(35 ),.SHIFT_WIDTH(8 )) lut_index_shiftright_usz (
   .data_in           (lut_index_sub_reg[31:0]) //|< w
  ,.shift_num         (cfg_lut_sel_reg[7:0])    //|< w
  ,.data_out          (lut_index_shift[8:0])    //|> w
  ,.frac_out          (lut_frac_shift[34:0])    //|> w
  );

assign  lut_oflow = (lut_index_shift[8:0] >= LUT_DEPTH -1); 

//index integar
always @(
  lut_oflow
  or lut_index_shift
  ) begin
   if (lut_oflow) 
       lut_index_final[8:0] = LUT_DEPTH - 1;
   else 
       lut_index_final[8:0] = lut_index_shift[8:0];
end

assign  lut_frac_final[34:0] = lut_frac_shift[34:0]; 

NV_NVDLA_SDP_HLS_LUT_LINE_pipe_p3 pipe_p3 (
   .nvdla_core_clk    (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)         //|< i
  ,.idx_out_prdy      (idx_out_prdy)            //|< i
  ,.lut_frac_final    (lut_frac_final[34:0])    //|< w
  ,.lut_index_final   (lut_index_final[8:0])    //|< r
  ,.lut_oflow         (lut_oflow)               //|< w
  ,.lut_uflow         (lut_uflow)               //|< w
  ,.sub_pvld          (sub_pvld)                //|< w
  ,.idx_out_pvld      (idx_out_pvld)            //|> o
  ,.lut_frac_out      (lut_frac_out[34:0])      //|> o
  ,.lut_index_out     (lut_index_out[8:0])      //|> o
  ,.lut_oflow_out     (lut_oflow_out)           //|> o
  ,.lut_uflow_out     (lut_uflow_out)           //|> o
  ,.sub_prdy          (sub_prdy)                //|> w
  );

endmodule // NV_NVDLA_SDP_HLS_lut_line



// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is {cfg_lut_sel_reg[7:0],cfg_lut_start_reg[31:0],idx_data_reg[31:0]} (mux_pvld,mux_prdy) <= {cfg_lut_sel[7:0],cfg_lut_start[31:0],idx_data_in[31:0]} (idx_in_pvld,idx_in_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_LUT_LINE_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cfg_lut_sel
  ,cfg_lut_start
  ,idx_data_in
  ,idx_in_pvld
  ,mux_prdy
  ,cfg_lut_sel_reg
  ,cfg_lut_start_reg
  ,idx_data_reg
  ,idx_in_prdy
  ,mux_pvld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input   [7:0] cfg_lut_sel;
input  [31:0] cfg_lut_start;
input  [31:0] idx_data_in;
input         idx_in_pvld;
input         mux_prdy;
output  [7:0] cfg_lut_sel_reg;
output [31:0] cfg_lut_start_reg;
output [31:0] idx_data_reg;
output        idx_in_prdy;
output        mux_pvld;
reg     [7:0] cfg_lut_sel_reg;
reg    [31:0] cfg_lut_start_reg;
reg    [31:0] idx_data_reg;
reg           idx_in_prdy;
reg           mux_pvld;
reg    [71:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [71:0] p1_skid_data;
reg    [71:0] p1_skid_pipe_data;
reg           p1_skid_pipe_ready;
reg           p1_skid_pipe_valid;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
//## pipe (1) skid buffer
always @(
  idx_in_pvld
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = idx_in_pvld && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    idx_in_prdy <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  idx_in_prdy <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? {cfg_lut_sel[7:0],cfg_lut_start[31:0],idx_data_in[31:0]} : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or idx_in_pvld
  or p1_skid_valid
  or cfg_lut_sel
  or cfg_lut_start
  or idx_data_in
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? idx_in_pvld : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? {cfg_lut_sel[7:0],cfg_lut_start[31:0],idx_data_in[31:0]} : p1_skid_data;
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
  or mux_prdy
  or p1_pipe_data
  ) begin
  mux_pvld = p1_pipe_valid;
  p1_pipe_ready = mux_prdy;
  {cfg_lut_sel_reg[7:0],cfg_lut_start_reg[31:0],idx_data_reg[31:0]} = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mux_pvld^mux_prdy^idx_in_pvld^idx_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (idx_in_pvld && !idx_in_prdy), (idx_in_pvld), (idx_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_LUT_LINE_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is {lut_uflow,lut_index_sub_reg[31:0]} (sub_pvld,sub_prdy) <= {lut_uflow_in,lut_index_sub[31:0]} (mux_pvld,mux_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_LUT_LINE_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,lut_index_sub
  ,lut_uflow_in
  ,mux_pvld
  ,sub_prdy
  ,lut_index_sub_reg
  ,lut_uflow
  ,mux_prdy
  ,sub_pvld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] lut_index_sub;
input         lut_uflow_in;
input         mux_pvld;
input         sub_prdy;
output [31:0] lut_index_sub_reg;
output        lut_uflow;
output        mux_prdy;
output        sub_pvld;
reg    [31:0] lut_index_sub_reg;
reg           lut_uflow;
reg           mux_prdy;
reg    [32:0] p2_pipe_data;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [32:0] p2_skid_data;
reg    [32:0] p2_skid_pipe_data;
reg           p2_skid_pipe_ready;
reg           p2_skid_pipe_valid;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
reg           sub_pvld;
//## pipe (2) skid buffer
always @(
  mux_pvld
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = mux_pvld && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    mux_prdy <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  mux_prdy <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? {lut_uflow_in,lut_index_sub[31:0]} : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or mux_pvld
  or p2_skid_valid
  or lut_uflow_in
  or lut_index_sub
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? mux_pvld : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? {lut_uflow_in,lut_index_sub[31:0]} : p2_skid_data;
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
  or sub_prdy
  or p2_pipe_data
  ) begin
  sub_pvld = p2_pipe_valid;
  p2_pipe_ready = sub_prdy;
  {lut_uflow,lut_index_sub_reg[31:0]} = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sub_pvld^sub_prdy^mux_pvld^mux_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (mux_pvld && !mux_prdy), (mux_pvld), (mux_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_LUT_LINE_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is {lut_uflow_out,lut_oflow_out,lut_index_out[8:0],lut_frac_out[34:0]} (idx_out_pvld,idx_out_prdy) <= {lut_uflow,lut_oflow,lut_index_final[8:0],lut_frac_final[34:0]} (sub_pvld,sub_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_LUT_LINE_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,idx_out_prdy
  ,lut_frac_final
  ,lut_index_final
  ,lut_oflow
  ,lut_uflow
  ,sub_pvld
  ,idx_out_pvld
  ,lut_frac_out
  ,lut_index_out
  ,lut_oflow_out
  ,lut_uflow_out
  ,sub_prdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         idx_out_prdy;
input  [34:0] lut_frac_final;
input   [8:0] lut_index_final;
input         lut_oflow;
input         lut_uflow;
input         sub_pvld;
output        idx_out_pvld;
output [34:0] lut_frac_out;
output  [8:0] lut_index_out;
output        lut_oflow_out;
output        lut_uflow_out;
output        sub_prdy;
reg           idx_out_pvld;
reg    [34:0] lut_frac_out;
reg     [8:0] lut_index_out;
reg           lut_oflow_out;
reg           lut_uflow_out;
reg    [45:0] p3_pipe_data;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg           p3_pipe_valid;
reg           p3_skid_catch;
reg    [45:0] p3_skid_data;
reg    [45:0] p3_skid_pipe_data;
reg           p3_skid_pipe_ready;
reg           p3_skid_pipe_valid;
reg           p3_skid_ready;
reg           p3_skid_ready_flop;
reg           p3_skid_valid;
reg           sub_prdy;
//## pipe (3) skid buffer
always @(
  sub_pvld
  or p3_skid_ready_flop
  or p3_skid_pipe_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = sub_pvld && p3_skid_ready_flop && !p3_skid_pipe_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_skid_pipe_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    sub_prdy <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_skid_pipe_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  sub_prdy <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? {lut_uflow,lut_oflow,lut_index_final[8:0],lut_frac_final[34:0]} : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or sub_pvld
  or p3_skid_valid
  or lut_uflow
  or lut_oflow
  or lut_index_final
  or lut_frac_final
  or p3_skid_data
  ) begin
  p3_skid_pipe_valid = (p3_skid_ready_flop)? sub_pvld : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_skid_pipe_data = (p3_skid_ready_flop)? {lut_uflow,lut_oflow,lut_index_final[8:0],lut_frac_final[34:0]} : p3_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (3) valid-ready-bubble-collapse
always @(
  p3_pipe_ready
  or p3_pipe_valid
  ) begin
  p3_pipe_ready_bc = p3_pipe_ready || !p3_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && p3_skid_pipe_valid)? p3_skid_pipe_data : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  p3_skid_pipe_ready = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or idx_out_prdy
  or p3_pipe_data
  ) begin
  idx_out_pvld = p3_pipe_valid;
  p3_pipe_ready = idx_out_prdy;
  {lut_uflow_out,lut_oflow_out,lut_index_out[8:0],lut_frac_out[34:0]} = p3_pipe_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (idx_out_pvld^idx_out_prdy^sub_pvld^sub_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (sub_pvld && !sub_prdy), (sub_pvld), (sub_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_LUT_LINE_pipe_p3



