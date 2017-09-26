//
// verilint 180 OFF -- Zero extension of extra bits
// verilint 257 OFF -- * Delays ignored by synthesis tools
// verilint 280 OFF -- * Delay in non blocking assignment
// verilint 192 OFF -- Empty block: begin ... end
// verilint 396 OFF -- * A flipflop without an asynchronous reset
// verilint 446 OFF -- * Reading from an output port
// verilint 484 OFF -- Possible loss of carry/borrow in addition/subtraction
// verilint 530 OFF -- A flipflop is inferred 
// verilint 542 OFF -- Enabled flipflop (synchronous latch) is inferred
// verilint 549 OFF -- Asynchronous flipflop is inferred
// verilint 570 OFF -- Inferred a counter
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected


module wstrb_fifo (
      clk
    , reset_
    , wr_busy
    , wr_empty
    , wr_req
`ifdef FV_RAND_WR_PAUSE
    , wr_pause
`endif
    , wr_data
    , rd_busy
    , rd_req
    , rd_data
    );

input         clk;
input         reset_;
output        wr_busy;
output        wr_empty;
input         wr_req;
`ifdef FV_RAND_WR_PAUSE
input         wr_pause;
`endif
input  [(`DATABUS2MEM_WIDTH/8)-1:0] wr_data;
input         rd_busy;
output        rd_req;
output [(`DATABUS2MEM_WIDTH/8)-1:0] rd_data;



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
reg        wr_busy;				// busy (or ready) to sender
reg        wr_busy_int;		        	// copy for internal use
assign       wr_reserving = wr_req && !wr_busy_int; // reserving write space?

wire       wr_popping;                          // fwd: write side sees pop?

reg  [6:0] wr_count;			// write-side count
// spyglass disable_block W164a
wire [6:0] wr_count_next_wr_popping = wr_reserving ? wr_count : (wr_count - 1'd1);
// spyglass enable_block W164a
// spyglass disable_block W164a
wire [6:0] wr_count_next_no_wr_popping = wr_reserving ? (wr_count + 1'd1) : wr_count;
// spyglass enable_block W164a
wire [6:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_64 = ( wr_count_next_no_wr_popping == 7'd64 );
wire wr_count_next_is_64 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_64;
wire [6:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [6:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       wr_busy_next = wr_count_next_is_64 || // busy next cycle?
                          (wr_limit_reg != 7'd0 &&      // check wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       wr_busy_next = wr_count_next_is_64 || // busy next cycle?
                          (wr_limit_reg != 7'd0 &&      // check wr_limit if != 0
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
reg        wr_empty;				// empty?
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_busy <=  1'b0;
        wr_busy_int <=  1'b0;
        wr_count <=  7'd0;
        wr_empty <=  1'b1;
    end else begin
	wr_busy <=  wr_busy_next;
	wr_busy_int <=  wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
//VCS coverage off 
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            wr_count <=  {7{1'b0}};
        end
        //synopsys translate_on
//VCS coverage on

	wr_empty <=  wr_count_next == 7'd0 ;
    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as wr_req

//
// RAM
//

reg  [5:0] wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_adr <=  6'd0;
    end else begin
        if ( wr_pushing ) begin
	    wr_adr <=  wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

reg [5:0] rd_adr;          // read address this cycle
wire ram_we = wr_pushing;   // note: write occurs next cycle
wire [(`DATABUS2MEM_WIDTH/8)-1:0] rd_data;                    // read data out of ram

wstrb_fifo_flopram_rwsa_64x64 ram (
      .clk( clk )
    , .di        ( wr_data )
    , .we        ( ram_we )
    , .wa        ( wr_adr )
    , .ra        ( rd_adr )
    , .dout        ( rd_data )
    );

wire   rd_popping;              // read side doing pop this cycle?

wire [5:0] rd_adr_next_popping = rd_adr + 1'd1;
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_adr <=  6'd0;
    end else begin
        if ( rd_popping ) begin
	    rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
//VCS coverage off 
            else if ( !rd_popping ) begin
        end else begin
            rd_adr <=  {6{1'b0}};
        end
        //synopsys translate_on
//VCS coverage on

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

reg        rd_req; 		// data out of fifo is valid

reg        rd_req_int;			// internal copy of rd_req
assign     rd_popping = rd_req_int && !rd_busy;

reg  [6:0] rd_count;			// read-side fifo count
// spyglass disable_block W164a
wire [6:0] rd_count_next_rd_popping = rd_pushing ? rd_count : 
                                                                (rd_count - 1'd1);
wire [6:0] rd_count_next_no_rd_popping =  rd_pushing ? (rd_count + 1'd1) : 
                                                                    rd_count;
// spyglass enable_block W164a
wire [6:0] rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
wire rd_count_next_rd_popping_not_0 = rd_count_next_rd_popping != 0;
wire rd_count_next_no_rd_popping_not_0 = rd_count_next_no_rd_popping != 0;
wire rd_count_next_not_0 = rd_popping ? rd_count_next_rd_popping_not_0 :
                                              rd_count_next_no_rd_popping_not_0;
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_count <=  7'd0;
        rd_req <=  1'b0;
        rd_req_int <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    rd_count <=  rd_count_next;
        end 
        //synopsys translate_off
//VCS coverage off 
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rd_count <=  {7{1'b0}};
        end
        //synopsys translate_on
//VCS coverage on

        if ( rd_pushing || rd_popping  ) begin
	    rd_req   <=   (rd_count_next_not_0);
        end 
        //synopsys translate_off
//VCS coverage off 
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rd_req   <=  1'b0;
        end
        //synopsys translate_on
//VCS coverage on

        if ( rd_pushing || rd_popping  ) begin
	    rd_req_int <=   (rd_count_next_not_0);
        end 
        //synopsys translate_off
//VCS coverage off 
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rd_req_int <=  1'b0;
        end
        //synopsys translate_on
//VCS coverage on

    end
end

// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.wstrb_fifo_wr_limit_override ? `EMU_FIFO_CFG.wstrb_fifo_wr_limit : 7'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 7'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 7'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 7'd0;

`else  

// RTL Simulation Plusarg Override

// verilint 372 off - undefined PLI task
// verilint 430 off - initial statement
// verilint 182 off - illegal statement for synthesis
// verilint 599 off - not supported by Synopsys

// VCS coverage off

reg wr_limit_override;
reg [6:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 7'd0;
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
    if ( $test$plusargs( "wstrb_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs("wstrb_fifo_wr_limit", wr_limit_override_value);
    end
end

// VCS coverage on

// verilint 372 on
// verilint 430 on
// verilint 182 on
// verilint 599 on

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
integer stall_cycles_left_next; // stall cycles left
reg     stall_update;           // update stall cycles
reg [15:0] seed0;
reg [15:0] seed1;
reg [15:0] seed2;

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

    if (!$value$plusargs("global_rollpli_seed0=%d", seed0)) begin 
        if (!$value$plusargs("seed0=%d", seed0)) seed0=16'h0123;
    end 
    if (!$value$plusargs("global_rollpli_seed1=%d", seed1)) begin
        if (!$value$plusargs("seed1=%d", seed1)) seed1=16'h4567;
    end
    if (!$value$plusargs("global_rollpli_seed2=%d", seed2)) begin
        if (!$value$plusargs("seed2=%d", seed2)) seed2=16'h89ab;
    end
`ifdef USE_ROLLPLI
    $Seed48PLI(seed0, seed1, seed2, "auto");
`endif

    if ( $test$plusargs( "wstrb_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs("wstrb_fifo_fifo_stall_probability", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs("default_fifo_stall_probability", stall_probability);
    end

    if ( $test$plusargs( "wstrb_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs("wstrb_fifo_fifo_stall_cycles_min", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs("default_fifo_stall_cycles_min", stall_cycles_min);
    end

    if ( $test$plusargs( "wstrb_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs("wstrb_fifo_fifo_stall_cycles_max", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs("default_fifo_stall_cycles_max", stall_cycles_max);
    end

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "wstrb_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "wstrb_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "wstrb_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        stall_cycles_left_next <=  0;
        stall_update <=  1'b0;
    end else begin
        if ( stall_probability > 0 ) begin
`ifdef USE_ROLLPLI
            stall_cycles_left_next <=  $RollPLI(stall_cycles_min, stall_cycles_max, "auto" );
            stall_update <=  $RollPLI(1, 100, "auto" ) <= stall_probability;
`endif
        end else begin
            stall_cycles_left_next <=  0;
            stall_update <=  0;
        end
    end
end

always @( negedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        stall_cycles_left <=  0;
    end else begin
            if ( wr_req && !(wr_busy) 
                 && stall_probability != 0
                 && stall_update ) begin
                stall_cycles_left <=  stall_cycles_left_next;
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
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
`ifdef NO_PERFMON_HISTOGRAM 
`else
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( clk ) 
    , .max      ( {25'd0, (wr_limit_reg == 7'd0) ? 7'd64 : wr_limit_reg} )
    , .curr	( {25'd0, wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a
// spyglass disable_block W164b
// spyglass disable_block W116
// spyglass disable_block W484
// spyglass disable_block W504

`ifdef VERILINT
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef VERILINT
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

// spyglass enable_block W164a
// spyglass enable_block W164b
// spyglass enable_block W116
// spyglass enable_block W484
// spyglass enable_block W504


`ifdef COVER

wire wr_testpoint_reset_ = reset_;


//VCS coverage off
`ifndef DISABLE_TESTPOINTS
`ifdef COVER
    // TESTPOINT_START
    // NAME="Fifo Full"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_0_internal_clk   = clk;
wire testpoint_0_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_0_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_0_internal_clk
    reg testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk;

    initial
        testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk <= 1'b0;

    always @(posedge testpoint_0_internal_clk or negedge testpoint_0_internal_wr_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_0
        if (~testpoint_0_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk <= 1'b1;
    end
`endif

    reg testpoint_0_count_0;

    reg testpoint_0_goal_0;
    initial testpoint_0_goal_0 = 0;
    initial testpoint_0_count_0 = 0;
    always@(testpoint_0_count_0) begin
        if(testpoint_0_count_0 >= 1)
            //VCS coverage on
            // wr_count==64
            testpoint_0_goal_0 = 1'b1;
            //VCS coverage off
        else
            testpoint_0_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_0_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
        if (testpoint_0_internal_wr_testpoint_reset_) begin
            if ((wr_count==64) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk)
                testpoint_0_count_0 <= 1'd1;
        end
        else begin
`ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk) begin
`endif
                testpoint_0_count_0 <= 1'd0;
`ifndef FV_COVER_ON
            end
`endif
        end
    end

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_0_goal_0_active = ((wr_count==64) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_clk), .tp(testpoint_0_goal_0_active));
`endif

    //VCS coverage on
// ifdef COVER
`endif

// ifndef DISABLE_TESTPOINTS
`endif

    // TESTPOINT_END
//VCS coverage off
`ifndef DISABLE_TESTPOINTS
`ifdef COVER
    // TESTPOINT_START
    // NAME="Fifo Full and wr_req"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_1_internal_clk   = clk;
wire testpoint_1_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_1_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_1_internal_clk
    reg testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk;

    initial
        testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk <= 1'b0;

    always @(posedge testpoint_1_internal_clk or negedge testpoint_1_internal_wr_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_1
        if (~testpoint_1_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk <= 1'b1;
    end
`endif

    reg testpoint_1_count_0;

    reg testpoint_1_goal_0;
    initial testpoint_1_goal_0 = 0;
    initial testpoint_1_count_0 = 0;
    always@(testpoint_1_count_0) begin
        if(testpoint_1_count_0 >= 1)
            //VCS coverage on
            // wr_count==64 && wr_req
            testpoint_1_goal_0 = 1'b1;
            //VCS coverage off
        else
            testpoint_1_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_1_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
        if (testpoint_1_internal_wr_testpoint_reset_) begin
            if ((wr_count==64 && wr_req) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk)
                testpoint_1_count_0 <= 1'd1;
        end
        else begin
`ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk) begin
`endif
                testpoint_1_count_0 <= 1'd0;
`ifndef FV_COVER_ON
            end
`endif
        end
    end

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_1_goal_0_active = ((wr_count==64 && wr_req) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_clk), .tp(testpoint_1_goal_0_active));
`endif

    //VCS coverage on
// ifdef COVER
`endif

// ifndef DISABLE_TESTPOINTS
`endif

    // TESTPOINT_END

wire rd_testpoint_reset_ = reset_;

//VCS coverage off
`ifndef DISABLE_TESTPOINTS
`ifdef COVER
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
wire testpoint_2_internal_clk   = clk;
wire testpoint_2_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_2_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_2_internal_clk
    reg testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk;

    initial
        testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk <= 1'b0;

    always @(posedge testpoint_2_internal_clk or negedge testpoint_2_internal_rd_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_2
        if (~testpoint_2_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk <= 1'b1;
    end
`endif

    reg testpoint_2_count_0;

    reg testpoint_2_goal_0;
    initial testpoint_2_goal_0 = 0;
    initial testpoint_2_count_0 = 0;
    always@(testpoint_2_count_0) begin
        if(testpoint_2_count_0 >= 1)
            //VCS coverage on
            // rd_req && rd_busy
            testpoint_2_goal_0 = 1'b1;
            //VCS coverage off
        else
            testpoint_2_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_2_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_2
        if (testpoint_2_internal_rd_testpoint_reset_) begin
            if ((rd_req && rd_busy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk)
                testpoint_2_count_0 <= 1'd1;
        end
        else begin
`ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk) begin
`endif
                testpoint_2_count_0 <= 1'd0;
`ifndef FV_COVER_ON
            end
`endif
        end
    end

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_2_goal_0_active = ((rd_req && rd_busy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_clk), .tp(testpoint_2_goal_0_active));
`endif

    //VCS coverage on
// ifdef COVER
`endif

// ifndef DISABLE_TESTPOINTS
`endif

    // TESTPOINT_END

reg [1:0] testpoint_empty_state;
reg [1:0] testpoint_empty_state_nxt;
reg testpoint_non_empty_to_empty_to_non_empty_reached;

`define FIFO_INIT 2'b00
`define FIFO_NON_EMPTY 2'b01
`define FIFO_EMPTY 2'b10

always @(testpoint_empty_state or (!rd_req)) begin
    testpoint_empty_state_nxt = testpoint_empty_state;
    testpoint_non_empty_to_empty_to_non_empty_reached = 0;
    casez (testpoint_empty_state)
         `FIFO_INIT: begin
             if (!(!rd_req)) begin
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         `FIFO_NON_EMPTY: begin
             if ((!rd_req)) begin
                 testpoint_empty_state_nxt = `FIFO_EMPTY;
             end
         end
         `FIFO_EMPTY: begin
             if (!(!rd_req)) begin
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
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        testpoint_empty_state <=  2'b00;
    end else begin
         if (testpoint_empty_state != testpoint_empty_state_nxt) begin
             testpoint_empty_state <= testpoint_empty_state_nxt;
         end
     end
end

//VCS coverage off
`ifndef DISABLE_TESTPOINTS
`ifdef COVER
    // TESTPOINT_START
    // NAME="Fifo non-empty to empty to non-empty"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_3_internal_clk   = clk;
wire testpoint_3_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_3_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_3_internal_clk
    reg testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk;

    initial
        testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk <= 1'b0;

    always @(posedge testpoint_3_internal_clk or negedge testpoint_3_internal_rd_testpoint_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_3
        if (~testpoint_3_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk <= 1'b1;
    end
`endif

    reg testpoint_3_count_0;

    reg testpoint_3_goal_0;
    initial testpoint_3_goal_0 = 0;
    initial testpoint_3_count_0 = 0;
    always@(testpoint_3_count_0) begin
        if(testpoint_3_count_0 >= 1)
            //VCS coverage on
            // testpoint_non_empty_to_empty_to_non_empty_reached
            testpoint_3_goal_0 = 1'b1;
            //VCS coverage off
        else
            testpoint_3_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_3_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_3
        if (testpoint_3_internal_rd_testpoint_reset_) begin
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk)
                testpoint_3_count_0 <= 1'd1;
        end
        else begin
`ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk) begin
`endif
                testpoint_3_count_0 <= 1'd0;
`ifndef FV_COVER_ON
            end
`endif
        end
    end

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_3_goal_0_active = ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_clk), .tp(testpoint_3_goal_0_active));
`endif

    //VCS coverage on
// ifdef COVER
`endif

// ifndef DISABLE_TESTPOINTS
`endif

    // TESTPOINT_END

`endif


// synopsys dc_script_begin
//   set_boundary_optimization find(design, "wstrb_fifo") true
// synopsys dc_script_end

endmodule // wstrb_fifo

// 
// Flop-Based RAM 
//
module wstrb_fifo_flopram_rwsa_64x64 (
      clk
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input  [(`DATABUS2MEM_WIDTH/8)-1:0] di;
input  we;
input  [5:0] wa;
input  [5:0] ra;
output [(`DATABUS2MEM_WIDTH/8)-1:0] dout;

reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff0;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff1;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff2;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff3;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff4;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff5;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff6;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff7;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff8;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff9;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff10;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff11;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff12;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff13;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff14;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff15;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff16;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff17;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff18;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff19;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff20;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff21;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff22;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff23;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff24;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff25;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff26;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff27;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff28;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff29;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff30;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff31;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff32;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff33;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff34;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff35;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff36;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff37;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff38;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff39;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff40;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff41;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff42;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff43;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff44;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff45;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff46;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff47;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff48;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff49;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff50;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff51;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff52;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff53;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff54;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff55;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff56;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff57;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff58;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff59;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff60;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff61;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff62;
reg [(`DATABUS2MEM_WIDTH/8)-1:0] ram_ff63;

always @( posedge clk ) begin
    if ( we && wa == 6'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 6'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 6'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 6'd3 ) begin
	ram_ff3 <=  di;
    end
    if ( we && wa == 6'd4 ) begin
	ram_ff4 <=  di;
    end
    if ( we && wa == 6'd5 ) begin
	ram_ff5 <=  di;
    end
    if ( we && wa == 6'd6 ) begin
	ram_ff6 <=  di;
    end
    if ( we && wa == 6'd7 ) begin
	ram_ff7 <=  di;
    end
    if ( we && wa == 6'd8 ) begin
	ram_ff8 <=  di;
    end
    if ( we && wa == 6'd9 ) begin
	ram_ff9 <=  di;
    end
    if ( we && wa == 6'd10 ) begin
	ram_ff10 <=  di;
    end
    if ( we && wa == 6'd11 ) begin
	ram_ff11 <=  di;
    end
    if ( we && wa == 6'd12 ) begin
	ram_ff12 <=  di;
    end
    if ( we && wa == 6'd13 ) begin
	ram_ff13 <=  di;
    end
    if ( we && wa == 6'd14 ) begin
	ram_ff14 <=  di;
    end
    if ( we && wa == 6'd15 ) begin
	ram_ff15 <=  di;
    end
    if ( we && wa == 6'd16 ) begin
	ram_ff16 <=  di;
    end
    if ( we && wa == 6'd17 ) begin
	ram_ff17 <=  di;
    end
    if ( we && wa == 6'd18 ) begin
	ram_ff18 <=  di;
    end
    if ( we && wa == 6'd19 ) begin
	ram_ff19 <=  di;
    end
    if ( we && wa == 6'd20 ) begin
	ram_ff20 <=  di;
    end
    if ( we && wa == 6'd21 ) begin
	ram_ff21 <=  di;
    end
    if ( we && wa == 6'd22 ) begin
	ram_ff22 <=  di;
    end
    if ( we && wa == 6'd23 ) begin
	ram_ff23 <=  di;
    end
    if ( we && wa == 6'd24 ) begin
	ram_ff24 <=  di;
    end
    if ( we && wa == 6'd25 ) begin
	ram_ff25 <=  di;
    end
    if ( we && wa == 6'd26 ) begin
	ram_ff26 <=  di;
    end
    if ( we && wa == 6'd27 ) begin
	ram_ff27 <=  di;
    end
    if ( we && wa == 6'd28 ) begin
	ram_ff28 <=  di;
    end
    if ( we && wa == 6'd29 ) begin
	ram_ff29 <=  di;
    end
    if ( we && wa == 6'd30 ) begin
	ram_ff30 <=  di;
    end
    if ( we && wa == 6'd31 ) begin
	ram_ff31 <=  di;
    end
    if ( we && wa == 6'd32 ) begin
	ram_ff32 <=  di;
    end
    if ( we && wa == 6'd33 ) begin
	ram_ff33 <=  di;
    end
    if ( we && wa == 6'd34 ) begin
	ram_ff34 <=  di;
    end
    if ( we && wa == 6'd35 ) begin
	ram_ff35 <=  di;
    end
    if ( we && wa == 6'd36 ) begin
	ram_ff36 <=  di;
    end
    if ( we && wa == 6'd37 ) begin
	ram_ff37 <=  di;
    end
    if ( we && wa == 6'd38 ) begin
	ram_ff38 <=  di;
    end
    if ( we && wa == 6'd39 ) begin
	ram_ff39 <=  di;
    end
    if ( we && wa == 6'd40 ) begin
	ram_ff40 <=  di;
    end
    if ( we && wa == 6'd41 ) begin
	ram_ff41 <=  di;
    end
    if ( we && wa == 6'd42 ) begin
	ram_ff42 <=  di;
    end
    if ( we && wa == 6'd43 ) begin
	ram_ff43 <=  di;
    end
    if ( we && wa == 6'd44 ) begin
	ram_ff44 <=  di;
    end
    if ( we && wa == 6'd45 ) begin
	ram_ff45 <=  di;
    end
    if ( we && wa == 6'd46 ) begin
	ram_ff46 <=  di;
    end
    if ( we && wa == 6'd47 ) begin
	ram_ff47 <=  di;
    end
    if ( we && wa == 6'd48 ) begin
	ram_ff48 <=  di;
    end
    if ( we && wa == 6'd49 ) begin
	ram_ff49 <=  di;
    end
    if ( we && wa == 6'd50 ) begin
	ram_ff50 <=  di;
    end
    if ( we && wa == 6'd51 ) begin
	ram_ff51 <=  di;
    end
    if ( we && wa == 6'd52 ) begin
	ram_ff52 <=  di;
    end
    if ( we && wa == 6'd53 ) begin
	ram_ff53 <=  di;
    end
    if ( we && wa == 6'd54 ) begin
	ram_ff54 <=  di;
    end
    if ( we && wa == 6'd55 ) begin
	ram_ff55 <=  di;
    end
    if ( we && wa == 6'd56 ) begin
	ram_ff56 <=  di;
    end
    if ( we && wa == 6'd57 ) begin
	ram_ff57 <=  di;
    end
    if ( we && wa == 6'd58 ) begin
	ram_ff58 <=  di;
    end
    if ( we && wa == 6'd59 ) begin
	ram_ff59 <=  di;
    end
    if ( we && wa == 6'd60 ) begin
	ram_ff60 <=  di;
    end
    if ( we && wa == 6'd61 ) begin
	ram_ff61 <=  di;
    end
    if ( we && wa == 6'd62 ) begin
	ram_ff62 <=  di;
    end
    if ( we && wa == 6'd63 ) begin
	ram_ff63 <=  di;
    end
end

reg [63:0] dout;

always @( ra
          or ram_ff0
          or ram_ff1
          or ram_ff2
          or ram_ff3
          or ram_ff4
          or ram_ff5
          or ram_ff6
          or ram_ff7
          or ram_ff8
          or ram_ff9
          or ram_ff10
          or ram_ff11
          or ram_ff12
          or ram_ff13
          or ram_ff14
          or ram_ff15
          or ram_ff16
          or ram_ff17
          or ram_ff18
          or ram_ff19
          or ram_ff20
          or ram_ff21
          or ram_ff22
          or ram_ff23
          or ram_ff24
          or ram_ff25
          or ram_ff26
          or ram_ff27
          or ram_ff28
          or ram_ff29
          or ram_ff30
          or ram_ff31
          or ram_ff32
          or ram_ff33
          or ram_ff34
          or ram_ff35
          or ram_ff36
          or ram_ff37
          or ram_ff38
          or ram_ff39
          or ram_ff40
          or ram_ff41
          or ram_ff42
          or ram_ff43
          or ram_ff44
          or ram_ff45
          or ram_ff46
          or ram_ff47
          or ram_ff48
          or ram_ff49
          or ram_ff50
          or ram_ff51
          or ram_ff52
          or ram_ff53
          or ram_ff54
          or ram_ff55
          or ram_ff56
          or ram_ff57
          or ram_ff58
          or ram_ff59
          or ram_ff60
          or ram_ff61
          or ram_ff62
          or ram_ff63
        ) begin
    case( ra ) // synopsys infer_mux
    6'd0:       dout = ram_ff0;
    6'd1:       dout = ram_ff1;
    6'd2:       dout = ram_ff2;
    6'd3:       dout = ram_ff3;
    6'd4:       dout = ram_ff4;
    6'd5:       dout = ram_ff5;
    6'd6:       dout = ram_ff6;
    6'd7:       dout = ram_ff7;
    6'd8:       dout = ram_ff8;
    6'd9:       dout = ram_ff9;
    6'd10:       dout = ram_ff10;
    6'd11:       dout = ram_ff11;
    6'd12:       dout = ram_ff12;
    6'd13:       dout = ram_ff13;
    6'd14:       dout = ram_ff14;
    6'd15:       dout = ram_ff15;
    6'd16:       dout = ram_ff16;
    6'd17:       dout = ram_ff17;
    6'd18:       dout = ram_ff18;
    6'd19:       dout = ram_ff19;
    6'd20:       dout = ram_ff20;
    6'd21:       dout = ram_ff21;
    6'd22:       dout = ram_ff22;
    6'd23:       dout = ram_ff23;
    6'd24:       dout = ram_ff24;
    6'd25:       dout = ram_ff25;
    6'd26:       dout = ram_ff26;
    6'd27:       dout = ram_ff27;
    6'd28:       dout = ram_ff28;
    6'd29:       dout = ram_ff29;
    6'd30:       dout = ram_ff30;
    6'd31:       dout = ram_ff31;
    6'd32:       dout = ram_ff32;
    6'd33:       dout = ram_ff33;
    6'd34:       dout = ram_ff34;
    6'd35:       dout = ram_ff35;
    6'd36:       dout = ram_ff36;
    6'd37:       dout = ram_ff37;
    6'd38:       dout = ram_ff38;
    6'd39:       dout = ram_ff39;
    6'd40:       dout = ram_ff40;
    6'd41:       dout = ram_ff41;
    6'd42:       dout = ram_ff42;
    6'd43:       dout = ram_ff43;
    6'd44:       dout = ram_ff44;
    6'd45:       dout = ram_ff45;
    6'd46:       dout = ram_ff46;
    6'd47:       dout = ram_ff47;
    6'd48:       dout = ram_ff48;
    6'd49:       dout = ram_ff49;
    6'd50:       dout = ram_ff50;
    6'd51:       dout = ram_ff51;
    6'd52:       dout = ram_ff52;
    6'd53:       dout = ram_ff53;
    6'd54:       dout = ram_ff54;
    6'd55:       dout = ram_ff55;
    6'd56:       dout = ram_ff56;
    6'd57:       dout = ram_ff57;
    6'd58:       dout = ram_ff58;
    6'd59:       dout = ram_ff59;
    6'd60:       dout = ram_ff60;
    6'd61:       dout = ram_ff61;
    6'd62:       dout = ram_ff62;
    6'd63:       dout = ram_ff63;
    //VCS coverage off
    default:    dout = {64{1'b0}};
    //VCS coverage on
    endcase
end

endmodule // wstrb_fifo_flopram_rwsa_64x64



