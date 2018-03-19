// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_WRITE_IG_spt_s.v

#include "NV_NVDLA_MCIF_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_WRITE_IG_spt_s (
   nvdla_core_clk    //|< i
  ,nvdla_core_rstn   //|< i
  ,arb2spt_cmd_valid //|< i
  ,arb2spt_cmd_ready //|> o
  ,arb2spt_cmd_pd    //|< i
  ,arb2spt_dat_valid //|< i
  ,arb2spt_dat_ready //|> o
  ,arb2spt_dat_pd    //|< i
  ,spt2cvt_cmd_valid //|> o
  ,spt2cvt_cmd_ready //|< i
  ,spt2cvt_cmd_pd    //|> o
  ,spt2cvt_dat_valid //|> o
  ,spt2cvt_dat_ready //|< i
  ,spt2cvt_dat_pd    //|> o
  ,pwrbus_ram_pd     //|< i
  );
//
// NV_NVDLA_MCIF_WRITE_IG_spt_ports.v
//
/////////////////////////////////////////////////////////
input  nvdla_core_clk;
input  nvdla_core_rstn; 

input         arb2spt_cmd_valid;
output        arb2spt_cmd_ready; 
input  [44:0] arb2spt_cmd_pd;

input          arb2spt_dat_valid; 
output         arb2spt_dat_ready; 
input  [MEMRSP_PD_BW-1:0] arb2spt_dat_pd;

output        spt2cvt_cmd_valid; 
input         spt2cvt_cmd_ready; 
output [44:0] spt2cvt_cmd_pd;

output         spt2cvt_dat_valid; 
input          spt2cvt_dat_ready;
output [MEMRSP_PD_BW-1:0] spt2cvt_dat_pd;

input [31:0] pwrbus_ram_pd;
/////////////////////////////////////////////////////////
reg    [2:0] out_size;
reg    [1:0] tran_count;
wire   [2:0] arb2spt_dat_count;
wire         cvt_cmd_accept;
wire  [31:0] cvt_cmd_addr;
wire   [3:0] cvt_cmd_axid;
wire         cvt_cmd_ftran;
wire         cvt_cmd_inc;
wire         cvt_cmd_ltran;
wire         cvt_cmd_odd;
wire         cvt_cmd_rdy;
wire         cvt_cmd_require_ack;
wire   [2:0] cvt_cmd_size;
wire         cvt_cmd_swizzle;
wire [MEM_BW-1:0] cvt_dat_data;
//wire   [1:0] cvt_dat_mask;
wire         cvt_dat_rdy;
wire   [1:0] first_addr_offset;
wire         is_first_tran;
wire         is_last_tran;
wire   [1:0] non_first_addr_offset;
wire  [31:0] out_addr;
wire   [1:0] out_addr_offset;
wire         out_ftran;
wire         out_ltran;
wire  [31:0] spt_cmd_addr;
wire   [3:0] spt_cmd_axid;
wire         spt_cmd_ftran;
wire         spt_cmd_inc;
wire         spt_cmd_ltran;
wire         spt_cmd_odd;
wire   [2:0] spt_cmd_offset;
wire         spt_cmd_rdy;
wire         spt_cmd_require_ack;
wire   [2:0] spt_cmd_size;
wire         spt_cmd_swizzle;
wire  [44:0] spt_cmd_vld_pd;
wire [MEM_BW-1:0] spt_dat_data;
wire [MEMRSP_PD_BW-1:0] spt_dat_pd;
wire         spt_dat_rdy;
wire         spt_dat_vld;
///////////////////////////////////////////////////////
//: &eperl::pipe("-wid 45 -do spt_cmd_pd -vo spt_cmd_vld -ri spt_cmd_rdy -di arb2spt_cmd_pd -vi arb2spt_cmd_valid -ro arb2spt_cmd_ready ");
assign spt_cmd_vld_pd = {45 {spt_cmd_vld}} & spt_cmd_pd;

assign        spt_cmd_axid[3:0] =    spt_cmd_vld_pd[3:0];
assign         spt_cmd_require_ack  =    spt_cmd_vld_pd[4];
assign        spt_cmd_addr[31:0] =    spt_cmd_vld_pd[36:5];
assign        spt_cmd_size[2:0] =    spt_cmd_vld_pd[39:37];
assign         spt_cmd_swizzle  =    spt_cmd_vld_pd[40];
assign         spt_cmd_odd  =    spt_cmd_vld_pd[41];
assign         spt_cmd_inc  =    spt_cmd_vld_pd[42];
assign         spt_cmd_ltran  =    spt_cmd_vld_pd[43];
assign         spt_cmd_ftran  =    spt_cmd_vld_pd[44];

assign spt_cmd_rdy = cvt_cmd_rdy && is_last_tran;

// Dat PIPE
assign arb2spt_dat_ready = (arb2spt_dat_count<=1);

NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo u_dfifo (//
   .nvdla_core_clk    (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)        //|< i
  ,.dfifo_wr_count    (arb2spt_dat_count[2:0]) //|> w
  ,.dfifo_wr_pvld     (arb2spt_dat_valid)      //|< i
  ,.dfifo_wr_pd       (arb2spt_dat_pd)  //|< i
  ,.dfifo_rd_prdy     (spt_dat_rdy)            //|< w
  ,.dfifo_rd_pvld     (spt_dat_vld)            //|> w
  ,.dfifo_rd_pd       (spt_dat_pd)      //|> w
  ,.pwrbus_ram_pd     (pwrbus_ram_pd[31:0])    //|< i
  );
//&Connect dfifo_wr_prdy  ;

// first beat of data need be accepted together with cmd, and the rest data will just need accepted alone 
assign spt_dat_rdy =  cvt_dat_rdy;

assign spt_dat_data =    spt_dat_pd[MEM_BW-1:0];
//==============
// size -> size_64 mapping & Split
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    tran_count <= {2{1'b0}};
  end else if (cvt_cmd_accept) begin
        if (is_last_tran) begin
            tran_count <= 0;
        end else begin
            tran_count <= tran_count + 1;
        end
  end
end
assign is_last_tran  = (tran_count==spt_cmd_size[1:0]);
assign is_first_tran = (tran_count==0);

//==============
// OUT: FTRAN / LTRAN
//==============
assign out_ftran = is_first_tran & spt_cmd_ftran;
assign out_ltran = is_last_tran & spt_cmd_ltran;
//==============
// OUT: SIZE
//==============
assign out_size = 3'd0;//atomic_m=memif always one atm_m in one tran 
//==============
// OUT: ADDR
//==============
//assign spt_cmd_offset = {spt_cmd_addr[7:6],1'b0};
//assign first_addr_offset = spt_cmd_offset;
//assign non_first_addr_offset[2:0] = (spt_cmd_offset[2:1] + tran_count) << 1; //spyglass disable SelfDeterminedExpr-ML
//assign out_addr_offset = (tran_count==0) ? first_addr_offset : non_first_addr_offset;
//assign out_addr = {spt_cmd_addr[63:8],out_addr_offset,{5{1'b0}}};  //stepheng.
assign spt_cmd_offset = spt_cmd_addr[4:3];
assign first_addr_offset = spt_cmd_offset;
assign non_first_addr_offset[1:0] = spt_cmd_offset[1:0] + tran_count; //spyglass disable SelfDeterminedExpr-ML

assign out_addr_offset = (tran_count==0) ? first_addr_offset : non_first_addr_offset;
assign out_addr = spt_cmd_addr; // {spt_cmd_addr[31:5],out_addr_offset,{3{1'b0}}};  //stepheng.

//Unpack cmd/data
//==============
//====OUTPUT====
//==============
assign cvt_cmd_accept = spt2cvt_cmd_valid & spt2cvt_cmd_ready;
// Ready
assign cvt_cmd_rdy = spt2cvt_cmd_ready;
assign cvt_dat_rdy = spt2cvt_dat_ready;

// CMD/DATA
assign cvt_cmd_addr          = out_addr;
assign cvt_cmd_size          = out_size;
assign cvt_cmd_axid          = spt_cmd_axid;
assign cvt_cmd_inc           = 1'b0; // change it as in cvt, we will never see a inceased pkt
assign cvt_cmd_swizzle       = spt_cmd_swizzle;
assign cvt_cmd_odd           = spt_cmd_odd;
assign cvt_cmd_ftran         = out_ftran;
assign cvt_cmd_ltran         = out_ltran;

assign cvt_cmd_require_ack   = spt_cmd_require_ack & spt_cmd_ltran;

assign spt2cvt_cmd_valid = spt_cmd_vld;

assign      spt2cvt_cmd_pd[3:0] =    cvt_cmd_axid[3:0];
assign      spt2cvt_cmd_pd[4] =      cvt_cmd_require_ack ;
assign      spt2cvt_cmd_pd[36:5] =   cvt_cmd_addr[31:0];
assign      spt2cvt_cmd_pd[39:37] =  cvt_cmd_size[2:0];
assign      spt2cvt_cmd_pd[40] =     cvt_cmd_swizzle ;
assign      spt2cvt_cmd_pd[41] =     cvt_cmd_odd ;
assign      spt2cvt_cmd_pd[42] =     cvt_cmd_inc ;
assign      spt2cvt_cmd_pd[43] =     cvt_cmd_ltran ;
assign      spt2cvt_cmd_pd[44] =     cvt_cmd_ftran ;

// TO CVT : data
assign cvt_dat_data = spt_dat_data;

assign spt2cvt_dat_valid = spt_dat_vld;

assign      spt2cvt_dat_pd[MEM_BW-1:0] =    cvt_dat_data[MEM_BW-1:0];

endmodule // NV_NVDLA_MCIF_WRITE_IG_spt


`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dfifo_wr_count
    , dfifo_wr_pvld
    , dfifo_wr_pd
    , dfifo_rd_prdy
    , dfifo_rd_pvld
    , dfifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output [2:0] dfifo_wr_count;
input         dfifo_wr_pvld;
input  [64:0] dfifo_wr_pd;
input         dfifo_rd_prdy;
output        dfifo_rd_pvld;
output [64:0] dfifo_rd_pd;
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
assign       wr_reserving = dfifo_wr_pvld;


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] dfifo_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? dfifo_wr_count : (dfifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (dfifo_wr_count + 1'd1) : dfifo_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_wr_count <=  3'd0;
    end else begin
	if ( wr_reserving ^ wr_popping ) begin
	    dfifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dfifo_wr_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dfifo_wr_pvld

//
// RAM
//

reg  [2:0] dfifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_wr_adr <=  3'd0;
    end else begin
        if ( wr_pushing ) begin
	    dfifo_wr_adr <=  (dfifo_wr_adr == 3'd4) ? 3'd0 : (dfifo_wr_adr + 1'd1);
        end
    end
end
// spyglass enable_block W484


reg [2:0] dfifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing;   // note: write occurs next cycle
wire [64:0] dfifo_rd_pd;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo_flopram_rwsa_5x65 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dfifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( dfifo_wr_adr )
    , .ra        ( dfifo_rd_adr )
    , .dout        ( dfifo_rd_pd )
    );

wire   rd_popping;              // read side doing pop this cycle?

wire [2:0] rd_adr_next_popping = (dfifo_rd_adr == 3'd4) ? 3'd0 : (dfifo_rd_adr + 1'd1); // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_adr <=  3'd0;
    end else begin
        if ( rd_popping ) begin
	    dfifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            dfifo_rd_adr <=  {3{`x_or_0}};
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

reg        dfifo_rd_pvld; 		// data out of fifo is valid

reg        dfifo_rd_pvld_int;			// internal copy of dfifo_rd_pvld
assign     rd_popping = dfifo_rd_pvld_int && dfifo_rd_prdy;

reg  [2:0] dfifo_rd_count;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_next_rd_popping = rd_pushing ? dfifo_rd_count : 
                                                                (dfifo_rd_count - 1'd1);
wire [2:0] rd_count_next_no_rd_popping =  rd_pushing ? (dfifo_rd_count + 1'd1) : 
                                                                    dfifo_rd_count;
// spyglass enable_block W164a W484
wire [2:0] rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
wire rd_count_next_rd_popping_not_0 = rd_count_next_rd_popping != 0;
wire rd_count_next_no_rd_popping_not_0 = rd_count_next_no_rd_popping != 0;
wire rd_count_next_not_0 = rd_popping ? rd_count_next_rd_popping_not_0 :
                                              rd_count_next_no_rd_popping_not_0;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_count <=  3'd0;
        dfifo_rd_pvld <=  1'b0;
        dfifo_rd_pvld_int <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dfifo_rd_count <=  rd_count_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dfifo_rd_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    dfifo_rd_pvld   <=   (rd_count_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dfifo_rd_pvld   <=  `x_or_0;
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    dfifo_rd_pvld_int <=   (rd_count_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dfifo_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on

    end
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || dfifo_wr_pvld) || (rd_pushing || rd_popping || (dfifo_rd_pvld && dfifo_rd_prdy)) || (wr_pushing))
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
    , .max      ( 32'd5 )
    , .curr	( {29'd0, dfifo_wr_count} )
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


nv_assert_fifo #(0, 5, 0, 0, "FIFOGEN_ASSERTION Fifo overflow or underflow") 
    fifogen_rd_fifo_check ( .clk    ( nvdla_core_clk ), 
                            .reset_ ( ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled === 1'bx ? 1'b0 : ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ) ), 
                            .push   ( rd_pushing ), 
                            .pop    ( rd_popping )
                          );

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
//   set_boundary_optimization find(design, "NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo_flopram_rwsa_5x65 (
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
input  [64:0] di;
input  we;
input  [2:0] wa;
input  [2:0] ra;
output [64:0] dout;

`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
`endif 
`ifndef FPGA 
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif 


`ifdef EMU


// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [2:0] Wa0_vmw;
reg we0_vmw;
reg [64:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo_flopram_rwsa_5x65 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout )
   );

`else

reg [64:0] ram_ff0;
reg [64:0] ram_ff1;
reg [64:0] ram_ff2;
reg [64:0] ram_ff3;
reg [64:0] ram_ff4;

always @( posedge clk ) begin
    if ( we && wa == 3'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 3'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 3'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 3'd3 ) begin
	ram_ff3 <=  di;
    end
    if ( we && wa == 3'd4 ) begin
	ram_ff4 <=  di;
    end
end

reg [64:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = ram_ff4;
    //VCS coverage off
    default:    dout = {65{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo_flopram_rwsa_5x65

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo_flopram_rwsa_5x65 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [2:0] Wa0;
input            we0;
input  [64:0] Di0;
input  [2:0] Ra0;
output [64:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 65'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [64:0] mem[4:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [64:0] Q0 = mem[0];
wire [64:0] Q1 = mem[1];
wire [64:0] Q2 = mem[2];
wire [64:0] Q3 = mem[3];
wire [64:0] Q4 = mem[4];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo_flopram_rwsa_5x65] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo_flopram_rwsa_5x65] }
endmodule // vmw_NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo_flopram_rwsa_5x65

//vmw: Memory vmw_NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo_flopram_rwsa_5x65
//vmw: Address-size 3
//vmw: Data-size 65
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[64:0] data0[64:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[64:0] data1[64:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_MCIF_WRITE_IG_SPT_dfifo_flopram_rwsa_5x65
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

