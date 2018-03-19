// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_lut_expn.v

module NV_NVDLA_SDP_HLS_lut_expn (
   cfg_lut_offset  //|< i
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

input   [7:0] cfg_lut_offset;
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
wire    [8:0] cfg_lut_offset_ext;
wire   [31:0] filter_frac;
wire    [4:0] leadzero;
wire   [31:0] log2_lut_frac;
wire   [31:0] log2_lut_frac_reg;
wire   [31:0] log2_lut_index;
wire    [8:0] log2_lut_index_reg;
wire    [8:0] log2_lut_index_tru;
wire          log2_prdy;
wire          log2_pvld;
wire   [34:0] lut_frac_final;
wire   [31:0] lut_index_sub;
wire    [8:0] lut_index_sub_mid;
wire    [8:0] lut_index_sub_mid_tmp;
wire   [31:0] lut_index_sub_reg;
wire   [31:0] lut_index_sub_tmp;
wire          lut_oflow_final;
wire          lut_uflow_final;
wire          lut_uflow_in;
wire          lut_uflow_mid;
wire          lut_uflow_reg;
wire          lut_uflow_reg2;
wire          mon_lutin_sub_c;
wire    [1:0] mon_lutmid_sub_c;
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

    
assign  lut_uflow_in = ($signed(idx_data_in[31:0]) <= $signed(cfg_lut_start[31:0])); 

assign  {mon_lutin_sub_c,lut_index_sub_tmp[31:0]} = $signed(idx_data_in[31:0])- $signed(cfg_lut_start[31:0]);

//unsigned int
assign  lut_index_sub[31:0] = lut_uflow_in ? 0 : lut_index_sub_tmp[31:0];

NV_NVDLA_SDP_HLS_LUT_EXPN_pipe_p1 pipe_p1 (
   .nvdla_core_clk     (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)         //|< i
  ,.idx_in_pvld        (idx_in_pvld)             //|< i
  ,.lut_index_sub      (lut_index_sub[31:0])     //|< w
  ,.lut_uflow_in       (lut_uflow_in)            //|< w
  ,.sub_prdy           (sub_prdy)                //|< w
  ,.idx_in_prdy        (idx_in_prdy)             //|> o
  ,.lut_index_sub_reg  (lut_index_sub_reg[31:0]) //|> w
  ,.lut_uflow_reg      (lut_uflow_reg)           //|> w
  ,.sub_pvld           (sub_pvld)                //|> w
  );

//log2 function 
NV_DW_lsd #(.a_width(32  )) log2_dw_lsd(.a(lut_index_sub_reg[31:0]), .enc(leadzero[4:0]), .dec());    //unsigned 

assign  log2_lut_index[31:0] = (lut_uflow_reg | !(|lut_index_sub_reg)) ? {32  {1'b0}} : (32   -2 - leadzero[4:0]);   //morework

assign  filter_frac[31:0] = (1 << log2_lut_index) - 1 ; 

assign  log2_lut_frac[31:0] = lut_index_sub_reg & filter_frac;
//log2 end

assign  log2_lut_index_tru[8:0] = log2_lut_index[8:0];    //always positive

NV_NVDLA_SDP_HLS_LUT_EXPN_pipe_p2 pipe_p2 (
   .nvdla_core_clk     (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)         //|< i
  ,.log2_lut_frac      (log2_lut_frac[31:0])     //|< w
  ,.log2_lut_index_tru (log2_lut_index_tru[8:0]) //|< w
  ,.log2_prdy          (log2_prdy)               //|< w
  ,.lut_uflow_reg      (lut_uflow_reg)           //|< w
  ,.sub_pvld           (sub_pvld)                //|< w
  ,.log2_lut_frac_reg  (log2_lut_frac_reg[31:0]) //|> w
  ,.log2_lut_index_reg (log2_lut_index_reg[8:0]) //|> w
  ,.log2_pvld          (log2_pvld)               //|> w
  ,.lut_uflow_reg2     (lut_uflow_reg2)          //|> w
  ,.sub_prdy           (sub_prdy)                //|> w
  );

assign  cfg_lut_offset_ext[8:0] = {{1{cfg_lut_offset[7]}}, cfg_lut_offset[7:0]};  

assign  lut_uflow_mid = $signed({1'b0,log2_lut_index_reg[8:0]}) < $signed(cfg_lut_offset_ext[8:0]);   //morework 

assign  {mon_lutmid_sub_c[1:0],lut_index_sub_mid_tmp[8:0]} = $signed({1'b0,log2_lut_index_reg[8:0]}) - $signed(cfg_lut_offset_ext[8:0]);  //morework

assign  lut_index_sub_mid[8:0] = (lut_uflow_reg2 | lut_uflow_mid) ? 0 : lut_index_sub_mid_tmp[8:0];

assign  lut_oflow_final = (lut_index_sub_mid >= LUT_DEPTH -1); 
assign  lut_uflow_final =  lut_uflow_reg2 | lut_uflow_mid; 

//index integar
always @(
  lut_oflow_final
  or lut_index_sub_mid
  ) begin
   if (lut_oflow_final) 
       lut_index_final[8:0] = LUT_DEPTH - 1;
   else 
       lut_index_final[8:0] = lut_index_sub_mid[8:0];
end

//index fraction
assign  lut_frac_final[34:0] = {{(35 - 32  ){1'b0}},log2_lut_frac_reg[31:0]} << (35  - log2_lut_index_reg[8:0]); 

NV_NVDLA_SDP_HLS_LUT_EXPN_pipe_p3 pipe_p3 (
   .nvdla_core_clk     (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)         //|< i
  ,.idx_out_prdy       (idx_out_prdy)            //|< i
  ,.log2_pvld          (log2_pvld)               //|< w
  ,.lut_frac_final     (lut_frac_final[34:0])    //|< w
  ,.lut_index_final    (lut_index_final[8:0])    //|< r
  ,.lut_oflow_final    (lut_oflow_final)         //|< w
  ,.lut_uflow_final    (lut_uflow_final)         //|< w
  ,.idx_out_pvld       (idx_out_pvld)            //|> o
  ,.log2_prdy          (log2_prdy)               //|> w
  ,.lut_frac_out       (lut_frac_out[34:0])      //|> o
  ,.lut_index_out      (lut_index_out[8:0])      //|> o
  ,.lut_oflow_out      (lut_oflow_out)           //|> o
  ,.lut_uflow_out      (lut_uflow_out)           //|> o
  );


endmodule // NV_NVDLA_SDP_HLS_lut_expn



// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is {lut_uflow_reg,lut_index_sub_reg[31:0]} (sub_pvld,sub_prdy) <= {lut_uflow_in,lut_index_sub[31:0]} (idx_in_pvld,idx_in_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_LUT_EXPN_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,idx_in_pvld
  ,lut_index_sub
  ,lut_uflow_in
  ,sub_prdy
  ,idx_in_prdy
  ,lut_index_sub_reg
  ,lut_uflow_reg
  ,sub_pvld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         idx_in_pvld;
input  [31:0] lut_index_sub;
input         lut_uflow_in;
input         sub_prdy;
output        idx_in_prdy;
output [31:0] lut_index_sub_reg;
output        lut_uflow_reg;
output        sub_pvld;
reg           idx_in_prdy;
reg    [31:0] lut_index_sub_reg;
reg           lut_uflow_reg;
reg    [32:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [32:0] p1_skid_data;
reg    [32:0] p1_skid_pipe_data;
reg           p1_skid_pipe_ready;
reg           p1_skid_pipe_valid;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
reg           sub_pvld;
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
  p1_skid_data <= (p1_skid_catch)? {lut_uflow_in,lut_index_sub[31:0]} : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or idx_in_pvld
  or p1_skid_valid
  or lut_uflow_in
  or lut_index_sub
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? idx_in_pvld : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? {lut_uflow_in,lut_index_sub[31:0]} : p1_skid_data;
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
  or sub_prdy
  or p1_pipe_data
  ) begin
  sub_pvld = p1_pipe_valid;
  p1_pipe_ready = sub_prdy;
  {lut_uflow_reg,lut_index_sub_reg[31:0]} = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sub_pvld^sub_prdy^idx_in_pvld^idx_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_LUT_EXPN_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is {lut_uflow_reg2,log2_lut_index_reg[8:0],log2_lut_frac_reg[31:0]} (log2_pvld,log2_prdy) <= {lut_uflow_reg,log2_lut_index_tru[8:0],log2_lut_frac[31:0]} (sub_pvld,sub_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_LUT_EXPN_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,log2_lut_frac
  ,log2_lut_index_tru
  ,log2_prdy
  ,lut_uflow_reg
  ,sub_pvld
  ,log2_lut_frac_reg
  ,log2_lut_index_reg
  ,log2_pvld
  ,lut_uflow_reg2
  ,sub_prdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] log2_lut_frac;
input   [8:0] log2_lut_index_tru;
input         log2_prdy;
input         lut_uflow_reg;
input         sub_pvld;
output [31:0] log2_lut_frac_reg;
output  [8:0] log2_lut_index_reg;
output        log2_pvld;
output        lut_uflow_reg2;
output        sub_prdy;
reg    [31:0] log2_lut_frac_reg;
reg     [8:0] log2_lut_index_reg;
reg           log2_pvld;
reg           lut_uflow_reg2;
reg    [41:0] p2_pipe_data;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [41:0] p2_skid_data;
reg    [41:0] p2_skid_pipe_data;
reg           p2_skid_pipe_ready;
reg           p2_skid_pipe_valid;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
reg           sub_prdy;
//## pipe (2) skid buffer
always @(
  sub_pvld
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = sub_pvld && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    sub_prdy <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  sub_prdy <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? {lut_uflow_reg,log2_lut_index_tru[8:0],log2_lut_frac[31:0]} : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or sub_pvld
  or p2_skid_valid
  or lut_uflow_reg
  or log2_lut_index_tru
  or log2_lut_frac
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? sub_pvld : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? {lut_uflow_reg,log2_lut_index_tru[8:0],log2_lut_frac[31:0]} : p2_skid_data;
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
  or log2_prdy
  or p2_pipe_data
  ) begin
  log2_pvld = p2_pipe_valid;
  p2_pipe_ready = log2_prdy;
  {lut_uflow_reg2,log2_lut_index_reg[8:0],log2_lut_frac_reg[31:0]} = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (log2_pvld^log2_prdy^sub_pvld^sub_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (sub_pvld && !sub_prdy), (sub_pvld), (sub_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_LUT_EXPN_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is {lut_uflow_out,lut_oflow_out,lut_index_out[8:0],lut_frac_out[34:0]} (idx_out_pvld,idx_out_prdy) <= {lut_uflow_final,lut_oflow_final,lut_index_final[8:0],lut_frac_final[34:0]} (log2_pvld,log2_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_LUT_EXPN_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,idx_out_prdy
  ,log2_pvld
  ,lut_frac_final
  ,lut_index_final
  ,lut_oflow_final
  ,lut_uflow_final
  ,idx_out_pvld
  ,log2_prdy
  ,lut_frac_out
  ,lut_index_out
  ,lut_oflow_out
  ,lut_uflow_out
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         idx_out_prdy;
input         log2_pvld;
input  [34:0] lut_frac_final;
input   [8:0] lut_index_final;
input         lut_oflow_final;
input         lut_uflow_final;
output        idx_out_pvld;
output        log2_prdy;
output [34:0] lut_frac_out;
output  [8:0] lut_index_out;
output        lut_oflow_out;
output        lut_uflow_out;
reg           idx_out_pvld;
reg           log2_prdy;
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
//## pipe (3) skid buffer
always @(
  log2_pvld
  or p3_skid_ready_flop
  or p3_skid_pipe_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = log2_pvld && p3_skid_ready_flop && !p3_skid_pipe_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_skid_pipe_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    log2_prdy <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_skid_pipe_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  log2_prdy <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? {lut_uflow_final,lut_oflow_final,lut_index_final[8:0],lut_frac_final[34:0]} : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or log2_pvld
  or p3_skid_valid
  or lut_uflow_final
  or lut_oflow_final
  or lut_index_final
  or lut_frac_final
  or p3_skid_data
  ) begin
  p3_skid_pipe_valid = (p3_skid_ready_flop)? log2_pvld : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_skid_pipe_data = (p3_skid_ready_flop)? {lut_uflow_final,lut_oflow_final,lut_index_final[8:0],lut_frac_final[34:0]} : p3_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (idx_out_pvld^idx_out_prdy^log2_pvld^log2_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (log2_pvld && !log2_prdy), (log2_pvld), (log2_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_LUT_EXPN_pipe_p3



