// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: fp_sum_block.v

module fp_sum_block (
   fp16_dout_0        //|< i
  ,fp16_dout_1        //|< i
  ,fp16_dout_2        //|< i
  ,fp16_dout_3        //|< i
  ,fp16_dout_4        //|< i
  ,fp16_dout_5        //|< i
  ,fp16_dout_6        //|< i
  ,fp16_dout_7        //|< i
  ,fp16_dout_8        //|< i
  ,fp16_sum_rdy       //|< i
  ,fp_sq_out_vld      //|< i
  ,len3               //|< i
  ,len5               //|< i
  ,len7               //|< i
  ,len9               //|< i
  ,nvdla_core_clk     //|< i
  ,nvdla_core_rstn    //|< i
  ,reg2dp_normalz_len //|< i
  ,fp16_sum           //|> o
  ,fp16_sum_vld       //|> o
  ,fp_sq_out_rdy      //|> o
  );
input  [31:0] fp16_dout_0;
input  [31:0] fp16_dout_1;
input  [31:0] fp16_dout_2;
input  [31:0] fp16_dout_3;
input  [31:0] fp16_dout_4;
input  [31:0] fp16_dout_5;
input  [31:0] fp16_dout_6;
input  [31:0] fp16_dout_7;
input  [31:0] fp16_dout_8;
input         fp16_sum_rdy;
input         fp_sq_out_vld;
input         len3;
input         len5;
input         len7;
input         len9;
input         nvdla_core_clk;
input         nvdla_core_rstn;
input   [1:0] reg2dp_normalz_len;
output [31:0] fp16_sum;
output        fp16_sum_vld;
output        fp_sq_out_rdy;
reg    [31:0] fp16_sum;
reg           fp16_sum_vld;
wire   [31:0] fp16_dout_4_in_pd;
wire   [31:0] fp16_dout_4_in_pd_d0;
wire   [31:0] fp16_dout_4_in_pd_d1;
wire   [31:0] fp16_dout_4_in_pd_d2;
wire   [31:0] fp16_dout_4_in_pd_d3;
wire   [31:0] fp16_dout_4_in_pd_d4;
wire          fp16_dout_4_in_rdy;
wire          fp16_dout_4_in_rdy_d0;
wire          fp16_dout_4_in_rdy_d1;
wire          fp16_dout_4_in_rdy_d2;
wire          fp16_dout_4_in_rdy_d3;
wire          fp16_dout_4_in_rdy_d4;
wire          fp16_dout_4_in_vld;
wire          fp16_dout_4_in_vld_d0;
wire          fp16_dout_4_in_vld_d1;
wire          fp16_dout_4_in_vld_d2;
wire          fp16_dout_4_in_vld_d3;
wire          fp16_dout_4_in_vld_d4;
wire   [31:0] fp16_dout_4_out_pd;
wire          fp16_dout_4_out_rdy;
wire          fp16_dout_4_out_vld;
wire   [31:0] fp16_sum3;
wire          fp16_sum35_rdy;
wire          fp16_sum35_vld;
wire          fp16_sum3_rdy;
wire          fp16_sum3_vld;
wire          fp16_sum4_rdy;
wire          fp16_sum4_vld;
wire   [31:0] fp16_sum5;
wire          fp16_sum5_rdy;
wire          fp16_sum5_vld;
wire   [31:0] fp16_sum7;
wire          fp16_sum7_rdy;
wire          fp16_sum7_vld;
wire   [31:0] fp16_sum9;
wire          fp16_sum9_rdy;
wire          fp16_sum9_vld;
wire   [31:0] fp16_sum_0_8;
wire          fp16_sum_0_8_rdy;
wire          fp16_sum_0_8_vld;
wire   [31:0] fp16_sum_1_7;
wire          fp16_sum_1_7_rdy;
wire          fp16_sum_1_7_vld;
wire   [31:0] fp16_sum_2_6;
wire          fp16_sum_2_6_rdy;
wire          fp16_sum_2_6_vld;
wire   [31:0] fp16_sum_3_5;
wire          fp16_sum_3_5_rdy;
wire          fp16_sum_3_5_vld;
wire          fp16_sum_stage0_rdy;
wire          fp16_sum_stage0_vld;
wire          fp16_sum_stage1_rdy;
wire          fp16_sum_stage1_vld;
wire          fp16_sum_stage2_rdy;
wire          fp16_sum_stage2_vld;
wire          fp16_sum_stage3_rdy;
wire          fp16_sum_stage3_vld;
wire    [8:0] fp_sq_vld;
wire    [8:0] fp_sum_in_rdy;
wire   [95:0] stage1_pipe_in_pd;
wire   [95:0] stage1_pipe_in_pd_d0;
wire   [95:0] stage1_pipe_in_pd_d1;
wire   [95:0] stage1_pipe_in_pd_d2;
wire   [95:0] stage1_pipe_in_pd_d3;
wire   [95:0] stage1_pipe_in_pd_d4;
wire          stage1_pipe_in_rdy;
wire          stage1_pipe_in_rdy_d0;
wire          stage1_pipe_in_rdy_d1;
wire          stage1_pipe_in_rdy_d2;
wire          stage1_pipe_in_rdy_d3;
wire          stage1_pipe_in_rdy_d4;
wire          stage1_pipe_in_vld;
wire          stage1_pipe_in_vld_d0;
wire          stage1_pipe_in_vld_d1;
wire          stage1_pipe_in_vld_d2;
wire          stage1_pipe_in_vld_d3;
wire          stage1_pipe_in_vld_d4;
wire   [95:0] stage1_pipe_out_pd;
wire          stage1_pipe_out_rdy;
wire          stage1_pipe_out_vld;
wire   [63:0] stage2_pipe_in_pd;
wire   [63:0] stage2_pipe_in_pd_d0;
wire   [63:0] stage2_pipe_in_pd_d1;
wire   [63:0] stage2_pipe_in_pd_d2;
wire   [63:0] stage2_pipe_in_pd_d3;
wire   [63:0] stage2_pipe_in_pd_d4;
wire          stage2_pipe_in_rdy;
wire          stage2_pipe_in_rdy_d0;
wire          stage2_pipe_in_rdy_d1;
wire          stage2_pipe_in_rdy_d2;
wire          stage2_pipe_in_rdy_d3;
wire          stage2_pipe_in_rdy_d4;
wire          stage2_pipe_in_vld;
wire          stage2_pipe_in_vld_d0;
wire          stage2_pipe_in_vld_d1;
wire          stage2_pipe_in_vld_d2;
wire          stage2_pipe_in_vld_d3;
wire          stage2_pipe_in_vld_d4;
wire   [63:0] stage2_pipe_out_pd;
wire          stage2_pipe_out_rdy;
wire          stage2_pipe_out_vld;
wire          stage2_sum26_rdy;
wire          stage2_sum26_vld;
wire          stage2_sum3_rdy;
wire          stage2_sum3_vld;
wire   [31:0] stage3_pipe_in_pd;
wire   [31:0] stage3_pipe_in_pd_d0;
wire   [31:0] stage3_pipe_in_pd_d1;
wire   [31:0] stage3_pipe_in_pd_d2;
wire   [31:0] stage3_pipe_in_pd_d3;
wire   [31:0] stage3_pipe_in_pd_d4;
wire          stage3_pipe_in_rdy;
wire          stage3_pipe_in_rdy_d0;
wire          stage3_pipe_in_rdy_d1;
wire          stage3_pipe_in_rdy_d2;
wire          stage3_pipe_in_rdy_d3;
wire          stage3_pipe_in_rdy_d4;
wire          stage3_pipe_in_vld;
wire          stage3_pipe_in_vld_d0;
wire          stage3_pipe_in_vld_d1;
wire          stage3_pipe_in_vld_d2;
wire          stage3_pipe_in_vld_d3;
wire          stage3_pipe_in_vld_d4;
wire   [31:0] stage3_pipe_out_pd;
wire          stage3_pipe_out_rdy;
wire          stage3_pipe_out_vld;
wire          stage3_sum17_rdy;
wire          stage3_sum17_vld;
wire          stage3_sum5_rdy;
wire          stage3_sum5_vld;
wire          stage4_sum08_rdy;
wire          stage4_sum08_vld;
wire          stage4_sum7_rdy;
wire          stage4_sum7_vld;
///////////////////////////////////
//assign len3_en = (reg2dp_normalz_len == NVDLA_CDP_D_LRN_CFG_0_NORMALZ_LEN_LEN3);
//assign len5_en = (reg2dp_normalz_len == NVDLA_CDP_D_LRN_CFG_0_NORMALZ_LEN_LEN5);
//assign len7_en = (reg2dp_normalz_len == NVDLA_CDP_D_LRN_CFG_0_NORMALZ_LEN_LEN7);
//assign len9_en = (reg2dp_normalz_len == NVDLA_CDP_D_LRN_CFG_0_NORMALZ_LEN_LEN9);
///////////////////////////////////
assign fp_sq_out_rdy = &fp_sum_in_rdy[8:0];

assign fp_sq_vld[0] = (len9)               ? (fp_sq_out_vld & (&fp_sum_in_rdy[8:1])                        ) : 1'b0;
assign fp_sq_vld[1] = (len7 | len9)        ? (fp_sq_out_vld & (&fp_sum_in_rdy[8:2]) & ( fp_sum_in_rdy[  0])) : 1'b0;
assign fp_sq_vld[2] = (len5 | len7 | len9) ? (fp_sq_out_vld & (&fp_sum_in_rdy[8:3]) & (&fp_sum_in_rdy[1:0])) : 1'b0;
assign fp_sq_vld[3] =                        (fp_sq_out_vld & (&fp_sum_in_rdy[8:4]) & (&fp_sum_in_rdy[2:0]));
assign fp_sq_vld[4] =                        (fp_sq_out_vld & (&fp_sum_in_rdy[8:5]) & (&fp_sum_in_rdy[3:0]));
assign fp_sq_vld[5] =                        (fp_sq_out_vld & (&fp_sum_in_rdy[8:6]) & (&fp_sum_in_rdy[4:0]));
assign fp_sq_vld[6] = (len5 | len7 | len9) ? (fp_sq_out_vld & (&fp_sum_in_rdy[8:7]) & (&fp_sum_in_rdy[5:0])) : 1'b0;
assign fp_sq_vld[7] = (len7 | len9)        ? (fp_sq_out_vld & (&fp_sum_in_rdy[8  ]) & (&fp_sum_in_rdy[6:0])) : 1'b0;
assign fp_sq_vld[8] = (len9)               ? (fp_sq_out_vld &                         (&fp_sum_in_rdy[7:0])) : 1'b0;
///////////////////////////////////
HLS_fp32_add u_HLS_fp32_add_3_5 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.chn_a_rsc_z           (fp16_dout_3[31:0])          //|< i
  ,.chn_a_rsc_vz          (fp_sq_vld[3])               //|< w
  ,.chn_a_rsc_lz          (fp_sum_in_rdy[3])           //|> w
  ,.chn_b_rsc_z           (fp16_dout_5[31:0])          //|< i
  ,.chn_b_rsc_vz          (fp_sq_vld[5])               //|< w
  ,.chn_b_rsc_lz          (fp_sum_in_rdy[5])           //|> w
  ,.chn_o_rsc_z           (fp16_sum_3_5[31:0])         //|> w
  ,.chn_o_rsc_vz          (fp16_sum_3_5_rdy)           //|< w
  ,.chn_o_rsc_lz          (fp16_sum_3_5_vld)           //|> w
  );

HLS_fp32_add u_HLS_fp32_add_2_6 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.chn_a_rsc_z           (fp16_dout_2[31:0])          //|< i
  ,.chn_a_rsc_vz          (fp_sq_vld[2])               //|< w
  ,.chn_a_rsc_lz          (fp_sum_in_rdy[2])           //|> w
  ,.chn_b_rsc_z           (fp16_dout_6[31:0])          //|< i
  ,.chn_b_rsc_vz          (fp_sq_vld[6])               //|< w
  ,.chn_b_rsc_lz          (fp_sum_in_rdy[6])           //|> w
  ,.chn_o_rsc_z           (fp16_sum_2_6[31:0])         //|> w
  ,.chn_o_rsc_vz          (fp16_sum_2_6_rdy)           //|< w
  ,.chn_o_rsc_lz          (fp16_sum_2_6_vld)           //|> w
  );

HLS_fp32_add u_HLS_fp32_add_1_7 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.chn_a_rsc_z           (fp16_dout_1[31:0])          //|< i
  ,.chn_a_rsc_vz          (fp_sq_vld[1])               //|< w
  ,.chn_a_rsc_lz          (fp_sum_in_rdy[1])           //|> w
  ,.chn_b_rsc_z           (fp16_dout_7[31:0])          //|< i
  ,.chn_b_rsc_vz          (fp_sq_vld[7])               //|< w
  ,.chn_b_rsc_lz          (fp_sum_in_rdy[7])           //|> w
  ,.chn_o_rsc_z           (fp16_sum_1_7[31:0])         //|> w
  ,.chn_o_rsc_vz          (fp16_sum_1_7_rdy)           //|< w
  ,.chn_o_rsc_lz          (fp16_sum_1_7_vld)           //|> w
  );

HLS_fp32_add u_HLS_fp32_add_0_8 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.chn_a_rsc_z           (fp16_dout_0[31:0])          //|< i
  ,.chn_a_rsc_vz          (fp_sq_vld[0])               //|< w
  ,.chn_a_rsc_lz          (fp_sum_in_rdy[0])           //|> w
  ,.chn_b_rsc_z           (fp16_dout_8[31:0])          //|< i
  ,.chn_b_rsc_vz          (fp_sq_vld[8])               //|< w
  ,.chn_b_rsc_lz          (fp_sum_in_rdy[8])           //|> w
  ,.chn_o_rsc_z           (fp16_sum_0_8[31:0])         //|> w
  ,.chn_o_rsc_vz          (fp16_sum_0_8_rdy)           //|< w
  ,.chn_o_rsc_lz          (fp16_sum_0_8_vld)           //|> w
  );

//assign fp16_sum_3_5_rdy = fp16_sum_stage0_rdy & fp16_sum_2_6_vld & fp16_sum_1_7_vld & fp16_sum_0_8_vld & fp16_dout_4_out_vld;
//assign fp16_sum_2_6_rdy = fp16_sum_stage0_rdy & fp16_sum_3_5_vld & fp16_sum_1_7_vld & fp16_sum_0_8_vld & fp16_dout_4_out_vld;
//assign fp16_sum_1_7_rdy = fp16_sum_stage0_rdy & fp16_sum_3_5_vld & fp16_sum_2_6_vld & fp16_sum_0_8_vld & fp16_dout_4_out_vld;
//assign fp16_sum_0_8_rdy = fp16_sum_stage0_rdy & fp16_sum_3_5_vld & fp16_sum_2_6_vld & fp16_sum_1_7_vld & fp16_dout_4_out_vld;

assign fp16_sum_3_5_rdy = fp16_sum_stage0_rdy &                    (len3 ? 1'b1 : fp16_sum_2_6_vld) & ((len7 | len9) ? fp16_sum_1_7_vld : 1'b1) & (len9 ? fp16_sum_0_8_vld : 1'b1) & fp16_dout_4_out_vld;
assign fp16_sum_2_6_rdy = fp16_sum_stage0_rdy & fp16_sum_3_5_vld &                                    ((len7 | len9) ? fp16_sum_1_7_vld : 1'b1) & (len9 ? fp16_sum_0_8_vld : 1'b1) & fp16_dout_4_out_vld;
assign fp16_sum_1_7_rdy = fp16_sum_stage0_rdy & fp16_sum_3_5_vld & (len3 ? 1'b1 : fp16_sum_2_6_vld) &                                             (len9 ? fp16_sum_0_8_vld : 1'b1) & fp16_dout_4_out_vld;
assign fp16_sum_0_8_rdy = fp16_sum_stage0_rdy & fp16_sum_3_5_vld & (len3 ? 1'b1 : fp16_sum_2_6_vld) & ((len7 | len9) ? fp16_sum_1_7_vld : 1'b1) & fp16_dout_4_out_vld;
//fp16_dout_4 sync process
assign fp16_dout_4_in_pd = fp16_dout_4[31:0];
assign fp16_dout_4_in_vld = fp_sq_vld[4];
assign fp_sum_in_rdy[4] = fp16_dout_4_in_rdy;

assign fp16_dout_4_in_vld_d0 = fp16_dout_4_in_vld;
assign fp16_dout_4_in_rdy = fp16_dout_4_in_rdy_d0;
assign fp16_dout_4_in_pd_d0[31:0] = fp16_dout_4_in_pd[31:0];
FP_SUM_BLOCK_pipe_p1 pipe_p1 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.fp16_dout_4_in_pd_d0  (fp16_dout_4_in_pd_d0[31:0]) //|< w
  ,.fp16_dout_4_in_rdy_d1 (fp16_dout_4_in_rdy_d1)      //|< w
  ,.fp16_dout_4_in_vld_d0 (fp16_dout_4_in_vld_d0)      //|< w
  ,.fp16_dout_4_in_pd_d1  (fp16_dout_4_in_pd_d1[31:0]) //|> w
  ,.fp16_dout_4_in_rdy_d0 (fp16_dout_4_in_rdy_d0)      //|> w
  ,.fp16_dout_4_in_vld_d1 (fp16_dout_4_in_vld_d1)      //|> w
  );
FP_SUM_BLOCK_pipe_p2 pipe_p2 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.fp16_dout_4_in_pd_d1  (fp16_dout_4_in_pd_d1[31:0]) //|< w
  ,.fp16_dout_4_in_rdy_d2 (fp16_dout_4_in_rdy_d2)      //|< w
  ,.fp16_dout_4_in_vld_d1 (fp16_dout_4_in_vld_d1)      //|< w
  ,.fp16_dout_4_in_pd_d2  (fp16_dout_4_in_pd_d2[31:0]) //|> w
  ,.fp16_dout_4_in_rdy_d1 (fp16_dout_4_in_rdy_d1)      //|> w
  ,.fp16_dout_4_in_vld_d2 (fp16_dout_4_in_vld_d2)      //|> w
  );
FP_SUM_BLOCK_pipe_p3 pipe_p3 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.fp16_dout_4_in_pd_d2  (fp16_dout_4_in_pd_d2[31:0]) //|< w
  ,.fp16_dout_4_in_rdy_d3 (fp16_dout_4_in_rdy_d3)      //|< w
  ,.fp16_dout_4_in_vld_d2 (fp16_dout_4_in_vld_d2)      //|< w
  ,.fp16_dout_4_in_pd_d3  (fp16_dout_4_in_pd_d3[31:0]) //|> w
  ,.fp16_dout_4_in_rdy_d2 (fp16_dout_4_in_rdy_d2)      //|> w
  ,.fp16_dout_4_in_vld_d3 (fp16_dout_4_in_vld_d3)      //|> w
  );
FP_SUM_BLOCK_pipe_p4 pipe_p4 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.fp16_dout_4_in_pd_d3  (fp16_dout_4_in_pd_d3[31:0]) //|< w
  ,.fp16_dout_4_in_rdy_d4 (fp16_dout_4_in_rdy_d4)      //|< w
  ,.fp16_dout_4_in_vld_d3 (fp16_dout_4_in_vld_d3)      //|< w
  ,.fp16_dout_4_in_pd_d4  (fp16_dout_4_in_pd_d4[31:0]) //|> w
  ,.fp16_dout_4_in_rdy_d3 (fp16_dout_4_in_rdy_d3)      //|> w
  ,.fp16_dout_4_in_vld_d4 (fp16_dout_4_in_vld_d4)      //|> w
  );
assign fp16_dout_4_out_vld = fp16_dout_4_in_vld_d4;
assign fp16_dout_4_in_rdy_d4 = fp16_dout_4_out_rdy;
assign fp16_dout_4_out_pd[31:0] = fp16_dout_4_in_pd_d4[31:0];

assign fp16_dout_4_out_rdy = fp16_sum_stage0_rdy & fp16_sum_3_5_vld & (len3 ? 1'b1 : fp16_sum_2_6_vld) & ((len7 | len9) ? fp16_sum_1_7_vld : 1'b1) & (len9 ? fp16_sum_0_8_vld : 1'b1);
//sum stage0 output valid
assign fp16_sum_stage0_vld = fp16_sum_3_5_vld & (len3 ? 1'b1 : fp16_sum_2_6_vld) & ((len7 | len9) ? fp16_sum_1_7_vld : 1'b1) & (len9 ? fp16_sum_0_8_vld : 1'b1) & fp16_dout_4_out_vld;
///////////////////////////////////
assign fp16_sum_stage0_rdy = len3 ? (fp16_sum35_rdy & fp16_sum4_rdy) : (fp16_sum35_rdy & fp16_sum4_rdy & stage1_pipe_in_rdy);

assign fp16_sum35_vld = len3 ? (fp16_sum_stage0_vld & fp16_sum4_rdy)  : (fp16_sum_stage0_vld & fp16_sum4_rdy & stage1_pipe_in_rdy);
assign fp16_sum4_vld  = len3 ? (fp16_sum_stage0_vld & fp16_sum35_rdy) : (fp16_sum_stage0_vld & fp16_sum35_rdy & stage1_pipe_in_rdy);
assign stage1_pipe_in_vld = (len5 | len7 | len9)? (fp16_sum_stage0_vld & fp16_sum35_rdy & fp16_sum4_rdy) : 1'b0;

HLS_fp32_add u_HLS_fp32_add_sum3 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.chn_a_rsc_z           (fp16_sum_3_5[31:0])         //|< w
  ,.chn_a_rsc_vz          (fp16_sum35_vld)             //|< w
  ,.chn_a_rsc_lz          (fp16_sum35_rdy)             //|> w
  ,.chn_b_rsc_z           (fp16_dout_4_out_pd[31:0])   //|< w
  ,.chn_b_rsc_vz          (fp16_sum4_vld)              //|< w
  ,.chn_b_rsc_lz          (fp16_sum4_rdy)              //|> w
  ,.chn_o_rsc_z           (fp16_sum3[31:0])            //|> w
  ,.chn_o_rsc_vz          (fp16_sum3_rdy)              //|< w
  ,.chn_o_rsc_lz          (fp16_sum3_vld)              //|> w
  );

assign fp16_sum3_rdy = len3 ? fp16_sum_rdy : (fp16_sum_stage1_rdy & stage1_pipe_out_vld);
assign stage1_pipe_out_rdy = len3 ? 1'b1 : (fp16_sum_stage1_rdy & fp16_sum3_vld);

assign stage1_pipe_in_pd = {fp16_sum_2_6,fp16_sum_1_7,fp16_sum_0_8};

assign stage1_pipe_in_vld_d0 = stage1_pipe_in_vld;
assign stage1_pipe_in_rdy = stage1_pipe_in_rdy_d0;
assign stage1_pipe_in_pd_d0[95:0] = stage1_pipe_in_pd[95:0];
FP_SUM_BLOCK_pipe_p5 pipe_p5 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage1_pipe_in_pd_d0  (stage1_pipe_in_pd_d0[95:0]) //|< w
  ,.stage1_pipe_in_rdy_d1 (stage1_pipe_in_rdy_d1)      //|< w
  ,.stage1_pipe_in_vld_d0 (stage1_pipe_in_vld_d0)      //|< w
  ,.stage1_pipe_in_pd_d1  (stage1_pipe_in_pd_d1[95:0]) //|> w
  ,.stage1_pipe_in_rdy_d0 (stage1_pipe_in_rdy_d0)      //|> w
  ,.stage1_pipe_in_vld_d1 (stage1_pipe_in_vld_d1)      //|> w
  );
FP_SUM_BLOCK_pipe_p6 pipe_p6 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage1_pipe_in_pd_d1  (stage1_pipe_in_pd_d1[95:0]) //|< w
  ,.stage1_pipe_in_rdy_d2 (stage1_pipe_in_rdy_d2)      //|< w
  ,.stage1_pipe_in_vld_d1 (stage1_pipe_in_vld_d1)      //|< w
  ,.stage1_pipe_in_pd_d2  (stage1_pipe_in_pd_d2[95:0]) //|> w
  ,.stage1_pipe_in_rdy_d1 (stage1_pipe_in_rdy_d1)      //|> w
  ,.stage1_pipe_in_vld_d2 (stage1_pipe_in_vld_d2)      //|> w
  );
FP_SUM_BLOCK_pipe_p7 pipe_p7 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage1_pipe_in_pd_d2  (stage1_pipe_in_pd_d2[95:0]) //|< w
  ,.stage1_pipe_in_rdy_d3 (stage1_pipe_in_rdy_d3)      //|< w
  ,.stage1_pipe_in_vld_d2 (stage1_pipe_in_vld_d2)      //|< w
  ,.stage1_pipe_in_pd_d3  (stage1_pipe_in_pd_d3[95:0]) //|> w
  ,.stage1_pipe_in_rdy_d2 (stage1_pipe_in_rdy_d2)      //|> w
  ,.stage1_pipe_in_vld_d3 (stage1_pipe_in_vld_d3)      //|> w
  );
FP_SUM_BLOCK_pipe_p8 pipe_p8 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage1_pipe_in_pd_d3  (stage1_pipe_in_pd_d3[95:0]) //|< w
  ,.stage1_pipe_in_rdy_d4 (stage1_pipe_in_rdy_d4)      //|< w
  ,.stage1_pipe_in_vld_d3 (stage1_pipe_in_vld_d3)      //|< w
  ,.stage1_pipe_in_pd_d4  (stage1_pipe_in_pd_d4[95:0]) //|> w
  ,.stage1_pipe_in_rdy_d3 (stage1_pipe_in_rdy_d3)      //|> w
  ,.stage1_pipe_in_vld_d4 (stage1_pipe_in_vld_d4)      //|> w
  );
assign stage1_pipe_out_vld = stage1_pipe_in_vld_d4;
assign stage1_pipe_in_rdy_d4 = stage1_pipe_out_rdy;
assign stage1_pipe_out_pd[95:0] = stage1_pipe_in_pd_d4[95:0];


assign fp16_sum_stage1_vld = len3 ? 1'b0 : (fp16_sum3_vld & stage1_pipe_out_vld);
//////////////////////////////////////
assign fp16_sum_stage1_rdy = (len7 | len9) ? (stage2_sum3_rdy & stage2_sum26_rdy & stage2_pipe_in_rdy) : (stage2_sum3_rdy & stage2_sum26_rdy);

assign stage2_sum3_vld = (len7 | len9) ? (fp16_sum_stage1_vld & stage2_sum26_rdy & stage2_pipe_in_rdy) : (fp16_sum_stage1_vld & stage2_sum26_rdy);
assign stage2_sum26_vld  = (len7 | len9) ? (fp16_sum_stage1_vld & stage2_sum3_rdy & stage2_pipe_in_rdy) : (fp16_sum_stage1_vld & stage2_sum3_rdy);
assign stage2_pipe_in_vld = (len7 | len9)? (fp16_sum_stage1_vld & stage2_sum26_rdy & stage2_sum3_rdy) : 1'b0;

HLS_fp32_add u_HLS_fp32_add_sum5 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.chn_a_rsc_z           (fp16_sum3[31:0])            //|< w
  ,.chn_a_rsc_vz          (stage2_sum3_vld)            //|< w
  ,.chn_a_rsc_lz          (stage2_sum3_rdy)            //|> w
  ,.chn_b_rsc_z           (stage1_pipe_out_pd[95:64])  //|< w
  ,.chn_b_rsc_vz          (stage2_sum26_vld)           //|< w
  ,.chn_b_rsc_lz          (stage2_sum26_rdy)           //|> w
  ,.chn_o_rsc_z           (fp16_sum5[31:0])            //|> w
  ,.chn_o_rsc_vz          (fp16_sum5_rdy)              //|< w
  ,.chn_o_rsc_lz          (fp16_sum5_vld)              //|> w
  );
//fp16_sum_2_6     ;

assign fp16_sum5_rdy = len5 ? fp16_sum_rdy : (fp16_sum_stage2_rdy & stage2_pipe_out_vld);
assign stage2_pipe_out_rdy = (len7 | len9) ? (fp16_sum_stage2_rdy & fp16_sum5_vld) : 1'b1;

assign stage2_pipe_in_pd = stage1_pipe_out_pd[63:0];//{fp16_sum_1_7,fp16_sum_0_8};

assign stage2_pipe_in_vld_d0 = stage2_pipe_in_vld;
assign stage2_pipe_in_rdy = stage2_pipe_in_rdy_d0;
assign stage2_pipe_in_pd_d0[63:0] = stage2_pipe_in_pd[63:0];
FP_SUM_BLOCK_pipe_p9 pipe_p9 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage2_pipe_in_pd_d0  (stage2_pipe_in_pd_d0[63:0]) //|< w
  ,.stage2_pipe_in_rdy_d1 (stage2_pipe_in_rdy_d1)      //|< w
  ,.stage2_pipe_in_vld_d0 (stage2_pipe_in_vld_d0)      //|< w
  ,.stage2_pipe_in_pd_d1  (stage2_pipe_in_pd_d1[63:0]) //|> w
  ,.stage2_pipe_in_rdy_d0 (stage2_pipe_in_rdy_d0)      //|> w
  ,.stage2_pipe_in_vld_d1 (stage2_pipe_in_vld_d1)      //|> w
  );
FP_SUM_BLOCK_pipe_p10 pipe_p10 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage2_pipe_in_pd_d1  (stage2_pipe_in_pd_d1[63:0]) //|< w
  ,.stage2_pipe_in_rdy_d2 (stage2_pipe_in_rdy_d2)      //|< w
  ,.stage2_pipe_in_vld_d1 (stage2_pipe_in_vld_d1)      //|< w
  ,.stage2_pipe_in_pd_d2  (stage2_pipe_in_pd_d2[63:0]) //|> w
  ,.stage2_pipe_in_rdy_d1 (stage2_pipe_in_rdy_d1)      //|> w
  ,.stage2_pipe_in_vld_d2 (stage2_pipe_in_vld_d2)      //|> w
  );
FP_SUM_BLOCK_pipe_p11 pipe_p11 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage2_pipe_in_pd_d2  (stage2_pipe_in_pd_d2[63:0]) //|< w
  ,.stage2_pipe_in_rdy_d3 (stage2_pipe_in_rdy_d3)      //|< w
  ,.stage2_pipe_in_vld_d2 (stage2_pipe_in_vld_d2)      //|< w
  ,.stage2_pipe_in_pd_d3  (stage2_pipe_in_pd_d3[63:0]) //|> w
  ,.stage2_pipe_in_rdy_d2 (stage2_pipe_in_rdy_d2)      //|> w
  ,.stage2_pipe_in_vld_d3 (stage2_pipe_in_vld_d3)      //|> w
  );
FP_SUM_BLOCK_pipe_p12 pipe_p12 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage2_pipe_in_pd_d3  (stage2_pipe_in_pd_d3[63:0]) //|< w
  ,.stage2_pipe_in_rdy_d4 (stage2_pipe_in_rdy_d4)      //|< w
  ,.stage2_pipe_in_vld_d3 (stage2_pipe_in_vld_d3)      //|< w
  ,.stage2_pipe_in_pd_d4  (stage2_pipe_in_pd_d4[63:0]) //|> w
  ,.stage2_pipe_in_rdy_d3 (stage2_pipe_in_rdy_d3)      //|> w
  ,.stage2_pipe_in_vld_d4 (stage2_pipe_in_vld_d4)      //|> w
  );
assign stage2_pipe_out_vld = stage2_pipe_in_vld_d4;
assign stage2_pipe_in_rdy_d4 = stage2_pipe_out_rdy;
assign stage2_pipe_out_pd[63:0] = stage2_pipe_in_pd_d4[63:0];


assign fp16_sum_stage2_vld = (len3 | len5) ? 1'b0 : (fp16_sum5_vld & stage2_pipe_out_vld);
//////////////////////////////////////
assign fp16_sum_stage2_rdy = len9 ? (stage3_sum5_rdy & stage3_sum17_rdy & stage3_pipe_in_rdy) : (stage3_sum5_rdy & stage3_sum17_rdy);

assign stage3_sum5_vld = len9 ? (fp16_sum_stage2_vld & stage3_sum17_rdy & stage3_pipe_in_rdy) : (fp16_sum_stage2_vld & stage3_sum17_rdy);
assign stage3_sum17_vld  = len9 ? (fp16_sum_stage2_vld & stage3_sum5_rdy & stage3_pipe_in_rdy) : (fp16_sum_stage2_vld & stage3_sum5_rdy);
assign stage3_pipe_in_vld = len9 ? (fp16_sum_stage2_vld & stage3_sum17_rdy & stage3_sum5_rdy) : 1'b0;

HLS_fp32_add u_HLS_fp32_add_sum7 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.chn_a_rsc_z           (fp16_sum5[31:0])            //|< w
  ,.chn_a_rsc_vz          (stage3_sum5_vld)            //|< w
  ,.chn_a_rsc_lz          (stage3_sum5_rdy)            //|> w
  ,.chn_b_rsc_z           (stage2_pipe_out_pd[63:32])  //|< w
  ,.chn_b_rsc_vz          (stage3_sum17_vld)           //|< w
  ,.chn_b_rsc_lz          (stage3_sum17_rdy)           //|> w
  ,.chn_o_rsc_z           (fp16_sum7[31:0])            //|> w
  ,.chn_o_rsc_vz          (fp16_sum7_rdy)              //|< w
  ,.chn_o_rsc_lz          (fp16_sum7_vld)              //|> w
  );
//fp16_sum_1_7     ;

assign fp16_sum7_rdy = len7 ? fp16_sum_rdy : (fp16_sum_stage3_rdy & stage3_pipe_out_vld);
assign stage3_pipe_out_rdy = len9 ? (fp16_sum_stage3_rdy & fp16_sum7_vld) : 1'b1;

assign stage3_pipe_in_pd = stage2_pipe_out_pd[31:0];

assign stage3_pipe_in_vld_d0 = stage3_pipe_in_vld;
assign stage3_pipe_in_rdy = stage3_pipe_in_rdy_d0;
assign stage3_pipe_in_pd_d0[31:0] = stage3_pipe_in_pd[31:0];
FP_SUM_BLOCK_pipe_p13 pipe_p13 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage3_pipe_in_pd_d0  (stage3_pipe_in_pd_d0[31:0]) //|< w
  ,.stage3_pipe_in_rdy_d1 (stage3_pipe_in_rdy_d1)      //|< w
  ,.stage3_pipe_in_vld_d0 (stage3_pipe_in_vld_d0)      //|< w
  ,.stage3_pipe_in_pd_d1  (stage3_pipe_in_pd_d1[31:0]) //|> w
  ,.stage3_pipe_in_rdy_d0 (stage3_pipe_in_rdy_d0)      //|> w
  ,.stage3_pipe_in_vld_d1 (stage3_pipe_in_vld_d1)      //|> w
  );
FP_SUM_BLOCK_pipe_p14 pipe_p14 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage3_pipe_in_pd_d1  (stage3_pipe_in_pd_d1[31:0]) //|< w
  ,.stage3_pipe_in_rdy_d2 (stage3_pipe_in_rdy_d2)      //|< w
  ,.stage3_pipe_in_vld_d1 (stage3_pipe_in_vld_d1)      //|< w
  ,.stage3_pipe_in_pd_d2  (stage3_pipe_in_pd_d2[31:0]) //|> w
  ,.stage3_pipe_in_rdy_d1 (stage3_pipe_in_rdy_d1)      //|> w
  ,.stage3_pipe_in_vld_d2 (stage3_pipe_in_vld_d2)      //|> w
  );
FP_SUM_BLOCK_pipe_p15 pipe_p15 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage3_pipe_in_pd_d2  (stage3_pipe_in_pd_d2[31:0]) //|< w
  ,.stage3_pipe_in_rdy_d3 (stage3_pipe_in_rdy_d3)      //|< w
  ,.stage3_pipe_in_vld_d2 (stage3_pipe_in_vld_d2)      //|< w
  ,.stage3_pipe_in_pd_d3  (stage3_pipe_in_pd_d3[31:0]) //|> w
  ,.stage3_pipe_in_rdy_d2 (stage3_pipe_in_rdy_d2)      //|> w
  ,.stage3_pipe_in_vld_d3 (stage3_pipe_in_vld_d3)      //|> w
  );
FP_SUM_BLOCK_pipe_p16 pipe_p16 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.stage3_pipe_in_pd_d3  (stage3_pipe_in_pd_d3[31:0]) //|< w
  ,.stage3_pipe_in_rdy_d4 (stage3_pipe_in_rdy_d4)      //|< w
  ,.stage3_pipe_in_vld_d3 (stage3_pipe_in_vld_d3)      //|< w
  ,.stage3_pipe_in_pd_d4  (stage3_pipe_in_pd_d4[31:0]) //|> w
  ,.stage3_pipe_in_rdy_d3 (stage3_pipe_in_rdy_d3)      //|> w
  ,.stage3_pipe_in_vld_d4 (stage3_pipe_in_vld_d4)      //|> w
  );
assign stage3_pipe_out_vld = stage3_pipe_in_vld_d4;
assign stage3_pipe_in_rdy_d4 = stage3_pipe_out_rdy;
assign stage3_pipe_out_pd[31:0] = stage3_pipe_in_pd_d4[31:0];


assign fp16_sum_stage3_vld = (len3 | len5 | len7) ? 1'b0 : (fp16_sum7_vld & stage3_pipe_out_vld);
//////////////////////////////////////
assign fp16_sum_stage3_rdy = stage4_sum7_rdy & stage4_sum08_rdy;

assign stage4_sum7_vld   = fp16_sum_stage3_vld & stage4_sum08_rdy;
assign stage4_sum08_vld  = fp16_sum_stage3_vld & stage4_sum7_rdy;

HLS_fp32_add u_HLS_fp32_add_sum9 (
   .nvdla_core_clk        (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn       (nvdla_core_rstn)            //|< i
  ,.chn_a_rsc_z           (fp16_sum7[31:0])            //|< w
  ,.chn_a_rsc_vz          (stage4_sum7_vld)            //|< w
  ,.chn_a_rsc_lz          (stage4_sum7_rdy)            //|> w
  ,.chn_b_rsc_z           (stage3_pipe_out_pd[31:0])   //|< w
  ,.chn_b_rsc_vz          (stage4_sum08_vld)           //|< w
  ,.chn_b_rsc_lz          (stage4_sum08_rdy)           //|> w
  ,.chn_o_rsc_z           (fp16_sum9[31:0])            //|> w
  ,.chn_o_rsc_vz          (fp16_sum9_rdy)              //|< w
  ,.chn_o_rsc_lz          (fp16_sum9_vld)              //|> w
  );
//fp16_sum_0_8     ;

assign fp16_sum9_rdy = fp16_sum_rdy;
//////////////////////////////////////
always @(
  reg2dp_normalz_len
  or fp16_sum3
  or fp16_sum3_vld
  or fp16_sum5
  or fp16_sum5_vld
  or fp16_sum7
  or fp16_sum7_vld
  or fp16_sum9
  or fp16_sum9_vld
  ) begin
    case(reg2dp_normalz_len[1:0]) 
    2'h0 : begin
        fp16_sum     = fp16_sum3;
        fp16_sum_vld = fp16_sum3_vld;
    end
    2'h1 : begin
        fp16_sum     = fp16_sum5;
        fp16_sum_vld = fp16_sum5_vld;
    end
    2'h2 : begin
        fp16_sum     = fp16_sum7;
        fp16_sum_vld = fp16_sum7_vld;
    end
    default: begin
    //NVDLA_CDP_D_LRN_CFG_0_NORMALZ_LEN_LEN9: begin
        fp16_sum     = fp16_sum9;
        fp16_sum_vld = fp16_sum9_vld;
    end
    endcase
end

//fp16_sum_rdy

endmodule // fp_sum_block



// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp16_dout_4_in_pd_d1[31:0] (fp16_dout_4_in_vld_d1,fp16_dout_4_in_rdy_d1) <= fp16_dout_4_in_pd_d0[31:0] (fp16_dout_4_in_vld_d0,fp16_dout_4_in_rdy_d0)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,fp16_dout_4_in_pd_d0
  ,fp16_dout_4_in_rdy_d1
  ,fp16_dout_4_in_vld_d0
  ,fp16_dout_4_in_pd_d1
  ,fp16_dout_4_in_rdy_d0
  ,fp16_dout_4_in_vld_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] fp16_dout_4_in_pd_d0;
input         fp16_dout_4_in_rdy_d1;
input         fp16_dout_4_in_vld_d0;
output [31:0] fp16_dout_4_in_pd_d1;
output        fp16_dout_4_in_rdy_d0;
output        fp16_dout_4_in_vld_d1;
reg    [31:0] fp16_dout_4_in_pd_d1;
reg           fp16_dout_4_in_rdy_d0;
reg           fp16_dout_4_in_vld_d1;
reg    [31:0] p1_pipe_data;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? fp16_dout_4_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && fp16_dout_4_in_vld_d0)? fp16_dout_4_in_pd_d0[31:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  fp16_dout_4_in_rdy_d0 = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or fp16_dout_4_in_rdy_d1
  or p1_pipe_data
  ) begin
  fp16_dout_4_in_vld_d1 = p1_pipe_valid;
  p1_pipe_ready = fp16_dout_4_in_rdy_d1;
  fp16_dout_4_in_pd_d1[31:0] = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (fp16_dout_4_in_vld_d1^fp16_dout_4_in_rdy_d1^fp16_dout_4_in_vld_d0^fp16_dout_4_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (fp16_dout_4_in_vld_d0 && !fp16_dout_4_in_rdy_d0), (fp16_dout_4_in_vld_d0), (fp16_dout_4_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp16_dout_4_in_pd_d2[31:0] (fp16_dout_4_in_vld_d2,fp16_dout_4_in_rdy_d2) <= fp16_dout_4_in_pd_d1[31:0] (fp16_dout_4_in_vld_d1,fp16_dout_4_in_rdy_d1)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,fp16_dout_4_in_pd_d1
  ,fp16_dout_4_in_rdy_d2
  ,fp16_dout_4_in_vld_d1
  ,fp16_dout_4_in_pd_d2
  ,fp16_dout_4_in_rdy_d1
  ,fp16_dout_4_in_vld_d2
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] fp16_dout_4_in_pd_d1;
input         fp16_dout_4_in_rdy_d2;
input         fp16_dout_4_in_vld_d1;
output [31:0] fp16_dout_4_in_pd_d2;
output        fp16_dout_4_in_rdy_d1;
output        fp16_dout_4_in_vld_d2;
reg    [31:0] fp16_dout_4_in_pd_d2;
reg           fp16_dout_4_in_rdy_d1;
reg           fp16_dout_4_in_vld_d2;
reg    [31:0] p2_pipe_data;
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
  p2_pipe_valid <= (p2_pipe_ready_bc)? fp16_dout_4_in_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && fp16_dout_4_in_vld_d1)? fp16_dout_4_in_pd_d1[31:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  fp16_dout_4_in_rdy_d1 = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or fp16_dout_4_in_rdy_d2
  or p2_pipe_data
  ) begin
  fp16_dout_4_in_vld_d2 = p2_pipe_valid;
  p2_pipe_ready = fp16_dout_4_in_rdy_d2;
  fp16_dout_4_in_pd_d2[31:0] = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (fp16_dout_4_in_vld_d2^fp16_dout_4_in_rdy_d2^fp16_dout_4_in_vld_d1^fp16_dout_4_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (fp16_dout_4_in_vld_d1 && !fp16_dout_4_in_rdy_d1), (fp16_dout_4_in_vld_d1), (fp16_dout_4_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp16_dout_4_in_pd_d3[31:0] (fp16_dout_4_in_vld_d3,fp16_dout_4_in_rdy_d3) <= fp16_dout_4_in_pd_d2[31:0] (fp16_dout_4_in_vld_d2,fp16_dout_4_in_rdy_d2)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,fp16_dout_4_in_pd_d2
  ,fp16_dout_4_in_rdy_d3
  ,fp16_dout_4_in_vld_d2
  ,fp16_dout_4_in_pd_d3
  ,fp16_dout_4_in_rdy_d2
  ,fp16_dout_4_in_vld_d3
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] fp16_dout_4_in_pd_d2;
input         fp16_dout_4_in_rdy_d3;
input         fp16_dout_4_in_vld_d2;
output [31:0] fp16_dout_4_in_pd_d3;
output        fp16_dout_4_in_rdy_d2;
output        fp16_dout_4_in_vld_d3;
reg    [31:0] fp16_dout_4_in_pd_d3;
reg           fp16_dout_4_in_rdy_d2;
reg           fp16_dout_4_in_vld_d3;
reg    [31:0] p3_pipe_data;
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
  p3_pipe_valid <= (p3_pipe_ready_bc)? fp16_dout_4_in_vld_d2 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && fp16_dout_4_in_vld_d2)? fp16_dout_4_in_pd_d2[31:0] : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  fp16_dout_4_in_rdy_d2 = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or fp16_dout_4_in_rdy_d3
  or p3_pipe_data
  ) begin
  fp16_dout_4_in_vld_d3 = p3_pipe_valid;
  p3_pipe_ready = fp16_dout_4_in_rdy_d3;
  fp16_dout_4_in_pd_d3[31:0] = p3_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (fp16_dout_4_in_vld_d3^fp16_dout_4_in_rdy_d3^fp16_dout_4_in_vld_d2^fp16_dout_4_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (fp16_dout_4_in_vld_d2 && !fp16_dout_4_in_rdy_d2), (fp16_dout_4_in_vld_d2), (fp16_dout_4_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp16_dout_4_in_pd_d4[31:0] (fp16_dout_4_in_vld_d4,fp16_dout_4_in_rdy_d4) <= fp16_dout_4_in_pd_d3[31:0] (fp16_dout_4_in_vld_d3,fp16_dout_4_in_rdy_d3)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,fp16_dout_4_in_pd_d3
  ,fp16_dout_4_in_rdy_d4
  ,fp16_dout_4_in_vld_d3
  ,fp16_dout_4_in_pd_d4
  ,fp16_dout_4_in_rdy_d3
  ,fp16_dout_4_in_vld_d4
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] fp16_dout_4_in_pd_d3;
input         fp16_dout_4_in_rdy_d4;
input         fp16_dout_4_in_vld_d3;
output [31:0] fp16_dout_4_in_pd_d4;
output        fp16_dout_4_in_rdy_d3;
output        fp16_dout_4_in_vld_d4;
reg    [31:0] fp16_dout_4_in_pd_d4;
reg           fp16_dout_4_in_rdy_d3;
reg           fp16_dout_4_in_vld_d4;
reg    [31:0] p4_pipe_data;
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
  p4_pipe_valid <= (p4_pipe_ready_bc)? fp16_dout_4_in_vld_d3 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && fp16_dout_4_in_vld_d3)? fp16_dout_4_in_pd_d3[31:0] : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  fp16_dout_4_in_rdy_d3 = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or fp16_dout_4_in_rdy_d4
  or p4_pipe_data
  ) begin
  fp16_dout_4_in_vld_d4 = p4_pipe_valid;
  p4_pipe_ready = fp16_dout_4_in_rdy_d4;
  fp16_dout_4_in_pd_d4[31:0] = p4_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (fp16_dout_4_in_vld_d4^fp16_dout_4_in_rdy_d4^fp16_dout_4_in_vld_d3^fp16_dout_4_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (fp16_dout_4_in_vld_d3 && !fp16_dout_4_in_rdy_d3), (fp16_dout_4_in_vld_d3), (fp16_dout_4_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage1_pipe_in_pd_d1[95:0] (stage1_pipe_in_vld_d1,stage1_pipe_in_rdy_d1) <= stage1_pipe_in_pd_d0[95:0] (stage1_pipe_in_vld_d0,stage1_pipe_in_rdy_d0)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p5 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage1_pipe_in_pd_d0
  ,stage1_pipe_in_rdy_d1
  ,stage1_pipe_in_vld_d0
  ,stage1_pipe_in_pd_d1
  ,stage1_pipe_in_rdy_d0
  ,stage1_pipe_in_vld_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [95:0] stage1_pipe_in_pd_d0;
input         stage1_pipe_in_rdy_d1;
input         stage1_pipe_in_vld_d0;
output [95:0] stage1_pipe_in_pd_d1;
output        stage1_pipe_in_rdy_d0;
output        stage1_pipe_in_vld_d1;
reg    [95:0] p5_pipe_data;
reg           p5_pipe_ready;
reg           p5_pipe_ready_bc;
reg           p5_pipe_valid;
reg    [95:0] stage1_pipe_in_pd_d1;
reg           stage1_pipe_in_rdy_d0;
reg           stage1_pipe_in_vld_d1;
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
  p5_pipe_valid <= (p5_pipe_ready_bc)? stage1_pipe_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && stage1_pipe_in_vld_d0)? stage1_pipe_in_pd_d0[95:0] : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  stage1_pipe_in_rdy_d0 = p5_pipe_ready_bc;
end
//## pipe (5) output
always @(
  p5_pipe_valid
  or stage1_pipe_in_rdy_d1
  or p5_pipe_data
  ) begin
  stage1_pipe_in_vld_d1 = p5_pipe_valid;
  p5_pipe_ready = stage1_pipe_in_rdy_d1;
  stage1_pipe_in_pd_d1[95:0] = p5_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage1_pipe_in_vld_d1^stage1_pipe_in_rdy_d1^stage1_pipe_in_vld_d0^stage1_pipe_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_10x (nvdla_core_clk, `ASSERT_RESET, (stage1_pipe_in_vld_d0 && !stage1_pipe_in_rdy_d0), (stage1_pipe_in_vld_d0), (stage1_pipe_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p5




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage1_pipe_in_pd_d2[95:0] (stage1_pipe_in_vld_d2,stage1_pipe_in_rdy_d2) <= stage1_pipe_in_pd_d1[95:0] (stage1_pipe_in_vld_d1,stage1_pipe_in_rdy_d1)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p6 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage1_pipe_in_pd_d1
  ,stage1_pipe_in_rdy_d2
  ,stage1_pipe_in_vld_d1
  ,stage1_pipe_in_pd_d2
  ,stage1_pipe_in_rdy_d1
  ,stage1_pipe_in_vld_d2
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [95:0] stage1_pipe_in_pd_d1;
input         stage1_pipe_in_rdy_d2;
input         stage1_pipe_in_vld_d1;
output [95:0] stage1_pipe_in_pd_d2;
output        stage1_pipe_in_rdy_d1;
output        stage1_pipe_in_vld_d2;
reg    [95:0] p6_pipe_data;
reg           p6_pipe_ready;
reg           p6_pipe_ready_bc;
reg           p6_pipe_valid;
reg    [95:0] stage1_pipe_in_pd_d2;
reg           stage1_pipe_in_rdy_d1;
reg           stage1_pipe_in_vld_d2;
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
  p6_pipe_valid <= (p6_pipe_ready_bc)? stage1_pipe_in_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p6_pipe_data <= (p6_pipe_ready_bc && stage1_pipe_in_vld_d1)? stage1_pipe_in_pd_d1[95:0] : p6_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p6_pipe_ready_bc
  ) begin
  stage1_pipe_in_rdy_d1 = p6_pipe_ready_bc;
end
//## pipe (6) output
always @(
  p6_pipe_valid
  or stage1_pipe_in_rdy_d2
  or p6_pipe_data
  ) begin
  stage1_pipe_in_vld_d2 = p6_pipe_valid;
  p6_pipe_ready = stage1_pipe_in_rdy_d2;
  stage1_pipe_in_pd_d2[95:0] = p6_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage1_pipe_in_vld_d2^stage1_pipe_in_rdy_d2^stage1_pipe_in_vld_d1^stage1_pipe_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_12x (nvdla_core_clk, `ASSERT_RESET, (stage1_pipe_in_vld_d1 && !stage1_pipe_in_rdy_d1), (stage1_pipe_in_vld_d1), (stage1_pipe_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p6




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage1_pipe_in_pd_d3[95:0] (stage1_pipe_in_vld_d3,stage1_pipe_in_rdy_d3) <= stage1_pipe_in_pd_d2[95:0] (stage1_pipe_in_vld_d2,stage1_pipe_in_rdy_d2)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p7 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage1_pipe_in_pd_d2
  ,stage1_pipe_in_rdy_d3
  ,stage1_pipe_in_vld_d2
  ,stage1_pipe_in_pd_d3
  ,stage1_pipe_in_rdy_d2
  ,stage1_pipe_in_vld_d3
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [95:0] stage1_pipe_in_pd_d2;
input         stage1_pipe_in_rdy_d3;
input         stage1_pipe_in_vld_d2;
output [95:0] stage1_pipe_in_pd_d3;
output        stage1_pipe_in_rdy_d2;
output        stage1_pipe_in_vld_d3;
reg    [95:0] p7_pipe_data;
reg           p7_pipe_ready;
reg           p7_pipe_ready_bc;
reg           p7_pipe_valid;
reg    [95:0] stage1_pipe_in_pd_d3;
reg           stage1_pipe_in_rdy_d2;
reg           stage1_pipe_in_vld_d3;
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
  p7_pipe_valid <= (p7_pipe_ready_bc)? stage1_pipe_in_vld_d2 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p7_pipe_data <= (p7_pipe_ready_bc && stage1_pipe_in_vld_d2)? stage1_pipe_in_pd_d2[95:0] : p7_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p7_pipe_ready_bc
  ) begin
  stage1_pipe_in_rdy_d2 = p7_pipe_ready_bc;
end
//## pipe (7) output
always @(
  p7_pipe_valid
  or stage1_pipe_in_rdy_d3
  or p7_pipe_data
  ) begin
  stage1_pipe_in_vld_d3 = p7_pipe_valid;
  p7_pipe_ready = stage1_pipe_in_rdy_d3;
  stage1_pipe_in_pd_d3[95:0] = p7_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage1_pipe_in_vld_d3^stage1_pipe_in_rdy_d3^stage1_pipe_in_vld_d2^stage1_pipe_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_14x (nvdla_core_clk, `ASSERT_RESET, (stage1_pipe_in_vld_d2 && !stage1_pipe_in_rdy_d2), (stage1_pipe_in_vld_d2), (stage1_pipe_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p7




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage1_pipe_in_pd_d4[95:0] (stage1_pipe_in_vld_d4,stage1_pipe_in_rdy_d4) <= stage1_pipe_in_pd_d3[95:0] (stage1_pipe_in_vld_d3,stage1_pipe_in_rdy_d3)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p8 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage1_pipe_in_pd_d3
  ,stage1_pipe_in_rdy_d4
  ,stage1_pipe_in_vld_d3
  ,stage1_pipe_in_pd_d4
  ,stage1_pipe_in_rdy_d3
  ,stage1_pipe_in_vld_d4
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [95:0] stage1_pipe_in_pd_d3;
input         stage1_pipe_in_rdy_d4;
input         stage1_pipe_in_vld_d3;
output [95:0] stage1_pipe_in_pd_d4;
output        stage1_pipe_in_rdy_d3;
output        stage1_pipe_in_vld_d4;
reg    [95:0] p8_pipe_data;
reg           p8_pipe_ready;
reg           p8_pipe_ready_bc;
reg           p8_pipe_valid;
reg    [95:0] stage1_pipe_in_pd_d4;
reg           stage1_pipe_in_rdy_d3;
reg           stage1_pipe_in_vld_d4;
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
  p8_pipe_valid <= (p8_pipe_ready_bc)? stage1_pipe_in_vld_d3 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p8_pipe_data <= (p8_pipe_ready_bc && stage1_pipe_in_vld_d3)? stage1_pipe_in_pd_d3[95:0] : p8_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p8_pipe_ready_bc
  ) begin
  stage1_pipe_in_rdy_d3 = p8_pipe_ready_bc;
end
//## pipe (8) output
always @(
  p8_pipe_valid
  or stage1_pipe_in_rdy_d4
  or p8_pipe_data
  ) begin
  stage1_pipe_in_vld_d4 = p8_pipe_valid;
  p8_pipe_ready = stage1_pipe_in_rdy_d4;
  stage1_pipe_in_pd_d4[95:0] = p8_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage1_pipe_in_vld_d4^stage1_pipe_in_rdy_d4^stage1_pipe_in_vld_d3^stage1_pipe_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_16x (nvdla_core_clk, `ASSERT_RESET, (stage1_pipe_in_vld_d3 && !stage1_pipe_in_rdy_d3), (stage1_pipe_in_vld_d3), (stage1_pipe_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p8




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage2_pipe_in_pd_d1[63:0] (stage2_pipe_in_vld_d1,stage2_pipe_in_rdy_d1) <= stage2_pipe_in_pd_d0[63:0] (stage2_pipe_in_vld_d0,stage2_pipe_in_rdy_d0)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p9 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage2_pipe_in_pd_d0
  ,stage2_pipe_in_rdy_d1
  ,stage2_pipe_in_vld_d0
  ,stage2_pipe_in_pd_d1
  ,stage2_pipe_in_rdy_d0
  ,stage2_pipe_in_vld_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [63:0] stage2_pipe_in_pd_d0;
input         stage2_pipe_in_rdy_d1;
input         stage2_pipe_in_vld_d0;
output [63:0] stage2_pipe_in_pd_d1;
output        stage2_pipe_in_rdy_d0;
output        stage2_pipe_in_vld_d1;
reg    [63:0] p9_pipe_data;
reg           p9_pipe_ready;
reg           p9_pipe_ready_bc;
reg           p9_pipe_valid;
reg    [63:0] stage2_pipe_in_pd_d1;
reg           stage2_pipe_in_rdy_d0;
reg           stage2_pipe_in_vld_d1;
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
  p9_pipe_valid <= (p9_pipe_ready_bc)? stage2_pipe_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p9_pipe_data <= (p9_pipe_ready_bc && stage2_pipe_in_vld_d0)? stage2_pipe_in_pd_d0[63:0] : p9_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p9_pipe_ready_bc
  ) begin
  stage2_pipe_in_rdy_d0 = p9_pipe_ready_bc;
end
//## pipe (9) output
always @(
  p9_pipe_valid
  or stage2_pipe_in_rdy_d1
  or p9_pipe_data
  ) begin
  stage2_pipe_in_vld_d1 = p9_pipe_valid;
  p9_pipe_ready = stage2_pipe_in_rdy_d1;
  stage2_pipe_in_pd_d1[63:0] = p9_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage2_pipe_in_vld_d1^stage2_pipe_in_rdy_d1^stage2_pipe_in_vld_d0^stage2_pipe_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_18x (nvdla_core_clk, `ASSERT_RESET, (stage2_pipe_in_vld_d0 && !stage2_pipe_in_rdy_d0), (stage2_pipe_in_vld_d0), (stage2_pipe_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p9




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage2_pipe_in_pd_d2[63:0] (stage2_pipe_in_vld_d2,stage2_pipe_in_rdy_d2) <= stage2_pipe_in_pd_d1[63:0] (stage2_pipe_in_vld_d1,stage2_pipe_in_rdy_d1)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p10 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage2_pipe_in_pd_d1
  ,stage2_pipe_in_rdy_d2
  ,stage2_pipe_in_vld_d1
  ,stage2_pipe_in_pd_d2
  ,stage2_pipe_in_rdy_d1
  ,stage2_pipe_in_vld_d2
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [63:0] stage2_pipe_in_pd_d1;
input         stage2_pipe_in_rdy_d2;
input         stage2_pipe_in_vld_d1;
output [63:0] stage2_pipe_in_pd_d2;
output        stage2_pipe_in_rdy_d1;
output        stage2_pipe_in_vld_d2;
reg    [63:0] p10_pipe_data;
reg           p10_pipe_ready;
reg           p10_pipe_ready_bc;
reg           p10_pipe_valid;
reg    [63:0] stage2_pipe_in_pd_d2;
reg           stage2_pipe_in_rdy_d1;
reg           stage2_pipe_in_vld_d2;
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
  p10_pipe_valid <= (p10_pipe_ready_bc)? stage2_pipe_in_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p10_pipe_data <= (p10_pipe_ready_bc && stage2_pipe_in_vld_d1)? stage2_pipe_in_pd_d1[63:0] : p10_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p10_pipe_ready_bc
  ) begin
  stage2_pipe_in_rdy_d1 = p10_pipe_ready_bc;
end
//## pipe (10) output
always @(
  p10_pipe_valid
  or stage2_pipe_in_rdy_d2
  or p10_pipe_data
  ) begin
  stage2_pipe_in_vld_d2 = p10_pipe_valid;
  p10_pipe_ready = stage2_pipe_in_rdy_d2;
  stage2_pipe_in_pd_d2[63:0] = p10_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage2_pipe_in_vld_d2^stage2_pipe_in_rdy_d2^stage2_pipe_in_vld_d1^stage2_pipe_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_20x (nvdla_core_clk, `ASSERT_RESET, (stage2_pipe_in_vld_d1 && !stage2_pipe_in_rdy_d1), (stage2_pipe_in_vld_d1), (stage2_pipe_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p10




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage2_pipe_in_pd_d3[63:0] (stage2_pipe_in_vld_d3,stage2_pipe_in_rdy_d3) <= stage2_pipe_in_pd_d2[63:0] (stage2_pipe_in_vld_d2,stage2_pipe_in_rdy_d2)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p11 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage2_pipe_in_pd_d2
  ,stage2_pipe_in_rdy_d3
  ,stage2_pipe_in_vld_d2
  ,stage2_pipe_in_pd_d3
  ,stage2_pipe_in_rdy_d2
  ,stage2_pipe_in_vld_d3
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [63:0] stage2_pipe_in_pd_d2;
input         stage2_pipe_in_rdy_d3;
input         stage2_pipe_in_vld_d2;
output [63:0] stage2_pipe_in_pd_d3;
output        stage2_pipe_in_rdy_d2;
output        stage2_pipe_in_vld_d3;
reg    [63:0] p11_pipe_data;
reg           p11_pipe_ready;
reg           p11_pipe_ready_bc;
reg           p11_pipe_valid;
reg    [63:0] stage2_pipe_in_pd_d3;
reg           stage2_pipe_in_rdy_d2;
reg           stage2_pipe_in_vld_d3;
//## pipe (11) valid-ready-bubble-collapse
always @(
  p11_pipe_ready
  or p11_pipe_valid
  ) begin
  p11_pipe_ready_bc = p11_pipe_ready || !p11_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p11_pipe_valid <= 1'b0;
  end else begin
  p11_pipe_valid <= (p11_pipe_ready_bc)? stage2_pipe_in_vld_d2 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p11_pipe_data <= (p11_pipe_ready_bc && stage2_pipe_in_vld_d2)? stage2_pipe_in_pd_d2[63:0] : p11_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p11_pipe_ready_bc
  ) begin
  stage2_pipe_in_rdy_d2 = p11_pipe_ready_bc;
end
//## pipe (11) output
always @(
  p11_pipe_valid
  or stage2_pipe_in_rdy_d3
  or p11_pipe_data
  ) begin
  stage2_pipe_in_vld_d3 = p11_pipe_valid;
  p11_pipe_ready = stage2_pipe_in_rdy_d3;
  stage2_pipe_in_pd_d3[63:0] = p11_pipe_data;
end
//## pipe (11) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p11_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage2_pipe_in_vld_d3^stage2_pipe_in_rdy_d3^stage2_pipe_in_vld_d2^stage2_pipe_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_22x (nvdla_core_clk, `ASSERT_RESET, (stage2_pipe_in_vld_d2 && !stage2_pipe_in_rdy_d2), (stage2_pipe_in_vld_d2), (stage2_pipe_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p11




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage2_pipe_in_pd_d4[63:0] (stage2_pipe_in_vld_d4,stage2_pipe_in_rdy_d4) <= stage2_pipe_in_pd_d3[63:0] (stage2_pipe_in_vld_d3,stage2_pipe_in_rdy_d3)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p12 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage2_pipe_in_pd_d3
  ,stage2_pipe_in_rdy_d4
  ,stage2_pipe_in_vld_d3
  ,stage2_pipe_in_pd_d4
  ,stage2_pipe_in_rdy_d3
  ,stage2_pipe_in_vld_d4
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [63:0] stage2_pipe_in_pd_d3;
input         stage2_pipe_in_rdy_d4;
input         stage2_pipe_in_vld_d3;
output [63:0] stage2_pipe_in_pd_d4;
output        stage2_pipe_in_rdy_d3;
output        stage2_pipe_in_vld_d4;
reg    [63:0] p12_pipe_data;
reg           p12_pipe_ready;
reg           p12_pipe_ready_bc;
reg           p12_pipe_valid;
reg    [63:0] stage2_pipe_in_pd_d4;
reg           stage2_pipe_in_rdy_d3;
reg           stage2_pipe_in_vld_d4;
//## pipe (12) valid-ready-bubble-collapse
always @(
  p12_pipe_ready
  or p12_pipe_valid
  ) begin
  p12_pipe_ready_bc = p12_pipe_ready || !p12_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p12_pipe_valid <= 1'b0;
  end else begin
  p12_pipe_valid <= (p12_pipe_ready_bc)? stage2_pipe_in_vld_d3 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p12_pipe_data <= (p12_pipe_ready_bc && stage2_pipe_in_vld_d3)? stage2_pipe_in_pd_d3[63:0] : p12_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p12_pipe_ready_bc
  ) begin
  stage2_pipe_in_rdy_d3 = p12_pipe_ready_bc;
end
//## pipe (12) output
always @(
  p12_pipe_valid
  or stage2_pipe_in_rdy_d4
  or p12_pipe_data
  ) begin
  stage2_pipe_in_vld_d4 = p12_pipe_valid;
  p12_pipe_ready = stage2_pipe_in_rdy_d4;
  stage2_pipe_in_pd_d4[63:0] = p12_pipe_data;
end
//## pipe (12) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p12_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage2_pipe_in_vld_d4^stage2_pipe_in_rdy_d4^stage2_pipe_in_vld_d3^stage2_pipe_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_24x (nvdla_core_clk, `ASSERT_RESET, (stage2_pipe_in_vld_d3 && !stage2_pipe_in_rdy_d3), (stage2_pipe_in_vld_d3), (stage2_pipe_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p12




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage3_pipe_in_pd_d1[31:0] (stage3_pipe_in_vld_d1,stage3_pipe_in_rdy_d1) <= stage3_pipe_in_pd_d0[31:0] (stage3_pipe_in_vld_d0,stage3_pipe_in_rdy_d0)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p13 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage3_pipe_in_pd_d0
  ,stage3_pipe_in_rdy_d1
  ,stage3_pipe_in_vld_d0
  ,stage3_pipe_in_pd_d1
  ,stage3_pipe_in_rdy_d0
  ,stage3_pipe_in_vld_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] stage3_pipe_in_pd_d0;
input         stage3_pipe_in_rdy_d1;
input         stage3_pipe_in_vld_d0;
output [31:0] stage3_pipe_in_pd_d1;
output        stage3_pipe_in_rdy_d0;
output        stage3_pipe_in_vld_d1;
reg    [31:0] p13_pipe_data;
reg           p13_pipe_ready;
reg           p13_pipe_ready_bc;
reg           p13_pipe_valid;
reg    [31:0] stage3_pipe_in_pd_d1;
reg           stage3_pipe_in_rdy_d0;
reg           stage3_pipe_in_vld_d1;
//## pipe (13) valid-ready-bubble-collapse
always @(
  p13_pipe_ready
  or p13_pipe_valid
  ) begin
  p13_pipe_ready_bc = p13_pipe_ready || !p13_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p13_pipe_valid <= 1'b0;
  end else begin
  p13_pipe_valid <= (p13_pipe_ready_bc)? stage3_pipe_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p13_pipe_data <= (p13_pipe_ready_bc && stage3_pipe_in_vld_d0)? stage3_pipe_in_pd_d0[31:0] : p13_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p13_pipe_ready_bc
  ) begin
  stage3_pipe_in_rdy_d0 = p13_pipe_ready_bc;
end
//## pipe (13) output
always @(
  p13_pipe_valid
  or stage3_pipe_in_rdy_d1
  or p13_pipe_data
  ) begin
  stage3_pipe_in_vld_d1 = p13_pipe_valid;
  p13_pipe_ready = stage3_pipe_in_rdy_d1;
  stage3_pipe_in_pd_d1[31:0] = p13_pipe_data;
end
//## pipe (13) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p13_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage3_pipe_in_vld_d1^stage3_pipe_in_rdy_d1^stage3_pipe_in_vld_d0^stage3_pipe_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_26x (nvdla_core_clk, `ASSERT_RESET, (stage3_pipe_in_vld_d0 && !stage3_pipe_in_rdy_d0), (stage3_pipe_in_vld_d0), (stage3_pipe_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p13




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage3_pipe_in_pd_d2[31:0] (stage3_pipe_in_vld_d2,stage3_pipe_in_rdy_d2) <= stage3_pipe_in_pd_d1[31:0] (stage3_pipe_in_vld_d1,stage3_pipe_in_rdy_d1)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p14 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage3_pipe_in_pd_d1
  ,stage3_pipe_in_rdy_d2
  ,stage3_pipe_in_vld_d1
  ,stage3_pipe_in_pd_d2
  ,stage3_pipe_in_rdy_d1
  ,stage3_pipe_in_vld_d2
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] stage3_pipe_in_pd_d1;
input         stage3_pipe_in_rdy_d2;
input         stage3_pipe_in_vld_d1;
output [31:0] stage3_pipe_in_pd_d2;
output        stage3_pipe_in_rdy_d1;
output        stage3_pipe_in_vld_d2;
reg    [31:0] p14_pipe_data;
reg           p14_pipe_ready;
reg           p14_pipe_ready_bc;
reg           p14_pipe_valid;
reg    [31:0] stage3_pipe_in_pd_d2;
reg           stage3_pipe_in_rdy_d1;
reg           stage3_pipe_in_vld_d2;
//## pipe (14) valid-ready-bubble-collapse
always @(
  p14_pipe_ready
  or p14_pipe_valid
  ) begin
  p14_pipe_ready_bc = p14_pipe_ready || !p14_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p14_pipe_valid <= 1'b0;
  end else begin
  p14_pipe_valid <= (p14_pipe_ready_bc)? stage3_pipe_in_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p14_pipe_data <= (p14_pipe_ready_bc && stage3_pipe_in_vld_d1)? stage3_pipe_in_pd_d1[31:0] : p14_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p14_pipe_ready_bc
  ) begin
  stage3_pipe_in_rdy_d1 = p14_pipe_ready_bc;
end
//## pipe (14) output
always @(
  p14_pipe_valid
  or stage3_pipe_in_rdy_d2
  or p14_pipe_data
  ) begin
  stage3_pipe_in_vld_d2 = p14_pipe_valid;
  p14_pipe_ready = stage3_pipe_in_rdy_d2;
  stage3_pipe_in_pd_d2[31:0] = p14_pipe_data;
end
//## pipe (14) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p14_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage3_pipe_in_vld_d2^stage3_pipe_in_rdy_d2^stage3_pipe_in_vld_d1^stage3_pipe_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_28x (nvdla_core_clk, `ASSERT_RESET, (stage3_pipe_in_vld_d1 && !stage3_pipe_in_rdy_d1), (stage3_pipe_in_vld_d1), (stage3_pipe_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p14




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage3_pipe_in_pd_d3[31:0] (stage3_pipe_in_vld_d3,stage3_pipe_in_rdy_d3) <= stage3_pipe_in_pd_d2[31:0] (stage3_pipe_in_vld_d2,stage3_pipe_in_rdy_d2)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p15 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage3_pipe_in_pd_d2
  ,stage3_pipe_in_rdy_d3
  ,stage3_pipe_in_vld_d2
  ,stage3_pipe_in_pd_d3
  ,stage3_pipe_in_rdy_d2
  ,stage3_pipe_in_vld_d3
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] stage3_pipe_in_pd_d2;
input         stage3_pipe_in_rdy_d3;
input         stage3_pipe_in_vld_d2;
output [31:0] stage3_pipe_in_pd_d3;
output        stage3_pipe_in_rdy_d2;
output        stage3_pipe_in_vld_d3;
reg    [31:0] p15_pipe_data;
reg           p15_pipe_ready;
reg           p15_pipe_ready_bc;
reg           p15_pipe_valid;
reg    [31:0] stage3_pipe_in_pd_d3;
reg           stage3_pipe_in_rdy_d2;
reg           stage3_pipe_in_vld_d3;
//## pipe (15) valid-ready-bubble-collapse
always @(
  p15_pipe_ready
  or p15_pipe_valid
  ) begin
  p15_pipe_ready_bc = p15_pipe_ready || !p15_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p15_pipe_valid <= 1'b0;
  end else begin
  p15_pipe_valid <= (p15_pipe_ready_bc)? stage3_pipe_in_vld_d2 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p15_pipe_data <= (p15_pipe_ready_bc && stage3_pipe_in_vld_d2)? stage3_pipe_in_pd_d2[31:0] : p15_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p15_pipe_ready_bc
  ) begin
  stage3_pipe_in_rdy_d2 = p15_pipe_ready_bc;
end
//## pipe (15) output
always @(
  p15_pipe_valid
  or stage3_pipe_in_rdy_d3
  or p15_pipe_data
  ) begin
  stage3_pipe_in_vld_d3 = p15_pipe_valid;
  p15_pipe_ready = stage3_pipe_in_rdy_d3;
  stage3_pipe_in_pd_d3[31:0] = p15_pipe_data;
end
//## pipe (15) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p15_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage3_pipe_in_vld_d3^stage3_pipe_in_rdy_d3^stage3_pipe_in_vld_d2^stage3_pipe_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_30x (nvdla_core_clk, `ASSERT_RESET, (stage3_pipe_in_vld_d2 && !stage3_pipe_in_rdy_d2), (stage3_pipe_in_vld_d2), (stage3_pipe_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p15




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none stage3_pipe_in_pd_d4[31:0] (stage3_pipe_in_vld_d4,stage3_pipe_in_rdy_d4) <= stage3_pipe_in_pd_d3[31:0] (stage3_pipe_in_vld_d3,stage3_pipe_in_rdy_d3)
// **************************************************************************************************************
module FP_SUM_BLOCK_pipe_p16 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,stage3_pipe_in_pd_d3
  ,stage3_pipe_in_rdy_d4
  ,stage3_pipe_in_vld_d3
  ,stage3_pipe_in_pd_d4
  ,stage3_pipe_in_rdy_d3
  ,stage3_pipe_in_vld_d4
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] stage3_pipe_in_pd_d3;
input         stage3_pipe_in_rdy_d4;
input         stage3_pipe_in_vld_d3;
output [31:0] stage3_pipe_in_pd_d4;
output        stage3_pipe_in_rdy_d3;
output        stage3_pipe_in_vld_d4;
reg    [31:0] p16_pipe_data;
reg           p16_pipe_ready;
reg           p16_pipe_ready_bc;
reg           p16_pipe_valid;
reg    [31:0] stage3_pipe_in_pd_d4;
reg           stage3_pipe_in_rdy_d3;
reg           stage3_pipe_in_vld_d4;
//## pipe (16) valid-ready-bubble-collapse
always @(
  p16_pipe_ready
  or p16_pipe_valid
  ) begin
  p16_pipe_ready_bc = p16_pipe_ready || !p16_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p16_pipe_valid <= 1'b0;
  end else begin
  p16_pipe_valid <= (p16_pipe_ready_bc)? stage3_pipe_in_vld_d3 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p16_pipe_data <= (p16_pipe_ready_bc && stage3_pipe_in_vld_d3)? stage3_pipe_in_pd_d3[31:0] : p16_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p16_pipe_ready_bc
  ) begin
  stage3_pipe_in_rdy_d3 = p16_pipe_ready_bc;
end
//## pipe (16) output
always @(
  p16_pipe_valid
  or stage3_pipe_in_rdy_d4
  or p16_pipe_data
  ) begin
  stage3_pipe_in_vld_d4 = p16_pipe_valid;
  p16_pipe_ready = stage3_pipe_in_rdy_d4;
  stage3_pipe_in_pd_d4[31:0] = p16_pipe_data;
end
//## pipe (16) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p16_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (stage3_pipe_in_vld_d4^stage3_pipe_in_rdy_d4^stage3_pipe_in_vld_d3^stage3_pipe_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_32x (nvdla_core_clk, `ASSERT_RESET, (stage3_pipe_in_vld_d3 && !stage3_pipe_in_rdy_d3), (stage3_pipe_in_vld_d3), (stage3_pipe_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // FP_SUM_BLOCK_pipe_p16



