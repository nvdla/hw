// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_BDMA_cq.v

`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"
module NV_NVDLA_BDMA_cq (
      nvdla_core_clk
    , nvdla_core_rstn
    , ld2st_wr_prdy
    , ld2st_wr_idle
    , ld2st_wr_pvld
    , ld2st_wr_pd
    , ld2st_rd_prdy
    , ld2st_rd_pvld
    , ld2st_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        ld2st_wr_prdy;
output        ld2st_wr_idle;
input         ld2st_wr_pvld;
input  [160:0] ld2st_wr_pd;
input         ld2st_rd_prdy;
output        ld2st_rd_pvld;
output [160:0] ld2st_rd_pd;
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
reg        ld2st_wr_pvld_in;                                // registered ld2st_wr_pvld
reg        wr_busy_in;                              // inputs being held this cycle?
assign     ld2st_wr_prdy = !wr_busy_in;
wire       ld2st_wr_busy_next;                           // fwd: fifo busy next?

// factor for better timing with distant ld2st_wr_pvld signal
wire       wr_busy_in_next_wr_req_eq_1 = ld2st_wr_busy_next;
wire       wr_busy_in_next_wr_req_eq_0 = (ld2st_wr_pvld_in && ld2st_wr_busy_next) && !wr_reserving;
wire       wr_busy_in_next = (ld2st_wr_pvld? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                               ;
wire       wr_busy_in_int;
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ld2st_wr_pvld_in <=  1'b0;
        wr_busy_in <=  1'b0;
    end else begin
        wr_busy_in <=  wr_busy_in_next;
        if ( !wr_busy_in_int ) begin
            ld2st_wr_pvld_in  <=  ld2st_wr_pvld && !wr_busy_in;
        end
        //synopsys translate_off
            else if ( wr_busy_in_int ) begin
        end else begin
            ld2st_wr_pvld_in  <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

reg        ld2st_wr_busy_int;		        	// copy for internal use
assign       wr_reserving = ld2st_wr_pvld_in && !ld2st_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [4:0] ld2st_wr_count;			// write-side count

wire [4:0] wr_count_next_wr_popping = wr_reserving ? ld2st_wr_count : (ld2st_wr_count - 1'd1); // spyglass disable W164a W484
wire [4:0] wr_count_next_no_wr_popping = wr_reserving ? (ld2st_wr_count + 1'd1) : ld2st_wr_count; // spyglass disable W164a W484
wire [4:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_20 = ( wr_count_next_no_wr_popping == 5'd20 );
wire wr_count_next_is_20 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_20;
wire [4:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [4:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
assign     ld2st_wr_busy_next = wr_count_next_is_20 || // busy next cycle?
                          (wr_limit_reg != 5'd0 &&      // check ld2st_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
assign     wr_busy_in_int = ld2st_wr_pvld_in && ld2st_wr_busy_int;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ld2st_wr_busy_int <=  1'b0;
        ld2st_wr_count <=  5'd0;
    end else begin
	ld2st_wr_busy_int <=  ld2st_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    ld2st_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            ld2st_wr_count <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as ld2st_wr_pvld_in

//
// RAM
//

reg  [4:0] ld2st_wr_adr;			// current write address

// spyglass disable_block W484
// next ld2st_wr_adr if wr_pushing=1
wire [4:0] wr_adr_next = (ld2st_wr_adr == 5'd19) ? 5'd0 : (ld2st_wr_adr + 1'd1);  // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ld2st_wr_adr <=  5'd0;
    end else begin
        if ( wr_pushing ) begin
            ld2st_wr_adr <=  wr_adr_next;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [4:0] ld2st_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (ld2st_wr_count > 5'd0 || !rd_popping);   // note: write occurs next cycle
wire ram_iwe = !wr_busy_in && ld2st_wr_pvld;  
wire [160:0] ld2st_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_BDMA_cq_flopram_rwsa_20x161 ram (
      .clk( nvdla_core_clk )
    , .clk_mgated( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( ld2st_wr_pd )
    , .iwe        ( ram_iwe )
    , .we        ( ram_we )
    , .wa        ( ld2st_wr_adr )
    , .ra        ( (ld2st_wr_count == 0) ? 5'd20 : ld2st_rd_adr )
    , .dout        ( ld2st_rd_pd_p )
    );


wire [4:0] rd_adr_next_popping = (ld2st_rd_adr == 5'd19) ? 5'd0 : (ld2st_rd_adr + 1'd1); // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ld2st_rd_adr <=  5'd0;
    end else begin
        if ( rd_popping ) begin
	    ld2st_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            ld2st_rd_adr <=  {5{`x_or_0}};
        end
        //synopsys translate_on

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

wire       ld2st_rd_pvld_p; 		// data out of fifo is valid

reg        ld2st_rd_pvld_int;	// internal copy of ld2st_rd_pvld
assign     ld2st_rd_pvld = ld2st_rd_pvld_int;
assign     rd_popping = ld2st_rd_pvld_p && !(ld2st_rd_pvld_int && !ld2st_rd_prdy);

reg  [4:0] ld2st_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [4:0] rd_count_p_next_rd_popping = rd_pushing ? ld2st_rd_count_p : 
                                                                (ld2st_rd_count_p - 1'd1);
wire [4:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (ld2st_rd_count_p + 1'd1) : 
                                                                    ld2st_rd_count_p;
// spyglass enable_block W164a W484
wire [4:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     ld2st_rd_pvld_p = ld2st_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ld2st_rd_count_p <=  5'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    ld2st_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            ld2st_rd_count_p <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [160:0]  ld2st_rd_pd;         // output data register
wire        rd_req_next = (ld2st_rd_pvld_p || (ld2st_rd_pvld_int && !ld2st_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ld2st_rd_pvld_int <=  1'b0;
    end else begin
        ld2st_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        ld2st_rd_pd <=  ld2st_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        ld2st_rd_pd <=  {161{`x_or_0}};
    end
    //synopsys translate_on

end
//
// Read-side Idle Calculation
//
wire   rd_idle = !ld2st_rd_pvld_int && !rd_pushing && ld2st_rd_count_p == 0;


//
// Write-Side Idle Calculation
//
wire ld2st_wr_idle_d0 = !ld2st_wr_pvld_in && rd_idle && !wr_pushing && ld2st_wr_count == 0;
wire ld2st_wr_idle = ld2st_wr_idle_d0;


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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (ld2st_wr_pvld_in && !ld2st_wr_busy_int) || (ld2st_wr_busy_int != ld2st_wr_busy_next)) || (rd_pushing || rd_popping || (ld2st_rd_pvld_int && ld2st_rd_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_BDMA_cq_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_BDMA_cq_wr_limit : 5'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 5'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 5'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 5'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [4:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 5'd0;
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
    if ( $test$plusargs( "NV_NVDLA_BDMA_cq_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_BDMA_cq_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {27'd0, (wr_limit_reg == 5'd0) ? 5'd20 : wr_limit_reg} )
    , .curr	( {27'd0, ld2st_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_BDMA_cq") true
// synopsys dc_script_end


endmodule // NV_NVDLA_BDMA_cq

// 
// Flop-Based RAM (with internal wr_reg)
//
module NV_NVDLA_BDMA_cq_flopram_rwsa_20x161 (
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
input  [160:0] di;
input  iwe;
input  we;
input  [4:0] wa;
input  [4:0] ra;
output [160:0] dout;

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

reg [160:0] di_d;  // -wr_reg

always @( posedge clk ) begin
    if ( iwe ) begin
        di_d <=  di; // -wr_reg
    end
end

`ifdef EMU


wire [160:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [4:0] Wa0_vmw;
reg we0_vmw;
reg [160:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di_d;
end

vmw_NV_NVDLA_BDMA_cq_flopram_rwsa_20x161 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 20) ? di_d : dout_p;

`else

reg [160:0] ram_ff0;
reg [160:0] ram_ff1;
reg [160:0] ram_ff2;
reg [160:0] ram_ff3;
reg [160:0] ram_ff4;
reg [160:0] ram_ff5;
reg [160:0] ram_ff6;
reg [160:0] ram_ff7;
reg [160:0] ram_ff8;
reg [160:0] ram_ff9;
reg [160:0] ram_ff10;
reg [160:0] ram_ff11;
reg [160:0] ram_ff12;
reg [160:0] ram_ff13;
reg [160:0] ram_ff14;
reg [160:0] ram_ff15;
reg [160:0] ram_ff16;
reg [160:0] ram_ff17;
reg [160:0] ram_ff18;
reg [160:0] ram_ff19;

always @( posedge clk_mgated ) begin
    if ( we && wa == 5'd0 ) begin
	ram_ff0 <=  di_d;
    end
    if ( we && wa == 5'd1 ) begin
	ram_ff1 <=  di_d;
    end
    if ( we && wa == 5'd2 ) begin
	ram_ff2 <=  di_d;
    end
    if ( we && wa == 5'd3 ) begin
	ram_ff3 <=  di_d;
    end
    if ( we && wa == 5'd4 ) begin
	ram_ff4 <=  di_d;
    end
    if ( we && wa == 5'd5 ) begin
	ram_ff5 <=  di_d;
    end
    if ( we && wa == 5'd6 ) begin
	ram_ff6 <=  di_d;
    end
    if ( we && wa == 5'd7 ) begin
	ram_ff7 <=  di_d;
    end
    if ( we && wa == 5'd8 ) begin
	ram_ff8 <=  di_d;
    end
    if ( we && wa == 5'd9 ) begin
	ram_ff9 <=  di_d;
    end
    if ( we && wa == 5'd10 ) begin
	ram_ff10 <=  di_d;
    end
    if ( we && wa == 5'd11 ) begin
	ram_ff11 <=  di_d;
    end
    if ( we && wa == 5'd12 ) begin
	ram_ff12 <=  di_d;
    end
    if ( we && wa == 5'd13 ) begin
	ram_ff13 <=  di_d;
    end
    if ( we && wa == 5'd14 ) begin
	ram_ff14 <=  di_d;
    end
    if ( we && wa == 5'd15 ) begin
	ram_ff15 <=  di_d;
    end
    if ( we && wa == 5'd16 ) begin
	ram_ff16 <=  di_d;
    end
    if ( we && wa == 5'd17 ) begin
	ram_ff17 <=  di_d;
    end
    if ( we && wa == 5'd18 ) begin
	ram_ff18 <=  di_d;
    end
    if ( we && wa == 5'd19 ) begin
	ram_ff19 <=  di_d;
    end
end

reg [160:0] dout;

always @(*) begin
    case( ra ) 
    5'd0:       dout = ram_ff0;
    5'd1:       dout = ram_ff1;
    5'd2:       dout = ram_ff2;
    5'd3:       dout = ram_ff3;
    5'd4:       dout = ram_ff4;
    5'd5:       dout = ram_ff5;
    5'd6:       dout = ram_ff6;
    5'd7:       dout = ram_ff7;
    5'd8:       dout = ram_ff8;
    5'd9:       dout = ram_ff9;
    5'd10:       dout = ram_ff10;
    5'd11:       dout = ram_ff11;
    5'd12:       dout = ram_ff12;
    5'd13:       dout = ram_ff13;
    5'd14:       dout = ram_ff14;
    5'd15:       dout = ram_ff15;
    5'd16:       dout = ram_ff16;
    5'd17:       dout = ram_ff17;
    5'd18:       dout = ram_ff18;
    5'd19:       dout = ram_ff19;
    5'd20:       dout = di_d;
    //VCS coverage off
    default:    dout = {161{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_BDMA_cq_flopram_rwsa_20x161

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_BDMA_cq_flopram_rwsa_20x161 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [4:0] Wa0;
input            we0;
input  [160:0] Di0;
input  [4:0] Ra0;
output [160:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 161'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [160:0] mem[19:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [160:0] Q0 = mem[0];
wire [160:0] Q1 = mem[1];
wire [160:0] Q2 = mem[2];
wire [160:0] Q3 = mem[3];
wire [160:0] Q4 = mem[4];
wire [160:0] Q5 = mem[5];
wire [160:0] Q6 = mem[6];
wire [160:0] Q7 = mem[7];
wire [160:0] Q8 = mem[8];
wire [160:0] Q9 = mem[9];
wire [160:0] Q10 = mem[10];
wire [160:0] Q11 = mem[11];
wire [160:0] Q12 = mem[12];
wire [160:0] Q13 = mem[13];
wire [160:0] Q14 = mem[14];
wire [160:0] Q15 = mem[15];
wire [160:0] Q16 = mem[16];
wire [160:0] Q17 = mem[17];
wire [160:0] Q18 = mem[18];
wire [160:0] Q19 = mem[19];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_BDMA_cq_flopram_rwsa_20x161] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_BDMA_cq_flopram_rwsa_20x161] }
endmodule // vmw_NV_NVDLA_BDMA_cq_flopram_rwsa_20x161

//vmw: Memory vmw_NV_NVDLA_BDMA_cq_flopram_rwsa_20x161
//vmw: Address-size 5
//vmw: Data-size 161
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[160:0] data0[160:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[160:0] data1[160:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_BDMA_cq_flopram_rwsa_20x161
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

