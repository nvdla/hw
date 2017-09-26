// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rwsp_80x514.v

`timescale 1ns / 10ps
module nv_ram_rwsp_80x514 (
        clk,
        ra,
        re,
        ore,
        dout,
        wa,
        we,
        di,
        pwrbus_ram_pd
        );
parameter FORCE_CONTENTION_ASSERTION_RESET_ACTIVE=1'b0;

// port list
input           clk;
input  [6:0]    ra;
input           re;
input           ore;
output [513:0]  dout;
input  [6:0]    wa;
input           we;
input  [513:0]  di;
input  [31:0]   pwrbus_ram_pd;



// This wrapper consists of :  2 Ram cells: RAMPDP_80X288_GL_M1_D2 RAMPDP_80X226_GL_M1_D2 ;  

//Wires for Misc Ports 
wire  DFT_clamp;

//Wires for Mbist Ports 
wire [6:0] mbist_Wa_w0;
wire [1:0] mbist_Di_w0;
wire  mbist_we_w0_0_0;
wire  mbist_we_w0_0_288;
wire [6:0] mbist_Ra_r0;

// verilint 528 off - Variable set but not used
wire [513:0] mbist_Do_r0_int_net;
// verilint 528 on - Variable set but not used
wire  mbist_ce_r0_0_0;
wire  mbist_ce_r0_0_288;
wire  mbist_en_sync;

//Wires for RamAccess Ports 
wire  SI;

// verilint 528 off - Variable set but not used
wire  SO_int_net;
// verilint 528 on - Variable set but not used
wire  shiftDR;
wire  updateDR;
wire  debug_mode;

//Wires for Misc Ports 
wire  mbist_ramaccess_rst_;
wire  ary_atpg_ctl;
wire  write_inh;
wire  scan_ramtms;
wire  iddq_mode;
wire  jtag_readonly_mode;
wire  ary_read_inh;
wire  test_mode;
wire  scan_en;
wire [7:0] svop;

// Use Bbox and clamps to clamp and tie off the DFT signals in the wrapper 
NV_BLKBOX_SRC0 UI_enableDFTmode_async_ld_buf (.Y(DFT_clamp));
wire pre_mbist_Wa_w0_0;
NV_BLKBOX_SRC0_X testInst_mbist_Wa_w0_0 (.Y(pre_mbist_Wa_w0_0));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Wa_w0_0 (.Z(mbist_Wa_w0[0]), .A1(pre_mbist_Wa_w0_0), .A2(DFT_clamp) );
wire pre_mbist_Wa_w0_1;
NV_BLKBOX_SRC0_X testInst_mbist_Wa_w0_1 (.Y(pre_mbist_Wa_w0_1));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Wa_w0_1 (.Z(mbist_Wa_w0[1]), .A1(pre_mbist_Wa_w0_1), .A2(DFT_clamp) );
wire pre_mbist_Wa_w0_2;
NV_BLKBOX_SRC0_X testInst_mbist_Wa_w0_2 (.Y(pre_mbist_Wa_w0_2));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Wa_w0_2 (.Z(mbist_Wa_w0[2]), .A1(pre_mbist_Wa_w0_2), .A2(DFT_clamp) );
wire pre_mbist_Wa_w0_3;
NV_BLKBOX_SRC0_X testInst_mbist_Wa_w0_3 (.Y(pre_mbist_Wa_w0_3));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Wa_w0_3 (.Z(mbist_Wa_w0[3]), .A1(pre_mbist_Wa_w0_3), .A2(DFT_clamp) );
wire pre_mbist_Wa_w0_4;
NV_BLKBOX_SRC0_X testInst_mbist_Wa_w0_4 (.Y(pre_mbist_Wa_w0_4));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Wa_w0_4 (.Z(mbist_Wa_w0[4]), .A1(pre_mbist_Wa_w0_4), .A2(DFT_clamp) );
wire pre_mbist_Wa_w0_5;
NV_BLKBOX_SRC0_X testInst_mbist_Wa_w0_5 (.Y(pre_mbist_Wa_w0_5));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Wa_w0_5 (.Z(mbist_Wa_w0[5]), .A1(pre_mbist_Wa_w0_5), .A2(DFT_clamp) );
wire pre_mbist_Wa_w0_6;
NV_BLKBOX_SRC0_X testInst_mbist_Wa_w0_6 (.Y(pre_mbist_Wa_w0_6));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Wa_w0_6 (.Z(mbist_Wa_w0[6]), .A1(pre_mbist_Wa_w0_6), .A2(DFT_clamp) );
wire pre_mbist_Di_w0_0;
NV_BLKBOX_SRC0_X testInst_mbist_Di_w0_0 (.Y(pre_mbist_Di_w0_0));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Di_w0_0 (.Z(mbist_Di_w0[0]), .A1(pre_mbist_Di_w0_0), .A2(DFT_clamp) );
wire pre_mbist_Di_w0_1;
NV_BLKBOX_SRC0_X testInst_mbist_Di_w0_1 (.Y(pre_mbist_Di_w0_1));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Di_w0_1 (.Z(mbist_Di_w0[1]), .A1(pre_mbist_Di_w0_1), .A2(DFT_clamp) );
wire pre_mbist_we_w0_0_0;
NV_BLKBOX_SRC0_X testInst_mbist_we_w0_0_0 (.Y(pre_mbist_we_w0_0_0));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_we_w0_0_0 (.Z(mbist_we_w0_0_0), .A1(pre_mbist_we_w0_0_0), .A2(DFT_clamp) );
wire pre_mbist_we_w0_0_288;
NV_BLKBOX_SRC0_X testInst_mbist_we_w0_0_288 (.Y(pre_mbist_we_w0_0_288));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_we_w0_0_288 (.Z(mbist_we_w0_0_288), .A1(pre_mbist_we_w0_0_288), .A2(DFT_clamp) );
wire pre_mbist_Ra_r0_0;
NV_BLKBOX_SRC0_X testInst_mbist_Ra_r0_0 (.Y(pre_mbist_Ra_r0_0));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Ra_r0_0 (.Z(mbist_Ra_r0[0]), .A1(pre_mbist_Ra_r0_0), .A2(DFT_clamp) );
wire pre_mbist_Ra_r0_1;
NV_BLKBOX_SRC0_X testInst_mbist_Ra_r0_1 (.Y(pre_mbist_Ra_r0_1));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Ra_r0_1 (.Z(mbist_Ra_r0[1]), .A1(pre_mbist_Ra_r0_1), .A2(DFT_clamp) );
wire pre_mbist_Ra_r0_2;
NV_BLKBOX_SRC0_X testInst_mbist_Ra_r0_2 (.Y(pre_mbist_Ra_r0_2));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Ra_r0_2 (.Z(mbist_Ra_r0[2]), .A1(pre_mbist_Ra_r0_2), .A2(DFT_clamp) );
wire pre_mbist_Ra_r0_3;
NV_BLKBOX_SRC0_X testInst_mbist_Ra_r0_3 (.Y(pre_mbist_Ra_r0_3));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Ra_r0_3 (.Z(mbist_Ra_r0[3]), .A1(pre_mbist_Ra_r0_3), .A2(DFT_clamp) );
wire pre_mbist_Ra_r0_4;
NV_BLKBOX_SRC0_X testInst_mbist_Ra_r0_4 (.Y(pre_mbist_Ra_r0_4));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Ra_r0_4 (.Z(mbist_Ra_r0[4]), .A1(pre_mbist_Ra_r0_4), .A2(DFT_clamp) );
wire pre_mbist_Ra_r0_5;
NV_BLKBOX_SRC0_X testInst_mbist_Ra_r0_5 (.Y(pre_mbist_Ra_r0_5));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Ra_r0_5 (.Z(mbist_Ra_r0[5]), .A1(pre_mbist_Ra_r0_5), .A2(DFT_clamp) );
wire pre_mbist_Ra_r0_6;
NV_BLKBOX_SRC0_X testInst_mbist_Ra_r0_6 (.Y(pre_mbist_Ra_r0_6));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Ra_r0_6 (.Z(mbist_Ra_r0[6]), .A1(pre_mbist_Ra_r0_6), .A2(DFT_clamp) );
NV_BLKBOX_SINK testInst_mbist_Do_r0_0 (.A(mbist_Do_r0_int_net[0]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_1 (.A(mbist_Do_r0_int_net[1]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_2 (.A(mbist_Do_r0_int_net[2]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_3 (.A(mbist_Do_r0_int_net[3]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_4 (.A(mbist_Do_r0_int_net[4]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_5 (.A(mbist_Do_r0_int_net[5]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_6 (.A(mbist_Do_r0_int_net[6]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_7 (.A(mbist_Do_r0_int_net[7]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_8 (.A(mbist_Do_r0_int_net[8]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_9 (.A(mbist_Do_r0_int_net[9]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_10 (.A(mbist_Do_r0_int_net[10]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_11 (.A(mbist_Do_r0_int_net[11]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_12 (.A(mbist_Do_r0_int_net[12]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_13 (.A(mbist_Do_r0_int_net[13]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_14 (.A(mbist_Do_r0_int_net[14]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_15 (.A(mbist_Do_r0_int_net[15]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_16 (.A(mbist_Do_r0_int_net[16]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_17 (.A(mbist_Do_r0_int_net[17]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_18 (.A(mbist_Do_r0_int_net[18]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_19 (.A(mbist_Do_r0_int_net[19]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_20 (.A(mbist_Do_r0_int_net[20]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_21 (.A(mbist_Do_r0_int_net[21]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_22 (.A(mbist_Do_r0_int_net[22]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_23 (.A(mbist_Do_r0_int_net[23]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_24 (.A(mbist_Do_r0_int_net[24]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_25 (.A(mbist_Do_r0_int_net[25]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_26 (.A(mbist_Do_r0_int_net[26]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_27 (.A(mbist_Do_r0_int_net[27]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_28 (.A(mbist_Do_r0_int_net[28]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_29 (.A(mbist_Do_r0_int_net[29]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_30 (.A(mbist_Do_r0_int_net[30]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_31 (.A(mbist_Do_r0_int_net[31]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_32 (.A(mbist_Do_r0_int_net[32]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_33 (.A(mbist_Do_r0_int_net[33]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_34 (.A(mbist_Do_r0_int_net[34]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_35 (.A(mbist_Do_r0_int_net[35]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_36 (.A(mbist_Do_r0_int_net[36]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_37 (.A(mbist_Do_r0_int_net[37]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_38 (.A(mbist_Do_r0_int_net[38]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_39 (.A(mbist_Do_r0_int_net[39]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_40 (.A(mbist_Do_r0_int_net[40]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_41 (.A(mbist_Do_r0_int_net[41]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_42 (.A(mbist_Do_r0_int_net[42]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_43 (.A(mbist_Do_r0_int_net[43]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_44 (.A(mbist_Do_r0_int_net[44]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_45 (.A(mbist_Do_r0_int_net[45]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_46 (.A(mbist_Do_r0_int_net[46]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_47 (.A(mbist_Do_r0_int_net[47]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_48 (.A(mbist_Do_r0_int_net[48]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_49 (.A(mbist_Do_r0_int_net[49]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_50 (.A(mbist_Do_r0_int_net[50]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_51 (.A(mbist_Do_r0_int_net[51]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_52 (.A(mbist_Do_r0_int_net[52]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_53 (.A(mbist_Do_r0_int_net[53]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_54 (.A(mbist_Do_r0_int_net[54]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_55 (.A(mbist_Do_r0_int_net[55]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_56 (.A(mbist_Do_r0_int_net[56]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_57 (.A(mbist_Do_r0_int_net[57]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_58 (.A(mbist_Do_r0_int_net[58]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_59 (.A(mbist_Do_r0_int_net[59]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_60 (.A(mbist_Do_r0_int_net[60]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_61 (.A(mbist_Do_r0_int_net[61]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_62 (.A(mbist_Do_r0_int_net[62]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_63 (.A(mbist_Do_r0_int_net[63]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_64 (.A(mbist_Do_r0_int_net[64]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_65 (.A(mbist_Do_r0_int_net[65]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_66 (.A(mbist_Do_r0_int_net[66]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_67 (.A(mbist_Do_r0_int_net[67]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_68 (.A(mbist_Do_r0_int_net[68]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_69 (.A(mbist_Do_r0_int_net[69]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_70 (.A(mbist_Do_r0_int_net[70]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_71 (.A(mbist_Do_r0_int_net[71]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_72 (.A(mbist_Do_r0_int_net[72]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_73 (.A(mbist_Do_r0_int_net[73]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_74 (.A(mbist_Do_r0_int_net[74]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_75 (.A(mbist_Do_r0_int_net[75]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_76 (.A(mbist_Do_r0_int_net[76]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_77 (.A(mbist_Do_r0_int_net[77]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_78 (.A(mbist_Do_r0_int_net[78]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_79 (.A(mbist_Do_r0_int_net[79]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_80 (.A(mbist_Do_r0_int_net[80]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_81 (.A(mbist_Do_r0_int_net[81]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_82 (.A(mbist_Do_r0_int_net[82]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_83 (.A(mbist_Do_r0_int_net[83]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_84 (.A(mbist_Do_r0_int_net[84]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_85 (.A(mbist_Do_r0_int_net[85]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_86 (.A(mbist_Do_r0_int_net[86]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_87 (.A(mbist_Do_r0_int_net[87]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_88 (.A(mbist_Do_r0_int_net[88]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_89 (.A(mbist_Do_r0_int_net[89]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_90 (.A(mbist_Do_r0_int_net[90]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_91 (.A(mbist_Do_r0_int_net[91]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_92 (.A(mbist_Do_r0_int_net[92]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_93 (.A(mbist_Do_r0_int_net[93]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_94 (.A(mbist_Do_r0_int_net[94]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_95 (.A(mbist_Do_r0_int_net[95]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_96 (.A(mbist_Do_r0_int_net[96]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_97 (.A(mbist_Do_r0_int_net[97]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_98 (.A(mbist_Do_r0_int_net[98]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_99 (.A(mbist_Do_r0_int_net[99]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_100 (.A(mbist_Do_r0_int_net[100]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_101 (.A(mbist_Do_r0_int_net[101]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_102 (.A(mbist_Do_r0_int_net[102]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_103 (.A(mbist_Do_r0_int_net[103]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_104 (.A(mbist_Do_r0_int_net[104]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_105 (.A(mbist_Do_r0_int_net[105]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_106 (.A(mbist_Do_r0_int_net[106]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_107 (.A(mbist_Do_r0_int_net[107]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_108 (.A(mbist_Do_r0_int_net[108]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_109 (.A(mbist_Do_r0_int_net[109]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_110 (.A(mbist_Do_r0_int_net[110]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_111 (.A(mbist_Do_r0_int_net[111]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_112 (.A(mbist_Do_r0_int_net[112]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_113 (.A(mbist_Do_r0_int_net[113]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_114 (.A(mbist_Do_r0_int_net[114]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_115 (.A(mbist_Do_r0_int_net[115]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_116 (.A(mbist_Do_r0_int_net[116]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_117 (.A(mbist_Do_r0_int_net[117]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_118 (.A(mbist_Do_r0_int_net[118]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_119 (.A(mbist_Do_r0_int_net[119]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_120 (.A(mbist_Do_r0_int_net[120]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_121 (.A(mbist_Do_r0_int_net[121]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_122 (.A(mbist_Do_r0_int_net[122]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_123 (.A(mbist_Do_r0_int_net[123]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_124 (.A(mbist_Do_r0_int_net[124]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_125 (.A(mbist_Do_r0_int_net[125]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_126 (.A(mbist_Do_r0_int_net[126]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_127 (.A(mbist_Do_r0_int_net[127]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_128 (.A(mbist_Do_r0_int_net[128]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_129 (.A(mbist_Do_r0_int_net[129]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_130 (.A(mbist_Do_r0_int_net[130]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_131 (.A(mbist_Do_r0_int_net[131]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_132 (.A(mbist_Do_r0_int_net[132]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_133 (.A(mbist_Do_r0_int_net[133]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_134 (.A(mbist_Do_r0_int_net[134]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_135 (.A(mbist_Do_r0_int_net[135]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_136 (.A(mbist_Do_r0_int_net[136]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_137 (.A(mbist_Do_r0_int_net[137]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_138 (.A(mbist_Do_r0_int_net[138]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_139 (.A(mbist_Do_r0_int_net[139]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_140 (.A(mbist_Do_r0_int_net[140]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_141 (.A(mbist_Do_r0_int_net[141]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_142 (.A(mbist_Do_r0_int_net[142]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_143 (.A(mbist_Do_r0_int_net[143]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_144 (.A(mbist_Do_r0_int_net[144]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_145 (.A(mbist_Do_r0_int_net[145]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_146 (.A(mbist_Do_r0_int_net[146]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_147 (.A(mbist_Do_r0_int_net[147]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_148 (.A(mbist_Do_r0_int_net[148]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_149 (.A(mbist_Do_r0_int_net[149]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_150 (.A(mbist_Do_r0_int_net[150]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_151 (.A(mbist_Do_r0_int_net[151]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_152 (.A(mbist_Do_r0_int_net[152]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_153 (.A(mbist_Do_r0_int_net[153]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_154 (.A(mbist_Do_r0_int_net[154]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_155 (.A(mbist_Do_r0_int_net[155]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_156 (.A(mbist_Do_r0_int_net[156]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_157 (.A(mbist_Do_r0_int_net[157]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_158 (.A(mbist_Do_r0_int_net[158]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_159 (.A(mbist_Do_r0_int_net[159]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_160 (.A(mbist_Do_r0_int_net[160]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_161 (.A(mbist_Do_r0_int_net[161]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_162 (.A(mbist_Do_r0_int_net[162]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_163 (.A(mbist_Do_r0_int_net[163]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_164 (.A(mbist_Do_r0_int_net[164]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_165 (.A(mbist_Do_r0_int_net[165]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_166 (.A(mbist_Do_r0_int_net[166]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_167 (.A(mbist_Do_r0_int_net[167]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_168 (.A(mbist_Do_r0_int_net[168]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_169 (.A(mbist_Do_r0_int_net[169]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_170 (.A(mbist_Do_r0_int_net[170]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_171 (.A(mbist_Do_r0_int_net[171]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_172 (.A(mbist_Do_r0_int_net[172]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_173 (.A(mbist_Do_r0_int_net[173]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_174 (.A(mbist_Do_r0_int_net[174]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_175 (.A(mbist_Do_r0_int_net[175]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_176 (.A(mbist_Do_r0_int_net[176]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_177 (.A(mbist_Do_r0_int_net[177]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_178 (.A(mbist_Do_r0_int_net[178]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_179 (.A(mbist_Do_r0_int_net[179]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_180 (.A(mbist_Do_r0_int_net[180]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_181 (.A(mbist_Do_r0_int_net[181]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_182 (.A(mbist_Do_r0_int_net[182]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_183 (.A(mbist_Do_r0_int_net[183]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_184 (.A(mbist_Do_r0_int_net[184]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_185 (.A(mbist_Do_r0_int_net[185]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_186 (.A(mbist_Do_r0_int_net[186]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_187 (.A(mbist_Do_r0_int_net[187]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_188 (.A(mbist_Do_r0_int_net[188]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_189 (.A(mbist_Do_r0_int_net[189]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_190 (.A(mbist_Do_r0_int_net[190]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_191 (.A(mbist_Do_r0_int_net[191]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_192 (.A(mbist_Do_r0_int_net[192]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_193 (.A(mbist_Do_r0_int_net[193]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_194 (.A(mbist_Do_r0_int_net[194]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_195 (.A(mbist_Do_r0_int_net[195]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_196 (.A(mbist_Do_r0_int_net[196]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_197 (.A(mbist_Do_r0_int_net[197]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_198 (.A(mbist_Do_r0_int_net[198]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_199 (.A(mbist_Do_r0_int_net[199]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_200 (.A(mbist_Do_r0_int_net[200]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_201 (.A(mbist_Do_r0_int_net[201]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_202 (.A(mbist_Do_r0_int_net[202]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_203 (.A(mbist_Do_r0_int_net[203]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_204 (.A(mbist_Do_r0_int_net[204]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_205 (.A(mbist_Do_r0_int_net[205]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_206 (.A(mbist_Do_r0_int_net[206]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_207 (.A(mbist_Do_r0_int_net[207]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_208 (.A(mbist_Do_r0_int_net[208]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_209 (.A(mbist_Do_r0_int_net[209]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_210 (.A(mbist_Do_r0_int_net[210]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_211 (.A(mbist_Do_r0_int_net[211]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_212 (.A(mbist_Do_r0_int_net[212]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_213 (.A(mbist_Do_r0_int_net[213]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_214 (.A(mbist_Do_r0_int_net[214]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_215 (.A(mbist_Do_r0_int_net[215]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_216 (.A(mbist_Do_r0_int_net[216]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_217 (.A(mbist_Do_r0_int_net[217]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_218 (.A(mbist_Do_r0_int_net[218]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_219 (.A(mbist_Do_r0_int_net[219]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_220 (.A(mbist_Do_r0_int_net[220]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_221 (.A(mbist_Do_r0_int_net[221]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_222 (.A(mbist_Do_r0_int_net[222]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_223 (.A(mbist_Do_r0_int_net[223]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_224 (.A(mbist_Do_r0_int_net[224]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_225 (.A(mbist_Do_r0_int_net[225]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_226 (.A(mbist_Do_r0_int_net[226]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_227 (.A(mbist_Do_r0_int_net[227]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_228 (.A(mbist_Do_r0_int_net[228]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_229 (.A(mbist_Do_r0_int_net[229]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_230 (.A(mbist_Do_r0_int_net[230]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_231 (.A(mbist_Do_r0_int_net[231]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_232 (.A(mbist_Do_r0_int_net[232]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_233 (.A(mbist_Do_r0_int_net[233]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_234 (.A(mbist_Do_r0_int_net[234]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_235 (.A(mbist_Do_r0_int_net[235]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_236 (.A(mbist_Do_r0_int_net[236]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_237 (.A(mbist_Do_r0_int_net[237]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_238 (.A(mbist_Do_r0_int_net[238]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_239 (.A(mbist_Do_r0_int_net[239]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_240 (.A(mbist_Do_r0_int_net[240]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_241 (.A(mbist_Do_r0_int_net[241]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_242 (.A(mbist_Do_r0_int_net[242]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_243 (.A(mbist_Do_r0_int_net[243]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_244 (.A(mbist_Do_r0_int_net[244]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_245 (.A(mbist_Do_r0_int_net[245]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_246 (.A(mbist_Do_r0_int_net[246]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_247 (.A(mbist_Do_r0_int_net[247]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_248 (.A(mbist_Do_r0_int_net[248]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_249 (.A(mbist_Do_r0_int_net[249]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_250 (.A(mbist_Do_r0_int_net[250]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_251 (.A(mbist_Do_r0_int_net[251]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_252 (.A(mbist_Do_r0_int_net[252]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_253 (.A(mbist_Do_r0_int_net[253]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_254 (.A(mbist_Do_r0_int_net[254]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_255 (.A(mbist_Do_r0_int_net[255]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_256 (.A(mbist_Do_r0_int_net[256]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_257 (.A(mbist_Do_r0_int_net[257]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_258 (.A(mbist_Do_r0_int_net[258]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_259 (.A(mbist_Do_r0_int_net[259]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_260 (.A(mbist_Do_r0_int_net[260]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_261 (.A(mbist_Do_r0_int_net[261]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_262 (.A(mbist_Do_r0_int_net[262]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_263 (.A(mbist_Do_r0_int_net[263]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_264 (.A(mbist_Do_r0_int_net[264]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_265 (.A(mbist_Do_r0_int_net[265]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_266 (.A(mbist_Do_r0_int_net[266]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_267 (.A(mbist_Do_r0_int_net[267]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_268 (.A(mbist_Do_r0_int_net[268]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_269 (.A(mbist_Do_r0_int_net[269]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_270 (.A(mbist_Do_r0_int_net[270]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_271 (.A(mbist_Do_r0_int_net[271]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_272 (.A(mbist_Do_r0_int_net[272]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_273 (.A(mbist_Do_r0_int_net[273]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_274 (.A(mbist_Do_r0_int_net[274]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_275 (.A(mbist_Do_r0_int_net[275]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_276 (.A(mbist_Do_r0_int_net[276]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_277 (.A(mbist_Do_r0_int_net[277]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_278 (.A(mbist_Do_r0_int_net[278]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_279 (.A(mbist_Do_r0_int_net[279]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_280 (.A(mbist_Do_r0_int_net[280]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_281 (.A(mbist_Do_r0_int_net[281]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_282 (.A(mbist_Do_r0_int_net[282]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_283 (.A(mbist_Do_r0_int_net[283]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_284 (.A(mbist_Do_r0_int_net[284]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_285 (.A(mbist_Do_r0_int_net[285]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_286 (.A(mbist_Do_r0_int_net[286]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_287 (.A(mbist_Do_r0_int_net[287]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_288 (.A(mbist_Do_r0_int_net[288]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_289 (.A(mbist_Do_r0_int_net[289]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_290 (.A(mbist_Do_r0_int_net[290]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_291 (.A(mbist_Do_r0_int_net[291]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_292 (.A(mbist_Do_r0_int_net[292]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_293 (.A(mbist_Do_r0_int_net[293]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_294 (.A(mbist_Do_r0_int_net[294]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_295 (.A(mbist_Do_r0_int_net[295]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_296 (.A(mbist_Do_r0_int_net[296]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_297 (.A(mbist_Do_r0_int_net[297]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_298 (.A(mbist_Do_r0_int_net[298]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_299 (.A(mbist_Do_r0_int_net[299]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_300 (.A(mbist_Do_r0_int_net[300]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_301 (.A(mbist_Do_r0_int_net[301]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_302 (.A(mbist_Do_r0_int_net[302]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_303 (.A(mbist_Do_r0_int_net[303]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_304 (.A(mbist_Do_r0_int_net[304]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_305 (.A(mbist_Do_r0_int_net[305]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_306 (.A(mbist_Do_r0_int_net[306]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_307 (.A(mbist_Do_r0_int_net[307]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_308 (.A(mbist_Do_r0_int_net[308]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_309 (.A(mbist_Do_r0_int_net[309]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_310 (.A(mbist_Do_r0_int_net[310]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_311 (.A(mbist_Do_r0_int_net[311]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_312 (.A(mbist_Do_r0_int_net[312]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_313 (.A(mbist_Do_r0_int_net[313]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_314 (.A(mbist_Do_r0_int_net[314]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_315 (.A(mbist_Do_r0_int_net[315]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_316 (.A(mbist_Do_r0_int_net[316]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_317 (.A(mbist_Do_r0_int_net[317]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_318 (.A(mbist_Do_r0_int_net[318]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_319 (.A(mbist_Do_r0_int_net[319]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_320 (.A(mbist_Do_r0_int_net[320]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_321 (.A(mbist_Do_r0_int_net[321]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_322 (.A(mbist_Do_r0_int_net[322]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_323 (.A(mbist_Do_r0_int_net[323]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_324 (.A(mbist_Do_r0_int_net[324]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_325 (.A(mbist_Do_r0_int_net[325]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_326 (.A(mbist_Do_r0_int_net[326]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_327 (.A(mbist_Do_r0_int_net[327]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_328 (.A(mbist_Do_r0_int_net[328]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_329 (.A(mbist_Do_r0_int_net[329]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_330 (.A(mbist_Do_r0_int_net[330]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_331 (.A(mbist_Do_r0_int_net[331]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_332 (.A(mbist_Do_r0_int_net[332]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_333 (.A(mbist_Do_r0_int_net[333]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_334 (.A(mbist_Do_r0_int_net[334]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_335 (.A(mbist_Do_r0_int_net[335]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_336 (.A(mbist_Do_r0_int_net[336]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_337 (.A(mbist_Do_r0_int_net[337]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_338 (.A(mbist_Do_r0_int_net[338]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_339 (.A(mbist_Do_r0_int_net[339]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_340 (.A(mbist_Do_r0_int_net[340]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_341 (.A(mbist_Do_r0_int_net[341]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_342 (.A(mbist_Do_r0_int_net[342]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_343 (.A(mbist_Do_r0_int_net[343]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_344 (.A(mbist_Do_r0_int_net[344]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_345 (.A(mbist_Do_r0_int_net[345]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_346 (.A(mbist_Do_r0_int_net[346]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_347 (.A(mbist_Do_r0_int_net[347]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_348 (.A(mbist_Do_r0_int_net[348]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_349 (.A(mbist_Do_r0_int_net[349]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_350 (.A(mbist_Do_r0_int_net[350]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_351 (.A(mbist_Do_r0_int_net[351]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_352 (.A(mbist_Do_r0_int_net[352]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_353 (.A(mbist_Do_r0_int_net[353]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_354 (.A(mbist_Do_r0_int_net[354]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_355 (.A(mbist_Do_r0_int_net[355]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_356 (.A(mbist_Do_r0_int_net[356]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_357 (.A(mbist_Do_r0_int_net[357]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_358 (.A(mbist_Do_r0_int_net[358]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_359 (.A(mbist_Do_r0_int_net[359]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_360 (.A(mbist_Do_r0_int_net[360]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_361 (.A(mbist_Do_r0_int_net[361]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_362 (.A(mbist_Do_r0_int_net[362]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_363 (.A(mbist_Do_r0_int_net[363]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_364 (.A(mbist_Do_r0_int_net[364]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_365 (.A(mbist_Do_r0_int_net[365]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_366 (.A(mbist_Do_r0_int_net[366]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_367 (.A(mbist_Do_r0_int_net[367]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_368 (.A(mbist_Do_r0_int_net[368]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_369 (.A(mbist_Do_r0_int_net[369]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_370 (.A(mbist_Do_r0_int_net[370]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_371 (.A(mbist_Do_r0_int_net[371]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_372 (.A(mbist_Do_r0_int_net[372]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_373 (.A(mbist_Do_r0_int_net[373]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_374 (.A(mbist_Do_r0_int_net[374]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_375 (.A(mbist_Do_r0_int_net[375]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_376 (.A(mbist_Do_r0_int_net[376]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_377 (.A(mbist_Do_r0_int_net[377]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_378 (.A(mbist_Do_r0_int_net[378]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_379 (.A(mbist_Do_r0_int_net[379]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_380 (.A(mbist_Do_r0_int_net[380]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_381 (.A(mbist_Do_r0_int_net[381]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_382 (.A(mbist_Do_r0_int_net[382]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_383 (.A(mbist_Do_r0_int_net[383]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_384 (.A(mbist_Do_r0_int_net[384]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_385 (.A(mbist_Do_r0_int_net[385]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_386 (.A(mbist_Do_r0_int_net[386]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_387 (.A(mbist_Do_r0_int_net[387]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_388 (.A(mbist_Do_r0_int_net[388]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_389 (.A(mbist_Do_r0_int_net[389]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_390 (.A(mbist_Do_r0_int_net[390]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_391 (.A(mbist_Do_r0_int_net[391]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_392 (.A(mbist_Do_r0_int_net[392]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_393 (.A(mbist_Do_r0_int_net[393]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_394 (.A(mbist_Do_r0_int_net[394]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_395 (.A(mbist_Do_r0_int_net[395]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_396 (.A(mbist_Do_r0_int_net[396]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_397 (.A(mbist_Do_r0_int_net[397]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_398 (.A(mbist_Do_r0_int_net[398]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_399 (.A(mbist_Do_r0_int_net[399]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_400 (.A(mbist_Do_r0_int_net[400]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_401 (.A(mbist_Do_r0_int_net[401]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_402 (.A(mbist_Do_r0_int_net[402]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_403 (.A(mbist_Do_r0_int_net[403]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_404 (.A(mbist_Do_r0_int_net[404]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_405 (.A(mbist_Do_r0_int_net[405]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_406 (.A(mbist_Do_r0_int_net[406]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_407 (.A(mbist_Do_r0_int_net[407]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_408 (.A(mbist_Do_r0_int_net[408]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_409 (.A(mbist_Do_r0_int_net[409]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_410 (.A(mbist_Do_r0_int_net[410]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_411 (.A(mbist_Do_r0_int_net[411]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_412 (.A(mbist_Do_r0_int_net[412]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_413 (.A(mbist_Do_r0_int_net[413]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_414 (.A(mbist_Do_r0_int_net[414]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_415 (.A(mbist_Do_r0_int_net[415]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_416 (.A(mbist_Do_r0_int_net[416]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_417 (.A(mbist_Do_r0_int_net[417]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_418 (.A(mbist_Do_r0_int_net[418]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_419 (.A(mbist_Do_r0_int_net[419]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_420 (.A(mbist_Do_r0_int_net[420]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_421 (.A(mbist_Do_r0_int_net[421]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_422 (.A(mbist_Do_r0_int_net[422]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_423 (.A(mbist_Do_r0_int_net[423]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_424 (.A(mbist_Do_r0_int_net[424]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_425 (.A(mbist_Do_r0_int_net[425]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_426 (.A(mbist_Do_r0_int_net[426]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_427 (.A(mbist_Do_r0_int_net[427]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_428 (.A(mbist_Do_r0_int_net[428]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_429 (.A(mbist_Do_r0_int_net[429]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_430 (.A(mbist_Do_r0_int_net[430]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_431 (.A(mbist_Do_r0_int_net[431]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_432 (.A(mbist_Do_r0_int_net[432]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_433 (.A(mbist_Do_r0_int_net[433]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_434 (.A(mbist_Do_r0_int_net[434]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_435 (.A(mbist_Do_r0_int_net[435]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_436 (.A(mbist_Do_r0_int_net[436]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_437 (.A(mbist_Do_r0_int_net[437]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_438 (.A(mbist_Do_r0_int_net[438]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_439 (.A(mbist_Do_r0_int_net[439]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_440 (.A(mbist_Do_r0_int_net[440]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_441 (.A(mbist_Do_r0_int_net[441]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_442 (.A(mbist_Do_r0_int_net[442]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_443 (.A(mbist_Do_r0_int_net[443]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_444 (.A(mbist_Do_r0_int_net[444]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_445 (.A(mbist_Do_r0_int_net[445]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_446 (.A(mbist_Do_r0_int_net[446]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_447 (.A(mbist_Do_r0_int_net[447]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_448 (.A(mbist_Do_r0_int_net[448]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_449 (.A(mbist_Do_r0_int_net[449]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_450 (.A(mbist_Do_r0_int_net[450]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_451 (.A(mbist_Do_r0_int_net[451]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_452 (.A(mbist_Do_r0_int_net[452]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_453 (.A(mbist_Do_r0_int_net[453]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_454 (.A(mbist_Do_r0_int_net[454]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_455 (.A(mbist_Do_r0_int_net[455]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_456 (.A(mbist_Do_r0_int_net[456]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_457 (.A(mbist_Do_r0_int_net[457]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_458 (.A(mbist_Do_r0_int_net[458]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_459 (.A(mbist_Do_r0_int_net[459]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_460 (.A(mbist_Do_r0_int_net[460]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_461 (.A(mbist_Do_r0_int_net[461]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_462 (.A(mbist_Do_r0_int_net[462]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_463 (.A(mbist_Do_r0_int_net[463]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_464 (.A(mbist_Do_r0_int_net[464]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_465 (.A(mbist_Do_r0_int_net[465]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_466 (.A(mbist_Do_r0_int_net[466]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_467 (.A(mbist_Do_r0_int_net[467]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_468 (.A(mbist_Do_r0_int_net[468]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_469 (.A(mbist_Do_r0_int_net[469]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_470 (.A(mbist_Do_r0_int_net[470]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_471 (.A(mbist_Do_r0_int_net[471]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_472 (.A(mbist_Do_r0_int_net[472]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_473 (.A(mbist_Do_r0_int_net[473]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_474 (.A(mbist_Do_r0_int_net[474]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_475 (.A(mbist_Do_r0_int_net[475]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_476 (.A(mbist_Do_r0_int_net[476]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_477 (.A(mbist_Do_r0_int_net[477]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_478 (.A(mbist_Do_r0_int_net[478]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_479 (.A(mbist_Do_r0_int_net[479]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_480 (.A(mbist_Do_r0_int_net[480]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_481 (.A(mbist_Do_r0_int_net[481]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_482 (.A(mbist_Do_r0_int_net[482]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_483 (.A(mbist_Do_r0_int_net[483]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_484 (.A(mbist_Do_r0_int_net[484]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_485 (.A(mbist_Do_r0_int_net[485]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_486 (.A(mbist_Do_r0_int_net[486]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_487 (.A(mbist_Do_r0_int_net[487]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_488 (.A(mbist_Do_r0_int_net[488]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_489 (.A(mbist_Do_r0_int_net[489]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_490 (.A(mbist_Do_r0_int_net[490]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_491 (.A(mbist_Do_r0_int_net[491]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_492 (.A(mbist_Do_r0_int_net[492]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_493 (.A(mbist_Do_r0_int_net[493]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_494 (.A(mbist_Do_r0_int_net[494]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_495 (.A(mbist_Do_r0_int_net[495]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_496 (.A(mbist_Do_r0_int_net[496]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_497 (.A(mbist_Do_r0_int_net[497]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_498 (.A(mbist_Do_r0_int_net[498]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_499 (.A(mbist_Do_r0_int_net[499]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_500 (.A(mbist_Do_r0_int_net[500]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_501 (.A(mbist_Do_r0_int_net[501]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_502 (.A(mbist_Do_r0_int_net[502]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_503 (.A(mbist_Do_r0_int_net[503]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_504 (.A(mbist_Do_r0_int_net[504]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_505 (.A(mbist_Do_r0_int_net[505]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_506 (.A(mbist_Do_r0_int_net[506]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_507 (.A(mbist_Do_r0_int_net[507]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_508 (.A(mbist_Do_r0_int_net[508]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_509 (.A(mbist_Do_r0_int_net[509]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_510 (.A(mbist_Do_r0_int_net[510]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_511 (.A(mbist_Do_r0_int_net[511]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_512 (.A(mbist_Do_r0_int_net[512]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_513 (.A(mbist_Do_r0_int_net[513]));
wire pre_mbist_ce_r0_0_0;
NV_BLKBOX_SRC0_X testInst_mbist_ce_r0_0_0 (.Y(pre_mbist_ce_r0_0_0));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_ce_r0_0_0 (.Z(mbist_ce_r0_0_0), .A1(pre_mbist_ce_r0_0_0), .A2(DFT_clamp) );
wire pre_mbist_ce_r0_0_288;
NV_BLKBOX_SRC0_X testInst_mbist_ce_r0_0_288 (.Y(pre_mbist_ce_r0_0_288));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_ce_r0_0_288 (.Z(mbist_ce_r0_0_288), .A1(pre_mbist_ce_r0_0_288), .A2(DFT_clamp) );
wire pre_mbist_en_sync;
NV_BLKBOX_SRC0_X testInst_mbist_en_sync (.Y(pre_mbist_en_sync));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_en_sync (.Z(mbist_en_sync), .A1(pre_mbist_en_sync), .A2(DFT_clamp) );
wire pre_SI;
NV_BLKBOX_SRC0_X testInst_SI (.Y(pre_SI));
AN2D4PO4 UJ_DFTQUALIFIER_SI (.Z(SI), .A1(pre_SI), .A2(DFT_clamp) );
NV_BLKBOX_SINK testInst_SO (.A(SO_int_net));
wire pre_shiftDR;
NV_BLKBOX_SRC0_X testInst_shiftDR (.Y(pre_shiftDR));
AN2D4PO4 UJ_DFTQUALIFIER_shiftDR (.Z(shiftDR), .A1(pre_shiftDR), .A2(DFT_clamp) );
wire pre_updateDR;
NV_BLKBOX_SRC0_X testInst_updateDR (.Y(pre_updateDR));
AN2D4PO4 UJ_DFTQUALIFIER_updateDR (.Z(updateDR), .A1(pre_updateDR), .A2(DFT_clamp) );
wire pre_debug_mode;
NV_BLKBOX_SRC0_X testInst_debug_mode (.Y(pre_debug_mode));
AN2D4PO4 UJ_DFTQUALIFIER_debug_mode (.Z(debug_mode), .A1(pre_debug_mode), .A2(DFT_clamp) );
wire pre_mbist_ramaccess_rst_;
NV_BLKBOX_SRC0_X testInst_mbist_ramaccess_rst_ (.Y(pre_mbist_ramaccess_rst_));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_ramaccess_rst_ (.Z(mbist_ramaccess_rst_), .A1(pre_mbist_ramaccess_rst_), .A2(DFT_clamp) );
wire pre_ary_atpg_ctl;
NV_BLKBOX_SRC0_X testInst_ary_atpg_ctl (.Y(pre_ary_atpg_ctl));
AN2D4PO4 UJ_DFTQUALIFIER_ary_atpg_ctl (.Z(ary_atpg_ctl), .A1(pre_ary_atpg_ctl), .A2(DFT_clamp) );
wire pre_write_inh;
NV_BLKBOX_SRC0_X testInst_write_inh (.Y(pre_write_inh));
AN2D4PO4 UJ_DFTQUALIFIER_write_inh (.Z(write_inh), .A1(pre_write_inh), .A2(DFT_clamp) );
wire pre_scan_ramtms;
NV_BLKBOX_SRC0_X testInst_scan_ramtms (.Y(pre_scan_ramtms));
AN2D4PO4 UJ_DFTQUALIFIER_scan_ramtms (.Z(scan_ramtms), .A1(pre_scan_ramtms), .A2(DFT_clamp) );
wire pre_iddq_mode;
NV_BLKBOX_SRC0_X testInst_iddq_mode (.Y(pre_iddq_mode));
AN2D4PO4 UJ_DFTQUALIFIER_iddq_mode (.Z(iddq_mode), .A1(pre_iddq_mode), .A2(DFT_clamp) );
wire pre_jtag_readonly_mode;
NV_BLKBOX_SRC0_X testInst_jtag_readonly_mode (.Y(pre_jtag_readonly_mode));
AN2D4PO4 UJ_DFTQUALIFIER_jtag_readonly_mode (.Z(jtag_readonly_mode), .A1(pre_jtag_readonly_mode), .A2(DFT_clamp) );
wire pre_ary_read_inh;
NV_BLKBOX_SRC0_X testInst_ary_read_inh (.Y(pre_ary_read_inh));
AN2D4PO4 UJ_DFTQUALIFIER_ary_read_inh (.Z(ary_read_inh), .A1(pre_ary_read_inh), .A2(DFT_clamp) );
wire pre_test_mode;
NV_BLKBOX_SRC0_X testInst_test_mode (.Y(pre_test_mode));
AN2D4PO4 UJ_DFTQUALIFIER_test_mode (.Z(test_mode), .A1(pre_test_mode), .A2(DFT_clamp) );
wire pre_scan_en;
NV_BLKBOX_SRC0_X testInst_scan_en (.Y(pre_scan_en));
AN2D4PO4 UJ_DFTQUALIFIER_scan_en (.Z(scan_en), .A1(pre_scan_en), .A2(DFT_clamp) );
NV_BLKBOX_SRC0 testInst_svop_0 (.Y(svop[0]));
NV_BLKBOX_SRC0 testInst_svop_1 (.Y(svop[1]));
NV_BLKBOX_SRC0 testInst_svop_2 (.Y(svop[2]));
NV_BLKBOX_SRC0 testInst_svop_3 (.Y(svop[3]));
NV_BLKBOX_SRC0 testInst_svop_4 (.Y(svop[4]));
NV_BLKBOX_SRC0 testInst_svop_5 (.Y(svop[5]));
NV_BLKBOX_SRC0 testInst_svop_6 (.Y(svop[6]));
NV_BLKBOX_SRC0 testInst_svop_7 (.Y(svop[7]));

// Declare the wires for test signals

// Instantiating the internal logic module now
// verilint 402 off - inferred Reset must be a module port
nv_ram_rwsp_80x514_logic #(FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) r_nv_ram_rwsp_80x514 (
                           .SI(SI), .SO_int_net(SO_int_net), 
                           .ary_atpg_ctl(ary_atpg_ctl), 
                           .ary_read_inh(ary_read_inh), .clk(clk), 
                           .debug_mode(debug_mode), .di(di), .dout(dout), 
                           .iddq_mode(iddq_mode), 
                           .jtag_readonly_mode(jtag_readonly_mode), 
                           .mbist_Di_w0(mbist_Di_w0), 
                           .mbist_Do_r0_int_net(mbist_Do_r0_int_net), 
                           .mbist_Ra_r0(mbist_Ra_r0), .mbist_Wa_w0(mbist_Wa_w0), 
                           .mbist_ce_r0_0_0(mbist_ce_r0_0_0), 
                           .mbist_ce_r0_0_288(mbist_ce_r0_0_288), 
                           .mbist_en_sync(mbist_en_sync), 
                           .mbist_ramaccess_rst_(mbist_ramaccess_rst_), 
                           .mbist_we_w0_0_0(mbist_we_w0_0_0), 
                           .mbist_we_w0_0_288(mbist_we_w0_0_288), .ore(ore), 
                           .pwrbus_ram_pd(pwrbus_ram_pd), .ra(ra), .re(re), 
                           .scan_en(scan_en), .scan_ramtms(scan_ramtms), 
                           .shiftDR(shiftDR), .svop(svop), .test_mode(test_mode), 
                           .updateDR(updateDR), .wa(wa), .we(we), 
                           .write_inh(write_inh) );
// verilint 402 on - inferred Reset must be a module port


// synopsys dc_tcl_script_begin
// synopsys dc_tcl_script_end



// synopsys dc_tcl_script_begin
// synopsys dc_tcl_script_end


`ifndef SYNTHESIS
task arrangement (output integer arrangment_string[513:0]);
  begin
    arrangment_string[0] = 0  ;     
    arrangment_string[1] = 1  ;     
    arrangment_string[2] = 2  ;     
    arrangment_string[3] = 3  ;     
    arrangment_string[4] = 4  ;     
    arrangment_string[5] = 5  ;     
    arrangment_string[6] = 6  ;     
    arrangment_string[7] = 7  ;     
    arrangment_string[8] = 8  ;     
    arrangment_string[9] = 9  ;     
    arrangment_string[10] = 10  ;     
    arrangment_string[11] = 11  ;     
    arrangment_string[12] = 12  ;     
    arrangment_string[13] = 13  ;     
    arrangment_string[14] = 14  ;     
    arrangment_string[15] = 15  ;     
    arrangment_string[16] = 16  ;     
    arrangment_string[17] = 17  ;     
    arrangment_string[18] = 18  ;     
    arrangment_string[19] = 19  ;     
    arrangment_string[20] = 20  ;     
    arrangment_string[21] = 21  ;     
    arrangment_string[22] = 22  ;     
    arrangment_string[23] = 23  ;     
    arrangment_string[24] = 24  ;     
    arrangment_string[25] = 25  ;     
    arrangment_string[26] = 26  ;     
    arrangment_string[27] = 27  ;     
    arrangment_string[28] = 28  ;     
    arrangment_string[29] = 29  ;     
    arrangment_string[30] = 30  ;     
    arrangment_string[31] = 31  ;     
    arrangment_string[32] = 32  ;     
    arrangment_string[33] = 33  ;     
    arrangment_string[34] = 34  ;     
    arrangment_string[35] = 35  ;     
    arrangment_string[36] = 36  ;     
    arrangment_string[37] = 37  ;     
    arrangment_string[38] = 38  ;     
    arrangment_string[39] = 39  ;     
    arrangment_string[40] = 40  ;     
    arrangment_string[41] = 41  ;     
    arrangment_string[42] = 42  ;     
    arrangment_string[43] = 43  ;     
    arrangment_string[44] = 44  ;     
    arrangment_string[45] = 45  ;     
    arrangment_string[46] = 46  ;     
    arrangment_string[47] = 47  ;     
    arrangment_string[48] = 48  ;     
    arrangment_string[49] = 49  ;     
    arrangment_string[50] = 50  ;     
    arrangment_string[51] = 51  ;     
    arrangment_string[52] = 52  ;     
    arrangment_string[53] = 53  ;     
    arrangment_string[54] = 54  ;     
    arrangment_string[55] = 55  ;     
    arrangment_string[56] = 56  ;     
    arrangment_string[57] = 57  ;     
    arrangment_string[58] = 58  ;     
    arrangment_string[59] = 59  ;     
    arrangment_string[60] = 60  ;     
    arrangment_string[61] = 61  ;     
    arrangment_string[62] = 62  ;     
    arrangment_string[63] = 63  ;     
    arrangment_string[64] = 64  ;     
    arrangment_string[65] = 65  ;     
    arrangment_string[66] = 66  ;     
    arrangment_string[67] = 67  ;     
    arrangment_string[68] = 68  ;     
    arrangment_string[69] = 69  ;     
    arrangment_string[70] = 70  ;     
    arrangment_string[71] = 71  ;     
    arrangment_string[72] = 72  ;     
    arrangment_string[73] = 73  ;     
    arrangment_string[74] = 74  ;     
    arrangment_string[75] = 75  ;     
    arrangment_string[76] = 76  ;     
    arrangment_string[77] = 77  ;     
    arrangment_string[78] = 78  ;     
    arrangment_string[79] = 79  ;     
    arrangment_string[80] = 80  ;     
    arrangment_string[81] = 81  ;     
    arrangment_string[82] = 82  ;     
    arrangment_string[83] = 83  ;     
    arrangment_string[84] = 84  ;     
    arrangment_string[85] = 85  ;     
    arrangment_string[86] = 86  ;     
    arrangment_string[87] = 87  ;     
    arrangment_string[88] = 88  ;     
    arrangment_string[89] = 89  ;     
    arrangment_string[90] = 90  ;     
    arrangment_string[91] = 91  ;     
    arrangment_string[92] = 92  ;     
    arrangment_string[93] = 93  ;     
    arrangment_string[94] = 94  ;     
    arrangment_string[95] = 95  ;     
    arrangment_string[96] = 96  ;     
    arrangment_string[97] = 97  ;     
    arrangment_string[98] = 98  ;     
    arrangment_string[99] = 99  ;     
    arrangment_string[100] = 100  ;     
    arrangment_string[101] = 101  ;     
    arrangment_string[102] = 102  ;     
    arrangment_string[103] = 103  ;     
    arrangment_string[104] = 104  ;     
    arrangment_string[105] = 105  ;     
    arrangment_string[106] = 106  ;     
    arrangment_string[107] = 107  ;     
    arrangment_string[108] = 108  ;     
    arrangment_string[109] = 109  ;     
    arrangment_string[110] = 110  ;     
    arrangment_string[111] = 111  ;     
    arrangment_string[112] = 112  ;     
    arrangment_string[113] = 113  ;     
    arrangment_string[114] = 114  ;     
    arrangment_string[115] = 115  ;     
    arrangment_string[116] = 116  ;     
    arrangment_string[117] = 117  ;     
    arrangment_string[118] = 118  ;     
    arrangment_string[119] = 119  ;     
    arrangment_string[120] = 120  ;     
    arrangment_string[121] = 121  ;     
    arrangment_string[122] = 122  ;     
    arrangment_string[123] = 123  ;     
    arrangment_string[124] = 124  ;     
    arrangment_string[125] = 125  ;     
    arrangment_string[126] = 126  ;     
    arrangment_string[127] = 127  ;     
    arrangment_string[128] = 128  ;     
    arrangment_string[129] = 129  ;     
    arrangment_string[130] = 130  ;     
    arrangment_string[131] = 131  ;     
    arrangment_string[132] = 132  ;     
    arrangment_string[133] = 133  ;     
    arrangment_string[134] = 134  ;     
    arrangment_string[135] = 135  ;     
    arrangment_string[136] = 136  ;     
    arrangment_string[137] = 137  ;     
    arrangment_string[138] = 138  ;     
    arrangment_string[139] = 139  ;     
    arrangment_string[140] = 140  ;     
    arrangment_string[141] = 141  ;     
    arrangment_string[142] = 142  ;     
    arrangment_string[143] = 143  ;     
    arrangment_string[144] = 144  ;     
    arrangment_string[145] = 145  ;     
    arrangment_string[146] = 146  ;     
    arrangment_string[147] = 147  ;     
    arrangment_string[148] = 148  ;     
    arrangment_string[149] = 149  ;     
    arrangment_string[150] = 150  ;     
    arrangment_string[151] = 151  ;     
    arrangment_string[152] = 152  ;     
    arrangment_string[153] = 153  ;     
    arrangment_string[154] = 154  ;     
    arrangment_string[155] = 155  ;     
    arrangment_string[156] = 156  ;     
    arrangment_string[157] = 157  ;     
    arrangment_string[158] = 158  ;     
    arrangment_string[159] = 159  ;     
    arrangment_string[160] = 160  ;     
    arrangment_string[161] = 161  ;     
    arrangment_string[162] = 162  ;     
    arrangment_string[163] = 163  ;     
    arrangment_string[164] = 164  ;     
    arrangment_string[165] = 165  ;     
    arrangment_string[166] = 166  ;     
    arrangment_string[167] = 167  ;     
    arrangment_string[168] = 168  ;     
    arrangment_string[169] = 169  ;     
    arrangment_string[170] = 170  ;     
    arrangment_string[171] = 171  ;     
    arrangment_string[172] = 172  ;     
    arrangment_string[173] = 173  ;     
    arrangment_string[174] = 174  ;     
    arrangment_string[175] = 175  ;     
    arrangment_string[176] = 176  ;     
    arrangment_string[177] = 177  ;     
    arrangment_string[178] = 178  ;     
    arrangment_string[179] = 179  ;     
    arrangment_string[180] = 180  ;     
    arrangment_string[181] = 181  ;     
    arrangment_string[182] = 182  ;     
    arrangment_string[183] = 183  ;     
    arrangment_string[184] = 184  ;     
    arrangment_string[185] = 185  ;     
    arrangment_string[186] = 186  ;     
    arrangment_string[187] = 187  ;     
    arrangment_string[188] = 188  ;     
    arrangment_string[189] = 189  ;     
    arrangment_string[190] = 190  ;     
    arrangment_string[191] = 191  ;     
    arrangment_string[192] = 192  ;     
    arrangment_string[193] = 193  ;     
    arrangment_string[194] = 194  ;     
    arrangment_string[195] = 195  ;     
    arrangment_string[196] = 196  ;     
    arrangment_string[197] = 197  ;     
    arrangment_string[198] = 198  ;     
    arrangment_string[199] = 199  ;     
    arrangment_string[200] = 200  ;     
    arrangment_string[201] = 201  ;     
    arrangment_string[202] = 202  ;     
    arrangment_string[203] = 203  ;     
    arrangment_string[204] = 204  ;     
    arrangment_string[205] = 205  ;     
    arrangment_string[206] = 206  ;     
    arrangment_string[207] = 207  ;     
    arrangment_string[208] = 208  ;     
    arrangment_string[209] = 209  ;     
    arrangment_string[210] = 210  ;     
    arrangment_string[211] = 211  ;     
    arrangment_string[212] = 212  ;     
    arrangment_string[213] = 213  ;     
    arrangment_string[214] = 214  ;     
    arrangment_string[215] = 215  ;     
    arrangment_string[216] = 216  ;     
    arrangment_string[217] = 217  ;     
    arrangment_string[218] = 218  ;     
    arrangment_string[219] = 219  ;     
    arrangment_string[220] = 220  ;     
    arrangment_string[221] = 221  ;     
    arrangment_string[222] = 222  ;     
    arrangment_string[223] = 223  ;     
    arrangment_string[224] = 224  ;     
    arrangment_string[225] = 225  ;     
    arrangment_string[226] = 226  ;     
    arrangment_string[227] = 227  ;     
    arrangment_string[228] = 228  ;     
    arrangment_string[229] = 229  ;     
    arrangment_string[230] = 230  ;     
    arrangment_string[231] = 231  ;     
    arrangment_string[232] = 232  ;     
    arrangment_string[233] = 233  ;     
    arrangment_string[234] = 234  ;     
    arrangment_string[235] = 235  ;     
    arrangment_string[236] = 236  ;     
    arrangment_string[237] = 237  ;     
    arrangment_string[238] = 238  ;     
    arrangment_string[239] = 239  ;     
    arrangment_string[240] = 240  ;     
    arrangment_string[241] = 241  ;     
    arrangment_string[242] = 242  ;     
    arrangment_string[243] = 243  ;     
    arrangment_string[244] = 244  ;     
    arrangment_string[245] = 245  ;     
    arrangment_string[246] = 246  ;     
    arrangment_string[247] = 247  ;     
    arrangment_string[248] = 248  ;     
    arrangment_string[249] = 249  ;     
    arrangment_string[250] = 250  ;     
    arrangment_string[251] = 251  ;     
    arrangment_string[252] = 252  ;     
    arrangment_string[253] = 253  ;     
    arrangment_string[254] = 254  ;     
    arrangment_string[255] = 255  ;     
    arrangment_string[256] = 256  ;     
    arrangment_string[257] = 257  ;     
    arrangment_string[258] = 258  ;     
    arrangment_string[259] = 259  ;     
    arrangment_string[260] = 260  ;     
    arrangment_string[261] = 261  ;     
    arrangment_string[262] = 262  ;     
    arrangment_string[263] = 263  ;     
    arrangment_string[264] = 264  ;     
    arrangment_string[265] = 265  ;     
    arrangment_string[266] = 266  ;     
    arrangment_string[267] = 267  ;     
    arrangment_string[268] = 268  ;     
    arrangment_string[269] = 269  ;     
    arrangment_string[270] = 270  ;     
    arrangment_string[271] = 271  ;     
    arrangment_string[272] = 272  ;     
    arrangment_string[273] = 273  ;     
    arrangment_string[274] = 274  ;     
    arrangment_string[275] = 275  ;     
    arrangment_string[276] = 276  ;     
    arrangment_string[277] = 277  ;     
    arrangment_string[278] = 278  ;     
    arrangment_string[279] = 279  ;     
    arrangment_string[280] = 280  ;     
    arrangment_string[281] = 281  ;     
    arrangment_string[282] = 282  ;     
    arrangment_string[283] = 283  ;     
    arrangment_string[284] = 284  ;     
    arrangment_string[285] = 285  ;     
    arrangment_string[286] = 286  ;     
    arrangment_string[287] = 287  ;     
    arrangment_string[288] = 288  ;     
    arrangment_string[289] = 289  ;     
    arrangment_string[290] = 290  ;     
    arrangment_string[291] = 291  ;     
    arrangment_string[292] = 292  ;     
    arrangment_string[293] = 293  ;     
    arrangment_string[294] = 294  ;     
    arrangment_string[295] = 295  ;     
    arrangment_string[296] = 296  ;     
    arrangment_string[297] = 297  ;     
    arrangment_string[298] = 298  ;     
    arrangment_string[299] = 299  ;     
    arrangment_string[300] = 300  ;     
    arrangment_string[301] = 301  ;     
    arrangment_string[302] = 302  ;     
    arrangment_string[303] = 303  ;     
    arrangment_string[304] = 304  ;     
    arrangment_string[305] = 305  ;     
    arrangment_string[306] = 306  ;     
    arrangment_string[307] = 307  ;     
    arrangment_string[308] = 308  ;     
    arrangment_string[309] = 309  ;     
    arrangment_string[310] = 310  ;     
    arrangment_string[311] = 311  ;     
    arrangment_string[312] = 312  ;     
    arrangment_string[313] = 313  ;     
    arrangment_string[314] = 314  ;     
    arrangment_string[315] = 315  ;     
    arrangment_string[316] = 316  ;     
    arrangment_string[317] = 317  ;     
    arrangment_string[318] = 318  ;     
    arrangment_string[319] = 319  ;     
    arrangment_string[320] = 320  ;     
    arrangment_string[321] = 321  ;     
    arrangment_string[322] = 322  ;     
    arrangment_string[323] = 323  ;     
    arrangment_string[324] = 324  ;     
    arrangment_string[325] = 325  ;     
    arrangment_string[326] = 326  ;     
    arrangment_string[327] = 327  ;     
    arrangment_string[328] = 328  ;     
    arrangment_string[329] = 329  ;     
    arrangment_string[330] = 330  ;     
    arrangment_string[331] = 331  ;     
    arrangment_string[332] = 332  ;     
    arrangment_string[333] = 333  ;     
    arrangment_string[334] = 334  ;     
    arrangment_string[335] = 335  ;     
    arrangment_string[336] = 336  ;     
    arrangment_string[337] = 337  ;     
    arrangment_string[338] = 338  ;     
    arrangment_string[339] = 339  ;     
    arrangment_string[340] = 340  ;     
    arrangment_string[341] = 341  ;     
    arrangment_string[342] = 342  ;     
    arrangment_string[343] = 343  ;     
    arrangment_string[344] = 344  ;     
    arrangment_string[345] = 345  ;     
    arrangment_string[346] = 346  ;     
    arrangment_string[347] = 347  ;     
    arrangment_string[348] = 348  ;     
    arrangment_string[349] = 349  ;     
    arrangment_string[350] = 350  ;     
    arrangment_string[351] = 351  ;     
    arrangment_string[352] = 352  ;     
    arrangment_string[353] = 353  ;     
    arrangment_string[354] = 354  ;     
    arrangment_string[355] = 355  ;     
    arrangment_string[356] = 356  ;     
    arrangment_string[357] = 357  ;     
    arrangment_string[358] = 358  ;     
    arrangment_string[359] = 359  ;     
    arrangment_string[360] = 360  ;     
    arrangment_string[361] = 361  ;     
    arrangment_string[362] = 362  ;     
    arrangment_string[363] = 363  ;     
    arrangment_string[364] = 364  ;     
    arrangment_string[365] = 365  ;     
    arrangment_string[366] = 366  ;     
    arrangment_string[367] = 367  ;     
    arrangment_string[368] = 368  ;     
    arrangment_string[369] = 369  ;     
    arrangment_string[370] = 370  ;     
    arrangment_string[371] = 371  ;     
    arrangment_string[372] = 372  ;     
    arrangment_string[373] = 373  ;     
    arrangment_string[374] = 374  ;     
    arrangment_string[375] = 375  ;     
    arrangment_string[376] = 376  ;     
    arrangment_string[377] = 377  ;     
    arrangment_string[378] = 378  ;     
    arrangment_string[379] = 379  ;     
    arrangment_string[380] = 380  ;     
    arrangment_string[381] = 381  ;     
    arrangment_string[382] = 382  ;     
    arrangment_string[383] = 383  ;     
    arrangment_string[384] = 384  ;     
    arrangment_string[385] = 385  ;     
    arrangment_string[386] = 386  ;     
    arrangment_string[387] = 387  ;     
    arrangment_string[388] = 388  ;     
    arrangment_string[389] = 389  ;     
    arrangment_string[390] = 390  ;     
    arrangment_string[391] = 391  ;     
    arrangment_string[392] = 392  ;     
    arrangment_string[393] = 393  ;     
    arrangment_string[394] = 394  ;     
    arrangment_string[395] = 395  ;     
    arrangment_string[396] = 396  ;     
    arrangment_string[397] = 397  ;     
    arrangment_string[398] = 398  ;     
    arrangment_string[399] = 399  ;     
    arrangment_string[400] = 400  ;     
    arrangment_string[401] = 401  ;     
    arrangment_string[402] = 402  ;     
    arrangment_string[403] = 403  ;     
    arrangment_string[404] = 404  ;     
    arrangment_string[405] = 405  ;     
    arrangment_string[406] = 406  ;     
    arrangment_string[407] = 407  ;     
    arrangment_string[408] = 408  ;     
    arrangment_string[409] = 409  ;     
    arrangment_string[410] = 410  ;     
    arrangment_string[411] = 411  ;     
    arrangment_string[412] = 412  ;     
    arrangment_string[413] = 413  ;     
    arrangment_string[414] = 414  ;     
    arrangment_string[415] = 415  ;     
    arrangment_string[416] = 416  ;     
    arrangment_string[417] = 417  ;     
    arrangment_string[418] = 418  ;     
    arrangment_string[419] = 419  ;     
    arrangment_string[420] = 420  ;     
    arrangment_string[421] = 421  ;     
    arrangment_string[422] = 422  ;     
    arrangment_string[423] = 423  ;     
    arrangment_string[424] = 424  ;     
    arrangment_string[425] = 425  ;     
    arrangment_string[426] = 426  ;     
    arrangment_string[427] = 427  ;     
    arrangment_string[428] = 428  ;     
    arrangment_string[429] = 429  ;     
    arrangment_string[430] = 430  ;     
    arrangment_string[431] = 431  ;     
    arrangment_string[432] = 432  ;     
    arrangment_string[433] = 433  ;     
    arrangment_string[434] = 434  ;     
    arrangment_string[435] = 435  ;     
    arrangment_string[436] = 436  ;     
    arrangment_string[437] = 437  ;     
    arrangment_string[438] = 438  ;     
    arrangment_string[439] = 439  ;     
    arrangment_string[440] = 440  ;     
    arrangment_string[441] = 441  ;     
    arrangment_string[442] = 442  ;     
    arrangment_string[443] = 443  ;     
    arrangment_string[444] = 444  ;     
    arrangment_string[445] = 445  ;     
    arrangment_string[446] = 446  ;     
    arrangment_string[447] = 447  ;     
    arrangment_string[448] = 448  ;     
    arrangment_string[449] = 449  ;     
    arrangment_string[450] = 450  ;     
    arrangment_string[451] = 451  ;     
    arrangment_string[452] = 452  ;     
    arrangment_string[453] = 453  ;     
    arrangment_string[454] = 454  ;     
    arrangment_string[455] = 455  ;     
    arrangment_string[456] = 456  ;     
    arrangment_string[457] = 457  ;     
    arrangment_string[458] = 458  ;     
    arrangment_string[459] = 459  ;     
    arrangment_string[460] = 460  ;     
    arrangment_string[461] = 461  ;     
    arrangment_string[462] = 462  ;     
    arrangment_string[463] = 463  ;     
    arrangment_string[464] = 464  ;     
    arrangment_string[465] = 465  ;     
    arrangment_string[466] = 466  ;     
    arrangment_string[467] = 467  ;     
    arrangment_string[468] = 468  ;     
    arrangment_string[469] = 469  ;     
    arrangment_string[470] = 470  ;     
    arrangment_string[471] = 471  ;     
    arrangment_string[472] = 472  ;     
    arrangment_string[473] = 473  ;     
    arrangment_string[474] = 474  ;     
    arrangment_string[475] = 475  ;     
    arrangment_string[476] = 476  ;     
    arrangment_string[477] = 477  ;     
    arrangment_string[478] = 478  ;     
    arrangment_string[479] = 479  ;     
    arrangment_string[480] = 480  ;     
    arrangment_string[481] = 481  ;     
    arrangment_string[482] = 482  ;     
    arrangment_string[483] = 483  ;     
    arrangment_string[484] = 484  ;     
    arrangment_string[485] = 485  ;     
    arrangment_string[486] = 486  ;     
    arrangment_string[487] = 487  ;     
    arrangment_string[488] = 488  ;     
    arrangment_string[489] = 489  ;     
    arrangment_string[490] = 490  ;     
    arrangment_string[491] = 491  ;     
    arrangment_string[492] = 492  ;     
    arrangment_string[493] = 493  ;     
    arrangment_string[494] = 494  ;     
    arrangment_string[495] = 495  ;     
    arrangment_string[496] = 496  ;     
    arrangment_string[497] = 497  ;     
    arrangment_string[498] = 498  ;     
    arrangment_string[499] = 499  ;     
    arrangment_string[500] = 500  ;     
    arrangment_string[501] = 501  ;     
    arrangment_string[502] = 502  ;     
    arrangment_string[503] = 503  ;     
    arrangment_string[504] = 504  ;     
    arrangment_string[505] = 505  ;     
    arrangment_string[506] = 506  ;     
    arrangment_string[507] = 507  ;     
    arrangment_string[508] = 508  ;     
    arrangment_string[509] = 509  ;     
    arrangment_string[510] = 510  ;     
    arrangment_string[511] = 511  ;     
    arrangment_string[512] = 512  ;     
    arrangment_string[513] = 513  ;     
  end
endtask
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS

`ifndef MEM_REG_NAME 
 `define MEM_REG_NAME MX.mem
`endif

// Bit vector indicating which shadow addresses have been written
reg [79:0] shadow_written = 'b0;

// Shadow ram array used to store initialization values
reg [513:0] shadow_mem [79:0];


`ifdef NV_RAM_EXPAND_ARRAY
wire [513:0] shadow_mem_row0 = shadow_mem[0];
wire [513:0] shadow_mem_row1 = shadow_mem[1];
wire [513:0] shadow_mem_row2 = shadow_mem[2];
wire [513:0] shadow_mem_row3 = shadow_mem[3];
wire [513:0] shadow_mem_row4 = shadow_mem[4];
wire [513:0] shadow_mem_row5 = shadow_mem[5];
wire [513:0] shadow_mem_row6 = shadow_mem[6];
wire [513:0] shadow_mem_row7 = shadow_mem[7];
wire [513:0] shadow_mem_row8 = shadow_mem[8];
wire [513:0] shadow_mem_row9 = shadow_mem[9];
wire [513:0] shadow_mem_row10 = shadow_mem[10];
wire [513:0] shadow_mem_row11 = shadow_mem[11];
wire [513:0] shadow_mem_row12 = shadow_mem[12];
wire [513:0] shadow_mem_row13 = shadow_mem[13];
wire [513:0] shadow_mem_row14 = shadow_mem[14];
wire [513:0] shadow_mem_row15 = shadow_mem[15];
wire [513:0] shadow_mem_row16 = shadow_mem[16];
wire [513:0] shadow_mem_row17 = shadow_mem[17];
wire [513:0] shadow_mem_row18 = shadow_mem[18];
wire [513:0] shadow_mem_row19 = shadow_mem[19];
wire [513:0] shadow_mem_row20 = shadow_mem[20];
wire [513:0] shadow_mem_row21 = shadow_mem[21];
wire [513:0] shadow_mem_row22 = shadow_mem[22];
wire [513:0] shadow_mem_row23 = shadow_mem[23];
wire [513:0] shadow_mem_row24 = shadow_mem[24];
wire [513:0] shadow_mem_row25 = shadow_mem[25];
wire [513:0] shadow_mem_row26 = shadow_mem[26];
wire [513:0] shadow_mem_row27 = shadow_mem[27];
wire [513:0] shadow_mem_row28 = shadow_mem[28];
wire [513:0] shadow_mem_row29 = shadow_mem[29];
wire [513:0] shadow_mem_row30 = shadow_mem[30];
wire [513:0] shadow_mem_row31 = shadow_mem[31];
wire [513:0] shadow_mem_row32 = shadow_mem[32];
wire [513:0] shadow_mem_row33 = shadow_mem[33];
wire [513:0] shadow_mem_row34 = shadow_mem[34];
wire [513:0] shadow_mem_row35 = shadow_mem[35];
wire [513:0] shadow_mem_row36 = shadow_mem[36];
wire [513:0] shadow_mem_row37 = shadow_mem[37];
wire [513:0] shadow_mem_row38 = shadow_mem[38];
wire [513:0] shadow_mem_row39 = shadow_mem[39];
wire [513:0] shadow_mem_row40 = shadow_mem[40];
wire [513:0] shadow_mem_row41 = shadow_mem[41];
wire [513:0] shadow_mem_row42 = shadow_mem[42];
wire [513:0] shadow_mem_row43 = shadow_mem[43];
wire [513:0] shadow_mem_row44 = shadow_mem[44];
wire [513:0] shadow_mem_row45 = shadow_mem[45];
wire [513:0] shadow_mem_row46 = shadow_mem[46];
wire [513:0] shadow_mem_row47 = shadow_mem[47];
wire [513:0] shadow_mem_row48 = shadow_mem[48];
wire [513:0] shadow_mem_row49 = shadow_mem[49];
wire [513:0] shadow_mem_row50 = shadow_mem[50];
wire [513:0] shadow_mem_row51 = shadow_mem[51];
wire [513:0] shadow_mem_row52 = shadow_mem[52];
wire [513:0] shadow_mem_row53 = shadow_mem[53];
wire [513:0] shadow_mem_row54 = shadow_mem[54];
wire [513:0] shadow_mem_row55 = shadow_mem[55];
wire [513:0] shadow_mem_row56 = shadow_mem[56];
wire [513:0] shadow_mem_row57 = shadow_mem[57];
wire [513:0] shadow_mem_row58 = shadow_mem[58];
wire [513:0] shadow_mem_row59 = shadow_mem[59];
wire [513:0] shadow_mem_row60 = shadow_mem[60];
wire [513:0] shadow_mem_row61 = shadow_mem[61];
wire [513:0] shadow_mem_row62 = shadow_mem[62];
wire [513:0] shadow_mem_row63 = shadow_mem[63];
wire [513:0] shadow_mem_row64 = shadow_mem[64];
wire [513:0] shadow_mem_row65 = shadow_mem[65];
wire [513:0] shadow_mem_row66 = shadow_mem[66];
wire [513:0] shadow_mem_row67 = shadow_mem[67];
wire [513:0] shadow_mem_row68 = shadow_mem[68];
wire [513:0] shadow_mem_row69 = shadow_mem[69];
wire [513:0] shadow_mem_row70 = shadow_mem[70];
wire [513:0] shadow_mem_row71 = shadow_mem[71];
wire [513:0] shadow_mem_row72 = shadow_mem[72];
wire [513:0] shadow_mem_row73 = shadow_mem[73];
wire [513:0] shadow_mem_row74 = shadow_mem[74];
wire [513:0] shadow_mem_row75 = shadow_mem[75];
wire [513:0] shadow_mem_row76 = shadow_mem[76];
wire [513:0] shadow_mem_row77 = shadow_mem[77];
wire [513:0] shadow_mem_row78 = shadow_mem[78];
wire [513:0] shadow_mem_row79 = shadow_mem[79];
`endif

task init_mem_val;
  input [6:0] row;
  input [513:0] data;
  begin
    shadow_mem[row] = data;
    shadow_written[row] = 1'b1;
  end
endtask

task init_mem_commit;
integer row;
begin

// initializing RAMPDP_80X288_GL_M1_D2
for (row = 0; row < 80; row = row + 1)
 if (shadow_written[row]) r_nv_ram_rwsp_80x514.ram_Inst_80X288_0_0.mem_write(row - 0, shadow_mem[row][287:0]);

// initializing RAMPDP_80X226_GL_M1_D2
for (row = 0; row < 80; row = row + 1)
 if (shadow_written[row]) r_nv_ram_rwsp_80x514.ram_Inst_80X226_0_288.mem_write(row - 0, shadow_mem[row][513:288]);

shadow_written = 'b0;
end
endtask
`endif
`endif
`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS
task do_write; //(wa, we, di);
   input  [6:0] wa;
   input   we;
   input  [513:0] di;
   reg    [513:0] d;
   begin
      d = probe_mem_val(wa);
      d = (we ? di : d);
      init_mem_val(wa,d);
   end
endtask

`endif
`endif


`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS

`ifndef MEM_REG_NAME 
 `define MEM_REG_NAME MX.mem
`endif

function [513:0] probe_mem_val;
input [6:0] row;
reg [513:0] data;
begin

// probing RAMPDP_80X288_GL_M1_D2
 if (row >=  0 &&  row < 80) data[287:0] = r_nv_ram_rwsp_80x514.ram_Inst_80X288_0_0.mem_read(row - 0);

// probing RAMPDP_80X226_GL_M1_D2
 if (row >=  0 &&  row < 80) data[513:288] = r_nv_ram_rwsp_80x514.ram_Inst_80X226_0_288.mem_read(row - 0);
    probe_mem_val = data;

end
endfunction
`endif
`endif

`ifndef SYNTHESIS
`ifndef NO_CLEAR_MEM_TASK
`ifndef NO_INIT_MEM_VAL_TASKS
reg disable_clear_mem = 0;
task clear_mem;
integer i;
begin
  if (!disable_clear_mem) 
  begin
    for (i = 0; i < 80; i = i + 1)
      begin
        init_mem_val(i, 'bx);
      end
    init_mem_commit();
  end
end
endtask
`endif
`endif
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_ZERO_TASK
`ifndef NO_INIT_MEM_VAL_TASKS
task init_mem_zero;
integer i;
begin
 for (i = 0; i < 80; i = i + 1)
   begin
     init_mem_val(i, 'b0);
   end
 init_mem_commit();
end
endtask
`endif
`endif
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS
`ifndef NO_INIT_MEM_FROM_FILE_TASK
task init_mem_from_file;
input string init_file;
integer i;
begin

 $readmemh(init_file,shadow_mem);
 for (i = 0; i < 80; i = i + 1)
   begin

     shadow_written[i] = 1'b1;

   end
 init_mem_commit();

end
endtask
`endif
`endif
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_RANDOM_TASK
`ifndef NO_INIT_MEM_VAL_TASKS
RANDFUNC rf0 ();
RANDFUNC rf1 ();
RANDFUNC rf2 ();
RANDFUNC rf3 ();
RANDFUNC rf4 ();
RANDFUNC rf5 ();
RANDFUNC rf6 ();
RANDFUNC rf7 ();
RANDFUNC rf8 ();
RANDFUNC rf9 ();
RANDFUNC rf10 ();
RANDFUNC rf11 ();
RANDFUNC rf12 ();
RANDFUNC rf13 ();
RANDFUNC rf14 ();
RANDFUNC rf15 ();
RANDFUNC rf16 ();

task init_mem_random;
reg [513:0] random_num;
integer i;
begin
 for (i = 0; i < 80; i = i + 1)
   begin
     random_num = {rf0.rollpli(0,32'hffffffff),rf1.rollpli(0,32'hffffffff),rf2.rollpli(0,32'hffffffff),rf3.rollpli(0,32'hffffffff),rf4.rollpli(0,32'hffffffff),rf5.rollpli(0,32'hffffffff),rf6.rollpli(0,32'hffffffff),rf7.rollpli(0,32'hffffffff),rf8.rollpli(0,32'hffffffff),rf9.rollpli(0,32'hffffffff),rf10.rollpli(0,32'hffffffff),rf11.rollpli(0,32'hffffffff),rf12.rollpli(0,32'hffffffff),rf13.rollpli(0,32'hffffffff),rf14.rollpli(0,32'hffffffff),rf15.rollpli(0,32'hffffffff),rf16.rollpli(0,32'hffffffff)};
     init_mem_val(i, random_num);
   end
 init_mem_commit();
end
endtask
`endif
`endif
`endif

`ifndef SYNTHESIS
`ifndef NO_FLIP_TASKS
`ifndef NO_INIT_MEM_VAL_TASKS

RANDFUNC rflip ();

task random_flip;
integer random_num;
integer row;
integer bitnum;
begin
  random_num = rflip.rollpli(0, 41120);
  row = random_num / 514;
  bitnum = random_num % 514;
  target_flip(row, bitnum);
end
endtask

task target_flip;
input [6:0] row;
input [513:0] bitnum;
reg [513:0] data;
begin
  if(!$test$plusargs("no_display_target_flips"))
    $display("%m: flipping row %d bit %d at time %t", row, bitnum, $time);

  data = probe_mem_val(row);
  data[bitnum] = ~data[bitnum];
  init_mem_val(row, data);
  init_mem_commit();
end
endtask

`endif
`endif
`endif

// The main module is done
endmodule

//********************************************************************************

