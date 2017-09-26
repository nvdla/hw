// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rws_256x7.v

`timescale 1ns / 10ps
module nv_ram_rws_256x7 (
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
input  [7:0]    ra;
input           re;
output [6:0]    dout;
input  [7:0]    wa;
input           we;
input  [6:0]    di;
input  [31:0]   pwrbus_ram_pd;



// This wrapper consists of :  1 Ram cells: RAMDP_256X7_GL_M2_E2 ;  

//Wires for Misc Ports 
wire  DFT_clamp;

//Wires for Mbist Ports 
wire [7:0] mbist_Wa_w0;
wire [1:0] mbist_Di_w0;
wire  mbist_we_w0;
wire [7:0] mbist_Ra_r0;

// verilint 528 off - Variable set but not used
wire [6:0] mbist_Do_r0_int_net;
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
wire [1:0] svop;

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
wire pre_mbist_Wa_w0_7;
NV_BLKBOX_SRC0_X testInst_mbist_Wa_w0_7 (.Y(pre_mbist_Wa_w0_7));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Wa_w0_7 (.Z(mbist_Wa_w0[7]), .A1(pre_mbist_Wa_w0_7), .A2(DFT_clamp) );
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
wire pre_mbist_Ra_r0_7;
NV_BLKBOX_SRC0_X testInst_mbist_Ra_r0_7 (.Y(pre_mbist_Ra_r0_7));
AN2D4PO4 UJ_DFTQUALIFIER_mbist_Ra_r0_7 (.Z(mbist_Ra_r0[7]), .A1(pre_mbist_Ra_r0_7), .A2(DFT_clamp) );
NV_BLKBOX_SINK testInst_mbist_Do_r0_0 (.A(mbist_Do_r0_int_net[0]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_1 (.A(mbist_Do_r0_int_net[1]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_2 (.A(mbist_Do_r0_int_net[2]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_3 (.A(mbist_Do_r0_int_net[3]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_4 (.A(mbist_Do_r0_int_net[4]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_5 (.A(mbist_Do_r0_int_net[5]));
NV_BLKBOX_SINK testInst_mbist_Do_r0_6 (.A(mbist_Do_r0_int_net[6]));
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

// Declare the wires for test signals

// Instantiating the internal logic module now
// verilint 402 off - inferred Reset must be a module port
nv_ram_rws_256x7_logic #(FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) r_nv_ram_rws_256x7 (
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
task arrangement (output integer arrangment_string[6:0]);
  begin
    arrangment_string[0] = 0  ;     
    arrangment_string[1] = 1  ;     
    arrangment_string[2] = 2  ;     
    arrangment_string[3] = 3  ;     
    arrangment_string[4] = 4  ;     
    arrangment_string[5] = 5  ;     
    arrangment_string[6] = 6  ;     
  end
endtask
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS

`ifndef MEM_REG_NAME 
 `define MEM_REG_NAME MX.mem
`endif

// Bit vector indicating which shadow addresses have been written
reg [255:0] shadow_written = 'b0;

// Shadow ram array used to store initialization values
reg [6:0] shadow_mem [255:0];


`ifdef NV_RAM_EXPAND_ARRAY
wire [6:0] shadow_mem_row0 = shadow_mem[0];
wire [6:0] shadow_mem_row1 = shadow_mem[1];
wire [6:0] shadow_mem_row2 = shadow_mem[2];
wire [6:0] shadow_mem_row3 = shadow_mem[3];
wire [6:0] shadow_mem_row4 = shadow_mem[4];
wire [6:0] shadow_mem_row5 = shadow_mem[5];
wire [6:0] shadow_mem_row6 = shadow_mem[6];
wire [6:0] shadow_mem_row7 = shadow_mem[7];
wire [6:0] shadow_mem_row8 = shadow_mem[8];
wire [6:0] shadow_mem_row9 = shadow_mem[9];
wire [6:0] shadow_mem_row10 = shadow_mem[10];
wire [6:0] shadow_mem_row11 = shadow_mem[11];
wire [6:0] shadow_mem_row12 = shadow_mem[12];
wire [6:0] shadow_mem_row13 = shadow_mem[13];
wire [6:0] shadow_mem_row14 = shadow_mem[14];
wire [6:0] shadow_mem_row15 = shadow_mem[15];
wire [6:0] shadow_mem_row16 = shadow_mem[16];
wire [6:0] shadow_mem_row17 = shadow_mem[17];
wire [6:0] shadow_mem_row18 = shadow_mem[18];
wire [6:0] shadow_mem_row19 = shadow_mem[19];
wire [6:0] shadow_mem_row20 = shadow_mem[20];
wire [6:0] shadow_mem_row21 = shadow_mem[21];
wire [6:0] shadow_mem_row22 = shadow_mem[22];
wire [6:0] shadow_mem_row23 = shadow_mem[23];
wire [6:0] shadow_mem_row24 = shadow_mem[24];
wire [6:0] shadow_mem_row25 = shadow_mem[25];
wire [6:0] shadow_mem_row26 = shadow_mem[26];
wire [6:0] shadow_mem_row27 = shadow_mem[27];
wire [6:0] shadow_mem_row28 = shadow_mem[28];
wire [6:0] shadow_mem_row29 = shadow_mem[29];
wire [6:0] shadow_mem_row30 = shadow_mem[30];
wire [6:0] shadow_mem_row31 = shadow_mem[31];
wire [6:0] shadow_mem_row32 = shadow_mem[32];
wire [6:0] shadow_mem_row33 = shadow_mem[33];
wire [6:0] shadow_mem_row34 = shadow_mem[34];
wire [6:0] shadow_mem_row35 = shadow_mem[35];
wire [6:0] shadow_mem_row36 = shadow_mem[36];
wire [6:0] shadow_mem_row37 = shadow_mem[37];
wire [6:0] shadow_mem_row38 = shadow_mem[38];
wire [6:0] shadow_mem_row39 = shadow_mem[39];
wire [6:0] shadow_mem_row40 = shadow_mem[40];
wire [6:0] shadow_mem_row41 = shadow_mem[41];
wire [6:0] shadow_mem_row42 = shadow_mem[42];
wire [6:0] shadow_mem_row43 = shadow_mem[43];
wire [6:0] shadow_mem_row44 = shadow_mem[44];
wire [6:0] shadow_mem_row45 = shadow_mem[45];
wire [6:0] shadow_mem_row46 = shadow_mem[46];
wire [6:0] shadow_mem_row47 = shadow_mem[47];
wire [6:0] shadow_mem_row48 = shadow_mem[48];
wire [6:0] shadow_mem_row49 = shadow_mem[49];
wire [6:0] shadow_mem_row50 = shadow_mem[50];
wire [6:0] shadow_mem_row51 = shadow_mem[51];
wire [6:0] shadow_mem_row52 = shadow_mem[52];
wire [6:0] shadow_mem_row53 = shadow_mem[53];
wire [6:0] shadow_mem_row54 = shadow_mem[54];
wire [6:0] shadow_mem_row55 = shadow_mem[55];
wire [6:0] shadow_mem_row56 = shadow_mem[56];
wire [6:0] shadow_mem_row57 = shadow_mem[57];
wire [6:0] shadow_mem_row58 = shadow_mem[58];
wire [6:0] shadow_mem_row59 = shadow_mem[59];
wire [6:0] shadow_mem_row60 = shadow_mem[60];
wire [6:0] shadow_mem_row61 = shadow_mem[61];
wire [6:0] shadow_mem_row62 = shadow_mem[62];
wire [6:0] shadow_mem_row63 = shadow_mem[63];
wire [6:0] shadow_mem_row64 = shadow_mem[64];
wire [6:0] shadow_mem_row65 = shadow_mem[65];
wire [6:0] shadow_mem_row66 = shadow_mem[66];
wire [6:0] shadow_mem_row67 = shadow_mem[67];
wire [6:0] shadow_mem_row68 = shadow_mem[68];
wire [6:0] shadow_mem_row69 = shadow_mem[69];
wire [6:0] shadow_mem_row70 = shadow_mem[70];
wire [6:0] shadow_mem_row71 = shadow_mem[71];
wire [6:0] shadow_mem_row72 = shadow_mem[72];
wire [6:0] shadow_mem_row73 = shadow_mem[73];
wire [6:0] shadow_mem_row74 = shadow_mem[74];
wire [6:0] shadow_mem_row75 = shadow_mem[75];
wire [6:0] shadow_mem_row76 = shadow_mem[76];
wire [6:0] shadow_mem_row77 = shadow_mem[77];
wire [6:0] shadow_mem_row78 = shadow_mem[78];
wire [6:0] shadow_mem_row79 = shadow_mem[79];
wire [6:0] shadow_mem_row80 = shadow_mem[80];
wire [6:0] shadow_mem_row81 = shadow_mem[81];
wire [6:0] shadow_mem_row82 = shadow_mem[82];
wire [6:0] shadow_mem_row83 = shadow_mem[83];
wire [6:0] shadow_mem_row84 = shadow_mem[84];
wire [6:0] shadow_mem_row85 = shadow_mem[85];
wire [6:0] shadow_mem_row86 = shadow_mem[86];
wire [6:0] shadow_mem_row87 = shadow_mem[87];
wire [6:0] shadow_mem_row88 = shadow_mem[88];
wire [6:0] shadow_mem_row89 = shadow_mem[89];
wire [6:0] shadow_mem_row90 = shadow_mem[90];
wire [6:0] shadow_mem_row91 = shadow_mem[91];
wire [6:0] shadow_mem_row92 = shadow_mem[92];
wire [6:0] shadow_mem_row93 = shadow_mem[93];
wire [6:0] shadow_mem_row94 = shadow_mem[94];
wire [6:0] shadow_mem_row95 = shadow_mem[95];
wire [6:0] shadow_mem_row96 = shadow_mem[96];
wire [6:0] shadow_mem_row97 = shadow_mem[97];
wire [6:0] shadow_mem_row98 = shadow_mem[98];
wire [6:0] shadow_mem_row99 = shadow_mem[99];
wire [6:0] shadow_mem_row100 = shadow_mem[100];
wire [6:0] shadow_mem_row101 = shadow_mem[101];
wire [6:0] shadow_mem_row102 = shadow_mem[102];
wire [6:0] shadow_mem_row103 = shadow_mem[103];
wire [6:0] shadow_mem_row104 = shadow_mem[104];
wire [6:0] shadow_mem_row105 = shadow_mem[105];
wire [6:0] shadow_mem_row106 = shadow_mem[106];
wire [6:0] shadow_mem_row107 = shadow_mem[107];
wire [6:0] shadow_mem_row108 = shadow_mem[108];
wire [6:0] shadow_mem_row109 = shadow_mem[109];
wire [6:0] shadow_mem_row110 = shadow_mem[110];
wire [6:0] shadow_mem_row111 = shadow_mem[111];
wire [6:0] shadow_mem_row112 = shadow_mem[112];
wire [6:0] shadow_mem_row113 = shadow_mem[113];
wire [6:0] shadow_mem_row114 = shadow_mem[114];
wire [6:0] shadow_mem_row115 = shadow_mem[115];
wire [6:0] shadow_mem_row116 = shadow_mem[116];
wire [6:0] shadow_mem_row117 = shadow_mem[117];
wire [6:0] shadow_mem_row118 = shadow_mem[118];
wire [6:0] shadow_mem_row119 = shadow_mem[119];
wire [6:0] shadow_mem_row120 = shadow_mem[120];
wire [6:0] shadow_mem_row121 = shadow_mem[121];
wire [6:0] shadow_mem_row122 = shadow_mem[122];
wire [6:0] shadow_mem_row123 = shadow_mem[123];
wire [6:0] shadow_mem_row124 = shadow_mem[124];
wire [6:0] shadow_mem_row125 = shadow_mem[125];
wire [6:0] shadow_mem_row126 = shadow_mem[126];
wire [6:0] shadow_mem_row127 = shadow_mem[127];
wire [6:0] shadow_mem_row128 = shadow_mem[128];
wire [6:0] shadow_mem_row129 = shadow_mem[129];
wire [6:0] shadow_mem_row130 = shadow_mem[130];
wire [6:0] shadow_mem_row131 = shadow_mem[131];
wire [6:0] shadow_mem_row132 = shadow_mem[132];
wire [6:0] shadow_mem_row133 = shadow_mem[133];
wire [6:0] shadow_mem_row134 = shadow_mem[134];
wire [6:0] shadow_mem_row135 = shadow_mem[135];
wire [6:0] shadow_mem_row136 = shadow_mem[136];
wire [6:0] shadow_mem_row137 = shadow_mem[137];
wire [6:0] shadow_mem_row138 = shadow_mem[138];
wire [6:0] shadow_mem_row139 = shadow_mem[139];
wire [6:0] shadow_mem_row140 = shadow_mem[140];
wire [6:0] shadow_mem_row141 = shadow_mem[141];
wire [6:0] shadow_mem_row142 = shadow_mem[142];
wire [6:0] shadow_mem_row143 = shadow_mem[143];
wire [6:0] shadow_mem_row144 = shadow_mem[144];
wire [6:0] shadow_mem_row145 = shadow_mem[145];
wire [6:0] shadow_mem_row146 = shadow_mem[146];
wire [6:0] shadow_mem_row147 = shadow_mem[147];
wire [6:0] shadow_mem_row148 = shadow_mem[148];
wire [6:0] shadow_mem_row149 = shadow_mem[149];
wire [6:0] shadow_mem_row150 = shadow_mem[150];
wire [6:0] shadow_mem_row151 = shadow_mem[151];
wire [6:0] shadow_mem_row152 = shadow_mem[152];
wire [6:0] shadow_mem_row153 = shadow_mem[153];
wire [6:0] shadow_mem_row154 = shadow_mem[154];
wire [6:0] shadow_mem_row155 = shadow_mem[155];
wire [6:0] shadow_mem_row156 = shadow_mem[156];
wire [6:0] shadow_mem_row157 = shadow_mem[157];
wire [6:0] shadow_mem_row158 = shadow_mem[158];
wire [6:0] shadow_mem_row159 = shadow_mem[159];
wire [6:0] shadow_mem_row160 = shadow_mem[160];
wire [6:0] shadow_mem_row161 = shadow_mem[161];
wire [6:0] shadow_mem_row162 = shadow_mem[162];
wire [6:0] shadow_mem_row163 = shadow_mem[163];
wire [6:0] shadow_mem_row164 = shadow_mem[164];
wire [6:0] shadow_mem_row165 = shadow_mem[165];
wire [6:0] shadow_mem_row166 = shadow_mem[166];
wire [6:0] shadow_mem_row167 = shadow_mem[167];
wire [6:0] shadow_mem_row168 = shadow_mem[168];
wire [6:0] shadow_mem_row169 = shadow_mem[169];
wire [6:0] shadow_mem_row170 = shadow_mem[170];
wire [6:0] shadow_mem_row171 = shadow_mem[171];
wire [6:0] shadow_mem_row172 = shadow_mem[172];
wire [6:0] shadow_mem_row173 = shadow_mem[173];
wire [6:0] shadow_mem_row174 = shadow_mem[174];
wire [6:0] shadow_mem_row175 = shadow_mem[175];
wire [6:0] shadow_mem_row176 = shadow_mem[176];
wire [6:0] shadow_mem_row177 = shadow_mem[177];
wire [6:0] shadow_mem_row178 = shadow_mem[178];
wire [6:0] shadow_mem_row179 = shadow_mem[179];
wire [6:0] shadow_mem_row180 = shadow_mem[180];
wire [6:0] shadow_mem_row181 = shadow_mem[181];
wire [6:0] shadow_mem_row182 = shadow_mem[182];
wire [6:0] shadow_mem_row183 = shadow_mem[183];
wire [6:0] shadow_mem_row184 = shadow_mem[184];
wire [6:0] shadow_mem_row185 = shadow_mem[185];
wire [6:0] shadow_mem_row186 = shadow_mem[186];
wire [6:0] shadow_mem_row187 = shadow_mem[187];
wire [6:0] shadow_mem_row188 = shadow_mem[188];
wire [6:0] shadow_mem_row189 = shadow_mem[189];
wire [6:0] shadow_mem_row190 = shadow_mem[190];
wire [6:0] shadow_mem_row191 = shadow_mem[191];
wire [6:0] shadow_mem_row192 = shadow_mem[192];
wire [6:0] shadow_mem_row193 = shadow_mem[193];
wire [6:0] shadow_mem_row194 = shadow_mem[194];
wire [6:0] shadow_mem_row195 = shadow_mem[195];
wire [6:0] shadow_mem_row196 = shadow_mem[196];
wire [6:0] shadow_mem_row197 = shadow_mem[197];
wire [6:0] shadow_mem_row198 = shadow_mem[198];
wire [6:0] shadow_mem_row199 = shadow_mem[199];
wire [6:0] shadow_mem_row200 = shadow_mem[200];
wire [6:0] shadow_mem_row201 = shadow_mem[201];
wire [6:0] shadow_mem_row202 = shadow_mem[202];
wire [6:0] shadow_mem_row203 = shadow_mem[203];
wire [6:0] shadow_mem_row204 = shadow_mem[204];
wire [6:0] shadow_mem_row205 = shadow_mem[205];
wire [6:0] shadow_mem_row206 = shadow_mem[206];
wire [6:0] shadow_mem_row207 = shadow_mem[207];
wire [6:0] shadow_mem_row208 = shadow_mem[208];
wire [6:0] shadow_mem_row209 = shadow_mem[209];
wire [6:0] shadow_mem_row210 = shadow_mem[210];
wire [6:0] shadow_mem_row211 = shadow_mem[211];
wire [6:0] shadow_mem_row212 = shadow_mem[212];
wire [6:0] shadow_mem_row213 = shadow_mem[213];
wire [6:0] shadow_mem_row214 = shadow_mem[214];
wire [6:0] shadow_mem_row215 = shadow_mem[215];
wire [6:0] shadow_mem_row216 = shadow_mem[216];
wire [6:0] shadow_mem_row217 = shadow_mem[217];
wire [6:0] shadow_mem_row218 = shadow_mem[218];
wire [6:0] shadow_mem_row219 = shadow_mem[219];
wire [6:0] shadow_mem_row220 = shadow_mem[220];
wire [6:0] shadow_mem_row221 = shadow_mem[221];
wire [6:0] shadow_mem_row222 = shadow_mem[222];
wire [6:0] shadow_mem_row223 = shadow_mem[223];
wire [6:0] shadow_mem_row224 = shadow_mem[224];
wire [6:0] shadow_mem_row225 = shadow_mem[225];
wire [6:0] shadow_mem_row226 = shadow_mem[226];
wire [6:0] shadow_mem_row227 = shadow_mem[227];
wire [6:0] shadow_mem_row228 = shadow_mem[228];
wire [6:0] shadow_mem_row229 = shadow_mem[229];
wire [6:0] shadow_mem_row230 = shadow_mem[230];
wire [6:0] shadow_mem_row231 = shadow_mem[231];
wire [6:0] shadow_mem_row232 = shadow_mem[232];
wire [6:0] shadow_mem_row233 = shadow_mem[233];
wire [6:0] shadow_mem_row234 = shadow_mem[234];
wire [6:0] shadow_mem_row235 = shadow_mem[235];
wire [6:0] shadow_mem_row236 = shadow_mem[236];
wire [6:0] shadow_mem_row237 = shadow_mem[237];
wire [6:0] shadow_mem_row238 = shadow_mem[238];
wire [6:0] shadow_mem_row239 = shadow_mem[239];
wire [6:0] shadow_mem_row240 = shadow_mem[240];
wire [6:0] shadow_mem_row241 = shadow_mem[241];
wire [6:0] shadow_mem_row242 = shadow_mem[242];
wire [6:0] shadow_mem_row243 = shadow_mem[243];
wire [6:0] shadow_mem_row244 = shadow_mem[244];
wire [6:0] shadow_mem_row245 = shadow_mem[245];
wire [6:0] shadow_mem_row246 = shadow_mem[246];
wire [6:0] shadow_mem_row247 = shadow_mem[247];
wire [6:0] shadow_mem_row248 = shadow_mem[248];
wire [6:0] shadow_mem_row249 = shadow_mem[249];
wire [6:0] shadow_mem_row250 = shadow_mem[250];
wire [6:0] shadow_mem_row251 = shadow_mem[251];
wire [6:0] shadow_mem_row252 = shadow_mem[252];
wire [6:0] shadow_mem_row253 = shadow_mem[253];
wire [6:0] shadow_mem_row254 = shadow_mem[254];
wire [6:0] shadow_mem_row255 = shadow_mem[255];
`endif

task init_mem_val;
  input [7:0] row;
  input [6:0] data;
  begin
    shadow_mem[row] = data;
    shadow_written[row] = 1'b1;
  end
endtask

task init_mem_commit;
integer row;
begin

// initializing RAMDP_256X7_GL_M2_E2
for (row = 0; row < 256; row = row + 1)
 if (shadow_written[row]) r_nv_ram_rws_256x7.ram_Inst_256X7.mem_write(row - 0, shadow_mem[row][6:0]);

shadow_written = 'b0;
end
endtask
`endif
`endif
`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS
task do_write; //(wa, we, di);
   input  [7:0] wa;
   input   we;
   input  [6:0] di;
   reg    [6:0] d;
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

function [6:0] probe_mem_val;
input [7:0] row;
reg [6:0] data;
begin

// probing RAMDP_256X7_GL_M2_E2
 if (row >=  0 &&  row < 256) data[6:0] = r_nv_ram_rws_256x7.ram_Inst_256X7.mem_read(row - 0);
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
    for (i = 0; i < 256; i = i + 1)
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
 for (i = 0; i < 256; i = i + 1)
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
 for (i = 0; i < 256; i = i + 1)
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

task init_mem_random;
reg [6:0] random_num;
integer i;
begin
 for (i = 0; i < 256; i = i + 1)
   begin
     random_num = {rf0.rollpli(0,32'hffffffff)};
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
  random_num = rflip.rollpli(0, 1792);
  row = random_num / 7;
  bitnum = random_num % 7;
  target_flip(row, bitnum);
end
endtask

task target_flip;
input [7:0] row;
input [6:0] bitnum;
reg [6:0] data;
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

