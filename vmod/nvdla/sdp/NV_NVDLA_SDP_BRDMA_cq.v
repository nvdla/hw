// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_BRDMA_cq.v

`include "simulate_x_tick.vh"
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_BRDMA_cq (
      nvdla_core_clk
    , nvdla_core_rstn
    , ig2cq_prdy
    , ig2cq_pvld
    , ig2cq_pd
    , cq2eg_prdy
    , cq2eg_pvld
    , cq2eg_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        ig2cq_prdy;
input         ig2cq_pvld;
input  [15:0] ig2cq_pd;
input         cq2eg_prdy;
output        cq2eg_pvld;
output [15:0] cq2eg_pd;
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
wire wr_reserving;
reg        ig2cq_busy_int;		        	// copy for internal use
assign     ig2cq_prdy = !ig2cq_busy_int;
assign       wr_reserving = ig2cq_pvld && !ig2cq_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [7:0] ig2cq_count;			// write-side count

wire [7:0] wr_count_next_wr_popping = wr_reserving ? ig2cq_count : (ig2cq_count - 1'd1); // spyglass disable W164a W484
wire [7:0] wr_count_next_no_wr_popping = wr_reserving ? (ig2cq_count + 1'd1) : ig2cq_count; // spyglass disable W164a W484
wire [7:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_160 = ( wr_count_next_no_wr_popping == 8'd160 );
wire wr_count_next_is_160 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_160;
wire [7:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [7:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       ig2cq_busy_next = wr_count_next_is_160 || // busy next cycle?
                          (wr_limit_reg != 8'd0 &&      // check ig2cq_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ig2cq_busy_int <=  1'b0;
        ig2cq_count <=  8'd0;
    end else begin
	ig2cq_busy_int <=  ig2cq_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    ig2cq_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            ig2cq_count <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as ig2cq_pvld

//
// RAM
//

reg  [7:0] ig2cq_adr;			// current write address
wire [7:0] cq2eg_adr_p;		// read address to use for ram
wire [15:0] cq2eg_pd_p;		// read data directly out of ram

wire rd_enable;

wire ore;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsp_160x16 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( ig2cq_adr )
    , .we        ( wr_pushing )
    , .di        ( ig2cq_pd )
    , .ra        ( cq2eg_adr_p )
    , .re        ( rd_enable )
    , .dout        ( cq2eg_pd_p )
    , .ore        ( ore )
    );
// next ig2cq_adr if wr_pushing=1
wire [7:0] wr_adr_next = (ig2cq_adr == 8'd159) ? 8'd0 : (ig2cq_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ig2cq_adr <=  8'd0;
    end else begin
        if ( wr_pushing ) begin
            ig2cq_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            ig2cq_adr   <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [7:0] cq2eg_adr;		// current read address
// next    read address
wire [7:0] rd_adr_next = (cq2eg_adr == 8'd159) ? 8'd0 : (cq2eg_adr + 1'd1);   // spyglass disable W484
assign         cq2eg_adr_p = rd_popping ? rd_adr_next : cq2eg_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq2eg_adr <=  8'd0;
    end else begin
        if ( rd_popping ) begin
	    cq2eg_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            cq2eg_adr <=  {8{`x_or_0}};
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

reg        cq2eg_pvld_p; 		// data out of fifo is valid

reg        cq2eg_pvld_int;			// internal copy of cq2eg_pvld
assign     cq2eg_pvld = cq2eg_pvld_int;
assign     rd_popping = cq2eg_pvld_p && !(cq2eg_pvld_int && !cq2eg_prdy);

reg  [7:0] cq2eg_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [7:0] rd_count_p_next_rd_popping = rd_pushing ? cq2eg_count_p : 
                                                                (cq2eg_count_p - 1'd1);
wire [7:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (cq2eg_count_p + 1'd1) : 
                                                                    cq2eg_count_p;
// spyglass enable_block W164a W484
wire [7:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~cq2eg_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq2eg_count_p <=  8'd0;
        cq2eg_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cq2eg_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cq2eg_count_p <=  {8{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    cq2eg_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cq2eg_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (cq2eg_pvld_p || (cq2eg_pvld_int && !cq2eg_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq2eg_pvld_int <=  1'b0;
    end else begin
        cq2eg_pvld_int <=  rd_req_next;
    end
end
assign cq2eg_pd = cq2eg_pd_p;
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (ig2cq_pvld && !ig2cq_busy_int) || (ig2cq_busy_int != ig2cq_busy_next)) || (rd_pushing || rd_popping || (cq2eg_pvld_int && cq2eg_prdy) || wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_cq_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_cq_wr_limit : 8'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_cq_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_cq_wr_limit=%d", wr_limit_override_value);
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
      .clk	( nvdla_core_clk ) 
    , .max      ( {24'd0, (wr_limit_reg == 8'd0) ? 8'd160 : wr_limit_reg} )
    , .curr	( {24'd0, ig2cq_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_BRDMA_cq") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_BRDMA_cq



