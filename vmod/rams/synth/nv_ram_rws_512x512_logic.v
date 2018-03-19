// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rws_512x512_logic.v

`ifdef _SIMULATE_X_VH_
`else

`ifndef SYNTHESIS
`define tick_x_or_0  1'bx
`define tick_x_or_1  1'bx
`else
`define tick_x_or_0  1'b0
`define tick_x_or_1  1'b1
`endif

`endif


// verilint 549 off - async flop inferred
// verilint 446 off - reading from output port
// verilint 389 off - multiple clocks in module
// verilint 287 off - unconnected ports
// verilint 401 off - Clock is not an input to the module (we use gated clk)
// verilint 257 off - delays ignored by synth tools
// verilint 240 off - Unused input
// verilint 542 off - enabled flop inferred
// verilint 210 off - too few module ports
// verilint 280 off - delay in non-blocking assignment
// verilint 332 off - not all possible cases covered, but default case exists
// verilint 390 off - multiple resets in this module
// verilint 396 off - flop w/o async reset
// verilint 69 off - case without default, all cases covered
// verilint 34 off - unused macro
// verilint 528 off - variable set but not used
// verilint 530 off - flop inferred
// verilint 550 off - mux inferred
// verilint 113 off - multiple drivers to flop
// leda ELB072 off

`timescale 1ns / 10ps

`define TSMC_CM_UNIT_DELAY
`define TSMC_CM_NO_WARNING


module nv_ram_rws_512x512_logic (
               SI,
               SO_int_net,
               ary_atpg_ctl,
               ary_read_inh,
               clk,
               debug_mode,
               di,
               dout,
               iddq_mode,
               jtag_readonly_mode,
               mbist_Di_w0,
               mbist_Do_r0_int_net,
               mbist_Ra_r0,
               mbist_Wa_w0,
               mbist_ce_r0_0_0,
               mbist_ce_r0_0_144,
               mbist_ce_r0_0_216,
               mbist_ce_r0_0_288,
               mbist_ce_r0_0_360,
               mbist_ce_r0_0_432,
               mbist_ce_r0_0_504,
               mbist_ce_r0_0_72,
               mbist_en_sync,
               mbist_ramaccess_rst_,
               mbist_we_w0_0_0,
               mbist_we_w0_0_144,
               mbist_we_w0_0_216,
               mbist_we_w0_0_288,
               mbist_we_w0_0_360,
               mbist_we_w0_0_432,
               mbist_we_w0_0_504,
               mbist_we_w0_0_72,
               pwrbus_ram_pd,
               ra,
               re,
               scan_en,
               scan_ramtms,
               shiftDR,
               svop,
               updateDR,
               wa,
               we,
               write_inh
        );
parameter FORCE_CONTENTION_ASSERTION_RESET_ACTIVE=1'b0;

// port list for submodule
input           SI;
output          SO_int_net;
input           ary_atpg_ctl;
input           ary_read_inh;
input           clk;
input           debug_mode;
input  [511:0]  di;
output [511:0]  dout;
input           iddq_mode;
input           jtag_readonly_mode;
input  [1:0]    mbist_Di_w0;
output [511:0]  mbist_Do_r0_int_net;
input  [8:0]    mbist_Ra_r0;
input  [8:0]    mbist_Wa_w0;
input           mbist_ce_r0_0_0;
input           mbist_ce_r0_0_144;
input           mbist_ce_r0_0_216;
input           mbist_ce_r0_0_288;
input           mbist_ce_r0_0_360;
input           mbist_ce_r0_0_432;
input           mbist_ce_r0_0_504;
input           mbist_ce_r0_0_72;
input           mbist_en_sync;
input           mbist_ramaccess_rst_;
input           mbist_we_w0_0_0;
input           mbist_we_w0_0_144;
input           mbist_we_w0_0_216;
input           mbist_we_w0_0_288;
input           mbist_we_w0_0_360;
input           mbist_we_w0_0_432;
input           mbist_we_w0_0_504;
input           mbist_we_w0_0_72;
input  [31:0]   pwrbus_ram_pd;
input  [8:0]    ra;
input           re;
input           scan_en;
input           scan_ramtms;
input           shiftDR;
input  [7:0]    svop;
input           updateDR;
input  [8:0]    wa;
input           we;
input           write_inh;


wire [7:0] sleep_en = pwrbus_ram_pd[7:0];
wire  ret_en = pwrbus_ram_pd[8];
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif 
// DFT ATPG signals
wire ram_bypass = (scan_ramtms | ary_read_inh);
wire la_bist_clkw0;
wire la_bist_clkr0;
assign la_bist_clkr0 = la_bist_clkw0;

wire updateDR_sync;
sync2d_c_pp updateDR_synchronizer (.d(updateDR), .clk(la_bist_clkw0), .q(updateDR_sync), .clr_(mbist_ramaccess_rst_));

reg updateDR_sync_1p;
always @(posedge la_bist_clkr0 or negedge mbist_ramaccess_rst_) begin
    if (!mbist_ramaccess_rst_)
        updateDR_sync_1p <= 1'b0;
    else
        updateDR_sync_1p <= updateDR_sync;
end

wire debug_mode_sync;

wire dft_rst_gated_clk;
CKLNQD12PO4  CLK_GATE_clk (.Q(dft_rst_gated_clk), .CP(clk), .E(mbist_ramaccess_rst_), .TE(scan_en));
sync2d_c_pp debug_mode_synchronizer (.d(debug_mode), .clk(dft_rst_gated_clk), .q(debug_mode_sync), .clr_(mbist_ramaccess_rst_));
reg [8:0] Ra_array_reg_r0;

wire mbist_en_r;
// hardcode mbist_en_r stdcell flop to avoid x bash recoverability issue described in bug 1803479 comment #7
p_SDFCNQD1PO4 mbist_en_flop(.D(mbist_en_sync), .CP(dft_rst_gated_clk), .Q(mbist_en_r), .CDN(mbist_ramaccess_rst_));

// Declare the Data_reg signal beforehand
wire [511:0] Data_reg_r0;


 // Data out bus for read port r0 for Output Mux
wire [511:0] r0_OutputMuxDataOut;
CKLNQD12PO4  UJ_la_bist_clkw0_gate (.Q(la_bist_clkw0), .CP(clk), .E(mbist_en_r | debug_mode_sync), .TE(scan_en));

// Write enable bus
wire  we_0_0;

// Read enable bus
wire re_0_0;

// Write enable bus
wire  we_0_72;

// Read enable bus
wire re_0_72;

// Write enable bus
wire  we_0_144;

// Read enable bus
wire re_0_144;

// Write enable bus
wire  we_0_216;

// Read enable bus
wire re_0_216;

// Write enable bus
wire  we_0_288;

// Read enable bus
wire re_0_288;

// Write enable bus
wire  we_0_360;

// Read enable bus
wire re_0_360;

// Write enable bus
wire  we_0_432;

// Read enable bus
wire re_0_432;

// Write enable bus
wire  we_0_504;

// Read enable bus
wire re_0_504;
// start of predeclareNvregSignals
wire ctx_ctrl_we;
wire clk_en_core_0_0 = (re_0_0 | (|we_0_0));
wire gated_clk_core_0_0;
CKLNQD12PO4  UJ_clk_gate_core_0_0 (.Q(gated_clk_core_0_0), .CP(clk), .E(clk_en_core_0_0), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_72 = (re_0_72 | (|we_0_72));
wire gated_clk_core_0_72;
CKLNQD12PO4  UJ_clk_gate_core_0_72 (.Q(gated_clk_core_0_72), .CP(clk), .E(clk_en_core_0_72), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_144 = (re_0_144 | (|we_0_144));
wire gated_clk_core_0_144;
CKLNQD12PO4  UJ_clk_gate_core_0_144 (.Q(gated_clk_core_0_144), .CP(clk), .E(clk_en_core_0_144), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_216 = (re_0_216 | (|we_0_216));
wire gated_clk_core_0_216;
CKLNQD12PO4  UJ_clk_gate_core_0_216 (.Q(gated_clk_core_0_216), .CP(clk), .E(clk_en_core_0_216), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_288 = (re_0_288 | (|we_0_288));
wire gated_clk_core_0_288;
CKLNQD12PO4  UJ_clk_gate_core_0_288 (.Q(gated_clk_core_0_288), .CP(clk), .E(clk_en_core_0_288), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_360 = (re_0_360 | (|we_0_360));
wire gated_clk_core_0_360;
CKLNQD12PO4  UJ_clk_gate_core_0_360 (.Q(gated_clk_core_0_360), .CP(clk), .E(clk_en_core_0_360), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_432 = (re_0_432 | (|we_0_432));
wire gated_clk_core_0_432;
CKLNQD12PO4  UJ_clk_gate_core_0_432 (.Q(gated_clk_core_0_432), .CP(clk), .E(clk_en_core_0_432), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_504 = (re_0_504 | (|we_0_504));
wire gated_clk_core_0_504;
CKLNQD12PO4  UJ_clk_gate_core_0_504 (.Q(gated_clk_core_0_504), .CP(clk), .E(clk_en_core_0_504), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire shiftDR_en;

reg [511:0] pre_muxed_Di_w0;
wire [511:0] pre_muxed_Di_w0_A, pre_muxed_Di_w0_B;
wire pre_muxed_Di_w0_S;

assign pre_muxed_Di_w0_S = !debug_mode_sync;
assign pre_muxed_Di_w0_A = Data_reg_r0[511:0];
assign pre_muxed_Di_w0_B = {{4{mbist_Di_w0}}, {36{mbist_Di_w0}}, {36{mbist_Di_w0}}, {36{mbist_Di_w0}}, {36{mbist_Di_w0}}, {36{mbist_Di_w0}}, {36{mbist_Di_w0}}, {36{mbist_Di_w0}}};

always @(pre_muxed_Di_w0_S or pre_muxed_Di_w0_A or pre_muxed_Di_w0_B)
    case(pre_muxed_Di_w0_S) // synopsys infer_mux
      1'b0 : pre_muxed_Di_w0 = pre_muxed_Di_w0_A;
      1'b1 : pre_muxed_Di_w0 = pre_muxed_Di_w0_B;
      default : pre_muxed_Di_w0 = {512{`tick_x_or_0}};
    endcase

reg [511:0] muxed_Di_w0;
wire [511:0] muxed_Di_w0_A, muxed_Di_w0_B;
assign muxed_Di_w0_A = {di[511:504], di[503:432], di[431:360], di[359:288], di[287:216], di[215:144], di[143:72], di[71:0]};
assign muxed_Di_w0_B = pre_muxed_Di_w0;

wire muxed_Di_w0_S = debug_mode_sync | mbist_en_r;
always @(muxed_Di_w0_S or muxed_Di_w0_A or muxed_Di_w0_B)
    case(muxed_Di_w0_S) // synopsys infer_mux
      1'b0 : muxed_Di_w0 = muxed_Di_w0_A;
      1'b1 : muxed_Di_w0 = muxed_Di_w0_B;
      default : muxed_Di_w0 = {512{`tick_x_or_0}};
    endcase


wire posedge_updateDR_sync = updateDR_sync & !updateDR_sync_1p;

wire access_en_w = posedge_updateDR_sync;

// ATPG logic: capture for non-data regs
wire dft_capdr_w = ary_atpg_ctl;

wire [8:0] pre_Wa_reg_w0;

reg [8:0] Wa_reg_w0;
wire [8:0] Wa_reg_w0_A, Wa_reg_w0_B;
wire Wa_reg_w0_S;

assign Wa_reg_w0_S = (!debug_mode_sync);
assign Wa_reg_w0_A = pre_Wa_reg_w0;
assign Wa_reg_w0_B = mbist_Wa_w0;

always @(Wa_reg_w0_S or Wa_reg_w0_A or Wa_reg_w0_B)
case(Wa_reg_w0_S) // synopsys infer_mux
  1'b0 : Wa_reg_w0 = Wa_reg_w0_A;
  1'b1 : Wa_reg_w0 = Wa_reg_w0_B;
  default : Wa_reg_w0 = {9{`tick_x_or_0}};
endcase

reg [8:0] muxed_Wa_w0;
wire [8:0] muxed_Wa_w0_A, muxed_Wa_w0_B;
wire muxed_Wa_w0_S;

assign muxed_Wa_w0_S = debug_mode_sync | mbist_en_r;
assign muxed_Wa_w0_A = wa;
assign muxed_Wa_w0_B = Wa_reg_w0;

always @(muxed_Wa_w0_S or muxed_Wa_w0_A or muxed_Wa_w0_B)
  case(muxed_Wa_w0_S) // synopsys infer_mux
    1'b0 : muxed_Wa_w0 = muxed_Wa_w0_A;
    1'b1 : muxed_Wa_w0 = muxed_Wa_w0_B;
    default : muxed_Wa_w0 = {9{`tick_x_or_0}};
  endcase

// testInst_*reg* for address and enable capture the signals going into RAM instance input
// 4.2.3.1 of bob's doc
wire Wa_reg_SO_w0;
wire [8:0]wadr_q;
assign pre_Wa_reg_w0 = wadr_q ;
wire we_reg_SO_w0_0_0;
wire re_reg_SO_r0_0_0;
wire we_reg_SO_w0_0_72;
wire re_reg_SO_r0_0_72;
wire we_reg_SO_w0_0_144;
wire re_reg_SO_r0_0_144;
wire we_reg_SO_w0_0_216;
wire re_reg_SO_r0_0_216;
wire we_reg_SO_w0_0_288;
wire re_reg_SO_r0_0_288;
wire we_reg_SO_w0_0_360;
wire re_reg_SO_r0_0_360;
wire we_reg_SO_w0_0_432;
wire re_reg_SO_r0_0_432;
wire we_reg_SO_w0_0_504;
wire re_reg_SO_r0_0_504;

wire we_reg_w0_0_0;
wire pre_we_w0_0_0;
assign pre_we_w0_0_0 = debug_mode_sync ?
        ({1{posedge_updateDR_sync}} & we_reg_w0_0_0) :  
        {1{(mbist_en_r & mbist_we_w0_0_0)}};

reg  muxed_we_w0_0_0;
wire muxed_we_w0_0_0_A, muxed_we_w0_0_0_B;
wire muxed_we_w0_0_0_S;

assign muxed_we_w0_0_0_S = debug_mode_sync | mbist_en_r;
assign muxed_we_w0_0_0_A = we_0_0;
assign muxed_we_w0_0_0_B = pre_we_w0_0_0;

always @(muxed_we_w0_0_0_S or muxed_we_w0_0_0_A or muxed_we_w0_0_0_B)
case(muxed_we_w0_0_0_S) // synopsys infer_mux
  1'b0 : muxed_we_w0_0_0 = muxed_we_w0_0_0_A;
  1'b1 : muxed_we_w0_0_0 = muxed_we_w0_0_0_B;
  default : muxed_we_w0_0_0 = {1{`tick_x_or_0}};
endcase


wire we_0_0_q;
assign we_reg_w0_0_0 = we_0_0_q ;

wire we_reg_w0_0_72;
wire pre_we_w0_0_72;
assign pre_we_w0_0_72 = debug_mode_sync ?
        ({1{posedge_updateDR_sync}} & we_reg_w0_0_72) :  
        {1{(mbist_en_r & mbist_we_w0_0_72)}};

reg  muxed_we_w0_0_72;
wire muxed_we_w0_0_72_A, muxed_we_w0_0_72_B;
wire muxed_we_w0_0_72_S;

assign muxed_we_w0_0_72_S = debug_mode_sync | mbist_en_r;
assign muxed_we_w0_0_72_A = we_0_72;
assign muxed_we_w0_0_72_B = pre_we_w0_0_72;

always @(muxed_we_w0_0_72_S or muxed_we_w0_0_72_A or muxed_we_w0_0_72_B)
case(muxed_we_w0_0_72_S) // synopsys infer_mux
  1'b0 : muxed_we_w0_0_72 = muxed_we_w0_0_72_A;
  1'b1 : muxed_we_w0_0_72 = muxed_we_w0_0_72_B;
  default : muxed_we_w0_0_72 = {1{`tick_x_or_0}};
endcase


wire we_0_72_q;
assign we_reg_w0_0_72 = we_0_72_q ;

wire we_reg_w0_0_144;
wire pre_we_w0_0_144;
assign pre_we_w0_0_144 = debug_mode_sync ?
        ({1{posedge_updateDR_sync}} & we_reg_w0_0_144) :  
        {1{(mbist_en_r & mbist_we_w0_0_144)}};

reg  muxed_we_w0_0_144;
wire muxed_we_w0_0_144_A, muxed_we_w0_0_144_B;
wire muxed_we_w0_0_144_S;

assign muxed_we_w0_0_144_S = debug_mode_sync | mbist_en_r;
assign muxed_we_w0_0_144_A = we_0_144;
assign muxed_we_w0_0_144_B = pre_we_w0_0_144;

always @(muxed_we_w0_0_144_S or muxed_we_w0_0_144_A or muxed_we_w0_0_144_B)
case(muxed_we_w0_0_144_S) // synopsys infer_mux
  1'b0 : muxed_we_w0_0_144 = muxed_we_w0_0_144_A;
  1'b1 : muxed_we_w0_0_144 = muxed_we_w0_0_144_B;
  default : muxed_we_w0_0_144 = {1{`tick_x_or_0}};
endcase


wire we_0_144_q;
assign we_reg_w0_0_144 = we_0_144_q ;

wire we_reg_w0_0_216;
wire pre_we_w0_0_216;
assign pre_we_w0_0_216 = debug_mode_sync ?
        ({1{posedge_updateDR_sync}} & we_reg_w0_0_216) :  
        {1{(mbist_en_r & mbist_we_w0_0_216)}};

reg  muxed_we_w0_0_216;
wire muxed_we_w0_0_216_A, muxed_we_w0_0_216_B;
wire muxed_we_w0_0_216_S;

assign muxed_we_w0_0_216_S = debug_mode_sync | mbist_en_r;
assign muxed_we_w0_0_216_A = we_0_216;
assign muxed_we_w0_0_216_B = pre_we_w0_0_216;

always @(muxed_we_w0_0_216_S or muxed_we_w0_0_216_A or muxed_we_w0_0_216_B)
case(muxed_we_w0_0_216_S) // synopsys infer_mux
  1'b0 : muxed_we_w0_0_216 = muxed_we_w0_0_216_A;
  1'b1 : muxed_we_w0_0_216 = muxed_we_w0_0_216_B;
  default : muxed_we_w0_0_216 = {1{`tick_x_or_0}};
endcase


wire we_0_216_q;
assign we_reg_w0_0_216 = we_0_216_q ;

wire we_reg_w0_0_288;
wire pre_we_w0_0_288;
assign pre_we_w0_0_288 = debug_mode_sync ?
        ({1{posedge_updateDR_sync}} & we_reg_w0_0_288) :  
        {1{(mbist_en_r & mbist_we_w0_0_288)}};

reg  muxed_we_w0_0_288;
wire muxed_we_w0_0_288_A, muxed_we_w0_0_288_B;
wire muxed_we_w0_0_288_S;

assign muxed_we_w0_0_288_S = debug_mode_sync | mbist_en_r;
assign muxed_we_w0_0_288_A = we_0_288;
assign muxed_we_w0_0_288_B = pre_we_w0_0_288;

always @(muxed_we_w0_0_288_S or muxed_we_w0_0_288_A or muxed_we_w0_0_288_B)
case(muxed_we_w0_0_288_S) // synopsys infer_mux
  1'b0 : muxed_we_w0_0_288 = muxed_we_w0_0_288_A;
  1'b1 : muxed_we_w0_0_288 = muxed_we_w0_0_288_B;
  default : muxed_we_w0_0_288 = {1{`tick_x_or_0}};
endcase


wire we_0_288_q;
assign we_reg_w0_0_288 = we_0_288_q ;

wire we_reg_w0_0_360;
wire pre_we_w0_0_360;
assign pre_we_w0_0_360 = debug_mode_sync ?
        ({1{posedge_updateDR_sync}} & we_reg_w0_0_360) :  
        {1{(mbist_en_r & mbist_we_w0_0_360)}};

reg  muxed_we_w0_0_360;
wire muxed_we_w0_0_360_A, muxed_we_w0_0_360_B;
wire muxed_we_w0_0_360_S;

assign muxed_we_w0_0_360_S = debug_mode_sync | mbist_en_r;
assign muxed_we_w0_0_360_A = we_0_360;
assign muxed_we_w0_0_360_B = pre_we_w0_0_360;

always @(muxed_we_w0_0_360_S or muxed_we_w0_0_360_A or muxed_we_w0_0_360_B)
case(muxed_we_w0_0_360_S) // synopsys infer_mux
  1'b0 : muxed_we_w0_0_360 = muxed_we_w0_0_360_A;
  1'b1 : muxed_we_w0_0_360 = muxed_we_w0_0_360_B;
  default : muxed_we_w0_0_360 = {1{`tick_x_or_0}};
endcase


wire we_0_360_q;
assign we_reg_w0_0_360 = we_0_360_q ;

wire we_reg_w0_0_432;
wire pre_we_w0_0_432;
assign pre_we_w0_0_432 = debug_mode_sync ?
        ({1{posedge_updateDR_sync}} & we_reg_w0_0_432) :  
        {1{(mbist_en_r & mbist_we_w0_0_432)}};

reg  muxed_we_w0_0_432;
wire muxed_we_w0_0_432_A, muxed_we_w0_0_432_B;
wire muxed_we_w0_0_432_S;

assign muxed_we_w0_0_432_S = debug_mode_sync | mbist_en_r;
assign muxed_we_w0_0_432_A = we_0_432;
assign muxed_we_w0_0_432_B = pre_we_w0_0_432;

always @(muxed_we_w0_0_432_S or muxed_we_w0_0_432_A or muxed_we_w0_0_432_B)
case(muxed_we_w0_0_432_S) // synopsys infer_mux
  1'b0 : muxed_we_w0_0_432 = muxed_we_w0_0_432_A;
  1'b1 : muxed_we_w0_0_432 = muxed_we_w0_0_432_B;
  default : muxed_we_w0_0_432 = {1{`tick_x_or_0}};
endcase


wire we_0_432_q;
assign we_reg_w0_0_432 = we_0_432_q ;

wire we_reg_w0_0_504;
wire pre_we_w0_0_504;
assign pre_we_w0_0_504 = debug_mode_sync ?
        ({1{posedge_updateDR_sync}} & we_reg_w0_0_504) :  
        {1{(mbist_en_r & mbist_we_w0_0_504)}};

reg  muxed_we_w0_0_504;
wire muxed_we_w0_0_504_A, muxed_we_w0_0_504_B;
wire muxed_we_w0_0_504_S;

assign muxed_we_w0_0_504_S = debug_mode_sync | mbist_en_r;
assign muxed_we_w0_0_504_A = we_0_504;
assign muxed_we_w0_0_504_B = pre_we_w0_0_504;

always @(muxed_we_w0_0_504_S or muxed_we_w0_0_504_A or muxed_we_w0_0_504_B)
case(muxed_we_w0_0_504_S) // synopsys infer_mux
  1'b0 : muxed_we_w0_0_504 = muxed_we_w0_0_504_A;
  1'b1 : muxed_we_w0_0_504 = muxed_we_w0_0_504_B;
  default : muxed_we_w0_0_504 = {1{`tick_x_or_0}};
endcase


wire we_0_504_q;
assign we_reg_w0_0_504 = we_0_504_q ;

// ATPG logic: capture for non-data regs
wire dft_capdr_r = ary_atpg_ctl;


// ATPG logic: capture for non-data regs

wire [8:0] pre_Ra_reg_r0;

reg [8:0] Ra_reg_r0;
wire [8:0] Ra_reg_r0_A, Ra_reg_r0_B;
wire Ra_reg_r0_S;

assign Ra_reg_r0_S = (!debug_mode_sync);
assign Ra_reg_r0_A = pre_Ra_reg_r0;
assign Ra_reg_r0_B = mbist_Ra_r0;

always @(Ra_reg_r0_S or Ra_reg_r0_A or Ra_reg_r0_B)
case(Ra_reg_r0_S) // synopsys infer_mux
  1'b0 : Ra_reg_r0 = Ra_reg_r0_A;
  1'b1 : Ra_reg_r0 = Ra_reg_r0_B;
  default : Ra_reg_r0 = {9{`tick_x_or_0}};
endcase

wire [8:0] D_Ra_reg_r0;


reg [8:0] muxed_Ra_r0;
wire [8:0] muxed_Ra_r0_A, muxed_Ra_r0_B;
wire muxed_Ra_r0_S;

assign muxed_Ra_r0_S = debug_mode_sync | mbist_en_r;
assign muxed_Ra_r0_A = ra;
assign muxed_Ra_r0_B = Ra_reg_r0;

always @(muxed_Ra_r0_S or muxed_Ra_r0_A or muxed_Ra_r0_B)
case(muxed_Ra_r0_S) // synopsys infer_mux
  1'b0 : muxed_Ra_r0 = muxed_Ra_r0_A;
  1'b1 : muxed_Ra_r0 = muxed_Ra_r0_B;
  default : muxed_Ra_r0 = {9{`tick_x_or_0}};
endcase

assign D_Ra_reg_r0 = muxed_Ra_r0;

// verilint 110 off - Incompatible width
// verilint 630 off - Port connected to a NULL expression
// These are used for registering Ra in case of Latch arrays as well (i.e.
// used in functional path as well)
wire Ra_reg_SO_r0;
wire [8:0]radr_q;
assign pre_Ra_reg_r0 = radr_q ;

wire re_reg_r0_0_0;
wire access_en_r_0_0 = posedge_updateDR_sync & re_reg_r0_0_0;
reg access_en_r_1p_0_0;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_0 <= 1'b0;
  else 
     access_en_r_1p_0_0 <= access_en_r_0_0;

wire re_reg_r0_0_72;
wire access_en_r_0_72 = posedge_updateDR_sync & re_reg_r0_0_72;
reg access_en_r_1p_0_72;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_72 <= 1'b0;
  else 
     access_en_r_1p_0_72 <= access_en_r_0_72;

wire re_reg_r0_0_144;
wire access_en_r_0_144 = posedge_updateDR_sync & re_reg_r0_0_144;
reg access_en_r_1p_0_144;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_144 <= 1'b0;
  else 
     access_en_r_1p_0_144 <= access_en_r_0_144;

wire re_reg_r0_0_216;
wire access_en_r_0_216 = posedge_updateDR_sync & re_reg_r0_0_216;
reg access_en_r_1p_0_216;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_216 <= 1'b0;
  else 
     access_en_r_1p_0_216 <= access_en_r_0_216;

wire re_reg_r0_0_288;
wire access_en_r_0_288 = posedge_updateDR_sync & re_reg_r0_0_288;
reg access_en_r_1p_0_288;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_288 <= 1'b0;
  else 
     access_en_r_1p_0_288 <= access_en_r_0_288;

wire re_reg_r0_0_360;
wire access_en_r_0_360 = posedge_updateDR_sync & re_reg_r0_0_360;
reg access_en_r_1p_0_360;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_360 <= 1'b0;
  else 
     access_en_r_1p_0_360 <= access_en_r_0_360;

wire re_reg_r0_0_432;
wire access_en_r_0_432 = posedge_updateDR_sync & re_reg_r0_0_432;
reg access_en_r_1p_0_432;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_432 <= 1'b0;
  else 
     access_en_r_1p_0_432 <= access_en_r_0_432;

wire re_reg_r0_0_504;
wire access_en_r_0_504 = posedge_updateDR_sync & re_reg_r0_0_504;
reg access_en_r_1p_0_504;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_504 <= 1'b0;
  else 
     access_en_r_1p_0_504 <= access_en_r_0_504;

wire pre_re_r0_0_0;

assign pre_re_r0_0_0 = (debug_mode_sync) ?
    (posedge_updateDR_sync & re_reg_r0_0_0) :
    (mbist_en_r & mbist_ce_r0_0_0); 
reg  muxed_re_r0_0_0;
wire muxed_re_r0_0_0_A, muxed_re_r0_0_0_B;
wire muxed_re_r0_0_0_S;

assign muxed_re_r0_0_0_S = debug_mode_sync | mbist_en_r;
assign muxed_re_r0_0_0_A = re;
assign muxed_re_r0_0_0_B = pre_re_r0_0_0;

always @(muxed_re_r0_0_0_S or muxed_re_r0_0_0_A or muxed_re_r0_0_0_B)
case(muxed_re_r0_0_0_S) // synopsys infer_mux
  1'b0 : muxed_re_r0_0_0 = muxed_re_r0_0_0_A;
  1'b1 : muxed_re_r0_0_0 = muxed_re_r0_0_0_B;
  default : muxed_re_r0_0_0 = `tick_x_or_0;
endcase
wire re_0_0_q;
assign re_reg_r0_0_0 = re_0_0_q ;

wire pre_re_r0_0_72;

assign pre_re_r0_0_72 = (debug_mode_sync) ?
    (posedge_updateDR_sync & re_reg_r0_0_72) :
    (mbist_en_r & mbist_ce_r0_0_72); 
reg  muxed_re_r0_0_72;
wire muxed_re_r0_0_72_A, muxed_re_r0_0_72_B;
wire muxed_re_r0_0_72_S;

assign muxed_re_r0_0_72_S = debug_mode_sync | mbist_en_r;
assign muxed_re_r0_0_72_A = re;
assign muxed_re_r0_0_72_B = pre_re_r0_0_72;

always @(muxed_re_r0_0_72_S or muxed_re_r0_0_72_A or muxed_re_r0_0_72_B)
case(muxed_re_r0_0_72_S) // synopsys infer_mux
  1'b0 : muxed_re_r0_0_72 = muxed_re_r0_0_72_A;
  1'b1 : muxed_re_r0_0_72 = muxed_re_r0_0_72_B;
  default : muxed_re_r0_0_72 = `tick_x_or_0;
endcase
wire re_0_72_q;
assign re_reg_r0_0_72 = re_0_72_q ;

wire pre_re_r0_0_144;

assign pre_re_r0_0_144 = (debug_mode_sync) ?
    (posedge_updateDR_sync & re_reg_r0_0_144) :
    (mbist_en_r & mbist_ce_r0_0_144); 
reg  muxed_re_r0_0_144;
wire muxed_re_r0_0_144_A, muxed_re_r0_0_144_B;
wire muxed_re_r0_0_144_S;

assign muxed_re_r0_0_144_S = debug_mode_sync | mbist_en_r;
assign muxed_re_r0_0_144_A = re;
assign muxed_re_r0_0_144_B = pre_re_r0_0_144;

always @(muxed_re_r0_0_144_S or muxed_re_r0_0_144_A or muxed_re_r0_0_144_B)
case(muxed_re_r0_0_144_S) // synopsys infer_mux
  1'b0 : muxed_re_r0_0_144 = muxed_re_r0_0_144_A;
  1'b1 : muxed_re_r0_0_144 = muxed_re_r0_0_144_B;
  default : muxed_re_r0_0_144 = `tick_x_or_0;
endcase
wire re_0_144_q;
assign re_reg_r0_0_144 = re_0_144_q ;

wire pre_re_r0_0_216;

assign pre_re_r0_0_216 = (debug_mode_sync) ?
    (posedge_updateDR_sync & re_reg_r0_0_216) :
    (mbist_en_r & mbist_ce_r0_0_216); 
reg  muxed_re_r0_0_216;
wire muxed_re_r0_0_216_A, muxed_re_r0_0_216_B;
wire muxed_re_r0_0_216_S;

assign muxed_re_r0_0_216_S = debug_mode_sync | mbist_en_r;
assign muxed_re_r0_0_216_A = re;
assign muxed_re_r0_0_216_B = pre_re_r0_0_216;

always @(muxed_re_r0_0_216_S or muxed_re_r0_0_216_A or muxed_re_r0_0_216_B)
case(muxed_re_r0_0_216_S) // synopsys infer_mux
  1'b0 : muxed_re_r0_0_216 = muxed_re_r0_0_216_A;
  1'b1 : muxed_re_r0_0_216 = muxed_re_r0_0_216_B;
  default : muxed_re_r0_0_216 = `tick_x_or_0;
endcase
wire re_0_216_q;
assign re_reg_r0_0_216 = re_0_216_q ;

wire pre_re_r0_0_288;

assign pre_re_r0_0_288 = (debug_mode_sync) ?
    (posedge_updateDR_sync & re_reg_r0_0_288) :
    (mbist_en_r & mbist_ce_r0_0_288); 
reg  muxed_re_r0_0_288;
wire muxed_re_r0_0_288_A, muxed_re_r0_0_288_B;
wire muxed_re_r0_0_288_S;

assign muxed_re_r0_0_288_S = debug_mode_sync | mbist_en_r;
assign muxed_re_r0_0_288_A = re;
assign muxed_re_r0_0_288_B = pre_re_r0_0_288;

always @(muxed_re_r0_0_288_S or muxed_re_r0_0_288_A or muxed_re_r0_0_288_B)
case(muxed_re_r0_0_288_S) // synopsys infer_mux
  1'b0 : muxed_re_r0_0_288 = muxed_re_r0_0_288_A;
  1'b1 : muxed_re_r0_0_288 = muxed_re_r0_0_288_B;
  default : muxed_re_r0_0_288 = `tick_x_or_0;
endcase
wire re_0_288_q;
assign re_reg_r0_0_288 = re_0_288_q ;

wire pre_re_r0_0_360;

assign pre_re_r0_0_360 = (debug_mode_sync) ?
    (posedge_updateDR_sync & re_reg_r0_0_360) :
    (mbist_en_r & mbist_ce_r0_0_360); 
reg  muxed_re_r0_0_360;
wire muxed_re_r0_0_360_A, muxed_re_r0_0_360_B;
wire muxed_re_r0_0_360_S;

assign muxed_re_r0_0_360_S = debug_mode_sync | mbist_en_r;
assign muxed_re_r0_0_360_A = re;
assign muxed_re_r0_0_360_B = pre_re_r0_0_360;

always @(muxed_re_r0_0_360_S or muxed_re_r0_0_360_A or muxed_re_r0_0_360_B)
case(muxed_re_r0_0_360_S) // synopsys infer_mux
  1'b0 : muxed_re_r0_0_360 = muxed_re_r0_0_360_A;
  1'b1 : muxed_re_r0_0_360 = muxed_re_r0_0_360_B;
  default : muxed_re_r0_0_360 = `tick_x_or_0;
endcase
wire re_0_360_q;
assign re_reg_r0_0_360 = re_0_360_q ;

wire pre_re_r0_0_432;

assign pre_re_r0_0_432 = (debug_mode_sync) ?
    (posedge_updateDR_sync & re_reg_r0_0_432) :
    (mbist_en_r & mbist_ce_r0_0_432); 
reg  muxed_re_r0_0_432;
wire muxed_re_r0_0_432_A, muxed_re_r0_0_432_B;
wire muxed_re_r0_0_432_S;

assign muxed_re_r0_0_432_S = debug_mode_sync | mbist_en_r;
assign muxed_re_r0_0_432_A = re;
assign muxed_re_r0_0_432_B = pre_re_r0_0_432;

always @(muxed_re_r0_0_432_S or muxed_re_r0_0_432_A or muxed_re_r0_0_432_B)
case(muxed_re_r0_0_432_S) // synopsys infer_mux
  1'b0 : muxed_re_r0_0_432 = muxed_re_r0_0_432_A;
  1'b1 : muxed_re_r0_0_432 = muxed_re_r0_0_432_B;
  default : muxed_re_r0_0_432 = `tick_x_or_0;
endcase
wire re_0_432_q;
assign re_reg_r0_0_432 = re_0_432_q ;

wire pre_re_r0_0_504;

assign pre_re_r0_0_504 = (debug_mode_sync) ?
    (posedge_updateDR_sync & re_reg_r0_0_504) :
    (mbist_en_r & mbist_ce_r0_0_504); 
reg  muxed_re_r0_0_504;
wire muxed_re_r0_0_504_A, muxed_re_r0_0_504_B;
wire muxed_re_r0_0_504_S;

assign muxed_re_r0_0_504_S = debug_mode_sync | mbist_en_r;
assign muxed_re_r0_0_504_A = re;
assign muxed_re_r0_0_504_B = pre_re_r0_0_504;

always @(muxed_re_r0_0_504_S or muxed_re_r0_0_504_A or muxed_re_r0_0_504_B)
case(muxed_re_r0_0_504_S) // synopsys infer_mux
  1'b0 : muxed_re_r0_0_504 = muxed_re_r0_0_504_A;
  1'b1 : muxed_re_r0_0_504 = muxed_re_r0_0_504_B;
  default : muxed_re_r0_0_504 = `tick_x_or_0;
endcase
wire re_0_504_q;
assign re_reg_r0_0_504 = re_0_504_q ;

// ------------------  START PIECE ----------------------------------
// Suffix _0_0 : Piece RAMPDP_512X72_GL_M4_D2 (RamCell)
// Covers Addresses from 0 to 511  Addressrange: [8:0]  
// Data Bit range: [71:0] (72 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [8:0] cs_start_val_0_0;
assign cs_start_val_0_0 = 9'd0;

wire [8:0] cs_end_val_0_0;
assign cs_end_val_0_0 = 9'd511;

// verilint 498 on - Incompatible width





// Write Address bus

wire [8:0] wa_0_0;
assign wa_0_0 = muxed_Wa_w0[8:0];

// Write Data in bus
wire [71:0] Wdata_0_0;
assign Wdata_0_0 = muxed_Di_w0[71:0];
assign we_0_0 = we;

// Read Address bus
wire [8:0] ra_0_0;
assign ra_0_0 = muxed_Ra_r0[8:0];

// Read DataOut bus
wire [71:0] dout_0_0;
assign re_0_0 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_72 : Piece RAMPDP_512X72_GL_M4_D2 (RamCell)
// Covers Addresses from 0 to 511  Addressrange: [8:0]  
// Data Bit range: [143:72] (72 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [8:0] cs_start_val_0_72;
assign cs_start_val_0_72 = 9'd0;

wire [8:0] cs_end_val_0_72;
assign cs_end_val_0_72 = 9'd511;

// verilint 498 on - Incompatible width





// Write Address bus

wire [8:0] wa_0_72;
assign wa_0_72 = muxed_Wa_w0[8:0];

// Write Data in bus
wire [143:72] Wdata_0_72;
assign Wdata_0_72 = muxed_Di_w0[143:72];
assign we_0_72 = we;

// Read Address bus
wire [8:0] ra_0_72;
assign ra_0_72 = muxed_Ra_r0[8:0];

// Read DataOut bus
wire [143:72] dout_0_72;
assign re_0_72 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_144 : Piece RAMPDP_512X72_GL_M4_D2 (RamCell)
// Covers Addresses from 0 to 511  Addressrange: [8:0]  
// Data Bit range: [215:144] (72 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [8:0] cs_start_val_0_144;
assign cs_start_val_0_144 = 9'd0;

wire [8:0] cs_end_val_0_144;
assign cs_end_val_0_144 = 9'd511;

// verilint 498 on - Incompatible width





// Write Address bus

wire [8:0] wa_0_144;
assign wa_0_144 = muxed_Wa_w0[8:0];

// Write Data in bus
wire [215:144] Wdata_0_144;
assign Wdata_0_144 = muxed_Di_w0[215:144];
assign we_0_144 = we;

// Read Address bus
wire [8:0] ra_0_144;
assign ra_0_144 = muxed_Ra_r0[8:0];

// Read DataOut bus
wire [215:144] dout_0_144;
assign re_0_144 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_216 : Piece RAMPDP_512X72_GL_M4_D2 (RamCell)
// Covers Addresses from 0 to 511  Addressrange: [8:0]  
// Data Bit range: [287:216] (72 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [8:0] cs_start_val_0_216;
assign cs_start_val_0_216 = 9'd0;

wire [8:0] cs_end_val_0_216;
assign cs_end_val_0_216 = 9'd511;

// verilint 498 on - Incompatible width





// Write Address bus

wire [8:0] wa_0_216;
assign wa_0_216 = muxed_Wa_w0[8:0];

// Write Data in bus
wire [287:216] Wdata_0_216;
assign Wdata_0_216 = muxed_Di_w0[287:216];
assign we_0_216 = we;

// Read Address bus
wire [8:0] ra_0_216;
assign ra_0_216 = muxed_Ra_r0[8:0];

// Read DataOut bus
wire [287:216] dout_0_216;
assign re_0_216 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_288 : Piece RAMPDP_512X72_GL_M4_D2 (RamCell)
// Covers Addresses from 0 to 511  Addressrange: [8:0]  
// Data Bit range: [359:288] (72 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [8:0] cs_start_val_0_288;
assign cs_start_val_0_288 = 9'd0;

wire [8:0] cs_end_val_0_288;
assign cs_end_val_0_288 = 9'd511;

// verilint 498 on - Incompatible width





// Write Address bus

wire [8:0] wa_0_288;
assign wa_0_288 = muxed_Wa_w0[8:0];

// Write Data in bus
wire [359:288] Wdata_0_288;
assign Wdata_0_288 = muxed_Di_w0[359:288];
assign we_0_288 = we;

// Read Address bus
wire [8:0] ra_0_288;
assign ra_0_288 = muxed_Ra_r0[8:0];

// Read DataOut bus
wire [359:288] dout_0_288;
assign re_0_288 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_360 : Piece RAMPDP_512X72_GL_M4_D2 (RamCell)
// Covers Addresses from 0 to 511  Addressrange: [8:0]  
// Data Bit range: [431:360] (72 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [8:0] cs_start_val_0_360;
assign cs_start_val_0_360 = 9'd0;

wire [8:0] cs_end_val_0_360;
assign cs_end_val_0_360 = 9'd511;

// verilint 498 on - Incompatible width





// Write Address bus

wire [8:0] wa_0_360;
assign wa_0_360 = muxed_Wa_w0[8:0];

// Write Data in bus
wire [431:360] Wdata_0_360;
assign Wdata_0_360 = muxed_Di_w0[431:360];
assign we_0_360 = we;

// Read Address bus
wire [8:0] ra_0_360;
assign ra_0_360 = muxed_Ra_r0[8:0];

// Read DataOut bus
wire [431:360] dout_0_360;
assign re_0_360 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_432 : Piece RAMPDP_512X72_GL_M4_D2 (RamCell)
// Covers Addresses from 0 to 511  Addressrange: [8:0]  
// Data Bit range: [503:432] (72 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [8:0] cs_start_val_0_432;
assign cs_start_val_0_432 = 9'd0;

wire [8:0] cs_end_val_0_432;
assign cs_end_val_0_432 = 9'd511;

// verilint 498 on - Incompatible width





// Write Address bus

wire [8:0] wa_0_432;
assign wa_0_432 = muxed_Wa_w0[8:0];

// Write Data in bus
wire [503:432] Wdata_0_432;
assign Wdata_0_432 = muxed_Di_w0[503:432];
assign we_0_432 = we;

// Read Address bus
wire [8:0] ra_0_432;
assign ra_0_432 = muxed_Ra_r0[8:0];

// Read DataOut bus
wire [503:432] dout_0_432;
assign re_0_432 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_504 : Piece RAMPDP_512X8_GL_M4_D2 (RamCell)
// Covers Addresses from 0 to 511  Addressrange: [8:0]  
// Data Bit range: [511:504] (8 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [8:0] cs_start_val_0_504;
assign cs_start_val_0_504 = 9'd0;

wire [8:0] cs_end_val_0_504;
assign cs_end_val_0_504 = 9'd511;

// verilint 498 on - Incompatible width





// Write Address bus

wire [8:0] wa_0_504;
assign wa_0_504 = muxed_Wa_w0[8:0];

// Write Data in bus
wire [511:504] Wdata_0_504;
assign Wdata_0_504 = muxed_Di_w0[511:504];
assign we_0_504 = we;

// Read Address bus
wire [8:0] ra_0_504;
assign ra_0_504 = muxed_Ra_r0[8:0];

// Read DataOut bus
wire [511:504] dout_0_504;
assign re_0_504 = re;


// Doing Global setup for all ram pieces

// Following control signals are shared by all ram pieces
// Done global setup for ram pieces


//-----------------------------------------------------------

// Declare the Bist logic\n
// Declare some mbist control signals

//--------------------------------------------------
// Vlint doesn't understand paramaters?
// verilint 110 off - Incompatible width

//--------------------------------------------------

// Turn the verilint warnings on
// verilint 110 on - Incompatible width

// -----------------  begin Ram Cell RAMPDP_512X72_GL_M4_D2_0_0 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_0 = !(|muxed_we_w0_0_0) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_0 = muxed_re_r0_0_0 | ( scan_en & jtag_readonly_mode );
wire reb_0_0 = !piece_re_0_0;
// Declare the ramOutData which connects to the ram directly
wire [71:0] ramDataOut_0_0;
assign dout_0_0[71:0] = ramDataOut_0_0[71:0];
RAMPDP_512X72_GL_M4_D2 ram_Inst_512X72_0_0 (
                                              .CLK             (gated_clk_core_0_0)
                                            , .WADR_8          (wa_0_0[8])
                                            , .WADR_7          (wa_0_0[7])
                                            , .WADR_6          (wa_0_0[6])
                                            , .WADR_5          (wa_0_0[5])
                                            , .WADR_4          (wa_0_0[4])
                                            , .WADR_3          (wa_0_0[3])
                                            , .WADR_2          (wa_0_0[2])
                                            , .WADR_1          (wa_0_0[1])
                                            , .WADR_0          (wa_0_0[0])
                                            , .WD_71           (Wdata_0_0[71])
                                            , .WD_70           (Wdata_0_0[70])
                                            , .WD_69           (Wdata_0_0[69])
                                            , .WD_68           (Wdata_0_0[68])
                                            , .WD_67           (Wdata_0_0[67])
                                            , .WD_66           (Wdata_0_0[66])
                                            , .WD_65           (Wdata_0_0[65])
                                            , .WD_64           (Wdata_0_0[64])
                                            , .WD_63           (Wdata_0_0[63])
                                            , .WD_62           (Wdata_0_0[62])
                                            , .WD_61           (Wdata_0_0[61])
                                            , .WD_60           (Wdata_0_0[60])
                                            , .WD_59           (Wdata_0_0[59])
                                            , .WD_58           (Wdata_0_0[58])
                                            , .WD_57           (Wdata_0_0[57])
                                            , .WD_56           (Wdata_0_0[56])
                                            , .WD_55           (Wdata_0_0[55])
                                            , .WD_54           (Wdata_0_0[54])
                                            , .WD_53           (Wdata_0_0[53])
                                            , .WD_52           (Wdata_0_0[52])
                                            , .WD_51           (Wdata_0_0[51])
                                            , .WD_50           (Wdata_0_0[50])
                                            , .WD_49           (Wdata_0_0[49])
                                            , .WD_48           (Wdata_0_0[48])
                                            , .WD_47           (Wdata_0_0[47])
                                            , .WD_46           (Wdata_0_0[46])
                                            , .WD_45           (Wdata_0_0[45])
                                            , .WD_44           (Wdata_0_0[44])
                                            , .WD_43           (Wdata_0_0[43])
                                            , .WD_42           (Wdata_0_0[42])
                                            , .WD_41           (Wdata_0_0[41])
                                            , .WD_40           (Wdata_0_0[40])
                                            , .WD_39           (Wdata_0_0[39])
                                            , .WD_38           (Wdata_0_0[38])
                                            , .WD_37           (Wdata_0_0[37])
                                            , .WD_36           (Wdata_0_0[36])
                                            , .WD_35           (Wdata_0_0[35])
                                            , .WD_34           (Wdata_0_0[34])
                                            , .WD_33           (Wdata_0_0[33])
                                            , .WD_32           (Wdata_0_0[32])
                                            , .WD_31           (Wdata_0_0[31])
                                            , .WD_30           (Wdata_0_0[30])
                                            , .WD_29           (Wdata_0_0[29])
                                            , .WD_28           (Wdata_0_0[28])
                                            , .WD_27           (Wdata_0_0[27])
                                            , .WD_26           (Wdata_0_0[26])
                                            , .WD_25           (Wdata_0_0[25])
                                            , .WD_24           (Wdata_0_0[24])
                                            , .WD_23           (Wdata_0_0[23])
                                            , .WD_22           (Wdata_0_0[22])
                                            , .WD_21           (Wdata_0_0[21])
                                            , .WD_20           (Wdata_0_0[20])
                                            , .WD_19           (Wdata_0_0[19])
                                            , .WD_18           (Wdata_0_0[18])
                                            , .WD_17           (Wdata_0_0[17])
                                            , .WD_16           (Wdata_0_0[16])
                                            , .WD_15           (Wdata_0_0[15])
                                            , .WD_14           (Wdata_0_0[14])
                                            , .WD_13           (Wdata_0_0[13])
                                            , .WD_12           (Wdata_0_0[12])
                                            , .WD_11           (Wdata_0_0[11])
                                            , .WD_10           (Wdata_0_0[10])
                                            , .WD_9            (Wdata_0_0[9])
                                            , .WD_8            (Wdata_0_0[8])
                                            , .WD_7            (Wdata_0_0[7])
                                            , .WD_6            (Wdata_0_0[6])
                                            , .WD_5            (Wdata_0_0[5])
                                            , .WD_4            (Wdata_0_0[4])
                                            , .WD_3            (Wdata_0_0[3])
                                            , .WD_2            (Wdata_0_0[2])
                                            , .WD_1            (Wdata_0_0[1])
                                            , .WD_0            (Wdata_0_0[0])
                                            , .WE              (!web_0_0)
                                            , .RADR_8          (ra_0_0 [8])
                                            , .RADR_7          (ra_0_0 [7])
                                            , .RADR_6          (ra_0_0 [6])
                                            , .RADR_5          (ra_0_0 [5])
                                            , .RADR_4          (ra_0_0 [4])
                                            , .RADR_3          (ra_0_0 [3])
                                            , .RADR_2          (ra_0_0 [2])
                                            , .RADR_1          (ra_0_0 [1])
                                            , .RADR_0          (ra_0_0 [0])
                                            , .RE              (!reb_0_0)
                                            , .RD_71           (ramDataOut_0_0[71])
                                            , .RD_70           (ramDataOut_0_0[70])
                                            , .RD_69           (ramDataOut_0_0[69])
                                            , .RD_68           (ramDataOut_0_0[68])
                                            , .RD_67           (ramDataOut_0_0[67])
                                            , .RD_66           (ramDataOut_0_0[66])
                                            , .RD_65           (ramDataOut_0_0[65])
                                            , .RD_64           (ramDataOut_0_0[64])
                                            , .RD_63           (ramDataOut_0_0[63])
                                            , .RD_62           (ramDataOut_0_0[62])
                                            , .RD_61           (ramDataOut_0_0[61])
                                            , .RD_60           (ramDataOut_0_0[60])
                                            , .RD_59           (ramDataOut_0_0[59])
                                            , .RD_58           (ramDataOut_0_0[58])
                                            , .RD_57           (ramDataOut_0_0[57])
                                            , .RD_56           (ramDataOut_0_0[56])
                                            , .RD_55           (ramDataOut_0_0[55])
                                            , .RD_54           (ramDataOut_0_0[54])
                                            , .RD_53           (ramDataOut_0_0[53])
                                            , .RD_52           (ramDataOut_0_0[52])
                                            , .RD_51           (ramDataOut_0_0[51])
                                            , .RD_50           (ramDataOut_0_0[50])
                                            , .RD_49           (ramDataOut_0_0[49])
                                            , .RD_48           (ramDataOut_0_0[48])
                                            , .RD_47           (ramDataOut_0_0[47])
                                            , .RD_46           (ramDataOut_0_0[46])
                                            , .RD_45           (ramDataOut_0_0[45])
                                            , .RD_44           (ramDataOut_0_0[44])
                                            , .RD_43           (ramDataOut_0_0[43])
                                            , .RD_42           (ramDataOut_0_0[42])
                                            , .RD_41           (ramDataOut_0_0[41])
                                            , .RD_40           (ramDataOut_0_0[40])
                                            , .RD_39           (ramDataOut_0_0[39])
                                            , .RD_38           (ramDataOut_0_0[38])
                                            , .RD_37           (ramDataOut_0_0[37])
                                            , .RD_36           (ramDataOut_0_0[36])
                                            , .RD_35           (ramDataOut_0_0[35])
                                            , .RD_34           (ramDataOut_0_0[34])
                                            , .RD_33           (ramDataOut_0_0[33])
                                            , .RD_32           (ramDataOut_0_0[32])
                                            , .RD_31           (ramDataOut_0_0[31])
                                            , .RD_30           (ramDataOut_0_0[30])
                                            , .RD_29           (ramDataOut_0_0[29])
                                            , .RD_28           (ramDataOut_0_0[28])
                                            , .RD_27           (ramDataOut_0_0[27])
                                            , .RD_26           (ramDataOut_0_0[26])
                                            , .RD_25           (ramDataOut_0_0[25])
                                            , .RD_24           (ramDataOut_0_0[24])
                                            , .RD_23           (ramDataOut_0_0[23])
                                            , .RD_22           (ramDataOut_0_0[22])
                                            , .RD_21           (ramDataOut_0_0[21])
                                            , .RD_20           (ramDataOut_0_0[20])
                                            , .RD_19           (ramDataOut_0_0[19])
                                            , .RD_18           (ramDataOut_0_0[18])
                                            , .RD_17           (ramDataOut_0_0[17])
                                            , .RD_16           (ramDataOut_0_0[16])
                                            , .RD_15           (ramDataOut_0_0[15])
                                            , .RD_14           (ramDataOut_0_0[14])
                                            , .RD_13           (ramDataOut_0_0[13])
                                            , .RD_12           (ramDataOut_0_0[12])
                                            , .RD_11           (ramDataOut_0_0[11])
                                            , .RD_10           (ramDataOut_0_0[10])
                                            , .RD_9            (ramDataOut_0_0[9])
                                            , .RD_8            (ramDataOut_0_0[8])
                                            , .RD_7            (ramDataOut_0_0[7])
                                            , .RD_6            (ramDataOut_0_0[6])
                                            , .RD_5            (ramDataOut_0_0[5])
                                            , .RD_4            (ramDataOut_0_0[4])
                                            , .RD_3            (ramDataOut_0_0[3])
                                            , .RD_2            (ramDataOut_0_0[2])
                                            , .RD_1            (ramDataOut_0_0[1])
                                            , .RD_0            (ramDataOut_0_0[0])
                                            , .SVOP_0          (svop[0])
                                            , .SVOP_1          (svop[1])
                                            , .SVOP_2          (svop[2])
                                            , .SVOP_3          (svop[3])
                                            , .SVOP_4          (svop[4])
                                            , .SVOP_5          (svop[5])
                                            , .SVOP_6          (svop[6])
                                            , .SVOP_7          (svop[7])
                                            , .IDDQ            (iddq_mode)
                                            , .SLEEP_EN_0      (sleep_en[0])
                                            , .SLEEP_EN_1      (sleep_en[1])
                                            , .SLEEP_EN_2      (sleep_en[2])
                                            , .SLEEP_EN_3      (sleep_en[3])
                                            , .SLEEP_EN_4      (sleep_en[4])
                                            , .SLEEP_EN_5      (sleep_en[5])
                                            , .SLEEP_EN_6      (sleep_en[6])
                                            , .SLEEP_EN_7      (sleep_en[7])
                                            , .RET_EN          (ret_en)
                                            );


//--------------------------------------------------
// THIS IS ONLY FOR TESTING. REMOVE THIS LATER
// verilint 97 on - undefined instance errors turned on

//--------------------------------------------------

//-----------------------------------------------------------

// Declare the Bist logic\n
// Declare some mbist control signals

//--------------------------------------------------
// Vlint doesn't understand paramaters?
// verilint 110 off - Incompatible width

//--------------------------------------------------

// Turn the verilint warnings on
// verilint 110 on - Incompatible width

// -----------------  begin Ram Cell RAMPDP_512X72_GL_M4_D2_0_72 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_72 = !(|muxed_we_w0_0_72) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_72 = muxed_re_r0_0_72 | ( scan_en & jtag_readonly_mode );
wire reb_0_72 = !piece_re_0_72;
// Declare the ramOutData which connects to the ram directly
wire [143:72] ramDataOut_0_72;
assign dout_0_72[143:72] = ramDataOut_0_72[143:72];
RAMPDP_512X72_GL_M4_D2 ram_Inst_512X72_0_72 (
                                               .CLK             (gated_clk_core_0_72)
                                             , .WADR_8          (wa_0_72[8])
                                             , .WADR_7          (wa_0_72[7])
                                             , .WADR_6          (wa_0_72[6])
                                             , .WADR_5          (wa_0_72[5])
                                             , .WADR_4          (wa_0_72[4])
                                             , .WADR_3          (wa_0_72[3])
                                             , .WADR_2          (wa_0_72[2])
                                             , .WADR_1          (wa_0_72[1])
                                             , .WADR_0          (wa_0_72[0])
                                             , .WD_71           (Wdata_0_72[143])
                                             , .WD_70           (Wdata_0_72[142])
                                             , .WD_69           (Wdata_0_72[141])
                                             , .WD_68           (Wdata_0_72[140])
                                             , .WD_67           (Wdata_0_72[139])
                                             , .WD_66           (Wdata_0_72[138])
                                             , .WD_65           (Wdata_0_72[137])
                                             , .WD_64           (Wdata_0_72[136])
                                             , .WD_63           (Wdata_0_72[135])
                                             , .WD_62           (Wdata_0_72[134])
                                             , .WD_61           (Wdata_0_72[133])
                                             , .WD_60           (Wdata_0_72[132])
                                             , .WD_59           (Wdata_0_72[131])
                                             , .WD_58           (Wdata_0_72[130])
                                             , .WD_57           (Wdata_0_72[129])
                                             , .WD_56           (Wdata_0_72[128])
                                             , .WD_55           (Wdata_0_72[127])
                                             , .WD_54           (Wdata_0_72[126])
                                             , .WD_53           (Wdata_0_72[125])
                                             , .WD_52           (Wdata_0_72[124])
                                             , .WD_51           (Wdata_0_72[123])
                                             , .WD_50           (Wdata_0_72[122])
                                             , .WD_49           (Wdata_0_72[121])
                                             , .WD_48           (Wdata_0_72[120])
                                             , .WD_47           (Wdata_0_72[119])
                                             , .WD_46           (Wdata_0_72[118])
                                             , .WD_45           (Wdata_0_72[117])
                                             , .WD_44           (Wdata_0_72[116])
                                             , .WD_43           (Wdata_0_72[115])
                                             , .WD_42           (Wdata_0_72[114])
                                             , .WD_41           (Wdata_0_72[113])
                                             , .WD_40           (Wdata_0_72[112])
                                             , .WD_39           (Wdata_0_72[111])
                                             , .WD_38           (Wdata_0_72[110])
                                             , .WD_37           (Wdata_0_72[109])
                                             , .WD_36           (Wdata_0_72[108])
                                             , .WD_35           (Wdata_0_72[107])
                                             , .WD_34           (Wdata_0_72[106])
                                             , .WD_33           (Wdata_0_72[105])
                                             , .WD_32           (Wdata_0_72[104])
                                             , .WD_31           (Wdata_0_72[103])
                                             , .WD_30           (Wdata_0_72[102])
                                             , .WD_29           (Wdata_0_72[101])
                                             , .WD_28           (Wdata_0_72[100])
                                             , .WD_27           (Wdata_0_72[99])
                                             , .WD_26           (Wdata_0_72[98])
                                             , .WD_25           (Wdata_0_72[97])
                                             , .WD_24           (Wdata_0_72[96])
                                             , .WD_23           (Wdata_0_72[95])
                                             , .WD_22           (Wdata_0_72[94])
                                             , .WD_21           (Wdata_0_72[93])
                                             , .WD_20           (Wdata_0_72[92])
                                             , .WD_19           (Wdata_0_72[91])
                                             , .WD_18           (Wdata_0_72[90])
                                             , .WD_17           (Wdata_0_72[89])
                                             , .WD_16           (Wdata_0_72[88])
                                             , .WD_15           (Wdata_0_72[87])
                                             , .WD_14           (Wdata_0_72[86])
                                             , .WD_13           (Wdata_0_72[85])
                                             , .WD_12           (Wdata_0_72[84])
                                             , .WD_11           (Wdata_0_72[83])
                                             , .WD_10           (Wdata_0_72[82])
                                             , .WD_9            (Wdata_0_72[81])
                                             , .WD_8            (Wdata_0_72[80])
                                             , .WD_7            (Wdata_0_72[79])
                                             , .WD_6            (Wdata_0_72[78])
                                             , .WD_5            (Wdata_0_72[77])
                                             , .WD_4            (Wdata_0_72[76])
                                             , .WD_3            (Wdata_0_72[75])
                                             , .WD_2            (Wdata_0_72[74])
                                             , .WD_1            (Wdata_0_72[73])
                                             , .WD_0            (Wdata_0_72[72])
                                             , .WE              (!web_0_72)
                                             , .RADR_8          (ra_0_72 [8])
                                             , .RADR_7          (ra_0_72 [7])
                                             , .RADR_6          (ra_0_72 [6])
                                             , .RADR_5          (ra_0_72 [5])
                                             , .RADR_4          (ra_0_72 [4])
                                             , .RADR_3          (ra_0_72 [3])
                                             , .RADR_2          (ra_0_72 [2])
                                             , .RADR_1          (ra_0_72 [1])
                                             , .RADR_0          (ra_0_72 [0])
                                             , .RE              (!reb_0_72)
                                             , .RD_71           (ramDataOut_0_72[143])
                                             , .RD_70           (ramDataOut_0_72[142])
                                             , .RD_69           (ramDataOut_0_72[141])
                                             , .RD_68           (ramDataOut_0_72[140])
                                             , .RD_67           (ramDataOut_0_72[139])
                                             , .RD_66           (ramDataOut_0_72[138])
                                             , .RD_65           (ramDataOut_0_72[137])
                                             , .RD_64           (ramDataOut_0_72[136])
                                             , .RD_63           (ramDataOut_0_72[135])
                                             , .RD_62           (ramDataOut_0_72[134])
                                             , .RD_61           (ramDataOut_0_72[133])
                                             , .RD_60           (ramDataOut_0_72[132])
                                             , .RD_59           (ramDataOut_0_72[131])
                                             , .RD_58           (ramDataOut_0_72[130])
                                             , .RD_57           (ramDataOut_0_72[129])
                                             , .RD_56           (ramDataOut_0_72[128])
                                             , .RD_55           (ramDataOut_0_72[127])
                                             , .RD_54           (ramDataOut_0_72[126])
                                             , .RD_53           (ramDataOut_0_72[125])
                                             , .RD_52           (ramDataOut_0_72[124])
                                             , .RD_51           (ramDataOut_0_72[123])
                                             , .RD_50           (ramDataOut_0_72[122])
                                             , .RD_49           (ramDataOut_0_72[121])
                                             , .RD_48           (ramDataOut_0_72[120])
                                             , .RD_47           (ramDataOut_0_72[119])
                                             , .RD_46           (ramDataOut_0_72[118])
                                             , .RD_45           (ramDataOut_0_72[117])
                                             , .RD_44           (ramDataOut_0_72[116])
                                             , .RD_43           (ramDataOut_0_72[115])
                                             , .RD_42           (ramDataOut_0_72[114])
                                             , .RD_41           (ramDataOut_0_72[113])
                                             , .RD_40           (ramDataOut_0_72[112])
                                             , .RD_39           (ramDataOut_0_72[111])
                                             , .RD_38           (ramDataOut_0_72[110])
                                             , .RD_37           (ramDataOut_0_72[109])
                                             , .RD_36           (ramDataOut_0_72[108])
                                             , .RD_35           (ramDataOut_0_72[107])
                                             , .RD_34           (ramDataOut_0_72[106])
                                             , .RD_33           (ramDataOut_0_72[105])
                                             , .RD_32           (ramDataOut_0_72[104])
                                             , .RD_31           (ramDataOut_0_72[103])
                                             , .RD_30           (ramDataOut_0_72[102])
                                             , .RD_29           (ramDataOut_0_72[101])
                                             , .RD_28           (ramDataOut_0_72[100])
                                             , .RD_27           (ramDataOut_0_72[99])
                                             , .RD_26           (ramDataOut_0_72[98])
                                             , .RD_25           (ramDataOut_0_72[97])
                                             , .RD_24           (ramDataOut_0_72[96])
                                             , .RD_23           (ramDataOut_0_72[95])
                                             , .RD_22           (ramDataOut_0_72[94])
                                             , .RD_21           (ramDataOut_0_72[93])
                                             , .RD_20           (ramDataOut_0_72[92])
                                             , .RD_19           (ramDataOut_0_72[91])
                                             , .RD_18           (ramDataOut_0_72[90])
                                             , .RD_17           (ramDataOut_0_72[89])
                                             , .RD_16           (ramDataOut_0_72[88])
                                             , .RD_15           (ramDataOut_0_72[87])
                                             , .RD_14           (ramDataOut_0_72[86])
                                             , .RD_13           (ramDataOut_0_72[85])
                                             , .RD_12           (ramDataOut_0_72[84])
                                             , .RD_11           (ramDataOut_0_72[83])
                                             , .RD_10           (ramDataOut_0_72[82])
                                             , .RD_9            (ramDataOut_0_72[81])
                                             , .RD_8            (ramDataOut_0_72[80])
                                             , .RD_7            (ramDataOut_0_72[79])
                                             , .RD_6            (ramDataOut_0_72[78])
                                             , .RD_5            (ramDataOut_0_72[77])
                                             , .RD_4            (ramDataOut_0_72[76])
                                             , .RD_3            (ramDataOut_0_72[75])
                                             , .RD_2            (ramDataOut_0_72[74])
                                             , .RD_1            (ramDataOut_0_72[73])
                                             , .RD_0            (ramDataOut_0_72[72])
                                             , .SVOP_0          (svop[0])
                                             , .SVOP_1          (svop[1])
                                             , .SVOP_2          (svop[2])
                                             , .SVOP_3          (svop[3])
                                             , .SVOP_4          (svop[4])
                                             , .SVOP_5          (svop[5])
                                             , .SVOP_6          (svop[6])
                                             , .SVOP_7          (svop[7])
                                             , .IDDQ            (iddq_mode)
                                             , .SLEEP_EN_0      (sleep_en[0])
                                             , .SLEEP_EN_1      (sleep_en[1])
                                             , .SLEEP_EN_2      (sleep_en[2])
                                             , .SLEEP_EN_3      (sleep_en[3])
                                             , .SLEEP_EN_4      (sleep_en[4])
                                             , .SLEEP_EN_5      (sleep_en[5])
                                             , .SLEEP_EN_6      (sleep_en[6])
                                             , .SLEEP_EN_7      (sleep_en[7])
                                             , .RET_EN          (ret_en)
                                             );


//--------------------------------------------------
// THIS IS ONLY FOR TESTING. REMOVE THIS LATER
// verilint 97 on - undefined instance errors turned on

//--------------------------------------------------

//-----------------------------------------------------------

// Declare the Bist logic\n
// Declare some mbist control signals

//--------------------------------------------------
// Vlint doesn't understand paramaters?
// verilint 110 off - Incompatible width

//--------------------------------------------------

// Turn the verilint warnings on
// verilint 110 on - Incompatible width

// -----------------  begin Ram Cell RAMPDP_512X72_GL_M4_D2_0_144 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_144 = !(|muxed_we_w0_0_144) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_144 = muxed_re_r0_0_144 | ( scan_en & jtag_readonly_mode );
wire reb_0_144 = !piece_re_0_144;
// Declare the ramOutData which connects to the ram directly
wire [215:144] ramDataOut_0_144;
assign dout_0_144[215:144] = ramDataOut_0_144[215:144];
RAMPDP_512X72_GL_M4_D2 ram_Inst_512X72_0_144 (
                                                .CLK             (gated_clk_core_0_144)
                                              , .WADR_8          (wa_0_144[8])
                                              , .WADR_7          (wa_0_144[7])
                                              , .WADR_6          (wa_0_144[6])
                                              , .WADR_5          (wa_0_144[5])
                                              , .WADR_4          (wa_0_144[4])
                                              , .WADR_3          (wa_0_144[3])
                                              , .WADR_2          (wa_0_144[2])
                                              , .WADR_1          (wa_0_144[1])
                                              , .WADR_0          (wa_0_144[0])
                                              , .WD_71           (Wdata_0_144[215])
                                              , .WD_70           (Wdata_0_144[214])
                                              , .WD_69           (Wdata_0_144[213])
                                              , .WD_68           (Wdata_0_144[212])
                                              , .WD_67           (Wdata_0_144[211])
                                              , .WD_66           (Wdata_0_144[210])
                                              , .WD_65           (Wdata_0_144[209])
                                              , .WD_64           (Wdata_0_144[208])
                                              , .WD_63           (Wdata_0_144[207])
                                              , .WD_62           (Wdata_0_144[206])
                                              , .WD_61           (Wdata_0_144[205])
                                              , .WD_60           (Wdata_0_144[204])
                                              , .WD_59           (Wdata_0_144[203])
                                              , .WD_58           (Wdata_0_144[202])
                                              , .WD_57           (Wdata_0_144[201])
                                              , .WD_56           (Wdata_0_144[200])
                                              , .WD_55           (Wdata_0_144[199])
                                              , .WD_54           (Wdata_0_144[198])
                                              , .WD_53           (Wdata_0_144[197])
                                              , .WD_52           (Wdata_0_144[196])
                                              , .WD_51           (Wdata_0_144[195])
                                              , .WD_50           (Wdata_0_144[194])
                                              , .WD_49           (Wdata_0_144[193])
                                              , .WD_48           (Wdata_0_144[192])
                                              , .WD_47           (Wdata_0_144[191])
                                              , .WD_46           (Wdata_0_144[190])
                                              , .WD_45           (Wdata_0_144[189])
                                              , .WD_44           (Wdata_0_144[188])
                                              , .WD_43           (Wdata_0_144[187])
                                              , .WD_42           (Wdata_0_144[186])
                                              , .WD_41           (Wdata_0_144[185])
                                              , .WD_40           (Wdata_0_144[184])
                                              , .WD_39           (Wdata_0_144[183])
                                              , .WD_38           (Wdata_0_144[182])
                                              , .WD_37           (Wdata_0_144[181])
                                              , .WD_36           (Wdata_0_144[180])
                                              , .WD_35           (Wdata_0_144[179])
                                              , .WD_34           (Wdata_0_144[178])
                                              , .WD_33           (Wdata_0_144[177])
                                              , .WD_32           (Wdata_0_144[176])
                                              , .WD_31           (Wdata_0_144[175])
                                              , .WD_30           (Wdata_0_144[174])
                                              , .WD_29           (Wdata_0_144[173])
                                              , .WD_28           (Wdata_0_144[172])
                                              , .WD_27           (Wdata_0_144[171])
                                              , .WD_26           (Wdata_0_144[170])
                                              , .WD_25           (Wdata_0_144[169])
                                              , .WD_24           (Wdata_0_144[168])
                                              , .WD_23           (Wdata_0_144[167])
                                              , .WD_22           (Wdata_0_144[166])
                                              , .WD_21           (Wdata_0_144[165])
                                              , .WD_20           (Wdata_0_144[164])
                                              , .WD_19           (Wdata_0_144[163])
                                              , .WD_18           (Wdata_0_144[162])
                                              , .WD_17           (Wdata_0_144[161])
                                              , .WD_16           (Wdata_0_144[160])
                                              , .WD_15           (Wdata_0_144[159])
                                              , .WD_14           (Wdata_0_144[158])
                                              , .WD_13           (Wdata_0_144[157])
                                              , .WD_12           (Wdata_0_144[156])
                                              , .WD_11           (Wdata_0_144[155])
                                              , .WD_10           (Wdata_0_144[154])
                                              , .WD_9            (Wdata_0_144[153])
                                              , .WD_8            (Wdata_0_144[152])
                                              , .WD_7            (Wdata_0_144[151])
                                              , .WD_6            (Wdata_0_144[150])
                                              , .WD_5            (Wdata_0_144[149])
                                              , .WD_4            (Wdata_0_144[148])
                                              , .WD_3            (Wdata_0_144[147])
                                              , .WD_2            (Wdata_0_144[146])
                                              , .WD_1            (Wdata_0_144[145])
                                              , .WD_0            (Wdata_0_144[144])
                                              , .WE              (!web_0_144)
                                              , .RADR_8          (ra_0_144 [8])
                                              , .RADR_7          (ra_0_144 [7])
                                              , .RADR_6          (ra_0_144 [6])
                                              , .RADR_5          (ra_0_144 [5])
                                              , .RADR_4          (ra_0_144 [4])
                                              , .RADR_3          (ra_0_144 [3])
                                              , .RADR_2          (ra_0_144 [2])
                                              , .RADR_1          (ra_0_144 [1])
                                              , .RADR_0          (ra_0_144 [0])
                                              , .RE              (!reb_0_144)
                                              , .RD_71           (ramDataOut_0_144[215])
                                              , .RD_70           (ramDataOut_0_144[214])
                                              , .RD_69           (ramDataOut_0_144[213])
                                              , .RD_68           (ramDataOut_0_144[212])
                                              , .RD_67           (ramDataOut_0_144[211])
                                              , .RD_66           (ramDataOut_0_144[210])
                                              , .RD_65           (ramDataOut_0_144[209])
                                              , .RD_64           (ramDataOut_0_144[208])
                                              , .RD_63           (ramDataOut_0_144[207])
                                              , .RD_62           (ramDataOut_0_144[206])
                                              , .RD_61           (ramDataOut_0_144[205])
                                              , .RD_60           (ramDataOut_0_144[204])
                                              , .RD_59           (ramDataOut_0_144[203])
                                              , .RD_58           (ramDataOut_0_144[202])
                                              , .RD_57           (ramDataOut_0_144[201])
                                              , .RD_56           (ramDataOut_0_144[200])
                                              , .RD_55           (ramDataOut_0_144[199])
                                              , .RD_54           (ramDataOut_0_144[198])
                                              , .RD_53           (ramDataOut_0_144[197])
                                              , .RD_52           (ramDataOut_0_144[196])
                                              , .RD_51           (ramDataOut_0_144[195])
                                              , .RD_50           (ramDataOut_0_144[194])
                                              , .RD_49           (ramDataOut_0_144[193])
                                              , .RD_48           (ramDataOut_0_144[192])
                                              , .RD_47           (ramDataOut_0_144[191])
                                              , .RD_46           (ramDataOut_0_144[190])
                                              , .RD_45           (ramDataOut_0_144[189])
                                              , .RD_44           (ramDataOut_0_144[188])
                                              , .RD_43           (ramDataOut_0_144[187])
                                              , .RD_42           (ramDataOut_0_144[186])
                                              , .RD_41           (ramDataOut_0_144[185])
                                              , .RD_40           (ramDataOut_0_144[184])
                                              , .RD_39           (ramDataOut_0_144[183])
                                              , .RD_38           (ramDataOut_0_144[182])
                                              , .RD_37           (ramDataOut_0_144[181])
                                              , .RD_36           (ramDataOut_0_144[180])
                                              , .RD_35           (ramDataOut_0_144[179])
                                              , .RD_34           (ramDataOut_0_144[178])
                                              , .RD_33           (ramDataOut_0_144[177])
                                              , .RD_32           (ramDataOut_0_144[176])
                                              , .RD_31           (ramDataOut_0_144[175])
                                              , .RD_30           (ramDataOut_0_144[174])
                                              , .RD_29           (ramDataOut_0_144[173])
                                              , .RD_28           (ramDataOut_0_144[172])
                                              , .RD_27           (ramDataOut_0_144[171])
                                              , .RD_26           (ramDataOut_0_144[170])
                                              , .RD_25           (ramDataOut_0_144[169])
                                              , .RD_24           (ramDataOut_0_144[168])
                                              , .RD_23           (ramDataOut_0_144[167])
                                              , .RD_22           (ramDataOut_0_144[166])
                                              , .RD_21           (ramDataOut_0_144[165])
                                              , .RD_20           (ramDataOut_0_144[164])
                                              , .RD_19           (ramDataOut_0_144[163])
                                              , .RD_18           (ramDataOut_0_144[162])
                                              , .RD_17           (ramDataOut_0_144[161])
                                              , .RD_16           (ramDataOut_0_144[160])
                                              , .RD_15           (ramDataOut_0_144[159])
                                              , .RD_14           (ramDataOut_0_144[158])
                                              , .RD_13           (ramDataOut_0_144[157])
                                              , .RD_12           (ramDataOut_0_144[156])
                                              , .RD_11           (ramDataOut_0_144[155])
                                              , .RD_10           (ramDataOut_0_144[154])
                                              , .RD_9            (ramDataOut_0_144[153])
                                              , .RD_8            (ramDataOut_0_144[152])
                                              , .RD_7            (ramDataOut_0_144[151])
                                              , .RD_6            (ramDataOut_0_144[150])
                                              , .RD_5            (ramDataOut_0_144[149])
                                              , .RD_4            (ramDataOut_0_144[148])
                                              , .RD_3            (ramDataOut_0_144[147])
                                              , .RD_2            (ramDataOut_0_144[146])
                                              , .RD_1            (ramDataOut_0_144[145])
                                              , .RD_0            (ramDataOut_0_144[144])
                                              , .SVOP_0          (svop[0])
                                              , .SVOP_1          (svop[1])
                                              , .SVOP_2          (svop[2])
                                              , .SVOP_3          (svop[3])
                                              , .SVOP_4          (svop[4])
                                              , .SVOP_5          (svop[5])
                                              , .SVOP_6          (svop[6])
                                              , .SVOP_7          (svop[7])
                                              , .IDDQ            (iddq_mode)
                                              , .SLEEP_EN_0      (sleep_en[0])
                                              , .SLEEP_EN_1      (sleep_en[1])
                                              , .SLEEP_EN_2      (sleep_en[2])
                                              , .SLEEP_EN_3      (sleep_en[3])
                                              , .SLEEP_EN_4      (sleep_en[4])
                                              , .SLEEP_EN_5      (sleep_en[5])
                                              , .SLEEP_EN_6      (sleep_en[6])
                                              , .SLEEP_EN_7      (sleep_en[7])
                                              , .RET_EN          (ret_en)
                                              );


//--------------------------------------------------
// THIS IS ONLY FOR TESTING. REMOVE THIS LATER
// verilint 97 on - undefined instance errors turned on

//--------------------------------------------------

//-----------------------------------------------------------

// Declare the Bist logic\n
// Declare some mbist control signals

//--------------------------------------------------
// Vlint doesn't understand paramaters?
// verilint 110 off - Incompatible width

//--------------------------------------------------

// Turn the verilint warnings on
// verilint 110 on - Incompatible width

// -----------------  begin Ram Cell RAMPDP_512X72_GL_M4_D2_0_216 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_216 = !(|muxed_we_w0_0_216) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_216 = muxed_re_r0_0_216 | ( scan_en & jtag_readonly_mode );
wire reb_0_216 = !piece_re_0_216;
// Declare the ramOutData which connects to the ram directly
wire [287:216] ramDataOut_0_216;
assign dout_0_216[287:216] = ramDataOut_0_216[287:216];
RAMPDP_512X72_GL_M4_D2 ram_Inst_512X72_0_216 (
                                                .CLK             (gated_clk_core_0_216)
                                              , .WADR_8          (wa_0_216[8])
                                              , .WADR_7          (wa_0_216[7])
                                              , .WADR_6          (wa_0_216[6])
                                              , .WADR_5          (wa_0_216[5])
                                              , .WADR_4          (wa_0_216[4])
                                              , .WADR_3          (wa_0_216[3])
                                              , .WADR_2          (wa_0_216[2])
                                              , .WADR_1          (wa_0_216[1])
                                              , .WADR_0          (wa_0_216[0])
                                              , .WD_71           (Wdata_0_216[287])
                                              , .WD_70           (Wdata_0_216[286])
                                              , .WD_69           (Wdata_0_216[285])
                                              , .WD_68           (Wdata_0_216[284])
                                              , .WD_67           (Wdata_0_216[283])
                                              , .WD_66           (Wdata_0_216[282])
                                              , .WD_65           (Wdata_0_216[281])
                                              , .WD_64           (Wdata_0_216[280])
                                              , .WD_63           (Wdata_0_216[279])
                                              , .WD_62           (Wdata_0_216[278])
                                              , .WD_61           (Wdata_0_216[277])
                                              , .WD_60           (Wdata_0_216[276])
                                              , .WD_59           (Wdata_0_216[275])
                                              , .WD_58           (Wdata_0_216[274])
                                              , .WD_57           (Wdata_0_216[273])
                                              , .WD_56           (Wdata_0_216[272])
                                              , .WD_55           (Wdata_0_216[271])
                                              , .WD_54           (Wdata_0_216[270])
                                              , .WD_53           (Wdata_0_216[269])
                                              , .WD_52           (Wdata_0_216[268])
                                              , .WD_51           (Wdata_0_216[267])
                                              , .WD_50           (Wdata_0_216[266])
                                              , .WD_49           (Wdata_0_216[265])
                                              , .WD_48           (Wdata_0_216[264])
                                              , .WD_47           (Wdata_0_216[263])
                                              , .WD_46           (Wdata_0_216[262])
                                              , .WD_45           (Wdata_0_216[261])
                                              , .WD_44           (Wdata_0_216[260])
                                              , .WD_43           (Wdata_0_216[259])
                                              , .WD_42           (Wdata_0_216[258])
                                              , .WD_41           (Wdata_0_216[257])
                                              , .WD_40           (Wdata_0_216[256])
                                              , .WD_39           (Wdata_0_216[255])
                                              , .WD_38           (Wdata_0_216[254])
                                              , .WD_37           (Wdata_0_216[253])
                                              , .WD_36           (Wdata_0_216[252])
                                              , .WD_35           (Wdata_0_216[251])
                                              , .WD_34           (Wdata_0_216[250])
                                              , .WD_33           (Wdata_0_216[249])
                                              , .WD_32           (Wdata_0_216[248])
                                              , .WD_31           (Wdata_0_216[247])
                                              , .WD_30           (Wdata_0_216[246])
                                              , .WD_29           (Wdata_0_216[245])
                                              , .WD_28           (Wdata_0_216[244])
                                              , .WD_27           (Wdata_0_216[243])
                                              , .WD_26           (Wdata_0_216[242])
                                              , .WD_25           (Wdata_0_216[241])
                                              , .WD_24           (Wdata_0_216[240])
                                              , .WD_23           (Wdata_0_216[239])
                                              , .WD_22           (Wdata_0_216[238])
                                              , .WD_21           (Wdata_0_216[237])
                                              , .WD_20           (Wdata_0_216[236])
                                              , .WD_19           (Wdata_0_216[235])
                                              , .WD_18           (Wdata_0_216[234])
                                              , .WD_17           (Wdata_0_216[233])
                                              , .WD_16           (Wdata_0_216[232])
                                              , .WD_15           (Wdata_0_216[231])
                                              , .WD_14           (Wdata_0_216[230])
                                              , .WD_13           (Wdata_0_216[229])
                                              , .WD_12           (Wdata_0_216[228])
                                              , .WD_11           (Wdata_0_216[227])
                                              , .WD_10           (Wdata_0_216[226])
                                              , .WD_9            (Wdata_0_216[225])
                                              , .WD_8            (Wdata_0_216[224])
                                              , .WD_7            (Wdata_0_216[223])
                                              , .WD_6            (Wdata_0_216[222])
                                              , .WD_5            (Wdata_0_216[221])
                                              , .WD_4            (Wdata_0_216[220])
                                              , .WD_3            (Wdata_0_216[219])
                                              , .WD_2            (Wdata_0_216[218])
                                              , .WD_1            (Wdata_0_216[217])
                                              , .WD_0            (Wdata_0_216[216])
                                              , .WE              (!web_0_216)
                                              , .RADR_8          (ra_0_216 [8])
                                              , .RADR_7          (ra_0_216 [7])
                                              , .RADR_6          (ra_0_216 [6])
                                              , .RADR_5          (ra_0_216 [5])
                                              , .RADR_4          (ra_0_216 [4])
                                              , .RADR_3          (ra_0_216 [3])
                                              , .RADR_2          (ra_0_216 [2])
                                              , .RADR_1          (ra_0_216 [1])
                                              , .RADR_0          (ra_0_216 [0])
                                              , .RE              (!reb_0_216)
                                              , .RD_71           (ramDataOut_0_216[287])
                                              , .RD_70           (ramDataOut_0_216[286])
                                              , .RD_69           (ramDataOut_0_216[285])
                                              , .RD_68           (ramDataOut_0_216[284])
                                              , .RD_67           (ramDataOut_0_216[283])
                                              , .RD_66           (ramDataOut_0_216[282])
                                              , .RD_65           (ramDataOut_0_216[281])
                                              , .RD_64           (ramDataOut_0_216[280])
                                              , .RD_63           (ramDataOut_0_216[279])
                                              , .RD_62           (ramDataOut_0_216[278])
                                              , .RD_61           (ramDataOut_0_216[277])
                                              , .RD_60           (ramDataOut_0_216[276])
                                              , .RD_59           (ramDataOut_0_216[275])
                                              , .RD_58           (ramDataOut_0_216[274])
                                              , .RD_57           (ramDataOut_0_216[273])
                                              , .RD_56           (ramDataOut_0_216[272])
                                              , .RD_55           (ramDataOut_0_216[271])
                                              , .RD_54           (ramDataOut_0_216[270])
                                              , .RD_53           (ramDataOut_0_216[269])
                                              , .RD_52           (ramDataOut_0_216[268])
                                              , .RD_51           (ramDataOut_0_216[267])
                                              , .RD_50           (ramDataOut_0_216[266])
                                              , .RD_49           (ramDataOut_0_216[265])
                                              , .RD_48           (ramDataOut_0_216[264])
                                              , .RD_47           (ramDataOut_0_216[263])
                                              , .RD_46           (ramDataOut_0_216[262])
                                              , .RD_45           (ramDataOut_0_216[261])
                                              , .RD_44           (ramDataOut_0_216[260])
                                              , .RD_43           (ramDataOut_0_216[259])
                                              , .RD_42           (ramDataOut_0_216[258])
                                              , .RD_41           (ramDataOut_0_216[257])
                                              , .RD_40           (ramDataOut_0_216[256])
                                              , .RD_39           (ramDataOut_0_216[255])
                                              , .RD_38           (ramDataOut_0_216[254])
                                              , .RD_37           (ramDataOut_0_216[253])
                                              , .RD_36           (ramDataOut_0_216[252])
                                              , .RD_35           (ramDataOut_0_216[251])
                                              , .RD_34           (ramDataOut_0_216[250])
                                              , .RD_33           (ramDataOut_0_216[249])
                                              , .RD_32           (ramDataOut_0_216[248])
                                              , .RD_31           (ramDataOut_0_216[247])
                                              , .RD_30           (ramDataOut_0_216[246])
                                              , .RD_29           (ramDataOut_0_216[245])
                                              , .RD_28           (ramDataOut_0_216[244])
                                              , .RD_27           (ramDataOut_0_216[243])
                                              , .RD_26           (ramDataOut_0_216[242])
                                              , .RD_25           (ramDataOut_0_216[241])
                                              , .RD_24           (ramDataOut_0_216[240])
                                              , .RD_23           (ramDataOut_0_216[239])
                                              , .RD_22           (ramDataOut_0_216[238])
                                              , .RD_21           (ramDataOut_0_216[237])
                                              , .RD_20           (ramDataOut_0_216[236])
                                              , .RD_19           (ramDataOut_0_216[235])
                                              , .RD_18           (ramDataOut_0_216[234])
                                              , .RD_17           (ramDataOut_0_216[233])
                                              , .RD_16           (ramDataOut_0_216[232])
                                              , .RD_15           (ramDataOut_0_216[231])
                                              , .RD_14           (ramDataOut_0_216[230])
                                              , .RD_13           (ramDataOut_0_216[229])
                                              , .RD_12           (ramDataOut_0_216[228])
                                              , .RD_11           (ramDataOut_0_216[227])
                                              , .RD_10           (ramDataOut_0_216[226])
                                              , .RD_9            (ramDataOut_0_216[225])
                                              , .RD_8            (ramDataOut_0_216[224])
                                              , .RD_7            (ramDataOut_0_216[223])
                                              , .RD_6            (ramDataOut_0_216[222])
                                              , .RD_5            (ramDataOut_0_216[221])
                                              , .RD_4            (ramDataOut_0_216[220])
                                              , .RD_3            (ramDataOut_0_216[219])
                                              , .RD_2            (ramDataOut_0_216[218])
                                              , .RD_1            (ramDataOut_0_216[217])
                                              , .RD_0            (ramDataOut_0_216[216])
                                              , .SVOP_0          (svop[0])
                                              , .SVOP_1          (svop[1])
                                              , .SVOP_2          (svop[2])
                                              , .SVOP_3          (svop[3])
                                              , .SVOP_4          (svop[4])
                                              , .SVOP_5          (svop[5])
                                              , .SVOP_6          (svop[6])
                                              , .SVOP_7          (svop[7])
                                              , .IDDQ            (iddq_mode)
                                              , .SLEEP_EN_0      (sleep_en[0])
                                              , .SLEEP_EN_1      (sleep_en[1])
                                              , .SLEEP_EN_2      (sleep_en[2])
                                              , .SLEEP_EN_3      (sleep_en[3])
                                              , .SLEEP_EN_4      (sleep_en[4])
                                              , .SLEEP_EN_5      (sleep_en[5])
                                              , .SLEEP_EN_6      (sleep_en[6])
                                              , .SLEEP_EN_7      (sleep_en[7])
                                              , .RET_EN          (ret_en)
                                              );


//--------------------------------------------------
// THIS IS ONLY FOR TESTING. REMOVE THIS LATER
// verilint 97 on - undefined instance errors turned on

//--------------------------------------------------

//-----------------------------------------------------------

// Declare the Bist logic\n
// Declare some mbist control signals

//--------------------------------------------------
// Vlint doesn't understand paramaters?
// verilint 110 off - Incompatible width

//--------------------------------------------------

// Turn the verilint warnings on
// verilint 110 on - Incompatible width

// -----------------  begin Ram Cell RAMPDP_512X72_GL_M4_D2_0_288 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_288 = !(|muxed_we_w0_0_288) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_288 = muxed_re_r0_0_288 | ( scan_en & jtag_readonly_mode );
wire reb_0_288 = !piece_re_0_288;
// Declare the ramOutData which connects to the ram directly
wire [359:288] ramDataOut_0_288;
assign dout_0_288[359:288] = ramDataOut_0_288[359:288];
RAMPDP_512X72_GL_M4_D2 ram_Inst_512X72_0_288 (
                                                .CLK             (gated_clk_core_0_288)
                                              , .WADR_8          (wa_0_288[8])
                                              , .WADR_7          (wa_0_288[7])
                                              , .WADR_6          (wa_0_288[6])
                                              , .WADR_5          (wa_0_288[5])
                                              , .WADR_4          (wa_0_288[4])
                                              , .WADR_3          (wa_0_288[3])
                                              , .WADR_2          (wa_0_288[2])
                                              , .WADR_1          (wa_0_288[1])
                                              , .WADR_0          (wa_0_288[0])
                                              , .WD_71           (Wdata_0_288[359])
                                              , .WD_70           (Wdata_0_288[358])
                                              , .WD_69           (Wdata_0_288[357])
                                              , .WD_68           (Wdata_0_288[356])
                                              , .WD_67           (Wdata_0_288[355])
                                              , .WD_66           (Wdata_0_288[354])
                                              , .WD_65           (Wdata_0_288[353])
                                              , .WD_64           (Wdata_0_288[352])
                                              , .WD_63           (Wdata_0_288[351])
                                              , .WD_62           (Wdata_0_288[350])
                                              , .WD_61           (Wdata_0_288[349])
                                              , .WD_60           (Wdata_0_288[348])
                                              , .WD_59           (Wdata_0_288[347])
                                              , .WD_58           (Wdata_0_288[346])
                                              , .WD_57           (Wdata_0_288[345])
                                              , .WD_56           (Wdata_0_288[344])
                                              , .WD_55           (Wdata_0_288[343])
                                              , .WD_54           (Wdata_0_288[342])
                                              , .WD_53           (Wdata_0_288[341])
                                              , .WD_52           (Wdata_0_288[340])
                                              , .WD_51           (Wdata_0_288[339])
                                              , .WD_50           (Wdata_0_288[338])
                                              , .WD_49           (Wdata_0_288[337])
                                              , .WD_48           (Wdata_0_288[336])
                                              , .WD_47           (Wdata_0_288[335])
                                              , .WD_46           (Wdata_0_288[334])
                                              , .WD_45           (Wdata_0_288[333])
                                              , .WD_44           (Wdata_0_288[332])
                                              , .WD_43           (Wdata_0_288[331])
                                              , .WD_42           (Wdata_0_288[330])
                                              , .WD_41           (Wdata_0_288[329])
                                              , .WD_40           (Wdata_0_288[328])
                                              , .WD_39           (Wdata_0_288[327])
                                              , .WD_38           (Wdata_0_288[326])
                                              , .WD_37           (Wdata_0_288[325])
                                              , .WD_36           (Wdata_0_288[324])
                                              , .WD_35           (Wdata_0_288[323])
                                              , .WD_34           (Wdata_0_288[322])
                                              , .WD_33           (Wdata_0_288[321])
                                              , .WD_32           (Wdata_0_288[320])
                                              , .WD_31           (Wdata_0_288[319])
                                              , .WD_30           (Wdata_0_288[318])
                                              , .WD_29           (Wdata_0_288[317])
                                              , .WD_28           (Wdata_0_288[316])
                                              , .WD_27           (Wdata_0_288[315])
                                              , .WD_26           (Wdata_0_288[314])
                                              , .WD_25           (Wdata_0_288[313])
                                              , .WD_24           (Wdata_0_288[312])
                                              , .WD_23           (Wdata_0_288[311])
                                              , .WD_22           (Wdata_0_288[310])
                                              , .WD_21           (Wdata_0_288[309])
                                              , .WD_20           (Wdata_0_288[308])
                                              , .WD_19           (Wdata_0_288[307])
                                              , .WD_18           (Wdata_0_288[306])
                                              , .WD_17           (Wdata_0_288[305])
                                              , .WD_16           (Wdata_0_288[304])
                                              , .WD_15           (Wdata_0_288[303])
                                              , .WD_14           (Wdata_0_288[302])
                                              , .WD_13           (Wdata_0_288[301])
                                              , .WD_12           (Wdata_0_288[300])
                                              , .WD_11           (Wdata_0_288[299])
                                              , .WD_10           (Wdata_0_288[298])
                                              , .WD_9            (Wdata_0_288[297])
                                              , .WD_8            (Wdata_0_288[296])
                                              , .WD_7            (Wdata_0_288[295])
                                              , .WD_6            (Wdata_0_288[294])
                                              , .WD_5            (Wdata_0_288[293])
                                              , .WD_4            (Wdata_0_288[292])
                                              , .WD_3            (Wdata_0_288[291])
                                              , .WD_2            (Wdata_0_288[290])
                                              , .WD_1            (Wdata_0_288[289])
                                              , .WD_0            (Wdata_0_288[288])
                                              , .WE              (!web_0_288)
                                              , .RADR_8          (ra_0_288 [8])
                                              , .RADR_7          (ra_0_288 [7])
                                              , .RADR_6          (ra_0_288 [6])
                                              , .RADR_5          (ra_0_288 [5])
                                              , .RADR_4          (ra_0_288 [4])
                                              , .RADR_3          (ra_0_288 [3])
                                              , .RADR_2          (ra_0_288 [2])
                                              , .RADR_1          (ra_0_288 [1])
                                              , .RADR_0          (ra_0_288 [0])
                                              , .RE              (!reb_0_288)
                                              , .RD_71           (ramDataOut_0_288[359])
                                              , .RD_70           (ramDataOut_0_288[358])
                                              , .RD_69           (ramDataOut_0_288[357])
                                              , .RD_68           (ramDataOut_0_288[356])
                                              , .RD_67           (ramDataOut_0_288[355])
                                              , .RD_66           (ramDataOut_0_288[354])
                                              , .RD_65           (ramDataOut_0_288[353])
                                              , .RD_64           (ramDataOut_0_288[352])
                                              , .RD_63           (ramDataOut_0_288[351])
                                              , .RD_62           (ramDataOut_0_288[350])
                                              , .RD_61           (ramDataOut_0_288[349])
                                              , .RD_60           (ramDataOut_0_288[348])
                                              , .RD_59           (ramDataOut_0_288[347])
                                              , .RD_58           (ramDataOut_0_288[346])
                                              , .RD_57           (ramDataOut_0_288[345])
                                              , .RD_56           (ramDataOut_0_288[344])
                                              , .RD_55           (ramDataOut_0_288[343])
                                              , .RD_54           (ramDataOut_0_288[342])
                                              , .RD_53           (ramDataOut_0_288[341])
                                              , .RD_52           (ramDataOut_0_288[340])
                                              , .RD_51           (ramDataOut_0_288[339])
                                              , .RD_50           (ramDataOut_0_288[338])
                                              , .RD_49           (ramDataOut_0_288[337])
                                              , .RD_48           (ramDataOut_0_288[336])
                                              , .RD_47           (ramDataOut_0_288[335])
                                              , .RD_46           (ramDataOut_0_288[334])
                                              , .RD_45           (ramDataOut_0_288[333])
                                              , .RD_44           (ramDataOut_0_288[332])
                                              , .RD_43           (ramDataOut_0_288[331])
                                              , .RD_42           (ramDataOut_0_288[330])
                                              , .RD_41           (ramDataOut_0_288[329])
                                              , .RD_40           (ramDataOut_0_288[328])
                                              , .RD_39           (ramDataOut_0_288[327])
                                              , .RD_38           (ramDataOut_0_288[326])
                                              , .RD_37           (ramDataOut_0_288[325])
                                              , .RD_36           (ramDataOut_0_288[324])
                                              , .RD_35           (ramDataOut_0_288[323])
                                              , .RD_34           (ramDataOut_0_288[322])
                                              , .RD_33           (ramDataOut_0_288[321])
                                              , .RD_32           (ramDataOut_0_288[320])
                                              , .RD_31           (ramDataOut_0_288[319])
                                              , .RD_30           (ramDataOut_0_288[318])
                                              , .RD_29           (ramDataOut_0_288[317])
                                              , .RD_28           (ramDataOut_0_288[316])
                                              , .RD_27           (ramDataOut_0_288[315])
                                              , .RD_26           (ramDataOut_0_288[314])
                                              , .RD_25           (ramDataOut_0_288[313])
                                              , .RD_24           (ramDataOut_0_288[312])
                                              , .RD_23           (ramDataOut_0_288[311])
                                              , .RD_22           (ramDataOut_0_288[310])
                                              , .RD_21           (ramDataOut_0_288[309])
                                              , .RD_20           (ramDataOut_0_288[308])
                                              , .RD_19           (ramDataOut_0_288[307])
                                              , .RD_18           (ramDataOut_0_288[306])
                                              , .RD_17           (ramDataOut_0_288[305])
                                              , .RD_16           (ramDataOut_0_288[304])
                                              , .RD_15           (ramDataOut_0_288[303])
                                              , .RD_14           (ramDataOut_0_288[302])
                                              , .RD_13           (ramDataOut_0_288[301])
                                              , .RD_12           (ramDataOut_0_288[300])
                                              , .RD_11           (ramDataOut_0_288[299])
                                              , .RD_10           (ramDataOut_0_288[298])
                                              , .RD_9            (ramDataOut_0_288[297])
                                              , .RD_8            (ramDataOut_0_288[296])
                                              , .RD_7            (ramDataOut_0_288[295])
                                              , .RD_6            (ramDataOut_0_288[294])
                                              , .RD_5            (ramDataOut_0_288[293])
                                              , .RD_4            (ramDataOut_0_288[292])
                                              , .RD_3            (ramDataOut_0_288[291])
                                              , .RD_2            (ramDataOut_0_288[290])
                                              , .RD_1            (ramDataOut_0_288[289])
                                              , .RD_0            (ramDataOut_0_288[288])
                                              , .SVOP_0          (svop[0])
                                              , .SVOP_1          (svop[1])
                                              , .SVOP_2          (svop[2])
                                              , .SVOP_3          (svop[3])
                                              , .SVOP_4          (svop[4])
                                              , .SVOP_5          (svop[5])
                                              , .SVOP_6          (svop[6])
                                              , .SVOP_7          (svop[7])
                                              , .IDDQ            (iddq_mode)
                                              , .SLEEP_EN_0      (sleep_en[0])
                                              , .SLEEP_EN_1      (sleep_en[1])
                                              , .SLEEP_EN_2      (sleep_en[2])
                                              , .SLEEP_EN_3      (sleep_en[3])
                                              , .SLEEP_EN_4      (sleep_en[4])
                                              , .SLEEP_EN_5      (sleep_en[5])
                                              , .SLEEP_EN_6      (sleep_en[6])
                                              , .SLEEP_EN_7      (sleep_en[7])
                                              , .RET_EN          (ret_en)
                                              );


//--------------------------------------------------
// THIS IS ONLY FOR TESTING. REMOVE THIS LATER
// verilint 97 on - undefined instance errors turned on

//--------------------------------------------------

//-----------------------------------------------------------

// Declare the Bist logic\n
// Declare some mbist control signals

//--------------------------------------------------
// Vlint doesn't understand paramaters?
// verilint 110 off - Incompatible width

//--------------------------------------------------

// Turn the verilint warnings on
// verilint 110 on - Incompatible width

// -----------------  begin Ram Cell RAMPDP_512X72_GL_M4_D2_0_360 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_360 = !(|muxed_we_w0_0_360) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_360 = muxed_re_r0_0_360 | ( scan_en & jtag_readonly_mode );
wire reb_0_360 = !piece_re_0_360;
// Declare the ramOutData which connects to the ram directly
wire [431:360] ramDataOut_0_360;
assign dout_0_360[431:360] = ramDataOut_0_360[431:360];
RAMPDP_512X72_GL_M4_D2 ram_Inst_512X72_0_360 (
                                                .CLK             (gated_clk_core_0_360)
                                              , .WADR_8          (wa_0_360[8])
                                              , .WADR_7          (wa_0_360[7])
                                              , .WADR_6          (wa_0_360[6])
                                              , .WADR_5          (wa_0_360[5])
                                              , .WADR_4          (wa_0_360[4])
                                              , .WADR_3          (wa_0_360[3])
                                              , .WADR_2          (wa_0_360[2])
                                              , .WADR_1          (wa_0_360[1])
                                              , .WADR_0          (wa_0_360[0])
                                              , .WD_71           (Wdata_0_360[431])
                                              , .WD_70           (Wdata_0_360[430])
                                              , .WD_69           (Wdata_0_360[429])
                                              , .WD_68           (Wdata_0_360[428])
                                              , .WD_67           (Wdata_0_360[427])
                                              , .WD_66           (Wdata_0_360[426])
                                              , .WD_65           (Wdata_0_360[425])
                                              , .WD_64           (Wdata_0_360[424])
                                              , .WD_63           (Wdata_0_360[423])
                                              , .WD_62           (Wdata_0_360[422])
                                              , .WD_61           (Wdata_0_360[421])
                                              , .WD_60           (Wdata_0_360[420])
                                              , .WD_59           (Wdata_0_360[419])
                                              , .WD_58           (Wdata_0_360[418])
                                              , .WD_57           (Wdata_0_360[417])
                                              , .WD_56           (Wdata_0_360[416])
                                              , .WD_55           (Wdata_0_360[415])
                                              , .WD_54           (Wdata_0_360[414])
                                              , .WD_53           (Wdata_0_360[413])
                                              , .WD_52           (Wdata_0_360[412])
                                              , .WD_51           (Wdata_0_360[411])
                                              , .WD_50           (Wdata_0_360[410])
                                              , .WD_49           (Wdata_0_360[409])
                                              , .WD_48           (Wdata_0_360[408])
                                              , .WD_47           (Wdata_0_360[407])
                                              , .WD_46           (Wdata_0_360[406])
                                              , .WD_45           (Wdata_0_360[405])
                                              , .WD_44           (Wdata_0_360[404])
                                              , .WD_43           (Wdata_0_360[403])
                                              , .WD_42           (Wdata_0_360[402])
                                              , .WD_41           (Wdata_0_360[401])
                                              , .WD_40           (Wdata_0_360[400])
                                              , .WD_39           (Wdata_0_360[399])
                                              , .WD_38           (Wdata_0_360[398])
                                              , .WD_37           (Wdata_0_360[397])
                                              , .WD_36           (Wdata_0_360[396])
                                              , .WD_35           (Wdata_0_360[395])
                                              , .WD_34           (Wdata_0_360[394])
                                              , .WD_33           (Wdata_0_360[393])
                                              , .WD_32           (Wdata_0_360[392])
                                              , .WD_31           (Wdata_0_360[391])
                                              , .WD_30           (Wdata_0_360[390])
                                              , .WD_29           (Wdata_0_360[389])
                                              , .WD_28           (Wdata_0_360[388])
                                              , .WD_27           (Wdata_0_360[387])
                                              , .WD_26           (Wdata_0_360[386])
                                              , .WD_25           (Wdata_0_360[385])
                                              , .WD_24           (Wdata_0_360[384])
                                              , .WD_23           (Wdata_0_360[383])
                                              , .WD_22           (Wdata_0_360[382])
                                              , .WD_21           (Wdata_0_360[381])
                                              , .WD_20           (Wdata_0_360[380])
                                              , .WD_19           (Wdata_0_360[379])
                                              , .WD_18           (Wdata_0_360[378])
                                              , .WD_17           (Wdata_0_360[377])
                                              , .WD_16           (Wdata_0_360[376])
                                              , .WD_15           (Wdata_0_360[375])
                                              , .WD_14           (Wdata_0_360[374])
                                              , .WD_13           (Wdata_0_360[373])
                                              , .WD_12           (Wdata_0_360[372])
                                              , .WD_11           (Wdata_0_360[371])
                                              , .WD_10           (Wdata_0_360[370])
                                              , .WD_9            (Wdata_0_360[369])
                                              , .WD_8            (Wdata_0_360[368])
                                              , .WD_7            (Wdata_0_360[367])
                                              , .WD_6            (Wdata_0_360[366])
                                              , .WD_5            (Wdata_0_360[365])
                                              , .WD_4            (Wdata_0_360[364])
                                              , .WD_3            (Wdata_0_360[363])
                                              , .WD_2            (Wdata_0_360[362])
                                              , .WD_1            (Wdata_0_360[361])
                                              , .WD_0            (Wdata_0_360[360])
                                              , .WE              (!web_0_360)
                                              , .RADR_8          (ra_0_360 [8])
                                              , .RADR_7          (ra_0_360 [7])
                                              , .RADR_6          (ra_0_360 [6])
                                              , .RADR_5          (ra_0_360 [5])
                                              , .RADR_4          (ra_0_360 [4])
                                              , .RADR_3          (ra_0_360 [3])
                                              , .RADR_2          (ra_0_360 [2])
                                              , .RADR_1          (ra_0_360 [1])
                                              , .RADR_0          (ra_0_360 [0])
                                              , .RE              (!reb_0_360)
                                              , .RD_71           (ramDataOut_0_360[431])
                                              , .RD_70           (ramDataOut_0_360[430])
                                              , .RD_69           (ramDataOut_0_360[429])
                                              , .RD_68           (ramDataOut_0_360[428])
                                              , .RD_67           (ramDataOut_0_360[427])
                                              , .RD_66           (ramDataOut_0_360[426])
                                              , .RD_65           (ramDataOut_0_360[425])
                                              , .RD_64           (ramDataOut_0_360[424])
                                              , .RD_63           (ramDataOut_0_360[423])
                                              , .RD_62           (ramDataOut_0_360[422])
                                              , .RD_61           (ramDataOut_0_360[421])
                                              , .RD_60           (ramDataOut_0_360[420])
                                              , .RD_59           (ramDataOut_0_360[419])
                                              , .RD_58           (ramDataOut_0_360[418])
                                              , .RD_57           (ramDataOut_0_360[417])
                                              , .RD_56           (ramDataOut_0_360[416])
                                              , .RD_55           (ramDataOut_0_360[415])
                                              , .RD_54           (ramDataOut_0_360[414])
                                              , .RD_53           (ramDataOut_0_360[413])
                                              , .RD_52           (ramDataOut_0_360[412])
                                              , .RD_51           (ramDataOut_0_360[411])
                                              , .RD_50           (ramDataOut_0_360[410])
                                              , .RD_49           (ramDataOut_0_360[409])
                                              , .RD_48           (ramDataOut_0_360[408])
                                              , .RD_47           (ramDataOut_0_360[407])
                                              , .RD_46           (ramDataOut_0_360[406])
                                              , .RD_45           (ramDataOut_0_360[405])
                                              , .RD_44           (ramDataOut_0_360[404])
                                              , .RD_43           (ramDataOut_0_360[403])
                                              , .RD_42           (ramDataOut_0_360[402])
                                              , .RD_41           (ramDataOut_0_360[401])
                                              , .RD_40           (ramDataOut_0_360[400])
                                              , .RD_39           (ramDataOut_0_360[399])
                                              , .RD_38           (ramDataOut_0_360[398])
                                              , .RD_37           (ramDataOut_0_360[397])
                                              , .RD_36           (ramDataOut_0_360[396])
                                              , .RD_35           (ramDataOut_0_360[395])
                                              , .RD_34           (ramDataOut_0_360[394])
                                              , .RD_33           (ramDataOut_0_360[393])
                                              , .RD_32           (ramDataOut_0_360[392])
                                              , .RD_31           (ramDataOut_0_360[391])
                                              , .RD_30           (ramDataOut_0_360[390])
                                              , .RD_29           (ramDataOut_0_360[389])
                                              , .RD_28           (ramDataOut_0_360[388])
                                              , .RD_27           (ramDataOut_0_360[387])
                                              , .RD_26           (ramDataOut_0_360[386])
                                              , .RD_25           (ramDataOut_0_360[385])
                                              , .RD_24           (ramDataOut_0_360[384])
                                              , .RD_23           (ramDataOut_0_360[383])
                                              , .RD_22           (ramDataOut_0_360[382])
                                              , .RD_21           (ramDataOut_0_360[381])
                                              , .RD_20           (ramDataOut_0_360[380])
                                              , .RD_19           (ramDataOut_0_360[379])
                                              , .RD_18           (ramDataOut_0_360[378])
                                              , .RD_17           (ramDataOut_0_360[377])
                                              , .RD_16           (ramDataOut_0_360[376])
                                              , .RD_15           (ramDataOut_0_360[375])
                                              , .RD_14           (ramDataOut_0_360[374])
                                              , .RD_13           (ramDataOut_0_360[373])
                                              , .RD_12           (ramDataOut_0_360[372])
                                              , .RD_11           (ramDataOut_0_360[371])
                                              , .RD_10           (ramDataOut_0_360[370])
                                              , .RD_9            (ramDataOut_0_360[369])
                                              , .RD_8            (ramDataOut_0_360[368])
                                              , .RD_7            (ramDataOut_0_360[367])
                                              , .RD_6            (ramDataOut_0_360[366])
                                              , .RD_5            (ramDataOut_0_360[365])
                                              , .RD_4            (ramDataOut_0_360[364])
                                              , .RD_3            (ramDataOut_0_360[363])
                                              , .RD_2            (ramDataOut_0_360[362])
                                              , .RD_1            (ramDataOut_0_360[361])
                                              , .RD_0            (ramDataOut_0_360[360])
                                              , .SVOP_0          (svop[0])
                                              , .SVOP_1          (svop[1])
                                              , .SVOP_2          (svop[2])
                                              , .SVOP_3          (svop[3])
                                              , .SVOP_4          (svop[4])
                                              , .SVOP_5          (svop[5])
                                              , .SVOP_6          (svop[6])
                                              , .SVOP_7          (svop[7])
                                              , .IDDQ            (iddq_mode)
                                              , .SLEEP_EN_0      (sleep_en[0])
                                              , .SLEEP_EN_1      (sleep_en[1])
                                              , .SLEEP_EN_2      (sleep_en[2])
                                              , .SLEEP_EN_3      (sleep_en[3])
                                              , .SLEEP_EN_4      (sleep_en[4])
                                              , .SLEEP_EN_5      (sleep_en[5])
                                              , .SLEEP_EN_6      (sleep_en[6])
                                              , .SLEEP_EN_7      (sleep_en[7])
                                              , .RET_EN          (ret_en)
                                              );


//--------------------------------------------------
// THIS IS ONLY FOR TESTING. REMOVE THIS LATER
// verilint 97 on - undefined instance errors turned on

//--------------------------------------------------

//-----------------------------------------------------------

// Declare the Bist logic\n
// Declare some mbist control signals

//--------------------------------------------------
// Vlint doesn't understand paramaters?
// verilint 110 off - Incompatible width

//--------------------------------------------------

// Turn the verilint warnings on
// verilint 110 on - Incompatible width

// -----------------  begin Ram Cell RAMPDP_512X72_GL_M4_D2_0_432 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_432 = !(|muxed_we_w0_0_432) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_432 = muxed_re_r0_0_432 | ( scan_en & jtag_readonly_mode );
wire reb_0_432 = !piece_re_0_432;
// Declare the ramOutData which connects to the ram directly
wire [503:432] ramDataOut_0_432;
assign dout_0_432[503:432] = ramDataOut_0_432[503:432];
RAMPDP_512X72_GL_M4_D2 ram_Inst_512X72_0_432 (
                                                .CLK             (gated_clk_core_0_432)
                                              , .WADR_8          (wa_0_432[8])
                                              , .WADR_7          (wa_0_432[7])
                                              , .WADR_6          (wa_0_432[6])
                                              , .WADR_5          (wa_0_432[5])
                                              , .WADR_4          (wa_0_432[4])
                                              , .WADR_3          (wa_0_432[3])
                                              , .WADR_2          (wa_0_432[2])
                                              , .WADR_1          (wa_0_432[1])
                                              , .WADR_0          (wa_0_432[0])
                                              , .WD_71           (Wdata_0_432[503])
                                              , .WD_70           (Wdata_0_432[502])
                                              , .WD_69           (Wdata_0_432[501])
                                              , .WD_68           (Wdata_0_432[500])
                                              , .WD_67           (Wdata_0_432[499])
                                              , .WD_66           (Wdata_0_432[498])
                                              , .WD_65           (Wdata_0_432[497])
                                              , .WD_64           (Wdata_0_432[496])
                                              , .WD_63           (Wdata_0_432[495])
                                              , .WD_62           (Wdata_0_432[494])
                                              , .WD_61           (Wdata_0_432[493])
                                              , .WD_60           (Wdata_0_432[492])
                                              , .WD_59           (Wdata_0_432[491])
                                              , .WD_58           (Wdata_0_432[490])
                                              , .WD_57           (Wdata_0_432[489])
                                              , .WD_56           (Wdata_0_432[488])
                                              , .WD_55           (Wdata_0_432[487])
                                              , .WD_54           (Wdata_0_432[486])
                                              , .WD_53           (Wdata_0_432[485])
                                              , .WD_52           (Wdata_0_432[484])
                                              , .WD_51           (Wdata_0_432[483])
                                              , .WD_50           (Wdata_0_432[482])
                                              , .WD_49           (Wdata_0_432[481])
                                              , .WD_48           (Wdata_0_432[480])
                                              , .WD_47           (Wdata_0_432[479])
                                              , .WD_46           (Wdata_0_432[478])
                                              , .WD_45           (Wdata_0_432[477])
                                              , .WD_44           (Wdata_0_432[476])
                                              , .WD_43           (Wdata_0_432[475])
                                              , .WD_42           (Wdata_0_432[474])
                                              , .WD_41           (Wdata_0_432[473])
                                              , .WD_40           (Wdata_0_432[472])
                                              , .WD_39           (Wdata_0_432[471])
                                              , .WD_38           (Wdata_0_432[470])
                                              , .WD_37           (Wdata_0_432[469])
                                              , .WD_36           (Wdata_0_432[468])
                                              , .WD_35           (Wdata_0_432[467])
                                              , .WD_34           (Wdata_0_432[466])
                                              , .WD_33           (Wdata_0_432[465])
                                              , .WD_32           (Wdata_0_432[464])
                                              , .WD_31           (Wdata_0_432[463])
                                              , .WD_30           (Wdata_0_432[462])
                                              , .WD_29           (Wdata_0_432[461])
                                              , .WD_28           (Wdata_0_432[460])
                                              , .WD_27           (Wdata_0_432[459])
                                              , .WD_26           (Wdata_0_432[458])
                                              , .WD_25           (Wdata_0_432[457])
                                              , .WD_24           (Wdata_0_432[456])
                                              , .WD_23           (Wdata_0_432[455])
                                              , .WD_22           (Wdata_0_432[454])
                                              , .WD_21           (Wdata_0_432[453])
                                              , .WD_20           (Wdata_0_432[452])
                                              , .WD_19           (Wdata_0_432[451])
                                              , .WD_18           (Wdata_0_432[450])
                                              , .WD_17           (Wdata_0_432[449])
                                              , .WD_16           (Wdata_0_432[448])
                                              , .WD_15           (Wdata_0_432[447])
                                              , .WD_14           (Wdata_0_432[446])
                                              , .WD_13           (Wdata_0_432[445])
                                              , .WD_12           (Wdata_0_432[444])
                                              , .WD_11           (Wdata_0_432[443])
                                              , .WD_10           (Wdata_0_432[442])
                                              , .WD_9            (Wdata_0_432[441])
                                              , .WD_8            (Wdata_0_432[440])
                                              , .WD_7            (Wdata_0_432[439])
                                              , .WD_6            (Wdata_0_432[438])
                                              , .WD_5            (Wdata_0_432[437])
                                              , .WD_4            (Wdata_0_432[436])
                                              , .WD_3            (Wdata_0_432[435])
                                              , .WD_2            (Wdata_0_432[434])
                                              , .WD_1            (Wdata_0_432[433])
                                              , .WD_0            (Wdata_0_432[432])
                                              , .WE              (!web_0_432)
                                              , .RADR_8          (ra_0_432 [8])
                                              , .RADR_7          (ra_0_432 [7])
                                              , .RADR_6          (ra_0_432 [6])
                                              , .RADR_5          (ra_0_432 [5])
                                              , .RADR_4          (ra_0_432 [4])
                                              , .RADR_3          (ra_0_432 [3])
                                              , .RADR_2          (ra_0_432 [2])
                                              , .RADR_1          (ra_0_432 [1])
                                              , .RADR_0          (ra_0_432 [0])
                                              , .RE              (!reb_0_432)
                                              , .RD_71           (ramDataOut_0_432[503])
                                              , .RD_70           (ramDataOut_0_432[502])
                                              , .RD_69           (ramDataOut_0_432[501])
                                              , .RD_68           (ramDataOut_0_432[500])
                                              , .RD_67           (ramDataOut_0_432[499])
                                              , .RD_66           (ramDataOut_0_432[498])
                                              , .RD_65           (ramDataOut_0_432[497])
                                              , .RD_64           (ramDataOut_0_432[496])
                                              , .RD_63           (ramDataOut_0_432[495])
                                              , .RD_62           (ramDataOut_0_432[494])
                                              , .RD_61           (ramDataOut_0_432[493])
                                              , .RD_60           (ramDataOut_0_432[492])
                                              , .RD_59           (ramDataOut_0_432[491])
                                              , .RD_58           (ramDataOut_0_432[490])
                                              , .RD_57           (ramDataOut_0_432[489])
                                              , .RD_56           (ramDataOut_0_432[488])
                                              , .RD_55           (ramDataOut_0_432[487])
                                              , .RD_54           (ramDataOut_0_432[486])
                                              , .RD_53           (ramDataOut_0_432[485])
                                              , .RD_52           (ramDataOut_0_432[484])
                                              , .RD_51           (ramDataOut_0_432[483])
                                              , .RD_50           (ramDataOut_0_432[482])
                                              , .RD_49           (ramDataOut_0_432[481])
                                              , .RD_48           (ramDataOut_0_432[480])
                                              , .RD_47           (ramDataOut_0_432[479])
                                              , .RD_46           (ramDataOut_0_432[478])
                                              , .RD_45           (ramDataOut_0_432[477])
                                              , .RD_44           (ramDataOut_0_432[476])
                                              , .RD_43           (ramDataOut_0_432[475])
                                              , .RD_42           (ramDataOut_0_432[474])
                                              , .RD_41           (ramDataOut_0_432[473])
                                              , .RD_40           (ramDataOut_0_432[472])
                                              , .RD_39           (ramDataOut_0_432[471])
                                              , .RD_38           (ramDataOut_0_432[470])
                                              , .RD_37           (ramDataOut_0_432[469])
                                              , .RD_36           (ramDataOut_0_432[468])
                                              , .RD_35           (ramDataOut_0_432[467])
                                              , .RD_34           (ramDataOut_0_432[466])
                                              , .RD_33           (ramDataOut_0_432[465])
                                              , .RD_32           (ramDataOut_0_432[464])
                                              , .RD_31           (ramDataOut_0_432[463])
                                              , .RD_30           (ramDataOut_0_432[462])
                                              , .RD_29           (ramDataOut_0_432[461])
                                              , .RD_28           (ramDataOut_0_432[460])
                                              , .RD_27           (ramDataOut_0_432[459])
                                              , .RD_26           (ramDataOut_0_432[458])
                                              , .RD_25           (ramDataOut_0_432[457])
                                              , .RD_24           (ramDataOut_0_432[456])
                                              , .RD_23           (ramDataOut_0_432[455])
                                              , .RD_22           (ramDataOut_0_432[454])
                                              , .RD_21           (ramDataOut_0_432[453])
                                              , .RD_20           (ramDataOut_0_432[452])
                                              , .RD_19           (ramDataOut_0_432[451])
                                              , .RD_18           (ramDataOut_0_432[450])
                                              , .RD_17           (ramDataOut_0_432[449])
                                              , .RD_16           (ramDataOut_0_432[448])
                                              , .RD_15           (ramDataOut_0_432[447])
                                              , .RD_14           (ramDataOut_0_432[446])
                                              , .RD_13           (ramDataOut_0_432[445])
                                              , .RD_12           (ramDataOut_0_432[444])
                                              , .RD_11           (ramDataOut_0_432[443])
                                              , .RD_10           (ramDataOut_0_432[442])
                                              , .RD_9            (ramDataOut_0_432[441])
                                              , .RD_8            (ramDataOut_0_432[440])
                                              , .RD_7            (ramDataOut_0_432[439])
                                              , .RD_6            (ramDataOut_0_432[438])
                                              , .RD_5            (ramDataOut_0_432[437])
                                              , .RD_4            (ramDataOut_0_432[436])
                                              , .RD_3            (ramDataOut_0_432[435])
                                              , .RD_2            (ramDataOut_0_432[434])
                                              , .RD_1            (ramDataOut_0_432[433])
                                              , .RD_0            (ramDataOut_0_432[432])
                                              , .SVOP_0          (svop[0])
                                              , .SVOP_1          (svop[1])
                                              , .SVOP_2          (svop[2])
                                              , .SVOP_3          (svop[3])
                                              , .SVOP_4          (svop[4])
                                              , .SVOP_5          (svop[5])
                                              , .SVOP_6          (svop[6])
                                              , .SVOP_7          (svop[7])
                                              , .IDDQ            (iddq_mode)
                                              , .SLEEP_EN_0      (sleep_en[0])
                                              , .SLEEP_EN_1      (sleep_en[1])
                                              , .SLEEP_EN_2      (sleep_en[2])
                                              , .SLEEP_EN_3      (sleep_en[3])
                                              , .SLEEP_EN_4      (sleep_en[4])
                                              , .SLEEP_EN_5      (sleep_en[5])
                                              , .SLEEP_EN_6      (sleep_en[6])
                                              , .SLEEP_EN_7      (sleep_en[7])
                                              , .RET_EN          (ret_en)
                                              );


//--------------------------------------------------
// THIS IS ONLY FOR TESTING. REMOVE THIS LATER
// verilint 97 on - undefined instance errors turned on

//--------------------------------------------------

//-----------------------------------------------------------

// Declare the Bist logic\n
// Declare some mbist control signals

//--------------------------------------------------
// Vlint doesn't understand paramaters?
// verilint 110 off - Incompatible width

//--------------------------------------------------

// Turn the verilint warnings on
// verilint 110 on - Incompatible width

// -----------------  begin Ram Cell RAMPDP_512X8_GL_M4_D2_0_504 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_504 = !(|muxed_we_w0_0_504) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_504 = muxed_re_r0_0_504 | ( scan_en & jtag_readonly_mode );
wire reb_0_504 = !piece_re_0_504;
// Declare the ramOutData which connects to the ram directly
wire [511:504] ramDataOut_0_504;
assign dout_0_504[511:504] = ramDataOut_0_504[511:504];
RAMPDP_512X8_GL_M4_D2 ram_Inst_512X8_0_504 (
                                              .CLK             (gated_clk_core_0_504)
                                            , .WADR_8          (wa_0_504[8])
                                            , .WADR_7          (wa_0_504[7])
                                            , .WADR_6          (wa_0_504[6])
                                            , .WADR_5          (wa_0_504[5])
                                            , .WADR_4          (wa_0_504[4])
                                            , .WADR_3          (wa_0_504[3])
                                            , .WADR_2          (wa_0_504[2])
                                            , .WADR_1          (wa_0_504[1])
                                            , .WADR_0          (wa_0_504[0])
                                            , .WD_7            (Wdata_0_504[511])
                                            , .WD_6            (Wdata_0_504[510])
                                            , .WD_5            (Wdata_0_504[509])
                                            , .WD_4            (Wdata_0_504[508])
                                            , .WD_3            (Wdata_0_504[507])
                                            , .WD_2            (Wdata_0_504[506])
                                            , .WD_1            (Wdata_0_504[505])
                                            , .WD_0            (Wdata_0_504[504])
                                            , .WE              (!web_0_504)
                                            , .RADR_8          (ra_0_504 [8])
                                            , .RADR_7          (ra_0_504 [7])
                                            , .RADR_6          (ra_0_504 [6])
                                            , .RADR_5          (ra_0_504 [5])
                                            , .RADR_4          (ra_0_504 [4])
                                            , .RADR_3          (ra_0_504 [3])
                                            , .RADR_2          (ra_0_504 [2])
                                            , .RADR_1          (ra_0_504 [1])
                                            , .RADR_0          (ra_0_504 [0])
                                            , .RE              (!reb_0_504)
                                            , .RD_7            (ramDataOut_0_504[511])
                                            , .RD_6            (ramDataOut_0_504[510])
                                            , .RD_5            (ramDataOut_0_504[509])
                                            , .RD_4            (ramDataOut_0_504[508])
                                            , .RD_3            (ramDataOut_0_504[507])
                                            , .RD_2            (ramDataOut_0_504[506])
                                            , .RD_1            (ramDataOut_0_504[505])
                                            , .RD_0            (ramDataOut_0_504[504])
                                            , .SVOP_0          (svop[0])
                                            , .SVOP_1          (svop[1])
                                            , .SVOP_2          (svop[2])
                                            , .SVOP_3          (svop[3])
                                            , .SVOP_4          (svop[4])
                                            , .SVOP_5          (svop[5])
                                            , .SVOP_6          (svop[6])
                                            , .SVOP_7          (svop[7])
                                            , .IDDQ            (iddq_mode)
                                            , .SLEEP_EN_0      (sleep_en[0])
                                            , .SLEEP_EN_1      (sleep_en[1])
                                            , .SLEEP_EN_2      (sleep_en[2])
                                            , .SLEEP_EN_3      (sleep_en[3])
                                            , .SLEEP_EN_4      (sleep_en[4])
                                            , .SLEEP_EN_5      (sleep_en[5])
                                            , .SLEEP_EN_6      (sleep_en[6])
                                            , .SLEEP_EN_7      (sleep_en[7])
                                            , .RET_EN          (ret_en)
                                            );


//--------------------------------------------------
// THIS IS ONLY FOR TESTING. REMOVE THIS LATER
// verilint 97 on - undefined instance errors turned on

//--------------------------------------------------

// --------------------------------------------- 

// Declare the interface wires for Output Mux logic


// verilint 552 off - Different bits of a net are driven in different blocks (harmless, 
// but some synthesis tools generate a warning for this)
reg [511:0] ram_r0_OutputMuxDataOut;

//For bitEnd 71, only one piece RAMPDP_512X72_GL_M4_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_0[71:0] or Data_reg_r0[71:0] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[71:0] = (ram_bypass) ? Data_reg_r0[71:0]: dout_0_0;
end
assign r0_OutputMuxDataOut[71:0] = ram_r0_OutputMuxDataOut[71:0];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 143, only one piece RAMPDP_512X72_GL_M4_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_72[143:72] or Data_reg_r0[143:72] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[143:72] = (ram_bypass) ? Data_reg_r0[143:72]: dout_0_72;
end
assign r0_OutputMuxDataOut[143:72] = ram_r0_OutputMuxDataOut[143:72];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 215, only one piece RAMPDP_512X72_GL_M4_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_144[215:144] or Data_reg_r0[215:144] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[215:144] = (ram_bypass) ? Data_reg_r0[215:144]: dout_0_144;
end
assign r0_OutputMuxDataOut[215:144] = ram_r0_OutputMuxDataOut[215:144];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 287, only one piece RAMPDP_512X72_GL_M4_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_216[287:216] or Data_reg_r0[287:216] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[287:216] = (ram_bypass) ? Data_reg_r0[287:216]: dout_0_216;
end
assign r0_OutputMuxDataOut[287:216] = ram_r0_OutputMuxDataOut[287:216];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 359, only one piece RAMPDP_512X72_GL_M4_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_288[359:288] or Data_reg_r0[359:288] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[359:288] = (ram_bypass) ? Data_reg_r0[359:288]: dout_0_288;
end
assign r0_OutputMuxDataOut[359:288] = ram_r0_OutputMuxDataOut[359:288];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 431, only one piece RAMPDP_512X72_GL_M4_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_360[431:360] or Data_reg_r0[431:360] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[431:360] = (ram_bypass) ? Data_reg_r0[431:360]: dout_0_360;
end
assign r0_OutputMuxDataOut[431:360] = ram_r0_OutputMuxDataOut[431:360];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 503, only one piece RAMPDP_512X72_GL_M4_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_432[503:432] or Data_reg_r0[503:432] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[503:432] = (ram_bypass) ? Data_reg_r0[503:432]: dout_0_432;
end
assign r0_OutputMuxDataOut[503:432] = ram_r0_OutputMuxDataOut[503:432];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 511, only one piece RAMPDP_512X8_GL_M4_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_504[511:504] or Data_reg_r0[511:504] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[511:504] = (ram_bypass) ? Data_reg_r0[511:504]: dout_0_504;
end
assign r0_OutputMuxDataOut[511:504] = ram_r0_OutputMuxDataOut[511:504];
// verilint 17 on - Range (rather than full vector) in the sensitivity list



// --------------------- Output Mbist Interface logic  -------------


// new mux in front of the data register

reg [512-1:0] muxed_Data_r0;
wire [512-1:0] muxed_Data_A, muxed_Data_B;
wire muxed_Data_S;

assign muxed_Data_S = debug_mode_sync ? (re_reg_r0_0_0 | re_reg_r0_0_72 | re_reg_r0_0_144 | re_reg_r0_0_216 | re_reg_r0_0_288 | re_reg_r0_0_360 | re_reg_r0_0_432 | re_reg_r0_0_504) : mbist_en_r;
assign muxed_Data_A = muxed_Di_w0;
assign muxed_Data_B = r0_OutputMuxDataOut;

always @(muxed_Data_S or muxed_Data_A or muxed_Data_B)
  case(muxed_Data_S) // synopsys infer_mux
    1'b0 : muxed_Data_r0 = muxed_Data_A;
    1'b1 : muxed_Data_r0 = muxed_Data_B;
    default : muxed_Data_r0 = {512{`tick_x_or_0}};
  endcase
reg mbist_ce_r0_0_0_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_0_1p <= mbist_ce_r0_0_0;
reg mbist_ce_r0_0_72_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_72_1p <= mbist_ce_r0_0_72;
reg mbist_ce_r0_0_144_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_144_1p <= mbist_ce_r0_0_144;
reg mbist_ce_r0_0_216_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_216_1p <= mbist_ce_r0_0_216;
reg mbist_ce_r0_0_288_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_288_1p <= mbist_ce_r0_0_288;
reg mbist_ce_r0_0_360_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_360_1p <= mbist_ce_r0_0_360;
reg mbist_ce_r0_0_432_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_432_1p <= mbist_ce_r0_0_432;
reg mbist_ce_r0_0_504_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_504_1p <= mbist_ce_r0_0_504;
wire captureDR_r0 = dft_capdr_r | (( debug_mode_sync ? (1'b1& (access_en_r_1p_0_0 | access_en_r_1p_0_72 | access_en_r_1p_0_144 | access_en_r_1p_0_216 | access_en_r_1p_0_288 | access_en_r_1p_0_360 | access_en_r_1p_0_432 | access_en_r_1p_0_504)) :  ((mbist_en_r & (mbist_ce_r0_0_0_1p | mbist_ce_r0_0_72_1p | mbist_ce_r0_0_144_1p | mbist_ce_r0_0_216_1p | mbist_ce_r0_0_288_1p | mbist_ce_r0_0_360_1p | mbist_ce_r0_0_432_1p | mbist_ce_r0_0_504_1p) & !1'b0))));
////MSB 511 LSB 0  and total rambit is 512 and  dsize is 512

wire Data_reg_SO_r0;
// verilint 110 off - Incompatible width
// verilint 630 off - Port connected to a NULL expression
// These are used for registering Ra in case of Latch arrays as well (i.e. 
// used in functional path as well)
wire [511:0]data_regq;
assign Data_reg_r0[511:0] = data_regq[511:0] ;

// verilint 110 on - Incompatible width
// verilint 630 on - Port connected to a NULL expression
assign dout = r0_OutputMuxDataOut;
assign mbist_Do_r0_int_net = Data_reg_r0[512-1:0];

// Declare the SO which goes out finally

`ifndef EMU
`ifndef FPGA
`define NO_EMU_NO_FPGA
// lock-up latch for ram_access SO
LNQD1PO4 testInst_ram_access_lockup (
                   .Q(SO_int_net),
                   .D(Data_reg_SO_r0),
                   .EN(la_bist_clkw0));

`endif
`endif

`ifndef NO_EMU_NO_FPGA
// no latch allow during emulation synthesis 
assign SO_int_net = Data_reg_SO_r0;
`endif

// Ram access scan chain 
wire gated_clk_jtag_Wa_reg_w0;
CKLNQD12PO4  UJ_clk_jtag_Wa_reg_w0 (.Q(gated_clk_jtag_Wa_reg_w0), .CP(clk), .E(debug_mode_sync ? (( 1'b0  | shiftDR ) ) :  (1'b0 |  1'b0 | mbist_en_r  | ( 1'b0 | ary_atpg_ctl)  ) ), .TE(scan_en));
    
ScanShareSel_JTAG_reg_ext_cg #(9, 0, 0) testInst_Wa_reg_w0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_Wa_w0), .Q(wadr_q),
            .scanin(SI), .scanout(Wa_reg_SO_w0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_0), .Q(we_0_0_q),
            .scanin(Wa_reg_SO_w0), .scanout(we_reg_SO_w0_0_0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_72 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_72), .Q(we_0_72_q),
            .scanin(we_reg_SO_w0_0_0), .scanout(we_reg_SO_w0_0_72)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_144 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_144), .Q(we_0_144_q),
            .scanin(we_reg_SO_w0_0_72), .scanout(we_reg_SO_w0_0_144)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_216 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_216), .Q(we_0_216_q),
            .scanin(we_reg_SO_w0_0_144), .scanout(we_reg_SO_w0_0_216)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_288 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_288), .Q(we_0_288_q),
            .scanin(we_reg_SO_w0_0_216), .scanout(we_reg_SO_w0_0_288)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_360 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_360), .Q(we_0_360_q),
            .scanin(we_reg_SO_w0_0_288), .scanout(we_reg_SO_w0_0_360)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_432 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_432), .Q(we_0_432_q),
            .scanin(we_reg_SO_w0_0_360), .scanout(we_reg_SO_w0_0_432)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_504 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_504), .Q(we_0_504_q),
            .scanin(we_reg_SO_w0_0_432), .scanout(we_reg_SO_w0_0_504)  );
    
ScanShareSel_JTAG_reg_ext_cg #(9, 0, 0) testInst_Ra_reg_r0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_Ra_r0), .Q(radr_q),
            .scanin(we_reg_SO_w0_0_504), .scanout(Ra_reg_SO_r0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_0), .Q(re_0_0_q),
            .scanin(Ra_reg_SO_r0), .scanout(re_reg_SO_r0_0_0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_72 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_72), .Q(re_0_72_q),
            .scanin(re_reg_SO_r0_0_0), .scanout(re_reg_SO_r0_0_72)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_144 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_144), .Q(re_0_144_q),
            .scanin(re_reg_SO_r0_0_72), .scanout(re_reg_SO_r0_0_144)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_216 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_216), .Q(re_0_216_q),
            .scanin(re_reg_SO_r0_0_144), .scanout(re_reg_SO_r0_0_216)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_288 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_288), .Q(re_0_288_q),
            .scanin(re_reg_SO_r0_0_216), .scanout(re_reg_SO_r0_0_288)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_360 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_360), .Q(re_0_360_q),
            .scanin(re_reg_SO_r0_0_288), .scanout(re_reg_SO_r0_0_360)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_432 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_432), .Q(re_0_432_q),
            .scanin(re_reg_SO_r0_0_360), .scanout(re_reg_SO_r0_0_432)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_504 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_504), .Q(re_0_504_q),
            .scanin(re_reg_SO_r0_0_432), .scanout(re_reg_SO_r0_0_504)  );
wire gated_clk_jtag_Data_reg_r0;
CKLNQD12PO4  UJ_clk_jtag_Data_reg_r0 (.Q(gated_clk_jtag_Data_reg_r0), .CP(clk), .E(captureDR_r0 | (debug_mode_sync & shiftDR)), .TE(scan_en));
wire [511:0] Data_reg_r0_D = muxed_Data_r0[511:0];
wire [511:0] Data_reg_r0_Q;
assign data_regq[511:0] = Data_reg_r0_Q;
wire so_Data_reg_r0_511_256;

ScanShareSel_JTAG_reg_ext_cg #(256, 0, 0) testInst_Data_reg_r0_511_256 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[511:256]), .Q(Data_reg_r0_Q[511:256]),
            .scanin(re_reg_SO_r0_0_504), .scanout(so_Data_reg_r0_511_256)  );

ScanShareSel_JTAG_reg_ext_cg #(256, 0, 0) testInst_Data_reg_r0_255_0 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[255:0]), .Q(Data_reg_r0_Q[255:0]),
            .scanin(so_Data_reg_r0_511_256), .scanout(Data_reg_SO_r0)  );

`ifdef ASSERT_ON
`ifndef SYNTHESIS
reg sim_reset_;
initial sim_reset_ = 0;
always @(posedge clk) sim_reset_ <= 1'b1;

wire start_of_sim = sim_reset_;


wire disable_clk_x_test = $test$plusargs ("disable_clk_x_test") ? 1'b1 : 1'b0;
nv_assert_no_x #(1,1,0," Try Reading Ram when clock is x for read port r0") _clk_x_test_read (clk, sim_reset_, ((disable_clk_x_test===1'b0) && (|re===1'b1 )), clk);
nv_assert_no_x #(1,1,0," Try Writing Ram when clock is x for write port w0") _clk_x_test_write (clk, sim_reset_, ((disable_clk_x_test===1'b0) && (|we===1'b1)), clk);
reg [512-1:0] written; 
always@(posedge clk or negedge sim_reset_) begin 
   if(!sim_reset_) begin 
      written <= {512{1'b0}}; 
   end else if( |we)begin 
      written[wa] <= 1'b1; 
   end
end
`endif // SYNTHESIS 
`endif // ASSERT_ON

`ifdef ASSERT_ON
`ifndef SYNTHESIS
`endif
`endif

`ifdef ASSERT_ON
`ifndef SYNTHESIS
wire pwrbus_assertion_not_x_while_active = $test$plusargs ("pwrbus_assertion_not_x_while_active");
nv_assert_never #(0, 0, "Power bus cannot be X when read/write enable is set") _pwrbus_assertion_not_x_while_active_we ( we, sim_reset_ && !pwrbus_assertion_not_x_while_active, ^pwrbus_ram_pd === 1'bx);
nv_assert_never #(0, 0, "Power bus cannot be X when read/write enable is set") _pwrbus_assertion_not_x_while_active_re ( re, sim_reset_ && !pwrbus_assertion_not_x_while_active, ^pwrbus_ram_pd === 1'bx);
`endif
`endif

// submodule done
endmodule
