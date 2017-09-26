// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: fp_format_cvt.v

module fp_format_cvt (
   FMcvt_in_vld      //|< i
  ,FMcvt_out_rdy     //|< i
  ,fp16to17_in_X0    //|< i
  ,fp16to32_in_X0    //|< i
  ,fp16to32_in_X1    //|< i
  ,lut_X_info_in     //|< i
  ,lut_X_sel_in      //|< i
  ,lut_Y_info_in     //|< i
  ,lut_Y_sel_in      //|< i
  ,nvdla_core_clk    //|< i
  ,nvdla_core_rstn   //|< i
  ,uint16tofp17_Xin  //|< i
  ,FMcvt_in_rdy      //|> o
  ,FMcvt_out_vld     //|> o
  ,fp16to17_out_X0   //|> o
  ,fp16to32_out_X0   //|> o
  ,fp16to32_out_X1   //|> o
  ,lut_X_info_out    //|> o
  ,lut_X_sel_out     //|> o
  ,lut_Y_info_out    //|> o
  ,lut_Y_sel_out     //|> o
  ,uint16tofp17_Xout //|> o
  );
input         FMcvt_in_vld;
input         FMcvt_out_rdy;
input  [15:0] fp16to17_in_X0;
input  [15:0] fp16to32_in_X0;
input  [15:0] fp16to32_in_X1;
input   [1:0] lut_X_info_in;
input   [0:0] lut_X_sel_in;
input   [1:0] lut_Y_info_in;
input   [0:0] lut_Y_sel_in;
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [15:0] uint16tofp17_Xin;
output        FMcvt_in_rdy;
output        FMcvt_out_vld;
output [16:0] fp16to17_out_X0;
output [31:0] fp16to32_out_X0;
output [31:0] fp16to32_out_X1;
output  [1:0] lut_X_info_out;
output  [0:0] lut_X_sel_out;
output  [1:0] lut_Y_info_out;
output  [0:0] lut_Y_sel_out;
output [16:0] uint16tofp17_Xout;
wire          fp16to17_in_X0_prdy;
wire          fp16to17_in_X0_pvld;
wire          fp16to17_out_X0_prdy;
wire          fp16to17_out_X0_pvld;
wire          fp16to32_in_X0_prdy;
wire          fp16to32_in_X0_pvld;
wire          fp16to32_in_X1_prdy;
wire          fp16to32_in_X1_pvld;
wire          fp16to32_out_X0_prdy;
wire          fp16to32_out_X0_pvld;
wire          fp16to32_out_X1_prdy;
wire          fp16to32_out_X1_pvld;
wire    [5:0] info_pipe_in_pd;
wire    [5:0] info_pipe_in_pd_d0;
wire    [5:0] info_pipe_in_pd_d1;
wire          info_pipe_in_rdy;
wire          info_pipe_in_rdy_d0;
wire          info_pipe_in_rdy_d1;
wire          info_pipe_in_vld;
wire          info_pipe_in_vld_d0;
wire          info_pipe_in_vld_d1;
wire    [5:0] info_pipe_out_pd;
wire          info_pipe_out_rdy;
wire          info_pipe_out_vld;
wire    [4:0] rdys_in;
wire          uint16tofp17_Xin_prdy;
wire          uint16tofp17_Xin_pvld;
wire          uint16tofp17_Xout_prdy;
wire          uint16tofp17_Xout_pvld;
wire    [4:0] vlds_out;
///////////////////////////////////
///////////////////////////////////
assign FMcvt_in_rdy = &rdys_in;
///////////////////////////////////
assign fp16to32_in_X0_pvld   = FMcvt_in_vld & (&rdys_in[3:0]);
assign fp16to32_in_X1_pvld   = FMcvt_in_vld & (&{rdys_in[4]  ,rdys_in[2:0]});
assign fp16to17_in_X0_pvld   = FMcvt_in_vld & (&{rdys_in[4:3],rdys_in[1:0]});
assign uint16tofp17_Xin_pvld = FMcvt_in_vld & (&{rdys_in[4:2],rdys_in[0]});
//assign fp16to32_in_Y0_pvld   = FMcvt_in_vld & (&{rdys_in[8:5],rdys_in[3:0]});
//assign fp16to32_in_Y1_pvld   = FMcvt_in_vld & (&{rdys_in[8:4],rdys_in[2:0]});
//assign fp16to17_in_Y0_pvld   = FMcvt_in_vld & (&{rdys_in[8:3],rdys_in[1:0]});
//assign uint16tofp17_Yin_pvld = FMcvt_in_vld & (&{rdys_in[8:2],rdys_in[  0]});
assign info_pipe_in_vld      = FMcvt_in_vld & (&rdys_in[4:1]);

assign rdys_in = {fp16to32_in_X0_prdy, fp16to32_in_X1_prdy, fp16to17_in_X0_prdy, uint16tofp17_Xin_prdy,
                  //fp16to32_in_Y0_prdy, fp16to32_in_Y1_prdy, fp16to17_in_Y0_prdy, uint16tofp17_Yin_prdy,
                  info_pipe_in_rdy};
///////////////////////////////////////////////
HLS_fp16_to_fp32 u_X_fp16_to_fp32_0 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z         (fp16to32_in_X0[15:0])    //|< i
  ,.chn_a_rsc_vz        (fp16to32_in_X0_pvld)     //|< w
  ,.chn_a_rsc_lz        (fp16to32_in_X0_prdy)     //|> w
  ,.chn_o_rsc_z         (fp16to32_out_X0[31:0])   //|> o
  ,.chn_o_rsc_vz        (fp16to32_out_X0_prdy)    //|< w
  ,.chn_o_rsc_lz        (fp16to32_out_X0_pvld)    //|> w
  );

HLS_fp16_to_fp32 u_X_fp16_to_fp32_1 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z         (fp16to32_in_X1[15:0])    //|< i
  ,.chn_a_rsc_vz        (fp16to32_in_X1_pvld)     //|< w
  ,.chn_a_rsc_lz        (fp16to32_in_X1_prdy)     //|> w
  ,.chn_o_rsc_z         (fp16to32_out_X1[31:0])   //|> o
  ,.chn_o_rsc_vz        (fp16to32_out_X1_prdy)    //|< w
  ,.chn_o_rsc_lz        (fp16to32_out_X1_pvld)    //|> w
  );

HLS_fp16_to_fp17 u_X_fp16_to_fp17 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z         (fp16to17_in_X0[15:0])    //|< i
  ,.chn_a_rsc_vz        (fp16to17_in_X0_pvld)     //|< w
  ,.chn_a_rsc_lz        (fp16to17_in_X0_prdy)     //|> w
  ,.chn_o_rsc_z         (fp16to17_out_X0[16:0])   //|> o
  ,.chn_o_rsc_vz        (fp16to17_out_X0_prdy)    //|< w
  ,.chn_o_rsc_lz        (fp16to17_out_X0_pvld)    //|> w
  );

HLS_uint16_to_fp17 u_X_uint16_to_fp17 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z         (uint16tofp17_Xin[15:0])  //|< i
  ,.chn_a_rsc_vz        (uint16tofp17_Xin_pvld)   //|< w
  ,.chn_a_rsc_lz        (uint16tofp17_Xin_prdy)   //|> w
  ,.chn_o_rsc_z         (uint16tofp17_Xout[16:0]) //|> o
  ,.chn_o_rsc_vz        (uint16tofp17_Xout_prdy)  //|< w
  ,.chn_o_rsc_lz        (uint16tofp17_Xout_pvld)  //|> w
  );

/////////////////////////////////////////////////////
//&Instance HLS_fp16_to_fp32 u_Y_fp16_to_fp32_0;
//&Connect chn_a_rsc_z    fp16to32_in_Y0[15:0];  
//&Connect chn_a_rsc_vz   fp16to32_in_Y0_pvld; 
//&Connect chn_a_rsc_lz   fp16to32_in_Y0_prdy; 
//&Connect chn_o_rsc_z    fp16to32_out_Y0;      
//&Connect chn_o_rsc_vz   fp16to32_out_Y0_prdy;
//&Connect chn_o_rsc_lz   fp16to32_out_Y0_pvld;
//
//&Instance HLS_fp16_to_fp32 u_Y_fp16_to_fp32_1;
//&Connect chn_a_rsc_z    fp16to32_in_Y1[15:0];  
//&Connect chn_a_rsc_vz   fp16to32_in_Y1_pvld; 
//&Connect chn_a_rsc_lz   fp16to32_in_Y1_prdy; 
//&Connect chn_o_rsc_z    fp16to32_out_Y1;      
//&Connect chn_o_rsc_vz   fp16to32_out_Y1_prdy;
//&Connect chn_o_rsc_lz   fp16to32_out_Y1_pvld;
//
//&Instance HLS_fp16_to_fp17 u_Y_fp16_to_fp17; 
//&Connect chn_a_rsc_z    fp16to17_in_Y0[15:0];  
//&Connect chn_a_rsc_vz   fp16to17_in_Y0_pvld; 
//&Connect chn_a_rsc_lz   fp16to17_in_Y0_prdy; 
//&Connect chn_o_rsc_z    fp16to17_out_Y0;      
//&Connect chn_o_rsc_vz   fp16to17_out_Y0_prdy;
//&Connect chn_o_rsc_lz   fp16to17_out_Y0_pvld;
//
//&Instance HLS_uint16_to_fp17 u_Y_uint16_to_fp17;
//&Connect chn_a_rsc_z     uint16tofp17_Yin[15:0];   
//&Connect chn_a_rsc_vz    uint16tofp17_Yin_pvld;
//&Connect chn_a_rsc_lz    uint16tofp17_Yin_prdy;
//&Connect chn_o_rsc_z     uint16tofp17_Yout;     
//&Connect chn_o_rsc_vz    uint16tofp17_Yout_prdy;
//&Connect chn_o_rsc_lz    uint16tofp17_Yout_pvld;
////////////////////////////////////////////////////
assign info_pipe_in_pd = {lut_Y_sel_in[0],lut_X_sel_in[0],lut_Y_info_in[1:0],lut_X_info_in[1:0]};
// need update if NVDLA_HLS_FP16TO32_LATENCY != NVDLA_HLS_FP16TO17_LATENCY

assign info_pipe_in_vld_d0 = info_pipe_in_vld;
assign info_pipe_in_rdy = info_pipe_in_rdy_d0;
assign info_pipe_in_pd_d0[5:0] = info_pipe_in_pd[5:0];
FP_FORMAT_CVT_pipe_p1 pipe_p1 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.info_pipe_in_pd_d0  (info_pipe_in_pd_d0[5:0]) //|< w
  ,.info_pipe_in_rdy_d1 (info_pipe_in_rdy_d1)     //|< w
  ,.info_pipe_in_vld_d0 (info_pipe_in_vld_d0)     //|< w
  ,.info_pipe_in_pd_d1  (info_pipe_in_pd_d1[5:0]) //|> w
  ,.info_pipe_in_rdy_d0 (info_pipe_in_rdy_d0)     //|> w
  ,.info_pipe_in_vld_d1 (info_pipe_in_vld_d1)     //|> w
  );
assign info_pipe_out_vld = info_pipe_in_vld_d1;
assign info_pipe_in_rdy_d1 = info_pipe_out_rdy;
assign info_pipe_out_pd[5:0] = info_pipe_in_pd_d1[5:0];

assign {lut_Y_sel_out[0],lut_X_sel_out[0],lut_Y_info_out[1:0],lut_X_info_out[1:0]} = info_pipe_out_pd;

//NVDLA_HLS_FP16TO32_LATENCY and NVDLA_HLS_FP16TO17_LATENCY must equal
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
  nv_assert_never #(0,0,"NVDLA_HLS_FP16TO32_LATENCY and NVDLA_HLS_FP16TO17_LATENCY must be same value")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, 1  != 1); // spyglass disable W504 SelfDeterminedExpr-ML 
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
////////////////////////////////////////////////////
assign vlds_out = {fp16to32_out_X0_pvld,fp16to32_out_X1_pvld,fp16to17_out_X0_pvld,uint16tofp17_Xout_pvld,
                   /*fp16to32_out_Y0_pvld,fp16to32_out_Y1_pvld,fp16to17_out_Y0_pvld,uint16tofp17_Yout_pvld,*/info_pipe_out_vld};

assign fp16to32_out_X0_prdy   = FMcvt_out_rdy & (&vlds_out[3:0]);
assign fp16to32_out_X1_prdy   = FMcvt_out_rdy & (&{vlds_out[4],vlds_out[2:0]});
assign fp16to17_out_X0_prdy   = FMcvt_out_rdy & (&{vlds_out[4:3],vlds_out[1:0]});
assign uint16tofp17_Xout_prdy = FMcvt_out_rdy & (&{vlds_out[4:2],vlds_out[0]});
//assign fp16to32_out_Y0_prdy   = FMcvt_out_rdy & (&{vlds_out[8:5],vlds_out[3:0]});
//assign fp16to32_out_Y1_prdy   = FMcvt_out_rdy & (&{vlds_out[8:4],vlds_out[2:0]});
//assign fp16to17_out_Y0_prdy   = FMcvt_out_rdy & (&{vlds_out[8:3],vlds_out[1:0]});
//assign uint16tofp17_Yout_prdy = FMcvt_out_rdy & (&{vlds_out[8:2],vlds_out[  0]});
assign info_pipe_out_rdy      = FMcvt_out_rdy & (&vlds_out[4:1]);

assign FMcvt_out_vld = &vlds_out;
////////////////////////////
endmodule // fp_format_cvt



// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none info_pipe_in_pd_d1[5:0] (info_pipe_in_vld_d1,info_pipe_in_rdy_d1) <= info_pipe_in_pd_d0[5:0] (info_pipe_in_vld_d0,info_pipe_in_rdy_d0)
// **************************************************************************************************************
module FP_FORMAT_CVT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,info_pipe_in_pd_d0
  ,info_pipe_in_rdy_d1
  ,info_pipe_in_vld_d0
  ,info_pipe_in_pd_d1
  ,info_pipe_in_rdy_d0
  ,info_pipe_in_vld_d1
  );
input        nvdla_core_clk;
input        nvdla_core_rstn;
input  [5:0] info_pipe_in_pd_d0;
input        info_pipe_in_rdy_d1;
input        info_pipe_in_vld_d0;
output [5:0] info_pipe_in_pd_d1;
output       info_pipe_in_rdy_d0;
output       info_pipe_in_vld_d1;
reg    [5:0] info_pipe_in_pd_d1;
reg          info_pipe_in_rdy_d0;
reg          info_pipe_in_vld_d1;
reg    [5:0] p1_pipe_data;
reg          p1_pipe_ready;
reg          p1_pipe_ready_bc;
reg          p1_pipe_valid;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? info_pipe_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && info_pipe_in_vld_d0)? info_pipe_in_pd_d0[5:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  info_pipe_in_rdy_d0 = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or info_pipe_in_rdy_d1
  or p1_pipe_data
  ) begin
  info_pipe_in_vld_d1 = p1_pipe_valid;
  p1_pipe_ready = info_pipe_in_rdy_d1;
  info_pipe_in_pd_d1[5:0] = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (info_pipe_in_vld_d1^info_pipe_in_rdy_d1^info_pipe_in_vld_d0^info_pipe_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_3x (nvdla_core_clk, `ASSERT_RESET, (info_pipe_in_vld_d0 && !info_pipe_in_rdy_d0), (info_pipe_in_vld_d0), (info_pipe_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_FORMAT_CVT_pipe_p1



