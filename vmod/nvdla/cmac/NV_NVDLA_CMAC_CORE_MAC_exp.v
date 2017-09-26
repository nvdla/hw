// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_CORE_MAC_exp.v

module NV_NVDLA_CMAC_CORE_MAC_exp (
   nvdla_core_clk     //|< i
  ,nvdla_core_rstn    //|< i
  ,cfg_is_fp16        //|< i
  ,cfg_reg_en         //|< i
  ,dat_pre_exp        //|< i
  ,dat_pre_mask       //|< i
  ,dat_pre_pvld       //|< i
  ,dat_pre_stripe_end //|< i
  ,dat_pre_stripe_st  //|< i
  ,wt_sd_exp          //|< i
  ,wt_sd_mask         //|< i
  ,wt_sd_pvld         //|< i
  ,exp_max            //|> o
  ,exp_pvld           //|> o
  ,exp_sft_00         //|> o
  ,exp_sft_01         //|> o
  ,exp_sft_02         //|> o
  ,exp_sft_03         //|> o
  ,exp_sft_04         //|> o
  ,exp_sft_05         //|> o
  ,exp_sft_06         //|> o
  ,exp_sft_07         //|> o
  ,exp_sft_08         //|> o
  ,exp_sft_09         //|> o
  ,exp_sft_10         //|> o
  ,exp_sft_11         //|> o
  ,exp_sft_12         //|> o
  ,exp_sft_13         //|> o
  ,exp_sft_14         //|> o
  ,exp_sft_15         //|> o
  ,exp_sft_16         //|> o
  ,exp_sft_17         //|> o
  ,exp_sft_18         //|> o
  ,exp_sft_19         //|> o
  ,exp_sft_20         //|> o
  ,exp_sft_21         //|> o
  ,exp_sft_22         //|> o
  ,exp_sft_23         //|> o
  ,exp_sft_24         //|> o
  ,exp_sft_25         //|> o
  ,exp_sft_26         //|> o
  ,exp_sft_27         //|> o
  ,exp_sft_28         //|> o
  ,exp_sft_29         //|> o
  ,exp_sft_30         //|> o
  ,exp_sft_31         //|> o
  ,exp_sft_32         //|> o
  ,exp_sft_33         //|> o
  ,exp_sft_34         //|> o
  ,exp_sft_35         //|> o
  ,exp_sft_36         //|> o
  ,exp_sft_37         //|> o
  ,exp_sft_38         //|> o
  ,exp_sft_39         //|> o
  ,exp_sft_40         //|> o
  ,exp_sft_41         //|> o
  ,exp_sft_42         //|> o
  ,exp_sft_43         //|> o
  ,exp_sft_44         //|> o
  ,exp_sft_45         //|> o
  ,exp_sft_46         //|> o
  ,exp_sft_47         //|> o
  ,exp_sft_48         //|> o
  ,exp_sft_49         //|> o
  ,exp_sft_50         //|> o
  ,exp_sft_51         //|> o
  ,exp_sft_52         //|> o
  ,exp_sft_53         //|> o
  ,exp_sft_54         //|> o
  ,exp_sft_55         //|> o
  ,exp_sft_56         //|> o
  ,exp_sft_57         //|> o
  ,exp_sft_58         //|> o
  ,exp_sft_59         //|> o
  ,exp_sft_60         //|> o
  ,exp_sft_61         //|> o
  ,exp_sft_62         //|> o
  ,exp_sft_63         //|> o
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input          cfg_is_fp16;
input          cfg_reg_en;
input  [191:0] dat_pre_exp;
input   [63:0] dat_pre_mask;
input          dat_pre_pvld;
input          dat_pre_stripe_end;
input          dat_pre_stripe_st;
input  [191:0] wt_sd_exp;
input   [63:0] wt_sd_mask;
input          wt_sd_pvld;
output   [3:0] exp_max;
output         exp_pvld;
output   [3:0] exp_sft_00;
output   [3:0] exp_sft_01;
output   [3:0] exp_sft_02;
output   [3:0] exp_sft_03;
output   [3:0] exp_sft_04;
output   [3:0] exp_sft_05;
output   [3:0] exp_sft_06;
output   [3:0] exp_sft_07;
output   [3:0] exp_sft_08;
output   [3:0] exp_sft_09;
output   [3:0] exp_sft_10;
output   [3:0] exp_sft_11;
output   [3:0] exp_sft_12;
output   [3:0] exp_sft_13;
output   [3:0] exp_sft_14;
output   [3:0] exp_sft_15;
output   [3:0] exp_sft_16;
output   [3:0] exp_sft_17;
output   [3:0] exp_sft_18;
output   [3:0] exp_sft_19;
output   [3:0] exp_sft_20;
output   [3:0] exp_sft_21;
output   [3:0] exp_sft_22;
output   [3:0] exp_sft_23;
output   [3:0] exp_sft_24;
output   [3:0] exp_sft_25;
output   [3:0] exp_sft_26;
output   [3:0] exp_sft_27;
output   [3:0] exp_sft_28;
output   [3:0] exp_sft_29;
output   [3:0] exp_sft_30;
output   [3:0] exp_sft_31;
output   [3:0] exp_sft_32;
output   [3:0] exp_sft_33;
output   [3:0] exp_sft_34;
output   [3:0] exp_sft_35;
output   [3:0] exp_sft_36;
output   [3:0] exp_sft_37;
output   [3:0] exp_sft_38;
output   [3:0] exp_sft_39;
output   [3:0] exp_sft_40;
output   [3:0] exp_sft_41;
output   [3:0] exp_sft_42;
output   [3:0] exp_sft_43;
output   [3:0] exp_sft_44;
output   [3:0] exp_sft_45;
output   [3:0] exp_sft_46;
output   [3:0] exp_sft_47;
output   [3:0] exp_sft_48;
output   [3:0] exp_sft_49;
output   [3:0] exp_sft_50;
output   [3:0] exp_sft_51;
output   [3:0] exp_sft_52;
output   [3:0] exp_sft_53;
output   [3:0] exp_sft_54;
output   [3:0] exp_sft_55;
output   [3:0] exp_sft_56;
output   [3:0] exp_sft_57;
output   [3:0] exp_sft_58;
output   [3:0] exp_sft_59;
output   [3:0] exp_sft_60;
output   [3:0] exp_sft_61;
output   [3:0] exp_sft_62;
output   [3:0] exp_sft_63;
wire     [3:0] exp_max_l0_00;
wire     [3:0] exp_max_l0_01;
wire     [3:0] exp_max_l0_02;
wire     [3:0] exp_max_l0_03;
wire     [3:0] exp_max_l0_04;
wire     [3:0] exp_max_l0_05;
wire     [3:0] exp_max_l0_06;
wire     [3:0] exp_max_l0_07;
wire     [3:0] exp_max_l0_08;
wire     [3:0] exp_max_l0_09;
wire     [3:0] exp_max_l0_10;
wire     [3:0] exp_max_l0_11;
wire     [3:0] exp_max_l0_12;
wire     [3:0] exp_max_l0_13;
wire     [3:0] exp_max_l0_14;
wire     [3:0] exp_max_l0_15;
wire     [3:0] exp_max_l1_0;
reg      [1:0] cfg_is_fp16_d1;
reg    [191:0] dat_cur_exp;
reg     [63:0] dat_cur_mask;
reg     [63:0] exp_cur_mask;
reg     [15:0] exp_in_l0n00;
reg     [15:0] exp_in_l0n01;
reg     [15:0] exp_in_l0n02;
reg     [15:0] exp_in_l0n03;
reg     [15:0] exp_in_l0n04;
reg     [15:0] exp_in_l0n05;
reg     [15:0] exp_in_l0n06;
reg     [15:0] exp_in_l0n07;
reg     [15:0] exp_in_l0n08;
reg     [15:0] exp_in_l0n09;
reg     [15:0] exp_in_l0n10;
reg     [15:0] exp_in_l0n11;
reg     [15:0] exp_in_l0n12;
reg     [15:0] exp_in_l0n13;
reg     [15:0] exp_in_l0n14;
reg     [15:0] exp_in_l0n15;
reg     [63:0] exp_in_l1n0;
reg      [3:0] exp_max_l1_0_d1;
reg            exp_p1_pvld;
reg            exp_p1_pvld_w;
reg      [3:0] exp_p1_sft_00_w;
reg      [3:0] exp_p1_sft_01_w;
reg      [3:0] exp_p1_sft_02_w;
reg      [3:0] exp_p1_sft_03_w;
reg      [3:0] exp_p1_sft_04_w;
reg      [3:0] exp_p1_sft_05_w;
reg      [3:0] exp_p1_sft_06_w;
reg      [3:0] exp_p1_sft_07_w;
reg      [3:0] exp_p1_sft_08_w;
reg      [3:0] exp_p1_sft_09_w;
reg      [3:0] exp_p1_sft_10_w;
reg      [3:0] exp_p1_sft_11_w;
reg      [3:0] exp_p1_sft_12_w;
reg      [3:0] exp_p1_sft_13_w;
reg      [3:0] exp_p1_sft_14_w;
reg      [3:0] exp_p1_sft_15_w;
reg      [3:0] exp_p1_sft_16_w;
reg      [3:0] exp_p1_sft_17_w;
reg      [3:0] exp_p1_sft_18_w;
reg      [3:0] exp_p1_sft_19_w;
reg      [3:0] exp_p1_sft_20_w;
reg      [3:0] exp_p1_sft_21_w;
reg      [3:0] exp_p1_sft_22_w;
reg      [3:0] exp_p1_sft_23_w;
reg      [3:0] exp_p1_sft_24_w;
reg      [3:0] exp_p1_sft_25_w;
reg      [3:0] exp_p1_sft_26_w;
reg      [3:0] exp_p1_sft_27_w;
reg      [3:0] exp_p1_sft_28_w;
reg      [3:0] exp_p1_sft_29_w;
reg      [3:0] exp_p1_sft_30_w;
reg      [3:0] exp_p1_sft_31_w;
reg      [3:0] exp_p1_sft_32_w;
reg      [3:0] exp_p1_sft_33_w;
reg      [3:0] exp_p1_sft_34_w;
reg      [3:0] exp_p1_sft_35_w;
reg      [3:0] exp_p1_sft_36_w;
reg      [3:0] exp_p1_sft_37_w;
reg      [3:0] exp_p1_sft_38_w;
reg      [3:0] exp_p1_sft_39_w;
reg      [3:0] exp_p1_sft_40_w;
reg      [3:0] exp_p1_sft_41_w;
reg      [3:0] exp_p1_sft_42_w;
reg      [3:0] exp_p1_sft_43_w;
reg      [3:0] exp_p1_sft_44_w;
reg      [3:0] exp_p1_sft_45_w;
reg      [3:0] exp_p1_sft_46_w;
reg      [3:0] exp_p1_sft_47_w;
reg      [3:0] exp_p1_sft_48_w;
reg      [3:0] exp_p1_sft_49_w;
reg      [3:0] exp_p1_sft_50_w;
reg      [3:0] exp_p1_sft_51_w;
reg      [3:0] exp_p1_sft_52_w;
reg      [3:0] exp_p1_sft_53_w;
reg      [3:0] exp_p1_sft_54_w;
reg      [3:0] exp_p1_sft_55_w;
reg      [3:0] exp_p1_sft_56_w;
reg      [3:0] exp_p1_sft_57_w;
reg      [3:0] exp_p1_sft_58_w;
reg      [3:0] exp_p1_sft_59_w;
reg      [3:0] exp_p1_sft_60_w;
reg      [3:0] exp_p1_sft_61_w;
reg      [3:0] exp_p1_sft_62_w;
reg      [3:0] exp_p1_sft_63_w;
reg      [3:0] exp_sft_00;
reg      [3:0] exp_sft_01;
reg      [3:0] exp_sft_02;
reg      [3:0] exp_sft_03;
reg      [3:0] exp_sft_04;
reg      [3:0] exp_sft_05;
reg      [3:0] exp_sft_06;
reg      [3:0] exp_sft_07;
reg      [3:0] exp_sft_08;
reg      [3:0] exp_sft_09;
reg      [3:0] exp_sft_10;
reg      [3:0] exp_sft_11;
reg      [3:0] exp_sft_12;
reg      [3:0] exp_sft_13;
reg      [3:0] exp_sft_14;
reg      [3:0] exp_sft_15;
reg      [3:0] exp_sft_16;
reg      [3:0] exp_sft_17;
reg      [3:0] exp_sft_18;
reg      [3:0] exp_sft_19;
reg      [3:0] exp_sft_20;
reg      [3:0] exp_sft_21;
reg      [3:0] exp_sft_22;
reg      [3:0] exp_sft_23;
reg      [3:0] exp_sft_24;
reg      [3:0] exp_sft_25;
reg      [3:0] exp_sft_26;
reg      [3:0] exp_sft_27;
reg      [3:0] exp_sft_28;
reg      [3:0] exp_sft_29;
reg      [3:0] exp_sft_30;
reg      [3:0] exp_sft_31;
reg      [3:0] exp_sft_32;
reg      [3:0] exp_sft_33;
reg      [3:0] exp_sft_34;
reg      [3:0] exp_sft_35;
reg      [3:0] exp_sft_36;
reg      [3:0] exp_sft_37;
reg      [3:0] exp_sft_38;
reg      [3:0] exp_sft_39;
reg      [3:0] exp_sft_40;
reg      [3:0] exp_sft_41;
reg      [3:0] exp_sft_42;
reg      [3:0] exp_sft_43;
reg      [3:0] exp_sft_44;
reg      [3:0] exp_sft_45;
reg      [3:0] exp_sft_46;
reg      [3:0] exp_sft_47;
reg      [3:0] exp_sft_48;
reg      [3:0] exp_sft_49;
reg      [3:0] exp_sft_50;
reg      [3:0] exp_sft_51;
reg      [3:0] exp_sft_52;
reg      [3:0] exp_sft_53;
reg      [3:0] exp_sft_54;
reg      [3:0] exp_sft_55;
reg      [3:0] exp_sft_56;
reg      [3:0] exp_sft_57;
reg      [3:0] exp_sft_58;
reg      [3:0] exp_sft_59;
reg      [3:0] exp_sft_60;
reg      [3:0] exp_sft_61;
reg      [3:0] exp_sft_62;
reg      [3:0] exp_sft_63;
reg      [3:0] exp_sum_00;
reg      [3:0] exp_sum_01;
reg      [3:0] exp_sum_02;
reg      [3:0] exp_sum_03;
reg      [3:0] exp_sum_04;
reg      [3:0] exp_sum_05;
reg      [3:0] exp_sum_06;
reg      [3:0] exp_sum_07;
reg      [3:0] exp_sum_08;
reg      [3:0] exp_sum_09;
reg      [3:0] exp_sum_10;
reg      [3:0] exp_sum_11;
reg      [3:0] exp_sum_12;
reg      [3:0] exp_sum_13;
reg      [3:0] exp_sum_14;
reg      [3:0] exp_sum_15;
reg      [3:0] exp_sum_16;
reg      [3:0] exp_sum_17;
reg      [3:0] exp_sum_18;
reg      [3:0] exp_sum_19;
reg      [3:0] exp_sum_20;
reg      [3:0] exp_sum_21;
reg      [3:0] exp_sum_22;
reg      [3:0] exp_sum_23;
reg      [3:0] exp_sum_24;
reg      [3:0] exp_sum_25;
reg      [3:0] exp_sum_26;
reg      [3:0] exp_sum_27;
reg      [3:0] exp_sum_28;
reg      [3:0] exp_sum_29;
reg      [3:0] exp_sum_30;
reg      [3:0] exp_sum_31;
reg      [3:0] exp_sum_32;
reg      [3:0] exp_sum_33;
reg      [3:0] exp_sum_34;
reg      [3:0] exp_sum_35;
reg      [3:0] exp_sum_36;
reg      [3:0] exp_sum_37;
reg      [3:0] exp_sum_38;
reg      [3:0] exp_sum_39;
reg      [3:0] exp_sum_40;
reg      [3:0] exp_sum_41;
reg      [3:0] exp_sum_42;
reg      [3:0] exp_sum_43;
reg      [3:0] exp_sum_44;
reg      [3:0] exp_sum_45;
reg      [3:0] exp_sum_46;
reg      [3:0] exp_sum_47;
reg      [3:0] exp_sum_48;
reg      [3:0] exp_sum_49;
reg      [3:0] exp_sum_50;
reg      [3:0] exp_sum_51;
reg      [3:0] exp_sum_52;
reg      [3:0] exp_sum_53;
reg      [3:0] exp_sum_54;
reg      [3:0] exp_sum_55;
reg      [3:0] exp_sum_56;
reg      [3:0] exp_sum_57;
reg      [3:0] exp_sum_58;
reg      [3:0] exp_sum_59;
reg      [3:0] exp_sum_60;
reg      [3:0] exp_sum_61;
reg      [3:0] exp_sum_62;
reg      [3:0] exp_sum_63;
reg            mon_exp_p1_sft_00_w;
reg            mon_exp_p1_sft_01_w;
reg            mon_exp_p1_sft_02_w;
reg            mon_exp_p1_sft_03_w;
reg            mon_exp_p1_sft_04_w;
reg            mon_exp_p1_sft_05_w;
reg            mon_exp_p1_sft_06_w;
reg            mon_exp_p1_sft_07_w;
reg            mon_exp_p1_sft_08_w;
reg            mon_exp_p1_sft_09_w;
reg            mon_exp_p1_sft_10_w;
reg            mon_exp_p1_sft_11_w;
reg            mon_exp_p1_sft_12_w;
reg            mon_exp_p1_sft_13_w;
reg            mon_exp_p1_sft_14_w;
reg            mon_exp_p1_sft_15_w;
reg            mon_exp_p1_sft_16_w;
reg            mon_exp_p1_sft_17_w;
reg            mon_exp_p1_sft_18_w;
reg            mon_exp_p1_sft_19_w;
reg            mon_exp_p1_sft_20_w;
reg            mon_exp_p1_sft_21_w;
reg            mon_exp_p1_sft_22_w;
reg            mon_exp_p1_sft_23_w;
reg            mon_exp_p1_sft_24_w;
reg            mon_exp_p1_sft_25_w;
reg            mon_exp_p1_sft_26_w;
reg            mon_exp_p1_sft_27_w;
reg            mon_exp_p1_sft_28_w;
reg            mon_exp_p1_sft_29_w;
reg            mon_exp_p1_sft_30_w;
reg            mon_exp_p1_sft_31_w;
reg            mon_exp_p1_sft_32_w;
reg            mon_exp_p1_sft_33_w;
reg            mon_exp_p1_sft_34_w;
reg            mon_exp_p1_sft_35_w;
reg            mon_exp_p1_sft_36_w;
reg            mon_exp_p1_sft_37_w;
reg            mon_exp_p1_sft_38_w;
reg            mon_exp_p1_sft_39_w;
reg            mon_exp_p1_sft_40_w;
reg            mon_exp_p1_sft_41_w;
reg            mon_exp_p1_sft_42_w;
reg            mon_exp_p1_sft_43_w;
reg            mon_exp_p1_sft_44_w;
reg            mon_exp_p1_sft_45_w;
reg            mon_exp_p1_sft_46_w;
reg            mon_exp_p1_sft_47_w;
reg            mon_exp_p1_sft_48_w;
reg            mon_exp_p1_sft_49_w;
reg            mon_exp_p1_sft_50_w;
reg            mon_exp_p1_sft_51_w;
reg            mon_exp_p1_sft_52_w;
reg            mon_exp_p1_sft_53_w;
reg            mon_exp_p1_sft_54_w;
reg            mon_exp_p1_sft_55_w;
reg            mon_exp_p1_sft_56_w;
reg            mon_exp_p1_sft_57_w;
reg            mon_exp_p1_sft_58_w;
reg            mon_exp_p1_sft_59_w;
reg            mon_exp_p1_sft_60_w;
reg            mon_exp_p1_sft_61_w;
reg            mon_exp_p1_sft_62_w;
reg            mon_exp_p1_sft_63_w;
reg    [191:0] wt_actv_exp;
reg            wt_actv_exp_clr;
reg            wt_actv_exp_clr_w;
reg            wt_actv_exp_pvld;
reg            wt_actv_exp_pvld_w;
reg            wt_actv_exp_set;
reg     [63:0] wt_actv_mask;
reg    [191:0] wt_cur_exp;
reg     [63:0] wt_cur_mask;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

//==========================================================
// Config logic
//==========================================================

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_fp16_d1 <= {2{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_is_fp16_d1 <= {2{cfg_is_fp16}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_is_fp16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==========================================================
// Weight exponent store
//==========================================================

always @(
  wt_sd_pvld
  or dat_pre_stripe_st
  or cfg_is_fp16_d1
  ) begin
    wt_actv_exp_set = (wt_sd_pvld & dat_pre_stripe_st & cfg_is_fp16_d1[0]);
end

always @(
  dat_pre_stripe_end
  ) begin
    wt_actv_exp_clr_w = dat_pre_stripe_end;
end

always @(
  wt_actv_exp_set
  or wt_actv_exp_clr
  or wt_actv_exp_pvld
  ) begin
    wt_actv_exp_pvld_w = (wt_actv_exp_set) ? 1'b1 :
                         (wt_actv_exp_clr) ? 1'b0 :
                         wt_actv_exp_pvld;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_actv_exp_pvld <= 1'b0;
  end else begin
  wt_actv_exp_pvld <= wt_actv_exp_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_actv_exp_clr <= 1'b0;
  end else begin
  wt_actv_exp_clr <= wt_actv_exp_clr_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((wt_actv_exp_set) == 1'b1) begin
    wt_actv_exp <= wt_sd_exp;
  // VCS coverage off
  end else if ((wt_actv_exp_set) == 1'b0) begin
  end else begin
    wt_actv_exp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_actv_mask <= {64{1'b0}};
  end else begin
  if ((wt_actv_exp_set) == 1'b1) begin
    wt_actv_mask <= wt_sd_mask;
  // VCS coverage off
  end else if ((wt_actv_exp_set) == 1'b0) begin
  end else begin
    wt_actv_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_actv_exp_set))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! wt_actv_exp_pvld is 1 when setting!")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (wt_actv_exp_set & ~wt_actv_exp_clr  & wt_actv_exp_pvld)); // spyglass disable W504 SelfDeterminedExpr-ML 
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


//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    reg funcpoint_cover_off;
    initial begin
        if ( $test$plusargs( "cover_off" ) ) begin
            funcpoint_cover_off = 1'b1;
        end else begin
            funcpoint_cover_off = 1'b0;
        end
    end

    property cmac_core_mac_exp__wt_actv_set_and_clr__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (wt_actv_exp_set & wt_actv_exp_clr);
    endproperty
    // Cover 0 : "(wt_actv_exp_set & wt_actv_exp_clr)"
    FUNCPOINT_cmac_core_mac_exp__wt_actv_set_and_clr__0_COV : cover property (cmac_core_mac_exp__wt_actv_set_and_clr__0_cov);

  `endif
`endif
//VCS coverage on


//==========================================================
// Input exponent select
//==========================================================
always @(
  wt_actv_exp_set
  or wt_sd_exp
  or wt_actv_exp
  ) begin
    wt_cur_exp = wt_actv_exp_set ? wt_sd_exp : wt_actv_exp;
end

always @(
  wt_actv_exp_set
  or wt_sd_mask
  or wt_actv_mask
  ) begin
    wt_cur_mask = wt_actv_exp_set ? wt_sd_mask : wt_actv_mask;
end

always @(
  dat_pre_exp
  ) begin
    dat_cur_exp = dat_pre_exp;
end

always @(
  dat_pre_mask
  ) begin
    dat_cur_mask = dat_pre_mask;
end

always @(
  dat_pre_pvld
  or cfg_is_fp16_d1
  or wt_sd_pvld
  or dat_pre_stripe_st
  or wt_actv_exp_pvld
  ) begin
    exp_p1_pvld_w = dat_pre_pvld & cfg_is_fp16_d1[1] & ((wt_sd_pvld & dat_pre_stripe_st) | (wt_actv_exp_pvld));
end

always @(
  wt_cur_mask
  or dat_cur_mask
  ) begin
    exp_cur_mask = wt_cur_mask & dat_cur_mask;
end

//==========================================================
// Calculate exponent for each multiplication
//==========================================================
//////////////// generate exponent sum ////////////////
always @(
  exp_cur_mask
  or dat_cur_exp
  or wt_cur_exp
  ) begin
    exp_sum_00[3:0] = ~exp_cur_mask[00] ? 4'b0 : (dat_cur_exp[2:0] + wt_cur_exp[2:0]);
    exp_sum_01[3:0] = ~exp_cur_mask[01] ? 4'b0 : (dat_cur_exp[5:3] + wt_cur_exp[5:3]);
    exp_sum_02[3:0] = ~exp_cur_mask[02] ? 4'b0 : (dat_cur_exp[8:6] + wt_cur_exp[8:6]);
    exp_sum_03[3:0] = ~exp_cur_mask[03] ? 4'b0 : (dat_cur_exp[11:9] + wt_cur_exp[11:9]);
    exp_sum_04[3:0] = ~exp_cur_mask[04] ? 4'b0 : (dat_cur_exp[14:12] + wt_cur_exp[14:12]);
    exp_sum_05[3:0] = ~exp_cur_mask[05] ? 4'b0 : (dat_cur_exp[17:15] + wt_cur_exp[17:15]);
    exp_sum_06[3:0] = ~exp_cur_mask[06] ? 4'b0 : (dat_cur_exp[20:18] + wt_cur_exp[20:18]);
    exp_sum_07[3:0] = ~exp_cur_mask[07] ? 4'b0 : (dat_cur_exp[23:21] + wt_cur_exp[23:21]);
    exp_sum_08[3:0] = ~exp_cur_mask[08] ? 4'b0 : (dat_cur_exp[26:24] + wt_cur_exp[26:24]);
    exp_sum_09[3:0] = ~exp_cur_mask[09] ? 4'b0 : (dat_cur_exp[29:27] + wt_cur_exp[29:27]);
    exp_sum_10[3:0] = ~exp_cur_mask[10] ? 4'b0 : (dat_cur_exp[32:30] + wt_cur_exp[32:30]);
    exp_sum_11[3:0] = ~exp_cur_mask[11] ? 4'b0 : (dat_cur_exp[35:33] + wt_cur_exp[35:33]);
    exp_sum_12[3:0] = ~exp_cur_mask[12] ? 4'b0 : (dat_cur_exp[38:36] + wt_cur_exp[38:36]);
    exp_sum_13[3:0] = ~exp_cur_mask[13] ? 4'b0 : (dat_cur_exp[41:39] + wt_cur_exp[41:39]);
    exp_sum_14[3:0] = ~exp_cur_mask[14] ? 4'b0 : (dat_cur_exp[44:42] + wt_cur_exp[44:42]);
    exp_sum_15[3:0] = ~exp_cur_mask[15] ? 4'b0 : (dat_cur_exp[47:45] + wt_cur_exp[47:45]);
    exp_sum_16[3:0] = ~exp_cur_mask[16] ? 4'b0 : (dat_cur_exp[50:48] + wt_cur_exp[50:48]);
    exp_sum_17[3:0] = ~exp_cur_mask[17] ? 4'b0 : (dat_cur_exp[53:51] + wt_cur_exp[53:51]);
    exp_sum_18[3:0] = ~exp_cur_mask[18] ? 4'b0 : (dat_cur_exp[56:54] + wt_cur_exp[56:54]);
    exp_sum_19[3:0] = ~exp_cur_mask[19] ? 4'b0 : (dat_cur_exp[59:57] + wt_cur_exp[59:57]);
    exp_sum_20[3:0] = ~exp_cur_mask[20] ? 4'b0 : (dat_cur_exp[62:60] + wt_cur_exp[62:60]);
    exp_sum_21[3:0] = ~exp_cur_mask[21] ? 4'b0 : (dat_cur_exp[65:63] + wt_cur_exp[65:63]);
    exp_sum_22[3:0] = ~exp_cur_mask[22] ? 4'b0 : (dat_cur_exp[68:66] + wt_cur_exp[68:66]);
    exp_sum_23[3:0] = ~exp_cur_mask[23] ? 4'b0 : (dat_cur_exp[71:69] + wt_cur_exp[71:69]);
    exp_sum_24[3:0] = ~exp_cur_mask[24] ? 4'b0 : (dat_cur_exp[74:72] + wt_cur_exp[74:72]);
    exp_sum_25[3:0] = ~exp_cur_mask[25] ? 4'b0 : (dat_cur_exp[77:75] + wt_cur_exp[77:75]);
    exp_sum_26[3:0] = ~exp_cur_mask[26] ? 4'b0 : (dat_cur_exp[80:78] + wt_cur_exp[80:78]);
    exp_sum_27[3:0] = ~exp_cur_mask[27] ? 4'b0 : (dat_cur_exp[83:81] + wt_cur_exp[83:81]);
    exp_sum_28[3:0] = ~exp_cur_mask[28] ? 4'b0 : (dat_cur_exp[86:84] + wt_cur_exp[86:84]);
    exp_sum_29[3:0] = ~exp_cur_mask[29] ? 4'b0 : (dat_cur_exp[89:87] + wt_cur_exp[89:87]);
    exp_sum_30[3:0] = ~exp_cur_mask[30] ? 4'b0 : (dat_cur_exp[92:90] + wt_cur_exp[92:90]);
    exp_sum_31[3:0] = ~exp_cur_mask[31] ? 4'b0 : (dat_cur_exp[95:93] + wt_cur_exp[95:93]);
    exp_sum_32[3:0] = ~exp_cur_mask[32] ? 4'b0 : (dat_cur_exp[98:96] + wt_cur_exp[98:96]);
    exp_sum_33[3:0] = ~exp_cur_mask[33] ? 4'b0 : (dat_cur_exp[101:99] + wt_cur_exp[101:99]);
    exp_sum_34[3:0] = ~exp_cur_mask[34] ? 4'b0 : (dat_cur_exp[104:102] + wt_cur_exp[104:102]);
    exp_sum_35[3:0] = ~exp_cur_mask[35] ? 4'b0 : (dat_cur_exp[107:105] + wt_cur_exp[107:105]);
    exp_sum_36[3:0] = ~exp_cur_mask[36] ? 4'b0 : (dat_cur_exp[110:108] + wt_cur_exp[110:108]);
    exp_sum_37[3:0] = ~exp_cur_mask[37] ? 4'b0 : (dat_cur_exp[113:111] + wt_cur_exp[113:111]);
    exp_sum_38[3:0] = ~exp_cur_mask[38] ? 4'b0 : (dat_cur_exp[116:114] + wt_cur_exp[116:114]);
    exp_sum_39[3:0] = ~exp_cur_mask[39] ? 4'b0 : (dat_cur_exp[119:117] + wt_cur_exp[119:117]);
    exp_sum_40[3:0] = ~exp_cur_mask[40] ? 4'b0 : (dat_cur_exp[122:120] + wt_cur_exp[122:120]);
    exp_sum_41[3:0] = ~exp_cur_mask[41] ? 4'b0 : (dat_cur_exp[125:123] + wt_cur_exp[125:123]);
    exp_sum_42[3:0] = ~exp_cur_mask[42] ? 4'b0 : (dat_cur_exp[128:126] + wt_cur_exp[128:126]);
    exp_sum_43[3:0] = ~exp_cur_mask[43] ? 4'b0 : (dat_cur_exp[131:129] + wt_cur_exp[131:129]);
    exp_sum_44[3:0] = ~exp_cur_mask[44] ? 4'b0 : (dat_cur_exp[134:132] + wt_cur_exp[134:132]);
    exp_sum_45[3:0] = ~exp_cur_mask[45] ? 4'b0 : (dat_cur_exp[137:135] + wt_cur_exp[137:135]);
    exp_sum_46[3:0] = ~exp_cur_mask[46] ? 4'b0 : (dat_cur_exp[140:138] + wt_cur_exp[140:138]);
    exp_sum_47[3:0] = ~exp_cur_mask[47] ? 4'b0 : (dat_cur_exp[143:141] + wt_cur_exp[143:141]);
    exp_sum_48[3:0] = ~exp_cur_mask[48] ? 4'b0 : (dat_cur_exp[146:144] + wt_cur_exp[146:144]);
    exp_sum_49[3:0] = ~exp_cur_mask[49] ? 4'b0 : (dat_cur_exp[149:147] + wt_cur_exp[149:147]);
    exp_sum_50[3:0] = ~exp_cur_mask[50] ? 4'b0 : (dat_cur_exp[152:150] + wt_cur_exp[152:150]);
    exp_sum_51[3:0] = ~exp_cur_mask[51] ? 4'b0 : (dat_cur_exp[155:153] + wt_cur_exp[155:153]);
    exp_sum_52[3:0] = ~exp_cur_mask[52] ? 4'b0 : (dat_cur_exp[158:156] + wt_cur_exp[158:156]);
    exp_sum_53[3:0] = ~exp_cur_mask[53] ? 4'b0 : (dat_cur_exp[161:159] + wt_cur_exp[161:159]);
    exp_sum_54[3:0] = ~exp_cur_mask[54] ? 4'b0 : (dat_cur_exp[164:162] + wt_cur_exp[164:162]);
    exp_sum_55[3:0] = ~exp_cur_mask[55] ? 4'b0 : (dat_cur_exp[167:165] + wt_cur_exp[167:165]);
    exp_sum_56[3:0] = ~exp_cur_mask[56] ? 4'b0 : (dat_cur_exp[170:168] + wt_cur_exp[170:168]);
    exp_sum_57[3:0] = ~exp_cur_mask[57] ? 4'b0 : (dat_cur_exp[173:171] + wt_cur_exp[173:171]);
    exp_sum_58[3:0] = ~exp_cur_mask[58] ? 4'b0 : (dat_cur_exp[176:174] + wt_cur_exp[176:174]);
    exp_sum_59[3:0] = ~exp_cur_mask[59] ? 4'b0 : (dat_cur_exp[179:177] + wt_cur_exp[179:177]);
    exp_sum_60[3:0] = ~exp_cur_mask[60] ? 4'b0 : (dat_cur_exp[182:180] + wt_cur_exp[182:180]);
    exp_sum_61[3:0] = ~exp_cur_mask[61] ? 4'b0 : (dat_cur_exp[185:183] + wt_cur_exp[185:183]);
    exp_sum_62[3:0] = ~exp_cur_mask[62] ? 4'b0 : (dat_cur_exp[188:186] + wt_cur_exp[188:186]);
    exp_sum_63[3:0] = ~exp_cur_mask[63] ? 4'b0 : (dat_cur_exp[191:189] + wt_cur_exp[191:189]);
end



//==========================================================
// EXP MAX PHASE I: Select one max value for each four sums
//==========================================================
//////////////// exp exp inptu ////////////////
always @(
  exp_sum_03
  or exp_sum_02
  or exp_sum_01
  or exp_sum_00
  or exp_sum_07
  or exp_sum_06
  or exp_sum_05
  or exp_sum_04
  or exp_sum_11
  or exp_sum_10
  or exp_sum_09
  or exp_sum_08
  or exp_sum_15
  or exp_sum_14
  or exp_sum_13
  or exp_sum_12
  or exp_sum_19
  or exp_sum_18
  or exp_sum_17
  or exp_sum_16
  or exp_sum_23
  or exp_sum_22
  or exp_sum_21
  or exp_sum_20
  or exp_sum_27
  or exp_sum_26
  or exp_sum_25
  or exp_sum_24
  or exp_sum_31
  or exp_sum_30
  or exp_sum_29
  or exp_sum_28
  or exp_sum_35
  or exp_sum_34
  or exp_sum_33
  or exp_sum_32
  or exp_sum_39
  or exp_sum_38
  or exp_sum_37
  or exp_sum_36
  or exp_sum_43
  or exp_sum_42
  or exp_sum_41
  or exp_sum_40
  or exp_sum_47
  or exp_sum_46
  or exp_sum_45
  or exp_sum_44
  or exp_sum_51
  or exp_sum_50
  or exp_sum_49
  or exp_sum_48
  or exp_sum_55
  or exp_sum_54
  or exp_sum_53
  or exp_sum_52
  or exp_sum_59
  or exp_sum_58
  or exp_sum_57
  or exp_sum_56
  or exp_sum_63
  or exp_sum_62
  or exp_sum_61
  or exp_sum_60
  ) begin
    exp_in_l0n00 = {exp_sum_03, exp_sum_02, exp_sum_01, exp_sum_00};
    exp_in_l0n01 = {exp_sum_07, exp_sum_06, exp_sum_05, exp_sum_04};
    exp_in_l0n02 = {exp_sum_11, exp_sum_10, exp_sum_09, exp_sum_08};
    exp_in_l0n03 = {exp_sum_15, exp_sum_14, exp_sum_13, exp_sum_12};
    exp_in_l0n04 = {exp_sum_19, exp_sum_18, exp_sum_17, exp_sum_16};
    exp_in_l0n05 = {exp_sum_23, exp_sum_22, exp_sum_21, exp_sum_20};
    exp_in_l0n06 = {exp_sum_27, exp_sum_26, exp_sum_25, exp_sum_24};
    exp_in_l0n07 = {exp_sum_31, exp_sum_30, exp_sum_29, exp_sum_28};
    exp_in_l0n08 = {exp_sum_35, exp_sum_34, exp_sum_33, exp_sum_32};
    exp_in_l0n09 = {exp_sum_39, exp_sum_38, exp_sum_37, exp_sum_36};
    exp_in_l0n10 = {exp_sum_43, exp_sum_42, exp_sum_41, exp_sum_40};
    exp_in_l0n11 = {exp_sum_47, exp_sum_46, exp_sum_45, exp_sum_44};
    exp_in_l0n12 = {exp_sum_51, exp_sum_50, exp_sum_49, exp_sum_48};
    exp_in_l0n13 = {exp_sum_55, exp_sum_54, exp_sum_53, exp_sum_52};
    exp_in_l0n14 = {exp_sum_59, exp_sum_58, exp_sum_57, exp_sum_56};
    exp_in_l0n15 = {exp_sum_63, exp_sum_62, exp_sum_61, exp_sum_60};
end



//////////////// exp max level 0 ////////////////

`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n00 (
   .a       (exp_in_l0n00[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_00[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n00 (
   .a       (exp_in_l0n00[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_00[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n01 (
   .a       (exp_in_l0n01[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_01[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n01 (
   .a       (exp_in_l0n01[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_01[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n02 (
   .a       (exp_in_l0n02[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_02[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n02 (
   .a       (exp_in_l0n02[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_02[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n03 (
   .a       (exp_in_l0n03[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_03[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n03 (
   .a       (exp_in_l0n03[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_03[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n04 (
   .a       (exp_in_l0n04[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_04[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n04 (
   .a       (exp_in_l0n04[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_04[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n05 (
   .a       (exp_in_l0n05[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_05[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n05 (
   .a       (exp_in_l0n05[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_05[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n06 (
   .a       (exp_in_l0n06[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_06[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n06 (
   .a       (exp_in_l0n06[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_06[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n07 (
   .a       (exp_in_l0n07[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_07[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n07 (
   .a       (exp_in_l0n07[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_07[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n08 (
   .a       (exp_in_l0n08[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_08[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n08 (
   .a       (exp_in_l0n08[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_08[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n09 (
   .a       (exp_in_l0n09[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_09[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n09 (
   .a       (exp_in_l0n09[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_09[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n10 (
   .a       (exp_in_l0n10[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_10[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n10 (
   .a       (exp_in_l0n10[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_10[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n11 (
   .a       (exp_in_l0n11[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_11[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n11 (
   .a       (exp_in_l0n11[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_11[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n12 (
   .a       (exp_in_l0n12[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_12[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n12 (
   .a       (exp_in_l0n12[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_12[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n13 (
   .a       (exp_in_l0n13[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_13[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n13 (
   .a       (exp_in_l0n13[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_13[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n14 (
   .a       (exp_in_l0n14[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_14[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n14 (
   .a       (exp_in_l0n14[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_14[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 4) u_expmax_l0n15 (
   .a       (exp_in_l0n15[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_15[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 4) u_expmax_l0n15 (
   .a       (exp_in_l0n15[15:0]) //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l0_15[3:0]) //|> w
  ,.index   ()                   //|> ?
  );
`endif 






//==========================================================
// EXP MAX PHASE II: Select one max value from 16 candidates
//==========================================================
//////////////// exp compare level 1 ////////////////
always @(
  exp_max_l0_15
  or exp_max_l0_14
  or exp_max_l0_13
  or exp_max_l0_12
  or exp_max_l0_11
  or exp_max_l0_10
  or exp_max_l0_09
  or exp_max_l0_08
  or exp_max_l0_07
  or exp_max_l0_06
  or exp_max_l0_05
  or exp_max_l0_04
  or exp_max_l0_03
  or exp_max_l0_02
  or exp_max_l0_01
  or exp_max_l0_00
  ) begin
    exp_in_l1n0 = {exp_max_l0_15, exp_max_l0_14, exp_max_l0_13, exp_max_l0_12,
                   exp_max_l0_11, exp_max_l0_10, exp_max_l0_09, exp_max_l0_08,
                   exp_max_l0_07, exp_max_l0_06, exp_max_l0_05, exp_max_l0_04,
                   exp_max_l0_03, exp_max_l0_02, exp_max_l0_01, exp_max_l0_00};
end

`ifdef DESIGNWARE_NOEXIST 
NV_DW_minmax #(4, 16) u_expmax_l1n0 (
   .a       (exp_in_l1n0[63:0])  //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l1_0[3:0])  //|> w
  ,.index   ()                   //|> ?
  );
`else 
DW_minmax #(4, 16) u_expmax_l1n0 (
   .a       (exp_in_l1n0[63:0])  //|< r
  ,.tc      (1'b0)               //|< ?
  ,.min_max (1'b1)               //|< ?
  ,.value   (exp_max_l1_0[3:0])  //|> w
  ,.index   ()                   //|> ?
  );
`endif 

//////////////// generate exp phase 2 shift ////////////////
always @(
  exp_max_l1_0
  or exp_sum_00
  or exp_sum_01
  or exp_sum_02
  or exp_sum_03
  or exp_sum_04
  or exp_sum_05
  or exp_sum_06
  or exp_sum_07
  or exp_sum_08
  or exp_sum_09
  or exp_sum_10
  or exp_sum_11
  or exp_sum_12
  or exp_sum_13
  or exp_sum_14
  or exp_sum_15
  or exp_sum_16
  or exp_sum_17
  or exp_sum_18
  or exp_sum_19
  or exp_sum_20
  or exp_sum_21
  or exp_sum_22
  or exp_sum_23
  or exp_sum_24
  or exp_sum_25
  or exp_sum_26
  or exp_sum_27
  or exp_sum_28
  or exp_sum_29
  or exp_sum_30
  or exp_sum_31
  or exp_sum_32
  or exp_sum_33
  or exp_sum_34
  or exp_sum_35
  or exp_sum_36
  or exp_sum_37
  or exp_sum_38
  or exp_sum_39
  or exp_sum_40
  or exp_sum_41
  or exp_sum_42
  or exp_sum_43
  or exp_sum_44
  or exp_sum_45
  or exp_sum_46
  or exp_sum_47
  or exp_sum_48
  or exp_sum_49
  or exp_sum_50
  or exp_sum_51
  or exp_sum_52
  or exp_sum_53
  or exp_sum_54
  or exp_sum_55
  or exp_sum_56
  or exp_sum_57
  or exp_sum_58
  or exp_sum_59
  or exp_sum_60
  or exp_sum_61
  or exp_sum_62
  or exp_sum_63
  ) begin
{mon_exp_p1_sft_00_w, exp_p1_sft_00_w[3:0]} = exp_max_l1_0 - exp_sum_00;
{mon_exp_p1_sft_01_w, exp_p1_sft_01_w[3:0]} = exp_max_l1_0 - exp_sum_01;
{mon_exp_p1_sft_02_w, exp_p1_sft_02_w[3:0]} = exp_max_l1_0 - exp_sum_02;
{mon_exp_p1_sft_03_w, exp_p1_sft_03_w[3:0]} = exp_max_l1_0 - exp_sum_03;
{mon_exp_p1_sft_04_w, exp_p1_sft_04_w[3:0]} = exp_max_l1_0 - exp_sum_04;
{mon_exp_p1_sft_05_w, exp_p1_sft_05_w[3:0]} = exp_max_l1_0 - exp_sum_05;
{mon_exp_p1_sft_06_w, exp_p1_sft_06_w[3:0]} = exp_max_l1_0 - exp_sum_06;
{mon_exp_p1_sft_07_w, exp_p1_sft_07_w[3:0]} = exp_max_l1_0 - exp_sum_07;
{mon_exp_p1_sft_08_w, exp_p1_sft_08_w[3:0]} = exp_max_l1_0 - exp_sum_08;
{mon_exp_p1_sft_09_w, exp_p1_sft_09_w[3:0]} = exp_max_l1_0 - exp_sum_09;
{mon_exp_p1_sft_10_w, exp_p1_sft_10_w[3:0]} = exp_max_l1_0 - exp_sum_10;
{mon_exp_p1_sft_11_w, exp_p1_sft_11_w[3:0]} = exp_max_l1_0 - exp_sum_11;
{mon_exp_p1_sft_12_w, exp_p1_sft_12_w[3:0]} = exp_max_l1_0 - exp_sum_12;
{mon_exp_p1_sft_13_w, exp_p1_sft_13_w[3:0]} = exp_max_l1_0 - exp_sum_13;
{mon_exp_p1_sft_14_w, exp_p1_sft_14_w[3:0]} = exp_max_l1_0 - exp_sum_14;
{mon_exp_p1_sft_15_w, exp_p1_sft_15_w[3:0]} = exp_max_l1_0 - exp_sum_15;
{mon_exp_p1_sft_16_w, exp_p1_sft_16_w[3:0]} = exp_max_l1_0 - exp_sum_16;
{mon_exp_p1_sft_17_w, exp_p1_sft_17_w[3:0]} = exp_max_l1_0 - exp_sum_17;
{mon_exp_p1_sft_18_w, exp_p1_sft_18_w[3:0]} = exp_max_l1_0 - exp_sum_18;
{mon_exp_p1_sft_19_w, exp_p1_sft_19_w[3:0]} = exp_max_l1_0 - exp_sum_19;
{mon_exp_p1_sft_20_w, exp_p1_sft_20_w[3:0]} = exp_max_l1_0 - exp_sum_20;
{mon_exp_p1_sft_21_w, exp_p1_sft_21_w[3:0]} = exp_max_l1_0 - exp_sum_21;
{mon_exp_p1_sft_22_w, exp_p1_sft_22_w[3:0]} = exp_max_l1_0 - exp_sum_22;
{mon_exp_p1_sft_23_w, exp_p1_sft_23_w[3:0]} = exp_max_l1_0 - exp_sum_23;
{mon_exp_p1_sft_24_w, exp_p1_sft_24_w[3:0]} = exp_max_l1_0 - exp_sum_24;
{mon_exp_p1_sft_25_w, exp_p1_sft_25_w[3:0]} = exp_max_l1_0 - exp_sum_25;
{mon_exp_p1_sft_26_w, exp_p1_sft_26_w[3:0]} = exp_max_l1_0 - exp_sum_26;
{mon_exp_p1_sft_27_w, exp_p1_sft_27_w[3:0]} = exp_max_l1_0 - exp_sum_27;
{mon_exp_p1_sft_28_w, exp_p1_sft_28_w[3:0]} = exp_max_l1_0 - exp_sum_28;
{mon_exp_p1_sft_29_w, exp_p1_sft_29_w[3:0]} = exp_max_l1_0 - exp_sum_29;
{mon_exp_p1_sft_30_w, exp_p1_sft_30_w[3:0]} = exp_max_l1_0 - exp_sum_30;
{mon_exp_p1_sft_31_w, exp_p1_sft_31_w[3:0]} = exp_max_l1_0 - exp_sum_31;
{mon_exp_p1_sft_32_w, exp_p1_sft_32_w[3:0]} = exp_max_l1_0 - exp_sum_32;
{mon_exp_p1_sft_33_w, exp_p1_sft_33_w[3:0]} = exp_max_l1_0 - exp_sum_33;
{mon_exp_p1_sft_34_w, exp_p1_sft_34_w[3:0]} = exp_max_l1_0 - exp_sum_34;
{mon_exp_p1_sft_35_w, exp_p1_sft_35_w[3:0]} = exp_max_l1_0 - exp_sum_35;
{mon_exp_p1_sft_36_w, exp_p1_sft_36_w[3:0]} = exp_max_l1_0 - exp_sum_36;
{mon_exp_p1_sft_37_w, exp_p1_sft_37_w[3:0]} = exp_max_l1_0 - exp_sum_37;
{mon_exp_p1_sft_38_w, exp_p1_sft_38_w[3:0]} = exp_max_l1_0 - exp_sum_38;
{mon_exp_p1_sft_39_w, exp_p1_sft_39_w[3:0]} = exp_max_l1_0 - exp_sum_39;
{mon_exp_p1_sft_40_w, exp_p1_sft_40_w[3:0]} = exp_max_l1_0 - exp_sum_40;
{mon_exp_p1_sft_41_w, exp_p1_sft_41_w[3:0]} = exp_max_l1_0 - exp_sum_41;
{mon_exp_p1_sft_42_w, exp_p1_sft_42_w[3:0]} = exp_max_l1_0 - exp_sum_42;
{mon_exp_p1_sft_43_w, exp_p1_sft_43_w[3:0]} = exp_max_l1_0 - exp_sum_43;
{mon_exp_p1_sft_44_w, exp_p1_sft_44_w[3:0]} = exp_max_l1_0 - exp_sum_44;
{mon_exp_p1_sft_45_w, exp_p1_sft_45_w[3:0]} = exp_max_l1_0 - exp_sum_45;
{mon_exp_p1_sft_46_w, exp_p1_sft_46_w[3:0]} = exp_max_l1_0 - exp_sum_46;
{mon_exp_p1_sft_47_w, exp_p1_sft_47_w[3:0]} = exp_max_l1_0 - exp_sum_47;
{mon_exp_p1_sft_48_w, exp_p1_sft_48_w[3:0]} = exp_max_l1_0 - exp_sum_48;
{mon_exp_p1_sft_49_w, exp_p1_sft_49_w[3:0]} = exp_max_l1_0 - exp_sum_49;
{mon_exp_p1_sft_50_w, exp_p1_sft_50_w[3:0]} = exp_max_l1_0 - exp_sum_50;
{mon_exp_p1_sft_51_w, exp_p1_sft_51_w[3:0]} = exp_max_l1_0 - exp_sum_51;
{mon_exp_p1_sft_52_w, exp_p1_sft_52_w[3:0]} = exp_max_l1_0 - exp_sum_52;
{mon_exp_p1_sft_53_w, exp_p1_sft_53_w[3:0]} = exp_max_l1_0 - exp_sum_53;
{mon_exp_p1_sft_54_w, exp_p1_sft_54_w[3:0]} = exp_max_l1_0 - exp_sum_54;
{mon_exp_p1_sft_55_w, exp_p1_sft_55_w[3:0]} = exp_max_l1_0 - exp_sum_55;
{mon_exp_p1_sft_56_w, exp_p1_sft_56_w[3:0]} = exp_max_l1_0 - exp_sum_56;
{mon_exp_p1_sft_57_w, exp_p1_sft_57_w[3:0]} = exp_max_l1_0 - exp_sum_57;
{mon_exp_p1_sft_58_w, exp_p1_sft_58_w[3:0]} = exp_max_l1_0 - exp_sum_58;
{mon_exp_p1_sft_59_w, exp_p1_sft_59_w[3:0]} = exp_max_l1_0 - exp_sum_59;
{mon_exp_p1_sft_60_w, exp_p1_sft_60_w[3:0]} = exp_max_l1_0 - exp_sum_60;
{mon_exp_p1_sft_61_w, exp_p1_sft_61_w[3:0]} = exp_max_l1_0 - exp_sum_61;
{mon_exp_p1_sft_62_w, exp_p1_sft_62_w[3:0]} = exp_max_l1_0 - exp_sum_62;
{mon_exp_p1_sft_63_w, exp_p1_sft_63_w[3:0]} = exp_max_l1_0 - exp_sum_63;
end




//==========================================================
// registers for PHASE II
//==========================================================
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_00 <= exp_p1_sft_00_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_00 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_01 <= exp_p1_sft_01_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_01 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_02 <= exp_p1_sft_02_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_02 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_03 <= exp_p1_sft_03_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_03 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_04 <= exp_p1_sft_04_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_04 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_05 <= exp_p1_sft_05_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_05 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_06 <= exp_p1_sft_06_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_06 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_07 <= exp_p1_sft_07_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_07 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_08 <= exp_p1_sft_08_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_08 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_09 <= exp_p1_sft_09_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_09 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_10 <= exp_p1_sft_10_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_10 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_11 <= exp_p1_sft_11_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_11 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_12 <= exp_p1_sft_12_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_12 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_13 <= exp_p1_sft_13_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_13 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_14 <= exp_p1_sft_14_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_14 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_15 <= exp_p1_sft_15_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_15 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_16 <= exp_p1_sft_16_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_16 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_17 <= exp_p1_sft_17_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_17 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_18 <= exp_p1_sft_18_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_18 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_19 <= exp_p1_sft_19_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_19 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_20 <= exp_p1_sft_20_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_20 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_21 <= exp_p1_sft_21_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_21 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_22 <= exp_p1_sft_22_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_22 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_23 <= exp_p1_sft_23_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_23 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_24 <= exp_p1_sft_24_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_24 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_25 <= exp_p1_sft_25_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_25 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_26 <= exp_p1_sft_26_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_26 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_27 <= exp_p1_sft_27_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_27 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_28 <= exp_p1_sft_28_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_28 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_29 <= exp_p1_sft_29_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_29 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_30 <= exp_p1_sft_30_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_30 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_31 <= exp_p1_sft_31_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_31 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_32 <= exp_p1_sft_32_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_32 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_33 <= exp_p1_sft_33_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_33 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_34 <= exp_p1_sft_34_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_34 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_35 <= exp_p1_sft_35_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_35 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_36 <= exp_p1_sft_36_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_36 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_37 <= exp_p1_sft_37_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_37 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_38 <= exp_p1_sft_38_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_38 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_39 <= exp_p1_sft_39_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_39 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_40 <= exp_p1_sft_40_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_40 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_41 <= exp_p1_sft_41_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_41 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_42 <= exp_p1_sft_42_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_42 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_43 <= exp_p1_sft_43_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_43 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_44 <= exp_p1_sft_44_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_44 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_45 <= exp_p1_sft_45_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_45 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_46 <= exp_p1_sft_46_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_46 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_47 <= exp_p1_sft_47_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_47 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_48 <= exp_p1_sft_48_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_48 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_49 <= exp_p1_sft_49_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_49 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_50 <= exp_p1_sft_50_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_50 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_51 <= exp_p1_sft_51_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_51 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_52 <= exp_p1_sft_52_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_52 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_53 <= exp_p1_sft_53_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_53 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_54 <= exp_p1_sft_54_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_54 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_55 <= exp_p1_sft_55_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_55 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_56 <= exp_p1_sft_56_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_56 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_57 <= exp_p1_sft_57_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_57 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_58 <= exp_p1_sft_58_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_58 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_59 <= exp_p1_sft_59_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_59 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_60 <= exp_p1_sft_60_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_60 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_61 <= exp_p1_sft_61_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_61 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_62 <= exp_p1_sft_62_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_62 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_sft_63 <= exp_p1_sft_63_w[3:0];
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_sft_63 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end





always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    exp_p1_pvld <= 1'b0;
  end else begin
  exp_p1_pvld <= exp_p1_pvld_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((exp_p1_pvld_w) == 1'b1) begin
    exp_max_l1_0_d1 <= exp_max_l1_0;
  // VCS coverage off
  end else if ((exp_p1_pvld_w) == 1'b0) begin
  end else begin
    exp_max_l1_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

assign exp_pvld = exp_p1_pvld;
assign exp_max = exp_max_l1_0_d1;

endmodule // NV_NVDLA_CMAC_CORE_MAC_exp


