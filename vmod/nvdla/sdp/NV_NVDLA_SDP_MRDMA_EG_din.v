// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_MRDMA_EG_din.v

`include "simulate_x_tick.vh"
#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_MRDMA_EG_din (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,pwrbus_ram_pd           //|< i
  ,reg2dp_src_ram_type     //|< i
  ,cmd2dat_spt_prdy        //|> o
  ,cmd2dat_spt_pd          //|< i
  ,cmd2dat_spt_pvld        //|< i
  ,dma_rd_cdt_lat_fifo_pop //|> o
  ,dma_rd_rsp_ram_type     //|> o
  ,dma_rd_rsp_pd           //|< i
  ,dma_rd_rsp_vld          //|< i
  ,dma_rd_rsp_rdy          //|> o
  ,pfifo0_rd_prdy          //|< i
  ,pfifo1_rd_prdy          //|< i
  ,pfifo2_rd_prdy          //|< i
  ,pfifo3_rd_prdy          //|< i
  ,pfifo0_rd_pd            //|> o
  ,pfifo0_rd_pvld          //|> o
  ,pfifo1_rd_pd            //|> o
  ,pfifo1_rd_pvld          //|> o
  ,pfifo2_rd_pd            //|> o
  ,pfifo2_rd_pvld          //|> o
  ,pfifo3_rd_pd            //|> o
  ,pfifo3_rd_pvld          //|> o
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
  ,sfifo0_rd_prdy          //|< i
  ,sfifo1_rd_prdy          //|< i
  ,sfifo0_rd_pd            //|> o
  ,sfifo0_rd_pvld          //|> o
  ,sfifo1_rd_pd            //|> o
  ,sfifo1_rd_pvld          //|> o
#endif
  );

//&Catenate "NV_NVDLA_SDP_MRDMA_EG_din_ports.v";
input          nvdla_core_clk;
input          nvdla_core_rstn;
input   [31:0] pwrbus_ram_pd;
input          reg2dp_src_ram_type;
output         dma_rd_rsp_ram_type;
input  [NVDLA_DMA_RD_RSP-1:0] dma_rd_rsp_pd;
input          dma_rd_rsp_vld;
output         dma_rd_rsp_rdy;
output         dma_rd_cdt_lat_fifo_pop;
input   [12:0] cmd2dat_spt_pd;
input          cmd2dat_spt_pvld;
output         cmd2dat_spt_prdy;
input          pfifo0_rd_prdy;
input          pfifo1_rd_prdy;
input          pfifo2_rd_prdy;
input          pfifo3_rd_prdy;
output [AM_DW-1:0] pfifo0_rd_pd;
output         pfifo0_rd_pvld;
output [AM_DW-1:0] pfifo1_rd_pd;
output         pfifo1_rd_pvld;
output [AM_DW-1:0] pfifo2_rd_pd;
output         pfifo2_rd_pvld;
output [AM_DW-1:0] pfifo3_rd_pd;
output         pfifo3_rd_pvld;

#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
input          sfifo0_rd_prdy;
input          sfifo1_rd_prdy;
output [AM_DW2-1:0] sfifo0_rd_pd;
output         sfifo0_rd_pvld;
output [AM_DW2-1:0] sfifo1_rd_pd;
output         sfifo1_rd_pvld;

wire   [AM_DW2-1:0] sfifo0_wr_pd;
wire           sfifo0_wr_prdy;
wire           sfifo0_wr_pvld;
wire   [AM_DW2-1:0] sfifo1_wr_pd;
wire           sfifo1_wr_prdy;
wire           sfifo1_wr_pvld;
#endif

wire           cmd2dat_spt_primary;
wire    [12:0] cmd2dat_spt_size;
wire    [13:0] cmd_size;
wire           is_last_beat;
reg     [12:0] beat_cnt;
wire    [13:0] beat_cnt_nxt;
reg            mon_beat_cnt;
wire           lat_ecc_rd_accept;
wire   [NVDLA_MEMIF_WIDTH-1:0] lat_ecc_rd_data;
wire   [3:0]   lat_ecc_rd_mask;
wire   [NVDLA_DMA_RD_RSP-1:0] lat_ecc_rd_pd;
wire           lat_ecc_rd_pvld;
wire           lat_ecc_rd_prdy;
wire   [AM_DW-1:0] pfifo0_wr_pd;
wire           pfifo0_wr_prdy;
wire           pfifo0_wr_pvld;
wire   [AM_DW-1:0] pfifo1_wr_pd;
wire           pfifo1_wr_prdy;
wire           pfifo1_wr_pvld;
wire   [AM_DW-1:0] pfifo2_wr_pd;
wire           pfifo2_wr_prdy;
wire           pfifo2_wr_pvld;
wire   [AM_DW-1:0] pfifo3_wr_pd;
wire           pfifo3_wr_prdy;
wire           pfifo3_wr_pvld;
wire    [4*AM_DW+3:0]  unpack_out_pd;
wire           unpack_out_pvld;
wire           unpack_out_prdy;
wire           pfifo_wr_rdy;
wire           pfifo_wr_vld;
wire   [3:0]   pfifo_wr_mask;


//==============
// Latency FIFO to buffer return DATA
//==============
assign dma_rd_rsp_ram_type     = reg2dp_src_ram_type;
assign dma_rd_cdt_lat_fifo_pop = lat_ecc_rd_pvld & lat_ecc_rd_prdy;

NV_NVDLA_SDP_MRDMA_EG_lat_fifo u_lat_fifo (
   .nvdla_core_clk  (nvdla_core_clk)       
  ,.nvdla_core_rstn (nvdla_core_rstn)      
  ,.lat_wr_prdy     (dma_rd_rsp_rdy)       
  ,.lat_wr_pvld     (dma_rd_rsp_vld)       
  ,.lat_wr_pd       (dma_rd_rsp_pd[NVDLA_DMA_RD_RSP-1:0]) 
  ,.lat_rd_prdy     (lat_ecc_rd_prdy)      
  ,.lat_rd_pvld     (lat_ecc_rd_pvld)      
  ,.lat_rd_pd       (lat_ecc_rd_pd[NVDLA_DMA_RD_RSP-1:0]) 
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])  
  );

assign      lat_ecc_rd_accept = lat_ecc_rd_pvld & lat_ecc_rd_prdy;

assign      lat_ecc_rd_data[NVDLA_MEMIF_WIDTH-1:0] = lat_ecc_rd_pd[NVDLA_MEMIF_WIDTH-1:0];

assign      lat_ecc_rd_mask[3:0] = {{(4-NVDLA_DMA_MASK_BIT){1'b0}},lat_ecc_rd_pd[NVDLA_DMA_RD_RSP-1:NVDLA_MEMIF_WIDTH]};
wire [2:0]  lat_ecc_rd_size = lat_ecc_rd_mask[3]+lat_ecc_rd_mask[2]+lat_ecc_rd_mask[1]+lat_ecc_rd_mask[0];


#ifdef NVDLA_SDP_DMAIF_FIX
wire lat_rd_mask0_vld = lat_ecc_rd_pvld & lat_ecc_rd_mask[0];
wire lat_rd_mask1_vld = lat_ecc_rd_pvld & lat_ecc_rd_mask[1];

assign  lat_ecc_rd_prdy = lat_rd_prdy;
always @(
  cmd2dat_spt_pvld
  or cmd2dat_spt_primary
  or lat_rd_mask0_vld
  or pfifo0_wr_prdy
  or pfifo1_wr_prdy
  or lat_rd_mask1_vld
  or pfifo2_wr_prdy
  or pfifo3_wr_prdy
  or sfifo0_wr_prdy
  or sfifo1_wr_prdy
  ) begin
    if (cmd2dat_spt_pvld) begin
        if (cmd2dat_spt_primary) begin
            lat_rd_prdy = (!lat_rd_mask0_vld || (pfifo0_wr_prdy & pfifo1_wr_prdy)) 
                            & (!lat_rd_mask1_vld || (pfifo2_wr_prdy & pfifo3_wr_prdy));
        end else begin
            lat_rd_prdy = (!lat_rd_mask0_vld || (sfifo0_wr_prdy)) 
                            & (!lat_rd_mask1_vld || (sfifo1_wr_prdy));
        end
    end else begin
        lat_rd_prdy = 1'b0;
    end
end
#endif


//========command for pfifo wr ====================
assign  cmd2dat_spt_prdy = lat_ecc_rd_accept & is_last_beat;

assign  cmd2dat_spt_size[12:0] =  cmd2dat_spt_pd[12:0];
//assign  cmd2dat_spt_primary  =    cmd2dat_spt_pd[12];
assign  cmd_size = cmd2dat_spt_pvld ? (cmd2dat_spt_size+1) : 0;


assign  beat_cnt_nxt = beat_cnt + lat_ecc_rd_size;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_beat_cnt,beat_cnt} <= 14'h0;
  end else begin
    if (lat_ecc_rd_accept) begin
        if (is_last_beat) begin
            {mon_beat_cnt,beat_cnt} <= 14'h0;
        end else begin
            {mon_beat_cnt,beat_cnt} <= beat_cnt_nxt;
        end
    end
  end
end
assign is_last_beat = beat_cnt_nxt == cmd_size;


/////////combine lat fifo pd to 4*atomic_m*bpe//////
wire  lat_ecc_rd_beat_end = is_last_beat;

NV_NVDLA_SDP_RDMA_unpack  u_rdma_unpack (
   .nvdla_core_clk        (nvdla_core_clk)
  ,.nvdla_core_rstn       (nvdla_core_rstn)
  ,.inp_data              (lat_ecc_rd_pd[NVDLA_DMA_RD_RSP-1:0])
  ,.inp_pvld              (lat_ecc_rd_pvld)
  ,.inp_prdy              (lat_ecc_rd_prdy)
  ,.inp_end               (lat_ecc_rd_beat_end)
  ,.out_data              (unpack_out_pd[4*AM_DW+3:0])
  ,.out_pvld              (unpack_out_pvld)
  ,.out_prdy              (unpack_out_prdy)
  );

assign  unpack_out_prdy = pfifo_wr_rdy;
assign  pfifo_wr_mask = unpack_out_pd[4*AM_DW+3:4*AM_DW];
assign  pfifo_wr_vld  = unpack_out_pvld;  


//==================================
// FIFO WRITE
assign pfifo0_wr_pd = unpack_out_pd[AM_DW*0+AM_DW-1:AM_DW*0];
assign pfifo1_wr_pd = unpack_out_pd[AM_DW*1+AM_DW-1:AM_DW*1];
assign pfifo2_wr_pd = unpack_out_pd[AM_DW*2+AM_DW-1:AM_DW*2];
assign pfifo3_wr_pd = unpack_out_pd[AM_DW*3+AM_DW-1:AM_DW*3];

#ifdef NVDLA_SDP_DMAIF_FIX
assign pfifo0_wr_pvld = cmd2dat_spt_pvld & cmd2dat_spt_primary & lat_rd_mask0_vld & pfifo1_wr_prdy & (!lat_ecc_rd_mask[1] || (pfifo2_wr_prdy & pfifo3_wr_prdy));
assign pfifo1_wr_pvld = cmd2dat_spt_pvld & cmd2dat_spt_primary & lat_rd_mask0_vld & pfifo0_wr_prdy & (!lat_ecc_rd_mask[1] || (pfifo2_wr_prdy & pfifo3_wr_prdy));
assign pfifo2_wr_pvld = cmd2dat_spt_pvld & cmd2dat_spt_primary & lat_rd_mask1_vld & pfifo3_wr_prdy & (!lat_ecc_rd_mask[0] || (pfifo0_wr_prdy & pfifo1_wr_prdy));
assign pfifo3_wr_pvld = cmd2dat_spt_pvld & cmd2dat_spt_primary & lat_rd_mask1_vld & pfifo2_wr_prdy & (!lat_ecc_rd_mask[0] || (pfifo0_wr_prdy & pfifo1_wr_prdy));
#else
assign pfifo_wr_rdy = ~(pfifo_wr_mask[0] & ~pfifo0_wr_prdy |pfifo_wr_mask[1] & ~pfifo1_wr_prdy | pfifo_wr_mask[2] & ~pfifo2_wr_prdy | pfifo_wr_mask[3] & ~pfifo3_wr_prdy );
assign pfifo0_wr_pvld = pfifo_wr_vld & pfifo_wr_mask[0] & ~(pfifo_wr_mask[1] & ~pfifo1_wr_prdy | pfifo_wr_mask[2] & ~pfifo2_wr_prdy | pfifo_wr_mask[3] & ~pfifo3_wr_prdy );
assign pfifo1_wr_pvld = pfifo_wr_vld & pfifo_wr_mask[1] & ~(pfifo_wr_mask[0] & ~pfifo0_wr_prdy | pfifo_wr_mask[2] & ~pfifo2_wr_prdy | pfifo_wr_mask[3] & ~pfifo3_wr_prdy );
assign pfifo2_wr_pvld = pfifo_wr_vld & pfifo_wr_mask[2] & ~(pfifo_wr_mask[0] & ~pfifo0_wr_prdy | pfifo_wr_mask[1] & ~pfifo1_wr_prdy | pfifo_wr_mask[3] & ~pfifo3_wr_prdy );
assign pfifo3_wr_pvld = pfifo_wr_vld & pfifo_wr_mask[3] & ~(pfifo_wr_mask[0] & ~pfifo0_wr_prdy | pfifo_wr_mask[1] & ~pfifo1_wr_prdy | pfifo_wr_mask[2] & ~pfifo2_wr_prdy );
#endif

#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
assign sfifo0_wr_pvld = cmd2dat_spt_pvld & (!cmd2dat_spt_primary) & lat_rd_mask0_vld & (!lat_ecc_rd_mask[1] || (sfifo1_wr_prdy ));
assign sfifo1_wr_pvld = cmd2dat_spt_pvld & (!cmd2dat_spt_primary) & lat_rd_mask1_vld & (!lat_ecc_rd_mask[1] || (sfifo0_wr_prdy ));
assign sfifo0_wr_pd   = lat_ecc_rd_data[AM_DW2*0+AM_DW2-1:AM_DW2*0];
assign sfifo1_wr_pd   = lat_ecc_rd_data[AM_DW2*1+AM_DW2-1:AM_DW2*1];
#endif

//==================================
// FIFO INSTANCE
NV_NVDLA_SDP_MRDMA_EG_pfifo u_pfifo0 (
   .nvdla_core_clk  (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)      //|< i
  ,.pfifo_wr_prdy   (pfifo0_wr_prdy)       //|> w
  ,.pfifo_wr_pvld   (pfifo0_wr_pvld)       //|< w
  ,.pfifo_wr_pd     (pfifo0_wr_pd[AM_DW-1:0])  //|< w
  ,.pfifo_rd_prdy   (pfifo0_rd_prdy)       //|< i
  ,.pfifo_rd_pvld   (pfifo0_rd_pvld)       //|> o
  ,.pfifo_rd_pd     (pfifo0_rd_pd[AM_DW-1:0])  //|> o
  );

NV_NVDLA_SDP_MRDMA_EG_pfifo u_pfifo1 (
   .nvdla_core_clk  (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)      //|< i
  ,.pfifo_wr_prdy   (pfifo1_wr_prdy)       //|> w
  ,.pfifo_wr_pvld   (pfifo1_wr_pvld)       //|< w
  ,.pfifo_wr_pd     (pfifo1_wr_pd[AM_DW-1:0])  //|< w
  ,.pfifo_rd_prdy   (pfifo1_rd_prdy)       //|< i
  ,.pfifo_rd_pvld   (pfifo1_rd_pvld)       //|> o
  ,.pfifo_rd_pd     (pfifo1_rd_pd[AM_DW-1:0])  //|> o
  );

NV_NVDLA_SDP_MRDMA_EG_pfifo u_pfifo2 (
   .nvdla_core_clk  (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)      //|< i
  ,.pfifo_wr_prdy   (pfifo2_wr_prdy)       //|> w
  ,.pfifo_wr_pvld   (pfifo2_wr_pvld)       //|< w
  ,.pfifo_wr_pd     (pfifo2_wr_pd[AM_DW-1:0])  //|< w
  ,.pfifo_rd_prdy   (pfifo2_rd_prdy)       //|< i
  ,.pfifo_rd_pvld   (pfifo2_rd_pvld)       //|> o
  ,.pfifo_rd_pd     (pfifo2_rd_pd[AM_DW-1:0])  //|> o
  );

NV_NVDLA_SDP_MRDMA_EG_pfifo u_pfifo3 (
   .nvdla_core_clk  (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)      //|< i
  ,.pfifo_wr_prdy   (pfifo3_wr_prdy)       //|> w
  ,.pfifo_wr_pvld   (pfifo3_wr_pvld)       //|< w
  ,.pfifo_wr_pd     (pfifo3_wr_pd[AM_DW-1:0])  //|< w
  ,.pfifo_rd_prdy   (pfifo3_rd_prdy)       //|< i
  ,.pfifo_rd_pvld   (pfifo3_rd_pvld)       //|> o
  ,.pfifo_rd_pd     (pfifo3_rd_pd[AM_DW-1:0])  //|> o
  );


#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
NV_NVDLA_SDP_MRDMA_EG_sfifo u_sfifo0 (
   .nvdla_core_clk  (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)      //|< i
  ,.sfifo_wr_prdy   (sfifo0_wr_prdy)       //|> w
  ,.sfifo_wr_pvld   (sfifo0_wr_pvld)       //|< w
  ,.sfifo_wr_pd     (sfifo0_wr_pd[AM_DW2-1:0])  //|< w
  ,.sfifo_rd_prdy   (sfifo0_rd_prdy)       //|< i
  ,.sfifo_rd_pvld   (sfifo0_rd_pvld)       //|> o
  ,.sfifo_rd_pd     (sfifo0_rd_pd[AM_DW2-1:0])  //|> o
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])  //|< i
  );
NV_NVDLA_SDP_MRDMA_EG_sfifo u_sfifo1 (
   .nvdla_core_clk  (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)      //|< i
  ,.sfifo_wr_prdy   (sfifo1_wr_prdy)       //|> w
  ,.sfifo_wr_pvld   (sfifo1_wr_pvld)       //|< w
  ,.sfifo_wr_pd     (sfifo1_wr_pd[AM_DW2-1:0])  //|< w
  ,.sfifo_rd_prdy   (sfifo1_rd_prdy)       //|< i
  ,.sfifo_rd_pvld   (sfifo1_rd_pvld)       //|> o
  ,.sfifo_rd_pd     (sfifo1_rd_pd[AM_DW2-1:0])  //|> o
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])  //|< i
  );
#endif


endmodule // NV_NVDLA_SDP_MRDMA_EG_din



module NV_NVDLA_SDP_MRDMA_EG_pfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , pfifo_wr_prdy
    , pfifo_wr_pvld
    , pfifo_wr_pd
    , pfifo_rd_prdy
    , pfifo_rd_pvld
    , pfifo_rd_pd
    );

input         nvdla_core_clk;
input         nvdla_core_rstn;
output        pfifo_wr_prdy;
input         pfifo_wr_pvld;
input  [AM_DW-1:0] pfifo_wr_pd;
input         pfifo_rd_prdy;
output        pfifo_rd_pvld;
output [AM_DW-1:0] pfifo_rd_pd;


//: my $dw = AM_DW;
//: &eperl::pipe("-is -wid $dw -do pfifo_rd_pd -vo pfifo_rd_pvld -ri pfifo_rd_prdy -di pfifo_wr_pd -vi pfifo_wr_pvld -ro pfifo_wr_prdy");


endmodule // NV_NVDLA_SDP_MRDMA_EG_pfifo




`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"

#if (NVDLA_MEMIF_WIDTH+NVDLA_DMA_MASK_BIT == 514)

module NV_NVDLA_SDP_MRDMA_EG_lat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , lat_wr_prdy
    , lat_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , lat_wr_pause
`endif
    , lat_wr_pd
    , lat_rd_prdy
    , lat_rd_pvld
    , lat_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        lat_wr_prdy;
input         lat_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         lat_wr_pause;
`endif
input  [513:0] lat_wr_pd;
input         lat_rd_prdy;
output        lat_rd_pvld;
output [513:0] lat_rd_pd;
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
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        lat_wr_busy_int;		        	// copy for internal use
assign     lat_wr_prdy = !lat_wr_busy_int;
assign       wr_reserving = lat_wr_pvld && !lat_wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [6:0] lat_wr_count;			// write-side count

wire [6:0] wr_count_next_wr_popping = wr_reserving ? lat_wr_count : (lat_wr_count - 1'd1); // spyglass disable W164a W484
wire [6:0] wr_count_next_no_wr_popping = wr_reserving ? (lat_wr_count + 1'd1) : lat_wr_count; // spyglass disable W164a W484
wire [6:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_80 = ( wr_count_next_no_wr_popping == 7'd80 );
wire wr_count_next_is_80 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_80;
wire [6:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [6:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_80 || // busy next cycle?
                          (wr_limit_reg != 7'd0 &&      // check lat_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || lat_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_80 || // busy next cycle?
                          (wr_limit_reg != 7'd0 &&      // check lat_wr_limit if != 0
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
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_busy_int <=  1'b0;
        lat_wr_count <=  7'd0;
    end else begin
	lat_wr_busy_int <=  lat_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    lat_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            lat_wr_count <=  {7{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as lat_wr_pvld

//
// RAM
//

reg  [6:0] lat_wr_adr;			// current write address
wire [6:0] lat_rd_adr_p;		// read address to use for ram
wire [513:0] lat_rd_pd_p;		// read data directly out of ram

wire rd_enable;

wire ore;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsp_80x514 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( lat_wr_adr )
    , .we        ( wr_pushing )
    , .di        ( lat_wr_pd )
    , .ra        ( lat_rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( lat_rd_pd_p )
    , .ore        ( ore )
    );
// next lat_wr_adr if wr_pushing=1
wire [6:0] wr_adr_next = (lat_wr_adr == 7'd79) ? 7'd0 : (lat_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_adr <=  7'd0;
    end else begin
        if ( wr_pushing ) begin
            lat_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            lat_wr_adr   <=  {7{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [6:0] lat_rd_adr;		// current read address
// next    read address
wire [6:0] rd_adr_next = (lat_rd_adr == 7'd79) ? 7'd0 : (lat_rd_adr + 1'd1);   // spyglass disable W484
assign         lat_rd_adr_p = rd_popping ? rd_adr_next : lat_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_adr <=  7'd0;
    end else begin
        if ( rd_popping ) begin
	    lat_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            lat_rd_adr <=  {7{`x_or_0}};
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

reg        lat_rd_pvld_p; 		// data out of fifo is valid

reg        lat_rd_pvld_int;			// internal copy of lat_rd_pvld
assign     lat_rd_pvld = lat_rd_pvld_int;
assign     rd_popping = lat_rd_pvld_p && !(lat_rd_pvld_int && !lat_rd_prdy);

reg  [6:0] lat_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [6:0] rd_count_p_next_rd_popping = rd_pushing ? lat_rd_count_p : 
                                                                (lat_rd_count_p - 1'd1);
wire [6:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (lat_rd_count_p + 1'd1) : 
                                                                    lat_rd_count_p;
// spyglass enable_block W164a W484
wire [6:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~lat_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_count_p <=  7'd0;
        lat_rd_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_count_p <=  {7{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (lat_rd_pvld_p || (lat_rd_pvld_int && !lat_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_pvld_int <=  1'b0;
    end else begin
        lat_rd_pvld_int <=  rd_req_next;
    end
end
assign lat_rd_pd = lat_rd_pd_p;
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (lat_wr_pvld && !lat_wr_busy_int) || (lat_wr_busy_int != lat_wr_busy_next)) || (rd_pushing || rd_popping || (lat_rd_pvld_int && lat_rd_prdy) || wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_lat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_lat_fifo_wr_limit : 7'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_wr_limit=%d", wr_limit_override_value);
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
    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
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
    if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( lat_wr_pvld && !(!lat_wr_prdy)
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
    , .max      ( {25'd0, (wr_limit_reg == 7'd0) ? 7'd80 : wr_limit_reg} )
    , .curr	( {25'd0, lat_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_MRDMA_EG_lat_fifo") true
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


endmodule // NV_NVDLA_SDP_MRDMA_EG_lat_fifo


#elif (NVDLA_MEMIF_WIDTH+NVDLA_DMA_MASK_BIT == 65)


module NV_NVDLA_SDP_MRDMA_EG_lat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , lat_wr_prdy
    , lat_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , lat_wr_pause
`endif
    , lat_wr_pd
    , lat_rd_prdy
    , lat_rd_pvld
    , lat_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        lat_wr_prdy;
input         lat_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         lat_wr_pause;
`endif
input  [64:0] lat_wr_pd;
input         lat_rd_prdy;
output        lat_rd_pvld;
output [64:0] lat_rd_pd;
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
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        lat_wr_busy_int;		        	// copy for internal use
assign     lat_wr_prdy = !lat_wr_busy_int;
assign       wr_reserving = lat_wr_pvld && !lat_wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [6:0] lat_wr_count;			// write-side count

wire [6:0] wr_count_next_wr_popping = wr_reserving ? lat_wr_count : (lat_wr_count - 1'd1); // spyglass disable W164a W484
wire [6:0] wr_count_next_no_wr_popping = wr_reserving ? (lat_wr_count + 1'd1) : lat_wr_count; // spyglass disable W164a W484
wire [6:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_80 = ( wr_count_next_no_wr_popping == 7'd80 );
wire wr_count_next_is_80 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_80;
wire [6:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [6:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_80 || // busy next cycle?
                          (wr_limit_reg != 7'd0 &&      // check lat_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || lat_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_80 || // busy next cycle?
                          (wr_limit_reg != 7'd0 &&      // check lat_wr_limit if != 0
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
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_busy_int <=  1'b0;
        lat_wr_count <=  7'd0;
    end else begin
	lat_wr_busy_int <=  lat_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    lat_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            lat_wr_count <=  {7{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as lat_wr_pvld

//
// RAM
//

reg  [6:0] lat_wr_adr;			// current write address
wire [6:0] lat_rd_adr_p;		// read address to use for ram
wire [64:0] lat_rd_pd_p;		// read data directly out of ram

wire rd_enable;

wire ore;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsp_80x65 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( lat_wr_adr )
    , .we        ( wr_pushing )
    , .di        ( lat_wr_pd )
    , .ra        ( lat_rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( lat_rd_pd_p )
    , .ore        ( ore )
    );
// next lat_wr_adr if wr_pushing=1
wire [6:0] wr_adr_next = (lat_wr_adr == 7'd79) ? 7'd0 : (lat_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_adr <=  7'd0;
    end else begin
        if ( wr_pushing ) begin
            lat_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            lat_wr_adr   <=  {7{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [6:0] lat_rd_adr;		// current read address
// next    read address
wire [6:0] rd_adr_next = (lat_rd_adr == 7'd79) ? 7'd0 : (lat_rd_adr + 1'd1);   // spyglass disable W484
assign         lat_rd_adr_p = rd_popping ? rd_adr_next : lat_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_adr <=  7'd0;
    end else begin
        if ( rd_popping ) begin
	    lat_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            lat_rd_adr <=  {7{`x_or_0}};
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

reg        lat_rd_pvld_p; 		// data out of fifo is valid

reg        lat_rd_pvld_int;			// internal copy of lat_rd_pvld
assign     lat_rd_pvld = lat_rd_pvld_int;
assign     rd_popping = lat_rd_pvld_p && !(lat_rd_pvld_int && !lat_rd_prdy);

reg  [6:0] lat_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [6:0] rd_count_p_next_rd_popping = rd_pushing ? lat_rd_count_p : 
                                                                (lat_rd_count_p - 1'd1);
wire [6:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (lat_rd_count_p + 1'd1) : 
                                                                    lat_rd_count_p;
// spyglass enable_block W164a W484
wire [6:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~lat_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_count_p <=  7'd0;
        lat_rd_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_count_p <=  {7{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (lat_rd_pvld_p || (lat_rd_pvld_int && !lat_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_pvld_int <=  1'b0;
    end else begin
        lat_rd_pvld_int <=  rd_req_next;
    end
end
assign lat_rd_pd = lat_rd_pd_p;
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (lat_wr_pvld && !lat_wr_busy_int) || (lat_wr_busy_int != lat_wr_busy_next)) || (rd_pushing || rd_popping || (lat_rd_pvld_int && lat_rd_prdy) || wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_lat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_lat_fifo_wr_limit : 7'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_wr_limit=%d", wr_limit_override_value);
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
    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
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
    if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( lat_wr_pvld && !(!lat_wr_prdy)
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
    , .max      ( {25'd0, (wr_limit_reg == 7'd0) ? 7'd80 : wr_limit_reg} )
    , .curr	( {25'd0, lat_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_MRDMA_EG_lat_fifo") true
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


endmodule // NV_NVDLA_SDP_MRDMA_EG_lat_fifo






#endif




#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
module NV_NVDLA_SDP_MRDMA_EG_sfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , sfifo_wr_prdy
    , sfifo_wr_pvld
    , sfifo_wr_pd
    , sfifo_rd_prdy
    , sfifo_rd_pvld
    , sfifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        sfifo_wr_prdy;
input         sfifo_wr_pvld;
input  [255:0] sfifo_wr_pd;
input         sfifo_rd_prdy;
output        sfifo_rd_pvld;
output [255:0] sfifo_rd_pd;
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
reg        sfifo_wr_busy_int;		        	// copy for internal use
assign     sfifo_wr_prdy = !sfifo_wr_busy_int;
assign       wr_reserving = sfifo_wr_pvld && !sfifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg        sfifo_wr_count;			// write-side count

wire       wr_count_next_wr_popping = wr_reserving ? sfifo_wr_count : (sfifo_wr_count - 1'd1); // spyglass disable W164a W484
wire       wr_count_next_no_wr_popping = wr_reserving ? (sfifo_wr_count + 1'd1) : sfifo_wr_count; // spyglass disable W164a W484
wire       wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_1 = ( wr_count_next_no_wr_popping == 1'd1 );
wire wr_count_next_is_1 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_1;
wire       wr_limit_muxed;  // muxed with simulation/emulation overrides
wire       wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       sfifo_wr_busy_next = wr_count_next_is_1 || // busy next cycle?
                          (wr_limit_reg != 1'd0 &&      // check sfifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        sfifo_wr_busy_int <=  1'b0;
        sfifo_wr_count <=  1'd0;
    end else begin
	sfifo_wr_busy_int <=  sfifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    sfifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            sfifo_wr_count <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as sfifo_wr_pvld

//
// RAM
//

wire rd_popping;

wire ram_we = wr_pushing && (sfifo_wr_count > 1'd0 || !rd_popping);   // note: write occurs next cycle
wire [255:0] sfifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_MRDMA_EG_sfifo_flopram_rwsa_1x256 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( sfifo_wr_pd )
    , .we        ( ram_we )
    , .ra        ( (sfifo_wr_count == 0) ? 1'd1 : 1'b0 )
    , .dout        ( sfifo_rd_pd_p )
    );


//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       sfifo_rd_pvld_p; 		// data out of fifo is valid

reg        sfifo_rd_pvld_int;	// internal copy of sfifo_rd_pvld
assign     sfifo_rd_pvld = sfifo_rd_pvld_int;
assign     rd_popping = sfifo_rd_pvld_p && !(sfifo_rd_pvld_int && !sfifo_rd_prdy);

reg        sfifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire       rd_count_p_next_rd_popping = rd_pushing ? sfifo_rd_count_p : 
                                                                (sfifo_rd_count_p - 1'd1);
wire       rd_count_p_next_no_rd_popping =  rd_pushing ? (sfifo_rd_count_p + 1'd1) : 
                                                                    sfifo_rd_count_p;
// spyglass enable_block W164a W484
wire       rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     sfifo_rd_pvld_p = sfifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        sfifo_rd_count_p <=  1'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    sfifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            sfifo_rd_count_p <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [255:0]  sfifo_rd_pd;         // output data register
wire        rd_req_next = (sfifo_rd_pvld_p || (sfifo_rd_pvld_int && !sfifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        sfifo_rd_pvld_int <=  1'b0;
    end else begin
        sfifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        sfifo_rd_pd <=  sfifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        sfifo_rd_pd <=  {256{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (sfifo_wr_pvld && !sfifo_wr_busy_int) || (sfifo_wr_busy_int != sfifo_wr_busy_next)) || (rd_pushing || rd_popping || (sfifo_rd_pvld_int && sfifo_rd_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_sfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_MRDMA_EG_sfifo_wr_limit : 1'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_MRDMA_EG_sfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_MRDMA_EG_sfifo_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {31'd0, (wr_limit_reg == 1'd0) ? 1'd1 : wr_limit_reg} )
    , .curr	( {31'd0, sfifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_MRDMA_EG_sfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_MRDMA_EG_sfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_MRDMA_EG_sfifo_flopram_rwsa_1x256 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [255:0] di;
input  we;
input  [0:0] ra;
output [255:0] dout;

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

reg [255:0] ram_ff0;

always @( posedge clk ) begin
    if ( we ) begin
	ram_ff0 <=  di;
    end
end

reg [255:0] dout;

always @(*) begin
    case( ra ) 
    1'd0:       dout = ram_ff0;
    1'd1:       dout = di;
    //VCS coverage off
    default:    dout = {256{`x_or_0}};
    //VCS coverage on
    endcase
end

endmodule // NV_NVDLA_SDP_MRDMA_EG_sfifo_flopram_rwsa_1x256

#endif
