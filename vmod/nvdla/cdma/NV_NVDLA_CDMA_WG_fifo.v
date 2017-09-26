// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_WG_fifo.v

`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"
module NV_NVDLA_CDMA_WG_fifo (
      clk
    , reset_
    , wr_ready
    , wr_req
    , wr_data
    , rd_ready
    , rd_req
    , rd_data
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         clk;
input         reset_;
output        wr_ready;
input         wr_req;
input  [4:0] wr_data;
input         rd_ready;
output        rd_req;
output [4:0] rd_data;
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
wire clk_mgated_enable;   // assigned by code at end of this module
wire clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power clk_mgate( .clk(clk), .reset_(reset_), .clk_en(clk_mgated_enable), .clk_gated(clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        wr_req_in;                                // registered wr_req
reg  [4:0] wr_data_in;                                // registered wr_data
reg        wr_busy_in;                              // inputs being held this cycle?
assign     wr_ready = !wr_busy_in;
wire       wr_busy_next;                           // fwd: fifo busy next?

// factor for better timing with distant wr_req signal
wire       wr_busy_in_next_wr_req_eq_1 = wr_busy_next;
wire       wr_busy_in_next_wr_req_eq_0 = (wr_req_in && wr_busy_next) && !wr_reserving;
wire       wr_busy_in_next = (wr_req? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                               ;
wire       wr_busy_in_int;
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
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

always @( posedge clk ) begin
    if ( !wr_busy_in && wr_req ) begin
        wr_data_in <=  wr_data;
    end 
    //synopsys translate_off
        else if ( !(!wr_busy_in && wr_req) ) begin
    end else begin
        wr_data_in <=  {5{`x_or_0}};
    end
    //synopsys translate_on

end

reg        wr_busy_int;		        	// copy for internal use
assign       wr_reserving = wr_req_in && !wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [7:0] wr_count;			// write-side count

wire [7:0] wr_count_next_wr_popping = wr_reserving ? wr_count : (wr_count - 1'd1); // spyglass disable W164a W484
wire [7:0] wr_count_next_no_wr_popping = wr_reserving ? (wr_count + 1'd1) : wr_count; // spyglass disable W164a W484
wire [7:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_128 = ( wr_count_next_no_wr_popping == 8'd128 );
wire wr_count_next_is_128 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_128;
wire [7:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [7:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
assign     wr_busy_next = wr_count_next_is_128 || // busy next cycle?
                          (wr_limit_reg != 8'd0 &&      // check wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
assign     wr_busy_in_int = wr_req_in && wr_busy_int;
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_busy_int <=  1'b0;
        wr_count <=  8'd0;
    end else begin
	wr_busy_int <=  wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            wr_count <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as wr_req_in

//
// RAM
//

reg  [6:0] wr_adr;			// current write address
wire [6:0] rd_adr_p;		// read address to use for ram
wire [4:0] rd_data_p;		// read data directly out of ram

wire rd_enable;

wire [31 : 0] pwrbus_ram_pd;

NV_NVDLA_CDMA_WG_fifo_folded_ram_rws_128x5 ram (
      .clk		 ( clk )
    , .clk_mgated        ( clk_mgated )
    , .reset_            ( reset_ )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( wr_adr )
    , .we        ( wr_pushing )
    , .di        ( wr_data_in )
    , .ra        ( rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( rd_data_p )
    );
// next wr_adr if wr_pushing=1
wire [6:0] wr_adr_next = wr_adr + 1'd1;  // spyglass disable W484

// spyglass disable_block W484
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_adr <=  7'd0;
    end else begin
        if ( wr_pushing ) begin
            wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            wr_adr   <=  {7{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [6:0] rd_adr;		// current read address
// next    read address
wire [6:0] rd_adr_next = rd_adr + 1'd1;   // spyglass disable W484
assign         rd_adr_p = rd_popping ? rd_adr_next : rd_adr; // for ram

// spyglass disable_block W484
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_adr <=  7'd0;
    end else begin
        if ( rd_popping ) begin
	    rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            rd_adr <=  {7{`x_or_0}};
        end
        //synopsys translate_on

    end
end
// spyglass enable_block W484

//
// SYNCHRONOUS BOUNDARY
//


always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_popping <=  1'b0;
    end else begin
	wr_popping <=  rd_popping;  
    end
end


reg    rd_pushing;

always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_pushing <=  1'b0;
    end else begin
	rd_pushing <=  wr_pushing;  // let data go into ram first
    end
end

//
// READ SIDE
//

reg        rd_req_p; 		// data out of fifo is valid

reg        rd_req_int;			// internal copy of rd_req
assign     rd_req = rd_req_int;
assign     rd_popping = rd_req_p && !(rd_req_int && !rd_ready);

reg  [7:0] rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [7:0] rd_count_p_next_rd_popping = rd_pushing ? rd_count_p : 
                                                                (rd_count_p - 1'd1);
wire [7:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (rd_count_p + 1'd1) : 
                                                                    rd_count_p;
// spyglass enable_block W164a W484
wire [7:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~rd_req_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_count_p <=  8'd0;
        rd_req_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rd_count_p <=  {8{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    rd_req_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rd_req_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
reg [4:0]  rd_data;         // output data register
wire        rd_req_next = (rd_req_p || (rd_req_int && !rd_ready)) ;

always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_req_int <=  1'b0;
    end else begin
        rd_req_int <=  rd_req_next;
    end
end
always @( posedge clk_mgated ) begin
    if ( (rd_popping) ) begin
        rd_data <=  rd_data_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        rd_data <=  {5{`x_or_0}};
    end
    //synopsys translate_on

end

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
assign clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (wr_req_in && !wr_busy_int) || (wr_busy_int != wr_busy_next)) || (rd_pushing || rd_popping || (rd_req_int && rd_ready) || wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDMA_WG_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDMA_WG_fifo_wr_limit : 8'd0;
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
    if ( $test$plusargs( "NV_NVDLA_CDMA_WG_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDMA_WG_fifo_wr_limit=%d", wr_limit_override_value);
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
      .clk	( clk ) 
    , .max      ( {24'd0, (wr_limit_reg == 8'd0) ? 8'd128 : wr_limit_reg} )
    , .curr	( {24'd0, wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_CDMA_WG_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_CDMA_WG_fifo

// folded ram wrapper
//
module NV_NVDLA_CDMA_WG_fifo_folded_ram_rws_128x5(
      clk
    , clk_mgated
    , reset_
    , pwrbus_ram_pd
    , wa
    , we
    , di
    , ra
    , re
    , dout
    );

input        clk;
input        clk_mgated;
input        reset_;
input [31 : 0] pwrbus_ram_pd;
input  [6:0] wa;
input        we;
input  [4:0] di;
input  [6:0] ra;
input        re;
output [4:0] dout;

// Folded Ram
//
// We assume incrementing write addresses.
// The read address could get backed up if there is flow control.
//
// We keep a write collection buffer (buff).
// We don't write it into the ram (we_f) until we write the first datum of the next row.
// The read side may read from the buffer instead of the ram if the data is there (use_buff_d_next).
// When the read side does read from the ram (re_f), it does it once per row.
//
// One special case to worry about is when a write and read are occurring to the
// same address in the same cycle.  That is allowed only when -ram_bypass_reg
// is in effect.  If -ram_bypass_reg is implemented externally to this module,
// then we just do a dummy use_buff_d_next=1 even though the data will be wrong
// and ignored.  If -ram_bypass_reg is implemented internally to this module (default),
// then we use_buff_d_next=1 and also copy di to buff_d.  Both cases prevent us
// from doing reads to the underlying ram.
//
// In the near future, we will optimize away some unnecessary assertions of we_f and re_f
// to the ram.   We seem to have a general problem at a higher level (even in non-folded
// rams) of having some superfluous assertions of these power-wasting signals.
// Some changes need to be made above this level to fix this.  For now, we keep it
// the same as with non-folded rams.
//
// If master clk gating (SLCG) is in effect, then the logic here is gated
// by the mgated clk, but the ram itself is not gated because it has its own SLCG.
//
reg  [9:0] buff;
reg  [6:0] buff_wa;
wire [5:0] buff_wa_f = buff_wa[6:1];
wire [5:0] ra_f = ra[6:1];
wire       same_addr_write_and_read = we && re && wa == ra;
wire       use_buff_d_next = (ra_f == buff_wa_f && buff_wa[0:0] >= ra[0:0]) || same_addr_write_and_read;
reg        use_buff_d;
wire       we_f = we && wa[0:0] == 1'd0; 
reg        did_re_f;
wire       re_f = re && !use_buff_d_next && (ra[0:0] == 1'd0 || !did_re_f);
reg  [4:0] buff_d;
wire [9:0] dout_f;
reg  [0:0] ro_d;

always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        buff_wa <=  7'd0;
        did_re_f <=  1'd0;
    end else begin
        if ( we ) begin
            buff_wa <= wa;  // note: resettable to avoid ramgen assert during first superfluous write
        end
        did_re_f <=  re_f || (!use_buff_d_next && did_re_f && ra[0:0] != 1'd0);
    end
end

always @( posedge clk_mgated ) begin
    if ( we ) begin
        case( wa[0:0] )
            1'd0: buff[4:0] <= di;
            1'd1: buff[9:5] <= di;
	    // VCS coverage off
            default: buff <=  {10{`x_or_0}};
	    // VCS coverage on
        endcase
    end 

    if ( re ) begin
        if ( use_buff_d_next ) begin
            use_buff_d <=  1'b1;
            case( ra[0:0] )
                1'd0: buff_d <=  buff[4:0];
                1'd1: buff_d <=  buff[9:5];
                // VCS coverage off
                default: buff_d <=  {5{`x_or_0}};
                // VCS coverage on
            endcase
        end else begin
            use_buff_d <=  1'b0;
            ro_d       <=  ra[0:0];
        end
    end
end

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.

nv_ram_rws_64x10 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( clk )
    , .pwrbus_ram_pd           ( pwrbus_ram_pd )
    , .wa		 ( buff_wa_f )
    , .we 		 ( we_f )
    , .di		 ( buff )
    , .ra		 ( ra_f )
    , .re		 ( re_f )
    , .dout		 ( dout_f )
    );

reg  [4:0] dout_fm;

always @(*) begin
    case( ro_d )
        1'd0: dout_fm = dout_f[4:0];
        1'd1: dout_fm = dout_f[9:5];
        // VCS coverage off
        default: dout_fm = {5{`x_or_0}};
        // VCS coverage on
    endcase
end

assign dout = use_buff_d ? buff_d : dout_fm;

endmodule



