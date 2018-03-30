// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rws_32x272.v

`timescale 1ns / 10ps
module nv_ram_rws_32x272 (
        clk,
        ra,
        re,
        dout,
        wa,
        we,
        di,
        pwrbus_ram_pd
        );
parameter FORCE_CONTENTION_ASSERTION_RESET_ACTIVE=1'b0;

// port list
input           clk;
input  [4:0]    ra;
input           re;
output [271:0]  dout;
input  [4:0]    wa;
input           we;
input  [271:0]  di;
input  [31:0]   pwrbus_ram_pd;



// This wrapper consists of :  1 Ram cells: RAMPDP_32X272_GL_M1_D2 ;  

//Wires for Misc Ports 
wire  DFT_clamp;

//Wires for Mbist Ports 
wire [4:0] mbist_Wa_w0;
wire [1:0] mbist_Di_w0;
wire  mbist_we_w0;
wire [4:0] mbist_Ra_r0;

// verilint 528 off - Variable set but not used
wire [271:0] mbist_Do_r0_int_net;
// verilint 528 on - Variable set but not used
wire  mbist_ce_r0;
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
wire pre_mbist_Di_w0_0;
NV_BLKBOX_SRC0_X testInst_mbist_Di_w0_0 (.Y(pre_mbist_Di_w0_0));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Di_w0_0 (.Z(mbist_Di_w0[0]), .A1(pre_mbist_Di_w0_0), .A2(DFT_clamp) );
wire pre_mbist_Di_w0_1;
NV_BLKBOX_SRC0_X testInst_mbist_Di_w0_1 (.Y(pre_mbist_Di_w0_1));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Di_w0_1 (.Z(mbist_Di_w0[1]), .A1(pre_mbist_Di_w0_1), .A2(DFT_clamp) );
wire pre_mbist_we_w0;
NV_BLKBOX_SRC0_X testInst_mbist_we_w0 (.Y(pre_mbist_we_w0));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_we_w0 (.Z(mbist_we_w0), .A1(pre_mbist_we_w0), .A2(DFT_clamp) );
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
wire pre_mbist_ce_r0;
NV_BLKBOX_SRC0_X testInst_mbist_ce_r0 (.Y(pre_mbist_ce_r0));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_ce_r0 (.Z(mbist_ce_r0), .A1(pre_mbist_ce_r0), .A2(DFT_clamp) );
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
nv_ram_rws_32x272_logic #(FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) r_nv_ram_rws_32x272 (
                           .SI(SI), .SO_int_net(SO_int_net), 
                           .ary_atpg_ctl(ary_atpg_ctl), 
                           .ary_read_inh(ary_read_inh), .clk(clk), 
                           .debug_mode(debug_mode), .di(di), .dout(dout), 
                           .iddq_mode(iddq_mode), 
                           .jtag_readonly_mode(jtag_readonly_mode), 
                           .mbist_Di_w0(mbist_Di_w0), 
                           .mbist_Do_r0_int_net(mbist_Do_r0_int_net), 
                           .mbist_Ra_r0(mbist_Ra_r0), .mbist_Wa_w0(mbist_Wa_w0), 
                           .mbist_ce_r0(mbist_ce_r0), 
                           .mbist_en_sync(mbist_en_sync), 
                           .mbist_ramaccess_rst_(mbist_ramaccess_rst_), 
                           .mbist_we_w0(mbist_we_w0), 
                           .pwrbus_ram_pd(pwrbus_ram_pd), .ra(ra), .re(re), 
                           .scan_en(scan_en), .scan_ramtms(scan_ramtms), 
                           .shiftDR(shiftDR), .svop(svop), .updateDR(updateDR), 
                           .wa(wa), .we(we), .write_inh(write_inh) );
// verilint 402 on - inferred Reset must be a module port


// synopsys dc_tcl_script_begin
// synopsys dc_tcl_script_end



// synopsys dc_tcl_script_begin
// synopsys dc_tcl_script_end


`ifndef SYNTHESIS
task arrangement (output integer arrangment_string[271:0]);
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
  end
endtask
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS

`ifndef MEM_REG_NAME 
 `define MEM_REG_NAME MX.mem
`endif

// Bit vector indicating which shadow addresses have been written
reg [31:0] shadow_written = 'b0;

// Shadow ram array used to store initialization values
reg [271:0] shadow_mem [31:0];


`ifdef NV_RAM_EXPAND_ARRAY
wire [271:0] shadow_mem_row0 = shadow_mem[0];
wire [271:0] shadow_mem_row1 = shadow_mem[1];
wire [271:0] shadow_mem_row2 = shadow_mem[2];
wire [271:0] shadow_mem_row3 = shadow_mem[3];
wire [271:0] shadow_mem_row4 = shadow_mem[4];
wire [271:0] shadow_mem_row5 = shadow_mem[5];
wire [271:0] shadow_mem_row6 = shadow_mem[6];
wire [271:0] shadow_mem_row7 = shadow_mem[7];
wire [271:0] shadow_mem_row8 = shadow_mem[8];
wire [271:0] shadow_mem_row9 = shadow_mem[9];
wire [271:0] shadow_mem_row10 = shadow_mem[10];
wire [271:0] shadow_mem_row11 = shadow_mem[11];
wire [271:0] shadow_mem_row12 = shadow_mem[12];
wire [271:0] shadow_mem_row13 = shadow_mem[13];
wire [271:0] shadow_mem_row14 = shadow_mem[14];
wire [271:0] shadow_mem_row15 = shadow_mem[15];
wire [271:0] shadow_mem_row16 = shadow_mem[16];
wire [271:0] shadow_mem_row17 = shadow_mem[17];
wire [271:0] shadow_mem_row18 = shadow_mem[18];
wire [271:0] shadow_mem_row19 = shadow_mem[19];
wire [271:0] shadow_mem_row20 = shadow_mem[20];
wire [271:0] shadow_mem_row21 = shadow_mem[21];
wire [271:0] shadow_mem_row22 = shadow_mem[22];
wire [271:0] shadow_mem_row23 = shadow_mem[23];
wire [271:0] shadow_mem_row24 = shadow_mem[24];
wire [271:0] shadow_mem_row25 = shadow_mem[25];
wire [271:0] shadow_mem_row26 = shadow_mem[26];
wire [271:0] shadow_mem_row27 = shadow_mem[27];
wire [271:0] shadow_mem_row28 = shadow_mem[28];
wire [271:0] shadow_mem_row29 = shadow_mem[29];
wire [271:0] shadow_mem_row30 = shadow_mem[30];
wire [271:0] shadow_mem_row31 = shadow_mem[31];
`endif

task init_mem_val;
  input [4:0] row;
  input [271:0] data;
  begin
    shadow_mem[row] = data;
    shadow_written[row] = 1'b1;
  end
endtask

task init_mem_commit;
integer row;
begin

// initializing RAMPDP_32X272_GL_M1_D2
for (row = 0; row < 32; row = row + 1)
 if (shadow_written[row]) r_nv_ram_rws_32x272.ram_Inst_32X272.mem_write(row - 0, shadow_mem[row][271:0]);

shadow_written = 'b0;
end
endtask
`endif
`endif
`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS
task do_write; //(wa, we, di);
   input  [4:0] wa;
   input   we;
   input  [271:0] di;
   reg    [271:0] d;
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

function [271:0] probe_mem_val;
input [4:0] row;
reg [271:0] data;
begin

// probing RAMPDP_32X272_GL_M1_D2
 if (row >=  0 &&  row < 32) data[271:0] = r_nv_ram_rws_32x272.ram_Inst_32X272.mem_read(row - 0);
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
    for (i = 0; i < 32; i = i + 1)
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
 for (i = 0; i < 32; i = i + 1)
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
 for (i = 0; i < 32; i = i + 1)
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

task init_mem_random;
reg [271:0] random_num;
integer i;
begin
 for (i = 0; i < 32; i = i + 1)
   begin
     random_num = {rf0.rollpli(0,32'hffffffff),rf1.rollpli(0,32'hffffffff),rf2.rollpli(0,32'hffffffff),rf3.rollpli(0,32'hffffffff),rf4.rollpli(0,32'hffffffff),rf5.rollpli(0,32'hffffffff),rf6.rollpli(0,32'hffffffff),rf7.rollpli(0,32'hffffffff),rf8.rollpli(0,32'hffffffff)};
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
  random_num = rflip.rollpli(0, 8704);
  row = random_num / 272;
  bitnum = random_num % 272;
  target_flip(row, bitnum);
end
endtask

task target_flip;
input [4:0] row;
input [271:0] bitnum;
reg [271:0] data;
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

