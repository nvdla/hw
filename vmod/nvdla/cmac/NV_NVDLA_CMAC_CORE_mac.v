// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_CORE_mac.v

module NV_NVDLA_CMAC_CORE_mac (
   nvdla_core_clk     //|< i
  ,nvdla_wg_clk       //|< i
  ,nvdla_core_rstn    //|< i
  ,cfg_is_fp16        //|< i
  ,cfg_is_int16       //|< i
  ,cfg_is_int8        //|< i
  ,cfg_is_wg          //|< i
  ,cfg_reg_en         //|< i
  ,dat_actv_data      //|< i
  ,dat_actv_nan       //|< i
  ,dat_actv_nz        //|< i
  ,dat_actv_pvld      //|< i
  ,dat_pre_exp        //|< i
  ,dat_pre_mask       //|< i
  ,dat_pre_pvld       //|< i
  ,dat_pre_stripe_end //|< i
  ,dat_pre_stripe_st  //|< i
  ,wt_actv_data       //|< i
  ,wt_actv_nan        //|< i
  ,wt_actv_nz         //|< i
  ,wt_actv_pvld       //|< i
  ,wt_sd_exp          //|< i
  ,wt_sd_mask         //|< i
  ,wt_sd_pvld         //|< i
  ,mac_out_data       //|> o
  ,mac_out_nan        //|> o
  ,mac_out_pvld       //|> o
  );

input           nvdla_core_clk;
input           nvdla_wg_clk;
input           nvdla_core_rstn;
input           cfg_is_fp16;
input           cfg_is_int16;
input           cfg_is_int8;
input           cfg_is_wg;
input           cfg_reg_en;
input  [1023:0] dat_actv_data;
input    [63:0] dat_actv_nan;
input   [127:0] dat_actv_nz;
input   [103:0] dat_actv_pvld;
input   [191:0] dat_pre_exp;
input    [63:0] dat_pre_mask;
input           dat_pre_pvld;
input           dat_pre_stripe_end;
input           dat_pre_stripe_st;
input  [1023:0] wt_actv_data;
input    [63:0] wt_actv_nan;
input   [127:0] wt_actv_nz;
input   [103:0] wt_actv_pvld;
input   [191:0] wt_sd_exp;
input    [63:0] wt_sd_mask;
input           wt_sd_pvld;
output  [175:0] mac_out_data;
output          mac_out_nan;
output          mac_out_pvld;
wire     [31:0] dbg_booth_result_00;
wire     [31:0] dbg_booth_result_01;
wire     [31:0] dbg_booth_result_02;
wire     [31:0] dbg_booth_result_03;
wire     [31:0] dbg_booth_result_04;
wire     [31:0] dbg_booth_result_05;
wire     [31:0] dbg_booth_result_06;
wire     [31:0] dbg_booth_result_07;
wire     [31:0] dbg_booth_result_08;
wire     [31:0] dbg_booth_result_09;
wire     [31:0] dbg_booth_result_10;
wire     [31:0] dbg_booth_result_11;
wire     [31:0] dbg_booth_result_12;
wire     [31:0] dbg_booth_result_13;
wire     [31:0] dbg_booth_result_14;
wire     [31:0] dbg_booth_result_15;
wire     [31:0] dbg_booth_result_16;
wire     [31:0] dbg_booth_result_17;
wire     [31:0] dbg_booth_result_18;
wire     [31:0] dbg_booth_result_19;
wire     [31:0] dbg_booth_result_20;
wire     [31:0] dbg_booth_result_21;
wire     [31:0] dbg_booth_result_22;
wire     [31:0] dbg_booth_result_23;
wire     [31:0] dbg_booth_result_24;
wire     [31:0] dbg_booth_result_25;
wire     [31:0] dbg_booth_result_26;
wire     [31:0] dbg_booth_result_27;
wire     [31:0] dbg_booth_result_28;
wire     [31:0] dbg_booth_result_29;
wire     [31:0] dbg_booth_result_30;
wire     [31:0] dbg_booth_result_31;
wire     [31:0] dbg_booth_result_32;
wire     [31:0] dbg_booth_result_33;
wire     [31:0] dbg_booth_result_34;
wire     [31:0] dbg_booth_result_35;
wire     [31:0] dbg_booth_result_36;
wire     [31:0] dbg_booth_result_37;
wire     [31:0] dbg_booth_result_38;
wire     [31:0] dbg_booth_result_39;
wire     [31:0] dbg_booth_result_40;
wire     [31:0] dbg_booth_result_41;
wire     [31:0] dbg_booth_result_42;
wire     [31:0] dbg_booth_result_43;
wire     [31:0] dbg_booth_result_44;
wire     [31:0] dbg_booth_result_45;
wire     [31:0] dbg_booth_result_46;
wire     [31:0] dbg_booth_result_47;
wire     [31:0] dbg_booth_result_48;
wire     [31:0] dbg_booth_result_49;
wire     [31:0] dbg_booth_result_50;
wire     [31:0] dbg_booth_result_51;
wire     [31:0] dbg_booth_result_52;
wire     [31:0] dbg_booth_result_53;
wire     [31:0] dbg_booth_result_54;
wire     [31:0] dbg_booth_result_55;
wire     [31:0] dbg_booth_result_56;
wire     [31:0] dbg_booth_result_57;
wire     [31:0] dbg_booth_result_58;
wire     [31:0] dbg_booth_result_59;
wire     [31:0] dbg_booth_result_60;
wire     [31:0] dbg_booth_result_61;
wire     [31:0] dbg_booth_result_62;
wire     [31:0] dbg_booth_result_63;
wire     [65:0] dbg_sign;
wire      [3:0] exp_max;
wire            exp_pvld;
wire      [3:0] exp_sft_00;
wire      [3:0] exp_sft_01;
wire      [3:0] exp_sft_02;
wire      [3:0] exp_sft_03;
wire      [3:0] exp_sft_04;
wire      [3:0] exp_sft_05;
wire      [3:0] exp_sft_06;
wire      [3:0] exp_sft_07;
wire      [3:0] exp_sft_08;
wire      [3:0] exp_sft_09;
wire      [3:0] exp_sft_10;
wire      [3:0] exp_sft_11;
wire      [3:0] exp_sft_12;
wire      [3:0] exp_sft_13;
wire      [3:0] exp_sft_14;
wire      [3:0] exp_sft_15;
wire      [3:0] exp_sft_16;
wire      [3:0] exp_sft_17;
wire      [3:0] exp_sft_18;
wire      [3:0] exp_sft_19;
wire      [3:0] exp_sft_20;
wire      [3:0] exp_sft_21;
wire      [3:0] exp_sft_22;
wire      [3:0] exp_sft_23;
wire      [3:0] exp_sft_24;
wire      [3:0] exp_sft_25;
wire      [3:0] exp_sft_26;
wire      [3:0] exp_sft_27;
wire      [3:0] exp_sft_28;
wire      [3:0] exp_sft_29;
wire      [3:0] exp_sft_30;
wire      [3:0] exp_sft_31;
wire      [3:0] exp_sft_32;
wire      [3:0] exp_sft_33;
wire      [3:0] exp_sft_34;
wire      [3:0] exp_sft_35;
wire      [3:0] exp_sft_36;
wire      [3:0] exp_sft_37;
wire      [3:0] exp_sft_38;
wire      [3:0] exp_sft_39;
wire      [3:0] exp_sft_40;
wire      [3:0] exp_sft_41;
wire      [3:0] exp_sft_42;
wire      [3:0] exp_sft_43;
wire      [3:0] exp_sft_44;
wire      [3:0] exp_sft_45;
wire      [3:0] exp_sft_46;
wire      [3:0] exp_sft_47;
wire      [3:0] exp_sft_48;
wire      [3:0] exp_sft_49;
wire      [3:0] exp_sft_50;
wire      [3:0] exp_sft_51;
wire      [3:0] exp_sft_52;
wire      [3:0] exp_sft_53;
wire      [3:0] exp_sft_54;
wire      [3:0] exp_sft_55;
wire      [3:0] exp_sft_56;
wire      [3:0] exp_sft_57;
wire      [3:0] exp_sft_58;
wire      [3:0] exp_sft_59;
wire      [3:0] exp_sft_60;
wire      [3:0] exp_sft_61;
wire      [3:0] exp_sft_62;
wire      [3:0] exp_sft_63;
wire     [10:0] out_nan_mts;
wire            out_nan_pvld;
wire            pp_exp_pvld_w;
wire            pp_nan_pvld_w;
wire     [35:0] pp_out_l0n00_0;
wire     [35:0] pp_out_l0n00_1;
wire     [35:0] pp_out_l0n01_0;
wire     [35:0] pp_out_l0n01_1;
wire     [35:0] pp_out_l0n02_0;
wire     [35:0] pp_out_l0n02_1;
wire     [35:0] pp_out_l0n03_0;
wire     [35:0] pp_out_l0n03_1;
wire     [35:0] pp_out_l0n04_0;
wire     [35:0] pp_out_l0n04_1;
wire     [35:0] pp_out_l0n05_0;
wire     [35:0] pp_out_l0n05_1;
wire     [35:0] pp_out_l0n06_0;
wire     [35:0] pp_out_l0n06_1;
wire     [35:0] pp_out_l0n07_0;
wire     [35:0] pp_out_l0n07_1;
wire     [35:0] pp_out_l0n08_0;
wire     [35:0] pp_out_l0n08_1;
wire     [35:0] pp_out_l0n09_0;
wire     [35:0] pp_out_l0n09_1;
wire     [35:0] pp_out_l0n10_0;
wire     [35:0] pp_out_l0n10_1;
wire     [35:0] pp_out_l0n11_0;
wire     [35:0] pp_out_l0n11_1;
wire     [35:0] pp_out_l0n12_0;
wire     [35:0] pp_out_l0n12_1;
wire     [35:0] pp_out_l0n13_0;
wire     [35:0] pp_out_l0n13_1;
wire     [35:0] pp_out_l0n14_0;
wire     [35:0] pp_out_l0n14_1;
wire     [35:0] pp_out_l0n15_0;
wire     [35:0] pp_out_l0n15_1;
wire     [41:0] pp_out_l1n0_0;
wire     [41:0] pp_out_l1n0_1;
wire     [41:0] pp_out_l1n1_0;
wire     [41:0] pp_out_l1n1_1;
wire     [41:0] pp_out_l1n2_0;
wire     [41:0] pp_out_l1n2_1;
wire     [41:0] pp_out_l1n3_0;
wire     [41:0] pp_out_l1n3_1;
wire     [41:0] pp_out_l1n4_0;
wire     [41:0] pp_out_l1n4_1;
wire     [41:0] pp_out_l1n5_0;
wire     [41:0] pp_out_l1n5_1;
wire     [41:0] pp_out_l1n6_0;
wire     [41:0] pp_out_l1n6_1;
wire     [41:0] pp_out_l1n7_0;
wire     [41:0] pp_out_l1n7_1;
wire     [41:0] pp_out_l2n0_0;
wire     [41:0] pp_out_l2n0_1;
wire     [41:0] pp_out_l2n1_0;
wire     [41:0] pp_out_l2n1_1;
wire     [41:0] pp_out_l2n2_0;
wire     [41:0] pp_out_l2n2_1;
wire     [41:0] pp_out_l2n3_0;
wire     [41:0] pp_out_l2n3_1;
wire     [41:0] pp_out_l2n4_0;
wire     [41:0] pp_out_l2n4_1;
wire     [41:0] pp_out_l2n5_0;
wire     [41:0] pp_out_l2n5_1;
wire     [41:0] pp_out_l2n6_0;
wire     [41:0] pp_out_l2n6_1;
wire     [41:0] pp_out_l2n7_0;
wire     [41:0] pp_out_l2n7_1;
wire     [45:0] pp_out_l3n0_0;
wire     [45:0] pp_out_l3n0_1;
wire     [45:0] pp_out_l3n1_0;
wire     [45:0] pp_out_l3n1_1;
wire     [45:0] pp_out_l3n2_0;
wire     [45:0] pp_out_l3n2_1;
wire     [45:0] pp_out_l3n3_0;
wire     [45:0] pp_out_l3n3_1;
wire     [45:0] pp_out_l4n0_0;
wire     [45:0] pp_out_l4n0_1;
wire     [45:0] pp_out_l4n1_0;
wire     [45:0] pp_out_l4n1_1;
wire     [45:0] pp_out_l4n2_0;
wire     [45:0] pp_out_l4n2_1;
wire     [45:0] pp_out_l4n3_0;
wire     [45:0] pp_out_l4n3_1;
wire     [63:0] ps_in_l1n0;
wire     [63:0] ps_in_l1n1;
wire     [63:0] ps_in_l1n10;
wire     [63:0] ps_in_l1n11;
wire     [63:0] ps_in_l1n12;
wire     [63:0] ps_in_l1n13;
wire     [63:0] ps_in_l1n14;
wire     [63:0] ps_in_l1n15;
wire     [63:0] ps_in_l1n2;
wire     [63:0] ps_in_l1n3;
wire     [63:0] ps_in_l1n4;
wire     [63:0] ps_in_l1n5;
wire     [63:0] ps_in_l1n6;
wire     [63:0] ps_in_l1n7;
wire     [63:0] ps_in_l1n8;
wire     [63:0] ps_in_l1n9;
wire    [303:0] ps_in_l2n0;
wire    [303:0] ps_in_l2n1;
wire    [303:0] ps_in_l2n2;
wire    [303:0] ps_in_l2n3;
wire      [7:0] ps_n0_in_b0;
wire      [7:0] ps_n0_in_b1;
wire      [7:0] ps_n0_in_b2;
wire      [7:0] ps_n0_in_b3;
wire      [7:0] ps_n0_in_b4;
wire      [7:0] ps_n0_in_b5;
wire      [7:0] ps_n0_in_b6;
wire      [7:0] ps_n0_in_b7;
wire      [6:0] ps_n0b0;
wire      [6:0] ps_n0b0_dc;
wire      [5:0] ps_n0b0_wg;
wire      [6:0] ps_n0b1;
wire      [6:0] ps_n0b1_dc;
wire      [5:0] ps_n0b1_wg;
wire      [6:0] ps_n0b2;
wire      [6:0] ps_n0b2_dc;
wire      [5:0] ps_n0b2_wg;
wire      [6:0] ps_n0b3;
wire      [6:0] ps_n0b3_dc;
wire      [5:0] ps_n0b3_wg;
wire      [6:0] ps_n0b4;
wire      [6:0] ps_n0b4_dc;
wire      [5:0] ps_n0b4_wg;
wire      [6:0] ps_n0b5;
wire      [6:0] ps_n0b5_dc;
wire      [5:0] ps_n0b5_wg;
wire      [6:0] ps_n0b6;
wire      [6:0] ps_n0b6_dc;
wire      [5:0] ps_n0b6_wg;
wire      [6:0] ps_n0b7;
wire      [6:0] ps_n0b7_dc;
wire      [5:0] ps_n0b7_wg;
wire      [7:0] ps_n1_in_b0;
wire      [7:0] ps_n1_in_b1;
wire      [7:0] ps_n1_in_b2;
wire      [7:0] ps_n1_in_b3;
wire      [7:0] ps_n1_in_b4;
wire      [7:0] ps_n1_in_b5;
wire      [7:0] ps_n1_in_b6;
wire      [7:0] ps_n1_in_b7;
wire      [6:0] ps_n1b0;
wire      [6:0] ps_n1b1;
wire      [6:0] ps_n1b2;
wire      [6:0] ps_n1b3;
wire      [6:0] ps_n1b4;
wire      [6:0] ps_n1b5;
wire      [6:0] ps_n1b6;
wire      [6:0] ps_n1b7;
wire      [7:0] ps_n2_in_b0;
wire      [7:0] ps_n2_in_b1;
wire      [7:0] ps_n2_in_b2;
wire      [7:0] ps_n2_in_b3;
wire      [7:0] ps_n2_in_b4;
wire      [7:0] ps_n2_in_b5;
wire      [7:0] ps_n2_in_b6;
wire      [7:0] ps_n2_in_b7;
wire      [6:0] ps_n2b0;
wire      [6:0] ps_n2b1;
wire      [6:0] ps_n2b2;
wire      [6:0] ps_n2b3;
wire      [6:0] ps_n2b4;
wire      [6:0] ps_n2b5;
wire      [6:0] ps_n2b6;
wire      [6:0] ps_n2b7;
wire      [7:0] ps_n3_in_b0;
wire      [7:0] ps_n3_in_b1;
wire      [7:0] ps_n3_in_b2;
wire      [7:0] ps_n3_in_b3;
wire      [7:0] ps_n3_in_b4;
wire      [7:0] ps_n3_in_b5;
wire      [7:0] ps_n3_in_b6;
wire      [7:0] ps_n3_in_b7;
wire      [6:0] ps_n3b0;
wire      [6:0] ps_n3b1;
wire      [6:0] ps_n3b2;
wire      [6:0] ps_n3b3;
wire      [6:0] ps_n3b4;
wire      [6:0] ps_n3b5;
wire      [6:0] ps_n3b6;
wire      [6:0] ps_n3b7;
wire     [15:0] ps_out_l1n0_0;
wire     [15:0] ps_out_l1n0_1;
wire     [15:0] ps_out_l1n10_0;
wire     [15:0] ps_out_l1n10_1;
wire     [15:0] ps_out_l1n11_0;
wire     [15:0] ps_out_l1n11_1;
wire     [15:0] ps_out_l1n12_0;
wire     [15:0] ps_out_l1n12_1;
wire     [15:0] ps_out_l1n13_0;
wire     [15:0] ps_out_l1n13_1;
wire     [15:0] ps_out_l1n14_0;
wire     [15:0] ps_out_l1n14_1;
wire     [15:0] ps_out_l1n15_0;
wire     [15:0] ps_out_l1n15_1;
wire     [15:0] ps_out_l1n1_0;
wire     [15:0] ps_out_l1n1_1;
wire     [15:0] ps_out_l1n2_0;
wire     [15:0] ps_out_l1n2_1;
wire     [15:0] ps_out_l1n3_0;
wire     [15:0] ps_out_l1n3_1;
wire     [15:0] ps_out_l1n4_0;
wire     [15:0] ps_out_l1n4_1;
wire     [15:0] ps_out_l1n5_0;
wire     [15:0] ps_out_l1n5_1;
wire     [15:0] ps_out_l1n6_0;
wire     [15:0] ps_out_l1n6_1;
wire     [15:0] ps_out_l1n7_0;
wire     [15:0] ps_out_l1n7_1;
wire     [15:0] ps_out_l1n8_0;
wire     [15:0] ps_out_l1n8_1;
wire     [15:0] ps_out_l1n9_0;
wire     [15:0] ps_out_l1n9_1;
wire     [37:0] ps_out_l2n0_0;
wire     [37:0] ps_out_l2n0_1;
wire     [37:0] ps_out_l2n1_0;
wire     [37:0] ps_out_l2n1_1;
wire     [37:0] ps_out_l2n2_0;
wire     [37:0] ps_out_l2n2_1;
wire     [37:0] ps_out_l2n3_0;
wire     [37:0] ps_out_l2n3_1;
wire     [31:0] res_a_00;
wire     [31:0] res_a_01;
wire     [31:0] res_a_02;
wire     [31:0] res_a_03;
wire     [31:0] res_a_04;
wire     [31:0] res_a_05;
wire     [31:0] res_a_06;
wire     [31:0] res_a_07;
wire     [31:0] res_a_08;
wire     [31:0] res_a_09;
wire     [31:0] res_a_10;
wire     [31:0] res_a_11;
wire     [31:0] res_a_12;
wire     [31:0] res_a_13;
wire     [31:0] res_a_14;
wire     [31:0] res_a_15;
wire     [31:0] res_a_16;
wire     [31:0] res_a_17;
wire     [31:0] res_a_18;
wire     [31:0] res_a_19;
wire     [31:0] res_a_20;
wire     [31:0] res_a_21;
wire     [31:0] res_a_22;
wire     [31:0] res_a_23;
wire     [31:0] res_a_24;
wire     [31:0] res_a_25;
wire     [31:0] res_a_26;
wire     [31:0] res_a_27;
wire     [31:0] res_a_28;
wire     [31:0] res_a_29;
wire     [31:0] res_a_30;
wire     [31:0] res_a_31;
wire     [31:0] res_a_32;
wire     [31:0] res_a_33;
wire     [31:0] res_a_34;
wire     [31:0] res_a_35;
wire     [31:0] res_a_36;
wire     [31:0] res_a_37;
wire     [31:0] res_a_38;
wire     [31:0] res_a_39;
wire     [31:0] res_a_40;
wire     [31:0] res_a_41;
wire     [31:0] res_a_42;
wire     [31:0] res_a_43;
wire     [31:0] res_a_44;
wire     [31:0] res_a_45;
wire     [31:0] res_a_46;
wire     [31:0] res_a_47;
wire     [31:0] res_a_48;
wire     [31:0] res_a_49;
wire     [31:0] res_a_50;
wire     [31:0] res_a_51;
wire     [31:0] res_a_52;
wire     [31:0] res_a_53;
wire     [31:0] res_a_54;
wire     [31:0] res_a_55;
wire     [31:0] res_a_56;
wire     [31:0] res_a_57;
wire     [31:0] res_a_58;
wire     [31:0] res_a_59;
wire     [31:0] res_a_60;
wire     [31:0] res_a_61;
wire     [31:0] res_a_62;
wire     [31:0] res_a_63;
wire     [31:0] res_b_00;
wire     [31:0] res_b_01;
wire     [31:0] res_b_02;
wire     [31:0] res_b_03;
wire     [31:0] res_b_04;
wire     [31:0] res_b_05;
wire     [31:0] res_b_06;
wire     [31:0] res_b_07;
wire     [31:0] res_b_08;
wire     [31:0] res_b_09;
wire     [31:0] res_b_10;
wire     [31:0] res_b_11;
wire     [31:0] res_b_12;
wire     [31:0] res_b_13;
wire     [31:0] res_b_14;
wire     [31:0] res_b_15;
wire     [31:0] res_b_16;
wire     [31:0] res_b_17;
wire     [31:0] res_b_18;
wire     [31:0] res_b_19;
wire     [31:0] res_b_20;
wire     [31:0] res_b_21;
wire     [31:0] res_b_22;
wire     [31:0] res_b_23;
wire     [31:0] res_b_24;
wire     [31:0] res_b_25;
wire     [31:0] res_b_26;
wire     [31:0] res_b_27;
wire     [31:0] res_b_28;
wire     [31:0] res_b_29;
wire     [31:0] res_b_30;
wire     [31:0] res_b_31;
wire     [31:0] res_b_32;
wire     [31:0] res_b_33;
wire     [31:0] res_b_34;
wire     [31:0] res_b_35;
wire     [31:0] res_b_36;
wire     [31:0] res_b_37;
wire     [31:0] res_b_38;
wire     [31:0] res_b_39;
wire     [31:0] res_b_40;
wire     [31:0] res_b_41;
wire     [31:0] res_b_42;
wire     [31:0] res_b_43;
wire     [31:0] res_b_44;
wire     [31:0] res_b_45;
wire     [31:0] res_b_46;
wire     [31:0] res_b_47;
wire     [31:0] res_b_48;
wire     [31:0] res_b_49;
wire     [31:0] res_b_50;
wire     [31:0] res_b_51;
wire     [31:0] res_b_52;
wire     [31:0] res_b_53;
wire     [31:0] res_b_54;
wire     [31:0] res_b_55;
wire     [31:0] res_b_56;
wire     [31:0] res_b_57;
wire     [31:0] res_b_58;
wire     [31:0] res_b_59;
wire     [31:0] res_b_60;
wire     [31:0] res_b_61;
wire     [31:0] res_b_62;
wire     [31:0] res_b_63;
wire      [7:0] res_tag_0;
wire      [7:0] res_tag_1;
wire      [7:0] res_tag_10;
wire      [7:0] res_tag_11;
wire      [7:0] res_tag_12;
wire      [7:0] res_tag_13;
wire      [7:0] res_tag_14;
wire      [7:0] res_tag_15;
wire      [7:0] res_tag_16;
wire      [7:0] res_tag_17;
wire      [7:0] res_tag_18;
wire      [7:0] res_tag_19;
wire      [7:0] res_tag_2;
wire      [7:0] res_tag_20;
wire      [7:0] res_tag_21;
wire      [7:0] res_tag_22;
wire      [7:0] res_tag_23;
wire      [7:0] res_tag_24;
wire      [7:0] res_tag_25;
wire      [7:0] res_tag_26;
wire      [7:0] res_tag_27;
wire      [7:0] res_tag_28;
wire      [7:0] res_tag_29;
wire      [7:0] res_tag_3;
wire      [7:0] res_tag_30;
wire      [7:0] res_tag_31;
wire      [7:0] res_tag_32;
wire      [7:0] res_tag_33;
wire      [7:0] res_tag_34;
wire      [7:0] res_tag_35;
wire      [7:0] res_tag_36;
wire      [7:0] res_tag_37;
wire      [7:0] res_tag_38;
wire      [7:0] res_tag_39;
wire      [7:0] res_tag_4;
wire      [7:0] res_tag_40;
wire      [7:0] res_tag_41;
wire      [7:0] res_tag_42;
wire      [7:0] res_tag_43;
wire      [7:0] res_tag_44;
wire      [7:0] res_tag_45;
wire      [7:0] res_tag_46;
wire      [7:0] res_tag_47;
wire      [7:0] res_tag_48;
wire      [7:0] res_tag_49;
wire      [7:0] res_tag_5;
wire      [7:0] res_tag_50;
wire      [7:0] res_tag_51;
wire      [7:0] res_tag_52;
wire      [7:0] res_tag_53;
wire      [7:0] res_tag_54;
wire      [7:0] res_tag_55;
wire      [7:0] res_tag_56;
wire      [7:0] res_tag_57;
wire      [7:0] res_tag_58;
wire      [7:0] res_tag_59;
wire      [7:0] res_tag_6;
wire      [7:0] res_tag_60;
wire      [7:0] res_tag_61;
wire      [7:0] res_tag_62;
wire      [7:0] res_tag_63;
wire      [7:0] res_tag_7;
wire      [7:0] res_tag_8;
wire      [7:0] res_tag_9;
wire     [63:0] res_tag_b0;
wire      [2:0] res_tag_b0_sum_0;
wire      [2:0] res_tag_b0_sum_1;
wire      [2:0] res_tag_b0_sum_10;
wire      [2:0] res_tag_b0_sum_11;
wire      [2:0] res_tag_b0_sum_12;
wire      [2:0] res_tag_b0_sum_13;
wire      [2:0] res_tag_b0_sum_14;
wire      [2:0] res_tag_b0_sum_15;
wire      [2:0] res_tag_b0_sum_2;
wire      [2:0] res_tag_b0_sum_3;
wire      [2:0] res_tag_b0_sum_4;
wire      [2:0] res_tag_b0_sum_5;
wire      [2:0] res_tag_b0_sum_6;
wire      [2:0] res_tag_b0_sum_7;
wire      [2:0] res_tag_b0_sum_8;
wire      [2:0] res_tag_b0_sum_9;
wire     [63:0] res_tag_b1;
wire      [2:0] res_tag_b1_sum_0;
wire      [2:0] res_tag_b1_sum_1;
wire      [2:0] res_tag_b1_sum_10;
wire      [2:0] res_tag_b1_sum_11;
wire      [2:0] res_tag_b1_sum_12;
wire      [2:0] res_tag_b1_sum_13;
wire      [2:0] res_tag_b1_sum_14;
wire      [2:0] res_tag_b1_sum_15;
wire      [2:0] res_tag_b1_sum_2;
wire      [2:0] res_tag_b1_sum_3;
wire      [2:0] res_tag_b1_sum_4;
wire      [2:0] res_tag_b1_sum_5;
wire      [2:0] res_tag_b1_sum_6;
wire      [2:0] res_tag_b1_sum_7;
wire      [2:0] res_tag_b1_sum_8;
wire      [2:0] res_tag_b1_sum_9;
wire     [63:0] res_tag_b2;
wire      [2:0] res_tag_b2_sum_0;
wire      [2:0] res_tag_b2_sum_1;
wire      [2:0] res_tag_b2_sum_10;
wire      [2:0] res_tag_b2_sum_11;
wire      [2:0] res_tag_b2_sum_12;
wire      [2:0] res_tag_b2_sum_13;
wire      [2:0] res_tag_b2_sum_14;
wire      [2:0] res_tag_b2_sum_15;
wire      [2:0] res_tag_b2_sum_2;
wire      [2:0] res_tag_b2_sum_3;
wire      [2:0] res_tag_b2_sum_4;
wire      [2:0] res_tag_b2_sum_5;
wire      [2:0] res_tag_b2_sum_6;
wire      [2:0] res_tag_b2_sum_7;
wire      [2:0] res_tag_b2_sum_8;
wire      [2:0] res_tag_b2_sum_9;
wire     [63:0] res_tag_b3;
wire      [2:0] res_tag_b3_sum_0;
wire      [2:0] res_tag_b3_sum_1;
wire      [2:0] res_tag_b3_sum_10;
wire      [2:0] res_tag_b3_sum_11;
wire      [2:0] res_tag_b3_sum_12;
wire      [2:0] res_tag_b3_sum_13;
wire      [2:0] res_tag_b3_sum_14;
wire      [2:0] res_tag_b3_sum_15;
wire      [2:0] res_tag_b3_sum_2;
wire      [2:0] res_tag_b3_sum_3;
wire      [2:0] res_tag_b3_sum_4;
wire      [2:0] res_tag_b3_sum_5;
wire      [2:0] res_tag_b3_sum_6;
wire      [2:0] res_tag_b3_sum_7;
wire      [2:0] res_tag_b3_sum_8;
wire      [2:0] res_tag_b3_sum_9;
wire     [63:0] res_tag_b4;
wire      [2:0] res_tag_b4_sum_0;
wire      [2:0] res_tag_b4_sum_1;
wire      [2:0] res_tag_b4_sum_10;
wire      [2:0] res_tag_b4_sum_11;
wire      [2:0] res_tag_b4_sum_12;
wire      [2:0] res_tag_b4_sum_13;
wire      [2:0] res_tag_b4_sum_14;
wire      [2:0] res_tag_b4_sum_15;
wire      [2:0] res_tag_b4_sum_2;
wire      [2:0] res_tag_b4_sum_3;
wire      [2:0] res_tag_b4_sum_4;
wire      [2:0] res_tag_b4_sum_5;
wire      [2:0] res_tag_b4_sum_6;
wire      [2:0] res_tag_b4_sum_7;
wire      [2:0] res_tag_b4_sum_8;
wire      [2:0] res_tag_b4_sum_9;
wire     [63:0] res_tag_b5;
wire      [2:0] res_tag_b5_sum_0;
wire      [2:0] res_tag_b5_sum_1;
wire      [2:0] res_tag_b5_sum_10;
wire      [2:0] res_tag_b5_sum_11;
wire      [2:0] res_tag_b5_sum_12;
wire      [2:0] res_tag_b5_sum_13;
wire      [2:0] res_tag_b5_sum_14;
wire      [2:0] res_tag_b5_sum_15;
wire      [2:0] res_tag_b5_sum_2;
wire      [2:0] res_tag_b5_sum_3;
wire      [2:0] res_tag_b5_sum_4;
wire      [2:0] res_tag_b5_sum_5;
wire      [2:0] res_tag_b5_sum_6;
wire      [2:0] res_tag_b5_sum_7;
wire      [2:0] res_tag_b5_sum_8;
wire      [2:0] res_tag_b5_sum_9;
wire     [63:0] res_tag_b6;
wire      [2:0] res_tag_b6_sum_0;
wire      [2:0] res_tag_b6_sum_1;
wire      [2:0] res_tag_b6_sum_10;
wire      [2:0] res_tag_b6_sum_11;
wire      [2:0] res_tag_b6_sum_12;
wire      [2:0] res_tag_b6_sum_13;
wire      [2:0] res_tag_b6_sum_14;
wire      [2:0] res_tag_b6_sum_15;
wire      [2:0] res_tag_b6_sum_2;
wire      [2:0] res_tag_b6_sum_3;
wire      [2:0] res_tag_b6_sum_4;
wire      [2:0] res_tag_b6_sum_5;
wire      [2:0] res_tag_b6_sum_6;
wire      [2:0] res_tag_b6_sum_7;
wire      [2:0] res_tag_b6_sum_8;
wire      [2:0] res_tag_b6_sum_9;
wire     [63:0] res_tag_b7;
wire      [2:0] res_tag_b7_sum_0;
wire      [2:0] res_tag_b7_sum_1;
wire      [2:0] res_tag_b7_sum_10;
wire      [2:0] res_tag_b7_sum_11;
wire      [2:0] res_tag_b7_sum_12;
wire      [2:0] res_tag_b7_sum_13;
wire      [2:0] res_tag_b7_sum_14;
wire      [2:0] res_tag_b7_sum_15;
wire      [2:0] res_tag_b7_sum_2;
wire      [2:0] res_tag_b7_sum_3;
wire      [2:0] res_tag_b7_sum_4;
wire      [2:0] res_tag_b7_sum_5;
wire      [2:0] res_tag_b7_sum_6;
wire      [2:0] res_tag_b7_sum_7;
wire      [2:0] res_tag_b7_sum_8;
wire      [2:0] res_tag_b7_sum_9;
reg       [8:0] cfg_is_fp16_d0;
reg       [8:0] cfg_is_fp16_d1;
reg       [8:0] cfg_is_fp16_d2;
reg       [7:0] cfg_is_fp16_d3;
reg             cfg_is_int16_d0;
reg             cfg_is_int16_d1;
reg             cfg_is_int16_d2;
reg       [0:0] cfg_is_int16_d3;
reg      [64:0] cfg_is_int8_d0;
reg      [12:0] cfg_is_int8_d1;
reg      [10:0] cfg_is_int8_d2;
reg       [7:0] cfg_is_int8_d3;
reg             cfg_is_wg_d0;
reg      [28:0] cfg_is_wg_d1;
reg       [8:0] cfg_is_wg_d2;
reg       [6:0] cfg_is_wg_d3;
reg             cfg_reg_en_d0;
reg             cfg_reg_en_d1;
reg             cfg_reg_en_d2;
reg      [15:0] dat_actv_data0;
reg      [15:0] dat_actv_data1;
reg      [15:0] dat_actv_data10;
reg      [15:0] dat_actv_data11;
reg      [15:0] dat_actv_data12;
reg      [15:0] dat_actv_data13;
reg      [15:0] dat_actv_data14;
reg      [15:0] dat_actv_data15;
reg      [15:0] dat_actv_data16;
reg      [15:0] dat_actv_data17;
reg      [15:0] dat_actv_data18;
reg      [15:0] dat_actv_data19;
reg      [15:0] dat_actv_data2;
reg      [15:0] dat_actv_data20;
reg      [15:0] dat_actv_data21;
reg      [15:0] dat_actv_data22;
reg      [15:0] dat_actv_data23;
reg      [15:0] dat_actv_data24;
reg      [15:0] dat_actv_data25;
reg      [15:0] dat_actv_data26;
reg      [15:0] dat_actv_data27;
reg      [15:0] dat_actv_data28;
reg      [15:0] dat_actv_data29;
reg      [15:0] dat_actv_data3;
reg      [15:0] dat_actv_data30;
reg      [15:0] dat_actv_data31;
reg      [15:0] dat_actv_data32;
reg      [15:0] dat_actv_data33;
reg      [15:0] dat_actv_data34;
reg      [15:0] dat_actv_data35;
reg      [15:0] dat_actv_data36;
reg      [15:0] dat_actv_data37;
reg      [15:0] dat_actv_data38;
reg      [15:0] dat_actv_data39;
reg      [15:0] dat_actv_data4;
reg      [15:0] dat_actv_data40;
reg      [15:0] dat_actv_data41;
reg      [15:0] dat_actv_data42;
reg      [15:0] dat_actv_data43;
reg      [15:0] dat_actv_data44;
reg      [15:0] dat_actv_data45;
reg      [15:0] dat_actv_data46;
reg      [15:0] dat_actv_data47;
reg      [15:0] dat_actv_data48;
reg      [15:0] dat_actv_data49;
reg      [15:0] dat_actv_data5;
reg      [15:0] dat_actv_data50;
reg      [15:0] dat_actv_data51;
reg      [15:0] dat_actv_data52;
reg      [15:0] dat_actv_data53;
reg      [15:0] dat_actv_data54;
reg      [15:0] dat_actv_data55;
reg      [15:0] dat_actv_data56;
reg      [15:0] dat_actv_data57;
reg      [15:0] dat_actv_data58;
reg      [15:0] dat_actv_data59;
reg      [15:0] dat_actv_data6;
reg      [15:0] dat_actv_data60;
reg      [15:0] dat_actv_data61;
reg      [15:0] dat_actv_data62;
reg      [15:0] dat_actv_data63;
reg      [15:0] dat_actv_data7;
reg      [15:0] dat_actv_data8;
reg      [15:0] dat_actv_data9;
reg       [1:0] dat_actv_nz0;
reg       [1:0] dat_actv_nz1;
reg       [1:0] dat_actv_nz10;
reg       [1:0] dat_actv_nz11;
reg       [1:0] dat_actv_nz12;
reg       [1:0] dat_actv_nz13;
reg       [1:0] dat_actv_nz14;
reg       [1:0] dat_actv_nz15;
reg       [1:0] dat_actv_nz16;
reg       [1:0] dat_actv_nz17;
reg       [1:0] dat_actv_nz18;
reg       [1:0] dat_actv_nz19;
reg       [1:0] dat_actv_nz2;
reg       [1:0] dat_actv_nz20;
reg       [1:0] dat_actv_nz21;
reg       [1:0] dat_actv_nz22;
reg       [1:0] dat_actv_nz23;
reg       [1:0] dat_actv_nz24;
reg       [1:0] dat_actv_nz25;
reg       [1:0] dat_actv_nz26;
reg       [1:0] dat_actv_nz27;
reg       [1:0] dat_actv_nz28;
reg       [1:0] dat_actv_nz29;
reg       [1:0] dat_actv_nz3;
reg       [1:0] dat_actv_nz30;
reg       [1:0] dat_actv_nz31;
reg       [1:0] dat_actv_nz32;
reg       [1:0] dat_actv_nz33;
reg       [1:0] dat_actv_nz34;
reg       [1:0] dat_actv_nz35;
reg       [1:0] dat_actv_nz36;
reg       [1:0] dat_actv_nz37;
reg       [1:0] dat_actv_nz38;
reg       [1:0] dat_actv_nz39;
reg       [1:0] dat_actv_nz4;
reg       [1:0] dat_actv_nz40;
reg       [1:0] dat_actv_nz41;
reg       [1:0] dat_actv_nz42;
reg       [1:0] dat_actv_nz43;
reg       [1:0] dat_actv_nz44;
reg       [1:0] dat_actv_nz45;
reg       [1:0] dat_actv_nz46;
reg       [1:0] dat_actv_nz47;
reg       [1:0] dat_actv_nz48;
reg       [1:0] dat_actv_nz49;
reg       [1:0] dat_actv_nz5;
reg       [1:0] dat_actv_nz50;
reg       [1:0] dat_actv_nz51;
reg       [1:0] dat_actv_nz52;
reg       [1:0] dat_actv_nz53;
reg       [1:0] dat_actv_nz54;
reg       [1:0] dat_actv_nz55;
reg       [1:0] dat_actv_nz56;
reg       [1:0] dat_actv_nz57;
reg       [1:0] dat_actv_nz58;
reg       [1:0] dat_actv_nz59;
reg       [1:0] dat_actv_nz6;
reg       [1:0] dat_actv_nz60;
reg       [1:0] dat_actv_nz61;
reg       [1:0] dat_actv_nz62;
reg       [1:0] dat_actv_nz63;
reg       [1:0] dat_actv_nz7;
reg       [1:0] dat_actv_nz8;
reg       [1:0] dat_actv_nz9;
reg     [175:0] mac_out_data;
reg       [3:0] mac_out_data_reg_en;
reg     [175:0] mac_out_data_w;
reg             mac_out_nan;
reg             mac_out_pvld;
reg      [41:0] mask2_4;
reg      [41:0] mask2_5;
reg      [41:0] mask2_6;
reg      [41:0] mask2_7;
reg      [45:0] mask4_2;
reg      [45:0] mask4_3;
reg      [45:0] mask4_4;
reg      [45:0] mask4_5;
reg      [45:0] mask4_6;
reg      [45:0] mask4_7;
reg       [3:0] pp_exp_d1;
reg       [3:0] pp_exp_d2;
reg       [3:0] pp_exp_d3;
reg             pp_exp_pvld_d1;
reg             pp_exp_pvld_d2;
reg      [35:0] pp_in_l0_a_00;
reg      [35:0] pp_in_l0_a_01;
reg      [35:0] pp_in_l0_a_02;
reg      [35:0] pp_in_l0_a_03;
reg      [35:0] pp_in_l0_a_04;
reg      [35:0] pp_in_l0_a_05;
reg      [35:0] pp_in_l0_a_06;
reg      [35:0] pp_in_l0_a_07;
reg      [35:0] pp_in_l0_a_08;
reg      [35:0] pp_in_l0_a_09;
reg      [35:0] pp_in_l0_a_10;
reg      [35:0] pp_in_l0_a_11;
reg      [35:0] pp_in_l0_a_12;
reg      [35:0] pp_in_l0_a_13;
reg      [35:0] pp_in_l0_a_14;
reg      [35:0] pp_in_l0_a_15;
reg      [35:0] pp_in_l0_a_16;
reg      [35:0] pp_in_l0_a_17;
reg      [35:0] pp_in_l0_a_18;
reg      [35:0] pp_in_l0_a_19;
reg      [35:0] pp_in_l0_a_20;
reg      [35:0] pp_in_l0_a_21;
reg      [35:0] pp_in_l0_a_22;
reg      [35:0] pp_in_l0_a_23;
reg      [35:0] pp_in_l0_a_24;
reg      [35:0] pp_in_l0_a_25;
reg      [35:0] pp_in_l0_a_26;
reg      [35:0] pp_in_l0_a_27;
reg      [35:0] pp_in_l0_a_28;
reg      [35:0] pp_in_l0_a_29;
reg      [35:0] pp_in_l0_a_30;
reg      [35:0] pp_in_l0_a_31;
reg      [35:0] pp_in_l0_a_32;
reg      [35:0] pp_in_l0_a_33;
reg      [35:0] pp_in_l0_a_34;
reg      [35:0] pp_in_l0_a_35;
reg      [35:0] pp_in_l0_a_36;
reg      [35:0] pp_in_l0_a_37;
reg      [35:0] pp_in_l0_a_38;
reg      [35:0] pp_in_l0_a_39;
reg      [35:0] pp_in_l0_a_40;
reg      [35:0] pp_in_l0_a_41;
reg      [35:0] pp_in_l0_a_42;
reg      [35:0] pp_in_l0_a_43;
reg      [35:0] pp_in_l0_a_44;
reg      [35:0] pp_in_l0_a_45;
reg      [35:0] pp_in_l0_a_46;
reg      [35:0] pp_in_l0_a_47;
reg      [35:0] pp_in_l0_a_48;
reg      [35:0] pp_in_l0_a_49;
reg      [35:0] pp_in_l0_a_50;
reg      [35:0] pp_in_l0_a_51;
reg      [35:0] pp_in_l0_a_52;
reg      [35:0] pp_in_l0_a_53;
reg      [35:0] pp_in_l0_a_54;
reg      [35:0] pp_in_l0_a_55;
reg      [35:0] pp_in_l0_a_56;
reg      [35:0] pp_in_l0_a_57;
reg      [35:0] pp_in_l0_a_58;
reg      [35:0] pp_in_l0_a_59;
reg      [35:0] pp_in_l0_a_60;
reg      [35:0] pp_in_l0_a_61;
reg      [35:0] pp_in_l0_a_62;
reg      [35:0] pp_in_l0_a_63;
reg      [35:0] pp_in_l0_b_00;
reg      [35:0] pp_in_l0_b_01;
reg      [35:0] pp_in_l0_b_02;
reg      [35:0] pp_in_l0_b_03;
reg      [35:0] pp_in_l0_b_04;
reg      [35:0] pp_in_l0_b_05;
reg      [35:0] pp_in_l0_b_06;
reg      [35:0] pp_in_l0_b_07;
reg      [35:0] pp_in_l0_b_08;
reg      [35:0] pp_in_l0_b_09;
reg      [35:0] pp_in_l0_b_10;
reg      [35:0] pp_in_l0_b_11;
reg      [35:0] pp_in_l0_b_12;
reg      [35:0] pp_in_l0_b_13;
reg      [35:0] pp_in_l0_b_14;
reg      [35:0] pp_in_l0_b_15;
reg      [35:0] pp_in_l0_b_16;
reg      [35:0] pp_in_l0_b_17;
reg      [35:0] pp_in_l0_b_18;
reg      [35:0] pp_in_l0_b_19;
reg      [35:0] pp_in_l0_b_20;
reg      [35:0] pp_in_l0_b_21;
reg      [35:0] pp_in_l0_b_22;
reg      [35:0] pp_in_l0_b_23;
reg      [35:0] pp_in_l0_b_24;
reg      [35:0] pp_in_l0_b_25;
reg      [35:0] pp_in_l0_b_26;
reg      [35:0] pp_in_l0_b_27;
reg      [35:0] pp_in_l0_b_28;
reg      [35:0] pp_in_l0_b_29;
reg      [35:0] pp_in_l0_b_30;
reg      [35:0] pp_in_l0_b_31;
reg      [35:0] pp_in_l0_b_32;
reg      [35:0] pp_in_l0_b_33;
reg      [35:0] pp_in_l0_b_34;
reg      [35:0] pp_in_l0_b_35;
reg      [35:0] pp_in_l0_b_36;
reg      [35:0] pp_in_l0_b_37;
reg      [35:0] pp_in_l0_b_38;
reg      [35:0] pp_in_l0_b_39;
reg      [35:0] pp_in_l0_b_40;
reg      [35:0] pp_in_l0_b_41;
reg      [35:0] pp_in_l0_b_42;
reg      [35:0] pp_in_l0_b_43;
reg      [35:0] pp_in_l0_b_44;
reg      [35:0] pp_in_l0_b_45;
reg      [35:0] pp_in_l0_b_46;
reg      [35:0] pp_in_l0_b_47;
reg      [35:0] pp_in_l0_b_48;
reg      [35:0] pp_in_l0_b_49;
reg      [35:0] pp_in_l0_b_50;
reg      [35:0] pp_in_l0_b_51;
reg      [35:0] pp_in_l0_b_52;
reg      [35:0] pp_in_l0_b_53;
reg      [35:0] pp_in_l0_b_54;
reg      [35:0] pp_in_l0_b_55;
reg      [35:0] pp_in_l0_b_56;
reg      [35:0] pp_in_l0_b_57;
reg      [35:0] pp_in_l0_b_58;
reg      [35:0] pp_in_l0_b_59;
reg      [35:0] pp_in_l0_b_60;
reg      [35:0] pp_in_l0_b_61;
reg      [35:0] pp_in_l0_b_62;
reg      [35:0] pp_in_l0_b_63;
reg     [287:0] pp_in_l0n00;
reg     [287:0] pp_in_l0n01;
reg     [287:0] pp_in_l0n02;
reg     [287:0] pp_in_l0n03;
reg     [287:0] pp_in_l0n04;
reg     [287:0] pp_in_l0n05;
reg     [287:0] pp_in_l0n06;
reg     [287:0] pp_in_l0n07;
reg     [287:0] pp_in_l0n08;
reg     [287:0] pp_in_l0n09;
reg     [287:0] pp_in_l0n10;
reg     [287:0] pp_in_l0n11;
reg     [287:0] pp_in_l0n12;
reg     [287:0] pp_in_l0n13;
reg     [287:0] pp_in_l0n14;
reg     [287:0] pp_in_l0n15;
reg     [167:0] pp_in_l1n0;
reg      [41:0] pp_in_l1n0_0;
reg      [41:0] pp_in_l1n0_1;
reg      [41:0] pp_in_l1n0_2;
reg      [41:0] pp_in_l1n0_3;
reg     [167:0] pp_in_l1n1;
reg      [41:0] pp_in_l1n1_0;
reg      [41:0] pp_in_l1n1_1;
reg      [41:0] pp_in_l1n1_2;
reg      [41:0] pp_in_l1n1_3;
reg     [167:0] pp_in_l1n2;
reg      [41:0] pp_in_l1n2_0;
reg      [41:0] pp_in_l1n2_1;
reg      [41:0] pp_in_l1n2_2;
reg      [41:0] pp_in_l1n2_3;
reg     [167:0] pp_in_l1n3;
reg      [41:0] pp_in_l1n3_0;
reg      [41:0] pp_in_l1n3_1;
reg      [41:0] pp_in_l1n3_2;
reg      [41:0] pp_in_l1n3_3;
reg     [167:0] pp_in_l1n4;
reg      [41:0] pp_in_l1n4_0;
reg      [41:0] pp_in_l1n4_1;
reg      [41:0] pp_in_l1n4_2;
reg      [41:0] pp_in_l1n4_3;
reg     [167:0] pp_in_l1n5;
reg      [41:0] pp_in_l1n5_0;
reg      [41:0] pp_in_l1n5_1;
reg      [41:0] pp_in_l1n5_2;
reg      [41:0] pp_in_l1n5_3;
reg     [167:0] pp_in_l1n6;
reg      [41:0] pp_in_l1n6_0;
reg      [41:0] pp_in_l1n6_1;
reg      [41:0] pp_in_l1n6_2;
reg      [41:0] pp_in_l1n6_3;
reg     [167:0] pp_in_l1n7;
reg      [41:0] pp_in_l1n7_0;
reg      [41:0] pp_in_l1n7_1;
reg      [41:0] pp_in_l1n7_2;
reg      [41:0] pp_in_l1n7_3;
reg     [167:0] pp_in_l2n0;
reg      [41:0] pp_in_l2n0_0;
reg      [41:0] pp_in_l2n0_1;
reg      [41:0] pp_in_l2n0_2;
reg      [41:0] pp_in_l2n0_3;
reg     [167:0] pp_in_l2n1;
reg      [41:0] pp_in_l2n1_0;
reg      [41:0] pp_in_l2n1_1;
reg      [41:0] pp_in_l2n1_2;
reg      [41:0] pp_in_l2n1_3;
reg     [167:0] pp_in_l2n2;
reg      [41:0] pp_in_l2n2_0;
reg      [41:0] pp_in_l2n2_1;
reg      [41:0] pp_in_l2n2_2;
reg      [41:0] pp_in_l2n2_3;
reg     [167:0] pp_in_l2n3;
reg      [41:0] pp_in_l2n3_0;
reg      [41:0] pp_in_l2n3_1;
reg      [41:0] pp_in_l2n3_2;
reg      [41:0] pp_in_l2n3_3;
reg     [167:0] pp_in_l2n4;
reg      [41:0] pp_in_l2n4_0;
reg      [41:0] pp_in_l2n4_1;
reg      [41:0] pp_in_l2n4_2;
reg      [41:0] pp_in_l2n4_3;
reg     [167:0] pp_in_l2n5;
reg      [41:0] pp_in_l2n5_0;
reg      [41:0] pp_in_l2n5_1;
reg      [41:0] pp_in_l2n5_2;
reg      [41:0] pp_in_l2n5_3;
reg     [167:0] pp_in_l2n6;
reg      [41:0] pp_in_l2n6_0;
reg      [41:0] pp_in_l2n6_1;
reg      [41:0] pp_in_l2n6_2;
reg      [41:0] pp_in_l2n6_3;
reg     [167:0] pp_in_l2n7;
reg      [41:0] pp_in_l2n7_0;
reg      [41:0] pp_in_l2n7_1;
reg      [41:0] pp_in_l2n7_2;
reg      [41:0] pp_in_l2n7_3;
reg     [183:0] pp_in_l3n0;
reg      [45:0] pp_in_l3n0_0;
reg      [45:0] pp_in_l3n0_1;
reg      [45:0] pp_in_l3n0_2;
reg      [45:0] pp_in_l3n0_3;
reg     [183:0] pp_in_l3n1;
reg      [45:0] pp_in_l3n1_0;
reg      [45:0] pp_in_l3n1_1;
reg      [45:0] pp_in_l3n1_2;
reg      [45:0] pp_in_l3n1_3;
reg     [183:0] pp_in_l3n2;
reg      [45:0] pp_in_l3n2_0;
reg      [45:0] pp_in_l3n2_1;
reg      [45:0] pp_in_l3n2_2;
reg      [45:0] pp_in_l3n2_3;
reg     [183:0] pp_in_l3n3;
reg      [45:0] pp_in_l3n3_0;
reg      [45:0] pp_in_l3n3_1;
reg      [45:0] pp_in_l3n3_2;
reg      [45:0] pp_in_l3n3_3;
reg     [275:0] pp_in_l4n0;
reg      [45:0] pp_in_l4n0_0;
reg      [45:0] pp_in_l4n0_1;
reg      [45:0] pp_in_l4n0_2;
reg      [45:0] pp_in_l4n0_3;
reg      [45:0] pp_in_l4n0_4;
reg      [45:0] pp_in_l4n0_5;
reg     [275:0] pp_in_l4n1;
reg      [45:0] pp_in_l4n1_0;
reg      [45:0] pp_in_l4n1_1;
reg      [45:0] pp_in_l4n1_2;
reg      [45:0] pp_in_l4n1_3;
reg      [45:0] pp_in_l4n1_4;
reg      [45:0] pp_in_l4n1_5;
reg     [275:0] pp_in_l4n2;
reg      [45:0] pp_in_l4n2_0;
reg      [45:0] pp_in_l4n2_1;
reg      [45:0] pp_in_l4n2_2;
reg      [45:0] pp_in_l4n2_3;
reg      [45:0] pp_in_l4n2_4;
reg      [45:0] pp_in_l4n2_5;
reg     [275:0] pp_in_l4n3;
reg      [45:0] pp_in_l4n3_0;
reg      [45:0] pp_in_l4n3_1;
reg      [45:0] pp_in_l4n3_2;
reg      [45:0] pp_in_l4n3_3;
reg      [45:0] pp_in_l4n3_4;
reg      [45:0] pp_in_l4n3_5;
reg      [10:0] pp_nan_mts_d1;
reg      [10:0] pp_nan_mts_d2;
reg      [10:0] pp_nan_mts_d3;
reg      [16:0] pp_nan_pvld_d1;
reg       [4:0] pp_nan_pvld_d2;
reg             pp_nan_pvld_d3;
reg      [35:0] pp_out_l0n00_0_d1;
reg      [35:0] pp_out_l0n00_0_d1_w;
reg      [35:0] pp_out_l0n00_1_d1;
reg      [35:0] pp_out_l0n00_1_d1_w;
reg      [35:0] pp_out_l0n01_0_d1;
reg      [35:0] pp_out_l0n01_0_d1_w;
reg      [35:0] pp_out_l0n01_1_d1;
reg      [35:0] pp_out_l0n01_1_d1_w;
reg      [35:0] pp_out_l0n02_0_d1;
reg      [35:0] pp_out_l0n02_0_d1_w;
reg      [35:0] pp_out_l0n02_1_d1;
reg      [35:0] pp_out_l0n02_1_d1_w;
reg      [35:0] pp_out_l0n03_0_d1;
reg      [35:0] pp_out_l0n03_0_d1_w;
reg      [35:0] pp_out_l0n03_1_d1;
reg      [35:0] pp_out_l0n03_1_d1_w;
reg      [35:0] pp_out_l0n04_0_d1;
reg      [35:0] pp_out_l0n04_0_d1_w;
reg      [35:0] pp_out_l0n04_1_d1;
reg      [35:0] pp_out_l0n04_1_d1_w;
reg      [35:0] pp_out_l0n05_0_d1;
reg      [35:0] pp_out_l0n05_0_d1_w;
reg      [35:0] pp_out_l0n05_1_d1;
reg      [35:0] pp_out_l0n05_1_d1_w;
reg      [35:0] pp_out_l0n06_0_d1;
reg      [35:0] pp_out_l0n06_0_d1_w;
reg      [35:0] pp_out_l0n06_1_d1;
reg      [35:0] pp_out_l0n06_1_d1_w;
reg      [35:0] pp_out_l0n07_0_d1;
reg      [35:0] pp_out_l0n07_0_d1_w;
reg      [35:0] pp_out_l0n07_1_d1;
reg      [35:0] pp_out_l0n07_1_d1_w;
reg      [35:0] pp_out_l0n08_0_d1;
reg      [35:0] pp_out_l0n08_0_d1_w;
reg      [35:0] pp_out_l0n08_1_d1;
reg      [35:0] pp_out_l0n08_1_d1_w;
reg      [35:0] pp_out_l0n09_0_d1;
reg      [35:0] pp_out_l0n09_0_d1_w;
reg      [35:0] pp_out_l0n09_1_d1;
reg      [35:0] pp_out_l0n09_1_d1_w;
reg      [35:0] pp_out_l0n10_0_d1;
reg      [35:0] pp_out_l0n10_0_d1_w;
reg      [35:0] pp_out_l0n10_1_d1;
reg      [35:0] pp_out_l0n10_1_d1_w;
reg      [35:0] pp_out_l0n11_0_d1;
reg      [35:0] pp_out_l0n11_0_d1_w;
reg      [35:0] pp_out_l0n11_1_d1;
reg      [35:0] pp_out_l0n11_1_d1_w;
reg      [35:0] pp_out_l0n12_0_d1;
reg      [35:0] pp_out_l0n12_0_d1_w;
reg      [35:0] pp_out_l0n12_1_d1;
reg      [35:0] pp_out_l0n12_1_d1_w;
reg      [35:0] pp_out_l0n13_0_d1;
reg      [35:0] pp_out_l0n13_0_d1_w;
reg      [35:0] pp_out_l0n13_1_d1;
reg      [35:0] pp_out_l0n13_1_d1_w;
reg      [35:0] pp_out_l0n14_0_d1;
reg      [35:0] pp_out_l0n14_0_d1_w;
reg      [35:0] pp_out_l0n14_1_d1;
reg      [35:0] pp_out_l0n14_1_d1_w;
reg      [35:0] pp_out_l0n15_0_d1;
reg      [35:0] pp_out_l0n15_0_d1_w;
reg      [35:0] pp_out_l0n15_1_d1;
reg      [35:0] pp_out_l0n15_1_d1_w;
reg      [41:0] pp_out_l2n0_0_d2;
reg      [41:0] pp_out_l2n0_1_d2;
reg      [41:0] pp_out_l2n1_0_d2;
reg      [41:0] pp_out_l2n1_1_d2;
reg      [41:0] pp_out_l2n2_0_d2;
reg      [41:0] pp_out_l2n2_1_d2;
reg      [41:0] pp_out_l2n3_0_d2;
reg      [41:0] pp_out_l2n3_1_d2;
reg      [41:0] pp_out_l2n4_0_d2;
reg      [41:0] pp_out_l2n4_1_d2;
reg      [41:0] pp_out_l2n5_0_d2;
reg      [41:0] pp_out_l2n5_1_d2;
reg      [41:0] pp_out_l2n6_0_d2;
reg      [41:0] pp_out_l2n6_1_d2;
reg      [41:0] pp_out_l2n7_0_d2;
reg      [41:0] pp_out_l2n7_1_d2;
reg      [45:0] pp_out_l4n0_0_d3;
reg      [45:0] pp_out_l4n0_0_d3_w;
reg      [45:0] pp_out_l4n0_1_d3;
reg      [45:0] pp_out_l4n0_1_d3_w;
reg      [45:0] pp_out_l4n1_0_d3;
reg      [45:0] pp_out_l4n1_0_d3_w;
reg      [45:0] pp_out_l4n1_1_d3;
reg      [45:0] pp_out_l4n1_1_d3_w;
reg      [45:0] pp_out_l4n2_0_d3;
reg      [45:0] pp_out_l4n2_0_d3_w;
reg      [45:0] pp_out_l4n2_1_d3;
reg      [45:0] pp_out_l4n2_1_d3_w;
reg      [45:0] pp_out_l4n3_0_d3;
reg      [45:0] pp_out_l4n3_0_d3_w;
reg      [45:0] pp_out_l4n3_1_d3;
reg      [45:0] pp_out_l4n3_1_d3_w;
reg      [16:0] pp_pvld_d1;
reg       [4:0] pp_pvld_d2;
reg       [1:0] pp_pvld_d3;
reg      [45:0] pp_sign_patch_0;
reg      [45:0] pp_sign_patch_1;
reg      [45:0] pp_sign_patch_2;
reg      [45:0] pp_sign_patch_3;
reg       [6:0] ps_n0b0_d2;
reg       [6:0] ps_n0b1_d2;
reg       [6:0] ps_n0b2_d2;
reg       [6:0] ps_n0b3_d2;
reg       [6:0] ps_n0b4_d2;
reg       [6:0] ps_n0b5_d2;
reg       [6:0] ps_n0b6_d2;
reg       [6:0] ps_n0b7_d2;
reg       [6:0] ps_n1b0_d2;
reg       [6:0] ps_n1b1_d2;
reg       [6:0] ps_n1b2_d2;
reg       [6:0] ps_n1b3_d2;
reg       [6:0] ps_n1b4_d2;
reg       [6:0] ps_n1b5_d2;
reg       [6:0] ps_n1b6_d2;
reg       [6:0] ps_n1b7_d2;
reg       [6:0] ps_n2b0_d2;
reg       [6:0] ps_n2b1_d2;
reg       [6:0] ps_n2b2_d2;
reg       [6:0] ps_n2b3_d2;
reg       [6:0] ps_n2b4_d2;
reg       [6:0] ps_n2b5_d2;
reg       [6:0] ps_n2b6_d2;
reg       [6:0] ps_n2b7_d2;
reg       [6:0] ps_n3b0_d2;
reg       [6:0] ps_n3b1_d2;
reg       [6:0] ps_n3b2_d2;
reg       [6:0] ps_n3b3_d2;
reg       [6:0] ps_n3b4_d2;
reg       [6:0] ps_n3b5_d2;
reg       [6:0] ps_n3b6_d2;
reg       [6:0] ps_n3b7_d2;
reg      [63:0] res_tag_b0_d1;
reg      [63:0] res_tag_b1_d1;
reg      [63:0] res_tag_b2_d1;
reg      [63:0] res_tag_b3_d1;
reg      [63:0] res_tag_b4_d1;
reg      [63:0] res_tag_b5_d1;
reg      [63:0] res_tag_b6_d1;
reg      [63:0] res_tag_b7_d1;
reg      [47:0] sop_0;
reg      [47:0] sop_1;
reg      [47:0] sop_2;
reg      [47:0] sop_3;
reg       [5:0] sop_exp;
reg      [43:0] sop_nan;
reg      [15:0] wt_actv_data0;
reg      [15:0] wt_actv_data1;
reg      [15:0] wt_actv_data10;
reg      [15:0] wt_actv_data11;
reg      [15:0] wt_actv_data12;
reg      [15:0] wt_actv_data13;
reg      [15:0] wt_actv_data14;
reg      [15:0] wt_actv_data15;
reg      [15:0] wt_actv_data16;
reg      [15:0] wt_actv_data17;
reg      [15:0] wt_actv_data18;
reg      [15:0] wt_actv_data19;
reg      [15:0] wt_actv_data2;
reg      [15:0] wt_actv_data20;
reg      [15:0] wt_actv_data21;
reg      [15:0] wt_actv_data22;
reg      [15:0] wt_actv_data23;
reg      [15:0] wt_actv_data24;
reg      [15:0] wt_actv_data25;
reg      [15:0] wt_actv_data26;
reg      [15:0] wt_actv_data27;
reg      [15:0] wt_actv_data28;
reg      [15:0] wt_actv_data29;
reg      [15:0] wt_actv_data3;
reg      [15:0] wt_actv_data30;
reg      [15:0] wt_actv_data31;
reg      [15:0] wt_actv_data32;
reg      [15:0] wt_actv_data33;
reg      [15:0] wt_actv_data34;
reg      [15:0] wt_actv_data35;
reg      [15:0] wt_actv_data36;
reg      [15:0] wt_actv_data37;
reg      [15:0] wt_actv_data38;
reg      [15:0] wt_actv_data39;
reg      [15:0] wt_actv_data4;
reg      [15:0] wt_actv_data40;
reg      [15:0] wt_actv_data41;
reg      [15:0] wt_actv_data42;
reg      [15:0] wt_actv_data43;
reg      [15:0] wt_actv_data44;
reg      [15:0] wt_actv_data45;
reg      [15:0] wt_actv_data46;
reg      [15:0] wt_actv_data47;
reg      [15:0] wt_actv_data48;
reg      [15:0] wt_actv_data49;
reg      [15:0] wt_actv_data5;
reg      [15:0] wt_actv_data50;
reg      [15:0] wt_actv_data51;
reg      [15:0] wt_actv_data52;
reg      [15:0] wt_actv_data53;
reg      [15:0] wt_actv_data54;
reg      [15:0] wt_actv_data55;
reg      [15:0] wt_actv_data56;
reg      [15:0] wt_actv_data57;
reg      [15:0] wt_actv_data58;
reg      [15:0] wt_actv_data59;
reg      [15:0] wt_actv_data6;
reg      [15:0] wt_actv_data60;
reg      [15:0] wt_actv_data61;
reg      [15:0] wt_actv_data62;
reg      [15:0] wt_actv_data63;
reg      [15:0] wt_actv_data7;
reg      [15:0] wt_actv_data8;
reg      [15:0] wt_actv_data9;
reg       [1:0] wt_actv_nz0;
reg       [1:0] wt_actv_nz1;
reg       [1:0] wt_actv_nz10;
reg       [1:0] wt_actv_nz11;
reg       [1:0] wt_actv_nz12;
reg       [1:0] wt_actv_nz13;
reg       [1:0] wt_actv_nz14;
reg       [1:0] wt_actv_nz15;
reg       [1:0] wt_actv_nz16;
reg       [1:0] wt_actv_nz17;
reg       [1:0] wt_actv_nz18;
reg       [1:0] wt_actv_nz19;
reg       [1:0] wt_actv_nz2;
reg       [1:0] wt_actv_nz20;
reg       [1:0] wt_actv_nz21;
reg       [1:0] wt_actv_nz22;
reg       [1:0] wt_actv_nz23;
reg       [1:0] wt_actv_nz24;
reg       [1:0] wt_actv_nz25;
reg       [1:0] wt_actv_nz26;
reg       [1:0] wt_actv_nz27;
reg       [1:0] wt_actv_nz28;
reg       [1:0] wt_actv_nz29;
reg       [1:0] wt_actv_nz3;
reg       [1:0] wt_actv_nz30;
reg       [1:0] wt_actv_nz31;
reg       [1:0] wt_actv_nz32;
reg       [1:0] wt_actv_nz33;
reg       [1:0] wt_actv_nz34;
reg       [1:0] wt_actv_nz35;
reg       [1:0] wt_actv_nz36;
reg       [1:0] wt_actv_nz37;
reg       [1:0] wt_actv_nz38;
reg       [1:0] wt_actv_nz39;
reg       [1:0] wt_actv_nz4;
reg       [1:0] wt_actv_nz40;
reg       [1:0] wt_actv_nz41;
reg       [1:0] wt_actv_nz42;
reg       [1:0] wt_actv_nz43;
reg       [1:0] wt_actv_nz44;
reg       [1:0] wt_actv_nz45;
reg       [1:0] wt_actv_nz46;
reg       [1:0] wt_actv_nz47;
reg       [1:0] wt_actv_nz48;
reg       [1:0] wt_actv_nz49;
reg       [1:0] wt_actv_nz5;
reg       [1:0] wt_actv_nz50;
reg       [1:0] wt_actv_nz51;
reg       [1:0] wt_actv_nz52;
reg       [1:0] wt_actv_nz53;
reg       [1:0] wt_actv_nz54;
reg       [1:0] wt_actv_nz55;
reg       [1:0] wt_actv_nz56;
reg       [1:0] wt_actv_nz57;
reg       [1:0] wt_actv_nz58;
reg       [1:0] wt_actv_nz59;
reg       [1:0] wt_actv_nz6;
reg       [1:0] wt_actv_nz60;
reg       [1:0] wt_actv_nz61;
reg       [1:0] wt_actv_nz62;
reg       [1:0] wt_actv_nz63;
reg       [1:0] wt_actv_nz7;
reg       [1:0] wt_actv_nz8;
reg       [1:0] wt_actv_nz9;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==============================================================================
// MAC support Winograd post addition (POA).
// It's a 2-level matrix muliplication implemented by adders.
// Fomular of POA are:
//
//                    | pp_out_00, pp_out_01, pp_out_02, pp_out_03 |  | 1   0 |
// | 1,  1,  1,  0 |  | pp_out_04, pp_out_05, pp_out_06, pp_out_07 |  | 1,  1 |
// | 0,  1, -1, -1 |  | pp_out_08, pp_out_09, pp_out_10, pp_out_11 |  | 1, -1 |
//                    | pp_out_12, pp_out_13, pp_out_14, pp_out_15 |  | 0, -1 |
//
//==============================================================================


//==========================================================
// Config logic
//==========================================================

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_reg_en_d0 <= 1'b0;
  end else begin
  cfg_reg_en_d0 <= cfg_reg_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_int8_d0 <= {65{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_is_int8_d0 <= {65{cfg_is_int8}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_is_int8_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_fp16_d0 <= {9{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_is_fp16_d0 <= {9{cfg_is_fp16}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_is_fp16_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_int16_d0 <= 1'b0;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_is_int16_d0 <= cfg_is_int16;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_is_int16_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_wg_d0 <= 1'b0;
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_is_wg_d0 <= cfg_is_wg;
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_is_wg_d0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_reg_en_d1 <= 1'b0;
  end else begin
  cfg_reg_en_d1 <= cfg_reg_en_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_int8_d1 <= {13{1'b0}};
  end else begin
  if ((cfg_reg_en_d0) == 1'b1) begin
    cfg_is_int8_d1 <= {13{cfg_is_int8_d0[64]}};
  // VCS coverage off
  end else if ((cfg_reg_en_d0) == 1'b0) begin
  end else begin
    cfg_is_int8_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_fp16_d1 <= {9{1'b0}};
  end else begin
  if ((cfg_reg_en_d0) == 1'b1) begin
    cfg_is_fp16_d1 <= {9{cfg_is_fp16_d0[8]}};
  // VCS coverage off
  end else if ((cfg_reg_en_d0) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_int16_d1 <= 1'b0;
  end else begin
  if ((cfg_reg_en_d0) == 1'b1) begin
    cfg_is_int16_d1 <= cfg_is_int16_d0;
  // VCS coverage off
  end else if ((cfg_reg_en_d0) == 1'b0) begin
  end else begin
    cfg_is_int16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_wg_d1 <= {29{1'b0}};
  end else begin
  if ((cfg_reg_en_d0) == 1'b1) begin
    cfg_is_wg_d1 <= {29{cfg_is_wg_d0}};
  // VCS coverage off
  end else if ((cfg_reg_en_d0) == 1'b0) begin
  end else begin
    cfg_is_wg_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_reg_en_d2 <= 1'b0;
  end else begin
  cfg_reg_en_d2 <= cfg_reg_en_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_int8_d2 <= {11{1'b0}};
  end else begin
  if ((cfg_reg_en_d1) == 1'b1) begin
    cfg_is_int8_d2 <= {11{cfg_is_int8_d1[12]}};
  // VCS coverage off
  end else if ((cfg_reg_en_d1) == 1'b0) begin
  end else begin
    cfg_is_int8_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_fp16_d2 <= {9{1'b0}};
  end else begin
  if ((cfg_reg_en_d1) == 1'b1) begin
    cfg_is_fp16_d2 <= {9{cfg_is_fp16_d1[8]}};
  // VCS coverage off
  end else if ((cfg_reg_en_d1) == 1'b0) begin
  end else begin
    cfg_is_fp16_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_int16_d2 <= 1'b0;
  end else begin
  if ((cfg_reg_en_d1) == 1'b1) begin
    cfg_is_int16_d2 <= cfg_is_int16_d1;
  // VCS coverage off
  end else if ((cfg_reg_en_d1) == 1'b0) begin
  end else begin
    cfg_is_int16_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_wg_d2 <= {9{1'b0}};
  end else begin
  if ((cfg_reg_en_d1) == 1'b1) begin
    cfg_is_wg_d2 <= {9{cfg_is_wg_d1[28]}};
  // VCS coverage off
  end else if ((cfg_reg_en_d1) == 1'b0) begin
  end else begin
    cfg_is_wg_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_int8_d3 <= {8{1'b0}};
  end else begin
  if ((cfg_reg_en_d2) == 1'b1) begin
    cfg_is_int8_d3 <= {8{cfg_is_int8_d2[10]}};
  // VCS coverage off
  end else if ((cfg_reg_en_d2) == 1'b0) begin
  end else begin
    cfg_is_int8_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_fp16_d3 <= {8{1'b0}};
  end else begin
  if ((cfg_reg_en_d2) == 1'b1) begin
    cfg_is_fp16_d3 <= {8{cfg_is_fp16_d2[8]}};
  // VCS coverage off
  end else if ((cfg_reg_en_d2) == 1'b0) begin
  end else begin
    cfg_is_fp16_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_int16_d3 <= 1'b0;
  end else begin
  if ((cfg_reg_en_d2) == 1'b1) begin
    cfg_is_int16_d3 <= cfg_is_int16_d2;
  // VCS coverage off
  end else if ((cfg_reg_en_d2) == 1'b0) begin
  end else begin
    cfg_is_int16_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    cfg_is_wg_d3 <= {7{1'b0}};
  end else begin
  if ((cfg_reg_en_d2) == 1'b1) begin
    cfg_is_wg_d3 <= {7{cfg_is_wg_d2[8]}};
  // VCS coverage off
  end else if ((cfg_reg_en_d2) == 1'b0) begin
  end else begin
    cfg_is_wg_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// Sub unit to handle fp16 NaN 
//==========================================================

NV_NVDLA_CMAC_CORE_MAC_nan u_nan (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.dat_actv_data      (dat_actv_data[1023:0]) //|< i
  ,.dat_actv_nan       (dat_actv_nan[63:0])    //|< i
  ,.wt_actv_data       (wt_actv_data[1023:0])  //|< i
  ,.wt_actv_nan        (wt_actv_nan[63:0])     //|< i
  ,.out_nan_mts        (out_nan_mts[10:0])     //|> w
  ,.out_nan_pvld       (out_nan_pvld)          //|> w
  );

//==========================================================
// Fp16 exponent pre-calculaiton instant
//==========================================================

NV_NVDLA_CMAC_CORE_MAC_exp u_exp (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.dat_pre_exp        (dat_pre_exp[191:0])    //|< i
  ,.dat_pre_mask       (dat_pre_mask[63:0])    //|< i
  ,.dat_pre_pvld       (dat_pre_pvld)          //|< i
  ,.dat_pre_stripe_end (dat_pre_stripe_end)    //|< i
  ,.dat_pre_stripe_st  (dat_pre_stripe_st)     //|< i
  ,.wt_sd_exp          (wt_sd_exp[191:0])      //|< i
  ,.wt_sd_mask         (wt_sd_mask[63:0])      //|< i
  ,.wt_sd_pvld         (wt_sd_pvld)            //|< i
  ,.exp_max            (exp_max[3:0])          //|> w
  ,.exp_pvld           (exp_pvld)              //|> w
  ,.exp_sft_00         (exp_sft_00[3:0])       //|> w
  ,.exp_sft_01         (exp_sft_01[3:0])       //|> w
  ,.exp_sft_02         (exp_sft_02[3:0])       //|> w
  ,.exp_sft_03         (exp_sft_03[3:0])       //|> w
  ,.exp_sft_04         (exp_sft_04[3:0])       //|> w
  ,.exp_sft_05         (exp_sft_05[3:0])       //|> w
  ,.exp_sft_06         (exp_sft_06[3:0])       //|> w
  ,.exp_sft_07         (exp_sft_07[3:0])       //|> w
  ,.exp_sft_08         (exp_sft_08[3:0])       //|> w
  ,.exp_sft_09         (exp_sft_09[3:0])       //|> w
  ,.exp_sft_10         (exp_sft_10[3:0])       //|> w
  ,.exp_sft_11         (exp_sft_11[3:0])       //|> w
  ,.exp_sft_12         (exp_sft_12[3:0])       //|> w
  ,.exp_sft_13         (exp_sft_13[3:0])       //|> w
  ,.exp_sft_14         (exp_sft_14[3:0])       //|> w
  ,.exp_sft_15         (exp_sft_15[3:0])       //|> w
  ,.exp_sft_16         (exp_sft_16[3:0])       //|> w
  ,.exp_sft_17         (exp_sft_17[3:0])       //|> w
  ,.exp_sft_18         (exp_sft_18[3:0])       //|> w
  ,.exp_sft_19         (exp_sft_19[3:0])       //|> w
  ,.exp_sft_20         (exp_sft_20[3:0])       //|> w
  ,.exp_sft_21         (exp_sft_21[3:0])       //|> w
  ,.exp_sft_22         (exp_sft_22[3:0])       //|> w
  ,.exp_sft_23         (exp_sft_23[3:0])       //|> w
  ,.exp_sft_24         (exp_sft_24[3:0])       //|> w
  ,.exp_sft_25         (exp_sft_25[3:0])       //|> w
  ,.exp_sft_26         (exp_sft_26[3:0])       //|> w
  ,.exp_sft_27         (exp_sft_27[3:0])       //|> w
  ,.exp_sft_28         (exp_sft_28[3:0])       //|> w
  ,.exp_sft_29         (exp_sft_29[3:0])       //|> w
  ,.exp_sft_30         (exp_sft_30[3:0])       //|> w
  ,.exp_sft_31         (exp_sft_31[3:0])       //|> w
  ,.exp_sft_32         (exp_sft_32[3:0])       //|> w
  ,.exp_sft_33         (exp_sft_33[3:0])       //|> w
  ,.exp_sft_34         (exp_sft_34[3:0])       //|> w
  ,.exp_sft_35         (exp_sft_35[3:0])       //|> w
  ,.exp_sft_36         (exp_sft_36[3:0])       //|> w
  ,.exp_sft_37         (exp_sft_37[3:0])       //|> w
  ,.exp_sft_38         (exp_sft_38[3:0])       //|> w
  ,.exp_sft_39         (exp_sft_39[3:0])       //|> w
  ,.exp_sft_40         (exp_sft_40[3:0])       //|> w
  ,.exp_sft_41         (exp_sft_41[3:0])       //|> w
  ,.exp_sft_42         (exp_sft_42[3:0])       //|> w
  ,.exp_sft_43         (exp_sft_43[3:0])       //|> w
  ,.exp_sft_44         (exp_sft_44[3:0])       //|> w
  ,.exp_sft_45         (exp_sft_45[3:0])       //|> w
  ,.exp_sft_46         (exp_sft_46[3:0])       //|> w
  ,.exp_sft_47         (exp_sft_47[3:0])       //|> w
  ,.exp_sft_48         (exp_sft_48[3:0])       //|> w
  ,.exp_sft_49         (exp_sft_49[3:0])       //|> w
  ,.exp_sft_50         (exp_sft_50[3:0])       //|> w
  ,.exp_sft_51         (exp_sft_51[3:0])       //|> w
  ,.exp_sft_52         (exp_sft_52[3:0])       //|> w
  ,.exp_sft_53         (exp_sft_53[3:0])       //|> w
  ,.exp_sft_54         (exp_sft_54[3:0])       //|> w
  ,.exp_sft_55         (exp_sft_55[3:0])       //|> w
  ,.exp_sft_56         (exp_sft_56[3:0])       //|> w
  ,.exp_sft_57         (exp_sft_57[3:0])       //|> w
  ,.exp_sft_58         (exp_sft_58[3:0])       //|> w
  ,.exp_sft_59         (exp_sft_59[3:0])       //|> w
  ,.exp_sft_60         (exp_sft_60[3:0])       //|> w
  ,.exp_sft_61         (exp_sft_61[3:0])       //|> w
  ,.exp_sft_62         (exp_sft_62[3:0])       //|> w
  ,.exp_sft_63         (exp_sft_63[3:0])       //|> w
  );

//==========================================================
// Single multiplication instances
//==========================================================


always @(
  wt_actv_data
  ) begin
    {wt_actv_data63, wt_actv_data62, wt_actv_data61, wt_actv_data60, wt_actv_data59, wt_actv_data58, wt_actv_data57, wt_actv_data56, wt_actv_data55, wt_actv_data54, wt_actv_data53, wt_actv_data52, wt_actv_data51, wt_actv_data50, wt_actv_data49, wt_actv_data48, wt_actv_data47, wt_actv_data46, wt_actv_data45, wt_actv_data44, wt_actv_data43, wt_actv_data42, wt_actv_data41, wt_actv_data40, wt_actv_data39, wt_actv_data38, wt_actv_data37, wt_actv_data36, wt_actv_data35, wt_actv_data34, wt_actv_data33, wt_actv_data32, wt_actv_data31, wt_actv_data30, wt_actv_data29, wt_actv_data28, wt_actv_data27, wt_actv_data26, wt_actv_data25, wt_actv_data24, wt_actv_data23, wt_actv_data22, wt_actv_data21, wt_actv_data20, wt_actv_data19, wt_actv_data18, wt_actv_data17, wt_actv_data16, wt_actv_data15, wt_actv_data14, wt_actv_data13, wt_actv_data12, wt_actv_data11, wt_actv_data10, wt_actv_data9, wt_actv_data8, wt_actv_data7, wt_actv_data6, wt_actv_data5, wt_actv_data4, wt_actv_data3, wt_actv_data2, wt_actv_data1, wt_actv_data0} = wt_actv_data;
end

always @(
  dat_actv_data
  ) begin
    {dat_actv_data63, dat_actv_data62, dat_actv_data61, dat_actv_data60, dat_actv_data59, dat_actv_data58, dat_actv_data57, dat_actv_data56, dat_actv_data55, dat_actv_data54, dat_actv_data53, dat_actv_data52, dat_actv_data51, dat_actv_data50, dat_actv_data49, dat_actv_data48, dat_actv_data47, dat_actv_data46, dat_actv_data45, dat_actv_data44, dat_actv_data43, dat_actv_data42, dat_actv_data41, dat_actv_data40, dat_actv_data39, dat_actv_data38, dat_actv_data37, dat_actv_data36, dat_actv_data35, dat_actv_data34, dat_actv_data33, dat_actv_data32, dat_actv_data31, dat_actv_data30, dat_actv_data29, dat_actv_data28, dat_actv_data27, dat_actv_data26, dat_actv_data25, dat_actv_data24, dat_actv_data23, dat_actv_data22, dat_actv_data21, dat_actv_data20, dat_actv_data19, dat_actv_data18, dat_actv_data17, dat_actv_data16, dat_actv_data15, dat_actv_data14, dat_actv_data13, dat_actv_data12, dat_actv_data11, dat_actv_data10, dat_actv_data9, dat_actv_data8, dat_actv_data7, dat_actv_data6, dat_actv_data5, dat_actv_data4, dat_actv_data3, dat_actv_data2, dat_actv_data1, dat_actv_data0} = dat_actv_data;
end

always @(
  wt_actv_nz
  ) begin
    {wt_actv_nz63, wt_actv_nz62, wt_actv_nz61, wt_actv_nz60, wt_actv_nz59, wt_actv_nz58, wt_actv_nz57, wt_actv_nz56, wt_actv_nz55, wt_actv_nz54, wt_actv_nz53, wt_actv_nz52, wt_actv_nz51, wt_actv_nz50, wt_actv_nz49, wt_actv_nz48, wt_actv_nz47, wt_actv_nz46, wt_actv_nz45, wt_actv_nz44, wt_actv_nz43, wt_actv_nz42, wt_actv_nz41, wt_actv_nz40, wt_actv_nz39, wt_actv_nz38, wt_actv_nz37, wt_actv_nz36, wt_actv_nz35, wt_actv_nz34, wt_actv_nz33, wt_actv_nz32, wt_actv_nz31, wt_actv_nz30, wt_actv_nz29, wt_actv_nz28, wt_actv_nz27, wt_actv_nz26, wt_actv_nz25, wt_actv_nz24, wt_actv_nz23, wt_actv_nz22, wt_actv_nz21, wt_actv_nz20, wt_actv_nz19, wt_actv_nz18, wt_actv_nz17, wt_actv_nz16, wt_actv_nz15, wt_actv_nz14, wt_actv_nz13, wt_actv_nz12, wt_actv_nz11, wt_actv_nz10, wt_actv_nz9, wt_actv_nz8, wt_actv_nz7, wt_actv_nz6, wt_actv_nz5, wt_actv_nz4, wt_actv_nz3, wt_actv_nz2, wt_actv_nz1, wt_actv_nz0} = wt_actv_nz;
end

always @(
  dat_actv_nz
  ) begin
    {dat_actv_nz63, dat_actv_nz62, dat_actv_nz61, dat_actv_nz60, dat_actv_nz59, dat_actv_nz58, dat_actv_nz57, dat_actv_nz56, dat_actv_nz55, dat_actv_nz54, dat_actv_nz53, dat_actv_nz52, dat_actv_nz51, dat_actv_nz50, dat_actv_nz49, dat_actv_nz48, dat_actv_nz47, dat_actv_nz46, dat_actv_nz45, dat_actv_nz44, dat_actv_nz43, dat_actv_nz42, dat_actv_nz41, dat_actv_nz40, dat_actv_nz39, dat_actv_nz38, dat_actv_nz37, dat_actv_nz36, dat_actv_nz35, dat_actv_nz34, dat_actv_nz33, dat_actv_nz32, dat_actv_nz31, dat_actv_nz30, dat_actv_nz29, dat_actv_nz28, dat_actv_nz27, dat_actv_nz26, dat_actv_nz25, dat_actv_nz24, dat_actv_nz23, dat_actv_nz22, dat_actv_nz21, dat_actv_nz20, dat_actv_nz19, dat_actv_nz18, dat_actv_nz17, dat_actv_nz16, dat_actv_nz15, dat_actv_nz14, dat_actv_nz13, dat_actv_nz12, dat_actv_nz11, dat_actv_nz10, dat_actv_nz9, dat_actv_nz8, dat_actv_nz7, dat_actv_nz6, dat_actv_nz5, dat_actv_nz4, dat_actv_nz3, dat_actv_nz2, dat_actv_nz1, dat_actv_nz0} = dat_actv_nz;
end


NV_NVDLA_CMAC_CORE_MAC_mul u_mul_0 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_00[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data0[15:0])   //|< r
  ,.op_a_nz            (wt_actv_nz0[1:0])      //|< r
  ,.op_a_pvld          (wt_actv_pvld[0])       //|< i
  ,.op_b_dat           (dat_actv_data0[15:0])  //|< r
  ,.op_b_nz            (dat_actv_nz0[1:0])     //|< r
  ,.op_b_pvld          (dat_actv_pvld[0])      //|< i
  ,.res_a              (res_a_00[31:0])        //|> w
  ,.res_b              (res_b_00[31:0])        //|> w
  ,.res_tag            (res_tag_0[7:0])        //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_1 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_01[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data1[15:0])   //|< r
  ,.op_a_nz            (wt_actv_nz1[1:0])      //|< r
  ,.op_a_pvld          (wt_actv_pvld[1])       //|< i
  ,.op_b_dat           (dat_actv_data1[15:0])  //|< r
  ,.op_b_nz            (dat_actv_nz1[1:0])     //|< r
  ,.op_b_pvld          (dat_actv_pvld[1])      //|< i
  ,.res_a              (res_a_01[31:0])        //|> w
  ,.res_b              (res_b_01[31:0])        //|> w
  ,.res_tag            (res_tag_1[7:0])        //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_2 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_02[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data2[15:0])   //|< r
  ,.op_a_nz            (wt_actv_nz2[1:0])      //|< r
  ,.op_a_pvld          (wt_actv_pvld[2])       //|< i
  ,.op_b_dat           (dat_actv_data2[15:0])  //|< r
  ,.op_b_nz            (dat_actv_nz2[1:0])     //|< r
  ,.op_b_pvld          (dat_actv_pvld[2])      //|< i
  ,.res_a              (res_a_02[31:0])        //|> w
  ,.res_b              (res_b_02[31:0])        //|> w
  ,.res_tag            (res_tag_2[7:0])        //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_3 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_03[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data3[15:0])   //|< r
  ,.op_a_nz            (wt_actv_nz3[1:0])      //|< r
  ,.op_a_pvld          (wt_actv_pvld[3])       //|< i
  ,.op_b_dat           (dat_actv_data3[15:0])  //|< r
  ,.op_b_nz            (dat_actv_nz3[1:0])     //|< r
  ,.op_b_pvld          (dat_actv_pvld[3])      //|< i
  ,.res_a              (res_a_03[31:0])        //|> w
  ,.res_b              (res_b_03[31:0])        //|> w
  ,.res_tag            (res_tag_3[7:0])        //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_4 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_04[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data4[15:0])   //|< r
  ,.op_a_nz            (wt_actv_nz4[1:0])      //|< r
  ,.op_a_pvld          (wt_actv_pvld[4])       //|< i
  ,.op_b_dat           (dat_actv_data4[15:0])  //|< r
  ,.op_b_nz            (dat_actv_nz4[1:0])     //|< r
  ,.op_b_pvld          (dat_actv_pvld[4])      //|< i
  ,.res_a              (res_a_04[31:0])        //|> w
  ,.res_b              (res_b_04[31:0])        //|> w
  ,.res_tag            (res_tag_4[7:0])        //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_5 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_05[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data5[15:0])   //|< r
  ,.op_a_nz            (wt_actv_nz5[1:0])      //|< r
  ,.op_a_pvld          (wt_actv_pvld[5])       //|< i
  ,.op_b_dat           (dat_actv_data5[15:0])  //|< r
  ,.op_b_nz            (dat_actv_nz5[1:0])     //|< r
  ,.op_b_pvld          (dat_actv_pvld[5])      //|< i
  ,.res_a              (res_a_05[31:0])        //|> w
  ,.res_b              (res_b_05[31:0])        //|> w
  ,.res_tag            (res_tag_5[7:0])        //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_6 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_06[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data6[15:0])   //|< r
  ,.op_a_nz            (wt_actv_nz6[1:0])      //|< r
  ,.op_a_pvld          (wt_actv_pvld[6])       //|< i
  ,.op_b_dat           (dat_actv_data6[15:0])  //|< r
  ,.op_b_nz            (dat_actv_nz6[1:0])     //|< r
  ,.op_b_pvld          (dat_actv_pvld[6])      //|< i
  ,.res_a              (res_a_06[31:0])        //|> w
  ,.res_b              (res_b_06[31:0])        //|> w
  ,.res_tag            (res_tag_6[7:0])        //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_7 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_07[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data7[15:0])   //|< r
  ,.op_a_nz            (wt_actv_nz7[1:0])      //|< r
  ,.op_a_pvld          (wt_actv_pvld[7])       //|< i
  ,.op_b_dat           (dat_actv_data7[15:0])  //|< r
  ,.op_b_nz            (dat_actv_nz7[1:0])     //|< r
  ,.op_b_pvld          (dat_actv_pvld[7])      //|< i
  ,.res_a              (res_a_07[31:0])        //|> w
  ,.res_b              (res_b_07[31:0])        //|> w
  ,.res_tag            (res_tag_7[7:0])        //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_8 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_08[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data8[15:0])   //|< r
  ,.op_a_nz            (wt_actv_nz8[1:0])      //|< r
  ,.op_a_pvld          (wt_actv_pvld[8])       //|< i
  ,.op_b_dat           (dat_actv_data8[15:0])  //|< r
  ,.op_b_nz            (dat_actv_nz8[1:0])     //|< r
  ,.op_b_pvld          (dat_actv_pvld[8])      //|< i
  ,.res_a              (res_a_08[31:0])        //|> w
  ,.res_b              (res_b_08[31:0])        //|> w
  ,.res_tag            (res_tag_8[7:0])        //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_9 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_09[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data9[15:0])   //|< r
  ,.op_a_nz            (wt_actv_nz9[1:0])      //|< r
  ,.op_a_pvld          (wt_actv_pvld[9])       //|< i
  ,.op_b_dat           (dat_actv_data9[15:0])  //|< r
  ,.op_b_nz            (dat_actv_nz9[1:0])     //|< r
  ,.op_b_pvld          (dat_actv_pvld[9])      //|< i
  ,.res_a              (res_a_09[31:0])        //|> w
  ,.res_b              (res_b_09[31:0])        //|> w
  ,.res_tag            (res_tag_9[7:0])        //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_10 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_10[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data10[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz10[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[10])      //|< i
  ,.op_b_dat           (dat_actv_data10[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz10[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[10])     //|< i
  ,.res_a              (res_a_10[31:0])        //|> w
  ,.res_b              (res_b_10[31:0])        //|> w
  ,.res_tag            (res_tag_10[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_11 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_11[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data11[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz11[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[11])      //|< i
  ,.op_b_dat           (dat_actv_data11[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz11[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[11])     //|< i
  ,.res_a              (res_a_11[31:0])        //|> w
  ,.res_b              (res_b_11[31:0])        //|> w
  ,.res_tag            (res_tag_11[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_12 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_12[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data12[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz12[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[12])      //|< i
  ,.op_b_dat           (dat_actv_data12[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz12[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[12])     //|< i
  ,.res_a              (res_a_12[31:0])        //|> w
  ,.res_b              (res_b_12[31:0])        //|> w
  ,.res_tag            (res_tag_12[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_13 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_13[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data13[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz13[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[13])      //|< i
  ,.op_b_dat           (dat_actv_data13[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz13[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[13])     //|< i
  ,.res_a              (res_a_13[31:0])        //|> w
  ,.res_b              (res_b_13[31:0])        //|> w
  ,.res_tag            (res_tag_13[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_14 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_14[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data14[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz14[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[14])      //|< i
  ,.op_b_dat           (dat_actv_data14[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz14[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[14])     //|< i
  ,.res_a              (res_a_14[31:0])        //|> w
  ,.res_b              (res_b_14[31:0])        //|> w
  ,.res_tag            (res_tag_14[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_15 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_15[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data15[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz15[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[15])      //|< i
  ,.op_b_dat           (dat_actv_data15[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz15[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[15])     //|< i
  ,.res_a              (res_a_15[31:0])        //|> w
  ,.res_b              (res_b_15[31:0])        //|> w
  ,.res_tag            (res_tag_15[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_16 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_16[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data16[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz16[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[16])      //|< i
  ,.op_b_dat           (dat_actv_data16[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz16[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[16])     //|< i
  ,.res_a              (res_a_16[31:0])        //|> w
  ,.res_b              (res_b_16[31:0])        //|> w
  ,.res_tag            (res_tag_16[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_17 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_17[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data17[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz17[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[17])      //|< i
  ,.op_b_dat           (dat_actv_data17[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz17[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[17])     //|< i
  ,.res_a              (res_a_17[31:0])        //|> w
  ,.res_b              (res_b_17[31:0])        //|> w
  ,.res_tag            (res_tag_17[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_18 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_18[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data18[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz18[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[18])      //|< i
  ,.op_b_dat           (dat_actv_data18[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz18[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[18])     //|< i
  ,.res_a              (res_a_18[31:0])        //|> w
  ,.res_b              (res_b_18[31:0])        //|> w
  ,.res_tag            (res_tag_18[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_19 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_19[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data19[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz19[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[19])      //|< i
  ,.op_b_dat           (dat_actv_data19[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz19[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[19])     //|< i
  ,.res_a              (res_a_19[31:0])        //|> w
  ,.res_b              (res_b_19[31:0])        //|> w
  ,.res_tag            (res_tag_19[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_20 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_20[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data20[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz20[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[20])      //|< i
  ,.op_b_dat           (dat_actv_data20[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz20[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[20])     //|< i
  ,.res_a              (res_a_20[31:0])        //|> w
  ,.res_b              (res_b_20[31:0])        //|> w
  ,.res_tag            (res_tag_20[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_21 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_21[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data21[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz21[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[21])      //|< i
  ,.op_b_dat           (dat_actv_data21[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz21[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[21])     //|< i
  ,.res_a              (res_a_21[31:0])        //|> w
  ,.res_b              (res_b_21[31:0])        //|> w
  ,.res_tag            (res_tag_21[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_22 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_22[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data22[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz22[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[22])      //|< i
  ,.op_b_dat           (dat_actv_data22[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz22[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[22])     //|< i
  ,.res_a              (res_a_22[31:0])        //|> w
  ,.res_b              (res_b_22[31:0])        //|> w
  ,.res_tag            (res_tag_22[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_23 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_23[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data23[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz23[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[23])      //|< i
  ,.op_b_dat           (dat_actv_data23[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz23[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[23])     //|< i
  ,.res_a              (res_a_23[31:0])        //|> w
  ,.res_b              (res_b_23[31:0])        //|> w
  ,.res_tag            (res_tag_23[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_24 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_24[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data24[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz24[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[24])      //|< i
  ,.op_b_dat           (dat_actv_data24[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz24[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[24])     //|< i
  ,.res_a              (res_a_24[31:0])        //|> w
  ,.res_b              (res_b_24[31:0])        //|> w
  ,.res_tag            (res_tag_24[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_25 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_25[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data25[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz25[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[25])      //|< i
  ,.op_b_dat           (dat_actv_data25[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz25[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[25])     //|< i
  ,.res_a              (res_a_25[31:0])        //|> w
  ,.res_b              (res_b_25[31:0])        //|> w
  ,.res_tag            (res_tag_25[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_26 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_26[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data26[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz26[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[26])      //|< i
  ,.op_b_dat           (dat_actv_data26[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz26[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[26])     //|< i
  ,.res_a              (res_a_26[31:0])        //|> w
  ,.res_b              (res_b_26[31:0])        //|> w
  ,.res_tag            (res_tag_26[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_27 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_27[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data27[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz27[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[27])      //|< i
  ,.op_b_dat           (dat_actv_data27[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz27[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[27])     //|< i
  ,.res_a              (res_a_27[31:0])        //|> w
  ,.res_b              (res_b_27[31:0])        //|> w
  ,.res_tag            (res_tag_27[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_28 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_28[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data28[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz28[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[28])      //|< i
  ,.op_b_dat           (dat_actv_data28[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz28[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[28])     //|< i
  ,.res_a              (res_a_28[31:0])        //|> w
  ,.res_b              (res_b_28[31:0])        //|> w
  ,.res_tag            (res_tag_28[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_29 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_29[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data29[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz29[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[29])      //|< i
  ,.op_b_dat           (dat_actv_data29[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz29[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[29])     //|< i
  ,.res_a              (res_a_29[31:0])        //|> w
  ,.res_b              (res_b_29[31:0])        //|> w
  ,.res_tag            (res_tag_29[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_30 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_30[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data30[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz30[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[30])      //|< i
  ,.op_b_dat           (dat_actv_data30[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz30[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[30])     //|< i
  ,.res_a              (res_a_30[31:0])        //|> w
  ,.res_b              (res_b_30[31:0])        //|> w
  ,.res_tag            (res_tag_30[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_31 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_31[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data31[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz31[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[31])      //|< i
  ,.op_b_dat           (dat_actv_data31[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz31[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[31])     //|< i
  ,.res_a              (res_a_31[31:0])        //|> w
  ,.res_b              (res_b_31[31:0])        //|> w
  ,.res_tag            (res_tag_31[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_32 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_32[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data32[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz32[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[32])      //|< i
  ,.op_b_dat           (dat_actv_data32[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz32[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[32])     //|< i
  ,.res_a              (res_a_32[31:0])        //|> w
  ,.res_b              (res_b_32[31:0])        //|> w
  ,.res_tag            (res_tag_32[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_33 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_33[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data33[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz33[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[33])      //|< i
  ,.op_b_dat           (dat_actv_data33[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz33[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[33])     //|< i
  ,.res_a              (res_a_33[31:0])        //|> w
  ,.res_b              (res_b_33[31:0])        //|> w
  ,.res_tag            (res_tag_33[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_34 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_34[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data34[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz34[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[34])      //|< i
  ,.op_b_dat           (dat_actv_data34[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz34[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[34])     //|< i
  ,.res_a              (res_a_34[31:0])        //|> w
  ,.res_b              (res_b_34[31:0])        //|> w
  ,.res_tag            (res_tag_34[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_35 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_35[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data35[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz35[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[35])      //|< i
  ,.op_b_dat           (dat_actv_data35[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz35[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[35])     //|< i
  ,.res_a              (res_a_35[31:0])        //|> w
  ,.res_b              (res_b_35[31:0])        //|> w
  ,.res_tag            (res_tag_35[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_36 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_36[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data36[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz36[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[36])      //|< i
  ,.op_b_dat           (dat_actv_data36[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz36[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[36])     //|< i
  ,.res_a              (res_a_36[31:0])        //|> w
  ,.res_b              (res_b_36[31:0])        //|> w
  ,.res_tag            (res_tag_36[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_37 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_37[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data37[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz37[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[37])      //|< i
  ,.op_b_dat           (dat_actv_data37[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz37[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[37])     //|< i
  ,.res_a              (res_a_37[31:0])        //|> w
  ,.res_b              (res_b_37[31:0])        //|> w
  ,.res_tag            (res_tag_37[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_38 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_38[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data38[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz38[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[38])      //|< i
  ,.op_b_dat           (dat_actv_data38[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz38[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[38])     //|< i
  ,.res_a              (res_a_38[31:0])        //|> w
  ,.res_b              (res_b_38[31:0])        //|> w
  ,.res_tag            (res_tag_38[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_39 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_39[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data39[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz39[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[39])      //|< i
  ,.op_b_dat           (dat_actv_data39[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz39[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[39])     //|< i
  ,.res_a              (res_a_39[31:0])        //|> w
  ,.res_b              (res_b_39[31:0])        //|> w
  ,.res_tag            (res_tag_39[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_40 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_40[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data40[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz40[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[40])      //|< i
  ,.op_b_dat           (dat_actv_data40[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz40[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[40])     //|< i
  ,.res_a              (res_a_40[31:0])        //|> w
  ,.res_b              (res_b_40[31:0])        //|> w
  ,.res_tag            (res_tag_40[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_41 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_41[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data41[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz41[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[41])      //|< i
  ,.op_b_dat           (dat_actv_data41[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz41[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[41])     //|< i
  ,.res_a              (res_a_41[31:0])        //|> w
  ,.res_b              (res_b_41[31:0])        //|> w
  ,.res_tag            (res_tag_41[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_42 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_42[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data42[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz42[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[42])      //|< i
  ,.op_b_dat           (dat_actv_data42[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz42[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[42])     //|< i
  ,.res_a              (res_a_42[31:0])        //|> w
  ,.res_b              (res_b_42[31:0])        //|> w
  ,.res_tag            (res_tag_42[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_43 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_43[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data43[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz43[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[43])      //|< i
  ,.op_b_dat           (dat_actv_data43[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz43[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[43])     //|< i
  ,.res_a              (res_a_43[31:0])        //|> w
  ,.res_b              (res_b_43[31:0])        //|> w
  ,.res_tag            (res_tag_43[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_44 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_44[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data44[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz44[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[44])      //|< i
  ,.op_b_dat           (dat_actv_data44[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz44[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[44])     //|< i
  ,.res_a              (res_a_44[31:0])        //|> w
  ,.res_b              (res_b_44[31:0])        //|> w
  ,.res_tag            (res_tag_44[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_45 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_45[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data45[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz45[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[45])      //|< i
  ,.op_b_dat           (dat_actv_data45[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz45[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[45])     //|< i
  ,.res_a              (res_a_45[31:0])        //|> w
  ,.res_b              (res_b_45[31:0])        //|> w
  ,.res_tag            (res_tag_45[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_46 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_46[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data46[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz46[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[46])      //|< i
  ,.op_b_dat           (dat_actv_data46[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz46[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[46])     //|< i
  ,.res_a              (res_a_46[31:0])        //|> w
  ,.res_b              (res_b_46[31:0])        //|> w
  ,.res_tag            (res_tag_46[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_47 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_47[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data47[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz47[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[47])      //|< i
  ,.op_b_dat           (dat_actv_data47[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz47[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[47])     //|< i
  ,.res_a              (res_a_47[31:0])        //|> w
  ,.res_b              (res_b_47[31:0])        //|> w
  ,.res_tag            (res_tag_47[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_48 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_48[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data48[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz48[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[48])      //|< i
  ,.op_b_dat           (dat_actv_data48[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz48[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[48])     //|< i
  ,.res_a              (res_a_48[31:0])        //|> w
  ,.res_b              (res_b_48[31:0])        //|> w
  ,.res_tag            (res_tag_48[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_49 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_49[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data49[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz49[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[49])      //|< i
  ,.op_b_dat           (dat_actv_data49[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz49[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[49])     //|< i
  ,.res_a              (res_a_49[31:0])        //|> w
  ,.res_b              (res_b_49[31:0])        //|> w
  ,.res_tag            (res_tag_49[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_50 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_50[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data50[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz50[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[50])      //|< i
  ,.op_b_dat           (dat_actv_data50[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz50[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[50])     //|< i
  ,.res_a              (res_a_50[31:0])        //|> w
  ,.res_b              (res_b_50[31:0])        //|> w
  ,.res_tag            (res_tag_50[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_51 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_51[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data51[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz51[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[51])      //|< i
  ,.op_b_dat           (dat_actv_data51[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz51[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[51])     //|< i
  ,.res_a              (res_a_51[31:0])        //|> w
  ,.res_b              (res_b_51[31:0])        //|> w
  ,.res_tag            (res_tag_51[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_52 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_52[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data52[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz52[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[52])      //|< i
  ,.op_b_dat           (dat_actv_data52[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz52[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[52])     //|< i
  ,.res_a              (res_a_52[31:0])        //|> w
  ,.res_b              (res_b_52[31:0])        //|> w
  ,.res_tag            (res_tag_52[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_53 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_53[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data53[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz53[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[53])      //|< i
  ,.op_b_dat           (dat_actv_data53[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz53[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[53])     //|< i
  ,.res_a              (res_a_53[31:0])        //|> w
  ,.res_b              (res_b_53[31:0])        //|> w
  ,.res_tag            (res_tag_53[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_54 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_54[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data54[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz54[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[54])      //|< i
  ,.op_b_dat           (dat_actv_data54[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz54[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[54])     //|< i
  ,.res_a              (res_a_54[31:0])        //|> w
  ,.res_b              (res_b_54[31:0])        //|> w
  ,.res_tag            (res_tag_54[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_55 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_55[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data55[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz55[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[55])      //|< i
  ,.op_b_dat           (dat_actv_data55[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz55[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[55])     //|< i
  ,.res_a              (res_a_55[31:0])        //|> w
  ,.res_b              (res_b_55[31:0])        //|> w
  ,.res_tag            (res_tag_55[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_56 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_56[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data56[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz56[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[56])      //|< i
  ,.op_b_dat           (dat_actv_data56[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz56[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[56])     //|< i
  ,.res_a              (res_a_56[31:0])        //|> w
  ,.res_b              (res_b_56[31:0])        //|> w
  ,.res_tag            (res_tag_56[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_57 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_57[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data57[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz57[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[57])      //|< i
  ,.op_b_dat           (dat_actv_data57[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz57[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[57])     //|< i
  ,.res_a              (res_a_57[31:0])        //|> w
  ,.res_b              (res_b_57[31:0])        //|> w
  ,.res_tag            (res_tag_57[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_58 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_58[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data58[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz58[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[58])      //|< i
  ,.op_b_dat           (dat_actv_data58[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz58[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[58])     //|< i
  ,.res_a              (res_a_58[31:0])        //|> w
  ,.res_b              (res_b_58[31:0])        //|> w
  ,.res_tag            (res_tag_58[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_59 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_59[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data59[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz59[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[59])      //|< i
  ,.op_b_dat           (dat_actv_data59[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz59[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[59])     //|< i
  ,.res_a              (res_a_59[31:0])        //|> w
  ,.res_b              (res_b_59[31:0])        //|> w
  ,.res_tag            (res_tag_59[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_60 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_60[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data60[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz60[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[60])      //|< i
  ,.op_b_dat           (dat_actv_data60[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz60[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[60])     //|< i
  ,.res_a              (res_a_60[31:0])        //|> w
  ,.res_b              (res_b_60[31:0])        //|> w
  ,.res_tag            (res_tag_60[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_61 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_61[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data61[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz61[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[61])      //|< i
  ,.op_b_dat           (dat_actv_data61[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz61[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[61])     //|< i
  ,.res_a              (res_a_61[31:0])        //|> w
  ,.res_b              (res_b_61[31:0])        //|> w
  ,.res_tag            (res_tag_61[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_62 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_62[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data62[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz62[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[62])      //|< i
  ,.op_b_dat           (dat_actv_data62[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz62[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[62])     //|< i
  ,.res_a              (res_a_62[31:0])        //|> w
  ,.res_b              (res_b_62[31:0])        //|> w
  ,.res_tag            (res_tag_62[7:0])       //|> w
  );



NV_NVDLA_CMAC_CORE_MAC_mul u_mul_63 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.cfg_is_fp16        (cfg_is_fp16)           //|< i
  ,.cfg_is_int8        (cfg_is_int8)           //|< i
  ,.cfg_reg_en         (cfg_reg_en)            //|< i
  ,.exp_sft            (exp_sft_63[3:0])       //|< w
  ,.op_a_dat           (wt_actv_data63[15:0])  //|< r
  ,.op_a_nz            (wt_actv_nz63[1:0])     //|< r
  ,.op_a_pvld          (wt_actv_pvld[63])      //|< i
  ,.op_b_dat           (dat_actv_data63[15:0]) //|< r
  ,.op_b_nz            (dat_actv_nz63[1:0])    //|< r
  ,.op_b_pvld          (dat_actv_pvld[63])     //|< i
  ,.res_a              (res_a_63[31:0])        //|> w
  ,.res_b              (res_b_63[31:0])        //|> w
  ,.res_tag            (res_tag_63[7:0])       //|> w
  );



//==========================================================
// MAC cell CSA tree level 0
// 64(128) -> 16(32)
//==========================================================

///////////////////////////////////////////////////////////////////
//////////////// input select for CSA tree level 0 ////////////////
///////////////////////////////////////////////////////////////////

always @(
  cfg_is_int8_d0
  or res_a_00
  or res_b_00
  ) begin
    pp_in_l0_a_00 = cfg_is_int8_d0[0] ? {2'b0, res_a_00[31:16], 2'b0, res_a_00[15:0]} :
                    {4'b0, res_a_00[31:0]};
    pp_in_l0_b_00 = cfg_is_int8_d0[0] ? {2'b0, res_b_00[31:16], 2'b0, res_b_00[15:0]} :
                    {4'b0, res_b_00[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_01
  or res_b_01
  ) begin
    pp_in_l0_a_01 = cfg_is_int8_d0[1] ? {2'b0, res_a_01[31:16], 2'b0, res_a_01[15:0]} :
                    {4'b0, res_a_01[31:0]};
    pp_in_l0_b_01 = cfg_is_int8_d0[1] ? {2'b0, res_b_01[31:16], 2'b0, res_b_01[15:0]} :
                    {4'b0, res_b_01[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_02
  or res_b_02
  ) begin
    pp_in_l0_a_02 = cfg_is_int8_d0[2] ? {2'b0, res_a_02[31:16], 2'b0, res_a_02[15:0]} :
                    {4'b0, res_a_02[31:0]};
    pp_in_l0_b_02 = cfg_is_int8_d0[2] ? {2'b0, res_b_02[31:16], 2'b0, res_b_02[15:0]} :
                    {4'b0, res_b_02[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_03
  or res_b_03
  ) begin
    pp_in_l0_a_03 = cfg_is_int8_d0[3] ? {2'b0, res_a_03[31:16], 2'b0, res_a_03[15:0]} :
                    {4'b0, res_a_03[31:0]};
    pp_in_l0_b_03 = cfg_is_int8_d0[3] ? {2'b0, res_b_03[31:16], 2'b0, res_b_03[15:0]} :
                    {4'b0, res_b_03[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_04
  or res_b_04
  ) begin
    pp_in_l0_a_04 = cfg_is_int8_d0[4] ? {2'b0, res_a_04[31:16], 2'b0, res_a_04[15:0]} :
                    {4'b0, res_a_04[31:0]};
    pp_in_l0_b_04 = cfg_is_int8_d0[4] ? {2'b0, res_b_04[31:16], 2'b0, res_b_04[15:0]} :
                    {4'b0, res_b_04[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_05
  or res_b_05
  ) begin
    pp_in_l0_a_05 = cfg_is_int8_d0[5] ? {2'b0, res_a_05[31:16], 2'b0, res_a_05[15:0]} :
                    {4'b0, res_a_05[31:0]};
    pp_in_l0_b_05 = cfg_is_int8_d0[5] ? {2'b0, res_b_05[31:16], 2'b0, res_b_05[15:0]} :
                    {4'b0, res_b_05[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_06
  or res_b_06
  ) begin
    pp_in_l0_a_06 = cfg_is_int8_d0[6] ? {2'b0, res_a_06[31:16], 2'b0, res_a_06[15:0]} :
                    {4'b0, res_a_06[31:0]};
    pp_in_l0_b_06 = cfg_is_int8_d0[6] ? {2'b0, res_b_06[31:16], 2'b0, res_b_06[15:0]} :
                    {4'b0, res_b_06[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_07
  or res_b_07
  ) begin
    pp_in_l0_a_07 = cfg_is_int8_d0[7] ? {2'b0, res_a_07[31:16], 2'b0, res_a_07[15:0]} :
                    {4'b0, res_a_07[31:0]};
    pp_in_l0_b_07 = cfg_is_int8_d0[7] ? {2'b0, res_b_07[31:16], 2'b0, res_b_07[15:0]} :
                    {4'b0, res_b_07[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_08
  or res_b_08
  ) begin
    pp_in_l0_a_08 = cfg_is_int8_d0[8] ? {2'b0, res_a_08[31:16], 2'b0, res_a_08[15:0]} :
                    {4'b0, res_a_08[31:0]};
    pp_in_l0_b_08 = cfg_is_int8_d0[8] ? {2'b0, res_b_08[31:16], 2'b0, res_b_08[15:0]} :
                    {4'b0, res_b_08[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_09
  or res_b_09
  ) begin
    pp_in_l0_a_09 = cfg_is_int8_d0[9] ? {2'b0, res_a_09[31:16], 2'b0, res_a_09[15:0]} :
                    {4'b0, res_a_09[31:0]};
    pp_in_l0_b_09 = cfg_is_int8_d0[9] ? {2'b0, res_b_09[31:16], 2'b0, res_b_09[15:0]} :
                    {4'b0, res_b_09[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_10
  or res_b_10
  ) begin
    pp_in_l0_a_10 = cfg_is_int8_d0[10] ? {2'b0, res_a_10[31:16], 2'b0, res_a_10[15:0]} :
                    {4'b0, res_a_10[31:0]};
    pp_in_l0_b_10 = cfg_is_int8_d0[10] ? {2'b0, res_b_10[31:16], 2'b0, res_b_10[15:0]} :
                    {4'b0, res_b_10[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_11
  or res_b_11
  ) begin
    pp_in_l0_a_11 = cfg_is_int8_d0[11] ? {2'b0, res_a_11[31:16], 2'b0, res_a_11[15:0]} :
                    {4'b0, res_a_11[31:0]};
    pp_in_l0_b_11 = cfg_is_int8_d0[11] ? {2'b0, res_b_11[31:16], 2'b0, res_b_11[15:0]} :
                    {4'b0, res_b_11[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_12
  or res_b_12
  ) begin
    pp_in_l0_a_12 = cfg_is_int8_d0[12] ? {2'b0, res_a_12[31:16], 2'b0, res_a_12[15:0]} :
                    {4'b0, res_a_12[31:0]};
    pp_in_l0_b_12 = cfg_is_int8_d0[12] ? {2'b0, res_b_12[31:16], 2'b0, res_b_12[15:0]} :
                    {4'b0, res_b_12[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_13
  or res_b_13
  ) begin
    pp_in_l0_a_13 = cfg_is_int8_d0[13] ? {2'b0, res_a_13[31:16], 2'b0, res_a_13[15:0]} :
                    {4'b0, res_a_13[31:0]};
    pp_in_l0_b_13 = cfg_is_int8_d0[13] ? {2'b0, res_b_13[31:16], 2'b0, res_b_13[15:0]} :
                    {4'b0, res_b_13[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_14
  or res_b_14
  ) begin
    pp_in_l0_a_14 = cfg_is_int8_d0[14] ? {2'b0, res_a_14[31:16], 2'b0, res_a_14[15:0]} :
                    {4'b0, res_a_14[31:0]};
    pp_in_l0_b_14 = cfg_is_int8_d0[14] ? {2'b0, res_b_14[31:16], 2'b0, res_b_14[15:0]} :
                    {4'b0, res_b_14[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_15
  or res_b_15
  ) begin
    pp_in_l0_a_15 = cfg_is_int8_d0[15] ? {2'b0, res_a_15[31:16], 2'b0, res_a_15[15:0]} :
                    {4'b0, res_a_15[31:0]};
    pp_in_l0_b_15 = cfg_is_int8_d0[15] ? {2'b0, res_b_15[31:16], 2'b0, res_b_15[15:0]} :
                    {4'b0, res_b_15[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_16
  or res_b_16
  ) begin
    pp_in_l0_a_16 = cfg_is_int8_d0[16] ? {2'b0, res_a_16[31:16], 2'b0, res_a_16[15:0]} :
                    {4'b0, res_a_16[31:0]};
    pp_in_l0_b_16 = cfg_is_int8_d0[16] ? {2'b0, res_b_16[31:16], 2'b0, res_b_16[15:0]} :
                    {4'b0, res_b_16[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_17
  or res_b_17
  ) begin
    pp_in_l0_a_17 = cfg_is_int8_d0[17] ? {2'b0, res_a_17[31:16], 2'b0, res_a_17[15:0]} :
                    {4'b0, res_a_17[31:0]};
    pp_in_l0_b_17 = cfg_is_int8_d0[17] ? {2'b0, res_b_17[31:16], 2'b0, res_b_17[15:0]} :
                    {4'b0, res_b_17[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_18
  or res_b_18
  ) begin
    pp_in_l0_a_18 = cfg_is_int8_d0[18] ? {2'b0, res_a_18[31:16], 2'b0, res_a_18[15:0]} :
                    {4'b0, res_a_18[31:0]};
    pp_in_l0_b_18 = cfg_is_int8_d0[18] ? {2'b0, res_b_18[31:16], 2'b0, res_b_18[15:0]} :
                    {4'b0, res_b_18[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_19
  or res_b_19
  ) begin
    pp_in_l0_a_19 = cfg_is_int8_d0[19] ? {2'b0, res_a_19[31:16], 2'b0, res_a_19[15:0]} :
                    {4'b0, res_a_19[31:0]};
    pp_in_l0_b_19 = cfg_is_int8_d0[19] ? {2'b0, res_b_19[31:16], 2'b0, res_b_19[15:0]} :
                    {4'b0, res_b_19[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_20
  or res_b_20
  ) begin
    pp_in_l0_a_20 = cfg_is_int8_d0[20] ? {2'b0, res_a_20[31:16], 2'b0, res_a_20[15:0]} :
                    {4'b0, res_a_20[31:0]};
    pp_in_l0_b_20 = cfg_is_int8_d0[20] ? {2'b0, res_b_20[31:16], 2'b0, res_b_20[15:0]} :
                    {4'b0, res_b_20[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_21
  or res_b_21
  ) begin
    pp_in_l0_a_21 = cfg_is_int8_d0[21] ? {2'b0, res_a_21[31:16], 2'b0, res_a_21[15:0]} :
                    {4'b0, res_a_21[31:0]};
    pp_in_l0_b_21 = cfg_is_int8_d0[21] ? {2'b0, res_b_21[31:16], 2'b0, res_b_21[15:0]} :
                    {4'b0, res_b_21[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_22
  or res_b_22
  ) begin
    pp_in_l0_a_22 = cfg_is_int8_d0[22] ? {2'b0, res_a_22[31:16], 2'b0, res_a_22[15:0]} :
                    {4'b0, res_a_22[31:0]};
    pp_in_l0_b_22 = cfg_is_int8_d0[22] ? {2'b0, res_b_22[31:16], 2'b0, res_b_22[15:0]} :
                    {4'b0, res_b_22[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_23
  or res_b_23
  ) begin
    pp_in_l0_a_23 = cfg_is_int8_d0[23] ? {2'b0, res_a_23[31:16], 2'b0, res_a_23[15:0]} :
                    {4'b0, res_a_23[31:0]};
    pp_in_l0_b_23 = cfg_is_int8_d0[23] ? {2'b0, res_b_23[31:16], 2'b0, res_b_23[15:0]} :
                    {4'b0, res_b_23[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_24
  or res_b_24
  ) begin
    pp_in_l0_a_24 = cfg_is_int8_d0[24] ? {2'b0, res_a_24[31:16], 2'b0, res_a_24[15:0]} :
                    {4'b0, res_a_24[31:0]};
    pp_in_l0_b_24 = cfg_is_int8_d0[24] ? {2'b0, res_b_24[31:16], 2'b0, res_b_24[15:0]} :
                    {4'b0, res_b_24[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_25
  or res_b_25
  ) begin
    pp_in_l0_a_25 = cfg_is_int8_d0[25] ? {2'b0, res_a_25[31:16], 2'b0, res_a_25[15:0]} :
                    {4'b0, res_a_25[31:0]};
    pp_in_l0_b_25 = cfg_is_int8_d0[25] ? {2'b0, res_b_25[31:16], 2'b0, res_b_25[15:0]} :
                    {4'b0, res_b_25[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_26
  or res_b_26
  ) begin
    pp_in_l0_a_26 = cfg_is_int8_d0[26] ? {2'b0, res_a_26[31:16], 2'b0, res_a_26[15:0]} :
                    {4'b0, res_a_26[31:0]};
    pp_in_l0_b_26 = cfg_is_int8_d0[26] ? {2'b0, res_b_26[31:16], 2'b0, res_b_26[15:0]} :
                    {4'b0, res_b_26[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_27
  or res_b_27
  ) begin
    pp_in_l0_a_27 = cfg_is_int8_d0[27] ? {2'b0, res_a_27[31:16], 2'b0, res_a_27[15:0]} :
                    {4'b0, res_a_27[31:0]};
    pp_in_l0_b_27 = cfg_is_int8_d0[27] ? {2'b0, res_b_27[31:16], 2'b0, res_b_27[15:0]} :
                    {4'b0, res_b_27[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_28
  or res_b_28
  ) begin
    pp_in_l0_a_28 = cfg_is_int8_d0[28] ? {2'b0, res_a_28[31:16], 2'b0, res_a_28[15:0]} :
                    {4'b0, res_a_28[31:0]};
    pp_in_l0_b_28 = cfg_is_int8_d0[28] ? {2'b0, res_b_28[31:16], 2'b0, res_b_28[15:0]} :
                    {4'b0, res_b_28[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_29
  or res_b_29
  ) begin
    pp_in_l0_a_29 = cfg_is_int8_d0[29] ? {2'b0, res_a_29[31:16], 2'b0, res_a_29[15:0]} :
                    {4'b0, res_a_29[31:0]};
    pp_in_l0_b_29 = cfg_is_int8_d0[29] ? {2'b0, res_b_29[31:16], 2'b0, res_b_29[15:0]} :
                    {4'b0, res_b_29[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_30
  or res_b_30
  ) begin
    pp_in_l0_a_30 = cfg_is_int8_d0[30] ? {2'b0, res_a_30[31:16], 2'b0, res_a_30[15:0]} :
                    {4'b0, res_a_30[31:0]};
    pp_in_l0_b_30 = cfg_is_int8_d0[30] ? {2'b0, res_b_30[31:16], 2'b0, res_b_30[15:0]} :
                    {4'b0, res_b_30[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_31
  or res_b_31
  ) begin
    pp_in_l0_a_31 = cfg_is_int8_d0[31] ? {2'b0, res_a_31[31:16], 2'b0, res_a_31[15:0]} :
                    {4'b0, res_a_31[31:0]};
    pp_in_l0_b_31 = cfg_is_int8_d0[31] ? {2'b0, res_b_31[31:16], 2'b0, res_b_31[15:0]} :
                    {4'b0, res_b_31[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_32
  or res_b_32
  ) begin
    pp_in_l0_a_32 = cfg_is_int8_d0[32] ? {2'b0, res_a_32[31:16], 2'b0, res_a_32[15:0]} :
                    {4'b0, res_a_32[31:0]};
    pp_in_l0_b_32 = cfg_is_int8_d0[32] ? {2'b0, res_b_32[31:16], 2'b0, res_b_32[15:0]} :
                    {4'b0, res_b_32[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_33
  or res_b_33
  ) begin
    pp_in_l0_a_33 = cfg_is_int8_d0[33] ? {2'b0, res_a_33[31:16], 2'b0, res_a_33[15:0]} :
                    {4'b0, res_a_33[31:0]};
    pp_in_l0_b_33 = cfg_is_int8_d0[33] ? {2'b0, res_b_33[31:16], 2'b0, res_b_33[15:0]} :
                    {4'b0, res_b_33[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_34
  or res_b_34
  ) begin
    pp_in_l0_a_34 = cfg_is_int8_d0[34] ? {2'b0, res_a_34[31:16], 2'b0, res_a_34[15:0]} :
                    {4'b0, res_a_34[31:0]};
    pp_in_l0_b_34 = cfg_is_int8_d0[34] ? {2'b0, res_b_34[31:16], 2'b0, res_b_34[15:0]} :
                    {4'b0, res_b_34[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_35
  or res_b_35
  ) begin
    pp_in_l0_a_35 = cfg_is_int8_d0[35] ? {2'b0, res_a_35[31:16], 2'b0, res_a_35[15:0]} :
                    {4'b0, res_a_35[31:0]};
    pp_in_l0_b_35 = cfg_is_int8_d0[35] ? {2'b0, res_b_35[31:16], 2'b0, res_b_35[15:0]} :
                    {4'b0, res_b_35[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_36
  or res_b_36
  ) begin
    pp_in_l0_a_36 = cfg_is_int8_d0[36] ? {2'b0, res_a_36[31:16], 2'b0, res_a_36[15:0]} :
                    {4'b0, res_a_36[31:0]};
    pp_in_l0_b_36 = cfg_is_int8_d0[36] ? {2'b0, res_b_36[31:16], 2'b0, res_b_36[15:0]} :
                    {4'b0, res_b_36[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_37
  or res_b_37
  ) begin
    pp_in_l0_a_37 = cfg_is_int8_d0[37] ? {2'b0, res_a_37[31:16], 2'b0, res_a_37[15:0]} :
                    {4'b0, res_a_37[31:0]};
    pp_in_l0_b_37 = cfg_is_int8_d0[37] ? {2'b0, res_b_37[31:16], 2'b0, res_b_37[15:0]} :
                    {4'b0, res_b_37[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_38
  or res_b_38
  ) begin
    pp_in_l0_a_38 = cfg_is_int8_d0[38] ? {2'b0, res_a_38[31:16], 2'b0, res_a_38[15:0]} :
                    {4'b0, res_a_38[31:0]};
    pp_in_l0_b_38 = cfg_is_int8_d0[38] ? {2'b0, res_b_38[31:16], 2'b0, res_b_38[15:0]} :
                    {4'b0, res_b_38[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_39
  or res_b_39
  ) begin
    pp_in_l0_a_39 = cfg_is_int8_d0[39] ? {2'b0, res_a_39[31:16], 2'b0, res_a_39[15:0]} :
                    {4'b0, res_a_39[31:0]};
    pp_in_l0_b_39 = cfg_is_int8_d0[39] ? {2'b0, res_b_39[31:16], 2'b0, res_b_39[15:0]} :
                    {4'b0, res_b_39[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_40
  or res_b_40
  ) begin
    pp_in_l0_a_40 = cfg_is_int8_d0[40] ? {2'b0, res_a_40[31:16], 2'b0, res_a_40[15:0]} :
                    {4'b0, res_a_40[31:0]};
    pp_in_l0_b_40 = cfg_is_int8_d0[40] ? {2'b0, res_b_40[31:16], 2'b0, res_b_40[15:0]} :
                    {4'b0, res_b_40[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_41
  or res_b_41
  ) begin
    pp_in_l0_a_41 = cfg_is_int8_d0[41] ? {2'b0, res_a_41[31:16], 2'b0, res_a_41[15:0]} :
                    {4'b0, res_a_41[31:0]};
    pp_in_l0_b_41 = cfg_is_int8_d0[41] ? {2'b0, res_b_41[31:16], 2'b0, res_b_41[15:0]} :
                    {4'b0, res_b_41[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_42
  or res_b_42
  ) begin
    pp_in_l0_a_42 = cfg_is_int8_d0[42] ? {2'b0, res_a_42[31:16], 2'b0, res_a_42[15:0]} :
                    {4'b0, res_a_42[31:0]};
    pp_in_l0_b_42 = cfg_is_int8_d0[42] ? {2'b0, res_b_42[31:16], 2'b0, res_b_42[15:0]} :
                    {4'b0, res_b_42[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_43
  or res_b_43
  ) begin
    pp_in_l0_a_43 = cfg_is_int8_d0[43] ? {2'b0, res_a_43[31:16], 2'b0, res_a_43[15:0]} :
                    {4'b0, res_a_43[31:0]};
    pp_in_l0_b_43 = cfg_is_int8_d0[43] ? {2'b0, res_b_43[31:16], 2'b0, res_b_43[15:0]} :
                    {4'b0, res_b_43[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_44
  or res_b_44
  ) begin
    pp_in_l0_a_44 = cfg_is_int8_d0[44] ? {2'b0, res_a_44[31:16], 2'b0, res_a_44[15:0]} :
                    {4'b0, res_a_44[31:0]};
    pp_in_l0_b_44 = cfg_is_int8_d0[44] ? {2'b0, res_b_44[31:16], 2'b0, res_b_44[15:0]} :
                    {4'b0, res_b_44[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_45
  or res_b_45
  ) begin
    pp_in_l0_a_45 = cfg_is_int8_d0[45] ? {2'b0, res_a_45[31:16], 2'b0, res_a_45[15:0]} :
                    {4'b0, res_a_45[31:0]};
    pp_in_l0_b_45 = cfg_is_int8_d0[45] ? {2'b0, res_b_45[31:16], 2'b0, res_b_45[15:0]} :
                    {4'b0, res_b_45[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_46
  or res_b_46
  ) begin
    pp_in_l0_a_46 = cfg_is_int8_d0[46] ? {2'b0, res_a_46[31:16], 2'b0, res_a_46[15:0]} :
                    {4'b0, res_a_46[31:0]};
    pp_in_l0_b_46 = cfg_is_int8_d0[46] ? {2'b0, res_b_46[31:16], 2'b0, res_b_46[15:0]} :
                    {4'b0, res_b_46[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_47
  or res_b_47
  ) begin
    pp_in_l0_a_47 = cfg_is_int8_d0[47] ? {2'b0, res_a_47[31:16], 2'b0, res_a_47[15:0]} :
                    {4'b0, res_a_47[31:0]};
    pp_in_l0_b_47 = cfg_is_int8_d0[47] ? {2'b0, res_b_47[31:16], 2'b0, res_b_47[15:0]} :
                    {4'b0, res_b_47[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_48
  or res_b_48
  ) begin
    pp_in_l0_a_48 = cfg_is_int8_d0[48] ? {2'b0, res_a_48[31:16], 2'b0, res_a_48[15:0]} :
                    {4'b0, res_a_48[31:0]};
    pp_in_l0_b_48 = cfg_is_int8_d0[48] ? {2'b0, res_b_48[31:16], 2'b0, res_b_48[15:0]} :
                    {4'b0, res_b_48[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_49
  or res_b_49
  ) begin
    pp_in_l0_a_49 = cfg_is_int8_d0[49] ? {2'b0, res_a_49[31:16], 2'b0, res_a_49[15:0]} :
                    {4'b0, res_a_49[31:0]};
    pp_in_l0_b_49 = cfg_is_int8_d0[49] ? {2'b0, res_b_49[31:16], 2'b0, res_b_49[15:0]} :
                    {4'b0, res_b_49[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_50
  or res_b_50
  ) begin
    pp_in_l0_a_50 = cfg_is_int8_d0[50] ? {2'b0, res_a_50[31:16], 2'b0, res_a_50[15:0]} :
                    {4'b0, res_a_50[31:0]};
    pp_in_l0_b_50 = cfg_is_int8_d0[50] ? {2'b0, res_b_50[31:16], 2'b0, res_b_50[15:0]} :
                    {4'b0, res_b_50[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_51
  or res_b_51
  ) begin
    pp_in_l0_a_51 = cfg_is_int8_d0[51] ? {2'b0, res_a_51[31:16], 2'b0, res_a_51[15:0]} :
                    {4'b0, res_a_51[31:0]};
    pp_in_l0_b_51 = cfg_is_int8_d0[51] ? {2'b0, res_b_51[31:16], 2'b0, res_b_51[15:0]} :
                    {4'b0, res_b_51[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_52
  or res_b_52
  ) begin
    pp_in_l0_a_52 = cfg_is_int8_d0[52] ? {2'b0, res_a_52[31:16], 2'b0, res_a_52[15:0]} :
                    {4'b0, res_a_52[31:0]};
    pp_in_l0_b_52 = cfg_is_int8_d0[52] ? {2'b0, res_b_52[31:16], 2'b0, res_b_52[15:0]} :
                    {4'b0, res_b_52[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_53
  or res_b_53
  ) begin
    pp_in_l0_a_53 = cfg_is_int8_d0[53] ? {2'b0, res_a_53[31:16], 2'b0, res_a_53[15:0]} :
                    {4'b0, res_a_53[31:0]};
    pp_in_l0_b_53 = cfg_is_int8_d0[53] ? {2'b0, res_b_53[31:16], 2'b0, res_b_53[15:0]} :
                    {4'b0, res_b_53[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_54
  or res_b_54
  ) begin
    pp_in_l0_a_54 = cfg_is_int8_d0[54] ? {2'b0, res_a_54[31:16], 2'b0, res_a_54[15:0]} :
                    {4'b0, res_a_54[31:0]};
    pp_in_l0_b_54 = cfg_is_int8_d0[54] ? {2'b0, res_b_54[31:16], 2'b0, res_b_54[15:0]} :
                    {4'b0, res_b_54[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_55
  or res_b_55
  ) begin
    pp_in_l0_a_55 = cfg_is_int8_d0[55] ? {2'b0, res_a_55[31:16], 2'b0, res_a_55[15:0]} :
                    {4'b0, res_a_55[31:0]};
    pp_in_l0_b_55 = cfg_is_int8_d0[55] ? {2'b0, res_b_55[31:16], 2'b0, res_b_55[15:0]} :
                    {4'b0, res_b_55[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_56
  or res_b_56
  ) begin
    pp_in_l0_a_56 = cfg_is_int8_d0[56] ? {2'b0, res_a_56[31:16], 2'b0, res_a_56[15:0]} :
                    {4'b0, res_a_56[31:0]};
    pp_in_l0_b_56 = cfg_is_int8_d0[56] ? {2'b0, res_b_56[31:16], 2'b0, res_b_56[15:0]} :
                    {4'b0, res_b_56[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_57
  or res_b_57
  ) begin
    pp_in_l0_a_57 = cfg_is_int8_d0[57] ? {2'b0, res_a_57[31:16], 2'b0, res_a_57[15:0]} :
                    {4'b0, res_a_57[31:0]};
    pp_in_l0_b_57 = cfg_is_int8_d0[57] ? {2'b0, res_b_57[31:16], 2'b0, res_b_57[15:0]} :
                    {4'b0, res_b_57[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_58
  or res_b_58
  ) begin
    pp_in_l0_a_58 = cfg_is_int8_d0[58] ? {2'b0, res_a_58[31:16], 2'b0, res_a_58[15:0]} :
                    {4'b0, res_a_58[31:0]};
    pp_in_l0_b_58 = cfg_is_int8_d0[58] ? {2'b0, res_b_58[31:16], 2'b0, res_b_58[15:0]} :
                    {4'b0, res_b_58[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_59
  or res_b_59
  ) begin
    pp_in_l0_a_59 = cfg_is_int8_d0[59] ? {2'b0, res_a_59[31:16], 2'b0, res_a_59[15:0]} :
                    {4'b0, res_a_59[31:0]};
    pp_in_l0_b_59 = cfg_is_int8_d0[59] ? {2'b0, res_b_59[31:16], 2'b0, res_b_59[15:0]} :
                    {4'b0, res_b_59[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_60
  or res_b_60
  ) begin
    pp_in_l0_a_60 = cfg_is_int8_d0[60] ? {2'b0, res_a_60[31:16], 2'b0, res_a_60[15:0]} :
                    {4'b0, res_a_60[31:0]};
    pp_in_l0_b_60 = cfg_is_int8_d0[60] ? {2'b0, res_b_60[31:16], 2'b0, res_b_60[15:0]} :
                    {4'b0, res_b_60[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_61
  or res_b_61
  ) begin
    pp_in_l0_a_61 = cfg_is_int8_d0[61] ? {2'b0, res_a_61[31:16], 2'b0, res_a_61[15:0]} :
                    {4'b0, res_a_61[31:0]};
    pp_in_l0_b_61 = cfg_is_int8_d0[61] ? {2'b0, res_b_61[31:16], 2'b0, res_b_61[15:0]} :
                    {4'b0, res_b_61[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_62
  or res_b_62
  ) begin
    pp_in_l0_a_62 = cfg_is_int8_d0[62] ? {2'b0, res_a_62[31:16], 2'b0, res_a_62[15:0]} :
                    {4'b0, res_a_62[31:0]};
    pp_in_l0_b_62 = cfg_is_int8_d0[62] ? {2'b0, res_b_62[31:16], 2'b0, res_b_62[15:0]} :
                    {4'b0, res_b_62[31:0]};
end


always @(
  cfg_is_int8_d0
  or res_a_63
  or res_b_63
  ) begin
    pp_in_l0_a_63 = cfg_is_int8_d0[63] ? {2'b0, res_a_63[31:16], 2'b0, res_a_63[15:0]} :
                    {4'b0, res_a_63[31:0]};
    pp_in_l0_b_63 = cfg_is_int8_d0[63] ? {2'b0, res_b_63[31:16], 2'b0, res_b_63[15:0]} :
                    {4'b0, res_b_63[31:0]};
end




/////////////////////////////////////////////////////////////////////
//////////////// assemble input for CSA tree level 0 ////////////////
/////////////////////////////////////////////////////////////////////

always @(
  pp_in_l0_b_03
  or pp_in_l0_a_03
  or pp_in_l0_b_02
  or pp_in_l0_a_02
  or pp_in_l0_b_01
  or pp_in_l0_a_01
  or pp_in_l0_b_00
  or pp_in_l0_a_00
  ) begin
    pp_in_l0n00 = {pp_in_l0_b_03, pp_in_l0_a_03, pp_in_l0_b_02, pp_in_l0_a_02, pp_in_l0_b_01, pp_in_l0_a_01, pp_in_l0_b_00, pp_in_l0_a_00};
end


always @(
  pp_in_l0_b_07
  or pp_in_l0_a_07
  or pp_in_l0_b_06
  or pp_in_l0_a_06
  or pp_in_l0_b_05
  or pp_in_l0_a_05
  or pp_in_l0_b_04
  or pp_in_l0_a_04
  ) begin
    pp_in_l0n01 = {pp_in_l0_b_07, pp_in_l0_a_07, pp_in_l0_b_06, pp_in_l0_a_06, pp_in_l0_b_05, pp_in_l0_a_05, pp_in_l0_b_04, pp_in_l0_a_04};
end


always @(
  pp_in_l0_b_11
  or pp_in_l0_a_11
  or pp_in_l0_b_10
  or pp_in_l0_a_10
  or pp_in_l0_b_09
  or pp_in_l0_a_09
  or pp_in_l0_b_08
  or pp_in_l0_a_08
  ) begin
    pp_in_l0n02 = {pp_in_l0_b_11, pp_in_l0_a_11, pp_in_l0_b_10, pp_in_l0_a_10, pp_in_l0_b_09, pp_in_l0_a_09, pp_in_l0_b_08, pp_in_l0_a_08};
end


always @(
  pp_in_l0_b_15
  or pp_in_l0_a_15
  or pp_in_l0_b_14
  or pp_in_l0_a_14
  or pp_in_l0_b_13
  or pp_in_l0_a_13
  or pp_in_l0_b_12
  or pp_in_l0_a_12
  ) begin
    pp_in_l0n03 = {pp_in_l0_b_15, pp_in_l0_a_15, pp_in_l0_b_14, pp_in_l0_a_14, pp_in_l0_b_13, pp_in_l0_a_13, pp_in_l0_b_12, pp_in_l0_a_12};
end


always @(
  pp_in_l0_b_19
  or pp_in_l0_a_19
  or pp_in_l0_b_18
  or pp_in_l0_a_18
  or pp_in_l0_b_17
  or pp_in_l0_a_17
  or pp_in_l0_b_16
  or pp_in_l0_a_16
  ) begin
    pp_in_l0n04 = {pp_in_l0_b_19, pp_in_l0_a_19, pp_in_l0_b_18, pp_in_l0_a_18, pp_in_l0_b_17, pp_in_l0_a_17, pp_in_l0_b_16, pp_in_l0_a_16};
end


always @(
  pp_in_l0_b_23
  or pp_in_l0_a_23
  or pp_in_l0_b_22
  or pp_in_l0_a_22
  or pp_in_l0_b_21
  or pp_in_l0_a_21
  or pp_in_l0_b_20
  or pp_in_l0_a_20
  ) begin
    pp_in_l0n05 = {pp_in_l0_b_23, pp_in_l0_a_23, pp_in_l0_b_22, pp_in_l0_a_22, pp_in_l0_b_21, pp_in_l0_a_21, pp_in_l0_b_20, pp_in_l0_a_20};
end


always @(
  pp_in_l0_b_27
  or pp_in_l0_a_27
  or pp_in_l0_b_26
  or pp_in_l0_a_26
  or pp_in_l0_b_25
  or pp_in_l0_a_25
  or pp_in_l0_b_24
  or pp_in_l0_a_24
  ) begin
    pp_in_l0n06 = {pp_in_l0_b_27, pp_in_l0_a_27, pp_in_l0_b_26, pp_in_l0_a_26, pp_in_l0_b_25, pp_in_l0_a_25, pp_in_l0_b_24, pp_in_l0_a_24};
end


always @(
  pp_in_l0_b_31
  or pp_in_l0_a_31
  or pp_in_l0_b_30
  or pp_in_l0_a_30
  or pp_in_l0_b_29
  or pp_in_l0_a_29
  or pp_in_l0_b_28
  or pp_in_l0_a_28
  ) begin
    pp_in_l0n07 = {pp_in_l0_b_31, pp_in_l0_a_31, pp_in_l0_b_30, pp_in_l0_a_30, pp_in_l0_b_29, pp_in_l0_a_29, pp_in_l0_b_28, pp_in_l0_a_28};
end


always @(
  pp_in_l0_b_35
  or pp_in_l0_a_35
  or pp_in_l0_b_34
  or pp_in_l0_a_34
  or pp_in_l0_b_33
  or pp_in_l0_a_33
  or pp_in_l0_b_32
  or pp_in_l0_a_32
  ) begin
    pp_in_l0n08 = {pp_in_l0_b_35, pp_in_l0_a_35, pp_in_l0_b_34, pp_in_l0_a_34, pp_in_l0_b_33, pp_in_l0_a_33, pp_in_l0_b_32, pp_in_l0_a_32};
end


always @(
  pp_in_l0_b_39
  or pp_in_l0_a_39
  or pp_in_l0_b_38
  or pp_in_l0_a_38
  or pp_in_l0_b_37
  or pp_in_l0_a_37
  or pp_in_l0_b_36
  or pp_in_l0_a_36
  ) begin
    pp_in_l0n09 = {pp_in_l0_b_39, pp_in_l0_a_39, pp_in_l0_b_38, pp_in_l0_a_38, pp_in_l0_b_37, pp_in_l0_a_37, pp_in_l0_b_36, pp_in_l0_a_36};
end


always @(
  pp_in_l0_b_43
  or pp_in_l0_a_43
  or pp_in_l0_b_42
  or pp_in_l0_a_42
  or pp_in_l0_b_41
  or pp_in_l0_a_41
  or pp_in_l0_b_40
  or pp_in_l0_a_40
  ) begin
    pp_in_l0n10 = {pp_in_l0_b_43, pp_in_l0_a_43, pp_in_l0_b_42, pp_in_l0_a_42, pp_in_l0_b_41, pp_in_l0_a_41, pp_in_l0_b_40, pp_in_l0_a_40};
end


always @(
  pp_in_l0_b_47
  or pp_in_l0_a_47
  or pp_in_l0_b_46
  or pp_in_l0_a_46
  or pp_in_l0_b_45
  or pp_in_l0_a_45
  or pp_in_l0_b_44
  or pp_in_l0_a_44
  ) begin
    pp_in_l0n11 = {pp_in_l0_b_47, pp_in_l0_a_47, pp_in_l0_b_46, pp_in_l0_a_46, pp_in_l0_b_45, pp_in_l0_a_45, pp_in_l0_b_44, pp_in_l0_a_44};
end


always @(
  pp_in_l0_b_51
  or pp_in_l0_a_51
  or pp_in_l0_b_50
  or pp_in_l0_a_50
  or pp_in_l0_b_49
  or pp_in_l0_a_49
  or pp_in_l0_b_48
  or pp_in_l0_a_48
  ) begin
    pp_in_l0n12 = {pp_in_l0_b_51, pp_in_l0_a_51, pp_in_l0_b_50, pp_in_l0_a_50, pp_in_l0_b_49, pp_in_l0_a_49, pp_in_l0_b_48, pp_in_l0_a_48};
end


always @(
  pp_in_l0_b_55
  or pp_in_l0_a_55
  or pp_in_l0_b_54
  or pp_in_l0_a_54
  or pp_in_l0_b_53
  or pp_in_l0_a_53
  or pp_in_l0_b_52
  or pp_in_l0_a_52
  ) begin
    pp_in_l0n13 = {pp_in_l0_b_55, pp_in_l0_a_55, pp_in_l0_b_54, pp_in_l0_a_54, pp_in_l0_b_53, pp_in_l0_a_53, pp_in_l0_b_52, pp_in_l0_a_52};
end


always @(
  pp_in_l0_b_59
  or pp_in_l0_a_59
  or pp_in_l0_b_58
  or pp_in_l0_a_58
  or pp_in_l0_b_57
  or pp_in_l0_a_57
  or pp_in_l0_b_56
  or pp_in_l0_a_56
  ) begin
    pp_in_l0n14 = {pp_in_l0_b_59, pp_in_l0_a_59, pp_in_l0_b_58, pp_in_l0_a_58, pp_in_l0_b_57, pp_in_l0_a_57, pp_in_l0_b_56, pp_in_l0_a_56};
end


always @(
  pp_in_l0_b_63
  or pp_in_l0_a_63
  or pp_in_l0_b_62
  or pp_in_l0_a_62
  or pp_in_l0_b_61
  or pp_in_l0_a_61
  or pp_in_l0_b_60
  or pp_in_l0_a_60
  ) begin
    pp_in_l0n15 = {pp_in_l0_b_63, pp_in_l0_a_63, pp_in_l0_b_62, pp_in_l0_a_62, pp_in_l0_b_61, pp_in_l0_a_61, pp_in_l0_b_60, pp_in_l0_a_60};
end




//////////////////////////////////////////////////////////
//////////////// CSA tree level 0: 64->16 ////////////////
//////////////////////////////////////////////////////////

`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n00 (
   .INPUT              (pp_in_l0n00[287:0])    //|< r
  ,.OUT0               (pp_out_l0n00_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n00_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n00 (
   .INPUT              (pp_in_l0n00[287:0])    //|< r
  ,.OUT0               (pp_out_l0n00_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n00_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n01 (
   .INPUT              (pp_in_l0n01[287:0])    //|< r
  ,.OUT0               (pp_out_l0n01_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n01_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n01 (
   .INPUT              (pp_in_l0n01[287:0])    //|< r
  ,.OUT0               (pp_out_l0n01_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n01_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n02 (
   .INPUT              (pp_in_l0n02[287:0])    //|< r
  ,.OUT0               (pp_out_l0n02_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n02_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n02 (
   .INPUT              (pp_in_l0n02[287:0])    //|< r
  ,.OUT0               (pp_out_l0n02_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n02_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n03 (
   .INPUT              (pp_in_l0n03[287:0])    //|< r
  ,.OUT0               (pp_out_l0n03_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n03_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n03 (
   .INPUT              (pp_in_l0n03[287:0])    //|< r
  ,.OUT0               (pp_out_l0n03_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n03_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n04 (
   .INPUT              (pp_in_l0n04[287:0])    //|< r
  ,.OUT0               (pp_out_l0n04_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n04_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n04 (
   .INPUT              (pp_in_l0n04[287:0])    //|< r
  ,.OUT0               (pp_out_l0n04_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n04_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n05 (
   .INPUT              (pp_in_l0n05[287:0])    //|< r
  ,.OUT0               (pp_out_l0n05_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n05_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n05 (
   .INPUT              (pp_in_l0n05[287:0])    //|< r
  ,.OUT0               (pp_out_l0n05_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n05_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n06 (
   .INPUT              (pp_in_l0n06[287:0])    //|< r
  ,.OUT0               (pp_out_l0n06_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n06_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n06 (
   .INPUT              (pp_in_l0n06[287:0])    //|< r
  ,.OUT0               (pp_out_l0n06_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n06_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n07 (
   .INPUT              (pp_in_l0n07[287:0])    //|< r
  ,.OUT0               (pp_out_l0n07_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n07_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n07 (
   .INPUT              (pp_in_l0n07[287:0])    //|< r
  ,.OUT0               (pp_out_l0n07_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n07_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n08 (
   .INPUT              (pp_in_l0n08[287:0])    //|< r
  ,.OUT0               (pp_out_l0n08_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n08_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n08 (
   .INPUT              (pp_in_l0n08[287:0])    //|< r
  ,.OUT0               (pp_out_l0n08_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n08_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n09 (
   .INPUT              (pp_in_l0n09[287:0])    //|< r
  ,.OUT0               (pp_out_l0n09_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n09_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n09 (
   .INPUT              (pp_in_l0n09[287:0])    //|< r
  ,.OUT0               (pp_out_l0n09_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n09_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n10 (
   .INPUT              (pp_in_l0n10[287:0])    //|< r
  ,.OUT0               (pp_out_l0n10_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n10_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n10 (
   .INPUT              (pp_in_l0n10[287:0])    //|< r
  ,.OUT0               (pp_out_l0n10_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n10_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n11 (
   .INPUT              (pp_in_l0n11[287:0])    //|< r
  ,.OUT0               (pp_out_l0n11_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n11_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n11 (
   .INPUT              (pp_in_l0n11[287:0])    //|< r
  ,.OUT0               (pp_out_l0n11_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n11_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n12 (
   .INPUT              (pp_in_l0n12[287:0])    //|< r
  ,.OUT0               (pp_out_l0n12_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n12_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n12 (
   .INPUT              (pp_in_l0n12[287:0])    //|< r
  ,.OUT0               (pp_out_l0n12_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n12_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n13 (
   .INPUT              (pp_in_l0n13[287:0])    //|< r
  ,.OUT0               (pp_out_l0n13_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n13_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n13 (
   .INPUT              (pp_in_l0n13[287:0])    //|< r
  ,.OUT0               (pp_out_l0n13_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n13_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n14 (
   .INPUT              (pp_in_l0n14[287:0])    //|< r
  ,.OUT0               (pp_out_l0n14_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n14_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n14 (
   .INPUT              (pp_in_l0n14[287:0])    //|< r
  ,.OUT0               (pp_out_l0n14_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n14_1[35:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 36) u_tree_l0n15 (
   .INPUT              (pp_in_l0n15[287:0])    //|< r
  ,.OUT0               (pp_out_l0n15_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n15_1[35:0])  //|> w
  );
`else 
DW02_tree #(8, 36) u_tree_l0n15 (
   .INPUT              (pp_in_l0n15[287:0])    //|< r
  ,.OUT0               (pp_out_l0n15_0[35:0])  //|> w
  ,.OUT1               (pp_out_l0n15_1[35:0])  //|> w
  );
`endif 




///////////////////////////////////////////////////////////////////////
//////////////// assemble output from CSA tree level 0 ////////////////
///////////////////////////////////////////////////////////////////////

always @(
  pp_out_l0n00_0
  or pp_out_l0n00_1
  ) begin
    pp_out_l0n00_0_d1_w[35:0] = pp_out_l0n00_0;
    pp_out_l0n00_1_d1_w[35:0] = pp_out_l0n00_1;
end



always @(
  pp_out_l0n01_0
  or pp_out_l0n01_1
  ) begin
    pp_out_l0n01_0_d1_w[35:0] = pp_out_l0n01_0;
    pp_out_l0n01_1_d1_w[35:0] = pp_out_l0n01_1;
end



always @(
  pp_out_l0n02_0
  or pp_out_l0n02_1
  ) begin
    pp_out_l0n02_0_d1_w[35:0] = pp_out_l0n02_0;
    pp_out_l0n02_1_d1_w[35:0] = pp_out_l0n02_1;
end



always @(
  pp_out_l0n03_0
  or pp_out_l0n03_1
  ) begin
    pp_out_l0n03_0_d1_w[35:0] = pp_out_l0n03_0;
    pp_out_l0n03_1_d1_w[35:0] = pp_out_l0n03_1;
end



always @(
  pp_out_l0n04_0
  or pp_out_l0n04_1
  ) begin
    pp_out_l0n04_0_d1_w[35:0] = pp_out_l0n04_0;
    pp_out_l0n04_1_d1_w[35:0] = pp_out_l0n04_1;
end



always @(
  pp_out_l0n05_0
  or pp_out_l0n05_1
  ) begin
    pp_out_l0n05_0_d1_w[35:0] = pp_out_l0n05_0;
    pp_out_l0n05_1_d1_w[35:0] = pp_out_l0n05_1;
end



always @(
  pp_out_l0n06_0
  or pp_out_l0n06_1
  ) begin
    pp_out_l0n06_0_d1_w[35:0] = pp_out_l0n06_0;
    pp_out_l0n06_1_d1_w[35:0] = pp_out_l0n06_1;
end



always @(
  pp_out_l0n07_0
  or pp_out_l0n07_1
  ) begin
    pp_out_l0n07_0_d1_w[35:0] = pp_out_l0n07_0;
    pp_out_l0n07_1_d1_w[35:0] = pp_out_l0n07_1;
end



always @(
  pp_out_l0n08_0
  or pp_out_l0n08_1
  ) begin
    pp_out_l0n08_0_d1_w[35:0] = pp_out_l0n08_0;
    pp_out_l0n08_1_d1_w[35:0] = pp_out_l0n08_1;
end



always @(
  pp_out_l0n09_0
  or pp_out_l0n09_1
  ) begin
    pp_out_l0n09_0_d1_w[35:0] = pp_out_l0n09_0;
    pp_out_l0n09_1_d1_w[35:0] = pp_out_l0n09_1;
end



always @(
  pp_out_l0n10_0
  or pp_out_l0n10_1
  ) begin
    pp_out_l0n10_0_d1_w[35:0] = pp_out_l0n10_0;
    pp_out_l0n10_1_d1_w[35:0] = pp_out_l0n10_1;
end



always @(
  pp_out_l0n11_0
  or pp_out_l0n11_1
  ) begin
    pp_out_l0n11_0_d1_w[35:0] = pp_out_l0n11_0;
    pp_out_l0n11_1_d1_w[35:0] = pp_out_l0n11_1;
end



always @(
  pp_out_l0n12_0
  or pp_out_l0n12_1
  ) begin
    pp_out_l0n12_0_d1_w[35:0] = pp_out_l0n12_0;
    pp_out_l0n12_1_d1_w[35:0] = pp_out_l0n12_1;
end



always @(
  pp_out_l0n13_0
  or pp_out_l0n13_1
  ) begin
    pp_out_l0n13_0_d1_w[35:0] = pp_out_l0n13_0;
    pp_out_l0n13_1_d1_w[35:0] = pp_out_l0n13_1;
end



always @(
  pp_out_l0n14_0
  or pp_out_l0n14_1
  ) begin
    pp_out_l0n14_0_d1_w[35:0] = pp_out_l0n14_0;
    pp_out_l0n14_1_d1_w[35:0] = pp_out_l0n14_1;
end



always @(
  pp_out_l0n15_0
  or pp_out_l0n15_1
  ) begin
    pp_out_l0n15_0_d1_w[35:0] = pp_out_l0n15_0;
    pp_out_l0n15_1_d1_w[35:0] = pp_out_l0n15_1;
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
  nv_assert_never #(0,0,"Error! pp_out_l0n00_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_17x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n00_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n00_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_18x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n00_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n01_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_19x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n01_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n01_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_20x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n01_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n02_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_21x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n02_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n02_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_22x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n02_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n03_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_23x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n03_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n03_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_24x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n03_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n04_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_25x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n04_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n04_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_26x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n04_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n05_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_27x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n05_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n05_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_28x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n05_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n06_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_29x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n06_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n06_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_30x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n06_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n07_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_31x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n07_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n07_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_32x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n07_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n08_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_33x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n08_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n08_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n08_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n09_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_35x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n09_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n09_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n09_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n10_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n10_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n10_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n10_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n11_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_39x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n11_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n11_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_40x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n11_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n12_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_41x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n12_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n12_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_42x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n12_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n13_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_43x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n13_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n13_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_44x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n13_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n14_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n14_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n14_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_46x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n14_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n15_0[35:34] is not zero when not int8 mode!")      zzz_assert_never_47x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n15_0[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pp_out_l0n15_1[35:34] is not zero when not int8 mode!")      zzz_assert_never_48x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & ~cfg_is_int8_d0[0] & (pp_out_l0n15_1[35:34] != 3'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

`ifndef SYNTHESIS
assign dbg_sign = {{34{1'b1}}, 32'haaab0000};


assign dbg_booth_result_00[31:0] = (res_a_00 + res_b_00);

assign dbg_booth_result_01[31:0] = (res_a_01 + res_b_01);

assign dbg_booth_result_02[31:0] = (res_a_02 + res_b_02);

assign dbg_booth_result_03[31:0] = (res_a_03 + res_b_03);

assign dbg_booth_result_04[31:0] = (res_a_04 + res_b_04);

assign dbg_booth_result_05[31:0] = (res_a_05 + res_b_05);

assign dbg_booth_result_06[31:0] = (res_a_06 + res_b_06);

assign dbg_booth_result_07[31:0] = (res_a_07 + res_b_07);

assign dbg_booth_result_08[31:0] = (res_a_08 + res_b_08);

assign dbg_booth_result_09[31:0] = (res_a_09 + res_b_09);

assign dbg_booth_result_10[31:0] = (res_a_10 + res_b_10);

assign dbg_booth_result_11[31:0] = (res_a_11 + res_b_11);

assign dbg_booth_result_12[31:0] = (res_a_12 + res_b_12);

assign dbg_booth_result_13[31:0] = (res_a_13 + res_b_13);

assign dbg_booth_result_14[31:0] = (res_a_14 + res_b_14);

assign dbg_booth_result_15[31:0] = (res_a_15 + res_b_15);

assign dbg_booth_result_16[31:0] = (res_a_16 + res_b_16);

assign dbg_booth_result_17[31:0] = (res_a_17 + res_b_17);

assign dbg_booth_result_18[31:0] = (res_a_18 + res_b_18);

assign dbg_booth_result_19[31:0] = (res_a_19 + res_b_19);

assign dbg_booth_result_20[31:0] = (res_a_20 + res_b_20);

assign dbg_booth_result_21[31:0] = (res_a_21 + res_b_21);

assign dbg_booth_result_22[31:0] = (res_a_22 + res_b_22);

assign dbg_booth_result_23[31:0] = (res_a_23 + res_b_23);

assign dbg_booth_result_24[31:0] = (res_a_24 + res_b_24);

assign dbg_booth_result_25[31:0] = (res_a_25 + res_b_25);

assign dbg_booth_result_26[31:0] = (res_a_26 + res_b_26);

assign dbg_booth_result_27[31:0] = (res_a_27 + res_b_27);

assign dbg_booth_result_28[31:0] = (res_a_28 + res_b_28);

assign dbg_booth_result_29[31:0] = (res_a_29 + res_b_29);

assign dbg_booth_result_30[31:0] = (res_a_30 + res_b_30);

assign dbg_booth_result_31[31:0] = (res_a_31 + res_b_31);

assign dbg_booth_result_32[31:0] = (res_a_32 + res_b_32);

assign dbg_booth_result_33[31:0] = (res_a_33 + res_b_33);

assign dbg_booth_result_34[31:0] = (res_a_34 + res_b_34);

assign dbg_booth_result_35[31:0] = (res_a_35 + res_b_35);

assign dbg_booth_result_36[31:0] = (res_a_36 + res_b_36);

assign dbg_booth_result_37[31:0] = (res_a_37 + res_b_37);

assign dbg_booth_result_38[31:0] = (res_a_38 + res_b_38);

assign dbg_booth_result_39[31:0] = (res_a_39 + res_b_39);

assign dbg_booth_result_40[31:0] = (res_a_40 + res_b_40);

assign dbg_booth_result_41[31:0] = (res_a_41 + res_b_41);

assign dbg_booth_result_42[31:0] = (res_a_42 + res_b_42);

assign dbg_booth_result_43[31:0] = (res_a_43 + res_b_43);

assign dbg_booth_result_44[31:0] = (res_a_44 + res_b_44);

assign dbg_booth_result_45[31:0] = (res_a_45 + res_b_45);

assign dbg_booth_result_46[31:0] = (res_a_46 + res_b_46);

assign dbg_booth_result_47[31:0] = (res_a_47 + res_b_47);

assign dbg_booth_result_48[31:0] = (res_a_48 + res_b_48);

assign dbg_booth_result_49[31:0] = (res_a_49 + res_b_49);

assign dbg_booth_result_50[31:0] = (res_a_50 + res_b_50);

assign dbg_booth_result_51[31:0] = (res_a_51 + res_b_51);

assign dbg_booth_result_52[31:0] = (res_a_52 + res_b_52);

assign dbg_booth_result_53[31:0] = (res_a_53 + res_b_53);

assign dbg_booth_result_54[31:0] = (res_a_54 + res_b_54);

assign dbg_booth_result_55[31:0] = (res_a_55 + res_b_55);

assign dbg_booth_result_56[31:0] = (res_a_56 + res_b_56);

assign dbg_booth_result_57[31:0] = (res_a_57 + res_b_57);

assign dbg_booth_result_58[31:0] = (res_a_58 + res_b_58);

assign dbg_booth_result_59[31:0] = (res_a_59 + res_b_59);

assign dbg_booth_result_60[31:0] = (res_a_60 + res_b_60);

assign dbg_booth_result_61[31:0] = (res_a_61 + res_b_61);

assign dbg_booth_result_62[31:0] = (res_a_62 + res_b_62);

assign dbg_booth_result_63[31:0] = (res_a_63 + res_b_63);




`endif

//==========================================================
// Gather FP16 sign tag
//==========================================================

assign res_tag_b0 = {res_tag_63[0], res_tag_62[0], res_tag_61[0], res_tag_60[0], res_tag_59[0], res_tag_58[0], res_tag_57[0], res_tag_56[0], res_tag_55[0], res_tag_54[0], res_tag_53[0], res_tag_52[0], res_tag_51[0], res_tag_50[0], res_tag_49[0], res_tag_48[0], res_tag_47[0], res_tag_46[0], res_tag_45[0], res_tag_44[0], res_tag_43[0], res_tag_42[0], res_tag_41[0], res_tag_40[0], res_tag_39[0], res_tag_38[0], res_tag_37[0], res_tag_36[0], res_tag_35[0], res_tag_34[0], res_tag_33[0], res_tag_32[0], res_tag_31[0], res_tag_30[0], res_tag_29[0], res_tag_28[0], res_tag_27[0], res_tag_26[0], res_tag_25[0], res_tag_24[0], res_tag_23[0], res_tag_22[0], res_tag_21[0], res_tag_20[0], res_tag_19[0], res_tag_18[0], res_tag_17[0], res_tag_16[0], res_tag_15[0], res_tag_14[0], res_tag_13[0], res_tag_12[0], res_tag_11[0], res_tag_10[0], res_tag_9[0], res_tag_8[0], res_tag_7[0], res_tag_6[0], res_tag_5[0], res_tag_4[0], res_tag_3[0], res_tag_2[0], res_tag_1[0], res_tag_0[0]};
assign res_tag_b1 = {res_tag_63[1], res_tag_62[1], res_tag_61[1], res_tag_60[1], res_tag_59[1], res_tag_58[1], res_tag_57[1], res_tag_56[1], res_tag_55[1], res_tag_54[1], res_tag_53[1], res_tag_52[1], res_tag_51[1], res_tag_50[1], res_tag_49[1], res_tag_48[1], res_tag_47[1], res_tag_46[1], res_tag_45[1], res_tag_44[1], res_tag_43[1], res_tag_42[1], res_tag_41[1], res_tag_40[1], res_tag_39[1], res_tag_38[1], res_tag_37[1], res_tag_36[1], res_tag_35[1], res_tag_34[1], res_tag_33[1], res_tag_32[1], res_tag_31[1], res_tag_30[1], res_tag_29[1], res_tag_28[1], res_tag_27[1], res_tag_26[1], res_tag_25[1], res_tag_24[1], res_tag_23[1], res_tag_22[1], res_tag_21[1], res_tag_20[1], res_tag_19[1], res_tag_18[1], res_tag_17[1], res_tag_16[1], res_tag_15[1], res_tag_14[1], res_tag_13[1], res_tag_12[1], res_tag_11[1], res_tag_10[1], res_tag_9[1], res_tag_8[1], res_tag_7[1], res_tag_6[1], res_tag_5[1], res_tag_4[1], res_tag_3[1], res_tag_2[1], res_tag_1[1], res_tag_0[1]};
assign res_tag_b2 = {res_tag_63[2], res_tag_62[2], res_tag_61[2], res_tag_60[2], res_tag_59[2], res_tag_58[2], res_tag_57[2], res_tag_56[2], res_tag_55[2], res_tag_54[2], res_tag_53[2], res_tag_52[2], res_tag_51[2], res_tag_50[2], res_tag_49[2], res_tag_48[2], res_tag_47[2], res_tag_46[2], res_tag_45[2], res_tag_44[2], res_tag_43[2], res_tag_42[2], res_tag_41[2], res_tag_40[2], res_tag_39[2], res_tag_38[2], res_tag_37[2], res_tag_36[2], res_tag_35[2], res_tag_34[2], res_tag_33[2], res_tag_32[2], res_tag_31[2], res_tag_30[2], res_tag_29[2], res_tag_28[2], res_tag_27[2], res_tag_26[2], res_tag_25[2], res_tag_24[2], res_tag_23[2], res_tag_22[2], res_tag_21[2], res_tag_20[2], res_tag_19[2], res_tag_18[2], res_tag_17[2], res_tag_16[2], res_tag_15[2], res_tag_14[2], res_tag_13[2], res_tag_12[2], res_tag_11[2], res_tag_10[2], res_tag_9[2], res_tag_8[2], res_tag_7[2], res_tag_6[2], res_tag_5[2], res_tag_4[2], res_tag_3[2], res_tag_2[2], res_tag_1[2], res_tag_0[2]};
assign res_tag_b3 = {res_tag_63[3], res_tag_62[3], res_tag_61[3], res_tag_60[3], res_tag_59[3], res_tag_58[3], res_tag_57[3], res_tag_56[3], res_tag_55[3], res_tag_54[3], res_tag_53[3], res_tag_52[3], res_tag_51[3], res_tag_50[3], res_tag_49[3], res_tag_48[3], res_tag_47[3], res_tag_46[3], res_tag_45[3], res_tag_44[3], res_tag_43[3], res_tag_42[3], res_tag_41[3], res_tag_40[3], res_tag_39[3], res_tag_38[3], res_tag_37[3], res_tag_36[3], res_tag_35[3], res_tag_34[3], res_tag_33[3], res_tag_32[3], res_tag_31[3], res_tag_30[3], res_tag_29[3], res_tag_28[3], res_tag_27[3], res_tag_26[3], res_tag_25[3], res_tag_24[3], res_tag_23[3], res_tag_22[3], res_tag_21[3], res_tag_20[3], res_tag_19[3], res_tag_18[3], res_tag_17[3], res_tag_16[3], res_tag_15[3], res_tag_14[3], res_tag_13[3], res_tag_12[3], res_tag_11[3], res_tag_10[3], res_tag_9[3], res_tag_8[3], res_tag_7[3], res_tag_6[3], res_tag_5[3], res_tag_4[3], res_tag_3[3], res_tag_2[3], res_tag_1[3], res_tag_0[3]};
assign res_tag_b4 = {res_tag_63[4], res_tag_62[4], res_tag_61[4], res_tag_60[4], res_tag_59[4], res_tag_58[4], res_tag_57[4], res_tag_56[4], res_tag_55[4], res_tag_54[4], res_tag_53[4], res_tag_52[4], res_tag_51[4], res_tag_50[4], res_tag_49[4], res_tag_48[4], res_tag_47[4], res_tag_46[4], res_tag_45[4], res_tag_44[4], res_tag_43[4], res_tag_42[4], res_tag_41[4], res_tag_40[4], res_tag_39[4], res_tag_38[4], res_tag_37[4], res_tag_36[4], res_tag_35[4], res_tag_34[4], res_tag_33[4], res_tag_32[4], res_tag_31[4], res_tag_30[4], res_tag_29[4], res_tag_28[4], res_tag_27[4], res_tag_26[4], res_tag_25[4], res_tag_24[4], res_tag_23[4], res_tag_22[4], res_tag_21[4], res_tag_20[4], res_tag_19[4], res_tag_18[4], res_tag_17[4], res_tag_16[4], res_tag_15[4], res_tag_14[4], res_tag_13[4], res_tag_12[4], res_tag_11[4], res_tag_10[4], res_tag_9[4], res_tag_8[4], res_tag_7[4], res_tag_6[4], res_tag_5[4], res_tag_4[4], res_tag_3[4], res_tag_2[4], res_tag_1[4], res_tag_0[4]};
assign res_tag_b5 = {res_tag_63[5], res_tag_62[5], res_tag_61[5], res_tag_60[5], res_tag_59[5], res_tag_58[5], res_tag_57[5], res_tag_56[5], res_tag_55[5], res_tag_54[5], res_tag_53[5], res_tag_52[5], res_tag_51[5], res_tag_50[5], res_tag_49[5], res_tag_48[5], res_tag_47[5], res_tag_46[5], res_tag_45[5], res_tag_44[5], res_tag_43[5], res_tag_42[5], res_tag_41[5], res_tag_40[5], res_tag_39[5], res_tag_38[5], res_tag_37[5], res_tag_36[5], res_tag_35[5], res_tag_34[5], res_tag_33[5], res_tag_32[5], res_tag_31[5], res_tag_30[5], res_tag_29[5], res_tag_28[5], res_tag_27[5], res_tag_26[5], res_tag_25[5], res_tag_24[5], res_tag_23[5], res_tag_22[5], res_tag_21[5], res_tag_20[5], res_tag_19[5], res_tag_18[5], res_tag_17[5], res_tag_16[5], res_tag_15[5], res_tag_14[5], res_tag_13[5], res_tag_12[5], res_tag_11[5], res_tag_10[5], res_tag_9[5], res_tag_8[5], res_tag_7[5], res_tag_6[5], res_tag_5[5], res_tag_4[5], res_tag_3[5], res_tag_2[5], res_tag_1[5], res_tag_0[5]};
assign res_tag_b6 = {res_tag_63[6], res_tag_62[6], res_tag_61[6], res_tag_60[6], res_tag_59[6], res_tag_58[6], res_tag_57[6], res_tag_56[6], res_tag_55[6], res_tag_54[6], res_tag_53[6], res_tag_52[6], res_tag_51[6], res_tag_50[6], res_tag_49[6], res_tag_48[6], res_tag_47[6], res_tag_46[6], res_tag_45[6], res_tag_44[6], res_tag_43[6], res_tag_42[6], res_tag_41[6], res_tag_40[6], res_tag_39[6], res_tag_38[6], res_tag_37[6], res_tag_36[6], res_tag_35[6], res_tag_34[6], res_tag_33[6], res_tag_32[6], res_tag_31[6], res_tag_30[6], res_tag_29[6], res_tag_28[6], res_tag_27[6], res_tag_26[6], res_tag_25[6], res_tag_24[6], res_tag_23[6], res_tag_22[6], res_tag_21[6], res_tag_20[6], res_tag_19[6], res_tag_18[6], res_tag_17[6], res_tag_16[6], res_tag_15[6], res_tag_14[6], res_tag_13[6], res_tag_12[6], res_tag_11[6], res_tag_10[6], res_tag_9[6], res_tag_8[6], res_tag_7[6], res_tag_6[6], res_tag_5[6], res_tag_4[6], res_tag_3[6], res_tag_2[6], res_tag_1[6], res_tag_0[6]};
assign res_tag_b7 = {res_tag_63[7], res_tag_62[7], res_tag_61[7], res_tag_60[7], res_tag_59[7], res_tag_58[7], res_tag_57[7], res_tag_56[7], res_tag_55[7], res_tag_54[7], res_tag_53[7], res_tag_52[7], res_tag_51[7], res_tag_50[7], res_tag_49[7], res_tag_48[7], res_tag_47[7], res_tag_46[7], res_tag_45[7], res_tag_44[7], res_tag_43[7], res_tag_42[7], res_tag_41[7], res_tag_40[7], res_tag_39[7], res_tag_38[7], res_tag_37[7], res_tag_36[7], res_tag_35[7], res_tag_34[7], res_tag_33[7], res_tag_32[7], res_tag_31[7], res_tag_30[7], res_tag_29[7], res_tag_28[7], res_tag_27[7], res_tag_26[7], res_tag_25[7], res_tag_24[7], res_tag_23[7], res_tag_22[7], res_tag_21[7], res_tag_20[7], res_tag_19[7], res_tag_18[7], res_tag_17[7], res_tag_16[7], res_tag_15[7], res_tag_14[7], res_tag_13[7], res_tag_12[7], res_tag_11[7], res_tag_10[7], res_tag_9[7], res_tag_8[7], res_tag_7[7], res_tag_6[7], res_tag_5[7], res_tag_4[7], res_tag_3[7], res_tag_2[7], res_tag_1[7], res_tag_0[7]};




//==========================================================
// Level 0 registers
//==========================================================

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[64] & wt_actv_pvld[64] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n00_0_d1 <= pp_out_l0n00_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[64] & wt_actv_pvld[64] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n00_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[65] & wt_actv_pvld[65] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n00_1_d1 <= pp_out_l0n00_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[65] & wt_actv_pvld[65] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n00_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[66] & wt_actv_pvld[66] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n01_0_d1 <= pp_out_l0n01_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[66] & wt_actv_pvld[66] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n01_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[67] & wt_actv_pvld[67] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n01_1_d1 <= pp_out_l0n01_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[67] & wt_actv_pvld[67] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n01_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[68] & wt_actv_pvld[68] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n02_0_d1 <= pp_out_l0n02_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[68] & wt_actv_pvld[68] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n02_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[69] & wt_actv_pvld[69] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n02_1_d1 <= pp_out_l0n02_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[69] & wt_actv_pvld[69] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n02_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[70] & wt_actv_pvld[70] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n03_0_d1 <= pp_out_l0n03_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[70] & wt_actv_pvld[70] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n03_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[71] & wt_actv_pvld[71] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n03_1_d1 <= pp_out_l0n03_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[71] & wt_actv_pvld[71] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n03_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[72] & wt_actv_pvld[72] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n04_0_d1 <= pp_out_l0n04_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[72] & wt_actv_pvld[72] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n04_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[73] & wt_actv_pvld[73] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n04_1_d1 <= pp_out_l0n04_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[73] & wt_actv_pvld[73] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n04_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[74] & wt_actv_pvld[74] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n05_0_d1 <= pp_out_l0n05_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[74] & wt_actv_pvld[74] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n05_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[75] & wt_actv_pvld[75] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n05_1_d1 <= pp_out_l0n05_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[75] & wt_actv_pvld[75] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n05_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[76] & wt_actv_pvld[76] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n06_0_d1 <= pp_out_l0n06_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[76] & wt_actv_pvld[76] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n06_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[77] & wt_actv_pvld[77] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n06_1_d1 <= pp_out_l0n06_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[77] & wt_actv_pvld[77] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n06_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[78] & wt_actv_pvld[78] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n07_0_d1 <= pp_out_l0n07_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[78] & wt_actv_pvld[78] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n07_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[79] & wt_actv_pvld[79] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n07_1_d1 <= pp_out_l0n07_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[79] & wt_actv_pvld[79] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n07_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[80] & wt_actv_pvld[80] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n08_0_d1 <= pp_out_l0n08_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[80] & wt_actv_pvld[80] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n08_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[81] & wt_actv_pvld[81] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n08_1_d1 <= pp_out_l0n08_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[81] & wt_actv_pvld[81] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n08_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[82] & wt_actv_pvld[82] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n09_0_d1 <= pp_out_l0n09_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[82] & wt_actv_pvld[82] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n09_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[83] & wt_actv_pvld[83] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n09_1_d1 <= pp_out_l0n09_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[83] & wt_actv_pvld[83] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n09_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[84] & wt_actv_pvld[84] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n10_0_d1 <= pp_out_l0n10_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[84] & wt_actv_pvld[84] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n10_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[85] & wt_actv_pvld[85] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n10_1_d1 <= pp_out_l0n10_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[85] & wt_actv_pvld[85] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n10_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[86] & wt_actv_pvld[86] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n11_0_d1 <= pp_out_l0n11_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[86] & wt_actv_pvld[86] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n11_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[87] & wt_actv_pvld[87] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n11_1_d1 <= pp_out_l0n11_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[87] & wt_actv_pvld[87] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n11_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[88] & wt_actv_pvld[88] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n12_0_d1 <= pp_out_l0n12_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[88] & wt_actv_pvld[88] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n12_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[89] & wt_actv_pvld[89] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n12_1_d1 <= pp_out_l0n12_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[89] & wt_actv_pvld[89] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n12_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[90] & wt_actv_pvld[90] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n13_0_d1 <= pp_out_l0n13_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[90] & wt_actv_pvld[90] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n13_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[91] & wt_actv_pvld[91] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n13_1_d1 <= pp_out_l0n13_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[91] & wt_actv_pvld[91] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n13_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[92] & wt_actv_pvld[92] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n14_0_d1 <= pp_out_l0n14_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[92] & wt_actv_pvld[92] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n14_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[93] & wt_actv_pvld[93] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n14_1_d1 <= pp_out_l0n14_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[93] & wt_actv_pvld[93] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n14_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[94] & wt_actv_pvld[94] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n15_0_d1 <= pp_out_l0n15_0_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[94] & wt_actv_pvld[94] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n15_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[95] & wt_actv_pvld[95] & ~out_nan_pvld) == 1'b1) begin
    pp_out_l0n15_1_d1 <= pp_out_l0n15_1_d1_w;
  // VCS coverage off
  end else if ((dat_actv_pvld[95] & wt_actv_pvld[95] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    pp_out_l0n15_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end





always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[96] & wt_actv_pvld[96] & cfg_is_fp16_d0[0] & ~out_nan_pvld) == 1'b1) begin
    res_tag_b0_d1 <= res_tag_b0;
  // VCS coverage off
  end else if ((dat_actv_pvld[96] & wt_actv_pvld[96] & cfg_is_fp16_d0[0] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    res_tag_b0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[97] & wt_actv_pvld[97] & cfg_is_fp16_d0[1] & ~out_nan_pvld) == 1'b1) begin
    res_tag_b1_d1 <= res_tag_b1;
  // VCS coverage off
  end else if ((dat_actv_pvld[97] & wt_actv_pvld[97] & cfg_is_fp16_d0[1] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    res_tag_b1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[98] & wt_actv_pvld[98] & cfg_is_fp16_d0[2] & ~out_nan_pvld) == 1'b1) begin
    res_tag_b2_d1 <= res_tag_b2;
  // VCS coverage off
  end else if ((dat_actv_pvld[98] & wt_actv_pvld[98] & cfg_is_fp16_d0[2] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    res_tag_b2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[99] & wt_actv_pvld[99] & cfg_is_fp16_d0[3] & ~out_nan_pvld) == 1'b1) begin
    res_tag_b3_d1 <= res_tag_b3;
  // VCS coverage off
  end else if ((dat_actv_pvld[99] & wt_actv_pvld[99] & cfg_is_fp16_d0[3] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    res_tag_b3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[100] & wt_actv_pvld[100] & cfg_is_fp16_d0[4] & ~out_nan_pvld) == 1'b1) begin
    res_tag_b4_d1 <= res_tag_b4;
  // VCS coverage off
  end else if ((dat_actv_pvld[100] & wt_actv_pvld[100] & cfg_is_fp16_d0[4] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    res_tag_b4_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[101] & wt_actv_pvld[101] & cfg_is_fp16_d0[5] & ~out_nan_pvld) == 1'b1) begin
    res_tag_b5_d1 <= res_tag_b5;
  // VCS coverage off
  end else if ((dat_actv_pvld[101] & wt_actv_pvld[101] & cfg_is_fp16_d0[5] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    res_tag_b5_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[102] & wt_actv_pvld[102] & cfg_is_fp16_d0[6] & ~out_nan_pvld) == 1'b1) begin
    res_tag_b6_d1 <= res_tag_b6;
  // VCS coverage off
  end else if ((dat_actv_pvld[102] & wt_actv_pvld[102] & cfg_is_fp16_d0[6] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    res_tag_b6_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_actv_pvld[103] & wt_actv_pvld[103] & cfg_is_fp16_d0[7] & ~out_nan_pvld) == 1'b1) begin
    res_tag_b7_d1 <= res_tag_b7;
  // VCS coverage off
  end else if ((dat_actv_pvld[103] & wt_actv_pvld[103] & cfg_is_fp16_d0[7] & ~out_nan_pvld) == 1'b0) begin
  end else begin
    res_tag_b7_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end




assign pp_nan_pvld_w = (dat_actv_pvld[0] & wt_actv_pvld[0] & out_nan_pvld);
assign pp_exp_pvld_w = (dat_actv_pvld[0] & wt_actv_pvld[0] & ~out_nan_pvld & exp_pvld);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pp_pvld_d1 <= {17{1'b0}};
  end else begin
  pp_pvld_d1 <= {17{(dat_actv_pvld[0] & wt_actv_pvld[0])}};
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pp_nan_pvld_d1 <= {17{1'b0}};
  end else begin
  pp_nan_pvld_d1 <= {17{pp_nan_pvld_w}};
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pp_nan_mts_d1 <= {11{1'b0}};
  end else begin
  if ((dat_actv_pvld[0] & wt_actv_pvld[0] & out_nan_pvld) == 1'b1) begin
    pp_nan_mts_d1 <= out_nan_mts;
  // VCS coverage off
  end else if ((dat_actv_pvld[0] & wt_actv_pvld[0] & out_nan_pvld) == 1'b0) begin
  end else begin
    pp_nan_mts_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_49x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_actv_pvld[0] & wt_actv_pvld[0] & out_nan_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pp_exp_pvld_d1 <= 1'b0;
  end else begin
  pp_exp_pvld_d1 <= pp_exp_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pp_exp_d1 <= {4{1'b0}};
  end else begin
  if ((pp_exp_pvld_w) == 1'b1) begin
    pp_exp_d1 <= exp_max;
  // VCS coverage off
  end else if ((pp_exp_pvld_w) == 1'b0) begin
  end else begin
    pp_exp_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_50x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pp_exp_pvld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! exp_pvld mismatch!")      zzz_assert_never_51x (nvdla_core_clk, `ASSERT_RESET, (dat_actv_pvld[0] & wt_actv_pvld[0] & cfg_is_fp16_d1[0] & ~exp_pvld)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! exp_pvld set when not fp16!")      zzz_assert_never_52x (nvdla_core_clk, `ASSERT_RESET, (~cfg_is_fp16_d1[0] & exp_pvld)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// MAC cell CSA tree level 1
// for DC: 16(32) -> 8(16)
// for WG: first step of 4x4(2*4x4) -> 4x2(2*4x2) 
//==========================================================

///////////////////////////////////////////////////////////////////
//////////////// input select for CSA tree level 1 ////////////////
///////////////////////////////////////////////////////////////////

always @(
  cfg_is_int8_d1
  or pp_out_l0n00_0_d1
  or pp_out_l0n00_1_d1
  or pp_out_l0n01_0_d1
  or pp_out_l0n01_1_d1
  ) begin
    pp_in_l1n0_0 = ~cfg_is_int8_d1[0] ? {8'b0, pp_out_l0n00_0_d1[33:0]} :
                      {3'b0, pp_out_l0n00_0_d1[35:18], 3'b0, pp_out_l0n00_0_d1[17:0]};
    pp_in_l1n0_1 = ~cfg_is_int8_d1[0] ? {8'b0, pp_out_l0n00_1_d1[33:0]} :
                      {3'b0, pp_out_l0n00_1_d1[35:18], 3'b0, pp_out_l0n00_1_d1[17:0]};
    pp_in_l1n0_2 = ~cfg_is_int8_d1[0] ? {8'b0, pp_out_l0n01_0_d1[33:0]} :
                      {3'b0, pp_out_l0n01_0_d1[35:18], 3'b0, pp_out_l0n01_0_d1[17:0]};
    pp_in_l1n0_3 = ~cfg_is_int8_d1[0] ? {8'b0, pp_out_l0n01_1_d1[33:0]} :
                      {3'b0, pp_out_l0n01_1_d1[35:18], 3'b0, pp_out_l0n01_1_d1[17:0]};
end


always @(
  cfg_is_int8_d1
  or pp_out_l0n02_0_d1
  or pp_out_l0n02_1_d1
  or pp_out_l0n03_0_d1
  or pp_out_l0n03_1_d1
  ) begin
    pp_in_l1n1_0 = ~cfg_is_int8_d1[1] ? {8'b0, pp_out_l0n02_0_d1[33:0]} :
                      {3'b0, pp_out_l0n02_0_d1[35:18], 3'b0, pp_out_l0n02_0_d1[17:0]};
    pp_in_l1n1_1 = ~cfg_is_int8_d1[1] ? {8'b0, pp_out_l0n02_1_d1[33:0]} :
                      {3'b0, pp_out_l0n02_1_d1[35:18], 3'b0, pp_out_l0n02_1_d1[17:0]};
    pp_in_l1n1_2 = ~cfg_is_int8_d1[1] ? {8'b0, pp_out_l0n03_0_d1[33:0]} :
                      {3'b0, pp_out_l0n03_0_d1[35:18], 3'b0, pp_out_l0n03_0_d1[17:0]};
    pp_in_l1n1_3 = ~cfg_is_int8_d1[1] ? {8'b0, pp_out_l0n03_1_d1[33:0]} :
                      {3'b0, pp_out_l0n03_1_d1[35:18], 3'b0, pp_out_l0n03_1_d1[17:0]};
end


always @(
  cfg_is_int8_d1
  or pp_out_l0n04_0_d1
  or pp_out_l0n04_1_d1
  or pp_out_l0n05_0_d1
  or pp_out_l0n05_1_d1
  ) begin
    pp_in_l1n2_0 = ~cfg_is_int8_d1[2] ? {8'b0, pp_out_l0n04_0_d1[33:0]} :
                      {3'b0, pp_out_l0n04_0_d1[35:18], 3'b0, pp_out_l0n04_0_d1[17:0]};
    pp_in_l1n2_1 = ~cfg_is_int8_d1[2] ? {8'b0, pp_out_l0n04_1_d1[33:0]} :
                      {3'b0, pp_out_l0n04_1_d1[35:18], 3'b0, pp_out_l0n04_1_d1[17:0]};
    pp_in_l1n2_2 = ~cfg_is_int8_d1[2] ? {8'b0, pp_out_l0n05_0_d1[33:0]} :
                      {3'b0, pp_out_l0n05_0_d1[35:18], 3'b0, pp_out_l0n05_0_d1[17:0]};
    pp_in_l1n2_3 = ~cfg_is_int8_d1[2] ? {8'b0, pp_out_l0n05_1_d1[33:0]} :
                      {3'b0, pp_out_l0n05_1_d1[35:18], 3'b0, pp_out_l0n05_1_d1[17:0]};
end


always @(
  cfg_is_int8_d1
  or pp_out_l0n06_0_d1
  or pp_out_l0n06_1_d1
  or pp_out_l0n07_0_d1
  or pp_out_l0n07_1_d1
  ) begin
    pp_in_l1n3_0 = ~cfg_is_int8_d1[3] ? {8'b0, pp_out_l0n06_0_d1[33:0]} :
                      {3'b0, pp_out_l0n06_0_d1[35:18], 3'b0, pp_out_l0n06_0_d1[17:0]};
    pp_in_l1n3_1 = ~cfg_is_int8_d1[3] ? {8'b0, pp_out_l0n06_1_d1[33:0]} :
                      {3'b0, pp_out_l0n06_1_d1[35:18], 3'b0, pp_out_l0n06_1_d1[17:0]};
    pp_in_l1n3_2 = ~cfg_is_int8_d1[3] ? {8'b0, pp_out_l0n07_0_d1[33:0]} :
                      {3'b0, pp_out_l0n07_0_d1[35:18], 3'b0, pp_out_l0n07_0_d1[17:0]};
    pp_in_l1n3_3 = ~cfg_is_int8_d1[3] ? {8'b0, pp_out_l0n07_1_d1[33:0]} :
                      {3'b0, pp_out_l0n07_1_d1[35:18], 3'b0, pp_out_l0n07_1_d1[17:0]};
end


always @(
  cfg_is_int8_d1
  or pp_out_l0n08_0_d1
  or pp_out_l0n08_1_d1
  or pp_out_l0n09_0_d1
  or pp_out_l0n09_1_d1
  ) begin
    pp_in_l1n4_0 = ~cfg_is_int8_d1[4] ? {8'b0, pp_out_l0n08_0_d1[33:0]} :
                      {3'b0, pp_out_l0n08_0_d1[35:18], 3'b0, pp_out_l0n08_0_d1[17:0]};
    pp_in_l1n4_1 = ~cfg_is_int8_d1[4] ? {8'b0, pp_out_l0n08_1_d1[33:0]} :
                      {3'b0, pp_out_l0n08_1_d1[35:18], 3'b0, pp_out_l0n08_1_d1[17:0]};
    pp_in_l1n4_2 = ~cfg_is_int8_d1[4] ? {8'b0, pp_out_l0n09_0_d1[33:0]} :
                      {3'b0, pp_out_l0n09_0_d1[35:18], 3'b0, pp_out_l0n09_0_d1[17:0]};
    pp_in_l1n4_3 = ~cfg_is_int8_d1[4] ? {8'b0, pp_out_l0n09_1_d1[33:0]} :
                      {3'b0, pp_out_l0n09_1_d1[35:18], 3'b0, pp_out_l0n09_1_d1[17:0]};
end


always @(
  cfg_is_int8_d1
  or pp_out_l0n10_0_d1
  or pp_out_l0n10_1_d1
  or pp_out_l0n11_0_d1
  or pp_out_l0n11_1_d1
  ) begin
    pp_in_l1n5_0 = ~cfg_is_int8_d1[5] ? {8'b0, pp_out_l0n10_0_d1[33:0]} :
                      {3'b0, pp_out_l0n10_0_d1[35:18], 3'b0, pp_out_l0n10_0_d1[17:0]};
    pp_in_l1n5_1 = ~cfg_is_int8_d1[5] ? {8'b0, pp_out_l0n10_1_d1[33:0]} :
                      {3'b0, pp_out_l0n10_1_d1[35:18], 3'b0, pp_out_l0n10_1_d1[17:0]};
    pp_in_l1n5_2 = ~cfg_is_int8_d1[5] ? {8'b0, pp_out_l0n11_0_d1[33:0]} :
                      {3'b0, pp_out_l0n11_0_d1[35:18], 3'b0, pp_out_l0n11_0_d1[17:0]};
    pp_in_l1n5_3 = ~cfg_is_int8_d1[5] ? {8'b0, pp_out_l0n11_1_d1[33:0]} :
                      {3'b0, pp_out_l0n11_1_d1[35:18], 3'b0, pp_out_l0n11_1_d1[17:0]};
end


always @(
  cfg_is_int8_d1
  or pp_out_l0n12_0_d1
  or pp_out_l0n12_1_d1
  or pp_out_l0n13_0_d1
  or pp_out_l0n13_1_d1
  ) begin
    pp_in_l1n6_0 = ~cfg_is_int8_d1[6] ? {8'b0, pp_out_l0n12_0_d1[33:0]} :
                      {3'b0, pp_out_l0n12_0_d1[35:18], 3'b0, pp_out_l0n12_0_d1[17:0]};
    pp_in_l1n6_1 = ~cfg_is_int8_d1[6] ? {8'b0, pp_out_l0n12_1_d1[33:0]} :
                      {3'b0, pp_out_l0n12_1_d1[35:18], 3'b0, pp_out_l0n12_1_d1[17:0]};
    pp_in_l1n6_2 = ~cfg_is_int8_d1[6] ? {8'b0, pp_out_l0n13_0_d1[33:0]} :
                      {3'b0, pp_out_l0n13_0_d1[35:18], 3'b0, pp_out_l0n13_0_d1[17:0]};
    pp_in_l1n6_3 = ~cfg_is_int8_d1[6] ? {8'b0, pp_out_l0n13_1_d1[33:0]} :
                      {3'b0, pp_out_l0n13_1_d1[35:18], 3'b0, pp_out_l0n13_1_d1[17:0]};
end


always @(
  cfg_is_int8_d1
  or pp_out_l0n14_0_d1
  or pp_out_l0n14_1_d1
  or pp_out_l0n15_0_d1
  or pp_out_l0n15_1_d1
  ) begin
    pp_in_l1n7_0 = ~cfg_is_int8_d1[7] ? {8'b0, pp_out_l0n14_0_d1[33:0]} :
                      {3'b0, pp_out_l0n14_0_d1[35:18], 3'b0, pp_out_l0n14_0_d1[17:0]};
    pp_in_l1n7_1 = ~cfg_is_int8_d1[7] ? {8'b0, pp_out_l0n14_1_d1[33:0]} :
                      {3'b0, pp_out_l0n14_1_d1[35:18], 3'b0, pp_out_l0n14_1_d1[17:0]};
    pp_in_l1n7_2 = ~cfg_is_int8_d1[7] ? {8'b0, pp_out_l0n15_0_d1[33:0]} :
                      {3'b0, pp_out_l0n15_0_d1[35:18], 3'b0, pp_out_l0n15_0_d1[17:0]};
    pp_in_l1n7_3 = ~cfg_is_int8_d1[7] ? {8'b0, pp_out_l0n15_1_d1[33:0]} :
                      {3'b0, pp_out_l0n15_1_d1[35:18], 3'b0, pp_out_l0n15_1_d1[17:0]};
end




/////////////////////////////////////////////////////////////////////
//////////////// assemble input for CSA tree level 1 ////////////////
/////////////////////////////////////////////////////////////////////

always @(
  pp_in_l1n0_3
  or pp_in_l1n0_2
  or pp_in_l1n0_1
  or pp_in_l1n0_0
  ) begin
    pp_in_l1n0 = {pp_in_l1n0_3, pp_in_l1n0_2, pp_in_l1n0_1, pp_in_l1n0_0};
end


always @(
  pp_in_l1n1_3
  or pp_in_l1n1_2
  or pp_in_l1n1_1
  or pp_in_l1n1_0
  ) begin
    pp_in_l1n1 = {pp_in_l1n1_3, pp_in_l1n1_2, pp_in_l1n1_1, pp_in_l1n1_0};
end


always @(
  pp_in_l1n2_3
  or pp_in_l1n2_2
  or pp_in_l1n2_1
  or pp_in_l1n2_0
  ) begin
    pp_in_l1n2 = {pp_in_l1n2_3, pp_in_l1n2_2, pp_in_l1n2_1, pp_in_l1n2_0};
end


always @(
  pp_in_l1n3_3
  or pp_in_l1n3_2
  or pp_in_l1n3_1
  or pp_in_l1n3_0
  ) begin
    pp_in_l1n3 = {pp_in_l1n3_3, pp_in_l1n3_2, pp_in_l1n3_1, pp_in_l1n3_0};
end


always @(
  pp_in_l1n4_3
  or pp_in_l1n4_2
  or pp_in_l1n4_1
  or pp_in_l1n4_0
  ) begin
    pp_in_l1n4 = {pp_in_l1n4_3, pp_in_l1n4_2, pp_in_l1n4_1, pp_in_l1n4_0};
end


always @(
  pp_in_l1n5_3
  or pp_in_l1n5_2
  or pp_in_l1n5_1
  or pp_in_l1n5_0
  ) begin
    pp_in_l1n5 = {pp_in_l1n5_3, pp_in_l1n5_2, pp_in_l1n5_1, pp_in_l1n5_0};
end


always @(
  pp_in_l1n6_3
  or pp_in_l1n6_2
  or pp_in_l1n6_1
  or pp_in_l1n6_0
  ) begin
    pp_in_l1n6 = {pp_in_l1n6_3, pp_in_l1n6_2, pp_in_l1n6_1, pp_in_l1n6_0};
end


always @(
  pp_in_l1n7_3
  or pp_in_l1n7_2
  or pp_in_l1n7_1
  or pp_in_l1n7_0
  ) begin
    pp_in_l1n7 = {pp_in_l1n7_3, pp_in_l1n7_2, pp_in_l1n7_1, pp_in_l1n7_0};
end




/////////////////////////////////////////////////////////
//////////////// CSA tree level 1: 16->8 ////////////////
/////////////////////////////////////////////////////////

`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l1n0 (
   .INPUT              (pp_in_l1n0[167:0])     //|< r
  ,.OUT0               (pp_out_l1n0_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n0_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l1n0 (
   .INPUT              (pp_in_l1n0[167:0])     //|< r
  ,.OUT0               (pp_out_l1n0_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n0_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l1n1 (
   .INPUT              (pp_in_l1n1[167:0])     //|< r
  ,.OUT0               (pp_out_l1n1_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n1_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l1n1 (
   .INPUT              (pp_in_l1n1[167:0])     //|< r
  ,.OUT0               (pp_out_l1n1_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n1_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l1n2 (
   .INPUT              (pp_in_l1n2[167:0])     //|< r
  ,.OUT0               (pp_out_l1n2_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n2_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l1n2 (
   .INPUT              (pp_in_l1n2[167:0])     //|< r
  ,.OUT0               (pp_out_l1n2_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n2_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l1n3 (
   .INPUT              (pp_in_l1n3[167:0])     //|< r
  ,.OUT0               (pp_out_l1n3_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n3_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l1n3 (
   .INPUT              (pp_in_l1n3[167:0])     //|< r
  ,.OUT0               (pp_out_l1n3_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n3_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l1n4 (
   .INPUT              (pp_in_l1n4[167:0])     //|< r
  ,.OUT0               (pp_out_l1n4_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n4_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l1n4 (
   .INPUT              (pp_in_l1n4[167:0])     //|< r
  ,.OUT0               (pp_out_l1n4_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n4_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l1n5 (
   .INPUT              (pp_in_l1n5[167:0])     //|< r
  ,.OUT0               (pp_out_l1n5_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n5_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l1n5 (
   .INPUT              (pp_in_l1n5[167:0])     //|< r
  ,.OUT0               (pp_out_l1n5_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n5_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l1n6 (
   .INPUT              (pp_in_l1n6[167:0])     //|< r
  ,.OUT0               (pp_out_l1n6_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n6_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l1n6 (
   .INPUT              (pp_in_l1n6[167:0])     //|< r
  ,.OUT0               (pp_out_l1n6_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n6_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l1n7 (
   .INPUT              (pp_in_l1n7[167:0])     //|< r
  ,.OUT0               (pp_out_l1n7_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n7_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l1n7 (
   .INPUT              (pp_in_l1n7[167:0])     //|< r
  ,.OUT0               (pp_out_l1n7_0[41:0])   //|> w
  ,.OUT1               (pp_out_l1n7_1[41:0])   //|> w
  );
`endif 




/////////////////////////////////////////////////////////////////////////
//////////////// input for CSA tree level 2 (first half) ////////////////
/////////////////////////////////////////////////////////////////////////

always @(
  pp_out_l1n0_0
  or pp_out_l1n0_1
  or cfg_is_wg_d1
  or pp_out_l1n1_0
  or pp_in_l1n1_0
  or pp_out_l1n1_1
  or pp_in_l1n1_1
  ) begin
    pp_in_l2n0_0 = pp_out_l1n0_0;
    pp_in_l2n0_1 = pp_out_l1n0_1;
    pp_in_l2n0_2 = (~cfg_is_wg_d1[0]) ? pp_out_l1n1_0 : pp_in_l1n1_0;
    pp_in_l2n0_3 = (~cfg_is_wg_d1[0]) ? pp_out_l1n1_1 : pp_in_l1n1_1;
end


always @(
  pp_out_l1n2_0
  or pp_out_l1n2_1
  or cfg_is_wg_d1
  or pp_out_l1n3_0
  or pp_in_l1n3_0
  or pp_out_l1n3_1
  or pp_in_l1n3_1
  ) begin
    pp_in_l2n1_0 = pp_out_l1n2_0;
    pp_in_l2n1_1 = pp_out_l1n2_1;
    pp_in_l2n1_2 = (~cfg_is_wg_d1[1]) ? pp_out_l1n3_0 : pp_in_l1n3_0;
    pp_in_l2n1_3 = (~cfg_is_wg_d1[1]) ? pp_out_l1n3_1 : pp_in_l1n3_1;
end


always @(
  pp_out_l1n4_0
  or pp_out_l1n4_1
  or cfg_is_wg_d1
  or pp_out_l1n5_0
  or pp_in_l1n5_0
  or pp_out_l1n5_1
  or pp_in_l1n5_1
  ) begin
    pp_in_l2n2_0 = pp_out_l1n4_0;
    pp_in_l2n2_1 = pp_out_l1n4_1;
    pp_in_l2n2_2 = (~cfg_is_wg_d1[2]) ? pp_out_l1n5_0 : pp_in_l1n5_0;
    pp_in_l2n2_3 = (~cfg_is_wg_d1[2]) ? pp_out_l1n5_1 : pp_in_l1n5_1;
end


always @(
  pp_out_l1n6_0
  or pp_out_l1n6_1
  or cfg_is_wg_d1
  or pp_out_l1n7_0
  or pp_in_l1n7_0
  or pp_out_l1n7_1
  or pp_in_l1n7_1
  ) begin
    pp_in_l2n3_0 = pp_out_l1n6_0;
    pp_in_l2n3_1 = pp_out_l1n6_1;
    pp_in_l2n3_2 = (~cfg_is_wg_d1[3]) ? pp_out_l1n7_0 : pp_in_l1n7_0;
    pp_in_l2n3_3 = (~cfg_is_wg_d1[3]) ? pp_out_l1n7_1 : pp_in_l1n7_1;
end





//==========================================================
// MAC cell CSA tree level 2
// for DC: 8(16) -> 4(8)
// for WG: second step of 4x4(2*4x4) -> 4x2(2*4x2)
//==========================================================

//////////////////////////////////////////////////////////////////////////////////
//////////////// assemble input for CSA tree level 2 (first half) ////////////////
//////////////////////////////////////////////////////////////////////////////////

always @(
  pp_in_l2n0_3
  or pp_in_l2n0_2
  or pp_in_l2n0_1
  or pp_in_l2n0_0
  ) begin
    pp_in_l2n0 = {pp_in_l2n0_3, pp_in_l2n0_2, pp_in_l2n0_1, pp_in_l2n0_0};
end


always @(
  pp_in_l2n1_3
  or pp_in_l2n1_2
  or pp_in_l2n1_1
  or pp_in_l2n1_0
  ) begin
    pp_in_l2n1 = {pp_in_l2n1_3, pp_in_l2n1_2, pp_in_l2n1_1, pp_in_l2n1_0};
end


always @(
  pp_in_l2n2_3
  or pp_in_l2n2_2
  or pp_in_l2n2_1
  or pp_in_l2n2_0
  ) begin
    pp_in_l2n2 = {pp_in_l2n2_3, pp_in_l2n2_2, pp_in_l2n2_1, pp_in_l2n2_0};
end


always @(
  pp_in_l2n3_3
  or pp_in_l2n3_2
  or pp_in_l2n3_1
  or pp_in_l2n3_0
  ) begin
    pp_in_l2n3 = {pp_in_l2n3_3, pp_in_l2n3_2, pp_in_l2n3_1, pp_in_l2n3_0};
end




/////////////////////////////////////////////////////////////////////
//////////////// CSA tree level 2 (first half): 8->4 ////////////////
/////////////////////////////////////////////////////////////////////

`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l2n0 (
   .INPUT              (pp_in_l2n0[167:0])     //|< r
  ,.OUT0               (pp_out_l2n0_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n0_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l2n0 (
   .INPUT              (pp_in_l2n0[167:0])     //|< r
  ,.OUT0               (pp_out_l2n0_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n0_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l2n1 (
   .INPUT              (pp_in_l2n1[167:0])     //|< r
  ,.OUT0               (pp_out_l2n1_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n1_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l2n1 (
   .INPUT              (pp_in_l2n1[167:0])     //|< r
  ,.OUT0               (pp_out_l2n1_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n1_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l2n2 (
   .INPUT              (pp_in_l2n2[167:0])     //|< r
  ,.OUT0               (pp_out_l2n2_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n2_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l2n2 (
   .INPUT              (pp_in_l2n2[167:0])     //|< r
  ,.OUT0               (pp_out_l2n2_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n2_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l2n3 (
   .INPUT              (pp_in_l2n3[167:0])     //|< r
  ,.OUT0               (pp_out_l2n3_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n3_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l2n3 (
   .INPUT              (pp_in_l2n3[167:0])     //|< r
  ,.OUT0               (pp_out_l2n3_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n3_1[41:0])   //|> w
  );
`endif 




//////////////////////////////////////////////////////////////////////////
//////////////// input for CSA tree level 2 (second half) ////////////////
//////////////////////////////////////////////////////////////////////////

always @(
  cfg_is_int8_d1
  or cfg_is_wg_d1
  or pp_in_l1n0_2
  or pp_in_l1n0_3
  or pp_out_l1n1_0
  or pp_out_l1n1_1
  ) begin
    mask2_4 = {2'b0, {2{cfg_is_int8_d1[8]}}, 17'h1ffff, {2{~cfg_is_int8_d1[8]}}, 19'h7ffff};
    pp_in_l2n4_0 = ~cfg_is_wg_d1[4] ? 42'b0 : pp_in_l1n0_2;
    pp_in_l2n4_1 = ~cfg_is_wg_d1[4] ? 42'b0 : pp_in_l1n0_3;
    pp_in_l2n4_2 = ~cfg_is_wg_d1[4] ? 42'b0 : ~pp_out_l1n1_0 & mask2_4;
    pp_in_l2n4_3 = ~cfg_is_wg_d1[4] ? 42'b0 : ~pp_out_l1n1_1 & mask2_4;
end


always @(
  cfg_is_int8_d1
  or cfg_is_wg_d1
  or pp_in_l1n2_2
  or pp_in_l1n2_3
  or pp_out_l1n3_0
  or pp_out_l1n3_1
  ) begin
    mask2_5 = {2'b0, {2{cfg_is_int8_d1[9]}}, 17'h1ffff, {2{~cfg_is_int8_d1[9]}}, 19'h7ffff};
    pp_in_l2n5_0 = ~cfg_is_wg_d1[5] ? 42'b0 : pp_in_l1n2_2;
    pp_in_l2n5_1 = ~cfg_is_wg_d1[5] ? 42'b0 : pp_in_l1n2_3;
    pp_in_l2n5_2 = ~cfg_is_wg_d1[5] ? 42'b0 : ~pp_out_l1n3_0 & mask2_5;
    pp_in_l2n5_3 = ~cfg_is_wg_d1[5] ? 42'b0 : ~pp_out_l1n3_1 & mask2_5;
end


always @(
  cfg_is_int8_d1
  or cfg_is_wg_d1
  or pp_in_l1n4_2
  or pp_in_l1n4_3
  or pp_out_l1n5_0
  or pp_out_l1n5_1
  ) begin
    mask2_6 = {2'b0, {2{cfg_is_int8_d1[10]}}, 17'h1ffff, {2{~cfg_is_int8_d1[10]}}, 19'h7ffff};
    pp_in_l2n6_0 = ~cfg_is_wg_d1[6] ? 42'b0 : pp_in_l1n4_2;
    pp_in_l2n6_1 = ~cfg_is_wg_d1[6] ? 42'b0 : pp_in_l1n4_3;
    pp_in_l2n6_2 = ~cfg_is_wg_d1[6] ? 42'b0 : ~pp_out_l1n5_0 & mask2_6;
    pp_in_l2n6_3 = ~cfg_is_wg_d1[6] ? 42'b0 : ~pp_out_l1n5_1 & mask2_6;
end


always @(
  cfg_is_int8_d1
  or cfg_is_wg_d1
  or pp_in_l1n6_2
  or pp_in_l1n6_3
  or pp_out_l1n7_0
  or pp_out_l1n7_1
  ) begin
    mask2_7 = {2'b0, {2{cfg_is_int8_d1[11]}}, 17'h1ffff, {2{~cfg_is_int8_d1[11]}}, 19'h7ffff};
    pp_in_l2n7_0 = ~cfg_is_wg_d1[7] ? 42'b0 : pp_in_l1n6_2;
    pp_in_l2n7_1 = ~cfg_is_wg_d1[7] ? 42'b0 : pp_in_l1n6_3;
    pp_in_l2n7_2 = ~cfg_is_wg_d1[7] ? 42'b0 : ~pp_out_l1n7_0 & mask2_7;
    pp_in_l2n7_3 = ~cfg_is_wg_d1[7] ? 42'b0 : ~pp_out_l1n7_1 & mask2_7;
end




///////////////////////////////////////////////////////////////////////////////////
//////////////// assemble input for CSA tree level 2 (second half) ////////////////
///////////////////////////////////////////////////////////////////////////////////

always @(
  pp_in_l2n4_3
  or pp_in_l2n4_2
  or pp_in_l2n4_1
  or pp_in_l2n4_0
  ) begin
    pp_in_l2n4 = {pp_in_l2n4_3, pp_in_l2n4_2, pp_in_l2n4_1, pp_in_l2n4_0};
end


always @(
  pp_in_l2n5_3
  or pp_in_l2n5_2
  or pp_in_l2n5_1
  or pp_in_l2n5_0
  ) begin
    pp_in_l2n5 = {pp_in_l2n5_3, pp_in_l2n5_2, pp_in_l2n5_1, pp_in_l2n5_0};
end


always @(
  pp_in_l2n6_3
  or pp_in_l2n6_2
  or pp_in_l2n6_1
  or pp_in_l2n6_0
  ) begin
    pp_in_l2n6 = {pp_in_l2n6_3, pp_in_l2n6_2, pp_in_l2n6_1, pp_in_l2n6_0};
end


always @(
  pp_in_l2n7_3
  or pp_in_l2n7_2
  or pp_in_l2n7_1
  or pp_in_l2n7_0
  ) begin
    pp_in_l2n7 = {pp_in_l2n7_3, pp_in_l2n7_2, pp_in_l2n7_1, pp_in_l2n7_0};
end




////////////////////////////////////////////////////////////////////////
//////////////// CSA tree level 2 (second half): for WG ////////////////
////////////////////////////////////////////////////////////////////////

`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l2n4 (
   .INPUT              (pp_in_l2n4[167:0])     //|< r
  ,.OUT0               (pp_out_l2n4_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n4_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l2n4 (
   .INPUT              (pp_in_l2n4[167:0])     //|< r
  ,.OUT0               (pp_out_l2n4_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n4_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l2n5 (
   .INPUT              (pp_in_l2n5[167:0])     //|< r
  ,.OUT0               (pp_out_l2n5_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n5_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l2n5 (
   .INPUT              (pp_in_l2n5[167:0])     //|< r
  ,.OUT0               (pp_out_l2n5_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n5_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l2n6 (
   .INPUT              (pp_in_l2n6[167:0])     //|< r
  ,.OUT0               (pp_out_l2n6_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n6_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l2n6 (
   .INPUT              (pp_in_l2n6[167:0])     //|< r
  ,.OUT0               (pp_out_l2n6_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n6_1[41:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 42) u_tree_l2n7 (
   .INPUT              (pp_in_l2n7[167:0])     //|< r
  ,.OUT0               (pp_out_l2n7_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n7_1[41:0])   //|> w
  );
`else 
DW02_tree #(4, 42) u_tree_l2n7 (
   .INPUT              (pp_in_l2n7[167:0])     //|< r
  ,.OUT0               (pp_out_l2n7_0[41:0])   //|> w
  ,.OUT1               (pp_out_l2n7_1[41:0])   //|> w
  );
`endif 





//==========================================================
// MAC cell CSA tree level 0
// FP16 sign tag process
//==========================================================

assign res_tag_b0_sum_0[2:0] = res_tag_b0_d1[0*4] + res_tag_b0_d1[0*4+1] + res_tag_b0_d1[0*4+2] + res_tag_b0_d1[0*4+3];
assign res_tag_b0_sum_1[2:0] = res_tag_b0_d1[1*4] + res_tag_b0_d1[1*4+1] + res_tag_b0_d1[1*4+2] + res_tag_b0_d1[1*4+3];
assign res_tag_b0_sum_2[2:0] = res_tag_b0_d1[2*4] + res_tag_b0_d1[2*4+1] + res_tag_b0_d1[2*4+2] + res_tag_b0_d1[2*4+3];
assign res_tag_b0_sum_3[2:0] = res_tag_b0_d1[3*4] + res_tag_b0_d1[3*4+1] + res_tag_b0_d1[3*4+2] + res_tag_b0_d1[3*4+3];
assign res_tag_b0_sum_4[2:0] = res_tag_b0_d1[4*4] + res_tag_b0_d1[4*4+1] + res_tag_b0_d1[4*4+2] + res_tag_b0_d1[4*4+3];
assign res_tag_b0_sum_5[2:0] = res_tag_b0_d1[5*4] + res_tag_b0_d1[5*4+1] + res_tag_b0_d1[5*4+2] + res_tag_b0_d1[5*4+3];
assign res_tag_b0_sum_6[2:0] = res_tag_b0_d1[6*4] + res_tag_b0_d1[6*4+1] + res_tag_b0_d1[6*4+2] + res_tag_b0_d1[6*4+3];
assign res_tag_b0_sum_7[2:0] = res_tag_b0_d1[7*4] + res_tag_b0_d1[7*4+1] + res_tag_b0_d1[7*4+2] + res_tag_b0_d1[7*4+3];
assign res_tag_b0_sum_8[2:0] = res_tag_b0_d1[8*4] + res_tag_b0_d1[8*4+1] + res_tag_b0_d1[8*4+2] + res_tag_b0_d1[8*4+3];
assign res_tag_b0_sum_9[2:0] = res_tag_b0_d1[9*4] + res_tag_b0_d1[9*4+1] + res_tag_b0_d1[9*4+2] + res_tag_b0_d1[9*4+3];
assign res_tag_b0_sum_10[2:0] = res_tag_b0_d1[10*4] + res_tag_b0_d1[10*4+1] + res_tag_b0_d1[10*4+2] + res_tag_b0_d1[10*4+3];
assign res_tag_b0_sum_11[2:0] = res_tag_b0_d1[11*4] + res_tag_b0_d1[11*4+1] + res_tag_b0_d1[11*4+2] + res_tag_b0_d1[11*4+3];
assign res_tag_b0_sum_12[2:0] = res_tag_b0_d1[12*4] + res_tag_b0_d1[12*4+1] + res_tag_b0_d1[12*4+2] + res_tag_b0_d1[12*4+3];
assign res_tag_b0_sum_13[2:0] = res_tag_b0_d1[13*4] + res_tag_b0_d1[13*4+1] + res_tag_b0_d1[13*4+2] + res_tag_b0_d1[13*4+3];
assign res_tag_b0_sum_14[2:0] = res_tag_b0_d1[14*4] + res_tag_b0_d1[14*4+1] + res_tag_b0_d1[14*4+2] + res_tag_b0_d1[14*4+3];
assign res_tag_b0_sum_15[2:0] = res_tag_b0_d1[15*4] + res_tag_b0_d1[15*4+1] + res_tag_b0_d1[15*4+2] + res_tag_b0_d1[15*4+3];
assign res_tag_b1_sum_0[2:0] = res_tag_b1_d1[0*4] + res_tag_b1_d1[0*4+1] + res_tag_b1_d1[0*4+2] + res_tag_b1_d1[0*4+3];
assign res_tag_b1_sum_1[2:0] = res_tag_b1_d1[1*4] + res_tag_b1_d1[1*4+1] + res_tag_b1_d1[1*4+2] + res_tag_b1_d1[1*4+3];
assign res_tag_b1_sum_2[2:0] = res_tag_b1_d1[2*4] + res_tag_b1_d1[2*4+1] + res_tag_b1_d1[2*4+2] + res_tag_b1_d1[2*4+3];
assign res_tag_b1_sum_3[2:0] = res_tag_b1_d1[3*4] + res_tag_b1_d1[3*4+1] + res_tag_b1_d1[3*4+2] + res_tag_b1_d1[3*4+3];
assign res_tag_b1_sum_4[2:0] = res_tag_b1_d1[4*4] + res_tag_b1_d1[4*4+1] + res_tag_b1_d1[4*4+2] + res_tag_b1_d1[4*4+3];
assign res_tag_b1_sum_5[2:0] = res_tag_b1_d1[5*4] + res_tag_b1_d1[5*4+1] + res_tag_b1_d1[5*4+2] + res_tag_b1_d1[5*4+3];
assign res_tag_b1_sum_6[2:0] = res_tag_b1_d1[6*4] + res_tag_b1_d1[6*4+1] + res_tag_b1_d1[6*4+2] + res_tag_b1_d1[6*4+3];
assign res_tag_b1_sum_7[2:0] = res_tag_b1_d1[7*4] + res_tag_b1_d1[7*4+1] + res_tag_b1_d1[7*4+2] + res_tag_b1_d1[7*4+3];
assign res_tag_b1_sum_8[2:0] = res_tag_b1_d1[8*4] + res_tag_b1_d1[8*4+1] + res_tag_b1_d1[8*4+2] + res_tag_b1_d1[8*4+3];
assign res_tag_b1_sum_9[2:0] = res_tag_b1_d1[9*4] + res_tag_b1_d1[9*4+1] + res_tag_b1_d1[9*4+2] + res_tag_b1_d1[9*4+3];
assign res_tag_b1_sum_10[2:0] = res_tag_b1_d1[10*4] + res_tag_b1_d1[10*4+1] + res_tag_b1_d1[10*4+2] + res_tag_b1_d1[10*4+3];
assign res_tag_b1_sum_11[2:0] = res_tag_b1_d1[11*4] + res_tag_b1_d1[11*4+1] + res_tag_b1_d1[11*4+2] + res_tag_b1_d1[11*4+3];
assign res_tag_b1_sum_12[2:0] = res_tag_b1_d1[12*4] + res_tag_b1_d1[12*4+1] + res_tag_b1_d1[12*4+2] + res_tag_b1_d1[12*4+3];
assign res_tag_b1_sum_13[2:0] = res_tag_b1_d1[13*4] + res_tag_b1_d1[13*4+1] + res_tag_b1_d1[13*4+2] + res_tag_b1_d1[13*4+3];
assign res_tag_b1_sum_14[2:0] = res_tag_b1_d1[14*4] + res_tag_b1_d1[14*4+1] + res_tag_b1_d1[14*4+2] + res_tag_b1_d1[14*4+3];
assign res_tag_b1_sum_15[2:0] = res_tag_b1_d1[15*4] + res_tag_b1_d1[15*4+1] + res_tag_b1_d1[15*4+2] + res_tag_b1_d1[15*4+3];
assign res_tag_b2_sum_0[2:0] = res_tag_b2_d1[0*4] + res_tag_b2_d1[0*4+1] + res_tag_b2_d1[0*4+2] + res_tag_b2_d1[0*4+3];
assign res_tag_b2_sum_1[2:0] = res_tag_b2_d1[1*4] + res_tag_b2_d1[1*4+1] + res_tag_b2_d1[1*4+2] + res_tag_b2_d1[1*4+3];
assign res_tag_b2_sum_2[2:0] = res_tag_b2_d1[2*4] + res_tag_b2_d1[2*4+1] + res_tag_b2_d1[2*4+2] + res_tag_b2_d1[2*4+3];
assign res_tag_b2_sum_3[2:0] = res_tag_b2_d1[3*4] + res_tag_b2_d1[3*4+1] + res_tag_b2_d1[3*4+2] + res_tag_b2_d1[3*4+3];
assign res_tag_b2_sum_4[2:0] = res_tag_b2_d1[4*4] + res_tag_b2_d1[4*4+1] + res_tag_b2_d1[4*4+2] + res_tag_b2_d1[4*4+3];
assign res_tag_b2_sum_5[2:0] = res_tag_b2_d1[5*4] + res_tag_b2_d1[5*4+1] + res_tag_b2_d1[5*4+2] + res_tag_b2_d1[5*4+3];
assign res_tag_b2_sum_6[2:0] = res_tag_b2_d1[6*4] + res_tag_b2_d1[6*4+1] + res_tag_b2_d1[6*4+2] + res_tag_b2_d1[6*4+3];
assign res_tag_b2_sum_7[2:0] = res_tag_b2_d1[7*4] + res_tag_b2_d1[7*4+1] + res_tag_b2_d1[7*4+2] + res_tag_b2_d1[7*4+3];
assign res_tag_b2_sum_8[2:0] = res_tag_b2_d1[8*4] + res_tag_b2_d1[8*4+1] + res_tag_b2_d1[8*4+2] + res_tag_b2_d1[8*4+3];
assign res_tag_b2_sum_9[2:0] = res_tag_b2_d1[9*4] + res_tag_b2_d1[9*4+1] + res_tag_b2_d1[9*4+2] + res_tag_b2_d1[9*4+3];
assign res_tag_b2_sum_10[2:0] = res_tag_b2_d1[10*4] + res_tag_b2_d1[10*4+1] + res_tag_b2_d1[10*4+2] + res_tag_b2_d1[10*4+3];
assign res_tag_b2_sum_11[2:0] = res_tag_b2_d1[11*4] + res_tag_b2_d1[11*4+1] + res_tag_b2_d1[11*4+2] + res_tag_b2_d1[11*4+3];
assign res_tag_b2_sum_12[2:0] = res_tag_b2_d1[12*4] + res_tag_b2_d1[12*4+1] + res_tag_b2_d1[12*4+2] + res_tag_b2_d1[12*4+3];
assign res_tag_b2_sum_13[2:0] = res_tag_b2_d1[13*4] + res_tag_b2_d1[13*4+1] + res_tag_b2_d1[13*4+2] + res_tag_b2_d1[13*4+3];
assign res_tag_b2_sum_14[2:0] = res_tag_b2_d1[14*4] + res_tag_b2_d1[14*4+1] + res_tag_b2_d1[14*4+2] + res_tag_b2_d1[14*4+3];
assign res_tag_b2_sum_15[2:0] = res_tag_b2_d1[15*4] + res_tag_b2_d1[15*4+1] + res_tag_b2_d1[15*4+2] + res_tag_b2_d1[15*4+3];
assign res_tag_b3_sum_0[2:0] = res_tag_b3_d1[0*4] + res_tag_b3_d1[0*4+1] + res_tag_b3_d1[0*4+2] + res_tag_b3_d1[0*4+3];
assign res_tag_b3_sum_1[2:0] = res_tag_b3_d1[1*4] + res_tag_b3_d1[1*4+1] + res_tag_b3_d1[1*4+2] + res_tag_b3_d1[1*4+3];
assign res_tag_b3_sum_2[2:0] = res_tag_b3_d1[2*4] + res_tag_b3_d1[2*4+1] + res_tag_b3_d1[2*4+2] + res_tag_b3_d1[2*4+3];
assign res_tag_b3_sum_3[2:0] = res_tag_b3_d1[3*4] + res_tag_b3_d1[3*4+1] + res_tag_b3_d1[3*4+2] + res_tag_b3_d1[3*4+3];
assign res_tag_b3_sum_4[2:0] = res_tag_b3_d1[4*4] + res_tag_b3_d1[4*4+1] + res_tag_b3_d1[4*4+2] + res_tag_b3_d1[4*4+3];
assign res_tag_b3_sum_5[2:0] = res_tag_b3_d1[5*4] + res_tag_b3_d1[5*4+1] + res_tag_b3_d1[5*4+2] + res_tag_b3_d1[5*4+3];
assign res_tag_b3_sum_6[2:0] = res_tag_b3_d1[6*4] + res_tag_b3_d1[6*4+1] + res_tag_b3_d1[6*4+2] + res_tag_b3_d1[6*4+3];
assign res_tag_b3_sum_7[2:0] = res_tag_b3_d1[7*4] + res_tag_b3_d1[7*4+1] + res_tag_b3_d1[7*4+2] + res_tag_b3_d1[7*4+3];
assign res_tag_b3_sum_8[2:0] = res_tag_b3_d1[8*4] + res_tag_b3_d1[8*4+1] + res_tag_b3_d1[8*4+2] + res_tag_b3_d1[8*4+3];
assign res_tag_b3_sum_9[2:0] = res_tag_b3_d1[9*4] + res_tag_b3_d1[9*4+1] + res_tag_b3_d1[9*4+2] + res_tag_b3_d1[9*4+3];
assign res_tag_b3_sum_10[2:0] = res_tag_b3_d1[10*4] + res_tag_b3_d1[10*4+1] + res_tag_b3_d1[10*4+2] + res_tag_b3_d1[10*4+3];
assign res_tag_b3_sum_11[2:0] = res_tag_b3_d1[11*4] + res_tag_b3_d1[11*4+1] + res_tag_b3_d1[11*4+2] + res_tag_b3_d1[11*4+3];
assign res_tag_b3_sum_12[2:0] = res_tag_b3_d1[12*4] + res_tag_b3_d1[12*4+1] + res_tag_b3_d1[12*4+2] + res_tag_b3_d1[12*4+3];
assign res_tag_b3_sum_13[2:0] = res_tag_b3_d1[13*4] + res_tag_b3_d1[13*4+1] + res_tag_b3_d1[13*4+2] + res_tag_b3_d1[13*4+3];
assign res_tag_b3_sum_14[2:0] = res_tag_b3_d1[14*4] + res_tag_b3_d1[14*4+1] + res_tag_b3_d1[14*4+2] + res_tag_b3_d1[14*4+3];
assign res_tag_b3_sum_15[2:0] = res_tag_b3_d1[15*4] + res_tag_b3_d1[15*4+1] + res_tag_b3_d1[15*4+2] + res_tag_b3_d1[15*4+3];
assign res_tag_b4_sum_0[2:0] = res_tag_b4_d1[0*4] + res_tag_b4_d1[0*4+1] + res_tag_b4_d1[0*4+2] + res_tag_b4_d1[0*4+3];
assign res_tag_b4_sum_1[2:0] = res_tag_b4_d1[1*4] + res_tag_b4_d1[1*4+1] + res_tag_b4_d1[1*4+2] + res_tag_b4_d1[1*4+3];
assign res_tag_b4_sum_2[2:0] = res_tag_b4_d1[2*4] + res_tag_b4_d1[2*4+1] + res_tag_b4_d1[2*4+2] + res_tag_b4_d1[2*4+3];
assign res_tag_b4_sum_3[2:0] = res_tag_b4_d1[3*4] + res_tag_b4_d1[3*4+1] + res_tag_b4_d1[3*4+2] + res_tag_b4_d1[3*4+3];
assign res_tag_b4_sum_4[2:0] = res_tag_b4_d1[4*4] + res_tag_b4_d1[4*4+1] + res_tag_b4_d1[4*4+2] + res_tag_b4_d1[4*4+3];
assign res_tag_b4_sum_5[2:0] = res_tag_b4_d1[5*4] + res_tag_b4_d1[5*4+1] + res_tag_b4_d1[5*4+2] + res_tag_b4_d1[5*4+3];
assign res_tag_b4_sum_6[2:0] = res_tag_b4_d1[6*4] + res_tag_b4_d1[6*4+1] + res_tag_b4_d1[6*4+2] + res_tag_b4_d1[6*4+3];
assign res_tag_b4_sum_7[2:0] = res_tag_b4_d1[7*4] + res_tag_b4_d1[7*4+1] + res_tag_b4_d1[7*4+2] + res_tag_b4_d1[7*4+3];
assign res_tag_b4_sum_8[2:0] = res_tag_b4_d1[8*4] + res_tag_b4_d1[8*4+1] + res_tag_b4_d1[8*4+2] + res_tag_b4_d1[8*4+3];
assign res_tag_b4_sum_9[2:0] = res_tag_b4_d1[9*4] + res_tag_b4_d1[9*4+1] + res_tag_b4_d1[9*4+2] + res_tag_b4_d1[9*4+3];
assign res_tag_b4_sum_10[2:0] = res_tag_b4_d1[10*4] + res_tag_b4_d1[10*4+1] + res_tag_b4_d1[10*4+2] + res_tag_b4_d1[10*4+3];
assign res_tag_b4_sum_11[2:0] = res_tag_b4_d1[11*4] + res_tag_b4_d1[11*4+1] + res_tag_b4_d1[11*4+2] + res_tag_b4_d1[11*4+3];
assign res_tag_b4_sum_12[2:0] = res_tag_b4_d1[12*4] + res_tag_b4_d1[12*4+1] + res_tag_b4_d1[12*4+2] + res_tag_b4_d1[12*4+3];
assign res_tag_b4_sum_13[2:0] = res_tag_b4_d1[13*4] + res_tag_b4_d1[13*4+1] + res_tag_b4_d1[13*4+2] + res_tag_b4_d1[13*4+3];
assign res_tag_b4_sum_14[2:0] = res_tag_b4_d1[14*4] + res_tag_b4_d1[14*4+1] + res_tag_b4_d1[14*4+2] + res_tag_b4_d1[14*4+3];
assign res_tag_b4_sum_15[2:0] = res_tag_b4_d1[15*4] + res_tag_b4_d1[15*4+1] + res_tag_b4_d1[15*4+2] + res_tag_b4_d1[15*4+3];
assign res_tag_b5_sum_0[2:0] = res_tag_b5_d1[0*4] + res_tag_b5_d1[0*4+1] + res_tag_b5_d1[0*4+2] + res_tag_b5_d1[0*4+3];
assign res_tag_b5_sum_1[2:0] = res_tag_b5_d1[1*4] + res_tag_b5_d1[1*4+1] + res_tag_b5_d1[1*4+2] + res_tag_b5_d1[1*4+3];
assign res_tag_b5_sum_2[2:0] = res_tag_b5_d1[2*4] + res_tag_b5_d1[2*4+1] + res_tag_b5_d1[2*4+2] + res_tag_b5_d1[2*4+3];
assign res_tag_b5_sum_3[2:0] = res_tag_b5_d1[3*4] + res_tag_b5_d1[3*4+1] + res_tag_b5_d1[3*4+2] + res_tag_b5_d1[3*4+3];
assign res_tag_b5_sum_4[2:0] = res_tag_b5_d1[4*4] + res_tag_b5_d1[4*4+1] + res_tag_b5_d1[4*4+2] + res_tag_b5_d1[4*4+3];
assign res_tag_b5_sum_5[2:0] = res_tag_b5_d1[5*4] + res_tag_b5_d1[5*4+1] + res_tag_b5_d1[5*4+2] + res_tag_b5_d1[5*4+3];
assign res_tag_b5_sum_6[2:0] = res_tag_b5_d1[6*4] + res_tag_b5_d1[6*4+1] + res_tag_b5_d1[6*4+2] + res_tag_b5_d1[6*4+3];
assign res_tag_b5_sum_7[2:0] = res_tag_b5_d1[7*4] + res_tag_b5_d1[7*4+1] + res_tag_b5_d1[7*4+2] + res_tag_b5_d1[7*4+3];
assign res_tag_b5_sum_8[2:0] = res_tag_b5_d1[8*4] + res_tag_b5_d1[8*4+1] + res_tag_b5_d1[8*4+2] + res_tag_b5_d1[8*4+3];
assign res_tag_b5_sum_9[2:0] = res_tag_b5_d1[9*4] + res_tag_b5_d1[9*4+1] + res_tag_b5_d1[9*4+2] + res_tag_b5_d1[9*4+3];
assign res_tag_b5_sum_10[2:0] = res_tag_b5_d1[10*4] + res_tag_b5_d1[10*4+1] + res_tag_b5_d1[10*4+2] + res_tag_b5_d1[10*4+3];
assign res_tag_b5_sum_11[2:0] = res_tag_b5_d1[11*4] + res_tag_b5_d1[11*4+1] + res_tag_b5_d1[11*4+2] + res_tag_b5_d1[11*4+3];
assign res_tag_b5_sum_12[2:0] = res_tag_b5_d1[12*4] + res_tag_b5_d1[12*4+1] + res_tag_b5_d1[12*4+2] + res_tag_b5_d1[12*4+3];
assign res_tag_b5_sum_13[2:0] = res_tag_b5_d1[13*4] + res_tag_b5_d1[13*4+1] + res_tag_b5_d1[13*4+2] + res_tag_b5_d1[13*4+3];
assign res_tag_b5_sum_14[2:0] = res_tag_b5_d1[14*4] + res_tag_b5_d1[14*4+1] + res_tag_b5_d1[14*4+2] + res_tag_b5_d1[14*4+3];
assign res_tag_b5_sum_15[2:0] = res_tag_b5_d1[15*4] + res_tag_b5_d1[15*4+1] + res_tag_b5_d1[15*4+2] + res_tag_b5_d1[15*4+3];
assign res_tag_b6_sum_0[2:0] = res_tag_b6_d1[0*4] + res_tag_b6_d1[0*4+1] + res_tag_b6_d1[0*4+2] + res_tag_b6_d1[0*4+3];
assign res_tag_b6_sum_1[2:0] = res_tag_b6_d1[1*4] + res_tag_b6_d1[1*4+1] + res_tag_b6_d1[1*4+2] + res_tag_b6_d1[1*4+3];
assign res_tag_b6_sum_2[2:0] = res_tag_b6_d1[2*4] + res_tag_b6_d1[2*4+1] + res_tag_b6_d1[2*4+2] + res_tag_b6_d1[2*4+3];
assign res_tag_b6_sum_3[2:0] = res_tag_b6_d1[3*4] + res_tag_b6_d1[3*4+1] + res_tag_b6_d1[3*4+2] + res_tag_b6_d1[3*4+3];
assign res_tag_b6_sum_4[2:0] = res_tag_b6_d1[4*4] + res_tag_b6_d1[4*4+1] + res_tag_b6_d1[4*4+2] + res_tag_b6_d1[4*4+3];
assign res_tag_b6_sum_5[2:0] = res_tag_b6_d1[5*4] + res_tag_b6_d1[5*4+1] + res_tag_b6_d1[5*4+2] + res_tag_b6_d1[5*4+3];
assign res_tag_b6_sum_6[2:0] = res_tag_b6_d1[6*4] + res_tag_b6_d1[6*4+1] + res_tag_b6_d1[6*4+2] + res_tag_b6_d1[6*4+3];
assign res_tag_b6_sum_7[2:0] = res_tag_b6_d1[7*4] + res_tag_b6_d1[7*4+1] + res_tag_b6_d1[7*4+2] + res_tag_b6_d1[7*4+3];
assign res_tag_b6_sum_8[2:0] = res_tag_b6_d1[8*4] + res_tag_b6_d1[8*4+1] + res_tag_b6_d1[8*4+2] + res_tag_b6_d1[8*4+3];
assign res_tag_b6_sum_9[2:0] = res_tag_b6_d1[9*4] + res_tag_b6_d1[9*4+1] + res_tag_b6_d1[9*4+2] + res_tag_b6_d1[9*4+3];
assign res_tag_b6_sum_10[2:0] = res_tag_b6_d1[10*4] + res_tag_b6_d1[10*4+1] + res_tag_b6_d1[10*4+2] + res_tag_b6_d1[10*4+3];
assign res_tag_b6_sum_11[2:0] = res_tag_b6_d1[11*4] + res_tag_b6_d1[11*4+1] + res_tag_b6_d1[11*4+2] + res_tag_b6_d1[11*4+3];
assign res_tag_b6_sum_12[2:0] = res_tag_b6_d1[12*4] + res_tag_b6_d1[12*4+1] + res_tag_b6_d1[12*4+2] + res_tag_b6_d1[12*4+3];
assign res_tag_b6_sum_13[2:0] = res_tag_b6_d1[13*4] + res_tag_b6_d1[13*4+1] + res_tag_b6_d1[13*4+2] + res_tag_b6_d1[13*4+3];
assign res_tag_b6_sum_14[2:0] = res_tag_b6_d1[14*4] + res_tag_b6_d1[14*4+1] + res_tag_b6_d1[14*4+2] + res_tag_b6_d1[14*4+3];
assign res_tag_b6_sum_15[2:0] = res_tag_b6_d1[15*4] + res_tag_b6_d1[15*4+1] + res_tag_b6_d1[15*4+2] + res_tag_b6_d1[15*4+3];
assign res_tag_b7_sum_0[2:0] = res_tag_b7_d1[0*4] + res_tag_b7_d1[0*4+1] + res_tag_b7_d1[0*4+2] + res_tag_b7_d1[0*4+3];
assign res_tag_b7_sum_1[2:0] = res_tag_b7_d1[1*4] + res_tag_b7_d1[1*4+1] + res_tag_b7_d1[1*4+2] + res_tag_b7_d1[1*4+3];
assign res_tag_b7_sum_2[2:0] = res_tag_b7_d1[2*4] + res_tag_b7_d1[2*4+1] + res_tag_b7_d1[2*4+2] + res_tag_b7_d1[2*4+3];
assign res_tag_b7_sum_3[2:0] = res_tag_b7_d1[3*4] + res_tag_b7_d1[3*4+1] + res_tag_b7_d1[3*4+2] + res_tag_b7_d1[3*4+3];
assign res_tag_b7_sum_4[2:0] = res_tag_b7_d1[4*4] + res_tag_b7_d1[4*4+1] + res_tag_b7_d1[4*4+2] + res_tag_b7_d1[4*4+3];
assign res_tag_b7_sum_5[2:0] = res_tag_b7_d1[5*4] + res_tag_b7_d1[5*4+1] + res_tag_b7_d1[5*4+2] + res_tag_b7_d1[5*4+3];
assign res_tag_b7_sum_6[2:0] = res_tag_b7_d1[6*4] + res_tag_b7_d1[6*4+1] + res_tag_b7_d1[6*4+2] + res_tag_b7_d1[6*4+3];
assign res_tag_b7_sum_7[2:0] = res_tag_b7_d1[7*4] + res_tag_b7_d1[7*4+1] + res_tag_b7_d1[7*4+2] + res_tag_b7_d1[7*4+3];
assign res_tag_b7_sum_8[2:0] = res_tag_b7_d1[8*4] + res_tag_b7_d1[8*4+1] + res_tag_b7_d1[8*4+2] + res_tag_b7_d1[8*4+3];
assign res_tag_b7_sum_9[2:0] = res_tag_b7_d1[9*4] + res_tag_b7_d1[9*4+1] + res_tag_b7_d1[9*4+2] + res_tag_b7_d1[9*4+3];
assign res_tag_b7_sum_10[2:0] = res_tag_b7_d1[10*4] + res_tag_b7_d1[10*4+1] + res_tag_b7_d1[10*4+2] + res_tag_b7_d1[10*4+3];
assign res_tag_b7_sum_11[2:0] = res_tag_b7_d1[11*4] + res_tag_b7_d1[11*4+1] + res_tag_b7_d1[11*4+2] + res_tag_b7_d1[11*4+3];
assign res_tag_b7_sum_12[2:0] = res_tag_b7_d1[12*4] + res_tag_b7_d1[12*4+1] + res_tag_b7_d1[12*4+2] + res_tag_b7_d1[12*4+3];
assign res_tag_b7_sum_13[2:0] = res_tag_b7_d1[13*4] + res_tag_b7_d1[13*4+1] + res_tag_b7_d1[13*4+2] + res_tag_b7_d1[13*4+3];
assign res_tag_b7_sum_14[2:0] = res_tag_b7_d1[14*4] + res_tag_b7_d1[14*4+1] + res_tag_b7_d1[14*4+2] + res_tag_b7_d1[14*4+3];
assign res_tag_b7_sum_15[2:0] = res_tag_b7_d1[15*4] + res_tag_b7_d1[15*4+1] + res_tag_b7_d1[15*4+2] + res_tag_b7_d1[15*4+3];




assign ps_n0b0_dc[6:0] = res_tag_b0_sum_15 + res_tag_b0_sum_14 + res_tag_b0_sum_13 + res_tag_b0_sum_12 + res_tag_b0_sum_11 + res_tag_b0_sum_10 + res_tag_b0_sum_9 + res_tag_b0_sum_8 + res_tag_b0_sum_7 + res_tag_b0_sum_6 + res_tag_b0_sum_5 + res_tag_b0_sum_4 + res_tag_b0_sum_3 + res_tag_b0_sum_2 + res_tag_b0_sum_1 + res_tag_b0_sum_0;
assign ps_n0b0_wg[5:0] = res_tag_b0_sum_0  + res_tag_b0_sum_1  + res_tag_b0_sum_2  +
                            res_tag_b0_sum_4  + res_tag_b0_sum_5  + res_tag_b0_sum_6  +
                            res_tag_b0_sum_8  + res_tag_b0_sum_9  + res_tag_b0_sum_10;
assign ps_n0b0[6:0] = (cfg_is_wg_d1[8]) ? {1'b0, ps_n0b0_wg} : ps_n0b0_dc;

assign ps_n1b0[5:0] = res_tag_b0_sum_1  - res_tag_b0_sum_2  - res_tag_b0_sum_3  +
                         res_tag_b0_sum_5  - res_tag_b0_sum_6  - res_tag_b0_sum_7  +
                         res_tag_b0_sum_9  - res_tag_b0_sum_10 - res_tag_b0_sum_11;
assign ps_n1b0[6] = ps_n1b0[5];

assign ps_n2b0[5:0] = res_tag_b0_sum_4  + res_tag_b0_sum_5  + res_tag_b0_sum_6  -
                         res_tag_b0_sum_8  - res_tag_b0_sum_9  - res_tag_b0_sum_10 -
                         res_tag_b0_sum_12 - res_tag_b0_sum_13 - res_tag_b0_sum_14;
assign ps_n2b0[6] = ps_n2b0[5];

assign ps_n3b0[5:0] = res_tag_b0_sum_5  - res_tag_b0_sum_6  - res_tag_b0_sum_7  -
                         res_tag_b0_sum_9  + res_tag_b0_sum_10 + res_tag_b0_sum_11 -
                         res_tag_b0_sum_13 + res_tag_b0_sum_14 + res_tag_b0_sum_15;
assign ps_n3b0[6] = ps_n3b0[5];

assign ps_n0b1_dc[6:0] = res_tag_b1_sum_15 + res_tag_b1_sum_14 + res_tag_b1_sum_13 + res_tag_b1_sum_12 + res_tag_b1_sum_11 + res_tag_b1_sum_10 + res_tag_b1_sum_9 + res_tag_b1_sum_8 + res_tag_b1_sum_7 + res_tag_b1_sum_6 + res_tag_b1_sum_5 + res_tag_b1_sum_4 + res_tag_b1_sum_3 + res_tag_b1_sum_2 + res_tag_b1_sum_1 + res_tag_b1_sum_0;
assign ps_n0b1_wg[5:0] = res_tag_b1_sum_0  + res_tag_b1_sum_1  + res_tag_b1_sum_2  +
                            res_tag_b1_sum_4  + res_tag_b1_sum_5  + res_tag_b1_sum_6  +
                            res_tag_b1_sum_8  + res_tag_b1_sum_9  + res_tag_b1_sum_10;
assign ps_n0b1[6:0] = (cfg_is_wg_d1[9]) ? {1'b0, ps_n0b1_wg} : ps_n0b1_dc;

assign ps_n1b1[5:0] = res_tag_b1_sum_1  - res_tag_b1_sum_2  - res_tag_b1_sum_3  +
                         res_tag_b1_sum_5  - res_tag_b1_sum_6  - res_tag_b1_sum_7  +
                         res_tag_b1_sum_9  - res_tag_b1_sum_10 - res_tag_b1_sum_11;
assign ps_n1b1[6] = ps_n1b1[5];

assign ps_n2b1[5:0] = res_tag_b1_sum_4  + res_tag_b1_sum_5  + res_tag_b1_sum_6  -
                         res_tag_b1_sum_8  - res_tag_b1_sum_9  - res_tag_b1_sum_10 -
                         res_tag_b1_sum_12 - res_tag_b1_sum_13 - res_tag_b1_sum_14;
assign ps_n2b1[6] = ps_n2b1[5];

assign ps_n3b1[5:0] = res_tag_b1_sum_5  - res_tag_b1_sum_6  - res_tag_b1_sum_7  -
                         res_tag_b1_sum_9  + res_tag_b1_sum_10 + res_tag_b1_sum_11 -
                         res_tag_b1_sum_13 + res_tag_b1_sum_14 + res_tag_b1_sum_15;
assign ps_n3b1[6] = ps_n3b1[5];

assign ps_n0b2_dc[6:0] = res_tag_b2_sum_15 + res_tag_b2_sum_14 + res_tag_b2_sum_13 + res_tag_b2_sum_12 + res_tag_b2_sum_11 + res_tag_b2_sum_10 + res_tag_b2_sum_9 + res_tag_b2_sum_8 + res_tag_b2_sum_7 + res_tag_b2_sum_6 + res_tag_b2_sum_5 + res_tag_b2_sum_4 + res_tag_b2_sum_3 + res_tag_b2_sum_2 + res_tag_b2_sum_1 + res_tag_b2_sum_0;
assign ps_n0b2_wg[5:0] = res_tag_b2_sum_0  + res_tag_b2_sum_1  + res_tag_b2_sum_2  +
                            res_tag_b2_sum_4  + res_tag_b2_sum_5  + res_tag_b2_sum_6  +
                            res_tag_b2_sum_8  + res_tag_b2_sum_9  + res_tag_b2_sum_10;
assign ps_n0b2[6:0] = (cfg_is_wg_d1[10]) ? {1'b0, ps_n0b2_wg} : ps_n0b2_dc;

assign ps_n1b2[5:0] = res_tag_b2_sum_1  - res_tag_b2_sum_2  - res_tag_b2_sum_3  +
                         res_tag_b2_sum_5  - res_tag_b2_sum_6  - res_tag_b2_sum_7  +
                         res_tag_b2_sum_9  - res_tag_b2_sum_10 - res_tag_b2_sum_11;
assign ps_n1b2[6] = ps_n1b2[5];

assign ps_n2b2[5:0] = res_tag_b2_sum_4  + res_tag_b2_sum_5  + res_tag_b2_sum_6  -
                         res_tag_b2_sum_8  - res_tag_b2_sum_9  - res_tag_b2_sum_10 -
                         res_tag_b2_sum_12 - res_tag_b2_sum_13 - res_tag_b2_sum_14;
assign ps_n2b2[6] = ps_n2b2[5];

assign ps_n3b2[5:0] = res_tag_b2_sum_5  - res_tag_b2_sum_6  - res_tag_b2_sum_7  -
                         res_tag_b2_sum_9  + res_tag_b2_sum_10 + res_tag_b2_sum_11 -
                         res_tag_b2_sum_13 + res_tag_b2_sum_14 + res_tag_b2_sum_15;
assign ps_n3b2[6] = ps_n3b2[5];

assign ps_n0b3_dc[6:0] = res_tag_b3_sum_15 + res_tag_b3_sum_14 + res_tag_b3_sum_13 + res_tag_b3_sum_12 + res_tag_b3_sum_11 + res_tag_b3_sum_10 + res_tag_b3_sum_9 + res_tag_b3_sum_8 + res_tag_b3_sum_7 + res_tag_b3_sum_6 + res_tag_b3_sum_5 + res_tag_b3_sum_4 + res_tag_b3_sum_3 + res_tag_b3_sum_2 + res_tag_b3_sum_1 + res_tag_b3_sum_0;
assign ps_n0b3_wg[5:0] = res_tag_b3_sum_0  + res_tag_b3_sum_1  + res_tag_b3_sum_2  +
                            res_tag_b3_sum_4  + res_tag_b3_sum_5  + res_tag_b3_sum_6  +
                            res_tag_b3_sum_8  + res_tag_b3_sum_9  + res_tag_b3_sum_10;
assign ps_n0b3[6:0] = (cfg_is_wg_d1[11]) ? {1'b0, ps_n0b3_wg} : ps_n0b3_dc;

assign ps_n1b3[5:0] = res_tag_b3_sum_1  - res_tag_b3_sum_2  - res_tag_b3_sum_3  +
                         res_tag_b3_sum_5  - res_tag_b3_sum_6  - res_tag_b3_sum_7  +
                         res_tag_b3_sum_9  - res_tag_b3_sum_10 - res_tag_b3_sum_11;
assign ps_n1b3[6] = ps_n1b3[5];

assign ps_n2b3[5:0] = res_tag_b3_sum_4  + res_tag_b3_sum_5  + res_tag_b3_sum_6  -
                         res_tag_b3_sum_8  - res_tag_b3_sum_9  - res_tag_b3_sum_10 -
                         res_tag_b3_sum_12 - res_tag_b3_sum_13 - res_tag_b3_sum_14;
assign ps_n2b3[6] = ps_n2b3[5];

assign ps_n3b3[5:0] = res_tag_b3_sum_5  - res_tag_b3_sum_6  - res_tag_b3_sum_7  -
                         res_tag_b3_sum_9  + res_tag_b3_sum_10 + res_tag_b3_sum_11 -
                         res_tag_b3_sum_13 + res_tag_b3_sum_14 + res_tag_b3_sum_15;
assign ps_n3b3[6] = ps_n3b3[5];

assign ps_n0b4_dc[6:0] = res_tag_b4_sum_15 + res_tag_b4_sum_14 + res_tag_b4_sum_13 + res_tag_b4_sum_12 + res_tag_b4_sum_11 + res_tag_b4_sum_10 + res_tag_b4_sum_9 + res_tag_b4_sum_8 + res_tag_b4_sum_7 + res_tag_b4_sum_6 + res_tag_b4_sum_5 + res_tag_b4_sum_4 + res_tag_b4_sum_3 + res_tag_b4_sum_2 + res_tag_b4_sum_1 + res_tag_b4_sum_0;
assign ps_n0b4_wg[5:0] = res_tag_b4_sum_0  + res_tag_b4_sum_1  + res_tag_b4_sum_2  +
                            res_tag_b4_sum_4  + res_tag_b4_sum_5  + res_tag_b4_sum_6  +
                            res_tag_b4_sum_8  + res_tag_b4_sum_9  + res_tag_b4_sum_10;
assign ps_n0b4[6:0] = (cfg_is_wg_d1[12]) ? {1'b0, ps_n0b4_wg} : ps_n0b4_dc;

assign ps_n1b4[5:0] = res_tag_b4_sum_1  - res_tag_b4_sum_2  - res_tag_b4_sum_3  +
                         res_tag_b4_sum_5  - res_tag_b4_sum_6  - res_tag_b4_sum_7  +
                         res_tag_b4_sum_9  - res_tag_b4_sum_10 - res_tag_b4_sum_11;
assign ps_n1b4[6] = ps_n1b4[5];

assign ps_n2b4[5:0] = res_tag_b4_sum_4  + res_tag_b4_sum_5  + res_tag_b4_sum_6  -
                         res_tag_b4_sum_8  - res_tag_b4_sum_9  - res_tag_b4_sum_10 -
                         res_tag_b4_sum_12 - res_tag_b4_sum_13 - res_tag_b4_sum_14;
assign ps_n2b4[6] = ps_n2b4[5];

assign ps_n3b4[5:0] = res_tag_b4_sum_5  - res_tag_b4_sum_6  - res_tag_b4_sum_7  -
                         res_tag_b4_sum_9  + res_tag_b4_sum_10 + res_tag_b4_sum_11 -
                         res_tag_b4_sum_13 + res_tag_b4_sum_14 + res_tag_b4_sum_15;
assign ps_n3b4[6] = ps_n3b4[5];

assign ps_n0b5_dc[6:0] = res_tag_b5_sum_15 + res_tag_b5_sum_14 + res_tag_b5_sum_13 + res_tag_b5_sum_12 + res_tag_b5_sum_11 + res_tag_b5_sum_10 + res_tag_b5_sum_9 + res_tag_b5_sum_8 + res_tag_b5_sum_7 + res_tag_b5_sum_6 + res_tag_b5_sum_5 + res_tag_b5_sum_4 + res_tag_b5_sum_3 + res_tag_b5_sum_2 + res_tag_b5_sum_1 + res_tag_b5_sum_0;
assign ps_n0b5_wg[5:0] = res_tag_b5_sum_0  + res_tag_b5_sum_1  + res_tag_b5_sum_2  +
                            res_tag_b5_sum_4  + res_tag_b5_sum_5  + res_tag_b5_sum_6  +
                            res_tag_b5_sum_8  + res_tag_b5_sum_9  + res_tag_b5_sum_10;
assign ps_n0b5[6:0] = (cfg_is_wg_d1[13]) ? {1'b0, ps_n0b5_wg} : ps_n0b5_dc;

assign ps_n1b5[5:0] = res_tag_b5_sum_1  - res_tag_b5_sum_2  - res_tag_b5_sum_3  +
                         res_tag_b5_sum_5  - res_tag_b5_sum_6  - res_tag_b5_sum_7  +
                         res_tag_b5_sum_9  - res_tag_b5_sum_10 - res_tag_b5_sum_11;
assign ps_n1b5[6] = ps_n1b5[5];

assign ps_n2b5[5:0] = res_tag_b5_sum_4  + res_tag_b5_sum_5  + res_tag_b5_sum_6  -
                         res_tag_b5_sum_8  - res_tag_b5_sum_9  - res_tag_b5_sum_10 -
                         res_tag_b5_sum_12 - res_tag_b5_sum_13 - res_tag_b5_sum_14;
assign ps_n2b5[6] = ps_n2b5[5];

assign ps_n3b5[5:0] = res_tag_b5_sum_5  - res_tag_b5_sum_6  - res_tag_b5_sum_7  -
                         res_tag_b5_sum_9  + res_tag_b5_sum_10 + res_tag_b5_sum_11 -
                         res_tag_b5_sum_13 + res_tag_b5_sum_14 + res_tag_b5_sum_15;
assign ps_n3b5[6] = ps_n3b5[5];

assign ps_n0b6_dc[6:0] = res_tag_b6_sum_15 + res_tag_b6_sum_14 + res_tag_b6_sum_13 + res_tag_b6_sum_12 + res_tag_b6_sum_11 + res_tag_b6_sum_10 + res_tag_b6_sum_9 + res_tag_b6_sum_8 + res_tag_b6_sum_7 + res_tag_b6_sum_6 + res_tag_b6_sum_5 + res_tag_b6_sum_4 + res_tag_b6_sum_3 + res_tag_b6_sum_2 + res_tag_b6_sum_1 + res_tag_b6_sum_0;
assign ps_n0b6_wg[5:0] = res_tag_b6_sum_0  + res_tag_b6_sum_1  + res_tag_b6_sum_2  +
                            res_tag_b6_sum_4  + res_tag_b6_sum_5  + res_tag_b6_sum_6  +
                            res_tag_b6_sum_8  + res_tag_b6_sum_9  + res_tag_b6_sum_10;
assign ps_n0b6[6:0] = (cfg_is_wg_d1[14]) ? {1'b0, ps_n0b6_wg} : ps_n0b6_dc;

assign ps_n1b6[5:0] = res_tag_b6_sum_1  - res_tag_b6_sum_2  - res_tag_b6_sum_3  +
                         res_tag_b6_sum_5  - res_tag_b6_sum_6  - res_tag_b6_sum_7  +
                         res_tag_b6_sum_9  - res_tag_b6_sum_10 - res_tag_b6_sum_11;
assign ps_n1b6[6] = ps_n1b6[5];

assign ps_n2b6[5:0] = res_tag_b6_sum_4  + res_tag_b6_sum_5  + res_tag_b6_sum_6  -
                         res_tag_b6_sum_8  - res_tag_b6_sum_9  - res_tag_b6_sum_10 -
                         res_tag_b6_sum_12 - res_tag_b6_sum_13 - res_tag_b6_sum_14;
assign ps_n2b6[6] = ps_n2b6[5];

assign ps_n3b6[5:0] = res_tag_b6_sum_5  - res_tag_b6_sum_6  - res_tag_b6_sum_7  -
                         res_tag_b6_sum_9  + res_tag_b6_sum_10 + res_tag_b6_sum_11 -
                         res_tag_b6_sum_13 + res_tag_b6_sum_14 + res_tag_b6_sum_15;
assign ps_n3b6[6] = ps_n3b6[5];

assign ps_n0b7_dc[6:0] = res_tag_b7_sum_15 + res_tag_b7_sum_14 + res_tag_b7_sum_13 + res_tag_b7_sum_12 + res_tag_b7_sum_11 + res_tag_b7_sum_10 + res_tag_b7_sum_9 + res_tag_b7_sum_8 + res_tag_b7_sum_7 + res_tag_b7_sum_6 + res_tag_b7_sum_5 + res_tag_b7_sum_4 + res_tag_b7_sum_3 + res_tag_b7_sum_2 + res_tag_b7_sum_1 + res_tag_b7_sum_0;
assign ps_n0b7_wg[5:0] = res_tag_b7_sum_0  + res_tag_b7_sum_1  + res_tag_b7_sum_2  +
                            res_tag_b7_sum_4  + res_tag_b7_sum_5  + res_tag_b7_sum_6  +
                            res_tag_b7_sum_8  + res_tag_b7_sum_9  + res_tag_b7_sum_10;
assign ps_n0b7[6:0] = (cfg_is_wg_d1[15]) ? {1'b0, ps_n0b7_wg} : ps_n0b7_dc;

assign ps_n1b7[5:0] = res_tag_b7_sum_1  - res_tag_b7_sum_2  - res_tag_b7_sum_3  +
                         res_tag_b7_sum_5  - res_tag_b7_sum_6  - res_tag_b7_sum_7  +
                         res_tag_b7_sum_9  - res_tag_b7_sum_10 - res_tag_b7_sum_11;
assign ps_n1b7[6] = ps_n1b7[5];

assign ps_n2b7[5:0] = res_tag_b7_sum_4  + res_tag_b7_sum_5  + res_tag_b7_sum_6  -
                         res_tag_b7_sum_8  - res_tag_b7_sum_9  - res_tag_b7_sum_10 -
                         res_tag_b7_sum_12 - res_tag_b7_sum_13 - res_tag_b7_sum_14;
assign ps_n2b7[6] = ps_n2b7[5];

assign ps_n3b7[5:0] = res_tag_b7_sum_5  - res_tag_b7_sum_6  - res_tag_b7_sum_7  -
                         res_tag_b7_sum_9  + res_tag_b7_sum_10 + res_tag_b7_sum_11 -
                         res_tag_b7_sum_13 + res_tag_b7_sum_14 + res_tag_b7_sum_15;
assign ps_n3b7[6] = ps_n3b7[5];





//==========================================================
// Level 2 registers
//==========================================================

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[0] & ~pp_nan_pvld_d1[0]) == 1'b1) begin
    pp_out_l2n0_0_d2 <= pp_out_l2n0_0;
  // VCS coverage off
  end else if ((pp_pvld_d1[0] & ~pp_nan_pvld_d1[0]) == 1'b0) begin
  end else begin
    pp_out_l2n0_0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[0] & ~pp_nan_pvld_d1[0]) == 1'b1) begin
    pp_out_l2n0_1_d2 <= pp_out_l2n0_1;
  // VCS coverage off
  end else if ((pp_pvld_d1[0] & ~pp_nan_pvld_d1[0]) == 1'b0) begin
  end else begin
    pp_out_l2n0_1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[1] & ~pp_nan_pvld_d1[1]) == 1'b1) begin
    pp_out_l2n1_0_d2 <= pp_out_l2n1_0;
  // VCS coverage off
  end else if ((pp_pvld_d1[1] & ~pp_nan_pvld_d1[1]) == 1'b0) begin
  end else begin
    pp_out_l2n1_0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[1] & ~pp_nan_pvld_d1[1]) == 1'b1) begin
    pp_out_l2n1_1_d2 <= pp_out_l2n1_1;
  // VCS coverage off
  end else if ((pp_pvld_d1[1] & ~pp_nan_pvld_d1[1]) == 1'b0) begin
  end else begin
    pp_out_l2n1_1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[2] & ~pp_nan_pvld_d1[2]) == 1'b1) begin
    pp_out_l2n2_0_d2 <= pp_out_l2n2_0;
  // VCS coverage off
  end else if ((pp_pvld_d1[2] & ~pp_nan_pvld_d1[2]) == 1'b0) begin
  end else begin
    pp_out_l2n2_0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[2] & ~pp_nan_pvld_d1[2]) == 1'b1) begin
    pp_out_l2n2_1_d2 <= pp_out_l2n2_1;
  // VCS coverage off
  end else if ((pp_pvld_d1[2] & ~pp_nan_pvld_d1[2]) == 1'b0) begin
  end else begin
    pp_out_l2n2_1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[3] & ~pp_nan_pvld_d1[3]) == 1'b1) begin
    pp_out_l2n3_0_d2 <= pp_out_l2n3_0;
  // VCS coverage off
  end else if ((pp_pvld_d1[3] & ~pp_nan_pvld_d1[3]) == 1'b0) begin
  end else begin
    pp_out_l2n3_0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[3] & ~pp_nan_pvld_d1[3]) == 1'b1) begin
    pp_out_l2n3_1_d2 <= pp_out_l2n3_1;
  // VCS coverage off
  end else if ((pp_pvld_d1[3] & ~pp_nan_pvld_d1[3]) == 1'b0) begin
  end else begin
    pp_out_l2n3_1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end





always @(posedge nvdla_wg_clk) begin
  if ((pp_pvld_d1[4] & ~pp_nan_pvld_d1[4] & cfg_is_wg_d1[16]) == 1'b1) begin
    pp_out_l2n4_0_d2 <= pp_out_l2n4_0;
  // VCS coverage off
  end else if ((pp_pvld_d1[4] & ~pp_nan_pvld_d1[4] & cfg_is_wg_d1[16]) == 1'b0) begin
  end else begin
    pp_out_l2n4_0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((pp_pvld_d1[4] & ~pp_nan_pvld_d1[4] & cfg_is_wg_d1[16]) == 1'b1) begin
    pp_out_l2n4_1_d2 <= pp_out_l2n4_1;
  // VCS coverage off
  end else if ((pp_pvld_d1[4] & ~pp_nan_pvld_d1[4] & cfg_is_wg_d1[16]) == 1'b0) begin
  end else begin
    pp_out_l2n4_1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_wg_clk) begin
  if ((pp_pvld_d1[5] & ~pp_nan_pvld_d1[5] & cfg_is_wg_d1[17]) == 1'b1) begin
    pp_out_l2n5_0_d2 <= pp_out_l2n5_0;
  // VCS coverage off
  end else if ((pp_pvld_d1[5] & ~pp_nan_pvld_d1[5] & cfg_is_wg_d1[17]) == 1'b0) begin
  end else begin
    pp_out_l2n5_0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((pp_pvld_d1[5] & ~pp_nan_pvld_d1[5] & cfg_is_wg_d1[17]) == 1'b1) begin
    pp_out_l2n5_1_d2 <= pp_out_l2n5_1;
  // VCS coverage off
  end else if ((pp_pvld_d1[5] & ~pp_nan_pvld_d1[5] & cfg_is_wg_d1[17]) == 1'b0) begin
  end else begin
    pp_out_l2n5_1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_wg_clk) begin
  if ((pp_pvld_d1[6] & ~pp_nan_pvld_d1[6] & cfg_is_wg_d1[18]) == 1'b1) begin
    pp_out_l2n6_0_d2 <= pp_out_l2n6_0;
  // VCS coverage off
  end else if ((pp_pvld_d1[6] & ~pp_nan_pvld_d1[6] & cfg_is_wg_d1[18]) == 1'b0) begin
  end else begin
    pp_out_l2n6_0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((pp_pvld_d1[6] & ~pp_nan_pvld_d1[6] & cfg_is_wg_d1[18]) == 1'b1) begin
    pp_out_l2n6_1_d2 <= pp_out_l2n6_1;
  // VCS coverage off
  end else if ((pp_pvld_d1[6] & ~pp_nan_pvld_d1[6] & cfg_is_wg_d1[18]) == 1'b0) begin
  end else begin
    pp_out_l2n6_1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_wg_clk) begin
  if ((pp_pvld_d1[7] & ~pp_nan_pvld_d1[7] & cfg_is_wg_d1[19]) == 1'b1) begin
    pp_out_l2n7_0_d2 <= pp_out_l2n7_0;
  // VCS coverage off
  end else if ((pp_pvld_d1[7] & ~pp_nan_pvld_d1[7] & cfg_is_wg_d1[19]) == 1'b0) begin
  end else begin
    pp_out_l2n7_0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((pp_pvld_d1[7] & ~pp_nan_pvld_d1[7] & cfg_is_wg_d1[19]) == 1'b1) begin
    pp_out_l2n7_1_d2 <= pp_out_l2n7_1;
  // VCS coverage off
  end else if ((pp_pvld_d1[7] & ~pp_nan_pvld_d1[7] & cfg_is_wg_d1[19]) == 1'b0) begin
  end else begin
    pp_out_l2n7_1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end






always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[8] & cfg_is_fp16_d1[0] & ~pp_nan_pvld_d1[8]) == 1'b1) begin
    ps_n0b0_d2 <= ~ps_n0b0;
  // VCS coverage off
  end else if ((pp_pvld_d1[8] & cfg_is_fp16_d1[0] & ~pp_nan_pvld_d1[8]) == 1'b0) begin
  end else begin
    ps_n0b0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[8] & cfg_is_fp16_d1[0] & cfg_is_wg_d1[20] & ~pp_nan_pvld_d1[8]) == 1'b1) begin
    ps_n1b0_d2 <= ~ps_n1b0;
  // VCS coverage off
  end else if ((pp_pvld_d1[8] & cfg_is_fp16_d1[0] & cfg_is_wg_d1[20] & ~pp_nan_pvld_d1[8]) == 1'b0) begin
  end else begin
    ps_n1b0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[8] & cfg_is_fp16_d1[0] & cfg_is_wg_d1[20] & ~pp_nan_pvld_d1[8]) == 1'b1) begin
    ps_n2b0_d2 <= ~ps_n2b0;
  // VCS coverage off
  end else if ((pp_pvld_d1[8] & cfg_is_fp16_d1[0] & cfg_is_wg_d1[20] & ~pp_nan_pvld_d1[8]) == 1'b0) begin
  end else begin
    ps_n2b0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[8] & cfg_is_fp16_d1[0] & cfg_is_wg_d1[20] & ~pp_nan_pvld_d1[8]) == 1'b1) begin
    ps_n3b0_d2 <= ~ps_n3b0;
  // VCS coverage off
  end else if ((pp_pvld_d1[8] & cfg_is_fp16_d1[0] & cfg_is_wg_d1[20] & ~pp_nan_pvld_d1[8]) == 1'b0) begin
  end else begin
    ps_n3b0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[9] & cfg_is_fp16_d1[1] & ~pp_nan_pvld_d1[9]) == 1'b1) begin
    ps_n0b1_d2 <= ~ps_n0b1;
  // VCS coverage off
  end else if ((pp_pvld_d1[9] & cfg_is_fp16_d1[1] & ~pp_nan_pvld_d1[9]) == 1'b0) begin
  end else begin
    ps_n0b1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[9] & cfg_is_fp16_d1[1] & cfg_is_wg_d1[21] & ~pp_nan_pvld_d1[9]) == 1'b1) begin
    ps_n1b1_d2 <= ~ps_n1b1;
  // VCS coverage off
  end else if ((pp_pvld_d1[9] & cfg_is_fp16_d1[1] & cfg_is_wg_d1[21] & ~pp_nan_pvld_d1[9]) == 1'b0) begin
  end else begin
    ps_n1b1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[9] & cfg_is_fp16_d1[1] & cfg_is_wg_d1[21] & ~pp_nan_pvld_d1[9]) == 1'b1) begin
    ps_n2b1_d2 <= ~ps_n2b1;
  // VCS coverage off
  end else if ((pp_pvld_d1[9] & cfg_is_fp16_d1[1] & cfg_is_wg_d1[21] & ~pp_nan_pvld_d1[9]) == 1'b0) begin
  end else begin
    ps_n2b1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[9] & cfg_is_fp16_d1[1] & cfg_is_wg_d1[21] & ~pp_nan_pvld_d1[9]) == 1'b1) begin
    ps_n3b1_d2 <= ~ps_n3b1;
  // VCS coverage off
  end else if ((pp_pvld_d1[9] & cfg_is_fp16_d1[1] & cfg_is_wg_d1[21] & ~pp_nan_pvld_d1[9]) == 1'b0) begin
  end else begin
    ps_n3b1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[10] & cfg_is_fp16_d1[2] & ~pp_nan_pvld_d1[10]) == 1'b1) begin
    ps_n0b2_d2 <= ~ps_n0b2;
  // VCS coverage off
  end else if ((pp_pvld_d1[10] & cfg_is_fp16_d1[2] & ~pp_nan_pvld_d1[10]) == 1'b0) begin
  end else begin
    ps_n0b2_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[10] & cfg_is_fp16_d1[2] & cfg_is_wg_d1[22] & ~pp_nan_pvld_d1[10]) == 1'b1) begin
    ps_n1b2_d2 <= ~ps_n1b2;
  // VCS coverage off
  end else if ((pp_pvld_d1[10] & cfg_is_fp16_d1[2] & cfg_is_wg_d1[22] & ~pp_nan_pvld_d1[10]) == 1'b0) begin
  end else begin
    ps_n1b2_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[10] & cfg_is_fp16_d1[2] & cfg_is_wg_d1[22] & ~pp_nan_pvld_d1[10]) == 1'b1) begin
    ps_n2b2_d2 <= ~ps_n2b2;
  // VCS coverage off
  end else if ((pp_pvld_d1[10] & cfg_is_fp16_d1[2] & cfg_is_wg_d1[22] & ~pp_nan_pvld_d1[10]) == 1'b0) begin
  end else begin
    ps_n2b2_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[10] & cfg_is_fp16_d1[2] & cfg_is_wg_d1[22] & ~pp_nan_pvld_d1[10]) == 1'b1) begin
    ps_n3b2_d2 <= ~ps_n3b2;
  // VCS coverage off
  end else if ((pp_pvld_d1[10] & cfg_is_fp16_d1[2] & cfg_is_wg_d1[22] & ~pp_nan_pvld_d1[10]) == 1'b0) begin
  end else begin
    ps_n3b2_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[11] & cfg_is_fp16_d1[3] & ~pp_nan_pvld_d1[11]) == 1'b1) begin
    ps_n0b3_d2 <= ~ps_n0b3;
  // VCS coverage off
  end else if ((pp_pvld_d1[11] & cfg_is_fp16_d1[3] & ~pp_nan_pvld_d1[11]) == 1'b0) begin
  end else begin
    ps_n0b3_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[11] & cfg_is_fp16_d1[3] & cfg_is_wg_d1[23] & ~pp_nan_pvld_d1[11]) == 1'b1) begin
    ps_n1b3_d2 <= ~ps_n1b3;
  // VCS coverage off
  end else if ((pp_pvld_d1[11] & cfg_is_fp16_d1[3] & cfg_is_wg_d1[23] & ~pp_nan_pvld_d1[11]) == 1'b0) begin
  end else begin
    ps_n1b3_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[11] & cfg_is_fp16_d1[3] & cfg_is_wg_d1[23] & ~pp_nan_pvld_d1[11]) == 1'b1) begin
    ps_n2b3_d2 <= ~ps_n2b3;
  // VCS coverage off
  end else if ((pp_pvld_d1[11] & cfg_is_fp16_d1[3] & cfg_is_wg_d1[23] & ~pp_nan_pvld_d1[11]) == 1'b0) begin
  end else begin
    ps_n2b3_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[11] & cfg_is_fp16_d1[3] & cfg_is_wg_d1[23] & ~pp_nan_pvld_d1[11]) == 1'b1) begin
    ps_n3b3_d2 <= ~ps_n3b3;
  // VCS coverage off
  end else if ((pp_pvld_d1[11] & cfg_is_fp16_d1[3] & cfg_is_wg_d1[23] & ~pp_nan_pvld_d1[11]) == 1'b0) begin
  end else begin
    ps_n3b3_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[12] & cfg_is_fp16_d1[4] & ~pp_nan_pvld_d1[12]) == 1'b1) begin
    ps_n0b4_d2 <= ~ps_n0b4;
  // VCS coverage off
  end else if ((pp_pvld_d1[12] & cfg_is_fp16_d1[4] & ~pp_nan_pvld_d1[12]) == 1'b0) begin
  end else begin
    ps_n0b4_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[12] & cfg_is_fp16_d1[4] & cfg_is_wg_d1[24] & ~pp_nan_pvld_d1[12]) == 1'b1) begin
    ps_n1b4_d2 <= ~ps_n1b4;
  // VCS coverage off
  end else if ((pp_pvld_d1[12] & cfg_is_fp16_d1[4] & cfg_is_wg_d1[24] & ~pp_nan_pvld_d1[12]) == 1'b0) begin
  end else begin
    ps_n1b4_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[12] & cfg_is_fp16_d1[4] & cfg_is_wg_d1[24] & ~pp_nan_pvld_d1[12]) == 1'b1) begin
    ps_n2b4_d2 <= ~ps_n2b4;
  // VCS coverage off
  end else if ((pp_pvld_d1[12] & cfg_is_fp16_d1[4] & cfg_is_wg_d1[24] & ~pp_nan_pvld_d1[12]) == 1'b0) begin
  end else begin
    ps_n2b4_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[12] & cfg_is_fp16_d1[4] & cfg_is_wg_d1[24] & ~pp_nan_pvld_d1[12]) == 1'b1) begin
    ps_n3b4_d2 <= ~ps_n3b4;
  // VCS coverage off
  end else if ((pp_pvld_d1[12] & cfg_is_fp16_d1[4] & cfg_is_wg_d1[24] & ~pp_nan_pvld_d1[12]) == 1'b0) begin
  end else begin
    ps_n3b4_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[13] & cfg_is_fp16_d1[5] & ~pp_nan_pvld_d1[13]) == 1'b1) begin
    ps_n0b5_d2 <= ~ps_n0b5;
  // VCS coverage off
  end else if ((pp_pvld_d1[13] & cfg_is_fp16_d1[5] & ~pp_nan_pvld_d1[13]) == 1'b0) begin
  end else begin
    ps_n0b5_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[13] & cfg_is_fp16_d1[5] & cfg_is_wg_d1[25] & ~pp_nan_pvld_d1[13]) == 1'b1) begin
    ps_n1b5_d2 <= ~ps_n1b5;
  // VCS coverage off
  end else if ((pp_pvld_d1[13] & cfg_is_fp16_d1[5] & cfg_is_wg_d1[25] & ~pp_nan_pvld_d1[13]) == 1'b0) begin
  end else begin
    ps_n1b5_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[13] & cfg_is_fp16_d1[5] & cfg_is_wg_d1[25] & ~pp_nan_pvld_d1[13]) == 1'b1) begin
    ps_n2b5_d2 <= ~ps_n2b5;
  // VCS coverage off
  end else if ((pp_pvld_d1[13] & cfg_is_fp16_d1[5] & cfg_is_wg_d1[25] & ~pp_nan_pvld_d1[13]) == 1'b0) begin
  end else begin
    ps_n2b5_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[13] & cfg_is_fp16_d1[5] & cfg_is_wg_d1[25] & ~pp_nan_pvld_d1[13]) == 1'b1) begin
    ps_n3b5_d2 <= ~ps_n3b5;
  // VCS coverage off
  end else if ((pp_pvld_d1[13] & cfg_is_fp16_d1[5] & cfg_is_wg_d1[25] & ~pp_nan_pvld_d1[13]) == 1'b0) begin
  end else begin
    ps_n3b5_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[14] & cfg_is_fp16_d1[6] & ~pp_nan_pvld_d1[14]) == 1'b1) begin
    ps_n0b6_d2 <= ~ps_n0b6;
  // VCS coverage off
  end else if ((pp_pvld_d1[14] & cfg_is_fp16_d1[6] & ~pp_nan_pvld_d1[14]) == 1'b0) begin
  end else begin
    ps_n0b6_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[14] & cfg_is_fp16_d1[6] & cfg_is_wg_d1[26] & ~pp_nan_pvld_d1[14]) == 1'b1) begin
    ps_n1b6_d2 <= ~ps_n1b6;
  // VCS coverage off
  end else if ((pp_pvld_d1[14] & cfg_is_fp16_d1[6] & cfg_is_wg_d1[26] & ~pp_nan_pvld_d1[14]) == 1'b0) begin
  end else begin
    ps_n1b6_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[14] & cfg_is_fp16_d1[6] & cfg_is_wg_d1[26] & ~pp_nan_pvld_d1[14]) == 1'b1) begin
    ps_n2b6_d2 <= ~ps_n2b6;
  // VCS coverage off
  end else if ((pp_pvld_d1[14] & cfg_is_fp16_d1[6] & cfg_is_wg_d1[26] & ~pp_nan_pvld_d1[14]) == 1'b0) begin
  end else begin
    ps_n2b6_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[14] & cfg_is_fp16_d1[6] & cfg_is_wg_d1[26] & ~pp_nan_pvld_d1[14]) == 1'b1) begin
    ps_n3b6_d2 <= ~ps_n3b6;
  // VCS coverage off
  end else if ((pp_pvld_d1[14] & cfg_is_fp16_d1[6] & cfg_is_wg_d1[26] & ~pp_nan_pvld_d1[14]) == 1'b0) begin
  end else begin
    ps_n3b6_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[15] & cfg_is_fp16_d1[7] & ~pp_nan_pvld_d1[15]) == 1'b1) begin
    ps_n0b7_d2 <= ~ps_n0b7;
  // VCS coverage off
  end else if ((pp_pvld_d1[15] & cfg_is_fp16_d1[7] & ~pp_nan_pvld_d1[15]) == 1'b0) begin
  end else begin
    ps_n0b7_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[15] & cfg_is_fp16_d1[7] & cfg_is_wg_d1[27] & ~pp_nan_pvld_d1[15]) == 1'b1) begin
    ps_n1b7_d2 <= ~ps_n1b7;
  // VCS coverage off
  end else if ((pp_pvld_d1[15] & cfg_is_fp16_d1[7] & cfg_is_wg_d1[27] & ~pp_nan_pvld_d1[15]) == 1'b0) begin
  end else begin
    ps_n1b7_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[15] & cfg_is_fp16_d1[7] & cfg_is_wg_d1[27] & ~pp_nan_pvld_d1[15]) == 1'b1) begin
    ps_n2b7_d2 <= ~ps_n2b7;
  // VCS coverage off
  end else if ((pp_pvld_d1[15] & cfg_is_fp16_d1[7] & cfg_is_wg_d1[27] & ~pp_nan_pvld_d1[15]) == 1'b0) begin
  end else begin
    ps_n2b7_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((pp_pvld_d1[15] & cfg_is_fp16_d1[7] & cfg_is_wg_d1[27] & ~pp_nan_pvld_d1[15]) == 1'b1) begin
    ps_n3b7_d2 <= ~ps_n3b7;
  // VCS coverage off
  end else if ((pp_pvld_d1[15] & cfg_is_fp16_d1[7] & cfg_is_wg_d1[27] & ~pp_nan_pvld_d1[15]) == 1'b0) begin
  end else begin
    ps_n3b7_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end




always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pp_pvld_d2 <= {5{1'b0}};
  end else begin
  pp_pvld_d2 <= {5{pp_pvld_d1[16]}};
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pp_exp_pvld_d2 <= 1'b0;
  end else begin
  pp_exp_pvld_d2 <= pp_exp_pvld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pp_exp_d2 <= {4{1'b0}};
  end else begin
  if ((pp_exp_pvld_d1) == 1'b1) begin
    pp_exp_d2 <= pp_exp_d1;
  // VCS coverage off
  end else if ((pp_exp_pvld_d1) == 1'b0) begin
  end else begin
    pp_exp_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pp_exp_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pp_nan_pvld_d2 <= {5{1'b0}};
  end else begin
  pp_nan_pvld_d2 <= {5{pp_nan_pvld_d1[16]}};
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pp_nan_mts_d2 <= {11{1'b0}};
  end else begin
  if ((pp_nan_pvld_d1[16]) == 1'b1) begin
    pp_nan_mts_d2 <= pp_nan_mts_d1;
  // VCS coverage off
  end else if ((pp_nan_pvld_d1[16]) == 1'b0) begin
  end else begin
    pp_nan_mts_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_54x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pp_nan_pvld_d1[16]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// MAC cell CSA tree level 3
// for DC: 4(8) -> 2(4)
// for WG: first step of 4x2(2*4x2) -> 2x2(2*2x2)
//==========================================================

////////////////////////////////////////////////////////////
//////////////// input for CSA tree level 3 ////////////////
////////////////////////////////////////////////////////////

always @(
  cfg_is_int8_d2
  or pp_out_l2n0_0_d2
  or pp_out_l2n0_1_d2
  or pp_out_l2n1_0_d2
  or pp_out_l2n1_1_d2
  ) begin
    pp_in_l3n0_0 = ~cfg_is_int8_d2[0] ? {4'b0, pp_out_l2n0_0_d2} : {1'b0, pp_out_l2n0_0_d2[41:21], 3'b0, pp_out_l2n0_0_d2[20:0]};
    pp_in_l3n0_1 = ~cfg_is_int8_d2[0] ? {4'b0, pp_out_l2n0_1_d2} : {1'b0, pp_out_l2n0_1_d2[41:21], 3'b0, pp_out_l2n0_1_d2[20:0]};
    pp_in_l3n0_2 = ~cfg_is_int8_d2[0] ? {4'b0, pp_out_l2n1_0_d2} : {1'b0, pp_out_l2n1_0_d2[41:21], 3'b0, pp_out_l2n1_0_d2[20:0]};
    pp_in_l3n0_3 = ~cfg_is_int8_d2[0] ? {4'b0, pp_out_l2n1_1_d2} : {1'b0, pp_out_l2n1_1_d2[41:21], 3'b0, pp_out_l2n1_1_d2[20:0]};
end


always @(
  cfg_is_int8_d2
  or pp_out_l2n2_0_d2
  or pp_out_l2n2_1_d2
  or pp_out_l2n3_0_d2
  or pp_out_l2n3_1_d2
  ) begin
    pp_in_l3n1_0 = ~cfg_is_int8_d2[1] ? {4'b0, pp_out_l2n2_0_d2} : {1'b0, pp_out_l2n2_0_d2[41:21], 3'b0, pp_out_l2n2_0_d2[20:0]};
    pp_in_l3n1_1 = ~cfg_is_int8_d2[1] ? {4'b0, pp_out_l2n2_1_d2} : {1'b0, pp_out_l2n2_1_d2[41:21], 3'b0, pp_out_l2n2_1_d2[20:0]};
    pp_in_l3n1_2 = ~cfg_is_int8_d2[1] ? {4'b0, pp_out_l2n3_0_d2} : {1'b0, pp_out_l2n3_0_d2[41:21], 3'b0, pp_out_l2n3_0_d2[20:0]};
    pp_in_l3n1_3 = ~cfg_is_int8_d2[1] ? {4'b0, pp_out_l2n3_1_d2} : {1'b0, pp_out_l2n3_1_d2[41:21], 3'b0, pp_out_l2n3_1_d2[20:0]};
end


always @(
  cfg_is_int8_d2
  or pp_out_l2n4_0_d2
  or pp_out_l2n4_1_d2
  or pp_out_l2n5_0_d2
  or pp_out_l2n5_1_d2
  ) begin
    pp_in_l3n2_0 = ~cfg_is_int8_d2[2] ? {4'b0, pp_out_l2n4_0_d2} : {1'b0, pp_out_l2n4_0_d2[41:21], 3'b0, pp_out_l2n4_0_d2[20:0]};
    pp_in_l3n2_1 = ~cfg_is_int8_d2[2] ? {4'b0, pp_out_l2n4_1_d2} : {1'b0, pp_out_l2n4_1_d2[41:21], 3'b0, pp_out_l2n4_1_d2[20:0]};
    pp_in_l3n2_2 = ~cfg_is_int8_d2[2] ? {4'b0, pp_out_l2n5_0_d2} : {1'b0, pp_out_l2n5_0_d2[41:21], 3'b0, pp_out_l2n5_0_d2[20:0]};
    pp_in_l3n2_3 = ~cfg_is_int8_d2[2] ? {4'b0, pp_out_l2n5_1_d2} : {1'b0, pp_out_l2n5_1_d2[41:21], 3'b0, pp_out_l2n5_1_d2[20:0]};
end


always @(
  cfg_is_int8_d2
  or pp_out_l2n6_0_d2
  or pp_out_l2n6_1_d2
  or pp_out_l2n7_0_d2
  or pp_out_l2n7_1_d2
  ) begin
    pp_in_l3n3_0 = ~cfg_is_int8_d2[3] ? {4'b0, pp_out_l2n6_0_d2} : {1'b0, pp_out_l2n6_0_d2[41:21], 3'b0, pp_out_l2n6_0_d2[20:0]};
    pp_in_l3n3_1 = ~cfg_is_int8_d2[3] ? {4'b0, pp_out_l2n6_1_d2} : {1'b0, pp_out_l2n6_1_d2[41:21], 3'b0, pp_out_l2n6_1_d2[20:0]};
    pp_in_l3n3_2 = ~cfg_is_int8_d2[3] ? {4'b0, pp_out_l2n7_0_d2} : {1'b0, pp_out_l2n7_0_d2[41:21], 3'b0, pp_out_l2n7_0_d2[20:0]};
    pp_in_l3n3_3 = ~cfg_is_int8_d2[3] ? {4'b0, pp_out_l2n7_1_d2} : {1'b0, pp_out_l2n7_1_d2[41:21], 3'b0, pp_out_l2n7_1_d2[20:0]};
end




/////////////////////////////////////////////////////////////////////
//////////////// assemble input for CSA tree level 3 ////////////////
/////////////////////////////////////////////////////////////////////

always @(
  pp_in_l3n0_3
  or pp_in_l3n0_2
  or pp_in_l3n0_1
  or pp_in_l3n0_0
  ) begin
    pp_in_l3n0 = {pp_in_l3n0_3, pp_in_l3n0_2, pp_in_l3n0_1, pp_in_l3n0_0};
end


always @(
  pp_in_l3n1_3
  or pp_in_l3n1_2
  or pp_in_l3n1_1
  or pp_in_l3n1_0
  ) begin
    pp_in_l3n1 = {pp_in_l3n1_3, pp_in_l3n1_2, pp_in_l3n1_1, pp_in_l3n1_0};
end


always @(
  pp_in_l3n2_3
  or pp_in_l3n2_2
  or pp_in_l3n2_1
  or pp_in_l3n2_0
  ) begin
    pp_in_l3n2 = {pp_in_l3n2_3, pp_in_l3n2_2, pp_in_l3n2_1, pp_in_l3n2_0};
end


always @(
  pp_in_l3n3_3
  or pp_in_l3n3_2
  or pp_in_l3n3_1
  or pp_in_l3n3_0
  ) begin
    pp_in_l3n3 = {pp_in_l3n3_3, pp_in_l3n3_2, pp_in_l3n3_1, pp_in_l3n3_0};
end




////////////////////////////////////////////////////////
//////////////// CSA tree level 3: 8->4 ////////////////
////////////////////////////////////////////////////////

`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 46) u_tree_l3n0 (
   .INPUT              (pp_in_l3n0[183:0])     //|< r
  ,.OUT0               (pp_out_l3n0_0[45:0])   //|> w
  ,.OUT1               (pp_out_l3n0_1[45:0])   //|> w
  );
`else 
DW02_tree #(4, 46) u_tree_l3n0 (
   .INPUT              (pp_in_l3n0[183:0])     //|< r
  ,.OUT0               (pp_out_l3n0_0[45:0])   //|> w
  ,.OUT1               (pp_out_l3n0_1[45:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 46) u_tree_l3n1 (
   .INPUT              (pp_in_l3n1[183:0])     //|< r
  ,.OUT0               (pp_out_l3n1_0[45:0])   //|> w
  ,.OUT1               (pp_out_l3n1_1[45:0])   //|> w
  );
`else 
DW02_tree #(4, 46) u_tree_l3n1 (
   .INPUT              (pp_in_l3n1[183:0])     //|< r
  ,.OUT0               (pp_out_l3n1_0[45:0])   //|> w
  ,.OUT1               (pp_out_l3n1_1[45:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 46) u_tree_l3n2 (
   .INPUT              (pp_in_l3n2[183:0])     //|< r
  ,.OUT0               (pp_out_l3n2_0[45:0])   //|> w
  ,.OUT1               (pp_out_l3n2_1[45:0])   //|> w
  );
`else 
DW02_tree #(4, 46) u_tree_l3n2 (
   .INPUT              (pp_in_l3n2[183:0])     //|< r
  ,.OUT0               (pp_out_l3n2_0[45:0])   //|> w
  ,.OUT1               (pp_out_l3n2_1[45:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 46) u_tree_l3n3 (
   .INPUT              (pp_in_l3n3[183:0])     //|< r
  ,.OUT0               (pp_out_l3n3_0[45:0])   //|> w
  ,.OUT1               (pp_out_l3n3_1[45:0])   //|> w
  );
`else 
DW02_tree #(4, 46) u_tree_l3n3 (
   .INPUT              (pp_in_l3n3[183:0])     //|< r
  ,.OUT0               (pp_out_l3n3_0[45:0])   //|> w
  ,.OUT1               (pp_out_l3n3_1[45:0])   //|> w
  );
`endif 





//==========================================================
// MAC cell float point sign compensation tree level 1
//==========================================================

/////////////////////////////////////////////////////////////////////
//////////////// assemble input for sign tree level 1 ///////////////
/////////////////////////////////////////////////////////////////////

assign ps_n0_in_b0 = (~cfg_is_fp16_d2[0]) ? 8'b0 :
                        (cfg_is_wg_d2[4]) ? {~ps_n0b0_d2[6], ps_n0b0_d2} :
                        {1'b0, ps_n0b0_d2};
assign ps_n0_in_b1 = (~cfg_is_fp16_d2[0]) ? 8'b0 :
                        (cfg_is_wg_d2[4]) ? {~ps_n0b1_d2[6], ps_n0b1_d2} :
                        {1'b0, ps_n0b1_d2};
assign ps_n0_in_b2 = (~cfg_is_fp16_d2[0]) ? 8'b0 :
                        (cfg_is_wg_d2[4]) ? {~ps_n0b2_d2[6], ps_n0b2_d2} :
                        {1'b0, ps_n0b2_d2};
assign ps_n0_in_b3 = (~cfg_is_fp16_d2[0]) ? 8'b0 :
                        (cfg_is_wg_d2[4]) ? {~ps_n0b3_d2[6], ps_n0b3_d2} :
                        {1'b0, ps_n0b3_d2};
assign ps_n0_in_b4 = (~cfg_is_fp16_d2[0]) ? 8'b0 :
                        (cfg_is_wg_d2[4]) ? {~ps_n0b4_d2[6], ps_n0b4_d2} :
                        {1'b0, ps_n0b4_d2};
assign ps_n0_in_b5 = (~cfg_is_fp16_d2[0]) ? 8'b0 :
                        (cfg_is_wg_d2[4]) ? {~ps_n0b5_d2[6], ps_n0b5_d2} :
                        {1'b0, ps_n0b5_d2};
assign ps_n0_in_b6 = (~cfg_is_fp16_d2[0]) ? 8'b0 :
                        (cfg_is_wg_d2[4]) ? {~ps_n0b6_d2[6], ps_n0b6_d2} :
                        {1'b0, ps_n0b6_d2};
assign ps_n0_in_b7 = (~cfg_is_fp16_d2[0]) ? 8'b0 :
                        (cfg_is_wg_d2[4]) ? {~ps_n0b7_d2[6], ps_n0b7_d2} :
                        {1'b0, ps_n0b7_d2};
assign ps_n1_in_b0 = (~cfg_is_fp16_d2[1]) ? 8'b0 : {~ps_n1b0_d2[6], ps_n1b0_d2};
assign ps_n1_in_b1 = (~cfg_is_fp16_d2[1]) ? 8'b0 : {~ps_n1b1_d2[6], ps_n1b1_d2};
assign ps_n1_in_b2 = (~cfg_is_fp16_d2[1]) ? 8'b0 : {~ps_n1b2_d2[6], ps_n1b2_d2};
assign ps_n1_in_b3 = (~cfg_is_fp16_d2[1]) ? 8'b0 : {~ps_n1b3_d2[6], ps_n1b3_d2};
assign ps_n1_in_b4 = (~cfg_is_fp16_d2[1]) ? 8'b0 : {~ps_n1b4_d2[6], ps_n1b4_d2};
assign ps_n1_in_b5 = (~cfg_is_fp16_d2[1]) ? 8'b0 : {~ps_n1b5_d2[6], ps_n1b5_d2};
assign ps_n1_in_b6 = (~cfg_is_fp16_d2[1]) ? 8'b0 : {~ps_n1b6_d2[6], ps_n1b6_d2};
assign ps_n1_in_b7 = (~cfg_is_fp16_d2[1]) ? 8'b0 : {~ps_n1b7_d2[6], ps_n1b7_d2};
assign ps_n2_in_b0 = (~cfg_is_fp16_d2[2]) ? 8'b0 : {~ps_n2b0_d2[6], ps_n2b0_d2};
assign ps_n2_in_b1 = (~cfg_is_fp16_d2[2]) ? 8'b0 : {~ps_n2b1_d2[6], ps_n2b1_d2};
assign ps_n2_in_b2 = (~cfg_is_fp16_d2[2]) ? 8'b0 : {~ps_n2b2_d2[6], ps_n2b2_d2};
assign ps_n2_in_b3 = (~cfg_is_fp16_d2[2]) ? 8'b0 : {~ps_n2b3_d2[6], ps_n2b3_d2};
assign ps_n2_in_b4 = (~cfg_is_fp16_d2[2]) ? 8'b0 : {~ps_n2b4_d2[6], ps_n2b4_d2};
assign ps_n2_in_b5 = (~cfg_is_fp16_d2[2]) ? 8'b0 : {~ps_n2b5_d2[6], ps_n2b5_d2};
assign ps_n2_in_b6 = (~cfg_is_fp16_d2[2]) ? 8'b0 : {~ps_n2b6_d2[6], ps_n2b6_d2};
assign ps_n2_in_b7 = (~cfg_is_fp16_d2[2]) ? 8'b0 : {~ps_n2b7_d2[6], ps_n2b7_d2};
assign ps_n3_in_b0 = (~cfg_is_fp16_d2[3]) ? 8'b0 : {~ps_n3b0_d2[6], ps_n3b0_d2};
assign ps_n3_in_b1 = (~cfg_is_fp16_d2[3]) ? 8'b0 : {~ps_n3b1_d2[6], ps_n3b1_d2};
assign ps_n3_in_b2 = (~cfg_is_fp16_d2[3]) ? 8'b0 : {~ps_n3b2_d2[6], ps_n3b2_d2};
assign ps_n3_in_b3 = (~cfg_is_fp16_d2[3]) ? 8'b0 : {~ps_n3b3_d2[6], ps_n3b3_d2};
assign ps_n3_in_b4 = (~cfg_is_fp16_d2[3]) ? 8'b0 : {~ps_n3b4_d2[6], ps_n3b4_d2};
assign ps_n3_in_b5 = (~cfg_is_fp16_d2[3]) ? 8'b0 : {~ps_n3b5_d2[6], ps_n3b5_d2};
assign ps_n3_in_b6 = (~cfg_is_fp16_d2[3]) ? 8'b0 : {~ps_n3b6_d2[6], ps_n3b6_d2};
assign ps_n3_in_b7 = (~cfg_is_fp16_d2[3]) ? 8'b0 : {~ps_n3b7_d2[6], ps_n3b7_d2};




assign ps_in_l1n0 = {2'b0, ps_n0_in_b1, 10'b0, ps_n0_in_b1, 10'b0, ps_n0_in_b0, 10'b0, ps_n0_in_b0};
assign ps_in_l1n1 = {2'b0, ps_n0_in_b3, 10'b0, ps_n0_in_b3, 10'b0, ps_n0_in_b2, 10'b0, ps_n0_in_b2};
assign ps_in_l1n2 = {2'b0, ps_n0_in_b5, 10'b0, ps_n0_in_b5, 10'b0, ps_n0_in_b4, 10'b0, ps_n0_in_b4};
assign ps_in_l1n3 = {2'b0, ps_n0_in_b7, 10'b0, ps_n0_in_b7, 10'b0, ps_n0_in_b6, 10'b0, ps_n0_in_b6};
assign ps_in_l1n4 = {2'b0, ps_n1_in_b1, 10'b0, ps_n1_in_b1, 10'b0, ps_n1_in_b0, 10'b0, ps_n1_in_b0};
assign ps_in_l1n5 = {2'b0, ps_n1_in_b3, 10'b0, ps_n1_in_b3, 10'b0, ps_n1_in_b2, 10'b0, ps_n1_in_b2};
assign ps_in_l1n6 = {2'b0, ps_n1_in_b5, 10'b0, ps_n1_in_b5, 10'b0, ps_n1_in_b4, 10'b0, ps_n1_in_b4};
assign ps_in_l1n7 = {2'b0, ps_n1_in_b7, 10'b0, ps_n1_in_b7, 10'b0, ps_n1_in_b6, 10'b0, ps_n1_in_b6};
assign ps_in_l1n8 = {2'b0, ps_n2_in_b1, 10'b0, ps_n2_in_b1, 10'b0, ps_n2_in_b0, 10'b0, ps_n2_in_b0};
assign ps_in_l1n9 = {2'b0, ps_n2_in_b3, 10'b0, ps_n2_in_b3, 10'b0, ps_n2_in_b2, 10'b0, ps_n2_in_b2};
assign ps_in_l1n10 = {2'b0, ps_n2_in_b5, 10'b0, ps_n2_in_b5, 10'b0, ps_n2_in_b4, 10'b0, ps_n2_in_b4};
assign ps_in_l1n11 = {2'b0, ps_n2_in_b7, 10'b0, ps_n2_in_b7, 10'b0, ps_n2_in_b6, 10'b0, ps_n2_in_b6};
assign ps_in_l1n12 = {2'b0, ps_n3_in_b1, 10'b0, ps_n3_in_b1, 10'b0, ps_n3_in_b0, 10'b0, ps_n3_in_b0};
assign ps_in_l1n13 = {2'b0, ps_n3_in_b3, 10'b0, ps_n3_in_b3, 10'b0, ps_n3_in_b2, 10'b0, ps_n3_in_b2};
assign ps_in_l1n14 = {2'b0, ps_n3_in_b5, 10'b0, ps_n3_in_b5, 10'b0, ps_n3_in_b4, 10'b0, ps_n3_in_b4};
assign ps_in_l1n15 = {2'b0, ps_n3_in_b7, 10'b0, ps_n3_in_b7, 10'b0, ps_n3_in_b6, 10'b0, ps_n3_in_b6};



//////////////////////////////////////////////////////////
//////////////// Sign tree level 0: 64->16 ///////////////
//////////////////////////////////////////////////////////

`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n0 (
   .INPUT              (ps_in_l1n0[63:0])      //|< w
  ,.OUT0               (ps_out_l1n0_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n0_1[15:0])   //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n0 (
   .INPUT              (ps_in_l1n0[63:0])      //|< w
  ,.OUT0               (ps_out_l1n0_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n0_1[15:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n1 (
   .INPUT              (ps_in_l1n1[63:0])      //|< w
  ,.OUT0               (ps_out_l1n1_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n1_1[15:0])   //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n1 (
   .INPUT              (ps_in_l1n1[63:0])      //|< w
  ,.OUT0               (ps_out_l1n1_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n1_1[15:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n2 (
   .INPUT              (ps_in_l1n2[63:0])      //|< w
  ,.OUT0               (ps_out_l1n2_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n2_1[15:0])   //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n2 (
   .INPUT              (ps_in_l1n2[63:0])      //|< w
  ,.OUT0               (ps_out_l1n2_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n2_1[15:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n3 (
   .INPUT              (ps_in_l1n3[63:0])      //|< w
  ,.OUT0               (ps_out_l1n3_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n3_1[15:0])   //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n3 (
   .INPUT              (ps_in_l1n3[63:0])      //|< w
  ,.OUT0               (ps_out_l1n3_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n3_1[15:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n4 (
   .INPUT              (ps_in_l1n4[63:0])      //|< w
  ,.OUT0               (ps_out_l1n4_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n4_1[15:0])   //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n4 (
   .INPUT              (ps_in_l1n4[63:0])      //|< w
  ,.OUT0               (ps_out_l1n4_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n4_1[15:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n5 (
   .INPUT              (ps_in_l1n5[63:0])      //|< w
  ,.OUT0               (ps_out_l1n5_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n5_1[15:0])   //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n5 (
   .INPUT              (ps_in_l1n5[63:0])      //|< w
  ,.OUT0               (ps_out_l1n5_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n5_1[15:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n6 (
   .INPUT              (ps_in_l1n6[63:0])      //|< w
  ,.OUT0               (ps_out_l1n6_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n6_1[15:0])   //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n6 (
   .INPUT              (ps_in_l1n6[63:0])      //|< w
  ,.OUT0               (ps_out_l1n6_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n6_1[15:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n7 (
   .INPUT              (ps_in_l1n7[63:0])      //|< w
  ,.OUT0               (ps_out_l1n7_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n7_1[15:0])   //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n7 (
   .INPUT              (ps_in_l1n7[63:0])      //|< w
  ,.OUT0               (ps_out_l1n7_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n7_1[15:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n8 (
   .INPUT              (ps_in_l1n8[63:0])      //|< w
  ,.OUT0               (ps_out_l1n8_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n8_1[15:0])   //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n8 (
   .INPUT              (ps_in_l1n8[63:0])      //|< w
  ,.OUT0               (ps_out_l1n8_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n8_1[15:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n9 (
   .INPUT              (ps_in_l1n9[63:0])      //|< w
  ,.OUT0               (ps_out_l1n9_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n9_1[15:0])   //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n9 (
   .INPUT              (ps_in_l1n9[63:0])      //|< w
  ,.OUT0               (ps_out_l1n9_0[15:0])   //|> w
  ,.OUT1               (ps_out_l1n9_1[15:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n10 (
   .INPUT              (ps_in_l1n10[63:0])     //|< w
  ,.OUT0               (ps_out_l1n10_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n10_1[15:0])  //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n10 (
   .INPUT              (ps_in_l1n10[63:0])     //|< w
  ,.OUT0               (ps_out_l1n10_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n10_1[15:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n11 (
   .INPUT              (ps_in_l1n11[63:0])     //|< w
  ,.OUT0               (ps_out_l1n11_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n11_1[15:0])  //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n11 (
   .INPUT              (ps_in_l1n11[63:0])     //|< w
  ,.OUT0               (ps_out_l1n11_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n11_1[15:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n12 (
   .INPUT              (ps_in_l1n12[63:0])     //|< w
  ,.OUT0               (ps_out_l1n12_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n12_1[15:0])  //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n12 (
   .INPUT              (ps_in_l1n12[63:0])     //|< w
  ,.OUT0               (ps_out_l1n12_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n12_1[15:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n13 (
   .INPUT              (ps_in_l1n13[63:0])     //|< w
  ,.OUT0               (ps_out_l1n13_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n13_1[15:0])  //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n13 (
   .INPUT              (ps_in_l1n13[63:0])     //|< w
  ,.OUT0               (ps_out_l1n13_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n13_1[15:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n14 (
   .INPUT              (ps_in_l1n14[63:0])     //|< w
  ,.OUT0               (ps_out_l1n14_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n14_1[15:0])  //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n14 (
   .INPUT              (ps_in_l1n14[63:0])     //|< w
  ,.OUT0               (ps_out_l1n14_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n14_1[15:0])  //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(4, 16) u_tree_sign_l1n15 (
   .INPUT              (ps_in_l1n15[63:0])     //|< w
  ,.OUT0               (ps_out_l1n15_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n15_1[15:0])  //|> w
  );
`else 
DW02_tree #(4, 16) u_tree_sign_l1n15 (
   .INPUT              (ps_in_l1n15[63:0])     //|< w
  ,.OUT0               (ps_out_l1n15_0[15:0])  //|> w
  ,.OUT1               (ps_out_l1n15_1[15:0])  //|> w
  );
`endif 






//==========================================================
// MAC cell float point sign compensation tree level 2
//==========================================================

/////////////////////////////////////////////////////////////////////
//////////////// assemble input for sign tree level 2 ///////////////
/////////////////////////////////////////////////////////////////////

assign ps_in_l2n0 = {ps_out_l1n3_1[13:0], 24'b0, ps_out_l1n3_0[13:0], 30'b0,
                        ps_out_l1n2_1, 22'b0, ps_out_l1n2_0, 30'b0,
                        ps_out_l1n1_1, 22'b0, ps_out_l1n1_0, 30'b0,
                        ps_out_l1n0_1, 22'b0, ps_out_l1n0_0};
assign ps_in_l2n1 = {ps_out_l1n7_1[13:0], 24'b0, ps_out_l1n7_0[13:0], 30'b0,
                        ps_out_l1n6_1, 22'b0, ps_out_l1n6_0, 30'b0,
                        ps_out_l1n5_1, 22'b0, ps_out_l1n5_0, 30'b0,
                        ps_out_l1n4_1, 22'b0, ps_out_l1n4_0};
assign ps_in_l2n2 = {ps_out_l1n11_1[13:0], 24'b0, ps_out_l1n11_0[13:0], 30'b0,
                        ps_out_l1n10_1, 22'b0, ps_out_l1n10_0, 30'b0,
                        ps_out_l1n9_1, 22'b0, ps_out_l1n9_0, 30'b0,
                        ps_out_l1n8_1, 22'b0, ps_out_l1n8_0};
assign ps_in_l2n3 = {ps_out_l1n15_1[13:0], 24'b0, ps_out_l1n15_0[13:0], 30'b0,
                        ps_out_l1n14_1, 22'b0, ps_out_l1n14_0, 30'b0,
                        ps_out_l1n13_1, 22'b0, ps_out_l1n13_0, 30'b0,
                        ps_out_l1n12_1, 22'b0, ps_out_l1n12_0};



//////////////////////////////////////////////////////////
//////////////// Sign tree level 2: 16->4  ///////////////
//////////////////////////////////////////////////////////

`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 38) u_tree_sign_l2n0 (
   .INPUT              (ps_in_l2n0[303:0])     //|< w
  ,.OUT0               (ps_out_l2n0_0[37:0])   //|> w
  ,.OUT1               (ps_out_l2n0_1[37:0])   //|> w
  );
`else 
DW02_tree #(8, 38) u_tree_sign_l2n0 (
   .INPUT              (ps_in_l2n0[303:0])     //|< w
  ,.OUT0               (ps_out_l2n0_0[37:0])   //|> w
  ,.OUT1               (ps_out_l2n0_1[37:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 38) u_tree_sign_l2n1 (
   .INPUT              (ps_in_l2n1[303:0])     //|< w
  ,.OUT0               (ps_out_l2n1_0[37:0])   //|> w
  ,.OUT1               (ps_out_l2n1_1[37:0])   //|> w
  );
`else 
DW02_tree #(8, 38) u_tree_sign_l2n1 (
   .INPUT              (ps_in_l2n1[303:0])     //|< w
  ,.OUT0               (ps_out_l2n1_0[37:0])   //|> w
  ,.OUT1               (ps_out_l2n1_1[37:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 38) u_tree_sign_l2n2 (
   .INPUT              (ps_in_l2n2[303:0])     //|< w
  ,.OUT0               (ps_out_l2n2_0[37:0])   //|> w
  ,.OUT1               (ps_out_l2n2_1[37:0])   //|> w
  );
`else 
DW02_tree #(8, 38) u_tree_sign_l2n2 (
   .INPUT              (ps_in_l2n2[303:0])     //|< w
  ,.OUT0               (ps_out_l2n2_0[37:0])   //|> w
  ,.OUT1               (ps_out_l2n2_1[37:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(8, 38) u_tree_sign_l2n3 (
   .INPUT              (ps_in_l2n3[303:0])     //|< w
  ,.OUT0               (ps_out_l2n3_0[37:0])   //|> w
  ,.OUT1               (ps_out_l2n3_1[37:0])   //|> w
  );
`else 
DW02_tree #(8, 38) u_tree_sign_l2n3 (
   .INPUT              (ps_in_l2n3[303:0])     //|< w
  ,.OUT0               (ps_out_l2n3_0[37:0])   //|> w
  ,.OUT1               (ps_out_l2n3_1[37:0])   //|> w
  );
`endif 






//==========================================================
// MAC cell CSA tree level 4
// for DC: 2(4) -> 1(2)
// for WG: second step of 4x2(2*4x2) -> 2x2(2*2x2)
//==========================================================

/////////////////////////////////////////////////////////////////////////
//////////////// input for CSA tree level 4 (first half) ////////////////
/////////////////////////////////////////////////////////////////////////

always @(
  pp_out_l3n0_0
  or pp_out_l3n0_1
  or cfg_is_wg_d2
  or pp_in_l3n1_0
  or pp_out_l3n1_0
  or pp_in_l3n1_1
  or pp_out_l3n1_1
  or cfg_is_fp16_d2
  or ps_out_l2n0_0
  or ps_out_l2n0_1
  ) begin
    pp_in_l4n0_0 = pp_out_l3n0_0;
    pp_in_l4n0_1 = pp_out_l3n0_1;
    pp_in_l4n0_2 = cfg_is_wg_d2[0] ? pp_in_l3n1_0 : pp_out_l3n1_0;
    pp_in_l4n0_3 = cfg_is_wg_d2[0] ? pp_in_l3n1_1 : pp_out_l3n1_1;
    pp_in_l4n0_4 = (~cfg_is_fp16_d2[4]) ? 46'b0 : {8'b0, ps_out_l2n0_0};
    pp_in_l4n0_5 = (~cfg_is_fp16_d2[4]) ? 46'b0 : {8'b0, ps_out_l2n0_1};
end


always @(
  pp_out_l3n2_0
  or pp_out_l3n2_1
  or cfg_is_wg_d2
  or pp_in_l3n3_0
  or pp_out_l3n3_0
  or pp_in_l3n3_1
  or pp_out_l3n3_1
  or cfg_is_fp16_d2
  or ps_out_l2n1_0
  or ps_out_l2n1_1
  ) begin
    pp_in_l4n1_0 = pp_out_l3n2_0;
    pp_in_l4n1_1 = pp_out_l3n2_1;
    pp_in_l4n1_2 = cfg_is_wg_d2[1] ? pp_in_l3n3_0 : pp_out_l3n3_0;
    pp_in_l4n1_3 = cfg_is_wg_d2[1] ? pp_in_l3n3_1 : pp_out_l3n3_1;
    pp_in_l4n1_4 = (~cfg_is_fp16_d2[5]) ? 46'b0 : {8'b0, ps_out_l2n1_0};
    pp_in_l4n1_5 = (~cfg_is_fp16_d2[5]) ? 46'b0 : {8'b0, ps_out_l2n1_1};
end




//////////////////////////////////////////////////////////////////////////////////
//////////////// assemble input for CSA tree level 4 (first half) ////////////////
//////////////////////////////////////////////////////////////////////////////////

always @(
  pp_in_l4n0_5
  or pp_in_l4n0_4
  or pp_in_l4n0_3
  or pp_in_l4n0_2
  or pp_in_l4n0_1
  or pp_in_l4n0_0
  ) begin
    pp_in_l4n0 = {pp_in_l4n0_5, pp_in_l4n0_4, pp_in_l4n0_3, pp_in_l4n0_2, pp_in_l4n0_1, pp_in_l4n0_0};
end


always @(
  pp_in_l4n1_5
  or pp_in_l4n1_4
  or pp_in_l4n1_3
  or pp_in_l4n1_2
  or pp_in_l4n1_1
  or pp_in_l4n1_0
  ) begin
    pp_in_l4n1 = {pp_in_l4n1_5, pp_in_l4n1_4, pp_in_l4n1_3, pp_in_l4n1_2, pp_in_l4n1_1, pp_in_l4n1_0};
end




/////////////////////////////////////////////////////////////////////
//////////////// CSA tree level 4 (first half): 4->2 ////////////////
/////////////////////////////////////////////////////////////////////

`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(6, 46) u_tree_l4n0 (
   .INPUT              (pp_in_l4n0[275:0])     //|< r
  ,.OUT0               (pp_out_l4n0_0[45:0])   //|> w
  ,.OUT1               (pp_out_l4n0_1[45:0])   //|> w
  );
`else 
DW02_tree #(6, 46) u_tree_l4n0 (
   .INPUT              (pp_in_l4n0[275:0])     //|< r
  ,.OUT0               (pp_out_l4n0_0[45:0])   //|> w
  ,.OUT1               (pp_out_l4n0_1[45:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(6, 46) u_tree_l4n1 (
   .INPUT              (pp_in_l4n1[275:0])     //|< r
  ,.OUT0               (pp_out_l4n1_0[45:0])   //|> w
  ,.OUT1               (pp_out_l4n1_1[45:0])   //|> w
  );
`else 
DW02_tree #(6, 46) u_tree_l4n1 (
   .INPUT              (pp_in_l4n1[275:0])     //|< r
  ,.OUT0               (pp_out_l4n1_0[45:0])   //|> w
  ,.OUT1               (pp_out_l4n1_1[45:0])   //|> w
  );
`endif 




//////////////////////////////////////////////////////////////////////////
//////////////// input for CSA tree level 4 (second half) ////////////////
//////////////////////////////////////////////////////////////////////////

always @(
  cfg_is_int8_d2
  or cfg_is_wg_d2
  or pp_in_l3n0_2
  or pp_in_l3n0_3
  or pp_out_l3n1_0
  or pp_out_l3n1_1
  or cfg_is_fp16_d2
  or ps_out_l2n2_0
  or ps_out_l2n2_1
  ) begin
    mask4_2 = {22'h3fffff, {2{~cfg_is_int8_d2[4]}}, 22'h3fffff};
    pp_in_l4n2_0 = ~cfg_is_wg_d2[2] ? 46'b0 : pp_in_l3n0_2;
    pp_in_l4n2_1 = ~cfg_is_wg_d2[2] ? 46'b0 : pp_in_l3n0_3;
    pp_in_l4n2_2 = ~cfg_is_wg_d2[2] ? 46'b0 : ~pp_out_l3n1_0 & mask4_2;
    pp_in_l4n2_3 = ~cfg_is_wg_d2[2] ? 46'b0 : ~pp_out_l3n1_1 & mask4_2;
    pp_in_l4n2_4 = (~cfg_is_wg_d2[2] | ~cfg_is_fp16_d2[6]) ? 46'b0 : {8'b0, ps_out_l2n2_0};
    pp_in_l4n2_5 = (~cfg_is_wg_d2[2] | ~cfg_is_fp16_d2[6]) ? 46'b0 : {8'b0, ps_out_l2n2_1};
end


always @(
  cfg_is_int8_d2
  or cfg_is_wg_d2
  or pp_in_l3n2_2
  or pp_in_l3n2_3
  or pp_out_l3n3_0
  or pp_out_l3n3_1
  or cfg_is_fp16_d2
  or ps_out_l2n3_0
  or ps_out_l2n3_1
  ) begin
    mask4_3 = {22'h3fffff, {2{~cfg_is_int8_d2[5]}}, 22'h3fffff};
    pp_in_l4n3_0 = ~cfg_is_wg_d2[3] ? 46'b0 : pp_in_l3n2_2;
    pp_in_l4n3_1 = ~cfg_is_wg_d2[3] ? 46'b0 : pp_in_l3n2_3;
    pp_in_l4n3_2 = ~cfg_is_wg_d2[3] ? 46'b0 : ~pp_out_l3n3_0 & mask4_3;
    pp_in_l4n3_3 = ~cfg_is_wg_d2[3] ? 46'b0 : ~pp_out_l3n3_1 & mask4_3;
    pp_in_l4n3_4 = (~cfg_is_wg_d2[3] | ~cfg_is_fp16_d2[7]) ? 46'b0 : {8'b0, ps_out_l2n3_0};
    pp_in_l4n3_5 = (~cfg_is_wg_d2[3] | ~cfg_is_fp16_d2[7]) ? 46'b0 : {8'b0, ps_out_l2n3_1};
end




///////////////////////////////////////////////////////////////////////////////////
//////////////// assemble input for CSA tree level 4 (second half) ////////////////
///////////////////////////////////////////////////////////////////////////////////

always @(
  pp_in_l4n2_5
  or pp_in_l4n2_4
  or pp_in_l4n2_3
  or pp_in_l4n2_2
  or pp_in_l4n2_1
  or pp_in_l4n2_0
  ) begin
    pp_in_l4n2 = {pp_in_l4n2_5, pp_in_l4n2_4, pp_in_l4n2_3, pp_in_l4n2_2, pp_in_l4n2_1, pp_in_l4n2_0};
end


always @(
  pp_in_l4n3_5
  or pp_in_l4n3_4
  or pp_in_l4n3_3
  or pp_in_l4n3_2
  or pp_in_l4n3_1
  or pp_in_l4n3_0
  ) begin
    pp_in_l4n3 = {pp_in_l4n3_5, pp_in_l4n3_4, pp_in_l4n3_3, pp_in_l4n3_2, pp_in_l4n3_1, pp_in_l4n3_0};
end




////////////////////////////////////////////////////////////////////////
//////////////// CSA tree level 4 (second half): for WG ////////////////
////////////////////////////////////////////////////////////////////////

`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(6, 46) u_tree_l4n2 (
   .INPUT              (pp_in_l4n2[275:0])     //|< r
  ,.OUT0               (pp_out_l4n2_0[45:0])   //|> w
  ,.OUT1               (pp_out_l4n2_1[45:0])   //|> w
  );
`else 
DW02_tree #(6, 46) u_tree_l4n2 (
   .INPUT              (pp_in_l4n2[275:0])     //|< r
  ,.OUT0               (pp_out_l4n2_0[45:0])   //|> w
  ,.OUT1               (pp_out_l4n2_1[45:0])   //|> w
  );
`endif 


`ifdef DESIGNWARE_NOEXIST 
NV_DW02_tree #(6, 46) u_tree_l4n3 (
   .INPUT              (pp_in_l4n3[275:0])     //|< r
  ,.OUT0               (pp_out_l4n3_0[45:0])   //|> w
  ,.OUT1               (pp_out_l4n3_1[45:0])   //|> w
  );
`else 
DW02_tree #(6, 46) u_tree_l4n3 (
   .INPUT              (pp_in_l4n3[275:0])     //|< r
  ,.OUT0               (pp_out_l4n3_0[45:0])   //|> w
  ,.OUT1               (pp_out_l4n3_1[45:0])   //|> w
  );
`endif 





//==========================================================
// Level 2 registers
//==========================================================
always @(
  cfg_is_int8_d2
  ) begin
    mask4_4 = {22'h3fffff, {2{~cfg_is_int8_d2[6]}}, 22'h3fffff};
    mask4_5 = {22'h3fffff, {2{~cfg_is_int8_d2[7]}}, 22'h3fffff};
    mask4_6 = {22'h3fffff, {2{~cfg_is_int8_d2[8]}}, 22'h3fffff};
    mask4_7 = {22'h3fffff, {2{~cfg_is_int8_d2[9]}}, 22'h3fffff};
end

always @(
  pp_out_l4n0_0
  or mask4_4
  or pp_out_l4n0_1
  or pp_out_l4n1_0
  or mask4_5
  or pp_out_l4n1_1
  or pp_out_l4n2_0
  or mask4_6
  or pp_out_l4n2_1
  or pp_out_l4n3_0
  or mask4_7
  or pp_out_l4n3_1
  ) begin
    pp_out_l4n0_0_d3_w = pp_out_l4n0_0 & mask4_4;
    pp_out_l4n0_1_d3_w = pp_out_l4n0_1 & mask4_4;
    pp_out_l4n1_0_d3_w = pp_out_l4n1_0 & mask4_5;
    pp_out_l4n1_1_d3_w = pp_out_l4n1_1 & mask4_5;
    pp_out_l4n2_0_d3_w = pp_out_l4n2_0 & mask4_6;
    pp_out_l4n2_1_d3_w = pp_out_l4n2_1 & mask4_6;
    pp_out_l4n3_0_d3_w = pp_out_l4n3_0 & mask4_7;
    pp_out_l4n3_1_d3_w = pp_out_l4n3_1 & mask4_7;
end

always @(
  pp_pvld_d2
  or pp_nan_pvld_d2
  or pp_out_l4n0_0_d3_w
  or pp_out_l4n0_1_d3_w
  or cfg_is_wg_d2
  or pp_out_l4n1_0_d3_w
  or pp_out_l4n1_1_d3_w
  or pp_out_l4n2_0_d3_w
  or pp_out_l4n2_1_d3_w
  or pp_out_l4n3_0_d3_w
  or pp_out_l4n3_1_d3_w
  ) begin
    pp_out_l4n0_0_d3 = (pp_pvld_d2[0] & ~pp_nan_pvld_d2[0]) ? pp_out_l4n0_0_d3_w : 46'b0;
    pp_out_l4n0_1_d3 = (pp_pvld_d2[0] & ~pp_nan_pvld_d2[0]) ? pp_out_l4n0_1_d3_w : 46'b0;
    pp_out_l4n1_0_d3 = (pp_pvld_d2[1] & ~pp_nan_pvld_d2[1] & cfg_is_wg_d2[5]) ? pp_out_l4n1_0_d3_w : 46'b0;
    pp_out_l4n1_1_d3 = (pp_pvld_d2[1] & ~pp_nan_pvld_d2[1] & cfg_is_wg_d2[5]) ? pp_out_l4n1_1_d3_w : 46'b0;
    pp_out_l4n2_0_d3 = (pp_pvld_d2[2] & ~pp_nan_pvld_d2[2] & cfg_is_wg_d2[6]) ? pp_out_l4n2_0_d3_w : 46'b0;
    pp_out_l4n2_1_d3 = (pp_pvld_d2[2] & ~pp_nan_pvld_d2[2] & cfg_is_wg_d2[6]) ? pp_out_l4n2_1_d3_w : 46'b0;
    pp_out_l4n3_0_d3 = (pp_pvld_d2[3] & ~pp_nan_pvld_d2[3] & cfg_is_wg_d2[7]) ? pp_out_l4n3_0_d3_w : 46'b0;
    pp_out_l4n3_1_d3 = (pp_pvld_d2[3] & ~pp_nan_pvld_d2[3] & cfg_is_wg_d2[7]) ? pp_out_l4n3_1_d3_w : 46'b0;
end

always @(
  pp_pvld_d2
  or pp_nan_pvld_d2
  or pp_nan_mts_d2
  or pp_exp_d2
  ) begin
    pp_pvld_d3 = {2{pp_pvld_d2[4]}};
    pp_nan_pvld_d3 = pp_nan_pvld_d2[4];
    pp_nan_mts_d3 = (pp_nan_pvld_d2[4]) ? pp_nan_mts_d2 : 11'b0;
    pp_exp_d3 = pp_exp_d2;
end



//==========================================================
// Final result of DC/WG
//==========================================================
//sop refers to sum of product

always @(
  cfg_is_wg_d3
  or cfg_is_int16_d3
  or cfg_is_int8_d3
  or cfg_is_fp16_d3
  ) begin
    pp_sign_patch_0 = (~cfg_is_wg_d3[0] & cfg_is_int16_d3[0]) ? 46'h2a_aac0_0000 :
                      (~cfg_is_wg_d3[0] & cfg_is_int8_d3[0]) ? 46'h2ac0_002a_c000 :
                      (~cfg_is_wg_d3[0] & cfg_is_fp16_d3[0]) ? 46'h15_aaaa_aad5 :
                      cfg_is_fp16_d3[0] ? 46'h15_aaaa_aad5 :
                      cfg_is_int8_d3[0] ? 46'h340c_0034_0c00 :
                      46'h8f4_000c_0000;
end

always @(
  cfg_is_wg_d3
  or cfg_is_fp16_d3
  or cfg_is_int8_d3
  ) begin
    pp_sign_patch_1 = (~cfg_is_wg_d3[1]) ? 46'b0 :
                      cfg_is_fp16_d3[1] ? 46'h15_aaaa_aadb :
                      cfg_is_int8_d3[1] ? 46'h13fc_0613_fc06 :
                      46'h3d03_fffc_0006;
end

always @(
  cfg_is_wg_d3
  or cfg_is_fp16_d3
  or cfg_is_int8_d3
  ) begin
    pp_sign_patch_2 = (~cfg_is_wg_d3[2]) ? 46'b0 :
                      cfg_is_fp16_d3[2] ? 46'h15_aaaa_aad7 :
                      cfg_is_int8_d3[2] ? 46'h3fc_0203_fc02 :
                      46'h3d03_fffc_0002;
end

always @(
  cfg_is_wg_d3
  or cfg_is_fp16_d3
  or cfg_is_int8_d3
  ) begin
    pp_sign_patch_3 = (~cfg_is_wg_d3[3]) ? 46'b0 :
                      cfg_is_fp16_d3[3] ? 46'h15_aaaa_aad5 :
                      cfg_is_int8_d3[3] ? 46'heac_000e_ac00 :
                      46'hfe_aaac_0000;
end

always @(
  pp_out_l4n0_0_d3
  or pp_out_l4n0_1_d3
  or pp_sign_patch_0
  or pp_out_l4n1_0_d3
  or pp_out_l4n1_1_d3
  or pp_sign_patch_1
  or pp_out_l4n2_0_d3
  or pp_out_l4n2_1_d3
  or pp_sign_patch_2
  or pp_out_l4n3_0_d3
  or pp_out_l4n3_1_d3
  or pp_sign_patch_3
  ) begin
    sop_0 = pp_out_l4n0_0_d3 + pp_out_l4n0_1_d3 + pp_sign_patch_0;
    sop_1 = pp_out_l4n1_0_d3 + pp_out_l4n1_1_d3 + pp_sign_patch_1;
    sop_2 = pp_out_l4n2_0_d3 + pp_out_l4n2_1_d3 + pp_sign_patch_2;
    sop_3 = pp_out_l4n3_0_d3 + pp_out_l4n3_1_d3 + pp_sign_patch_3;
end

always @(
  pp_nan_mts_d3
  ) begin
    sop_nan = {6'h3f, pp_nan_mts_d3, 27'b0};
end

always @(
  cfg_is_fp16_d3
  or pp_exp_d3
  ) begin
    sop_exp = cfg_is_fp16_d3[0] ? {pp_exp_d3, 2'b0} : 6'b0;
end

always @(
  pp_nan_pvld_d3
  or sop_nan
  or cfg_is_int8_d3
  or sop_0
  or sop_exp
  ) begin
    mac_out_data_w[43:0] = pp_nan_pvld_d3 ? sop_nan :
                           (cfg_is_int8_d3[4]) ? {sop_0[45:24], sop_0[21:0]} :
                           {sop_exp, sop_0[37:0]};
end

always @(
  cfg_is_wg_d3
  or pp_nan_pvld_d3
  or sop_nan
  or cfg_is_int8_d3
  or sop_1
  or sop_exp
  ) begin
    mac_out_data_w[87:44] = ~cfg_is_wg_d3[4] ? 44'b0 :
                            pp_nan_pvld_d3 ? sop_nan :
                            cfg_is_int8_d3[5] ? {sop_1[45:24], sop_1[21:0]} :
                            {sop_exp, sop_1[37:0]};
end

always @(
  cfg_is_wg_d3
  or pp_nan_pvld_d3
  or sop_nan
  or cfg_is_int8_d3
  or sop_2
  or sop_exp
  ) begin
    mac_out_data_w[131:88] = ~cfg_is_wg_d3[5] ? 44'b0 :
                             pp_nan_pvld_d3 ? sop_nan :
                             cfg_is_int8_d3[6] ? {sop_2[45:24], sop_2[21:0]} :
                             {sop_exp, sop_2[37:0]};
end

always @(
  cfg_is_wg_d3
  or pp_nan_pvld_d3
  or sop_nan
  or cfg_is_int8_d3
  or sop_3
  or sop_exp
  ) begin
    mac_out_data_w[175:132] = ~cfg_is_wg_d3[6] ? 44'b0 :
                              pp_nan_pvld_d3 ? sop_nan :
                              cfg_is_int8_d3[7] ? {sop_3[45:24], sop_3[21:0]} :
                              {sop_exp, sop_3[37:0]};
end

always @(
  pp_pvld_d3
  or cfg_is_wg_d3
  ) begin
    mac_out_data_reg_en[0] = pp_pvld_d3[1];
    mac_out_data_reg_en[1] = (pp_pvld_d3[1] & cfg_is_wg_d3[4]);
    mac_out_data_reg_en[2] = (pp_pvld_d3[1] & cfg_is_wg_d3[5]);
    mac_out_data_reg_en[3] = (pp_pvld_d3[1] & cfg_is_wg_d3[6]);
end

//==========================================================
// Final register for MAC output
//==========================================================

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mac_out_pvld <= 1'b0;
  end else begin
  mac_out_pvld <= pp_pvld_d3[0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mac_out_nan <= 1'b0;
  end else begin
  mac_out_nan <= pp_nan_pvld_d3;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_out_data_reg_en[0]) == 1'b1) begin
    mac_out_data[43:0] <= mac_out_data_w[43:0];
  // VCS coverage off
  end else if ((mac_out_data_reg_en[0]) == 1'b0) begin
  end else begin
    mac_out_data[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_wg_clk) begin
  if ((mac_out_data_reg_en[1]) == 1'b1) begin
    mac_out_data[87:44] <= mac_out_data_w[87:44];
  // VCS coverage off
  end else if ((mac_out_data_reg_en[1]) == 1'b0) begin
  end else begin
    mac_out_data[87:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((mac_out_data_reg_en[2]) == 1'b1) begin
    mac_out_data[131:88] <= mac_out_data_w[131:88];
  // VCS coverage off
  end else if ((mac_out_data_reg_en[2]) == 1'b0) begin
  end else begin
    mac_out_data[131:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_wg_clk) begin
  if ((mac_out_data_reg_en[3]) == 1'b1) begin
    mac_out_data[175:132] <= mac_out_data_w[175:132];
  // VCS coverage off
  end else if ((mac_out_data_reg_en[3]) == 1'b0) begin
  end else begin
    mac_out_data[175:132] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           pp_nan_pvld_d1[1:0]
//                           pp_exp_d1[1:0];

//////////////////////////////////////////////////////////////
///// functional point                                   /////
//////////////////////////////////////////////////////////////

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

    property cmac_core_mac__mac_output_nan__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mac_out_pvld) && nvdla_core_rstn) |-> ((mac_out_nan));
    endproperty
    // Cover 0 : "(mac_out_nan)"
    FUNCPOINT_cmac_core_mac__mac_output_nan__0_COV : cover property (cmac_core_mac__mac_output_nan__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cmac_core_mac__mac_output_fp_zero__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mac_out_pvld) && nvdla_core_rstn) |-> ((cfg_is_fp16_d3[0] & ~(|mac_out_data[37:0]) & (|mac_out_data[43:38])));
    endproperty
    // Cover 1 : "(cfg_is_fp16_d3[0] & ~(|mac_out_data[37:0]) & (|mac_out_data[43:38]))"
    FUNCPOINT_cmac_core_mac__mac_output_fp_zero__1_COV : cover property (cmac_core_mac__mac_output_fp_zero__1_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CMAC_CORE_mac

