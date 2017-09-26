// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_cvtout.v

module NV_NVDLA_CDP_DP_cvtout (
   nvdla_core_clk           //|< i
  ,nvdla_core_rstn          //|< i
  ,cvtout_prdy              //|< i
  ,dp2reg_done              //|< i
  ,mul2ocvt_pd              //|< i
  ,mul2ocvt_pvld            //|< i
  ,reg2dp_datout_offset     //|< i
  ,reg2dp_datout_scale      //|< i
  ,reg2dp_datout_shifter    //|< i
  ,reg2dp_input_data_type   //|< i
  ,sync2ocvt_pd             //|< i
  ,sync2ocvt_pvld           //|< i
  ,cvtout_pd                //|> o
  ,cvtout_pvld              //|> o
  ,dp2reg_d0_out_saturation //|> o
  ,dp2reg_d1_out_saturation //|> o
  ,mul2ocvt_prdy            //|> o
  ,sync2ocvt_prdy           //|> o
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          cvtout_prdy;
input          dp2reg_done;
input  [199:0] mul2ocvt_pd;
input          mul2ocvt_pvld;
input   [31:0] reg2dp_datout_offset;
input   [15:0] reg2dp_datout_scale;
input    [5:0] reg2dp_datout_shifter;
input    [1:0] reg2dp_input_data_type;
input   [14:0] sync2ocvt_pd;
input          sync2ocvt_pvld;
output  [78:0] cvtout_pd;
output         cvtout_pvld;
output  [31:0] dp2reg_d0_out_saturation;
output  [31:0] dp2reg_d1_out_saturation;
output         mul2ocvt_prdy;
output         sync2ocvt_prdy;
reg     [31:0] dp2reg_d0_out_saturation;
reg     [31:0] dp2reg_d1_out_saturation;
reg            layer_flag;
reg     [31:0] reg2dp_datout_offset_use;
reg     [15:0] reg2dp_datout_scale_use;
reg      [5:0] reg2dp_datout_shifter_use;
reg      [1:0] reg2dp_input_data_type_use;
reg     [31:0] sat_cnt;
wire           cdp_cvtout_in_ready;
wire           cdp_cvtout_in_valid;
wire    [49:0] cdp_cvtout_input_pd_0;
wire    [49:0] cdp_cvtout_input_pd_1;
wire    [49:0] cdp_cvtout_input_pd_2;
wire    [49:0] cdp_cvtout_input_pd_3;
wire           cdp_cvtout_input_rdy;
wire           cdp_cvtout_input_rdy_0;
wire           cdp_cvtout_input_rdy_1;
wire           cdp_cvtout_input_rdy_2;
wire           cdp_cvtout_input_rdy_3;
wire           cdp_cvtout_input_vld;
wire           cdp_cvtout_input_vld_0;
wire           cdp_cvtout_input_vld_1;
wire           cdp_cvtout_input_vld_2;
wire           cdp_cvtout_input_vld_3;
wire    [63:0] cdp_cvtout_output_pd;
wire    [15:0] cdp_cvtout_output_pd_0;
wire    [15:0] cdp_cvtout_output_pd_1;
wire    [15:0] cdp_cvtout_output_pd_2;
wire    [15:0] cdp_cvtout_output_pd_3;
wire           cdp_cvtout_output_rdy;
wire           cdp_cvtout_output_rdy_0;
wire           cdp_cvtout_output_rdy_1;
wire           cdp_cvtout_output_rdy_2;
wire           cdp_cvtout_output_rdy_3;
wire           cdp_cvtout_output_vld;
wire           cdp_cvtout_output_vld_0;
wire           cdp_cvtout_output_vld_1;
wire           cdp_cvtout_output_vld_2;
wire           cdp_cvtout_output_vld_3;
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
wire           fp16_dout_load;
wire           fp16_en;
wire     [3:0] fp16_status_saturation;
wire           layer_done;
wire           mon_sat_cnt_nxt;
wire    [31:0] sat_cnt_nxt;
wire     [3:0] saturation_ele;
wire     [7:0] stat_sat;
wire     [7:0] status_saturation;
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
assign cdp_cvtout_input_rdy = cdp_cvtout_input_rdy_3 & cdp_cvtout_input_rdy_2 & cdp_cvtout_input_rdy_1 & cdp_cvtout_input_rdy_0;
//cvt sub-unit valid in
assign cdp_cvtout_input_vld_0 = cdp_cvtout_input_vld & cdp_cvtout_input_rdy_1 & cdp_cvtout_input_rdy_2 & cdp_cvtout_input_rdy_3;
assign cdp_cvtout_input_vld_1 = cdp_cvtout_input_vld & cdp_cvtout_input_rdy_0 & cdp_cvtout_input_rdy_2 & cdp_cvtout_input_rdy_3;
assign cdp_cvtout_input_vld_2 = cdp_cvtout_input_vld & cdp_cvtout_input_rdy_0 & cdp_cvtout_input_rdy_1 & cdp_cvtout_input_rdy_3;
assign cdp_cvtout_input_vld_3 = cdp_cvtout_input_vld & cdp_cvtout_input_rdy_0 & cdp_cvtout_input_rdy_1 & cdp_cvtout_input_rdy_2;
//cvt sub-unit data in
assign cdp_cvtout_input_pd_0 = mul2ocvt_pd[49:0];   //cdp_cvtout_in_pd[49:0];
assign cdp_cvtout_input_pd_1 = mul2ocvt_pd[99:50];  //cdp_cvtout_in_pd[99:50];
assign cdp_cvtout_input_pd_2 = mul2ocvt_pd[149:100];//cdp_cvtout_in_pd[149:100];
assign cdp_cvtout_input_pd_3 = mul2ocvt_pd[199:150];//cdp_cvtout_in_pd[199:150];

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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_input_data_type_use[1:0] <= {2{1'b0}};
  end else begin
  reg2dp_input_data_type_use[1:0] <= reg2dp_input_data_type[1:0];
  end
end

HLS_cdp_ocvt u_HLS_cdp_ocvt_0 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.chn_data_in_rsc_z   (cdp_cvtout_input_pd_0[49:0])     //|< w
  ,.chn_data_in_rsc_vz  (cdp_cvtout_input_vld_0)          //|< w
  ,.chn_data_in_rsc_lz  (cdp_cvtout_input_rdy_0)          //|> w
  ,.cfg_alu_in_rsc_z    (reg2dp_datout_offset_use[31:0])  //|< r
  ,.cfg_mul_in_rsc_z    (reg2dp_datout_scale_use[15:0])   //|< r
  ,.cfg_truncate_rsc_z  (reg2dp_datout_shifter_use[5:0])  //|< r
  ,.cfg_precision_rsc_z (reg2dp_input_data_type_use[1:0]) //|< r
  ,.chn_data_out_rsc_z  ({status_saturation[1:0],cdp_cvtout_output_pd_0[15:0]}) //|> ?
  ,.chn_data_out_rsc_vz (cdp_cvtout_output_rdy_0)         //|< w
  ,.chn_data_out_rsc_lz (cdp_cvtout_output_vld_0)         //|> w
  );
 //&Connect  status_saturation_rsc_z      status_saturation[1:0];

HLS_cdp_ocvt u_HLS_cdp_ocvt_1 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.chn_data_in_rsc_z   (cdp_cvtout_input_pd_1[49:0])     //|< w
  ,.chn_data_in_rsc_vz  (cdp_cvtout_input_vld_1)          //|< w
  ,.chn_data_in_rsc_lz  (cdp_cvtout_input_rdy_1)          //|> w
  ,.cfg_alu_in_rsc_z    (reg2dp_datout_offset_use[31:0])  //|< r
  ,.cfg_mul_in_rsc_z    (reg2dp_datout_scale_use[15:0])   //|< r
  ,.cfg_truncate_rsc_z  (reg2dp_datout_shifter_use[5:0])  //|< r
  ,.cfg_precision_rsc_z (reg2dp_input_data_type_use[1:0]) //|< r
  ,.chn_data_out_rsc_z  ({status_saturation[3:2],cdp_cvtout_output_pd_1[15:0]}) //|> ?
  ,.chn_data_out_rsc_vz (cdp_cvtout_output_rdy_1)         //|< w
  ,.chn_data_out_rsc_lz (cdp_cvtout_output_vld_1)         //|> w
  );
 //&Connect  status_saturation_rsc_z      status_saturation[3:2];

HLS_cdp_ocvt u_HLS_cdp_ocvt_2 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.chn_data_in_rsc_z   (cdp_cvtout_input_pd_2[49:0])     //|< w
  ,.chn_data_in_rsc_vz  (cdp_cvtout_input_vld_2)          //|< w
  ,.chn_data_in_rsc_lz  (cdp_cvtout_input_rdy_2)          //|> w
  ,.cfg_alu_in_rsc_z    (reg2dp_datout_offset_use[31:0])  //|< r
  ,.cfg_mul_in_rsc_z    (reg2dp_datout_scale_use[15:0])   //|< r
  ,.cfg_truncate_rsc_z  (reg2dp_datout_shifter_use[5:0])  //|< r
  ,.cfg_precision_rsc_z (reg2dp_input_data_type_use[1:0]) //|< r
  ,.chn_data_out_rsc_z  ({status_saturation[5:4],cdp_cvtout_output_pd_2[15:0]}) //|> ?
  ,.chn_data_out_rsc_vz (cdp_cvtout_output_rdy_2)         //|< w
  ,.chn_data_out_rsc_lz (cdp_cvtout_output_vld_2)         //|> w
  );
 //&Connect  status_saturation_rsc_z      status_saturation[5:4];

HLS_cdp_ocvt u_HLS_cdp_ocvt_3 (
   .nvdla_core_clk      (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)                 //|< i
  ,.chn_data_in_rsc_z   (cdp_cvtout_input_pd_3[49:0])     //|< w
  ,.chn_data_in_rsc_vz  (cdp_cvtout_input_vld_3)          //|< w
  ,.chn_data_in_rsc_lz  (cdp_cvtout_input_rdy_3)          //|> w
  ,.cfg_alu_in_rsc_z    (reg2dp_datout_offset_use[31:0])  //|< r
  ,.cfg_mul_in_rsc_z    (reg2dp_datout_scale_use[15:0])   //|< r
  ,.cfg_truncate_rsc_z  (reg2dp_datout_shifter_use[5:0])  //|< r
  ,.cfg_precision_rsc_z (reg2dp_input_data_type_use[1:0]) //|< r
  ,.chn_data_out_rsc_z  ({status_saturation[7:6],cdp_cvtout_output_pd_3[15:0]}) //|> ?
  ,.chn_data_out_rsc_vz (cdp_cvtout_output_rdy_3)         //|< w
  ,.chn_data_out_rsc_lz (cdp_cvtout_output_vld_3)         //|> w
  );
 //&Connect  status_saturation_rsc_z      status_saturation[7:6];

//sub-unit output ready
assign cdp_cvtout_output_rdy_0 = cdp_cvtout_output_rdy & (cdp_cvtout_output_vld_1 & cdp_cvtout_output_vld_2 & cdp_cvtout_output_vld_3);
assign cdp_cvtout_output_rdy_1 = cdp_cvtout_output_rdy & (cdp_cvtout_output_vld_0 & cdp_cvtout_output_vld_2 & cdp_cvtout_output_vld_3);
assign cdp_cvtout_output_rdy_2 = cdp_cvtout_output_rdy & (cdp_cvtout_output_vld_0 & cdp_cvtout_output_vld_1 & cdp_cvtout_output_vld_3);
assign cdp_cvtout_output_rdy_3 = cdp_cvtout_output_rdy & (cdp_cvtout_output_vld_0 & cdp_cvtout_output_vld_1 & cdp_cvtout_output_vld_2);
//output valid
assign cdp_cvtout_output_vld = cdp_cvtout_output_vld_0 & cdp_cvtout_output_vld_1 & cdp_cvtout_output_vld_2 & cdp_cvtout_output_vld_3;
//output ready
assign cdp_cvtout_output_rdy = cvtout_prdy & data_info_out_vld;
//output data
assign cdp_cvtout_output_pd  = {cdp_cvtout_output_pd_3,cdp_cvtout_output_pd_2,cdp_cvtout_output_pd_1,cdp_cvtout_output_pd_0};
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
//===============================================
//satuation perf logic 
//-----------------------------------------------
assign fp16_en = (reg2dp_input_data_type_use == 2'h2 );
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
  nv_assert_never #(0,0,"CDP ocvt should not output saturation in fp16 mdoe")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, fp16_dout_load & (|status_saturation)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign fp16_dout_load = fp16_en & (cdp_cvtout_output_vld & data_info_out_vld) & cvtout_prdy;
assign fp16_status_saturation[0] = fp16_dout_load & (&{cdp_cvtout_output_pd_0[14:11],cdp_cvtout_output_pd_0[9:0]} & (~cdp_cvtout_output_pd_0[10])); 
assign fp16_status_saturation[1] = fp16_dout_load & (&{cdp_cvtout_output_pd_1[14:11],cdp_cvtout_output_pd_1[9:0]} & (~cdp_cvtout_output_pd_1[10]));
assign fp16_status_saturation[2] = fp16_dout_load & (&{cdp_cvtout_output_pd_2[14:11],cdp_cvtout_output_pd_2[9:0]} & (~cdp_cvtout_output_pd_2[10]));
assign fp16_status_saturation[3] = fp16_dout_load & (&{cdp_cvtout_output_pd_3[14:11],cdp_cvtout_output_pd_3[9:0]} & (~cdp_cvtout_output_pd_3[10]));

assign stat_sat = {4'd0,fp16_status_saturation} | status_saturation[7:0];

function [3:0] fun_bit_sum_8;
  input [7:0] idata;
  reg [3:0] ocnt;
  begin
    ocnt =
        (( idata[0]  
      +  idata[1]  
      +  idata[2] ) 
      + ( idata[3]  
      +  idata[4]  
      +  idata[5] )) 
      + ( idata[6]  
      +  idata[7] ) ;
    fun_bit_sum_8 = ocnt;
  end
endfunction

//assign saturation_ele = fun_bit_sum_8(status_saturation);
assign saturation_ele = fun_bit_sum_8(stat_sat);
assign layer_done = dp2reg_done;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sat_cnt <= {32{1'b0}};
  end else begin
    if(layer_done)
        sat_cnt <= 32'd0;
    else if(mon_sat_cnt_nxt)
        sat_cnt <= 32'hffffffff;
    else
        sat_cnt <= sat_cnt_nxt;
  end
end
assign {mon_sat_cnt_nxt,sat_cnt_nxt[31:0]} = sat_cnt + saturation_ele;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    layer_flag <= 1'b0;
  end else begin
  if ((layer_done) == 1'b1) begin
    layer_flag <= ~layer_flag;
  // VCS coverage off
  end else if ((layer_done) == 1'b0) begin
  end else begin
    layer_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_out_saturation <= {32{1'b0}};
  end else begin
  if ((layer_done & (~layer_flag)) == 1'b1) begin
    dp2reg_d0_out_saturation <= sat_cnt[31:0];
  // VCS coverage off
  end else if ((layer_done & (~layer_flag)) == 1'b0) begin
  end else begin
    dp2reg_d0_out_saturation <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done & (~layer_flag)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_out_saturation <= {32{1'b0}};
  end else begin
  if ((layer_done &   layer_flag ) == 1'b1) begin
    dp2reg_d1_out_saturation <= sat_cnt[31:0];
  // VCS coverage off
  end else if ((layer_done &   layer_flag ) == 1'b0) begin
  end else begin
    dp2reg_d1_out_saturation <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_done &   layer_flag ))); // spyglass disable W504 SelfDeterminedExpr-ML 
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



