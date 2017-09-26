// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_IMG_sg2pack_fifo.v

`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"
module NV_NVDLA_CDMA_IMG_sg2pack_fifo (
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
input  [10:0] wr_data;
input         rd_ready;
output        rd_req;
output [10:0] rd_data;
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

reg        wr_busy_int;		        	// copy for internal use
assign       wr_reserving = wr_req_in && !wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

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

// spyglass disable_block W484
// next wr_adr if wr_pushing=1
wire [6:0] wr_adr_next = wr_adr + 1'd1;  // spyglass disable W484
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_adr <=  7'd0;
    end else begin
        if ( wr_pushing ) begin
            wr_adr <=  wr_adr_next;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [6:0] rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (wr_count > 8'd0 || !rd_popping);   // note: write occurs next cycle
wire ram_iwe = !wr_busy_in && wr_req;  
wire [10:0] rd_data_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CDMA_IMG_sg2pack_fifo_flopram_rwsa_128x11 ram (
      .clk( clk )
    , .clk_mgated( clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( wr_data )
    , .iwe        ( ram_iwe )
    , .we        ( ram_we )
    , .wa        ( wr_adr )
    , .ra        ( (wr_count == 0) ? 8'd128 : {1'b0,rd_adr} )
    , .dout        ( rd_data_p )
    );


wire [6:0] rd_adr_next_popping = rd_adr + 1'd1; // spyglass disable W484
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_adr <=  7'd0;
    end else begin
        if ( rd_popping ) begin
	    rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            rd_adr <=  {7{`x_or_0}};
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

wire       rd_req_p; 		// data out of fifo is valid

reg        rd_req_int;	// internal copy of rd_req
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
assign     rd_req_p = rd_count_p != 0 || rd_pushing;
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_count_p <=  8'd0;
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

    end
end
reg [10:0]  rd_data;         // output data register
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
        rd_data <=  {11{`x_or_0}};
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
assign clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (wr_req_in && !wr_busy_int) || (wr_busy_int != wr_busy_next)) || (rd_pushing || rd_popping || (rd_req_int && rd_ready)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDMA_IMG_sg2pack_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDMA_IMG_sg2pack_fifo_wr_limit : 8'd0;
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
    if ( $test$plusargs( "NV_NVDLA_CDMA_IMG_sg2pack_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDMA_IMG_sg2pack_fifo_wr_limit=%d", wr_limit_override_value);
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
//   set_boundary_optimization find(design, "NV_NVDLA_CDMA_IMG_sg2pack_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_CDMA_IMG_sg2pack_fifo

// 
// Flop-Based RAM (with internal wr_reg)
//
module NV_NVDLA_CDMA_IMG_sg2pack_fifo_flopram_rwsa_128x11 (
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
input  [10:0] di;
input  iwe;
input  we;
input  [6:0] wa;
input  [7:0] ra;
output [10:0] dout;

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

reg [10:0] di_d;  // -wr_reg

always @( posedge clk ) begin
    if ( iwe ) begin
        di_d <=  di; // -wr_reg
    end
end

`ifdef EMU


wire [10:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [6:0] Wa0_vmw;
reg we0_vmw;
reg [10:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di_d;
end

vmw_NV_NVDLA_CDMA_IMG_sg2pack_fifo_flopram_rwsa_128x11 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[6:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 128) ? di_d : dout_p;

`else

reg [10:0] ram_ff0;
reg [10:0] ram_ff1;
reg [10:0] ram_ff2;
reg [10:0] ram_ff3;
reg [10:0] ram_ff4;
reg [10:0] ram_ff5;
reg [10:0] ram_ff6;
reg [10:0] ram_ff7;
reg [10:0] ram_ff8;
reg [10:0] ram_ff9;
reg [10:0] ram_ff10;
reg [10:0] ram_ff11;
reg [10:0] ram_ff12;
reg [10:0] ram_ff13;
reg [10:0] ram_ff14;
reg [10:0] ram_ff15;
reg [10:0] ram_ff16;
reg [10:0] ram_ff17;
reg [10:0] ram_ff18;
reg [10:0] ram_ff19;
reg [10:0] ram_ff20;
reg [10:0] ram_ff21;
reg [10:0] ram_ff22;
reg [10:0] ram_ff23;
reg [10:0] ram_ff24;
reg [10:0] ram_ff25;
reg [10:0] ram_ff26;
reg [10:0] ram_ff27;
reg [10:0] ram_ff28;
reg [10:0] ram_ff29;
reg [10:0] ram_ff30;
reg [10:0] ram_ff31;
reg [10:0] ram_ff32;
reg [10:0] ram_ff33;
reg [10:0] ram_ff34;
reg [10:0] ram_ff35;
reg [10:0] ram_ff36;
reg [10:0] ram_ff37;
reg [10:0] ram_ff38;
reg [10:0] ram_ff39;
reg [10:0] ram_ff40;
reg [10:0] ram_ff41;
reg [10:0] ram_ff42;
reg [10:0] ram_ff43;
reg [10:0] ram_ff44;
reg [10:0] ram_ff45;
reg [10:0] ram_ff46;
reg [10:0] ram_ff47;
reg [10:0] ram_ff48;
reg [10:0] ram_ff49;
reg [10:0] ram_ff50;
reg [10:0] ram_ff51;
reg [10:0] ram_ff52;
reg [10:0] ram_ff53;
reg [10:0] ram_ff54;
reg [10:0] ram_ff55;
reg [10:0] ram_ff56;
reg [10:0] ram_ff57;
reg [10:0] ram_ff58;
reg [10:0] ram_ff59;
reg [10:0] ram_ff60;
reg [10:0] ram_ff61;
reg [10:0] ram_ff62;
reg [10:0] ram_ff63;
reg [10:0] ram_ff64;
reg [10:0] ram_ff65;
reg [10:0] ram_ff66;
reg [10:0] ram_ff67;
reg [10:0] ram_ff68;
reg [10:0] ram_ff69;
reg [10:0] ram_ff70;
reg [10:0] ram_ff71;
reg [10:0] ram_ff72;
reg [10:0] ram_ff73;
reg [10:0] ram_ff74;
reg [10:0] ram_ff75;
reg [10:0] ram_ff76;
reg [10:0] ram_ff77;
reg [10:0] ram_ff78;
reg [10:0] ram_ff79;
reg [10:0] ram_ff80;
reg [10:0] ram_ff81;
reg [10:0] ram_ff82;
reg [10:0] ram_ff83;
reg [10:0] ram_ff84;
reg [10:0] ram_ff85;
reg [10:0] ram_ff86;
reg [10:0] ram_ff87;
reg [10:0] ram_ff88;
reg [10:0] ram_ff89;
reg [10:0] ram_ff90;
reg [10:0] ram_ff91;
reg [10:0] ram_ff92;
reg [10:0] ram_ff93;
reg [10:0] ram_ff94;
reg [10:0] ram_ff95;
reg [10:0] ram_ff96;
reg [10:0] ram_ff97;
reg [10:0] ram_ff98;
reg [10:0] ram_ff99;
reg [10:0] ram_ff100;
reg [10:0] ram_ff101;
reg [10:0] ram_ff102;
reg [10:0] ram_ff103;
reg [10:0] ram_ff104;
reg [10:0] ram_ff105;
reg [10:0] ram_ff106;
reg [10:0] ram_ff107;
reg [10:0] ram_ff108;
reg [10:0] ram_ff109;
reg [10:0] ram_ff110;
reg [10:0] ram_ff111;
reg [10:0] ram_ff112;
reg [10:0] ram_ff113;
reg [10:0] ram_ff114;
reg [10:0] ram_ff115;
reg [10:0] ram_ff116;
reg [10:0] ram_ff117;
reg [10:0] ram_ff118;
reg [10:0] ram_ff119;
reg [10:0] ram_ff120;
reg [10:0] ram_ff121;
reg [10:0] ram_ff122;
reg [10:0] ram_ff123;
reg [10:0] ram_ff124;
reg [10:0] ram_ff125;
reg [10:0] ram_ff126;
reg [10:0] ram_ff127;

always @( posedge clk_mgated ) begin
    if ( we && wa == 7'd0 ) begin
	ram_ff0 <=  di_d;
    end
    if ( we && wa == 7'd1 ) begin
	ram_ff1 <=  di_d;
    end
    if ( we && wa == 7'd2 ) begin
	ram_ff2 <=  di_d;
    end
    if ( we && wa == 7'd3 ) begin
	ram_ff3 <=  di_d;
    end
    if ( we && wa == 7'd4 ) begin
	ram_ff4 <=  di_d;
    end
    if ( we && wa == 7'd5 ) begin
	ram_ff5 <=  di_d;
    end
    if ( we && wa == 7'd6 ) begin
	ram_ff6 <=  di_d;
    end
    if ( we && wa == 7'd7 ) begin
	ram_ff7 <=  di_d;
    end
    if ( we && wa == 7'd8 ) begin
	ram_ff8 <=  di_d;
    end
    if ( we && wa == 7'd9 ) begin
	ram_ff9 <=  di_d;
    end
    if ( we && wa == 7'd10 ) begin
	ram_ff10 <=  di_d;
    end
    if ( we && wa == 7'd11 ) begin
	ram_ff11 <=  di_d;
    end
    if ( we && wa == 7'd12 ) begin
	ram_ff12 <=  di_d;
    end
    if ( we && wa == 7'd13 ) begin
	ram_ff13 <=  di_d;
    end
    if ( we && wa == 7'd14 ) begin
	ram_ff14 <=  di_d;
    end
    if ( we && wa == 7'd15 ) begin
	ram_ff15 <=  di_d;
    end
    if ( we && wa == 7'd16 ) begin
	ram_ff16 <=  di_d;
    end
    if ( we && wa == 7'd17 ) begin
	ram_ff17 <=  di_d;
    end
    if ( we && wa == 7'd18 ) begin
	ram_ff18 <=  di_d;
    end
    if ( we && wa == 7'd19 ) begin
	ram_ff19 <=  di_d;
    end
    if ( we && wa == 7'd20 ) begin
	ram_ff20 <=  di_d;
    end
    if ( we && wa == 7'd21 ) begin
	ram_ff21 <=  di_d;
    end
    if ( we && wa == 7'd22 ) begin
	ram_ff22 <=  di_d;
    end
    if ( we && wa == 7'd23 ) begin
	ram_ff23 <=  di_d;
    end
    if ( we && wa == 7'd24 ) begin
	ram_ff24 <=  di_d;
    end
    if ( we && wa == 7'd25 ) begin
	ram_ff25 <=  di_d;
    end
    if ( we && wa == 7'd26 ) begin
	ram_ff26 <=  di_d;
    end
    if ( we && wa == 7'd27 ) begin
	ram_ff27 <=  di_d;
    end
    if ( we && wa == 7'd28 ) begin
	ram_ff28 <=  di_d;
    end
    if ( we && wa == 7'd29 ) begin
	ram_ff29 <=  di_d;
    end
    if ( we && wa == 7'd30 ) begin
	ram_ff30 <=  di_d;
    end
    if ( we && wa == 7'd31 ) begin
	ram_ff31 <=  di_d;
    end
    if ( we && wa == 7'd32 ) begin
	ram_ff32 <=  di_d;
    end
    if ( we && wa == 7'd33 ) begin
	ram_ff33 <=  di_d;
    end
    if ( we && wa == 7'd34 ) begin
	ram_ff34 <=  di_d;
    end
    if ( we && wa == 7'd35 ) begin
	ram_ff35 <=  di_d;
    end
    if ( we && wa == 7'd36 ) begin
	ram_ff36 <=  di_d;
    end
    if ( we && wa == 7'd37 ) begin
	ram_ff37 <=  di_d;
    end
    if ( we && wa == 7'd38 ) begin
	ram_ff38 <=  di_d;
    end
    if ( we && wa == 7'd39 ) begin
	ram_ff39 <=  di_d;
    end
    if ( we && wa == 7'd40 ) begin
	ram_ff40 <=  di_d;
    end
    if ( we && wa == 7'd41 ) begin
	ram_ff41 <=  di_d;
    end
    if ( we && wa == 7'd42 ) begin
	ram_ff42 <=  di_d;
    end
    if ( we && wa == 7'd43 ) begin
	ram_ff43 <=  di_d;
    end
    if ( we && wa == 7'd44 ) begin
	ram_ff44 <=  di_d;
    end
    if ( we && wa == 7'd45 ) begin
	ram_ff45 <=  di_d;
    end
    if ( we && wa == 7'd46 ) begin
	ram_ff46 <=  di_d;
    end
    if ( we && wa == 7'd47 ) begin
	ram_ff47 <=  di_d;
    end
    if ( we && wa == 7'd48 ) begin
	ram_ff48 <=  di_d;
    end
    if ( we && wa == 7'd49 ) begin
	ram_ff49 <=  di_d;
    end
    if ( we && wa == 7'd50 ) begin
	ram_ff50 <=  di_d;
    end
    if ( we && wa == 7'd51 ) begin
	ram_ff51 <=  di_d;
    end
    if ( we && wa == 7'd52 ) begin
	ram_ff52 <=  di_d;
    end
    if ( we && wa == 7'd53 ) begin
	ram_ff53 <=  di_d;
    end
    if ( we && wa == 7'd54 ) begin
	ram_ff54 <=  di_d;
    end
    if ( we && wa == 7'd55 ) begin
	ram_ff55 <=  di_d;
    end
    if ( we && wa == 7'd56 ) begin
	ram_ff56 <=  di_d;
    end
    if ( we && wa == 7'd57 ) begin
	ram_ff57 <=  di_d;
    end
    if ( we && wa == 7'd58 ) begin
	ram_ff58 <=  di_d;
    end
    if ( we && wa == 7'd59 ) begin
	ram_ff59 <=  di_d;
    end
    if ( we && wa == 7'd60 ) begin
	ram_ff60 <=  di_d;
    end
    if ( we && wa == 7'd61 ) begin
	ram_ff61 <=  di_d;
    end
    if ( we && wa == 7'd62 ) begin
	ram_ff62 <=  di_d;
    end
    if ( we && wa == 7'd63 ) begin
	ram_ff63 <=  di_d;
    end
    if ( we && wa == 7'd64 ) begin
	ram_ff64 <=  di_d;
    end
    if ( we && wa == 7'd65 ) begin
	ram_ff65 <=  di_d;
    end
    if ( we && wa == 7'd66 ) begin
	ram_ff66 <=  di_d;
    end
    if ( we && wa == 7'd67 ) begin
	ram_ff67 <=  di_d;
    end
    if ( we && wa == 7'd68 ) begin
	ram_ff68 <=  di_d;
    end
    if ( we && wa == 7'd69 ) begin
	ram_ff69 <=  di_d;
    end
    if ( we && wa == 7'd70 ) begin
	ram_ff70 <=  di_d;
    end
    if ( we && wa == 7'd71 ) begin
	ram_ff71 <=  di_d;
    end
    if ( we && wa == 7'd72 ) begin
	ram_ff72 <=  di_d;
    end
    if ( we && wa == 7'd73 ) begin
	ram_ff73 <=  di_d;
    end
    if ( we && wa == 7'd74 ) begin
	ram_ff74 <=  di_d;
    end
    if ( we && wa == 7'd75 ) begin
	ram_ff75 <=  di_d;
    end
    if ( we && wa == 7'd76 ) begin
	ram_ff76 <=  di_d;
    end
    if ( we && wa == 7'd77 ) begin
	ram_ff77 <=  di_d;
    end
    if ( we && wa == 7'd78 ) begin
	ram_ff78 <=  di_d;
    end
    if ( we && wa == 7'd79 ) begin
	ram_ff79 <=  di_d;
    end
    if ( we && wa == 7'd80 ) begin
	ram_ff80 <=  di_d;
    end
    if ( we && wa == 7'd81 ) begin
	ram_ff81 <=  di_d;
    end
    if ( we && wa == 7'd82 ) begin
	ram_ff82 <=  di_d;
    end
    if ( we && wa == 7'd83 ) begin
	ram_ff83 <=  di_d;
    end
    if ( we && wa == 7'd84 ) begin
	ram_ff84 <=  di_d;
    end
    if ( we && wa == 7'd85 ) begin
	ram_ff85 <=  di_d;
    end
    if ( we && wa == 7'd86 ) begin
	ram_ff86 <=  di_d;
    end
    if ( we && wa == 7'd87 ) begin
	ram_ff87 <=  di_d;
    end
    if ( we && wa == 7'd88 ) begin
	ram_ff88 <=  di_d;
    end
    if ( we && wa == 7'd89 ) begin
	ram_ff89 <=  di_d;
    end
    if ( we && wa == 7'd90 ) begin
	ram_ff90 <=  di_d;
    end
    if ( we && wa == 7'd91 ) begin
	ram_ff91 <=  di_d;
    end
    if ( we && wa == 7'd92 ) begin
	ram_ff92 <=  di_d;
    end
    if ( we && wa == 7'd93 ) begin
	ram_ff93 <=  di_d;
    end
    if ( we && wa == 7'd94 ) begin
	ram_ff94 <=  di_d;
    end
    if ( we && wa == 7'd95 ) begin
	ram_ff95 <=  di_d;
    end
    if ( we && wa == 7'd96 ) begin
	ram_ff96 <=  di_d;
    end
    if ( we && wa == 7'd97 ) begin
	ram_ff97 <=  di_d;
    end
    if ( we && wa == 7'd98 ) begin
	ram_ff98 <=  di_d;
    end
    if ( we && wa == 7'd99 ) begin
	ram_ff99 <=  di_d;
    end
    if ( we && wa == 7'd100 ) begin
	ram_ff100 <=  di_d;
    end
    if ( we && wa == 7'd101 ) begin
	ram_ff101 <=  di_d;
    end
    if ( we && wa == 7'd102 ) begin
	ram_ff102 <=  di_d;
    end
    if ( we && wa == 7'd103 ) begin
	ram_ff103 <=  di_d;
    end
    if ( we && wa == 7'd104 ) begin
	ram_ff104 <=  di_d;
    end
    if ( we && wa == 7'd105 ) begin
	ram_ff105 <=  di_d;
    end
    if ( we && wa == 7'd106 ) begin
	ram_ff106 <=  di_d;
    end
    if ( we && wa == 7'd107 ) begin
	ram_ff107 <=  di_d;
    end
    if ( we && wa == 7'd108 ) begin
	ram_ff108 <=  di_d;
    end
    if ( we && wa == 7'd109 ) begin
	ram_ff109 <=  di_d;
    end
    if ( we && wa == 7'd110 ) begin
	ram_ff110 <=  di_d;
    end
    if ( we && wa == 7'd111 ) begin
	ram_ff111 <=  di_d;
    end
    if ( we && wa == 7'd112 ) begin
	ram_ff112 <=  di_d;
    end
    if ( we && wa == 7'd113 ) begin
	ram_ff113 <=  di_d;
    end
    if ( we && wa == 7'd114 ) begin
	ram_ff114 <=  di_d;
    end
    if ( we && wa == 7'd115 ) begin
	ram_ff115 <=  di_d;
    end
    if ( we && wa == 7'd116 ) begin
	ram_ff116 <=  di_d;
    end
    if ( we && wa == 7'd117 ) begin
	ram_ff117 <=  di_d;
    end
    if ( we && wa == 7'd118 ) begin
	ram_ff118 <=  di_d;
    end
    if ( we && wa == 7'd119 ) begin
	ram_ff119 <=  di_d;
    end
    if ( we && wa == 7'd120 ) begin
	ram_ff120 <=  di_d;
    end
    if ( we && wa == 7'd121 ) begin
	ram_ff121 <=  di_d;
    end
    if ( we && wa == 7'd122 ) begin
	ram_ff122 <=  di_d;
    end
    if ( we && wa == 7'd123 ) begin
	ram_ff123 <=  di_d;
    end
    if ( we && wa == 7'd124 ) begin
	ram_ff124 <=  di_d;
    end
    if ( we && wa == 7'd125 ) begin
	ram_ff125 <=  di_d;
    end
    if ( we && wa == 7'd126 ) begin
	ram_ff126 <=  di_d;
    end
    if ( we && wa == 7'd127 ) begin
	ram_ff127 <=  di_d;
    end
end

reg [10:0] dout;

always @(*) begin
    case( ra ) 
    8'd0:       dout = ram_ff0;
    8'd1:       dout = ram_ff1;
    8'd2:       dout = ram_ff2;
    8'd3:       dout = ram_ff3;
    8'd4:       dout = ram_ff4;
    8'd5:       dout = ram_ff5;
    8'd6:       dout = ram_ff6;
    8'd7:       dout = ram_ff7;
    8'd8:       dout = ram_ff8;
    8'd9:       dout = ram_ff9;
    8'd10:       dout = ram_ff10;
    8'd11:       dout = ram_ff11;
    8'd12:       dout = ram_ff12;
    8'd13:       dout = ram_ff13;
    8'd14:       dout = ram_ff14;
    8'd15:       dout = ram_ff15;
    8'd16:       dout = ram_ff16;
    8'd17:       dout = ram_ff17;
    8'd18:       dout = ram_ff18;
    8'd19:       dout = ram_ff19;
    8'd20:       dout = ram_ff20;
    8'd21:       dout = ram_ff21;
    8'd22:       dout = ram_ff22;
    8'd23:       dout = ram_ff23;
    8'd24:       dout = ram_ff24;
    8'd25:       dout = ram_ff25;
    8'd26:       dout = ram_ff26;
    8'd27:       dout = ram_ff27;
    8'd28:       dout = ram_ff28;
    8'd29:       dout = ram_ff29;
    8'd30:       dout = ram_ff30;
    8'd31:       dout = ram_ff31;
    8'd32:       dout = ram_ff32;
    8'd33:       dout = ram_ff33;
    8'd34:       dout = ram_ff34;
    8'd35:       dout = ram_ff35;
    8'd36:       dout = ram_ff36;
    8'd37:       dout = ram_ff37;
    8'd38:       dout = ram_ff38;
    8'd39:       dout = ram_ff39;
    8'd40:       dout = ram_ff40;
    8'd41:       dout = ram_ff41;
    8'd42:       dout = ram_ff42;
    8'd43:       dout = ram_ff43;
    8'd44:       dout = ram_ff44;
    8'd45:       dout = ram_ff45;
    8'd46:       dout = ram_ff46;
    8'd47:       dout = ram_ff47;
    8'd48:       dout = ram_ff48;
    8'd49:       dout = ram_ff49;
    8'd50:       dout = ram_ff50;
    8'd51:       dout = ram_ff51;
    8'd52:       dout = ram_ff52;
    8'd53:       dout = ram_ff53;
    8'd54:       dout = ram_ff54;
    8'd55:       dout = ram_ff55;
    8'd56:       dout = ram_ff56;
    8'd57:       dout = ram_ff57;
    8'd58:       dout = ram_ff58;
    8'd59:       dout = ram_ff59;
    8'd60:       dout = ram_ff60;
    8'd61:       dout = ram_ff61;
    8'd62:       dout = ram_ff62;
    8'd63:       dout = ram_ff63;
    8'd64:       dout = ram_ff64;
    8'd65:       dout = ram_ff65;
    8'd66:       dout = ram_ff66;
    8'd67:       dout = ram_ff67;
    8'd68:       dout = ram_ff68;
    8'd69:       dout = ram_ff69;
    8'd70:       dout = ram_ff70;
    8'd71:       dout = ram_ff71;
    8'd72:       dout = ram_ff72;
    8'd73:       dout = ram_ff73;
    8'd74:       dout = ram_ff74;
    8'd75:       dout = ram_ff75;
    8'd76:       dout = ram_ff76;
    8'd77:       dout = ram_ff77;
    8'd78:       dout = ram_ff78;
    8'd79:       dout = ram_ff79;
    8'd80:       dout = ram_ff80;
    8'd81:       dout = ram_ff81;
    8'd82:       dout = ram_ff82;
    8'd83:       dout = ram_ff83;
    8'd84:       dout = ram_ff84;
    8'd85:       dout = ram_ff85;
    8'd86:       dout = ram_ff86;
    8'd87:       dout = ram_ff87;
    8'd88:       dout = ram_ff88;
    8'd89:       dout = ram_ff89;
    8'd90:       dout = ram_ff90;
    8'd91:       dout = ram_ff91;
    8'd92:       dout = ram_ff92;
    8'd93:       dout = ram_ff93;
    8'd94:       dout = ram_ff94;
    8'd95:       dout = ram_ff95;
    8'd96:       dout = ram_ff96;
    8'd97:       dout = ram_ff97;
    8'd98:       dout = ram_ff98;
    8'd99:       dout = ram_ff99;
    8'd100:       dout = ram_ff100;
    8'd101:       dout = ram_ff101;
    8'd102:       dout = ram_ff102;
    8'd103:       dout = ram_ff103;
    8'd104:       dout = ram_ff104;
    8'd105:       dout = ram_ff105;
    8'd106:       dout = ram_ff106;
    8'd107:       dout = ram_ff107;
    8'd108:       dout = ram_ff108;
    8'd109:       dout = ram_ff109;
    8'd110:       dout = ram_ff110;
    8'd111:       dout = ram_ff111;
    8'd112:       dout = ram_ff112;
    8'd113:       dout = ram_ff113;
    8'd114:       dout = ram_ff114;
    8'd115:       dout = ram_ff115;
    8'd116:       dout = ram_ff116;
    8'd117:       dout = ram_ff117;
    8'd118:       dout = ram_ff118;
    8'd119:       dout = ram_ff119;
    8'd120:       dout = ram_ff120;
    8'd121:       dout = ram_ff121;
    8'd122:       dout = ram_ff122;
    8'd123:       dout = ram_ff123;
    8'd124:       dout = ram_ff124;
    8'd125:       dout = ram_ff125;
    8'd126:       dout = ram_ff126;
    8'd127:       dout = ram_ff127;
    8'd128:       dout = di_d;
    //VCS coverage off
    default:    dout = {11{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CDMA_IMG_sg2pack_fifo_flopram_rwsa_128x11

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CDMA_IMG_sg2pack_fifo_flopram_rwsa_128x11 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [6:0] Wa0;
input            we0;
input  [10:0] Di0;
input  [6:0] Ra0;
output [10:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 11'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [10:0] mem[127:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [10:0] Q0 = mem[0];
wire [10:0] Q1 = mem[1];
wire [10:0] Q2 = mem[2];
wire [10:0] Q3 = mem[3];
wire [10:0] Q4 = mem[4];
wire [10:0] Q5 = mem[5];
wire [10:0] Q6 = mem[6];
wire [10:0] Q7 = mem[7];
wire [10:0] Q8 = mem[8];
wire [10:0] Q9 = mem[9];
wire [10:0] Q10 = mem[10];
wire [10:0] Q11 = mem[11];
wire [10:0] Q12 = mem[12];
wire [10:0] Q13 = mem[13];
wire [10:0] Q14 = mem[14];
wire [10:0] Q15 = mem[15];
wire [10:0] Q16 = mem[16];
wire [10:0] Q17 = mem[17];
wire [10:0] Q18 = mem[18];
wire [10:0] Q19 = mem[19];
wire [10:0] Q20 = mem[20];
wire [10:0] Q21 = mem[21];
wire [10:0] Q22 = mem[22];
wire [10:0] Q23 = mem[23];
wire [10:0] Q24 = mem[24];
wire [10:0] Q25 = mem[25];
wire [10:0] Q26 = mem[26];
wire [10:0] Q27 = mem[27];
wire [10:0] Q28 = mem[28];
wire [10:0] Q29 = mem[29];
wire [10:0] Q30 = mem[30];
wire [10:0] Q31 = mem[31];
wire [10:0] Q32 = mem[32];
wire [10:0] Q33 = mem[33];
wire [10:0] Q34 = mem[34];
wire [10:0] Q35 = mem[35];
wire [10:0] Q36 = mem[36];
wire [10:0] Q37 = mem[37];
wire [10:0] Q38 = mem[38];
wire [10:0] Q39 = mem[39];
wire [10:0] Q40 = mem[40];
wire [10:0] Q41 = mem[41];
wire [10:0] Q42 = mem[42];
wire [10:0] Q43 = mem[43];
wire [10:0] Q44 = mem[44];
wire [10:0] Q45 = mem[45];
wire [10:0] Q46 = mem[46];
wire [10:0] Q47 = mem[47];
wire [10:0] Q48 = mem[48];
wire [10:0] Q49 = mem[49];
wire [10:0] Q50 = mem[50];
wire [10:0] Q51 = mem[51];
wire [10:0] Q52 = mem[52];
wire [10:0] Q53 = mem[53];
wire [10:0] Q54 = mem[54];
wire [10:0] Q55 = mem[55];
wire [10:0] Q56 = mem[56];
wire [10:0] Q57 = mem[57];
wire [10:0] Q58 = mem[58];
wire [10:0] Q59 = mem[59];
wire [10:0] Q60 = mem[60];
wire [10:0] Q61 = mem[61];
wire [10:0] Q62 = mem[62];
wire [10:0] Q63 = mem[63];
wire [10:0] Q64 = mem[64];
wire [10:0] Q65 = mem[65];
wire [10:0] Q66 = mem[66];
wire [10:0] Q67 = mem[67];
wire [10:0] Q68 = mem[68];
wire [10:0] Q69 = mem[69];
wire [10:0] Q70 = mem[70];
wire [10:0] Q71 = mem[71];
wire [10:0] Q72 = mem[72];
wire [10:0] Q73 = mem[73];
wire [10:0] Q74 = mem[74];
wire [10:0] Q75 = mem[75];
wire [10:0] Q76 = mem[76];
wire [10:0] Q77 = mem[77];
wire [10:0] Q78 = mem[78];
wire [10:0] Q79 = mem[79];
wire [10:0] Q80 = mem[80];
wire [10:0] Q81 = mem[81];
wire [10:0] Q82 = mem[82];
wire [10:0] Q83 = mem[83];
wire [10:0] Q84 = mem[84];
wire [10:0] Q85 = mem[85];
wire [10:0] Q86 = mem[86];
wire [10:0] Q87 = mem[87];
wire [10:0] Q88 = mem[88];
wire [10:0] Q89 = mem[89];
wire [10:0] Q90 = mem[90];
wire [10:0] Q91 = mem[91];
wire [10:0] Q92 = mem[92];
wire [10:0] Q93 = mem[93];
wire [10:0] Q94 = mem[94];
wire [10:0] Q95 = mem[95];
wire [10:0] Q96 = mem[96];
wire [10:0] Q97 = mem[97];
wire [10:0] Q98 = mem[98];
wire [10:0] Q99 = mem[99];
wire [10:0] Q100 = mem[100];
wire [10:0] Q101 = mem[101];
wire [10:0] Q102 = mem[102];
wire [10:0] Q103 = mem[103];
wire [10:0] Q104 = mem[104];
wire [10:0] Q105 = mem[105];
wire [10:0] Q106 = mem[106];
wire [10:0] Q107 = mem[107];
wire [10:0] Q108 = mem[108];
wire [10:0] Q109 = mem[109];
wire [10:0] Q110 = mem[110];
wire [10:0] Q111 = mem[111];
wire [10:0] Q112 = mem[112];
wire [10:0] Q113 = mem[113];
wire [10:0] Q114 = mem[114];
wire [10:0] Q115 = mem[115];
wire [10:0] Q116 = mem[116];
wire [10:0] Q117 = mem[117];
wire [10:0] Q118 = mem[118];
wire [10:0] Q119 = mem[119];
wire [10:0] Q120 = mem[120];
wire [10:0] Q121 = mem[121];
wire [10:0] Q122 = mem[122];
wire [10:0] Q123 = mem[123];
wire [10:0] Q124 = mem[124];
wire [10:0] Q125 = mem[125];
wire [10:0] Q126 = mem[126];
wire [10:0] Q127 = mem[127];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CDMA_IMG_sg2pack_fifo_flopram_rwsa_128x11] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CDMA_IMG_sg2pack_fifo_flopram_rwsa_128x11] }
endmodule // vmw_NV_NVDLA_CDMA_IMG_sg2pack_fifo_flopram_rwsa_128x11

//vmw: Memory vmw_NV_NVDLA_CDMA_IMG_sg2pack_fifo_flopram_rwsa_128x11
//vmw: Address-size 7
//vmw: Data-size 11
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[10:0] data0[10:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[10:0] data1[10:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CDMA_IMG_sg2pack_fifo_flopram_rwsa_128x11
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

