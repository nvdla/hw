// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rwsp_160x514_logic.v

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


module nv_ram_rwsp_160x514_logic (
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
               mbist_ce_r0_0_288,
               mbist_ce_r0_0_432,
               mbist_en_sync,
               mbist_ramaccess_rst_,
               mbist_we_w0_0_0,
               mbist_we_w0_0_144,
               mbist_we_w0_0_288,
               mbist_we_w0_0_432,
               ore,
               pwrbus_ram_pd,
               ra,
               re,
               scan_en,
               scan_ramtms,
               shiftDR,
               svop,
               test_mode,
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
input  [513:0]  di;
output [513:0]  dout;
input           iddq_mode;
input           jtag_readonly_mode;
input  [1:0]    mbist_Di_w0;
output [513:0]  mbist_Do_r0_int_net;
input  [7:0]    mbist_Ra_r0;
input  [7:0]    mbist_Wa_w0;
input           mbist_ce_r0_0_0;
input           mbist_ce_r0_0_144;
input           mbist_ce_r0_0_288;
input           mbist_ce_r0_0_432;
input           mbist_en_sync;
input           mbist_ramaccess_rst_;
input           mbist_we_w0_0_0;
input           mbist_we_w0_0_144;
input           mbist_we_w0_0_288;
input           mbist_we_w0_0_432;
input           ore;
input  [31:0]   pwrbus_ram_pd;
input  [7:0]    ra;
input           re;
input           scan_en;
input           scan_ramtms;
input           shiftDR;
input  [7:0]    svop;
input           test_mode;
input           updateDR;
input  [7:0]    wa;
input           we;
input           write_inh;


wire [7:0] sleep_en = pwrbus_ram_pd[7:0];
wire  ret_en = pwrbus_ram_pd[8];
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
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
reg [7:0] Ra_array_reg_r0;

wire mbist_en_r;
// hardcode mbist_en_r stdcell flop to avoid x bash recoverability issue described in bug 1803479 comment #7
p_SDFCNQD1PO4 mbist_en_flop(.D(mbist_en_sync), .CP(dft_rst_gated_clk), .Q(mbist_en_r), .CDN(mbist_ramaccess_rst_));

// Declare the Data_reg signal beforehand
wire [513:0] Data_reg_r0;


 // Data out bus for read port r0 for Output Mux
wire [513:0] r0_OutputMuxDataOut;
CKLNQD12PO4  UJ_la_bist_clkw0_gate (.Q(la_bist_clkw0), .CP(clk), .E(mbist_en_r | debug_mode_sync), .TE(scan_en));

// Write enable bus
wire  we_0_0;

// Read enable bus
wire re_0_0;

// Write enable bus
wire  we_0_144;

// Read enable bus
wire re_0_144;

// Write enable bus
wire  we_0_288;

// Read enable bus
wire re_0_288;

// Write enable bus
wire  we_0_432;

// Read enable bus
wire re_0_432;
// start of predeclareNvregSignals
wire ctx_ctrl_we;
wire clk_en_core_0_0 = (re_0_0 | (|we_0_0));
wire gated_clk_core_0_0;
CKLNQD12PO4  UJ_clk_gate_core_0_0 (.Q(gated_clk_core_0_0), .CP(clk), .E(clk_en_core_0_0), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_144 = (re_0_144 | (|we_0_144));
wire gated_clk_core_0_144;
CKLNQD12PO4  UJ_clk_gate_core_0_144 (.Q(gated_clk_core_0_144), .CP(clk), .E(clk_en_core_0_144), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_288 = (re_0_288 | (|we_0_288));
wire gated_clk_core_0_288;
CKLNQD12PO4  UJ_clk_gate_core_0_288 (.Q(gated_clk_core_0_288), .CP(clk), .E(clk_en_core_0_288), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_432 = (re_0_432 | (|we_0_432));
wire gated_clk_core_0_432;
CKLNQD12PO4  UJ_clk_gate_core_0_432 (.Q(gated_clk_core_0_432), .CP(clk), .E(clk_en_core_0_432), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire shiftDR_en;

reg [513:0] pre_muxed_Di_w0;
wire [513:0] pre_muxed_Di_w0_A, pre_muxed_Di_w0_B;
wire pre_muxed_Di_w0_S;

assign pre_muxed_Di_w0_S = !debug_mode_sync;
assign pre_muxed_Di_w0_A = Data_reg_r0[513:0];
assign pre_muxed_Di_w0_B = {{41{mbist_Di_w0}}, {72{mbist_Di_w0}}, {72{mbist_Di_w0}}, {72{mbist_Di_w0}}};

always @(pre_muxed_Di_w0_S or pre_muxed_Di_w0_A or pre_muxed_Di_w0_B)
    case(pre_muxed_Di_w0_S) // synopsys infer_mux
      1'b0 : pre_muxed_Di_w0 = pre_muxed_Di_w0_A;
      1'b1 : pre_muxed_Di_w0 = pre_muxed_Di_w0_B;
      default : pre_muxed_Di_w0 = {514{`tick_x_or_0}};
    endcase

reg [513:0] muxed_Di_w0;
wire [513:0] muxed_Di_w0_A, muxed_Di_w0_B;
assign muxed_Di_w0_A = {di[513:432], di[431:288], di[287:144], di[143:0]};
assign muxed_Di_w0_B = pre_muxed_Di_w0;

wire muxed_Di_w0_S = debug_mode_sync | mbist_en_r;
always @(muxed_Di_w0_S or muxed_Di_w0_A or muxed_Di_w0_B)
    case(muxed_Di_w0_S) // synopsys infer_mux
      1'b0 : muxed_Di_w0 = muxed_Di_w0_A;
      1'b1 : muxed_Di_w0 = muxed_Di_w0_B;
      default : muxed_Di_w0 = {514{`tick_x_or_0}};
    endcase


wire posedge_updateDR_sync = updateDR_sync & !updateDR_sync_1p;

wire access_en_w = posedge_updateDR_sync;

// ATPG logic: capture for non-data regs
wire dft_capdr_w = ary_atpg_ctl;

wire [7:0] pre_Wa_reg_w0;

reg [7:0] Wa_reg_w0;
wire [7:0] Wa_reg_w0_A, Wa_reg_w0_B;
wire Wa_reg_w0_S;

assign Wa_reg_w0_S = (!debug_mode_sync);
assign Wa_reg_w0_A = pre_Wa_reg_w0;
assign Wa_reg_w0_B = mbist_Wa_w0;

always @(Wa_reg_w0_S or Wa_reg_w0_A or Wa_reg_w0_B)
case(Wa_reg_w0_S) // synopsys infer_mux
  1'b0 : Wa_reg_w0 = Wa_reg_w0_A;
  1'b1 : Wa_reg_w0 = Wa_reg_w0_B;
  default : Wa_reg_w0 = {8{`tick_x_or_0}};
endcase

reg [7:0] muxed_Wa_w0;
wire [7:0] muxed_Wa_w0_A, muxed_Wa_w0_B;
wire muxed_Wa_w0_S;

assign muxed_Wa_w0_S = debug_mode_sync | mbist_en_r;
assign muxed_Wa_w0_A = wa;
assign muxed_Wa_w0_B = Wa_reg_w0;

always @(muxed_Wa_w0_S or muxed_Wa_w0_A or muxed_Wa_w0_B)
  case(muxed_Wa_w0_S) // synopsys infer_mux
    1'b0 : muxed_Wa_w0 = muxed_Wa_w0_A;
    1'b1 : muxed_Wa_w0 = muxed_Wa_w0_B;
    default : muxed_Wa_w0 = {8{`tick_x_or_0}};
  endcase

// testInst_*reg* for address and enable capture the signals going into RAM instance input
// 4.2.3.1 of bob's doc
wire Wa_reg_SO_w0;
wire [7:0]wadr_q;
assign pre_Wa_reg_w0 = wadr_q ;
wire we_reg_SO_w0_0_0;
wire re_reg_SO_r0_0_0;
wire we_reg_SO_w0_0_144;
wire re_reg_SO_r0_0_144;
wire we_reg_SO_w0_0_288;
wire re_reg_SO_r0_0_288;
wire we_reg_SO_w0_0_432;
wire re_reg_SO_r0_0_432;

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

// ATPG logic: capture for non-data regs
wire dft_capdr_r = ary_atpg_ctl;


// ATPG logic: capture for non-data regs

wire [7:0] pre_Ra_reg_r0;

reg [7:0] Ra_reg_r0;
wire [7:0] Ra_reg_r0_A, Ra_reg_r0_B;
wire Ra_reg_r0_S;

assign Ra_reg_r0_S = (!debug_mode_sync);
assign Ra_reg_r0_A = pre_Ra_reg_r0;
assign Ra_reg_r0_B = mbist_Ra_r0;

always @(Ra_reg_r0_S or Ra_reg_r0_A or Ra_reg_r0_B)
case(Ra_reg_r0_S) // synopsys infer_mux
  1'b0 : Ra_reg_r0 = Ra_reg_r0_A;
  1'b1 : Ra_reg_r0 = Ra_reg_r0_B;
  default : Ra_reg_r0 = {8{`tick_x_or_0}};
endcase

wire [7:0] D_Ra_reg_r0;


reg [7:0] muxed_Ra_r0;
wire [7:0] muxed_Ra_r0_A, muxed_Ra_r0_B;
wire muxed_Ra_r0_S;

assign muxed_Ra_r0_S = debug_mode_sync | mbist_en_r;
assign muxed_Ra_r0_A = ra;
assign muxed_Ra_r0_B = Ra_reg_r0;

always @(muxed_Ra_r0_S or muxed_Ra_r0_A or muxed_Ra_r0_B)
case(muxed_Ra_r0_S) // synopsys infer_mux
  1'b0 : muxed_Ra_r0 = muxed_Ra_r0_A;
  1'b1 : muxed_Ra_r0 = muxed_Ra_r0_B;
  default : muxed_Ra_r0 = {8{`tick_x_or_0}};
endcase

assign D_Ra_reg_r0 = muxed_Ra_r0;

// verilint 110 off - Incompatible width
// verilint 630 off - Port connected to a NULL expression
// These are used for registering Ra in case of Latch arrays as well (i.e.
// used in functional path as well)
wire Ra_reg_SO_r0;
wire [7:0]radr_q;
assign pre_Ra_reg_r0 = radr_q ;

wire re_reg_r0_0_0;
wire access_en_r_0_0 = posedge_updateDR_sync & re_reg_r0_0_0;
reg access_en_r_1p_0_0;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_0 <= 1'b0;
  else 
     access_en_r_1p_0_0 <= access_en_r_0_0;

wire re_reg_r0_0_144;
wire access_en_r_0_144 = posedge_updateDR_sync & re_reg_r0_0_144;
reg access_en_r_1p_0_144;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_144 <= 1'b0;
  else 
     access_en_r_1p_0_144 <= access_en_r_0_144;

wire re_reg_r0_0_288;
wire access_en_r_0_288 = posedge_updateDR_sync & re_reg_r0_0_288;
reg access_en_r_1p_0_288;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_288 <= 1'b0;
  else 
     access_en_r_1p_0_288 <= access_en_r_0_288;

wire re_reg_r0_0_432;
wire access_en_r_0_432 = posedge_updateDR_sync & re_reg_r0_0_432;
reg access_en_r_1p_0_432;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_432 <= 1'b0;
  else 
     access_en_r_1p_0_432 <= access_en_r_0_432;

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

// ------------------  START PIECE ----------------------------------
// Suffix _0_0 : Piece RAMPDP_160X144_GL_M2_D2 (RamCell)
// Covers Addresses from 0 to 159  Addressrange: [7:0]  
// Data Bit range: [143:0] (144 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [7:0] cs_start_val_0_0;
assign cs_start_val_0_0 = 8'd0;

wire [7:0] cs_end_val_0_0;
assign cs_end_val_0_0 = 8'd159;

// verilint 498 on - Incompatible width





// Write Address bus

wire [7:0] wa_0_0;
assign wa_0_0 = muxed_Wa_w0[7:0];

// Write Data in bus
wire [143:0] Wdata_0_0;
assign Wdata_0_0 = muxed_Di_w0[143:0];
assign we_0_0 = we;

// Read Address bus
wire [7:0] ra_0_0;
assign ra_0_0 = muxed_Ra_r0[7:0];

// Read DataOut bus
wire [143:0] dout_0_0;
assign re_0_0 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_144 : Piece RAMPDP_160X144_GL_M2_D2 (RamCell)
// Covers Addresses from 0 to 159  Addressrange: [7:0]  
// Data Bit range: [287:144] (144 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [7:0] cs_start_val_0_144;
assign cs_start_val_0_144 = 8'd0;

wire [7:0] cs_end_val_0_144;
assign cs_end_val_0_144 = 8'd159;

// verilint 498 on - Incompatible width





// Write Address bus

wire [7:0] wa_0_144;
assign wa_0_144 = muxed_Wa_w0[7:0];

// Write Data in bus
wire [287:144] Wdata_0_144;
assign Wdata_0_144 = muxed_Di_w0[287:144];
assign we_0_144 = we;

// Read Address bus
wire [7:0] ra_0_144;
assign ra_0_144 = muxed_Ra_r0[7:0];

// Read DataOut bus
wire [287:144] dout_0_144;
assign re_0_144 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_288 : Piece RAMPDP_160X144_GL_M2_D2 (RamCell)
// Covers Addresses from 0 to 159  Addressrange: [7:0]  
// Data Bit range: [431:288] (144 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [7:0] cs_start_val_0_288;
assign cs_start_val_0_288 = 8'd0;

wire [7:0] cs_end_val_0_288;
assign cs_end_val_0_288 = 8'd159;

// verilint 498 on - Incompatible width





// Write Address bus

wire [7:0] wa_0_288;
assign wa_0_288 = muxed_Wa_w0[7:0];

// Write Data in bus
wire [431:288] Wdata_0_288;
assign Wdata_0_288 = muxed_Di_w0[431:288];
assign we_0_288 = we;

// Read Address bus
wire [7:0] ra_0_288;
assign ra_0_288 = muxed_Ra_r0[7:0];

// Read DataOut bus
wire [431:288] dout_0_288;
assign re_0_288 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_432 : Piece RAMPDP_160X82_GL_M2_D2 (RamCell)
// Covers Addresses from 0 to 159  Addressrange: [7:0]  
// Data Bit range: [513:432] (82 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [7:0] cs_start_val_0_432;
assign cs_start_val_0_432 = 8'd0;

wire [7:0] cs_end_val_0_432;
assign cs_end_val_0_432 = 8'd159;

// verilint 498 on - Incompatible width





// Write Address bus

wire [7:0] wa_0_432;
assign wa_0_432 = muxed_Wa_w0[7:0];

// Write Data in bus
wire [513:432] Wdata_0_432;
assign Wdata_0_432 = muxed_Di_w0[513:432];
assign we_0_432 = we;

// Read Address bus
wire [7:0] ra_0_432;
assign ra_0_432 = muxed_Ra_r0[7:0];

// Read DataOut bus
wire [513:432] dout_0_432;
assign re_0_432 = re;


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

// -----------------  begin Ram Cell RAMPDP_160X144_GL_M2_D2_0_0 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_0 = !(|muxed_we_w0_0_0) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_0 = muxed_re_r0_0_0 | ( scan_en & jtag_readonly_mode );
wire reb_0_0 = !piece_re_0_0;
// Declare the ramOutData which connects to the ram directly
wire [143:0] ramDataOut_0_0;
assign dout_0_0[143:0] = ramDataOut_0_0[143:0];
RAMPDP_160X144_GL_M2_D2 ram_Inst_160X144_0_0 (
                                                .CLK             (gated_clk_core_0_0)
                                              , .WADR_7          (wa_0_0[7])
                                              , .WADR_6          (wa_0_0[6])
                                              , .WADR_5          (wa_0_0[5])
                                              , .WADR_4          (wa_0_0[4])
                                              , .WADR_3          (wa_0_0[3])
                                              , .WADR_2          (wa_0_0[2])
                                              , .WADR_1          (wa_0_0[1])
                                              , .WADR_0          (wa_0_0[0])
                                              , .WD_143          (Wdata_0_0[143])
                                              , .WD_142          (Wdata_0_0[142])
                                              , .WD_141          (Wdata_0_0[141])
                                              , .WD_140          (Wdata_0_0[140])
                                              , .WD_139          (Wdata_0_0[139])
                                              , .WD_138          (Wdata_0_0[138])
                                              , .WD_137          (Wdata_0_0[137])
                                              , .WD_136          (Wdata_0_0[136])
                                              , .WD_135          (Wdata_0_0[135])
                                              , .WD_134          (Wdata_0_0[134])
                                              , .WD_133          (Wdata_0_0[133])
                                              , .WD_132          (Wdata_0_0[132])
                                              , .WD_131          (Wdata_0_0[131])
                                              , .WD_130          (Wdata_0_0[130])
                                              , .WD_129          (Wdata_0_0[129])
                                              , .WD_128          (Wdata_0_0[128])
                                              , .WD_127          (Wdata_0_0[127])
                                              , .WD_126          (Wdata_0_0[126])
                                              , .WD_125          (Wdata_0_0[125])
                                              , .WD_124          (Wdata_0_0[124])
                                              , .WD_123          (Wdata_0_0[123])
                                              , .WD_122          (Wdata_0_0[122])
                                              , .WD_121          (Wdata_0_0[121])
                                              , .WD_120          (Wdata_0_0[120])
                                              , .WD_119          (Wdata_0_0[119])
                                              , .WD_118          (Wdata_0_0[118])
                                              , .WD_117          (Wdata_0_0[117])
                                              , .WD_116          (Wdata_0_0[116])
                                              , .WD_115          (Wdata_0_0[115])
                                              , .WD_114          (Wdata_0_0[114])
                                              , .WD_113          (Wdata_0_0[113])
                                              , .WD_112          (Wdata_0_0[112])
                                              , .WD_111          (Wdata_0_0[111])
                                              , .WD_110          (Wdata_0_0[110])
                                              , .WD_109          (Wdata_0_0[109])
                                              , .WD_108          (Wdata_0_0[108])
                                              , .WD_107          (Wdata_0_0[107])
                                              , .WD_106          (Wdata_0_0[106])
                                              , .WD_105          (Wdata_0_0[105])
                                              , .WD_104          (Wdata_0_0[104])
                                              , .WD_103          (Wdata_0_0[103])
                                              , .WD_102          (Wdata_0_0[102])
                                              , .WD_101          (Wdata_0_0[101])
                                              , .WD_100          (Wdata_0_0[100])
                                              , .WD_99           (Wdata_0_0[99])
                                              , .WD_98           (Wdata_0_0[98])
                                              , .WD_97           (Wdata_0_0[97])
                                              , .WD_96           (Wdata_0_0[96])
                                              , .WD_95           (Wdata_0_0[95])
                                              , .WD_94           (Wdata_0_0[94])
                                              , .WD_93           (Wdata_0_0[93])
                                              , .WD_92           (Wdata_0_0[92])
                                              , .WD_91           (Wdata_0_0[91])
                                              , .WD_90           (Wdata_0_0[90])
                                              , .WD_89           (Wdata_0_0[89])
                                              , .WD_88           (Wdata_0_0[88])
                                              , .WD_87           (Wdata_0_0[87])
                                              , .WD_86           (Wdata_0_0[86])
                                              , .WD_85           (Wdata_0_0[85])
                                              , .WD_84           (Wdata_0_0[84])
                                              , .WD_83           (Wdata_0_0[83])
                                              , .WD_82           (Wdata_0_0[82])
                                              , .WD_81           (Wdata_0_0[81])
                                              , .WD_80           (Wdata_0_0[80])
                                              , .WD_79           (Wdata_0_0[79])
                                              , .WD_78           (Wdata_0_0[78])
                                              , .WD_77           (Wdata_0_0[77])
                                              , .WD_76           (Wdata_0_0[76])
                                              , .WD_75           (Wdata_0_0[75])
                                              , .WD_74           (Wdata_0_0[74])
                                              , .WD_73           (Wdata_0_0[73])
                                              , .WD_72           (Wdata_0_0[72])
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
                                              , .RADR_7          (ra_0_0 [7] & !test_mode)
                                              , .RADR_6          (ra_0_0 [6])
                                              , .RADR_5          (ra_0_0 [5])
                                              , .RADR_4          (ra_0_0 [4])
                                              , .RADR_3          (ra_0_0 [3])
                                              , .RADR_2          (ra_0_0 [2])
                                              , .RADR_1          (ra_0_0 [1])
                                              , .RADR_0          (ra_0_0 [0])
                                              , .RE              (!reb_0_0)
                                              , .RD_143          (ramDataOut_0_0[143])
                                              , .RD_142          (ramDataOut_0_0[142])
                                              , .RD_141          (ramDataOut_0_0[141])
                                              , .RD_140          (ramDataOut_0_0[140])
                                              , .RD_139          (ramDataOut_0_0[139])
                                              , .RD_138          (ramDataOut_0_0[138])
                                              , .RD_137          (ramDataOut_0_0[137])
                                              , .RD_136          (ramDataOut_0_0[136])
                                              , .RD_135          (ramDataOut_0_0[135])
                                              , .RD_134          (ramDataOut_0_0[134])
                                              , .RD_133          (ramDataOut_0_0[133])
                                              , .RD_132          (ramDataOut_0_0[132])
                                              , .RD_131          (ramDataOut_0_0[131])
                                              , .RD_130          (ramDataOut_0_0[130])
                                              , .RD_129          (ramDataOut_0_0[129])
                                              , .RD_128          (ramDataOut_0_0[128])
                                              , .RD_127          (ramDataOut_0_0[127])
                                              , .RD_126          (ramDataOut_0_0[126])
                                              , .RD_125          (ramDataOut_0_0[125])
                                              , .RD_124          (ramDataOut_0_0[124])
                                              , .RD_123          (ramDataOut_0_0[123])
                                              , .RD_122          (ramDataOut_0_0[122])
                                              , .RD_121          (ramDataOut_0_0[121])
                                              , .RD_120          (ramDataOut_0_0[120])
                                              , .RD_119          (ramDataOut_0_0[119])
                                              , .RD_118          (ramDataOut_0_0[118])
                                              , .RD_117          (ramDataOut_0_0[117])
                                              , .RD_116          (ramDataOut_0_0[116])
                                              , .RD_115          (ramDataOut_0_0[115])
                                              , .RD_114          (ramDataOut_0_0[114])
                                              , .RD_113          (ramDataOut_0_0[113])
                                              , .RD_112          (ramDataOut_0_0[112])
                                              , .RD_111          (ramDataOut_0_0[111])
                                              , .RD_110          (ramDataOut_0_0[110])
                                              , .RD_109          (ramDataOut_0_0[109])
                                              , .RD_108          (ramDataOut_0_0[108])
                                              , .RD_107          (ramDataOut_0_0[107])
                                              , .RD_106          (ramDataOut_0_0[106])
                                              , .RD_105          (ramDataOut_0_0[105])
                                              , .RD_104          (ramDataOut_0_0[104])
                                              , .RD_103          (ramDataOut_0_0[103])
                                              , .RD_102          (ramDataOut_0_0[102])
                                              , .RD_101          (ramDataOut_0_0[101])
                                              , .RD_100          (ramDataOut_0_0[100])
                                              , .RD_99           (ramDataOut_0_0[99])
                                              , .RD_98           (ramDataOut_0_0[98])
                                              , .RD_97           (ramDataOut_0_0[97])
                                              , .RD_96           (ramDataOut_0_0[96])
                                              , .RD_95           (ramDataOut_0_0[95])
                                              , .RD_94           (ramDataOut_0_0[94])
                                              , .RD_93           (ramDataOut_0_0[93])
                                              , .RD_92           (ramDataOut_0_0[92])
                                              , .RD_91           (ramDataOut_0_0[91])
                                              , .RD_90           (ramDataOut_0_0[90])
                                              , .RD_89           (ramDataOut_0_0[89])
                                              , .RD_88           (ramDataOut_0_0[88])
                                              , .RD_87           (ramDataOut_0_0[87])
                                              , .RD_86           (ramDataOut_0_0[86])
                                              , .RD_85           (ramDataOut_0_0[85])
                                              , .RD_84           (ramDataOut_0_0[84])
                                              , .RD_83           (ramDataOut_0_0[83])
                                              , .RD_82           (ramDataOut_0_0[82])
                                              , .RD_81           (ramDataOut_0_0[81])
                                              , .RD_80           (ramDataOut_0_0[80])
                                              , .RD_79           (ramDataOut_0_0[79])
                                              , .RD_78           (ramDataOut_0_0[78])
                                              , .RD_77           (ramDataOut_0_0[77])
                                              , .RD_76           (ramDataOut_0_0[76])
                                              , .RD_75           (ramDataOut_0_0[75])
                                              , .RD_74           (ramDataOut_0_0[74])
                                              , .RD_73           (ramDataOut_0_0[73])
                                              , .RD_72           (ramDataOut_0_0[72])
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

// -----------------  begin Ram Cell RAMPDP_160X144_GL_M2_D2_0_144 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_144 = !(|muxed_we_w0_0_144) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_144 = muxed_re_r0_0_144 | ( scan_en & jtag_readonly_mode );
wire reb_0_144 = !piece_re_0_144;
// Declare the ramOutData which connects to the ram directly
wire [287:144] ramDataOut_0_144;
assign dout_0_144[287:144] = ramDataOut_0_144[287:144];
RAMPDP_160X144_GL_M2_D2 ram_Inst_160X144_0_144 (
                                                  .CLK             (gated_clk_core_0_144)
                                                , .WADR_7          (wa_0_144[7])
                                                , .WADR_6          (wa_0_144[6])
                                                , .WADR_5          (wa_0_144[5])
                                                , .WADR_4          (wa_0_144[4])
                                                , .WADR_3          (wa_0_144[3])
                                                , .WADR_2          (wa_0_144[2])
                                                , .WADR_1          (wa_0_144[1])
                                                , .WADR_0          (wa_0_144[0])
                                                , .WD_143          (Wdata_0_144[287])
                                                , .WD_142          (Wdata_0_144[286])
                                                , .WD_141          (Wdata_0_144[285])
                                                , .WD_140          (Wdata_0_144[284])
                                                , .WD_139          (Wdata_0_144[283])
                                                , .WD_138          (Wdata_0_144[282])
                                                , .WD_137          (Wdata_0_144[281])
                                                , .WD_136          (Wdata_0_144[280])
                                                , .WD_135          (Wdata_0_144[279])
                                                , .WD_134          (Wdata_0_144[278])
                                                , .WD_133          (Wdata_0_144[277])
                                                , .WD_132          (Wdata_0_144[276])
                                                , .WD_131          (Wdata_0_144[275])
                                                , .WD_130          (Wdata_0_144[274])
                                                , .WD_129          (Wdata_0_144[273])
                                                , .WD_128          (Wdata_0_144[272])
                                                , .WD_127          (Wdata_0_144[271])
                                                , .WD_126          (Wdata_0_144[270])
                                                , .WD_125          (Wdata_0_144[269])
                                                , .WD_124          (Wdata_0_144[268])
                                                , .WD_123          (Wdata_0_144[267])
                                                , .WD_122          (Wdata_0_144[266])
                                                , .WD_121          (Wdata_0_144[265])
                                                , .WD_120          (Wdata_0_144[264])
                                                , .WD_119          (Wdata_0_144[263])
                                                , .WD_118          (Wdata_0_144[262])
                                                , .WD_117          (Wdata_0_144[261])
                                                , .WD_116          (Wdata_0_144[260])
                                                , .WD_115          (Wdata_0_144[259])
                                                , .WD_114          (Wdata_0_144[258])
                                                , .WD_113          (Wdata_0_144[257])
                                                , .WD_112          (Wdata_0_144[256])
                                                , .WD_111          (Wdata_0_144[255])
                                                , .WD_110          (Wdata_0_144[254])
                                                , .WD_109          (Wdata_0_144[253])
                                                , .WD_108          (Wdata_0_144[252])
                                                , .WD_107          (Wdata_0_144[251])
                                                , .WD_106          (Wdata_0_144[250])
                                                , .WD_105          (Wdata_0_144[249])
                                                , .WD_104          (Wdata_0_144[248])
                                                , .WD_103          (Wdata_0_144[247])
                                                , .WD_102          (Wdata_0_144[246])
                                                , .WD_101          (Wdata_0_144[245])
                                                , .WD_100          (Wdata_0_144[244])
                                                , .WD_99           (Wdata_0_144[243])
                                                , .WD_98           (Wdata_0_144[242])
                                                , .WD_97           (Wdata_0_144[241])
                                                , .WD_96           (Wdata_0_144[240])
                                                , .WD_95           (Wdata_0_144[239])
                                                , .WD_94           (Wdata_0_144[238])
                                                , .WD_93           (Wdata_0_144[237])
                                                , .WD_92           (Wdata_0_144[236])
                                                , .WD_91           (Wdata_0_144[235])
                                                , .WD_90           (Wdata_0_144[234])
                                                , .WD_89           (Wdata_0_144[233])
                                                , .WD_88           (Wdata_0_144[232])
                                                , .WD_87           (Wdata_0_144[231])
                                                , .WD_86           (Wdata_0_144[230])
                                                , .WD_85           (Wdata_0_144[229])
                                                , .WD_84           (Wdata_0_144[228])
                                                , .WD_83           (Wdata_0_144[227])
                                                , .WD_82           (Wdata_0_144[226])
                                                , .WD_81           (Wdata_0_144[225])
                                                , .WD_80           (Wdata_0_144[224])
                                                , .WD_79           (Wdata_0_144[223])
                                                , .WD_78           (Wdata_0_144[222])
                                                , .WD_77           (Wdata_0_144[221])
                                                , .WD_76           (Wdata_0_144[220])
                                                , .WD_75           (Wdata_0_144[219])
                                                , .WD_74           (Wdata_0_144[218])
                                                , .WD_73           (Wdata_0_144[217])
                                                , .WD_72           (Wdata_0_144[216])
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
                                                , .RADR_7          (ra_0_144 [7] & !test_mode)
                                                , .RADR_6          (ra_0_144 [6])
                                                , .RADR_5          (ra_0_144 [5])
                                                , .RADR_4          (ra_0_144 [4])
                                                , .RADR_3          (ra_0_144 [3])
                                                , .RADR_2          (ra_0_144 [2])
                                                , .RADR_1          (ra_0_144 [1])
                                                , .RADR_0          (ra_0_144 [0])
                                                , .RE              (!reb_0_144)
                                                , .RD_143          (ramDataOut_0_144[287])
                                                , .RD_142          (ramDataOut_0_144[286])
                                                , .RD_141          (ramDataOut_0_144[285])
                                                , .RD_140          (ramDataOut_0_144[284])
                                                , .RD_139          (ramDataOut_0_144[283])
                                                , .RD_138          (ramDataOut_0_144[282])
                                                , .RD_137          (ramDataOut_0_144[281])
                                                , .RD_136          (ramDataOut_0_144[280])
                                                , .RD_135          (ramDataOut_0_144[279])
                                                , .RD_134          (ramDataOut_0_144[278])
                                                , .RD_133          (ramDataOut_0_144[277])
                                                , .RD_132          (ramDataOut_0_144[276])
                                                , .RD_131          (ramDataOut_0_144[275])
                                                , .RD_130          (ramDataOut_0_144[274])
                                                , .RD_129          (ramDataOut_0_144[273])
                                                , .RD_128          (ramDataOut_0_144[272])
                                                , .RD_127          (ramDataOut_0_144[271])
                                                , .RD_126          (ramDataOut_0_144[270])
                                                , .RD_125          (ramDataOut_0_144[269])
                                                , .RD_124          (ramDataOut_0_144[268])
                                                , .RD_123          (ramDataOut_0_144[267])
                                                , .RD_122          (ramDataOut_0_144[266])
                                                , .RD_121          (ramDataOut_0_144[265])
                                                , .RD_120          (ramDataOut_0_144[264])
                                                , .RD_119          (ramDataOut_0_144[263])
                                                , .RD_118          (ramDataOut_0_144[262])
                                                , .RD_117          (ramDataOut_0_144[261])
                                                , .RD_116          (ramDataOut_0_144[260])
                                                , .RD_115          (ramDataOut_0_144[259])
                                                , .RD_114          (ramDataOut_0_144[258])
                                                , .RD_113          (ramDataOut_0_144[257])
                                                , .RD_112          (ramDataOut_0_144[256])
                                                , .RD_111          (ramDataOut_0_144[255])
                                                , .RD_110          (ramDataOut_0_144[254])
                                                , .RD_109          (ramDataOut_0_144[253])
                                                , .RD_108          (ramDataOut_0_144[252])
                                                , .RD_107          (ramDataOut_0_144[251])
                                                , .RD_106          (ramDataOut_0_144[250])
                                                , .RD_105          (ramDataOut_0_144[249])
                                                , .RD_104          (ramDataOut_0_144[248])
                                                , .RD_103          (ramDataOut_0_144[247])
                                                , .RD_102          (ramDataOut_0_144[246])
                                                , .RD_101          (ramDataOut_0_144[245])
                                                , .RD_100          (ramDataOut_0_144[244])
                                                , .RD_99           (ramDataOut_0_144[243])
                                                , .RD_98           (ramDataOut_0_144[242])
                                                , .RD_97           (ramDataOut_0_144[241])
                                                , .RD_96           (ramDataOut_0_144[240])
                                                , .RD_95           (ramDataOut_0_144[239])
                                                , .RD_94           (ramDataOut_0_144[238])
                                                , .RD_93           (ramDataOut_0_144[237])
                                                , .RD_92           (ramDataOut_0_144[236])
                                                , .RD_91           (ramDataOut_0_144[235])
                                                , .RD_90           (ramDataOut_0_144[234])
                                                , .RD_89           (ramDataOut_0_144[233])
                                                , .RD_88           (ramDataOut_0_144[232])
                                                , .RD_87           (ramDataOut_0_144[231])
                                                , .RD_86           (ramDataOut_0_144[230])
                                                , .RD_85           (ramDataOut_0_144[229])
                                                , .RD_84           (ramDataOut_0_144[228])
                                                , .RD_83           (ramDataOut_0_144[227])
                                                , .RD_82           (ramDataOut_0_144[226])
                                                , .RD_81           (ramDataOut_0_144[225])
                                                , .RD_80           (ramDataOut_0_144[224])
                                                , .RD_79           (ramDataOut_0_144[223])
                                                , .RD_78           (ramDataOut_0_144[222])
                                                , .RD_77           (ramDataOut_0_144[221])
                                                , .RD_76           (ramDataOut_0_144[220])
                                                , .RD_75           (ramDataOut_0_144[219])
                                                , .RD_74           (ramDataOut_0_144[218])
                                                , .RD_73           (ramDataOut_0_144[217])
                                                , .RD_72           (ramDataOut_0_144[216])
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

// -----------------  begin Ram Cell RAMPDP_160X144_GL_M2_D2_0_288 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_288 = !(|muxed_we_w0_0_288) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_288 = muxed_re_r0_0_288 | ( scan_en & jtag_readonly_mode );
wire reb_0_288 = !piece_re_0_288;
// Declare the ramOutData which connects to the ram directly
wire [431:288] ramDataOut_0_288;
assign dout_0_288[431:288] = ramDataOut_0_288[431:288];
RAMPDP_160X144_GL_M2_D2 ram_Inst_160X144_0_288 (
                                                  .CLK             (gated_clk_core_0_288)
                                                , .WADR_7          (wa_0_288[7])
                                                , .WADR_6          (wa_0_288[6])
                                                , .WADR_5          (wa_0_288[5])
                                                , .WADR_4          (wa_0_288[4])
                                                , .WADR_3          (wa_0_288[3])
                                                , .WADR_2          (wa_0_288[2])
                                                , .WADR_1          (wa_0_288[1])
                                                , .WADR_0          (wa_0_288[0])
                                                , .WD_143          (Wdata_0_288[431])
                                                , .WD_142          (Wdata_0_288[430])
                                                , .WD_141          (Wdata_0_288[429])
                                                , .WD_140          (Wdata_0_288[428])
                                                , .WD_139          (Wdata_0_288[427])
                                                , .WD_138          (Wdata_0_288[426])
                                                , .WD_137          (Wdata_0_288[425])
                                                , .WD_136          (Wdata_0_288[424])
                                                , .WD_135          (Wdata_0_288[423])
                                                , .WD_134          (Wdata_0_288[422])
                                                , .WD_133          (Wdata_0_288[421])
                                                , .WD_132          (Wdata_0_288[420])
                                                , .WD_131          (Wdata_0_288[419])
                                                , .WD_130          (Wdata_0_288[418])
                                                , .WD_129          (Wdata_0_288[417])
                                                , .WD_128          (Wdata_0_288[416])
                                                , .WD_127          (Wdata_0_288[415])
                                                , .WD_126          (Wdata_0_288[414])
                                                , .WD_125          (Wdata_0_288[413])
                                                , .WD_124          (Wdata_0_288[412])
                                                , .WD_123          (Wdata_0_288[411])
                                                , .WD_122          (Wdata_0_288[410])
                                                , .WD_121          (Wdata_0_288[409])
                                                , .WD_120          (Wdata_0_288[408])
                                                , .WD_119          (Wdata_0_288[407])
                                                , .WD_118          (Wdata_0_288[406])
                                                , .WD_117          (Wdata_0_288[405])
                                                , .WD_116          (Wdata_0_288[404])
                                                , .WD_115          (Wdata_0_288[403])
                                                , .WD_114          (Wdata_0_288[402])
                                                , .WD_113          (Wdata_0_288[401])
                                                , .WD_112          (Wdata_0_288[400])
                                                , .WD_111          (Wdata_0_288[399])
                                                , .WD_110          (Wdata_0_288[398])
                                                , .WD_109          (Wdata_0_288[397])
                                                , .WD_108          (Wdata_0_288[396])
                                                , .WD_107          (Wdata_0_288[395])
                                                , .WD_106          (Wdata_0_288[394])
                                                , .WD_105          (Wdata_0_288[393])
                                                , .WD_104          (Wdata_0_288[392])
                                                , .WD_103          (Wdata_0_288[391])
                                                , .WD_102          (Wdata_0_288[390])
                                                , .WD_101          (Wdata_0_288[389])
                                                , .WD_100          (Wdata_0_288[388])
                                                , .WD_99           (Wdata_0_288[387])
                                                , .WD_98           (Wdata_0_288[386])
                                                , .WD_97           (Wdata_0_288[385])
                                                , .WD_96           (Wdata_0_288[384])
                                                , .WD_95           (Wdata_0_288[383])
                                                , .WD_94           (Wdata_0_288[382])
                                                , .WD_93           (Wdata_0_288[381])
                                                , .WD_92           (Wdata_0_288[380])
                                                , .WD_91           (Wdata_0_288[379])
                                                , .WD_90           (Wdata_0_288[378])
                                                , .WD_89           (Wdata_0_288[377])
                                                , .WD_88           (Wdata_0_288[376])
                                                , .WD_87           (Wdata_0_288[375])
                                                , .WD_86           (Wdata_0_288[374])
                                                , .WD_85           (Wdata_0_288[373])
                                                , .WD_84           (Wdata_0_288[372])
                                                , .WD_83           (Wdata_0_288[371])
                                                , .WD_82           (Wdata_0_288[370])
                                                , .WD_81           (Wdata_0_288[369])
                                                , .WD_80           (Wdata_0_288[368])
                                                , .WD_79           (Wdata_0_288[367])
                                                , .WD_78           (Wdata_0_288[366])
                                                , .WD_77           (Wdata_0_288[365])
                                                , .WD_76           (Wdata_0_288[364])
                                                , .WD_75           (Wdata_0_288[363])
                                                , .WD_74           (Wdata_0_288[362])
                                                , .WD_73           (Wdata_0_288[361])
                                                , .WD_72           (Wdata_0_288[360])
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
                                                , .RADR_7          (ra_0_288 [7] & !test_mode)
                                                , .RADR_6          (ra_0_288 [6])
                                                , .RADR_5          (ra_0_288 [5])
                                                , .RADR_4          (ra_0_288 [4])
                                                , .RADR_3          (ra_0_288 [3])
                                                , .RADR_2          (ra_0_288 [2])
                                                , .RADR_1          (ra_0_288 [1])
                                                , .RADR_0          (ra_0_288 [0])
                                                , .RE              (!reb_0_288)
                                                , .RD_143          (ramDataOut_0_288[431])
                                                , .RD_142          (ramDataOut_0_288[430])
                                                , .RD_141          (ramDataOut_0_288[429])
                                                , .RD_140          (ramDataOut_0_288[428])
                                                , .RD_139          (ramDataOut_0_288[427])
                                                , .RD_138          (ramDataOut_0_288[426])
                                                , .RD_137          (ramDataOut_0_288[425])
                                                , .RD_136          (ramDataOut_0_288[424])
                                                , .RD_135          (ramDataOut_0_288[423])
                                                , .RD_134          (ramDataOut_0_288[422])
                                                , .RD_133          (ramDataOut_0_288[421])
                                                , .RD_132          (ramDataOut_0_288[420])
                                                , .RD_131          (ramDataOut_0_288[419])
                                                , .RD_130          (ramDataOut_0_288[418])
                                                , .RD_129          (ramDataOut_0_288[417])
                                                , .RD_128          (ramDataOut_0_288[416])
                                                , .RD_127          (ramDataOut_0_288[415])
                                                , .RD_126          (ramDataOut_0_288[414])
                                                , .RD_125          (ramDataOut_0_288[413])
                                                , .RD_124          (ramDataOut_0_288[412])
                                                , .RD_123          (ramDataOut_0_288[411])
                                                , .RD_122          (ramDataOut_0_288[410])
                                                , .RD_121          (ramDataOut_0_288[409])
                                                , .RD_120          (ramDataOut_0_288[408])
                                                , .RD_119          (ramDataOut_0_288[407])
                                                , .RD_118          (ramDataOut_0_288[406])
                                                , .RD_117          (ramDataOut_0_288[405])
                                                , .RD_116          (ramDataOut_0_288[404])
                                                , .RD_115          (ramDataOut_0_288[403])
                                                , .RD_114          (ramDataOut_0_288[402])
                                                , .RD_113          (ramDataOut_0_288[401])
                                                , .RD_112          (ramDataOut_0_288[400])
                                                , .RD_111          (ramDataOut_0_288[399])
                                                , .RD_110          (ramDataOut_0_288[398])
                                                , .RD_109          (ramDataOut_0_288[397])
                                                , .RD_108          (ramDataOut_0_288[396])
                                                , .RD_107          (ramDataOut_0_288[395])
                                                , .RD_106          (ramDataOut_0_288[394])
                                                , .RD_105          (ramDataOut_0_288[393])
                                                , .RD_104          (ramDataOut_0_288[392])
                                                , .RD_103          (ramDataOut_0_288[391])
                                                , .RD_102          (ramDataOut_0_288[390])
                                                , .RD_101          (ramDataOut_0_288[389])
                                                , .RD_100          (ramDataOut_0_288[388])
                                                , .RD_99           (ramDataOut_0_288[387])
                                                , .RD_98           (ramDataOut_0_288[386])
                                                , .RD_97           (ramDataOut_0_288[385])
                                                , .RD_96           (ramDataOut_0_288[384])
                                                , .RD_95           (ramDataOut_0_288[383])
                                                , .RD_94           (ramDataOut_0_288[382])
                                                , .RD_93           (ramDataOut_0_288[381])
                                                , .RD_92           (ramDataOut_0_288[380])
                                                , .RD_91           (ramDataOut_0_288[379])
                                                , .RD_90           (ramDataOut_0_288[378])
                                                , .RD_89           (ramDataOut_0_288[377])
                                                , .RD_88           (ramDataOut_0_288[376])
                                                , .RD_87           (ramDataOut_0_288[375])
                                                , .RD_86           (ramDataOut_0_288[374])
                                                , .RD_85           (ramDataOut_0_288[373])
                                                , .RD_84           (ramDataOut_0_288[372])
                                                , .RD_83           (ramDataOut_0_288[371])
                                                , .RD_82           (ramDataOut_0_288[370])
                                                , .RD_81           (ramDataOut_0_288[369])
                                                , .RD_80           (ramDataOut_0_288[368])
                                                , .RD_79           (ramDataOut_0_288[367])
                                                , .RD_78           (ramDataOut_0_288[366])
                                                , .RD_77           (ramDataOut_0_288[365])
                                                , .RD_76           (ramDataOut_0_288[364])
                                                , .RD_75           (ramDataOut_0_288[363])
                                                , .RD_74           (ramDataOut_0_288[362])
                                                , .RD_73           (ramDataOut_0_288[361])
                                                , .RD_72           (ramDataOut_0_288[360])
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

// -----------------  begin Ram Cell RAMPDP_160X82_GL_M2_D2_0_432 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_432 = !(|muxed_we_w0_0_432) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_432 = muxed_re_r0_0_432 | ( scan_en & jtag_readonly_mode );
wire reb_0_432 = !piece_re_0_432;
// Declare the ramOutData which connects to the ram directly
wire [513:432] ramDataOut_0_432;
assign dout_0_432[513:432] = ramDataOut_0_432[513:432];
RAMPDP_160X82_GL_M2_D2 ram_Inst_160X82_0_432 (
                                                .CLK             (gated_clk_core_0_432)
                                              , .WADR_7          (wa_0_432[7])
                                              , .WADR_6          (wa_0_432[6])
                                              , .WADR_5          (wa_0_432[5])
                                              , .WADR_4          (wa_0_432[4])
                                              , .WADR_3          (wa_0_432[3])
                                              , .WADR_2          (wa_0_432[2])
                                              , .WADR_1          (wa_0_432[1])
                                              , .WADR_0          (wa_0_432[0])
                                              , .WD_81           (Wdata_0_432[513])
                                              , .WD_80           (Wdata_0_432[512])
                                              , .WD_79           (Wdata_0_432[511])
                                              , .WD_78           (Wdata_0_432[510])
                                              , .WD_77           (Wdata_0_432[509])
                                              , .WD_76           (Wdata_0_432[508])
                                              , .WD_75           (Wdata_0_432[507])
                                              , .WD_74           (Wdata_0_432[506])
                                              , .WD_73           (Wdata_0_432[505])
                                              , .WD_72           (Wdata_0_432[504])
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
                                              , .RADR_7          (ra_0_432 [7] & !test_mode)
                                              , .RADR_6          (ra_0_432 [6])
                                              , .RADR_5          (ra_0_432 [5])
                                              , .RADR_4          (ra_0_432 [4])
                                              , .RADR_3          (ra_0_432 [3])
                                              , .RADR_2          (ra_0_432 [2])
                                              , .RADR_1          (ra_0_432 [1])
                                              , .RADR_0          (ra_0_432 [0])
                                              , .RE              (!reb_0_432)
                                              , .RD_81           (ramDataOut_0_432[513])
                                              , .RD_80           (ramDataOut_0_432[512])
                                              , .RD_79           (ramDataOut_0_432[511])
                                              , .RD_78           (ramDataOut_0_432[510])
                                              , .RD_77           (ramDataOut_0_432[509])
                                              , .RD_76           (ramDataOut_0_432[508])
                                              , .RD_75           (ramDataOut_0_432[507])
                                              , .RD_74           (ramDataOut_0_432[506])
                                              , .RD_73           (ramDataOut_0_432[505])
                                              , .RD_72           (ramDataOut_0_432[504])
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

// --------------------------------------------- 

// Declare the interface wires for Output Mux logic


// verilint 552 off - Different bits of a net are driven in different blocks (harmless, 
// but some synthesis tools generate a warning for this)
reg [513:0] ram_r0_OutputMuxDataOut;

//For bitEnd 143, only one piece RAMPDP_160X144_GL_M2_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_0[143:0] or muxed_Di_w0[143:0] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[143:0] = (ram_bypass) ? muxed_Di_w0[143:0]: dout_0_0;
end
assign r0_OutputMuxDataOut[143:0] = ram_r0_OutputMuxDataOut[143:0];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 287, only one piece RAMPDP_160X144_GL_M2_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_144[287:144] or muxed_Di_w0[287:144] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[287:144] = (ram_bypass) ? muxed_Di_w0[287:144]: dout_0_144;
end
assign r0_OutputMuxDataOut[287:144] = ram_r0_OutputMuxDataOut[287:144];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 431, only one piece RAMPDP_160X144_GL_M2_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_288[431:288] or muxed_Di_w0[431:288] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[431:288] = (ram_bypass) ? muxed_Di_w0[431:288]: dout_0_288;
end
assign r0_OutputMuxDataOut[431:288] = ram_r0_OutputMuxDataOut[431:288];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 513, only one piece RAMPDP_160X82_GL_M2_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_432[513:432] or muxed_Di_w0[513:432] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[513:432] = (ram_bypass) ? muxed_Di_w0[513:432]: dout_0_432;
end
assign r0_OutputMuxDataOut[513:432] = ram_r0_OutputMuxDataOut[513:432];
// verilint 17 on - Range (rather than full vector) in the sensitivity list



// --------------------- Output Mbist Interface logic  -------------

reg mbist_ce_r0_0_0_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_0_1p <= mbist_ce_r0_0_0;
reg mbist_ce_r0_0_144_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_144_1p <= mbist_ce_r0_0_144;
reg mbist_ce_r0_0_288_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_288_1p <= mbist_ce_r0_0_288;
reg mbist_ce_r0_0_432_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_432_1p <= mbist_ce_r0_0_432;
wire captureDR_r0 = dft_capdr_r | ((((ore)) & !mbist_en_r & !debug_mode_sync) || ( debug_mode_sync ? (1'b1& (access_en_r_1p_0_0 | access_en_r_1p_0_144 | access_en_r_1p_0_288 | access_en_r_1p_0_432)) :  ((mbist_en_r & (mbist_ce_r0_0_0_1p | mbist_ce_r0_0_144_1p | mbist_ce_r0_0_288_1p | mbist_ce_r0_0_432_1p) & !1'b0))));
////MSB 513 LSB 0  and total rambit is 514 and  dsize is 514

wire Data_reg_SO_r0;
// verilint 110 off - Incompatible width
// verilint 630 off - Port connected to a NULL expression
// These are used for registering Ra in case of Latch arrays as well (i.e. 
// used in functional path as well)
wire [513:0]data_regq;
assign Data_reg_r0[513:0] = data_regq[513:0] ;

// verilint 110 on - Incompatible width
// verilint 630 on - Port connected to a NULL expression
assign dout = Data_reg_r0;

assign mbist_Do_r0_int_net = Data_reg_r0[514-1:0];

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
    
ScanShareSel_JTAG_reg_ext_cg #(8, 0, 0) testInst_Wa_reg_w0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_Wa_w0), .Q(wadr_q),
            .scanin(SI), .scanout(Wa_reg_SO_w0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_0), .Q(we_0_0_q),
            .scanin(Wa_reg_SO_w0), .scanout(we_reg_SO_w0_0_0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_144 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_144), .Q(we_0_144_q),
            .scanin(we_reg_SO_w0_0_0), .scanout(we_reg_SO_w0_0_144)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_288 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_288), .Q(we_0_288_q),
            .scanin(we_reg_SO_w0_0_144), .scanout(we_reg_SO_w0_0_288)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_432 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_432), .Q(we_0_432_q),
            .scanin(we_reg_SO_w0_0_288), .scanout(we_reg_SO_w0_0_432)  );
    
ScanShareSel_JTAG_reg_ext_cg #(8, 0, 0) testInst_Ra_reg_r0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_Ra_r0), .Q(radr_q),
            .scanin(we_reg_SO_w0_0_432), .scanout(Ra_reg_SO_r0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_0), .Q(re_0_0_q),
            .scanin(Ra_reg_SO_r0), .scanout(re_reg_SO_r0_0_0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_144 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_144), .Q(re_0_144_q),
            .scanin(re_reg_SO_r0_0_0), .scanout(re_reg_SO_r0_0_144)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_288 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_288), .Q(re_0_288_q),
            .scanin(re_reg_SO_r0_0_144), .scanout(re_reg_SO_r0_0_288)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_432 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_432), .Q(re_0_432_q),
            .scanin(re_reg_SO_r0_0_288), .scanout(re_reg_SO_r0_0_432)  );
wire gated_clk_jtag_Data_reg_r0;
CKLNQD12PO4  UJ_clk_jtag_Data_reg_r0 (.Q(gated_clk_jtag_Data_reg_r0), .CP(clk), .E(captureDR_r0 | (debug_mode_sync & shiftDR)), .TE(scan_en));
wire [513:0] Data_reg_r0_D = r0_OutputMuxDataOut[513:0];
wire [513:0] Data_reg_r0_Q;
assign data_regq[513:0] = Data_reg_r0_Q;
wire so_Data_reg_r0_513_258;

ScanShareSel_JTAG_reg_ext_cg #(256, 0, 0) testInst_Data_reg_r0_513_258 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[513:258]), .Q(Data_reg_r0_Q[513:258]),
            .scanin(re_reg_SO_r0_0_432), .scanout(so_Data_reg_r0_513_258)  );
wire so_Data_reg_r0_257_2;

ScanShareSel_JTAG_reg_ext_cg #(256, 0, 0) testInst_Data_reg_r0_257_2 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[257:2]), .Q(Data_reg_r0_Q[257:2]),
            .scanin(so_Data_reg_r0_513_258), .scanout(so_Data_reg_r0_257_2)  );

ScanShareSel_JTAG_reg_ext_cg #(2, 0, 0) testInst_Data_reg_r0_1_0 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[1:0]), .Q(Data_reg_r0_Q[1:0]),
            .scanin(so_Data_reg_r0_257_2), .scanout(Data_reg_SO_r0)  );

`ifdef ASSERT_ON
`ifndef SYNTHESIS
reg sim_reset_;
initial sim_reset_ = 0;
always @(posedge clk) sim_reset_ <= 1'b1;

wire start_of_sim = sim_reset_;


wire disable_clk_x_test = $test$plusargs ("disable_clk_x_test") ? 1'b1 : 1'b0;
nv_assert_no_x #(1,1,0," Try Reading Ram when clock is x for read port r0") _clk_x_test_read (clk, sim_reset_, ((disable_clk_x_test===1'b0) && (|re===1'b1 )), clk);
nv_assert_no_x #(1,1,0," Try Writing Ram when clock is x for write port w0") _clk_x_test_write (clk, sim_reset_, ((disable_clk_x_test===1'b0) && (|we===1'b1)), clk);
reg [160-1:0] written; 
always@(posedge clk or negedge sim_reset_) begin 
   if(!sim_reset_) begin 
      written <= {160{1'b0}}; 
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
