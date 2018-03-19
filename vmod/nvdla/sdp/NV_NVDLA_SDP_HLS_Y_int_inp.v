// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_Y_int_inp.v

module NV_NVDLA_SDP_HLS_Y_int_inp (
   inp_bias_in     //|< i
  ,inp_flow_in     //|< i
  ,inp_frac_in     //|< i
  ,inp_in_pvld     //|< i
  ,inp_offset_in   //|< i
  ,inp_out_prdy    //|< i
  ,inp_scale_in    //|< i
  ,inp_shift_in    //|< i
  ,inp_x_in        //|< i
  ,inp_y0_in       //|< i
  ,inp_y1_in       //|< i
  ,nvdla_core_clk  //|< i
  ,nvdla_core_rstn //|< i
  ,inp_data_out    //|> o
  ,inp_in_prdy     //|> o
  ,inp_out_pvld    //|> o
  );

input  [31:0] inp_bias_in;
input         inp_flow_in;
input  [34:0] inp_frac_in;
input         inp_in_pvld;
input  [31:0] inp_offset_in;
input         inp_out_prdy;
input  [15:0] inp_scale_in;
input   [4:0] inp_shift_in;
input  [31:0] inp_x_in;
input  [15:0] inp_y0_in;
input  [15:0] inp_y1_in;
output [31:0] inp_data_out;
output        inp_in_prdy;
output        inp_out_pvld;

input nvdla_core_clk;
input nvdla_core_rstn;

wire          flow_in_pipe1;
wire          flow_in_pipe2;
wire          flow_in_pipe3;
wire   [70:0] flow_pd;
wire   [70:0] flow_pd2;
wire   [70:0] flow_pd2_reg;
wire   [70:0] flow_pd_reg;
wire          flow_pipe0_prdy;
wire          flow_pipe1_prdy;
wire          flow_pipe1_pvld;
wire          flow_pipe2_prdy;
wire          flow_pipe2_pvld;
wire          flow_pipe3_pvld;
wire   [34:0] frac_in;
wire   [35:0] frac_remain;
wire   [32:0] inp_bias_mux;
wire   [31:0] inp_flow_dout;
wire          inp_fout_pvld;
wire          inp_in_fvld;
wire          inp_in_frdy;
wire          inp_in_mvld;
wire          inp_in_prdy0;
wire          inp_in_prdy1;
wire          inp_mout_pvld;
wire   [49:0] inp_mul_scale;
wire   [49:0] inp_mul_scale_reg;
wire   [31:0] inp_mul_tru;
wire   [31:0] inp_nrm_dout;
wire   [33:0] inp_ob_in;
wire   [32:0] inp_offset_mux;
wire   [15:0] inp_scale_reg;
wire    [4:0] inp_shift_reg;
wire    [4:0] inp_shift_reg2;
wire   [33:0] inp_x_ext;
wire   [33:0] inp_xsub;
wire   [33:0] inp_xsub_reg;
wire   [15:0] inp_y0_mux;
wire   [15:0] inp_y0_reg;
wire   [15:0] inp_y0_reg2;
wire   [32:0] inp_y0_sum;
wire   [32:0] inp_y0_sum_reg;
wire   [52:0] intp_sum;
wire   [52:0] intp_sum_reg;
wire   [31:0] intp_sum_tru;
wire          mon_intp_sum_c;
wire          mon_xsub_c;
wire   [52:0] mul0;
wire          mul0_prdy;
wire          mul0_pvld;
wire   [52:0] mul0_reg;
wire   [52:0] mul1;
wire          mul1_prdy;
wire          mul1_pvld;
wire   [52:0] mul1_reg;
wire          mul_scale_prdy;
wire          mul_scale_pvld;
wire          sum_in_prdy;
wire          sum_in_pvld;
wire          sum_out_prdy;
wire          sum_out_pvld;
wire          xsub_prdy;
wire          xsub_pvld;

    
//overflow and unflow  interpolation
assign  inp_x_ext[33:0] = inp_flow_in ? {{2{inp_x_in[31]}}, inp_x_in[31:0]} : {32 +2 {1'b0}};
assign  inp_offset_mux[32:0] = inp_flow_in ? {inp_offset_in[32 -1],inp_offset_in[31:0]} : {(32 +1){1'b0}};  
assign  inp_bias_mux[32:0]   = inp_flow_in ? {1'b0,inp_bias_in[31:0]} : {(32 +1){1'b0}};  
assign  inp_y0_mux[15:0]  = inp_flow_in ? inp_y0_in[15:0] : {16 {1'b0}};

assign  inp_ob_in[33:0] = $signed(inp_bias_mux[32:0]) + $signed({inp_offset_mux[32:0]}); 

assign  {mon_xsub_c,inp_xsub[33:0]} = $signed(inp_x_ext[33:0]) - $signed(inp_ob_in[33:0]);      

assign  flow_pd = {inp_y0_mux[15:0],inp_shift_in[4:0],inp_scale_in[15:0],inp_xsub[33:0]};

NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p1 pipe_p1 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.flow_pd         (flow_pd[70:0])           //|< w
  ,.inp_in_pvld     (inp_in_fvld)             //|< i
  ,.inp_in_frdy     (inp_in_frdy)             //|> w
  ,.flow_pd_reg     (flow_pd_reg[70:0])       //|> w
  ,.xsub_pvld       (xsub_pvld)               //|> w
  ,.xsub_prdy       (xsub_prdy)               //|< w
  );

assign  {inp_y0_reg[15:0],inp_shift_reg[4:0],inp_scale_reg[15:0],inp_xsub_reg[33:0]} = flow_pd_reg;

assign  inp_mul_scale[49:0] = $signed(inp_xsub_reg[33:0]) * $signed(inp_scale_reg[15:0]);   //morework

assign  flow_pd2 = {inp_y0_reg[15:0],inp_shift_reg[4:0],inp_mul_scale[49:0]};

NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p2 pipe_p2 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.flow_pd2        (flow_pd2[70:0])          //|< w
  ,.mul_scale_prdy  (mul_scale_prdy)          //|< w
  ,.xsub_pvld       (xsub_pvld)               //|< w
  ,.flow_pd2_reg    (flow_pd2_reg[70:0])      //|> w
  ,.mul_scale_pvld  (mul_scale_pvld)          //|> w
  ,.xsub_prdy       (xsub_prdy)               //|> w
  );

assign  {inp_y0_reg2[15:0],inp_shift_reg2[4:0],inp_mul_scale_reg[49:0]} = flow_pd2_reg;

NV_NVDLA_HLS_shiftrightss #(.IN_WIDTH(32 + 16 + 2 ),.OUT_WIDTH(32 ),.SHIFT_WIDTH(5 )) intp_flow_shiftright_ss (
   .data_in         (inp_mul_scale_reg[49:0]) //|< w
  ,.shift_num       (inp_shift_reg2[4:0])     //|< w
  ,.data_out        (inp_mul_tru[31:0])       //|> w
  );
//signed
//signed
  
assign  inp_y0_sum[32:0] = $signed(inp_y0_reg2[15:0]) + $signed(inp_mul_tru[31:0]);  //morework 

NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p3 pipe_p3 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.inp_out_prdy    (inp_out_prdy)            //|< i
  ,.inp_y0_sum      (inp_y0_sum[32:0])        //|< w
  ,.mul_scale_pvld  (mul_scale_pvld)          //|< w
  ,.inp_fout_pvld   (inp_fout_pvld)           //|> w
  ,.inp_y0_sum_reg  (inp_y0_sum_reg[32:0])    //|> w
  ,.mul_scale_prdy  (mul_scale_prdy)          //|> w
  );

NV_NVDLA_HLS_saturate #(.IN_WIDTH(32 +1 ),.OUT_WIDTH(32 )) intp_flow_saturate (
   .data_in         (inp_y0_sum_reg[32:0])    //|< w
  ,.data_out        (inp_flow_dout[31:0])     //|> w
  );

//hit interpolation
assign  frac_in[34:0] = inp_flow_in ? 0 : inp_frac_in[34:0];   //unsigned  
 
assign  frac_remain[35:0] = (1 << 35 ) - frac_in[34:0];   //unsigned 

assign  mul0[52:0] = $signed(inp_y0_in[15:0]) *$signed({1'b0,frac_remain[35:0]});

NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p4 pipe_p4 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.inp_in_pvld     (inp_in_mvld)             //|< i
  ,.inp_in_prdy0    (inp_in_prdy0)            //|> w
  ,.mul0            (mul0[52:0])              //|< w
  ,.mul0_prdy       (mul0_prdy)               //|< w
  ,.mul0_pvld       (mul0_pvld)               //|> w
  ,.mul0_reg        (mul0_reg[52:0])          //|> w
  );

assign  mul1[52:0] = $signed(inp_y1_in[15:0]) *$signed({1'b0,frac_in[34:0]});

NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p5 pipe_p5 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.inp_in_pvld     (inp_in_mvld)             //|< i
  ,.inp_in_prdy1    (inp_in_prdy1)            //|> w
  ,.mul1            (mul1[52:0])              //|< w
  ,.mul1_prdy       (mul1_prdy)               //|< w
  ,.mul1_pvld       (mul1_pvld)               //|> w
  ,.mul1_reg        (mul1_reg[52:0])          //|> w
  );

assign  {mon_intp_sum_c,intp_sum[52:0]} = $signed(mul0_reg[52:0]) + $signed(mul1_reg[52:0]);

assign  mul0_prdy = sum_in_prdy;
assign  mul1_prdy = sum_in_prdy;
assign  sum_in_pvld = mul0_pvld & mul1_pvld;

NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p6 pipe_p6 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.intp_sum        (intp_sum[52:0])          //|< w
  ,.sum_in_pvld     (sum_in_pvld)             //|< w
  ,.sum_out_prdy    (sum_out_prdy)            //|< w
  ,.intp_sum_reg    (intp_sum_reg[52:0])      //|> w
  ,.sum_in_prdy     (sum_in_prdy)             //|> w
  ,.sum_out_pvld    (sum_out_pvld)            //|> w
  );

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(35 + 16 + 2 ),.OUT_WIDTH(32 ),.SHIFT_WIDTH(6)) inp_shiftright_su (
   .data_in         (intp_sum_reg[52:0])      //|< w
  ,.shift_num       (6'd35)                   //|< ?
  ,.data_out        (intp_sum_tru[31:0])      //|> w
  );
//signed 
//unsigned 
                
NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p7 pipe_p7 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.inp_out_prdy    (inp_out_prdy)            //|< i
  ,.intp_sum_tru    (intp_sum_tru[31:0])      //|< w
  ,.sum_out_pvld    (sum_out_pvld)            //|< w
  ,.inp_mout_pvld   (inp_mout_pvld)           //|> w
  ,.inp_nrm_dout    (inp_nrm_dout[31:0])      //|> w
  ,.sum_out_prdy    (sum_out_prdy)            //|> w
  );


assign  inp_in_fvld =  inp_flow_in ? inp_in_pvld : 1'b0; 
assign  inp_in_mvld = !inp_flow_in ? inp_in_pvld : 1'b0; 
assign  inp_in_prdy =  inp_flow_in ? inp_in_frdy : inp_in_prdy0 & inp_in_prdy1;

assign  inp_data_out = flow_in_pipe3 ? inp_flow_dout : inp_nrm_dout;
assign  inp_out_pvld = flow_in_pipe3 ? inp_fout_pvld : inp_mout_pvld; 


NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p8 pipe_p8 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.flow_pipe1_prdy (flow_pipe1_prdy)         //|< w
  ,.inp_flow_in     (inp_flow_in)             //|< i
  ,.inp_in_pvld     (inp_in_pvld)             //|< i
  ,.flow_in_pipe1   (flow_in_pipe1)           //|> w
  ,.flow_pipe0_prdy (flow_pipe0_prdy)         //|> w *
  ,.flow_pipe1_pvld (flow_pipe1_pvld)         //|> w
  );
NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p9 pipe_p9 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.flow_in_pipe1   (flow_in_pipe1)           //|< w
  ,.flow_pipe1_pvld (flow_pipe1_pvld)         //|< w
  ,.flow_pipe2_prdy (flow_pipe2_prdy)         //|< w
  ,.flow_in_pipe2   (flow_in_pipe2)           //|> w
  ,.flow_pipe1_prdy (flow_pipe1_prdy)         //|> w
  ,.flow_pipe2_pvld (flow_pipe2_pvld)         //|> w
  );
NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p10 pipe_p10 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.flow_in_pipe2   (flow_in_pipe2)           //|< w
  ,.flow_pipe2_pvld (flow_pipe2_pvld)         //|< w
  ,.inp_out_prdy    (inp_out_prdy)            //|< i
  ,.flow_in_pipe3   (flow_in_pipe3)           //|> w
  ,.flow_pipe2_prdy (flow_pipe2_prdy)         //|> w
  ,.flow_pipe3_pvld (flow_pipe3_pvld)         //|> w *
  );

endmodule // NV_NVDLA_SDP_HLS_Y_int_inp



// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is flow_pd_reg[70:0] (xsub_pvld,xsub_prdy) <= flow_pd[70:0] (inp_in_pvld,inp_in_frdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,flow_pd
  ,inp_in_pvld
  ,xsub_prdy
  ,flow_pd_reg
  ,inp_in_frdy
  ,xsub_pvld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [70:0] flow_pd;
input         inp_in_pvld;
input         xsub_prdy;
output [70:0] flow_pd_reg;
output        inp_in_frdy;
output        xsub_pvld;
reg    [70:0] flow_pd_reg;
reg           inp_in_frdy;
reg    [70:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [70:0] p1_skid_data;
reg    [70:0] p1_skid_pipe_data;
reg           p1_skid_pipe_ready;
reg           p1_skid_pipe_valid;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
reg           xsub_pvld;
//## pipe (1) skid buffer
always @(
  inp_in_pvld
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = inp_in_pvld && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    inp_in_frdy <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  inp_in_frdy <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? flow_pd[70:0] : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or inp_in_pvld
  or p1_skid_valid
  or flow_pd
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? inp_in_pvld : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? flow_pd[70:0] : p1_skid_data;
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
  or xsub_prdy
  or p1_pipe_data
  ) begin
  xsub_pvld = p1_pipe_valid;
  p1_pipe_ready = xsub_prdy;
  flow_pd_reg[70:0] = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (xsub_pvld^xsub_prdy^inp_in_pvld^inp_in_frdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (inp_in_pvld && !inp_in_frdy), (inp_in_pvld), (inp_in_frdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is flow_pd2_reg[70:0] (mul_scale_pvld,mul_scale_prdy) <= flow_pd2[70:0] (xsub_pvld,xsub_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,flow_pd2
  ,mul_scale_prdy
  ,xsub_pvld
  ,flow_pd2_reg
  ,mul_scale_pvld
  ,xsub_prdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [70:0] flow_pd2;
input         mul_scale_prdy;
input         xsub_pvld;
output [70:0] flow_pd2_reg;
output        mul_scale_pvld;
output        xsub_prdy;
reg    [70:0] flow_pd2_reg;
reg           mul_scale_pvld;
reg    [70:0] p2_pipe_data;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [70:0] p2_skid_data;
reg    [70:0] p2_skid_pipe_data;
reg           p2_skid_pipe_ready;
reg           p2_skid_pipe_valid;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
reg           xsub_prdy;
//## pipe (2) skid buffer
always @(
  xsub_pvld
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = xsub_pvld && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    xsub_prdy <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  xsub_prdy <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? flow_pd2[70:0] : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or xsub_pvld
  or p2_skid_valid
  or flow_pd2
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? xsub_pvld : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? flow_pd2[70:0] : p2_skid_data;
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
  or mul_scale_prdy
  or p2_pipe_data
  ) begin
  mul_scale_pvld = p2_pipe_valid;
  p2_pipe_ready = mul_scale_prdy;
  flow_pd2_reg[70:0] = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mul_scale_pvld^mul_scale_prdy^xsub_pvld^xsub_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (xsub_pvld && !xsub_prdy), (xsub_pvld), (xsub_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is inp_y0_sum_reg[32:0] (inp_fout_pvld,inp_out_prdy) <= inp_y0_sum[32:0] (mul_scale_pvld,mul_scale_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,inp_out_prdy
  ,inp_y0_sum
  ,mul_scale_pvld
  ,inp_fout_pvld
  ,inp_y0_sum_reg
  ,mul_scale_prdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         inp_out_prdy;
input  [32:0] inp_y0_sum;
input         mul_scale_pvld;
output        inp_fout_pvld;
output [32:0] inp_y0_sum_reg;
output        mul_scale_prdy;
reg           inp_fout_pvld;
reg    [32:0] inp_y0_sum_reg;
reg           mul_scale_prdy;
reg    [32:0] p3_pipe_data;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg           p3_pipe_valid;
reg           p3_skid_catch;
reg    [32:0] p3_skid_data;
reg    [32:0] p3_skid_pipe_data;
reg           p3_skid_pipe_ready;
reg           p3_skid_pipe_valid;
reg           p3_skid_ready;
reg           p3_skid_ready_flop;
reg           p3_skid_valid;
//## pipe (3) skid buffer
always @(
  mul_scale_pvld
  or p3_skid_ready_flop
  or p3_skid_pipe_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = mul_scale_pvld && p3_skid_ready_flop && !p3_skid_pipe_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_skid_pipe_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    mul_scale_prdy <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_skid_pipe_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  mul_scale_prdy <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? inp_y0_sum[32:0] : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or mul_scale_pvld
  or p3_skid_valid
  or inp_y0_sum
  or p3_skid_data
  ) begin
  p3_skid_pipe_valid = (p3_skid_ready_flop)? mul_scale_pvld : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_skid_pipe_data = (p3_skid_ready_flop)? inp_y0_sum[32:0] : p3_skid_data;
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
  or inp_out_prdy
  or p3_pipe_data
  ) begin
  inp_fout_pvld = p3_pipe_valid;
  p3_pipe_ready = inp_out_prdy;
  inp_y0_sum_reg[32:0] = p3_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (inp_fout_pvld^inp_out_prdy^mul_scale_pvld^mul_scale_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (mul_scale_pvld && !mul_scale_prdy), (mul_scale_pvld), (mul_scale_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is mul0_reg[52:0] (mul0_pvld,mul0_prdy) <= mul0[52:0] (inp_in_pvld,inp_in_prdy0)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,inp_in_pvld
  ,mul0
  ,mul0_prdy
  ,inp_in_prdy0
  ,mul0_pvld
  ,mul0_reg
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         inp_in_pvld;
input  [52:0] mul0;
input         mul0_prdy;
output        inp_in_prdy0;
output        mul0_pvld;
output [52:0] mul0_reg;
reg           inp_in_prdy0;
reg           mul0_pvld;
reg    [52:0] mul0_reg;
reg    [52:0] p4_pipe_data;
reg           p4_pipe_ready;
reg           p4_pipe_ready_bc;
reg           p4_pipe_valid;
reg           p4_skid_catch;
reg    [52:0] p4_skid_data;
reg    [52:0] p4_skid_pipe_data;
reg           p4_skid_pipe_ready;
reg           p4_skid_pipe_valid;
reg           p4_skid_ready;
reg           p4_skid_ready_flop;
reg           p4_skid_valid;
//## pipe (4) skid buffer
always @(
  inp_in_pvld
  or p4_skid_ready_flop
  or p4_skid_pipe_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = inp_in_pvld && p4_skid_ready_flop && !p4_skid_pipe_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_skid_pipe_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    inp_in_prdy0 <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_skid_pipe_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  inp_in_prdy0 <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? mul0[52:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or inp_in_pvld
  or p4_skid_valid
  or mul0
  or p4_skid_data
  ) begin
  p4_skid_pipe_valid = (p4_skid_ready_flop)? inp_in_pvld : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_skid_pipe_data = (p4_skid_ready_flop)? mul0[52:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? p4_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && p4_skid_pipe_valid)? p4_skid_pipe_data : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  p4_skid_pipe_ready = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or mul0_prdy
  or p4_pipe_data
  ) begin
  mul0_pvld = p4_pipe_valid;
  p4_pipe_ready = mul0_prdy;
  mul0_reg[52:0] = p4_pipe_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mul0_pvld^mul0_prdy^inp_in_pvld^inp_in_prdy0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (inp_in_pvld && !inp_in_prdy0), (inp_in_pvld), (inp_in_prdy0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is mul1_reg[52:0] (mul1_pvld,mul1_prdy) <= mul1[52:0] (inp_in_pvld,inp_in_prdy1)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p5 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,inp_in_pvld
  ,mul1
  ,mul1_prdy
  ,inp_in_prdy1
  ,mul1_pvld
  ,mul1_reg
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         inp_in_pvld;
input  [52:0] mul1;
input         mul1_prdy;
output        inp_in_prdy1;
output        mul1_pvld;
output [52:0] mul1_reg;
reg           inp_in_prdy1;
reg           mul1_pvld;
reg    [52:0] mul1_reg;
reg    [52:0] p5_pipe_data;
reg           p5_pipe_ready;
reg           p5_pipe_ready_bc;
reg           p5_pipe_valid;
reg           p5_skid_catch;
reg    [52:0] p5_skid_data;
reg    [52:0] p5_skid_pipe_data;
reg           p5_skid_pipe_ready;
reg           p5_skid_pipe_valid;
reg           p5_skid_ready;
reg           p5_skid_ready_flop;
reg           p5_skid_valid;
//## pipe (5) skid buffer
always @(
  inp_in_pvld
  or p5_skid_ready_flop
  or p5_skid_pipe_ready
  or p5_skid_valid
  ) begin
  p5_skid_catch = inp_in_pvld && p5_skid_ready_flop && !p5_skid_pipe_ready;  
  p5_skid_ready = (p5_skid_valid)? p5_skid_pipe_ready : !p5_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_skid_valid <= 1'b0;
    p5_skid_ready_flop <= 1'b1;
    inp_in_prdy1 <= 1'b1;
  end else begin
  p5_skid_valid <= (p5_skid_valid)? !p5_skid_pipe_ready : p5_skid_catch;
  p5_skid_ready_flop <= p5_skid_ready;
  inp_in_prdy1 <= p5_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_skid_data <= (p5_skid_catch)? mul1[52:0] : p5_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p5_skid_ready_flop
  or inp_in_pvld
  or p5_skid_valid
  or mul1
  or p5_skid_data
  ) begin
  p5_skid_pipe_valid = (p5_skid_ready_flop)? inp_in_pvld : p5_skid_valid; 
  // VCS sop_coverage_off start
  p5_skid_pipe_data = (p5_skid_ready_flop)? mul1[52:0] : p5_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (5) valid-ready-bubble-collapse
always @(
  p5_pipe_ready
  or p5_pipe_valid
  ) begin
  p5_pipe_ready_bc = p5_pipe_ready || !p5_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_pipe_valid <= 1'b0;
  end else begin
  p5_pipe_valid <= (p5_pipe_ready_bc)? p5_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && p5_skid_pipe_valid)? p5_skid_pipe_data : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  p5_skid_pipe_ready = p5_pipe_ready_bc;
end
//## pipe (5) output
always @(
  p5_pipe_valid
  or mul1_prdy
  or p5_pipe_data
  ) begin
  mul1_pvld = p5_pipe_valid;
  p5_pipe_ready = mul1_prdy;
  mul1_reg[52:0] = p5_pipe_data;
end
//## pipe (5) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p5_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mul1_pvld^mul1_prdy^inp_in_pvld^inp_in_prdy1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_10x (nvdla_core_clk, `ASSERT_RESET, (inp_in_pvld && !inp_in_prdy1), (inp_in_pvld), (inp_in_prdy1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p5




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is intp_sum_reg[52:0] (sum_out_pvld,sum_out_prdy) <= intp_sum[52:0] (sum_in_pvld,sum_in_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p6 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,intp_sum
  ,sum_in_pvld
  ,sum_out_prdy
  ,intp_sum_reg
  ,sum_in_prdy
  ,sum_out_pvld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [52:0] intp_sum;
input         sum_in_pvld;
input         sum_out_prdy;
output [52:0] intp_sum_reg;
output        sum_in_prdy;
output        sum_out_pvld;
reg    [52:0] intp_sum_reg;
reg    [52:0] p6_pipe_data;
reg           p6_pipe_ready;
reg           p6_pipe_ready_bc;
reg           p6_pipe_valid;
reg           p6_skid_catch;
reg    [52:0] p6_skid_data;
reg    [52:0] p6_skid_pipe_data;
reg           p6_skid_pipe_ready;
reg           p6_skid_pipe_valid;
reg           p6_skid_ready;
reg           p6_skid_ready_flop;
reg           p6_skid_valid;
reg           sum_in_prdy;
reg           sum_out_pvld;
//## pipe (6) skid buffer
always @(
  sum_in_pvld
  or p6_skid_ready_flop
  or p6_skid_pipe_ready
  or p6_skid_valid
  ) begin
  p6_skid_catch = sum_in_pvld && p6_skid_ready_flop && !p6_skid_pipe_ready;  
  p6_skid_ready = (p6_skid_valid)? p6_skid_pipe_ready : !p6_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p6_skid_valid <= 1'b0;
    p6_skid_ready_flop <= 1'b1;
    sum_in_prdy <= 1'b1;
  end else begin
  p6_skid_valid <= (p6_skid_valid)? !p6_skid_pipe_ready : p6_skid_catch;
  p6_skid_ready_flop <= p6_skid_ready;
  sum_in_prdy <= p6_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p6_skid_data <= (p6_skid_catch)? intp_sum[52:0] : p6_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p6_skid_ready_flop
  or sum_in_pvld
  or p6_skid_valid
  or intp_sum
  or p6_skid_data
  ) begin
  p6_skid_pipe_valid = (p6_skid_ready_flop)? sum_in_pvld : p6_skid_valid; 
  // VCS sop_coverage_off start
  p6_skid_pipe_data = (p6_skid_ready_flop)? intp_sum[52:0] : p6_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (6) valid-ready-bubble-collapse
always @(
  p6_pipe_ready
  or p6_pipe_valid
  ) begin
  p6_pipe_ready_bc = p6_pipe_ready || !p6_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p6_pipe_valid <= 1'b0;
  end else begin
  p6_pipe_valid <= (p6_pipe_ready_bc)? p6_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p6_pipe_data <= (p6_pipe_ready_bc && p6_skid_pipe_valid)? p6_skid_pipe_data : p6_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p6_pipe_ready_bc
  ) begin
  p6_skid_pipe_ready = p6_pipe_ready_bc;
end
//## pipe (6) output
always @(
  p6_pipe_valid
  or sum_out_prdy
  or p6_pipe_data
  ) begin
  sum_out_pvld = p6_pipe_valid;
  p6_pipe_ready = sum_out_prdy;
  intp_sum_reg[52:0] = p6_pipe_data;
end
//## pipe (6) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p6_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sum_out_pvld^sum_out_prdy^sum_in_pvld^sum_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_12x (nvdla_core_clk, `ASSERT_RESET, (sum_in_pvld && !sum_in_prdy), (sum_in_pvld), (sum_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p6




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is inp_nrm_dout[31:0] (inp_mout_pvld,inp_out_prdy) <= intp_sum_tru[31:0] (sum_out_pvld,sum_out_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p7 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,inp_out_prdy
  ,intp_sum_tru
  ,sum_out_pvld
  ,inp_mout_pvld
  ,inp_nrm_dout
  ,sum_out_prdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         inp_out_prdy;
input  [31:0] intp_sum_tru;
input         sum_out_pvld;
output        inp_mout_pvld;
output [31:0] inp_nrm_dout;
output        sum_out_prdy;
reg           inp_mout_pvld;
reg    [31:0] inp_nrm_dout;
reg    [31:0] p7_pipe_data;
reg           p7_pipe_ready;
reg           p7_pipe_ready_bc;
reg           p7_pipe_valid;
reg           p7_skid_catch;
reg    [31:0] p7_skid_data;
reg    [31:0] p7_skid_pipe_data;
reg           p7_skid_pipe_ready;
reg           p7_skid_pipe_valid;
reg           p7_skid_ready;
reg           p7_skid_ready_flop;
reg           p7_skid_valid;
reg           sum_out_prdy;
//## pipe (7) skid buffer
always @(
  sum_out_pvld
  or p7_skid_ready_flop
  or p7_skid_pipe_ready
  or p7_skid_valid
  ) begin
  p7_skid_catch = sum_out_pvld && p7_skid_ready_flop && !p7_skid_pipe_ready;  
  p7_skid_ready = (p7_skid_valid)? p7_skid_pipe_ready : !p7_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_skid_valid <= 1'b0;
    p7_skid_ready_flop <= 1'b1;
    sum_out_prdy <= 1'b1;
  end else begin
  p7_skid_valid <= (p7_skid_valid)? !p7_skid_pipe_ready : p7_skid_catch;
  p7_skid_ready_flop <= p7_skid_ready;
  sum_out_prdy <= p7_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p7_skid_data <= (p7_skid_catch)? intp_sum_tru[31:0] : p7_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p7_skid_ready_flop
  or sum_out_pvld
  or p7_skid_valid
  or intp_sum_tru
  or p7_skid_data
  ) begin
  p7_skid_pipe_valid = (p7_skid_ready_flop)? sum_out_pvld : p7_skid_valid; 
  // VCS sop_coverage_off start
  p7_skid_pipe_data = (p7_skid_ready_flop)? intp_sum_tru[31:0] : p7_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (7) valid-ready-bubble-collapse
always @(
  p7_pipe_ready
  or p7_pipe_valid
  ) begin
  p7_pipe_ready_bc = p7_pipe_ready || !p7_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_pipe_valid <= 1'b0;
  end else begin
  p7_pipe_valid <= (p7_pipe_ready_bc)? p7_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p7_pipe_data <= (p7_pipe_ready_bc && p7_skid_pipe_valid)? p7_skid_pipe_data : p7_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p7_pipe_ready_bc
  ) begin
  p7_skid_pipe_ready = p7_pipe_ready_bc;
end
//## pipe (7) output
always @(
  p7_pipe_valid
  or inp_out_prdy
  or p7_pipe_data
  ) begin
  inp_mout_pvld = p7_pipe_valid;
  p7_pipe_ready = inp_out_prdy;
  inp_nrm_dout[31:0] = p7_pipe_data;
end
//## pipe (7) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p7_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (inp_mout_pvld^inp_out_prdy^sum_out_pvld^sum_out_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_14x (nvdla_core_clk, `ASSERT_RESET, (sum_out_pvld && !sum_out_prdy), (sum_out_pvld), (sum_out_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p7




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is flow_in_pipe1 (flow_pipe1_pvld,flow_pipe1_prdy) <= inp_flow_in   (inp_in_pvld,    flow_pipe0_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p8 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,flow_pipe1_prdy
  ,inp_flow_in
  ,inp_in_pvld
  ,flow_in_pipe1
  ,flow_pipe0_prdy
  ,flow_pipe1_pvld
  );
input   nvdla_core_clk;
input   nvdla_core_rstn;
input   flow_pipe1_prdy;
input   inp_flow_in;
input   inp_in_pvld;
output  flow_in_pipe1;
output  flow_pipe0_prdy;
output  flow_pipe1_pvld;
reg     flow_in_pipe1;
reg     flow_pipe0_prdy;
reg     flow_pipe1_pvld;
reg     p8_pipe_data;
reg     p8_pipe_ready;
reg     p8_pipe_ready_bc;
reg     p8_pipe_valid;
reg     p8_skid_catch;
reg     p8_skid_data;
reg     p8_skid_pipe_data;
reg     p8_skid_pipe_ready;
reg     p8_skid_pipe_valid;
reg     p8_skid_ready;
reg     p8_skid_ready_flop;
reg     p8_skid_valid;
//## pipe (8) skid buffer
always @(
  inp_in_pvld
  or p8_skid_ready_flop
  or p8_skid_pipe_ready
  or p8_skid_valid
  ) begin
  p8_skid_catch = inp_in_pvld && p8_skid_ready_flop && !p8_skid_pipe_ready;  
  p8_skid_ready = (p8_skid_valid)? p8_skid_pipe_ready : !p8_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p8_skid_valid <= 1'b0;
    p8_skid_ready_flop <= 1'b1;
    flow_pipe0_prdy <= 1'b1;
  end else begin
  p8_skid_valid <= (p8_skid_valid)? !p8_skid_pipe_ready : p8_skid_catch;
  p8_skid_ready_flop <= p8_skid_ready;
  flow_pipe0_prdy <= p8_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p8_skid_data <= (p8_skid_catch)? inp_flow_in : p8_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p8_skid_ready_flop
  or inp_in_pvld
  or p8_skid_valid
  or inp_flow_in
  or p8_skid_data
  ) begin
  p8_skid_pipe_valid = (p8_skid_ready_flop)? inp_in_pvld : p8_skid_valid; 
  // VCS sop_coverage_off start
  p8_skid_pipe_data = (p8_skid_ready_flop)? inp_flow_in : p8_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (8) valid-ready-bubble-collapse
always @(
  p8_pipe_ready
  or p8_pipe_valid
  ) begin
  p8_pipe_ready_bc = p8_pipe_ready || !p8_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p8_pipe_valid <= 1'b0;
  end else begin
  p8_pipe_valid <= (p8_pipe_ready_bc)? p8_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p8_pipe_data <= (p8_pipe_ready_bc && p8_skid_pipe_valid)? p8_skid_pipe_data : p8_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p8_pipe_ready_bc
  ) begin
  p8_skid_pipe_ready = p8_pipe_ready_bc;
end
//## pipe (8) output
always @(
  p8_pipe_valid
  or flow_pipe1_prdy
  or p8_pipe_data
  ) begin
  flow_pipe1_pvld = p8_pipe_valid;
  p8_pipe_ready = flow_pipe1_prdy;
  flow_in_pipe1 = p8_pipe_data;
end
//## pipe (8) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p8_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (flow_pipe1_pvld^flow_pipe1_prdy^inp_in_pvld^flow_pipe0_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_16x (nvdla_core_clk, `ASSERT_RESET, (inp_in_pvld && !flow_pipe0_prdy), (inp_in_pvld), (flow_pipe0_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p8




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is flow_in_pipe2 (flow_pipe2_pvld,flow_pipe2_prdy) <= flow_in_pipe1 (flow_pipe1_pvld,flow_pipe1_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p9 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,flow_in_pipe1
  ,flow_pipe1_pvld
  ,flow_pipe2_prdy
  ,flow_in_pipe2
  ,flow_pipe1_prdy
  ,flow_pipe2_pvld
  );
input   nvdla_core_clk;
input   nvdla_core_rstn;
input   flow_in_pipe1;
input   flow_pipe1_pvld;
input   flow_pipe2_prdy;
output  flow_in_pipe2;
output  flow_pipe1_prdy;
output  flow_pipe2_pvld;
reg     flow_in_pipe2;
reg     flow_pipe1_prdy;
reg     flow_pipe2_pvld;
reg     p9_pipe_data;
reg     p9_pipe_ready;
reg     p9_pipe_ready_bc;
reg     p9_pipe_valid;
reg     p9_skid_catch;
reg     p9_skid_data;
reg     p9_skid_pipe_data;
reg     p9_skid_pipe_ready;
reg     p9_skid_pipe_valid;
reg     p9_skid_ready;
reg     p9_skid_ready_flop;
reg     p9_skid_valid;
//## pipe (9) skid buffer
always @(
  flow_pipe1_pvld
  or p9_skid_ready_flop
  or p9_skid_pipe_ready
  or p9_skid_valid
  ) begin
  p9_skid_catch = flow_pipe1_pvld && p9_skid_ready_flop && !p9_skid_pipe_ready;  
  p9_skid_ready = (p9_skid_valid)? p9_skid_pipe_ready : !p9_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p9_skid_valid <= 1'b0;
    p9_skid_ready_flop <= 1'b1;
    flow_pipe1_prdy <= 1'b1;
  end else begin
  p9_skid_valid <= (p9_skid_valid)? !p9_skid_pipe_ready : p9_skid_catch;
  p9_skid_ready_flop <= p9_skid_ready;
  flow_pipe1_prdy <= p9_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p9_skid_data <= (p9_skid_catch)? flow_in_pipe1 : p9_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p9_skid_ready_flop
  or flow_pipe1_pvld
  or p9_skid_valid
  or flow_in_pipe1
  or p9_skid_data
  ) begin
  p9_skid_pipe_valid = (p9_skid_ready_flop)? flow_pipe1_pvld : p9_skid_valid; 
  // VCS sop_coverage_off start
  p9_skid_pipe_data = (p9_skid_ready_flop)? flow_in_pipe1 : p9_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (9) valid-ready-bubble-collapse
always @(
  p9_pipe_ready
  or p9_pipe_valid
  ) begin
  p9_pipe_ready_bc = p9_pipe_ready || !p9_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p9_pipe_valid <= 1'b0;
  end else begin
  p9_pipe_valid <= (p9_pipe_ready_bc)? p9_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p9_pipe_data <= (p9_pipe_ready_bc && p9_skid_pipe_valid)? p9_skid_pipe_data : p9_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p9_pipe_ready_bc
  ) begin
  p9_skid_pipe_ready = p9_pipe_ready_bc;
end
//## pipe (9) output
always @(
  p9_pipe_valid
  or flow_pipe2_prdy
  or p9_pipe_data
  ) begin
  flow_pipe2_pvld = p9_pipe_valid;
  p9_pipe_ready = flow_pipe2_prdy;
  flow_in_pipe2 = p9_pipe_data;
end
//## pipe (9) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p9_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (flow_pipe2_pvld^flow_pipe2_prdy^flow_pipe1_pvld^flow_pipe1_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_18x (nvdla_core_clk, `ASSERT_RESET, (flow_pipe1_pvld && !flow_pipe1_prdy), (flow_pipe1_pvld), (flow_pipe1_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p9




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is flow_in_pipe3 (flow_pipe3_pvld,inp_out_prdy)    <= flow_in_pipe2 (flow_pipe2_pvld,flow_pipe2_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p10 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,flow_in_pipe2
  ,flow_pipe2_pvld
  ,inp_out_prdy
  ,flow_in_pipe3
  ,flow_pipe2_prdy
  ,flow_pipe3_pvld
  );
input   nvdla_core_clk;
input   nvdla_core_rstn;
input   flow_in_pipe2;
input   flow_pipe2_pvld;
input   inp_out_prdy;
output  flow_in_pipe3;
output  flow_pipe2_prdy;
output  flow_pipe3_pvld;
reg     flow_in_pipe3;
reg     flow_pipe2_prdy;
reg     flow_pipe3_pvld;
reg     p10_pipe_data;
reg     p10_pipe_ready;
reg     p10_pipe_ready_bc;
reg     p10_pipe_valid;
reg     p10_skid_catch;
reg     p10_skid_data;
reg     p10_skid_pipe_data;
reg     p10_skid_pipe_ready;
reg     p10_skid_pipe_valid;
reg     p10_skid_ready;
reg     p10_skid_ready_flop;
reg     p10_skid_valid;
//## pipe (10) skid buffer
always @(
  flow_pipe2_pvld
  or p10_skid_ready_flop
  or p10_skid_pipe_ready
  or p10_skid_valid
  ) begin
  p10_skid_catch = flow_pipe2_pvld && p10_skid_ready_flop && !p10_skid_pipe_ready;  
  p10_skid_ready = (p10_skid_valid)? p10_skid_pipe_ready : !p10_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p10_skid_valid <= 1'b0;
    p10_skid_ready_flop <= 1'b1;
    flow_pipe2_prdy <= 1'b1;
  end else begin
  p10_skid_valid <= (p10_skid_valid)? !p10_skid_pipe_ready : p10_skid_catch;
  p10_skid_ready_flop <= p10_skid_ready;
  flow_pipe2_prdy <= p10_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p10_skid_data <= (p10_skid_catch)? flow_in_pipe2 : p10_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p10_skid_ready_flop
  or flow_pipe2_pvld
  or p10_skid_valid
  or flow_in_pipe2
  or p10_skid_data
  ) begin
  p10_skid_pipe_valid = (p10_skid_ready_flop)? flow_pipe2_pvld : p10_skid_valid; 
  // VCS sop_coverage_off start
  p10_skid_pipe_data = (p10_skid_ready_flop)? flow_in_pipe2 : p10_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (10) valid-ready-bubble-collapse
always @(
  p10_pipe_ready
  or p10_pipe_valid
  ) begin
  p10_pipe_ready_bc = p10_pipe_ready || !p10_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p10_pipe_valid <= 1'b0;
  end else begin
  p10_pipe_valid <= (p10_pipe_ready_bc)? p10_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p10_pipe_data <= (p10_pipe_ready_bc && p10_skid_pipe_valid)? p10_skid_pipe_data : p10_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p10_pipe_ready_bc
  ) begin
  p10_skid_pipe_ready = p10_pipe_ready_bc;
end
//## pipe (10) output
always @(
  p10_pipe_valid
  or inp_out_prdy
  or p10_pipe_data
  ) begin
  flow_pipe3_pvld = p10_pipe_valid;
  p10_pipe_ready = inp_out_prdy;
  flow_in_pipe3 = p10_pipe_data;
end
//## pipe (10) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p10_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (flow_pipe3_pvld^inp_out_prdy^flow_pipe2_pvld^flow_pipe2_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_20x (nvdla_core_clk, `ASSERT_RESET, (flow_pipe2_pvld && !flow_pipe2_prdy), (flow_pipe2_pvld), (flow_pipe2_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_INP_pipe_p10



