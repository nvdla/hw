// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_LUT_ctrl.v

module NV_NVDLA_CDP_DP_LUT_ctrl (
   nvdla_core_clk             //|< i
  ,nvdla_core_rstn            //|< i
  ,dp2lut_prdy                //|< i
  ,fp16_en                    //|< i
  ,int16_en                   //|< i
  ,int8_en                    //|< i
  ,nvdla_op_gated_clk_fp16    //|< i
  ,nvdla_op_gated_clk_int     //|< i
  ,reg2dp_lut_le_function     //|< i
  ,reg2dp_lut_le_index_offset //|< i
  ,reg2dp_lut_le_index_select //|< i
  ,reg2dp_lut_le_start_high   //|< i
  ,reg2dp_lut_le_start_low    //|< i
  ,reg2dp_lut_lo_index_select //|< i
  ,reg2dp_lut_lo_start_high   //|< i
  ,reg2dp_lut_lo_start_low    //|< i
  ,reg2dp_sqsum_bypass        //|< i
  ,sum2itp_pd                 //|< i
  ,sum2itp_pvld               //|< i
  ,sum2sync_prdy              //|< i
  ,dp2lut_X_entry_0           //|> o
  ,dp2lut_X_entry_1           //|> o
  ,dp2lut_X_entry_2           //|> o
  ,dp2lut_X_entry_3           //|> o
  ,dp2lut_X_entry_4           //|> o
  ,dp2lut_X_entry_5           //|> o
  ,dp2lut_X_entry_6           //|> o
  ,dp2lut_X_entry_7           //|> o
  ,dp2lut_Xinfo_0             //|> o
  ,dp2lut_Xinfo_1             //|> o
  ,dp2lut_Xinfo_2             //|> o
  ,dp2lut_Xinfo_3             //|> o
  ,dp2lut_Xinfo_4             //|> o
  ,dp2lut_Xinfo_5             //|> o
  ,dp2lut_Xinfo_6             //|> o
  ,dp2lut_Xinfo_7             //|> o
  ,dp2lut_Y_entry_0           //|> o
  ,dp2lut_Y_entry_1           //|> o
  ,dp2lut_Y_entry_2           //|> o
  ,dp2lut_Y_entry_3           //|> o
  ,dp2lut_Y_entry_4           //|> o
  ,dp2lut_Y_entry_5           //|> o
  ,dp2lut_Y_entry_6           //|> o
  ,dp2lut_Y_entry_7           //|> o
  ,dp2lut_Yinfo_0             //|> o
  ,dp2lut_Yinfo_1             //|> o
  ,dp2lut_Yinfo_2             //|> o
  ,dp2lut_Yinfo_3             //|> o
  ,dp2lut_Yinfo_4             //|> o
  ,dp2lut_Yinfo_5             //|> o
  ,dp2lut_Yinfo_6             //|> o
  ,dp2lut_Yinfo_7             //|> o
  ,dp2lut_pvld                //|> o
  ,sum2itp_prdy               //|> o
  ,sum2sync_pd                //|> o
  ,sum2sync_pvld              //|> o
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          dp2lut_prdy;
input          fp16_en;
input          int16_en;
input          int8_en;
input          nvdla_op_gated_clk_fp16;
input          nvdla_op_gated_clk_int;
input          reg2dp_lut_le_function;
input    [7:0] reg2dp_lut_le_index_offset;
input    [7:0] reg2dp_lut_le_index_select;
input    [5:0] reg2dp_lut_le_start_high;
input   [31:0] reg2dp_lut_le_start_low;
input    [7:0] reg2dp_lut_lo_index_select;
input    [5:0] reg2dp_lut_lo_start_high;
input   [31:0] reg2dp_lut_lo_start_low;
input          reg2dp_sqsum_bypass;
input  [167:0] sum2itp_pd;
input          sum2itp_pvld;
input          sum2sync_prdy;
output   [9:0] dp2lut_X_entry_0;
output   [9:0] dp2lut_X_entry_1;
output   [9:0] dp2lut_X_entry_2;
output   [9:0] dp2lut_X_entry_3;
output   [9:0] dp2lut_X_entry_4;
output   [9:0] dp2lut_X_entry_5;
output   [9:0] dp2lut_X_entry_6;
output   [9:0] dp2lut_X_entry_7;
output  [17:0] dp2lut_Xinfo_0;
output  [17:0] dp2lut_Xinfo_1;
output  [17:0] dp2lut_Xinfo_2;
output  [17:0] dp2lut_Xinfo_3;
output  [17:0] dp2lut_Xinfo_4;
output  [17:0] dp2lut_Xinfo_5;
output  [17:0] dp2lut_Xinfo_6;
output  [17:0] dp2lut_Xinfo_7;
output   [9:0] dp2lut_Y_entry_0;
output   [9:0] dp2lut_Y_entry_1;
output   [9:0] dp2lut_Y_entry_2;
output   [9:0] dp2lut_Y_entry_3;
output   [9:0] dp2lut_Y_entry_4;
output   [9:0] dp2lut_Y_entry_5;
output   [9:0] dp2lut_Y_entry_6;
output   [9:0] dp2lut_Y_entry_7;
output  [17:0] dp2lut_Yinfo_0;
output  [17:0] dp2lut_Yinfo_1;
output  [17:0] dp2lut_Yinfo_2;
output  [17:0] dp2lut_Yinfo_3;
output  [17:0] dp2lut_Yinfo_4;
output  [17:0] dp2lut_Yinfo_5;
output  [17:0] dp2lut_Yinfo_6;
output  [17:0] dp2lut_Yinfo_7;
output         dp2lut_pvld;
output         sum2itp_prdy;
output [167:0] sum2sync_pd;
output         sum2sync_pvld;
reg            sqsum_bypass_enb;
wire    [35:0] dp2lut_X_info_0;
wire    [35:0] dp2lut_X_info_1;
wire    [35:0] dp2lut_X_info_2;
wire    [35:0] dp2lut_X_info_3;
wire    [19:0] dp2lut_X_pd_0;
wire    [19:0] dp2lut_X_pd_1;
wire    [19:0] dp2lut_X_pd_2;
wire    [19:0] dp2lut_X_pd_3;
wire    [35:0] dp2lut_Y_info_0;
wire    [35:0] dp2lut_Y_info_1;
wire    [35:0] dp2lut_Y_info_2;
wire    [35:0] dp2lut_Y_info_3;
wire    [19:0] dp2lut_Y_pd_0;
wire    [19:0] dp2lut_Y_pd_1;
wire    [19:0] dp2lut_Y_pd_2;
wire    [19:0] dp2lut_Y_pd_3;
wire           dp2lut_prdy_0;
wire           dp2lut_prdy_1;
wire           dp2lut_prdy_2;
wire           dp2lut_prdy_3;
wire           dp2lut_pvld_0;
wire           dp2lut_pvld_1;
wire           dp2lut_pvld_2;
wire           dp2lut_pvld_3;
wire           fp16_sqsum_bypass_en;
wire    [16:0] fp17to32_in_pd_0;
wire    [16:0] fp17to32_in_pd_1;
wire    [16:0] fp17to32_in_pd_2;
wire    [16:0] fp17to32_in_pd_3;
wire     [3:0] fp17to32_in_rdy;
wire     [3:0] fp17to32_in_vld;
wire    [31:0] fp17to32_out_pd_0;
wire    [31:0] fp17to32_out_pd_1;
wire    [31:0] fp17to32_out_pd_2;
wire    [31:0] fp17to32_out_pd_3;
wire     [3:0] fp17to32_out_rdy;
wire     [3:0] fp17to32_out_vld;
wire    [41:0] sum2itp_pd_0;
wire    [41:0] sum2itp_pd_1;
wire    [41:0] sum2itp_pd_2;
wire    [41:0] sum2itp_pd_3;
wire   [167:0] sum2itp_pd_f;
wire           sum2itp_prdy_0;
wire           sum2itp_prdy_1;
wire           sum2itp_prdy_2;
wire           sum2itp_prdy_3;
wire           sum2itp_prdy_f;
wire           sum2itp_pvld_0;
wire           sum2itp_pvld_1;
wire           sum2itp_pvld_2;
wire           sum2itp_pvld_3;
wire           sum2itp_pvld_f;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    ////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sqsum_bypass_enb <= 1'b0;
  end else begin
  sqsum_bypass_enb <= reg2dp_sqsum_bypass == 1'h1;
  end
end
assign fp16_sqsum_bypass_en = (sqsum_bypass_enb & fp16_en);
assign sum2itp_prdy = fp16_sqsum_bypass_en ? (&fp17to32_in_rdy) : sum2itp_prdy_f;

assign fp17to32_in_vld[0] = fp16_sqsum_bypass_en & sum2itp_pvld & (&fp17to32_in_rdy[3:1]);
assign fp17to32_in_vld[1] = fp16_sqsum_bypass_en & sum2itp_pvld & (&{fp17to32_in_rdy[3:2],fp17to32_in_rdy[0]});
assign fp17to32_in_vld[2] = fp16_sqsum_bypass_en & sum2itp_pvld & (&{fp17to32_in_rdy[3],fp17to32_in_rdy[1:0]});
assign fp17to32_in_vld[3] = fp16_sqsum_bypass_en & sum2itp_pvld & (&fp17to32_in_rdy[2:0]);

//fp17 switch to fp32 when fp16_sqsum_bypass_en
assign fp17to32_in_pd_0   = {17{fp16_sqsum_bypass_en}} & sum2itp_pd[42*0+16:42*0]; 
HLS_fp17_to_fp32 u_fp17to32_0 (
   .nvdla_core_clk             (nvdla_op_gated_clk_fp16)         //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                 //|< i
  ,.chn_a_rsc_z                (fp17to32_in_pd_0[16:0])          //|< w
  ,.chn_a_rsc_vz               (fp17to32_in_vld[0])              //|< w
  ,.chn_a_rsc_lz               (fp17to32_in_rdy[0])              //|> w
  ,.chn_o_rsc_z                (fp17to32_out_pd_0[31:0])         //|> w
  ,.chn_o_rsc_vz               (fp17to32_out_rdy[0])             //|< w
  ,.chn_o_rsc_lz               (fp17to32_out_vld[0])             //|> w
  );
assign fp17to32_in_pd_1   = {17{fp16_sqsum_bypass_en}} & sum2itp_pd[42*1+16:42*1]; 
HLS_fp17_to_fp32 u_fp17to32_1 (
   .nvdla_core_clk             (nvdla_op_gated_clk_fp16)         //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                 //|< i
  ,.chn_a_rsc_z                (fp17to32_in_pd_1[16:0])          //|< w
  ,.chn_a_rsc_vz               (fp17to32_in_vld[1])              //|< w
  ,.chn_a_rsc_lz               (fp17to32_in_rdy[1])              //|> w
  ,.chn_o_rsc_z                (fp17to32_out_pd_1[31:0])         //|> w
  ,.chn_o_rsc_vz               (fp17to32_out_rdy[1])             //|< w
  ,.chn_o_rsc_lz               (fp17to32_out_vld[1])             //|> w
  );
assign fp17to32_in_pd_2   = {17{fp16_sqsum_bypass_en}} & sum2itp_pd[42*2+16:42*2]; 
HLS_fp17_to_fp32 u_fp17to32_2 (
   .nvdla_core_clk             (nvdla_op_gated_clk_fp16)         //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                 //|< i
  ,.chn_a_rsc_z                (fp17to32_in_pd_2[16:0])          //|< w
  ,.chn_a_rsc_vz               (fp17to32_in_vld[2])              //|< w
  ,.chn_a_rsc_lz               (fp17to32_in_rdy[2])              //|> w
  ,.chn_o_rsc_z                (fp17to32_out_pd_2[31:0])         //|> w
  ,.chn_o_rsc_vz               (fp17to32_out_rdy[2])             //|< w
  ,.chn_o_rsc_lz               (fp17to32_out_vld[2])             //|> w
  );
assign fp17to32_in_pd_3   = {17{fp16_sqsum_bypass_en}} & sum2itp_pd[42*3+16:42*3]; 
HLS_fp17_to_fp32 u_fp17to32_3 (
   .nvdla_core_clk             (nvdla_op_gated_clk_fp16)         //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                 //|< i
  ,.chn_a_rsc_z                (fp17to32_in_pd_3[16:0])          //|< w
  ,.chn_a_rsc_vz               (fp17to32_in_vld[3])              //|< w
  ,.chn_a_rsc_lz               (fp17to32_in_rdy[3])              //|> w
  ,.chn_o_rsc_z                (fp17to32_out_pd_3[31:0])         //|> w
  ,.chn_o_rsc_vz               (fp17to32_out_rdy[3])             //|< w
  ,.chn_o_rsc_lz               (fp17to32_out_vld[3])             //|> w
  );

assign fp17to32_out_rdy[0] = fp16_sqsum_bypass_en ? (sum2itp_prdy_f & (&fp17to32_out_vld[3:1])) : 1'b1;
assign fp17to32_out_rdy[1] = fp16_sqsum_bypass_en ? (sum2itp_prdy_f & (&{fp17to32_out_vld[3:2],fp17to32_out_vld[0]})) : 1'b1;
assign fp17to32_out_rdy[2] = fp16_sqsum_bypass_en ? (sum2itp_prdy_f & (&{fp17to32_out_vld[3],fp17to32_out_vld[1:0]})) : 1'b1;
assign fp17to32_out_rdy[3] = fp16_sqsum_bypass_en ? (sum2itp_prdy_f & (&fp17to32_out_vld[2:0])) : 1'b1;

/////////////////////////////
assign sum2itp_pd_f = fp16_sqsum_bypass_en ? {{{10{fp17to32_out_pd_3[31]}}, fp17to32_out_pd_3[31:0]},{{10{fp17to32_out_pd_2[31]}}, fp17to32_out_pd_2[31:0]},
                                              {{10{fp17to32_out_pd_1[31]}}, fp17to32_out_pd_1[31:0]},{{10{fp17to32_out_pd_0[31]}}, fp17to32_out_pd_0[31:0]}}
                                              : sum2itp_pd[167:0];
assign sum2itp_pvld_f = fp16_sqsum_bypass_en ? (&fp17to32_out_vld) : sum2itp_pvld;
//////////////////////////////////////////////////////////////////////
///////////////////////////////////////////
//from intp_ctrl input port to sync fifo for interpolation
assign sum2sync_pvld = sum2itp_pvld_f & sum2itp_prdy_3 & sum2itp_prdy_2 & sum2itp_prdy_1 & sum2itp_prdy_0;
assign sum2sync_pd   = sum2itp_pd_f[167:0];
///////////////////////////////////////////
assign sum2itp_prdy_f = sum2itp_prdy_3 & sum2itp_prdy_2 & sum2itp_prdy_1 & sum2itp_prdy_0 & sum2sync_prdy;
assign sum2itp_pvld_0 = sum2itp_pvld_f & sum2itp_prdy_3 & sum2itp_prdy_2 & sum2itp_prdy_1 & sum2sync_prdy;
assign sum2itp_pvld_1 = sum2itp_pvld_f & sum2itp_prdy_3 & sum2itp_prdy_2 & sum2itp_prdy_0 & sum2sync_prdy;
assign sum2itp_pvld_2 = sum2itp_pvld_f & sum2itp_prdy_3 & sum2itp_prdy_1 & sum2itp_prdy_0 & sum2sync_prdy;
assign sum2itp_pvld_3 = sum2itp_pvld_f & sum2itp_prdy_2 & sum2itp_prdy_1 & sum2itp_prdy_0 & sum2sync_prdy;
assign sum2itp_pd_0 = sum2itp_pd_f[41:0];
assign sum2itp_pd_1 = sum2itp_pd_f[83:42];
assign sum2itp_pd_2 = sum2itp_pd_f[125:84];
assign sum2itp_pd_3 = sum2itp_pd_f[167:126];

NV_NVDLA_CDP_DP_LUT_CTRL_unit u_LUT_CTRL_unit0 (
   .nvdla_core_clk             (nvdla_core_clk)                  //|< i
  ,.nvdla_op_gated_clk_fp16    (nvdla_op_gated_clk_fp16)         //|< i
  ,.nvdla_op_gated_clk_int     (nvdla_op_gated_clk_int)          //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                 //|< i
  ,.dp2lut_prdy                (dp2lut_prdy_0)                   //|< w
  ,.fp16_en                    (fp16_en)                         //|< i
  ,.int16_en                   (int16_en)                        //|< i
  ,.int8_en                    (int8_en)                         //|< i
  ,.reg2dp_lut_le_function     (reg2dp_lut_le_function)          //|< i
  ,.reg2dp_lut_le_index_offset (reg2dp_lut_le_index_offset[7:0]) //|< i
  ,.reg2dp_lut_le_index_select (reg2dp_lut_le_index_select[7:0]) //|< i
  ,.reg2dp_lut_le_start_high   (reg2dp_lut_le_start_high[5:0])   //|< i
  ,.reg2dp_lut_le_start_low    (reg2dp_lut_le_start_low[31:0])   //|< i
  ,.reg2dp_lut_lo_index_select (reg2dp_lut_lo_index_select[7:0]) //|< i
  ,.reg2dp_lut_lo_start_high   (reg2dp_lut_lo_start_high[5:0])   //|< i
  ,.reg2dp_lut_lo_start_low    (reg2dp_lut_lo_start_low[31:0])   //|< i
  ,.reg2dp_sqsum_bypass        (reg2dp_sqsum_bypass)             //|< i
  ,.sum2itp_pd                 (sum2itp_pd_0[41:0])              //|< w
  ,.sum2itp_pvld               (sum2itp_pvld_0)                  //|< w
  ,.dp2lut_X_info              (dp2lut_X_info_0[35:0])           //|> w
  ,.dp2lut_X_pd                (dp2lut_X_pd_0[19:0])             //|> w
  ,.dp2lut_Y_info              (dp2lut_Y_info_0[35:0])           //|> w
  ,.dp2lut_Y_pd                (dp2lut_Y_pd_0[19:0])             //|> w
  ,.dp2lut_pvld                (dp2lut_pvld_0)                   //|> w
  ,.sum2itp_prdy               (sum2itp_prdy_0)                  //|> w
  );

NV_NVDLA_CDP_DP_LUT_CTRL_unit u_LUT_CTRL_unit1 (
   .nvdla_core_clk             (nvdla_core_clk)                  //|< i
  ,.nvdla_op_gated_clk_fp16    (nvdla_op_gated_clk_fp16)         //|< i
  ,.nvdla_op_gated_clk_int     (nvdla_op_gated_clk_int)          //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                 //|< i
  ,.dp2lut_prdy                (dp2lut_prdy_1)                   //|< w
  ,.fp16_en                    (fp16_en)                         //|< i
  ,.int16_en                   (int16_en)                        //|< i
  ,.int8_en                    (int8_en)                         //|< i
  ,.reg2dp_lut_le_function     (reg2dp_lut_le_function)          //|< i
  ,.reg2dp_lut_le_index_offset (reg2dp_lut_le_index_offset[7:0]) //|< i
  ,.reg2dp_lut_le_index_select (reg2dp_lut_le_index_select[7:0]) //|< i
  ,.reg2dp_lut_le_start_high   (reg2dp_lut_le_start_high[5:0])   //|< i
  ,.reg2dp_lut_le_start_low    (reg2dp_lut_le_start_low[31:0])   //|< i
  ,.reg2dp_lut_lo_index_select (reg2dp_lut_lo_index_select[7:0]) //|< i
  ,.reg2dp_lut_lo_start_high   (reg2dp_lut_lo_start_high[5:0])   //|< i
  ,.reg2dp_lut_lo_start_low    (reg2dp_lut_lo_start_low[31:0])   //|< i
  ,.reg2dp_sqsum_bypass        (reg2dp_sqsum_bypass)             //|< i
  ,.sum2itp_pd                 (sum2itp_pd_1[41:0])              //|< w
  ,.sum2itp_pvld               (sum2itp_pvld_1)                  //|< w
  ,.dp2lut_X_info              (dp2lut_X_info_1[35:0])           //|> w
  ,.dp2lut_X_pd                (dp2lut_X_pd_1[19:0])             //|> w
  ,.dp2lut_Y_info              (dp2lut_Y_info_1[35:0])           //|> w
  ,.dp2lut_Y_pd                (dp2lut_Y_pd_1[19:0])             //|> w
  ,.dp2lut_pvld                (dp2lut_pvld_1)                   //|> w
  ,.sum2itp_prdy               (sum2itp_prdy_1)                  //|> w
  );

NV_NVDLA_CDP_DP_LUT_CTRL_unit u_LUT_CTRL_unit2 (
   .nvdla_core_clk             (nvdla_core_clk)                  //|< i
  ,.nvdla_op_gated_clk_fp16    (nvdla_op_gated_clk_fp16)         //|< i
  ,.nvdla_op_gated_clk_int     (nvdla_op_gated_clk_int)          //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                 //|< i
  ,.dp2lut_prdy                (dp2lut_prdy_2)                   //|< w
  ,.fp16_en                    (fp16_en)                         //|< i
  ,.int16_en                   (int16_en)                        //|< i
  ,.int8_en                    (int8_en)                         //|< i
  ,.reg2dp_lut_le_function     (reg2dp_lut_le_function)          //|< i
  ,.reg2dp_lut_le_index_offset (reg2dp_lut_le_index_offset[7:0]) //|< i
  ,.reg2dp_lut_le_index_select (reg2dp_lut_le_index_select[7:0]) //|< i
  ,.reg2dp_lut_le_start_high   (reg2dp_lut_le_start_high[5:0])   //|< i
  ,.reg2dp_lut_le_start_low    (reg2dp_lut_le_start_low[31:0])   //|< i
  ,.reg2dp_lut_lo_index_select (reg2dp_lut_lo_index_select[7:0]) //|< i
  ,.reg2dp_lut_lo_start_high   (reg2dp_lut_lo_start_high[5:0])   //|< i
  ,.reg2dp_lut_lo_start_low    (reg2dp_lut_lo_start_low[31:0])   //|< i
  ,.reg2dp_sqsum_bypass        (reg2dp_sqsum_bypass)             //|< i
  ,.sum2itp_pd                 (sum2itp_pd_2[41:0])              //|< w
  ,.sum2itp_pvld               (sum2itp_pvld_2)                  //|< w
  ,.dp2lut_X_info              (dp2lut_X_info_2[35:0])           //|> w
  ,.dp2lut_X_pd                (dp2lut_X_pd_2[19:0])             //|> w
  ,.dp2lut_Y_info              (dp2lut_Y_info_2[35:0])           //|> w
  ,.dp2lut_Y_pd                (dp2lut_Y_pd_2[19:0])             //|> w
  ,.dp2lut_pvld                (dp2lut_pvld_2)                   //|> w
  ,.sum2itp_prdy               (sum2itp_prdy_2)                  //|> w
  );

NV_NVDLA_CDP_DP_LUT_CTRL_unit u_LUT_CTRL_unit3 (
   .nvdla_core_clk             (nvdla_core_clk)                  //|< i
  ,.nvdla_op_gated_clk_fp16    (nvdla_op_gated_clk_fp16)         //|< i
  ,.nvdla_op_gated_clk_int     (nvdla_op_gated_clk_int)          //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                 //|< i
  ,.dp2lut_prdy                (dp2lut_prdy_3)                   //|< w
  ,.fp16_en                    (fp16_en)                         //|< i
  ,.int16_en                   (int16_en)                        //|< i
  ,.int8_en                    (int8_en)                         //|< i
  ,.reg2dp_lut_le_function     (reg2dp_lut_le_function)          //|< i
  ,.reg2dp_lut_le_index_offset (reg2dp_lut_le_index_offset[7:0]) //|< i
  ,.reg2dp_lut_le_index_select (reg2dp_lut_le_index_select[7:0]) //|< i
  ,.reg2dp_lut_le_start_high   (reg2dp_lut_le_start_high[5:0])   //|< i
  ,.reg2dp_lut_le_start_low    (reg2dp_lut_le_start_low[31:0])   //|< i
  ,.reg2dp_lut_lo_index_select (reg2dp_lut_lo_index_select[7:0]) //|< i
  ,.reg2dp_lut_lo_start_high   (reg2dp_lut_lo_start_high[5:0])   //|< i
  ,.reg2dp_lut_lo_start_low    (reg2dp_lut_lo_start_low[31:0])   //|< i
  ,.reg2dp_sqsum_bypass        (reg2dp_sqsum_bypass)             //|< i
  ,.sum2itp_pd                 (sum2itp_pd_3[41:0])              //|< w
  ,.sum2itp_pvld               (sum2itp_pvld_3)                  //|< w
  ,.dp2lut_X_info              (dp2lut_X_info_3[35:0])           //|> w
  ,.dp2lut_X_pd                (dp2lut_X_pd_3[19:0])             //|> w
  ,.dp2lut_Y_info              (dp2lut_Y_info_3[35:0])           //|> w
  ,.dp2lut_Y_pd                (dp2lut_Y_pd_3[19:0])             //|> w
  ,.dp2lut_pvld                (dp2lut_pvld_3)                   //|> w
  ,.sum2itp_prdy               (sum2itp_prdy_3)                  //|> w
  );


assign dp2lut_X_entry_0 = dp2lut_X_pd_0[9:0];
assign dp2lut_X_entry_4 = dp2lut_X_pd_0[19:10];
assign dp2lut_X_entry_1 = dp2lut_X_pd_1[9:0];
assign dp2lut_X_entry_5 = dp2lut_X_pd_1[19:10];
assign dp2lut_X_entry_2 = dp2lut_X_pd_2[9:0];
assign dp2lut_X_entry_6 = dp2lut_X_pd_2[19:10];
assign dp2lut_X_entry_3 = dp2lut_X_pd_3[9:0];
assign dp2lut_X_entry_7 = dp2lut_X_pd_3[19:10];
assign dp2lut_Y_entry_0 = dp2lut_Y_pd_0[9:0];
assign dp2lut_Y_entry_4 = dp2lut_Y_pd_0[19:10];
assign dp2lut_Y_entry_1 = dp2lut_Y_pd_1[9:0];
assign dp2lut_Y_entry_5 = dp2lut_Y_pd_1[19:10];
assign dp2lut_Y_entry_2 = dp2lut_Y_pd_2[9:0];
assign dp2lut_Y_entry_6 = dp2lut_Y_pd_2[19:10];
assign dp2lut_Y_entry_3 = dp2lut_Y_pd_3[9:0];
assign dp2lut_Y_entry_7 = dp2lut_Y_pd_3[19:10];

assign dp2lut_Xinfo_0 = {dp2lut_X_info_0[34],dp2lut_X_info_0[32],dp2lut_X_info_0[15:0]};
assign dp2lut_Xinfo_4 = {dp2lut_X_info_0[35],dp2lut_X_info_0[33],dp2lut_X_info_0[31:16]};
assign dp2lut_Xinfo_1 = {dp2lut_X_info_1[34],dp2lut_X_info_1[32],dp2lut_X_info_1[15:0]};
assign dp2lut_Xinfo_5 = {dp2lut_X_info_1[35],dp2lut_X_info_1[33],dp2lut_X_info_1[31:16]};
assign dp2lut_Xinfo_2 = {dp2lut_X_info_2[34],dp2lut_X_info_2[32],dp2lut_X_info_2[15:0]};
assign dp2lut_Xinfo_6 = {dp2lut_X_info_2[35],dp2lut_X_info_2[33],dp2lut_X_info_2[31:16]};
assign dp2lut_Xinfo_3 = {dp2lut_X_info_3[34],dp2lut_X_info_3[32],dp2lut_X_info_3[15:0]};
assign dp2lut_Xinfo_7 = {dp2lut_X_info_3[35],dp2lut_X_info_3[33],dp2lut_X_info_3[31:16]};

assign dp2lut_Yinfo_0 = {dp2lut_Y_info_0[34],dp2lut_Y_info_0[32],dp2lut_Y_info_0[15:0]};
assign dp2lut_Yinfo_4 = {dp2lut_Y_info_0[35],dp2lut_Y_info_0[33],dp2lut_Y_info_0[31:16]};
assign dp2lut_Yinfo_1 = {dp2lut_Y_info_1[34],dp2lut_Y_info_1[32],dp2lut_Y_info_1[15:0]};
assign dp2lut_Yinfo_5 = {dp2lut_Y_info_1[35],dp2lut_Y_info_1[33],dp2lut_Y_info_1[31:16]};
assign dp2lut_Yinfo_2 = {dp2lut_Y_info_2[34],dp2lut_Y_info_2[32],dp2lut_Y_info_2[15:0]};
assign dp2lut_Yinfo_6 = {dp2lut_Y_info_2[35],dp2lut_Y_info_2[33],dp2lut_Y_info_2[31:16]};
assign dp2lut_Yinfo_3 = {dp2lut_Y_info_3[34],dp2lut_Y_info_3[32],dp2lut_Y_info_3[15:0]};
assign dp2lut_Yinfo_7 = {dp2lut_Y_info_3[35],dp2lut_Y_info_3[33],dp2lut_Y_info_3[31:16]};

assign dp2lut_prdy_0 = dp2lut_prdy & dp2lut_pvld_3 & dp2lut_pvld_2 & dp2lut_pvld_1;
assign dp2lut_prdy_1 = dp2lut_prdy & dp2lut_pvld_3 & dp2lut_pvld_2 & dp2lut_pvld_0;
assign dp2lut_prdy_2 = dp2lut_prdy & dp2lut_pvld_3 & dp2lut_pvld_1 & dp2lut_pvld_0;
assign dp2lut_prdy_3 = dp2lut_prdy & dp2lut_pvld_2 & dp2lut_pvld_1 & dp2lut_pvld_0;
assign dp2lut_pvld = dp2lut_pvld_3 & dp2lut_pvld_2 & dp2lut_pvld_1 & dp2lut_pvld_0;

///////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_LUT_ctrl


