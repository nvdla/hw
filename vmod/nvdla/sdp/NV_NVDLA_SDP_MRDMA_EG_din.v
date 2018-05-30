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

//: my $depth = NVDLA_VMOD_SDP_MRDMA_LATENCY_FIFO_DEPTH; 
//: my $width = NVDLA_DMA_RD_RSP;
//: print "NV_NVDLA_SDP_MRDMA_EG_lat_fifo_${depth}x${width}  u_lat_fifo (\n";
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



