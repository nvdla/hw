// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: RAMPDP_256X64_GL_M2_D2.v

`ifdef EMULATION
	`define SYNTHESIS
`endif

`ifndef SYNTHESIS
	`ifdef FAULT_INJECTION
		`define SIM_and_FAULT
	`endif
`endif

`ifndef SYNTHESIS
	`ifdef MONITOR
		`define SIM_and_MONITOR
	`endif
`endif


`ifndef SYNTHESIS 
`timescale 10ps/1ps
`endif 
`celldefine
module RAMPDP_256X64_GL_M2_D2 (  WE,  CLK, IDDQ, SVOP_0, SVOP_1, SVOP_2, SVOP_3, SVOP_4, SVOP_5, SVOP_6, SVOP_7 
,WD_63, WD_62, WD_61, WD_60, WD_59, WD_58, WD_57, WD_56, WD_55, WD_54, WD_53, WD_52, WD_51, WD_50, WD_49, WD_48, WD_47, WD_46, WD_45, WD_44, WD_43, WD_42, WD_41, WD_40, WD_39, WD_38, WD_37, WD_36, WD_35, WD_34, WD_33, WD_32, WD_31, WD_30, WD_29, WD_28, WD_27, WD_26, WD_25, WD_24, WD_23, WD_22, WD_21, WD_20, WD_19, WD_18, WD_17, WD_16, WD_15, WD_14, WD_13, WD_12, WD_11, WD_10, WD_9, WD_8, WD_7, WD_6, WD_5, WD_4, WD_3, WD_2, WD_1, WD_0,RD_63, RD_62, RD_61, RD_60, RD_59, RD_58, RD_57, RD_56, RD_55, RD_54, RD_53, RD_52, RD_51, RD_50, RD_49, RD_48, RD_47, RD_46, RD_45, RD_44, RD_43, RD_42, RD_41, RD_40, RD_39, RD_38, RD_37, RD_36, RD_35, RD_34, RD_33, RD_32, RD_31, RD_30, RD_29, RD_28, RD_27, RD_26, RD_25, RD_24, RD_23, RD_22, RD_21, RD_20, RD_19, RD_18, RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0, RE
, RADR_7, RADR_6, RADR_5, RADR_4, RADR_3, RADR_2, RADR_1, RADR_0, WADR_7, WADR_6, WADR_5, WADR_4, WADR_3, WADR_2, WADR_1, WADR_0, SLEEP_EN_7, SLEEP_EN_6, SLEEP_EN_5, SLEEP_EN_4, SLEEP_EN_3, SLEEP_EN_2, SLEEP_EN_1, SLEEP_EN_0, RET_EN
);

// nvProps NoBus SLEEP_EN_

`ifndef RAM_INTERFACE
`ifndef SYNTHESIS
// Physical ram size defined as localparam
parameter phy_rows = 128;
parameter phy_cols = 128;
parameter phy_rcols_pos = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

`endif //SYNTHESIS
`endif //RAM_INTERFACE

// Test mode control ports
input IDDQ;
// Clock port
input CLK;
// SVOP ports
input SVOP_0, SVOP_1, SVOP_2, SVOP_3, SVOP_4, SVOP_5, SVOP_6, SVOP_7;
// Write data ports
input WD_63, WD_62, WD_61, WD_60, WD_59, WD_58, WD_57, WD_56, WD_55, WD_54, WD_53, WD_52, WD_51, WD_50, WD_49, WD_48, WD_47, WD_46, WD_45, WD_44, WD_43, WD_42, WD_41, WD_40, WD_39, WD_38, WD_37, WD_36, WD_35, WD_34, WD_33, WD_32, WD_31, WD_30, WD_29, WD_28, WD_27, WD_26, WD_25, WD_24, WD_23, WD_22, WD_21, WD_20, WD_19, WD_18, WD_17, WD_16, WD_15, WD_14, WD_13, WD_12, WD_11, WD_10, WD_9, WD_8, WD_7, WD_6, WD_5, WD_4, WD_3, WD_2, WD_1, WD_0;
// Read data ports
output RD_63, RD_62, RD_61, RD_60, RD_59, RD_58, RD_57, RD_56, RD_55, RD_54, RD_53, RD_52, RD_51, RD_50, RD_49, RD_48, RD_47, RD_46, RD_45, RD_44, RD_43, RD_42, RD_41, RD_40, RD_39, RD_38, RD_37, RD_36, RD_35, RD_34, RD_33, RD_32, RD_31, RD_30, RD_29, RD_28, RD_27, RD_26, RD_25, RD_24, RD_23, RD_22, RD_21, RD_20, RD_19, RD_18, RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0;
// Read enable ports
input RE;
// Write enable ports
input WE;
// Read address ports
input RADR_7, RADR_6, RADR_5, RADR_4, RADR_3, RADR_2, RADR_1, RADR_0;
// Write address ports
input WADR_7, WADR_6, WADR_5, WADR_4, WADR_3, WADR_2, WADR_1, WADR_0;

// PG Zone enables
input SLEEP_EN_0, SLEEP_EN_1, SLEEP_EN_2, SLEEP_EN_3, SLEEP_EN_4, SLEEP_EN_5, SLEEP_EN_6, SLEEP_EN_7, RET_EN;

`ifndef RAM_INTERFACE
wire VDD = 1'b1;
wire GND  = 1'b0;

// Combine the sleep enable pins into one bus
	wire [7:0] SLEEP_EN = {SLEEP_EN_7, SLEEP_EN_6, SLEEP_EN_5, SLEEP_EN_4, SLEEP_EN_3, SLEEP_EN_2, SLEEP_EN_1, SLEEP_EN_0};

// Signal to clamp the outputs when the VDD is power gated off.
	wire clamp_rd   = SLEEP_EN[7] ;

// State point clobering signals
// X-out state points when their power goes out
    wire clobber_x;
`ifndef SYNTHESIS
`ifdef DISABLE_REPAIR_X
    wire check_x = (RET_EN ^ (^SLEEP_EN[7:0]) ^  SVOP_0 ^ SVOP_1 ^ SVOP_2 ^ SVOP_3 ^ SVOP_4 ^ SVOP_5 ^ SVOP_6 ^ SVOP_7);
`else 
    wire check_x = (RET_EN ^ (^SLEEP_EN[7:0]) ^  SVOP_0 ^ SVOP_1 ^ SVOP_2 ^ SVOP_3 ^ SVOP_4 ^ SVOP_5 ^ SVOP_6 ^ SVOP_7 );
`endif 
    assign clobber_x = ((check_x === 1'bx) || (check_x === 1'bz))?1'b1:1'b0;
 
    wire clobber_array = (~RET_EN & (|SLEEP_EN[3:0]))  | clobber_x;
    wire clobber_flops = (|SLEEP_EN[7:4]) | clobber_x ;
`else //SYNTHESIS
    wire clobber_array = 1'b0;
    wire clobber_flops = 1'b0;
    assign clobber_x = 1'b0;
`endif //SYNTHESIS 

// Output valid signal
// Outputs are unknown in non-retention mode if VDDM is powered up , but VDD is not 
    wire outvalid;
	assign outvalid = ~(clobber_x | (~RET_EN & (|SLEEP_EN[3:0]) & (|(~SLEEP_EN[7:4]))));


//assemble & rename wires
// Extend the MSB's of the read/write addresses to cover all the flop inputs
// The number of address flops is fixed. Also combine all the individual *_* bits into one bus
	wire [7:0] RA = {RADR_7, RADR_6, RADR_5, RADR_4, RADR_3, RADR_2, RADR_1, RADR_0};
	wire [7:0] WA = {WADR_7, WADR_6, WADR_5, WADR_4, WADR_3, WADR_2, WADR_1, WADR_0};
// Combine all the write data input bits
	wire [63:0] WD = {WD_63, WD_62, WD_61, WD_60, WD_59, WD_58, WD_57, WD_56, WD_55, WD_54, WD_53, WD_52, WD_51, WD_50, WD_49, WD_48, WD_47, WD_46, WD_45, WD_44, WD_43, WD_42, WD_41, WD_40, WD_39, WD_38, WD_37, WD_36, WD_35, WD_34, WD_33, WD_32, WD_31, WD_30, WD_29, WD_28, WD_27, WD_26, WD_25, WD_24, WD_23, WD_22, WD_21, WD_20, WD_19, WD_18, WD_17, WD_16, WD_15, WD_14, WD_13, WD_12, WD_11, WD_10, WD_9, WD_8, WD_7, WD_6, WD_5, WD_4, WD_3, WD_2, WD_1, WD_0};
	wire [63:0] RD;
// Expand the read data bus into individual output bits
//	assign {RD_63, RD_62, RD_61, RD_60, RD_59, RD_58, RD_57, RD_56, RD_55, RD_54, RD_53, RD_52, RD_51, RD_50, RD_49, RD_48, RD_47, RD_46, RD_45, RD_44, RD_43, RD_42, RD_41, RD_40, RD_39, RD_38, RD_37, RD_36, RD_35, RD_34, RD_33, RD_32, RD_31, RD_30, RD_29, RD_28, RD_27, RD_26, RD_25, RD_24, RD_23, RD_22, RD_21, RD_20, RD_19, RD_18, RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0} = (outvalid) ? RD : 64'bx;
// Do the read data swizzing based on the number of words and bits. 
`ifndef SYNTHESIS
	assign {RD_63, RD_62, RD_61, RD_60, RD_59, RD_58, RD_57, RD_56, RD_55, RD_54, RD_53, RD_52, RD_51, RD_50, RD_49, RD_48, RD_47, RD_46, RD_45, RD_44, RD_43, RD_42, RD_41, RD_40, RD_39, RD_38, RD_37, RD_36, RD_35, RD_34, RD_33, RD_32, RD_31, RD_30, RD_29, RD_28, RD_27, RD_26, RD_25, RD_24, RD_23, RD_22, RD_21, RD_20, RD_19, RD_18, RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0} = (outvalid) ? RD & ~{64{clamp_rd}} : 64'bx;
`else
	assign {RD_63, RD_62, RD_61, RD_60, RD_59, RD_58, RD_57, RD_56, RD_55, RD_54, RD_53, RD_52, RD_51, RD_50, RD_49, RD_48, RD_47, RD_46, RD_45, RD_44, RD_43, RD_42, RD_41, RD_40, RD_39, RD_38, RD_37, RD_36, RD_35, RD_34, RD_33, RD_32, RD_31, RD_30, RD_29, RD_28, RD_27, RD_26, RD_25, RD_24, RD_23, RD_22, RD_21, RD_20, RD_19, RD_18, RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0} =  RD & ~{64{clamp_rd}};
`endif
	wire [7:0] SVOP = {SVOP_7, SVOP_6, SVOP_5, SVOP_4, SVOP_3, SVOP_2, SVOP_1, SVOP_0};


`ifndef EMULATION

// Instantiate memory bank
// This block defines the core functionality of the rams.
	RAM_BANK_RAMPDP_256X64_GL_M2_D2 ITOP ( WE, CLK, IDDQ, SVOP, WD, RD, RE, RA, WA
, SLEEP_EN
,  RET_EN, clobber_array , clobber_flops 
);

`ifndef SYNTHESIS 
// Tasks for initializing the arrays
//VCS coverage off    
always  @(clobber_array) begin : clobber_array_block
    integer i;
    if (clobber_array) begin
	    for (i=0; i<256; i=i+1) begin
		     mem_wr_raw(i, {64{1'bx}});
		end
    end
end


always  @(clobber_flops) begin
  if (clobber_flops) begin
      ITOP.RE_LATB <= 1'bx;
      ITOP.RE_FF <= 1'bx;
      ITOP.WE_LATB <= 1'bx;
      ITOP.WE_FF <= 1'bx;
      ITOP.RADR <= 8'bx;
      ITOP.WADR <= 8'bx;
      ITOP.WAFF <= 8'bx;
      ITOP.WDQ_pr <= 64'bx;
      ITOP.dout <= 64'bx;
  end
end  
//VCS coverage on    

//VCS coverage off    
task mem_wr_raw;
  input [7:0] addr;
  input [63:0] data;
  begin
    if (addr[0] == 1'b0) 
        ITOP.iow0.mem_wr_raw_subbank(addr[7:1], data);
    else if (addr[0] == 1'b1)
        ITOP.iow1.mem_wr_raw_subbank(addr[7:1], data);
  end
endtask

// Ramgen function for writing the arrays 
task mem_write;
  input [7:0] addr;
  input [63:0] data;
  begin
    ITOP.mem_write_bank(addr,data);
  end
endtask

// Ramgen function for reading the arrays 
function [63:0] mem_read;
input [7:0] addr;
  begin
        mem_read = ITOP.mem_read_bank(addr);
  end
endfunction


// Random only generates 32 bit value.
// If nbits > 32, call it multiple times
// Old random fill fills all memory locations with same random value


task mem_fill_random;
	reg [63:0] val;
	integer i;
	begin
		for (i=0; i<256; i=i+1) begin
		    val = {$random, $random};
		    mem_wr_raw(i, val);
		end
	end 
endtask

// Fill the memory with a given bit value 
task mem_fill_value;
    input fill_bit;
	reg [63:0] val;
    integer i;
    begin
        val = {64{fill_bit}};
        for (i=0; i<256; i=i+1) begin
		    mem_wr_raw(i, val);
        end
    end
endtask 

// read logical address and feed into salat
task force_rd;
input [7:0] addr;
	reg [63:0] rd;

	`ifdef USE_RAMINIT_LIBS
	reg raminit_active, raminit_argcheck, raminit_debug, raminit_enable, raminit_random, raminit_invert,
	    raminit_val, raminit_waitclock, raminit_use_force;
	real raminit_delay_ns, raminit_waitclock_check_ns;
	initial
	begin
	  raminit_active    = 0; // default is inactive (plusarg to active the ram init functionality)
	  raminit_argcheck  = 0; // default is no plusargs check (apart from raminit_active and raminit_argcheck)
	  raminit_debug     = 0; // default is no debug messages
	  raminit_enable    = 0; // default is no init (variable indicating if the ram init functionality is enabled for this instance)
	  raminit_random    = 0; // default is no random init
	  raminit_invert    = 0; // default is not to invert the init value
	  raminit_val       = 0; // default init value is zero
	  raminit_waitclock = 0; // default is not to wait to clock to be non-X
	  raminit_use_force = 1; // default is to use force/release
	  raminit_delay_ns           = `ifdef NV_TOP_RESET_ON_DELAY  (`NV_TOP_RESET_ON_DELAY+2) `else 3 `endif; // default is 2ns after nv_top_reset_ goes low or ram clock is not X
	  raminit_waitclock_check_ns = `ifdef NV_TOP_RESET_OFF_DELAY (`NV_TOP_RESET_OFF_DELAY)  `else 0 `endif; // default is when nv_top_reset_ goes high
	  $value$plusargs("raminit_active=%d",    raminit_active);
	  $value$plusargs("raminit_argcheck=%d",  raminit_argcheck);
	  if (raminit_argcheck)
	  begin
	    // The following variables are not usually used as plusargs, but instead set through add_inst_array calls or the init_inst_file.
	    $value$plusargs("raminit_debug=%d",              raminit_debug);
	    $value$plusargs("raminit_enable=%d",             raminit_enable);
	    $value$plusargs("raminit_random=%d",             raminit_random);
	    $value$plusargs("raminit_invert=%d",             raminit_invert);
	    $value$plusargs("raminit_val=%d",                raminit_val);
	    $value$plusargs("raminit_waitclock=%d",          raminit_waitclock);
	    $value$plusargs("raminit_delay_ns=%f",           raminit_delay_ns);
	    $value$plusargs("raminit_waitclock_check_ns=%f", raminit_waitclock_check_ns);
	    $value$plusargs("raminit_use_force=%d",          raminit_use_force);
	  end
	  `ifdef INST_CHECK
	  `INST_CHECK(ram_inst_check0,raminit_active,raminit_debug,raminit_enable,raminit_random,raminit_val,raminit_invert,raminit_waitclock,raminit_delay_ns,raminit_waitclock_check_ns);
	  `endif
	  if (!raminit_active)  raminit_enable = 0;
	  else if (raminit_enable)
	  begin
	    if (raminit_random) raminit_val = `ifdef NO_PLI 1'b0 `else $RollPLI(0,1) `endif;
	    if (raminit_invert) raminit_val = ~raminit_val;
	  end
	  if (raminit_debug)
	  begin
	    $display("%m: raminit_active              = %d", raminit_active);
	    $display("%m: raminit_argcheck            = %d", raminit_argcheck);
	    $display("%m: raminit_debug               = %d", raminit_debug);
	    $display("%m: raminit_enable              = %d", raminit_enable);
	    $display("%m: raminit_random              = %d", raminit_random);
	    $display("%m: raminit_invert              = %d", raminit_invert);
	    $display("%m: raminit_val                 = %d", raminit_val);
	    $display("%m: raminit_waitclock           = %d", raminit_waitclock);
	    $display("%m: raminit_delay_ns            = %f ns", raminit_delay_ns);
	    $display("%m: raminit_waitclock_check_ns  = %f ns", raminit_waitclock_check_ns);
	    $display("%m: raminit_use_force           = %d", raminit_use_force);
	  end
	end
	`endif

	`ifdef USE_RAMINIT_LIBS
	// init rd
	task init_rd_regs;
	begin
	  #0; // wait for raminit variables to be set
	  if (raminit_enable)
	  begin : raminit_val_blk
	    reg [64-1:0] raminit_fullval;
	    if (raminit_random)  raminit_fullval = `ifdef NO_PLI {64 {1'b1}} `else { $RollPLI(0,{32{1'b1}}), $RollPLI(0,{32{1'b1}}) } `endif ;
	    else                 raminit_fullval = {64 {raminit_val}};
	    if (raminit_invert)  raminit_fullval = ~raminit_fullval;
	    if (raminit_use_force)  force rd = raminit_fullval;
	    if (raminit_waitclock)  wait ( !== 1'bx);
	    #(raminit_delay_ns*100);
	    `ifdef INST_WAITCLOCK_CHECK
	    `INST_WAITCLOCK_CHECK(waitclock_inst_check0,raminit_waitclock,raminit_waitclock_check_ns,100)
	    `endif
	    if (raminit_use_force)  release rd;
	    rd = raminit_fullval;
	  end
	end
	endtask
	initial begin init_rd_regs();  end
	`ifdef RAMINIT_TRIGGER
	always @(`RAMINIT_TRIGGER)  init_rd_regs();
	`endif
	`endif // `ifdef USE_RAMINIT_LIBS

	begin
        if (addr[0] == 1'b0) 
            rd = ITOP.iow0.mem_read_raw_subbank(addr[7:1]);
        else if (addr[0] == 1'b1)
            rd = ITOP.iow1.mem_read_raw_subbank(addr[7:1]);
		ITOP.dout = rd;
	end
endtask

`ifdef MEM_PHYS_INFO
//function for physical array read row, takes physical address
function [127:0] mem_phys_read_padr;
input [6:0] addr;
	reg [127:0] rd_row;

	`ifdef USE_RAMINIT_LIBS
	// init rd_row
	task init_rd_row_regs;
	begin
	  #0; // wait for raminit variables to be set
	  if (raminit_enable)
	  begin : raminit_val_blk
	    reg [128-1:0] raminit_fullval;
	    if (raminit_random)  raminit_fullval = `ifdef NO_PLI {128 {1'b1}} `else { $RollPLI(0,{32{1'b1}}), $RollPLI(0,{32{1'b1}}), $RollPLI(0,{32{1'b1}}), $RollPLI(0,{32{1'b1}}) } `endif ;
	    else                 raminit_fullval = {128 {raminit_val}};
	    if (raminit_invert)  raminit_fullval = ~raminit_fullval;
	    if (raminit_use_force)  force rd_row = raminit_fullval;
	    if (raminit_waitclock)  wait ( !== 1'bx);
	    #(raminit_delay_ns*100);
	    `ifdef INST_WAITCLOCK_CHECK
	    `INST_WAITCLOCK_CHECK(waitclock_inst_check1,raminit_waitclock,raminit_waitclock_check_ns,100)
	    `endif
	    if (raminit_use_force)  release rd_row;
	    rd_row = raminit_fullval;
	  end
	end
	endtask
	initial begin init_rd_row_regs();  end
	`ifdef RAMINIT_TRIGGER
	always @(`RAMINIT_TRIGGER)  init_rd_row_regs();
	`endif
	`endif // `ifdef USE_RAMINIT_LIBS

	reg [63:0] rd[1:0];
	integer i;
	begin
        rd[0] = ITOP.iow0.mem_read_raw_subbank(addr);
        rd[1] = ITOP.iow1.mem_read_raw_subbank(addr);
        for (i=0; i<=63; i=i+1) begin
            rd_row[i*2+0] = rd[0][i];
            rd_row[i*2+1] = rd[1][i];
		end
		mem_phys_read_padr = rd_row;
	end
endfunction

//function for physical array read row, takes logical address
function [127:0] mem_phys_read_ladr;
input [7:0] addr;
    reg [6:0] paddr;
	reg [127:0] rd_row;

	`ifdef USE_RAMINIT_LIBS
	// init rd_row
	task init_rd_row_regs;
	begin
	  #0; // wait for raminit variables to be set
	  if (raminit_enable)
	  begin : raminit_val_blk
	    reg [128-1:0] raminit_fullval;
	    if (raminit_random)  raminit_fullval = `ifdef NO_PLI {128 {1'b1}} `else { $RollPLI(0,{32{1'b1}}), $RollPLI(0,{32{1'b1}}), $RollPLI(0,{32{1'b1}}), $RollPLI(0,{32{1'b1}}) } `endif ;
	    else                 raminit_fullval = {128 {raminit_val}};
	    if (raminit_invert)  raminit_fullval = ~raminit_fullval;
	    if (raminit_use_force)  force rd_row = raminit_fullval;
	    if (raminit_waitclock)  wait ( !== 1'bx);
	    #(raminit_delay_ns*100);
	    `ifdef INST_WAITCLOCK_CHECK
	    `INST_WAITCLOCK_CHECK(waitclock_inst_check2,raminit_waitclock,raminit_waitclock_check_ns,100)
	    `endif
	    if (raminit_use_force)  release rd_row;
	    rd_row = raminit_fullval;
	  end
	end
	endtask
	initial begin init_rd_row_regs();  end
	`ifdef RAMINIT_TRIGGER
	always @(`RAMINIT_TRIGGER)  init_rd_row_regs();
	`endif
	`endif // `ifdef USE_RAMINIT_LIBS

	reg [63:0] rd[1:0];
	integer i;
	begin
        paddr = (addr >> 1);
        rd[0] = ITOP.iow0.mem_read_raw_subbank(paddr);
        rd[1] = ITOP.iow1.mem_read_raw_subbank(paddr);
        for (i=0; i<=63; i=i+1) begin
            rd_row[i*2+0] = rd[0][i];
            rd_row[i*2+1] = rd[1][i];
		end
		mem_phys_read_ladr = rd_row;
	end
endfunction


//function for physical array read row with column masking, takes logical address
function [127:0] mem_phys_read_pmasked;
input [7:0] addr;
   reg [127:0] rd_row;

   `ifdef USE_RAMINIT_LIBS
   // init rd_row
   task init_rd_row_regs;
   begin
     #0; // wait for raminit variables to be set
     if (raminit_enable)
     begin : raminit_val_blk
       reg [128-1:0] raminit_fullval;
       if (raminit_random)  raminit_fullval = `ifdef NO_PLI {128 {1'b1}} `else { $RollPLI(0,{32{1'b1}}), $RollPLI(0,{32{1'b1}}), $RollPLI(0,{32{1'b1}}), $RollPLI(0,{32{1'b1}}) } `endif ;
       else                 raminit_fullval = {128 {raminit_val}};
       if (raminit_invert)  raminit_fullval = ~raminit_fullval;
       if (raminit_use_force)  force rd_row = raminit_fullval;
       if (raminit_waitclock)  wait ( !== 1'bx);
       #(raminit_delay_ns*100);
       `ifdef INST_WAITCLOCK_CHECK
       `INST_WAITCLOCK_CHECK(waitclock_inst_check3,raminit_waitclock,raminit_waitclock_check_ns,100)
       `endif
       if (raminit_use_force)  release rd_row;
       rd_row = raminit_fullval;
     end
   end
   endtask
   initial begin init_rd_row_regs();  end
   `ifdef RAMINIT_TRIGGER
   always @(`RAMINIT_TRIGGER)  init_rd_row_regs();
   `endif
   `endif // `ifdef USE_RAMINIT_LIBS

   reg [63:0] rd[1 : 0];
   integer i;
   begin
        rd[0] = (addr[0:0] === 0) ? ITOP.iow0.mem_read_raw_subbank(addr[7:1]) : 64'bx;
        rd[1] = (addr[0:0] === 1) ? ITOP.iow1.mem_read_raw_subbank(addr[7:1]) : 64'bx;
        for (i=0; i<=63; i=i+1) begin
            rd_row[i*2+0] = rd[0][i];
            rd_row[i*2+1] = rd[1][i];
        end
        mem_phys_read_pmasked = rd_row;
    end
endfunction

//Task for physical array write row, takes physical address
task mem_phys_write;
input [6:0] addr;
input [127:0] data;
	reg [63:0] wr[1:0];
	integer i;
	begin
        for (i=0; i<=63; i=i+1) begin
            wr[0][i] = data[i*2+0];
            wr[1][i] = data[i*2+1];
		end
        ITOP.iow0.mem_wr_raw_subbank(addr,wr[0]);
        ITOP.iow1.mem_wr_raw_subbank(addr,wr[1]);
	end
endtask

// Function to return a physical address given a logical address input.
function [6:0] mem_log_to_phys_adr;
input [7:0] addr;
    begin
        mem_log_to_phys_adr = (addr >> 1) ; 
    end
endfunction 
`endif //MEM_PHYS_INFO

`ifdef MONITOR
// Monitor dump trigger
reg dump_monitor_result;

initial begin : init_monitor
  dump_monitor_result = 1'b0;
end

task monitor_on;
    begin
		ITOP.iow0.monitor_on = 1'b1;
		ITOP.iow1.monitor_on = 1'b1;
   end
endtask

task monitor_off;
    begin
		ITOP.iow0.monitor_on = 1'b0;
		ITOP.iow1.monitor_on = 1'b0;
        dump_monitor_result = 1'b1;
    end
endtask

// read bit_written monitor row by physical address from subarray
function [127:0] mon_bit_w;
input [6:0] addr;
	reg [127:0] mon_row;
	reg [63:0] mon_word[1:0];
	integer i;
	begin
		// read all monitor words for a row
		mon_word[0] = ITOP.iow0.bit_written[addr];
		mon_word[1] = ITOP.iow1.bit_written[addr];
		// combine all 2 words to a row
		for (i=0; i<=63; i=i+1) begin
			mon_row[i*2+0] = mon_word[0][i];
			mon_row[i*2+1] = mon_word[1][i];
		end
		mon_bit_w = mon_row;
	end
endfunction

// read bit_read monitor word by address from subarray
function [127:0] mon_bit_r;
input [6:0] addr;
	reg [127:0] mon_row;
	reg [63:0] mon_word[1:0];
	integer i;
	begin
		// read all monitor words for a row
		mon_word[0] = ITOP.iow0.bit_read[addr];
		mon_word[1] = ITOP.iow1.bit_read[addr];
		// combine all 2 words to a row
		for (i=0; i<=63; i=i+1) begin
			mon_row[i*2+0] = mon_word[0][i];
			mon_row[i*2+1] = mon_word[1][i];
		end
		mon_bit_r = mon_row;
	end
endfunction

// read word_written monitor row by physical address from subarray
function  mon_word_w;
input [6:0] addr;
	reg mon_word[1:0];
	integer i;
	begin
		// read all monitor words for a row
		mon_word[0] = ITOP.iow0.word_written[addr];
		mon_word[1] = ITOP.iow1.word_written[addr];
		// combine all 2 words to a row
		mon_word_w = mon_word[0] | mon_word[1] ;
	end
endfunction

// read word_read monitor row by physical address from subarray
function  mon_word_r;
input [6:0] addr;
	reg mon_word[1:0];
	integer i;
	begin
		// read all monitor words for a row
		mon_word[0] = ITOP.iow0.word_read[addr];
		mon_word[1] = ITOP.iow1.word_read[addr];
		// combine all 2 words to a row
		mon_word_r = mon_word[0] | mon_word[1] ;
	end
endfunction

always @(dump_monitor_result) begin : dump_monitor
	integer i;
	integer j;
	reg [127:0] tmp_row;
    reg tmp_bit;
	if (dump_monitor_result == 1'b1) begin
	    $display("Exercised coverage summary:");
        $display("\t%m rows unwritten:");
        for(i=0;i<=128;i=i+1) begin
			tmp_bit = mon_word_w(i);
            if (tmp_bit !== 1) $display("\t\trow %d", i);
		end
        $display("\t%m rows unread:");
        for(i=0;i<=128;i=i+1) begin
			tmp_bit = mon_word_r(i);
            if (tmp_bit !== 1) $display("\t\trow %d", i);
		end
		$display("\t%m bits not written as 0:");
		for (i=0; i<128; i=i+1) begin
			tmp_row = mon_bit_w(i);
			for (j=0; j<128; j=j+1) begin
				if (tmp_row[j] !== 1'b0 && tmp_row[j] !== 1'bz) $display("\t\t[row,bit] [%d,%d]", i, j);
			end
		end
		$display("\t%m bits not written as 1:");
		for (i=0; i<128; i=i+1) begin
			tmp_row = mon_bit_w(i);
			for (j=0; j<128; j=j+1) begin
				if (tmp_row[j] !== 1'b1 && tmp_row[j] !== 1'bz) $display("\t\t[row,bit] [%d,%d]", i, j);
			end
		end
		$display("\t%m bits not read as 0:");
		for (i=0; i<128; i=i+1) begin
			tmp_row = mon_bit_r(i);
			for (j=0; j<128; j=j+1) begin
				if (tmp_row[j] !== 1'b0 && tmp_row[j] !== 1'bz) $display("\t\t[row,bit] [%d,%d]", i, j);
			end
		end
		$display("\t%m bits not read as 1:");
		for (i=0; i<128; i=i+1) begin
			tmp_row = mon_bit_r(i);
			for (j=0; j<128; j=j+1) begin
				if (tmp_row[j] !== 1'b1 && tmp_row[j] !== 1'bz) $display("\t\t[row,bit] [%d,%d]", i, j);
			end
		end
		dump_monitor_result = 1'b0;
	end
end

//VCS coverage on    
`endif // MONITOR

`ifdef NV_RAM_EXPAND_ARRAY
wire [63:0] Q_0 = ITOP.iow0.arr[0];
wire [63:0] Q_1 = ITOP.iow1.arr[0];
wire [63:0] Q_2 = ITOP.iow0.arr[1];
wire [63:0] Q_3 = ITOP.iow1.arr[1];
wire [63:0] Q_4 = ITOP.iow0.arr[2];
wire [63:0] Q_5 = ITOP.iow1.arr[2];
wire [63:0] Q_6 = ITOP.iow0.arr[3];
wire [63:0] Q_7 = ITOP.iow1.arr[3];
wire [63:0] Q_8 = ITOP.iow0.arr[4];
wire [63:0] Q_9 = ITOP.iow1.arr[4];
wire [63:0] Q_10 = ITOP.iow0.arr[5];
wire [63:0] Q_11 = ITOP.iow1.arr[5];
wire [63:0] Q_12 = ITOP.iow0.arr[6];
wire [63:0] Q_13 = ITOP.iow1.arr[6];
wire [63:0] Q_14 = ITOP.iow0.arr[7];
wire [63:0] Q_15 = ITOP.iow1.arr[7];
wire [63:0] Q_16 = ITOP.iow0.arr[8];
wire [63:0] Q_17 = ITOP.iow1.arr[8];
wire [63:0] Q_18 = ITOP.iow0.arr[9];
wire [63:0] Q_19 = ITOP.iow1.arr[9];
wire [63:0] Q_20 = ITOP.iow0.arr[10];
wire [63:0] Q_21 = ITOP.iow1.arr[10];
wire [63:0] Q_22 = ITOP.iow0.arr[11];
wire [63:0] Q_23 = ITOP.iow1.arr[11];
wire [63:0] Q_24 = ITOP.iow0.arr[12];
wire [63:0] Q_25 = ITOP.iow1.arr[12];
wire [63:0] Q_26 = ITOP.iow0.arr[13];
wire [63:0] Q_27 = ITOP.iow1.arr[13];
wire [63:0] Q_28 = ITOP.iow0.arr[14];
wire [63:0] Q_29 = ITOP.iow1.arr[14];
wire [63:0] Q_30 = ITOP.iow0.arr[15];
wire [63:0] Q_31 = ITOP.iow1.arr[15];
wire [63:0] Q_32 = ITOP.iow0.arr[16];
wire [63:0] Q_33 = ITOP.iow1.arr[16];
wire [63:0] Q_34 = ITOP.iow0.arr[17];
wire [63:0] Q_35 = ITOP.iow1.arr[17];
wire [63:0] Q_36 = ITOP.iow0.arr[18];
wire [63:0] Q_37 = ITOP.iow1.arr[18];
wire [63:0] Q_38 = ITOP.iow0.arr[19];
wire [63:0] Q_39 = ITOP.iow1.arr[19];
wire [63:0] Q_40 = ITOP.iow0.arr[20];
wire [63:0] Q_41 = ITOP.iow1.arr[20];
wire [63:0] Q_42 = ITOP.iow0.arr[21];
wire [63:0] Q_43 = ITOP.iow1.arr[21];
wire [63:0] Q_44 = ITOP.iow0.arr[22];
wire [63:0] Q_45 = ITOP.iow1.arr[22];
wire [63:0] Q_46 = ITOP.iow0.arr[23];
wire [63:0] Q_47 = ITOP.iow1.arr[23];
wire [63:0] Q_48 = ITOP.iow0.arr[24];
wire [63:0] Q_49 = ITOP.iow1.arr[24];
wire [63:0] Q_50 = ITOP.iow0.arr[25];
wire [63:0] Q_51 = ITOP.iow1.arr[25];
wire [63:0] Q_52 = ITOP.iow0.arr[26];
wire [63:0] Q_53 = ITOP.iow1.arr[26];
wire [63:0] Q_54 = ITOP.iow0.arr[27];
wire [63:0] Q_55 = ITOP.iow1.arr[27];
wire [63:0] Q_56 = ITOP.iow0.arr[28];
wire [63:0] Q_57 = ITOP.iow1.arr[28];
wire [63:0] Q_58 = ITOP.iow0.arr[29];
wire [63:0] Q_59 = ITOP.iow1.arr[29];
wire [63:0] Q_60 = ITOP.iow0.arr[30];
wire [63:0] Q_61 = ITOP.iow1.arr[30];
wire [63:0] Q_62 = ITOP.iow0.arr[31];
wire [63:0] Q_63 = ITOP.iow1.arr[31];
wire [63:0] Q_64 = ITOP.iow0.arr[32];
wire [63:0] Q_65 = ITOP.iow1.arr[32];
wire [63:0] Q_66 = ITOP.iow0.arr[33];
wire [63:0] Q_67 = ITOP.iow1.arr[33];
wire [63:0] Q_68 = ITOP.iow0.arr[34];
wire [63:0] Q_69 = ITOP.iow1.arr[34];
wire [63:0] Q_70 = ITOP.iow0.arr[35];
wire [63:0] Q_71 = ITOP.iow1.arr[35];
wire [63:0] Q_72 = ITOP.iow0.arr[36];
wire [63:0] Q_73 = ITOP.iow1.arr[36];
wire [63:0] Q_74 = ITOP.iow0.arr[37];
wire [63:0] Q_75 = ITOP.iow1.arr[37];
wire [63:0] Q_76 = ITOP.iow0.arr[38];
wire [63:0] Q_77 = ITOP.iow1.arr[38];
wire [63:0] Q_78 = ITOP.iow0.arr[39];
wire [63:0] Q_79 = ITOP.iow1.arr[39];
wire [63:0] Q_80 = ITOP.iow0.arr[40];
wire [63:0] Q_81 = ITOP.iow1.arr[40];
wire [63:0] Q_82 = ITOP.iow0.arr[41];
wire [63:0] Q_83 = ITOP.iow1.arr[41];
wire [63:0] Q_84 = ITOP.iow0.arr[42];
wire [63:0] Q_85 = ITOP.iow1.arr[42];
wire [63:0] Q_86 = ITOP.iow0.arr[43];
wire [63:0] Q_87 = ITOP.iow1.arr[43];
wire [63:0] Q_88 = ITOP.iow0.arr[44];
wire [63:0] Q_89 = ITOP.iow1.arr[44];
wire [63:0] Q_90 = ITOP.iow0.arr[45];
wire [63:0] Q_91 = ITOP.iow1.arr[45];
wire [63:0] Q_92 = ITOP.iow0.arr[46];
wire [63:0] Q_93 = ITOP.iow1.arr[46];
wire [63:0] Q_94 = ITOP.iow0.arr[47];
wire [63:0] Q_95 = ITOP.iow1.arr[47];
wire [63:0] Q_96 = ITOP.iow0.arr[48];
wire [63:0] Q_97 = ITOP.iow1.arr[48];
wire [63:0] Q_98 = ITOP.iow0.arr[49];
wire [63:0] Q_99 = ITOP.iow1.arr[49];
wire [63:0] Q_100 = ITOP.iow0.arr[50];
wire [63:0] Q_101 = ITOP.iow1.arr[50];
wire [63:0] Q_102 = ITOP.iow0.arr[51];
wire [63:0] Q_103 = ITOP.iow1.arr[51];
wire [63:0] Q_104 = ITOP.iow0.arr[52];
wire [63:0] Q_105 = ITOP.iow1.arr[52];
wire [63:0] Q_106 = ITOP.iow0.arr[53];
wire [63:0] Q_107 = ITOP.iow1.arr[53];
wire [63:0] Q_108 = ITOP.iow0.arr[54];
wire [63:0] Q_109 = ITOP.iow1.arr[54];
wire [63:0] Q_110 = ITOP.iow0.arr[55];
wire [63:0] Q_111 = ITOP.iow1.arr[55];
wire [63:0] Q_112 = ITOP.iow0.arr[56];
wire [63:0] Q_113 = ITOP.iow1.arr[56];
wire [63:0] Q_114 = ITOP.iow0.arr[57];
wire [63:0] Q_115 = ITOP.iow1.arr[57];
wire [63:0] Q_116 = ITOP.iow0.arr[58];
wire [63:0] Q_117 = ITOP.iow1.arr[58];
wire [63:0] Q_118 = ITOP.iow0.arr[59];
wire [63:0] Q_119 = ITOP.iow1.arr[59];
wire [63:0] Q_120 = ITOP.iow0.arr[60];
wire [63:0] Q_121 = ITOP.iow1.arr[60];
wire [63:0] Q_122 = ITOP.iow0.arr[61];
wire [63:0] Q_123 = ITOP.iow1.arr[61];
wire [63:0] Q_124 = ITOP.iow0.arr[62];
wire [63:0] Q_125 = ITOP.iow1.arr[62];
wire [63:0] Q_126 = ITOP.iow0.arr[63];
wire [63:0] Q_127 = ITOP.iow1.arr[63];
wire [63:0] Q_128 = ITOP.iow0.arr[64];
wire [63:0] Q_129 = ITOP.iow1.arr[64];
wire [63:0] Q_130 = ITOP.iow0.arr[65];
wire [63:0] Q_131 = ITOP.iow1.arr[65];
wire [63:0] Q_132 = ITOP.iow0.arr[66];
wire [63:0] Q_133 = ITOP.iow1.arr[66];
wire [63:0] Q_134 = ITOP.iow0.arr[67];
wire [63:0] Q_135 = ITOP.iow1.arr[67];
wire [63:0] Q_136 = ITOP.iow0.arr[68];
wire [63:0] Q_137 = ITOP.iow1.arr[68];
wire [63:0] Q_138 = ITOP.iow0.arr[69];
wire [63:0] Q_139 = ITOP.iow1.arr[69];
wire [63:0] Q_140 = ITOP.iow0.arr[70];
wire [63:0] Q_141 = ITOP.iow1.arr[70];
wire [63:0] Q_142 = ITOP.iow0.arr[71];
wire [63:0] Q_143 = ITOP.iow1.arr[71];
wire [63:0] Q_144 = ITOP.iow0.arr[72];
wire [63:0] Q_145 = ITOP.iow1.arr[72];
wire [63:0] Q_146 = ITOP.iow0.arr[73];
wire [63:0] Q_147 = ITOP.iow1.arr[73];
wire [63:0] Q_148 = ITOP.iow0.arr[74];
wire [63:0] Q_149 = ITOP.iow1.arr[74];
wire [63:0] Q_150 = ITOP.iow0.arr[75];
wire [63:0] Q_151 = ITOP.iow1.arr[75];
wire [63:0] Q_152 = ITOP.iow0.arr[76];
wire [63:0] Q_153 = ITOP.iow1.arr[76];
wire [63:0] Q_154 = ITOP.iow0.arr[77];
wire [63:0] Q_155 = ITOP.iow1.arr[77];
wire [63:0] Q_156 = ITOP.iow0.arr[78];
wire [63:0] Q_157 = ITOP.iow1.arr[78];
wire [63:0] Q_158 = ITOP.iow0.arr[79];
wire [63:0] Q_159 = ITOP.iow1.arr[79];
wire [63:0] Q_160 = ITOP.iow0.arr[80];
wire [63:0] Q_161 = ITOP.iow1.arr[80];
wire [63:0] Q_162 = ITOP.iow0.arr[81];
wire [63:0] Q_163 = ITOP.iow1.arr[81];
wire [63:0] Q_164 = ITOP.iow0.arr[82];
wire [63:0] Q_165 = ITOP.iow1.arr[82];
wire [63:0] Q_166 = ITOP.iow0.arr[83];
wire [63:0] Q_167 = ITOP.iow1.arr[83];
wire [63:0] Q_168 = ITOP.iow0.arr[84];
wire [63:0] Q_169 = ITOP.iow1.arr[84];
wire [63:0] Q_170 = ITOP.iow0.arr[85];
wire [63:0] Q_171 = ITOP.iow1.arr[85];
wire [63:0] Q_172 = ITOP.iow0.arr[86];
wire [63:0] Q_173 = ITOP.iow1.arr[86];
wire [63:0] Q_174 = ITOP.iow0.arr[87];
wire [63:0] Q_175 = ITOP.iow1.arr[87];
wire [63:0] Q_176 = ITOP.iow0.arr[88];
wire [63:0] Q_177 = ITOP.iow1.arr[88];
wire [63:0] Q_178 = ITOP.iow0.arr[89];
wire [63:0] Q_179 = ITOP.iow1.arr[89];
wire [63:0] Q_180 = ITOP.iow0.arr[90];
wire [63:0] Q_181 = ITOP.iow1.arr[90];
wire [63:0] Q_182 = ITOP.iow0.arr[91];
wire [63:0] Q_183 = ITOP.iow1.arr[91];
wire [63:0] Q_184 = ITOP.iow0.arr[92];
wire [63:0] Q_185 = ITOP.iow1.arr[92];
wire [63:0] Q_186 = ITOP.iow0.arr[93];
wire [63:0] Q_187 = ITOP.iow1.arr[93];
wire [63:0] Q_188 = ITOP.iow0.arr[94];
wire [63:0] Q_189 = ITOP.iow1.arr[94];
wire [63:0] Q_190 = ITOP.iow0.arr[95];
wire [63:0] Q_191 = ITOP.iow1.arr[95];
wire [63:0] Q_192 = ITOP.iow0.arr[96];
wire [63:0] Q_193 = ITOP.iow1.arr[96];
wire [63:0] Q_194 = ITOP.iow0.arr[97];
wire [63:0] Q_195 = ITOP.iow1.arr[97];
wire [63:0] Q_196 = ITOP.iow0.arr[98];
wire [63:0] Q_197 = ITOP.iow1.arr[98];
wire [63:0] Q_198 = ITOP.iow0.arr[99];
wire [63:0] Q_199 = ITOP.iow1.arr[99];
wire [63:0] Q_200 = ITOP.iow0.arr[100];
wire [63:0] Q_201 = ITOP.iow1.arr[100];
wire [63:0] Q_202 = ITOP.iow0.arr[101];
wire [63:0] Q_203 = ITOP.iow1.arr[101];
wire [63:0] Q_204 = ITOP.iow0.arr[102];
wire [63:0] Q_205 = ITOP.iow1.arr[102];
wire [63:0] Q_206 = ITOP.iow0.arr[103];
wire [63:0] Q_207 = ITOP.iow1.arr[103];
wire [63:0] Q_208 = ITOP.iow0.arr[104];
wire [63:0] Q_209 = ITOP.iow1.arr[104];
wire [63:0] Q_210 = ITOP.iow0.arr[105];
wire [63:0] Q_211 = ITOP.iow1.arr[105];
wire [63:0] Q_212 = ITOP.iow0.arr[106];
wire [63:0] Q_213 = ITOP.iow1.arr[106];
wire [63:0] Q_214 = ITOP.iow0.arr[107];
wire [63:0] Q_215 = ITOP.iow1.arr[107];
wire [63:0] Q_216 = ITOP.iow0.arr[108];
wire [63:0] Q_217 = ITOP.iow1.arr[108];
wire [63:0] Q_218 = ITOP.iow0.arr[109];
wire [63:0] Q_219 = ITOP.iow1.arr[109];
wire [63:0] Q_220 = ITOP.iow0.arr[110];
wire [63:0] Q_221 = ITOP.iow1.arr[110];
wire [63:0] Q_222 = ITOP.iow0.arr[111];
wire [63:0] Q_223 = ITOP.iow1.arr[111];
wire [63:0] Q_224 = ITOP.iow0.arr[112];
wire [63:0] Q_225 = ITOP.iow1.arr[112];
wire [63:0] Q_226 = ITOP.iow0.arr[113];
wire [63:0] Q_227 = ITOP.iow1.arr[113];
wire [63:0] Q_228 = ITOP.iow0.arr[114];
wire [63:0] Q_229 = ITOP.iow1.arr[114];
wire [63:0] Q_230 = ITOP.iow0.arr[115];
wire [63:0] Q_231 = ITOP.iow1.arr[115];
wire [63:0] Q_232 = ITOP.iow0.arr[116];
wire [63:0] Q_233 = ITOP.iow1.arr[116];
wire [63:0] Q_234 = ITOP.iow0.arr[117];
wire [63:0] Q_235 = ITOP.iow1.arr[117];
wire [63:0] Q_236 = ITOP.iow0.arr[118];
wire [63:0] Q_237 = ITOP.iow1.arr[118];
wire [63:0] Q_238 = ITOP.iow0.arr[119];
wire [63:0] Q_239 = ITOP.iow1.arr[119];
wire [63:0] Q_240 = ITOP.iow0.arr[120];
wire [63:0] Q_241 = ITOP.iow1.arr[120];
wire [63:0] Q_242 = ITOP.iow0.arr[121];
wire [63:0] Q_243 = ITOP.iow1.arr[121];
wire [63:0] Q_244 = ITOP.iow0.arr[122];
wire [63:0] Q_245 = ITOP.iow1.arr[122];
wire [63:0] Q_246 = ITOP.iow0.arr[123];
wire [63:0] Q_247 = ITOP.iow1.arr[123];
wire [63:0] Q_248 = ITOP.iow0.arr[124];
wire [63:0] Q_249 = ITOP.iow1.arr[124];
wire [63:0] Q_250 = ITOP.iow0.arr[125];
wire [63:0] Q_251 = ITOP.iow1.arr[125];
wire [63:0] Q_252 = ITOP.iow0.arr[126];
wire [63:0] Q_253 = ITOP.iow1.arr[126];
wire [63:0] Q_254 = ITOP.iow0.arr[127];
wire [63:0] Q_255 = ITOP.iow1.arr[127];
`endif //NV_RAM_EXPAND_ARRAY
`endif //SYNTHESIS

`ifdef FAULT_INJECTION
// BIST stuck at tasks
// induce faults on columns
//VCS coverage off    
task mem_fault_no_write;
input [63:0] fault_mask;
    begin
        ITOP.iow0.mem_fault_no_write_subbank(fault_mask);
        ITOP.iow1.mem_fault_no_write_subbank(fault_mask);
    end
endtask

task mem_fault_stuck_0;
input [63:0] fault_mask;
    begin
        ITOP.iow0.mem_fault_stuck_0_subbank(fault_mask);
        ITOP.iow1.mem_fault_stuck_0_subbank(fault_mask);
    end
endtask

task mem_fault_stuck_1;
input [63:0] fault_mask;
    begin
        ITOP.iow0.mem_fault_stuck_1_subbank(fault_mask);
        ITOP.iow1.mem_fault_stuck_1_subbank(fault_mask);
    end
endtask

task set_bit_fault_stuck_0;
input r;
input c;
integer r;
integer c;

  if ( (r % 2) == 0) 
    ITOP.iow0.set_bit_fault_stuck_0_subbank((r/2), c);
  else if  ( (r % 2) == 1)
    ITOP.iow1.set_bit_fault_stuck_0_subbank((r/2), c);

endtask

task set_bit_fault_stuck_1;
input r;
input c;
integer r;
integer c;
 
    if ( (r % 2) == 0) 
    ITOP.iow0.set_bit_fault_stuck_1_subbank((r/2), c);
  else if  ( (r % 2) == 1)
    ITOP.iow1.set_bit_fault_stuck_1_subbank((r/2), c);

endtask

task clear_bit_fault_stuck_0;
input r;
input c;
integer r;
integer c;

  if ( (r % 2) == 0) 
    ITOP.iow0.clear_bit_fault_stuck_0_subbank((r/2), c);
  else if  ( (r % 2) == 1)
    ITOP.iow1.clear_bit_fault_stuck_0_subbank((r/2), c);

endtask

task clear_bit_fault_stuck_1;
input r;
input c;
integer r;
integer c;

  if ( (r % 2) == 0) 
    ITOP.iow0.clear_bit_fault_stuck_1_subbank((r/2), c);
  else if  ( (r % 2) == 1)
    ITOP.iow1.clear_bit_fault_stuck_1_subbank((r/2), c);

endtask
//VCS coverage on    

`endif // STUCK
`else // EMULATION=1 
//VCS coverage off    
// The emulation model is a simple model which models only basic functionality and contains no test logic or redundancy.
// The model also uses flops wherever possible. Latches are avoided to help close timing on the emulator.
// The unused pins are left floating in the model.

// Register declarations
// enables 
    reg RE_FF,WE_FF,RE_LAT,WE_LAT;
// Addresses 
    reg [7:0] RAFF,WAFF;
// Data 
    reg [63:0] WD_FF;
    reg [63:0] RD_LAT;
 
// Latch the enables
//spyglass disable_block IntClock,W18 
    always @(*) begin 
        if (!CLK) begin
            RE_LAT <= RE; 
            WE_LAT <= WE; 
        end 
    end
//spyglass enable_block IntClock,W18 
            
// Flop the enables : RE/WE/RE_O
    always @(posedge CLK) begin
        RE_FF <= RE; //spyglass disable IntClock
        WE_FF <= WE; //spyglass disable IntClock
    end 

// Gated clock for the read/write operations 
    wire RECLK = CLK & RE_LAT; //spyglass disable GatedClock
    wire WECLK = CLK & WE_LAT; //spyglass disable GatedClock

// Flop the addresses/write data//mask 
    always @(posedge RECLK) 
        RAFF <= RA; //spyglass disable IntClock
    always @(posedge WECLK) begin 
        WAFF <= WA; //spyglass disable IntClock
        WD_FF <= WD; //spyglass disable IntClock
    end 



// Memory 
    reg [63:0] mem[255:0]; 

// write into the memory on negative edge of clock
   wire WRCLK = ~CLK & WE_FF ; //spyglass disable GatedClock
 
    always @(posedge WRCLK)
        mem[WAFF] <= WD_FF; //spyglass disable SYNTH_5130

// Read 
    wire [63:0] dout;
    assign dout = mem[RAFF]; //spyglass disable SYNTH_5130
    reg [63:0] dout_LAT;
    always @(RECLK or dout) 
        if (RECLK) 
            dout_LAT <= dout; //spyglass disable W18
    assign RD = dout_LAT;

`endif // EMULATION
//VCS coverage on    
`endif  // end RAM_INTERFACE
endmodule
`endcelldefine

`ifndef RAM_INTERFACE
`ifndef EMULATION

//memory bank block
module RAM_BANK_RAMPDP_256X64_GL_M2_D2 ( WE, CLK, IDDQ, SVOP, WD, RD, RE, RA, WA
, SLEEP_EN
, RET_EN , clobber_array , clobber_flops 
);

// Input/output port definitions
input  WE, CLK, IDDQ , RE;
input [7:0] SVOP;
input [63:0] WD;
input [7:0] RA, WA;
output [63:0] RD;
input [7:0] SLEEP_EN;

input RET_EN , clobber_array , clobber_flops ; 

// When there is no bypass requested, tie the internal bypass select to 0.
    wire RDBYP = 1'b0;
//Definitions of latches and flops in the design
// *_LAT --> Latched value
// *_LATB --> inverted latch value
// *_FF   --> Flopped version
	reg RE_LATB, RE_FF, WE_LATB, WE_FF;
	reg [7:0] RADR, WADR, WAFF;

    // For non-pipelined rams , capture_dis is disabled
    wire CAPT_DIS = 1'b0;

// Clamp the array access when IDDQ=1
	wire CLAMPB = ~IDDQ;
	wire latffclk = CLK;

// Latch and flop the primary control enables. This is on the unconditional clock.
// spyglass disable_block W18
	always @(*) begin
    // Latch part 
		if(!latffclk & !clobber_flops) begin
            RE_LATB     <= ~RE ;
            // Write Enable 
			WE_LATB     <= ~WE; // spyglass disable IntClock
		end // end if
	end // end always

	always @(*) begin
    // Flop part
		if (latffclk & !clobber_flops) begin
        // Flop outputs of the latches above
            WE_FF      <= ~WE_LATB;
			RE_FF      <= ~RE_LATB;
        end // end if
    end // end always
// spyglass enable_block W18
    
// Conditional clock generation.

// Write enable	and clock
// Clocks are generated when the write enable OR SE == 1 , but SHOLD == 0
    wire we_se   = ~WE_LATB;
	wire WRDCLK  = we_se & latffclk & !clobber_flops; // spyglass disable GatedClock
	wire WADRCLK = WRDCLK;

// Read enable and clock
// There is no SHOLD dependence on the read clocks because these are implemented using loopback flops
// Clocks are generated when the Read enable OR SE == 1
    wire re_se   = ~RE_LATB;
	wire RADRCLK =  re_se & latffclk ;

//  *** The model reads in A , writes in B ***
// Read clock to the memory is off the rising edge of clock
// CLk ==1 , when RE=1 or (SE=1 and SCRE=1) && (ACC_DIS == 1)
// SE=1 and SCRE=1 is needed to force known values into the latches for launch in testmodes.
	wire RECLK   = (~RE_LATB) & CLAMPB & !clobber_flops & !RET_EN & CLK;
// Writes are shifted to the low phase of the clock
// Flopped version of the enables are used to prevent glitches in the clock
// SCWI ==1 prevents writes into the memory
    wire WECLK   = WE_FF &  CLAMPB & !clobber_flops & !RET_EN & ~CLK;
	wire RWSEL   = WE_FF &  CLAMPB & ~CLK;



// Latch read addresses
// spyglass disable_block W18
	always @(*) begin
		if(!RADRCLK & !clobber_flops) begin
			RADR <= RA;
		end // end if
	end // end always


// Flop write address
	always @(posedge WADRCLK) begin
		WAFF <= WA ;
	end
// spyglass enable_block W18


// Force the MSB's to 0 in the SCRE mode. This makes sure that we will always read in from valid addresses for resetting the output latches.
	wire [7:0] RADRSWI = RADR[7:0];
// Select the read address when CLK=1 and write addresses when CLK=0
	wire [7:0] ADR = {8{RWSEL}} & WAFF | ~{8{RWSEL}} & RADRSWI;

	wire [7:0] fusePDEC2;
	wire [7:0] fusePDEC1;
	wire [7:0] fusePDEC0;
    wire fuseien;
// Non repairable rams
    assign fusePDEC2 = {8{1'b0}};
    assign fusePDEC1 = {8{1'b0}};
    assign fusePDEC0 = {8{1'b0}};
    assign fuseien = 0;

//io part
	wire [63:0] WDQ;
	wire [63:0] WDBQ;
	wire [63:0] WMNexp;
	wire [63:0] WMNQ;

// Expand the fuse predec to 512 bits . It follows the 8x8x8 repeat pattern
// We will use only the ones needed for this particular ram configuration and ignore the rest
	wire [511:0] PDEC2 = {{64{fusePDEC2[7]}}, {64{fusePDEC2[6]}}, {64{fusePDEC2[5]}}, {64{fusePDEC2[4]}}, {64{fusePDEC2[3]}}, {64{fusePDEC2[2]}}, {64{fusePDEC2[1]}}, {64{fusePDEC2[0]}}};
	wire [511:0] PDEC1 = {8{{8{fusePDEC1[7]}}, {8{fusePDEC1[6]}}, {8{fusePDEC1[5]}}, {8{fusePDEC1[4]}}, {8{fusePDEC1[3]}}, {8{fusePDEC1[2]}}, {8{fusePDEC1[1]}}, {8{fusePDEC1[0]}}}};
	wire [511:0] PDEC0 = {64{fusePDEC0[7:0]}};
	wire [63:0] BADBIT, SHFT;

// SHIFT<*> == 1 --> No repair at that bit , 0 --> repair at that bit .
// SHIFT<X> == not(and Pdec*<X>) & SHIFT<X-1>
    assign BADBIT = {64{1'b0}};
    assign SHFT   = {64{1'b1}};

    reg [63:0] WDQ_pr;
    wire [63:0] WDBQ_pr;

    assign WMNexp = {64{1'b1}};

    always @(posedge WRDCLK) begin
// Flop write data
		WDQ_pr[63:0]    <= WD & WMNexp;
	end

    assign WDBQ_pr = ~WDQ_pr;

    assign WMNQ = (WDQ | WDBQ);
	assign WDQ  = WDQ_pr;
	assign WDBQ = WDBQ_pr;

    reg [63:0] dout;
	wire [63:0] RD;
	wire RD_rdnt;

	wire [63:0] sel_normal, sel_redun;

// Read bypass is not used for non custom ram
	wire [63:0] RDBYPASS = {64{1'b0}};


// Read bypass will override redunancy mux .
	assign sel_redun  = ~SHFT & ~RDBYPASS;
	assign sel_normal =  SHFT & ~RDBYPASS;

// Non pipelined Read out. This is a 2 to 1 mux with bypass taking priority
	assign RD = sel_normal & dout | RDBYPASS & WDQ_pr;


// FOR SIMULATION ONLY. REMOVE WHEN ASSERTIONS ARE AVAILABLE!
// The following section figures out the unused address space and forces a X out on the reads/prevents writes
// #unusedbits 0 #lowcmidx 1 #cmstep 1 #cm 2 #maxaddr 256
    wire legal, tiedvalid, empadd;
    assign tiedvalid = 1'b1;

// Max address is 256 --> ['1', '1', '1', '1', '1', '1', '1', '1']
    assign empadd = 1'b0;
// It is a legal input address if it does not fall in the empty space.
    assign legal = tiedvalid & ~empadd ;
    
    wire [63:0] force_x;
`ifndef SYNTHESIS
    assign force_x = {64{1'bx}};
`else 
    assign force_x = {64{1'b0}};
`endif 

// Generate the read and write clocks for the various CM banks
    wire RdClk0,RdClk1;
    wire WrClk0,WrClk1;
    
    assign RdClk0 = RECLK & ~RADRSWI[0];
    assign RdClk1 = RECLK & RADRSWI[0];
    
    assign WrClk0 = WECLK & ~WAFF[0] & legal;
    assign WrClk1 = WECLK & WAFF[0] & legal;
    
    wire [63:0] rmuxd0, rmuxd1;
    wire [63:0] dout0, dout1;

// Mux the way reads onto the final read busa
// Output X's if the address is invalid
//    assign rmuxd0 = legal ? {64{RdClk0}} & ~dout0 : force_x;
//    assign rmuxd1 = legal ? {64{RdClk1}} & ~dout1 : force_x;
    assign rmuxd0 = {64{RdClk0}} & ~dout0 ;
    assign rmuxd1 = {64{RdClk1}} & ~dout1 ;
    always @(RECLK or rmuxd0 or rmuxd1)
    begin
        if (RECLK)
	    begin
            dout[63:0] <= (rmuxd0[63:0] | rmuxd1[63:0]); // spyglass disable W18 
        end
    end
// Instantiate the memory banks. One for each CM .
    RAMPDP_256X64_GL_M2_D2_ram # (128, 64, 7) iow0 (
		WAFF[7:1],
		WrClk0,
        WMNQ,
		WDQ,
		RADRSWI[7:1],
		dout0
	);

    RAMPDP_256X64_GL_M2_D2_ram # (128, 64, 7) iow1 (
		WAFF[7:1],
		WrClk1,
        WMNQ,
		WDQ,
		RADRSWI[7:1],
		dout1
	);

 
`ifndef SYNTHESIS 
// Tasks for initializing the arrays
// Ramgen function for writing the arrays 
//VCS coverage off    
task mem_write_bank;
  input [7:0] addr;
  input [63:0] data;
  reg   [63:0] wdat;
  begin
    wdat = data;
    if (addr[0] == 1'b0) 
        iow0.mem_wr_raw_subbank(addr[7:1], wdat);
    else if (addr[0] == 1'b1)
        iow1.mem_wr_raw_subbank(addr[7:1], wdat);
  end
endtask

// Ramgen function for reading the arrays 
function [63:0] mem_read_bank;
input [7:0] addr;
reg [63:0] memout;
  begin
    if (addr[0] == 1'b0) 
        memout = iow0.mem_read_raw_subbank(addr[7:1]);
    else if (addr[0] == 1'b1)
        memout = iow1.mem_read_raw_subbank(addr[7:1]);
    mem_read_bank = memout;
  end
endfunction
//VCS coverage on    

`endif  //SYNTHESIS

endmodule
`endif // end EMULATION
`endif // end RAM_INTERFACE 

`ifndef RAM_INTERFACE
`ifndef EMULATION
module RAMPDP_256X64_GL_M2_D2_ram (
   wadr,
   wrclk,
   wrmaskn,
   wrdata,
   radr,
   rout_B
);

// default parameters
parameter  words =  128;
parameter  bits  =  64;
parameter  addrs =  7;

// Write address
input  [addrs-1:0] wadr;
// Write clock
input  wrclk;
// Write data
input  [bits-1:0] wrdata;
// Write Mask
input  [bits-1:0] wrmaskn;

// Read address
input  [addrs-1:0] radr;
// Read out
wire   [bits-1:0]  rdarr;
output [bits-1:0] rout_B;


// Memory . words X bits
reg    [bits-1:0]  arr[0:words-1];

`ifdef SIM_and_FAULT
// regs for inducing faults
reg [bits-1:0] fault_no_write; // block writes to this column
reg [bits-1:0] fault_stuck_0;  // column always reads as 0
reg [bits-1:0] fault_stuck_1;  // column always reads as 1
reg [bits-1:0] bit_fault_stuck_0[0:words-1];  // column always reads as 0
reg [bits-1:0] bit_fault_stuck_1[0:words-1];  // column always reads as 1

initial begin : init_bit_fault_stuck
    integer i;
    integer j;
    fault_no_write = {bits{1'b0}};
    fault_stuck_0  = {bits{1'b0}};
    fault_stuck_1  = {bits{1'b0}};
    for ( i =0; i <=words; i=i+1) begin
        bit_fault_stuck_0[i] = {bits{1'b0}};
        bit_fault_stuck_1[i] = {bits{1'b0}};
    end
end
`endif // FAULT

`ifdef SIM_and_MONITOR
//VCS coverage off    
// monitor variables
reg monitor_on;
reg [words-1:0] word_written;
reg [words-1:0] word_read;
reg [bits-1:0] bit_written[0:words-1];
reg [bits-1:0] bit_read[0:words-1];

initial begin : init_monitor
  integer i;
  monitor_on = 1'b0; 
  for(i=0;i<= words-1;i=i+1) begin
      word_written[i] = 1'b0;
      word_read[i] = 1'b0;
      bit_written[i] = {bits{1'bx}};
      bit_read[i] = {bits{1'bx}};
  end
end  
`endif // MONITOR
//VCS coverage on    

// Bit write enable
// Write only when mask=1. Else hold the data.
`ifdef SIM_and_FAULT
// Include fault registers
wire [bits-1:0] bwe = wrmaskn & ~fault_no_write;
`else //SIM_and_FAULT
wire [bits-1:0] bwe = wrmaskn ;
`endif //SIM_and_FAULT
wire [bits-1:0] bitclk = {bits{wrclk}} & bwe ;

integer i;
`ifdef SIM_and_FAULT
always @(bitclk or wadr or wrdata)
`else 
always @(wrclk or wadr or wrdata)
`endif 
begin
`ifdef SIM_and_FAULT
    for (i=0 ; i<bits ; i=i+1) 
    begin
        if (bitclk[i])
            arr[wadr][i] <= wrdata[i]; // spyglass disable SYNTH_5130,W18
    end
`else 
    if (wrclk) 
        arr[wadr] <= wrdata; // spyglass disable SYNTH_5130,W18
`endif
`ifdef SIM_and_MONITOR
//VCS coverage off    
    for (i=0 ; i<bits ; i=i+1) 
    begin
`ifdef SIM_and_FAULT
        if (bitclk[i]) 
`else 
        if (wrclk)
`endif // FAULT
        begin
            // Check which bits are being written. Also track the values as per table below.
            // 1'bx = not accessed
            // 1'b0 = accessed as a 0
            // 1'b1 = accessed as a 1
            // 1'bz = accessed as both 0 and 1 
            if (monitor_on) begin 
				case (bit_written[wadr][i]) // spyglass disable SYNTH_5130,W18
					1'bx: bit_written[wadr][i] = wrdata[i];
					1'b0: bit_written[wadr][i] = wrdata[i] == 1 ? 1'bz : 1'b0;
					1'b1: bit_written[wadr][i] = wrdata[i] == 0 ? 1'bz : 1'b1;
					1'bz: bit_written[wadr][i] = 1'bz;
				endcase
            end
        end // if
    end //for
    if (monitor_on) begin 
    // Word is considered written if any of the bits are written
`ifdef SIM_and_FAULT
        word_written[wadr] <= |(bitclk) | word_written[wadr]; // spyglass disable SYNTH_5130,W18
`else 
        word_written[wadr] <= wrclk | word_written[wadr]; // spyglass disable SYNTH_5130,W18
`endif // FAULT
    end
`endif // MONITOR
//VCS coverage on    
end

`ifdef SIM_and_FAULT
// Include fault registers
wire [bits-1:0] bre = ~(bit_fault_stuck_1[radr] | bit_fault_stuck_0[radr]); // spyglass disable SYNTH_5130
`else //SIM_and_FAULT
wire [bits-1:0] bre = {bits{1'b1}};
`endif //SIM_and_FAULT

// Read the unlatched data out.
`ifdef SIM_and_FAULT
assign rdarr = (~arr[radr] | bit_fault_stuck_0[radr]) & ~bit_fault_stuck_1[radr]; // spyglass disable SYNTH_5130
`else 
assign rdarr = ~arr[radr]; // spyglass disable SYNTH_5130
`endif 

`ifdef SIM_and_MONITOR
//VCS coverage off    
always @radr begin
    // Check if a bit in the word can be read.
    // 1'bx = not accessed
    // 1'b0 = accessed as a 0
    // 1'b1 = accessed as a 1
    // 1'bz = accessed as both 0 and 1 
    if (monitor_on) begin
        for (i=0; i<bits; i=i+1) begin
	        if (bre[i]) begin
	            case (bit_read[radr][i])
				    1'bx: bit_read[radr][i] = rdarr[i];
					1'b0: bit_read[radr][i] = rdarr[i] == 1 ? 1'bz : 1'b0;
					1'b1: bit_read[radr][i] = rdarr[i] == 0 ? 1'bz : 1'b1;
					1'bz: bit_read[radr][i] = 1'bz;
		        endcase
	        end
	    end
    end 
    // Word is marked read only if any of the bits are read.
    word_read[radr] = |(bre);
end
//VCS coverage on    
`endif // MONITOR

`ifndef SYNTHESIS 
assign #0.1 rout_B = rdarr;
`else 
assign  rout_B = rdarr;
`endif

`ifndef SYNTHESIS
// Task for initializing the arrays

//VCS coverage off    
task mem_wr_raw_subbank;
  input [addrs-1:0] addr;
  input [63:0] data;
  begin
    arr[addr] = data;
  end
endtask

// function for array read
function [63:0] mem_read_raw_subbank;
input [addrs-1:0] addr;
	mem_read_raw_subbank = arr[addr];
endfunction

`ifdef FAULT_INJECTION
// BIST Tasks for inducing faults
// induce faults on columns
task mem_fault_no_write_subbank;
  input [bits-1:0] fault_mask;
   begin
    fault_no_write = fault_mask;
  end
endtask

// Stuck at 0 for entire memory
task mem_fault_stuck_0_subbank;
  input [bits-1:0] fault_mask;
  integer i;
   begin
    for ( i=0; i<words; i=i+1 ) begin
      bit_fault_stuck_0[i] = fault_mask;
    end
  end
endtask

// Stuck at 1 for entire memory
task mem_fault_stuck_1_subbank;
  input [bits-1:0] fault_mask;
  integer i;
   begin
    for ( i=0; i<words; i=i+1 ) begin
      bit_fault_stuck_1[i] = fault_mask;
    end
  end
endtask

// Stuck at 0 for specific bit
task set_bit_fault_stuck_0_subbank;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_0[r][c] = 1;
endtask

// Stuck at 1 for specific bit
task set_bit_fault_stuck_1_subbank;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_1[r][c] = 1;
endtask

// Clear stuck 0 at bit
task clear_bit_fault_stuck_0_subbank;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_0[r][c] = 0;
endtask

// Clear stuck 1 at bit
task clear_bit_fault_stuck_1_subbank;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_1[r][c] = 0;
endtask
//VCS coverage on    
`endif //STUCK
`endif //SYNTHESIS

endmodule
`endif // end EMULATION
`endif // end RAM_INTERFACE 

