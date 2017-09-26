// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_lut.v

module NV_NVDLA_CDP_DP_lut (
   nvdla_core_clk             //|< i
  ,nvdla_core_clk_orig        //|< i
  ,nvdla_core_rstn            //|< i
  ,dp2lut_X_entry_0           //|< i
  ,dp2lut_X_entry_1           //|< i
  ,dp2lut_X_entry_2           //|< i
  ,dp2lut_X_entry_3           //|< i
  ,dp2lut_X_entry_4           //|< i
  ,dp2lut_X_entry_5           //|< i
  ,dp2lut_X_entry_6           //|< i
  ,dp2lut_X_entry_7           //|< i
  ,dp2lut_Xinfo_0             //|< i
  ,dp2lut_Xinfo_1             //|< i
  ,dp2lut_Xinfo_2             //|< i
  ,dp2lut_Xinfo_3             //|< i
  ,dp2lut_Xinfo_4             //|< i
  ,dp2lut_Xinfo_5             //|< i
  ,dp2lut_Xinfo_6             //|< i
  ,dp2lut_Xinfo_7             //|< i
  ,dp2lut_Y_entry_0           //|< i
  ,dp2lut_Y_entry_1           //|< i
  ,dp2lut_Y_entry_2           //|< i
  ,dp2lut_Y_entry_3           //|< i
  ,dp2lut_Y_entry_4           //|< i
  ,dp2lut_Y_entry_5           //|< i
  ,dp2lut_Y_entry_6           //|< i
  ,dp2lut_Y_entry_7           //|< i
  ,dp2lut_Yinfo_0             //|< i
  ,dp2lut_Yinfo_1             //|< i
  ,dp2lut_Yinfo_2             //|< i
  ,dp2lut_Yinfo_3             //|< i
  ,dp2lut_Yinfo_4             //|< i
  ,dp2lut_Yinfo_5             //|< i
  ,dp2lut_Yinfo_6             //|< i
  ,dp2lut_Yinfo_7             //|< i
  ,dp2lut_pvld                //|< i
  ,int8_en                    //|< i
  ,lut2intp_prdy              //|< i
  ,nvdla_op_gated_clk_fp16    //|< i
  ,reg2dp_input_data_type     //|< i
  ,reg2dp_lut_access_type     //|< i
  ,reg2dp_lut_addr            //|< i
  ,reg2dp_lut_data            //|< i
  ,reg2dp_lut_data_trigger    //|< i
  ,reg2dp_lut_hybrid_priority //|< i
  ,reg2dp_lut_oflow_priority  //|< i
  ,reg2dp_lut_table_id        //|< i
  ,reg2dp_lut_uflow_priority  //|< i
  ,dp2lut_prdy                //|> o
  ,dp2reg_lut_data            //|> o
  ,lut2intp_X_data_00         //|> o
  ,lut2intp_X_data_00_17b     //|> o
  ,lut2intp_X_data_01         //|> o
  ,lut2intp_X_data_10         //|> o
  ,lut2intp_X_data_10_17b     //|> o
  ,lut2intp_X_data_11         //|> o
  ,lut2intp_X_data_20         //|> o
  ,lut2intp_X_data_20_17b     //|> o
  ,lut2intp_X_data_21         //|> o
  ,lut2intp_X_data_30         //|> o
  ,lut2intp_X_data_30_17b     //|> o
  ,lut2intp_X_data_31         //|> o
  ,lut2intp_X_data_40         //|> o
  ,lut2intp_X_data_40_17b     //|> o
  ,lut2intp_X_data_41         //|> o
  ,lut2intp_X_data_50         //|> o
  ,lut2intp_X_data_50_17b     //|> o
  ,lut2intp_X_data_51         //|> o
  ,lut2intp_X_data_60         //|> o
  ,lut2intp_X_data_60_17b     //|> o
  ,lut2intp_X_data_61         //|> o
  ,lut2intp_X_data_70         //|> o
  ,lut2intp_X_data_70_17b     //|> o
  ,lut2intp_X_data_71         //|> o
  ,lut2intp_X_info_0          //|> o
  ,lut2intp_X_info_1          //|> o
  ,lut2intp_X_info_2          //|> o
  ,lut2intp_X_info_3          //|> o
  ,lut2intp_X_info_4          //|> o
  ,lut2intp_X_info_5          //|> o
  ,lut2intp_X_info_6          //|> o
  ,lut2intp_X_info_7          //|> o
  ,lut2intp_X_sel             //|> o
  ,lut2intp_Y_sel             //|> o
  ,lut2intp_pvld              //|> o
  );
input         nvdla_core_clk;
input         nvdla_core_clk_orig;
input         nvdla_core_rstn;
input   [9:0] dp2lut_X_entry_0;
input   [9:0] dp2lut_X_entry_1;
input   [9:0] dp2lut_X_entry_2;
input   [9:0] dp2lut_X_entry_3;
input   [9:0] dp2lut_X_entry_4;
input   [9:0] dp2lut_X_entry_5;
input   [9:0] dp2lut_X_entry_6;
input   [9:0] dp2lut_X_entry_7;
input  [17:0] dp2lut_Xinfo_0;
input  [17:0] dp2lut_Xinfo_1;
input  [17:0] dp2lut_Xinfo_2;
input  [17:0] dp2lut_Xinfo_3;
input  [17:0] dp2lut_Xinfo_4;
input  [17:0] dp2lut_Xinfo_5;
input  [17:0] dp2lut_Xinfo_6;
input  [17:0] dp2lut_Xinfo_7;
input   [9:0] dp2lut_Y_entry_0;
input   [9:0] dp2lut_Y_entry_1;
input   [9:0] dp2lut_Y_entry_2;
input   [9:0] dp2lut_Y_entry_3;
input   [9:0] dp2lut_Y_entry_4;
input   [9:0] dp2lut_Y_entry_5;
input   [9:0] dp2lut_Y_entry_6;
input   [9:0] dp2lut_Y_entry_7;
input  [17:0] dp2lut_Yinfo_0;
input  [17:0] dp2lut_Yinfo_1;
input  [17:0] dp2lut_Yinfo_2;
input  [17:0] dp2lut_Yinfo_3;
input  [17:0] dp2lut_Yinfo_4;
input  [17:0] dp2lut_Yinfo_5;
input  [17:0] dp2lut_Yinfo_6;
input  [17:0] dp2lut_Yinfo_7;
input         dp2lut_pvld;
input         int8_en;
input         lut2intp_prdy;
input         nvdla_op_gated_clk_fp16;
input   [1:0] reg2dp_input_data_type;
input         reg2dp_lut_access_type;
input   [9:0] reg2dp_lut_addr;
input  [15:0] reg2dp_lut_data;
input         reg2dp_lut_data_trigger;
input         reg2dp_lut_hybrid_priority;
input         reg2dp_lut_oflow_priority;
input         reg2dp_lut_table_id;
input         reg2dp_lut_uflow_priority;
output        dp2lut_prdy;
output [15:0] dp2reg_lut_data;
output [31:0] lut2intp_X_data_00;
output [16:0] lut2intp_X_data_00_17b;
output [31:0] lut2intp_X_data_01;
output [31:0] lut2intp_X_data_10;
output [16:0] lut2intp_X_data_10_17b;
output [31:0] lut2intp_X_data_11;
output [31:0] lut2intp_X_data_20;
output [16:0] lut2intp_X_data_20_17b;
output [31:0] lut2intp_X_data_21;
output [31:0] lut2intp_X_data_30;
output [16:0] lut2intp_X_data_30_17b;
output [31:0] lut2intp_X_data_31;
output [31:0] lut2intp_X_data_40;
output [16:0] lut2intp_X_data_40_17b;
output [31:0] lut2intp_X_data_41;
output [31:0] lut2intp_X_data_50;
output [16:0] lut2intp_X_data_50_17b;
output [31:0] lut2intp_X_data_51;
output [31:0] lut2intp_X_data_60;
output [16:0] lut2intp_X_data_60_17b;
output [31:0] lut2intp_X_data_61;
output [31:0] lut2intp_X_data_70;
output [16:0] lut2intp_X_data_70_17b;
output [31:0] lut2intp_X_data_71;
output [19:0] lut2intp_X_info_0;
output [19:0] lut2intp_X_info_1;
output [19:0] lut2intp_X_info_2;
output [19:0] lut2intp_X_info_3;
output [19:0] lut2intp_X_info_4;
output [19:0] lut2intp_X_info_5;
output [19:0] lut2intp_X_info_6;
output [19:0] lut2intp_X_info_7;
output  [7:0] lut2intp_X_sel;
output  [7:0] lut2intp_Y_sel;
output        lut2intp_pvld;
reg    [15:0] density_out;
reg    [15:0] density_reg0;
reg    [15:0] density_reg1;
reg    [15:0] density_reg10;
reg    [15:0] density_reg100;
reg    [15:0] density_reg101;
reg    [15:0] density_reg102;
reg    [15:0] density_reg103;
reg    [15:0] density_reg104;
reg    [15:0] density_reg105;
reg    [15:0] density_reg106;
reg    [15:0] density_reg107;
reg    [15:0] density_reg108;
reg    [15:0] density_reg109;
reg    [15:0] density_reg11;
reg    [15:0] density_reg110;
reg    [15:0] density_reg111;
reg    [15:0] density_reg112;
reg    [15:0] density_reg113;
reg    [15:0] density_reg114;
reg    [15:0] density_reg115;
reg    [15:0] density_reg116;
reg    [15:0] density_reg117;
reg    [15:0] density_reg118;
reg    [15:0] density_reg119;
reg    [15:0] density_reg12;
reg    [15:0] density_reg120;
reg    [15:0] density_reg121;
reg    [15:0] density_reg122;
reg    [15:0] density_reg123;
reg    [15:0] density_reg124;
reg    [15:0] density_reg125;
reg    [15:0] density_reg126;
reg    [15:0] density_reg127;
reg    [15:0] density_reg128;
reg    [15:0] density_reg129;
reg    [15:0] density_reg13;
reg    [15:0] density_reg130;
reg    [15:0] density_reg131;
reg    [15:0] density_reg132;
reg    [15:0] density_reg133;
reg    [15:0] density_reg134;
reg    [15:0] density_reg135;
reg    [15:0] density_reg136;
reg    [15:0] density_reg137;
reg    [15:0] density_reg138;
reg    [15:0] density_reg139;
reg    [15:0] density_reg14;
reg    [15:0] density_reg140;
reg    [15:0] density_reg141;
reg    [15:0] density_reg142;
reg    [15:0] density_reg143;
reg    [15:0] density_reg144;
reg    [15:0] density_reg145;
reg    [15:0] density_reg146;
reg    [15:0] density_reg147;
reg    [15:0] density_reg148;
reg    [15:0] density_reg149;
reg    [15:0] density_reg15;
reg    [15:0] density_reg150;
reg    [15:0] density_reg151;
reg    [15:0] density_reg152;
reg    [15:0] density_reg153;
reg    [15:0] density_reg154;
reg    [15:0] density_reg155;
reg    [15:0] density_reg156;
reg    [15:0] density_reg157;
reg    [15:0] density_reg158;
reg    [15:0] density_reg159;
reg    [15:0] density_reg16;
reg    [15:0] density_reg160;
reg    [15:0] density_reg161;
reg    [15:0] density_reg162;
reg    [15:0] density_reg163;
reg    [15:0] density_reg164;
reg    [15:0] density_reg165;
reg    [15:0] density_reg166;
reg    [15:0] density_reg167;
reg    [15:0] density_reg168;
reg    [15:0] density_reg169;
reg    [15:0] density_reg17;
reg    [15:0] density_reg170;
reg    [15:0] density_reg171;
reg    [15:0] density_reg172;
reg    [15:0] density_reg173;
reg    [15:0] density_reg174;
reg    [15:0] density_reg175;
reg    [15:0] density_reg176;
reg    [15:0] density_reg177;
reg    [15:0] density_reg178;
reg    [15:0] density_reg179;
reg    [15:0] density_reg18;
reg    [15:0] density_reg180;
reg    [15:0] density_reg181;
reg    [15:0] density_reg182;
reg    [15:0] density_reg183;
reg    [15:0] density_reg184;
reg    [15:0] density_reg185;
reg    [15:0] density_reg186;
reg    [15:0] density_reg187;
reg    [15:0] density_reg188;
reg    [15:0] density_reg189;
reg    [15:0] density_reg19;
reg    [15:0] density_reg190;
reg    [15:0] density_reg191;
reg    [15:0] density_reg192;
reg    [15:0] density_reg193;
reg    [15:0] density_reg194;
reg    [15:0] density_reg195;
reg    [15:0] density_reg196;
reg    [15:0] density_reg197;
reg    [15:0] density_reg198;
reg    [15:0] density_reg199;
reg    [15:0] density_reg2;
reg    [15:0] density_reg20;
reg    [15:0] density_reg200;
reg    [15:0] density_reg201;
reg    [15:0] density_reg202;
reg    [15:0] density_reg203;
reg    [15:0] density_reg204;
reg    [15:0] density_reg205;
reg    [15:0] density_reg206;
reg    [15:0] density_reg207;
reg    [15:0] density_reg208;
reg    [15:0] density_reg209;
reg    [15:0] density_reg21;
reg    [15:0] density_reg210;
reg    [15:0] density_reg211;
reg    [15:0] density_reg212;
reg    [15:0] density_reg213;
reg    [15:0] density_reg214;
reg    [15:0] density_reg215;
reg    [15:0] density_reg216;
reg    [15:0] density_reg217;
reg    [15:0] density_reg218;
reg    [15:0] density_reg219;
reg    [15:0] density_reg22;
reg    [15:0] density_reg220;
reg    [15:0] density_reg221;
reg    [15:0] density_reg222;
reg    [15:0] density_reg223;
reg    [15:0] density_reg224;
reg    [15:0] density_reg225;
reg    [15:0] density_reg226;
reg    [15:0] density_reg227;
reg    [15:0] density_reg228;
reg    [15:0] density_reg229;
reg    [15:0] density_reg23;
reg    [15:0] density_reg230;
reg    [15:0] density_reg231;
reg    [15:0] density_reg232;
reg    [15:0] density_reg233;
reg    [15:0] density_reg234;
reg    [15:0] density_reg235;
reg    [15:0] density_reg236;
reg    [15:0] density_reg237;
reg    [15:0] density_reg238;
reg    [15:0] density_reg239;
reg    [15:0] density_reg24;
reg    [15:0] density_reg240;
reg    [15:0] density_reg241;
reg    [15:0] density_reg242;
reg    [15:0] density_reg243;
reg    [15:0] density_reg244;
reg    [15:0] density_reg245;
reg    [15:0] density_reg246;
reg    [15:0] density_reg247;
reg    [15:0] density_reg248;
reg    [15:0] density_reg249;
reg    [15:0] density_reg25;
reg    [15:0] density_reg250;
reg    [15:0] density_reg251;
reg    [15:0] density_reg252;
reg    [15:0] density_reg253;
reg    [15:0] density_reg254;
reg    [15:0] density_reg255;
reg    [15:0] density_reg256;
reg    [15:0] density_reg26;
reg    [15:0] density_reg27;
reg    [15:0] density_reg28;
reg    [15:0] density_reg29;
reg    [15:0] density_reg3;
reg    [15:0] density_reg30;
reg    [15:0] density_reg31;
reg    [15:0] density_reg32;
reg    [15:0] density_reg33;
reg    [15:0] density_reg34;
reg    [15:0] density_reg35;
reg    [15:0] density_reg36;
reg    [15:0] density_reg37;
reg    [15:0] density_reg38;
reg    [15:0] density_reg39;
reg    [15:0] density_reg4;
reg    [15:0] density_reg40;
reg    [15:0] density_reg41;
reg    [15:0] density_reg42;
reg    [15:0] density_reg43;
reg    [15:0] density_reg44;
reg    [15:0] density_reg45;
reg    [15:0] density_reg46;
reg    [15:0] density_reg47;
reg    [15:0] density_reg48;
reg    [15:0] density_reg49;
reg    [15:0] density_reg5;
reg    [15:0] density_reg50;
reg    [15:0] density_reg51;
reg    [15:0] density_reg52;
reg    [15:0] density_reg53;
reg    [15:0] density_reg54;
reg    [15:0] density_reg55;
reg    [15:0] density_reg56;
reg    [15:0] density_reg57;
reg    [15:0] density_reg58;
reg    [15:0] density_reg59;
reg    [15:0] density_reg6;
reg    [15:0] density_reg60;
reg    [15:0] density_reg61;
reg    [15:0] density_reg62;
reg    [15:0] density_reg63;
reg    [15:0] density_reg64;
reg    [15:0] density_reg65;
reg    [15:0] density_reg66;
reg    [15:0] density_reg67;
reg    [15:0] density_reg68;
reg    [15:0] density_reg69;
reg    [15:0] density_reg7;
reg    [15:0] density_reg70;
reg    [15:0] density_reg71;
reg    [15:0] density_reg72;
reg    [15:0] density_reg73;
reg    [15:0] density_reg74;
reg    [15:0] density_reg75;
reg    [15:0] density_reg76;
reg    [15:0] density_reg77;
reg    [15:0] density_reg78;
reg    [15:0] density_reg79;
reg    [15:0] density_reg8;
reg    [15:0] density_reg80;
reg    [15:0] density_reg81;
reg    [15:0] density_reg82;
reg    [15:0] density_reg83;
reg    [15:0] density_reg84;
reg    [15:0] density_reg85;
reg    [15:0] density_reg86;
reg    [15:0] density_reg87;
reg    [15:0] density_reg88;
reg    [15:0] density_reg89;
reg    [15:0] density_reg9;
reg    [15:0] density_reg90;
reg    [15:0] density_reg91;
reg    [15:0] density_reg92;
reg    [15:0] density_reg93;
reg    [15:0] density_reg94;
reg    [15:0] density_reg95;
reg    [15:0] density_reg96;
reg    [15:0] density_reg97;
reg    [15:0] density_reg98;
reg    [15:0] density_reg99;
reg           fp16_en_f;
reg    [31:0] lut2intp_X_data_00;
reg    [16:0] lut2intp_X_data_00_17b;
reg    [31:0] lut2intp_X_data_01;
reg    [31:0] lut2intp_X_data_10;
reg    [16:0] lut2intp_X_data_10_17b;
reg    [31:0] lut2intp_X_data_11;
reg    [31:0] lut2intp_X_data_20;
reg    [16:0] lut2intp_X_data_20_17b;
reg    [31:0] lut2intp_X_data_21;
reg    [31:0] lut2intp_X_data_30;
reg    [16:0] lut2intp_X_data_30_17b;
reg    [31:0] lut2intp_X_data_31;
reg    [31:0] lut2intp_X_data_40;
reg    [16:0] lut2intp_X_data_40_17b;
reg    [31:0] lut2intp_X_data_41;
reg    [31:0] lut2intp_X_data_50;
reg    [16:0] lut2intp_X_data_50_17b;
reg    [31:0] lut2intp_X_data_51;
reg    [31:0] lut2intp_X_data_60;
reg    [16:0] lut2intp_X_data_60_17b;
reg    [31:0] lut2intp_X_data_61;
reg    [31:0] lut2intp_X_data_70;
reg    [16:0] lut2intp_X_data_70_17b;
reg    [31:0] lut2intp_X_data_71;
reg    [19:0] lut2intp_X_info_0;
reg    [19:0] lut2intp_X_info_1;
reg    [19:0] lut2intp_X_info_2;
reg    [19:0] lut2intp_X_info_3;
reg    [19:0] lut2intp_X_info_4;
reg    [19:0] lut2intp_X_info_5;
reg    [19:0] lut2intp_X_info_6;
reg    [19:0] lut2intp_X_info_7;
reg     [7:0] lut2intp_X_sel;
reg     [7:0] lut2intp_Y_sel;
reg     [7:0] lutX_sel;
reg     [7:0] lutY_sel;
reg    [15:0] lut_X_data_00;
reg    [15:0] lut_X_data_01;
reg    [15:0] lut_X_data_10;
reg    [15:0] lut_X_data_11;
reg    [15:0] lut_X_data_20;
reg    [15:0] lut_X_data_21;
reg    [15:0] lut_X_data_30;
reg    [15:0] lut_X_data_31;
reg    [15:0] lut_X_data_40;
reg    [15:0] lut_X_data_41;
reg    [15:0] lut_X_data_50;
reg    [15:0] lut_X_data_51;
reg    [15:0] lut_X_data_60;
reg    [15:0] lut_X_data_61;
reg    [15:0] lut_X_data_70;
reg    [15:0] lut_X_data_71;
reg    [17:0] lut_X_info_0;
reg    [17:0] lut_X_info_1;
reg    [17:0] lut_X_info_2;
reg    [17:0] lut_X_info_3;
reg    [17:0] lut_X_info_4;
reg    [17:0] lut_X_info_5;
reg    [17:0] lut_X_info_6;
reg    [17:0] lut_X_info_7;
reg     [7:0] lut_X_sel;
reg    [15:0] lut_Y_data_00;
reg    [15:0] lut_Y_data_01;
reg    [15:0] lut_Y_data_10;
reg    [15:0] lut_Y_data_11;
reg    [15:0] lut_Y_data_20;
reg    [15:0] lut_Y_data_21;
reg    [15:0] lut_Y_data_30;
reg    [15:0] lut_Y_data_31;
reg    [15:0] lut_Y_data_40;
reg    [15:0] lut_Y_data_41;
reg    [15:0] lut_Y_data_50;
reg    [15:0] lut_Y_data_51;
reg    [15:0] lut_Y_data_60;
reg    [15:0] lut_Y_data_61;
reg    [15:0] lut_Y_data_70;
reg    [15:0] lut_Y_data_71;
reg    [17:0] lut_Y_info_0;
reg    [17:0] lut_Y_info_1;
reg    [17:0] lut_Y_info_2;
reg    [17:0] lut_Y_info_3;
reg    [17:0] lut_Y_info_4;
reg    [17:0] lut_Y_info_5;
reg    [17:0] lut_Y_info_6;
reg    [17:0] lut_Y_info_7;
reg     [7:0] lut_Y_sel;
reg           lut_pvld_f;
reg    [15:0] raw_out;
reg    [15:0] raw_reg0;
reg    [15:0] raw_reg1;
reg    [15:0] raw_reg10;
reg    [15:0] raw_reg11;
reg    [15:0] raw_reg12;
reg    [15:0] raw_reg13;
reg    [15:0] raw_reg14;
reg    [15:0] raw_reg15;
reg    [15:0] raw_reg16;
reg    [15:0] raw_reg17;
reg    [15:0] raw_reg18;
reg    [15:0] raw_reg19;
reg    [15:0] raw_reg2;
reg    [15:0] raw_reg20;
reg    [15:0] raw_reg21;
reg    [15:0] raw_reg22;
reg    [15:0] raw_reg23;
reg    [15:0] raw_reg24;
reg    [15:0] raw_reg25;
reg    [15:0] raw_reg26;
reg    [15:0] raw_reg27;
reg    [15:0] raw_reg28;
reg    [15:0] raw_reg29;
reg    [15:0] raw_reg3;
reg    [15:0] raw_reg30;
reg    [15:0] raw_reg31;
reg    [15:0] raw_reg32;
reg    [15:0] raw_reg33;
reg    [15:0] raw_reg34;
reg    [15:0] raw_reg35;
reg    [15:0] raw_reg36;
reg    [15:0] raw_reg37;
reg    [15:0] raw_reg38;
reg    [15:0] raw_reg39;
reg    [15:0] raw_reg4;
reg    [15:0] raw_reg40;
reg    [15:0] raw_reg41;
reg    [15:0] raw_reg42;
reg    [15:0] raw_reg43;
reg    [15:0] raw_reg44;
reg    [15:0] raw_reg45;
reg    [15:0] raw_reg46;
reg    [15:0] raw_reg47;
reg    [15:0] raw_reg48;
reg    [15:0] raw_reg49;
reg    [15:0] raw_reg5;
reg    [15:0] raw_reg50;
reg    [15:0] raw_reg51;
reg    [15:0] raw_reg52;
reg    [15:0] raw_reg53;
reg    [15:0] raw_reg54;
reg    [15:0] raw_reg55;
reg    [15:0] raw_reg56;
reg    [15:0] raw_reg57;
reg    [15:0] raw_reg58;
reg    [15:0] raw_reg59;
reg    [15:0] raw_reg6;
reg    [15:0] raw_reg60;
reg    [15:0] raw_reg61;
reg    [15:0] raw_reg62;
reg    [15:0] raw_reg63;
reg    [15:0] raw_reg64;
reg    [15:0] raw_reg7;
reg    [15:0] raw_reg8;
reg    [15:0] raw_reg9;
wire    [3:0] FMcvt_in_rdy;
wire    [3:0] FMcvt_in_vld;
wire    [3:0] FMcvt_out_rdy;
wire    [3:0] FMcvt_out_vld;
wire          both_hybrid_sel;
wire          both_of_sel;
wire          both_uf_sel;
wire          dp2lut_prdy_f;
wire          fp_lut_prdy_f;
wire          fp_lut_pvld_f;
wire          fp_out_prdy;
wire          fp_out_vld;
wire          load_din;
wire   [15:0] lutX_data_00;
wire   [15:0] lutX_data_01;
wire   [15:0] lutX_data_10;
wire   [15:0] lutX_data_11;
wire   [15:0] lutX_data_20;
wire   [15:0] lutX_data_21;
wire   [15:0] lutX_data_30;
wire   [15:0] lutX_data_31;
wire   [15:0] lutX_data_40;
wire   [15:0] lutX_data_41;
wire   [15:0] lutX_data_50;
wire   [15:0] lutX_data_51;
wire   [15:0] lutX_data_60;
wire   [15:0] lutX_data_61;
wire   [15:0] lutX_data_70;
wire   [15:0] lutX_data_71;
wire   [15:0] lutX_info_0;
wire   [15:0] lutX_info_1;
wire   [15:0] lutX_info_2;
wire   [15:0] lutX_info_3;
wire   [15:0] lutX_info_4;
wire   [15:0] lutX_info_5;
wire   [15:0] lutX_info_6;
wire   [15:0] lutX_info_7;
wire    [3:0] lutX_sel_o;
wire    [3:0] lutY_sel_o;
wire   [31:0] lut_X_dat_00;
wire   [16:0] lut_X_dat_00_fp17;
wire   [31:0] lut_X_dat_01;
wire   [31:0] lut_X_dat_10;
wire   [16:0] lut_X_dat_10_fp17;
wire   [31:0] lut_X_dat_11;
wire   [31:0] lut_X_dat_20;
wire   [16:0] lut_X_dat_20_fp17;
wire   [31:0] lut_X_dat_21;
wire   [31:0] lut_X_dat_30;
wire   [16:0] lut_X_dat_30_fp17;
wire   [31:0] lut_X_dat_31;
wire   [20:0] lut_X_inf_0;
wire   [20:0] lut_X_inf_1;
wire   [20:0] lut_X_inf_2;
wire   [20:0] lut_X_inf_3;
wire          lut_prdy;
wire          lut_wr_en;
wire          raw_select;
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
assign lut_wr_en = (reg2dp_lut_access_type== 1'h1 ) && reg2dp_lut_data_trigger;
assign raw_select = (reg2dp_lut_table_id == 1'h0 );
//==========================================
//LUT write 
//------------------------------------------
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg0 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 0) 
              raw_reg0 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg1 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 1) 
              raw_reg1 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg2 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 2) 
              raw_reg2 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg3 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 3) 
              raw_reg3 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg4 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 4) 
              raw_reg4 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg5 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 5) 
              raw_reg5 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg6 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 6) 
              raw_reg6 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg7 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 7) 
              raw_reg7 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg8 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 8) 
              raw_reg8 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg9 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 9) 
              raw_reg9 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg10 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 10) 
              raw_reg10 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg11 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 11) 
              raw_reg11 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg12 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 12) 
              raw_reg12 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg13 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 13) 
              raw_reg13 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg14 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 14) 
              raw_reg14 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg15 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 15) 
              raw_reg15 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg16 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 16) 
              raw_reg16 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg17 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 17) 
              raw_reg17 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg18 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 18) 
              raw_reg18 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg19 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 19) 
              raw_reg19 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg20 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 20) 
              raw_reg20 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg21 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 21) 
              raw_reg21 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg22 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 22) 
              raw_reg22 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg23 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 23) 
              raw_reg23 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg24 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 24) 
              raw_reg24 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg25 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 25) 
              raw_reg25 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg26 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 26) 
              raw_reg26 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg27 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 27) 
              raw_reg27 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg28 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 28) 
              raw_reg28 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg29 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 29) 
              raw_reg29 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg30 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 30) 
              raw_reg30 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg31 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 31) 
              raw_reg31 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg32 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 32) 
              raw_reg32 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg33 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 33) 
              raw_reg33 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg34 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 34) 
              raw_reg34 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg35 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 35) 
              raw_reg35 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg36 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 36) 
              raw_reg36 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg37 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 37) 
              raw_reg37 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg38 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 38) 
              raw_reg38 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg39 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 39) 
              raw_reg39 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg40 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 40) 
              raw_reg40 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg41 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 41) 
              raw_reg41 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg42 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 42) 
              raw_reg42 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg43 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 43) 
              raw_reg43 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg44 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 44) 
              raw_reg44 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg45 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 45) 
              raw_reg45 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg46 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 46) 
              raw_reg46 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg47 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 47) 
              raw_reg47 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg48 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 48) 
              raw_reg48 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg49 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 49) 
              raw_reg49 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg50 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 50) 
              raw_reg50 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg51 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 51) 
              raw_reg51 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg52 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 52) 
              raw_reg52 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg53 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 53) 
              raw_reg53 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg54 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 54) 
              raw_reg54 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg55 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 55) 
              raw_reg55 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg56 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 56) 
              raw_reg56 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg57 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 57) 
              raw_reg57 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg58 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 58) 
              raw_reg58 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg59 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 59) 
              raw_reg59 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg60 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 60) 
              raw_reg60 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg61 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 61) 
              raw_reg61 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg62 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 62) 
              raw_reg62 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg63 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 63) 
              raw_reg63 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     raw_reg64 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & raw_select) begin 
         if (reg2dp_lut_addr[9:0] == 64) 
              raw_reg64 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
//------------------------------------------
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg0 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 0) 
              density_reg0 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg1 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 1) 
              density_reg1 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg2 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 2) 
              density_reg2 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg3 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 3) 
              density_reg3 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg4 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 4) 
              density_reg4 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg5 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 5) 
              density_reg5 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg6 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 6) 
              density_reg6 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg7 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 7) 
              density_reg7 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg8 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 8) 
              density_reg8 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg9 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 9) 
              density_reg9 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg10 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 10) 
              density_reg10 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg11 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 11) 
              density_reg11 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg12 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 12) 
              density_reg12 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg13 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 13) 
              density_reg13 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg14 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 14) 
              density_reg14 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg15 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 15) 
              density_reg15 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg16 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 16) 
              density_reg16 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg17 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 17) 
              density_reg17 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg18 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 18) 
              density_reg18 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg19 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 19) 
              density_reg19 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg20 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 20) 
              density_reg20 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg21 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 21) 
              density_reg21 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg22 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 22) 
              density_reg22 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg23 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 23) 
              density_reg23 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg24 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 24) 
              density_reg24 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg25 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 25) 
              density_reg25 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg26 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 26) 
              density_reg26 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg27 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 27) 
              density_reg27 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg28 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 28) 
              density_reg28 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg29 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 29) 
              density_reg29 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg30 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 30) 
              density_reg30 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg31 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 31) 
              density_reg31 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg32 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 32) 
              density_reg32 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg33 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 33) 
              density_reg33 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg34 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 34) 
              density_reg34 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg35 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 35) 
              density_reg35 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg36 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 36) 
              density_reg36 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg37 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 37) 
              density_reg37 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg38 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 38) 
              density_reg38 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg39 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 39) 
              density_reg39 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg40 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 40) 
              density_reg40 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg41 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 41) 
              density_reg41 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg42 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 42) 
              density_reg42 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg43 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 43) 
              density_reg43 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg44 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 44) 
              density_reg44 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg45 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 45) 
              density_reg45 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg46 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 46) 
              density_reg46 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg47 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 47) 
              density_reg47 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg48 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 48) 
              density_reg48 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg49 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 49) 
              density_reg49 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg50 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 50) 
              density_reg50 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg51 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 51) 
              density_reg51 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg52 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 52) 
              density_reg52 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg53 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 53) 
              density_reg53 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg54 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 54) 
              density_reg54 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg55 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 55) 
              density_reg55 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg56 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 56) 
              density_reg56 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg57 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 57) 
              density_reg57 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg58 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 58) 
              density_reg58 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg59 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 59) 
              density_reg59 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg60 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 60) 
              density_reg60 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg61 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 61) 
              density_reg61 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg62 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 62) 
              density_reg62 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg63 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 63) 
              density_reg63 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg64 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 64) 
              density_reg64 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg65 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 65) 
              density_reg65 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg66 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 66) 
              density_reg66 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg67 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 67) 
              density_reg67 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg68 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 68) 
              density_reg68 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg69 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 69) 
              density_reg69 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg70 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 70) 
              density_reg70 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg71 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 71) 
              density_reg71 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg72 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 72) 
              density_reg72 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg73 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 73) 
              density_reg73 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg74 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 74) 
              density_reg74 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg75 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 75) 
              density_reg75 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg76 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 76) 
              density_reg76 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg77 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 77) 
              density_reg77 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg78 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 78) 
              density_reg78 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg79 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 79) 
              density_reg79 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg80 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 80) 
              density_reg80 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg81 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 81) 
              density_reg81 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg82 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 82) 
              density_reg82 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg83 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 83) 
              density_reg83 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg84 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 84) 
              density_reg84 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg85 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 85) 
              density_reg85 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg86 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 86) 
              density_reg86 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg87 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 87) 
              density_reg87 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg88 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 88) 
              density_reg88 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg89 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 89) 
              density_reg89 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg90 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 90) 
              density_reg90 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg91 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 91) 
              density_reg91 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg92 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 92) 
              density_reg92 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg93 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 93) 
              density_reg93 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg94 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 94) 
              density_reg94 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg95 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 95) 
              density_reg95 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg96 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 96) 
              density_reg96 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg97 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 97) 
              density_reg97 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg98 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 98) 
              density_reg98 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg99 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 99) 
              density_reg99 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg100 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 100) 
              density_reg100 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg101 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 101) 
              density_reg101 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg102 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 102) 
              density_reg102 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg103 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 103) 
              density_reg103 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg104 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 104) 
              density_reg104 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg105 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 105) 
              density_reg105 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg106 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 106) 
              density_reg106 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg107 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 107) 
              density_reg107 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg108 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 108) 
              density_reg108 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg109 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 109) 
              density_reg109 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg110 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 110) 
              density_reg110 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg111 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 111) 
              density_reg111 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg112 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 112) 
              density_reg112 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg113 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 113) 
              density_reg113 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg114 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 114) 
              density_reg114 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg115 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 115) 
              density_reg115 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg116 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 116) 
              density_reg116 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg117 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 117) 
              density_reg117 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg118 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 118) 
              density_reg118 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg119 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 119) 
              density_reg119 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg120 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 120) 
              density_reg120 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg121 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 121) 
              density_reg121 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg122 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 122) 
              density_reg122 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg123 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 123) 
              density_reg123 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg124 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 124) 
              density_reg124 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg125 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 125) 
              density_reg125 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg126 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 126) 
              density_reg126 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg127 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 127) 
              density_reg127 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg128 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 128) 
              density_reg128 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg129 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 129) 
              density_reg129 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg130 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 130) 
              density_reg130 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg131 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 131) 
              density_reg131 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg132 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 132) 
              density_reg132 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg133 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 133) 
              density_reg133 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg134 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 134) 
              density_reg134 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg135 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 135) 
              density_reg135 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg136 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 136) 
              density_reg136 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg137 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 137) 
              density_reg137 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg138 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 138) 
              density_reg138 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg139 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 139) 
              density_reg139 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg140 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 140) 
              density_reg140 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg141 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 141) 
              density_reg141 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg142 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 142) 
              density_reg142 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg143 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 143) 
              density_reg143 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg144 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 144) 
              density_reg144 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg145 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 145) 
              density_reg145 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg146 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 146) 
              density_reg146 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg147 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 147) 
              density_reg147 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg148 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 148) 
              density_reg148 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg149 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 149) 
              density_reg149 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg150 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 150) 
              density_reg150 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg151 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 151) 
              density_reg151 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg152 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 152) 
              density_reg152 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg153 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 153) 
              density_reg153 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg154 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 154) 
              density_reg154 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg155 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 155) 
              density_reg155 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg156 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 156) 
              density_reg156 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg157 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 157) 
              density_reg157 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg158 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 158) 
              density_reg158 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg159 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 159) 
              density_reg159 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg160 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 160) 
              density_reg160 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg161 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 161) 
              density_reg161 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg162 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 162) 
              density_reg162 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg163 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 163) 
              density_reg163 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg164 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 164) 
              density_reg164 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg165 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 165) 
              density_reg165 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg166 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 166) 
              density_reg166 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg167 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 167) 
              density_reg167 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg168 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 168) 
              density_reg168 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg169 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 169) 
              density_reg169 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg170 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 170) 
              density_reg170 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg171 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 171) 
              density_reg171 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg172 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 172) 
              density_reg172 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg173 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 173) 
              density_reg173 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg174 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 174) 
              density_reg174 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg175 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 175) 
              density_reg175 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg176 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 176) 
              density_reg176 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg177 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 177) 
              density_reg177 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg178 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 178) 
              density_reg178 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg179 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 179) 
              density_reg179 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg180 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 180) 
              density_reg180 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg181 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 181) 
              density_reg181 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg182 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 182) 
              density_reg182 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg183 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 183) 
              density_reg183 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg184 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 184) 
              density_reg184 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg185 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 185) 
              density_reg185 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg186 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 186) 
              density_reg186 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg187 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 187) 
              density_reg187 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg188 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 188) 
              density_reg188 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg189 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 189) 
              density_reg189 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg190 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 190) 
              density_reg190 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg191 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 191) 
              density_reg191 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg192 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 192) 
              density_reg192 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg193 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 193) 
              density_reg193 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg194 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 194) 
              density_reg194 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg195 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 195) 
              density_reg195 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg196 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 196) 
              density_reg196 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg197 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 197) 
              density_reg197 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg198 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 198) 
              density_reg198 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg199 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 199) 
              density_reg199 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg200 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 200) 
              density_reg200 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg201 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 201) 
              density_reg201 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg202 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 202) 
              density_reg202 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg203 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 203) 
              density_reg203 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg204 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 204) 
              density_reg204 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg205 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 205) 
              density_reg205 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg206 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 206) 
              density_reg206 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg207 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 207) 
              density_reg207 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg208 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 208) 
              density_reg208 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg209 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 209) 
              density_reg209 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg210 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 210) 
              density_reg210 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg211 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 211) 
              density_reg211 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg212 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 212) 
              density_reg212 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg213 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 213) 
              density_reg213 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg214 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 214) 
              density_reg214 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg215 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 215) 
              density_reg215 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg216 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 216) 
              density_reg216 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg217 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 217) 
              density_reg217 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg218 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 218) 
              density_reg218 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg219 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 219) 
              density_reg219 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg220 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 220) 
              density_reg220 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg221 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 221) 
              density_reg221 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg222 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 222) 
              density_reg222 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg223 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 223) 
              density_reg223 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg224 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 224) 
              density_reg224 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg225 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 225) 
              density_reg225 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg226 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 226) 
              density_reg226 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg227 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 227) 
              density_reg227 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg228 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 228) 
              density_reg228 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg229 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 229) 
              density_reg229 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg230 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 230) 
              density_reg230 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg231 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 231) 
              density_reg231 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg232 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 232) 
              density_reg232 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg233 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 233) 
              density_reg233 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg234 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 234) 
              density_reg234 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg235 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 235) 
              density_reg235 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg236 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 236) 
              density_reg236 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg237 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 237) 
              density_reg237 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg238 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 238) 
              density_reg238 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg239 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 239) 
              density_reg239 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg240 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 240) 
              density_reg240 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg241 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 241) 
              density_reg241 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg242 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 242) 
              density_reg242 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg243 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 243) 
              density_reg243 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg244 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 244) 
              density_reg244 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg245 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 245) 
              density_reg245 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg246 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 246) 
              density_reg246 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg247 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 247) 
              density_reg247 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg248 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 248) 
              density_reg248 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg249 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 249) 
              density_reg249 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg250 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 250) 
              density_reg250 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg251 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 251) 
              density_reg251 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg252 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 252) 
              density_reg252 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg253 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 253) 
              density_reg253 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg254 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 254) 
              density_reg254 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg255 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 255) 
              density_reg255 <= reg2dp_lut_data[15:0]; 
     end
   end
 end
 always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     density_reg256 <= {16{1'b0}};
   end else begin
     if (lut_wr_en & (~raw_select)) begin 
         if (reg2dp_lut_addr[9:0] == 256) 
              density_reg256 <= reg2dp_lut_data[15:0]; 
     end
   end
 end

//==========================================
//LUT read
//------------------------------------------
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    raw_out <= {16{1'b0}};
  end else begin
 case(reg2dp_lut_addr[9:0]) 
 0: 
      raw_out <= raw_reg0; 
 1: 
      raw_out <= raw_reg1; 
 2: 
      raw_out <= raw_reg2; 
 3: 
      raw_out <= raw_reg3; 
 4: 
      raw_out <= raw_reg4; 
 5: 
      raw_out <= raw_reg5; 
 6: 
      raw_out <= raw_reg6; 
 7: 
      raw_out <= raw_reg7; 
 8: 
      raw_out <= raw_reg8; 
 9: 
      raw_out <= raw_reg9; 
 10: 
      raw_out <= raw_reg10; 
 11: 
      raw_out <= raw_reg11; 
 12: 
      raw_out <= raw_reg12; 
 13: 
      raw_out <= raw_reg13; 
 14: 
      raw_out <= raw_reg14; 
 15: 
      raw_out <= raw_reg15; 
 16: 
      raw_out <= raw_reg16; 
 17: 
      raw_out <= raw_reg17; 
 18: 
      raw_out <= raw_reg18; 
 19: 
      raw_out <= raw_reg19; 
 20: 
      raw_out <= raw_reg20; 
 21: 
      raw_out <= raw_reg21; 
 22: 
      raw_out <= raw_reg22; 
 23: 
      raw_out <= raw_reg23; 
 24: 
      raw_out <= raw_reg24; 
 25: 
      raw_out <= raw_reg25; 
 26: 
      raw_out <= raw_reg26; 
 27: 
      raw_out <= raw_reg27; 
 28: 
      raw_out <= raw_reg28; 
 29: 
      raw_out <= raw_reg29; 
 30: 
      raw_out <= raw_reg30; 
 31: 
      raw_out <= raw_reg31; 
 32: 
      raw_out <= raw_reg32; 
 33: 
      raw_out <= raw_reg33; 
 34: 
      raw_out <= raw_reg34; 
 35: 
      raw_out <= raw_reg35; 
 36: 
      raw_out <= raw_reg36; 
 37: 
      raw_out <= raw_reg37; 
 38: 
      raw_out <= raw_reg38; 
 39: 
      raw_out <= raw_reg39; 
 40: 
      raw_out <= raw_reg40; 
 41: 
      raw_out <= raw_reg41; 
 42: 
      raw_out <= raw_reg42; 
 43: 
      raw_out <= raw_reg43; 
 44: 
      raw_out <= raw_reg44; 
 45: 
      raw_out <= raw_reg45; 
 46: 
      raw_out <= raw_reg46; 
 47: 
      raw_out <= raw_reg47; 
 48: 
      raw_out <= raw_reg48; 
 49: 
      raw_out <= raw_reg49; 
 50: 
      raw_out <= raw_reg50; 
 51: 
      raw_out <= raw_reg51; 
 52: 
      raw_out <= raw_reg52; 
 53: 
      raw_out <= raw_reg53; 
 54: 
      raw_out <= raw_reg54; 
 55: 
      raw_out <= raw_reg55; 
 56: 
      raw_out <= raw_reg56; 
 57: 
      raw_out <= raw_reg57; 
 58: 
      raw_out <= raw_reg58; 
 59: 
      raw_out <= raw_reg59; 
 60: 
      raw_out <= raw_reg60; 
 61: 
      raw_out <= raw_reg61; 
 62: 
      raw_out <= raw_reg62; 
 63: 
      raw_out <= raw_reg63; 
 64: 
      raw_out <= raw_reg64; 
 default: raw_out <= raw_reg0; 
 endcase 
  end
end

always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    density_out <= {16{1'b0}};
  end else begin
 case (reg2dp_lut_addr[9:0]) 
 0: 
      density_out <= density_reg0; 
 1: 
      density_out <= density_reg1; 
 2: 
      density_out <= density_reg2; 
 3: 
      density_out <= density_reg3; 
 4: 
      density_out <= density_reg4; 
 5: 
      density_out <= density_reg5; 
 6: 
      density_out <= density_reg6; 
 7: 
      density_out <= density_reg7; 
 8: 
      density_out <= density_reg8; 
 9: 
      density_out <= density_reg9; 
 10: 
      density_out <= density_reg10; 
 11: 
      density_out <= density_reg11; 
 12: 
      density_out <= density_reg12; 
 13: 
      density_out <= density_reg13; 
 14: 
      density_out <= density_reg14; 
 15: 
      density_out <= density_reg15; 
 16: 
      density_out <= density_reg16; 
 17: 
      density_out <= density_reg17; 
 18: 
      density_out <= density_reg18; 
 19: 
      density_out <= density_reg19; 
 20: 
      density_out <= density_reg20; 
 21: 
      density_out <= density_reg21; 
 22: 
      density_out <= density_reg22; 
 23: 
      density_out <= density_reg23; 
 24: 
      density_out <= density_reg24; 
 25: 
      density_out <= density_reg25; 
 26: 
      density_out <= density_reg26; 
 27: 
      density_out <= density_reg27; 
 28: 
      density_out <= density_reg28; 
 29: 
      density_out <= density_reg29; 
 30: 
      density_out <= density_reg30; 
 31: 
      density_out <= density_reg31; 
 32: 
      density_out <= density_reg32; 
 33: 
      density_out <= density_reg33; 
 34: 
      density_out <= density_reg34; 
 35: 
      density_out <= density_reg35; 
 36: 
      density_out <= density_reg36; 
 37: 
      density_out <= density_reg37; 
 38: 
      density_out <= density_reg38; 
 39: 
      density_out <= density_reg39; 
 40: 
      density_out <= density_reg40; 
 41: 
      density_out <= density_reg41; 
 42: 
      density_out <= density_reg42; 
 43: 
      density_out <= density_reg43; 
 44: 
      density_out <= density_reg44; 
 45: 
      density_out <= density_reg45; 
 46: 
      density_out <= density_reg46; 
 47: 
      density_out <= density_reg47; 
 48: 
      density_out <= density_reg48; 
 49: 
      density_out <= density_reg49; 
 50: 
      density_out <= density_reg50; 
 51: 
      density_out <= density_reg51; 
 52: 
      density_out <= density_reg52; 
 53: 
      density_out <= density_reg53; 
 54: 
      density_out <= density_reg54; 
 55: 
      density_out <= density_reg55; 
 56: 
      density_out <= density_reg56; 
 57: 
      density_out <= density_reg57; 
 58: 
      density_out <= density_reg58; 
 59: 
      density_out <= density_reg59; 
 60: 
      density_out <= density_reg60; 
 61: 
      density_out <= density_reg61; 
 62: 
      density_out <= density_reg62; 
 63: 
      density_out <= density_reg63; 
 64: 
      density_out <= density_reg64; 
 65: 
      density_out <= density_reg65; 
 66: 
      density_out <= density_reg66; 
 67: 
      density_out <= density_reg67; 
 68: 
      density_out <= density_reg68; 
 69: 
      density_out <= density_reg69; 
 70: 
      density_out <= density_reg70; 
 71: 
      density_out <= density_reg71; 
 72: 
      density_out <= density_reg72; 
 73: 
      density_out <= density_reg73; 
 74: 
      density_out <= density_reg74; 
 75: 
      density_out <= density_reg75; 
 76: 
      density_out <= density_reg76; 
 77: 
      density_out <= density_reg77; 
 78: 
      density_out <= density_reg78; 
 79: 
      density_out <= density_reg79; 
 80: 
      density_out <= density_reg80; 
 81: 
      density_out <= density_reg81; 
 82: 
      density_out <= density_reg82; 
 83: 
      density_out <= density_reg83; 
 84: 
      density_out <= density_reg84; 
 85: 
      density_out <= density_reg85; 
 86: 
      density_out <= density_reg86; 
 87: 
      density_out <= density_reg87; 
 88: 
      density_out <= density_reg88; 
 89: 
      density_out <= density_reg89; 
 90: 
      density_out <= density_reg90; 
 91: 
      density_out <= density_reg91; 
 92: 
      density_out <= density_reg92; 
 93: 
      density_out <= density_reg93; 
 94: 
      density_out <= density_reg94; 
 95: 
      density_out <= density_reg95; 
 96: 
      density_out <= density_reg96; 
 97: 
      density_out <= density_reg97; 
 98: 
      density_out <= density_reg98; 
 99: 
      density_out <= density_reg99; 
 100: 
      density_out <= density_reg100; 
 101: 
      density_out <= density_reg101; 
 102: 
      density_out <= density_reg102; 
 103: 
      density_out <= density_reg103; 
 104: 
      density_out <= density_reg104; 
 105: 
      density_out <= density_reg105; 
 106: 
      density_out <= density_reg106; 
 107: 
      density_out <= density_reg107; 
 108: 
      density_out <= density_reg108; 
 109: 
      density_out <= density_reg109; 
 110: 
      density_out <= density_reg110; 
 111: 
      density_out <= density_reg111; 
 112: 
      density_out <= density_reg112; 
 113: 
      density_out <= density_reg113; 
 114: 
      density_out <= density_reg114; 
 115: 
      density_out <= density_reg115; 
 116: 
      density_out <= density_reg116; 
 117: 
      density_out <= density_reg117; 
 118: 
      density_out <= density_reg118; 
 119: 
      density_out <= density_reg119; 
 120: 
      density_out <= density_reg120; 
 121: 
      density_out <= density_reg121; 
 122: 
      density_out <= density_reg122; 
 123: 
      density_out <= density_reg123; 
 124: 
      density_out <= density_reg124; 
 125: 
      density_out <= density_reg125; 
 126: 
      density_out <= density_reg126; 
 127: 
      density_out <= density_reg127; 
 128: 
      density_out <= density_reg128; 
 129: 
      density_out <= density_reg129; 
 130: 
      density_out <= density_reg130; 
 131: 
      density_out <= density_reg131; 
 132: 
      density_out <= density_reg132; 
 133: 
      density_out <= density_reg133; 
 134: 
      density_out <= density_reg134; 
 135: 
      density_out <= density_reg135; 
 136: 
      density_out <= density_reg136; 
 137: 
      density_out <= density_reg137; 
 138: 
      density_out <= density_reg138; 
 139: 
      density_out <= density_reg139; 
 140: 
      density_out <= density_reg140; 
 141: 
      density_out <= density_reg141; 
 142: 
      density_out <= density_reg142; 
 143: 
      density_out <= density_reg143; 
 144: 
      density_out <= density_reg144; 
 145: 
      density_out <= density_reg145; 
 146: 
      density_out <= density_reg146; 
 147: 
      density_out <= density_reg147; 
 148: 
      density_out <= density_reg148; 
 149: 
      density_out <= density_reg149; 
 150: 
      density_out <= density_reg150; 
 151: 
      density_out <= density_reg151; 
 152: 
      density_out <= density_reg152; 
 153: 
      density_out <= density_reg153; 
 154: 
      density_out <= density_reg154; 
 155: 
      density_out <= density_reg155; 
 156: 
      density_out <= density_reg156; 
 157: 
      density_out <= density_reg157; 
 158: 
      density_out <= density_reg158; 
 159: 
      density_out <= density_reg159; 
 160: 
      density_out <= density_reg160; 
 161: 
      density_out <= density_reg161; 
 162: 
      density_out <= density_reg162; 
 163: 
      density_out <= density_reg163; 
 164: 
      density_out <= density_reg164; 
 165: 
      density_out <= density_reg165; 
 166: 
      density_out <= density_reg166; 
 167: 
      density_out <= density_reg167; 
 168: 
      density_out <= density_reg168; 
 169: 
      density_out <= density_reg169; 
 170: 
      density_out <= density_reg170; 
 171: 
      density_out <= density_reg171; 
 172: 
      density_out <= density_reg172; 
 173: 
      density_out <= density_reg173; 
 174: 
      density_out <= density_reg174; 
 175: 
      density_out <= density_reg175; 
 176: 
      density_out <= density_reg176; 
 177: 
      density_out <= density_reg177; 
 178: 
      density_out <= density_reg178; 
 179: 
      density_out <= density_reg179; 
 180: 
      density_out <= density_reg180; 
 181: 
      density_out <= density_reg181; 
 182: 
      density_out <= density_reg182; 
 183: 
      density_out <= density_reg183; 
 184: 
      density_out <= density_reg184; 
 185: 
      density_out <= density_reg185; 
 186: 
      density_out <= density_reg186; 
 187: 
      density_out <= density_reg187; 
 188: 
      density_out <= density_reg188; 
 189: 
      density_out <= density_reg189; 
 190: 
      density_out <= density_reg190; 
 191: 
      density_out <= density_reg191; 
 192: 
      density_out <= density_reg192; 
 193: 
      density_out <= density_reg193; 
 194: 
      density_out <= density_reg194; 
 195: 
      density_out <= density_reg195; 
 196: 
      density_out <= density_reg196; 
 197: 
      density_out <= density_reg197; 
 198: 
      density_out <= density_reg198; 
 199: 
      density_out <= density_reg199; 
 200: 
      density_out <= density_reg200; 
 201: 
      density_out <= density_reg201; 
 202: 
      density_out <= density_reg202; 
 203: 
      density_out <= density_reg203; 
 204: 
      density_out <= density_reg204; 
 205: 
      density_out <= density_reg205; 
 206: 
      density_out <= density_reg206; 
 207: 
      density_out <= density_reg207; 
 208: 
      density_out <= density_reg208; 
 209: 
      density_out <= density_reg209; 
 210: 
      density_out <= density_reg210; 
 211: 
      density_out <= density_reg211; 
 212: 
      density_out <= density_reg212; 
 213: 
      density_out <= density_reg213; 
 214: 
      density_out <= density_reg214; 
 215: 
      density_out <= density_reg215; 
 216: 
      density_out <= density_reg216; 
 217: 
      density_out <= density_reg217; 
 218: 
      density_out <= density_reg218; 
 219: 
      density_out <= density_reg219; 
 220: 
      density_out <= density_reg220; 
 221: 
      density_out <= density_reg221; 
 222: 
      density_out <= density_reg222; 
 223: 
      density_out <= density_reg223; 
 224: 
      density_out <= density_reg224; 
 225: 
      density_out <= density_reg225; 
 226: 
      density_out <= density_reg226; 
 227: 
      density_out <= density_reg227; 
 228: 
      density_out <= density_reg228; 
 229: 
      density_out <= density_reg229; 
 230: 
      density_out <= density_reg230; 
 231: 
      density_out <= density_reg231; 
 232: 
      density_out <= density_reg232; 
 233: 
      density_out <= density_reg233; 
 234: 
      density_out <= density_reg234; 
 235: 
      density_out <= density_reg235; 
 236: 
      density_out <= density_reg236; 
 237: 
      density_out <= density_reg237; 
 238: 
      density_out <= density_reg238; 
 239: 
      density_out <= density_reg239; 
 240: 
      density_out <= density_reg240; 
 241: 
      density_out <= density_reg241; 
 242: 
      density_out <= density_reg242; 
 243: 
      density_out <= density_reg243; 
 244: 
      density_out <= density_reg244; 
 245: 
      density_out <= density_reg245; 
 246: 
      density_out <= density_reg246; 
 247: 
      density_out <= density_reg247; 
 248: 
      density_out <= density_reg248; 
 249: 
      density_out <= density_reg249; 
 250: 
      density_out <= density_reg250; 
 251: 
      density_out <= density_reg251; 
 252: 
      density_out <= density_reg252; 
 253: 
      density_out <= density_reg253; 
 254: 
      density_out <= density_reg254; 
 255: 
      density_out <= density_reg255; 
 256: 
      density_out <= density_reg256; 
 default: density_out <= density_reg0; 
 endcase 
  end
end

assign dp2reg_lut_data[15:0] = raw_select ? raw_out : density_out;

//==========================================
//data to DP
//------------------------------------------


assign load_din = dp2lut_pvld & dp2lut_prdy_f;
assign dp2lut_prdy_f = ~lut_pvld_f | lut_prdy;
assign dp2lut_prdy = dp2lut_prdy_f;

/////////////////////////////////
//lut look up select control
/////////////////////////////////
assign both_hybrid_sel = (reg2dp_lut_hybrid_priority == 1'h1 );
assign both_of_sel  = (reg2dp_lut_oflow_priority == 1'h1 );
assign both_uf_sel  = (reg2dp_lut_uflow_priority == 1'h1 );

 always @(
   dp2lut_Xinfo_0
   or dp2lut_Yinfo_0
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      case({dp2lut_Xinfo_0[17:16],dp2lut_Yinfo_0[17:16]}) 
      4'b0000,4'b0110,4'b1001: lut_X_sel[0] = ~both_hybrid_sel; //both hit, or one uflow and the other oflow 
      4'b0001,4'b0010: lut_X_sel[0] = 1'b1; //X hit, Y uflow/oflow 
      4'b0100,4'b1000: lut_X_sel[0] = 1'b0; //X uflow/oflow, Y hit 
      4'b0101: lut_X_sel[0] = ~both_uf_sel ; //both uflow 
      4'b1010: lut_X_sel[0] = ~both_of_sel ; //both oflow 
      default: lut_X_sel[0] = 1'd0; 
      endcase 
 end
 always @(
   dp2lut_Xinfo_1
   or dp2lut_Yinfo_1
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      case({dp2lut_Xinfo_1[17:16],dp2lut_Yinfo_1[17:16]}) 
      4'b0000,4'b0110,4'b1001: lut_X_sel[1] = ~both_hybrid_sel; //both hit, or one uflow and the other oflow 
      4'b0001,4'b0010: lut_X_sel[1] = 1'b1; //X hit, Y uflow/oflow 
      4'b0100,4'b1000: lut_X_sel[1] = 1'b0; //X uflow/oflow, Y hit 
      4'b0101: lut_X_sel[1] = ~both_uf_sel ; //both uflow 
      4'b1010: lut_X_sel[1] = ~both_of_sel ; //both oflow 
      default: lut_X_sel[1] = 1'd0; 
      endcase 
 end
 always @(
   dp2lut_Xinfo_2
   or dp2lut_Yinfo_2
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      case({dp2lut_Xinfo_2[17:16],dp2lut_Yinfo_2[17:16]}) 
      4'b0000,4'b0110,4'b1001: lut_X_sel[2] = ~both_hybrid_sel; //both hit, or one uflow and the other oflow 
      4'b0001,4'b0010: lut_X_sel[2] = 1'b1; //X hit, Y uflow/oflow 
      4'b0100,4'b1000: lut_X_sel[2] = 1'b0; //X uflow/oflow, Y hit 
      4'b0101: lut_X_sel[2] = ~both_uf_sel ; //both uflow 
      4'b1010: lut_X_sel[2] = ~both_of_sel ; //both oflow 
      default: lut_X_sel[2] = 1'd0; 
      endcase 
 end
 always @(
   dp2lut_Xinfo_3
   or dp2lut_Yinfo_3
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      case({dp2lut_Xinfo_3[17:16],dp2lut_Yinfo_3[17:16]}) 
      4'b0000,4'b0110,4'b1001: lut_X_sel[3] = ~both_hybrid_sel; //both hit, or one uflow and the other oflow 
      4'b0001,4'b0010: lut_X_sel[3] = 1'b1; //X hit, Y uflow/oflow 
      4'b0100,4'b1000: lut_X_sel[3] = 1'b0; //X uflow/oflow, Y hit 
      4'b0101: lut_X_sel[3] = ~both_uf_sel ; //both uflow 
      4'b1010: lut_X_sel[3] = ~both_of_sel ; //both oflow 
      default: lut_X_sel[3] = 1'd0; 
      endcase 
 end

 always @(
   int8_en
   or dp2lut_Xinfo_4
   or dp2lut_Yinfo_4
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      if(int8_en) begin 
          case({dp2lut_Xinfo_4[17:16],dp2lut_Yinfo_4[17:16]}) 
          4'b0000,4'b0110,4'b1001: lut_X_sel[4] = ~both_hybrid_sel; //both hit, or one uflow and the other oflow 
          4'b0001,4'b0010: lut_X_sel[4] = 1'b1; //X hit, Y uflow/oflow 
          4'b0100,4'b1000: lut_X_sel[4] = 1'b0; //X uflow/oflow, Y hit 
          4'b0101: lut_X_sel[4] = ~both_uf_sel ; //both uflow 
          4'b1010: lut_X_sel[4] = ~both_of_sel ; //both oflow 
          default: lut_X_sel[4] = 1'd0; 
          endcase 
      end else 
          lut_X_sel[4] = 1'd0; 
 end
 always @(
   int8_en
   or dp2lut_Xinfo_5
   or dp2lut_Yinfo_5
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      if(int8_en) begin 
          case({dp2lut_Xinfo_5[17:16],dp2lut_Yinfo_5[17:16]}) 
          4'b0000,4'b0110,4'b1001: lut_X_sel[5] = ~both_hybrid_sel; //both hit, or one uflow and the other oflow 
          4'b0001,4'b0010: lut_X_sel[5] = 1'b1; //X hit, Y uflow/oflow 
          4'b0100,4'b1000: lut_X_sel[5] = 1'b0; //X uflow/oflow, Y hit 
          4'b0101: lut_X_sel[5] = ~both_uf_sel ; //both uflow 
          4'b1010: lut_X_sel[5] = ~both_of_sel ; //both oflow 
          default: lut_X_sel[5] = 1'd0; 
          endcase 
      end else 
          lut_X_sel[5] = 1'd0; 
 end
 always @(
   int8_en
   or dp2lut_Xinfo_6
   or dp2lut_Yinfo_6
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      if(int8_en) begin 
          case({dp2lut_Xinfo_6[17:16],dp2lut_Yinfo_6[17:16]}) 
          4'b0000,4'b0110,4'b1001: lut_X_sel[6] = ~both_hybrid_sel; //both hit, or one uflow and the other oflow 
          4'b0001,4'b0010: lut_X_sel[6] = 1'b1; //X hit, Y uflow/oflow 
          4'b0100,4'b1000: lut_X_sel[6] = 1'b0; //X uflow/oflow, Y hit 
          4'b0101: lut_X_sel[6] = ~both_uf_sel ; //both uflow 
          4'b1010: lut_X_sel[6] = ~both_of_sel ; //both oflow 
          default: lut_X_sel[6] = 1'd0; 
          endcase 
      end else 
          lut_X_sel[6] = 1'd0; 
 end
 always @(
   int8_en
   or dp2lut_Xinfo_7
   or dp2lut_Yinfo_7
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      if(int8_en) begin 
          case({dp2lut_Xinfo_7[17:16],dp2lut_Yinfo_7[17:16]}) 
          4'b0000,4'b0110,4'b1001: lut_X_sel[7] = ~both_hybrid_sel; //both hit, or one uflow and the other oflow 
          4'b0001,4'b0010: lut_X_sel[7] = 1'b1; //X hit, Y uflow/oflow 
          4'b0100,4'b1000: lut_X_sel[7] = 1'b0; //X uflow/oflow, Y hit 
          4'b0101: lut_X_sel[7] = ~both_uf_sel ; //both uflow 
          4'b1010: lut_X_sel[7] = ~both_of_sel ; //both oflow 
          default: lut_X_sel[7] = 1'd0; 
          endcase 
      end else 
          lut_X_sel[7] = 1'd0; 
 end

 always @(
   dp2lut_Xinfo_0
   or dp2lut_Yinfo_0
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      case({dp2lut_Xinfo_0[17:16],dp2lut_Yinfo_0[17:16]}) 
      4'b0000,4'b0110,4'b1001: lut_Y_sel[0] = both_hybrid_sel; //both hit, or one uflow and the other oflow 
      4'b0001,4'b0010: lut_Y_sel[0] = 1'b0; //X hit, Y uflow/oflow 
      4'b0100,4'b1000: lut_Y_sel[0] = 1'b1; //X uflow/oflow, Y hit 
      4'b0101: lut_Y_sel[0] = both_uf_sel ; //both uflow 
      4'b1010: lut_Y_sel[0] = both_of_sel ; //both oflow 
      default: lut_Y_sel[0] = 1'd0; 
      endcase 
 end
 always @(
   dp2lut_Xinfo_1
   or dp2lut_Yinfo_1
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      case({dp2lut_Xinfo_1[17:16],dp2lut_Yinfo_1[17:16]}) 
      4'b0000,4'b0110,4'b1001: lut_Y_sel[1] = both_hybrid_sel; //both hit, or one uflow and the other oflow 
      4'b0001,4'b0010: lut_Y_sel[1] = 1'b0; //X hit, Y uflow/oflow 
      4'b0100,4'b1000: lut_Y_sel[1] = 1'b1; //X uflow/oflow, Y hit 
      4'b0101: lut_Y_sel[1] = both_uf_sel ; //both uflow 
      4'b1010: lut_Y_sel[1] = both_of_sel ; //both oflow 
      default: lut_Y_sel[1] = 1'd0; 
      endcase 
 end
 always @(
   dp2lut_Xinfo_2
   or dp2lut_Yinfo_2
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      case({dp2lut_Xinfo_2[17:16],dp2lut_Yinfo_2[17:16]}) 
      4'b0000,4'b0110,4'b1001: lut_Y_sel[2] = both_hybrid_sel; //both hit, or one uflow and the other oflow 
      4'b0001,4'b0010: lut_Y_sel[2] = 1'b0; //X hit, Y uflow/oflow 
      4'b0100,4'b1000: lut_Y_sel[2] = 1'b1; //X uflow/oflow, Y hit 
      4'b0101: lut_Y_sel[2] = both_uf_sel ; //both uflow 
      4'b1010: lut_Y_sel[2] = both_of_sel ; //both oflow 
      default: lut_Y_sel[2] = 1'd0; 
      endcase 
 end
 always @(
   dp2lut_Xinfo_3
   or dp2lut_Yinfo_3
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      case({dp2lut_Xinfo_3[17:16],dp2lut_Yinfo_3[17:16]}) 
      4'b0000,4'b0110,4'b1001: lut_Y_sel[3] = both_hybrid_sel; //both hit, or one uflow and the other oflow 
      4'b0001,4'b0010: lut_Y_sel[3] = 1'b0; //X hit, Y uflow/oflow 
      4'b0100,4'b1000: lut_Y_sel[3] = 1'b1; //X uflow/oflow, Y hit 
      4'b0101: lut_Y_sel[3] = both_uf_sel ; //both uflow 
      4'b1010: lut_Y_sel[3] = both_of_sel ; //both oflow 
      default: lut_Y_sel[3] = 1'd0; 
      endcase 
 end

 always @(
   int8_en
   or dp2lut_Xinfo_4
   or dp2lut_Yinfo_4
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      if(int8_en) begin 
          case({dp2lut_Xinfo_4[17:16],dp2lut_Yinfo_4[17:16]}) 
          4'b0000,4'b0110,4'b1001: lut_Y_sel[4] = both_hybrid_sel; //both hit, or one uflow and the other oflow 
          4'b0001,4'b0010: lut_Y_sel[4] = 1'b0; //X hit, Y uflow/oflow 
          4'b0100,4'b1000: lut_Y_sel[4] = 1'b1; //X uflow/oflow, Y hit 
          4'b0101: lut_Y_sel[4] = both_uf_sel ; //both uflow 
          4'b1010: lut_Y_sel[4] = both_of_sel ; //both oflow 
          default: lut_Y_sel[4] = 1'd0; 
          endcase 
      end else 
          lut_Y_sel[4] = 1'd0; 
 end
 always @(
   int8_en
   or dp2lut_Xinfo_5
   or dp2lut_Yinfo_5
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      if(int8_en) begin 
          case({dp2lut_Xinfo_5[17:16],dp2lut_Yinfo_5[17:16]}) 
          4'b0000,4'b0110,4'b1001: lut_Y_sel[5] = both_hybrid_sel; //both hit, or one uflow and the other oflow 
          4'b0001,4'b0010: lut_Y_sel[5] = 1'b0; //X hit, Y uflow/oflow 
          4'b0100,4'b1000: lut_Y_sel[5] = 1'b1; //X uflow/oflow, Y hit 
          4'b0101: lut_Y_sel[5] = both_uf_sel ; //both uflow 
          4'b1010: lut_Y_sel[5] = both_of_sel ; //both oflow 
          default: lut_Y_sel[5] = 1'd0; 
          endcase 
      end else 
          lut_Y_sel[5] = 1'd0; 
 end
 always @(
   int8_en
   or dp2lut_Xinfo_6
   or dp2lut_Yinfo_6
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      if(int8_en) begin 
          case({dp2lut_Xinfo_6[17:16],dp2lut_Yinfo_6[17:16]}) 
          4'b0000,4'b0110,4'b1001: lut_Y_sel[6] = both_hybrid_sel; //both hit, or one uflow and the other oflow 
          4'b0001,4'b0010: lut_Y_sel[6] = 1'b0; //X hit, Y uflow/oflow 
          4'b0100,4'b1000: lut_Y_sel[6] = 1'b1; //X uflow/oflow, Y hit 
          4'b0101: lut_Y_sel[6] = both_uf_sel ; //both uflow 
          4'b1010: lut_Y_sel[6] = both_of_sel ; //both oflow 
          default: lut_Y_sel[6] = 1'd0; 
          endcase 
      end else 
          lut_Y_sel[6] = 1'd0; 
 end
 always @(
   int8_en
   or dp2lut_Xinfo_7
   or dp2lut_Yinfo_7
   or both_hybrid_sel
   or both_uf_sel
   or both_of_sel
   ) begin
      if(int8_en) begin 
          case({dp2lut_Xinfo_7[17:16],dp2lut_Yinfo_7[17:16]}) 
          4'b0000,4'b0110,4'b1001: lut_Y_sel[7] = both_hybrid_sel; //both hit, or one uflow and the other oflow 
          4'b0001,4'b0010: lut_Y_sel[7] = 1'b0; //X hit, Y uflow/oflow 
          4'b0100,4'b1000: lut_Y_sel[7] = 1'b1; //X uflow/oflow, Y hit 
          4'b0101: lut_Y_sel[7] = both_uf_sel ; //both uflow 
          4'b1010: lut_Y_sel[7] = both_of_sel ; //both oflow 
          default: lut_Y_sel[7] = 1'd0; 
          endcase 
      end else 
          lut_Y_sel[7] = 1'd0; 
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP LUT select: Lut X and Lut Y both select or both not selected")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, ~int8_en & load_din & (~(&(lut_X_sel[3:0] ^ lut_Y_sel[3:0])))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"CDP LUT select: Lut X and Lut Y both select or both not selected")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, int8_en & load_din & (~(&(lut_X_sel ^ lut_Y_sel)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////////////////////
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_X_data_00[15:0] <= {16{1'b0}};
     lut_X_data_01[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & lut_X_sel[0]) begin 
      if(dp2lut_Xinfo_0[16]) begin 
         lut_X_data_00[15:0] <= raw_reg0; 
         lut_X_data_01[15:0] <= raw_reg0; 
      end else if(dp2lut_Xinfo_0[17]) begin 
         lut_X_data_00[15:0] <= raw_reg64; 
         lut_X_data_01[15:0] <= raw_reg64; 
      end else begin 
        case(dp2lut_X_entry_0[9:0]) 
      0: begin 
           lut_X_data_00[15:0] <= raw_reg0; 
           lut_X_data_01[15:0] <= raw_reg1; 
      end 
      1: begin 
           lut_X_data_00[15:0] <= raw_reg1; 
           lut_X_data_01[15:0] <= raw_reg2; 
      end 
      2: begin 
           lut_X_data_00[15:0] <= raw_reg2; 
           lut_X_data_01[15:0] <= raw_reg3; 
      end 
      3: begin 
           lut_X_data_00[15:0] <= raw_reg3; 
           lut_X_data_01[15:0] <= raw_reg4; 
      end 
      4: begin 
           lut_X_data_00[15:0] <= raw_reg4; 
           lut_X_data_01[15:0] <= raw_reg5; 
      end 
      5: begin 
           lut_X_data_00[15:0] <= raw_reg5; 
           lut_X_data_01[15:0] <= raw_reg6; 
      end 
      6: begin 
           lut_X_data_00[15:0] <= raw_reg6; 
           lut_X_data_01[15:0] <= raw_reg7; 
      end 
      7: begin 
           lut_X_data_00[15:0] <= raw_reg7; 
           lut_X_data_01[15:0] <= raw_reg8; 
      end 
      8: begin 
           lut_X_data_00[15:0] <= raw_reg8; 
           lut_X_data_01[15:0] <= raw_reg9; 
      end 
      9: begin 
           lut_X_data_00[15:0] <= raw_reg9; 
           lut_X_data_01[15:0] <= raw_reg10; 
      end 
      10: begin 
           lut_X_data_00[15:0] <= raw_reg10; 
           lut_X_data_01[15:0] <= raw_reg11; 
      end 
      11: begin 
           lut_X_data_00[15:0] <= raw_reg11; 
           lut_X_data_01[15:0] <= raw_reg12; 
      end 
      12: begin 
           lut_X_data_00[15:0] <= raw_reg12; 
           lut_X_data_01[15:0] <= raw_reg13; 
      end 
      13: begin 
           lut_X_data_00[15:0] <= raw_reg13; 
           lut_X_data_01[15:0] <= raw_reg14; 
      end 
      14: begin 
           lut_X_data_00[15:0] <= raw_reg14; 
           lut_X_data_01[15:0] <= raw_reg15; 
      end 
      15: begin 
           lut_X_data_00[15:0] <= raw_reg15; 
           lut_X_data_01[15:0] <= raw_reg16; 
      end 
      16: begin 
           lut_X_data_00[15:0] <= raw_reg16; 
           lut_X_data_01[15:0] <= raw_reg17; 
      end 
      17: begin 
           lut_X_data_00[15:0] <= raw_reg17; 
           lut_X_data_01[15:0] <= raw_reg18; 
      end 
      18: begin 
           lut_X_data_00[15:0] <= raw_reg18; 
           lut_X_data_01[15:0] <= raw_reg19; 
      end 
      19: begin 
           lut_X_data_00[15:0] <= raw_reg19; 
           lut_X_data_01[15:0] <= raw_reg20; 
      end 
      20: begin 
           lut_X_data_00[15:0] <= raw_reg20; 
           lut_X_data_01[15:0] <= raw_reg21; 
      end 
      21: begin 
           lut_X_data_00[15:0] <= raw_reg21; 
           lut_X_data_01[15:0] <= raw_reg22; 
      end 
      22: begin 
           lut_X_data_00[15:0] <= raw_reg22; 
           lut_X_data_01[15:0] <= raw_reg23; 
      end 
      23: begin 
           lut_X_data_00[15:0] <= raw_reg23; 
           lut_X_data_01[15:0] <= raw_reg24; 
      end 
      24: begin 
           lut_X_data_00[15:0] <= raw_reg24; 
           lut_X_data_01[15:0] <= raw_reg25; 
      end 
      25: begin 
           lut_X_data_00[15:0] <= raw_reg25; 
           lut_X_data_01[15:0] <= raw_reg26; 
      end 
      26: begin 
           lut_X_data_00[15:0] <= raw_reg26; 
           lut_X_data_01[15:0] <= raw_reg27; 
      end 
      27: begin 
           lut_X_data_00[15:0] <= raw_reg27; 
           lut_X_data_01[15:0] <= raw_reg28; 
      end 
      28: begin 
           lut_X_data_00[15:0] <= raw_reg28; 
           lut_X_data_01[15:0] <= raw_reg29; 
      end 
      29: begin 
           lut_X_data_00[15:0] <= raw_reg29; 
           lut_X_data_01[15:0] <= raw_reg30; 
      end 
      30: begin 
           lut_X_data_00[15:0] <= raw_reg30; 
           lut_X_data_01[15:0] <= raw_reg31; 
      end 
      31: begin 
           lut_X_data_00[15:0] <= raw_reg31; 
           lut_X_data_01[15:0] <= raw_reg32; 
      end 
      32: begin 
           lut_X_data_00[15:0] <= raw_reg32; 
           lut_X_data_01[15:0] <= raw_reg33; 
      end 
      33: begin 
           lut_X_data_00[15:0] <= raw_reg33; 
           lut_X_data_01[15:0] <= raw_reg34; 
      end 
      34: begin 
           lut_X_data_00[15:0] <= raw_reg34; 
           lut_X_data_01[15:0] <= raw_reg35; 
      end 
      35: begin 
           lut_X_data_00[15:0] <= raw_reg35; 
           lut_X_data_01[15:0] <= raw_reg36; 
      end 
      36: begin 
           lut_X_data_00[15:0] <= raw_reg36; 
           lut_X_data_01[15:0] <= raw_reg37; 
      end 
      37: begin 
           lut_X_data_00[15:0] <= raw_reg37; 
           lut_X_data_01[15:0] <= raw_reg38; 
      end 
      38: begin 
           lut_X_data_00[15:0] <= raw_reg38; 
           lut_X_data_01[15:0] <= raw_reg39; 
      end 
      39: begin 
           lut_X_data_00[15:0] <= raw_reg39; 
           lut_X_data_01[15:0] <= raw_reg40; 
      end 
      40: begin 
           lut_X_data_00[15:0] <= raw_reg40; 
           lut_X_data_01[15:0] <= raw_reg41; 
      end 
      41: begin 
           lut_X_data_00[15:0] <= raw_reg41; 
           lut_X_data_01[15:0] <= raw_reg42; 
      end 
      42: begin 
           lut_X_data_00[15:0] <= raw_reg42; 
           lut_X_data_01[15:0] <= raw_reg43; 
      end 
      43: begin 
           lut_X_data_00[15:0] <= raw_reg43; 
           lut_X_data_01[15:0] <= raw_reg44; 
      end 
      44: begin 
           lut_X_data_00[15:0] <= raw_reg44; 
           lut_X_data_01[15:0] <= raw_reg45; 
      end 
      45: begin 
           lut_X_data_00[15:0] <= raw_reg45; 
           lut_X_data_01[15:0] <= raw_reg46; 
      end 
      46: begin 
           lut_X_data_00[15:0] <= raw_reg46; 
           lut_X_data_01[15:0] <= raw_reg47; 
      end 
      47: begin 
           lut_X_data_00[15:0] <= raw_reg47; 
           lut_X_data_01[15:0] <= raw_reg48; 
      end 
      48: begin 
           lut_X_data_00[15:0] <= raw_reg48; 
           lut_X_data_01[15:0] <= raw_reg49; 
      end 
      49: begin 
           lut_X_data_00[15:0] <= raw_reg49; 
           lut_X_data_01[15:0] <= raw_reg50; 
      end 
      50: begin 
           lut_X_data_00[15:0] <= raw_reg50; 
           lut_X_data_01[15:0] <= raw_reg51; 
      end 
      51: begin 
           lut_X_data_00[15:0] <= raw_reg51; 
           lut_X_data_01[15:0] <= raw_reg52; 
      end 
      52: begin 
           lut_X_data_00[15:0] <= raw_reg52; 
           lut_X_data_01[15:0] <= raw_reg53; 
      end 
      53: begin 
           lut_X_data_00[15:0] <= raw_reg53; 
           lut_X_data_01[15:0] <= raw_reg54; 
      end 
      54: begin 
           lut_X_data_00[15:0] <= raw_reg54; 
           lut_X_data_01[15:0] <= raw_reg55; 
      end 
      55: begin 
           lut_X_data_00[15:0] <= raw_reg55; 
           lut_X_data_01[15:0] <= raw_reg56; 
      end 
      56: begin 
           lut_X_data_00[15:0] <= raw_reg56; 
           lut_X_data_01[15:0] <= raw_reg57; 
      end 
      57: begin 
           lut_X_data_00[15:0] <= raw_reg57; 
           lut_X_data_01[15:0] <= raw_reg58; 
      end 
      58: begin 
           lut_X_data_00[15:0] <= raw_reg58; 
           lut_X_data_01[15:0] <= raw_reg59; 
      end 
      59: begin 
           lut_X_data_00[15:0] <= raw_reg59; 
           lut_X_data_01[15:0] <= raw_reg60; 
      end 
      60: begin 
           lut_X_data_00[15:0] <= raw_reg60; 
           lut_X_data_01[15:0] <= raw_reg61; 
      end 
      61: begin 
           lut_X_data_00[15:0] <= raw_reg61; 
           lut_X_data_01[15:0] <= raw_reg62; 
      end 
      62: begin 
           lut_X_data_00[15:0] <= raw_reg62; 
           lut_X_data_01[15:0] <= raw_reg63; 
      end 
      63: begin 
           lut_X_data_00[15:0] <= raw_reg63; 
           lut_X_data_01[15:0] <= raw_reg64; 
      end 
      64: begin 
           lut_X_data_00[15:0] <= raw_reg64; 
           lut_X_data_01[15:0] <= raw_reg64; 
      end 
      default: begin 
        lut_X_data_00[15:0] <= raw_reg0; 
        lut_X_data_01[15:0] <= raw_reg0; 
      end 
      endcase 
      end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_X_data_10[15:0] <= {16{1'b0}};
     lut_X_data_11[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & lut_X_sel[1]) begin 
      if(dp2lut_Xinfo_1[16]) begin 
         lut_X_data_10[15:0] <= raw_reg0; 
         lut_X_data_11[15:0] <= raw_reg0; 
      end else if(dp2lut_Xinfo_1[17]) begin 
         lut_X_data_10[15:0] <= raw_reg64; 
         lut_X_data_11[15:0] <= raw_reg64; 
      end else begin 
        case(dp2lut_X_entry_1[9:0]) 
      0: begin 
           lut_X_data_10[15:0] <= raw_reg0; 
           lut_X_data_11[15:0] <= raw_reg1; 
      end 
      1: begin 
           lut_X_data_10[15:0] <= raw_reg1; 
           lut_X_data_11[15:0] <= raw_reg2; 
      end 
      2: begin 
           lut_X_data_10[15:0] <= raw_reg2; 
           lut_X_data_11[15:0] <= raw_reg3; 
      end 
      3: begin 
           lut_X_data_10[15:0] <= raw_reg3; 
           lut_X_data_11[15:0] <= raw_reg4; 
      end 
      4: begin 
           lut_X_data_10[15:0] <= raw_reg4; 
           lut_X_data_11[15:0] <= raw_reg5; 
      end 
      5: begin 
           lut_X_data_10[15:0] <= raw_reg5; 
           lut_X_data_11[15:0] <= raw_reg6; 
      end 
      6: begin 
           lut_X_data_10[15:0] <= raw_reg6; 
           lut_X_data_11[15:0] <= raw_reg7; 
      end 
      7: begin 
           lut_X_data_10[15:0] <= raw_reg7; 
           lut_X_data_11[15:0] <= raw_reg8; 
      end 
      8: begin 
           lut_X_data_10[15:0] <= raw_reg8; 
           lut_X_data_11[15:0] <= raw_reg9; 
      end 
      9: begin 
           lut_X_data_10[15:0] <= raw_reg9; 
           lut_X_data_11[15:0] <= raw_reg10; 
      end 
      10: begin 
           lut_X_data_10[15:0] <= raw_reg10; 
           lut_X_data_11[15:0] <= raw_reg11; 
      end 
      11: begin 
           lut_X_data_10[15:0] <= raw_reg11; 
           lut_X_data_11[15:0] <= raw_reg12; 
      end 
      12: begin 
           lut_X_data_10[15:0] <= raw_reg12; 
           lut_X_data_11[15:0] <= raw_reg13; 
      end 
      13: begin 
           lut_X_data_10[15:0] <= raw_reg13; 
           lut_X_data_11[15:0] <= raw_reg14; 
      end 
      14: begin 
           lut_X_data_10[15:0] <= raw_reg14; 
           lut_X_data_11[15:0] <= raw_reg15; 
      end 
      15: begin 
           lut_X_data_10[15:0] <= raw_reg15; 
           lut_X_data_11[15:0] <= raw_reg16; 
      end 
      16: begin 
           lut_X_data_10[15:0] <= raw_reg16; 
           lut_X_data_11[15:0] <= raw_reg17; 
      end 
      17: begin 
           lut_X_data_10[15:0] <= raw_reg17; 
           lut_X_data_11[15:0] <= raw_reg18; 
      end 
      18: begin 
           lut_X_data_10[15:0] <= raw_reg18; 
           lut_X_data_11[15:0] <= raw_reg19; 
      end 
      19: begin 
           lut_X_data_10[15:0] <= raw_reg19; 
           lut_X_data_11[15:0] <= raw_reg20; 
      end 
      20: begin 
           lut_X_data_10[15:0] <= raw_reg20; 
           lut_X_data_11[15:0] <= raw_reg21; 
      end 
      21: begin 
           lut_X_data_10[15:0] <= raw_reg21; 
           lut_X_data_11[15:0] <= raw_reg22; 
      end 
      22: begin 
           lut_X_data_10[15:0] <= raw_reg22; 
           lut_X_data_11[15:0] <= raw_reg23; 
      end 
      23: begin 
           lut_X_data_10[15:0] <= raw_reg23; 
           lut_X_data_11[15:0] <= raw_reg24; 
      end 
      24: begin 
           lut_X_data_10[15:0] <= raw_reg24; 
           lut_X_data_11[15:0] <= raw_reg25; 
      end 
      25: begin 
           lut_X_data_10[15:0] <= raw_reg25; 
           lut_X_data_11[15:0] <= raw_reg26; 
      end 
      26: begin 
           lut_X_data_10[15:0] <= raw_reg26; 
           lut_X_data_11[15:0] <= raw_reg27; 
      end 
      27: begin 
           lut_X_data_10[15:0] <= raw_reg27; 
           lut_X_data_11[15:0] <= raw_reg28; 
      end 
      28: begin 
           lut_X_data_10[15:0] <= raw_reg28; 
           lut_X_data_11[15:0] <= raw_reg29; 
      end 
      29: begin 
           lut_X_data_10[15:0] <= raw_reg29; 
           lut_X_data_11[15:0] <= raw_reg30; 
      end 
      30: begin 
           lut_X_data_10[15:0] <= raw_reg30; 
           lut_X_data_11[15:0] <= raw_reg31; 
      end 
      31: begin 
           lut_X_data_10[15:0] <= raw_reg31; 
           lut_X_data_11[15:0] <= raw_reg32; 
      end 
      32: begin 
           lut_X_data_10[15:0] <= raw_reg32; 
           lut_X_data_11[15:0] <= raw_reg33; 
      end 
      33: begin 
           lut_X_data_10[15:0] <= raw_reg33; 
           lut_X_data_11[15:0] <= raw_reg34; 
      end 
      34: begin 
           lut_X_data_10[15:0] <= raw_reg34; 
           lut_X_data_11[15:0] <= raw_reg35; 
      end 
      35: begin 
           lut_X_data_10[15:0] <= raw_reg35; 
           lut_X_data_11[15:0] <= raw_reg36; 
      end 
      36: begin 
           lut_X_data_10[15:0] <= raw_reg36; 
           lut_X_data_11[15:0] <= raw_reg37; 
      end 
      37: begin 
           lut_X_data_10[15:0] <= raw_reg37; 
           lut_X_data_11[15:0] <= raw_reg38; 
      end 
      38: begin 
           lut_X_data_10[15:0] <= raw_reg38; 
           lut_X_data_11[15:0] <= raw_reg39; 
      end 
      39: begin 
           lut_X_data_10[15:0] <= raw_reg39; 
           lut_X_data_11[15:0] <= raw_reg40; 
      end 
      40: begin 
           lut_X_data_10[15:0] <= raw_reg40; 
           lut_X_data_11[15:0] <= raw_reg41; 
      end 
      41: begin 
           lut_X_data_10[15:0] <= raw_reg41; 
           lut_X_data_11[15:0] <= raw_reg42; 
      end 
      42: begin 
           lut_X_data_10[15:0] <= raw_reg42; 
           lut_X_data_11[15:0] <= raw_reg43; 
      end 
      43: begin 
           lut_X_data_10[15:0] <= raw_reg43; 
           lut_X_data_11[15:0] <= raw_reg44; 
      end 
      44: begin 
           lut_X_data_10[15:0] <= raw_reg44; 
           lut_X_data_11[15:0] <= raw_reg45; 
      end 
      45: begin 
           lut_X_data_10[15:0] <= raw_reg45; 
           lut_X_data_11[15:0] <= raw_reg46; 
      end 
      46: begin 
           lut_X_data_10[15:0] <= raw_reg46; 
           lut_X_data_11[15:0] <= raw_reg47; 
      end 
      47: begin 
           lut_X_data_10[15:0] <= raw_reg47; 
           lut_X_data_11[15:0] <= raw_reg48; 
      end 
      48: begin 
           lut_X_data_10[15:0] <= raw_reg48; 
           lut_X_data_11[15:0] <= raw_reg49; 
      end 
      49: begin 
           lut_X_data_10[15:0] <= raw_reg49; 
           lut_X_data_11[15:0] <= raw_reg50; 
      end 
      50: begin 
           lut_X_data_10[15:0] <= raw_reg50; 
           lut_X_data_11[15:0] <= raw_reg51; 
      end 
      51: begin 
           lut_X_data_10[15:0] <= raw_reg51; 
           lut_X_data_11[15:0] <= raw_reg52; 
      end 
      52: begin 
           lut_X_data_10[15:0] <= raw_reg52; 
           lut_X_data_11[15:0] <= raw_reg53; 
      end 
      53: begin 
           lut_X_data_10[15:0] <= raw_reg53; 
           lut_X_data_11[15:0] <= raw_reg54; 
      end 
      54: begin 
           lut_X_data_10[15:0] <= raw_reg54; 
           lut_X_data_11[15:0] <= raw_reg55; 
      end 
      55: begin 
           lut_X_data_10[15:0] <= raw_reg55; 
           lut_X_data_11[15:0] <= raw_reg56; 
      end 
      56: begin 
           lut_X_data_10[15:0] <= raw_reg56; 
           lut_X_data_11[15:0] <= raw_reg57; 
      end 
      57: begin 
           lut_X_data_10[15:0] <= raw_reg57; 
           lut_X_data_11[15:0] <= raw_reg58; 
      end 
      58: begin 
           lut_X_data_10[15:0] <= raw_reg58; 
           lut_X_data_11[15:0] <= raw_reg59; 
      end 
      59: begin 
           lut_X_data_10[15:0] <= raw_reg59; 
           lut_X_data_11[15:0] <= raw_reg60; 
      end 
      60: begin 
           lut_X_data_10[15:0] <= raw_reg60; 
           lut_X_data_11[15:0] <= raw_reg61; 
      end 
      61: begin 
           lut_X_data_10[15:0] <= raw_reg61; 
           lut_X_data_11[15:0] <= raw_reg62; 
      end 
      62: begin 
           lut_X_data_10[15:0] <= raw_reg62; 
           lut_X_data_11[15:0] <= raw_reg63; 
      end 
      63: begin 
           lut_X_data_10[15:0] <= raw_reg63; 
           lut_X_data_11[15:0] <= raw_reg64; 
      end 
      64: begin 
           lut_X_data_10[15:0] <= raw_reg64; 
           lut_X_data_11[15:0] <= raw_reg64; 
      end 
      default: begin 
        lut_X_data_10[15:0] <= raw_reg0; 
        lut_X_data_11[15:0] <= raw_reg0; 
      end 
      endcase 
      end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_X_data_20[15:0] <= {16{1'b0}};
     lut_X_data_21[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & lut_X_sel[2]) begin 
      if(dp2lut_Xinfo_2[16]) begin 
         lut_X_data_20[15:0] <= raw_reg0; 
         lut_X_data_21[15:0] <= raw_reg0; 
      end else if(dp2lut_Xinfo_2[17]) begin 
         lut_X_data_20[15:0] <= raw_reg64; 
         lut_X_data_21[15:0] <= raw_reg64; 
      end else begin 
        case(dp2lut_X_entry_2[9:0]) 
      0: begin 
           lut_X_data_20[15:0] <= raw_reg0; 
           lut_X_data_21[15:0] <= raw_reg1; 
      end 
      1: begin 
           lut_X_data_20[15:0] <= raw_reg1; 
           lut_X_data_21[15:0] <= raw_reg2; 
      end 
      2: begin 
           lut_X_data_20[15:0] <= raw_reg2; 
           lut_X_data_21[15:0] <= raw_reg3; 
      end 
      3: begin 
           lut_X_data_20[15:0] <= raw_reg3; 
           lut_X_data_21[15:0] <= raw_reg4; 
      end 
      4: begin 
           lut_X_data_20[15:0] <= raw_reg4; 
           lut_X_data_21[15:0] <= raw_reg5; 
      end 
      5: begin 
           lut_X_data_20[15:0] <= raw_reg5; 
           lut_X_data_21[15:0] <= raw_reg6; 
      end 
      6: begin 
           lut_X_data_20[15:0] <= raw_reg6; 
           lut_X_data_21[15:0] <= raw_reg7; 
      end 
      7: begin 
           lut_X_data_20[15:0] <= raw_reg7; 
           lut_X_data_21[15:0] <= raw_reg8; 
      end 
      8: begin 
           lut_X_data_20[15:0] <= raw_reg8; 
           lut_X_data_21[15:0] <= raw_reg9; 
      end 
      9: begin 
           lut_X_data_20[15:0] <= raw_reg9; 
           lut_X_data_21[15:0] <= raw_reg10; 
      end 
      10: begin 
           lut_X_data_20[15:0] <= raw_reg10; 
           lut_X_data_21[15:0] <= raw_reg11; 
      end 
      11: begin 
           lut_X_data_20[15:0] <= raw_reg11; 
           lut_X_data_21[15:0] <= raw_reg12; 
      end 
      12: begin 
           lut_X_data_20[15:0] <= raw_reg12; 
           lut_X_data_21[15:0] <= raw_reg13; 
      end 
      13: begin 
           lut_X_data_20[15:0] <= raw_reg13; 
           lut_X_data_21[15:0] <= raw_reg14; 
      end 
      14: begin 
           lut_X_data_20[15:0] <= raw_reg14; 
           lut_X_data_21[15:0] <= raw_reg15; 
      end 
      15: begin 
           lut_X_data_20[15:0] <= raw_reg15; 
           lut_X_data_21[15:0] <= raw_reg16; 
      end 
      16: begin 
           lut_X_data_20[15:0] <= raw_reg16; 
           lut_X_data_21[15:0] <= raw_reg17; 
      end 
      17: begin 
           lut_X_data_20[15:0] <= raw_reg17; 
           lut_X_data_21[15:0] <= raw_reg18; 
      end 
      18: begin 
           lut_X_data_20[15:0] <= raw_reg18; 
           lut_X_data_21[15:0] <= raw_reg19; 
      end 
      19: begin 
           lut_X_data_20[15:0] <= raw_reg19; 
           lut_X_data_21[15:0] <= raw_reg20; 
      end 
      20: begin 
           lut_X_data_20[15:0] <= raw_reg20; 
           lut_X_data_21[15:0] <= raw_reg21; 
      end 
      21: begin 
           lut_X_data_20[15:0] <= raw_reg21; 
           lut_X_data_21[15:0] <= raw_reg22; 
      end 
      22: begin 
           lut_X_data_20[15:0] <= raw_reg22; 
           lut_X_data_21[15:0] <= raw_reg23; 
      end 
      23: begin 
           lut_X_data_20[15:0] <= raw_reg23; 
           lut_X_data_21[15:0] <= raw_reg24; 
      end 
      24: begin 
           lut_X_data_20[15:0] <= raw_reg24; 
           lut_X_data_21[15:0] <= raw_reg25; 
      end 
      25: begin 
           lut_X_data_20[15:0] <= raw_reg25; 
           lut_X_data_21[15:0] <= raw_reg26; 
      end 
      26: begin 
           lut_X_data_20[15:0] <= raw_reg26; 
           lut_X_data_21[15:0] <= raw_reg27; 
      end 
      27: begin 
           lut_X_data_20[15:0] <= raw_reg27; 
           lut_X_data_21[15:0] <= raw_reg28; 
      end 
      28: begin 
           lut_X_data_20[15:0] <= raw_reg28; 
           lut_X_data_21[15:0] <= raw_reg29; 
      end 
      29: begin 
           lut_X_data_20[15:0] <= raw_reg29; 
           lut_X_data_21[15:0] <= raw_reg30; 
      end 
      30: begin 
           lut_X_data_20[15:0] <= raw_reg30; 
           lut_X_data_21[15:0] <= raw_reg31; 
      end 
      31: begin 
           lut_X_data_20[15:0] <= raw_reg31; 
           lut_X_data_21[15:0] <= raw_reg32; 
      end 
      32: begin 
           lut_X_data_20[15:0] <= raw_reg32; 
           lut_X_data_21[15:0] <= raw_reg33; 
      end 
      33: begin 
           lut_X_data_20[15:0] <= raw_reg33; 
           lut_X_data_21[15:0] <= raw_reg34; 
      end 
      34: begin 
           lut_X_data_20[15:0] <= raw_reg34; 
           lut_X_data_21[15:0] <= raw_reg35; 
      end 
      35: begin 
           lut_X_data_20[15:0] <= raw_reg35; 
           lut_X_data_21[15:0] <= raw_reg36; 
      end 
      36: begin 
           lut_X_data_20[15:0] <= raw_reg36; 
           lut_X_data_21[15:0] <= raw_reg37; 
      end 
      37: begin 
           lut_X_data_20[15:0] <= raw_reg37; 
           lut_X_data_21[15:0] <= raw_reg38; 
      end 
      38: begin 
           lut_X_data_20[15:0] <= raw_reg38; 
           lut_X_data_21[15:0] <= raw_reg39; 
      end 
      39: begin 
           lut_X_data_20[15:0] <= raw_reg39; 
           lut_X_data_21[15:0] <= raw_reg40; 
      end 
      40: begin 
           lut_X_data_20[15:0] <= raw_reg40; 
           lut_X_data_21[15:0] <= raw_reg41; 
      end 
      41: begin 
           lut_X_data_20[15:0] <= raw_reg41; 
           lut_X_data_21[15:0] <= raw_reg42; 
      end 
      42: begin 
           lut_X_data_20[15:0] <= raw_reg42; 
           lut_X_data_21[15:0] <= raw_reg43; 
      end 
      43: begin 
           lut_X_data_20[15:0] <= raw_reg43; 
           lut_X_data_21[15:0] <= raw_reg44; 
      end 
      44: begin 
           lut_X_data_20[15:0] <= raw_reg44; 
           lut_X_data_21[15:0] <= raw_reg45; 
      end 
      45: begin 
           lut_X_data_20[15:0] <= raw_reg45; 
           lut_X_data_21[15:0] <= raw_reg46; 
      end 
      46: begin 
           lut_X_data_20[15:0] <= raw_reg46; 
           lut_X_data_21[15:0] <= raw_reg47; 
      end 
      47: begin 
           lut_X_data_20[15:0] <= raw_reg47; 
           lut_X_data_21[15:0] <= raw_reg48; 
      end 
      48: begin 
           lut_X_data_20[15:0] <= raw_reg48; 
           lut_X_data_21[15:0] <= raw_reg49; 
      end 
      49: begin 
           lut_X_data_20[15:0] <= raw_reg49; 
           lut_X_data_21[15:0] <= raw_reg50; 
      end 
      50: begin 
           lut_X_data_20[15:0] <= raw_reg50; 
           lut_X_data_21[15:0] <= raw_reg51; 
      end 
      51: begin 
           lut_X_data_20[15:0] <= raw_reg51; 
           lut_X_data_21[15:0] <= raw_reg52; 
      end 
      52: begin 
           lut_X_data_20[15:0] <= raw_reg52; 
           lut_X_data_21[15:0] <= raw_reg53; 
      end 
      53: begin 
           lut_X_data_20[15:0] <= raw_reg53; 
           lut_X_data_21[15:0] <= raw_reg54; 
      end 
      54: begin 
           lut_X_data_20[15:0] <= raw_reg54; 
           lut_X_data_21[15:0] <= raw_reg55; 
      end 
      55: begin 
           lut_X_data_20[15:0] <= raw_reg55; 
           lut_X_data_21[15:0] <= raw_reg56; 
      end 
      56: begin 
           lut_X_data_20[15:0] <= raw_reg56; 
           lut_X_data_21[15:0] <= raw_reg57; 
      end 
      57: begin 
           lut_X_data_20[15:0] <= raw_reg57; 
           lut_X_data_21[15:0] <= raw_reg58; 
      end 
      58: begin 
           lut_X_data_20[15:0] <= raw_reg58; 
           lut_X_data_21[15:0] <= raw_reg59; 
      end 
      59: begin 
           lut_X_data_20[15:0] <= raw_reg59; 
           lut_X_data_21[15:0] <= raw_reg60; 
      end 
      60: begin 
           lut_X_data_20[15:0] <= raw_reg60; 
           lut_X_data_21[15:0] <= raw_reg61; 
      end 
      61: begin 
           lut_X_data_20[15:0] <= raw_reg61; 
           lut_X_data_21[15:0] <= raw_reg62; 
      end 
      62: begin 
           lut_X_data_20[15:0] <= raw_reg62; 
           lut_X_data_21[15:0] <= raw_reg63; 
      end 
      63: begin 
           lut_X_data_20[15:0] <= raw_reg63; 
           lut_X_data_21[15:0] <= raw_reg64; 
      end 
      64: begin 
           lut_X_data_20[15:0] <= raw_reg64; 
           lut_X_data_21[15:0] <= raw_reg64; 
      end 
      default: begin 
        lut_X_data_20[15:0] <= raw_reg0; 
        lut_X_data_21[15:0] <= raw_reg0; 
      end 
      endcase 
      end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_X_data_30[15:0] <= {16{1'b0}};
     lut_X_data_31[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & lut_X_sel[3]) begin 
      if(dp2lut_Xinfo_3[16]) begin 
         lut_X_data_30[15:0] <= raw_reg0; 
         lut_X_data_31[15:0] <= raw_reg0; 
      end else if(dp2lut_Xinfo_3[17]) begin 
         lut_X_data_30[15:0] <= raw_reg64; 
         lut_X_data_31[15:0] <= raw_reg64; 
      end else begin 
        case(dp2lut_X_entry_3[9:0]) 
      0: begin 
           lut_X_data_30[15:0] <= raw_reg0; 
           lut_X_data_31[15:0] <= raw_reg1; 
      end 
      1: begin 
           lut_X_data_30[15:0] <= raw_reg1; 
           lut_X_data_31[15:0] <= raw_reg2; 
      end 
      2: begin 
           lut_X_data_30[15:0] <= raw_reg2; 
           lut_X_data_31[15:0] <= raw_reg3; 
      end 
      3: begin 
           lut_X_data_30[15:0] <= raw_reg3; 
           lut_X_data_31[15:0] <= raw_reg4; 
      end 
      4: begin 
           lut_X_data_30[15:0] <= raw_reg4; 
           lut_X_data_31[15:0] <= raw_reg5; 
      end 
      5: begin 
           lut_X_data_30[15:0] <= raw_reg5; 
           lut_X_data_31[15:0] <= raw_reg6; 
      end 
      6: begin 
           lut_X_data_30[15:0] <= raw_reg6; 
           lut_X_data_31[15:0] <= raw_reg7; 
      end 
      7: begin 
           lut_X_data_30[15:0] <= raw_reg7; 
           lut_X_data_31[15:0] <= raw_reg8; 
      end 
      8: begin 
           lut_X_data_30[15:0] <= raw_reg8; 
           lut_X_data_31[15:0] <= raw_reg9; 
      end 
      9: begin 
           lut_X_data_30[15:0] <= raw_reg9; 
           lut_X_data_31[15:0] <= raw_reg10; 
      end 
      10: begin 
           lut_X_data_30[15:0] <= raw_reg10; 
           lut_X_data_31[15:0] <= raw_reg11; 
      end 
      11: begin 
           lut_X_data_30[15:0] <= raw_reg11; 
           lut_X_data_31[15:0] <= raw_reg12; 
      end 
      12: begin 
           lut_X_data_30[15:0] <= raw_reg12; 
           lut_X_data_31[15:0] <= raw_reg13; 
      end 
      13: begin 
           lut_X_data_30[15:0] <= raw_reg13; 
           lut_X_data_31[15:0] <= raw_reg14; 
      end 
      14: begin 
           lut_X_data_30[15:0] <= raw_reg14; 
           lut_X_data_31[15:0] <= raw_reg15; 
      end 
      15: begin 
           lut_X_data_30[15:0] <= raw_reg15; 
           lut_X_data_31[15:0] <= raw_reg16; 
      end 
      16: begin 
           lut_X_data_30[15:0] <= raw_reg16; 
           lut_X_data_31[15:0] <= raw_reg17; 
      end 
      17: begin 
           lut_X_data_30[15:0] <= raw_reg17; 
           lut_X_data_31[15:0] <= raw_reg18; 
      end 
      18: begin 
           lut_X_data_30[15:0] <= raw_reg18; 
           lut_X_data_31[15:0] <= raw_reg19; 
      end 
      19: begin 
           lut_X_data_30[15:0] <= raw_reg19; 
           lut_X_data_31[15:0] <= raw_reg20; 
      end 
      20: begin 
           lut_X_data_30[15:0] <= raw_reg20; 
           lut_X_data_31[15:0] <= raw_reg21; 
      end 
      21: begin 
           lut_X_data_30[15:0] <= raw_reg21; 
           lut_X_data_31[15:0] <= raw_reg22; 
      end 
      22: begin 
           lut_X_data_30[15:0] <= raw_reg22; 
           lut_X_data_31[15:0] <= raw_reg23; 
      end 
      23: begin 
           lut_X_data_30[15:0] <= raw_reg23; 
           lut_X_data_31[15:0] <= raw_reg24; 
      end 
      24: begin 
           lut_X_data_30[15:0] <= raw_reg24; 
           lut_X_data_31[15:0] <= raw_reg25; 
      end 
      25: begin 
           lut_X_data_30[15:0] <= raw_reg25; 
           lut_X_data_31[15:0] <= raw_reg26; 
      end 
      26: begin 
           lut_X_data_30[15:0] <= raw_reg26; 
           lut_X_data_31[15:0] <= raw_reg27; 
      end 
      27: begin 
           lut_X_data_30[15:0] <= raw_reg27; 
           lut_X_data_31[15:0] <= raw_reg28; 
      end 
      28: begin 
           lut_X_data_30[15:0] <= raw_reg28; 
           lut_X_data_31[15:0] <= raw_reg29; 
      end 
      29: begin 
           lut_X_data_30[15:0] <= raw_reg29; 
           lut_X_data_31[15:0] <= raw_reg30; 
      end 
      30: begin 
           lut_X_data_30[15:0] <= raw_reg30; 
           lut_X_data_31[15:0] <= raw_reg31; 
      end 
      31: begin 
           lut_X_data_30[15:0] <= raw_reg31; 
           lut_X_data_31[15:0] <= raw_reg32; 
      end 
      32: begin 
           lut_X_data_30[15:0] <= raw_reg32; 
           lut_X_data_31[15:0] <= raw_reg33; 
      end 
      33: begin 
           lut_X_data_30[15:0] <= raw_reg33; 
           lut_X_data_31[15:0] <= raw_reg34; 
      end 
      34: begin 
           lut_X_data_30[15:0] <= raw_reg34; 
           lut_X_data_31[15:0] <= raw_reg35; 
      end 
      35: begin 
           lut_X_data_30[15:0] <= raw_reg35; 
           lut_X_data_31[15:0] <= raw_reg36; 
      end 
      36: begin 
           lut_X_data_30[15:0] <= raw_reg36; 
           lut_X_data_31[15:0] <= raw_reg37; 
      end 
      37: begin 
           lut_X_data_30[15:0] <= raw_reg37; 
           lut_X_data_31[15:0] <= raw_reg38; 
      end 
      38: begin 
           lut_X_data_30[15:0] <= raw_reg38; 
           lut_X_data_31[15:0] <= raw_reg39; 
      end 
      39: begin 
           lut_X_data_30[15:0] <= raw_reg39; 
           lut_X_data_31[15:0] <= raw_reg40; 
      end 
      40: begin 
           lut_X_data_30[15:0] <= raw_reg40; 
           lut_X_data_31[15:0] <= raw_reg41; 
      end 
      41: begin 
           lut_X_data_30[15:0] <= raw_reg41; 
           lut_X_data_31[15:0] <= raw_reg42; 
      end 
      42: begin 
           lut_X_data_30[15:0] <= raw_reg42; 
           lut_X_data_31[15:0] <= raw_reg43; 
      end 
      43: begin 
           lut_X_data_30[15:0] <= raw_reg43; 
           lut_X_data_31[15:0] <= raw_reg44; 
      end 
      44: begin 
           lut_X_data_30[15:0] <= raw_reg44; 
           lut_X_data_31[15:0] <= raw_reg45; 
      end 
      45: begin 
           lut_X_data_30[15:0] <= raw_reg45; 
           lut_X_data_31[15:0] <= raw_reg46; 
      end 
      46: begin 
           lut_X_data_30[15:0] <= raw_reg46; 
           lut_X_data_31[15:0] <= raw_reg47; 
      end 
      47: begin 
           lut_X_data_30[15:0] <= raw_reg47; 
           lut_X_data_31[15:0] <= raw_reg48; 
      end 
      48: begin 
           lut_X_data_30[15:0] <= raw_reg48; 
           lut_X_data_31[15:0] <= raw_reg49; 
      end 
      49: begin 
           lut_X_data_30[15:0] <= raw_reg49; 
           lut_X_data_31[15:0] <= raw_reg50; 
      end 
      50: begin 
           lut_X_data_30[15:0] <= raw_reg50; 
           lut_X_data_31[15:0] <= raw_reg51; 
      end 
      51: begin 
           lut_X_data_30[15:0] <= raw_reg51; 
           lut_X_data_31[15:0] <= raw_reg52; 
      end 
      52: begin 
           lut_X_data_30[15:0] <= raw_reg52; 
           lut_X_data_31[15:0] <= raw_reg53; 
      end 
      53: begin 
           lut_X_data_30[15:0] <= raw_reg53; 
           lut_X_data_31[15:0] <= raw_reg54; 
      end 
      54: begin 
           lut_X_data_30[15:0] <= raw_reg54; 
           lut_X_data_31[15:0] <= raw_reg55; 
      end 
      55: begin 
           lut_X_data_30[15:0] <= raw_reg55; 
           lut_X_data_31[15:0] <= raw_reg56; 
      end 
      56: begin 
           lut_X_data_30[15:0] <= raw_reg56; 
           lut_X_data_31[15:0] <= raw_reg57; 
      end 
      57: begin 
           lut_X_data_30[15:0] <= raw_reg57; 
           lut_X_data_31[15:0] <= raw_reg58; 
      end 
      58: begin 
           lut_X_data_30[15:0] <= raw_reg58; 
           lut_X_data_31[15:0] <= raw_reg59; 
      end 
      59: begin 
           lut_X_data_30[15:0] <= raw_reg59; 
           lut_X_data_31[15:0] <= raw_reg60; 
      end 
      60: begin 
           lut_X_data_30[15:0] <= raw_reg60; 
           lut_X_data_31[15:0] <= raw_reg61; 
      end 
      61: begin 
           lut_X_data_30[15:0] <= raw_reg61; 
           lut_X_data_31[15:0] <= raw_reg62; 
      end 
      62: begin 
           lut_X_data_30[15:0] <= raw_reg62; 
           lut_X_data_31[15:0] <= raw_reg63; 
      end 
      63: begin 
           lut_X_data_30[15:0] <= raw_reg63; 
           lut_X_data_31[15:0] <= raw_reg64; 
      end 
      64: begin 
           lut_X_data_30[15:0] <= raw_reg64; 
           lut_X_data_31[15:0] <= raw_reg64; 
      end 
      default: begin 
        lut_X_data_30[15:0] <= raw_reg0; 
        lut_X_data_31[15:0] <= raw_reg0; 
      end 
      endcase 
      end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_X_data_40[15:0] <= {16{1'b0}};
     lut_X_data_41[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & int8_en & lut_X_sel[4]) begin 
      if(dp2lut_Xinfo_4[16]) begin 
         lut_X_data_40[15:0] <= raw_reg0; 
         lut_X_data_41[15:0] <= raw_reg0; 
      end else if(dp2lut_Xinfo_4[17]) begin 
         lut_X_data_40[15:0] <= raw_reg64; 
         lut_X_data_41[15:0] <= raw_reg64; 
      end else begin 
        case(dp2lut_X_entry_4[9:0]) 
          0: begin 
               lut_X_data_40[15:0] <= raw_reg0; 
               lut_X_data_41[15:0] <= raw_reg1; 
          end 
          1: begin 
               lut_X_data_40[15:0] <= raw_reg1; 
               lut_X_data_41[15:0] <= raw_reg2; 
          end 
          2: begin 
               lut_X_data_40[15:0] <= raw_reg2; 
               lut_X_data_41[15:0] <= raw_reg3; 
          end 
          3: begin 
               lut_X_data_40[15:0] <= raw_reg3; 
               lut_X_data_41[15:0] <= raw_reg4; 
          end 
          4: begin 
               lut_X_data_40[15:0] <= raw_reg4; 
               lut_X_data_41[15:0] <= raw_reg5; 
          end 
          5: begin 
               lut_X_data_40[15:0] <= raw_reg5; 
               lut_X_data_41[15:0] <= raw_reg6; 
          end 
          6: begin 
               lut_X_data_40[15:0] <= raw_reg6; 
               lut_X_data_41[15:0] <= raw_reg7; 
          end 
          7: begin 
               lut_X_data_40[15:0] <= raw_reg7; 
               lut_X_data_41[15:0] <= raw_reg8; 
          end 
          8: begin 
               lut_X_data_40[15:0] <= raw_reg8; 
               lut_X_data_41[15:0] <= raw_reg9; 
          end 
          9: begin 
               lut_X_data_40[15:0] <= raw_reg9; 
               lut_X_data_41[15:0] <= raw_reg10; 
          end 
          10: begin 
               lut_X_data_40[15:0] <= raw_reg10; 
               lut_X_data_41[15:0] <= raw_reg11; 
          end 
          11: begin 
               lut_X_data_40[15:0] <= raw_reg11; 
               lut_X_data_41[15:0] <= raw_reg12; 
          end 
          12: begin 
               lut_X_data_40[15:0] <= raw_reg12; 
               lut_X_data_41[15:0] <= raw_reg13; 
          end 
          13: begin 
               lut_X_data_40[15:0] <= raw_reg13; 
               lut_X_data_41[15:0] <= raw_reg14; 
          end 
          14: begin 
               lut_X_data_40[15:0] <= raw_reg14; 
               lut_X_data_41[15:0] <= raw_reg15; 
          end 
          15: begin 
               lut_X_data_40[15:0] <= raw_reg15; 
               lut_X_data_41[15:0] <= raw_reg16; 
          end 
          16: begin 
               lut_X_data_40[15:0] <= raw_reg16; 
               lut_X_data_41[15:0] <= raw_reg17; 
          end 
          17: begin 
               lut_X_data_40[15:0] <= raw_reg17; 
               lut_X_data_41[15:0] <= raw_reg18; 
          end 
          18: begin 
               lut_X_data_40[15:0] <= raw_reg18; 
               lut_X_data_41[15:0] <= raw_reg19; 
          end 
          19: begin 
               lut_X_data_40[15:0] <= raw_reg19; 
               lut_X_data_41[15:0] <= raw_reg20; 
          end 
          20: begin 
               lut_X_data_40[15:0] <= raw_reg20; 
               lut_X_data_41[15:0] <= raw_reg21; 
          end 
          21: begin 
               lut_X_data_40[15:0] <= raw_reg21; 
               lut_X_data_41[15:0] <= raw_reg22; 
          end 
          22: begin 
               lut_X_data_40[15:0] <= raw_reg22; 
               lut_X_data_41[15:0] <= raw_reg23; 
          end 
          23: begin 
               lut_X_data_40[15:0] <= raw_reg23; 
               lut_X_data_41[15:0] <= raw_reg24; 
          end 
          24: begin 
               lut_X_data_40[15:0] <= raw_reg24; 
               lut_X_data_41[15:0] <= raw_reg25; 
          end 
          25: begin 
               lut_X_data_40[15:0] <= raw_reg25; 
               lut_X_data_41[15:0] <= raw_reg26; 
          end 
          26: begin 
               lut_X_data_40[15:0] <= raw_reg26; 
               lut_X_data_41[15:0] <= raw_reg27; 
          end 
          27: begin 
               lut_X_data_40[15:0] <= raw_reg27; 
               lut_X_data_41[15:0] <= raw_reg28; 
          end 
          28: begin 
               lut_X_data_40[15:0] <= raw_reg28; 
               lut_X_data_41[15:0] <= raw_reg29; 
          end 
          29: begin 
               lut_X_data_40[15:0] <= raw_reg29; 
               lut_X_data_41[15:0] <= raw_reg30; 
          end 
          30: begin 
               lut_X_data_40[15:0] <= raw_reg30; 
               lut_X_data_41[15:0] <= raw_reg31; 
          end 
          31: begin 
               lut_X_data_40[15:0] <= raw_reg31; 
               lut_X_data_41[15:0] <= raw_reg32; 
          end 
          32: begin 
               lut_X_data_40[15:0] <= raw_reg32; 
               lut_X_data_41[15:0] <= raw_reg33; 
          end 
          33: begin 
               lut_X_data_40[15:0] <= raw_reg33; 
               lut_X_data_41[15:0] <= raw_reg34; 
          end 
          34: begin 
               lut_X_data_40[15:0] <= raw_reg34; 
               lut_X_data_41[15:0] <= raw_reg35; 
          end 
          35: begin 
               lut_X_data_40[15:0] <= raw_reg35; 
               lut_X_data_41[15:0] <= raw_reg36; 
          end 
          36: begin 
               lut_X_data_40[15:0] <= raw_reg36; 
               lut_X_data_41[15:0] <= raw_reg37; 
          end 
          37: begin 
               lut_X_data_40[15:0] <= raw_reg37; 
               lut_X_data_41[15:0] <= raw_reg38; 
          end 
          38: begin 
               lut_X_data_40[15:0] <= raw_reg38; 
               lut_X_data_41[15:0] <= raw_reg39; 
          end 
          39: begin 
               lut_X_data_40[15:0] <= raw_reg39; 
               lut_X_data_41[15:0] <= raw_reg40; 
          end 
          40: begin 
               lut_X_data_40[15:0] <= raw_reg40; 
               lut_X_data_41[15:0] <= raw_reg41; 
          end 
          41: begin 
               lut_X_data_40[15:0] <= raw_reg41; 
               lut_X_data_41[15:0] <= raw_reg42; 
          end 
          42: begin 
               lut_X_data_40[15:0] <= raw_reg42; 
               lut_X_data_41[15:0] <= raw_reg43; 
          end 
          43: begin 
               lut_X_data_40[15:0] <= raw_reg43; 
               lut_X_data_41[15:0] <= raw_reg44; 
          end 
          44: begin 
               lut_X_data_40[15:0] <= raw_reg44; 
               lut_X_data_41[15:0] <= raw_reg45; 
          end 
          45: begin 
               lut_X_data_40[15:0] <= raw_reg45; 
               lut_X_data_41[15:0] <= raw_reg46; 
          end 
          46: begin 
               lut_X_data_40[15:0] <= raw_reg46; 
               lut_X_data_41[15:0] <= raw_reg47; 
          end 
          47: begin 
               lut_X_data_40[15:0] <= raw_reg47; 
               lut_X_data_41[15:0] <= raw_reg48; 
          end 
          48: begin 
               lut_X_data_40[15:0] <= raw_reg48; 
               lut_X_data_41[15:0] <= raw_reg49; 
          end 
          49: begin 
               lut_X_data_40[15:0] <= raw_reg49; 
               lut_X_data_41[15:0] <= raw_reg50; 
          end 
          50: begin 
               lut_X_data_40[15:0] <= raw_reg50; 
               lut_X_data_41[15:0] <= raw_reg51; 
          end 
          51: begin 
               lut_X_data_40[15:0] <= raw_reg51; 
               lut_X_data_41[15:0] <= raw_reg52; 
          end 
          52: begin 
               lut_X_data_40[15:0] <= raw_reg52; 
               lut_X_data_41[15:0] <= raw_reg53; 
          end 
          53: begin 
               lut_X_data_40[15:0] <= raw_reg53; 
               lut_X_data_41[15:0] <= raw_reg54; 
          end 
          54: begin 
               lut_X_data_40[15:0] <= raw_reg54; 
               lut_X_data_41[15:0] <= raw_reg55; 
          end 
          55: begin 
               lut_X_data_40[15:0] <= raw_reg55; 
               lut_X_data_41[15:0] <= raw_reg56; 
          end 
          56: begin 
               lut_X_data_40[15:0] <= raw_reg56; 
               lut_X_data_41[15:0] <= raw_reg57; 
          end 
          57: begin 
               lut_X_data_40[15:0] <= raw_reg57; 
               lut_X_data_41[15:0] <= raw_reg58; 
          end 
          58: begin 
               lut_X_data_40[15:0] <= raw_reg58; 
               lut_X_data_41[15:0] <= raw_reg59; 
          end 
          59: begin 
               lut_X_data_40[15:0] <= raw_reg59; 
               lut_X_data_41[15:0] <= raw_reg60; 
          end 
          60: begin 
               lut_X_data_40[15:0] <= raw_reg60; 
               lut_X_data_41[15:0] <= raw_reg61; 
          end 
          61: begin 
               lut_X_data_40[15:0] <= raw_reg61; 
               lut_X_data_41[15:0] <= raw_reg62; 
          end 
          62: begin 
               lut_X_data_40[15:0] <= raw_reg62; 
               lut_X_data_41[15:0] <= raw_reg63; 
          end 
          63: begin 
               lut_X_data_40[15:0] <= raw_reg63; 
               lut_X_data_41[15:0] <= raw_reg64; 
          end 
          64: begin 
               lut_X_data_40[15:0] <= raw_reg64; 
               lut_X_data_41[15:0] <= raw_reg64; 
          end 
          default: begin 
            lut_X_data_40[15:0] <= raw_reg0; 
            lut_X_data_41[15:0] <= raw_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_X_data_50[15:0] <= {16{1'b0}};
     lut_X_data_51[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & int8_en & lut_X_sel[5]) begin 
      if(dp2lut_Xinfo_5[16]) begin 
         lut_X_data_50[15:0] <= raw_reg0; 
         lut_X_data_51[15:0] <= raw_reg0; 
      end else if(dp2lut_Xinfo_5[17]) begin 
         lut_X_data_50[15:0] <= raw_reg64; 
         lut_X_data_51[15:0] <= raw_reg64; 
      end else begin 
        case(dp2lut_X_entry_5[9:0]) 
          0: begin 
               lut_X_data_50[15:0] <= raw_reg0; 
               lut_X_data_51[15:0] <= raw_reg1; 
          end 
          1: begin 
               lut_X_data_50[15:0] <= raw_reg1; 
               lut_X_data_51[15:0] <= raw_reg2; 
          end 
          2: begin 
               lut_X_data_50[15:0] <= raw_reg2; 
               lut_X_data_51[15:0] <= raw_reg3; 
          end 
          3: begin 
               lut_X_data_50[15:0] <= raw_reg3; 
               lut_X_data_51[15:0] <= raw_reg4; 
          end 
          4: begin 
               lut_X_data_50[15:0] <= raw_reg4; 
               lut_X_data_51[15:0] <= raw_reg5; 
          end 
          5: begin 
               lut_X_data_50[15:0] <= raw_reg5; 
               lut_X_data_51[15:0] <= raw_reg6; 
          end 
          6: begin 
               lut_X_data_50[15:0] <= raw_reg6; 
               lut_X_data_51[15:0] <= raw_reg7; 
          end 
          7: begin 
               lut_X_data_50[15:0] <= raw_reg7; 
               lut_X_data_51[15:0] <= raw_reg8; 
          end 
          8: begin 
               lut_X_data_50[15:0] <= raw_reg8; 
               lut_X_data_51[15:0] <= raw_reg9; 
          end 
          9: begin 
               lut_X_data_50[15:0] <= raw_reg9; 
               lut_X_data_51[15:0] <= raw_reg10; 
          end 
          10: begin 
               lut_X_data_50[15:0] <= raw_reg10; 
               lut_X_data_51[15:0] <= raw_reg11; 
          end 
          11: begin 
               lut_X_data_50[15:0] <= raw_reg11; 
               lut_X_data_51[15:0] <= raw_reg12; 
          end 
          12: begin 
               lut_X_data_50[15:0] <= raw_reg12; 
               lut_X_data_51[15:0] <= raw_reg13; 
          end 
          13: begin 
               lut_X_data_50[15:0] <= raw_reg13; 
               lut_X_data_51[15:0] <= raw_reg14; 
          end 
          14: begin 
               lut_X_data_50[15:0] <= raw_reg14; 
               lut_X_data_51[15:0] <= raw_reg15; 
          end 
          15: begin 
               lut_X_data_50[15:0] <= raw_reg15; 
               lut_X_data_51[15:0] <= raw_reg16; 
          end 
          16: begin 
               lut_X_data_50[15:0] <= raw_reg16; 
               lut_X_data_51[15:0] <= raw_reg17; 
          end 
          17: begin 
               lut_X_data_50[15:0] <= raw_reg17; 
               lut_X_data_51[15:0] <= raw_reg18; 
          end 
          18: begin 
               lut_X_data_50[15:0] <= raw_reg18; 
               lut_X_data_51[15:0] <= raw_reg19; 
          end 
          19: begin 
               lut_X_data_50[15:0] <= raw_reg19; 
               lut_X_data_51[15:0] <= raw_reg20; 
          end 
          20: begin 
               lut_X_data_50[15:0] <= raw_reg20; 
               lut_X_data_51[15:0] <= raw_reg21; 
          end 
          21: begin 
               lut_X_data_50[15:0] <= raw_reg21; 
               lut_X_data_51[15:0] <= raw_reg22; 
          end 
          22: begin 
               lut_X_data_50[15:0] <= raw_reg22; 
               lut_X_data_51[15:0] <= raw_reg23; 
          end 
          23: begin 
               lut_X_data_50[15:0] <= raw_reg23; 
               lut_X_data_51[15:0] <= raw_reg24; 
          end 
          24: begin 
               lut_X_data_50[15:0] <= raw_reg24; 
               lut_X_data_51[15:0] <= raw_reg25; 
          end 
          25: begin 
               lut_X_data_50[15:0] <= raw_reg25; 
               lut_X_data_51[15:0] <= raw_reg26; 
          end 
          26: begin 
               lut_X_data_50[15:0] <= raw_reg26; 
               lut_X_data_51[15:0] <= raw_reg27; 
          end 
          27: begin 
               lut_X_data_50[15:0] <= raw_reg27; 
               lut_X_data_51[15:0] <= raw_reg28; 
          end 
          28: begin 
               lut_X_data_50[15:0] <= raw_reg28; 
               lut_X_data_51[15:0] <= raw_reg29; 
          end 
          29: begin 
               lut_X_data_50[15:0] <= raw_reg29; 
               lut_X_data_51[15:0] <= raw_reg30; 
          end 
          30: begin 
               lut_X_data_50[15:0] <= raw_reg30; 
               lut_X_data_51[15:0] <= raw_reg31; 
          end 
          31: begin 
               lut_X_data_50[15:0] <= raw_reg31; 
               lut_X_data_51[15:0] <= raw_reg32; 
          end 
          32: begin 
               lut_X_data_50[15:0] <= raw_reg32; 
               lut_X_data_51[15:0] <= raw_reg33; 
          end 
          33: begin 
               lut_X_data_50[15:0] <= raw_reg33; 
               lut_X_data_51[15:0] <= raw_reg34; 
          end 
          34: begin 
               lut_X_data_50[15:0] <= raw_reg34; 
               lut_X_data_51[15:0] <= raw_reg35; 
          end 
          35: begin 
               lut_X_data_50[15:0] <= raw_reg35; 
               lut_X_data_51[15:0] <= raw_reg36; 
          end 
          36: begin 
               lut_X_data_50[15:0] <= raw_reg36; 
               lut_X_data_51[15:0] <= raw_reg37; 
          end 
          37: begin 
               lut_X_data_50[15:0] <= raw_reg37; 
               lut_X_data_51[15:0] <= raw_reg38; 
          end 
          38: begin 
               lut_X_data_50[15:0] <= raw_reg38; 
               lut_X_data_51[15:0] <= raw_reg39; 
          end 
          39: begin 
               lut_X_data_50[15:0] <= raw_reg39; 
               lut_X_data_51[15:0] <= raw_reg40; 
          end 
          40: begin 
               lut_X_data_50[15:0] <= raw_reg40; 
               lut_X_data_51[15:0] <= raw_reg41; 
          end 
          41: begin 
               lut_X_data_50[15:0] <= raw_reg41; 
               lut_X_data_51[15:0] <= raw_reg42; 
          end 
          42: begin 
               lut_X_data_50[15:0] <= raw_reg42; 
               lut_X_data_51[15:0] <= raw_reg43; 
          end 
          43: begin 
               lut_X_data_50[15:0] <= raw_reg43; 
               lut_X_data_51[15:0] <= raw_reg44; 
          end 
          44: begin 
               lut_X_data_50[15:0] <= raw_reg44; 
               lut_X_data_51[15:0] <= raw_reg45; 
          end 
          45: begin 
               lut_X_data_50[15:0] <= raw_reg45; 
               lut_X_data_51[15:0] <= raw_reg46; 
          end 
          46: begin 
               lut_X_data_50[15:0] <= raw_reg46; 
               lut_X_data_51[15:0] <= raw_reg47; 
          end 
          47: begin 
               lut_X_data_50[15:0] <= raw_reg47; 
               lut_X_data_51[15:0] <= raw_reg48; 
          end 
          48: begin 
               lut_X_data_50[15:0] <= raw_reg48; 
               lut_X_data_51[15:0] <= raw_reg49; 
          end 
          49: begin 
               lut_X_data_50[15:0] <= raw_reg49; 
               lut_X_data_51[15:0] <= raw_reg50; 
          end 
          50: begin 
               lut_X_data_50[15:0] <= raw_reg50; 
               lut_X_data_51[15:0] <= raw_reg51; 
          end 
          51: begin 
               lut_X_data_50[15:0] <= raw_reg51; 
               lut_X_data_51[15:0] <= raw_reg52; 
          end 
          52: begin 
               lut_X_data_50[15:0] <= raw_reg52; 
               lut_X_data_51[15:0] <= raw_reg53; 
          end 
          53: begin 
               lut_X_data_50[15:0] <= raw_reg53; 
               lut_X_data_51[15:0] <= raw_reg54; 
          end 
          54: begin 
               lut_X_data_50[15:0] <= raw_reg54; 
               lut_X_data_51[15:0] <= raw_reg55; 
          end 
          55: begin 
               lut_X_data_50[15:0] <= raw_reg55; 
               lut_X_data_51[15:0] <= raw_reg56; 
          end 
          56: begin 
               lut_X_data_50[15:0] <= raw_reg56; 
               lut_X_data_51[15:0] <= raw_reg57; 
          end 
          57: begin 
               lut_X_data_50[15:0] <= raw_reg57; 
               lut_X_data_51[15:0] <= raw_reg58; 
          end 
          58: begin 
               lut_X_data_50[15:0] <= raw_reg58; 
               lut_X_data_51[15:0] <= raw_reg59; 
          end 
          59: begin 
               lut_X_data_50[15:0] <= raw_reg59; 
               lut_X_data_51[15:0] <= raw_reg60; 
          end 
          60: begin 
               lut_X_data_50[15:0] <= raw_reg60; 
               lut_X_data_51[15:0] <= raw_reg61; 
          end 
          61: begin 
               lut_X_data_50[15:0] <= raw_reg61; 
               lut_X_data_51[15:0] <= raw_reg62; 
          end 
          62: begin 
               lut_X_data_50[15:0] <= raw_reg62; 
               lut_X_data_51[15:0] <= raw_reg63; 
          end 
          63: begin 
               lut_X_data_50[15:0] <= raw_reg63; 
               lut_X_data_51[15:0] <= raw_reg64; 
          end 
          64: begin 
               lut_X_data_50[15:0] <= raw_reg64; 
               lut_X_data_51[15:0] <= raw_reg64; 
          end 
          default: begin 
            lut_X_data_50[15:0] <= raw_reg0; 
            lut_X_data_51[15:0] <= raw_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_X_data_60[15:0] <= {16{1'b0}};
     lut_X_data_61[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & int8_en & lut_X_sel[6]) begin 
      if(dp2lut_Xinfo_6[16]) begin 
         lut_X_data_60[15:0] <= raw_reg0; 
         lut_X_data_61[15:0] <= raw_reg0; 
      end else if(dp2lut_Xinfo_6[17]) begin 
         lut_X_data_60[15:0] <= raw_reg64; 
         lut_X_data_61[15:0] <= raw_reg64; 
      end else begin 
        case(dp2lut_X_entry_6[9:0]) 
          0: begin 
               lut_X_data_60[15:0] <= raw_reg0; 
               lut_X_data_61[15:0] <= raw_reg1; 
          end 
          1: begin 
               lut_X_data_60[15:0] <= raw_reg1; 
               lut_X_data_61[15:0] <= raw_reg2; 
          end 
          2: begin 
               lut_X_data_60[15:0] <= raw_reg2; 
               lut_X_data_61[15:0] <= raw_reg3; 
          end 
          3: begin 
               lut_X_data_60[15:0] <= raw_reg3; 
               lut_X_data_61[15:0] <= raw_reg4; 
          end 
          4: begin 
               lut_X_data_60[15:0] <= raw_reg4; 
               lut_X_data_61[15:0] <= raw_reg5; 
          end 
          5: begin 
               lut_X_data_60[15:0] <= raw_reg5; 
               lut_X_data_61[15:0] <= raw_reg6; 
          end 
          6: begin 
               lut_X_data_60[15:0] <= raw_reg6; 
               lut_X_data_61[15:0] <= raw_reg7; 
          end 
          7: begin 
               lut_X_data_60[15:0] <= raw_reg7; 
               lut_X_data_61[15:0] <= raw_reg8; 
          end 
          8: begin 
               lut_X_data_60[15:0] <= raw_reg8; 
               lut_X_data_61[15:0] <= raw_reg9; 
          end 
          9: begin 
               lut_X_data_60[15:0] <= raw_reg9; 
               lut_X_data_61[15:0] <= raw_reg10; 
          end 
          10: begin 
               lut_X_data_60[15:0] <= raw_reg10; 
               lut_X_data_61[15:0] <= raw_reg11; 
          end 
          11: begin 
               lut_X_data_60[15:0] <= raw_reg11; 
               lut_X_data_61[15:0] <= raw_reg12; 
          end 
          12: begin 
               lut_X_data_60[15:0] <= raw_reg12; 
               lut_X_data_61[15:0] <= raw_reg13; 
          end 
          13: begin 
               lut_X_data_60[15:0] <= raw_reg13; 
               lut_X_data_61[15:0] <= raw_reg14; 
          end 
          14: begin 
               lut_X_data_60[15:0] <= raw_reg14; 
               lut_X_data_61[15:0] <= raw_reg15; 
          end 
          15: begin 
               lut_X_data_60[15:0] <= raw_reg15; 
               lut_X_data_61[15:0] <= raw_reg16; 
          end 
          16: begin 
               lut_X_data_60[15:0] <= raw_reg16; 
               lut_X_data_61[15:0] <= raw_reg17; 
          end 
          17: begin 
               lut_X_data_60[15:0] <= raw_reg17; 
               lut_X_data_61[15:0] <= raw_reg18; 
          end 
          18: begin 
               lut_X_data_60[15:0] <= raw_reg18; 
               lut_X_data_61[15:0] <= raw_reg19; 
          end 
          19: begin 
               lut_X_data_60[15:0] <= raw_reg19; 
               lut_X_data_61[15:0] <= raw_reg20; 
          end 
          20: begin 
               lut_X_data_60[15:0] <= raw_reg20; 
               lut_X_data_61[15:0] <= raw_reg21; 
          end 
          21: begin 
               lut_X_data_60[15:0] <= raw_reg21; 
               lut_X_data_61[15:0] <= raw_reg22; 
          end 
          22: begin 
               lut_X_data_60[15:0] <= raw_reg22; 
               lut_X_data_61[15:0] <= raw_reg23; 
          end 
          23: begin 
               lut_X_data_60[15:0] <= raw_reg23; 
               lut_X_data_61[15:0] <= raw_reg24; 
          end 
          24: begin 
               lut_X_data_60[15:0] <= raw_reg24; 
               lut_X_data_61[15:0] <= raw_reg25; 
          end 
          25: begin 
               lut_X_data_60[15:0] <= raw_reg25; 
               lut_X_data_61[15:0] <= raw_reg26; 
          end 
          26: begin 
               lut_X_data_60[15:0] <= raw_reg26; 
               lut_X_data_61[15:0] <= raw_reg27; 
          end 
          27: begin 
               lut_X_data_60[15:0] <= raw_reg27; 
               lut_X_data_61[15:0] <= raw_reg28; 
          end 
          28: begin 
               lut_X_data_60[15:0] <= raw_reg28; 
               lut_X_data_61[15:0] <= raw_reg29; 
          end 
          29: begin 
               lut_X_data_60[15:0] <= raw_reg29; 
               lut_X_data_61[15:0] <= raw_reg30; 
          end 
          30: begin 
               lut_X_data_60[15:0] <= raw_reg30; 
               lut_X_data_61[15:0] <= raw_reg31; 
          end 
          31: begin 
               lut_X_data_60[15:0] <= raw_reg31; 
               lut_X_data_61[15:0] <= raw_reg32; 
          end 
          32: begin 
               lut_X_data_60[15:0] <= raw_reg32; 
               lut_X_data_61[15:0] <= raw_reg33; 
          end 
          33: begin 
               lut_X_data_60[15:0] <= raw_reg33; 
               lut_X_data_61[15:0] <= raw_reg34; 
          end 
          34: begin 
               lut_X_data_60[15:0] <= raw_reg34; 
               lut_X_data_61[15:0] <= raw_reg35; 
          end 
          35: begin 
               lut_X_data_60[15:0] <= raw_reg35; 
               lut_X_data_61[15:0] <= raw_reg36; 
          end 
          36: begin 
               lut_X_data_60[15:0] <= raw_reg36; 
               lut_X_data_61[15:0] <= raw_reg37; 
          end 
          37: begin 
               lut_X_data_60[15:0] <= raw_reg37; 
               lut_X_data_61[15:0] <= raw_reg38; 
          end 
          38: begin 
               lut_X_data_60[15:0] <= raw_reg38; 
               lut_X_data_61[15:0] <= raw_reg39; 
          end 
          39: begin 
               lut_X_data_60[15:0] <= raw_reg39; 
               lut_X_data_61[15:0] <= raw_reg40; 
          end 
          40: begin 
               lut_X_data_60[15:0] <= raw_reg40; 
               lut_X_data_61[15:0] <= raw_reg41; 
          end 
          41: begin 
               lut_X_data_60[15:0] <= raw_reg41; 
               lut_X_data_61[15:0] <= raw_reg42; 
          end 
          42: begin 
               lut_X_data_60[15:0] <= raw_reg42; 
               lut_X_data_61[15:0] <= raw_reg43; 
          end 
          43: begin 
               lut_X_data_60[15:0] <= raw_reg43; 
               lut_X_data_61[15:0] <= raw_reg44; 
          end 
          44: begin 
               lut_X_data_60[15:0] <= raw_reg44; 
               lut_X_data_61[15:0] <= raw_reg45; 
          end 
          45: begin 
               lut_X_data_60[15:0] <= raw_reg45; 
               lut_X_data_61[15:0] <= raw_reg46; 
          end 
          46: begin 
               lut_X_data_60[15:0] <= raw_reg46; 
               lut_X_data_61[15:0] <= raw_reg47; 
          end 
          47: begin 
               lut_X_data_60[15:0] <= raw_reg47; 
               lut_X_data_61[15:0] <= raw_reg48; 
          end 
          48: begin 
               lut_X_data_60[15:0] <= raw_reg48; 
               lut_X_data_61[15:0] <= raw_reg49; 
          end 
          49: begin 
               lut_X_data_60[15:0] <= raw_reg49; 
               lut_X_data_61[15:0] <= raw_reg50; 
          end 
          50: begin 
               lut_X_data_60[15:0] <= raw_reg50; 
               lut_X_data_61[15:0] <= raw_reg51; 
          end 
          51: begin 
               lut_X_data_60[15:0] <= raw_reg51; 
               lut_X_data_61[15:0] <= raw_reg52; 
          end 
          52: begin 
               lut_X_data_60[15:0] <= raw_reg52; 
               lut_X_data_61[15:0] <= raw_reg53; 
          end 
          53: begin 
               lut_X_data_60[15:0] <= raw_reg53; 
               lut_X_data_61[15:0] <= raw_reg54; 
          end 
          54: begin 
               lut_X_data_60[15:0] <= raw_reg54; 
               lut_X_data_61[15:0] <= raw_reg55; 
          end 
          55: begin 
               lut_X_data_60[15:0] <= raw_reg55; 
               lut_X_data_61[15:0] <= raw_reg56; 
          end 
          56: begin 
               lut_X_data_60[15:0] <= raw_reg56; 
               lut_X_data_61[15:0] <= raw_reg57; 
          end 
          57: begin 
               lut_X_data_60[15:0] <= raw_reg57; 
               lut_X_data_61[15:0] <= raw_reg58; 
          end 
          58: begin 
               lut_X_data_60[15:0] <= raw_reg58; 
               lut_X_data_61[15:0] <= raw_reg59; 
          end 
          59: begin 
               lut_X_data_60[15:0] <= raw_reg59; 
               lut_X_data_61[15:0] <= raw_reg60; 
          end 
          60: begin 
               lut_X_data_60[15:0] <= raw_reg60; 
               lut_X_data_61[15:0] <= raw_reg61; 
          end 
          61: begin 
               lut_X_data_60[15:0] <= raw_reg61; 
               lut_X_data_61[15:0] <= raw_reg62; 
          end 
          62: begin 
               lut_X_data_60[15:0] <= raw_reg62; 
               lut_X_data_61[15:0] <= raw_reg63; 
          end 
          63: begin 
               lut_X_data_60[15:0] <= raw_reg63; 
               lut_X_data_61[15:0] <= raw_reg64; 
          end 
          64: begin 
               lut_X_data_60[15:0] <= raw_reg64; 
               lut_X_data_61[15:0] <= raw_reg64; 
          end 
          default: begin 
            lut_X_data_60[15:0] <= raw_reg0; 
            lut_X_data_61[15:0] <= raw_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_X_data_70[15:0] <= {16{1'b0}};
     lut_X_data_71[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & int8_en & lut_X_sel[7]) begin 
      if(dp2lut_Xinfo_7[16]) begin 
         lut_X_data_70[15:0] <= raw_reg0; 
         lut_X_data_71[15:0] <= raw_reg0; 
      end else if(dp2lut_Xinfo_7[17]) begin 
         lut_X_data_70[15:0] <= raw_reg64; 
         lut_X_data_71[15:0] <= raw_reg64; 
      end else begin 
        case(dp2lut_X_entry_7[9:0]) 
          0: begin 
               lut_X_data_70[15:0] <= raw_reg0; 
               lut_X_data_71[15:0] <= raw_reg1; 
          end 
          1: begin 
               lut_X_data_70[15:0] <= raw_reg1; 
               lut_X_data_71[15:0] <= raw_reg2; 
          end 
          2: begin 
               lut_X_data_70[15:0] <= raw_reg2; 
               lut_X_data_71[15:0] <= raw_reg3; 
          end 
          3: begin 
               lut_X_data_70[15:0] <= raw_reg3; 
               lut_X_data_71[15:0] <= raw_reg4; 
          end 
          4: begin 
               lut_X_data_70[15:0] <= raw_reg4; 
               lut_X_data_71[15:0] <= raw_reg5; 
          end 
          5: begin 
               lut_X_data_70[15:0] <= raw_reg5; 
               lut_X_data_71[15:0] <= raw_reg6; 
          end 
          6: begin 
               lut_X_data_70[15:0] <= raw_reg6; 
               lut_X_data_71[15:0] <= raw_reg7; 
          end 
          7: begin 
               lut_X_data_70[15:0] <= raw_reg7; 
               lut_X_data_71[15:0] <= raw_reg8; 
          end 
          8: begin 
               lut_X_data_70[15:0] <= raw_reg8; 
               lut_X_data_71[15:0] <= raw_reg9; 
          end 
          9: begin 
               lut_X_data_70[15:0] <= raw_reg9; 
               lut_X_data_71[15:0] <= raw_reg10; 
          end 
          10: begin 
               lut_X_data_70[15:0] <= raw_reg10; 
               lut_X_data_71[15:0] <= raw_reg11; 
          end 
          11: begin 
               lut_X_data_70[15:0] <= raw_reg11; 
               lut_X_data_71[15:0] <= raw_reg12; 
          end 
          12: begin 
               lut_X_data_70[15:0] <= raw_reg12; 
               lut_X_data_71[15:0] <= raw_reg13; 
          end 
          13: begin 
               lut_X_data_70[15:0] <= raw_reg13; 
               lut_X_data_71[15:0] <= raw_reg14; 
          end 
          14: begin 
               lut_X_data_70[15:0] <= raw_reg14; 
               lut_X_data_71[15:0] <= raw_reg15; 
          end 
          15: begin 
               lut_X_data_70[15:0] <= raw_reg15; 
               lut_X_data_71[15:0] <= raw_reg16; 
          end 
          16: begin 
               lut_X_data_70[15:0] <= raw_reg16; 
               lut_X_data_71[15:0] <= raw_reg17; 
          end 
          17: begin 
               lut_X_data_70[15:0] <= raw_reg17; 
               lut_X_data_71[15:0] <= raw_reg18; 
          end 
          18: begin 
               lut_X_data_70[15:0] <= raw_reg18; 
               lut_X_data_71[15:0] <= raw_reg19; 
          end 
          19: begin 
               lut_X_data_70[15:0] <= raw_reg19; 
               lut_X_data_71[15:0] <= raw_reg20; 
          end 
          20: begin 
               lut_X_data_70[15:0] <= raw_reg20; 
               lut_X_data_71[15:0] <= raw_reg21; 
          end 
          21: begin 
               lut_X_data_70[15:0] <= raw_reg21; 
               lut_X_data_71[15:0] <= raw_reg22; 
          end 
          22: begin 
               lut_X_data_70[15:0] <= raw_reg22; 
               lut_X_data_71[15:0] <= raw_reg23; 
          end 
          23: begin 
               lut_X_data_70[15:0] <= raw_reg23; 
               lut_X_data_71[15:0] <= raw_reg24; 
          end 
          24: begin 
               lut_X_data_70[15:0] <= raw_reg24; 
               lut_X_data_71[15:0] <= raw_reg25; 
          end 
          25: begin 
               lut_X_data_70[15:0] <= raw_reg25; 
               lut_X_data_71[15:0] <= raw_reg26; 
          end 
          26: begin 
               lut_X_data_70[15:0] <= raw_reg26; 
               lut_X_data_71[15:0] <= raw_reg27; 
          end 
          27: begin 
               lut_X_data_70[15:0] <= raw_reg27; 
               lut_X_data_71[15:0] <= raw_reg28; 
          end 
          28: begin 
               lut_X_data_70[15:0] <= raw_reg28; 
               lut_X_data_71[15:0] <= raw_reg29; 
          end 
          29: begin 
               lut_X_data_70[15:0] <= raw_reg29; 
               lut_X_data_71[15:0] <= raw_reg30; 
          end 
          30: begin 
               lut_X_data_70[15:0] <= raw_reg30; 
               lut_X_data_71[15:0] <= raw_reg31; 
          end 
          31: begin 
               lut_X_data_70[15:0] <= raw_reg31; 
               lut_X_data_71[15:0] <= raw_reg32; 
          end 
          32: begin 
               lut_X_data_70[15:0] <= raw_reg32; 
               lut_X_data_71[15:0] <= raw_reg33; 
          end 
          33: begin 
               lut_X_data_70[15:0] <= raw_reg33; 
               lut_X_data_71[15:0] <= raw_reg34; 
          end 
          34: begin 
               lut_X_data_70[15:0] <= raw_reg34; 
               lut_X_data_71[15:0] <= raw_reg35; 
          end 
          35: begin 
               lut_X_data_70[15:0] <= raw_reg35; 
               lut_X_data_71[15:0] <= raw_reg36; 
          end 
          36: begin 
               lut_X_data_70[15:0] <= raw_reg36; 
               lut_X_data_71[15:0] <= raw_reg37; 
          end 
          37: begin 
               lut_X_data_70[15:0] <= raw_reg37; 
               lut_X_data_71[15:0] <= raw_reg38; 
          end 
          38: begin 
               lut_X_data_70[15:0] <= raw_reg38; 
               lut_X_data_71[15:0] <= raw_reg39; 
          end 
          39: begin 
               lut_X_data_70[15:0] <= raw_reg39; 
               lut_X_data_71[15:0] <= raw_reg40; 
          end 
          40: begin 
               lut_X_data_70[15:0] <= raw_reg40; 
               lut_X_data_71[15:0] <= raw_reg41; 
          end 
          41: begin 
               lut_X_data_70[15:0] <= raw_reg41; 
               lut_X_data_71[15:0] <= raw_reg42; 
          end 
          42: begin 
               lut_X_data_70[15:0] <= raw_reg42; 
               lut_X_data_71[15:0] <= raw_reg43; 
          end 
          43: begin 
               lut_X_data_70[15:0] <= raw_reg43; 
               lut_X_data_71[15:0] <= raw_reg44; 
          end 
          44: begin 
               lut_X_data_70[15:0] <= raw_reg44; 
               lut_X_data_71[15:0] <= raw_reg45; 
          end 
          45: begin 
               lut_X_data_70[15:0] <= raw_reg45; 
               lut_X_data_71[15:0] <= raw_reg46; 
          end 
          46: begin 
               lut_X_data_70[15:0] <= raw_reg46; 
               lut_X_data_71[15:0] <= raw_reg47; 
          end 
          47: begin 
               lut_X_data_70[15:0] <= raw_reg47; 
               lut_X_data_71[15:0] <= raw_reg48; 
          end 
          48: begin 
               lut_X_data_70[15:0] <= raw_reg48; 
               lut_X_data_71[15:0] <= raw_reg49; 
          end 
          49: begin 
               lut_X_data_70[15:0] <= raw_reg49; 
               lut_X_data_71[15:0] <= raw_reg50; 
          end 
          50: begin 
               lut_X_data_70[15:0] <= raw_reg50; 
               lut_X_data_71[15:0] <= raw_reg51; 
          end 
          51: begin 
               lut_X_data_70[15:0] <= raw_reg51; 
               lut_X_data_71[15:0] <= raw_reg52; 
          end 
          52: begin 
               lut_X_data_70[15:0] <= raw_reg52; 
               lut_X_data_71[15:0] <= raw_reg53; 
          end 
          53: begin 
               lut_X_data_70[15:0] <= raw_reg53; 
               lut_X_data_71[15:0] <= raw_reg54; 
          end 
          54: begin 
               lut_X_data_70[15:0] <= raw_reg54; 
               lut_X_data_71[15:0] <= raw_reg55; 
          end 
          55: begin 
               lut_X_data_70[15:0] <= raw_reg55; 
               lut_X_data_71[15:0] <= raw_reg56; 
          end 
          56: begin 
               lut_X_data_70[15:0] <= raw_reg56; 
               lut_X_data_71[15:0] <= raw_reg57; 
          end 
          57: begin 
               lut_X_data_70[15:0] <= raw_reg57; 
               lut_X_data_71[15:0] <= raw_reg58; 
          end 
          58: begin 
               lut_X_data_70[15:0] <= raw_reg58; 
               lut_X_data_71[15:0] <= raw_reg59; 
          end 
          59: begin 
               lut_X_data_70[15:0] <= raw_reg59; 
               lut_X_data_71[15:0] <= raw_reg60; 
          end 
          60: begin 
               lut_X_data_70[15:0] <= raw_reg60; 
               lut_X_data_71[15:0] <= raw_reg61; 
          end 
          61: begin 
               lut_X_data_70[15:0] <= raw_reg61; 
               lut_X_data_71[15:0] <= raw_reg62; 
          end 
          62: begin 
               lut_X_data_70[15:0] <= raw_reg62; 
               lut_X_data_71[15:0] <= raw_reg63; 
          end 
          63: begin 
               lut_X_data_70[15:0] <= raw_reg63; 
               lut_X_data_71[15:0] <= raw_reg64; 
          end 
          64: begin 
               lut_X_data_70[15:0] <= raw_reg64; 
               lut_X_data_71[15:0] <= raw_reg64; 
          end 
          default: begin 
            lut_X_data_70[15:0] <= raw_reg0; 
            lut_X_data_71[15:0] <= raw_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
/////////////////
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_Y_data_00[15:0] <= {16{1'b0}};
     lut_Y_data_01[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & lut_Y_sel[0]) begin 
      if(dp2lut_Yinfo_0[16]) begin 
         lut_Y_data_00[15:0] <= density_reg0; 
         lut_Y_data_01[15:0] <= density_reg0; 
      end else if(dp2lut_Yinfo_0[17]) begin 
         lut_Y_data_00[15:0] <= density_reg256; 
         lut_Y_data_01[15:0] <= density_reg256; 
      end else begin 
        case(dp2lut_Y_entry_0[9:0]) 
          0: begin 
               lut_Y_data_00[15:0] <= density_reg0; 
               lut_Y_data_01[15:0] <= density_reg1; 
          end 
          1: begin 
               lut_Y_data_00[15:0] <= density_reg1; 
               lut_Y_data_01[15:0] <= density_reg2; 
          end 
          2: begin 
               lut_Y_data_00[15:0] <= density_reg2; 
               lut_Y_data_01[15:0] <= density_reg3; 
          end 
          3: begin 
               lut_Y_data_00[15:0] <= density_reg3; 
               lut_Y_data_01[15:0] <= density_reg4; 
          end 
          4: begin 
               lut_Y_data_00[15:0] <= density_reg4; 
               lut_Y_data_01[15:0] <= density_reg5; 
          end 
          5: begin 
               lut_Y_data_00[15:0] <= density_reg5; 
               lut_Y_data_01[15:0] <= density_reg6; 
          end 
          6: begin 
               lut_Y_data_00[15:0] <= density_reg6; 
               lut_Y_data_01[15:0] <= density_reg7; 
          end 
          7: begin 
               lut_Y_data_00[15:0] <= density_reg7; 
               lut_Y_data_01[15:0] <= density_reg8; 
          end 
          8: begin 
               lut_Y_data_00[15:0] <= density_reg8; 
               lut_Y_data_01[15:0] <= density_reg9; 
          end 
          9: begin 
               lut_Y_data_00[15:0] <= density_reg9; 
               lut_Y_data_01[15:0] <= density_reg10; 
          end 
          10: begin 
               lut_Y_data_00[15:0] <= density_reg10; 
               lut_Y_data_01[15:0] <= density_reg11; 
          end 
          11: begin 
               lut_Y_data_00[15:0] <= density_reg11; 
               lut_Y_data_01[15:0] <= density_reg12; 
          end 
          12: begin 
               lut_Y_data_00[15:0] <= density_reg12; 
               lut_Y_data_01[15:0] <= density_reg13; 
          end 
          13: begin 
               lut_Y_data_00[15:0] <= density_reg13; 
               lut_Y_data_01[15:0] <= density_reg14; 
          end 
          14: begin 
               lut_Y_data_00[15:0] <= density_reg14; 
               lut_Y_data_01[15:0] <= density_reg15; 
          end 
          15: begin 
               lut_Y_data_00[15:0] <= density_reg15; 
               lut_Y_data_01[15:0] <= density_reg16; 
          end 
          16: begin 
               lut_Y_data_00[15:0] <= density_reg16; 
               lut_Y_data_01[15:0] <= density_reg17; 
          end 
          17: begin 
               lut_Y_data_00[15:0] <= density_reg17; 
               lut_Y_data_01[15:0] <= density_reg18; 
          end 
          18: begin 
               lut_Y_data_00[15:0] <= density_reg18; 
               lut_Y_data_01[15:0] <= density_reg19; 
          end 
          19: begin 
               lut_Y_data_00[15:0] <= density_reg19; 
               lut_Y_data_01[15:0] <= density_reg20; 
          end 
          20: begin 
               lut_Y_data_00[15:0] <= density_reg20; 
               lut_Y_data_01[15:0] <= density_reg21; 
          end 
          21: begin 
               lut_Y_data_00[15:0] <= density_reg21; 
               lut_Y_data_01[15:0] <= density_reg22; 
          end 
          22: begin 
               lut_Y_data_00[15:0] <= density_reg22; 
               lut_Y_data_01[15:0] <= density_reg23; 
          end 
          23: begin 
               lut_Y_data_00[15:0] <= density_reg23; 
               lut_Y_data_01[15:0] <= density_reg24; 
          end 
          24: begin 
               lut_Y_data_00[15:0] <= density_reg24; 
               lut_Y_data_01[15:0] <= density_reg25; 
          end 
          25: begin 
               lut_Y_data_00[15:0] <= density_reg25; 
               lut_Y_data_01[15:0] <= density_reg26; 
          end 
          26: begin 
               lut_Y_data_00[15:0] <= density_reg26; 
               lut_Y_data_01[15:0] <= density_reg27; 
          end 
          27: begin 
               lut_Y_data_00[15:0] <= density_reg27; 
               lut_Y_data_01[15:0] <= density_reg28; 
          end 
          28: begin 
               lut_Y_data_00[15:0] <= density_reg28; 
               lut_Y_data_01[15:0] <= density_reg29; 
          end 
          29: begin 
               lut_Y_data_00[15:0] <= density_reg29; 
               lut_Y_data_01[15:0] <= density_reg30; 
          end 
          30: begin 
               lut_Y_data_00[15:0] <= density_reg30; 
               lut_Y_data_01[15:0] <= density_reg31; 
          end 
          31: begin 
               lut_Y_data_00[15:0] <= density_reg31; 
               lut_Y_data_01[15:0] <= density_reg32; 
          end 
          32: begin 
               lut_Y_data_00[15:0] <= density_reg32; 
               lut_Y_data_01[15:0] <= density_reg33; 
          end 
          33: begin 
               lut_Y_data_00[15:0] <= density_reg33; 
               lut_Y_data_01[15:0] <= density_reg34; 
          end 
          34: begin 
               lut_Y_data_00[15:0] <= density_reg34; 
               lut_Y_data_01[15:0] <= density_reg35; 
          end 
          35: begin 
               lut_Y_data_00[15:0] <= density_reg35; 
               lut_Y_data_01[15:0] <= density_reg36; 
          end 
          36: begin 
               lut_Y_data_00[15:0] <= density_reg36; 
               lut_Y_data_01[15:0] <= density_reg37; 
          end 
          37: begin 
               lut_Y_data_00[15:0] <= density_reg37; 
               lut_Y_data_01[15:0] <= density_reg38; 
          end 
          38: begin 
               lut_Y_data_00[15:0] <= density_reg38; 
               lut_Y_data_01[15:0] <= density_reg39; 
          end 
          39: begin 
               lut_Y_data_00[15:0] <= density_reg39; 
               lut_Y_data_01[15:0] <= density_reg40; 
          end 
          40: begin 
               lut_Y_data_00[15:0] <= density_reg40; 
               lut_Y_data_01[15:0] <= density_reg41; 
          end 
          41: begin 
               lut_Y_data_00[15:0] <= density_reg41; 
               lut_Y_data_01[15:0] <= density_reg42; 
          end 
          42: begin 
               lut_Y_data_00[15:0] <= density_reg42; 
               lut_Y_data_01[15:0] <= density_reg43; 
          end 
          43: begin 
               lut_Y_data_00[15:0] <= density_reg43; 
               lut_Y_data_01[15:0] <= density_reg44; 
          end 
          44: begin 
               lut_Y_data_00[15:0] <= density_reg44; 
               lut_Y_data_01[15:0] <= density_reg45; 
          end 
          45: begin 
               lut_Y_data_00[15:0] <= density_reg45; 
               lut_Y_data_01[15:0] <= density_reg46; 
          end 
          46: begin 
               lut_Y_data_00[15:0] <= density_reg46; 
               lut_Y_data_01[15:0] <= density_reg47; 
          end 
          47: begin 
               lut_Y_data_00[15:0] <= density_reg47; 
               lut_Y_data_01[15:0] <= density_reg48; 
          end 
          48: begin 
               lut_Y_data_00[15:0] <= density_reg48; 
               lut_Y_data_01[15:0] <= density_reg49; 
          end 
          49: begin 
               lut_Y_data_00[15:0] <= density_reg49; 
               lut_Y_data_01[15:0] <= density_reg50; 
          end 
          50: begin 
               lut_Y_data_00[15:0] <= density_reg50; 
               lut_Y_data_01[15:0] <= density_reg51; 
          end 
          51: begin 
               lut_Y_data_00[15:0] <= density_reg51; 
               lut_Y_data_01[15:0] <= density_reg52; 
          end 
          52: begin 
               lut_Y_data_00[15:0] <= density_reg52; 
               lut_Y_data_01[15:0] <= density_reg53; 
          end 
          53: begin 
               lut_Y_data_00[15:0] <= density_reg53; 
               lut_Y_data_01[15:0] <= density_reg54; 
          end 
          54: begin 
               lut_Y_data_00[15:0] <= density_reg54; 
               lut_Y_data_01[15:0] <= density_reg55; 
          end 
          55: begin 
               lut_Y_data_00[15:0] <= density_reg55; 
               lut_Y_data_01[15:0] <= density_reg56; 
          end 
          56: begin 
               lut_Y_data_00[15:0] <= density_reg56; 
               lut_Y_data_01[15:0] <= density_reg57; 
          end 
          57: begin 
               lut_Y_data_00[15:0] <= density_reg57; 
               lut_Y_data_01[15:0] <= density_reg58; 
          end 
          58: begin 
               lut_Y_data_00[15:0] <= density_reg58; 
               lut_Y_data_01[15:0] <= density_reg59; 
          end 
          59: begin 
               lut_Y_data_00[15:0] <= density_reg59; 
               lut_Y_data_01[15:0] <= density_reg60; 
          end 
          60: begin 
               lut_Y_data_00[15:0] <= density_reg60; 
               lut_Y_data_01[15:0] <= density_reg61; 
          end 
          61: begin 
               lut_Y_data_00[15:0] <= density_reg61; 
               lut_Y_data_01[15:0] <= density_reg62; 
          end 
          62: begin 
               lut_Y_data_00[15:0] <= density_reg62; 
               lut_Y_data_01[15:0] <= density_reg63; 
          end 
          63: begin 
               lut_Y_data_00[15:0] <= density_reg63; 
               lut_Y_data_01[15:0] <= density_reg64; 
          end 
          64: begin 
               lut_Y_data_00[15:0] <= density_reg64; 
               lut_Y_data_01[15:0] <= density_reg65; 
          end 
          65: begin 
               lut_Y_data_00[15:0] <= density_reg65; 
               lut_Y_data_01[15:0] <= density_reg66; 
          end 
          66: begin 
               lut_Y_data_00[15:0] <= density_reg66; 
               lut_Y_data_01[15:0] <= density_reg67; 
          end 
          67: begin 
               lut_Y_data_00[15:0] <= density_reg67; 
               lut_Y_data_01[15:0] <= density_reg68; 
          end 
          68: begin 
               lut_Y_data_00[15:0] <= density_reg68; 
               lut_Y_data_01[15:0] <= density_reg69; 
          end 
          69: begin 
               lut_Y_data_00[15:0] <= density_reg69; 
               lut_Y_data_01[15:0] <= density_reg70; 
          end 
          70: begin 
               lut_Y_data_00[15:0] <= density_reg70; 
               lut_Y_data_01[15:0] <= density_reg71; 
          end 
          71: begin 
               lut_Y_data_00[15:0] <= density_reg71; 
               lut_Y_data_01[15:0] <= density_reg72; 
          end 
          72: begin 
               lut_Y_data_00[15:0] <= density_reg72; 
               lut_Y_data_01[15:0] <= density_reg73; 
          end 
          73: begin 
               lut_Y_data_00[15:0] <= density_reg73; 
               lut_Y_data_01[15:0] <= density_reg74; 
          end 
          74: begin 
               lut_Y_data_00[15:0] <= density_reg74; 
               lut_Y_data_01[15:0] <= density_reg75; 
          end 
          75: begin 
               lut_Y_data_00[15:0] <= density_reg75; 
               lut_Y_data_01[15:0] <= density_reg76; 
          end 
          76: begin 
               lut_Y_data_00[15:0] <= density_reg76; 
               lut_Y_data_01[15:0] <= density_reg77; 
          end 
          77: begin 
               lut_Y_data_00[15:0] <= density_reg77; 
               lut_Y_data_01[15:0] <= density_reg78; 
          end 
          78: begin 
               lut_Y_data_00[15:0] <= density_reg78; 
               lut_Y_data_01[15:0] <= density_reg79; 
          end 
          79: begin 
               lut_Y_data_00[15:0] <= density_reg79; 
               lut_Y_data_01[15:0] <= density_reg80; 
          end 
          80: begin 
               lut_Y_data_00[15:0] <= density_reg80; 
               lut_Y_data_01[15:0] <= density_reg81; 
          end 
          81: begin 
               lut_Y_data_00[15:0] <= density_reg81; 
               lut_Y_data_01[15:0] <= density_reg82; 
          end 
          82: begin 
               lut_Y_data_00[15:0] <= density_reg82; 
               lut_Y_data_01[15:0] <= density_reg83; 
          end 
          83: begin 
               lut_Y_data_00[15:0] <= density_reg83; 
               lut_Y_data_01[15:0] <= density_reg84; 
          end 
          84: begin 
               lut_Y_data_00[15:0] <= density_reg84; 
               lut_Y_data_01[15:0] <= density_reg85; 
          end 
          85: begin 
               lut_Y_data_00[15:0] <= density_reg85; 
               lut_Y_data_01[15:0] <= density_reg86; 
          end 
          86: begin 
               lut_Y_data_00[15:0] <= density_reg86; 
               lut_Y_data_01[15:0] <= density_reg87; 
          end 
          87: begin 
               lut_Y_data_00[15:0] <= density_reg87; 
               lut_Y_data_01[15:0] <= density_reg88; 
          end 
          88: begin 
               lut_Y_data_00[15:0] <= density_reg88; 
               lut_Y_data_01[15:0] <= density_reg89; 
          end 
          89: begin 
               lut_Y_data_00[15:0] <= density_reg89; 
               lut_Y_data_01[15:0] <= density_reg90; 
          end 
          90: begin 
               lut_Y_data_00[15:0] <= density_reg90; 
               lut_Y_data_01[15:0] <= density_reg91; 
          end 
          91: begin 
               lut_Y_data_00[15:0] <= density_reg91; 
               lut_Y_data_01[15:0] <= density_reg92; 
          end 
          92: begin 
               lut_Y_data_00[15:0] <= density_reg92; 
               lut_Y_data_01[15:0] <= density_reg93; 
          end 
          93: begin 
               lut_Y_data_00[15:0] <= density_reg93; 
               lut_Y_data_01[15:0] <= density_reg94; 
          end 
          94: begin 
               lut_Y_data_00[15:0] <= density_reg94; 
               lut_Y_data_01[15:0] <= density_reg95; 
          end 
          95: begin 
               lut_Y_data_00[15:0] <= density_reg95; 
               lut_Y_data_01[15:0] <= density_reg96; 
          end 
          96: begin 
               lut_Y_data_00[15:0] <= density_reg96; 
               lut_Y_data_01[15:0] <= density_reg97; 
          end 
          97: begin 
               lut_Y_data_00[15:0] <= density_reg97; 
               lut_Y_data_01[15:0] <= density_reg98; 
          end 
          98: begin 
               lut_Y_data_00[15:0] <= density_reg98; 
               lut_Y_data_01[15:0] <= density_reg99; 
          end 
          99: begin 
               lut_Y_data_00[15:0] <= density_reg99; 
               lut_Y_data_01[15:0] <= density_reg100; 
          end 
          100: begin 
               lut_Y_data_00[15:0] <= density_reg100; 
               lut_Y_data_01[15:0] <= density_reg101; 
          end 
          101: begin 
               lut_Y_data_00[15:0] <= density_reg101; 
               lut_Y_data_01[15:0] <= density_reg102; 
          end 
          102: begin 
               lut_Y_data_00[15:0] <= density_reg102; 
               lut_Y_data_01[15:0] <= density_reg103; 
          end 
          103: begin 
               lut_Y_data_00[15:0] <= density_reg103; 
               lut_Y_data_01[15:0] <= density_reg104; 
          end 
          104: begin 
               lut_Y_data_00[15:0] <= density_reg104; 
               lut_Y_data_01[15:0] <= density_reg105; 
          end 
          105: begin 
               lut_Y_data_00[15:0] <= density_reg105; 
               lut_Y_data_01[15:0] <= density_reg106; 
          end 
          106: begin 
               lut_Y_data_00[15:0] <= density_reg106; 
               lut_Y_data_01[15:0] <= density_reg107; 
          end 
          107: begin 
               lut_Y_data_00[15:0] <= density_reg107; 
               lut_Y_data_01[15:0] <= density_reg108; 
          end 
          108: begin 
               lut_Y_data_00[15:0] <= density_reg108; 
               lut_Y_data_01[15:0] <= density_reg109; 
          end 
          109: begin 
               lut_Y_data_00[15:0] <= density_reg109; 
               lut_Y_data_01[15:0] <= density_reg110; 
          end 
          110: begin 
               lut_Y_data_00[15:0] <= density_reg110; 
               lut_Y_data_01[15:0] <= density_reg111; 
          end 
          111: begin 
               lut_Y_data_00[15:0] <= density_reg111; 
               lut_Y_data_01[15:0] <= density_reg112; 
          end 
          112: begin 
               lut_Y_data_00[15:0] <= density_reg112; 
               lut_Y_data_01[15:0] <= density_reg113; 
          end 
          113: begin 
               lut_Y_data_00[15:0] <= density_reg113; 
               lut_Y_data_01[15:0] <= density_reg114; 
          end 
          114: begin 
               lut_Y_data_00[15:0] <= density_reg114; 
               lut_Y_data_01[15:0] <= density_reg115; 
          end 
          115: begin 
               lut_Y_data_00[15:0] <= density_reg115; 
               lut_Y_data_01[15:0] <= density_reg116; 
          end 
          116: begin 
               lut_Y_data_00[15:0] <= density_reg116; 
               lut_Y_data_01[15:0] <= density_reg117; 
          end 
          117: begin 
               lut_Y_data_00[15:0] <= density_reg117; 
               lut_Y_data_01[15:0] <= density_reg118; 
          end 
          118: begin 
               lut_Y_data_00[15:0] <= density_reg118; 
               lut_Y_data_01[15:0] <= density_reg119; 
          end 
          119: begin 
               lut_Y_data_00[15:0] <= density_reg119; 
               lut_Y_data_01[15:0] <= density_reg120; 
          end 
          120: begin 
               lut_Y_data_00[15:0] <= density_reg120; 
               lut_Y_data_01[15:0] <= density_reg121; 
          end 
          121: begin 
               lut_Y_data_00[15:0] <= density_reg121; 
               lut_Y_data_01[15:0] <= density_reg122; 
          end 
          122: begin 
               lut_Y_data_00[15:0] <= density_reg122; 
               lut_Y_data_01[15:0] <= density_reg123; 
          end 
          123: begin 
               lut_Y_data_00[15:0] <= density_reg123; 
               lut_Y_data_01[15:0] <= density_reg124; 
          end 
          124: begin 
               lut_Y_data_00[15:0] <= density_reg124; 
               lut_Y_data_01[15:0] <= density_reg125; 
          end 
          125: begin 
               lut_Y_data_00[15:0] <= density_reg125; 
               lut_Y_data_01[15:0] <= density_reg126; 
          end 
          126: begin 
               lut_Y_data_00[15:0] <= density_reg126; 
               lut_Y_data_01[15:0] <= density_reg127; 
          end 
          127: begin 
               lut_Y_data_00[15:0] <= density_reg127; 
               lut_Y_data_01[15:0] <= density_reg128; 
          end 
          128: begin 
               lut_Y_data_00[15:0] <= density_reg128; 
               lut_Y_data_01[15:0] <= density_reg129; 
          end 
          129: begin 
               lut_Y_data_00[15:0] <= density_reg129; 
               lut_Y_data_01[15:0] <= density_reg130; 
          end 
          130: begin 
               lut_Y_data_00[15:0] <= density_reg130; 
               lut_Y_data_01[15:0] <= density_reg131; 
          end 
          131: begin 
               lut_Y_data_00[15:0] <= density_reg131; 
               lut_Y_data_01[15:0] <= density_reg132; 
          end 
          132: begin 
               lut_Y_data_00[15:0] <= density_reg132; 
               lut_Y_data_01[15:0] <= density_reg133; 
          end 
          133: begin 
               lut_Y_data_00[15:0] <= density_reg133; 
               lut_Y_data_01[15:0] <= density_reg134; 
          end 
          134: begin 
               lut_Y_data_00[15:0] <= density_reg134; 
               lut_Y_data_01[15:0] <= density_reg135; 
          end 
          135: begin 
               lut_Y_data_00[15:0] <= density_reg135; 
               lut_Y_data_01[15:0] <= density_reg136; 
          end 
          136: begin 
               lut_Y_data_00[15:0] <= density_reg136; 
               lut_Y_data_01[15:0] <= density_reg137; 
          end 
          137: begin 
               lut_Y_data_00[15:0] <= density_reg137; 
               lut_Y_data_01[15:0] <= density_reg138; 
          end 
          138: begin 
               lut_Y_data_00[15:0] <= density_reg138; 
               lut_Y_data_01[15:0] <= density_reg139; 
          end 
          139: begin 
               lut_Y_data_00[15:0] <= density_reg139; 
               lut_Y_data_01[15:0] <= density_reg140; 
          end 
          140: begin 
               lut_Y_data_00[15:0] <= density_reg140; 
               lut_Y_data_01[15:0] <= density_reg141; 
          end 
          141: begin 
               lut_Y_data_00[15:0] <= density_reg141; 
               lut_Y_data_01[15:0] <= density_reg142; 
          end 
          142: begin 
               lut_Y_data_00[15:0] <= density_reg142; 
               lut_Y_data_01[15:0] <= density_reg143; 
          end 
          143: begin 
               lut_Y_data_00[15:0] <= density_reg143; 
               lut_Y_data_01[15:0] <= density_reg144; 
          end 
          144: begin 
               lut_Y_data_00[15:0] <= density_reg144; 
               lut_Y_data_01[15:0] <= density_reg145; 
          end 
          145: begin 
               lut_Y_data_00[15:0] <= density_reg145; 
               lut_Y_data_01[15:0] <= density_reg146; 
          end 
          146: begin 
               lut_Y_data_00[15:0] <= density_reg146; 
               lut_Y_data_01[15:0] <= density_reg147; 
          end 
          147: begin 
               lut_Y_data_00[15:0] <= density_reg147; 
               lut_Y_data_01[15:0] <= density_reg148; 
          end 
          148: begin 
               lut_Y_data_00[15:0] <= density_reg148; 
               lut_Y_data_01[15:0] <= density_reg149; 
          end 
          149: begin 
               lut_Y_data_00[15:0] <= density_reg149; 
               lut_Y_data_01[15:0] <= density_reg150; 
          end 
          150: begin 
               lut_Y_data_00[15:0] <= density_reg150; 
               lut_Y_data_01[15:0] <= density_reg151; 
          end 
          151: begin 
               lut_Y_data_00[15:0] <= density_reg151; 
               lut_Y_data_01[15:0] <= density_reg152; 
          end 
          152: begin 
               lut_Y_data_00[15:0] <= density_reg152; 
               lut_Y_data_01[15:0] <= density_reg153; 
          end 
          153: begin 
               lut_Y_data_00[15:0] <= density_reg153; 
               lut_Y_data_01[15:0] <= density_reg154; 
          end 
          154: begin 
               lut_Y_data_00[15:0] <= density_reg154; 
               lut_Y_data_01[15:0] <= density_reg155; 
          end 
          155: begin 
               lut_Y_data_00[15:0] <= density_reg155; 
               lut_Y_data_01[15:0] <= density_reg156; 
          end 
          156: begin 
               lut_Y_data_00[15:0] <= density_reg156; 
               lut_Y_data_01[15:0] <= density_reg157; 
          end 
          157: begin 
               lut_Y_data_00[15:0] <= density_reg157; 
               lut_Y_data_01[15:0] <= density_reg158; 
          end 
          158: begin 
               lut_Y_data_00[15:0] <= density_reg158; 
               lut_Y_data_01[15:0] <= density_reg159; 
          end 
          159: begin 
               lut_Y_data_00[15:0] <= density_reg159; 
               lut_Y_data_01[15:0] <= density_reg160; 
          end 
          160: begin 
               lut_Y_data_00[15:0] <= density_reg160; 
               lut_Y_data_01[15:0] <= density_reg161; 
          end 
          161: begin 
               lut_Y_data_00[15:0] <= density_reg161; 
               lut_Y_data_01[15:0] <= density_reg162; 
          end 
          162: begin 
               lut_Y_data_00[15:0] <= density_reg162; 
               lut_Y_data_01[15:0] <= density_reg163; 
          end 
          163: begin 
               lut_Y_data_00[15:0] <= density_reg163; 
               lut_Y_data_01[15:0] <= density_reg164; 
          end 
          164: begin 
               lut_Y_data_00[15:0] <= density_reg164; 
               lut_Y_data_01[15:0] <= density_reg165; 
          end 
          165: begin 
               lut_Y_data_00[15:0] <= density_reg165; 
               lut_Y_data_01[15:0] <= density_reg166; 
          end 
          166: begin 
               lut_Y_data_00[15:0] <= density_reg166; 
               lut_Y_data_01[15:0] <= density_reg167; 
          end 
          167: begin 
               lut_Y_data_00[15:0] <= density_reg167; 
               lut_Y_data_01[15:0] <= density_reg168; 
          end 
          168: begin 
               lut_Y_data_00[15:0] <= density_reg168; 
               lut_Y_data_01[15:0] <= density_reg169; 
          end 
          169: begin 
               lut_Y_data_00[15:0] <= density_reg169; 
               lut_Y_data_01[15:0] <= density_reg170; 
          end 
          170: begin 
               lut_Y_data_00[15:0] <= density_reg170; 
               lut_Y_data_01[15:0] <= density_reg171; 
          end 
          171: begin 
               lut_Y_data_00[15:0] <= density_reg171; 
               lut_Y_data_01[15:0] <= density_reg172; 
          end 
          172: begin 
               lut_Y_data_00[15:0] <= density_reg172; 
               lut_Y_data_01[15:0] <= density_reg173; 
          end 
          173: begin 
               lut_Y_data_00[15:0] <= density_reg173; 
               lut_Y_data_01[15:0] <= density_reg174; 
          end 
          174: begin 
               lut_Y_data_00[15:0] <= density_reg174; 
               lut_Y_data_01[15:0] <= density_reg175; 
          end 
          175: begin 
               lut_Y_data_00[15:0] <= density_reg175; 
               lut_Y_data_01[15:0] <= density_reg176; 
          end 
          176: begin 
               lut_Y_data_00[15:0] <= density_reg176; 
               lut_Y_data_01[15:0] <= density_reg177; 
          end 
          177: begin 
               lut_Y_data_00[15:0] <= density_reg177; 
               lut_Y_data_01[15:0] <= density_reg178; 
          end 
          178: begin 
               lut_Y_data_00[15:0] <= density_reg178; 
               lut_Y_data_01[15:0] <= density_reg179; 
          end 
          179: begin 
               lut_Y_data_00[15:0] <= density_reg179; 
               lut_Y_data_01[15:0] <= density_reg180; 
          end 
          180: begin 
               lut_Y_data_00[15:0] <= density_reg180; 
               lut_Y_data_01[15:0] <= density_reg181; 
          end 
          181: begin 
               lut_Y_data_00[15:0] <= density_reg181; 
               lut_Y_data_01[15:0] <= density_reg182; 
          end 
          182: begin 
               lut_Y_data_00[15:0] <= density_reg182; 
               lut_Y_data_01[15:0] <= density_reg183; 
          end 
          183: begin 
               lut_Y_data_00[15:0] <= density_reg183; 
               lut_Y_data_01[15:0] <= density_reg184; 
          end 
          184: begin 
               lut_Y_data_00[15:0] <= density_reg184; 
               lut_Y_data_01[15:0] <= density_reg185; 
          end 
          185: begin 
               lut_Y_data_00[15:0] <= density_reg185; 
               lut_Y_data_01[15:0] <= density_reg186; 
          end 
          186: begin 
               lut_Y_data_00[15:0] <= density_reg186; 
               lut_Y_data_01[15:0] <= density_reg187; 
          end 
          187: begin 
               lut_Y_data_00[15:0] <= density_reg187; 
               lut_Y_data_01[15:0] <= density_reg188; 
          end 
          188: begin 
               lut_Y_data_00[15:0] <= density_reg188; 
               lut_Y_data_01[15:0] <= density_reg189; 
          end 
          189: begin 
               lut_Y_data_00[15:0] <= density_reg189; 
               lut_Y_data_01[15:0] <= density_reg190; 
          end 
          190: begin 
               lut_Y_data_00[15:0] <= density_reg190; 
               lut_Y_data_01[15:0] <= density_reg191; 
          end 
          191: begin 
               lut_Y_data_00[15:0] <= density_reg191; 
               lut_Y_data_01[15:0] <= density_reg192; 
          end 
          192: begin 
               lut_Y_data_00[15:0] <= density_reg192; 
               lut_Y_data_01[15:0] <= density_reg193; 
          end 
          193: begin 
               lut_Y_data_00[15:0] <= density_reg193; 
               lut_Y_data_01[15:0] <= density_reg194; 
          end 
          194: begin 
               lut_Y_data_00[15:0] <= density_reg194; 
               lut_Y_data_01[15:0] <= density_reg195; 
          end 
          195: begin 
               lut_Y_data_00[15:0] <= density_reg195; 
               lut_Y_data_01[15:0] <= density_reg196; 
          end 
          196: begin 
               lut_Y_data_00[15:0] <= density_reg196; 
               lut_Y_data_01[15:0] <= density_reg197; 
          end 
          197: begin 
               lut_Y_data_00[15:0] <= density_reg197; 
               lut_Y_data_01[15:0] <= density_reg198; 
          end 
          198: begin 
               lut_Y_data_00[15:0] <= density_reg198; 
               lut_Y_data_01[15:0] <= density_reg199; 
          end 
          199: begin 
               lut_Y_data_00[15:0] <= density_reg199; 
               lut_Y_data_01[15:0] <= density_reg200; 
          end 
          200: begin 
               lut_Y_data_00[15:0] <= density_reg200; 
               lut_Y_data_01[15:0] <= density_reg201; 
          end 
          201: begin 
               lut_Y_data_00[15:0] <= density_reg201; 
               lut_Y_data_01[15:0] <= density_reg202; 
          end 
          202: begin 
               lut_Y_data_00[15:0] <= density_reg202; 
               lut_Y_data_01[15:0] <= density_reg203; 
          end 
          203: begin 
               lut_Y_data_00[15:0] <= density_reg203; 
               lut_Y_data_01[15:0] <= density_reg204; 
          end 
          204: begin 
               lut_Y_data_00[15:0] <= density_reg204; 
               lut_Y_data_01[15:0] <= density_reg205; 
          end 
          205: begin 
               lut_Y_data_00[15:0] <= density_reg205; 
               lut_Y_data_01[15:0] <= density_reg206; 
          end 
          206: begin 
               lut_Y_data_00[15:0] <= density_reg206; 
               lut_Y_data_01[15:0] <= density_reg207; 
          end 
          207: begin 
               lut_Y_data_00[15:0] <= density_reg207; 
               lut_Y_data_01[15:0] <= density_reg208; 
          end 
          208: begin 
               lut_Y_data_00[15:0] <= density_reg208; 
               lut_Y_data_01[15:0] <= density_reg209; 
          end 
          209: begin 
               lut_Y_data_00[15:0] <= density_reg209; 
               lut_Y_data_01[15:0] <= density_reg210; 
          end 
          210: begin 
               lut_Y_data_00[15:0] <= density_reg210; 
               lut_Y_data_01[15:0] <= density_reg211; 
          end 
          211: begin 
               lut_Y_data_00[15:0] <= density_reg211; 
               lut_Y_data_01[15:0] <= density_reg212; 
          end 
          212: begin 
               lut_Y_data_00[15:0] <= density_reg212; 
               lut_Y_data_01[15:0] <= density_reg213; 
          end 
          213: begin 
               lut_Y_data_00[15:0] <= density_reg213; 
               lut_Y_data_01[15:0] <= density_reg214; 
          end 
          214: begin 
               lut_Y_data_00[15:0] <= density_reg214; 
               lut_Y_data_01[15:0] <= density_reg215; 
          end 
          215: begin 
               lut_Y_data_00[15:0] <= density_reg215; 
               lut_Y_data_01[15:0] <= density_reg216; 
          end 
          216: begin 
               lut_Y_data_00[15:0] <= density_reg216; 
               lut_Y_data_01[15:0] <= density_reg217; 
          end 
          217: begin 
               lut_Y_data_00[15:0] <= density_reg217; 
               lut_Y_data_01[15:0] <= density_reg218; 
          end 
          218: begin 
               lut_Y_data_00[15:0] <= density_reg218; 
               lut_Y_data_01[15:0] <= density_reg219; 
          end 
          219: begin 
               lut_Y_data_00[15:0] <= density_reg219; 
               lut_Y_data_01[15:0] <= density_reg220; 
          end 
          220: begin 
               lut_Y_data_00[15:0] <= density_reg220; 
               lut_Y_data_01[15:0] <= density_reg221; 
          end 
          221: begin 
               lut_Y_data_00[15:0] <= density_reg221; 
               lut_Y_data_01[15:0] <= density_reg222; 
          end 
          222: begin 
               lut_Y_data_00[15:0] <= density_reg222; 
               lut_Y_data_01[15:0] <= density_reg223; 
          end 
          223: begin 
               lut_Y_data_00[15:0] <= density_reg223; 
               lut_Y_data_01[15:0] <= density_reg224; 
          end 
          224: begin 
               lut_Y_data_00[15:0] <= density_reg224; 
               lut_Y_data_01[15:0] <= density_reg225; 
          end 
          225: begin 
               lut_Y_data_00[15:0] <= density_reg225; 
               lut_Y_data_01[15:0] <= density_reg226; 
          end 
          226: begin 
               lut_Y_data_00[15:0] <= density_reg226; 
               lut_Y_data_01[15:0] <= density_reg227; 
          end 
          227: begin 
               lut_Y_data_00[15:0] <= density_reg227; 
               lut_Y_data_01[15:0] <= density_reg228; 
          end 
          228: begin 
               lut_Y_data_00[15:0] <= density_reg228; 
               lut_Y_data_01[15:0] <= density_reg229; 
          end 
          229: begin 
               lut_Y_data_00[15:0] <= density_reg229; 
               lut_Y_data_01[15:0] <= density_reg230; 
          end 
          230: begin 
               lut_Y_data_00[15:0] <= density_reg230; 
               lut_Y_data_01[15:0] <= density_reg231; 
          end 
          231: begin 
               lut_Y_data_00[15:0] <= density_reg231; 
               lut_Y_data_01[15:0] <= density_reg232; 
          end 
          232: begin 
               lut_Y_data_00[15:0] <= density_reg232; 
               lut_Y_data_01[15:0] <= density_reg233; 
          end 
          233: begin 
               lut_Y_data_00[15:0] <= density_reg233; 
               lut_Y_data_01[15:0] <= density_reg234; 
          end 
          234: begin 
               lut_Y_data_00[15:0] <= density_reg234; 
               lut_Y_data_01[15:0] <= density_reg235; 
          end 
          235: begin 
               lut_Y_data_00[15:0] <= density_reg235; 
               lut_Y_data_01[15:0] <= density_reg236; 
          end 
          236: begin 
               lut_Y_data_00[15:0] <= density_reg236; 
               lut_Y_data_01[15:0] <= density_reg237; 
          end 
          237: begin 
               lut_Y_data_00[15:0] <= density_reg237; 
               lut_Y_data_01[15:0] <= density_reg238; 
          end 
          238: begin 
               lut_Y_data_00[15:0] <= density_reg238; 
               lut_Y_data_01[15:0] <= density_reg239; 
          end 
          239: begin 
               lut_Y_data_00[15:0] <= density_reg239; 
               lut_Y_data_01[15:0] <= density_reg240; 
          end 
          240: begin 
               lut_Y_data_00[15:0] <= density_reg240; 
               lut_Y_data_01[15:0] <= density_reg241; 
          end 
          241: begin 
               lut_Y_data_00[15:0] <= density_reg241; 
               lut_Y_data_01[15:0] <= density_reg242; 
          end 
          242: begin 
               lut_Y_data_00[15:0] <= density_reg242; 
               lut_Y_data_01[15:0] <= density_reg243; 
          end 
          243: begin 
               lut_Y_data_00[15:0] <= density_reg243; 
               lut_Y_data_01[15:0] <= density_reg244; 
          end 
          244: begin 
               lut_Y_data_00[15:0] <= density_reg244; 
               lut_Y_data_01[15:0] <= density_reg245; 
          end 
          245: begin 
               lut_Y_data_00[15:0] <= density_reg245; 
               lut_Y_data_01[15:0] <= density_reg246; 
          end 
          246: begin 
               lut_Y_data_00[15:0] <= density_reg246; 
               lut_Y_data_01[15:0] <= density_reg247; 
          end 
          247: begin 
               lut_Y_data_00[15:0] <= density_reg247; 
               lut_Y_data_01[15:0] <= density_reg248; 
          end 
          248: begin 
               lut_Y_data_00[15:0] <= density_reg248; 
               lut_Y_data_01[15:0] <= density_reg249; 
          end 
          249: begin 
               lut_Y_data_00[15:0] <= density_reg249; 
               lut_Y_data_01[15:0] <= density_reg250; 
          end 
          250: begin 
               lut_Y_data_00[15:0] <= density_reg250; 
               lut_Y_data_01[15:0] <= density_reg251; 
          end 
          251: begin 
               lut_Y_data_00[15:0] <= density_reg251; 
               lut_Y_data_01[15:0] <= density_reg252; 
          end 
          252: begin 
               lut_Y_data_00[15:0] <= density_reg252; 
               lut_Y_data_01[15:0] <= density_reg253; 
          end 
          253: begin 
               lut_Y_data_00[15:0] <= density_reg253; 
               lut_Y_data_01[15:0] <= density_reg254; 
          end 
          254: begin 
               lut_Y_data_00[15:0] <= density_reg254; 
               lut_Y_data_01[15:0] <= density_reg255; 
          end 
          255: begin 
               lut_Y_data_00[15:0] <= density_reg255; 
               lut_Y_data_01[15:0] <= density_reg256; 
          end 
          256: begin 
               lut_Y_data_00[15:0] <= density_reg256; 
               lut_Y_data_01[15:0] <= density_reg256; 
          end 
          default: begin 
            lut_Y_data_00[15:0] <= density_reg0; 
            lut_Y_data_01[15:0] <= density_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_Y_data_10[15:0] <= {16{1'b0}};
     lut_Y_data_11[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & lut_Y_sel[1]) begin 
      if(dp2lut_Yinfo_1[16]) begin 
         lut_Y_data_10[15:0] <= density_reg0; 
         lut_Y_data_11[15:0] <= density_reg0; 
      end else if(dp2lut_Yinfo_1[17]) begin 
         lut_Y_data_10[15:0] <= density_reg256; 
         lut_Y_data_11[15:0] <= density_reg256; 
      end else begin 
        case(dp2lut_Y_entry_1[9:0]) 
          0: begin 
               lut_Y_data_10[15:0] <= density_reg0; 
               lut_Y_data_11[15:0] <= density_reg1; 
          end 
          1: begin 
               lut_Y_data_10[15:0] <= density_reg1; 
               lut_Y_data_11[15:0] <= density_reg2; 
          end 
          2: begin 
               lut_Y_data_10[15:0] <= density_reg2; 
               lut_Y_data_11[15:0] <= density_reg3; 
          end 
          3: begin 
               lut_Y_data_10[15:0] <= density_reg3; 
               lut_Y_data_11[15:0] <= density_reg4; 
          end 
          4: begin 
               lut_Y_data_10[15:0] <= density_reg4; 
               lut_Y_data_11[15:0] <= density_reg5; 
          end 
          5: begin 
               lut_Y_data_10[15:0] <= density_reg5; 
               lut_Y_data_11[15:0] <= density_reg6; 
          end 
          6: begin 
               lut_Y_data_10[15:0] <= density_reg6; 
               lut_Y_data_11[15:0] <= density_reg7; 
          end 
          7: begin 
               lut_Y_data_10[15:0] <= density_reg7; 
               lut_Y_data_11[15:0] <= density_reg8; 
          end 
          8: begin 
               lut_Y_data_10[15:0] <= density_reg8; 
               lut_Y_data_11[15:0] <= density_reg9; 
          end 
          9: begin 
               lut_Y_data_10[15:0] <= density_reg9; 
               lut_Y_data_11[15:0] <= density_reg10; 
          end 
          10: begin 
               lut_Y_data_10[15:0] <= density_reg10; 
               lut_Y_data_11[15:0] <= density_reg11; 
          end 
          11: begin 
               lut_Y_data_10[15:0] <= density_reg11; 
               lut_Y_data_11[15:0] <= density_reg12; 
          end 
          12: begin 
               lut_Y_data_10[15:0] <= density_reg12; 
               lut_Y_data_11[15:0] <= density_reg13; 
          end 
          13: begin 
               lut_Y_data_10[15:0] <= density_reg13; 
               lut_Y_data_11[15:0] <= density_reg14; 
          end 
          14: begin 
               lut_Y_data_10[15:0] <= density_reg14; 
               lut_Y_data_11[15:0] <= density_reg15; 
          end 
          15: begin 
               lut_Y_data_10[15:0] <= density_reg15; 
               lut_Y_data_11[15:0] <= density_reg16; 
          end 
          16: begin 
               lut_Y_data_10[15:0] <= density_reg16; 
               lut_Y_data_11[15:0] <= density_reg17; 
          end 
          17: begin 
               lut_Y_data_10[15:0] <= density_reg17; 
               lut_Y_data_11[15:0] <= density_reg18; 
          end 
          18: begin 
               lut_Y_data_10[15:0] <= density_reg18; 
               lut_Y_data_11[15:0] <= density_reg19; 
          end 
          19: begin 
               lut_Y_data_10[15:0] <= density_reg19; 
               lut_Y_data_11[15:0] <= density_reg20; 
          end 
          20: begin 
               lut_Y_data_10[15:0] <= density_reg20; 
               lut_Y_data_11[15:0] <= density_reg21; 
          end 
          21: begin 
               lut_Y_data_10[15:0] <= density_reg21; 
               lut_Y_data_11[15:0] <= density_reg22; 
          end 
          22: begin 
               lut_Y_data_10[15:0] <= density_reg22; 
               lut_Y_data_11[15:0] <= density_reg23; 
          end 
          23: begin 
               lut_Y_data_10[15:0] <= density_reg23; 
               lut_Y_data_11[15:0] <= density_reg24; 
          end 
          24: begin 
               lut_Y_data_10[15:0] <= density_reg24; 
               lut_Y_data_11[15:0] <= density_reg25; 
          end 
          25: begin 
               lut_Y_data_10[15:0] <= density_reg25; 
               lut_Y_data_11[15:0] <= density_reg26; 
          end 
          26: begin 
               lut_Y_data_10[15:0] <= density_reg26; 
               lut_Y_data_11[15:0] <= density_reg27; 
          end 
          27: begin 
               lut_Y_data_10[15:0] <= density_reg27; 
               lut_Y_data_11[15:0] <= density_reg28; 
          end 
          28: begin 
               lut_Y_data_10[15:0] <= density_reg28; 
               lut_Y_data_11[15:0] <= density_reg29; 
          end 
          29: begin 
               lut_Y_data_10[15:0] <= density_reg29; 
               lut_Y_data_11[15:0] <= density_reg30; 
          end 
          30: begin 
               lut_Y_data_10[15:0] <= density_reg30; 
               lut_Y_data_11[15:0] <= density_reg31; 
          end 
          31: begin 
               lut_Y_data_10[15:0] <= density_reg31; 
               lut_Y_data_11[15:0] <= density_reg32; 
          end 
          32: begin 
               lut_Y_data_10[15:0] <= density_reg32; 
               lut_Y_data_11[15:0] <= density_reg33; 
          end 
          33: begin 
               lut_Y_data_10[15:0] <= density_reg33; 
               lut_Y_data_11[15:0] <= density_reg34; 
          end 
          34: begin 
               lut_Y_data_10[15:0] <= density_reg34; 
               lut_Y_data_11[15:0] <= density_reg35; 
          end 
          35: begin 
               lut_Y_data_10[15:0] <= density_reg35; 
               lut_Y_data_11[15:0] <= density_reg36; 
          end 
          36: begin 
               lut_Y_data_10[15:0] <= density_reg36; 
               lut_Y_data_11[15:0] <= density_reg37; 
          end 
          37: begin 
               lut_Y_data_10[15:0] <= density_reg37; 
               lut_Y_data_11[15:0] <= density_reg38; 
          end 
          38: begin 
               lut_Y_data_10[15:0] <= density_reg38; 
               lut_Y_data_11[15:0] <= density_reg39; 
          end 
          39: begin 
               lut_Y_data_10[15:0] <= density_reg39; 
               lut_Y_data_11[15:0] <= density_reg40; 
          end 
          40: begin 
               lut_Y_data_10[15:0] <= density_reg40; 
               lut_Y_data_11[15:0] <= density_reg41; 
          end 
          41: begin 
               lut_Y_data_10[15:0] <= density_reg41; 
               lut_Y_data_11[15:0] <= density_reg42; 
          end 
          42: begin 
               lut_Y_data_10[15:0] <= density_reg42; 
               lut_Y_data_11[15:0] <= density_reg43; 
          end 
          43: begin 
               lut_Y_data_10[15:0] <= density_reg43; 
               lut_Y_data_11[15:0] <= density_reg44; 
          end 
          44: begin 
               lut_Y_data_10[15:0] <= density_reg44; 
               lut_Y_data_11[15:0] <= density_reg45; 
          end 
          45: begin 
               lut_Y_data_10[15:0] <= density_reg45; 
               lut_Y_data_11[15:0] <= density_reg46; 
          end 
          46: begin 
               lut_Y_data_10[15:0] <= density_reg46; 
               lut_Y_data_11[15:0] <= density_reg47; 
          end 
          47: begin 
               lut_Y_data_10[15:0] <= density_reg47; 
               lut_Y_data_11[15:0] <= density_reg48; 
          end 
          48: begin 
               lut_Y_data_10[15:0] <= density_reg48; 
               lut_Y_data_11[15:0] <= density_reg49; 
          end 
          49: begin 
               lut_Y_data_10[15:0] <= density_reg49; 
               lut_Y_data_11[15:0] <= density_reg50; 
          end 
          50: begin 
               lut_Y_data_10[15:0] <= density_reg50; 
               lut_Y_data_11[15:0] <= density_reg51; 
          end 
          51: begin 
               lut_Y_data_10[15:0] <= density_reg51; 
               lut_Y_data_11[15:0] <= density_reg52; 
          end 
          52: begin 
               lut_Y_data_10[15:0] <= density_reg52; 
               lut_Y_data_11[15:0] <= density_reg53; 
          end 
          53: begin 
               lut_Y_data_10[15:0] <= density_reg53; 
               lut_Y_data_11[15:0] <= density_reg54; 
          end 
          54: begin 
               lut_Y_data_10[15:0] <= density_reg54; 
               lut_Y_data_11[15:0] <= density_reg55; 
          end 
          55: begin 
               lut_Y_data_10[15:0] <= density_reg55; 
               lut_Y_data_11[15:0] <= density_reg56; 
          end 
          56: begin 
               lut_Y_data_10[15:0] <= density_reg56; 
               lut_Y_data_11[15:0] <= density_reg57; 
          end 
          57: begin 
               lut_Y_data_10[15:0] <= density_reg57; 
               lut_Y_data_11[15:0] <= density_reg58; 
          end 
          58: begin 
               lut_Y_data_10[15:0] <= density_reg58; 
               lut_Y_data_11[15:0] <= density_reg59; 
          end 
          59: begin 
               lut_Y_data_10[15:0] <= density_reg59; 
               lut_Y_data_11[15:0] <= density_reg60; 
          end 
          60: begin 
               lut_Y_data_10[15:0] <= density_reg60; 
               lut_Y_data_11[15:0] <= density_reg61; 
          end 
          61: begin 
               lut_Y_data_10[15:0] <= density_reg61; 
               lut_Y_data_11[15:0] <= density_reg62; 
          end 
          62: begin 
               lut_Y_data_10[15:0] <= density_reg62; 
               lut_Y_data_11[15:0] <= density_reg63; 
          end 
          63: begin 
               lut_Y_data_10[15:0] <= density_reg63; 
               lut_Y_data_11[15:0] <= density_reg64; 
          end 
          64: begin 
               lut_Y_data_10[15:0] <= density_reg64; 
               lut_Y_data_11[15:0] <= density_reg65; 
          end 
          65: begin 
               lut_Y_data_10[15:0] <= density_reg65; 
               lut_Y_data_11[15:0] <= density_reg66; 
          end 
          66: begin 
               lut_Y_data_10[15:0] <= density_reg66; 
               lut_Y_data_11[15:0] <= density_reg67; 
          end 
          67: begin 
               lut_Y_data_10[15:0] <= density_reg67; 
               lut_Y_data_11[15:0] <= density_reg68; 
          end 
          68: begin 
               lut_Y_data_10[15:0] <= density_reg68; 
               lut_Y_data_11[15:0] <= density_reg69; 
          end 
          69: begin 
               lut_Y_data_10[15:0] <= density_reg69; 
               lut_Y_data_11[15:0] <= density_reg70; 
          end 
          70: begin 
               lut_Y_data_10[15:0] <= density_reg70; 
               lut_Y_data_11[15:0] <= density_reg71; 
          end 
          71: begin 
               lut_Y_data_10[15:0] <= density_reg71; 
               lut_Y_data_11[15:0] <= density_reg72; 
          end 
          72: begin 
               lut_Y_data_10[15:0] <= density_reg72; 
               lut_Y_data_11[15:0] <= density_reg73; 
          end 
          73: begin 
               lut_Y_data_10[15:0] <= density_reg73; 
               lut_Y_data_11[15:0] <= density_reg74; 
          end 
          74: begin 
               lut_Y_data_10[15:0] <= density_reg74; 
               lut_Y_data_11[15:0] <= density_reg75; 
          end 
          75: begin 
               lut_Y_data_10[15:0] <= density_reg75; 
               lut_Y_data_11[15:0] <= density_reg76; 
          end 
          76: begin 
               lut_Y_data_10[15:0] <= density_reg76; 
               lut_Y_data_11[15:0] <= density_reg77; 
          end 
          77: begin 
               lut_Y_data_10[15:0] <= density_reg77; 
               lut_Y_data_11[15:0] <= density_reg78; 
          end 
          78: begin 
               lut_Y_data_10[15:0] <= density_reg78; 
               lut_Y_data_11[15:0] <= density_reg79; 
          end 
          79: begin 
               lut_Y_data_10[15:0] <= density_reg79; 
               lut_Y_data_11[15:0] <= density_reg80; 
          end 
          80: begin 
               lut_Y_data_10[15:0] <= density_reg80; 
               lut_Y_data_11[15:0] <= density_reg81; 
          end 
          81: begin 
               lut_Y_data_10[15:0] <= density_reg81; 
               lut_Y_data_11[15:0] <= density_reg82; 
          end 
          82: begin 
               lut_Y_data_10[15:0] <= density_reg82; 
               lut_Y_data_11[15:0] <= density_reg83; 
          end 
          83: begin 
               lut_Y_data_10[15:0] <= density_reg83; 
               lut_Y_data_11[15:0] <= density_reg84; 
          end 
          84: begin 
               lut_Y_data_10[15:0] <= density_reg84; 
               lut_Y_data_11[15:0] <= density_reg85; 
          end 
          85: begin 
               lut_Y_data_10[15:0] <= density_reg85; 
               lut_Y_data_11[15:0] <= density_reg86; 
          end 
          86: begin 
               lut_Y_data_10[15:0] <= density_reg86; 
               lut_Y_data_11[15:0] <= density_reg87; 
          end 
          87: begin 
               lut_Y_data_10[15:0] <= density_reg87; 
               lut_Y_data_11[15:0] <= density_reg88; 
          end 
          88: begin 
               lut_Y_data_10[15:0] <= density_reg88; 
               lut_Y_data_11[15:0] <= density_reg89; 
          end 
          89: begin 
               lut_Y_data_10[15:0] <= density_reg89; 
               lut_Y_data_11[15:0] <= density_reg90; 
          end 
          90: begin 
               lut_Y_data_10[15:0] <= density_reg90; 
               lut_Y_data_11[15:0] <= density_reg91; 
          end 
          91: begin 
               lut_Y_data_10[15:0] <= density_reg91; 
               lut_Y_data_11[15:0] <= density_reg92; 
          end 
          92: begin 
               lut_Y_data_10[15:0] <= density_reg92; 
               lut_Y_data_11[15:0] <= density_reg93; 
          end 
          93: begin 
               lut_Y_data_10[15:0] <= density_reg93; 
               lut_Y_data_11[15:0] <= density_reg94; 
          end 
          94: begin 
               lut_Y_data_10[15:0] <= density_reg94; 
               lut_Y_data_11[15:0] <= density_reg95; 
          end 
          95: begin 
               lut_Y_data_10[15:0] <= density_reg95; 
               lut_Y_data_11[15:0] <= density_reg96; 
          end 
          96: begin 
               lut_Y_data_10[15:0] <= density_reg96; 
               lut_Y_data_11[15:0] <= density_reg97; 
          end 
          97: begin 
               lut_Y_data_10[15:0] <= density_reg97; 
               lut_Y_data_11[15:0] <= density_reg98; 
          end 
          98: begin 
               lut_Y_data_10[15:0] <= density_reg98; 
               lut_Y_data_11[15:0] <= density_reg99; 
          end 
          99: begin 
               lut_Y_data_10[15:0] <= density_reg99; 
               lut_Y_data_11[15:0] <= density_reg100; 
          end 
          100: begin 
               lut_Y_data_10[15:0] <= density_reg100; 
               lut_Y_data_11[15:0] <= density_reg101; 
          end 
          101: begin 
               lut_Y_data_10[15:0] <= density_reg101; 
               lut_Y_data_11[15:0] <= density_reg102; 
          end 
          102: begin 
               lut_Y_data_10[15:0] <= density_reg102; 
               lut_Y_data_11[15:0] <= density_reg103; 
          end 
          103: begin 
               lut_Y_data_10[15:0] <= density_reg103; 
               lut_Y_data_11[15:0] <= density_reg104; 
          end 
          104: begin 
               lut_Y_data_10[15:0] <= density_reg104; 
               lut_Y_data_11[15:0] <= density_reg105; 
          end 
          105: begin 
               lut_Y_data_10[15:0] <= density_reg105; 
               lut_Y_data_11[15:0] <= density_reg106; 
          end 
          106: begin 
               lut_Y_data_10[15:0] <= density_reg106; 
               lut_Y_data_11[15:0] <= density_reg107; 
          end 
          107: begin 
               lut_Y_data_10[15:0] <= density_reg107; 
               lut_Y_data_11[15:0] <= density_reg108; 
          end 
          108: begin 
               lut_Y_data_10[15:0] <= density_reg108; 
               lut_Y_data_11[15:0] <= density_reg109; 
          end 
          109: begin 
               lut_Y_data_10[15:0] <= density_reg109; 
               lut_Y_data_11[15:0] <= density_reg110; 
          end 
          110: begin 
               lut_Y_data_10[15:0] <= density_reg110; 
               lut_Y_data_11[15:0] <= density_reg111; 
          end 
          111: begin 
               lut_Y_data_10[15:0] <= density_reg111; 
               lut_Y_data_11[15:0] <= density_reg112; 
          end 
          112: begin 
               lut_Y_data_10[15:0] <= density_reg112; 
               lut_Y_data_11[15:0] <= density_reg113; 
          end 
          113: begin 
               lut_Y_data_10[15:0] <= density_reg113; 
               lut_Y_data_11[15:0] <= density_reg114; 
          end 
          114: begin 
               lut_Y_data_10[15:0] <= density_reg114; 
               lut_Y_data_11[15:0] <= density_reg115; 
          end 
          115: begin 
               lut_Y_data_10[15:0] <= density_reg115; 
               lut_Y_data_11[15:0] <= density_reg116; 
          end 
          116: begin 
               lut_Y_data_10[15:0] <= density_reg116; 
               lut_Y_data_11[15:0] <= density_reg117; 
          end 
          117: begin 
               lut_Y_data_10[15:0] <= density_reg117; 
               lut_Y_data_11[15:0] <= density_reg118; 
          end 
          118: begin 
               lut_Y_data_10[15:0] <= density_reg118; 
               lut_Y_data_11[15:0] <= density_reg119; 
          end 
          119: begin 
               lut_Y_data_10[15:0] <= density_reg119; 
               lut_Y_data_11[15:0] <= density_reg120; 
          end 
          120: begin 
               lut_Y_data_10[15:0] <= density_reg120; 
               lut_Y_data_11[15:0] <= density_reg121; 
          end 
          121: begin 
               lut_Y_data_10[15:0] <= density_reg121; 
               lut_Y_data_11[15:0] <= density_reg122; 
          end 
          122: begin 
               lut_Y_data_10[15:0] <= density_reg122; 
               lut_Y_data_11[15:0] <= density_reg123; 
          end 
          123: begin 
               lut_Y_data_10[15:0] <= density_reg123; 
               lut_Y_data_11[15:0] <= density_reg124; 
          end 
          124: begin 
               lut_Y_data_10[15:0] <= density_reg124; 
               lut_Y_data_11[15:0] <= density_reg125; 
          end 
          125: begin 
               lut_Y_data_10[15:0] <= density_reg125; 
               lut_Y_data_11[15:0] <= density_reg126; 
          end 
          126: begin 
               lut_Y_data_10[15:0] <= density_reg126; 
               lut_Y_data_11[15:0] <= density_reg127; 
          end 
          127: begin 
               lut_Y_data_10[15:0] <= density_reg127; 
               lut_Y_data_11[15:0] <= density_reg128; 
          end 
          128: begin 
               lut_Y_data_10[15:0] <= density_reg128; 
               lut_Y_data_11[15:0] <= density_reg129; 
          end 
          129: begin 
               lut_Y_data_10[15:0] <= density_reg129; 
               lut_Y_data_11[15:0] <= density_reg130; 
          end 
          130: begin 
               lut_Y_data_10[15:0] <= density_reg130; 
               lut_Y_data_11[15:0] <= density_reg131; 
          end 
          131: begin 
               lut_Y_data_10[15:0] <= density_reg131; 
               lut_Y_data_11[15:0] <= density_reg132; 
          end 
          132: begin 
               lut_Y_data_10[15:0] <= density_reg132; 
               lut_Y_data_11[15:0] <= density_reg133; 
          end 
          133: begin 
               lut_Y_data_10[15:0] <= density_reg133; 
               lut_Y_data_11[15:0] <= density_reg134; 
          end 
          134: begin 
               lut_Y_data_10[15:0] <= density_reg134; 
               lut_Y_data_11[15:0] <= density_reg135; 
          end 
          135: begin 
               lut_Y_data_10[15:0] <= density_reg135; 
               lut_Y_data_11[15:0] <= density_reg136; 
          end 
          136: begin 
               lut_Y_data_10[15:0] <= density_reg136; 
               lut_Y_data_11[15:0] <= density_reg137; 
          end 
          137: begin 
               lut_Y_data_10[15:0] <= density_reg137; 
               lut_Y_data_11[15:0] <= density_reg138; 
          end 
          138: begin 
               lut_Y_data_10[15:0] <= density_reg138; 
               lut_Y_data_11[15:0] <= density_reg139; 
          end 
          139: begin 
               lut_Y_data_10[15:0] <= density_reg139; 
               lut_Y_data_11[15:0] <= density_reg140; 
          end 
          140: begin 
               lut_Y_data_10[15:0] <= density_reg140; 
               lut_Y_data_11[15:0] <= density_reg141; 
          end 
          141: begin 
               lut_Y_data_10[15:0] <= density_reg141; 
               lut_Y_data_11[15:0] <= density_reg142; 
          end 
          142: begin 
               lut_Y_data_10[15:0] <= density_reg142; 
               lut_Y_data_11[15:0] <= density_reg143; 
          end 
          143: begin 
               lut_Y_data_10[15:0] <= density_reg143; 
               lut_Y_data_11[15:0] <= density_reg144; 
          end 
          144: begin 
               lut_Y_data_10[15:0] <= density_reg144; 
               lut_Y_data_11[15:0] <= density_reg145; 
          end 
          145: begin 
               lut_Y_data_10[15:0] <= density_reg145; 
               lut_Y_data_11[15:0] <= density_reg146; 
          end 
          146: begin 
               lut_Y_data_10[15:0] <= density_reg146; 
               lut_Y_data_11[15:0] <= density_reg147; 
          end 
          147: begin 
               lut_Y_data_10[15:0] <= density_reg147; 
               lut_Y_data_11[15:0] <= density_reg148; 
          end 
          148: begin 
               lut_Y_data_10[15:0] <= density_reg148; 
               lut_Y_data_11[15:0] <= density_reg149; 
          end 
          149: begin 
               lut_Y_data_10[15:0] <= density_reg149; 
               lut_Y_data_11[15:0] <= density_reg150; 
          end 
          150: begin 
               lut_Y_data_10[15:0] <= density_reg150; 
               lut_Y_data_11[15:0] <= density_reg151; 
          end 
          151: begin 
               lut_Y_data_10[15:0] <= density_reg151; 
               lut_Y_data_11[15:0] <= density_reg152; 
          end 
          152: begin 
               lut_Y_data_10[15:0] <= density_reg152; 
               lut_Y_data_11[15:0] <= density_reg153; 
          end 
          153: begin 
               lut_Y_data_10[15:0] <= density_reg153; 
               lut_Y_data_11[15:0] <= density_reg154; 
          end 
          154: begin 
               lut_Y_data_10[15:0] <= density_reg154; 
               lut_Y_data_11[15:0] <= density_reg155; 
          end 
          155: begin 
               lut_Y_data_10[15:0] <= density_reg155; 
               lut_Y_data_11[15:0] <= density_reg156; 
          end 
          156: begin 
               lut_Y_data_10[15:0] <= density_reg156; 
               lut_Y_data_11[15:0] <= density_reg157; 
          end 
          157: begin 
               lut_Y_data_10[15:0] <= density_reg157; 
               lut_Y_data_11[15:0] <= density_reg158; 
          end 
          158: begin 
               lut_Y_data_10[15:0] <= density_reg158; 
               lut_Y_data_11[15:0] <= density_reg159; 
          end 
          159: begin 
               lut_Y_data_10[15:0] <= density_reg159; 
               lut_Y_data_11[15:0] <= density_reg160; 
          end 
          160: begin 
               lut_Y_data_10[15:0] <= density_reg160; 
               lut_Y_data_11[15:0] <= density_reg161; 
          end 
          161: begin 
               lut_Y_data_10[15:0] <= density_reg161; 
               lut_Y_data_11[15:0] <= density_reg162; 
          end 
          162: begin 
               lut_Y_data_10[15:0] <= density_reg162; 
               lut_Y_data_11[15:0] <= density_reg163; 
          end 
          163: begin 
               lut_Y_data_10[15:0] <= density_reg163; 
               lut_Y_data_11[15:0] <= density_reg164; 
          end 
          164: begin 
               lut_Y_data_10[15:0] <= density_reg164; 
               lut_Y_data_11[15:0] <= density_reg165; 
          end 
          165: begin 
               lut_Y_data_10[15:0] <= density_reg165; 
               lut_Y_data_11[15:0] <= density_reg166; 
          end 
          166: begin 
               lut_Y_data_10[15:0] <= density_reg166; 
               lut_Y_data_11[15:0] <= density_reg167; 
          end 
          167: begin 
               lut_Y_data_10[15:0] <= density_reg167; 
               lut_Y_data_11[15:0] <= density_reg168; 
          end 
          168: begin 
               lut_Y_data_10[15:0] <= density_reg168; 
               lut_Y_data_11[15:0] <= density_reg169; 
          end 
          169: begin 
               lut_Y_data_10[15:0] <= density_reg169; 
               lut_Y_data_11[15:0] <= density_reg170; 
          end 
          170: begin 
               lut_Y_data_10[15:0] <= density_reg170; 
               lut_Y_data_11[15:0] <= density_reg171; 
          end 
          171: begin 
               lut_Y_data_10[15:0] <= density_reg171; 
               lut_Y_data_11[15:0] <= density_reg172; 
          end 
          172: begin 
               lut_Y_data_10[15:0] <= density_reg172; 
               lut_Y_data_11[15:0] <= density_reg173; 
          end 
          173: begin 
               lut_Y_data_10[15:0] <= density_reg173; 
               lut_Y_data_11[15:0] <= density_reg174; 
          end 
          174: begin 
               lut_Y_data_10[15:0] <= density_reg174; 
               lut_Y_data_11[15:0] <= density_reg175; 
          end 
          175: begin 
               lut_Y_data_10[15:0] <= density_reg175; 
               lut_Y_data_11[15:0] <= density_reg176; 
          end 
          176: begin 
               lut_Y_data_10[15:0] <= density_reg176; 
               lut_Y_data_11[15:0] <= density_reg177; 
          end 
          177: begin 
               lut_Y_data_10[15:0] <= density_reg177; 
               lut_Y_data_11[15:0] <= density_reg178; 
          end 
          178: begin 
               lut_Y_data_10[15:0] <= density_reg178; 
               lut_Y_data_11[15:0] <= density_reg179; 
          end 
          179: begin 
               lut_Y_data_10[15:0] <= density_reg179; 
               lut_Y_data_11[15:0] <= density_reg180; 
          end 
          180: begin 
               lut_Y_data_10[15:0] <= density_reg180; 
               lut_Y_data_11[15:0] <= density_reg181; 
          end 
          181: begin 
               lut_Y_data_10[15:0] <= density_reg181; 
               lut_Y_data_11[15:0] <= density_reg182; 
          end 
          182: begin 
               lut_Y_data_10[15:0] <= density_reg182; 
               lut_Y_data_11[15:0] <= density_reg183; 
          end 
          183: begin 
               lut_Y_data_10[15:0] <= density_reg183; 
               lut_Y_data_11[15:0] <= density_reg184; 
          end 
          184: begin 
               lut_Y_data_10[15:0] <= density_reg184; 
               lut_Y_data_11[15:0] <= density_reg185; 
          end 
          185: begin 
               lut_Y_data_10[15:0] <= density_reg185; 
               lut_Y_data_11[15:0] <= density_reg186; 
          end 
          186: begin 
               lut_Y_data_10[15:0] <= density_reg186; 
               lut_Y_data_11[15:0] <= density_reg187; 
          end 
          187: begin 
               lut_Y_data_10[15:0] <= density_reg187; 
               lut_Y_data_11[15:0] <= density_reg188; 
          end 
          188: begin 
               lut_Y_data_10[15:0] <= density_reg188; 
               lut_Y_data_11[15:0] <= density_reg189; 
          end 
          189: begin 
               lut_Y_data_10[15:0] <= density_reg189; 
               lut_Y_data_11[15:0] <= density_reg190; 
          end 
          190: begin 
               lut_Y_data_10[15:0] <= density_reg190; 
               lut_Y_data_11[15:0] <= density_reg191; 
          end 
          191: begin 
               lut_Y_data_10[15:0] <= density_reg191; 
               lut_Y_data_11[15:0] <= density_reg192; 
          end 
          192: begin 
               lut_Y_data_10[15:0] <= density_reg192; 
               lut_Y_data_11[15:0] <= density_reg193; 
          end 
          193: begin 
               lut_Y_data_10[15:0] <= density_reg193; 
               lut_Y_data_11[15:0] <= density_reg194; 
          end 
          194: begin 
               lut_Y_data_10[15:0] <= density_reg194; 
               lut_Y_data_11[15:0] <= density_reg195; 
          end 
          195: begin 
               lut_Y_data_10[15:0] <= density_reg195; 
               lut_Y_data_11[15:0] <= density_reg196; 
          end 
          196: begin 
               lut_Y_data_10[15:0] <= density_reg196; 
               lut_Y_data_11[15:0] <= density_reg197; 
          end 
          197: begin 
               lut_Y_data_10[15:0] <= density_reg197; 
               lut_Y_data_11[15:0] <= density_reg198; 
          end 
          198: begin 
               lut_Y_data_10[15:0] <= density_reg198; 
               lut_Y_data_11[15:0] <= density_reg199; 
          end 
          199: begin 
               lut_Y_data_10[15:0] <= density_reg199; 
               lut_Y_data_11[15:0] <= density_reg200; 
          end 
          200: begin 
               lut_Y_data_10[15:0] <= density_reg200; 
               lut_Y_data_11[15:0] <= density_reg201; 
          end 
          201: begin 
               lut_Y_data_10[15:0] <= density_reg201; 
               lut_Y_data_11[15:0] <= density_reg202; 
          end 
          202: begin 
               lut_Y_data_10[15:0] <= density_reg202; 
               lut_Y_data_11[15:0] <= density_reg203; 
          end 
          203: begin 
               lut_Y_data_10[15:0] <= density_reg203; 
               lut_Y_data_11[15:0] <= density_reg204; 
          end 
          204: begin 
               lut_Y_data_10[15:0] <= density_reg204; 
               lut_Y_data_11[15:0] <= density_reg205; 
          end 
          205: begin 
               lut_Y_data_10[15:0] <= density_reg205; 
               lut_Y_data_11[15:0] <= density_reg206; 
          end 
          206: begin 
               lut_Y_data_10[15:0] <= density_reg206; 
               lut_Y_data_11[15:0] <= density_reg207; 
          end 
          207: begin 
               lut_Y_data_10[15:0] <= density_reg207; 
               lut_Y_data_11[15:0] <= density_reg208; 
          end 
          208: begin 
               lut_Y_data_10[15:0] <= density_reg208; 
               lut_Y_data_11[15:0] <= density_reg209; 
          end 
          209: begin 
               lut_Y_data_10[15:0] <= density_reg209; 
               lut_Y_data_11[15:0] <= density_reg210; 
          end 
          210: begin 
               lut_Y_data_10[15:0] <= density_reg210; 
               lut_Y_data_11[15:0] <= density_reg211; 
          end 
          211: begin 
               lut_Y_data_10[15:0] <= density_reg211; 
               lut_Y_data_11[15:0] <= density_reg212; 
          end 
          212: begin 
               lut_Y_data_10[15:0] <= density_reg212; 
               lut_Y_data_11[15:0] <= density_reg213; 
          end 
          213: begin 
               lut_Y_data_10[15:0] <= density_reg213; 
               lut_Y_data_11[15:0] <= density_reg214; 
          end 
          214: begin 
               lut_Y_data_10[15:0] <= density_reg214; 
               lut_Y_data_11[15:0] <= density_reg215; 
          end 
          215: begin 
               lut_Y_data_10[15:0] <= density_reg215; 
               lut_Y_data_11[15:0] <= density_reg216; 
          end 
          216: begin 
               lut_Y_data_10[15:0] <= density_reg216; 
               lut_Y_data_11[15:0] <= density_reg217; 
          end 
          217: begin 
               lut_Y_data_10[15:0] <= density_reg217; 
               lut_Y_data_11[15:0] <= density_reg218; 
          end 
          218: begin 
               lut_Y_data_10[15:0] <= density_reg218; 
               lut_Y_data_11[15:0] <= density_reg219; 
          end 
          219: begin 
               lut_Y_data_10[15:0] <= density_reg219; 
               lut_Y_data_11[15:0] <= density_reg220; 
          end 
          220: begin 
               lut_Y_data_10[15:0] <= density_reg220; 
               lut_Y_data_11[15:0] <= density_reg221; 
          end 
          221: begin 
               lut_Y_data_10[15:0] <= density_reg221; 
               lut_Y_data_11[15:0] <= density_reg222; 
          end 
          222: begin 
               lut_Y_data_10[15:0] <= density_reg222; 
               lut_Y_data_11[15:0] <= density_reg223; 
          end 
          223: begin 
               lut_Y_data_10[15:0] <= density_reg223; 
               lut_Y_data_11[15:0] <= density_reg224; 
          end 
          224: begin 
               lut_Y_data_10[15:0] <= density_reg224; 
               lut_Y_data_11[15:0] <= density_reg225; 
          end 
          225: begin 
               lut_Y_data_10[15:0] <= density_reg225; 
               lut_Y_data_11[15:0] <= density_reg226; 
          end 
          226: begin 
               lut_Y_data_10[15:0] <= density_reg226; 
               lut_Y_data_11[15:0] <= density_reg227; 
          end 
          227: begin 
               lut_Y_data_10[15:0] <= density_reg227; 
               lut_Y_data_11[15:0] <= density_reg228; 
          end 
          228: begin 
               lut_Y_data_10[15:0] <= density_reg228; 
               lut_Y_data_11[15:0] <= density_reg229; 
          end 
          229: begin 
               lut_Y_data_10[15:0] <= density_reg229; 
               lut_Y_data_11[15:0] <= density_reg230; 
          end 
          230: begin 
               lut_Y_data_10[15:0] <= density_reg230; 
               lut_Y_data_11[15:0] <= density_reg231; 
          end 
          231: begin 
               lut_Y_data_10[15:0] <= density_reg231; 
               lut_Y_data_11[15:0] <= density_reg232; 
          end 
          232: begin 
               lut_Y_data_10[15:0] <= density_reg232; 
               lut_Y_data_11[15:0] <= density_reg233; 
          end 
          233: begin 
               lut_Y_data_10[15:0] <= density_reg233; 
               lut_Y_data_11[15:0] <= density_reg234; 
          end 
          234: begin 
               lut_Y_data_10[15:0] <= density_reg234; 
               lut_Y_data_11[15:0] <= density_reg235; 
          end 
          235: begin 
               lut_Y_data_10[15:0] <= density_reg235; 
               lut_Y_data_11[15:0] <= density_reg236; 
          end 
          236: begin 
               lut_Y_data_10[15:0] <= density_reg236; 
               lut_Y_data_11[15:0] <= density_reg237; 
          end 
          237: begin 
               lut_Y_data_10[15:0] <= density_reg237; 
               lut_Y_data_11[15:0] <= density_reg238; 
          end 
          238: begin 
               lut_Y_data_10[15:0] <= density_reg238; 
               lut_Y_data_11[15:0] <= density_reg239; 
          end 
          239: begin 
               lut_Y_data_10[15:0] <= density_reg239; 
               lut_Y_data_11[15:0] <= density_reg240; 
          end 
          240: begin 
               lut_Y_data_10[15:0] <= density_reg240; 
               lut_Y_data_11[15:0] <= density_reg241; 
          end 
          241: begin 
               lut_Y_data_10[15:0] <= density_reg241; 
               lut_Y_data_11[15:0] <= density_reg242; 
          end 
          242: begin 
               lut_Y_data_10[15:0] <= density_reg242; 
               lut_Y_data_11[15:0] <= density_reg243; 
          end 
          243: begin 
               lut_Y_data_10[15:0] <= density_reg243; 
               lut_Y_data_11[15:0] <= density_reg244; 
          end 
          244: begin 
               lut_Y_data_10[15:0] <= density_reg244; 
               lut_Y_data_11[15:0] <= density_reg245; 
          end 
          245: begin 
               lut_Y_data_10[15:0] <= density_reg245; 
               lut_Y_data_11[15:0] <= density_reg246; 
          end 
          246: begin 
               lut_Y_data_10[15:0] <= density_reg246; 
               lut_Y_data_11[15:0] <= density_reg247; 
          end 
          247: begin 
               lut_Y_data_10[15:0] <= density_reg247; 
               lut_Y_data_11[15:0] <= density_reg248; 
          end 
          248: begin 
               lut_Y_data_10[15:0] <= density_reg248; 
               lut_Y_data_11[15:0] <= density_reg249; 
          end 
          249: begin 
               lut_Y_data_10[15:0] <= density_reg249; 
               lut_Y_data_11[15:0] <= density_reg250; 
          end 
          250: begin 
               lut_Y_data_10[15:0] <= density_reg250; 
               lut_Y_data_11[15:0] <= density_reg251; 
          end 
          251: begin 
               lut_Y_data_10[15:0] <= density_reg251; 
               lut_Y_data_11[15:0] <= density_reg252; 
          end 
          252: begin 
               lut_Y_data_10[15:0] <= density_reg252; 
               lut_Y_data_11[15:0] <= density_reg253; 
          end 
          253: begin 
               lut_Y_data_10[15:0] <= density_reg253; 
               lut_Y_data_11[15:0] <= density_reg254; 
          end 
          254: begin 
               lut_Y_data_10[15:0] <= density_reg254; 
               lut_Y_data_11[15:0] <= density_reg255; 
          end 
          255: begin 
               lut_Y_data_10[15:0] <= density_reg255; 
               lut_Y_data_11[15:0] <= density_reg256; 
          end 
          256: begin 
               lut_Y_data_10[15:0] <= density_reg256; 
               lut_Y_data_11[15:0] <= density_reg256; 
          end 
          default: begin 
            lut_Y_data_10[15:0] <= density_reg0; 
            lut_Y_data_11[15:0] <= density_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_Y_data_20[15:0] <= {16{1'b0}};
     lut_Y_data_21[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & lut_Y_sel[2]) begin 
      if(dp2lut_Yinfo_2[16]) begin 
         lut_Y_data_20[15:0] <= density_reg0; 
         lut_Y_data_21[15:0] <= density_reg0; 
      end else if(dp2lut_Yinfo_2[17]) begin 
         lut_Y_data_20[15:0] <= density_reg256; 
         lut_Y_data_21[15:0] <= density_reg256; 
      end else begin 
        case(dp2lut_Y_entry_2[9:0]) 
          0: begin 
               lut_Y_data_20[15:0] <= density_reg0; 
               lut_Y_data_21[15:0] <= density_reg1; 
          end 
          1: begin 
               lut_Y_data_20[15:0] <= density_reg1; 
               lut_Y_data_21[15:0] <= density_reg2; 
          end 
          2: begin 
               lut_Y_data_20[15:0] <= density_reg2; 
               lut_Y_data_21[15:0] <= density_reg3; 
          end 
          3: begin 
               lut_Y_data_20[15:0] <= density_reg3; 
               lut_Y_data_21[15:0] <= density_reg4; 
          end 
          4: begin 
               lut_Y_data_20[15:0] <= density_reg4; 
               lut_Y_data_21[15:0] <= density_reg5; 
          end 
          5: begin 
               lut_Y_data_20[15:0] <= density_reg5; 
               lut_Y_data_21[15:0] <= density_reg6; 
          end 
          6: begin 
               lut_Y_data_20[15:0] <= density_reg6; 
               lut_Y_data_21[15:0] <= density_reg7; 
          end 
          7: begin 
               lut_Y_data_20[15:0] <= density_reg7; 
               lut_Y_data_21[15:0] <= density_reg8; 
          end 
          8: begin 
               lut_Y_data_20[15:0] <= density_reg8; 
               lut_Y_data_21[15:0] <= density_reg9; 
          end 
          9: begin 
               lut_Y_data_20[15:0] <= density_reg9; 
               lut_Y_data_21[15:0] <= density_reg10; 
          end 
          10: begin 
               lut_Y_data_20[15:0] <= density_reg10; 
               lut_Y_data_21[15:0] <= density_reg11; 
          end 
          11: begin 
               lut_Y_data_20[15:0] <= density_reg11; 
               lut_Y_data_21[15:0] <= density_reg12; 
          end 
          12: begin 
               lut_Y_data_20[15:0] <= density_reg12; 
               lut_Y_data_21[15:0] <= density_reg13; 
          end 
          13: begin 
               lut_Y_data_20[15:0] <= density_reg13; 
               lut_Y_data_21[15:0] <= density_reg14; 
          end 
          14: begin 
               lut_Y_data_20[15:0] <= density_reg14; 
               lut_Y_data_21[15:0] <= density_reg15; 
          end 
          15: begin 
               lut_Y_data_20[15:0] <= density_reg15; 
               lut_Y_data_21[15:0] <= density_reg16; 
          end 
          16: begin 
               lut_Y_data_20[15:0] <= density_reg16; 
               lut_Y_data_21[15:0] <= density_reg17; 
          end 
          17: begin 
               lut_Y_data_20[15:0] <= density_reg17; 
               lut_Y_data_21[15:0] <= density_reg18; 
          end 
          18: begin 
               lut_Y_data_20[15:0] <= density_reg18; 
               lut_Y_data_21[15:0] <= density_reg19; 
          end 
          19: begin 
               lut_Y_data_20[15:0] <= density_reg19; 
               lut_Y_data_21[15:0] <= density_reg20; 
          end 
          20: begin 
               lut_Y_data_20[15:0] <= density_reg20; 
               lut_Y_data_21[15:0] <= density_reg21; 
          end 
          21: begin 
               lut_Y_data_20[15:0] <= density_reg21; 
               lut_Y_data_21[15:0] <= density_reg22; 
          end 
          22: begin 
               lut_Y_data_20[15:0] <= density_reg22; 
               lut_Y_data_21[15:0] <= density_reg23; 
          end 
          23: begin 
               lut_Y_data_20[15:0] <= density_reg23; 
               lut_Y_data_21[15:0] <= density_reg24; 
          end 
          24: begin 
               lut_Y_data_20[15:0] <= density_reg24; 
               lut_Y_data_21[15:0] <= density_reg25; 
          end 
          25: begin 
               lut_Y_data_20[15:0] <= density_reg25; 
               lut_Y_data_21[15:0] <= density_reg26; 
          end 
          26: begin 
               lut_Y_data_20[15:0] <= density_reg26; 
               lut_Y_data_21[15:0] <= density_reg27; 
          end 
          27: begin 
               lut_Y_data_20[15:0] <= density_reg27; 
               lut_Y_data_21[15:0] <= density_reg28; 
          end 
          28: begin 
               lut_Y_data_20[15:0] <= density_reg28; 
               lut_Y_data_21[15:0] <= density_reg29; 
          end 
          29: begin 
               lut_Y_data_20[15:0] <= density_reg29; 
               lut_Y_data_21[15:0] <= density_reg30; 
          end 
          30: begin 
               lut_Y_data_20[15:0] <= density_reg30; 
               lut_Y_data_21[15:0] <= density_reg31; 
          end 
          31: begin 
               lut_Y_data_20[15:0] <= density_reg31; 
               lut_Y_data_21[15:0] <= density_reg32; 
          end 
          32: begin 
               lut_Y_data_20[15:0] <= density_reg32; 
               lut_Y_data_21[15:0] <= density_reg33; 
          end 
          33: begin 
               lut_Y_data_20[15:0] <= density_reg33; 
               lut_Y_data_21[15:0] <= density_reg34; 
          end 
          34: begin 
               lut_Y_data_20[15:0] <= density_reg34; 
               lut_Y_data_21[15:0] <= density_reg35; 
          end 
          35: begin 
               lut_Y_data_20[15:0] <= density_reg35; 
               lut_Y_data_21[15:0] <= density_reg36; 
          end 
          36: begin 
               lut_Y_data_20[15:0] <= density_reg36; 
               lut_Y_data_21[15:0] <= density_reg37; 
          end 
          37: begin 
               lut_Y_data_20[15:0] <= density_reg37; 
               lut_Y_data_21[15:0] <= density_reg38; 
          end 
          38: begin 
               lut_Y_data_20[15:0] <= density_reg38; 
               lut_Y_data_21[15:0] <= density_reg39; 
          end 
          39: begin 
               lut_Y_data_20[15:0] <= density_reg39; 
               lut_Y_data_21[15:0] <= density_reg40; 
          end 
          40: begin 
               lut_Y_data_20[15:0] <= density_reg40; 
               lut_Y_data_21[15:0] <= density_reg41; 
          end 
          41: begin 
               lut_Y_data_20[15:0] <= density_reg41; 
               lut_Y_data_21[15:0] <= density_reg42; 
          end 
          42: begin 
               lut_Y_data_20[15:0] <= density_reg42; 
               lut_Y_data_21[15:0] <= density_reg43; 
          end 
          43: begin 
               lut_Y_data_20[15:0] <= density_reg43; 
               lut_Y_data_21[15:0] <= density_reg44; 
          end 
          44: begin 
               lut_Y_data_20[15:0] <= density_reg44; 
               lut_Y_data_21[15:0] <= density_reg45; 
          end 
          45: begin 
               lut_Y_data_20[15:0] <= density_reg45; 
               lut_Y_data_21[15:0] <= density_reg46; 
          end 
          46: begin 
               lut_Y_data_20[15:0] <= density_reg46; 
               lut_Y_data_21[15:0] <= density_reg47; 
          end 
          47: begin 
               lut_Y_data_20[15:0] <= density_reg47; 
               lut_Y_data_21[15:0] <= density_reg48; 
          end 
          48: begin 
               lut_Y_data_20[15:0] <= density_reg48; 
               lut_Y_data_21[15:0] <= density_reg49; 
          end 
          49: begin 
               lut_Y_data_20[15:0] <= density_reg49; 
               lut_Y_data_21[15:0] <= density_reg50; 
          end 
          50: begin 
               lut_Y_data_20[15:0] <= density_reg50; 
               lut_Y_data_21[15:0] <= density_reg51; 
          end 
          51: begin 
               lut_Y_data_20[15:0] <= density_reg51; 
               lut_Y_data_21[15:0] <= density_reg52; 
          end 
          52: begin 
               lut_Y_data_20[15:0] <= density_reg52; 
               lut_Y_data_21[15:0] <= density_reg53; 
          end 
          53: begin 
               lut_Y_data_20[15:0] <= density_reg53; 
               lut_Y_data_21[15:0] <= density_reg54; 
          end 
          54: begin 
               lut_Y_data_20[15:0] <= density_reg54; 
               lut_Y_data_21[15:0] <= density_reg55; 
          end 
          55: begin 
               lut_Y_data_20[15:0] <= density_reg55; 
               lut_Y_data_21[15:0] <= density_reg56; 
          end 
          56: begin 
               lut_Y_data_20[15:0] <= density_reg56; 
               lut_Y_data_21[15:0] <= density_reg57; 
          end 
          57: begin 
               lut_Y_data_20[15:0] <= density_reg57; 
               lut_Y_data_21[15:0] <= density_reg58; 
          end 
          58: begin 
               lut_Y_data_20[15:0] <= density_reg58; 
               lut_Y_data_21[15:0] <= density_reg59; 
          end 
          59: begin 
               lut_Y_data_20[15:0] <= density_reg59; 
               lut_Y_data_21[15:0] <= density_reg60; 
          end 
          60: begin 
               lut_Y_data_20[15:0] <= density_reg60; 
               lut_Y_data_21[15:0] <= density_reg61; 
          end 
          61: begin 
               lut_Y_data_20[15:0] <= density_reg61; 
               lut_Y_data_21[15:0] <= density_reg62; 
          end 
          62: begin 
               lut_Y_data_20[15:0] <= density_reg62; 
               lut_Y_data_21[15:0] <= density_reg63; 
          end 
          63: begin 
               lut_Y_data_20[15:0] <= density_reg63; 
               lut_Y_data_21[15:0] <= density_reg64; 
          end 
          64: begin 
               lut_Y_data_20[15:0] <= density_reg64; 
               lut_Y_data_21[15:0] <= density_reg65; 
          end 
          65: begin 
               lut_Y_data_20[15:0] <= density_reg65; 
               lut_Y_data_21[15:0] <= density_reg66; 
          end 
          66: begin 
               lut_Y_data_20[15:0] <= density_reg66; 
               lut_Y_data_21[15:0] <= density_reg67; 
          end 
          67: begin 
               lut_Y_data_20[15:0] <= density_reg67; 
               lut_Y_data_21[15:0] <= density_reg68; 
          end 
          68: begin 
               lut_Y_data_20[15:0] <= density_reg68; 
               lut_Y_data_21[15:0] <= density_reg69; 
          end 
          69: begin 
               lut_Y_data_20[15:0] <= density_reg69; 
               lut_Y_data_21[15:0] <= density_reg70; 
          end 
          70: begin 
               lut_Y_data_20[15:0] <= density_reg70; 
               lut_Y_data_21[15:0] <= density_reg71; 
          end 
          71: begin 
               lut_Y_data_20[15:0] <= density_reg71; 
               lut_Y_data_21[15:0] <= density_reg72; 
          end 
          72: begin 
               lut_Y_data_20[15:0] <= density_reg72; 
               lut_Y_data_21[15:0] <= density_reg73; 
          end 
          73: begin 
               lut_Y_data_20[15:0] <= density_reg73; 
               lut_Y_data_21[15:0] <= density_reg74; 
          end 
          74: begin 
               lut_Y_data_20[15:0] <= density_reg74; 
               lut_Y_data_21[15:0] <= density_reg75; 
          end 
          75: begin 
               lut_Y_data_20[15:0] <= density_reg75; 
               lut_Y_data_21[15:0] <= density_reg76; 
          end 
          76: begin 
               lut_Y_data_20[15:0] <= density_reg76; 
               lut_Y_data_21[15:0] <= density_reg77; 
          end 
          77: begin 
               lut_Y_data_20[15:0] <= density_reg77; 
               lut_Y_data_21[15:0] <= density_reg78; 
          end 
          78: begin 
               lut_Y_data_20[15:0] <= density_reg78; 
               lut_Y_data_21[15:0] <= density_reg79; 
          end 
          79: begin 
               lut_Y_data_20[15:0] <= density_reg79; 
               lut_Y_data_21[15:0] <= density_reg80; 
          end 
          80: begin 
               lut_Y_data_20[15:0] <= density_reg80; 
               lut_Y_data_21[15:0] <= density_reg81; 
          end 
          81: begin 
               lut_Y_data_20[15:0] <= density_reg81; 
               lut_Y_data_21[15:0] <= density_reg82; 
          end 
          82: begin 
               lut_Y_data_20[15:0] <= density_reg82; 
               lut_Y_data_21[15:0] <= density_reg83; 
          end 
          83: begin 
               lut_Y_data_20[15:0] <= density_reg83; 
               lut_Y_data_21[15:0] <= density_reg84; 
          end 
          84: begin 
               lut_Y_data_20[15:0] <= density_reg84; 
               lut_Y_data_21[15:0] <= density_reg85; 
          end 
          85: begin 
               lut_Y_data_20[15:0] <= density_reg85; 
               lut_Y_data_21[15:0] <= density_reg86; 
          end 
          86: begin 
               lut_Y_data_20[15:0] <= density_reg86; 
               lut_Y_data_21[15:0] <= density_reg87; 
          end 
          87: begin 
               lut_Y_data_20[15:0] <= density_reg87; 
               lut_Y_data_21[15:0] <= density_reg88; 
          end 
          88: begin 
               lut_Y_data_20[15:0] <= density_reg88; 
               lut_Y_data_21[15:0] <= density_reg89; 
          end 
          89: begin 
               lut_Y_data_20[15:0] <= density_reg89; 
               lut_Y_data_21[15:0] <= density_reg90; 
          end 
          90: begin 
               lut_Y_data_20[15:0] <= density_reg90; 
               lut_Y_data_21[15:0] <= density_reg91; 
          end 
          91: begin 
               lut_Y_data_20[15:0] <= density_reg91; 
               lut_Y_data_21[15:0] <= density_reg92; 
          end 
          92: begin 
               lut_Y_data_20[15:0] <= density_reg92; 
               lut_Y_data_21[15:0] <= density_reg93; 
          end 
          93: begin 
               lut_Y_data_20[15:0] <= density_reg93; 
               lut_Y_data_21[15:0] <= density_reg94; 
          end 
          94: begin 
               lut_Y_data_20[15:0] <= density_reg94; 
               lut_Y_data_21[15:0] <= density_reg95; 
          end 
          95: begin 
               lut_Y_data_20[15:0] <= density_reg95; 
               lut_Y_data_21[15:0] <= density_reg96; 
          end 
          96: begin 
               lut_Y_data_20[15:0] <= density_reg96; 
               lut_Y_data_21[15:0] <= density_reg97; 
          end 
          97: begin 
               lut_Y_data_20[15:0] <= density_reg97; 
               lut_Y_data_21[15:0] <= density_reg98; 
          end 
          98: begin 
               lut_Y_data_20[15:0] <= density_reg98; 
               lut_Y_data_21[15:0] <= density_reg99; 
          end 
          99: begin 
               lut_Y_data_20[15:0] <= density_reg99; 
               lut_Y_data_21[15:0] <= density_reg100; 
          end 
          100: begin 
               lut_Y_data_20[15:0] <= density_reg100; 
               lut_Y_data_21[15:0] <= density_reg101; 
          end 
          101: begin 
               lut_Y_data_20[15:0] <= density_reg101; 
               lut_Y_data_21[15:0] <= density_reg102; 
          end 
          102: begin 
               lut_Y_data_20[15:0] <= density_reg102; 
               lut_Y_data_21[15:0] <= density_reg103; 
          end 
          103: begin 
               lut_Y_data_20[15:0] <= density_reg103; 
               lut_Y_data_21[15:0] <= density_reg104; 
          end 
          104: begin 
               lut_Y_data_20[15:0] <= density_reg104; 
               lut_Y_data_21[15:0] <= density_reg105; 
          end 
          105: begin 
               lut_Y_data_20[15:0] <= density_reg105; 
               lut_Y_data_21[15:0] <= density_reg106; 
          end 
          106: begin 
               lut_Y_data_20[15:0] <= density_reg106; 
               lut_Y_data_21[15:0] <= density_reg107; 
          end 
          107: begin 
               lut_Y_data_20[15:0] <= density_reg107; 
               lut_Y_data_21[15:0] <= density_reg108; 
          end 
          108: begin 
               lut_Y_data_20[15:0] <= density_reg108; 
               lut_Y_data_21[15:0] <= density_reg109; 
          end 
          109: begin 
               lut_Y_data_20[15:0] <= density_reg109; 
               lut_Y_data_21[15:0] <= density_reg110; 
          end 
          110: begin 
               lut_Y_data_20[15:0] <= density_reg110; 
               lut_Y_data_21[15:0] <= density_reg111; 
          end 
          111: begin 
               lut_Y_data_20[15:0] <= density_reg111; 
               lut_Y_data_21[15:0] <= density_reg112; 
          end 
          112: begin 
               lut_Y_data_20[15:0] <= density_reg112; 
               lut_Y_data_21[15:0] <= density_reg113; 
          end 
          113: begin 
               lut_Y_data_20[15:0] <= density_reg113; 
               lut_Y_data_21[15:0] <= density_reg114; 
          end 
          114: begin 
               lut_Y_data_20[15:0] <= density_reg114; 
               lut_Y_data_21[15:0] <= density_reg115; 
          end 
          115: begin 
               lut_Y_data_20[15:0] <= density_reg115; 
               lut_Y_data_21[15:0] <= density_reg116; 
          end 
          116: begin 
               lut_Y_data_20[15:0] <= density_reg116; 
               lut_Y_data_21[15:0] <= density_reg117; 
          end 
          117: begin 
               lut_Y_data_20[15:0] <= density_reg117; 
               lut_Y_data_21[15:0] <= density_reg118; 
          end 
          118: begin 
               lut_Y_data_20[15:0] <= density_reg118; 
               lut_Y_data_21[15:0] <= density_reg119; 
          end 
          119: begin 
               lut_Y_data_20[15:0] <= density_reg119; 
               lut_Y_data_21[15:0] <= density_reg120; 
          end 
          120: begin 
               lut_Y_data_20[15:0] <= density_reg120; 
               lut_Y_data_21[15:0] <= density_reg121; 
          end 
          121: begin 
               lut_Y_data_20[15:0] <= density_reg121; 
               lut_Y_data_21[15:0] <= density_reg122; 
          end 
          122: begin 
               lut_Y_data_20[15:0] <= density_reg122; 
               lut_Y_data_21[15:0] <= density_reg123; 
          end 
          123: begin 
               lut_Y_data_20[15:0] <= density_reg123; 
               lut_Y_data_21[15:0] <= density_reg124; 
          end 
          124: begin 
               lut_Y_data_20[15:0] <= density_reg124; 
               lut_Y_data_21[15:0] <= density_reg125; 
          end 
          125: begin 
               lut_Y_data_20[15:0] <= density_reg125; 
               lut_Y_data_21[15:0] <= density_reg126; 
          end 
          126: begin 
               lut_Y_data_20[15:0] <= density_reg126; 
               lut_Y_data_21[15:0] <= density_reg127; 
          end 
          127: begin 
               lut_Y_data_20[15:0] <= density_reg127; 
               lut_Y_data_21[15:0] <= density_reg128; 
          end 
          128: begin 
               lut_Y_data_20[15:0] <= density_reg128; 
               lut_Y_data_21[15:0] <= density_reg129; 
          end 
          129: begin 
               lut_Y_data_20[15:0] <= density_reg129; 
               lut_Y_data_21[15:0] <= density_reg130; 
          end 
          130: begin 
               lut_Y_data_20[15:0] <= density_reg130; 
               lut_Y_data_21[15:0] <= density_reg131; 
          end 
          131: begin 
               lut_Y_data_20[15:0] <= density_reg131; 
               lut_Y_data_21[15:0] <= density_reg132; 
          end 
          132: begin 
               lut_Y_data_20[15:0] <= density_reg132; 
               lut_Y_data_21[15:0] <= density_reg133; 
          end 
          133: begin 
               lut_Y_data_20[15:0] <= density_reg133; 
               lut_Y_data_21[15:0] <= density_reg134; 
          end 
          134: begin 
               lut_Y_data_20[15:0] <= density_reg134; 
               lut_Y_data_21[15:0] <= density_reg135; 
          end 
          135: begin 
               lut_Y_data_20[15:0] <= density_reg135; 
               lut_Y_data_21[15:0] <= density_reg136; 
          end 
          136: begin 
               lut_Y_data_20[15:0] <= density_reg136; 
               lut_Y_data_21[15:0] <= density_reg137; 
          end 
          137: begin 
               lut_Y_data_20[15:0] <= density_reg137; 
               lut_Y_data_21[15:0] <= density_reg138; 
          end 
          138: begin 
               lut_Y_data_20[15:0] <= density_reg138; 
               lut_Y_data_21[15:0] <= density_reg139; 
          end 
          139: begin 
               lut_Y_data_20[15:0] <= density_reg139; 
               lut_Y_data_21[15:0] <= density_reg140; 
          end 
          140: begin 
               lut_Y_data_20[15:0] <= density_reg140; 
               lut_Y_data_21[15:0] <= density_reg141; 
          end 
          141: begin 
               lut_Y_data_20[15:0] <= density_reg141; 
               lut_Y_data_21[15:0] <= density_reg142; 
          end 
          142: begin 
               lut_Y_data_20[15:0] <= density_reg142; 
               lut_Y_data_21[15:0] <= density_reg143; 
          end 
          143: begin 
               lut_Y_data_20[15:0] <= density_reg143; 
               lut_Y_data_21[15:0] <= density_reg144; 
          end 
          144: begin 
               lut_Y_data_20[15:0] <= density_reg144; 
               lut_Y_data_21[15:0] <= density_reg145; 
          end 
          145: begin 
               lut_Y_data_20[15:0] <= density_reg145; 
               lut_Y_data_21[15:0] <= density_reg146; 
          end 
          146: begin 
               lut_Y_data_20[15:0] <= density_reg146; 
               lut_Y_data_21[15:0] <= density_reg147; 
          end 
          147: begin 
               lut_Y_data_20[15:0] <= density_reg147; 
               lut_Y_data_21[15:0] <= density_reg148; 
          end 
          148: begin 
               lut_Y_data_20[15:0] <= density_reg148; 
               lut_Y_data_21[15:0] <= density_reg149; 
          end 
          149: begin 
               lut_Y_data_20[15:0] <= density_reg149; 
               lut_Y_data_21[15:0] <= density_reg150; 
          end 
          150: begin 
               lut_Y_data_20[15:0] <= density_reg150; 
               lut_Y_data_21[15:0] <= density_reg151; 
          end 
          151: begin 
               lut_Y_data_20[15:0] <= density_reg151; 
               lut_Y_data_21[15:0] <= density_reg152; 
          end 
          152: begin 
               lut_Y_data_20[15:0] <= density_reg152; 
               lut_Y_data_21[15:0] <= density_reg153; 
          end 
          153: begin 
               lut_Y_data_20[15:0] <= density_reg153; 
               lut_Y_data_21[15:0] <= density_reg154; 
          end 
          154: begin 
               lut_Y_data_20[15:0] <= density_reg154; 
               lut_Y_data_21[15:0] <= density_reg155; 
          end 
          155: begin 
               lut_Y_data_20[15:0] <= density_reg155; 
               lut_Y_data_21[15:0] <= density_reg156; 
          end 
          156: begin 
               lut_Y_data_20[15:0] <= density_reg156; 
               lut_Y_data_21[15:0] <= density_reg157; 
          end 
          157: begin 
               lut_Y_data_20[15:0] <= density_reg157; 
               lut_Y_data_21[15:0] <= density_reg158; 
          end 
          158: begin 
               lut_Y_data_20[15:0] <= density_reg158; 
               lut_Y_data_21[15:0] <= density_reg159; 
          end 
          159: begin 
               lut_Y_data_20[15:0] <= density_reg159; 
               lut_Y_data_21[15:0] <= density_reg160; 
          end 
          160: begin 
               lut_Y_data_20[15:0] <= density_reg160; 
               lut_Y_data_21[15:0] <= density_reg161; 
          end 
          161: begin 
               lut_Y_data_20[15:0] <= density_reg161; 
               lut_Y_data_21[15:0] <= density_reg162; 
          end 
          162: begin 
               lut_Y_data_20[15:0] <= density_reg162; 
               lut_Y_data_21[15:0] <= density_reg163; 
          end 
          163: begin 
               lut_Y_data_20[15:0] <= density_reg163; 
               lut_Y_data_21[15:0] <= density_reg164; 
          end 
          164: begin 
               lut_Y_data_20[15:0] <= density_reg164; 
               lut_Y_data_21[15:0] <= density_reg165; 
          end 
          165: begin 
               lut_Y_data_20[15:0] <= density_reg165; 
               lut_Y_data_21[15:0] <= density_reg166; 
          end 
          166: begin 
               lut_Y_data_20[15:0] <= density_reg166; 
               lut_Y_data_21[15:0] <= density_reg167; 
          end 
          167: begin 
               lut_Y_data_20[15:0] <= density_reg167; 
               lut_Y_data_21[15:0] <= density_reg168; 
          end 
          168: begin 
               lut_Y_data_20[15:0] <= density_reg168; 
               lut_Y_data_21[15:0] <= density_reg169; 
          end 
          169: begin 
               lut_Y_data_20[15:0] <= density_reg169; 
               lut_Y_data_21[15:0] <= density_reg170; 
          end 
          170: begin 
               lut_Y_data_20[15:0] <= density_reg170; 
               lut_Y_data_21[15:0] <= density_reg171; 
          end 
          171: begin 
               lut_Y_data_20[15:0] <= density_reg171; 
               lut_Y_data_21[15:0] <= density_reg172; 
          end 
          172: begin 
               lut_Y_data_20[15:0] <= density_reg172; 
               lut_Y_data_21[15:0] <= density_reg173; 
          end 
          173: begin 
               lut_Y_data_20[15:0] <= density_reg173; 
               lut_Y_data_21[15:0] <= density_reg174; 
          end 
          174: begin 
               lut_Y_data_20[15:0] <= density_reg174; 
               lut_Y_data_21[15:0] <= density_reg175; 
          end 
          175: begin 
               lut_Y_data_20[15:0] <= density_reg175; 
               lut_Y_data_21[15:0] <= density_reg176; 
          end 
          176: begin 
               lut_Y_data_20[15:0] <= density_reg176; 
               lut_Y_data_21[15:0] <= density_reg177; 
          end 
          177: begin 
               lut_Y_data_20[15:0] <= density_reg177; 
               lut_Y_data_21[15:0] <= density_reg178; 
          end 
          178: begin 
               lut_Y_data_20[15:0] <= density_reg178; 
               lut_Y_data_21[15:0] <= density_reg179; 
          end 
          179: begin 
               lut_Y_data_20[15:0] <= density_reg179; 
               lut_Y_data_21[15:0] <= density_reg180; 
          end 
          180: begin 
               lut_Y_data_20[15:0] <= density_reg180; 
               lut_Y_data_21[15:0] <= density_reg181; 
          end 
          181: begin 
               lut_Y_data_20[15:0] <= density_reg181; 
               lut_Y_data_21[15:0] <= density_reg182; 
          end 
          182: begin 
               lut_Y_data_20[15:0] <= density_reg182; 
               lut_Y_data_21[15:0] <= density_reg183; 
          end 
          183: begin 
               lut_Y_data_20[15:0] <= density_reg183; 
               lut_Y_data_21[15:0] <= density_reg184; 
          end 
          184: begin 
               lut_Y_data_20[15:0] <= density_reg184; 
               lut_Y_data_21[15:0] <= density_reg185; 
          end 
          185: begin 
               lut_Y_data_20[15:0] <= density_reg185; 
               lut_Y_data_21[15:0] <= density_reg186; 
          end 
          186: begin 
               lut_Y_data_20[15:0] <= density_reg186; 
               lut_Y_data_21[15:0] <= density_reg187; 
          end 
          187: begin 
               lut_Y_data_20[15:0] <= density_reg187; 
               lut_Y_data_21[15:0] <= density_reg188; 
          end 
          188: begin 
               lut_Y_data_20[15:0] <= density_reg188; 
               lut_Y_data_21[15:0] <= density_reg189; 
          end 
          189: begin 
               lut_Y_data_20[15:0] <= density_reg189; 
               lut_Y_data_21[15:0] <= density_reg190; 
          end 
          190: begin 
               lut_Y_data_20[15:0] <= density_reg190; 
               lut_Y_data_21[15:0] <= density_reg191; 
          end 
          191: begin 
               lut_Y_data_20[15:0] <= density_reg191; 
               lut_Y_data_21[15:0] <= density_reg192; 
          end 
          192: begin 
               lut_Y_data_20[15:0] <= density_reg192; 
               lut_Y_data_21[15:0] <= density_reg193; 
          end 
          193: begin 
               lut_Y_data_20[15:0] <= density_reg193; 
               lut_Y_data_21[15:0] <= density_reg194; 
          end 
          194: begin 
               lut_Y_data_20[15:0] <= density_reg194; 
               lut_Y_data_21[15:0] <= density_reg195; 
          end 
          195: begin 
               lut_Y_data_20[15:0] <= density_reg195; 
               lut_Y_data_21[15:0] <= density_reg196; 
          end 
          196: begin 
               lut_Y_data_20[15:0] <= density_reg196; 
               lut_Y_data_21[15:0] <= density_reg197; 
          end 
          197: begin 
               lut_Y_data_20[15:0] <= density_reg197; 
               lut_Y_data_21[15:0] <= density_reg198; 
          end 
          198: begin 
               lut_Y_data_20[15:0] <= density_reg198; 
               lut_Y_data_21[15:0] <= density_reg199; 
          end 
          199: begin 
               lut_Y_data_20[15:0] <= density_reg199; 
               lut_Y_data_21[15:0] <= density_reg200; 
          end 
          200: begin 
               lut_Y_data_20[15:0] <= density_reg200; 
               lut_Y_data_21[15:0] <= density_reg201; 
          end 
          201: begin 
               lut_Y_data_20[15:0] <= density_reg201; 
               lut_Y_data_21[15:0] <= density_reg202; 
          end 
          202: begin 
               lut_Y_data_20[15:0] <= density_reg202; 
               lut_Y_data_21[15:0] <= density_reg203; 
          end 
          203: begin 
               lut_Y_data_20[15:0] <= density_reg203; 
               lut_Y_data_21[15:0] <= density_reg204; 
          end 
          204: begin 
               lut_Y_data_20[15:0] <= density_reg204; 
               lut_Y_data_21[15:0] <= density_reg205; 
          end 
          205: begin 
               lut_Y_data_20[15:0] <= density_reg205; 
               lut_Y_data_21[15:0] <= density_reg206; 
          end 
          206: begin 
               lut_Y_data_20[15:0] <= density_reg206; 
               lut_Y_data_21[15:0] <= density_reg207; 
          end 
          207: begin 
               lut_Y_data_20[15:0] <= density_reg207; 
               lut_Y_data_21[15:0] <= density_reg208; 
          end 
          208: begin 
               lut_Y_data_20[15:0] <= density_reg208; 
               lut_Y_data_21[15:0] <= density_reg209; 
          end 
          209: begin 
               lut_Y_data_20[15:0] <= density_reg209; 
               lut_Y_data_21[15:0] <= density_reg210; 
          end 
          210: begin 
               lut_Y_data_20[15:0] <= density_reg210; 
               lut_Y_data_21[15:0] <= density_reg211; 
          end 
          211: begin 
               lut_Y_data_20[15:0] <= density_reg211; 
               lut_Y_data_21[15:0] <= density_reg212; 
          end 
          212: begin 
               lut_Y_data_20[15:0] <= density_reg212; 
               lut_Y_data_21[15:0] <= density_reg213; 
          end 
          213: begin 
               lut_Y_data_20[15:0] <= density_reg213; 
               lut_Y_data_21[15:0] <= density_reg214; 
          end 
          214: begin 
               lut_Y_data_20[15:0] <= density_reg214; 
               lut_Y_data_21[15:0] <= density_reg215; 
          end 
          215: begin 
               lut_Y_data_20[15:0] <= density_reg215; 
               lut_Y_data_21[15:0] <= density_reg216; 
          end 
          216: begin 
               lut_Y_data_20[15:0] <= density_reg216; 
               lut_Y_data_21[15:0] <= density_reg217; 
          end 
          217: begin 
               lut_Y_data_20[15:0] <= density_reg217; 
               lut_Y_data_21[15:0] <= density_reg218; 
          end 
          218: begin 
               lut_Y_data_20[15:0] <= density_reg218; 
               lut_Y_data_21[15:0] <= density_reg219; 
          end 
          219: begin 
               lut_Y_data_20[15:0] <= density_reg219; 
               lut_Y_data_21[15:0] <= density_reg220; 
          end 
          220: begin 
               lut_Y_data_20[15:0] <= density_reg220; 
               lut_Y_data_21[15:0] <= density_reg221; 
          end 
          221: begin 
               lut_Y_data_20[15:0] <= density_reg221; 
               lut_Y_data_21[15:0] <= density_reg222; 
          end 
          222: begin 
               lut_Y_data_20[15:0] <= density_reg222; 
               lut_Y_data_21[15:0] <= density_reg223; 
          end 
          223: begin 
               lut_Y_data_20[15:0] <= density_reg223; 
               lut_Y_data_21[15:0] <= density_reg224; 
          end 
          224: begin 
               lut_Y_data_20[15:0] <= density_reg224; 
               lut_Y_data_21[15:0] <= density_reg225; 
          end 
          225: begin 
               lut_Y_data_20[15:0] <= density_reg225; 
               lut_Y_data_21[15:0] <= density_reg226; 
          end 
          226: begin 
               lut_Y_data_20[15:0] <= density_reg226; 
               lut_Y_data_21[15:0] <= density_reg227; 
          end 
          227: begin 
               lut_Y_data_20[15:0] <= density_reg227; 
               lut_Y_data_21[15:0] <= density_reg228; 
          end 
          228: begin 
               lut_Y_data_20[15:0] <= density_reg228; 
               lut_Y_data_21[15:0] <= density_reg229; 
          end 
          229: begin 
               lut_Y_data_20[15:0] <= density_reg229; 
               lut_Y_data_21[15:0] <= density_reg230; 
          end 
          230: begin 
               lut_Y_data_20[15:0] <= density_reg230; 
               lut_Y_data_21[15:0] <= density_reg231; 
          end 
          231: begin 
               lut_Y_data_20[15:0] <= density_reg231; 
               lut_Y_data_21[15:0] <= density_reg232; 
          end 
          232: begin 
               lut_Y_data_20[15:0] <= density_reg232; 
               lut_Y_data_21[15:0] <= density_reg233; 
          end 
          233: begin 
               lut_Y_data_20[15:0] <= density_reg233; 
               lut_Y_data_21[15:0] <= density_reg234; 
          end 
          234: begin 
               lut_Y_data_20[15:0] <= density_reg234; 
               lut_Y_data_21[15:0] <= density_reg235; 
          end 
          235: begin 
               lut_Y_data_20[15:0] <= density_reg235; 
               lut_Y_data_21[15:0] <= density_reg236; 
          end 
          236: begin 
               lut_Y_data_20[15:0] <= density_reg236; 
               lut_Y_data_21[15:0] <= density_reg237; 
          end 
          237: begin 
               lut_Y_data_20[15:0] <= density_reg237; 
               lut_Y_data_21[15:0] <= density_reg238; 
          end 
          238: begin 
               lut_Y_data_20[15:0] <= density_reg238; 
               lut_Y_data_21[15:0] <= density_reg239; 
          end 
          239: begin 
               lut_Y_data_20[15:0] <= density_reg239; 
               lut_Y_data_21[15:0] <= density_reg240; 
          end 
          240: begin 
               lut_Y_data_20[15:0] <= density_reg240; 
               lut_Y_data_21[15:0] <= density_reg241; 
          end 
          241: begin 
               lut_Y_data_20[15:0] <= density_reg241; 
               lut_Y_data_21[15:0] <= density_reg242; 
          end 
          242: begin 
               lut_Y_data_20[15:0] <= density_reg242; 
               lut_Y_data_21[15:0] <= density_reg243; 
          end 
          243: begin 
               lut_Y_data_20[15:0] <= density_reg243; 
               lut_Y_data_21[15:0] <= density_reg244; 
          end 
          244: begin 
               lut_Y_data_20[15:0] <= density_reg244; 
               lut_Y_data_21[15:0] <= density_reg245; 
          end 
          245: begin 
               lut_Y_data_20[15:0] <= density_reg245; 
               lut_Y_data_21[15:0] <= density_reg246; 
          end 
          246: begin 
               lut_Y_data_20[15:0] <= density_reg246; 
               lut_Y_data_21[15:0] <= density_reg247; 
          end 
          247: begin 
               lut_Y_data_20[15:0] <= density_reg247; 
               lut_Y_data_21[15:0] <= density_reg248; 
          end 
          248: begin 
               lut_Y_data_20[15:0] <= density_reg248; 
               lut_Y_data_21[15:0] <= density_reg249; 
          end 
          249: begin 
               lut_Y_data_20[15:0] <= density_reg249; 
               lut_Y_data_21[15:0] <= density_reg250; 
          end 
          250: begin 
               lut_Y_data_20[15:0] <= density_reg250; 
               lut_Y_data_21[15:0] <= density_reg251; 
          end 
          251: begin 
               lut_Y_data_20[15:0] <= density_reg251; 
               lut_Y_data_21[15:0] <= density_reg252; 
          end 
          252: begin 
               lut_Y_data_20[15:0] <= density_reg252; 
               lut_Y_data_21[15:0] <= density_reg253; 
          end 
          253: begin 
               lut_Y_data_20[15:0] <= density_reg253; 
               lut_Y_data_21[15:0] <= density_reg254; 
          end 
          254: begin 
               lut_Y_data_20[15:0] <= density_reg254; 
               lut_Y_data_21[15:0] <= density_reg255; 
          end 
          255: begin 
               lut_Y_data_20[15:0] <= density_reg255; 
               lut_Y_data_21[15:0] <= density_reg256; 
          end 
          256: begin 
               lut_Y_data_20[15:0] <= density_reg256; 
               lut_Y_data_21[15:0] <= density_reg256; 
          end 
          default: begin 
            lut_Y_data_20[15:0] <= density_reg0; 
            lut_Y_data_21[15:0] <= density_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_Y_data_30[15:0] <= {16{1'b0}};
     lut_Y_data_31[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & lut_Y_sel[3]) begin 
      if(dp2lut_Yinfo_3[16]) begin 
         lut_Y_data_30[15:0] <= density_reg0; 
         lut_Y_data_31[15:0] <= density_reg0; 
      end else if(dp2lut_Yinfo_3[17]) begin 
         lut_Y_data_30[15:0] <= density_reg256; 
         lut_Y_data_31[15:0] <= density_reg256; 
      end else begin 
        case(dp2lut_Y_entry_3[9:0]) 
          0: begin 
               lut_Y_data_30[15:0] <= density_reg0; 
               lut_Y_data_31[15:0] <= density_reg1; 
          end 
          1: begin 
               lut_Y_data_30[15:0] <= density_reg1; 
               lut_Y_data_31[15:0] <= density_reg2; 
          end 
          2: begin 
               lut_Y_data_30[15:0] <= density_reg2; 
               lut_Y_data_31[15:0] <= density_reg3; 
          end 
          3: begin 
               lut_Y_data_30[15:0] <= density_reg3; 
               lut_Y_data_31[15:0] <= density_reg4; 
          end 
          4: begin 
               lut_Y_data_30[15:0] <= density_reg4; 
               lut_Y_data_31[15:0] <= density_reg5; 
          end 
          5: begin 
               lut_Y_data_30[15:0] <= density_reg5; 
               lut_Y_data_31[15:0] <= density_reg6; 
          end 
          6: begin 
               lut_Y_data_30[15:0] <= density_reg6; 
               lut_Y_data_31[15:0] <= density_reg7; 
          end 
          7: begin 
               lut_Y_data_30[15:0] <= density_reg7; 
               lut_Y_data_31[15:0] <= density_reg8; 
          end 
          8: begin 
               lut_Y_data_30[15:0] <= density_reg8; 
               lut_Y_data_31[15:0] <= density_reg9; 
          end 
          9: begin 
               lut_Y_data_30[15:0] <= density_reg9; 
               lut_Y_data_31[15:0] <= density_reg10; 
          end 
          10: begin 
               lut_Y_data_30[15:0] <= density_reg10; 
               lut_Y_data_31[15:0] <= density_reg11; 
          end 
          11: begin 
               lut_Y_data_30[15:0] <= density_reg11; 
               lut_Y_data_31[15:0] <= density_reg12; 
          end 
          12: begin 
               lut_Y_data_30[15:0] <= density_reg12; 
               lut_Y_data_31[15:0] <= density_reg13; 
          end 
          13: begin 
               lut_Y_data_30[15:0] <= density_reg13; 
               lut_Y_data_31[15:0] <= density_reg14; 
          end 
          14: begin 
               lut_Y_data_30[15:0] <= density_reg14; 
               lut_Y_data_31[15:0] <= density_reg15; 
          end 
          15: begin 
               lut_Y_data_30[15:0] <= density_reg15; 
               lut_Y_data_31[15:0] <= density_reg16; 
          end 
          16: begin 
               lut_Y_data_30[15:0] <= density_reg16; 
               lut_Y_data_31[15:0] <= density_reg17; 
          end 
          17: begin 
               lut_Y_data_30[15:0] <= density_reg17; 
               lut_Y_data_31[15:0] <= density_reg18; 
          end 
          18: begin 
               lut_Y_data_30[15:0] <= density_reg18; 
               lut_Y_data_31[15:0] <= density_reg19; 
          end 
          19: begin 
               lut_Y_data_30[15:0] <= density_reg19; 
               lut_Y_data_31[15:0] <= density_reg20; 
          end 
          20: begin 
               lut_Y_data_30[15:0] <= density_reg20; 
               lut_Y_data_31[15:0] <= density_reg21; 
          end 
          21: begin 
               lut_Y_data_30[15:0] <= density_reg21; 
               lut_Y_data_31[15:0] <= density_reg22; 
          end 
          22: begin 
               lut_Y_data_30[15:0] <= density_reg22; 
               lut_Y_data_31[15:0] <= density_reg23; 
          end 
          23: begin 
               lut_Y_data_30[15:0] <= density_reg23; 
               lut_Y_data_31[15:0] <= density_reg24; 
          end 
          24: begin 
               lut_Y_data_30[15:0] <= density_reg24; 
               lut_Y_data_31[15:0] <= density_reg25; 
          end 
          25: begin 
               lut_Y_data_30[15:0] <= density_reg25; 
               lut_Y_data_31[15:0] <= density_reg26; 
          end 
          26: begin 
               lut_Y_data_30[15:0] <= density_reg26; 
               lut_Y_data_31[15:0] <= density_reg27; 
          end 
          27: begin 
               lut_Y_data_30[15:0] <= density_reg27; 
               lut_Y_data_31[15:0] <= density_reg28; 
          end 
          28: begin 
               lut_Y_data_30[15:0] <= density_reg28; 
               lut_Y_data_31[15:0] <= density_reg29; 
          end 
          29: begin 
               lut_Y_data_30[15:0] <= density_reg29; 
               lut_Y_data_31[15:0] <= density_reg30; 
          end 
          30: begin 
               lut_Y_data_30[15:0] <= density_reg30; 
               lut_Y_data_31[15:0] <= density_reg31; 
          end 
          31: begin 
               lut_Y_data_30[15:0] <= density_reg31; 
               lut_Y_data_31[15:0] <= density_reg32; 
          end 
          32: begin 
               lut_Y_data_30[15:0] <= density_reg32; 
               lut_Y_data_31[15:0] <= density_reg33; 
          end 
          33: begin 
               lut_Y_data_30[15:0] <= density_reg33; 
               lut_Y_data_31[15:0] <= density_reg34; 
          end 
          34: begin 
               lut_Y_data_30[15:0] <= density_reg34; 
               lut_Y_data_31[15:0] <= density_reg35; 
          end 
          35: begin 
               lut_Y_data_30[15:0] <= density_reg35; 
               lut_Y_data_31[15:0] <= density_reg36; 
          end 
          36: begin 
               lut_Y_data_30[15:0] <= density_reg36; 
               lut_Y_data_31[15:0] <= density_reg37; 
          end 
          37: begin 
               lut_Y_data_30[15:0] <= density_reg37; 
               lut_Y_data_31[15:0] <= density_reg38; 
          end 
          38: begin 
               lut_Y_data_30[15:0] <= density_reg38; 
               lut_Y_data_31[15:0] <= density_reg39; 
          end 
          39: begin 
               lut_Y_data_30[15:0] <= density_reg39; 
               lut_Y_data_31[15:0] <= density_reg40; 
          end 
          40: begin 
               lut_Y_data_30[15:0] <= density_reg40; 
               lut_Y_data_31[15:0] <= density_reg41; 
          end 
          41: begin 
               lut_Y_data_30[15:0] <= density_reg41; 
               lut_Y_data_31[15:0] <= density_reg42; 
          end 
          42: begin 
               lut_Y_data_30[15:0] <= density_reg42; 
               lut_Y_data_31[15:0] <= density_reg43; 
          end 
          43: begin 
               lut_Y_data_30[15:0] <= density_reg43; 
               lut_Y_data_31[15:0] <= density_reg44; 
          end 
          44: begin 
               lut_Y_data_30[15:0] <= density_reg44; 
               lut_Y_data_31[15:0] <= density_reg45; 
          end 
          45: begin 
               lut_Y_data_30[15:0] <= density_reg45; 
               lut_Y_data_31[15:0] <= density_reg46; 
          end 
          46: begin 
               lut_Y_data_30[15:0] <= density_reg46; 
               lut_Y_data_31[15:0] <= density_reg47; 
          end 
          47: begin 
               lut_Y_data_30[15:0] <= density_reg47; 
               lut_Y_data_31[15:0] <= density_reg48; 
          end 
          48: begin 
               lut_Y_data_30[15:0] <= density_reg48; 
               lut_Y_data_31[15:0] <= density_reg49; 
          end 
          49: begin 
               lut_Y_data_30[15:0] <= density_reg49; 
               lut_Y_data_31[15:0] <= density_reg50; 
          end 
          50: begin 
               lut_Y_data_30[15:0] <= density_reg50; 
               lut_Y_data_31[15:0] <= density_reg51; 
          end 
          51: begin 
               lut_Y_data_30[15:0] <= density_reg51; 
               lut_Y_data_31[15:0] <= density_reg52; 
          end 
          52: begin 
               lut_Y_data_30[15:0] <= density_reg52; 
               lut_Y_data_31[15:0] <= density_reg53; 
          end 
          53: begin 
               lut_Y_data_30[15:0] <= density_reg53; 
               lut_Y_data_31[15:0] <= density_reg54; 
          end 
          54: begin 
               lut_Y_data_30[15:0] <= density_reg54; 
               lut_Y_data_31[15:0] <= density_reg55; 
          end 
          55: begin 
               lut_Y_data_30[15:0] <= density_reg55; 
               lut_Y_data_31[15:0] <= density_reg56; 
          end 
          56: begin 
               lut_Y_data_30[15:0] <= density_reg56; 
               lut_Y_data_31[15:0] <= density_reg57; 
          end 
          57: begin 
               lut_Y_data_30[15:0] <= density_reg57; 
               lut_Y_data_31[15:0] <= density_reg58; 
          end 
          58: begin 
               lut_Y_data_30[15:0] <= density_reg58; 
               lut_Y_data_31[15:0] <= density_reg59; 
          end 
          59: begin 
               lut_Y_data_30[15:0] <= density_reg59; 
               lut_Y_data_31[15:0] <= density_reg60; 
          end 
          60: begin 
               lut_Y_data_30[15:0] <= density_reg60; 
               lut_Y_data_31[15:0] <= density_reg61; 
          end 
          61: begin 
               lut_Y_data_30[15:0] <= density_reg61; 
               lut_Y_data_31[15:0] <= density_reg62; 
          end 
          62: begin 
               lut_Y_data_30[15:0] <= density_reg62; 
               lut_Y_data_31[15:0] <= density_reg63; 
          end 
          63: begin 
               lut_Y_data_30[15:0] <= density_reg63; 
               lut_Y_data_31[15:0] <= density_reg64; 
          end 
          64: begin 
               lut_Y_data_30[15:0] <= density_reg64; 
               lut_Y_data_31[15:0] <= density_reg65; 
          end 
          65: begin 
               lut_Y_data_30[15:0] <= density_reg65; 
               lut_Y_data_31[15:0] <= density_reg66; 
          end 
          66: begin 
               lut_Y_data_30[15:0] <= density_reg66; 
               lut_Y_data_31[15:0] <= density_reg67; 
          end 
          67: begin 
               lut_Y_data_30[15:0] <= density_reg67; 
               lut_Y_data_31[15:0] <= density_reg68; 
          end 
          68: begin 
               lut_Y_data_30[15:0] <= density_reg68; 
               lut_Y_data_31[15:0] <= density_reg69; 
          end 
          69: begin 
               lut_Y_data_30[15:0] <= density_reg69; 
               lut_Y_data_31[15:0] <= density_reg70; 
          end 
          70: begin 
               lut_Y_data_30[15:0] <= density_reg70; 
               lut_Y_data_31[15:0] <= density_reg71; 
          end 
          71: begin 
               lut_Y_data_30[15:0] <= density_reg71; 
               lut_Y_data_31[15:0] <= density_reg72; 
          end 
          72: begin 
               lut_Y_data_30[15:0] <= density_reg72; 
               lut_Y_data_31[15:0] <= density_reg73; 
          end 
          73: begin 
               lut_Y_data_30[15:0] <= density_reg73; 
               lut_Y_data_31[15:0] <= density_reg74; 
          end 
          74: begin 
               lut_Y_data_30[15:0] <= density_reg74; 
               lut_Y_data_31[15:0] <= density_reg75; 
          end 
          75: begin 
               lut_Y_data_30[15:0] <= density_reg75; 
               lut_Y_data_31[15:0] <= density_reg76; 
          end 
          76: begin 
               lut_Y_data_30[15:0] <= density_reg76; 
               lut_Y_data_31[15:0] <= density_reg77; 
          end 
          77: begin 
               lut_Y_data_30[15:0] <= density_reg77; 
               lut_Y_data_31[15:0] <= density_reg78; 
          end 
          78: begin 
               lut_Y_data_30[15:0] <= density_reg78; 
               lut_Y_data_31[15:0] <= density_reg79; 
          end 
          79: begin 
               lut_Y_data_30[15:0] <= density_reg79; 
               lut_Y_data_31[15:0] <= density_reg80; 
          end 
          80: begin 
               lut_Y_data_30[15:0] <= density_reg80; 
               lut_Y_data_31[15:0] <= density_reg81; 
          end 
          81: begin 
               lut_Y_data_30[15:0] <= density_reg81; 
               lut_Y_data_31[15:0] <= density_reg82; 
          end 
          82: begin 
               lut_Y_data_30[15:0] <= density_reg82; 
               lut_Y_data_31[15:0] <= density_reg83; 
          end 
          83: begin 
               lut_Y_data_30[15:0] <= density_reg83; 
               lut_Y_data_31[15:0] <= density_reg84; 
          end 
          84: begin 
               lut_Y_data_30[15:0] <= density_reg84; 
               lut_Y_data_31[15:0] <= density_reg85; 
          end 
          85: begin 
               lut_Y_data_30[15:0] <= density_reg85; 
               lut_Y_data_31[15:0] <= density_reg86; 
          end 
          86: begin 
               lut_Y_data_30[15:0] <= density_reg86; 
               lut_Y_data_31[15:0] <= density_reg87; 
          end 
          87: begin 
               lut_Y_data_30[15:0] <= density_reg87; 
               lut_Y_data_31[15:0] <= density_reg88; 
          end 
          88: begin 
               lut_Y_data_30[15:0] <= density_reg88; 
               lut_Y_data_31[15:0] <= density_reg89; 
          end 
          89: begin 
               lut_Y_data_30[15:0] <= density_reg89; 
               lut_Y_data_31[15:0] <= density_reg90; 
          end 
          90: begin 
               lut_Y_data_30[15:0] <= density_reg90; 
               lut_Y_data_31[15:0] <= density_reg91; 
          end 
          91: begin 
               lut_Y_data_30[15:0] <= density_reg91; 
               lut_Y_data_31[15:0] <= density_reg92; 
          end 
          92: begin 
               lut_Y_data_30[15:0] <= density_reg92; 
               lut_Y_data_31[15:0] <= density_reg93; 
          end 
          93: begin 
               lut_Y_data_30[15:0] <= density_reg93; 
               lut_Y_data_31[15:0] <= density_reg94; 
          end 
          94: begin 
               lut_Y_data_30[15:0] <= density_reg94; 
               lut_Y_data_31[15:0] <= density_reg95; 
          end 
          95: begin 
               lut_Y_data_30[15:0] <= density_reg95; 
               lut_Y_data_31[15:0] <= density_reg96; 
          end 
          96: begin 
               lut_Y_data_30[15:0] <= density_reg96; 
               lut_Y_data_31[15:0] <= density_reg97; 
          end 
          97: begin 
               lut_Y_data_30[15:0] <= density_reg97; 
               lut_Y_data_31[15:0] <= density_reg98; 
          end 
          98: begin 
               lut_Y_data_30[15:0] <= density_reg98; 
               lut_Y_data_31[15:0] <= density_reg99; 
          end 
          99: begin 
               lut_Y_data_30[15:0] <= density_reg99; 
               lut_Y_data_31[15:0] <= density_reg100; 
          end 
          100: begin 
               lut_Y_data_30[15:0] <= density_reg100; 
               lut_Y_data_31[15:0] <= density_reg101; 
          end 
          101: begin 
               lut_Y_data_30[15:0] <= density_reg101; 
               lut_Y_data_31[15:0] <= density_reg102; 
          end 
          102: begin 
               lut_Y_data_30[15:0] <= density_reg102; 
               lut_Y_data_31[15:0] <= density_reg103; 
          end 
          103: begin 
               lut_Y_data_30[15:0] <= density_reg103; 
               lut_Y_data_31[15:0] <= density_reg104; 
          end 
          104: begin 
               lut_Y_data_30[15:0] <= density_reg104; 
               lut_Y_data_31[15:0] <= density_reg105; 
          end 
          105: begin 
               lut_Y_data_30[15:0] <= density_reg105; 
               lut_Y_data_31[15:0] <= density_reg106; 
          end 
          106: begin 
               lut_Y_data_30[15:0] <= density_reg106; 
               lut_Y_data_31[15:0] <= density_reg107; 
          end 
          107: begin 
               lut_Y_data_30[15:0] <= density_reg107; 
               lut_Y_data_31[15:0] <= density_reg108; 
          end 
          108: begin 
               lut_Y_data_30[15:0] <= density_reg108; 
               lut_Y_data_31[15:0] <= density_reg109; 
          end 
          109: begin 
               lut_Y_data_30[15:0] <= density_reg109; 
               lut_Y_data_31[15:0] <= density_reg110; 
          end 
          110: begin 
               lut_Y_data_30[15:0] <= density_reg110; 
               lut_Y_data_31[15:0] <= density_reg111; 
          end 
          111: begin 
               lut_Y_data_30[15:0] <= density_reg111; 
               lut_Y_data_31[15:0] <= density_reg112; 
          end 
          112: begin 
               lut_Y_data_30[15:0] <= density_reg112; 
               lut_Y_data_31[15:0] <= density_reg113; 
          end 
          113: begin 
               lut_Y_data_30[15:0] <= density_reg113; 
               lut_Y_data_31[15:0] <= density_reg114; 
          end 
          114: begin 
               lut_Y_data_30[15:0] <= density_reg114; 
               lut_Y_data_31[15:0] <= density_reg115; 
          end 
          115: begin 
               lut_Y_data_30[15:0] <= density_reg115; 
               lut_Y_data_31[15:0] <= density_reg116; 
          end 
          116: begin 
               lut_Y_data_30[15:0] <= density_reg116; 
               lut_Y_data_31[15:0] <= density_reg117; 
          end 
          117: begin 
               lut_Y_data_30[15:0] <= density_reg117; 
               lut_Y_data_31[15:0] <= density_reg118; 
          end 
          118: begin 
               lut_Y_data_30[15:0] <= density_reg118; 
               lut_Y_data_31[15:0] <= density_reg119; 
          end 
          119: begin 
               lut_Y_data_30[15:0] <= density_reg119; 
               lut_Y_data_31[15:0] <= density_reg120; 
          end 
          120: begin 
               lut_Y_data_30[15:0] <= density_reg120; 
               lut_Y_data_31[15:0] <= density_reg121; 
          end 
          121: begin 
               lut_Y_data_30[15:0] <= density_reg121; 
               lut_Y_data_31[15:0] <= density_reg122; 
          end 
          122: begin 
               lut_Y_data_30[15:0] <= density_reg122; 
               lut_Y_data_31[15:0] <= density_reg123; 
          end 
          123: begin 
               lut_Y_data_30[15:0] <= density_reg123; 
               lut_Y_data_31[15:0] <= density_reg124; 
          end 
          124: begin 
               lut_Y_data_30[15:0] <= density_reg124; 
               lut_Y_data_31[15:0] <= density_reg125; 
          end 
          125: begin 
               lut_Y_data_30[15:0] <= density_reg125; 
               lut_Y_data_31[15:0] <= density_reg126; 
          end 
          126: begin 
               lut_Y_data_30[15:0] <= density_reg126; 
               lut_Y_data_31[15:0] <= density_reg127; 
          end 
          127: begin 
               lut_Y_data_30[15:0] <= density_reg127; 
               lut_Y_data_31[15:0] <= density_reg128; 
          end 
          128: begin 
               lut_Y_data_30[15:0] <= density_reg128; 
               lut_Y_data_31[15:0] <= density_reg129; 
          end 
          129: begin 
               lut_Y_data_30[15:0] <= density_reg129; 
               lut_Y_data_31[15:0] <= density_reg130; 
          end 
          130: begin 
               lut_Y_data_30[15:0] <= density_reg130; 
               lut_Y_data_31[15:0] <= density_reg131; 
          end 
          131: begin 
               lut_Y_data_30[15:0] <= density_reg131; 
               lut_Y_data_31[15:0] <= density_reg132; 
          end 
          132: begin 
               lut_Y_data_30[15:0] <= density_reg132; 
               lut_Y_data_31[15:0] <= density_reg133; 
          end 
          133: begin 
               lut_Y_data_30[15:0] <= density_reg133; 
               lut_Y_data_31[15:0] <= density_reg134; 
          end 
          134: begin 
               lut_Y_data_30[15:0] <= density_reg134; 
               lut_Y_data_31[15:0] <= density_reg135; 
          end 
          135: begin 
               lut_Y_data_30[15:0] <= density_reg135; 
               lut_Y_data_31[15:0] <= density_reg136; 
          end 
          136: begin 
               lut_Y_data_30[15:0] <= density_reg136; 
               lut_Y_data_31[15:0] <= density_reg137; 
          end 
          137: begin 
               lut_Y_data_30[15:0] <= density_reg137; 
               lut_Y_data_31[15:0] <= density_reg138; 
          end 
          138: begin 
               lut_Y_data_30[15:0] <= density_reg138; 
               lut_Y_data_31[15:0] <= density_reg139; 
          end 
          139: begin 
               lut_Y_data_30[15:0] <= density_reg139; 
               lut_Y_data_31[15:0] <= density_reg140; 
          end 
          140: begin 
               lut_Y_data_30[15:0] <= density_reg140; 
               lut_Y_data_31[15:0] <= density_reg141; 
          end 
          141: begin 
               lut_Y_data_30[15:0] <= density_reg141; 
               lut_Y_data_31[15:0] <= density_reg142; 
          end 
          142: begin 
               lut_Y_data_30[15:0] <= density_reg142; 
               lut_Y_data_31[15:0] <= density_reg143; 
          end 
          143: begin 
               lut_Y_data_30[15:0] <= density_reg143; 
               lut_Y_data_31[15:0] <= density_reg144; 
          end 
          144: begin 
               lut_Y_data_30[15:0] <= density_reg144; 
               lut_Y_data_31[15:0] <= density_reg145; 
          end 
          145: begin 
               lut_Y_data_30[15:0] <= density_reg145; 
               lut_Y_data_31[15:0] <= density_reg146; 
          end 
          146: begin 
               lut_Y_data_30[15:0] <= density_reg146; 
               lut_Y_data_31[15:0] <= density_reg147; 
          end 
          147: begin 
               lut_Y_data_30[15:0] <= density_reg147; 
               lut_Y_data_31[15:0] <= density_reg148; 
          end 
          148: begin 
               lut_Y_data_30[15:0] <= density_reg148; 
               lut_Y_data_31[15:0] <= density_reg149; 
          end 
          149: begin 
               lut_Y_data_30[15:0] <= density_reg149; 
               lut_Y_data_31[15:0] <= density_reg150; 
          end 
          150: begin 
               lut_Y_data_30[15:0] <= density_reg150; 
               lut_Y_data_31[15:0] <= density_reg151; 
          end 
          151: begin 
               lut_Y_data_30[15:0] <= density_reg151; 
               lut_Y_data_31[15:0] <= density_reg152; 
          end 
          152: begin 
               lut_Y_data_30[15:0] <= density_reg152; 
               lut_Y_data_31[15:0] <= density_reg153; 
          end 
          153: begin 
               lut_Y_data_30[15:0] <= density_reg153; 
               lut_Y_data_31[15:0] <= density_reg154; 
          end 
          154: begin 
               lut_Y_data_30[15:0] <= density_reg154; 
               lut_Y_data_31[15:0] <= density_reg155; 
          end 
          155: begin 
               lut_Y_data_30[15:0] <= density_reg155; 
               lut_Y_data_31[15:0] <= density_reg156; 
          end 
          156: begin 
               lut_Y_data_30[15:0] <= density_reg156; 
               lut_Y_data_31[15:0] <= density_reg157; 
          end 
          157: begin 
               lut_Y_data_30[15:0] <= density_reg157; 
               lut_Y_data_31[15:0] <= density_reg158; 
          end 
          158: begin 
               lut_Y_data_30[15:0] <= density_reg158; 
               lut_Y_data_31[15:0] <= density_reg159; 
          end 
          159: begin 
               lut_Y_data_30[15:0] <= density_reg159; 
               lut_Y_data_31[15:0] <= density_reg160; 
          end 
          160: begin 
               lut_Y_data_30[15:0] <= density_reg160; 
               lut_Y_data_31[15:0] <= density_reg161; 
          end 
          161: begin 
               lut_Y_data_30[15:0] <= density_reg161; 
               lut_Y_data_31[15:0] <= density_reg162; 
          end 
          162: begin 
               lut_Y_data_30[15:0] <= density_reg162; 
               lut_Y_data_31[15:0] <= density_reg163; 
          end 
          163: begin 
               lut_Y_data_30[15:0] <= density_reg163; 
               lut_Y_data_31[15:0] <= density_reg164; 
          end 
          164: begin 
               lut_Y_data_30[15:0] <= density_reg164; 
               lut_Y_data_31[15:0] <= density_reg165; 
          end 
          165: begin 
               lut_Y_data_30[15:0] <= density_reg165; 
               lut_Y_data_31[15:0] <= density_reg166; 
          end 
          166: begin 
               lut_Y_data_30[15:0] <= density_reg166; 
               lut_Y_data_31[15:0] <= density_reg167; 
          end 
          167: begin 
               lut_Y_data_30[15:0] <= density_reg167; 
               lut_Y_data_31[15:0] <= density_reg168; 
          end 
          168: begin 
               lut_Y_data_30[15:0] <= density_reg168; 
               lut_Y_data_31[15:0] <= density_reg169; 
          end 
          169: begin 
               lut_Y_data_30[15:0] <= density_reg169; 
               lut_Y_data_31[15:0] <= density_reg170; 
          end 
          170: begin 
               lut_Y_data_30[15:0] <= density_reg170; 
               lut_Y_data_31[15:0] <= density_reg171; 
          end 
          171: begin 
               lut_Y_data_30[15:0] <= density_reg171; 
               lut_Y_data_31[15:0] <= density_reg172; 
          end 
          172: begin 
               lut_Y_data_30[15:0] <= density_reg172; 
               lut_Y_data_31[15:0] <= density_reg173; 
          end 
          173: begin 
               lut_Y_data_30[15:0] <= density_reg173; 
               lut_Y_data_31[15:0] <= density_reg174; 
          end 
          174: begin 
               lut_Y_data_30[15:0] <= density_reg174; 
               lut_Y_data_31[15:0] <= density_reg175; 
          end 
          175: begin 
               lut_Y_data_30[15:0] <= density_reg175; 
               lut_Y_data_31[15:0] <= density_reg176; 
          end 
          176: begin 
               lut_Y_data_30[15:0] <= density_reg176; 
               lut_Y_data_31[15:0] <= density_reg177; 
          end 
          177: begin 
               lut_Y_data_30[15:0] <= density_reg177; 
               lut_Y_data_31[15:0] <= density_reg178; 
          end 
          178: begin 
               lut_Y_data_30[15:0] <= density_reg178; 
               lut_Y_data_31[15:0] <= density_reg179; 
          end 
          179: begin 
               lut_Y_data_30[15:0] <= density_reg179; 
               lut_Y_data_31[15:0] <= density_reg180; 
          end 
          180: begin 
               lut_Y_data_30[15:0] <= density_reg180; 
               lut_Y_data_31[15:0] <= density_reg181; 
          end 
          181: begin 
               lut_Y_data_30[15:0] <= density_reg181; 
               lut_Y_data_31[15:0] <= density_reg182; 
          end 
          182: begin 
               lut_Y_data_30[15:0] <= density_reg182; 
               lut_Y_data_31[15:0] <= density_reg183; 
          end 
          183: begin 
               lut_Y_data_30[15:0] <= density_reg183; 
               lut_Y_data_31[15:0] <= density_reg184; 
          end 
          184: begin 
               lut_Y_data_30[15:0] <= density_reg184; 
               lut_Y_data_31[15:0] <= density_reg185; 
          end 
          185: begin 
               lut_Y_data_30[15:0] <= density_reg185; 
               lut_Y_data_31[15:0] <= density_reg186; 
          end 
          186: begin 
               lut_Y_data_30[15:0] <= density_reg186; 
               lut_Y_data_31[15:0] <= density_reg187; 
          end 
          187: begin 
               lut_Y_data_30[15:0] <= density_reg187; 
               lut_Y_data_31[15:0] <= density_reg188; 
          end 
          188: begin 
               lut_Y_data_30[15:0] <= density_reg188; 
               lut_Y_data_31[15:0] <= density_reg189; 
          end 
          189: begin 
               lut_Y_data_30[15:0] <= density_reg189; 
               lut_Y_data_31[15:0] <= density_reg190; 
          end 
          190: begin 
               lut_Y_data_30[15:0] <= density_reg190; 
               lut_Y_data_31[15:0] <= density_reg191; 
          end 
          191: begin 
               lut_Y_data_30[15:0] <= density_reg191; 
               lut_Y_data_31[15:0] <= density_reg192; 
          end 
          192: begin 
               lut_Y_data_30[15:0] <= density_reg192; 
               lut_Y_data_31[15:0] <= density_reg193; 
          end 
          193: begin 
               lut_Y_data_30[15:0] <= density_reg193; 
               lut_Y_data_31[15:0] <= density_reg194; 
          end 
          194: begin 
               lut_Y_data_30[15:0] <= density_reg194; 
               lut_Y_data_31[15:0] <= density_reg195; 
          end 
          195: begin 
               lut_Y_data_30[15:0] <= density_reg195; 
               lut_Y_data_31[15:0] <= density_reg196; 
          end 
          196: begin 
               lut_Y_data_30[15:0] <= density_reg196; 
               lut_Y_data_31[15:0] <= density_reg197; 
          end 
          197: begin 
               lut_Y_data_30[15:0] <= density_reg197; 
               lut_Y_data_31[15:0] <= density_reg198; 
          end 
          198: begin 
               lut_Y_data_30[15:0] <= density_reg198; 
               lut_Y_data_31[15:0] <= density_reg199; 
          end 
          199: begin 
               lut_Y_data_30[15:0] <= density_reg199; 
               lut_Y_data_31[15:0] <= density_reg200; 
          end 
          200: begin 
               lut_Y_data_30[15:0] <= density_reg200; 
               lut_Y_data_31[15:0] <= density_reg201; 
          end 
          201: begin 
               lut_Y_data_30[15:0] <= density_reg201; 
               lut_Y_data_31[15:0] <= density_reg202; 
          end 
          202: begin 
               lut_Y_data_30[15:0] <= density_reg202; 
               lut_Y_data_31[15:0] <= density_reg203; 
          end 
          203: begin 
               lut_Y_data_30[15:0] <= density_reg203; 
               lut_Y_data_31[15:0] <= density_reg204; 
          end 
          204: begin 
               lut_Y_data_30[15:0] <= density_reg204; 
               lut_Y_data_31[15:0] <= density_reg205; 
          end 
          205: begin 
               lut_Y_data_30[15:0] <= density_reg205; 
               lut_Y_data_31[15:0] <= density_reg206; 
          end 
          206: begin 
               lut_Y_data_30[15:0] <= density_reg206; 
               lut_Y_data_31[15:0] <= density_reg207; 
          end 
          207: begin 
               lut_Y_data_30[15:0] <= density_reg207; 
               lut_Y_data_31[15:0] <= density_reg208; 
          end 
          208: begin 
               lut_Y_data_30[15:0] <= density_reg208; 
               lut_Y_data_31[15:0] <= density_reg209; 
          end 
          209: begin 
               lut_Y_data_30[15:0] <= density_reg209; 
               lut_Y_data_31[15:0] <= density_reg210; 
          end 
          210: begin 
               lut_Y_data_30[15:0] <= density_reg210; 
               lut_Y_data_31[15:0] <= density_reg211; 
          end 
          211: begin 
               lut_Y_data_30[15:0] <= density_reg211; 
               lut_Y_data_31[15:0] <= density_reg212; 
          end 
          212: begin 
               lut_Y_data_30[15:0] <= density_reg212; 
               lut_Y_data_31[15:0] <= density_reg213; 
          end 
          213: begin 
               lut_Y_data_30[15:0] <= density_reg213; 
               lut_Y_data_31[15:0] <= density_reg214; 
          end 
          214: begin 
               lut_Y_data_30[15:0] <= density_reg214; 
               lut_Y_data_31[15:0] <= density_reg215; 
          end 
          215: begin 
               lut_Y_data_30[15:0] <= density_reg215; 
               lut_Y_data_31[15:0] <= density_reg216; 
          end 
          216: begin 
               lut_Y_data_30[15:0] <= density_reg216; 
               lut_Y_data_31[15:0] <= density_reg217; 
          end 
          217: begin 
               lut_Y_data_30[15:0] <= density_reg217; 
               lut_Y_data_31[15:0] <= density_reg218; 
          end 
          218: begin 
               lut_Y_data_30[15:0] <= density_reg218; 
               lut_Y_data_31[15:0] <= density_reg219; 
          end 
          219: begin 
               lut_Y_data_30[15:0] <= density_reg219; 
               lut_Y_data_31[15:0] <= density_reg220; 
          end 
          220: begin 
               lut_Y_data_30[15:0] <= density_reg220; 
               lut_Y_data_31[15:0] <= density_reg221; 
          end 
          221: begin 
               lut_Y_data_30[15:0] <= density_reg221; 
               lut_Y_data_31[15:0] <= density_reg222; 
          end 
          222: begin 
               lut_Y_data_30[15:0] <= density_reg222; 
               lut_Y_data_31[15:0] <= density_reg223; 
          end 
          223: begin 
               lut_Y_data_30[15:0] <= density_reg223; 
               lut_Y_data_31[15:0] <= density_reg224; 
          end 
          224: begin 
               lut_Y_data_30[15:0] <= density_reg224; 
               lut_Y_data_31[15:0] <= density_reg225; 
          end 
          225: begin 
               lut_Y_data_30[15:0] <= density_reg225; 
               lut_Y_data_31[15:0] <= density_reg226; 
          end 
          226: begin 
               lut_Y_data_30[15:0] <= density_reg226; 
               lut_Y_data_31[15:0] <= density_reg227; 
          end 
          227: begin 
               lut_Y_data_30[15:0] <= density_reg227; 
               lut_Y_data_31[15:0] <= density_reg228; 
          end 
          228: begin 
               lut_Y_data_30[15:0] <= density_reg228; 
               lut_Y_data_31[15:0] <= density_reg229; 
          end 
          229: begin 
               lut_Y_data_30[15:0] <= density_reg229; 
               lut_Y_data_31[15:0] <= density_reg230; 
          end 
          230: begin 
               lut_Y_data_30[15:0] <= density_reg230; 
               lut_Y_data_31[15:0] <= density_reg231; 
          end 
          231: begin 
               lut_Y_data_30[15:0] <= density_reg231; 
               lut_Y_data_31[15:0] <= density_reg232; 
          end 
          232: begin 
               lut_Y_data_30[15:0] <= density_reg232; 
               lut_Y_data_31[15:0] <= density_reg233; 
          end 
          233: begin 
               lut_Y_data_30[15:0] <= density_reg233; 
               lut_Y_data_31[15:0] <= density_reg234; 
          end 
          234: begin 
               lut_Y_data_30[15:0] <= density_reg234; 
               lut_Y_data_31[15:0] <= density_reg235; 
          end 
          235: begin 
               lut_Y_data_30[15:0] <= density_reg235; 
               lut_Y_data_31[15:0] <= density_reg236; 
          end 
          236: begin 
               lut_Y_data_30[15:0] <= density_reg236; 
               lut_Y_data_31[15:0] <= density_reg237; 
          end 
          237: begin 
               lut_Y_data_30[15:0] <= density_reg237; 
               lut_Y_data_31[15:0] <= density_reg238; 
          end 
          238: begin 
               lut_Y_data_30[15:0] <= density_reg238; 
               lut_Y_data_31[15:0] <= density_reg239; 
          end 
          239: begin 
               lut_Y_data_30[15:0] <= density_reg239; 
               lut_Y_data_31[15:0] <= density_reg240; 
          end 
          240: begin 
               lut_Y_data_30[15:0] <= density_reg240; 
               lut_Y_data_31[15:0] <= density_reg241; 
          end 
          241: begin 
               lut_Y_data_30[15:0] <= density_reg241; 
               lut_Y_data_31[15:0] <= density_reg242; 
          end 
          242: begin 
               lut_Y_data_30[15:0] <= density_reg242; 
               lut_Y_data_31[15:0] <= density_reg243; 
          end 
          243: begin 
               lut_Y_data_30[15:0] <= density_reg243; 
               lut_Y_data_31[15:0] <= density_reg244; 
          end 
          244: begin 
               lut_Y_data_30[15:0] <= density_reg244; 
               lut_Y_data_31[15:0] <= density_reg245; 
          end 
          245: begin 
               lut_Y_data_30[15:0] <= density_reg245; 
               lut_Y_data_31[15:0] <= density_reg246; 
          end 
          246: begin 
               lut_Y_data_30[15:0] <= density_reg246; 
               lut_Y_data_31[15:0] <= density_reg247; 
          end 
          247: begin 
               lut_Y_data_30[15:0] <= density_reg247; 
               lut_Y_data_31[15:0] <= density_reg248; 
          end 
          248: begin 
               lut_Y_data_30[15:0] <= density_reg248; 
               lut_Y_data_31[15:0] <= density_reg249; 
          end 
          249: begin 
               lut_Y_data_30[15:0] <= density_reg249; 
               lut_Y_data_31[15:0] <= density_reg250; 
          end 
          250: begin 
               lut_Y_data_30[15:0] <= density_reg250; 
               lut_Y_data_31[15:0] <= density_reg251; 
          end 
          251: begin 
               lut_Y_data_30[15:0] <= density_reg251; 
               lut_Y_data_31[15:0] <= density_reg252; 
          end 
          252: begin 
               lut_Y_data_30[15:0] <= density_reg252; 
               lut_Y_data_31[15:0] <= density_reg253; 
          end 
          253: begin 
               lut_Y_data_30[15:0] <= density_reg253; 
               lut_Y_data_31[15:0] <= density_reg254; 
          end 
          254: begin 
               lut_Y_data_30[15:0] <= density_reg254; 
               lut_Y_data_31[15:0] <= density_reg255; 
          end 
          255: begin 
               lut_Y_data_30[15:0] <= density_reg255; 
               lut_Y_data_31[15:0] <= density_reg256; 
          end 
          256: begin 
               lut_Y_data_30[15:0] <= density_reg256; 
               lut_Y_data_31[15:0] <= density_reg256; 
          end 
          default: begin 
            lut_Y_data_30[15:0] <= density_reg0; 
            lut_Y_data_31[15:0] <= density_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_Y_data_40[15:0] <= {16{1'b0}};
     lut_Y_data_41[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & int8_en & lut_Y_sel[4]) begin 
      if(dp2lut_Yinfo_4[16]) begin 
         lut_Y_data_40[15:0] <= density_reg0; 
         lut_Y_data_41[15:0] <= density_reg0; 
      end else if(dp2lut_Yinfo_4[17]) begin 
         lut_Y_data_40[15:0] <= density_reg256; 
         lut_Y_data_41[15:0] <= density_reg256; 
      end else begin 
        case(dp2lut_Y_entry_4[9:0]) 
          0: begin 
               lut_Y_data_40[15:0] <= density_reg0; 
               lut_Y_data_41[15:0] <= density_reg1; 
          end 
          1: begin 
               lut_Y_data_40[15:0] <= density_reg1; 
               lut_Y_data_41[15:0] <= density_reg2; 
          end 
          2: begin 
               lut_Y_data_40[15:0] <= density_reg2; 
               lut_Y_data_41[15:0] <= density_reg3; 
          end 
          3: begin 
               lut_Y_data_40[15:0] <= density_reg3; 
               lut_Y_data_41[15:0] <= density_reg4; 
          end 
          4: begin 
               lut_Y_data_40[15:0] <= density_reg4; 
               lut_Y_data_41[15:0] <= density_reg5; 
          end 
          5: begin 
               lut_Y_data_40[15:0] <= density_reg5; 
               lut_Y_data_41[15:0] <= density_reg6; 
          end 
          6: begin 
               lut_Y_data_40[15:0] <= density_reg6; 
               lut_Y_data_41[15:0] <= density_reg7; 
          end 
          7: begin 
               lut_Y_data_40[15:0] <= density_reg7; 
               lut_Y_data_41[15:0] <= density_reg8; 
          end 
          8: begin 
               lut_Y_data_40[15:0] <= density_reg8; 
               lut_Y_data_41[15:0] <= density_reg9; 
          end 
          9: begin 
               lut_Y_data_40[15:0] <= density_reg9; 
               lut_Y_data_41[15:0] <= density_reg10; 
          end 
          10: begin 
               lut_Y_data_40[15:0] <= density_reg10; 
               lut_Y_data_41[15:0] <= density_reg11; 
          end 
          11: begin 
               lut_Y_data_40[15:0] <= density_reg11; 
               lut_Y_data_41[15:0] <= density_reg12; 
          end 
          12: begin 
               lut_Y_data_40[15:0] <= density_reg12; 
               lut_Y_data_41[15:0] <= density_reg13; 
          end 
          13: begin 
               lut_Y_data_40[15:0] <= density_reg13; 
               lut_Y_data_41[15:0] <= density_reg14; 
          end 
          14: begin 
               lut_Y_data_40[15:0] <= density_reg14; 
               lut_Y_data_41[15:0] <= density_reg15; 
          end 
          15: begin 
               lut_Y_data_40[15:0] <= density_reg15; 
               lut_Y_data_41[15:0] <= density_reg16; 
          end 
          16: begin 
               lut_Y_data_40[15:0] <= density_reg16; 
               lut_Y_data_41[15:0] <= density_reg17; 
          end 
          17: begin 
               lut_Y_data_40[15:0] <= density_reg17; 
               lut_Y_data_41[15:0] <= density_reg18; 
          end 
          18: begin 
               lut_Y_data_40[15:0] <= density_reg18; 
               lut_Y_data_41[15:0] <= density_reg19; 
          end 
          19: begin 
               lut_Y_data_40[15:0] <= density_reg19; 
               lut_Y_data_41[15:0] <= density_reg20; 
          end 
          20: begin 
               lut_Y_data_40[15:0] <= density_reg20; 
               lut_Y_data_41[15:0] <= density_reg21; 
          end 
          21: begin 
               lut_Y_data_40[15:0] <= density_reg21; 
               lut_Y_data_41[15:0] <= density_reg22; 
          end 
          22: begin 
               lut_Y_data_40[15:0] <= density_reg22; 
               lut_Y_data_41[15:0] <= density_reg23; 
          end 
          23: begin 
               lut_Y_data_40[15:0] <= density_reg23; 
               lut_Y_data_41[15:0] <= density_reg24; 
          end 
          24: begin 
               lut_Y_data_40[15:0] <= density_reg24; 
               lut_Y_data_41[15:0] <= density_reg25; 
          end 
          25: begin 
               lut_Y_data_40[15:0] <= density_reg25; 
               lut_Y_data_41[15:0] <= density_reg26; 
          end 
          26: begin 
               lut_Y_data_40[15:0] <= density_reg26; 
               lut_Y_data_41[15:0] <= density_reg27; 
          end 
          27: begin 
               lut_Y_data_40[15:0] <= density_reg27; 
               lut_Y_data_41[15:0] <= density_reg28; 
          end 
          28: begin 
               lut_Y_data_40[15:0] <= density_reg28; 
               lut_Y_data_41[15:0] <= density_reg29; 
          end 
          29: begin 
               lut_Y_data_40[15:0] <= density_reg29; 
               lut_Y_data_41[15:0] <= density_reg30; 
          end 
          30: begin 
               lut_Y_data_40[15:0] <= density_reg30; 
               lut_Y_data_41[15:0] <= density_reg31; 
          end 
          31: begin 
               lut_Y_data_40[15:0] <= density_reg31; 
               lut_Y_data_41[15:0] <= density_reg32; 
          end 
          32: begin 
               lut_Y_data_40[15:0] <= density_reg32; 
               lut_Y_data_41[15:0] <= density_reg33; 
          end 
          33: begin 
               lut_Y_data_40[15:0] <= density_reg33; 
               lut_Y_data_41[15:0] <= density_reg34; 
          end 
          34: begin 
               lut_Y_data_40[15:0] <= density_reg34; 
               lut_Y_data_41[15:0] <= density_reg35; 
          end 
          35: begin 
               lut_Y_data_40[15:0] <= density_reg35; 
               lut_Y_data_41[15:0] <= density_reg36; 
          end 
          36: begin 
               lut_Y_data_40[15:0] <= density_reg36; 
               lut_Y_data_41[15:0] <= density_reg37; 
          end 
          37: begin 
               lut_Y_data_40[15:0] <= density_reg37; 
               lut_Y_data_41[15:0] <= density_reg38; 
          end 
          38: begin 
               lut_Y_data_40[15:0] <= density_reg38; 
               lut_Y_data_41[15:0] <= density_reg39; 
          end 
          39: begin 
               lut_Y_data_40[15:0] <= density_reg39; 
               lut_Y_data_41[15:0] <= density_reg40; 
          end 
          40: begin 
               lut_Y_data_40[15:0] <= density_reg40; 
               lut_Y_data_41[15:0] <= density_reg41; 
          end 
          41: begin 
               lut_Y_data_40[15:0] <= density_reg41; 
               lut_Y_data_41[15:0] <= density_reg42; 
          end 
          42: begin 
               lut_Y_data_40[15:0] <= density_reg42; 
               lut_Y_data_41[15:0] <= density_reg43; 
          end 
          43: begin 
               lut_Y_data_40[15:0] <= density_reg43; 
               lut_Y_data_41[15:0] <= density_reg44; 
          end 
          44: begin 
               lut_Y_data_40[15:0] <= density_reg44; 
               lut_Y_data_41[15:0] <= density_reg45; 
          end 
          45: begin 
               lut_Y_data_40[15:0] <= density_reg45; 
               lut_Y_data_41[15:0] <= density_reg46; 
          end 
          46: begin 
               lut_Y_data_40[15:0] <= density_reg46; 
               lut_Y_data_41[15:0] <= density_reg47; 
          end 
          47: begin 
               lut_Y_data_40[15:0] <= density_reg47; 
               lut_Y_data_41[15:0] <= density_reg48; 
          end 
          48: begin 
               lut_Y_data_40[15:0] <= density_reg48; 
               lut_Y_data_41[15:0] <= density_reg49; 
          end 
          49: begin 
               lut_Y_data_40[15:0] <= density_reg49; 
               lut_Y_data_41[15:0] <= density_reg50; 
          end 
          50: begin 
               lut_Y_data_40[15:0] <= density_reg50; 
               lut_Y_data_41[15:0] <= density_reg51; 
          end 
          51: begin 
               lut_Y_data_40[15:0] <= density_reg51; 
               lut_Y_data_41[15:0] <= density_reg52; 
          end 
          52: begin 
               lut_Y_data_40[15:0] <= density_reg52; 
               lut_Y_data_41[15:0] <= density_reg53; 
          end 
          53: begin 
               lut_Y_data_40[15:0] <= density_reg53; 
               lut_Y_data_41[15:0] <= density_reg54; 
          end 
          54: begin 
               lut_Y_data_40[15:0] <= density_reg54; 
               lut_Y_data_41[15:0] <= density_reg55; 
          end 
          55: begin 
               lut_Y_data_40[15:0] <= density_reg55; 
               lut_Y_data_41[15:0] <= density_reg56; 
          end 
          56: begin 
               lut_Y_data_40[15:0] <= density_reg56; 
               lut_Y_data_41[15:0] <= density_reg57; 
          end 
          57: begin 
               lut_Y_data_40[15:0] <= density_reg57; 
               lut_Y_data_41[15:0] <= density_reg58; 
          end 
          58: begin 
               lut_Y_data_40[15:0] <= density_reg58; 
               lut_Y_data_41[15:0] <= density_reg59; 
          end 
          59: begin 
               lut_Y_data_40[15:0] <= density_reg59; 
               lut_Y_data_41[15:0] <= density_reg60; 
          end 
          60: begin 
               lut_Y_data_40[15:0] <= density_reg60; 
               lut_Y_data_41[15:0] <= density_reg61; 
          end 
          61: begin 
               lut_Y_data_40[15:0] <= density_reg61; 
               lut_Y_data_41[15:0] <= density_reg62; 
          end 
          62: begin 
               lut_Y_data_40[15:0] <= density_reg62; 
               lut_Y_data_41[15:0] <= density_reg63; 
          end 
          63: begin 
               lut_Y_data_40[15:0] <= density_reg63; 
               lut_Y_data_41[15:0] <= density_reg64; 
          end 
          64: begin 
               lut_Y_data_40[15:0] <= density_reg64; 
               lut_Y_data_41[15:0] <= density_reg65; 
          end 
          65: begin 
               lut_Y_data_40[15:0] <= density_reg65; 
               lut_Y_data_41[15:0] <= density_reg66; 
          end 
          66: begin 
               lut_Y_data_40[15:0] <= density_reg66; 
               lut_Y_data_41[15:0] <= density_reg67; 
          end 
          67: begin 
               lut_Y_data_40[15:0] <= density_reg67; 
               lut_Y_data_41[15:0] <= density_reg68; 
          end 
          68: begin 
               lut_Y_data_40[15:0] <= density_reg68; 
               lut_Y_data_41[15:0] <= density_reg69; 
          end 
          69: begin 
               lut_Y_data_40[15:0] <= density_reg69; 
               lut_Y_data_41[15:0] <= density_reg70; 
          end 
          70: begin 
               lut_Y_data_40[15:0] <= density_reg70; 
               lut_Y_data_41[15:0] <= density_reg71; 
          end 
          71: begin 
               lut_Y_data_40[15:0] <= density_reg71; 
               lut_Y_data_41[15:0] <= density_reg72; 
          end 
          72: begin 
               lut_Y_data_40[15:0] <= density_reg72; 
               lut_Y_data_41[15:0] <= density_reg73; 
          end 
          73: begin 
               lut_Y_data_40[15:0] <= density_reg73; 
               lut_Y_data_41[15:0] <= density_reg74; 
          end 
          74: begin 
               lut_Y_data_40[15:0] <= density_reg74; 
               lut_Y_data_41[15:0] <= density_reg75; 
          end 
          75: begin 
               lut_Y_data_40[15:0] <= density_reg75; 
               lut_Y_data_41[15:0] <= density_reg76; 
          end 
          76: begin 
               lut_Y_data_40[15:0] <= density_reg76; 
               lut_Y_data_41[15:0] <= density_reg77; 
          end 
          77: begin 
               lut_Y_data_40[15:0] <= density_reg77; 
               lut_Y_data_41[15:0] <= density_reg78; 
          end 
          78: begin 
               lut_Y_data_40[15:0] <= density_reg78; 
               lut_Y_data_41[15:0] <= density_reg79; 
          end 
          79: begin 
               lut_Y_data_40[15:0] <= density_reg79; 
               lut_Y_data_41[15:0] <= density_reg80; 
          end 
          80: begin 
               lut_Y_data_40[15:0] <= density_reg80; 
               lut_Y_data_41[15:0] <= density_reg81; 
          end 
          81: begin 
               lut_Y_data_40[15:0] <= density_reg81; 
               lut_Y_data_41[15:0] <= density_reg82; 
          end 
          82: begin 
               lut_Y_data_40[15:0] <= density_reg82; 
               lut_Y_data_41[15:0] <= density_reg83; 
          end 
          83: begin 
               lut_Y_data_40[15:0] <= density_reg83; 
               lut_Y_data_41[15:0] <= density_reg84; 
          end 
          84: begin 
               lut_Y_data_40[15:0] <= density_reg84; 
               lut_Y_data_41[15:0] <= density_reg85; 
          end 
          85: begin 
               lut_Y_data_40[15:0] <= density_reg85; 
               lut_Y_data_41[15:0] <= density_reg86; 
          end 
          86: begin 
               lut_Y_data_40[15:0] <= density_reg86; 
               lut_Y_data_41[15:0] <= density_reg87; 
          end 
          87: begin 
               lut_Y_data_40[15:0] <= density_reg87; 
               lut_Y_data_41[15:0] <= density_reg88; 
          end 
          88: begin 
               lut_Y_data_40[15:0] <= density_reg88; 
               lut_Y_data_41[15:0] <= density_reg89; 
          end 
          89: begin 
               lut_Y_data_40[15:0] <= density_reg89; 
               lut_Y_data_41[15:0] <= density_reg90; 
          end 
          90: begin 
               lut_Y_data_40[15:0] <= density_reg90; 
               lut_Y_data_41[15:0] <= density_reg91; 
          end 
          91: begin 
               lut_Y_data_40[15:0] <= density_reg91; 
               lut_Y_data_41[15:0] <= density_reg92; 
          end 
          92: begin 
               lut_Y_data_40[15:0] <= density_reg92; 
               lut_Y_data_41[15:0] <= density_reg93; 
          end 
          93: begin 
               lut_Y_data_40[15:0] <= density_reg93; 
               lut_Y_data_41[15:0] <= density_reg94; 
          end 
          94: begin 
               lut_Y_data_40[15:0] <= density_reg94; 
               lut_Y_data_41[15:0] <= density_reg95; 
          end 
          95: begin 
               lut_Y_data_40[15:0] <= density_reg95; 
               lut_Y_data_41[15:0] <= density_reg96; 
          end 
          96: begin 
               lut_Y_data_40[15:0] <= density_reg96; 
               lut_Y_data_41[15:0] <= density_reg97; 
          end 
          97: begin 
               lut_Y_data_40[15:0] <= density_reg97; 
               lut_Y_data_41[15:0] <= density_reg98; 
          end 
          98: begin 
               lut_Y_data_40[15:0] <= density_reg98; 
               lut_Y_data_41[15:0] <= density_reg99; 
          end 
          99: begin 
               lut_Y_data_40[15:0] <= density_reg99; 
               lut_Y_data_41[15:0] <= density_reg100; 
          end 
          100: begin 
               lut_Y_data_40[15:0] <= density_reg100; 
               lut_Y_data_41[15:0] <= density_reg101; 
          end 
          101: begin 
               lut_Y_data_40[15:0] <= density_reg101; 
               lut_Y_data_41[15:0] <= density_reg102; 
          end 
          102: begin 
               lut_Y_data_40[15:0] <= density_reg102; 
               lut_Y_data_41[15:0] <= density_reg103; 
          end 
          103: begin 
               lut_Y_data_40[15:0] <= density_reg103; 
               lut_Y_data_41[15:0] <= density_reg104; 
          end 
          104: begin 
               lut_Y_data_40[15:0] <= density_reg104; 
               lut_Y_data_41[15:0] <= density_reg105; 
          end 
          105: begin 
               lut_Y_data_40[15:0] <= density_reg105; 
               lut_Y_data_41[15:0] <= density_reg106; 
          end 
          106: begin 
               lut_Y_data_40[15:0] <= density_reg106; 
               lut_Y_data_41[15:0] <= density_reg107; 
          end 
          107: begin 
               lut_Y_data_40[15:0] <= density_reg107; 
               lut_Y_data_41[15:0] <= density_reg108; 
          end 
          108: begin 
               lut_Y_data_40[15:0] <= density_reg108; 
               lut_Y_data_41[15:0] <= density_reg109; 
          end 
          109: begin 
               lut_Y_data_40[15:0] <= density_reg109; 
               lut_Y_data_41[15:0] <= density_reg110; 
          end 
          110: begin 
               lut_Y_data_40[15:0] <= density_reg110; 
               lut_Y_data_41[15:0] <= density_reg111; 
          end 
          111: begin 
               lut_Y_data_40[15:0] <= density_reg111; 
               lut_Y_data_41[15:0] <= density_reg112; 
          end 
          112: begin 
               lut_Y_data_40[15:0] <= density_reg112; 
               lut_Y_data_41[15:0] <= density_reg113; 
          end 
          113: begin 
               lut_Y_data_40[15:0] <= density_reg113; 
               lut_Y_data_41[15:0] <= density_reg114; 
          end 
          114: begin 
               lut_Y_data_40[15:0] <= density_reg114; 
               lut_Y_data_41[15:0] <= density_reg115; 
          end 
          115: begin 
               lut_Y_data_40[15:0] <= density_reg115; 
               lut_Y_data_41[15:0] <= density_reg116; 
          end 
          116: begin 
               lut_Y_data_40[15:0] <= density_reg116; 
               lut_Y_data_41[15:0] <= density_reg117; 
          end 
          117: begin 
               lut_Y_data_40[15:0] <= density_reg117; 
               lut_Y_data_41[15:0] <= density_reg118; 
          end 
          118: begin 
               lut_Y_data_40[15:0] <= density_reg118; 
               lut_Y_data_41[15:0] <= density_reg119; 
          end 
          119: begin 
               lut_Y_data_40[15:0] <= density_reg119; 
               lut_Y_data_41[15:0] <= density_reg120; 
          end 
          120: begin 
               lut_Y_data_40[15:0] <= density_reg120; 
               lut_Y_data_41[15:0] <= density_reg121; 
          end 
          121: begin 
               lut_Y_data_40[15:0] <= density_reg121; 
               lut_Y_data_41[15:0] <= density_reg122; 
          end 
          122: begin 
               lut_Y_data_40[15:0] <= density_reg122; 
               lut_Y_data_41[15:0] <= density_reg123; 
          end 
          123: begin 
               lut_Y_data_40[15:0] <= density_reg123; 
               lut_Y_data_41[15:0] <= density_reg124; 
          end 
          124: begin 
               lut_Y_data_40[15:0] <= density_reg124; 
               lut_Y_data_41[15:0] <= density_reg125; 
          end 
          125: begin 
               lut_Y_data_40[15:0] <= density_reg125; 
               lut_Y_data_41[15:0] <= density_reg126; 
          end 
          126: begin 
               lut_Y_data_40[15:0] <= density_reg126; 
               lut_Y_data_41[15:0] <= density_reg127; 
          end 
          127: begin 
               lut_Y_data_40[15:0] <= density_reg127; 
               lut_Y_data_41[15:0] <= density_reg128; 
          end 
          128: begin 
               lut_Y_data_40[15:0] <= density_reg128; 
               lut_Y_data_41[15:0] <= density_reg129; 
          end 
          129: begin 
               lut_Y_data_40[15:0] <= density_reg129; 
               lut_Y_data_41[15:0] <= density_reg130; 
          end 
          130: begin 
               lut_Y_data_40[15:0] <= density_reg130; 
               lut_Y_data_41[15:0] <= density_reg131; 
          end 
          131: begin 
               lut_Y_data_40[15:0] <= density_reg131; 
               lut_Y_data_41[15:0] <= density_reg132; 
          end 
          132: begin 
               lut_Y_data_40[15:0] <= density_reg132; 
               lut_Y_data_41[15:0] <= density_reg133; 
          end 
          133: begin 
               lut_Y_data_40[15:0] <= density_reg133; 
               lut_Y_data_41[15:0] <= density_reg134; 
          end 
          134: begin 
               lut_Y_data_40[15:0] <= density_reg134; 
               lut_Y_data_41[15:0] <= density_reg135; 
          end 
          135: begin 
               lut_Y_data_40[15:0] <= density_reg135; 
               lut_Y_data_41[15:0] <= density_reg136; 
          end 
          136: begin 
               lut_Y_data_40[15:0] <= density_reg136; 
               lut_Y_data_41[15:0] <= density_reg137; 
          end 
          137: begin 
               lut_Y_data_40[15:0] <= density_reg137; 
               lut_Y_data_41[15:0] <= density_reg138; 
          end 
          138: begin 
               lut_Y_data_40[15:0] <= density_reg138; 
               lut_Y_data_41[15:0] <= density_reg139; 
          end 
          139: begin 
               lut_Y_data_40[15:0] <= density_reg139; 
               lut_Y_data_41[15:0] <= density_reg140; 
          end 
          140: begin 
               lut_Y_data_40[15:0] <= density_reg140; 
               lut_Y_data_41[15:0] <= density_reg141; 
          end 
          141: begin 
               lut_Y_data_40[15:0] <= density_reg141; 
               lut_Y_data_41[15:0] <= density_reg142; 
          end 
          142: begin 
               lut_Y_data_40[15:0] <= density_reg142; 
               lut_Y_data_41[15:0] <= density_reg143; 
          end 
          143: begin 
               lut_Y_data_40[15:0] <= density_reg143; 
               lut_Y_data_41[15:0] <= density_reg144; 
          end 
          144: begin 
               lut_Y_data_40[15:0] <= density_reg144; 
               lut_Y_data_41[15:0] <= density_reg145; 
          end 
          145: begin 
               lut_Y_data_40[15:0] <= density_reg145; 
               lut_Y_data_41[15:0] <= density_reg146; 
          end 
          146: begin 
               lut_Y_data_40[15:0] <= density_reg146; 
               lut_Y_data_41[15:0] <= density_reg147; 
          end 
          147: begin 
               lut_Y_data_40[15:0] <= density_reg147; 
               lut_Y_data_41[15:0] <= density_reg148; 
          end 
          148: begin 
               lut_Y_data_40[15:0] <= density_reg148; 
               lut_Y_data_41[15:0] <= density_reg149; 
          end 
          149: begin 
               lut_Y_data_40[15:0] <= density_reg149; 
               lut_Y_data_41[15:0] <= density_reg150; 
          end 
          150: begin 
               lut_Y_data_40[15:0] <= density_reg150; 
               lut_Y_data_41[15:0] <= density_reg151; 
          end 
          151: begin 
               lut_Y_data_40[15:0] <= density_reg151; 
               lut_Y_data_41[15:0] <= density_reg152; 
          end 
          152: begin 
               lut_Y_data_40[15:0] <= density_reg152; 
               lut_Y_data_41[15:0] <= density_reg153; 
          end 
          153: begin 
               lut_Y_data_40[15:0] <= density_reg153; 
               lut_Y_data_41[15:0] <= density_reg154; 
          end 
          154: begin 
               lut_Y_data_40[15:0] <= density_reg154; 
               lut_Y_data_41[15:0] <= density_reg155; 
          end 
          155: begin 
               lut_Y_data_40[15:0] <= density_reg155; 
               lut_Y_data_41[15:0] <= density_reg156; 
          end 
          156: begin 
               lut_Y_data_40[15:0] <= density_reg156; 
               lut_Y_data_41[15:0] <= density_reg157; 
          end 
          157: begin 
               lut_Y_data_40[15:0] <= density_reg157; 
               lut_Y_data_41[15:0] <= density_reg158; 
          end 
          158: begin 
               lut_Y_data_40[15:0] <= density_reg158; 
               lut_Y_data_41[15:0] <= density_reg159; 
          end 
          159: begin 
               lut_Y_data_40[15:0] <= density_reg159; 
               lut_Y_data_41[15:0] <= density_reg160; 
          end 
          160: begin 
               lut_Y_data_40[15:0] <= density_reg160; 
               lut_Y_data_41[15:0] <= density_reg161; 
          end 
          161: begin 
               lut_Y_data_40[15:0] <= density_reg161; 
               lut_Y_data_41[15:0] <= density_reg162; 
          end 
          162: begin 
               lut_Y_data_40[15:0] <= density_reg162; 
               lut_Y_data_41[15:0] <= density_reg163; 
          end 
          163: begin 
               lut_Y_data_40[15:0] <= density_reg163; 
               lut_Y_data_41[15:0] <= density_reg164; 
          end 
          164: begin 
               lut_Y_data_40[15:0] <= density_reg164; 
               lut_Y_data_41[15:0] <= density_reg165; 
          end 
          165: begin 
               lut_Y_data_40[15:0] <= density_reg165; 
               lut_Y_data_41[15:0] <= density_reg166; 
          end 
          166: begin 
               lut_Y_data_40[15:0] <= density_reg166; 
               lut_Y_data_41[15:0] <= density_reg167; 
          end 
          167: begin 
               lut_Y_data_40[15:0] <= density_reg167; 
               lut_Y_data_41[15:0] <= density_reg168; 
          end 
          168: begin 
               lut_Y_data_40[15:0] <= density_reg168; 
               lut_Y_data_41[15:0] <= density_reg169; 
          end 
          169: begin 
               lut_Y_data_40[15:0] <= density_reg169; 
               lut_Y_data_41[15:0] <= density_reg170; 
          end 
          170: begin 
               lut_Y_data_40[15:0] <= density_reg170; 
               lut_Y_data_41[15:0] <= density_reg171; 
          end 
          171: begin 
               lut_Y_data_40[15:0] <= density_reg171; 
               lut_Y_data_41[15:0] <= density_reg172; 
          end 
          172: begin 
               lut_Y_data_40[15:0] <= density_reg172; 
               lut_Y_data_41[15:0] <= density_reg173; 
          end 
          173: begin 
               lut_Y_data_40[15:0] <= density_reg173; 
               lut_Y_data_41[15:0] <= density_reg174; 
          end 
          174: begin 
               lut_Y_data_40[15:0] <= density_reg174; 
               lut_Y_data_41[15:0] <= density_reg175; 
          end 
          175: begin 
               lut_Y_data_40[15:0] <= density_reg175; 
               lut_Y_data_41[15:0] <= density_reg176; 
          end 
          176: begin 
               lut_Y_data_40[15:0] <= density_reg176; 
               lut_Y_data_41[15:0] <= density_reg177; 
          end 
          177: begin 
               lut_Y_data_40[15:0] <= density_reg177; 
               lut_Y_data_41[15:0] <= density_reg178; 
          end 
          178: begin 
               lut_Y_data_40[15:0] <= density_reg178; 
               lut_Y_data_41[15:0] <= density_reg179; 
          end 
          179: begin 
               lut_Y_data_40[15:0] <= density_reg179; 
               lut_Y_data_41[15:0] <= density_reg180; 
          end 
          180: begin 
               lut_Y_data_40[15:0] <= density_reg180; 
               lut_Y_data_41[15:0] <= density_reg181; 
          end 
          181: begin 
               lut_Y_data_40[15:0] <= density_reg181; 
               lut_Y_data_41[15:0] <= density_reg182; 
          end 
          182: begin 
               lut_Y_data_40[15:0] <= density_reg182; 
               lut_Y_data_41[15:0] <= density_reg183; 
          end 
          183: begin 
               lut_Y_data_40[15:0] <= density_reg183; 
               lut_Y_data_41[15:0] <= density_reg184; 
          end 
          184: begin 
               lut_Y_data_40[15:0] <= density_reg184; 
               lut_Y_data_41[15:0] <= density_reg185; 
          end 
          185: begin 
               lut_Y_data_40[15:0] <= density_reg185; 
               lut_Y_data_41[15:0] <= density_reg186; 
          end 
          186: begin 
               lut_Y_data_40[15:0] <= density_reg186; 
               lut_Y_data_41[15:0] <= density_reg187; 
          end 
          187: begin 
               lut_Y_data_40[15:0] <= density_reg187; 
               lut_Y_data_41[15:0] <= density_reg188; 
          end 
          188: begin 
               lut_Y_data_40[15:0] <= density_reg188; 
               lut_Y_data_41[15:0] <= density_reg189; 
          end 
          189: begin 
               lut_Y_data_40[15:0] <= density_reg189; 
               lut_Y_data_41[15:0] <= density_reg190; 
          end 
          190: begin 
               lut_Y_data_40[15:0] <= density_reg190; 
               lut_Y_data_41[15:0] <= density_reg191; 
          end 
          191: begin 
               lut_Y_data_40[15:0] <= density_reg191; 
               lut_Y_data_41[15:0] <= density_reg192; 
          end 
          192: begin 
               lut_Y_data_40[15:0] <= density_reg192; 
               lut_Y_data_41[15:0] <= density_reg193; 
          end 
          193: begin 
               lut_Y_data_40[15:0] <= density_reg193; 
               lut_Y_data_41[15:0] <= density_reg194; 
          end 
          194: begin 
               lut_Y_data_40[15:0] <= density_reg194; 
               lut_Y_data_41[15:0] <= density_reg195; 
          end 
          195: begin 
               lut_Y_data_40[15:0] <= density_reg195; 
               lut_Y_data_41[15:0] <= density_reg196; 
          end 
          196: begin 
               lut_Y_data_40[15:0] <= density_reg196; 
               lut_Y_data_41[15:0] <= density_reg197; 
          end 
          197: begin 
               lut_Y_data_40[15:0] <= density_reg197; 
               lut_Y_data_41[15:0] <= density_reg198; 
          end 
          198: begin 
               lut_Y_data_40[15:0] <= density_reg198; 
               lut_Y_data_41[15:0] <= density_reg199; 
          end 
          199: begin 
               lut_Y_data_40[15:0] <= density_reg199; 
               lut_Y_data_41[15:0] <= density_reg200; 
          end 
          200: begin 
               lut_Y_data_40[15:0] <= density_reg200; 
               lut_Y_data_41[15:0] <= density_reg201; 
          end 
          201: begin 
               lut_Y_data_40[15:0] <= density_reg201; 
               lut_Y_data_41[15:0] <= density_reg202; 
          end 
          202: begin 
               lut_Y_data_40[15:0] <= density_reg202; 
               lut_Y_data_41[15:0] <= density_reg203; 
          end 
          203: begin 
               lut_Y_data_40[15:0] <= density_reg203; 
               lut_Y_data_41[15:0] <= density_reg204; 
          end 
          204: begin 
               lut_Y_data_40[15:0] <= density_reg204; 
               lut_Y_data_41[15:0] <= density_reg205; 
          end 
          205: begin 
               lut_Y_data_40[15:0] <= density_reg205; 
               lut_Y_data_41[15:0] <= density_reg206; 
          end 
          206: begin 
               lut_Y_data_40[15:0] <= density_reg206; 
               lut_Y_data_41[15:0] <= density_reg207; 
          end 
          207: begin 
               lut_Y_data_40[15:0] <= density_reg207; 
               lut_Y_data_41[15:0] <= density_reg208; 
          end 
          208: begin 
               lut_Y_data_40[15:0] <= density_reg208; 
               lut_Y_data_41[15:0] <= density_reg209; 
          end 
          209: begin 
               lut_Y_data_40[15:0] <= density_reg209; 
               lut_Y_data_41[15:0] <= density_reg210; 
          end 
          210: begin 
               lut_Y_data_40[15:0] <= density_reg210; 
               lut_Y_data_41[15:0] <= density_reg211; 
          end 
          211: begin 
               lut_Y_data_40[15:0] <= density_reg211; 
               lut_Y_data_41[15:0] <= density_reg212; 
          end 
          212: begin 
               lut_Y_data_40[15:0] <= density_reg212; 
               lut_Y_data_41[15:0] <= density_reg213; 
          end 
          213: begin 
               lut_Y_data_40[15:0] <= density_reg213; 
               lut_Y_data_41[15:0] <= density_reg214; 
          end 
          214: begin 
               lut_Y_data_40[15:0] <= density_reg214; 
               lut_Y_data_41[15:0] <= density_reg215; 
          end 
          215: begin 
               lut_Y_data_40[15:0] <= density_reg215; 
               lut_Y_data_41[15:0] <= density_reg216; 
          end 
          216: begin 
               lut_Y_data_40[15:0] <= density_reg216; 
               lut_Y_data_41[15:0] <= density_reg217; 
          end 
          217: begin 
               lut_Y_data_40[15:0] <= density_reg217; 
               lut_Y_data_41[15:0] <= density_reg218; 
          end 
          218: begin 
               lut_Y_data_40[15:0] <= density_reg218; 
               lut_Y_data_41[15:0] <= density_reg219; 
          end 
          219: begin 
               lut_Y_data_40[15:0] <= density_reg219; 
               lut_Y_data_41[15:0] <= density_reg220; 
          end 
          220: begin 
               lut_Y_data_40[15:0] <= density_reg220; 
               lut_Y_data_41[15:0] <= density_reg221; 
          end 
          221: begin 
               lut_Y_data_40[15:0] <= density_reg221; 
               lut_Y_data_41[15:0] <= density_reg222; 
          end 
          222: begin 
               lut_Y_data_40[15:0] <= density_reg222; 
               lut_Y_data_41[15:0] <= density_reg223; 
          end 
          223: begin 
               lut_Y_data_40[15:0] <= density_reg223; 
               lut_Y_data_41[15:0] <= density_reg224; 
          end 
          224: begin 
               lut_Y_data_40[15:0] <= density_reg224; 
               lut_Y_data_41[15:0] <= density_reg225; 
          end 
          225: begin 
               lut_Y_data_40[15:0] <= density_reg225; 
               lut_Y_data_41[15:0] <= density_reg226; 
          end 
          226: begin 
               lut_Y_data_40[15:0] <= density_reg226; 
               lut_Y_data_41[15:0] <= density_reg227; 
          end 
          227: begin 
               lut_Y_data_40[15:0] <= density_reg227; 
               lut_Y_data_41[15:0] <= density_reg228; 
          end 
          228: begin 
               lut_Y_data_40[15:0] <= density_reg228; 
               lut_Y_data_41[15:0] <= density_reg229; 
          end 
          229: begin 
               lut_Y_data_40[15:0] <= density_reg229; 
               lut_Y_data_41[15:0] <= density_reg230; 
          end 
          230: begin 
               lut_Y_data_40[15:0] <= density_reg230; 
               lut_Y_data_41[15:0] <= density_reg231; 
          end 
          231: begin 
               lut_Y_data_40[15:0] <= density_reg231; 
               lut_Y_data_41[15:0] <= density_reg232; 
          end 
          232: begin 
               lut_Y_data_40[15:0] <= density_reg232; 
               lut_Y_data_41[15:0] <= density_reg233; 
          end 
          233: begin 
               lut_Y_data_40[15:0] <= density_reg233; 
               lut_Y_data_41[15:0] <= density_reg234; 
          end 
          234: begin 
               lut_Y_data_40[15:0] <= density_reg234; 
               lut_Y_data_41[15:0] <= density_reg235; 
          end 
          235: begin 
               lut_Y_data_40[15:0] <= density_reg235; 
               lut_Y_data_41[15:0] <= density_reg236; 
          end 
          236: begin 
               lut_Y_data_40[15:0] <= density_reg236; 
               lut_Y_data_41[15:0] <= density_reg237; 
          end 
          237: begin 
               lut_Y_data_40[15:0] <= density_reg237; 
               lut_Y_data_41[15:0] <= density_reg238; 
          end 
          238: begin 
               lut_Y_data_40[15:0] <= density_reg238; 
               lut_Y_data_41[15:0] <= density_reg239; 
          end 
          239: begin 
               lut_Y_data_40[15:0] <= density_reg239; 
               lut_Y_data_41[15:0] <= density_reg240; 
          end 
          240: begin 
               lut_Y_data_40[15:0] <= density_reg240; 
               lut_Y_data_41[15:0] <= density_reg241; 
          end 
          241: begin 
               lut_Y_data_40[15:0] <= density_reg241; 
               lut_Y_data_41[15:0] <= density_reg242; 
          end 
          242: begin 
               lut_Y_data_40[15:0] <= density_reg242; 
               lut_Y_data_41[15:0] <= density_reg243; 
          end 
          243: begin 
               lut_Y_data_40[15:0] <= density_reg243; 
               lut_Y_data_41[15:0] <= density_reg244; 
          end 
          244: begin 
               lut_Y_data_40[15:0] <= density_reg244; 
               lut_Y_data_41[15:0] <= density_reg245; 
          end 
          245: begin 
               lut_Y_data_40[15:0] <= density_reg245; 
               lut_Y_data_41[15:0] <= density_reg246; 
          end 
          246: begin 
               lut_Y_data_40[15:0] <= density_reg246; 
               lut_Y_data_41[15:0] <= density_reg247; 
          end 
          247: begin 
               lut_Y_data_40[15:0] <= density_reg247; 
               lut_Y_data_41[15:0] <= density_reg248; 
          end 
          248: begin 
               lut_Y_data_40[15:0] <= density_reg248; 
               lut_Y_data_41[15:0] <= density_reg249; 
          end 
          249: begin 
               lut_Y_data_40[15:0] <= density_reg249; 
               lut_Y_data_41[15:0] <= density_reg250; 
          end 
          250: begin 
               lut_Y_data_40[15:0] <= density_reg250; 
               lut_Y_data_41[15:0] <= density_reg251; 
          end 
          251: begin 
               lut_Y_data_40[15:0] <= density_reg251; 
               lut_Y_data_41[15:0] <= density_reg252; 
          end 
          252: begin 
               lut_Y_data_40[15:0] <= density_reg252; 
               lut_Y_data_41[15:0] <= density_reg253; 
          end 
          253: begin 
               lut_Y_data_40[15:0] <= density_reg253; 
               lut_Y_data_41[15:0] <= density_reg254; 
          end 
          254: begin 
               lut_Y_data_40[15:0] <= density_reg254; 
               lut_Y_data_41[15:0] <= density_reg255; 
          end 
          255: begin 
               lut_Y_data_40[15:0] <= density_reg255; 
               lut_Y_data_41[15:0] <= density_reg256; 
          end 
          256: begin 
               lut_Y_data_40[15:0] <= density_reg256; 
               lut_Y_data_41[15:0] <= density_reg256; 
          end 
          default: begin 
            lut_Y_data_40[15:0] <= density_reg0; 
            lut_Y_data_41[15:0] <= density_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_Y_data_50[15:0] <= {16{1'b0}};
     lut_Y_data_51[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & int8_en & lut_Y_sel[5]) begin 
      if(dp2lut_Yinfo_5[16]) begin 
         lut_Y_data_50[15:0] <= density_reg0; 
         lut_Y_data_51[15:0] <= density_reg0; 
      end else if(dp2lut_Yinfo_5[17]) begin 
         lut_Y_data_50[15:0] <= density_reg256; 
         lut_Y_data_51[15:0] <= density_reg256; 
      end else begin 
        case(dp2lut_Y_entry_5[9:0]) 
          0: begin 
               lut_Y_data_50[15:0] <= density_reg0; 
               lut_Y_data_51[15:0] <= density_reg1; 
          end 
          1: begin 
               lut_Y_data_50[15:0] <= density_reg1; 
               lut_Y_data_51[15:0] <= density_reg2; 
          end 
          2: begin 
               lut_Y_data_50[15:0] <= density_reg2; 
               lut_Y_data_51[15:0] <= density_reg3; 
          end 
          3: begin 
               lut_Y_data_50[15:0] <= density_reg3; 
               lut_Y_data_51[15:0] <= density_reg4; 
          end 
          4: begin 
               lut_Y_data_50[15:0] <= density_reg4; 
               lut_Y_data_51[15:0] <= density_reg5; 
          end 
          5: begin 
               lut_Y_data_50[15:0] <= density_reg5; 
               lut_Y_data_51[15:0] <= density_reg6; 
          end 
          6: begin 
               lut_Y_data_50[15:0] <= density_reg6; 
               lut_Y_data_51[15:0] <= density_reg7; 
          end 
          7: begin 
               lut_Y_data_50[15:0] <= density_reg7; 
               lut_Y_data_51[15:0] <= density_reg8; 
          end 
          8: begin 
               lut_Y_data_50[15:0] <= density_reg8; 
               lut_Y_data_51[15:0] <= density_reg9; 
          end 
          9: begin 
               lut_Y_data_50[15:0] <= density_reg9; 
               lut_Y_data_51[15:0] <= density_reg10; 
          end 
          10: begin 
               lut_Y_data_50[15:0] <= density_reg10; 
               lut_Y_data_51[15:0] <= density_reg11; 
          end 
          11: begin 
               lut_Y_data_50[15:0] <= density_reg11; 
               lut_Y_data_51[15:0] <= density_reg12; 
          end 
          12: begin 
               lut_Y_data_50[15:0] <= density_reg12; 
               lut_Y_data_51[15:0] <= density_reg13; 
          end 
          13: begin 
               lut_Y_data_50[15:0] <= density_reg13; 
               lut_Y_data_51[15:0] <= density_reg14; 
          end 
          14: begin 
               lut_Y_data_50[15:0] <= density_reg14; 
               lut_Y_data_51[15:0] <= density_reg15; 
          end 
          15: begin 
               lut_Y_data_50[15:0] <= density_reg15; 
               lut_Y_data_51[15:0] <= density_reg16; 
          end 
          16: begin 
               lut_Y_data_50[15:0] <= density_reg16; 
               lut_Y_data_51[15:0] <= density_reg17; 
          end 
          17: begin 
               lut_Y_data_50[15:0] <= density_reg17; 
               lut_Y_data_51[15:0] <= density_reg18; 
          end 
          18: begin 
               lut_Y_data_50[15:0] <= density_reg18; 
               lut_Y_data_51[15:0] <= density_reg19; 
          end 
          19: begin 
               lut_Y_data_50[15:0] <= density_reg19; 
               lut_Y_data_51[15:0] <= density_reg20; 
          end 
          20: begin 
               lut_Y_data_50[15:0] <= density_reg20; 
               lut_Y_data_51[15:0] <= density_reg21; 
          end 
          21: begin 
               lut_Y_data_50[15:0] <= density_reg21; 
               lut_Y_data_51[15:0] <= density_reg22; 
          end 
          22: begin 
               lut_Y_data_50[15:0] <= density_reg22; 
               lut_Y_data_51[15:0] <= density_reg23; 
          end 
          23: begin 
               lut_Y_data_50[15:0] <= density_reg23; 
               lut_Y_data_51[15:0] <= density_reg24; 
          end 
          24: begin 
               lut_Y_data_50[15:0] <= density_reg24; 
               lut_Y_data_51[15:0] <= density_reg25; 
          end 
          25: begin 
               lut_Y_data_50[15:0] <= density_reg25; 
               lut_Y_data_51[15:0] <= density_reg26; 
          end 
          26: begin 
               lut_Y_data_50[15:0] <= density_reg26; 
               lut_Y_data_51[15:0] <= density_reg27; 
          end 
          27: begin 
               lut_Y_data_50[15:0] <= density_reg27; 
               lut_Y_data_51[15:0] <= density_reg28; 
          end 
          28: begin 
               lut_Y_data_50[15:0] <= density_reg28; 
               lut_Y_data_51[15:0] <= density_reg29; 
          end 
          29: begin 
               lut_Y_data_50[15:0] <= density_reg29; 
               lut_Y_data_51[15:0] <= density_reg30; 
          end 
          30: begin 
               lut_Y_data_50[15:0] <= density_reg30; 
               lut_Y_data_51[15:0] <= density_reg31; 
          end 
          31: begin 
               lut_Y_data_50[15:0] <= density_reg31; 
               lut_Y_data_51[15:0] <= density_reg32; 
          end 
          32: begin 
               lut_Y_data_50[15:0] <= density_reg32; 
               lut_Y_data_51[15:0] <= density_reg33; 
          end 
          33: begin 
               lut_Y_data_50[15:0] <= density_reg33; 
               lut_Y_data_51[15:0] <= density_reg34; 
          end 
          34: begin 
               lut_Y_data_50[15:0] <= density_reg34; 
               lut_Y_data_51[15:0] <= density_reg35; 
          end 
          35: begin 
               lut_Y_data_50[15:0] <= density_reg35; 
               lut_Y_data_51[15:0] <= density_reg36; 
          end 
          36: begin 
               lut_Y_data_50[15:0] <= density_reg36; 
               lut_Y_data_51[15:0] <= density_reg37; 
          end 
          37: begin 
               lut_Y_data_50[15:0] <= density_reg37; 
               lut_Y_data_51[15:0] <= density_reg38; 
          end 
          38: begin 
               lut_Y_data_50[15:0] <= density_reg38; 
               lut_Y_data_51[15:0] <= density_reg39; 
          end 
          39: begin 
               lut_Y_data_50[15:0] <= density_reg39; 
               lut_Y_data_51[15:0] <= density_reg40; 
          end 
          40: begin 
               lut_Y_data_50[15:0] <= density_reg40; 
               lut_Y_data_51[15:0] <= density_reg41; 
          end 
          41: begin 
               lut_Y_data_50[15:0] <= density_reg41; 
               lut_Y_data_51[15:0] <= density_reg42; 
          end 
          42: begin 
               lut_Y_data_50[15:0] <= density_reg42; 
               lut_Y_data_51[15:0] <= density_reg43; 
          end 
          43: begin 
               lut_Y_data_50[15:0] <= density_reg43; 
               lut_Y_data_51[15:0] <= density_reg44; 
          end 
          44: begin 
               lut_Y_data_50[15:0] <= density_reg44; 
               lut_Y_data_51[15:0] <= density_reg45; 
          end 
          45: begin 
               lut_Y_data_50[15:0] <= density_reg45; 
               lut_Y_data_51[15:0] <= density_reg46; 
          end 
          46: begin 
               lut_Y_data_50[15:0] <= density_reg46; 
               lut_Y_data_51[15:0] <= density_reg47; 
          end 
          47: begin 
               lut_Y_data_50[15:0] <= density_reg47; 
               lut_Y_data_51[15:0] <= density_reg48; 
          end 
          48: begin 
               lut_Y_data_50[15:0] <= density_reg48; 
               lut_Y_data_51[15:0] <= density_reg49; 
          end 
          49: begin 
               lut_Y_data_50[15:0] <= density_reg49; 
               lut_Y_data_51[15:0] <= density_reg50; 
          end 
          50: begin 
               lut_Y_data_50[15:0] <= density_reg50; 
               lut_Y_data_51[15:0] <= density_reg51; 
          end 
          51: begin 
               lut_Y_data_50[15:0] <= density_reg51; 
               lut_Y_data_51[15:0] <= density_reg52; 
          end 
          52: begin 
               lut_Y_data_50[15:0] <= density_reg52; 
               lut_Y_data_51[15:0] <= density_reg53; 
          end 
          53: begin 
               lut_Y_data_50[15:0] <= density_reg53; 
               lut_Y_data_51[15:0] <= density_reg54; 
          end 
          54: begin 
               lut_Y_data_50[15:0] <= density_reg54; 
               lut_Y_data_51[15:0] <= density_reg55; 
          end 
          55: begin 
               lut_Y_data_50[15:0] <= density_reg55; 
               lut_Y_data_51[15:0] <= density_reg56; 
          end 
          56: begin 
               lut_Y_data_50[15:0] <= density_reg56; 
               lut_Y_data_51[15:0] <= density_reg57; 
          end 
          57: begin 
               lut_Y_data_50[15:0] <= density_reg57; 
               lut_Y_data_51[15:0] <= density_reg58; 
          end 
          58: begin 
               lut_Y_data_50[15:0] <= density_reg58; 
               lut_Y_data_51[15:0] <= density_reg59; 
          end 
          59: begin 
               lut_Y_data_50[15:0] <= density_reg59; 
               lut_Y_data_51[15:0] <= density_reg60; 
          end 
          60: begin 
               lut_Y_data_50[15:0] <= density_reg60; 
               lut_Y_data_51[15:0] <= density_reg61; 
          end 
          61: begin 
               lut_Y_data_50[15:0] <= density_reg61; 
               lut_Y_data_51[15:0] <= density_reg62; 
          end 
          62: begin 
               lut_Y_data_50[15:0] <= density_reg62; 
               lut_Y_data_51[15:0] <= density_reg63; 
          end 
          63: begin 
               lut_Y_data_50[15:0] <= density_reg63; 
               lut_Y_data_51[15:0] <= density_reg64; 
          end 
          64: begin 
               lut_Y_data_50[15:0] <= density_reg64; 
               lut_Y_data_51[15:0] <= density_reg65; 
          end 
          65: begin 
               lut_Y_data_50[15:0] <= density_reg65; 
               lut_Y_data_51[15:0] <= density_reg66; 
          end 
          66: begin 
               lut_Y_data_50[15:0] <= density_reg66; 
               lut_Y_data_51[15:0] <= density_reg67; 
          end 
          67: begin 
               lut_Y_data_50[15:0] <= density_reg67; 
               lut_Y_data_51[15:0] <= density_reg68; 
          end 
          68: begin 
               lut_Y_data_50[15:0] <= density_reg68; 
               lut_Y_data_51[15:0] <= density_reg69; 
          end 
          69: begin 
               lut_Y_data_50[15:0] <= density_reg69; 
               lut_Y_data_51[15:0] <= density_reg70; 
          end 
          70: begin 
               lut_Y_data_50[15:0] <= density_reg70; 
               lut_Y_data_51[15:0] <= density_reg71; 
          end 
          71: begin 
               lut_Y_data_50[15:0] <= density_reg71; 
               lut_Y_data_51[15:0] <= density_reg72; 
          end 
          72: begin 
               lut_Y_data_50[15:0] <= density_reg72; 
               lut_Y_data_51[15:0] <= density_reg73; 
          end 
          73: begin 
               lut_Y_data_50[15:0] <= density_reg73; 
               lut_Y_data_51[15:0] <= density_reg74; 
          end 
          74: begin 
               lut_Y_data_50[15:0] <= density_reg74; 
               lut_Y_data_51[15:0] <= density_reg75; 
          end 
          75: begin 
               lut_Y_data_50[15:0] <= density_reg75; 
               lut_Y_data_51[15:0] <= density_reg76; 
          end 
          76: begin 
               lut_Y_data_50[15:0] <= density_reg76; 
               lut_Y_data_51[15:0] <= density_reg77; 
          end 
          77: begin 
               lut_Y_data_50[15:0] <= density_reg77; 
               lut_Y_data_51[15:0] <= density_reg78; 
          end 
          78: begin 
               lut_Y_data_50[15:0] <= density_reg78; 
               lut_Y_data_51[15:0] <= density_reg79; 
          end 
          79: begin 
               lut_Y_data_50[15:0] <= density_reg79; 
               lut_Y_data_51[15:0] <= density_reg80; 
          end 
          80: begin 
               lut_Y_data_50[15:0] <= density_reg80; 
               lut_Y_data_51[15:0] <= density_reg81; 
          end 
          81: begin 
               lut_Y_data_50[15:0] <= density_reg81; 
               lut_Y_data_51[15:0] <= density_reg82; 
          end 
          82: begin 
               lut_Y_data_50[15:0] <= density_reg82; 
               lut_Y_data_51[15:0] <= density_reg83; 
          end 
          83: begin 
               lut_Y_data_50[15:0] <= density_reg83; 
               lut_Y_data_51[15:0] <= density_reg84; 
          end 
          84: begin 
               lut_Y_data_50[15:0] <= density_reg84; 
               lut_Y_data_51[15:0] <= density_reg85; 
          end 
          85: begin 
               lut_Y_data_50[15:0] <= density_reg85; 
               lut_Y_data_51[15:0] <= density_reg86; 
          end 
          86: begin 
               lut_Y_data_50[15:0] <= density_reg86; 
               lut_Y_data_51[15:0] <= density_reg87; 
          end 
          87: begin 
               lut_Y_data_50[15:0] <= density_reg87; 
               lut_Y_data_51[15:0] <= density_reg88; 
          end 
          88: begin 
               lut_Y_data_50[15:0] <= density_reg88; 
               lut_Y_data_51[15:0] <= density_reg89; 
          end 
          89: begin 
               lut_Y_data_50[15:0] <= density_reg89; 
               lut_Y_data_51[15:0] <= density_reg90; 
          end 
          90: begin 
               lut_Y_data_50[15:0] <= density_reg90; 
               lut_Y_data_51[15:0] <= density_reg91; 
          end 
          91: begin 
               lut_Y_data_50[15:0] <= density_reg91; 
               lut_Y_data_51[15:0] <= density_reg92; 
          end 
          92: begin 
               lut_Y_data_50[15:0] <= density_reg92; 
               lut_Y_data_51[15:0] <= density_reg93; 
          end 
          93: begin 
               lut_Y_data_50[15:0] <= density_reg93; 
               lut_Y_data_51[15:0] <= density_reg94; 
          end 
          94: begin 
               lut_Y_data_50[15:0] <= density_reg94; 
               lut_Y_data_51[15:0] <= density_reg95; 
          end 
          95: begin 
               lut_Y_data_50[15:0] <= density_reg95; 
               lut_Y_data_51[15:0] <= density_reg96; 
          end 
          96: begin 
               lut_Y_data_50[15:0] <= density_reg96; 
               lut_Y_data_51[15:0] <= density_reg97; 
          end 
          97: begin 
               lut_Y_data_50[15:0] <= density_reg97; 
               lut_Y_data_51[15:0] <= density_reg98; 
          end 
          98: begin 
               lut_Y_data_50[15:0] <= density_reg98; 
               lut_Y_data_51[15:0] <= density_reg99; 
          end 
          99: begin 
               lut_Y_data_50[15:0] <= density_reg99; 
               lut_Y_data_51[15:0] <= density_reg100; 
          end 
          100: begin 
               lut_Y_data_50[15:0] <= density_reg100; 
               lut_Y_data_51[15:0] <= density_reg101; 
          end 
          101: begin 
               lut_Y_data_50[15:0] <= density_reg101; 
               lut_Y_data_51[15:0] <= density_reg102; 
          end 
          102: begin 
               lut_Y_data_50[15:0] <= density_reg102; 
               lut_Y_data_51[15:0] <= density_reg103; 
          end 
          103: begin 
               lut_Y_data_50[15:0] <= density_reg103; 
               lut_Y_data_51[15:0] <= density_reg104; 
          end 
          104: begin 
               lut_Y_data_50[15:0] <= density_reg104; 
               lut_Y_data_51[15:0] <= density_reg105; 
          end 
          105: begin 
               lut_Y_data_50[15:0] <= density_reg105; 
               lut_Y_data_51[15:0] <= density_reg106; 
          end 
          106: begin 
               lut_Y_data_50[15:0] <= density_reg106; 
               lut_Y_data_51[15:0] <= density_reg107; 
          end 
          107: begin 
               lut_Y_data_50[15:0] <= density_reg107; 
               lut_Y_data_51[15:0] <= density_reg108; 
          end 
          108: begin 
               lut_Y_data_50[15:0] <= density_reg108; 
               lut_Y_data_51[15:0] <= density_reg109; 
          end 
          109: begin 
               lut_Y_data_50[15:0] <= density_reg109; 
               lut_Y_data_51[15:0] <= density_reg110; 
          end 
          110: begin 
               lut_Y_data_50[15:0] <= density_reg110; 
               lut_Y_data_51[15:0] <= density_reg111; 
          end 
          111: begin 
               lut_Y_data_50[15:0] <= density_reg111; 
               lut_Y_data_51[15:0] <= density_reg112; 
          end 
          112: begin 
               lut_Y_data_50[15:0] <= density_reg112; 
               lut_Y_data_51[15:0] <= density_reg113; 
          end 
          113: begin 
               lut_Y_data_50[15:0] <= density_reg113; 
               lut_Y_data_51[15:0] <= density_reg114; 
          end 
          114: begin 
               lut_Y_data_50[15:0] <= density_reg114; 
               lut_Y_data_51[15:0] <= density_reg115; 
          end 
          115: begin 
               lut_Y_data_50[15:0] <= density_reg115; 
               lut_Y_data_51[15:0] <= density_reg116; 
          end 
          116: begin 
               lut_Y_data_50[15:0] <= density_reg116; 
               lut_Y_data_51[15:0] <= density_reg117; 
          end 
          117: begin 
               lut_Y_data_50[15:0] <= density_reg117; 
               lut_Y_data_51[15:0] <= density_reg118; 
          end 
          118: begin 
               lut_Y_data_50[15:0] <= density_reg118; 
               lut_Y_data_51[15:0] <= density_reg119; 
          end 
          119: begin 
               lut_Y_data_50[15:0] <= density_reg119; 
               lut_Y_data_51[15:0] <= density_reg120; 
          end 
          120: begin 
               lut_Y_data_50[15:0] <= density_reg120; 
               lut_Y_data_51[15:0] <= density_reg121; 
          end 
          121: begin 
               lut_Y_data_50[15:0] <= density_reg121; 
               lut_Y_data_51[15:0] <= density_reg122; 
          end 
          122: begin 
               lut_Y_data_50[15:0] <= density_reg122; 
               lut_Y_data_51[15:0] <= density_reg123; 
          end 
          123: begin 
               lut_Y_data_50[15:0] <= density_reg123; 
               lut_Y_data_51[15:0] <= density_reg124; 
          end 
          124: begin 
               lut_Y_data_50[15:0] <= density_reg124; 
               lut_Y_data_51[15:0] <= density_reg125; 
          end 
          125: begin 
               lut_Y_data_50[15:0] <= density_reg125; 
               lut_Y_data_51[15:0] <= density_reg126; 
          end 
          126: begin 
               lut_Y_data_50[15:0] <= density_reg126; 
               lut_Y_data_51[15:0] <= density_reg127; 
          end 
          127: begin 
               lut_Y_data_50[15:0] <= density_reg127; 
               lut_Y_data_51[15:0] <= density_reg128; 
          end 
          128: begin 
               lut_Y_data_50[15:0] <= density_reg128; 
               lut_Y_data_51[15:0] <= density_reg129; 
          end 
          129: begin 
               lut_Y_data_50[15:0] <= density_reg129; 
               lut_Y_data_51[15:0] <= density_reg130; 
          end 
          130: begin 
               lut_Y_data_50[15:0] <= density_reg130; 
               lut_Y_data_51[15:0] <= density_reg131; 
          end 
          131: begin 
               lut_Y_data_50[15:0] <= density_reg131; 
               lut_Y_data_51[15:0] <= density_reg132; 
          end 
          132: begin 
               lut_Y_data_50[15:0] <= density_reg132; 
               lut_Y_data_51[15:0] <= density_reg133; 
          end 
          133: begin 
               lut_Y_data_50[15:0] <= density_reg133; 
               lut_Y_data_51[15:0] <= density_reg134; 
          end 
          134: begin 
               lut_Y_data_50[15:0] <= density_reg134; 
               lut_Y_data_51[15:0] <= density_reg135; 
          end 
          135: begin 
               lut_Y_data_50[15:0] <= density_reg135; 
               lut_Y_data_51[15:0] <= density_reg136; 
          end 
          136: begin 
               lut_Y_data_50[15:0] <= density_reg136; 
               lut_Y_data_51[15:0] <= density_reg137; 
          end 
          137: begin 
               lut_Y_data_50[15:0] <= density_reg137; 
               lut_Y_data_51[15:0] <= density_reg138; 
          end 
          138: begin 
               lut_Y_data_50[15:0] <= density_reg138; 
               lut_Y_data_51[15:0] <= density_reg139; 
          end 
          139: begin 
               lut_Y_data_50[15:0] <= density_reg139; 
               lut_Y_data_51[15:0] <= density_reg140; 
          end 
          140: begin 
               lut_Y_data_50[15:0] <= density_reg140; 
               lut_Y_data_51[15:0] <= density_reg141; 
          end 
          141: begin 
               lut_Y_data_50[15:0] <= density_reg141; 
               lut_Y_data_51[15:0] <= density_reg142; 
          end 
          142: begin 
               lut_Y_data_50[15:0] <= density_reg142; 
               lut_Y_data_51[15:0] <= density_reg143; 
          end 
          143: begin 
               lut_Y_data_50[15:0] <= density_reg143; 
               lut_Y_data_51[15:0] <= density_reg144; 
          end 
          144: begin 
               lut_Y_data_50[15:0] <= density_reg144; 
               lut_Y_data_51[15:0] <= density_reg145; 
          end 
          145: begin 
               lut_Y_data_50[15:0] <= density_reg145; 
               lut_Y_data_51[15:0] <= density_reg146; 
          end 
          146: begin 
               lut_Y_data_50[15:0] <= density_reg146; 
               lut_Y_data_51[15:0] <= density_reg147; 
          end 
          147: begin 
               lut_Y_data_50[15:0] <= density_reg147; 
               lut_Y_data_51[15:0] <= density_reg148; 
          end 
          148: begin 
               lut_Y_data_50[15:0] <= density_reg148; 
               lut_Y_data_51[15:0] <= density_reg149; 
          end 
          149: begin 
               lut_Y_data_50[15:0] <= density_reg149; 
               lut_Y_data_51[15:0] <= density_reg150; 
          end 
          150: begin 
               lut_Y_data_50[15:0] <= density_reg150; 
               lut_Y_data_51[15:0] <= density_reg151; 
          end 
          151: begin 
               lut_Y_data_50[15:0] <= density_reg151; 
               lut_Y_data_51[15:0] <= density_reg152; 
          end 
          152: begin 
               lut_Y_data_50[15:0] <= density_reg152; 
               lut_Y_data_51[15:0] <= density_reg153; 
          end 
          153: begin 
               lut_Y_data_50[15:0] <= density_reg153; 
               lut_Y_data_51[15:0] <= density_reg154; 
          end 
          154: begin 
               lut_Y_data_50[15:0] <= density_reg154; 
               lut_Y_data_51[15:0] <= density_reg155; 
          end 
          155: begin 
               lut_Y_data_50[15:0] <= density_reg155; 
               lut_Y_data_51[15:0] <= density_reg156; 
          end 
          156: begin 
               lut_Y_data_50[15:0] <= density_reg156; 
               lut_Y_data_51[15:0] <= density_reg157; 
          end 
          157: begin 
               lut_Y_data_50[15:0] <= density_reg157; 
               lut_Y_data_51[15:0] <= density_reg158; 
          end 
          158: begin 
               lut_Y_data_50[15:0] <= density_reg158; 
               lut_Y_data_51[15:0] <= density_reg159; 
          end 
          159: begin 
               lut_Y_data_50[15:0] <= density_reg159; 
               lut_Y_data_51[15:0] <= density_reg160; 
          end 
          160: begin 
               lut_Y_data_50[15:0] <= density_reg160; 
               lut_Y_data_51[15:0] <= density_reg161; 
          end 
          161: begin 
               lut_Y_data_50[15:0] <= density_reg161; 
               lut_Y_data_51[15:0] <= density_reg162; 
          end 
          162: begin 
               lut_Y_data_50[15:0] <= density_reg162; 
               lut_Y_data_51[15:0] <= density_reg163; 
          end 
          163: begin 
               lut_Y_data_50[15:0] <= density_reg163; 
               lut_Y_data_51[15:0] <= density_reg164; 
          end 
          164: begin 
               lut_Y_data_50[15:0] <= density_reg164; 
               lut_Y_data_51[15:0] <= density_reg165; 
          end 
          165: begin 
               lut_Y_data_50[15:0] <= density_reg165; 
               lut_Y_data_51[15:0] <= density_reg166; 
          end 
          166: begin 
               lut_Y_data_50[15:0] <= density_reg166; 
               lut_Y_data_51[15:0] <= density_reg167; 
          end 
          167: begin 
               lut_Y_data_50[15:0] <= density_reg167; 
               lut_Y_data_51[15:0] <= density_reg168; 
          end 
          168: begin 
               lut_Y_data_50[15:0] <= density_reg168; 
               lut_Y_data_51[15:0] <= density_reg169; 
          end 
          169: begin 
               lut_Y_data_50[15:0] <= density_reg169; 
               lut_Y_data_51[15:0] <= density_reg170; 
          end 
          170: begin 
               lut_Y_data_50[15:0] <= density_reg170; 
               lut_Y_data_51[15:0] <= density_reg171; 
          end 
          171: begin 
               lut_Y_data_50[15:0] <= density_reg171; 
               lut_Y_data_51[15:0] <= density_reg172; 
          end 
          172: begin 
               lut_Y_data_50[15:0] <= density_reg172; 
               lut_Y_data_51[15:0] <= density_reg173; 
          end 
          173: begin 
               lut_Y_data_50[15:0] <= density_reg173; 
               lut_Y_data_51[15:0] <= density_reg174; 
          end 
          174: begin 
               lut_Y_data_50[15:0] <= density_reg174; 
               lut_Y_data_51[15:0] <= density_reg175; 
          end 
          175: begin 
               lut_Y_data_50[15:0] <= density_reg175; 
               lut_Y_data_51[15:0] <= density_reg176; 
          end 
          176: begin 
               lut_Y_data_50[15:0] <= density_reg176; 
               lut_Y_data_51[15:0] <= density_reg177; 
          end 
          177: begin 
               lut_Y_data_50[15:0] <= density_reg177; 
               lut_Y_data_51[15:0] <= density_reg178; 
          end 
          178: begin 
               lut_Y_data_50[15:0] <= density_reg178; 
               lut_Y_data_51[15:0] <= density_reg179; 
          end 
          179: begin 
               lut_Y_data_50[15:0] <= density_reg179; 
               lut_Y_data_51[15:0] <= density_reg180; 
          end 
          180: begin 
               lut_Y_data_50[15:0] <= density_reg180; 
               lut_Y_data_51[15:0] <= density_reg181; 
          end 
          181: begin 
               lut_Y_data_50[15:0] <= density_reg181; 
               lut_Y_data_51[15:0] <= density_reg182; 
          end 
          182: begin 
               lut_Y_data_50[15:0] <= density_reg182; 
               lut_Y_data_51[15:0] <= density_reg183; 
          end 
          183: begin 
               lut_Y_data_50[15:0] <= density_reg183; 
               lut_Y_data_51[15:0] <= density_reg184; 
          end 
          184: begin 
               lut_Y_data_50[15:0] <= density_reg184; 
               lut_Y_data_51[15:0] <= density_reg185; 
          end 
          185: begin 
               lut_Y_data_50[15:0] <= density_reg185; 
               lut_Y_data_51[15:0] <= density_reg186; 
          end 
          186: begin 
               lut_Y_data_50[15:0] <= density_reg186; 
               lut_Y_data_51[15:0] <= density_reg187; 
          end 
          187: begin 
               lut_Y_data_50[15:0] <= density_reg187; 
               lut_Y_data_51[15:0] <= density_reg188; 
          end 
          188: begin 
               lut_Y_data_50[15:0] <= density_reg188; 
               lut_Y_data_51[15:0] <= density_reg189; 
          end 
          189: begin 
               lut_Y_data_50[15:0] <= density_reg189; 
               lut_Y_data_51[15:0] <= density_reg190; 
          end 
          190: begin 
               lut_Y_data_50[15:0] <= density_reg190; 
               lut_Y_data_51[15:0] <= density_reg191; 
          end 
          191: begin 
               lut_Y_data_50[15:0] <= density_reg191; 
               lut_Y_data_51[15:0] <= density_reg192; 
          end 
          192: begin 
               lut_Y_data_50[15:0] <= density_reg192; 
               lut_Y_data_51[15:0] <= density_reg193; 
          end 
          193: begin 
               lut_Y_data_50[15:0] <= density_reg193; 
               lut_Y_data_51[15:0] <= density_reg194; 
          end 
          194: begin 
               lut_Y_data_50[15:0] <= density_reg194; 
               lut_Y_data_51[15:0] <= density_reg195; 
          end 
          195: begin 
               lut_Y_data_50[15:0] <= density_reg195; 
               lut_Y_data_51[15:0] <= density_reg196; 
          end 
          196: begin 
               lut_Y_data_50[15:0] <= density_reg196; 
               lut_Y_data_51[15:0] <= density_reg197; 
          end 
          197: begin 
               lut_Y_data_50[15:0] <= density_reg197; 
               lut_Y_data_51[15:0] <= density_reg198; 
          end 
          198: begin 
               lut_Y_data_50[15:0] <= density_reg198; 
               lut_Y_data_51[15:0] <= density_reg199; 
          end 
          199: begin 
               lut_Y_data_50[15:0] <= density_reg199; 
               lut_Y_data_51[15:0] <= density_reg200; 
          end 
          200: begin 
               lut_Y_data_50[15:0] <= density_reg200; 
               lut_Y_data_51[15:0] <= density_reg201; 
          end 
          201: begin 
               lut_Y_data_50[15:0] <= density_reg201; 
               lut_Y_data_51[15:0] <= density_reg202; 
          end 
          202: begin 
               lut_Y_data_50[15:0] <= density_reg202; 
               lut_Y_data_51[15:0] <= density_reg203; 
          end 
          203: begin 
               lut_Y_data_50[15:0] <= density_reg203; 
               lut_Y_data_51[15:0] <= density_reg204; 
          end 
          204: begin 
               lut_Y_data_50[15:0] <= density_reg204; 
               lut_Y_data_51[15:0] <= density_reg205; 
          end 
          205: begin 
               lut_Y_data_50[15:0] <= density_reg205; 
               lut_Y_data_51[15:0] <= density_reg206; 
          end 
          206: begin 
               lut_Y_data_50[15:0] <= density_reg206; 
               lut_Y_data_51[15:0] <= density_reg207; 
          end 
          207: begin 
               lut_Y_data_50[15:0] <= density_reg207; 
               lut_Y_data_51[15:0] <= density_reg208; 
          end 
          208: begin 
               lut_Y_data_50[15:0] <= density_reg208; 
               lut_Y_data_51[15:0] <= density_reg209; 
          end 
          209: begin 
               lut_Y_data_50[15:0] <= density_reg209; 
               lut_Y_data_51[15:0] <= density_reg210; 
          end 
          210: begin 
               lut_Y_data_50[15:0] <= density_reg210; 
               lut_Y_data_51[15:0] <= density_reg211; 
          end 
          211: begin 
               lut_Y_data_50[15:0] <= density_reg211; 
               lut_Y_data_51[15:0] <= density_reg212; 
          end 
          212: begin 
               lut_Y_data_50[15:0] <= density_reg212; 
               lut_Y_data_51[15:0] <= density_reg213; 
          end 
          213: begin 
               lut_Y_data_50[15:0] <= density_reg213; 
               lut_Y_data_51[15:0] <= density_reg214; 
          end 
          214: begin 
               lut_Y_data_50[15:0] <= density_reg214; 
               lut_Y_data_51[15:0] <= density_reg215; 
          end 
          215: begin 
               lut_Y_data_50[15:0] <= density_reg215; 
               lut_Y_data_51[15:0] <= density_reg216; 
          end 
          216: begin 
               lut_Y_data_50[15:0] <= density_reg216; 
               lut_Y_data_51[15:0] <= density_reg217; 
          end 
          217: begin 
               lut_Y_data_50[15:0] <= density_reg217; 
               lut_Y_data_51[15:0] <= density_reg218; 
          end 
          218: begin 
               lut_Y_data_50[15:0] <= density_reg218; 
               lut_Y_data_51[15:0] <= density_reg219; 
          end 
          219: begin 
               lut_Y_data_50[15:0] <= density_reg219; 
               lut_Y_data_51[15:0] <= density_reg220; 
          end 
          220: begin 
               lut_Y_data_50[15:0] <= density_reg220; 
               lut_Y_data_51[15:0] <= density_reg221; 
          end 
          221: begin 
               lut_Y_data_50[15:0] <= density_reg221; 
               lut_Y_data_51[15:0] <= density_reg222; 
          end 
          222: begin 
               lut_Y_data_50[15:0] <= density_reg222; 
               lut_Y_data_51[15:0] <= density_reg223; 
          end 
          223: begin 
               lut_Y_data_50[15:0] <= density_reg223; 
               lut_Y_data_51[15:0] <= density_reg224; 
          end 
          224: begin 
               lut_Y_data_50[15:0] <= density_reg224; 
               lut_Y_data_51[15:0] <= density_reg225; 
          end 
          225: begin 
               lut_Y_data_50[15:0] <= density_reg225; 
               lut_Y_data_51[15:0] <= density_reg226; 
          end 
          226: begin 
               lut_Y_data_50[15:0] <= density_reg226; 
               lut_Y_data_51[15:0] <= density_reg227; 
          end 
          227: begin 
               lut_Y_data_50[15:0] <= density_reg227; 
               lut_Y_data_51[15:0] <= density_reg228; 
          end 
          228: begin 
               lut_Y_data_50[15:0] <= density_reg228; 
               lut_Y_data_51[15:0] <= density_reg229; 
          end 
          229: begin 
               lut_Y_data_50[15:0] <= density_reg229; 
               lut_Y_data_51[15:0] <= density_reg230; 
          end 
          230: begin 
               lut_Y_data_50[15:0] <= density_reg230; 
               lut_Y_data_51[15:0] <= density_reg231; 
          end 
          231: begin 
               lut_Y_data_50[15:0] <= density_reg231; 
               lut_Y_data_51[15:0] <= density_reg232; 
          end 
          232: begin 
               lut_Y_data_50[15:0] <= density_reg232; 
               lut_Y_data_51[15:0] <= density_reg233; 
          end 
          233: begin 
               lut_Y_data_50[15:0] <= density_reg233; 
               lut_Y_data_51[15:0] <= density_reg234; 
          end 
          234: begin 
               lut_Y_data_50[15:0] <= density_reg234; 
               lut_Y_data_51[15:0] <= density_reg235; 
          end 
          235: begin 
               lut_Y_data_50[15:0] <= density_reg235; 
               lut_Y_data_51[15:0] <= density_reg236; 
          end 
          236: begin 
               lut_Y_data_50[15:0] <= density_reg236; 
               lut_Y_data_51[15:0] <= density_reg237; 
          end 
          237: begin 
               lut_Y_data_50[15:0] <= density_reg237; 
               lut_Y_data_51[15:0] <= density_reg238; 
          end 
          238: begin 
               lut_Y_data_50[15:0] <= density_reg238; 
               lut_Y_data_51[15:0] <= density_reg239; 
          end 
          239: begin 
               lut_Y_data_50[15:0] <= density_reg239; 
               lut_Y_data_51[15:0] <= density_reg240; 
          end 
          240: begin 
               lut_Y_data_50[15:0] <= density_reg240; 
               lut_Y_data_51[15:0] <= density_reg241; 
          end 
          241: begin 
               lut_Y_data_50[15:0] <= density_reg241; 
               lut_Y_data_51[15:0] <= density_reg242; 
          end 
          242: begin 
               lut_Y_data_50[15:0] <= density_reg242; 
               lut_Y_data_51[15:0] <= density_reg243; 
          end 
          243: begin 
               lut_Y_data_50[15:0] <= density_reg243; 
               lut_Y_data_51[15:0] <= density_reg244; 
          end 
          244: begin 
               lut_Y_data_50[15:0] <= density_reg244; 
               lut_Y_data_51[15:0] <= density_reg245; 
          end 
          245: begin 
               lut_Y_data_50[15:0] <= density_reg245; 
               lut_Y_data_51[15:0] <= density_reg246; 
          end 
          246: begin 
               lut_Y_data_50[15:0] <= density_reg246; 
               lut_Y_data_51[15:0] <= density_reg247; 
          end 
          247: begin 
               lut_Y_data_50[15:0] <= density_reg247; 
               lut_Y_data_51[15:0] <= density_reg248; 
          end 
          248: begin 
               lut_Y_data_50[15:0] <= density_reg248; 
               lut_Y_data_51[15:0] <= density_reg249; 
          end 
          249: begin 
               lut_Y_data_50[15:0] <= density_reg249; 
               lut_Y_data_51[15:0] <= density_reg250; 
          end 
          250: begin 
               lut_Y_data_50[15:0] <= density_reg250; 
               lut_Y_data_51[15:0] <= density_reg251; 
          end 
          251: begin 
               lut_Y_data_50[15:0] <= density_reg251; 
               lut_Y_data_51[15:0] <= density_reg252; 
          end 
          252: begin 
               lut_Y_data_50[15:0] <= density_reg252; 
               lut_Y_data_51[15:0] <= density_reg253; 
          end 
          253: begin 
               lut_Y_data_50[15:0] <= density_reg253; 
               lut_Y_data_51[15:0] <= density_reg254; 
          end 
          254: begin 
               lut_Y_data_50[15:0] <= density_reg254; 
               lut_Y_data_51[15:0] <= density_reg255; 
          end 
          255: begin 
               lut_Y_data_50[15:0] <= density_reg255; 
               lut_Y_data_51[15:0] <= density_reg256; 
          end 
          256: begin 
               lut_Y_data_50[15:0] <= density_reg256; 
               lut_Y_data_51[15:0] <= density_reg256; 
          end 
          default: begin 
            lut_Y_data_50[15:0] <= density_reg0; 
            lut_Y_data_51[15:0] <= density_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_Y_data_60[15:0] <= {16{1'b0}};
     lut_Y_data_61[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & int8_en & lut_Y_sel[6]) begin 
      if(dp2lut_Yinfo_6[16]) begin 
         lut_Y_data_60[15:0] <= density_reg0; 
         lut_Y_data_61[15:0] <= density_reg0; 
      end else if(dp2lut_Yinfo_6[17]) begin 
         lut_Y_data_60[15:0] <= density_reg256; 
         lut_Y_data_61[15:0] <= density_reg256; 
      end else begin 
        case(dp2lut_Y_entry_6[9:0]) 
          0: begin 
               lut_Y_data_60[15:0] <= density_reg0; 
               lut_Y_data_61[15:0] <= density_reg1; 
          end 
          1: begin 
               lut_Y_data_60[15:0] <= density_reg1; 
               lut_Y_data_61[15:0] <= density_reg2; 
          end 
          2: begin 
               lut_Y_data_60[15:0] <= density_reg2; 
               lut_Y_data_61[15:0] <= density_reg3; 
          end 
          3: begin 
               lut_Y_data_60[15:0] <= density_reg3; 
               lut_Y_data_61[15:0] <= density_reg4; 
          end 
          4: begin 
               lut_Y_data_60[15:0] <= density_reg4; 
               lut_Y_data_61[15:0] <= density_reg5; 
          end 
          5: begin 
               lut_Y_data_60[15:0] <= density_reg5; 
               lut_Y_data_61[15:0] <= density_reg6; 
          end 
          6: begin 
               lut_Y_data_60[15:0] <= density_reg6; 
               lut_Y_data_61[15:0] <= density_reg7; 
          end 
          7: begin 
               lut_Y_data_60[15:0] <= density_reg7; 
               lut_Y_data_61[15:0] <= density_reg8; 
          end 
          8: begin 
               lut_Y_data_60[15:0] <= density_reg8; 
               lut_Y_data_61[15:0] <= density_reg9; 
          end 
          9: begin 
               lut_Y_data_60[15:0] <= density_reg9; 
               lut_Y_data_61[15:0] <= density_reg10; 
          end 
          10: begin 
               lut_Y_data_60[15:0] <= density_reg10; 
               lut_Y_data_61[15:0] <= density_reg11; 
          end 
          11: begin 
               lut_Y_data_60[15:0] <= density_reg11; 
               lut_Y_data_61[15:0] <= density_reg12; 
          end 
          12: begin 
               lut_Y_data_60[15:0] <= density_reg12; 
               lut_Y_data_61[15:0] <= density_reg13; 
          end 
          13: begin 
               lut_Y_data_60[15:0] <= density_reg13; 
               lut_Y_data_61[15:0] <= density_reg14; 
          end 
          14: begin 
               lut_Y_data_60[15:0] <= density_reg14; 
               lut_Y_data_61[15:0] <= density_reg15; 
          end 
          15: begin 
               lut_Y_data_60[15:0] <= density_reg15; 
               lut_Y_data_61[15:0] <= density_reg16; 
          end 
          16: begin 
               lut_Y_data_60[15:0] <= density_reg16; 
               lut_Y_data_61[15:0] <= density_reg17; 
          end 
          17: begin 
               lut_Y_data_60[15:0] <= density_reg17; 
               lut_Y_data_61[15:0] <= density_reg18; 
          end 
          18: begin 
               lut_Y_data_60[15:0] <= density_reg18; 
               lut_Y_data_61[15:0] <= density_reg19; 
          end 
          19: begin 
               lut_Y_data_60[15:0] <= density_reg19; 
               lut_Y_data_61[15:0] <= density_reg20; 
          end 
          20: begin 
               lut_Y_data_60[15:0] <= density_reg20; 
               lut_Y_data_61[15:0] <= density_reg21; 
          end 
          21: begin 
               lut_Y_data_60[15:0] <= density_reg21; 
               lut_Y_data_61[15:0] <= density_reg22; 
          end 
          22: begin 
               lut_Y_data_60[15:0] <= density_reg22; 
               lut_Y_data_61[15:0] <= density_reg23; 
          end 
          23: begin 
               lut_Y_data_60[15:0] <= density_reg23; 
               lut_Y_data_61[15:0] <= density_reg24; 
          end 
          24: begin 
               lut_Y_data_60[15:0] <= density_reg24; 
               lut_Y_data_61[15:0] <= density_reg25; 
          end 
          25: begin 
               lut_Y_data_60[15:0] <= density_reg25; 
               lut_Y_data_61[15:0] <= density_reg26; 
          end 
          26: begin 
               lut_Y_data_60[15:0] <= density_reg26; 
               lut_Y_data_61[15:0] <= density_reg27; 
          end 
          27: begin 
               lut_Y_data_60[15:0] <= density_reg27; 
               lut_Y_data_61[15:0] <= density_reg28; 
          end 
          28: begin 
               lut_Y_data_60[15:0] <= density_reg28; 
               lut_Y_data_61[15:0] <= density_reg29; 
          end 
          29: begin 
               lut_Y_data_60[15:0] <= density_reg29; 
               lut_Y_data_61[15:0] <= density_reg30; 
          end 
          30: begin 
               lut_Y_data_60[15:0] <= density_reg30; 
               lut_Y_data_61[15:0] <= density_reg31; 
          end 
          31: begin 
               lut_Y_data_60[15:0] <= density_reg31; 
               lut_Y_data_61[15:0] <= density_reg32; 
          end 
          32: begin 
               lut_Y_data_60[15:0] <= density_reg32; 
               lut_Y_data_61[15:0] <= density_reg33; 
          end 
          33: begin 
               lut_Y_data_60[15:0] <= density_reg33; 
               lut_Y_data_61[15:0] <= density_reg34; 
          end 
          34: begin 
               lut_Y_data_60[15:0] <= density_reg34; 
               lut_Y_data_61[15:0] <= density_reg35; 
          end 
          35: begin 
               lut_Y_data_60[15:0] <= density_reg35; 
               lut_Y_data_61[15:0] <= density_reg36; 
          end 
          36: begin 
               lut_Y_data_60[15:0] <= density_reg36; 
               lut_Y_data_61[15:0] <= density_reg37; 
          end 
          37: begin 
               lut_Y_data_60[15:0] <= density_reg37; 
               lut_Y_data_61[15:0] <= density_reg38; 
          end 
          38: begin 
               lut_Y_data_60[15:0] <= density_reg38; 
               lut_Y_data_61[15:0] <= density_reg39; 
          end 
          39: begin 
               lut_Y_data_60[15:0] <= density_reg39; 
               lut_Y_data_61[15:0] <= density_reg40; 
          end 
          40: begin 
               lut_Y_data_60[15:0] <= density_reg40; 
               lut_Y_data_61[15:0] <= density_reg41; 
          end 
          41: begin 
               lut_Y_data_60[15:0] <= density_reg41; 
               lut_Y_data_61[15:0] <= density_reg42; 
          end 
          42: begin 
               lut_Y_data_60[15:0] <= density_reg42; 
               lut_Y_data_61[15:0] <= density_reg43; 
          end 
          43: begin 
               lut_Y_data_60[15:0] <= density_reg43; 
               lut_Y_data_61[15:0] <= density_reg44; 
          end 
          44: begin 
               lut_Y_data_60[15:0] <= density_reg44; 
               lut_Y_data_61[15:0] <= density_reg45; 
          end 
          45: begin 
               lut_Y_data_60[15:0] <= density_reg45; 
               lut_Y_data_61[15:0] <= density_reg46; 
          end 
          46: begin 
               lut_Y_data_60[15:0] <= density_reg46; 
               lut_Y_data_61[15:0] <= density_reg47; 
          end 
          47: begin 
               lut_Y_data_60[15:0] <= density_reg47; 
               lut_Y_data_61[15:0] <= density_reg48; 
          end 
          48: begin 
               lut_Y_data_60[15:0] <= density_reg48; 
               lut_Y_data_61[15:0] <= density_reg49; 
          end 
          49: begin 
               lut_Y_data_60[15:0] <= density_reg49; 
               lut_Y_data_61[15:0] <= density_reg50; 
          end 
          50: begin 
               lut_Y_data_60[15:0] <= density_reg50; 
               lut_Y_data_61[15:0] <= density_reg51; 
          end 
          51: begin 
               lut_Y_data_60[15:0] <= density_reg51; 
               lut_Y_data_61[15:0] <= density_reg52; 
          end 
          52: begin 
               lut_Y_data_60[15:0] <= density_reg52; 
               lut_Y_data_61[15:0] <= density_reg53; 
          end 
          53: begin 
               lut_Y_data_60[15:0] <= density_reg53; 
               lut_Y_data_61[15:0] <= density_reg54; 
          end 
          54: begin 
               lut_Y_data_60[15:0] <= density_reg54; 
               lut_Y_data_61[15:0] <= density_reg55; 
          end 
          55: begin 
               lut_Y_data_60[15:0] <= density_reg55; 
               lut_Y_data_61[15:0] <= density_reg56; 
          end 
          56: begin 
               lut_Y_data_60[15:0] <= density_reg56; 
               lut_Y_data_61[15:0] <= density_reg57; 
          end 
          57: begin 
               lut_Y_data_60[15:0] <= density_reg57; 
               lut_Y_data_61[15:0] <= density_reg58; 
          end 
          58: begin 
               lut_Y_data_60[15:0] <= density_reg58; 
               lut_Y_data_61[15:0] <= density_reg59; 
          end 
          59: begin 
               lut_Y_data_60[15:0] <= density_reg59; 
               lut_Y_data_61[15:0] <= density_reg60; 
          end 
          60: begin 
               lut_Y_data_60[15:0] <= density_reg60; 
               lut_Y_data_61[15:0] <= density_reg61; 
          end 
          61: begin 
               lut_Y_data_60[15:0] <= density_reg61; 
               lut_Y_data_61[15:0] <= density_reg62; 
          end 
          62: begin 
               lut_Y_data_60[15:0] <= density_reg62; 
               lut_Y_data_61[15:0] <= density_reg63; 
          end 
          63: begin 
               lut_Y_data_60[15:0] <= density_reg63; 
               lut_Y_data_61[15:0] <= density_reg64; 
          end 
          64: begin 
               lut_Y_data_60[15:0] <= density_reg64; 
               lut_Y_data_61[15:0] <= density_reg65; 
          end 
          65: begin 
               lut_Y_data_60[15:0] <= density_reg65; 
               lut_Y_data_61[15:0] <= density_reg66; 
          end 
          66: begin 
               lut_Y_data_60[15:0] <= density_reg66; 
               lut_Y_data_61[15:0] <= density_reg67; 
          end 
          67: begin 
               lut_Y_data_60[15:0] <= density_reg67; 
               lut_Y_data_61[15:0] <= density_reg68; 
          end 
          68: begin 
               lut_Y_data_60[15:0] <= density_reg68; 
               lut_Y_data_61[15:0] <= density_reg69; 
          end 
          69: begin 
               lut_Y_data_60[15:0] <= density_reg69; 
               lut_Y_data_61[15:0] <= density_reg70; 
          end 
          70: begin 
               lut_Y_data_60[15:0] <= density_reg70; 
               lut_Y_data_61[15:0] <= density_reg71; 
          end 
          71: begin 
               lut_Y_data_60[15:0] <= density_reg71; 
               lut_Y_data_61[15:0] <= density_reg72; 
          end 
          72: begin 
               lut_Y_data_60[15:0] <= density_reg72; 
               lut_Y_data_61[15:0] <= density_reg73; 
          end 
          73: begin 
               lut_Y_data_60[15:0] <= density_reg73; 
               lut_Y_data_61[15:0] <= density_reg74; 
          end 
          74: begin 
               lut_Y_data_60[15:0] <= density_reg74; 
               lut_Y_data_61[15:0] <= density_reg75; 
          end 
          75: begin 
               lut_Y_data_60[15:0] <= density_reg75; 
               lut_Y_data_61[15:0] <= density_reg76; 
          end 
          76: begin 
               lut_Y_data_60[15:0] <= density_reg76; 
               lut_Y_data_61[15:0] <= density_reg77; 
          end 
          77: begin 
               lut_Y_data_60[15:0] <= density_reg77; 
               lut_Y_data_61[15:0] <= density_reg78; 
          end 
          78: begin 
               lut_Y_data_60[15:0] <= density_reg78; 
               lut_Y_data_61[15:0] <= density_reg79; 
          end 
          79: begin 
               lut_Y_data_60[15:0] <= density_reg79; 
               lut_Y_data_61[15:0] <= density_reg80; 
          end 
          80: begin 
               lut_Y_data_60[15:0] <= density_reg80; 
               lut_Y_data_61[15:0] <= density_reg81; 
          end 
          81: begin 
               lut_Y_data_60[15:0] <= density_reg81; 
               lut_Y_data_61[15:0] <= density_reg82; 
          end 
          82: begin 
               lut_Y_data_60[15:0] <= density_reg82; 
               lut_Y_data_61[15:0] <= density_reg83; 
          end 
          83: begin 
               lut_Y_data_60[15:0] <= density_reg83; 
               lut_Y_data_61[15:0] <= density_reg84; 
          end 
          84: begin 
               lut_Y_data_60[15:0] <= density_reg84; 
               lut_Y_data_61[15:0] <= density_reg85; 
          end 
          85: begin 
               lut_Y_data_60[15:0] <= density_reg85; 
               lut_Y_data_61[15:0] <= density_reg86; 
          end 
          86: begin 
               lut_Y_data_60[15:0] <= density_reg86; 
               lut_Y_data_61[15:0] <= density_reg87; 
          end 
          87: begin 
               lut_Y_data_60[15:0] <= density_reg87; 
               lut_Y_data_61[15:0] <= density_reg88; 
          end 
          88: begin 
               lut_Y_data_60[15:0] <= density_reg88; 
               lut_Y_data_61[15:0] <= density_reg89; 
          end 
          89: begin 
               lut_Y_data_60[15:0] <= density_reg89; 
               lut_Y_data_61[15:0] <= density_reg90; 
          end 
          90: begin 
               lut_Y_data_60[15:0] <= density_reg90; 
               lut_Y_data_61[15:0] <= density_reg91; 
          end 
          91: begin 
               lut_Y_data_60[15:0] <= density_reg91; 
               lut_Y_data_61[15:0] <= density_reg92; 
          end 
          92: begin 
               lut_Y_data_60[15:0] <= density_reg92; 
               lut_Y_data_61[15:0] <= density_reg93; 
          end 
          93: begin 
               lut_Y_data_60[15:0] <= density_reg93; 
               lut_Y_data_61[15:0] <= density_reg94; 
          end 
          94: begin 
               lut_Y_data_60[15:0] <= density_reg94; 
               lut_Y_data_61[15:0] <= density_reg95; 
          end 
          95: begin 
               lut_Y_data_60[15:0] <= density_reg95; 
               lut_Y_data_61[15:0] <= density_reg96; 
          end 
          96: begin 
               lut_Y_data_60[15:0] <= density_reg96; 
               lut_Y_data_61[15:0] <= density_reg97; 
          end 
          97: begin 
               lut_Y_data_60[15:0] <= density_reg97; 
               lut_Y_data_61[15:0] <= density_reg98; 
          end 
          98: begin 
               lut_Y_data_60[15:0] <= density_reg98; 
               lut_Y_data_61[15:0] <= density_reg99; 
          end 
          99: begin 
               lut_Y_data_60[15:0] <= density_reg99; 
               lut_Y_data_61[15:0] <= density_reg100; 
          end 
          100: begin 
               lut_Y_data_60[15:0] <= density_reg100; 
               lut_Y_data_61[15:0] <= density_reg101; 
          end 
          101: begin 
               lut_Y_data_60[15:0] <= density_reg101; 
               lut_Y_data_61[15:0] <= density_reg102; 
          end 
          102: begin 
               lut_Y_data_60[15:0] <= density_reg102; 
               lut_Y_data_61[15:0] <= density_reg103; 
          end 
          103: begin 
               lut_Y_data_60[15:0] <= density_reg103; 
               lut_Y_data_61[15:0] <= density_reg104; 
          end 
          104: begin 
               lut_Y_data_60[15:0] <= density_reg104; 
               lut_Y_data_61[15:0] <= density_reg105; 
          end 
          105: begin 
               lut_Y_data_60[15:0] <= density_reg105; 
               lut_Y_data_61[15:0] <= density_reg106; 
          end 
          106: begin 
               lut_Y_data_60[15:0] <= density_reg106; 
               lut_Y_data_61[15:0] <= density_reg107; 
          end 
          107: begin 
               lut_Y_data_60[15:0] <= density_reg107; 
               lut_Y_data_61[15:0] <= density_reg108; 
          end 
          108: begin 
               lut_Y_data_60[15:0] <= density_reg108; 
               lut_Y_data_61[15:0] <= density_reg109; 
          end 
          109: begin 
               lut_Y_data_60[15:0] <= density_reg109; 
               lut_Y_data_61[15:0] <= density_reg110; 
          end 
          110: begin 
               lut_Y_data_60[15:0] <= density_reg110; 
               lut_Y_data_61[15:0] <= density_reg111; 
          end 
          111: begin 
               lut_Y_data_60[15:0] <= density_reg111; 
               lut_Y_data_61[15:0] <= density_reg112; 
          end 
          112: begin 
               lut_Y_data_60[15:0] <= density_reg112; 
               lut_Y_data_61[15:0] <= density_reg113; 
          end 
          113: begin 
               lut_Y_data_60[15:0] <= density_reg113; 
               lut_Y_data_61[15:0] <= density_reg114; 
          end 
          114: begin 
               lut_Y_data_60[15:0] <= density_reg114; 
               lut_Y_data_61[15:0] <= density_reg115; 
          end 
          115: begin 
               lut_Y_data_60[15:0] <= density_reg115; 
               lut_Y_data_61[15:0] <= density_reg116; 
          end 
          116: begin 
               lut_Y_data_60[15:0] <= density_reg116; 
               lut_Y_data_61[15:0] <= density_reg117; 
          end 
          117: begin 
               lut_Y_data_60[15:0] <= density_reg117; 
               lut_Y_data_61[15:0] <= density_reg118; 
          end 
          118: begin 
               lut_Y_data_60[15:0] <= density_reg118; 
               lut_Y_data_61[15:0] <= density_reg119; 
          end 
          119: begin 
               lut_Y_data_60[15:0] <= density_reg119; 
               lut_Y_data_61[15:0] <= density_reg120; 
          end 
          120: begin 
               lut_Y_data_60[15:0] <= density_reg120; 
               lut_Y_data_61[15:0] <= density_reg121; 
          end 
          121: begin 
               lut_Y_data_60[15:0] <= density_reg121; 
               lut_Y_data_61[15:0] <= density_reg122; 
          end 
          122: begin 
               lut_Y_data_60[15:0] <= density_reg122; 
               lut_Y_data_61[15:0] <= density_reg123; 
          end 
          123: begin 
               lut_Y_data_60[15:0] <= density_reg123; 
               lut_Y_data_61[15:0] <= density_reg124; 
          end 
          124: begin 
               lut_Y_data_60[15:0] <= density_reg124; 
               lut_Y_data_61[15:0] <= density_reg125; 
          end 
          125: begin 
               lut_Y_data_60[15:0] <= density_reg125; 
               lut_Y_data_61[15:0] <= density_reg126; 
          end 
          126: begin 
               lut_Y_data_60[15:0] <= density_reg126; 
               lut_Y_data_61[15:0] <= density_reg127; 
          end 
          127: begin 
               lut_Y_data_60[15:0] <= density_reg127; 
               lut_Y_data_61[15:0] <= density_reg128; 
          end 
          128: begin 
               lut_Y_data_60[15:0] <= density_reg128; 
               lut_Y_data_61[15:0] <= density_reg129; 
          end 
          129: begin 
               lut_Y_data_60[15:0] <= density_reg129; 
               lut_Y_data_61[15:0] <= density_reg130; 
          end 
          130: begin 
               lut_Y_data_60[15:0] <= density_reg130; 
               lut_Y_data_61[15:0] <= density_reg131; 
          end 
          131: begin 
               lut_Y_data_60[15:0] <= density_reg131; 
               lut_Y_data_61[15:0] <= density_reg132; 
          end 
          132: begin 
               lut_Y_data_60[15:0] <= density_reg132; 
               lut_Y_data_61[15:0] <= density_reg133; 
          end 
          133: begin 
               lut_Y_data_60[15:0] <= density_reg133; 
               lut_Y_data_61[15:0] <= density_reg134; 
          end 
          134: begin 
               lut_Y_data_60[15:0] <= density_reg134; 
               lut_Y_data_61[15:0] <= density_reg135; 
          end 
          135: begin 
               lut_Y_data_60[15:0] <= density_reg135; 
               lut_Y_data_61[15:0] <= density_reg136; 
          end 
          136: begin 
               lut_Y_data_60[15:0] <= density_reg136; 
               lut_Y_data_61[15:0] <= density_reg137; 
          end 
          137: begin 
               lut_Y_data_60[15:0] <= density_reg137; 
               lut_Y_data_61[15:0] <= density_reg138; 
          end 
          138: begin 
               lut_Y_data_60[15:0] <= density_reg138; 
               lut_Y_data_61[15:0] <= density_reg139; 
          end 
          139: begin 
               lut_Y_data_60[15:0] <= density_reg139; 
               lut_Y_data_61[15:0] <= density_reg140; 
          end 
          140: begin 
               lut_Y_data_60[15:0] <= density_reg140; 
               lut_Y_data_61[15:0] <= density_reg141; 
          end 
          141: begin 
               lut_Y_data_60[15:0] <= density_reg141; 
               lut_Y_data_61[15:0] <= density_reg142; 
          end 
          142: begin 
               lut_Y_data_60[15:0] <= density_reg142; 
               lut_Y_data_61[15:0] <= density_reg143; 
          end 
          143: begin 
               lut_Y_data_60[15:0] <= density_reg143; 
               lut_Y_data_61[15:0] <= density_reg144; 
          end 
          144: begin 
               lut_Y_data_60[15:0] <= density_reg144; 
               lut_Y_data_61[15:0] <= density_reg145; 
          end 
          145: begin 
               lut_Y_data_60[15:0] <= density_reg145; 
               lut_Y_data_61[15:0] <= density_reg146; 
          end 
          146: begin 
               lut_Y_data_60[15:0] <= density_reg146; 
               lut_Y_data_61[15:0] <= density_reg147; 
          end 
          147: begin 
               lut_Y_data_60[15:0] <= density_reg147; 
               lut_Y_data_61[15:0] <= density_reg148; 
          end 
          148: begin 
               lut_Y_data_60[15:0] <= density_reg148; 
               lut_Y_data_61[15:0] <= density_reg149; 
          end 
          149: begin 
               lut_Y_data_60[15:0] <= density_reg149; 
               lut_Y_data_61[15:0] <= density_reg150; 
          end 
          150: begin 
               lut_Y_data_60[15:0] <= density_reg150; 
               lut_Y_data_61[15:0] <= density_reg151; 
          end 
          151: begin 
               lut_Y_data_60[15:0] <= density_reg151; 
               lut_Y_data_61[15:0] <= density_reg152; 
          end 
          152: begin 
               lut_Y_data_60[15:0] <= density_reg152; 
               lut_Y_data_61[15:0] <= density_reg153; 
          end 
          153: begin 
               lut_Y_data_60[15:0] <= density_reg153; 
               lut_Y_data_61[15:0] <= density_reg154; 
          end 
          154: begin 
               lut_Y_data_60[15:0] <= density_reg154; 
               lut_Y_data_61[15:0] <= density_reg155; 
          end 
          155: begin 
               lut_Y_data_60[15:0] <= density_reg155; 
               lut_Y_data_61[15:0] <= density_reg156; 
          end 
          156: begin 
               lut_Y_data_60[15:0] <= density_reg156; 
               lut_Y_data_61[15:0] <= density_reg157; 
          end 
          157: begin 
               lut_Y_data_60[15:0] <= density_reg157; 
               lut_Y_data_61[15:0] <= density_reg158; 
          end 
          158: begin 
               lut_Y_data_60[15:0] <= density_reg158; 
               lut_Y_data_61[15:0] <= density_reg159; 
          end 
          159: begin 
               lut_Y_data_60[15:0] <= density_reg159; 
               lut_Y_data_61[15:0] <= density_reg160; 
          end 
          160: begin 
               lut_Y_data_60[15:0] <= density_reg160; 
               lut_Y_data_61[15:0] <= density_reg161; 
          end 
          161: begin 
               lut_Y_data_60[15:0] <= density_reg161; 
               lut_Y_data_61[15:0] <= density_reg162; 
          end 
          162: begin 
               lut_Y_data_60[15:0] <= density_reg162; 
               lut_Y_data_61[15:0] <= density_reg163; 
          end 
          163: begin 
               lut_Y_data_60[15:0] <= density_reg163; 
               lut_Y_data_61[15:0] <= density_reg164; 
          end 
          164: begin 
               lut_Y_data_60[15:0] <= density_reg164; 
               lut_Y_data_61[15:0] <= density_reg165; 
          end 
          165: begin 
               lut_Y_data_60[15:0] <= density_reg165; 
               lut_Y_data_61[15:0] <= density_reg166; 
          end 
          166: begin 
               lut_Y_data_60[15:0] <= density_reg166; 
               lut_Y_data_61[15:0] <= density_reg167; 
          end 
          167: begin 
               lut_Y_data_60[15:0] <= density_reg167; 
               lut_Y_data_61[15:0] <= density_reg168; 
          end 
          168: begin 
               lut_Y_data_60[15:0] <= density_reg168; 
               lut_Y_data_61[15:0] <= density_reg169; 
          end 
          169: begin 
               lut_Y_data_60[15:0] <= density_reg169; 
               lut_Y_data_61[15:0] <= density_reg170; 
          end 
          170: begin 
               lut_Y_data_60[15:0] <= density_reg170; 
               lut_Y_data_61[15:0] <= density_reg171; 
          end 
          171: begin 
               lut_Y_data_60[15:0] <= density_reg171; 
               lut_Y_data_61[15:0] <= density_reg172; 
          end 
          172: begin 
               lut_Y_data_60[15:0] <= density_reg172; 
               lut_Y_data_61[15:0] <= density_reg173; 
          end 
          173: begin 
               lut_Y_data_60[15:0] <= density_reg173; 
               lut_Y_data_61[15:0] <= density_reg174; 
          end 
          174: begin 
               lut_Y_data_60[15:0] <= density_reg174; 
               lut_Y_data_61[15:0] <= density_reg175; 
          end 
          175: begin 
               lut_Y_data_60[15:0] <= density_reg175; 
               lut_Y_data_61[15:0] <= density_reg176; 
          end 
          176: begin 
               lut_Y_data_60[15:0] <= density_reg176; 
               lut_Y_data_61[15:0] <= density_reg177; 
          end 
          177: begin 
               lut_Y_data_60[15:0] <= density_reg177; 
               lut_Y_data_61[15:0] <= density_reg178; 
          end 
          178: begin 
               lut_Y_data_60[15:0] <= density_reg178; 
               lut_Y_data_61[15:0] <= density_reg179; 
          end 
          179: begin 
               lut_Y_data_60[15:0] <= density_reg179; 
               lut_Y_data_61[15:0] <= density_reg180; 
          end 
          180: begin 
               lut_Y_data_60[15:0] <= density_reg180; 
               lut_Y_data_61[15:0] <= density_reg181; 
          end 
          181: begin 
               lut_Y_data_60[15:0] <= density_reg181; 
               lut_Y_data_61[15:0] <= density_reg182; 
          end 
          182: begin 
               lut_Y_data_60[15:0] <= density_reg182; 
               lut_Y_data_61[15:0] <= density_reg183; 
          end 
          183: begin 
               lut_Y_data_60[15:0] <= density_reg183; 
               lut_Y_data_61[15:0] <= density_reg184; 
          end 
          184: begin 
               lut_Y_data_60[15:0] <= density_reg184; 
               lut_Y_data_61[15:0] <= density_reg185; 
          end 
          185: begin 
               lut_Y_data_60[15:0] <= density_reg185; 
               lut_Y_data_61[15:0] <= density_reg186; 
          end 
          186: begin 
               lut_Y_data_60[15:0] <= density_reg186; 
               lut_Y_data_61[15:0] <= density_reg187; 
          end 
          187: begin 
               lut_Y_data_60[15:0] <= density_reg187; 
               lut_Y_data_61[15:0] <= density_reg188; 
          end 
          188: begin 
               lut_Y_data_60[15:0] <= density_reg188; 
               lut_Y_data_61[15:0] <= density_reg189; 
          end 
          189: begin 
               lut_Y_data_60[15:0] <= density_reg189; 
               lut_Y_data_61[15:0] <= density_reg190; 
          end 
          190: begin 
               lut_Y_data_60[15:0] <= density_reg190; 
               lut_Y_data_61[15:0] <= density_reg191; 
          end 
          191: begin 
               lut_Y_data_60[15:0] <= density_reg191; 
               lut_Y_data_61[15:0] <= density_reg192; 
          end 
          192: begin 
               lut_Y_data_60[15:0] <= density_reg192; 
               lut_Y_data_61[15:0] <= density_reg193; 
          end 
          193: begin 
               lut_Y_data_60[15:0] <= density_reg193; 
               lut_Y_data_61[15:0] <= density_reg194; 
          end 
          194: begin 
               lut_Y_data_60[15:0] <= density_reg194; 
               lut_Y_data_61[15:0] <= density_reg195; 
          end 
          195: begin 
               lut_Y_data_60[15:0] <= density_reg195; 
               lut_Y_data_61[15:0] <= density_reg196; 
          end 
          196: begin 
               lut_Y_data_60[15:0] <= density_reg196; 
               lut_Y_data_61[15:0] <= density_reg197; 
          end 
          197: begin 
               lut_Y_data_60[15:0] <= density_reg197; 
               lut_Y_data_61[15:0] <= density_reg198; 
          end 
          198: begin 
               lut_Y_data_60[15:0] <= density_reg198; 
               lut_Y_data_61[15:0] <= density_reg199; 
          end 
          199: begin 
               lut_Y_data_60[15:0] <= density_reg199; 
               lut_Y_data_61[15:0] <= density_reg200; 
          end 
          200: begin 
               lut_Y_data_60[15:0] <= density_reg200; 
               lut_Y_data_61[15:0] <= density_reg201; 
          end 
          201: begin 
               lut_Y_data_60[15:0] <= density_reg201; 
               lut_Y_data_61[15:0] <= density_reg202; 
          end 
          202: begin 
               lut_Y_data_60[15:0] <= density_reg202; 
               lut_Y_data_61[15:0] <= density_reg203; 
          end 
          203: begin 
               lut_Y_data_60[15:0] <= density_reg203; 
               lut_Y_data_61[15:0] <= density_reg204; 
          end 
          204: begin 
               lut_Y_data_60[15:0] <= density_reg204; 
               lut_Y_data_61[15:0] <= density_reg205; 
          end 
          205: begin 
               lut_Y_data_60[15:0] <= density_reg205; 
               lut_Y_data_61[15:0] <= density_reg206; 
          end 
          206: begin 
               lut_Y_data_60[15:0] <= density_reg206; 
               lut_Y_data_61[15:0] <= density_reg207; 
          end 
          207: begin 
               lut_Y_data_60[15:0] <= density_reg207; 
               lut_Y_data_61[15:0] <= density_reg208; 
          end 
          208: begin 
               lut_Y_data_60[15:0] <= density_reg208; 
               lut_Y_data_61[15:0] <= density_reg209; 
          end 
          209: begin 
               lut_Y_data_60[15:0] <= density_reg209; 
               lut_Y_data_61[15:0] <= density_reg210; 
          end 
          210: begin 
               lut_Y_data_60[15:0] <= density_reg210; 
               lut_Y_data_61[15:0] <= density_reg211; 
          end 
          211: begin 
               lut_Y_data_60[15:0] <= density_reg211; 
               lut_Y_data_61[15:0] <= density_reg212; 
          end 
          212: begin 
               lut_Y_data_60[15:0] <= density_reg212; 
               lut_Y_data_61[15:0] <= density_reg213; 
          end 
          213: begin 
               lut_Y_data_60[15:0] <= density_reg213; 
               lut_Y_data_61[15:0] <= density_reg214; 
          end 
          214: begin 
               lut_Y_data_60[15:0] <= density_reg214; 
               lut_Y_data_61[15:0] <= density_reg215; 
          end 
          215: begin 
               lut_Y_data_60[15:0] <= density_reg215; 
               lut_Y_data_61[15:0] <= density_reg216; 
          end 
          216: begin 
               lut_Y_data_60[15:0] <= density_reg216; 
               lut_Y_data_61[15:0] <= density_reg217; 
          end 
          217: begin 
               lut_Y_data_60[15:0] <= density_reg217; 
               lut_Y_data_61[15:0] <= density_reg218; 
          end 
          218: begin 
               lut_Y_data_60[15:0] <= density_reg218; 
               lut_Y_data_61[15:0] <= density_reg219; 
          end 
          219: begin 
               lut_Y_data_60[15:0] <= density_reg219; 
               lut_Y_data_61[15:0] <= density_reg220; 
          end 
          220: begin 
               lut_Y_data_60[15:0] <= density_reg220; 
               lut_Y_data_61[15:0] <= density_reg221; 
          end 
          221: begin 
               lut_Y_data_60[15:0] <= density_reg221; 
               lut_Y_data_61[15:0] <= density_reg222; 
          end 
          222: begin 
               lut_Y_data_60[15:0] <= density_reg222; 
               lut_Y_data_61[15:0] <= density_reg223; 
          end 
          223: begin 
               lut_Y_data_60[15:0] <= density_reg223; 
               lut_Y_data_61[15:0] <= density_reg224; 
          end 
          224: begin 
               lut_Y_data_60[15:0] <= density_reg224; 
               lut_Y_data_61[15:0] <= density_reg225; 
          end 
          225: begin 
               lut_Y_data_60[15:0] <= density_reg225; 
               lut_Y_data_61[15:0] <= density_reg226; 
          end 
          226: begin 
               lut_Y_data_60[15:0] <= density_reg226; 
               lut_Y_data_61[15:0] <= density_reg227; 
          end 
          227: begin 
               lut_Y_data_60[15:0] <= density_reg227; 
               lut_Y_data_61[15:0] <= density_reg228; 
          end 
          228: begin 
               lut_Y_data_60[15:0] <= density_reg228; 
               lut_Y_data_61[15:0] <= density_reg229; 
          end 
          229: begin 
               lut_Y_data_60[15:0] <= density_reg229; 
               lut_Y_data_61[15:0] <= density_reg230; 
          end 
          230: begin 
               lut_Y_data_60[15:0] <= density_reg230; 
               lut_Y_data_61[15:0] <= density_reg231; 
          end 
          231: begin 
               lut_Y_data_60[15:0] <= density_reg231; 
               lut_Y_data_61[15:0] <= density_reg232; 
          end 
          232: begin 
               lut_Y_data_60[15:0] <= density_reg232; 
               lut_Y_data_61[15:0] <= density_reg233; 
          end 
          233: begin 
               lut_Y_data_60[15:0] <= density_reg233; 
               lut_Y_data_61[15:0] <= density_reg234; 
          end 
          234: begin 
               lut_Y_data_60[15:0] <= density_reg234; 
               lut_Y_data_61[15:0] <= density_reg235; 
          end 
          235: begin 
               lut_Y_data_60[15:0] <= density_reg235; 
               lut_Y_data_61[15:0] <= density_reg236; 
          end 
          236: begin 
               lut_Y_data_60[15:0] <= density_reg236; 
               lut_Y_data_61[15:0] <= density_reg237; 
          end 
          237: begin 
               lut_Y_data_60[15:0] <= density_reg237; 
               lut_Y_data_61[15:0] <= density_reg238; 
          end 
          238: begin 
               lut_Y_data_60[15:0] <= density_reg238; 
               lut_Y_data_61[15:0] <= density_reg239; 
          end 
          239: begin 
               lut_Y_data_60[15:0] <= density_reg239; 
               lut_Y_data_61[15:0] <= density_reg240; 
          end 
          240: begin 
               lut_Y_data_60[15:0] <= density_reg240; 
               lut_Y_data_61[15:0] <= density_reg241; 
          end 
          241: begin 
               lut_Y_data_60[15:0] <= density_reg241; 
               lut_Y_data_61[15:0] <= density_reg242; 
          end 
          242: begin 
               lut_Y_data_60[15:0] <= density_reg242; 
               lut_Y_data_61[15:0] <= density_reg243; 
          end 
          243: begin 
               lut_Y_data_60[15:0] <= density_reg243; 
               lut_Y_data_61[15:0] <= density_reg244; 
          end 
          244: begin 
               lut_Y_data_60[15:0] <= density_reg244; 
               lut_Y_data_61[15:0] <= density_reg245; 
          end 
          245: begin 
               lut_Y_data_60[15:0] <= density_reg245; 
               lut_Y_data_61[15:0] <= density_reg246; 
          end 
          246: begin 
               lut_Y_data_60[15:0] <= density_reg246; 
               lut_Y_data_61[15:0] <= density_reg247; 
          end 
          247: begin 
               lut_Y_data_60[15:0] <= density_reg247; 
               lut_Y_data_61[15:0] <= density_reg248; 
          end 
          248: begin 
               lut_Y_data_60[15:0] <= density_reg248; 
               lut_Y_data_61[15:0] <= density_reg249; 
          end 
          249: begin 
               lut_Y_data_60[15:0] <= density_reg249; 
               lut_Y_data_61[15:0] <= density_reg250; 
          end 
          250: begin 
               lut_Y_data_60[15:0] <= density_reg250; 
               lut_Y_data_61[15:0] <= density_reg251; 
          end 
          251: begin 
               lut_Y_data_60[15:0] <= density_reg251; 
               lut_Y_data_61[15:0] <= density_reg252; 
          end 
          252: begin 
               lut_Y_data_60[15:0] <= density_reg252; 
               lut_Y_data_61[15:0] <= density_reg253; 
          end 
          253: begin 
               lut_Y_data_60[15:0] <= density_reg253; 
               lut_Y_data_61[15:0] <= density_reg254; 
          end 
          254: begin 
               lut_Y_data_60[15:0] <= density_reg254; 
               lut_Y_data_61[15:0] <= density_reg255; 
          end 
          255: begin 
               lut_Y_data_60[15:0] <= density_reg255; 
               lut_Y_data_61[15:0] <= density_reg256; 
          end 
          256: begin 
               lut_Y_data_60[15:0] <= density_reg256; 
               lut_Y_data_61[15:0] <= density_reg256; 
          end 
          default: begin 
            lut_Y_data_60[15:0] <= density_reg0; 
            lut_Y_data_61[15:0] <= density_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
 always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
   if (!nvdla_core_rstn) begin
     lut_Y_data_70[15:0] <= {16{1'b0}};
     lut_Y_data_71[15:0] <= {16{1'b0}};
   end else begin
   if(load_din & int8_en & lut_Y_sel[7]) begin 
      if(dp2lut_Yinfo_7[16]) begin 
         lut_Y_data_70[15:0] <= density_reg0; 
         lut_Y_data_71[15:0] <= density_reg0; 
      end else if(dp2lut_Yinfo_7[17]) begin 
         lut_Y_data_70[15:0] <= density_reg256; 
         lut_Y_data_71[15:0] <= density_reg256; 
      end else begin 
        case(dp2lut_Y_entry_7[9:0]) 
          0: begin 
               lut_Y_data_70[15:0] <= density_reg0; 
               lut_Y_data_71[15:0] <= density_reg1; 
          end 
          1: begin 
               lut_Y_data_70[15:0] <= density_reg1; 
               lut_Y_data_71[15:0] <= density_reg2; 
          end 
          2: begin 
               lut_Y_data_70[15:0] <= density_reg2; 
               lut_Y_data_71[15:0] <= density_reg3; 
          end 
          3: begin 
               lut_Y_data_70[15:0] <= density_reg3; 
               lut_Y_data_71[15:0] <= density_reg4; 
          end 
          4: begin 
               lut_Y_data_70[15:0] <= density_reg4; 
               lut_Y_data_71[15:0] <= density_reg5; 
          end 
          5: begin 
               lut_Y_data_70[15:0] <= density_reg5; 
               lut_Y_data_71[15:0] <= density_reg6; 
          end 
          6: begin 
               lut_Y_data_70[15:0] <= density_reg6; 
               lut_Y_data_71[15:0] <= density_reg7; 
          end 
          7: begin 
               lut_Y_data_70[15:0] <= density_reg7; 
               lut_Y_data_71[15:0] <= density_reg8; 
          end 
          8: begin 
               lut_Y_data_70[15:0] <= density_reg8; 
               lut_Y_data_71[15:0] <= density_reg9; 
          end 
          9: begin 
               lut_Y_data_70[15:0] <= density_reg9; 
               lut_Y_data_71[15:0] <= density_reg10; 
          end 
          10: begin 
               lut_Y_data_70[15:0] <= density_reg10; 
               lut_Y_data_71[15:0] <= density_reg11; 
          end 
          11: begin 
               lut_Y_data_70[15:0] <= density_reg11; 
               lut_Y_data_71[15:0] <= density_reg12; 
          end 
          12: begin 
               lut_Y_data_70[15:0] <= density_reg12; 
               lut_Y_data_71[15:0] <= density_reg13; 
          end 
          13: begin 
               lut_Y_data_70[15:0] <= density_reg13; 
               lut_Y_data_71[15:0] <= density_reg14; 
          end 
          14: begin 
               lut_Y_data_70[15:0] <= density_reg14; 
               lut_Y_data_71[15:0] <= density_reg15; 
          end 
          15: begin 
               lut_Y_data_70[15:0] <= density_reg15; 
               lut_Y_data_71[15:0] <= density_reg16; 
          end 
          16: begin 
               lut_Y_data_70[15:0] <= density_reg16; 
               lut_Y_data_71[15:0] <= density_reg17; 
          end 
          17: begin 
               lut_Y_data_70[15:0] <= density_reg17; 
               lut_Y_data_71[15:0] <= density_reg18; 
          end 
          18: begin 
               lut_Y_data_70[15:0] <= density_reg18; 
               lut_Y_data_71[15:0] <= density_reg19; 
          end 
          19: begin 
               lut_Y_data_70[15:0] <= density_reg19; 
               lut_Y_data_71[15:0] <= density_reg20; 
          end 
          20: begin 
               lut_Y_data_70[15:0] <= density_reg20; 
               lut_Y_data_71[15:0] <= density_reg21; 
          end 
          21: begin 
               lut_Y_data_70[15:0] <= density_reg21; 
               lut_Y_data_71[15:0] <= density_reg22; 
          end 
          22: begin 
               lut_Y_data_70[15:0] <= density_reg22; 
               lut_Y_data_71[15:0] <= density_reg23; 
          end 
          23: begin 
               lut_Y_data_70[15:0] <= density_reg23; 
               lut_Y_data_71[15:0] <= density_reg24; 
          end 
          24: begin 
               lut_Y_data_70[15:0] <= density_reg24; 
               lut_Y_data_71[15:0] <= density_reg25; 
          end 
          25: begin 
               lut_Y_data_70[15:0] <= density_reg25; 
               lut_Y_data_71[15:0] <= density_reg26; 
          end 
          26: begin 
               lut_Y_data_70[15:0] <= density_reg26; 
               lut_Y_data_71[15:0] <= density_reg27; 
          end 
          27: begin 
               lut_Y_data_70[15:0] <= density_reg27; 
               lut_Y_data_71[15:0] <= density_reg28; 
          end 
          28: begin 
               lut_Y_data_70[15:0] <= density_reg28; 
               lut_Y_data_71[15:0] <= density_reg29; 
          end 
          29: begin 
               lut_Y_data_70[15:0] <= density_reg29; 
               lut_Y_data_71[15:0] <= density_reg30; 
          end 
          30: begin 
               lut_Y_data_70[15:0] <= density_reg30; 
               lut_Y_data_71[15:0] <= density_reg31; 
          end 
          31: begin 
               lut_Y_data_70[15:0] <= density_reg31; 
               lut_Y_data_71[15:0] <= density_reg32; 
          end 
          32: begin 
               lut_Y_data_70[15:0] <= density_reg32; 
               lut_Y_data_71[15:0] <= density_reg33; 
          end 
          33: begin 
               lut_Y_data_70[15:0] <= density_reg33; 
               lut_Y_data_71[15:0] <= density_reg34; 
          end 
          34: begin 
               lut_Y_data_70[15:0] <= density_reg34; 
               lut_Y_data_71[15:0] <= density_reg35; 
          end 
          35: begin 
               lut_Y_data_70[15:0] <= density_reg35; 
               lut_Y_data_71[15:0] <= density_reg36; 
          end 
          36: begin 
               lut_Y_data_70[15:0] <= density_reg36; 
               lut_Y_data_71[15:0] <= density_reg37; 
          end 
          37: begin 
               lut_Y_data_70[15:0] <= density_reg37; 
               lut_Y_data_71[15:0] <= density_reg38; 
          end 
          38: begin 
               lut_Y_data_70[15:0] <= density_reg38; 
               lut_Y_data_71[15:0] <= density_reg39; 
          end 
          39: begin 
               lut_Y_data_70[15:0] <= density_reg39; 
               lut_Y_data_71[15:0] <= density_reg40; 
          end 
          40: begin 
               lut_Y_data_70[15:0] <= density_reg40; 
               lut_Y_data_71[15:0] <= density_reg41; 
          end 
          41: begin 
               lut_Y_data_70[15:0] <= density_reg41; 
               lut_Y_data_71[15:0] <= density_reg42; 
          end 
          42: begin 
               lut_Y_data_70[15:0] <= density_reg42; 
               lut_Y_data_71[15:0] <= density_reg43; 
          end 
          43: begin 
               lut_Y_data_70[15:0] <= density_reg43; 
               lut_Y_data_71[15:0] <= density_reg44; 
          end 
          44: begin 
               lut_Y_data_70[15:0] <= density_reg44; 
               lut_Y_data_71[15:0] <= density_reg45; 
          end 
          45: begin 
               lut_Y_data_70[15:0] <= density_reg45; 
               lut_Y_data_71[15:0] <= density_reg46; 
          end 
          46: begin 
               lut_Y_data_70[15:0] <= density_reg46; 
               lut_Y_data_71[15:0] <= density_reg47; 
          end 
          47: begin 
               lut_Y_data_70[15:0] <= density_reg47; 
               lut_Y_data_71[15:0] <= density_reg48; 
          end 
          48: begin 
               lut_Y_data_70[15:0] <= density_reg48; 
               lut_Y_data_71[15:0] <= density_reg49; 
          end 
          49: begin 
               lut_Y_data_70[15:0] <= density_reg49; 
               lut_Y_data_71[15:0] <= density_reg50; 
          end 
          50: begin 
               lut_Y_data_70[15:0] <= density_reg50; 
               lut_Y_data_71[15:0] <= density_reg51; 
          end 
          51: begin 
               lut_Y_data_70[15:0] <= density_reg51; 
               lut_Y_data_71[15:0] <= density_reg52; 
          end 
          52: begin 
               lut_Y_data_70[15:0] <= density_reg52; 
               lut_Y_data_71[15:0] <= density_reg53; 
          end 
          53: begin 
               lut_Y_data_70[15:0] <= density_reg53; 
               lut_Y_data_71[15:0] <= density_reg54; 
          end 
          54: begin 
               lut_Y_data_70[15:0] <= density_reg54; 
               lut_Y_data_71[15:0] <= density_reg55; 
          end 
          55: begin 
               lut_Y_data_70[15:0] <= density_reg55; 
               lut_Y_data_71[15:0] <= density_reg56; 
          end 
          56: begin 
               lut_Y_data_70[15:0] <= density_reg56; 
               lut_Y_data_71[15:0] <= density_reg57; 
          end 
          57: begin 
               lut_Y_data_70[15:0] <= density_reg57; 
               lut_Y_data_71[15:0] <= density_reg58; 
          end 
          58: begin 
               lut_Y_data_70[15:0] <= density_reg58; 
               lut_Y_data_71[15:0] <= density_reg59; 
          end 
          59: begin 
               lut_Y_data_70[15:0] <= density_reg59; 
               lut_Y_data_71[15:0] <= density_reg60; 
          end 
          60: begin 
               lut_Y_data_70[15:0] <= density_reg60; 
               lut_Y_data_71[15:0] <= density_reg61; 
          end 
          61: begin 
               lut_Y_data_70[15:0] <= density_reg61; 
               lut_Y_data_71[15:0] <= density_reg62; 
          end 
          62: begin 
               lut_Y_data_70[15:0] <= density_reg62; 
               lut_Y_data_71[15:0] <= density_reg63; 
          end 
          63: begin 
               lut_Y_data_70[15:0] <= density_reg63; 
               lut_Y_data_71[15:0] <= density_reg64; 
          end 
          64: begin 
               lut_Y_data_70[15:0] <= density_reg64; 
               lut_Y_data_71[15:0] <= density_reg65; 
          end 
          65: begin 
               lut_Y_data_70[15:0] <= density_reg65; 
               lut_Y_data_71[15:0] <= density_reg66; 
          end 
          66: begin 
               lut_Y_data_70[15:0] <= density_reg66; 
               lut_Y_data_71[15:0] <= density_reg67; 
          end 
          67: begin 
               lut_Y_data_70[15:0] <= density_reg67; 
               lut_Y_data_71[15:0] <= density_reg68; 
          end 
          68: begin 
               lut_Y_data_70[15:0] <= density_reg68; 
               lut_Y_data_71[15:0] <= density_reg69; 
          end 
          69: begin 
               lut_Y_data_70[15:0] <= density_reg69; 
               lut_Y_data_71[15:0] <= density_reg70; 
          end 
          70: begin 
               lut_Y_data_70[15:0] <= density_reg70; 
               lut_Y_data_71[15:0] <= density_reg71; 
          end 
          71: begin 
               lut_Y_data_70[15:0] <= density_reg71; 
               lut_Y_data_71[15:0] <= density_reg72; 
          end 
          72: begin 
               lut_Y_data_70[15:0] <= density_reg72; 
               lut_Y_data_71[15:0] <= density_reg73; 
          end 
          73: begin 
               lut_Y_data_70[15:0] <= density_reg73; 
               lut_Y_data_71[15:0] <= density_reg74; 
          end 
          74: begin 
               lut_Y_data_70[15:0] <= density_reg74; 
               lut_Y_data_71[15:0] <= density_reg75; 
          end 
          75: begin 
               lut_Y_data_70[15:0] <= density_reg75; 
               lut_Y_data_71[15:0] <= density_reg76; 
          end 
          76: begin 
               lut_Y_data_70[15:0] <= density_reg76; 
               lut_Y_data_71[15:0] <= density_reg77; 
          end 
          77: begin 
               lut_Y_data_70[15:0] <= density_reg77; 
               lut_Y_data_71[15:0] <= density_reg78; 
          end 
          78: begin 
               lut_Y_data_70[15:0] <= density_reg78; 
               lut_Y_data_71[15:0] <= density_reg79; 
          end 
          79: begin 
               lut_Y_data_70[15:0] <= density_reg79; 
               lut_Y_data_71[15:0] <= density_reg80; 
          end 
          80: begin 
               lut_Y_data_70[15:0] <= density_reg80; 
               lut_Y_data_71[15:0] <= density_reg81; 
          end 
          81: begin 
               lut_Y_data_70[15:0] <= density_reg81; 
               lut_Y_data_71[15:0] <= density_reg82; 
          end 
          82: begin 
               lut_Y_data_70[15:0] <= density_reg82; 
               lut_Y_data_71[15:0] <= density_reg83; 
          end 
          83: begin 
               lut_Y_data_70[15:0] <= density_reg83; 
               lut_Y_data_71[15:0] <= density_reg84; 
          end 
          84: begin 
               lut_Y_data_70[15:0] <= density_reg84; 
               lut_Y_data_71[15:0] <= density_reg85; 
          end 
          85: begin 
               lut_Y_data_70[15:0] <= density_reg85; 
               lut_Y_data_71[15:0] <= density_reg86; 
          end 
          86: begin 
               lut_Y_data_70[15:0] <= density_reg86; 
               lut_Y_data_71[15:0] <= density_reg87; 
          end 
          87: begin 
               lut_Y_data_70[15:0] <= density_reg87; 
               lut_Y_data_71[15:0] <= density_reg88; 
          end 
          88: begin 
               lut_Y_data_70[15:0] <= density_reg88; 
               lut_Y_data_71[15:0] <= density_reg89; 
          end 
          89: begin 
               lut_Y_data_70[15:0] <= density_reg89; 
               lut_Y_data_71[15:0] <= density_reg90; 
          end 
          90: begin 
               lut_Y_data_70[15:0] <= density_reg90; 
               lut_Y_data_71[15:0] <= density_reg91; 
          end 
          91: begin 
               lut_Y_data_70[15:0] <= density_reg91; 
               lut_Y_data_71[15:0] <= density_reg92; 
          end 
          92: begin 
               lut_Y_data_70[15:0] <= density_reg92; 
               lut_Y_data_71[15:0] <= density_reg93; 
          end 
          93: begin 
               lut_Y_data_70[15:0] <= density_reg93; 
               lut_Y_data_71[15:0] <= density_reg94; 
          end 
          94: begin 
               lut_Y_data_70[15:0] <= density_reg94; 
               lut_Y_data_71[15:0] <= density_reg95; 
          end 
          95: begin 
               lut_Y_data_70[15:0] <= density_reg95; 
               lut_Y_data_71[15:0] <= density_reg96; 
          end 
          96: begin 
               lut_Y_data_70[15:0] <= density_reg96; 
               lut_Y_data_71[15:0] <= density_reg97; 
          end 
          97: begin 
               lut_Y_data_70[15:0] <= density_reg97; 
               lut_Y_data_71[15:0] <= density_reg98; 
          end 
          98: begin 
               lut_Y_data_70[15:0] <= density_reg98; 
               lut_Y_data_71[15:0] <= density_reg99; 
          end 
          99: begin 
               lut_Y_data_70[15:0] <= density_reg99; 
               lut_Y_data_71[15:0] <= density_reg100; 
          end 
          100: begin 
               lut_Y_data_70[15:0] <= density_reg100; 
               lut_Y_data_71[15:0] <= density_reg101; 
          end 
          101: begin 
               lut_Y_data_70[15:0] <= density_reg101; 
               lut_Y_data_71[15:0] <= density_reg102; 
          end 
          102: begin 
               lut_Y_data_70[15:0] <= density_reg102; 
               lut_Y_data_71[15:0] <= density_reg103; 
          end 
          103: begin 
               lut_Y_data_70[15:0] <= density_reg103; 
               lut_Y_data_71[15:0] <= density_reg104; 
          end 
          104: begin 
               lut_Y_data_70[15:0] <= density_reg104; 
               lut_Y_data_71[15:0] <= density_reg105; 
          end 
          105: begin 
               lut_Y_data_70[15:0] <= density_reg105; 
               lut_Y_data_71[15:0] <= density_reg106; 
          end 
          106: begin 
               lut_Y_data_70[15:0] <= density_reg106; 
               lut_Y_data_71[15:0] <= density_reg107; 
          end 
          107: begin 
               lut_Y_data_70[15:0] <= density_reg107; 
               lut_Y_data_71[15:0] <= density_reg108; 
          end 
          108: begin 
               lut_Y_data_70[15:0] <= density_reg108; 
               lut_Y_data_71[15:0] <= density_reg109; 
          end 
          109: begin 
               lut_Y_data_70[15:0] <= density_reg109; 
               lut_Y_data_71[15:0] <= density_reg110; 
          end 
          110: begin 
               lut_Y_data_70[15:0] <= density_reg110; 
               lut_Y_data_71[15:0] <= density_reg111; 
          end 
          111: begin 
               lut_Y_data_70[15:0] <= density_reg111; 
               lut_Y_data_71[15:0] <= density_reg112; 
          end 
          112: begin 
               lut_Y_data_70[15:0] <= density_reg112; 
               lut_Y_data_71[15:0] <= density_reg113; 
          end 
          113: begin 
               lut_Y_data_70[15:0] <= density_reg113; 
               lut_Y_data_71[15:0] <= density_reg114; 
          end 
          114: begin 
               lut_Y_data_70[15:0] <= density_reg114; 
               lut_Y_data_71[15:0] <= density_reg115; 
          end 
          115: begin 
               lut_Y_data_70[15:0] <= density_reg115; 
               lut_Y_data_71[15:0] <= density_reg116; 
          end 
          116: begin 
               lut_Y_data_70[15:0] <= density_reg116; 
               lut_Y_data_71[15:0] <= density_reg117; 
          end 
          117: begin 
               lut_Y_data_70[15:0] <= density_reg117; 
               lut_Y_data_71[15:0] <= density_reg118; 
          end 
          118: begin 
               lut_Y_data_70[15:0] <= density_reg118; 
               lut_Y_data_71[15:0] <= density_reg119; 
          end 
          119: begin 
               lut_Y_data_70[15:0] <= density_reg119; 
               lut_Y_data_71[15:0] <= density_reg120; 
          end 
          120: begin 
               lut_Y_data_70[15:0] <= density_reg120; 
               lut_Y_data_71[15:0] <= density_reg121; 
          end 
          121: begin 
               lut_Y_data_70[15:0] <= density_reg121; 
               lut_Y_data_71[15:0] <= density_reg122; 
          end 
          122: begin 
               lut_Y_data_70[15:0] <= density_reg122; 
               lut_Y_data_71[15:0] <= density_reg123; 
          end 
          123: begin 
               lut_Y_data_70[15:0] <= density_reg123; 
               lut_Y_data_71[15:0] <= density_reg124; 
          end 
          124: begin 
               lut_Y_data_70[15:0] <= density_reg124; 
               lut_Y_data_71[15:0] <= density_reg125; 
          end 
          125: begin 
               lut_Y_data_70[15:0] <= density_reg125; 
               lut_Y_data_71[15:0] <= density_reg126; 
          end 
          126: begin 
               lut_Y_data_70[15:0] <= density_reg126; 
               lut_Y_data_71[15:0] <= density_reg127; 
          end 
          127: begin 
               lut_Y_data_70[15:0] <= density_reg127; 
               lut_Y_data_71[15:0] <= density_reg128; 
          end 
          128: begin 
               lut_Y_data_70[15:0] <= density_reg128; 
               lut_Y_data_71[15:0] <= density_reg129; 
          end 
          129: begin 
               lut_Y_data_70[15:0] <= density_reg129; 
               lut_Y_data_71[15:0] <= density_reg130; 
          end 
          130: begin 
               lut_Y_data_70[15:0] <= density_reg130; 
               lut_Y_data_71[15:0] <= density_reg131; 
          end 
          131: begin 
               lut_Y_data_70[15:0] <= density_reg131; 
               lut_Y_data_71[15:0] <= density_reg132; 
          end 
          132: begin 
               lut_Y_data_70[15:0] <= density_reg132; 
               lut_Y_data_71[15:0] <= density_reg133; 
          end 
          133: begin 
               lut_Y_data_70[15:0] <= density_reg133; 
               lut_Y_data_71[15:0] <= density_reg134; 
          end 
          134: begin 
               lut_Y_data_70[15:0] <= density_reg134; 
               lut_Y_data_71[15:0] <= density_reg135; 
          end 
          135: begin 
               lut_Y_data_70[15:0] <= density_reg135; 
               lut_Y_data_71[15:0] <= density_reg136; 
          end 
          136: begin 
               lut_Y_data_70[15:0] <= density_reg136; 
               lut_Y_data_71[15:0] <= density_reg137; 
          end 
          137: begin 
               lut_Y_data_70[15:0] <= density_reg137; 
               lut_Y_data_71[15:0] <= density_reg138; 
          end 
          138: begin 
               lut_Y_data_70[15:0] <= density_reg138; 
               lut_Y_data_71[15:0] <= density_reg139; 
          end 
          139: begin 
               lut_Y_data_70[15:0] <= density_reg139; 
               lut_Y_data_71[15:0] <= density_reg140; 
          end 
          140: begin 
               lut_Y_data_70[15:0] <= density_reg140; 
               lut_Y_data_71[15:0] <= density_reg141; 
          end 
          141: begin 
               lut_Y_data_70[15:0] <= density_reg141; 
               lut_Y_data_71[15:0] <= density_reg142; 
          end 
          142: begin 
               lut_Y_data_70[15:0] <= density_reg142; 
               lut_Y_data_71[15:0] <= density_reg143; 
          end 
          143: begin 
               lut_Y_data_70[15:0] <= density_reg143; 
               lut_Y_data_71[15:0] <= density_reg144; 
          end 
          144: begin 
               lut_Y_data_70[15:0] <= density_reg144; 
               lut_Y_data_71[15:0] <= density_reg145; 
          end 
          145: begin 
               lut_Y_data_70[15:0] <= density_reg145; 
               lut_Y_data_71[15:0] <= density_reg146; 
          end 
          146: begin 
               lut_Y_data_70[15:0] <= density_reg146; 
               lut_Y_data_71[15:0] <= density_reg147; 
          end 
          147: begin 
               lut_Y_data_70[15:0] <= density_reg147; 
               lut_Y_data_71[15:0] <= density_reg148; 
          end 
          148: begin 
               lut_Y_data_70[15:0] <= density_reg148; 
               lut_Y_data_71[15:0] <= density_reg149; 
          end 
          149: begin 
               lut_Y_data_70[15:0] <= density_reg149; 
               lut_Y_data_71[15:0] <= density_reg150; 
          end 
          150: begin 
               lut_Y_data_70[15:0] <= density_reg150; 
               lut_Y_data_71[15:0] <= density_reg151; 
          end 
          151: begin 
               lut_Y_data_70[15:0] <= density_reg151; 
               lut_Y_data_71[15:0] <= density_reg152; 
          end 
          152: begin 
               lut_Y_data_70[15:0] <= density_reg152; 
               lut_Y_data_71[15:0] <= density_reg153; 
          end 
          153: begin 
               lut_Y_data_70[15:0] <= density_reg153; 
               lut_Y_data_71[15:0] <= density_reg154; 
          end 
          154: begin 
               lut_Y_data_70[15:0] <= density_reg154; 
               lut_Y_data_71[15:0] <= density_reg155; 
          end 
          155: begin 
               lut_Y_data_70[15:0] <= density_reg155; 
               lut_Y_data_71[15:0] <= density_reg156; 
          end 
          156: begin 
               lut_Y_data_70[15:0] <= density_reg156; 
               lut_Y_data_71[15:0] <= density_reg157; 
          end 
          157: begin 
               lut_Y_data_70[15:0] <= density_reg157; 
               lut_Y_data_71[15:0] <= density_reg158; 
          end 
          158: begin 
               lut_Y_data_70[15:0] <= density_reg158; 
               lut_Y_data_71[15:0] <= density_reg159; 
          end 
          159: begin 
               lut_Y_data_70[15:0] <= density_reg159; 
               lut_Y_data_71[15:0] <= density_reg160; 
          end 
          160: begin 
               lut_Y_data_70[15:0] <= density_reg160; 
               lut_Y_data_71[15:0] <= density_reg161; 
          end 
          161: begin 
               lut_Y_data_70[15:0] <= density_reg161; 
               lut_Y_data_71[15:0] <= density_reg162; 
          end 
          162: begin 
               lut_Y_data_70[15:0] <= density_reg162; 
               lut_Y_data_71[15:0] <= density_reg163; 
          end 
          163: begin 
               lut_Y_data_70[15:0] <= density_reg163; 
               lut_Y_data_71[15:0] <= density_reg164; 
          end 
          164: begin 
               lut_Y_data_70[15:0] <= density_reg164; 
               lut_Y_data_71[15:0] <= density_reg165; 
          end 
          165: begin 
               lut_Y_data_70[15:0] <= density_reg165; 
               lut_Y_data_71[15:0] <= density_reg166; 
          end 
          166: begin 
               lut_Y_data_70[15:0] <= density_reg166; 
               lut_Y_data_71[15:0] <= density_reg167; 
          end 
          167: begin 
               lut_Y_data_70[15:0] <= density_reg167; 
               lut_Y_data_71[15:0] <= density_reg168; 
          end 
          168: begin 
               lut_Y_data_70[15:0] <= density_reg168; 
               lut_Y_data_71[15:0] <= density_reg169; 
          end 
          169: begin 
               lut_Y_data_70[15:0] <= density_reg169; 
               lut_Y_data_71[15:0] <= density_reg170; 
          end 
          170: begin 
               lut_Y_data_70[15:0] <= density_reg170; 
               lut_Y_data_71[15:0] <= density_reg171; 
          end 
          171: begin 
               lut_Y_data_70[15:0] <= density_reg171; 
               lut_Y_data_71[15:0] <= density_reg172; 
          end 
          172: begin 
               lut_Y_data_70[15:0] <= density_reg172; 
               lut_Y_data_71[15:0] <= density_reg173; 
          end 
          173: begin 
               lut_Y_data_70[15:0] <= density_reg173; 
               lut_Y_data_71[15:0] <= density_reg174; 
          end 
          174: begin 
               lut_Y_data_70[15:0] <= density_reg174; 
               lut_Y_data_71[15:0] <= density_reg175; 
          end 
          175: begin 
               lut_Y_data_70[15:0] <= density_reg175; 
               lut_Y_data_71[15:0] <= density_reg176; 
          end 
          176: begin 
               lut_Y_data_70[15:0] <= density_reg176; 
               lut_Y_data_71[15:0] <= density_reg177; 
          end 
          177: begin 
               lut_Y_data_70[15:0] <= density_reg177; 
               lut_Y_data_71[15:0] <= density_reg178; 
          end 
          178: begin 
               lut_Y_data_70[15:0] <= density_reg178; 
               lut_Y_data_71[15:0] <= density_reg179; 
          end 
          179: begin 
               lut_Y_data_70[15:0] <= density_reg179; 
               lut_Y_data_71[15:0] <= density_reg180; 
          end 
          180: begin 
               lut_Y_data_70[15:0] <= density_reg180; 
               lut_Y_data_71[15:0] <= density_reg181; 
          end 
          181: begin 
               lut_Y_data_70[15:0] <= density_reg181; 
               lut_Y_data_71[15:0] <= density_reg182; 
          end 
          182: begin 
               lut_Y_data_70[15:0] <= density_reg182; 
               lut_Y_data_71[15:0] <= density_reg183; 
          end 
          183: begin 
               lut_Y_data_70[15:0] <= density_reg183; 
               lut_Y_data_71[15:0] <= density_reg184; 
          end 
          184: begin 
               lut_Y_data_70[15:0] <= density_reg184; 
               lut_Y_data_71[15:0] <= density_reg185; 
          end 
          185: begin 
               lut_Y_data_70[15:0] <= density_reg185; 
               lut_Y_data_71[15:0] <= density_reg186; 
          end 
          186: begin 
               lut_Y_data_70[15:0] <= density_reg186; 
               lut_Y_data_71[15:0] <= density_reg187; 
          end 
          187: begin 
               lut_Y_data_70[15:0] <= density_reg187; 
               lut_Y_data_71[15:0] <= density_reg188; 
          end 
          188: begin 
               lut_Y_data_70[15:0] <= density_reg188; 
               lut_Y_data_71[15:0] <= density_reg189; 
          end 
          189: begin 
               lut_Y_data_70[15:0] <= density_reg189; 
               lut_Y_data_71[15:0] <= density_reg190; 
          end 
          190: begin 
               lut_Y_data_70[15:0] <= density_reg190; 
               lut_Y_data_71[15:0] <= density_reg191; 
          end 
          191: begin 
               lut_Y_data_70[15:0] <= density_reg191; 
               lut_Y_data_71[15:0] <= density_reg192; 
          end 
          192: begin 
               lut_Y_data_70[15:0] <= density_reg192; 
               lut_Y_data_71[15:0] <= density_reg193; 
          end 
          193: begin 
               lut_Y_data_70[15:0] <= density_reg193; 
               lut_Y_data_71[15:0] <= density_reg194; 
          end 
          194: begin 
               lut_Y_data_70[15:0] <= density_reg194; 
               lut_Y_data_71[15:0] <= density_reg195; 
          end 
          195: begin 
               lut_Y_data_70[15:0] <= density_reg195; 
               lut_Y_data_71[15:0] <= density_reg196; 
          end 
          196: begin 
               lut_Y_data_70[15:0] <= density_reg196; 
               lut_Y_data_71[15:0] <= density_reg197; 
          end 
          197: begin 
               lut_Y_data_70[15:0] <= density_reg197; 
               lut_Y_data_71[15:0] <= density_reg198; 
          end 
          198: begin 
               lut_Y_data_70[15:0] <= density_reg198; 
               lut_Y_data_71[15:0] <= density_reg199; 
          end 
          199: begin 
               lut_Y_data_70[15:0] <= density_reg199; 
               lut_Y_data_71[15:0] <= density_reg200; 
          end 
          200: begin 
               lut_Y_data_70[15:0] <= density_reg200; 
               lut_Y_data_71[15:0] <= density_reg201; 
          end 
          201: begin 
               lut_Y_data_70[15:0] <= density_reg201; 
               lut_Y_data_71[15:0] <= density_reg202; 
          end 
          202: begin 
               lut_Y_data_70[15:0] <= density_reg202; 
               lut_Y_data_71[15:0] <= density_reg203; 
          end 
          203: begin 
               lut_Y_data_70[15:0] <= density_reg203; 
               lut_Y_data_71[15:0] <= density_reg204; 
          end 
          204: begin 
               lut_Y_data_70[15:0] <= density_reg204; 
               lut_Y_data_71[15:0] <= density_reg205; 
          end 
          205: begin 
               lut_Y_data_70[15:0] <= density_reg205; 
               lut_Y_data_71[15:0] <= density_reg206; 
          end 
          206: begin 
               lut_Y_data_70[15:0] <= density_reg206; 
               lut_Y_data_71[15:0] <= density_reg207; 
          end 
          207: begin 
               lut_Y_data_70[15:0] <= density_reg207; 
               lut_Y_data_71[15:0] <= density_reg208; 
          end 
          208: begin 
               lut_Y_data_70[15:0] <= density_reg208; 
               lut_Y_data_71[15:0] <= density_reg209; 
          end 
          209: begin 
               lut_Y_data_70[15:0] <= density_reg209; 
               lut_Y_data_71[15:0] <= density_reg210; 
          end 
          210: begin 
               lut_Y_data_70[15:0] <= density_reg210; 
               lut_Y_data_71[15:0] <= density_reg211; 
          end 
          211: begin 
               lut_Y_data_70[15:0] <= density_reg211; 
               lut_Y_data_71[15:0] <= density_reg212; 
          end 
          212: begin 
               lut_Y_data_70[15:0] <= density_reg212; 
               lut_Y_data_71[15:0] <= density_reg213; 
          end 
          213: begin 
               lut_Y_data_70[15:0] <= density_reg213; 
               lut_Y_data_71[15:0] <= density_reg214; 
          end 
          214: begin 
               lut_Y_data_70[15:0] <= density_reg214; 
               lut_Y_data_71[15:0] <= density_reg215; 
          end 
          215: begin 
               lut_Y_data_70[15:0] <= density_reg215; 
               lut_Y_data_71[15:0] <= density_reg216; 
          end 
          216: begin 
               lut_Y_data_70[15:0] <= density_reg216; 
               lut_Y_data_71[15:0] <= density_reg217; 
          end 
          217: begin 
               lut_Y_data_70[15:0] <= density_reg217; 
               lut_Y_data_71[15:0] <= density_reg218; 
          end 
          218: begin 
               lut_Y_data_70[15:0] <= density_reg218; 
               lut_Y_data_71[15:0] <= density_reg219; 
          end 
          219: begin 
               lut_Y_data_70[15:0] <= density_reg219; 
               lut_Y_data_71[15:0] <= density_reg220; 
          end 
          220: begin 
               lut_Y_data_70[15:0] <= density_reg220; 
               lut_Y_data_71[15:0] <= density_reg221; 
          end 
          221: begin 
               lut_Y_data_70[15:0] <= density_reg221; 
               lut_Y_data_71[15:0] <= density_reg222; 
          end 
          222: begin 
               lut_Y_data_70[15:0] <= density_reg222; 
               lut_Y_data_71[15:0] <= density_reg223; 
          end 
          223: begin 
               lut_Y_data_70[15:0] <= density_reg223; 
               lut_Y_data_71[15:0] <= density_reg224; 
          end 
          224: begin 
               lut_Y_data_70[15:0] <= density_reg224; 
               lut_Y_data_71[15:0] <= density_reg225; 
          end 
          225: begin 
               lut_Y_data_70[15:0] <= density_reg225; 
               lut_Y_data_71[15:0] <= density_reg226; 
          end 
          226: begin 
               lut_Y_data_70[15:0] <= density_reg226; 
               lut_Y_data_71[15:0] <= density_reg227; 
          end 
          227: begin 
               lut_Y_data_70[15:0] <= density_reg227; 
               lut_Y_data_71[15:0] <= density_reg228; 
          end 
          228: begin 
               lut_Y_data_70[15:0] <= density_reg228; 
               lut_Y_data_71[15:0] <= density_reg229; 
          end 
          229: begin 
               lut_Y_data_70[15:0] <= density_reg229; 
               lut_Y_data_71[15:0] <= density_reg230; 
          end 
          230: begin 
               lut_Y_data_70[15:0] <= density_reg230; 
               lut_Y_data_71[15:0] <= density_reg231; 
          end 
          231: begin 
               lut_Y_data_70[15:0] <= density_reg231; 
               lut_Y_data_71[15:0] <= density_reg232; 
          end 
          232: begin 
               lut_Y_data_70[15:0] <= density_reg232; 
               lut_Y_data_71[15:0] <= density_reg233; 
          end 
          233: begin 
               lut_Y_data_70[15:0] <= density_reg233; 
               lut_Y_data_71[15:0] <= density_reg234; 
          end 
          234: begin 
               lut_Y_data_70[15:0] <= density_reg234; 
               lut_Y_data_71[15:0] <= density_reg235; 
          end 
          235: begin 
               lut_Y_data_70[15:0] <= density_reg235; 
               lut_Y_data_71[15:0] <= density_reg236; 
          end 
          236: begin 
               lut_Y_data_70[15:0] <= density_reg236; 
               lut_Y_data_71[15:0] <= density_reg237; 
          end 
          237: begin 
               lut_Y_data_70[15:0] <= density_reg237; 
               lut_Y_data_71[15:0] <= density_reg238; 
          end 
          238: begin 
               lut_Y_data_70[15:0] <= density_reg238; 
               lut_Y_data_71[15:0] <= density_reg239; 
          end 
          239: begin 
               lut_Y_data_70[15:0] <= density_reg239; 
               lut_Y_data_71[15:0] <= density_reg240; 
          end 
          240: begin 
               lut_Y_data_70[15:0] <= density_reg240; 
               lut_Y_data_71[15:0] <= density_reg241; 
          end 
          241: begin 
               lut_Y_data_70[15:0] <= density_reg241; 
               lut_Y_data_71[15:0] <= density_reg242; 
          end 
          242: begin 
               lut_Y_data_70[15:0] <= density_reg242; 
               lut_Y_data_71[15:0] <= density_reg243; 
          end 
          243: begin 
               lut_Y_data_70[15:0] <= density_reg243; 
               lut_Y_data_71[15:0] <= density_reg244; 
          end 
          244: begin 
               lut_Y_data_70[15:0] <= density_reg244; 
               lut_Y_data_71[15:0] <= density_reg245; 
          end 
          245: begin 
               lut_Y_data_70[15:0] <= density_reg245; 
               lut_Y_data_71[15:0] <= density_reg246; 
          end 
          246: begin 
               lut_Y_data_70[15:0] <= density_reg246; 
               lut_Y_data_71[15:0] <= density_reg247; 
          end 
          247: begin 
               lut_Y_data_70[15:0] <= density_reg247; 
               lut_Y_data_71[15:0] <= density_reg248; 
          end 
          248: begin 
               lut_Y_data_70[15:0] <= density_reg248; 
               lut_Y_data_71[15:0] <= density_reg249; 
          end 
          249: begin 
               lut_Y_data_70[15:0] <= density_reg249; 
               lut_Y_data_71[15:0] <= density_reg250; 
          end 
          250: begin 
               lut_Y_data_70[15:0] <= density_reg250; 
               lut_Y_data_71[15:0] <= density_reg251; 
          end 
          251: begin 
               lut_Y_data_70[15:0] <= density_reg251; 
               lut_Y_data_71[15:0] <= density_reg252; 
          end 
          252: begin 
               lut_Y_data_70[15:0] <= density_reg252; 
               lut_Y_data_71[15:0] <= density_reg253; 
          end 
          253: begin 
               lut_Y_data_70[15:0] <= density_reg253; 
               lut_Y_data_71[15:0] <= density_reg254; 
          end 
          254: begin 
               lut_Y_data_70[15:0] <= density_reg254; 
               lut_Y_data_71[15:0] <= density_reg255; 
          end 
          255: begin 
               lut_Y_data_70[15:0] <= density_reg255; 
               lut_Y_data_71[15:0] <= density_reg256; 
          end 
          256: begin 
               lut_Y_data_70[15:0] <= density_reg256; 
               lut_Y_data_71[15:0] <= density_reg256; 
          end 
          default: begin 
            lut_Y_data_70[15:0] <= density_reg0; 
            lut_Y_data_71[15:0] <= density_reg0; 
          end 
        endcase 
        end 
  end 
    end
  end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_X_info_0 <= {18{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    lut_X_info_0 <= dp2lut_Xinfo_0[17:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    lut_X_info_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_X_info_1 <= {18{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    lut_X_info_1 <= dp2lut_Xinfo_1[17:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    lut_X_info_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_X_info_2 <= {18{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    lut_X_info_2 <= dp2lut_Xinfo_2[17:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    lut_X_info_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_X_info_3 <= {18{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    lut_X_info_3 <= dp2lut_Xinfo_3[17:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    lut_X_info_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_X_info_4 <= {18{1'b0}};
  end else begin
  if ((load_din & int8_en) == 1'b1) begin
    lut_X_info_4 <= dp2lut_Xinfo_4[17:0];
  // VCS coverage off
  end else if ((load_din & int8_en) == 1'b0) begin
  end else begin
    lut_X_info_4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din & int8_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_X_info_5 <= {18{1'b0}};
  end else begin
  if ((load_din & int8_en) == 1'b1) begin
    lut_X_info_5 <= dp2lut_Xinfo_5[17:0];
  // VCS coverage off
  end else if ((load_din & int8_en) == 1'b0) begin
  end else begin
    lut_X_info_5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din & int8_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_X_info_6 <= {18{1'b0}};
  end else begin
  if ((load_din & int8_en) == 1'b1) begin
    lut_X_info_6 <= dp2lut_Xinfo_6[17:0];
  // VCS coverage off
  end else if ((load_din & int8_en) == 1'b0) begin
  end else begin
    lut_X_info_6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din & int8_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_X_info_7 <= {18{1'b0}};
  end else begin
  if ((load_din & int8_en) == 1'b1) begin
    lut_X_info_7 <= dp2lut_Xinfo_7[17:0];
  // VCS coverage off
  end else if ((load_din & int8_en) == 1'b0) begin
  end else begin
    lut_X_info_7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din & int8_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lutX_sel <= {8{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    lutX_sel <= lut_X_sel[7:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    lutX_sel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_Y_info_0 <= {18{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    lut_Y_info_0 <= dp2lut_Yinfo_0[17:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    lut_Y_info_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_Y_info_1 <= {18{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    lut_Y_info_1 <= dp2lut_Yinfo_1[17:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    lut_Y_info_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_Y_info_2 <= {18{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    lut_Y_info_2 <= dp2lut_Yinfo_2[17:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    lut_Y_info_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_Y_info_3 <= {18{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    lut_Y_info_3 <= dp2lut_Yinfo_3[17:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    lut_Y_info_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_Y_info_4 <= {18{1'b0}};
  end else begin
  if ((load_din & int8_en) == 1'b1) begin
    lut_Y_info_4 <= dp2lut_Yinfo_4[17:0];
  // VCS coverage off
  end else if ((load_din & int8_en) == 1'b0) begin
  end else begin
    lut_Y_info_4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din & int8_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_Y_info_5 <= {18{1'b0}};
  end else begin
  if ((load_din & int8_en) == 1'b1) begin
    lut_Y_info_5 <= dp2lut_Yinfo_5[17:0];
  // VCS coverage off
  end else if ((load_din & int8_en) == 1'b0) begin
  end else begin
    lut_Y_info_5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din & int8_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_Y_info_6 <= {18{1'b0}};
  end else begin
  if ((load_din & int8_en) == 1'b1) begin
    lut_Y_info_6 <= dp2lut_Yinfo_6[17:0];
  // VCS coverage off
  end else if ((load_din & int8_en) == 1'b0) begin
  end else begin
    lut_Y_info_6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din & int8_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lut_Y_info_7 <= {18{1'b0}};
  end else begin
  if ((load_din & int8_en) == 1'b1) begin
    lut_Y_info_7 <= dp2lut_Yinfo_7[17:0];
  // VCS coverage off
  end else if ((load_din & int8_en) == 1'b0) begin
  end else begin
    lut_Y_info_7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din & int8_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    lutY_sel <= {8{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    lutY_sel <= lut_Y_sel[7:0];
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    lutY_sel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

 assign lutX_data_00[15:0] = lutX_sel[0] ? lut_X_data_00[15:0] : (lutY_sel[0] ? lut_Y_data_00[15:0] : 16'd0); 
 assign lutX_data_01[15:0] = lutX_sel[0] ? lut_X_data_01[15:0] : (lutY_sel[0] ? lut_Y_data_01[15:0] : 16'd0); 
 assign lutX_info_0[15:0]  = lutX_sel[0] ? lut_X_info_0[15:0]  : (lutY_sel[0] ? lut_Y_info_0[15:0]  : 16'd0); 
 assign lutX_data_10[15:0] = lutX_sel[1] ? lut_X_data_10[15:0] : (lutY_sel[1] ? lut_Y_data_10[15:0] : 16'd0); 
 assign lutX_data_11[15:0] = lutX_sel[1] ? lut_X_data_11[15:0] : (lutY_sel[1] ? lut_Y_data_11[15:0] : 16'd0); 
 assign lutX_info_1[15:0]  = lutX_sel[1] ? lut_X_info_1[15:0]  : (lutY_sel[1] ? lut_Y_info_1[15:0]  : 16'd0); 
 assign lutX_data_20[15:0] = lutX_sel[2] ? lut_X_data_20[15:0] : (lutY_sel[2] ? lut_Y_data_20[15:0] : 16'd0); 
 assign lutX_data_21[15:0] = lutX_sel[2] ? lut_X_data_21[15:0] : (lutY_sel[2] ? lut_Y_data_21[15:0] : 16'd0); 
 assign lutX_info_2[15:0]  = lutX_sel[2] ? lut_X_info_2[15:0]  : (lutY_sel[2] ? lut_Y_info_2[15:0]  : 16'd0); 
 assign lutX_data_30[15:0] = lutX_sel[3] ? lut_X_data_30[15:0] : (lutY_sel[3] ? lut_Y_data_30[15:0] : 16'd0); 
 assign lutX_data_31[15:0] = lutX_sel[3] ? lut_X_data_31[15:0] : (lutY_sel[3] ? lut_Y_data_31[15:0] : 16'd0); 
 assign lutX_info_3[15:0]  = lutX_sel[3] ? lut_X_info_3[15:0]  : (lutY_sel[3] ? lut_Y_info_3[15:0]  : 16'd0); 
 assign lutX_data_40[15:0] = lutX_sel[4] ? lut_X_data_40[15:0] : (lutY_sel[4] ? lut_Y_data_40[15:0] : 16'd0); 
 assign lutX_data_41[15:0] = lutX_sel[4] ? lut_X_data_41[15:0] : (lutY_sel[4] ? lut_Y_data_41[15:0] : 16'd0); 
 assign lutX_info_4[15:0]  = lutX_sel[4] ? lut_X_info_4[15:0]  : (lutY_sel[4] ? lut_Y_info_4[15:0]  : 16'd0); 
 assign lutX_data_50[15:0] = lutX_sel[5] ? lut_X_data_50[15:0] : (lutY_sel[5] ? lut_Y_data_50[15:0] : 16'd0); 
 assign lutX_data_51[15:0] = lutX_sel[5] ? lut_X_data_51[15:0] : (lutY_sel[5] ? lut_Y_data_51[15:0] : 16'd0); 
 assign lutX_info_5[15:0]  = lutX_sel[5] ? lut_X_info_5[15:0]  : (lutY_sel[5] ? lut_Y_info_5[15:0]  : 16'd0); 
 assign lutX_data_60[15:0] = lutX_sel[6] ? lut_X_data_60[15:0] : (lutY_sel[6] ? lut_Y_data_60[15:0] : 16'd0); 
 assign lutX_data_61[15:0] = lutX_sel[6] ? lut_X_data_61[15:0] : (lutY_sel[6] ? lut_Y_data_61[15:0] : 16'd0); 
 assign lutX_info_6[15:0]  = lutX_sel[6] ? lut_X_info_6[15:0]  : (lutY_sel[6] ? lut_Y_info_6[15:0]  : 16'd0); 
 assign lutX_data_70[15:0] = lutX_sel[7] ? lut_X_data_70[15:0] : (lutY_sel[7] ? lut_Y_data_70[15:0] : 16'd0); 
 assign lutX_data_71[15:0] = lutX_sel[7] ? lut_X_data_71[15:0] : (lutY_sel[7] ? lut_Y_data_71[15:0] : 16'd0); 
 assign lutX_info_7[15:0]  = lutX_sel[7] ? lut_X_info_7[15:0]  : (lutY_sel[7] ? lut_Y_info_7[15:0]  : 16'd0); 

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lut_pvld_f <= 1'b0;
  end else begin
    if(dp2lut_pvld)
        lut_pvld_f <= 1'b1;
    else if(lut_prdy)
        lut_pvld_f <= 1'b0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp16_en_f <= 1'b0;
  end else begin
  fp16_en_f <= reg2dp_input_data_type[1:0] == 2;
  end
end
assign lut_prdy = fp16_en_f ? fp_lut_prdy_f : lut2intp_prdy;
///////////////////////////////////////////////////////////////
//data format switch process for fp16 precision mode
///////////////////////////////////////////////////////////////
assign fp_lut_prdy_f = fp16_en_f ? (&FMcvt_in_rdy) : 1'b1;
assign fp_lut_pvld_f = fp16_en_f ? lut_pvld_f : 1'b0;

assign FMcvt_in_vld[0] = fp_lut_pvld_f & (&{FMcvt_in_rdy[3:1]});
assign FMcvt_in_vld[1] = fp_lut_pvld_f & (&{FMcvt_in_rdy[3:2],FMcvt_in_rdy[  0]});
assign FMcvt_in_vld[2] = fp_lut_pvld_f & (&{FMcvt_in_rdy[  3],FMcvt_in_rdy[1:0]});
assign FMcvt_in_vld[3] = fp_lut_pvld_f & (&{FMcvt_in_rdy[2:0]});

 fp_format_cvt u_fp_format_cvt_0 (
    .FMcvt_in_vld      (FMcvt_in_vld[0])         //|< w
   ,.FMcvt_out_rdy     (FMcvt_out_rdy[0])        //|< w
   ,.fp16to17_in_X0    (lutX_data_00[15:0])      //|< w
   ,.fp16to32_in_X0    (lutX_data_00[15:0])      //|< w
   ,.fp16to32_in_X1    (lutX_data_01[15:0])      //|< w
   ,.lut_X_info_in     (lut_X_info_0[17:16])     //|< r
   ,.lut_X_sel_in      (lutX_sel[0])             //|< r
   ,.lut_Y_info_in     (lut_Y_info_0[17:16])     //|< r
   ,.lut_Y_sel_in      (lutY_sel[0])             //|< r
   ,.nvdla_core_clk    (nvdla_op_gated_clk_fp16) //|< i
   ,.nvdla_core_rstn   (nvdla_core_rstn)         //|< i
   ,.uint16tofp17_Xin  (lutX_info_0[15:0])       //|< w
   ,.FMcvt_in_rdy      (FMcvt_in_rdy[0])         //|> w
   ,.FMcvt_out_vld     (FMcvt_out_vld[0])        //|> w
   ,.fp16to17_out_X0   (lut_X_dat_00_fp17[16:0]) //|> w
   ,.fp16to32_out_X0   (lut_X_dat_00[31:0])      //|> w
   ,.fp16to32_out_X1   (lut_X_dat_01[31:0])      //|> w
   ,.lut_X_info_out    (lut_X_inf_0[18:17])      //|> w
   ,.lut_X_sel_out     (lutX_sel_o[0])           //|> w
   ,.lut_Y_info_out    (lut_X_inf_0[20:19])      //|> w
   ,.lut_Y_sel_out     (lutY_sel_o[0])           //|> w
   ,.uint16tofp17_Xout (lut_X_inf_0[16:0])       //|> w
   );
 fp_format_cvt u_fp_format_cvt_1 (
    .FMcvt_in_vld      (FMcvt_in_vld[1])         //|< w
   ,.FMcvt_out_rdy     (FMcvt_out_rdy[1])        //|< w
   ,.fp16to17_in_X0    (lutX_data_10[15:0])      //|< w
   ,.fp16to32_in_X0    (lutX_data_10[15:0])      //|< w
   ,.fp16to32_in_X1    (lutX_data_11[15:0])      //|< w
   ,.lut_X_info_in     (lut_X_info_1[17:16])     //|< r
   ,.lut_X_sel_in      (lutX_sel[1])             //|< r
   ,.lut_Y_info_in     (lut_Y_info_1[17:16])     //|< r
   ,.lut_Y_sel_in      (lutY_sel[1])             //|< r
   ,.nvdla_core_clk    (nvdla_op_gated_clk_fp16) //|< i
   ,.nvdla_core_rstn   (nvdla_core_rstn)         //|< i
   ,.uint16tofp17_Xin  (lutX_info_1[15:0])       //|< w
   ,.FMcvt_in_rdy      (FMcvt_in_rdy[1])         //|> w
   ,.FMcvt_out_vld     (FMcvt_out_vld[1])        //|> w
   ,.fp16to17_out_X0   (lut_X_dat_10_fp17[16:0]) //|> w
   ,.fp16to32_out_X0   (lut_X_dat_10[31:0])      //|> w
   ,.fp16to32_out_X1   (lut_X_dat_11[31:0])      //|> w
   ,.lut_X_info_out    (lut_X_inf_1[18:17])      //|> w
   ,.lut_X_sel_out     (lutX_sel_o[1])           //|> w
   ,.lut_Y_info_out    (lut_X_inf_1[20:19])      //|> w
   ,.lut_Y_sel_out     (lutY_sel_o[1])           //|> w
   ,.uint16tofp17_Xout (lut_X_inf_1[16:0])       //|> w
   );
 fp_format_cvt u_fp_format_cvt_2 (
    .FMcvt_in_vld      (FMcvt_in_vld[2])         //|< w
   ,.FMcvt_out_rdy     (FMcvt_out_rdy[2])        //|< w
   ,.fp16to17_in_X0    (lutX_data_20[15:0])      //|< w
   ,.fp16to32_in_X0    (lutX_data_20[15:0])      //|< w
   ,.fp16to32_in_X1    (lutX_data_21[15:0])      //|< w
   ,.lut_X_info_in     (lut_X_info_2[17:16])     //|< r
   ,.lut_X_sel_in      (lutX_sel[2])             //|< r
   ,.lut_Y_info_in     (lut_Y_info_2[17:16])     //|< r
   ,.lut_Y_sel_in      (lutY_sel[2])             //|< r
   ,.nvdla_core_clk    (nvdla_op_gated_clk_fp16) //|< i
   ,.nvdla_core_rstn   (nvdla_core_rstn)         //|< i
   ,.uint16tofp17_Xin  (lutX_info_2[15:0])       //|< w
   ,.FMcvt_in_rdy      (FMcvt_in_rdy[2])         //|> w
   ,.FMcvt_out_vld     (FMcvt_out_vld[2])        //|> w
   ,.fp16to17_out_X0   (lut_X_dat_20_fp17[16:0]) //|> w
   ,.fp16to32_out_X0   (lut_X_dat_20[31:0])      //|> w
   ,.fp16to32_out_X1   (lut_X_dat_21[31:0])      //|> w
   ,.lut_X_info_out    (lut_X_inf_2[18:17])      //|> w
   ,.lut_X_sel_out     (lutX_sel_o[2])           //|> w
   ,.lut_Y_info_out    (lut_X_inf_2[20:19])      //|> w
   ,.lut_Y_sel_out     (lutY_sel_o[2])           //|> w
   ,.uint16tofp17_Xout (lut_X_inf_2[16:0])       //|> w
   );
 fp_format_cvt u_fp_format_cvt_3 (
    .FMcvt_in_vld      (FMcvt_in_vld[3])         //|< w
   ,.FMcvt_out_rdy     (FMcvt_out_rdy[3])        //|< w
   ,.fp16to17_in_X0    (lutX_data_30[15:0])      //|< w
   ,.fp16to32_in_X0    (lutX_data_30[15:0])      //|< w
   ,.fp16to32_in_X1    (lutX_data_31[15:0])      //|< w
   ,.lut_X_info_in     (lut_X_info_3[17:16])     //|< r
   ,.lut_X_sel_in      (lutX_sel[3])             //|< r
   ,.lut_Y_info_in     (lut_Y_info_3[17:16])     //|< r
   ,.lut_Y_sel_in      (lutY_sel[3])             //|< r
   ,.nvdla_core_clk    (nvdla_op_gated_clk_fp16) //|< i
   ,.nvdla_core_rstn   (nvdla_core_rstn)         //|< i
   ,.uint16tofp17_Xin  (lutX_info_3[15:0])       //|< w
   ,.FMcvt_in_rdy      (FMcvt_in_rdy[3])         //|> w
   ,.FMcvt_out_vld     (FMcvt_out_vld[3])        //|> w
   ,.fp16to17_out_X0   (lut_X_dat_30_fp17[16:0]) //|> w
   ,.fp16to32_out_X0   (lut_X_dat_30[31:0])      //|> w
   ,.fp16to32_out_X1   (lut_X_dat_31[31:0])      //|> w
   ,.lut_X_info_out    (lut_X_inf_3[18:17])      //|> w
   ,.lut_X_sel_out     (lutX_sel_o[3])           //|> w
   ,.lut_Y_info_out    (lut_X_inf_3[20:19])      //|> w
   ,.lut_Y_sel_out     (lutY_sel_o[3])           //|> w
   ,.uint16tofp17_Xout (lut_X_inf_3[16:0])       //|> w
   );

assign FMcvt_out_rdy[0] = fp_out_prdy & (&{FMcvt_out_vld[3:1]});
assign FMcvt_out_rdy[1] = fp_out_prdy & (&{FMcvt_out_vld[3:2],FMcvt_out_vld[  0]});
assign FMcvt_out_rdy[2] = fp_out_prdy & (&{FMcvt_out_vld[3  ],FMcvt_out_vld[1:0]});
assign FMcvt_out_rdy[3] = fp_out_prdy & (&{FMcvt_out_vld[2:0]});

assign fp_out_vld = &FMcvt_out_vld;
assign fp_out_prdy = fp16_en_f ? lut2intp_prdy : 1'b1;
///////////////////////////////////////////////////////////////
//output data and valid select by fp16_en
///////////////////////////////////////////////////////////////
assign lut2intp_pvld = fp16_en_f ? fp_out_vld : lut_pvld_f;

always @(
  fp16_en_f
  or lutX_data_00
  or lutX_data_01
  or lut_Y_info_0
  or lut_X_info_0
  or lutX_info_0
  or lutX_sel
  or lutY_sel
  or lutX_data_10
  or lutX_data_11
  or lut_Y_info_1
  or lut_X_info_1
  or lutX_info_1
  or lutX_data_20
  or lutX_data_21
  or lut_Y_info_2
  or lut_X_info_2
  or lutX_info_2
  or lutX_data_30
  or lutX_data_31
  or lut_Y_info_3
  or lut_X_info_3
  or lutX_info_3
  or lut_X_dat_00
  or lut_X_dat_01
  or lut_X_dat_00_fp17
  or lut_X_inf_0
  or lutX_sel_o
  or lutY_sel_o
  or lut_X_dat_10
  or lut_X_dat_11
  or lut_X_dat_10_fp17
  or lut_X_inf_1
  or lut_X_dat_20
  or lut_X_dat_21
  or lut_X_dat_20_fp17
  or lut_X_inf_2
  or lut_X_dat_30
  or lut_X_dat_31
  or lut_X_dat_30_fp17
  or lut_X_inf_3
  ) begin
   if(~fp16_en_f) begin
       lut2intp_X_data_00[31:0]     = {{16{lutX_data_00[15]}},lutX_data_00[15:0]}; 
       lut2intp_X_data_01[31:0]     = {{16{lutX_data_01[15]}},lutX_data_01[15:0]}; 
       lut2intp_X_data_00_17b[16:0] = {lutX_data_00[15],lutX_data_00[15:0]}; 
       lut2intp_X_info_0[19:0]      = {lut_Y_info_0[17:16],lut_X_info_0[17:16],lutX_info_0[15:0]}; 
       lut2intp_X_sel[0]            = lutX_sel[0]; 
       lut2intp_Y_sel[0]            = lutY_sel[0]; 
       lut2intp_X_data_10[31:0]     = {{16{lutX_data_10[15]}},lutX_data_10[15:0]}; 
       lut2intp_X_data_11[31:0]     = {{16{lutX_data_11[15]}},lutX_data_11[15:0]}; 
       lut2intp_X_data_10_17b[16:0] = {lutX_data_10[15],lutX_data_10[15:0]}; 
       lut2intp_X_info_1[19:0]      = {lut_Y_info_1[17:16],lut_X_info_1[17:16],lutX_info_1[15:0]}; 
       lut2intp_X_sel[1]            = lutX_sel[1]; 
       lut2intp_Y_sel[1]            = lutY_sel[1]; 
       lut2intp_X_data_20[31:0]     = {{16{lutX_data_20[15]}},lutX_data_20[15:0]}; 
       lut2intp_X_data_21[31:0]     = {{16{lutX_data_21[15]}},lutX_data_21[15:0]}; 
       lut2intp_X_data_20_17b[16:0] = {lutX_data_20[15],lutX_data_20[15:0]}; 
       lut2intp_X_info_2[19:0]      = {lut_Y_info_2[17:16],lut_X_info_2[17:16],lutX_info_2[15:0]}; 
       lut2intp_X_sel[2]            = lutX_sel[2]; 
       lut2intp_Y_sel[2]            = lutY_sel[2]; 
       lut2intp_X_data_30[31:0]     = {{16{lutX_data_30[15]}},lutX_data_30[15:0]}; 
       lut2intp_X_data_31[31:0]     = {{16{lutX_data_31[15]}},lutX_data_31[15:0]}; 
       lut2intp_X_data_30_17b[16:0] = {lutX_data_30[15],lutX_data_30[15:0]}; 
       lut2intp_X_info_3[19:0]      = {lut_Y_info_3[17:16],lut_X_info_3[17:16],lutX_info_3[15:0]}; 
       lut2intp_X_sel[3]            = lutX_sel[3]; 
       lut2intp_Y_sel[3]            = lutY_sel[3]; 
   end else begin
       lut2intp_X_data_00[31:0]     = lut_X_dat_00[31:0]; 
       lut2intp_X_data_01[31:0]     = lut_X_dat_01[31:0]; 
       lut2intp_X_data_00_17b[16:0] = lut_X_dat_00_fp17; 
       lut2intp_X_info_0[19:0]      = {lut_X_inf_0[20:17],lut_X_inf_0[15:0]}; 
       lut2intp_X_sel[0]            = lutX_sel_o[0]; 
       lut2intp_Y_sel[0]            = lutY_sel_o[0]; 
       lut2intp_X_data_10[31:0]     = lut_X_dat_10[31:0]; 
       lut2intp_X_data_11[31:0]     = lut_X_dat_11[31:0]; 
       lut2intp_X_data_10_17b[16:0] = lut_X_dat_10_fp17; 
       lut2intp_X_info_1[19:0]      = {lut_X_inf_1[20:17],lut_X_inf_1[15:0]}; 
       lut2intp_X_sel[1]            = lutX_sel_o[1]; 
       lut2intp_Y_sel[1]            = lutY_sel_o[1]; 
       lut2intp_X_data_20[31:0]     = lut_X_dat_20[31:0]; 
       lut2intp_X_data_21[31:0]     = lut_X_dat_21[31:0]; 
       lut2intp_X_data_20_17b[16:0] = lut_X_dat_20_fp17; 
       lut2intp_X_info_2[19:0]      = {lut_X_inf_2[20:17],lut_X_inf_2[15:0]}; 
       lut2intp_X_sel[2]            = lutX_sel_o[2]; 
       lut2intp_Y_sel[2]            = lutY_sel_o[2]; 
       lut2intp_X_data_30[31:0]     = lut_X_dat_30[31:0]; 
       lut2intp_X_data_31[31:0]     = lut_X_dat_31[31:0]; 
       lut2intp_X_data_30_17b[16:0] = lut_X_dat_30_fp17; 
       lut2intp_X_info_3[19:0]      = {lut_X_inf_3[20:17],lut_X_inf_3[15:0]}; 
       lut2intp_X_sel[3]            = lutX_sel_o[3]; 
       lut2intp_Y_sel[3]            = lutY_sel_o[3]; 
   end
end

always @(
  fp16_en_f
  or lutX_data_40
  or lutX_data_41
  or lut_Y_info_4
  or lut_X_info_4
  or lutX_info_4
  or lutX_sel
  or lutY_sel
  or lutX_data_50
  or lutX_data_51
  or lut_Y_info_5
  or lut_X_info_5
  or lutX_info_5
  or lutX_data_60
  or lutX_data_61
  or lut_Y_info_6
  or lut_X_info_6
  or lutX_info_6
  or lutX_data_70
  or lutX_data_71
  or lut_Y_info_7
  or lut_X_info_7
  or lutX_info_7
  ) begin
   if(~fp16_en_f) begin
       lut2intp_X_data_40[31:0]     = {{16{lutX_data_40[15]}},lutX_data_40[15:0]}; 
       lut2intp_X_data_41[31:0]     = {{16{lutX_data_41[15]}},lutX_data_41[15:0]}; 
       lut2intp_X_data_40_17b[16:0] = {lutX_data_40[15],lutX_data_40[15:0]}; 
       lut2intp_X_info_4[19:0]      = {lut_Y_info_4[17:16],lut_X_info_4[17:16],lutX_info_4[15:0]}; 
       lut2intp_X_sel[4]            = lutX_sel[4]; 
       lut2intp_Y_sel[4]            = lutY_sel[4]; 
       lut2intp_X_data_50[31:0]     = {{16{lutX_data_50[15]}},lutX_data_50[15:0]}; 
       lut2intp_X_data_51[31:0]     = {{16{lutX_data_51[15]}},lutX_data_51[15:0]}; 
       lut2intp_X_data_50_17b[16:0] = {lutX_data_50[15],lutX_data_50[15:0]}; 
       lut2intp_X_info_5[19:0]      = {lut_Y_info_5[17:16],lut_X_info_5[17:16],lutX_info_5[15:0]}; 
       lut2intp_X_sel[5]            = lutX_sel[5]; 
       lut2intp_Y_sel[5]            = lutY_sel[5]; 
       lut2intp_X_data_60[31:0]     = {{16{lutX_data_60[15]}},lutX_data_60[15:0]}; 
       lut2intp_X_data_61[31:0]     = {{16{lutX_data_61[15]}},lutX_data_61[15:0]}; 
       lut2intp_X_data_60_17b[16:0] = {lutX_data_60[15],lutX_data_60[15:0]}; 
       lut2intp_X_info_6[19:0]      = {lut_Y_info_6[17:16],lut_X_info_6[17:16],lutX_info_6[15:0]}; 
       lut2intp_X_sel[6]            = lutX_sel[6]; 
       lut2intp_Y_sel[6]            = lutY_sel[6]; 
       lut2intp_X_data_70[31:0]     = {{16{lutX_data_70[15]}},lutX_data_70[15:0]}; 
       lut2intp_X_data_71[31:0]     = {{16{lutX_data_71[15]}},lutX_data_71[15:0]}; 
       lut2intp_X_data_70_17b[16:0] = {lutX_data_70[15],lutX_data_70[15:0]}; 
       lut2intp_X_info_7[19:0]      = {lut_Y_info_7[17:16],lut_X_info_7[17:16],lutX_info_7[15:0]}; 
       lut2intp_X_sel[7]            = lutX_sel[7]; 
       lut2intp_Y_sel[7]            = lutY_sel[7]; 
   end else begin
       lut2intp_X_data_40[31:0]     = 0; 
       lut2intp_X_data_41[31:0]     = 0; 
       lut2intp_X_data_40_17b[16:0] = 0; 
       lut2intp_X_info_4[19:0]      = 0; 
       lut2intp_X_sel[4]            = 1'b0; 
       lut2intp_Y_sel[4]            = 1'b0; 
       lut2intp_X_data_50[31:0]     = 0; 
       lut2intp_X_data_51[31:0]     = 0; 
       lut2intp_X_data_50_17b[16:0] = 0; 
       lut2intp_X_info_5[19:0]      = 0; 
       lut2intp_X_sel[5]            = 1'b0; 
       lut2intp_Y_sel[5]            = 1'b0; 
       lut2intp_X_data_60[31:0]     = 0; 
       lut2intp_X_data_61[31:0]     = 0; 
       lut2intp_X_data_60_17b[16:0] = 0; 
       lut2intp_X_info_6[19:0]      = 0; 
       lut2intp_X_sel[6]            = 1'b0; 
       lut2intp_Y_sel[6]            = 1'b0; 
       lut2intp_X_data_70[31:0]     = 0; 
       lut2intp_X_data_71[31:0]     = 0; 
       lut2intp_X_data_70_17b[16:0] = 0; 
       lut2intp_X_info_7[19:0]      = 0; 
       lut2intp_X_sel[7]            = 1'b0; 
       lut2intp_Y_sel[7]            = 1'b0; 
   end
end

////==============
////OBS signals
////==============
//assign obs_bus_cdp_lut_wr_en   = lut_wr_en; 
//assign obs_bus_cdp_lut_addr    = reg2dp_lut_addr[1]; 

/////////////////////////
endmodule // NV_NVDLA_CDP_DP_lut

