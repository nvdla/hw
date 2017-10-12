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


module memresp_fifo (
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
    , rd_count
    );

input         clk;
input         reset_;
output        wr_busy;
output        wr_empty;
input         wr_req;
`ifdef FV_RAND_WR_PAUSE
input         wr_pause;
`endif
input  [511:0] wr_data;
input         rd_busy;
output        rd_req;
output [511:0] rd_data;
output   [8:0] rd_count;



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

reg  [8:0] wr_count;			// write-side count
// spyglass disable_block W164a
wire [8:0] wr_count_next_wr_popping = wr_reserving ? wr_count : (wr_count - 1'd1);
// spyglass enable_block W164a
// spyglass disable_block W164a
wire [8:0] wr_count_next_no_wr_popping = wr_reserving ? (wr_count + 1'd1) : wr_count;
// spyglass enable_block W164a
wire [8:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_448 = ( wr_count_next_no_wr_popping == 9'd448 );
wire wr_count_next_is_448 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_448;
wire [8:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [8:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       wr_busy_next = wr_count_next_is_448 || // busy next cycle?
                          (wr_limit_reg != 9'd0 &&      // check wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       wr_busy_next = wr_count_next_is_448 || // busy next cycle?
                          (wr_limit_reg != 9'd0 &&      // check wr_limit if != 0
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
        wr_count <=  9'd0;
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
            wr_count <=  {9{1'b0}};
        end
        //synopsys translate_on
//VCS coverage on

	wr_empty <=  wr_count_next == 9'd0 ;
    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as wr_req

//
// RAM
//

reg  [8:0] wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_adr <=  9'd0;
    end else begin
        if ( wr_pushing ) begin
	    wr_adr <=  (wr_adr == 9'd447) ? 9'd0 : (wr_adr + 1'd1);
        end
    end
end
// spyglass enable_block W484

reg [8:0] rd_adr;          // read address this cycle
wire ram_we = wr_pushing;   // note: write occurs next cycle
wire [511:0] rd_data;                    // read data out of ram

memresp_fifo_flopram_rwsa_448x512 ram (
      .clk( clk )
    , .di        ( wr_data )
    , .we        ( ram_we )
    , .wa        ( wr_adr )
    , .ra        ( rd_adr )
    , .dout        ( rd_data )
    );

wire   rd_popping;              // read side doing pop this cycle?

wire [8:0] rd_adr_next_popping = (rd_adr == 9'd447) ? 9'd0 : (rd_adr + 1'd1);
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_adr <=  9'd0;
    end else begin
        if ( rd_popping ) begin
	    rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
//VCS coverage off 
            else if ( !rd_popping ) begin
        end else begin
            rd_adr <=  {9{1'b0}};
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

reg  [8:0] rd_count;			// read-side fifo count
// spyglass disable_block W164a
wire [8:0] rd_count_next_rd_popping = rd_pushing ? rd_count : 
                                                                (rd_count - 1'd1);
wire [8:0] rd_count_next_no_rd_popping =  rd_pushing ? (rd_count + 1'd1) : 
                                                                    rd_count;
// spyglass enable_block W164a
wire [8:0] rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
wire rd_count_next_rd_popping_not_0 = rd_count_next_rd_popping != 0;
wire rd_count_next_no_rd_popping_not_0 = rd_count_next_no_rd_popping != 0;
wire rd_count_next_not_0 = rd_popping ? rd_count_next_rd_popping_not_0 :
                                              rd_count_next_no_rd_popping_not_0;
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_count <=  9'd0;
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
            rd_count <=  {9{1'b0}};
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
assign wr_limit_muxed = `EMU_FIFO_CFG.memresp_fifo_wr_limit_override ? `EMU_FIFO_CFG.memresp_fifo_wr_limit : 9'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 9'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 9'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 9'd0;

`else  

// RTL Simulation Plusarg Override

// verilint 372 off - undefined PLI task
// verilint 430 off - initial statement
// verilint 182 off - illegal statement for synthesis
// verilint 599 off - not supported by Synopsys

// VCS coverage off

reg wr_limit_override;
reg [8:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 9'd0;
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
    if ( $test$plusargs( "memresp_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs("memresp_fifo_wr_limit", wr_limit_override_value);
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

    if ( $test$plusargs( "memresp_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs("memresp_fifo_fifo_stall_probability", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs("default_fifo_stall_probability", stall_probability);
    end

    if ( $test$plusargs( "memresp_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs("memresp_fifo_fifo_stall_cycles_min", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs("default_fifo_stall_cycles_min", stall_cycles_min);
    end

    if ( $test$plusargs( "memresp_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs("memresp_fifo_fifo_stall_cycles_max", stall_cycles_max);
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
    if ( ! $test$plusargs( "memresp_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "memresp_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "memresp_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
    , .max      ( {23'd0, (wr_limit_reg == 9'd0) ? 9'd448 : wr_limit_reg} )
    , .curr	( {23'd0, wr_count} )
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
            // wr_count==448
            testpoint_0_goal_0 = 1'b1;
            //VCS coverage off
        else
            testpoint_0_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_0_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
        if (testpoint_0_internal_wr_testpoint_reset_) begin
            if ((wr_count==448) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk)
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
    wire testpoint_0_goal_0_active = ((wr_count==448) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk);

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
            // wr_count==448 && wr_req
            testpoint_1_goal_0 = 1'b1;
            //VCS coverage off
        else
            testpoint_1_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_1_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
        if (testpoint_1_internal_wr_testpoint_reset_) begin
            if ((wr_count==448 && wr_req) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk)
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
    wire testpoint_1_goal_0_active = ((wr_count==448 && wr_req) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk);

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
//   set_boundary_optimization find(design, "memresp_fifo") true
// synopsys dc_script_end

endmodule // memresp_fifo

// 
// Flop-Based RAM 
//
module memresp_fifo_flopram_rwsa_448x512 (
      clk
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input  [511:0] di;
input  we;
input  [8:0] wa;
input  [8:0] ra;
output [511:0] dout;

reg [511:0] ram_ff0;
reg [511:0] ram_ff1;
reg [511:0] ram_ff2;
reg [511:0] ram_ff3;
reg [511:0] ram_ff4;
reg [511:0] ram_ff5;
reg [511:0] ram_ff6;
reg [511:0] ram_ff7;
reg [511:0] ram_ff8;
reg [511:0] ram_ff9;
reg [511:0] ram_ff10;
reg [511:0] ram_ff11;
reg [511:0] ram_ff12;
reg [511:0] ram_ff13;
reg [511:0] ram_ff14;
reg [511:0] ram_ff15;
reg [511:0] ram_ff16;
reg [511:0] ram_ff17;
reg [511:0] ram_ff18;
reg [511:0] ram_ff19;
reg [511:0] ram_ff20;
reg [511:0] ram_ff21;
reg [511:0] ram_ff22;
reg [511:0] ram_ff23;
reg [511:0] ram_ff24;
reg [511:0] ram_ff25;
reg [511:0] ram_ff26;
reg [511:0] ram_ff27;
reg [511:0] ram_ff28;
reg [511:0] ram_ff29;
reg [511:0] ram_ff30;
reg [511:0] ram_ff31;
reg [511:0] ram_ff32;
reg [511:0] ram_ff33;
reg [511:0] ram_ff34;
reg [511:0] ram_ff35;
reg [511:0] ram_ff36;
reg [511:0] ram_ff37;
reg [511:0] ram_ff38;
reg [511:0] ram_ff39;
reg [511:0] ram_ff40;
reg [511:0] ram_ff41;
reg [511:0] ram_ff42;
reg [511:0] ram_ff43;
reg [511:0] ram_ff44;
reg [511:0] ram_ff45;
reg [511:0] ram_ff46;
reg [511:0] ram_ff47;
reg [511:0] ram_ff48;
reg [511:0] ram_ff49;
reg [511:0] ram_ff50;
reg [511:0] ram_ff51;
reg [511:0] ram_ff52;
reg [511:0] ram_ff53;
reg [511:0] ram_ff54;
reg [511:0] ram_ff55;
reg [511:0] ram_ff56;
reg [511:0] ram_ff57;
reg [511:0] ram_ff58;
reg [511:0] ram_ff59;
reg [511:0] ram_ff60;
reg [511:0] ram_ff61;
reg [511:0] ram_ff62;
reg [511:0] ram_ff63;
reg [511:0] ram_ff64;
reg [511:0] ram_ff65;
reg [511:0] ram_ff66;
reg [511:0] ram_ff67;
reg [511:0] ram_ff68;
reg [511:0] ram_ff69;
reg [511:0] ram_ff70;
reg [511:0] ram_ff71;
reg [511:0] ram_ff72;
reg [511:0] ram_ff73;
reg [511:0] ram_ff74;
reg [511:0] ram_ff75;
reg [511:0] ram_ff76;
reg [511:0] ram_ff77;
reg [511:0] ram_ff78;
reg [511:0] ram_ff79;
reg [511:0] ram_ff80;
reg [511:0] ram_ff81;
reg [511:0] ram_ff82;
reg [511:0] ram_ff83;
reg [511:0] ram_ff84;
reg [511:0] ram_ff85;
reg [511:0] ram_ff86;
reg [511:0] ram_ff87;
reg [511:0] ram_ff88;
reg [511:0] ram_ff89;
reg [511:0] ram_ff90;
reg [511:0] ram_ff91;
reg [511:0] ram_ff92;
reg [511:0] ram_ff93;
reg [511:0] ram_ff94;
reg [511:0] ram_ff95;
reg [511:0] ram_ff96;
reg [511:0] ram_ff97;
reg [511:0] ram_ff98;
reg [511:0] ram_ff99;
reg [511:0] ram_ff100;
reg [511:0] ram_ff101;
reg [511:0] ram_ff102;
reg [511:0] ram_ff103;
reg [511:0] ram_ff104;
reg [511:0] ram_ff105;
reg [511:0] ram_ff106;
reg [511:0] ram_ff107;
reg [511:0] ram_ff108;
reg [511:0] ram_ff109;
reg [511:0] ram_ff110;
reg [511:0] ram_ff111;
reg [511:0] ram_ff112;
reg [511:0] ram_ff113;
reg [511:0] ram_ff114;
reg [511:0] ram_ff115;
reg [511:0] ram_ff116;
reg [511:0] ram_ff117;
reg [511:0] ram_ff118;
reg [511:0] ram_ff119;
reg [511:0] ram_ff120;
reg [511:0] ram_ff121;
reg [511:0] ram_ff122;
reg [511:0] ram_ff123;
reg [511:0] ram_ff124;
reg [511:0] ram_ff125;
reg [511:0] ram_ff126;
reg [511:0] ram_ff127;
reg [511:0] ram_ff128;
reg [511:0] ram_ff129;
reg [511:0] ram_ff130;
reg [511:0] ram_ff131;
reg [511:0] ram_ff132;
reg [511:0] ram_ff133;
reg [511:0] ram_ff134;
reg [511:0] ram_ff135;
reg [511:0] ram_ff136;
reg [511:0] ram_ff137;
reg [511:0] ram_ff138;
reg [511:0] ram_ff139;
reg [511:0] ram_ff140;
reg [511:0] ram_ff141;
reg [511:0] ram_ff142;
reg [511:0] ram_ff143;
reg [511:0] ram_ff144;
reg [511:0] ram_ff145;
reg [511:0] ram_ff146;
reg [511:0] ram_ff147;
reg [511:0] ram_ff148;
reg [511:0] ram_ff149;
reg [511:0] ram_ff150;
reg [511:0] ram_ff151;
reg [511:0] ram_ff152;
reg [511:0] ram_ff153;
reg [511:0] ram_ff154;
reg [511:0] ram_ff155;
reg [511:0] ram_ff156;
reg [511:0] ram_ff157;
reg [511:0] ram_ff158;
reg [511:0] ram_ff159;
reg [511:0] ram_ff160;
reg [511:0] ram_ff161;
reg [511:0] ram_ff162;
reg [511:0] ram_ff163;
reg [511:0] ram_ff164;
reg [511:0] ram_ff165;
reg [511:0] ram_ff166;
reg [511:0] ram_ff167;
reg [511:0] ram_ff168;
reg [511:0] ram_ff169;
reg [511:0] ram_ff170;
reg [511:0] ram_ff171;
reg [511:0] ram_ff172;
reg [511:0] ram_ff173;
reg [511:0] ram_ff174;
reg [511:0] ram_ff175;
reg [511:0] ram_ff176;
reg [511:0] ram_ff177;
reg [511:0] ram_ff178;
reg [511:0] ram_ff179;
reg [511:0] ram_ff180;
reg [511:0] ram_ff181;
reg [511:0] ram_ff182;
reg [511:0] ram_ff183;
reg [511:0] ram_ff184;
reg [511:0] ram_ff185;
reg [511:0] ram_ff186;
reg [511:0] ram_ff187;
reg [511:0] ram_ff188;
reg [511:0] ram_ff189;
reg [511:0] ram_ff190;
reg [511:0] ram_ff191;
reg [511:0] ram_ff192;
reg [511:0] ram_ff193;
reg [511:0] ram_ff194;
reg [511:0] ram_ff195;
reg [511:0] ram_ff196;
reg [511:0] ram_ff197;
reg [511:0] ram_ff198;
reg [511:0] ram_ff199;
reg [511:0] ram_ff200;
reg [511:0] ram_ff201;
reg [511:0] ram_ff202;
reg [511:0] ram_ff203;
reg [511:0] ram_ff204;
reg [511:0] ram_ff205;
reg [511:0] ram_ff206;
reg [511:0] ram_ff207;
reg [511:0] ram_ff208;
reg [511:0] ram_ff209;
reg [511:0] ram_ff210;
reg [511:0] ram_ff211;
reg [511:0] ram_ff212;
reg [511:0] ram_ff213;
reg [511:0] ram_ff214;
reg [511:0] ram_ff215;
reg [511:0] ram_ff216;
reg [511:0] ram_ff217;
reg [511:0] ram_ff218;
reg [511:0] ram_ff219;
reg [511:0] ram_ff220;
reg [511:0] ram_ff221;
reg [511:0] ram_ff222;
reg [511:0] ram_ff223;
reg [511:0] ram_ff224;
reg [511:0] ram_ff225;
reg [511:0] ram_ff226;
reg [511:0] ram_ff227;
reg [511:0] ram_ff228;
reg [511:0] ram_ff229;
reg [511:0] ram_ff230;
reg [511:0] ram_ff231;
reg [511:0] ram_ff232;
reg [511:0] ram_ff233;
reg [511:0] ram_ff234;
reg [511:0] ram_ff235;
reg [511:0] ram_ff236;
reg [511:0] ram_ff237;
reg [511:0] ram_ff238;
reg [511:0] ram_ff239;
reg [511:0] ram_ff240;
reg [511:0] ram_ff241;
reg [511:0] ram_ff242;
reg [511:0] ram_ff243;
reg [511:0] ram_ff244;
reg [511:0] ram_ff245;
reg [511:0] ram_ff246;
reg [511:0] ram_ff247;
reg [511:0] ram_ff248;
reg [511:0] ram_ff249;
reg [511:0] ram_ff250;
reg [511:0] ram_ff251;
reg [511:0] ram_ff252;
reg [511:0] ram_ff253;
reg [511:0] ram_ff254;
reg [511:0] ram_ff255;
reg [511:0] ram_ff256;
reg [511:0] ram_ff257;
reg [511:0] ram_ff258;
reg [511:0] ram_ff259;
reg [511:0] ram_ff260;
reg [511:0] ram_ff261;
reg [511:0] ram_ff262;
reg [511:0] ram_ff263;
reg [511:0] ram_ff264;
reg [511:0] ram_ff265;
reg [511:0] ram_ff266;
reg [511:0] ram_ff267;
reg [511:0] ram_ff268;
reg [511:0] ram_ff269;
reg [511:0] ram_ff270;
reg [511:0] ram_ff271;
reg [511:0] ram_ff272;
reg [511:0] ram_ff273;
reg [511:0] ram_ff274;
reg [511:0] ram_ff275;
reg [511:0] ram_ff276;
reg [511:0] ram_ff277;
reg [511:0] ram_ff278;
reg [511:0] ram_ff279;
reg [511:0] ram_ff280;
reg [511:0] ram_ff281;
reg [511:0] ram_ff282;
reg [511:0] ram_ff283;
reg [511:0] ram_ff284;
reg [511:0] ram_ff285;
reg [511:0] ram_ff286;
reg [511:0] ram_ff287;
reg [511:0] ram_ff288;
reg [511:0] ram_ff289;
reg [511:0] ram_ff290;
reg [511:0] ram_ff291;
reg [511:0] ram_ff292;
reg [511:0] ram_ff293;
reg [511:0] ram_ff294;
reg [511:0] ram_ff295;
reg [511:0] ram_ff296;
reg [511:0] ram_ff297;
reg [511:0] ram_ff298;
reg [511:0] ram_ff299;
reg [511:0] ram_ff300;
reg [511:0] ram_ff301;
reg [511:0] ram_ff302;
reg [511:0] ram_ff303;
reg [511:0] ram_ff304;
reg [511:0] ram_ff305;
reg [511:0] ram_ff306;
reg [511:0] ram_ff307;
reg [511:0] ram_ff308;
reg [511:0] ram_ff309;
reg [511:0] ram_ff310;
reg [511:0] ram_ff311;
reg [511:0] ram_ff312;
reg [511:0] ram_ff313;
reg [511:0] ram_ff314;
reg [511:0] ram_ff315;
reg [511:0] ram_ff316;
reg [511:0] ram_ff317;
reg [511:0] ram_ff318;
reg [511:0] ram_ff319;
reg [511:0] ram_ff320;
reg [511:0] ram_ff321;
reg [511:0] ram_ff322;
reg [511:0] ram_ff323;
reg [511:0] ram_ff324;
reg [511:0] ram_ff325;
reg [511:0] ram_ff326;
reg [511:0] ram_ff327;
reg [511:0] ram_ff328;
reg [511:0] ram_ff329;
reg [511:0] ram_ff330;
reg [511:0] ram_ff331;
reg [511:0] ram_ff332;
reg [511:0] ram_ff333;
reg [511:0] ram_ff334;
reg [511:0] ram_ff335;
reg [511:0] ram_ff336;
reg [511:0] ram_ff337;
reg [511:0] ram_ff338;
reg [511:0] ram_ff339;
reg [511:0] ram_ff340;
reg [511:0] ram_ff341;
reg [511:0] ram_ff342;
reg [511:0] ram_ff343;
reg [511:0] ram_ff344;
reg [511:0] ram_ff345;
reg [511:0] ram_ff346;
reg [511:0] ram_ff347;
reg [511:0] ram_ff348;
reg [511:0] ram_ff349;
reg [511:0] ram_ff350;
reg [511:0] ram_ff351;
reg [511:0] ram_ff352;
reg [511:0] ram_ff353;
reg [511:0] ram_ff354;
reg [511:0] ram_ff355;
reg [511:0] ram_ff356;
reg [511:0] ram_ff357;
reg [511:0] ram_ff358;
reg [511:0] ram_ff359;
reg [511:0] ram_ff360;
reg [511:0] ram_ff361;
reg [511:0] ram_ff362;
reg [511:0] ram_ff363;
reg [511:0] ram_ff364;
reg [511:0] ram_ff365;
reg [511:0] ram_ff366;
reg [511:0] ram_ff367;
reg [511:0] ram_ff368;
reg [511:0] ram_ff369;
reg [511:0] ram_ff370;
reg [511:0] ram_ff371;
reg [511:0] ram_ff372;
reg [511:0] ram_ff373;
reg [511:0] ram_ff374;
reg [511:0] ram_ff375;
reg [511:0] ram_ff376;
reg [511:0] ram_ff377;
reg [511:0] ram_ff378;
reg [511:0] ram_ff379;
reg [511:0] ram_ff380;
reg [511:0] ram_ff381;
reg [511:0] ram_ff382;
reg [511:0] ram_ff383;
reg [511:0] ram_ff384;
reg [511:0] ram_ff385;
reg [511:0] ram_ff386;
reg [511:0] ram_ff387;
reg [511:0] ram_ff388;
reg [511:0] ram_ff389;
reg [511:0] ram_ff390;
reg [511:0] ram_ff391;
reg [511:0] ram_ff392;
reg [511:0] ram_ff393;
reg [511:0] ram_ff394;
reg [511:0] ram_ff395;
reg [511:0] ram_ff396;
reg [511:0] ram_ff397;
reg [511:0] ram_ff398;
reg [511:0] ram_ff399;
reg [511:0] ram_ff400;
reg [511:0] ram_ff401;
reg [511:0] ram_ff402;
reg [511:0] ram_ff403;
reg [511:0] ram_ff404;
reg [511:0] ram_ff405;
reg [511:0] ram_ff406;
reg [511:0] ram_ff407;
reg [511:0] ram_ff408;
reg [511:0] ram_ff409;
reg [511:0] ram_ff410;
reg [511:0] ram_ff411;
reg [511:0] ram_ff412;
reg [511:0] ram_ff413;
reg [511:0] ram_ff414;
reg [511:0] ram_ff415;
reg [511:0] ram_ff416;
reg [511:0] ram_ff417;
reg [511:0] ram_ff418;
reg [511:0] ram_ff419;
reg [511:0] ram_ff420;
reg [511:0] ram_ff421;
reg [511:0] ram_ff422;
reg [511:0] ram_ff423;
reg [511:0] ram_ff424;
reg [511:0] ram_ff425;
reg [511:0] ram_ff426;
reg [511:0] ram_ff427;
reg [511:0] ram_ff428;
reg [511:0] ram_ff429;
reg [511:0] ram_ff430;
reg [511:0] ram_ff431;
reg [511:0] ram_ff432;
reg [511:0] ram_ff433;
reg [511:0] ram_ff434;
reg [511:0] ram_ff435;
reg [511:0] ram_ff436;
reg [511:0] ram_ff437;
reg [511:0] ram_ff438;
reg [511:0] ram_ff439;
reg [511:0] ram_ff440;
reg [511:0] ram_ff441;
reg [511:0] ram_ff442;
reg [511:0] ram_ff443;
reg [511:0] ram_ff444;
reg [511:0] ram_ff445;
reg [511:0] ram_ff446;
reg [511:0] ram_ff447;

always @( posedge clk ) begin
    if ( we && wa == 9'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 9'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 9'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 9'd3 ) begin
	ram_ff3 <=  di;
    end
    if ( we && wa == 9'd4 ) begin
	ram_ff4 <=  di;
    end
    if ( we && wa == 9'd5 ) begin
	ram_ff5 <=  di;
    end
    if ( we && wa == 9'd6 ) begin
	ram_ff6 <=  di;
    end
    if ( we && wa == 9'd7 ) begin
	ram_ff7 <=  di;
    end
    if ( we && wa == 9'd8 ) begin
	ram_ff8 <=  di;
    end
    if ( we && wa == 9'd9 ) begin
	ram_ff9 <=  di;
    end
    if ( we && wa == 9'd10 ) begin
	ram_ff10 <=  di;
    end
    if ( we && wa == 9'd11 ) begin
	ram_ff11 <=  di;
    end
    if ( we && wa == 9'd12 ) begin
	ram_ff12 <=  di;
    end
    if ( we && wa == 9'd13 ) begin
	ram_ff13 <=  di;
    end
    if ( we && wa == 9'd14 ) begin
	ram_ff14 <=  di;
    end
    if ( we && wa == 9'd15 ) begin
	ram_ff15 <=  di;
    end
    if ( we && wa == 9'd16 ) begin
	ram_ff16 <=  di;
    end
    if ( we && wa == 9'd17 ) begin
	ram_ff17 <=  di;
    end
    if ( we && wa == 9'd18 ) begin
	ram_ff18 <=  di;
    end
    if ( we && wa == 9'd19 ) begin
	ram_ff19 <=  di;
    end
    if ( we && wa == 9'd20 ) begin
	ram_ff20 <=  di;
    end
    if ( we && wa == 9'd21 ) begin
	ram_ff21 <=  di;
    end
    if ( we && wa == 9'd22 ) begin
	ram_ff22 <=  di;
    end
    if ( we && wa == 9'd23 ) begin
	ram_ff23 <=  di;
    end
    if ( we && wa == 9'd24 ) begin
	ram_ff24 <=  di;
    end
    if ( we && wa == 9'd25 ) begin
	ram_ff25 <=  di;
    end
    if ( we && wa == 9'd26 ) begin
	ram_ff26 <=  di;
    end
    if ( we && wa == 9'd27 ) begin
	ram_ff27 <=  di;
    end
    if ( we && wa == 9'd28 ) begin
	ram_ff28 <=  di;
    end
    if ( we && wa == 9'd29 ) begin
	ram_ff29 <=  di;
    end
    if ( we && wa == 9'd30 ) begin
	ram_ff30 <=  di;
    end
    if ( we && wa == 9'd31 ) begin
	ram_ff31 <=  di;
    end
    if ( we && wa == 9'd32 ) begin
	ram_ff32 <=  di;
    end
    if ( we && wa == 9'd33 ) begin
	ram_ff33 <=  di;
    end
    if ( we && wa == 9'd34 ) begin
	ram_ff34 <=  di;
    end
    if ( we && wa == 9'd35 ) begin
	ram_ff35 <=  di;
    end
    if ( we && wa == 9'd36 ) begin
	ram_ff36 <=  di;
    end
    if ( we && wa == 9'd37 ) begin
	ram_ff37 <=  di;
    end
    if ( we && wa == 9'd38 ) begin
	ram_ff38 <=  di;
    end
    if ( we && wa == 9'd39 ) begin
	ram_ff39 <=  di;
    end
    if ( we && wa == 9'd40 ) begin
	ram_ff40 <=  di;
    end
    if ( we && wa == 9'd41 ) begin
	ram_ff41 <=  di;
    end
    if ( we && wa == 9'd42 ) begin
	ram_ff42 <=  di;
    end
    if ( we && wa == 9'd43 ) begin
	ram_ff43 <=  di;
    end
    if ( we && wa == 9'd44 ) begin
	ram_ff44 <=  di;
    end
    if ( we && wa == 9'd45 ) begin
	ram_ff45 <=  di;
    end
    if ( we && wa == 9'd46 ) begin
	ram_ff46 <=  di;
    end
    if ( we && wa == 9'd47 ) begin
	ram_ff47 <=  di;
    end
    if ( we && wa == 9'd48 ) begin
	ram_ff48 <=  di;
    end
    if ( we && wa == 9'd49 ) begin
	ram_ff49 <=  di;
    end
    if ( we && wa == 9'd50 ) begin
	ram_ff50 <=  di;
    end
    if ( we && wa == 9'd51 ) begin
	ram_ff51 <=  di;
    end
    if ( we && wa == 9'd52 ) begin
	ram_ff52 <=  di;
    end
    if ( we && wa == 9'd53 ) begin
	ram_ff53 <=  di;
    end
    if ( we && wa == 9'd54 ) begin
	ram_ff54 <=  di;
    end
    if ( we && wa == 9'd55 ) begin
	ram_ff55 <=  di;
    end
    if ( we && wa == 9'd56 ) begin
	ram_ff56 <=  di;
    end
    if ( we && wa == 9'd57 ) begin
	ram_ff57 <=  di;
    end
    if ( we && wa == 9'd58 ) begin
	ram_ff58 <=  di;
    end
    if ( we && wa == 9'd59 ) begin
	ram_ff59 <=  di;
    end
    if ( we && wa == 9'd60 ) begin
	ram_ff60 <=  di;
    end
    if ( we && wa == 9'd61 ) begin
	ram_ff61 <=  di;
    end
    if ( we && wa == 9'd62 ) begin
	ram_ff62 <=  di;
    end
    if ( we && wa == 9'd63 ) begin
	ram_ff63 <=  di;
    end
    if ( we && wa == 9'd64 ) begin
	ram_ff64 <=  di;
    end
    if ( we && wa == 9'd65 ) begin
	ram_ff65 <=  di;
    end
    if ( we && wa == 9'd66 ) begin
	ram_ff66 <=  di;
    end
    if ( we && wa == 9'd67 ) begin
	ram_ff67 <=  di;
    end
    if ( we && wa == 9'd68 ) begin
	ram_ff68 <=  di;
    end
    if ( we && wa == 9'd69 ) begin
	ram_ff69 <=  di;
    end
    if ( we && wa == 9'd70 ) begin
	ram_ff70 <=  di;
    end
    if ( we && wa == 9'd71 ) begin
	ram_ff71 <=  di;
    end
    if ( we && wa == 9'd72 ) begin
	ram_ff72 <=  di;
    end
    if ( we && wa == 9'd73 ) begin
	ram_ff73 <=  di;
    end
    if ( we && wa == 9'd74 ) begin
	ram_ff74 <=  di;
    end
    if ( we && wa == 9'd75 ) begin
	ram_ff75 <=  di;
    end
    if ( we && wa == 9'd76 ) begin
	ram_ff76 <=  di;
    end
    if ( we && wa == 9'd77 ) begin
	ram_ff77 <=  di;
    end
    if ( we && wa == 9'd78 ) begin
	ram_ff78 <=  di;
    end
    if ( we && wa == 9'd79 ) begin
	ram_ff79 <=  di;
    end
    if ( we && wa == 9'd80 ) begin
	ram_ff80 <=  di;
    end
    if ( we && wa == 9'd81 ) begin
	ram_ff81 <=  di;
    end
    if ( we && wa == 9'd82 ) begin
	ram_ff82 <=  di;
    end
    if ( we && wa == 9'd83 ) begin
	ram_ff83 <=  di;
    end
    if ( we && wa == 9'd84 ) begin
	ram_ff84 <=  di;
    end
    if ( we && wa == 9'd85 ) begin
	ram_ff85 <=  di;
    end
    if ( we && wa == 9'd86 ) begin
	ram_ff86 <=  di;
    end
    if ( we && wa == 9'd87 ) begin
	ram_ff87 <=  di;
    end
    if ( we && wa == 9'd88 ) begin
	ram_ff88 <=  di;
    end
    if ( we && wa == 9'd89 ) begin
	ram_ff89 <=  di;
    end
    if ( we && wa == 9'd90 ) begin
	ram_ff90 <=  di;
    end
    if ( we && wa == 9'd91 ) begin
	ram_ff91 <=  di;
    end
    if ( we && wa == 9'd92 ) begin
	ram_ff92 <=  di;
    end
    if ( we && wa == 9'd93 ) begin
	ram_ff93 <=  di;
    end
    if ( we && wa == 9'd94 ) begin
	ram_ff94 <=  di;
    end
    if ( we && wa == 9'd95 ) begin
	ram_ff95 <=  di;
    end
    if ( we && wa == 9'd96 ) begin
	ram_ff96 <=  di;
    end
    if ( we && wa == 9'd97 ) begin
	ram_ff97 <=  di;
    end
    if ( we && wa == 9'd98 ) begin
	ram_ff98 <=  di;
    end
    if ( we && wa == 9'd99 ) begin
	ram_ff99 <=  di;
    end
    if ( we && wa == 9'd100 ) begin
	ram_ff100 <=  di;
    end
    if ( we && wa == 9'd101 ) begin
	ram_ff101 <=  di;
    end
    if ( we && wa == 9'd102 ) begin
	ram_ff102 <=  di;
    end
    if ( we && wa == 9'd103 ) begin
	ram_ff103 <=  di;
    end
    if ( we && wa == 9'd104 ) begin
	ram_ff104 <=  di;
    end
    if ( we && wa == 9'd105 ) begin
	ram_ff105 <=  di;
    end
    if ( we && wa == 9'd106 ) begin
	ram_ff106 <=  di;
    end
    if ( we && wa == 9'd107 ) begin
	ram_ff107 <=  di;
    end
    if ( we && wa == 9'd108 ) begin
	ram_ff108 <=  di;
    end
    if ( we && wa == 9'd109 ) begin
	ram_ff109 <=  di;
    end
    if ( we && wa == 9'd110 ) begin
	ram_ff110 <=  di;
    end
    if ( we && wa == 9'd111 ) begin
	ram_ff111 <=  di;
    end
    if ( we && wa == 9'd112 ) begin
	ram_ff112 <=  di;
    end
    if ( we && wa == 9'd113 ) begin
	ram_ff113 <=  di;
    end
    if ( we && wa == 9'd114 ) begin
	ram_ff114 <=  di;
    end
    if ( we && wa == 9'd115 ) begin
	ram_ff115 <=  di;
    end
    if ( we && wa == 9'd116 ) begin
	ram_ff116 <=  di;
    end
    if ( we && wa == 9'd117 ) begin
	ram_ff117 <=  di;
    end
    if ( we && wa == 9'd118 ) begin
	ram_ff118 <=  di;
    end
    if ( we && wa == 9'd119 ) begin
	ram_ff119 <=  di;
    end
    if ( we && wa == 9'd120 ) begin
	ram_ff120 <=  di;
    end
    if ( we && wa == 9'd121 ) begin
	ram_ff121 <=  di;
    end
    if ( we && wa == 9'd122 ) begin
	ram_ff122 <=  di;
    end
    if ( we && wa == 9'd123 ) begin
	ram_ff123 <=  di;
    end
    if ( we && wa == 9'd124 ) begin
	ram_ff124 <=  di;
    end
    if ( we && wa == 9'd125 ) begin
	ram_ff125 <=  di;
    end
    if ( we && wa == 9'd126 ) begin
	ram_ff126 <=  di;
    end
    if ( we && wa == 9'd127 ) begin
	ram_ff127 <=  di;
    end
    if ( we && wa == 9'd128 ) begin
	ram_ff128 <=  di;
    end
    if ( we && wa == 9'd129 ) begin
	ram_ff129 <=  di;
    end
    if ( we && wa == 9'd130 ) begin
	ram_ff130 <=  di;
    end
    if ( we && wa == 9'd131 ) begin
	ram_ff131 <=  di;
    end
    if ( we && wa == 9'd132 ) begin
	ram_ff132 <=  di;
    end
    if ( we && wa == 9'd133 ) begin
	ram_ff133 <=  di;
    end
    if ( we && wa == 9'd134 ) begin
	ram_ff134 <=  di;
    end
    if ( we && wa == 9'd135 ) begin
	ram_ff135 <=  di;
    end
    if ( we && wa == 9'd136 ) begin
	ram_ff136 <=  di;
    end
    if ( we && wa == 9'd137 ) begin
	ram_ff137 <=  di;
    end
    if ( we && wa == 9'd138 ) begin
	ram_ff138 <=  di;
    end
    if ( we && wa == 9'd139 ) begin
	ram_ff139 <=  di;
    end
    if ( we && wa == 9'd140 ) begin
	ram_ff140 <=  di;
    end
    if ( we && wa == 9'd141 ) begin
	ram_ff141 <=  di;
    end
    if ( we && wa == 9'd142 ) begin
	ram_ff142 <=  di;
    end
    if ( we && wa == 9'd143 ) begin
	ram_ff143 <=  di;
    end
    if ( we && wa == 9'd144 ) begin
	ram_ff144 <=  di;
    end
    if ( we && wa == 9'd145 ) begin
	ram_ff145 <=  di;
    end
    if ( we && wa == 9'd146 ) begin
	ram_ff146 <=  di;
    end
    if ( we && wa == 9'd147 ) begin
	ram_ff147 <=  di;
    end
    if ( we && wa == 9'd148 ) begin
	ram_ff148 <=  di;
    end
    if ( we && wa == 9'd149 ) begin
	ram_ff149 <=  di;
    end
    if ( we && wa == 9'd150 ) begin
	ram_ff150 <=  di;
    end
    if ( we && wa == 9'd151 ) begin
	ram_ff151 <=  di;
    end
    if ( we && wa == 9'd152 ) begin
	ram_ff152 <=  di;
    end
    if ( we && wa == 9'd153 ) begin
	ram_ff153 <=  di;
    end
    if ( we && wa == 9'd154 ) begin
	ram_ff154 <=  di;
    end
    if ( we && wa == 9'd155 ) begin
	ram_ff155 <=  di;
    end
    if ( we && wa == 9'd156 ) begin
	ram_ff156 <=  di;
    end
    if ( we && wa == 9'd157 ) begin
	ram_ff157 <=  di;
    end
    if ( we && wa == 9'd158 ) begin
	ram_ff158 <=  di;
    end
    if ( we && wa == 9'd159 ) begin
	ram_ff159 <=  di;
    end
    if ( we && wa == 9'd160 ) begin
	ram_ff160 <=  di;
    end
    if ( we && wa == 9'd161 ) begin
	ram_ff161 <=  di;
    end
    if ( we && wa == 9'd162 ) begin
	ram_ff162 <=  di;
    end
    if ( we && wa == 9'd163 ) begin
	ram_ff163 <=  di;
    end
    if ( we && wa == 9'd164 ) begin
	ram_ff164 <=  di;
    end
    if ( we && wa == 9'd165 ) begin
	ram_ff165 <=  di;
    end
    if ( we && wa == 9'd166 ) begin
	ram_ff166 <=  di;
    end
    if ( we && wa == 9'd167 ) begin
	ram_ff167 <=  di;
    end
    if ( we && wa == 9'd168 ) begin
	ram_ff168 <=  di;
    end
    if ( we && wa == 9'd169 ) begin
	ram_ff169 <=  di;
    end
    if ( we && wa == 9'd170 ) begin
	ram_ff170 <=  di;
    end
    if ( we && wa == 9'd171 ) begin
	ram_ff171 <=  di;
    end
    if ( we && wa == 9'd172 ) begin
	ram_ff172 <=  di;
    end
    if ( we && wa == 9'd173 ) begin
	ram_ff173 <=  di;
    end
    if ( we && wa == 9'd174 ) begin
	ram_ff174 <=  di;
    end
    if ( we && wa == 9'd175 ) begin
	ram_ff175 <=  di;
    end
    if ( we && wa == 9'd176 ) begin
	ram_ff176 <=  di;
    end
    if ( we && wa == 9'd177 ) begin
	ram_ff177 <=  di;
    end
    if ( we && wa == 9'd178 ) begin
	ram_ff178 <=  di;
    end
    if ( we && wa == 9'd179 ) begin
	ram_ff179 <=  di;
    end
    if ( we && wa == 9'd180 ) begin
	ram_ff180 <=  di;
    end
    if ( we && wa == 9'd181 ) begin
	ram_ff181 <=  di;
    end
    if ( we && wa == 9'd182 ) begin
	ram_ff182 <=  di;
    end
    if ( we && wa == 9'd183 ) begin
	ram_ff183 <=  di;
    end
    if ( we && wa == 9'd184 ) begin
	ram_ff184 <=  di;
    end
    if ( we && wa == 9'd185 ) begin
	ram_ff185 <=  di;
    end
    if ( we && wa == 9'd186 ) begin
	ram_ff186 <=  di;
    end
    if ( we && wa == 9'd187 ) begin
	ram_ff187 <=  di;
    end
    if ( we && wa == 9'd188 ) begin
	ram_ff188 <=  di;
    end
    if ( we && wa == 9'd189 ) begin
	ram_ff189 <=  di;
    end
    if ( we && wa == 9'd190 ) begin
	ram_ff190 <=  di;
    end
    if ( we && wa == 9'd191 ) begin
	ram_ff191 <=  di;
    end
    if ( we && wa == 9'd192 ) begin
	ram_ff192 <=  di;
    end
    if ( we && wa == 9'd193 ) begin
	ram_ff193 <=  di;
    end
    if ( we && wa == 9'd194 ) begin
	ram_ff194 <=  di;
    end
    if ( we && wa == 9'd195 ) begin
	ram_ff195 <=  di;
    end
    if ( we && wa == 9'd196 ) begin
	ram_ff196 <=  di;
    end
    if ( we && wa == 9'd197 ) begin
	ram_ff197 <=  di;
    end
    if ( we && wa == 9'd198 ) begin
	ram_ff198 <=  di;
    end
    if ( we && wa == 9'd199 ) begin
	ram_ff199 <=  di;
    end
    if ( we && wa == 9'd200 ) begin
	ram_ff200 <=  di;
    end
    if ( we && wa == 9'd201 ) begin
	ram_ff201 <=  di;
    end
    if ( we && wa == 9'd202 ) begin
	ram_ff202 <=  di;
    end
    if ( we && wa == 9'd203 ) begin
	ram_ff203 <=  di;
    end
    if ( we && wa == 9'd204 ) begin
	ram_ff204 <=  di;
    end
    if ( we && wa == 9'd205 ) begin
	ram_ff205 <=  di;
    end
    if ( we && wa == 9'd206 ) begin
	ram_ff206 <=  di;
    end
    if ( we && wa == 9'd207 ) begin
	ram_ff207 <=  di;
    end
    if ( we && wa == 9'd208 ) begin
	ram_ff208 <=  di;
    end
    if ( we && wa == 9'd209 ) begin
	ram_ff209 <=  di;
    end
    if ( we && wa == 9'd210 ) begin
	ram_ff210 <=  di;
    end
    if ( we && wa == 9'd211 ) begin
	ram_ff211 <=  di;
    end
    if ( we && wa == 9'd212 ) begin
	ram_ff212 <=  di;
    end
    if ( we && wa == 9'd213 ) begin
	ram_ff213 <=  di;
    end
    if ( we && wa == 9'd214 ) begin
	ram_ff214 <=  di;
    end
    if ( we && wa == 9'd215 ) begin
	ram_ff215 <=  di;
    end
    if ( we && wa == 9'd216 ) begin
	ram_ff216 <=  di;
    end
    if ( we && wa == 9'd217 ) begin
	ram_ff217 <=  di;
    end
    if ( we && wa == 9'd218 ) begin
	ram_ff218 <=  di;
    end
    if ( we && wa == 9'd219 ) begin
	ram_ff219 <=  di;
    end
    if ( we && wa == 9'd220 ) begin
	ram_ff220 <=  di;
    end
    if ( we && wa == 9'd221 ) begin
	ram_ff221 <=  di;
    end
    if ( we && wa == 9'd222 ) begin
	ram_ff222 <=  di;
    end
    if ( we && wa == 9'd223 ) begin
	ram_ff223 <=  di;
    end
    if ( we && wa == 9'd224 ) begin
	ram_ff224 <=  di;
    end
    if ( we && wa == 9'd225 ) begin
	ram_ff225 <=  di;
    end
    if ( we && wa == 9'd226 ) begin
	ram_ff226 <=  di;
    end
    if ( we && wa == 9'd227 ) begin
	ram_ff227 <=  di;
    end
    if ( we && wa == 9'd228 ) begin
	ram_ff228 <=  di;
    end
    if ( we && wa == 9'd229 ) begin
	ram_ff229 <=  di;
    end
    if ( we && wa == 9'd230 ) begin
	ram_ff230 <=  di;
    end
    if ( we && wa == 9'd231 ) begin
	ram_ff231 <=  di;
    end
    if ( we && wa == 9'd232 ) begin
	ram_ff232 <=  di;
    end
    if ( we && wa == 9'd233 ) begin
	ram_ff233 <=  di;
    end
    if ( we && wa == 9'd234 ) begin
	ram_ff234 <=  di;
    end
    if ( we && wa == 9'd235 ) begin
	ram_ff235 <=  di;
    end
    if ( we && wa == 9'd236 ) begin
	ram_ff236 <=  di;
    end
    if ( we && wa == 9'd237 ) begin
	ram_ff237 <=  di;
    end
    if ( we && wa == 9'd238 ) begin
	ram_ff238 <=  di;
    end
    if ( we && wa == 9'd239 ) begin
	ram_ff239 <=  di;
    end
    if ( we && wa == 9'd240 ) begin
	ram_ff240 <=  di;
    end
    if ( we && wa == 9'd241 ) begin
	ram_ff241 <=  di;
    end
    if ( we && wa == 9'd242 ) begin
	ram_ff242 <=  di;
    end
    if ( we && wa == 9'd243 ) begin
	ram_ff243 <=  di;
    end
    if ( we && wa == 9'd244 ) begin
	ram_ff244 <=  di;
    end
    if ( we && wa == 9'd245 ) begin
	ram_ff245 <=  di;
    end
    if ( we && wa == 9'd246 ) begin
	ram_ff246 <=  di;
    end
    if ( we && wa == 9'd247 ) begin
	ram_ff247 <=  di;
    end
    if ( we && wa == 9'd248 ) begin
	ram_ff248 <=  di;
    end
    if ( we && wa == 9'd249 ) begin
	ram_ff249 <=  di;
    end
    if ( we && wa == 9'd250 ) begin
	ram_ff250 <=  di;
    end
    if ( we && wa == 9'd251 ) begin
	ram_ff251 <=  di;
    end
    if ( we && wa == 9'd252 ) begin
	ram_ff252 <=  di;
    end
    if ( we && wa == 9'd253 ) begin
	ram_ff253 <=  di;
    end
    if ( we && wa == 9'd254 ) begin
	ram_ff254 <=  di;
    end
    if ( we && wa == 9'd255 ) begin
	ram_ff255 <=  di;
    end
    if ( we && wa == 9'd256 ) begin
	ram_ff256 <=  di;
    end
    if ( we && wa == 9'd257 ) begin
	ram_ff257 <=  di;
    end
    if ( we && wa == 9'd258 ) begin
	ram_ff258 <=  di;
    end
    if ( we && wa == 9'd259 ) begin
	ram_ff259 <=  di;
    end
    if ( we && wa == 9'd260 ) begin
	ram_ff260 <=  di;
    end
    if ( we && wa == 9'd261 ) begin
	ram_ff261 <=  di;
    end
    if ( we && wa == 9'd262 ) begin
	ram_ff262 <=  di;
    end
    if ( we && wa == 9'd263 ) begin
	ram_ff263 <=  di;
    end
    if ( we && wa == 9'd264 ) begin
	ram_ff264 <=  di;
    end
    if ( we && wa == 9'd265 ) begin
	ram_ff265 <=  di;
    end
    if ( we && wa == 9'd266 ) begin
	ram_ff266 <=  di;
    end
    if ( we && wa == 9'd267 ) begin
	ram_ff267 <=  di;
    end
    if ( we && wa == 9'd268 ) begin
	ram_ff268 <=  di;
    end
    if ( we && wa == 9'd269 ) begin
	ram_ff269 <=  di;
    end
    if ( we && wa == 9'd270 ) begin
	ram_ff270 <=  di;
    end
    if ( we && wa == 9'd271 ) begin
	ram_ff271 <=  di;
    end
    if ( we && wa == 9'd272 ) begin
	ram_ff272 <=  di;
    end
    if ( we && wa == 9'd273 ) begin
	ram_ff273 <=  di;
    end
    if ( we && wa == 9'd274 ) begin
	ram_ff274 <=  di;
    end
    if ( we && wa == 9'd275 ) begin
	ram_ff275 <=  di;
    end
    if ( we && wa == 9'd276 ) begin
	ram_ff276 <=  di;
    end
    if ( we && wa == 9'd277 ) begin
	ram_ff277 <=  di;
    end
    if ( we && wa == 9'd278 ) begin
	ram_ff278 <=  di;
    end
    if ( we && wa == 9'd279 ) begin
	ram_ff279 <=  di;
    end
    if ( we && wa == 9'd280 ) begin
	ram_ff280 <=  di;
    end
    if ( we && wa == 9'd281 ) begin
	ram_ff281 <=  di;
    end
    if ( we && wa == 9'd282 ) begin
	ram_ff282 <=  di;
    end
    if ( we && wa == 9'd283 ) begin
	ram_ff283 <=  di;
    end
    if ( we && wa == 9'd284 ) begin
	ram_ff284 <=  di;
    end
    if ( we && wa == 9'd285 ) begin
	ram_ff285 <=  di;
    end
    if ( we && wa == 9'd286 ) begin
	ram_ff286 <=  di;
    end
    if ( we && wa == 9'd287 ) begin
	ram_ff287 <=  di;
    end
    if ( we && wa == 9'd288 ) begin
	ram_ff288 <=  di;
    end
    if ( we && wa == 9'd289 ) begin
	ram_ff289 <=  di;
    end
    if ( we && wa == 9'd290 ) begin
	ram_ff290 <=  di;
    end
    if ( we && wa == 9'd291 ) begin
	ram_ff291 <=  di;
    end
    if ( we && wa == 9'd292 ) begin
	ram_ff292 <=  di;
    end
    if ( we && wa == 9'd293 ) begin
	ram_ff293 <=  di;
    end
    if ( we && wa == 9'd294 ) begin
	ram_ff294 <=  di;
    end
    if ( we && wa == 9'd295 ) begin
	ram_ff295 <=  di;
    end
    if ( we && wa == 9'd296 ) begin
	ram_ff296 <=  di;
    end
    if ( we && wa == 9'd297 ) begin
	ram_ff297 <=  di;
    end
    if ( we && wa == 9'd298 ) begin
	ram_ff298 <=  di;
    end
    if ( we && wa == 9'd299 ) begin
	ram_ff299 <=  di;
    end
    if ( we && wa == 9'd300 ) begin
	ram_ff300 <=  di;
    end
    if ( we && wa == 9'd301 ) begin
	ram_ff301 <=  di;
    end
    if ( we && wa == 9'd302 ) begin
	ram_ff302 <=  di;
    end
    if ( we && wa == 9'd303 ) begin
	ram_ff303 <=  di;
    end
    if ( we && wa == 9'd304 ) begin
	ram_ff304 <=  di;
    end
    if ( we && wa == 9'd305 ) begin
	ram_ff305 <=  di;
    end
    if ( we && wa == 9'd306 ) begin
	ram_ff306 <=  di;
    end
    if ( we && wa == 9'd307 ) begin
	ram_ff307 <=  di;
    end
    if ( we && wa == 9'd308 ) begin
	ram_ff308 <=  di;
    end
    if ( we && wa == 9'd309 ) begin
	ram_ff309 <=  di;
    end
    if ( we && wa == 9'd310 ) begin
	ram_ff310 <=  di;
    end
    if ( we && wa == 9'd311 ) begin
	ram_ff311 <=  di;
    end
    if ( we && wa == 9'd312 ) begin
	ram_ff312 <=  di;
    end
    if ( we && wa == 9'd313 ) begin
	ram_ff313 <=  di;
    end
    if ( we && wa == 9'd314 ) begin
	ram_ff314 <=  di;
    end
    if ( we && wa == 9'd315 ) begin
	ram_ff315 <=  di;
    end
    if ( we && wa == 9'd316 ) begin
	ram_ff316 <=  di;
    end
    if ( we && wa == 9'd317 ) begin
	ram_ff317 <=  di;
    end
    if ( we && wa == 9'd318 ) begin
	ram_ff318 <=  di;
    end
    if ( we && wa == 9'd319 ) begin
	ram_ff319 <=  di;
    end
    if ( we && wa == 9'd320 ) begin
	ram_ff320 <=  di;
    end
    if ( we && wa == 9'd321 ) begin
	ram_ff321 <=  di;
    end
    if ( we && wa == 9'd322 ) begin
	ram_ff322 <=  di;
    end
    if ( we && wa == 9'd323 ) begin
	ram_ff323 <=  di;
    end
    if ( we && wa == 9'd324 ) begin
	ram_ff324 <=  di;
    end
    if ( we && wa == 9'd325 ) begin
	ram_ff325 <=  di;
    end
    if ( we && wa == 9'd326 ) begin
	ram_ff326 <=  di;
    end
    if ( we && wa == 9'd327 ) begin
	ram_ff327 <=  di;
    end
    if ( we && wa == 9'd328 ) begin
	ram_ff328 <=  di;
    end
    if ( we && wa == 9'd329 ) begin
	ram_ff329 <=  di;
    end
    if ( we && wa == 9'd330 ) begin
	ram_ff330 <=  di;
    end
    if ( we && wa == 9'd331 ) begin
	ram_ff331 <=  di;
    end
    if ( we && wa == 9'd332 ) begin
	ram_ff332 <=  di;
    end
    if ( we && wa == 9'd333 ) begin
	ram_ff333 <=  di;
    end
    if ( we && wa == 9'd334 ) begin
	ram_ff334 <=  di;
    end
    if ( we && wa == 9'd335 ) begin
	ram_ff335 <=  di;
    end
    if ( we && wa == 9'd336 ) begin
	ram_ff336 <=  di;
    end
    if ( we && wa == 9'd337 ) begin
	ram_ff337 <=  di;
    end
    if ( we && wa == 9'd338 ) begin
	ram_ff338 <=  di;
    end
    if ( we && wa == 9'd339 ) begin
	ram_ff339 <=  di;
    end
    if ( we && wa == 9'd340 ) begin
	ram_ff340 <=  di;
    end
    if ( we && wa == 9'd341 ) begin
	ram_ff341 <=  di;
    end
    if ( we && wa == 9'd342 ) begin
	ram_ff342 <=  di;
    end
    if ( we && wa == 9'd343 ) begin
	ram_ff343 <=  di;
    end
    if ( we && wa == 9'd344 ) begin
	ram_ff344 <=  di;
    end
    if ( we && wa == 9'd345 ) begin
	ram_ff345 <=  di;
    end
    if ( we && wa == 9'd346 ) begin
	ram_ff346 <=  di;
    end
    if ( we && wa == 9'd347 ) begin
	ram_ff347 <=  di;
    end
    if ( we && wa == 9'd348 ) begin
	ram_ff348 <=  di;
    end
    if ( we && wa == 9'd349 ) begin
	ram_ff349 <=  di;
    end
    if ( we && wa == 9'd350 ) begin
	ram_ff350 <=  di;
    end
    if ( we && wa == 9'd351 ) begin
	ram_ff351 <=  di;
    end
    if ( we && wa == 9'd352 ) begin
	ram_ff352 <=  di;
    end
    if ( we && wa == 9'd353 ) begin
	ram_ff353 <=  di;
    end
    if ( we && wa == 9'd354 ) begin
	ram_ff354 <=  di;
    end
    if ( we && wa == 9'd355 ) begin
	ram_ff355 <=  di;
    end
    if ( we && wa == 9'd356 ) begin
	ram_ff356 <=  di;
    end
    if ( we && wa == 9'd357 ) begin
	ram_ff357 <=  di;
    end
    if ( we && wa == 9'd358 ) begin
	ram_ff358 <=  di;
    end
    if ( we && wa == 9'd359 ) begin
	ram_ff359 <=  di;
    end
    if ( we && wa == 9'd360 ) begin
	ram_ff360 <=  di;
    end
    if ( we && wa == 9'd361 ) begin
	ram_ff361 <=  di;
    end
    if ( we && wa == 9'd362 ) begin
	ram_ff362 <=  di;
    end
    if ( we && wa == 9'd363 ) begin
	ram_ff363 <=  di;
    end
    if ( we && wa == 9'd364 ) begin
	ram_ff364 <=  di;
    end
    if ( we && wa == 9'd365 ) begin
	ram_ff365 <=  di;
    end
    if ( we && wa == 9'd366 ) begin
	ram_ff366 <=  di;
    end
    if ( we && wa == 9'd367 ) begin
	ram_ff367 <=  di;
    end
    if ( we && wa == 9'd368 ) begin
	ram_ff368 <=  di;
    end
    if ( we && wa == 9'd369 ) begin
	ram_ff369 <=  di;
    end
    if ( we && wa == 9'd370 ) begin
	ram_ff370 <=  di;
    end
    if ( we && wa == 9'd371 ) begin
	ram_ff371 <=  di;
    end
    if ( we && wa == 9'd372 ) begin
	ram_ff372 <=  di;
    end
    if ( we && wa == 9'd373 ) begin
	ram_ff373 <=  di;
    end
    if ( we && wa == 9'd374 ) begin
	ram_ff374 <=  di;
    end
    if ( we && wa == 9'd375 ) begin
	ram_ff375 <=  di;
    end
    if ( we && wa == 9'd376 ) begin
	ram_ff376 <=  di;
    end
    if ( we && wa == 9'd377 ) begin
	ram_ff377 <=  di;
    end
    if ( we && wa == 9'd378 ) begin
	ram_ff378 <=  di;
    end
    if ( we && wa == 9'd379 ) begin
	ram_ff379 <=  di;
    end
    if ( we && wa == 9'd380 ) begin
	ram_ff380 <=  di;
    end
    if ( we && wa == 9'd381 ) begin
	ram_ff381 <=  di;
    end
    if ( we && wa == 9'd382 ) begin
	ram_ff382 <=  di;
    end
    if ( we && wa == 9'd383 ) begin
	ram_ff383 <=  di;
    end
    if ( we && wa == 9'd384 ) begin
	ram_ff384 <=  di;
    end
    if ( we && wa == 9'd385 ) begin
	ram_ff385 <=  di;
    end
    if ( we && wa == 9'd386 ) begin
	ram_ff386 <=  di;
    end
    if ( we && wa == 9'd387 ) begin
	ram_ff387 <=  di;
    end
    if ( we && wa == 9'd388 ) begin
	ram_ff388 <=  di;
    end
    if ( we && wa == 9'd389 ) begin
	ram_ff389 <=  di;
    end
    if ( we && wa == 9'd390 ) begin
	ram_ff390 <=  di;
    end
    if ( we && wa == 9'd391 ) begin
	ram_ff391 <=  di;
    end
    if ( we && wa == 9'd392 ) begin
	ram_ff392 <=  di;
    end
    if ( we && wa == 9'd393 ) begin
	ram_ff393 <=  di;
    end
    if ( we && wa == 9'd394 ) begin
	ram_ff394 <=  di;
    end
    if ( we && wa == 9'd395 ) begin
	ram_ff395 <=  di;
    end
    if ( we && wa == 9'd396 ) begin
	ram_ff396 <=  di;
    end
    if ( we && wa == 9'd397 ) begin
	ram_ff397 <=  di;
    end
    if ( we && wa == 9'd398 ) begin
	ram_ff398 <=  di;
    end
    if ( we && wa == 9'd399 ) begin
	ram_ff399 <=  di;
    end
    if ( we && wa == 9'd400 ) begin
	ram_ff400 <=  di;
    end
    if ( we && wa == 9'd401 ) begin
	ram_ff401 <=  di;
    end
    if ( we && wa == 9'd402 ) begin
	ram_ff402 <=  di;
    end
    if ( we && wa == 9'd403 ) begin
	ram_ff403 <=  di;
    end
    if ( we && wa == 9'd404 ) begin
	ram_ff404 <=  di;
    end
    if ( we && wa == 9'd405 ) begin
	ram_ff405 <=  di;
    end
    if ( we && wa == 9'd406 ) begin
	ram_ff406 <=  di;
    end
    if ( we && wa == 9'd407 ) begin
	ram_ff407 <=  di;
    end
    if ( we && wa == 9'd408 ) begin
	ram_ff408 <=  di;
    end
    if ( we && wa == 9'd409 ) begin
	ram_ff409 <=  di;
    end
    if ( we && wa == 9'd410 ) begin
	ram_ff410 <=  di;
    end
    if ( we && wa == 9'd411 ) begin
	ram_ff411 <=  di;
    end
    if ( we && wa == 9'd412 ) begin
	ram_ff412 <=  di;
    end
    if ( we && wa == 9'd413 ) begin
	ram_ff413 <=  di;
    end
    if ( we && wa == 9'd414 ) begin
	ram_ff414 <=  di;
    end
    if ( we && wa == 9'd415 ) begin
	ram_ff415 <=  di;
    end
    if ( we && wa == 9'd416 ) begin
	ram_ff416 <=  di;
    end
    if ( we && wa == 9'd417 ) begin
	ram_ff417 <=  di;
    end
    if ( we && wa == 9'd418 ) begin
	ram_ff418 <=  di;
    end
    if ( we && wa == 9'd419 ) begin
	ram_ff419 <=  di;
    end
    if ( we && wa == 9'd420 ) begin
	ram_ff420 <=  di;
    end
    if ( we && wa == 9'd421 ) begin
	ram_ff421 <=  di;
    end
    if ( we && wa == 9'd422 ) begin
	ram_ff422 <=  di;
    end
    if ( we && wa == 9'd423 ) begin
	ram_ff423 <=  di;
    end
    if ( we && wa == 9'd424 ) begin
	ram_ff424 <=  di;
    end
    if ( we && wa == 9'd425 ) begin
	ram_ff425 <=  di;
    end
    if ( we && wa == 9'd426 ) begin
	ram_ff426 <=  di;
    end
    if ( we && wa == 9'd427 ) begin
	ram_ff427 <=  di;
    end
    if ( we && wa == 9'd428 ) begin
	ram_ff428 <=  di;
    end
    if ( we && wa == 9'd429 ) begin
	ram_ff429 <=  di;
    end
    if ( we && wa == 9'd430 ) begin
	ram_ff430 <=  di;
    end
    if ( we && wa == 9'd431 ) begin
	ram_ff431 <=  di;
    end
    if ( we && wa == 9'd432 ) begin
	ram_ff432 <=  di;
    end
    if ( we && wa == 9'd433 ) begin
	ram_ff433 <=  di;
    end
    if ( we && wa == 9'd434 ) begin
	ram_ff434 <=  di;
    end
    if ( we && wa == 9'd435 ) begin
	ram_ff435 <=  di;
    end
    if ( we && wa == 9'd436 ) begin
	ram_ff436 <=  di;
    end
    if ( we && wa == 9'd437 ) begin
	ram_ff437 <=  di;
    end
    if ( we && wa == 9'd438 ) begin
	ram_ff438 <=  di;
    end
    if ( we && wa == 9'd439 ) begin
	ram_ff439 <=  di;
    end
    if ( we && wa == 9'd440 ) begin
	ram_ff440 <=  di;
    end
    if ( we && wa == 9'd441 ) begin
	ram_ff441 <=  di;
    end
    if ( we && wa == 9'd442 ) begin
	ram_ff442 <=  di;
    end
    if ( we && wa == 9'd443 ) begin
	ram_ff443 <=  di;
    end
    if ( we && wa == 9'd444 ) begin
	ram_ff444 <=  di;
    end
    if ( we && wa == 9'd445 ) begin
	ram_ff445 <=  di;
    end
    if ( we && wa == 9'd446 ) begin
	ram_ff446 <=  di;
    end
    if ( we && wa == 9'd447 ) begin
	ram_ff447 <=  di;
    end
end

reg [511:0] dout;

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
          or ram_ff64
          or ram_ff65
          or ram_ff66
          or ram_ff67
          or ram_ff68
          or ram_ff69
          or ram_ff70
          or ram_ff71
          or ram_ff72
          or ram_ff73
          or ram_ff74
          or ram_ff75
          or ram_ff76
          or ram_ff77
          or ram_ff78
          or ram_ff79
          or ram_ff80
          or ram_ff81
          or ram_ff82
          or ram_ff83
          or ram_ff84
          or ram_ff85
          or ram_ff86
          or ram_ff87
          or ram_ff88
          or ram_ff89
          or ram_ff90
          or ram_ff91
          or ram_ff92
          or ram_ff93
          or ram_ff94
          or ram_ff95
          or ram_ff96
          or ram_ff97
          or ram_ff98
          or ram_ff99
          or ram_ff100
          or ram_ff101
          or ram_ff102
          or ram_ff103
          or ram_ff104
          or ram_ff105
          or ram_ff106
          or ram_ff107
          or ram_ff108
          or ram_ff109
          or ram_ff110
          or ram_ff111
          or ram_ff112
          or ram_ff113
          or ram_ff114
          or ram_ff115
          or ram_ff116
          or ram_ff117
          or ram_ff118
          or ram_ff119
          or ram_ff120
          or ram_ff121
          or ram_ff122
          or ram_ff123
          or ram_ff124
          or ram_ff125
          or ram_ff126
          or ram_ff127
          or ram_ff128
          or ram_ff129
          or ram_ff130
          or ram_ff131
          or ram_ff132
          or ram_ff133
          or ram_ff134
          or ram_ff135
          or ram_ff136
          or ram_ff137
          or ram_ff138
          or ram_ff139
          or ram_ff140
          or ram_ff141
          or ram_ff142
          or ram_ff143
          or ram_ff144
          or ram_ff145
          or ram_ff146
          or ram_ff147
          or ram_ff148
          or ram_ff149
          or ram_ff150
          or ram_ff151
          or ram_ff152
          or ram_ff153
          or ram_ff154
          or ram_ff155
          or ram_ff156
          or ram_ff157
          or ram_ff158
          or ram_ff159
          or ram_ff160
          or ram_ff161
          or ram_ff162
          or ram_ff163
          or ram_ff164
          or ram_ff165
          or ram_ff166
          or ram_ff167
          or ram_ff168
          or ram_ff169
          or ram_ff170
          or ram_ff171
          or ram_ff172
          or ram_ff173
          or ram_ff174
          or ram_ff175
          or ram_ff176
          or ram_ff177
          or ram_ff178
          or ram_ff179
          or ram_ff180
          or ram_ff181
          or ram_ff182
          or ram_ff183
          or ram_ff184
          or ram_ff185
          or ram_ff186
          or ram_ff187
          or ram_ff188
          or ram_ff189
          or ram_ff190
          or ram_ff191
          or ram_ff192
          or ram_ff193
          or ram_ff194
          or ram_ff195
          or ram_ff196
          or ram_ff197
          or ram_ff198
          or ram_ff199
          or ram_ff200
          or ram_ff201
          or ram_ff202
          or ram_ff203
          or ram_ff204
          or ram_ff205
          or ram_ff206
          or ram_ff207
          or ram_ff208
          or ram_ff209
          or ram_ff210
          or ram_ff211
          or ram_ff212
          or ram_ff213
          or ram_ff214
          or ram_ff215
          or ram_ff216
          or ram_ff217
          or ram_ff218
          or ram_ff219
          or ram_ff220
          or ram_ff221
          or ram_ff222
          or ram_ff223
          or ram_ff224
          or ram_ff225
          or ram_ff226
          or ram_ff227
          or ram_ff228
          or ram_ff229
          or ram_ff230
          or ram_ff231
          or ram_ff232
          or ram_ff233
          or ram_ff234
          or ram_ff235
          or ram_ff236
          or ram_ff237
          or ram_ff238
          or ram_ff239
          or ram_ff240
          or ram_ff241
          or ram_ff242
          or ram_ff243
          or ram_ff244
          or ram_ff245
          or ram_ff246
          or ram_ff247
          or ram_ff248
          or ram_ff249
          or ram_ff250
          or ram_ff251
          or ram_ff252
          or ram_ff253
          or ram_ff254
          or ram_ff255
          or ram_ff256
          or ram_ff257
          or ram_ff258
          or ram_ff259
          or ram_ff260
          or ram_ff261
          or ram_ff262
          or ram_ff263
          or ram_ff264
          or ram_ff265
          or ram_ff266
          or ram_ff267
          or ram_ff268
          or ram_ff269
          or ram_ff270
          or ram_ff271
          or ram_ff272
          or ram_ff273
          or ram_ff274
          or ram_ff275
          or ram_ff276
          or ram_ff277
          or ram_ff278
          or ram_ff279
          or ram_ff280
          or ram_ff281
          or ram_ff282
          or ram_ff283
          or ram_ff284
          or ram_ff285
          or ram_ff286
          or ram_ff287
          or ram_ff288
          or ram_ff289
          or ram_ff290
          or ram_ff291
          or ram_ff292
          or ram_ff293
          or ram_ff294
          or ram_ff295
          or ram_ff296
          or ram_ff297
          or ram_ff298
          or ram_ff299
          or ram_ff300
          or ram_ff301
          or ram_ff302
          or ram_ff303
          or ram_ff304
          or ram_ff305
          or ram_ff306
          or ram_ff307
          or ram_ff308
          or ram_ff309
          or ram_ff310
          or ram_ff311
          or ram_ff312
          or ram_ff313
          or ram_ff314
          or ram_ff315
          or ram_ff316
          or ram_ff317
          or ram_ff318
          or ram_ff319
          or ram_ff320
          or ram_ff321
          or ram_ff322
          or ram_ff323
          or ram_ff324
          or ram_ff325
          or ram_ff326
          or ram_ff327
          or ram_ff328
          or ram_ff329
          or ram_ff330
          or ram_ff331
          or ram_ff332
          or ram_ff333
          or ram_ff334
          or ram_ff335
          or ram_ff336
          or ram_ff337
          or ram_ff338
          or ram_ff339
          or ram_ff340
          or ram_ff341
          or ram_ff342
          or ram_ff343
          or ram_ff344
          or ram_ff345
          or ram_ff346
          or ram_ff347
          or ram_ff348
          or ram_ff349
          or ram_ff350
          or ram_ff351
          or ram_ff352
          or ram_ff353
          or ram_ff354
          or ram_ff355
          or ram_ff356
          or ram_ff357
          or ram_ff358
          or ram_ff359
          or ram_ff360
          or ram_ff361
          or ram_ff362
          or ram_ff363
          or ram_ff364
          or ram_ff365
          or ram_ff366
          or ram_ff367
          or ram_ff368
          or ram_ff369
          or ram_ff370
          or ram_ff371
          or ram_ff372
          or ram_ff373
          or ram_ff374
          or ram_ff375
          or ram_ff376
          or ram_ff377
          or ram_ff378
          or ram_ff379
          or ram_ff380
          or ram_ff381
          or ram_ff382
          or ram_ff383
          or ram_ff384
          or ram_ff385
          or ram_ff386
          or ram_ff387
          or ram_ff388
          or ram_ff389
          or ram_ff390
          or ram_ff391
          or ram_ff392
          or ram_ff393
          or ram_ff394
          or ram_ff395
          or ram_ff396
          or ram_ff397
          or ram_ff398
          or ram_ff399
          or ram_ff400
          or ram_ff401
          or ram_ff402
          or ram_ff403
          or ram_ff404
          or ram_ff405
          or ram_ff406
          or ram_ff407
          or ram_ff408
          or ram_ff409
          or ram_ff410
          or ram_ff411
          or ram_ff412
          or ram_ff413
          or ram_ff414
          or ram_ff415
          or ram_ff416
          or ram_ff417
          or ram_ff418
          or ram_ff419
          or ram_ff420
          or ram_ff421
          or ram_ff422
          or ram_ff423
          or ram_ff424
          or ram_ff425
          or ram_ff426
          or ram_ff427
          or ram_ff428
          or ram_ff429
          or ram_ff430
          or ram_ff431
          or ram_ff432
          or ram_ff433
          or ram_ff434
          or ram_ff435
          or ram_ff436
          or ram_ff437
          or ram_ff438
          or ram_ff439
          or ram_ff440
          or ram_ff441
          or ram_ff442
          or ram_ff443
          or ram_ff444
          or ram_ff445
          or ram_ff446
          or ram_ff447
        ) begin
    case( ra ) // synopsys infer_mux
    9'd0:       dout = ram_ff0;
    9'd1:       dout = ram_ff1;
    9'd2:       dout = ram_ff2;
    9'd3:       dout = ram_ff3;
    9'd4:       dout = ram_ff4;
    9'd5:       dout = ram_ff5;
    9'd6:       dout = ram_ff6;
    9'd7:       dout = ram_ff7;
    9'd8:       dout = ram_ff8;
    9'd9:       dout = ram_ff9;
    9'd10:       dout = ram_ff10;
    9'd11:       dout = ram_ff11;
    9'd12:       dout = ram_ff12;
    9'd13:       dout = ram_ff13;
    9'd14:       dout = ram_ff14;
    9'd15:       dout = ram_ff15;
    9'd16:       dout = ram_ff16;
    9'd17:       dout = ram_ff17;
    9'd18:       dout = ram_ff18;
    9'd19:       dout = ram_ff19;
    9'd20:       dout = ram_ff20;
    9'd21:       dout = ram_ff21;
    9'd22:       dout = ram_ff22;
    9'd23:       dout = ram_ff23;
    9'd24:       dout = ram_ff24;
    9'd25:       dout = ram_ff25;
    9'd26:       dout = ram_ff26;
    9'd27:       dout = ram_ff27;
    9'd28:       dout = ram_ff28;
    9'd29:       dout = ram_ff29;
    9'd30:       dout = ram_ff30;
    9'd31:       dout = ram_ff31;
    9'd32:       dout = ram_ff32;
    9'd33:       dout = ram_ff33;
    9'd34:       dout = ram_ff34;
    9'd35:       dout = ram_ff35;
    9'd36:       dout = ram_ff36;
    9'd37:       dout = ram_ff37;
    9'd38:       dout = ram_ff38;
    9'd39:       dout = ram_ff39;
    9'd40:       dout = ram_ff40;
    9'd41:       dout = ram_ff41;
    9'd42:       dout = ram_ff42;
    9'd43:       dout = ram_ff43;
    9'd44:       dout = ram_ff44;
    9'd45:       dout = ram_ff45;
    9'd46:       dout = ram_ff46;
    9'd47:       dout = ram_ff47;
    9'd48:       dout = ram_ff48;
    9'd49:       dout = ram_ff49;
    9'd50:       dout = ram_ff50;
    9'd51:       dout = ram_ff51;
    9'd52:       dout = ram_ff52;
    9'd53:       dout = ram_ff53;
    9'd54:       dout = ram_ff54;
    9'd55:       dout = ram_ff55;
    9'd56:       dout = ram_ff56;
    9'd57:       dout = ram_ff57;
    9'd58:       dout = ram_ff58;
    9'd59:       dout = ram_ff59;
    9'd60:       dout = ram_ff60;
    9'd61:       dout = ram_ff61;
    9'd62:       dout = ram_ff62;
    9'd63:       dout = ram_ff63;
    9'd64:       dout = ram_ff64;
    9'd65:       dout = ram_ff65;
    9'd66:       dout = ram_ff66;
    9'd67:       dout = ram_ff67;
    9'd68:       dout = ram_ff68;
    9'd69:       dout = ram_ff69;
    9'd70:       dout = ram_ff70;
    9'd71:       dout = ram_ff71;
    9'd72:       dout = ram_ff72;
    9'd73:       dout = ram_ff73;
    9'd74:       dout = ram_ff74;
    9'd75:       dout = ram_ff75;
    9'd76:       dout = ram_ff76;
    9'd77:       dout = ram_ff77;
    9'd78:       dout = ram_ff78;
    9'd79:       dout = ram_ff79;
    9'd80:       dout = ram_ff80;
    9'd81:       dout = ram_ff81;
    9'd82:       dout = ram_ff82;
    9'd83:       dout = ram_ff83;
    9'd84:       dout = ram_ff84;
    9'd85:       dout = ram_ff85;
    9'd86:       dout = ram_ff86;
    9'd87:       dout = ram_ff87;
    9'd88:       dout = ram_ff88;
    9'd89:       dout = ram_ff89;
    9'd90:       dout = ram_ff90;
    9'd91:       dout = ram_ff91;
    9'd92:       dout = ram_ff92;
    9'd93:       dout = ram_ff93;
    9'd94:       dout = ram_ff94;
    9'd95:       dout = ram_ff95;
    9'd96:       dout = ram_ff96;
    9'd97:       dout = ram_ff97;
    9'd98:       dout = ram_ff98;
    9'd99:       dout = ram_ff99;
    9'd100:       dout = ram_ff100;
    9'd101:       dout = ram_ff101;
    9'd102:       dout = ram_ff102;
    9'd103:       dout = ram_ff103;
    9'd104:       dout = ram_ff104;
    9'd105:       dout = ram_ff105;
    9'd106:       dout = ram_ff106;
    9'd107:       dout = ram_ff107;
    9'd108:       dout = ram_ff108;
    9'd109:       dout = ram_ff109;
    9'd110:       dout = ram_ff110;
    9'd111:       dout = ram_ff111;
    9'd112:       dout = ram_ff112;
    9'd113:       dout = ram_ff113;
    9'd114:       dout = ram_ff114;
    9'd115:       dout = ram_ff115;
    9'd116:       dout = ram_ff116;
    9'd117:       dout = ram_ff117;
    9'd118:       dout = ram_ff118;
    9'd119:       dout = ram_ff119;
    9'd120:       dout = ram_ff120;
    9'd121:       dout = ram_ff121;
    9'd122:       dout = ram_ff122;
    9'd123:       dout = ram_ff123;
    9'd124:       dout = ram_ff124;
    9'd125:       dout = ram_ff125;
    9'd126:       dout = ram_ff126;
    9'd127:       dout = ram_ff127;
    9'd128:       dout = ram_ff128;
    9'd129:       dout = ram_ff129;
    9'd130:       dout = ram_ff130;
    9'd131:       dout = ram_ff131;
    9'd132:       dout = ram_ff132;
    9'd133:       dout = ram_ff133;
    9'd134:       dout = ram_ff134;
    9'd135:       dout = ram_ff135;
    9'd136:       dout = ram_ff136;
    9'd137:       dout = ram_ff137;
    9'd138:       dout = ram_ff138;
    9'd139:       dout = ram_ff139;
    9'd140:       dout = ram_ff140;
    9'd141:       dout = ram_ff141;
    9'd142:       dout = ram_ff142;
    9'd143:       dout = ram_ff143;
    9'd144:       dout = ram_ff144;
    9'd145:       dout = ram_ff145;
    9'd146:       dout = ram_ff146;
    9'd147:       dout = ram_ff147;
    9'd148:       dout = ram_ff148;
    9'd149:       dout = ram_ff149;
    9'd150:       dout = ram_ff150;
    9'd151:       dout = ram_ff151;
    9'd152:       dout = ram_ff152;
    9'd153:       dout = ram_ff153;
    9'd154:       dout = ram_ff154;
    9'd155:       dout = ram_ff155;
    9'd156:       dout = ram_ff156;
    9'd157:       dout = ram_ff157;
    9'd158:       dout = ram_ff158;
    9'd159:       dout = ram_ff159;
    9'd160:       dout = ram_ff160;
    9'd161:       dout = ram_ff161;
    9'd162:       dout = ram_ff162;
    9'd163:       dout = ram_ff163;
    9'd164:       dout = ram_ff164;
    9'd165:       dout = ram_ff165;
    9'd166:       dout = ram_ff166;
    9'd167:       dout = ram_ff167;
    9'd168:       dout = ram_ff168;
    9'd169:       dout = ram_ff169;
    9'd170:       dout = ram_ff170;
    9'd171:       dout = ram_ff171;
    9'd172:       dout = ram_ff172;
    9'd173:       dout = ram_ff173;
    9'd174:       dout = ram_ff174;
    9'd175:       dout = ram_ff175;
    9'd176:       dout = ram_ff176;
    9'd177:       dout = ram_ff177;
    9'd178:       dout = ram_ff178;
    9'd179:       dout = ram_ff179;
    9'd180:       dout = ram_ff180;
    9'd181:       dout = ram_ff181;
    9'd182:       dout = ram_ff182;
    9'd183:       dout = ram_ff183;
    9'd184:       dout = ram_ff184;
    9'd185:       dout = ram_ff185;
    9'd186:       dout = ram_ff186;
    9'd187:       dout = ram_ff187;
    9'd188:       dout = ram_ff188;
    9'd189:       dout = ram_ff189;
    9'd190:       dout = ram_ff190;
    9'd191:       dout = ram_ff191;
    9'd192:       dout = ram_ff192;
    9'd193:       dout = ram_ff193;
    9'd194:       dout = ram_ff194;
    9'd195:       dout = ram_ff195;
    9'd196:       dout = ram_ff196;
    9'd197:       dout = ram_ff197;
    9'd198:       dout = ram_ff198;
    9'd199:       dout = ram_ff199;
    9'd200:       dout = ram_ff200;
    9'd201:       dout = ram_ff201;
    9'd202:       dout = ram_ff202;
    9'd203:       dout = ram_ff203;
    9'd204:       dout = ram_ff204;
    9'd205:       dout = ram_ff205;
    9'd206:       dout = ram_ff206;
    9'd207:       dout = ram_ff207;
    9'd208:       dout = ram_ff208;
    9'd209:       dout = ram_ff209;
    9'd210:       dout = ram_ff210;
    9'd211:       dout = ram_ff211;
    9'd212:       dout = ram_ff212;
    9'd213:       dout = ram_ff213;
    9'd214:       dout = ram_ff214;
    9'd215:       dout = ram_ff215;
    9'd216:       dout = ram_ff216;
    9'd217:       dout = ram_ff217;
    9'd218:       dout = ram_ff218;
    9'd219:       dout = ram_ff219;
    9'd220:       dout = ram_ff220;
    9'd221:       dout = ram_ff221;
    9'd222:       dout = ram_ff222;
    9'd223:       dout = ram_ff223;
    9'd224:       dout = ram_ff224;
    9'd225:       dout = ram_ff225;
    9'd226:       dout = ram_ff226;
    9'd227:       dout = ram_ff227;
    9'd228:       dout = ram_ff228;
    9'd229:       dout = ram_ff229;
    9'd230:       dout = ram_ff230;
    9'd231:       dout = ram_ff231;
    9'd232:       dout = ram_ff232;
    9'd233:       dout = ram_ff233;
    9'd234:       dout = ram_ff234;
    9'd235:       dout = ram_ff235;
    9'd236:       dout = ram_ff236;
    9'd237:       dout = ram_ff237;
    9'd238:       dout = ram_ff238;
    9'd239:       dout = ram_ff239;
    9'd240:       dout = ram_ff240;
    9'd241:       dout = ram_ff241;
    9'd242:       dout = ram_ff242;
    9'd243:       dout = ram_ff243;
    9'd244:       dout = ram_ff244;
    9'd245:       dout = ram_ff245;
    9'd246:       dout = ram_ff246;
    9'd247:       dout = ram_ff247;
    9'd248:       dout = ram_ff248;
    9'd249:       dout = ram_ff249;
    9'd250:       dout = ram_ff250;
    9'd251:       dout = ram_ff251;
    9'd252:       dout = ram_ff252;
    9'd253:       dout = ram_ff253;
    9'd254:       dout = ram_ff254;
    9'd255:       dout = ram_ff255;
    9'd256:       dout = ram_ff256;
    9'd257:       dout = ram_ff257;
    9'd258:       dout = ram_ff258;
    9'd259:       dout = ram_ff259;
    9'd260:       dout = ram_ff260;
    9'd261:       dout = ram_ff261;
    9'd262:       dout = ram_ff262;
    9'd263:       dout = ram_ff263;
    9'd264:       dout = ram_ff264;
    9'd265:       dout = ram_ff265;
    9'd266:       dout = ram_ff266;
    9'd267:       dout = ram_ff267;
    9'd268:       dout = ram_ff268;
    9'd269:       dout = ram_ff269;
    9'd270:       dout = ram_ff270;
    9'd271:       dout = ram_ff271;
    9'd272:       dout = ram_ff272;
    9'd273:       dout = ram_ff273;
    9'd274:       dout = ram_ff274;
    9'd275:       dout = ram_ff275;
    9'd276:       dout = ram_ff276;
    9'd277:       dout = ram_ff277;
    9'd278:       dout = ram_ff278;
    9'd279:       dout = ram_ff279;
    9'd280:       dout = ram_ff280;
    9'd281:       dout = ram_ff281;
    9'd282:       dout = ram_ff282;
    9'd283:       dout = ram_ff283;
    9'd284:       dout = ram_ff284;
    9'd285:       dout = ram_ff285;
    9'd286:       dout = ram_ff286;
    9'd287:       dout = ram_ff287;
    9'd288:       dout = ram_ff288;
    9'd289:       dout = ram_ff289;
    9'd290:       dout = ram_ff290;
    9'd291:       dout = ram_ff291;
    9'd292:       dout = ram_ff292;
    9'd293:       dout = ram_ff293;
    9'd294:       dout = ram_ff294;
    9'd295:       dout = ram_ff295;
    9'd296:       dout = ram_ff296;
    9'd297:       dout = ram_ff297;
    9'd298:       dout = ram_ff298;
    9'd299:       dout = ram_ff299;
    9'd300:       dout = ram_ff300;
    9'd301:       dout = ram_ff301;
    9'd302:       dout = ram_ff302;
    9'd303:       dout = ram_ff303;
    9'd304:       dout = ram_ff304;
    9'd305:       dout = ram_ff305;
    9'd306:       dout = ram_ff306;
    9'd307:       dout = ram_ff307;
    9'd308:       dout = ram_ff308;
    9'd309:       dout = ram_ff309;
    9'd310:       dout = ram_ff310;
    9'd311:       dout = ram_ff311;
    9'd312:       dout = ram_ff312;
    9'd313:       dout = ram_ff313;
    9'd314:       dout = ram_ff314;
    9'd315:       dout = ram_ff315;
    9'd316:       dout = ram_ff316;
    9'd317:       dout = ram_ff317;
    9'd318:       dout = ram_ff318;
    9'd319:       dout = ram_ff319;
    9'd320:       dout = ram_ff320;
    9'd321:       dout = ram_ff321;
    9'd322:       dout = ram_ff322;
    9'd323:       dout = ram_ff323;
    9'd324:       dout = ram_ff324;
    9'd325:       dout = ram_ff325;
    9'd326:       dout = ram_ff326;
    9'd327:       dout = ram_ff327;
    9'd328:       dout = ram_ff328;
    9'd329:       dout = ram_ff329;
    9'd330:       dout = ram_ff330;
    9'd331:       dout = ram_ff331;
    9'd332:       dout = ram_ff332;
    9'd333:       dout = ram_ff333;
    9'd334:       dout = ram_ff334;
    9'd335:       dout = ram_ff335;
    9'd336:       dout = ram_ff336;
    9'd337:       dout = ram_ff337;
    9'd338:       dout = ram_ff338;
    9'd339:       dout = ram_ff339;
    9'd340:       dout = ram_ff340;
    9'd341:       dout = ram_ff341;
    9'd342:       dout = ram_ff342;
    9'd343:       dout = ram_ff343;
    9'd344:       dout = ram_ff344;
    9'd345:       dout = ram_ff345;
    9'd346:       dout = ram_ff346;
    9'd347:       dout = ram_ff347;
    9'd348:       dout = ram_ff348;
    9'd349:       dout = ram_ff349;
    9'd350:       dout = ram_ff350;
    9'd351:       dout = ram_ff351;
    9'd352:       dout = ram_ff352;
    9'd353:       dout = ram_ff353;
    9'd354:       dout = ram_ff354;
    9'd355:       dout = ram_ff355;
    9'd356:       dout = ram_ff356;
    9'd357:       dout = ram_ff357;
    9'd358:       dout = ram_ff358;
    9'd359:       dout = ram_ff359;
    9'd360:       dout = ram_ff360;
    9'd361:       dout = ram_ff361;
    9'd362:       dout = ram_ff362;
    9'd363:       dout = ram_ff363;
    9'd364:       dout = ram_ff364;
    9'd365:       dout = ram_ff365;
    9'd366:       dout = ram_ff366;
    9'd367:       dout = ram_ff367;
    9'd368:       dout = ram_ff368;
    9'd369:       dout = ram_ff369;
    9'd370:       dout = ram_ff370;
    9'd371:       dout = ram_ff371;
    9'd372:       dout = ram_ff372;
    9'd373:       dout = ram_ff373;
    9'd374:       dout = ram_ff374;
    9'd375:       dout = ram_ff375;
    9'd376:       dout = ram_ff376;
    9'd377:       dout = ram_ff377;
    9'd378:       dout = ram_ff378;
    9'd379:       dout = ram_ff379;
    9'd380:       dout = ram_ff380;
    9'd381:       dout = ram_ff381;
    9'd382:       dout = ram_ff382;
    9'd383:       dout = ram_ff383;
    9'd384:       dout = ram_ff384;
    9'd385:       dout = ram_ff385;
    9'd386:       dout = ram_ff386;
    9'd387:       dout = ram_ff387;
    9'd388:       dout = ram_ff388;
    9'd389:       dout = ram_ff389;
    9'd390:       dout = ram_ff390;
    9'd391:       dout = ram_ff391;
    9'd392:       dout = ram_ff392;
    9'd393:       dout = ram_ff393;
    9'd394:       dout = ram_ff394;
    9'd395:       dout = ram_ff395;
    9'd396:       dout = ram_ff396;
    9'd397:       dout = ram_ff397;
    9'd398:       dout = ram_ff398;
    9'd399:       dout = ram_ff399;
    9'd400:       dout = ram_ff400;
    9'd401:       dout = ram_ff401;
    9'd402:       dout = ram_ff402;
    9'd403:       dout = ram_ff403;
    9'd404:       dout = ram_ff404;
    9'd405:       dout = ram_ff405;
    9'd406:       dout = ram_ff406;
    9'd407:       dout = ram_ff407;
    9'd408:       dout = ram_ff408;
    9'd409:       dout = ram_ff409;
    9'd410:       dout = ram_ff410;
    9'd411:       dout = ram_ff411;
    9'd412:       dout = ram_ff412;
    9'd413:       dout = ram_ff413;
    9'd414:       dout = ram_ff414;
    9'd415:       dout = ram_ff415;
    9'd416:       dout = ram_ff416;
    9'd417:       dout = ram_ff417;
    9'd418:       dout = ram_ff418;
    9'd419:       dout = ram_ff419;
    9'd420:       dout = ram_ff420;
    9'd421:       dout = ram_ff421;
    9'd422:       dout = ram_ff422;
    9'd423:       dout = ram_ff423;
    9'd424:       dout = ram_ff424;
    9'd425:       dout = ram_ff425;
    9'd426:       dout = ram_ff426;
    9'd427:       dout = ram_ff427;
    9'd428:       dout = ram_ff428;
    9'd429:       dout = ram_ff429;
    9'd430:       dout = ram_ff430;
    9'd431:       dout = ram_ff431;
    9'd432:       dout = ram_ff432;
    9'd433:       dout = ram_ff433;
    9'd434:       dout = ram_ff434;
    9'd435:       dout = ram_ff435;
    9'd436:       dout = ram_ff436;
    9'd437:       dout = ram_ff437;
    9'd438:       dout = ram_ff438;
    9'd439:       dout = ram_ff439;
    9'd440:       dout = ram_ff440;
    9'd441:       dout = ram_ff441;
    9'd442:       dout = ram_ff442;
    9'd443:       dout = ram_ff443;
    9'd444:       dout = ram_ff444;
    9'd445:       dout = ram_ff445;
    9'd446:       dout = ram_ff446;
    9'd447:       dout = ram_ff447;
    //VCS coverage off
    default:    dout = {512{1'b0}};
    //VCS coverage on
    endcase
end

endmodule // memresp_fifo_flopram_rwsa_448x512



