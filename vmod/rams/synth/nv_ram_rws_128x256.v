// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rws_128x256.v

`timescale 1ns / 10ps
module nv_ram_rws_128x256 (
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
input  [6:0]    ra;
input           re;
output [255:0]  dout;
input  [6:0]    wa;
input           we;
input  [255:0]  di;
input  [31:0]   pwrbus_ram_pd;



// This wrapper consists of :  1 Ram cells: RAMPDP_128X256_GL_M1_D2 ;  

//Wires for Misc Ports 
wire  DFT_clamp;

//Wires for Mbist Ports 
wire [6:0] mbist_Wa_w0;
wire [1:0] mbist_Di_w0;
wire  mbist_we_w0;
wire [6:0] mbist_Ra_r0;

// verilint 528 off - Variable set but not used
wire [255:0] mbist_Do_r0_int_net;
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
wire pre_mbist_Ra_r0_5;
NV_BLKBOX_SRC0_X testInst_mbist_Ra_r0_5 (.Y(pre_mbist_Ra_r0_5));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Ra_r0_5 (.Z(mbist_Ra_r0[5]), .A1(pre_mbist_Ra_r0_5), .A2(DFT_clamp) );
wire pre_mbist_Ra_r0_6;
NV_BLKBOX_SRC0_X testInst_mbist_Ra_r0_6 (.Y(pre_mbist_Ra_r0_6));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Ra_r0_6 (.Z(mbist_Ra_r0[6]), .A1(pre_mbist_Ra_r0_6), .A2(DFT_clamp) );
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_0 (.A(mbist_Do_r0_int_net[0]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_1 (.A(mbist_Do_r0_int_net[1]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_2 (.A(mbist_Do_r0_int_net[2]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_3 (.A(mbist_Do_r0_int_net[3]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_4 (.A(mbist_Do_r0_int_net[4]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_5 (.A(mbist_Do_r0_int_net[5]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_6 (.A(mbist_Do_r0_int_net[6]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_7 (.A(mbist_Do_r0_int_net[7]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_8 (.A(mbist_Do_r0_int_net[8]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_9 (.A(mbist_Do_r0_int_net[9]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_10 (.A(mbist_Do_r0_int_net[10]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_11 (.A(mbist_Do_r0_int_net[11]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_12 (.A(mbist_Do_r0_int_net[12]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_13 (.A(mbist_Do_r0_int_net[13]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_14 (.A(mbist_Do_r0_int_net[14]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_15 (.A(mbist_Do_r0_int_net[15]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_16 (.A(mbist_Do_r0_int_net[16]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_17 (.A(mbist_Do_r0_int_net[17]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_18 (.A(mbist_Do_r0_int_net[18]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_19 (.A(mbist_Do_r0_int_net[19]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_20 (.A(mbist_Do_r0_int_net[20]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_21 (.A(mbist_Do_r0_int_net[21]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_22 (.A(mbist_Do_r0_int_net[22]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_23 (.A(mbist_Do_r0_int_net[23]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_24 (.A(mbist_Do_r0_int_net[24]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_25 (.A(mbist_Do_r0_int_net[25]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_26 (.A(mbist_Do_r0_int_net[26]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_27 (.A(mbist_Do_r0_int_net[27]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_28 (.A(mbist_Do_r0_int_net[28]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_29 (.A(mbist_Do_r0_int_net[29]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_30 (.A(mbist_Do_r0_int_net[30]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_31 (.A(mbist_Do_r0_int_net[31]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_32 (.A(mbist_Do_r0_int_net[32]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_33 (.A(mbist_Do_r0_int_net[33]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_34 (.A(mbist_Do_r0_int_net[34]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_35 (.A(mbist_Do_r0_int_net[35]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_36 (.A(mbist_Do_r0_int_net[36]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_37 (.A(mbist_Do_r0_int_net[37]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_38 (.A(mbist_Do_r0_int_net[38]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_39 (.A(mbist_Do_r0_int_net[39]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_40 (.A(mbist_Do_r0_int_net[40]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_41 (.A(mbist_Do_r0_int_net[41]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_42 (.A(mbist_Do_r0_int_net[42]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_43 (.A(mbist_Do_r0_int_net[43]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_44 (.A(mbist_Do_r0_int_net[44]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_45 (.A(mbist_Do_r0_int_net[45]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_46 (.A(mbist_Do_r0_int_net[46]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_47 (.A(mbist_Do_r0_int_net[47]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_48 (.A(mbist_Do_r0_int_net[48]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_49 (.A(mbist_Do_r0_int_net[49]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_50 (.A(mbist_Do_r0_int_net[50]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_51 (.A(mbist_Do_r0_int_net[51]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_52 (.A(mbist_Do_r0_int_net[52]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_53 (.A(mbist_Do_r0_int_net[53]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_54 (.A(mbist_Do_r0_int_net[54]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_55 (.A(mbist_Do_r0_int_net[55]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_56 (.A(mbist_Do_r0_int_net[56]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_57 (.A(mbist_Do_r0_int_net[57]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_58 (.A(mbist_Do_r0_int_net[58]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_59 (.A(mbist_Do_r0_int_net[59]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_60 (.A(mbist_Do_r0_int_net[60]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_61 (.A(mbist_Do_r0_int_net[61]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_62 (.A(mbist_Do_r0_int_net[62]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_63 (.A(mbist_Do_r0_int_net[63]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_64 (.A(mbist_Do_r0_int_net[64]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_65 (.A(mbist_Do_r0_int_net[65]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_66 (.A(mbist_Do_r0_int_net[66]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_67 (.A(mbist_Do_r0_int_net[67]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_68 (.A(mbist_Do_r0_int_net[68]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_69 (.A(mbist_Do_r0_int_net[69]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_70 (.A(mbist_Do_r0_int_net[70]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_71 (.A(mbist_Do_r0_int_net[71]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_72 (.A(mbist_Do_r0_int_net[72]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_73 (.A(mbist_Do_r0_int_net[73]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_74 (.A(mbist_Do_r0_int_net[74]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_75 (.A(mbist_Do_r0_int_net[75]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_76 (.A(mbist_Do_r0_int_net[76]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_77 (.A(mbist_Do_r0_int_net[77]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_78 (.A(mbist_Do_r0_int_net[78]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_79 (.A(mbist_Do_r0_int_net[79]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_80 (.A(mbist_Do_r0_int_net[80]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_81 (.A(mbist_Do_r0_int_net[81]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_82 (.A(mbist_Do_r0_int_net[82]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_83 (.A(mbist_Do_r0_int_net[83]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_84 (.A(mbist_Do_r0_int_net[84]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_85 (.A(mbist_Do_r0_int_net[85]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_86 (.A(mbist_Do_r0_int_net[86]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_87 (.A(mbist_Do_r0_int_net[87]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_88 (.A(mbist_Do_r0_int_net[88]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_89 (.A(mbist_Do_r0_int_net[89]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_90 (.A(mbist_Do_r0_int_net[90]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_91 (.A(mbist_Do_r0_int_net[91]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_92 (.A(mbist_Do_r0_int_net[92]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_93 (.A(mbist_Do_r0_int_net[93]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_94 (.A(mbist_Do_r0_int_net[94]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_95 (.A(mbist_Do_r0_int_net[95]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_96 (.A(mbist_Do_r0_int_net[96]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_97 (.A(mbist_Do_r0_int_net[97]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_98 (.A(mbist_Do_r0_int_net[98]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_99 (.A(mbist_Do_r0_int_net[99]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_100 (.A(mbist_Do_r0_int_net[100]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_101 (.A(mbist_Do_r0_int_net[101]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_102 (.A(mbist_Do_r0_int_net[102]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_103 (.A(mbist_Do_r0_int_net[103]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_104 (.A(mbist_Do_r0_int_net[104]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_105 (.A(mbist_Do_r0_int_net[105]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_106 (.A(mbist_Do_r0_int_net[106]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_107 (.A(mbist_Do_r0_int_net[107]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_108 (.A(mbist_Do_r0_int_net[108]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_109 (.A(mbist_Do_r0_int_net[109]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_110 (.A(mbist_Do_r0_int_net[110]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_111 (.A(mbist_Do_r0_int_net[111]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_112 (.A(mbist_Do_r0_int_net[112]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_113 (.A(mbist_Do_r0_int_net[113]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_114 (.A(mbist_Do_r0_int_net[114]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_115 (.A(mbist_Do_r0_int_net[115]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_116 (.A(mbist_Do_r0_int_net[116]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_117 (.A(mbist_Do_r0_int_net[117]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_118 (.A(mbist_Do_r0_int_net[118]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_119 (.A(mbist_Do_r0_int_net[119]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_120 (.A(mbist_Do_r0_int_net[120]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_121 (.A(mbist_Do_r0_int_net[121]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_122 (.A(mbist_Do_r0_int_net[122]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_123 (.A(mbist_Do_r0_int_net[123]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_124 (.A(mbist_Do_r0_int_net[124]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_125 (.A(mbist_Do_r0_int_net[125]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_126 (.A(mbist_Do_r0_int_net[126]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_127 (.A(mbist_Do_r0_int_net[127]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_128 (.A(mbist_Do_r0_int_net[128]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_129 (.A(mbist_Do_r0_int_net[129]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_130 (.A(mbist_Do_r0_int_net[130]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_131 (.A(mbist_Do_r0_int_net[131]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_132 (.A(mbist_Do_r0_int_net[132]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_133 (.A(mbist_Do_r0_int_net[133]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_134 (.A(mbist_Do_r0_int_net[134]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_135 (.A(mbist_Do_r0_int_net[135]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_136 (.A(mbist_Do_r0_int_net[136]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_137 (.A(mbist_Do_r0_int_net[137]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_138 (.A(mbist_Do_r0_int_net[138]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_139 (.A(mbist_Do_r0_int_net[139]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_140 (.A(mbist_Do_r0_int_net[140]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_141 (.A(mbist_Do_r0_int_net[141]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_142 (.A(mbist_Do_r0_int_net[142]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_143 (.A(mbist_Do_r0_int_net[143]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_144 (.A(mbist_Do_r0_int_net[144]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_145 (.A(mbist_Do_r0_int_net[145]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_146 (.A(mbist_Do_r0_int_net[146]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_147 (.A(mbist_Do_r0_int_net[147]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_148 (.A(mbist_Do_r0_int_net[148]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_149 (.A(mbist_Do_r0_int_net[149]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_150 (.A(mbist_Do_r0_int_net[150]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_151 (.A(mbist_Do_r0_int_net[151]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_152 (.A(mbist_Do_r0_int_net[152]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_153 (.A(mbist_Do_r0_int_net[153]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_154 (.A(mbist_Do_r0_int_net[154]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_155 (.A(mbist_Do_r0_int_net[155]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_156 (.A(mbist_Do_r0_int_net[156]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_157 (.A(mbist_Do_r0_int_net[157]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_158 (.A(mbist_Do_r0_int_net[158]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_159 (.A(mbist_Do_r0_int_net[159]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_160 (.A(mbist_Do_r0_int_net[160]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_161 (.A(mbist_Do_r0_int_net[161]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_162 (.A(mbist_Do_r0_int_net[162]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_163 (.A(mbist_Do_r0_int_net[163]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_164 (.A(mbist_Do_r0_int_net[164]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_165 (.A(mbist_Do_r0_int_net[165]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_166 (.A(mbist_Do_r0_int_net[166]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_167 (.A(mbist_Do_r0_int_net[167]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_168 (.A(mbist_Do_r0_int_net[168]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_169 (.A(mbist_Do_r0_int_net[169]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_170 (.A(mbist_Do_r0_int_net[170]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_171 (.A(mbist_Do_r0_int_net[171]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_172 (.A(mbist_Do_r0_int_net[172]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_173 (.A(mbist_Do_r0_int_net[173]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_174 (.A(mbist_Do_r0_int_net[174]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_175 (.A(mbist_Do_r0_int_net[175]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_176 (.A(mbist_Do_r0_int_net[176]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_177 (.A(mbist_Do_r0_int_net[177]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_178 (.A(mbist_Do_r0_int_net[178]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_179 (.A(mbist_Do_r0_int_net[179]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_180 (.A(mbist_Do_r0_int_net[180]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_181 (.A(mbist_Do_r0_int_net[181]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_182 (.A(mbist_Do_r0_int_net[182]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_183 (.A(mbist_Do_r0_int_net[183]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_184 (.A(mbist_Do_r0_int_net[184]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_185 (.A(mbist_Do_r0_int_net[185]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_186 (.A(mbist_Do_r0_int_net[186]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_187 (.A(mbist_Do_r0_int_net[187]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_188 (.A(mbist_Do_r0_int_net[188]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_189 (.A(mbist_Do_r0_int_net[189]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_190 (.A(mbist_Do_r0_int_net[190]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_191 (.A(mbist_Do_r0_int_net[191]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_192 (.A(mbist_Do_r0_int_net[192]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_193 (.A(mbist_Do_r0_int_net[193]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_194 (.A(mbist_Do_r0_int_net[194]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_195 (.A(mbist_Do_r0_int_net[195]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_196 (.A(mbist_Do_r0_int_net[196]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_197 (.A(mbist_Do_r0_int_net[197]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_198 (.A(mbist_Do_r0_int_net[198]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_199 (.A(mbist_Do_r0_int_net[199]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_200 (.A(mbist_Do_r0_int_net[200]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_201 (.A(mbist_Do_r0_int_net[201]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_202 (.A(mbist_Do_r0_int_net[202]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_203 (.A(mbist_Do_r0_int_net[203]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_204 (.A(mbist_Do_r0_int_net[204]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_205 (.A(mbist_Do_r0_int_net[205]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_206 (.A(mbist_Do_r0_int_net[206]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_207 (.A(mbist_Do_r0_int_net[207]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_208 (.A(mbist_Do_r0_int_net[208]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_209 (.A(mbist_Do_r0_int_net[209]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_210 (.A(mbist_Do_r0_int_net[210]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_211 (.A(mbist_Do_r0_int_net[211]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_212 (.A(mbist_Do_r0_int_net[212]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_213 (.A(mbist_Do_r0_int_net[213]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_214 (.A(mbist_Do_r0_int_net[214]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_215 (.A(mbist_Do_r0_int_net[215]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_216 (.A(mbist_Do_r0_int_net[216]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_217 (.A(mbist_Do_r0_int_net[217]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_218 (.A(mbist_Do_r0_int_net[218]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_219 (.A(mbist_Do_r0_int_net[219]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_220 (.A(mbist_Do_r0_int_net[220]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_221 (.A(mbist_Do_r0_int_net[221]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_222 (.A(mbist_Do_r0_int_net[222]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_223 (.A(mbist_Do_r0_int_net[223]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_224 (.A(mbist_Do_r0_int_net[224]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_225 (.A(mbist_Do_r0_int_net[225]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_226 (.A(mbist_Do_r0_int_net[226]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_227 (.A(mbist_Do_r0_int_net[227]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_228 (.A(mbist_Do_r0_int_net[228]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_229 (.A(mbist_Do_r0_int_net[229]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_230 (.A(mbist_Do_r0_int_net[230]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_231 (.A(mbist_Do_r0_int_net[231]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_232 (.A(mbist_Do_r0_int_net[232]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_233 (.A(mbist_Do_r0_int_net[233]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_234 (.A(mbist_Do_r0_int_net[234]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_235 (.A(mbist_Do_r0_int_net[235]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_236 (.A(mbist_Do_r0_int_net[236]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_237 (.A(mbist_Do_r0_int_net[237]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_238 (.A(mbist_Do_r0_int_net[238]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_239 (.A(mbist_Do_r0_int_net[239]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_240 (.A(mbist_Do_r0_int_net[240]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_241 (.A(mbist_Do_r0_int_net[241]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_242 (.A(mbist_Do_r0_int_net[242]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_243 (.A(mbist_Do_r0_int_net[243]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_244 (.A(mbist_Do_r0_int_net[244]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_245 (.A(mbist_Do_r0_int_net[245]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_246 (.A(mbist_Do_r0_int_net[246]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_247 (.A(mbist_Do_r0_int_net[247]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_248 (.A(mbist_Do_r0_int_net[248]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_249 (.A(mbist_Do_r0_int_net[249]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_250 (.A(mbist_Do_r0_int_net[250]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_251 (.A(mbist_Do_r0_int_net[251]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_252 (.A(mbist_Do_r0_int_net[252]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_253 (.A(mbist_Do_r0_int_net[253]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_254 (.A(mbist_Do_r0_int_net[254]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK testInst_mbist_Do_r0_255 (.A(mbist_Do_r0_int_net[255]));
`endif 
wire pre_mbist_ce_r0;
NV_BLKBOX_SRC0_X testInst_mbist_ce_r0 (.Y(pre_mbist_ce_r0));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_ce_r0 (.Z(mbist_ce_r0), .A1(pre_mbist_ce_r0), .A2(DFT_clamp) );
wire pre_mbist_en_sync;
NV_BLKBOX_SRC0_X testInst_mbist_en_sync (.Y(pre_mbist_en_sync));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_en_sync (.Z(mbist_en_sync), .A1(pre_mbist_en_sync), .A2(DFT_clamp) );
wire pre_SI;
NV_BLKBOX_SRC0_X testInst_SI (.Y(pre_SI));
AN2D4PO4 UJ_DFTQUALIFIER_SI (.Z(SI), .A1(pre_SI), .A2(DFT_clamp) );
`ifndef FPGA 
NV_BLKBOX_SINK testInst_SO (.A(SO_int_net));
`endif 
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
nv_ram_rws_128x256_logic #(FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) r_nv_ram_rws_128x256 (
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
task arrangement (output integer arrangment_string[255:0]);
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
  end
endtask
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS

`ifndef MEM_REG_NAME 
 `define MEM_REG_NAME MX.mem
`endif

// Bit vector indicating which shadow addresses have been written
reg [127:0] shadow_written = 'b0;

// Shadow ram array used to store initialization values
reg [255:0] shadow_mem [127:0];


`ifdef NV_RAM_EXPAND_ARRAY
wire [255:0] shadow_mem_row0 = shadow_mem[0];
wire [255:0] shadow_mem_row1 = shadow_mem[1];
wire [255:0] shadow_mem_row2 = shadow_mem[2];
wire [255:0] shadow_mem_row3 = shadow_mem[3];
wire [255:0] shadow_mem_row4 = shadow_mem[4];
wire [255:0] shadow_mem_row5 = shadow_mem[5];
wire [255:0] shadow_mem_row6 = shadow_mem[6];
wire [255:0] shadow_mem_row7 = shadow_mem[7];
wire [255:0] shadow_mem_row8 = shadow_mem[8];
wire [255:0] shadow_mem_row9 = shadow_mem[9];
wire [255:0] shadow_mem_row10 = shadow_mem[10];
wire [255:0] shadow_mem_row11 = shadow_mem[11];
wire [255:0] shadow_mem_row12 = shadow_mem[12];
wire [255:0] shadow_mem_row13 = shadow_mem[13];
wire [255:0] shadow_mem_row14 = shadow_mem[14];
wire [255:0] shadow_mem_row15 = shadow_mem[15];
wire [255:0] shadow_mem_row16 = shadow_mem[16];
wire [255:0] shadow_mem_row17 = shadow_mem[17];
wire [255:0] shadow_mem_row18 = shadow_mem[18];
wire [255:0] shadow_mem_row19 = shadow_mem[19];
wire [255:0] shadow_mem_row20 = shadow_mem[20];
wire [255:0] shadow_mem_row21 = shadow_mem[21];
wire [255:0] shadow_mem_row22 = shadow_mem[22];
wire [255:0] shadow_mem_row23 = shadow_mem[23];
wire [255:0] shadow_mem_row24 = shadow_mem[24];
wire [255:0] shadow_mem_row25 = shadow_mem[25];
wire [255:0] shadow_mem_row26 = shadow_mem[26];
wire [255:0] shadow_mem_row27 = shadow_mem[27];
wire [255:0] shadow_mem_row28 = shadow_mem[28];
wire [255:0] shadow_mem_row29 = shadow_mem[29];
wire [255:0] shadow_mem_row30 = shadow_mem[30];
wire [255:0] shadow_mem_row31 = shadow_mem[31];
wire [255:0] shadow_mem_row32 = shadow_mem[32];
wire [255:0] shadow_mem_row33 = shadow_mem[33];
wire [255:0] shadow_mem_row34 = shadow_mem[34];
wire [255:0] shadow_mem_row35 = shadow_mem[35];
wire [255:0] shadow_mem_row36 = shadow_mem[36];
wire [255:0] shadow_mem_row37 = shadow_mem[37];
wire [255:0] shadow_mem_row38 = shadow_mem[38];
wire [255:0] shadow_mem_row39 = shadow_mem[39];
wire [255:0] shadow_mem_row40 = shadow_mem[40];
wire [255:0] shadow_mem_row41 = shadow_mem[41];
wire [255:0] shadow_mem_row42 = shadow_mem[42];
wire [255:0] shadow_mem_row43 = shadow_mem[43];
wire [255:0] shadow_mem_row44 = shadow_mem[44];
wire [255:0] shadow_mem_row45 = shadow_mem[45];
wire [255:0] shadow_mem_row46 = shadow_mem[46];
wire [255:0] shadow_mem_row47 = shadow_mem[47];
wire [255:0] shadow_mem_row48 = shadow_mem[48];
wire [255:0] shadow_mem_row49 = shadow_mem[49];
wire [255:0] shadow_mem_row50 = shadow_mem[50];
wire [255:0] shadow_mem_row51 = shadow_mem[51];
wire [255:0] shadow_mem_row52 = shadow_mem[52];
wire [255:0] shadow_mem_row53 = shadow_mem[53];
wire [255:0] shadow_mem_row54 = shadow_mem[54];
wire [255:0] shadow_mem_row55 = shadow_mem[55];
wire [255:0] shadow_mem_row56 = shadow_mem[56];
wire [255:0] shadow_mem_row57 = shadow_mem[57];
wire [255:0] shadow_mem_row58 = shadow_mem[58];
wire [255:0] shadow_mem_row59 = shadow_mem[59];
wire [255:0] shadow_mem_row60 = shadow_mem[60];
wire [255:0] shadow_mem_row61 = shadow_mem[61];
wire [255:0] shadow_mem_row62 = shadow_mem[62];
wire [255:0] shadow_mem_row63 = shadow_mem[63];
wire [255:0] shadow_mem_row64 = shadow_mem[64];
wire [255:0] shadow_mem_row65 = shadow_mem[65];
wire [255:0] shadow_mem_row66 = shadow_mem[66];
wire [255:0] shadow_mem_row67 = shadow_mem[67];
wire [255:0] shadow_mem_row68 = shadow_mem[68];
wire [255:0] shadow_mem_row69 = shadow_mem[69];
wire [255:0] shadow_mem_row70 = shadow_mem[70];
wire [255:0] shadow_mem_row71 = shadow_mem[71];
wire [255:0] shadow_mem_row72 = shadow_mem[72];
wire [255:0] shadow_mem_row73 = shadow_mem[73];
wire [255:0] shadow_mem_row74 = shadow_mem[74];
wire [255:0] shadow_mem_row75 = shadow_mem[75];
wire [255:0] shadow_mem_row76 = shadow_mem[76];
wire [255:0] shadow_mem_row77 = shadow_mem[77];
wire [255:0] shadow_mem_row78 = shadow_mem[78];
wire [255:0] shadow_mem_row79 = shadow_mem[79];
wire [255:0] shadow_mem_row80 = shadow_mem[80];
wire [255:0] shadow_mem_row81 = shadow_mem[81];
wire [255:0] shadow_mem_row82 = shadow_mem[82];
wire [255:0] shadow_mem_row83 = shadow_mem[83];
wire [255:0] shadow_mem_row84 = shadow_mem[84];
wire [255:0] shadow_mem_row85 = shadow_mem[85];
wire [255:0] shadow_mem_row86 = shadow_mem[86];
wire [255:0] shadow_mem_row87 = shadow_mem[87];
wire [255:0] shadow_mem_row88 = shadow_mem[88];
wire [255:0] shadow_mem_row89 = shadow_mem[89];
wire [255:0] shadow_mem_row90 = shadow_mem[90];
wire [255:0] shadow_mem_row91 = shadow_mem[91];
wire [255:0] shadow_mem_row92 = shadow_mem[92];
wire [255:0] shadow_mem_row93 = shadow_mem[93];
wire [255:0] shadow_mem_row94 = shadow_mem[94];
wire [255:0] shadow_mem_row95 = shadow_mem[95];
wire [255:0] shadow_mem_row96 = shadow_mem[96];
wire [255:0] shadow_mem_row97 = shadow_mem[97];
wire [255:0] shadow_mem_row98 = shadow_mem[98];
wire [255:0] shadow_mem_row99 = shadow_mem[99];
wire [255:0] shadow_mem_row100 = shadow_mem[100];
wire [255:0] shadow_mem_row101 = shadow_mem[101];
wire [255:0] shadow_mem_row102 = shadow_mem[102];
wire [255:0] shadow_mem_row103 = shadow_mem[103];
wire [255:0] shadow_mem_row104 = shadow_mem[104];
wire [255:0] shadow_mem_row105 = shadow_mem[105];
wire [255:0] shadow_mem_row106 = shadow_mem[106];
wire [255:0] shadow_mem_row107 = shadow_mem[107];
wire [255:0] shadow_mem_row108 = shadow_mem[108];
wire [255:0] shadow_mem_row109 = shadow_mem[109];
wire [255:0] shadow_mem_row110 = shadow_mem[110];
wire [255:0] shadow_mem_row111 = shadow_mem[111];
wire [255:0] shadow_mem_row112 = shadow_mem[112];
wire [255:0] shadow_mem_row113 = shadow_mem[113];
wire [255:0] shadow_mem_row114 = shadow_mem[114];
wire [255:0] shadow_mem_row115 = shadow_mem[115];
wire [255:0] shadow_mem_row116 = shadow_mem[116];
wire [255:0] shadow_mem_row117 = shadow_mem[117];
wire [255:0] shadow_mem_row118 = shadow_mem[118];
wire [255:0] shadow_mem_row119 = shadow_mem[119];
wire [255:0] shadow_mem_row120 = shadow_mem[120];
wire [255:0] shadow_mem_row121 = shadow_mem[121];
wire [255:0] shadow_mem_row122 = shadow_mem[122];
wire [255:0] shadow_mem_row123 = shadow_mem[123];
wire [255:0] shadow_mem_row124 = shadow_mem[124];
wire [255:0] shadow_mem_row125 = shadow_mem[125];
wire [255:0] shadow_mem_row126 = shadow_mem[126];
wire [255:0] shadow_mem_row127 = shadow_mem[127];
`endif

task init_mem_val;
  input [6:0] row;
  input [255:0] data;
  begin
    shadow_mem[row] = data;
    shadow_written[row] = 1'b1;
  end
endtask

task init_mem_commit;
integer row;
begin

// initializing RAMPDP_128X256_GL_M1_D2
for (row = 0; row < 128; row = row + 1)
 if (shadow_written[row]) r_nv_ram_rws_128x256.ram_Inst_128X256.mem_write(row - 0, shadow_mem[row][255:0]);

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
   input  [255:0] di;
   reg    [255:0] d;
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

function [255:0] probe_mem_val;
input [6:0] row;
reg [255:0] data;
begin

// probing RAMPDP_128X256_GL_M1_D2
 if (row >=  0 &&  row < 128) data[255:0] = r_nv_ram_rws_128x256.ram_Inst_128X256.mem_read(row - 0);
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
    for (i = 0; i < 128; i = i + 1)
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
 for (i = 0; i < 128; i = i + 1)
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
 for (i = 0; i < 128; i = i + 1)
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

task init_mem_random;
reg [255:0] random_num;
integer i;
begin
 for (i = 0; i < 128; i = i + 1)
   begin
     random_num = {rf0.rollpli(0,32'hffffffff),rf1.rollpli(0,32'hffffffff),rf2.rollpli(0,32'hffffffff),rf3.rollpli(0,32'hffffffff),rf4.rollpli(0,32'hffffffff),rf5.rollpli(0,32'hffffffff),rf6.rollpli(0,32'hffffffff),rf7.rollpli(0,32'hffffffff)};
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
  random_num = rflip.rollpli(0, 32768);
  row = random_num / 256;
  bitnum = random_num % 256;
  target_flip(row, bitnum);
end
endtask

task target_flip;
input [6:0] row;
input [255:0] bitnum;
reg [255:0] data;
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

