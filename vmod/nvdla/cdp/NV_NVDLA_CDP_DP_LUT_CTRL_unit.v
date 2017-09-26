// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_LUT_CTRL_unit.v

module NV_NVDLA_CDP_DP_LUT_CTRL_unit (
   nvdla_core_clk             //|< i
  ,nvdla_op_gated_clk_fp16    //|< i
  ,nvdla_op_gated_clk_int     //|< i
  ,nvdla_core_rstn            //|< i
  ,dp2lut_prdy                //|< i
  ,fp16_en                    //|< i
  ,int16_en                   //|< i
  ,int8_en                    //|< i
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
  ,dp2lut_X_info              //|> o
  ,dp2lut_X_pd                //|> o
  ,dp2lut_Y_info              //|> o
  ,dp2lut_Y_pd                //|> o
  ,dp2lut_pvld                //|> o
  ,sum2itp_prdy               //|> o
  );
input          nvdla_core_clk;
input          nvdla_op_gated_clk_fp16;
input          nvdla_op_gated_clk_int;
input          nvdla_core_rstn;
input          dp2lut_prdy;
input          fp16_en;
input          int16_en;
input          int8_en;
input          reg2dp_lut_le_function;
input    [7:0] reg2dp_lut_le_index_offset;
input    [7:0] reg2dp_lut_le_index_select;
input    [5:0] reg2dp_lut_le_start_high;
input   [31:0] reg2dp_lut_le_start_low;
input    [7:0] reg2dp_lut_lo_index_select;
input    [5:0] reg2dp_lut_lo_start_high;
input   [31:0] reg2dp_lut_lo_start_low;
input          reg2dp_sqsum_bypass;
input   [41:0] sum2itp_pd;
input          sum2itp_pvld;
output  [35:0] dp2lut_X_info;
output  [19:0] dp2lut_X_pd;
output  [35:0] dp2lut_Y_info;
output  [19:0] dp2lut_Y_pd;
output         dp2lut_pvld;
output         sum2itp_prdy;
reg            X_exp;
reg            X_exp_s;
reg            X_int16_oflow;
reg            X_int8_oflow_lsb;
reg            X_int8_oflow_msb;
reg     [15:0] X_lin_frac_int16;
reg     [15:0] X_lin_frac_int8_lsb;
reg     [15:0] X_lin_frac_int8_msb;
reg      [1:0] Y_dat_info_shift;
reg     [37:0] Y_dec_offset_lsb;
reg     [21:0] Y_dec_offset_msb;
reg            Y_int16_oflow;
reg            Y_int8_oflow_lsb;
reg            Y_int8_oflow_msb;
reg            Y_less_than_win_s;
reg            Y_less_than_win_start;
reg     [15:0] Y_lin_frac_int16;
reg     [15:0] Y_lin_frac_int8_lsb;
reg     [15:0] Y_lin_frac_int8_msb;
reg      [7:0] Y_shift_bits;
reg      [9:0] Y_shift_int16;
reg      [9:0] Y_shift_lsb_int8;
reg      [9:0] Y_shift_msb_int8;
reg     [33:0] dat_info_d;
reg     [33:0] dat_info_shift;
reg     [38:0] dec_Xindex_lsb;
reg     [22:0] dec_Xindex_msb;
reg     [37:0] dec_offset_lsb;
reg     [21:0] dec_offset_msb;
reg     [15:0] fp_X_exp_frac;
reg            fp_X_index_uflow;
reg     [16:0] fp_X_info_d;
reg     [31:0] fp_X_log2_datout;
reg     [31:0] fp_X_log2_datout_d;
reg            fp_X_stage1_vld;
reg            fp_X_stage2_vld;
reg            fp_X_uflow;
reg      [8:0] fp_Xindex;
reg     [16:0] fp_Xindex_info_d;
reg      [9:0] fp_Xshift;
reg     [15:0] fp_Xshift_frac;
reg            fp_Xshift_oflow;
reg            fp_Y_stage1_vld;
reg            fp_Y_uflow;
reg            fp_Yindex_info_d;
reg      [9:0] fp_Yshift;
reg     [15:0] fp_Yshift_frac;
reg            fp_Yshift_oflow;
reg            int_X_index_uflow_lsb;
reg            int_X_index_uflow_msb;
reg      [1:0] int_X_input_uflow_d;
reg            int_X_input_uflow_lsb;
reg            int_X_input_uflow_msb;
reg            int_Y_input_uflow_lsb;
reg            int_Y_input_uflow_msb;
reg            int_Y_stage0_pvld;
reg            int_Y_stage1_pvld;
reg            int_stage0_pvld;
reg            int_stage1_pvld;
reg            int_stage2_pvld;
reg            int_stage3_pvld;
reg            less_than_win_s;
reg            less_than_win_start;
reg     [37:0] log2_datout_lsb;
reg     [21:0] log2_datout_msb;
reg     [36:0] log2_frac_lsb;
reg     [20:0] log2_frac_msb;
reg      [0:0] mon_Y_dec_offset_lsb;
reg      [0:0] mon_Y_dec_offset_msb;
reg      [0:0] mon_dec_Xindex_lsb;
reg      [0:0] mon_dec_Xindex_msb;
reg      [0:0] mon_dec_offset_lsb;
reg      [0:0] mon_dec_offset_msb;
reg      [0:0] mon_fp_Xindex;
reg      [9:0] shift_int16;
reg      [9:0] shift_lsb_int8;
reg      [9:0] shift_msb_int8;
reg            sqsum_bypass_enable;
wire    [35:0] X_dat_info;
wire    [15:0] X_exp_frac_lsb;
wire    [15:0] X_exp_frac_msb;
wire    [15:0] X_frac_lsb;
wire    [15:0] X_frac_msb;
wire     [9:0] X_index_lsb;
wire     [9:0] X_index_msb;
wire    [15:0] X_lin_frac_lsb;
wire    [15:0] X_lin_frac_msb;
wire           X_oflow_int_lsb;
wire           X_oflow_int_msb;
wire           Xinput_is_NaN;
wire    [35:0] Y_dat_info;
wire    [35:0] Y_dat_info_f;
wire           Y_datin_fp16_rdy;
wire           Y_datin_fp16_vld;
wire    [22:0] Y_fp32_frac;
wire   [127:0] Y_fp32_frac_ext;
wire    [22:0] Y_fp32_frac_f;
wire   [127:0] Y_fp32_frac_f_ext;
wire   [128:0] Y_fp32_int;
wire   [127:0] Y_fp32_int_e;
wire   [126:0] Y_fp32_int_f;
wire   [151:0] Y_fp32_pd;
wire    [31:0] Y_fp_dec_offset;
wire           Y_fp_stage0_prdy;
wire           Y_fp_stage0_pvld;
wire     [9:0] Y_index_lsb;
wire     [9:0] Y_index_lsb_f;
wire     [9:0] Y_index_msb;
wire     [9:0] Y_index_msb_f;
wire           Y_int_stage3_prdy;
wire           Y_int_stage3_pvld;
wire    [15:0] Y_lin_frac_lsb;
wire    [15:0] Y_lin_frac_msb;
wire           Y_offset_rdy;
wire           Y_offset_vld;
wire           Y_oflow_int_lsb;
wire           Y_oflow_int_msb;
wire     [5:0] Y_shift_bits_int16_abs;
wire     [4:0] Y_shift_bits_int8_abs;
wire     [4:0] Y_shift_bits_inv;
wire     [5:0] Y_shift_bits_inv1;
wire    [37:0] Y_shift_int16_f;
wire    [63:0] Y_shift_int16_s;
wire    [21:0] Y_shift_lsb_int8_f;
wire    [31:0] Y_shift_lsb_int8_s;
wire    [21:0] Y_shift_msb_int8_f;
wire    [31:0] Y_shift_msb_int8_s;
wire    [55:0] Y_stage1_in_pd;
wire    [55:0] Y_stage1_in_pd_d0;
wire    [55:0] Y_stage1_in_pd_d1;
wire    [55:0] Y_stage1_in_pd_d2;
wire           Y_stage1_in_rdy;
wire           Y_stage1_in_rdy_d0;
wire           Y_stage1_in_rdy_d1;
wire           Y_stage1_in_rdy_d2;
wire           Y_stage1_in_vld;
wire           Y_stage1_in_vld_d0;
wire           Y_stage1_in_vld_d1;
wire           Y_stage1_in_vld_d2;
wire    [55:0] Y_stage3_out_pd;
wire           Y_stage3_out_rdy;
wire           Y_stage3_out_vld;
wire           Yinput_is_NaN;
wire    [33:0] dat_info;
wire    [33:0] dat_info_index_sub;
wire    [31:0] datin_fp16;
wire           datin_fp16_rdy;
wire           datin_fp16_vld;
wire    [36:0] datin_int16;
wire    [20:0] datin_int8_lsb;
wire    [20:0] datin_int8_msb;
wire    [37:0] dec_Xindex_datin_lsb;
wire    [21:0] dec_Xindex_datin_msb;
wire    [37:0] dec_Yindex_lsb;
wire    [21:0] dec_Yindex_msb;
wire    [37:0] dec_offset_datin_lsb;
wire    [37:0] dec_offset_datin_lsb_f0;
wire    [37:0] dec_offset_datin_lsb_f1;
wire    [21:0] dec_offset_datin_msb;
wire    [21:0] dec_offset_datin_msb_f0;
wire    [21:0] dec_offset_datin_msb_f1;
wire           fp16_X_datin_prdy;
wire           fp16_Y_datin_prdy;
wire    [22:0] fp32_frac;
wire   [127:0] fp32_frac_ext;
wire    [22:0] fp32_frac_f;
wire   [127:0] fp32_frac_f_ext;
wire   [128:0] fp32_int;
wire   [127:0] fp32_int_e;
wire   [126:0] fp32_int_f;
wire   [151:0] fp32_pd;
wire    [15:0] fp_X_frac;
wire    [16:0] fp_X_info;
wire           fp_X_proc_in_vld;
wire     [7:0] fp_X_shift;
wire     [7:0] fp_X_shift_abs;
wire     [6:0] fp_X_shift_inv;
wire           fp_X_stage0_load;
wire           fp_X_stage0_rdy;
wire           fp_X_stage0_vld;
wire           fp_X_stage1_load;
wire           fp_X_stage1_rdy;
wire           fp_X_stage2_rdy;
wire    [31:0] fp_X_start_a_in;
wire    [31:0] fp_X_start_b_in;
wire    [31:0] fp_Xindex_data;
wire    [16:0] fp_Xindex_info;
wire    [17:0] fp_Xshift_info;
wire    [22:0] fp_Xshift_lin_f;
wire   [256:0] fp_Xshift_lin_s;
wire     [9:0] fp_Y_index;
wire    [17:0] fp_Y_index_info;
wire           fp_Y_more1;
wire           fp_Y_proc_in_vld;
wire     [7:0] fp_Y_shift;
wire     [7:0] fp_Y_shift_abs;
wire     [6:0] fp_Y_shift_inv;
wire           fp_Y_stage0_load;
wire           fp_Y_stage0_rdy;
wire           fp_Y_stage0_vld;
wire    [27:0] fp_Y_stage1_pd;
wire    [27:0] fp_Y_stage1_pd_d0;
wire    [27:0] fp_Y_stage1_pd_d1;
wire           fp_Y_stage1_rdy;
wire           fp_Y_stage1_rdy_d0;
wire           fp_Y_stage1_rdy_d1;
wire           fp_Y_stage1_vld_d0;
wire           fp_Y_stage1_vld_d1;
wire    [27:0] fp_Y_stage2_pd;
wire           fp_Y_stage2_rdy;
wire           fp_Y_stage2_vld;
wire    [31:0] fp_Y_start_a_in;
wire    [31:0] fp_Y_start_b_in;
wire    [31:0] fp_Yindex_data;
wire    [17:0] fp_Yshift_info;
wire    [22:0] fp_Yshift_lin_f;
wire   [256:0] fp_Yshift_lin_s;
wire    [31:0] fp_dec_offset;
wire           fp_en_rdy;
wire           fp_en_vld;
wire    [31:0] fp_log2_datin;
wire           fp_out_rdy;
wire           fp_out_vld;
wire           fp_stage0_prdy;
wire           fp_stage0_pvld;
wire           int_X_datin_prdy;
wire           int_X_proc_in_vld;
wire           int_Y_datin_prdy;
wire           int_Y_proc_in_vld;
wire           int_Y_stage0_prdy;
wire           int_Y_stage1_prdy;
wire           int_en_rdy;
wire           int_en_vld;
wire           int_out_rdy;
wire           int_out_vld;
wire           int_stage0_prdy;
wire           int_stage1_prdy;
wire           int_stage2_in_vld;
wire           int_stage2_prdy;
wire           int_stage3_prdy;
wire           less_than_start;
wire           load_din_intY;
wire           load_in_intX;
wire           load_int_Y_stage0;
wire           load_int_stage0;
wire           load_int_stage1;
wire           load_int_stage2;
wire    [37:0] log2_datin_lsb;
wire    [21:0] log2_datin_msb;
wire           log2_datin_vld;
wire           mon_Y_dec_offset_lsb_int8;
wire           mon_dec_Xindex_lsb_int8;
wire           mon_dec_offset_lsb_int8;
wire           mon_fp_X_R_shift;
wire   [127:0] mon_fp_Xshift_lin_f;
wire           mon_fp_Y_shift;
wire   [127:0] mon_fp_Yshift_lin_f;
wire     [1:0] mon_neg_out_f;
wire           more1;
wire     [7:0] neg_out;
wire     [6:0] neg_out_f;
wire     [7:0] neg_out_ff;
wire           offset_rdy;
wire           offset_vld;
wire     [7:0] reg2dp_X_index_offset;
wire    [37:0] reg2dp_X_offset;
wire    [37:0] reg2dp_Y_offset;
wire           same_sign;
wire     [7:0] shift_bits;
wire     [6:0] shift_bits_int16_abs;
wire     [5:0] shift_bits_int8_abs;
wire     [4:0] shift_bits_inv;
wire     [5:0] shift_bits_inv1;
wire    [38:0] shift_int16_f;
wire    [63:0] shift_int16_s;
wire    [22:0] shift_lsb_int8_f;
wire    [31:0] shift_lsb_int8_s;
wire    [22:0] shift_msb_int8_f;
wire    [31:0] shift_msb_int8_s;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    //==============
// Work Processing
//==============

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    X_exp <= 1'b0;
  end else begin
  X_exp <= reg2dp_lut_le_function == 1'h0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    X_exp_s <= 1'b0;
  end else begin
  X_exp_s <= reg2dp_lut_le_function == 1'h0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_shift_bits[7:0] <= {8{1'b0}};
  end else begin
  Y_shift_bits[7:0] <= reg2dp_lut_lo_index_select[7:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sqsum_bypass_enable <= 1'b0;
  end else begin
  sqsum_bypass_enable <= reg2dp_sqsum_bypass == 1'h1;
  end
end
///////////////////////////////////////
assign sum2itp_prdy = fp16_en ? fp_en_rdy : int_en_rdy;
assign int_en_vld   = fp16_en ? 1'b0 : sum2itp_pvld;
assign fp_en_vld    = fp16_en ? sum2itp_pvld : 1'b0;

assign datin_int8_lsb = {21{int8_en }} & sum2itp_pd[20:0];
assign datin_int8_msb = {21{int8_en }} & sum2itp_pd[41:21];
assign datin_int16    = {37{int16_en}} & sum2itp_pd[36:0];
///////////////////////////////////////////////////////////////////////////////////////
//int X Y table input interlock
assign int_X_proc_in_vld = int_en_vld & int_Y_datin_prdy;
assign int_Y_proc_in_vld = int_en_vld & int_X_datin_prdy;
assign int_en_rdy = int_Y_datin_prdy & int_X_datin_prdy;

//////////////////////////////////////////////////////////////////////
//INT8/16 mode index calculation of X table
//////////////////////////////////////////////////////////////////////

//===================================================================
//offset minus for int8/int16 data type
//===================================================================
assign reg2dp_X_offset[37:0] = {reg2dp_lut_le_start_high[5:0],reg2dp_lut_le_start_low[31:0]};

assign load_in_intX = int_X_proc_in_vld & int_X_datin_prdy;
assign dec_offset_datin_lsb_f0[37:0] = int16_en ? {1'b0,datin_int16} : (int8_en ? {17'd0,datin_int8_lsb} : 38'd0);
assign dec_offset_datin_msb_f0[21:0] = int8_en  ? {1'b0,datin_int8_msb} : 22'd0;
assign dec_offset_datin_lsb_f1[37:0] = int16_en ? {datin_int16[36],datin_int16} : (int8_en ? {{17{datin_int8_lsb[20]}},datin_int8_lsb} : 38'd0);
assign dec_offset_datin_msb_f1[21:0] = int8_en  ? {datin_int8_msb[20],datin_int8_msb} : 22'd0;
assign dec_offset_datin_lsb = sqsum_bypass_enable ? dec_offset_datin_lsb_f1 : dec_offset_datin_lsb_f0;
assign dec_offset_datin_msb = sqsum_bypass_enable ? dec_offset_datin_msb_f1 : dec_offset_datin_msb_f0;

//slcg
//////

always @(
  dec_offset_datin_lsb
  or reg2dp_X_offset
  ) begin
    case({dec_offset_datin_lsb[37],reg2dp_X_offset[37]})
    2'b01: less_than_win_start = 1'b0;
    2'b10: less_than_win_start = 1'b1;
    //default: less_than_win_start = (dec_offset_datin_lsb[37:0] < reg2dp_X_offset[37:0]);
    default: less_than_win_start = (dec_offset_datin_lsb[37:0] < reg2dp_X_offset[37:0]) | (dec_offset_datin_lsb[37:0] == reg2dp_X_offset[37:0]);
    endcase
end

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_dec_offset_lsb[0],dec_offset_lsb[37:0]} <= {39{1'b0}};
    int_X_input_uflow_lsb <= 1'b0;
  end else begin
    if(load_in_intX) begin
        if(less_than_win_start) begin
            {mon_dec_offset_lsb[0], dec_offset_lsb[37:0]} <= 39'd0;
            int_X_input_uflow_lsb <= 1'b1;
        end else begin
            {mon_dec_offset_lsb[0], dec_offset_lsb[37:0]} <= ($signed(dec_offset_datin_lsb) - $signed(reg2dp_X_offset[37:0]));
            int_X_input_uflow_lsb <= 1'b0;
        end
    end
  end
end
always @(
  dec_offset_datin_msb
  or reg2dp_X_offset
  ) begin
    case({dec_offset_datin_msb[21],reg2dp_X_offset[21]})
    2'b01: less_than_win_s = 1'b0;
    2'b10: less_than_win_s = 1'b1;
    default: less_than_win_s = (dec_offset_datin_msb[21:0] < reg2dp_X_offset[21:0]) | (dec_offset_datin_msb[21:0] == reg2dp_X_offset[21:0]);
    endcase
end
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_dec_offset_msb[0],dec_offset_msb[21:0]} <= {23{1'b0}};
    int_X_input_uflow_msb <= 1'b0;
  end else begin
    if(load_in_intX) begin
        if(less_than_win_s) begin
            {mon_dec_offset_msb[0], dec_offset_msb[21:0]} <= 23'd0;
            int_X_input_uflow_msb <= 1'b1;
        end else begin
            {mon_dec_offset_msb[0], dec_offset_msb[21:0]} <= ($signed(dec_offset_datin_msb) - $signed(reg2dp_X_offset[21:0]));
            int_X_input_uflow_msb <= 1'b0;
        end
    end
  end
end

assign mon_dec_offset_lsb_int8 = int8_en & (|{mon_dec_offset_lsb, dec_offset_lsb[36:22]});
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
  nv_assert_never #(0,0,"CDP_LUT_ctrl: no overflow is allowed")      zzz_assert_never_1x (nvdla_op_gated_clk_int, `ASSERT_RESET, load_int_stage0 & (|{mon_dec_offset_lsb_int8,mon_dec_offset_lsb,mon_dec_offset_msb})); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign int_X_datin_prdy = ~int_stage0_pvld | int_stage0_prdy;
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_stage0_pvld <= 1'b0;
  end else begin
    if(int_X_proc_in_vld)
        int_stage0_pvld <= 1'b1;
    else if(int_stage0_prdy)
        int_stage0_pvld <= 1'b0;
  end
end
assign int_stage0_prdy = ~int_stage1_pvld | int_stage1_prdy;

assign load_int_stage0 = int_stage0_pvld & int_stage0_prdy;
//===================================================================
//log2 logic for int8/int16, bypassed when X is a linear table
assign log2_datin_lsb = dec_offset_lsb ;
assign log2_datin_msb = dec_offset_msb ;
assign log2_datin_vld = load_int_stage0;

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    log2_datout_lsb[37:0] <= {38{1'b0}};
    log2_frac_lsb[36:0] <= {37{1'b0}};
  end else begin
    if(log2_datin_vld) begin
        if(int_X_input_uflow_lsb) begin
            log2_datout_lsb[37:0] <= 38'd0;
            log2_frac_lsb[36:0]   <= 37'd0;
        end else begin
            if(X_exp) begin
                if(log2_datin_lsb[37]) begin
                    log2_datout_lsb[37:0] <= 38'd37;
                    log2_frac_lsb[36:0]   <= log2_datin_lsb[36:0];
                 end else if(log2_datin_lsb[36]) begin 
                     log2_datout_lsb[37:0] <= 38'd36; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[36-1:0],{(37-36){1'b0}}}; 
                 end else if(log2_datin_lsb[35]) begin 
                     log2_datout_lsb[37:0] <= 38'd35; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[35-1:0],{(37-35){1'b0}}}; 
                 end else if(log2_datin_lsb[34]) begin 
                     log2_datout_lsb[37:0] <= 38'd34; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[34-1:0],{(37-34){1'b0}}}; 
                 end else if(log2_datin_lsb[33]) begin 
                     log2_datout_lsb[37:0] <= 38'd33; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[33-1:0],{(37-33){1'b0}}}; 
                 end else if(log2_datin_lsb[32]) begin 
                     log2_datout_lsb[37:0] <= 38'd32; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[32-1:0],{(37-32){1'b0}}}; 
                 end else if(log2_datin_lsb[31]) begin 
                     log2_datout_lsb[37:0] <= 38'd31; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[31-1:0],{(37-31){1'b0}}}; 
                 end else if(log2_datin_lsb[30]) begin 
                     log2_datout_lsb[37:0] <= 38'd30; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[30-1:0],{(37-30){1'b0}}}; 
                 end else if(log2_datin_lsb[29]) begin 
                     log2_datout_lsb[37:0] <= 38'd29; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[29-1:0],{(37-29){1'b0}}}; 
                 end else if(log2_datin_lsb[28]) begin 
                     log2_datout_lsb[37:0] <= 38'd28; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[28-1:0],{(37-28){1'b0}}}; 
                 end else if(log2_datin_lsb[27]) begin 
                     log2_datout_lsb[37:0] <= 38'd27; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[27-1:0],{(37-27){1'b0}}}; 
                 end else if(log2_datin_lsb[26]) begin 
                     log2_datout_lsb[37:0] <= 38'd26; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[26-1:0],{(37-26){1'b0}}}; 
                 end else if(log2_datin_lsb[25]) begin 
                     log2_datout_lsb[37:0] <= 38'd25; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[25-1:0],{(37-25){1'b0}}}; 
                 end else if(log2_datin_lsb[24]) begin 
                     log2_datout_lsb[37:0] <= 38'd24; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[24-1:0],{(37-24){1'b0}}}; 
                 end else if(log2_datin_lsb[23]) begin 
                     log2_datout_lsb[37:0] <= 38'd23; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[23-1:0],{(37-23){1'b0}}}; 
                 end else if(log2_datin_lsb[22]) begin 
                     log2_datout_lsb[37:0] <= 38'd22; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[22-1:0],{(37-22){1'b0}}}; 
                 end else if(log2_datin_lsb[21]) begin 
                     log2_datout_lsb[37:0] <= 38'd21; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[21-1:0],{(37-21){1'b0}}}; 
                 end else if(log2_datin_lsb[20]) begin 
                     log2_datout_lsb[37:0] <= 38'd20; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[20-1:0],{(37-20){1'b0}}}; 
                 end else if(log2_datin_lsb[19]) begin 
                     log2_datout_lsb[37:0] <= 38'd19; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[19-1:0],{(37-19){1'b0}}}; 
                 end else if(log2_datin_lsb[18]) begin 
                     log2_datout_lsb[37:0] <= 38'd18; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[18-1:0],{(37-18){1'b0}}}; 
                 end else if(log2_datin_lsb[17]) begin 
                     log2_datout_lsb[37:0] <= 38'd17; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[17-1:0],{(37-17){1'b0}}}; 
                 end else if(log2_datin_lsb[16]) begin 
                     log2_datout_lsb[37:0] <= 38'd16; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[16-1:0],{(37-16){1'b0}}}; 
                 end else if(log2_datin_lsb[15]) begin 
                     log2_datout_lsb[37:0] <= 38'd15; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[15-1:0],{(37-15){1'b0}}}; 
                 end else if(log2_datin_lsb[14]) begin 
                     log2_datout_lsb[37:0] <= 38'd14; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[14-1:0],{(37-14){1'b0}}}; 
                 end else if(log2_datin_lsb[13]) begin 
                     log2_datout_lsb[37:0] <= 38'd13; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[13-1:0],{(37-13){1'b0}}}; 
                 end else if(log2_datin_lsb[12]) begin 
                     log2_datout_lsb[37:0] <= 38'd12; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[12-1:0],{(37-12){1'b0}}}; 
                 end else if(log2_datin_lsb[11]) begin 
                     log2_datout_lsb[37:0] <= 38'd11; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[11-1:0],{(37-11){1'b0}}}; 
                 end else if(log2_datin_lsb[10]) begin 
                     log2_datout_lsb[37:0] <= 38'd10; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[10-1:0],{(37-10){1'b0}}}; 
                 end else if(log2_datin_lsb[9]) begin 
                     log2_datout_lsb[37:0] <= 38'd9; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[9-1:0],{(37-9){1'b0}}}; 
                 end else if(log2_datin_lsb[8]) begin 
                     log2_datout_lsb[37:0] <= 38'd8; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[8-1:0],{(37-8){1'b0}}}; 
                 end else if(log2_datin_lsb[7]) begin 
                     log2_datout_lsb[37:0] <= 38'd7; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[7-1:0],{(37-7){1'b0}}}; 
                 end else if(log2_datin_lsb[6]) begin 
                     log2_datout_lsb[37:0] <= 38'd6; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[6-1:0],{(37-6){1'b0}}}; 
                 end else if(log2_datin_lsb[5]) begin 
                     log2_datout_lsb[37:0] <= 38'd5; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[5-1:0],{(37-5){1'b0}}}; 
                 end else if(log2_datin_lsb[4]) begin 
                     log2_datout_lsb[37:0] <= 38'd4; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[4-1:0],{(37-4){1'b0}}}; 
                 end else if(log2_datin_lsb[3]) begin 
                     log2_datout_lsb[37:0] <= 38'd3; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[3-1:0],{(37-3){1'b0}}}; 
                 end else if(log2_datin_lsb[2]) begin 
                     log2_datout_lsb[37:0] <= 38'd2; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[2-1:0],{(37-2){1'b0}}}; 
                 end else if(log2_datin_lsb[1]) begin 
                     log2_datout_lsb[37:0] <= 38'd1; 
                     log2_frac_lsb[36:0]   <= {log2_datin_lsb[1-1:0],{(37-1){1'b0}}}; 
                end else if(log2_datin_lsb[0])  begin
                    log2_datout_lsb[37:0] <= 38'd0;
                    log2_frac_lsb[36:0]   <= 37'd0;
                end
            end else
                log2_datout_lsb[37:0] <= log2_datin_lsb;
        end
    end
  end
end
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    log2_datout_msb[21:0] <= {22{1'b0}};
    log2_frac_msb[20:0] <= {21{1'b0}};
  end else begin
    if(log2_datin_vld) begin
        if(int_X_input_uflow_msb) begin
            log2_datout_msb[21:0] <= 22'd0;
            log2_frac_msb[20:0]   <= 21'd0;
        end else begin
            if(X_exp) begin
                    if(log2_datin_msb[21]) begin
                        log2_datout_msb[21:0] <= 22'd21;
                        log2_frac_msb[20:0]   <= log2_datin_msb[20:0];
                     end else if(log2_datin_msb[20]) begin
                         log2_datout_msb[21:0] <= 22'd20; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[20-1:0],{(21-20){1'b0}}}; 
                     end else if(log2_datin_msb[19]) begin
                         log2_datout_msb[21:0] <= 22'd19; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[19-1:0],{(21-19){1'b0}}}; 
                     end else if(log2_datin_msb[18]) begin
                         log2_datout_msb[21:0] <= 22'd18; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[18-1:0],{(21-18){1'b0}}}; 
                     end else if(log2_datin_msb[17]) begin
                         log2_datout_msb[21:0] <= 22'd17; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[17-1:0],{(21-17){1'b0}}}; 
                     end else if(log2_datin_msb[16]) begin
                         log2_datout_msb[21:0] <= 22'd16; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[16-1:0],{(21-16){1'b0}}}; 
                     end else if(log2_datin_msb[15]) begin
                         log2_datout_msb[21:0] <= 22'd15; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[15-1:0],{(21-15){1'b0}}}; 
                     end else if(log2_datin_msb[14]) begin
                         log2_datout_msb[21:0] <= 22'd14; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[14-1:0],{(21-14){1'b0}}}; 
                     end else if(log2_datin_msb[13]) begin
                         log2_datout_msb[21:0] <= 22'd13; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[13-1:0],{(21-13){1'b0}}}; 
                     end else if(log2_datin_msb[12]) begin
                         log2_datout_msb[21:0] <= 22'd12; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[12-1:0],{(21-12){1'b0}}}; 
                     end else if(log2_datin_msb[11]) begin
                         log2_datout_msb[21:0] <= 22'd11; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[11-1:0],{(21-11){1'b0}}}; 
                     end else if(log2_datin_msb[10]) begin
                         log2_datout_msb[21:0] <= 22'd10; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[10-1:0],{(21-10){1'b0}}}; 
                     end else if(log2_datin_msb[9]) begin
                         log2_datout_msb[21:0] <= 22'd9; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[9-1:0],{(21-9){1'b0}}}; 
                     end else if(log2_datin_msb[8]) begin
                         log2_datout_msb[21:0] <= 22'd8; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[8-1:0],{(21-8){1'b0}}}; 
                     end else if(log2_datin_msb[7]) begin
                         log2_datout_msb[21:0] <= 22'd7; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[7-1:0],{(21-7){1'b0}}}; 
                     end else if(log2_datin_msb[6]) begin
                         log2_datout_msb[21:0] <= 22'd6; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[6-1:0],{(21-6){1'b0}}}; 
                     end else if(log2_datin_msb[5]) begin
                         log2_datout_msb[21:0] <= 22'd5; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[5-1:0],{(21-5){1'b0}}}; 
                     end else if(log2_datin_msb[4]) begin
                         log2_datout_msb[21:0] <= 22'd4; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[4-1:0],{(21-4){1'b0}}}; 
                     end else if(log2_datin_msb[3]) begin
                         log2_datout_msb[21:0] <= 22'd3; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[3-1:0],{(21-3){1'b0}}}; 
                     end else if(log2_datin_msb[2]) begin
                         log2_datout_msb[21:0] <= 22'd2; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[2-1:0],{(21-2){1'b0}}}; 
                     end else if(log2_datin_msb[1]) begin
                         log2_datout_msb[21:0] <= 22'd1; 
                         log2_frac_msb[20:0]   <= {log2_datin_msb[1-1:0],{(21-1){1'b0}}}; 
                    end else if(log2_datin_msb[0]) begin
                        log2_datout_msb[21:0] <= 22'd0;
                        log2_frac_msb[20:0]   <= 21'd0;
                    end
            end else
                log2_datout_msb[21:0] <= log2_datin_msb;
        end
    end
  end
end

assign X_exp_frac_lsb = log2_frac_lsb[36:21];
assign X_exp_frac_msb = log2_frac_msb[20:5];

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_X_input_uflow_d <= {2{1'b0}};
  end else begin
    if(log2_datin_vld)
        int_X_input_uflow_d <= {int_X_input_uflow_msb,int_X_input_uflow_lsb};
  end
end

assign dat_info = {int_X_input_uflow_d,X_exp_frac_msb,X_exp_frac_lsb};
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_stage1_pvld <= 1'b0;
  end else begin
    if(int_stage0_pvld)
        int_stage1_pvld <= 1'b1;
    else if(int_stage1_prdy)
        int_stage1_pvld <= 1'b0;
  end
end
assign int_stage1_prdy = ~int_stage2_pvld | int_stage2_prdy;

//===================================================================
//exp index offset for int8/int16, only valid for exponent table
//assign reg2dp_X_index_offset[7:0] = X_exp ? reg2dp_lut_le_index_offset[7:0] : 8'd0;//i8 type
assign reg2dp_X_index_offset[7:0] = reg2dp_lut_le_index_offset[7:0];

assign load_int_stage1 = int_stage1_pvld & int_stage1_prdy;
assign int_stage2_in_vld = int_stage1_pvld;
assign dec_Xindex_datin_lsb[37:0] = log2_datout_lsb;
assign dec_Xindex_datin_msb[21:0] = log2_datout_msb;
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_dec_Xindex_lsb[0],dec_Xindex_lsb[38:0]} <= {40{1'b0}};
    int_X_index_uflow_lsb <= 1'b0;
  end else begin
    if(load_int_stage1) begin
        if(dat_info[32]) begin //lsb uflow
            {mon_dec_Xindex_lsb[0], dec_Xindex_lsb[38:0]} <= 40'd0;
            int_X_index_uflow_lsb <= 1'b0;
        end else if(X_exp) begin
            if((dec_Xindex_datin_lsb < {31'd0,reg2dp_X_index_offset[6:0]}) & (~reg2dp_X_index_offset[7])) begin
                {mon_dec_Xindex_lsb[0], dec_Xindex_lsb[38:0]} <= 40'd0;
                int_X_index_uflow_lsb <= 1'b1;
            end else begin
                {mon_dec_Xindex_lsb[0], dec_Xindex_lsb[38:0]} <= ($signed({1'b0,dec_Xindex_datin_lsb[37:0]}) - $signed({{31{reg2dp_X_index_offset[7]}},reg2dp_X_index_offset[7:0]}));
                int_X_index_uflow_lsb <= 1'b0;
            end
        end else begin
            {mon_dec_Xindex_lsb[0], dec_Xindex_lsb[38:0]} <= {2'd0,dec_Xindex_datin_lsb};
            int_X_index_uflow_lsb <= 1'b0;
        end
    end
  end
end
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_dec_Xindex_msb[0],dec_Xindex_msb[22:0]} <= {24{1'b0}};
    int_X_index_uflow_msb <= 1'b0;
  end else begin
    if(load_int_stage1) begin
        if(dat_info[33]) begin //msb uflow
            {mon_dec_Xindex_msb[0], dec_Xindex_msb[22:0]} <= 24'd0;
            int_X_index_uflow_msb <= 1'b0;
        end else if(X_exp) begin
            if((dec_Xindex_datin_msb < {15'd0,reg2dp_X_index_offset[6:0]}) & (~reg2dp_X_index_offset[7])) begin
                {mon_dec_Xindex_msb[0], dec_Xindex_msb[22:0]} <= 24'd0;
                int_X_index_uflow_msb <= 1'b1;
            end else begin
                {mon_dec_Xindex_msb[0], dec_Xindex_msb[22:0]} <= $signed({1'b0,dec_Xindex_datin_msb[21:0]}) - $signed({{15{reg2dp_X_index_offset[7]}},reg2dp_X_index_offset[7:0]});
                int_X_index_uflow_msb <= 1'b0;
            end
        end else begin
            {mon_dec_Xindex_msb[0], dec_Xindex_msb[22:0]} <= {2'd0,dec_Xindex_datin_msb};
            int_X_index_uflow_msb <= 1'b0;
        end
    end
  end
end
assign mon_dec_Xindex_lsb_int8 = int8_en & (|{mon_dec_Xindex_lsb, dec_Xindex_lsb[38:23]});
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
  nv_assert_never #(0,0,"CDP_LUT_ctrl: no overflow is allowed")      zzz_assert_never_2x (nvdla_op_gated_clk_int, `ASSERT_RESET, load_int_stage2 & (mon_dec_Xindex_lsb_int8|(|mon_dec_Xindex_lsb)|(|mon_dec_Xindex_msb))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_info_d <= {34{1'b0}};
  end else begin
  if ((load_int_stage1) == 1'b1) begin
    dat_info_d <= dat_info;
  // VCS coverage off
  end else if ((load_int_stage1) == 1'b0) begin
  end else begin
    dat_info_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_op_gated_clk_int, `ASSERT_RESET, 1'd1,  (^(load_int_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dat_info_index_sub = {dat_info_d[33:32] | {int_X_index_uflow_msb,int_X_index_uflow_lsb}, dat_info_d[31:0]};

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_stage2_pvld <= 1'b0;
  end else begin
    if(int_stage2_in_vld)
        int_stage2_pvld <= 1'b1;
    else if(int_stage2_prdy)
        int_stage2_pvld <= 1'b0;
  end
end
assign int_stage2_prdy = ~int_stage3_pvld | int_stage3_prdy;

assign load_int_stage2 = int_stage2_pvld & int_stage2_prdy;

//===================================================================
//shift process for int8/int16, linear only, shift "0" when exponent X
assign shift_bits[7:0] = X_exp ? 8'd0 : reg2dp_lut_le_index_select[7:0];
assign shift_bits_inv[4:0]  = ~shift_bits[4:0];
assign shift_bits_inv1[5:0] = ~shift_bits[5:0];
assign shift_bits_int8_abs[5:0]  = shift_bits[5]? (shift_bits_inv[4:0] +1) : shift_bits[4:0];
assign shift_bits_int16_abs[6:0] = shift_bits[6]? (shift_bits_inv1[5:0]+1) : shift_bits[5:0];

//assign {shift_int16_s[38:0],   shift_int16_f[38:0]   } = shift_bits[6]? ({39'd0,dec_Xindex_lsb[38:0]}<<shift_bits_int16_abs) : ({dec_Xindex_lsb[38:0],39'd0}>>shift_bits_int16_abs);
//assign {shift_lsb_int8_s[22:0],shift_lsb_int8_f[22:0]} = shift_bits[5]? ({23'd0,dec_Xindex_lsb[22:0]}<<shift_bits_int8_abs ) : ({dec_Xindex_lsb[22:0],23'd0}>>shift_bits_int8_abs );
//assign {shift_msb_int8_s[22:0],shift_msb_int8_f[22:0]} = shift_bits[5]? ({23'd0,dec_Xindex_msb[22:0]}<<shift_bits_int8_abs ) : ({dec_Xindex_msb[22:0],23'd0}>>shift_bits_int8_abs );
assign {shift_int16_s[63:0],   shift_int16_f[38:0]   } = shift_bits[6]? ({64'd0,dec_Xindex_lsb[38:0]}<<shift_bits_int16_abs) : ({25'd0,dec_Xindex_lsb[38:0],39'd0}>>shift_bits_int16_abs);
assign {shift_lsb_int8_s[31:0],shift_lsb_int8_f[22:0]} = shift_bits[5]? ({32'd0,dec_Xindex_lsb[22:0]}<<shift_bits_int8_abs ) : ({9'd0,dec_Xindex_lsb[22:0],23'd0}>>shift_bits_int8_abs );
assign {shift_msb_int8_s[31:0],shift_msb_int8_f[22:0]} = shift_bits[5]? ({32'd0,dec_Xindex_msb[22:0]}<<shift_bits_int8_abs ) : ({9'd0,dec_Xindex_msb[22:0],23'd0}>>shift_bits_int8_abs );

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    shift_int16[9:0] <= {10{1'b0}};
    X_int16_oflow <= 1'b0;
  end else begin
    if(load_int_stage2) begin
        if(dat_info_index_sub[32]) begin //lsb uflow
            shift_int16[9:0] <= 10'd0;
            X_int16_oflow <= 1'b0;
        end else if(shift_bits[6]) begin
            if({shift_int16_s,shift_int16_f} >= (65 -1)) begin
                shift_int16[9:0] <= 65  - 1;
                X_int16_oflow <= 1'b1;
            end else begin
                shift_int16[9:0] <= shift_int16_f[9:0];
                X_int16_oflow <= 1'b0;
            end
        end else begin
            if(shift_int16_s >= (65 -1)) begin
                shift_int16[9:0] <= 65  - 1;
                X_int16_oflow <= 1'b1;
            end else begin
                shift_int16[9:0] <= shift_int16_s[9:0];
                X_int16_oflow <= 1'b0;
            end
        end
    end
  end
end

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    shift_lsb_int8[9:0] <= {10{1'b0}};
    X_int8_oflow_lsb <= 1'b0;
  end else begin
    if(load_int_stage2) begin
        if(dat_info_index_sub[32]) begin //lsb uflow
            shift_lsb_int8[9:0] <= 10'd0;//7'd64;
            X_int8_oflow_lsb <= 1'b0;
        end else if(shift_bits[5]) begin
            if({shift_lsb_int8_s,shift_lsb_int8_f} >= (65 -1)) begin
                shift_lsb_int8[9:0] <= 65  - 1;//7'd64;
                X_int8_oflow_lsb <= 1'b1;
            end else begin
                shift_lsb_int8[9:0] <= shift_lsb_int8_f[9:0];
                X_int8_oflow_lsb <= 1'b0;
            end
        end else begin
            if(shift_lsb_int8_s >= (65 -1)) begin
                shift_lsb_int8[9:0] <= 65  - 1;//7'd64;
                X_int8_oflow_lsb <= 1'b1;
            end else begin
                shift_lsb_int8[9:0] <= shift_lsb_int8_s[9:0];
                X_int8_oflow_lsb <= 1'b0;
            end
        end
    end
  end
end
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    shift_msb_int8[9:0] <= {10{1'b0}};
    X_int8_oflow_msb <= 1'b0;
  end else begin
    if(load_int_stage2) begin
        if(dat_info_index_sub[33]) begin //lsb uflow
            shift_msb_int8[9:0] <= 10'd0;//7'd64;
            X_int8_oflow_msb <= 1'b0;
        end else if(shift_bits[5]) begin
            if({shift_msb_int8_s,shift_msb_int8_f} >= (65 -1)) begin
                shift_msb_int8[9:0] <= 65  - 1;//7'd64;
                X_int8_oflow_msb <= 1'b1;
            end else begin
                shift_msb_int8[9:0] <= shift_msb_int8_f[9:0];
                X_int8_oflow_msb <= 1'b0;
            end
        end else begin
            if(shift_msb_int8_s >= (65 -1)) begin
                shift_msb_int8[9:0] <= 65  - 1;//7'd64;
                X_int8_oflow_msb <= 1'b1;
            end else begin
                shift_msb_int8[9:0] <= shift_msb_int8_s[9:0];
                X_int8_oflow_msb <= 1'b0;
            end
        end
    end
  end
end
assign X_oflow_int_lsb = int16_en ? X_int16_oflow : (int8_en ? X_int8_oflow_lsb : 1'b0);
assign X_oflow_int_msb = X_int8_oflow_msb;
assign X_index_lsb = int16_en ? shift_int16 : (int8_en ? shift_lsb_int8 : 10'd0);
assign X_index_msb = shift_msb_int8;
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    X_lin_frac_int16[15:0] <= {16{1'b0}};
  end else begin
    if(load_int_stage2) begin
        if(shift_bits[6])
            X_lin_frac_int16[15:0] <= 16'd0;
        else
            X_lin_frac_int16[15:0] <= shift_int16_f[38:23];
    end
  end
end
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    X_lin_frac_int8_lsb[15:0] <= {16{1'b0}};
  end else begin
    if(load_int_stage2) begin
        if(shift_bits[5])
            X_lin_frac_int8_lsb[15:0] <= 16'd0;
        else
            X_lin_frac_int8_lsb[15:0] <= shift_lsb_int8_f[22:7];
    end
  end
end
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    X_lin_frac_int8_msb[15:0] <= {16{1'b0}};
  end else begin
    if(load_int_stage2) begin
        if(shift_bits[5])
            X_lin_frac_int8_msb[15:0] <= 16'd0;
        else
            X_lin_frac_int8_msb[15:0] <= shift_msb_int8_f[22:7];
    end
  end
end

assign X_lin_frac_lsb = int16_en ? X_lin_frac_int16 : (int8_en ? X_lin_frac_int8_lsb : 16'd0);
assign X_lin_frac_msb = X_lin_frac_int8_msb;
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_info_shift[33:0] <= {34{1'b0}};
  end else begin
  if ((load_int_stage2) == 1'b1) begin
    dat_info_shift[33:0] <= dat_info_index_sub;
  // VCS coverage off
  end else if ((load_int_stage2) == 1'b0) begin
  end else begin
    dat_info_shift[33:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_op_gated_clk_int, `ASSERT_RESET, 1'd1,  (^(load_int_stage2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign X_frac_lsb = X_exp ? dat_info_shift[15:0]  : X_lin_frac_lsb;
assign X_frac_msb = X_exp ? dat_info_shift[31:16] : X_lin_frac_msb;
assign X_dat_info   = {X_oflow_int_msb,X_oflow_int_lsb,dat_info_shift[33:32],X_frac_msb,X_frac_lsb};
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
  nv_assert_never #(0,0,"CDP INT X table lsb info: uflow and oflow occured at same time")      zzz_assert_never_5x (nvdla_op_gated_clk_int, `ASSERT_RESET, int_stage3_pvld & dat_info_shift[32] & X_oflow_int_lsb); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"CDP INT X table msb info: uflow and oflow occured at same time")      zzz_assert_never_6x (nvdla_op_gated_clk_int, `ASSERT_RESET, int_stage3_pvld & dat_info_shift[33] & X_oflow_int_msb); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_stage3_pvld <= 1'b0;
  end else begin
    if(int_stage2_pvld)
        int_stage3_pvld <= 1'b1;
    else if(int_stage3_prdy)
        int_stage3_pvld <= 1'b0;
  end
end
//assign int_stage3_prdy = ~int_stage4_pvld | int_stage4_prdy;

//assign load_int_stage3 = int_stage3_pvld & int_stage3_prdy;

//////////////////////////////////////////////////////////////////////
//INT8/16 mode index calculation of Y table
//////////////////////////////////////////////////////////////////////

//===================================================================
//input offset for Y int8/int16 data type
//===================================================================
assign reg2dp_Y_offset[37:0] = {reg2dp_lut_lo_start_high[5:0],reg2dp_lut_lo_start_low[31:0]};

assign load_din_intY = int_Y_proc_in_vld & int_Y_datin_prdy;

always @(
  dec_offset_datin_lsb
  or reg2dp_Y_offset
  ) begin
    case({dec_offset_datin_lsb[37],reg2dp_Y_offset[37]})
    2'b01: Y_less_than_win_start = 1'b0;
    2'b10: Y_less_than_win_start = 1'b1;
    //default: Y_less_than_win_start = (dec_offset_datin_lsb[37:0] < reg2dp_Y_offset[37:0]);
    default: Y_less_than_win_start = (dec_offset_datin_lsb[37:0] < reg2dp_Y_offset[37:0]) | (dec_offset_datin_lsb[37:0] == reg2dp_Y_offset[37:0]);
    endcase
end
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_Y_dec_offset_lsb[0],Y_dec_offset_lsb[37:0]} <= {39{1'b0}};
    int_Y_input_uflow_lsb <= 1'b0;
  end else begin
    if(load_din_intY) begin
        if(Y_less_than_win_start) begin
            {mon_Y_dec_offset_lsb[0], Y_dec_offset_lsb[37:0]} <= 39'd0;
            int_Y_input_uflow_lsb <= 1'b1;
        end else begin
            {mon_Y_dec_offset_lsb[0], Y_dec_offset_lsb[37:0]} <= ($signed(dec_offset_datin_lsb) - $signed(reg2dp_Y_offset[37:0]));
            int_Y_input_uflow_lsb <= 1'b0;
        end
    end
  end
end
always @(
  dec_offset_datin_msb
  or reg2dp_Y_offset
  ) begin
    case({dec_offset_datin_msb[21],reg2dp_Y_offset[21]})
    2'b01: Y_less_than_win_s = 1'b0;
    2'b10: Y_less_than_win_s = 1'b1;
    default: Y_less_than_win_s = (dec_offset_datin_msb[21:0] < reg2dp_Y_offset[21:0]) | (dec_offset_datin_msb[21:0] == reg2dp_Y_offset[21:0]);
    endcase
end
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_Y_dec_offset_msb[0],Y_dec_offset_msb[21:0]} <= {23{1'b0}};
    int_Y_input_uflow_msb <= 1'b0;
  end else begin
    if(load_din_intY) begin
        if(Y_less_than_win_s) begin
            {mon_Y_dec_offset_msb[0], Y_dec_offset_msb[21:0]} <= 23'd0;
            int_Y_input_uflow_msb <= 1'b1;
        end else begin
            {mon_Y_dec_offset_msb[0], Y_dec_offset_msb[21:0]} <= ($signed(dec_offset_datin_msb) - $signed(reg2dp_Y_offset[21:0]));
            int_Y_input_uflow_msb <= 1'b0;
        end
    end
  end
end

assign mon_Y_dec_offset_lsb_int8 = int8_en & (|{mon_Y_dec_offset_lsb, Y_dec_offset_lsb[36:22]});
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
  nv_assert_never #(0,0,"CDP_LUT_ctrl: no overflow is allowed")      zzz_assert_never_7x (nvdla_op_gated_clk_int, `ASSERT_RESET, load_int_Y_stage0 & (|{mon_Y_dec_offset_lsb_int8,mon_Y_dec_offset_lsb,mon_Y_dec_offset_msb})); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign int_Y_datin_prdy = ~int_Y_stage0_pvld | int_Y_stage0_prdy;
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_Y_stage0_pvld <= 1'b0;
  end else begin
    if(int_Y_proc_in_vld)
        int_Y_stage0_pvld <= 1'b1;
    else if(int_Y_stage0_prdy)
        int_Y_stage0_pvld <= 1'b0;
  end
end
assign int_Y_stage0_prdy =~int_Y_stage1_pvld | int_Y_stage1_prdy;

assign load_int_Y_stage0 = int_Y_stage0_pvld & int_Y_stage0_prdy;

//===================================================================
//shift process for Y int8/int16, Y is linear only
//===================================================================
assign dec_Yindex_lsb = Y_dec_offset_lsb;
assign dec_Yindex_msb = Y_dec_offset_msb;

assign Y_shift_bits_inv[4:0]  = ~Y_shift_bits[4:0];
assign Y_shift_bits_inv1[5:0] = ~Y_shift_bits[5:0];
assign Y_shift_bits_int8_abs  = Y_shift_bits[5]? (Y_shift_bits_inv[4:0] +1) : Y_shift_bits[4:0];
assign Y_shift_bits_int16_abs = Y_shift_bits[6]? (Y_shift_bits_inv1[5:0]+1) : Y_shift_bits[5:0];

//assign {Y_shift_int16_s[37:0]   ,Y_shift_int16_f[37:0]}    = Y_shift_bits[6]? ({38'd0,dec_Yindex_lsb[37:0]} << Y_shift_bits_int16_abs) : ({dec_Yindex_lsb[37:0],38'd0} >> Y_shift_bits_int16_abs);
//assign {Y_shift_lsb_int8_s[21:0],Y_shift_lsb_int8_f[21:0]} = Y_shift_bits[5]? ({22'd0,dec_Yindex_lsb[21:0]} << Y_shift_bits_int8_abs ) : ({dec_Yindex_lsb[21:0],22'd0} >> Y_shift_bits_int8_abs);
//assign {Y_shift_msb_int8_s[21:0],Y_shift_msb_int8_f[21:0]} = Y_shift_bits[5]? ({22'd0,dec_Yindex_msb[21:0]} << Y_shift_bits_int8_abs ) : ({dec_Yindex_msb[21:0],22'd0} >> Y_shift_bits_int8_abs);
assign {Y_shift_int16_s[63:0]   ,Y_shift_int16_f[37:0]}    = Y_shift_bits[6]? ({64'd0,dec_Yindex_lsb[37:0]} << Y_shift_bits_int16_abs) : ({26'd0,dec_Yindex_lsb[37:0],38'd0} >> Y_shift_bits_int16_abs);
assign {Y_shift_lsb_int8_s[31:0],Y_shift_lsb_int8_f[21:0]} = Y_shift_bits[5]? ({32'd0,dec_Yindex_lsb[21:0]} << Y_shift_bits_int8_abs ) : ({10'd0,dec_Yindex_lsb[21:0],22'd0} >> Y_shift_bits_int8_abs);
assign {Y_shift_msb_int8_s[31:0],Y_shift_msb_int8_f[21:0]} = Y_shift_bits[5]? ({32'd0,dec_Yindex_msb[21:0]} << Y_shift_bits_int8_abs ) : ({10'd0,dec_Yindex_msb[21:0],22'd0} >> Y_shift_bits_int8_abs);

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_shift_int16[9:0] <= {10{1'b0}};
    Y_int16_oflow <= 1'b0;
  end else begin
    if(load_int_Y_stage0) begin
        if(int_Y_input_uflow_lsb) begin
            Y_shift_int16[9:0] <= 10'd0;
            Y_int16_oflow <= 1'b0;
        end else if(Y_shift_bits[6]) begin
            if({Y_shift_int16_s,Y_shift_int16_f} >= (257 -1)) begin
                Y_shift_int16[9:0] <= 257  - 1;
                Y_int16_oflow <= 1'b1;
            end else begin
                Y_shift_int16[9:0] <= Y_shift_int16_f[9:0];
                Y_int16_oflow <= 1'b0;
            end
        end else begin
            if(Y_shift_int16_s >= (257 -1)) begin
                Y_shift_int16[9:0] <= 257  - 1;
                Y_int16_oflow <= 1'b1;
            end else begin
                Y_shift_int16[9:0] <= Y_shift_int16_s[9:0];
                Y_int16_oflow <= 1'b0;
            end
        end
    end
  end
end

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_shift_lsb_int8[9:0] <= {10{1'b0}};
    Y_int8_oflow_lsb <= 1'b0;
  end else begin
    if(load_int_Y_stage0) begin
        if(int_Y_input_uflow_lsb) begin
            Y_shift_lsb_int8[9:0] <= 10'd0;
            Y_int8_oflow_lsb <= 1'b0;
        end else if(Y_shift_bits[5]) begin
            if({Y_shift_lsb_int8_s,Y_shift_lsb_int8_f} >= (257 -1)) begin
                Y_shift_lsb_int8[9:0] <= 257  - 1;
                Y_int8_oflow_lsb <= 1'b1;
            end else begin
                Y_shift_lsb_int8[9:0] <= Y_shift_lsb_int8_f[9:0];
                Y_int8_oflow_lsb <= 1'b0;
            end
        end else begin
            if(Y_shift_lsb_int8_s >= (257 -1)) begin
                Y_shift_lsb_int8[9:0] <= 257  - 1;
                Y_int8_oflow_lsb <= 1'b1;
            end else begin
                Y_shift_lsb_int8[9:0] <= Y_shift_lsb_int8_s[9:0];
                Y_int8_oflow_lsb <= 1'b0;
            end
        end
    end
  end
end

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_shift_msb_int8[9:0] <= {10{1'b0}};
    Y_int8_oflow_msb <= 1'b0;
  end else begin
    if(load_int_Y_stage0) begin
        if(int_Y_input_uflow_msb) begin
            Y_shift_msb_int8[9:0] <= 10'd0;
            Y_int8_oflow_msb <= 1'b0;
        end else if(Y_shift_bits[5]) begin
            if({Y_shift_msb_int8_s,Y_shift_msb_int8_f} >= (257 -1)) begin
                Y_shift_msb_int8[9:0] <= 257  - 1;
                Y_int8_oflow_msb <= 1'b1;
            end else begin
                Y_shift_msb_int8[9:0] <= Y_shift_msb_int8_f[9:0];
                Y_int8_oflow_msb <= 1'b0;
            end
        end else begin
            if(Y_shift_msb_int8_s >= (257 -1)) begin
                Y_shift_msb_int8[9:0] <= 257  - 1;
                Y_int8_oflow_msb <= 1'b1;
            end else begin
                Y_shift_msb_int8[9:0] <= Y_shift_msb_int8_s[9:0];
                Y_int8_oflow_msb <= 1'b0;
            end
        end
    end
  end
end
assign Y_oflow_int_lsb = int16_en ? Y_int16_oflow : (int8_en ? Y_int8_oflow_lsb : 1'b0);
assign Y_oflow_int_msb = Y_int8_oflow_msb;
assign Y_index_lsb_f = int16_en ? Y_shift_int16 : (int8_en ? Y_shift_lsb_int8 : 10'd0);
assign Y_index_msb_f = Y_shift_msb_int8;
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_lin_frac_int16[15:0] <= {16{1'b0}};
  end else begin
    if(load_int_Y_stage0) begin
        if(Y_shift_bits[6])
            Y_lin_frac_int16[15:0] <= 16'd0;
        else
            Y_lin_frac_int16[15:0] <= Y_shift_int16_f[37:22];
    end
  end
end
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_lin_frac_int8_lsb[15:0] <= {16{1'b0}};
  end else begin
    if(load_int_Y_stage0) begin
        if(Y_shift_bits[5])
            Y_lin_frac_int8_lsb[15:0] <= 16'd0;
        else
            Y_lin_frac_int8_lsb[15:0] <= Y_shift_lsb_int8_f[21:6];
    end
  end
end
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_lin_frac_int8_msb[15:0] <= {16{1'b0}};
  end else begin
    if(load_int_Y_stage0) begin
        if(Y_shift_bits[5])
            Y_lin_frac_int8_msb[15:0] <= 16'd0;
        else
            Y_lin_frac_int8_msb[15:0] <= Y_shift_msb_int8_f[21:6];
    end
  end
end

assign Y_lin_frac_lsb = int16_en ? Y_lin_frac_int16 : (int8_en ? Y_lin_frac_int8_lsb : 16'd0);
assign Y_lin_frac_msb = Y_lin_frac_int8_msb;
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    Y_dat_info_shift <= {2{1'b0}};
  end else begin
  if ((load_int_Y_stage0) == 1'b1) begin
    Y_dat_info_shift <= {int_Y_input_uflow_msb,int_Y_input_uflow_lsb};
  // VCS coverage off
  end else if ((load_int_Y_stage0) == 1'b0) begin
  end else begin
    Y_dat_info_shift <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_op_gated_clk_int, `ASSERT_RESET, 1'd1,  (^(load_int_Y_stage0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign Y_dat_info_f   = {Y_oflow_int_msb,Y_oflow_int_lsb,Y_dat_info_shift,Y_lin_frac_msb,Y_lin_frac_lsb};
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
  nv_assert_never #(0,0,"CDP INT Y table lsb info: uflow and oflow occured at same time")      zzz_assert_never_9x (nvdla_op_gated_clk_int, `ASSERT_RESET, int_Y_stage1_pvld & Y_dat_info_shift[0] & Y_oflow_int_lsb); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"CDP INT Y table msb info: uflow and oflow occured at same time")      zzz_assert_never_10x (nvdla_op_gated_clk_int, `ASSERT_RESET, int_Y_stage1_pvld & Y_dat_info_shift[1] & Y_oflow_int_msb); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_Y_stage1_pvld <= 1'b0;
  end else begin
    if(int_Y_stage0_pvld)
        int_Y_stage1_pvld <= 1'b1;
    else if(int_Y_stage1_prdy)
        int_Y_stage1_pvld <= 1'b0;
  end
end
assign int_Y_stage1_prdy = Y_stage1_in_rdy;

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//pipe delay to sync with X table
assign Y_stage1_in_pd = {Y_dat_info_f,Y_index_msb_f,Y_index_lsb_f};
assign Y_stage1_in_vld = int_Y_stage1_pvld;

assign Y_stage1_in_vld_d0 = Y_stage1_in_vld;
assign Y_stage1_in_rdy = Y_stage1_in_rdy_d0;
assign Y_stage1_in_pd_d0[55:0] = Y_stage1_in_pd[55:0];
NV_NVDLA_CDP_DP_LUT_CTRL_UNIT_pipe_p1 pipe_p1 (
   .nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)  //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)         //|< i
  ,.Y_stage1_in_pd_d0       (Y_stage1_in_pd_d0[55:0]) //|< w
  ,.Y_stage1_in_rdy_d1      (Y_stage1_in_rdy_d1)      //|< w
  ,.Y_stage1_in_vld_d0      (Y_stage1_in_vld_d0)      //|< w
  ,.Y_stage1_in_pd_d1       (Y_stage1_in_pd_d1[55:0]) //|> w
  ,.Y_stage1_in_rdy_d0      (Y_stage1_in_rdy_d0)      //|> w
  ,.Y_stage1_in_vld_d1      (Y_stage1_in_vld_d1)      //|> w
  );
NV_NVDLA_CDP_DP_LUT_CTRL_UNIT_pipe_p2 pipe_p2 (
   .nvdla_op_gated_clk_int  (nvdla_op_gated_clk_int)  //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)         //|< i
  ,.Y_stage1_in_pd_d1       (Y_stage1_in_pd_d1[55:0]) //|< w
  ,.Y_stage1_in_rdy_d2      (Y_stage1_in_rdy_d2)      //|< w
  ,.Y_stage1_in_vld_d1      (Y_stage1_in_vld_d1)      //|< w
  ,.Y_stage1_in_pd_d2       (Y_stage1_in_pd_d2[55:0]) //|> w
  ,.Y_stage1_in_rdy_d1      (Y_stage1_in_rdy_d1)      //|> w
  ,.Y_stage1_in_vld_d2      (Y_stage1_in_vld_d2)      //|> w
  );
assign Y_stage3_out_vld = Y_stage1_in_vld_d2;
assign Y_stage1_in_rdy_d2 = Y_stage3_out_rdy;
assign Y_stage3_out_pd[55:0] = Y_stage1_in_pd_d2[55:0];

assign Y_index_lsb = Y_stage3_out_pd[9:0];
assign Y_index_msb = Y_stage3_out_pd[19:10];
assign Y_dat_info = Y_stage3_out_pd[55:20];
assign Y_int_stage3_pvld = Y_stage3_out_vld;
assign Y_stage3_out_rdy  = Y_int_stage3_prdy;
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
//int X Y tables control output interlock
assign int_stage3_prdy   = int_out_rdy & Y_int_stage3_pvld;
assign Y_int_stage3_prdy = int_out_rdy & int_stage3_pvld;
assign int_out_vld = int_stage3_pvld & Y_int_stage3_pvld;

////////////////////////////////////////////////////////////////////////////////////////
//FP16 mode
////////////////////////////////////////////////////////////////////////////////////////
//fp X Y tables interlock
assign datin_fp16     = {32{fp16_en }} & sum2itp_pd[31:0];
assign fp_X_proc_in_vld = fp_en_vld & fp16_Y_datin_prdy;
assign fp_Y_proc_in_vld = fp_en_vld & fp16_X_datin_prdy;
assign fp_en_rdy = fp16_Y_datin_prdy & fp16_X_datin_prdy;

//slcg
//////
//////////////////////////////////////////////////////////////////////
//FP16 mode index calculation of X table
//////////////////////////////////////////////////////////////////////
//===================================================================

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
  nv_assert_never #(0,0,"CDP_LUT_ctrl: LE start should not be set to NaN")      zzz_assert_never_11x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_X_proc_in_vld & fp16_X_datin_prdy & (&reg2dp_X_offset[30:23] & (|reg2dp_X_offset[22:0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//input offset proc for fp16 data type
assign fp16_X_datin_prdy = datin_fp16_rdy & offset_rdy;
assign datin_fp16_vld    = fp_X_proc_in_vld & offset_rdy;
assign offset_vld        = fp_X_proc_in_vld & datin_fp16_rdy;

assign fp_X_start_a_in[31:0] = datin_fp16;
assign fp_X_start_b_in[31:0] = reg2dp_X_offset[31:0];

HLS_fp32_sub u_CDP_DP_LUTCTRL_XOFFSET (
   .nvdla_core_clk          (nvdla_op_gated_clk_fp16) //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z             (fp_X_start_a_in[31:0])   //|< w
  ,.chn_a_rsc_vz            (datin_fp16_vld)          //|< w
  ,.chn_a_rsc_lz            (datin_fp16_rdy)          //|> w
  ,.chn_b_rsc_z             (fp_X_start_b_in[31:0])   //|< w
  ,.chn_b_rsc_vz            (offset_vld)              //|< w
  ,.chn_b_rsc_lz            (offset_rdy)              //|> w
  ,.chn_o_rsc_z             (fp_dec_offset[31:0])     //|> w
  ,.chn_o_rsc_vz            (fp_stage0_prdy)          //|< w
  ,.chn_o_rsc_lz            (fp_stage0_pvld)          //|> w
  );
assign fp_stage0_prdy = fp_X_stage0_rdy;

//if input NaN, both X and Y flow
assign Xinput_is_NaN = &fp_dec_offset[30:23] & (|fp_dec_offset[22:0]);

////////////////////////////
//uflow condition
////////////////////////////
always @(
  Xinput_is_NaN
  or fp_dec_offset
  ) begin
    if(Xinput_is_NaN)
        fp_X_uflow = 1'b1;
    else if(~(|fp_dec_offset))
        fp_X_uflow = 1'b1;
    else if(fp_dec_offset[31])
        fp_X_uflow = 1'b1;
    else
        fp_X_uflow = 1'b0;
    
end
//&Always;
//    if(input_is_NaN) begin
//        fp_X_uflow_in_pd = 1'b1;
//    end else begin
//        case({reg2dp_X_offset[31],datin_fp16[31]})
//        2'b00 : fp_X_uflow_in_pd = (datin_fp16[30:0] < reg2dp_X_offset[30:0]) | (datin_fp16[30:0] == reg2dp_X_offset[30:0]);
//        2'b11 : fp_X_uflow_in_pd = (datin_fp16[30:0] > reg2dp_X_offset[30:0]) | (datin_fp16[30:0] == reg2dp_X_offset[30:0]);
//        2'b01 : fp_X_uflow_in_pd = 1'b1;
//        2'b10 : fp_X_uflow_in_pd = 1'b0;
//        default : fp_X_uflow_in_pd = 1'b0;
//        endcase
//    end
//&End;

assign fp_X_stage0_vld = fp_stage0_pvld;
assign fp_X_stage0_rdy = ~fp_X_stage1_vld | fp_X_stage1_rdy;
assign fp_X_stage0_load = fp_X_stage0_vld & fp_X_stage0_rdy;
//===================================================================
//===================================================================
assign fp_log2_datin[31:0] = fp_X_uflow ? 32'd0 : fp_dec_offset[31:0];
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
  nv_assert_never #(0,0,"CDP_LUT_ctrl: no overflow is allowed")      zzz_assert_never_12x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_X_stage0_load & (|mon_neg_out_f )); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//log2 logic for fp16, bypassed when X is a linear table
assign {mon_neg_out_f[1:0],neg_out_f[6:0]} = (fp_log2_datin[30:23] < 8'd127) ? (8'd127 - fp_log2_datin[30:23]) : 9'd0;
assign neg_out_ff[7:0] = ~{1'b0,neg_out_f[6:0]};
assign neg_out[7:0] = neg_out_ff + 1'b1;

always @(
  fp_X_uflow
  or X_exp
  or fp_log2_datin
  or neg_out
  ) begin
    if(fp_X_uflow) begin
        fp_X_log2_datout = 8'd0;
        fp_X_exp_frac    = 16'd0;
    end else begin
        if(X_exp) begin
            //if(~(|fp_log2_datin[31:0])) begin
            //    fp_X_log2_datout = 8'd0;
            //    fp_X_exp_frac    = 16'd0;
            //end else begin
                if(fp_log2_datin[30:23] >= 8'd127) begin
                    fp_X_log2_datout = fp_log2_datin[30:23] - 8'd127;
                    fp_X_exp_frac    = fp_log2_datin[22:7];
                end else begin
                    fp_X_log2_datout = {{24{neg_out[7]}},neg_out};
                    fp_X_exp_frac    = fp_log2_datin[22:7];
                end
            //end
        end else begin
            fp_X_log2_datout = fp_log2_datin;
            fp_X_exp_frac    = 16'd0;
        end
    end
end
assign fp_X_info[16:0] = {fp_X_uflow,fp_X_exp_frac};// underflow, exp_frac

//===================================================================
//index offset proc for fp16
//===================================================================
assign same_sign = (reg2dp_X_index_offset[7] == fp_X_log2_datout[7]);
assign less_than_start = (fp_X_log2_datout[6:0] < reg2dp_X_index_offset[6:0]);
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_fp_Xindex[0],fp_Xindex[8:0]} <= {10{1'b0}};
    fp_X_index_uflow <= 1'b0;
  end else begin
    if(fp_X_stage0_load) begin
        if(fp_X_info[16]) begin
            {mon_fp_Xindex[0], fp_Xindex[8:0]} <= 10'd0;
            fp_X_index_uflow <= 1'b0;
        end else begin
            if(X_exp) begin
                if(same_sign & less_than_start) begin
                    {mon_fp_Xindex[0], fp_Xindex[8:0]} <= 10'd0;
                    fp_X_index_uflow <= 1'b1;
                end else if((~reg2dp_X_index_offset[7]) & fp_X_log2_datout[7]) begin
                    {mon_fp_Xindex[0], fp_Xindex[8:0]} <= 10'd0;
                    fp_X_index_uflow <= 1'b1;
                end else begin
                    {mon_fp_Xindex[0], fp_Xindex[8:0]} <= ($signed({fp_X_log2_datout[7],fp_X_log2_datout[7:0]}) - $signed({reg2dp_X_index_offset[7],reg2dp_X_index_offset[7:0]}));
                    fp_X_index_uflow <= 1'b0;
                end
            end
        end
    end
  end
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp_X_log2_datout_d <= {32{1'b0}};
  end else begin
  if ((fp_X_stage0_load) == 1'b1) begin
    fp_X_log2_datout_d <= fp_X_log2_datout;
  // VCS coverage off
  end else if ((fp_X_stage0_load) == 1'b0) begin
  end else begin
    fp_X_log2_datout_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, 1'd1,  (^(fp_X_stage0_load))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp_X_info_d <= {17{1'b0}};
  end else begin
  if ((fp_X_stage0_load) == 1'b1) begin
    fp_X_info_d <= fp_X_info;
  // VCS coverage off
  end else if ((fp_X_stage0_load) == 1'b0) begin
  end else begin
    fp_X_info_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, 1'd1,  (^(fp_X_stage0_load))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign fp_Xindex_data = X_exp ? {23'd0,fp_Xindex} : fp_X_log2_datout_d;
//assign fp_Xindex_info = {(fp_X_info_d[16]|fp_X_index_uflow),fp_X_info_d[15:0]};// underflow, exp_frac
assign fp_Xindex_info = X_exp ? {(fp_X_info_d[16]|fp_X_index_uflow),fp_X_info_d[15:0]} : {fp_X_info_d[16],fp_X_info_d[15:0]};// underflow, exp_frac
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp_X_stage1_vld <= 1'b0;
  end else begin
    if(fp_X_stage0_vld)
        fp_X_stage1_vld <= 1'b1;
    else if(fp_X_stage1_rdy)
        fp_X_stage1_vld <= 1'b0;
  end
end
assign fp_X_stage1_rdy = ~fp_X_stage2_vld | fp_X_stage2_rdy;

assign fp_X_stage1_load = fp_X_stage1_vld & fp_X_stage1_rdy;
//===================================================================
//shift process for fp16 mode, linear only, shift "0" when exponent X
//===================================================================
assign fp_X_shift_inv[6:0]  = ~shift_bits[6:0];
assign fp_X_shift_abs[7:0]  = shift_bits[7]? (fp_X_shift_inv[6:0]+7'd1) : shift_bits[7:0];
assign more1 = (fp_Xindex_data[30:23]>=8'd127);
assign {mon_fp_X_R_shift,fp_X_shift[7:0]} = more1 ? (fp_Xindex_data[30:23] - 8'd127) : (8'd126 - fp_Xindex_data[30:23]);

assign fp32_int_e[127:0] = more1 ? ({127'd0,1'b1} << fp_X_shift) : 128'd0;
//assign {fp32_int_f[126:0],fp32_frac_f[22:0],fp32_frac_f_ext[126:0]} = more1 ? ({127'd0,fp_Xindex_data[22:0],127'd0} << fp_X_shift) : ({127'd0,1'b1,fp_Xindex_data[22:1],127'd0} >> fp_X_shift);
assign {fp32_int_f[126:0],fp32_frac_f[22:0],fp32_frac_f_ext[127:0]} = more1 ? ({127'd0,fp_Xindex_data[22:0],128'd0} << fp_X_shift) : ({127'd0,1'b1,fp_Xindex_data[22:0],127'd0} >> fp_X_shift);
assign fp32_int[128:0] = fp32_int_e[127:0] + {1'b0,fp32_int_f[126:0]};
//assign {fp32_frac[22:0],fp32_frac_ext[126:0]} = {fp32_frac_f,fp32_frac_f_ext};
assign {fp32_frac[22:0],fp32_frac_ext[127:0]} = {fp32_frac_f,fp32_frac_f_ext};
assign fp32_pd[151:0] = {fp32_int,fp32_frac};
//assign {fp_Xshift_lin_s[256:0],fp_Xshift_lin_f[22:0],mon_fp_Xshift_lin_f[126:0]} = shift_bits[7] ? ({128'd0,fp32_pd,fp32_frac_ext[126:0]} << fp_X_shift_abs) : ({128'd0,fp32_pd,fp32_frac_ext[126:0]} >> fp_X_shift_abs);
assign {fp_Xshift_lin_s[256:0],fp_Xshift_lin_f[22:0],mon_fp_Xshift_lin_f[127:0]} = shift_bits[7] ? ({128'd0,fp32_pd,fp32_frac_ext[127:0]} << fp_X_shift_abs) : ({128'd0,fp32_pd,fp32_frac_ext[127:0]} >> fp_X_shift_abs);

always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp_Xshift[9:0] <= {10{1'b0}};
    fp_Xshift_oflow <= 1'b0;
    fp_Xshift_frac <= {16{1'b0}};
  end else begin
    if(fp_X_stage1_load) begin
        if(fp_Xindex_info[16]) begin
            fp_Xshift[9:0] <= 10'd0;
            fp_Xshift_oflow <= 1'b0;
        end else begin
            if(X_exp_s) begin
                if(fp_Xindex_data[8:0]>=(65 -1)) begin
                    fp_Xshift[9:0] <= 65  - 1;
                    fp_Xshift_oflow <= 1'b1;
                end else begin
                    fp_Xshift[9:0] <= fp_Xindex_data[9:0];//
                    fp_Xshift_oflow <= 1'b0;
                end
            end else begin
                if(~(|fp_Xindex_data[31:0])) begin
                    fp_Xshift_frac <= 16'd0;
                    fp_Xshift[9:0] <= 10'd0;
                    fp_Xshift_oflow <= 1'b0;
                end else begin
                    fp_Xshift_frac <= fp_Xshift_lin_f[22:7];
                    if(fp_Xshift_lin_s >= (65 -1)) begin
                       fp_Xshift[9:0] <= 65  - 1;
                       fp_Xshift_oflow <= 1'b1;
                    end else begin
                       fp_Xshift[9:0] <= fp_Xshift_lin_s[9:0];
                       fp_Xshift_oflow <= 1'b0;
                    end
                end
            end
        end
    end
  end
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp_Xindex_info_d <= {17{1'b0}};
  end else begin
  if ((fp_X_stage1_load) == 1'b1) begin
    fp_Xindex_info_d <= fp_Xindex_info;
  // VCS coverage off
  end else if ((fp_X_stage1_load) == 1'b0) begin
  end else begin
    fp_Xindex_info_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, 1'd1,  (^(fp_X_stage1_load))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign fp_X_frac = X_exp_s ? fp_Xindex_info_d[15:0] : fp_Xshift_frac;
assign fp_Xshift_info = {fp_Xshift_oflow, fp_Xindex_info_d[16], fp_X_frac};//oflow, uflow, frac

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
  nv_assert_never #(0,0,"CDP-LUT info: uflow and oflow occured at same time")      zzz_assert_never_16x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_X_stage2_vld & fp_Xshift_oflow & fp_Xindex_info_d[16]); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp_X_stage2_vld <= 1'b0;
  end else begin
    if(fp_X_stage1_vld)
        fp_X_stage2_vld <= 1'b1;
    else if(fp_X_stage2_rdy)
        fp_X_stage2_vld <= 1'b0;
  end
end
//assign fp_X_stage2_rdy = ;

//////////////////////////////////////////////////////////////////////
//FP16 mode index calculation of Y table, linear only
//////////////////////////////////////////////////////////////////////
//===================================================================
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
  nv_assert_never #(0,0,"CDP_LUT_ctrl: LO start should not be set to NaN")      zzz_assert_never_17x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_Y_proc_in_vld & fp16_Y_datin_prdy & (&reg2dp_Y_offset[30:23] & (|reg2dp_Y_offset[22:0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//input offset proc for fp16 data type
assign fp16_Y_datin_prdy = Y_datin_fp16_rdy & Y_offset_rdy;
assign Y_datin_fp16_vld  = fp_Y_proc_in_vld & Y_offset_rdy;
assign Y_offset_vld      = fp_Y_proc_in_vld & Y_datin_fp16_rdy;

assign fp_Y_start_a_in[31:0] = datin_fp16;
assign fp_Y_start_b_in[31:0] = reg2dp_Y_offset[31:0];

HLS_fp32_sub u_CDP_DP_LUTCTRL_YOFFSET (
   .nvdla_core_clk          (nvdla_op_gated_clk_fp16) //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z             (fp_Y_start_a_in[31:0])   //|< w
  ,.chn_a_rsc_vz            (Y_datin_fp16_vld)        //|< w
  ,.chn_a_rsc_lz            (Y_datin_fp16_rdy)        //|> w
  ,.chn_b_rsc_z             (fp_Y_start_b_in[31:0])   //|< w
  ,.chn_b_rsc_vz            (Y_offset_vld)            //|< w
  ,.chn_b_rsc_lz            (Y_offset_rdy)            //|> w
  ,.chn_o_rsc_z             (Y_fp_dec_offset[31:0])   //|> w
  ,.chn_o_rsc_vz            (Y_fp_stage0_prdy)        //|< w
  ,.chn_o_rsc_lz            (Y_fp_stage0_pvld)        //|> w
  );
//&Connect chn_a_rsc_z    datin_fp16;
//&Connect chn_b_rsc_z    reg2dp_Y_offset[31:0];
assign Y_fp_stage0_prdy = fp_Y_stage0_rdy;

//if input NaN, both X and Y flow
assign Yinput_is_NaN = &Y_fp_dec_offset[30:23] & (|Y_fp_dec_offset[22:0]);

////////////////////////////
//uflow condition
////////////////////////////
always @(
  Yinput_is_NaN
  or Y_fp_dec_offset
  ) begin
    if(Yinput_is_NaN)
        fp_Y_uflow = 1'b1;
    else if(~(|Y_fp_dec_offset))
        fp_Y_uflow = 1'b1;
    else if(Y_fp_dec_offset[31])
        fp_Y_uflow = 1'b1;
    else
        fp_Y_uflow = 1'b0;
    
end

//&Always;
//    if(input_is_NaN) begin
//        fp_Y_uflow_in_pd = 1'b1;
//    end else begin
//        case({reg2dp_Y_offset[31],datin_fp16[31]})
//        //2'b00 : fp_Y_uflow_in_pd = datin_fp16[30:0] < reg2dp_Y_offset[30:0];
//        //2'b11 : fp_Y_uflow_in_pd = datin_fp16[30:0] > reg2dp_Y_offset[30:0];
//        2'b00 : fp_Y_uflow_in_pd = (datin_fp16[30:0] < reg2dp_Y_offset[30:0]) | (datin_fp16[30:0] == reg2dp_Y_offset[30:0]);
//        //2'b00 : fp_Y_uflow_in_pd = (datin_fp16[30:0] < reg2dp_Y_offset[30:0]);
//        2'b11 : fp_Y_uflow_in_pd = (datin_fp16[30:0] > reg2dp_Y_offset[30:0]) | (datin_fp16[30:0] == reg2dp_Y_offset[30:0]);
//        2'b01 : fp_Y_uflow_in_pd = 1'b1;
//        2'b10 : fp_Y_uflow_in_pd = 1'b0;
//        default : fp_Y_uflow_in_pd = 1'b0;
//        endcase
//    end
//&End;
//assign fp_Y_uflow_in_pd  = datin_fp16 < reg2dp_Y_offset[31:0];

assign fp_Y_stage0_vld = Y_fp_stage0_pvld;
assign fp_Y_stage0_rdy = ~fp_Y_stage1_vld | fp_Y_stage1_rdy;
assign fp_Y_stage0_load = fp_Y_stage0_vld & fp_Y_stage0_rdy;

//===================================================================
//shift process for Y table fp16 mode, linear only
assign fp_Yindex_data = Y_fp_dec_offset;
assign fp_Y_shift_inv[6:0]  = ~Y_shift_bits[6:0];
assign fp_Y_shift_abs[7:0]  = Y_shift_bits[7]? (fp_Y_shift_inv[6:0]+7'd1) : Y_shift_bits[7:0];
assign fp_Y_more1 = (fp_Yindex_data[30:23]>=8'd127);
assign {mon_fp_Y_shift,fp_Y_shift[7:0]} = fp_Y_more1 ? (fp_Yindex_data[30:23] - 8'd127) : (8'd126 - fp_Yindex_data[30:23]);

assign Y_fp32_int_e[127:0] = fp_Y_more1 ? ({127'd0,1'b1} << fp_Y_shift) : 128'd0;
assign {Y_fp32_int_f[126:0],Y_fp32_frac_f[22:0],Y_fp32_frac_f_ext[127:0]} = fp_Y_more1 ? ({127'd0,fp_Yindex_data[22:0],128'd0} << fp_Y_shift) : ({127'd0,1'b1,fp_Yindex_data[22:0],127'd0} >> fp_Y_shift);
assign Y_fp32_int[128:0] = Y_fp32_int_e[127:0] + {1'b0,Y_fp32_int_f[126:0]};
assign {Y_fp32_frac[22:0],Y_fp32_frac_ext[127:0]} = {Y_fp32_frac_f,Y_fp32_frac_f_ext};
assign Y_fp32_pd[151:0] = {Y_fp32_int,Y_fp32_frac};
assign {fp_Yshift_lin_s[256:0],fp_Yshift_lin_f[22:0],mon_fp_Yshift_lin_f[127:0]} = Y_shift_bits[7] ? ({128'd0,Y_fp32_pd,Y_fp32_frac_ext[127:0]} << fp_Y_shift_abs) : ({128'd0,Y_fp32_pd,Y_fp32_frac_ext[127:0]} >> fp_Y_shift_abs);

always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp_Yshift[9:0] <= {10{1'b0}};
    fp_Yshift_oflow <= 1'b0;
    fp_Yshift_frac[15:0] <= {16{1'b0}};
  end else begin
    if(fp_Y_stage0_load) begin
        if(fp_Y_uflow) begin
            fp_Yshift[9:0] <= 10'd0;
            fp_Yshift_oflow <= 1'b0;
        end else if(~(|fp_Yindex_data[31:0])) begin
            fp_Yshift[9:0] <= 10'd0;
            fp_Yshift_oflow <= 1'b0;
            fp_Yshift_frac[15:0] <= 16'd0;
        end else begin
            if(fp_Yshift_lin_s >= (257 -1)) begin
                fp_Yshift[9:0] <= 257  - 1;
                fp_Yshift_oflow <= 1'b1;
            end else begin
                fp_Yshift[9:0] <= fp_Yshift_lin_s[9:0];
                fp_Yshift_oflow <= 1'b0;
            end
            fp_Yshift_frac[15:0] <= fp_Yshift_lin_f[22:7];
        end
    end
  end
end
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp_Yindex_info_d <= 1'b0;
  end else begin
  if ((fp_Y_stage0_load) == 1'b1) begin
    fp_Yindex_info_d <= fp_Y_uflow;
  // VCS coverage off
  end else if ((fp_Y_stage0_load) == 1'b0) begin
  end else begin
    fp_Yindex_info_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, 1'd1,  (^(fp_Y_stage0_load))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign fp_Yshift_info = {fp_Yshift_oflow,fp_Yindex_info_d,fp_Yshift_frac};//oflow, uflow, lin_frac
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
  nv_assert_never #(0,0,"CDP-FP16 Y table info: uflow and oflow occured at same time")      zzz_assert_never_19x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, fp_Y_stage1_vld & fp_Yindex_info_d & fp_Yshift_oflow); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp_Y_stage1_vld <= 1'b0;
  end else begin
    if(fp_Y_stage0_vld)
        fp_Y_stage1_vld <= 1'b1;
    else if(fp_Y_stage1_rdy)
        fp_Y_stage1_vld <= 1'b0;
  end
end

/////////////////////////////////////////////////////////////////////////
//pipe delay to sync with FP X table
assign fp_Y_stage1_pd = {fp_Yshift_info,fp_Yshift};

assign fp_Y_stage1_vld_d0 = fp_Y_stage1_vld;
assign fp_Y_stage1_rdy = fp_Y_stage1_rdy_d0;
assign fp_Y_stage1_pd_d0[27:0] = fp_Y_stage1_pd[27:0];
NV_NVDLA_CDP_DP_LUT_CTRL_UNIT_pipe_p3 pipe_p3 (
   .nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16) //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)         //|< i
  ,.fp_Y_stage1_pd_d0       (fp_Y_stage1_pd_d0[27:0]) //|< w
  ,.fp_Y_stage1_rdy_d1      (fp_Y_stage1_rdy_d1)      //|< w
  ,.fp_Y_stage1_vld_d0      (fp_Y_stage1_vld_d0)      //|< w
  ,.fp_Y_stage1_pd_d1       (fp_Y_stage1_pd_d1[27:0]) //|> w
  ,.fp_Y_stage1_rdy_d0      (fp_Y_stage1_rdy_d0)      //|> w
  ,.fp_Y_stage1_vld_d1      (fp_Y_stage1_vld_d1)      //|> w
  );
assign fp_Y_stage2_vld = fp_Y_stage1_vld_d1;
assign fp_Y_stage1_rdy_d1 = fp_Y_stage2_rdy;
assign fp_Y_stage2_pd[27:0] = fp_Y_stage1_pd_d1[27:0];

assign fp_Y_index = fp_Y_stage2_pd[9:0];
assign fp_Y_index_info = fp_Y_stage2_pd[27:10];//uflow, oflow, lin_frac

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
//fp X Y tables control output interlock
assign fp_X_stage2_rdy = fp_out_rdy & fp_Y_stage2_vld;
assign fp_Y_stage2_rdy = fp_out_rdy & fp_X_stage2_vld;
assign fp_out_vld = fp_X_stage2_vld & fp_Y_stage2_vld;

////////////////////////////////////////////////////////////////////////////////////////
assign dp2lut_pvld = fp16_en ? fp_out_vld : int_out_vld;
assign fp_out_rdy  = fp16_en ? dp2lut_prdy : 1'b1;
assign int_out_rdy = fp16_en ? 1'b1 : dp2lut_prdy;

//info= oflow_msb,oflow_lsb,uflow_msb,uflow_lsb,frac_msb,frac_lsb
assign dp2lut_X_pd   = fp16_en ? {10'd0,fp_Xshift} : {X_index_msb,X_index_lsb};
assign dp2lut_X_info = fp16_en ? {1'd0,fp_Xshift_info[17],1'd0,fp_Xshift_info[16],16'd0,fp_Xshift_info[15:0]} : X_dat_info;

assign dp2lut_Y_pd   = fp16_en ? {10'd0,fp_Y_index} : {Y_index_msb,Y_index_lsb};
assign dp2lut_Y_info = fp16_en ? {1'd0,fp_Y_index_info[17],1'd0,fp_Y_index_info[16],16'd0,fp_Y_index_info[15:0]} : Y_dat_info;

////////////
endmodule // NV_NVDLA_CDP_DP_LUT_CTRL_unit



// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none Y_stage1_in_pd_d1[55:0] (Y_stage1_in_vld_d1,Y_stage1_in_rdy_d1) <= Y_stage1_in_pd_d0[55:0] (Y_stage1_in_vld_d0,Y_stage1_in_rdy_d0)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_LUT_CTRL_UNIT_pipe_p1 (
   nvdla_op_gated_clk_int
  ,nvdla_core_rstn
  ,Y_stage1_in_pd_d0
  ,Y_stage1_in_rdy_d1
  ,Y_stage1_in_vld_d0
  ,Y_stage1_in_pd_d1
  ,Y_stage1_in_rdy_d0
  ,Y_stage1_in_vld_d1
  );
input         nvdla_op_gated_clk_int;
input         nvdla_core_rstn;
input  [55:0] Y_stage1_in_pd_d0;
input         Y_stage1_in_rdy_d1;
input         Y_stage1_in_vld_d0;
output [55:0] Y_stage1_in_pd_d1;
output        Y_stage1_in_rdy_d0;
output        Y_stage1_in_vld_d1;
reg    [55:0] Y_stage1_in_pd_d1;
reg           Y_stage1_in_rdy_d0;
reg           Y_stage1_in_vld_d1;
reg    [55:0] p1_pipe_data;
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
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? Y_stage1_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_int) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && Y_stage1_in_vld_d0)? Y_stage1_in_pd_d0[55:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  Y_stage1_in_rdy_d0 = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or Y_stage1_in_rdy_d1
  or p1_pipe_data
  ) begin
  Y_stage1_in_vld_d1 = p1_pipe_valid;
  p1_pipe_ready = Y_stage1_in_rdy_d1;
  Y_stage1_in_pd_d1[55:0] = p1_pipe_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_op_gated_clk_int;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_op_gated_clk_int, `ASSERT_RESET, nvdla_core_rstn, (Y_stage1_in_vld_d1^Y_stage1_in_rdy_d1^Y_stage1_in_vld_d0^Y_stage1_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_21x (nvdla_op_gated_clk_int, `ASSERT_RESET, (Y_stage1_in_vld_d0 && !Y_stage1_in_rdy_d0), (Y_stage1_in_vld_d0), (Y_stage1_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDP_DP_LUT_CTRL_UNIT_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none Y_stage1_in_pd_d2[55:0] (Y_stage1_in_vld_d2,Y_stage1_in_rdy_d2) <= Y_stage1_in_pd_d1[55:0] (Y_stage1_in_vld_d1,Y_stage1_in_rdy_d1)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_LUT_CTRL_UNIT_pipe_p2 (
   nvdla_op_gated_clk_int
  ,nvdla_core_rstn
  ,Y_stage1_in_pd_d1
  ,Y_stage1_in_rdy_d2
  ,Y_stage1_in_vld_d1
  ,Y_stage1_in_pd_d2
  ,Y_stage1_in_rdy_d1
  ,Y_stage1_in_vld_d2
  );
input         nvdla_op_gated_clk_int;
input         nvdla_core_rstn;
input  [55:0] Y_stage1_in_pd_d1;
input         Y_stage1_in_rdy_d2;
input         Y_stage1_in_vld_d1;
output [55:0] Y_stage1_in_pd_d2;
output        Y_stage1_in_rdy_d1;
output        Y_stage1_in_vld_d2;
reg    [55:0] Y_stage1_in_pd_d2;
reg           Y_stage1_in_rdy_d1;
reg           Y_stage1_in_vld_d2;
reg    [55:0] p2_pipe_data;
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
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? Y_stage1_in_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_int) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && Y_stage1_in_vld_d1)? Y_stage1_in_pd_d1[55:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  Y_stage1_in_rdy_d1 = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or Y_stage1_in_rdy_d2
  or p2_pipe_data
  ) begin
  Y_stage1_in_vld_d2 = p2_pipe_valid;
  p2_pipe_ready = Y_stage1_in_rdy_d2;
  Y_stage1_in_pd_d2[55:0] = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_op_gated_clk_int;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_op_gated_clk_int, `ASSERT_RESET, nvdla_core_rstn, (Y_stage1_in_vld_d2^Y_stage1_in_rdy_d2^Y_stage1_in_vld_d1^Y_stage1_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_23x (nvdla_op_gated_clk_int, `ASSERT_RESET, (Y_stage1_in_vld_d1 && !Y_stage1_in_rdy_d1), (Y_stage1_in_vld_d1), (Y_stage1_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDP_DP_LUT_CTRL_UNIT_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none fp_Y_stage1_pd_d1[27:0] (fp_Y_stage1_vld_d1,fp_Y_stage1_rdy_d1) <= fp_Y_stage1_pd_d0[27:0] (fp_Y_stage1_vld_d0,fp_Y_stage1_rdy_d0)
// **************************************************************************************************************
module NV_NVDLA_CDP_DP_LUT_CTRL_UNIT_pipe_p3 (
   nvdla_op_gated_clk_fp16
  ,nvdla_core_rstn
  ,fp_Y_stage1_pd_d0
  ,fp_Y_stage1_rdy_d1
  ,fp_Y_stage1_vld_d0
  ,fp_Y_stage1_pd_d1
  ,fp_Y_stage1_rdy_d0
  ,fp_Y_stage1_vld_d1
  );
input         nvdla_op_gated_clk_fp16;
input         nvdla_core_rstn;
input  [27:0] fp_Y_stage1_pd_d0;
input         fp_Y_stage1_rdy_d1;
input         fp_Y_stage1_vld_d0;
output [27:0] fp_Y_stage1_pd_d1;
output        fp_Y_stage1_rdy_d0;
output        fp_Y_stage1_vld_d1;
reg    [27:0] fp_Y_stage1_pd_d1;
reg           fp_Y_stage1_rdy_d0;
reg           fp_Y_stage1_vld_d1;
reg    [27:0] p3_pipe_data;
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
always @(posedge nvdla_op_gated_clk_fp16 or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? fp_Y_stage1_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_op_gated_clk_fp16) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && fp_Y_stage1_vld_d0)? fp_Y_stage1_pd_d0[27:0] : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  fp_Y_stage1_rdy_d0 = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or fp_Y_stage1_rdy_d1
  or p3_pipe_data
  ) begin
  fp_Y_stage1_vld_d1 = p3_pipe_valid;
  p3_pipe_ready = fp_Y_stage1_rdy_d1;
  fp_Y_stage1_pd_d1[27:0] = p3_pipe_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_op_gated_clk_fp16;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, nvdla_core_rstn, (fp_Y_stage1_vld_d1^fp_Y_stage1_rdy_d1^fp_Y_stage1_vld_d0^fp_Y_stage1_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_25x (nvdla_op_gated_clk_fp16, `ASSERT_RESET, (fp_Y_stage1_vld_d0 && !fp_Y_stage1_rdy_d0), (fp_Y_stage1_vld_d0), (fp_Y_stage1_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDP_DP_LUT_CTRL_UNIT_pipe_p3


