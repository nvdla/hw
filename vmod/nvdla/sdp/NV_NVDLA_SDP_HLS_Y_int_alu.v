// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_Y_int_alu.v

module NV_NVDLA_SDP_HLS_Y_int_alu (
   alu_data_in     //|< i
  ,alu_in_pvld     //|< i
  ,alu_out_prdy    //|< i
  ,cfg_alu_algo    //|< i
  ,cfg_alu_bypass  //|< i
  ,cfg_alu_op      //|< i
  ,cfg_alu_src     //|< i
  ,chn_alu_op      //|< i
  ,chn_alu_op_pvld //|< i
  ,nvdla_core_clk  //|< i
  ,nvdla_core_rstn //|< i
  ,alu_data_out    //|> o
  ,alu_in_prdy     //|> o
  ,alu_out_pvld    //|> o
  ,chn_alu_op_prdy //|> o
  );

input  [31:0] alu_data_in;
input         alu_in_pvld;
input         alu_out_prdy;
input   [1:0] cfg_alu_algo;
input         cfg_alu_bypass;
input  [31:0] cfg_alu_op;
input         cfg_alu_src;
input  [31:0] chn_alu_op;
input         chn_alu_op_pvld;
input         nvdla_core_clk;
input         nvdla_core_rstn;
output [31:0] alu_data_out;
output        alu_in_prdy;
output        alu_out_pvld;
output        chn_alu_op_prdy;


wire   [32:0] alu_sum;
reg    [32:0] alu_dout;
reg           mon_sum_c;
wire   [32:0] alu_data_ext;
wire   [31:0] alu_data_final;
wire   [31:0] alu_data_reg;
wire   [31:0] alu_data_sync;
wire          alu_final_prdy;
wire          alu_final_pvld;
wire          alu_in_srdy;
wire          alu_mux_prdy;
wire          alu_mux_pvld;
wire   [32:0] alu_op_ext;
wire   [31:0] alu_op_mux;
wire   [31:0] alu_op_reg;
wire   [31:0] alu_op_sync;
wire   [31:0] alu_sat;
wire          alu_sync_prdy;
wire          alu_sync_pvld;

    
NV_NVDLA_SDP_HLS_sync2data #(.DATA1_WIDTH(32 ),.DATA2_WIDTH(32 )) y_alu_sync2data (
   .chn1_en         (cfg_alu_src & !cfg_alu_bypass) //|< ?
  ,.chn2_en         (!cfg_alu_bypass)               //|< i
  ,.chn1_in_pvld    (chn_alu_op_pvld)               //|< i
  ,.chn1_in_prdy    (chn_alu_op_prdy)               //|> o
  ,.chn2_in_pvld    (alu_in_pvld)                   //|< i
  ,.chn2_in_prdy    (alu_in_srdy)                   //|> w
  ,.chn_out_pvld    (alu_sync_pvld)                 //|> w
  ,.chn_out_prdy    (alu_sync_prdy)                 //|< w
  ,.data1_in        (chn_alu_op[31:0])              //|< i
  ,.data2_in        (alu_data_in[31:0])             //|< i
  ,.data1_out       (alu_op_sync[31:0])             //|> w
  ,.data2_out       (alu_data_sync[31:0])           //|> w
  );

assign  alu_op_mux = cfg_alu_src ? alu_op_sync[31:0] : cfg_alu_op[31:0];

NV_NVDLA_SDP_HLS_Y_INT_ALU_pipe_p1 pipe_p1 (
   .nvdla_core_clk  (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)               //|< i
  ,.alu_data_sync   (alu_data_sync[31:0])           //|< w
  ,.alu_mux_prdy    (alu_mux_prdy)                  //|< w
  ,.alu_op_mux      (alu_op_mux[31:0])              //|< w
  ,.alu_sync_pvld   (alu_sync_pvld)                 //|< w
  ,.alu_data_reg    (alu_data_reg[31:0])            //|> w
  ,.alu_mux_pvld    (alu_mux_pvld)                  //|> w
  ,.alu_op_reg      (alu_op_reg[31:0])              //|> w
  ,.alu_sync_prdy   (alu_sync_prdy)                 //|> w
  );

assign  alu_op_ext[32:0]   = {{1{alu_op_reg[31]}}, alu_op_reg[31:0]};
assign  alu_data_ext[32:0] = {{1{alu_data_reg[31]}}, alu_data_reg[31:0]};
assign  {mon_sum_c,alu_sum[32:0]} = $signed(alu_data_ext) + $signed(alu_op_ext);

always @(
  cfg_alu_algo
  or alu_data_ext
  or alu_op_ext
  or alu_sum
  ) begin
 if (cfg_alu_algo[1:0] == 0 ) 
     alu_dout[32:0] = ($signed(alu_data_ext) > $signed(alu_op_ext)) ? alu_data_ext : alu_op_ext;
 else if (cfg_alu_algo[1:0] == 1 ) 
     alu_dout[32:0] = ($signed(alu_data_ext) < $signed(alu_op_ext)) ? alu_data_ext : alu_op_ext;
 else if (cfg_alu_algo[1:0] == 3 )
     alu_dout[32:0] = (alu_data_ext == alu_op_ext) ? 0 : 1;
 else 
     alu_dout[32:0] = alu_sum[32:0]; 
end

NV_NVDLA_HLS_saturate #(.IN_WIDTH(32 +1 ),.OUT_WIDTH(32 )) y_alu_saturate (
   .data_in         (alu_dout[32:0])                //|< r
  ,.data_out        (alu_sat[31:0])                 //|> w
  );

NV_NVDLA_SDP_HLS_Y_INT_ALU_pipe_p2 pipe_p2 (
   .nvdla_core_clk  (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)               //|< i
  ,.alu_final_prdy  (alu_final_prdy)                //|< w
  ,.alu_mux_pvld    (alu_mux_pvld)                  //|< w
  ,.alu_sat         (alu_sat[31:0])                 //|< w
  ,.alu_data_final  (alu_data_final[31:0])          //|> w
  ,.alu_final_pvld  (alu_final_pvld)                //|> w
  ,.alu_mux_prdy    (alu_mux_prdy)                  //|> w
  );

assign  alu_in_prdy    = cfg_alu_bypass ? alu_out_prdy : alu_in_srdy;
assign  alu_final_prdy = cfg_alu_bypass ? 1'b1 : alu_out_prdy;
assign  alu_out_pvld   = cfg_alu_bypass ? alu_in_pvld : alu_final_pvld;
assign  alu_data_out[31:0] = cfg_alu_bypass ? alu_data_in[31:0] : alu_data_final[31:0];

endmodule // NV_NVDLA_SDP_HLS_Y_int_alu



// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is {alu_data_reg[31:0],alu_op_reg[31:0]} (alu_mux_pvld,alu_mux_prdy) <= {alu_data_sync[31:0],alu_op_mux[31:0]} (alu_sync_pvld,alu_sync_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_ALU_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,alu_data_sync
  ,alu_mux_prdy
  ,alu_op_mux
  ,alu_sync_pvld
  ,alu_data_reg
  ,alu_mux_pvld
  ,alu_op_reg
  ,alu_sync_prdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] alu_data_sync;
input         alu_mux_prdy;
input  [31:0] alu_op_mux;
input         alu_sync_pvld;
output [31:0] alu_data_reg;
output        alu_mux_pvld;
output [31:0] alu_op_reg;
output        alu_sync_prdy;
reg    [31:0] alu_data_reg;
reg           alu_mux_pvld;
reg    [31:0] alu_op_reg;
reg           alu_sync_prdy;
reg    [63:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [63:0] p1_skid_data;
reg    [63:0] p1_skid_pipe_data;
reg           p1_skid_pipe_ready;
reg           p1_skid_pipe_valid;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
//## pipe (1) skid buffer
always @(
  alu_sync_pvld
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = alu_sync_pvld && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    alu_sync_prdy <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  alu_sync_prdy <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? {alu_data_sync[31:0],alu_op_mux[31:0]} : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or alu_sync_pvld
  or p1_skid_valid
  or alu_data_sync
  or alu_op_mux
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? alu_sync_pvld : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? {alu_data_sync[31:0],alu_op_mux[31:0]} : p1_skid_data;
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
  or alu_mux_prdy
  or p1_pipe_data
  ) begin
  alu_mux_pvld = p1_pipe_valid;
  p1_pipe_ready = alu_mux_prdy;
  {alu_data_reg[31:0],alu_op_reg[31:0]} = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (alu_mux_pvld^alu_mux_prdy^alu_sync_pvld^alu_sync_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (alu_sync_pvld && !alu_sync_prdy), (alu_sync_pvld), (alu_sync_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_ALU_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is alu_data_final[31:0] (alu_final_pvld,alu_final_prdy) <= alu_sat[31:0] (alu_mux_pvld,alu_mux_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_ALU_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,alu_final_prdy
  ,alu_mux_pvld
  ,alu_sat
  ,alu_data_final
  ,alu_final_pvld
  ,alu_mux_prdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         alu_final_prdy;
input         alu_mux_pvld;
input  [31:0] alu_sat;
output [31:0] alu_data_final;
output        alu_final_pvld;
output        alu_mux_prdy;
reg    [31:0] alu_data_final;
reg           alu_final_pvld;
reg           alu_mux_prdy;
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
  alu_mux_pvld
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = alu_mux_pvld && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    alu_mux_prdy <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  alu_mux_prdy <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? alu_sat[31:0] : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or alu_mux_pvld
  or p2_skid_valid
  or alu_sat
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? alu_mux_pvld : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? alu_sat[31:0] : p2_skid_data;
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
  or alu_final_prdy
  or p2_pipe_data
  ) begin
  alu_final_pvld = p2_pipe_valid;
  p2_pipe_ready = alu_final_prdy;
  alu_data_final[31:0] = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (alu_final_pvld^alu_final_prdy^alu_mux_pvld^alu_mux_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (alu_mux_pvld && !alu_mux_prdy), (alu_mux_pvld), (alu_mux_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_ALU_pipe_p2



