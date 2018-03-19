// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CSB_MASTER_csb2falcon_fifo.v

`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"
module NV_NVDLA_CSB_MASTER_csb2falcon_fifo (
      wr_clk
    , wr_reset_
    , wr_ready
    , wr_req
    , wr_data
    , rd_clk
    , rd_reset_
    , rd_ready
    , rd_req
    , rd_data
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         wr_clk;
input         wr_reset_;
output        wr_ready;
input         wr_req;
input  [33:0] wr_data;
input         rd_clk;
input         rd_reset_;
input         rd_ready;
output        rd_req;
output [33:0] rd_data;
input  [31:0] pwrbus_ram_pd;

//
// DFT clock gate enable qualifier
//

// Write side
wire dft_qualifier_wr_enable;
oneHotClk_async_write_clock fifogenDFTWrQual ( .enable_w( dft_qualifier_wr_enable ) );

wire wr_clk_dft_mgated;

NV_CLK_gate_power wr_clk_wr_dft_mgate( .clk(wr_clk), .reset_(wr_reset_), .clk_en(dft_qualifier_wr_enable), .clk_gated(wr_clk_dft_mgated) );

`ifndef FPGA
// Add a dummy sink to prevent issue related to no fanout on this clock gate
NV_BLKBOX_SINK UJ_BLKBOX_UNUSED_FIFOGEN_dft_wr_clkgate_sink (.A( wr_clk_dft_mgated ) );
`endif

// Read side
wire dft_qualifier_rd_enable;
oneHotClk_async_read_clock fifogenDFTRdQual ( .enable_r( dft_qualifier_rd_enable ) );

wire rd_clk_dft_mgated;

NV_CLK_gate_power rd_clk_rd_dft_mgate( .clk(rd_clk), .reset_(rd_reset_), .clk_en(dft_qualifier_rd_enable), .clk_gated(rd_clk_dft_mgated) );

`ifndef FPGA
// Add a dummy sink to prevent issue related to no fanout on this clock gate
NV_BLKBOX_SINK UJ_BLKBOX_UNUSED_FIFOGEN_dft_rd_clkgate_sink (.A( rd_clk_dft_mgated ) );
`endif

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire wr_clk_wr_mgated_enable;   // assigned by code at end of this module
wire wr_clk_wr_mgated;
NV_CLK_gate_power wr_clk_wr_mgate( .clk(wr_clk), .reset_(wr_reset_), .clk_en(wr_clk_wr_mgated_enable), .clk_gated(wr_clk_wr_mgated) );
wire rd_clk_rd_mgated_enable;   // assigned by code at end of this module
wire rd_clk_rd_mgated;
NV_CLK_gate_power rd_clk_rd_mgate( .clk(rd_clk), .reset_(rd_reset_), .clk_en(rd_clk_rd_mgated_enable), .clk_gated(rd_clk_rd_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        wr_req_in;                                // registered wr_req
reg        wr_busy_in;                              // inputs being held this cycle?
assign     wr_ready = !wr_busy_in;
wire       wr_busy_next;                           // fwd: fifo busy next?

// factor for better timing with distant wr_req signal
wire       wr_busy_in_next_wr_req_eq_1 = wr_busy_next;
wire       wr_busy_in_next_wr_req_eq_0 = (wr_req_in && wr_busy_next) && !wr_reserving;
wire       wr_busy_in_next = (wr_req? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                               ;
wire       wr_busy_in_int;
always @( posedge wr_clk_dft_mgated or negedge wr_reset_ ) begin
    if ( !wr_reset_ ) begin
        wr_req_in <=  1'b0;
        wr_busy_in <=  1'b0;
    end else begin
        wr_busy_in <=  wr_busy_in_next;
        if ( !wr_busy_in_int ) begin
            wr_req_in  <=  wr_req && !wr_busy_in;
        end
        //synopsys translate_off
            else if ( wr_busy_in_int ) begin
        end else begin
            wr_req_in  <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

reg        wr_busy_int;		        	// copy for internal use
assign       wr_reserving = wr_req_in && !wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? wr_count : (wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (wr_count + 1'd1) : wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_2 = ( wr_count_next_no_wr_popping == 2'd2 );
wire wr_count_next_is_2 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_2;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
assign     wr_busy_next = wr_count_next_is_2 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
assign     wr_busy_in_int = wr_req_in && wr_busy_int;
always @( posedge wr_clk_wr_mgated or negedge wr_reset_ ) begin
    if ( !wr_reset_ ) begin
        wr_busy_int <=  1'b0;
        wr_count <=  2'd0;
    end else begin
	wr_busy_int <=  wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as wr_req_in

//
// RAM
//

reg   wr_adr;			// current write address

// spyglass disable_block W484
// next wr_adr if wr_pushing=1
wire  wr_adr_next = wr_adr + 1'd1;  // spyglass disable W484
always @( posedge wr_clk_wr_mgated or negedge wr_reset_ ) begin
    if ( !wr_reset_ ) begin
        wr_adr <=  1'd0;
    end else begin
        if ( wr_pushing ) begin
            wr_adr <=  wr_adr_next;
        end
    end
end
// spyglass enable_block W484


reg  rd_adr;          // read address this cycle
wire ram_we = wr_pushing;   // note: write occurs next cycle
wire ram_iwe = !wr_busy_in && wr_req;  
wire [33:0] rd_data_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CSB_MASTER_csb2falcon_fifo_flopram_rwa_2x34 ram (
      .clk( wr_clk_dft_mgated )
    , .clk_mgated( wr_clk_wr_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( wr_data )
    , .iwe        ( ram_iwe )
    , .we        ( ram_we )
    , .wa        ( wr_adr )
    , .ra        ( rd_adr )
    , .dout        ( rd_data_p )
    );

wire   rd_popping;              // read side doing pop this cycle?

wire [0:0] rd_adr_next_popping = rd_adr + 1'd1; // spyglass disable W484
always @( posedge rd_clk_rd_mgated or negedge rd_reset_ ) begin
    if ( !rd_reset_ ) begin
        rd_adr <=  1'd0;
    end else begin
        if ( rd_popping ) begin
	    rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            rd_adr <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// ASYNCHRONOUS BOUNDARY USING TRADITIONAL SYNCHRONIZERS
//
// Our goal here is to translate wr_pushing pulses into rd_pushing
// pulses on the read side and, conversely, to translate rd_popping
// pulses to wr_popping pulses on the write side.
//
// We don't try to optimize the case where the async fifo depth is
// a power of two.  We handle the general case using one scheme to
// avoid maintaining different implementations.  We may use a couple
// more counters, but they are quite cheap in the grand scheme of things.
// This wr_pushing/rd_pushing/rd_popping/wr_popping centric scheme also
// fits in well with the case where there is no asynchronous boundary.
//
// The scheme works as follows.  For the wr_pushing -> rd_pushing translation,
// we keep an 2-bit gray counter on the write and read sides.
// This counter is initialized to 0 on both sides.   When wr_pushing
// is pulsed, the write side gray-increments its counter, registers it,
// then sends it through an 2-bit synchronizer to the other side.
// Whenever the read side sees the new gray counter not equal to its
// copy of the gray counter, it gray-increments its counter and pulses
// rd_pushing=1.  The actual value of the gray counter is irrelevant.
// It must be a power-of-2 to make the gray code work.  Otherwise,
// we're just looking for changes in the gray value.
//
// The same technique is used for the rd_popping -> wr_popping translation.
//
// The gray counter algorithm uses a 1-bit polarity register that starts
// off as 0 and is inverted whenever the gray counter is incremented.
//
// In plain English, the next gray counter is determined as follows:
// if the current polarity register is 0, invert bit 0 (the lsb); otherwise,
// find the rightmost one bit and invert the bit to the left of the one bit
// if the one bit is not the msb else invert the msb one bit.  The
// general expression is thus:
//
// { gray[n-1] ^ (polarity             & ~gray[n-3] & ~gray[n-4] & ... ),
//   gray[n-2] ^ (polarity & gray[n-3] & ~gray[n-4] & ~gray[n-5] & ... ),
//   gray[n-3] ^ (polarity & gray[n-4] & ~gray[n-5] & ~gray[n-6] & ... ),
//   ...
//   gray[0]   ^ (~polarity) }
//
// For n == 1, the next gray value is obviously just ~gray.
//
// The wr_pushing/rd_popping signal does not affect the registered
// gray counter until the next cycle.  However, for non-FF-type rams,
// the write will not complete until the end of the next cycle, so
// we must delay wr_pushing yet another more cycle,
// unless the -rd_clk_le_2x_wr_clk option was given
// (or the -rd_clk_le_2x_wr_clk_dynamic option was given
// and the rd_clk_le_2x_wr_clk signal is 1).
//




// clk gating of strict synchronizers
//

wire wr_clk_wr_mgated_strict_snd_gated;
NV_CLK_gate_power wr_clk_wr_mgated_snd_gate( .clk(wr_clk), .reset_(wr_reset_), .clk_en(dft_qualifier_wr_enable && (wr_pushing)), .clk_gated(wr_clk_wr_mgated_strict_snd_gated) ); 

//
// wr_pushing -> rd_pushing translation
//
wire [1:0]	wr_pushing_gray_cntr;
wire [1:0]	wr_pushing_gray_cntr_next;

NV_NVDLA_CSB_MASTER_csb2falcon_fifo_gray_cntr_strict wr_pushing_gray (  
`ifdef NV_FPGA_FIFOGEN
      .inc		( wr_pushing ) ,
`endif
      .gray		( wr_pushing_gray_cntr )
    , .gray_next        ( wr_pushing_gray_cntr_next )
    );
wire [1:0] wr_pushing_gray_cntr_sync; 

p_STRICTSYNC3DOTM_C_PPP NV_AFIFO_wr_pushing_sync0 (
      .SRC_CLK          ( wr_clk_wr_mgated_strict_snd_gated )
    , .SRC_CLRN         ( wr_reset_ )
    , .SRC_D_NEXT	( wr_pushing_gray_cntr_next[0] )
    , .SRC_D		( wr_pushing_gray_cntr[0] )
    , .DST_CLK		( rd_clk_dft_mgated )
    , .DST_CLRN  	( rd_reset_ )
    , .DST_Q		( wr_pushing_gray_cntr_sync[0] )
    , .ATPG_CTL         ( 1'b0 )
    , .TEST_MODE        ( 1'b0 )
    );
p_STRICTSYNC3DOTM_C_PPP NV_AFIFO_wr_pushing_sync1 (
      .SRC_CLK          ( wr_clk_wr_mgated_strict_snd_gated )
    , .SRC_CLRN         ( wr_reset_ )
    , .SRC_D_NEXT	( wr_pushing_gray_cntr_next[1] )
    , .SRC_D		( wr_pushing_gray_cntr[1] )
    , .DST_CLK		( rd_clk_dft_mgated )
    , .DST_CLRN  	( rd_reset_ )
    , .DST_Q		( wr_pushing_gray_cntr_sync[1] )
    , .ATPG_CTL         ( 1'b0 )
    , .TEST_MODE        ( 1'b0 )
    );

wire [1:0] rd_pushing_gray_cntr;
wire    rd_pushing =  wr_pushing_gray_cntr_sync != rd_pushing_gray_cntr;

NV_NVDLA_CSB_MASTER_csb2falcon_fifo_gray_cntr rd_pushing_gray (  
      .clk		( rd_clk_rd_mgated )
    , .reset_		( rd_reset_ )
    , .inc		( rd_pushing )
    , .gray	( rd_pushing_gray_cntr )
    );







// clk gating of strict synchronizers
//

wire rd_clk_rd_mgated_strict_snd_gated;
NV_CLK_gate_power rd_clk_rd_mgated_snd_gate( .clk(rd_clk), .reset_(rd_reset_), .clk_en(dft_qualifier_rd_enable && (rd_popping)), .clk_gated(rd_clk_rd_mgated_strict_snd_gated) ); 
wire wr_clk_strict_rcv_gated;
NV_CLK_gate_power wr_clk_rcv_gate( .clk(wr_clk), .reset_(wr_reset_), .clk_en(dft_qualifier_wr_enable && (wr_count_next_no_wr_popping != 2'd0)), .clk_gated(wr_clk_strict_rcv_gated) ); 

//
// rd_popping -> wr_popping translation
//
wire [1:0]	rd_popping_gray_cntr;
wire [1:0]	rd_popping_gray_cntr_next;

NV_NVDLA_CSB_MASTER_csb2falcon_fifo_gray_cntr_strict rd_popping_gray (  
`ifdef NV_FPGA_FIFOGEN
      .inc		( rd_popping ) ,
`endif
      .gray		( rd_popping_gray_cntr )
    , .gray_next        ( rd_popping_gray_cntr_next )
    );
wire [1:0] rd_popping_gray_cntr_sync; 

p_STRICTSYNC3DOTM_C_PPP NV_AFIFO_rd_popping_sync0 (
      .SRC_CLK          ( rd_clk_rd_mgated_strict_snd_gated )
    , .SRC_CLRN         ( rd_reset_ )
    , .SRC_D_NEXT	( rd_popping_gray_cntr_next[0] )
    , .SRC_D		( rd_popping_gray_cntr[0] )
    , .DST_CLK		( wr_clk_strict_rcv_gated )
    , .DST_CLRN  	( wr_reset_ )
    , .DST_Q		( rd_popping_gray_cntr_sync[0] )
    , .ATPG_CTL         ( 1'b0 )
    , .TEST_MODE        ( 1'b0 )
    );
p_STRICTSYNC3DOTM_C_PPP NV_AFIFO_rd_popping_sync1 (
      .SRC_CLK          ( rd_clk_rd_mgated_strict_snd_gated )
    , .SRC_CLRN         ( rd_reset_ )
    , .SRC_D_NEXT	( rd_popping_gray_cntr_next[1] )
    , .SRC_D		( rd_popping_gray_cntr[1] )
    , .DST_CLK		( wr_clk_strict_rcv_gated )
    , .DST_CLRN  	( wr_reset_ )
    , .DST_Q		( rd_popping_gray_cntr_sync[1] )
    , .ATPG_CTL         ( 1'b0 )
    , .TEST_MODE        ( 1'b0 )
    );

wire [1:0] wr_popping_gray_cntr;
assign    wr_popping =  rd_popping_gray_cntr_sync != wr_popping_gray_cntr;

NV_NVDLA_CSB_MASTER_csb2falcon_fifo_gray_cntr wr_popping_gray (  
      .clk		( wr_clk_wr_mgated )
    , .reset_		( wr_reset_ )
    , .inc		( wr_popping )
    , .gray	( wr_popping_gray_cntr )
    );




//
// READ SIDE
//

wire       rd_req_p; 		// data out of fifo is valid

reg        rd_req_int;	// internal copy of rd_req
assign     rd_req = rd_req_int;
assign     rd_popping = rd_req_p && !(rd_req_int && !rd_ready);

reg  [1:0] rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? rd_count_p : 
                                                                (rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (rd_count_p + 1'd1) : 
                                                                    rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     rd_req_p = rd_count_p != 0 || rd_pushing;
always @( posedge rd_clk_rd_mgated or negedge rd_reset_ ) begin
    if ( !rd_reset_ ) begin
        rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [33:0]  NV_AFIFO_rd_data;         // output data register
wire        rd_req_next = (rd_req_p || (rd_req_int && !rd_ready)) ;

always @( posedge rd_clk_rd_mgated or negedge rd_reset_ ) begin
    if ( !rd_reset_ ) begin
        rd_req_int <=  1'b0;
    end else begin
        rd_req_int <=  rd_req_next;
    end
end
always @( posedge rd_clk_rd_mgated ) begin
    if ( (rd_popping) ) begin
        NV_AFIFO_rd_data <=  rd_data_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        NV_AFIFO_rd_data <=  {34{`x_or_0}};
    end
    //synopsys translate_on

end

assign rd_data = NV_AFIFO_rd_data;


// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on
assign wr_clk_wr_mgated_enable = dft_qualifier_wr_enable && (wr_reserving || wr_pushing || wr_popping || wr_popping || (wr_req_in && !wr_busy_int) || (wr_busy_int != wr_busy_next))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;
assign rd_clk_rd_mgated_enable = dft_qualifier_rd_enable && ((rd_pushing || rd_popping || (rd_req_int && rd_ready)))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CSB_MASTER_csb2falcon_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CSB_MASTER_csb2falcon_fifo_wr_limit : 2'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 2'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 2'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 2'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [1:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 2'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_CSB_MASTER_csb2falcon_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CSB_MASTER_csb2falcon_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif

//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( wr_clk ) 
    , .max      ( {30'd0, (wr_limit_reg == 2'd0) ? 2'd2 : wr_limit_reg} )
    , .curr	( {30'd0, wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_CSB_MASTER_csb2falcon_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_CSB_MASTER_csb2falcon_fifo

// 
// Flop-Based RAM (with internal wr_reg)
//
module NV_NVDLA_CSB_MASTER_csb2falcon_fifo_flopram_rwa_2x34 (
      clk
    , clk_mgated
    , pwrbus_ram_pd
    , di
    , iwe
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input  clk_mgated;  // write clock mgated
input [31 : 0] pwrbus_ram_pd;
input  [33:0] di;
input  iwe;
input  we;
input  [0:0] wa;
input  [0:0] ra;
output [33:0] dout;

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
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
`endif

reg [33:0] di_d;  // -wr_reg

always @( posedge clk ) begin
    if ( iwe ) begin
        di_d <=  di; // -wr_reg
    end
end

`ifdef EMU


// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [0:0] Wa0_vmw;
reg we0_vmw;
reg [33:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di_d;
end

vmw_NV_NVDLA_CSB_MASTER_csb2falcon_fifo_flopram_rwa_2x34 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout )
   );

`else

reg [33:0] ram_ff0;
reg [33:0] ram_ff1;

always @( posedge clk_mgated ) begin
    if ( we && wa == 1'd0 ) begin
	ram_ff0 <=  di_d;
    end
    if ( we && wa == 1'd1 ) begin
	ram_ff1 <=  di_d;
    end
end

reg [33:0] dout;

always @(*) begin
    case( ra ) // synopsys infer_mux_override
    1'd0:       dout = ram_ff0;
    1'd1:       dout = ram_ff1;
    //VCS coverage off
    default:    dout = {34{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CSB_MASTER_csb2falcon_fifo_flopram_rwa_2x34

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CSB_MASTER_csb2falcon_fifo_flopram_rwa_2x34 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [0:0] Wa0;
input            we0;
input  [33:0] Di0;
input  [0:0] Ra0;
output [33:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 34'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [33:0] mem[1:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [33:0] Q0 = mem[0];
wire [33:0] Q1 = mem[1];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CSB_MASTER_csb2falcon_fifo_flopram_rwa_2x34] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CSB_MASTER_csb2falcon_fifo_flopram_rwa_2x34] }
endmodule // vmw_NV_NVDLA_CSB_MASTER_csb2falcon_fifo_flopram_rwa_2x34

//vmw: Memory vmw_NV_NVDLA_CSB_MASTER_csb2falcon_fifo_flopram_rwa_2x34
//vmw: Address-size 1
//vmw: Data-size 34
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[33:0] data0[33:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[33:0] data1[33:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CSB_MASTER_csb2falcon_fifo_flopram_rwa_2x34
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU


//
// See the ASYNCHONROUS BOUNDARY section above for details on the
// gray counter implementation.
//

module NV_NVDLA_CSB_MASTER_csb2falcon_fifo_gray_cntr_strict (
`ifdef NV_FPGA_FIFOGEN
      inc ,
`endif
      gray
    , gray_next
    );

`ifdef NV_FPGA_FIFOGEN
input 			inc;
`endif
input  [1:0]		gray;
output [1:0]                gray_next;


wire			polarity;  // polarity of gray counter bits

assign polarity = gray[0] ^ gray[1];

assign gray_next = 
`ifdef NV_FPGA_FIFOGEN
 (~inc) ? gray : 
`endif 
                         { gray[1]^(polarity           ),
                         gray[0]^(~polarity) };

endmodule // NV_NVDLA_CSB_MASTER_csb2falcon_fifo_gray_cntr_strict

module NV_NVDLA_CSB_MASTER_csb2falcon_fifo_gray_cntr (
      clk
    , reset_
    , inc
    , gray
    );

input			clk;
input			reset_;
input 			inc;
output [1:0]		gray;

reg    [1:0]		gray;   // gray counter


wire			polarity;  // polarity of gray counter bits

assign polarity = gray[0] ^ gray[1];

  always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
	gray     <=  2'd0;
    end else if ( inc ) begin
        gray     <=  { gray[1]^(polarity           ),
                         gray[0]^(~polarity) };
    end
end

endmodule // NV_NVDLA_CSB_MASTER_csb2falcon_fifo_gray_cntr

