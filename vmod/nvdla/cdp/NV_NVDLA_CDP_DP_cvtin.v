// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_cvtin.v

module NV_NVDLA_CDP_DP_cvtin (
   nvdla_core_clk         //|< i
  ,nvdla_core_rstn        //|< i
  ,cdp_rdma2dp_pd         //|< i
  ,cdp_rdma2dp_valid      //|< i
  ,cvt2buf_prdy           //|< i
  ,cvt2sync_prdy          //|< i
  ,reg2dp_datin_offset    //|< i
  ,reg2dp_datin_scale     //|< i
  ,reg2dp_datin_shifter   //|< i
  ,reg2dp_input_data_type //|< i
  ,cdp_rdma2dp_ready      //|> o
  ,cvt2buf_pd             //|> o
  ,cvt2buf_pvld           //|> o
  ,cvt2sync_pd            //|> o
  ,cvt2sync_pvld          //|> o
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [86:0] cdp_rdma2dp_pd;
input         cdp_rdma2dp_valid;
input         cvt2buf_prdy;
input         cvt2sync_prdy;
input  [15:0] reg2dp_datin_offset;
input  [15:0] reg2dp_datin_scale;
input   [4:0] reg2dp_datin_shifter;
input   [1:0] reg2dp_input_data_type;
output        cdp_rdma2dp_ready;
output [86:0] cvt2buf_pd;
output        cvt2buf_pvld;
output [86:0] cvt2sync_pd;
output        cvt2sync_pvld;
reg    [15:0] reg2dp_datin_offset_use;
reg    [15:0] reg2dp_datin_scale_use;
reg     [4:0] reg2dp_datin_shifter_use;
reg     [1:0] reg2dp_input_data_type_use;
wire   [15:0] cdp_cvtin_input_pd_0;
wire   [15:0] cdp_cvtin_input_pd_1;
wire   [15:0] cdp_cvtin_input_pd_2;
wire   [15:0] cdp_cvtin_input_pd_3;
wire          cdp_cvtin_input_rdy;
wire          cdp_cvtin_input_rdy_0;
wire          cdp_cvtin_input_rdy_1;
wire          cdp_cvtin_input_rdy_2;
wire          cdp_cvtin_input_rdy_3;
wire          cdp_cvtin_input_vld;
wire          cdp_cvtin_input_vld_0;
wire          cdp_cvtin_input_vld_1;
wire          cdp_cvtin_input_vld_2;
wire          cdp_cvtin_input_vld_3;
wire   [71:0] cdp_cvtin_output_pd;
wire   [17:0] cdp_cvtin_output_pd_0;
wire   [17:0] cdp_cvtin_output_pd_1;
wire   [17:0] cdp_cvtin_output_pd_2;
wire   [17:0] cdp_cvtin_output_pd_3;
wire          cdp_cvtin_output_rdy;
wire          cdp_cvtin_output_rdy_0;
wire          cdp_cvtin_output_rdy_1;
wire          cdp_cvtin_output_rdy_2;
wire          cdp_cvtin_output_rdy_3;
wire          cdp_cvtin_output_vld;
wire          cdp_cvtin_output_vld_0;
wire          cdp_cvtin_output_vld_1;
wire          cdp_cvtin_output_vld_2;
wire          cdp_cvtin_output_vld_3;
wire          cvtin_o_prdy;
wire          cvtin_o_pvld;
wire   [22:0] data_info_in_pd;
wire   [22:0] data_info_in_pd_d0;
wire   [22:0] data_info_in_pd_d1;
wire   [22:0] data_info_in_pd_d2;
wire   [22:0] data_info_in_pd_d3;
wire          data_info_in_rdy;
wire          data_info_in_rdy_d0;
wire          data_info_in_rdy_d1;
wire          data_info_in_rdy_d2;
wire          data_info_in_rdy_d3;
wire          data_info_in_vld;
wire          data_info_in_vld_d0;
wire          data_info_in_vld_d1;
wire          data_info_in_vld_d2;
wire          data_info_in_vld_d3;
wire   [22:0] data_info_out_pd;
wire          data_info_out_rdy;
wire          data_info_out_vld;
wire   [71:0] icvt_out_pd;
wire    [7:0] invalid_flag;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    //==========================================

//----------------------------------------
//cdp_rdma2dp_pd[78:0]
//cdp_rdma2dp_valid
//cdp_rdma2dp_ready

assign cdp_rdma2dp_ready = cdp_cvtin_input_rdy & data_info_in_rdy;
//===============================================
//pipeline delay for data info to sync with data path
//-----------------------------------------------
//data info valid in
assign data_info_in_vld = cdp_rdma2dp_valid & cdp_cvtin_input_rdy;
//data info data in
assign data_info_in_pd = cdp_rdma2dp_pd[86:64];


assign data_info_in_vld_d0 = data_info_in_vld;
assign data_info_in_rdy = data_info_in_rdy_d0;
assign data_info_in_pd_d0[22:0] = data_info_in_pd[22:0];
NV_NVDLA_CDP_DP_CVTIN_pipe_p1 pipe_p1 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.data_info_in_pd_d0  (data_info_in_pd_d0[22:0])        //|< w
  ,.data_info_in_rdy_d1 (data_info_in_rdy_d1)             //|< w
  ,.data_info_in_vld_d0 (data_info_in_vld_d0)             //|< w
  ,.data_info_in_pd_d1  (data_info_in_pd_d1[22:0])        //|> w
  ,.data_info_in_rdy_d0 (data_info_in_rdy_d0)             //|> w
  ,.data_info_in_vld_d1 (data_info_in_vld_d1)             //|> w
  );
NV_NVDLA_CDP_DP_CVTIN_pipe_p2 pipe_p2 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.data_info_in_pd_d1  (data_info_in_pd_d1[22:0])        //|< w
  ,.data_info_in_rdy_d2 (data_info_in_rdy_d2)             //|< w
  ,.data_info_in_vld_d1 (data_info_in_vld_d1)             //|< w
  ,.data_info_in_pd_d2  (data_info_in_pd_d2[22:0])        //|> w
  ,.data_info_in_rdy_d1 (data_info_in_rdy_d1)             //|> w
  ,.data_info_in_vld_d2 (data_info_in_vld_d2)             //|> w
  );
NV_NVDLA_CDP_DP_CVTIN_pipe_p3 pipe_p3 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.data_info_in_pd_d2  (data_info_in_pd_d2[22:0])        //|< w
  ,.data_info_in_rdy_d3 (data_info_in_rdy_d3)             //|< w
  ,.data_info_in_vld_d2 (data_info_in_vld_d2)             //|< w
  ,.data_info_in_pd_d3  (data_info_in_pd_d3[22:0])        //|> w
  ,.data_info_in_rdy_d2 (data_info_in_rdy_d2)             //|> w
  ,.data_info_in_vld_d3 (data_info_in_vld_d3)             //|> w
  );
assign data_info_out_vld = data_info_in_vld_d3;
assign data_info_in_rdy_d3 = data_info_out_rdy;
assign data_info_out_pd[22:0] = data_info_in_pd_d3[22:0];

//===============================================
//convertor process
//-----------------------------------------------
//cvtin valid input
assign cdp_cvtin_input_vld = cdp_rdma2dp_valid & data_info_in_rdy;
//cvtin ready input
assign cdp_cvtin_input_rdy = cdp_cvtin_input_rdy_3 & cdp_cvtin_input_rdy_2 & cdp_cvtin_input_rdy_1 & cdp_cvtin_input_rdy_0;
//cvt sub-unit valid in
assign cdp_cvtin_input_vld_0 = cdp_cvtin_input_vld & cdp_cvtin_input_rdy_1 & cdp_cvtin_input_rdy_2 & cdp_cvtin_input_rdy_3;
assign cdp_cvtin_input_vld_1 = cdp_cvtin_input_vld & cdp_cvtin_input_rdy_0 & cdp_cvtin_input_rdy_2 & cdp_cvtin_input_rdy_3;
assign cdp_cvtin_input_vld_2 = cdp_cvtin_input_vld & cdp_cvtin_input_rdy_0 & cdp_cvtin_input_rdy_1 & cdp_cvtin_input_rdy_3;
assign cdp_cvtin_input_vld_3 = cdp_cvtin_input_vld & cdp_cvtin_input_rdy_0 & cdp_cvtin_input_rdy_1 & cdp_cvtin_input_rdy_2;
//cvt sub-unit data in
assign cdp_cvtin_input_pd_0 = cdp_rdma2dp_pd[15:0];
assign cdp_cvtin_input_pd_1 = cdp_rdma2dp_pd[31:16];
assign cdp_cvtin_input_pd_2 = cdp_rdma2dp_pd[47:32];
assign cdp_cvtin_input_pd_3 = cdp_rdma2dp_pd[63:48];

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_datin_offset_use <= {16{1'b0}};
  end else begin
  reg2dp_datin_offset_use <= reg2dp_datin_offset[15:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_datin_scale_use <= {16{1'b0}};
  end else begin
  reg2dp_datin_scale_use <= reg2dp_datin_scale[15:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_datin_shifter_use <= {5{1'b0}};
  end else begin
  reg2dp_datin_shifter_use <= reg2dp_datin_shifter[4:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_input_data_type_use <= {2{1'b0}};
  end else begin
  reg2dp_input_data_type_use <= reg2dp_input_data_type[1:0];
  end
end

HLS_cdp_icvt u_HLS_cdp_icvt_0 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.chn_data_in_rsc_z   (cdp_cvtin_input_pd_0[15:0])      //|< w
  ,.chn_data_in_rsc_vz  (cdp_cvtin_input_vld_0)           //|< w
  ,.chn_data_in_rsc_lz  (cdp_cvtin_input_rdy_0)           //|> w
  ,.cfg_alu_in_rsc_z    (reg2dp_datin_offset_use[15:0])   //|< r
  ,.cfg_mul_in_rsc_z    (reg2dp_datin_scale_use[15:0])    //|< r
  ,.cfg_truncate_rsc_z  (reg2dp_datin_shifter_use[4:0])   //|< r
  ,.cfg_precision_rsc_z (reg2dp_input_data_type_use[1:0]) //|< r
  ,.chn_data_out_rsc_z  (cdp_cvtin_output_pd_0[17:0])     //|> w
  ,.chn_data_out_rsc_vz (cdp_cvtin_output_rdy_0)          //|< w
  ,.chn_data_out_rsc_lz (cdp_cvtin_output_vld_0)          //|> w
  );

HLS_cdp_icvt u_HLS_cdp_icvt_1 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.chn_data_in_rsc_z   (cdp_cvtin_input_pd_1[15:0])      //|< w
  ,.chn_data_in_rsc_vz  (cdp_cvtin_input_vld_1)           //|< w
  ,.chn_data_in_rsc_lz  (cdp_cvtin_input_rdy_1)           //|> w
  ,.cfg_alu_in_rsc_z    (reg2dp_datin_offset_use[15:0])   //|< r
  ,.cfg_mul_in_rsc_z    (reg2dp_datin_scale_use[15:0])    //|< r
  ,.cfg_truncate_rsc_z  (reg2dp_datin_shifter_use[4:0])   //|< r
  ,.cfg_precision_rsc_z (reg2dp_input_data_type_use[1:0]) //|< r
  ,.chn_data_out_rsc_z  (cdp_cvtin_output_pd_1[17:0])     //|> w
  ,.chn_data_out_rsc_vz (cdp_cvtin_output_rdy_1)          //|< w
  ,.chn_data_out_rsc_lz (cdp_cvtin_output_vld_1)          //|> w
  );

HLS_cdp_icvt u_HLS_cdp_icvt_2 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.chn_data_in_rsc_z   (cdp_cvtin_input_pd_2[15:0])      //|< w
  ,.chn_data_in_rsc_vz  (cdp_cvtin_input_vld_2)           //|< w
  ,.chn_data_in_rsc_lz  (cdp_cvtin_input_rdy_2)           //|> w
  ,.cfg_alu_in_rsc_z    (reg2dp_datin_offset_use[15:0])   //|< r
  ,.cfg_mul_in_rsc_z    (reg2dp_datin_scale_use[15:0])    //|< r
  ,.cfg_truncate_rsc_z  (reg2dp_datin_shifter_use[4:0])   //|< r
  ,.cfg_precision_rsc_z (reg2dp_input_data_type_use[1:0]) //|< r
  ,.chn_data_out_rsc_z  (cdp_cvtin_output_pd_2[17:0])     //|> w
  ,.chn_data_out_rsc_vz (cdp_cvtin_output_rdy_2)          //|< w
  ,.chn_data_out_rsc_lz (cdp_cvtin_output_vld_2)          //|> w
  );

HLS_cdp_icvt u_HLS_cdp_icvt_3 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.chn_data_in_rsc_z   (cdp_cvtin_input_pd_3[15:0])      //|< w
  ,.chn_data_in_rsc_vz  (cdp_cvtin_input_vld_3)           //|< w
  ,.chn_data_in_rsc_lz  (cdp_cvtin_input_rdy_3)           //|> w
  ,.cfg_alu_in_rsc_z    (reg2dp_datin_offset_use[15:0])   //|< r
  ,.cfg_mul_in_rsc_z    (reg2dp_datin_scale_use[15:0])    //|< r
  ,.cfg_truncate_rsc_z  (reg2dp_datin_shifter_use[4:0])   //|< r
  ,.cfg_precision_rsc_z (reg2dp_input_data_type_use[1:0]) //|< r
  ,.chn_data_out_rsc_z  (cdp_cvtin_output_pd_3[17:0])     //|> w
  ,.chn_data_out_rsc_vz (cdp_cvtin_output_rdy_3)          //|< w
  ,.chn_data_out_rsc_lz (cdp_cvtin_output_vld_3)          //|> w
  );

//sub-unit output ready
assign cdp_cvtin_output_rdy_0 = cdp_cvtin_output_rdy & (cdp_cvtin_output_vld_1 & cdp_cvtin_output_vld_2 & cdp_cvtin_output_vld_3);
assign cdp_cvtin_output_rdy_1 = cdp_cvtin_output_rdy & (cdp_cvtin_output_vld_0 & cdp_cvtin_output_vld_2 & cdp_cvtin_output_vld_3);
assign cdp_cvtin_output_rdy_2 = cdp_cvtin_output_rdy & (cdp_cvtin_output_vld_0 & cdp_cvtin_output_vld_1 & cdp_cvtin_output_vld_3);
assign cdp_cvtin_output_rdy_3 = cdp_cvtin_output_rdy & (cdp_cvtin_output_vld_0 & cdp_cvtin_output_vld_1 & cdp_cvtin_output_vld_2);
//output valid
assign cdp_cvtin_output_vld = cdp_cvtin_output_vld_0 & cdp_cvtin_output_vld_1 & cdp_cvtin_output_vld_2 & cdp_cvtin_output_vld_3;
//output ready
assign cdp_cvtin_output_rdy = cvtin_o_prdy & data_info_out_vld;
//output data
assign cdp_cvtin_output_pd  = {cdp_cvtin_output_pd_3,cdp_cvtin_output_pd_2,cdp_cvtin_output_pd_1,cdp_cvtin_output_pd_0};
//===============================================
//data info output
//-----------------------------------------------
//data info output ready
assign data_info_out_rdy = cvtin_o_prdy & cdp_cvtin_output_vld;

//===============================================
//convertor output
//-----------------------------------------------
assign cvtin_o_prdy = cvt2buf_prdy & cvt2sync_prdy;
assign cvtin_o_pvld = cdp_cvtin_output_vld & data_info_out_vld;

assign invalid_flag = data_info_out_pd[22:15];

assign icvt_out_pd = {72{invalid_flag[7:0]==8'hfe}} & {63'd0,cdp_cvtin_output_pd[8:0]}
                   | {72{invalid_flag[7:0]==8'hfc}} & {54'd0,cdp_cvtin_output_pd[17:0]}
                   | {72{invalid_flag[7:0]==8'hf8}} & {45'd0,cdp_cvtin_output_pd[26:0]}
                   | {72{invalid_flag[7:0]==8'hf0}} & {36'd0,cdp_cvtin_output_pd[35:0]}
                   | {72{invalid_flag[7:0]==8'he0}} & {27'd0,cdp_cvtin_output_pd[44:0]}
                   | {72{invalid_flag[7:0]==8'hc0}} & {18'd0,cdp_cvtin_output_pd[53:0]}
                   | {72{invalid_flag[7:0]==8'h80}} & {9'd0 ,cdp_cvtin_output_pd[62:0]}
                   | {72{invalid_flag[7:0]==8'h00}} &        cdp_cvtin_output_pd[71:0];

//assign cvt2buf_pd   = {data_info_out_pd,cdp_cvtin_output_pd};
assign cvt2buf_pd   = {data_info_out_pd[14:0],icvt_out_pd};
assign cvt2buf_pvld = cvtin_o_pvld & cvt2sync_prdy;
assign cvt2sync_pvld = cvtin_o_pvld & cvt2buf_prdy;
assign cvt2sync_pd   = {data_info_out_pd[14:0],icvt_out_pd};

//////////////////////////////////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_cvtin



// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none data_info_in_pd_d1[22:0] (data_info_in_vld_d1,data_info_in_rdy_d1) <= data_info_in_pd_d0[22:0] (data_info_in_vld_d0,data_info_in_rdy_d0)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_CVTIN_pipe_p1 (
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
input  [22:0] data_info_in_pd_d0;
input         data_info_in_rdy_d1;
input         data_info_in_vld_d0;
output [22:0] data_info_in_pd_d1;
output        data_info_in_rdy_d0;
output        data_info_in_vld_d1;
reg    [22:0] data_info_in_pd_d1;
reg           data_info_in_rdy_d0;
reg           data_info_in_vld_d1;
reg    [22:0] p1_pipe_data;
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
  p1_pipe_data <= (p1_pipe_ready_bc && data_info_in_vld_d0)? data_info_in_pd_d0[22:0] : p1_pipe_data;
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
  data_info_in_pd_d1[22:0] = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (data_info_in_vld_d1^data_info_in_rdy_d1^data_info_in_vld_d0^data_info_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (data_info_in_vld_d0 && !data_info_in_rdy_d0), (data_info_in_vld_d0), (data_info_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDP_DP_CVTIN_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none data_info_in_pd_d2[22:0] (data_info_in_vld_d2,data_info_in_rdy_d2) <= data_info_in_pd_d1[22:0] (data_info_in_vld_d1,data_info_in_rdy_d1)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_CVTIN_pipe_p2 (
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
input  [22:0] data_info_in_pd_d1;
input         data_info_in_rdy_d2;
input         data_info_in_vld_d1;
output [22:0] data_info_in_pd_d2;
output        data_info_in_rdy_d1;
output        data_info_in_vld_d2;
reg    [22:0] data_info_in_pd_d2;
reg           data_info_in_rdy_d1;
reg           data_info_in_vld_d2;
reg    [22:0] p2_pipe_data;
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
  p2_pipe_data <= (p2_pipe_ready_bc && data_info_in_vld_d1)? data_info_in_pd_d1[22:0] : p2_pipe_data;
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
  data_info_in_pd_d2[22:0] = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (data_info_in_vld_d2^data_info_in_rdy_d2^data_info_in_vld_d1^data_info_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (data_info_in_vld_d1 && !data_info_in_rdy_d1), (data_info_in_vld_d1), (data_info_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDP_DP_CVTIN_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none data_info_in_pd_d3[22:0] (data_info_in_vld_d3,data_info_in_rdy_d3) <= data_info_in_pd_d2[22:0] (data_info_in_vld_d2,data_info_in_rdy_d2)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_CVTIN_pipe_p3 (
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
input  [22:0] data_info_in_pd_d2;
input         data_info_in_rdy_d3;
input         data_info_in_vld_d2;
output [22:0] data_info_in_pd_d3;
output        data_info_in_rdy_d2;
output        data_info_in_vld_d3;
reg    [22:0] data_info_in_pd_d3;
reg           data_info_in_rdy_d2;
reg           data_info_in_vld_d3;
reg    [22:0] p3_pipe_data;
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
  p3_pipe_data <= (p3_pipe_ready_bc && data_info_in_vld_d2)? data_info_in_pd_d2[22:0] : p3_pipe_data;
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
  data_info_in_pd_d3[22:0] = p3_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (data_info_in_vld_d3^data_info_in_rdy_d3^data_info_in_vld_d2^data_info_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (data_info_in_vld_d2 && !data_info_in_rdy_d2), (data_info_in_vld_d2), (data_info_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDP_DP_CVTIN_pipe_p3



