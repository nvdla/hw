// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_BRDMA_lat_fifo.v

`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"
#if (NVDLA_MEMIF_WIDTH+NVDLA_DMA_MASK_BIT == 514)

module NV_NVDLA_SDP_BRDMA_lat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , lat_wr_prdy
    , lat_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , lat_wr_pause
`endif
    , lat_wr_pd
    , lat_rd_prdy
    , lat_rd_pvld
    , lat_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        lat_wr_prdy;
input         lat_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         lat_wr_pause;
`endif
input  [513:0] lat_wr_pd;
input         lat_rd_prdy;
output        lat_rd_pvld;
output [513:0] lat_rd_pd;
input  [31:0] pwrbus_ram_pd;

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
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        lat_wr_busy_int;		        	// copy for internal use
assign     lat_wr_prdy = !lat_wr_busy_int;
assign       wr_reserving = lat_wr_pvld && !lat_wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [7:0] lat_wr_count;			// write-side count

wire [7:0] wr_count_next_wr_popping = wr_reserving ? lat_wr_count : (lat_wr_count - 1'd1); // spyglass disable W164a W484
wire [7:0] wr_count_next_no_wr_popping = wr_reserving ? (lat_wr_count + 1'd1) : lat_wr_count; // spyglass disable W164a W484
wire [7:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_160 = ( wr_count_next_no_wr_popping == 8'd160 );
wire wr_count_next_is_160 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_160;
wire [7:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [7:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_160 || // busy next cycle?
                          (wr_limit_reg != 8'd0 &&      // check lat_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || lat_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_160 || // busy next cycle?
                          (wr_limit_reg != 8'd0 &&      // check lat_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_busy_int <=  1'b0;
        lat_wr_count <=  8'd0;
    end else begin
	lat_wr_busy_int <=  lat_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    lat_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            lat_wr_count <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as lat_wr_pvld

//
// RAM
//

reg  [7:0] lat_wr_adr;			// current write address
wire [7:0] lat_rd_adr_p;		// read address to use for ram
wire [513:0] lat_rd_pd_p;		// read data directly out of ram

wire rd_enable;

wire ore;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsp_160x514 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( lat_wr_adr )
    , .we        ( wr_pushing )
    , .di        ( lat_wr_pd )
    , .ra        ( lat_rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( lat_rd_pd_p )
    , .ore        ( ore )
    );
// next lat_wr_adr if wr_pushing=1
wire [7:0] wr_adr_next = (lat_wr_adr == 8'd159) ? 8'd0 : (lat_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_adr <=  8'd0;
    end else begin
        if ( wr_pushing ) begin
            lat_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            lat_wr_adr   <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [7:0] lat_rd_adr;		// current read address
// next    read address
wire [7:0] rd_adr_next = (lat_rd_adr == 8'd159) ? 8'd0 : (lat_rd_adr + 1'd1);   // spyglass disable W484
assign         lat_rd_adr_p = rd_popping ? rd_adr_next : lat_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_adr <=  8'd0;
    end else begin
        if ( rd_popping ) begin
	    lat_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            lat_rd_adr <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end
end
// spyglass enable_block W484

//
// SYNCHRONOUS BOUNDARY
//


always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_popping <=  1'b0;
    end else begin
	wr_popping <=  rd_popping;  
    end
end


reg    rd_pushing;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_pushing <=  1'b0;
    end else begin
	rd_pushing <=  wr_pushing;  // let data go into ram first
    end
end

//
// READ SIDE
//

reg        lat_rd_pvld_p; 		// data out of fifo is valid

reg        lat_rd_pvld_int;			// internal copy of lat_rd_pvld
assign     lat_rd_pvld = lat_rd_pvld_int;
assign     rd_popping = lat_rd_pvld_p && !(lat_rd_pvld_int && !lat_rd_prdy);

reg  [7:0] lat_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [7:0] rd_count_p_next_rd_popping = rd_pushing ? lat_rd_count_p : 
                                                                (lat_rd_count_p - 1'd1);
wire [7:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (lat_rd_count_p + 1'd1) : 
                                                                    lat_rd_count_p;
// spyglass enable_block W164a W484
wire [7:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~lat_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_count_p <=  8'd0;
        lat_rd_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_count_p <=  {8{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (lat_rd_pvld_p || (lat_rd_pvld_int && !lat_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_pvld_int <=  1'b0;
    end else begin
        lat_rd_pvld_int <=  rd_req_next;
    end
end
assign lat_rd_pd = lat_rd_pd_p;
assign ore = rd_popping;

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

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (lat_wr_pvld && !lat_wr_busy_int) || (lat_wr_busy_int != lat_wr_busy_next)) || (rd_pushing || rd_popping || (lat_rd_pvld_int && lat_rd_prdy) || wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_lat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_lat_fifo_wr_limit : 8'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 8'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 8'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 8'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [7:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 8'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( lat_wr_pvld && !(!lat_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst0(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst1(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


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
      .clk	( nvdla_core_clk ) 
    , .max      ( {24'd0, (wr_limit_reg == 8'd0) ? 8'd160 : wr_limit_reg} )
    , .curr	( {24'd0, lat_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_BRDMA_lat_fifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_SDP_BRDMA_lat_fifo


#elif (NVDLA_MEMIF_WIDTH+NVDLA_DMA_MASK_BIT == 65)


module NV_NVDLA_SDP_BRDMA_lat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , lat_wr_prdy
    , lat_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , lat_wr_pause
`endif
    , lat_wr_pd
    , lat_rd_prdy
    , lat_rd_pvld
    , lat_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        lat_wr_prdy;
input         lat_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         lat_wr_pause;
`endif
input  [64:0] lat_wr_pd;
input         lat_rd_prdy;
output        lat_rd_pvld;
output [64:0] lat_rd_pd;
input  [31:0] pwrbus_ram_pd;

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
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        lat_wr_busy_int;		        	// copy for internal use
assign     lat_wr_prdy = !lat_wr_busy_int;
assign       wr_reserving = lat_wr_pvld && !lat_wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [7:0] lat_wr_count;			// write-side count

wire [7:0] wr_count_next_wr_popping = wr_reserving ? lat_wr_count : (lat_wr_count - 1'd1); // spyglass disable W164a W484
wire [7:0] wr_count_next_no_wr_popping = wr_reserving ? (lat_wr_count + 1'd1) : lat_wr_count; // spyglass disable W164a W484
wire [7:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_160 = ( wr_count_next_no_wr_popping == 8'd160 );
wire wr_count_next_is_160 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_160;
wire [7:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [7:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_160 || // busy next cycle?
                          (wr_limit_reg != 8'd0 &&      // check lat_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || lat_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_160 || // busy next cycle?
                          (wr_limit_reg != 8'd0 &&      // check lat_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_busy_int <=  1'b0;
        lat_wr_count <=  8'd0;
    end else begin
	lat_wr_busy_int <=  lat_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    lat_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            lat_wr_count <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as lat_wr_pvld

//
// RAM
//

reg  [7:0] lat_wr_adr;			// current write address
wire [7:0] lat_rd_adr_p;		// read address to use for ram
wire [64:0] lat_rd_pd_p;		// read data directly out of ram

wire rd_enable;

wire ore;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsp_160x65 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( lat_wr_adr )
    , .we        ( wr_pushing )
    , .di        ( lat_wr_pd )
    , .ra        ( lat_rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( lat_rd_pd_p )
    , .ore        ( ore )
    );
// next lat_wr_adr if wr_pushing=1
wire [7:0] wr_adr_next = (lat_wr_adr == 8'd159) ? 8'd0 : (lat_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_adr <=  8'd0;
    end else begin
        if ( wr_pushing ) begin
            lat_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            lat_wr_adr   <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [7:0] lat_rd_adr;		// current read address
// next    read address
wire [7:0] rd_adr_next = (lat_rd_adr == 8'd159) ? 8'd0 : (lat_rd_adr + 1'd1);   // spyglass disable W484
assign         lat_rd_adr_p = rd_popping ? rd_adr_next : lat_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_adr <=  8'd0;
    end else begin
        if ( rd_popping ) begin
	    lat_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            lat_rd_adr <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end
end
// spyglass enable_block W484

//
// SYNCHRONOUS BOUNDARY
//


always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_popping <=  1'b0;
    end else begin
	wr_popping <=  rd_popping;  
    end
end


reg    rd_pushing;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_pushing <=  1'b0;
    end else begin
	rd_pushing <=  wr_pushing;  // let data go into ram first
    end
end

//
// READ SIDE
//

reg        lat_rd_pvld_p; 		// data out of fifo is valid

reg        lat_rd_pvld_int;			// internal copy of lat_rd_pvld
assign     lat_rd_pvld = lat_rd_pvld_int;
assign     rd_popping = lat_rd_pvld_p && !(lat_rd_pvld_int && !lat_rd_prdy);

reg  [7:0] lat_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [7:0] rd_count_p_next_rd_popping = rd_pushing ? lat_rd_count_p : 
                                                                (lat_rd_count_p - 1'd1);
wire [7:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (lat_rd_count_p + 1'd1) : 
                                                                    lat_rd_count_p;
// spyglass enable_block W164a W484
wire [7:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~lat_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_count_p <=  8'd0;
        lat_rd_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_count_p <=  {8{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (lat_rd_pvld_p || (lat_rd_pvld_int && !lat_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_pvld_int <=  1'b0;
    end else begin
        lat_rd_pvld_int <=  rd_req_next;
    end
end
assign lat_rd_pd = lat_rd_pd_p;
assign ore = rd_popping;

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

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (lat_wr_pvld && !lat_wr_busy_int) || (lat_wr_busy_int != lat_wr_busy_next)) || (rd_pushing || rd_popping || (lat_rd_pvld_int && lat_rd_prdy) || wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_lat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_lat_fifo_wr_limit : 8'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 8'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 8'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 8'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [7:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 8'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_lat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( lat_wr_pvld && !(!lat_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst6(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst7(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


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
      .clk	( nvdla_core_clk ) 
    , .max      ( {24'd0, (wr_limit_reg == 8'd0) ? 8'd160 : wr_limit_reg} )
    , .curr	( {24'd0, lat_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_BRDMA_lat_fifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed6;
reg prand_initialized6;
reg prand_no_rollpli6;
`endif
`endif
`endif

function [31:0] prand_inst6;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst6 = min;
`else
`ifdef SYNTHESIS
        prand_inst6 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized6 !== 1'b1) begin
            prand_no_rollpli6 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli6)
                prand_local_seed6 = {$prand_get_seed(6), 16'b0};
            prand_initialized6 = 1'b1;
        end
        if (prand_no_rollpli6) begin
            prand_inst6 = min;
        end else begin
            diff = max - min + 1;
            prand_inst6 = min + prand_local_seed6[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed6 = prand_local_seed6 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst6 = min;
`else
        prand_inst6 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed7;
reg prand_initialized7;
reg prand_no_rollpli7;
`endif
`endif
`endif

function [31:0] prand_inst7;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst7 = min;
`else
`ifdef SYNTHESIS
        prand_inst7 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized7 !== 1'b1) begin
            prand_no_rollpli7 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli7)
                prand_local_seed7 = {$prand_get_seed(7), 16'b0};
            prand_initialized7 = 1'b1;
        end
        if (prand_no_rollpli7) begin
            prand_inst7 = min;
        end else begin
            diff = max - min + 1;
            prand_inst7 = min + prand_local_seed7[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed7 = prand_local_seed7 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst7 = min;
`else
        prand_inst7 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_SDP_BRDMA_lat_fifo
 





#endif
