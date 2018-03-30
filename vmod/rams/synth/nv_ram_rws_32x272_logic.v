// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rws_32x272_logic.v

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


module nv_ram_rws_32x272_logic (
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
               mbist_ce_r0,
               mbist_en_sync,
               mbist_ramaccess_rst_,
               mbist_we_w0,
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
input  [271:0]  di;
output [271:0]  dout;
input           iddq_mode;
input           jtag_readonly_mode;
input  [1:0]    mbist_Di_w0;
output [271:0]  mbist_Do_r0_int_net;
input  [4:0]    mbist_Ra_r0;
input  [4:0]    mbist_Wa_w0;
input           mbist_ce_r0;
input           mbist_en_sync;
input           mbist_ramaccess_rst_;
input           mbist_we_w0;
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
reg [4:0] Ra_array_reg_r0;

wire mbist_en_r;
// hardcode mbist_en_r stdcell flop to avoid x bash recoverability issue described in bug 1803479 comment #7
p_SDFCNQD1PO4 mbist_en_flop(.D(mbist_en_sync), .CP(dft_rst_gated_clk), .Q(mbist_en_r), .CDN(mbist_ramaccess_rst_));

// Declare the Data_reg signal beforehand
wire [271:0] Data_reg_r0;


 // Data out bus for read port r0 for Output Mux
wire [271:0] r0_OutputMuxDataOut;
CKLNQD12PO4  UJ_la_bist_clkw0_gate (.Q(la_bist_clkw0), .CP(clk), .E(mbist_en_r | debug_mode_sync), .TE(scan_en));

// Write enable bus
wire  we_0_0;

// Read enable bus
wire re_0_0;
// start of predeclareNvregSignals
wire ctx_ctrl_we;
wire clk_en_core = (re_0_0 | (|we_0_0));
wire gated_clk_core;
CKLNQD12PO4  UJ_clk_gate_core (.Q(gated_clk_core), .CP(clk), .E(clk_en_core), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire shiftDR_en;

reg [271:0] pre_muxed_Di_w0;
wire [271:0] pre_muxed_Di_w0_A, pre_muxed_Di_w0_B;
wire pre_muxed_Di_w0_S;

assign pre_muxed_Di_w0_S = !debug_mode_sync;
assign pre_muxed_Di_w0_A = Data_reg_r0[271:0];
assign pre_muxed_Di_w0_B = {{136{mbist_Di_w0}}};

always @(pre_muxed_Di_w0_S or pre_muxed_Di_w0_A or pre_muxed_Di_w0_B)
    case(pre_muxed_Di_w0_S) // synopsys infer_mux
      1'b0 : pre_muxed_Di_w0 = pre_muxed_Di_w0_A;
      1'b1 : pre_muxed_Di_w0 = pre_muxed_Di_w0_B;
      default : pre_muxed_Di_w0 = {272{`tick_x_or_0}};
    endcase

reg [271:0] muxed_Di_w0;
wire [271:0] muxed_Di_w0_A, muxed_Di_w0_B;
assign muxed_Di_w0_A = {di[271:0]};
assign muxed_Di_w0_B = pre_muxed_Di_w0;

wire muxed_Di_w0_S = debug_mode_sync | mbist_en_r;
always @(muxed_Di_w0_S or muxed_Di_w0_A or muxed_Di_w0_B)
    case(muxed_Di_w0_S) // synopsys infer_mux
      1'b0 : muxed_Di_w0 = muxed_Di_w0_A;
      1'b1 : muxed_Di_w0 = muxed_Di_w0_B;
      default : muxed_Di_w0 = {272{`tick_x_or_0}};
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
wire we_reg_SO_w0;
wire re_reg_SO_r0;

wire we_reg_w0;
wire pre_we_w0;
assign pre_we_w0 = debug_mode_sync ?
        ({1{posedge_updateDR_sync}} & we_reg_w0) :  
        {1{(mbist_en_r & mbist_we_w0)}};

reg  muxed_we_w0;
wire muxed_we_w0_A, muxed_we_w0_B;
wire muxed_we_w0_S;

assign muxed_we_w0_S = debug_mode_sync | mbist_en_r;
assign muxed_we_w0_A = we_0_0;
assign muxed_we_w0_B = pre_we_w0;

always @(muxed_we_w0_S or muxed_we_w0_A or muxed_we_w0_B)
case(muxed_we_w0_S) // synopsys infer_mux
  1'b0 : muxed_we_w0 = muxed_we_w0_A;
  1'b1 : muxed_we_w0 = muxed_we_w0_B;
  default : muxed_we_w0 = {1{`tick_x_or_0}};
endcase


wire we_q;
assign we_reg_w0 = we_q ;

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

wire re_reg_r0;
wire access_en_r = posedge_updateDR_sync & re_reg_r0;
reg access_en_r_1p;
always @(posedge la_bist_clkw0 or negedge mbist_ramaccess_rst_)
  if (!mbist_ramaccess_rst_)
     access_en_r_1p <= 1'b0;
  else 
     access_en_r_1p <= access_en_r;

wire pre_re_r0;

assign pre_re_r0 = (debug_mode_sync) ?
    (posedge_updateDR_sync & re_reg_r0) :
    (mbist_en_r & mbist_ce_r0); 
reg  muxed_re_r0;
wire muxed_re_r0_A, muxed_re_r0_B;
wire muxed_re_r0_S;

assign muxed_re_r0_S = debug_mode_sync | mbist_en_r;
assign muxed_re_r0_A = re;
assign muxed_re_r0_B = pre_re_r0;

always @(muxed_re_r0_S or muxed_re_r0_A or muxed_re_r0_B)
case(muxed_re_r0_S) // synopsys infer_mux
  1'b0 : muxed_re_r0 = muxed_re_r0_A;
  1'b1 : muxed_re_r0 = muxed_re_r0_B;
  default : muxed_re_r0 = `tick_x_or_0;
endcase
wire re_q;
assign re_reg_r0 = re_q ;

// ------------------  START PIECE ----------------------------------
// Suffix  : Piece RAMPDP_32X272_GL_M1_D2 (RamCell)
// Covers Addresses from 0 to 31  Addressrange: [4:0]  
// Data Bit range: [271:0] (272 bits)   
// Enables: 1   Enable range: 




// Write Address bus

wire [4:0] wa_0_0;
assign wa_0_0 = muxed_Wa_w0[4:0];

// Write Data in bus
wire [271:0] Wdata;
assign Wdata = muxed_Di_w0[271:0];
assign we_0_0 = we;

// Read Address bus
wire [4:0] ra_0_0;
assign ra_0_0 = muxed_Ra_r0[4:0];

// Read DataOut bus
wire [271:0] dout_0_0;
assign re_0_0 = re;


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

// -----------------  begin Ram Cell RAMPDP_32X272_GL_M1_D2 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web = !(|muxed_we_w0) | write_inh;


// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re = muxed_re_r0 | ( scan_en & jtag_readonly_mode );
wire reb = !piece_re;
// Declare the ramOutData which connects to the ram directly
wire [271:0] ramDataOut;
assign dout_0_0[271:0] = ramDataOut[271:0];
RAMPDP_32X272_GL_M1_D2 ram_Inst_32X272 (
                                          .CLK             (gated_clk_core)
                                        , .WADR_4          (wa_0_0[4])
                                        , .WADR_3          (wa_0_0[3])
                                        , .WADR_2          (wa_0_0[2])
                                        , .WADR_1          (wa_0_0[1])
                                        , .WADR_0          (wa_0_0[0])
                                        , .WD_271          (Wdata[271])
                                        , .WD_270          (Wdata[270])
                                        , .WD_269          (Wdata[269])
                                        , .WD_268          (Wdata[268])
                                        , .WD_267          (Wdata[267])
                                        , .WD_266          (Wdata[266])
                                        , .WD_265          (Wdata[265])
                                        , .WD_264          (Wdata[264])
                                        , .WD_263          (Wdata[263])
                                        , .WD_262          (Wdata[262])
                                        , .WD_261          (Wdata[261])
                                        , .WD_260          (Wdata[260])
                                        , .WD_259          (Wdata[259])
                                        , .WD_258          (Wdata[258])
                                        , .WD_257          (Wdata[257])
                                        , .WD_256          (Wdata[256])
                                        , .WD_255          (Wdata[255])
                                        , .WD_254          (Wdata[254])
                                        , .WD_253          (Wdata[253])
                                        , .WD_252          (Wdata[252])
                                        , .WD_251          (Wdata[251])
                                        , .WD_250          (Wdata[250])
                                        , .WD_249          (Wdata[249])
                                        , .WD_248          (Wdata[248])
                                        , .WD_247          (Wdata[247])
                                        , .WD_246          (Wdata[246])
                                        , .WD_245          (Wdata[245])
                                        , .WD_244          (Wdata[244])
                                        , .WD_243          (Wdata[243])
                                        , .WD_242          (Wdata[242])
                                        , .WD_241          (Wdata[241])
                                        , .WD_240          (Wdata[240])
                                        , .WD_239          (Wdata[239])
                                        , .WD_238          (Wdata[238])
                                        , .WD_237          (Wdata[237])
                                        , .WD_236          (Wdata[236])
                                        , .WD_235          (Wdata[235])
                                        , .WD_234          (Wdata[234])
                                        , .WD_233          (Wdata[233])
                                        , .WD_232          (Wdata[232])
                                        , .WD_231          (Wdata[231])
                                        , .WD_230          (Wdata[230])
                                        , .WD_229          (Wdata[229])
                                        , .WD_228          (Wdata[228])
                                        , .WD_227          (Wdata[227])
                                        , .WD_226          (Wdata[226])
                                        , .WD_225          (Wdata[225])
                                        , .WD_224          (Wdata[224])
                                        , .WD_223          (Wdata[223])
                                        , .WD_222          (Wdata[222])
                                        , .WD_221          (Wdata[221])
                                        , .WD_220          (Wdata[220])
                                        , .WD_219          (Wdata[219])
                                        , .WD_218          (Wdata[218])
                                        , .WD_217          (Wdata[217])
                                        , .WD_216          (Wdata[216])
                                        , .WD_215          (Wdata[215])
                                        , .WD_214          (Wdata[214])
                                        , .WD_213          (Wdata[213])
                                        , .WD_212          (Wdata[212])
                                        , .WD_211          (Wdata[211])
                                        , .WD_210          (Wdata[210])
                                        , .WD_209          (Wdata[209])
                                        , .WD_208          (Wdata[208])
                                        , .WD_207          (Wdata[207])
                                        , .WD_206          (Wdata[206])
                                        , .WD_205          (Wdata[205])
                                        , .WD_204          (Wdata[204])
                                        , .WD_203          (Wdata[203])
                                        , .WD_202          (Wdata[202])
                                        , .WD_201          (Wdata[201])
                                        , .WD_200          (Wdata[200])
                                        , .WD_199          (Wdata[199])
                                        , .WD_198          (Wdata[198])
                                        , .WD_197          (Wdata[197])
                                        , .WD_196          (Wdata[196])
                                        , .WD_195          (Wdata[195])
                                        , .WD_194          (Wdata[194])
                                        , .WD_193          (Wdata[193])
                                        , .WD_192          (Wdata[192])
                                        , .WD_191          (Wdata[191])
                                        , .WD_190          (Wdata[190])
                                        , .WD_189          (Wdata[189])
                                        , .WD_188          (Wdata[188])
                                        , .WD_187          (Wdata[187])
                                        , .WD_186          (Wdata[186])
                                        , .WD_185          (Wdata[185])
                                        , .WD_184          (Wdata[184])
                                        , .WD_183          (Wdata[183])
                                        , .WD_182          (Wdata[182])
                                        , .WD_181          (Wdata[181])
                                        , .WD_180          (Wdata[180])
                                        , .WD_179          (Wdata[179])
                                        , .WD_178          (Wdata[178])
                                        , .WD_177          (Wdata[177])
                                        , .WD_176          (Wdata[176])
                                        , .WD_175          (Wdata[175])
                                        , .WD_174          (Wdata[174])
                                        , .WD_173          (Wdata[173])
                                        , .WD_172          (Wdata[172])
                                        , .WD_171          (Wdata[171])
                                        , .WD_170          (Wdata[170])
                                        , .WD_169          (Wdata[169])
                                        , .WD_168          (Wdata[168])
                                        , .WD_167          (Wdata[167])
                                        , .WD_166          (Wdata[166])
                                        , .WD_165          (Wdata[165])
                                        , .WD_164          (Wdata[164])
                                        , .WD_163          (Wdata[163])
                                        , .WD_162          (Wdata[162])
                                        , .WD_161          (Wdata[161])
                                        , .WD_160          (Wdata[160])
                                        , .WD_159          (Wdata[159])
                                        , .WD_158          (Wdata[158])
                                        , .WD_157          (Wdata[157])
                                        , .WD_156          (Wdata[156])
                                        , .WD_155          (Wdata[155])
                                        , .WD_154          (Wdata[154])
                                        , .WD_153          (Wdata[153])
                                        , .WD_152          (Wdata[152])
                                        , .WD_151          (Wdata[151])
                                        , .WD_150          (Wdata[150])
                                        , .WD_149          (Wdata[149])
                                        , .WD_148          (Wdata[148])
                                        , .WD_147          (Wdata[147])
                                        , .WD_146          (Wdata[146])
                                        , .WD_145          (Wdata[145])
                                        , .WD_144          (Wdata[144])
                                        , .WD_143          (Wdata[143])
                                        , .WD_142          (Wdata[142])
                                        , .WD_141          (Wdata[141])
                                        , .WD_140          (Wdata[140])
                                        , .WD_139          (Wdata[139])
                                        , .WD_138          (Wdata[138])
                                        , .WD_137          (Wdata[137])
                                        , .WD_136          (Wdata[136])
                                        , .WD_135          (Wdata[135])
                                        , .WD_134          (Wdata[134])
                                        , .WD_133          (Wdata[133])
                                        , .WD_132          (Wdata[132])
                                        , .WD_131          (Wdata[131])
                                        , .WD_130          (Wdata[130])
                                        , .WD_129          (Wdata[129])
                                        , .WD_128          (Wdata[128])
                                        , .WD_127          (Wdata[127])
                                        , .WD_126          (Wdata[126])
                                        , .WD_125          (Wdata[125])
                                        , .WD_124          (Wdata[124])
                                        , .WD_123          (Wdata[123])
                                        , .WD_122          (Wdata[122])
                                        , .WD_121          (Wdata[121])
                                        , .WD_120          (Wdata[120])
                                        , .WD_119          (Wdata[119])
                                        , .WD_118          (Wdata[118])
                                        , .WD_117          (Wdata[117])
                                        , .WD_116          (Wdata[116])
                                        , .WD_115          (Wdata[115])
                                        , .WD_114          (Wdata[114])
                                        , .WD_113          (Wdata[113])
                                        , .WD_112          (Wdata[112])
                                        , .WD_111          (Wdata[111])
                                        , .WD_110          (Wdata[110])
                                        , .WD_109          (Wdata[109])
                                        , .WD_108          (Wdata[108])
                                        , .WD_107          (Wdata[107])
                                        , .WD_106          (Wdata[106])
                                        , .WD_105          (Wdata[105])
                                        , .WD_104          (Wdata[104])
                                        , .WD_103          (Wdata[103])
                                        , .WD_102          (Wdata[102])
                                        , .WD_101          (Wdata[101])
                                        , .WD_100          (Wdata[100])
                                        , .WD_99           (Wdata[99])
                                        , .WD_98           (Wdata[98])
                                        , .WD_97           (Wdata[97])
                                        , .WD_96           (Wdata[96])
                                        , .WD_95           (Wdata[95])
                                        , .WD_94           (Wdata[94])
                                        , .WD_93           (Wdata[93])
                                        , .WD_92           (Wdata[92])
                                        , .WD_91           (Wdata[91])
                                        , .WD_90           (Wdata[90])
                                        , .WD_89           (Wdata[89])
                                        , .WD_88           (Wdata[88])
                                        , .WD_87           (Wdata[87])
                                        , .WD_86           (Wdata[86])
                                        , .WD_85           (Wdata[85])
                                        , .WD_84           (Wdata[84])
                                        , .WD_83           (Wdata[83])
                                        , .WD_82           (Wdata[82])
                                        , .WD_81           (Wdata[81])
                                        , .WD_80           (Wdata[80])
                                        , .WD_79           (Wdata[79])
                                        , .WD_78           (Wdata[78])
                                        , .WD_77           (Wdata[77])
                                        , .WD_76           (Wdata[76])
                                        , .WD_75           (Wdata[75])
                                        , .WD_74           (Wdata[74])
                                        , .WD_73           (Wdata[73])
                                        , .WD_72           (Wdata[72])
                                        , .WD_71           (Wdata[71])
                                        , .WD_70           (Wdata[70])
                                        , .WD_69           (Wdata[69])
                                        , .WD_68           (Wdata[68])
                                        , .WD_67           (Wdata[67])
                                        , .WD_66           (Wdata[66])
                                        , .WD_65           (Wdata[65])
                                        , .WD_64           (Wdata[64])
                                        , .WD_63           (Wdata[63])
                                        , .WD_62           (Wdata[62])
                                        , .WD_61           (Wdata[61])
                                        , .WD_60           (Wdata[60])
                                        , .WD_59           (Wdata[59])
                                        , .WD_58           (Wdata[58])
                                        , .WD_57           (Wdata[57])
                                        , .WD_56           (Wdata[56])
                                        , .WD_55           (Wdata[55])
                                        , .WD_54           (Wdata[54])
                                        , .WD_53           (Wdata[53])
                                        , .WD_52           (Wdata[52])
                                        , .WD_51           (Wdata[51])
                                        , .WD_50           (Wdata[50])
                                        , .WD_49           (Wdata[49])
                                        , .WD_48           (Wdata[48])
                                        , .WD_47           (Wdata[47])
                                        , .WD_46           (Wdata[46])
                                        , .WD_45           (Wdata[45])
                                        , .WD_44           (Wdata[44])
                                        , .WD_43           (Wdata[43])
                                        , .WD_42           (Wdata[42])
                                        , .WD_41           (Wdata[41])
                                        , .WD_40           (Wdata[40])
                                        , .WD_39           (Wdata[39])
                                        , .WD_38           (Wdata[38])
                                        , .WD_37           (Wdata[37])
                                        , .WD_36           (Wdata[36])
                                        , .WD_35           (Wdata[35])
                                        , .WD_34           (Wdata[34])
                                        , .WD_33           (Wdata[33])
                                        , .WD_32           (Wdata[32])
                                        , .WD_31           (Wdata[31])
                                        , .WD_30           (Wdata[30])
                                        , .WD_29           (Wdata[29])
                                        , .WD_28           (Wdata[28])
                                        , .WD_27           (Wdata[27])
                                        , .WD_26           (Wdata[26])
                                        , .WD_25           (Wdata[25])
                                        , .WD_24           (Wdata[24])
                                        , .WD_23           (Wdata[23])
                                        , .WD_22           (Wdata[22])
                                        , .WD_21           (Wdata[21])
                                        , .WD_20           (Wdata[20])
                                        , .WD_19           (Wdata[19])
                                        , .WD_18           (Wdata[18])
                                        , .WD_17           (Wdata[17])
                                        , .WD_16           (Wdata[16])
                                        , .WD_15           (Wdata[15])
                                        , .WD_14           (Wdata[14])
                                        , .WD_13           (Wdata[13])
                                        , .WD_12           (Wdata[12])
                                        , .WD_11           (Wdata[11])
                                        , .WD_10           (Wdata[10])
                                        , .WD_9            (Wdata[9])
                                        , .WD_8            (Wdata[8])
                                        , .WD_7            (Wdata[7])
                                        , .WD_6            (Wdata[6])
                                        , .WD_5            (Wdata[5])
                                        , .WD_4            (Wdata[4])
                                        , .WD_3            (Wdata[3])
                                        , .WD_2            (Wdata[2])
                                        , .WD_1            (Wdata[1])
                                        , .WD_0            (Wdata[0])
                                        , .WE              (!web)
                                        , .RADR_4          (ra_0_0 [4])
                                        , .RADR_3          (ra_0_0 [3])
                                        , .RADR_2          (ra_0_0 [2])
                                        , .RADR_1          (ra_0_0 [1])
                                        , .RADR_0          (ra_0_0 [0])
                                        , .RE              (!reb)
                                        , .RD_271          (ramDataOut[271])
                                        , .RD_270          (ramDataOut[270])
                                        , .RD_269          (ramDataOut[269])
                                        , .RD_268          (ramDataOut[268])
                                        , .RD_267          (ramDataOut[267])
                                        , .RD_266          (ramDataOut[266])
                                        , .RD_265          (ramDataOut[265])
                                        , .RD_264          (ramDataOut[264])
                                        , .RD_263          (ramDataOut[263])
                                        , .RD_262          (ramDataOut[262])
                                        , .RD_261          (ramDataOut[261])
                                        , .RD_260          (ramDataOut[260])
                                        , .RD_259          (ramDataOut[259])
                                        , .RD_258          (ramDataOut[258])
                                        , .RD_257          (ramDataOut[257])
                                        , .RD_256          (ramDataOut[256])
                                        , .RD_255          (ramDataOut[255])
                                        , .RD_254          (ramDataOut[254])
                                        , .RD_253          (ramDataOut[253])
                                        , .RD_252          (ramDataOut[252])
                                        , .RD_251          (ramDataOut[251])
                                        , .RD_250          (ramDataOut[250])
                                        , .RD_249          (ramDataOut[249])
                                        , .RD_248          (ramDataOut[248])
                                        , .RD_247          (ramDataOut[247])
                                        , .RD_246          (ramDataOut[246])
                                        , .RD_245          (ramDataOut[245])
                                        , .RD_244          (ramDataOut[244])
                                        , .RD_243          (ramDataOut[243])
                                        , .RD_242          (ramDataOut[242])
                                        , .RD_241          (ramDataOut[241])
                                        , .RD_240          (ramDataOut[240])
                                        , .RD_239          (ramDataOut[239])
                                        , .RD_238          (ramDataOut[238])
                                        , .RD_237          (ramDataOut[237])
                                        , .RD_236          (ramDataOut[236])
                                        , .RD_235          (ramDataOut[235])
                                        , .RD_234          (ramDataOut[234])
                                        , .RD_233          (ramDataOut[233])
                                        , .RD_232          (ramDataOut[232])
                                        , .RD_231          (ramDataOut[231])
                                        , .RD_230          (ramDataOut[230])
                                        , .RD_229          (ramDataOut[229])
                                        , .RD_228          (ramDataOut[228])
                                        , .RD_227          (ramDataOut[227])
                                        , .RD_226          (ramDataOut[226])
                                        , .RD_225          (ramDataOut[225])
                                        , .RD_224          (ramDataOut[224])
                                        , .RD_223          (ramDataOut[223])
                                        , .RD_222          (ramDataOut[222])
                                        , .RD_221          (ramDataOut[221])
                                        , .RD_220          (ramDataOut[220])
                                        , .RD_219          (ramDataOut[219])
                                        , .RD_218          (ramDataOut[218])
                                        , .RD_217          (ramDataOut[217])
                                        , .RD_216          (ramDataOut[216])
                                        , .RD_215          (ramDataOut[215])
                                        , .RD_214          (ramDataOut[214])
                                        , .RD_213          (ramDataOut[213])
                                        , .RD_212          (ramDataOut[212])
                                        , .RD_211          (ramDataOut[211])
                                        , .RD_210          (ramDataOut[210])
                                        , .RD_209          (ramDataOut[209])
                                        , .RD_208          (ramDataOut[208])
                                        , .RD_207          (ramDataOut[207])
                                        , .RD_206          (ramDataOut[206])
                                        , .RD_205          (ramDataOut[205])
                                        , .RD_204          (ramDataOut[204])
                                        , .RD_203          (ramDataOut[203])
                                        , .RD_202          (ramDataOut[202])
                                        , .RD_201          (ramDataOut[201])
                                        , .RD_200          (ramDataOut[200])
                                        , .RD_199          (ramDataOut[199])
                                        , .RD_198          (ramDataOut[198])
                                        , .RD_197          (ramDataOut[197])
                                        , .RD_196          (ramDataOut[196])
                                        , .RD_195          (ramDataOut[195])
                                        , .RD_194          (ramDataOut[194])
                                        , .RD_193          (ramDataOut[193])
                                        , .RD_192          (ramDataOut[192])
                                        , .RD_191          (ramDataOut[191])
                                        , .RD_190          (ramDataOut[190])
                                        , .RD_189          (ramDataOut[189])
                                        , .RD_188          (ramDataOut[188])
                                        , .RD_187          (ramDataOut[187])
                                        , .RD_186          (ramDataOut[186])
                                        , .RD_185          (ramDataOut[185])
                                        , .RD_184          (ramDataOut[184])
                                        , .RD_183          (ramDataOut[183])
                                        , .RD_182          (ramDataOut[182])
                                        , .RD_181          (ramDataOut[181])
                                        , .RD_180          (ramDataOut[180])
                                        , .RD_179          (ramDataOut[179])
                                        , .RD_178          (ramDataOut[178])
                                        , .RD_177          (ramDataOut[177])
                                        , .RD_176          (ramDataOut[176])
                                        , .RD_175          (ramDataOut[175])
                                        , .RD_174          (ramDataOut[174])
                                        , .RD_173          (ramDataOut[173])
                                        , .RD_172          (ramDataOut[172])
                                        , .RD_171          (ramDataOut[171])
                                        , .RD_170          (ramDataOut[170])
                                        , .RD_169          (ramDataOut[169])
                                        , .RD_168          (ramDataOut[168])
                                        , .RD_167          (ramDataOut[167])
                                        , .RD_166          (ramDataOut[166])
                                        , .RD_165          (ramDataOut[165])
                                        , .RD_164          (ramDataOut[164])
                                        , .RD_163          (ramDataOut[163])
                                        , .RD_162          (ramDataOut[162])
                                        , .RD_161          (ramDataOut[161])
                                        , .RD_160          (ramDataOut[160])
                                        , .RD_159          (ramDataOut[159])
                                        , .RD_158          (ramDataOut[158])
                                        , .RD_157          (ramDataOut[157])
                                        , .RD_156          (ramDataOut[156])
                                        , .RD_155          (ramDataOut[155])
                                        , .RD_154          (ramDataOut[154])
                                        , .RD_153          (ramDataOut[153])
                                        , .RD_152          (ramDataOut[152])
                                        , .RD_151          (ramDataOut[151])
                                        , .RD_150          (ramDataOut[150])
                                        , .RD_149          (ramDataOut[149])
                                        , .RD_148          (ramDataOut[148])
                                        , .RD_147          (ramDataOut[147])
                                        , .RD_146          (ramDataOut[146])
                                        , .RD_145          (ramDataOut[145])
                                        , .RD_144          (ramDataOut[144])
                                        , .RD_143          (ramDataOut[143])
                                        , .RD_142          (ramDataOut[142])
                                        , .RD_141          (ramDataOut[141])
                                        , .RD_140          (ramDataOut[140])
                                        , .RD_139          (ramDataOut[139])
                                        , .RD_138          (ramDataOut[138])
                                        , .RD_137          (ramDataOut[137])
                                        , .RD_136          (ramDataOut[136])
                                        , .RD_135          (ramDataOut[135])
                                        , .RD_134          (ramDataOut[134])
                                        , .RD_133          (ramDataOut[133])
                                        , .RD_132          (ramDataOut[132])
                                        , .RD_131          (ramDataOut[131])
                                        , .RD_130          (ramDataOut[130])
                                        , .RD_129          (ramDataOut[129])
                                        , .RD_128          (ramDataOut[128])
                                        , .RD_127          (ramDataOut[127])
                                        , .RD_126          (ramDataOut[126])
                                        , .RD_125          (ramDataOut[125])
                                        , .RD_124          (ramDataOut[124])
                                        , .RD_123          (ramDataOut[123])
                                        , .RD_122          (ramDataOut[122])
                                        , .RD_121          (ramDataOut[121])
                                        , .RD_120          (ramDataOut[120])
                                        , .RD_119          (ramDataOut[119])
                                        , .RD_118          (ramDataOut[118])
                                        , .RD_117          (ramDataOut[117])
                                        , .RD_116          (ramDataOut[116])
                                        , .RD_115          (ramDataOut[115])
                                        , .RD_114          (ramDataOut[114])
                                        , .RD_113          (ramDataOut[113])
                                        , .RD_112          (ramDataOut[112])
                                        , .RD_111          (ramDataOut[111])
                                        , .RD_110          (ramDataOut[110])
                                        , .RD_109          (ramDataOut[109])
                                        , .RD_108          (ramDataOut[108])
                                        , .RD_107          (ramDataOut[107])
                                        , .RD_106          (ramDataOut[106])
                                        , .RD_105          (ramDataOut[105])
                                        , .RD_104          (ramDataOut[104])
                                        , .RD_103          (ramDataOut[103])
                                        , .RD_102          (ramDataOut[102])
                                        , .RD_101          (ramDataOut[101])
                                        , .RD_100          (ramDataOut[100])
                                        , .RD_99           (ramDataOut[99])
                                        , .RD_98           (ramDataOut[98])
                                        , .RD_97           (ramDataOut[97])
                                        , .RD_96           (ramDataOut[96])
                                        , .RD_95           (ramDataOut[95])
                                        , .RD_94           (ramDataOut[94])
                                        , .RD_93           (ramDataOut[93])
                                        , .RD_92           (ramDataOut[92])
                                        , .RD_91           (ramDataOut[91])
                                        , .RD_90           (ramDataOut[90])
                                        , .RD_89           (ramDataOut[89])
                                        , .RD_88           (ramDataOut[88])
                                        , .RD_87           (ramDataOut[87])
                                        , .RD_86           (ramDataOut[86])
                                        , .RD_85           (ramDataOut[85])
                                        , .RD_84           (ramDataOut[84])
                                        , .RD_83           (ramDataOut[83])
                                        , .RD_82           (ramDataOut[82])
                                        , .RD_81           (ramDataOut[81])
                                        , .RD_80           (ramDataOut[80])
                                        , .RD_79           (ramDataOut[79])
                                        , .RD_78           (ramDataOut[78])
                                        , .RD_77           (ramDataOut[77])
                                        , .RD_76           (ramDataOut[76])
                                        , .RD_75           (ramDataOut[75])
                                        , .RD_74           (ramDataOut[74])
                                        , .RD_73           (ramDataOut[73])
                                        , .RD_72           (ramDataOut[72])
                                        , .RD_71           (ramDataOut[71])
                                        , .RD_70           (ramDataOut[70])
                                        , .RD_69           (ramDataOut[69])
                                        , .RD_68           (ramDataOut[68])
                                        , .RD_67           (ramDataOut[67])
                                        , .RD_66           (ramDataOut[66])
                                        , .RD_65           (ramDataOut[65])
                                        , .RD_64           (ramDataOut[64])
                                        , .RD_63           (ramDataOut[63])
                                        , .RD_62           (ramDataOut[62])
                                        , .RD_61           (ramDataOut[61])
                                        , .RD_60           (ramDataOut[60])
                                        , .RD_59           (ramDataOut[59])
                                        , .RD_58           (ramDataOut[58])
                                        , .RD_57           (ramDataOut[57])
                                        , .RD_56           (ramDataOut[56])
                                        , .RD_55           (ramDataOut[55])
                                        , .RD_54           (ramDataOut[54])
                                        , .RD_53           (ramDataOut[53])
                                        , .RD_52           (ramDataOut[52])
                                        , .RD_51           (ramDataOut[51])
                                        , .RD_50           (ramDataOut[50])
                                        , .RD_49           (ramDataOut[49])
                                        , .RD_48           (ramDataOut[48])
                                        , .RD_47           (ramDataOut[47])
                                        , .RD_46           (ramDataOut[46])
                                        , .RD_45           (ramDataOut[45])
                                        , .RD_44           (ramDataOut[44])
                                        , .RD_43           (ramDataOut[43])
                                        , .RD_42           (ramDataOut[42])
                                        , .RD_41           (ramDataOut[41])
                                        , .RD_40           (ramDataOut[40])
                                        , .RD_39           (ramDataOut[39])
                                        , .RD_38           (ramDataOut[38])
                                        , .RD_37           (ramDataOut[37])
                                        , .RD_36           (ramDataOut[36])
                                        , .RD_35           (ramDataOut[35])
                                        , .RD_34           (ramDataOut[34])
                                        , .RD_33           (ramDataOut[33])
                                        , .RD_32           (ramDataOut[32])
                                        , .RD_31           (ramDataOut[31])
                                        , .RD_30           (ramDataOut[30])
                                        , .RD_29           (ramDataOut[29])
                                        , .RD_28           (ramDataOut[28])
                                        , .RD_27           (ramDataOut[27])
                                        , .RD_26           (ramDataOut[26])
                                        , .RD_25           (ramDataOut[25])
                                        , .RD_24           (ramDataOut[24])
                                        , .RD_23           (ramDataOut[23])
                                        , .RD_22           (ramDataOut[22])
                                        , .RD_21           (ramDataOut[21])
                                        , .RD_20           (ramDataOut[20])
                                        , .RD_19           (ramDataOut[19])
                                        , .RD_18           (ramDataOut[18])
                                        , .RD_17           (ramDataOut[17])
                                        , .RD_16           (ramDataOut[16])
                                        , .RD_15           (ramDataOut[15])
                                        , .RD_14           (ramDataOut[14])
                                        , .RD_13           (ramDataOut[13])
                                        , .RD_12           (ramDataOut[12])
                                        , .RD_11           (ramDataOut[11])
                                        , .RD_10           (ramDataOut[10])
                                        , .RD_9            (ramDataOut[9])
                                        , .RD_8            (ramDataOut[8])
                                        , .RD_7            (ramDataOut[7])
                                        , .RD_6            (ramDataOut[6])
                                        , .RD_5            (ramDataOut[5])
                                        , .RD_4            (ramDataOut[4])
                                        , .RD_3            (ramDataOut[3])
                                        , .RD_2            (ramDataOut[2])
                                        , .RD_1            (ramDataOut[1])
                                        , .RD_0            (ramDataOut[0])
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
reg [271:0] ram_r0_OutputMuxDataOut;

//For bitEnd 271, only one piece RAMPDP_32X272_GL_M1_D2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_0[271:0] or Data_reg_r0[271:0] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[271:0] = (ram_bypass) ? Data_reg_r0[271:0]: dout_0_0;
end
assign r0_OutputMuxDataOut[271:0] = ram_r0_OutputMuxDataOut[271:0];
// verilint 17 on - Range (rather than full vector) in the sensitivity list



// --------------------- Output Mbist Interface logic  -------------


// new mux in front of the data register

reg [272-1:0] muxed_Data_r0;
wire [272-1:0] muxed_Data_A, muxed_Data_B;
wire muxed_Data_S;

assign muxed_Data_S = debug_mode_sync ? (re_reg_r0) : mbist_en_r;
assign muxed_Data_A = muxed_Di_w0;
assign muxed_Data_B = r0_OutputMuxDataOut;

always @(muxed_Data_S or muxed_Data_A or muxed_Data_B)
  case(muxed_Data_S) // synopsys infer_mux
    1'b0 : muxed_Data_r0 = muxed_Data_A;
    1'b1 : muxed_Data_r0 = muxed_Data_B;
    default : muxed_Data_r0 = {272{`tick_x_or_0}};
  endcase
reg mbist_ce_r0_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_1p <= mbist_ce_r0;
wire captureDR_r0 = dft_capdr_r | (( debug_mode_sync ? (1'b1& (access_en_r_1p)) :  ((mbist_en_r & (mbist_ce_r0_1p) & !1'b0))));
////MSB 271 LSB 0  and total rambit is 272 and  dsize is 272

wire Data_reg_SO_r0;
// verilint 110 off - Incompatible width
// verilint 630 off - Port connected to a NULL expression
// These are used for registering Ra in case of Latch arrays as well (i.e. 
// used in functional path as well)
wire [271:0]data_regq;
assign Data_reg_r0[271:0] = data_regq[271:0] ;

// verilint 110 on - Incompatible width
// verilint 630 on - Port connected to a NULL expression
assign dout = r0_OutputMuxDataOut;
assign mbist_Do_r0_int_net = Data_reg_r0[272-1:0];

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
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_we_reg_w0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_we_w0), .Q(we_q),
            .scanin(Wa_reg_SO_w0), .scanout(we_reg_SO_w0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(5, 0, 0) testInst_Ra_reg_r0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_Ra_r0), .Q(radr_q),
            .scanin(we_reg_SO_w0), .scanout(Ra_reg_SO_r0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0), .Q(re_q),
            .scanin(Ra_reg_SO_r0), .scanout(re_reg_SO_r0)  );
wire gated_clk_jtag_Data_reg_r0;
CKLNQD12PO4  UJ_clk_jtag_Data_reg_r0 (.Q(gated_clk_jtag_Data_reg_r0), .CP(clk), .E(captureDR_r0 | (debug_mode_sync & shiftDR)), .TE(scan_en));
wire [271:0] Data_reg_r0_D = muxed_Data_r0[271:0];
wire [271:0] Data_reg_r0_Q;
assign data_regq[271:0] = Data_reg_r0_Q;
wire so_Data_reg_r0_271_16;

ScanShareSel_JTAG_reg_ext_cg #(256, 0, 0) testInst_Data_reg_r0_271_16 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[271:16]), .Q(Data_reg_r0_Q[271:16]),
            .scanin(re_reg_SO_r0), .scanout(so_Data_reg_r0_271_16)  );

ScanShareSel_JTAG_reg_ext_cg #(16, 0, 0) testInst_Data_reg_r0_15_0 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[15:0]), .Q(Data_reg_r0_Q[15:0]),
            .scanin(so_Data_reg_r0_271_16), .scanout(Data_reg_SO_r0)  );

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
