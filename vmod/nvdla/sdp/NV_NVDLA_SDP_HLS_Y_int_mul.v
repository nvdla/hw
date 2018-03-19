// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_Y_int_mul.v

module NV_NVDLA_SDP_HLS_Y_int_mul (
   cfg_mul_bypass   //|< i
  ,cfg_mul_op       //|< i
  ,cfg_mul_prelu    //|< i
  ,cfg_mul_src      //|< i
  ,cfg_mul_truncate //|< i
  ,chn_in_pvld      //|< i
  ,chn_mul_in       //|< i
  ,chn_mul_op       //|< i
  ,chn_mul_op_pvld  //|< i
  ,mul_out_prdy     //|< i
  ,nvdla_core_clk   //|< i
  ,nvdla_core_rstn  //|< i
  ,chn_in_prdy      //|> o
  ,chn_mul_op_prdy  //|> o
  ,mul_data_out     //|> o
  ,mul_out_pvld     //|> o
  );

input         cfg_mul_bypass;
input  [31:0] cfg_mul_op;
input         cfg_mul_prelu;
input         cfg_mul_src;
input   [9:0] cfg_mul_truncate;
input         chn_in_pvld;
input  [31:0] chn_mul_in;
input  [31:0] chn_mul_op;
input         chn_mul_op_pvld;
input         mul_out_prdy;
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        chn_in_prdy;
output        chn_mul_op_prdy;
output [31:0] mul_data_out;
output        mul_out_pvld;

reg    [31:0] mul_dout;
wire          chn_in_srdy;
wire   [31:0] mul_data_final;
wire   [31:0] mul_data_in;
wire   [31:0] mul_data_reg;
wire   [31:0] mul_data_sync;
wire          mul_final_prdy;
wire          mul_final_pvld;
wire   [31:0] mul_op_in;
wire   [31:0] mul_op_sync;
wire   [63:0] mul_prelu_dout;
wire   [63:0] mul_prelu_out;
wire          mul_prelu_prdy;
wire          mul_prelu_pvld;
wire          mul_sync_prdy;
wire          mul_sync_pvld;
wire   [31:0] mul_truncate_out;

    
NV_NVDLA_SDP_HLS_sync2data #(.DATA1_WIDTH(32 ),.DATA2_WIDTH(32 )) y_mul_sync2data (
   .chn1_en         (!cfg_mul_bypass & cfg_mul_src) //|< ?
  ,.chn2_en         (!cfg_mul_bypass)               //|< i
  ,.chn1_in_pvld    (chn_mul_op_pvld)               //|< i
  ,.chn1_in_prdy    (chn_mul_op_prdy)               //|> o
  ,.chn2_in_pvld    (chn_in_pvld)                   //|< i
  ,.chn2_in_prdy    (chn_in_srdy)                   //|> w
  ,.chn_out_pvld    (mul_sync_pvld)                 //|> w
  ,.chn_out_prdy    (mul_sync_prdy)                 //|< w
  ,.data1_in        (chn_mul_op[31:0])              //|< i
  ,.data2_in        (chn_mul_in[31:0])              //|< i
  ,.data1_out       (mul_op_sync[31:0])             //|> w
  ,.data2_out       (mul_data_sync[31:0])           //|> w
  );

assign  mul_data_in[31:0]   =  mul_data_sync[31:0];
assign  mul_op_in[31:0] = (cfg_mul_src == 0 ) ? cfg_mul_op[31:0] : mul_op_sync[31:0];

NV_NVDLA_SDP_HLS_prelu #(.IN_WIDTH(32 ),.OUT_WIDTH(32 + 32 ),.OP_WIDTH(32 )) y_mul_prelu (
   .cfg_prelu_en    (cfg_mul_prelu)                 //|< i
  ,.data_in         (mul_data_in[31:0])             //|< w
  ,.op_in           (mul_op_in[31:0])               //|< w
  ,.data_out        (mul_prelu_dout[63:0])          //|> w
  );

NV_NVDLA_SDP_HLS_Y_INT_MUL_pipe_p1 pipe_p1 (
   .nvdla_core_clk  (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)               //|< i
  ,.mul_data_in     (mul_data_in[31:0])             //|< w
  ,.mul_prelu_dout  (mul_prelu_dout[63:0])          //|< w
  ,.mul_prelu_prdy  (mul_prelu_prdy)                //|< w
  ,.mul_sync_pvld   (mul_sync_pvld)                 //|< w
  ,.mul_data_reg    (mul_data_reg[31:0])            //|> w
  ,.mul_prelu_out   (mul_prelu_out[63:0])           //|> w
  ,.mul_prelu_pvld  (mul_prelu_pvld)                //|> w
  ,.mul_sync_prdy   (mul_sync_prdy)                 //|> w
  );

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(32 + 32 ),.OUT_WIDTH(32 ),.SHIFT_WIDTH(10 )) y_mul_shiftright_su (
   .data_in         (mul_prelu_out[63:0])           //|< w
  ,.shift_num       (cfg_mul_truncate[9:0])         //|< i
  ,.data_out        (mul_truncate_out[31:0])        //|> w
  );
//signed 
//unsigned 

assign   mul_data_reg[31:0] = mul_prelu_out[31:0];

always @(
  cfg_mul_prelu
  or mul_data_reg
  or mul_truncate_out
  ) begin
   if (cfg_mul_prelu & !mul_data_reg[32 -1]) 
      mul_dout[31:0] = mul_data_reg;
   else 
      mul_dout[31:0] = mul_truncate_out[31:0]; 
end

NV_NVDLA_SDP_HLS_Y_INT_MUL_pipe_p2 pipe_p2 (
   .nvdla_core_clk  (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)               //|< i
  ,.mul_dout        (mul_dout[31:0])                //|< r
  ,.mul_final_prdy  (mul_final_prdy)                //|< w
  ,.mul_prelu_pvld  (mul_prelu_pvld)                //|< w
  ,.mul_data_final  (mul_data_final[31:0])          //|> w
  ,.mul_final_pvld  (mul_final_pvld)                //|> w
  ,.mul_prelu_prdy  (mul_prelu_prdy)                //|> w
  );

assign  chn_in_prdy    = cfg_mul_bypass ? mul_out_prdy : chn_in_srdy;
assign  mul_final_prdy = cfg_mul_bypass ? 1'b1 : mul_out_prdy;
assign  mul_out_pvld   = cfg_mul_bypass ? chn_in_pvld : mul_final_pvld;
assign  mul_data_out[31:0] = cfg_mul_bypass ? chn_mul_in : mul_data_final[31:0];

endmodule // NV_NVDLA_SDP_HLS_Y_int_mul



// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is {mul_data_reg[31:0],mul_prelu_out[63:0]} (mul_prelu_pvld,mul_prelu_prdy) <= {mul_data_in[31:0],mul_prelu_dout[63:0]} (mul_sync_pvld,mul_sync_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_MUL_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,mul_data_in
  ,mul_prelu_dout
  ,mul_prelu_prdy
  ,mul_sync_pvld
  ,mul_data_reg
  ,mul_prelu_out
  ,mul_prelu_pvld
  ,mul_sync_prdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] mul_data_in;
input  [63:0] mul_prelu_dout;
input         mul_prelu_prdy;
input         mul_sync_pvld;
output [31:0] mul_data_reg;
output [63:0] mul_prelu_out;
output        mul_prelu_pvld;
output        mul_sync_prdy;
reg    [31:0] mul_data_reg;
reg    [63:0] mul_prelu_out;
reg           mul_prelu_pvld;
reg           mul_sync_prdy;
reg    [95:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [95:0] p1_skid_data;
reg    [95:0] p1_skid_pipe_data;
reg           p1_skid_pipe_ready;
reg           p1_skid_pipe_valid;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
//## pipe (1) skid buffer
always @(
  mul_sync_pvld
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = mul_sync_pvld && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    mul_sync_prdy <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  mul_sync_prdy <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? {mul_data_in[31:0],mul_prelu_dout[63:0]} : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or mul_sync_pvld
  or p1_skid_valid
  or mul_data_in
  or mul_prelu_dout
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? mul_sync_pvld : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? {mul_data_in[31:0],mul_prelu_dout[63:0]} : p1_skid_data;
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
  or mul_prelu_prdy
  or p1_pipe_data
  ) begin
  mul_prelu_pvld = p1_pipe_valid;
  p1_pipe_ready = mul_prelu_prdy;
  {mul_data_reg[31:0],mul_prelu_out[63:0]} = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mul_prelu_pvld^mul_prelu_prdy^mul_sync_pvld^mul_sync_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (mul_sync_pvld && !mul_sync_prdy), (mul_sync_pvld), (mul_sync_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_MUL_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is mul_data_final[31:0] (mul_final_pvld,mul_final_prdy) <= mul_dout[31:0] (mul_prelu_pvld,mul_prelu_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_MUL_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,mul_dout
  ,mul_final_prdy
  ,mul_prelu_pvld
  ,mul_data_final
  ,mul_final_pvld
  ,mul_prelu_prdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] mul_dout;
input         mul_final_prdy;
input         mul_prelu_pvld;
output [31:0] mul_data_final;
output        mul_final_pvld;
output        mul_prelu_prdy;
reg    [31:0] mul_data_final;
reg           mul_final_pvld;
reg           mul_prelu_prdy;
reg    [31:0] p2_pipe_data;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [31:0] p2_skid_data;
reg    [31:0] p2_skid_pipe_data;
reg           p2_skid_pipe_ready;
reg           p2_skid_pipe_valid;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
//## pipe (2) skid buffer
always @(
  mul_prelu_pvld
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = mul_prelu_pvld && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    mul_prelu_prdy <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  mul_prelu_prdy <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? mul_dout[31:0] : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or mul_prelu_pvld
  or p2_skid_valid
  or mul_dout
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? mul_prelu_pvld : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? mul_dout[31:0] : p2_skid_data;
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
  or mul_final_prdy
  or p2_pipe_data
  ) begin
  mul_final_pvld = p2_pipe_valid;
  p2_pipe_ready = mul_final_prdy;
  mul_data_final[31:0] = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mul_final_pvld^mul_final_prdy^mul_prelu_pvld^mul_prelu_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (mul_prelu_pvld && !mul_prelu_prdy), (mul_prelu_pvld), (mul_prelu_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_MUL_pipe_p2



