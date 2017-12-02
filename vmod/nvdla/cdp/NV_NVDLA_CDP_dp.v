// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_dp.v

module NV_NVDLA_CDP_dp (
   nvdla_core_clk                  //|< i
  ,nvdla_core_rstn                 //|< i
  ,cdp_dp2wdma_ready               //|< i
  ,cdp_rdma2dp_pd                  //|< i
  ,cdp_rdma2dp_valid               //|< i
  ,dp2reg_done                     //|< i
  ,nvdla_core_clk_orig             //|< i
  ,nvdla_op_gated_clk_fp16         //|< i
  ,nvdla_op_gated_clk_int          //|< i
  ,pwrbus_ram_pd                   //|< i
  ,reg2dp_datin_offset             //|< i
  ,reg2dp_datin_scale              //|< i
  ,reg2dp_datin_shifter            //|< i
  ,reg2dp_datout_offset            //|< i
  ,reg2dp_datout_scale             //|< i
  ,reg2dp_datout_shifter           //|< i
  ,reg2dp_input_data_type          //|< i
  ,reg2dp_lut_access_type          //|< i
  ,reg2dp_lut_addr                 //|< i
  ,reg2dp_lut_data                 //|< i
  ,reg2dp_lut_data_trigger         //|< i
  ,reg2dp_lut_hybrid_priority      //|< i
  ,reg2dp_lut_le_end_high          //|< i
  ,reg2dp_lut_le_end_low           //|< i
  ,reg2dp_lut_le_function          //|< i
  ,reg2dp_lut_le_index_offset      //|< i
  ,reg2dp_lut_le_index_select      //|< i
  ,reg2dp_lut_le_slope_oflow_scale //|< i
  ,reg2dp_lut_le_slope_oflow_shift //|< i
  ,reg2dp_lut_le_slope_uflow_scale //|< i
  ,reg2dp_lut_le_slope_uflow_shift //|< i
  ,reg2dp_lut_le_start_high        //|< i
  ,reg2dp_lut_le_start_low         //|< i
  ,reg2dp_lut_lo_end_high          //|< i
  ,reg2dp_lut_lo_end_low           //|< i
  ,reg2dp_lut_lo_index_select      //|< i
  ,reg2dp_lut_lo_slope_oflow_scale //|< i
  ,reg2dp_lut_lo_slope_oflow_shift //|< i
  ,reg2dp_lut_lo_slope_uflow_scale //|< i
  ,reg2dp_lut_lo_slope_uflow_shift //|< i
  ,reg2dp_lut_lo_start_high        //|< i
  ,reg2dp_lut_lo_start_low         //|< i
  ,reg2dp_lut_oflow_priority       //|< i
  ,reg2dp_lut_table_id             //|< i
  ,reg2dp_lut_uflow_priority       //|< i
  ,reg2dp_mul_bypass               //|< i
  ,reg2dp_normalz_len              //|< i
  ,reg2dp_sqsum_bypass             //|< i
  ,cdp_dp2wdma_pd                  //|> o
  ,cdp_dp2wdma_valid               //|> o
  ,cdp_rdma2dp_ready               //|> o
  ,dp2reg_d0_out_saturation        //|> o
  ,dp2reg_d0_perf_lut_hybrid       //|> o
  ,dp2reg_d0_perf_lut_le_hit       //|> o
  ,dp2reg_d0_perf_lut_lo_hit       //|> o
  ,dp2reg_d0_perf_lut_oflow        //|> o
  ,dp2reg_d0_perf_lut_uflow        //|> o
  ,dp2reg_d1_out_saturation        //|> o
  ,dp2reg_d1_perf_lut_hybrid       //|> o
  ,dp2reg_d1_perf_lut_le_hit       //|> o
  ,dp2reg_d1_perf_lut_lo_hit       //|> o
  ,dp2reg_d1_perf_lut_oflow        //|> o
  ,dp2reg_d1_perf_lut_uflow        //|> o
  ,dp2reg_lut_data                 //|> o
  );

//&Clock nvdla_core_clk;
//&Reset nvdla_core_rstn;
input   [31:0] pwrbus_ram_pd;
input          dp2reg_done;
input   [15:0] reg2dp_datin_offset;
input   [15:0] reg2dp_datin_scale;
input    [4:0] reg2dp_datin_shifter;
input   [31:0] reg2dp_datout_offset;
input   [15:0] reg2dp_datout_scale;
input    [5:0] reg2dp_datout_shifter;
input    [1:0] reg2dp_input_data_type;
input          reg2dp_lut_access_type;
input    [9:0] reg2dp_lut_addr;
input   [15:0] reg2dp_lut_data;
input          reg2dp_lut_data_trigger;
input          reg2dp_lut_hybrid_priority;
input    [5:0] reg2dp_lut_le_end_high;
input   [31:0] reg2dp_lut_le_end_low;
input          reg2dp_lut_le_function;
input    [7:0] reg2dp_lut_le_index_offset;
input    [7:0] reg2dp_lut_le_index_select;
input   [15:0] reg2dp_lut_le_slope_oflow_scale;
input    [4:0] reg2dp_lut_le_slope_oflow_shift;
input   [15:0] reg2dp_lut_le_slope_uflow_scale;
input    [4:0] reg2dp_lut_le_slope_uflow_shift;
input    [5:0] reg2dp_lut_le_start_high;
input   [31:0] reg2dp_lut_le_start_low;
input    [5:0] reg2dp_lut_lo_end_high;
input   [31:0] reg2dp_lut_lo_end_low;
input    [7:0] reg2dp_lut_lo_index_select;
input   [15:0] reg2dp_lut_lo_slope_oflow_scale;
input    [4:0] reg2dp_lut_lo_slope_oflow_shift;
input   [15:0] reg2dp_lut_lo_slope_uflow_scale;
input    [4:0] reg2dp_lut_lo_slope_uflow_shift;
input    [5:0] reg2dp_lut_lo_start_high;
input   [31:0] reg2dp_lut_lo_start_low;
input          reg2dp_lut_oflow_priority;
input          reg2dp_lut_table_id;
input          reg2dp_lut_uflow_priority;
input          reg2dp_mul_bypass;
input    [1:0] reg2dp_normalz_len;
input          reg2dp_sqsum_bypass;
output  [31:0] dp2reg_d0_out_saturation;
output  [31:0] dp2reg_d0_perf_lut_hybrid;
output  [31:0] dp2reg_d0_perf_lut_le_hit;
output  [31:0] dp2reg_d0_perf_lut_lo_hit;
output  [31:0] dp2reg_d0_perf_lut_oflow;
output  [31:0] dp2reg_d0_perf_lut_uflow;
output  [31:0] dp2reg_d1_out_saturation;
output  [31:0] dp2reg_d1_perf_lut_hybrid;
output  [31:0] dp2reg_d1_perf_lut_le_hit;
output  [31:0] dp2reg_d1_perf_lut_lo_hit;
output  [31:0] dp2reg_d1_perf_lut_oflow;
output  [31:0] dp2reg_d1_perf_lut_uflow;
output  [15:0] dp2reg_lut_data;
//
// NV_NVDLA_CDP_core_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         cdp_rdma2dp_valid;  /* data valid */
output        cdp_rdma2dp_ready;  /* data return handshake */
input  [86:0] cdp_rdma2dp_pd;

output        cdp_dp2wdma_valid;  /* data valid */
input         cdp_dp2wdma_ready;  /* data return handshake */
output [78:0] cdp_dp2wdma_pd;

input   nvdla_core_clk_orig;
input   nvdla_op_gated_clk_fp16;
input   nvdla_op_gated_clk_int;
reg            fp16_en;
reg            int16_en;
reg            int8_en;
reg            sqsum_bypass_en;
wire    [86:0] bufin_pd;
wire           bufin_prdy;
wire           bufin_pvld;
wire    [86:0] cvt2buf_pd;
wire           cvt2buf_prdy;
wire           cvt2buf_pvld;
wire    [86:0] cvt2sync_pd;
wire           cvt2sync_prdy;
wire           cvt2sync_pvld;
wire    [16:0] cvtin_out_16_0;
wire    [16:0] cvtin_out_16_1;
wire    [16:0] cvtin_out_16_2;
wire    [16:0] cvtin_out_16_3;
wire   [167:0] cvtin_out_16_ext;
wire     [8:0] cvtin_out_int8_0;
wire     [8:0] cvtin_out_int8_1;
wire     [8:0] cvtin_out_int8_2;
wire     [8:0] cvtin_out_int8_3;
wire     [8:0] cvtin_out_int8_4;
wire     [8:0] cvtin_out_int8_5;
wire     [8:0] cvtin_out_int8_6;
wire     [8:0] cvtin_out_int8_7;
wire   [167:0] cvtin_out_int8_ext;
wire     [9:0] dp2lut_X_entry_0;
wire     [9:0] dp2lut_X_entry_1;
wire     [9:0] dp2lut_X_entry_2;
wire     [9:0] dp2lut_X_entry_3;
wire     [9:0] dp2lut_X_entry_4;
wire     [9:0] dp2lut_X_entry_5;
wire     [9:0] dp2lut_X_entry_6;
wire     [9:0] dp2lut_X_entry_7;
wire    [17:0] dp2lut_Xinfo_0;
wire    [17:0] dp2lut_Xinfo_1;
wire    [17:0] dp2lut_Xinfo_2;
wire    [17:0] dp2lut_Xinfo_3;
wire    [17:0] dp2lut_Xinfo_4;
wire    [17:0] dp2lut_Xinfo_5;
wire    [17:0] dp2lut_Xinfo_6;
wire    [17:0] dp2lut_Xinfo_7;
wire     [9:0] dp2lut_Y_entry_0;
wire     [9:0] dp2lut_Y_entry_1;
wire     [9:0] dp2lut_Y_entry_2;
wire     [9:0] dp2lut_Y_entry_3;
wire     [9:0] dp2lut_Y_entry_4;
wire     [9:0] dp2lut_Y_entry_5;
wire     [9:0] dp2lut_Y_entry_6;
wire     [9:0] dp2lut_Y_entry_7;
wire    [17:0] dp2lut_Yinfo_0;
wire    [17:0] dp2lut_Yinfo_1;
wire    [17:0] dp2lut_Yinfo_2;
wire    [17:0] dp2lut_Yinfo_3;
wire    [17:0] dp2lut_Yinfo_4;
wire    [17:0] dp2lut_Yinfo_5;
wire    [17:0] dp2lut_Yinfo_6;
wire    [17:0] dp2lut_Yinfo_7;
wire           dp2lut_prdy;
wire           dp2lut_pvld;
wire    [16:0] intp2mul_pd_0;
wire    [16:0] intp2mul_pd_1;
wire    [16:0] intp2mul_pd_2;
wire    [16:0] intp2mul_pd_3;
wire    [16:0] intp2mul_pd_4;
wire    [16:0] intp2mul_pd_5;
wire    [16:0] intp2mul_pd_6;
wire    [16:0] intp2mul_pd_7;
wire           intp2mul_prdy;
wire           intp2mul_pvld;
wire    [31:0] lut2intp_X_data_00;
wire    [16:0] lut2intp_X_data_00_17b;
wire    [31:0] lut2intp_X_data_01;
wire    [31:0] lut2intp_X_data_10;
wire    [16:0] lut2intp_X_data_10_17b;
wire    [31:0] lut2intp_X_data_11;
wire    [31:0] lut2intp_X_data_20;
wire    [16:0] lut2intp_X_data_20_17b;
wire    [31:0] lut2intp_X_data_21;
wire    [31:0] lut2intp_X_data_30;
wire    [16:0] lut2intp_X_data_30_17b;
wire    [31:0] lut2intp_X_data_31;
wire    [31:0] lut2intp_X_data_40;
wire    [16:0] lut2intp_X_data_40_17b;
wire    [31:0] lut2intp_X_data_41;
wire    [31:0] lut2intp_X_data_50;
wire    [16:0] lut2intp_X_data_50_17b;
wire    [31:0] lut2intp_X_data_51;
wire    [31:0] lut2intp_X_data_60;
wire    [16:0] lut2intp_X_data_60_17b;
wire    [31:0] lut2intp_X_data_61;
wire    [31:0] lut2intp_X_data_70;
wire    [16:0] lut2intp_X_data_70_17b;
wire    [31:0] lut2intp_X_data_71;
wire    [19:0] lut2intp_X_info_0;
wire    [19:0] lut2intp_X_info_1;
wire    [19:0] lut2intp_X_info_2;
wire    [19:0] lut2intp_X_info_3;
wire    [19:0] lut2intp_X_info_4;
wire    [19:0] lut2intp_X_info_5;
wire    [19:0] lut2intp_X_info_6;
wire    [19:0] lut2intp_X_info_7;
wire     [7:0] lut2intp_X_sel;
wire     [7:0] lut2intp_Y_sel;
wire           lut2intp_prdy;
wire           lut2intp_pvld;
wire   [167:0] lutctrl_in_pd;
wire           lutctrl_in_pvld;
wire   [167:0] lutctrl_in_sqsum_bypass;
wire   [199:0] mul2ocvt_pd;
wire           mul2ocvt_prdy;
wire           mul2ocvt_pvld;
wire   [230:0] normalz_buf_data;
wire           normalz_buf_data_prdy;
wire           normalz_buf_data_pvld;
wire   [167:0] sum2itp_pd;
wire           sum2itp_prdy;
wire           sum2itp_pvld;
wire   [167:0] sum2sync_pd;
wire           sum2sync_prdy;
wire           sum2sync_pvld;
wire   [167:0] sync2itp_pd;
wire           sync2itp_prdy;
wire           sync2itp_pvld;
wire    [71:0] sync2mul_pd;
wire           sync2mul_prdy;
wire           sync2mul_pvld;
wire    [14:0] sync2ocvt_pd;
wire           sync2ocvt_prdy;
wire           sync2ocvt_pvld;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int16_en <= 1'b0;
  end else begin
  int16_en <= reg2dp_input_data_type[1:0] == 1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_en <= 1'b0;
  end else begin
  int8_en <= reg2dp_input_data_type[1:0] == 0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp16_en <= 1'b0;
  end else begin
  fp16_en <= reg2dp_input_data_type[1:0] == 2;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sqsum_bypass_en <= 1'b0;
  end else begin
  sqsum_bypass_en <= reg2dp_sqsum_bypass == 1'h1;
  end
end
//===== convertor_in Instance========
assign cvt2buf_prdy = sqsum_bypass_en ? sum2itp_prdy : bufin_prdy;
NV_NVDLA_CDP_DP_cvtin u_NV_NVDLA_CDP_DP_cvtin (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.cdp_rdma2dp_pd                  (cdp_rdma2dp_pd[86:0])                  //|< i
  ,.cdp_rdma2dp_valid               (cdp_rdma2dp_valid)                     //|< i
  ,.cvt2buf_prdy                    (cvt2buf_prdy)                          //|< w
  ,.cvt2sync_prdy                   (cvt2sync_prdy)                         //|< w
  ,.reg2dp_datin_offset             (reg2dp_datin_offset[15:0])             //|< i
  ,.reg2dp_datin_scale              (reg2dp_datin_scale[15:0])              //|< i
  ,.reg2dp_datin_shifter            (reg2dp_datin_shifter[4:0])             //|< i
  ,.reg2dp_input_data_type          (reg2dp_input_data_type[1:0])           //|< i
  ,.cdp_rdma2dp_ready               (cdp_rdma2dp_ready)                     //|> o
  ,.cvt2buf_pd                      (cvt2buf_pd[86:0])                      //|> w
  ,.cvt2buf_pvld                    (cvt2buf_pvld)                          //|> w
  ,.cvt2sync_pd                     (cvt2sync_pd[86:0])                     //|> w
  ,.cvt2sync_pvld                   (cvt2sync_pvld)                         //|> w
  );

//===== sync fifo Instance========
NV_NVDLA_CDP_DP_syncfifo u_NV_NVDLA_CDP_DP_syncfifo (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.cvt2sync_pd                     (cvt2sync_pd[86:0])                     //|< w
  ,.cvt2sync_pvld                   (cvt2sync_pvld)                         //|< w
  ,.pwrbus_ram_pd                   (pwrbus_ram_pd[31:0])                   //|< i
  ,.sum2sync_pd                     (sum2sync_pd[167:0])                    //|< w
  ,.sum2sync_pvld                   (sum2sync_pvld)                         //|< w
  ,.sync2itp_prdy                   (sync2itp_prdy)                         //|< w
  ,.sync2mul_prdy                   (sync2mul_prdy)                         //|< w
  ,.sync2ocvt_prdy                  (sync2ocvt_prdy)                        //|< w
  ,.cvt2sync_prdy                   (cvt2sync_prdy)                         //|> w
  ,.sum2sync_prdy                   (sum2sync_prdy)                         //|> w
  ,.sync2itp_pd                     (sync2itp_pd[167:0])                    //|> w
  ,.sync2itp_pvld                   (sync2itp_pvld)                         //|> w
  ,.sync2mul_pd                     (sync2mul_pd[71:0])                     //|> w
  ,.sync2mul_pvld                   (sync2mul_pvld)                         //|> w
  ,.sync2ocvt_pd                    (sync2ocvt_pd[14:0])                    //|> w
  ,.sync2ocvt_pvld                  (sync2ocvt_pvld)                        //|> w
  );

//===== Buffer_in Instance========
assign bufin_pd   = sqsum_bypass_en ? 0 : cvt2buf_pd;
assign bufin_pvld = sqsum_bypass_en ? 0 : cvt2buf_pvld;
NV_NVDLA_CDP_DP_bufferin u_NV_NVDLA_CDP_DP_bufferin (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.cdp_rdma2dp_pd                  (bufin_pd[86:0])                        //|< w
  ,.cdp_rdma2dp_valid               (bufin_pvld)                            //|< w
  ,.normalz_buf_data_prdy           (normalz_buf_data_prdy)                 //|< w
  ,.cdp_rdma2dp_ready               (bufin_prdy)                            //|> w
  ,.normalz_buf_data                (normalz_buf_data[230:0])               //|> w
  ,.normalz_buf_data_pvld           (normalz_buf_data_pvld)                 //|> w
  );

//===== sigma squre Instance========
NV_NVDLA_CDP_DP_sum u_NV_NVDLA_CDP_DP_sum (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_op_gated_clk_int          (nvdla_op_gated_clk_int)                //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.fp16_en                         (fp16_en)                               //|< r
  ,.int16_en                        (int16_en)                              //|< r
  ,.int8_en                         (int8_en)                               //|< r
  ,.normalz_buf_data                (normalz_buf_data[230:0])               //|< w
  ,.normalz_buf_data_pvld           (normalz_buf_data_pvld)                 //|< w
  ,.nvdla_op_gated_clk_fp16         (nvdla_op_gated_clk_fp16)               //|< i
  ,.reg2dp_normalz_len              (reg2dp_normalz_len[1:0])               //|< i
  ,.sum2itp_prdy                    (sum2itp_prdy)                          //|< w
  ,.normalz_buf_data_prdy           (normalz_buf_data_prdy)                 //|> w
  ,.sum2itp_pd                      (sum2itp_pd[167:0])                     //|> w
  ,.sum2itp_pvld                    (sum2itp_pvld)                          //|> w
  );

//===== LUT controller Instance========
assign cvtin_out_int8_0 = cvt2buf_pd[8:0];
assign cvtin_out_int8_1 = cvt2buf_pd[17:9];
assign cvtin_out_int8_2 = cvt2buf_pd[26:18];
assign cvtin_out_int8_3 = cvt2buf_pd[35:27];
assign cvtin_out_int8_4 = cvt2buf_pd[44:36];
assign cvtin_out_int8_5 = cvt2buf_pd[53:45];
assign cvtin_out_int8_6 = cvt2buf_pd[62:54];
assign cvtin_out_int8_7 = cvt2buf_pd[71:63];
assign cvtin_out_int8_ext = {{{12{cvtin_out_int8_7[8]}}, cvtin_out_int8_7[8:0]},{{12{cvtin_out_int8_6[8]}}, cvtin_out_int8_6[8:0]},
                             {{12{cvtin_out_int8_5[8]}}, cvtin_out_int8_5[8:0]},{{12{cvtin_out_int8_4[8]}}, cvtin_out_int8_4[8:0]},
                             {{12{cvtin_out_int8_3[8]}}, cvtin_out_int8_3[8:0]},{{12{cvtin_out_int8_2[8]}}, cvtin_out_int8_2[8:0]},
                             {{12{cvtin_out_int8_1[8]}}, cvtin_out_int8_1[8:0]},{{12{cvtin_out_int8_0[8]}}, cvtin_out_int8_0[8:0]}};
assign cvtin_out_16_0 = cvt2buf_pd[16:0];
assign cvtin_out_16_1 = cvt2buf_pd[34:18];
assign cvtin_out_16_2 = cvt2buf_pd[52:36];
assign cvtin_out_16_3 = cvt2buf_pd[70:54];
assign cvtin_out_16_ext = {{{25{cvtin_out_16_3[16]}}, cvtin_out_16_3[16:0]},{{25{cvtin_out_16_2[16]}}, cvtin_out_16_2[16:0]},
                           {{25{cvtin_out_16_1[16]}}, cvtin_out_16_1[16:0]},{{25{cvtin_out_16_0[16]}}, cvtin_out_16_0[16:0]}};
assign lutctrl_in_sqsum_bypass = int8_en ? cvtin_out_int8_ext : cvtin_out_16_ext;
assign lutctrl_in_pd = sqsum_bypass_en ? lutctrl_in_sqsum_bypass : sum2itp_pd;
assign lutctrl_in_pvld = sqsum_bypass_en ? cvt2buf_pvld : sum2itp_pvld;

NV_NVDLA_CDP_DP_LUT_ctrl u_NV_NVDLA_CDP_DP_LUT_ctrl (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.dp2lut_prdy                     (dp2lut_prdy)                           //|< w
  ,.fp16_en                         (fp16_en)                               //|< r
  ,.int16_en                        (int16_en)                              //|< r
  ,.int8_en                         (int8_en)                               //|< r
  ,.nvdla_op_gated_clk_fp16         (nvdla_op_gated_clk_fp16)               //|< i
  ,.nvdla_op_gated_clk_int          (nvdla_op_gated_clk_int)                //|< i
  ,.reg2dp_lut_le_function          (reg2dp_lut_le_function)                //|< i
  ,.reg2dp_lut_le_index_offset      (reg2dp_lut_le_index_offset[7:0])       //|< i
  ,.reg2dp_lut_le_index_select      (reg2dp_lut_le_index_select[7:0])       //|< i
  ,.reg2dp_lut_le_start_high        (reg2dp_lut_le_start_high[5:0])         //|< i
  ,.reg2dp_lut_le_start_low         (reg2dp_lut_le_start_low[31:0])         //|< i
  ,.reg2dp_lut_lo_index_select      (reg2dp_lut_lo_index_select[7:0])       //|< i
  ,.reg2dp_lut_lo_start_high        (reg2dp_lut_lo_start_high[5:0])         //|< i
  ,.reg2dp_lut_lo_start_low         (reg2dp_lut_lo_start_low[31:0])         //|< i
  ,.reg2dp_sqsum_bypass             (reg2dp_sqsum_bypass)                   //|< i
  ,.sum2itp_pd                      (lutctrl_in_pd[167:0])                  //|< w
  ,.sum2itp_pvld                    (lutctrl_in_pvld)                       //|< w
  ,.sum2sync_prdy                   (sum2sync_prdy)                         //|< w
  ,.dp2lut_X_entry_0                (dp2lut_X_entry_0[9:0])                 //|> w
  ,.dp2lut_X_entry_1                (dp2lut_X_entry_1[9:0])                 //|> w
  ,.dp2lut_X_entry_2                (dp2lut_X_entry_2[9:0])                 //|> w
  ,.dp2lut_X_entry_3                (dp2lut_X_entry_3[9:0])                 //|> w
  ,.dp2lut_X_entry_4                (dp2lut_X_entry_4[9:0])                 //|> w
  ,.dp2lut_X_entry_5                (dp2lut_X_entry_5[9:0])                 //|> w
  ,.dp2lut_X_entry_6                (dp2lut_X_entry_6[9:0])                 //|> w
  ,.dp2lut_X_entry_7                (dp2lut_X_entry_7[9:0])                 //|> w
  ,.dp2lut_Xinfo_0                  (dp2lut_Xinfo_0[17:0])                  //|> w
  ,.dp2lut_Xinfo_1                  (dp2lut_Xinfo_1[17:0])                  //|> w
  ,.dp2lut_Xinfo_2                  (dp2lut_Xinfo_2[17:0])                  //|> w
  ,.dp2lut_Xinfo_3                  (dp2lut_Xinfo_3[17:0])                  //|> w
  ,.dp2lut_Xinfo_4                  (dp2lut_Xinfo_4[17:0])                  //|> w
  ,.dp2lut_Xinfo_5                  (dp2lut_Xinfo_5[17:0])                  //|> w
  ,.dp2lut_Xinfo_6                  (dp2lut_Xinfo_6[17:0])                  //|> w
  ,.dp2lut_Xinfo_7                  (dp2lut_Xinfo_7[17:0])                  //|> w
  ,.dp2lut_Y_entry_0                (dp2lut_Y_entry_0[9:0])                 //|> w
  ,.dp2lut_Y_entry_1                (dp2lut_Y_entry_1[9:0])                 //|> w
  ,.dp2lut_Y_entry_2                (dp2lut_Y_entry_2[9:0])                 //|> w
  ,.dp2lut_Y_entry_3                (dp2lut_Y_entry_3[9:0])                 //|> w
  ,.dp2lut_Y_entry_4                (dp2lut_Y_entry_4[9:0])                 //|> w
  ,.dp2lut_Y_entry_5                (dp2lut_Y_entry_5[9:0])                 //|> w
  ,.dp2lut_Y_entry_6                (dp2lut_Y_entry_6[9:0])                 //|> w
  ,.dp2lut_Y_entry_7                (dp2lut_Y_entry_7[9:0])                 //|> w
  ,.dp2lut_Yinfo_0                  (dp2lut_Yinfo_0[17:0])                  //|> w
  ,.dp2lut_Yinfo_1                  (dp2lut_Yinfo_1[17:0])                  //|> w
  ,.dp2lut_Yinfo_2                  (dp2lut_Yinfo_2[17:0])                  //|> w
  ,.dp2lut_Yinfo_3                  (dp2lut_Yinfo_3[17:0])                  //|> w
  ,.dp2lut_Yinfo_4                  (dp2lut_Yinfo_4[17:0])                  //|> w
  ,.dp2lut_Yinfo_5                  (dp2lut_Yinfo_5[17:0])                  //|> w
  ,.dp2lut_Yinfo_6                  (dp2lut_Yinfo_6[17:0])                  //|> w
  ,.dp2lut_Yinfo_7                  (dp2lut_Yinfo_7[17:0])                  //|> w
  ,.dp2lut_pvld                     (dp2lut_pvld)                           //|> w
  ,.sum2itp_prdy                    (sum2itp_prdy)                          //|> w
  ,.sum2sync_pd                     (sum2sync_pd[167:0])                    //|> w
  ,.sum2sync_pvld                   (sum2sync_pvld)                         //|> w
  );

//===== LUT Instance========
NV_NVDLA_CDP_DP_lut u_NV_NVDLA_CDP_DP_lut (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_clk_orig             (nvdla_core_clk_orig)                   //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.dp2lut_X_entry_0                (dp2lut_X_entry_0[9:0])                 //|< w
  ,.dp2lut_X_entry_1                (dp2lut_X_entry_1[9:0])                 //|< w
  ,.dp2lut_X_entry_2                (dp2lut_X_entry_2[9:0])                 //|< w
  ,.dp2lut_X_entry_3                (dp2lut_X_entry_3[9:0])                 //|< w
  ,.dp2lut_X_entry_4                (dp2lut_X_entry_4[9:0])                 //|< w
  ,.dp2lut_X_entry_5                (dp2lut_X_entry_5[9:0])                 //|< w
  ,.dp2lut_X_entry_6                (dp2lut_X_entry_6[9:0])                 //|< w
  ,.dp2lut_X_entry_7                (dp2lut_X_entry_7[9:0])                 //|< w
  ,.dp2lut_Xinfo_0                  (dp2lut_Xinfo_0[17:0])                  //|< w
  ,.dp2lut_Xinfo_1                  (dp2lut_Xinfo_1[17:0])                  //|< w
  ,.dp2lut_Xinfo_2                  (dp2lut_Xinfo_2[17:0])                  //|< w
  ,.dp2lut_Xinfo_3                  (dp2lut_Xinfo_3[17:0])                  //|< w
  ,.dp2lut_Xinfo_4                  (dp2lut_Xinfo_4[17:0])                  //|< w
  ,.dp2lut_Xinfo_5                  (dp2lut_Xinfo_5[17:0])                  //|< w
  ,.dp2lut_Xinfo_6                  (dp2lut_Xinfo_6[17:0])                  //|< w
  ,.dp2lut_Xinfo_7                  (dp2lut_Xinfo_7[17:0])                  //|< w
  ,.dp2lut_Y_entry_0                (dp2lut_Y_entry_0[9:0])                 //|< w
  ,.dp2lut_Y_entry_1                (dp2lut_Y_entry_1[9:0])                 //|< w
  ,.dp2lut_Y_entry_2                (dp2lut_Y_entry_2[9:0])                 //|< w
  ,.dp2lut_Y_entry_3                (dp2lut_Y_entry_3[9:0])                 //|< w
  ,.dp2lut_Y_entry_4                (dp2lut_Y_entry_4[9:0])                 //|< w
  ,.dp2lut_Y_entry_5                (dp2lut_Y_entry_5[9:0])                 //|< w
  ,.dp2lut_Y_entry_6                (dp2lut_Y_entry_6[9:0])                 //|< w
  ,.dp2lut_Y_entry_7                (dp2lut_Y_entry_7[9:0])                 //|< w
  ,.dp2lut_Yinfo_0                  (dp2lut_Yinfo_0[17:0])                  //|< w
  ,.dp2lut_Yinfo_1                  (dp2lut_Yinfo_1[17:0])                  //|< w
  ,.dp2lut_Yinfo_2                  (dp2lut_Yinfo_2[17:0])                  //|< w
  ,.dp2lut_Yinfo_3                  (dp2lut_Yinfo_3[17:0])                  //|< w
  ,.dp2lut_Yinfo_4                  (dp2lut_Yinfo_4[17:0])                  //|< w
  ,.dp2lut_Yinfo_5                  (dp2lut_Yinfo_5[17:0])                  //|< w
  ,.dp2lut_Yinfo_6                  (dp2lut_Yinfo_6[17:0])                  //|< w
  ,.dp2lut_Yinfo_7                  (dp2lut_Yinfo_7[17:0])                  //|< w
  ,.dp2lut_pvld                     (dp2lut_pvld)                           //|< w
  ,.int8_en                         (int8_en)                               //|< r
  ,.lut2intp_prdy                   (lut2intp_prdy)                         //|< w
  ,.nvdla_op_gated_clk_fp16         (nvdla_op_gated_clk_fp16)               //|< i
  ,.reg2dp_input_data_type          (reg2dp_input_data_type[1:0])           //|< i
  ,.reg2dp_lut_access_type          (reg2dp_lut_access_type)                //|< i
  ,.reg2dp_lut_addr                 (reg2dp_lut_addr[9:0])                  //|< i
  ,.reg2dp_lut_data                 (reg2dp_lut_data[15:0])                 //|< i
  ,.reg2dp_lut_data_trigger         (reg2dp_lut_data_trigger)               //|< i
  ,.reg2dp_lut_hybrid_priority      (reg2dp_lut_hybrid_priority)            //|< i
  ,.reg2dp_lut_oflow_priority       (reg2dp_lut_oflow_priority)             //|< i
  ,.reg2dp_lut_table_id             (reg2dp_lut_table_id)                   //|< i
  ,.reg2dp_lut_uflow_priority       (reg2dp_lut_uflow_priority)             //|< i
  ,.dp2lut_prdy                     (dp2lut_prdy)                           //|> w
  ,.dp2reg_lut_data                 (dp2reg_lut_data[15:0])                 //|> o
  ,.lut2intp_X_data_00              (lut2intp_X_data_00[31:0])              //|> w
  ,.lut2intp_X_data_00_17b          (lut2intp_X_data_00_17b[16:0])          //|> w
  ,.lut2intp_X_data_01              (lut2intp_X_data_01[31:0])              //|> w
  ,.lut2intp_X_data_10              (lut2intp_X_data_10[31:0])              //|> w
  ,.lut2intp_X_data_10_17b          (lut2intp_X_data_10_17b[16:0])          //|> w
  ,.lut2intp_X_data_11              (lut2intp_X_data_11[31:0])              //|> w
  ,.lut2intp_X_data_20              (lut2intp_X_data_20[31:0])              //|> w
  ,.lut2intp_X_data_20_17b          (lut2intp_X_data_20_17b[16:0])          //|> w
  ,.lut2intp_X_data_21              (lut2intp_X_data_21[31:0])              //|> w
  ,.lut2intp_X_data_30              (lut2intp_X_data_30[31:0])              //|> w
  ,.lut2intp_X_data_30_17b          (lut2intp_X_data_30_17b[16:0])          //|> w
  ,.lut2intp_X_data_31              (lut2intp_X_data_31[31:0])              //|> w
  ,.lut2intp_X_data_40              (lut2intp_X_data_40[31:0])              //|> w
  ,.lut2intp_X_data_40_17b          (lut2intp_X_data_40_17b[16:0])          //|> w
  ,.lut2intp_X_data_41              (lut2intp_X_data_41[31:0])              //|> w
  ,.lut2intp_X_data_50              (lut2intp_X_data_50[31:0])              //|> w
  ,.lut2intp_X_data_50_17b          (lut2intp_X_data_50_17b[16:0])          //|> w
  ,.lut2intp_X_data_51              (lut2intp_X_data_51[31:0])              //|> w
  ,.lut2intp_X_data_60              (lut2intp_X_data_60[31:0])              //|> w
  ,.lut2intp_X_data_60_17b          (lut2intp_X_data_60_17b[16:0])          //|> w
  ,.lut2intp_X_data_61              (lut2intp_X_data_61[31:0])              //|> w
  ,.lut2intp_X_data_70              (lut2intp_X_data_70[31:0])              //|> w
  ,.lut2intp_X_data_70_17b          (lut2intp_X_data_70_17b[16:0])          //|> w
  ,.lut2intp_X_data_71              (lut2intp_X_data_71[31:0])              //|> w
  ,.lut2intp_X_info_0               (lut2intp_X_info_0[19:0])               //|> w
  ,.lut2intp_X_info_1               (lut2intp_X_info_1[19:0])               //|> w
  ,.lut2intp_X_info_2               (lut2intp_X_info_2[19:0])               //|> w
  ,.lut2intp_X_info_3               (lut2intp_X_info_3[19:0])               //|> w
  ,.lut2intp_X_info_4               (lut2intp_X_info_4[19:0])               //|> w
  ,.lut2intp_X_info_5               (lut2intp_X_info_5[19:0])               //|> w
  ,.lut2intp_X_info_6               (lut2intp_X_info_6[19:0])               //|> w
  ,.lut2intp_X_info_7               (lut2intp_X_info_7[19:0])               //|> w
  ,.lut2intp_X_sel                  (lut2intp_X_sel[7:0])                   //|> w
  ,.lut2intp_Y_sel                  (lut2intp_Y_sel[7:0])                   //|> w
  ,.lut2intp_pvld                   (lut2intp_pvld)                         //|> w
  );

//===== interpolator Instance========
//assign intp2mul_out_prdy  =   mul_bypass_en ? mul2ocvt_prdy : intp2mul_prdy;
NV_NVDLA_CDP_DP_intp u_NV_NVDLA_CDP_DP_intp (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.dp2reg_done                     (dp2reg_done)                           //|< i
  ,.fp16_en                         (fp16_en)                               //|< r
  ,.int16_en                        (int16_en)                              //|< r
  ,.int8_en                         (int8_en)                               //|< r
  ,.intp2mul_prdy                   (intp2mul_prdy)                         //|< w
  ,.lut2intp_X_data_00              (lut2intp_X_data_00[31:0])              //|< w
  ,.lut2intp_X_data_00_17b          (lut2intp_X_data_00_17b[16:0])          //|< w
  ,.lut2intp_X_data_01              (lut2intp_X_data_01[31:0])              //|< w
  ,.lut2intp_X_data_10              (lut2intp_X_data_10[31:0])              //|< w
  ,.lut2intp_X_data_10_17b          (lut2intp_X_data_10_17b[16:0])          //|< w
  ,.lut2intp_X_data_11              (lut2intp_X_data_11[31:0])              //|< w
  ,.lut2intp_X_data_20              (lut2intp_X_data_20[31:0])              //|< w
  ,.lut2intp_X_data_20_17b          (lut2intp_X_data_20_17b[16:0])          //|< w
  ,.lut2intp_X_data_21              (lut2intp_X_data_21[31:0])              //|< w
  ,.lut2intp_X_data_30              (lut2intp_X_data_30[31:0])              //|< w
  ,.lut2intp_X_data_30_17b          (lut2intp_X_data_30_17b[16:0])          //|< w
  ,.lut2intp_X_data_31              (lut2intp_X_data_31[31:0])              //|< w
  ,.lut2intp_X_data_40              (lut2intp_X_data_40[31:0])              //|< w
  ,.lut2intp_X_data_40_17b          (lut2intp_X_data_40_17b[16:0])          //|< w
  ,.lut2intp_X_data_41              (lut2intp_X_data_41[31:0])              //|< w
  ,.lut2intp_X_data_50              (lut2intp_X_data_50[31:0])              //|< w
  ,.lut2intp_X_data_50_17b          (lut2intp_X_data_50_17b[16:0])          //|< w
  ,.lut2intp_X_data_51              (lut2intp_X_data_51[31:0])              //|< w
  ,.lut2intp_X_data_60              (lut2intp_X_data_60[31:0])              //|< w
  ,.lut2intp_X_data_60_17b          (lut2intp_X_data_60_17b[16:0])          //|< w
  ,.lut2intp_X_data_61              (lut2intp_X_data_61[31:0])              //|< w
  ,.lut2intp_X_data_70              (lut2intp_X_data_70[31:0])              //|< w
  ,.lut2intp_X_data_70_17b          (lut2intp_X_data_70_17b[16:0])          //|< w
  ,.lut2intp_X_data_71              (lut2intp_X_data_71[31:0])              //|< w
  ,.lut2intp_X_info_0               (lut2intp_X_info_0[19:0])               //|< w
  ,.lut2intp_X_info_1               (lut2intp_X_info_1[19:0])               //|< w
  ,.lut2intp_X_info_2               (lut2intp_X_info_2[19:0])               //|< w
  ,.lut2intp_X_info_3               (lut2intp_X_info_3[19:0])               //|< w
  ,.lut2intp_X_info_4               (lut2intp_X_info_4[19:0])               //|< w
  ,.lut2intp_X_info_5               (lut2intp_X_info_5[19:0])               //|< w
  ,.lut2intp_X_info_6               (lut2intp_X_info_6[19:0])               //|< w
  ,.lut2intp_X_info_7               (lut2intp_X_info_7[19:0])               //|< w
  ,.lut2intp_X_sel                  (lut2intp_X_sel[7:0])                   //|< w
  ,.lut2intp_Y_sel                  (lut2intp_Y_sel[7:0])                   //|< w
  ,.lut2intp_pvld                   (lut2intp_pvld)                         //|< w
  ,.nvdla_op_gated_clk_fp16         (nvdla_op_gated_clk_fp16)               //|< i
  ,.nvdla_op_gated_clk_int          (nvdla_op_gated_clk_int)                //|< i
  ,.pwrbus_ram_pd                   (pwrbus_ram_pd[31:0])                   //|< i
  ,.reg2dp_lut_le_end_high          (reg2dp_lut_le_end_high[5:0])           //|< i
  ,.reg2dp_lut_le_end_low           (reg2dp_lut_le_end_low[31:0])           //|< i
  ,.reg2dp_lut_le_function          (reg2dp_lut_le_function)                //|< i
  ,.reg2dp_lut_le_index_offset      (reg2dp_lut_le_index_offset[7:0])       //|< i
  ,.reg2dp_lut_le_slope_oflow_scale (reg2dp_lut_le_slope_oflow_scale[15:0]) //|< i
  ,.reg2dp_lut_le_slope_oflow_shift (reg2dp_lut_le_slope_oflow_shift[4:0])  //|< i
  ,.reg2dp_lut_le_slope_uflow_scale (reg2dp_lut_le_slope_uflow_scale[15:0]) //|< i
  ,.reg2dp_lut_le_slope_uflow_shift (reg2dp_lut_le_slope_uflow_shift[4:0])  //|< i
  ,.reg2dp_lut_le_start_high        (reg2dp_lut_le_start_high[5:0])         //|< i
  ,.reg2dp_lut_le_start_low         (reg2dp_lut_le_start_low[31:0])         //|< i
  ,.reg2dp_lut_lo_end_high          (reg2dp_lut_lo_end_high[5:0])           //|< i
  ,.reg2dp_lut_lo_end_low           (reg2dp_lut_lo_end_low[31:0])           //|< i
  ,.reg2dp_lut_lo_slope_oflow_scale (reg2dp_lut_lo_slope_oflow_scale[15:0]) //|< i
  ,.reg2dp_lut_lo_slope_oflow_shift (reg2dp_lut_lo_slope_oflow_shift[4:0])  //|< i
  ,.reg2dp_lut_lo_slope_uflow_scale (reg2dp_lut_lo_slope_uflow_scale[15:0]) //|< i
  ,.reg2dp_lut_lo_slope_uflow_shift (reg2dp_lut_lo_slope_uflow_shift[4:0])  //|< i
  ,.reg2dp_lut_lo_start_high        (reg2dp_lut_lo_start_high[5:0])         //|< i
  ,.reg2dp_lut_lo_start_low         (reg2dp_lut_lo_start_low[31:0])         //|< i
  ,.reg2dp_sqsum_bypass             (reg2dp_sqsum_bypass)                   //|< i
  ,.sync2itp_pd                     (sync2itp_pd[167:0])                    //|< w
  ,.sync2itp_pvld                   (sync2itp_pvld)                         //|< w
  ,.dp2reg_d0_perf_lut_hybrid       (dp2reg_d0_perf_lut_hybrid[31:0])       //|> o
  ,.dp2reg_d0_perf_lut_le_hit       (dp2reg_d0_perf_lut_le_hit[31:0])       //|> o
  ,.dp2reg_d0_perf_lut_lo_hit       (dp2reg_d0_perf_lut_lo_hit[31:0])       //|> o
  ,.dp2reg_d0_perf_lut_oflow        (dp2reg_d0_perf_lut_oflow[31:0])        //|> o
  ,.dp2reg_d0_perf_lut_uflow        (dp2reg_d0_perf_lut_uflow[31:0])        //|> o
  ,.dp2reg_d1_perf_lut_hybrid       (dp2reg_d1_perf_lut_hybrid[31:0])       //|> o
  ,.dp2reg_d1_perf_lut_le_hit       (dp2reg_d1_perf_lut_le_hit[31:0])       //|> o
  ,.dp2reg_d1_perf_lut_lo_hit       (dp2reg_d1_perf_lut_lo_hit[31:0])       //|> o
  ,.dp2reg_d1_perf_lut_oflow        (dp2reg_d1_perf_lut_oflow[31:0])        //|> o
  ,.dp2reg_d1_perf_lut_uflow        (dp2reg_d1_perf_lut_uflow[31:0])        //|> o
  ,.intp2mul_pd_0                   (intp2mul_pd_0[16:0])                   //|> w
  ,.intp2mul_pd_1                   (intp2mul_pd_1[16:0])                   //|> w
  ,.intp2mul_pd_2                   (intp2mul_pd_2[16:0])                   //|> w
  ,.intp2mul_pd_3                   (intp2mul_pd_3[16:0])                   //|> w
  ,.intp2mul_pd_4                   (intp2mul_pd_4[16:0])                   //|> w
  ,.intp2mul_pd_5                   (intp2mul_pd_5[16:0])                   //|> w
  ,.intp2mul_pd_6                   (intp2mul_pd_6[16:0])                   //|> w
  ,.intp2mul_pd_7                   (intp2mul_pd_7[16:0])                   //|> w
  ,.intp2mul_pvld                   (intp2mul_pvld)                         //|> w
  ,.lut2intp_prdy                   (lut2intp_prdy)                         //|> w
  ,.sync2itp_prdy                   (sync2itp_prdy)                         //|> w
  );
//&Connect intp2mul_prdy      intp2mul_out_prdy;

//===== DP multiple Instance========
//assign mul_in_pd_0= mul_bypass_en ? 17'd0 : intp2mul_pd_0[16:0]; 
//assign mul_in_pd_1= mul_bypass_en ? 17'd0 : intp2mul_pd_1[16:0]; 
//assign mul_in_pd_2= mul_bypass_en ? 17'd0 : intp2mul_pd_2[16:0]; 
//assign mul_in_pd_3= mul_bypass_en ? 17'd0 : intp2mul_pd_3[16:0]; 
//assign mul_in_pd_4= mul_bypass_en ? 17'd0 : intp2mul_pd_4[16:0]; 
//assign mul_in_pd_5= mul_bypass_en ? 17'd0 : intp2mul_pd_5[16:0]; 
//assign mul_in_pd_6= mul_bypass_en ? 17'd0 : intp2mul_pd_6[16:0]; 
//assign mul_in_pd_7= mul_bypass_en ? 17'd0 : intp2mul_pd_7[16:0]; 
//assign mul_in_pvld= mul_bypass_en ? 1'd0  : intp2mul_pvld; 

NV_NVDLA_CDP_DP_mul u_NV_NVDLA_CDP_DP_mul (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.fp16_en                         (fp16_en)                               //|< r
  ,.int16_en                        (int16_en)                              //|< r
  ,.int8_en                         (int8_en)                               //|< r
  ,.intp2mul_pd_0                   (intp2mul_pd_0[16:0])                   //|< w
  ,.intp2mul_pd_1                   (intp2mul_pd_1[16:0])                   //|< w
  ,.intp2mul_pd_2                   (intp2mul_pd_2[16:0])                   //|< w
  ,.intp2mul_pd_3                   (intp2mul_pd_3[16:0])                   //|< w
  ,.intp2mul_pd_4                   (intp2mul_pd_4[16:0])                   //|< w
  ,.intp2mul_pd_5                   (intp2mul_pd_5[16:0])                   //|< w
  ,.intp2mul_pd_6                   (intp2mul_pd_6[16:0])                   //|< w
  ,.intp2mul_pd_7                   (intp2mul_pd_7[16:0])                   //|< w
  ,.intp2mul_pvld                   (intp2mul_pvld)                         //|< w
  ,.mul2ocvt_prdy                   (mul2ocvt_prdy)                         //|< w
  ,.nvdla_op_gated_clk_fp16         (nvdla_op_gated_clk_fp16)               //|< i
  ,.nvdla_op_gated_clk_int          (nvdla_op_gated_clk_int)                //|< i
  ,.reg2dp_input_data_type          (reg2dp_input_data_type[1:0])           //|< i
  ,.reg2dp_mul_bypass               (reg2dp_mul_bypass)                     //|< i
  ,.sync2mul_pd                     (sync2mul_pd[71:0])                     //|< w
  ,.sync2mul_pvld                   (sync2mul_pvld)                         //|< w
  ,.intp2mul_prdy                   (intp2mul_prdy)                         //|> w
  ,.mul2ocvt_pd                     (mul2ocvt_pd[199:0])                    //|> w
  ,.mul2ocvt_pvld                   (mul2ocvt_pvld)                         //|> w
  ,.sync2mul_prdy                   (sync2mul_prdy)                         //|> w
  );
//&Connect intp2mul_pd_0      mul_in_pd_0; 
//&Connect intp2mul_pd_1      mul_in_pd_1; 
//&Connect intp2mul_pd_2      mul_in_pd_2; 
//&Connect intp2mul_pd_3      mul_in_pd_3; 
//&Connect intp2mul_pd_4      mul_in_pd_4; 
//&Connect intp2mul_pd_5      mul_in_pd_5; 
//&Connect intp2mul_pd_6      mul_in_pd_6; 
//&Connect intp2mul_pd_7      mul_in_pd_7; 
//&Connect intp2mul_pvld      mul_in_pvld;       

//===== convertor_out Instance========
//assign intp_out_int8 = {::sign_extend(intp2mul_pd_7,17,25),::sign_extend(intp2mul_pd_6,17,25),
//assign intp_out_16   = {::sign_extend(intp2mul_pd_3,17,50),::sign_extend(intp2mul_pd_2,17,50),
//assign intp_out_ext  = int8_en ? intp_out_int8 : intp_out_16;
//
//assign ocvt_in_pd = mul_bypass_en ? intp_out_ext : mul2ocvt_pd;
//assign ocvt_in_pvld = mul_bypass_en ? intp2mul_pvld : mul2ocvt_pvld;

NV_NVDLA_CDP_DP_cvtout u_NV_NVDLA_CDP_DP_cvtout (
   .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
  ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
  ,.cvtout_prdy                     (cdp_dp2wdma_ready)                     //|< i
  ,.dp2reg_done                     (dp2reg_done)                           //|< i
  ,.mul2ocvt_pd                     (mul2ocvt_pd[199:0])                    //|< w
  ,.mul2ocvt_pvld                   (mul2ocvt_pvld)                         //|< w
  ,.reg2dp_datout_offset            (reg2dp_datout_offset[31:0])            //|< i
  ,.reg2dp_datout_scale             (reg2dp_datout_scale[15:0])             //|< i
  ,.reg2dp_datout_shifter           (reg2dp_datout_shifter[5:0])            //|< i
  ,.reg2dp_input_data_type          (reg2dp_input_data_type[1:0])           //|< i
  ,.sync2ocvt_pd                    (sync2ocvt_pd[14:0])                    //|< w
  ,.sync2ocvt_pvld                  (sync2ocvt_pvld)                        //|< w
  ,.cvtout_pd                       (cdp_dp2wdma_pd[78:0])                  //|> o
  ,.cvtout_pvld                     (cdp_dp2wdma_valid)                     //|> o
  ,.dp2reg_d0_out_saturation        (dp2reg_d0_out_saturation[31:0])        //|> o
  ,.dp2reg_d1_out_saturation        (dp2reg_d1_out_saturation[31:0])        //|> o
  ,.mul2ocvt_prdy                   (mul2ocvt_prdy)                         //|> w
  ,.sync2ocvt_prdy                  (sync2ocvt_prdy)                        //|> w
  );
//&Connect mul2ocvt_pd       ocvt_in_pd[199:0];
//&Connect mul2ocvt_pvld     ocvt_in_pvld;

////==============
////OBS signals
////==============
//assign obs_bus_cdp_rdma2dp_vld = cdp_rdma2dp_valid;
//assign obs_bus_cdp_rdma2dp_rdy = cdp_rdma2dp_ready;
//assign obs_bus_cdp_icvt_vld    = cvt2buf_pvld;
//assign obs_bus_cdp_icvt_rdy    = cvt2buf_prdy;
//assign obs_bus_cdp_buf_vld     = normalz_buf_data_pvld;
//assign obs_bus_cdp_buf_rdy     = normalz_buf_data_prdy; 
//assign obs_bus_cdp_sum_vld     = sum2itp_pvld;
//assign obs_bus_cdp_sum_rdy     = sum2itp_prdy;
//assign obs_bus_cdp_lutctrl_vld = dp2lut_pvld; 
//assign obs_bus_cdp_lutctrl_rdy = dp2lut_prdy; 
//assign obs_bus_cdp_intp_vld    = intp2mul_pvld; 
//assign obs_bus_cdp_intp_rdy    = intp2mul_prdy; 
//assign obs_bus_cdp_ocvt_vld    = cdp_dp2wdma_valid; 
//assign obs_bus_cdp_ocvt_rdy    = cdp_dp2wdma_ready; 


endmodule // NV_NVDLA_CDP_dp

