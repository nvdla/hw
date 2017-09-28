// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rwsp_20x289_logic.v

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


module nv_ram_rwsp_20x289_logic (
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
               mbist_en_sync,
               mbist_ramaccess_rst_,
               mbist_we_w0_0_0,
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
input  [288:0]  di;
output [288:0]  dout;
input           iddq_mode;
input           jtag_readonly_mode;
input  [1:0]    mbist_Di_w0;
output [287:0]  mbist_Do_r0_int_net;
input  [4:0]    mbist_Ra_r0;
input  [4:0]    mbist_Wa_w0;
input           mbist_ce_r0_0_0;
input           mbist_en_sync;
input           mbist_ramaccess_rst_;
input           mbist_we_w0_0_0;
input           ore;
input  [31:0]   pwrbus_ram_pd;
input  [4:0]    ra;
input           re;
input           scan_en;
input           scan_ramtms;
input           shiftDR;
input  [1:0]    svop;
input           test_mode;
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
wire [288:0] Data_reg_r0;


 // Data out bus for read port r0 for Output Mux
wire [288:0] r0_OutputMuxDataOut;
CKLNQD12PO4  UJ_la_bist_clkw0_gate (.Q(la_bist_clkw0), .CP(clk), .E(mbist_en_r | debug_mode_sync), .TE(scan_en));

// Write enable bus
wire  we_0_0;

// Read enable bus
wire re_0_0;

// Write enable bus
wire  we_0_288;
// start of predeclareNvregSignals
wire ctx_ctrl_we;
wire clk_en_core_0_0 = (re_0_0 | (|we_0_0));
wire gated_clk_core_0_0;
CKLNQD12PO4  UJ_clk_gate_core_0_0 (.Q(gated_clk_core_0_0), .CP(clk), .E(clk_en_core_0_0), .TE(1'b0 | mbist_en_r | debug_mode_sync | scan_en));
wire shiftDR_en;

reg [288:0] pre_muxed_Di_w0;
wire [288:0] pre_muxed_Di_w0_A, pre_muxed_Di_w0_B;
wire pre_muxed_Di_w0_S;

assign pre_muxed_Di_w0_S = !debug_mode_sync;
assign pre_muxed_Di_w0_A = Data_reg_r0[288:0];
assign pre_muxed_Di_w0_B = {mbist_Di_w0[0], {144{mbist_Di_w0}}};

always @(pre_muxed_Di_w0_S or pre_muxed_Di_w0_A or pre_muxed_Di_w0_B)
    case(pre_muxed_Di_w0_S) // synopsys infer_mux
      1'b0 : pre_muxed_Di_w0 = pre_muxed_Di_w0_A;
      1'b1 : pre_muxed_Di_w0 = pre_muxed_Di_w0_B;
      default : pre_muxed_Di_w0 = {289{`tick_x_or_0}};
    endcase

reg [288:0] muxed_Di_w0;
wire [288:0] muxed_Di_w0_A, muxed_Di_w0_B;
assign muxed_Di_w0_A = {di[288:288], di[287:0]};
assign muxed_Di_w0_B = pre_muxed_Di_w0;

wire muxed_Di_w0_S = debug_mode_sync | mbist_en_r;
always @(muxed_Di_w0_S or muxed_Di_w0_A or muxed_Di_w0_B)
    case(muxed_Di_w0_S) // synopsys infer_mux
      1'b0 : muxed_Di_w0 = muxed_Di_w0_A;
      1'b1 : muxed_Di_w0 = muxed_Di_w0_B;
      default : muxed_Di_w0 = {289{`tick_x_or_0}};
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

assign pre_re_r0_0_288 = 1'b0; 
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
wire [4:0] D_Ra_array_reg_r0;

wire [4:0] la_muxedRa_r0;
assign D_Ra_array_reg_r0 = ( ((re)))  ? ra : Ra_array_reg_r0;


always @(posedge clk) begin
    Ra_array_reg_r0 <= D_Ra_array_reg_r0;
 end
assign la_muxedRa_r0 = Ra_array_reg_r0;

// ------------------  START PIECE ----------------------------------
// Suffix _0_0 : Piece RAMDP_20X288_GL_M1_E2 (RamCell)
// Covers Addresses from 0 to 19  Addressrange: [4:0]  
// Data Bit range: [287:0] (288 bits)   
// Enables: 1   Enable range: 

// Declare some wires for doing chip select logic

// verilint 498 off - Incompatible width


wire [4:0] cs_start_val_0_0;
assign cs_start_val_0_0 = 5'd0;

wire [4:0] cs_end_val_0_0;
assign cs_end_val_0_0 = 5'd19;

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
// Suffix _0_288 : Piece Flop_Array (FlopArray)
// Covers Addresses from 0 to 19  Addressrange: [4:0]  
// Data Bit range: [288:288] (1 bits)   
// Enables: 1   Enable range: 

// Write Address bus

wire [4:0] wa_0_288;
assign wa_0_288 = muxed_Wa_w0;

// Write Data in bus
wire [288:288] di_0_288;
assign di_0_288 = di[288:288];
assign we_0_288 = we;

// Read Address bus
wire [4:0] ra_0_288;
assign ra_0_288 = la_muxedRa_r0;

// Read DataOut bus
wire  dout_0_288;


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

// -----------------  begin Ram Cell RAMDP_20X288_GL_M1_E2_0_0 -------------


// Write Port Stuff -----

// Declare the Write address bus
wire web_0_0 = ~(|muxed_we_w0_0_0) | write_inh;

// Read Port Stuff -----

// Declare the Read address bus

// Read enable
wire piece_re_0_0 = muxed_re_r0_0_0 | ( scan_en & jtag_readonly_mode );
wire reb_0_0 = !piece_re_0_0;
// Declare the ramOutData which connects to the ram directly
wire [287:0] ramDataOut_0_0;
assign dout_0_0[287:0] = ramDataOut_0_0[287:0];
RAMDP_20X288_GL_M1_E2 ram_Inst_20X288_0_0 (
                                             .CLK_W           (gated_clk_core_0_0)
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
                                           , .CLK_R           (gated_clk_core_0_0)
                                           , .RADR_4          (ra_0_0 [4] & !test_mode)
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

// begin ----------------  Flop_Array_0_288 ---------------


// Declare the register array
reg  FlopArray_row0_0_288;
reg  FlopArray_row1_0_288;
reg  FlopArray_row2_0_288;
reg  FlopArray_row3_0_288;
reg  FlopArray_row4_0_288;
reg  FlopArray_row5_0_288;
reg  FlopArray_row6_0_288;
reg  FlopArray_row7_0_288;
reg  FlopArray_row8_0_288;
reg  FlopArray_row9_0_288;
reg  FlopArray_row10_0_288;
reg  FlopArray_row11_0_288;
reg  FlopArray_row12_0_288;
reg  FlopArray_row13_0_288;
reg  FlopArray_row14_0_288;
reg  FlopArray_row15_0_288;
reg  FlopArray_row16_0_288;
reg  FlopArray_row17_0_288;
reg  FlopArray_row18_0_288;
reg  FlopArray_row19_0_288;

// Declare the Write port wires

// Write Data wires

wire [288:288] Wdata_0_288;

// Assign for data input
assign Wdata_0_288 = di_0_288;
    

// Address decode for Flop array 
wire [19:0] Wa_decode_0_288;


// Create wire for one write enable
wire   We_0_288;
assign We_0_288 = we_0_288;

assign Wa_decode_0_288[0] = We_0_288 & (wa_0_288 == 5'd0);
assign Wa_decode_0_288[1] = We_0_288 & (wa_0_288 == 5'd1);
assign Wa_decode_0_288[2] = We_0_288 & (wa_0_288 == 5'd2);
assign Wa_decode_0_288[3] = We_0_288 & (wa_0_288 == 5'd3);
assign Wa_decode_0_288[4] = We_0_288 & (wa_0_288 == 5'd4);
assign Wa_decode_0_288[5] = We_0_288 & (wa_0_288 == 5'd5);
assign Wa_decode_0_288[6] = We_0_288 & (wa_0_288 == 5'd6);
assign Wa_decode_0_288[7] = We_0_288 & (wa_0_288 == 5'd7);
assign Wa_decode_0_288[8] = We_0_288 & (wa_0_288 == 5'd8);
assign Wa_decode_0_288[9] = We_0_288 & (wa_0_288 == 5'd9);
assign Wa_decode_0_288[10] = We_0_288 & (wa_0_288 == 5'd10);
assign Wa_decode_0_288[11] = We_0_288 & (wa_0_288 == 5'd11);
assign Wa_decode_0_288[12] = We_0_288 & (wa_0_288 == 5'd12);
assign Wa_decode_0_288[13] = We_0_288 & (wa_0_288 == 5'd13);
assign Wa_decode_0_288[14] = We_0_288 & (wa_0_288 == 5'd14);
assign Wa_decode_0_288[15] = We_0_288 & (wa_0_288 == 5'd15);
assign Wa_decode_0_288[16] = We_0_288 & (wa_0_288 == 5'd16);
assign Wa_decode_0_288[17] = We_0_288 & (wa_0_288 == 5'd17);
assign Wa_decode_0_288[18] = We_0_288 & (wa_0_288 == 5'd18);
assign Wa_decode_0_288[19] = We_0_288 & (wa_0_288 == 5'd19);
reg [288:288] RaDecodeDor0_0_288;

// Assign the input data to the flop input
wire [0:0] FlopArray_row0_0_288_d;
assign FlopArray_row0_0_288_d =  (Wa_decode_0_288[0]) ? Wdata_0_288 : FlopArray_row0_0_288;

wire [0:0] FlopArray_row1_0_288_d;
assign FlopArray_row1_0_288_d =  (Wa_decode_0_288[1]) ? Wdata_0_288 : FlopArray_row1_0_288;

wire [0:0] FlopArray_row2_0_288_d;
assign FlopArray_row2_0_288_d =  (Wa_decode_0_288[2]) ? Wdata_0_288 : FlopArray_row2_0_288;

wire [0:0] FlopArray_row3_0_288_d;
assign FlopArray_row3_0_288_d =  (Wa_decode_0_288[3]) ? Wdata_0_288 : FlopArray_row3_0_288;

wire [0:0] FlopArray_row4_0_288_d;
assign FlopArray_row4_0_288_d =  (Wa_decode_0_288[4]) ? Wdata_0_288 : FlopArray_row4_0_288;

wire [0:0] FlopArray_row5_0_288_d;
assign FlopArray_row5_0_288_d =  (Wa_decode_0_288[5]) ? Wdata_0_288 : FlopArray_row5_0_288;

wire [0:0] FlopArray_row6_0_288_d;
assign FlopArray_row6_0_288_d =  (Wa_decode_0_288[6]) ? Wdata_0_288 : FlopArray_row6_0_288;

wire [0:0] FlopArray_row7_0_288_d;
assign FlopArray_row7_0_288_d =  (Wa_decode_0_288[7]) ? Wdata_0_288 : FlopArray_row7_0_288;

wire [0:0] FlopArray_row8_0_288_d;
assign FlopArray_row8_0_288_d =  (Wa_decode_0_288[8]) ? Wdata_0_288 : FlopArray_row8_0_288;

wire [0:0] FlopArray_row9_0_288_d;
assign FlopArray_row9_0_288_d =  (Wa_decode_0_288[9]) ? Wdata_0_288 : FlopArray_row9_0_288;

wire [0:0] FlopArray_row10_0_288_d;
assign FlopArray_row10_0_288_d =  (Wa_decode_0_288[10]) ? Wdata_0_288 : FlopArray_row10_0_288;

wire [0:0] FlopArray_row11_0_288_d;
assign FlopArray_row11_0_288_d =  (Wa_decode_0_288[11]) ? Wdata_0_288 : FlopArray_row11_0_288;

wire [0:0] FlopArray_row12_0_288_d;
assign FlopArray_row12_0_288_d =  (Wa_decode_0_288[12]) ? Wdata_0_288 : FlopArray_row12_0_288;

wire [0:0] FlopArray_row13_0_288_d;
assign FlopArray_row13_0_288_d =  (Wa_decode_0_288[13]) ? Wdata_0_288 : FlopArray_row13_0_288;

wire [0:0] FlopArray_row14_0_288_d;
assign FlopArray_row14_0_288_d =  (Wa_decode_0_288[14]) ? Wdata_0_288 : FlopArray_row14_0_288;

wire [0:0] FlopArray_row15_0_288_d;
assign FlopArray_row15_0_288_d =  (Wa_decode_0_288[15]) ? Wdata_0_288 : FlopArray_row15_0_288;

wire [0:0] FlopArray_row16_0_288_d;
assign FlopArray_row16_0_288_d =  (Wa_decode_0_288[16]) ? Wdata_0_288 : FlopArray_row16_0_288;

wire [0:0] FlopArray_row17_0_288_d;
assign FlopArray_row17_0_288_d =  (Wa_decode_0_288[17]) ? Wdata_0_288 : FlopArray_row17_0_288;

wire [0:0] FlopArray_row18_0_288_d;
assign FlopArray_row18_0_288_d =  (Wa_decode_0_288[18]) ? Wdata_0_288 : FlopArray_row18_0_288;

wire [0:0] FlopArray_row19_0_288_d;
assign FlopArray_row19_0_288_d =  (Wa_decode_0_288[19]) ? Wdata_0_288 : FlopArray_row19_0_288;

always @(posedge clk) begin
   FlopArray_row0_0_288 <=  FlopArray_row0_0_288_d;

   FlopArray_row1_0_288 <=  FlopArray_row1_0_288_d;

   FlopArray_row2_0_288 <=  FlopArray_row2_0_288_d;

   FlopArray_row3_0_288 <=  FlopArray_row3_0_288_d;

   FlopArray_row4_0_288 <=  FlopArray_row4_0_288_d;

   FlopArray_row5_0_288 <=  FlopArray_row5_0_288_d;

   FlopArray_row6_0_288 <=  FlopArray_row6_0_288_d;

   FlopArray_row7_0_288 <=  FlopArray_row7_0_288_d;

   FlopArray_row8_0_288 <=  FlopArray_row8_0_288_d;

   FlopArray_row9_0_288 <=  FlopArray_row9_0_288_d;

   FlopArray_row10_0_288 <=  FlopArray_row10_0_288_d;

   FlopArray_row11_0_288 <=  FlopArray_row11_0_288_d;

   FlopArray_row12_0_288 <=  FlopArray_row12_0_288_d;

   FlopArray_row13_0_288 <=  FlopArray_row13_0_288_d;

   FlopArray_row14_0_288 <=  FlopArray_row14_0_288_d;

   FlopArray_row15_0_288 <=  FlopArray_row15_0_288_d;

   FlopArray_row16_0_288 <=  FlopArray_row16_0_288_d;

   FlopArray_row17_0_288 <=  FlopArray_row17_0_288_d;

   FlopArray_row18_0_288 <=  FlopArray_row18_0_288_d;

   FlopArray_row19_0_288 <=  FlopArray_row19_0_288_d;

end


// Declare the Do buses for data out.


// Do Ra decode

always @(ra_0_288 or FlopArray_row0_0_288 or FlopArray_row1_0_288 or 
         FlopArray_row2_0_288 or FlopArray_row3_0_288 or FlopArray_row4_0_288 or 
         FlopArray_row5_0_288 or FlopArray_row6_0_288 or FlopArray_row7_0_288 or 
         FlopArray_row8_0_288 or FlopArray_row9_0_288 or FlopArray_row10_0_288 or 
         FlopArray_row11_0_288 or FlopArray_row12_0_288 or FlopArray_row13_0_288 or 
         FlopArray_row14_0_288 or FlopArray_row15_0_288 or FlopArray_row16_0_288 or 
         FlopArray_row17_0_288 or FlopArray_row18_0_288 or FlopArray_row19_0_288
         )
   // verilint 332 off - not all cases covered, default exists
   case(ra_0_288)
       5'd0 : RaDecodeDor0_0_288 = FlopArray_row0_0_288;
       5'd1 : RaDecodeDor0_0_288 = FlopArray_row1_0_288;
       5'd2 : RaDecodeDor0_0_288 = FlopArray_row2_0_288;
       5'd3 : RaDecodeDor0_0_288 = FlopArray_row3_0_288;
       5'd4 : RaDecodeDor0_0_288 = FlopArray_row4_0_288;
       5'd5 : RaDecodeDor0_0_288 = FlopArray_row5_0_288;
       5'd6 : RaDecodeDor0_0_288 = FlopArray_row6_0_288;
       5'd7 : RaDecodeDor0_0_288 = FlopArray_row7_0_288;
       5'd8 : RaDecodeDor0_0_288 = FlopArray_row8_0_288;
       5'd9 : RaDecodeDor0_0_288 = FlopArray_row9_0_288;
       5'd10 : RaDecodeDor0_0_288 = FlopArray_row10_0_288;
       5'd11 : RaDecodeDor0_0_288 = FlopArray_row11_0_288;
       5'd12 : RaDecodeDor0_0_288 = FlopArray_row12_0_288;
       5'd13 : RaDecodeDor0_0_288 = FlopArray_row13_0_288;
       5'd14 : RaDecodeDor0_0_288 = FlopArray_row14_0_288;
       5'd15 : RaDecodeDor0_0_288 = FlopArray_row15_0_288;
       5'd16 : RaDecodeDor0_0_288 = FlopArray_row16_0_288;
       5'd17 : RaDecodeDor0_0_288 = FlopArray_row17_0_288;
       5'd18 : RaDecodeDor0_0_288 = FlopArray_row18_0_288;
       5'd19 : RaDecodeDor0_0_288 = FlopArray_row19_0_288;
       default :RaDecodeDor0_0_288 = {1{`tick_x_or_0}};
    endcase

   // verilint 332 on

assign dout_0_288 = RaDecodeDor0_0_288;


//------------ Done generating flop array Flop_Array_0_288 -------------


// --------------------------------------------- 

// Declare the interface wires for Output Mux logic


// verilint 552 off - Different bits of a net are driven in different blocks (harmless, 
// but some synthesis tools generate a warning for this)
reg [288:0] ram_r0_OutputMuxDataOut;

//For bitEnd 287, only one piece RAMDP_20X288_GL_M1_E2 in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_0[287:0] or muxed_Di_w0[287:0] or ram_bypass)
begin
    ram_r0_OutputMuxDataOut[287:0] = (ram_bypass) ? muxed_Di_w0[287:0]: dout_0_0;
end
assign r0_OutputMuxDataOut[287:0] = ram_r0_OutputMuxDataOut[287:0];
// verilint 17 on - Range (rather than full vector) in the sensitivity list

//For bitEnd 288, only one piece Flop_Array in the column.

// verilint 17 off - Range (rather than full vector) in the sensitivity list

always @(dout_0_288)
begin
    ram_r0_OutputMuxDataOut[288:288] = dout_0_288;
end
assign r0_OutputMuxDataOut[288:288] = ram_r0_OutputMuxDataOut[288:288];
// verilint 17 on - Range (rather than full vector) in the sensitivity list



// --------------------- Output Mbist Interface logic  -------------

reg mbist_ce_r0_0_0_1p;
always @(posedge la_bist_clkw0) mbist_ce_r0_0_0_1p <= mbist_ce_r0_0_0;
wire captureDR_r0 = dft_capdr_r | ((((ore)) & !mbist_en_r & !debug_mode_sync) || ( debug_mode_sync ? (1'b1& (access_en_r_1p_0_0)) :  ((mbist_en_r & (mbist_ce_r0_0_0_1p) & !1'b0))));
////MSB 287 LSB 0  and total rambit is 288 and  dsize is 289

wire Data_reg_SO_r0;
// verilint 110 off - Incompatible width
// verilint 630 off - Port connected to a NULL expression
// These are used for registering Ra in case of Latch arrays as well (i.e. 
// used in functional path as well)
wire [287:0]data_regq;
assign Data_reg_r0[287:0] = data_regq[287:0] ;

reg [0 :0] Data_reg_temp_r0 ;
always @ (posedge clk) begin
 if(captureDR_r0) begin
  Data_reg_temp_r0 <= r0_OutputMuxDataOut[288:288]; 
 end
end 

assign Data_reg_r0[288:288]= Data_reg_temp_r0;

// verilint 110 on - Incompatible width
// verilint 630 on - Port connected to a NULL expression
assign dout = Data_reg_r0;

assign mbist_Do_r0_int_net = Data_reg_r0[288-1:0];

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
    
ScanShareSel_JTAG_reg_ext_cg #(5, 0, 0) testInst_Ra_reg_r0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_Ra_r0), .Q(radr_q),
            .scanin(we_reg_SO_w0_0_0), .scanout(Ra_reg_SO_r0)  );
    
ScanShareSel_JTAG_reg_ext_cg #(1, 0, 0) testInst_re_reg_r0_0_0 (
	    .clk(gated_clk_jtag_Wa_reg_w0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(muxed_re_r0_0_0), .Q(re_0_0_q),
            .scanin(Ra_reg_SO_r0), .scanout(re_reg_SO_r0_0_0)  );
wire gated_clk_jtag_Data_reg_r0;
CKLNQD12PO4  UJ_clk_jtag_Data_reg_r0 (.Q(gated_clk_jtag_Data_reg_r0), .CP(clk), .E(captureDR_r0 | (debug_mode_sync & shiftDR)), .TE(scan_en));
wire [287:0] Data_reg_r0_D = r0_OutputMuxDataOut[287:0];
wire [287:0] Data_reg_r0_Q;
assign data_regq[287:0] = Data_reg_r0_Q;
wire so_Data_reg_r0_287_32;

ScanShareSel_JTAG_reg_ext_cg #(256, 0, 0) testInst_Data_reg_r0_287_32 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[287:32]), .Q(Data_reg_r0_Q[287:32]),
            .scanin(re_reg_SO_r0_0_0), .scanout(so_Data_reg_r0_287_32)  );

ScanShareSel_JTAG_reg_ext_cg #(32, 0, 0) testInst_Data_reg_r0_31_0 (
	    .clk(gated_clk_jtag_Data_reg_r0), .sel(debug_mode),
            .shiftDR(shiftDR),
            .reset_(1'b1), .D(Data_reg_r0_D[31:0]), .Q(Data_reg_r0_Q[31:0]),
            .scanin(so_Data_reg_r0_287_32), .scanout(Data_reg_SO_r0)  );

`ifdef ASSERT_ON
`ifndef SYNTHESIS
reg sim_reset_;
initial sim_reset_ = 0;
always @(posedge clk) sim_reset_ <= 1'b1;

wire start_of_sim = sim_reset_;


wire disable_clk_x_test = $test$plusargs ("disable_clk_x_test") ? 1'b1 : 1'b0;
nv_assert_no_x #(1,1,0," Try Reading Ram when clock is x for read port r0") _clk_x_test_read (clk, sim_reset_, ((disable_clk_x_test===1'b0) && (|re===1'b1 )), clk);
nv_assert_no_x #(1,1,0," Try Writing Ram when clock is x for write port w0") _clk_x_test_write (clk, sim_reset_, ((disable_clk_x_test===1'b0) && (|we===1'b1)), clk);
reg [20-1:0] written; 
always@(posedge clk or negedge sim_reset_) begin 
   if(!sim_reset_) begin 
      written <= {20{1'b0}}; 
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
