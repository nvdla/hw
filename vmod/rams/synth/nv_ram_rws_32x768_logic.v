// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rws_32x768_logic.v

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


module nv_ram_rws_32x768_logic (
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
               mbist_ce_r0_0_288,
               mbist_ce_r0_0_576,
               mbist_en_sync,
               mbist_ramaccess_rst_,
               mbist_we_w0_0_0,
               mbist_we_w0_0_288,
               mbist_we_w0_0_576,
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
input  [767:0]  di;
output [767:0]  dout;
input           iddq_mode;
input           jtag_readonly_mode;
input  [1:0]    mbist_Di_w0;
output [767:0]  mbist_Do_r0_int_net;
input  [4:0]    mbist_Ra_r0;
input  [4:0]    mbist_Wa_w0;
input           mbist_ce_r0_0_0;
input           mbist_ce_r0_0_288;
input           mbist_ce_r0_0_576;
input           mbist_en_sync;
input           mbist_ramaccess_rst_;
input           mbist_we_w0_0_0;
input           mbist_we_w0_0_288;
input           mbist_we_w0_0_576;
input  [31:0]   pwrbus_ram_pd;
input  [4:0]    ra;
input           re;
input           scan_en;
input           scan_ramtms;
input           shiftDR;
input  [7:0]    svop;
input           updateDR;
input  [4:0]    wa;
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
reg [4:0] Ra_array_reg_r0;

wire mbist_en_r;
// hardcode mbist_en_r stdcell flop to avoid x bash recoverability issue described in bug 1803479 comment #7
p_SDFCNQD1PO4 mbist_en_flop(.D(mbist_en_sync), .CP(dft_rst_gated_clk), .Q(mbist_en_r), .CDN(mbist_ramaccess_rst_));

// Declare the Data_reg signal beforehand
wire [767:0] Data_reg_r0;


 // Data out bus for read port r0 for Output Mux
wire [767:0] r0_OutputMuxDataOut;
CKLNQD12PO4  UJ_la_bist_clkw0_gate (.Q(la_bist_clkw0), .CP(clk), .E(mbist_en_r | debug_mode_sync), .TE(scan_en));

// Write enable bus
wire  we_0_0;

// Read enable bus
wire re_0_0;

// Write enable bus
wire  we_0_288;

// Read enable bus
wire re_0_288;

// Write enable bus
wire  we_0_576;

// Read enable bus
wire re_0_576;
// start of predeclareNvregSignals
wire ctx_ctrl_we;
wire clk_en_core_0_0 = (re_0_0 | (|we_0_0));
wire gated_clk_core_0_0;
CKLNQD12PO4  UJ_clk_gate_core_0_0 (.Q(gated_clk_core_0_0), .CP(clk), .E(clk_en_core_0_0), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_288 = (re_0_288 | (|we_0_288));
wire gated_clk_core_0_288;
CKLNQD12PO4  UJ_clk_gate_core_0_288 (.Q(gated_clk_core_0_288), .CP(clk), .E(clk_en_core_0_288), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire clk_en_core_0_576 = (re_0_576 | (|we_0_576));
wire gated_clk_core_0_576;
CKLNQD12PO4  UJ_clk_gate_core_0_576 (.Q(gated_clk_core_0_576), .CP(clk), .E(clk_en_core_0_576), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire shiftDR_en;

reg [767:0] pre_muxed_Di_w0;
wire [767:0] pre_muxed_Di_w0_A, pre_muxed_Di_w0_B;
wire pre_muxed_Di_w0_S;

assign pre_muxed_Di_w0_S = !debug_mode_sync;
assign pre_muxed_Di_w0_A = Data_reg_r0[767:0];
assign pre_muxed_Di_w0_B = {{96{mbist_Di_w0}}, {144{mbist_Di_w0}}, {144{mbist_Di_w0}}};

always @(pre_muxed_Di_w0_S or pre_muxed_Di_w0_A or pre_muxed_Di_w0_B)
    case(pre_muxed_Di_w0_S) // synopsys infer_mux
      1'b0 : pre_muxed_Di_w0 = pre_muxed_Di_w0_A;
      1'b1 : pre_muxed_Di_w0 = pre_muxed_Di_w0_B;
      default : pre_muxed_Di_w0 = {768{`tick_x_or_0}};
    endcase

reg [767:0] muxed_Di_w0;
wire [767:0] muxed_Di_w0_A, muxed_Di_w0_B;
assign muxed_Di_w0_A = {di[767:576], di[575:288], di[287:0]};
assign muxed_Di_w0_B = pre_muxed_Di_w0;

wire muxed_Di_w0_S = debug_mode_sync | mbist_en_r;
always @(muxed_Di_w0_S or muxed_Di_w0_A or muxed_Di_w0_B)
    case(muxed_Di_w0_S) // synopsys infer_mux
      1'b0 : muxed_Di_w0 = muxed_Di_w0_A;
      1'b1 : muxed_Di_w0 = muxed_Di_w0_B;
      default : muxed_Di_w0 = {768{`tick_x_or_0}};
    endcase


wire posedge_updateDR_sync = updateDR_sync & !updateDR_sync_1p;

wire access_en_w = posedge_updateDR_sync;

// ATPG logic: capture for non-data regs
wire dft_capdr_w = ary_atpg_ctl;

wire [4:0] pre_Wa_reg_w0;

reg [4:0] Wa_reg_w0;
wire [4:0] Wa_reg_w0_A, Wa_reg_w0_B;
wire Wa_reg_w0_S;

assign Wa_reg_w0_S = (!debug_mode_sync);
assign Wa_reg_w0_A = pre_Wa_reg_w0;
assign Wa_reg_w0_B = mbist_Wa_w0;

always @(Wa_reg_w0_S or Wa_reg_w0_A or Wa_reg_w0_B)
case(Wa_reg_w0_S) // synopsys infer_mux
  1'b0 : Wa_reg_w0 = Wa_reg_w0_A;
  1'b1 : Wa_reg_w0 = Wa_reg_w0_B;
  default : Wa_reg_w0 = {5{`tick_x_or_0}};
endcase

reg [4:0] muxed_Wa_w0;
wire [4:0] muxed_Wa_w0_A, muxed_Wa_w0_B;
wire muxed_Wa_w0_S;

assign muxed_Wa_w0_S = debug_mode_sync | mbist_en_r;
assign muxed_Wa_w0_A = wa;
assign muxed_Wa_w0_B = Wa_reg_w0;

always @(muxed_Wa_w0_S or muxed_Wa_w0_A or muxed_Wa_w0_B)
  case(muxed_Wa_w0_S) // synopsys infer_mux
    1'b0 : muxed_Wa_w0 = muxed_Wa_w0_A;
    1'b1 : muxed_Wa_w0 = muxed_Wa_w0_B;
    default : muxed_Wa_w0 = {5{`tick_x_or_0}};
  endcase

// testInst_*reg* for address and enable capture the signals going into RAM instance input
// 4.2.3.1 of bob's doc
wire Wa_reg_SO_w0;
wire [4:0]wadr_q;
assign pre_Wa_reg_w0 = wadr_q ;
wire we_reg_SO_w0_0_0;
wire re_reg_SO_r0_0_0;
wire we_reg_SO_w0_0_288;
wire re_reg_SO_r0_0_288;
wire we_reg_SO_w0_0_576;
wire re_reg_SO_r0_0_576;

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

wire we_reg_w0_0_576;
wire pre_we_w0_0_576;
assign pre_we_w0_0_576 = debug_mode_sync ?
        ({1{posedge_updateDR_sync}} & we_reg_w0_0_576) :  
        {1{(mbist_en_r & mbist_we_w0_0_576)}};

reg  muxed_we_w0_0_576;
wire muxed_we_w0_0_576_A, muxed_we_w0_0_576_B;
wire muxed_we_w0_0_576_S;

assign muxed_we_w0_0_576_S = debug_mode_sync | mbist_en_r;
assign muxed_we_w0_0_576_A = we_0_576;
assign muxed_we_w0_0_576_B = pre_we_w0_0_576;

always @(muxed_we_w0_0_576_S or muxed_we_w0_0_576_A or muxed_we_w0_0_576_B)
case(muxed_we_w0_0_576_S) // synopsys infer_mux
  1'b0 : muxed_we_w0_0_576 = muxed_we_w0_0_576_A;
  1'b1 : muxed_we_w0_0_576 = muxed_we_w0_0_576_B;
  default : muxed_we_w0_0_576 = {1{`tick_x_or_0}};
endcase


wire we_0_576_q;
assign we_reg_w0_0_576 = we_0_576_q ;

// ATPG logic: capture for non-data regs
wire dft_capdr_r = ary_atpg_ctl;


// ATPG logic: capture for non-data regs

wire [4:0] pre_Ra_reg_r0;

reg [4:0] Ra_reg_r0;
wire [4:0] Ra_reg_r0_A, Ra_reg_r0_B;
wire Ra_reg_r0_S;

assign Ra_reg_r0_S = (!debug_mode_sync);
assign Ra_reg_r0_A = pre_Ra_reg_r0;
assign Ra_reg_r0_B = mbist_Ra_r0;

always @(Ra_reg_r0_S or Ra_reg_r0_A or Ra_reg_r0_B)
case(Ra_reg_r0_S) // synopsys infer_mux
  1'b0 : Ra_reg_r0 = Ra_reg_r0_A;
  1'b1 : Ra_reg_r0 = Ra_reg_r0_B;
  default : Ra_reg_r0 = {5{`tick_x_or_0}};
endcase

wire [4:0] D_Ra_reg_r0;


reg [4:0] muxed_Ra_r0;
wire [4:0] muxed_Ra_r0_A, muxed_Ra_r0_B;
wire muxed_Ra_r0_S;

assign muxed_Ra_r0_S = debug_mode_sync | mbist_en_r;
assign muxed_Ra_r0_A = ra;
assign muxed_Ra_r0_B = Ra_reg_r0;

always @(muxed_Ra_r0_S or muxed_Ra_r0_A or muxed_Ra_r0_B)
case(muxed_Ra_r0_S) // synopsys infer_mux
  1'b0 : muxed_Ra_r0 = muxed_Ra_r0_A;
  1'b1 : muxed_Ra_r0 = muxed_Ra_r0_B;
  default : muxed_Ra_r0 = {5{`tick_x_or_0}};
endcase

assign D_Ra_reg_r0 = muxed_Ra_r0;

// verilint 110 off - Incompatible width
// verilint 630 off - Port connected to a NULL expression
// These are used for registering Ra in case of Latch arrays as well (i.e.
// used in functional path as well)
wire Ra_reg_SO_r0;
wire [4:0]radr_q;
assign pre_Ra_reg_r0 = radr_q ;

wire re_reg_r0_0_0;
wire access_en_r_0_0 = posedge_updateDR_sync & re_reg_r0_0_0;
reg access_en_r_1p_0_0;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_0 <= 1'b0;
  else 
     access_en_r_1p_0_0 <= access_en_r_0_0;

wire re_reg_r0_0_288;
wire access_en_r_0_288 = posedge_updateDR_sync & re_reg_r0_0_288;
reg access_en_r_1p_0_288;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_288 <= 1'b0;
  else 
     access_en_r_1p_0_288 <= access_en_r_0_288;

wire re_reg_r0_0_576;
wire access_en_r_0_576 = posedge_updateDR_sync & re_reg_r0_0_576;
reg access_en_r_1p_0_576;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p_0_576 <= 1'b0;
  else 
     access_en_r_1p_0_576 <= access_en_r_0_576;

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

wire pre_re_r0_0_576;

assign pre_re_r0_0_576 = (debug_mode_sync) ?
    (posedge_updateDR_sync & re_reg_r0_0_576) :
    (mbist_en_r & mbist_ce_r0_0_576); 
reg  muxed_re_r0_0_576;
wire muxed_re_r0_0_576_A, muxed_re_r0_0_576_B;
wire muxed_re_r0_0_576_S;

assign muxed_re_r0_0_576_S = debug_mode_sync | mbist_en_r;
assign muxed_re_r0_0_576_A = re;
assign muxed_re_r0_0_576_B = pre_re_r0_0_576;

always @(muxed_re_r0_0_576_S or muxed_re_r0_0_576_A or muxed_re_r0_0_576_B)
case(muxed_re_r0_0_576_S) // synopsys infer_mux
  1'b0 : muxed_re_r0_0_576 = muxed_re_r0_0_576_A;
  1'b1 : muxed_re_r0_0_576 = muxed_re_r0_0_576_B;
  default : muxed_re_r0_0_576 = `tick_x_or_0;
endcase
wire re_0_576_q;
assign re_reg_r0_0_576 = re_0_576_q ;

// ------------------  START PIECE ----------------------------------
// Suffix _0_0 : Piece RAMPDP_32X288_GL_M1_D2 (RamCell)
// Covers Addresses from 0 to 31  Addressrange: [4:0]  
// Data Bit range: [287:0] (288 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [4:0] cs_start_val_0_0;
assign cs_start_val_0_0 = 5'd0;

wire [4:0] cs_end_val_0_0;
assign cs_end_val_0_0 = 5'd31;

// verilint 498 on - Incompatible width





// Write Address bus

wire [4:0] wa_0_0;
assign wa_0_0 = muxed_Wa_w0[4:0];

// Write Data in bus
wire [287:0] Wdata_0_0;
assign Wdata_0_0 = muxed_Di_w0[287:0];
assign we_0_0 = we;

// Read Address bus
wire [4:0] ra_0_0;
assign ra_0_0 = muxed_Ra_r0[4:0];

// Read DataOut bus
wire [287:0] dout_0_0;
assign re_0_0 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_288 : Piece RAMPDP_32X288_GL_M1_D2 (RamCell)
// Covers Addresses from 0 to 31  Addressrange: [4:0]  
// Data Bit range: [575:288] (288 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [4:0] cs_start_val_0_288;
assign cs_start_val_0_288 = 5'd0;

wire [4:0] cs_end_val_0_288;
assign cs_end_val_0_288 = 5'd31;

// verilint 498 on - Incompatible width





// Write Address bus

wire [4:0] wa_0_288;
assign wa_0_288 = muxed_Wa_w0[4:0];

// Write Data in bus
wire [575:288] Wdata_0_288;
assign Wdata_0_288 = muxed_Di_w0[575:288];
assign we_0_288 = we;

// Read Address bus
wire [4:0] ra_0_288;
assign ra_0_288 = muxed_Ra_r0[4:0];

// Read DataOut bus
wire [575:288] dout_0_288;
assign re_0_288 = re;


// ------------------  START PIECE ----------------------------------
// Suffix _0_576 : Piece RAMPDP_32X192_GL_M1_D2 (RamCell)
// Covers Addresses from 0 to 31  Addressrange: [4:0]  
// Data Bit range: [767:576] (192 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [4:0] cs_start_val_0_576;
assign cs_start_val_0_576 = 5'd0;

wire [4:0] cs_end_val_0_576;
assign cs_end_val_0_576 = 5'd31;

// verilint 498 on - Incompatible width





// Write Address bus

wire [4:0] wa_0_576;
assign wa_0_576 = muxed_Wa_w0[4:0];

// Write Data in bus
wire [767:576] Wdata_0_576;
assign Wdata_0_576 = muxed_Di_w0[767:576];
assign we_0_576 = we;

// Read Address bus
wire [4:0] ra_0_576;
assign ra_0_576 = muxed_Ra_r0[4:0];

// Read DataOut bus
wire [767:576] dout_0_576;
assign re_0_576 = re;


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

// -----------------  begin Ram Cell RAMPDP_32X288_GL_M1_D2_0_0 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_0 = !(|muxed_we_w0_0_0) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_0 = muxed_re_r0_0_0 | ( scan_en & jtag_readonly_mode );
wire reb_0_0 = !piece_re_0_0;
// Declare the ramOutData which connects to the ram directly
wire [287:0] ramDataOut_0_0;
assign dout_0_0[287:0] = ramDataOut_0_0[287:0];
RAMPDP_32X288_GL_M1_D2 ram_Inst_32X288_0_0 (
                                              .CLK             (gated_clk_core_0_0)
                                            , .WADR_4          (wa_0_0[4])
                                            , .WADR_3          (wa_0_0[3])
                                            , .WADR_2          (wa_0_0[2])
                                            , .WADR_1          (wa_0_0[1])
                                            , .WADR_0          (wa_0_0[0])
                                            , .WD_287          (Wdata_0_0[287])
                                            , .WD_286          (Wdata_0_0[286])
                                            , .WD_285          (Wdata_0_0[285])
                                            , .WD_284          (Wdata_0_0[284])
                                            , .WD_283          (Wdata_0_0[283])
                                            , .WD_282          (Wdata_0_0[282])
                                            , .WD_281          (Wdata_0_0[281])
                                            , .WD_280          (Wdata_0_0[280])
                                            , .WD_279          (Wdata_0_0[279])
                                            , .WD_278          (Wdata_0_0[278])
                                            , .WD_277          (Wdata_0_0[277])
                                            , .WD_276          (Wdata_0_0[276])
                                            , .WD_275          (Wdata_0_0[275])
                                            , .WD_274          (Wdata_0_0[274])
                                            , .WD_273          (Wdata_0_0[273])
                                            , .WD_272          (Wdata_0_0[272])
                                            , .WD_271          (Wdata_0_0[271])
                                            , .WD_270          (Wdata_0_0[270])
                                            , .WD_269          (Wdata_0_0[269])
                                            , .WD_268          (Wdata_0_0[268])
                                            , .WD_267          (Wdata_0_0[267])
                                            , .WD_266          (Wdata_0_0[266])
                                            , .WD_265          (Wdata_0_0[265])
                                            , .WD_264          (Wdata_0_0[264])
                                            , .WD_263          (Wdata_0_0[263])
                                            , .WD_262          (Wdata_0_0[262])
                                            , .WD_261          (Wdata_0_0[261])
                                            , .WD_260          (Wdata_0_0[260])
                                            , .WD_259          (Wdata_0_0[259])
                                            , .WD_258          (Wdata_0_0[258])
                                            , .WD_257          (Wdata_0_0[257])
                                            , .WD_256          (Wdata_0_0[256])
                                            , .WD_255          (Wdata_0_0[255])
                                            , .WD_254          (Wdata_0_0[254])
                                            , .WD_253          (Wdata_0_0[253])
                                            , .WD_252          (Wdata_0_0[252])
                                            , .WD_251          (Wdata_0_0[251])
                                            , .WD_250          (Wdata_0_0[250])
                                            , .WD_249          (Wdata_0_0[249])
                                            , .WD_248          (Wdata_0_0[248])
                                            , .WD_247          (Wdata_0_0[247])
                                            , .WD_246          (Wdata_0_0[246])
                                            , .WD_245          (Wdata_0_0[245])
                                            , .WD_244          (Wdata_0_0[244])
                                            , .WD_243          (Wdata_0_0[243])
                                            , .WD_242          (Wdata_0_0[242])
                                            , .WD_241          (Wdata_0_0[241])
                                            , .WD_240          (Wdata_0_0[240])
                                            , .WD_239          (Wdata_0_0[239])
                                            , .WD_238          (Wdata_0_0[238])
                                            , .WD_237          (Wdata_0_0[237])
                                            , .WD_236          (Wdata_0_0[236])
                                            , .WD_235          (Wdata_0_0[235])
                                            , .WD_234          (Wdata_0_0[234])
                                            , .WD_233          (Wdata_0_0[233])
                                            , .WD_232          (Wdata_0_0[232])
                                            , .WD_231          (Wdata_0_0[231])
                                            , .WD_230          (Wdata_0_0[230])
                                            , .WD_229          (Wdata_0_0[229])
                                            , .WD_228          (Wdata_0_0[228])
                                            , .WD_227          (Wdata_0_0[227])
                                            , .WD_226          (Wdata_0_0[226])
                                            , .WD_225          (Wdata_0_0[225])
                                            , .WD_224          (Wdata_0_0[224])
                                            , .WD_223          (Wdata_0_0[223])
                                            , .WD_222          (Wdata_0_0[222])
                                            , .WD_221          (Wdata_0_0[221])
                                            , .WD_220          (Wdata_0_0[220])
                                            , .WD_219          (Wdata_0_0[219])
                                            , .WD_218          (Wdata_0_0[218])
                                            , .WD_217          (Wdata_0_0[217])
                                            , .WD_216          (Wdata_0_0[216])
                                            , .WD_215          (Wdata_0_0[215])
                                            , .WD_214          (Wdata_0_0[214])
                                            , .WD_213          (Wdata_0_0[213])
                                            , .WD_212          (Wdata_0_0[212])
                                            , .WD_211          (Wdata_0_0[211])
                                            , .WD_210          (Wdata_0_0[210])
                                            , .WD_209          (Wdata_0_0[209])
                                            , .WD_208          (Wdata_0_0[208])
                                            , .WD_207          (Wdata_0_0[207])
                                            , .WD_206          (Wdata_0_0[206])
                                            , .WD_205          (Wdata_0_0[205])
                                            , .WD_204          (Wdata_0_0[204])
                                            , .WD_203          (Wdata_0_0[203])
                                            , .WD_202          (Wdata_0_0[202])
                                            , .WD_201          (Wdata_0_0[201])
                                            , .WD_200          (Wdata_0_0[200])
                                            , .WD_199          (Wdata_0_0[199])
                                            , .WD_198          (Wdata_0_0[198])
                                            , .WD_197          (Wdata_0_0[197])
                                            , .WD_196          (Wdata_0_0[196])
                                            , .WD_195          (Wdata_0_0[195])
                                            , .WD_194          (Wdata_0_0[194])
                                            , .WD_193          (Wdata_0_0[193])
                                            , .WD_192          (Wdata_0_0[192])
                                            , .WD_191          (Wdata_0_0[191])
                                            , .WD_190          (Wdata_0_0[190])
                                            , .WD_189          (Wdata_0_0[189])
                                            , .WD_188          (Wdata_0_0[188])
                                            , .WD_187          (Wdata_0_0[187])
                                            , .WD_186          (Wdata_0_0[186])
                                            , .WD_185          (Wdata_0_0[185])
                                            , .WD_184          (Wdata_0_0[184])
                                            , .WD_183          (Wdata_0_0[183])
                                            , .WD_182          (Wdata_0_0[182])
                                            , .WD_181          (Wdata_0_0[181])
                                            , .WD_180          (Wdata_0_0[180])
                                            , .WD_179          (Wdata_0_0[179])
                                            , .WD_178          (Wdata_0_0[178])
                                            , .WD_177          (Wdata_0_0[177])
                                            , .WD_176          (Wdata_0_0[176])
                                            , .WD_175          (Wdata_0_0[175])
                                            , .WD_174          (Wdata_0_0[174])
                                            , .WD_173          (Wdata_0_0[173])
                                            , .WD_172          (Wdata_0_0[172])
                                            , .WD_171          (Wdata_0_0[171])
                                            , .WD_170          (Wdata_0_0[170])
                                            , .WD_169          (Wdata_0_0[169])
                                            , .WD_168          (Wdata_0_0[168])
                                            , .WD_167          (Wdata_0_0[167])
                                            , .WD_166          (Wdata_0_0[166])
                                            , .WD_165          (Wdata_0_0[165])
                                            , .WD_164          (Wdata_0_0[164])
                                            , .WD_163          (Wdata_0_0[163])
                                            , .WD_162          (Wdata_0_0[162])
                                            , .WD_161          (Wdata_0_0[161])
                                            , .WD_160          (Wdata_0_0[160])
                                            , .WD_159          (Wdata_0_0[159])
                                            , .WD_158          (Wdata_0_0[158])
                                            , .WD_157          (Wdata_0_0[157])
                                            , .WD_156          (Wdata_0_0[156])
                                            , .WD_155          (Wdata_0_0[155])
                                            , .WD_154          (Wdata_0_0[154])
                                            , .WD_153          (Wdata_0_0[153])
                                            , .WD_152          (Wdata_0_0[152])
                                            , .WD_151          (Wdata_0_0[151])
                                            , .WD_150          (Wdata_0_0[150])
                                            , .WD_149          (Wdata_0_0[149])
                                            , .WD_148          (Wdata_0_0[148])
                                            , .WD_147          (Wdata_0_0[147])
                                            , .WD_146          (Wdata_0_0[146])
                                            , .WD_145          (Wdata_0_0[145])
                                            , .WD_144          (Wdata_0_0[144])
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
                                            , .RADR_4          (ra_0_0 [4])
                                            , .RADR_3          (ra_0_0 [3])
                                            , .RADR_2          (ra_0_0 [2])
                                            , .RADR_1          (ra_0_0 [1])
                                            , .RADR_0          (ra_0_0 [0])
                                            , .RE              (!reb_0_0)
                                            , .RD_287          (ramDataOut_0_0[287])
                                            , .RD_286          (ramDataOut_0_0[286])
                                            , .RD_285          (ramDataOut_0_0[285])
                                            , .RD_284          (ramDataOut_0_0[284])
                                            , .RD_283          (ramDataOut_0_0[283])
                                            , .RD_282          (ramDataOut_0_0[282])
                                            , .RD_281          (ramDataOut_0_0[281])
                                            , .RD_280          (ramDataOut_0_0[280])
                                            , .RD_279          (ramDataOut_0_0[279])
                                            , .RD_278          (ramDataOut_0_0[278])
                                            , .RD_277          (ramDataOut_0_0[277])
                                            , .RD_276          (ramDataOut_0_0[276])
                                            , .RD_275          (ramDataOut_0_0[275])
                                            , .RD_274          (ramDataOut_0_0[274])
                                            , .RD_273          (ramDataOut_0_0[273])
                                            , .RD_272          (ramDataOut_0_0[272])
                                            , .RD_271          (ramDataOut_0_0[271])
                                            , .RD_270          (ramDataOut_0_0[270])
                                            , .RD_269          (ramDataOut_0_0[269])
                                            , .RD_268          (ramDataOut_0_0[268])
                                            , .RD_267          (ramDataOut_0_0[267])
                                            , .RD_266          (ramDataOut_0_0[266])
                                            , .RD_265          (ramDataOut_0_0[265])
                                            , .RD_264          (ramDataOut_0_0[264])
                                            , .RD_263          (ramDataOut_0_0[263])
                                            , .RD_262          (ramDataOut_0_0[262])
                                            , .RD_261          (ramDataOut_0_0[261])
                                            , .RD_260          (ramDataOut_0_0[260])
                                            , .RD_259          (ramDataOut_0_0[259])
                                            , .RD_258          (ramDataOut_0_0[258])
                                            , .RD_257          (ramDataOut_0_0[257])
                                            , .RD_256          (ramDataOut_0_0[256])
                                            , .RD_255          (ramDataOut_0_0[255])
                                            , .RD_254          (ramDataOut_0_0[254])
                                            , .RD_253          (ramDataOut_0_0[253])
                                            , .RD_252          (ramDataOut_0_0[252])
                                            , .RD_251          (ramDataOut_0_0[251])
                                            , .RD_250          (ramDataOut_0_0[250])
                                            , .RD_249          (ramDataOut_0_0[249])
                                            , .RD_248          (ramDataOut_0_0[248])
                                            , .RD_247          (ramDataOut_0_0[247])
                                            , .RD_246          (ramDataOut_0_0[246])
                                            , .RD_245          (ramDataOut_0_0[245])
                                            , .RD_244          (ramDataOut_0_0[244])
                                            , .RD_243          (ramDataOut_0_0[243])
                                            , .RD_242          (ramDataOut_0_0[242])
                                            , .RD_241          (ramDataOut_0_0[241])
                                            , .RD_240          (ramDataOut_0_0[240])
                                            , .RD_239          (ramDataOut_0_0[239])
                                            , .RD_238          (ramDataOut_0_0[238])
                                            , .RD_237          (ramDataOut_0_0[237])
                                            , .RD_236          (ramDataOut_0_0[236])
                                            , .RD_235          (ramDataOut_0_0[235])
                                            , .RD_234          (ramDataOut_0_0[234])
                                            , .RD_233          (ramDataOut_0_0[233])
                                            , .RD_232          (ramDataOut_0_0[232])
                                            , .RD_231          (ramDataOut_0_0[231])
                                            , .RD_230          (ramDataOut_0_0[230])
                                            , .RD_229          (ramDataOut_0_0[229])
                                            , .RD_228          (ramDataOut_0_0[228])
                                            , .RD_227          (ramDataOut_0_0[227])
                                            , .RD_226          (ramDataOut_0_0[226])
                                            , .RD_225          (ramDataOut_0_0[225])
                                            , .RD_224          (ramDataOut_0_0[224])
                                            , .RD_223          (ramDataOut_0_0[223])
                                            , .RD_222          (ramDataOut_0_0[222])
                                            , .RD_221          (ramDataOut_0_0[221])
                                            , .RD_220          (ramDataOut_0_0[220])
                                            , .RD_219          (ramDataOut_0_0[219])
                                            , .RD_218          (ramDataOut_0_0[218])
                                            , .RD_217          (ramDataOut_0_0[217])
                                            , .RD_216          (ramDataOut_0_0[216])
                                            , .RD_215          (ramDataOut_0_0[215])
                                            , .RD_214          (ramDataOut_0_0[214])
                                            , .RD_213          (ramDataOut_0_0[213])
                                            , .RD_212          (ramDataOut_0_0[212])
                                            , .RD_211          (ramDataOut_0_0[211])
                                            , .RD_210          (ramDataOut_0_0[210])
                                            , .RD_209          (ramDataOut_0_0[209])
                                            , .RD_208          (ramDataOut_0_0[208])
                                            , .RD_207          (ramDataOut_0_0[207])
                                            , .RD_206          (ramDataOut_0_0[206])
                                            , .RD_205          (ramDataOut_0_0[205])
                                            , .RD_204          (ramDataOut_0_0[204])
                                            , .RD_203          (ramDataOut_0_0[203])
                                            , .RD_202          (ramDataOut_0_0[202])
                                            , .RD_201          (ramDataOut_0_0[201])
                                            , .RD_200          (ramDataOut_0_0[200])
                                            , .RD_199          (ramDataOut_0_0[199])
                                            , .RD_198          (ramDataOut_0_0[198])
                                            , .RD_197          (ramDataOut_0_0[197])
                                            , .RD_196          (ramDataOut_0_0[196])
                                            , .RD_195          (ramDataOut_0_0[195])
                                            , .RD_194          (ramDataOut_0_0[194])
                                            , .RD_193          (ramDataOut_0_0[193])
                                            , .RD_192          (ramDataOut_0_0[192])
                                            , .RD_191          (ramDataOut_0_0[191])
                                            , .RD_190          (ramDataOut_0_0[190])
                                            , .RD_189          (ramDataOut_0_0[189])
                                            , .RD_188          (ramDataOut_0_0[188])
                                            , .RD_187          (ramDataOut_0_0[187])
                                            , .RD_186          (ramDataOut_0_0[186])
                                            , .RD_185          (ramDataOut_0_0[185])
                                            , .RD_184          (ramDataOut_0_0[184])
                                            , .RD_183          (ramDataOut_0_0[183])
                                            , .RD_182          (ramDataOut_0_0[182])
                                            , .RD_181          (ramDataOut_0_0[181])
                                            , .RD_180          (ramDataOut_0_0[180])
                                            , .RD_179          (ramDataOut_0_0[179])
                                            , .RD_178          (ramDataOut_0_0[178])
                                            , .RD_177          (ramDataOut_0_0[177])
                                            , .RD_176          (ramDataOut_0_0[176])
                                            , .RD_175          (ramDataOut_0_0[175])
                                            , .RD_174          (ramDataOut_0_0[174])
                                            , .RD_173          (ramDataOut_0_0[173])
                                            , .RD_172          (ramDataOut_0_0[172])
                                            , .RD_171          (ramDataOut_0_0[171])
                                            , .RD_170          (ramDataOut_0_0[170])
                                            , .RD_169          (ramDataOut_0_0[169])
                                            , .RD_168          (ramDataOut_0_0[168])
                                            , .RD_167          (ramDataOut_0_0[167])
                                            , .RD_166          (ramDataOut_0_0[166])
                                            , .RD_165          (ramDataOut_0_0[165])
                                            , .RD_164          (ramDataOut_0_0[164])
                                            , .RD_163          (ramDataOut_0_0[163])
                                            , .RD_162          (ramDataOut_0_0[162])
                                            , .RD_161          (ramDataOut_0_0[161])
                                            , .RD_160          (ramDataOut_0_0[160])
                                            , .RD_159          (ramDataOut_0_0[159])
                                            , .RD_158          (ramDataOut_0_0[158])
                                            , .RD_157          (ramDataOut_0_0[157])
                                            , .RD_156          (ramDataOut_0_0[156])
                                            , .RD_155          (ramDataOut_0_0[155])
                                            , .RD_154          (ramDataOut_0_0[154])
                                            , .RD_153          (ramDataOut_0_0[153])
                                            , .RD_152          (ramDataOut_0_0[152])
                                            , .RD_151          (ramDataOut_0_0[151])
                                            , .RD_150          (ramDataOut_0_0[150])
                                            , .RD_149          (ramDataOut_0_0[149])
                                            , .RD_148          (ramDataOut_0_0[148])
                                            , .RD_147          (ramDataOut_0_0[147])
                                            , .RD_146          (ramDataOut_0_0[146])
                                            , .RD_145          (ramDataOut_0_0[145])
                                            , .RD_144          (ramDataOut_0_0[144])
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

// -----------------  begin Ram Cell RAMPDP_32X288_GL_M1_D2_0_288 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_288 = !(|muxed_we_w0_0_288) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_288 = muxed_re_r0_0_288 | ( scan_en & jtag_readonly_mode );
wire reb_0_288 = !piece_re_0_288;
// Declare the ramOutData which connects to the ram directly
wire [575:288] ramDataOut_0_288;
assign dout_0_288[575:288] = ramDataOut_0_288[575:288];
RAMPDP_32X288_GL_M1_D2 ram_Inst_32X288_0_288 (
                                                .CLK             (gated_clk_core_0_288)
                                              , .WADR_4          (wa_0_288[4])
                                              , .WADR_3          (wa_0_288[3])
                                              , .WADR_2          (wa_0_288[2])
                                              , .WADR_1          (wa_0_288[1])
                                              , .WADR_0          (wa_0_288[0])
                                              , .WD_287          (Wdata_0_288[575])
                                              , .WD_286          (Wdata_0_288[574])
                                              , .WD_285          (Wdata_0_288[573])
                                              , .WD_284          (Wdata_0_288[572])
                                              , .WD_283          (Wdata_0_288[571])
                                              , .WD_282          (Wdata_0_288[570])
                                              , .WD_281          (Wdata_0_288[569])
                                              , .WD_280          (Wdata_0_288[568])
                                              , .WD_279          (Wdata_0_288[567])
                                              , .WD_278          (Wdata_0_288[566])
                                              , .WD_277          (Wdata_0_288[565])
                                              , .WD_276          (Wdata_0_288[564])
                                              , .WD_275          (Wdata_0_288[563])
                                              , .WD_274          (Wdata_0_288[562])
                                              , .WD_273          (Wdata_0_288[561])
                                              , .WD_272          (Wdata_0_288[560])
                                              , .WD_271          (Wdata_0_288[559])
                                              , .WD_270          (Wdata_0_288[558])
                                              , .WD_269          (Wdata_0_288[557])
                                              , .WD_268          (Wdata_0_288[556])
                                              , .WD_267          (Wdata_0_288[555])
                                              , .WD_266          (Wdata_0_288[554])
                                              , .WD_265          (Wdata_0_288[553])
                                              , .WD_264          (Wdata_0_288[552])
                                              , .WD_263          (Wdata_0_288[551])
                                              , .WD_262          (Wdata_0_288[550])
                                              , .WD_261          (Wdata_0_288[549])
                                              , .WD_260          (Wdata_0_288[548])
                                              , .WD_259          (Wdata_0_288[547])
                                              , .WD_258          (Wdata_0_288[546])
                                              , .WD_257          (Wdata_0_288[545])
                                              , .WD_256          (Wdata_0_288[544])
                                              , .WD_255          (Wdata_0_288[543])
                                              , .WD_254          (Wdata_0_288[542])
                                              , .WD_253          (Wdata_0_288[541])
                                              , .WD_252          (Wdata_0_288[540])
                                              , .WD_251          (Wdata_0_288[539])
                                              , .WD_250          (Wdata_0_288[538])
                                              , .WD_249          (Wdata_0_288[537])
                                              , .WD_248          (Wdata_0_288[536])
                                              , .WD_247          (Wdata_0_288[535])
                                              , .WD_246          (Wdata_0_288[534])
                                              , .WD_245          (Wdata_0_288[533])
                                              , .WD_244          (Wdata_0_288[532])
                                              , .WD_243          (Wdata_0_288[531])
                                              , .WD_242          (Wdata_0_288[530])
                                              , .WD_241          (Wdata_0_288[529])
                                              , .WD_240          (Wdata_0_288[528])
                                              , .WD_239          (Wdata_0_288[527])
                                              , .WD_238          (Wdata_0_288[526])
                                              , .WD_237          (Wdata_0_288[525])
                                              , .WD_236          (Wdata_0_288[524])
                                              , .WD_235          (Wdata_0_288[523])
                                              , .WD_234          (Wdata_0_288[522])
                                              , .WD_233          (Wdata_0_288[521])
                                              , .WD_232          (Wdata_0_288[520])
                                              , .WD_231          (Wdata_0_288[519])
                                              , .WD_230          (Wdata_0_288[518])
                                              , .WD_229          (Wdata_0_288[517])
                                              , .WD_228          (Wdata_0_288[516])
                                              , .WD_227          (Wdata_0_288[515])
                                              , .WD_226          (Wdata_0_288[514])
                                              , .WD_225          (Wdata_0_288[513])
                                              , .WD_224          (Wdata_0_288[512])
                                              , .WD_223          (Wdata_0_288[511])
                                              , .WD_222          (Wdata_0_288[510])
                                              , .WD_221          (Wdata_0_288[509])
                                              , .WD_220          (Wdata_0_288[508])
                                              , .WD_219          (Wdata_0_288[507])
                                              , .WD_218          (Wdata_0_288[506])
                                              , .WD_217          (Wdata_0_288[505])
                                              , .WD_216          (Wdata_0_288[504])
                                              , .WD_215          (Wdata_0_288[503])
                                              , .WD_214          (Wdata_0_288[502])
                                              , .WD_213          (Wdata_0_288[501])
                                              , .WD_212          (Wdata_0_288[500])
                                              , .WD_211          (Wdata_0_288[499])
                                              , .WD_210          (Wdata_0_288[498])
                                              , .WD_209          (Wdata_0_288[497])
                                              , .WD_208          (Wdata_0_288[496])
                                              , .WD_207          (Wdata_0_288[495])
                                              , .WD_206          (Wdata_0_288[494])
                                              , .WD_205          (Wdata_0_288[493])
                                              , .WD_204          (Wdata_0_288[492])
                                              , .WD_203          (Wdata_0_288[491])
                                              , .WD_202          (Wdata_0_288[490])
                                              , .WD_201          (Wdata_0_288[489])
                                              , .WD_200          (Wdata_0_288[488])
                                              , .WD_199          (Wdata_0_288[487])
                                              , .WD_198          (Wdata_0_288[486])
                                              , .WD_197          (Wdata_0_288[485])
                                              , .WD_196          (Wdata_0_288[484])
                                              , .WD_195          (Wdata_0_288[483])
                                              , .WD_194          (Wdata_0_288[482])
                                              , .WD_193          (Wdata_0_288[481])
                                              , .WD_192          (Wdata_0_288[480])
                                              , .WD_191          (Wdata_0_288[479])
                                              , .WD_190          (Wdata_0_288[478])
                                              , .WD_189          (Wdata_0_288[477])
                                              , .WD_188          (Wdata_0_288[476])
                                              , .WD_187          (Wdata_0_288[475])
                                              , .WD_186          (Wdata_0_288[474])
                                              , .WD_185          (Wdata_0_288[473])
                                              , .WD_184          (Wdata_0_288[472])
                                              , .WD_183          (Wdata_0_288[471])
                                              , .WD_182          (Wdata_0_288[470])
                                              , .WD_181          (Wdata_0_288[469])
                                              , .WD_180          (Wdata_0_288[468])
                                              , .WD_179          (Wdata_0_288[467])
                                              , .WD_178          (Wdata_0_288[466])
                                              , .WD_177          (Wdata_0_288[465])
                                              , .WD_176          (Wdata_0_288[464])
                                              , .WD_175          (Wdata_0_288[463])
                                              , .WD_174          (Wdata_0_288[462])
                                              , .WD_173          (Wdata_0_288[461])
                                              , .WD_172          (Wdata_0_288[460])
                                              , .WD_171          (Wdata_0_288[459])
                                              , .WD_170          (Wdata_0_288[458])
                                              , .WD_169          (Wdata_0_288[457])
                                              , .WD_168          (Wdata_0_288[456])
                                              , .WD_167          (Wdata_0_288[455])
                                              , .WD_166          (Wdata_0_288[454])
                                              , .WD_165          (Wdata_0_288[453])
                                              , .WD_164          (Wdata_0_288[452])
                                              , .WD_163          (Wdata_0_288[451])
                                              , .WD_162          (Wdata_0_288[450])
                                              , .WD_161          (Wdata_0_288[449])
                                              , .WD_160          (Wdata_0_288[448])
                                              , .WD_159          (Wdata_0_288[447])
                                              , .WD_158          (Wdata_0_288[446])
                                              , .WD_157          (Wdata_0_288[445])
                                              , .WD_156          (Wdata_0_288[444])
                                              , .WD_155          (Wdata_0_288[443])
                                              , .WD_154          (Wdata_0_288[442])
                                              , .WD_153          (Wdata_0_288[441])
                                              , .WD_152          (Wdata_0_288[440])
                                              , .WD_151          (Wdata_0_288[439])
                                              , .WD_150          (Wdata_0_288[438])
                                              , .WD_149          (Wdata_0_288[437])
                                              , .WD_148          (Wdata_0_288[436])
                                              , .WD_147          (Wdata_0_288[435])
                                              , .WD_146          (Wdata_0_288[434])
                                              , .WD_145          (Wdata_0_288[433])
                                              , .WD_144          (Wdata_0_288[432])
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
                                              , .RADR_4          (ra_0_288 [4])
                                              , .RADR_3          (ra_0_288 [3])
                                              , .RADR_2          (ra_0_288 [2])
                                              , .RADR_1          (ra_0_288 [1])
                                              , .RADR_0          (ra_0_288 [0])
                                              , .RE              (!reb_0_288)
                                              , .RD_287          (ramDataOut_0_288[575])
                                              , .RD_286          (ramDataOut_0_288[574])
                                              , .RD_285          (ramDataOut_0_288[573])
                                              , .RD_284          (ramDataOut_0_288[572])
                                              , .RD_283          (ramDataOut_0_288[571])
                                              , .RD_282          (ramDataOut_0_288[570])
                                              , .RD_281          (ramDataOut_0_288[569])
                                              , .RD_280          (ramDataOut_0_288[568])
                                              , .RD_279          (ramDataOut_0_288[567])
                                              , .RD_278          (ramDataOut_0_288[566])
                                              , .RD_277          (ramDataOut_0_288[565])
                                              , .RD_276          (ramDataOut_0_288[564])
                                              , .RD_275          (ramDataOut_0_288[563])
                                              , .RD_274          (ramDataOut_0_288[562])
                                              , .RD_273          (ramDataOut_0_288[561])
                                              , .RD_272          (ramDataOut_0_288[560])
                                              , .RD_271          (ramDataOut_0_288[559])
                                              , .RD_270          (ramDataOut_0_288[558])
                                              , .RD_269          (ramDataOut_0_288[557])
                                              , .RD_268          (ramDataOut_0_288[556])
                                              , .RD_267          (ramDataOut_0_288[555])
                                              , .RD_266          (ramDataOut_0_288[554])
                                              , .RD_265          (ramDataOut_0_288[553])
                                              , .RD_264          (ramDataOut_0_288[552])
                                              , .RD_263          (ramDataOut_0_288[551])
                                              , .RD_262          (ramDataOut_0_288[550])
                                              , .RD_261          (ramDataOut_0_288[549])
                                              , .RD_260          (ramDataOut_0_288[548])
                                              , .RD_259          (ramDataOut_0_288[547])
                                              , .RD_258          (ramDataOut_0_288[546])
                                              , .RD_257          (ramDataOut_0_288[545])
                                              , .RD_256          (ramDataOut_0_288[544])
                                              , .RD_255          (ramDataOut_0_288[543])
                                              , .RD_254          (ramDataOut_0_288[542])
                                              , .RD_253          (ramDataOut_0_288[541])
                                              , .RD_252          (ramDataOut_0_288[540])
                                              , .RD_251          (ramDataOut_0_288[539])
                                              , .RD_250          (ramDataOut_0_288[538])
                                              , .RD_249          (ramDataOut_0_288[537])
                                              , .RD_248          (ramDataOut_0_288[536])
                                              , .RD_247          (ramDataOut_0_288[535])
                                              , .RD_246          (ramDataOut_0_288[534])
                                              , .RD_245          (ramDataOut_0_288[533])
                                              , .RD_244          (ramDataOut_0_288[532])
                                              , .RD_243          (ramDataOut_0_288[531])
                                              , .RD_242          (ramDataOut_0_288[530])
                                              , .RD_241          (ramDataOut_0_288[529])
                                              , .RD_240          (ramDataOut_0_288[528])
                                              , .RD_239          (ramDataOut_0_288[527])
                                              , .RD_238          (ramDataOut_0_288[526])
                                              , .RD_237          (ramDataOut_0_288[525])
                                              , .RD_236          (ramDataOut_0_288[524])
                                              , .RD_235          (ramDataOut_0_288[523])
                                              , .RD_234          (ramDataOut_0_288[522])
                                              , .RD_233          (ramDataOut_0_288[521])
                                              , .RD_232          (ramDataOut_0_288[520])
                                              , .RD_231          (ramDataOut_0_288[519])
                                              , .RD_230          (ramDataOut_0_288[518])
                                              , .RD_229          (ramDataOut_0_288[517])
                                              , .RD_228          (ramDataOut_0_288[516])
                                              , .RD_227          (ramDataOut_0_288[515])
                                              , .RD_226          (ramDataOut_0_288[514])
                                              , .RD_225          (ramDataOut_0_288[513])
                                              , .RD_224          (ramDataOut_0_288[512])
                                              , .RD_223          (ramDataOut_0_288[511])
                                              , .RD_222          (ramDataOut_0_288[510])
                                              , .RD_221          (ramDataOut_0_288[509])
                                              , .RD_220          (ramDataOut_0_288[508])
                                              , .RD_219          (ramDataOut_0_288[507])
                                              , .RD_218          (ramDataOut_0_288[506])
                                              , .RD_217          (ramDataOut_0_288[505])
                                              , .RD_216          (ramDataOut_0_288[504])
                                              , .RD_215          (ramDataOut_0_288[503])
                                              , .RD_214          (ramDataOut_0_288[502])
                                              , .RD_213          (ramDataOut_0_288[501])
                                              , .RD_212          (ramDataOut_0_288[500])
                                              , .RD_211          (ramDataOut_0_288[499])
                                              , .RD_210          (ramDataOut_0_288[498])
                                              , .RD_209          (ramDataOut_0_288[497])
                                              , .RD_208          (ramDataOut_0_288[496])
                                              , .RD_207          (ramDataOut_0_288[495])
                                              , .RD_206          (ramDataOut_0_288[494])
                                              , .RD_205          (ramDataOut_0_288[493])
                                              , .RD_204          (ramDataOut_0_288[492])
                                              , .RD_203          (ramDataOut_0_288[491])
                                              , .RD_202          (ramDataOut_0_288[490])
                                              , .RD_201          (ramDataOut_0_288[489])
                                              , .RD_200          (ramDataOut_0_288[488])
                                              , .RD_199          (ramDataOut_0_288[487])
                                              , .RD_198          (ramDataOut_0_288[486])
                                              , .RD_197          (ramDataOut_0_288[485])
                                              , .RD_196          (ramDataOut_0_288[484])
                                              , .RD_195          (ramDataOut_0_288[483])
                                              , .RD_194          (ramDataOut_0_288[482])
                                              , .RD_193          (ramDataOut_0_288[481])
                                              , .RD_192          (ramDataOut_0_288[480])
                                              , .RD_191          (ramDataOut_0_288[479])
                                              , .RD_190          (ramDataOut_0_288[478])
                                              , .RD_189          (ramDataOut_0_288[477])
                                              , .RD_188          (ramDataOut_0_288[476])
                                              , .RD_187          (ramDataOut_0_288[475])
                                              , .RD_186          (ramDataOut_0_288[474])
                                              , .RD_185          (ramDataOut_0_288[473])
                                              , .RD_184          (ramDataOut_0_288[472])
                                              , .RD_183          (ramDataOut_0_288[471])
                                              , .RD_182          (ramDataOut_0_288[470])
                                              , .RD_181          (ramDataOut_0_288[469])
                                              , .RD_180          (ramDataOut_0_288[468])
                                              , .RD_179          (ramDataOut_0_288[467])
                                              , .RD_178          (ramDataOut_0_288[466])
                                              , .RD_177          (ramDataOut_0_288[465])
                                              , .RD_176          (ramDataOut_0_288[464])
                                              , .RD_175          (ramDataOut_0_288[463])
                                              , .RD_174          (ramDataOut_0_288[462])
                                              , .RD_173          (ramDataOut_0_288[461])
                                              , .RD_172          (ramDataOut_0_288[460])
                                              , .RD_171          (ramDataOut_0_288[459])
                                              , .RD_170          (ramDataOut_0_288[458])
                                              , .RD_169          (ramDataOut_0_288[457])
                                              , .RD_168          (ramDataOut_0_288[456])
                                              , .RD_167          (ramDataOut_0_288[455])
                                              , .RD_166          (ramDataOut_0_288[454])
                                              , .RD_165          (ramDataOut_0_288[453])
                                              , .RD_164          (ramDataOut_0_288[452])
                                              , .RD_163          (ramDataOut_0_288[451])
                                              , .RD_162          (ramDataOut_0_288[450])
                                              , .RD_161          (ramDataOut_0_288[449])
                                              , .RD_160          (ramDataOut_0_288[448])
                                              , .RD_159          (ramDataOut_0_288[447])
                                              , .RD_158          (ramDataOut_0_288[446])
                                              , .RD_157          (ramDataOut_0_288[445])
                                              , .RD_156          (ramDataOut_0_288[444])
                                              , .RD_155          (ramDataOut_0_288[443])
                                              , .RD_154          (ramDataOut_0_288[442])
                                              , .RD_153          (ramDataOut_0_288[441])
                                              , .RD_152          (ramDataOut_0_288[440])
                                              , .RD_151          (ramDataOut_0_288[439])
                                              , .RD_150          (ramDataOut_0_288[438])
                                              , .RD_149          (ramDataOut_0_288[437])
                                              , .RD_148          (ramDataOut_0_288[436])
                                              , .RD_147          (ramDataOut_0_288[435])
                                              , .RD_146          (ramDataOut_0_288[434])
                                              , .RD_145          (ramDataOut_0_288[433])
                                              , .RD_144          (ramDataOut_0_288[432])
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

// -----------------  begin Ram Cell RAMPDP_32X192_GL_M1_D2_0_576 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_576 = !(|muxed_we_w0_0_576) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_576 = muxed_re_r0_0_576 | ( scan_en & jtag_readonly_mode );
wire reb_0_576 = !piece_re_0_576;
// Declare the ramOutData which connects to the ram directly
wire [767:576] ramDataOut_0_576;
assign dout_0_576[767:576] = ramDataOut_0_576[767:576];
RAMPDP_32X192_GL_M1_D2 ram_Inst_32X192_0_576 (
                                                .CLK             (gated_clk_core_0_576)
                                              , .WADR_4          (wa_0_576[4])
                                              , .WADR_3          (wa_0_576[3])
                                              , .WADR_2          (wa_0_576[2])
                                              , .WADR_1          (wa_0_576[1])
                                              , .WADR_0          (wa_0_576[0])
                                              , .WD_191          (Wdata_0_576[767])
                                              , .WD_190          (Wdata_0_576[766])
                                              , .WD_189          (Wdata_0_576[765])
                                              , .WD_188          (Wdata_0_576[764])
                                              , .WD_187          (Wdata_0_576[763])
                                              , .WD_186          (Wdata_0_576[762])
                                              , .WD_185          (Wdata_0_576[761])
                                              , .WD_184          (Wdata_0_576[760])
                                              , .WD_183          (Wdata_0_576[759])
                                              , .WD_182          (Wdata_0_576[758])
                                              , .WD_181          (Wdata_0_576[757])
                                              , .WD_180          (Wdata_0_576[756])
                                              , .WD_179          (Wdata_0_576[755])
                                              , .WD_178          (Wdata_0_576[754])
                                              , .WD_177          (Wdata_0_576[753])
                                              , .WD_176          (Wdata_0_576[752])
                                              , .WD_175          (Wdata_0_576[751])
                                              , .WD_174          (Wdata_0_576[750])
                                              , .WD_173          (Wdata_0_576[749])
                                              , .WD_172          (Wdata_0_576[748])
                                              , .WD_171          (Wdata_0_576[747])
                                              , .WD_170          (Wdata_0_576[746])
                                              , .WD_169          (Wdata_0_576[745])
                                              , .WD_168          (Wdata_0_576[744])
                                              , .WD_167          (Wdata_0_576[743])
                                              , .WD_166          (Wdata_0_576[742])
                                              , .WD_165          (Wdata_0_576[741])
                                              , .WD_164          (Wdata_0_576[740])
                                              , .WD_163          (Wdata_0_576[739])
                                              , .WD_162          (Wdata_0_576[738])
                                              , .WD_161          (Wdata_0_576[737])
                                              , .WD_160          (Wdata_0_576[736])
                                              , .WD_159          (Wdata_0_576[735])
                                              , .WD_158          (Wdata_0_576[734])
                                              , .WD_157          (Wdata_0_576[733])
                                              , .WD_156          (Wdata_0_576[732])
                                              , .WD_155          (Wdata_0_576[731])
                                              , .WD_154          (Wdata_0_576[730])
                                              , .WD_153          (Wdata_0_576[729])
                                              , .WD_152          (Wdata_0_576[728])
                                              , .WD_151          (Wdata_0_576[727])
                                              , .WD_150          (Wdata_0_576[726])
                                              , .WD_149          (Wdata_0_576[725])
                                              , .WD_148          (Wdata_0_576[724])
                                              , .WD_147          (Wdata_0_576[723])
                                              , .WD_146          (Wdata_0_576[722])
                                              , .WD_145          (Wdata_0_576[721])
                                              , .WD_144          (Wdata_0_576[720])
                                              , .WD_143          (Wdata_0_576[719])
                                              , .WD_142          (Wdata_0_576[718])
                                              , .WD_141          (Wdata_0_576[717])
                                              , .WD_140          (Wdata_0_576[716])
                                              , .WD_139          (Wdata_0_576[715])
                                              , .WD_138          (Wdata_0_576[714])
                                              , .WD_137          (Wdata_0_576[713])
                                              , .WD_136          (Wdata_0_576[712])
                                              , .WD_135          (Wdata_0_576[711])
                                              , .WD_134          (Wdata_0_576[710])
                                              , .WD_133          (Wdata_0_576[709])
                                              , .WD_132          (Wdata_0_576[708])
                                              , .WD_131          (Wdata_0_576[707])
                                              , .WD_130          (Wdata_0_576[706])
                                              , .WD_129          (Wdata_0_576[705])
                                              , .WD_128          (Wdata_0_576[704])
                                              , .WD_127          (Wdata_0_576[703])
                                              , .WD_126          (Wdata_0_576[702])
                                              , .WD_125          (Wdata_0_576[701])
                                              , .WD_124          (Wdata_0_576[700])
                                              , .WD_123          (Wdata_0_576[699])
                                              , .WD_122          (Wdata_0_576[698])
                                              , .WD_121          (Wdata_0_576[697])
                                              , .WD_120          (Wdata_0_576[696])
                                              , .WD_119          (Wdata_0_576[695])
                                              , .WD_118          (Wdata_0_576[694])
                                              , .WD_117          (Wdata_0_576[693])
                                              , .WD_116          (Wdata_0_576[692])
                                              , .WD_115          (Wdata_0_576[691])
                                              , .WD_114          (Wdata_0_576[690])
                                              , .WD_113          (Wdata_0_576[689])
                                              , .WD_112          (Wdata_0_576[688])
                                              , .WD_111          (Wdata_0_576[687])
                                              , .WD_110          (Wdata_0_576[686])
                                              , .WD_109          (Wdata_0_576[685])
                                              , .WD_108          (Wdata_0_576[684])
                                              , .WD_107          (Wdata_0_576[683])
                                              , .WD_106          (Wdata_0_576[682])
                                              , .WD_105          (Wdata_0_576[681])
                                              , .WD_104          (Wdata_0_576[680])
                                              , .WD_103          (Wdata_0_576[679])
                                              , .WD_102          (Wdata_0_576[678])
                                              , .WD_101          (Wdata_0_576[677])
                                              , .WD_100          (Wdata_0_576[676])
                                              , .WD_99           (Wdata_0_576[675])
                                              , .WD_98           (Wdata_0_576[674])
                                              , .WD_97           (Wdata_0_576[673])
                                              , .WD_96           (Wdata_0_576[672])
                                              , .WD_95           (Wdata_0_576[671])
                                              , .WD_94           (Wdata_0_576[670])
                                              , .WD_93           (Wdata_0_576[669])
                                              , .WD_92           (Wdata_0_576[668])
                                              , .WD_91           (Wdata_0_576[667])
                                              , .WD_90           (Wdata_0_576[666])
                                              , .WD_89           (Wdata_0_576[665])
                                              , .WD_88           (Wdata_0_576[664])
                                              , .WD_87           (Wdata_0_576[663])
                                              , .WD_86           (Wdata_0_576[662])
                                              , .WD_85           (Wdata_0_576[661])
                                              , .WD_84           (Wdata_0_576[660])
                                              , .WD_83           (Wdata_0_576[659])
                                              , .WD_82           (Wdata_0_576[658])
                                              , .WD_81           (Wdata_0_576[657])
                                              , .WD_80           (Wdata_0_576[656])
                                              , .WD_79           (Wdata_0_576[655])
                                              , .WD_78           (Wdata_0_576[654])
                                              , .WD_77           (Wdata_0_576[653])
                                              , .WD_76           (Wdata_0_576[652])
                                              , .WD_75           (Wdata_0_576[651])
                                              , .WD_74           (Wdata_0_576[650])
                                              , .WD_73           (Wdata_0_576[649])
                                              , .WD_72           (Wdata_0_576[648])
                                              , .WD_71           (Wdata_0_576[647])
                                              , .WD_70           (Wdata_0_576[646])
                                              , .WD_69           (Wdata_0_576[645])
                                              , .WD_68           (Wdata_0_576[644])
                                              , .WD_67           (Wdata_0_576[643])
                                              , .WD_66           (Wdata_0_576[642])
                                              , .WD_65           (Wdata_0_576[641])
                                              , .WD_64           (Wdata_0_576[640])
                                              , .WD_63           (Wdata_0_576[639])
                                              , .WD_62           (Wdata_0_576[638])
                                              , .WD_61           (Wdata_0_576[637])
                                              , .WD_60           (Wdata_0_576[636])
                                              , .WD_59           (Wdata_0_576[635])
                                              , .WD_58           (Wdata_0_576[634])
                                              , .WD_57           (Wdata_0_576[633])
                                              , .WD_56           (Wdata_0_576[632])
                                              , .WD_55           (Wdata_0_576[631])
                                              , .WD_54           (Wdata_0_576[630])
                                              , .WD_53           (Wdata_0_576[629])
                                              , .WD_52           (Wdata_0_576[628])
                                              , .WD_51           (Wdata_0_576[627])
                                              , .WD_50           (Wdata_0_576[626])
                                              , .WD_49           (Wdata_0_576[625])
                                              , .WD_48           (Wdata_0_576[624])
                                              , .WD_47           (Wdata_0_576[623])
                                              , .WD_46           (Wdata_0_576[622])
                                              , .WD_45           (Wdata_0_576[621])
                                              , .WD_44           (Wdata_0_576[620])
                                              , .WD_43           (Wdata_0_576[619])
                                              , .WD_42           (Wdata_0_576[618])
                                              , .WD_41           (Wdata_0_576[617])
                                              , .WD_40           (Wdata_0_576[616])
                                              , .WD_39           (Wdata_0_576[615])
                                              , .WD_38           (Wdata_0_576[614])
                                              , .WD_37           (Wdata_0_576[613])
                                              , .WD_36           (Wdata_0_576[612])
                                              , .WD_35           (Wdata_0_576[611])
                                              , .WD_34           (Wdata_0_576[610])
                                              , .WD_33           (Wdata_0_576[609])
                                              , .WD_32           (Wdata_0_576[608])
                                              , .WD_31           (Wdata_0_576[607])
                                              , .WD_30           (Wdata_0_576[606])
                                              , .WD_29           (Wdata_0_576[605])
                                              , .WD_28           (Wdata_0_576[604])
                                              , .WD_27           (Wdata_0_576[603])
                                              , .WD_26           (Wdata_0_576[602])
                                              , .WD_25           (Wdata_0_576[601])
                                              , .WD_24           (Wdata_0_576[600])
                                              , .WD_23           (Wdata_0_576[599])
                                              , .WD_22           (Wdata_0_576[598])
                                              , .WD_21           (Wdata_0_576[597])
                                              , .WD_20           (Wdata_0_576[596])
                                              , .WD_19           (Wdata_0_576[595])
                                              , .WD_18           (Wdata_0_576[594])
                                              , .WD_17           (Wdata_0_576[593])
                                              , .WD_16           (Wdata_0_576[592])
                                              , .WD_15           (Wdata_0_576[591])
                                              , .WD_14           (Wdata_0_576[590])
                                              , .WD_13           (Wdata_0_576[589])
                                              , .WD_12           (Wdata_0_576[588])
                                              , .WD_11           (Wdata_0_576[587])
                                              , .WD_10           (Wdata_0_576[586])
                                              , .WD_9            (Wdata_0_576[585])
                                              , .WD_8            (Wdata_0_576[584])
                                              , .WD_7            (Wdata_0_576[583])
                                              , .WD_6            (Wdata_0_576[582])
                                              , .WD_5            (Wdata_0_576[581])
                                              , .WD_4            (Wdata_0_576[580])
                                              , .WD_3            (Wdata_0_576[579])
                                              , .WD_2            (Wdata_0_576[578])
                                              , .WD_1            (Wdata_0_576[577])
                                              , .WD_0            (Wdata_0_576[576])
                                              , .WE              (!web_0_576)
                                              , .RADR_4          (ra_0_576 [4])
                                              , .RADR_3          (ra_0_576 [3])
                                              , .RADR_2          (ra_0_576 [2])
                                              , .RADR_1          (ra_0_576 [1])
                                              , .RADR_0          (ra_0_576 [0])
                                              , .RE              (!reb_0_576)
                                              , .RD_191          (ramDataOut_0_576[767])
                                              , .RD_190          (ramDataOut_0_576[766])
                                              , .RD_189          (ramDataOut_0_576[765])
                                              , .RD_188          (ramDataOut_0_576[764])
                                              , .RD_187          (ramDataOut_0_576[763])
                                              , .RD_186          (ramDataOut_0_576[762])
                                              , .RD_185          (ramDataOut_0_576[761])
                                              , .RD_184          (ramDataOut_0_576[760])
                                              , .RD_183          (ramDataOut_0_576[759])
                                              , .RD_182          (ramDataOut_0_576[758])
                                              , .RD_181          (ramDataOut_0_576[757])
                                              , .RD_180          (ramDataOut_0_576[756])
                                              , .RD_179          (ramDataOut_0_576[755])
                                              , .RD_178          (ramDataOut_0_576[754])
                                              , .RD_177          (ramDataOut_0_576[753])
                                              , .RD_176          (ramDataOut_0_576[752])
                                              , .RD_175          (ramDataOut_0_576[751])
                                              , .RD_174          (ramDataOut_0_576[750])
                                              , .RD_173          (ramDataOut_0_576[749])
                                              , .RD_172          (ramDataOut_0_576[748])
                                              , .RD_171          (ramDataOut_0_576[747])
                                              , .RD_170          (ramDataOut_0_576[746])
                                              , .RD_169          (ramDataOut_0_576[745])
                                              , .RD_168          (ramDataOut_0_576[744])
                                              , .RD_167          (ramDataOut_0_576[743])
                                              , .RD_166          (ramDataOut_0_576[742])
                                              , .RD_165          (ramDataOut_0_576[741])
                                              , .RD_164          (ramDataOut_0_576[740])
                                              , .RD_163          (ramDataOut_0_576[739])
                                              , .RD_162          (ramDataOut_0_576[738])
                                              , .RD_161          (ramDataOut_0_576[737])
                                              , .RD_160          (ramDataOut_0_576[736])
                                              , .RD_159          (ramDataOut_0_576[735])
                                              , .RD_158          (ramDataOut_0_576[734])
                                              , .RD_157          (ramDataOut_0_576[733])
                                              , .RD_156          (ramDataOut_0_576[732])
                                              , .RD_155          (ramDataOut_0_576[731])
                                              , .RD_154          (ramDataOut_0_576[730])
                                              , .RD_153          (ramDataOut_0_576[729])
                                              , .RD_152          (ramDataOut_0_576[728])
                                              , .RD_151          (ramDataOut_0_576[727])
                                              , .RD_150          (ramDataOut_0_576[726])
                                              , .RD_149          (ramDataOut_0_576[725])
                                              , .RD_148          (ramDataOut_0_576[724])
                                              , .RD_147          (ramDataOut_0_576[723])
                                              , .RD_146          (ramDataOut_0_576[722])
                                              , .RD_145          (ramDataOut_0_576[721])
                                              , .RD_144          (ramDataOut_0_576[720])
                                              , .RD_143          (ramDataOut_0_576[719])
                                              , .RD_142          (ramDataOut_0_576[718])
                                              , .RD_141          (ramDataOut_0_576[717])
                                              , .RD_140          (ramDataOut_0_576[716])
                                              , .RD_139          (ramDataOut_0_576[715])
                                              , .RD_138          (ramDataOut_0_576[714])
                                              , .RD_137          (ramDataOut_0_576[713])
                                              , .RD_136          (ramDataOut_0_576[712])
                                              , .RD_135          (ramDataOut_0_576[711])
                                              , .RD_134          (ramDataOut_0_576[710])
                                              , .RD_133          (ramDataOut_0_576[709])
                                              , .RD_132          (ramDataOut_0_576[708])
                                              , .RD_131          (ramDataOut_0_576[707])
                                              , .RD_130          (ramDataOut_0_576[706])
                                              , .RD_129          (ramDataOut_0_576[705])
                                              , .RD_128          (ramDataOut_0_576[704])
                                              , .RD_127          (ramDataOut_0_576[703])
                                              , .RD_126          (ramDataOut_0_576[702])
                                              , .RD_125          (ramDataOut_0_576[701])
                                              , .RD_124          (ramDataOut_0_576[700])
                                              , .RD_123          (ramDataOut_0_576[699])
                                              , .RD_122          (ramDataOut_0_576[698])
                                              , .RD_121          (ramDataOut_0_576[697])
                                              , .RD_120          (ramDataOut_0_576[696])
                                              , .RD_119          (ramDataOut_0_576[695])
                                              , .RD_118          (ramDataOut_0_576[694])
                                              , .RD_117          (ramDataOut_0_576[693])
                                              , .RD_116          (ramDataOut_0_576[692])
                                              , .RD_115          (ramDataOut_0_576[691])
                                              , .RD_114          (ramDataOut_0_576[690])
                                              , .RD_113          (ramDataOut_0_576[689])
                                              , .RD_112          (ramDataOut_0_576[688])
                                              , .RD_111          (ramDataOut_0_576[687])
                                              , .RD_110          (ramDataOut_0_576[686])
                                              , .RD_109          (ramDataOut_0_576[685])
                                              , .RD_108          (ramDataOut_0_576[684])
                                              , .RD_107          (ramDataOut_0_576[683])
                                              , .RD_106          (ramDataOut_0_576[682])
                                              , .RD_105          (ramDataOut_0_576[681])
                                              , .RD_104          (ramDataOut_0_576[680])
                                              , .RD_103          (ramDataOut_0_576[679])
                                              , .RD_102          (ramDataOut_0_576[678])
                                              , .RD_101          (ramDataOut_0_576[677])
                                              , .RD_100          (ramDataOut_0_576[676])
                                              , .RD_99           (ramDataOut_0_576[675])
                                              , .RD_98           (ramDataOut_0_576[674])
                                              , .RD_97           (ramDataOut_0_576[673])
                                              , .RD_96           (ramDataOut_0_576[672])
                                              , .RD_95           (ramDataOut_0_576[671])
                                              , .RD_94           (ramDataOut_0_576[670])
                                              , .RD_93           (ramDataOut_0_576[669])
                                              , .RD_92           (ramDataOut_0_576[668])
                                              , .RD_91           (ramDataOut_0_576[667])
                                              , .RD_90           (ramDataOut_0_576[666])
                                              , .RD_89           (ramDataOut_0_576[665])
                                              , .RD_88           (ramDataOut_0_576[664])
                                              , .RD_87           (ramDataOut_0_576[663])
                                              , .RD_86           (ramDataOut_0_576[662])
                                              , .RD_85           (ramDataOut_0_576[661])
                                              , .RD_84           (ramDataOut_0_576[660])
                                              , .RD_83           (ramDataOut_0_576[659])
                                              , .RD_82           (ramDataOut_0_576[658])
                                              , .RD_81           (ramDataOut_0_576[657])
                                              , .RD_80           (ramDataOut_0_576[656])
                                              , .RD_79           (ramDataOut_0_576[655])
                                              , .RD_78           (ramDataOut_0_576[654])
                                              , .RD_77           (ramDataOut_0_576[653])
                                              , .RD_76           (ramDataOut_0_576[652])
                                              , .RD_75           (ramDataOut_0_576[651])
                                              , .RD_74           (ramDataOut_0_576[650])
                                              , .RD_73           (ramDataOut_0_576[649])
                                              , .RD_72           (ramDataOut_0_576[648])
                                              , .RD_71           (ramDataOut_0_576[647])
                                              , .RD_70           (ramDataOut_0_576[646])
                                              , .RD_69           (ramDataOut_0_576[645])
                                              , .RD_68           (ramDataOut_0_576[644])
                                              , .RD_67           (ramDataOut_0_576[643])
                                              , .RD_66           (ramDataOut_0_576[642])
                                              , .RD_65           (ramDataOut_0_576[641])
                                              , .RD_64           (ramDataOut_0_576[640])
                                              , .RD_63           (ramDataOut_0_576[639])
                                              , .RD_62           (ramDataOut_0_576[638])
                                              , .RD_61           (ramDataOut_0_576[637])
                                              , .RD_60           (ramDataOut_0_576[636])
                                              , .RD_59           (ramDataOut_0_576[635])
                                              , .RD_58           (ramDataOut_0_576[634])
                                              , .RD_57           (ramDataOut_0_576[633])
                                              , .RD_56           (ramDataOut_0_576[632])
                                              , .RD_55           (ramDataOut_0_576[631])
                                              , .RD_54           (ramDataOut_0_576[630])
                                              , .RD_53           (ramDataOut_0_576[629])
                                              , .RD_52           (ramDataOut_0_576[628])
                                              , .RD_51           (ramDataOut_0_576[627])
                                              , .RD_50           (ramDataOut_0_576[626])
                                              , .RD_49           (ramDataOut_0_576[625])
                                              , .RD_48           (ramDataOut_0_576[624])
                                              , .RD_47           (ramDataOut_0_576[623])
                                              , .RD_46           (ramDataOut_0_576[622])
                                              , .RD_45           (ramDataOut_0_576[621])
                                              , .RD_44           (ramDataOut_0_576[620])
                                              , .RD_43           (ramDataOut_0_576[619])
                                              , .RD_42           (ramDataOut_0_576[618])
                                              , .RD_41           (ramDataOut_0_576[617])
                                              , .RD_40           (ramDataOut_0_576[616])
                                              , .RD_39           (ramDataOut_0_576[615])
                                              , .RD_38           (ramDataOut_0_576[614])
                                              , .RD_37           (ramDataOut_0_576[613])
                                              , .RD_36           (ramDataOut_0_576[612])
                                              , .RD_35           (ramDataOut_0_576[611])
                                              , .RD_34           (ramDataOut_0_576[610])
                                              , .RD_33           (ramDataOut_0_576[609])
                                              , .RD_32           (ramDataOut_0_576[608])
                                              , .RD_31           (ramDataOut_0_576[607])
                                              , .RD_30           (ramDataOut_0_576[606])
                                              , .RD_29           (ramDataOut_0_576[605])
                                              , .RD_28           (ramDataOut_0_576[604])
                                              , .RD_27           (ramDataOut_0_576[603])
                                              , .RD_26           (ramDataOut_0_576[602])
                                              , .RD_25           (ramDataOut_0_576[601])
                                              , .RD_24           (ramDataOut_0_576[600])
                                              , .RD_23           (ramDataOut_0_576[599])
                                              , .RD_22           (ramDataOut_0_576[598])
                                              , .RD_21           (ramDataOut_0_576[597])
                                              , .RD_20           (ramDataOut_0_576[596])
                                              , .RD_19           (ramDataOut_0_576[595])
                                              , .RD_18           (ramDataOut_0_576[594])
                                              , .RD_17           (ramDataOut_0_576[593])
                                              , .RD_16           (ramDataOut_0_576[592])
                                              , .RD_15           (ramDataOut_0_576[591])
                                              , .RD_14           (ramDataOut_0_576[590])
                                              , .RD_13           (ramDataOut_0_576[589])
                                              , .RD_12           (ramDataOut_0_576[588])
                                              , .RD_11           (ramDataOut_0_576[587])
                                              , .RD_10           (ramDataOut_0_576[586])
                                              , .RD_9            (ramDataOut_0_576[585])
                                              , .RD_8            (ramDataOut_0_576[584])
                                              , .RD_7            (ramDataOut_0_576[583])
                                              , .RD_6            (ramDataOut_0_576[582])
                                              , .RD_5            (ramDataOut_0_576[581])
                                              , .RD_4            (ramDataOut_0_576[580])
                                              , .RD_3            (ramDataOut_0_576[579])
                                              , .RD_2            (ramDataOut_0_576[578])
                                              , .RD_1            (ramDataOut_0_576[577])
                                              , .RD_0            (ramDataOut_0_576[576])
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
reg [767:0] ram_r0_OutputMuxDataOut;

//For bitEnd 287, only one piece RAMPDP_32X288_GL_M1_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_0[287:0] or Data_reg_r0[287:0] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[287:0] = (ram_bypass) ? Data_reg_r0[287:0]: dout_0_0;
end
assign r0_OutputMuxDataOut[287:0] = ram_r0_OutputMuxDataOut[287:0];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 575, only one piece RAMPDP_32X288_GL_M1_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_288[575:288] or Data_reg_r0[575:288] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[575:288] = (ram_bypass) ? Data_reg_r0[575:288]: dout_0_288;
end
assign r0_OutputMuxDataOut[575:288] = ram_r0_OutputMuxDataOut[575:288];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 767, only one piece RAMPDP_32X192_GL_M1_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_576[767:576] or Data_reg_r0[767:576] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[767:576] = (ram_bypass) ? Data_reg_r0[767:576]: dout_0_576;
end
assign r0_OutputMuxDataOut[767:576] = ram_r0_OutputMuxDataOut[767:576];
// verilint 17 on - Range (rather than full vector) in the sensitivity list



// --------------------- Output Mbist Interface logic  -------------


// new mux in front of the data register

reg [768-1:0] muxed_Data_r0;
wire [768-1:0] muxed_Data_A, muxed_Data_B;
wire muxed_Data_S;

assign muxed_Data_S = debug_mode_sync ? (re_reg_r0_0_0 | re_reg_r0_0_288 | re_reg_r0_0_576) : mbist_en_r;
assign muxed_Data_A = muxed_Di_w0;
assign muxed_Data_B = r0_OutputMuxDataOut;

always @(muxed_Data_S or muxed_Data_A or muxed_Data_B)
  case(muxed_Data_S) // synopsys infer_mux
    1'b0 : muxed_Data_r0 = muxed_Data_A;
    1'b1 : muxed_Data_r0 = muxed_Data_B;
    default : muxed_Data_r0 = {768{`tick_x_or_0}};
  endcase
reg mbist_ce_r0_0_0_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_0_1p <= mbist_ce_r0_0_0;
reg mbist_ce_r0_0_288_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_288_1p <= mbist_ce_r0_0_288;
reg mbist_ce_r0_0_576_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_576_1p <= mbist_ce_r0_0_576;
wire captureDR_r0 = dft_capdr_r | (( debug_mode_sync ? (1'b1& (access_en_r_1p_0_0 | access_en_r_1p_0_288 | access_en_r_1p_0_576)) :  ((mbist_en_r & (mbist_ce_r0_0_0_1p | mbist_ce_r0_0_288_1p | mbist_ce_r0_0_576_1p) & !1'b0))));
////MSB 767 LSB 0  and total rambit is 768 and  dsize is 768

wire Data_reg_SO_r0;
// verilint 110 off - Incompatible width
// verilint 630 off - Port connected to a NULL expression
// These are used for registering Ra in case of Latch arrays as well (i.e. 
// used in functional path as well)
wire [767:0]data_regq;
assign Data_reg_r0[767:0] = data_regq[767:0] ;

// verilint 110 on - Incompatible width
// verilint 630 on - Port connected to a NULL expression
assign dout = r0_OutputMuxDataOut;
assign mbist_Do_r0_int_net = Data_reg_r0[768-1:0];

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
    
ScanShareSel_JTAG_reg_ext_cg #(5, 0, 0) testInst_Wa_reg_w0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_Wa_w0), .Q(wadr_q),
            .scanin(SI), .scanout(Wa_reg_SO_w0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_0), .Q(we_0_0_q),
            .scanin(Wa_reg_SO_w0), .scanout(we_reg_SO_w0_0_0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_288 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_288), .Q(we_0_288_q),
            .scanin(we_reg_SO_w0_0_0), .scanout(we_reg_SO_w0_0_288)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0_0_576 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0_0_576), .Q(we_0_576_q),
            .scanin(we_reg_SO_w0_0_288), .scanout(we_reg_SO_w0_0_576)  );
    
ScanShareSel_JTAG_reg_ext_cg #(5, 0, 0) testInst_Ra_reg_r0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_Ra_r0), .Q(radr_q),
            .scanin(we_reg_SO_w0_0_576), .scanout(Ra_reg_SO_r0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_0), .Q(re_0_0_q),
            .scanin(Ra_reg_SO_r0), .scanout(re_reg_SO_r0_0_0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_288 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_288), .Q(re_0_288_q),
            .scanin(re_reg_SO_r0_0_0), .scanout(re_reg_SO_r0_0_288)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_576 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_576), .Q(re_0_576_q),
            .scanin(re_reg_SO_r0_0_288), .scanout(re_reg_SO_r0_0_576)  );
wire gated_clk_jtag_Data_reg_r0;
CKLNQD12PO4  UJ_clk_jtag_Data_reg_r0 (.Q(gated_clk_jtag_Data_reg_r0), .CP(clk), .E(captureDR_r0 | (debug_mode_sync & shiftDR)), .TE(scan_en));
wire [767:0] Data_reg_r0_D = muxed_Data_r0[767:0];
wire [767:0] Data_reg_r0_Q;
assign data_regq[767:0] = Data_reg_r0_Q;
wire so_Data_reg_r0_767_512;

ScanShareSel_JTAG_reg_ext_cg #(256, 0, 0) testInst_Data_reg_r0_767_512 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[767:512]), .Q(Data_reg_r0_Q[767:512]),
            .scanin(re_reg_SO_r0_0_576), .scanout(so_Data_reg_r0_767_512)  );
wire so_Data_reg_r0_511_256;

ScanShareSel_JTAG_reg_ext_cg #(256, 0, 0) testInst_Data_reg_r0_511_256 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[511:256]), .Q(Data_reg_r0_Q[511:256]),
            .scanin(so_Data_reg_r0_767_512), .scanout(so_Data_reg_r0_511_256)  );

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
reg [32-1:0] written; 
always@(posedge clk or negedge sim_reset_) begin 
   if(!sim_reset_) begin 
      written <= {32{1'b0}}; 
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
