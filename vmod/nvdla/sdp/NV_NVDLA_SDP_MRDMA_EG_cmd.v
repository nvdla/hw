// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_MRDMA_EG_cmd.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_MRDMA_EG_cmd (
   nvdla_core_clk        //|< i
  ,nvdla_core_rstn       //|< i
  ,pwrbus_ram_pd         //|< i
  ,eg_done               //|< i
  ,cq2eg_pd              //|< i
  ,cq2eg_pvld            //|< i
  ,cq2eg_prdy            //|> o
  ,cmd2dat_dma_pd        //|> o
  ,cmd2dat_dma_pvld      //|> o
  ,cmd2dat_dma_prdy      //|< i
  ,cmd2dat_spt_pd        //|> o
  ,cmd2dat_spt_pvld      //|> o
  ,cmd2dat_spt_prdy      //|< i
  ,reg2dp_height         //|< i
  ,reg2dp_width          //|< i
  ,reg2dp_in_precision   //|< i
  ,reg2dp_proc_precision //|< i
  );

//
// NV_NVDLA_SDP_MRDMA_EG_cmd_ports.v
//
input  nvdla_core_clk;   
input  nvdla_core_rstn; 
input [31:0]  pwrbus_ram_pd;
input         eg_done;
input         cq2eg_pvld;  
output        cq2eg_prdy;  
input  [13:0] cq2eg_pd;
output        cmd2dat_spt_pvld;  
input         cmd2dat_spt_prdy;  
output [12:0] cmd2dat_spt_pd;
output        cmd2dat_dma_pvld;  
input         cmd2dat_dma_prdy;  
output [14:0] cmd2dat_dma_pd;
input [12:0]  reg2dp_height;
input  [1:0]  reg2dp_in_precision;
input  [1:0]  reg2dp_proc_precision;
input [12:0]  reg2dp_width;

wire         cfg_di_int16;
wire         cfg_do_int8;
wire         cfg_do_16;
wire         cfg_do_fp16;
wire         cfg_do_int16;
wire         cfg_mode_1x1_pack;
reg          cmd_vld;
wire         cmd_rdy;
reg          cmd_cube_end;
reg   [13:0] cmd_dma_size;
reg   [12:0] cmd_spt_size;
wire         dma_cube_end;
wire  [14:0] dma_fifo_pd;
wire         dma_fifo_prdy;
wire         dma_fifo_pvld;
wire  [13:0] dma_size;
reg   [13:0] ig2eg_dma_size;
wire         cq2eg_accept;
wire         ig2eg_cube_end;
wire  [12:0] ig2eg_size;
wire  [12:0] ig2eg_spt_size;
wire  [12:0] spt_fifo_pd;
wire         spt_fifo_prdy;
wire         spt_fifo_pvld;
wire  [12:0] spt_size;

    
//==============
// CFG
assign cfg_di_int16 = reg2dp_in_precision == 1 ;
assign cfg_do_int8  = reg2dp_proc_precision == 0 ;
assign cfg_do_int16 = reg2dp_proc_precision == 1 ;
assign cfg_do_fp16  = reg2dp_proc_precision == 2 ;
assign cfg_do_16    = cfg_do_int16 | cfg_do_fp16;
assign cfg_mode_1x1_pack = (reg2dp_width==0) & (reg2dp_height==0);
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
wire   cfg_mode_16to8 = cfg_di_int16 & cfg_do_int8;
#endif

assign   ig2eg_size[12:0] = cq2eg_pd[12:0];
assign   ig2eg_cube_end   = cq2eg_pd[13];

assign cq2eg_prdy = !cmd_vld || cmd_rdy;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_vld <= 1'b0;
  end else begin
  if ((cq2eg_prdy) == 1'b1) begin
    cmd_vld <= cq2eg_pvld;
  //end else if ((cq2eg_prdy) == 1'b0) begin
  //end else begin
  //  cmd_vld <= 1'bx;  
  end
  end
end

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq2eg_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign cq2eg_accept = cq2eg_pvld & cq2eg_prdy;

//dma_size is in unit of atomic_m * 1B
assign ig2eg_spt_size[12:0] = ig2eg_size;  //ig2eg_size[12:1];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_spt_size <= {13{1'b0}};
  end else begin
  if ((cq2eg_accept) == 1'b1) begin
    cmd_spt_size <= ig2eg_spt_size;
  //end else if ((cq2eg_accept) == 1'b0) begin
  //end else begin
  //  cmd_spt_size <= 13'bx;  
  end
  end
end


`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq2eg_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//dma_size is in unit of 16B
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
always @(
  cfg_do_16
  or ig2eg_size
  or cfg_mode_1x1_pack
  or cfg_mode_16to8
  ) begin
    if (cfg_do_16) begin
        ig2eg_dma_size = {1'b0,ig2eg_size};
    end else begin
        if (cfg_mode_1x1_pack) begin
            if (cfg_mode_16to8) 
                ig2eg_dma_size = {1'b0,ig2eg_size};
            else
                ig2eg_dma_size = {ig2eg_size,1'b1};
        end else begin
            ig2eg_dma_size = {ig2eg_size,1'b1};
        end
    end
end
#else 
always @( ig2eg_size ) begin
 ig2eg_dma_size = {1'b0,ig2eg_size};    //fixme
end
#endif 


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_dma_size <= {14{1'b0}};
  end else begin
  if ((cq2eg_accept) == 1'b1) begin
    cmd_dma_size <= ig2eg_dma_size;
  //end else if ((cq2eg_accept) == 1'b0) begin
  //end else begin
  //  cmd_dma_size <= 14'bx;  
  end
  end
end

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq2eg_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_cube_end <= 1'b0;
  end else begin
  if ((cq2eg_accept) == 1'b1) begin
    cmd_cube_end <= ig2eg_cube_end;
  //end else if ((cq2eg_accept) == 1'b0) begin
  //end else begin
  //  cmd_cube_end <= 1'bx;  
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cq2eg_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
          
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
reg     is_primary;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_primary <= 1'b0;
  end else begin
    if (eg_done) begin
            is_primary <= 0;
    end else begin
        if (cfg_mode_16to8 & cq2eg_accept) begin
            is_primary <= ~is_primary;
        end
    end
  end
end

wire spt_primary = is_primary || (!cfg_mode_16to8);

wire dma_req_en = cfg_mode_1x1_pack || (!is_primary) || (!cfg_mode_16to8);
#else 
wire dma_req_en = 1'b1; 
#endif

assign spt_size = cmd_spt_size;
assign dma_size = cmd_dma_size;
assign dma_cube_end = cmd_cube_end;


//==============
// OUTPUT PACK and PIPE: To EG_DAT
//==============
assign       spt_fifo_pd[12:0] = spt_size[12:0];
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
assign       spt_fifo_pd[12]   = spt_primary ;
#endif

assign       dma_fifo_pd[13:0] = dma_size[13:0];
assign       dma_fifo_pd[14]   = dma_cube_end ;

assign spt_fifo_pvld = cmd_vld & dma_fifo_prdy;
assign dma_fifo_pvld = cmd_vld & dma_req_en & spt_fifo_prdy;
assign cmd_rdy = spt_fifo_prdy & dma_fifo_prdy;

NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo u_sfifo (
   .nvdla_core_clk   (nvdla_core_clk)       
  ,.nvdla_core_rstn  (nvdla_core_rstn)      
  ,.spt_fifo_prdy    (spt_fifo_prdy)        
  ,.spt_fifo_pvld    (spt_fifo_pvld)        
  ,.spt_fifo_pd      (spt_fifo_pd[12:0])    
  ,.cmd2dat_spt_prdy (cmd2dat_spt_prdy)     
  ,.cmd2dat_spt_pvld (cmd2dat_spt_pvld)     
  ,.cmd2dat_spt_pd   (cmd2dat_spt_pd[12:0]) 
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])  
  );

//fixme
NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo u_dfifo (
   .nvdla_core_clk   (nvdla_core_clk)       
  ,.nvdla_core_rstn  (nvdla_core_rstn)      
  ,.dma_fifo_prdy    (dma_fifo_prdy)        
  ,.dma_fifo_pvld    (dma_fifo_pvld)        
  ,.dma_fifo_pd      (dma_fifo_pd[14:0])    
  ,.cmd2dat_dma_prdy (cmd2dat_dma_prdy)     
  ,.cmd2dat_dma_pvld (cmd2dat_dma_pvld)     
  ,.cmd2dat_dma_pd   (cmd2dat_dma_pd[14:0]) 
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])  
  );



endmodule // NV_NVDLA_SDP_MRDMA_EG_cmd



`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , spt_fifo_prdy
    , spt_fifo_pvld
    , spt_fifo_pd
    , cmd2dat_spt_prdy
    , cmd2dat_spt_pvld
    , cmd2dat_spt_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        spt_fifo_prdy;
input         spt_fifo_pvld;
input  [12:0] spt_fifo_pd;
input         cmd2dat_spt_prdy;
output        cmd2dat_spt_pvld;
output [12:0] cmd2dat_spt_pd;
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
reg        spt_fifo_busy_int;		        	// copy for internal use
assign     spt_fifo_prdy = !spt_fifo_busy_int;
assign       wr_reserving = spt_fifo_pvld && !spt_fifo_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] spt_fifo_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? spt_fifo_count : (spt_fifo_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (spt_fifo_count + 1'd1) : spt_fifo_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       spt_fifo_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check spt_fifo_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        spt_fifo_busy_int <=  1'b0;
        spt_fifo_count <=  3'd0;
    end else begin
	spt_fifo_busy_int <=  spt_fifo_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    spt_fifo_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            spt_fifo_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as spt_fifo_pvld

//
// RAM
//

reg  [1:0] spt_fifo_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        spt_fifo_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    spt_fifo_adr <=  spt_fifo_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] cmd2dat_spt_adr;          // read address this cycle
wire ram_we = wr_pushing && (spt_fifo_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [12:0] cmd2dat_spt_pd;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_flopram_rwsa_4x13 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( spt_fifo_pd )
    , .we        ( ram_we )
    , .wa        ( spt_fifo_adr )
    , .ra        ( (spt_fifo_count == 0) ? 3'd4 : {1'b0,cmd2dat_spt_adr} )
    , .dout        ( cmd2dat_spt_pd )
    );


wire [1:0] rd_adr_next_popping = cmd2dat_spt_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd2dat_spt_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    cmd2dat_spt_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            cmd2dat_spt_adr <=  {2{`x_or_0}};
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

wire       cmd2dat_spt_pvld; 		// data out of fifo is valid

assign     rd_popping = cmd2dat_spt_pvld && cmd2dat_spt_prdy;

reg  [2:0] cmd2dat_spt_count;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_next_rd_popping = rd_pushing ? cmd2dat_spt_count : 
                                                                (cmd2dat_spt_count - 1'd1);
wire [2:0] rd_count_next_no_rd_popping =  rd_pushing ? (cmd2dat_spt_count + 1'd1) : 
                                                                    cmd2dat_spt_count;
// spyglass enable_block W164a W484
wire [2:0] rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
assign     cmd2dat_spt_pvld = cmd2dat_spt_count != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd2dat_spt_count <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cmd2dat_spt_count <=  rd_count_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cmd2dat_spt_count <=  {3{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (spt_fifo_pvld && !spt_fifo_busy_int) || (spt_fifo_busy_int != spt_fifo_busy_next)) || (rd_pushing || rd_popping || (cmd2dat_spt_pvld && cmd2dat_spt_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
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
    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, spt_fifo_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_flopram_rwsa_4x13 (
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
input  [12:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [12:0] dout;

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

`ifdef EMU


wire [12:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [12:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_flopram_rwsa_4x13 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [12:0] ram_ff0;
reg [12:0] ram_ff1;
reg [12:0] ram_ff2;
reg [12:0] ram_ff3;

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

reg [12:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {13{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_flopram_rwsa_4x13

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_flopram_rwsa_4x13 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [12:0] Di0;
input  [1:0] Ra0;
output [12:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 13'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [12:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [12:0] Q0 = mem[0];
wire [12:0] Q1 = mem[1];
wire [12:0] Q2 = mem[2];
wire [12:0] Q3 = mem[3];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_flopram_rwsa_4x13] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_flopram_rwsa_4x13] }
endmodule // vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_flopram_rwsa_4x13

//vmw: Memory vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_flopram_rwsa_4x13
//vmw: Address-size 2
//vmw: Data-size 13
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[12:0] data0[12:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[12:0] data1[12:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_sfifo_flopram_rwsa_4x13
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU



`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dma_fifo_prdy
    , dma_fifo_pvld
    , dma_fifo_pd
    , cmd2dat_dma_prdy
    , cmd2dat_dma_pvld
    , cmd2dat_dma_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dma_fifo_prdy;
input         dma_fifo_pvld;
input  [14:0] dma_fifo_pd;
input         cmd2dat_dma_prdy;
output        cmd2dat_dma_pvld;
output [14:0] cmd2dat_dma_pd;
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
reg        dma_fifo_busy_int;		        	// copy for internal use
assign     dma_fifo_prdy = !dma_fifo_busy_int;
assign       wr_reserving = dma_fifo_pvld && !dma_fifo_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] dma_fifo_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? dma_fifo_count : (dma_fifo_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (dma_fifo_count + 1'd1) : dma_fifo_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       dma_fifo_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check dma_fifo_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dma_fifo_busy_int <=  1'b0;
        dma_fifo_count <=  3'd0;
    end else begin
	dma_fifo_busy_int <=  dma_fifo_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dma_fifo_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dma_fifo_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dma_fifo_pvld

//
// RAM
//

reg  [1:0] dma_fifo_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dma_fifo_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    dma_fifo_adr <=  dma_fifo_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] cmd2dat_dma_adr;          // read address this cycle
wire ram_we = wr_pushing && (dma_fifo_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [14:0] cmd2dat_dma_pd;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_flopram_rwsa_4x15 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dma_fifo_pd )
    , .we        ( ram_we )
    , .wa        ( dma_fifo_adr )
    , .ra        ( (dma_fifo_count == 0) ? 3'd4 : {1'b0,cmd2dat_dma_adr} )
    , .dout        ( cmd2dat_dma_pd )
    );


wire [1:0] rd_adr_next_popping = cmd2dat_dma_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd2dat_dma_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    cmd2dat_dma_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            cmd2dat_dma_adr <=  {2{`x_or_0}};
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

wire       cmd2dat_dma_pvld; 		// data out of fifo is valid

assign     rd_popping = cmd2dat_dma_pvld && cmd2dat_dma_prdy;

reg  [2:0] cmd2dat_dma_count;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_next_rd_popping = rd_pushing ? cmd2dat_dma_count : 
                                                                (cmd2dat_dma_count - 1'd1);
wire [2:0] rd_count_next_no_rd_popping =  rd_pushing ? (cmd2dat_dma_count + 1'd1) : 
                                                                    cmd2dat_dma_count;
// spyglass enable_block W164a W484
wire [2:0] rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
assign     cmd2dat_dma_pvld = cmd2dat_dma_count != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd2dat_dma_count <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cmd2dat_dma_count <=  rd_count_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cmd2dat_dma_count <=  {3{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dma_fifo_pvld && !dma_fifo_busy_int) || (dma_fifo_busy_int != dma_fifo_busy_next)) || (rd_pushing || rd_popping || (cmd2dat_dma_pvld && cmd2dat_dma_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
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
    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, dma_fifo_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_flopram_rwsa_4x15 (
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
input  [14:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [14:0] dout;

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

`ifdef EMU


wire [14:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [14:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_flopram_rwsa_4x15 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [14:0] ram_ff0;
reg [14:0] ram_ff1;
reg [14:0] ram_ff2;
reg [14:0] ram_ff3;

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

reg [14:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {15{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_flopram_rwsa_4x15

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_flopram_rwsa_4x15 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [14:0] Di0;
input  [1:0] Ra0;
output [14:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 15'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [14:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [14:0] Q0 = mem[0];
wire [14:0] Q1 = mem[1];
wire [14:0] Q2 = mem[2];
wire [14:0] Q3 = mem[3];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_flopram_rwsa_4x15] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_flopram_rwsa_4x15] }
endmodule // vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_flopram_rwsa_4x15

//vmw: Memory vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_flopram_rwsa_4x15
//vmw: Address-size 2
//vmw: Data-size 15
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[14:0] data0[14:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[14:0] data1[14:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_MRDMA_EG_CMD_dfifo_flopram_rwsa_4x15
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

