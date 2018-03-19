// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_WRITE_IG_bpt_s.v

#include "NV_NVDLA_MCIF_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_WRITE_IG_bpt_s (
   nvdla_core_clk    //|< i
  ,nvdla_core_rstn   //|< i
  ,dma2bpt_req_valid //|< i
  ,dma2bpt_req_ready //|> o
  ,dma2bpt_req_pd    //|< i
  ,bpt2arb_cmd_valid //|> o
  ,bpt2arb_cmd_ready //|< i
  ,bpt2arb_cmd_pd    //|> o
  ,bpt2arb_dat_valid //|> o
  ,bpt2arb_dat_ready //|< i
  ,bpt2arb_dat_pd    //|> o
  ,pwrbus_ram_pd     //|< i
  ,axid              //|< i
  );
//////////////////////////////////////////////////////////////
//
// NV_NVDLA_MCIF_WRITE_IG_bpt_ports.v
//
input  nvdla_core_clk;  
input  nvdla_core_rstn;

input          dma2bpt_req_valid; 
output         dma2bpt_req_ready;
input  [MEM_WR_PD_BW-1:0] dma2bpt_req_pd; 

output        bpt2arb_cmd_valid; 
input         bpt2arb_cmd_ready;
//output [76:0] bpt2arb_cmd_pd;
output [44:0] bpt2arb_cmd_pd;

output         bpt2arb_dat_valid; 
input          bpt2arb_dat_ready;
output [MEMRSP_PD_BW-1:0] bpt2arb_dat_pd;

input [31:0] pwrbus_ram_pd;

input [3:0] axid;
//////////////////////////////////////////////////////////////
reg    [1:0] beat_count;
reg          cmd_en;
reg          dat_en;
reg          in_dat1_dis;
reg   [12:0] in_dat_cnt;
reg   [31:0] out_addr;
wire    [1:0] out_size;
reg   [13:0] req_count;
reg   [13:0] req_num;
wire         bpt2arb_cmd_accept;
wire         bpt2arb_dat_accept;
wire [MEM_BW-1:0] dfifo0_rd_pd;
wire         dfifo0_rd_prdy;
wire         dfifo0_rd_pvld;
wire         dfifo_wr_rdy;
wire         dfifo_wr_vld;
wire   [1:0] end_offset;
wire   [1:0] ftran_size;
wire  [31:0] in_cmd_addr;
wire         in_cmd_rdy;
wire         in_cmd_require_ack;
wire  [12:0] in_cmd_size;
wire  [46:0] in_cmd_vld_pd;
wire         in_dat_first;
wire         in_dat_last;
wire  [45:0] ipipe_cmd_pd;
wire         ipipe_cmd_rdy;
wire         ipipe_cmd_vld;
wire         ipipe_rdy;
wire         ipipe_rdy_p;
wire         is_ftran;
wire         is_last_beat;
wire         is_ltran;
wire         is_mtran;
wire         is_single_tran;
wire   [1:0] ltran_size;
wire         mon_end_offset_c;
wire  [12:0] mtran_num;
wire  [31:0] out_cmd_addr;
wire   [3:0] out_cmd_axid;
wire         out_cmd_ftran;
wire         out_cmd_inc;
wire         out_cmd_ltran;
wire         out_cmd_odd;
wire         out_cmd_require_ack;
wire   [2:0] out_cmd_size;
wire         out_cmd_swizzle;
wire         out_cmd_vld;
wire [MEM_BW-1:0] out_dat_data;
//wire [MEMRSP_PD_BW-1-MEM_BW] out_dat_mask;
wire         out_dat_vld;
wire   [1:0] size_offset;
wire   [1:0] stt_offset;
///////////////////////////////////////////////////////////

//: my $k = MEM_WR_PD_BW;
//: &eperl::pipe(" -wid $k -os -do ipipe_pd_p -vo ipipe_vld_p -ri ipipe_rdy_p -di dma2bpt_req_pd -vi dma2bpt_req_valid -ro dma2bpt_req_ready ");
//: &eperl::pipe(" -wid $k -is -do ipipe_pd -vo ipipe_vld -ri ipipe_rdy -di ipipe_pd_p -vi ipipe_vld_p -ro ipipe_rdy_p_f ");
assign ipipe_rdy_p = ipipe_rdy_p_f;
///////////////////////
assign ipipe_rdy = (ipipe_cmd_vld & ipipe_cmd_rdy) || (dfifo_wr_vld & dfifo_wr_rdy); 

assign ipipe_cmd_vld = ipipe_vld && (~ipipe_pd[MEM_WR_PD_BW-1]);
assign dfifo_wr_vld  = ipipe_vld && (ipipe_pd[MEM_WR_PD_BW-1] );
//==================
assign      ipipe_cmd_pd[MEM_WR_CMD_BW-1:0] = ipipe_pd[MEM_WR_CMD_BW-1:0] ;
//: my $k = MEM_WR_CMD_BW;
//: &eperl::pipe(" -wid $k -do in_cmd_pd -vo in_cmd_vld -ri in_cmd_rdy -di ipipe_cmd_pd -vi ipipe_cmd_vld -ro ipipe_cmd_rdy_f ");
assign ipipe_cmd_rdy = ipipe_cmd_rdy_f;
assign in_cmd_rdy = is_ltran & is_last_beat & bpt2arb_dat_accept;

assign in_cmd_vld_pd = {MEM_WR_CMD_BW{in_cmd_vld}} & in_cmd_pd;

assign in_cmd_addr[31:0] =    in_cmd_vld_pd[31:0];
assign in_cmd_size[12:0] =    in_cmd_vld_pd[44:32];
assign in_cmd_require_ack  =  in_cmd_vld_pd[45];
//==================

NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo u_dfifo0 (
   .nvdla_core_clk    (nvdla_core_clk)      
  ,.nvdla_core_rstn   (nvdla_core_rstn)     
  ,.dfifo_wr_prdy     (dfifo_wr_rdy)        
  ,.dfifo_wr_idle     (              )      
  ,.dfifo_wr_pvld     (dfifo_wr_vld)        
  ,.dfifo_wr_pd       (ipipe_pd[MEM_BW-1:0])
  ,.dfifo_rd_prdy     (dfifo0_rd_prdy)      
  ,.dfifo_rd_pvld     (dfifo0_rd_pvld)      
  ,.dfifo_rd_pd       (dfifo0_rd_pd) 
  ,.pwrbus_ram_pd     (pwrbus_ram_pd[31:0]) 
  );
//==================
// in_cmd analysis to determine how to pop data from dFIFO
assign stt_offset[1:0] = in_cmd_addr[4:3];
assign size_offset[1:0] = in_cmd_size[1:0];
assign {mon_end_offset_c, end_offset[1:0]} = stt_offset + size_offset;
//==================
// dFIFO popping in AXI format
//==================
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    in_dat_cnt <= {13{1'b0}};
  end else if (bpt2arb_dat_accept) begin
        if (in_dat_last) begin
            in_dat_cnt <= 0;
        end else begin
            in_dat_cnt <= in_dat_cnt + 1;
        end
  end
end
assign in_dat_last = (in_dat_cnt==in_cmd_size[12:0]);
assign in_dat_first = (in_dat_cnt==0);
//==================
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_en <= 1'b1;
    dat_en <= 1'b0;
  end else begin
    if (bpt2arb_cmd_accept) begin
        cmd_en <= 1'b0;
        dat_en <= 1'b1;
    end else if (bpt2arb_dat_accept & is_last_beat) begin
        cmd_en <= 1'b1;
        dat_en <= 1'b0;
    end
  end
end

// vld & data & mask
assign dfifo0_rd_prdy = dat_en & bpt2arb_dat_ready;
// DATA FIFO read side: valid
assign out_dat_vld = dat_en & dfifo0_rd_pvld;
assign out_dat_data = dfifo0_rd_pd[MEM_BW-1:0];
//assign out_data_mask = dfifo0_rd_pd[MEMRSP_PD_BW-1:MEM_BW];

// calculate how many trans to be split
assign is_single_tran = (stt_offset + in_cmd_size) < 4;
assign ftran_size[1:0] = is_single_tran ? size_offset : 2'd3-stt_offset;
assign ltran_size[1:0] = is_single_tran ? size_offset : end_offset;
assign mtran_num = in_cmd_size - ftran_size - ltran_size - 1;
//================
// Beat Count: to count data per split req
//================
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_count <= {2{1'b0}};
  end else begin
    if (bpt2arb_dat_accept) begin
        if (is_last_beat) begin
            beat_count <= 0; 
        end else begin
            beat_count <= beat_count + 1;
        end
    end
  end
end
assign is_last_beat = (beat_count==out_size);
// in AXI format
//================
// bsp out: size: this is in unit of 64B, including masked 32B data
//================
/*always @(*) begin
    out_size = {2{`tick_x_or_0}};
    if (is_ftran) begin
        out_size = ftran_size;
    end else if (is_mtran) begin
        out_size = 2'd3;
    end else if (is_ltran) begin
        out_size = ltran_size;
    end
end
*/
assign out_size = 2'd0;
//================
// bpt2arb: addr
//================
always @(posedge nvdla_core_clk) begin
    if (bpt2arb_cmd_accept) begin
        //if (is_ftran) begin
        //    out_addr <= in_cmd_addr + ((ftran_size+1)<<3);
        //end else begin
        //    out_addr <= out_addr + 32;
        //end
        if (is_ftran) begin
            out_addr <= in_cmd_addr + 8;
        end else begin
            out_addr <= out_addr + 8;
        end
    end
end
//================
// tran count
//================
always @(*) begin
    //if (is_single_tran) begin
    //    req_num = 1;
    //end else if (mtran_num==0) begin
    //    req_num = 2;
    //end else begin
    //    req_num = 2 + mtran_num[12:2];
    //end
        req_num = in_cmd_size + 1;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_count <= {14{1'b0}};
  end else if (bpt2arb_dat_accept & is_last_beat) begin
        if (is_ltran) begin
            req_count <= 0;
        end else begin
            req_count <= req_count + 1;
        end
  end
end
assign is_ftran = (req_count==0);
//assign is_mtran = (req_count>0 && req_count<req_num-1);
assign is_ltran = (req_count==req_num-1);

// CMD PATH
assign out_cmd_vld  = cmd_en & in_cmd_vld;
assign out_cmd_addr = (is_ftran) ? in_cmd_addr : out_addr;
assign out_cmd_size = out_size;
assign out_cmd_inc  = 1'b0;//
assign out_cmd_swizzle = 1'b0;//is_swizzle;
assign out_cmd_odd   = 1'b0;//in_size_is_odd;
assign out_cmd_ftran = is_ftran;
assign out_cmd_ltran = is_ltran;
assign out_cmd_axid = axid;
assign out_cmd_require_ack = in_cmd_require_ack & is_ltran;
assign bpt2arb_cmd_valid = out_cmd_vld;

assign      bpt2arb_cmd_pd[3:0] =    out_cmd_axid[3:0];
assign      bpt2arb_cmd_pd[4] =    out_cmd_require_ack ;
assign      bpt2arb_cmd_pd[36:5] =    out_cmd_addr[31:0];
assign      bpt2arb_cmd_pd[39:37] =    out_cmd_size[2:0];
assign      bpt2arb_cmd_pd[40] =    out_cmd_swizzle ;
assign      bpt2arb_cmd_pd[41] =    out_cmd_odd ;
assign      bpt2arb_cmd_pd[42] =    out_cmd_inc ;
assign      bpt2arb_cmd_pd[43] =    out_cmd_ltran ;
assign      bpt2arb_cmd_pd[44] =    out_cmd_ftran ;

assign bpt2arb_cmd_accept = bpt2arb_cmd_valid & bpt2arb_cmd_ready;
// DATA PATH
assign bpt2arb_dat_valid = out_dat_vld;

assign      bpt2arb_dat_pd[MEM_BW-1:0] =    out_dat_data[MEM_BW-1:0];
//assign      bpt2arb_dat_pd[MEMRSP_PD_BW-1:MEM_BW] = out_dat_mask;
assign bpt2arb_dat_accept = bpt2arb_dat_valid & bpt2arb_dat_ready;

endmodule // NV_NVDLA_MCIF_WRITE_IG_bpt

`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dfifo_wr_prdy
    , dfifo_wr_idle
    , dfifo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , dfifo_wr_pause
`endif
    , dfifo_wr_pd
    , dfifo_rd_prdy
    , dfifo_rd_pvld
    , dfifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dfifo_wr_prdy;
output        dfifo_wr_idle;
input         dfifo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         dfifo_wr_pause;
`endif
input  [63:0] dfifo_wr_pd;
input         dfifo_rd_prdy;
output        dfifo_rd_pvld;
output [63:0] dfifo_rd_pd;
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
reg wr_pause_rand_in;
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        dfifo_wr_pvld_in;                                // registered dfifo_wr_pvld
reg        wr_busy_in;                              // inputs being held this cycle?
assign     dfifo_wr_prdy = !wr_busy_in;
wire       dfifo_wr_busy_next;                           // fwd: fifo busy next?

// factor for better timing with distant dfifo_wr_pvld signal
wire       wr_busy_in_next_wr_req_eq_1 = dfifo_wr_busy_next;
wire       wr_busy_in_next_wr_req_eq_0 = (dfifo_wr_pvld_in && dfifo_wr_busy_next) && !wr_reserving;
`ifdef FV_RAND_WR_PAUSE
wire       wr_busy_in_next = (dfifo_wr_pvld? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                             || dfifo_wr_pause ;
`else
wire       wr_busy_in_next = (dfifo_wr_pvld? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                              
                            // synopsys translate_off
                            `ifndef SYNTH_LEVEL1_COMPILE
                            `ifndef SYNTHESIS
                            || wr_pause_rand
                            `endif
                            `endif
                            // synopsys translate_on
                             ;
`endif
wire       wr_busy_in_int;
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_wr_pvld_in <=  1'b0;
        wr_busy_in <=  1'b0;
    end else begin
        wr_busy_in <=  wr_busy_in_next;
        if ( !wr_busy_in_int ) begin
            dfifo_wr_pvld_in  <=  dfifo_wr_pvld && !wr_busy_in;
        end
        //synopsys translate_off
            else if ( wr_busy_in_int ) begin
        end else begin
            dfifo_wr_pvld_in  <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

reg        dfifo_wr_busy_int;		        	// copy for internal use
assign       wr_reserving = dfifo_wr_pvld_in && !dfifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg        dfifo_wr_count;			// write-side count

wire       wr_count_next_wr_popping = wr_reserving ? dfifo_wr_count : (dfifo_wr_count - 1'd1); // spyglass disable W164a W484
wire       wr_count_next_no_wr_popping = wr_reserving ? (dfifo_wr_count + 1'd1) : dfifo_wr_count; // spyglass disable W164a W484
wire       wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_1 = ( wr_count_next_no_wr_popping == 1'd1 );
wire wr_count_next_is_1 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_1;
wire       wr_limit_muxed;  // muxed with simulation/emulation overrides
wire       wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
assign     dfifo_wr_busy_next = wr_count_next_is_1 || // busy next cycle?
                          (wr_limit_reg != 1'd0 &&      // check dfifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
assign     wr_busy_in_int = dfifo_wr_pvld_in && dfifo_wr_busy_int;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_wr_busy_int <=  1'b0;
        dfifo_wr_count <=  1'd0;
    end else begin
	dfifo_wr_busy_int <=  dfifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dfifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dfifo_wr_count <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dfifo_wr_pvld_in

//
// RAM
//

wire rd_popping;

wire ram_we = wr_pushing && (dfifo_wr_count > 1'd0 || !rd_popping);   // note: write occurs next cycle
wire ram_iwe = !wr_busy_in && dfifo_wr_pvld;  
wire [63:0] dfifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_flopram_rwsa_1x64 ram (
      .clk( nvdla_core_clk )
    , .clk_mgated( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dfifo_wr_pd )
    , .iwe        ( ram_iwe )
    , .we        ( ram_we )
    , .ra        ( (dfifo_wr_count == 0) ? 1'd1 : 1'b0 )
    , .dout        ( dfifo_rd_pd_p )
    );


//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

reg        dfifo_rd_prdy_d;				// dfifo_rd_prdy registered in cleanly

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_prdy_d <=  1'b1;
    end else begin
        dfifo_rd_prdy_d <=  dfifo_rd_prdy;
    end
end

wire       dfifo_rd_prdy_d_o;			// combinatorial rd_busy

reg        dfifo_rd_pvld_int;			// internal copy of dfifo_rd_pvld

assign     dfifo_rd_pvld = dfifo_rd_pvld_int;
wire       dfifo_rd_pvld_p; 		// data out of fifo is valid

reg        dfifo_rd_pvld_int_o;	// internal copy of dfifo_rd_pvld_o
wire       dfifo_rd_pvld_o = dfifo_rd_pvld_int_o;
assign     rd_popping = dfifo_rd_pvld_p && !(dfifo_rd_pvld_int_o && !dfifo_rd_prdy_d_o);

reg        dfifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire       rd_count_p_next_rd_popping = rd_pushing ? dfifo_rd_count_p : 
                                                                (dfifo_rd_count_p - 1'd1);
wire       rd_count_p_next_no_rd_popping =  rd_pushing ? (dfifo_rd_count_p + 1'd1) : 
                                                                    dfifo_rd_count_p;
// spyglass enable_block W164a W484
wire       rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     dfifo_rd_pvld_p = dfifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_count_p <=  1'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dfifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dfifo_rd_count_p <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end


// 
// SKID for -rd_busy_reg
//
reg [63:0]  dfifo_rd_pd_o;         // output data register
wire        rd_req_next_o = (dfifo_rd_pvld_p || (dfifo_rd_pvld_int_o && !dfifo_rd_prdy_d_o)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_pvld_int_o <=  1'b0;
    end else begin
        dfifo_rd_pvld_int_o <=  rd_req_next_o;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (dfifo_rd_pvld_int && rd_req_next_o && rd_popping) ) begin
        dfifo_rd_pd_o <=  dfifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((dfifo_rd_pvld_int && rd_req_next_o && rd_popping)) ) begin
    end else begin
        dfifo_rd_pd_o <=  {64{`x_or_0}};
    end
    //synopsys translate_on

end

//
// FINAL OUTPUT
//
reg [63:0]  dfifo_rd_pd;				// output data register
reg        dfifo_rd_pvld_int_d;			// so we can bubble-collapse dfifo_rd_prdy_d
assign     dfifo_rd_prdy_d_o = !((dfifo_rd_pvld_o && dfifo_rd_pvld_int_d && !dfifo_rd_prdy_d ) );
wire       rd_req_next = (!dfifo_rd_prdy_d_o ? dfifo_rd_pvld_o : dfifo_rd_pvld_p) ;  

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_pvld_int <=  1'b0;
        dfifo_rd_pvld_int_d <=  1'b0;
    end else begin
        if ( !dfifo_rd_pvld_int || dfifo_rd_prdy ) begin
	    dfifo_rd_pvld_int <=  rd_req_next;
        end
        //synopsys translate_off
            else if ( !(!dfifo_rd_pvld_int || dfifo_rd_prdy) ) begin
        end else begin
            dfifo_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on


        dfifo_rd_pvld_int_d <=  dfifo_rd_pvld_int;
    end
end

always @( posedge nvdla_core_clk ) begin
    if ( rd_req_next && (!dfifo_rd_pvld_int || dfifo_rd_prdy ) ) begin
        case (!dfifo_rd_prdy_d_o) 
            1'b0:    dfifo_rd_pd <=  dfifo_rd_pd_p;
            1'b1:    dfifo_rd_pd <=  dfifo_rd_pd_o;
            //VCS coverage off
            default: dfifo_rd_pd <=  {64{`x_or_0}};
            //VCS coverage on
        endcase
    end
    //synopsys translate_off
        else if ( !(rd_req_next && (!dfifo_rd_pvld_int || dfifo_rd_prdy)) ) begin
    end else begin
        dfifo_rd_pd <=  {64{`x_or_0}};
    end
    //synopsys translate_on

end

//
// Read-side Idle Calculation
//
wire   rd_idle = !dfifo_rd_pvld_int_o && !dfifo_rd_pvld_int && !rd_pushing && dfifo_rd_count_p == 0;


//
// Write-Side Idle Calculation
//
wire dfifo_wr_idle_d0 = !dfifo_wr_pvld_in && rd_idle && !wr_pushing && dfifo_wr_count == 0
// synopsys translate_off
 `ifndef SYNTH_LEVEL1_COMPILE
 `ifndef SYNTHESIS
    && !wr_pause_rand_in
  `endif
  `endif
// synopsys translate_on
;
wire dfifo_wr_idle = dfifo_wr_idle_d0;


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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dfifo_wr_pvld_in && !dfifo_wr_busy_int) || (dfifo_wr_busy_int != dfifo_wr_busy_next)) || (rd_pushing || rd_popping || (dfifo_rd_pvld_int && dfifo_rd_prdy_d) || (dfifo_rd_pvld_int_o && dfifo_rd_prdy_d_o)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_wr_limit : 1'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 1'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 1'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 1'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg       wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 1'd0;
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
    if ( $test$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_wr_limit=%d", wr_limit_override_value);
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
    if ( $test$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_max=%d", stall_cycles_max);
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
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( dfifo_wr_pvld && !(!dfifo_wr_prdy)
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
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_in <=  1'b0;
    end else begin
        wr_pause_rand_in <=  wr_pause_rand;
    end
end

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
    , .max      ( {31'd0, (wr_limit_reg == 1'd0) ? 1'd1 : wr_limit_reg} )
    , .curr	( {31'd0, dfifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo") true
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


endmodule // NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo

// 
// Flop-Based RAM (with internal wr_reg)
//
module NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_flopram_rwsa_1x64 (
      clk
    , clk_mgated
    , pwrbus_ram_pd
    , di
    , iwe
    , we
    , ra
    , dout
    );

input  clk;  // write clock
input  clk_mgated;  // write clock mgated
input [31 : 0] pwrbus_ram_pd;
input  [63:0] di;
input  iwe;
input  we;
input  [0:0] ra;
output [63:0] dout;

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

reg [63:0] di_d;  // -wr_reg

always @( posedge clk ) begin
    if ( iwe ) begin
        di_d <=  di; // -wr_reg
    end
end
reg [63:0] ram_ff0;

always @( posedge clk_mgated ) begin
    if ( we ) begin
	ram_ff0 <=  di_d;
    end
end

reg [63:0] dout;

always @(*) begin
    case( ra ) 
    1'd0:       dout = ram_ff0;
    1'd1:       dout = di_d;
    //VCS coverage off
    default:    dout = {64{`x_or_0}};
    //VCS coverage on
    endcase
end

endmodule // NV_NVDLA_MCIF_WRITE_IG_BPT_dfifo_flopram_rwsa_1x64

