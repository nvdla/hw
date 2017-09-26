// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: fp16_4add.v

module fp16_4add (
   fp16_add_in_a     //|< i
  ,fp16_add_in_b     //|< i
  ,fp16_add_in_pvld  //|< i
  ,fp16_add_out_prdy //|< i
  ,nvdla_core_clk    //|< i
  ,nvdla_core_rstn   //|< i
  ,fp16_add_in_prdy  //|> o
  ,fp16_add_out_dp   //|> o
  ,fp16_add_out_pvld //|> o
  );
input  [67:0] fp16_add_in_a;
input  [67:0] fp16_add_in_b;
input         fp16_add_in_pvld;
input         fp16_add_out_prdy;
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        fp16_add_in_prdy;
output [67:0] fp16_add_out_dp;
output        fp16_add_out_pvld;
wire          fp16_add_in0_a_rdy;
wire          fp16_add_in0_a_vld;
wire          fp16_add_in0_b_rdy;
wire          fp16_add_in0_b_vld;
wire          fp16_add_in1_a_rdy;
wire          fp16_add_in1_a_vld;
wire          fp16_add_in1_b_rdy;
wire          fp16_add_in1_b_vld;
wire          fp16_add_in2_a_rdy;
wire          fp16_add_in2_a_vld;
wire          fp16_add_in2_b_rdy;
wire          fp16_add_in2_b_vld;
wire          fp16_add_in3_a_rdy;
wire          fp16_add_in3_a_vld;
wire          fp16_add_in3_b_rdy;
wire          fp16_add_in3_b_vld;
wire   [16:0] fp16_add_out0;
wire          fp16_add_out0_rdy;
wire          fp16_add_out0_vld;
wire   [16:0] fp16_add_out1;
wire          fp16_add_out1_rdy;
wire          fp16_add_out1_vld;
wire   [16:0] fp16_add_out2;
wire          fp16_add_out2_rdy;
wire          fp16_add_out2_vld;
wire   [16:0] fp16_add_out3;
wire          fp16_add_out3_rdy;
wire          fp16_add_out3_vld;
/////////////////////////////////////////////

assign fp16_add_in_prdy = fp16_add_in3_b_rdy & fp16_add_in2_b_rdy & fp16_add_in1_b_rdy & fp16_add_in0_b_rdy
                                & fp16_add_in3_a_rdy & fp16_add_in2_a_rdy & fp16_add_in1_a_rdy & fp16_add_in0_a_rdy ;
assign fp16_add_in0_a_vld = fp16_add_in_pvld & (fp16_add_in0_b_rdy&fp16_add_in1_a_rdy&fp16_add_in1_b_rdy&fp16_add_in2_a_rdy&fp16_add_in2_b_rdy&fp16_add_in3_a_rdy&fp16_add_in3_b_rdy);
assign fp16_add_in1_a_vld = fp16_add_in_pvld & (fp16_add_in0_a_rdy&fp16_add_in0_b_rdy&fp16_add_in1_b_rdy&fp16_add_in2_a_rdy&fp16_add_in2_b_rdy&fp16_add_in3_a_rdy&fp16_add_in3_b_rdy);
assign fp16_add_in2_a_vld = fp16_add_in_pvld & (fp16_add_in0_a_rdy&fp16_add_in0_b_rdy&fp16_add_in1_a_rdy&fp16_add_in1_b_rdy&fp16_add_in2_b_rdy&fp16_add_in3_a_rdy&fp16_add_in3_b_rdy);
assign fp16_add_in3_a_vld = fp16_add_in_pvld & (fp16_add_in0_a_rdy&fp16_add_in0_b_rdy&fp16_add_in1_a_rdy&fp16_add_in1_b_rdy&fp16_add_in2_a_rdy&fp16_add_in2_b_rdy&fp16_add_in3_b_rdy);
assign fp16_add_in0_b_vld = fp16_add_in_pvld & (fp16_add_in0_a_rdy&fp16_add_in1_a_rdy&fp16_add_in1_b_rdy&fp16_add_in2_a_rdy&fp16_add_in2_b_rdy&fp16_add_in3_a_rdy&fp16_add_in3_b_rdy);
assign fp16_add_in1_b_vld = fp16_add_in_pvld & (fp16_add_in0_a_rdy&fp16_add_in0_b_rdy&fp16_add_in1_a_rdy&fp16_add_in2_a_rdy&fp16_add_in2_b_rdy&fp16_add_in3_a_rdy&fp16_add_in3_b_rdy);
assign fp16_add_in2_b_vld = fp16_add_in_pvld & (fp16_add_in0_a_rdy&fp16_add_in0_b_rdy&fp16_add_in1_a_rdy&fp16_add_in1_b_rdy&fp16_add_in2_a_rdy&fp16_add_in3_a_rdy&fp16_add_in3_b_rdy);
assign fp16_add_in3_b_vld = fp16_add_in_pvld & (fp16_add_in0_a_rdy&fp16_add_in0_b_rdy&fp16_add_in1_a_rdy&fp16_add_in1_b_rdy&fp16_add_in2_a_rdy&fp16_add_in2_b_rdy&fp16_add_in3_a_rdy);

HLS_fp17_add u_HLS_fp17_pooling_add_0 (
   .nvdla_core_clk  (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)      //|< i
  ,.chn_a_rsc_z     (fp16_add_in_a[16:0])  //|< i
  ,.chn_a_rsc_vz    (fp16_add_in0_a_vld)   //|< w
  ,.chn_a_rsc_lz    (fp16_add_in0_a_rdy)   //|> w
  ,.chn_b_rsc_z     (fp16_add_in_b[16:0])  //|< i
  ,.chn_b_rsc_vz    (fp16_add_in0_b_vld)   //|< w
  ,.chn_b_rsc_lz    (fp16_add_in0_b_rdy)   //|> w
  ,.chn_o_rsc_z     (fp16_add_out0[16:0])  //|> w
  ,.chn_o_rsc_vz    (fp16_add_out0_rdy)    //|< w
  ,.chn_o_rsc_lz    (fp16_add_out0_vld)    //|> w
  );

HLS_fp17_add u_HLS_fp17_pooling_add_1 (
   .nvdla_core_clk  (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)      //|< i
  ,.chn_a_rsc_z     (fp16_add_in_a[33:17]) //|< i
  ,.chn_a_rsc_vz    (fp16_add_in1_a_vld)   //|< w
  ,.chn_a_rsc_lz    (fp16_add_in1_a_rdy)   //|> w
  ,.chn_b_rsc_z     (fp16_add_in_b[33:17]) //|< i
  ,.chn_b_rsc_vz    (fp16_add_in1_b_vld)   //|< w
  ,.chn_b_rsc_lz    (fp16_add_in1_b_rdy)   //|> w
  ,.chn_o_rsc_z     (fp16_add_out1[16:0])  //|> w
  ,.chn_o_rsc_vz    (fp16_add_out1_rdy)    //|< w
  ,.chn_o_rsc_lz    (fp16_add_out1_vld)    //|> w
  );

HLS_fp17_add u_HLS_fp17_pooling_add_2 (
   .nvdla_core_clk  (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)      //|< i
  ,.chn_a_rsc_z     (fp16_add_in_a[50:34]) //|< i
  ,.chn_a_rsc_vz    (fp16_add_in2_a_vld)   //|< w
  ,.chn_a_rsc_lz    (fp16_add_in2_a_rdy)   //|> w
  ,.chn_b_rsc_z     (fp16_add_in_b[50:34]) //|< i
  ,.chn_b_rsc_vz    (fp16_add_in2_b_vld)   //|< w
  ,.chn_b_rsc_lz    (fp16_add_in2_b_rdy)   //|> w
  ,.chn_o_rsc_z     (fp16_add_out2[16:0])  //|> w
  ,.chn_o_rsc_vz    (fp16_add_out2_rdy)    //|< w
  ,.chn_o_rsc_lz    (fp16_add_out2_vld)    //|> w
  );

HLS_fp17_add u_HLS_fp17_pooling_add_3 (
   .nvdla_core_clk  (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)      //|< i
  ,.chn_a_rsc_z     (fp16_add_in_a[67:51]) //|< i
  ,.chn_a_rsc_vz    (fp16_add_in3_a_vld)   //|< w
  ,.chn_a_rsc_lz    (fp16_add_in3_a_rdy)   //|> w
  ,.chn_b_rsc_z     (fp16_add_in_b[67:51]) //|< i
  ,.chn_b_rsc_vz    (fp16_add_in3_b_vld)   //|< w
  ,.chn_b_rsc_lz    (fp16_add_in3_b_rdy)   //|> w
  ,.chn_o_rsc_z     (fp16_add_out3[16:0])  //|> w
  ,.chn_o_rsc_vz    (fp16_add_out3_rdy)    //|< w
  ,.chn_o_rsc_lz    (fp16_add_out3_vld)    //|> w
  );

assign fp16_add_out0_rdy = fp16_add_out_prdy & (fp16_add_out3_vld & fp16_add_out2_vld & fp16_add_out1_vld);
assign fp16_add_out1_rdy = fp16_add_out_prdy & (fp16_add_out3_vld & fp16_add_out2_vld & fp16_add_out0_vld);
assign fp16_add_out2_rdy = fp16_add_out_prdy & (fp16_add_out3_vld & fp16_add_out1_vld & fp16_add_out0_vld);
assign fp16_add_out3_rdy = fp16_add_out_prdy & (fp16_add_out2_vld & fp16_add_out1_vld & fp16_add_out0_vld);

assign fp16_add_out_pvld = fp16_add_out3_vld & fp16_add_out2_vld & fp16_add_out1_vld & fp16_add_out0_vld;
assign fp16_add_out_dp   = {fp16_add_out3,fp16_add_out2,fp16_add_out1,fp16_add_out0}; 

endmodule // fp16_4add

