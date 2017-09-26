// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cal1d_fp16_pool_sum.v

module cal1d_fp16_pool_sum (
   inp_a_0                 //|< i
  ,inp_a_1                 //|< i
  ,inp_a_2                 //|< i
  ,inp_a_3                 //|< i
  ,inp_b_0                 //|< i
  ,inp_b_1                 //|< i
  ,inp_b_2                 //|< i
  ,inp_b_3                 //|< i
  ,inp_in_pvld             //|< i
  ,inp_out_prdy            //|< i
  ,nvdla_core_rstn         //|< i
  ,nvdla_op_gated_clk_fp16 //|< i
  ,inp_in_prdy             //|> o
  ,inp_out_pvld            //|> o
  ,out_z_0                 //|> o
  ,out_z_1                 //|> o
  ,out_z_2                 //|> o
  ,out_z_3                 //|> o
  );
input  [16:0] inp_a_0;
input  [16:0] inp_a_1;
input  [16:0] inp_a_2;
input  [16:0] inp_a_3;
input  [16:0] inp_b_0;
input  [16:0] inp_b_1;
input  [16:0] inp_b_2;
input  [16:0] inp_b_3;
input         inp_in_pvld;
input         inp_out_prdy;
input         nvdla_core_rstn;
input         nvdla_op_gated_clk_fp16;
output        inp_in_prdy;
output        inp_out_pvld;
output [16:0] out_z_0;
output [16:0] out_z_1;
output [16:0] out_z_2;
output [16:0] out_z_3;
wire    [3:0] inp_a_rdy;
wire    [3:0] inp_a_vld;
wire    [3:0] inp_b_rdy;
wire    [3:0] inp_b_vld;
wire    [3:0] out_z_rdy;
wire    [3:0] out_z_vld;
/////////////////////////////////////////////
assign inp_in_prdy = (&inp_a_rdy) & (&inp_b_rdy);
assign inp_a_vld[0] = inp_in_pvld & (&inp_a_rdy[3:1])                & (&inp_b_rdy[3:0]);
assign inp_a_vld[1] = inp_in_pvld & (&{inp_a_rdy[3:2],inp_a_rdy[0]}) & (&inp_b_rdy[3:0]);
assign inp_a_vld[2] = inp_in_pvld & (&{inp_a_rdy[3],inp_a_rdy[1:0]}) & (&inp_b_rdy[3:0]);
assign inp_a_vld[3] = inp_in_pvld & (&inp_a_rdy[2:0])                & (&inp_b_rdy[3:0]);
assign inp_b_vld[0] = inp_in_pvld & (&inp_b_rdy[3:1])                & (&inp_a_rdy[3:0]);
assign inp_b_vld[1] = inp_in_pvld & (&{inp_b_rdy[3:2],inp_b_rdy[0]}) & (&inp_a_rdy[3:0]);
assign inp_b_vld[2] = inp_in_pvld & (&{inp_b_rdy[3],inp_b_rdy[1:0]}) & (&inp_a_rdy[3:0]);
assign inp_b_vld[3] = inp_in_pvld & (&inp_b_rdy[2:0])                & (&inp_a_rdy[3:0]);

HLS_fp17_add u_cal1d_pool_sum_0 (
   .nvdla_core_clk  (nvdla_op_gated_clk_fp16) //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z     (inp_a_0[16:0])           //|< i
  ,.chn_a_rsc_vz    (inp_a_vld[0])            //|< w
  ,.chn_a_rsc_lz    (inp_a_rdy[0])            //|> w
  ,.chn_b_rsc_z     (inp_b_0[16:0])           //|< i
  ,.chn_b_rsc_vz    (inp_b_vld[0])            //|< w
  ,.chn_b_rsc_lz    (inp_b_rdy[0])            //|> w
  ,.chn_o_rsc_z     (out_z_0[16:0])           //|> o
  ,.chn_o_rsc_vz    (out_z_rdy[0])            //|< w
  ,.chn_o_rsc_lz    (out_z_vld[0])            //|> w
  );
HLS_fp17_add u_cal1d_pool_sum_1 (
   .nvdla_core_clk  (nvdla_op_gated_clk_fp16) //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z     (inp_a_1[16:0])           //|< i
  ,.chn_a_rsc_vz    (inp_a_vld[1])            //|< w
  ,.chn_a_rsc_lz    (inp_a_rdy[1])            //|> w
  ,.chn_b_rsc_z     (inp_b_1[16:0])           //|< i
  ,.chn_b_rsc_vz    (inp_b_vld[1])            //|< w
  ,.chn_b_rsc_lz    (inp_b_rdy[1])            //|> w
  ,.chn_o_rsc_z     (out_z_1[16:0])           //|> o
  ,.chn_o_rsc_vz    (out_z_rdy[1])            //|< w
  ,.chn_o_rsc_lz    (out_z_vld[1])            //|> w
  );
HLS_fp17_add u_cal1d_pool_sum_2 (
   .nvdla_core_clk  (nvdla_op_gated_clk_fp16) //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z     (inp_a_2[16:0])           //|< i
  ,.chn_a_rsc_vz    (inp_a_vld[2])            //|< w
  ,.chn_a_rsc_lz    (inp_a_rdy[2])            //|> w
  ,.chn_b_rsc_z     (inp_b_2[16:0])           //|< i
  ,.chn_b_rsc_vz    (inp_b_vld[2])            //|< w
  ,.chn_b_rsc_lz    (inp_b_rdy[2])            //|> w
  ,.chn_o_rsc_z     (out_z_2[16:0])           //|> o
  ,.chn_o_rsc_vz    (out_z_rdy[2])            //|< w
  ,.chn_o_rsc_lz    (out_z_vld[2])            //|> w
  );
HLS_fp17_add u_cal1d_pool_sum_3 (
   .nvdla_core_clk  (nvdla_op_gated_clk_fp16) //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z     (inp_a_3[16:0])           //|< i
  ,.chn_a_rsc_vz    (inp_a_vld[3])            //|< w
  ,.chn_a_rsc_lz    (inp_a_rdy[3])            //|> w
  ,.chn_b_rsc_z     (inp_b_3[16:0])           //|< i
  ,.chn_b_rsc_vz    (inp_b_vld[3])            //|< w
  ,.chn_b_rsc_lz    (inp_b_rdy[3])            //|> w
  ,.chn_o_rsc_z     (out_z_3[16:0])           //|> o
  ,.chn_o_rsc_vz    (out_z_rdy[3])            //|< w
  ,.chn_o_rsc_lz    (out_z_vld[3])            //|> w
  );
assign inp_out_pvld = &out_z_vld;
assign out_z_rdy[0] = inp_out_prdy & (&out_z_vld[3:1]);
assign out_z_rdy[1] = inp_out_prdy & (&out_z_vld[3:2] & out_z_vld[0]);
assign out_z_rdy[2] = inp_out_prdy & (out_z_vld[3] & (&out_z_vld[1:0]));
assign out_z_rdy[3] = inp_out_prdy & (&out_z_vld[2:0]);

//&Instance fp17_add u_cal1d_pool_sum_0;
// &Connect inp_a        inp_a_0;
// &Connect inp_b        inp_b_0;
// &Connect out_status   out_status_0;
// &Connect out_z        out_z_0;
//
//&Instance fp17_add u_cal1d_pool_sum_1;
// &Connect inp_a        inp_a_1;
// &Connect inp_b        inp_b_1;
// &Connect out_status   out_status_1;
// &Connect out_z        out_z_1;
//
//&Instance fp17_add u_cal1d_pool_sum_2;
// &Connect inp_a        inp_a_2;
// &Connect inp_b        inp_b_2;
// &Connect out_status   out_status_2;
// &Connect out_z        out_z_2;
//
//&Instance fp17_add u_cal1d_pool_sum_3;
// &Connect inp_a        inp_a_3;
// &Connect inp_b        inp_b_3;
// &Connect out_status   out_status_3;
// &Connect out_z        out_z_3;

endmodule // cal1d_fp16_pool_sum

