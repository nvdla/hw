

`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1

`ifndef SYNTHESIS
    `define FIFOGEN_KEEP_ASSERTION_VERIF_CODE
`else
    `ifdef FV_ASSERT_ON
        `define FIFOGEN_KEEP_ASSERTION_VERIF_CODE
    `endif
`endif

`include "simulate_x_tick.vh"


module NV_NVDLA_CDP_RDMA_ro_fifo_4x8 (
      nvdla_core_clk
    , nvdla_core_rstn
    , ro_wr_prdy
    , ro_wr_pvld
    , ro_wr_pd
    , ro_rd_prdy
    , ro_rd_pvld
    , ro_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        ro_wr_prdy;
input         ro_wr_pvld;
input  [7:0] ro_wr_pd;
input         ro_rd_prdy;
output        ro_rd_pvld;
output [7:0] ro_rd_pd;
input  [31:0] pwrbus_ram_pd;

//| &PerlBeg;
//|     $NV_NVDLA_CDP_RDMA_ro_fifo_4x8_PARENT_VIVA_MODULE = "$VIVA_MODULE";
//|     $VIVA_MODULE = "NV_NVDLA_CDP_RDMA_ro_fifo_4x8";
//| &PerlEnd;


`ifdef FV_RAND_WR_PAUSE
// FV forces this signal to trigger random stalling
wire ro_wr_pause = 0;
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
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        ro_wr_busy_int;		        	// copy for internal use
assign     ro_wr_prdy = !ro_wr_busy_int;
assign       wr_reserving = ro_wr_pvld && !ro_wr_busy_int; // reserving write space?



wire       wr_popping;                          // fwd: write side sees pop?


reg  [2:0] ro_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? ro_wr_count : (ro_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (ro_wr_count + 1'd1) : ro_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       ro_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check ro_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_busy_int <=  1'b0;
        ro_wr_count <=  3'd0;
    end else begin
	ro_wr_busy_int <=  ro_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    ro_wr_count <=  wr_count_next;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            ro_wr_count <=  {3{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as ro_wr_pvld

//
// RAM
//

reg  [1:0] ro_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    ro_wr_adr <=  ro_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] ro_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (ro_wr_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [7:0] ro_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( ro_wr_pd )
    , .we        ( ram_we )
    , .wa        ( ro_wr_adr )
    , .ra        ( (ro_wr_count == 0) ? 3'd4 : {1'b0,ro_rd_adr} )
    , .dout        ( ro_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = ro_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
            ro_rd_adr <=  rd_adr_next_popping;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !rd_popping ) begin
        end else begin
            ro_rd_adr <=  {2{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately


wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       ro_rd_pvld_p; 		// data out of fifo is valid

reg        ro_rd_pvld_int;	// internal copy of ro_rd_pvld
assign     ro_rd_pvld = ro_rd_pvld_int;
assign     rd_popping = ro_rd_pvld_p && !(ro_rd_pvld_int && !ro_rd_prdy);

reg  [2:0] ro_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_p_next_rd_popping = rd_pushing ? ro_rd_count_p : 
                                                                (ro_rd_count_p - 1'd1);
wire [2:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (ro_rd_count_p + 1'd1) : 
                                                                    ro_rd_count_p;
// spyglass enable_block W164a W484
wire [2:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     ro_rd_pvld_p = ro_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_count_p <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    ro_rd_count_p <=  rd_count_p_next;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            ro_rd_count_p <=  {3{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end
reg [7:0]  ro_rd_pd;         // output data register
wire        rd_req_next = (ro_rd_pvld_p || (ro_rd_pvld_int && !ro_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_pvld_int <=  1'b0;
    end else begin
        ro_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        ro_rd_pd <=  ro_rd_pd_p;
    end 
    `ifndef SYNTHESIS
    // VCS coverage off
    else if ( !((rd_popping)) ) begin
    end else begin
        ro_rd_pd <=  {8{`x_or_0}};
    end
    // VCS coverage on
    `endif // SYNTHESIS
end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// VCS coverage off
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
// VCS coverage on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (ro_wr_pvld && !ro_wr_busy_int) || (ro_wr_busy_int != ro_wr_busy_next)) || (rd_pushing || rd_popping || (ro_rd_pvld_int && ro_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // VCS coverage off
                               `ifndef SYNTHESIS
                               || master_clk_gating_disabled
                               `endif
                               // VCS coverage on
;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_RDMA_ro_fifo_4x8_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_RDMA_ro_fifo_4x8_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_CDP_RDMA_ro_fifo_4x8_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_RDMA_ro_fifo_4x8_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


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
// VCS coverage off
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, ro_wr_count} )
    );
`endif
// VCS coverage on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FIFOGEN_KEEP_ASSERTION_VERIF_CODE
// VCS coverage off
`ifdef ASSERT_ON



`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = |($test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS"));
`endif // ifdef FV_ASSERT_ON

`endif // ifdef SPYGLASS


wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif // ifdef ASSERT_ON
// VCS coverage on
`endif // ifdef FIFOGEN_KEEP_ASSERTION_VERIF_CODE


`ifdef ASSERT_ON

// VCS coverage off
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
// VCS coverage on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//| &Viva push ifdef_ignore_on;

`ifdef COVER

wire wr_testpoint_reset_ = ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn );


//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo Full" -clk nvdla_core_clk -reset wr_testpoint_reset_ ro_wr_count==4;
//| &Force internal /^testpoint_/;

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_Full
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_Full

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x8
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo Full"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_0_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_0_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_0_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_0_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_0_internal_nvdla_core_clk or negedge testpoint_0_internal_wr_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_0
        if (~testpoint_0_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_0_count_0;

    reg testpoint_0_goal_0;
    initial testpoint_0_goal_0 = 0;
    initial testpoint_0_count_0 = 0;
    always@(testpoint_0_count_0) begin
        if(testpoint_0_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_0_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: FIFOGEN_TESTPOINT Fifo Full ::: ro_wr_count==4");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: FIFOGEN_TESTPOINT Fifo Full ::: testpoint_0_goal_0
            testpoint_0_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_0_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_0_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
        if (testpoint_0_internal_wr_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_wr_count==4) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: FIFOGEN_TESTPOINT Fifo Full ::: testpoint_0_goal_0");
 `endif
            if ((ro_wr_count==4) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk)
                testpoint_0_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk) begin
 `endif
                testpoint_0_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_0_goal_0_active = ((ro_wr_count==4) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_Full_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo Full and wr_req" -clk nvdla_core_clk -reset wr_testpoint_reset_ ro_wr_count==4 && ro_wr_pvld;
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x8
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo Full and wr_req"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_1_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_1_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_1_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_1_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_1_internal_nvdla_core_clk or negedge testpoint_1_internal_wr_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_1
        if (~testpoint_1_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_1_count_0;

    reg testpoint_1_goal_0;
    initial testpoint_1_goal_0 = 0;
    initial testpoint_1_count_0 = 0;
    always@(testpoint_1_count_0) begin
        if(testpoint_1_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_1_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: ro_wr_count==4 && ro_wr_pvld");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: testpoint_1_goal_0
            testpoint_1_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_1_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_1_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
        if (testpoint_1_internal_wr_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: testpoint_1_goal_0");
 `endif
            if ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk)
                testpoint_1_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk) begin
 `endif
                testpoint_1_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_1_goal_0_active = ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


wire rd_testpoint_reset_ = ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn );


//| ::testpoint -autogen true -name "Fifo not empty and rd_busy" -clk nvdla_core_clk -reset rd_testpoint_reset_ ro_rd_pvld && !ro_rd_prdy;
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // COVER

  `ifdef TP__Fifo_not_empty_and_rd_busy
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // TP__Fifo_not_empty_and_rd_busy

`ifdef COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x8
//VCS coverage off
    // TESTPOINT_START
    // NAME="Fifo not empty and rd_busy"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_2_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_2_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_2_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_2_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_2_internal_nvdla_core_clk or negedge testpoint_2_internal_rd_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_2
        if (~testpoint_2_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_2_count_0;

    reg testpoint_2_goal_0;
    initial testpoint_2_goal_0 = 0;
    initial testpoint_2_count_0 = 0;
    always@(testpoint_2_count_0) begin
        if(testpoint_2_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_2_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: Fifo not empty and rd_busy ::: ro_rd_pvld && !ro_rd_prdy");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: Fifo not empty and rd_busy ::: testpoint_2_goal_0
            testpoint_2_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_2_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_2_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_2
        if (testpoint_2_internal_rd_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: Fifo not empty and rd_busy ::: testpoint_2_goal_0");
 `endif
            if ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk)
                testpoint_2_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk) begin
 `endif
                testpoint_2_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_2_goal_0_active = ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_Fifo_not_empty_and_rd_busy_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

reg [1:0] testpoint_empty_state;
reg [1:0] testpoint_empty_state_nxt;
reg testpoint_non_empty_to_empty_to_non_empty_reached;

`define FIFO_INIT 2'b00
`define FIFO_NON_EMPTY 2'b01
`define FIFO_EMPTY 2'b10

always @(testpoint_empty_state or (!ro_rd_pvld)) begin
    testpoint_empty_state_nxt = testpoint_empty_state;
    testpoint_non_empty_to_empty_to_non_empty_reached = 0;
    casez (testpoint_empty_state)
         `FIFO_INIT: begin
             if (!(!ro_rd_pvld)) begin
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         `FIFO_NON_EMPTY: begin
             if ((!ro_rd_pvld)) begin
                 testpoint_empty_state_nxt = `FIFO_EMPTY;
             end
         end
         `FIFO_EMPTY: begin
             if (!(!ro_rd_pvld)) begin
                 testpoint_non_empty_to_empty_to_non_empty_reached = 1;
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         // VCS coverage off
         default: begin
             testpoint_empty_state_nxt = `FIFO_INIT;
         end
         // VCS coverage on
    endcase
end
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        testpoint_empty_state <=  2'b00;
    end else begin
         if (testpoint_empty_state != testpoint_empty_state_nxt) begin
             testpoint_empty_state <= testpoint_empty_state_nxt;
         end
     end
end

//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty" -clk nvdla_core_clk -reset rd_testpoint_reset_ testpoint_non_empty_to_empty_to_non_empty_reached; 
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x8
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_3_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_3_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_3_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_3_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_3_internal_nvdla_core_clk or negedge testpoint_3_internal_rd_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_3
        if (~testpoint_3_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_3_count_0;

    reg testpoint_3_goal_0;
    initial testpoint_3_goal_0 = 0;
    initial testpoint_3_count_0 = 0;
    always@(testpoint_3_count_0) begin
        if(testpoint_3_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_3_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_non_empty_to_empty_to_non_empty_reached");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_3_goal_0
            testpoint_3_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_3_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_3_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_3
        if (testpoint_3_internal_rd_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x8 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_3_goal_0");
 `endif
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk)
                testpoint_3_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk) begin
 `endif
                testpoint_3_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_3_goal_0_active = ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


`endif

//| &Viva pop ifdef_ignore_on;


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_RDMA_ro_fifo_4x8") true
// synopsys dc_script_end

//| &Attachment -no_warn EndModulePrepend;

//| &Perl $VIVA_MODULE = $NV_NVDLA_CDP_RDMA_ro_fifo_4x8_PARENT_VIVA_MODULE;


endmodule // NV_NVDLA_CDP_RDMA_ro_fifo_4x8

// 
// Flop-Based RAM 
//
module NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [7:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [7:0] dout;

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


`ifdef EMU


wire [7:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [7:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [7:0] ram_ff0;
reg [7:0] ram_ff1;
reg [7:0] ram_ff2;
reg [7:0] ram_ff3;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [7:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {8{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [7:0] Di0;
input  [1:0] Ra0;
output [7:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 8'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// VCS coverage off
`ifndef SYNTHESIS
reg [7:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [7:0] Q0 = mem[0];
wire [7:0] Q1 = mem[1];
wire [7:0] Q2 = mem[2];
wire [7:0] Q3 = mem[3];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
// VCS coverage on

// synopsys dc_script_begin
//  set_dont_touch { find (design, vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8) }
//  set_attribute  { find (design, vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8) } require_dont_touch true -type boolean
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8] }
endmodule // vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8

//vmw: Memory vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8
//vmw: Address-size 2
//vmw: Data-size 8
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[7:0] data0[7:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[7:0] data1[7:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x8_flopram_rwsa_4x8
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU


`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1

`ifndef SYNTHESIS
    `define FIFOGEN_KEEP_ASSERTION_VERIF_CODE
`else
    `ifdef FV_ASSERT_ON
        `define FIFOGEN_KEEP_ASSERTION_VERIF_CODE
    `endif
`endif

`include "simulate_x_tick.vh"


module NV_NVDLA_CDP_RDMA_ro_fifo_4x16 (
      nvdla_core_clk
    , nvdla_core_rstn
    , ro_wr_prdy
    , ro_wr_pvld
    , ro_wr_pd
    , ro_rd_prdy
    , ro_rd_pvld
    , ro_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        ro_wr_prdy;
input         ro_wr_pvld;
input  [15:0] ro_wr_pd;
input         ro_rd_prdy;
output        ro_rd_pvld;
output [15:0] ro_rd_pd;
input  [31:0] pwrbus_ram_pd;

//| &PerlBeg;
//|     $NV_NVDLA_CDP_RDMA_ro_fifo_4x16_PARENT_VIVA_MODULE = "$VIVA_MODULE";
//|     $VIVA_MODULE = "NV_NVDLA_CDP_RDMA_ro_fifo_4x16";
//| &PerlEnd;


`ifdef FV_RAND_WR_PAUSE
// FV forces this signal to trigger random stalling
wire ro_wr_pause = 0;
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
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        ro_wr_busy_int;		        	// copy for internal use
assign     ro_wr_prdy = !ro_wr_busy_int;
assign       wr_reserving = ro_wr_pvld && !ro_wr_busy_int; // reserving write space?



wire       wr_popping;                          // fwd: write side sees pop?


reg  [2:0] ro_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? ro_wr_count : (ro_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (ro_wr_count + 1'd1) : ro_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       ro_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check ro_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_busy_int <=  1'b0;
        ro_wr_count <=  3'd0;
    end else begin
	ro_wr_busy_int <=  ro_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    ro_wr_count <=  wr_count_next;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            ro_wr_count <=  {3{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as ro_wr_pvld

//
// RAM
//

reg  [1:0] ro_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    ro_wr_adr <=  ro_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] ro_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (ro_wr_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [15:0] ro_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( ro_wr_pd )
    , .we        ( ram_we )
    , .wa        ( ro_wr_adr )
    , .ra        ( (ro_wr_count == 0) ? 3'd4 : {1'b0,ro_rd_adr} )
    , .dout        ( ro_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = ro_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
            ro_rd_adr <=  rd_adr_next_popping;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !rd_popping ) begin
        end else begin
            ro_rd_adr <=  {2{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately


wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       ro_rd_pvld_p; 		// data out of fifo is valid

reg        ro_rd_pvld_int;	// internal copy of ro_rd_pvld
assign     ro_rd_pvld = ro_rd_pvld_int;
assign     rd_popping = ro_rd_pvld_p && !(ro_rd_pvld_int && !ro_rd_prdy);

reg  [2:0] ro_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_p_next_rd_popping = rd_pushing ? ro_rd_count_p : 
                                                                (ro_rd_count_p - 1'd1);
wire [2:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (ro_rd_count_p + 1'd1) : 
                                                                    ro_rd_count_p;
// spyglass enable_block W164a W484
wire [2:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     ro_rd_pvld_p = ro_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_count_p <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    ro_rd_count_p <=  rd_count_p_next;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            ro_rd_count_p <=  {3{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end
reg [15:0]  ro_rd_pd;         // output data register
wire        rd_req_next = (ro_rd_pvld_p || (ro_rd_pvld_int && !ro_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_pvld_int <=  1'b0;
    end else begin
        ro_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        ro_rd_pd <=  ro_rd_pd_p;
    end 
    `ifndef SYNTHESIS
    // VCS coverage off
    else if ( !((rd_popping)) ) begin
    end else begin
        ro_rd_pd <=  {16{`x_or_0}};
    end
    // VCS coverage on
    `endif // SYNTHESIS
end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// VCS coverage off
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
// VCS coverage on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (ro_wr_pvld && !ro_wr_busy_int) || (ro_wr_busy_int != ro_wr_busy_next)) || (rd_pushing || rd_popping || (ro_rd_pvld_int && ro_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // VCS coverage off
                               `ifndef SYNTHESIS
                               || master_clk_gating_disabled
                               `endif
                               // VCS coverage on
;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_RDMA_ro_fifo_4x16_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_RDMA_ro_fifo_4x16_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_CDP_RDMA_ro_fifo_4x16_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_RDMA_ro_fifo_4x16_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


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
// VCS coverage off
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, ro_wr_count} )
    );
`endif
// VCS coverage on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FIFOGEN_KEEP_ASSERTION_VERIF_CODE
// VCS coverage off
`ifdef ASSERT_ON



`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = |($test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS"));
`endif // ifdef FV_ASSERT_ON

`endif // ifdef SPYGLASS


wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif // ifdef ASSERT_ON
// VCS coverage on
`endif // ifdef FIFOGEN_KEEP_ASSERTION_VERIF_CODE


`ifdef ASSERT_ON

// VCS coverage off
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
// VCS coverage on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//| &Viva push ifdef_ignore_on;

`ifdef COVER

wire wr_testpoint_reset_ = ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn );


//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo Full" -clk nvdla_core_clk -reset wr_testpoint_reset_ ro_wr_count==4;
//| &Force internal /^testpoint_/;

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_Full
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_Full

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x16
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo Full"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_0_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_0_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_0_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_0_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_0_internal_nvdla_core_clk or negedge testpoint_0_internal_wr_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_0
        if (~testpoint_0_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_0_count_0;

    reg testpoint_0_goal_0;
    initial testpoint_0_goal_0 = 0;
    initial testpoint_0_count_0 = 0;
    always@(testpoint_0_count_0) begin
        if(testpoint_0_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_0_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: FIFOGEN_TESTPOINT Fifo Full ::: ro_wr_count==4");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: FIFOGEN_TESTPOINT Fifo Full ::: testpoint_0_goal_0
            testpoint_0_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_0_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_0_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
        if (testpoint_0_internal_wr_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_wr_count==4) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: FIFOGEN_TESTPOINT Fifo Full ::: testpoint_0_goal_0");
 `endif
            if ((ro_wr_count==4) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk)
                testpoint_0_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk) begin
 `endif
                testpoint_0_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_0_goal_0_active = ((ro_wr_count==4) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_Full_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo Full and wr_req" -clk nvdla_core_clk -reset wr_testpoint_reset_ ro_wr_count==4 && ro_wr_pvld;
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x16
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo Full and wr_req"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_1_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_1_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_1_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_1_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_1_internal_nvdla_core_clk or negedge testpoint_1_internal_wr_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_1
        if (~testpoint_1_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_1_count_0;

    reg testpoint_1_goal_0;
    initial testpoint_1_goal_0 = 0;
    initial testpoint_1_count_0 = 0;
    always@(testpoint_1_count_0) begin
        if(testpoint_1_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_1_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: ro_wr_count==4 && ro_wr_pvld");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: testpoint_1_goal_0
            testpoint_1_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_1_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_1_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
        if (testpoint_1_internal_wr_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: testpoint_1_goal_0");
 `endif
            if ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk)
                testpoint_1_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk) begin
 `endif
                testpoint_1_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_1_goal_0_active = ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


wire rd_testpoint_reset_ = ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn );


//| ::testpoint -autogen true -name "Fifo not empty and rd_busy" -clk nvdla_core_clk -reset rd_testpoint_reset_ ro_rd_pvld && !ro_rd_prdy;
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // COVER

  `ifdef TP__Fifo_not_empty_and_rd_busy
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // TP__Fifo_not_empty_and_rd_busy

`ifdef COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x16
//VCS coverage off
    // TESTPOINT_START
    // NAME="Fifo not empty and rd_busy"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_2_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_2_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_2_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_2_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_2_internal_nvdla_core_clk or negedge testpoint_2_internal_rd_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_2
        if (~testpoint_2_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_2_count_0;

    reg testpoint_2_goal_0;
    initial testpoint_2_goal_0 = 0;
    initial testpoint_2_count_0 = 0;
    always@(testpoint_2_count_0) begin
        if(testpoint_2_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_2_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: Fifo not empty and rd_busy ::: ro_rd_pvld && !ro_rd_prdy");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: Fifo not empty and rd_busy ::: testpoint_2_goal_0
            testpoint_2_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_2_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_2_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_2
        if (testpoint_2_internal_rd_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: Fifo not empty and rd_busy ::: testpoint_2_goal_0");
 `endif
            if ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk)
                testpoint_2_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk) begin
 `endif
                testpoint_2_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_2_goal_0_active = ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_Fifo_not_empty_and_rd_busy_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

reg [1:0] testpoint_empty_state;
reg [1:0] testpoint_empty_state_nxt;
reg testpoint_non_empty_to_empty_to_non_empty_reached;

`define FIFO_INIT 2'b00
`define FIFO_NON_EMPTY 2'b01
`define FIFO_EMPTY 2'b10

always @(testpoint_empty_state or (!ro_rd_pvld)) begin
    testpoint_empty_state_nxt = testpoint_empty_state;
    testpoint_non_empty_to_empty_to_non_empty_reached = 0;
    casez (testpoint_empty_state)
         `FIFO_INIT: begin
             if (!(!ro_rd_pvld)) begin
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         `FIFO_NON_EMPTY: begin
             if ((!ro_rd_pvld)) begin
                 testpoint_empty_state_nxt = `FIFO_EMPTY;
             end
         end
         `FIFO_EMPTY: begin
             if (!(!ro_rd_pvld)) begin
                 testpoint_non_empty_to_empty_to_non_empty_reached = 1;
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         // VCS coverage off
         default: begin
             testpoint_empty_state_nxt = `FIFO_INIT;
         end
         // VCS coverage on
    endcase
end
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        testpoint_empty_state <=  2'b00;
    end else begin
         if (testpoint_empty_state != testpoint_empty_state_nxt) begin
             testpoint_empty_state <= testpoint_empty_state_nxt;
         end
     end
end

//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty" -clk nvdla_core_clk -reset rd_testpoint_reset_ testpoint_non_empty_to_empty_to_non_empty_reached; 
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x16
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_3_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_3_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_3_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_3_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_3_internal_nvdla_core_clk or negedge testpoint_3_internal_rd_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_3
        if (~testpoint_3_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_3_count_0;

    reg testpoint_3_goal_0;
    initial testpoint_3_goal_0 = 0;
    initial testpoint_3_count_0 = 0;
    always@(testpoint_3_count_0) begin
        if(testpoint_3_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_3_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_non_empty_to_empty_to_non_empty_reached");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_3_goal_0
            testpoint_3_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_3_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_3_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_3
        if (testpoint_3_internal_rd_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x16 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_3_goal_0");
 `endif
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk)
                testpoint_3_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk) begin
 `endif
                testpoint_3_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_3_goal_0_active = ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


`endif

//| &Viva pop ifdef_ignore_on;


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_RDMA_ro_fifo_4x16") true
// synopsys dc_script_end

//| &Attachment -no_warn EndModulePrepend;

//| &Perl $VIVA_MODULE = $NV_NVDLA_CDP_RDMA_ro_fifo_4x16_PARENT_VIVA_MODULE;


endmodule // NV_NVDLA_CDP_RDMA_ro_fifo_4x16

// 
// Flop-Based RAM 
//
module NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [15:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [15:0] dout;

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


`ifdef EMU


wire [15:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [15:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [15:0] ram_ff0;
reg [15:0] ram_ff1;
reg [15:0] ram_ff2;
reg [15:0] ram_ff3;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [15:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {16{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [15:0] Di0;
input  [1:0] Ra0;
output [15:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 16'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// VCS coverage off
`ifndef SYNTHESIS
reg [15:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [15:0] Q0 = mem[0];
wire [15:0] Q1 = mem[1];
wire [15:0] Q2 = mem[2];
wire [15:0] Q3 = mem[3];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
// VCS coverage on

// synopsys dc_script_begin
//  set_dont_touch { find (design, vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16) }
//  set_attribute  { find (design, vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16) } require_dont_touch true -type boolean
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16] }
endmodule // vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16

//vmw: Memory vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16
//vmw: Address-size 2
//vmw: Data-size 16
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[15:0] data0[15:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[15:0] data1[15:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x16_flopram_rwsa_4x16
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

//| &Viva pop dangle_checks_off;

`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1

`ifndef SYNTHESIS
    `define FIFOGEN_KEEP_ASSERTION_VERIF_CODE
`else
    `ifdef FV_ASSERT_ON
        `define FIFOGEN_KEEP_ASSERTION_VERIF_CODE
    `endif
`endif

`include "simulate_x_tick.vh"


module NV_NVDLA_CDP_RDMA_ro_fifo_4x32 (
      nvdla_core_clk
    , nvdla_core_rstn
    , ro_wr_prdy
    , ro_wr_pvld
    , ro_wr_pd
    , ro_rd_prdy
    , ro_rd_pvld
    , ro_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        ro_wr_prdy;
input         ro_wr_pvld;
input  [31:0] ro_wr_pd;
input         ro_rd_prdy;
output        ro_rd_pvld;
output [31:0] ro_rd_pd;
input  [31:0] pwrbus_ram_pd;

//| &PerlBeg;
//|     $NV_NVDLA_CDP_RDMA_ro_fifo_4x32_PARENT_VIVA_MODULE = "$VIVA_MODULE";
//|     $VIVA_MODULE = "NV_NVDLA_CDP_RDMA_ro_fifo_4x32";
//| &PerlEnd;


`ifdef FV_RAND_WR_PAUSE
// FV forces this signal to trigger random stalling
wire ro_wr_pause = 0;
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
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        ro_wr_busy_int;		        	// copy for internal use
assign     ro_wr_prdy = !ro_wr_busy_int;
assign       wr_reserving = ro_wr_pvld && !ro_wr_busy_int; // reserving write space?



wire       wr_popping;                          // fwd: write side sees pop?


reg  [2:0] ro_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? ro_wr_count : (ro_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (ro_wr_count + 1'd1) : ro_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       ro_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check ro_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_busy_int <=  1'b0;
        ro_wr_count <=  3'd0;
    end else begin
	ro_wr_busy_int <=  ro_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    ro_wr_count <=  wr_count_next;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            ro_wr_count <=  {3{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as ro_wr_pvld

//
// RAM
//

reg  [1:0] ro_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    ro_wr_adr <=  ro_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] ro_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (ro_wr_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [31:0] ro_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( ro_wr_pd )
    , .we        ( ram_we )
    , .wa        ( ro_wr_adr )
    , .ra        ( (ro_wr_count == 0) ? 3'd4 : {1'b0,ro_rd_adr} )
    , .dout        ( ro_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = ro_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
            ro_rd_adr <=  rd_adr_next_popping;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !rd_popping ) begin
        end else begin
            ro_rd_adr <=  {2{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately


wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       ro_rd_pvld_p; 		// data out of fifo is valid

reg        ro_rd_pvld_int;	// internal copy of ro_rd_pvld
assign     ro_rd_pvld = ro_rd_pvld_int;
assign     rd_popping = ro_rd_pvld_p && !(ro_rd_pvld_int && !ro_rd_prdy);

reg  [2:0] ro_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_p_next_rd_popping = rd_pushing ? ro_rd_count_p : 
                                                                (ro_rd_count_p - 1'd1);
wire [2:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (ro_rd_count_p + 1'd1) : 
                                                                    ro_rd_count_p;
// spyglass enable_block W164a W484
wire [2:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     ro_rd_pvld_p = ro_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_count_p <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    ro_rd_count_p <=  rd_count_p_next;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            ro_rd_count_p <=  {3{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end
reg [31:0]  ro_rd_pd;         // output data register
wire        rd_req_next = (ro_rd_pvld_p || (ro_rd_pvld_int && !ro_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_pvld_int <=  1'b0;
    end else begin
        ro_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        ro_rd_pd <=  ro_rd_pd_p;
    end 
    `ifndef SYNTHESIS
    // VCS coverage off
    else if ( !((rd_popping)) ) begin
    end else begin
        ro_rd_pd <=  {32{`x_or_0}};
    end
    // VCS coverage on
    `endif // SYNTHESIS
end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// VCS coverage off
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
// VCS coverage on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (ro_wr_pvld && !ro_wr_busy_int) || (ro_wr_busy_int != ro_wr_busy_next)) || (rd_pushing || rd_popping || (ro_rd_pvld_int && ro_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // VCS coverage off
                               `ifndef SYNTHESIS
                               || master_clk_gating_disabled
                               `endif
                               // VCS coverage on
;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_RDMA_ro_fifo_4x32_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_RDMA_ro_fifo_4x32_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_CDP_RDMA_ro_fifo_4x32_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_RDMA_ro_fifo_4x32_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


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
// VCS coverage off
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, ro_wr_count} )
    );
`endif
// VCS coverage on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FIFOGEN_KEEP_ASSERTION_VERIF_CODE
// VCS coverage off
`ifdef ASSERT_ON



`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = |($test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS"));
`endif // ifdef FV_ASSERT_ON

`endif // ifdef SPYGLASS


wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif // ifdef ASSERT_ON
// VCS coverage on
`endif // ifdef FIFOGEN_KEEP_ASSERTION_VERIF_CODE


`ifdef ASSERT_ON

// VCS coverage off
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
// VCS coverage on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//| &Viva push ifdef_ignore_on;

`ifdef COVER

wire wr_testpoint_reset_ = ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn );


//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo Full" -clk nvdla_core_clk -reset wr_testpoint_reset_ ro_wr_count==4;
//| &Force internal /^testpoint_/;

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_Full
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_Full

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x32
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo Full"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_0_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_0_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_0_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_0_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_0_internal_nvdla_core_clk or negedge testpoint_0_internal_wr_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_0
        if (~testpoint_0_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_0_count_0;

    reg testpoint_0_goal_0;
    initial testpoint_0_goal_0 = 0;
    initial testpoint_0_count_0 = 0;
    always@(testpoint_0_count_0) begin
        if(testpoint_0_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_0_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: FIFOGEN_TESTPOINT Fifo Full ::: ro_wr_count==4");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: FIFOGEN_TESTPOINT Fifo Full ::: testpoint_0_goal_0
            testpoint_0_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_0_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_0_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
        if (testpoint_0_internal_wr_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_wr_count==4) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: FIFOGEN_TESTPOINT Fifo Full ::: testpoint_0_goal_0");
 `endif
            if ((ro_wr_count==4) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk)
                testpoint_0_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk) begin
 `endif
                testpoint_0_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_0_goal_0_active = ((ro_wr_count==4) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_Full_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo Full and wr_req" -clk nvdla_core_clk -reset wr_testpoint_reset_ ro_wr_count==4 && ro_wr_pvld;
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x32
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo Full and wr_req"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_1_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_1_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_1_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_1_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_1_internal_nvdla_core_clk or negedge testpoint_1_internal_wr_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_1
        if (~testpoint_1_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_1_count_0;

    reg testpoint_1_goal_0;
    initial testpoint_1_goal_0 = 0;
    initial testpoint_1_count_0 = 0;
    always@(testpoint_1_count_0) begin
        if(testpoint_1_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_1_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: ro_wr_count==4 && ro_wr_pvld");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: testpoint_1_goal_0
            testpoint_1_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_1_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_1_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
        if (testpoint_1_internal_wr_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: testpoint_1_goal_0");
 `endif
            if ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk)
                testpoint_1_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk) begin
 `endif
                testpoint_1_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_1_goal_0_active = ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


wire rd_testpoint_reset_ = ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn );


//| ::testpoint -autogen true -name "Fifo not empty and rd_busy" -clk nvdla_core_clk -reset rd_testpoint_reset_ ro_rd_pvld && !ro_rd_prdy;
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // COVER

  `ifdef TP__Fifo_not_empty_and_rd_busy
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // TP__Fifo_not_empty_and_rd_busy

`ifdef COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x32
//VCS coverage off
    // TESTPOINT_START
    // NAME="Fifo not empty and rd_busy"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_2_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_2_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_2_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_2_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_2_internal_nvdla_core_clk or negedge testpoint_2_internal_rd_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_2
        if (~testpoint_2_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_2_count_0;

    reg testpoint_2_goal_0;
    initial testpoint_2_goal_0 = 0;
    initial testpoint_2_count_0 = 0;
    always@(testpoint_2_count_0) begin
        if(testpoint_2_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_2_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: Fifo not empty and rd_busy ::: ro_rd_pvld && !ro_rd_prdy");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: Fifo not empty and rd_busy ::: testpoint_2_goal_0
            testpoint_2_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_2_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_2_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_2
        if (testpoint_2_internal_rd_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: Fifo not empty and rd_busy ::: testpoint_2_goal_0");
 `endif
            if ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk)
                testpoint_2_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk) begin
 `endif
                testpoint_2_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_2_goal_0_active = ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_Fifo_not_empty_and_rd_busy_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

reg [1:0] testpoint_empty_state;
reg [1:0] testpoint_empty_state_nxt;
reg testpoint_non_empty_to_empty_to_non_empty_reached;

`define FIFO_INIT 2'b00
`define FIFO_NON_EMPTY 2'b01
`define FIFO_EMPTY 2'b10

always @(testpoint_empty_state or (!ro_rd_pvld)) begin
    testpoint_empty_state_nxt = testpoint_empty_state;
    testpoint_non_empty_to_empty_to_non_empty_reached = 0;
    casez (testpoint_empty_state)
         `FIFO_INIT: begin
             if (!(!ro_rd_pvld)) begin
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         `FIFO_NON_EMPTY: begin
             if ((!ro_rd_pvld)) begin
                 testpoint_empty_state_nxt = `FIFO_EMPTY;
             end
         end
         `FIFO_EMPTY: begin
             if (!(!ro_rd_pvld)) begin
                 testpoint_non_empty_to_empty_to_non_empty_reached = 1;
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         // VCS coverage off
         default: begin
             testpoint_empty_state_nxt = `FIFO_INIT;
         end
         // VCS coverage on
    endcase
end
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        testpoint_empty_state <=  2'b00;
    end else begin
         if (testpoint_empty_state != testpoint_empty_state_nxt) begin
             testpoint_empty_state <= testpoint_empty_state_nxt;
         end
     end
end

//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty" -clk nvdla_core_clk -reset rd_testpoint_reset_ testpoint_non_empty_to_empty_to_non_empty_reached; 
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x32
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_3_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_3_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_3_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_3_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_3_internal_nvdla_core_clk or negedge testpoint_3_internal_rd_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_3
        if (~testpoint_3_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_3_count_0;

    reg testpoint_3_goal_0;
    initial testpoint_3_goal_0 = 0;
    initial testpoint_3_count_0 = 0;
    always@(testpoint_3_count_0) begin
        if(testpoint_3_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_3_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_non_empty_to_empty_to_non_empty_reached");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_3_goal_0
            testpoint_3_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_3_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_3_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_3
        if (testpoint_3_internal_rd_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x32 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_3_goal_0");
 `endif
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk)
                testpoint_3_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk) begin
 `endif
                testpoint_3_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_3_goal_0_active = ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


`endif

//| &Viva pop ifdef_ignore_on;


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_RDMA_ro_fifo_4x32") true
// synopsys dc_script_end

//| &Attachment -no_warn EndModulePrepend;

//| &Perl $VIVA_MODULE = $NV_NVDLA_CDP_RDMA_ro_fifo_4x32_PARENT_VIVA_MODULE;


endmodule // NV_NVDLA_CDP_RDMA_ro_fifo_4x32

// 
// Flop-Based RAM 
//
module NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [31:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [31:0] dout;

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


`ifdef EMU


wire [31:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [31:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [31:0] ram_ff0;
reg [31:0] ram_ff1;
reg [31:0] ram_ff2;
reg [31:0] ram_ff3;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [31:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {32{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [31:0] Di0;
input  [1:0] Ra0;
output [31:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 32'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// VCS coverage off
`ifndef SYNTHESIS
reg [31:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [31:0] Q0 = mem[0];
wire [31:0] Q1 = mem[1];
wire [31:0] Q2 = mem[2];
wire [31:0] Q3 = mem[3];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
// VCS coverage on

// synopsys dc_script_begin
//  set_dont_touch { find (design, vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32) }
//  set_attribute  { find (design, vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32) } require_dont_touch true -type boolean
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32] }
endmodule // vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32

//vmw: Memory vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32
//vmw: Address-size 2
//vmw: Data-size 32
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[31:0] data0[31:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[31:0] data1[31:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x32_flopram_rwsa_4x32
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

//| &Viva pop dangle_checks_off;


//| &Shell ${FIFOGEN} -stdout -m NV_NVDLA_CDP_RDMA_ro_fifo_4x64
//|                 -clk_name   ::eval($VIVA_CLOCK)
//|                 -reset_name ::eval($VIVA_RESET)
//|                 -wr_pipebus ro_wr
//|                 -rd_pipebus ro_rd
//|                 -rd_reg
//|                 -rand_none
//|                 -ram_bypass
//|                 -d ::eval(4)
//|                 -w ::eval(64)
//|                 -ram ff; 
//| &Depend "../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit6/fifogen.yml";
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2018/04/28_05_00_03/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit6/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_CDP_RDMA_ro_fifo_4x64 -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus ro_wr -rd_pipebus ro_rd -rd_reg -rand_none -ram_bypass -d 4 -w 64 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  testpoint_message_prefix=FIFOGEN_TESTPOINT  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  remove_unused_ports=1  viva_parsed=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1  allow_mt_rttrb_wr_reg=0 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected

//| &Viva push dangle_checks_off;

`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1

`ifndef SYNTHESIS
    `define FIFOGEN_KEEP_ASSERTION_VERIF_CODE
`else
    `ifdef FV_ASSERT_ON
        `define FIFOGEN_KEEP_ASSERTION_VERIF_CODE
    `endif
`endif

`include "simulate_x_tick.vh"


module NV_NVDLA_CDP_RDMA_ro_fifo_4x64 (
      nvdla_core_clk
    , nvdla_core_rstn
    , ro_wr_prdy
    , ro_wr_pvld
    , ro_wr_pd
    , ro_rd_prdy
    , ro_rd_pvld
    , ro_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        ro_wr_prdy;
input         ro_wr_pvld;
input  [63:0] ro_wr_pd;
input         ro_rd_prdy;
output        ro_rd_pvld;
output [63:0] ro_rd_pd;
input  [31:0] pwrbus_ram_pd;

//| &PerlBeg;
//|     $NV_NVDLA_CDP_RDMA_ro_fifo_4x64_PARENT_VIVA_MODULE = "$VIVA_MODULE";
//|     $VIVA_MODULE = "NV_NVDLA_CDP_RDMA_ro_fifo_4x64";
//| &PerlEnd;


`ifdef FV_RAND_WR_PAUSE
// FV forces this signal to trigger random stalling
wire ro_wr_pause = 0;
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
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        ro_wr_busy_int;		        	// copy for internal use
assign     ro_wr_prdy = !ro_wr_busy_int;
assign       wr_reserving = ro_wr_pvld && !ro_wr_busy_int; // reserving write space?



wire       wr_popping;                          // fwd: write side sees pop?


reg  [2:0] ro_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? ro_wr_count : (ro_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (ro_wr_count + 1'd1) : ro_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       ro_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check ro_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_busy_int <=  1'b0;
        ro_wr_count <=  3'd0;
    end else begin
	ro_wr_busy_int <=  ro_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    ro_wr_count <=  wr_count_next;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            ro_wr_count <=  {3{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as ro_wr_pvld

//
// RAM
//

reg  [1:0] ro_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    ro_wr_adr <=  ro_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] ro_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (ro_wr_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [63:0] ro_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( ro_wr_pd )
    , .we        ( ram_we )
    , .wa        ( ro_wr_adr )
    , .ra        ( (ro_wr_count == 0) ? 3'd4 : {1'b0,ro_rd_adr} )
    , .dout        ( ro_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = ro_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
            ro_rd_adr <=  rd_adr_next_popping;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !rd_popping ) begin
        end else begin
            ro_rd_adr <=  {2{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately


wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       ro_rd_pvld_p; 		// data out of fifo is valid

reg        ro_rd_pvld_int;	// internal copy of ro_rd_pvld
assign     ro_rd_pvld = ro_rd_pvld_int;
assign     rd_popping = ro_rd_pvld_p && !(ro_rd_pvld_int && !ro_rd_prdy);

reg  [2:0] ro_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_p_next_rd_popping = rd_pushing ? ro_rd_count_p : 
                                                                (ro_rd_count_p - 1'd1);
wire [2:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (ro_rd_count_p + 1'd1) : 
                                                                    ro_rd_count_p;
// spyglass enable_block W164a W484
wire [2:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     ro_rd_pvld_p = ro_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_count_p <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    ro_rd_count_p <=  rd_count_p_next;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            ro_rd_count_p <=  {3{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end
reg [63:0]  ro_rd_pd;         // output data register
wire        rd_req_next = (ro_rd_pvld_p || (ro_rd_pvld_int && !ro_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_pvld_int <=  1'b0;
    end else begin
        ro_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        ro_rd_pd <=  ro_rd_pd_p;
    end 
    `ifndef SYNTHESIS
    // VCS coverage off
    else if ( !((rd_popping)) ) begin
    end else begin
        ro_rd_pd <=  {64{`x_or_0}};
    end
    // VCS coverage on
    `endif // SYNTHESIS
end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// VCS coverage off
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
// VCS coverage on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (ro_wr_pvld && !ro_wr_busy_int) || (ro_wr_busy_int != ro_wr_busy_next)) || (rd_pushing || rd_popping || (ro_rd_pvld_int && ro_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // VCS coverage off
                               `ifndef SYNTHESIS
                               || master_clk_gating_disabled
                               `endif
                               // VCS coverage on
;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_RDMA_ro_fifo_4x64_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_RDMA_ro_fifo_4x64_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_CDP_RDMA_ro_fifo_4x64_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_RDMA_ro_fifo_4x64_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


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
// VCS coverage off
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, ro_wr_count} )
    );
`endif
// VCS coverage on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FIFOGEN_KEEP_ASSERTION_VERIF_CODE
// VCS coverage off
`ifdef ASSERT_ON



`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = |($test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS"));
`endif // ifdef FV_ASSERT_ON

`endif // ifdef SPYGLASS


wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif // ifdef ASSERT_ON
// VCS coverage on
`endif // ifdef FIFOGEN_KEEP_ASSERTION_VERIF_CODE


`ifdef ASSERT_ON

// VCS coverage off
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
// VCS coverage on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//| &Viva push ifdef_ignore_on;

`ifdef COVER

wire wr_testpoint_reset_ = ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn );


//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo Full" -clk nvdla_core_clk -reset wr_testpoint_reset_ ro_wr_count==4;
//| &Force internal /^testpoint_/;

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_Full
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_Full

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x64
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo Full"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_4_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_4_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_4_internal_wr_testpoint_reset__with_clock_testpoint_4_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_4_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_4_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_4_internal_wr_testpoint_reset__with_clock_testpoint_4_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_4_internal_wr_testpoint_reset__with_clock_testpoint_4_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_4_internal_nvdla_core_clk or negedge testpoint_4_internal_wr_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_4
        if (~testpoint_4_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_4_internal_wr_testpoint_reset__with_clock_testpoint_4_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_4_count_0;

    reg testpoint_4_goal_0;
    initial testpoint_4_goal_0 = 0;
    initial testpoint_4_count_0 = 0;
    always@(testpoint_4_count_0) begin
        if(testpoint_4_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_4_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: FIFOGEN_TESTPOINT Fifo Full ::: ro_wr_count==4");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: FIFOGEN_TESTPOINT Fifo Full ::: testpoint_4_goal_0
            testpoint_4_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_4_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_4_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_4
        if (testpoint_4_internal_wr_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_wr_count==4) && testpoint_got_reset_testpoint_4_internal_wr_testpoint_reset__with_clock_testpoint_4_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: FIFOGEN_TESTPOINT Fifo Full ::: testpoint_4_goal_0");
 `endif
            if ((ro_wr_count==4) && testpoint_got_reset_testpoint_4_internal_wr_testpoint_reset__with_clock_testpoint_4_internal_nvdla_core_clk)
                testpoint_4_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_4_internal_wr_testpoint_reset__with_clock_testpoint_4_internal_nvdla_core_clk) begin
 `endif
                testpoint_4_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_4_goal_0_active = ((ro_wr_count==4) && testpoint_got_reset_testpoint_4_internal_wr_testpoint_reset__with_clock_testpoint_4_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_4_goal_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_Full_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo Full and wr_req" -clk nvdla_core_clk -reset wr_testpoint_reset_ ro_wr_count==4 && ro_wr_pvld;
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x64
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo Full and wr_req"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_5_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_5_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_5_internal_wr_testpoint_reset__with_clock_testpoint_5_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_5_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_5_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_5_internal_wr_testpoint_reset__with_clock_testpoint_5_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_5_internal_wr_testpoint_reset__with_clock_testpoint_5_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_5_internal_nvdla_core_clk or negedge testpoint_5_internal_wr_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_5
        if (~testpoint_5_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_5_internal_wr_testpoint_reset__with_clock_testpoint_5_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_5_count_0;

    reg testpoint_5_goal_0;
    initial testpoint_5_goal_0 = 0;
    initial testpoint_5_count_0 = 0;
    always@(testpoint_5_count_0) begin
        if(testpoint_5_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_5_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: ro_wr_count==4 && ro_wr_pvld");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: testpoint_5_goal_0
            testpoint_5_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_5_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_5_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_5
        if (testpoint_5_internal_wr_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_5_internal_wr_testpoint_reset__with_clock_testpoint_5_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: FIFOGEN_TESTPOINT Fifo Full and wr_req ::: testpoint_5_goal_0");
 `endif
            if ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_5_internal_wr_testpoint_reset__with_clock_testpoint_5_internal_nvdla_core_clk)
                testpoint_5_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_5_internal_wr_testpoint_reset__with_clock_testpoint_5_internal_nvdla_core_clk) begin
 `endif
                testpoint_5_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_5_goal_0_active = ((ro_wr_count==4 && ro_wr_pvld) && testpoint_got_reset_testpoint_5_internal_wr_testpoint_reset__with_clock_testpoint_5_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_5_goal_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_Full_and_wr_req_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


wire rd_testpoint_reset_ = ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn );


//| ::testpoint -autogen true -name "Fifo not empty and rd_busy" -clk nvdla_core_clk -reset rd_testpoint_reset_ ro_rd_pvld && !ro_rd_prdy;
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // COVER

  `ifdef TP__Fifo_not_empty_and_rd_busy
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // TP__Fifo_not_empty_and_rd_busy

`ifdef COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x64
//VCS coverage off
    // TESTPOINT_START
    // NAME="Fifo not empty and rd_busy"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_6_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_6_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_6_internal_rd_testpoint_reset__with_clock_testpoint_6_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_6_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_6_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_6_internal_rd_testpoint_reset__with_clock_testpoint_6_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_6_internal_rd_testpoint_reset__with_clock_testpoint_6_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_6_internal_nvdla_core_clk or negedge testpoint_6_internal_rd_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_6
        if (~testpoint_6_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_6_internal_rd_testpoint_reset__with_clock_testpoint_6_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_6_count_0;

    reg testpoint_6_goal_0;
    initial testpoint_6_goal_0 = 0;
    initial testpoint_6_count_0 = 0;
    always@(testpoint_6_count_0) begin
        if(testpoint_6_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_6_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: Fifo not empty and rd_busy ::: ro_rd_pvld && !ro_rd_prdy");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: Fifo not empty and rd_busy ::: testpoint_6_goal_0
            testpoint_6_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_6_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_6_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_6
        if (testpoint_6_internal_rd_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_6_internal_rd_testpoint_reset__with_clock_testpoint_6_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: Fifo not empty and rd_busy ::: testpoint_6_goal_0");
 `endif
            if ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_6_internal_rd_testpoint_reset__with_clock_testpoint_6_internal_nvdla_core_clk)
                testpoint_6_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_6_internal_rd_testpoint_reset__with_clock_testpoint_6_internal_nvdla_core_clk) begin
 `endif
                testpoint_6_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_6_goal_0_active = ((ro_rd_pvld && !ro_rd_prdy) && testpoint_got_reset_testpoint_6_internal_rd_testpoint_reset__with_clock_testpoint_6_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_6_goal_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `else
    system_verilog_testpoint svt_Fifo_not_empty_and_rd_busy_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

reg [1:0] testpoint_empty_state;
reg [1:0] testpoint_empty_state_nxt;
reg testpoint_non_empty_to_empty_to_non_empty_reached;

`define FIFO_INIT 2'b00
`define FIFO_NON_EMPTY 2'b01
`define FIFO_EMPTY 2'b10

always @(testpoint_empty_state or (!ro_rd_pvld)) begin
    testpoint_empty_state_nxt = testpoint_empty_state;
    testpoint_non_empty_to_empty_to_non_empty_reached = 0;
    casez (testpoint_empty_state)
         `FIFO_INIT: begin
             if (!(!ro_rd_pvld)) begin
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         `FIFO_NON_EMPTY: begin
             if ((!ro_rd_pvld)) begin
                 testpoint_empty_state_nxt = `FIFO_EMPTY;
             end
         end
         `FIFO_EMPTY: begin
             if (!(!ro_rd_pvld)) begin
                 testpoint_non_empty_to_empty_to_non_empty_reached = 1;
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         // VCS coverage off
         default: begin
             testpoint_empty_state_nxt = `FIFO_INIT;
         end
         // VCS coverage on
    endcase
end
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        testpoint_empty_state <=  2'b00;
    end else begin
         if (testpoint_empty_state != testpoint_empty_state_nxt) begin
             testpoint_empty_state <= testpoint_empty_state_nxt;
         end
     end
end

//| ::testpoint -autogen true -name "FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty" -clk nvdla_core_clk -reset rd_testpoint_reset_ testpoint_non_empty_to_empty_to_non_empty_reached; 
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // COVER

  `ifdef TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty
    `define COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty

`ifdef COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER


`define NV_TESTPOINT_COVERAGE_GUARD_NV_NVDLA_CDP_RDMA_ro_fifo_4x64
//VCS coverage off
    // TESTPOINT_START
    // NAME="FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_7_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_7_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_7_internal_rd_testpoint_reset__with_clock_testpoint_7_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_7_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_7_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_7_internal_rd_testpoint_reset__with_clock_testpoint_7_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_7_internal_rd_testpoint_reset__with_clock_testpoint_7_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_7_internal_nvdla_core_clk or negedge testpoint_7_internal_rd_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_7
        if (~testpoint_7_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_7_internal_rd_testpoint_reset__with_clock_testpoint_7_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_7_count_0;

    reg testpoint_7_goal_0;
    initial testpoint_7_goal_0 = 0;
    initial testpoint_7_count_0 = 0;
    always@(testpoint_7_count_0) begin
        if(testpoint_7_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_7_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_non_empty_to_empty_to_non_empty_reached");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_7_goal_0
            testpoint_7_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_7_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_7_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_7
        if (testpoint_7_internal_rd_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_7_internal_rd_testpoint_reset__with_clock_testpoint_7_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDP_RDMA_ro_fifo_4x64 ::: FIFOGEN_TESTPOINT Fifo non-empty to empty to non-empty ::: testpoint_7_goal_0");
 `endif
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_7_internal_rd_testpoint_reset__with_clock_testpoint_7_internal_nvdla_core_clk)
                testpoint_7_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_7_internal_rd_testpoint_reset__with_clock_testpoint_7_internal_nvdla_core_clk) begin
 `endif
                testpoint_7_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_7_goal_0_active = ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_7_internal_rd_testpoint_reset__with_clock_testpoint_7_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_7_goal_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `else
    system_verilog_testpoint svt_FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__FIFOGEN_TESTPOINT_Fifo_non_empty_to_empty_to_non_empty_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


`endif

//| &Viva pop ifdef_ignore_on;


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_RDMA_ro_fifo_4x64") true
// synopsys dc_script_end

//| &Attachment -no_warn EndModulePrepend;

//| &Perl $VIVA_MODULE = $NV_NVDLA_CDP_RDMA_ro_fifo_4x64_PARENT_VIVA_MODULE;


endmodule // NV_NVDLA_CDP_RDMA_ro_fifo_4x64

// 
// Flop-Based RAM 
//
module NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [63:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [63:0] dout;

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


`ifdef EMU


wire [63:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [63:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [63:0] ram_ff0;
reg [63:0] ram_ff1;
reg [63:0] ram_ff2;
reg [63:0] ram_ff3;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [63:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {64{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [63:0] Di0;
input  [1:0] Ra0;
output [63:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 64'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// VCS coverage off
`ifndef SYNTHESIS
reg [63:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [63:0] Q0 = mem[0];
wire [63:0] Q1 = mem[1];
wire [63:0] Q2 = mem[2];
wire [63:0] Q3 = mem[3];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
// VCS coverage on

// synopsys dc_script_begin
//  set_dont_touch { find (design, vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64) }
//  set_attribute  { find (design, vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64) } require_dont_touch true -type boolean
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64] }
endmodule // vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64

//vmw: Memory vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64
//vmw: Address-size 2
//vmw: Data-size 64
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[63:0] data0[63:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[63:0] data1[63:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CDP_RDMA_ro_fifo_4x64_flopram_rwsa_4x64
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

//| &Viva pop dangle_checks_off;



