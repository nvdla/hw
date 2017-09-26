// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CACC_calculator.v

module NV_NVDLA_CACC_calculator (
   nvdla_core_clk      //|< i
  ,nvdla_core_rstn     //|< i
  ,abuf_rd_data_0      //|< i
  ,abuf_rd_data_1      //|< i
  ,abuf_rd_data_2      //|< i
  ,abuf_rd_data_3      //|< i
  ,abuf_rd_data_4      //|< i
  ,abuf_rd_data_5      //|< i
  ,abuf_rd_data_6      //|< i
  ,abuf_rd_data_7      //|< i
  ,accu_ctrl_pd        //|< i
  ,accu_ctrl_ram_valid //|< i
  ,accu_ctrl_valid     //|< i
  ,cfg_in_en_mask      //|< i
  ,cfg_is_fp           //|< i
  ,cfg_is_int          //|< i
  ,cfg_is_int8         //|< i
  ,cfg_is_wg           //|< i
  ,cfg_truncate        //|< i
  ,mac_a2accu_data0    //|< i
  ,mac_a2accu_data1    //|< i
  ,mac_a2accu_data2    //|< i
  ,mac_a2accu_data3    //|< i
  ,mac_a2accu_data4    //|< i
  ,mac_a2accu_data5    //|< i
  ,mac_a2accu_data6    //|< i
  ,mac_a2accu_data7    //|< i
  ,mac_a2accu_mask     //|< i
  ,mac_a2accu_mode     //|< i
  ,mac_a2accu_pvld     //|< i
  ,mac_b2accu_data0    //|< i
  ,mac_b2accu_data1    //|< i
  ,mac_b2accu_data2    //|< i
  ,mac_b2accu_data3    //|< i
  ,mac_b2accu_data4    //|< i
  ,mac_b2accu_data5    //|< i
  ,mac_b2accu_data6    //|< i
  ,mac_b2accu_data7    //|< i
  ,mac_b2accu_mask     //|< i
  ,mac_b2accu_mode     //|< i
  ,mac_b2accu_pvld     //|< i
  ,nvdla_cell_clk_0    //|< i
  ,nvdla_cell_clk_1    //|< i
  ,nvdla_cell_clk_2    //|< i
  ,nvdla_cell_clk_3    //|< i
  ,abuf_wr_addr        //|> o
  ,abuf_wr_data_0      //|> o
  ,abuf_wr_data_1      //|> o
  ,abuf_wr_data_2      //|> o
  ,abuf_wr_data_3      //|> o
  ,abuf_wr_data_4      //|> o
  ,abuf_wr_data_5      //|> o
  ,abuf_wr_data_6      //|> o
  ,abuf_wr_data_7      //|> o
  ,abuf_wr_en          //|> o
  ,dlv_data_0          //|> o
  ,dlv_data_1          //|> o
  ,dlv_data_2          //|> o
  ,dlv_data_3          //|> o
  ,dlv_data_4          //|> o
  ,dlv_data_5          //|> o
  ,dlv_data_6          //|> o
  ,dlv_data_7          //|> o
  ,dlv_mask            //|> o
  ,dlv_pd              //|> o
  ,dlv_valid           //|> o
  ,dp2reg_sat_count    //|> o
  );


input nvdla_cell_clk_0;
input nvdla_cell_clk_1;
input nvdla_cell_clk_2;
input nvdla_cell_clk_3;

input           nvdla_core_clk;
input           nvdla_core_rstn;
input   [767:0] abuf_rd_data_0;
input   [767:0] abuf_rd_data_1;
input   [767:0] abuf_rd_data_2;
input   [767:0] abuf_rd_data_3;
input   [543:0] abuf_rd_data_4;
input   [543:0] abuf_rd_data_5;
input   [543:0] abuf_rd_data_6;
input   [543:0] abuf_rd_data_7;
input   [339:0] accu_ctrl_pd;
input   [191:0] accu_ctrl_ram_valid;
input           accu_ctrl_valid;
input   [191:0] cfg_in_en_mask;
input    [24:0] cfg_is_fp;
input    [24:0] cfg_is_int;
input   [126:0] cfg_is_int8;
input    [95:0] cfg_is_wg;
input   [639:0] cfg_truncate;
input   [175:0] mac_a2accu_data0;
input   [175:0] mac_a2accu_data1;
input   [175:0] mac_a2accu_data2;
input   [175:0] mac_a2accu_data3;
input   [175:0] mac_a2accu_data4;
input   [175:0] mac_a2accu_data5;
input   [175:0] mac_a2accu_data6;
input   [175:0] mac_a2accu_data7;
input     [7:0] mac_a2accu_mask;
input     [7:0] mac_a2accu_mode;
input           mac_a2accu_pvld;
input   [175:0] mac_b2accu_data0;
input   [175:0] mac_b2accu_data1;
input   [175:0] mac_b2accu_data2;
input   [175:0] mac_b2accu_data3;
input   [175:0] mac_b2accu_data4;
input   [175:0] mac_b2accu_data5;
input   [175:0] mac_b2accu_data6;
input   [175:0] mac_b2accu_data7;
input     [7:0] mac_b2accu_mask;
input     [7:0] mac_b2accu_mode;
input           mac_b2accu_pvld;
output    [4:0] abuf_wr_addr;
output  [767:0] abuf_wr_data_0;
output  [767:0] abuf_wr_data_1;
output  [767:0] abuf_wr_data_2;
output  [767:0] abuf_wr_data_3;
output  [543:0] abuf_wr_data_4;
output  [543:0] abuf_wr_data_5;
output  [543:0] abuf_wr_data_6;
output  [543:0] abuf_wr_data_7;
output    [7:0] abuf_wr_en;
output  [511:0] dlv_data_0;
output  [511:0] dlv_data_1;
output  [511:0] dlv_data_2;
output  [511:0] dlv_data_3;
output  [511:0] dlv_data_4;
output  [511:0] dlv_data_5;
output  [511:0] dlv_data_6;
output  [511:0] dlv_data_7;
output    [7:0] dlv_mask;
output    [1:0] dlv_pd;
output          dlv_valid;
output   [31:0] dp2reg_sat_count;
wire     [47:0] abuf_wr_elem_0;
wire     [47:0] abuf_wr_elem_1;
wire     [47:0] abuf_wr_elem_10;
wire     [33:0] abuf_wr_elem_100;
wire     [33:0] abuf_wr_elem_101;
wire     [33:0] abuf_wr_elem_102;
wire     [33:0] abuf_wr_elem_103;
wire     [33:0] abuf_wr_elem_104;
wire     [33:0] abuf_wr_elem_105;
wire     [33:0] abuf_wr_elem_106;
wire     [33:0] abuf_wr_elem_107;
wire     [33:0] abuf_wr_elem_108;
wire     [33:0] abuf_wr_elem_109;
wire     [47:0] abuf_wr_elem_11;
wire     [33:0] abuf_wr_elem_110;
wire     [33:0] abuf_wr_elem_111;
wire     [33:0] abuf_wr_elem_112;
wire     [33:0] abuf_wr_elem_113;
wire     [33:0] abuf_wr_elem_114;
wire     [33:0] abuf_wr_elem_115;
wire     [33:0] abuf_wr_elem_116;
wire     [33:0] abuf_wr_elem_117;
wire     [33:0] abuf_wr_elem_118;
wire     [33:0] abuf_wr_elem_119;
wire     [47:0] abuf_wr_elem_12;
wire     [33:0] abuf_wr_elem_120;
wire     [33:0] abuf_wr_elem_121;
wire     [33:0] abuf_wr_elem_122;
wire     [33:0] abuf_wr_elem_123;
wire     [33:0] abuf_wr_elem_124;
wire     [33:0] abuf_wr_elem_125;
wire     [33:0] abuf_wr_elem_126;
wire     [33:0] abuf_wr_elem_127;
wire     [47:0] abuf_wr_elem_13;
wire     [47:0] abuf_wr_elem_14;
wire     [47:0] abuf_wr_elem_15;
wire     [47:0] abuf_wr_elem_16;
wire     [47:0] abuf_wr_elem_17;
wire     [47:0] abuf_wr_elem_18;
wire     [47:0] abuf_wr_elem_19;
wire     [47:0] abuf_wr_elem_2;
wire     [47:0] abuf_wr_elem_20;
wire     [47:0] abuf_wr_elem_21;
wire     [47:0] abuf_wr_elem_22;
wire     [47:0] abuf_wr_elem_23;
wire     [47:0] abuf_wr_elem_24;
wire     [47:0] abuf_wr_elem_25;
wire     [47:0] abuf_wr_elem_26;
wire     [47:0] abuf_wr_elem_27;
wire     [47:0] abuf_wr_elem_28;
wire     [47:0] abuf_wr_elem_29;
wire     [47:0] abuf_wr_elem_3;
wire     [47:0] abuf_wr_elem_30;
wire     [47:0] abuf_wr_elem_31;
wire     [47:0] abuf_wr_elem_32;
wire     [47:0] abuf_wr_elem_33;
wire     [47:0] abuf_wr_elem_34;
wire     [47:0] abuf_wr_elem_35;
wire     [47:0] abuf_wr_elem_36;
wire     [47:0] abuf_wr_elem_37;
wire     [47:0] abuf_wr_elem_38;
wire     [47:0] abuf_wr_elem_39;
wire     [47:0] abuf_wr_elem_4;
wire     [47:0] abuf_wr_elem_40;
wire     [47:0] abuf_wr_elem_41;
wire     [47:0] abuf_wr_elem_42;
wire     [47:0] abuf_wr_elem_43;
wire     [47:0] abuf_wr_elem_44;
wire     [47:0] abuf_wr_elem_45;
wire     [47:0] abuf_wr_elem_46;
wire     [47:0] abuf_wr_elem_47;
wire     [47:0] abuf_wr_elem_48;
wire     [47:0] abuf_wr_elem_49;
wire     [47:0] abuf_wr_elem_5;
wire     [47:0] abuf_wr_elem_50;
wire     [47:0] abuf_wr_elem_51;
wire     [47:0] abuf_wr_elem_52;
wire     [47:0] abuf_wr_elem_53;
wire     [47:0] abuf_wr_elem_54;
wire     [47:0] abuf_wr_elem_55;
wire     [47:0] abuf_wr_elem_56;
wire     [47:0] abuf_wr_elem_57;
wire     [47:0] abuf_wr_elem_58;
wire     [47:0] abuf_wr_elem_59;
wire     [47:0] abuf_wr_elem_6;
wire     [47:0] abuf_wr_elem_60;
wire     [47:0] abuf_wr_elem_61;
wire     [47:0] abuf_wr_elem_62;
wire     [47:0] abuf_wr_elem_63;
wire     [33:0] abuf_wr_elem_64;
wire     [33:0] abuf_wr_elem_65;
wire     [33:0] abuf_wr_elem_66;
wire     [33:0] abuf_wr_elem_67;
wire     [33:0] abuf_wr_elem_68;
wire     [33:0] abuf_wr_elem_69;
wire     [47:0] abuf_wr_elem_7;
wire     [33:0] abuf_wr_elem_70;
wire     [33:0] abuf_wr_elem_71;
wire     [33:0] abuf_wr_elem_72;
wire     [33:0] abuf_wr_elem_73;
wire     [33:0] abuf_wr_elem_74;
wire     [33:0] abuf_wr_elem_75;
wire     [33:0] abuf_wr_elem_76;
wire     [33:0] abuf_wr_elem_77;
wire     [33:0] abuf_wr_elem_78;
wire     [33:0] abuf_wr_elem_79;
wire     [47:0] abuf_wr_elem_8;
wire     [33:0] abuf_wr_elem_80;
wire     [33:0] abuf_wr_elem_81;
wire     [33:0] abuf_wr_elem_82;
wire     [33:0] abuf_wr_elem_83;
wire     [33:0] abuf_wr_elem_84;
wire     [33:0] abuf_wr_elem_85;
wire     [33:0] abuf_wr_elem_86;
wire     [33:0] abuf_wr_elem_87;
wire     [33:0] abuf_wr_elem_88;
wire     [33:0] abuf_wr_elem_89;
wire     [47:0] abuf_wr_elem_9;
wire     [33:0] abuf_wr_elem_90;
wire     [33:0] abuf_wr_elem_91;
wire     [33:0] abuf_wr_elem_92;
wire     [33:0] abuf_wr_elem_93;
wire     [33:0] abuf_wr_elem_94;
wire     [33:0] abuf_wr_elem_95;
wire     [33:0] abuf_wr_elem_96;
wire     [33:0] abuf_wr_elem_97;
wire     [33:0] abuf_wr_elem_98;
wire     [33:0] abuf_wr_elem_99;
wire      [4:0] calc_addr;
wire      [4:0] calc_addr_out;
wire            calc_channel_end;
wire     [43:0] calc_data_16_0;
wire     [43:0] calc_data_16_1;
wire     [43:0] calc_data_16_10;
wire     [43:0] calc_data_16_11;
wire     [43:0] calc_data_16_12;
wire     [43:0] calc_data_16_13;
wire     [43:0] calc_data_16_14;
wire     [43:0] calc_data_16_15;
wire     [43:0] calc_data_16_16;
wire     [43:0] calc_data_16_17;
wire     [43:0] calc_data_16_18;
wire     [43:0] calc_data_16_19;
wire     [43:0] calc_data_16_2;
wire     [43:0] calc_data_16_20;
wire     [43:0] calc_data_16_21;
wire     [43:0] calc_data_16_22;
wire     [43:0] calc_data_16_23;
wire     [43:0] calc_data_16_24;
wire     [43:0] calc_data_16_25;
wire     [43:0] calc_data_16_26;
wire     [43:0] calc_data_16_27;
wire     [43:0] calc_data_16_28;
wire     [43:0] calc_data_16_29;
wire     [43:0] calc_data_16_3;
wire     [43:0] calc_data_16_30;
wire     [43:0] calc_data_16_31;
wire     [43:0] calc_data_16_32;
wire     [43:0] calc_data_16_33;
wire     [43:0] calc_data_16_34;
wire     [43:0] calc_data_16_35;
wire     [43:0] calc_data_16_36;
wire     [43:0] calc_data_16_37;
wire     [43:0] calc_data_16_38;
wire     [43:0] calc_data_16_39;
wire     [43:0] calc_data_16_4;
wire     [43:0] calc_data_16_40;
wire     [43:0] calc_data_16_41;
wire     [43:0] calc_data_16_42;
wire     [43:0] calc_data_16_43;
wire     [43:0] calc_data_16_44;
wire     [43:0] calc_data_16_45;
wire     [43:0] calc_data_16_46;
wire     [43:0] calc_data_16_47;
wire     [43:0] calc_data_16_48;
wire     [43:0] calc_data_16_49;
wire     [43:0] calc_data_16_5;
wire     [43:0] calc_data_16_50;
wire     [43:0] calc_data_16_51;
wire     [43:0] calc_data_16_52;
wire     [43:0] calc_data_16_53;
wire     [43:0] calc_data_16_54;
wire     [43:0] calc_data_16_55;
wire     [43:0] calc_data_16_56;
wire     [43:0] calc_data_16_57;
wire     [43:0] calc_data_16_58;
wire     [43:0] calc_data_16_59;
wire     [43:0] calc_data_16_6;
wire     [43:0] calc_data_16_60;
wire     [43:0] calc_data_16_61;
wire     [43:0] calc_data_16_62;
wire     [43:0] calc_data_16_63;
wire     [43:0] calc_data_16_7;
wire     [43:0] calc_data_16_8;
wire     [43:0] calc_data_16_9;
wire     [43:0] calc_data_8_0;
wire     [21:0] calc_data_8_1;
wire     [43:0] calc_data_8_10;
wire     [43:0] calc_data_8_100;
wire     [21:0] calc_data_8_101;
wire     [43:0] calc_data_8_102;
wire     [21:0] calc_data_8_103;
wire     [43:0] calc_data_8_104;
wire     [21:0] calc_data_8_105;
wire     [43:0] calc_data_8_106;
wire     [21:0] calc_data_8_107;
wire     [43:0] calc_data_8_108;
wire     [21:0] calc_data_8_109;
wire     [21:0] calc_data_8_11;
wire     [43:0] calc_data_8_110;
wire     [21:0] calc_data_8_111;
wire     [43:0] calc_data_8_112;
wire     [21:0] calc_data_8_113;
wire     [43:0] calc_data_8_114;
wire     [21:0] calc_data_8_115;
wire     [43:0] calc_data_8_116;
wire     [21:0] calc_data_8_117;
wire     [43:0] calc_data_8_118;
wire     [21:0] calc_data_8_119;
wire     [43:0] calc_data_8_12;
wire     [43:0] calc_data_8_120;
wire     [21:0] calc_data_8_121;
wire     [43:0] calc_data_8_122;
wire     [21:0] calc_data_8_123;
wire     [43:0] calc_data_8_124;
wire     [21:0] calc_data_8_125;
wire     [43:0] calc_data_8_126;
wire     [21:0] calc_data_8_127;
wire     [21:0] calc_data_8_13;
wire     [43:0] calc_data_8_14;
wire     [21:0] calc_data_8_15;
wire     [43:0] calc_data_8_16;
wire     [21:0] calc_data_8_17;
wire     [43:0] calc_data_8_18;
wire     [21:0] calc_data_8_19;
wire     [43:0] calc_data_8_2;
wire     [43:0] calc_data_8_20;
wire     [21:0] calc_data_8_21;
wire     [43:0] calc_data_8_22;
wire     [21:0] calc_data_8_23;
wire     [43:0] calc_data_8_24;
wire     [21:0] calc_data_8_25;
wire     [43:0] calc_data_8_26;
wire     [21:0] calc_data_8_27;
wire     [43:0] calc_data_8_28;
wire     [21:0] calc_data_8_29;
wire     [21:0] calc_data_8_3;
wire     [43:0] calc_data_8_30;
wire     [21:0] calc_data_8_31;
wire     [43:0] calc_data_8_32;
wire     [21:0] calc_data_8_33;
wire     [43:0] calc_data_8_34;
wire     [21:0] calc_data_8_35;
wire     [43:0] calc_data_8_36;
wire     [21:0] calc_data_8_37;
wire     [43:0] calc_data_8_38;
wire     [21:0] calc_data_8_39;
wire     [43:0] calc_data_8_4;
wire     [43:0] calc_data_8_40;
wire     [21:0] calc_data_8_41;
wire     [43:0] calc_data_8_42;
wire     [21:0] calc_data_8_43;
wire     [43:0] calc_data_8_44;
wire     [21:0] calc_data_8_45;
wire     [43:0] calc_data_8_46;
wire     [21:0] calc_data_8_47;
wire     [43:0] calc_data_8_48;
wire     [21:0] calc_data_8_49;
wire     [21:0] calc_data_8_5;
wire     [43:0] calc_data_8_50;
wire     [21:0] calc_data_8_51;
wire     [43:0] calc_data_8_52;
wire     [21:0] calc_data_8_53;
wire     [43:0] calc_data_8_54;
wire     [21:0] calc_data_8_55;
wire     [43:0] calc_data_8_56;
wire     [21:0] calc_data_8_57;
wire     [43:0] calc_data_8_58;
wire     [21:0] calc_data_8_59;
wire     [43:0] calc_data_8_6;
wire     [43:0] calc_data_8_60;
wire     [21:0] calc_data_8_61;
wire     [43:0] calc_data_8_62;
wire     [21:0] calc_data_8_63;
wire     [43:0] calc_data_8_64;
wire     [21:0] calc_data_8_65;
wire     [43:0] calc_data_8_66;
wire     [21:0] calc_data_8_67;
wire     [43:0] calc_data_8_68;
wire     [21:0] calc_data_8_69;
wire     [21:0] calc_data_8_7;
wire     [43:0] calc_data_8_70;
wire     [21:0] calc_data_8_71;
wire     [43:0] calc_data_8_72;
wire     [21:0] calc_data_8_73;
wire     [43:0] calc_data_8_74;
wire     [21:0] calc_data_8_75;
wire     [43:0] calc_data_8_76;
wire     [21:0] calc_data_8_77;
wire     [43:0] calc_data_8_78;
wire     [21:0] calc_data_8_79;
wire     [43:0] calc_data_8_8;
wire     [43:0] calc_data_8_80;
wire     [21:0] calc_data_8_81;
wire     [43:0] calc_data_8_82;
wire     [21:0] calc_data_8_83;
wire     [43:0] calc_data_8_84;
wire     [21:0] calc_data_8_85;
wire     [43:0] calc_data_8_86;
wire     [21:0] calc_data_8_87;
wire     [43:0] calc_data_8_88;
wire     [21:0] calc_data_8_89;
wire     [21:0] calc_data_8_9;
wire     [43:0] calc_data_8_90;
wire     [21:0] calc_data_8_91;
wire     [43:0] calc_data_8_92;
wire     [21:0] calc_data_8_93;
wire     [43:0] calc_data_8_94;
wire     [21:0] calc_data_8_95;
wire     [43:0] calc_data_8_96;
wire     [21:0] calc_data_8_97;
wire     [43:0] calc_data_8_98;
wire     [21:0] calc_data_8_99;
wire   [2815:0] calc_data_all;
wire     [31:0] calc_dlv_elem_0;
wire     [31:0] calc_dlv_elem_1;
wire     [31:0] calc_dlv_elem_10;
wire     [31:0] calc_dlv_elem_100;
wire     [31:0] calc_dlv_elem_101;
wire     [31:0] calc_dlv_elem_102;
wire     [31:0] calc_dlv_elem_103;
wire     [31:0] calc_dlv_elem_104;
wire     [31:0] calc_dlv_elem_105;
wire     [31:0] calc_dlv_elem_106;
wire     [31:0] calc_dlv_elem_107;
wire     [31:0] calc_dlv_elem_108;
wire     [31:0] calc_dlv_elem_109;
wire     [31:0] calc_dlv_elem_11;
wire     [31:0] calc_dlv_elem_110;
wire     [31:0] calc_dlv_elem_111;
wire     [31:0] calc_dlv_elem_112;
wire     [31:0] calc_dlv_elem_113;
wire     [31:0] calc_dlv_elem_114;
wire     [31:0] calc_dlv_elem_115;
wire     [31:0] calc_dlv_elem_116;
wire     [31:0] calc_dlv_elem_117;
wire     [31:0] calc_dlv_elem_118;
wire     [31:0] calc_dlv_elem_119;
wire     [31:0] calc_dlv_elem_12;
wire     [31:0] calc_dlv_elem_120;
wire     [31:0] calc_dlv_elem_121;
wire     [31:0] calc_dlv_elem_122;
wire     [31:0] calc_dlv_elem_123;
wire     [31:0] calc_dlv_elem_124;
wire     [31:0] calc_dlv_elem_125;
wire     [31:0] calc_dlv_elem_126;
wire     [31:0] calc_dlv_elem_127;
wire     [31:0] calc_dlv_elem_13;
wire     [31:0] calc_dlv_elem_14;
wire     [31:0] calc_dlv_elem_15;
wire     [31:0] calc_dlv_elem_16;
wire     [31:0] calc_dlv_elem_17;
wire     [31:0] calc_dlv_elem_18;
wire     [31:0] calc_dlv_elem_19;
wire     [31:0] calc_dlv_elem_2;
wire     [31:0] calc_dlv_elem_20;
wire     [31:0] calc_dlv_elem_21;
wire     [31:0] calc_dlv_elem_22;
wire     [31:0] calc_dlv_elem_23;
wire     [31:0] calc_dlv_elem_24;
wire     [31:0] calc_dlv_elem_25;
wire     [31:0] calc_dlv_elem_26;
wire     [31:0] calc_dlv_elem_27;
wire     [31:0] calc_dlv_elem_28;
wire     [31:0] calc_dlv_elem_29;
wire     [31:0] calc_dlv_elem_3;
wire     [31:0] calc_dlv_elem_30;
wire     [31:0] calc_dlv_elem_31;
wire     [31:0] calc_dlv_elem_32;
wire     [31:0] calc_dlv_elem_33;
wire     [31:0] calc_dlv_elem_34;
wire     [31:0] calc_dlv_elem_35;
wire     [31:0] calc_dlv_elem_36;
wire     [31:0] calc_dlv_elem_37;
wire     [31:0] calc_dlv_elem_38;
wire     [31:0] calc_dlv_elem_39;
wire     [31:0] calc_dlv_elem_4;
wire     [31:0] calc_dlv_elem_40;
wire     [31:0] calc_dlv_elem_41;
wire     [31:0] calc_dlv_elem_42;
wire     [31:0] calc_dlv_elem_43;
wire     [31:0] calc_dlv_elem_44;
wire     [31:0] calc_dlv_elem_45;
wire     [31:0] calc_dlv_elem_46;
wire     [31:0] calc_dlv_elem_47;
wire     [31:0] calc_dlv_elem_48;
wire     [31:0] calc_dlv_elem_49;
wire     [31:0] calc_dlv_elem_5;
wire     [31:0] calc_dlv_elem_50;
wire     [31:0] calc_dlv_elem_51;
wire     [31:0] calc_dlv_elem_52;
wire     [31:0] calc_dlv_elem_53;
wire     [31:0] calc_dlv_elem_54;
wire     [31:0] calc_dlv_elem_55;
wire     [31:0] calc_dlv_elem_56;
wire     [31:0] calc_dlv_elem_57;
wire     [31:0] calc_dlv_elem_58;
wire     [31:0] calc_dlv_elem_59;
wire     [31:0] calc_dlv_elem_6;
wire     [31:0] calc_dlv_elem_60;
wire     [31:0] calc_dlv_elem_61;
wire     [31:0] calc_dlv_elem_62;
wire     [31:0] calc_dlv_elem_63;
wire     [31:0] calc_dlv_elem_64;
wire     [31:0] calc_dlv_elem_65;
wire     [31:0] calc_dlv_elem_66;
wire     [31:0] calc_dlv_elem_67;
wire     [31:0] calc_dlv_elem_68;
wire     [31:0] calc_dlv_elem_69;
wire     [31:0] calc_dlv_elem_7;
wire     [31:0] calc_dlv_elem_70;
wire     [31:0] calc_dlv_elem_71;
wire     [31:0] calc_dlv_elem_72;
wire     [31:0] calc_dlv_elem_73;
wire     [31:0] calc_dlv_elem_74;
wire     [31:0] calc_dlv_elem_75;
wire     [31:0] calc_dlv_elem_76;
wire     [31:0] calc_dlv_elem_77;
wire     [31:0] calc_dlv_elem_78;
wire     [31:0] calc_dlv_elem_79;
wire     [31:0] calc_dlv_elem_8;
wire     [31:0] calc_dlv_elem_80;
wire     [31:0] calc_dlv_elem_81;
wire     [31:0] calc_dlv_elem_82;
wire     [31:0] calc_dlv_elem_83;
wire     [31:0] calc_dlv_elem_84;
wire     [31:0] calc_dlv_elem_85;
wire     [31:0] calc_dlv_elem_86;
wire     [31:0] calc_dlv_elem_87;
wire     [31:0] calc_dlv_elem_88;
wire     [31:0] calc_dlv_elem_89;
wire     [31:0] calc_dlv_elem_9;
wire     [31:0] calc_dlv_elem_90;
wire     [31:0] calc_dlv_elem_91;
wire     [31:0] calc_dlv_elem_92;
wire     [31:0] calc_dlv_elem_93;
wire     [31:0] calc_dlv_elem_94;
wire     [31:0] calc_dlv_elem_95;
wire     [31:0] calc_dlv_elem_96;
wire     [31:0] calc_dlv_elem_97;
wire     [31:0] calc_dlv_elem_98;
wire     [31:0] calc_dlv_elem_99;
wire    [191:0] calc_dlv_elem_en;
wire    [191:0] calc_dlv_elem_mask;
wire     [63:0] calc_dlv_en_fp;
wire    [127:0] calc_dlv_en_int;
wire      [7:0] calc_dlv_en_out;
wire            calc_dlv_valid_out;
wire     [43:0] calc_elem_0_w;
wire     [21:0] calc_elem_100_w;
wire     [21:0] calc_elem_101_w;
wire     [21:0] calc_elem_102_w;
wire     [21:0] calc_elem_103_w;
wire     [21:0] calc_elem_104_w;
wire     [21:0] calc_elem_105_w;
wire     [21:0] calc_elem_106_w;
wire     [21:0] calc_elem_107_w;
wire     [21:0] calc_elem_108_w;
wire     [21:0] calc_elem_109_w;
wire     [43:0] calc_elem_10_w;
wire     [21:0] calc_elem_110_w;
wire     [21:0] calc_elem_111_w;
wire     [21:0] calc_elem_112_w;
wire     [21:0] calc_elem_113_w;
wire     [21:0] calc_elem_114_w;
wire     [21:0] calc_elem_115_w;
wire     [21:0] calc_elem_116_w;
wire     [21:0] calc_elem_117_w;
wire     [21:0] calc_elem_118_w;
wire     [21:0] calc_elem_119_w;
wire     [43:0] calc_elem_11_w;
wire     [21:0] calc_elem_120_w;
wire     [21:0] calc_elem_121_w;
wire     [21:0] calc_elem_122_w;
wire     [21:0] calc_elem_123_w;
wire     [21:0] calc_elem_124_w;
wire     [21:0] calc_elem_125_w;
wire     [21:0] calc_elem_126_w;
wire     [21:0] calc_elem_127_w;
wire     [43:0] calc_elem_12_w;
wire     [43:0] calc_elem_13_w;
wire     [43:0] calc_elem_14_w;
wire     [43:0] calc_elem_15_w;
wire     [43:0] calc_elem_16_w;
wire     [43:0] calc_elem_17_w;
wire     [43:0] calc_elem_18_w;
wire     [43:0] calc_elem_19_w;
wire     [43:0] calc_elem_1_w;
wire     [43:0] calc_elem_20_w;
wire     [43:0] calc_elem_21_w;
wire     [43:0] calc_elem_22_w;
wire     [43:0] calc_elem_23_w;
wire     [43:0] calc_elem_24_w;
wire     [43:0] calc_elem_25_w;
wire     [43:0] calc_elem_26_w;
wire     [43:0] calc_elem_27_w;
wire     [43:0] calc_elem_28_w;
wire     [43:0] calc_elem_29_w;
wire     [43:0] calc_elem_2_w;
wire     [43:0] calc_elem_30_w;
wire     [43:0] calc_elem_31_w;
wire     [43:0] calc_elem_32_w;
wire     [43:0] calc_elem_33_w;
wire     [43:0] calc_elem_34_w;
wire     [43:0] calc_elem_35_w;
wire     [43:0] calc_elem_36_w;
wire     [43:0] calc_elem_37_w;
wire     [43:0] calc_elem_38_w;
wire     [43:0] calc_elem_39_w;
wire     [43:0] calc_elem_3_w;
wire     [43:0] calc_elem_40_w;
wire     [43:0] calc_elem_41_w;
wire     [43:0] calc_elem_42_w;
wire     [43:0] calc_elem_43_w;
wire     [43:0] calc_elem_44_w;
wire     [43:0] calc_elem_45_w;
wire     [43:0] calc_elem_46_w;
wire     [43:0] calc_elem_47_w;
wire     [43:0] calc_elem_48_w;
wire     [43:0] calc_elem_49_w;
wire     [43:0] calc_elem_4_w;
wire     [43:0] calc_elem_50_w;
wire     [43:0] calc_elem_51_w;
wire     [43:0] calc_elem_52_w;
wire     [43:0] calc_elem_53_w;
wire     [43:0] calc_elem_54_w;
wire     [43:0] calc_elem_55_w;
wire     [43:0] calc_elem_56_w;
wire     [43:0] calc_elem_57_w;
wire     [43:0] calc_elem_58_w;
wire     [43:0] calc_elem_59_w;
wire     [43:0] calc_elem_5_w;
wire     [43:0] calc_elem_60_w;
wire     [43:0] calc_elem_61_w;
wire     [43:0] calc_elem_62_w;
wire     [43:0] calc_elem_63_w;
wire     [21:0] calc_elem_64_w;
wire     [21:0] calc_elem_65_w;
wire     [21:0] calc_elem_66_w;
wire     [21:0] calc_elem_67_w;
wire     [21:0] calc_elem_68_w;
wire     [21:0] calc_elem_69_w;
wire     [43:0] calc_elem_6_w;
wire     [21:0] calc_elem_70_w;
wire     [21:0] calc_elem_71_w;
wire     [21:0] calc_elem_72_w;
wire     [21:0] calc_elem_73_w;
wire     [21:0] calc_elem_74_w;
wire     [21:0] calc_elem_75_w;
wire     [21:0] calc_elem_76_w;
wire     [21:0] calc_elem_77_w;
wire     [21:0] calc_elem_78_w;
wire     [21:0] calc_elem_79_w;
wire     [43:0] calc_elem_7_w;
wire     [21:0] calc_elem_80_w;
wire     [21:0] calc_elem_81_w;
wire     [21:0] calc_elem_82_w;
wire     [21:0] calc_elem_83_w;
wire     [21:0] calc_elem_84_w;
wire     [21:0] calc_elem_85_w;
wire     [21:0] calc_elem_86_w;
wire     [21:0] calc_elem_87_w;
wire     [21:0] calc_elem_88_w;
wire     [21:0] calc_elem_89_w;
wire     [43:0] calc_elem_8_w;
wire     [21:0] calc_elem_90_w;
wire     [21:0] calc_elem_91_w;
wire     [21:0] calc_elem_92_w;
wire     [21:0] calc_elem_93_w;
wire     [21:0] calc_elem_94_w;
wire     [21:0] calc_elem_95_w;
wire     [21:0] calc_elem_96_w;
wire     [21:0] calc_elem_97_w;
wire     [21:0] calc_elem_98_w;
wire     [21:0] calc_elem_99_w;
wire     [43:0] calc_elem_9_w;
wire    [191:0] calc_elem_en;
wire    [191:0] calc_elem_op1_vld;
wire     [31:0] calc_fout_0;
wire     [31:0] calc_fout_1;
wire     [31:0] calc_fout_10;
wire     [31:0] calc_fout_100;
wire     [31:0] calc_fout_101;
wire     [31:0] calc_fout_102;
wire     [31:0] calc_fout_103;
wire     [31:0] calc_fout_104;
wire     [31:0] calc_fout_105;
wire     [31:0] calc_fout_106;
wire     [31:0] calc_fout_107;
wire     [31:0] calc_fout_108;
wire     [31:0] calc_fout_109;
wire     [31:0] calc_fout_11;
wire     [31:0] calc_fout_110;
wire     [31:0] calc_fout_111;
wire     [31:0] calc_fout_112;
wire     [31:0] calc_fout_113;
wire     [31:0] calc_fout_114;
wire     [31:0] calc_fout_115;
wire     [31:0] calc_fout_116;
wire     [31:0] calc_fout_117;
wire     [31:0] calc_fout_118;
wire     [31:0] calc_fout_119;
wire     [31:0] calc_fout_12;
wire     [31:0] calc_fout_120;
wire     [31:0] calc_fout_121;
wire     [31:0] calc_fout_122;
wire     [31:0] calc_fout_123;
wire     [31:0] calc_fout_124;
wire     [31:0] calc_fout_125;
wire     [31:0] calc_fout_126;
wire     [31:0] calc_fout_127;
wire     [31:0] calc_fout_13;
wire     [31:0] calc_fout_14;
wire     [31:0] calc_fout_15;
wire     [31:0] calc_fout_16;
wire     [31:0] calc_fout_17;
wire     [31:0] calc_fout_18;
wire     [31:0] calc_fout_19;
wire     [31:0] calc_fout_2;
wire     [31:0] calc_fout_20;
wire     [31:0] calc_fout_21;
wire     [31:0] calc_fout_22;
wire     [31:0] calc_fout_23;
wire     [31:0] calc_fout_24;
wire     [31:0] calc_fout_25;
wire     [31:0] calc_fout_26;
wire     [31:0] calc_fout_27;
wire     [31:0] calc_fout_28;
wire     [31:0] calc_fout_29;
wire     [31:0] calc_fout_3;
wire     [31:0] calc_fout_30;
wire     [31:0] calc_fout_31;
wire     [31:0] calc_fout_32;
wire     [31:0] calc_fout_33;
wire     [31:0] calc_fout_34;
wire     [31:0] calc_fout_35;
wire     [31:0] calc_fout_36;
wire     [31:0] calc_fout_37;
wire     [31:0] calc_fout_38;
wire     [31:0] calc_fout_39;
wire     [31:0] calc_fout_4;
wire     [31:0] calc_fout_40;
wire     [31:0] calc_fout_41;
wire     [31:0] calc_fout_42;
wire     [31:0] calc_fout_43;
wire     [31:0] calc_fout_44;
wire     [31:0] calc_fout_45;
wire     [31:0] calc_fout_46;
wire     [31:0] calc_fout_47;
wire     [31:0] calc_fout_48;
wire     [31:0] calc_fout_49;
wire     [31:0] calc_fout_5;
wire     [31:0] calc_fout_50;
wire     [31:0] calc_fout_51;
wire     [31:0] calc_fout_52;
wire     [31:0] calc_fout_53;
wire     [31:0] calc_fout_54;
wire     [31:0] calc_fout_55;
wire     [31:0] calc_fout_56;
wire     [31:0] calc_fout_57;
wire     [31:0] calc_fout_58;
wire     [31:0] calc_fout_59;
wire     [31:0] calc_fout_6;
wire     [31:0] calc_fout_60;
wire     [31:0] calc_fout_61;
wire     [31:0] calc_fout_62;
wire     [31:0] calc_fout_63;
wire     [31:0] calc_fout_64;
wire     [31:0] calc_fout_65;
wire     [31:0] calc_fout_66;
wire     [31:0] calc_fout_67;
wire     [31:0] calc_fout_68;
wire     [31:0] calc_fout_69;
wire     [31:0] calc_fout_7;
wire     [31:0] calc_fout_70;
wire     [31:0] calc_fout_71;
wire     [31:0] calc_fout_72;
wire     [31:0] calc_fout_73;
wire     [31:0] calc_fout_74;
wire     [31:0] calc_fout_75;
wire     [31:0] calc_fout_76;
wire     [31:0] calc_fout_77;
wire     [31:0] calc_fout_78;
wire     [31:0] calc_fout_79;
wire     [31:0] calc_fout_8;
wire     [31:0] calc_fout_80;
wire     [31:0] calc_fout_81;
wire     [31:0] calc_fout_82;
wire     [31:0] calc_fout_83;
wire     [31:0] calc_fout_84;
wire     [31:0] calc_fout_85;
wire     [31:0] calc_fout_86;
wire     [31:0] calc_fout_87;
wire     [31:0] calc_fout_88;
wire     [31:0] calc_fout_89;
wire     [31:0] calc_fout_9;
wire     [31:0] calc_fout_90;
wire     [31:0] calc_fout_91;
wire     [31:0] calc_fout_92;
wire     [31:0] calc_fout_93;
wire     [31:0] calc_fout_94;
wire     [31:0] calc_fout_95;
wire     [31:0] calc_fout_96;
wire     [31:0] calc_fout_97;
wire     [31:0] calc_fout_98;
wire     [31:0] calc_fout_99;
wire     [31:0] calc_fout_fp_0_sum;
wire     [31:0] calc_fout_fp_10_sum;
wire     [31:0] calc_fout_fp_11_sum;
wire     [31:0] calc_fout_fp_12_sum;
wire     [31:0] calc_fout_fp_13_sum;
wire     [31:0] calc_fout_fp_14_sum;
wire     [31:0] calc_fout_fp_15_sum;
wire     [31:0] calc_fout_fp_16_sum;
wire     [31:0] calc_fout_fp_17_sum;
wire     [31:0] calc_fout_fp_18_sum;
wire     [31:0] calc_fout_fp_19_sum;
wire     [31:0] calc_fout_fp_1_sum;
wire     [31:0] calc_fout_fp_20_sum;
wire     [31:0] calc_fout_fp_21_sum;
wire     [31:0] calc_fout_fp_22_sum;
wire     [31:0] calc_fout_fp_23_sum;
wire     [31:0] calc_fout_fp_24_sum;
wire     [31:0] calc_fout_fp_25_sum;
wire     [31:0] calc_fout_fp_26_sum;
wire     [31:0] calc_fout_fp_27_sum;
wire     [31:0] calc_fout_fp_28_sum;
wire     [31:0] calc_fout_fp_29_sum;
wire     [31:0] calc_fout_fp_2_sum;
wire     [31:0] calc_fout_fp_30_sum;
wire     [31:0] calc_fout_fp_31_sum;
wire     [31:0] calc_fout_fp_32_sum;
wire     [31:0] calc_fout_fp_33_sum;
wire     [31:0] calc_fout_fp_34_sum;
wire     [31:0] calc_fout_fp_35_sum;
wire     [31:0] calc_fout_fp_36_sum;
wire     [31:0] calc_fout_fp_37_sum;
wire     [31:0] calc_fout_fp_38_sum;
wire     [31:0] calc_fout_fp_39_sum;
wire     [31:0] calc_fout_fp_3_sum;
wire     [31:0] calc_fout_fp_40_sum;
wire     [31:0] calc_fout_fp_41_sum;
wire     [31:0] calc_fout_fp_42_sum;
wire     [31:0] calc_fout_fp_43_sum;
wire     [31:0] calc_fout_fp_44_sum;
wire     [31:0] calc_fout_fp_45_sum;
wire     [31:0] calc_fout_fp_46_sum;
wire     [31:0] calc_fout_fp_47_sum;
wire     [31:0] calc_fout_fp_48_sum;
wire     [31:0] calc_fout_fp_49_sum;
wire     [31:0] calc_fout_fp_4_sum;
wire     [31:0] calc_fout_fp_50_sum;
wire     [31:0] calc_fout_fp_51_sum;
wire     [31:0] calc_fout_fp_52_sum;
wire     [31:0] calc_fout_fp_53_sum;
wire     [31:0] calc_fout_fp_54_sum;
wire     [31:0] calc_fout_fp_55_sum;
wire     [31:0] calc_fout_fp_56_sum;
wire     [31:0] calc_fout_fp_57_sum;
wire     [31:0] calc_fout_fp_58_sum;
wire     [31:0] calc_fout_fp_59_sum;
wire     [31:0] calc_fout_fp_5_sum;
wire     [31:0] calc_fout_fp_60_sum;
wire     [31:0] calc_fout_fp_61_sum;
wire     [31:0] calc_fout_fp_62_sum;
wire     [31:0] calc_fout_fp_63_sum;
wire     [31:0] calc_fout_fp_6_sum;
wire     [31:0] calc_fout_fp_7_sum;
wire     [31:0] calc_fout_fp_8_sum;
wire     [31:0] calc_fout_fp_9_sum;
wire     [63:0] calc_fout_fp_vld;
wire     [31:0] calc_fout_int_0_sum;
wire     [31:0] calc_fout_int_100_sum;
wire     [31:0] calc_fout_int_101_sum;
wire     [31:0] calc_fout_int_102_sum;
wire     [31:0] calc_fout_int_103_sum;
wire     [31:0] calc_fout_int_104_sum;
wire     [31:0] calc_fout_int_105_sum;
wire     [31:0] calc_fout_int_106_sum;
wire     [31:0] calc_fout_int_107_sum;
wire     [31:0] calc_fout_int_108_sum;
wire     [31:0] calc_fout_int_109_sum;
wire     [31:0] calc_fout_int_10_sum;
wire     [31:0] calc_fout_int_110_sum;
wire     [31:0] calc_fout_int_111_sum;
wire     [31:0] calc_fout_int_112_sum;
wire     [31:0] calc_fout_int_113_sum;
wire     [31:0] calc_fout_int_114_sum;
wire     [31:0] calc_fout_int_115_sum;
wire     [31:0] calc_fout_int_116_sum;
wire     [31:0] calc_fout_int_117_sum;
wire     [31:0] calc_fout_int_118_sum;
wire     [31:0] calc_fout_int_119_sum;
wire     [31:0] calc_fout_int_11_sum;
wire     [31:0] calc_fout_int_120_sum;
wire     [31:0] calc_fout_int_121_sum;
wire     [31:0] calc_fout_int_122_sum;
wire     [31:0] calc_fout_int_123_sum;
wire     [31:0] calc_fout_int_124_sum;
wire     [31:0] calc_fout_int_125_sum;
wire     [31:0] calc_fout_int_126_sum;
wire     [31:0] calc_fout_int_127_sum;
wire     [31:0] calc_fout_int_12_sum;
wire     [31:0] calc_fout_int_13_sum;
wire     [31:0] calc_fout_int_14_sum;
wire     [31:0] calc_fout_int_15_sum;
wire     [31:0] calc_fout_int_16_sum;
wire     [31:0] calc_fout_int_17_sum;
wire     [31:0] calc_fout_int_18_sum;
wire     [31:0] calc_fout_int_19_sum;
wire     [31:0] calc_fout_int_1_sum;
wire     [31:0] calc_fout_int_20_sum;
wire     [31:0] calc_fout_int_21_sum;
wire     [31:0] calc_fout_int_22_sum;
wire     [31:0] calc_fout_int_23_sum;
wire     [31:0] calc_fout_int_24_sum;
wire     [31:0] calc_fout_int_25_sum;
wire     [31:0] calc_fout_int_26_sum;
wire     [31:0] calc_fout_int_27_sum;
wire     [31:0] calc_fout_int_28_sum;
wire     [31:0] calc_fout_int_29_sum;
wire     [31:0] calc_fout_int_2_sum;
wire     [31:0] calc_fout_int_30_sum;
wire     [31:0] calc_fout_int_31_sum;
wire     [31:0] calc_fout_int_32_sum;
wire     [31:0] calc_fout_int_33_sum;
wire     [31:0] calc_fout_int_34_sum;
wire     [31:0] calc_fout_int_35_sum;
wire     [31:0] calc_fout_int_36_sum;
wire     [31:0] calc_fout_int_37_sum;
wire     [31:0] calc_fout_int_38_sum;
wire     [31:0] calc_fout_int_39_sum;
wire     [31:0] calc_fout_int_3_sum;
wire     [31:0] calc_fout_int_40_sum;
wire     [31:0] calc_fout_int_41_sum;
wire     [31:0] calc_fout_int_42_sum;
wire     [31:0] calc_fout_int_43_sum;
wire     [31:0] calc_fout_int_44_sum;
wire     [31:0] calc_fout_int_45_sum;
wire     [31:0] calc_fout_int_46_sum;
wire     [31:0] calc_fout_int_47_sum;
wire     [31:0] calc_fout_int_48_sum;
wire     [31:0] calc_fout_int_49_sum;
wire     [31:0] calc_fout_int_4_sum;
wire     [31:0] calc_fout_int_50_sum;
wire     [31:0] calc_fout_int_51_sum;
wire     [31:0] calc_fout_int_52_sum;
wire     [31:0] calc_fout_int_53_sum;
wire     [31:0] calc_fout_int_54_sum;
wire     [31:0] calc_fout_int_55_sum;
wire     [31:0] calc_fout_int_56_sum;
wire     [31:0] calc_fout_int_57_sum;
wire     [31:0] calc_fout_int_58_sum;
wire     [31:0] calc_fout_int_59_sum;
wire     [31:0] calc_fout_int_5_sum;
wire     [31:0] calc_fout_int_60_sum;
wire     [31:0] calc_fout_int_61_sum;
wire     [31:0] calc_fout_int_62_sum;
wire     [31:0] calc_fout_int_63_sum;
wire     [31:0] calc_fout_int_64_sum;
wire     [31:0] calc_fout_int_65_sum;
wire     [31:0] calc_fout_int_66_sum;
wire     [31:0] calc_fout_int_67_sum;
wire     [31:0] calc_fout_int_68_sum;
wire     [31:0] calc_fout_int_69_sum;
wire     [31:0] calc_fout_int_6_sum;
wire     [31:0] calc_fout_int_70_sum;
wire     [31:0] calc_fout_int_71_sum;
wire     [31:0] calc_fout_int_72_sum;
wire     [31:0] calc_fout_int_73_sum;
wire     [31:0] calc_fout_int_74_sum;
wire     [31:0] calc_fout_int_75_sum;
wire     [31:0] calc_fout_int_76_sum;
wire     [31:0] calc_fout_int_77_sum;
wire     [31:0] calc_fout_int_78_sum;
wire     [31:0] calc_fout_int_79_sum;
wire     [31:0] calc_fout_int_7_sum;
wire     [31:0] calc_fout_int_80_sum;
wire     [31:0] calc_fout_int_81_sum;
wire     [31:0] calc_fout_int_82_sum;
wire     [31:0] calc_fout_int_83_sum;
wire     [31:0] calc_fout_int_84_sum;
wire     [31:0] calc_fout_int_85_sum;
wire     [31:0] calc_fout_int_86_sum;
wire     [31:0] calc_fout_int_87_sum;
wire     [31:0] calc_fout_int_88_sum;
wire     [31:0] calc_fout_int_89_sum;
wire     [31:0] calc_fout_int_8_sum;
wire     [31:0] calc_fout_int_90_sum;
wire     [31:0] calc_fout_int_91_sum;
wire     [31:0] calc_fout_int_92_sum;
wire     [31:0] calc_fout_int_93_sum;
wire     [31:0] calc_fout_int_94_sum;
wire     [31:0] calc_fout_int_95_sum;
wire     [31:0] calc_fout_int_96_sum;
wire     [31:0] calc_fout_int_97_sum;
wire     [31:0] calc_fout_int_98_sum;
wire     [31:0] calc_fout_int_99_sum;
wire     [31:0] calc_fout_int_9_sum;
wire    [127:0] calc_fout_int_sat;
wire    [127:0] calc_fout_int_vld;
wire            calc_layer_end;
wire            calc_layer_end_out;
wire      [3:0] calc_mode;
wire     [63:0] calc_op1_vld_fp;
wire    [127:0] calc_op1_vld_int;
wire     [63:0] calc_op_en_fp;
wire    [127:0] calc_op_en_int;
wire     [47:0] calc_pout_0;
wire     [47:0] calc_pout_1;
wire     [47:0] calc_pout_10;
wire     [33:0] calc_pout_100;
wire     [33:0] calc_pout_101;
wire     [33:0] calc_pout_102;
wire     [33:0] calc_pout_103;
wire     [33:0] calc_pout_104;
wire     [33:0] calc_pout_105;
wire     [33:0] calc_pout_106;
wire     [33:0] calc_pout_107;
wire     [33:0] calc_pout_108;
wire     [33:0] calc_pout_109;
wire     [47:0] calc_pout_11;
wire     [33:0] calc_pout_110;
wire     [33:0] calc_pout_111;
wire     [33:0] calc_pout_112;
wire     [33:0] calc_pout_113;
wire     [33:0] calc_pout_114;
wire     [33:0] calc_pout_115;
wire     [33:0] calc_pout_116;
wire     [33:0] calc_pout_117;
wire     [33:0] calc_pout_118;
wire     [33:0] calc_pout_119;
wire     [47:0] calc_pout_12;
wire     [33:0] calc_pout_120;
wire     [33:0] calc_pout_121;
wire     [33:0] calc_pout_122;
wire     [33:0] calc_pout_123;
wire     [33:0] calc_pout_124;
wire     [33:0] calc_pout_125;
wire     [33:0] calc_pout_126;
wire     [33:0] calc_pout_127;
wire     [47:0] calc_pout_13;
wire     [47:0] calc_pout_14;
wire     [47:0] calc_pout_15;
wire     [47:0] calc_pout_16;
wire     [47:0] calc_pout_17;
wire     [47:0] calc_pout_18;
wire     [47:0] calc_pout_19;
wire     [47:0] calc_pout_2;
wire     [47:0] calc_pout_20;
wire     [47:0] calc_pout_21;
wire     [47:0] calc_pout_22;
wire     [47:0] calc_pout_23;
wire     [47:0] calc_pout_24;
wire     [47:0] calc_pout_25;
wire     [47:0] calc_pout_26;
wire     [47:0] calc_pout_27;
wire     [47:0] calc_pout_28;
wire     [47:0] calc_pout_29;
wire     [47:0] calc_pout_3;
wire     [47:0] calc_pout_30;
wire     [47:0] calc_pout_31;
wire     [47:0] calc_pout_32;
wire     [47:0] calc_pout_33;
wire     [47:0] calc_pout_34;
wire     [47:0] calc_pout_35;
wire     [47:0] calc_pout_36;
wire     [47:0] calc_pout_37;
wire     [47:0] calc_pout_38;
wire     [47:0] calc_pout_39;
wire     [47:0] calc_pout_4;
wire     [47:0] calc_pout_40;
wire     [47:0] calc_pout_41;
wire     [47:0] calc_pout_42;
wire     [47:0] calc_pout_43;
wire     [47:0] calc_pout_44;
wire     [47:0] calc_pout_45;
wire     [47:0] calc_pout_46;
wire     [47:0] calc_pout_47;
wire     [47:0] calc_pout_48;
wire     [47:0] calc_pout_49;
wire     [47:0] calc_pout_5;
wire     [47:0] calc_pout_50;
wire     [47:0] calc_pout_51;
wire     [47:0] calc_pout_52;
wire     [47:0] calc_pout_53;
wire     [47:0] calc_pout_54;
wire     [47:0] calc_pout_55;
wire     [47:0] calc_pout_56;
wire     [47:0] calc_pout_57;
wire     [47:0] calc_pout_58;
wire     [47:0] calc_pout_59;
wire     [47:0] calc_pout_6;
wire     [47:0] calc_pout_60;
wire     [47:0] calc_pout_61;
wire     [47:0] calc_pout_62;
wire     [47:0] calc_pout_63;
wire     [33:0] calc_pout_64;
wire     [33:0] calc_pout_65;
wire     [33:0] calc_pout_66;
wire     [33:0] calc_pout_67;
wire     [33:0] calc_pout_68;
wire     [33:0] calc_pout_69;
wire     [47:0] calc_pout_7;
wire     [33:0] calc_pout_70;
wire     [33:0] calc_pout_71;
wire     [33:0] calc_pout_72;
wire     [33:0] calc_pout_73;
wire     [33:0] calc_pout_74;
wire     [33:0] calc_pout_75;
wire     [33:0] calc_pout_76;
wire     [33:0] calc_pout_77;
wire     [33:0] calc_pout_78;
wire     [33:0] calc_pout_79;
wire     [47:0] calc_pout_8;
wire     [33:0] calc_pout_80;
wire     [33:0] calc_pout_81;
wire     [33:0] calc_pout_82;
wire     [33:0] calc_pout_83;
wire     [33:0] calc_pout_84;
wire     [33:0] calc_pout_85;
wire     [33:0] calc_pout_86;
wire     [33:0] calc_pout_87;
wire     [33:0] calc_pout_88;
wire     [33:0] calc_pout_89;
wire     [47:0] calc_pout_9;
wire     [33:0] calc_pout_90;
wire     [33:0] calc_pout_91;
wire     [33:0] calc_pout_92;
wire     [33:0] calc_pout_93;
wire     [33:0] calc_pout_94;
wire     [33:0] calc_pout_95;
wire     [33:0] calc_pout_96;
wire     [33:0] calc_pout_97;
wire     [33:0] calc_pout_98;
wire     [33:0] calc_pout_99;
wire     [47:0] calc_pout_fp_0_sum;
wire     [47:0] calc_pout_fp_0_sum_ext;
wire     [47:0] calc_pout_fp_10_sum;
wire     [47:0] calc_pout_fp_10_sum_ext;
wire     [47:0] calc_pout_fp_11_sum;
wire     [47:0] calc_pout_fp_11_sum_ext;
wire     [47:0] calc_pout_fp_12_sum;
wire     [47:0] calc_pout_fp_12_sum_ext;
wire     [47:0] calc_pout_fp_13_sum;
wire     [47:0] calc_pout_fp_13_sum_ext;
wire     [47:0] calc_pout_fp_14_sum;
wire     [47:0] calc_pout_fp_14_sum_ext;
wire     [47:0] calc_pout_fp_15_sum;
wire     [47:0] calc_pout_fp_15_sum_ext;
wire     [47:0] calc_pout_fp_16_sum;
wire     [47:0] calc_pout_fp_16_sum_ext;
wire     [47:0] calc_pout_fp_17_sum;
wire     [47:0] calc_pout_fp_17_sum_ext;
wire     [47:0] calc_pout_fp_18_sum;
wire     [47:0] calc_pout_fp_18_sum_ext;
wire     [47:0] calc_pout_fp_19_sum;
wire     [47:0] calc_pout_fp_19_sum_ext;
wire     [47:0] calc_pout_fp_1_sum;
wire     [47:0] calc_pout_fp_1_sum_ext;
wire     [47:0] calc_pout_fp_20_sum;
wire     [47:0] calc_pout_fp_20_sum_ext;
wire     [47:0] calc_pout_fp_21_sum;
wire     [47:0] calc_pout_fp_21_sum_ext;
wire     [47:0] calc_pout_fp_22_sum;
wire     [47:0] calc_pout_fp_22_sum_ext;
wire     [47:0] calc_pout_fp_23_sum;
wire     [47:0] calc_pout_fp_23_sum_ext;
wire     [47:0] calc_pout_fp_24_sum;
wire     [47:0] calc_pout_fp_24_sum_ext;
wire     [47:0] calc_pout_fp_25_sum;
wire     [47:0] calc_pout_fp_25_sum_ext;
wire     [47:0] calc_pout_fp_26_sum;
wire     [47:0] calc_pout_fp_26_sum_ext;
wire     [47:0] calc_pout_fp_27_sum;
wire     [47:0] calc_pout_fp_27_sum_ext;
wire     [47:0] calc_pout_fp_28_sum;
wire     [47:0] calc_pout_fp_28_sum_ext;
wire     [47:0] calc_pout_fp_29_sum;
wire     [47:0] calc_pout_fp_29_sum_ext;
wire     [47:0] calc_pout_fp_2_sum;
wire     [47:0] calc_pout_fp_2_sum_ext;
wire     [47:0] calc_pout_fp_30_sum;
wire     [47:0] calc_pout_fp_30_sum_ext;
wire     [47:0] calc_pout_fp_31_sum;
wire     [47:0] calc_pout_fp_31_sum_ext;
wire     [47:0] calc_pout_fp_32_sum;
wire     [47:0] calc_pout_fp_32_sum_ext;
wire     [47:0] calc_pout_fp_33_sum;
wire     [47:0] calc_pout_fp_33_sum_ext;
wire     [47:0] calc_pout_fp_34_sum;
wire     [47:0] calc_pout_fp_34_sum_ext;
wire     [47:0] calc_pout_fp_35_sum;
wire     [47:0] calc_pout_fp_35_sum_ext;
wire     [47:0] calc_pout_fp_36_sum;
wire     [47:0] calc_pout_fp_36_sum_ext;
wire     [47:0] calc_pout_fp_37_sum;
wire     [47:0] calc_pout_fp_37_sum_ext;
wire     [47:0] calc_pout_fp_38_sum;
wire     [47:0] calc_pout_fp_38_sum_ext;
wire     [47:0] calc_pout_fp_39_sum;
wire     [47:0] calc_pout_fp_39_sum_ext;
wire     [47:0] calc_pout_fp_3_sum;
wire     [47:0] calc_pout_fp_3_sum_ext;
wire     [47:0] calc_pout_fp_40_sum;
wire     [47:0] calc_pout_fp_40_sum_ext;
wire     [47:0] calc_pout_fp_41_sum;
wire     [47:0] calc_pout_fp_41_sum_ext;
wire     [47:0] calc_pout_fp_42_sum;
wire     [47:0] calc_pout_fp_42_sum_ext;
wire     [47:0] calc_pout_fp_43_sum;
wire     [47:0] calc_pout_fp_43_sum_ext;
wire     [47:0] calc_pout_fp_44_sum;
wire     [47:0] calc_pout_fp_44_sum_ext;
wire     [47:0] calc_pout_fp_45_sum;
wire     [47:0] calc_pout_fp_45_sum_ext;
wire     [47:0] calc_pout_fp_46_sum;
wire     [47:0] calc_pout_fp_46_sum_ext;
wire     [47:0] calc_pout_fp_47_sum;
wire     [47:0] calc_pout_fp_47_sum_ext;
wire     [47:0] calc_pout_fp_48_sum;
wire     [47:0] calc_pout_fp_48_sum_ext;
wire     [47:0] calc_pout_fp_49_sum;
wire     [47:0] calc_pout_fp_49_sum_ext;
wire     [47:0] calc_pout_fp_4_sum;
wire     [47:0] calc_pout_fp_4_sum_ext;
wire     [47:0] calc_pout_fp_50_sum;
wire     [47:0] calc_pout_fp_50_sum_ext;
wire     [47:0] calc_pout_fp_51_sum;
wire     [47:0] calc_pout_fp_51_sum_ext;
wire     [47:0] calc_pout_fp_52_sum;
wire     [47:0] calc_pout_fp_52_sum_ext;
wire     [47:0] calc_pout_fp_53_sum;
wire     [47:0] calc_pout_fp_53_sum_ext;
wire     [47:0] calc_pout_fp_54_sum;
wire     [47:0] calc_pout_fp_54_sum_ext;
wire     [47:0] calc_pout_fp_55_sum;
wire     [47:0] calc_pout_fp_55_sum_ext;
wire     [47:0] calc_pout_fp_56_sum;
wire     [47:0] calc_pout_fp_56_sum_ext;
wire     [47:0] calc_pout_fp_57_sum;
wire     [47:0] calc_pout_fp_57_sum_ext;
wire     [47:0] calc_pout_fp_58_sum;
wire     [47:0] calc_pout_fp_58_sum_ext;
wire     [47:0] calc_pout_fp_59_sum;
wire     [47:0] calc_pout_fp_59_sum_ext;
wire     [47:0] calc_pout_fp_5_sum;
wire     [47:0] calc_pout_fp_5_sum_ext;
wire     [47:0] calc_pout_fp_60_sum;
wire     [47:0] calc_pout_fp_60_sum_ext;
wire     [47:0] calc_pout_fp_61_sum;
wire     [47:0] calc_pout_fp_61_sum_ext;
wire     [47:0] calc_pout_fp_62_sum;
wire     [47:0] calc_pout_fp_62_sum_ext;
wire     [47:0] calc_pout_fp_63_sum;
wire     [47:0] calc_pout_fp_63_sum_ext;
wire     [47:0] calc_pout_fp_6_sum;
wire     [47:0] calc_pout_fp_6_sum_ext;
wire     [47:0] calc_pout_fp_7_sum;
wire     [47:0] calc_pout_fp_7_sum_ext;
wire     [47:0] calc_pout_fp_8_sum;
wire     [47:0] calc_pout_fp_8_sum_ext;
wire     [47:0] calc_pout_fp_9_sum;
wire     [47:0] calc_pout_fp_9_sum_ext;
wire     [63:0] calc_pout_fp_vld;
wire     [47:0] calc_pout_int_0_sum;
wire     [33:0] calc_pout_int_100_sum;
wire     [33:0] calc_pout_int_101_sum;
wire     [33:0] calc_pout_int_102_sum;
wire     [33:0] calc_pout_int_103_sum;
wire     [33:0] calc_pout_int_104_sum;
wire     [33:0] calc_pout_int_105_sum;
wire     [33:0] calc_pout_int_106_sum;
wire     [33:0] calc_pout_int_107_sum;
wire     [33:0] calc_pout_int_108_sum;
wire     [33:0] calc_pout_int_109_sum;
wire     [47:0] calc_pout_int_10_sum;
wire     [33:0] calc_pout_int_110_sum;
wire     [33:0] calc_pout_int_111_sum;
wire     [33:0] calc_pout_int_112_sum;
wire     [33:0] calc_pout_int_113_sum;
wire     [33:0] calc_pout_int_114_sum;
wire     [33:0] calc_pout_int_115_sum;
wire     [33:0] calc_pout_int_116_sum;
wire     [33:0] calc_pout_int_117_sum;
wire     [33:0] calc_pout_int_118_sum;
wire     [33:0] calc_pout_int_119_sum;
wire     [47:0] calc_pout_int_11_sum;
wire     [33:0] calc_pout_int_120_sum;
wire     [33:0] calc_pout_int_121_sum;
wire     [33:0] calc_pout_int_122_sum;
wire     [33:0] calc_pout_int_123_sum;
wire     [33:0] calc_pout_int_124_sum;
wire     [33:0] calc_pout_int_125_sum;
wire     [33:0] calc_pout_int_126_sum;
wire     [33:0] calc_pout_int_127_sum;
wire     [47:0] calc_pout_int_12_sum;
wire     [47:0] calc_pout_int_13_sum;
wire     [47:0] calc_pout_int_14_sum;
wire     [47:0] calc_pout_int_15_sum;
wire     [47:0] calc_pout_int_16_sum;
wire     [47:0] calc_pout_int_17_sum;
wire     [47:0] calc_pout_int_18_sum;
wire     [47:0] calc_pout_int_19_sum;
wire     [47:0] calc_pout_int_1_sum;
wire     [47:0] calc_pout_int_20_sum;
wire     [47:0] calc_pout_int_21_sum;
wire     [47:0] calc_pout_int_22_sum;
wire     [47:0] calc_pout_int_23_sum;
wire     [47:0] calc_pout_int_24_sum;
wire     [47:0] calc_pout_int_25_sum;
wire     [47:0] calc_pout_int_26_sum;
wire     [47:0] calc_pout_int_27_sum;
wire     [47:0] calc_pout_int_28_sum;
wire     [47:0] calc_pout_int_29_sum;
wire     [47:0] calc_pout_int_2_sum;
wire     [47:0] calc_pout_int_30_sum;
wire     [47:0] calc_pout_int_31_sum;
wire     [47:0] calc_pout_int_32_sum;
wire     [47:0] calc_pout_int_33_sum;
wire     [47:0] calc_pout_int_34_sum;
wire     [47:0] calc_pout_int_35_sum;
wire     [47:0] calc_pout_int_36_sum;
wire     [47:0] calc_pout_int_37_sum;
wire     [47:0] calc_pout_int_38_sum;
wire     [47:0] calc_pout_int_39_sum;
wire     [47:0] calc_pout_int_3_sum;
wire     [47:0] calc_pout_int_40_sum;
wire     [47:0] calc_pout_int_41_sum;
wire     [47:0] calc_pout_int_42_sum;
wire     [47:0] calc_pout_int_43_sum;
wire     [47:0] calc_pout_int_44_sum;
wire     [47:0] calc_pout_int_45_sum;
wire     [47:0] calc_pout_int_46_sum;
wire     [47:0] calc_pout_int_47_sum;
wire     [47:0] calc_pout_int_48_sum;
wire     [47:0] calc_pout_int_49_sum;
wire     [47:0] calc_pout_int_4_sum;
wire     [47:0] calc_pout_int_50_sum;
wire     [47:0] calc_pout_int_51_sum;
wire     [47:0] calc_pout_int_52_sum;
wire     [47:0] calc_pout_int_53_sum;
wire     [47:0] calc_pout_int_54_sum;
wire     [47:0] calc_pout_int_55_sum;
wire     [47:0] calc_pout_int_56_sum;
wire     [47:0] calc_pout_int_57_sum;
wire     [47:0] calc_pout_int_58_sum;
wire     [47:0] calc_pout_int_59_sum;
wire     [47:0] calc_pout_int_5_sum;
wire     [47:0] calc_pout_int_60_sum;
wire     [47:0] calc_pout_int_61_sum;
wire     [47:0] calc_pout_int_62_sum;
wire     [47:0] calc_pout_int_63_sum;
wire     [33:0] calc_pout_int_64_sum;
wire     [33:0] calc_pout_int_65_sum;
wire     [33:0] calc_pout_int_66_sum;
wire     [33:0] calc_pout_int_67_sum;
wire     [33:0] calc_pout_int_68_sum;
wire     [33:0] calc_pout_int_69_sum;
wire     [47:0] calc_pout_int_6_sum;
wire     [33:0] calc_pout_int_70_sum;
wire     [33:0] calc_pout_int_71_sum;
wire     [33:0] calc_pout_int_72_sum;
wire     [33:0] calc_pout_int_73_sum;
wire     [33:0] calc_pout_int_74_sum;
wire     [33:0] calc_pout_int_75_sum;
wire     [33:0] calc_pout_int_76_sum;
wire     [33:0] calc_pout_int_77_sum;
wire     [33:0] calc_pout_int_78_sum;
wire     [33:0] calc_pout_int_79_sum;
wire     [47:0] calc_pout_int_7_sum;
wire     [33:0] calc_pout_int_80_sum;
wire     [33:0] calc_pout_int_81_sum;
wire     [33:0] calc_pout_int_82_sum;
wire     [33:0] calc_pout_int_83_sum;
wire     [33:0] calc_pout_int_84_sum;
wire     [33:0] calc_pout_int_85_sum;
wire     [33:0] calc_pout_int_86_sum;
wire     [33:0] calc_pout_int_87_sum;
wire     [33:0] calc_pout_int_88_sum;
wire     [33:0] calc_pout_int_89_sum;
wire     [47:0] calc_pout_int_8_sum;
wire     [33:0] calc_pout_int_90_sum;
wire     [33:0] calc_pout_int_91_sum;
wire     [33:0] calc_pout_int_92_sum;
wire     [33:0] calc_pout_int_93_sum;
wire     [33:0] calc_pout_int_94_sum;
wire     [33:0] calc_pout_int_95_sum;
wire     [33:0] calc_pout_int_96_sum;
wire     [33:0] calc_pout_int_97_sum;
wire     [33:0] calc_pout_int_98_sum;
wire     [33:0] calc_pout_int_99_sum;
wire     [47:0] calc_pout_int_9_sum;
wire    [127:0] calc_pout_int_vld;
wire     [15:0] calc_ram_sel_0;
wire    [767:0] calc_ram_sel_0_ext;
wire     [15:0] calc_ram_sel_1;
wire    [767:0] calc_ram_sel_1_ext;
wire     [15:0] calc_ram_sel_2;
wire    [767:0] calc_ram_sel_2_ext;
wire     [15:0] calc_ram_sel_3;
wire    [767:0] calc_ram_sel_3_ext;
wire     [15:0] calc_ram_sel_4;
wire    [543:0] calc_ram_sel_4_ext;
wire     [15:0] calc_ram_sel_5;
wire    [543:0] calc_ram_sel_5_ext;
wire     [15:0] calc_ram_sel_6;
wire    [543:0] calc_ram_sel_6_ext;
wire     [15:0] calc_ram_sel_7;
wire    [543:0] calc_ram_sel_7_ext;
wire      [7:0] calc_rd_mask;
wire            calc_stripe_end;
wire            calc_stripe_end_out;
wire            calc_valid_d0;
wire            calc_valid_fw_0;
wire            calc_valid_out;
wire            calc_valid_w;
wire      [7:0] calc_wr_en_out;
wire      [4:0] cfg_truncate_0;
wire      [4:0] cfg_truncate_1;
wire      [4:0] cfg_truncate_10;
wire      [4:0] cfg_truncate_100;
wire      [4:0] cfg_truncate_101;
wire      [4:0] cfg_truncate_102;
wire      [4:0] cfg_truncate_103;
wire      [4:0] cfg_truncate_104;
wire      [4:0] cfg_truncate_105;
wire      [4:0] cfg_truncate_106;
wire      [4:0] cfg_truncate_107;
wire      [4:0] cfg_truncate_108;
wire      [4:0] cfg_truncate_109;
wire      [4:0] cfg_truncate_11;
wire      [4:0] cfg_truncate_110;
wire      [4:0] cfg_truncate_111;
wire      [4:0] cfg_truncate_112;
wire      [4:0] cfg_truncate_113;
wire      [4:0] cfg_truncate_114;
wire      [4:0] cfg_truncate_115;
wire      [4:0] cfg_truncate_116;
wire      [4:0] cfg_truncate_117;
wire      [4:0] cfg_truncate_118;
wire      [4:0] cfg_truncate_119;
wire      [4:0] cfg_truncate_12;
wire      [4:0] cfg_truncate_120;
wire      [4:0] cfg_truncate_121;
wire      [4:0] cfg_truncate_122;
wire      [4:0] cfg_truncate_123;
wire      [4:0] cfg_truncate_124;
wire      [4:0] cfg_truncate_125;
wire      [4:0] cfg_truncate_126;
wire      [4:0] cfg_truncate_127;
wire      [4:0] cfg_truncate_13;
wire      [4:0] cfg_truncate_14;
wire      [4:0] cfg_truncate_15;
wire      [4:0] cfg_truncate_16;
wire      [4:0] cfg_truncate_17;
wire      [4:0] cfg_truncate_18;
wire      [4:0] cfg_truncate_19;
wire      [4:0] cfg_truncate_2;
wire      [4:0] cfg_truncate_20;
wire      [4:0] cfg_truncate_21;
wire      [4:0] cfg_truncate_22;
wire      [4:0] cfg_truncate_23;
wire      [4:0] cfg_truncate_24;
wire      [4:0] cfg_truncate_25;
wire      [4:0] cfg_truncate_26;
wire      [4:0] cfg_truncate_27;
wire      [4:0] cfg_truncate_28;
wire      [4:0] cfg_truncate_29;
wire      [4:0] cfg_truncate_3;
wire      [4:0] cfg_truncate_30;
wire      [4:0] cfg_truncate_31;
wire      [4:0] cfg_truncate_32;
wire      [4:0] cfg_truncate_33;
wire      [4:0] cfg_truncate_34;
wire      [4:0] cfg_truncate_35;
wire      [4:0] cfg_truncate_36;
wire      [4:0] cfg_truncate_37;
wire      [4:0] cfg_truncate_38;
wire      [4:0] cfg_truncate_39;
wire      [4:0] cfg_truncate_4;
wire      [4:0] cfg_truncate_40;
wire      [4:0] cfg_truncate_41;
wire      [4:0] cfg_truncate_42;
wire      [4:0] cfg_truncate_43;
wire      [4:0] cfg_truncate_44;
wire      [4:0] cfg_truncate_45;
wire      [4:0] cfg_truncate_46;
wire      [4:0] cfg_truncate_47;
wire      [4:0] cfg_truncate_48;
wire      [4:0] cfg_truncate_49;
wire      [4:0] cfg_truncate_5;
wire      [4:0] cfg_truncate_50;
wire      [4:0] cfg_truncate_51;
wire      [4:0] cfg_truncate_52;
wire      [4:0] cfg_truncate_53;
wire      [4:0] cfg_truncate_54;
wire      [4:0] cfg_truncate_55;
wire      [4:0] cfg_truncate_56;
wire      [4:0] cfg_truncate_57;
wire      [4:0] cfg_truncate_58;
wire      [4:0] cfg_truncate_59;
wire      [4:0] cfg_truncate_6;
wire      [4:0] cfg_truncate_60;
wire      [4:0] cfg_truncate_61;
wire      [4:0] cfg_truncate_62;
wire      [4:0] cfg_truncate_63;
wire      [4:0] cfg_truncate_64;
wire      [4:0] cfg_truncate_65;
wire      [4:0] cfg_truncate_66;
wire      [4:0] cfg_truncate_67;
wire      [4:0] cfg_truncate_68;
wire      [4:0] cfg_truncate_69;
wire      [4:0] cfg_truncate_7;
wire      [4:0] cfg_truncate_70;
wire      [4:0] cfg_truncate_71;
wire      [4:0] cfg_truncate_72;
wire      [4:0] cfg_truncate_73;
wire      [4:0] cfg_truncate_74;
wire      [4:0] cfg_truncate_75;
wire      [4:0] cfg_truncate_76;
wire      [4:0] cfg_truncate_77;
wire      [4:0] cfg_truncate_78;
wire      [4:0] cfg_truncate_79;
wire      [4:0] cfg_truncate_8;
wire      [4:0] cfg_truncate_80;
wire      [4:0] cfg_truncate_81;
wire      [4:0] cfg_truncate_82;
wire      [4:0] cfg_truncate_83;
wire      [4:0] cfg_truncate_84;
wire      [4:0] cfg_truncate_85;
wire      [4:0] cfg_truncate_86;
wire      [4:0] cfg_truncate_87;
wire      [4:0] cfg_truncate_88;
wire      [4:0] cfg_truncate_89;
wire      [4:0] cfg_truncate_9;
wire      [4:0] cfg_truncate_90;
wire      [4:0] cfg_truncate_91;
wire      [4:0] cfg_truncate_92;
wire      [4:0] cfg_truncate_93;
wire      [4:0] cfg_truncate_94;
wire      [4:0] cfg_truncate_95;
wire      [4:0] cfg_truncate_96;
wire      [4:0] cfg_truncate_97;
wire      [4:0] cfg_truncate_98;
wire      [4:0] cfg_truncate_99;
wire    [127:0] dlv_sat_bit;
wire            dlv_sat_clr;
wire            dlv_sat_end;
wire     [31:0] sat_count_w;
wire            sat_reg_en;
reg      [47:0] abuf_in_data_0;
reg      [47:0] abuf_in_data_1;
reg      [47:0] abuf_in_data_10;
reg      [33:0] abuf_in_data_100;
reg      [33:0] abuf_in_data_101;
reg      [33:0] abuf_in_data_102;
reg      [33:0] abuf_in_data_103;
reg      [33:0] abuf_in_data_104;
reg      [33:0] abuf_in_data_105;
reg      [33:0] abuf_in_data_106;
reg      [33:0] abuf_in_data_107;
reg      [33:0] abuf_in_data_108;
reg      [33:0] abuf_in_data_109;
reg      [47:0] abuf_in_data_11;
reg      [33:0] abuf_in_data_110;
reg      [33:0] abuf_in_data_111;
reg      [33:0] abuf_in_data_112;
reg      [33:0] abuf_in_data_113;
reg      [33:0] abuf_in_data_114;
reg      [33:0] abuf_in_data_115;
reg      [33:0] abuf_in_data_116;
reg      [33:0] abuf_in_data_117;
reg      [33:0] abuf_in_data_118;
reg      [33:0] abuf_in_data_119;
reg      [47:0] abuf_in_data_12;
reg      [33:0] abuf_in_data_120;
reg      [33:0] abuf_in_data_121;
reg      [33:0] abuf_in_data_122;
reg      [33:0] abuf_in_data_123;
reg      [33:0] abuf_in_data_124;
reg      [33:0] abuf_in_data_125;
reg      [33:0] abuf_in_data_126;
reg      [33:0] abuf_in_data_127;
reg      [47:0] abuf_in_data_13;
reg      [47:0] abuf_in_data_14;
reg      [47:0] abuf_in_data_15;
reg      [47:0] abuf_in_data_16;
reg      [47:0] abuf_in_data_17;
reg      [47:0] abuf_in_data_18;
reg      [47:0] abuf_in_data_19;
reg      [47:0] abuf_in_data_2;
reg      [47:0] abuf_in_data_20;
reg      [47:0] abuf_in_data_21;
reg      [47:0] abuf_in_data_22;
reg      [47:0] abuf_in_data_23;
reg      [47:0] abuf_in_data_24;
reg      [47:0] abuf_in_data_25;
reg      [47:0] abuf_in_data_26;
reg      [47:0] abuf_in_data_27;
reg      [47:0] abuf_in_data_28;
reg      [47:0] abuf_in_data_29;
reg      [47:0] abuf_in_data_3;
reg      [47:0] abuf_in_data_30;
reg      [47:0] abuf_in_data_31;
reg      [47:0] abuf_in_data_32;
reg      [47:0] abuf_in_data_33;
reg      [47:0] abuf_in_data_34;
reg      [47:0] abuf_in_data_35;
reg      [47:0] abuf_in_data_36;
reg      [47:0] abuf_in_data_37;
reg      [47:0] abuf_in_data_38;
reg      [47:0] abuf_in_data_39;
reg      [47:0] abuf_in_data_4;
reg      [47:0] abuf_in_data_40;
reg      [47:0] abuf_in_data_41;
reg      [47:0] abuf_in_data_42;
reg      [47:0] abuf_in_data_43;
reg      [47:0] abuf_in_data_44;
reg      [47:0] abuf_in_data_45;
reg      [47:0] abuf_in_data_46;
reg      [47:0] abuf_in_data_47;
reg      [47:0] abuf_in_data_48;
reg      [47:0] abuf_in_data_49;
reg      [47:0] abuf_in_data_5;
reg      [47:0] abuf_in_data_50;
reg      [47:0] abuf_in_data_51;
reg      [47:0] abuf_in_data_52;
reg      [47:0] abuf_in_data_53;
reg      [47:0] abuf_in_data_54;
reg      [47:0] abuf_in_data_55;
reg      [47:0] abuf_in_data_56;
reg      [47:0] abuf_in_data_57;
reg      [47:0] abuf_in_data_58;
reg      [47:0] abuf_in_data_59;
reg      [47:0] abuf_in_data_6;
reg      [47:0] abuf_in_data_60;
reg      [47:0] abuf_in_data_61;
reg      [47:0] abuf_in_data_62;
reg      [47:0] abuf_in_data_63;
reg      [33:0] abuf_in_data_64;
reg      [33:0] abuf_in_data_65;
reg      [33:0] abuf_in_data_66;
reg      [33:0] abuf_in_data_67;
reg      [33:0] abuf_in_data_68;
reg      [33:0] abuf_in_data_69;
reg      [47:0] abuf_in_data_7;
reg      [33:0] abuf_in_data_70;
reg      [33:0] abuf_in_data_71;
reg      [33:0] abuf_in_data_72;
reg      [33:0] abuf_in_data_73;
reg      [33:0] abuf_in_data_74;
reg      [33:0] abuf_in_data_75;
reg      [33:0] abuf_in_data_76;
reg      [33:0] abuf_in_data_77;
reg      [33:0] abuf_in_data_78;
reg      [33:0] abuf_in_data_79;
reg      [47:0] abuf_in_data_8;
reg      [33:0] abuf_in_data_80;
reg      [33:0] abuf_in_data_81;
reg      [33:0] abuf_in_data_82;
reg      [33:0] abuf_in_data_83;
reg      [33:0] abuf_in_data_84;
reg      [33:0] abuf_in_data_85;
reg      [33:0] abuf_in_data_86;
reg      [33:0] abuf_in_data_87;
reg      [33:0] abuf_in_data_88;
reg      [33:0] abuf_in_data_89;
reg      [47:0] abuf_in_data_9;
reg      [33:0] abuf_in_data_90;
reg      [33:0] abuf_in_data_91;
reg      [33:0] abuf_in_data_92;
reg      [33:0] abuf_in_data_93;
reg      [33:0] abuf_in_data_94;
reg      [33:0] abuf_in_data_95;
reg      [33:0] abuf_in_data_96;
reg      [33:0] abuf_in_data_97;
reg      [33:0] abuf_in_data_98;
reg      [33:0] abuf_in_data_99;
reg     [767:0] abuf_rd_data_0_sft;
reg     [767:0] abuf_rd_data_1_sft;
reg     [767:0] abuf_rd_data_2_sft;
reg     [767:0] abuf_rd_data_3_sft;
reg     [543:0] abuf_rd_data_4_sft;
reg     [543:0] abuf_rd_data_5_sft;
reg     [543:0] abuf_rd_data_6_sft;
reg     [543:0] abuf_rd_data_7_sft;
reg       [4:0] abuf_wr_addr;
reg     [767:0] abuf_wr_data_0;
reg     [767:0] abuf_wr_data_0_w;
reg     [767:0] abuf_wr_data_1;
reg     [767:0] abuf_wr_data_1_w;
reg     [767:0] abuf_wr_data_2;
reg     [767:0] abuf_wr_data_2_w;
reg     [767:0] abuf_wr_data_3;
reg     [767:0] abuf_wr_data_3_w;
reg     [543:0] abuf_wr_data_4;
reg     [543:0] abuf_wr_data_4_w;
reg     [543:0] abuf_wr_data_5;
reg     [543:0] abuf_wr_data_5_w;
reg     [543:0] abuf_wr_data_6;
reg     [543:0] abuf_wr_data_6_w;
reg     [543:0] abuf_wr_data_7;
reg     [543:0] abuf_wr_data_7_w;
reg       [7:0] abuf_wr_en;
reg       [4:0] calc_addr_d1;
reg       [4:0] calc_addr_d2;
reg       [4:0] calc_addr_d3;
reg       [4:0] calc_addr_d4;
reg     [175:0] calc_data_0;
reg     [175:0] calc_data_1;
reg     [175:0] calc_data_10;
reg     [175:0] calc_data_11;
reg     [175:0] calc_data_12;
reg     [175:0] calc_data_13;
reg     [175:0] calc_data_14;
reg     [175:0] calc_data_15;
reg     [175:0] calc_data_2;
reg     [175:0] calc_data_3;
reg     [175:0] calc_data_4;
reg     [175:0] calc_data_5;
reg     [175:0] calc_data_6;
reg     [175:0] calc_data_7;
reg     [175:0] calc_data_8;
reg     [175:0] calc_data_9;
reg       [7:0] calc_dlv_en;
reg       [7:0] calc_dlv_en_d1;
reg       [7:0] calc_dlv_en_d2;
reg       [7:0] calc_dlv_en_d3;
reg       [7:0] calc_dlv_en_d4;
reg       [7:0] calc_dlv_en_d5;
reg      [63:0] calc_dlv_en_fp_d1;
reg     [127:0] calc_dlv_en_int_d1;
reg             calc_dlv_valid;
reg             calc_dlv_valid_d1;
reg             calc_dlv_valid_d2;
reg             calc_dlv_valid_d3;
reg             calc_dlv_valid_d4;
reg             calc_dlv_valid_d5;
reg     [191:0] calc_in_mask;
reg             calc_layer_end_d1;
reg             calc_layer_end_d2;
reg             calc_layer_end_d3;
reg             calc_layer_end_d4;
reg             calc_layer_end_d5;
reg      [43:0] calc_op0_fp_0_d1;
reg      [43:0] calc_op0_fp_10_d1;
reg      [43:0] calc_op0_fp_11_d1;
reg      [43:0] calc_op0_fp_12_d1;
reg      [43:0] calc_op0_fp_13_d1;
reg      [43:0] calc_op0_fp_14_d1;
reg      [43:0] calc_op0_fp_15_d1;
reg      [43:0] calc_op0_fp_16_d1;
reg      [43:0] calc_op0_fp_17_d1;
reg      [43:0] calc_op0_fp_18_d1;
reg      [43:0] calc_op0_fp_19_d1;
reg      [43:0] calc_op0_fp_1_d1;
reg      [43:0] calc_op0_fp_20_d1;
reg      [43:0] calc_op0_fp_21_d1;
reg      [43:0] calc_op0_fp_22_d1;
reg      [43:0] calc_op0_fp_23_d1;
reg      [43:0] calc_op0_fp_24_d1;
reg      [43:0] calc_op0_fp_25_d1;
reg      [43:0] calc_op0_fp_26_d1;
reg      [43:0] calc_op0_fp_27_d1;
reg      [43:0] calc_op0_fp_28_d1;
reg      [43:0] calc_op0_fp_29_d1;
reg      [43:0] calc_op0_fp_2_d1;
reg      [43:0] calc_op0_fp_30_d1;
reg      [43:0] calc_op0_fp_31_d1;
reg      [43:0] calc_op0_fp_32_d1;
reg      [43:0] calc_op0_fp_33_d1;
reg      [43:0] calc_op0_fp_34_d1;
reg      [43:0] calc_op0_fp_35_d1;
reg      [43:0] calc_op0_fp_36_d1;
reg      [43:0] calc_op0_fp_37_d1;
reg      [43:0] calc_op0_fp_38_d1;
reg      [43:0] calc_op0_fp_39_d1;
reg      [43:0] calc_op0_fp_3_d1;
reg      [43:0] calc_op0_fp_40_d1;
reg      [43:0] calc_op0_fp_41_d1;
reg      [43:0] calc_op0_fp_42_d1;
reg      [43:0] calc_op0_fp_43_d1;
reg      [43:0] calc_op0_fp_44_d1;
reg      [43:0] calc_op0_fp_45_d1;
reg      [43:0] calc_op0_fp_46_d1;
reg      [43:0] calc_op0_fp_47_d1;
reg      [43:0] calc_op0_fp_48_d1;
reg      [43:0] calc_op0_fp_49_d1;
reg      [43:0] calc_op0_fp_4_d1;
reg      [43:0] calc_op0_fp_50_d1;
reg      [43:0] calc_op0_fp_51_d1;
reg      [43:0] calc_op0_fp_52_d1;
reg      [43:0] calc_op0_fp_53_d1;
reg      [43:0] calc_op0_fp_54_d1;
reg      [43:0] calc_op0_fp_55_d1;
reg      [43:0] calc_op0_fp_56_d1;
reg      [43:0] calc_op0_fp_57_d1;
reg      [43:0] calc_op0_fp_58_d1;
reg      [43:0] calc_op0_fp_59_d1;
reg      [43:0] calc_op0_fp_5_d1;
reg      [43:0] calc_op0_fp_60_d1;
reg      [43:0] calc_op0_fp_61_d1;
reg      [43:0] calc_op0_fp_62_d1;
reg      [43:0] calc_op0_fp_63_d1;
reg      [43:0] calc_op0_fp_6_d1;
reg      [43:0] calc_op0_fp_7_d1;
reg      [43:0] calc_op0_fp_8_d1;
reg      [43:0] calc_op0_fp_9_d1;
reg      [37:0] calc_op0_int_0_d1;
reg      [21:0] calc_op0_int_100_d1;
reg      [21:0] calc_op0_int_101_d1;
reg      [21:0] calc_op0_int_102_d1;
reg      [21:0] calc_op0_int_103_d1;
reg      [21:0] calc_op0_int_104_d1;
reg      [21:0] calc_op0_int_105_d1;
reg      [21:0] calc_op0_int_106_d1;
reg      [21:0] calc_op0_int_107_d1;
reg      [21:0] calc_op0_int_108_d1;
reg      [21:0] calc_op0_int_109_d1;
reg      [37:0] calc_op0_int_10_d1;
reg      [21:0] calc_op0_int_110_d1;
reg      [21:0] calc_op0_int_111_d1;
reg      [21:0] calc_op0_int_112_d1;
reg      [21:0] calc_op0_int_113_d1;
reg      [21:0] calc_op0_int_114_d1;
reg      [21:0] calc_op0_int_115_d1;
reg      [21:0] calc_op0_int_116_d1;
reg      [21:0] calc_op0_int_117_d1;
reg      [21:0] calc_op0_int_118_d1;
reg      [21:0] calc_op0_int_119_d1;
reg      [37:0] calc_op0_int_11_d1;
reg      [21:0] calc_op0_int_120_d1;
reg      [21:0] calc_op0_int_121_d1;
reg      [21:0] calc_op0_int_122_d1;
reg      [21:0] calc_op0_int_123_d1;
reg      [21:0] calc_op0_int_124_d1;
reg      [21:0] calc_op0_int_125_d1;
reg      [21:0] calc_op0_int_126_d1;
reg      [21:0] calc_op0_int_127_d1;
reg      [37:0] calc_op0_int_12_d1;
reg      [37:0] calc_op0_int_13_d1;
reg      [37:0] calc_op0_int_14_d1;
reg      [37:0] calc_op0_int_15_d1;
reg      [37:0] calc_op0_int_16_d1;
reg      [37:0] calc_op0_int_17_d1;
reg      [37:0] calc_op0_int_18_d1;
reg      [37:0] calc_op0_int_19_d1;
reg      [37:0] calc_op0_int_1_d1;
reg      [37:0] calc_op0_int_20_d1;
reg      [37:0] calc_op0_int_21_d1;
reg      [37:0] calc_op0_int_22_d1;
reg      [37:0] calc_op0_int_23_d1;
reg      [37:0] calc_op0_int_24_d1;
reg      [37:0] calc_op0_int_25_d1;
reg      [37:0] calc_op0_int_26_d1;
reg      [37:0] calc_op0_int_27_d1;
reg      [37:0] calc_op0_int_28_d1;
reg      [37:0] calc_op0_int_29_d1;
reg      [37:0] calc_op0_int_2_d1;
reg      [37:0] calc_op0_int_30_d1;
reg      [37:0] calc_op0_int_31_d1;
reg      [37:0] calc_op0_int_32_d1;
reg      [37:0] calc_op0_int_33_d1;
reg      [37:0] calc_op0_int_34_d1;
reg      [37:0] calc_op0_int_35_d1;
reg      [37:0] calc_op0_int_36_d1;
reg      [37:0] calc_op0_int_37_d1;
reg      [37:0] calc_op0_int_38_d1;
reg      [37:0] calc_op0_int_39_d1;
reg      [37:0] calc_op0_int_3_d1;
reg      [37:0] calc_op0_int_40_d1;
reg      [37:0] calc_op0_int_41_d1;
reg      [37:0] calc_op0_int_42_d1;
reg      [37:0] calc_op0_int_43_d1;
reg      [37:0] calc_op0_int_44_d1;
reg      [37:0] calc_op0_int_45_d1;
reg      [37:0] calc_op0_int_46_d1;
reg      [37:0] calc_op0_int_47_d1;
reg      [37:0] calc_op0_int_48_d1;
reg      [37:0] calc_op0_int_49_d1;
reg      [37:0] calc_op0_int_4_d1;
reg      [37:0] calc_op0_int_50_d1;
reg      [37:0] calc_op0_int_51_d1;
reg      [37:0] calc_op0_int_52_d1;
reg      [37:0] calc_op0_int_53_d1;
reg      [37:0] calc_op0_int_54_d1;
reg      [37:0] calc_op0_int_55_d1;
reg      [37:0] calc_op0_int_56_d1;
reg      [37:0] calc_op0_int_57_d1;
reg      [37:0] calc_op0_int_58_d1;
reg      [37:0] calc_op0_int_59_d1;
reg      [37:0] calc_op0_int_5_d1;
reg      [37:0] calc_op0_int_60_d1;
reg      [37:0] calc_op0_int_61_d1;
reg      [37:0] calc_op0_int_62_d1;
reg      [37:0] calc_op0_int_63_d1;
reg      [21:0] calc_op0_int_64_d1;
reg      [21:0] calc_op0_int_65_d1;
reg      [21:0] calc_op0_int_66_d1;
reg      [21:0] calc_op0_int_67_d1;
reg      [21:0] calc_op0_int_68_d1;
reg      [21:0] calc_op0_int_69_d1;
reg      [37:0] calc_op0_int_6_d1;
reg      [21:0] calc_op0_int_70_d1;
reg      [21:0] calc_op0_int_71_d1;
reg      [21:0] calc_op0_int_72_d1;
reg      [21:0] calc_op0_int_73_d1;
reg      [21:0] calc_op0_int_74_d1;
reg      [21:0] calc_op0_int_75_d1;
reg      [21:0] calc_op0_int_76_d1;
reg      [21:0] calc_op0_int_77_d1;
reg      [21:0] calc_op0_int_78_d1;
reg      [21:0] calc_op0_int_79_d1;
reg      [37:0] calc_op0_int_7_d1;
reg      [21:0] calc_op0_int_80_d1;
reg      [21:0] calc_op0_int_81_d1;
reg      [21:0] calc_op0_int_82_d1;
reg      [21:0] calc_op0_int_83_d1;
reg      [21:0] calc_op0_int_84_d1;
reg      [21:0] calc_op0_int_85_d1;
reg      [21:0] calc_op0_int_86_d1;
reg      [21:0] calc_op0_int_87_d1;
reg      [21:0] calc_op0_int_88_d1;
reg      [21:0] calc_op0_int_89_d1;
reg      [37:0] calc_op0_int_8_d1;
reg      [21:0] calc_op0_int_90_d1;
reg      [21:0] calc_op0_int_91_d1;
reg      [21:0] calc_op0_int_92_d1;
reg      [21:0] calc_op0_int_93_d1;
reg      [21:0] calc_op0_int_94_d1;
reg      [21:0] calc_op0_int_95_d1;
reg      [21:0] calc_op0_int_96_d1;
reg      [21:0] calc_op0_int_97_d1;
reg      [21:0] calc_op0_int_98_d1;
reg      [21:0] calc_op0_int_99_d1;
reg      [37:0] calc_op0_int_9_d1;
reg      [47:0] calc_op1_fp_0_d1;
reg      [47:0] calc_op1_fp_10_d1;
reg      [47:0] calc_op1_fp_11_d1;
reg      [47:0] calc_op1_fp_12_d1;
reg      [47:0] calc_op1_fp_13_d1;
reg      [47:0] calc_op1_fp_14_d1;
reg      [47:0] calc_op1_fp_15_d1;
reg      [47:0] calc_op1_fp_16_d1;
reg      [47:0] calc_op1_fp_17_d1;
reg      [47:0] calc_op1_fp_18_d1;
reg      [47:0] calc_op1_fp_19_d1;
reg      [47:0] calc_op1_fp_1_d1;
reg      [47:0] calc_op1_fp_20_d1;
reg      [47:0] calc_op1_fp_21_d1;
reg      [47:0] calc_op1_fp_22_d1;
reg      [47:0] calc_op1_fp_23_d1;
reg      [47:0] calc_op1_fp_24_d1;
reg      [47:0] calc_op1_fp_25_d1;
reg      [47:0] calc_op1_fp_26_d1;
reg      [47:0] calc_op1_fp_27_d1;
reg      [47:0] calc_op1_fp_28_d1;
reg      [47:0] calc_op1_fp_29_d1;
reg      [47:0] calc_op1_fp_2_d1;
reg      [47:0] calc_op1_fp_30_d1;
reg      [47:0] calc_op1_fp_31_d1;
reg      [47:0] calc_op1_fp_32_d1;
reg      [47:0] calc_op1_fp_33_d1;
reg      [47:0] calc_op1_fp_34_d1;
reg      [47:0] calc_op1_fp_35_d1;
reg      [47:0] calc_op1_fp_36_d1;
reg      [47:0] calc_op1_fp_37_d1;
reg      [47:0] calc_op1_fp_38_d1;
reg      [47:0] calc_op1_fp_39_d1;
reg      [47:0] calc_op1_fp_3_d1;
reg      [47:0] calc_op1_fp_40_d1;
reg      [47:0] calc_op1_fp_41_d1;
reg      [47:0] calc_op1_fp_42_d1;
reg      [47:0] calc_op1_fp_43_d1;
reg      [47:0] calc_op1_fp_44_d1;
reg      [47:0] calc_op1_fp_45_d1;
reg      [47:0] calc_op1_fp_46_d1;
reg      [47:0] calc_op1_fp_47_d1;
reg      [47:0] calc_op1_fp_48_d1;
reg      [47:0] calc_op1_fp_49_d1;
reg      [47:0] calc_op1_fp_4_d1;
reg      [47:0] calc_op1_fp_50_d1;
reg      [47:0] calc_op1_fp_51_d1;
reg      [47:0] calc_op1_fp_52_d1;
reg      [47:0] calc_op1_fp_53_d1;
reg      [47:0] calc_op1_fp_54_d1;
reg      [47:0] calc_op1_fp_55_d1;
reg      [47:0] calc_op1_fp_56_d1;
reg      [47:0] calc_op1_fp_57_d1;
reg      [47:0] calc_op1_fp_58_d1;
reg      [47:0] calc_op1_fp_59_d1;
reg      [47:0] calc_op1_fp_5_d1;
reg      [47:0] calc_op1_fp_60_d1;
reg      [47:0] calc_op1_fp_61_d1;
reg      [47:0] calc_op1_fp_62_d1;
reg      [47:0] calc_op1_fp_63_d1;
reg      [47:0] calc_op1_fp_6_d1;
reg      [47:0] calc_op1_fp_7_d1;
reg      [47:0] calc_op1_fp_8_d1;
reg      [47:0] calc_op1_fp_9_d1;
reg      [47:0] calc_op1_int_0_d1;
reg      [33:0] calc_op1_int_100_d1;
reg      [33:0] calc_op1_int_101_d1;
reg      [33:0] calc_op1_int_102_d1;
reg      [33:0] calc_op1_int_103_d1;
reg      [33:0] calc_op1_int_104_d1;
reg      [33:0] calc_op1_int_105_d1;
reg      [33:0] calc_op1_int_106_d1;
reg      [33:0] calc_op1_int_107_d1;
reg      [33:0] calc_op1_int_108_d1;
reg      [33:0] calc_op1_int_109_d1;
reg      [47:0] calc_op1_int_10_d1;
reg      [33:0] calc_op1_int_110_d1;
reg      [33:0] calc_op1_int_111_d1;
reg      [33:0] calc_op1_int_112_d1;
reg      [33:0] calc_op1_int_113_d1;
reg      [33:0] calc_op1_int_114_d1;
reg      [33:0] calc_op1_int_115_d1;
reg      [33:0] calc_op1_int_116_d1;
reg      [33:0] calc_op1_int_117_d1;
reg      [33:0] calc_op1_int_118_d1;
reg      [33:0] calc_op1_int_119_d1;
reg      [47:0] calc_op1_int_11_d1;
reg      [33:0] calc_op1_int_120_d1;
reg      [33:0] calc_op1_int_121_d1;
reg      [33:0] calc_op1_int_122_d1;
reg      [33:0] calc_op1_int_123_d1;
reg      [33:0] calc_op1_int_124_d1;
reg      [33:0] calc_op1_int_125_d1;
reg      [33:0] calc_op1_int_126_d1;
reg      [33:0] calc_op1_int_127_d1;
reg      [47:0] calc_op1_int_12_d1;
reg      [47:0] calc_op1_int_13_d1;
reg      [47:0] calc_op1_int_14_d1;
reg      [47:0] calc_op1_int_15_d1;
reg      [47:0] calc_op1_int_16_d1;
reg      [47:0] calc_op1_int_17_d1;
reg      [47:0] calc_op1_int_18_d1;
reg      [47:0] calc_op1_int_19_d1;
reg      [47:0] calc_op1_int_1_d1;
reg      [47:0] calc_op1_int_20_d1;
reg      [47:0] calc_op1_int_21_d1;
reg      [47:0] calc_op1_int_22_d1;
reg      [47:0] calc_op1_int_23_d1;
reg      [47:0] calc_op1_int_24_d1;
reg      [47:0] calc_op1_int_25_d1;
reg      [47:0] calc_op1_int_26_d1;
reg      [47:0] calc_op1_int_27_d1;
reg      [47:0] calc_op1_int_28_d1;
reg      [47:0] calc_op1_int_29_d1;
reg      [47:0] calc_op1_int_2_d1;
reg      [47:0] calc_op1_int_30_d1;
reg      [47:0] calc_op1_int_31_d1;
reg      [47:0] calc_op1_int_32_d1;
reg      [47:0] calc_op1_int_33_d1;
reg      [47:0] calc_op1_int_34_d1;
reg      [47:0] calc_op1_int_35_d1;
reg      [47:0] calc_op1_int_36_d1;
reg      [47:0] calc_op1_int_37_d1;
reg      [47:0] calc_op1_int_38_d1;
reg      [47:0] calc_op1_int_39_d1;
reg      [47:0] calc_op1_int_3_d1;
reg      [47:0] calc_op1_int_40_d1;
reg      [47:0] calc_op1_int_41_d1;
reg      [47:0] calc_op1_int_42_d1;
reg      [47:0] calc_op1_int_43_d1;
reg      [47:0] calc_op1_int_44_d1;
reg      [47:0] calc_op1_int_45_d1;
reg      [47:0] calc_op1_int_46_d1;
reg      [47:0] calc_op1_int_47_d1;
reg      [47:0] calc_op1_int_48_d1;
reg      [47:0] calc_op1_int_49_d1;
reg      [47:0] calc_op1_int_4_d1;
reg      [47:0] calc_op1_int_50_d1;
reg      [47:0] calc_op1_int_51_d1;
reg      [47:0] calc_op1_int_52_d1;
reg      [47:0] calc_op1_int_53_d1;
reg      [47:0] calc_op1_int_54_d1;
reg      [47:0] calc_op1_int_55_d1;
reg      [47:0] calc_op1_int_56_d1;
reg      [47:0] calc_op1_int_57_d1;
reg      [47:0] calc_op1_int_58_d1;
reg      [47:0] calc_op1_int_59_d1;
reg      [47:0] calc_op1_int_5_d1;
reg      [47:0] calc_op1_int_60_d1;
reg      [47:0] calc_op1_int_61_d1;
reg      [47:0] calc_op1_int_62_d1;
reg      [47:0] calc_op1_int_63_d1;
reg      [33:0] calc_op1_int_64_d1;
reg      [33:0] calc_op1_int_65_d1;
reg      [33:0] calc_op1_int_66_d1;
reg      [33:0] calc_op1_int_67_d1;
reg      [33:0] calc_op1_int_68_d1;
reg      [33:0] calc_op1_int_69_d1;
reg      [47:0] calc_op1_int_6_d1;
reg      [33:0] calc_op1_int_70_d1;
reg      [33:0] calc_op1_int_71_d1;
reg      [33:0] calc_op1_int_72_d1;
reg      [33:0] calc_op1_int_73_d1;
reg      [33:0] calc_op1_int_74_d1;
reg      [33:0] calc_op1_int_75_d1;
reg      [33:0] calc_op1_int_76_d1;
reg      [33:0] calc_op1_int_77_d1;
reg      [33:0] calc_op1_int_78_d1;
reg      [33:0] calc_op1_int_79_d1;
reg      [47:0] calc_op1_int_7_d1;
reg      [33:0] calc_op1_int_80_d1;
reg      [33:0] calc_op1_int_81_d1;
reg      [33:0] calc_op1_int_82_d1;
reg      [33:0] calc_op1_int_83_d1;
reg      [33:0] calc_op1_int_84_d1;
reg      [33:0] calc_op1_int_85_d1;
reg      [33:0] calc_op1_int_86_d1;
reg      [33:0] calc_op1_int_87_d1;
reg      [33:0] calc_op1_int_88_d1;
reg      [33:0] calc_op1_int_89_d1;
reg      [47:0] calc_op1_int_8_d1;
reg      [33:0] calc_op1_int_90_d1;
reg      [33:0] calc_op1_int_91_d1;
reg      [33:0] calc_op1_int_92_d1;
reg      [33:0] calc_op1_int_93_d1;
reg      [33:0] calc_op1_int_94_d1;
reg      [33:0] calc_op1_int_95_d1;
reg      [33:0] calc_op1_int_96_d1;
reg      [33:0] calc_op1_int_97_d1;
reg      [33:0] calc_op1_int_98_d1;
reg      [33:0] calc_op1_int_99_d1;
reg      [47:0] calc_op1_int_9_d1;
reg      [63:0] calc_op1_vld_fp_d1;
reg     [127:0] calc_op1_vld_int_d1;
reg      [63:0] calc_op_en_fp_d1;
reg     [127:0] calc_op_en_int_d1;
reg             calc_stripe_end_d1;
reg             calc_stripe_end_d2;
reg             calc_stripe_end_d3;
reg             calc_stripe_end_d4;
reg             calc_stripe_end_d5;
reg             calc_valid;
reg             calc_valid_d1;
reg             calc_valid_d2;
reg             calc_valid_d3;
reg             calc_valid_d4;
reg             calc_valid_fw_1;
reg             calc_valid_fw_2;
reg             calc_valid_fw_3;
reg       [7:0] calc_wr_en;
reg       [7:0] calc_wr_en_d1;
reg       [7:0] calc_wr_en_d2;
reg       [7:0] calc_wr_en_d3;
reg       [7:0] calc_wr_en_d4;
reg     [511:0] dlv_data_0;
reg     [511:0] dlv_data_0_w;
reg     [511:0] dlv_data_1;
reg     [511:0] dlv_data_1_w;
reg     [511:0] dlv_data_2;
reg     [511:0] dlv_data_2_w;
reg     [511:0] dlv_data_3;
reg     [511:0] dlv_data_3_w;
reg     [511:0] dlv_data_4;
reg     [511:0] dlv_data_4_w;
reg     [511:0] dlv_data_5;
reg     [511:0] dlv_data_5_w;
reg     [511:0] dlv_data_6;
reg     [511:0] dlv_data_6_w;
reg     [511:0] dlv_data_7;
reg     [511:0] dlv_data_7_w;
reg             dlv_layer_end;
reg       [7:0] dlv_mask;
reg     [127:0] dlv_sat_bit_d1;
reg             dlv_sat_clr_d1;
reg             dlv_sat_end_d1;
reg             dlv_sat_vld_d1;
reg             dlv_stripe_end;
reg             dlv_valid;
reg             sat_carry;
reg      [31:0] sat_count;
reg      [31:0] sat_count_inc;
reg       [7:0] sat_sum;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
/////////////////////////////////////////////////////////////////////////////////////////////
// Pipeline of Weight loader, for both compressed weight and uncompressed weight
//
//                (from mac cell)
//                       |
//                input register --------> assmebly buffer rd request (3 cycles ahead to prefetch)
//                       |
//                  data shifter 1
//                       |
//                pipe register 1
//                       |
//                     adders <-------- assmebly buffer rd data
//                       |
//                 adder register -------> assmebly buffer wr req
//                       |
//                    converter
//                       |
//                   cvt register
//                       |
//                  pipe register 3
//                       |
//              register to delivery      
//
/////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////
///// register input data for power partition boundary   /////
//////////////////////////////////////////////////////////////



always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[0]) == 1'b1) begin
    calc_data_0[43:0] <= mac_a2accu_data0[43:0];
  // VCS coverage off
  end else if ((mac_a2accu_mask[0]) == 1'b0) begin
  end else begin
    calc_data_0[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[0] & mac_a2accu_mode[0]) == 1'b1) begin
    calc_data_0[175:44] <= mac_a2accu_data0[175:44];
  // VCS coverage off
  end else if ((mac_a2accu_mask[0] & mac_a2accu_mode[0]) == 1'b0) begin
  end else begin
    calc_data_0[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[1]) == 1'b1) begin
    calc_data_1[43:0] <= mac_a2accu_data1[43:0];
  // VCS coverage off
  end else if ((mac_a2accu_mask[1]) == 1'b0) begin
  end else begin
    calc_data_1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[1] & mac_a2accu_mode[1]) == 1'b1) begin
    calc_data_1[175:44] <= mac_a2accu_data1[175:44];
  // VCS coverage off
  end else if ((mac_a2accu_mask[1] & mac_a2accu_mode[1]) == 1'b0) begin
  end else begin
    calc_data_1[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[2]) == 1'b1) begin
    calc_data_2[43:0] <= mac_a2accu_data2[43:0];
  // VCS coverage off
  end else if ((mac_a2accu_mask[2]) == 1'b0) begin
  end else begin
    calc_data_2[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[2] & mac_a2accu_mode[2]) == 1'b1) begin
    calc_data_2[175:44] <= mac_a2accu_data2[175:44];
  // VCS coverage off
  end else if ((mac_a2accu_mask[2] & mac_a2accu_mode[2]) == 1'b0) begin
  end else begin
    calc_data_2[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[3]) == 1'b1) begin
    calc_data_3[43:0] <= mac_a2accu_data3[43:0];
  // VCS coverage off
  end else if ((mac_a2accu_mask[3]) == 1'b0) begin
  end else begin
    calc_data_3[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[3] & mac_a2accu_mode[3]) == 1'b1) begin
    calc_data_3[175:44] <= mac_a2accu_data3[175:44];
  // VCS coverage off
  end else if ((mac_a2accu_mask[3] & mac_a2accu_mode[3]) == 1'b0) begin
  end else begin
    calc_data_3[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[4]) == 1'b1) begin
    calc_data_4[43:0] <= mac_a2accu_data4[43:0];
  // VCS coverage off
  end else if ((mac_a2accu_mask[4]) == 1'b0) begin
  end else begin
    calc_data_4[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[4] & mac_a2accu_mode[4]) == 1'b1) begin
    calc_data_4[175:44] <= mac_a2accu_data4[175:44];
  // VCS coverage off
  end else if ((mac_a2accu_mask[4] & mac_a2accu_mode[4]) == 1'b0) begin
  end else begin
    calc_data_4[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[5]) == 1'b1) begin
    calc_data_5[43:0] <= mac_a2accu_data5[43:0];
  // VCS coverage off
  end else if ((mac_a2accu_mask[5]) == 1'b0) begin
  end else begin
    calc_data_5[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[5] & mac_a2accu_mode[5]) == 1'b1) begin
    calc_data_5[175:44] <= mac_a2accu_data5[175:44];
  // VCS coverage off
  end else if ((mac_a2accu_mask[5] & mac_a2accu_mode[5]) == 1'b0) begin
  end else begin
    calc_data_5[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[6]) == 1'b1) begin
    calc_data_6[43:0] <= mac_a2accu_data6[43:0];
  // VCS coverage off
  end else if ((mac_a2accu_mask[6]) == 1'b0) begin
  end else begin
    calc_data_6[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[6] & mac_a2accu_mode[6]) == 1'b1) begin
    calc_data_6[175:44] <= mac_a2accu_data6[175:44];
  // VCS coverage off
  end else if ((mac_a2accu_mask[6] & mac_a2accu_mode[6]) == 1'b0) begin
  end else begin
    calc_data_6[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[7]) == 1'b1) begin
    calc_data_7[43:0] <= mac_a2accu_data7[43:0];
  // VCS coverage off
  end else if ((mac_a2accu_mask[7]) == 1'b0) begin
  end else begin
    calc_data_7[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_a2accu_mask[7] & mac_a2accu_mode[7]) == 1'b1) begin
    calc_data_7[175:44] <= mac_a2accu_data7[175:44];
  // VCS coverage off
  end else if ((mac_a2accu_mask[7] & mac_a2accu_mode[7]) == 1'b0) begin
  end else begin
    calc_data_7[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[0]) == 1'b1) begin
    calc_data_8[43:0] <= mac_b2accu_data0[43:0];
  // VCS coverage off
  end else if ((mac_b2accu_mask[0]) == 1'b0) begin
  end else begin
    calc_data_8[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[0] & mac_b2accu_mode[0]) == 1'b1) begin
    calc_data_8[175:44] <= mac_b2accu_data0[175:44];
  // VCS coverage off
  end else if ((mac_b2accu_mask[0] & mac_b2accu_mode[0]) == 1'b0) begin
  end else begin
    calc_data_8[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[1]) == 1'b1) begin
    calc_data_9[43:0] <= mac_b2accu_data1[43:0];
  // VCS coverage off
  end else if ((mac_b2accu_mask[1]) == 1'b0) begin
  end else begin
    calc_data_9[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[1] & mac_b2accu_mode[1]) == 1'b1) begin
    calc_data_9[175:44] <= mac_b2accu_data1[175:44];
  // VCS coverage off
  end else if ((mac_b2accu_mask[1] & mac_b2accu_mode[1]) == 1'b0) begin
  end else begin
    calc_data_9[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[2]) == 1'b1) begin
    calc_data_10[43:0] <= mac_b2accu_data2[43:0];
  // VCS coverage off
  end else if ((mac_b2accu_mask[2]) == 1'b0) begin
  end else begin
    calc_data_10[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[2] & mac_b2accu_mode[2]) == 1'b1) begin
    calc_data_10[175:44] <= mac_b2accu_data2[175:44];
  // VCS coverage off
  end else if ((mac_b2accu_mask[2] & mac_b2accu_mode[2]) == 1'b0) begin
  end else begin
    calc_data_10[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[3]) == 1'b1) begin
    calc_data_11[43:0] <= mac_b2accu_data3[43:0];
  // VCS coverage off
  end else if ((mac_b2accu_mask[3]) == 1'b0) begin
  end else begin
    calc_data_11[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[3] & mac_b2accu_mode[3]) == 1'b1) begin
    calc_data_11[175:44] <= mac_b2accu_data3[175:44];
  // VCS coverage off
  end else if ((mac_b2accu_mask[3] & mac_b2accu_mode[3]) == 1'b0) begin
  end else begin
    calc_data_11[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[4]) == 1'b1) begin
    calc_data_12[43:0] <= mac_b2accu_data4[43:0];
  // VCS coverage off
  end else if ((mac_b2accu_mask[4]) == 1'b0) begin
  end else begin
    calc_data_12[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[4] & mac_b2accu_mode[4]) == 1'b1) begin
    calc_data_12[175:44] <= mac_b2accu_data4[175:44];
  // VCS coverage off
  end else if ((mac_b2accu_mask[4] & mac_b2accu_mode[4]) == 1'b0) begin
  end else begin
    calc_data_12[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[5]) == 1'b1) begin
    calc_data_13[43:0] <= mac_b2accu_data5[43:0];
  // VCS coverage off
  end else if ((mac_b2accu_mask[5]) == 1'b0) begin
  end else begin
    calc_data_13[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[5] & mac_b2accu_mode[5]) == 1'b1) begin
    calc_data_13[175:44] <= mac_b2accu_data5[175:44];
  // VCS coverage off
  end else if ((mac_b2accu_mask[5] & mac_b2accu_mode[5]) == 1'b0) begin
  end else begin
    calc_data_13[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[6]) == 1'b1) begin
    calc_data_14[43:0] <= mac_b2accu_data6[43:0];
  // VCS coverage off
  end else if ((mac_b2accu_mask[6]) == 1'b0) begin
  end else begin
    calc_data_14[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[6] & mac_b2accu_mode[6]) == 1'b1) begin
    calc_data_14[175:44] <= mac_b2accu_data6[175:44];
  // VCS coverage off
  end else if ((mac_b2accu_mask[6] & mac_b2accu_mode[6]) == 1'b0) begin
  end else begin
    calc_data_14[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[7]) == 1'b1) begin
    calc_data_15[43:0] <= mac_b2accu_data7[43:0];
  // VCS coverage off
  end else if ((mac_b2accu_mask[7]) == 1'b0) begin
  end else begin
    calc_data_15[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac_b2accu_mask[7] & mac_b2accu_mode[7]) == 1'b1) begin
    calc_data_15[175:44] <= mac_b2accu_data7[175:44];
  // VCS coverage off
  end else if ((mac_b2accu_mask[7] & mac_b2accu_mode[7]) == 1'b0) begin
  end else begin
    calc_data_15[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

assign calc_valid_fw_0 = (mac_b2accu_pvld | mac_a2accu_pvld);


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_valid_fw_1 <= 1'b0;
  end else begin
  calc_valid_fw_1 <= calc_valid_fw_0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_valid_fw_2 <= 1'b0;
  end else begin
  calc_valid_fw_2 <= calc_valid_fw_1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_valid_fw_3 <= 1'b0;
  end else begin
  calc_valid_fw_3 <= calc_valid_fw_2;
  end
end
assign calc_valid_w = calc_valid_fw_3;




always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_in_mask <= {192{1'b0}};
  end else begin
  if ((calc_valid_w | calc_valid) == 1'b1) begin
    calc_in_mask <= {12{mac_b2accu_mask, mac_a2accu_mask}};
  // VCS coverage off
  end else if ((calc_valid_w | calc_valid) == 1'b0) begin
  end else begin
    calc_in_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_valid_w | calc_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_valid <= 1'b0;
  end else begin
  calc_valid <= calc_valid_w;
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
  nv_assert_never #(0,0,"Error! calc two valid mismatch!")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, (accu_ctrl_valid ^ calc_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! valid and mask mismatch!")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (calc_valid ^ (|calc_in_mask))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// unpack input package from buffer controllor        /////
//////////////////////////////////////////////////////////////


// PKT_UNPACK_WIRE( nvdla_abuf_info ,  calc_ ,  accu_ctrl_pd )
assign        calc_addr[4:0] =     accu_ctrl_pd[4:0];
assign        calc_mode[3:0] =     accu_ctrl_pd[8:5];
assign        calc_rd_mask[7:0] =     accu_ctrl_pd[16:9];
assign         calc_stripe_end  =     accu_ctrl_pd[17];
assign         calc_channel_end  =     accu_ctrl_pd[18];
assign         calc_layer_end  =     accu_ctrl_pd[19];
assign        calc_ram_sel_0[15:0] =     accu_ctrl_pd[35:20];
assign        calc_ram_sel_1[15:0] =     accu_ctrl_pd[51:36];
assign        calc_ram_sel_2[15:0] =     accu_ctrl_pd[67:52];
assign        calc_ram_sel_3[15:0] =     accu_ctrl_pd[83:68];
assign        calc_ram_sel_4[15:0] =     accu_ctrl_pd[99:84];
assign        calc_ram_sel_5[15:0] =     accu_ctrl_pd[115:100];
assign        calc_ram_sel_6[15:0] =     accu_ctrl_pd[131:116];
assign        calc_ram_sel_7[15:0] =     accu_ctrl_pd[147:132];
assign        calc_dlv_elem_mask[191:0] =     accu_ctrl_pd[339:148];

//////////////////////////////////////////////////////////////
///// data shifter 1                                     /////
//////////////////////////////////////////////////////////////

assign calc_data_all = {calc_data_15, calc_data_14, calc_data_13, calc_data_12, calc_data_11, calc_data_10, calc_data_9, calc_data_8, calc_data_7, calc_data_6, calc_data_5, calc_data_4, calc_data_3, calc_data_2, calc_data_1, calc_data_0};

assign calc_data_16_0 = calc_data_all[43:0];
assign calc_data_16_1 = calc_data_all[87:44];
assign calc_data_16_2 = calc_data_all[131:88];
assign calc_data_16_3 = calc_data_all[175:132];
assign calc_data_16_4 = calc_data_all[219:176];
assign calc_data_16_5 = calc_data_all[263:220];
assign calc_data_16_6 = calc_data_all[307:264];
assign calc_data_16_7 = calc_data_all[351:308];
assign calc_data_16_8 = calc_data_all[395:352];
assign calc_data_16_9 = calc_data_all[439:396];
assign calc_data_16_10 = calc_data_all[483:440];
assign calc_data_16_11 = calc_data_all[527:484];
assign calc_data_16_12 = calc_data_all[571:528];
assign calc_data_16_13 = calc_data_all[615:572];
assign calc_data_16_14 = calc_data_all[659:616];
assign calc_data_16_15 = calc_data_all[703:660];
assign calc_data_16_16 = calc_data_all[747:704];
assign calc_data_16_17 = calc_data_all[791:748];
assign calc_data_16_18 = calc_data_all[835:792];
assign calc_data_16_19 = calc_data_all[879:836];
assign calc_data_16_20 = calc_data_all[923:880];
assign calc_data_16_21 = calc_data_all[967:924];
assign calc_data_16_22 = calc_data_all[1011:968];
assign calc_data_16_23 = calc_data_all[1055:1012];
assign calc_data_16_24 = calc_data_all[1099:1056];
assign calc_data_16_25 = calc_data_all[1143:1100];
assign calc_data_16_26 = calc_data_all[1187:1144];
assign calc_data_16_27 = calc_data_all[1231:1188];
assign calc_data_16_28 = calc_data_all[1275:1232];
assign calc_data_16_29 = calc_data_all[1319:1276];
assign calc_data_16_30 = calc_data_all[1363:1320];
assign calc_data_16_31 = calc_data_all[1407:1364];
assign calc_data_16_32 = calc_data_all[1451:1408];
assign calc_data_16_33 = calc_data_all[1495:1452];
assign calc_data_16_34 = calc_data_all[1539:1496];
assign calc_data_16_35 = calc_data_all[1583:1540];
assign calc_data_16_36 = calc_data_all[1627:1584];
assign calc_data_16_37 = calc_data_all[1671:1628];
assign calc_data_16_38 = calc_data_all[1715:1672];
assign calc_data_16_39 = calc_data_all[1759:1716];
assign calc_data_16_40 = calc_data_all[1803:1760];
assign calc_data_16_41 = calc_data_all[1847:1804];
assign calc_data_16_42 = calc_data_all[1891:1848];
assign calc_data_16_43 = calc_data_all[1935:1892];
assign calc_data_16_44 = calc_data_all[1979:1936];
assign calc_data_16_45 = calc_data_all[2023:1980];
assign calc_data_16_46 = calc_data_all[2067:2024];
assign calc_data_16_47 = calc_data_all[2111:2068];
assign calc_data_16_48 = calc_data_all[2155:2112];
assign calc_data_16_49 = calc_data_all[2199:2156];
assign calc_data_16_50 = calc_data_all[2243:2200];
assign calc_data_16_51 = calc_data_all[2287:2244];
assign calc_data_16_52 = calc_data_all[2331:2288];
assign calc_data_16_53 = calc_data_all[2375:2332];
assign calc_data_16_54 = calc_data_all[2419:2376];
assign calc_data_16_55 = calc_data_all[2463:2420];
assign calc_data_16_56 = calc_data_all[2507:2464];
assign calc_data_16_57 = calc_data_all[2551:2508];
assign calc_data_16_58 = calc_data_all[2595:2552];
assign calc_data_16_59 = calc_data_all[2639:2596];
assign calc_data_16_60 = calc_data_all[2683:2640];
assign calc_data_16_61 = calc_data_all[2727:2684];
assign calc_data_16_62 = calc_data_all[2771:2728];
assign calc_data_16_63 = calc_data_all[2815:2772];




assign calc_data_8_0 = {{22{calc_data_all[21]}}, calc_data_all[21:0]};
assign calc_data_8_2 = {{22{calc_data_all[65]}}, calc_data_all[65:44]};
assign calc_data_8_4 = {{22{calc_data_all[109]}}, calc_data_all[109:88]};
assign calc_data_8_6 = {{22{calc_data_all[153]}}, calc_data_all[153:132]};
assign calc_data_8_8 = {{22{calc_data_all[197]}}, calc_data_all[197:176]};
assign calc_data_8_10 = {{22{calc_data_all[241]}}, calc_data_all[241:220]};
assign calc_data_8_12 = {{22{calc_data_all[285]}}, calc_data_all[285:264]};
assign calc_data_8_14 = {{22{calc_data_all[329]}}, calc_data_all[329:308]};
assign calc_data_8_16 = {{22{calc_data_all[373]}}, calc_data_all[373:352]};
assign calc_data_8_18 = {{22{calc_data_all[417]}}, calc_data_all[417:396]};
assign calc_data_8_20 = {{22{calc_data_all[461]}}, calc_data_all[461:440]};
assign calc_data_8_22 = {{22{calc_data_all[505]}}, calc_data_all[505:484]};
assign calc_data_8_24 = {{22{calc_data_all[549]}}, calc_data_all[549:528]};
assign calc_data_8_26 = {{22{calc_data_all[593]}}, calc_data_all[593:572]};
assign calc_data_8_28 = {{22{calc_data_all[637]}}, calc_data_all[637:616]};
assign calc_data_8_30 = {{22{calc_data_all[681]}}, calc_data_all[681:660]};
assign calc_data_8_32 = {{22{calc_data_all[725]}}, calc_data_all[725:704]};
assign calc_data_8_34 = {{22{calc_data_all[769]}}, calc_data_all[769:748]};
assign calc_data_8_36 = {{22{calc_data_all[813]}}, calc_data_all[813:792]};
assign calc_data_8_38 = {{22{calc_data_all[857]}}, calc_data_all[857:836]};
assign calc_data_8_40 = {{22{calc_data_all[901]}}, calc_data_all[901:880]};
assign calc_data_8_42 = {{22{calc_data_all[945]}}, calc_data_all[945:924]};
assign calc_data_8_44 = {{22{calc_data_all[989]}}, calc_data_all[989:968]};
assign calc_data_8_46 = {{22{calc_data_all[1033]}}, calc_data_all[1033:1012]};
assign calc_data_8_48 = {{22{calc_data_all[1077]}}, calc_data_all[1077:1056]};
assign calc_data_8_50 = {{22{calc_data_all[1121]}}, calc_data_all[1121:1100]};
assign calc_data_8_52 = {{22{calc_data_all[1165]}}, calc_data_all[1165:1144]};
assign calc_data_8_54 = {{22{calc_data_all[1209]}}, calc_data_all[1209:1188]};
assign calc_data_8_56 = {{22{calc_data_all[1253]}}, calc_data_all[1253:1232]};
assign calc_data_8_58 = {{22{calc_data_all[1297]}}, calc_data_all[1297:1276]};
assign calc_data_8_60 = {{22{calc_data_all[1341]}}, calc_data_all[1341:1320]};
assign calc_data_8_62 = {{22{calc_data_all[1385]}}, calc_data_all[1385:1364]};
assign calc_data_8_64 = {{22{calc_data_all[1429]}}, calc_data_all[1429:1408]};
assign calc_data_8_66 = {{22{calc_data_all[1473]}}, calc_data_all[1473:1452]};
assign calc_data_8_68 = {{22{calc_data_all[1517]}}, calc_data_all[1517:1496]};
assign calc_data_8_70 = {{22{calc_data_all[1561]}}, calc_data_all[1561:1540]};
assign calc_data_8_72 = {{22{calc_data_all[1605]}}, calc_data_all[1605:1584]};
assign calc_data_8_74 = {{22{calc_data_all[1649]}}, calc_data_all[1649:1628]};
assign calc_data_8_76 = {{22{calc_data_all[1693]}}, calc_data_all[1693:1672]};
assign calc_data_8_78 = {{22{calc_data_all[1737]}}, calc_data_all[1737:1716]};
assign calc_data_8_80 = {{22{calc_data_all[1781]}}, calc_data_all[1781:1760]};
assign calc_data_8_82 = {{22{calc_data_all[1825]}}, calc_data_all[1825:1804]};
assign calc_data_8_84 = {{22{calc_data_all[1869]}}, calc_data_all[1869:1848]};
assign calc_data_8_86 = {{22{calc_data_all[1913]}}, calc_data_all[1913:1892]};
assign calc_data_8_88 = {{22{calc_data_all[1957]}}, calc_data_all[1957:1936]};
assign calc_data_8_90 = {{22{calc_data_all[2001]}}, calc_data_all[2001:1980]};
assign calc_data_8_92 = {{22{calc_data_all[2045]}}, calc_data_all[2045:2024]};
assign calc_data_8_94 = {{22{calc_data_all[2089]}}, calc_data_all[2089:2068]};
assign calc_data_8_96 = {{22{calc_data_all[2133]}}, calc_data_all[2133:2112]};
assign calc_data_8_98 = {{22{calc_data_all[2177]}}, calc_data_all[2177:2156]};
assign calc_data_8_100 = {{22{calc_data_all[2221]}}, calc_data_all[2221:2200]};
assign calc_data_8_102 = {{22{calc_data_all[2265]}}, calc_data_all[2265:2244]};
assign calc_data_8_104 = {{22{calc_data_all[2309]}}, calc_data_all[2309:2288]};
assign calc_data_8_106 = {{22{calc_data_all[2353]}}, calc_data_all[2353:2332]};
assign calc_data_8_108 = {{22{calc_data_all[2397]}}, calc_data_all[2397:2376]};
assign calc_data_8_110 = {{22{calc_data_all[2441]}}, calc_data_all[2441:2420]};
assign calc_data_8_112 = {{22{calc_data_all[2485]}}, calc_data_all[2485:2464]};
assign calc_data_8_114 = {{22{calc_data_all[2529]}}, calc_data_all[2529:2508]};
assign calc_data_8_116 = {{22{calc_data_all[2573]}}, calc_data_all[2573:2552]};
assign calc_data_8_118 = {{22{calc_data_all[2617]}}, calc_data_all[2617:2596]};
assign calc_data_8_120 = {{22{calc_data_all[2661]}}, calc_data_all[2661:2640]};
assign calc_data_8_122 = {{22{calc_data_all[2705]}}, calc_data_all[2705:2684]};
assign calc_data_8_124 = {{22{calc_data_all[2749]}}, calc_data_all[2749:2728]};
assign calc_data_8_126 = {{22{calc_data_all[2793]}}, calc_data_all[2793:2772]};




assign calc_data_8_1 = calc_data_all[43:22];
assign calc_data_8_3 = calc_data_all[87:66];
assign calc_data_8_5 = calc_data_all[131:110];
assign calc_data_8_7 = calc_data_all[175:154];
assign calc_data_8_9 = calc_data_all[219:198];
assign calc_data_8_11 = calc_data_all[263:242];
assign calc_data_8_13 = calc_data_all[307:286];
assign calc_data_8_15 = calc_data_all[351:330];
assign calc_data_8_17 = calc_data_all[395:374];
assign calc_data_8_19 = calc_data_all[439:418];
assign calc_data_8_21 = calc_data_all[483:462];
assign calc_data_8_23 = calc_data_all[527:506];
assign calc_data_8_25 = calc_data_all[571:550];
assign calc_data_8_27 = calc_data_all[615:594];
assign calc_data_8_29 = calc_data_all[659:638];
assign calc_data_8_31 = calc_data_all[703:682];
assign calc_data_8_33 = calc_data_all[747:726];
assign calc_data_8_35 = calc_data_all[791:770];
assign calc_data_8_37 = calc_data_all[835:814];
assign calc_data_8_39 = calc_data_all[879:858];
assign calc_data_8_41 = calc_data_all[923:902];
assign calc_data_8_43 = calc_data_all[967:946];
assign calc_data_8_45 = calc_data_all[1011:990];
assign calc_data_8_47 = calc_data_all[1055:1034];
assign calc_data_8_49 = calc_data_all[1099:1078];
assign calc_data_8_51 = calc_data_all[1143:1122];
assign calc_data_8_53 = calc_data_all[1187:1166];
assign calc_data_8_55 = calc_data_all[1231:1210];
assign calc_data_8_57 = calc_data_all[1275:1254];
assign calc_data_8_59 = calc_data_all[1319:1298];
assign calc_data_8_61 = calc_data_all[1363:1342];
assign calc_data_8_63 = calc_data_all[1407:1386];
assign calc_data_8_65 = calc_data_all[1451:1430];
assign calc_data_8_67 = calc_data_all[1495:1474];
assign calc_data_8_69 = calc_data_all[1539:1518];
assign calc_data_8_71 = calc_data_all[1583:1562];
assign calc_data_8_73 = calc_data_all[1627:1606];
assign calc_data_8_75 = calc_data_all[1671:1650];
assign calc_data_8_77 = calc_data_all[1715:1694];
assign calc_data_8_79 = calc_data_all[1759:1738];
assign calc_data_8_81 = calc_data_all[1803:1782];
assign calc_data_8_83 = calc_data_all[1847:1826];
assign calc_data_8_85 = calc_data_all[1891:1870];
assign calc_data_8_87 = calc_data_all[1935:1914];
assign calc_data_8_89 = calc_data_all[1979:1958];
assign calc_data_8_91 = calc_data_all[2023:2002];
assign calc_data_8_93 = calc_data_all[2067:2046];
assign calc_data_8_95 = calc_data_all[2111:2090];
assign calc_data_8_97 = calc_data_all[2155:2134];
assign calc_data_8_99 = calc_data_all[2199:2178];
assign calc_data_8_101 = calc_data_all[2243:2222];
assign calc_data_8_103 = calc_data_all[2287:2266];
assign calc_data_8_105 = calc_data_all[2331:2310];
assign calc_data_8_107 = calc_data_all[2375:2354];
assign calc_data_8_109 = calc_data_all[2419:2398];
assign calc_data_8_111 = calc_data_all[2463:2442];
assign calc_data_8_113 = calc_data_all[2507:2486];
assign calc_data_8_115 = calc_data_all[2551:2530];
assign calc_data_8_117 = calc_data_all[2595:2574];
assign calc_data_8_119 = calc_data_all[2639:2618];
assign calc_data_8_121 = calc_data_all[2683:2662];
assign calc_data_8_123 = calc_data_all[2727:2706];
assign calc_data_8_125 = calc_data_all[2771:2750];
assign calc_data_8_127 = calc_data_all[2815:2794];












assign calc_elem_0_w = cfg_is_int8[0] ? calc_data_8_0 : calc_data_16_0;
assign calc_elem_1_w = cfg_is_int8[1] ? calc_data_8_8 : calc_data_16_4;
assign calc_elem_2_w = cfg_is_int8[2] ? calc_data_8_16 : calc_data_16_8;
assign calc_elem_3_w = cfg_is_int8[3] ? calc_data_8_24 : calc_data_16_12;
assign calc_elem_4_w = cfg_is_int8[4] ? calc_data_8_32 : calc_data_16_16;
assign calc_elem_5_w = cfg_is_int8[5] ? calc_data_8_40 : calc_data_16_20;
assign calc_elem_6_w = cfg_is_int8[6] ? calc_data_8_48 : calc_data_16_24;
assign calc_elem_7_w = cfg_is_int8[7] ? calc_data_8_56 : calc_data_16_28;
assign calc_elem_8_w = cfg_is_int8[8] ? calc_data_8_64 : calc_data_16_32;
assign calc_elem_9_w = cfg_is_int8[9] ? calc_data_8_72 : calc_data_16_36;
assign calc_elem_10_w = cfg_is_int8[10] ? calc_data_8_80 : calc_data_16_40;
assign calc_elem_11_w = cfg_is_int8[11] ? calc_data_8_88 : calc_data_16_44;
assign calc_elem_12_w = cfg_is_int8[12] ? calc_data_8_96 : calc_data_16_48;
assign calc_elem_13_w = cfg_is_int8[13] ? calc_data_8_104 : calc_data_16_52;
assign calc_elem_14_w = cfg_is_int8[14] ? calc_data_8_112 : calc_data_16_56;
assign calc_elem_15_w = cfg_is_int8[15] ? calc_data_8_120 : calc_data_16_60;
assign calc_elem_16_w = cfg_is_int8[16] ? calc_data_8_2 : calc_data_16_1;
assign calc_elem_17_w = cfg_is_int8[17] ? calc_data_8_10 : calc_data_16_5;
assign calc_elem_18_w = cfg_is_int8[18] ? calc_data_8_18 : calc_data_16_9;
assign calc_elem_19_w = cfg_is_int8[19] ? calc_data_8_26 : calc_data_16_13;
assign calc_elem_20_w = cfg_is_int8[20] ? calc_data_8_34 : calc_data_16_17;
assign calc_elem_21_w = cfg_is_int8[21] ? calc_data_8_42 : calc_data_16_21;
assign calc_elem_22_w = cfg_is_int8[22] ? calc_data_8_50 : calc_data_16_25;
assign calc_elem_23_w = cfg_is_int8[23] ? calc_data_8_58 : calc_data_16_29;
assign calc_elem_24_w = cfg_is_int8[24] ? calc_data_8_66 : calc_data_16_33;
assign calc_elem_25_w = cfg_is_int8[25] ? calc_data_8_74 : calc_data_16_37;
assign calc_elem_26_w = cfg_is_int8[26] ? calc_data_8_82 : calc_data_16_41;
assign calc_elem_27_w = cfg_is_int8[27] ? calc_data_8_90 : calc_data_16_45;
assign calc_elem_28_w = cfg_is_int8[28] ? calc_data_8_98 : calc_data_16_49;
assign calc_elem_29_w = cfg_is_int8[29] ? calc_data_8_106 : calc_data_16_53;
assign calc_elem_30_w = cfg_is_int8[30] ? calc_data_8_114 : calc_data_16_57;
assign calc_elem_31_w = cfg_is_int8[31] ? calc_data_8_122 : calc_data_16_61;
assign calc_elem_32_w = cfg_is_int8[32] ? calc_data_8_4 : calc_data_16_2;
assign calc_elem_33_w = cfg_is_int8[33] ? calc_data_8_12 : calc_data_16_6;
assign calc_elem_34_w = cfg_is_int8[34] ? calc_data_8_20 : calc_data_16_10;
assign calc_elem_35_w = cfg_is_int8[35] ? calc_data_8_28 : calc_data_16_14;
assign calc_elem_36_w = cfg_is_int8[36] ? calc_data_8_36 : calc_data_16_18;
assign calc_elem_37_w = cfg_is_int8[37] ? calc_data_8_44 : calc_data_16_22;
assign calc_elem_38_w = cfg_is_int8[38] ? calc_data_8_52 : calc_data_16_26;
assign calc_elem_39_w = cfg_is_int8[39] ? calc_data_8_60 : calc_data_16_30;
assign calc_elem_40_w = cfg_is_int8[40] ? calc_data_8_68 : calc_data_16_34;
assign calc_elem_41_w = cfg_is_int8[41] ? calc_data_8_76 : calc_data_16_38;
assign calc_elem_42_w = cfg_is_int8[42] ? calc_data_8_84 : calc_data_16_42;
assign calc_elem_43_w = cfg_is_int8[43] ? calc_data_8_92 : calc_data_16_46;
assign calc_elem_44_w = cfg_is_int8[44] ? calc_data_8_100 : calc_data_16_50;
assign calc_elem_45_w = cfg_is_int8[45] ? calc_data_8_108 : calc_data_16_54;
assign calc_elem_46_w = cfg_is_int8[46] ? calc_data_8_116 : calc_data_16_58;
assign calc_elem_47_w = cfg_is_int8[47] ? calc_data_8_124 : calc_data_16_62;
assign calc_elem_48_w = cfg_is_int8[48] ? calc_data_8_6 : calc_data_16_3;
assign calc_elem_49_w = cfg_is_int8[49] ? calc_data_8_14 : calc_data_16_7;
assign calc_elem_50_w = cfg_is_int8[50] ? calc_data_8_22 : calc_data_16_11;
assign calc_elem_51_w = cfg_is_int8[51] ? calc_data_8_30 : calc_data_16_15;
assign calc_elem_52_w = cfg_is_int8[52] ? calc_data_8_38 : calc_data_16_19;
assign calc_elem_53_w = cfg_is_int8[53] ? calc_data_8_46 : calc_data_16_23;
assign calc_elem_54_w = cfg_is_int8[54] ? calc_data_8_54 : calc_data_16_27;
assign calc_elem_55_w = cfg_is_int8[55] ? calc_data_8_62 : calc_data_16_31;
assign calc_elem_56_w = cfg_is_int8[56] ? calc_data_8_70 : calc_data_16_35;
assign calc_elem_57_w = cfg_is_int8[57] ? calc_data_8_78 : calc_data_16_39;
assign calc_elem_58_w = cfg_is_int8[58] ? calc_data_8_86 : calc_data_16_43;
assign calc_elem_59_w = cfg_is_int8[59] ? calc_data_8_94 : calc_data_16_47;
assign calc_elem_60_w = cfg_is_int8[60] ? calc_data_8_102 : calc_data_16_51;
assign calc_elem_61_w = cfg_is_int8[61] ? calc_data_8_110 : calc_data_16_55;
assign calc_elem_62_w = cfg_is_int8[62] ? calc_data_8_118 : calc_data_16_59;
assign calc_elem_63_w = cfg_is_int8[63] ? calc_data_8_126 : calc_data_16_63;




assign calc_elem_64_w = calc_data_8_1;
assign calc_elem_65_w = calc_data_8_9;
assign calc_elem_66_w = calc_data_8_17;
assign calc_elem_67_w = calc_data_8_25;
assign calc_elem_68_w = calc_data_8_33;
assign calc_elem_69_w = calc_data_8_41;
assign calc_elem_70_w = calc_data_8_49;
assign calc_elem_71_w = calc_data_8_57;
assign calc_elem_72_w = calc_data_8_65;
assign calc_elem_73_w = calc_data_8_73;
assign calc_elem_74_w = calc_data_8_81;
assign calc_elem_75_w = calc_data_8_89;
assign calc_elem_76_w = calc_data_8_97;
assign calc_elem_77_w = calc_data_8_105;
assign calc_elem_78_w = calc_data_8_113;
assign calc_elem_79_w = calc_data_8_121;
assign calc_elem_80_w = calc_data_8_3;
assign calc_elem_81_w = calc_data_8_11;
assign calc_elem_82_w = calc_data_8_19;
assign calc_elem_83_w = calc_data_8_27;
assign calc_elem_84_w = calc_data_8_35;
assign calc_elem_85_w = calc_data_8_43;
assign calc_elem_86_w = calc_data_8_51;
assign calc_elem_87_w = calc_data_8_59;
assign calc_elem_88_w = calc_data_8_67;
assign calc_elem_89_w = calc_data_8_75;
assign calc_elem_90_w = calc_data_8_83;
assign calc_elem_91_w = calc_data_8_91;
assign calc_elem_92_w = calc_data_8_99;
assign calc_elem_93_w = calc_data_8_107;
assign calc_elem_94_w = calc_data_8_115;
assign calc_elem_95_w = calc_data_8_123;
assign calc_elem_96_w = calc_data_8_5;
assign calc_elem_97_w = calc_data_8_13;
assign calc_elem_98_w = calc_data_8_21;
assign calc_elem_99_w = calc_data_8_29;
assign calc_elem_100_w = calc_data_8_37;
assign calc_elem_101_w = calc_data_8_45;
assign calc_elem_102_w = calc_data_8_53;
assign calc_elem_103_w = calc_data_8_61;
assign calc_elem_104_w = calc_data_8_69;
assign calc_elem_105_w = calc_data_8_77;
assign calc_elem_106_w = calc_data_8_85;
assign calc_elem_107_w = calc_data_8_93;
assign calc_elem_108_w = calc_data_8_101;
assign calc_elem_109_w = calc_data_8_109;
assign calc_elem_110_w = calc_data_8_117;
assign calc_elem_111_w = calc_data_8_125;
assign calc_elem_112_w = calc_data_8_7;
assign calc_elem_113_w = calc_data_8_15;
assign calc_elem_114_w = calc_data_8_23;
assign calc_elem_115_w = calc_data_8_31;
assign calc_elem_116_w = calc_data_8_39;
assign calc_elem_117_w = calc_data_8_47;
assign calc_elem_118_w = calc_data_8_55;
assign calc_elem_119_w = calc_data_8_63;
assign calc_elem_120_w = calc_data_8_71;
assign calc_elem_121_w = calc_data_8_79;
assign calc_elem_122_w = calc_data_8_87;
assign calc_elem_123_w = calc_data_8_95;
assign calc_elem_124_w = calc_data_8_103;
assign calc_elem_125_w = calc_data_8_111;
assign calc_elem_126_w = calc_data_8_119;
assign calc_elem_127_w = calc_data_8_127;





//////////////////////////////////////////////////////////////
///// A_BUFFER read data shifter                         /////
//////////////////////////////////////////////////////////////







assign calc_ram_sel_0_ext = {{48{calc_ram_sel_0[15]}}, {48{calc_ram_sel_0[14]}}, {48{calc_ram_sel_0[13]}}, {48{calc_ram_sel_0[12]}}, {48{calc_ram_sel_0[11]}}, {48{calc_ram_sel_0[10]}}, {48{calc_ram_sel_0[9]}}, {48{calc_ram_sel_0[8]}}, {48{calc_ram_sel_0[7]}}, {48{calc_ram_sel_0[6]}}, {48{calc_ram_sel_0[5]}}, {48{calc_ram_sel_0[4]}}, {48{calc_ram_sel_0[3]}}, {48{calc_ram_sel_0[2]}}, {48{calc_ram_sel_0[1]}}, {48{calc_ram_sel_0[0]}}};
assign calc_ram_sel_1_ext = {{48{calc_ram_sel_1[15]}}, {48{calc_ram_sel_1[14]}}, {48{calc_ram_sel_1[13]}}, {48{calc_ram_sel_1[12]}}, {48{calc_ram_sel_1[11]}}, {48{calc_ram_sel_1[10]}}, {48{calc_ram_sel_1[9]}}, {48{calc_ram_sel_1[8]}}, {48{calc_ram_sel_1[7]}}, {48{calc_ram_sel_1[6]}}, {48{calc_ram_sel_1[5]}}, {48{calc_ram_sel_1[4]}}, {48{calc_ram_sel_1[3]}}, {48{calc_ram_sel_1[2]}}, {48{calc_ram_sel_1[1]}}, {48{calc_ram_sel_1[0]}}};
assign calc_ram_sel_2_ext = {{48{calc_ram_sel_2[15]}}, {48{calc_ram_sel_2[14]}}, {48{calc_ram_sel_2[13]}}, {48{calc_ram_sel_2[12]}}, {48{calc_ram_sel_2[11]}}, {48{calc_ram_sel_2[10]}}, {48{calc_ram_sel_2[9]}}, {48{calc_ram_sel_2[8]}}, {48{calc_ram_sel_2[7]}}, {48{calc_ram_sel_2[6]}}, {48{calc_ram_sel_2[5]}}, {48{calc_ram_sel_2[4]}}, {48{calc_ram_sel_2[3]}}, {48{calc_ram_sel_2[2]}}, {48{calc_ram_sel_2[1]}}, {48{calc_ram_sel_2[0]}}};
assign calc_ram_sel_3_ext = {{48{calc_ram_sel_3[15]}}, {48{calc_ram_sel_3[14]}}, {48{calc_ram_sel_3[13]}}, {48{calc_ram_sel_3[12]}}, {48{calc_ram_sel_3[11]}}, {48{calc_ram_sel_3[10]}}, {48{calc_ram_sel_3[9]}}, {48{calc_ram_sel_3[8]}}, {48{calc_ram_sel_3[7]}}, {48{calc_ram_sel_3[6]}}, {48{calc_ram_sel_3[5]}}, {48{calc_ram_sel_3[4]}}, {48{calc_ram_sel_3[3]}}, {48{calc_ram_sel_3[2]}}, {48{calc_ram_sel_3[1]}}, {48{calc_ram_sel_3[0]}}};
assign calc_ram_sel_4_ext = {{34{calc_ram_sel_4[15]}}, {34{calc_ram_sel_4[14]}}, {34{calc_ram_sel_4[13]}}, {34{calc_ram_sel_4[12]}}, {34{calc_ram_sel_4[11]}}, {34{calc_ram_sel_4[10]}}, {34{calc_ram_sel_4[9]}}, {34{calc_ram_sel_4[8]}}, {34{calc_ram_sel_4[7]}}, {34{calc_ram_sel_4[6]}}, {34{calc_ram_sel_4[5]}}, {34{calc_ram_sel_4[4]}}, {34{calc_ram_sel_4[3]}}, {34{calc_ram_sel_4[2]}}, {34{calc_ram_sel_4[1]}}, {34{calc_ram_sel_4[0]}}};
assign calc_ram_sel_5_ext = {{34{calc_ram_sel_5[15]}}, {34{calc_ram_sel_5[14]}}, {34{calc_ram_sel_5[13]}}, {34{calc_ram_sel_5[12]}}, {34{calc_ram_sel_5[11]}}, {34{calc_ram_sel_5[10]}}, {34{calc_ram_sel_5[9]}}, {34{calc_ram_sel_5[8]}}, {34{calc_ram_sel_5[7]}}, {34{calc_ram_sel_5[6]}}, {34{calc_ram_sel_5[5]}}, {34{calc_ram_sel_5[4]}}, {34{calc_ram_sel_5[3]}}, {34{calc_ram_sel_5[2]}}, {34{calc_ram_sel_5[1]}}, {34{calc_ram_sel_5[0]}}};
assign calc_ram_sel_6_ext = {{34{calc_ram_sel_6[15]}}, {34{calc_ram_sel_6[14]}}, {34{calc_ram_sel_6[13]}}, {34{calc_ram_sel_6[12]}}, {34{calc_ram_sel_6[11]}}, {34{calc_ram_sel_6[10]}}, {34{calc_ram_sel_6[9]}}, {34{calc_ram_sel_6[8]}}, {34{calc_ram_sel_6[7]}}, {34{calc_ram_sel_6[6]}}, {34{calc_ram_sel_6[5]}}, {34{calc_ram_sel_6[4]}}, {34{calc_ram_sel_6[3]}}, {34{calc_ram_sel_6[2]}}, {34{calc_ram_sel_6[1]}}, {34{calc_ram_sel_6[0]}}};
assign calc_ram_sel_7_ext = {{34{calc_ram_sel_7[15]}}, {34{calc_ram_sel_7[14]}}, {34{calc_ram_sel_7[13]}}, {34{calc_ram_sel_7[12]}}, {34{calc_ram_sel_7[11]}}, {34{calc_ram_sel_7[10]}}, {34{calc_ram_sel_7[9]}}, {34{calc_ram_sel_7[8]}}, {34{calc_ram_sel_7[7]}}, {34{calc_ram_sel_7[6]}}, {34{calc_ram_sel_7[5]}}, {34{calc_ram_sel_7[4]}}, {34{calc_ram_sel_7[3]}}, {34{calc_ram_sel_7[2]}}, {34{calc_ram_sel_7[1]}}, {34{calc_ram_sel_7[0]}}};




always @(
  calc_ram_sel_0_ext
  or abuf_rd_data_0
  or calc_ram_sel_1_ext
  or abuf_rd_data_1
  or calc_ram_sel_2_ext
  or abuf_rd_data_2
  or calc_ram_sel_3_ext
  or abuf_rd_data_3
  ) begin
    abuf_rd_data_0_sft = (calc_ram_sel_0_ext & abuf_rd_data_0) |
                         (calc_ram_sel_1_ext & abuf_rd_data_1) |
                         (calc_ram_sel_2_ext & abuf_rd_data_2) |
                         (calc_ram_sel_3_ext & abuf_rd_data_3);
end

always @(
  abuf_rd_data_1
  or abuf_rd_data_2
  or abuf_rd_data_3
  ) begin
    abuf_rd_data_1_sft = abuf_rd_data_1;
    abuf_rd_data_2_sft = abuf_rd_data_2;
    abuf_rd_data_3_sft = abuf_rd_data_3;
end

always @(
  calc_ram_sel_4_ext
  or abuf_rd_data_4
  or calc_ram_sel_5_ext
  or abuf_rd_data_5
  or calc_ram_sel_6_ext
  or abuf_rd_data_6
  or calc_ram_sel_7_ext
  or abuf_rd_data_7
  ) begin
    abuf_rd_data_4_sft = (calc_ram_sel_4_ext & abuf_rd_data_4) |
                         (calc_ram_sel_5_ext & abuf_rd_data_5) |
                         (calc_ram_sel_6_ext & abuf_rd_data_6) |
                         (calc_ram_sel_7_ext & abuf_rd_data_7);
end

always @(
  abuf_rd_data_5
  or abuf_rd_data_6
  or abuf_rd_data_7
  ) begin
    abuf_rd_data_5_sft = abuf_rd_data_5;
    abuf_rd_data_6_sft = abuf_rd_data_6;
    abuf_rd_data_7_sft = abuf_rd_data_7;
end

always @(
  abuf_rd_data_7_sft
  or abuf_rd_data_6_sft
  or abuf_rd_data_5_sft
  or abuf_rd_data_4_sft
  or abuf_rd_data_3_sft
  or abuf_rd_data_2_sft
  or abuf_rd_data_1_sft
  or abuf_rd_data_0_sft
  ) begin
    {abuf_in_data_127, abuf_in_data_126, abuf_in_data_125, abuf_in_data_124, abuf_in_data_123, abuf_in_data_122, abuf_in_data_121, abuf_in_data_120, abuf_in_data_119, abuf_in_data_118, abuf_in_data_117, abuf_in_data_116, abuf_in_data_115, abuf_in_data_114, abuf_in_data_113, abuf_in_data_112, abuf_in_data_111, abuf_in_data_110, abuf_in_data_109, abuf_in_data_108, abuf_in_data_107, abuf_in_data_106, abuf_in_data_105, abuf_in_data_104, abuf_in_data_103, abuf_in_data_102, abuf_in_data_101, abuf_in_data_100, abuf_in_data_99, abuf_in_data_98, abuf_in_data_97, abuf_in_data_96, abuf_in_data_95, abuf_in_data_94, abuf_in_data_93, abuf_in_data_92, abuf_in_data_91, abuf_in_data_90, abuf_in_data_89, abuf_in_data_88, abuf_in_data_87, abuf_in_data_86, abuf_in_data_85, abuf_in_data_84, abuf_in_data_83, abuf_in_data_82, abuf_in_data_81, abuf_in_data_80, abuf_in_data_79, abuf_in_data_78, abuf_in_data_77, abuf_in_data_76, abuf_in_data_75, abuf_in_data_74, abuf_in_data_73, abuf_in_data_72, abuf_in_data_71, abuf_in_data_70, abuf_in_data_69, abuf_in_data_68, abuf_in_data_67, abuf_in_data_66, abuf_in_data_65, abuf_in_data_64, abuf_in_data_63, abuf_in_data_62, abuf_in_data_61, abuf_in_data_60, abuf_in_data_59, abuf_in_data_58, abuf_in_data_57, abuf_in_data_56, abuf_in_data_55, abuf_in_data_54, abuf_in_data_53, abuf_in_data_52, abuf_in_data_51, abuf_in_data_50, abuf_in_data_49, abuf_in_data_48, abuf_in_data_47, abuf_in_data_46, abuf_in_data_45, abuf_in_data_44, abuf_in_data_43, abuf_in_data_42, abuf_in_data_41, abuf_in_data_40, abuf_in_data_39, abuf_in_data_38, abuf_in_data_37, abuf_in_data_36, abuf_in_data_35, abuf_in_data_34, abuf_in_data_33, abuf_in_data_32, abuf_in_data_31, abuf_in_data_30, abuf_in_data_29, abuf_in_data_28, abuf_in_data_27, abuf_in_data_26, abuf_in_data_25, abuf_in_data_24, abuf_in_data_23, abuf_in_data_22, abuf_in_data_21, abuf_in_data_20, abuf_in_data_19, abuf_in_data_18, abuf_in_data_17, abuf_in_data_16, abuf_in_data_15, abuf_in_data_14, abuf_in_data_13, abuf_in_data_12, abuf_in_data_11, abuf_in_data_10, abuf_in_data_9, abuf_in_data_8, abuf_in_data_7, abuf_in_data_6, abuf_in_data_5, abuf_in_data_4, abuf_in_data_3, abuf_in_data_2, abuf_in_data_1, abuf_in_data_0} = {abuf_rd_data_7_sft, abuf_rd_data_6_sft, abuf_rd_data_5_sft, abuf_rd_data_4_sft, abuf_rd_data_3_sft, abuf_rd_data_2_sft, abuf_rd_data_1_sft, abuf_rd_data_0_sft};
end

//////////////////////////////////////////////////////////////
///// Control signals                                    /////
//////////////////////////////////////////////////////////////
assign calc_elem_en = calc_in_mask & cfg_in_en_mask;
assign calc_op_en_int = calc_elem_en[127:0];
assign calc_op_en_fp = calc_elem_en[191:128];

assign calc_elem_op1_vld = calc_elem_en & accu_ctrl_ram_valid;
assign calc_op1_vld_int = calc_elem_op1_vld[127:0];
assign calc_op1_vld_fp = calc_elem_op1_vld[191:128];

assign calc_dlv_elem_en = calc_elem_en & calc_dlv_elem_mask;
assign calc_dlv_en_int = calc_dlv_elem_en[127:0];
assign calc_dlv_en_fp = calc_dlv_elem_en[191:128];

always @(
  calc_valid
  or calc_channel_end
  or calc_mode
  ) begin
    calc_dlv_en = (~calc_valid | ~calc_channel_end) ? 8  'b0 :
                  calc_mode[0] ? 8  'h1 :
                  calc_mode[1] ? 8  'h3 :
                  calc_mode[2] ? 8  'hf :
                  8  'hff;
end

always @(
  accu_ctrl_valid
  or calc_channel_end
  or calc_rd_mask
  ) begin
    calc_wr_en =  (~accu_ctrl_valid | calc_channel_end) ? 8  'b0 :
                  calc_rd_mask;
end

always @(
  accu_ctrl_valid
  or calc_channel_end
  ) begin
    calc_dlv_valid = accu_ctrl_valid & calc_channel_end;
end

assign calc_valid_d0 = accu_ctrl_valid & calc_valid;

//////////////////////////////////////////////////////////////
///// pipe register 1                                    /////
//////////////////////////////////////////////////////////////

always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[0]) == 1'b1) begin
    calc_op0_int_0_d1 <= calc_elem_0_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[0]) == 1'b0) begin
  end else begin
    calc_op0_int_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[1]) == 1'b1) begin
    calc_op0_int_1_d1 <= calc_elem_1_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[1]) == 1'b0) begin
  end else begin
    calc_op0_int_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[2]) == 1'b1) begin
    calc_op0_int_2_d1 <= calc_elem_2_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[2]) == 1'b0) begin
  end else begin
    calc_op0_int_2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[3]) == 1'b1) begin
    calc_op0_int_3_d1 <= calc_elem_3_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[3]) == 1'b0) begin
  end else begin
    calc_op0_int_3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[4]) == 1'b1) begin
    calc_op0_int_4_d1 <= calc_elem_4_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[4]) == 1'b0) begin
  end else begin
    calc_op0_int_4_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[5]) == 1'b1) begin
    calc_op0_int_5_d1 <= calc_elem_5_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[5]) == 1'b0) begin
  end else begin
    calc_op0_int_5_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[6]) == 1'b1) begin
    calc_op0_int_6_d1 <= calc_elem_6_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[6]) == 1'b0) begin
  end else begin
    calc_op0_int_6_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[7]) == 1'b1) begin
    calc_op0_int_7_d1 <= calc_elem_7_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[7]) == 1'b0) begin
  end else begin
    calc_op0_int_7_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[8]) == 1'b1) begin
    calc_op0_int_8_d1 <= calc_elem_8_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[8]) == 1'b0) begin
  end else begin
    calc_op0_int_8_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[9]) == 1'b1) begin
    calc_op0_int_9_d1 <= calc_elem_9_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[9]) == 1'b0) begin
  end else begin
    calc_op0_int_9_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[10]) == 1'b1) begin
    calc_op0_int_10_d1 <= calc_elem_10_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[10]) == 1'b0) begin
  end else begin
    calc_op0_int_10_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[11]) == 1'b1) begin
    calc_op0_int_11_d1 <= calc_elem_11_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[11]) == 1'b0) begin
  end else begin
    calc_op0_int_11_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[12]) == 1'b1) begin
    calc_op0_int_12_d1 <= calc_elem_12_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[12]) == 1'b0) begin
  end else begin
    calc_op0_int_12_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[13]) == 1'b1) begin
    calc_op0_int_13_d1 <= calc_elem_13_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[13]) == 1'b0) begin
  end else begin
    calc_op0_int_13_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[14]) == 1'b1) begin
    calc_op0_int_14_d1 <= calc_elem_14_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[14]) == 1'b0) begin
  end else begin
    calc_op0_int_14_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[15]) == 1'b1) begin
    calc_op0_int_15_d1 <= calc_elem_15_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[15]) == 1'b0) begin
  end else begin
    calc_op0_int_15_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[16]) == 1'b1) begin
    calc_op0_int_16_d1 <= calc_elem_16_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[16]) == 1'b0) begin
  end else begin
    calc_op0_int_16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[17]) == 1'b1) begin
    calc_op0_int_17_d1 <= calc_elem_17_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[17]) == 1'b0) begin
  end else begin
    calc_op0_int_17_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[18]) == 1'b1) begin
    calc_op0_int_18_d1 <= calc_elem_18_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[18]) == 1'b0) begin
  end else begin
    calc_op0_int_18_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[19]) == 1'b1) begin
    calc_op0_int_19_d1 <= calc_elem_19_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[19]) == 1'b0) begin
  end else begin
    calc_op0_int_19_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[20]) == 1'b1) begin
    calc_op0_int_20_d1 <= calc_elem_20_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[20]) == 1'b0) begin
  end else begin
    calc_op0_int_20_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[21]) == 1'b1) begin
    calc_op0_int_21_d1 <= calc_elem_21_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[21]) == 1'b0) begin
  end else begin
    calc_op0_int_21_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[22]) == 1'b1) begin
    calc_op0_int_22_d1 <= calc_elem_22_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[22]) == 1'b0) begin
  end else begin
    calc_op0_int_22_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[23]) == 1'b1) begin
    calc_op0_int_23_d1 <= calc_elem_23_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[23]) == 1'b0) begin
  end else begin
    calc_op0_int_23_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[24]) == 1'b1) begin
    calc_op0_int_24_d1 <= calc_elem_24_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[24]) == 1'b0) begin
  end else begin
    calc_op0_int_24_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[25]) == 1'b1) begin
    calc_op0_int_25_d1 <= calc_elem_25_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[25]) == 1'b0) begin
  end else begin
    calc_op0_int_25_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[26]) == 1'b1) begin
    calc_op0_int_26_d1 <= calc_elem_26_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[26]) == 1'b0) begin
  end else begin
    calc_op0_int_26_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[27]) == 1'b1) begin
    calc_op0_int_27_d1 <= calc_elem_27_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[27]) == 1'b0) begin
  end else begin
    calc_op0_int_27_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[28]) == 1'b1) begin
    calc_op0_int_28_d1 <= calc_elem_28_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[28]) == 1'b0) begin
  end else begin
    calc_op0_int_28_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[29]) == 1'b1) begin
    calc_op0_int_29_d1 <= calc_elem_29_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[29]) == 1'b0) begin
  end else begin
    calc_op0_int_29_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[30]) == 1'b1) begin
    calc_op0_int_30_d1 <= calc_elem_30_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[30]) == 1'b0) begin
  end else begin
    calc_op0_int_30_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[31]) == 1'b1) begin
    calc_op0_int_31_d1 <= calc_elem_31_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[31]) == 1'b0) begin
  end else begin
    calc_op0_int_31_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[32]) == 1'b1) begin
    calc_op0_int_32_d1 <= calc_elem_32_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[32]) == 1'b0) begin
  end else begin
    calc_op0_int_32_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[33]) == 1'b1) begin
    calc_op0_int_33_d1 <= calc_elem_33_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[33]) == 1'b0) begin
  end else begin
    calc_op0_int_33_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[34]) == 1'b1) begin
    calc_op0_int_34_d1 <= calc_elem_34_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[34]) == 1'b0) begin
  end else begin
    calc_op0_int_34_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[35]) == 1'b1) begin
    calc_op0_int_35_d1 <= calc_elem_35_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[35]) == 1'b0) begin
  end else begin
    calc_op0_int_35_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[36]) == 1'b1) begin
    calc_op0_int_36_d1 <= calc_elem_36_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[36]) == 1'b0) begin
  end else begin
    calc_op0_int_36_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[37]) == 1'b1) begin
    calc_op0_int_37_d1 <= calc_elem_37_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[37]) == 1'b0) begin
  end else begin
    calc_op0_int_37_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[38]) == 1'b1) begin
    calc_op0_int_38_d1 <= calc_elem_38_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[38]) == 1'b0) begin
  end else begin
    calc_op0_int_38_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[39]) == 1'b1) begin
    calc_op0_int_39_d1 <= calc_elem_39_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[39]) == 1'b0) begin
  end else begin
    calc_op0_int_39_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[40]) == 1'b1) begin
    calc_op0_int_40_d1 <= calc_elem_40_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[40]) == 1'b0) begin
  end else begin
    calc_op0_int_40_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[41]) == 1'b1) begin
    calc_op0_int_41_d1 <= calc_elem_41_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[41]) == 1'b0) begin
  end else begin
    calc_op0_int_41_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[42]) == 1'b1) begin
    calc_op0_int_42_d1 <= calc_elem_42_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[42]) == 1'b0) begin
  end else begin
    calc_op0_int_42_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[43]) == 1'b1) begin
    calc_op0_int_43_d1 <= calc_elem_43_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[43]) == 1'b0) begin
  end else begin
    calc_op0_int_43_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[44]) == 1'b1) begin
    calc_op0_int_44_d1 <= calc_elem_44_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[44]) == 1'b0) begin
  end else begin
    calc_op0_int_44_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[45]) == 1'b1) begin
    calc_op0_int_45_d1 <= calc_elem_45_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[45]) == 1'b0) begin
  end else begin
    calc_op0_int_45_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[46]) == 1'b1) begin
    calc_op0_int_46_d1 <= calc_elem_46_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[46]) == 1'b0) begin
  end else begin
    calc_op0_int_46_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[47]) == 1'b1) begin
    calc_op0_int_47_d1 <= calc_elem_47_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[47]) == 1'b0) begin
  end else begin
    calc_op0_int_47_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[48]) == 1'b1) begin
    calc_op0_int_48_d1 <= calc_elem_48_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[48]) == 1'b0) begin
  end else begin
    calc_op0_int_48_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[49]) == 1'b1) begin
    calc_op0_int_49_d1 <= calc_elem_49_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[49]) == 1'b0) begin
  end else begin
    calc_op0_int_49_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[50]) == 1'b1) begin
    calc_op0_int_50_d1 <= calc_elem_50_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[50]) == 1'b0) begin
  end else begin
    calc_op0_int_50_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[51]) == 1'b1) begin
    calc_op0_int_51_d1 <= calc_elem_51_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[51]) == 1'b0) begin
  end else begin
    calc_op0_int_51_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[52]) == 1'b1) begin
    calc_op0_int_52_d1 <= calc_elem_52_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[52]) == 1'b0) begin
  end else begin
    calc_op0_int_52_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[53]) == 1'b1) begin
    calc_op0_int_53_d1 <= calc_elem_53_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[53]) == 1'b0) begin
  end else begin
    calc_op0_int_53_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[54]) == 1'b1) begin
    calc_op0_int_54_d1 <= calc_elem_54_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[54]) == 1'b0) begin
  end else begin
    calc_op0_int_54_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[55]) == 1'b1) begin
    calc_op0_int_55_d1 <= calc_elem_55_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[55]) == 1'b0) begin
  end else begin
    calc_op0_int_55_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[56]) == 1'b1) begin
    calc_op0_int_56_d1 <= calc_elem_56_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[56]) == 1'b0) begin
  end else begin
    calc_op0_int_56_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[57]) == 1'b1) begin
    calc_op0_int_57_d1 <= calc_elem_57_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[57]) == 1'b0) begin
  end else begin
    calc_op0_int_57_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[58]) == 1'b1) begin
    calc_op0_int_58_d1 <= calc_elem_58_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[58]) == 1'b0) begin
  end else begin
    calc_op0_int_58_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[59]) == 1'b1) begin
    calc_op0_int_59_d1 <= calc_elem_59_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[59]) == 1'b0) begin
  end else begin
    calc_op0_int_59_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[60]) == 1'b1) begin
    calc_op0_int_60_d1 <= calc_elem_60_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[60]) == 1'b0) begin
  end else begin
    calc_op0_int_60_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[61]) == 1'b1) begin
    calc_op0_int_61_d1 <= calc_elem_61_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[61]) == 1'b0) begin
  end else begin
    calc_op0_int_61_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[62]) == 1'b1) begin
    calc_op0_int_62_d1 <= calc_elem_62_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[62]) == 1'b0) begin
  end else begin
    calc_op0_int_62_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[63]) == 1'b1) begin
    calc_op0_int_63_d1 <= calc_elem_63_w[37:0];
  // VCS coverage off
  end else if ((calc_op_en_int[63]) == 1'b0) begin
  end else begin
    calc_op0_int_63_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end




always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[64]) == 1'b1) begin
    calc_op0_int_64_d1 <= calc_elem_64_w;
  // VCS coverage off
  end else if ((calc_op_en_int[64]) == 1'b0) begin
  end else begin
    calc_op0_int_64_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[65]) == 1'b1) begin
    calc_op0_int_65_d1 <= calc_elem_65_w;
  // VCS coverage off
  end else if ((calc_op_en_int[65]) == 1'b0) begin
  end else begin
    calc_op0_int_65_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[66]) == 1'b1) begin
    calc_op0_int_66_d1 <= calc_elem_66_w;
  // VCS coverage off
  end else if ((calc_op_en_int[66]) == 1'b0) begin
  end else begin
    calc_op0_int_66_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[67]) == 1'b1) begin
    calc_op0_int_67_d1 <= calc_elem_67_w;
  // VCS coverage off
  end else if ((calc_op_en_int[67]) == 1'b0) begin
  end else begin
    calc_op0_int_67_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[68]) == 1'b1) begin
    calc_op0_int_68_d1 <= calc_elem_68_w;
  // VCS coverage off
  end else if ((calc_op_en_int[68]) == 1'b0) begin
  end else begin
    calc_op0_int_68_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[69]) == 1'b1) begin
    calc_op0_int_69_d1 <= calc_elem_69_w;
  // VCS coverage off
  end else if ((calc_op_en_int[69]) == 1'b0) begin
  end else begin
    calc_op0_int_69_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[70]) == 1'b1) begin
    calc_op0_int_70_d1 <= calc_elem_70_w;
  // VCS coverage off
  end else if ((calc_op_en_int[70]) == 1'b0) begin
  end else begin
    calc_op0_int_70_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[71]) == 1'b1) begin
    calc_op0_int_71_d1 <= calc_elem_71_w;
  // VCS coverage off
  end else if ((calc_op_en_int[71]) == 1'b0) begin
  end else begin
    calc_op0_int_71_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[72]) == 1'b1) begin
    calc_op0_int_72_d1 <= calc_elem_72_w;
  // VCS coverage off
  end else if ((calc_op_en_int[72]) == 1'b0) begin
  end else begin
    calc_op0_int_72_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[73]) == 1'b1) begin
    calc_op0_int_73_d1 <= calc_elem_73_w;
  // VCS coverage off
  end else if ((calc_op_en_int[73]) == 1'b0) begin
  end else begin
    calc_op0_int_73_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[74]) == 1'b1) begin
    calc_op0_int_74_d1 <= calc_elem_74_w;
  // VCS coverage off
  end else if ((calc_op_en_int[74]) == 1'b0) begin
  end else begin
    calc_op0_int_74_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[75]) == 1'b1) begin
    calc_op0_int_75_d1 <= calc_elem_75_w;
  // VCS coverage off
  end else if ((calc_op_en_int[75]) == 1'b0) begin
  end else begin
    calc_op0_int_75_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[76]) == 1'b1) begin
    calc_op0_int_76_d1 <= calc_elem_76_w;
  // VCS coverage off
  end else if ((calc_op_en_int[76]) == 1'b0) begin
  end else begin
    calc_op0_int_76_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[77]) == 1'b1) begin
    calc_op0_int_77_d1 <= calc_elem_77_w;
  // VCS coverage off
  end else if ((calc_op_en_int[77]) == 1'b0) begin
  end else begin
    calc_op0_int_77_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[78]) == 1'b1) begin
    calc_op0_int_78_d1 <= calc_elem_78_w;
  // VCS coverage off
  end else if ((calc_op_en_int[78]) == 1'b0) begin
  end else begin
    calc_op0_int_78_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[79]) == 1'b1) begin
    calc_op0_int_79_d1 <= calc_elem_79_w;
  // VCS coverage off
  end else if ((calc_op_en_int[79]) == 1'b0) begin
  end else begin
    calc_op0_int_79_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[80]) == 1'b1) begin
    calc_op0_int_80_d1 <= calc_elem_80_w;
  // VCS coverage off
  end else if ((calc_op_en_int[80]) == 1'b0) begin
  end else begin
    calc_op0_int_80_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[81]) == 1'b1) begin
    calc_op0_int_81_d1 <= calc_elem_81_w;
  // VCS coverage off
  end else if ((calc_op_en_int[81]) == 1'b0) begin
  end else begin
    calc_op0_int_81_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[82]) == 1'b1) begin
    calc_op0_int_82_d1 <= calc_elem_82_w;
  // VCS coverage off
  end else if ((calc_op_en_int[82]) == 1'b0) begin
  end else begin
    calc_op0_int_82_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[83]) == 1'b1) begin
    calc_op0_int_83_d1 <= calc_elem_83_w;
  // VCS coverage off
  end else if ((calc_op_en_int[83]) == 1'b0) begin
  end else begin
    calc_op0_int_83_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[84]) == 1'b1) begin
    calc_op0_int_84_d1 <= calc_elem_84_w;
  // VCS coverage off
  end else if ((calc_op_en_int[84]) == 1'b0) begin
  end else begin
    calc_op0_int_84_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[85]) == 1'b1) begin
    calc_op0_int_85_d1 <= calc_elem_85_w;
  // VCS coverage off
  end else if ((calc_op_en_int[85]) == 1'b0) begin
  end else begin
    calc_op0_int_85_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[86]) == 1'b1) begin
    calc_op0_int_86_d1 <= calc_elem_86_w;
  // VCS coverage off
  end else if ((calc_op_en_int[86]) == 1'b0) begin
  end else begin
    calc_op0_int_86_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[87]) == 1'b1) begin
    calc_op0_int_87_d1 <= calc_elem_87_w;
  // VCS coverage off
  end else if ((calc_op_en_int[87]) == 1'b0) begin
  end else begin
    calc_op0_int_87_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[88]) == 1'b1) begin
    calc_op0_int_88_d1 <= calc_elem_88_w;
  // VCS coverage off
  end else if ((calc_op_en_int[88]) == 1'b0) begin
  end else begin
    calc_op0_int_88_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[89]) == 1'b1) begin
    calc_op0_int_89_d1 <= calc_elem_89_w;
  // VCS coverage off
  end else if ((calc_op_en_int[89]) == 1'b0) begin
  end else begin
    calc_op0_int_89_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[90]) == 1'b1) begin
    calc_op0_int_90_d1 <= calc_elem_90_w;
  // VCS coverage off
  end else if ((calc_op_en_int[90]) == 1'b0) begin
  end else begin
    calc_op0_int_90_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[91]) == 1'b1) begin
    calc_op0_int_91_d1 <= calc_elem_91_w;
  // VCS coverage off
  end else if ((calc_op_en_int[91]) == 1'b0) begin
  end else begin
    calc_op0_int_91_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[92]) == 1'b1) begin
    calc_op0_int_92_d1 <= calc_elem_92_w;
  // VCS coverage off
  end else if ((calc_op_en_int[92]) == 1'b0) begin
  end else begin
    calc_op0_int_92_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[93]) == 1'b1) begin
    calc_op0_int_93_d1 <= calc_elem_93_w;
  // VCS coverage off
  end else if ((calc_op_en_int[93]) == 1'b0) begin
  end else begin
    calc_op0_int_93_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[94]) == 1'b1) begin
    calc_op0_int_94_d1 <= calc_elem_94_w;
  // VCS coverage off
  end else if ((calc_op_en_int[94]) == 1'b0) begin
  end else begin
    calc_op0_int_94_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[95]) == 1'b1) begin
    calc_op0_int_95_d1 <= calc_elem_95_w;
  // VCS coverage off
  end else if ((calc_op_en_int[95]) == 1'b0) begin
  end else begin
    calc_op0_int_95_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[96]) == 1'b1) begin
    calc_op0_int_96_d1 <= calc_elem_96_w;
  // VCS coverage off
  end else if ((calc_op_en_int[96]) == 1'b0) begin
  end else begin
    calc_op0_int_96_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[97]) == 1'b1) begin
    calc_op0_int_97_d1 <= calc_elem_97_w;
  // VCS coverage off
  end else if ((calc_op_en_int[97]) == 1'b0) begin
  end else begin
    calc_op0_int_97_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[98]) == 1'b1) begin
    calc_op0_int_98_d1 <= calc_elem_98_w;
  // VCS coverage off
  end else if ((calc_op_en_int[98]) == 1'b0) begin
  end else begin
    calc_op0_int_98_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[99]) == 1'b1) begin
    calc_op0_int_99_d1 <= calc_elem_99_w;
  // VCS coverage off
  end else if ((calc_op_en_int[99]) == 1'b0) begin
  end else begin
    calc_op0_int_99_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[100]) == 1'b1) begin
    calc_op0_int_100_d1 <= calc_elem_100_w;
  // VCS coverage off
  end else if ((calc_op_en_int[100]) == 1'b0) begin
  end else begin
    calc_op0_int_100_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[101]) == 1'b1) begin
    calc_op0_int_101_d1 <= calc_elem_101_w;
  // VCS coverage off
  end else if ((calc_op_en_int[101]) == 1'b0) begin
  end else begin
    calc_op0_int_101_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[102]) == 1'b1) begin
    calc_op0_int_102_d1 <= calc_elem_102_w;
  // VCS coverage off
  end else if ((calc_op_en_int[102]) == 1'b0) begin
  end else begin
    calc_op0_int_102_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[103]) == 1'b1) begin
    calc_op0_int_103_d1 <= calc_elem_103_w;
  // VCS coverage off
  end else if ((calc_op_en_int[103]) == 1'b0) begin
  end else begin
    calc_op0_int_103_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[104]) == 1'b1) begin
    calc_op0_int_104_d1 <= calc_elem_104_w;
  // VCS coverage off
  end else if ((calc_op_en_int[104]) == 1'b0) begin
  end else begin
    calc_op0_int_104_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[105]) == 1'b1) begin
    calc_op0_int_105_d1 <= calc_elem_105_w;
  // VCS coverage off
  end else if ((calc_op_en_int[105]) == 1'b0) begin
  end else begin
    calc_op0_int_105_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[106]) == 1'b1) begin
    calc_op0_int_106_d1 <= calc_elem_106_w;
  // VCS coverage off
  end else if ((calc_op_en_int[106]) == 1'b0) begin
  end else begin
    calc_op0_int_106_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[107]) == 1'b1) begin
    calc_op0_int_107_d1 <= calc_elem_107_w;
  // VCS coverage off
  end else if ((calc_op_en_int[107]) == 1'b0) begin
  end else begin
    calc_op0_int_107_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[108]) == 1'b1) begin
    calc_op0_int_108_d1 <= calc_elem_108_w;
  // VCS coverage off
  end else if ((calc_op_en_int[108]) == 1'b0) begin
  end else begin
    calc_op0_int_108_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[109]) == 1'b1) begin
    calc_op0_int_109_d1 <= calc_elem_109_w;
  // VCS coverage off
  end else if ((calc_op_en_int[109]) == 1'b0) begin
  end else begin
    calc_op0_int_109_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[110]) == 1'b1) begin
    calc_op0_int_110_d1 <= calc_elem_110_w;
  // VCS coverage off
  end else if ((calc_op_en_int[110]) == 1'b0) begin
  end else begin
    calc_op0_int_110_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[111]) == 1'b1) begin
    calc_op0_int_111_d1 <= calc_elem_111_w;
  // VCS coverage off
  end else if ((calc_op_en_int[111]) == 1'b0) begin
  end else begin
    calc_op0_int_111_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[112]) == 1'b1) begin
    calc_op0_int_112_d1 <= calc_elem_112_w;
  // VCS coverage off
  end else if ((calc_op_en_int[112]) == 1'b0) begin
  end else begin
    calc_op0_int_112_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[113]) == 1'b1) begin
    calc_op0_int_113_d1 <= calc_elem_113_w;
  // VCS coverage off
  end else if ((calc_op_en_int[113]) == 1'b0) begin
  end else begin
    calc_op0_int_113_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[114]) == 1'b1) begin
    calc_op0_int_114_d1 <= calc_elem_114_w;
  // VCS coverage off
  end else if ((calc_op_en_int[114]) == 1'b0) begin
  end else begin
    calc_op0_int_114_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[115]) == 1'b1) begin
    calc_op0_int_115_d1 <= calc_elem_115_w;
  // VCS coverage off
  end else if ((calc_op_en_int[115]) == 1'b0) begin
  end else begin
    calc_op0_int_115_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[116]) == 1'b1) begin
    calc_op0_int_116_d1 <= calc_elem_116_w;
  // VCS coverage off
  end else if ((calc_op_en_int[116]) == 1'b0) begin
  end else begin
    calc_op0_int_116_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[117]) == 1'b1) begin
    calc_op0_int_117_d1 <= calc_elem_117_w;
  // VCS coverage off
  end else if ((calc_op_en_int[117]) == 1'b0) begin
  end else begin
    calc_op0_int_117_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[118]) == 1'b1) begin
    calc_op0_int_118_d1 <= calc_elem_118_w;
  // VCS coverage off
  end else if ((calc_op_en_int[118]) == 1'b0) begin
  end else begin
    calc_op0_int_118_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[119]) == 1'b1) begin
    calc_op0_int_119_d1 <= calc_elem_119_w;
  // VCS coverage off
  end else if ((calc_op_en_int[119]) == 1'b0) begin
  end else begin
    calc_op0_int_119_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[120]) == 1'b1) begin
    calc_op0_int_120_d1 <= calc_elem_120_w;
  // VCS coverage off
  end else if ((calc_op_en_int[120]) == 1'b0) begin
  end else begin
    calc_op0_int_120_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[121]) == 1'b1) begin
    calc_op0_int_121_d1 <= calc_elem_121_w;
  // VCS coverage off
  end else if ((calc_op_en_int[121]) == 1'b0) begin
  end else begin
    calc_op0_int_121_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[122]) == 1'b1) begin
    calc_op0_int_122_d1 <= calc_elem_122_w;
  // VCS coverage off
  end else if ((calc_op_en_int[122]) == 1'b0) begin
  end else begin
    calc_op0_int_122_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[123]) == 1'b1) begin
    calc_op0_int_123_d1 <= calc_elem_123_w;
  // VCS coverage off
  end else if ((calc_op_en_int[123]) == 1'b0) begin
  end else begin
    calc_op0_int_123_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[124]) == 1'b1) begin
    calc_op0_int_124_d1 <= calc_elem_124_w;
  // VCS coverage off
  end else if ((calc_op_en_int[124]) == 1'b0) begin
  end else begin
    calc_op0_int_124_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[125]) == 1'b1) begin
    calc_op0_int_125_d1 <= calc_elem_125_w;
  // VCS coverage off
  end else if ((calc_op_en_int[125]) == 1'b0) begin
  end else begin
    calc_op0_int_125_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[126]) == 1'b1) begin
    calc_op0_int_126_d1 <= calc_elem_126_w;
  // VCS coverage off
  end else if ((calc_op_en_int[126]) == 1'b0) begin
  end else begin
    calc_op0_int_126_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[127]) == 1'b1) begin
    calc_op0_int_127_d1 <= calc_elem_127_w;
  // VCS coverage off
  end else if ((calc_op_en_int[127]) == 1'b0) begin
  end else begin
    calc_op0_int_127_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end




always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[0]) == 1'b1) begin
    calc_op0_fp_0_d1 <= calc_elem_0_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[0]) == 1'b0) begin
  end else begin
    calc_op0_fp_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[1]) == 1'b1) begin
    calc_op0_fp_1_d1 <= calc_elem_1_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[1]) == 1'b0) begin
  end else begin
    calc_op0_fp_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[2]) == 1'b1) begin
    calc_op0_fp_2_d1 <= calc_elem_2_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[2]) == 1'b0) begin
  end else begin
    calc_op0_fp_2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[3]) == 1'b1) begin
    calc_op0_fp_3_d1 <= calc_elem_3_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[3]) == 1'b0) begin
  end else begin
    calc_op0_fp_3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[4]) == 1'b1) begin
    calc_op0_fp_4_d1 <= calc_elem_4_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[4]) == 1'b0) begin
  end else begin
    calc_op0_fp_4_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[5]) == 1'b1) begin
    calc_op0_fp_5_d1 <= calc_elem_5_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[5]) == 1'b0) begin
  end else begin
    calc_op0_fp_5_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[6]) == 1'b1) begin
    calc_op0_fp_6_d1 <= calc_elem_6_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[6]) == 1'b0) begin
  end else begin
    calc_op0_fp_6_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[7]) == 1'b1) begin
    calc_op0_fp_7_d1 <= calc_elem_7_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[7]) == 1'b0) begin
  end else begin
    calc_op0_fp_7_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[8]) == 1'b1) begin
    calc_op0_fp_8_d1 <= calc_elem_8_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[8]) == 1'b0) begin
  end else begin
    calc_op0_fp_8_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[9]) == 1'b1) begin
    calc_op0_fp_9_d1 <= calc_elem_9_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[9]) == 1'b0) begin
  end else begin
    calc_op0_fp_9_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[10]) == 1'b1) begin
    calc_op0_fp_10_d1 <= calc_elem_10_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[10]) == 1'b0) begin
  end else begin
    calc_op0_fp_10_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[11]) == 1'b1) begin
    calc_op0_fp_11_d1 <= calc_elem_11_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[11]) == 1'b0) begin
  end else begin
    calc_op0_fp_11_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[12]) == 1'b1) begin
    calc_op0_fp_12_d1 <= calc_elem_12_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[12]) == 1'b0) begin
  end else begin
    calc_op0_fp_12_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[13]) == 1'b1) begin
    calc_op0_fp_13_d1 <= calc_elem_13_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[13]) == 1'b0) begin
  end else begin
    calc_op0_fp_13_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[14]) == 1'b1) begin
    calc_op0_fp_14_d1 <= calc_elem_14_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[14]) == 1'b0) begin
  end else begin
    calc_op0_fp_14_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[15]) == 1'b1) begin
    calc_op0_fp_15_d1 <= calc_elem_15_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[15]) == 1'b0) begin
  end else begin
    calc_op0_fp_15_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[16]) == 1'b1) begin
    calc_op0_fp_16_d1 <= calc_elem_16_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[16]) == 1'b0) begin
  end else begin
    calc_op0_fp_16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[17]) == 1'b1) begin
    calc_op0_fp_17_d1 <= calc_elem_17_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[17]) == 1'b0) begin
  end else begin
    calc_op0_fp_17_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[18]) == 1'b1) begin
    calc_op0_fp_18_d1 <= calc_elem_18_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[18]) == 1'b0) begin
  end else begin
    calc_op0_fp_18_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[19]) == 1'b1) begin
    calc_op0_fp_19_d1 <= calc_elem_19_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[19]) == 1'b0) begin
  end else begin
    calc_op0_fp_19_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[20]) == 1'b1) begin
    calc_op0_fp_20_d1 <= calc_elem_20_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[20]) == 1'b0) begin
  end else begin
    calc_op0_fp_20_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[21]) == 1'b1) begin
    calc_op0_fp_21_d1 <= calc_elem_21_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[21]) == 1'b0) begin
  end else begin
    calc_op0_fp_21_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[22]) == 1'b1) begin
    calc_op0_fp_22_d1 <= calc_elem_22_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[22]) == 1'b0) begin
  end else begin
    calc_op0_fp_22_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[23]) == 1'b1) begin
    calc_op0_fp_23_d1 <= calc_elem_23_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[23]) == 1'b0) begin
  end else begin
    calc_op0_fp_23_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[24]) == 1'b1) begin
    calc_op0_fp_24_d1 <= calc_elem_24_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[24]) == 1'b0) begin
  end else begin
    calc_op0_fp_24_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[25]) == 1'b1) begin
    calc_op0_fp_25_d1 <= calc_elem_25_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[25]) == 1'b0) begin
  end else begin
    calc_op0_fp_25_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[26]) == 1'b1) begin
    calc_op0_fp_26_d1 <= calc_elem_26_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[26]) == 1'b0) begin
  end else begin
    calc_op0_fp_26_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[27]) == 1'b1) begin
    calc_op0_fp_27_d1 <= calc_elem_27_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[27]) == 1'b0) begin
  end else begin
    calc_op0_fp_27_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[28]) == 1'b1) begin
    calc_op0_fp_28_d1 <= calc_elem_28_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[28]) == 1'b0) begin
  end else begin
    calc_op0_fp_28_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[29]) == 1'b1) begin
    calc_op0_fp_29_d1 <= calc_elem_29_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[29]) == 1'b0) begin
  end else begin
    calc_op0_fp_29_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[30]) == 1'b1) begin
    calc_op0_fp_30_d1 <= calc_elem_30_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[30]) == 1'b0) begin
  end else begin
    calc_op0_fp_30_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[31]) == 1'b1) begin
    calc_op0_fp_31_d1 <= calc_elem_31_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[31]) == 1'b0) begin
  end else begin
    calc_op0_fp_31_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[32]) == 1'b1) begin
    calc_op0_fp_32_d1 <= calc_elem_32_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[32]) == 1'b0) begin
  end else begin
    calc_op0_fp_32_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[33]) == 1'b1) begin
    calc_op0_fp_33_d1 <= calc_elem_33_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[33]) == 1'b0) begin
  end else begin
    calc_op0_fp_33_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[34]) == 1'b1) begin
    calc_op0_fp_34_d1 <= calc_elem_34_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[34]) == 1'b0) begin
  end else begin
    calc_op0_fp_34_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[35]) == 1'b1) begin
    calc_op0_fp_35_d1 <= calc_elem_35_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[35]) == 1'b0) begin
  end else begin
    calc_op0_fp_35_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[36]) == 1'b1) begin
    calc_op0_fp_36_d1 <= calc_elem_36_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[36]) == 1'b0) begin
  end else begin
    calc_op0_fp_36_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[37]) == 1'b1) begin
    calc_op0_fp_37_d1 <= calc_elem_37_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[37]) == 1'b0) begin
  end else begin
    calc_op0_fp_37_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[38]) == 1'b1) begin
    calc_op0_fp_38_d1 <= calc_elem_38_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[38]) == 1'b0) begin
  end else begin
    calc_op0_fp_38_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[39]) == 1'b1) begin
    calc_op0_fp_39_d1 <= calc_elem_39_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[39]) == 1'b0) begin
  end else begin
    calc_op0_fp_39_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[40]) == 1'b1) begin
    calc_op0_fp_40_d1 <= calc_elem_40_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[40]) == 1'b0) begin
  end else begin
    calc_op0_fp_40_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[41]) == 1'b1) begin
    calc_op0_fp_41_d1 <= calc_elem_41_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[41]) == 1'b0) begin
  end else begin
    calc_op0_fp_41_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[42]) == 1'b1) begin
    calc_op0_fp_42_d1 <= calc_elem_42_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[42]) == 1'b0) begin
  end else begin
    calc_op0_fp_42_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[43]) == 1'b1) begin
    calc_op0_fp_43_d1 <= calc_elem_43_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[43]) == 1'b0) begin
  end else begin
    calc_op0_fp_43_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[44]) == 1'b1) begin
    calc_op0_fp_44_d1 <= calc_elem_44_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[44]) == 1'b0) begin
  end else begin
    calc_op0_fp_44_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[45]) == 1'b1) begin
    calc_op0_fp_45_d1 <= calc_elem_45_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[45]) == 1'b0) begin
  end else begin
    calc_op0_fp_45_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[46]) == 1'b1) begin
    calc_op0_fp_46_d1 <= calc_elem_46_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[46]) == 1'b0) begin
  end else begin
    calc_op0_fp_46_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[47]) == 1'b1) begin
    calc_op0_fp_47_d1 <= calc_elem_47_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[47]) == 1'b0) begin
  end else begin
    calc_op0_fp_47_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[48]) == 1'b1) begin
    calc_op0_fp_48_d1 <= calc_elem_48_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[48]) == 1'b0) begin
  end else begin
    calc_op0_fp_48_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[49]) == 1'b1) begin
    calc_op0_fp_49_d1 <= calc_elem_49_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[49]) == 1'b0) begin
  end else begin
    calc_op0_fp_49_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[50]) == 1'b1) begin
    calc_op0_fp_50_d1 <= calc_elem_50_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[50]) == 1'b0) begin
  end else begin
    calc_op0_fp_50_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[51]) == 1'b1) begin
    calc_op0_fp_51_d1 <= calc_elem_51_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[51]) == 1'b0) begin
  end else begin
    calc_op0_fp_51_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[52]) == 1'b1) begin
    calc_op0_fp_52_d1 <= calc_elem_52_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[52]) == 1'b0) begin
  end else begin
    calc_op0_fp_52_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[53]) == 1'b1) begin
    calc_op0_fp_53_d1 <= calc_elem_53_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[53]) == 1'b0) begin
  end else begin
    calc_op0_fp_53_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[54]) == 1'b1) begin
    calc_op0_fp_54_d1 <= calc_elem_54_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[54]) == 1'b0) begin
  end else begin
    calc_op0_fp_54_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[55]) == 1'b1) begin
    calc_op0_fp_55_d1 <= calc_elem_55_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[55]) == 1'b0) begin
  end else begin
    calc_op0_fp_55_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[56]) == 1'b1) begin
    calc_op0_fp_56_d1 <= calc_elem_56_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[56]) == 1'b0) begin
  end else begin
    calc_op0_fp_56_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[57]) == 1'b1) begin
    calc_op0_fp_57_d1 <= calc_elem_57_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[57]) == 1'b0) begin
  end else begin
    calc_op0_fp_57_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[58]) == 1'b1) begin
    calc_op0_fp_58_d1 <= calc_elem_58_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[58]) == 1'b0) begin
  end else begin
    calc_op0_fp_58_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[59]) == 1'b1) begin
    calc_op0_fp_59_d1 <= calc_elem_59_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[59]) == 1'b0) begin
  end else begin
    calc_op0_fp_59_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[60]) == 1'b1) begin
    calc_op0_fp_60_d1 <= calc_elem_60_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[60]) == 1'b0) begin
  end else begin
    calc_op0_fp_60_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[61]) == 1'b1) begin
    calc_op0_fp_61_d1 <= calc_elem_61_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[61]) == 1'b0) begin
  end else begin
    calc_op0_fp_61_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[62]) == 1'b1) begin
    calc_op0_fp_62_d1 <= calc_elem_62_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[62]) == 1'b0) begin
  end else begin
    calc_op0_fp_62_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[63]) == 1'b1) begin
    calc_op0_fp_63_d1 <= calc_elem_63_w;
  // VCS coverage off
  end else if ((calc_op_en_fp[63]) == 1'b0) begin
  end else begin
    calc_op0_fp_63_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end




always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[0]) == 1'b1) begin
    calc_op1_int_0_d1 <= abuf_in_data_0;
  // VCS coverage off
  end else if ((calc_op_en_int[0]) == 1'b0) begin
  end else begin
    calc_op1_int_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[1]) == 1'b1) begin
    calc_op1_int_1_d1 <= abuf_in_data_1;
  // VCS coverage off
  end else if ((calc_op_en_int[1]) == 1'b0) begin
  end else begin
    calc_op1_int_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[2]) == 1'b1) begin
    calc_op1_int_2_d1 <= abuf_in_data_2;
  // VCS coverage off
  end else if ((calc_op_en_int[2]) == 1'b0) begin
  end else begin
    calc_op1_int_2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[3]) == 1'b1) begin
    calc_op1_int_3_d1 <= abuf_in_data_3;
  // VCS coverage off
  end else if ((calc_op_en_int[3]) == 1'b0) begin
  end else begin
    calc_op1_int_3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[4]) == 1'b1) begin
    calc_op1_int_4_d1 <= abuf_in_data_4;
  // VCS coverage off
  end else if ((calc_op_en_int[4]) == 1'b0) begin
  end else begin
    calc_op1_int_4_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[5]) == 1'b1) begin
    calc_op1_int_5_d1 <= abuf_in_data_5;
  // VCS coverage off
  end else if ((calc_op_en_int[5]) == 1'b0) begin
  end else begin
    calc_op1_int_5_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[6]) == 1'b1) begin
    calc_op1_int_6_d1 <= abuf_in_data_6;
  // VCS coverage off
  end else if ((calc_op_en_int[6]) == 1'b0) begin
  end else begin
    calc_op1_int_6_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[7]) == 1'b1) begin
    calc_op1_int_7_d1 <= abuf_in_data_7;
  // VCS coverage off
  end else if ((calc_op_en_int[7]) == 1'b0) begin
  end else begin
    calc_op1_int_7_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[8]) == 1'b1) begin
    calc_op1_int_8_d1 <= abuf_in_data_8;
  // VCS coverage off
  end else if ((calc_op_en_int[8]) == 1'b0) begin
  end else begin
    calc_op1_int_8_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[9]) == 1'b1) begin
    calc_op1_int_9_d1 <= abuf_in_data_9;
  // VCS coverage off
  end else if ((calc_op_en_int[9]) == 1'b0) begin
  end else begin
    calc_op1_int_9_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[10]) == 1'b1) begin
    calc_op1_int_10_d1 <= abuf_in_data_10;
  // VCS coverage off
  end else if ((calc_op_en_int[10]) == 1'b0) begin
  end else begin
    calc_op1_int_10_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[11]) == 1'b1) begin
    calc_op1_int_11_d1 <= abuf_in_data_11;
  // VCS coverage off
  end else if ((calc_op_en_int[11]) == 1'b0) begin
  end else begin
    calc_op1_int_11_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[12]) == 1'b1) begin
    calc_op1_int_12_d1 <= abuf_in_data_12;
  // VCS coverage off
  end else if ((calc_op_en_int[12]) == 1'b0) begin
  end else begin
    calc_op1_int_12_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[13]) == 1'b1) begin
    calc_op1_int_13_d1 <= abuf_in_data_13;
  // VCS coverage off
  end else if ((calc_op_en_int[13]) == 1'b0) begin
  end else begin
    calc_op1_int_13_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[14]) == 1'b1) begin
    calc_op1_int_14_d1 <= abuf_in_data_14;
  // VCS coverage off
  end else if ((calc_op_en_int[14]) == 1'b0) begin
  end else begin
    calc_op1_int_14_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[15]) == 1'b1) begin
    calc_op1_int_15_d1 <= abuf_in_data_15;
  // VCS coverage off
  end else if ((calc_op_en_int[15]) == 1'b0) begin
  end else begin
    calc_op1_int_15_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[16]) == 1'b1) begin
    calc_op1_int_16_d1 <= abuf_in_data_16;
  // VCS coverage off
  end else if ((calc_op_en_int[16]) == 1'b0) begin
  end else begin
    calc_op1_int_16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[17]) == 1'b1) begin
    calc_op1_int_17_d1 <= abuf_in_data_17;
  // VCS coverage off
  end else if ((calc_op_en_int[17]) == 1'b0) begin
  end else begin
    calc_op1_int_17_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[18]) == 1'b1) begin
    calc_op1_int_18_d1 <= abuf_in_data_18;
  // VCS coverage off
  end else if ((calc_op_en_int[18]) == 1'b0) begin
  end else begin
    calc_op1_int_18_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[19]) == 1'b1) begin
    calc_op1_int_19_d1 <= abuf_in_data_19;
  // VCS coverage off
  end else if ((calc_op_en_int[19]) == 1'b0) begin
  end else begin
    calc_op1_int_19_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[20]) == 1'b1) begin
    calc_op1_int_20_d1 <= abuf_in_data_20;
  // VCS coverage off
  end else if ((calc_op_en_int[20]) == 1'b0) begin
  end else begin
    calc_op1_int_20_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[21]) == 1'b1) begin
    calc_op1_int_21_d1 <= abuf_in_data_21;
  // VCS coverage off
  end else if ((calc_op_en_int[21]) == 1'b0) begin
  end else begin
    calc_op1_int_21_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[22]) == 1'b1) begin
    calc_op1_int_22_d1 <= abuf_in_data_22;
  // VCS coverage off
  end else if ((calc_op_en_int[22]) == 1'b0) begin
  end else begin
    calc_op1_int_22_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[23]) == 1'b1) begin
    calc_op1_int_23_d1 <= abuf_in_data_23;
  // VCS coverage off
  end else if ((calc_op_en_int[23]) == 1'b0) begin
  end else begin
    calc_op1_int_23_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[24]) == 1'b1) begin
    calc_op1_int_24_d1 <= abuf_in_data_24;
  // VCS coverage off
  end else if ((calc_op_en_int[24]) == 1'b0) begin
  end else begin
    calc_op1_int_24_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[25]) == 1'b1) begin
    calc_op1_int_25_d1 <= abuf_in_data_25;
  // VCS coverage off
  end else if ((calc_op_en_int[25]) == 1'b0) begin
  end else begin
    calc_op1_int_25_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[26]) == 1'b1) begin
    calc_op1_int_26_d1 <= abuf_in_data_26;
  // VCS coverage off
  end else if ((calc_op_en_int[26]) == 1'b0) begin
  end else begin
    calc_op1_int_26_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[27]) == 1'b1) begin
    calc_op1_int_27_d1 <= abuf_in_data_27;
  // VCS coverage off
  end else if ((calc_op_en_int[27]) == 1'b0) begin
  end else begin
    calc_op1_int_27_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[28]) == 1'b1) begin
    calc_op1_int_28_d1 <= abuf_in_data_28;
  // VCS coverage off
  end else if ((calc_op_en_int[28]) == 1'b0) begin
  end else begin
    calc_op1_int_28_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[29]) == 1'b1) begin
    calc_op1_int_29_d1 <= abuf_in_data_29;
  // VCS coverage off
  end else if ((calc_op_en_int[29]) == 1'b0) begin
  end else begin
    calc_op1_int_29_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[30]) == 1'b1) begin
    calc_op1_int_30_d1 <= abuf_in_data_30;
  // VCS coverage off
  end else if ((calc_op_en_int[30]) == 1'b0) begin
  end else begin
    calc_op1_int_30_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[31]) == 1'b1) begin
    calc_op1_int_31_d1 <= abuf_in_data_31;
  // VCS coverage off
  end else if ((calc_op_en_int[31]) == 1'b0) begin
  end else begin
    calc_op1_int_31_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[32]) == 1'b1) begin
    calc_op1_int_32_d1 <= abuf_in_data_32;
  // VCS coverage off
  end else if ((calc_op_en_int[32]) == 1'b0) begin
  end else begin
    calc_op1_int_32_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[33]) == 1'b1) begin
    calc_op1_int_33_d1 <= abuf_in_data_33;
  // VCS coverage off
  end else if ((calc_op_en_int[33]) == 1'b0) begin
  end else begin
    calc_op1_int_33_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[34]) == 1'b1) begin
    calc_op1_int_34_d1 <= abuf_in_data_34;
  // VCS coverage off
  end else if ((calc_op_en_int[34]) == 1'b0) begin
  end else begin
    calc_op1_int_34_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[35]) == 1'b1) begin
    calc_op1_int_35_d1 <= abuf_in_data_35;
  // VCS coverage off
  end else if ((calc_op_en_int[35]) == 1'b0) begin
  end else begin
    calc_op1_int_35_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[36]) == 1'b1) begin
    calc_op1_int_36_d1 <= abuf_in_data_36;
  // VCS coverage off
  end else if ((calc_op_en_int[36]) == 1'b0) begin
  end else begin
    calc_op1_int_36_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[37]) == 1'b1) begin
    calc_op1_int_37_d1 <= abuf_in_data_37;
  // VCS coverage off
  end else if ((calc_op_en_int[37]) == 1'b0) begin
  end else begin
    calc_op1_int_37_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[38]) == 1'b1) begin
    calc_op1_int_38_d1 <= abuf_in_data_38;
  // VCS coverage off
  end else if ((calc_op_en_int[38]) == 1'b0) begin
  end else begin
    calc_op1_int_38_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[39]) == 1'b1) begin
    calc_op1_int_39_d1 <= abuf_in_data_39;
  // VCS coverage off
  end else if ((calc_op_en_int[39]) == 1'b0) begin
  end else begin
    calc_op1_int_39_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[40]) == 1'b1) begin
    calc_op1_int_40_d1 <= abuf_in_data_40;
  // VCS coverage off
  end else if ((calc_op_en_int[40]) == 1'b0) begin
  end else begin
    calc_op1_int_40_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[41]) == 1'b1) begin
    calc_op1_int_41_d1 <= abuf_in_data_41;
  // VCS coverage off
  end else if ((calc_op_en_int[41]) == 1'b0) begin
  end else begin
    calc_op1_int_41_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[42]) == 1'b1) begin
    calc_op1_int_42_d1 <= abuf_in_data_42;
  // VCS coverage off
  end else if ((calc_op_en_int[42]) == 1'b0) begin
  end else begin
    calc_op1_int_42_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[43]) == 1'b1) begin
    calc_op1_int_43_d1 <= abuf_in_data_43;
  // VCS coverage off
  end else if ((calc_op_en_int[43]) == 1'b0) begin
  end else begin
    calc_op1_int_43_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[44]) == 1'b1) begin
    calc_op1_int_44_d1 <= abuf_in_data_44;
  // VCS coverage off
  end else if ((calc_op_en_int[44]) == 1'b0) begin
  end else begin
    calc_op1_int_44_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[45]) == 1'b1) begin
    calc_op1_int_45_d1 <= abuf_in_data_45;
  // VCS coverage off
  end else if ((calc_op_en_int[45]) == 1'b0) begin
  end else begin
    calc_op1_int_45_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[46]) == 1'b1) begin
    calc_op1_int_46_d1 <= abuf_in_data_46;
  // VCS coverage off
  end else if ((calc_op_en_int[46]) == 1'b0) begin
  end else begin
    calc_op1_int_46_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[47]) == 1'b1) begin
    calc_op1_int_47_d1 <= abuf_in_data_47;
  // VCS coverage off
  end else if ((calc_op_en_int[47]) == 1'b0) begin
  end else begin
    calc_op1_int_47_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[48]) == 1'b1) begin
    calc_op1_int_48_d1 <= abuf_in_data_48;
  // VCS coverage off
  end else if ((calc_op_en_int[48]) == 1'b0) begin
  end else begin
    calc_op1_int_48_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[49]) == 1'b1) begin
    calc_op1_int_49_d1 <= abuf_in_data_49;
  // VCS coverage off
  end else if ((calc_op_en_int[49]) == 1'b0) begin
  end else begin
    calc_op1_int_49_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[50]) == 1'b1) begin
    calc_op1_int_50_d1 <= abuf_in_data_50;
  // VCS coverage off
  end else if ((calc_op_en_int[50]) == 1'b0) begin
  end else begin
    calc_op1_int_50_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[51]) == 1'b1) begin
    calc_op1_int_51_d1 <= abuf_in_data_51;
  // VCS coverage off
  end else if ((calc_op_en_int[51]) == 1'b0) begin
  end else begin
    calc_op1_int_51_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[52]) == 1'b1) begin
    calc_op1_int_52_d1 <= abuf_in_data_52;
  // VCS coverage off
  end else if ((calc_op_en_int[52]) == 1'b0) begin
  end else begin
    calc_op1_int_52_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[53]) == 1'b1) begin
    calc_op1_int_53_d1 <= abuf_in_data_53;
  // VCS coverage off
  end else if ((calc_op_en_int[53]) == 1'b0) begin
  end else begin
    calc_op1_int_53_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[54]) == 1'b1) begin
    calc_op1_int_54_d1 <= abuf_in_data_54;
  // VCS coverage off
  end else if ((calc_op_en_int[54]) == 1'b0) begin
  end else begin
    calc_op1_int_54_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[55]) == 1'b1) begin
    calc_op1_int_55_d1 <= abuf_in_data_55;
  // VCS coverage off
  end else if ((calc_op_en_int[55]) == 1'b0) begin
  end else begin
    calc_op1_int_55_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[56]) == 1'b1) begin
    calc_op1_int_56_d1 <= abuf_in_data_56;
  // VCS coverage off
  end else if ((calc_op_en_int[56]) == 1'b0) begin
  end else begin
    calc_op1_int_56_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[57]) == 1'b1) begin
    calc_op1_int_57_d1 <= abuf_in_data_57;
  // VCS coverage off
  end else if ((calc_op_en_int[57]) == 1'b0) begin
  end else begin
    calc_op1_int_57_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[58]) == 1'b1) begin
    calc_op1_int_58_d1 <= abuf_in_data_58;
  // VCS coverage off
  end else if ((calc_op_en_int[58]) == 1'b0) begin
  end else begin
    calc_op1_int_58_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[59]) == 1'b1) begin
    calc_op1_int_59_d1 <= abuf_in_data_59;
  // VCS coverage off
  end else if ((calc_op_en_int[59]) == 1'b0) begin
  end else begin
    calc_op1_int_59_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[60]) == 1'b1) begin
    calc_op1_int_60_d1 <= abuf_in_data_60;
  // VCS coverage off
  end else if ((calc_op_en_int[60]) == 1'b0) begin
  end else begin
    calc_op1_int_60_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[61]) == 1'b1) begin
    calc_op1_int_61_d1 <= abuf_in_data_61;
  // VCS coverage off
  end else if ((calc_op_en_int[61]) == 1'b0) begin
  end else begin
    calc_op1_int_61_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[62]) == 1'b1) begin
    calc_op1_int_62_d1 <= abuf_in_data_62;
  // VCS coverage off
  end else if ((calc_op_en_int[62]) == 1'b0) begin
  end else begin
    calc_op1_int_62_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[63]) == 1'b1) begin
    calc_op1_int_63_d1 <= abuf_in_data_63;
  // VCS coverage off
  end else if ((calc_op_en_int[63]) == 1'b0) begin
  end else begin
    calc_op1_int_63_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end




always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[64]) == 1'b1) begin
    calc_op1_int_64_d1 <= abuf_in_data_64;
  // VCS coverage off
  end else if ((calc_op_en_int[64]) == 1'b0) begin
  end else begin
    calc_op1_int_64_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[65]) == 1'b1) begin
    calc_op1_int_65_d1 <= abuf_in_data_65;
  // VCS coverage off
  end else if ((calc_op_en_int[65]) == 1'b0) begin
  end else begin
    calc_op1_int_65_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[66]) == 1'b1) begin
    calc_op1_int_66_d1 <= abuf_in_data_66;
  // VCS coverage off
  end else if ((calc_op_en_int[66]) == 1'b0) begin
  end else begin
    calc_op1_int_66_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[67]) == 1'b1) begin
    calc_op1_int_67_d1 <= abuf_in_data_67;
  // VCS coverage off
  end else if ((calc_op_en_int[67]) == 1'b0) begin
  end else begin
    calc_op1_int_67_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[68]) == 1'b1) begin
    calc_op1_int_68_d1 <= abuf_in_data_68;
  // VCS coverage off
  end else if ((calc_op_en_int[68]) == 1'b0) begin
  end else begin
    calc_op1_int_68_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[69]) == 1'b1) begin
    calc_op1_int_69_d1 <= abuf_in_data_69;
  // VCS coverage off
  end else if ((calc_op_en_int[69]) == 1'b0) begin
  end else begin
    calc_op1_int_69_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[70]) == 1'b1) begin
    calc_op1_int_70_d1 <= abuf_in_data_70;
  // VCS coverage off
  end else if ((calc_op_en_int[70]) == 1'b0) begin
  end else begin
    calc_op1_int_70_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[71]) == 1'b1) begin
    calc_op1_int_71_d1 <= abuf_in_data_71;
  // VCS coverage off
  end else if ((calc_op_en_int[71]) == 1'b0) begin
  end else begin
    calc_op1_int_71_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[72]) == 1'b1) begin
    calc_op1_int_72_d1 <= abuf_in_data_72;
  // VCS coverage off
  end else if ((calc_op_en_int[72]) == 1'b0) begin
  end else begin
    calc_op1_int_72_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[73]) == 1'b1) begin
    calc_op1_int_73_d1 <= abuf_in_data_73;
  // VCS coverage off
  end else if ((calc_op_en_int[73]) == 1'b0) begin
  end else begin
    calc_op1_int_73_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[74]) == 1'b1) begin
    calc_op1_int_74_d1 <= abuf_in_data_74;
  // VCS coverage off
  end else if ((calc_op_en_int[74]) == 1'b0) begin
  end else begin
    calc_op1_int_74_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[75]) == 1'b1) begin
    calc_op1_int_75_d1 <= abuf_in_data_75;
  // VCS coverage off
  end else if ((calc_op_en_int[75]) == 1'b0) begin
  end else begin
    calc_op1_int_75_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[76]) == 1'b1) begin
    calc_op1_int_76_d1 <= abuf_in_data_76;
  // VCS coverage off
  end else if ((calc_op_en_int[76]) == 1'b0) begin
  end else begin
    calc_op1_int_76_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[77]) == 1'b1) begin
    calc_op1_int_77_d1 <= abuf_in_data_77;
  // VCS coverage off
  end else if ((calc_op_en_int[77]) == 1'b0) begin
  end else begin
    calc_op1_int_77_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[78]) == 1'b1) begin
    calc_op1_int_78_d1 <= abuf_in_data_78;
  // VCS coverage off
  end else if ((calc_op_en_int[78]) == 1'b0) begin
  end else begin
    calc_op1_int_78_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[79]) == 1'b1) begin
    calc_op1_int_79_d1 <= abuf_in_data_79;
  // VCS coverage off
  end else if ((calc_op_en_int[79]) == 1'b0) begin
  end else begin
    calc_op1_int_79_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[80]) == 1'b1) begin
    calc_op1_int_80_d1 <= abuf_in_data_80;
  // VCS coverage off
  end else if ((calc_op_en_int[80]) == 1'b0) begin
  end else begin
    calc_op1_int_80_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[81]) == 1'b1) begin
    calc_op1_int_81_d1 <= abuf_in_data_81;
  // VCS coverage off
  end else if ((calc_op_en_int[81]) == 1'b0) begin
  end else begin
    calc_op1_int_81_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[82]) == 1'b1) begin
    calc_op1_int_82_d1 <= abuf_in_data_82;
  // VCS coverage off
  end else if ((calc_op_en_int[82]) == 1'b0) begin
  end else begin
    calc_op1_int_82_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[83]) == 1'b1) begin
    calc_op1_int_83_d1 <= abuf_in_data_83;
  // VCS coverage off
  end else if ((calc_op_en_int[83]) == 1'b0) begin
  end else begin
    calc_op1_int_83_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[84]) == 1'b1) begin
    calc_op1_int_84_d1 <= abuf_in_data_84;
  // VCS coverage off
  end else if ((calc_op_en_int[84]) == 1'b0) begin
  end else begin
    calc_op1_int_84_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[85]) == 1'b1) begin
    calc_op1_int_85_d1 <= abuf_in_data_85;
  // VCS coverage off
  end else if ((calc_op_en_int[85]) == 1'b0) begin
  end else begin
    calc_op1_int_85_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[86]) == 1'b1) begin
    calc_op1_int_86_d1 <= abuf_in_data_86;
  // VCS coverage off
  end else if ((calc_op_en_int[86]) == 1'b0) begin
  end else begin
    calc_op1_int_86_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[87]) == 1'b1) begin
    calc_op1_int_87_d1 <= abuf_in_data_87;
  // VCS coverage off
  end else if ((calc_op_en_int[87]) == 1'b0) begin
  end else begin
    calc_op1_int_87_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[88]) == 1'b1) begin
    calc_op1_int_88_d1 <= abuf_in_data_88;
  // VCS coverage off
  end else if ((calc_op_en_int[88]) == 1'b0) begin
  end else begin
    calc_op1_int_88_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[89]) == 1'b1) begin
    calc_op1_int_89_d1 <= abuf_in_data_89;
  // VCS coverage off
  end else if ((calc_op_en_int[89]) == 1'b0) begin
  end else begin
    calc_op1_int_89_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[90]) == 1'b1) begin
    calc_op1_int_90_d1 <= abuf_in_data_90;
  // VCS coverage off
  end else if ((calc_op_en_int[90]) == 1'b0) begin
  end else begin
    calc_op1_int_90_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[91]) == 1'b1) begin
    calc_op1_int_91_d1 <= abuf_in_data_91;
  // VCS coverage off
  end else if ((calc_op_en_int[91]) == 1'b0) begin
  end else begin
    calc_op1_int_91_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[92]) == 1'b1) begin
    calc_op1_int_92_d1 <= abuf_in_data_92;
  // VCS coverage off
  end else if ((calc_op_en_int[92]) == 1'b0) begin
  end else begin
    calc_op1_int_92_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[93]) == 1'b1) begin
    calc_op1_int_93_d1 <= abuf_in_data_93;
  // VCS coverage off
  end else if ((calc_op_en_int[93]) == 1'b0) begin
  end else begin
    calc_op1_int_93_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[94]) == 1'b1) begin
    calc_op1_int_94_d1 <= abuf_in_data_94;
  // VCS coverage off
  end else if ((calc_op_en_int[94]) == 1'b0) begin
  end else begin
    calc_op1_int_94_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[95]) == 1'b1) begin
    calc_op1_int_95_d1 <= abuf_in_data_95;
  // VCS coverage off
  end else if ((calc_op_en_int[95]) == 1'b0) begin
  end else begin
    calc_op1_int_95_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[96]) == 1'b1) begin
    calc_op1_int_96_d1 <= abuf_in_data_96;
  // VCS coverage off
  end else if ((calc_op_en_int[96]) == 1'b0) begin
  end else begin
    calc_op1_int_96_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[97]) == 1'b1) begin
    calc_op1_int_97_d1 <= abuf_in_data_97;
  // VCS coverage off
  end else if ((calc_op_en_int[97]) == 1'b0) begin
  end else begin
    calc_op1_int_97_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[98]) == 1'b1) begin
    calc_op1_int_98_d1 <= abuf_in_data_98;
  // VCS coverage off
  end else if ((calc_op_en_int[98]) == 1'b0) begin
  end else begin
    calc_op1_int_98_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[99]) == 1'b1) begin
    calc_op1_int_99_d1 <= abuf_in_data_99;
  // VCS coverage off
  end else if ((calc_op_en_int[99]) == 1'b0) begin
  end else begin
    calc_op1_int_99_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[100]) == 1'b1) begin
    calc_op1_int_100_d1 <= abuf_in_data_100;
  // VCS coverage off
  end else if ((calc_op_en_int[100]) == 1'b0) begin
  end else begin
    calc_op1_int_100_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[101]) == 1'b1) begin
    calc_op1_int_101_d1 <= abuf_in_data_101;
  // VCS coverage off
  end else if ((calc_op_en_int[101]) == 1'b0) begin
  end else begin
    calc_op1_int_101_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[102]) == 1'b1) begin
    calc_op1_int_102_d1 <= abuf_in_data_102;
  // VCS coverage off
  end else if ((calc_op_en_int[102]) == 1'b0) begin
  end else begin
    calc_op1_int_102_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[103]) == 1'b1) begin
    calc_op1_int_103_d1 <= abuf_in_data_103;
  // VCS coverage off
  end else if ((calc_op_en_int[103]) == 1'b0) begin
  end else begin
    calc_op1_int_103_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[104]) == 1'b1) begin
    calc_op1_int_104_d1 <= abuf_in_data_104;
  // VCS coverage off
  end else if ((calc_op_en_int[104]) == 1'b0) begin
  end else begin
    calc_op1_int_104_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[105]) == 1'b1) begin
    calc_op1_int_105_d1 <= abuf_in_data_105;
  // VCS coverage off
  end else if ((calc_op_en_int[105]) == 1'b0) begin
  end else begin
    calc_op1_int_105_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[106]) == 1'b1) begin
    calc_op1_int_106_d1 <= abuf_in_data_106;
  // VCS coverage off
  end else if ((calc_op_en_int[106]) == 1'b0) begin
  end else begin
    calc_op1_int_106_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[107]) == 1'b1) begin
    calc_op1_int_107_d1 <= abuf_in_data_107;
  // VCS coverage off
  end else if ((calc_op_en_int[107]) == 1'b0) begin
  end else begin
    calc_op1_int_107_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[108]) == 1'b1) begin
    calc_op1_int_108_d1 <= abuf_in_data_108;
  // VCS coverage off
  end else if ((calc_op_en_int[108]) == 1'b0) begin
  end else begin
    calc_op1_int_108_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[109]) == 1'b1) begin
    calc_op1_int_109_d1 <= abuf_in_data_109;
  // VCS coverage off
  end else if ((calc_op_en_int[109]) == 1'b0) begin
  end else begin
    calc_op1_int_109_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[110]) == 1'b1) begin
    calc_op1_int_110_d1 <= abuf_in_data_110;
  // VCS coverage off
  end else if ((calc_op_en_int[110]) == 1'b0) begin
  end else begin
    calc_op1_int_110_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[111]) == 1'b1) begin
    calc_op1_int_111_d1 <= abuf_in_data_111;
  // VCS coverage off
  end else if ((calc_op_en_int[111]) == 1'b0) begin
  end else begin
    calc_op1_int_111_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[112]) == 1'b1) begin
    calc_op1_int_112_d1 <= abuf_in_data_112;
  // VCS coverage off
  end else if ((calc_op_en_int[112]) == 1'b0) begin
  end else begin
    calc_op1_int_112_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[113]) == 1'b1) begin
    calc_op1_int_113_d1 <= abuf_in_data_113;
  // VCS coverage off
  end else if ((calc_op_en_int[113]) == 1'b0) begin
  end else begin
    calc_op1_int_113_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[114]) == 1'b1) begin
    calc_op1_int_114_d1 <= abuf_in_data_114;
  // VCS coverage off
  end else if ((calc_op_en_int[114]) == 1'b0) begin
  end else begin
    calc_op1_int_114_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[115]) == 1'b1) begin
    calc_op1_int_115_d1 <= abuf_in_data_115;
  // VCS coverage off
  end else if ((calc_op_en_int[115]) == 1'b0) begin
  end else begin
    calc_op1_int_115_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[116]) == 1'b1) begin
    calc_op1_int_116_d1 <= abuf_in_data_116;
  // VCS coverage off
  end else if ((calc_op_en_int[116]) == 1'b0) begin
  end else begin
    calc_op1_int_116_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[117]) == 1'b1) begin
    calc_op1_int_117_d1 <= abuf_in_data_117;
  // VCS coverage off
  end else if ((calc_op_en_int[117]) == 1'b0) begin
  end else begin
    calc_op1_int_117_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[118]) == 1'b1) begin
    calc_op1_int_118_d1 <= abuf_in_data_118;
  // VCS coverage off
  end else if ((calc_op_en_int[118]) == 1'b0) begin
  end else begin
    calc_op1_int_118_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[119]) == 1'b1) begin
    calc_op1_int_119_d1 <= abuf_in_data_119;
  // VCS coverage off
  end else if ((calc_op_en_int[119]) == 1'b0) begin
  end else begin
    calc_op1_int_119_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[120]) == 1'b1) begin
    calc_op1_int_120_d1 <= abuf_in_data_120;
  // VCS coverage off
  end else if ((calc_op_en_int[120]) == 1'b0) begin
  end else begin
    calc_op1_int_120_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[121]) == 1'b1) begin
    calc_op1_int_121_d1 <= abuf_in_data_121;
  // VCS coverage off
  end else if ((calc_op_en_int[121]) == 1'b0) begin
  end else begin
    calc_op1_int_121_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[122]) == 1'b1) begin
    calc_op1_int_122_d1 <= abuf_in_data_122;
  // VCS coverage off
  end else if ((calc_op_en_int[122]) == 1'b0) begin
  end else begin
    calc_op1_int_122_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[123]) == 1'b1) begin
    calc_op1_int_123_d1 <= abuf_in_data_123;
  // VCS coverage off
  end else if ((calc_op_en_int[123]) == 1'b0) begin
  end else begin
    calc_op1_int_123_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[124]) == 1'b1) begin
    calc_op1_int_124_d1 <= abuf_in_data_124;
  // VCS coverage off
  end else if ((calc_op_en_int[124]) == 1'b0) begin
  end else begin
    calc_op1_int_124_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[125]) == 1'b1) begin
    calc_op1_int_125_d1 <= abuf_in_data_125;
  // VCS coverage off
  end else if ((calc_op_en_int[125]) == 1'b0) begin
  end else begin
    calc_op1_int_125_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[126]) == 1'b1) begin
    calc_op1_int_126_d1 <= abuf_in_data_126;
  // VCS coverage off
  end else if ((calc_op_en_int[126]) == 1'b0) begin
  end else begin
    calc_op1_int_126_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_int[127]) == 1'b1) begin
    calc_op1_int_127_d1 <= abuf_in_data_127;
  // VCS coverage off
  end else if ((calc_op_en_int[127]) == 1'b0) begin
  end else begin
    calc_op1_int_127_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end




always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[0]) == 1'b1) begin
    calc_op1_fp_0_d1 <= abuf_in_data_0[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[0]) == 1'b0) begin
  end else begin
    calc_op1_fp_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[1]) == 1'b1) begin
    calc_op1_fp_1_d1 <= abuf_in_data_1[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[1]) == 1'b0) begin
  end else begin
    calc_op1_fp_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[2]) == 1'b1) begin
    calc_op1_fp_2_d1 <= abuf_in_data_2[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[2]) == 1'b0) begin
  end else begin
    calc_op1_fp_2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[3]) == 1'b1) begin
    calc_op1_fp_3_d1 <= abuf_in_data_3[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[3]) == 1'b0) begin
  end else begin
    calc_op1_fp_3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[4]) == 1'b1) begin
    calc_op1_fp_4_d1 <= abuf_in_data_4[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[4]) == 1'b0) begin
  end else begin
    calc_op1_fp_4_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[5]) == 1'b1) begin
    calc_op1_fp_5_d1 <= abuf_in_data_5[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[5]) == 1'b0) begin
  end else begin
    calc_op1_fp_5_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[6]) == 1'b1) begin
    calc_op1_fp_6_d1 <= abuf_in_data_6[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[6]) == 1'b0) begin
  end else begin
    calc_op1_fp_6_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[7]) == 1'b1) begin
    calc_op1_fp_7_d1 <= abuf_in_data_7[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[7]) == 1'b0) begin
  end else begin
    calc_op1_fp_7_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[8]) == 1'b1) begin
    calc_op1_fp_8_d1 <= abuf_in_data_8[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[8]) == 1'b0) begin
  end else begin
    calc_op1_fp_8_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[9]) == 1'b1) begin
    calc_op1_fp_9_d1 <= abuf_in_data_9[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[9]) == 1'b0) begin
  end else begin
    calc_op1_fp_9_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[10]) == 1'b1) begin
    calc_op1_fp_10_d1 <= abuf_in_data_10[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[10]) == 1'b0) begin
  end else begin
    calc_op1_fp_10_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[11]) == 1'b1) begin
    calc_op1_fp_11_d1 <= abuf_in_data_11[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[11]) == 1'b0) begin
  end else begin
    calc_op1_fp_11_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[12]) == 1'b1) begin
    calc_op1_fp_12_d1 <= abuf_in_data_12[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[12]) == 1'b0) begin
  end else begin
    calc_op1_fp_12_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[13]) == 1'b1) begin
    calc_op1_fp_13_d1 <= abuf_in_data_13[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[13]) == 1'b0) begin
  end else begin
    calc_op1_fp_13_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[14]) == 1'b1) begin
    calc_op1_fp_14_d1 <= abuf_in_data_14[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[14]) == 1'b0) begin
  end else begin
    calc_op1_fp_14_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[15]) == 1'b1) begin
    calc_op1_fp_15_d1 <= abuf_in_data_15[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[15]) == 1'b0) begin
  end else begin
    calc_op1_fp_15_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[16]) == 1'b1) begin
    calc_op1_fp_16_d1 <= abuf_in_data_16[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[16]) == 1'b0) begin
  end else begin
    calc_op1_fp_16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[17]) == 1'b1) begin
    calc_op1_fp_17_d1 <= abuf_in_data_17[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[17]) == 1'b0) begin
  end else begin
    calc_op1_fp_17_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[18]) == 1'b1) begin
    calc_op1_fp_18_d1 <= abuf_in_data_18[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[18]) == 1'b0) begin
  end else begin
    calc_op1_fp_18_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[19]) == 1'b1) begin
    calc_op1_fp_19_d1 <= abuf_in_data_19[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[19]) == 1'b0) begin
  end else begin
    calc_op1_fp_19_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[20]) == 1'b1) begin
    calc_op1_fp_20_d1 <= abuf_in_data_20[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[20]) == 1'b0) begin
  end else begin
    calc_op1_fp_20_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[21]) == 1'b1) begin
    calc_op1_fp_21_d1 <= abuf_in_data_21[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[21]) == 1'b0) begin
  end else begin
    calc_op1_fp_21_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[22]) == 1'b1) begin
    calc_op1_fp_22_d1 <= abuf_in_data_22[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[22]) == 1'b0) begin
  end else begin
    calc_op1_fp_22_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[23]) == 1'b1) begin
    calc_op1_fp_23_d1 <= abuf_in_data_23[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[23]) == 1'b0) begin
  end else begin
    calc_op1_fp_23_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[24]) == 1'b1) begin
    calc_op1_fp_24_d1 <= abuf_in_data_24[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[24]) == 1'b0) begin
  end else begin
    calc_op1_fp_24_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[25]) == 1'b1) begin
    calc_op1_fp_25_d1 <= abuf_in_data_25[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[25]) == 1'b0) begin
  end else begin
    calc_op1_fp_25_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[26]) == 1'b1) begin
    calc_op1_fp_26_d1 <= abuf_in_data_26[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[26]) == 1'b0) begin
  end else begin
    calc_op1_fp_26_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[27]) == 1'b1) begin
    calc_op1_fp_27_d1 <= abuf_in_data_27[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[27]) == 1'b0) begin
  end else begin
    calc_op1_fp_27_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[28]) == 1'b1) begin
    calc_op1_fp_28_d1 <= abuf_in_data_28[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[28]) == 1'b0) begin
  end else begin
    calc_op1_fp_28_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[29]) == 1'b1) begin
    calc_op1_fp_29_d1 <= abuf_in_data_29[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[29]) == 1'b0) begin
  end else begin
    calc_op1_fp_29_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[30]) == 1'b1) begin
    calc_op1_fp_30_d1 <= abuf_in_data_30[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[30]) == 1'b0) begin
  end else begin
    calc_op1_fp_30_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[31]) == 1'b1) begin
    calc_op1_fp_31_d1 <= abuf_in_data_31[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[31]) == 1'b0) begin
  end else begin
    calc_op1_fp_31_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[32]) == 1'b1) begin
    calc_op1_fp_32_d1 <= abuf_in_data_32[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[32]) == 1'b0) begin
  end else begin
    calc_op1_fp_32_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[33]) == 1'b1) begin
    calc_op1_fp_33_d1 <= abuf_in_data_33[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[33]) == 1'b0) begin
  end else begin
    calc_op1_fp_33_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[34]) == 1'b1) begin
    calc_op1_fp_34_d1 <= abuf_in_data_34[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[34]) == 1'b0) begin
  end else begin
    calc_op1_fp_34_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[35]) == 1'b1) begin
    calc_op1_fp_35_d1 <= abuf_in_data_35[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[35]) == 1'b0) begin
  end else begin
    calc_op1_fp_35_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[36]) == 1'b1) begin
    calc_op1_fp_36_d1 <= abuf_in_data_36[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[36]) == 1'b0) begin
  end else begin
    calc_op1_fp_36_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[37]) == 1'b1) begin
    calc_op1_fp_37_d1 <= abuf_in_data_37[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[37]) == 1'b0) begin
  end else begin
    calc_op1_fp_37_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[38]) == 1'b1) begin
    calc_op1_fp_38_d1 <= abuf_in_data_38[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[38]) == 1'b0) begin
  end else begin
    calc_op1_fp_38_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[39]) == 1'b1) begin
    calc_op1_fp_39_d1 <= abuf_in_data_39[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[39]) == 1'b0) begin
  end else begin
    calc_op1_fp_39_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[40]) == 1'b1) begin
    calc_op1_fp_40_d1 <= abuf_in_data_40[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[40]) == 1'b0) begin
  end else begin
    calc_op1_fp_40_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[41]) == 1'b1) begin
    calc_op1_fp_41_d1 <= abuf_in_data_41[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[41]) == 1'b0) begin
  end else begin
    calc_op1_fp_41_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[42]) == 1'b1) begin
    calc_op1_fp_42_d1 <= abuf_in_data_42[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[42]) == 1'b0) begin
  end else begin
    calc_op1_fp_42_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[43]) == 1'b1) begin
    calc_op1_fp_43_d1 <= abuf_in_data_43[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[43]) == 1'b0) begin
  end else begin
    calc_op1_fp_43_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[44]) == 1'b1) begin
    calc_op1_fp_44_d1 <= abuf_in_data_44[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[44]) == 1'b0) begin
  end else begin
    calc_op1_fp_44_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[45]) == 1'b1) begin
    calc_op1_fp_45_d1 <= abuf_in_data_45[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[45]) == 1'b0) begin
  end else begin
    calc_op1_fp_45_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[46]) == 1'b1) begin
    calc_op1_fp_46_d1 <= abuf_in_data_46[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[46]) == 1'b0) begin
  end else begin
    calc_op1_fp_46_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[47]) == 1'b1) begin
    calc_op1_fp_47_d1 <= abuf_in_data_47[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[47]) == 1'b0) begin
  end else begin
    calc_op1_fp_47_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[48]) == 1'b1) begin
    calc_op1_fp_48_d1 <= abuf_in_data_48[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[48]) == 1'b0) begin
  end else begin
    calc_op1_fp_48_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[49]) == 1'b1) begin
    calc_op1_fp_49_d1 <= abuf_in_data_49[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[49]) == 1'b0) begin
  end else begin
    calc_op1_fp_49_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[50]) == 1'b1) begin
    calc_op1_fp_50_d1 <= abuf_in_data_50[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[50]) == 1'b0) begin
  end else begin
    calc_op1_fp_50_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[51]) == 1'b1) begin
    calc_op1_fp_51_d1 <= abuf_in_data_51[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[51]) == 1'b0) begin
  end else begin
    calc_op1_fp_51_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[52]) == 1'b1) begin
    calc_op1_fp_52_d1 <= abuf_in_data_52[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[52]) == 1'b0) begin
  end else begin
    calc_op1_fp_52_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[53]) == 1'b1) begin
    calc_op1_fp_53_d1 <= abuf_in_data_53[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[53]) == 1'b0) begin
  end else begin
    calc_op1_fp_53_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[54]) == 1'b1) begin
    calc_op1_fp_54_d1 <= abuf_in_data_54[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[54]) == 1'b0) begin
  end else begin
    calc_op1_fp_54_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[55]) == 1'b1) begin
    calc_op1_fp_55_d1 <= abuf_in_data_55[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[55]) == 1'b0) begin
  end else begin
    calc_op1_fp_55_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[56]) == 1'b1) begin
    calc_op1_fp_56_d1 <= abuf_in_data_56[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[56]) == 1'b0) begin
  end else begin
    calc_op1_fp_56_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[57]) == 1'b1) begin
    calc_op1_fp_57_d1 <= abuf_in_data_57[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[57]) == 1'b0) begin
  end else begin
    calc_op1_fp_57_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[58]) == 1'b1) begin
    calc_op1_fp_58_d1 <= abuf_in_data_58[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[58]) == 1'b0) begin
  end else begin
    calc_op1_fp_58_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[59]) == 1'b1) begin
    calc_op1_fp_59_d1 <= abuf_in_data_59[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[59]) == 1'b0) begin
  end else begin
    calc_op1_fp_59_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[60]) == 1'b1) begin
    calc_op1_fp_60_d1 <= abuf_in_data_60[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[60]) == 1'b0) begin
  end else begin
    calc_op1_fp_60_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[61]) == 1'b1) begin
    calc_op1_fp_61_d1 <= abuf_in_data_61[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[61]) == 1'b0) begin
  end else begin
    calc_op1_fp_61_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[62]) == 1'b1) begin
    calc_op1_fp_62_d1 <= abuf_in_data_62[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[62]) == 1'b0) begin
  end else begin
    calc_op1_fp_62_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_op_en_fp[63]) == 1'b1) begin
    calc_op1_fp_63_d1 <= abuf_in_data_63[47:0];
  // VCS coverage off
  end else if ((calc_op_en_fp[63]) == 1'b0) begin
  end else begin
    calc_op1_fp_63_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end





always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_valid_d1 <= 1'b0;
  end else begin
  calc_valid_d1 <= calc_valid_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_wr_en_d1 <= {8{1'b0}};
  end else begin
  if ((accu_ctrl_valid | calc_valid_d1) == 1'b1) begin
    calc_wr_en_d1 <= calc_wr_en;
  // VCS coverage off
  end else if ((accu_ctrl_valid | calc_valid_d1) == 1'b0) begin
  end else begin
    calc_wr_en_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid | calc_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_addr_d1 <= {5{1'b0}};
  end else begin
  if ((accu_ctrl_valid) == 1'b1) begin
    calc_addr_d1 <= calc_addr;
  // VCS coverage off
  end else if ((accu_ctrl_valid) == 1'b0) begin
  end else begin
    calc_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_dlv_valid_d1 <= 1'b0;
  end else begin
  calc_dlv_valid_d1 <= calc_dlv_valid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_dlv_en_d1 <= {8{1'b0}};
  end else begin
  if ((accu_ctrl_valid | calc_valid_d1) == 1'b1) begin
    calc_dlv_en_d1 <= calc_dlv_en;
  // VCS coverage off
  end else if ((accu_ctrl_valid | calc_valid_d1) == 1'b0) begin
  end else begin
    calc_dlv_en_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid | calc_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_stripe_end_d1 <= 1'b0;
  end else begin
  if ((accu_ctrl_valid) == 1'b1) begin
    calc_stripe_end_d1 <= calc_stripe_end;
  // VCS coverage off
  end else if ((accu_ctrl_valid) == 1'b0) begin
  end else begin
    calc_stripe_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_layer_end_d1 <= 1'b0;
  end else begin
  if ((accu_ctrl_valid) == 1'b1) begin
    calc_layer_end_d1 <= calc_layer_end;
  // VCS coverage off
  end else if ((accu_ctrl_valid) == 1'b0) begin
  end else begin
    calc_layer_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_op_en_int_d1 <= {128{1'b0}};
  end else begin
  if ((accu_ctrl_valid | calc_valid_d1) == 1'b1) begin
    calc_op_en_int_d1 <= calc_op_en_int;
  // VCS coverage off
  end else if ((accu_ctrl_valid | calc_valid_d1) == 1'b0) begin
  end else begin
    calc_op_en_int_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid | calc_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_op_en_fp_d1 <= {64{1'b0}};
  end else begin
  if ((accu_ctrl_valid | calc_valid_d1) == 1'b1) begin
    calc_op_en_fp_d1 <= calc_op_en_fp;
  // VCS coverage off
  end else if ((accu_ctrl_valid | calc_valid_d1) == 1'b0) begin
  end else begin
    calc_op_en_fp_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid | calc_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_op1_vld_int_d1 <= {128{1'b0}};
  end else begin
  if ((accu_ctrl_valid | calc_valid_d1) == 1'b1) begin
    calc_op1_vld_int_d1 <= calc_op1_vld_int;
  // VCS coverage off
  end else if ((accu_ctrl_valid | calc_valid_d1) == 1'b0) begin
  end else begin
    calc_op1_vld_int_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid | calc_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_op1_vld_fp_d1 <= {64{1'b0}};
  end else begin
  if ((accu_ctrl_valid | calc_valid_d1) == 1'b1) begin
    calc_op1_vld_fp_d1 <= calc_op1_vld_fp;
  // VCS coverage off
  end else if ((accu_ctrl_valid | calc_valid_d1) == 1'b0) begin
  end else begin
    calc_op1_vld_fp_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid | calc_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_dlv_en_int_d1 <= {128{1'b0}};
  end else begin
  if ((accu_ctrl_valid | calc_valid_d1) == 1'b1) begin
    calc_dlv_en_int_d1 <= calc_dlv_en_int;
  // VCS coverage off
  end else if ((accu_ctrl_valid | calc_valid_d1) == 1'b0) begin
  end else begin
    calc_dlv_en_int_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid | calc_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_dlv_en_fp_d1 <= {64{1'b0}};
  end else begin
  if ((accu_ctrl_valid | calc_valid_d1) == 1'b1) begin
    calc_dlv_en_fp_d1 <= calc_dlv_en_fp;
  // VCS coverage off
  end else if ((accu_ctrl_valid | calc_valid_d1) == 1'b0) begin
  end else begin
    calc_dlv_en_fp_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(accu_ctrl_valid | calc_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign {cfg_truncate_127, cfg_truncate_126, cfg_truncate_125, cfg_truncate_124, cfg_truncate_123, cfg_truncate_122, cfg_truncate_121, cfg_truncate_120, cfg_truncate_119, cfg_truncate_118, cfg_truncate_117, cfg_truncate_116, cfg_truncate_115, cfg_truncate_114, cfg_truncate_113, cfg_truncate_112, cfg_truncate_111, cfg_truncate_110, cfg_truncate_109, cfg_truncate_108, cfg_truncate_107, cfg_truncate_106, cfg_truncate_105, cfg_truncate_104, cfg_truncate_103, cfg_truncate_102, cfg_truncate_101, cfg_truncate_100, cfg_truncate_99, cfg_truncate_98, cfg_truncate_97, cfg_truncate_96, cfg_truncate_95, cfg_truncate_94, cfg_truncate_93, cfg_truncate_92, cfg_truncate_91, cfg_truncate_90, cfg_truncate_89, cfg_truncate_88, cfg_truncate_87, cfg_truncate_86, cfg_truncate_85, cfg_truncate_84, cfg_truncate_83, cfg_truncate_82, cfg_truncate_81, cfg_truncate_80, cfg_truncate_79, cfg_truncate_78, cfg_truncate_77, cfg_truncate_76, cfg_truncate_75, cfg_truncate_74, cfg_truncate_73, cfg_truncate_72, cfg_truncate_71, cfg_truncate_70, cfg_truncate_69, cfg_truncate_68, cfg_truncate_67, cfg_truncate_66, cfg_truncate_65, cfg_truncate_64, cfg_truncate_63, cfg_truncate_62, cfg_truncate_61, cfg_truncate_60, cfg_truncate_59, cfg_truncate_58, cfg_truncate_57, cfg_truncate_56, cfg_truncate_55, cfg_truncate_54, cfg_truncate_53, cfg_truncate_52, cfg_truncate_51, cfg_truncate_50, cfg_truncate_49, cfg_truncate_48, cfg_truncate_47, cfg_truncate_46, cfg_truncate_45, cfg_truncate_44, cfg_truncate_43, cfg_truncate_42, cfg_truncate_41, cfg_truncate_40, cfg_truncate_39, cfg_truncate_38, cfg_truncate_37, cfg_truncate_36, cfg_truncate_35, cfg_truncate_34, cfg_truncate_33, cfg_truncate_32, cfg_truncate_31, cfg_truncate_30, cfg_truncate_29, cfg_truncate_28, cfg_truncate_27, cfg_truncate_26, cfg_truncate_25, cfg_truncate_24, cfg_truncate_23, cfg_truncate_22, cfg_truncate_21, cfg_truncate_20, cfg_truncate_19, cfg_truncate_18, cfg_truncate_17, cfg_truncate_16, cfg_truncate_15, cfg_truncate_14, cfg_truncate_13, cfg_truncate_12, cfg_truncate_11, cfg_truncate_10, cfg_truncate_9, cfg_truncate_8, cfg_truncate_7, cfg_truncate_6, cfg_truncate_5, cfg_truncate_4, cfg_truncate_3, cfg_truncate_2, cfg_truncate_1, cfg_truncate_0} = cfg_truncate;

//////////////////////////////////////////////////////////////
///// Calculation Cells: Adders and Convertors           /////
//////////////////////////////////////////////////////////////



NV_NVDLA_CACC_CALC_int16 u_cell_int_0 (
   .cfg_truncate      (cfg_truncate_0[4:0])         //|< w
  ,.in_data           (calc_op0_int_0_d1[37:0])     //|< r
  ,.in_op             (calc_op1_int_0_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[0])      //|< r
  ,.in_sel            (calc_dlv_en_int_d1[0])       //|< r
  ,.in_valid          (calc_op_en_int_d1[0])        //|< r
  ,.out_final_data    (calc_fout_int_0_sum[31:0])   //|> w
  ,.out_final_sat     (calc_fout_int_sat[0])        //|> w
  ,.out_final_valid   (calc_fout_int_vld[0])        //|> w
  ,.out_partial_data  (calc_pout_int_0_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_int_vld[0])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_1 (
   .cfg_truncate      (cfg_truncate_1[4:0])         //|< w
  ,.in_data           (calc_op0_int_1_d1[37:0])     //|< r
  ,.in_op             (calc_op1_int_1_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[1])      //|< r
  ,.in_sel            (calc_dlv_en_int_d1[1])       //|< r
  ,.in_valid          (calc_op_en_int_d1[1])        //|< r
  ,.out_final_data    (calc_fout_int_1_sum[31:0])   //|> w
  ,.out_final_sat     (calc_fout_int_sat[1])        //|> w
  ,.out_final_valid   (calc_fout_int_vld[1])        //|> w
  ,.out_partial_data  (calc_pout_int_1_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_int_vld[1])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_2 (
   .cfg_truncate      (cfg_truncate_2[4:0])         //|< w
  ,.in_data           (calc_op0_int_2_d1[37:0])     //|< r
  ,.in_op             (calc_op1_int_2_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[2])      //|< r
  ,.in_sel            (calc_dlv_en_int_d1[2])       //|< r
  ,.in_valid          (calc_op_en_int_d1[2])        //|< r
  ,.out_final_data    (calc_fout_int_2_sum[31:0])   //|> w
  ,.out_final_sat     (calc_fout_int_sat[2])        //|> w
  ,.out_final_valid   (calc_fout_int_vld[2])        //|> w
  ,.out_partial_data  (calc_pout_int_2_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_int_vld[2])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_3 (
   .cfg_truncate      (cfg_truncate_3[4:0])         //|< w
  ,.in_data           (calc_op0_int_3_d1[37:0])     //|< r
  ,.in_op             (calc_op1_int_3_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[3])      //|< r
  ,.in_sel            (calc_dlv_en_int_d1[3])       //|< r
  ,.in_valid          (calc_op_en_int_d1[3])        //|< r
  ,.out_final_data    (calc_fout_int_3_sum[31:0])   //|> w
  ,.out_final_sat     (calc_fout_int_sat[3])        //|> w
  ,.out_final_valid   (calc_fout_int_vld[3])        //|> w
  ,.out_partial_data  (calc_pout_int_3_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_int_vld[3])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_4 (
   .cfg_truncate      (cfg_truncate_4[4:0])         //|< w
  ,.in_data           (calc_op0_int_4_d1[37:0])     //|< r
  ,.in_op             (calc_op1_int_4_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[4])      //|< r
  ,.in_sel            (calc_dlv_en_int_d1[4])       //|< r
  ,.in_valid          (calc_op_en_int_d1[4])        //|< r
  ,.out_final_data    (calc_fout_int_4_sum[31:0])   //|> w
  ,.out_final_sat     (calc_fout_int_sat[4])        //|> w
  ,.out_final_valid   (calc_fout_int_vld[4])        //|> w
  ,.out_partial_data  (calc_pout_int_4_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_int_vld[4])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_5 (
   .cfg_truncate      (cfg_truncate_5[4:0])         //|< w
  ,.in_data           (calc_op0_int_5_d1[37:0])     //|< r
  ,.in_op             (calc_op1_int_5_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[5])      //|< r
  ,.in_sel            (calc_dlv_en_int_d1[5])       //|< r
  ,.in_valid          (calc_op_en_int_d1[5])        //|< r
  ,.out_final_data    (calc_fout_int_5_sum[31:0])   //|> w
  ,.out_final_sat     (calc_fout_int_sat[5])        //|> w
  ,.out_final_valid   (calc_fout_int_vld[5])        //|> w
  ,.out_partial_data  (calc_pout_int_5_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_int_vld[5])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_6 (
   .cfg_truncate      (cfg_truncate_6[4:0])         //|< w
  ,.in_data           (calc_op0_int_6_d1[37:0])     //|< r
  ,.in_op             (calc_op1_int_6_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[6])      //|< r
  ,.in_sel            (calc_dlv_en_int_d1[6])       //|< r
  ,.in_valid          (calc_op_en_int_d1[6])        //|< r
  ,.out_final_data    (calc_fout_int_6_sum[31:0])   //|> w
  ,.out_final_sat     (calc_fout_int_sat[6])        //|> w
  ,.out_final_valid   (calc_fout_int_vld[6])        //|> w
  ,.out_partial_data  (calc_pout_int_6_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_int_vld[6])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_7 (
   .cfg_truncate      (cfg_truncate_7[4:0])         //|< w
  ,.in_data           (calc_op0_int_7_d1[37:0])     //|< r
  ,.in_op             (calc_op1_int_7_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[7])      //|< r
  ,.in_sel            (calc_dlv_en_int_d1[7])       //|< r
  ,.in_valid          (calc_op_en_int_d1[7])        //|< r
  ,.out_final_data    (calc_fout_int_7_sum[31:0])   //|> w
  ,.out_final_sat     (calc_fout_int_sat[7])        //|> w
  ,.out_final_valid   (calc_fout_int_vld[7])        //|> w
  ,.out_partial_data  (calc_pout_int_7_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_int_vld[7])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_8 (
   .cfg_truncate      (cfg_truncate_8[4:0])         //|< w
  ,.in_data           (calc_op0_int_8_d1[37:0])     //|< r
  ,.in_op             (calc_op1_int_8_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[8])      //|< r
  ,.in_sel            (calc_dlv_en_int_d1[8])       //|< r
  ,.in_valid          (calc_op_en_int_d1[8])        //|< r
  ,.out_final_data    (calc_fout_int_8_sum[31:0])   //|> w
  ,.out_final_sat     (calc_fout_int_sat[8])        //|> w
  ,.out_final_valid   (calc_fout_int_vld[8])        //|> w
  ,.out_partial_data  (calc_pout_int_8_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_int_vld[8])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_9 (
   .cfg_truncate      (cfg_truncate_9[4:0])         //|< w
  ,.in_data           (calc_op0_int_9_d1[37:0])     //|< r
  ,.in_op             (calc_op1_int_9_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[9])      //|< r
  ,.in_sel            (calc_dlv_en_int_d1[9])       //|< r
  ,.in_valid          (calc_op_en_int_d1[9])        //|< r
  ,.out_final_data    (calc_fout_int_9_sum[31:0])   //|> w
  ,.out_final_sat     (calc_fout_int_sat[9])        //|> w
  ,.out_final_valid   (calc_fout_int_vld[9])        //|> w
  ,.out_partial_data  (calc_pout_int_9_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_int_vld[9])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_10 (
   .cfg_truncate      (cfg_truncate_10[4:0])        //|< w
  ,.in_data           (calc_op0_int_10_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_10_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[10])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[10])      //|< r
  ,.in_valid          (calc_op_en_int_d1[10])       //|< r
  ,.out_final_data    (calc_fout_int_10_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[10])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[10])       //|> w
  ,.out_partial_data  (calc_pout_int_10_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[10])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_11 (
   .cfg_truncate      (cfg_truncate_11[4:0])        //|< w
  ,.in_data           (calc_op0_int_11_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_11_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[11])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[11])      //|< r
  ,.in_valid          (calc_op_en_int_d1[11])       //|< r
  ,.out_final_data    (calc_fout_int_11_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[11])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[11])       //|> w
  ,.out_partial_data  (calc_pout_int_11_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[11])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_12 (
   .cfg_truncate      (cfg_truncate_12[4:0])        //|< w
  ,.in_data           (calc_op0_int_12_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_12_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[12])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[12])      //|< r
  ,.in_valid          (calc_op_en_int_d1[12])       //|< r
  ,.out_final_data    (calc_fout_int_12_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[12])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[12])       //|> w
  ,.out_partial_data  (calc_pout_int_12_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[12])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_13 (
   .cfg_truncate      (cfg_truncate_13[4:0])        //|< w
  ,.in_data           (calc_op0_int_13_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_13_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[13])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[13])      //|< r
  ,.in_valid          (calc_op_en_int_d1[13])       //|< r
  ,.out_final_data    (calc_fout_int_13_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[13])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[13])       //|> w
  ,.out_partial_data  (calc_pout_int_13_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[13])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_14 (
   .cfg_truncate      (cfg_truncate_14[4:0])        //|< w
  ,.in_data           (calc_op0_int_14_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_14_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[14])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[14])      //|< r
  ,.in_valid          (calc_op_en_int_d1[14])       //|< r
  ,.out_final_data    (calc_fout_int_14_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[14])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[14])       //|> w
  ,.out_partial_data  (calc_pout_int_14_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[14])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_15 (
   .cfg_truncate      (cfg_truncate_15[4:0])        //|< w
  ,.in_data           (calc_op0_int_15_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_15_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[15])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[15])      //|< r
  ,.in_valid          (calc_op_en_int_d1[15])       //|< r
  ,.out_final_data    (calc_fout_int_15_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[15])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[15])       //|> w
  ,.out_partial_data  (calc_pout_int_15_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[15])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );






NV_NVDLA_CACC_CALC_int16 u_cell_int_16 (
   .cfg_truncate      (cfg_truncate_16[4:0])        //|< w
  ,.in_data           (calc_op0_int_16_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_16_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[16])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[16])      //|< r
  ,.in_valid          (calc_op_en_int_d1[16])       //|< r
  ,.out_final_data    (calc_fout_int_16_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[16])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[16])       //|> w
  ,.out_partial_data  (calc_pout_int_16_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[16])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_17 (
   .cfg_truncate      (cfg_truncate_17[4:0])        //|< w
  ,.in_data           (calc_op0_int_17_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_17_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[17])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[17])      //|< r
  ,.in_valid          (calc_op_en_int_d1[17])       //|< r
  ,.out_final_data    (calc_fout_int_17_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[17])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[17])       //|> w
  ,.out_partial_data  (calc_pout_int_17_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[17])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_18 (
   .cfg_truncate      (cfg_truncate_18[4:0])        //|< w
  ,.in_data           (calc_op0_int_18_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_18_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[18])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[18])      //|< r
  ,.in_valid          (calc_op_en_int_d1[18])       //|< r
  ,.out_final_data    (calc_fout_int_18_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[18])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[18])       //|> w
  ,.out_partial_data  (calc_pout_int_18_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[18])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_19 (
   .cfg_truncate      (cfg_truncate_19[4:0])        //|< w
  ,.in_data           (calc_op0_int_19_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_19_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[19])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[19])      //|< r
  ,.in_valid          (calc_op_en_int_d1[19])       //|< r
  ,.out_final_data    (calc_fout_int_19_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[19])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[19])       //|> w
  ,.out_partial_data  (calc_pout_int_19_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[19])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_20 (
   .cfg_truncate      (cfg_truncate_20[4:0])        //|< w
  ,.in_data           (calc_op0_int_20_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_20_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[20])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[20])      //|< r
  ,.in_valid          (calc_op_en_int_d1[20])       //|< r
  ,.out_final_data    (calc_fout_int_20_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[20])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[20])       //|> w
  ,.out_partial_data  (calc_pout_int_20_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[20])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_21 (
   .cfg_truncate      (cfg_truncate_21[4:0])        //|< w
  ,.in_data           (calc_op0_int_21_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_21_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[21])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[21])      //|< r
  ,.in_valid          (calc_op_en_int_d1[21])       //|< r
  ,.out_final_data    (calc_fout_int_21_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[21])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[21])       //|> w
  ,.out_partial_data  (calc_pout_int_21_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[21])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_22 (
   .cfg_truncate      (cfg_truncate_22[4:0])        //|< w
  ,.in_data           (calc_op0_int_22_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_22_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[22])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[22])      //|< r
  ,.in_valid          (calc_op_en_int_d1[22])       //|< r
  ,.out_final_data    (calc_fout_int_22_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[22])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[22])       //|> w
  ,.out_partial_data  (calc_pout_int_22_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[22])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_23 (
   .cfg_truncate      (cfg_truncate_23[4:0])        //|< w
  ,.in_data           (calc_op0_int_23_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_23_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[23])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[23])      //|< r
  ,.in_valid          (calc_op_en_int_d1[23])       //|< r
  ,.out_final_data    (calc_fout_int_23_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[23])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[23])       //|> w
  ,.out_partial_data  (calc_pout_int_23_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[23])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_24 (
   .cfg_truncate      (cfg_truncate_24[4:0])        //|< w
  ,.in_data           (calc_op0_int_24_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_24_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[24])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[24])      //|< r
  ,.in_valid          (calc_op_en_int_d1[24])       //|< r
  ,.out_final_data    (calc_fout_int_24_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[24])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[24])       //|> w
  ,.out_partial_data  (calc_pout_int_24_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[24])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_25 (
   .cfg_truncate      (cfg_truncate_25[4:0])        //|< w
  ,.in_data           (calc_op0_int_25_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_25_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[25])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[25])      //|< r
  ,.in_valid          (calc_op_en_int_d1[25])       //|< r
  ,.out_final_data    (calc_fout_int_25_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[25])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[25])       //|> w
  ,.out_partial_data  (calc_pout_int_25_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[25])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_26 (
   .cfg_truncate      (cfg_truncate_26[4:0])        //|< w
  ,.in_data           (calc_op0_int_26_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_26_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[26])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[26])      //|< r
  ,.in_valid          (calc_op_en_int_d1[26])       //|< r
  ,.out_final_data    (calc_fout_int_26_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[26])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[26])       //|> w
  ,.out_partial_data  (calc_pout_int_26_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[26])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_27 (
   .cfg_truncate      (cfg_truncate_27[4:0])        //|< w
  ,.in_data           (calc_op0_int_27_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_27_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[27])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[27])      //|< r
  ,.in_valid          (calc_op_en_int_d1[27])       //|< r
  ,.out_final_data    (calc_fout_int_27_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[27])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[27])       //|> w
  ,.out_partial_data  (calc_pout_int_27_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[27])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_28 (
   .cfg_truncate      (cfg_truncate_28[4:0])        //|< w
  ,.in_data           (calc_op0_int_28_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_28_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[28])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[28])      //|< r
  ,.in_valid          (calc_op_en_int_d1[28])       //|< r
  ,.out_final_data    (calc_fout_int_28_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[28])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[28])       //|> w
  ,.out_partial_data  (calc_pout_int_28_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[28])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_29 (
   .cfg_truncate      (cfg_truncate_29[4:0])        //|< w
  ,.in_data           (calc_op0_int_29_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_29_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[29])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[29])      //|< r
  ,.in_valid          (calc_op_en_int_d1[29])       //|< r
  ,.out_final_data    (calc_fout_int_29_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[29])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[29])       //|> w
  ,.out_partial_data  (calc_pout_int_29_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[29])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_30 (
   .cfg_truncate      (cfg_truncate_30[4:0])        //|< w
  ,.in_data           (calc_op0_int_30_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_30_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[30])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[30])      //|< r
  ,.in_valid          (calc_op_en_int_d1[30])       //|< r
  ,.out_final_data    (calc_fout_int_30_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[30])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[30])       //|> w
  ,.out_partial_data  (calc_pout_int_30_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[30])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_31 (
   .cfg_truncate      (cfg_truncate_31[4:0])        //|< w
  ,.in_data           (calc_op0_int_31_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_31_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[31])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[31])      //|< r
  ,.in_valid          (calc_op_en_int_d1[31])       //|< r
  ,.out_final_data    (calc_fout_int_31_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[31])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[31])       //|> w
  ,.out_partial_data  (calc_pout_int_31_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[31])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_32 (
   .cfg_truncate      (cfg_truncate_32[4:0])        //|< w
  ,.in_data           (calc_op0_int_32_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_32_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[32])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[32])      //|< r
  ,.in_valid          (calc_op_en_int_d1[32])       //|< r
  ,.out_final_data    (calc_fout_int_32_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[32])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[32])       //|> w
  ,.out_partial_data  (calc_pout_int_32_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[32])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_33 (
   .cfg_truncate      (cfg_truncate_33[4:0])        //|< w
  ,.in_data           (calc_op0_int_33_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_33_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[33])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[33])      //|< r
  ,.in_valid          (calc_op_en_int_d1[33])       //|< r
  ,.out_final_data    (calc_fout_int_33_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[33])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[33])       //|> w
  ,.out_partial_data  (calc_pout_int_33_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[33])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_34 (
   .cfg_truncate      (cfg_truncate_34[4:0])        //|< w
  ,.in_data           (calc_op0_int_34_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_34_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[34])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[34])      //|< r
  ,.in_valid          (calc_op_en_int_d1[34])       //|< r
  ,.out_final_data    (calc_fout_int_34_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[34])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[34])       //|> w
  ,.out_partial_data  (calc_pout_int_34_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[34])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_35 (
   .cfg_truncate      (cfg_truncate_35[4:0])        //|< w
  ,.in_data           (calc_op0_int_35_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_35_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[35])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[35])      //|< r
  ,.in_valid          (calc_op_en_int_d1[35])       //|< r
  ,.out_final_data    (calc_fout_int_35_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[35])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[35])       //|> w
  ,.out_partial_data  (calc_pout_int_35_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[35])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_36 (
   .cfg_truncate      (cfg_truncate_36[4:0])        //|< w
  ,.in_data           (calc_op0_int_36_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_36_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[36])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[36])      //|< r
  ,.in_valid          (calc_op_en_int_d1[36])       //|< r
  ,.out_final_data    (calc_fout_int_36_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[36])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[36])       //|> w
  ,.out_partial_data  (calc_pout_int_36_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[36])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_37 (
   .cfg_truncate      (cfg_truncate_37[4:0])        //|< w
  ,.in_data           (calc_op0_int_37_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_37_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[37])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[37])      //|< r
  ,.in_valid          (calc_op_en_int_d1[37])       //|< r
  ,.out_final_data    (calc_fout_int_37_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[37])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[37])       //|> w
  ,.out_partial_data  (calc_pout_int_37_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[37])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_38 (
   .cfg_truncate      (cfg_truncate_38[4:0])        //|< w
  ,.in_data           (calc_op0_int_38_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_38_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[38])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[38])      //|< r
  ,.in_valid          (calc_op_en_int_d1[38])       //|< r
  ,.out_final_data    (calc_fout_int_38_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[38])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[38])       //|> w
  ,.out_partial_data  (calc_pout_int_38_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[38])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_39 (
   .cfg_truncate      (cfg_truncate_39[4:0])        //|< w
  ,.in_data           (calc_op0_int_39_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_39_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[39])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[39])      //|< r
  ,.in_valid          (calc_op_en_int_d1[39])       //|< r
  ,.out_final_data    (calc_fout_int_39_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[39])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[39])       //|> w
  ,.out_partial_data  (calc_pout_int_39_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[39])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_40 (
   .cfg_truncate      (cfg_truncate_40[4:0])        //|< w
  ,.in_data           (calc_op0_int_40_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_40_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[40])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[40])      //|< r
  ,.in_valid          (calc_op_en_int_d1[40])       //|< r
  ,.out_final_data    (calc_fout_int_40_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[40])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[40])       //|> w
  ,.out_partial_data  (calc_pout_int_40_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[40])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_41 (
   .cfg_truncate      (cfg_truncate_41[4:0])        //|< w
  ,.in_data           (calc_op0_int_41_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_41_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[41])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[41])      //|< r
  ,.in_valid          (calc_op_en_int_d1[41])       //|< r
  ,.out_final_data    (calc_fout_int_41_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[41])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[41])       //|> w
  ,.out_partial_data  (calc_pout_int_41_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[41])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_42 (
   .cfg_truncate      (cfg_truncate_42[4:0])        //|< w
  ,.in_data           (calc_op0_int_42_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_42_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[42])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[42])      //|< r
  ,.in_valid          (calc_op_en_int_d1[42])       //|< r
  ,.out_final_data    (calc_fout_int_42_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[42])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[42])       //|> w
  ,.out_partial_data  (calc_pout_int_42_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[42])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_43 (
   .cfg_truncate      (cfg_truncate_43[4:0])        //|< w
  ,.in_data           (calc_op0_int_43_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_43_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[43])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[43])      //|< r
  ,.in_valid          (calc_op_en_int_d1[43])       //|< r
  ,.out_final_data    (calc_fout_int_43_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[43])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[43])       //|> w
  ,.out_partial_data  (calc_pout_int_43_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[43])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_44 (
   .cfg_truncate      (cfg_truncate_44[4:0])        //|< w
  ,.in_data           (calc_op0_int_44_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_44_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[44])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[44])      //|< r
  ,.in_valid          (calc_op_en_int_d1[44])       //|< r
  ,.out_final_data    (calc_fout_int_44_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[44])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[44])       //|> w
  ,.out_partial_data  (calc_pout_int_44_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[44])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_45 (
   .cfg_truncate      (cfg_truncate_45[4:0])        //|< w
  ,.in_data           (calc_op0_int_45_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_45_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[45])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[45])      //|< r
  ,.in_valid          (calc_op_en_int_d1[45])       //|< r
  ,.out_final_data    (calc_fout_int_45_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[45])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[45])       //|> w
  ,.out_partial_data  (calc_pout_int_45_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[45])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_46 (
   .cfg_truncate      (cfg_truncate_46[4:0])        //|< w
  ,.in_data           (calc_op0_int_46_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_46_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[46])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[46])      //|< r
  ,.in_valid          (calc_op_en_int_d1[46])       //|< r
  ,.out_final_data    (calc_fout_int_46_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[46])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[46])       //|> w
  ,.out_partial_data  (calc_pout_int_46_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[46])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_47 (
   .cfg_truncate      (cfg_truncate_47[4:0])        //|< w
  ,.in_data           (calc_op0_int_47_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_47_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[47])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[47])      //|< r
  ,.in_valid          (calc_op_en_int_d1[47])       //|< r
  ,.out_final_data    (calc_fout_int_47_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[47])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[47])       //|> w
  ,.out_partial_data  (calc_pout_int_47_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[47])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_48 (
   .cfg_truncate      (cfg_truncate_48[4:0])        //|< w
  ,.in_data           (calc_op0_int_48_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_48_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[48])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[48])      //|< r
  ,.in_valid          (calc_op_en_int_d1[48])       //|< r
  ,.out_final_data    (calc_fout_int_48_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[48])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[48])       //|> w
  ,.out_partial_data  (calc_pout_int_48_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[48])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_49 (
   .cfg_truncate      (cfg_truncate_49[4:0])        //|< w
  ,.in_data           (calc_op0_int_49_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_49_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[49])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[49])      //|< r
  ,.in_valid          (calc_op_en_int_d1[49])       //|< r
  ,.out_final_data    (calc_fout_int_49_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[49])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[49])       //|> w
  ,.out_partial_data  (calc_pout_int_49_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[49])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_50 (
   .cfg_truncate      (cfg_truncate_50[4:0])        //|< w
  ,.in_data           (calc_op0_int_50_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_50_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[50])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[50])      //|< r
  ,.in_valid          (calc_op_en_int_d1[50])       //|< r
  ,.out_final_data    (calc_fout_int_50_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[50])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[50])       //|> w
  ,.out_partial_data  (calc_pout_int_50_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[50])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_51 (
   .cfg_truncate      (cfg_truncate_51[4:0])        //|< w
  ,.in_data           (calc_op0_int_51_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_51_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[51])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[51])      //|< r
  ,.in_valid          (calc_op_en_int_d1[51])       //|< r
  ,.out_final_data    (calc_fout_int_51_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[51])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[51])       //|> w
  ,.out_partial_data  (calc_pout_int_51_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[51])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_52 (
   .cfg_truncate      (cfg_truncate_52[4:0])        //|< w
  ,.in_data           (calc_op0_int_52_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_52_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[52])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[52])      //|< r
  ,.in_valid          (calc_op_en_int_d1[52])       //|< r
  ,.out_final_data    (calc_fout_int_52_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[52])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[52])       //|> w
  ,.out_partial_data  (calc_pout_int_52_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[52])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_53 (
   .cfg_truncate      (cfg_truncate_53[4:0])        //|< w
  ,.in_data           (calc_op0_int_53_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_53_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[53])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[53])      //|< r
  ,.in_valid          (calc_op_en_int_d1[53])       //|< r
  ,.out_final_data    (calc_fout_int_53_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[53])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[53])       //|> w
  ,.out_partial_data  (calc_pout_int_53_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[53])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_54 (
   .cfg_truncate      (cfg_truncate_54[4:0])        //|< w
  ,.in_data           (calc_op0_int_54_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_54_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[54])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[54])      //|< r
  ,.in_valid          (calc_op_en_int_d1[54])       //|< r
  ,.out_final_data    (calc_fout_int_54_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[54])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[54])       //|> w
  ,.out_partial_data  (calc_pout_int_54_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[54])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_55 (
   .cfg_truncate      (cfg_truncate_55[4:0])        //|< w
  ,.in_data           (calc_op0_int_55_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_55_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[55])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[55])      //|< r
  ,.in_valid          (calc_op_en_int_d1[55])       //|< r
  ,.out_final_data    (calc_fout_int_55_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[55])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[55])       //|> w
  ,.out_partial_data  (calc_pout_int_55_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[55])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_56 (
   .cfg_truncate      (cfg_truncate_56[4:0])        //|< w
  ,.in_data           (calc_op0_int_56_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_56_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[56])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[56])      //|< r
  ,.in_valid          (calc_op_en_int_d1[56])       //|< r
  ,.out_final_data    (calc_fout_int_56_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[56])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[56])       //|> w
  ,.out_partial_data  (calc_pout_int_56_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[56])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_57 (
   .cfg_truncate      (cfg_truncate_57[4:0])        //|< w
  ,.in_data           (calc_op0_int_57_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_57_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[57])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[57])      //|< r
  ,.in_valid          (calc_op_en_int_d1[57])       //|< r
  ,.out_final_data    (calc_fout_int_57_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[57])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[57])       //|> w
  ,.out_partial_data  (calc_pout_int_57_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[57])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_58 (
   .cfg_truncate      (cfg_truncate_58[4:0])        //|< w
  ,.in_data           (calc_op0_int_58_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_58_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[58])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[58])      //|< r
  ,.in_valid          (calc_op_en_int_d1[58])       //|< r
  ,.out_final_data    (calc_fout_int_58_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[58])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[58])       //|> w
  ,.out_partial_data  (calc_pout_int_58_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[58])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_59 (
   .cfg_truncate      (cfg_truncate_59[4:0])        //|< w
  ,.in_data           (calc_op0_int_59_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_59_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[59])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[59])      //|< r
  ,.in_valid          (calc_op_en_int_d1[59])       //|< r
  ,.out_final_data    (calc_fout_int_59_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[59])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[59])       //|> w
  ,.out_partial_data  (calc_pout_int_59_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[59])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_60 (
   .cfg_truncate      (cfg_truncate_60[4:0])        //|< w
  ,.in_data           (calc_op0_int_60_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_60_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[60])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[60])      //|< r
  ,.in_valid          (calc_op_en_int_d1[60])       //|< r
  ,.out_final_data    (calc_fout_int_60_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[60])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[60])       //|> w
  ,.out_partial_data  (calc_pout_int_60_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[60])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_61 (
   .cfg_truncate      (cfg_truncate_61[4:0])        //|< w
  ,.in_data           (calc_op0_int_61_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_61_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[61])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[61])      //|< r
  ,.in_valid          (calc_op_en_int_d1[61])       //|< r
  ,.out_final_data    (calc_fout_int_61_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[61])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[61])       //|> w
  ,.out_partial_data  (calc_pout_int_61_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[61])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_62 (
   .cfg_truncate      (cfg_truncate_62[4:0])        //|< w
  ,.in_data           (calc_op0_int_62_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_62_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[62])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[62])      //|< r
  ,.in_valid          (calc_op_en_int_d1[62])       //|< r
  ,.out_final_data    (calc_fout_int_62_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[62])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[62])       //|> w
  ,.out_partial_data  (calc_pout_int_62_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[62])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int16 u_cell_int_63 (
   .cfg_truncate      (cfg_truncate_63[4:0])        //|< w
  ,.in_data           (calc_op0_int_63_d1[37:0])    //|< r
  ,.in_op             (calc_op1_int_63_d1[47:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[63])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[63])      //|< r
  ,.in_valid          (calc_op_en_int_d1[63])       //|< r
  ,.out_final_data    (calc_fout_int_63_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[63])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[63])       //|> w
  ,.out_partial_data  (calc_pout_int_63_sum[47:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[63])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );






NV_NVDLA_CACC_CALC_int8 u_cell_int_64 (
   .cfg_truncate      (cfg_truncate_64[4:0])        //|< w
  ,.in_data           (calc_op0_int_64_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_64_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[64])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[64])      //|< r
  ,.in_valid          (calc_op_en_int_d1[64])       //|< r
  ,.out_final_data    (calc_fout_int_64_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[64])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[64])       //|> w
  ,.out_partial_data  (calc_pout_int_64_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[64])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_65 (
   .cfg_truncate      (cfg_truncate_65[4:0])        //|< w
  ,.in_data           (calc_op0_int_65_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_65_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[65])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[65])      //|< r
  ,.in_valid          (calc_op_en_int_d1[65])       //|< r
  ,.out_final_data    (calc_fout_int_65_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[65])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[65])       //|> w
  ,.out_partial_data  (calc_pout_int_65_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[65])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_66 (
   .cfg_truncate      (cfg_truncate_66[4:0])        //|< w
  ,.in_data           (calc_op0_int_66_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_66_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[66])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[66])      //|< r
  ,.in_valid          (calc_op_en_int_d1[66])       //|< r
  ,.out_final_data    (calc_fout_int_66_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[66])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[66])       //|> w
  ,.out_partial_data  (calc_pout_int_66_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[66])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_67 (
   .cfg_truncate      (cfg_truncate_67[4:0])        //|< w
  ,.in_data           (calc_op0_int_67_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_67_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[67])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[67])      //|< r
  ,.in_valid          (calc_op_en_int_d1[67])       //|< r
  ,.out_final_data    (calc_fout_int_67_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[67])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[67])       //|> w
  ,.out_partial_data  (calc_pout_int_67_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[67])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_68 (
   .cfg_truncate      (cfg_truncate_68[4:0])        //|< w
  ,.in_data           (calc_op0_int_68_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_68_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[68])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[68])      //|< r
  ,.in_valid          (calc_op_en_int_d1[68])       //|< r
  ,.out_final_data    (calc_fout_int_68_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[68])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[68])       //|> w
  ,.out_partial_data  (calc_pout_int_68_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[68])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_69 (
   .cfg_truncate      (cfg_truncate_69[4:0])        //|< w
  ,.in_data           (calc_op0_int_69_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_69_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[69])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[69])      //|< r
  ,.in_valid          (calc_op_en_int_d1[69])       //|< r
  ,.out_final_data    (calc_fout_int_69_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[69])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[69])       //|> w
  ,.out_partial_data  (calc_pout_int_69_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[69])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_70 (
   .cfg_truncate      (cfg_truncate_70[4:0])        //|< w
  ,.in_data           (calc_op0_int_70_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_70_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[70])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[70])      //|< r
  ,.in_valid          (calc_op_en_int_d1[70])       //|< r
  ,.out_final_data    (calc_fout_int_70_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[70])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[70])       //|> w
  ,.out_partial_data  (calc_pout_int_70_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[70])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_71 (
   .cfg_truncate      (cfg_truncate_71[4:0])        //|< w
  ,.in_data           (calc_op0_int_71_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_71_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[71])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[71])      //|< r
  ,.in_valid          (calc_op_en_int_d1[71])       //|< r
  ,.out_final_data    (calc_fout_int_71_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[71])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[71])       //|> w
  ,.out_partial_data  (calc_pout_int_71_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[71])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_72 (
   .cfg_truncate      (cfg_truncate_72[4:0])        //|< w
  ,.in_data           (calc_op0_int_72_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_72_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[72])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[72])      //|< r
  ,.in_valid          (calc_op_en_int_d1[72])       //|< r
  ,.out_final_data    (calc_fout_int_72_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[72])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[72])       //|> w
  ,.out_partial_data  (calc_pout_int_72_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[72])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_73 (
   .cfg_truncate      (cfg_truncate_73[4:0])        //|< w
  ,.in_data           (calc_op0_int_73_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_73_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[73])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[73])      //|< r
  ,.in_valid          (calc_op_en_int_d1[73])       //|< r
  ,.out_final_data    (calc_fout_int_73_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[73])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[73])       //|> w
  ,.out_partial_data  (calc_pout_int_73_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[73])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_74 (
   .cfg_truncate      (cfg_truncate_74[4:0])        //|< w
  ,.in_data           (calc_op0_int_74_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_74_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[74])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[74])      //|< r
  ,.in_valid          (calc_op_en_int_d1[74])       //|< r
  ,.out_final_data    (calc_fout_int_74_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[74])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[74])       //|> w
  ,.out_partial_data  (calc_pout_int_74_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[74])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_75 (
   .cfg_truncate      (cfg_truncate_75[4:0])        //|< w
  ,.in_data           (calc_op0_int_75_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_75_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[75])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[75])      //|< r
  ,.in_valid          (calc_op_en_int_d1[75])       //|< r
  ,.out_final_data    (calc_fout_int_75_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[75])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[75])       //|> w
  ,.out_partial_data  (calc_pout_int_75_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[75])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_76 (
   .cfg_truncate      (cfg_truncate_76[4:0])        //|< w
  ,.in_data           (calc_op0_int_76_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_76_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[76])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[76])      //|< r
  ,.in_valid          (calc_op_en_int_d1[76])       //|< r
  ,.out_final_data    (calc_fout_int_76_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[76])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[76])       //|> w
  ,.out_partial_data  (calc_pout_int_76_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[76])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_77 (
   .cfg_truncate      (cfg_truncate_77[4:0])        //|< w
  ,.in_data           (calc_op0_int_77_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_77_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[77])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[77])      //|< r
  ,.in_valid          (calc_op_en_int_d1[77])       //|< r
  ,.out_final_data    (calc_fout_int_77_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[77])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[77])       //|> w
  ,.out_partial_data  (calc_pout_int_77_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[77])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_78 (
   .cfg_truncate      (cfg_truncate_78[4:0])        //|< w
  ,.in_data           (calc_op0_int_78_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_78_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[78])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[78])      //|< r
  ,.in_valid          (calc_op_en_int_d1[78])       //|< r
  ,.out_final_data    (calc_fout_int_78_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[78])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[78])       //|> w
  ,.out_partial_data  (calc_pout_int_78_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[78])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_79 (
   .cfg_truncate      (cfg_truncate_79[4:0])        //|< w
  ,.in_data           (calc_op0_int_79_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_79_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[79])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[79])      //|< r
  ,.in_valid          (calc_op_en_int_d1[79])       //|< r
  ,.out_final_data    (calc_fout_int_79_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[79])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[79])       //|> w
  ,.out_partial_data  (calc_pout_int_79_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[79])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_0)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );






NV_NVDLA_CACC_CALC_int8 u_cell_int_80 (
   .cfg_truncate      (cfg_truncate_80[4:0])        //|< w
  ,.in_data           (calc_op0_int_80_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_80_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[80])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[80])      //|< r
  ,.in_valid          (calc_op_en_int_d1[80])       //|< r
  ,.out_final_data    (calc_fout_int_80_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[80])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[80])       //|> w
  ,.out_partial_data  (calc_pout_int_80_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[80])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_81 (
   .cfg_truncate      (cfg_truncate_81[4:0])        //|< w
  ,.in_data           (calc_op0_int_81_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_81_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[81])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[81])      //|< r
  ,.in_valid          (calc_op_en_int_d1[81])       //|< r
  ,.out_final_data    (calc_fout_int_81_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[81])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[81])       //|> w
  ,.out_partial_data  (calc_pout_int_81_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[81])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_82 (
   .cfg_truncate      (cfg_truncate_82[4:0])        //|< w
  ,.in_data           (calc_op0_int_82_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_82_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[82])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[82])      //|< r
  ,.in_valid          (calc_op_en_int_d1[82])       //|< r
  ,.out_final_data    (calc_fout_int_82_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[82])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[82])       //|> w
  ,.out_partial_data  (calc_pout_int_82_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[82])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_83 (
   .cfg_truncate      (cfg_truncate_83[4:0])        //|< w
  ,.in_data           (calc_op0_int_83_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_83_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[83])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[83])      //|< r
  ,.in_valid          (calc_op_en_int_d1[83])       //|< r
  ,.out_final_data    (calc_fout_int_83_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[83])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[83])       //|> w
  ,.out_partial_data  (calc_pout_int_83_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[83])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_84 (
   .cfg_truncate      (cfg_truncate_84[4:0])        //|< w
  ,.in_data           (calc_op0_int_84_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_84_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[84])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[84])      //|< r
  ,.in_valid          (calc_op_en_int_d1[84])       //|< r
  ,.out_final_data    (calc_fout_int_84_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[84])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[84])       //|> w
  ,.out_partial_data  (calc_pout_int_84_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[84])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_85 (
   .cfg_truncate      (cfg_truncate_85[4:0])        //|< w
  ,.in_data           (calc_op0_int_85_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_85_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[85])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[85])      //|< r
  ,.in_valid          (calc_op_en_int_d1[85])       //|< r
  ,.out_final_data    (calc_fout_int_85_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[85])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[85])       //|> w
  ,.out_partial_data  (calc_pout_int_85_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[85])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_86 (
   .cfg_truncate      (cfg_truncate_86[4:0])        //|< w
  ,.in_data           (calc_op0_int_86_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_86_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[86])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[86])      //|< r
  ,.in_valid          (calc_op_en_int_d1[86])       //|< r
  ,.out_final_data    (calc_fout_int_86_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[86])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[86])       //|> w
  ,.out_partial_data  (calc_pout_int_86_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[86])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_87 (
   .cfg_truncate      (cfg_truncate_87[4:0])        //|< w
  ,.in_data           (calc_op0_int_87_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_87_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[87])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[87])      //|< r
  ,.in_valid          (calc_op_en_int_d1[87])       //|< r
  ,.out_final_data    (calc_fout_int_87_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[87])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[87])       //|> w
  ,.out_partial_data  (calc_pout_int_87_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[87])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_88 (
   .cfg_truncate      (cfg_truncate_88[4:0])        //|< w
  ,.in_data           (calc_op0_int_88_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_88_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[88])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[88])      //|< r
  ,.in_valid          (calc_op_en_int_d1[88])       //|< r
  ,.out_final_data    (calc_fout_int_88_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[88])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[88])       //|> w
  ,.out_partial_data  (calc_pout_int_88_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[88])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_89 (
   .cfg_truncate      (cfg_truncate_89[4:0])        //|< w
  ,.in_data           (calc_op0_int_89_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_89_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[89])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[89])      //|< r
  ,.in_valid          (calc_op_en_int_d1[89])       //|< r
  ,.out_final_data    (calc_fout_int_89_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[89])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[89])       //|> w
  ,.out_partial_data  (calc_pout_int_89_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[89])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_90 (
   .cfg_truncate      (cfg_truncate_90[4:0])        //|< w
  ,.in_data           (calc_op0_int_90_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_90_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[90])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[90])      //|< r
  ,.in_valid          (calc_op_en_int_d1[90])       //|< r
  ,.out_final_data    (calc_fout_int_90_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[90])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[90])       //|> w
  ,.out_partial_data  (calc_pout_int_90_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[90])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_91 (
   .cfg_truncate      (cfg_truncate_91[4:0])        //|< w
  ,.in_data           (calc_op0_int_91_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_91_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[91])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[91])      //|< r
  ,.in_valid          (calc_op_en_int_d1[91])       //|< r
  ,.out_final_data    (calc_fout_int_91_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[91])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[91])       //|> w
  ,.out_partial_data  (calc_pout_int_91_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[91])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_92 (
   .cfg_truncate      (cfg_truncate_92[4:0])        //|< w
  ,.in_data           (calc_op0_int_92_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_92_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[92])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[92])      //|< r
  ,.in_valid          (calc_op_en_int_d1[92])       //|< r
  ,.out_final_data    (calc_fout_int_92_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[92])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[92])       //|> w
  ,.out_partial_data  (calc_pout_int_92_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[92])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_93 (
   .cfg_truncate      (cfg_truncate_93[4:0])        //|< w
  ,.in_data           (calc_op0_int_93_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_93_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[93])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[93])      //|< r
  ,.in_valid          (calc_op_en_int_d1[93])       //|< r
  ,.out_final_data    (calc_fout_int_93_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[93])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[93])       //|> w
  ,.out_partial_data  (calc_pout_int_93_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[93])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_94 (
   .cfg_truncate      (cfg_truncate_94[4:0])        //|< w
  ,.in_data           (calc_op0_int_94_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_94_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[94])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[94])      //|< r
  ,.in_valid          (calc_op_en_int_d1[94])       //|< r
  ,.out_final_data    (calc_fout_int_94_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[94])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[94])       //|> w
  ,.out_partial_data  (calc_pout_int_94_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[94])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_95 (
   .cfg_truncate      (cfg_truncate_95[4:0])        //|< w
  ,.in_data           (calc_op0_int_95_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_95_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[95])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[95])      //|< r
  ,.in_valid          (calc_op_en_int_d1[95])       //|< r
  ,.out_final_data    (calc_fout_int_95_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[95])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[95])       //|> w
  ,.out_partial_data  (calc_pout_int_95_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[95])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_96 (
   .cfg_truncate      (cfg_truncate_96[4:0])        //|< w
  ,.in_data           (calc_op0_int_96_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_96_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[96])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[96])      //|< r
  ,.in_valid          (calc_op_en_int_d1[96])       //|< r
  ,.out_final_data    (calc_fout_int_96_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[96])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[96])       //|> w
  ,.out_partial_data  (calc_pout_int_96_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[96])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_97 (
   .cfg_truncate      (cfg_truncate_97[4:0])        //|< w
  ,.in_data           (calc_op0_int_97_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_97_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[97])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[97])      //|< r
  ,.in_valid          (calc_op_en_int_d1[97])       //|< r
  ,.out_final_data    (calc_fout_int_97_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[97])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[97])       //|> w
  ,.out_partial_data  (calc_pout_int_97_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[97])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_98 (
   .cfg_truncate      (cfg_truncate_98[4:0])        //|< w
  ,.in_data           (calc_op0_int_98_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_98_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[98])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[98])      //|< r
  ,.in_valid          (calc_op_en_int_d1[98])       //|< r
  ,.out_final_data    (calc_fout_int_98_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[98])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[98])       //|> w
  ,.out_partial_data  (calc_pout_int_98_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[98])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_99 (
   .cfg_truncate      (cfg_truncate_99[4:0])        //|< w
  ,.in_data           (calc_op0_int_99_d1[21:0])    //|< r
  ,.in_op             (calc_op1_int_99_d1[33:0])    //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[99])     //|< r
  ,.in_sel            (calc_dlv_en_int_d1[99])      //|< r
  ,.in_valid          (calc_op_en_int_d1[99])       //|< r
  ,.out_final_data    (calc_fout_int_99_sum[31:0])  //|> w
  ,.out_final_sat     (calc_fout_int_sat[99])       //|> w
  ,.out_final_valid   (calc_fout_int_vld[99])       //|> w
  ,.out_partial_data  (calc_pout_int_99_sum[33:0])  //|> w
  ,.out_partial_valid (calc_pout_int_vld[99])       //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_100 (
   .cfg_truncate      (cfg_truncate_100[4:0])       //|< w
  ,.in_data           (calc_op0_int_100_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_100_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[100])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[100])     //|< r
  ,.in_valid          (calc_op_en_int_d1[100])      //|< r
  ,.out_final_data    (calc_fout_int_100_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[100])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[100])      //|> w
  ,.out_partial_data  (calc_pout_int_100_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[100])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_101 (
   .cfg_truncate      (cfg_truncate_101[4:0])       //|< w
  ,.in_data           (calc_op0_int_101_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_101_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[101])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[101])     //|< r
  ,.in_valid          (calc_op_en_int_d1[101])      //|< r
  ,.out_final_data    (calc_fout_int_101_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[101])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[101])      //|> w
  ,.out_partial_data  (calc_pout_int_101_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[101])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_102 (
   .cfg_truncate      (cfg_truncate_102[4:0])       //|< w
  ,.in_data           (calc_op0_int_102_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_102_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[102])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[102])     //|< r
  ,.in_valid          (calc_op_en_int_d1[102])      //|< r
  ,.out_final_data    (calc_fout_int_102_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[102])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[102])      //|> w
  ,.out_partial_data  (calc_pout_int_102_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[102])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_103 (
   .cfg_truncate      (cfg_truncate_103[4:0])       //|< w
  ,.in_data           (calc_op0_int_103_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_103_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[103])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[103])     //|< r
  ,.in_valid          (calc_op_en_int_d1[103])      //|< r
  ,.out_final_data    (calc_fout_int_103_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[103])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[103])      //|> w
  ,.out_partial_data  (calc_pout_int_103_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[103])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_104 (
   .cfg_truncate      (cfg_truncate_104[4:0])       //|< w
  ,.in_data           (calc_op0_int_104_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_104_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[104])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[104])     //|< r
  ,.in_valid          (calc_op_en_int_d1[104])      //|< r
  ,.out_final_data    (calc_fout_int_104_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[104])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[104])      //|> w
  ,.out_partial_data  (calc_pout_int_104_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[104])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_105 (
   .cfg_truncate      (cfg_truncate_105[4:0])       //|< w
  ,.in_data           (calc_op0_int_105_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_105_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[105])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[105])     //|< r
  ,.in_valid          (calc_op_en_int_d1[105])      //|< r
  ,.out_final_data    (calc_fout_int_105_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[105])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[105])      //|> w
  ,.out_partial_data  (calc_pout_int_105_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[105])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_106 (
   .cfg_truncate      (cfg_truncate_106[4:0])       //|< w
  ,.in_data           (calc_op0_int_106_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_106_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[106])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[106])     //|< r
  ,.in_valid          (calc_op_en_int_d1[106])      //|< r
  ,.out_final_data    (calc_fout_int_106_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[106])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[106])      //|> w
  ,.out_partial_data  (calc_pout_int_106_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[106])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_107 (
   .cfg_truncate      (cfg_truncate_107[4:0])       //|< w
  ,.in_data           (calc_op0_int_107_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_107_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[107])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[107])     //|< r
  ,.in_valid          (calc_op_en_int_d1[107])      //|< r
  ,.out_final_data    (calc_fout_int_107_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[107])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[107])      //|> w
  ,.out_partial_data  (calc_pout_int_107_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[107])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_108 (
   .cfg_truncate      (cfg_truncate_108[4:0])       //|< w
  ,.in_data           (calc_op0_int_108_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_108_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[108])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[108])     //|< r
  ,.in_valid          (calc_op_en_int_d1[108])      //|< r
  ,.out_final_data    (calc_fout_int_108_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[108])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[108])      //|> w
  ,.out_partial_data  (calc_pout_int_108_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[108])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_109 (
   .cfg_truncate      (cfg_truncate_109[4:0])       //|< w
  ,.in_data           (calc_op0_int_109_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_109_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[109])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[109])     //|< r
  ,.in_valid          (calc_op_en_int_d1[109])      //|< r
  ,.out_final_data    (calc_fout_int_109_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[109])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[109])      //|> w
  ,.out_partial_data  (calc_pout_int_109_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[109])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_110 (
   .cfg_truncate      (cfg_truncate_110[4:0])       //|< w
  ,.in_data           (calc_op0_int_110_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_110_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[110])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[110])     //|< r
  ,.in_valid          (calc_op_en_int_d1[110])      //|< r
  ,.out_final_data    (calc_fout_int_110_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[110])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[110])      //|> w
  ,.out_partial_data  (calc_pout_int_110_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[110])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_111 (
   .cfg_truncate      (cfg_truncate_111[4:0])       //|< w
  ,.in_data           (calc_op0_int_111_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_111_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[111])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[111])     //|< r
  ,.in_valid          (calc_op_en_int_d1[111])      //|< r
  ,.out_final_data    (calc_fout_int_111_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[111])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[111])      //|> w
  ,.out_partial_data  (calc_pout_int_111_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[111])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_112 (
   .cfg_truncate      (cfg_truncate_112[4:0])       //|< w
  ,.in_data           (calc_op0_int_112_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_112_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[112])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[112])     //|< r
  ,.in_valid          (calc_op_en_int_d1[112])      //|< r
  ,.out_final_data    (calc_fout_int_112_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[112])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[112])      //|> w
  ,.out_partial_data  (calc_pout_int_112_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[112])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_113 (
   .cfg_truncate      (cfg_truncate_113[4:0])       //|< w
  ,.in_data           (calc_op0_int_113_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_113_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[113])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[113])     //|< r
  ,.in_valid          (calc_op_en_int_d1[113])      //|< r
  ,.out_final_data    (calc_fout_int_113_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[113])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[113])      //|> w
  ,.out_partial_data  (calc_pout_int_113_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[113])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_114 (
   .cfg_truncate      (cfg_truncate_114[4:0])       //|< w
  ,.in_data           (calc_op0_int_114_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_114_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[114])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[114])     //|< r
  ,.in_valid          (calc_op_en_int_d1[114])      //|< r
  ,.out_final_data    (calc_fout_int_114_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[114])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[114])      //|> w
  ,.out_partial_data  (calc_pout_int_114_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[114])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_115 (
   .cfg_truncate      (cfg_truncate_115[4:0])       //|< w
  ,.in_data           (calc_op0_int_115_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_115_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[115])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[115])     //|< r
  ,.in_valid          (calc_op_en_int_d1[115])      //|< r
  ,.out_final_data    (calc_fout_int_115_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[115])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[115])      //|> w
  ,.out_partial_data  (calc_pout_int_115_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[115])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_116 (
   .cfg_truncate      (cfg_truncate_116[4:0])       //|< w
  ,.in_data           (calc_op0_int_116_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_116_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[116])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[116])     //|< r
  ,.in_valid          (calc_op_en_int_d1[116])      //|< r
  ,.out_final_data    (calc_fout_int_116_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[116])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[116])      //|> w
  ,.out_partial_data  (calc_pout_int_116_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[116])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_117 (
   .cfg_truncate      (cfg_truncate_117[4:0])       //|< w
  ,.in_data           (calc_op0_int_117_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_117_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[117])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[117])     //|< r
  ,.in_valid          (calc_op_en_int_d1[117])      //|< r
  ,.out_final_data    (calc_fout_int_117_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[117])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[117])      //|> w
  ,.out_partial_data  (calc_pout_int_117_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[117])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_118 (
   .cfg_truncate      (cfg_truncate_118[4:0])       //|< w
  ,.in_data           (calc_op0_int_118_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_118_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[118])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[118])     //|< r
  ,.in_valid          (calc_op_en_int_d1[118])      //|< r
  ,.out_final_data    (calc_fout_int_118_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[118])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[118])      //|> w
  ,.out_partial_data  (calc_pout_int_118_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[118])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_119 (
   .cfg_truncate      (cfg_truncate_119[4:0])       //|< w
  ,.in_data           (calc_op0_int_119_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_119_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[119])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[119])     //|< r
  ,.in_valid          (calc_op_en_int_d1[119])      //|< r
  ,.out_final_data    (calc_fout_int_119_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[119])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[119])      //|> w
  ,.out_partial_data  (calc_pout_int_119_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[119])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_120 (
   .cfg_truncate      (cfg_truncate_120[4:0])       //|< w
  ,.in_data           (calc_op0_int_120_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_120_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[120])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[120])     //|< r
  ,.in_valid          (calc_op_en_int_d1[120])      //|< r
  ,.out_final_data    (calc_fout_int_120_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[120])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[120])      //|> w
  ,.out_partial_data  (calc_pout_int_120_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[120])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_121 (
   .cfg_truncate      (cfg_truncate_121[4:0])       //|< w
  ,.in_data           (calc_op0_int_121_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_121_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[121])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[121])     //|< r
  ,.in_valid          (calc_op_en_int_d1[121])      //|< r
  ,.out_final_data    (calc_fout_int_121_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[121])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[121])      //|> w
  ,.out_partial_data  (calc_pout_int_121_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[121])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_122 (
   .cfg_truncate      (cfg_truncate_122[4:0])       //|< w
  ,.in_data           (calc_op0_int_122_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_122_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[122])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[122])     //|< r
  ,.in_valid          (calc_op_en_int_d1[122])      //|< r
  ,.out_final_data    (calc_fout_int_122_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[122])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[122])      //|> w
  ,.out_partial_data  (calc_pout_int_122_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[122])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_123 (
   .cfg_truncate      (cfg_truncate_123[4:0])       //|< w
  ,.in_data           (calc_op0_int_123_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_123_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[123])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[123])     //|< r
  ,.in_valid          (calc_op_en_int_d1[123])      //|< r
  ,.out_final_data    (calc_fout_int_123_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[123])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[123])      //|> w
  ,.out_partial_data  (calc_pout_int_123_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[123])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_124 (
   .cfg_truncate      (cfg_truncate_124[4:0])       //|< w
  ,.in_data           (calc_op0_int_124_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_124_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[124])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[124])     //|< r
  ,.in_valid          (calc_op_en_int_d1[124])      //|< r
  ,.out_final_data    (calc_fout_int_124_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[124])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[124])      //|> w
  ,.out_partial_data  (calc_pout_int_124_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[124])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_125 (
   .cfg_truncate      (cfg_truncate_125[4:0])       //|< w
  ,.in_data           (calc_op0_int_125_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_125_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[125])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[125])     //|< r
  ,.in_valid          (calc_op_en_int_d1[125])      //|< r
  ,.out_final_data    (calc_fout_int_125_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[125])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[125])      //|> w
  ,.out_partial_data  (calc_pout_int_125_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[125])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_126 (
   .cfg_truncate      (cfg_truncate_126[4:0])       //|< w
  ,.in_data           (calc_op0_int_126_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_126_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[126])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[126])     //|< r
  ,.in_valid          (calc_op_en_int_d1[126])      //|< r
  ,.out_final_data    (calc_fout_int_126_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[126])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[126])      //|> w
  ,.out_partial_data  (calc_pout_int_126_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[126])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_int8 u_cell_int_127 (
   .cfg_truncate      (cfg_truncate_127[4:0])       //|< w
  ,.in_data           (calc_op0_int_127_d1[21:0])   //|< r
  ,.in_op             (calc_op1_int_127_d1[33:0])   //|< r
  ,.in_op_valid       (calc_op1_vld_int_d1[127])    //|< r
  ,.in_sel            (calc_dlv_en_int_d1[127])     //|< r
  ,.in_valid          (calc_op_en_int_d1[127])      //|< r
  ,.out_final_data    (calc_fout_int_127_sum[31:0]) //|> w
  ,.out_final_sat     (calc_fout_int_sat[127])      //|> w
  ,.out_final_valid   (calc_fout_int_vld[127])      //|> w
  ,.out_partial_data  (calc_pout_int_127_sum[33:0]) //|> w
  ,.out_partial_valid (calc_pout_int_vld[127])      //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_1)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );






NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_0 (
   .in_data           (calc_op0_fp_0_d1[43:0])      //|< r
  ,.in_op             (calc_op1_fp_0_d1[47:0])      //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[0])       //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[0])        //|< r
  ,.in_valid          (calc_op_en_fp_d1[0])         //|< r
  ,.out_final_data    (calc_fout_fp_0_sum[31:0])    //|> w
  ,.out_final_valid   (calc_fout_fp_vld[0])         //|> w
  ,.out_partial_data  (calc_pout_fp_0_sum[47:0])    //|> w
  ,.out_partial_valid (calc_pout_fp_vld[0])         //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_1 (
   .in_data           (calc_op0_fp_1_d1[43:0])      //|< r
  ,.in_op             (calc_op1_fp_1_d1[47:0])      //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[1])       //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[1])        //|< r
  ,.in_valid          (calc_op_en_fp_d1[1])         //|< r
  ,.out_final_data    (calc_fout_fp_1_sum[31:0])    //|> w
  ,.out_final_valid   (calc_fout_fp_vld[1])         //|> w
  ,.out_partial_data  (calc_pout_fp_1_sum[47:0])    //|> w
  ,.out_partial_valid (calc_pout_fp_vld[1])         //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_2 (
   .in_data           (calc_op0_fp_2_d1[43:0])      //|< r
  ,.in_op             (calc_op1_fp_2_d1[47:0])      //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[2])       //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[2])        //|< r
  ,.in_valid          (calc_op_en_fp_d1[2])         //|< r
  ,.out_final_data    (calc_fout_fp_2_sum[31:0])    //|> w
  ,.out_final_valid   (calc_fout_fp_vld[2])         //|> w
  ,.out_partial_data  (calc_pout_fp_2_sum[47:0])    //|> w
  ,.out_partial_valid (calc_pout_fp_vld[2])         //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_3 (
   .in_data           (calc_op0_fp_3_d1[43:0])      //|< r
  ,.in_op             (calc_op1_fp_3_d1[47:0])      //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[3])       //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[3])        //|< r
  ,.in_valid          (calc_op_en_fp_d1[3])         //|< r
  ,.out_final_data    (calc_fout_fp_3_sum[31:0])    //|> w
  ,.out_final_valid   (calc_fout_fp_vld[3])         //|> w
  ,.out_partial_data  (calc_pout_fp_3_sum[47:0])    //|> w
  ,.out_partial_valid (calc_pout_fp_vld[3])         //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_4 (
   .in_data           (calc_op0_fp_4_d1[43:0])      //|< r
  ,.in_op             (calc_op1_fp_4_d1[47:0])      //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[4])       //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[4])        //|< r
  ,.in_valid          (calc_op_en_fp_d1[4])         //|< r
  ,.out_final_data    (calc_fout_fp_4_sum[31:0])    //|> w
  ,.out_final_valid   (calc_fout_fp_vld[4])         //|> w
  ,.out_partial_data  (calc_pout_fp_4_sum[47:0])    //|> w
  ,.out_partial_valid (calc_pout_fp_vld[4])         //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_5 (
   .in_data           (calc_op0_fp_5_d1[43:0])      //|< r
  ,.in_op             (calc_op1_fp_5_d1[47:0])      //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[5])       //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[5])        //|< r
  ,.in_valid          (calc_op_en_fp_d1[5])         //|< r
  ,.out_final_data    (calc_fout_fp_5_sum[31:0])    //|> w
  ,.out_final_valid   (calc_fout_fp_vld[5])         //|> w
  ,.out_partial_data  (calc_pout_fp_5_sum[47:0])    //|> w
  ,.out_partial_valid (calc_pout_fp_vld[5])         //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_6 (
   .in_data           (calc_op0_fp_6_d1[43:0])      //|< r
  ,.in_op             (calc_op1_fp_6_d1[47:0])      //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[6])       //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[6])        //|< r
  ,.in_valid          (calc_op_en_fp_d1[6])         //|< r
  ,.out_final_data    (calc_fout_fp_6_sum[31:0])    //|> w
  ,.out_final_valid   (calc_fout_fp_vld[6])         //|> w
  ,.out_partial_data  (calc_pout_fp_6_sum[47:0])    //|> w
  ,.out_partial_valid (calc_pout_fp_vld[6])         //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_7 (
   .in_data           (calc_op0_fp_7_d1[43:0])      //|< r
  ,.in_op             (calc_op1_fp_7_d1[47:0])      //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[7])       //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[7])        //|< r
  ,.in_valid          (calc_op_en_fp_d1[7])         //|< r
  ,.out_final_data    (calc_fout_fp_7_sum[31:0])    //|> w
  ,.out_final_valid   (calc_fout_fp_vld[7])         //|> w
  ,.out_partial_data  (calc_pout_fp_7_sum[47:0])    //|> w
  ,.out_partial_valid (calc_pout_fp_vld[7])         //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_8 (
   .in_data           (calc_op0_fp_8_d1[43:0])      //|< r
  ,.in_op             (calc_op1_fp_8_d1[47:0])      //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[8])       //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[8])        //|< r
  ,.in_valid          (calc_op_en_fp_d1[8])         //|< r
  ,.out_final_data    (calc_fout_fp_8_sum[31:0])    //|> w
  ,.out_final_valid   (calc_fout_fp_vld[8])         //|> w
  ,.out_partial_data  (calc_pout_fp_8_sum[47:0])    //|> w
  ,.out_partial_valid (calc_pout_fp_vld[8])         //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_9 (
   .in_data           (calc_op0_fp_9_d1[43:0])      //|< r
  ,.in_op             (calc_op1_fp_9_d1[47:0])      //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[9])       //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[9])        //|< r
  ,.in_valid          (calc_op_en_fp_d1[9])         //|< r
  ,.out_final_data    (calc_fout_fp_9_sum[31:0])    //|> w
  ,.out_final_valid   (calc_fout_fp_vld[9])         //|> w
  ,.out_partial_data  (calc_pout_fp_9_sum[47:0])    //|> w
  ,.out_partial_valid (calc_pout_fp_vld[9])         //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_10 (
   .in_data           (calc_op0_fp_10_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_10_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[10])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[10])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[10])        //|< r
  ,.out_final_data    (calc_fout_fp_10_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[10])        //|> w
  ,.out_partial_data  (calc_pout_fp_10_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[10])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_11 (
   .in_data           (calc_op0_fp_11_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_11_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[11])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[11])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[11])        //|< r
  ,.out_final_data    (calc_fout_fp_11_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[11])        //|> w
  ,.out_partial_data  (calc_pout_fp_11_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[11])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_12 (
   .in_data           (calc_op0_fp_12_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_12_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[12])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[12])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[12])        //|< r
  ,.out_final_data    (calc_fout_fp_12_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[12])        //|> w
  ,.out_partial_data  (calc_pout_fp_12_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[12])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_13 (
   .in_data           (calc_op0_fp_13_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_13_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[13])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[13])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[13])        //|< r
  ,.out_final_data    (calc_fout_fp_13_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[13])        //|> w
  ,.out_partial_data  (calc_pout_fp_13_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[13])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_14 (
   .in_data           (calc_op0_fp_14_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_14_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[14])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[14])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[14])        //|< r
  ,.out_final_data    (calc_fout_fp_14_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[14])        //|> w
  ,.out_partial_data  (calc_pout_fp_14_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[14])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_15 (
   .in_data           (calc_op0_fp_15_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_15_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[15])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[15])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[15])        //|< r
  ,.out_final_data    (calc_fout_fp_15_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[15])        //|> w
  ,.out_partial_data  (calc_pout_fp_15_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[15])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_2)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );






NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_16 (
   .in_data           (calc_op0_fp_16_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_16_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[16])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[16])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[16])        //|< r
  ,.out_final_data    (calc_fout_fp_16_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[16])        //|> w
  ,.out_partial_data  (calc_pout_fp_16_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[16])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_17 (
   .in_data           (calc_op0_fp_17_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_17_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[17])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[17])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[17])        //|< r
  ,.out_final_data    (calc_fout_fp_17_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[17])        //|> w
  ,.out_partial_data  (calc_pout_fp_17_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[17])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_18 (
   .in_data           (calc_op0_fp_18_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_18_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[18])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[18])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[18])        //|< r
  ,.out_final_data    (calc_fout_fp_18_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[18])        //|> w
  ,.out_partial_data  (calc_pout_fp_18_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[18])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_19 (
   .in_data           (calc_op0_fp_19_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_19_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[19])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[19])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[19])        //|< r
  ,.out_final_data    (calc_fout_fp_19_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[19])        //|> w
  ,.out_partial_data  (calc_pout_fp_19_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[19])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_20 (
   .in_data           (calc_op0_fp_20_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_20_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[20])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[20])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[20])        //|< r
  ,.out_final_data    (calc_fout_fp_20_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[20])        //|> w
  ,.out_partial_data  (calc_pout_fp_20_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[20])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_21 (
   .in_data           (calc_op0_fp_21_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_21_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[21])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[21])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[21])        //|< r
  ,.out_final_data    (calc_fout_fp_21_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[21])        //|> w
  ,.out_partial_data  (calc_pout_fp_21_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[21])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_22 (
   .in_data           (calc_op0_fp_22_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_22_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[22])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[22])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[22])        //|< r
  ,.out_final_data    (calc_fout_fp_22_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[22])        //|> w
  ,.out_partial_data  (calc_pout_fp_22_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[22])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_23 (
   .in_data           (calc_op0_fp_23_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_23_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[23])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[23])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[23])        //|< r
  ,.out_final_data    (calc_fout_fp_23_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[23])        //|> w
  ,.out_partial_data  (calc_pout_fp_23_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[23])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_24 (
   .in_data           (calc_op0_fp_24_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_24_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[24])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[24])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[24])        //|< r
  ,.out_final_data    (calc_fout_fp_24_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[24])        //|> w
  ,.out_partial_data  (calc_pout_fp_24_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[24])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_25 (
   .in_data           (calc_op0_fp_25_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_25_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[25])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[25])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[25])        //|< r
  ,.out_final_data    (calc_fout_fp_25_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[25])        //|> w
  ,.out_partial_data  (calc_pout_fp_25_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[25])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_26 (
   .in_data           (calc_op0_fp_26_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_26_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[26])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[26])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[26])        //|< r
  ,.out_final_data    (calc_fout_fp_26_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[26])        //|> w
  ,.out_partial_data  (calc_pout_fp_26_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[26])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_27 (
   .in_data           (calc_op0_fp_27_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_27_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[27])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[27])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[27])        //|< r
  ,.out_final_data    (calc_fout_fp_27_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[27])        //|> w
  ,.out_partial_data  (calc_pout_fp_27_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[27])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_28 (
   .in_data           (calc_op0_fp_28_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_28_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[28])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[28])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[28])        //|< r
  ,.out_final_data    (calc_fout_fp_28_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[28])        //|> w
  ,.out_partial_data  (calc_pout_fp_28_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[28])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_29 (
   .in_data           (calc_op0_fp_29_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_29_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[29])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[29])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[29])        //|< r
  ,.out_final_data    (calc_fout_fp_29_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[29])        //|> w
  ,.out_partial_data  (calc_pout_fp_29_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[29])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_30 (
   .in_data           (calc_op0_fp_30_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_30_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[30])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[30])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[30])        //|< r
  ,.out_final_data    (calc_fout_fp_30_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[30])        //|> w
  ,.out_partial_data  (calc_pout_fp_30_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[30])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_31 (
   .in_data           (calc_op0_fp_31_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_31_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[31])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[31])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[31])        //|< r
  ,.out_final_data    (calc_fout_fp_31_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[31])        //|> w
  ,.out_partial_data  (calc_pout_fp_31_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[31])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_32 (
   .in_data           (calc_op0_fp_32_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_32_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[32])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[32])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[32])        //|< r
  ,.out_final_data    (calc_fout_fp_32_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[32])        //|> w
  ,.out_partial_data  (calc_pout_fp_32_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[32])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_33 (
   .in_data           (calc_op0_fp_33_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_33_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[33])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[33])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[33])        //|< r
  ,.out_final_data    (calc_fout_fp_33_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[33])        //|> w
  ,.out_partial_data  (calc_pout_fp_33_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[33])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_34 (
   .in_data           (calc_op0_fp_34_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_34_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[34])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[34])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[34])        //|< r
  ,.out_final_data    (calc_fout_fp_34_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[34])        //|> w
  ,.out_partial_data  (calc_pout_fp_34_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[34])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_35 (
   .in_data           (calc_op0_fp_35_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_35_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[35])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[35])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[35])        //|< r
  ,.out_final_data    (calc_fout_fp_35_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[35])        //|> w
  ,.out_partial_data  (calc_pout_fp_35_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[35])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_36 (
   .in_data           (calc_op0_fp_36_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_36_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[36])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[36])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[36])        //|< r
  ,.out_final_data    (calc_fout_fp_36_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[36])        //|> w
  ,.out_partial_data  (calc_pout_fp_36_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[36])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_37 (
   .in_data           (calc_op0_fp_37_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_37_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[37])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[37])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[37])        //|< r
  ,.out_final_data    (calc_fout_fp_37_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[37])        //|> w
  ,.out_partial_data  (calc_pout_fp_37_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[37])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_38 (
   .in_data           (calc_op0_fp_38_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_38_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[38])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[38])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[38])        //|< r
  ,.out_final_data    (calc_fout_fp_38_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[38])        //|> w
  ,.out_partial_data  (calc_pout_fp_38_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[38])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_39 (
   .in_data           (calc_op0_fp_39_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_39_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[39])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[39])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[39])        //|< r
  ,.out_final_data    (calc_fout_fp_39_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[39])        //|> w
  ,.out_partial_data  (calc_pout_fp_39_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[39])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_40 (
   .in_data           (calc_op0_fp_40_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_40_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[40])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[40])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[40])        //|< r
  ,.out_final_data    (calc_fout_fp_40_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[40])        //|> w
  ,.out_partial_data  (calc_pout_fp_40_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[40])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_41 (
   .in_data           (calc_op0_fp_41_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_41_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[41])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[41])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[41])        //|< r
  ,.out_final_data    (calc_fout_fp_41_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[41])        //|> w
  ,.out_partial_data  (calc_pout_fp_41_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[41])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_42 (
   .in_data           (calc_op0_fp_42_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_42_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[42])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[42])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[42])        //|< r
  ,.out_final_data    (calc_fout_fp_42_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[42])        //|> w
  ,.out_partial_data  (calc_pout_fp_42_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[42])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_43 (
   .in_data           (calc_op0_fp_43_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_43_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[43])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[43])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[43])        //|< r
  ,.out_final_data    (calc_fout_fp_43_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[43])        //|> w
  ,.out_partial_data  (calc_pout_fp_43_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[43])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_44 (
   .in_data           (calc_op0_fp_44_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_44_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[44])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[44])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[44])        //|< r
  ,.out_final_data    (calc_fout_fp_44_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[44])        //|> w
  ,.out_partial_data  (calc_pout_fp_44_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[44])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_45 (
   .in_data           (calc_op0_fp_45_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_45_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[45])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[45])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[45])        //|< r
  ,.out_final_data    (calc_fout_fp_45_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[45])        //|> w
  ,.out_partial_data  (calc_pout_fp_45_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[45])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_46 (
   .in_data           (calc_op0_fp_46_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_46_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[46])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[46])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[46])        //|< r
  ,.out_final_data    (calc_fout_fp_46_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[46])        //|> w
  ,.out_partial_data  (calc_pout_fp_46_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[46])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_47 (
   .in_data           (calc_op0_fp_47_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_47_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[47])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[47])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[47])        //|< r
  ,.out_final_data    (calc_fout_fp_47_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[47])        //|> w
  ,.out_partial_data  (calc_pout_fp_47_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[47])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_48 (
   .in_data           (calc_op0_fp_48_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_48_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[48])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[48])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[48])        //|< r
  ,.out_final_data    (calc_fout_fp_48_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[48])        //|> w
  ,.out_partial_data  (calc_pout_fp_48_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[48])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_49 (
   .in_data           (calc_op0_fp_49_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_49_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[49])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[49])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[49])        //|< r
  ,.out_final_data    (calc_fout_fp_49_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[49])        //|> w
  ,.out_partial_data  (calc_pout_fp_49_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[49])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_50 (
   .in_data           (calc_op0_fp_50_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_50_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[50])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[50])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[50])        //|< r
  ,.out_final_data    (calc_fout_fp_50_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[50])        //|> w
  ,.out_partial_data  (calc_pout_fp_50_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[50])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_51 (
   .in_data           (calc_op0_fp_51_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_51_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[51])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[51])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[51])        //|< r
  ,.out_final_data    (calc_fout_fp_51_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[51])        //|> w
  ,.out_partial_data  (calc_pout_fp_51_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[51])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_52 (
   .in_data           (calc_op0_fp_52_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_52_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[52])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[52])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[52])        //|< r
  ,.out_final_data    (calc_fout_fp_52_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[52])        //|> w
  ,.out_partial_data  (calc_pout_fp_52_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[52])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_53 (
   .in_data           (calc_op0_fp_53_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_53_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[53])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[53])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[53])        //|< r
  ,.out_final_data    (calc_fout_fp_53_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[53])        //|> w
  ,.out_partial_data  (calc_pout_fp_53_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[53])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_54 (
   .in_data           (calc_op0_fp_54_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_54_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[54])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[54])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[54])        //|< r
  ,.out_final_data    (calc_fout_fp_54_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[54])        //|> w
  ,.out_partial_data  (calc_pout_fp_54_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[54])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_55 (
   .in_data           (calc_op0_fp_55_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_55_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[55])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[55])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[55])        //|< r
  ,.out_final_data    (calc_fout_fp_55_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[55])        //|> w
  ,.out_partial_data  (calc_pout_fp_55_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[55])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_56 (
   .in_data           (calc_op0_fp_56_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_56_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[56])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[56])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[56])        //|< r
  ,.out_final_data    (calc_fout_fp_56_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[56])        //|> w
  ,.out_partial_data  (calc_pout_fp_56_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[56])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_57 (
   .in_data           (calc_op0_fp_57_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_57_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[57])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[57])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[57])        //|< r
  ,.out_final_data    (calc_fout_fp_57_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[57])        //|> w
  ,.out_partial_data  (calc_pout_fp_57_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[57])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_58 (
   .in_data           (calc_op0_fp_58_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_58_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[58])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[58])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[58])        //|< r
  ,.out_final_data    (calc_fout_fp_58_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[58])        //|> w
  ,.out_partial_data  (calc_pout_fp_58_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[58])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_59 (
   .in_data           (calc_op0_fp_59_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_59_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[59])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[59])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[59])        //|< r
  ,.out_final_data    (calc_fout_fp_59_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[59])        //|> w
  ,.out_partial_data  (calc_pout_fp_59_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[59])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_60 (
   .in_data           (calc_op0_fp_60_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_60_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[60])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[60])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[60])        //|< r
  ,.out_final_data    (calc_fout_fp_60_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[60])        //|> w
  ,.out_partial_data  (calc_pout_fp_60_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[60])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_61 (
   .in_data           (calc_op0_fp_61_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_61_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[61])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[61])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[61])        //|< r
  ,.out_final_data    (calc_fout_fp_61_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[61])        //|> w
  ,.out_partial_data  (calc_pout_fp_61_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[61])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_62 (
   .in_data           (calc_op0_fp_62_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_62_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[62])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[62])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[62])        //|< r
  ,.out_final_data    (calc_fout_fp_62_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[62])        //|> w
  ,.out_partial_data  (calc_pout_fp_62_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[62])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


NV_NVDLA_CACC_CALC_fp_48b u_cell_fp_63 (
   .in_data           (calc_op0_fp_63_d1[43:0])     //|< r
  ,.in_op             (calc_op1_fp_63_d1[47:0])     //|< r
  ,.in_op_valid       (calc_op1_vld_fp_d1[63])      //|< r
  ,.in_sel            (calc_dlv_en_fp_d1[63])       //|< r
  ,.in_valid          (calc_op_en_fp_d1[63])        //|< r
  ,.out_final_data    (calc_fout_fp_63_sum[31:0])   //|> w
  ,.out_final_valid   (calc_fout_fp_vld[63])        //|> w
  ,.out_partial_data  (calc_pout_fp_63_sum[47:0])   //|> w
  ,.out_partial_valid (calc_pout_fp_vld[63])        //|> w
  ,.nvdla_core_clk    (nvdla_cell_clk_3)            //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)             //|< i
  );


//////////////////////////////////////////////////////////////
///// Latency pipeline to balance with calc cells        /////
//////////////////////////////////////////////////////////////


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_valid_d2 <= 1'b0;
  end else begin
  calc_valid_d2 <= calc_valid_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_wr_en_d2 <= {8{1'b0}};
  end else begin
  if ((calc_valid_d1 | calc_valid_d2) == 1'b1) begin
    calc_wr_en_d2 <= calc_wr_en_d1;
  // VCS coverage off
  end else if ((calc_valid_d1 | calc_valid_d2) == 1'b0) begin
  end else begin
    calc_wr_en_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_valid_d1 | calc_valid_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_addr_d2 <= {5{1'b0}};
  end else begin
  if ((calc_valid_d1) == 1'b1) begin
    calc_addr_d2 <= calc_addr_d1;
  // VCS coverage off
  end else if ((calc_valid_d1) == 1'b0) begin
  end else begin
    calc_addr_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_valid_d3 <= 1'b0;
  end else begin
  calc_valid_d3 <= calc_valid_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_wr_en_d3 <= {8{1'b0}};
  end else begin
  if ((calc_valid_d2 | calc_valid_d3) == 1'b1) begin
    calc_wr_en_d3 <= calc_wr_en_d2;
  // VCS coverage off
  end else if ((calc_valid_d2 | calc_valid_d3) == 1'b0) begin
  end else begin
    calc_wr_en_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_valid_d2 | calc_valid_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_addr_d3 <= {5{1'b0}};
  end else begin
  if ((calc_valid_d2) == 1'b1) begin
    calc_addr_d3 <= calc_addr_d2;
  // VCS coverage off
  end else if ((calc_valid_d2) == 1'b0) begin
  end else begin
    calc_addr_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_valid_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_valid_d4 <= 1'b0;
  end else begin
  calc_valid_d4 <= calc_valid_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_wr_en_d4 <= {8{1'b0}};
  end else begin
  if ((calc_valid_d3 | calc_valid_d4) == 1'b1) begin
    calc_wr_en_d4 <= calc_wr_en_d3;
  // VCS coverage off
  end else if ((calc_valid_d3 | calc_valid_d4) == 1'b0) begin
  end else begin
    calc_wr_en_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_valid_d3 | calc_valid_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_addr_d4 <= {5{1'b0}};
  end else begin
  if ((calc_valid_d3) == 1'b1) begin
    calc_addr_d4 <= calc_addr_d3;
  // VCS coverage off
  end else if ((calc_valid_d3) == 1'b0) begin
  end else begin
    calc_addr_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_valid_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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






assign calc_valid_out = (calc_valid_d3 & cfg_is_int[0]) |
                        (calc_valid_d4 & cfg_is_fp[0]);
assign calc_wr_en_out = (calc_wr_en_d3 & cfg_is_int[8:1]) |
                        (calc_wr_en_d4 & cfg_is_fp[8:1]);
assign calc_addr_out = (calc_addr_d3 & cfg_is_int[13:9]) |
                       (calc_addr_d4 & cfg_is_fp[13:9]);






always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_dlv_valid_d2 <= 1'b0;
  end else begin
  calc_dlv_valid_d2 <= calc_dlv_valid_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_dlv_en_d2 <= {8{1'b0}};
  end else begin
  if ((calc_dlv_valid_d1 | calc_dlv_valid_d2) == 1'b1) begin
    calc_dlv_en_d2 <= calc_dlv_en_d1;
  // VCS coverage off
  end else if ((calc_dlv_valid_d1 | calc_dlv_valid_d2) == 1'b0) begin
  end else begin
    calc_dlv_en_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d1 | calc_dlv_valid_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_stripe_end_d2 <= 1'b0;
  end else begin
  if ((calc_dlv_valid_d1) == 1'b1) begin
    calc_stripe_end_d2 <= calc_stripe_end_d1;
  // VCS coverage off
  end else if ((calc_dlv_valid_d1) == 1'b0) begin
  end else begin
    calc_stripe_end_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_layer_end_d2 <= 1'b0;
  end else begin
  if ((calc_dlv_valid_d1) == 1'b1) begin
    calc_layer_end_d2 <= calc_layer_end_d1;
  // VCS coverage off
  end else if ((calc_dlv_valid_d1) == 1'b0) begin
  end else begin
    calc_layer_end_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_dlv_valid_d3 <= 1'b0;
  end else begin
  calc_dlv_valid_d3 <= calc_dlv_valid_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_dlv_en_d3 <= {8{1'b0}};
  end else begin
  if ((calc_dlv_valid_d2 | calc_dlv_valid_d3) == 1'b1) begin
    calc_dlv_en_d3 <= calc_dlv_en_d2;
  // VCS coverage off
  end else if ((calc_dlv_valid_d2 | calc_dlv_valid_d3) == 1'b0) begin
  end else begin
    calc_dlv_en_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d2 | calc_dlv_valid_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_stripe_end_d3 <= 1'b0;
  end else begin
  if ((calc_dlv_valid_d2) == 1'b1) begin
    calc_stripe_end_d3 <= calc_stripe_end_d2;
  // VCS coverage off
  end else if ((calc_dlv_valid_d2) == 1'b0) begin
  end else begin
    calc_stripe_end_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_layer_end_d3 <= 1'b0;
  end else begin
  if ((calc_dlv_valid_d2) == 1'b1) begin
    calc_layer_end_d3 <= calc_layer_end_d2;
  // VCS coverage off
  end else if ((calc_dlv_valid_d2) == 1'b0) begin
  end else begin
    calc_layer_end_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_dlv_valid_d4 <= 1'b0;
  end else begin
  calc_dlv_valid_d4 <= calc_dlv_valid_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_dlv_en_d4 <= {8{1'b0}};
  end else begin
  if ((calc_dlv_valid_d3 | calc_dlv_valid_d4) == 1'b1) begin
    calc_dlv_en_d4 <= calc_dlv_en_d3;
  // VCS coverage off
  end else if ((calc_dlv_valid_d3 | calc_dlv_valid_d4) == 1'b0) begin
  end else begin
    calc_dlv_en_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d3 | calc_dlv_valid_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_stripe_end_d4 <= 1'b0;
  end else begin
  if ((calc_dlv_valid_d3) == 1'b1) begin
    calc_stripe_end_d4 <= calc_stripe_end_d3;
  // VCS coverage off
  end else if ((calc_dlv_valid_d3) == 1'b0) begin
  end else begin
    calc_stripe_end_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_layer_end_d4 <= 1'b0;
  end else begin
  if ((calc_dlv_valid_d3) == 1'b1) begin
    calc_layer_end_d4 <= calc_layer_end_d3;
  // VCS coverage off
  end else if ((calc_dlv_valid_d3) == 1'b0) begin
  end else begin
    calc_layer_end_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_dlv_valid_d5 <= 1'b0;
  end else begin
  calc_dlv_valid_d5 <= calc_dlv_valid_d4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    calc_dlv_en_d5 <= {8{1'b0}};
  end else begin
  if ((calc_dlv_valid_d4 | calc_dlv_valid_d5) == 1'b1) begin
    calc_dlv_en_d5 <= calc_dlv_en_d4;
  // VCS coverage off
  end else if ((calc_dlv_valid_d4 | calc_dlv_valid_d5) == 1'b0) begin
  end else begin
    calc_dlv_en_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d4 | calc_dlv_valid_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_stripe_end_d5 <= 1'b0;
  end else begin
  if ((calc_dlv_valid_d4) == 1'b1) begin
    calc_stripe_end_d5 <= calc_stripe_end_d4;
  // VCS coverage off
  end else if ((calc_dlv_valid_d4) == 1'b0) begin
  end else begin
    calc_stripe_end_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    calc_layer_end_d5 <= 1'b0;
  end else begin
  if ((calc_dlv_valid_d4) == 1'b1) begin
    calc_layer_end_d5 <= calc_layer_end_d4;
  // VCS coverage off
  end else if ((calc_dlv_valid_d4) == 1'b0) begin
  end else begin
    calc_layer_end_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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






assign calc_dlv_valid_out = (calc_dlv_valid_d3 & cfg_is_int[14]) |
                            (calc_dlv_valid_d5 & cfg_is_fp[14]);
assign calc_dlv_en_out = (calc_dlv_en_d3 & cfg_is_int[22:15]) |
                         (calc_dlv_en_d5 & cfg_is_fp[22:15]);
assign calc_stripe_end_out = (calc_stripe_end_d3 & cfg_is_int[23]) |
                             (calc_stripe_end_d5 & cfg_is_fp[23]);
assign calc_layer_end_out = (calc_layer_end_d3 & cfg_is_int[24]) |
                            (calc_layer_end_d5 & cfg_is_fp[24]);






//////////////////////////////////////////////////////////////
///// Gather of accumulator result                       /////
//////////////////////////////////////////////////////////////

assign calc_pout_fp_0_sum_ext = calc_pout_fp_0_sum;
assign calc_pout_fp_1_sum_ext = calc_pout_fp_1_sum;
assign calc_pout_fp_2_sum_ext = calc_pout_fp_2_sum;
assign calc_pout_fp_3_sum_ext = calc_pout_fp_3_sum;
assign calc_pout_fp_4_sum_ext = calc_pout_fp_4_sum;
assign calc_pout_fp_5_sum_ext = calc_pout_fp_5_sum;
assign calc_pout_fp_6_sum_ext = calc_pout_fp_6_sum;
assign calc_pout_fp_7_sum_ext = calc_pout_fp_7_sum;
assign calc_pout_fp_8_sum_ext = calc_pout_fp_8_sum;
assign calc_pout_fp_9_sum_ext = calc_pout_fp_9_sum;
assign calc_pout_fp_10_sum_ext = calc_pout_fp_10_sum;
assign calc_pout_fp_11_sum_ext = calc_pout_fp_11_sum;
assign calc_pout_fp_12_sum_ext = calc_pout_fp_12_sum;
assign calc_pout_fp_13_sum_ext = calc_pout_fp_13_sum;
assign calc_pout_fp_14_sum_ext = calc_pout_fp_14_sum;
assign calc_pout_fp_15_sum_ext = calc_pout_fp_15_sum;
assign calc_pout_fp_16_sum_ext = calc_pout_fp_16_sum;
assign calc_pout_fp_17_sum_ext = calc_pout_fp_17_sum;
assign calc_pout_fp_18_sum_ext = calc_pout_fp_18_sum;
assign calc_pout_fp_19_sum_ext = calc_pout_fp_19_sum;
assign calc_pout_fp_20_sum_ext = calc_pout_fp_20_sum;
assign calc_pout_fp_21_sum_ext = calc_pout_fp_21_sum;
assign calc_pout_fp_22_sum_ext = calc_pout_fp_22_sum;
assign calc_pout_fp_23_sum_ext = calc_pout_fp_23_sum;
assign calc_pout_fp_24_sum_ext = calc_pout_fp_24_sum;
assign calc_pout_fp_25_sum_ext = calc_pout_fp_25_sum;
assign calc_pout_fp_26_sum_ext = calc_pout_fp_26_sum;
assign calc_pout_fp_27_sum_ext = calc_pout_fp_27_sum;
assign calc_pout_fp_28_sum_ext = calc_pout_fp_28_sum;
assign calc_pout_fp_29_sum_ext = calc_pout_fp_29_sum;
assign calc_pout_fp_30_sum_ext = calc_pout_fp_30_sum;
assign calc_pout_fp_31_sum_ext = calc_pout_fp_31_sum;
assign calc_pout_fp_32_sum_ext = calc_pout_fp_32_sum;
assign calc_pout_fp_33_sum_ext = calc_pout_fp_33_sum;
assign calc_pout_fp_34_sum_ext = calc_pout_fp_34_sum;
assign calc_pout_fp_35_sum_ext = calc_pout_fp_35_sum;
assign calc_pout_fp_36_sum_ext = calc_pout_fp_36_sum;
assign calc_pout_fp_37_sum_ext = calc_pout_fp_37_sum;
assign calc_pout_fp_38_sum_ext = calc_pout_fp_38_sum;
assign calc_pout_fp_39_sum_ext = calc_pout_fp_39_sum;
assign calc_pout_fp_40_sum_ext = calc_pout_fp_40_sum;
assign calc_pout_fp_41_sum_ext = calc_pout_fp_41_sum;
assign calc_pout_fp_42_sum_ext = calc_pout_fp_42_sum;
assign calc_pout_fp_43_sum_ext = calc_pout_fp_43_sum;
assign calc_pout_fp_44_sum_ext = calc_pout_fp_44_sum;
assign calc_pout_fp_45_sum_ext = calc_pout_fp_45_sum;
assign calc_pout_fp_46_sum_ext = calc_pout_fp_46_sum;
assign calc_pout_fp_47_sum_ext = calc_pout_fp_47_sum;
assign calc_pout_fp_48_sum_ext = calc_pout_fp_48_sum;
assign calc_pout_fp_49_sum_ext = calc_pout_fp_49_sum;
assign calc_pout_fp_50_sum_ext = calc_pout_fp_50_sum;
assign calc_pout_fp_51_sum_ext = calc_pout_fp_51_sum;
assign calc_pout_fp_52_sum_ext = calc_pout_fp_52_sum;
assign calc_pout_fp_53_sum_ext = calc_pout_fp_53_sum;
assign calc_pout_fp_54_sum_ext = calc_pout_fp_54_sum;
assign calc_pout_fp_55_sum_ext = calc_pout_fp_55_sum;
assign calc_pout_fp_56_sum_ext = calc_pout_fp_56_sum;
assign calc_pout_fp_57_sum_ext = calc_pout_fp_57_sum;
assign calc_pout_fp_58_sum_ext = calc_pout_fp_58_sum;
assign calc_pout_fp_59_sum_ext = calc_pout_fp_59_sum;
assign calc_pout_fp_60_sum_ext = calc_pout_fp_60_sum;
assign calc_pout_fp_61_sum_ext = calc_pout_fp_61_sum;
assign calc_pout_fp_62_sum_ext = calc_pout_fp_62_sum;
assign calc_pout_fp_63_sum_ext = calc_pout_fp_63_sum;





assign calc_pout_0 = ({48{calc_pout_int_vld[0]}} & calc_pout_int_0_sum) |
                     ({48{calc_pout_fp_vld[0]}} & calc_pout_fp_0_sum_ext);
assign calc_pout_1 = ({48{calc_pout_int_vld[1]}} & calc_pout_int_1_sum) |
                     ({48{calc_pout_fp_vld[1]}} & calc_pout_fp_1_sum_ext);
assign calc_pout_2 = ({48{calc_pout_int_vld[2]}} & calc_pout_int_2_sum) |
                     ({48{calc_pout_fp_vld[2]}} & calc_pout_fp_2_sum_ext);
assign calc_pout_3 = ({48{calc_pout_int_vld[3]}} & calc_pout_int_3_sum) |
                     ({48{calc_pout_fp_vld[3]}} & calc_pout_fp_3_sum_ext);
assign calc_pout_4 = ({48{calc_pout_int_vld[4]}} & calc_pout_int_4_sum) |
                     ({48{calc_pout_fp_vld[4]}} & calc_pout_fp_4_sum_ext);
assign calc_pout_5 = ({48{calc_pout_int_vld[5]}} & calc_pout_int_5_sum) |
                     ({48{calc_pout_fp_vld[5]}} & calc_pout_fp_5_sum_ext);
assign calc_pout_6 = ({48{calc_pout_int_vld[6]}} & calc_pout_int_6_sum) |
                     ({48{calc_pout_fp_vld[6]}} & calc_pout_fp_6_sum_ext);
assign calc_pout_7 = ({48{calc_pout_int_vld[7]}} & calc_pout_int_7_sum) |
                     ({48{calc_pout_fp_vld[7]}} & calc_pout_fp_7_sum_ext);
assign calc_pout_8 = ({48{calc_pout_int_vld[8]}} & calc_pout_int_8_sum) |
                     ({48{calc_pout_fp_vld[8]}} & calc_pout_fp_8_sum_ext);
assign calc_pout_9 = ({48{calc_pout_int_vld[9]}} & calc_pout_int_9_sum) |
                     ({48{calc_pout_fp_vld[9]}} & calc_pout_fp_9_sum_ext);
assign calc_pout_10 = ({48{calc_pout_int_vld[10]}} & calc_pout_int_10_sum) |
                     ({48{calc_pout_fp_vld[10]}} & calc_pout_fp_10_sum_ext);
assign calc_pout_11 = ({48{calc_pout_int_vld[11]}} & calc_pout_int_11_sum) |
                     ({48{calc_pout_fp_vld[11]}} & calc_pout_fp_11_sum_ext);
assign calc_pout_12 = ({48{calc_pout_int_vld[12]}} & calc_pout_int_12_sum) |
                     ({48{calc_pout_fp_vld[12]}} & calc_pout_fp_12_sum_ext);
assign calc_pout_13 = ({48{calc_pout_int_vld[13]}} & calc_pout_int_13_sum) |
                     ({48{calc_pout_fp_vld[13]}} & calc_pout_fp_13_sum_ext);
assign calc_pout_14 = ({48{calc_pout_int_vld[14]}} & calc_pout_int_14_sum) |
                     ({48{calc_pout_fp_vld[14]}} & calc_pout_fp_14_sum_ext);
assign calc_pout_15 = ({48{calc_pout_int_vld[15]}} & calc_pout_int_15_sum) |
                     ({48{calc_pout_fp_vld[15]}} & calc_pout_fp_15_sum_ext);
assign calc_pout_16 = ({48{calc_pout_int_vld[16]}} & calc_pout_int_16_sum) |
                     ({48{calc_pout_fp_vld[16]}} & calc_pout_fp_16_sum_ext);
assign calc_pout_17 = ({48{calc_pout_int_vld[17]}} & calc_pout_int_17_sum) |
                     ({48{calc_pout_fp_vld[17]}} & calc_pout_fp_17_sum_ext);
assign calc_pout_18 = ({48{calc_pout_int_vld[18]}} & calc_pout_int_18_sum) |
                     ({48{calc_pout_fp_vld[18]}} & calc_pout_fp_18_sum_ext);
assign calc_pout_19 = ({48{calc_pout_int_vld[19]}} & calc_pout_int_19_sum) |
                     ({48{calc_pout_fp_vld[19]}} & calc_pout_fp_19_sum_ext);
assign calc_pout_20 = ({48{calc_pout_int_vld[20]}} & calc_pout_int_20_sum) |
                     ({48{calc_pout_fp_vld[20]}} & calc_pout_fp_20_sum_ext);
assign calc_pout_21 = ({48{calc_pout_int_vld[21]}} & calc_pout_int_21_sum) |
                     ({48{calc_pout_fp_vld[21]}} & calc_pout_fp_21_sum_ext);
assign calc_pout_22 = ({48{calc_pout_int_vld[22]}} & calc_pout_int_22_sum) |
                     ({48{calc_pout_fp_vld[22]}} & calc_pout_fp_22_sum_ext);
assign calc_pout_23 = ({48{calc_pout_int_vld[23]}} & calc_pout_int_23_sum) |
                     ({48{calc_pout_fp_vld[23]}} & calc_pout_fp_23_sum_ext);
assign calc_pout_24 = ({48{calc_pout_int_vld[24]}} & calc_pout_int_24_sum) |
                     ({48{calc_pout_fp_vld[24]}} & calc_pout_fp_24_sum_ext);
assign calc_pout_25 = ({48{calc_pout_int_vld[25]}} & calc_pout_int_25_sum) |
                     ({48{calc_pout_fp_vld[25]}} & calc_pout_fp_25_sum_ext);
assign calc_pout_26 = ({48{calc_pout_int_vld[26]}} & calc_pout_int_26_sum) |
                     ({48{calc_pout_fp_vld[26]}} & calc_pout_fp_26_sum_ext);
assign calc_pout_27 = ({48{calc_pout_int_vld[27]}} & calc_pout_int_27_sum) |
                     ({48{calc_pout_fp_vld[27]}} & calc_pout_fp_27_sum_ext);
assign calc_pout_28 = ({48{calc_pout_int_vld[28]}} & calc_pout_int_28_sum) |
                     ({48{calc_pout_fp_vld[28]}} & calc_pout_fp_28_sum_ext);
assign calc_pout_29 = ({48{calc_pout_int_vld[29]}} & calc_pout_int_29_sum) |
                     ({48{calc_pout_fp_vld[29]}} & calc_pout_fp_29_sum_ext);
assign calc_pout_30 = ({48{calc_pout_int_vld[30]}} & calc_pout_int_30_sum) |
                     ({48{calc_pout_fp_vld[30]}} & calc_pout_fp_30_sum_ext);
assign calc_pout_31 = ({48{calc_pout_int_vld[31]}} & calc_pout_int_31_sum) |
                     ({48{calc_pout_fp_vld[31]}} & calc_pout_fp_31_sum_ext);
assign calc_pout_32 = ({48{calc_pout_int_vld[32]}} & calc_pout_int_32_sum) |
                     ({48{calc_pout_fp_vld[32]}} & calc_pout_fp_32_sum_ext);
assign calc_pout_33 = ({48{calc_pout_int_vld[33]}} & calc_pout_int_33_sum) |
                     ({48{calc_pout_fp_vld[33]}} & calc_pout_fp_33_sum_ext);
assign calc_pout_34 = ({48{calc_pout_int_vld[34]}} & calc_pout_int_34_sum) |
                     ({48{calc_pout_fp_vld[34]}} & calc_pout_fp_34_sum_ext);
assign calc_pout_35 = ({48{calc_pout_int_vld[35]}} & calc_pout_int_35_sum) |
                     ({48{calc_pout_fp_vld[35]}} & calc_pout_fp_35_sum_ext);
assign calc_pout_36 = ({48{calc_pout_int_vld[36]}} & calc_pout_int_36_sum) |
                     ({48{calc_pout_fp_vld[36]}} & calc_pout_fp_36_sum_ext);
assign calc_pout_37 = ({48{calc_pout_int_vld[37]}} & calc_pout_int_37_sum) |
                     ({48{calc_pout_fp_vld[37]}} & calc_pout_fp_37_sum_ext);
assign calc_pout_38 = ({48{calc_pout_int_vld[38]}} & calc_pout_int_38_sum) |
                     ({48{calc_pout_fp_vld[38]}} & calc_pout_fp_38_sum_ext);
assign calc_pout_39 = ({48{calc_pout_int_vld[39]}} & calc_pout_int_39_sum) |
                     ({48{calc_pout_fp_vld[39]}} & calc_pout_fp_39_sum_ext);
assign calc_pout_40 = ({48{calc_pout_int_vld[40]}} & calc_pout_int_40_sum) |
                     ({48{calc_pout_fp_vld[40]}} & calc_pout_fp_40_sum_ext);
assign calc_pout_41 = ({48{calc_pout_int_vld[41]}} & calc_pout_int_41_sum) |
                     ({48{calc_pout_fp_vld[41]}} & calc_pout_fp_41_sum_ext);
assign calc_pout_42 = ({48{calc_pout_int_vld[42]}} & calc_pout_int_42_sum) |
                     ({48{calc_pout_fp_vld[42]}} & calc_pout_fp_42_sum_ext);
assign calc_pout_43 = ({48{calc_pout_int_vld[43]}} & calc_pout_int_43_sum) |
                     ({48{calc_pout_fp_vld[43]}} & calc_pout_fp_43_sum_ext);
assign calc_pout_44 = ({48{calc_pout_int_vld[44]}} & calc_pout_int_44_sum) |
                     ({48{calc_pout_fp_vld[44]}} & calc_pout_fp_44_sum_ext);
assign calc_pout_45 = ({48{calc_pout_int_vld[45]}} & calc_pout_int_45_sum) |
                     ({48{calc_pout_fp_vld[45]}} & calc_pout_fp_45_sum_ext);
assign calc_pout_46 = ({48{calc_pout_int_vld[46]}} & calc_pout_int_46_sum) |
                     ({48{calc_pout_fp_vld[46]}} & calc_pout_fp_46_sum_ext);
assign calc_pout_47 = ({48{calc_pout_int_vld[47]}} & calc_pout_int_47_sum) |
                     ({48{calc_pout_fp_vld[47]}} & calc_pout_fp_47_sum_ext);
assign calc_pout_48 = ({48{calc_pout_int_vld[48]}} & calc_pout_int_48_sum) |
                     ({48{calc_pout_fp_vld[48]}} & calc_pout_fp_48_sum_ext);
assign calc_pout_49 = ({48{calc_pout_int_vld[49]}} & calc_pout_int_49_sum) |
                     ({48{calc_pout_fp_vld[49]}} & calc_pout_fp_49_sum_ext);
assign calc_pout_50 = ({48{calc_pout_int_vld[50]}} & calc_pout_int_50_sum) |
                     ({48{calc_pout_fp_vld[50]}} & calc_pout_fp_50_sum_ext);
assign calc_pout_51 = ({48{calc_pout_int_vld[51]}} & calc_pout_int_51_sum) |
                     ({48{calc_pout_fp_vld[51]}} & calc_pout_fp_51_sum_ext);
assign calc_pout_52 = ({48{calc_pout_int_vld[52]}} & calc_pout_int_52_sum) |
                     ({48{calc_pout_fp_vld[52]}} & calc_pout_fp_52_sum_ext);
assign calc_pout_53 = ({48{calc_pout_int_vld[53]}} & calc_pout_int_53_sum) |
                     ({48{calc_pout_fp_vld[53]}} & calc_pout_fp_53_sum_ext);
assign calc_pout_54 = ({48{calc_pout_int_vld[54]}} & calc_pout_int_54_sum) |
                     ({48{calc_pout_fp_vld[54]}} & calc_pout_fp_54_sum_ext);
assign calc_pout_55 = ({48{calc_pout_int_vld[55]}} & calc_pout_int_55_sum) |
                     ({48{calc_pout_fp_vld[55]}} & calc_pout_fp_55_sum_ext);
assign calc_pout_56 = ({48{calc_pout_int_vld[56]}} & calc_pout_int_56_sum) |
                     ({48{calc_pout_fp_vld[56]}} & calc_pout_fp_56_sum_ext);
assign calc_pout_57 = ({48{calc_pout_int_vld[57]}} & calc_pout_int_57_sum) |
                     ({48{calc_pout_fp_vld[57]}} & calc_pout_fp_57_sum_ext);
assign calc_pout_58 = ({48{calc_pout_int_vld[58]}} & calc_pout_int_58_sum) |
                     ({48{calc_pout_fp_vld[58]}} & calc_pout_fp_58_sum_ext);
assign calc_pout_59 = ({48{calc_pout_int_vld[59]}} & calc_pout_int_59_sum) |
                     ({48{calc_pout_fp_vld[59]}} & calc_pout_fp_59_sum_ext);
assign calc_pout_60 = ({48{calc_pout_int_vld[60]}} & calc_pout_int_60_sum) |
                     ({48{calc_pout_fp_vld[60]}} & calc_pout_fp_60_sum_ext);
assign calc_pout_61 = ({48{calc_pout_int_vld[61]}} & calc_pout_int_61_sum) |
                     ({48{calc_pout_fp_vld[61]}} & calc_pout_fp_61_sum_ext);
assign calc_pout_62 = ({48{calc_pout_int_vld[62]}} & calc_pout_int_62_sum) |
                     ({48{calc_pout_fp_vld[62]}} & calc_pout_fp_62_sum_ext);
assign calc_pout_63 = ({48{calc_pout_int_vld[63]}} & calc_pout_int_63_sum) |
                     ({48{calc_pout_fp_vld[63]}} & calc_pout_fp_63_sum_ext);




assign calc_pout_64 = ({34{calc_pout_int_vld[64]}} & calc_pout_int_64_sum);
assign calc_pout_65 = ({34{calc_pout_int_vld[65]}} & calc_pout_int_65_sum);
assign calc_pout_66 = ({34{calc_pout_int_vld[66]}} & calc_pout_int_66_sum);
assign calc_pout_67 = ({34{calc_pout_int_vld[67]}} & calc_pout_int_67_sum);
assign calc_pout_68 = ({34{calc_pout_int_vld[68]}} & calc_pout_int_68_sum);
assign calc_pout_69 = ({34{calc_pout_int_vld[69]}} & calc_pout_int_69_sum);
assign calc_pout_70 = ({34{calc_pout_int_vld[70]}} & calc_pout_int_70_sum);
assign calc_pout_71 = ({34{calc_pout_int_vld[71]}} & calc_pout_int_71_sum);
assign calc_pout_72 = ({34{calc_pout_int_vld[72]}} & calc_pout_int_72_sum);
assign calc_pout_73 = ({34{calc_pout_int_vld[73]}} & calc_pout_int_73_sum);
assign calc_pout_74 = ({34{calc_pout_int_vld[74]}} & calc_pout_int_74_sum);
assign calc_pout_75 = ({34{calc_pout_int_vld[75]}} & calc_pout_int_75_sum);
assign calc_pout_76 = ({34{calc_pout_int_vld[76]}} & calc_pout_int_76_sum);
assign calc_pout_77 = ({34{calc_pout_int_vld[77]}} & calc_pout_int_77_sum);
assign calc_pout_78 = ({34{calc_pout_int_vld[78]}} & calc_pout_int_78_sum);
assign calc_pout_79 = ({34{calc_pout_int_vld[79]}} & calc_pout_int_79_sum);
assign calc_pout_80 = ({34{calc_pout_int_vld[80]}} & calc_pout_int_80_sum);
assign calc_pout_81 = ({34{calc_pout_int_vld[81]}} & calc_pout_int_81_sum);
assign calc_pout_82 = ({34{calc_pout_int_vld[82]}} & calc_pout_int_82_sum);
assign calc_pout_83 = ({34{calc_pout_int_vld[83]}} & calc_pout_int_83_sum);
assign calc_pout_84 = ({34{calc_pout_int_vld[84]}} & calc_pout_int_84_sum);
assign calc_pout_85 = ({34{calc_pout_int_vld[85]}} & calc_pout_int_85_sum);
assign calc_pout_86 = ({34{calc_pout_int_vld[86]}} & calc_pout_int_86_sum);
assign calc_pout_87 = ({34{calc_pout_int_vld[87]}} & calc_pout_int_87_sum);
assign calc_pout_88 = ({34{calc_pout_int_vld[88]}} & calc_pout_int_88_sum);
assign calc_pout_89 = ({34{calc_pout_int_vld[89]}} & calc_pout_int_89_sum);
assign calc_pout_90 = ({34{calc_pout_int_vld[90]}} & calc_pout_int_90_sum);
assign calc_pout_91 = ({34{calc_pout_int_vld[91]}} & calc_pout_int_91_sum);
assign calc_pout_92 = ({34{calc_pout_int_vld[92]}} & calc_pout_int_92_sum);
assign calc_pout_93 = ({34{calc_pout_int_vld[93]}} & calc_pout_int_93_sum);
assign calc_pout_94 = ({34{calc_pout_int_vld[94]}} & calc_pout_int_94_sum);
assign calc_pout_95 = ({34{calc_pout_int_vld[95]}} & calc_pout_int_95_sum);
assign calc_pout_96 = ({34{calc_pout_int_vld[96]}} & calc_pout_int_96_sum);
assign calc_pout_97 = ({34{calc_pout_int_vld[97]}} & calc_pout_int_97_sum);
assign calc_pout_98 = ({34{calc_pout_int_vld[98]}} & calc_pout_int_98_sum);
assign calc_pout_99 = ({34{calc_pout_int_vld[99]}} & calc_pout_int_99_sum);
assign calc_pout_100 = ({34{calc_pout_int_vld[100]}} & calc_pout_int_100_sum);
assign calc_pout_101 = ({34{calc_pout_int_vld[101]}} & calc_pout_int_101_sum);
assign calc_pout_102 = ({34{calc_pout_int_vld[102]}} & calc_pout_int_102_sum);
assign calc_pout_103 = ({34{calc_pout_int_vld[103]}} & calc_pout_int_103_sum);
assign calc_pout_104 = ({34{calc_pout_int_vld[104]}} & calc_pout_int_104_sum);
assign calc_pout_105 = ({34{calc_pout_int_vld[105]}} & calc_pout_int_105_sum);
assign calc_pout_106 = ({34{calc_pout_int_vld[106]}} & calc_pout_int_106_sum);
assign calc_pout_107 = ({34{calc_pout_int_vld[107]}} & calc_pout_int_107_sum);
assign calc_pout_108 = ({34{calc_pout_int_vld[108]}} & calc_pout_int_108_sum);
assign calc_pout_109 = ({34{calc_pout_int_vld[109]}} & calc_pout_int_109_sum);
assign calc_pout_110 = ({34{calc_pout_int_vld[110]}} & calc_pout_int_110_sum);
assign calc_pout_111 = ({34{calc_pout_int_vld[111]}} & calc_pout_int_111_sum);
assign calc_pout_112 = ({34{calc_pout_int_vld[112]}} & calc_pout_int_112_sum);
assign calc_pout_113 = ({34{calc_pout_int_vld[113]}} & calc_pout_int_113_sum);
assign calc_pout_114 = ({34{calc_pout_int_vld[114]}} & calc_pout_int_114_sum);
assign calc_pout_115 = ({34{calc_pout_int_vld[115]}} & calc_pout_int_115_sum);
assign calc_pout_116 = ({34{calc_pout_int_vld[116]}} & calc_pout_int_116_sum);
assign calc_pout_117 = ({34{calc_pout_int_vld[117]}} & calc_pout_int_117_sum);
assign calc_pout_118 = ({34{calc_pout_int_vld[118]}} & calc_pout_int_118_sum);
assign calc_pout_119 = ({34{calc_pout_int_vld[119]}} & calc_pout_int_119_sum);
assign calc_pout_120 = ({34{calc_pout_int_vld[120]}} & calc_pout_int_120_sum);
assign calc_pout_121 = ({34{calc_pout_int_vld[121]}} & calc_pout_int_121_sum);
assign calc_pout_122 = ({34{calc_pout_int_vld[122]}} & calc_pout_int_122_sum);
assign calc_pout_123 = ({34{calc_pout_int_vld[123]}} & calc_pout_int_123_sum);
assign calc_pout_124 = ({34{calc_pout_int_vld[124]}} & calc_pout_int_124_sum);
assign calc_pout_125 = ({34{calc_pout_int_vld[125]}} & calc_pout_int_125_sum);
assign calc_pout_126 = ({34{calc_pout_int_vld[126]}} & calc_pout_int_126_sum);
assign calc_pout_127 = ({34{calc_pout_int_vld[127]}} & calc_pout_int_127_sum);




assign calc_fout_0 = ({32{calc_fout_int_vld[0]}} & calc_fout_int_0_sum) |
                     ({32{calc_fout_fp_vld[0]}} & calc_fout_fp_0_sum);
assign calc_fout_1 = ({32{calc_fout_int_vld[1]}} & calc_fout_int_1_sum) |
                     ({32{calc_fout_fp_vld[1]}} & calc_fout_fp_1_sum);
assign calc_fout_2 = ({32{calc_fout_int_vld[2]}} & calc_fout_int_2_sum) |
                     ({32{calc_fout_fp_vld[2]}} & calc_fout_fp_2_sum);
assign calc_fout_3 = ({32{calc_fout_int_vld[3]}} & calc_fout_int_3_sum) |
                     ({32{calc_fout_fp_vld[3]}} & calc_fout_fp_3_sum);
assign calc_fout_4 = ({32{calc_fout_int_vld[4]}} & calc_fout_int_4_sum) |
                     ({32{calc_fout_fp_vld[4]}} & calc_fout_fp_4_sum);
assign calc_fout_5 = ({32{calc_fout_int_vld[5]}} & calc_fout_int_5_sum) |
                     ({32{calc_fout_fp_vld[5]}} & calc_fout_fp_5_sum);
assign calc_fout_6 = ({32{calc_fout_int_vld[6]}} & calc_fout_int_6_sum) |
                     ({32{calc_fout_fp_vld[6]}} & calc_fout_fp_6_sum);
assign calc_fout_7 = ({32{calc_fout_int_vld[7]}} & calc_fout_int_7_sum) |
                     ({32{calc_fout_fp_vld[7]}} & calc_fout_fp_7_sum);
assign calc_fout_8 = ({32{calc_fout_int_vld[8]}} & calc_fout_int_8_sum) |
                     ({32{calc_fout_fp_vld[8]}} & calc_fout_fp_8_sum);
assign calc_fout_9 = ({32{calc_fout_int_vld[9]}} & calc_fout_int_9_sum) |
                     ({32{calc_fout_fp_vld[9]}} & calc_fout_fp_9_sum);
assign calc_fout_10 = ({32{calc_fout_int_vld[10]}} & calc_fout_int_10_sum) |
                     ({32{calc_fout_fp_vld[10]}} & calc_fout_fp_10_sum);
assign calc_fout_11 = ({32{calc_fout_int_vld[11]}} & calc_fout_int_11_sum) |
                     ({32{calc_fout_fp_vld[11]}} & calc_fout_fp_11_sum);
assign calc_fout_12 = ({32{calc_fout_int_vld[12]}} & calc_fout_int_12_sum) |
                     ({32{calc_fout_fp_vld[12]}} & calc_fout_fp_12_sum);
assign calc_fout_13 = ({32{calc_fout_int_vld[13]}} & calc_fout_int_13_sum) |
                     ({32{calc_fout_fp_vld[13]}} & calc_fout_fp_13_sum);
assign calc_fout_14 = ({32{calc_fout_int_vld[14]}} & calc_fout_int_14_sum) |
                     ({32{calc_fout_fp_vld[14]}} & calc_fout_fp_14_sum);
assign calc_fout_15 = ({32{calc_fout_int_vld[15]}} & calc_fout_int_15_sum) |
                     ({32{calc_fout_fp_vld[15]}} & calc_fout_fp_15_sum);
assign calc_fout_16 = ({32{calc_fout_int_vld[16]}} & calc_fout_int_16_sum) |
                     ({32{calc_fout_fp_vld[16]}} & calc_fout_fp_16_sum);
assign calc_fout_17 = ({32{calc_fout_int_vld[17]}} & calc_fout_int_17_sum) |
                     ({32{calc_fout_fp_vld[17]}} & calc_fout_fp_17_sum);
assign calc_fout_18 = ({32{calc_fout_int_vld[18]}} & calc_fout_int_18_sum) |
                     ({32{calc_fout_fp_vld[18]}} & calc_fout_fp_18_sum);
assign calc_fout_19 = ({32{calc_fout_int_vld[19]}} & calc_fout_int_19_sum) |
                     ({32{calc_fout_fp_vld[19]}} & calc_fout_fp_19_sum);
assign calc_fout_20 = ({32{calc_fout_int_vld[20]}} & calc_fout_int_20_sum) |
                     ({32{calc_fout_fp_vld[20]}} & calc_fout_fp_20_sum);
assign calc_fout_21 = ({32{calc_fout_int_vld[21]}} & calc_fout_int_21_sum) |
                     ({32{calc_fout_fp_vld[21]}} & calc_fout_fp_21_sum);
assign calc_fout_22 = ({32{calc_fout_int_vld[22]}} & calc_fout_int_22_sum) |
                     ({32{calc_fout_fp_vld[22]}} & calc_fout_fp_22_sum);
assign calc_fout_23 = ({32{calc_fout_int_vld[23]}} & calc_fout_int_23_sum) |
                     ({32{calc_fout_fp_vld[23]}} & calc_fout_fp_23_sum);
assign calc_fout_24 = ({32{calc_fout_int_vld[24]}} & calc_fout_int_24_sum) |
                     ({32{calc_fout_fp_vld[24]}} & calc_fout_fp_24_sum);
assign calc_fout_25 = ({32{calc_fout_int_vld[25]}} & calc_fout_int_25_sum) |
                     ({32{calc_fout_fp_vld[25]}} & calc_fout_fp_25_sum);
assign calc_fout_26 = ({32{calc_fout_int_vld[26]}} & calc_fout_int_26_sum) |
                     ({32{calc_fout_fp_vld[26]}} & calc_fout_fp_26_sum);
assign calc_fout_27 = ({32{calc_fout_int_vld[27]}} & calc_fout_int_27_sum) |
                     ({32{calc_fout_fp_vld[27]}} & calc_fout_fp_27_sum);
assign calc_fout_28 = ({32{calc_fout_int_vld[28]}} & calc_fout_int_28_sum) |
                     ({32{calc_fout_fp_vld[28]}} & calc_fout_fp_28_sum);
assign calc_fout_29 = ({32{calc_fout_int_vld[29]}} & calc_fout_int_29_sum) |
                     ({32{calc_fout_fp_vld[29]}} & calc_fout_fp_29_sum);
assign calc_fout_30 = ({32{calc_fout_int_vld[30]}} & calc_fout_int_30_sum) |
                     ({32{calc_fout_fp_vld[30]}} & calc_fout_fp_30_sum);
assign calc_fout_31 = ({32{calc_fout_int_vld[31]}} & calc_fout_int_31_sum) |
                     ({32{calc_fout_fp_vld[31]}} & calc_fout_fp_31_sum);
assign calc_fout_32 = ({32{calc_fout_int_vld[32]}} & calc_fout_int_32_sum) |
                     ({32{calc_fout_fp_vld[32]}} & calc_fout_fp_32_sum);
assign calc_fout_33 = ({32{calc_fout_int_vld[33]}} & calc_fout_int_33_sum) |
                     ({32{calc_fout_fp_vld[33]}} & calc_fout_fp_33_sum);
assign calc_fout_34 = ({32{calc_fout_int_vld[34]}} & calc_fout_int_34_sum) |
                     ({32{calc_fout_fp_vld[34]}} & calc_fout_fp_34_sum);
assign calc_fout_35 = ({32{calc_fout_int_vld[35]}} & calc_fout_int_35_sum) |
                     ({32{calc_fout_fp_vld[35]}} & calc_fout_fp_35_sum);
assign calc_fout_36 = ({32{calc_fout_int_vld[36]}} & calc_fout_int_36_sum) |
                     ({32{calc_fout_fp_vld[36]}} & calc_fout_fp_36_sum);
assign calc_fout_37 = ({32{calc_fout_int_vld[37]}} & calc_fout_int_37_sum) |
                     ({32{calc_fout_fp_vld[37]}} & calc_fout_fp_37_sum);
assign calc_fout_38 = ({32{calc_fout_int_vld[38]}} & calc_fout_int_38_sum) |
                     ({32{calc_fout_fp_vld[38]}} & calc_fout_fp_38_sum);
assign calc_fout_39 = ({32{calc_fout_int_vld[39]}} & calc_fout_int_39_sum) |
                     ({32{calc_fout_fp_vld[39]}} & calc_fout_fp_39_sum);
assign calc_fout_40 = ({32{calc_fout_int_vld[40]}} & calc_fout_int_40_sum) |
                     ({32{calc_fout_fp_vld[40]}} & calc_fout_fp_40_sum);
assign calc_fout_41 = ({32{calc_fout_int_vld[41]}} & calc_fout_int_41_sum) |
                     ({32{calc_fout_fp_vld[41]}} & calc_fout_fp_41_sum);
assign calc_fout_42 = ({32{calc_fout_int_vld[42]}} & calc_fout_int_42_sum) |
                     ({32{calc_fout_fp_vld[42]}} & calc_fout_fp_42_sum);
assign calc_fout_43 = ({32{calc_fout_int_vld[43]}} & calc_fout_int_43_sum) |
                     ({32{calc_fout_fp_vld[43]}} & calc_fout_fp_43_sum);
assign calc_fout_44 = ({32{calc_fout_int_vld[44]}} & calc_fout_int_44_sum) |
                     ({32{calc_fout_fp_vld[44]}} & calc_fout_fp_44_sum);
assign calc_fout_45 = ({32{calc_fout_int_vld[45]}} & calc_fout_int_45_sum) |
                     ({32{calc_fout_fp_vld[45]}} & calc_fout_fp_45_sum);
assign calc_fout_46 = ({32{calc_fout_int_vld[46]}} & calc_fout_int_46_sum) |
                     ({32{calc_fout_fp_vld[46]}} & calc_fout_fp_46_sum);
assign calc_fout_47 = ({32{calc_fout_int_vld[47]}} & calc_fout_int_47_sum) |
                     ({32{calc_fout_fp_vld[47]}} & calc_fout_fp_47_sum);
assign calc_fout_48 = ({32{calc_fout_int_vld[48]}} & calc_fout_int_48_sum) |
                     ({32{calc_fout_fp_vld[48]}} & calc_fout_fp_48_sum);
assign calc_fout_49 = ({32{calc_fout_int_vld[49]}} & calc_fout_int_49_sum) |
                     ({32{calc_fout_fp_vld[49]}} & calc_fout_fp_49_sum);
assign calc_fout_50 = ({32{calc_fout_int_vld[50]}} & calc_fout_int_50_sum) |
                     ({32{calc_fout_fp_vld[50]}} & calc_fout_fp_50_sum);
assign calc_fout_51 = ({32{calc_fout_int_vld[51]}} & calc_fout_int_51_sum) |
                     ({32{calc_fout_fp_vld[51]}} & calc_fout_fp_51_sum);
assign calc_fout_52 = ({32{calc_fout_int_vld[52]}} & calc_fout_int_52_sum) |
                     ({32{calc_fout_fp_vld[52]}} & calc_fout_fp_52_sum);
assign calc_fout_53 = ({32{calc_fout_int_vld[53]}} & calc_fout_int_53_sum) |
                     ({32{calc_fout_fp_vld[53]}} & calc_fout_fp_53_sum);
assign calc_fout_54 = ({32{calc_fout_int_vld[54]}} & calc_fout_int_54_sum) |
                     ({32{calc_fout_fp_vld[54]}} & calc_fout_fp_54_sum);
assign calc_fout_55 = ({32{calc_fout_int_vld[55]}} & calc_fout_int_55_sum) |
                     ({32{calc_fout_fp_vld[55]}} & calc_fout_fp_55_sum);
assign calc_fout_56 = ({32{calc_fout_int_vld[56]}} & calc_fout_int_56_sum) |
                     ({32{calc_fout_fp_vld[56]}} & calc_fout_fp_56_sum);
assign calc_fout_57 = ({32{calc_fout_int_vld[57]}} & calc_fout_int_57_sum) |
                     ({32{calc_fout_fp_vld[57]}} & calc_fout_fp_57_sum);
assign calc_fout_58 = ({32{calc_fout_int_vld[58]}} & calc_fout_int_58_sum) |
                     ({32{calc_fout_fp_vld[58]}} & calc_fout_fp_58_sum);
assign calc_fout_59 = ({32{calc_fout_int_vld[59]}} & calc_fout_int_59_sum) |
                     ({32{calc_fout_fp_vld[59]}} & calc_fout_fp_59_sum);
assign calc_fout_60 = ({32{calc_fout_int_vld[60]}} & calc_fout_int_60_sum) |
                     ({32{calc_fout_fp_vld[60]}} & calc_fout_fp_60_sum);
assign calc_fout_61 = ({32{calc_fout_int_vld[61]}} & calc_fout_int_61_sum) |
                     ({32{calc_fout_fp_vld[61]}} & calc_fout_fp_61_sum);
assign calc_fout_62 = ({32{calc_fout_int_vld[62]}} & calc_fout_int_62_sum) |
                     ({32{calc_fout_fp_vld[62]}} & calc_fout_fp_62_sum);
assign calc_fout_63 = ({32{calc_fout_int_vld[63]}} & calc_fout_int_63_sum) |
                     ({32{calc_fout_fp_vld[63]}} & calc_fout_fp_63_sum);




assign calc_fout_64 = ({32{calc_fout_int_vld[64]}} & calc_fout_int_64_sum);
assign calc_fout_65 = ({32{calc_fout_int_vld[65]}} & calc_fout_int_65_sum);
assign calc_fout_66 = ({32{calc_fout_int_vld[66]}} & calc_fout_int_66_sum);
assign calc_fout_67 = ({32{calc_fout_int_vld[67]}} & calc_fout_int_67_sum);
assign calc_fout_68 = ({32{calc_fout_int_vld[68]}} & calc_fout_int_68_sum);
assign calc_fout_69 = ({32{calc_fout_int_vld[69]}} & calc_fout_int_69_sum);
assign calc_fout_70 = ({32{calc_fout_int_vld[70]}} & calc_fout_int_70_sum);
assign calc_fout_71 = ({32{calc_fout_int_vld[71]}} & calc_fout_int_71_sum);
assign calc_fout_72 = ({32{calc_fout_int_vld[72]}} & calc_fout_int_72_sum);
assign calc_fout_73 = ({32{calc_fout_int_vld[73]}} & calc_fout_int_73_sum);
assign calc_fout_74 = ({32{calc_fout_int_vld[74]}} & calc_fout_int_74_sum);
assign calc_fout_75 = ({32{calc_fout_int_vld[75]}} & calc_fout_int_75_sum);
assign calc_fout_76 = ({32{calc_fout_int_vld[76]}} & calc_fout_int_76_sum);
assign calc_fout_77 = ({32{calc_fout_int_vld[77]}} & calc_fout_int_77_sum);
assign calc_fout_78 = ({32{calc_fout_int_vld[78]}} & calc_fout_int_78_sum);
assign calc_fout_79 = ({32{calc_fout_int_vld[79]}} & calc_fout_int_79_sum);
assign calc_fout_80 = ({32{calc_fout_int_vld[80]}} & calc_fout_int_80_sum);
assign calc_fout_81 = ({32{calc_fout_int_vld[81]}} & calc_fout_int_81_sum);
assign calc_fout_82 = ({32{calc_fout_int_vld[82]}} & calc_fout_int_82_sum);
assign calc_fout_83 = ({32{calc_fout_int_vld[83]}} & calc_fout_int_83_sum);
assign calc_fout_84 = ({32{calc_fout_int_vld[84]}} & calc_fout_int_84_sum);
assign calc_fout_85 = ({32{calc_fout_int_vld[85]}} & calc_fout_int_85_sum);
assign calc_fout_86 = ({32{calc_fout_int_vld[86]}} & calc_fout_int_86_sum);
assign calc_fout_87 = ({32{calc_fout_int_vld[87]}} & calc_fout_int_87_sum);
assign calc_fout_88 = ({32{calc_fout_int_vld[88]}} & calc_fout_int_88_sum);
assign calc_fout_89 = ({32{calc_fout_int_vld[89]}} & calc_fout_int_89_sum);
assign calc_fout_90 = ({32{calc_fout_int_vld[90]}} & calc_fout_int_90_sum);
assign calc_fout_91 = ({32{calc_fout_int_vld[91]}} & calc_fout_int_91_sum);
assign calc_fout_92 = ({32{calc_fout_int_vld[92]}} & calc_fout_int_92_sum);
assign calc_fout_93 = ({32{calc_fout_int_vld[93]}} & calc_fout_int_93_sum);
assign calc_fout_94 = ({32{calc_fout_int_vld[94]}} & calc_fout_int_94_sum);
assign calc_fout_95 = ({32{calc_fout_int_vld[95]}} & calc_fout_int_95_sum);
assign calc_fout_96 = ({32{calc_fout_int_vld[96]}} & calc_fout_int_96_sum);
assign calc_fout_97 = ({32{calc_fout_int_vld[97]}} & calc_fout_int_97_sum);
assign calc_fout_98 = ({32{calc_fout_int_vld[98]}} & calc_fout_int_98_sum);
assign calc_fout_99 = ({32{calc_fout_int_vld[99]}} & calc_fout_int_99_sum);
assign calc_fout_100 = ({32{calc_fout_int_vld[100]}} & calc_fout_int_100_sum);
assign calc_fout_101 = ({32{calc_fout_int_vld[101]}} & calc_fout_int_101_sum);
assign calc_fout_102 = ({32{calc_fout_int_vld[102]}} & calc_fout_int_102_sum);
assign calc_fout_103 = ({32{calc_fout_int_vld[103]}} & calc_fout_int_103_sum);
assign calc_fout_104 = ({32{calc_fout_int_vld[104]}} & calc_fout_int_104_sum);
assign calc_fout_105 = ({32{calc_fout_int_vld[105]}} & calc_fout_int_105_sum);
assign calc_fout_106 = ({32{calc_fout_int_vld[106]}} & calc_fout_int_106_sum);
assign calc_fout_107 = ({32{calc_fout_int_vld[107]}} & calc_fout_int_107_sum);
assign calc_fout_108 = ({32{calc_fout_int_vld[108]}} & calc_fout_int_108_sum);
assign calc_fout_109 = ({32{calc_fout_int_vld[109]}} & calc_fout_int_109_sum);
assign calc_fout_110 = ({32{calc_fout_int_vld[110]}} & calc_fout_int_110_sum);
assign calc_fout_111 = ({32{calc_fout_int_vld[111]}} & calc_fout_int_111_sum);
assign calc_fout_112 = ({32{calc_fout_int_vld[112]}} & calc_fout_int_112_sum);
assign calc_fout_113 = ({32{calc_fout_int_vld[113]}} & calc_fout_int_113_sum);
assign calc_fout_114 = ({32{calc_fout_int_vld[114]}} & calc_fout_int_114_sum);
assign calc_fout_115 = ({32{calc_fout_int_vld[115]}} & calc_fout_int_115_sum);
assign calc_fout_116 = ({32{calc_fout_int_vld[116]}} & calc_fout_int_116_sum);
assign calc_fout_117 = ({32{calc_fout_int_vld[117]}} & calc_fout_int_117_sum);
assign calc_fout_118 = ({32{calc_fout_int_vld[118]}} & calc_fout_int_118_sum);
assign calc_fout_119 = ({32{calc_fout_int_vld[119]}} & calc_fout_int_119_sum);
assign calc_fout_120 = ({32{calc_fout_int_vld[120]}} & calc_fout_int_120_sum);
assign calc_fout_121 = ({32{calc_fout_int_vld[121]}} & calc_fout_int_121_sum);
assign calc_fout_122 = ({32{calc_fout_int_vld[122]}} & calc_fout_int_122_sum);
assign calc_fout_123 = ({32{calc_fout_int_vld[123]}} & calc_fout_int_123_sum);
assign calc_fout_124 = ({32{calc_fout_int_vld[124]}} & calc_fout_int_124_sum);
assign calc_fout_125 = ({32{calc_fout_int_vld[125]}} & calc_fout_int_125_sum);
assign calc_fout_126 = ({32{calc_fout_int_vld[126]}} & calc_fout_int_126_sum);
assign calc_fout_127 = ({32{calc_fout_int_vld[127]}} & calc_fout_int_127_sum);




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
  nv_assert_never #(0,0,"Error! calc_pout_int_vld & calc_pout_fp_vld are conflict!")      zzz_assert_never_33x (nvdla_core_clk, `ASSERT_RESET, ((|(calc_pout_int_vld[63:0] & calc_pout_fp_vld)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! calc_fout_int_vld & calc_fout_fp_vld are conflict!")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, ((|(calc_fout_int_vld[63:0] & calc_fout_fp_vld)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! cell partial valid and control partial valid are conflict!")      zzz_assert_never_35x (nvdla_core_clk, `ASSERT_RESET, ((|{calc_pout_int_vld, calc_pout_fp_vld}) & ~calc_valid_out)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! cell final valid and control final valid are conflict!")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, ((|{calc_fout_int_vld, calc_fout_fp_vld}) & ~calc_dlv_valid_out)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// Output to assmebly buffers                         /////
//////////////////////////////////////////////////////////////


assign abuf_wr_elem_0 = calc_pout_0;
assign abuf_wr_elem_1 = calc_pout_1;
assign abuf_wr_elem_2 = calc_pout_2;
assign abuf_wr_elem_3 = calc_pout_3;
assign abuf_wr_elem_4 = calc_pout_4;
assign abuf_wr_elem_5 = calc_pout_5;
assign abuf_wr_elem_6 = calc_pout_6;
assign abuf_wr_elem_7 = calc_pout_7;
assign abuf_wr_elem_8 = calc_pout_8;
assign abuf_wr_elem_9 = calc_pout_9;
assign abuf_wr_elem_10 = calc_pout_10;
assign abuf_wr_elem_11 = calc_pout_11;
assign abuf_wr_elem_12 = calc_pout_12;
assign abuf_wr_elem_13 = calc_pout_13;
assign abuf_wr_elem_14 = calc_pout_14;
assign abuf_wr_elem_15 = calc_pout_15;


assign abuf_wr_elem_16 = (cfg_is_wg[0]) ? calc_pout_16 : calc_pout_0;
assign abuf_wr_elem_17 = (cfg_is_wg[1]) ? calc_pout_17 : calc_pout_1;
assign abuf_wr_elem_18 = (cfg_is_wg[2]) ? calc_pout_18 : calc_pout_2;
assign abuf_wr_elem_19 = (cfg_is_wg[3]) ? calc_pout_19 : calc_pout_3;
assign abuf_wr_elem_20 = (cfg_is_wg[4]) ? calc_pout_20 : calc_pout_4;
assign abuf_wr_elem_21 = (cfg_is_wg[5]) ? calc_pout_21 : calc_pout_5;
assign abuf_wr_elem_22 = (cfg_is_wg[6]) ? calc_pout_22 : calc_pout_6;
assign abuf_wr_elem_23 = (cfg_is_wg[7]) ? calc_pout_23 : calc_pout_7;
assign abuf_wr_elem_24 = (cfg_is_wg[8]) ? calc_pout_24 : calc_pout_8;
assign abuf_wr_elem_25 = (cfg_is_wg[9]) ? calc_pout_25 : calc_pout_9;
assign abuf_wr_elem_26 = (cfg_is_wg[10]) ? calc_pout_26 : calc_pout_10;
assign abuf_wr_elem_27 = (cfg_is_wg[11]) ? calc_pout_27 : calc_pout_11;
assign abuf_wr_elem_28 = (cfg_is_wg[12]) ? calc_pout_28 : calc_pout_12;
assign abuf_wr_elem_29 = (cfg_is_wg[13]) ? calc_pout_29 : calc_pout_13;
assign abuf_wr_elem_30 = (cfg_is_wg[14]) ? calc_pout_30 : calc_pout_14;
assign abuf_wr_elem_31 = (cfg_is_wg[15]) ? calc_pout_31 : calc_pout_15;
assign abuf_wr_elem_32 = (cfg_is_wg[16]) ? calc_pout_32 : calc_pout_0;
assign abuf_wr_elem_33 = (cfg_is_wg[17]) ? calc_pout_33 : calc_pout_1;
assign abuf_wr_elem_34 = (cfg_is_wg[18]) ? calc_pout_34 : calc_pout_2;
assign abuf_wr_elem_35 = (cfg_is_wg[19]) ? calc_pout_35 : calc_pout_3;
assign abuf_wr_elem_36 = (cfg_is_wg[20]) ? calc_pout_36 : calc_pout_4;
assign abuf_wr_elem_37 = (cfg_is_wg[21]) ? calc_pout_37 : calc_pout_5;
assign abuf_wr_elem_38 = (cfg_is_wg[22]) ? calc_pout_38 : calc_pout_6;
assign abuf_wr_elem_39 = (cfg_is_wg[23]) ? calc_pout_39 : calc_pout_7;
assign abuf_wr_elem_40 = (cfg_is_wg[24]) ? calc_pout_40 : calc_pout_8;
assign abuf_wr_elem_41 = (cfg_is_wg[25]) ? calc_pout_41 : calc_pout_9;
assign abuf_wr_elem_42 = (cfg_is_wg[26]) ? calc_pout_42 : calc_pout_10;
assign abuf_wr_elem_43 = (cfg_is_wg[27]) ? calc_pout_43 : calc_pout_11;
assign abuf_wr_elem_44 = (cfg_is_wg[28]) ? calc_pout_44 : calc_pout_12;
assign abuf_wr_elem_45 = (cfg_is_wg[29]) ? calc_pout_45 : calc_pout_13;
assign abuf_wr_elem_46 = (cfg_is_wg[30]) ? calc_pout_46 : calc_pout_14;
assign abuf_wr_elem_47 = (cfg_is_wg[31]) ? calc_pout_47 : calc_pout_15;
assign abuf_wr_elem_48 = (cfg_is_wg[32]) ? calc_pout_48 : calc_pout_0;
assign abuf_wr_elem_49 = (cfg_is_wg[33]) ? calc_pout_49 : calc_pout_1;
assign abuf_wr_elem_50 = (cfg_is_wg[34]) ? calc_pout_50 : calc_pout_2;
assign abuf_wr_elem_51 = (cfg_is_wg[35]) ? calc_pout_51 : calc_pout_3;
assign abuf_wr_elem_52 = (cfg_is_wg[36]) ? calc_pout_52 : calc_pout_4;
assign abuf_wr_elem_53 = (cfg_is_wg[37]) ? calc_pout_53 : calc_pout_5;
assign abuf_wr_elem_54 = (cfg_is_wg[38]) ? calc_pout_54 : calc_pout_6;
assign abuf_wr_elem_55 = (cfg_is_wg[39]) ? calc_pout_55 : calc_pout_7;
assign abuf_wr_elem_56 = (cfg_is_wg[40]) ? calc_pout_56 : calc_pout_8;
assign abuf_wr_elem_57 = (cfg_is_wg[41]) ? calc_pout_57 : calc_pout_9;
assign abuf_wr_elem_58 = (cfg_is_wg[42]) ? calc_pout_58 : calc_pout_10;
assign abuf_wr_elem_59 = (cfg_is_wg[43]) ? calc_pout_59 : calc_pout_11;
assign abuf_wr_elem_60 = (cfg_is_wg[44]) ? calc_pout_60 : calc_pout_12;
assign abuf_wr_elem_61 = (cfg_is_wg[45]) ? calc_pout_61 : calc_pout_13;
assign abuf_wr_elem_62 = (cfg_is_wg[46]) ? calc_pout_62 : calc_pout_14;
assign abuf_wr_elem_63 = (cfg_is_wg[47]) ? calc_pout_63 : calc_pout_15;


assign abuf_wr_elem_64 = calc_pout_64;
assign abuf_wr_elem_65 = calc_pout_65;
assign abuf_wr_elem_66 = calc_pout_66;
assign abuf_wr_elem_67 = calc_pout_67;
assign abuf_wr_elem_68 = calc_pout_68;
assign abuf_wr_elem_69 = calc_pout_69;
assign abuf_wr_elem_70 = calc_pout_70;
assign abuf_wr_elem_71 = calc_pout_71;
assign abuf_wr_elem_72 = calc_pout_72;
assign abuf_wr_elem_73 = calc_pout_73;
assign abuf_wr_elem_74 = calc_pout_74;
assign abuf_wr_elem_75 = calc_pout_75;
assign abuf_wr_elem_76 = calc_pout_76;
assign abuf_wr_elem_77 = calc_pout_77;
assign abuf_wr_elem_78 = calc_pout_78;
assign abuf_wr_elem_79 = calc_pout_79;


assign abuf_wr_elem_80 = (cfg_is_wg[48]) ? calc_pout_80 : calc_pout_64;
assign abuf_wr_elem_81 = (cfg_is_wg[49]) ? calc_pout_81 : calc_pout_65;
assign abuf_wr_elem_82 = (cfg_is_wg[50]) ? calc_pout_82 : calc_pout_66;
assign abuf_wr_elem_83 = (cfg_is_wg[51]) ? calc_pout_83 : calc_pout_67;
assign abuf_wr_elem_84 = (cfg_is_wg[52]) ? calc_pout_84 : calc_pout_68;
assign abuf_wr_elem_85 = (cfg_is_wg[53]) ? calc_pout_85 : calc_pout_69;
assign abuf_wr_elem_86 = (cfg_is_wg[54]) ? calc_pout_86 : calc_pout_70;
assign abuf_wr_elem_87 = (cfg_is_wg[55]) ? calc_pout_87 : calc_pout_71;
assign abuf_wr_elem_88 = (cfg_is_wg[56]) ? calc_pout_88 : calc_pout_72;
assign abuf_wr_elem_89 = (cfg_is_wg[57]) ? calc_pout_89 : calc_pout_73;
assign abuf_wr_elem_90 = (cfg_is_wg[58]) ? calc_pout_90 : calc_pout_74;
assign abuf_wr_elem_91 = (cfg_is_wg[59]) ? calc_pout_91 : calc_pout_75;
assign abuf_wr_elem_92 = (cfg_is_wg[60]) ? calc_pout_92 : calc_pout_76;
assign abuf_wr_elem_93 = (cfg_is_wg[61]) ? calc_pout_93 : calc_pout_77;
assign abuf_wr_elem_94 = (cfg_is_wg[62]) ? calc_pout_94 : calc_pout_78;
assign abuf_wr_elem_95 = (cfg_is_wg[63]) ? calc_pout_95 : calc_pout_79;
assign abuf_wr_elem_96 = (cfg_is_wg[64]) ? calc_pout_96 : calc_pout_64;
assign abuf_wr_elem_97 = (cfg_is_wg[65]) ? calc_pout_97 : calc_pout_65;
assign abuf_wr_elem_98 = (cfg_is_wg[66]) ? calc_pout_98 : calc_pout_66;
assign abuf_wr_elem_99 = (cfg_is_wg[67]) ? calc_pout_99 : calc_pout_67;
assign abuf_wr_elem_100 = (cfg_is_wg[68]) ? calc_pout_100 : calc_pout_68;
assign abuf_wr_elem_101 = (cfg_is_wg[69]) ? calc_pout_101 : calc_pout_69;
assign abuf_wr_elem_102 = (cfg_is_wg[70]) ? calc_pout_102 : calc_pout_70;
assign abuf_wr_elem_103 = (cfg_is_wg[71]) ? calc_pout_103 : calc_pout_71;
assign abuf_wr_elem_104 = (cfg_is_wg[72]) ? calc_pout_104 : calc_pout_72;
assign abuf_wr_elem_105 = (cfg_is_wg[73]) ? calc_pout_105 : calc_pout_73;
assign abuf_wr_elem_106 = (cfg_is_wg[74]) ? calc_pout_106 : calc_pout_74;
assign abuf_wr_elem_107 = (cfg_is_wg[75]) ? calc_pout_107 : calc_pout_75;
assign abuf_wr_elem_108 = (cfg_is_wg[76]) ? calc_pout_108 : calc_pout_76;
assign abuf_wr_elem_109 = (cfg_is_wg[77]) ? calc_pout_109 : calc_pout_77;
assign abuf_wr_elem_110 = (cfg_is_wg[78]) ? calc_pout_110 : calc_pout_78;
assign abuf_wr_elem_111 = (cfg_is_wg[79]) ? calc_pout_111 : calc_pout_79;
assign abuf_wr_elem_112 = (cfg_is_wg[80]) ? calc_pout_112 : calc_pout_64;
assign abuf_wr_elem_113 = (cfg_is_wg[81]) ? calc_pout_113 : calc_pout_65;
assign abuf_wr_elem_114 = (cfg_is_wg[82]) ? calc_pout_114 : calc_pout_66;
assign abuf_wr_elem_115 = (cfg_is_wg[83]) ? calc_pout_115 : calc_pout_67;
assign abuf_wr_elem_116 = (cfg_is_wg[84]) ? calc_pout_116 : calc_pout_68;
assign abuf_wr_elem_117 = (cfg_is_wg[85]) ? calc_pout_117 : calc_pout_69;
assign abuf_wr_elem_118 = (cfg_is_wg[86]) ? calc_pout_118 : calc_pout_70;
assign abuf_wr_elem_119 = (cfg_is_wg[87]) ? calc_pout_119 : calc_pout_71;
assign abuf_wr_elem_120 = (cfg_is_wg[88]) ? calc_pout_120 : calc_pout_72;
assign abuf_wr_elem_121 = (cfg_is_wg[89]) ? calc_pout_121 : calc_pout_73;
assign abuf_wr_elem_122 = (cfg_is_wg[90]) ? calc_pout_122 : calc_pout_74;
assign abuf_wr_elem_123 = (cfg_is_wg[91]) ? calc_pout_123 : calc_pout_75;
assign abuf_wr_elem_124 = (cfg_is_wg[92]) ? calc_pout_124 : calc_pout_76;
assign abuf_wr_elem_125 = (cfg_is_wg[93]) ? calc_pout_125 : calc_pout_77;
assign abuf_wr_elem_126 = (cfg_is_wg[94]) ? calc_pout_126 : calc_pout_78;
assign abuf_wr_elem_127 = (cfg_is_wg[95]) ? calc_pout_127 : calc_pout_79;




always @(
  abuf_wr_elem_127
  or abuf_wr_elem_126
  or abuf_wr_elem_125
  or abuf_wr_elem_124
  or abuf_wr_elem_123
  or abuf_wr_elem_122
  or abuf_wr_elem_121
  or abuf_wr_elem_120
  or abuf_wr_elem_119
  or abuf_wr_elem_118
  or abuf_wr_elem_117
  or abuf_wr_elem_116
  or abuf_wr_elem_115
  or abuf_wr_elem_114
  or abuf_wr_elem_113
  or abuf_wr_elem_112
  or abuf_wr_elem_111
  or abuf_wr_elem_110
  or abuf_wr_elem_109
  or abuf_wr_elem_108
  or abuf_wr_elem_107
  or abuf_wr_elem_106
  or abuf_wr_elem_105
  or abuf_wr_elem_104
  or abuf_wr_elem_103
  or abuf_wr_elem_102
  or abuf_wr_elem_101
  or abuf_wr_elem_100
  or abuf_wr_elem_99
  or abuf_wr_elem_98
  or abuf_wr_elem_97
  or abuf_wr_elem_96
  or abuf_wr_elem_95
  or abuf_wr_elem_94
  or abuf_wr_elem_93
  or abuf_wr_elem_92
  or abuf_wr_elem_91
  or abuf_wr_elem_90
  or abuf_wr_elem_89
  or abuf_wr_elem_88
  or abuf_wr_elem_87
  or abuf_wr_elem_86
  or abuf_wr_elem_85
  or abuf_wr_elem_84
  or abuf_wr_elem_83
  or abuf_wr_elem_82
  or abuf_wr_elem_81
  or abuf_wr_elem_80
  or abuf_wr_elem_79
  or abuf_wr_elem_78
  or abuf_wr_elem_77
  or abuf_wr_elem_76
  or abuf_wr_elem_75
  or abuf_wr_elem_74
  or abuf_wr_elem_73
  or abuf_wr_elem_72
  or abuf_wr_elem_71
  or abuf_wr_elem_70
  or abuf_wr_elem_69
  or abuf_wr_elem_68
  or abuf_wr_elem_67
  or abuf_wr_elem_66
  or abuf_wr_elem_65
  or abuf_wr_elem_64
  or abuf_wr_elem_63
  or abuf_wr_elem_62
  or abuf_wr_elem_61
  or abuf_wr_elem_60
  or abuf_wr_elem_59
  or abuf_wr_elem_58
  or abuf_wr_elem_57
  or abuf_wr_elem_56
  or abuf_wr_elem_55
  or abuf_wr_elem_54
  or abuf_wr_elem_53
  or abuf_wr_elem_52
  or abuf_wr_elem_51
  or abuf_wr_elem_50
  or abuf_wr_elem_49
  or abuf_wr_elem_48
  or abuf_wr_elem_47
  or abuf_wr_elem_46
  or abuf_wr_elem_45
  or abuf_wr_elem_44
  or abuf_wr_elem_43
  or abuf_wr_elem_42
  or abuf_wr_elem_41
  or abuf_wr_elem_40
  or abuf_wr_elem_39
  or abuf_wr_elem_38
  or abuf_wr_elem_37
  or abuf_wr_elem_36
  or abuf_wr_elem_35
  or abuf_wr_elem_34
  or abuf_wr_elem_33
  or abuf_wr_elem_32
  or abuf_wr_elem_31
  or abuf_wr_elem_30
  or abuf_wr_elem_29
  or abuf_wr_elem_28
  or abuf_wr_elem_27
  or abuf_wr_elem_26
  or abuf_wr_elem_25
  or abuf_wr_elem_24
  or abuf_wr_elem_23
  or abuf_wr_elem_22
  or abuf_wr_elem_21
  or abuf_wr_elem_20
  or abuf_wr_elem_19
  or abuf_wr_elem_18
  or abuf_wr_elem_17
  or abuf_wr_elem_16
  or abuf_wr_elem_15
  or abuf_wr_elem_14
  or abuf_wr_elem_13
  or abuf_wr_elem_12
  or abuf_wr_elem_11
  or abuf_wr_elem_10
  or abuf_wr_elem_9
  or abuf_wr_elem_8
  or abuf_wr_elem_7
  or abuf_wr_elem_6
  or abuf_wr_elem_5
  or abuf_wr_elem_4
  or abuf_wr_elem_3
  or abuf_wr_elem_2
  or abuf_wr_elem_1
  or abuf_wr_elem_0
  ) begin
    {abuf_wr_data_7_w, abuf_wr_data_6_w, abuf_wr_data_5_w, abuf_wr_data_4_w, abuf_wr_data_3_w, abuf_wr_data_2_w, abuf_wr_data_1_w, abuf_wr_data_0_w}
        = {abuf_wr_elem_127, abuf_wr_elem_126, abuf_wr_elem_125, abuf_wr_elem_124, abuf_wr_elem_123, abuf_wr_elem_122, abuf_wr_elem_121, abuf_wr_elem_120, abuf_wr_elem_119, abuf_wr_elem_118, abuf_wr_elem_117, abuf_wr_elem_116, abuf_wr_elem_115, abuf_wr_elem_114, abuf_wr_elem_113, abuf_wr_elem_112, abuf_wr_elem_111, abuf_wr_elem_110, abuf_wr_elem_109, abuf_wr_elem_108, abuf_wr_elem_107, abuf_wr_elem_106, abuf_wr_elem_105, abuf_wr_elem_104, abuf_wr_elem_103, abuf_wr_elem_102, abuf_wr_elem_101, abuf_wr_elem_100, abuf_wr_elem_99, abuf_wr_elem_98, abuf_wr_elem_97, abuf_wr_elem_96, abuf_wr_elem_95, abuf_wr_elem_94, abuf_wr_elem_93, abuf_wr_elem_92, abuf_wr_elem_91, abuf_wr_elem_90, abuf_wr_elem_89, abuf_wr_elem_88, abuf_wr_elem_87, abuf_wr_elem_86, abuf_wr_elem_85, abuf_wr_elem_84, abuf_wr_elem_83, abuf_wr_elem_82, abuf_wr_elem_81, abuf_wr_elem_80, abuf_wr_elem_79, abuf_wr_elem_78, abuf_wr_elem_77, abuf_wr_elem_76, abuf_wr_elem_75, abuf_wr_elem_74, abuf_wr_elem_73, abuf_wr_elem_72, abuf_wr_elem_71, abuf_wr_elem_70, abuf_wr_elem_69, abuf_wr_elem_68, abuf_wr_elem_67, abuf_wr_elem_66, abuf_wr_elem_65, abuf_wr_elem_64, abuf_wr_elem_63, abuf_wr_elem_62, abuf_wr_elem_61, abuf_wr_elem_60, abuf_wr_elem_59, abuf_wr_elem_58, abuf_wr_elem_57, abuf_wr_elem_56, abuf_wr_elem_55, abuf_wr_elem_54, abuf_wr_elem_53, abuf_wr_elem_52, abuf_wr_elem_51, abuf_wr_elem_50, abuf_wr_elem_49, abuf_wr_elem_48, abuf_wr_elem_47, abuf_wr_elem_46, abuf_wr_elem_45, abuf_wr_elem_44, abuf_wr_elem_43, abuf_wr_elem_42, abuf_wr_elem_41, abuf_wr_elem_40, abuf_wr_elem_39, abuf_wr_elem_38, abuf_wr_elem_37, abuf_wr_elem_36, abuf_wr_elem_35, abuf_wr_elem_34, abuf_wr_elem_33, abuf_wr_elem_32, abuf_wr_elem_31, abuf_wr_elem_30, abuf_wr_elem_29, abuf_wr_elem_28, abuf_wr_elem_27, abuf_wr_elem_26, abuf_wr_elem_25, abuf_wr_elem_24, abuf_wr_elem_23, abuf_wr_elem_22, abuf_wr_elem_21, abuf_wr_elem_20, abuf_wr_elem_19, abuf_wr_elem_18, abuf_wr_elem_17, abuf_wr_elem_16, abuf_wr_elem_15, abuf_wr_elem_14, abuf_wr_elem_13, abuf_wr_elem_12, abuf_wr_elem_11, abuf_wr_elem_10, abuf_wr_elem_9, abuf_wr_elem_8, abuf_wr_elem_7, abuf_wr_elem_6, abuf_wr_elem_5, abuf_wr_elem_4, abuf_wr_elem_3, abuf_wr_elem_2, abuf_wr_elem_1, abuf_wr_elem_0};
end





always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    abuf_wr_en <= {8{1'b0}};
  end else begin
  abuf_wr_en <= calc_wr_en_out;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    abuf_wr_addr <= {5{1'b0}};
  end else begin
  if ((|calc_wr_en_out) == 1'b1) begin
    abuf_wr_addr <= calc_addr_out;
  // VCS coverage off
  end else if ((|calc_wr_en_out) == 1'b0) begin
  end else begin
    abuf_wr_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_37x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(|calc_wr_en_out))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk) begin
  if ((calc_wr_en_out[0]) == 1'b1) begin
    abuf_wr_data_0 <= abuf_wr_data_0_w;
  // VCS coverage off
  end else if ((calc_wr_en_out[0]) == 1'b0) begin
  end else begin
    abuf_wr_data_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_wr_en_out[1]) == 1'b1) begin
    abuf_wr_data_1 <= abuf_wr_data_1_w;
  // VCS coverage off
  end else if ((calc_wr_en_out[1]) == 1'b0) begin
  end else begin
    abuf_wr_data_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_wr_en_out[2]) == 1'b1) begin
    abuf_wr_data_2 <= abuf_wr_data_2_w;
  // VCS coverage off
  end else if ((calc_wr_en_out[2]) == 1'b0) begin
  end else begin
    abuf_wr_data_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_wr_en_out[3]) == 1'b1) begin
    abuf_wr_data_3 <= abuf_wr_data_3_w;
  // VCS coverage off
  end else if ((calc_wr_en_out[3]) == 1'b0) begin
  end else begin
    abuf_wr_data_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_wr_en_out[4]) == 1'b1) begin
    abuf_wr_data_4 <= abuf_wr_data_4_w;
  // VCS coverage off
  end else if ((calc_wr_en_out[4]) == 1'b0) begin
  end else begin
    abuf_wr_data_4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_wr_en_out[5]) == 1'b1) begin
    abuf_wr_data_5 <= abuf_wr_data_5_w;
  // VCS coverage off
  end else if ((calc_wr_en_out[5]) == 1'b0) begin
  end else begin
    abuf_wr_data_5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_wr_en_out[6]) == 1'b1) begin
    abuf_wr_data_6 <= abuf_wr_data_6_w;
  // VCS coverage off
  end else if ((calc_wr_en_out[6]) == 1'b0) begin
  end else begin
    abuf_wr_data_6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_wr_en_out[7]) == 1'b1) begin
    abuf_wr_data_7 <= abuf_wr_data_7_w;
  // VCS coverage off
  end else if ((calc_wr_en_out[7]) == 1'b0) begin
  end else begin
    abuf_wr_data_7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

//////////////////////////////////////////////////////////////
///// pipe register 3                                    /////
//////////////////////////////////////////////////////////////

assign calc_dlv_elem_0 = calc_fout_0;
assign calc_dlv_elem_1 = cfg_is_int8[64] ? calc_fout_64 : calc_fout_1;
assign calc_dlv_elem_2 = cfg_is_int8[65] ? calc_fout_1 : calc_fout_2;
assign calc_dlv_elem_3 = cfg_is_int8[66] ? calc_fout_65 : calc_fout_3;
assign calc_dlv_elem_4 = cfg_is_int8[67] ? calc_fout_2 : calc_fout_4;
assign calc_dlv_elem_5 = cfg_is_int8[68] ? calc_fout_66 : calc_fout_5;
assign calc_dlv_elem_6 = cfg_is_int8[69] ? calc_fout_3 : calc_fout_6;
assign calc_dlv_elem_7 = cfg_is_int8[70] ? calc_fout_67 : calc_fout_7;
assign calc_dlv_elem_8 = cfg_is_int8[71] ? calc_fout_4 : calc_fout_8;
assign calc_dlv_elem_9 = cfg_is_int8[72] ? calc_fout_68 : calc_fout_9;
assign calc_dlv_elem_10 = cfg_is_int8[73] ? calc_fout_5 : calc_fout_10;
assign calc_dlv_elem_11 = cfg_is_int8[74] ? calc_fout_69 : calc_fout_11;
assign calc_dlv_elem_12 = cfg_is_int8[75] ? calc_fout_6 : calc_fout_12;
assign calc_dlv_elem_13 = cfg_is_int8[76] ? calc_fout_70 : calc_fout_13;
assign calc_dlv_elem_14 = cfg_is_int8[77] ? calc_fout_7 : calc_fout_14;
assign calc_dlv_elem_15 = cfg_is_int8[78] ? calc_fout_71 : calc_fout_15;
assign calc_dlv_elem_16 = cfg_is_int8[79] ? calc_fout_8 : calc_fout_16;
assign calc_dlv_elem_17 = cfg_is_int8[80] ? calc_fout_72 : calc_fout_17;
assign calc_dlv_elem_18 = cfg_is_int8[81] ? calc_fout_9 : calc_fout_18;
assign calc_dlv_elem_19 = cfg_is_int8[82] ? calc_fout_73 : calc_fout_19;
assign calc_dlv_elem_20 = cfg_is_int8[83] ? calc_fout_10 : calc_fout_20;
assign calc_dlv_elem_21 = cfg_is_int8[84] ? calc_fout_74 : calc_fout_21;
assign calc_dlv_elem_22 = cfg_is_int8[85] ? calc_fout_11 : calc_fout_22;
assign calc_dlv_elem_23 = cfg_is_int8[86] ? calc_fout_75 : calc_fout_23;
assign calc_dlv_elem_24 = cfg_is_int8[87] ? calc_fout_12 : calc_fout_24;
assign calc_dlv_elem_25 = cfg_is_int8[88] ? calc_fout_76 : calc_fout_25;
assign calc_dlv_elem_26 = cfg_is_int8[89] ? calc_fout_13 : calc_fout_26;
assign calc_dlv_elem_27 = cfg_is_int8[90] ? calc_fout_77 : calc_fout_27;
assign calc_dlv_elem_28 = cfg_is_int8[91] ? calc_fout_14 : calc_fout_28;
assign calc_dlv_elem_29 = cfg_is_int8[92] ? calc_fout_78 : calc_fout_29;
assign calc_dlv_elem_30 = cfg_is_int8[93] ? calc_fout_15 : calc_fout_30;
assign calc_dlv_elem_31 = cfg_is_int8[94] ? calc_fout_79 : calc_fout_31;
assign calc_dlv_elem_32 = cfg_is_int8[95] ? calc_fout_16 : calc_fout_32;
assign calc_dlv_elem_33 = cfg_is_int8[96] ? calc_fout_80 : calc_fout_33;
assign calc_dlv_elem_34 = cfg_is_int8[97] ? calc_fout_17 : calc_fout_34;
assign calc_dlv_elem_35 = cfg_is_int8[98] ? calc_fout_81 : calc_fout_35;
assign calc_dlv_elem_36 = cfg_is_int8[99] ? calc_fout_18 : calc_fout_36;
assign calc_dlv_elem_37 = cfg_is_int8[100] ? calc_fout_82 : calc_fout_37;
assign calc_dlv_elem_38 = cfg_is_int8[101] ? calc_fout_19 : calc_fout_38;
assign calc_dlv_elem_39 = cfg_is_int8[102] ? calc_fout_83 : calc_fout_39;
assign calc_dlv_elem_40 = cfg_is_int8[103] ? calc_fout_20 : calc_fout_40;
assign calc_dlv_elem_41 = cfg_is_int8[104] ? calc_fout_84 : calc_fout_41;
assign calc_dlv_elem_42 = cfg_is_int8[105] ? calc_fout_21 : calc_fout_42;
assign calc_dlv_elem_43 = cfg_is_int8[106] ? calc_fout_85 : calc_fout_43;
assign calc_dlv_elem_44 = cfg_is_int8[107] ? calc_fout_22 : calc_fout_44;
assign calc_dlv_elem_45 = cfg_is_int8[108] ? calc_fout_86 : calc_fout_45;
assign calc_dlv_elem_46 = cfg_is_int8[109] ? calc_fout_23 : calc_fout_46;
assign calc_dlv_elem_47 = cfg_is_int8[110] ? calc_fout_87 : calc_fout_47;
assign calc_dlv_elem_48 = cfg_is_int8[111] ? calc_fout_24 : calc_fout_48;
assign calc_dlv_elem_49 = cfg_is_int8[112] ? calc_fout_88 : calc_fout_49;
assign calc_dlv_elem_50 = cfg_is_int8[113] ? calc_fout_25 : calc_fout_50;
assign calc_dlv_elem_51 = cfg_is_int8[114] ? calc_fout_89 : calc_fout_51;
assign calc_dlv_elem_52 = cfg_is_int8[115] ? calc_fout_26 : calc_fout_52;
assign calc_dlv_elem_53 = cfg_is_int8[116] ? calc_fout_90 : calc_fout_53;
assign calc_dlv_elem_54 = cfg_is_int8[117] ? calc_fout_27 : calc_fout_54;
assign calc_dlv_elem_55 = cfg_is_int8[118] ? calc_fout_91 : calc_fout_55;
assign calc_dlv_elem_56 = cfg_is_int8[119] ? calc_fout_28 : calc_fout_56;
assign calc_dlv_elem_57 = cfg_is_int8[120] ? calc_fout_92 : calc_fout_57;
assign calc_dlv_elem_58 = cfg_is_int8[121] ? calc_fout_29 : calc_fout_58;
assign calc_dlv_elem_59 = cfg_is_int8[122] ? calc_fout_93 : calc_fout_59;
assign calc_dlv_elem_60 = cfg_is_int8[123] ? calc_fout_30 : calc_fout_60;
assign calc_dlv_elem_61 = cfg_is_int8[124] ? calc_fout_94 : calc_fout_61;
assign calc_dlv_elem_62 = cfg_is_int8[125] ? calc_fout_31 : calc_fout_62;
assign calc_dlv_elem_63 = cfg_is_int8[126] ? calc_fout_95 : calc_fout_63;




assign calc_dlv_elem_64 = calc_fout_32;
assign calc_dlv_elem_65 = calc_fout_96;
assign calc_dlv_elem_66 = calc_fout_33;
assign calc_dlv_elem_67 = calc_fout_97;
assign calc_dlv_elem_68 = calc_fout_34;
assign calc_dlv_elem_69 = calc_fout_98;
assign calc_dlv_elem_70 = calc_fout_35;
assign calc_dlv_elem_71 = calc_fout_99;
assign calc_dlv_elem_72 = calc_fout_36;
assign calc_dlv_elem_73 = calc_fout_100;
assign calc_dlv_elem_74 = calc_fout_37;
assign calc_dlv_elem_75 = calc_fout_101;
assign calc_dlv_elem_76 = calc_fout_38;
assign calc_dlv_elem_77 = calc_fout_102;
assign calc_dlv_elem_78 = calc_fout_39;
assign calc_dlv_elem_79 = calc_fout_103;
assign calc_dlv_elem_80 = calc_fout_40;
assign calc_dlv_elem_81 = calc_fout_104;
assign calc_dlv_elem_82 = calc_fout_41;
assign calc_dlv_elem_83 = calc_fout_105;
assign calc_dlv_elem_84 = calc_fout_42;
assign calc_dlv_elem_85 = calc_fout_106;
assign calc_dlv_elem_86 = calc_fout_43;
assign calc_dlv_elem_87 = calc_fout_107;
assign calc_dlv_elem_88 = calc_fout_44;
assign calc_dlv_elem_89 = calc_fout_108;
assign calc_dlv_elem_90 = calc_fout_45;
assign calc_dlv_elem_91 = calc_fout_109;
assign calc_dlv_elem_92 = calc_fout_46;
assign calc_dlv_elem_93 = calc_fout_110;
assign calc_dlv_elem_94 = calc_fout_47;
assign calc_dlv_elem_95 = calc_fout_111;
assign calc_dlv_elem_96 = calc_fout_48;
assign calc_dlv_elem_97 = calc_fout_112;
assign calc_dlv_elem_98 = calc_fout_49;
assign calc_dlv_elem_99 = calc_fout_113;
assign calc_dlv_elem_100 = calc_fout_50;
assign calc_dlv_elem_101 = calc_fout_114;
assign calc_dlv_elem_102 = calc_fout_51;
assign calc_dlv_elem_103 = calc_fout_115;
assign calc_dlv_elem_104 = calc_fout_52;
assign calc_dlv_elem_105 = calc_fout_116;
assign calc_dlv_elem_106 = calc_fout_53;
assign calc_dlv_elem_107 = calc_fout_117;
assign calc_dlv_elem_108 = calc_fout_54;
assign calc_dlv_elem_109 = calc_fout_118;
assign calc_dlv_elem_110 = calc_fout_55;
assign calc_dlv_elem_111 = calc_fout_119;
assign calc_dlv_elem_112 = calc_fout_56;
assign calc_dlv_elem_113 = calc_fout_120;
assign calc_dlv_elem_114 = calc_fout_57;
assign calc_dlv_elem_115 = calc_fout_121;
assign calc_dlv_elem_116 = calc_fout_58;
assign calc_dlv_elem_117 = calc_fout_122;
assign calc_dlv_elem_118 = calc_fout_59;
assign calc_dlv_elem_119 = calc_fout_123;
assign calc_dlv_elem_120 = calc_fout_60;
assign calc_dlv_elem_121 = calc_fout_124;
assign calc_dlv_elem_122 = calc_fout_61;
assign calc_dlv_elem_123 = calc_fout_125;
assign calc_dlv_elem_124 = calc_fout_62;
assign calc_dlv_elem_125 = calc_fout_126;
assign calc_dlv_elem_126 = calc_fout_63;
assign calc_dlv_elem_127 = calc_fout_127;





always @(
  calc_dlv_elem_127
  or calc_dlv_elem_126
  or calc_dlv_elem_125
  or calc_dlv_elem_124
  or calc_dlv_elem_123
  or calc_dlv_elem_122
  or calc_dlv_elem_121
  or calc_dlv_elem_120
  or calc_dlv_elem_119
  or calc_dlv_elem_118
  or calc_dlv_elem_117
  or calc_dlv_elem_116
  or calc_dlv_elem_115
  or calc_dlv_elem_114
  or calc_dlv_elem_113
  or calc_dlv_elem_112
  or calc_dlv_elem_111
  or calc_dlv_elem_110
  or calc_dlv_elem_109
  or calc_dlv_elem_108
  or calc_dlv_elem_107
  or calc_dlv_elem_106
  or calc_dlv_elem_105
  or calc_dlv_elem_104
  or calc_dlv_elem_103
  or calc_dlv_elem_102
  or calc_dlv_elem_101
  or calc_dlv_elem_100
  or calc_dlv_elem_99
  or calc_dlv_elem_98
  or calc_dlv_elem_97
  or calc_dlv_elem_96
  or calc_dlv_elem_95
  or calc_dlv_elem_94
  or calc_dlv_elem_93
  or calc_dlv_elem_92
  or calc_dlv_elem_91
  or calc_dlv_elem_90
  or calc_dlv_elem_89
  or calc_dlv_elem_88
  or calc_dlv_elem_87
  or calc_dlv_elem_86
  or calc_dlv_elem_85
  or calc_dlv_elem_84
  or calc_dlv_elem_83
  or calc_dlv_elem_82
  or calc_dlv_elem_81
  or calc_dlv_elem_80
  or calc_dlv_elem_79
  or calc_dlv_elem_78
  or calc_dlv_elem_77
  or calc_dlv_elem_76
  or calc_dlv_elem_75
  or calc_dlv_elem_74
  or calc_dlv_elem_73
  or calc_dlv_elem_72
  or calc_dlv_elem_71
  or calc_dlv_elem_70
  or calc_dlv_elem_69
  or calc_dlv_elem_68
  or calc_dlv_elem_67
  or calc_dlv_elem_66
  or calc_dlv_elem_65
  or calc_dlv_elem_64
  or calc_dlv_elem_63
  or calc_dlv_elem_62
  or calc_dlv_elem_61
  or calc_dlv_elem_60
  or calc_dlv_elem_59
  or calc_dlv_elem_58
  or calc_dlv_elem_57
  or calc_dlv_elem_56
  or calc_dlv_elem_55
  or calc_dlv_elem_54
  or calc_dlv_elem_53
  or calc_dlv_elem_52
  or calc_dlv_elem_51
  or calc_dlv_elem_50
  or calc_dlv_elem_49
  or calc_dlv_elem_48
  or calc_dlv_elem_47
  or calc_dlv_elem_46
  or calc_dlv_elem_45
  or calc_dlv_elem_44
  or calc_dlv_elem_43
  or calc_dlv_elem_42
  or calc_dlv_elem_41
  or calc_dlv_elem_40
  or calc_dlv_elem_39
  or calc_dlv_elem_38
  or calc_dlv_elem_37
  or calc_dlv_elem_36
  or calc_dlv_elem_35
  or calc_dlv_elem_34
  or calc_dlv_elem_33
  or calc_dlv_elem_32
  or calc_dlv_elem_31
  or calc_dlv_elem_30
  or calc_dlv_elem_29
  or calc_dlv_elem_28
  or calc_dlv_elem_27
  or calc_dlv_elem_26
  or calc_dlv_elem_25
  or calc_dlv_elem_24
  or calc_dlv_elem_23
  or calc_dlv_elem_22
  or calc_dlv_elem_21
  or calc_dlv_elem_20
  or calc_dlv_elem_19
  or calc_dlv_elem_18
  or calc_dlv_elem_17
  or calc_dlv_elem_16
  or calc_dlv_elem_15
  or calc_dlv_elem_14
  or calc_dlv_elem_13
  or calc_dlv_elem_12
  or calc_dlv_elem_11
  or calc_dlv_elem_10
  or calc_dlv_elem_9
  or calc_dlv_elem_8
  or calc_dlv_elem_7
  or calc_dlv_elem_6
  or calc_dlv_elem_5
  or calc_dlv_elem_4
  or calc_dlv_elem_3
  or calc_dlv_elem_2
  or calc_dlv_elem_1
  or calc_dlv_elem_0
  ) begin
    {dlv_data_7_w, dlv_data_6_w, dlv_data_5_w, dlv_data_4_w, dlv_data_3_w, dlv_data_2_w, dlv_data_1_w, dlv_data_0_w} =
        {calc_dlv_elem_127, calc_dlv_elem_126, calc_dlv_elem_125, calc_dlv_elem_124, calc_dlv_elem_123, calc_dlv_elem_122, calc_dlv_elem_121, calc_dlv_elem_120, calc_dlv_elem_119, calc_dlv_elem_118, calc_dlv_elem_117, calc_dlv_elem_116, calc_dlv_elem_115, calc_dlv_elem_114, calc_dlv_elem_113, calc_dlv_elem_112, calc_dlv_elem_111, calc_dlv_elem_110, calc_dlv_elem_109, calc_dlv_elem_108, calc_dlv_elem_107, calc_dlv_elem_106, calc_dlv_elem_105, calc_dlv_elem_104, calc_dlv_elem_103, calc_dlv_elem_102, calc_dlv_elem_101, calc_dlv_elem_100, calc_dlv_elem_99, calc_dlv_elem_98, calc_dlv_elem_97, calc_dlv_elem_96, calc_dlv_elem_95, calc_dlv_elem_94, calc_dlv_elem_93, calc_dlv_elem_92, calc_dlv_elem_91, calc_dlv_elem_90, calc_dlv_elem_89, calc_dlv_elem_88, calc_dlv_elem_87, calc_dlv_elem_86, calc_dlv_elem_85, calc_dlv_elem_84, calc_dlv_elem_83, calc_dlv_elem_82, calc_dlv_elem_81, calc_dlv_elem_80, calc_dlv_elem_79, calc_dlv_elem_78, calc_dlv_elem_77, calc_dlv_elem_76, calc_dlv_elem_75, calc_dlv_elem_74, calc_dlv_elem_73, calc_dlv_elem_72, calc_dlv_elem_71, calc_dlv_elem_70, calc_dlv_elem_69, calc_dlv_elem_68, calc_dlv_elem_67, calc_dlv_elem_66, calc_dlv_elem_65, calc_dlv_elem_64, calc_dlv_elem_63, calc_dlv_elem_62, calc_dlv_elem_61, calc_dlv_elem_60, calc_dlv_elem_59, calc_dlv_elem_58, calc_dlv_elem_57, calc_dlv_elem_56, calc_dlv_elem_55, calc_dlv_elem_54, calc_dlv_elem_53, calc_dlv_elem_52, calc_dlv_elem_51, calc_dlv_elem_50, calc_dlv_elem_49, calc_dlv_elem_48, calc_dlv_elem_47, calc_dlv_elem_46, calc_dlv_elem_45, calc_dlv_elem_44, calc_dlv_elem_43, calc_dlv_elem_42, calc_dlv_elem_41, calc_dlv_elem_40, calc_dlv_elem_39, calc_dlv_elem_38, calc_dlv_elem_37, calc_dlv_elem_36, calc_dlv_elem_35, calc_dlv_elem_34, calc_dlv_elem_33, calc_dlv_elem_32, calc_dlv_elem_31, calc_dlv_elem_30, calc_dlv_elem_29, calc_dlv_elem_28, calc_dlv_elem_27, calc_dlv_elem_26, calc_dlv_elem_25, calc_dlv_elem_24, calc_dlv_elem_23, calc_dlv_elem_22, calc_dlv_elem_21, calc_dlv_elem_20, calc_dlv_elem_19, calc_dlv_elem_18, calc_dlv_elem_17, calc_dlv_elem_16, calc_dlv_elem_15, calc_dlv_elem_14, calc_dlv_elem_13, calc_dlv_elem_12, calc_dlv_elem_11, calc_dlv_elem_10, calc_dlv_elem_9, calc_dlv_elem_8, calc_dlv_elem_7, calc_dlv_elem_6, calc_dlv_elem_5, calc_dlv_elem_4, calc_dlv_elem_3, calc_dlv_elem_2, calc_dlv_elem_1, calc_dlv_elem_0};
end







always @(posedge nvdla_core_clk) begin
  if ((calc_dlv_en_out[0]) == 1'b1) begin
    dlv_data_0 <= dlv_data_0_w;
  // VCS coverage off
  end else if ((calc_dlv_en_out[0]) == 1'b0) begin
  end else begin
    dlv_data_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_dlv_en_out[1]) == 1'b1) begin
    dlv_data_1 <= dlv_data_1_w;
  // VCS coverage off
  end else if ((calc_dlv_en_out[1]) == 1'b0) begin
  end else begin
    dlv_data_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_dlv_en_out[2]) == 1'b1) begin
    dlv_data_2 <= dlv_data_2_w;
  // VCS coverage off
  end else if ((calc_dlv_en_out[2]) == 1'b0) begin
  end else begin
    dlv_data_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_dlv_en_out[3]) == 1'b1) begin
    dlv_data_3 <= dlv_data_3_w;
  // VCS coverage off
  end else if ((calc_dlv_en_out[3]) == 1'b0) begin
  end else begin
    dlv_data_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_dlv_en_out[4]) == 1'b1) begin
    dlv_data_4 <= dlv_data_4_w;
  // VCS coverage off
  end else if ((calc_dlv_en_out[4]) == 1'b0) begin
  end else begin
    dlv_data_4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_dlv_en_out[5]) == 1'b1) begin
    dlv_data_5 <= dlv_data_5_w;
  // VCS coverage off
  end else if ((calc_dlv_en_out[5]) == 1'b0) begin
  end else begin
    dlv_data_5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_dlv_en_out[6]) == 1'b1) begin
    dlv_data_6 <= dlv_data_6_w;
  // VCS coverage off
  end else if ((calc_dlv_en_out[6]) == 1'b0) begin
  end else begin
    dlv_data_6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((calc_dlv_en_out[7]) == 1'b1) begin
    dlv_data_7 <= dlv_data_7_w;
  // VCS coverage off
  end else if ((calc_dlv_en_out[7]) == 1'b0) begin
  end else begin
    dlv_data_7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end



always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_valid <= 1'b0;
  end else begin
  dlv_valid <= calc_dlv_valid_out;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_mask <= {8{1'b0}};
  end else begin
  if ((calc_dlv_valid_out) == 1'b1) begin
    dlv_mask <= calc_dlv_en_out;
  // VCS coverage off
  end else if ((calc_dlv_valid_out) == 1'b0) begin
  end else begin
    dlv_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_38x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_out))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dlv_stripe_end <= 1'b0;
  end else begin
  if ((calc_dlv_valid_out) == 1'b1) begin
    dlv_stripe_end <= calc_stripe_end_out;
  // VCS coverage off
  end else if ((calc_dlv_valid_out) == 1'b0) begin
  end else begin
    dlv_stripe_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_out))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dlv_layer_end <= 1'b0;
  end else begin
  if ((calc_dlv_valid_out) == 1'b1) begin
    dlv_layer_end <= calc_layer_end_out;
  // VCS coverage off
  end else if ((calc_dlv_valid_out) == 1'b0) begin
  end else begin
    dlv_layer_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_out))); // spyglass disable W504 SelfDeterminedExpr-ML 
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


// PKT_PACK_WIRE( nvdla_dbuf_info ,  dlv_ ,  dlv_pd )
assign       dlv_pd[0] =     dlv_stripe_end ;
assign       dlv_pd[1] =     dlv_layer_end ;

//////////////////////////////////////////////////////////////
///// overflow count                                     /////
//////////////////////////////////////////////////////////////

assign dlv_sat_bit = calc_fout_int_sat;
assign dlv_sat_end = calc_layer_end_out & calc_stripe_end_out;
assign dlv_sat_clr = calc_dlv_valid_out & ~dlv_sat_end & dlv_sat_end_d1;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_sat_vld_d1 <= 1'b0;
  end else begin
  dlv_sat_vld_d1 <= calc_dlv_valid_out;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dlv_sat_end_d1 <= 1'b1;
  end else begin
  if ((calc_dlv_valid_out) == 1'b1) begin
    dlv_sat_end_d1 <= dlv_sat_end;
  // VCS coverage off
  end else if ((calc_dlv_valid_out) == 1'b0) begin
  end else begin
    dlv_sat_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_out))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dlv_sat_bit_d1 <= {128{1'b0}};
  end else begin
  if ((calc_dlv_valid_out) == 1'b1) begin
    dlv_sat_bit_d1 <= dlv_sat_bit;
  // VCS coverage off
  end else if ((calc_dlv_valid_out) == 1'b0) begin
  end else begin
    dlv_sat_bit_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(calc_dlv_valid_out))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dlv_sat_clr_d1 <= 1'b0;
  end else begin
  dlv_sat_clr_d1 <= dlv_sat_clr;
  end
end

always @(
  dlv_sat_bit_d1
  ) begin
    sat_sum[7:0] = 
        dlv_sat_bit_d1[127] + dlv_sat_bit_d1[126] + dlv_sat_bit_d1[125] + dlv_sat_bit_d1[124] + dlv_sat_bit_d1[123] + dlv_sat_bit_d1[122] + dlv_sat_bit_d1[121] + dlv_sat_bit_d1[120] + dlv_sat_bit_d1[119] + dlv_sat_bit_d1[118] + dlv_sat_bit_d1[117] + dlv_sat_bit_d1[116] + dlv_sat_bit_d1[115] + dlv_sat_bit_d1[114] + dlv_sat_bit_d1[113] + dlv_sat_bit_d1[112] + dlv_sat_bit_d1[111] + dlv_sat_bit_d1[110] + dlv_sat_bit_d1[109] + dlv_sat_bit_d1[108] + dlv_sat_bit_d1[107] + dlv_sat_bit_d1[106] + dlv_sat_bit_d1[105] + dlv_sat_bit_d1[104] + dlv_sat_bit_d1[103] + dlv_sat_bit_d1[102] + dlv_sat_bit_d1[101] + dlv_sat_bit_d1[100] + dlv_sat_bit_d1[99] + dlv_sat_bit_d1[98] + dlv_sat_bit_d1[97] + dlv_sat_bit_d1[96] + dlv_sat_bit_d1[95] + dlv_sat_bit_d1[94] + dlv_sat_bit_d1[93] + dlv_sat_bit_d1[92] + dlv_sat_bit_d1[91] + dlv_sat_bit_d1[90] + dlv_sat_bit_d1[89] + dlv_sat_bit_d1[88] + dlv_sat_bit_d1[87] + dlv_sat_bit_d1[86] + dlv_sat_bit_d1[85] + dlv_sat_bit_d1[84] + dlv_sat_bit_d1[83] + dlv_sat_bit_d1[82] + dlv_sat_bit_d1[81] + dlv_sat_bit_d1[80] + dlv_sat_bit_d1[79] + dlv_sat_bit_d1[78] + dlv_sat_bit_d1[77] + dlv_sat_bit_d1[76] + dlv_sat_bit_d1[75] + dlv_sat_bit_d1[74] + dlv_sat_bit_d1[73] + dlv_sat_bit_d1[72] + dlv_sat_bit_d1[71] + dlv_sat_bit_d1[70] + dlv_sat_bit_d1[69] + dlv_sat_bit_d1[68] + dlv_sat_bit_d1[67] + dlv_sat_bit_d1[66] + dlv_sat_bit_d1[65] + dlv_sat_bit_d1[64] + dlv_sat_bit_d1[63] + dlv_sat_bit_d1[62] + dlv_sat_bit_d1[61] + dlv_sat_bit_d1[60] + dlv_sat_bit_d1[59] + dlv_sat_bit_d1[58] + dlv_sat_bit_d1[57] + dlv_sat_bit_d1[56] + dlv_sat_bit_d1[55] + dlv_sat_bit_d1[54] + dlv_sat_bit_d1[53] + dlv_sat_bit_d1[52] + dlv_sat_bit_d1[51] + dlv_sat_bit_d1[50] + dlv_sat_bit_d1[49] + dlv_sat_bit_d1[48] + dlv_sat_bit_d1[47] + dlv_sat_bit_d1[46] + dlv_sat_bit_d1[45] + dlv_sat_bit_d1[44] + dlv_sat_bit_d1[43] + dlv_sat_bit_d1[42] + dlv_sat_bit_d1[41] + dlv_sat_bit_d1[40] + dlv_sat_bit_d1[39] + dlv_sat_bit_d1[38] + dlv_sat_bit_d1[37] + dlv_sat_bit_d1[36] + dlv_sat_bit_d1[35] + dlv_sat_bit_d1[34] + dlv_sat_bit_d1[33] + dlv_sat_bit_d1[32] + dlv_sat_bit_d1[31] + dlv_sat_bit_d1[30] + dlv_sat_bit_d1[29] + dlv_sat_bit_d1[28] + dlv_sat_bit_d1[27] + dlv_sat_bit_d1[26] + dlv_sat_bit_d1[25] + dlv_sat_bit_d1[24] + dlv_sat_bit_d1[23] + dlv_sat_bit_d1[22] + dlv_sat_bit_d1[21] + dlv_sat_bit_d1[20] + dlv_sat_bit_d1[19] + dlv_sat_bit_d1[18] + dlv_sat_bit_d1[17] + dlv_sat_bit_d1[16] + dlv_sat_bit_d1[15] + dlv_sat_bit_d1[14] + dlv_sat_bit_d1[13] + dlv_sat_bit_d1[12] + dlv_sat_bit_d1[11] + dlv_sat_bit_d1[10] + dlv_sat_bit_d1[9] + dlv_sat_bit_d1[8] + dlv_sat_bit_d1[7] + dlv_sat_bit_d1[6] + dlv_sat_bit_d1[5] + dlv_sat_bit_d1[4] + dlv_sat_bit_d1[3] + dlv_sat_bit_d1[2] + dlv_sat_bit_d1[1] + dlv_sat_bit_d1[0];
end

always @(
  sat_count
  or sat_sum
  ) begin
    {sat_carry,
     sat_count_inc[31:0]} = sat_count + sat_sum;
end

assign sat_count_w = (dlv_sat_clr_d1) ? {24'b0, sat_sum} :
                     sat_carry ? {32{1'b1}} :
                     sat_count_inc;
assign sat_reg_en = dlv_sat_vld_d1 & ((|sat_sum) | dlv_sat_clr_d1);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sat_count <= {32{1'b0}};
  end else begin
  if ((sat_reg_en) == 1'b1) begin
    sat_count <= sat_count_w;
  // VCS coverage off
  end else if ((sat_reg_en) == 1'b0) begin
  end else begin
    sat_count <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sat_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign dp2reg_sat_count = sat_count;

endmodule // NV_NVDLA_CACC_calculator


