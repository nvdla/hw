// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_cvtout.v

#include "NV_NVDLA_CDP_define.h"

module NV_NVDLA_CDP_DP_cvtout (
   nvdla_core_clk           //|< i
  ,nvdla_core_rstn          //|< i
  ,cvtout_prdy              //|< i
  ,mul2ocvt_pd              //|< i
  ,mul2ocvt_pvld            //|< i
  ,reg2dp_datout_offset     //|< i
  ,reg2dp_datout_scale      //|< i
  ,reg2dp_datout_shifter    //|< i
  ,sync2ocvt_pd             //|< i
  ,sync2ocvt_pvld           //|< i
  ,cvtout_pd                //|> o
  ,cvtout_pvld              //|> o
  ,mul2ocvt_prdy            //|> o
  ,sync2ocvt_prdy           //|> o
  );
///////////////////////////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          cvtout_prdy;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: my $icvto = NVDLA_CDP_ICVTO_BWPE;
//: my $ocvti = $icvto + 16;
//: my $ocvto = NVDLA_CDP_BWPE;
//: print "input  [${k}*${ocvti}-1:0] mul2ocvt_pd;  \n";
//: print "output  [${k}*${ocvto}+14:0] cvtout_pd;  \n";
input          mul2ocvt_pvld;
input   [31:0] reg2dp_datout_offset;
input   [15:0] reg2dp_datout_scale;
input    [5:0] reg2dp_datout_shifter;
input   [14:0] sync2ocvt_pd;
input          sync2ocvt_pvld;
output         cvtout_pvld;
output         mul2ocvt_prdy;
output         sync2ocvt_prdy;
///////////////////////////////////////////////////////////////////
reg            layer_flag;
reg     [31:0] reg2dp_datout_offset_use;
reg     [15:0] reg2dp_datout_scale_use;
reg      [5:0] reg2dp_datout_shifter_use;
wire           cdp_cvtout_in_ready;
wire           cdp_cvtout_in_valid;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: my $icvto = NVDLA_CDP_ICVTO_BWPE;
//: my $ocvti = $icvto + 16;
//: my $ocvto = NVDLA_CDP_BWPE;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         wire    [${ocvti}-1:0] cdp_cvtout_input_pd_$m;
//:         wire    [${ocvto}-1:0] cdp_cvtout_output_pd_$m;
//:     );
//: }
wire           cdp_cvtout_input_rdy;
wire           cdp_cvtout_input_vld;
wire    [NVDLA_CDP_THROUGHPUT-1:0]       cdp_cvtout_input_rdys;
wire    [NVDLA_CDP_THROUGHPUT-1:0]       cdp_cvtout_input_vlds;
wire    [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_BWPE-1:0]     cdp_cvtout_output_pd;
wire    [NVDLA_CDP_THROUGHPUT-1:0]      cdp_cvtout_output_rdys;
wire    [NVDLA_CDP_THROUGHPUT-1:0]      cdp_cvtout_output_vlds;
wire           cdp_cvtout_output_rdy;
wire           cdp_cvtout_output_vld;
wire    [14:0] data_info_in_pd;
wire    [14:0] data_info_in_pd_d0;
wire    [14:0] data_info_in_pd_d1;
wire    [14:0] data_info_in_pd_d2;
wire    [14:0] data_info_in_pd_d3;
wire    [14:0] data_info_in_pd_d4;
wire           data_info_in_rdy;
wire           data_info_in_rdy_d0;
wire           data_info_in_rdy_d1;
wire           data_info_in_rdy_d2;
wire           data_info_in_rdy_d3;
wire           data_info_in_rdy_d4;
wire           data_info_in_vld;
wire           data_info_in_vld_d0;
wire           data_info_in_vld_d1;
wire           data_info_in_vld_d2;
wire           data_info_in_vld_d3;
wire           data_info_in_vld_d4;
wire    [14:0] data_info_out_pd;
wire           data_info_out_rdy;
wire           data_info_out_vld;
///////////////////////////////////////////////////////////////////

//----------------------------------------
//interlock between data and info
assign cdp_cvtout_in_valid = sync2ocvt_pvld & mul2ocvt_pvld;
assign mul2ocvt_prdy = cdp_cvtout_in_ready & sync2ocvt_pvld;
assign sync2ocvt_prdy = cdp_cvtout_in_ready & mul2ocvt_pvld;

/////////////////////////////
assign cdp_cvtout_in_ready = cdp_cvtout_input_rdy & data_info_in_rdy;
//===============================================
//pipeline delay for data info to sync with data path
//-----------------------------------------------
//data info valid in
assign data_info_in_vld = cdp_cvtout_in_valid & cdp_cvtout_input_rdy;
//data info data in
assign data_info_in_pd[14:0] = sync2ocvt_pd[14:0];


assign data_info_in_vld_d0 = data_info_in_vld;
assign data_info_in_rdy = data_info_in_rdy_d0;
assign data_info_in_pd_d0[14:0] = data_info_in_pd[14:0];
// ::dla_pipe -stages NVDLA_HLS_CDP_OCVT_LATENCY -i data_info_in -o data_info_out -width 15; 

NV_NVDLA_CDP_DP_CVTOUT_pipe_p1 pipe_p1 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.data_info_in_pd_d0  (data_info_in_pd_d0[14:0])        //|< w
  ,.data_info_in_rdy_d1 (data_info_in_rdy_d1)             //|< w
  ,.data_info_in_vld_d0 (data_info_in_vld_d0)             //|< w
  ,.data_info_in_pd_d1  (data_info_in_pd_d1[14:0])        //|> w
  ,.data_info_in_rdy_d0 (data_info_in_rdy_d0)             //|> w
  ,.data_info_in_vld_d1 (data_info_in_vld_d1)             //|> w
  );
NV_NVDLA_CDP_DP_CVTOUT_pipe_p2 pipe_p2 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.data_info_in_pd_d1  (data_info_in_pd_d1[14:0])        //|< w
  ,.data_info_in_rdy_d2 (data_info_in_rdy_d2)             //|< w
  ,.data_info_in_vld_d1 (data_info_in_vld_d1)             //|< w
  ,.data_info_in_pd_d2  (data_info_in_pd_d2[14:0])        //|> w
  ,.data_info_in_rdy_d1 (data_info_in_rdy_d1)             //|> w
  ,.data_info_in_vld_d2 (data_info_in_vld_d2)             //|> w
  );
NV_NVDLA_CDP_DP_CVTOUT_pipe_p3 pipe_p3 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.data_info_in_pd_d2  (data_info_in_pd_d2[14:0])        //|< w
  ,.data_info_in_rdy_d3 (data_info_in_rdy_d3)             //|< w
  ,.data_info_in_vld_d2 (data_info_in_vld_d2)             //|< w
  ,.data_info_in_pd_d3  (data_info_in_pd_d3[14:0])        //|> w
  ,.data_info_in_rdy_d2 (data_info_in_rdy_d2)             //|> w
  ,.data_info_in_vld_d3 (data_info_in_vld_d3)             //|> w
  );
NV_NVDLA_CDP_DP_CVTOUT_pipe_p4 pipe_p4 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.data_info_in_pd_d3  (data_info_in_pd_d3[14:0])        //|< w
  ,.data_info_in_rdy_d4 (data_info_in_rdy_d4)             //|< w
  ,.data_info_in_vld_d3 (data_info_in_vld_d3)             //|< w
  ,.data_info_in_pd_d4  (data_info_in_pd_d4[14:0])        //|> w
  ,.data_info_in_rdy_d3 (data_info_in_rdy_d3)             //|> w
  ,.data_info_in_vld_d4 (data_info_in_vld_d4)             //|> w
  );
assign data_info_out_vld = data_info_in_vld_d4;
assign data_info_in_rdy_d4 = data_info_out_rdy;
assign data_info_out_pd[14:0] = data_info_in_pd_d4[14:0];

//===============================================
//convertor process
//-----------------------------------------------
//cvtout valid input
assign cdp_cvtout_input_vld = cdp_cvtout_in_valid & data_info_in_rdy;
//cvtout ready input
assign cdp_cvtout_input_rdy = &cdp_cvtout_input_rdys;
//cvt sub-unit valid in
//cvt sub-unit data in

//: my $k = NVDLA_CDP_THROUGHPUT;
//: my $icvto = NVDLA_CDP_ICVTO_BWPE;
//: my $ocvti = $icvto + 16;
//: my $ocvto = NVDLA_CDP_BWPE;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         assign cdp_cvtout_input_pd_$m = mul2ocvt_pd[${m}*${ocvti}+${ocvti}-1:${m}*${ocvti}];
//:         assign cdp_cvtout_input_vlds[$m] = cdp_cvtout_input_vld
//:     );
//:     foreach my $i  (0..$k-1) {
//:         print qq(
//:             & cdp_cvtout_input_rdys[$i]
//:         );
//:     }
//:     print qq(
//:         ;
//:     );
//: }

//cvt sub-unit data in

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_datout_offset_use[31:0] <= {32{1'b0}};
  end else begin
  reg2dp_datout_offset_use[31:0] <= reg2dp_datout_offset[31:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_datout_scale_use[15:0] <= {16{1'b0}};
  end else begin
  reg2dp_datout_scale_use[15:0] <= reg2dp_datout_scale[15:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_datout_shifter_use[5:0] <= {6{1'b0}};
  end else begin
  reg2dp_datout_shifter_use[5:0] <= reg2dp_datout_shifter[5:0];
  end
end
//: my $k = NVDLA_CDP_THROUGHPUT;
//: my $icvto = NVDLA_CDP_ICVTO_BWPE;
//: my $ocvti = $icvto + 16;
//: my $ocvto = NVDLA_CDP_BWPE;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         HLS_cdp_ocvt u_HLS_cdp_ocvt_$m (
//:            .nvdla_core_clk      (nvdla_core_clk)                  //|< i
//:           ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
//:           ,.chn_data_in_rsc_z   (cdp_cvtout_input_pd_${m})     //|< w
//:           ,.chn_data_in_rsc_vz  (cdp_cvtout_input_vlds[$m])          //|< w
//:           ,.chn_data_in_rsc_lz  (cdp_cvtout_input_rdys[$m])          //|> w
//:           ,.cfg_alu_in_rsc_z    (reg2dp_datout_offset_use[${ocvti}-1:0])  //|< r
//:           ,.cfg_mul_in_rsc_z    (reg2dp_datout_scale_use[15:0])   //|< r
//:           ,.cfg_truncate_rsc_z  (reg2dp_datout_shifter_use[5:0])  //|< r
//:           ,.chn_data_out_rsc_z  (cdp_cvtout_output_pd_${m}) //|> ?
//:           ,.chn_data_out_rsc_vz (cdp_cvtout_output_rdys[$m])         //|< w
//:           ,.chn_data_out_rsc_lz (cdp_cvtout_output_vlds[$m])         //|> w
//:           );
//:     );
//: }


//sub-unit output ready
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         assign cdp_cvtout_output_rdys[$m] = cdp_cvtout_output_rdy
//:     );
//:     foreach my $i  (0..$k-1) {
//:         print qq(
//:             & cdp_cvtout_output_vlds[$i]
//:         );
//:     }
//:     print qq(
//:         ;
//:     );
//: }
//output valid
assign cdp_cvtout_output_vld = &cdp_cvtout_output_vlds;
//output ready
assign cdp_cvtout_output_rdy = cvtout_prdy & data_info_out_vld;
//output data
assign cdp_cvtout_output_pd  = {
//: my $k = NVDLA_CDP_THROUGHPUT;
//: if($k > 1) {
//:   foreach my $m  (0..$k-2) {
//:     my $i = $k -$m -1;
//:     print qq(
//:         cdp_cvtout_output_pd_$i,
//:     );
//:   }
//: }
cdp_cvtout_output_pd_0};
//===============================================
//data info output
//-----------------------------------------------
//data info output ready
assign data_info_out_rdy = cvtout_prdy & cdp_cvtout_output_vld;

//===============================================
//convertor output
//-----------------------------------------------
assign cvtout_pvld = cdp_cvtout_output_vld & data_info_out_vld;
assign cvtout_pd   = {data_info_out_pd[14:0],cdp_cvtout_output_pd};

//////////////////////////////////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_cvtout



// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none data_info_in_pd_d1[14:0] (data_info_in_vld_d1,data_info_in_rdy_d1) <= data_info_in_pd_d0[14:0] (data_info_in_vld_d0,data_info_in_rdy_d0)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_CVTOUT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,data_info_in_pd_d0
  ,data_info_in_rdy_d1
  ,data_info_in_vld_d0
  ,data_info_in_pd_d1
  ,data_info_in_rdy_d0
  ,data_info_in_vld_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [14:0] data_info_in_pd_d0;
input         data_info_in_rdy_d1;
input         data_info_in_vld_d0;
output [14:0] data_info_in_pd_d1;
output        data_info_in_rdy_d0;
output        data_info_in_vld_d1;
reg    [14:0] data_info_in_pd_d1;
reg           data_info_in_rdy_d0;
reg           data_info_in_vld_d1;
reg    [14:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? data_info_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && data_info_in_vld_d0)? data_info_in_pd_d0[14:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  data_info_in_rdy_d0 = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or data_info_in_rdy_d1
  or p1_pipe_data
  ) begin
  data_info_in_vld_d1 = p1_pipe_valid;
  p1_pipe_ready = data_info_in_rdy_d1;
  data_info_in_pd_d1[14:0] = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (data_info_in_vld_d1^data_info_in_rdy_d1^data_info_in_vld_d0^data_info_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (data_info_in_vld_d0 && !data_info_in_rdy_d0), (data_info_in_vld_d0), (data_info_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDP_DP_CVTOUT_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none data_info_in_pd_d2[14:0] (data_info_in_vld_d2,data_info_in_rdy_d2) <= data_info_in_pd_d1[14:0] (data_info_in_vld_d1,data_info_in_rdy_d1)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_CVTOUT_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,data_info_in_pd_d1
  ,data_info_in_rdy_d2
  ,data_info_in_vld_d1
  ,data_info_in_pd_d2
  ,data_info_in_rdy_d1
  ,data_info_in_vld_d2
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [14:0] data_info_in_pd_d1;
input         data_info_in_rdy_d2;
input         data_info_in_vld_d1;
output [14:0] data_info_in_pd_d2;
output        data_info_in_rdy_d1;
output        data_info_in_vld_d2;
reg    [14:0] data_info_in_pd_d2;
reg           data_info_in_rdy_d1;
reg           data_info_in_vld_d2;
reg    [14:0] p2_pipe_data;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg           p2_pipe_valid;
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
  p2_pipe_valid <= (p2_pipe_ready_bc)? data_info_in_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && data_info_in_vld_d1)? data_info_in_pd_d1[14:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  data_info_in_rdy_d1 = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or data_info_in_rdy_d2
  or p2_pipe_data
  ) begin
  data_info_in_vld_d2 = p2_pipe_valid;
  p2_pipe_ready = data_info_in_rdy_d2;
  data_info_in_pd_d2[14:0] = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (data_info_in_vld_d2^data_info_in_rdy_d2^data_info_in_vld_d1^data_info_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (data_info_in_vld_d1 && !data_info_in_rdy_d1), (data_info_in_vld_d1), (data_info_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDP_DP_CVTOUT_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none data_info_in_pd_d3[14:0] (data_info_in_vld_d3,data_info_in_rdy_d3) <= data_info_in_pd_d2[14:0] (data_info_in_vld_d2,data_info_in_rdy_d2)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_CVTOUT_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,data_info_in_pd_d2
  ,data_info_in_rdy_d3
  ,data_info_in_vld_d2
  ,data_info_in_pd_d3
  ,data_info_in_rdy_d2
  ,data_info_in_vld_d3
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [14:0] data_info_in_pd_d2;
input         data_info_in_rdy_d3;
input         data_info_in_vld_d2;
output [14:0] data_info_in_pd_d3;
output        data_info_in_rdy_d2;
output        data_info_in_vld_d3;
reg    [14:0] data_info_in_pd_d3;
reg           data_info_in_rdy_d2;
reg           data_info_in_vld_d3;
reg    [14:0] p3_pipe_data;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg           p3_pipe_valid;
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
  p3_pipe_valid <= (p3_pipe_ready_bc)? data_info_in_vld_d2 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && data_info_in_vld_d2)? data_info_in_pd_d2[14:0] : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  data_info_in_rdy_d2 = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or data_info_in_rdy_d3
  or p3_pipe_data
  ) begin
  data_info_in_vld_d3 = p3_pipe_valid;
  p3_pipe_ready = data_info_in_rdy_d3;
  data_info_in_pd_d3[14:0] = p3_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (data_info_in_vld_d3^data_info_in_rdy_d3^data_info_in_vld_d2^data_info_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_10x (nvdla_core_clk, `ASSERT_RESET, (data_info_in_vld_d2 && !data_info_in_rdy_d2), (data_info_in_vld_d2), (data_info_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDP_DP_CVTOUT_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none data_info_in_pd_d4[14:0] (data_info_in_vld_d4,data_info_in_rdy_d4) <= data_info_in_pd_d3[14:0] (data_info_in_vld_d3,data_info_in_rdy_d3)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_CVTOUT_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,data_info_in_pd_d3
  ,data_info_in_rdy_d4
  ,data_info_in_vld_d3
  ,data_info_in_pd_d4
  ,data_info_in_rdy_d3
  ,data_info_in_vld_d4
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [14:0] data_info_in_pd_d3;
input         data_info_in_rdy_d4;
input         data_info_in_vld_d3;
output [14:0] data_info_in_pd_d4;
output        data_info_in_rdy_d3;
output        data_info_in_vld_d4;
reg    [14:0] data_info_in_pd_d4;
reg           data_info_in_rdy_d3;
reg           data_info_in_vld_d4;
reg    [14:0] p4_pipe_data;
reg           p4_pipe_ready;
reg           p4_pipe_ready_bc;
reg           p4_pipe_valid;
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
  p4_pipe_valid <= (p4_pipe_ready_bc)? data_info_in_vld_d3 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && data_info_in_vld_d3)? data_info_in_pd_d3[14:0] : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  data_info_in_rdy_d3 = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or data_info_in_rdy_d4
  or p4_pipe_data
  ) begin
  data_info_in_vld_d4 = p4_pipe_valid;
  p4_pipe_ready = data_info_in_rdy_d4;
  data_info_in_pd_d4[14:0] = p4_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (data_info_in_vld_d4^data_info_in_rdy_d4^data_info_in_vld_d3^data_info_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_12x (nvdla_core_clk, `ASSERT_RESET, (data_info_in_vld_d3 && !data_info_in_rdy_d3), (data_info_in_vld_d3), (data_info_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDP_DP_CVTOUT_pipe_p4



